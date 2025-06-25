import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../core/services/firebase_service.dart';

/// Diagnostic utility to identify and fix document synchronization issues
/// This helps resolve cases where documents exist in UI but not in Firestore
class DocumentSyncDiagnostic {
  static DocumentSyncDiagnostic? _instance;
  static DocumentSyncDiagnostic get instance =>
      _instance ??= DocumentSyncDiagnostic._();

  DocumentSyncDiagnostic._();

  final FirebaseService _firebaseService = FirebaseService.instance;

  /// Run comprehensive diagnostic on document synchronization
  Future<Map<String, dynamic>> runDiagnostic() async {
    debugPrint('🔍 Starting document synchronization diagnostic...');

    final results = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'firestoreDocuments': <String>[],
      'storageFiles': <String>[],
      'orphanedFirestoreRecords': <String>[],
      'orphanedStorageFiles': <String>[],
      'syncIssues': <String>[],
      'recommendations': <String>[],
    };

    try {
      // Step 1: Get all documents from Firestore
      debugPrint('📊 Fetching documents from Firestore...');
      final firestoreSnapshot = await _firebaseService.documentsCollection
          .where('isActive', isEqualTo: true)
          .get();

      final firestoreDocuments = <String, Map<String, dynamic>>{};
      for (final doc in firestoreSnapshot.docs) {
        firestoreDocuments[doc.id] = doc.data() as Map<String, dynamic>;
        results['firestoreDocuments'].add(doc.id);
      }

      debugPrint('✅ Found ${firestoreDocuments.length} documents in Firestore');

      // Step 2: Get all files from Firebase Storage
      debugPrint('📁 Fetching files from Firebase Storage...');
      final storageFiles = <String, FullMetadata>{};

      try {
        final listResult = await _firebaseService.storage
            .ref()
            .child('documents')
            .listAll();

        for (final item in listResult.items) {
          try {
            final metadata = await item.getMetadata();
            storageFiles[item.fullPath] = metadata;
            results['storageFiles'].add(item.fullPath);
          } catch (e) {
            debugPrint('⚠️ Failed to get metadata for ${item.fullPath}: $e');
          }
        }
      } catch (e) {
        debugPrint('❌ Failed to list storage files: $e');
        results['syncIssues'].add('Failed to access Firebase Storage: $e');
      }

      debugPrint('✅ Found ${storageFiles.length} files in Firebase Storage');

      // Step 3: Find orphaned Firestore records (documents without storage files)
      debugPrint('🔍 Checking for orphaned Firestore records...');
      for (final entry in firestoreDocuments.entries) {
        final documentId = entry.key;
        final documentData = entry.value;
        final filePath = documentData['filePath'] as String?;

        if (filePath != null && filePath.isNotEmpty) {
          if (!storageFiles.containsKey(filePath)) {
            results['orphanedFirestoreRecords'].add(documentId);
            results['syncIssues'].add(
              'Document $documentId references missing storage file: $filePath',
            );
          }
        } else {
          results['syncIssues'].add(
            'Document $documentId has empty or missing filePath',
          );
        }
      }

      // Step 4: Find orphaned storage files (files without Firestore records)
      debugPrint('🔍 Checking for orphaned storage files...');
      final firestoreFilePaths = firestoreDocuments.values
          .map((doc) => doc['filePath'] as String?)
          .where((path) => path != null && path.isNotEmpty)
          .toSet();

      for (final filePath in storageFiles.keys) {
        if (!firestoreFilePaths.contains(filePath)) {
          results['orphanedStorageFiles'].add(filePath);
          results['syncIssues'].add(
            'Storage file has no corresponding Firestore record: $filePath',
          );
        }
      }

      // Step 5: Generate recommendations
      _generateRecommendations(results);

      debugPrint('✅ Diagnostic completed successfully');
      debugPrint('📊 Summary:');
      debugPrint(
        '   - Firestore documents: ${results['firestoreDocuments'].length}',
      );
      debugPrint('   - Storage files: ${results['storageFiles'].length}');
      debugPrint(
        '   - Orphaned Firestore records: ${results['orphanedFirestoreRecords'].length}',
      );
      debugPrint(
        '   - Orphaned storage files: ${results['orphanedStorageFiles'].length}',
      );
      debugPrint('   - Sync issues found: ${results['syncIssues'].length}');
    } catch (e) {
      debugPrint('❌ Diagnostic failed: $e');
      results['syncIssues'].add('Diagnostic failed: $e');
    }

    return results;
  }

  /// Generate recommendations based on diagnostic results
  void _generateRecommendations(Map<String, dynamic> results) {
    final recommendations = results['recommendations'] as List<String>;

    if ((results['orphanedFirestoreRecords'] as List).isNotEmpty) {
      recommendations.add(
        'Clean up orphaned Firestore records that reference missing storage files',
      );
    }

    if ((results['orphanedStorageFiles'] as List).isNotEmpty) {
      recommendations.add(
        'Create Firestore metadata records for orphaned storage files or delete unused files',
      );
    }

    if ((results['syncIssues'] as List).isNotEmpty) {
      recommendations.add(
        'Run data synchronization to fix inconsistencies between Firestore and Storage',
      );
    }

    if ((results['syncIssues'] as List).isEmpty) {
      recommendations.add(
        'No synchronization issues detected - system is healthy',
      );
    }
  }

  /// Fix specific document ID by checking both Firestore and Storage
  Future<Map<String, dynamic>> diagnoseSpecificDocument(
    String documentId,
  ) async {
    debugPrint('🔍 Diagnosing specific document: $documentId');

    final result = <String, dynamic>{
      'documentId': documentId,
      'existsInFirestore': false,
      'existsInStorage': false,
      'firestoreData': null,
      'storageMetadata': null,
      'issues': <String>[],
      'recommendations': <String>[],
    };

    try {
      // Check Firestore
      final firestoreDoc = await _firebaseService.documentsCollection
          .doc(documentId)
          .get();

      if (firestoreDoc.exists) {
        result['existsInFirestore'] = true;
        result['firestoreData'] = firestoreDoc.data();
        debugPrint('✅ Document found in Firestore');

        // Check if referenced storage file exists
        final data = firestoreDoc.data() as Map<String, dynamic>;
        final filePath = data['filePath'] as String?;

        if (filePath != null && filePath.isNotEmpty) {
          try {
            final storageRef = _firebaseService.storage.ref().child(filePath);
            final metadata = await storageRef.getMetadata();
            result['existsInStorage'] = true;
            result['storageMetadata'] = {
              'name': metadata.name,
              'size': metadata.size,
              'contentType': metadata.contentType,
              'timeCreated': metadata.timeCreated?.toIso8601String(),
            };
            debugPrint('✅ Referenced storage file found');
          } catch (e) {
            result['issues'].add(
              'Referenced storage file not found: $filePath',
            );
            debugPrint('❌ Referenced storage file not found: $filePath');
          }
        } else {
          result['issues'].add('Document has empty or missing filePath');
        }
      } else {
        result['issues'].add('Document not found in Firestore');
        debugPrint('❌ Document not found in Firestore');

        // Try to find in storage by common patterns
        final storagePatterns = [
          'documents/$documentId',
          'documents/$documentId.pdf',
          'documents/$documentId.docx',
          'documents/$documentId.jpg',
          'documents/$documentId.png',
        ];

        for (final pattern in storagePatterns) {
          try {
            final storageRef = _firebaseService.storage.ref().child(pattern);
            final metadata = await storageRef.getMetadata();
            result['existsInStorage'] = true;
            result['storageMetadata'] = {
              'name': metadata.name,
              'size': metadata.size,
              'contentType': metadata.contentType,
              'timeCreated': metadata.timeCreated?.toIso8601String(),
              'fullPath': pattern,
            };
            debugPrint('✅ Found orphaned storage file: $pattern');
            result['issues'].add(
              'Storage file exists but no Firestore record: $pattern',
            );
            break;
          } catch (e) {
            // Continue to next pattern
          }
        }
      }

      // Generate specific recommendations
      if (!result['existsInFirestore'] && !result['existsInStorage']) {
        result['recommendations'].add(
          'Document does not exist anywhere - remove from UI',
        );
      } else if (!result['existsInFirestore'] && result['existsInStorage']) {
        result['recommendations'].add(
          'Create Firestore metadata record for orphaned storage file',
        );
      } else if (result['existsInFirestore'] && !result['existsInStorage']) {
        result['recommendations'].add(
          'Remove orphaned Firestore record or restore missing storage file',
        );
      } else {
        result['recommendations'].add(
          'Document exists in both locations - no action needed',
        );
      }
    } catch (e) {
      result['issues'].add('Diagnostic failed: $e');
      debugPrint('❌ Diagnostic failed for document $documentId: $e');
    }

    return result;
  }

  /// Clean up orphaned Firestore records
  Future<int> cleanupOrphanedFirestoreRecords() async {
    debugPrint('🧹 Starting cleanup of orphaned Firestore records...');

    final diagnostic = await runDiagnostic();
    final orphanedRecords =
        diagnostic['orphanedFirestoreRecords'] as List<String>;

    int cleanedCount = 0;

    for (final documentId in orphanedRecords) {
      try {
        await _firebaseService.documentsCollection.doc(documentId).update({
          'isActive': false,
          'orphanedAt': FieldValue.serverTimestamp(),
        });
        cleanedCount++;
        debugPrint('✅ Marked orphaned record as inactive: $documentId');
      } catch (e) {
        debugPrint('❌ Failed to cleanup record $documentId: $e');
      }
    }

    debugPrint('✅ Cleanup completed: $cleanedCount records processed');
    return cleanedCount;
  }
}
