import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import '../../config/firebase_config.dart';
import '../../services/cloud_functions_service.dart';
import 'network_service.dart';

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

      // Initialize App Check to prevent warnings and improve security
      await _initializeAppCheck();

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
      // CRITICAL FIX: Always enable App Check to prevent placeholder token warnings
      debugPrint('🔧 Initializing Firebase App Check...');

      // Initialize App Check based on build mode
      if (kDebugMode) {
        // For debug mode, use debug providers with timeout
        await Future.any([
          FirebaseAppCheck.instance.activate(
            androidProvider: AndroidProvider.debug,
            appleProvider: AppleProvider.debug,
          ),
          Future.delayed(
            const Duration(seconds: 10),
          ), // Timeout after 10 seconds
        ]);
        debugPrint('✅ App Check initialized for debug mode');

        // Try to get a token to verify it's working
        try {
          final token = await FirebaseAppCheck.instance.getToken();
          if (token != null) {
            debugPrint('✅ App Check token obtained successfully');
          } else {
            debugPrint('⚠️ App Check token is null, using placeholder');
          }
        } catch (tokenError) {
          debugPrint('⚠️ Failed to get App Check token: $tokenError');
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

      // Set up token refresh listener with rate limiting
      _setupAppCheckTokenListener();
    } catch (e) {
      debugPrint('⚠️ App Check initialization failed: $e');
      // Continue without App Check but log the issue
      debugPrint('📝 App Check failure may cause placeholder token warnings');
      debugPrint('📝 This may be due to network connectivity issues');

      // Try alternative initialization without App Check for development
      if (kDebugMode) {
        debugPrint('🔧 Continuing without App Check for debug mode');
      }
    }
  }

  // Token refresh listener with rate limiting to prevent "too many attempts"
  static DateTime? _lastTokenRefresh;

  static void _setupAppCheckTokenListener() {
    FirebaseAppCheck.instance.onTokenChange.listen((token) {
      final now = DateTime.now();

      // Rate limit token refresh to prevent "too many attempts" error
      if (_lastTokenRefresh != null &&
          now.difference(_lastTokenRefresh!) <
              FirebaseConfig.appCheckTokenRefreshCooldown) {
        debugPrint('🔄 App Check token refresh skipped (rate limited)');
        return;
      }

      _lastTokenRefresh = now;
      debugPrint('🔄 App Check token refreshed');
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
}
