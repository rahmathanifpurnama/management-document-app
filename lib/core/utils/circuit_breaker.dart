import 'dart:async';
import 'package:flutter/foundation.dart';
import '../config/anr_config.dart';

/// Circuit breaker pattern implementation to prevent infinite retry loops
/// Prevents continuous failed operations from overwhelming the system
class CircuitBreaker {
  static final Map<String, _CircuitBreakerState> _circuits = {};

  /// Execute operation with circuit breaker protection (reduced logging)
  static Future<T?> execute<T>(
    String operationId,
    Future<T> Function() operation, {
    String? operationName,
    int? maxFailures,
    Duration? resetTime,
    Duration? cooldown,
    bool enableLogging = false, // REDUCED LOGGING: Disabled by default
  }) async {
    final effectiveMaxFailures =
        maxFailures ?? ANRConfig.maxConsecutiveFailures;
    final effectiveResetTime = resetTime ?? ANRConfig.circuitBreakerResetTime;
    final effectiveCooldown = cooldown ?? ANRConfig.circuitBreakerCooldown;

    final circuit = _circuits.putIfAbsent(
      operationId,
      () => _CircuitBreakerState(
        operationId: operationId,
        maxFailures: effectiveMaxFailures,
        resetTime: effectiveResetTime,
        cooldown: effectiveCooldown,
      ),
    );

    return await circuit.execute(operation, operationName: operationName);
  }

  /// Check if circuit is open for given operation
  static bool isCircuitOpen(String operationId) {
    final circuit = _circuits[operationId];
    return circuit?.isOpen ?? false;
  }

  /// Reset circuit breaker for given operation
  static void resetCircuit(String operationId) {
    final circuit = _circuits[operationId];
    circuit?.reset();
    debugPrint('🔄 Circuit breaker reset for: $operationId');
  }

  /// Reset all circuit breakers
  static void resetAllCircuits() {
    for (final circuit in _circuits.values) {
      circuit.reset();
    }
    debugPrint('🔄 All circuit breakers reset');
  }

  /// Get circuit breaker status for debugging
  static Map<String, Map<String, dynamic>> getCircuitStatus() {
    return _circuits.map(
      (key, circuit) => MapEntry(key, {
        'operationId': circuit.operationId,
        'state': circuit.state.toString(),
        'failureCount': circuit.failureCount,
        'lastFailureTime': circuit.lastFailureTime?.toIso8601String(),
        'nextRetryTime': circuit.nextRetryTime?.toIso8601String(),
      }),
    );
  }
}

/// Internal circuit breaker state management
class _CircuitBreakerState {
  final String operationId;
  final int maxFailures;
  final Duration resetTime;
  final Duration cooldown;

  int failureCount = 0;
  DateTime? lastFailureTime;
  DateTime? nextRetryTime;
  _CircuitState state = _CircuitState.closed;

  _CircuitBreakerState({
    required this.operationId,
    required this.maxFailures,
    required this.resetTime,
    required this.cooldown,
  });

  bool get isOpen => state == _CircuitState.open;
  bool get isHalfOpen => state == _CircuitState.halfOpen;
  bool get isClosed => state == _CircuitState.closed;

  Future<T?> execute<T>(
    Future<T> Function() operation, {
    String? operationName,
  }) async {
    final now = DateTime.now();

    // Check if circuit should transition from open to half-open
    if (isOpen && nextRetryTime != null && now.isAfter(nextRetryTime!)) {
      state = _CircuitState.halfOpen;
      debugPrint('🔄 Circuit breaker half-open for: $operationId');
    }

    // Reject if circuit is open
    if (isOpen) {
      final timeUntilRetry = nextRetryTime?.difference(now);
      debugPrint(
        '🚫 Circuit breaker OPEN for: $operationId '
        '(retry in ${timeUntilRetry?.inMinutes ?? 0} minutes)',
      );
      return null;
    }

    // Check cooldown period
    if (lastFailureTime != null &&
        now.difference(lastFailureTime!).compareTo(cooldown) < 0) {
      debugPrint('⏳ Circuit breaker cooldown active for: $operationId');
      return null;
    }

    try {
      debugPrint('🔄 Executing operation: ${operationName ?? operationId}');
      final result = await operation();

      // Success - reset circuit
      if (isHalfOpen || failureCount > 0) {
        reset();
        debugPrint('✅ Circuit breaker reset after success: $operationId');
      }

      return result;
    } catch (e) {
      _recordFailure();
      debugPrint('❌ Circuit breaker recorded failure for: $operationId ($e)');
      return null;
    }
  }

  void _recordFailure() {
    failureCount++;
    lastFailureTime = DateTime.now();

    if (failureCount >= maxFailures) {
      state = _CircuitState.open;
      nextRetryTime = DateTime.now().add(resetTime);
      debugPrint(
        '🔴 Circuit breaker OPENED for: $operationId '
        '(${failureCount} failures, retry at ${nextRetryTime!.toLocal()})',
      );
    } else {
      debugPrint(
        '⚠️ Circuit breaker failure $failureCount/$maxFailures for: $operationId',
      );
    }
  }

  void reset() {
    failureCount = 0;
    lastFailureTime = null;
    nextRetryTime = null;
    state = _CircuitState.closed;
  }
}

enum _CircuitState {
  closed, // Normal operation
  open, // Failing, rejecting calls
  halfOpen, // Testing if service recovered
}
