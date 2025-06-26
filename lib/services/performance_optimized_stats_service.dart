import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/document_model.dart';
import 'optimized_statistics_service.dart';

/// Performance-optimized statistics service with advanced features
/// Handles 1M+ files with progressive loading, virtualization, and memory management
class PerformanceOptimizedStatsService {
  static final PerformanceOptimizedStatsService _instance =
      PerformanceOptimizedStatsService._internal();
  factory PerformanceOptimizedStatsService() => _instance;
  PerformanceOptimizedStatsService._internal();

  static PerformanceOptimizedStatsService get instance => _instance;

  final OptimizedStatisticsService _baseStatsService =
      OptimizedStatisticsService.instance;

  // Memory management
  static const int _maxCacheSize = 1000; // Maximum items in memory
  static const int _virtualPageSize = 50; // Items per virtual page
  static const Duration _memoryCleanupInterval = Duration(minutes: 10);

  // LRU Cache for paginated data
  final LinkedHashMap<String, PaginatedFileStats> _paginatedCache =
      LinkedHashMap();
  final LinkedHashMap<String, DateTime> _cacheAccessTimes = LinkedHashMap();

  // Stream controllers for progressive loading
  final StreamController<ProgressiveLoadingEvent>
  _progressiveLoadingController =
      StreamController<ProgressiveLoadingEvent>.broadcast();

  // Memory pressure monitoring
  Timer? _memoryCleanupTimer;
  int _currentMemoryUsage = 0;

  Stream<ProgressiveLoadingEvent> get progressiveLoadingStream =>
      _progressiveLoadingController.stream;

  /// Initialize the service with memory management
  void initialize() {
    _startMemoryCleanupTimer();
    debugPrint(
      '🚀 PerformanceOptimizedStatsService: Initialized with memory management',
    );
  }

  /// Get statistics with progressive loading
  Stream<Map<String, dynamic>> getProgressiveStatistics() async* {
    try {
      // Phase 1: Try to get cached stats (using public method)
      try {
        final cachedStats = await _baseStatsService.getAggregatedStatistics();
        yield cachedStats;
        _emitProgressiveEvent(
          ProgressiveLoadingPhase.cached,
          'Cached data loaded',
        );
      } catch (e) {
        // No cached data available, continue to skeleton
      }

      // Phase 2: Emit skeleton/loading state
      yield _getSkeletonStats();
      _emitProgressiveEvent(
        ProgressiveLoadingPhase.skeleton,
        'Loading fresh data...',
      );

      // Phase 3: Load and emit fresh aggregated stats
      final freshStats = await _baseStatsService.getAggregatedStatistics(
        forceRefresh: true,
      );
      yield freshStats;
      _emitProgressiveEvent(
        ProgressiveLoadingPhase.basic,
        'Basic statistics loaded',
      );

      // Phase 4: Load and emit detailed breakdowns progressively
      final detailedStats = await _loadDetailedStatistics(freshStats);
      yield detailedStats;
      _emitProgressiveEvent(
        ProgressiveLoadingPhase.detailed,
        'Detailed statistics loaded',
      );
    } catch (e) {
      _emitProgressiveEvent(ProgressiveLoadingPhase.error, 'Error: $e');
      debugPrint(
        '❌ PerformanceOptimizedStatsService: Progressive loading error - $e',
      );
    }
  }

  /// Get virtualized paginated statistics with memory management
  Future<VirtualizedStatsResult> getVirtualizedStats({
    required int startIndex,
    required int endIndex,
    String? category,
    String? fileType,
    String sortBy = 'uploadedAt',
    String sortOrder = 'desc',
  }) async {
    try {
      final cacheKey = _generateCacheKey(
        startIndex,
        endIndex,
        category,
        fileType,
        sortBy,
        sortOrder,
      );

      // Check cache first
      if (_paginatedCache.containsKey(cacheKey)) {
        _updateCacheAccess(cacheKey);
        final cachedResult = _paginatedCache[cacheKey]!;

        return VirtualizedStatsResult(
          data: cachedResult,
          isFromCache: true,
          loadTime: Duration.zero,
        );
      }

      final startTime = DateTime.now();

      // Calculate pagination parameters
      final page = (startIndex / _virtualPageSize).floor() + 1;
      final limit = min(_virtualPageSize, endIndex - startIndex + 1);

      // Load data from Cloud Functions
      final paginatedStats = await _baseStatsService.getPaginatedFileStats(
        page: page,
        limit: limit,
        category: category,
        fileType: fileType,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      // Cache the result with memory management
      _cacheWithMemoryManagement(cacheKey, paginatedStats);

      final loadTime = DateTime.now().difference(startTime);

      return VirtualizedStatsResult(
        data: paginatedStats,
        isFromCache: false,
        loadTime: loadTime,
      );
    } catch (e) {
      debugPrint(
        '❌ PerformanceOptimizedStatsService: Virtualized stats error - $e',
      );
      return VirtualizedStatsResult(
        data: PaginatedFileStats.empty(),
        isFromCache: false,
        loadTime: Duration.zero,
        error: e.toString(),
      );
    }
  }

  /// Preload data for smooth scrolling
  Future<void> preloadVirtualizedData({
    required int currentIndex,
    required int viewportSize,
    String? category,
    String? fileType,
    String sortBy = 'uploadedAt',
    String sortOrder = 'desc',
  }) async {
    try {
      // Calculate preload range (load next 2 pages)
      final preloadStart = currentIndex + viewportSize;
      final preloadEnd = preloadStart + (_virtualPageSize * 2);

      // Preload in background without blocking UI
      unawaited(
        _getVirtualizedStatsInBackground(
          startIndex: preloadStart,
          endIndex: preloadEnd,
          category: category,
          fileType: fileType,
          sortBy: sortBy,
          sortOrder: sortOrder,
        ),
      );
    } catch (e) {
      debugPrint('❌ PerformanceOptimizedStatsService: Preload error - $e');
    }
  }

  /// Get memory usage statistics
  MemoryUsageStats getMemoryUsage() {
    return MemoryUsageStats(
      cacheSize: _paginatedCache.length,
      maxCacheSize: _maxCacheSize,
      memoryUsageBytes: _currentMemoryUsage,
      cacheHitRate: _calculateCacheHitRate(),
    );
  }

  /// Clear cache and free memory
  void clearCache() {
    _paginatedCache.clear();
    _cacheAccessTimes.clear();
    _currentMemoryUsage = 0;
    debugPrint('🗑️ PerformanceOptimizedStatsService: Cache cleared');
  }

  /// Dispose resources
  void dispose() {
    _progressiveLoadingController.close();
    _memoryCleanupTimer?.cancel();
    clearCache();
  }

  // Private methods

  void _emitProgressiveEvent(ProgressiveLoadingPhase phase, String message) {
    _progressiveLoadingController.add(
      ProgressiveLoadingEvent(
        phase: phase,
        message: message,
        timestamp: DateTime.now(),
      ),
    );
  }

  Map<String, dynamic> _getSkeletonStats() {
    return {
      'totalFiles': '...',
      'activeUsers': '...',
      'totalCategories': '...',
      'recentFiles': '...',
      'fileTypeStats': <String, String>{},
      'totalStorageSize': '...',
      'isLoading': true,
    };
  }

  Future<Map<String, dynamic>> _loadDetailedStatistics(
    Map<String, dynamic> basicStats,
  ) async {
    // Add detailed breakdowns without blocking
    final detailed = Map<String, dynamic>.from(basicStats);

    // Add file type distribution
    final fileTypeStats =
        basicStats['fileTypeStats'] as Map<String, dynamic>? ?? {};
    detailed['fileTypeDistribution'] = _calculateDistribution(fileTypeStats);

    // Add growth trends (mock data for now - would come from time-series analysis)
    detailed['growthTrends'] = {
      'dailyGrowth': '+12',
      'weeklyGrowth': '+89',
      'monthlyGrowth': '+342',
    };

    return detailed;
  }

  Map<String, double> _calculateDistribution(Map<String, dynamic> stats) {
    final total = stats.values.fold<int>(
      0,
      (sum, value) => sum + (value as int),
    );
    if (total == 0) return {};

    return stats.map(
      (key, value) => MapEntry(key, (value as int) / total * 100),
    );
  }

  String _generateCacheKey(
    int start,
    int end,
    String? category,
    String? fileType,
    String sortBy,
    String sortOrder,
  ) {
    return '$start-$end-${category ?? 'all'}-${fileType ?? 'all'}-$sortBy-$sortOrder';
  }

  void _updateCacheAccess(String key) {
    _cacheAccessTimes[key] = DateTime.now();
  }

  void _cacheWithMemoryManagement(String key, PaginatedFileStats data) {
    // Remove oldest entries if cache is full
    while (_paginatedCache.length >= _maxCacheSize) {
      final oldestKey = _cacheAccessTimes.keys.first;
      _paginatedCache.remove(oldestKey);
      _cacheAccessTimes.remove(oldestKey);
    }

    _paginatedCache[key] = data;
    _cacheAccessTimes[key] = DateTime.now();

    // Estimate memory usage (rough calculation)
    _currentMemoryUsage += data.files.length * 1024; // ~1KB per file estimate
  }

  Future<void> _getVirtualizedStatsInBackground({
    required int startIndex,
    required int endIndex,
    String? category,
    String? fileType,
    String sortBy = 'uploadedAt',
    String sortOrder = 'desc',
  }) async {
    await getVirtualizedStats(
      startIndex: startIndex,
      endIndex: endIndex,
      category: category,
      fileType: fileType,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }

  void _startMemoryCleanupTimer() {
    _memoryCleanupTimer = Timer.periodic(_memoryCleanupInterval, (_) {
      _performMemoryCleanup();
    });
  }

  void _performMemoryCleanup() {
    final now = DateTime.now();
    final keysToRemove = <String>[];

    // Remove entries older than 30 minutes
    _cacheAccessTimes.forEach((key, accessTime) {
      if (now.difference(accessTime).inMinutes > 30) {
        keysToRemove.add(key);
      }
    });

    for (final key in keysToRemove) {
      _paginatedCache.remove(key);
      _cacheAccessTimes.remove(key);
    }

    if (keysToRemove.isNotEmpty) {
      _currentMemoryUsage = max(
        0,
        _currentMemoryUsage - (keysToRemove.length * 1024),
      );
      debugPrint(
        '🧹 PerformanceOptimizedStatsService: Cleaned ${keysToRemove.length} cache entries',
      );
    }
  }

  double _calculateCacheHitRate() {
    // This would be tracked in a real implementation
    return 0.85; // Mock 85% hit rate
  }
}

/// Progressive loading phases
enum ProgressiveLoadingPhase {
  cached, // Cached data loaded
  skeleton, // Skeleton/loading state
  basic, // Basic statistics loaded
  detailed, // Detailed statistics loaded
  error, // Error occurred
}

/// Progressive loading event
class ProgressiveLoadingEvent {
  final ProgressiveLoadingPhase phase;
  final String message;
  final DateTime timestamp;

  const ProgressiveLoadingEvent({
    required this.phase,
    required this.message,
    required this.timestamp,
  });
}

/// Virtualized statistics result
class VirtualizedStatsResult {
  final PaginatedFileStats data;
  final bool isFromCache;
  final Duration loadTime;
  final String? error;

  const VirtualizedStatsResult({
    required this.data,
    required this.isFromCache,
    required this.loadTime,
    this.error,
  });

  bool get hasError => error != null;
  bool get isSuccess => error == null;
}

/// Memory usage statistics
class MemoryUsageStats {
  final int cacheSize;
  final int maxCacheSize;
  final int memoryUsageBytes;
  final double cacheHitRate;

  const MemoryUsageStats({
    required this.cacheSize,
    required this.maxCacheSize,
    required this.memoryUsageBytes,
    required this.cacheHitRate,
  });

  double get cacheUsagePercentage => (cacheSize / maxCacheSize) * 100;
  String get memoryUsageFormatted => _formatBytes(memoryUsageBytes);
  bool get isNearCapacity => cacheUsagePercentage > 80;

  String _formatBytes(int bytes) {
    if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '$bytes B';
    }
  }
}

/// Virtualized list controller for large datasets
class VirtualizedStatsController {
  final PerformanceOptimizedStatsService _service =
      PerformanceOptimizedStatsService.instance;

  final StreamController<List<DocumentModel>> _dataController =
      StreamController<List<DocumentModel>>.broadcast();

  Stream<List<DocumentModel>> get dataStream => _dataController.stream;

  int _totalItems = 0;

  int get totalItems => _totalItems;

  /// Load data for viewport
  Future<void> loadViewport({
    required int startIndex,
    required int endIndex,
    String? category,
    String? fileType,
    String sortBy = 'uploadedAt',
    String sortOrder = 'desc',
  }) async {
    try {
      final result = await _service.getVirtualizedStats(
        startIndex: startIndex,
        endIndex: endIndex,
        category: category,
        fileType: fileType,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      if (result.isSuccess) {
        _totalItems = result.data.pagination.total;
        _dataController.add(result.data.files);

        // Preload next viewport for smooth scrolling
        _service.preloadVirtualizedData(
          currentIndex: startIndex,
          viewportSize: endIndex - startIndex,
          category: category,
          fileType: fileType,
          sortBy: sortBy,
          sortOrder: sortOrder,
        );
      }
    } catch (e) {
      debugPrint('❌ VirtualizedStatsController: Load viewport error - $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _dataController.close();
  }
}
