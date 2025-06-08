import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';

/// Utility class to prevent ANR (App Not Responding) issues
class ANRPreventionUtils {
  /// Maximum time for a single operation before considering it blocking
  static const Duration maxOperationTime = Duration(seconds: 2);

  /// Maximum number of concurrent Firebase operations
  static const int maxConcurrentFirebaseOps = 3;

  /// Debounce duration for UI updates
  static const Duration uiUpdateDebounce = Duration(milliseconds: 500);

  /// Batch size for processing large datasets
  static const int defaultBatchSize = 10;

  /// Delay between batches to prevent UI blocking
  static const Duration batchDelay = Duration(milliseconds: 100);

  /// Execute a potentially blocking operation with timeout and error handling
  static Future<T?> executeWithTimeout<T>(
    Future<T> Function() operation, {
    Duration timeout = maxOperationTime,
    String operationName = 'Unknown Operation',
  }) async {
    try {
      final result = await operation().timeout(
        timeout,
        onTimeout: () {
          debugPrint('⚠️ Operation timeout: $operationName');
          throw TimeoutException('Operation timeout: $operationName', timeout);
        },
      );
      return result;
    } catch (e) {
      debugPrint('❌ Operation failed: $operationName - $e');
      return null;
    }
  }

  /// Process a large list in batches to prevent UI blocking
  static Future<List<R>> processBatched<T, R>(
    List<T> items,
    Future<R> Function(T item) processor, {
    int batchSize = defaultBatchSize,
    Duration batchDelay = batchDelay,
    String operationName = 'Batch Processing',
  }) async {
    final results = <R>[];
    final totalBatches = (items.length / batchSize).ceil();

    debugPrint(
      '🔄 Starting $operationName: ${items.length} items in $totalBatches batches',
    );

    for (int i = 0; i < items.length; i += batchSize) {
      final batch = items.skip(i).take(batchSize).toList();
      final batchNumber = (i / batchSize).floor() + 1;

      try {
        // Process batch with timeout
        final batchResults =
            await Future.wait(batch.map(processor), eagerError: false).timeout(
              const Duration(minutes: 2),
              onTimeout: () {
                debugPrint('⚠️ Batch $batchNumber timeout in $operationName');
                return <R>[];
              },
            );

        results.addAll(batchResults);

        debugPrint(
          '✅ Completed batch $batchNumber/$totalBatches in $operationName',
        );

        // Yield control to UI thread between batches
        if (i + batchSize < items.length) {
          await Future.delayed(batchDelay);
        }
      } catch (e) {
        debugPrint('❌ Batch $batchNumber failed in $operationName: $e');
        // Continue with next batch even if current fails
      }
    }

    debugPrint(
      '🎉 $operationName completed: ${results.length}/${items.length} items processed',
    );
    return results;
  }

  /// Execute multiple operations with controlled concurrency
  static Future<List<T?>> executeConcurrently<T>(
    List<Future<T> Function()> operations, {
    int maxConcurrency = maxConcurrentFirebaseOps,
    String operationName = 'Concurrent Operations',
  }) async {
    if (operations.isEmpty) return [];

    final semaphore = Semaphore(maxConcurrency);
    final results = <T?>[];

    debugPrint(
      '🚀 Starting $operationName: ${operations.length} operations with max concurrency $maxConcurrency',
    );

    final futures = operations.map((operation) async {
      await semaphore.acquire();
      try {
        return await executeWithTimeout(
          operation,
          operationName: operationName,
        );
      } finally {
        semaphore.release();
      }
    }).toList();

    final completedResults = await Future.wait(futures, eagerError: false);
    results.addAll(completedResults);

    final successCount = results.where((r) => r != null).length;
    debugPrint(
      '✅ $operationName completed: $successCount/${operations.length} operations successful',
    );

    return results;
  }

  /// Debounce function calls to prevent excessive execution
  static Timer? debounce(
    Timer? previousTimer,
    Duration delay,
    VoidCallback callback, {
    String operationName = 'Debounced Operation',
  }) {
    previousTimer?.cancel();
    return Timer(delay, () {
      debugPrint('🔄 Executing debounced operation: $operationName');
      callback();
    });
  }

  /// Throttle function calls to limit execution frequency
  static bool throttle(
    Map<String, DateTime> lastExecutionTimes,
    String operationKey,
    Duration minimumInterval, {
    String operationName = 'Throttled Operation',
  }) {
    final now = DateTime.now();
    final lastExecution = lastExecutionTimes[operationKey];

    if (lastExecution == null ||
        now.difference(lastExecution) >= minimumInterval) {
      lastExecutionTimes[operationKey] = now;
      debugPrint('✅ Executing throttled operation: $operationName');
      return true;
    }

    debugPrint('⏳ Throttled operation skipped: $operationName');
    return false;
  }

  /// Execute operation in isolate for CPU-intensive tasks
  static Future<R?> executeInIsolate<T, R>(
    R Function(T data) computation,
    T data, {
    String operationName = 'Isolate Operation',
  }) async {
    try {
      debugPrint('🔄 Starting isolate operation: $operationName');

      final result = await compute(computation, data);

      debugPrint('✅ Isolate operation completed: $operationName');
      return result;
    } catch (e) {
      debugPrint('❌ Isolate operation failed: $operationName - $e');
      return null;
    }
  }

  /// Monitor operation performance and warn about potential ANR issues
  static Future<T> monitorPerformance<T>(
    Future<T> Function() operation, {
    required String operationName,
    Duration warningThreshold = const Duration(seconds: 1),
    Duration errorThreshold = const Duration(seconds: 3),
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      final result = await operation();
      stopwatch.stop();

      final duration = stopwatch.elapsed;

      if (duration > errorThreshold) {
        debugPrint(
          '🚨 CRITICAL: $operationName took ${duration.inMilliseconds}ms - Potential ANR risk!',
        );
      } else if (duration > warningThreshold) {
        debugPrint(
          '⚠️ WARNING: $operationName took ${duration.inMilliseconds}ms - Consider optimization',
        );
      } else {
        debugPrint(
          '✅ $operationName completed in ${duration.inMilliseconds}ms',
        );
      }

      return result;
    } catch (e) {
      stopwatch.stop();
      debugPrint(
        '❌ $operationName failed after ${stopwatch.elapsed.inMilliseconds}ms: $e',
      );
      rethrow;
    }
  }

  /// Create a circuit breaker to prevent cascading failures
  static CircuitBreaker createCircuitBreaker({
    required String name,
    int failureThreshold = 5,
    Duration timeout = const Duration(minutes: 1),
  }) {
    return CircuitBreaker(
      name: name,
      failureThreshold: failureThreshold,
      timeout: timeout,
    );
  }

  /// Yield control to UI thread periodically during long operations
  static Future<void> yieldToUI() async {
    await Future.delayed(Duration.zero);
  }

  /// Check if operation should be cancelled due to app state
  static bool shouldCancelOperation(bool isAppInBackground) {
    if (isAppInBackground) {
      debugPrint('⏸️ Cancelling operation - app is in background');
      return true;
    }
    return false;
  }
}

/// Semaphore implementation for controlling concurrency
class Semaphore {
  final int maxCount;
  int _currentCount;
  final Queue<Completer<void>> _waitQueue = Queue<Completer<void>>();

  Semaphore(this.maxCount) : _currentCount = maxCount;

  Future<void> acquire() async {
    if (_currentCount > 0) {
      _currentCount--;
      return;
    }

    final completer = Completer<void>();
    _waitQueue.add(completer);
    return completer.future;
  }

  void release() {
    if (_waitQueue.isNotEmpty) {
      final completer = _waitQueue.removeFirst();
      completer.complete();
    } else {
      _currentCount++;
    }
  }
}

/// Circuit breaker pattern implementation
class CircuitBreaker {
  final String name;
  final int failureThreshold;
  final Duration timeout;

  int _failureCount = 0;
  DateTime? _lastFailureTime;
  bool _isOpen = false;

  CircuitBreaker({
    required this.name,
    required this.failureThreshold,
    required this.timeout,
  });

  Future<T> execute<T>(Future<T> Function() operation) async {
    if (_isOpen) {
      if (_lastFailureTime != null &&
          DateTime.now().difference(_lastFailureTime!) > timeout) {
        _isOpen = false;
        _failureCount = 0;
        debugPrint('🔄 Circuit breaker $name reset - attempting operation');
      } else {
        debugPrint('⚡ Circuit breaker $name is OPEN - operation blocked');
        throw Exception('Circuit breaker $name is open');
      }
    }

    try {
      final result = await operation();
      _failureCount = 0;
      return result;
    } catch (e) {
      _failureCount++;
      _lastFailureTime = DateTime.now();

      if (_failureCount >= failureThreshold) {
        _isOpen = true;
        debugPrint(
          '⚡ Circuit breaker $name OPENED after $failureThreshold failures',
        );
      }

      rethrow;
    }
  }
}
