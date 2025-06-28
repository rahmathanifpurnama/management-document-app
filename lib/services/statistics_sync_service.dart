import 'package:flutter/foundation.dart';
import 'statistics_notification_service.dart';
import 'optimized_statistics_service.dart';

/// Service to synchronize statistics updates across providers
/// Ensures real-time statistics updates when data changes
class StatisticsSyncService {
  static final StatisticsSyncService _instance =
      StatisticsSyncService._internal();
  factory StatisticsSyncService() => _instance;
  StatisticsSyncService._internal();

  static StatisticsSyncService get instance => _instance;

  final StatisticsNotificationService _notificationService =
      StatisticsNotificationService.instance;
  final OptimizedStatisticsService _statsService =
      OptimizedStatisticsService.instance;

  bool _isInitialized = false;

  /// Initialize the sync service
  void initialize() {
    if (_isInitialized) {
      debugPrint('📊 StatisticsSyncService: Already initialized');
      return;
    }

    debugPrint('📊 StatisticsSyncService: Initializing...');

    _isInitialized = true;
    debugPrint('✅ StatisticsSyncService: Initialized successfully');
  }

  /// Trigger statistics update
  void _triggerStatisticsUpdate(String reason) {
    debugPrint(
      '📊 StatisticsSyncService: Triggering statistics update - $reason',
    );

    // Invalidate cache to force fresh calculation
    _statsService.invalidateCache(reason: reason);

    // Notify statistics update
    _notificationService.requestStatisticsRefresh(reason: reason);
  }

  /// Manually trigger statistics refresh
  void refreshStatistics({String? reason}) {
    debugPrint('📊 StatisticsSyncService: Manual refresh requested');
    _triggerStatisticsUpdate(reason ?? 'Manual refresh');
  }

  /// Notify file uploaded
  void notifyFileUploaded({
    required String fileId,
    required String fileName,
    required String category,
    required int fileSize,
  }) {
    debugPrint('📊 StatisticsSyncService: File uploaded - $fileName');

    _notificationService.notifyFileUploaded(
      fileId: fileId,
      fileName: fileName,
      category: category,
      fileSize: fileSize,
    );

    _triggerStatisticsUpdate('File uploaded: $fileName');
  }

  /// Notify file deleted
  void notifyFileDeleted({
    required String fileId,
    required String fileName,
    required String category,
    required int fileSize,
  }) {
    debugPrint('📊 StatisticsSyncService: File deleted - $fileName');

    _notificationService.notifyFileDeleted(
      fileId: fileId,
      fileName: fileName,
      category: category,
      fileSize: fileSize,
    );

    _triggerStatisticsUpdate('File deleted: $fileName');
  }

  /// Notify category created
  void notifyCategoryCreated({
    required String categoryId,
    required String categoryName,
  }) {
    debugPrint('📊 StatisticsSyncService: Category created - $categoryName');
    _triggerStatisticsUpdate('Category created: $categoryName');
  }

  /// Notify category deleted
  void notifyCategoryDeleted({
    required String categoryId,
    required String categoryName,
  }) {
    debugPrint('📊 StatisticsSyncService: Category deleted - $categoryName');
    _triggerStatisticsUpdate('Category deleted: $categoryName');
  }

  /// Notify user created
  void notifyUserCreated({required String userId, required String userName}) {
    debugPrint('📊 StatisticsSyncService: User created - $userName');
    _triggerStatisticsUpdate('User created: $userName');
  }

  /// Notify user deleted
  void notifyUserDeleted({required String userId, required String userName}) {
    debugPrint('📊 StatisticsSyncService: User deleted - $userName');
    _triggerStatisticsUpdate('User deleted: $userName');
  }

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Dispose resources
  void dispose() {
    debugPrint('📊 StatisticsSyncService: Disposing...');

    _isInitialized = false;

    debugPrint('✅ StatisticsSyncService: Disposed');
  }
}
