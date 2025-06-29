import 'dart:async';
import 'package:flutter/foundation.dart';
import '../core/services/firebase_service.dart';
import 'cloud_functions_service.dart';
import 'statistics_sync_service.dart';

/// Service for synchronizing Firebase Authentication users with Firestore
/// Ensures all authenticated users are properly represented in statistics
class UserSyncService {
  static final UserSyncService _instance = UserSyncService._internal();
  factory UserSyncService() => _instance;
  UserSyncService._internal();

  static UserSyncService get instance => _instance;

  final FirebaseService _firebaseService = FirebaseService.instance;
  final CloudFunctionsService _cloudFunctions = CloudFunctionsService.instance;
  final StatisticsSyncService _statisticsSync = StatisticsSyncService.instance;

  bool _isInitialized = false;
  bool _isSyncing = false;
  DateTime? _lastSyncTime;

  /// Initialize user sync service
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('📊 UserSyncService: Already initialized');
      return;
    }

    try {
      debugPrint('📊 UserSyncService: Initializing...');

      // Perform initial sync check
      await _performInitialSyncCheck();

      _isInitialized = true;
      debugPrint('✅ UserSyncService: Initialized successfully');
    } catch (e) {
      debugPrint('❌ UserSyncService: Initialization failed - $e');
      rethrow;
    }
  }

  /// Perform initial sync check to ensure Firebase Auth users are in Firestore
  Future<void> _performInitialSyncCheck() async {
    try {
      // Get current user counts
      final authUserCount = await _getFirebaseAuthUserCount();
      final firestoreUserCount = await _getFirestoreUserCount();

      debugPrint('📊 Auth users: $authUserCount, Firestore users: $firestoreUserCount');

      // If there's a significant difference, perform auto-sync
      if (authUserCount > firestoreUserCount) {
        debugPrint('🔄 UserSyncService: Detected missing users, performing auto-sync...');
        await _performAutoSync();
      }
    } catch (e) {
      debugPrint('❌ UserSyncService: Initial sync check failed - $e');
      // Don't rethrow - this is not critical for app startup
    }
  }

  /// Get Firebase Authentication user count
  Future<int> _getFirebaseAuthUserCount() async {
    try {
      // This is an approximation since we can't directly count Auth users from client
      // We'll rely on the Cloud Function to provide accurate counts
      return 0; // Placeholder - actual count will be determined by Cloud Function
    } catch (e) {
      debugPrint('❌ Error getting Firebase Auth user count: $e');
      return 0;
    }
  }

  /// Get Firestore user count
  Future<int> _getFirestoreUserCount() async {
    try {
      final snapshot = await _firebaseService.firestore
          .collection('users')
          .where('isActive', isEqualTo: true)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      debugPrint('❌ Error getting Firestore user count: $e');
      return 0;
    }
  }

  /// Perform automatic sync of Firebase Auth users to Firestore
  Future<Map<String, dynamic>> _performAutoSync() async {
    if (_isSyncing) {
      debugPrint('⚠️ UserSyncService: Sync already in progress');
      return {'success': false, 'message': 'Sync already in progress'};
    }

    _isSyncing = true;

    try {
      debugPrint('🔄 UserSyncService: Starting auto-sync...');

      final result = await _cloudFunctions.autoSyncFirebaseAuthUsers();
      _lastSyncTime = DateTime.now();

      debugPrint('✅ UserSyncService: Auto-sync completed');
      debugPrint('📊 Sync result: ${result.toString()}');

      // Trigger statistics refresh after sync
      _statisticsSync.refreshStatistics(reason: 'User auto-sync completed');

      return result;
    } catch (e) {
      debugPrint('❌ UserSyncService: Auto-sync failed - $e');
      return {
        'success': false,
        'message': 'Auto-sync failed: $e',
      };
    } finally {
      _isSyncing = false;
    }
  }

  /// Manually trigger user sync (for admin use)
  Future<Map<String, dynamic>> manualSync() async {
    try {
      debugPrint('🔄 UserSyncService: Manual sync requested');
      return await _performAutoSync();
    } catch (e) {
      debugPrint('❌ UserSyncService: Manual sync failed - $e');
      rethrow;
    }
  }

  /// Check if sync is needed based on user count discrepancy
  Future<bool> isSyncNeeded() async {
    try {
      final firestoreUserCount = await _getFirestoreUserCount();
      
      // If we have very few users in Firestore, sync is likely needed
      // This assumes there should be at least some seeded users
      return firestoreUserCount < 3;
    } catch (e) {
      debugPrint('❌ Error checking if sync is needed: $e');
      return false;
    }
  }

  /// Get sync status information
  Map<String, dynamic> getSyncStatus() {
    return {
      'isInitialized': _isInitialized,
      'isSyncing': _isSyncing,
      'lastSyncTime': _lastSyncTime?.toIso8601String(),
    };
  }

  /// Force refresh user statistics after external changes
  void notifyUserChanges() {
    _statisticsSync.refreshStatistics(reason: 'User changes detected');
  }

  /// Dispose resources
  void dispose() {
    _isInitialized = false;
    _isSyncing = false;
    _lastSyncTime = null;
    debugPrint('🔄 UserSyncService disposed');
  }
}
