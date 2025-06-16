import 'package:flutter/foundation.dart';

/// Configuration for application logging levels
class LoggingConfig {
  // Global logging control
  static const bool enableDebugLogs = kDebugMode;
  
  // Service-specific logging controls
  static const bool enablePerformanceLogs = false; // Disabled to reduce noise
  static const bool enableCircuitBreakerLogs = false; // Disabled to reduce noise
  static const bool enableFirebaseListenerLogs = false; // Disabled to reduce noise
  static const bool enableANRDetectorLogs = false; // Disabled to reduce noise
  static const bool enableDocumentProviderLogs = true; // Keep essential logs
  static const bool enableStorageServiceLogs = true; // Keep essential logs
  static const bool enableUnifiedLoaderLogs = false; // Disabled to reduce noise
  static const bool enableHomeScreenLogs = false; // Disabled to reduce noise
  
  // Log level controls
  static const bool showSuccessLogs = false; // Disable success logs to reduce noise
  static const bool showInfoLogs = true; // Keep info logs
  static const bool showWarningLogs = true; // Keep warning logs
  static const bool showErrorLogs = true; // Always keep error logs
  
  // Specific operation logging
  static const bool logFileOperations = true; // Keep file operation logs
  static const bool logNetworkOperations = false; // Disable network logs
  static const bool logCacheOperations = false; // Disable cache logs
  static const bool logUIOperations = false; // Disable UI logs
  
  /// Check if a specific log type should be shown
  static bool shouldLog(LogType type) {
    if (!enableDebugLogs) return false;
    
    switch (type) {
      case LogType.success:
        return showSuccessLogs;
      case LogType.info:
        return showInfoLogs;
      case LogType.warning:
        return showWarningLogs;
      case LogType.error:
        return showErrorLogs;
      case LogType.performance:
        return enablePerformanceLogs;
      case LogType.circuitBreaker:
        return enableCircuitBreakerLogs;
      case LogType.firebaseListener:
        return enableFirebaseListenerLogs;
      case LogType.anrDetector:
        return enableANRDetectorLogs;
      case LogType.documentProvider:
        return enableDocumentProviderLogs;
      case LogType.storageService:
        return enableStorageServiceLogs;
      case LogType.unifiedLoader:
        return enableUnifiedLoaderLogs;
      case LogType.homeScreen:
        return enableHomeScreenLogs;
      case LogType.fileOperation:
        return logFileOperations;
      case LogType.networkOperation:
        return logNetworkOperations;
      case LogType.cacheOperation:
        return logCacheOperations;
      case LogType.uiOperation:
        return logUIOperations;
    }
  }
  
  /// Controlled debug print
  static void log(String message, LogType type) {
    if (shouldLog(type)) {
      debugPrint(message);
    }
  }
  
  /// Essential logs that should always be shown (errors, critical warnings)
  static void essentialLog(String message) {
    if (enableDebugLogs) {
      debugPrint(message);
    }
  }
  
  /// Error logs that should always be shown
  static void errorLog(String message) {
    debugPrint('❌ $message');
  }
  
  /// Warning logs
  static void warningLog(String message) {
    if (shouldLog(LogType.warning)) {
      debugPrint('⚠️ $message');
    }
  }
  
  /// Info logs
  static void infoLog(String message) {
    if (shouldLog(LogType.info)) {
      debugPrint('ℹ️ $message');
    }
  }
  
  /// Success logs
  static void successLog(String message) {
    if (shouldLog(LogType.success)) {
      debugPrint('✅ $message');
    }
  }
}

/// Enum for different log types
enum LogType {
  success,
  info,
  warning,
  error,
  performance,
  circuitBreaker,
  firebaseListener,
  anrDetector,
  documentProvider,
  storageService,
  unifiedLoader,
  homeScreen,
  fileOperation,
  networkOperation,
  cacheOperation,
  uiOperation,
}
