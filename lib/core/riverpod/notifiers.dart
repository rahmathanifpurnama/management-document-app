import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

/// Base notifier class for StateNotifier
/// Provides common functionality and error handling
abstract class BaseNotifier<T> extends StateNotifier<T> {
  BaseNotifier(super.initialState);

  /// Safe state update with error handling
  void safeUpdate(T Function() updater) {
    if (mounted) {
      try {
        state = updater();
      } catch (e) {
        debugPrint('$runtimeType Error updating state: $e');
        handleError(e);
      }
    }
  }

  /// Handle errors - override in subclasses
  void handleError(Object error) {
    debugPrint('$runtimeType Error: $error');
  }

  /// Reset to initial state - override in subclasses
  void reset() {
    // Override in subclasses
  }

  @override
  void dispose() {
    debugPrint('$runtimeType disposed');
    super.dispose();
  }
}

/// Base async notifier class for AsyncNotifier
/// Provides common functionality for async operations
abstract class BaseAsyncNotifier<T> extends AsyncNotifier<T> {
  /// Safe async operation with error handling
  Future<void> safeAsyncOperation(Future<T> Function() operation) async {
    state = const AsyncValue.loading();

    try {
      final result = await operation();
      // AsyncNotifier doesn't have mounted property, so we just update state
      state = AsyncValue.data(result);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      handleAsyncError(error, stackTrace);
    }
  }

  /// Handle errors - override in subclasses
  void handleAsyncError(Object error, StackTrace stackTrace) {
    debugPrint('$runtimeType Error: $error');
    debugPrint('StackTrace: $stackTrace');
  }

  /// Refresh data - override in subclasses
  Future<void> refresh() async {
    // Override in subclasses
  }
}
