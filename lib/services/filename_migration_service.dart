import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/document_model.dart';
import '../utils/filename_utils.dart';

/// Service to migrate existing documents to use clean display filenames
/// 
/// This service helps fix existing documents that have timestamp prefixes
/// in their fileName field by updating them to use clean display names
/// while preserving the storage path with timestamps.
class FilenameMigrationService {
  static final FilenameMigrationService _instance = FilenameMigrationService._internal();
  factory FilenameMigrationService() => _instance;
  FilenameMigrationService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Check if migration is needed for the current documents
  /// 
  /// Returns a report of how many documents need filename cleaning
  Future<Map<String, dynamic>> checkMigrationStatus() async {
    try {
      debugPrint('🔍 Checking filename migration status...');
      
      final querySnapshot = await _firestore
          .collection('document-metadata')
          .where('isActive', isEqualTo: true)
          .get();

      int totalDocuments = querySnapshot.docs.length;
      int documentsWithTimestamp = 0;
      int documentsAlreadyClean = 0;
      List<String> sampleTimestampFiles = [];

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final fileName = data['fileName'] as String? ?? '';
        
        if (FilenameUtils.hasTimestampPrefix(fileName)) {
          documentsWithTimestamp++;
          if (sampleTimestampFiles.length < 5) {
            sampleTimestampFiles.add(fileName);
          }
        } else {
          documentsAlreadyClean++;
        }
      }

      final report = {
        'totalDocuments': totalDocuments,
        'documentsWithTimestamp': documentsWithTimestamp,
        'documentsAlreadyClean': documentsAlreadyClean,
        'migrationNeeded': documentsWithTimestamp > 0,
        'sampleTimestampFiles': sampleTimestampFiles,
      };

      debugPrint('📊 Migration Status Report:');
      debugPrint('   Total Documents: $totalDocuments');
      debugPrint('   Need Migration: $documentsWithTimestamp');
      debugPrint('   Already Clean: $documentsAlreadyClean');
      
      return report;
    } catch (e) {
      debugPrint('❌ Failed to check migration status: $e');
      return {
        'error': e.toString(),
        'migrationNeeded': false,
      };
    }
  }

  /// Migrate all documents to use clean display filenames
  /// 
  /// Updates fileName field to remove timestamp prefixes while preserving
  /// the original storage path in filePath field
  Future<Map<String, dynamic>> migrateAllDocuments() async {
    try {
      debugPrint('🚀 Starting filename migration...');
      
      final querySnapshot = await _firestore
          .collection('document-metadata')
          .where('isActive', isEqualTo: true)
          .get();

      int totalProcessed = 0;
      int successfulMigrations = 0;
      int alreadyClean = 0;
      int failures = 0;
      List<String> failedDocuments = [];

      // Process in batches to avoid overwhelming Firestore
      const batchSize = 10;
      final docs = querySnapshot.docs;
      
      for (int i = 0; i < docs.length; i += batchSize) {
        final batch = docs.skip(i).take(batchSize);
        
        await Future.wait(batch.map((doc) async {
          try {
            totalProcessed++;
            final data = doc.data();
            final currentFileName = data['fileName'] as String? ?? '';
            
            if (FilenameUtils.hasTimestampPrefix(currentFileName)) {
              // Extract clean display name
              final cleanFileName = FilenameUtils.getDisplayFileName(currentFileName);
              
              // Update document with clean filename
              await _firestore
                  .collection('document-metadata')
                  .doc(doc.id)
                  .update({
                'fileName': cleanFileName,
                'originalFileName': currentFileName, // Preserve original for reference
                'metadata.displayFileName': cleanFileName,
                'metadata.storageFileName': currentFileName,
                'metadata.migrated': true,
                'metadata.migratedAt': FieldValue.serverTimestamp(),
              });
              
              successfulMigrations++;
              debugPrint('✅ Migrated: $currentFileName -> $cleanFileName');
            } else {
              alreadyClean++;
              debugPrint('✓ Already clean: $currentFileName');
            }
          } catch (e) {
            failures++;
            failedDocuments.add(doc.id);
            debugPrint('❌ Failed to migrate document ${doc.id}: $e');
          }
        }));
        
        // Small delay between batches
        if (i + batchSize < docs.length) {
          await Future.delayed(const Duration(milliseconds: 200));
        }
      }

      final result = {
        'success': true,
        'totalProcessed': totalProcessed,
        'successfulMigrations': successfulMigrations,
        'alreadyClean': alreadyClean,
        'failures': failures,
        'failedDocuments': failedDocuments,
      };

      debugPrint('✅ Migration completed:');
      debugPrint('   Processed: $totalProcessed');
      debugPrint('   Migrated: $successfulMigrations');
      debugPrint('   Already Clean: $alreadyClean');
      debugPrint('   Failures: $failures');

      return result;
    } catch (e) {
      debugPrint('❌ Migration failed: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Migrate a single document by ID
  /// 
  /// Useful for fixing individual documents
  Future<bool> migrateSingleDocument(String documentId) async {
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

      if (FilenameUtils.hasTimestampPrefix(currentFileName)) {
        final cleanFileName = FilenameUtils.getDisplayFileName(currentFileName);
        
        await _firestore
            .collection('document-metadata')
            .doc(documentId)
            .update({
          'fileName': cleanFileName,
          'originalFileName': currentFileName,
          'metadata.displayFileName': cleanFileName,
          'metadata.storageFileName': currentFileName,
          'metadata.migrated': true,
          'metadata.migratedAt': FieldValue.serverTimestamp(),
        });

        debugPrint('✅ Migrated single document: $currentFileName -> $cleanFileName');
        return true;
      } else {
        debugPrint('✓ Document already has clean filename: $currentFileName');
        return true;
      }
    } catch (e) {
      debugPrint('❌ Failed to migrate document $documentId: $e');
      return false;
    }
  }

  /// Rollback migration for testing purposes
  /// 
  /// WARNING: This will restore timestamp prefixes to filenames
  Future<Map<String, dynamic>> rollbackMigration() async {
    try {
      debugPrint('⚠️ Starting migration rollback...');
      
      final querySnapshot = await _firestore
          .collection('document-metadata')
          .where('metadata.migrated', isEqualTo: true)
          .get();

      int totalRolledBack = 0;
      int failures = 0;

      for (final doc in querySnapshot.docs) {
        try {
          final data = doc.data();
          final originalFileName = data['originalFileName'] as String? ?? '';
          
          if (originalFileName.isNotEmpty) {
            await _firestore
                .collection('document-metadata')
                .doc(doc.id)
                .update({
              'fileName': originalFileName,
              'metadata.migrated': false,
              'metadata.rolledBackAt': FieldValue.serverTimestamp(),
            });
            
            totalRolledBack++;
          }
        } catch (e) {
          failures++;
          debugPrint('❌ Failed to rollback document ${doc.id}: $e');
        }
      }

      debugPrint('⚠️ Rollback completed: $totalRolledBack documents restored');
      
      return {
        'success': true,
        'totalRolledBack': totalRolledBack,
        'failures': failures,
      };
    } catch (e) {
      debugPrint('❌ Rollback failed: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Get migration statistics
  /// 
  /// Returns detailed statistics about the migration status
  Future<Map<String, dynamic>> getMigrationStatistics() async {
    try {
      final allDocs = await _firestore
          .collection('document-metadata')
          .where('isActive', isEqualTo: true)
          .get();

      final migratedDocs = await _firestore
          .collection('document-metadata')
          .where('metadata.migrated', isEqualTo: true)
          .get();

      return {
        'totalDocuments': allDocs.docs.length,
        'migratedDocuments': migratedDocs.docs.length,
        'pendingMigration': allDocs.docs.length - migratedDocs.docs.length,
        'migrationProgress': allDocs.docs.isEmpty 
            ? 0.0 
            : (migratedDocs.docs.length / allDocs.docs.length) * 100,
      };
    } catch (e) {
      debugPrint('❌ Failed to get migration statistics: $e');
      return {
        'error': e.toString(),
      };
    }
  }
}
