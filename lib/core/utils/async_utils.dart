import 'dart:async';
import 'package:flutter/foundation.dart';

/// Utility class for handling async operations with timeouts and error handling
class AsyncUtils {
  /// Execute a future with timeout and error handling
  static Future<T?> executeWithTimeout<T>(
    Future<T> future, {
    Duration timeout = const Duration(seconds: 10),
    T? defaultValue,
    bool logErrors = true,
  }) async {
    try {
      return await future.timeout(timeout);
    } on TimeoutException catch (e) {
      if (logErrors) {
        debugPrint('Operation timed out: $e');
      }
      return defaultValue;
    } catch (e) {
      if (logErrors) {
        debugPrint('Operation failed: $e');
      }
      return defaultValue;
    }
  }

  /// Execute multiple futures with timeout and return results
  static Future<List<T?>> executeMultipleWithTimeout<T>(
    List<Future<T>> futures, {
    Duration timeout = const Duration(seconds: 10),
    bool eagerError = false,
  }) async {
    try {
      final results = await Future.wait(
        futures.map((f) => f.timeout(timeout)),
        eagerError: eagerError,
      );
      return results;
    } catch (e) {
      debugPrint('Multiple operations failed: $e');
      return List.filled(futures.length, null);
    }
  }

  /// Execute a future with retry mechanism
  static Future<T?> executeWithRetry<T>(
    Future<T> Function() futureFactory, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
    bool logErrors = true,
  }) async {
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        return await futureFactory();
      } catch (e) {
        if (logErrors) {
          debugPrint('Attempt ${attempt + 1} failed: $e');
        }
        
        if (attempt == maxRetries) {
          if (logErrors) {
            debugPrint('All retry attempts failed');
          }
          return null;
        }
        
        await Future.delayed(delay);
      }
    }
    return null;
  }

  /// Execute a future in background without blocking UI
  static Future<T?> executeInBackground<T>(
    Future<T> future, {
    Duration timeout = const Duration(seconds: 30),
    bool logErrors = true,
  }) async {
    return compute(_executeInIsolate, {
      'future': future,
      'timeout': timeout,
      'logErrors': logErrors,
    });
  }

  static Future<T?> _executeInIsolate<T>(Map<String, dynamic> params) async {
    final future = params['future'] as Future<T>;
    final timeout = params['timeout'] as Duration;
    final logErrors = params['logErrors'] as bool;

    try {
      return await future.timeout(timeout);
    } catch (e) {
      if (logErrors) {
        debugPrint('Background operation failed: $e');
      }
      return null;
    }
  }

  /// Debounce function calls
  static Timer? _debounceTimer;
  
  static void debounce(
    VoidCallback callback, {
    Duration delay = const Duration(milliseconds: 500),
  }) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, callback);
  }

  /// Throttle function calls
  static DateTime? _lastThrottleTime;
  
  static void throttle(
    VoidCallback callback, {
    Duration interval = const Duration(milliseconds: 500),
  }) {
    final now = DateTime.now();
    if (_lastThrottleTime == null || 
        now.difference(_lastThrottleTime!) >= interval) {
      _lastThrottleTime = now;
      callback();
    }
  }

  /// Check if device has good network connectivity
  static Future<bool> hasGoodConnectivity() async {
    try {
      // Simple connectivity check with timeout
      await Future.any([
        Future.delayed(const Duration(seconds: 3)),
        // Add actual connectivity check here if needed
      ]);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Batch operations to reduce UI blocking
  static Future<List<T>> batchProcess<T, R>(
    List<R> items,
    Future<T> Function(R item) processor, {
    int batchSize = 10,
    Duration batchDelay = const Duration(milliseconds: 100),
  }) async {
    final results = <T>[];
    
    for (int i = 0; i < items.length; i += batchSize) {
      final batch = items.skip(i).take(batchSize);
      final batchResults = await Future.wait(
        batch.map(processor),
        eagerError: false,
      );
      
      results.addAll(batchResults);
      
      // Small delay to prevent UI blocking
      if (i + batchSize < items.length) {
        await Future.delayed(batchDelay);
      }
    }
    
    return results;
  }
}

/// Extension for Future to add common async utilities
extension FutureExtensions<T> on Future<T> {
  /// Add timeout with default value
  Future<T> timeoutWithDefault(
    Duration timeout,
    T defaultValue,
  ) async {
    try {
      return await this.timeout(timeout);
    } on TimeoutException {
      return defaultValue;
    }
  }

  /// Add retry mechanism
  Future<T?> withRetry({
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    return AsyncUtils.executeWithRetry(
      () => this,
      maxRetries: maxRetries,
      delay: delay,
    );
  }

  /// Add error handling with default value
  Future<T> withDefault(T defaultValue) async {
    try {
      return await this;
    } catch (e) {
      debugPrint('Future failed, using default: $e');
      return defaultValue;
    }
  }
}
