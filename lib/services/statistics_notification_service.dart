import 'dart:async';
import 'package:flutter/foundation.dart';

/// Centralized service for managing statistics updates and notifications
/// Provides real-time statistics refresh capabilities across the application
class StatisticsNotificationService {
  static final StatisticsNotificationService _instance = StatisticsNotificationService._internal();
  factory StatisticsNotificationService() => _instance;
  StatisticsNotificationService._internal();

  static StatisticsNotificationService get instance => _instance;

  // Stream controllers for different types of statistics updates
  final StreamController<StatisticsUpdateEvent> _statisticsUpdateController = 
      StreamController<StatisticsUpdateEvent>.broadcast();
  
  final StreamController<FileCountUpdateEvent> _fileCountUpdateController = 
      StreamController<FileCountUpdateEvent>.broadcast();
  
  final StreamController<StorageStatsUpdateEvent> _storageStatsUpdateController = 
      StreamController<StorageStatsUpdateEvent>.broadcast();

  // Streams for listening to updates
  Stream<StatisticsUpdateEvent> get statisticsUpdates => _statisticsUpdateController.stream;
  Stream<FileCountUpdateEvent> get fileCountUpdates => _fileCountUpdateController.stream;
  Stream<StorageStatsUpdateEvent> get storageStatsUpdates => _storageStatsUpdateController.stream;

  // Cache for current statistics to prevent unnecessary updates
  Map<String, dynamic>? _cachedStorageStats;
  DateTime? _lastStatsUpdate;
  static const Duration _cacheValidDuration = Duration(minutes: 2);

  /// Notify about file deletion and trigger statistics refresh
  void notifyFileDeleted({
    required String fileId,
    required String fileName,
    required String category,
    required int fileSize,
  }) {
    debugPrint('📊 StatisticsNotificationService: File deleted - $fileName');
    
    // Emit file count update event
    _fileCountUpdateController.add(FileCountUpdateEvent(
      type: FileCountUpdateType.deleted,
      fileId: fileId,
      fileName: fileName,
      category: category,
      fileSize: fileSize,
      timestamp: DateTime.now(),
    ));

    // Emit general statistics update event
    _statisticsUpdateController.add(StatisticsUpdateEvent(
      type: StatisticsUpdateType.fileDeleted,
      data: {
        'fileId': fileId,
        'fileName': fileName,
        'category': category,
        'fileSize': fileSize,
      },
      timestamp: DateTime.now(),
    ));

    // Invalidate cached statistics
    _invalidateCache();
  }

  /// Notify about file upload and trigger statistics refresh
  void notifyFileUploaded({
    required String fileId,
    required String fileName,
    required String category,
    required int fileSize,
  }) {
    debugPrint('📊 StatisticsNotificationService: File uploaded - $fileName');
    
    // Emit file count update event
    _fileCountUpdateController.add(FileCountUpdateEvent(
      type: FileCountUpdateType.added,
      fileId: fileId,
      fileName: fileName,
      category: category,
      fileSize: fileSize,
      timestamp: DateTime.now(),
    ));

    // Emit general statistics update event
    _statisticsUpdateController.add(StatisticsUpdateEvent(
      type: StatisticsUpdateType.fileUploaded,
      data: {
        'fileId': fileId,
        'fileName': fileName,
        'category': category,
        'fileSize': fileSize,
      },
      timestamp: DateTime.now(),
    ));

    // Invalidate cached statistics
    _invalidateCache();
  }

  /// Notify about storage statistics update
  void notifyStorageStatsUpdate(Map<String, dynamic> newStats) {
    debugPrint('📊 StatisticsNotificationService: Storage stats updated');
    
    // Update cache
    _cachedStorageStats = Map.from(newStats);
    _lastStatsUpdate = DateTime.now();

    // Emit storage stats update event
    _storageStatsUpdateController.add(StorageStatsUpdateEvent(
      stats: newStats,
      timestamp: DateTime.now(),
    ));

    // Emit general statistics update event
    _statisticsUpdateController.add(StatisticsUpdateEvent(
      type: StatisticsUpdateType.storageStatsRefreshed,
      data: newStats,
      timestamp: DateTime.now(),
    ));
  }

  /// Request immediate statistics refresh
  void requestStatisticsRefresh({String? reason}) {
    debugPrint('📊 StatisticsNotificationService: Statistics refresh requested - $reason');
    
    _statisticsUpdateController.add(StatisticsUpdateEvent(
      type: StatisticsUpdateType.refreshRequested,
      data: {'reason': reason ?? 'Manual refresh'},
      timestamp: DateTime.now(),
    ));

    // Invalidate cache to force fresh data
    _invalidateCache();
  }

  /// Get cached storage statistics if valid
  Map<String, dynamic>? getCachedStorageStats() {
    if (_cachedStorageStats == null || _lastStatsUpdate == null) {
      return null;
    }

    final isValid = DateTime.now().difference(_lastStatsUpdate!) < _cacheValidDuration;
    return isValid ? Map.from(_cachedStorageStats!) : null;
  }

  /// Check if cached statistics are valid
  bool get hasCachedStats => getCachedStorageStats() != null;

  /// Invalidate cached statistics
  void _invalidateCache() {
    _cachedStorageStats = null;
    _lastStatsUpdate = null;
    debugPrint('📊 StatisticsNotificationService: Cache invalidated');
  }

  /// Dispose of all stream controllers
  void dispose() {
    _statisticsUpdateController.close();
    _fileCountUpdateController.close();
    _storageStatsUpdateController.close();
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
enum FileCountUpdateType {
  added,
  deleted,
  modified,
}

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
  String toString() => 'StatisticsUpdateEvent(type: $type, timestamp: $timestamp)';
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

  StorageStatsUpdateEvent({
    required this.stats,
    required this.timestamp,
  });

  @override
  String toString() => 'StorageStatsUpdateEvent(timestamp: $timestamp)';
}
