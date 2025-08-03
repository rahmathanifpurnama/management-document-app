import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../exceptions/custom_exceptions.dart';
import 'error_recovery_strategies.dart';
import 'error_logger.dart';

/// Centralized Error Handler following OOP principles
/// Implements Strategy pattern for different error handling approaches
class ErrorHandler {
  static final ErrorHandler _instance = ErrorHandler._internal();
  factory ErrorHandler() => _instance;
  ErrorHandler._internal();

  static ErrorHandler get instance => _instance;

  final ErrorLogger _logger = ErrorLogger.instance;
  final Map<Type, ErrorRecoveryStrategy> _recoveryStrategies = {};
  final List<ErrorObserver> _observers = [];

  /// Initialize error handler with default strategies
  void initialize() {
    // Register default recovery strategies
    _recoveryStrategies[NetworkException] = NetworkErrorRecoveryStrategy();
    _recoveryStrategies[AuthenticationException] =
        AuthenticationErrorRecoveryStrategy();
    _recoveryStrategies[DataException] = DataErrorRecoveryStrategy();
    _recoveryStrategies[FileOperationException] =
        FileOperationErrorRecoveryStrategy();
  }

  /// Register a custom recovery strategy for a specific exception type
  void registerRecoveryStrategy<T extends AppException>(
    ErrorRecoveryStrategy strategy,
  ) {
    _recoveryStrategies[T] = strategy;
  }

  /// Add an error observer
  void addObserver(ErrorObserver observer) {
    _observers.add(observer);
  }

  /// Remove an error observer
  void removeObserver(ErrorObserver observer) {
    _observers.remove(observer);
  }

  /// Handle an exception with appropriate strategy
  Future<ErrorHandlingResult> handleError(
    dynamic error, {
    StackTrace? stackTrace,
    BuildContext? context,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      // Convert to AppException if needed
      final appException = _convertToAppException(error, stackTrace);

      // Log the error
      await _logger.logError(appException, additionalData: additionalData);

      // Notify observers
      _notifyObservers(appException);

      // Find appropriate recovery strategy
      final strategy = _findRecoveryStrategy(appException);

      // Execute recovery strategy
      final result = await strategy.recover(appException, context: context);

      // Log recovery result
      await _logger.logRecoveryAttempt(appException, result);

      return result;
    } catch (handlingError) {
      // Fallback error handling
      debugPrint('Error in error handler: $handlingError');
      return ErrorHandlingResult.failed(
        'An unexpected error occurred while handling the original error.',
      );
    }
  }

  /// Handle error with user notification
  Future<ErrorHandlingResult> handleErrorWithNotification(
    dynamic error, {
    StackTrace? stackTrace,
    BuildContext? context,
    bool showUserMessage = true,
    Map<String, dynamic>? additionalData,
  }) async {
    final result = await handleError(
      error,
      stackTrace: stackTrace,
      context: context,
      additionalData: additionalData,
    );

    // Show user notification if requested and context is available
    if (showUserMessage && context != null && context.mounted) {
      await _showUserNotification(context, result);
    }

    return result;
  }

  /// Convert any error to AppException
  AppException _convertToAppException(dynamic error, StackTrace? stackTrace) {
    if (error is AppException) {
      return error;
    }

    // Convert common Flutter/Dart exceptions
    if (error is FormatException) {
      return DataValidationException(
        message: error.message,
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is ArgumentError) {
      return DataValidationException(
        message: error.message ?? 'Invalid argument provided',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is StateError) {
      return DataCorruptionException(
        message: error.message,
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    // Default to generic app exception
    return GenericAppException(
      message: error.toString(),
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  /// Find appropriate recovery strategy for exception type
  ErrorRecoveryStrategy _findRecoveryStrategy(AppException exception) {
    // Look for exact type match first
    final exactStrategy = _recoveryStrategies[exception.runtimeType];
    if (exactStrategy != null) {
      return exactStrategy;
    }

    // Look for parent type matches
    for (final entry in _recoveryStrategies.entries) {
      if (exception.runtimeType.toString().contains(
        entry.key.toString().split('.').last,
      )) {
        return entry.value;
      }
    }

    // Fallback to default strategy
    return DefaultErrorRecoveryStrategy();
  }

  /// Notify all observers about the error
  void _notifyObservers(AppException exception) {
    for (final observer in _observers) {
      try {
        observer.onError(exception);
      } catch (e) {
        debugPrint('Error in observer notification: $e');
      }
    }
  }

  /// Show user notification based on error handling result
  Future<void> _showUserNotification(
    BuildContext context,
    ErrorHandlingResult result,
  ) async {
    if (!context.mounted) return;

    switch (result.type) {
      case ErrorHandlingResultType.recovered:
        _showSuccessSnackBar(context, result.message);
        break;
      case ErrorHandlingResultType.partiallyRecovered:
        _showWarningSnackBar(context, result.message);
        break;
      case ErrorHandlingResultType.failed:
        _showErrorDialog(context, result.message);
        break;
      case ErrorHandlingResultType.retryRequired:
        _showRetryDialog(context, result.message, result.retryAction);
        break;
    }
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showWarningSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showRetryDialog(
    BuildContext context,
    String message,
    VoidCallback? retryAction,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          if (retryAction != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                retryAction();
              },
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }
}

/// Generic app exception for unknown errors
class GenericAppException extends AppException {
  GenericAppException({
    required super.message,
    super.code = 'GENERIC_ERROR',
    super.originalError,
    super.stackTrace,
    super.timestamp,
  });

  @override
  String get userMessage => 'An unexpected error occurred. Please try again.';

  @override
  bool get isRecoverable => true;
}

/// Error handling result
class ErrorHandlingResult {
  final ErrorHandlingResultType type;
  final String message;
  final VoidCallback? retryAction;
  final Map<String, dynamic>? additionalData;

  const ErrorHandlingResult._({
    required this.type,
    required this.message,
    this.retryAction,
    this.additionalData,
  });

  factory ErrorHandlingResult.recovered(String message) {
    return ErrorHandlingResult._(
      type: ErrorHandlingResultType.recovered,
      message: message,
    );
  }

  factory ErrorHandlingResult.partiallyRecovered(String message) {
    return ErrorHandlingResult._(
      type: ErrorHandlingResultType.partiallyRecovered,
      message: message,
    );
  }

  factory ErrorHandlingResult.failed(String message) {
    return ErrorHandlingResult._(
      type: ErrorHandlingResultType.failed,
      message: message,
    );
  }

  factory ErrorHandlingResult.retryRequired(
    String message,
    VoidCallback retryAction,
  ) {
    return ErrorHandlingResult._(
      type: ErrorHandlingResultType.retryRequired,
      message: message,
      retryAction: retryAction,
    );
  }
}

/// Error handling result types
enum ErrorHandlingResultType {
  recovered,
  partiallyRecovered,
  failed,
  retryRequired,
}

/// Observer pattern for error notifications
abstract class ErrorObserver {
  void onError(AppException exception);
}

/// Analytics error observer
class AnalyticsErrorObserver implements ErrorObserver {
  @override
  void onError(AppException exception) {
    // Send error to analytics service
    debugPrint(
      'Analytics: Error occurred - ${exception.code}: ${exception.message}',
    );
  }
}

/// Crash reporting error observer
class CrashReportingErrorObserver implements ErrorObserver {
  @override
  void onError(AppException exception) {
    // Send error to crash reporting service
    if (exception.severity == ErrorSeverity.critical) {
      debugPrint(
        'Crash Report: Critical error - ${exception.code}: ${exception.message}',
      );
    }
  }
}
