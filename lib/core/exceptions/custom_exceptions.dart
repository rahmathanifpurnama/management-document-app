/// Custom Exception Classes following OOP principles
/// Implements inheritance hierarchy for different error scenarios

// ============================================================================
// BASE EXCEPTION CLASS
// ============================================================================

/// Base exception class for all application exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;
  final DateTime timestamp;

  AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Get user-friendly error message
  String get userMessage => message;

  /// Get technical error details
  String get technicalDetails =>
      'Code: ${code ?? 'UNKNOWN'}, Error: ${originalError?.toString() ?? 'N/A'}';

  /// Check if error is recoverable
  bool get isRecoverable => false;

  /// Get error severity level
  ErrorSeverity get severity => ErrorSeverity.medium;

  @override
  String toString() => 'AppException: $message';
}

/// Error severity levels
enum ErrorSeverity { low, medium, high, critical }

// ============================================================================
// NETWORK EXCEPTIONS
// ============================================================================

/// Base class for network-related exceptions
abstract class NetworkException extends AppException {
  NetworkException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
    super.timestamp,
  });

  @override
  ErrorSeverity get severity => ErrorSeverity.high;
}

/// Exception for connection timeout
class ConnectionTimeoutException extends NetworkException {
  ConnectionTimeoutException({
    super.message = 'Connection timeout occurred',
    super.code = 'NETWORK_TIMEOUT',
    super.originalError,
    super.stackTrace,
    super.timestamp,
  });

  @override
  String get userMessage =>
      'Connection timed out. Please check your internet connection and try again.';

  @override
  bool get isRecoverable => true;
}

/// Exception for no internet connection
class NoInternetException extends NetworkException {
  NoInternetException({
    super.message = 'No internet connection available',
    super.code = 'NO_INTERNET',
    super.originalError,
    super.stackTrace,
    super.timestamp,
  });

  @override
  String get userMessage =>
      'No internet connection. Please check your network settings.';

  @override
  bool get isRecoverable => true;
}

/// Exception for server errors
class ServerException extends NetworkException {
  final int? statusCode;

  ServerException({
    super.message = 'Server error occurred',
    super.code = 'SERVER_ERROR',
    this.statusCode,
    super.originalError,
    super.stackTrace,
    super.timestamp,
  });

  @override
  String get userMessage => statusCode != null && statusCode! >= 500
      ? 'Server is temporarily unavailable. Please try again later.'
      : 'An error occurred while processing your request.';

  @override
  bool get isRecoverable => statusCode != null && statusCode! >= 500;

  @override
  ErrorSeverity get severity => statusCode != null && statusCode! >= 500
      ? ErrorSeverity.critical
      : ErrorSeverity.high;
}

// ============================================================================
// AUTHENTICATION EXCEPTIONS
// ============================================================================

/// Base class for authentication-related exceptions
abstract class AuthenticationException extends AppException {
  AuthenticationException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
    super.timestamp,
  });

  @override
  ErrorSeverity get severity => ErrorSeverity.high;
}

/// Exception for invalid credentials
class InvalidCredentialsException extends AuthenticationException {
  InvalidCredentialsException({
    super.message = 'Invalid credentials provided',
    super.code = 'INVALID_CREDENTIALS',
    super.originalError,
    super.stackTrace,
    super.timestamp,
  });

  @override
  String get userMessage => 'Invalid email or password. Please try again.';

  @override
  bool get isRecoverable => true;
}

/// Exception for expired session
class SessionExpiredException extends AuthenticationException {
  SessionExpiredException({
    super.message = 'User session has expired',
    super.code = 'SESSION_EXPIRED',
    super.originalError,
    super.stackTrace,
    super.timestamp,
  });

  @override
  String get userMessage => 'Your session has expired. Please log in again.';

  @override
  bool get isRecoverable => true;
}

/// Exception for insufficient permissions
class InsufficientPermissionsException extends AuthenticationException {
  InsufficientPermissionsException({
    super.message = 'Insufficient permissions to perform this action',
    super.code = 'INSUFFICIENT_PERMISSIONS',
    super.originalError,
    super.stackTrace,
    super.timestamp,
  });

  @override
  String get userMessage =>
      'You don\'t have permission to perform this action.';

  @override
  bool get isRecoverable => false;
}

// ============================================================================
// DATA EXCEPTIONS
// ============================================================================

/// Base class for data-related exceptions
abstract class DataException extends AppException {
  DataException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
    super.timestamp,
  });

  @override
  ErrorSeverity get severity => ErrorSeverity.medium;
}

/// Exception for data not found
class DataNotFoundException extends DataException {
  final String? resourceType;
  final String? resourceId;

  DataNotFoundException({
    super.message = 'Requested data not found',
    super.code = 'DATA_NOT_FOUND',
    this.resourceType,
    this.resourceId,
    super.originalError,
    super.stackTrace,
    super.timestamp,
  });

  @override
  String get userMessage => resourceType != null
      ? '$resourceType not found.'
      : 'The requested item could not be found.';

  @override
  bool get isRecoverable => false;
}

/// Exception for data validation errors
class DataValidationException extends DataException {
  final Map<String, String>? fieldErrors;

  DataValidationException({
    super.message = 'Data validation failed',
    super.code = 'DATA_VALIDATION_ERROR',
    this.fieldErrors,
    super.originalError,
    super.stackTrace,
    super.timestamp,
  });

  @override
  String get userMessage => fieldErrors?.isNotEmpty == true
      ? 'Please correct the following errors: ${fieldErrors!.values.join(', ')}'
      : 'Please check your input and try again.';

  @override
  bool get isRecoverable => true;

  @override
  ErrorSeverity get severity => ErrorSeverity.low;
}

/// Exception for data corruption
class DataCorruptionException extends DataException {
  DataCorruptionException({
    super.message = 'Data corruption detected',
    super.code = 'DATA_CORRUPTION',
    super.originalError,
    super.stackTrace,
    super.timestamp,
  });

  @override
  String get userMessage => 'Data corruption detected. Please contact support.';

  @override
  bool get isRecoverable => false;

  @override
  ErrorSeverity get severity => ErrorSeverity.critical;
}

// ============================================================================
// FILE OPERATION EXCEPTIONS
// ============================================================================

/// Base class for file operation exceptions
abstract class FileOperationException extends AppException {
  final String? filePath;
  final String? fileName;

  FileOperationException({
    required super.message,
    super.code,
    this.filePath,
    this.fileName,
    super.originalError,
    super.stackTrace,
    super.timestamp,
  });

  @override
  ErrorSeverity get severity => ErrorSeverity.medium;
}

/// Exception for file not found
class FileNotFoundException extends FileOperationException {
  FileNotFoundException({
    super.message = 'File not found',
    super.code = 'FILE_NOT_FOUND',
    super.filePath,
    super.fileName,
    super.originalError,
    super.stackTrace,
    super.timestamp,
  });

  @override
  String get userMessage => fileName != null
      ? 'File "$fileName" not found.'
      : 'The requested file could not be found.';

  @override
  bool get isRecoverable => false;
}

/// Exception for insufficient storage space
class InsufficientStorageException extends FileOperationException {
  InsufficientStorageException({
    super.message = 'Insufficient storage space',
    super.code = 'INSUFFICIENT_STORAGE',
    super.filePath,
    super.fileName,
    super.originalError,
    super.stackTrace,
    super.timestamp,
  });

  @override
  String get userMessage =>
      'Not enough storage space available. Please free up some space and try again.';

  @override
  bool get isRecoverable => true;
}

/// Exception for file access denied
class FileAccessDeniedException extends FileOperationException {
  FileAccessDeniedException({
    super.message = 'File access denied',
    super.code = 'FILE_ACCESS_DENIED',
    super.filePath,
    super.fileName,
    super.originalError,
    super.stackTrace,
    super.timestamp,
  });

  @override
  String get userMessage =>
      'Access to the file is denied. Please check permissions.';

  @override
  bool get isRecoverable => false;
}
