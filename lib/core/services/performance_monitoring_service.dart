import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import '../config/anr_config.dart';

/// LOW PRIORITY: Performance monitoring service for ANR detection and optimization
class PerformanceMonitoringService {
  static PerformanceMonitoringService? _instance;
  static PerformanceMonitoringService get instance => _instance ??= PerformanceMonitoringService._();
  
  PerformanceMonitoringService._();

  Timer? _monitoringTimer;
  Timer? _frameTimer;
  bool _isMonitoring = false;
  
  // Performance metrics
  final Queue<double> _frameTimeHistory = Queue();
  final Queue<int> _memoryUsageHistory = Queue();
  final Map<String, List<Duration>> _operationTimes = {};
  
  // Frame rate tracking
  int _frameCount = 0;
  double _currentFPS = 0.0;
  double _averageFPS = 0.0;
  
  // ANR detection
  DateTime? _lastFrameTime;
  int _anrCount = 0;
  final List<String> _anrEvents = [];
  
  // Performance thresholds
  static const double _targetFPS = 60.0;
  static const double _lowFPSThreshold = 30.0;
  static const Duration _anrThreshold = Duration(seconds: 2);
  static const int _maxHistorySize = 100;

  /// Start performance monitoring
  void startMonitoring() {
    if (_isMonitoring) return;
    
    _isMonitoring = true;
    _startFrameMonitoring();
    _startPerformanceTimer();
    
    debugPrint('📊 Performance monitoring started');
  }

  /// Stop performance monitoring
  void stopMonitoring() {
    _isMonitoring = false;
    _monitoringTimer?.cancel();
    _frameTimer?.cancel();
    
    debugPrint('📊 Performance monitoring stopped');
  }

  /// Start frame rate monitoring
  void _startFrameMonitoring() {
    _frameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isMonitoring) {
        timer.cancel();
        return;
      }
      
      _updateFrameRate();
      _checkForANR();
    });
    
    // Monitor frame callbacks
    SchedulerBinding.instance.addPostFrameCallback(_onFrameEnd);
  }

  /// Start general performance timer
  void _startPerformanceTimer() {
    _monitoringTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isMonitoring) {
        timer.cancel();
        return;
      }
      
      _collectPerformanceMetrics();
      _analyzePerformance();
    });
  }

  /// Handle frame end callback
  void _onFrameEnd(Duration timestamp) {
    if (!_isMonitoring) return;
    
    _frameCount++;
    _lastFrameTime = DateTime.now();
    
    // Schedule next frame callback
    SchedulerBinding.instance.addPostFrameCallback(_onFrameEnd);
  }

  /// Update frame rate calculations
  void _updateFrameRate() {
    _currentFPS = _frameCount.toDouble();
    _frameCount = 0;
    
    // Update frame time history
    _frameTimeHistory.add(_currentFPS);
    if (_frameTimeHistory.length > _maxHistorySize) {
      _frameTimeHistory.removeFirst();
    }
    
    // Calculate average FPS
    if (_frameTimeHistory.isNotEmpty) {
      _averageFPS = _frameTimeHistory.reduce((a, b) => a + b) / _frameTimeHistory.length;
    }
    
    // Check for low FPS
    if (_currentFPS < _lowFPSThreshold) {
      _recordPerformanceIssue('Low FPS detected: ${_currentFPS.toStringAsFixed(1)}');
    }
  }

  /// Check for ANR conditions
  void _checkForANR() {
    if (_lastFrameTime == null) return;
    
    final now = DateTime.now();
    final timeSinceLastFrame = now.difference(_lastFrameTime!);
    
    if (timeSinceLastFrame > _anrThreshold) {
      _anrCount++;
      final anrMessage = 'ANR detected: ${timeSinceLastFrame.inMilliseconds}ms since last frame';
      _recordPerformanceIssue(anrMessage);
      _anrEvents.add('${now.toIso8601String()}: $anrMessage');
      
      // Keep only recent ANR events
      if (_anrEvents.length > 20) {
        _anrEvents.removeAt(0);
      }
    }
  }

  /// Collect performance metrics
  void _collectPerformanceMetrics() {
    // Simulate memory usage collection
    final memoryUsage = _estimateMemoryUsage();
    _memoryUsageHistory.add(memoryUsage);
    
    if (_memoryUsageHistory.length > _maxHistorySize) {
      _memoryUsageHistory.removeFirst();
    }
  }

  /// Estimate memory usage (simplified)
  int _estimateMemoryUsage() {
    // This is a placeholder - implement actual memory measurement
    return _operationTimes.length * 1024 * 1024; // Rough estimate
  }

  /// Analyze performance and provide recommendations
  void _analyzePerformance() {
    final stats = getPerformanceStats();
    
    // Check for performance issues
    if (stats['averageFPS'] < _lowFPSThreshold) {
      _recordPerformanceIssue('Consistently low FPS: ${stats['averageFPS']}');
    }
    
    if (stats['anrCount'] > 0) {
      _recordPerformanceIssue('ANR events detected: ${stats['anrCount']}');
    }
    
    // Check slow operations
    _analyzeSlowOperations();
  }

  /// Analyze slow operations
  void _analyzeSlowOperations() {
    for (final entry in _operationTimes.entries) {
      final operationName = entry.key;
      final times = entry.value;
      
      if (times.isNotEmpty) {
        final averageTime = times.fold<int>(0, (sum, duration) => sum + duration.inMilliseconds) / times.length;
        
        if (averageTime > ANRConfig.slowOperationThreshold.inMilliseconds) {
          _recordPerformanceIssue('Slow operation detected: $operationName (${averageTime.toStringAsFixed(1)}ms avg)');
        }
      }
    }
  }

  /// Record performance issue
  void _recordPerformanceIssue(String issue) {
    debugPrint('⚠️ Performance Issue: $issue');
    
    // In production, you might want to send this to analytics
    if (kReleaseMode) {
      // Send to crash reporting service
    }
  }

  /// Track operation performance
  void trackOperation(String operationName, Duration duration) {
    if (!_operationTimes.containsKey(operationName)) {
      _operationTimes[operationName] = [];
    }
    
    _operationTimes[operationName]!.add(duration);
    
    // Keep only recent measurements
    if (_operationTimes[operationName]!.length > 50) {
      _operationTimes[operationName]!.removeAt(0);
    }
    
    // Check if operation is slow
    if (duration > ANRConfig.slowOperationThreshold) {
      _recordPerformanceIssue('Slow operation: $operationName (${duration.inMilliseconds}ms)');
    }
  }

  /// Get performance statistics
  Map<String, dynamic> getPerformanceStats() {
    return {
      'currentFPS': _currentFPS,
      'averageFPS': _averageFPS,
      'anrCount': _anrCount,
      'recentANREvents': _anrEvents.take(5).toList(),
      'memoryUsage': _memoryUsageHistory.isEmpty ? 0 : _memoryUsageHistory.last,
      'averageMemoryUsage': _memoryUsageHistory.isEmpty 
          ? 0 
          : _memoryUsageHistory.reduce((a, b) => a + b) / _memoryUsageHistory.length,
      'slowOperations': _getSlowOperations(),
      'isMonitoring': _isMonitoring,
      'frameTimeHistory': _frameTimeHistory.toList(),
    };
  }

  /// Get slow operations summary
  Map<String, double> _getSlowOperations() {
    final slowOps = <String, double>{};
    
    for (final entry in _operationTimes.entries) {
      final operationName = entry.key;
      final times = entry.value;
      
      if (times.isNotEmpty) {
        final averageTime = times.fold<int>(0, (sum, duration) => sum + duration.inMilliseconds) / times.length;
        
        if (averageTime > ANRConfig.slowOperationThreshold.inMilliseconds) {
          slowOps[operationName] = averageTime;
        }
      }
    }
    
    return slowOps;
  }

  /// Get performance recommendations
  List<String> getPerformanceRecommendations() {
    final recommendations = <String>[];
    final stats = getPerformanceStats();
    
    if (stats['averageFPS'] < _lowFPSThreshold) {
      recommendations.add('Consider reducing UI complexity or using lazy loading');
    }
    
    if (stats['anrCount'] > 0) {
      recommendations.add('Implement timeouts and background processing for heavy operations');
    }
    
    final slowOps = stats['slowOperations'] as Map<String, double>;
    if (slowOps.isNotEmpty) {
      recommendations.add('Optimize slow operations: ${slowOps.keys.join(', ')}');
    }
    
    if (stats['averageMemoryUsage'] > 100 * 1024 * 1024) { // > 100MB
      recommendations.add('Consider implementing memory management and cache cleanup');
    }
    
    return recommendations;
  }

  /// Reset performance metrics
  void resetMetrics() {
    _frameTimeHistory.clear();
    _memoryUsageHistory.clear();
    _operationTimes.clear();
    _anrCount = 0;
    _anrEvents.clear();
    _currentFPS = 0.0;
    _averageFPS = 0.0;
    
    debugPrint('📊 Performance metrics reset');
  }

  /// Dispose resources
  void dispose() {
    stopMonitoring();
    resetMetrics();
    debugPrint('📊 Performance monitoring service disposed');
  }
}

/// Performance tracking mixin for widgets
mixin PerformanceTrackingMixin<T extends StatefulWidget> on State<T> {
  final PerformanceMonitoringService _performanceService = PerformanceMonitoringService.instance;
  late Stopwatch _operationStopwatch;
  
  /// Start tracking an operation
  void startOperationTracking() {
    _operationStopwatch = Stopwatch()..start();
  }
  
  /// End tracking an operation
  void endOperationTracking(String operationName) {
    _operationStopwatch.stop();
    _performanceService.trackOperation(operationName, _operationStopwatch.elapsed);
  }
  
  /// Track a specific operation
  Future<T> trackOperation<T>(String operationName, Future<T> operation) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await operation;
      stopwatch.stop();
      _performanceService.trackOperation(operationName, stopwatch.elapsed);
      return result;
    } catch (e) {
      stopwatch.stop();
      _performanceService.trackOperation('$operationName (failed)', stopwatch.elapsed);
      rethrow;
    }
  }
}
