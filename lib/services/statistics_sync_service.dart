import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'statistics_notification_service.dart';
import 'optimized_statistics_service.dart';
import '../core/services/firebase_service.dart';

/// Service to synchronize statistics updates across providers
/// Ensures real-time statistics updates when data changes
class StatisticsSyncService {
  static final StatisticsSyncService _instance =
      StatisticsSyncService._internal();
  factory StatisticsSyncService() => _instance;
  StatisticsSyncService._internal();

  static StatisticsSyncService get instance => _instance;

  final StatisticsNotificationService _notificationService =
      StatisticsNotificationService.instance;
  final OptimizedStatisticsService _statsService =
      OptimizedStatisticsService.instance;
  final FirebaseService _firebaseService = FirebaseService.instance;

  // Firestore listeners for real-time updates
  StreamSubscription<QuerySnapshot>? _usersListener;
  StreamSubscription<QuerySnapshot>? _categoriesListener;

  bool _isInitialized = false;
  bool _listenersActive = false;

  /// Initialize the sync service with Firestore listeners
  void initialize() {
    if (_isInitialized) {
      debugPrint('📊 StatisticsSyncService: Already initialized');
      return;
    }

    debugPrint(
      '📊 StatisticsSyncService: Initializing with real-time listeners...',
    );

    _setupFirestoreListeners();
    _isInitialized = true;

    debugPrint(
      '✅ StatisticsSyncService: Initialized successfully with real-time capabilities',
    );
  }

  /// Setup Firestore listeners for real-time statistics updates
  void _setupFirestoreListeners() {
    if (_listenersActive) {
      debugPrint('📊 StatisticsSyncService: Listeners already active');
      return;
    }

    try {
      debugPrint('📊 StatisticsSyncService: Setting up Firestore listeners...');

      // Listen to users collection changes
      _usersListener = _firebaseService.firestore
          .collection('users')
          .where('isActive', isEqualTo: true)
          .snapshots()
          .listen(_onUsersCollectionChanged, onError: _onUsersListenerError);

      // Listen to categories collection changes
      _categoriesListener = _firebaseService.firestore
          .collection('categories')
          .where('isActive', isEqualTo: true)
          .snapshots()
          .listen(
            _onCategoriesCollectionChanged,
            onError: _onCategoriesListenerError,
          );

      _listenersActive = true;
      debugPrint('✅ StatisticsSyncService: Firestore listeners setup complete');
    } catch (e) {
      debugPrint('❌ StatisticsSyncService: Error setting up listeners - $e');
      _stopFirestoreListeners(); // Cleanup on error
    }
  }

  /// Handle users collection changes
  void _onUsersCollectionChanged(QuerySnapshot snapshot) {
    try {
      final userCount = snapshot.docs.length;
      debugPrint(
        '📊 StatisticsSyncService: Users collection changed - $userCount active users',
      );

      // Trigger statistics update
      _triggerStatisticsUpdate('Users collection changed ($userCount users)');
    } catch (e) {
      debugPrint('❌ StatisticsSyncService: Error handling users change - $e');
    }
  }

  /// Handle categories collection changes
  void _onCategoriesCollectionChanged(QuerySnapshot snapshot) {
    try {
      final categoryCount = snapshot.docs.length;
      debugPrint(
        '📊 StatisticsSyncService: Categories collection changed - $categoryCount active categories',
      );

      // Trigger statistics update
      _triggerStatisticsUpdate(
        'Categories collection changed ($categoryCount categories)',
      );
    } catch (e) {
      debugPrint(
        '❌ StatisticsSyncService: Error handling categories change - $e',
      );
    }
  }

  /// Handle users listener errors
  void _onUsersListenerError(Object error) {
    debugPrint('❌ StatisticsSyncService: Users listener error - $error');

    // Attempt to restart the listener after a delay
    Future.delayed(const Duration(seconds: 5), () {
      if (_isInitialized && !_listenersActive) {
        debugPrint(
          '🔄 StatisticsSyncService: Attempting to restart users listener',
        );
        _restartUsersListener();
      }
    });
  }

  /// Handle categories listener errors
  void _onCategoriesListenerError(Object error) {
    debugPrint('❌ StatisticsSyncService: Categories listener error - $error');

    // Attempt to restart the listener after a delay
    Future.delayed(const Duration(seconds: 5), () {
      if (_isInitialized && !_listenersActive) {
        debugPrint(
          '🔄 StatisticsSyncService: Attempting to restart categories listener',
        );
        _restartCategoriesListener();
      }
    });
  }

  /// Restart users listener
  void _restartUsersListener() {
    try {
      _usersListener?.cancel();
      _usersListener = _firebaseService.firestore
          .collection('users')
          .where('isActive', isEqualTo: true)
          .snapshots()
          .listen(_onUsersCollectionChanged, onError: _onUsersListenerError);
      debugPrint('✅ StatisticsSyncService: Users listener restarted');
    } catch (e) {
      debugPrint(
        '❌ StatisticsSyncService: Failed to restart users listener - $e',
      );
    }
  }

  /// Restart categories listener
  void _restartCategoriesListener() {
    try {
      _categoriesListener?.cancel();
      _categoriesListener = _firebaseService.firestore
          .collection('categories')
          .where('isActive', isEqualTo: true)
          .snapshots()
          .listen(
            _onCategoriesCollectionChanged,
            onError: _onCategoriesListenerError,
          );
      debugPrint('✅ StatisticsSyncService: Categories listener restarted');
    } catch (e) {
      debugPrint(
        '❌ StatisticsSyncService: Failed to restart categories listener - $e',
      );
    }
  }

  /// Stop Firestore listeners
  void _stopFirestoreListeners() {
    debugPrint('📊 StatisticsSyncService: Stopping Firestore listeners...');

    _usersListener?.cancel();
    _usersListener = null;

    _categoriesListener?.cancel();
    _categoriesListener = null;

    _listenersActive = false;
    debugPrint('✅ StatisticsSyncService: Firestore listeners stopped');
  }

  /// Trigger statistics update
  void _triggerStatisticsUpdate(String reason) {
    debugPrint(
      '📊 StatisticsSyncService: Triggering statistics update - $reason',
    );

    // Invalidate cache to force fresh calculation
    _statsService.invalidateCache(reason: reason);

    // Notify statistics update
    _notificationService.requestStatisticsRefresh(reason: reason);
  }

  /// Manually trigger statistics refresh
  void refreshStatistics({String? reason}) {
    debugPrint('📊 StatisticsSyncService: Manual refresh requested');
    _triggerStatisticsUpdate(reason ?? 'Manual refresh');
  }

  /// Notify file uploaded
  void notifyFileUploaded({
    required String fileId,
    required String fileName,
    required String category,
    required int fileSize,
  }) {
    debugPrint('📊 StatisticsSyncService: File uploaded - $fileName');

    _notificationService.notifyFileUploaded(
      fileId: fileId,
      fileName: fileName,
      category: category,
      fileSize: fileSize,
    );

    _triggerStatisticsUpdate('File uploaded: $fileName');
  }

  /// Notify file deleted
  void notifyFileDeleted({
    required String fileId,
    required String fileName,
    required String category,
    required int fileSize,
  }) {
    debugPrint('📊 StatisticsSyncService: File deleted - $fileName');

    _notificationService.notifyFileDeleted(
      fileId: fileId,
      fileName: fileName,
      category: category,
      fileSize: fileSize,
    );

    _triggerStatisticsUpdate('File deleted: $fileName');
  }

  /// Notify category created
  void notifyCategoryCreated({
    required String categoryId,
    required String categoryName,
  }) {
    debugPrint('📊 StatisticsSyncService: Category created - $categoryName');
    _triggerStatisticsUpdate('Category created: $categoryName');
  }

  /// Notify category deleted
  void notifyCategoryDeleted({
    required String categoryId,
    required String categoryName,
  }) {
    debugPrint('📊 StatisticsSyncService: Category deleted - $categoryName');
    _triggerStatisticsUpdate('Category deleted: $categoryName');
  }

  /// Notify user created
  void notifyUserCreated({required String userId, required String userName}) {
    debugPrint('📊 StatisticsSyncService: User created - $userName');
    _triggerStatisticsUpdate('User created: $userName');
  }

  /// Notify user deleted
  void notifyUserDeleted({required String userId, required String userName}) {
    debugPrint('📊 StatisticsSyncService: User deleted - $userName');
    _triggerStatisticsUpdate('User deleted: $userName');
  }

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Get listener status
  bool get areListenersActive => _listenersActive;

  /// Manually start Firestore listeners (if not already active)
  void startListeners() {
    if (!_listenersActive) {
      debugPrint('📊 StatisticsSyncService: Manually starting listeners...');
      _setupFirestoreListeners();
    } else {
      debugPrint('📊 StatisticsSyncService: Listeners already active');
    }
  }

  /// Manually stop Firestore listeners
  void stopListeners() {
    if (_listenersActive) {
      debugPrint('📊 StatisticsSyncService: Manually stopping listeners...');
      _stopFirestoreListeners();
    } else {
      debugPrint('📊 StatisticsSyncService: Listeners already stopped');
    }
  }

  /// Dispose resources and cleanup listeners
  void dispose() {
    debugPrint('📊 StatisticsSyncService: Disposing...');

    // Stop all Firestore listeners
    _stopFirestoreListeners();

    _isInitialized = false;

    debugPrint('✅ StatisticsSyncService: Disposed with listeners cleanup');
  }
}
