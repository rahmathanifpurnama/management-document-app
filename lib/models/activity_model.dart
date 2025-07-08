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
  final String type;
  final String description;
  final DateTime timestamp;
  final String? userName;
  final String? userEmail;
  final String? documentId;
  final String? categoryId;
  final bool isSuspicious;
  final String? ipAddress;
  final String? userAgent;
  final Map<String, dynamic> details;

  ActivityModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.description,
    required this.timestamp,
    this.userName,
    this.userEmail,
    this.documentId,
    this.categoryId,
    this.isSuspicious = false,
    this.ipAddress,
    this.userAgent,
    this.details = const {},
  });

  /// Create ActivityModel from Firestore document
  factory ActivityModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ActivityModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      type: data['type'] ?? data['action'] ?? '',
      description: data['description'] ?? data['resource'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      userName: data['userName'],
      userEmail: data['userEmail'],
      documentId: data['documentId'],
      categoryId: data['categoryId'],
      isSuspicious: data['isSuspicious'] ?? false,
      ipAddress: data['ipAddress'],
      userAgent: data['userAgent'],
      details: Map<String, dynamic>.from(data['details'] ?? {}),
    );
  }

  /// Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'description': description,
      'timestamp': Timestamp.fromDate(timestamp),
      'userName': userName,
      'userEmail': userEmail,
      'documentId': documentId,
      'categoryId': categoryId,
      'isSuspicious': isSuspicious,
      'ipAddress': ipAddress,
      'userAgent': userAgent,
      'details': details,
    };
  }

  /// Get ActivityType from type string
  ActivityType get activityType {
    for (ActivityType activityType in ActivityType.values) {
      if (activityType.value == type) {
        return activityType;
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
    String? type,
    String? description,
    DateTime? timestamp,
    String? userName,
    String? userEmail,
    String? documentId,
    String? categoryId,
    bool? isSuspicious,
    String? ipAddress,
    String? userAgent,
    Map<String, dynamic>? details,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      documentId: documentId ?? this.documentId,
      categoryId: categoryId ?? this.categoryId,
      isSuspicious: isSuspicious ?? this.isSuspicious,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      details: details ?? this.details,
    );
  }

  @override
  String toString() {
    return 'ActivityModel(id: $id, userId: $userId, type: $type, description: $description, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ActivityModel &&
        other.id == id &&
        other.userId == userId &&
        other.type == type &&
        other.description == description &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        type.hashCode ^
        description.hashCode ^
        timestamp.hashCode;
  }
}
