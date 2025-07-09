import 'dart:async';
import 'package:flutter/foundation.dart';

/// Base repository class that provides common functionality
/// All repositories should extend this class for consistency
abstract class BaseRepository {
  
  /// Timeout duration for network operations
  static const Duration defaultTimeout = Duration(seconds: 30);

  /// Execute an operation with timeout and error handling
  Future<T> executeWithTimeout<T>(
    Future<T> Function() operation, {
    Duration? timeout,
    String? operationName,
  }) async {
    try {
      final result = await operation().timeout(
        timeout ?? defaultTimeout,
        onTimeout: () {
          throw TimeoutException(
            'Operation ${operationName ?? 'unknown'} timed out',
            timeout ?? defaultTimeout,
          );
        },
      );
      return result;
    } catch (e) {
      debugPrint('Repository Error in ${operationName ?? 'unknown'}: $e');
      rethrow;
    }
  }

  /// Execute an operation with retry logic
  Future<T> executeWithRetry<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
    String? operationName,
  }) async {
    int attempts = 0;
    
    while (attempts < maxRetries) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        
        if (attempts >= maxRetries) {
          debugPrint('Repository: Max retries reached for ${operationName ?? 'unknown'}');
          rethrow;
        }
        
        debugPrint('Repository: Retry $attempts for ${operationName ?? 'unknown'}: $e');
        await Future.delayed(delay * attempts);
      }
    }
    
    throw Exception('Max retries exceeded');
  }

  /// Check if the repository is available (network, permissions, etc.)
  Future<bool> isAvailable() async {
    return true; // Override in subclasses
  }

  /// Dispose resources
  void dispose() {
    // Override in subclasses if needed
  }
}
