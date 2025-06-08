import 'dart:async';
import 'package:flutter/widgets.dart';
import '../config/anr_config.dart';

/// Utility class to prevent ANR (Application Not Responding) issues
class ANRPrevention {
  // Use optimized timeouts from ANRConfig
  static Duration get _defaultTimeout => ANRConfig.defaultTimeout;
  static Duration get _heavyOperationTimeout => ANRConfig.heavyOperationTimeout;
  static Duration get _networkTimeout => ANRConfig.networkTimeout;

  /// Execute operation with timeout to prevent ANR
  static Future<T?> executeWithTimeout<T>(
    Future<T> operation, {
    Duration? timeout,
    String? operationName,
  }) async {
    final timeoutDuration = timeout ?? _defaultTimeout;

    try {
      return await operation.timeout(
        timeoutDuration,
        onTimeout: () {
          debugPrint(
            '⚠️ Operation timeout: ${operationName ?? 'Unknown'} after ${timeoutDuration.inSeconds}s',
          );
          throw TimeoutException(
            'Operation timeout: ${operationName ?? 'Unknown'}',
            timeoutDuration,
          );
        },
      );
    } catch (e) {
      debugPrint('❌ Operation failed: ${operationName ?? 'Unknown'} - $e');
      return null;
    }
  }

  /// Execute heavy operation in background to prevent UI blocking
  /// Note: For now, this uses timeout instead of isolate for simplicity
  static Future<T?> executeInBackground<T>(
    Future<T> Function() operation, {
    Duration? timeout,
    String? operationName,
  }) async {
    final timeoutDuration = timeout ?? _heavyOperationTimeout;

    try {
      debugPrint(
        '🔄 Executing background operation: ${operationName ?? 'Unknown'}',
      );

      return await executeWithTimeout(
        operation(),
        timeout: timeoutDuration,
        operationName: operationName ?? 'Background Operation',
      );
    } catch (e) {
      debugPrint(
        '❌ Background operation failed: ${operationName ?? 'Unknown'} - $e',
      );
      return null;
    }
  }

  /// Execute network operation with appropriate timeout
  static Future<T?> executeNetworkOperation<T>(
    Future<T> operation, {
    String? operationName,
  }) async {
    return executeWithTimeout(
      operation,
      timeout: _networkTimeout,
      operationName: operationName ?? 'Network Operation',
    );
  }

  /// Batch process large lists to prevent UI blocking
  static Future<List<T>> batchProcess<T, R>(
    List<R> items,
    Future<T> Function(R item) processor, {
    int? batchSize,
    Duration? batchDelay,
    String? operationName,
  }) async {
    final effectiveBatchSize = batchSize ?? ANRConfig.defaultBatchSize;
    final effectiveBatchDelay = batchDelay ?? ANRConfig.batchDelay;
    final results = <T>[];

    debugPrint(
      '🔄 Starting batch processing: ${operationName ?? 'Unknown'} (${items.length} items)',
    );

    for (int i = 0; i < items.length; i += effectiveBatchSize) {
      final batch = items.skip(i).take(effectiveBatchSize);

      try {
        final batchResults = await Future.wait(
          batch.map(processor),
          eagerError: false,
        ).timeout(_defaultTimeout);

        results.addAll(batchResults);

        // Small delay to prevent UI blocking
        if (i + effectiveBatchSize < items.length) {
          await Future.delayed(effectiveBatchDelay);
        }

        // Progress logging
        final progress = ((i + effectiveBatchSize) / items.length * 100).clamp(
          0,
          100,
        );
        debugPrint('📊 Batch progress: ${progress.toStringAsFixed(1)}%');
      } catch (e) {
        debugPrint('❌ Batch processing error at index $i: $e');
        // Continue with next batch even if current batch fails
      }
    }

    debugPrint(
      '✅ Batch processing completed: ${results.length}/${items.length} items processed',
    );
    return results;
  }

  /// Debounce function calls to prevent excessive operations
  static Timer? _debounceTimer;

  static void debounce(
    VoidCallback callback, {
    Duration delay = const Duration(milliseconds: 300),
    String? operationName,
  }) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, () {
      debugPrint(
        '🎯 Executing debounced operation: ${operationName ?? 'Unknown'}',
      );
      callback();
    });
  }

  /// Throttle function calls to limit frequency
  static DateTime? _lastThrottleTime;

  static void throttle(
    VoidCallback callback, {
    Duration interval = const Duration(milliseconds: 500),
    String? operationName,
  }) {
    final now = DateTime.now();
    if (_lastThrottleTime == null ||
        now.difference(_lastThrottleTime!) >= interval) {
      _lastThrottleTime = now;
      debugPrint(
        '🎯 Executing throttled operation: ${operationName ?? 'Unknown'}',
      );
      callback();
    } else {
      debugPrint(
        '⏭️ Skipping throttled operation: ${operationName ?? 'Unknown'}',
      );
    }
  }

  /// Execute operation with retry mechanism
  static Future<T?> executeWithRetry<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
    String? operationName,
  }) async {
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        debugPrint(
          '🔄 Attempt ${attempt + 1}/${maxRetries + 1}: ${operationName ?? 'Unknown'}',
        );

        return await executeWithTimeout(
          operation(),
          operationName: operationName,
        );
      } catch (e) {
        debugPrint(
          '❌ Attempt ${attempt + 1} failed: ${operationName ?? 'Unknown'} - $e',
        );

        if (attempt == maxRetries) {
          debugPrint(
            '💥 All retry attempts failed: ${operationName ?? 'Unknown'}',
          );
          return null;
        }

        // Exponential backoff
        final retryDelay = Duration(
          milliseconds: delay.inMilliseconds * (attempt + 1),
        );
        await Future.delayed(retryDelay);
      }
    }
    return null;
  }

  /// Monitor operation performance
  static Future<T?> monitorPerformance<T>(
    Future<T> operation, {
    String? operationName,
    Duration? warningThreshold,
  }) async {
    final stopwatch = Stopwatch()..start();
    final threshold = warningThreshold ?? const Duration(milliseconds: 500);

    try {
      final result = await operation;
      stopwatch.stop();

      final duration = stopwatch.elapsed;
      if (duration > threshold) {
        debugPrint(
          '⚠️ Slow operation detected: ${operationName ?? 'Unknown'} took ${duration.inMilliseconds}ms',
        );
      } else {
        debugPrint(
          '✅ Operation completed: ${operationName ?? 'Unknown'} took ${duration.inMilliseconds}ms',
        );
      }

      return result;
    } catch (e) {
      stopwatch.stop();
      debugPrint(
        '❌ Operation failed: ${operationName ?? 'Unknown'} after ${stopwatch.elapsed.inMilliseconds}ms - $e',
      );
      return null;
    }
  }

  /// Check if app is in foreground to avoid unnecessary operations
  static bool isAppInForeground() {
    return WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
  }

  /// Execute operation only if app is in foreground
  static Future<T?> executeIfForeground<T>(
    Future<T> operation, {
    String? operationName,
  }) async {
    if (!isAppInForeground()) {
      debugPrint(
        '⏸️ Skipping operation (app in background): ${operationName ?? 'Unknown'}',
      );
      return null;
    }

    return executeWithTimeout(operation, operationName: operationName);
  }

  /// Clean up resources to prevent memory leaks
  static void cleanup() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
    _lastThrottleTime = null;
    debugPrint('🧹 ANR Prevention cleanup completed');
  }
}
