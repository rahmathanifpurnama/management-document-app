import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/services/firebase_service.dart';
import '../models/document_model.dart';
import 'timestamp_debug_service.dart';
import 'real_time_sync_service.dart';
import 'cloud_functions_service.dart';

/// Optimized statistics service for handling large datasets (1M+ files)
/// Uses Cloud Functions, intelligent caching, and streaming for performance
class OptimizedStatisticsService {
  static final OptimizedStatisticsService _instance =
      OptimizedStatisticsService._internal();
  factory OptimizedStatisticsService() => _instance;
  OptimizedStatisticsService._internal();

  static OptimizedStatisticsService get instance => _instance;

  final FirebaseService _firebaseService = FirebaseService.instance;
  final RealTimeSyncService _realTimeSyncService = RealTimeSyncService.instance;

  // Cache management
  Map<String, dynamic>? _cachedStats;
  DateTime? _lastCacheTime;
  static const Duration _cacheValidDuration = Duration(minutes: 5);

  // Stream controllers for real-time updates
  final StreamController<Map<String, dynamic>> _statsStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  // Real-time sync subscription
  StreamSubscription<Map<String, dynamic>>? _realTimeSyncSubscription;
  StreamSubscription<SyncEvent>? _syncEventsSubscription;

  // Prevent excessive updates
  bool _isUpdatingStatistics = false;
  DateTime? _lastUpdateTime;
  static const Duration _minUpdateInterval = Duration(seconds: 5);

  Stream<Map<String, dynamic>> get statsStream => _statsStreamController.stream;

  /// Get aggregated statistics optimized for large datasets
  Future<Map<String, dynamic>> getAggregatedStatistics({
    bool forceRefresh = false,
  }) async {
    try {
      // FIXED: Always use real-time queries for delete operations and critical updates
      // Only use cache for non-critical requests with very short cache duration
      if (!forceRefresh && _isCacheValid() && _isNonCriticalRequest()) {
        debugPrint('📊 OptimizedStatisticsService: Using cached statistics');
        return _cachedStats!;
      }

      debugPrint(
        '📊 OptimizedStatisticsService: Fetching fresh real-time statistics...',
      );

      // Try Cloud Function first
      try {
        final callable = _firebaseService.functions.httpsCallable(
          'getAggregatedStatistics',
        );
        final result = await callable.call().timeout(
          const Duration(seconds: 10),
        );

        final stats = Map<String, dynamic>.from(result.data);

        // Update cache
        _cachedStats = stats;
        _lastCacheTime = DateTime.now();

        // Emit to stream
        _statsStreamController.add(stats);

        debugPrint(
          '✅ OptimizedStatisticsService: Statistics fetched from Cloud Function',
        );
        return stats;
      } catch (cloudError) {
        debugPrint(
          '⚠️ Cloud Function failed, falling back to direct Firestore: $cloudError',
        );

        // Fallback to direct Firestore queries
        final stats = await _calculateStatisticsDirectly();

        // Update cache
        _cachedStats = stats;
        _lastCacheTime = DateTime.now();

        // Emit to stream
        _statsStreamController.add(stats);

        debugPrint(
          '✅ OptimizedStatisticsService: Statistics calculated directly',
        );
        return stats;
      }
    } catch (e) {
      debugPrint(
        '❌ OptimizedStatisticsService: Error fetching statistics - $e',
      );

      // Return cached data if available, otherwise calculate directly
      if (_cachedStats != null) {
        debugPrint('⚠️ Using cached statistics due to error');
        return _cachedStats!;
      }

      // Last resort: try direct calculation
      try {
        final stats = await _calculateStatisticsDirectly();
        return stats;
      } catch (directError) {
        debugPrint('❌ Direct calculation also failed: $directError');
        return _getEmptyStats();
      }
    }
  }

  /// Get paginated file statistics for detailed breakdowns
  Future<PaginatedFileStats> getPaginatedFileStats({
    int page = 1,
    int limit = 50,
    String? category,
    String? fileType,
    String sortBy = 'uploadedAt',
    String sortOrder = 'desc',
  }) async {
    try {
      debugPrint(
        '📄 OptimizedStatisticsService: Getting paginated stats (page: $page)',
      );

      final callable = _firebaseService.functions.httpsCallable(
        'getPaginatedFileStats',
      );
      final result = await callable.call({
        'page': page,
        'limit': limit,
        'category': category,
        'fileType': fileType,
        'sortBy': sortBy,
        'sortOrder': sortOrder,
      });

      final data = Map<String, dynamic>.from(result.data);
      return PaginatedFileStats.fromMap(data);
    } catch (e) {
      debugPrint(
        '❌ OptimizedStatisticsService: Error getting paginated stats - $e',
      );
      return PaginatedFileStats.empty();
    }
  }

  /// Invalidate statistics cache
  Future<void> invalidateCache({String? reason}) async {
    try {
      debugPrint(
        '🗑️ OptimizedStatisticsService: Invalidating cache - $reason',
      );

      // Clear local cache
      _cachedStats = null;
      _lastCacheTime = null;

      // Invalidate server cache
      final callable = _firebaseService.functions.httpsCallable(
        'invalidateStatisticsCache',
      );
      await callable.call();

      debugPrint('✅ OptimizedStatisticsService: Cache invalidated');
    } catch (e) {
      debugPrint('❌ OptimizedStatisticsService: Error invalidating cache - $e');
    }
  }

  /// Get statistics stream for real-time updates
  Stream<Map<String, dynamic>> getStatisticsStream() async* {
    // Emit cached data immediately if available
    if (_isCacheValid()) {
      yield _cachedStats!;
    }

    // Fetch fresh data
    try {
      final freshStats = await getAggregatedStatistics();
      yield freshStats;
    } catch (e) {
      debugPrint('❌ Error in statistics stream: $e');
    }

    // Listen to stream updates
    yield* _statsStreamController.stream;
  }

  /// Check if cache is valid
  bool _isCacheValid() {
    return _cachedStats != null &&
        _lastCacheTime != null &&
        DateTime.now().difference(_lastCacheTime!) < _cacheValidDuration;
  }

  /// Check if this is a non-critical request that can use cached data
  bool _isNonCriticalRequest() {
    // For now, always return false to prioritize real-time data
    // This ensures statistics are always fresh after delete operations
    return false;
  }

  /// Calculate statistics directly from Firestore (fallback method)
  Future<Map<String, dynamic>> _calculateStatisticsDirectly() async {
    debugPrint('📊 Calculating statistics directly from Firestore...');

    try {
      final firestore = _firebaseService.firestore;
      final startTime = DateTime.now();

      // Check if user is authenticated first
      if (_firebaseService.auth.currentUser == null) {
        debugPrint('❌ User not authenticated for statistics calculation');
        return _getEmptyStats();
      }

      // Execute basic count queries with error handling for each
      int totalFiles = 0;
      int activeUsers = 0;
      int totalCategories = 0;

      // Try to get total files count
      try {
        final filesSnapshot = await firestore
            .collection('documents')
            .where('isActive', isEqualTo: true)
            .count()
            .get();
        totalFiles = filesSnapshot.count ?? 0;
      } catch (e) {
        debugPrint('⚠️ Failed to get files count, using fallback: $e');
        // Fallback: use 0 for now, will be updated by storage sync
        totalFiles = 0;
      }

      // Try to get user count
      try {
        activeUsers = await _getFirebaseAuthUserCount();
      } catch (e) {
        debugPrint('⚠️ Failed to get user count: $e');
        activeUsers = 1; // At least current user
      }

      // Try to get categories count
      try {
        final categoriesSnapshot = await firestore
            .collection('categories')
            .where('isActive', isEqualTo: true)
            .count()
            .get();
        totalCategories = categoriesSnapshot.count ?? 0;
      } catch (e) {
        debugPrint('⚠️ Failed to get categories count: $e');
        totalCategories = 0;
      }

      // TIMESTAMP FIX: Enhanced recent files calculation with proper server-side timestamp handling
      // Get recent files by fetching documents and counting them locally (last 7 days)
      int recentFilesCount = 0;
      try {
        // Use Firestore Timestamp for server-side consistency
        final sevenDaysAgo = Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 7)),
        );
        debugPrint(
          '📊 Calculating recent files since: ${sevenDaysAgo.toDate()}',
        );
        debugPrint('📊 Current server time reference: ${DateTime.now()}');

        final recentFilesSnapshot = await firestore
            .collection('documents')
            .where('isActive', isEqualTo: true)
            .where('uploadedAt', isGreaterThanOrEqualTo: sevenDaysAgo)
            .limit(1000) // Limit to prevent excessive reads
            .get();

        recentFilesCount = recentFilesSnapshot.docs.length;
        debugPrint('📊 Recent files count (last 7 days): $recentFilesCount');

        // Enhanced debugging: Log sample recent files with detailed timestamp info
        if (recentFilesSnapshot.docs.isNotEmpty) {
          debugPrint('📊 Sample recent files for verification:');
          final sampleDocs = recentFilesSnapshot.docs.take(5);
          for (final doc in sampleDocs) {
            final data = doc.data();
            final uploadedAt = data['uploadedAt'];
            final uploadedAtDate = uploadedAt is Timestamp
                ? uploadedAt.toDate()
                : uploadedAt;
            final daysDiff = DateTime.now().difference(uploadedAtDate).inDays;
            debugPrint(
              '📄 File: ${data['fileName']} | Uploaded: $uploadedAtDate | Days ago: $daysDiff',
            );
          }
        } else {
          debugPrint('⚠️ No recent files found in the last 7 days');

          // ENHANCED DEBUGGING: Run comprehensive timestamp analysis
          debugPrint('🔍 Running comprehensive timestamp analysis...');
          await TimestampDebugService.instance.monitorRecentFilesStatistics();

          // Additional debugging: Check if there are any files at all
          final totalFilesSnapshot = await firestore
              .collection('documents')
              .where('isActive', isEqualTo: true)
              .limit(5)
              .get();

          debugPrint(
            '📊 Total active files sample (${totalFilesSnapshot.docs.length}):',
          );
          for (final doc in totalFilesSnapshot.docs) {
            final data = doc.data();
            final uploadedAt = data['uploadedAt'];
            final uploadedAtDate = uploadedAt is Timestamp
                ? uploadedAt.toDate()
                : uploadedAt;
            final daysDiff = DateTime.now().difference(uploadedAtDate).inDays;
            debugPrint(
              '📄 File: ${data['fileName']} | Uploaded: $uploadedAtDate | Days ago: $daysDiff',
            );
          }
        }
      } catch (recentFilesError) {
        debugPrint(
          '⚠️ Could not calculate recent files, using 0: $recentFilesError',
        );
        debugPrint('⚠️ Error details: ${recentFilesError.toString()}');
        recentFilesCount = 0;
      }

      final stats = {
        'totalFiles': totalFiles,
        'activeUsers': activeUsers,
        'totalCategories': totalCategories,
        'recentFiles': recentFilesCount,
        'fileTypeStats': <String, int>{},
        'totalStorageSize': 0,
        'lastCalculated': startTime.toIso8601String(),
        'calculationDurationMs': DateTime.now()
            .difference(startTime)
            .inMilliseconds,
      };

      debugPrint('✅ Direct statistics calculation completed: $stats');
      return stats;
    } catch (e) {
      debugPrint('❌ Direct statistics calculation failed: $e');
      rethrow;
    }
  }

  /// Get Firebase Authentication user count (real-time)
  /// This method queries the Firestore users collection for active users
  /// and ensures sync with Firebase Auth users if needed
  Future<int> _getFirebaseAuthUserCount() async {
    try {
      final firestore = _firebaseService.firestore;

      // First try to auto-sync users to ensure they exist in Firestore
      await _autoSyncFirebaseAuthUsers();

      // Query active users from Firestore users collection
      final usersSnapshot = await firestore
          .collection('users')
          .where('isActive', isEqualTo: true)
          .count()
          .get();

      final userCount = usersSnapshot.count ?? 0;

      // If still no users, return at least 1 (current user)
      return userCount > 0 ? userCount : 1;
    } catch (e) {
      debugPrint('❌ Error getting user count from Firestore: $e');

      // If permission denied, try to sync users first
      if (e.toString().contains('PERMISSION_DENIED')) {
        debugPrint('🔄 Permission denied, attempting user sync...');
        try {
          await _autoSyncFirebaseAuthUsers();
          return 1; // At least current user exists
        } catch (syncError) {
          debugPrint('❌ User sync also failed: $syncError');
        }
      }

      return 1; // Return at least 1 user (current authenticated user)
    }
  }

  /// Auto-sync Firebase Auth users to Firestore (silent operation)
  Future<void> _autoSyncFirebaseAuthUsers() async {
    try {
      final cloudFunctions = CloudFunctionsService.instance;
      await cloudFunctions.autoSyncFirebaseAuthUsers();
    } catch (e) {
      // Silent fail - don't disrupt statistics if sync fails
      debugPrint('⚠️ Auto-sync Firebase Auth users failed: $e');
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

  /// Initialize real-time synchronization
  Future<void> initializeRealTimeSync() async {
    try {
      debugPrint(
        '🔄 OptimizedStatisticsService: Initializing real-time sync...',
      );

      // Initialize real-time sync service if not already done
      if (!_realTimeSyncService.isInitialized) {
        await _realTimeSyncService.initialize();
      }

      // Subscribe to real-time statistics updates
      _realTimeSyncSubscription = _realTimeSyncService.statisticsStream.listen(
        (stats) {
          if (_shouldUpdateStatistics()) {
            debugPrint('📊 Real-time statistics update received');
            _updateStatisticsCache(stats);
          } else {
            debugPrint('⏳ Skipping statistics update - too frequent');
          }
        },
        onError: (error) {
          debugPrint('❌ Real-time statistics error: $error');
        },
      );

      // Listen to sync events for cache invalidation (with throttling)
      _syncEventsSubscription = _realTimeSyncService.syncEventsStream.listen((
        event,
      ) {
        if (_shouldProcessSyncEvent(event)) {
          debugPrint(
            '🔄 Sync event detected: ${event.type} - invalidating cache',
          );
          _invalidateCache();
        }
      });

      debugPrint('✅ OptimizedStatisticsService: Real-time sync initialized');
    } catch (e) {
      debugPrint('❌ Error initializing real-time sync: $e');
      rethrow;
    }
  }

  /// Check if statistics should be updated (throttling)
  bool _shouldUpdateStatistics() {
    if (_isUpdatingStatistics) {
      return false;
    }

    final now = DateTime.now();
    if (_lastUpdateTime != null &&
        now.difference(_lastUpdateTime!) < _minUpdateInterval) {
      return false;
    }

    return true;
  }

  /// Update statistics cache with throttling
  void _updateStatisticsCache(Map<String, dynamic> stats) {
    _isUpdatingStatistics = true;
    _cachedStats = stats;
    _lastCacheTime = DateTime.now();
    _lastUpdateTime = DateTime.now();
    _statsStreamController.add(stats);
    _isUpdatingStatistics = false;
  }

  /// Check if sync event should be processed (prevent loop)
  bool _shouldProcessSyncEvent(SyncEvent event) {
    // Only process critical events that require immediate cache invalidation
    final criticalEvents = {
      SyncEventType.documentAdded,
      SyncEventType.documentRemoved,
      SyncEventType.userAdded,
      SyncEventType.userRemoved,
    };

    // Skip statistics invalidation events to prevent loops
    if (event.type == SyncEventType.statisticsInvalidated ||
        event.type == SyncEventType.statisticsUpdated) {
      return false;
    }

    return criticalEvents.contains(event.type);
  }

  /// Invalidate local cache
  void _invalidateCache() {
    _cachedStats = null;
    _lastCacheTime = null;
    debugPrint('🔄 Local statistics cache invalidated');
  }

  /// Get enhanced statistics stream with real-time updates
  Stream<Map<String, dynamic>> getEnhancedStatisticsStream() async* {
    // Initialize real-time sync if not done
    if (!_realTimeSyncService.isInitialized) {
      await initializeRealTimeSync();
    }

    // Emit cached data immediately if available
    if (_isCacheValid() && _cachedStats != null) {
      yield _cachedStats!;
    }

    // Fetch fresh data if cache is invalid
    if (!_isCacheValid()) {
      try {
        final freshStats = await getAggregatedStatistics(forceRefresh: true);
        yield freshStats;
      } catch (e) {
        debugPrint('❌ Error fetching fresh statistics: $e');
      }
    }

    // Listen to real-time updates
    yield* _statsStreamController.stream;
  }

  /// Dispose resources
  void dispose() {
    _realTimeSyncSubscription?.cancel();
    _syncEventsSubscription?.cancel();
    _statsStreamController.close();
    debugPrint('🔄 OptimizedStatisticsService disposed');
  }
}

/// Model for paginated file statistics
class PaginatedFileStats {
  final List<DocumentModel> files;
  final PaginationInfo pagination;

  const PaginatedFileStats({required this.files, required this.pagination});

  factory PaginatedFileStats.fromMap(Map<String, dynamic> map) {
    final filesData = List<Map<String, dynamic>>.from(map['files'] ?? []);
    final files = filesData
        .map((fileData) => DocumentModel.fromMap(fileData))
        .toList();

    final paginationData = Map<String, dynamic>.from(map['pagination'] ?? {});
    final pagination = PaginationInfo.fromMap(paginationData);

    return PaginatedFileStats(files: files, pagination: pagination);
  }

  factory PaginatedFileStats.empty() {
    return const PaginatedFileStats(
      files: [],
      pagination: PaginationInfo(
        page: 1,
        limit: 50,
        total: 0,
        totalPages: 0,
        hasNext: false,
        hasPrev: false,
      ),
    );
  }
}

/// Pagination information model
class PaginationInfo {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  const PaginationInfo({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory PaginationInfo.fromMap(Map<String, dynamic> map) {
    return PaginationInfo(
      page: map['page'] ?? 1,
      limit: map['limit'] ?? 50,
      total: map['total'] ?? 0,
      totalPages: map['totalPages'] ?? 0,
      hasNext: map['hasNext'] ?? false,
      hasPrev: map['hasPrev'] ?? false,
    );
  }
}

/// Statistics configuration for different stat types
class StatConfig {
  final String key;
  final String title;
  final String Function(dynamic value) formatter;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const StatConfig({
    required this.key,
    required this.title,
    required this.formatter,
    required this.icon,
    required this.color,
    this.subtitle,
  });

  /// Format large numbers with K, M, B suffixes
  static String formatLargeNumber(dynamic value) {
    if (value == null) return '0';

    final num = value is String ? int.tryParse(value) ?? 0 : value as int;

    if (num >= 1000000000) {
      return '${(num / 1000000000).toStringAsFixed(1)}B';
    } else if (num >= 1000000) {
      return '${(num / 1000000).toStringAsFixed(1)}M';
    } else if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(1)}K';
    } else {
      return num.toString();
    }
  }

  /// Format file size in bytes to human readable
  static String formatFileSize(dynamic bytes) {
    if (bytes == null) return '0 B';

    final size = bytes is String ? int.tryParse(bytes) ?? 0 : bytes as int;

    if (size >= 1024 * 1024 * 1024) {
      return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    } else if (size >= 1024 * 1024) {
      return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else if (size >= 1024) {
      return '${(size / 1024).toStringAsFixed(1)} KB';
    } else {
      return '$size B';
    }
  }
}
