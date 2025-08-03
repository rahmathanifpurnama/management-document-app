import 'package:flutter/material.dart';
import '../exceptions/custom_exceptions.dart';
import 'error_handler.dart';

/// Strategy pattern for error recovery
/// Each strategy handles specific types of errors with appropriate recovery mechanisms

// ============================================================================
// BASE STRATEGY
// ============================================================================

/// Abstract base class for error recovery strategies
abstract class ErrorRecoveryStrategy {
  /// Attempt to recover from the given exception
  Future<ErrorHandlingResult> recover(
    AppException exception, {
    BuildContext? context,
    Map<String, dynamic>? additionalData,
  });

  /// Check if this strategy can handle the given exception
  bool canHandle(AppException exception);

  /// Get recovery priority (higher number = higher priority)
  int get priority => 0;
}

// ============================================================================
// NETWORK ERROR RECOVERY
// ============================================================================

/// Recovery strategy for network-related errors
class NetworkErrorRecoveryStrategy extends ErrorRecoveryStrategy {
  @override
  Future<ErrorHandlingResult> recover(
    AppException exception, {
    BuildContext? context,
    Map<String, dynamic>? additionalData,
  }) async {
    if (exception is ConnectionTimeoutException) {
      return _handleConnectionTimeout(exception);
    }
    
    if (exception is NoInternetException) {
      return _handleNoInternet(exception);
    }
    
    if (exception is ServerException) {
      return _handleServerError(exception);
    }

    return ErrorHandlingResult.failed(exception.userMessage);
  }

  @override
  bool canHandle(AppException exception) {
    return exception is NetworkException;
  }

  @override
  int get priority => 10;

  ErrorHandlingResult _handleConnectionTimeout(ConnectionTimeoutException exception) {
    return ErrorHandlingResult.retryRequired(
      'Connection timed out. Would you like to try again?',
      () {
        // Retry logic would be implemented here
        debugPrint('Retrying connection...');
      },
    );
  }

  ErrorHandlingResult _handleNoInternet(NoInternetException exception) {
    return ErrorHandlingResult.retryRequired(
      'No internet connection. Please check your network and try again.',
      () {
        // Retry logic would be implemented here
        debugPrint('Retrying with network check...');
      },
    );
  }

  ErrorHandlingResult _handleServerError(ServerException exception) {
    if (exception.statusCode != null && exception.statusCode! >= 500) {
      return ErrorHandlingResult.retryRequired(
        'Server is temporarily unavailable. Try again in a few moments.',
        () {
          // Retry with exponential backoff
          debugPrint('Retrying server request...');
        },
      );
    }

    return ErrorHandlingResult.failed(exception.userMessage);
  }
}

// ============================================================================
// AUTHENTICATION ERROR RECOVERY
// ============================================================================

/// Recovery strategy for authentication-related errors
class AuthenticationErrorRecoveryStrategy extends ErrorRecoveryStrategy {
  @override
  Future<ErrorHandlingResult> recover(
    AppException exception, {
    BuildContext? context,
    Map<String, dynamic>? additionalData,
  }) async {
    if (exception is SessionExpiredException) {
      return _handleSessionExpired(exception, context);
    }
    
    if (exception is InvalidCredentialsException) {
      return _handleInvalidCredentials(exception);
    }
    
    if (exception is InsufficientPermissionsException) {
      return _handleInsufficientPermissions(exception);
    }

    return ErrorHandlingResult.failed(exception.userMessage);
  }

  @override
  bool canHandle(AppException exception) {
    return exception is AuthenticationException;
  }

  @override
  int get priority => 15;

  ErrorHandlingResult _handleSessionExpired(
    SessionExpiredException exception,
    BuildContext? context,
  ) {
    // Navigate to login screen
    if (context != null && context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      });
    }

    return ErrorHandlingResult.partiallyRecovered(
      'Session expired. Please log in again.',
    );
  }

  ErrorHandlingResult _handleInvalidCredentials(InvalidCredentialsException exception) {
    return ErrorHandlingResult.failed(
      'Invalid credentials. Please check your email and password.',
    );
  }

  ErrorHandlingResult _handleInsufficientPermissions(InsufficientPermissionsException exception) {
    return ErrorHandlingResult.failed(
      'You don\'t have permission to perform this action.',
    );
  }
}

// ============================================================================
// DATA ERROR RECOVERY
// ============================================================================

/// Recovery strategy for data-related errors
class DataErrorRecoveryStrategy extends ErrorRecoveryStrategy {
  @override
  Future<ErrorHandlingResult> recover(
    AppException exception, {
    BuildContext? context,
    Map<String, dynamic>? additionalData,
  }) async {
    if (exception is DataNotFoundException) {
      return _handleDataNotFound(exception);
    }
    
    if (exception is DataValidationException) {
      return _handleDataValidation(exception);
    }
    
    if (exception is DataCorruptionException) {
      return _handleDataCorruption(exception);
    }

    return ErrorHandlingResult.failed(exception.userMessage);
  }

  @override
  bool canHandle(AppException exception) {
    return exception is DataException;
  }

  @override
  int get priority => 8;

  ErrorHandlingResult _handleDataNotFound(DataNotFoundException exception) {
    return ErrorHandlingResult.retryRequired(
      'The requested data could not be found. Would you like to refresh?',
      () {
        // Refresh data logic
        debugPrint('Refreshing data...');
      },
    );
  }

  ErrorHandlingResult _handleDataValidation(DataValidationException exception) {
    return ErrorHandlingResult.failed(exception.userMessage);
  }

  ErrorHandlingResult _handleDataCorruption(DataCorruptionException exception) {
    return ErrorHandlingResult.retryRequired(
      'Data corruption detected. Would you like to reload the data?',
      () {
        // Reload data from server
        debugPrint('Reloading data from server...');
      },
    );
  }
}

// ============================================================================
// FILE OPERATION ERROR RECOVERY
// ============================================================================

/// Recovery strategy for file operation errors
class FileOperationErrorRecoveryStrategy extends ErrorRecoveryStrategy {
  @override
  Future<ErrorHandlingResult> recover(
    AppException exception, {
    BuildContext? context,
    Map<String, dynamic>? additionalData,
  }) async {
    if (exception is FileNotFoundException) {
      return _handleFileNotFound(exception);
    }
    
    if (exception is InsufficientStorageException) {
      return _handleInsufficientStorage(exception);
    }
    
    if (exception is FileAccessDeniedException) {
      return _handleFileAccessDenied(exception);
    }

    return ErrorHandlingResult.failed(exception.userMessage);
  }

  @override
  bool canHandle(AppException exception) {
    return exception is FileOperationException;
  }

  @override
  int get priority => 5;

  ErrorHandlingResult _handleFileNotFound(FileNotFoundException exception) {
    return ErrorHandlingResult.retryRequired(
      'File not found. Would you like to refresh the file list?',
      () {
        // Refresh file list
        debugPrint('Refreshing file list...');
      },
    );
  }

  ErrorHandlingResult _handleInsufficientStorage(InsufficientStorageException exception) {
    return ErrorHandlingResult.failed(
      'Not enough storage space. Please free up some space and try again.',
    );
  }

  ErrorHandlingResult _handleFileAccessDenied(FileAccessDeniedException exception) {
    return ErrorHandlingResult.failed(
      'Access denied. Please check file permissions.',
    );
  }
}

// ============================================================================
// DEFAULT ERROR RECOVERY
// ============================================================================

/// Default recovery strategy for unhandled errors
class DefaultErrorRecoveryStrategy extends ErrorRecoveryStrategy {
  @override
  Future<ErrorHandlingResult> recover(
    AppException exception, {
    BuildContext? context,
    Map<String, dynamic>? additionalData,
  }) async {
    // Log the unhandled error
    debugPrint('Unhandled error: ${exception.runtimeType} - ${exception.message}');

    if (exception.isRecoverable) {
      return ErrorHandlingResult.retryRequired(
        exception.userMessage,
        () {
          // Generic retry logic
          debugPrint('Retrying operation...');
        },
      );
    }

    return ErrorHandlingResult.failed(exception.userMessage);
  }

  @override
  bool canHandle(AppException exception) {
    return true; // Can handle any exception as fallback
  }

  @override
  int get priority => 0; // Lowest priority
}

// ============================================================================
// COMPOSITE RECOVERY STRATEGY
// ============================================================================

/// Composite strategy that tries multiple recovery strategies
class CompositeErrorRecoveryStrategy extends ErrorRecoveryStrategy {
  final List<ErrorRecoveryStrategy> _strategies = [];

  void addStrategy(ErrorRecoveryStrategy strategy) {
    _strategies.add(strategy);
    _strategies.sort((a, b) => b.priority.compareTo(a.priority));
  }

  void removeStrategy(ErrorRecoveryStrategy strategy) {
    _strategies.remove(strategy);
  }

  @override
  Future<ErrorHandlingResult> recover(
    AppException exception, {
    BuildContext? context,
    Map<String, dynamic>? additionalData,
  }) async {
    for (final strategy in _strategies) {
      if (strategy.canHandle(exception)) {
        try {
          final result = await strategy.recover(
            exception,
            context: context,
            additionalData: additionalData,
          );
          
          // If recovery was successful or partially successful, return result
          if (result.type == ErrorHandlingResultType.recovered ||
              result.type == ErrorHandlingResultType.partiallyRecovered) {
            return result;
          }
          
          // If retry is required, return that result
          if (result.type == ErrorHandlingResultType.retryRequired) {
            return result;
          }
          
          // Continue to next strategy if this one failed
        } catch (e) {
          debugPrint('Error in recovery strategy ${strategy.runtimeType}: $e');
          // Continue to next strategy
        }
      }
    }

    // If no strategy could handle the error, return failed result
    return ErrorHandlingResult.failed(exception.userMessage);
  }

  @override
  bool canHandle(AppException exception) {
    return _strategies.any((strategy) => strategy.canHandle(exception));
  }

  @override
  int get priority => _strategies.isNotEmpty 
      ? _strategies.map((s) => s.priority).reduce((a, b) => a > b ? a : b)
      : 0;
}
