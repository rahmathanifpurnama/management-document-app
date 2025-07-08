import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/notification_model.dart';

import '../core/services/firebase_service.dart';

class NotificationProvider with ChangeNotifier {
  static final NotificationProvider _instance =
      NotificationProvider._internal();
  factory NotificationProvider() => _instance;
  NotificationProvider._internal();

  final FirebaseService _firebaseService = FirebaseService.instance;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Safe getters for Firebase services
  FirebaseFirestore? get _firestore => _firebaseService.firestoreSafe;
  FirebaseAuth? get _auth => _firebaseService.authSafe;

  // State variables
  List<NotificationModel> _notifications = [];
  NotificationStats _stats = NotificationStats.empty();
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription<QuerySnapshot>? _notificationSubscription;
  String? _currentUserId;

  // Email verification notification state
  bool _hasUnverifiedEmailWarning = false;
  bool _isEmailVerificationDismissed = false;

  // Getters
  List<NotificationModel> get notifications =>
      List.unmodifiable(_notifications);
  NotificationStats get stats => _stats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get unreadCount => _stats.unreadCount;
  bool get hasUnreadNotifications => _stats.unreadCount > 0;

  // Email verification getters
  bool get hasUnverifiedEmailWarning => _hasUnverifiedEmailWarning;
  bool get isEmailVerificationDismissed => _isEmailVerificationDismissed;
  bool get hasActiveEmailWarning =>
      _hasUnverifiedEmailWarning && !_isEmailVerificationDismissed;
  int get totalNotificationCount =>
      unreadCount + (hasActiveEmailWarning ? 1 : 0);
  bool get hasAnyNotifications =>
      hasUnreadNotifications || hasActiveEmailWarning;

  // Filtered notifications
  List<NotificationModel> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();

  List<NotificationModel> get recentNotifications =>
      _notifications.where((n) => n.isRecent).toList();

  List<NotificationModel> getNotificationsByType(NotificationType type) =>
      _notifications.where((n) => n.type == type).toList();

  /// Initialize notification provider for a user
  Future<void> initialize(String userId) async {
    if (_currentUserId == userId) return; // Already initialized for this user

    _currentUserId = userId;
    await _setupNotificationListener();
    await _requestNotificationPermissions();
    await _updateFCMToken();
    _checkEmailVerificationStatus();
  }

  /// Setup real-time notification listener
  Future<void> _setupNotificationListener() async {
    if (_currentUserId == null) return;

    _setLoading(true);
    _clearError();

    try {
      // Cancel existing subscription
      await _notificationSubscription?.cancel();

      // Setup new subscription
      if (_firestore != null) {
        _notificationSubscription = _firestore!
            .collection('notifications')
            .where('userId', isEqualTo: _currentUserId)
            .orderBy('createdAt', descending: true)
            .limit(100) // Limit to recent 100 notifications
            .snapshots()
            .listen(
              _handleNotificationSnapshot,
              onError: _handleNotificationError,
            );
      }

      debugPrint('✅ Notification listener setup for user: $_currentUserId');
    } catch (e) {
      _setError('Failed to setup notification listener: ${e.toString()}');
      debugPrint('❌ Error setting up notification listener: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Handle notification snapshot updates
  void _handleNotificationSnapshot(QuerySnapshot snapshot) {
    try {
      _notifications = snapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();

      _updateStats();
      _clearError();
      notifyListeners();

      debugPrint('📱 Updated ${_notifications.length} notifications');
    } catch (e) {
      _setError('Failed to process notifications: ${e.toString()}');
      debugPrint('❌ Error processing notification snapshot: $e');
    }
  }

  /// Handle notification listener errors
  void _handleNotificationError(dynamic error) {
    _setError('Notification listener error: ${error.toString()}');
    debugPrint('❌ Notification listener error: $error');
  }

  /// Update notification statistics
  void _updateStats() {
    _stats = NotificationStats.fromNotifications(_notifications);
  }

  /// Request notification permissions
  Future<void> _requestNotificationPermissions() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('✅ Notification permissions granted');
      } else {
        debugPrint('⚠️ Notification permissions denied');
      }
    } catch (e) {
      debugPrint('❌ Error requesting notification permissions: $e');
    }
  }

  /// Update FCM token for push notifications
  Future<void> _updateFCMToken() async {
    if (_currentUserId == null) return;

    try {
      final token = await _messaging.getToken();
      if (token != null && _firestore != null) {
        await _firestore!.collection('users').doc(_currentUserId).update({
          'fcmToken': token,
        });
        debugPrint('✅ FCM token updated');
      }
    } catch (e) {
      debugPrint('❌ Error updating FCM token: $e');
    }
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      if (_firestore == null) return;

      await _firestore!.collection('notifications').doc(notificationId).update({
        'isRead': true,
      });

      // Update local state
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
        _updateStats();
        notifyListeners();
      }

      debugPrint('✅ Notification marked as read: $notificationId');
    } catch (e) {
      debugPrint('❌ Error marking notification as read: $e');
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    if (_currentUserId == null) return;

    try {
      if (_firestore == null) return;

      final batch = _firestore!.batch();
      final unreadNotifications = _notifications.where((n) => !n.isRead);

      for (final notification in unreadNotifications) {
        final docRef = _firestore!
            .collection('notifications')
            .doc(notification.id);
        batch.update(docRef, {'isRead': true});
      }

      await batch.commit();
      debugPrint('✅ All notifications marked as read');
    } catch (e) {
      debugPrint('❌ Error marking all notifications as read: $e');
    }
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      if (_firestore == null) return;

      await _firestore!
          .collection('notifications')
          .doc(notificationId)
          .delete();

      debugPrint('✅ Notification deleted: $notificationId');
    } catch (e) {
      debugPrint('❌ Error deleting notification: $e');
    }
  }

  /// Clear all notifications
  Future<void> clearAllNotifications() async {
    if (_currentUserId == null) return;

    try {
      if (_firestore == null) return;

      final batch = _firestore!.batch();

      for (final notification in _notifications) {
        final docRef = _firestore!
            .collection('notifications')
            .doc(notification.id);
        batch.delete(docRef);
      }

      await batch.commit();
      debugPrint('✅ All notifications cleared');
    } catch (e) {
      debugPrint('❌ Error clearing all notifications: $e');
    }
  }

  /// Refresh notifications
  Future<void> refresh() async {
    if (_currentUserId != null) {
      await _setupNotificationListener();
    }
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Clear error message
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Dispose resources
  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }

  /// Reset provider state
  void reset() {
    _notificationSubscription?.cancel();
    _notifications.clear();
    _stats = NotificationStats.empty();
    _isLoading = false;
    _errorMessage = null;
    _currentUserId = null;
    _hasUnverifiedEmailWarning = false;
    _isEmailVerificationDismissed = false;
    notifyListeners();
  }

  /// Check if current user has unverified email
  void _checkEmailVerificationStatus() {
    if (_auth == null) return;

    final user = _auth!.currentUser;
    if (user != null && !user.emailVerified) {
      _hasUnverifiedEmailWarning = true;
      _isEmailVerificationDismissed = false;
    } else {
      _hasUnverifiedEmailWarning = false;
      _isEmailVerificationDismissed = false;
    }
    notifyListeners();
  }

  /// Dismiss the email verification warning
  void dismissEmailVerificationWarning() {
    _isEmailVerificationDismissed = true;
    notifyListeners();
  }

  /// Refresh email verification status
  void refreshEmailVerificationStatus() {
    _checkEmailVerificationStatus();
  }
}
