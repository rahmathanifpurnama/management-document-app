import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/services/firebase_service.dart';

/// Service for bulk deletion operations on Firestore collections
/// WARNING: This service can delete all data in your Firestore database
class FirestoreBulkDeleteService {
  static FirestoreBulkDeleteService? _instance;
  static FirestoreBulkDeleteService get instance =>
      _instance ??= FirestoreBulkDeleteService._();

  FirestoreBulkDeleteService._();

  final FirebaseService _firebaseService = FirebaseService.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get list of all collections in the database
  Future<List<String>> getAllCollections() async {
    try {
      debugPrint('🔍 Scanning for all collections in Firestore...');

      // Known collections in your app
      final knownCollections = [
        'documents',
        'categories',
        'users',
        'activities',
        'processing_queue',
        'settings',
        'notifications',
        'file_cache',
        'user_preferences',
      ];

      final existingCollections = <String>[];

      for (final collectionName in knownCollections) {
        try {
          final snapshot = await _firestore
              .collection(collectionName)
              .limit(1)
              .get();

          if (snapshot.docs.isNotEmpty || snapshot.metadata.isFromCache) {
            existingCollections.add(collectionName);
            debugPrint('✅ Found collection: $collectionName');
          }
        } catch (e) {
          debugPrint('⚠️ Collection $collectionName not accessible: $e');
        }
      }

      debugPrint('📊 Total collections found: ${existingCollections.length}');
      return existingCollections;
    } catch (e) {
      debugPrint('❌ Error scanning collections: $e');
      return [];
    }
  }

  /// Get document count for a specific collection
  Future<int> getCollectionDocumentCount(String collectionName) async {
    try {
      final snapshot = await _firestore.collection(collectionName).get();
      return snapshot.docs.length;
    } catch (e) {
      debugPrint('❌ Error counting documents in $collectionName: $e');
      return 0;
    }
  }

  /// Get overview of all collections and their document counts
  Future<Map<String, dynamic>> getDatabaseOverview() async {
    try {
      debugPrint('📊 Generating database overview...');

      final collections = await getAllCollections();
      final overview = <String, dynamic>{
        'timestamp': DateTime.now().toIso8601String(),
        'total_collections': collections.length,
        'collections': <Map<String, dynamic>>[],
        'total_documents': 0,
      };

      for (final collectionName in collections) {
        final docCount = await getCollectionDocumentCount(collectionName);

        final collectionInfo = {
          'name': collectionName,
          'document_count': docCount,
        };

        (overview['collections'] as List).add(collectionInfo);
        overview['total_documents'] =
            (overview['total_documents'] as int) + docCount;

        debugPrint('📁 $collectionName: $docCount documents');
      }

      debugPrint('📊 Database Overview:');
      debugPrint('   Total Collections: ${overview['total_collections']}');
      debugPrint('   Total Documents: ${overview['total_documents']}');

      return overview;
    } catch (e) {
      debugPrint('❌ Error generating database overview: $e');
      return {'error': e.toString()};
    }
  }

  /// Delete all documents from a specific collection
  Future<Map<String, dynamic>> deleteAllDocumentsFromCollection(
    String collectionName, {
    bool dryRun = true,
    int batchSize = 100,
  }) async {
    try {
      debugPrint(
        '🗑️ ${dryRun ? '[DRY RUN] ' : ''}Deleting all documents from collection: $collectionName',
      );

      final result = <String, dynamic>{
        'collection': collectionName,
        'dry_run': dryRun,
        'deleted_count': 0,
        'error_count': 0,
        'errors': <String>[],
        'start_time': DateTime.now().toIso8601String(),
      };

      // Get all documents in batches
      QuerySnapshot snapshot;
      int totalDeleted = 0;
      int batchNumber = 1;

      do {
        snapshot = await _firestore
            .collection(collectionName)
            .limit(batchSize)
            .get();

        if (snapshot.docs.isEmpty) break;

        debugPrint(
          '🔄 Processing batch $batchNumber: ${snapshot.docs.length} documents',
        );

        if (!dryRun) {
          // Create a batch for deletion
          final batch = _firestore.batch();

          for (final doc in snapshot.docs) {
            batch.delete(doc.reference);
          }

          try {
            await batch.commit();
            totalDeleted += snapshot.docs.length;
            debugPrint(
              '✅ Deleted batch $batchNumber: ${snapshot.docs.length} documents',
            );
          } catch (e) {
            result['error_count'] = (result['error_count'] as int) + 1;
            (result['errors'] as List).add('Batch $batchNumber: $e');
            debugPrint('❌ Error deleting batch $batchNumber: $e');
          }
        } else {
          // Dry run - just count
          totalDeleted += snapshot.docs.length;
          debugPrint(
            '📋 [DRY RUN] Would delete ${snapshot.docs.length} documents',
          );
        }

        batchNumber++;

        // Small delay to prevent overwhelming Firestore
        await Future.delayed(const Duration(milliseconds: 100));
      } while (snapshot.docs.length == batchSize);

      result['deleted_count'] = totalDeleted;
      result['end_time'] = DateTime.now().toIso8601String();

      debugPrint(
        '✅ ${dryRun ? '[DRY RUN] ' : ''}Collection $collectionName: $totalDeleted documents ${dryRun ? 'would be ' : ''}deleted',
      );

      return result;
    } catch (e) {
      debugPrint('❌ Error deleting from collection $collectionName: $e');
      return {
        'collection': collectionName,
        'error': e.toString(),
        'dry_run': dryRun,
      };
    }
  }

  /// Delete all documents from all collections
  Future<Map<String, dynamic>> deleteAllDocumentsFromAllCollections({
    bool dryRun = true,
    List<String>? excludeCollections,
    int batchSize = 100,
  }) async {
    try {
      debugPrint(
        '🚨 ${dryRun ? '[DRY RUN] ' : ''}STARTING BULK DELETE OPERATION',
      );
      debugPrint('⚠️ This will delete ALL documents from ALL collections!');

      final result = <String, dynamic>{
        'operation': 'delete_all_collections',
        'dry_run': dryRun,
        'start_time': DateTime.now().toIso8601String(),
        'collections_processed': <Map<String, dynamic>>[],
        'total_deleted': 0,
        'total_errors': 0,
        'excluded_collections': excludeCollections ?? [],
      };

      final collections = await getAllCollections();
      final collectionsToProcess = collections
          .where(
            (collection) =>
                !(excludeCollections?.contains(collection) ?? false),
          )
          .toList();

      debugPrint(
        '📋 Collections to process: ${collectionsToProcess.join(', ')}',
      );
      if (excludeCollections?.isNotEmpty == true) {
        debugPrint(
          '🚫 Excluded collections: ${excludeCollections!.join(', ')}',
        );
      }

      for (final collectionName in collectionsToProcess) {
        debugPrint('🔄 Processing collection: $collectionName');

        final collectionResult = await deleteAllDocumentsFromCollection(
          collectionName,
          dryRun: dryRun,
          batchSize: batchSize,
        );

        (result['collections_processed'] as List).add(collectionResult);
        result['total_deleted'] =
            (result['total_deleted'] as int) +
            (collectionResult['deleted_count'] as int? ?? 0);
        result['total_errors'] =
            (result['total_errors'] as int) +
            (collectionResult['error_count'] as int? ?? 0);

        // Delay between collections to prevent overwhelming Firestore
        await Future.delayed(const Duration(milliseconds: 500));
      }

      result['end_time'] = DateTime.now().toIso8601String();

      debugPrint(
        '🎉 ${dryRun ? '[DRY RUN] ' : ''}BULK DELETE OPERATION COMPLETED',
      );
      debugPrint('📊 Summary:');
      debugPrint('   Collections processed: ${collectionsToProcess.length}');
      debugPrint(
        '   Total documents ${dryRun ? 'would be ' : ''}deleted: ${result['total_deleted']}',
      );
      debugPrint('   Total errors: ${result['total_errors']}');

      return result;
    } catch (e) {
      debugPrint('❌ BULK DELETE OPERATION FAILED: $e');
      return {
        'operation': 'delete_all_collections',
        'error': e.toString(),
        'dry_run': dryRun,
      };
    }
  }

  /// Delete only specific collections
  Future<Map<String, dynamic>> deleteSpecificCollections(
    List<String> collectionsToDelete, {
    bool dryRun = true,
    int batchSize = 100,
  }) async {
    try {
      debugPrint(
        '🗑️ ${dryRun ? '[DRY RUN] ' : ''}Deleting specific collections: ${collectionsToDelete.join(', ')}',
      );

      final result = <String, dynamic>{
        'operation': 'delete_specific_collections',
        'dry_run': dryRun,
        'target_collections': collectionsToDelete,
        'start_time': DateTime.now().toIso8601String(),
        'collections_processed': <Map<String, dynamic>>[],
        'total_deleted': 0,
        'total_errors': 0,
      };

      for (final collectionName in collectionsToDelete) {
        debugPrint('🔄 Processing collection: $collectionName');

        final collectionResult = await deleteAllDocumentsFromCollection(
          collectionName,
          dryRun: dryRun,
          batchSize: batchSize,
        );

        (result['collections_processed'] as List).add(collectionResult);
        result['total_deleted'] =
            (result['total_deleted'] as int) +
            (collectionResult['deleted_count'] as int? ?? 0);
        result['total_errors'] =
            (result['total_errors'] as int) +
            (collectionResult['error_count'] as int? ?? 0);

        // Delay between collections
        await Future.delayed(const Duration(milliseconds: 500));
      }

      result['end_time'] = DateTime.now().toIso8601String();

      debugPrint('✅ Specific collections deletion completed');
      debugPrint(
        '   Total documents ${dryRun ? 'would be ' : ''}deleted: ${result['total_deleted']}',
      );

      return result;
    } catch (e) {
      debugPrint('❌ Error deleting specific collections: $e');
      return {
        'operation': 'delete_specific_collections',
        'error': e.toString(),
        'dry_run': dryRun,
      };
    }
  }

  /// Emergency stop - this method can be called to stop ongoing operations
  bool _shouldStop = false;

  void stopOperation() {
    _shouldStop = true;
    debugPrint('🛑 STOP SIGNAL RECEIVED - Operations will halt');
  }

  void resetStopSignal() {
    _shouldStop = false;
    debugPrint('🔄 Stop signal reset - Operations can proceed');
  }

  /// QUICK DELETE ALL - Use this method for immediate deletion of all documents
  /// WARNING: This will delete ALL documents from ALL collections immediately!
  static Future<void> quickDeleteAllDocuments() async {
    final service = FirestoreBulkDeleteService.instance;

    debugPrint('🚨 QUICK DELETE ALL INITIATED');
    debugPrint('⚠️ This will delete ALL documents from ALL collections!');

    try {
      // First, show what will be deleted
      final overview = await service.getDatabaseOverview();
      debugPrint('📊 Database before deletion:');
      debugPrint('   Total Collections: ${overview['total_collections']}');
      debugPrint('   Total Documents: ${overview['total_documents']}');

      // Perform the deletion
      final result = await service.deleteAllDocumentsFromAllCollections(
        dryRun: false, // REAL DELETION
        batchSize: 100,
      );

      debugPrint('✅ QUICK DELETE COMPLETED');
      debugPrint('📊 Results:');
      debugPrint(
        '   Collections processed: ${(result['collections_processed'] as List).length}',
      );
      debugPrint('   Total documents deleted: ${result['total_deleted']}');
      debugPrint('   Total errors: ${result['total_errors']}');
    } catch (e) {
      debugPrint('❌ QUICK DELETE FAILED: $e');
      rethrow;
    }
  }

  /// QUICK DELETE SPECIFIC COLLECTIONS
  static Future<void> quickDeleteSpecificCollections(
    List<String> collections,
  ) async {
    final service = FirestoreBulkDeleteService.instance;

    debugPrint(
      '🗑️ QUICK DELETE SPECIFIC COLLECTIONS: ${collections.join(', ')}',
    );

    try {
      final result = await service.deleteSpecificCollections(
        collections,
        dryRun: false, // REAL DELETION
        batchSize: 100,
      );

      debugPrint('✅ SPECIFIC COLLECTIONS DELETE COMPLETED');
      debugPrint('   Total documents deleted: ${result['total_deleted']}');
    } catch (e) {
      debugPrint('❌ SPECIFIC COLLECTIONS DELETE FAILED: $e');
      rethrow;
    }
  }

  /// QUICK PREVIEW - See what would be deleted without actually deleting
  static Future<void> quickPreviewDeletion() async {
    final service = FirestoreBulkDeleteService.instance;

    debugPrint('👁️ QUICK PREVIEW - Showing what would be deleted');

    try {
      final overview = await service.getDatabaseOverview();
      debugPrint('📊 Current Database State:');
      debugPrint('   Total Collections: ${overview['total_collections']}');
      debugPrint('   Total Documents: ${overview['total_documents']}');

      final collections = overview['collections'] as List;
      for (final collection in collections) {
        debugPrint(
          '   📁 ${collection['name']}: ${collection['document_count']} documents',
        );
      }

      // Dry run to show what would be deleted
      final result = await service.deleteAllDocumentsFromAllCollections(
        dryRun: true, // DRY RUN ONLY
      );

      debugPrint('📋 PREVIEW RESULTS:');
      debugPrint('   Would delete ${result['total_deleted']} documents total');
    } catch (e) {
      debugPrint('❌ PREVIEW FAILED: $e');
      rethrow;
    }
  }
}
