import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/riverpod/notifiers.dart';
import '../../../core/services/firebase_service.dart';
import '../../../models/notification_model.dart';
import '../models/notification_state.dart';

class NotificationNotifier extends BaseNotifier<NotificationState> {
  NotificationNotifier() : super(const NotificationState());

  final FirebaseService _firebaseService = FirebaseService.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  StreamSubscription<QuerySnapshot>? _notificationSubscription;

  // Safe getters for Firebase services
  FirebaseFirestore? get _firestore => _firebaseService.firestoreSafe;
  FirebaseAuth? get _auth => _firebaseService.authSafe;

  /// Initialize notification provider for a user
  Future<void> initialize(String userId) async {
    if (state.isInitializedFor(userId)) return; // Already initialized for this user

    safeUpdate(() => state.copyWith(currentUserId: userId));
    
    await _setupNotificationListener();
    await _requestNotificationPermissions();
    await _updateFCMToken();
    _checkEmailVerificationStatus();
  }

  /// Setup real-time notification listener
  Future<void> _setupNotificationListener() async {
    if (state.currentUserId == null) return;

    safeUpdate(() => state.copyWith(isLoading: true, errorMessage: null));

    try {
      // Cancel existing subscription
      await _notificationSubscription?.cancel();

      // Setup new subscription
      if (_firestore != null) {
        _notificationSubscription = _firestore!
            .collection('notifications')
            .where('userId', isEqualTo: state.currentUserId)
            .orderBy('createdAt', descending: true)
            .limit(100) // Limit to recent 100 notifications
            .snapshots()
            .listen(
              _handleNotificationSnapshot,
              onError: _handleNotificationError,
            );
      }

      debugPrint('✅ Notification listener setup for user: ${state.currentUserId}');
    } catch (e) {
      safeUpdate(() => state.copyWith(
        errorMessage: 'Failed to setup notification listener: ${e.toString()}',
        isLoading: false,
      ));
      debugPrint('❌ Error setting up notification listener: $e');
    }
  }

  /// Handle notification snapshot updates
  void _handleNotificationSnapshot(QuerySnapshot snapshot) {
    try {
      final notifications = snapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();

      final stats = NotificationStats.fromNotifications(notifications);

      safeUpdate(() => state.copyWith(
        notifications: notifications,
        stats: stats,
        errorMessage: null,
        isLoading: false,
      ));

      debugPrint('📱 Updated ${notifications.length} notifications');
    } catch (e) {
      safeUpdate(() => state.copyWith(
        errorMessage: 'Failed to process notifications: ${e.toString()}',
        isLoading: false,
      ));
      debugPrint('❌ Error processing notification snapshot: $e');
    }
  }

  /// Handle notification listener errors
  void _handleNotificationError(dynamic error) {
    safeUpdate(() => state.copyWith(
      errorMessage: 'Notification listener error: ${error.toString()}',
      isLoading: false,
    ));
    debugPrint('❌ Notification listener error: $error');
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

  /// Update FCM token
  Future<void> _updateFCMToken() async {
    if (state.currentUserId == null || _firestore == null) return;

    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _firestore!
            .collection('users')
            .doc(state.currentUserId)
            .update({'fcmToken': token});
        debugPrint('✅ FCM token updated');
      }
    } catch (e) {
      debugPrint('❌ Error updating FCM token: $e');
    }
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    if (state.currentUserId == null || _firestore == null) return;

    try {
      await _firestore!
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
      debugPrint('✅ Notification marked as read: $notificationId');
    } catch (e) {
      debugPrint('❌ Error marking notification as read: $e');
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    if (state.currentUserId == null || _firestore == null) return;

    try {
      final batch = _firestore!.batch();

      for (final notification in state.unreadNotifications) {
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
    if (state.currentUserId == null || _firestore == null) return;

    try {
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
    if (state.currentUserId == null || _firestore == null) return;

    try {
      final batch = _firestore!.batch();

      for (final notification in state.notifications) {
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
    if (state.currentUserId != null) {
      await _setupNotificationListener();
    }
  }

  /// Check if current user has unverified email
  void _checkEmailVerificationStatus() {
    if (_auth == null) return;

    final user = _auth!.currentUser;
    if (user != null && !user.emailVerified) {
      safeUpdate(() => state.copyWith(
        hasUnverifiedEmailWarning: true,
        isEmailVerificationDismissed: false,
      ));
    } else {
      safeUpdate(() => state.copyWith(
        hasUnverifiedEmailWarning: false,
        isEmailVerificationDismissed: false,
      ));
    }
  }

  /// Dismiss the email verification warning
  void dismissEmailVerificationWarning() {
    safeUpdate(() => state.copyWith(isEmailVerificationDismissed: true));
  }

  /// Refresh email verification status
  void refreshEmailVerificationStatus() {
    _checkEmailVerificationStatus();
  }

  /// Reset provider state
  @override
  void reset() {
    _notificationSubscription?.cancel();
    state = const NotificationState();
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }
}
