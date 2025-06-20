import 'package:flutter/foundation.dart';
import '../core/services/firebase_service.dart';
import '../models/document_model.dart';

/// Diagnostic tool for file deletion issues
class DeletionDiagnostic {
  final FirebaseService _firebaseService = FirebaseService.instance;

  /// Run comprehensive diagnostic for a specific document ID
  Future<Map<String, dynamic>> runDiagnostic(String documentId) async {
    final results = <String, dynamic>{
      'documentId': documentId,
      'timestamp': DateTime.now().toIso8601String(),
      'firestoreStatus': {},
      'storageStatus': {},
      'recommendations': <String>[],
    };

    try {
      debugPrint('🔍 Starting deletion diagnostic for: $documentId');

      // 1. Check Firestore
      results['firestoreStatus'] = await _checkFirestore(documentId);

      // 2. Check Firebase Storage
      results['storageStatus'] = await _checkStorage(documentId);

      // 3. Generate recommendations
      results['recommendations'] = _generateRecommendations(results);

      debugPrint('✅ Diagnostic completed for: $documentId');
      return results;
    } catch (e) {
      debugPrint('❌ Diagnostic failed: $e');
      results['error'] = e.toString();
      return results;
    }
  }

  /// Check Firestore for document existence and metadata
  Future<Map<String, dynamic>> _checkFirestore(String documentId) async {
    final firestoreStatus = <String, dynamic>{
      'exists': false,
      'document': null,
      'error': null,
    };

    try {
      // Direct lookup by ID
      final docSnapshot = await _firebaseService.documentsCollection
          .doc(documentId)
          .get();

      if (docSnapshot.exists) {
        firestoreStatus['exists'] = true;
        firestoreStatus['document'] = docSnapshot.data();
        debugPrint('✅ Document found in Firestore by ID');
      } else {
        debugPrint('❌ Document not found in Firestore by ID');

        // Try alternative searches
        final alternatives = await _searchFirestoreAlternatives(documentId);
        firestoreStatus['alternat ives'] = alternatives;
      }
    } catch (e) {
      firestoreStatus['error'] = e.toString();
      debugPrint('❌ Error checking Firestore: $e');
    }

    return firestoreStatus;
  }

  /// Search for document using alternative methods
  Future<List<Map<String, dynamic>>> _searchFirestoreAlternatives(
    String documentId,
  ) async {
    final alternatives = <Map<String, dynamic>>[];

    try {
      // Search by fileName containing documentId
      final fileNameQuery = await _firebaseService.documentsCollection
          .where('fileName', isGreaterThanOrEqualTo: documentId)
          .where('fileName', isLessThanOrEqualTo: '$documentId\uf8ff')
          .get();

      for (final doc in fileNameQuery.docs) {
        alternatives.add({
          'method': 'fileName_search',
          'id': doc.id,
          'data': doc.data(),
        });
      }

      // Search by filePath containing documentId
      final filePathQuery = await _firebaseService.documentsCollection
          .where('filePath', isGreaterThanOrEqualTo: documentId)
          .where('filePath', isLessThanOrEqualTo: '$documentId\uf8ff')
          .get();

      for (final doc in filePathQuery.docs) {
        alternatives.add({
          'method': 'filePath_search',
          'id': doc.id,
          'data': doc.data(),
        });
      }

      debugPrint(
        '🔍 Found ${alternatives.length} alternative matches in Firestore',
      );
    } catch (e) {
      debugPrint('❌ Error in alternative Firestore search: $e');
    }

    return alternatives;
  }

  /// Check Firebase Storage for file existence
  Future<Map<String, dynamic>> _checkStorage(String documentId) async {
    final storageStatus = <String, dynamic>{
      'foundFiles': <Map<String, dynamic>>[],
      'searchedPaths': <String>[],
      'error': null,
    };

    try {
      // Search in main documents folder
      await _searchStorageFolder('documents', documentId, storageStatus);

      // Search in user-specific folders
      await _searchUserFolders(documentId, storageStatus);

      debugPrint(
        '🔍 Storage search completed. Found ${storageStatus['foundFiles'].length} files',
      );
    } catch (e) {
      storageStatus['error'] = e.toString();
      debugPrint('❌ Error checking storage: $e');
    }

    return storageStatus;
  }

  /// Search storage folder for matching files
  Future<void> _searchStorageFolder(
    String folderPath,
    String documentId,
    Map<String, dynamic> storageStatus,
  ) async {
    try {
      final folderRef = _firebaseService.storage.ref().child(folderPath);
      final listResult = await folderRef.listAll();

      // Check files in this folder
      for (final item in listResult.items) {
        storageStatus['searchedPaths'].add(item.fullPath);

        if (_isMatchingFile(documentId, item.name, item.fullPath)) {
          try {
            final metadata = await item.getMetadata();
            storageStatus['foundFiles'].add({
              'path': item.fullPath,
              'name': item.name,
              'size': metadata.size,
              'contentType': metadata.contentType,
              'timeCreated': metadata.timeCreated?.toIso8601String(),
              'uploadedBy': metadata.customMetadata?['uploadedBy'],
            });
            debugPrint('✅ Found matching file: ${item.fullPath}');
          } catch (e) {
            debugPrint('⚠️ Error getting metadata for ${item.fullPath}: $e');
          }
        }
      }

      // Recursively search subfolders
      for (final prefix in listResult.prefixes) {
        await _searchStorageFolder(prefix.fullPath, documentId, storageStatus);
      }
    } catch (e) {
      debugPrint('⚠️ Error searching folder $folderPath: $e');
    }
  }

  /// Search user-specific folders
  Future<void> _searchUserFolders(
    String documentId,
    Map<String, dynamic> storageStatus,
  ) async {
    try {
      final documentsRef = _firebaseService.storage.ref().child('documents');
      final listResult = await documentsRef.listAll();

      // Check each user folder
      for (final prefix in listResult.prefixes) {
        await _searchStorageFolder(prefix.fullPath, documentId, storageStatus);
      }
    } catch (e) {
      debugPrint('⚠️ Error searching user folders: $e');
    }
  }

  /// Check if a file matches the document ID
  bool _isMatchingFile(String documentId, String fileName, String fullPath) {
    // Check various matching patterns
    final fileNameWithoutExt = fileName.split('.').first;

    return fileNameWithoutExt == documentId ||
        fileName.contains(documentId) ||
        fullPath.contains(documentId);
  }

  /// Generate recommendations based on diagnostic results
  List<String> _generateRecommendations(Map<String, dynamic> results) {
    final recommendations = <String>[];
    final firestoreStatus = results['firestoreStatus'] as Map<String, dynamic>;
    final storageStatus = results['storageStatus'] as Map<String, dynamic>;

    // Firestore recommendations
    if (!(firestoreStatus['exists'] as bool)) {
      recommendations.add(
        'Document not found in Firestore - may be a cache synchronization issue',
      );

      final alternatives =
          firestoreStatus['alternatives'] as List<Map<String, dynamic>>?;
      if (alternatives != null && alternatives.isNotEmpty) {
        recommendations.add(
          'Found ${alternatives.length} similar documents in Firestore - check for ID mismatch',
        );
      }
    }

    // Storage recommendations
    final foundFiles =
        storageStatus['foundFiles'] as List<Map<String, dynamic>>;
    if (foundFiles.isEmpty) {
      recommendations.add('No matching files found in Firebase Storage');
      recommendations.add('File may have been already deleted or moved');
    } else if (foundFiles.length == 1) {
      final file = foundFiles.first;
      recommendations.add('Found 1 matching file at: ${file['path']}');
      recommendations.add('Use this path for deletion: ${file['path']}');
    } else {
      recommendations.add(
        'Found ${foundFiles.length} matching files - may indicate duplicates',
      );
      for (final file in foundFiles) {
        recommendations.add('File found at: ${file['path']}');
      }
    }

    // General recommendations
    if (firestoreStatus['exists'] as bool && foundFiles.isNotEmpty) {
      recommendations.add(
        'Both Firestore and Storage have the file - normal deletion should work',
      );
    } else if (firestoreStatus['exists'] as bool && foundFiles.isEmpty) {
      recommendations.add(
        'Firestore has metadata but Storage file is missing - orphaned metadata',
      );
      recommendations.add('Delete only from Firestore to clean up');
    } else if (!(firestoreStatus['exists'] as bool) && foundFiles.isNotEmpty) {
      recommendations.add(
        'Storage has file but Firestore metadata is missing - orphaned file',
      );
      recommendations.add('Delete only from Storage to clean up');
    }

    return recommendations;
  }
}
