import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../models/notification_model.dart';

part 'notification_state.freezed.dart';

@freezed
class NotificationState with _$NotificationState {
  const factory NotificationState({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default([])
    List<NotificationModel> notifications,
    @JsonKey(includeFromJson: false, includeToJson: false)
    NotificationStats? stats,
    @Default(false) bool isLoading,
    String? errorMessage,
    String? currentUserId,
    @Default(false) bool hasUnverifiedEmailWarning,
    @Default(false) bool isEmailVerificationDismissed,
  }) = _NotificationState;
}

/// Extension to provide computed properties
extension NotificationStateX on NotificationState {
  /// Get stats with fallback to empty
  NotificationStats get safeStats => stats ?? NotificationStats.empty();

  /// Get unread count
  int get unreadCount => safeStats.unreadCount;

  /// Check if there are unread notifications
  bool get hasUnreadNotifications => safeStats.unreadCount > 0;

  /// Check if email verification warning is active
  bool get hasActiveEmailWarning =>
      this.hasUnverifiedEmailWarning && !this.isEmailVerificationDismissed;

  /// Get total notification count including email warning
  int get totalNotificationCount =>
      unreadCount + (hasActiveEmailWarning ? 1 : 0);

  /// Check if there are any notifications (including email warning)
  bool get hasAnyNotifications =>
      hasUnreadNotifications || hasActiveEmailWarning;

  /// Get unread notifications
  List<NotificationModel> get unreadNotifications =>
      this.notifications.where((n) => !n.isRead).toList();

  /// Get recent notifications
  List<NotificationModel> get recentNotifications =>
      this.notifications.where((n) => n.isRecent).toList();

  /// Get notifications by type
  List<NotificationModel> getNotificationsByType(NotificationType type) =>
      this.notifications.where((n) => n.type == type).toList();

  /// Check if provider is initialized for a user
  bool isInitializedFor(String userId) => this.currentUserId == userId;

  /// Check if there's an error
  bool get hasError => this.errorMessage != null;
}
