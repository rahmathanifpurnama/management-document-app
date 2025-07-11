import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'base_event.dart';
import 'base_state.dart';

/// Base BLoC class that provides common functionality
/// All BLoCs should extend this class for consistency
abstract class BaseBloc<Event extends BaseEvent, State extends BaseState>
    extends Bloc<Event, State> {
  BaseBloc(super.initialState) {
    // Handle common events - only register if Event type supports them
    // Subclasses should override and register their specific events
  }

  /// Override this method to handle refresh logic
  Future<void> onRefresh(Emitter<State> emit) async {
    // Default implementation - subclasses can override
    debugPrint('$runtimeType: Refresh not implemented');
  }

  /// Override this method to handle clear logic
  Future<void> onClear(Emitter<State> emit) async {
    // Default implementation - subclasses can override
    debugPrint('$runtimeType: Clear not implemented');
  }

  /// Override this method to handle reset logic
  Future<void> onReset(Emitter<State> emit) async {
    // Default implementation - subclasses can override
    debugPrint('$runtimeType: Reset not implemented');
  }

  /// Helper method to emit error states
  void emitError(
    Emitter<State> emit,
    String message, {
    String? code,
    dynamic error,
  }) {
    if (emit.isDone) return;

    final errorState =
        ErrorState(message: message, code: code, error: error) as State;

    emit(errorState);
  }

  /// Helper method to emit loading states
  void emitLoading(Emitter<State> emit) {
    if (emit.isDone) return;

    final loadingState = LoadingState() as State;
    emit(loadingState);
  }

  /// Helper method to emit success states
  void emitSuccess(Emitter<State> emit, {String? message}) {
    if (emit.isDone) return;

    final successState = SuccessState(message: message) as State;
    emit(successState);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    debugPrint('$runtimeType Error: $error');
    debugPrint('StackTrace: $stackTrace');
    super.onError(error, stackTrace);
  }

  @override
  void onTransition(Transition<Event, State> transition) {
    if (kDebugMode) {
      debugPrint(
        '$runtimeType Transition: ${transition.currentState} -> ${transition.nextState}',
      );
    }
    super.onTransition(transition);
  }
}
