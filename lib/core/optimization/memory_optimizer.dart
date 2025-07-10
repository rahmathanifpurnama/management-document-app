import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

class MemoryOptimizer {
  static Timer? _memoryCheckTimer;
  static final List<WeakReference<Object>> _trackedObjects = [];
  static final Map<String, int> _objectCounts = {};
  static int _maxImageCacheSize = 100;
  static int _maxImageCacheSizeBytes = 50 * 1024 * 1024; // 50MB

  /// Start memory monitoring
  static void startMonitoring({Duration interval = const Duration(minutes: 1)}) {
    _memoryCheckTimer?.cancel();
    _memoryCheckTimer = Timer.periodic(interval, (_) => _checkMemoryUsage());
    debugPrint('🔍 Memory monitoring started (interval: ${interval.inMinutes}min)');
  }

  /// Stop memory monitoring
  static void stopMonitoring() {
    _memoryCheckTimer?.cancel();
    _memoryCheckTimer = null;
    debugPrint('🛑 Memory monitoring stopped');
  }

  /// Track object for memory leaks
  static void trackObject(Object object, String name) {
    if (!kDebugMode) return;
    
    _trackedObjects.add(WeakReference(object));
    _objectCounts[name] = (_objectCounts[name] ?? 0) + 1;
    debugPrint('🔍 Tracking object: $name (Total: ${_objectCounts[name]})');
  }

  /// Check for memory leaks
  static void _checkMemoryUsage() {
    if (!kDebugMode) return;

    // Remove garbage collected objects
    final beforeCount = _trackedObjects.length;
    _trackedObjects.removeWhere((ref) => ref.target == null);
    final afterCount = _trackedObjects.length;
    final collectedCount = beforeCount - afterCount;
    
    debugPrint('💾 Memory Check: ${_trackedObjects.length} active objects, $collectedCount collected');
    
    // Update object counts
    _updateObjectCounts();
    
    // Check for potential memory issues
    _checkForMemoryIssues();
    
    // Auto-optimize if needed
    _autoOptimizeMemory();
  }

  /// Update object counts based on tracked objects
  static void _updateObjectCounts() {
    _objectCounts.clear();
    for (final ref in _trackedObjects) {
      final obj = ref.target;
      if (obj != null) {
        final typeName = obj.runtimeType.toString();
        _objectCounts[typeName] = (_objectCounts[typeName] ?? 0) + 1;
      }
    }
  }

  /// Check for potential memory issues
  static void _checkForMemoryIssues() {
    // Check for high object counts
    _objectCounts.forEach((type, count) {
      if (count > 100) {
        debugPrint('⚠️ High object count for $type: $count instances');
      }
    });
    
    // Check image cache size
    final imageCache = PaintingBinding.instance.imageCache;
    if (imageCache.currentSize > _maxImageCacheSize) {
      debugPrint('⚠️ Image cache size exceeded: ${imageCache.currentSize}/$_maxImageCacheSize');
    }
    
    if (imageCache.currentSizeBytes > _maxImageCacheSizeBytes) {
      debugPrint('⚠️ Image cache memory exceeded: ${imageCache.currentSizeBytes}/$_maxImageCacheSizeBytes bytes');
    }
  }

  /// Auto-optimize memory if thresholds are exceeded
  static void _autoOptimizeMemory() {
    final imageCache = PaintingBinding.instance.imageCache;
    
    // Auto-clear image cache if it's too large
    if (imageCache.currentSize > _maxImageCacheSize * 1.5 ||
        imageCache.currentSizeBytes > _maxImageCacheSizeBytes * 1.5) {
      optimizeImageCache();
    }
    
    // Force garbage collection if too many tracked objects
    if (_trackedObjects.length > 200) {
      debugPrint('🗑️ Forcing garbage collection due to high object count');
      // Note: Dart doesn't have explicit GC, but we can clear references
      _clearStaleReferences();
    }
  }

  /// Clear stale references
  static void _clearStaleReferences() {
    final beforeCount = _trackedObjects.length;
    _trackedObjects.removeWhere((ref) => ref.target == null);
    final clearedCount = beforeCount - _trackedObjects.length;
    debugPrint('🧹 Cleared $clearedCount stale references');
  }

  /// Optimize image cache
  static void optimizeImageCache() {
    final imageCache = PaintingBinding.instance.imageCache;
    final beforeSize = imageCache.currentSize;
    final beforeBytes = imageCache.currentSizeBytes;
    
    imageCache.clear();
    imageCache.clearLiveImages();
    
    debugPrint('🖼️ Image cache optimized: $beforeSize→${imageCache.currentSize} images, ${beforeBytes}→${imageCache.currentSizeBytes} bytes');
  }

  /// Configure image cache limits
  static void configureImageCache({
    int? maxSize,
    int? maxSizeBytes,
  }) {
    final imageCache = PaintingBinding.instance.imageCache;
    
    if (maxSize != null) {
      _maxImageCacheSize = maxSize;
      imageCache.maximumSize = maxSize;
      debugPrint('📐 Image cache max size set to: $maxSize');
    }
    
    if (maxSizeBytes != null) {
      _maxImageCacheSizeBytes = maxSizeBytes;
      imageCache.maximumSizeBytes = maxSizeBytes;
      debugPrint('📏 Image cache max bytes set to: ${maxSizeBytes / 1024 / 1024}MB');
    }
  }

  /// Get memory optimization suggestions
  static List<String> getOptimizationSuggestions() {
    final suggestions = <String>[];
    
    // Check tracked objects
    if (_trackedObjects.length > 50) {
      suggestions.add('Consider reducing the number of cached objects (${_trackedObjects.length} tracked)');
    }
    
    // Check object type distribution
    _objectCounts.forEach((type, count) {
      if (count > 50) {
        suggestions.add('High count of $type objects ($count). Consider object pooling or caching strategies.');
      }
    });
    
    // Check image cache
    final imageCache = PaintingBinding.instance.imageCache;
    if (imageCache.currentSize > _maxImageCacheSize * 0.8) {
      suggestions.add('Image cache is near capacity (${imageCache.currentSize}/$_maxImageCacheSize)');
    }
    
    if (imageCache.currentSizeBytes > _maxImageCacheSizeBytes * 0.8) {
      final currentMB = imageCache.currentSizeBytes / 1024 / 1024;
      final maxMB = _maxImageCacheSizeBytes / 1024 / 1024;
      suggestions.add('Image cache memory usage is high (${currentMB.toStringAsFixed(1)}/${maxMB.toStringAsFixed(1)}MB)');
    }
    
    return suggestions;
  }

  /// Get memory usage report
  static MemoryUsageReport getMemoryReport() {
    return MemoryUsageReport(
      trackedObjectCount: _trackedObjects.length,
      objectCounts: Map.from(_objectCounts),
      imageCacheSize: PaintingBinding.instance.imageCache.currentSize,
      imageCacheSizeBytes: PaintingBinding.instance.imageCache.currentSizeBytes,
      maxImageCacheSize: _maxImageCacheSize,
      maxImageCacheSizeBytes: _maxImageCacheSizeBytes,
      suggestions: getOptimizationSuggestions(),
    );
  }

  /// Dispose and cleanup
  static void dispose() {
    stopMonitoring();
    _trackedObjects.clear();
    _objectCounts.clear();
    debugPrint('🧹 Memory optimizer disposed');
  }
}

class MemoryUsageReport {
  final int trackedObjectCount;
  final Map<String, int> objectCounts;
  final int imageCacheSize;
  final int imageCacheSizeBytes;
  final int maxImageCacheSize;
  final int maxImageCacheSizeBytes;
  final List<String> suggestions;

  MemoryUsageReport({
    required this.trackedObjectCount,
    required this.objectCounts,
    required this.imageCacheSize,
    required this.imageCacheSizeBytes,
    required this.maxImageCacheSize,
    required this.maxImageCacheSizeBytes,
    required this.suggestions,
  });

  /// Get formatted report
  String getFormattedReport() {
    final buffer = StringBuffer();
    buffer.writeln('💾 Memory Usage Report');
    buffer.writeln('=' * 30);
    
    buffer.writeln('📊 Overview:');
    buffer.writeln('  Tracked Objects: $trackedObjectCount');
    buffer.writeln('  Image Cache: $imageCacheSize/$maxImageCacheSize images');
    buffer.writeln('  Image Memory: ${(imageCacheSizeBytes / 1024 / 1024).toStringAsFixed(1)}/${(maxImageCacheSizeBytes / 1024 / 1024).toStringAsFixed(1)}MB');
    
    if (objectCounts.isNotEmpty) {
      buffer.writeln('\n🏷️ Object Types:');
      final sortedCounts = objectCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      
      for (final entry in sortedCounts.take(10)) {
        buffer.writeln('  ${entry.key}: ${entry.value}');
      }
    }
    
    if (suggestions.isNotEmpty) {
      buffer.writeln('\n💡 Suggestions:');
      for (final suggestion in suggestions) {
        buffer.writeln('  • $suggestion');
      }
    }
    
    return buffer.toString();
  }
}
