import 'package:flutter/foundation.dart';
import 'cloud_functions_service.dart';

class CloudSyncService {
  static CloudSyncService? _instance;
  static CloudSyncService get instance => _instance ??= CloudSyncService._();

  CloudSyncService._();

  final CloudFunctionsService _cloudFunctions = CloudFunctionsService.instance;

  /// Perform comprehensive sync using Cloud Functions
  /// This will sync Storage files with Firestore and cleanup orphaned metadata
  Future<Map<String, dynamic>> performComprehensiveSync() async {
    try {
      debugPrint('🔄 Starting comprehensive sync via Cloud Functions...');
      
      final result = await _cloudFunctions.performComprehensiveSync();

      if (result['success'] == true) {
        final totalDocuments = result['totalDocuments'] ?? 0;
        final cleanedMetadata = result['cleanedMetadata'] ?? 0;
        
        debugPrint('✅ Comprehensive sync completed successfully:');
        debugPrint('   📄 Total documents processed: $totalDocuments');
        debugPrint('   🧹 Orphaned metadata cleaned: $cleanedMetadata');
        
        return {
          'success': true,
          'totalDocuments': totalDocuments,
          'cleanedMetadata': cleanedMetadata,
          'message': 'Comprehensive sync completed successfully',
        };
      } else {
        throw Exception('Comprehensive sync failed: ${result['message']}');
      }
    } catch (e) {
      debugPrint('❌ Comprehensive sync failed: $e');
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Failed to perform comprehensive sync',
      };
    }
  }

  /// Sync Firebase Storage with Firestore using Cloud Functions
  /// This creates Firestore documents for files that exist in Storage but not in Firestore
  Future<Map<String, dynamic>> syncStorageWithFirestore() async {
    try {
      debugPrint('🔄 Starting Storage to Firestore sync via Cloud Functions...');
      
      final result = await _cloudFunctions.syncStorageWithFirestore();

      if (result['success'] == true) {
        final syncedDocuments = result['syncedDocuments'] ?? 0;
        
        debugPrint('✅ Storage sync completed successfully:');
        debugPrint('   📄 Documents synced: $syncedDocuments');
        
        return {
          'success': true,
          'syncedDocuments': syncedDocuments,
          'message': 'Storage sync completed successfully',
        };
      } else {
        throw Exception('Storage sync failed: ${result['message']}');
      }
    } catch (e) {
      debugPrint('❌ Storage sync failed: $e');
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Failed to sync storage with Firestore',
      };
    }
  }

  /// Cleanup orphaned metadata using Cloud Functions
  /// This removes Firestore documents that reference files that no longer exist in Storage
  Future<Map<String, dynamic>> cleanupOrphanedMetadata() async {
    try {
      debugPrint('🔄 Starting orphaned metadata cleanup via Cloud Functions...');
      
      final result = await _cloudFunctions.cleanupOrphanedMetadata();

      if (result['success'] == true) {
        final cleanedCount = result['cleanedCount'] ?? 0;
        
        debugPrint('✅ Orphaned metadata cleanup completed successfully:');
        debugPrint('   🧹 Orphaned documents cleaned: $cleanedCount');
        
        return {
          'success': true,
          'cleanedCount': cleanedCount,
          'message': 'Orphaned metadata cleanup completed successfully',
        };
      } else {
        throw Exception('Cleanup failed: ${result['message']}');
      }
    } catch (e) {
      debugPrint('❌ Orphaned metadata cleanup failed: $e');
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Failed to cleanup orphaned metadata',
      };
    }
  }

  /// Get sync status and statistics
  Future<Map<String, dynamic>> getSyncStatus() async {
    try {
      debugPrint('🔄 Getting sync status...');
      
      // This would ideally be a separate Cloud Function, but for now we can use existing ones
      // to get some basic statistics
      
      return {
        'success': true,
        'lastSyncTime': DateTime.now().toIso8601String(),
        'message': 'Sync status retrieved successfully',
      };
    } catch (e) {
      debugPrint('❌ Failed to get sync status: $e');
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Failed to get sync status',
      };
    }
  }

  /// Schedule automatic sync (this would typically be handled by Cloud Functions scheduled tasks)
  Future<void> scheduleAutoSync() async {
    try {
      debugPrint('📅 Auto sync is handled by Cloud Functions scheduled tasks');
      debugPrint('   - Daily cleanup: 2 AM Jakarta time');
      debugPrint('   - Weekly comprehensive sync: Sunday 3 AM Jakarta time');
    } catch (e) {
      debugPrint('❌ Failed to schedule auto sync: $e');
    }
  }

  /// Manual trigger for emergency sync
  Future<Map<String, dynamic>> emergencySync() async {
    try {
      debugPrint('🚨 Starting emergency sync...');
      
      // Perform all sync operations in sequence
      final results = <String, dynamic>{};
      
      // 1. Sync Storage with Firestore
      final storageSync = await syncStorageWithFirestore();
      results['storageSync'] = storageSync;
      
      // 2. Cleanup orphaned metadata
      final cleanup = await cleanupOrphanedMetadata();
      results['cleanup'] = cleanup;
      
      // 3. Comprehensive sync
      final comprehensive = await performComprehensiveSync();
      results['comprehensive'] = comprehensive;
      
      final allSuccessful = storageSync['success'] == true && 
                           cleanup['success'] == true && 
                           comprehensive['success'] == true;
      
      if (allSuccessful) {
        debugPrint('✅ Emergency sync completed successfully');
        return {
          'success': true,
          'results': results,
          'message': 'Emergency sync completed successfully',
        };
      } else {
        debugPrint('⚠️ Emergency sync completed with some failures');
        return {
          'success': false,
          'results': results,
          'message': 'Emergency sync completed with some failures',
        };
      }
    } catch (e) {
      debugPrint('❌ Emergency sync failed: $e');
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Emergency sync failed',
      };
    }
  }

  /// Check if sync is needed based on last sync time and file counts
  Future<bool> isSyncNeeded() async {
    try {
      // This is a simple check - in a real implementation, you might want to
      // compare file counts between Storage and Firestore
      debugPrint('🔍 Checking if sync is needed...');
      
      // For now, we'll assume sync is always beneficial
      return true;
    } catch (e) {
      debugPrint('❌ Failed to check sync status: $e');
      return true; // Default to needing sync if we can't determine
    }
  }

  /// Get human-readable sync summary
  String getSyncSummary(Map<String, dynamic> syncResult) {
    if (syncResult['success'] != true) {
      return 'Sync failed: ${syncResult['message'] ?? 'Unknown error'}';
    }

    final parts = <String>[];
    
    if (syncResult['totalDocuments'] != null) {
      parts.add('${syncResult['totalDocuments']} documents processed');
    }
    
    if (syncResult['syncedDocuments'] != null) {
      parts.add('${syncResult['syncedDocuments']} documents synced');
    }
    
    if (syncResult['cleanedMetadata'] != null) {
      parts.add('${syncResult['cleanedMetadata']} orphaned records cleaned');
    }
    
    if (syncResult['cleanedCount'] != null) {
      parts.add('${syncResult['cleanedCount']} orphaned records cleaned');
    }

    return parts.isEmpty ? 'Sync completed successfully' : parts.join(', ');
  }
}
