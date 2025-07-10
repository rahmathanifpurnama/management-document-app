import 'package:flutter/foundation.dart';

class PerformanceMonitor {
  static final Map<String, int> _rebuildCounts = {};
  static final Map<String, DateTime> _lastRebuildTimes = {};
  static final List<PerformanceMetric> _metrics = [];

  /// Track widget rebuilds
  static void trackRebuild(String widgetName) {
    if (!kDebugMode) return;

    _rebuildCounts[widgetName] = (_rebuildCounts[widgetName] ?? 0) + 1;
    _lastRebuildTimes[widgetName] = DateTime.now();

    debugPrint(
      '🔄 Widget Rebuild: $widgetName (Count: ${_rebuildCounts[widgetName]})',
    );
  }

  /// Track state changes
  static void trackStateChange(
    String providerName,
    dynamic oldState,
    dynamic newState,
  ) {
    if (!kDebugMode) return;

    final metric = PerformanceMetric(
      type: MetricType.stateChange,
      name: providerName,
      timestamp: DateTime.now(),
      data: {'oldState': oldState.toString(), 'newState': newState.toString()},
    );

    _metrics.add(metric);
    debugPrint('📊 State Change: $providerName');
  }

  /// Track memory usage
  static Future<void> trackMemoryUsage() async {
    if (!kDebugMode) return;

    try {
      final info = await MemoryInfo.fromPlatform();
      final metric = PerformanceMetric(
        type: MetricType.memory,
        name: 'memory_usage',
        timestamp: DateTime.now(),
        data: {
          'totalMemory': info.totalMemory,
          'freeMemory': info.freeMemory,
          'usedMemory': info.totalMemory - info.freeMemory,
        },
      );

      _metrics.add(metric);
      debugPrint(
        '💾 Memory Usage: ${(info.totalMemory - info.freeMemory) / 1024 / 1024} MB',
      );
    } catch (e) {
      debugPrint('❌ Error tracking memory: $e');
    }
  }

  /// Track navigation performance
  static void trackNavigation(String routeName, Duration duration) {
    if (!kDebugMode) return;

    final metric = PerformanceMetric(
      type: MetricType.navigation,
      name: 'navigation_$routeName',
      timestamp: DateTime.now(),
      data: {'routeName': routeName, 'duration': duration.inMilliseconds},
    );

    _metrics.add(metric);
    debugPrint('🧭 Navigation to $routeName: ${duration.inMilliseconds}ms');
  }

  /// Get performance report
  static PerformanceReport getReport() {
    return PerformanceReport(
      rebuildCounts: Map.from(_rebuildCounts),
      metrics: List.from(_metrics),
      generatedAt: DateTime.now(),
    );
  }

  /// Clear metrics
  static void clearMetrics() {
    _rebuildCounts.clear();
    _lastRebuildTimes.clear();
    _metrics.clear();
  }

  /// Get top rebuilding widgets
  static List<MapEntry<String, int>> getTopRebuildingWidgets({int limit = 10}) {
    final sorted = _rebuildCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(limit).toList();
  }

  /// Get memory metrics summary
  static Map<String, dynamic> getMemoryMetricsSummary() {
    final memoryMetrics = _metrics
        .where((m) => m.type == MetricType.memory)
        .toList();

    if (memoryMetrics.isEmpty) return {};

    final usedMemoryValues = memoryMetrics
        .map((m) => m.data['usedMemory'] as int)
        .toList();

    return {
      'averageMemoryUsage':
          usedMemoryValues.reduce((a, b) => a + b) / usedMemoryValues.length,
      'maxMemoryUsage': usedMemoryValues.reduce((a, b) => a > b ? a : b),
      'minMemoryUsage': usedMemoryValues.reduce((a, b) => a < b ? a : b),
      'memoryMeasurements': usedMemoryValues.length,
    };
  }
}

class PerformanceMetric {
  final MetricType type;
  final String name;
  final DateTime timestamp;
  final Map<String, dynamic> data;

  PerformanceMetric({
    required this.type,
    required this.name,
    required this.timestamp,
    required this.data,
  });
}

enum MetricType { stateChange, memory, rebuild, navigation }

class PerformanceReport {
  final Map<String, int> rebuildCounts;
  final List<PerformanceMetric> metrics;
  final DateTime generatedAt;

  PerformanceReport({
    required this.rebuildCounts,
    required this.metrics,
    required this.generatedAt,
  });

  /// Get formatted report as string
  String getFormattedReport() {
    final buffer = StringBuffer();
    buffer.writeln('📊 Performance Report - ${generatedAt.toString()}');
    buffer.writeln('=' * 50);

    // Top rebuilding widgets
    buffer.writeln('\n🔄 Top Rebuilding Widgets:');
    final topWidgets = PerformanceMonitor.getTopRebuildingWidgets();
    for (final entry in topWidgets) {
      buffer.writeln('  ${entry.key}: ${entry.value} rebuilds');
    }

    // Memory summary
    buffer.writeln('\n💾 Memory Usage Summary:');
    final memorySummary = PerformanceMonitor.getMemoryMetricsSummary();
    if (memorySummary.isNotEmpty) {
      buffer.writeln(
        '  Average: ${(memorySummary['averageMemoryUsage'] / 1024 / 1024).toStringAsFixed(2)} MB',
      );
      buffer.writeln(
        '  Max: ${(memorySummary['maxMemoryUsage'] / 1024 / 1024).toStringAsFixed(2)} MB',
      );
      buffer.writeln(
        '  Min: ${(memorySummary['minMemoryUsage'] / 1024 / 1024).toStringAsFixed(2)} MB',
      );
    }

    return buffer.toString();
  }
}

class MemoryInfo {
  final int totalMemory;
  final int freeMemory;

  MemoryInfo({required this.totalMemory, required this.freeMemory});

  static Future<MemoryInfo> fromPlatform() async {
    try {
      // For now, return mock data. In production, this would use platform channels
      // to get actual memory information from the device
      return MemoryInfo(
        totalMemory: 8 * 1024 * 1024 * 1024, // 8GB mock
        freeMemory: 4 * 1024 * 1024 * 1024, // 4GB mock
      );
    } catch (e) {
      debugPrint('Error getting memory info: $e');
      return MemoryInfo(totalMemory: 0, freeMemory: 0);
    }
  }
}
