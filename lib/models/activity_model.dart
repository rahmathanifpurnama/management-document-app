import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

/// Activity types for user-initiated actions only
/// System-generated operations are excluded to keep activity logs clean and meaningful
enum ActivityType {
  // Authentication activities (user-initiated)
  login('login'),
  logout('logout'),

  // File operations (user-initiated)
  upload('upload'),
  download('download'),
  delete('delete'),
  view('view'),
  share('share'),
  copy('copy'),
  move('move'),
  rename('rename'),

  // Document management (user-initiated)
  update('update'),
  create('create'),

  // User management (admin-initiated)
  createUser('create_user'),
  updateUser('update_user'),
  deleteUser('delete_user'),

  // Category management (user/admin-initiated)
  categoryCreate('category_create'),
  categoryUpdate('category_update'),
  categoryDelete('category_delete'),

  // Security and monitoring (user-initiated or admin-initiated)
  suspiciousActivity('suspicious_activity'),
  security('security');

  // REMOVED: System-generated activity types
  // - sync: Automatic synchronization processes
  // - backup: Automatic backup operations
  // - restore: Automatic restore operations
  // - fileUploaded: Duplicate of upload (system-generated)

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
      case ActivityType.view:
        return '👁️';
      case ActivityType.share:
        return '🔗';
      case ActivityType.copy:
        return '📋';
      case ActivityType.move:
        return '📁';
      case ActivityType.rename:
        return '✏️';
      case ActivityType.categoryCreate:
        return '📂➕';
      case ActivityType.categoryUpdate:
        return '📂✏️';
      case ActivityType.categoryDelete:
        return '📂🗑️';
      case ActivityType.suspiciousActivity:
        return '⚠️';
      case ActivityType.security:
        return '🔒';
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
      case ActivityType.view:
        return 'View Action';
      case ActivityType.share:
        return 'Share Action';
      case ActivityType.copy:
        return 'Copy Action';
      case ActivityType.move:
        return 'Move Action';
      case ActivityType.rename:
        return 'Rename Action';
      case ActivityType.categoryCreate:
        return 'Category Created';
      case ActivityType.categoryUpdate:
        return 'Category Updated';
      case ActivityType.categoryDelete:
        return 'Category Deleted';
      case ActivityType.suspiciousActivity:
        return 'Suspicious Activity';
      case ActivityType.security:
        return 'Security Event';
    }
  }

  /// Get Material icon for activity type
  IconData get materialIcon {
    switch (this) {
      case ActivityType.login:
        return Icons.login;
      case ActivityType.logout:
        return Icons.logout;
      case ActivityType.upload:
        return Icons.cloud_upload;
      case ActivityType.download:
        return Icons.get_app;
      case ActivityType.delete:
        return Icons.delete_forever;
      case ActivityType.view:
        return Icons.preview;
      case ActivityType.create:
        return Icons.add_circle;
      case ActivityType.update:
        return Icons.edit;
      case ActivityType.share:
        return Icons.share;
      case ActivityType.copy:
        return Icons.content_copy;
      case ActivityType.move:
        return Icons.drive_file_move;
      case ActivityType.rename:
        return Icons.drive_file_rename_outline;
      case ActivityType.createUser:
        return Icons.person_add;
      case ActivityType.updateUser:
        return Icons.person_outline;
      case ActivityType.deleteUser:
        return Icons.person_remove;
      case ActivityType.categoryCreate:
        return Icons.create_new_folder;
      case ActivityType.categoryUpdate:
        return Icons.folder_open;
      case ActivityType.categoryDelete:
        return Icons.folder_delete;
      case ActivityType.suspiciousActivity:
        return Icons.warning;
      case ActivityType.security:
        return Icons.security;
    }
  }

  /// Get color for activity type
  Color get color {
    switch (this) {
      case ActivityType.login:
        return AppColors.success;
      case ActivityType.logout:
        return AppColors.primary;
      case ActivityType.upload:
        return AppColors.success;
      case ActivityType.download:
        return AppColors.info;
      case ActivityType.delete:
      case ActivityType.deleteUser:
      case ActivityType.categoryDelete:
        return AppColors.error;
      case ActivityType.view:
        return AppColors.textSecondary;
      case ActivityType.create:
      case ActivityType.createUser:
      case ActivityType.categoryCreate:
        return AppColors.success;
      case ActivityType.update:
      case ActivityType.updateUser:
      case ActivityType.categoryUpdate:
      case ActivityType.rename:
      case ActivityType.move:
        return AppColors.warning;
      case ActivityType.share:
        return AppColors.primary;
      case ActivityType.copy:
        return AppColors.info;
      case ActivityType.suspiciousActivity:
      case ActivityType.security:
        return AppColors.error;
    }
  }
}

/// Base abstract class for all activity types
abstract class BaseActivity {
  final String id;
  final String userId;
  final String type;
  final String description;
  final DateTime timestamp;
  final String? userName;
  final String? userEmail;
  final bool isSuspicious;
  final String? ipAddress;
  final String? userAgent;
  final Map<String, dynamic> details;

  const BaseActivity({
    required this.id,
    required this.userId,
    required this.type,
    required this.description,
    required this.timestamp,
    this.userName,
    this.userEmail,
    this.isSuspicious = false,
    this.ipAddress,
    this.userAgent,
    this.details = const {},
  });

  /// Get the activity type enum
  ActivityType get activityType;

  /// Get the display title for this activity
  String get displayTitle;

  /// Get the display subtitle for this activity
  String get displaySubtitle;

  /// Get additional context information for this activity
  List<String> get contextInfo;

  /// Get the icon for this activity type
  IconData get icon => activityType.materialIcon;

  /// Get the color for this activity type
  Color get color => activityType.color;

  /// Check if this activity has specific context (document, category, etc.)
  bool get hasContext;

  /// Convert to Map for Firestore
  Map<String, dynamic> toMap();

  /// Create a copy with updated values
  BaseActivity copyWith({
    String? id,
    String? userId,
    String? type,
    String? description,
    DateTime? timestamp,
    String? userName,
    String? userEmail,
    bool? isSuspicious,
    String? ipAddress,
    String? userAgent,
    Map<String, dynamic>? details,
  });

  @override
  String toString() {
    return '$runtimeType(id: $id, userId: $userId, type: $type, description: $description, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BaseActivity &&
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

/// Legacy ActivityModel for backward compatibility
class ActivityModel extends BaseActivity {
  final String? documentId;
  final String? categoryId;

  const ActivityModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.description,
    required super.timestamp,
    super.userName,
    super.userEmail,
    this.documentId,
    this.categoryId,
    super.isSuspicious = false,
    super.ipAddress,
    super.userAgent,
    super.details = const {},
  });

  @override
  ActivityType get activityType {
    for (ActivityType activityType in ActivityType.values) {
      if (activityType.value == type) {
        return activityType;
      }
    }
    return ActivityType.update; // Default fallback
  }

  @override
  String get displayTitle => description;

  @override
  String get displaySubtitle => userName ?? userEmail ?? 'Unknown User';

  @override
  List<String> get contextInfo {
    final info = <String>[];
    if (documentId != null) info.add('Document: $documentId');
    if (categoryId != null) info.add('Category: $categoryId');
    if (ipAddress != null) info.add('IP: $ipAddress');
    return info;
  }

  @override
  bool get hasContext => documentId != null || categoryId != null;

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
      details: _parseDetails(data['details']),
    );
  }

  /// Parse details from Firestore data
  static Map<String, dynamic> _parseDetails(dynamic details) {
    if (details == null) return {};
    if (details is Map<String, dynamic>) return details;
    if (details is Map) {
      return Map<String, dynamic>.from(details);
    }
    return {};
  }

  @override
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

  /// Get icon for this activity
  String get actionIcon => activityType.actionIcon;

  /// Get description for this activity
  String get actionDescription => activityType.actionDescription;

  @override
  ActivityModel copyWith({
    String? id,
    String? userId,
    String? type,
    String? description,
    DateTime? timestamp,
    String? userName,
    String? userEmail,
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
      documentId: documentId,
      categoryId: categoryId,
      isSuspicious: isSuspicious ?? this.isSuspicious,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      details: details ?? this.details,
    );
  }
}
