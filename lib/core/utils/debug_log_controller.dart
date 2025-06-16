import 'package:flutter/foundation.dart';

/// Global debug logging controller to manage debug output
/// Helps reduce excessive logging in production and development
class DebugLogController {
  static bool _enableDebugLogs = kDebugMode;
  static bool _enablePerformanceLogs = false;
  static bool _enableCircuitBreakerLogs = false;
  static bool _enableFirebaseListenerLogs = false;
  static bool _enableANRDetectorLogs = false;
  static bool _enableDocumentProviderLogs = true; // Keep essential logs
  static bool _enableStorageServiceLogs = true; // Keep essential logs

  /// Enable or disable all debug logs
  static void setGlobalDebugLogging(bool enabled) {
    _enableDebugLogs = enabled;
  }

  /// Enable or disable performance monitoring logs
  static void setPerformanceLogging(bool enabled) {
    _enablePerformanceLogs = enabled;
  }

  /// Enable or disable circuit breaker logs
  static void setCircuitBreakerLogging(bool enabled) {
    _enableCircuitBreakerLogs = enabled;
  }

  /// Enable or disable Firebase listener logs
  static void setFirebaseListenerLogging(bool enabled) {
    _enableFirebaseListenerLogs = enabled;
  }

  /// Enable or disable ANR detector logs
  static void setANRDetectorLogging(bool enabled) {
    _enableANRDetectorLogs = enabled;
  }

  /// Enable or disable document provider logs
  static void setDocumentProviderLogging(bool enabled) {
    _enableDocumentProviderLogs = enabled;
  }

  /// Enable or disable storage service logs
  static void setStorageServiceLogging(bool enabled) {
    _enableStorageServiceLogs = enabled;
  }

  /// Controlled debug print for performance monitoring
  static void performanceLog(String message) {
    if (_enableDebugLogs && _enablePerformanceLogs) {
      debugPrint(message);
    }
  }

  /// Controlled debug print for circuit breaker
  static void circuitBreakerLog(String message) {
    if (_enableDebugLogs && _enableCircuitBreakerLogs) {
      debugPrint(message);
    }
  }

  /// Controlled debug print for Firebase listeners
  static void firebaseListenerLog(String message) {
    if (_enableDebugLogs && _enableFirebaseListenerLogs) {
      debugPrint(message);
    }
  }

  /// Controlled debug print for ANR detector
  static void anrDetectorLog(String message) {
    if (_enableDebugLogs && _enableANRDetectorLogs) {
      debugPrint(message);
    }
  }

  /// Controlled debug print for document provider
  static void documentProviderLog(String message) {
    if (_enableDebugLogs && _enableDocumentProviderLogs) {
      debugPrint(message);
    }
  }

  /// Controlled debug print for storage service
  static void storageServiceLog(String message) {
    if (_enableDebugLogs && _enableStorageServiceLogs) {
      debugPrint(message);
    }
  }

  /// Essential logs that should always be shown (errors, warnings)
  static void essentialLog(String message) {
    if (_enableDebugLogs) {
      debugPrint(message);
    }
  }

  /// Get current logging configuration
  static Map<String, bool> getLoggingConfig() {
    return {
      'globalDebugLogs': _enableDebugLogs,
      'performanceLogs': _enablePerformanceLogs,
      'circuitBreakerLogs': _enableCircuitBreakerLogs,
      'firebaseListenerLogs': _enableFirebaseListenerLogs,
      'anrDetectorLogs': _enableANRDetectorLogs,
      'documentProviderLogs': _enableDocumentProviderLogs,
      'storageServiceLogs': _enableStorageServiceLogs,
    };
  }

  /// Set quiet mode (only essential logs)
  static void setQuietMode() {
    _enablePerformanceLogs = false;
    _enableCircuitBreakerLogs = false;
    _enableFirebaseListenerLogs = false;
    _enableANRDetectorLogs = false;
    _enableDocumentProviderLogs = false;
    _enableStorageServiceLogs = false;
    debugPrint('🔇 Debug logging set to quiet mode - only essential logs will be shown');
  }

  /// Set verbose mode (all logs)
  static void setVerboseMode() {
    _enablePerformanceLogs = true;
    _enableCircuitBreakerLogs = true;
    _enableFirebaseListenerLogs = true;
    _enableANRDetectorLogs = true;
    _enableDocumentProviderLogs = true;
    _enableStorageServiceLogs = true;
    debugPrint('🔊 Debug logging set to verbose mode - all logs will be shown');
  }

  /// Set production mode (minimal logging)
  static void setProductionMode() {
    _enableDebugLogs = false;
    _enablePerformanceLogs = false;
    _enableCircuitBreakerLogs = false;
    _enableFirebaseListenerLogs = false;
    _enableANRDetectorLogs = false;
    _enableDocumentProviderLogs = false;
    _enableStorageServiceLogs = false;
    debugPrint('🏭 Debug logging set to production mode - logging disabled');
  }
}
