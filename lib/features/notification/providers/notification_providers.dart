import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/notification_model.dart';
import '../notifiers/notification_notifier.dart';
import '../models/notification_state.dart';

/// Main notification provider
final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier();
});

/// Computed providers for specific notification properties
final notificationsProvider = Provider<List<NotificationModel>>((ref) {
  return ref.watch(notificationProvider).notifications;
});

final notificationStatsProvider = Provider<NotificationStats>((ref) {
  return ref.watch(notificationProvider).stats;
});

final isNotificationLoadingProvider = Provider<bool>((ref) {
  return ref.watch(notificationProvider).isLoading;
});

final notificationErrorProvider = Provider<String?>((ref) {
  return ref.watch(notificationProvider).errorMessage;
});

final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationProvider).unreadCount;
});

final hasUnreadNotificationsProvider = Provider<bool>((ref) {
  return ref.watch(notificationProvider).hasUnreadNotifications;
});

final hasUnverifiedEmailWarningProvider = Provider<bool>((ref) {
  return ref.watch(notificationProvider).hasUnverifiedEmailWarning;
});

final isEmailVerificationDismissedProvider = Provider<bool>((ref) {
  return ref.watch(notificationProvider).isEmailVerificationDismissed;
});

final hasActiveEmailWarningProvider = Provider<bool>((ref) {
  return ref.watch(notificationProvider).hasActiveEmailWarning;
});

final totalNotificationCountProvider = Provider<int>((ref) {
  return ref.watch(notificationProvider).totalNotificationCount;
});

final hasAnyNotificationsProvider = Provider<bool>((ref) {
  return ref.watch(notificationProvider).hasAnyNotifications;
});

final unreadNotificationsProvider = Provider<List<NotificationModel>>((ref) {
  return ref.watch(notificationProvider).unreadNotifications;
});

final recentNotificationsProvider = Provider<List<NotificationModel>>((ref) {
  return ref.watch(notificationProvider).recentNotifications;
});

/// Provider for notifications by type
final notificationsByTypeProvider = Provider.family<List<NotificationModel>, NotificationType>((ref, type) {
  return ref.watch(notificationProvider).getNotificationsByType(type);
});

/// Notification actions provider
final notificationActionsProvider = Provider<NotificationActions>((ref) {
  return NotificationActions(ref);
});

/// Notification actions class for easy access to notifier methods
class NotificationActions {
  final Ref _ref;
  
  NotificationActions(this._ref);

  NotificationNotifier get _notifier => _ref.read(notificationProvider.notifier);

  Future<void> initialize(String userId) async {
    await _notifier.initialize(userId);
  }

  Future<void> markAsRead(String notificationId) async {
    await _notifier.markAsRead(notificationId);
  }

  Future<void> markAllAsRead() async {
    await _notifier.markAllAsRead();
  }

  Future<void> deleteNotification(String notificationId) async {
    await _notifier.deleteNotification(notificationId);
  }

  Future<void> clearAllNotifications() async {
    await _notifier.clearAllNotifications();
  }

  Future<void> refresh() async {
    await _notifier.refresh();
  }

  void dismissEmailVerificationWarning() {
    _notifier.dismissEmailVerificationWarning();
  }

  void refreshEmailVerificationStatus() {
    _notifier.refreshEmailVerificationStatus();
  }

  void reset() {
    _notifier.reset();
  }
}
