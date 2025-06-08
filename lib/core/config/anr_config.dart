import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Configuration class for ANR (Application Not Responding) prevention
class ANRConfig {
  // Optimized timeout configurations to prevent ANR
  static const Duration defaultTimeout = Duration(
    seconds: 3,
  ); // Reduced from 5s
  static const Duration networkTimeout = Duration(
    seconds: 10,
  ); // Reduced from 15s
  static const Duration fileOperationTimeout = Duration(
    seconds: 8,
  ); // Reduced from 10s
  static const Duration databaseTimeout = Duration(
    seconds: 6,
  ); // Reduced from 8s
  static const Duration heavyOperationTimeout = Duration(
    seconds: 8,
  ); // Reduced from 12s

  // Firebase specific timeouts (optimized for better UX)
  static const Duration firebaseInitTimeout = Duration(
    seconds: 8,
  ); // Reduced from 10s
  static const Duration firestoreQueryTimeout = Duration(
    seconds: 8,
  ); // Reduced from 12s
  static const Duration storageUploadTimeout = Duration(
    minutes: 3,
  ); // Reduced from 5m
  static const Duration storageListTimeout = Duration(
    seconds: 15,
  ); // New: for listing operations
  static const Duration storageMetadataTimeout = Duration(
    seconds: 5,
  ); // New: for metadata operations
  static const Duration authTimeout = Duration(seconds: 6); // Reduced from 8s

  // File reading timeouts based on size
  static const Duration smallFileReadTimeout = Duration(seconds: 5); // < 5MB
  static const Duration largeFileReadTimeout = Duration(seconds: 15); // >= 5MB

  // Batch processing configurations
  static const int defaultBatchSize = 8; // Reduced from 10
  static const int largeBatchSize = 15; // For less critical operations
  static const Duration batchDelay = Duration(
    milliseconds: 50,
  ); // Reduced delay

  // ANR detection thresholds
  static const Duration anrWarningThreshold = Duration(seconds: 2);
  static const Duration anrCriticalThreshold = Duration(seconds: 4);
  static const Duration anrEmergencyThreshold = Duration(seconds: 6);

  // UI responsiveness settings
  static const Duration debounceDelay = Duration(milliseconds: 300);
  static const Duration throttleInterval = Duration(milliseconds: 500);
  static const Duration uiUpdateDelay = Duration(milliseconds: 100);

  // Additional settings
  static const int maxRetries = 3;

  // Performance monitoring thresholds
  static const Duration slowOperationThreshold = Duration(milliseconds: 500);
  static const Duration criticalOperationThreshold = Duration(seconds: 2);

  // Memory and resource limits
  static const int maxConcurrentOperations = 5;
  static const int maxCacheSize = 100;
  static const Duration cacheExpiry = Duration(hours: 1);

  // File size limits to prevent ANR
  static const int maxFileSize = 15 * 1024 * 1024; // 15MB
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxDocumentSize = 10 * 1024 * 1024; // 10MB

  // Network retry settings
  static const Duration retryDelay = Duration(seconds: 1);
  static const Duration maxRetryDelay = Duration(seconds: 10);
  static const double retryBackoffMultiplier = 1.5;

  /// Get timeout for specific operation type
  static Duration getTimeoutForOperation(OperationType type) {
    switch (type) {
      case OperationType.network:
        return networkTimeout;
      case OperationType.fileOperation:
        return fileOperationTimeout;
      case OperationType.database:
        return databaseTimeout;
      case OperationType.heavyComputation:
        return heavyOperationTimeout;
      case OperationType.firebaseInit:
        return firebaseInitTimeout;
      case OperationType.firestoreQuery:
        return firestoreQueryTimeout;
      case OperationType.storageUpload:
        return storageUploadTimeout;
      case OperationType.authentication:
        return authTimeout;
      default:
        return defaultTimeout;
    }
  }

  /// Check if operation should be executed based on app state
  static bool shouldExecuteOperation({
    required OperationType type,
    bool requiresForeground = false,
  }) {
    // Check if app is in foreground for operations that require it
    if (requiresForeground) {
      final lifecycleState = WidgetsBinding.instance.lifecycleState;
      if (lifecycleState != AppLifecycleState.resumed) {
        debugPrint('⏸️ Skipping operation (app not in foreground): $type');
        return false;
      }
    }

    return true;
  }

  /// Get batch size for specific operation
  static int getBatchSizeForOperation(OperationType type) {
    switch (type) {
      case OperationType.fileOperation:
        return 5; // Smaller batches for file operations
      case OperationType.database:
        return 20; // Larger batches for database operations
      case OperationType.network:
        return 8; // Medium batches for network operations
      default:
        return defaultBatchSize;
    }
  }

  /// Get retry count for specific operation
  static int getRetryCountForOperation(OperationType type) {
    switch (type) {
      case OperationType.network:
        return 5; // More retries for network operations
      case OperationType.authentication:
        return 2; // Fewer retries for auth operations
      case OperationType.fileOperation:
        return 3; // Standard retries for file operations
      default:
        return maxRetries;
    }
  }

  /// Check if file size is within limits
  static bool isFileSizeValid(int fileSize, FileType fileType) {
    switch (fileType) {
      case FileType.image:
        return fileSize <= maxImageSize;
      case FileType.document:
        return fileSize <= maxDocumentSize;
      case FileType.general:
        return fileSize <= maxFileSize;
    }
  }

  /// Get appropriate delay for retry attempt
  static Duration getRetryDelay(int attemptNumber) {
    final delay =
        retryDelay.inMilliseconds * (retryBackoffMultiplier * attemptNumber);
    return Duration(
      milliseconds: delay
          .clamp(
            retryDelay.inMilliseconds.toDouble(),
            maxRetryDelay.inMilliseconds.toDouble(),
          )
          .toInt(),
    );
  }

  /// Log performance metrics
  static void logPerformance({
    required String operationName,
    required Duration duration,
    required OperationType type,
    bool wasSuccessful = true,
  }) {
    final threshold = type == OperationType.heavyComputation
        ? criticalOperationThreshold
        : slowOperationThreshold;

    if (duration > threshold) {
      debugPrint(
        '⚠️ Slow operation: $operationName took ${duration.inMilliseconds}ms '
        '(threshold: ${threshold.inMilliseconds}ms)',
      );
    } else if (kDebugMode) {
      debugPrint(
        '✅ Operation completed: $operationName took ${duration.inMilliseconds}ms',
      );
    }

    // Log failure
    if (!wasSuccessful) {
      debugPrint(
        '❌ Operation failed: $operationName after ${duration.inMilliseconds}ms',
      );
    }
  }
}

/// Types of operations for timeout configuration
enum OperationType {
  network,
  fileOperation,
  database,
  heavyComputation,
  firebaseInit,
  firestoreQuery,
  storageUpload,
  authentication,
  uiUpdate,
  general,
}

/// File types for size validation
enum FileType { image, document, general }

/// ANR prevention recommendations
class ANRRecommendations {
  static const List<String> bestPractices = [
    '1. Always use timeouts for network operations',
    '2. Process large lists in batches with delays',
    '3. Use background isolates for heavy computations',
    '4. Implement proper error handling and fallbacks',
    '5. Monitor operation performance and optimize slow operations',
    '6. Use debouncing for user input operations',
    '7. Avoid blocking the main thread with synchronous operations',
    '8. Implement proper loading states for long operations',
    '9. Use lazy loading for large datasets',
    '10. Clean up resources and cancel operations when not needed',
  ];

  static void printRecommendations() {
    debugPrint('📋 ANR Prevention Best Practices:');
    for (final practice in bestPractices) {
      debugPrint('   $practice');
    }
  }
}
