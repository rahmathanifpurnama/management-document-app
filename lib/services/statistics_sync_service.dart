import 'dart:async';
import 'package:flutter/foundation.dart';
import '../providers/document_provider.dart';
import '../providers/category_provider.dart';
import '../providers/user_provider.dart';
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

  // Provider listeners
  DocumentProvider? _documentProvider;
  CategoryProvider? _categoryProvider;
  UserProvider? _userProvider;

  // Debounce timer to prevent excessive updates
  Timer? _debounceTimer;
  static const Duration _debounceDelay = Duration(milliseconds: 500);

  bool _isInitialized = false;

  /// Initialize the sync service with providers
  void initialize({
    required DocumentProvider documentProvider,
    required CategoryProvider categoryProvider,
    required UserProvider userProvider,
  }) {
    if (_isInitialized) {
      debugPrint('📊 StatisticsSyncService: Already initialized');
      return;
    }

    debugPrint('📊 StatisticsSyncService: Initializing...');

    _documentProvider = documentProvider;
    _categoryProvider = categoryProvider;
    _userProvider = userProvider;

    _setupProviderListeners();
    _isInitialized = true;

    debugPrint('✅ StatisticsSyncService: Initialized successfully');
  }

  /// Setup listeners for all providers
  void _setupProviderListeners() {
    // Listen to document changes
    _documentProvider?.addListener(_onDocumentProviderChanged);

    // Listen to category changes
    _categoryProvider?.addListener(_onCategoryProviderChanged);

    // Listen to user changes
    _userProvider?.addListener(_onUserProviderChanged);
  }

  /// Handle document provider changes
  void _onDocumentProviderChanged() {
    debugPrint('📊 StatisticsSyncService: Document provider changed');
    _scheduleStatisticsUpdate('Document provider changed');
  }

  /// Handle category provider changes
  void _onCategoryProviderChanged() {
    debugPrint('📊 StatisticsSyncService: Category provider changed');
    _scheduleStatisticsUpdate('Category provider changed');
  }

  /// Handle user provider changes
  void _onUserProviderChanged() {
    debugPrint('📊 StatisticsSyncService: User provider changed');
    _scheduleStatisticsUpdate('User provider changed');
  }

  /// Schedule statistics update with debouncing
  void _scheduleStatisticsUpdate(String reason) {
    // Cancel existing timer
    _debounceTimer?.cancel();

    // Schedule new update
    _debounceTimer = Timer(_debounceDelay, () {
      _triggerStatisticsUpdate(reason);
    });
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

  /// Get current statistics from providers (fallback method)
  Map<String, dynamic> getCurrentStatisticsFromProviders() {
    if (!_isInitialized) {
      debugPrint(
        '⚠️ StatisticsSyncService: Not initialized, returning empty stats',
      );
      return _getEmptyStats();
    }

    try {
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));

      // Calculate recent files (standardized to 7 days)
      final recentFiles =
          _documentProvider?.documents.where((doc) {
            return doc.uploadedAt.isAfter(sevenDaysAgo);
          }).length ??
          0;

      // Debug logging for statistics coordination
      debugPrint('📊 StatisticsSyncService: Calculating statistics');
      debugPrint('   Total files: ${_documentProvider?.documents.length ?? 0}');
      debugPrint('   Recent files (7 days): $recentFiles');
      debugPrint('   Active users: ${_userProvider?.users.length ?? 0}');
      debugPrint(
        '   Total categories: ${_categoryProvider?.categories.length ?? 0}',
      );

      final stats = {
        'totalFiles': _documentProvider?.documents.length ?? 0,
        'activeUsers': _userProvider?.users.length ?? 0,
        'totalCategories': _categoryProvider?.categories.length ?? 0,
        'recentFiles': recentFiles,
        'fileTypeStats': <String, int>{},
        'totalStorageSize': 0,
        'lastCalculated': now.toIso8601String(),
        'calculationDurationMs': 0,
      };

      debugPrint(
        '📊 StatisticsSyncService: Current stats from providers: $stats',
      );
      return stats;
    } catch (e) {
      debugPrint(
        '❌ StatisticsSyncService: Error getting stats from providers: $e',
      );
      return _getEmptyStats();
    }
  }

  /// Get empty statistics structure
  Map<String, dynamic> _getEmptyStats() {
    return {
      'totalFiles': 0,
      'activeUsers': 0,
      'totalCategories': 0,
      'recentFiles': 0,
      'fileTypeStats': <String, int>{},
      'totalStorageSize': 0,
      'lastCalculated': DateTime.now().toIso8601String(),
      'calculationDurationMs': 0,
    };
  }

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Dispose resources
  void dispose() {
    debugPrint('📊 StatisticsSyncService: Disposing...');

    _debounceTimer?.cancel();

    // Remove listeners
    _documentProvider?.removeListener(_onDocumentProviderChanged);
    _categoryProvider?.removeListener(_onCategoryProviderChanged);
    _userProvider?.removeListener(_onUserProviderChanged);

    _documentProvider = null;
    _categoryProvider = null;
    _userProvider = null;

    _isInitialized = false;

    debugPrint('✅ StatisticsSyncService: Disposed');
  }
}
