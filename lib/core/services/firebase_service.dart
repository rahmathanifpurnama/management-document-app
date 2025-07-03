import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../config/firebase_config.dart';
import 'network_service.dart';
import '../utils/app_check_status.dart';

/// Firebase initialization states
enum FirebaseInitializationState {
  notInitialized,
  initializing,
  initialized,
  failed,
  offline,
}

/// Firebase service availability status
class FirebaseServiceStatus {
  final bool isFirebaseInitialized;
  final bool isFirestoreAvailable;
  final bool isAuthAvailable;
  final bool isStorageAvailable;
  final bool isFunctionsAvailable;
  final String? errorMessage;
  final FirebaseInitializationState state;

  const FirebaseServiceStatus({
    required this.isFirebaseInitialized,
    required this.isFirestoreAvailable,
    required this.isAuthAvailable,
    required this.isStorageAvailable,
    required this.isFunctionsAvailable,
    required this.state,
    this.errorMessage,
  });

  bool get isFullyAvailable =>
      isFirebaseInitialized &&
      isFirestoreAvailable &&
      isAuthAvailable &&
      isStorageAvailable;

  bool get isPartiallyAvailable =>
      isFirebaseInitialized &&
      (isFirestoreAvailable || isAuthAvailable || isStorageAvailable);

  bool get canWorkOffline => isFirebaseInitialized && isFirestoreAvailable;
}

class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();

  FirebaseService._();

  // State management
  FirebaseInitializationState _state =
      FirebaseInitializationState.notInitialized;
  String? _lastError;
  bool _isFirebaseInitialized = false;
  bool _isFirestoreAvailable = false;
  bool _isAuthAvailable = false;
  bool _isStorageAvailable = false;
  bool _isFunctionsAvailable = false;

  // Getters for state
  FirebaseInitializationState get state => _state;
  String? get lastError => _lastError;

  /// Get current Firebase service status
  FirebaseServiceStatus get status => FirebaseServiceStatus(
    isFirebaseInitialized: _isFirebaseInitialized,
    isFirestoreAvailable: _isFirestoreAvailable,
    isAuthAvailable: _isAuthAvailable,
    isStorageAvailable: _isStorageAvailable,
    isFunctionsAvailable: _isFunctionsAvailable,
    state: _state,
    errorMessage: _lastError,
  );

  // Firebase instances with safety checks
  FirebaseAuth get auth {
    if (!_isAuthAvailable) {
      throw Exception('Firebase Auth is not available. Current state: $_state');
    }
    return FirebaseAuth.instance;
  }

  FirebaseFirestore get firestore {
    if (!_isFirestoreAvailable) {
      throw Exception('Firestore is not available. Current state: $_state');
    }
    return FirebaseFirestore.instance;
  }

  FirebaseStorage get storage {
    if (!_isStorageAvailable) {
      throw Exception(
        'Firebase Storage is not available. Current state: $_state',
      );
    }
    return FirebaseStorage.instance;
  }

  FirebaseFunctions get functions {
    if (!_isFunctionsAvailable) {
      throw Exception(
        'Firebase Functions is not available. Current state: $_state',
      );
    }
    return FirebaseFunctions.instance;
  }

  // Safe getters that return null instead of throwing
  FirebaseAuth? get authSafe => _isAuthAvailable ? FirebaseAuth.instance : null;
  FirebaseFirestore? get firestoreSafe =>
      _isFirestoreAvailable ? FirebaseFirestore.instance : null;
  FirebaseStorage? get storageSafe =>
      _isStorageAvailable ? FirebaseStorage.instance : null;
  FirebaseFunctions? get functionsSafe =>
      _isFunctionsAvailable ? FirebaseFunctions.instance : null;

  // Initialize Firebase with robust error handling
  static Future<void> initialize() async {
    final service = FirebaseService.instance;

    if (service._state == FirebaseInitializationState.initializing) {
      debugPrint('🔄 Firebase initialization already in progress');
      return;
    }

    if (service._state == FirebaseInitializationState.initialized) {
      debugPrint('✅ Firebase already initialized');
      return;
    }

    service._state = FirebaseInitializationState.initializing;
    service._lastError = null;

    debugPrint('🚀 Starting Firebase initialization...');

    try {
      // Step 1: Check network connectivity
      final networkService = NetworkService.instance;
      final diagnostics = await networkService.runDiagnostics();

      if (!diagnostics.hasInternet) {
        debugPrint('⚠️ No internet connection detected');
        service._state = FirebaseInitializationState.offline;

        // Try to initialize Firebase in offline mode
        await _initializeOfflineMode(service);
        return;
      }

      // Step 2: Initialize Firebase Core
      await _initializeFirebaseCore(service);

      // Step 3: Initialize individual services
      await _initializeFirebaseServices(service);

      // Step 4: Mark as fully initialized
      service._state = FirebaseInitializationState.initialized;
      debugPrint('✅ Firebase initialization completed successfully');
    } catch (e) {
      service._state = FirebaseInitializationState.failed;
      service._lastError = e.toString();
      debugPrint('❌ Firebase initialization failed: $e');

      // Try partial initialization for offline functionality
      await _attemptPartialInitialization(service);

      // Don't rethrow - allow app to continue with limited functionality
    }
  }

  /// Initialize Firebase in offline mode
  static Future<void> _initializeOfflineMode(FirebaseService service) async {
    try {
      debugPrint('🔄 Attempting offline Firebase initialization...');

      // Try to initialize Firebase core even without internet
      await Firebase.initializeApp();
      service._isFirebaseInitialized = true;

      // Try to configure Firestore for offline use
      await _configureFirestoreOffline();
      service._isFirestoreAvailable = true;

      // Auth might work offline with cached credentials
      service._isAuthAvailable = true;

      debugPrint('✅ Firebase initialized in offline mode');
    } catch (e) {
      debugPrint('❌ Offline Firebase initialization failed: $e');
      service._lastError = 'Offline initialization failed: $e';
    }
  }

  /// Initialize Firebase Core
  static Future<void> _initializeFirebaseCore(FirebaseService service) async {
    try {
      debugPrint('🔄 Initializing Firebase Core...');
      await Firebase.initializeApp();
      service._isFirebaseInitialized = true;
      debugPrint('✅ Firebase Core initialized');
    } catch (e) {
      debugPrint('❌ Firebase Core initialization failed: $e');
      throw Exception('Firebase Core initialization failed: $e');
    }
  }

  /// Initialize individual Firebase services
  static Future<void> _initializeFirebaseServices(
    FirebaseService service,
  ) async {
    // Initialize Auth
    await _initializeAuth(service);

    // Initialize Firestore
    await _initializeFirestore(service);

    // Initialize Storage
    await _initializeStorage(service);

    // Initialize Functions
    await _initializeFunctions(service);

    // Initialize App Check (optional)
    await _initializeAppCheck(service);
  }

  /// Attempt partial initialization for offline functionality
  static Future<void> _attemptPartialInitialization(
    FirebaseService service,
  ) async {
    debugPrint('🔄 Attempting partial Firebase initialization...');

    // Try to initialize at least Firestore for offline functionality
    await _initializeFirestore(service);

    // Try Auth for cached credentials
    await _initializeAuth(service);

    if (service._isFirestoreAvailable || service._isAuthAvailable) {
      debugPrint('✅ Partial Firebase initialization successful');
    } else {
      debugPrint('❌ Partial Firebase initialization failed');
    }
  }

  /// Initialize Firebase Auth
  static Future<void> _initializeAuth(FirebaseService service) async {
    try {
      debugPrint('🔄 Initializing Firebase Auth...');
      // Test Auth availability
      final _ = FirebaseAuth.instance;
      service._isAuthAvailable = true;
      debugPrint('✅ Firebase Auth initialized');
    } catch (e) {
      debugPrint('❌ Firebase Auth initialization failed: $e');
      service._isAuthAvailable = false;
    }
  }

  /// Initialize Firestore
  static Future<void> _initializeFirestore(FirebaseService service) async {
    try {
      debugPrint('🔄 Initializing Firestore...');

      // Configure Firestore settings
      await _configureFirestore();

      // Test Firestore availability with a simple operation
      await FirebaseFirestore.instance
          .collection('_test')
          .limit(1)
          .get()
          .timeout(const Duration(seconds: 5));

      service._isFirestoreAvailable = true;
      debugPrint('✅ Firestore initialized');
    } catch (e) {
      debugPrint('❌ Firestore initialization failed: $e');

      // Try offline configuration
      try {
        await _configureFirestoreOffline();
        service._isFirestoreAvailable = true;
        debugPrint('✅ Firestore initialized in offline mode');
      } catch (offlineError) {
        debugPrint('❌ Firestore offline initialization failed: $offlineError');
        service._isFirestoreAvailable = false;
      }
    }
  }

  /// Initialize Firebase Storage
  static Future<void> _initializeStorage(FirebaseService service) async {
    try {
      debugPrint('🔄 Initializing Firebase Storage...');

      // Test Storage availability
      final _ = FirebaseStorage.instance;
      service._isStorageAvailable = true;
      debugPrint('✅ Firebase Storage initialized');
    } catch (e) {
      debugPrint('❌ Firebase Storage initialization failed: $e');
      service._isStorageAvailable = false;
    }
  }

  /// Initialize Firebase Functions
  static Future<void> _initializeFunctions(FirebaseService service) async {
    try {
      debugPrint('🔄 Initializing Firebase Functions...');

      // Test Functions availability with health check
      final functions = FirebaseFunctions.instance;
      final healthCheck = functions.httpsCallable('healthCheck');

      await healthCheck.call().timeout(const Duration(seconds: 5));
      service._isFunctionsAvailable = true;
      debugPrint('✅ Firebase Functions initialized');
    } catch (e) {
      debugPrint('❌ Firebase Functions initialization failed: $e');
      service._isFunctionsAvailable = false;
    }
  }

  /// Configure Firestore for offline use
  static Future<void> _configureFirestoreOffline() async {
    try {
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: 50 * 1024 * 1024, // 50MB cache
      );
      debugPrint('✅ Firestore configured for offline use');
    } catch (e) {
      debugPrint('❌ Firestore offline configuration failed: $e');
      rethrow;
    }
  }

  // Configure Firestore settings
  static Future<void> _configureFirestore() async {
    try {
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: 50 * 1024 * 1024, // 50MB instead of unlimited
      );
    } catch (e) {
      debugPrint('Firestore configuration error: $e');
    }
  }

  /// Initialize App Check (optional)
  static Future<void> _initializeAppCheck(FirebaseService service) async {
    try {
      // Check if App Check should be enabled based on configuration
      final shouldEnableInDebug = FirebaseConfig.enableAppCheckInDebug;
      final shouldEnableInProduction =
          FirebaseConfig.enableAppCheckInProduction;

      if (kDebugMode && !shouldEnableInDebug) {
        debugPrint(
          '🔧 Skipping App Check initialization in debug mode (disabled in config)',
        );
        debugPrint('✅ This prevents "Too many attempts" errors');
        debugPrint('📝 To enable App Check in debug mode:');
        debugPrint('   1. Add debug token to Firebase Console');
        debugPrint(
          '   2. Set enableAppCheckInDebug = true in firebase_config.dart',
        );
        return;
      }

      // Enhanced network security configuration check
      if (FirebaseConfig.useEnhancedNetworkSecurity) {
        debugPrint('🔒 Using enhanced network security configuration');
        debugPrint(
          '📱 Android network security config optimized for App Check',
        );
        if (kDebugMode && FirebaseConfig.allowUserCertificates) {
          debugPrint(
            '🔧 Debug mode: User certificates allowed for development',
          );
        }
      }

      if (!kDebugMode && !shouldEnableInProduction) {
        debugPrint(
          '🔧 Skipping App Check initialization in production mode (disabled in config)',
        );
        return;
      }

      debugPrint('🔧 Initializing Firebase App Check...');

      // Initialize App Check based on build mode
      if (kDebugMode) {
        // For debug mode, use debug providers with specific debug token
        await Future.any([
          FirebaseAppCheck.instance.activate(
            androidProvider: AndroidProvider.debug,
            appleProvider: AppleProvider.debug,
          ),
          Future.delayed(
            const Duration(seconds: 10),
          ), // Timeout after 10 seconds
        ]);

        // Configure auto-refresh based on configuration
        try {
          await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(false);
          debugPrint(
            '✅ App Check initialized for debug mode with auto-refresh disabled',
          );
          debugPrint(
            '🔧 Auto-refresh disabled to prevent "Too many attempts" errors',
          );
        } catch (e) {
          debugPrint('⚠️ Failed to configure auto-refresh: $e');
        }

        // Try to get a token to verify it's working (with timeout)
        try {
          final token = await Future.any([
            FirebaseAppCheck.instance.getToken(),
            Future.delayed(
              const Duration(seconds: 10),
              () => null,
            ), // Increased timeout
          ]);
          if (token != null) {
            debugPrint('✅ App Check token obtained successfully');
            debugPrint('🔒 Token length: ${token.length} characters');
          } else {
            debugPrint(
              '⚠️ App Check token timeout or null, continuing without token',
            );
            debugPrint(
              '🔧 Check network connectivity and Android security config',
            );
          }
        } catch (tokenError) {
          debugPrint('⚠️ Failed to get App Check token: $tokenError');

          // Enhanced error diagnostics
          if (tokenError.toString().contains('network')) {
            debugPrint(
              '🌐 Network error detected - check network security config',
            );
            debugPrint(
              '📱 Verify Android network_security_config.xml includes Firebase domains',
            );
          } else if (tokenError.toString().contains('certificate')) {
            debugPrint('🔒 Certificate error detected - check trust anchors');
            debugPrint('📱 Verify user certificates are allowed in debug mode');
          } else if (tokenError.toString().contains('timeout')) {
            debugPrint(
              '⏱️ Timeout error detected - check network connectivity',
            );
          }

          debugPrint(
            '🔧 Continuing without App Check token (check network security config)',
          );
        }
      } else {
        // For production, use proper providers
        await Future.any([
          FirebaseAppCheck.instance.activate(
            androidProvider: AndroidProvider.playIntegrity,
            appleProvider: AppleProvider.deviceCheck,
          ),
          Future.delayed(
            const Duration(seconds: 10),
          ), // Timeout after 10 seconds
        ]);
        debugPrint('✅ App Check initialized for production mode');
      }

      // Set up token refresh listener with enhanced rate limiting
      _setupAppCheckTokenListener();

      // Print App Check status for debugging
      if (kDebugMode) {
        AppCheckStatus.instance.printStatus();
      }
    } catch (e) {
      debugPrint('⚠️ App Check initialization failed: $e');

      // Provide specific guidance based on error type
      if (e.toString().contains('Too many attempts')) {
        debugPrint('🚨 "Too many attempts" error detected');
        debugPrint('✅ Solution: App Check is now disabled in debug mode');
        debugPrint('🔧 This error should not occur with current configuration');
      } else if (e.toString().contains('network')) {
        debugPrint('📝 Network connectivity issue detected');
        debugPrint('🔧 Check your internet connection and try again');
      } else {
        debugPrint('📝 General App Check initialization failure');
        debugPrint('🔧 Continuing without App Check (app will still function)');
      }

      // Continue without App Check - app will still work
      if (kDebugMode) {
        debugPrint('✅ Debug mode: App will continue without App Check');
      }
    }
  }

  // Enhanced token refresh listener with aggressive rate limiting
  static DateTime? _lastTokenRefresh;
  static int _tokenRefreshAttempts = 0;
  static const int _maxTokenRefreshAttempts = 3;

  static void _setupAppCheckTokenListener() {
    FirebaseAppCheck.instance.onTokenChange.listen((token) {
      final now = DateTime.now();

      // Enhanced rate limiting to prevent "too many attempts" error
      if (_lastTokenRefresh != null &&
          now.difference(_lastTokenRefresh!) <
              FirebaseConfig.appCheckTokenRefreshCooldown) {
        debugPrint('🔄 App Check token refresh skipped (rate limited)');
        return;
      }

      // Limit total refresh attempts
      if (_tokenRefreshAttempts >= _maxTokenRefreshAttempts) {
        debugPrint(
          '🚨 App Check token refresh limit reached, stopping auto-refresh',
        );
        return;
      }

      _lastTokenRefresh = now;
      _tokenRefreshAttempts++;
      debugPrint(
        '🔄 App Check token refreshed (attempt $_tokenRefreshAttempts/$_maxTokenRefreshAttempts)',
      );

      // Reset attempts counter after successful refresh
      if (token != null) {
        _tokenRefreshAttempts = 0;
      }
    });
  }

  // Collections references
  CollectionReference get usersCollection => firestore.collection('users');

  CollectionReference get documentsCollection =>
      firestore.collection('documents');
  CollectionReference get activitiesCollection =>
      firestore.collection('activities');
  CollectionReference get categoriesCollection =>
      firestore.collection('categories');

  // Storage references
  Reference get documentsStorage => storage.ref().child('documents');
  Reference get profileImagesStorage => storage.ref().child('profile_images');

  // Batch operations
  WriteBatch get batch => firestore.batch();

  // Transaction
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction transaction) updateFunction,
  ) {
    return firestore.runTransaction(updateFunction);
  }

  // Get server timestamp
  FieldValue get serverTimestamp => FieldValue.serverTimestamp();

  // Check connection status
  Future<bool> checkConnection() async {
    try {
      await firestore.doc('test/connection').get();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Enable/disable network
  Future<void> enableNetwork() async {
    await firestore.enableNetwork();
  }

  Future<void> disableNetwork() async {
    await firestore.disableNetwork();
  }

  // Clear persistence
  Future<void> clearPersistence() async {
    await firestore.clearPersistence();
  }

  // Terminate Firestore
  Future<void> terminate() async {
    await firestore.terminate();
  }

  /// Attempt to recover Firebase services
  Future<void> attemptRecovery() async {
    debugPrint('🔄 Attempting Firebase service recovery...');

    if (_state == FirebaseInitializationState.failed ||
        _state == FirebaseInitializationState.offline) {
      // Reset state
      _state = FirebaseInitializationState.notInitialized;
      _lastError = null;

      // Try to reinitialize
      await initialize();
    }
  }

  /// Check if a specific service is available
  bool isServiceAvailable(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case 'auth':
        return _isAuthAvailable;
      case 'firestore':
        return _isFirestoreAvailable;
      case 'storage':
        return _isStorageAvailable;
      case 'functions':
        return _isFunctionsAvailable;
      default:
        return false;
    }
  }

  /// Get a human-readable status message
  String getStatusMessage() {
    switch (_state) {
      case FirebaseInitializationState.notInitialized:
        return 'Firebase not initialized';
      case FirebaseInitializationState.initializing:
        return 'Initializing Firebase services...';
      case FirebaseInitializationState.initialized:
        return 'All Firebase services available';
      case FirebaseInitializationState.failed:
        return 'Firebase initialization failed: ${_lastError ?? 'Unknown error'}';
      case FirebaseInitializationState.offline:
        return 'Running in offline mode';
    }
  }

  /// Execute operation with Firebase availability check
  Future<T?> executeWithAvailabilityCheck<T>(
    String serviceName,
    Future<T> Function() operation, {
    T? fallbackValue,
  }) async {
    if (!isServiceAvailable(serviceName)) {
      debugPrint('⚠️ Service $serviceName not available, using fallback');
      return fallbackValue;
    }

    try {
      return await operation();
    } catch (e) {
      debugPrint('❌ Operation failed for $serviceName: $e');
      return fallbackValue;
    }
  }
}
