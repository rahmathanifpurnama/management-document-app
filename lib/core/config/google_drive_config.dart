import 'package:flutter/foundation.dart';

/// Configuration for Google Drive integration
class GoogleDriveConfig {
  // Google Drive API scopes
  static const List<String> requiredScopes = [
    'https://www.googleapis.com/auth/drive.file',
  ];

  // File upload settings
  static const int maxFileSize = 100 * 1024 * 1024; // 100MB
  static const int chunkSize = 1024 * 1024; // 1MB chunks for large files
  static const Duration uploadTimeout = Duration(minutes: 10);
  static const Duration authTimeout = Duration(minutes: 2);

  // Retry settings
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // UI settings
  static const Duration progressUpdateInterval = Duration(milliseconds: 500);
  static const Duration snackbarDuration = Duration(seconds: 3);
  static const Duration uploadSnackbarDuration = Duration(minutes: 5);

  // File naming settings
  static const bool preserveOriginalNames = true;
  static const bool removeTimestampPrefixes = true;

  // Debug settings
  static const bool enableDebugLogging = kDebugMode;
  static const bool enablePerformanceLogging = kDebugMode;

  /// Check if file size is within limits
  static bool isFileSizeValid(int fileSize) {
    return fileSize > 0 && fileSize <= maxFileSize;
  }

  /// Get human readable file size limit
  static String get maxFileSizeFormatted {
    if (maxFileSize < 1024 * 1024) {
      return '${(maxFileSize / 1024).toStringAsFixed(1)} KB';
    } else if (maxFileSize < 1024 * 1024 * 1024) {
      return '${(maxFileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(maxFileSize / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Get timeout for file size
  static Duration getTimeoutForFileSize(int fileSize) {
    if (fileSize < 5 * 1024 * 1024) {
      // < 5MB
      return const Duration(minutes: 2);
    } else if (fileSize < 20 * 1024 * 1024) {
      // < 20MB
      return const Duration(minutes: 5);
    } else {
      // >= 20MB
      return uploadTimeout;
    }
  }

  /// Check if file should be uploaded in chunks
  static bool shouldUseChunkedUpload(int fileSize) {
    return fileSize > chunkSize;
  }

  /// Get number of chunks for file
  static int getChunkCount(int fileSize) {
    return (fileSize / chunkSize).ceil();
  }

  /// Validate Google Drive configuration
  static bool validateConfiguration() {
    try {
      // Check if required scopes are defined
      if (requiredScopes.isEmpty) {
        debugPrint('❌ Google Drive: No scopes defined');
        return false;
      }

      // Check if file size limits are reasonable
      if (maxFileSize <= 0) {
        debugPrint('❌ Google Drive: Invalid max file size');
        return false;
      }

      // Check if chunk size is reasonable
      if (chunkSize <= 0 || chunkSize > maxFileSize) {
        debugPrint('❌ Google Drive: Invalid chunk size');
        return false;
      }

      debugPrint('✅ Google Drive configuration validated');
      return true;
    } catch (e) {
      debugPrint('❌ Google Drive configuration validation failed: $e');
      return false;
    }
  }

  /// Get configuration summary for debugging
  static Map<String, dynamic> getConfigSummary() {
    return {
      'scopes': requiredScopes,
      'maxFileSize': maxFileSizeFormatted,
      'chunkSize': '${(chunkSize / 1024).toStringAsFixed(1)} KB',
      'uploadTimeout': '${uploadTimeout.inMinutes} minutes',
      'authTimeout': '${authTimeout.inMinutes} minutes',
      'maxRetryAttempts': maxRetryAttempts,
      'retryDelay': '${retryDelay.inSeconds} seconds',
      'preserveOriginalNames': preserveOriginalNames,
      'removeTimestampPrefixes': removeTimestampPrefixes,
      'debugLogging': enableDebugLogging,
      'performanceLogging': enablePerformanceLogging,
    };
  }

  /// Print configuration for debugging
  static void printConfiguration() {
    if (!enableDebugLogging) return;

    debugPrint('🔧 Google Drive Configuration:');
    final config = getConfigSummary();
    config.forEach((key, value) {
      debugPrint('   $key: $value');
    });
  }
}
