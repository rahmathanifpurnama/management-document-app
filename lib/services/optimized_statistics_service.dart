import 'dart:async';
import 'package:flutter/material.dart';
import '../core/services/firebase_service.dart';
import '../models/document_model.dart';

/// Optimized statistics service for handling large datasets (1M+ files)
/// Uses Cloud Functions, intelligent caching, and streaming for performance
class OptimizedStatisticsService {
  static final OptimizedStatisticsService _instance =
      OptimizedStatisticsService._internal();
  factory OptimizedStatisticsService() => _instance;
  OptimizedStatisticsService._internal();

  static OptimizedStatisticsService get instance => _instance;

  final FirebaseService _firebaseService = FirebaseService.instance;

  // Cache management
  Map<String, dynamic>? _cachedStats;
  DateTime? _lastCacheTime;
  static const Duration _cacheValidDuration = Duration(minutes: 5);

  // Stream controllers for real-time updates
  final StreamController<Map<String, dynamic>> _statsStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get statsStream => _statsStreamController.stream;

  /// Get aggregated statistics optimized for large datasets
  Future<Map<String, dynamic>> getAggregatedStatistics({
    bool forceRefresh = false,
  }) async {
    try {
      // Check cache first unless force refresh
      if (!forceRefresh && _isCacheValid()) {
        debugPrint('📊 OptimizedStatisticsService: Using cached statistics');
        return _cachedStats!;
      }

      debugPrint('📊 OptimizedStatisticsService: Fetching fresh statistics...');

      // Call Cloud Function for optimized statistics
      final callable = _firebaseService.functions.httpsCallable(
        'getAggregatedStatistics',
      );
      final result = await callable.call();

      final stats = Map<String, dynamic>.from(result.data);

      // Update cache
      _cachedStats = stats;
      _lastCacheTime = DateTime.now();

      // Emit to stream
      _statsStreamController.add(stats);

      debugPrint(
        '✅ OptimizedStatisticsService: Statistics fetched successfully',
      );
      return stats;
    } catch (e) {
      debugPrint(
        '❌ OptimizedStatisticsService: Error fetching statistics - $e',
      );

      // Return cached data if available, otherwise return empty stats
      if (_cachedStats != null) {
        debugPrint('⚠️ Using cached statistics due to error');
        return _cachedStats!;
      }

      return _getEmptyStats();
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

  /// Dispose resources
  void dispose() {
    _statsStreamController.close();
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
