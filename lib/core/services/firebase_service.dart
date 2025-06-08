import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import '../../services/cloud_functions_service.dart';

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
      // Use debug provider for development
      // In production, you should use proper App Check providers
      if (kDebugMode) {
        await FirebaseAppCheck.instance.activate(
          // Use debug provider for development
          androidProvider: AndroidProvider.debug,
          // For iOS, you would also add:
          // iosProvider: IOSProvider.debug,
          // Enable automatic token refresh
          appleProvider: AppleProvider.debug,
        );
      } else {
        // For production, use proper providers like Play Integrity or Device Check
        await FirebaseAppCheck.instance.activate(
          // Configure proper providers for production
          androidProvider: AndroidProvider.playIntegrity,
          // For iOS production:
          appleProvider: AppleProvider.deviceCheck,
        );
      }

      // Set up token refresh listener to handle token expiration
      FirebaseAppCheck.instance.onTokenChange.listen((token) {
        // Token refreshed
      });
    } catch (e) {
      // App Check is not critical for app functionality, so we continue
    }
  }

  // Collections references
  CollectionReference get usersCollection => firestore.collection('users');
  CollectionReference get documentsCollection =>
      firestore.collection('documents');
  CollectionReference get categoriesCollection =>
      firestore.collection('categories');
  CollectionReference get activitiesCollection =>
      firestore.collection('activities');

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
