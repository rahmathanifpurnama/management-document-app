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

  // Sync settings - ENHANCED: Firebase Storage as primary source
  static const bool enableRealtimeSync =
      true; // ENABLED: Optimized real-time sync with proper debouncing
  static const bool enableStorageSync =
      true; // ENABLED: Firebase Storage as primary data source for consistency
  static const bool useStorageAsSourceOfTruth =
      true; // ENHANCED: Firebase Storage as single source of truth

  // Logging settings
  static const bool enableVerboseLogging =
      false; // Set to true for detailed logs
  static const bool logOnlySignificantChanges =
      true; // Only log when there are actual changes

  // UI refresh settings
  static const bool enableMultipleRefreshTimers =
      false; // Disabled to reduce Firebase calls
  static const Duration uiRefreshDelay = Duration(milliseconds: 500);

  // App Check settings - ENHANCED: Enable with proper network security configuration
  static const bool enableAppCheckInDebug =
      true; // ENHANCED: Enable App Check in debug mode with network security fixes
  static const bool enableAppCheckInProduction =
      true; // Enable App Check in production mode
  static const Duration appCheckTokenRefreshCooldown = Duration(minutes: 2);

  // Network security configuration settings
  static const bool useEnhancedNetworkSecurity =
      true; // Enable enhanced network security
  static const bool allowUserCertificates =
      true; // Allow user-added certificates in debug

  // Performance settings
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 1);

  // Smart loading settings
  static const bool enableProgressiveLoading = true; // Load data in chunks
  static const bool enableSmartCaching = true; // Use intelligent caching
  static const bool enablePriorityLoading = true; // Load critical data first

  // UI optimization settings - ENTERPRISE SCALE SUPPORT
  static const bool enableLazyLoading = true; // Load content as needed
  static const bool enablePreloading = true; // Preload next batch
  static const int initialLoadSize = 100; // Increased for enterprise use
  static const int batchSize = 50; // Increased batch size for enterprise
  static const int unlimitedQueryBatchSize = 1000; // For unlimited queries
  static const bool enableUnlimitedQueries =
      true; // Enable unlimited database queries
  static const bool enableEnterpriseMode =
      true; // Enable enterprise-scale features

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

  /// Get appropriate batch size based on enterprise mode
  static int get getEnterpriseBatchSize =>
      enableEnterpriseMode ? unlimitedQueryBatchSize : batchSize;

  /// Check if unlimited file display is enabled
  static bool get shouldEnableUnlimitedFiles =>
      enableEnterpriseMode && enableUnlimitedQueries;

  /// Check if progressive loading should be enabled
  static bool get shouldEnableProgressiveLoading => enableProgressiveLoading;

  /// Check if smart caching should be enabled
  static bool get shouldEnableSmartCaching => enableSmartCaching;
}
