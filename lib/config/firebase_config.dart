/// Firebase configuration settings for the application
class FirebaseConfig {
  // Auto-refresh settings
  static const bool enableAutoRefresh =
      true; // Set to false to disable auto-refresh
  static const Duration autoRefreshInterval = Duration(
    minutes: 5,
  ); // Reduced from 30 seconds

  // Firebase listener settings
  static const Duration firebaseListenerDebounce = Duration(
    seconds: 2,
  ); // Increased from 500ms

  // Sync settings - ENHANCED: Enable optimized sync for better file management
  static const bool enableRealtimeSync =
      true; // ENABLED: Optimized real-time sync with proper debouncing
  static const bool enableStorageSync =
      true; // ENABLED: Optimized storage sync for file display functionality

  // Logging settings
  static const bool enableVerboseLogging =
      false; // Set to true for detailed logs
  static const bool logOnlySignificantChanges =
      true; // Only log when there are actual changes

  // UI refresh settings
  static const bool enableMultipleRefreshTimers =
      false; // Disabled to reduce Firebase calls
  static const Duration uiRefreshDelay = Duration(milliseconds: 500);

  // App Check settings - CRITICAL FIX: Always enable to prevent placeholder tokens
  static const bool enableAppCheckInDebug =
      true; // FIXED: Enable App Check in debug mode to prevent warnings
  static const bool enableAppCheckInProduction =
      true; // Enable App Check in production mode
  static const Duration appCheckTokenRefreshCooldown = Duration(minutes: 1);

  // Performance settings
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 1);

  // Smart loading settings
  static const bool enableProgressiveLoading = true; // Load data in chunks
  static const bool enableSmartCaching = true; // Use intelligent caching
  static const bool enablePriorityLoading = true; // Load critical data first

  // UI optimization settings - ENHANCED for unlimited queries
  static const bool enableLazyLoading = true; // Load content as needed
  static const bool enablePreloading = true; // Preload next batch
  static const int initialLoadSize = 50; // Increased initial load size
  static const int batchSize =
      25; // Increased batch size for better performance
  static const int unlimitedQueryBatchSize = 100; // For unlimited queries
  static const bool enableUnlimitedQueries =
      true; // Enable unlimited database queries

  /// Check if auto-refresh should be enabled
  static bool get shouldAutoRefresh => enableAutoRefresh;

  /// Check if real-time sync should be enabled
  static bool get shouldEnableRealtimeSync => enableRealtimeSync;

  /// Check if storage sync should be enabled
  static bool get shouldEnableStorageSync => enableStorageSync;

  /// Check if verbose logging should be enabled
  static bool get shouldLogVerbose => enableVerboseLogging;

  /// Check if only significant changes should be logged
  static bool get shouldLogOnlySignificantChanges => logOnlySignificantChanges;

  /// Check if unlimited queries should be enabled
  static bool get shouldEnableUnlimitedQueries => enableUnlimitedQueries;

  /// Get unlimited query batch size
  static int get getUnlimitedQueryBatchSize => unlimitedQueryBatchSize;

  /// Check if progressive loading should be enabled
  static bool get shouldEnableProgressiveLoading => enableProgressiveLoading;

  /// Check if smart caching should be enabled
  static bool get shouldEnableSmartCaching => enableSmartCaching;
}
