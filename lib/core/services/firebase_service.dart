import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import '../../config/firebase_config.dart';
import '../../services/cloud_functions_service.dart';
import 'network_service.dart';
import '../utils/app_check_status.dart';

class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();

  FirebaseService._();

  // Firebase instances
  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;

  // Initialize Firebase
  static Future<void> initialize() async {
    try {
      // Check network connectivity first
      final networkService = NetworkService.instance;
      final diagnostics = await networkService.runDiagnostics();

      if (!diagnostics.hasInternet) {
        debugPrint('⚠️ No internet connection detected');
        final suggestions = networkService.getTroubleshootingSuggestions(
          diagnostics,
        );
        for (final suggestion in suggestions) {
          debugPrint('💡 $suggestion');
        }
        // Continue initialization but with warnings
      }

      await Firebase.initializeApp();

      // Initialize App Check only if enabled in configuration
      if (FirebaseConfig.enableAppCheckInDebug ||
          FirebaseConfig.enableAppCheckInProduction) {
        await _initializeAppCheck();
      } else {
        debugPrint(
          '🔧 App Check disabled in configuration - skipping initialization',
        );
      }

      // Enable offline persistence for Firestore with timeout
      await Future.any([
        _configureFirestore(),
        Future.delayed(const Duration(seconds: 5)), // Timeout after 5 seconds
      ]);

      // Initialize Cloud Functions service
      CloudFunctionsService.instance.configureForDevelopment();
    } catch (e) {
      debugPrint('❌ Firebase initialization error: $e');
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

  // Initialize App Check to prevent warnings and improve security
  static Future<void> _initializeAppCheck() async {
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
      firestore.collection('document-metadata');
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
}
