import 'package:flutter/foundation.dart';
import '../core/services/document_service.dart';
import '../models/document_model.dart';
import 'document_id_generator.dart';

/// Service to migrate existing documents with inconsistent IDs to the new standardized format
class DocumentIdMigrationService {
  static DocumentIdMigrationService? _instance;
  static DocumentIdMigrationService get instance =>
      _instance ??= DocumentIdMigrationService._();

  DocumentIdMigrationService._();

  final DocumentService _documentService = DocumentService.instance;

  /// Check if migration is needed by analyzing existing document IDs
  Future<bool> isMigrationNeeded() async {
    try {
      debugPrint('🔍 Checking if document ID migration is needed...');
      
      final documents = await _documentService.getAllDocuments(limit: 100);
      
      if (documents.isEmpty) {
        debugPrint('✅ No documents found, migration not needed');
        return false;
      }
      
      int nonStandardIds = 0;
      int standardIds = 0;
      
      for (final doc in documents) {
        if (DocumentIdGenerator.isStandardFormat(doc.id)) {
          standardIds++;
        } else {
          nonStandardIds++;
        }
      }
      
      debugPrint('📊 Document ID analysis:');
      debugPrint('   Standard format: $standardIds');
      debugPrint('   Non-standard format: $nonStandardIds');
      
      // Migration needed if more than 10% of documents have non-standard IDs
      final migrationNeeded = nonStandardIds > (documents.length * 0.1);
      
      if (migrationNeeded) {
        debugPrint('⚠️ Migration needed: $nonStandardIds non-standard IDs found');
      } else {
        debugPrint('✅ Migration not needed: Most documents have standard IDs');
      }
      
      return migrationNeeded;
    } catch (e) {
      debugPrint('❌ Error checking migration status: $e');
      return false;
    }
  }

  /// Perform document ID migration (this is a complex operation, use with caution)
  Future<Map<String, dynamic>> performMigration({
    bool dryRun = true,
    int batchSize = 10,
  }) async {
    try {
      debugPrint('🔄 Starting document ID migration (dryRun: $dryRun)...');
      
      final documents = await _documentService.getAllDocuments();
      final migrationResults = <String, dynamic>{
        'totalDocuments': documents.length,
        'migratedCount': 0,
        'skippedCount': 0,
        'errorCount': 0,
        'errors': <String>[],
        'dryRun': dryRun,
      };
      
      if (documents.isEmpty) {
        debugPrint('⚠️ No documents found for migration');
        return migrationResults;
      }
      
      // Find documents that need migration
      final documentsToMigrate = documents.where(
        (doc) => !DocumentIdGenerator.isStandardFormat(doc.id),
      ).toList();
      
      debugPrint('📋 Found ${documentsToMigrate.length} documents to migrate');
      
      if (documentsToMigrate.isEmpty) {
        debugPrint('✅ All documents already have standard IDs');
        return migrationResults;
      }
      
      // Process in batches to prevent overwhelming the system
      for (int i = 0; i < documentsToMigrate.length; i += batchSize) {
        final batch = documentsToMigrate.skip(i).take(batchSize).toList();
        
        debugPrint('🔄 Processing batch ${(i / batchSize).floor() + 1}/${(documentsToMigrate.length / batchSize).ceil()}');
        
        for (final doc in batch) {
          try {
            final result = await _migrateSingleDocument(doc, dryRun: dryRun);
            
            if (result['success'] == true) {
              migrationResults['migratedCount']++;
            } else {
              migrationResults['skippedCount']++;
            }
            
            if (result['error'] != null) {
              migrationResults['errorCount']++;
              migrationResults['errors'].add(result['error']);
            }
          } catch (e) {
            debugPrint('❌ Error migrating document ${doc.id}: $e');
            migrationResults['errorCount']++;
            migrationResults['errors'].add('${doc.id}: $e');
          }
        }
        
        // Small delay between batches
        if (i + batchSize < documentsToMigrate.length) {
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }
      
      debugPrint('✅ Migration completed:');
      debugPrint('   Migrated: ${migrationResults['migratedCount']}');
      debugPrint('   Skipped: ${migrationResults['skippedCount']}');
      debugPrint('   Errors: ${migrationResults['errorCount']}');
      
      return migrationResults;
    } catch (e) {
      debugPrint('❌ Migration failed: $e');
      return {
        'error': e.toString(),
        'dryRun': dryRun,
      };
    }
  }

  /// Migrate a single document ID
  Future<Map<String, dynamic>> _migrateSingleDocument(
    DocumentModel document,
    {bool dryRun = true}
  ) async {
    try {
      // Generate new standardized ID
      final newId = DocumentIdGenerator.generateFromFileName(document.fileName);
      
      if (newId == document.id) {
        debugPrint('⚠️ Document ${document.id} already has correct ID format');
        return {'success': false, 'reason': 'already_correct'};
      }
      
      debugPrint('🔄 Migrating ${document.id} -> $newId (${document.fileName})');
      
      if (dryRun) {
        debugPrint('   [DRY RUN] Would migrate to: $newId');
        return {'success': true, 'newId': newId, 'dryRun': true};
      }
      
      // Check if new ID already exists
      final existingDoc = await _documentService.getDocumentById(newId);
      if (existingDoc != null) {
        debugPrint('⚠️ Target ID $newId already exists, skipping migration');
        return {
          'success': false, 
          'reason': 'target_exists',
          'error': 'Target ID already exists: $newId'
        };
      }
      
      // Create new document with updated ID
      final updatedDocument = document.copyWith(id: newId);
      
      // This is a complex operation that would require:
      // 1. Creating new document with new ID
      // 2. Updating all references to the old ID
      // 3. Deleting the old document
      // For now, we'll just log what would be done
      
      debugPrint('⚠️ MIGRATION NOT IMPLEMENTED: Complex operation requires careful handling');
      debugPrint('   Would create new document with ID: $newId');
      debugPrint('   Would update all references from: ${document.id}');
      debugPrint('   Would delete old document: ${document.id}');
      
      return {
        'success': false,
        'reason': 'not_implemented',
        'error': 'Migration implementation requires careful handling of references'
      };
    } catch (e) {
      debugPrint('❌ Error migrating document ${document.id}: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Get migration status report
  Future<Map<String, dynamic>> getMigrationReport() async {
    try {
      final documents = await _documentService.getAllDocuments();
      
      final report = <String, dynamic>{
        'totalDocuments': documents.length,
        'standardIds': 0,
        'nonStandardIds': 0,
        'idFormats': <String, int>{},
        'sampleNonStandardIds': <String>[],
      };
      
      for (final doc in documents) {
        if (DocumentIdGenerator.isStandardFormat(doc.id)) {
          report['standardIds']++;
        } else {
          report['nonStandardIds']++;
          
          // Collect sample non-standard IDs
          if ((report['sampleNonStandardIds'] as List).length < 10) {
            (report['sampleNonStandardIds'] as List).add(doc.id);
          }
        }
        
        // Analyze ID format patterns
        String format = 'unknown';
        if (doc.id.startsWith('doc_')) {
          format = 'doc_prefix';
        } else if (doc.id.startsWith('sync_')) {
          format = 'sync_prefix';
        } else if (RegExp(r'^[a-f0-9-]{36}$').hasMatch(doc.id)) {
          format = 'uuid';
        } else if (RegExp(r'^\d+_').hasMatch(doc.id)) {
          format = 'timestamp_prefix';
        } else if (doc.id.length < 10) {
          format = 'short_name';
        }
        
        report['idFormats'][format] = (report['idFormats'][format] ?? 0) + 1;
      }
      
      return report;
    } catch (e) {
      debugPrint('❌ Error generating migration report: $e');
      return {'error': e.toString()};
    }
  }
}
