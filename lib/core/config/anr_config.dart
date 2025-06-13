import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Configuration class for ANR (Application Not Responding) prevention
class ANRConfig {
  // Optimized timeout configurations to prevent ANR
  static const Duration defaultTimeout = Duration(
    seconds: 2,
  ); // Further reduced
  static const Duration networkTimeout = Duration(
    seconds: 8,
  ); // Further reduced
  static const Duration fileOperationTimeout = Duration(
    seconds: 6,
  ); // Further reduced
  static const Duration databaseTimeout = Duration(
    seconds: 4,
  ); // Further reduced
  static const Duration heavyOperationTimeout = Duration(
    seconds: 6,
  ); // Further reduced

  // Firebase specific timeouts (optimized for better UX)
  static const Duration firebaseInitTimeout = Duration(
    seconds: 6,
  ); // Further reduced
  static const Duration firestoreQueryTimeout = Duration(
    seconds: 5,
  ); // Further reduced
  static const Duration storageUploadTimeout = Duration(
    minutes: 2,
  ); // Further reduced
  static const Duration storageListTimeout = Duration(
    seconds: 10,
  ); // Further reduced
  static const Duration storageMetadataTimeout = Duration(
    seconds: 3,
  ); // Further reduced
  static const Duration authTimeout = Duration(seconds: 4); // Further reduced

  // File reading timeouts based on size
  static const Duration smallFileReadTimeout = Duration(seconds: 3); // < 5MB
  static const Duration largeFileReadTimeout = Duration(seconds: 8); // >= 5MB

  // Batch processing configurations - HIGH PRIORITY FIX
  static const int defaultBatchSize =
      5; // Significantly reduced for better performance
  static const int smallBatchSize = 3; // For critical operations
  static const int largeBatchSize = 10; // For less critical operations
  static const Duration batchDelay = Duration(
    milliseconds: 100,
  ); // Increased delay
  static const Duration yieldDelay = Duration(milliseconds: 16); // 60fps yield

  // ANR detection thresholds - More aggressive
  static const Duration anrWarningThreshold = Duration(milliseconds: 1500);
  static const Duration anrCriticalThreshold = Duration(seconds: 3);
  static const Duration anrEmergencyThreshold = Duration(seconds: 4);

  // UI responsiveness settings - HIGH PRIORITY FIX
  static const Duration debounceDelay = Duration(milliseconds: 200); // Reduced
  static const Duration throttleInterval = Duration(
    milliseconds: 300,
  ); // Reduced
  static const Duration uiUpdateDelay = Duration(milliseconds: 50); // Reduced

  // Additional settings
  static const int maxRetries = 2; // Reduced retries

  // Performance monitoring thresholds
  static const Duration slowOperationThreshold = Duration(milliseconds: 300);
  static const Duration criticalOperationThreshold = Duration(
    milliseconds: 1500,
  );

  // HIGH PRIORITY: Pagination settings - UNIFIED LIMITS
  static const int defaultPageSize = 50; // Increased to match listener limit
  static const int smallPageSize = 25; // Increased for better consistency
  static const int largePageSize = 100;
  static const int maxItemsPerPage = 50; // Unified with Firebase listener limit

  // HIGH PRIORITY: Concurrent operation limits
  static const int maxConcurrentFirebaseOps = 2; // Reduced from 3
  static const int maxConcurrentNetworkOps = 3;
  static const int maxConcurrentFileOps =
      1; // Only one file operation at a time

  // MEDIUM PRIORITY: Memory management
  static const int maxCacheSize = 50; // Reduced cache size
  static const Duration cacheExpiry = Duration(
    minutes: 30,
  ); // Reduced cache time
  static const int maxImageCacheSize = 20;
  static const int maxListViewCacheExtent = 100;

  // Memory and resource limits - Updated
  static const int maxConcurrentOperations = 3; // Reduced

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
