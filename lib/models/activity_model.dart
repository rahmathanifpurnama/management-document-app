import 'package:cloud_firestore/cloud_firestore.dart';

/// Activity types for system logging
enum ActivityType {
  login('login'),
  logout('logout'),
  upload('upload'),
  download('download'),
  delete('delete'),
  update('update'),
  create('create'),
  createUser('create_user'),
  updateUser('update_user'),
  deleteUser('delete_user'),
  approve('approve'),
  reject('reject');

  const ActivityType(this.value);
  final String value;

  /// Get icon for activity type
  String get actionIcon {
    switch (this) {
      case ActivityType.login:
        return '🔐';
      case ActivityType.logout:
        return '🚪';
      case ActivityType.upload:
        return '📤';
      case ActivityType.download:
        return '📥';
      case ActivityType.delete:
        return '🗑️';
      case ActivityType.update:
        return '✏️';
      case ActivityType.create:
        return '➕';
      case ActivityType.createUser:
        return '👤➕';
      case ActivityType.updateUser:
        return '👤✏️';
      case ActivityType.deleteUser:
        return '👤🗑️';
      case ActivityType.approve:
        return '✅';
      case ActivityType.reject:
        return '❌';
    }
  }

  /// Get description for activity type
  String get actionDescription {
    switch (this) {
      case ActivityType.login:
        return 'User Login';
      case ActivityType.logout:
        return 'User Logout';
      case ActivityType.upload:
        return 'File Upload';
      case ActivityType.download:
        return 'File Download';
      case ActivityType.delete:
        return 'Delete Action';
      case ActivityType.update:
        return 'Update Action';
      case ActivityType.create:
        return 'Create Action';
      case ActivityType.createUser:
        return 'Create User';
      case ActivityType.updateUser:
        return 'Update User';
      case ActivityType.deleteUser:
        return 'Delete User';
      case ActivityType.approve:
        return 'Approve Action';
      case ActivityType.reject:
        return 'Reject Action';
    }
  }
}

/// Model for activity logging
class ActivityModel {
  final String id;
  final String userId;
  final String action;
  final String resource;
  final DateTime timestamp;
  final Map<String, dynamic> details;

  ActivityModel({
    required this.id,
    required this.userId,
    required this.action,
    required this.resource,
    required this.timestamp,
    this.details = const {},
  });

  /// Create ActivityModel from Firestore document
  factory ActivityModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ActivityModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      action: data['action'] ?? '',
      resource: data['resource'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      details: Map<String, dynamic>.from(data['details'] ?? {}),
    );
  }

  /// Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'action': action,
      'resource': resource,
      'timestamp': Timestamp.fromDate(timestamp),
      'details': details,
    };
  }

  /// Get ActivityType from action string
  ActivityType get activityType {
    for (ActivityType type in ActivityType.values) {
      if (type.value == action) {
        return type;
      }
    }
    return ActivityType.update; // Default fallback
  }

  /// Get icon for this activity
  String get actionIcon => activityType.actionIcon;

  /// Get description for this activity
  String get actionDescription => activityType.actionDescription;

  /// Copy with new values
  ActivityModel copyWith({
    String? id,
    String? userId,
    String? action,
    String? resource,
    DateTime? timestamp,
    Map<String, dynamic>? details,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      resource: resource ?? this.resource,
      timestamp: timestamp ?? this.timestamp,
      details: details ?? this.details,
    );
  }

  @override
  String toString() {
    return 'ActivityModel(id: $id, userId: $userId, action: $action, resource: $resource, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ActivityModel &&
        other.id == id &&
        other.userId == userId &&
        other.action == action &&
        other.resource == resource &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        action.hashCode ^
        resource.hashCode ^
        timestamp.hashCode;
  }
}
