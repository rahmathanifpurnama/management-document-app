import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  fileUploaded,
  fileApproved,
  fileRejected,
  bulkApproval,
  bulkRejection,
  systemNotification,
}

enum NotificationPriority {
  low,
  normal,
  high,
  urgent,
}

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final NotificationType type;
  final NotificationPriority priority;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? data;
  final String? documentId;
  final String? actionUrl;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.priority = NotificationPriority.normal,
    required this.createdAt,
    this.isRead = false,
    this.data,
    this.documentId,
    this.actionUrl,
  });

  // Factory constructor from Firestore document
  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return NotificationModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      type: _parseNotificationType(data['type']),
      priority: _parseNotificationPriority(data['priority']),
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] ?? false,
      data: data['data'],
      documentId: data['documentId'],
      actionUrl: data['actionUrl'],
    );
  }

  // Factory constructor from Map
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      type: _parseNotificationType(map['type']),
      priority: _parseNotificationPriority(map['priority']),
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      isRead: map['isRead'] ?? false,
      data: map['data'],
      documentId: map['documentId'],
      actionUrl: map['actionUrl'],
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'message': message,
      'type': type.name,
      'priority': priority.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
      'data': data,
      'documentId': documentId,
      'actionUrl': actionUrl,
    };
  }

  // Copy with method
  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    NotificationType? type,
    NotificationPriority? priority,
    DateTime? createdAt,
    bool? isRead,
    Map<String, dynamic>? data,
    String? documentId,
    String? actionUrl,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
      documentId: documentId ?? this.documentId,
      actionUrl: actionUrl ?? this.actionUrl,
    );
  }

  // Helper methods for parsing enums
  static NotificationType _parseNotificationType(String? type) {
    switch (type) {
      case 'fileUploaded':
        return NotificationType.fileUploaded;
      case 'fileApproved':
        return NotificationType.fileApproved;
      case 'fileRejected':
        return NotificationType.fileRejected;
      case 'bulkApproval':
        return NotificationType.bulkApproval;
      case 'bulkRejection':
        return NotificationType.bulkRejection;
      case 'systemNotification':
        return NotificationType.systemNotification;
      default:
        return NotificationType.systemNotification;
    }
  }

  static NotificationPriority _parseNotificationPriority(String? priority) {
    switch (priority) {
      case 'low':
        return NotificationPriority.low;
      case 'normal':
        return NotificationPriority.normal;
      case 'high':
        return NotificationPriority.high;
      case 'urgent':
        return NotificationPriority.urgent;
      default:
        return NotificationPriority.normal;
    }
  }

  // Get display icon for notification type
  String get displayIcon {
    switch (type) {
      case NotificationType.fileUploaded:
        return '📤';
      case NotificationType.fileApproved:
        return '✅';
      case NotificationType.fileRejected:
        return '❌';
      case NotificationType.bulkApproval:
        return '✅';
      case NotificationType.bulkRejection:
        return '❌';
      case NotificationType.systemNotification:
        return '🔔';
    }
  }

  // Get priority color
  String get priorityColor {
    switch (priority) {
      case NotificationPriority.low:
        return '#6B7280'; // Gray
      case NotificationPriority.normal:
        return '#3B82F6'; // Blue
      case NotificationPriority.high:
        return '#F59E0B'; // Orange
      case NotificationPriority.urgent:
        return '#EF4444'; // Red
    }
  }

  // Check if notification is recent (within 24 hours)
  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inHours < 24;
  }

  // Get formatted time ago
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, type: $type, isRead: $isRead)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Notification statistics model
class NotificationStats {
  final int totalCount;
  final int unreadCount;
  final int todayCount;
  final int weekCount;
  final Map<NotificationType, int> typeBreakdown;

  NotificationStats({
    required this.totalCount,
    required this.unreadCount,
    required this.todayCount,
    required this.weekCount,
    required this.typeBreakdown,
  });

  factory NotificationStats.empty() {
    return NotificationStats(
      totalCount: 0,
      unreadCount: 0,
      todayCount: 0,
      weekCount: 0,
      typeBreakdown: {},
    );
  }

  factory NotificationStats.fromNotifications(List<NotificationModel> notifications) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekAgo = now.subtract(const Duration(days: 7));

    int unreadCount = 0;
    int todayCount = 0;
    int weekCount = 0;
    Map<NotificationType, int> typeBreakdown = {};

    for (final notification in notifications) {
      if (!notification.isRead) unreadCount++;
      if (notification.createdAt.isAfter(today)) todayCount++;
      if (notification.createdAt.isAfter(weekAgo)) weekCount++;

      typeBreakdown[notification.type] = (typeBreakdown[notification.type] ?? 0) + 1;
    }

    return NotificationStats(
      totalCount: notifications.length,
      unreadCount: unreadCount,
      todayCount: todayCount,
      weekCount: weekCount,
      typeBreakdown: typeBreakdown,
    );
  }
}
