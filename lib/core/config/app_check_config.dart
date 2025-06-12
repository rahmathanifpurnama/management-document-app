import 'package:flutter/foundation.dart';

/// Configuration for Firebase App Check
class AppCheckConfig {
  // Debug token for development - Replace with your actual debug token
  static const String debugToken = '0D5038C4-B4F2-4628-8AD4-D500B904BA04';
  
  // App Check settings
  static const bool enableAutoRefresh = true;
  static const Duration tokenRefreshInterval = Duration(minutes: 30);
  static const Duration tokenValidityDuration = Duration(hours: 1);
  
  // Timeout settings for App Check operations
  static const Duration initializationTimeout = Duration(seconds: 10);
  static const Duration tokenRetrievalTimeout = Duration(seconds: 5);
  
  /// Get the appropriate debug token based on environment
  static String? getDebugToken() {
    if (kDebugMode) {
      return debugToken;
    }
    return null; // No debug token in production
  }
  
  /// Check if App Check should be enabled
  static bool shouldEnableAppCheck() {
    return true; // Always enable App Check for security
  }
  
  /// Get initialization timeout
  static Duration getInitializationTimeout() {
    return initializationTimeout;
  }
  
  /// Get token retrieval timeout
  static Duration getTokenRetrievalTimeout() {
    return tokenRetrievalTimeout;
  }
  
  /// Check if auto-refresh should be enabled
  static bool shouldEnableAutoRefresh() {
    return enableAutoRefresh;
  }
  
  /// Get token refresh interval
  static Duration getTokenRefreshInterval() {
    return tokenRefreshInterval;
  }
  
  /// Debug information about current configuration
  static Map<String, dynamic> getDebugInfo() {
    return {
      'debugMode': kDebugMode,
      'debugToken': kDebugMode ? debugToken : 'Hidden (Production)',
      'autoRefreshEnabled': enableAutoRefresh,
      'refreshInterval': tokenRefreshInterval.inMinutes,
      'initTimeout': initializationTimeout.inSeconds,
      'tokenTimeout': tokenRetrievalTimeout.inSeconds,
    };
  }
}
