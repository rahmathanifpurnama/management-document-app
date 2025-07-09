import 'package:equatable/equatable.dart';

/// Base class for all BLoC events
/// Provides common functionality and ensures consistency across all events
abstract class BaseEvent extends Equatable {
  const BaseEvent();

  @override
  List<Object?> get props => [];

  @override
  bool get stringify => true;
}

/// Common events that can be used across different BLoCs
abstract class CommonEvent extends BaseEvent {
  const CommonEvent();
}

/// Event for refreshing data
class RefreshEvent extends CommonEvent {
  const RefreshEvent();
}

/// Event for clearing data
class ClearEvent extends CommonEvent {
  const ClearEvent();
}

/// Event for resetting to initial state
class ResetEvent extends CommonEvent {
  const ResetEvent();
}
