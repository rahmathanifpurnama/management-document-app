import 'package:flutter/foundation.dart';
import 'direct_statistics_service.dart';

/// Direct Statistics Update Service
/// Handles immediate statistics updates after delete operations
/// Uses DirectStatisticsService for real-time data without cache dependencies
class DirectStatisticsUpdateService {
  static final DirectStatisticsUpdateService _instance = DirectStatisticsUpdateService._internal();
  static DirectStatisticsUpdateService get instance => _instance;
  DirectStatisticsUpdateService._internal();

  final DirectStatisticsService _directStatsService = DirectStatisticsService.instance;

  /// Notify that a file has been deleted and trigger immediate statistics refresh
  Future<void> notifyFileDeleted({
    required String fileId,
    required String fileName,
    required String category,
    required int fileSize,
  }) async {
    try {
      debugPrint('📊 DirectStatisticsUpdateService: File deleted - $fileName');
      
      // Immediately refresh file statistics using direct queries
      final fileStats = await _directStatsService.getFileStatistics();
      debugPrint('📊 Updated file statistics: ${fileStats['totalFiles']} total, ${fileStats['activeFiles']} active');
      
      // If the file was in a category, also refresh category statistics
      if (category.isNotEmpty && category != 'uncategorized') {
        final categoryStats = await _directStatsService.getCategoryStatistics();
        debugPrint('📊 Updated category statistics: ${categoryStats['totalCategories']} total');
      }
      
      // Trigger a full statistics refresh to ensure all widgets are updated
      await _directStatsService.getAllStatistics();
      
    } catch (e) {
      debugPrint('❌ DirectStatisticsUpdateService: Error updating statistics after file deletion - $e');
    }
  }

  /// Notify that a category has been deleted and trigger immediate statistics refresh
  Future<void> notifyCategoryDeleted({
    required String categoryId,
    required String categoryName,
    int? movedDocuments,
  }) async {
    try {
      debugPrint('📊 DirectStatisticsUpdateService: Category deleted - $categoryName');
      
      // Immediately refresh category statistics using direct queries
      final categoryStats = await _directStatsService.getCategoryStatistics();
      debugPrint('📊 Updated category statistics: ${categoryStats['totalCategories']} total, ${categoryStats['activeCategories']} active');
      
      // If documents were moved, also refresh file statistics
      if (movedDocuments != null && movedDocuments > 0) {
        final fileStats = await _directStatsService.getFileStatistics();
        debugPrint('📊 Updated file statistics after moving $movedDocuments documents');
      }
      
      // Trigger a full statistics refresh to ensure all widgets are updated
      await _directStatsService.getAllStatistics();
      
    } catch (e) {
      debugPrint('❌ DirectStatisticsUpdateService: Error updating statistics after category deletion - $e');
    }
  }

  /// Notify that a user has been deleted and trigger immediate statistics refresh
  Future<void> notifyUserDeleted({
    required String userId,
    required String userEmail,
    required String userRole,
  }) async {
    try {
      debugPrint('📊 DirectStatisticsUpdateService: User deleted - $userEmail');
      
      // Immediately refresh user statistics using direct queries
      final userStats = await _directStatsService.getUserStatistics();
      debugPrint('📊 Updated user statistics: ${userStats['totalUsers']} total, ${userStats['activeUsers']} active');
      
      // Trigger a full statistics refresh to ensure all widgets are updated
      await _directStatsService.getAllStatistics();
      
    } catch (e) {
      debugPrint('❌ DirectStatisticsUpdateService: Error updating statistics after user deletion - $e');
    }
  }

  /// Notify that multiple files have been deleted (batch operation)
  Future<void> notifyBatchFilesDeleted({
    required List<String> fileIds,
    required List<String> fileNames,
    required List<String> categories,
  }) async {
    try {
      debugPrint('📊 DirectStatisticsUpdateService: Batch files deleted - ${fileIds.length} files');
      
      // Immediately refresh all statistics using direct queries
      final allStats = await _directStatsService.getAllStatistics();
      debugPrint('📊 Updated all statistics after batch deletion');
      
    } catch (e) {
      debugPrint('❌ DirectStatisticsUpdateService: Error updating statistics after batch file deletion - $e');
    }
  }

  /// Notify that multiple users have been deleted (batch operation)
  Future<void> notifyBatchUsersDeleted({
    required List<String> userIds,
    required List<String> userEmails,
  }) async {
    try {
      debugPrint('📊 DirectStatisticsUpdateService: Batch users deleted - ${userIds.length} users');
      
      // Immediately refresh user statistics using direct queries
      final userStats = await _directStatsService.getUserStatistics();
      debugPrint('📊 Updated user statistics after batch deletion: ${userStats['totalUsers']} total');
      
      // Trigger a full statistics refresh to ensure all widgets are updated
      await _directStatsService.getAllStatistics();
      
    } catch (e) {
      debugPrint('❌ DirectStatisticsUpdateService: Error updating statistics after batch user deletion - $e');
    }
  }

  /// Force refresh all statistics (can be called manually or after any major operation)
  Future<void> forceRefreshAllStatistics({String? reason}) async {
    try {
      debugPrint('📊 DirectStatisticsUpdateService: Force refresh all statistics - ${reason ?? 'Manual'}');
      
      // Get fresh statistics from all sources
      final allStats = await _directStatsService.getAllStatistics();
      
      debugPrint('📊 Force refresh completed:');
      debugPrint('   - Categories: ${allStats['categories']['totalCategories']}');
      debugPrint('   - Users: ${allStats['users']['totalUsers']}');
      debugPrint('   - Files: ${allStats['files']['totalFiles']}');
      
    } catch (e) {
      debugPrint('❌ DirectStatisticsUpdateService: Error in force refresh - $e');
    }
  }

  /// Get current statistics summary for debugging
  Future<Map<String, dynamic>> getCurrentStatisticsSummary() async {
    try {
      final allStats = await _directStatsService.getAllStatistics();
      
      return {
        'categories': {
          'total': allStats['categories']['totalCategories'],
          'active': allStats['categories']['activeCategories'],
        },
        'users': {
          'total': allStats['users']['totalUsers'],
          'active': allStats['users']['activeUsers'],
          'admin': allStats['users']['adminUsers'],
        },
        'files': {
          'total': allStats['files']['totalFiles'],
          'active': allStats['files']['activeFiles'],
        },
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('❌ DirectStatisticsUpdateService: Error getting statistics summary - $e');
      return {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }
}
