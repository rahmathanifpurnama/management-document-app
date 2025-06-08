import 'package:cloud_firestore/cloud_firestore.dart';

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
    required this.details,
  });

  // Factory constructor from Firestore document
  factory ActivityModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return ActivityModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      action: data['action'] ?? '',
      resource: data['resource'] ?? '',
      timestamp: data['timestamp']?.toDate() ?? DateTime.now(),
      details: Map<String, dynamic>.from(data['details'] ?? {}),
    );
  }

  // Factory constructor from Map
  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      action: map['action'] ?? '',
      resource: map['resource'] ?? '',
      timestamp: map['timestamp']?.toDate() ?? DateTime.now(),
      details: Map<String, dynamic>.from(map['details'] ?? {}),
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'action': action,
      'resource': resource,
      'timestamp': Timestamp.fromDate(timestamp),
      'details': details,
    };
  }

  // Copy with method
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

  // Get formatted action description
  String get actionDescription {
    switch (action) {
      case 'login':
        return 'Masuk ke sistem';
      case 'logout':
        return 'Keluar dari sistem';
      case 'upload':
        return 'Mengupload dokumen';
      case 'download':
        return 'Mendownload dokumen';
      case 'delete':
        return 'Menghapus dokumen';
      case 'create':
        return 'Membuat';
      case 'update':
        return 'Mengupdate';
      case 'approve':
        return 'Menyetujui dokumen';
      case 'reject':
        return 'Menolak dokumen';
      case 'create_user':
        return 'Membuat pengguna baru';
      case 'update_user':
        return 'Mengupdate pengguna';
      case 'delete_user':
        return 'Menghapus pengguna';
      case 'create_category':
        return 'Membuat kategori baru';
      case 'update_category':
        return 'Mengupdate kategori';
      case 'delete_category':
        return 'Menghapus kategori';
      default:
        return action;
    }
  }

  // Get activity icon based on action
  String get actionIcon {
    switch (action) {
      case 'login':
        return '🔐';
      case 'logout':
        return '🚪';
      case 'upload':
        return '📤';
      case 'download':
        return '📥';
      case 'delete':
        return '🗑️';
      case 'create':
        return '➕';
      case 'update':
        return '✏️';
      case 'approve':
        return '✅';
      case 'reject':
        return '❌';
      case 'create_user':
        return '👤➕';
      case 'update_user':
        return '👤✏️';
      case 'delete_user':
        return '👤🗑️';
      case 'create_category':
        return '📁➕';
      case 'update_category':
        return '📁✏️';
      case 'delete_category':
        return '📁🗑️';
      default:
        return '📋';
    }
  }

  @override
  String toString() {
    return 'ActivityModel(id: $id, userId: $userId, action: $action, resource: $resource)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ActivityModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Activity types enum
enum ActivityType {
  login,
  logout,
  upload,
  download,
  delete,
  create,
  update,
  approve,
  reject,
  createUser,
  updateUser,
  deleteUser,
  createCategory,
  updateCategory,
  deleteCategory,
}

// Extension to convert enum to string
extension ActivityTypeExtension on ActivityType {
  String get value {
    switch (this) {
      case ActivityType.login:
        return 'login';
      case ActivityType.logout:
        return 'logout';
      case ActivityType.upload:
        return 'upload';
      case ActivityType.download:
        return 'download';
      case ActivityType.delete:
        return 'delete';
      case ActivityType.create:
        return 'create';
      case ActivityType.update:
        return 'update';
      case ActivityType.approve:
        return 'approve';
      case ActivityType.reject:
        return 'reject';
      case ActivityType.createUser:
        return 'create_user';
      case ActivityType.updateUser:
        return 'update_user';
      case ActivityType.deleteUser:
        return 'delete_user';
      case ActivityType.createCategory:
        return 'create_category';
      case ActivityType.updateCategory:
        return 'update_category';
      case ActivityType.deleteCategory:
        return 'delete_category';
    }
  }
}
