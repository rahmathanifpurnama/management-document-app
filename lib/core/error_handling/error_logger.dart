import 'package:flutter/foundation.dart';
import '../exceptions/custom_exceptions.dart';
import 'error_handler.dart';

/// Error logging service following OOP principles
class ErrorLogger {
  static final ErrorLogger _instance = ErrorLogger._internal();
  factory ErrorLogger() => _instance;
  ErrorLogger._internal();

  static ErrorLogger get instance => _instance;

  final List<ErrorLogEntry> _errorLog = [];
  final int _maxLogEntries = 1000;

  /// Log an error with additional context
  Future<void> logError(
    AppException exception, {
    Map<String, dynamic>? additionalData,
  }) async {
    final entry = ErrorLogEntry(
      exception: exception,
      additionalData: additionalData,
    );

    _errorLog.add(entry);

    // Maintain log size limit
    if (_errorLog.length > _maxLogEntries) {
      _errorLog.removeAt(0);
    }

    // Log to console in debug mode
    if (kDebugMode) {
      debugPrint('ERROR: ${exception.code} - ${exception.message}');
      if (exception.stackTrace != null) {
        debugPrint('Stack trace: ${exception.stackTrace}');
      }
    }

    // Send to external logging service in production
    if (kReleaseMode) {
      await _sendToExternalLogger(entry);
    }
  }

  /// Log a recovery attempt
  Future<void> logRecoveryAttempt(
    AppException exception,
    ErrorHandlingResult result,
  ) async {
    if (kDebugMode) {
      debugPrint('RECOVERY: ${exception.code} - ${result.type.name}: ${result.message}');
    }
  }

  /// Get recent error logs
  List<ErrorLogEntry> getRecentErrors({int limit = 50}) {
    final startIndex = _errorLog.length > limit ? _errorLog.length - limit : 0;
    return _errorLog.sublist(startIndex);
  }

  /// Clear error log
  void clearLog() {
    _errorLog.clear();
  }

  /// Send error to external logging service
  Future<void> _sendToExternalLogger(ErrorLogEntry entry) async {
    try {
      // Implementation would send to external service like Firebase Crashlytics
      // For now, just simulate the call
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      debugPrint('Failed to send error to external logger: $e');
    }
  }
}

/// Error log entry
class ErrorLogEntry {
  final AppException exception;
  final DateTime timestamp;
  final Map<String, dynamic>? additionalData;

  ErrorLogEntry({
    required this.exception,
    this.additionalData,
  }) : timestamp = DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'code': exception.code,
      'message': exception.message,
      'severity': exception.severity.name,
      'isRecoverable': exception.isRecoverable,
      'technicalDetails': exception.technicalDetails,
      'additionalData': additionalData,
    };
  }
}
