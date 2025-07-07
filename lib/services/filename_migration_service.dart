import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../utils/filename_utils.dart';

/// Service for filename operations (migration no longer needed)
///
/// This service was previously used for timestamp migration but is now
/// simplified since we removed the timestamp system entirely.
class FilenameMigrationService {
  static final FilenameMigrationService _instance =
      FilenameMigrationService._internal();
  factory FilenameMigrationService() => _instance;
  FilenameMigrationService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Check document status (migration no longer needed)
  ///
  /// Returns a report of document status since timestamp system was removed
  Future<Map<String, dynamic>> checkDocumentStatus() async {
    try {
      debugPrint('🔍 Checking document status...');

      final querySnapshot = await _firestore
          .collection('document-metadata')
          .where('isActive', isEqualTo: true)
          .get();

      int totalDocuments = querySnapshot.docs.length;
      int validDocuments = 0;
      int invalidDocuments = 0;
      List<String> sampleFiles = [];

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final fileName = data['fileName'] as String? ?? '';

        if (FilenameUtils.isValidFileName(fileName)) {
          validDocuments++;
        } else {
          invalidDocuments++;
        }

        if (sampleFiles.length < 5) {
          sampleFiles.add(fileName);
        }
      }

      final report = {
        'totalDocuments': totalDocuments,
        'validDocuments': validDocuments,
        'invalidDocuments': invalidDocuments,
        'migrationNeeded': false, // No longer needed
        'sampleFiles': sampleFiles,
      };

      debugPrint('📊 Document Status Report:');
      debugPrint('   Total Documents: $totalDocuments');
      debugPrint('   Valid Documents: $validDocuments');
      debugPrint('   Invalid Documents: $invalidDocuments');

      return report;
    } catch (e) {
      debugPrint('❌ Failed to check document status: $e');
      return {'error': e.toString(), 'migrationNeeded': false};
    }
  }

  /// Validate all document filenames (migration no longer needed)
  ///
  /// Checks all documents for valid filenames since timestamp system was removed
  Future<Map<String, dynamic>> validateAllDocuments() async {
    try {
      debugPrint('🚀 Starting filename validation...');

      final querySnapshot = await _firestore
          .collection('document-metadata')
          .where('isActive', isEqualTo: true)
          .get();

      int totalProcessed = 0;
      int validFiles = 0;
      int invalidFiles = 0;
      int failures = 0;
      List<String> invalidDocuments = [];

      for (final doc in querySnapshot.docs) {
        try {
          totalProcessed++;
          final data = doc.data();
          final currentFileName = data['fileName'] as String? ?? '';

          if (FilenameUtils.isValidFileName(currentFileName)) {
            validFiles++;
            debugPrint('✓ Valid filename: $currentFileName');
          } else {
            invalidFiles++;
            invalidDocuments.add(doc.id);
            debugPrint('⚠️ Invalid filename: $currentFileName');
          }
        } catch (e) {
          failures++;
          debugPrint('❌ Failed to validate document ${doc.id}: $e');
        }
      }

      final result = {
        'success': true,
        'totalProcessed': totalProcessed,
        'validFiles': validFiles,
        'invalidFiles': invalidFiles,
        'failures': failures,
        'invalidDocuments': invalidDocuments,
      };

      debugPrint('✅ Validation completed:');
      debugPrint('   Processed: $totalProcessed');
      debugPrint('   Valid Files: $validFiles');
      debugPrint('   Invalid Files: $invalidFiles');
      debugPrint('   Failures: $failures');

      return result;
    } catch (e) {
      debugPrint('❌ Validation failed: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Validate a single document by ID
  ///
  /// Useful for checking individual documents
  Future<bool> validateSingleDocument(String documentId) async {
    try {
      final docSnapshot = await _firestore
          .collection('document-metadata')
          .doc(documentId)
          .get();

      if (!docSnapshot.exists) {
        debugPrint('❌ Document not found: $documentId');
        return false;
      }

      final data = docSnapshot.data()!;
      final currentFileName = data['fileName'] as String? ?? '';

      if (FilenameUtils.isValidFileName(currentFileName)) {
        debugPrint('✓ Document has valid filename: $currentFileName');
        return true;
      } else {
        debugPrint('⚠️ Document has invalid filename: $currentFileName');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Failed to validate document $documentId: $e');
      return false;
    }
  }

  /// Clean up old migration metadata (no longer needed)
  ///
  /// Removes old migration-related metadata fields from documents
  Future<Map<String, dynamic>> cleanupOldMetadata() async {
    try {
      debugPrint('🧹 Starting metadata cleanup...');

      final querySnapshot = await _firestore
          .collection('documents')
          .where('metadata.migrated', isEqualTo: true)
          .get();

      int totalCleaned = 0;
      int failures = 0;

      for (final doc in querySnapshot.docs) {
        try {
          await _firestore.collection('document-metadata').doc(doc.id).update({
            'metadata.migrated': FieldValue.delete(),
            'metadata.migratedAt': FieldValue.delete(),
            'metadata.rolledBackAt': FieldValue.delete(),
            'metadata.storageFileName': FieldValue.delete(),
          });

          totalCleaned++;
        } catch (e) {
          failures++;
          debugPrint('❌ Failed to cleanup document ${doc.id}: $e');
        }
      }

      debugPrint('🧹 Cleanup completed: $totalCleaned documents cleaned');

      return {
        'success': true,
        'totalCleaned': totalCleaned,
        'failures': failures,
      };
    } catch (e) {
      debugPrint('❌ Cleanup failed: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Get document statistics
  ///
  /// Returns detailed statistics about document status
  Future<Map<String, dynamic>> getDocumentStatistics() async {
    try {
      final allDocs = await _firestore
          .collection('document-metadata')
          .where('isActive', isEqualTo: true)
          .get();

      int validDocs = 0;
      int invalidDocs = 0;

      for (final doc in allDocs.docs) {
        final data = doc.data();
        final fileName = data['fileName'] as String? ?? '';

        if (FilenameUtils.isValidFileName(fileName)) {
          validDocs++;
        } else {
          invalidDocs++;
        }
      }

      return {
        'totalDocuments': allDocs.docs.length,
        'validDocuments': validDocs,
        'invalidDocuments': invalidDocs,
        'validationProgress': allDocs.docs.isEmpty
            ? 100.0
            : (validDocs / allDocs.docs.length) * 100,
      };
    } catch (e) {
      debugPrint('❌ Failed to get document statistics: $e');
      return {'error': e.toString()};
    }
  }
}
