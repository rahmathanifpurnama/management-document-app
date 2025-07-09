import 'package:equatable/equatable.dart';

/// Base class for all BLoC states
/// Provides common functionality and ensures consistency across all states
abstract class BaseState extends Equatable {
  const BaseState();

  @override
  List<Object?> get props => [];

  @override
  bool get stringify => true;
}

/// Common loading state
class LoadingState extends BaseState {
  const LoadingState();
}

/// Common error state
class ErrorState extends BaseState {
  final String message;
  final String? code;
  final dynamic error;

  const ErrorState({
    required this.message,
    this.code,
    this.error,
  });

  @override
  List<Object?> get props => [message, code, error];
}

/// Common initial state
class InitialState extends BaseState {
  const InitialState();
}

/// Common success state
class SuccessState extends BaseState {
  final String? message;

  const SuccessState({this.message});

  @override
  List<Object?> get props => [message];
}
