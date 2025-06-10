import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../config/anr_config.dart';

/// MEDIUM PRIORITY: Memory management service to prevent ANR from memory issues
class MemoryManagementService {
  static MemoryManagementService? _instance;
  static MemoryManagementService get instance =>
      _instance ??= MemoryManagementService._();

  MemoryManagementService._();

  Timer? _memoryMonitorTimer;
  Timer? _cleanupTimer;
  final List<StreamSubscription> _subscriptions = [];
  final Map<String, Timer> _disposalTimers = {};

  // Memory tracking
  int _lastMemoryUsage = 0;
  int _peakMemoryUsage = 0;
  final Queue<int> _memoryHistory = Queue();

  // Resource tracking
  final Set<String> _activeResources = {};
  final Map<String, DateTime> _resourceTimestamps = {};

  /// Initialize memory management
  void initialize() {
    _startMemoryMonitoring();
    _startPeriodicCleanup();
    debugPrint('🧠 MemoryManagementService initialized');
  }

  /// Start memory monitoring
  void _startMemoryMonitoring() {
    _memoryMonitorTimer?.cancel();
    _memoryMonitorTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _checkMemoryUsage(),
    );
  }

  /// Start periodic cleanup
  void _startPeriodicCleanup() {
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(
      const Duration(minutes: 2),
      (_) => performCleanup(),
    );
  }

  /// Check current memory usage
  Future<void> _checkMemoryUsage() async {
    try {
      // This is a simplified approach - in production you might want to use
      // more sophisticated memory monitoring

      // Simulate memory check (replace with actual implementation)
      final currentMemory = _estimateMemoryUsage();

      _lastMemoryUsage = currentMemory;
      if (currentMemory > _peakMemoryUsage) {
        _peakMemoryUsage = currentMemory;
      }

      _memoryHistory.add(currentMemory);
      if (_memoryHistory.length > 20) {
        _memoryHistory.removeFirst();
      }

      // Check for memory pressure
      if (currentMemory > 100 * 1024 * 1024) {
        // > 100MB
        debugPrint(
          '⚠️ High memory usage detected: ${_formatMemorySize(currentMemory)}',
        );
        await _handleMemoryPressure();
      }
    } catch (e) {
      debugPrint('❌ Error checking memory usage: $e');
    }
  }

  /// Estimate memory usage (simplified)
  int _estimateMemoryUsage() {
    // This is a placeholder - implement actual memory measurement
    return _activeResources.length * 1024 * 1024; // Rough estimate
  }

  /// Handle memory pressure
  Future<void> _handleMemoryPressure() async {
    debugPrint('🧹 Handling memory pressure...');

    // Force garbage collection
    await _forceGarbageCollection();

    // Clear caches
    await _clearCaches();

    // Dispose unused resources
    await _disposeUnusedResources();

    debugPrint('✅ Memory pressure handling completed');
  }

  /// Force garbage collection
  Future<void> _forceGarbageCollection() async {
    try {
      // Request garbage collection - simplified approach
      // In production, you might want to use more sophisticated GC triggering
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      debugPrint('❌ Error forcing GC: $e');
    }
  }

  /// Clear various caches
  Future<void> _clearCaches() async {
    try {
      // Clear image cache
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();

      debugPrint('🧹 Caches cleared');
    } catch (e) {
      debugPrint('❌ Error clearing caches: $e');
    }
  }

  /// Dispose unused resources
  Future<void> _disposeUnusedResources() async {
    final now = DateTime.now();
    final toDispose = <String>[];

    for (final entry in _resourceTimestamps.entries) {
      if (now.difference(entry.value) > ANRConfig.cacheExpiry) {
        toDispose.add(entry.key);
      }
    }

    for (final resourceId in toDispose) {
      await disposeResource(resourceId);
    }

    debugPrint('🗑️ Disposed ${toDispose.length} unused resources');
  }

  /// Register a resource for tracking
  void registerResource(String resourceId, {Duration? autoDisposeAfter}) {
    _activeResources.add(resourceId);
    _resourceTimestamps[resourceId] = DateTime.now();

    if (autoDisposeAfter != null) {
      _disposalTimers[resourceId]?.cancel();
      _disposalTimers[resourceId] = Timer(autoDisposeAfter, () {
        disposeResource(resourceId);
      });
    }

    debugPrint('📝 Registered resource: $resourceId');
  }

  /// Dispose a specific resource
  Future<void> disposeResource(String resourceId) async {
    _activeResources.remove(resourceId);
    _resourceTimestamps.remove(resourceId);
    _disposalTimers[resourceId]?.cancel();
    _disposalTimers.remove(resourceId);

    debugPrint('🗑️ Disposed resource: $resourceId');
  }

  /// Register a stream subscription for automatic disposal
  void registerSubscription(StreamSubscription subscription) {
    _subscriptions.add(subscription);
  }

  /// Perform comprehensive cleanup
  Future<void> performCleanup() async {
    debugPrint('🧹 Starting comprehensive cleanup...');

    try {
      // Cancel old subscriptions
      final oldSubscriptions = <StreamSubscription>[];

      for (final subscription in _subscriptions) {
        // Check if subscription is still active (simplified check)
        try {
          if (subscription.isPaused) {
            oldSubscriptions.add(subscription);
          }
        } catch (e) {
          oldSubscriptions.add(subscription);
        }
      }

      for (final subscription in oldSubscriptions) {
        try {
          await subscription.cancel();
          _subscriptions.remove(subscription);
        } catch (e) {
          debugPrint('❌ Error cancelling subscription: $e');
        }
      }

      // Clear old resources
      await _disposeUnusedResources();

      // Clear caches if memory usage is high
      if (_lastMemoryUsage > 50 * 1024 * 1024) {
        // > 50MB
        await _clearCaches();
      }

      debugPrint(
        '✅ Cleanup completed. Active resources: ${_activeResources.length}',
      );
    } catch (e) {
      debugPrint('❌ Error during cleanup: $e');
    }
  }

  /// Get memory statistics
  Map<String, dynamic> getMemoryStats() {
    return {
      'currentMemoryUsage': _formatMemorySize(_lastMemoryUsage),
      'peakMemoryUsage': _formatMemorySize(_peakMemoryUsage),
      'activeResources': _activeResources.length,
      'activeSubscriptions': _subscriptions.length,
      'memoryHistory': _memoryHistory.toList(),
      'averageMemoryUsage': _memoryHistory.isEmpty
          ? 0
          : _memoryHistory.reduce((a, b) => a + b) ~/ _memoryHistory.length,
    };
  }

  /// Format memory size for display
  String _formatMemorySize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Check if memory usage is critical
  bool isMemoryUsageCritical() {
    return _lastMemoryUsage > 150 * 1024 * 1024; // > 150MB
  }

  /// Get memory usage trend
  String getMemoryTrend() {
    if (_memoryHistory.length < 3) return 'Unknown';

    final recent = _memoryHistory.toList().reversed.take(3).toList();
    if (recent[0] > recent[1] && recent[1] > recent[2]) {
      return 'Increasing';
    } else if (recent[0] < recent[1] && recent[1] < recent[2]) {
      return 'Decreasing';
    } else {
      return 'Stable';
    }
  }

  /// Force immediate cleanup
  Future<void> forceCleanup() async {
    debugPrint('🚨 Force cleanup requested');
    await _handleMemoryPressure();
    await performCleanup();
  }

  /// Dispose the service
  void dispose() {
    _memoryMonitorTimer?.cancel();
    _cleanupTimer?.cancel();

    // Cancel all subscriptions
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();

    // Cancel all disposal timers
    for (final timer in _disposalTimers.values) {
      timer.cancel();
    }
    _disposalTimers.clear();

    _activeResources.clear();
    _resourceTimestamps.clear();
    _memoryHistory.clear();

    debugPrint('🗑️ MemoryManagementService disposed');
  }
}

/// Memory-aware widget mixin
mixin MemoryAwareMixin<T extends StatefulWidget> on State<T> {
  final List<StreamSubscription> _subscriptions = [];
  final MemoryManagementService _memoryService =
      MemoryManagementService.instance;

  /// Register a subscription for automatic cleanup
  void registerSubscription(StreamSubscription subscription) {
    _subscriptions.add(subscription);
    _memoryService.registerSubscription(subscription);
  }

  /// Register a resource for tracking
  void registerResource(String resourceId, {Duration? autoDisposeAfter}) {
    _memoryService.registerResource(
      resourceId,
      autoDisposeAfter: autoDisposeAfter,
    );
  }

  @override
  void dispose() {
    // Cancel all subscriptions
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();

    super.dispose();
  }
}

/// Memory-aware StatefulWidget base class
abstract class MemoryAwareStatefulWidget extends StatefulWidget {
  const MemoryAwareStatefulWidget({super.key});
}

/// Memory-aware State base class
abstract class MemoryAwareState<T extends MemoryAwareStatefulWidget>
    extends State<T>
    with MemoryAwareMixin<T> {
  @override
  void initState() {
    super.initState();
    registerResource(runtimeType.toString());
  }

  @override
  void dispose() {
    MemoryManagementService.instance.disposeResource(runtimeType.toString());
    super.dispose();
  }
}
