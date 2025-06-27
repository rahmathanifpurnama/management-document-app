import 'dart:async';
import 'package:flutter/foundation.dart';
import 'optimized_statistics_service.dart';
import 'performance_optimized_stats_service.dart';

/// ENHANCED: Centralized service for managing statistics updates and notifications
/// Provides real-time statistics refresh capabilities across the application
/// Now optimized for large datasets (1M+ files) with intelligent caching and batching
class StatisticsNotificationService {
  static final StatisticsNotificationService _instance =
      StatisticsNotificationService._internal();
  factory StatisticsNotificationService() => _instance;
  StatisticsNotificationService._internal();

  static StatisticsNotificationService get instance => _instance;

  // Enhanced services integration
  final OptimizedStatisticsService _optimizedStatsService =
      OptimizedStatisticsService.instance;
  final PerformanceOptimizedStatsService _performanceStatsService =
      PerformanceOptimizedStatsService.instance;

  // Stream controllers for different types of statistics updates
  final StreamController<StatisticsUpdateEvent> _statisticsUpdateController =
      StreamController<StatisticsUpdateEvent>.broadcast();

  final StreamController<FileCountUpdateEvent> _fileCountUpdateController =
      StreamController<FileCountUpdateEvent>.broadcast();

  final StreamController<StorageStatsUpdateEvent>
  _storageStatsUpdateController =
      StreamController<StorageStatsUpdateEvent>.broadcast();

  // Streams for listening to updates
  Stream<StatisticsUpdateEvent> get statisticsUpdates =>
      _statisticsUpdateController.stream;
  Stream<FileCountUpdateEvent> get fileCountUpdates =>
      _fileCountUpdateController.stream;
  Stream<StorageStatsUpdateEvent> get storageStatsUpdates =>
      _storageStatsUpdateController.stream;

  // Cache for current statistics to prevent unnecessary updates
  Map<String, dynamic>? _cachedStorageStats;
  DateTime? _lastStatsUpdate;
  static const Duration _cacheValidDuration = Duration(minutes: 2);

  // ENHANCED: Batching system for high-frequency operations
  final List<Map<String, dynamic>> _pendingOperations = [];
  Timer? _batchTimer;
  static const Duration _batchDelay = Duration(milliseconds: 500);
  static const int _maxBatchSize = 100;

  /// Notify about file deletion and trigger statistics refresh
  void notifyFileDeleted({
    required String fileId,
    required String fileName,
    required String category,
    required int fileSize,
  }) {
    debugPrint('📊 StatisticsNotificationService: File deleted - $fileName');

    // ENHANCED: Invalidate all caches immediately when file is deleted
    _invalidateCache();

    // Emit file count update event
    _fileCountUpdateController.add(
      FileCountUpdateEvent(
        type: FileCountUpdateType.deleted,
        fileId: fileId,
        fileName: fileName,
        category: category,
        fileSize: fileSize,
        timestamp: DateTime.now(),
      ),
    );

    // Emit general statistics update event
    _statisticsUpdateController.add(
      StatisticsUpdateEvent(
        type: StatisticsUpdateType.fileDeleted,
        data: {
          'fileId': fileId,
          'fileName': fileName,
          'category': category,
          'fileSize': fileSize,
        },
        timestamp: DateTime.now(),
      ),
    );

    // ENHANCED: Force immediate statistics refresh for real-time updates
    requestStatisticsRefresh(reason: 'File deleted: $fileName');

    // Add to batch for optimized processing
    _addToBatch({
      'type': 'fileDeleted',
      'fileId': fileId,
      'fileName': fileName,
      'category': category,
      'fileSize': fileSize,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Notify about file upload and trigger statistics refresh
  void notifyFileUploaded({
    required String fileId,
    required String fileName,
    required String category,
    required int fileSize,
  }) {
    debugPrint('📊 StatisticsNotificationService: File uploaded - $fileName');

    // ENHANCED: Invalidate all caches immediately when file is uploaded
    _invalidateCache();

    // Emit file count update event
    _fileCountUpdateController.add(
      FileCountUpdateEvent(
        type: FileCountUpdateType.added,
        fileId: fileId,
        fileName: fileName,
        category: category,
        fileSize: fileSize,
        timestamp: DateTime.now(),
      ),
    );

    // Emit general statistics update event
    _statisticsUpdateController.add(
      StatisticsUpdateEvent(
        type: StatisticsUpdateType.fileUploaded,
        data: {
          'fileId': fileId,
          'fileName': fileName,
          'category': category,
          'fileSize': fileSize,
        },
        timestamp: DateTime.now(),
      ),
    );

    // ENHANCED: Force immediate statistics refresh for real-time updates
    requestStatisticsRefresh(reason: 'File uploaded: $fileName');

    // Add to batch for optimized processing
    _addToBatch({
      'type': 'fileUploaded',
      'fileId': fileId,
      'fileName': fileName,
      'category': category,
      'fileSize': fileSize,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Notify about storage statistics update
  void notifyStorageStatsUpdate(Map<String, dynamic> newStats) {
    debugPrint('📊 StatisticsNotificationService: Storage stats updated');

    // Update cache
    _cachedStorageStats = Map.from(newStats);
    _lastStatsUpdate = DateTime.now();

    // Emit storage stats update event
    _storageStatsUpdateController.add(
      StorageStatsUpdateEvent(stats: newStats, timestamp: DateTime.now()),
    );

    // Emit general statistics update event
    _statisticsUpdateController.add(
      StatisticsUpdateEvent(
        type: StatisticsUpdateType.storageStatsRefreshed,
        data: newStats,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Request immediate statistics refresh
  void requestStatisticsRefresh({String? reason}) {
    debugPrint(
      '📊 StatisticsNotificationService: Statistics refresh requested - $reason',
    );

    _statisticsUpdateController.add(
      StatisticsUpdateEvent(
        type: StatisticsUpdateType.refreshRequested,
        data: {'reason': reason ?? 'Manual refresh'},
        timestamp: DateTime.now(),
      ),
    );

    // Invalidate cache to force fresh data
    _invalidateCache();
  }

  /// Get cached storage statistics if valid
  Map<String, dynamic>? getCachedStorageStats() {
    if (_cachedStorageStats == null || _lastStatsUpdate == null) {
      return null;
    }

    final isValid =
        DateTime.now().difference(_lastStatsUpdate!) < _cacheValidDuration;
    return isValid ? Map.from(_cachedStorageStats!) : null;
  }

  /// Check if cached statistics are valid
  bool get hasCachedStats => getCachedStorageStats() != null;

  /// ENHANCED: Add operation to batch for processing
  void _addToBatch(Map<String, dynamic> operation) {
    _pendingOperations.add(operation);

    // Process immediately if batch is full
    if (_pendingOperations.length >= _maxBatchSize) {
      _processBatch();
      return;
    }

    // Schedule batch processing
    _batchTimer?.cancel();
    _batchTimer = Timer(_batchDelay, _processBatch);
  }

  /// ENHANCED: Process batched operations for performance
  void _processBatch() {
    if (_pendingOperations.isEmpty) return;

    debugPrint(
      '📊 StatisticsNotificationService: Processing batch of ${_pendingOperations.length} operations',
    );

    // Invalidate cache for all optimized services
    _optimizedStatsService.invalidateCache(
      reason: 'Batch operations processed',
    );
    _performanceStatsService.clearCache();

    // Clear batch
    _pendingOperations.clear();
    _batchTimer?.cancel();
    _batchTimer = null;
  }

  /// ENHANCED: Invalidate cached statistics across all services
  void _invalidateCache() {
    _cachedStorageStats = null;
    _lastStatsUpdate = null;

    // Invalidate optimized services caches
    _optimizedStatsService.invalidateCache(
      reason: 'Statistics cache invalidated',
    );
    _performanceStatsService.clearCache();

    debugPrint('📊 StatisticsNotificationService: Cache invalidated');
  }

  /// ENHANCED: Get performance metrics
  Map<String, dynamic> getPerformanceMetrics() {
    final memoryStats = _performanceStatsService.getMemoryUsage();

    return {
      'cacheSize': memoryStats.cacheSize,
      'maxCacheSize': memoryStats.maxCacheSize,
      'memoryUsage': memoryStats.memoryUsageFormatted,
      'cacheHitRate': '${(memoryStats.cacheHitRate * 100).toStringAsFixed(1)}%',
      'pendingOperations': _pendingOperations.length,
      'isNearCapacity': memoryStats.isNearCapacity,
    };
  }

  /// ENHANCED: Force immediate statistics refresh across all services
  Future<void> forceRefreshAll({String? reason}) async {
    debugPrint('🔄 StatisticsNotificationService: Force refresh all - $reason');

    // Process any pending batches immediately
    _processBatch();

    // Invalidate all caches
    _invalidateCache();

    // Request fresh data from optimized service
    await _optimizedStatsService.getAggregatedStatistics(forceRefresh: true);

    // Emit refresh event
    requestStatisticsRefresh(reason: reason ?? 'Force refresh all');
  }

  /// ENHANCED: Dispose of all stream controllers and timers
  void dispose() {
    _batchTimer?.cancel();
    _statisticsUpdateController.close();
    _fileCountUpdateController.close();
    _storageStatsUpdateController.close();
    _performanceStatsService.dispose();
    debugPrint('📊 StatisticsNotificationService: Disposed');
  }
}

/// Event types for statistics updates
enum StatisticsUpdateType {
  fileDeleted,
  fileUploaded,
  storageStatsRefreshed,
  refreshRequested,
}

/// Event types for file count updates
enum FileCountUpdateType { added, deleted, modified }

/// General statistics update event
class StatisticsUpdateEvent {
  final StatisticsUpdateType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  StatisticsUpdateEvent({
    required this.type,
    required this.data,
    required this.timestamp,
  });

  @override
  String toString() =>
      'StatisticsUpdateEvent(type: $type, timestamp: $timestamp)';
}

/// File count specific update event
class FileCountUpdateEvent {
  final FileCountUpdateType type;
  final String fileId;
  final String fileName;
  final String category;
  final int fileSize;
  final DateTime timestamp;

  FileCountUpdateEvent({
    required this.type,
    required this.fileId,
    required this.fileName,
    required this.category,
    required this.fileSize,
    required this.timestamp,
  });

  @override
  String toString() => 'FileCountUpdateEvent(type: $type, fileName: $fileName)';
}

/// Storage statistics update event
class StorageStatsUpdateEvent {
  final Map<String, dynamic> stats;
  final DateTime timestamp;

  StorageStatsUpdateEvent({required this.stats, required this.timestamp});

  @override
  String toString() => 'StorageStatsUpdateEvent(timestamp: $timestamp)';
}
