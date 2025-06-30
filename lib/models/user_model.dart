import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String status;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? lastLogin;
  final String? profileImage;
  final UserPermissions permissions;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.status,
    this.createdBy,
    this.createdAt,
    this.lastLogin,
    this.profileImage,
    required this.permissions,
  });

  // Factory constructor from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    try {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // Safely extract and validate fullName
      String fullName = data['fullName']?.toString() ?? '';
      String email = data['email']?.toString() ?? '';

      // Ensure fullName is never empty - use fallbacks
      if (fullName.trim().isEmpty) {
        if (email.isNotEmpty) {
          // Extract name from email (part before @)
          fullName = email
              .split('@')[0]
              .replaceAll('.', ' ')
              .replaceAll('_', ' ');
          // Capitalize each word
          fullName = fullName
              .split(' ')
              .map(
                (word) => word.isNotEmpty
                    ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                    : '',
              )
              .where((word) => word.isNotEmpty)
              .join(' ');
        }

        // Final fallback if email parsing fails
        if (fullName.trim().isEmpty) {
          fullName = 'Unknown User';
        }
      }

      return UserModel(
        id: doc.id,
        fullName: fullName,
        email: email,
        role: data['role']?.toString() ?? 'user',
        status: data['status']?.toString() ?? 'active',
        createdBy: data['createdBy']?.toString(),
        createdAt: _parseTimestamp(data['createdAt']),
        lastLogin: _parseTimestamp(data['lastLogin']),
        profileImage: data['profileImage']?.toString(),
        permissions: UserPermissions.fromMap(_parseMap(data['permissions'])),
      );
    } catch (e) {
      throw Exception(
        'Error parsing user data from Firestore: ${e.toString()}',
      );
    }
  }

  // Helper method to safely parse timestamp
  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return null;
  }

  // Helper method to safely parse map
  static Map<String, dynamic> _parseMap(dynamic value) {
    if (value == null) return {};

    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return {};
  }

  // Factory constructor from Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    try {
      // Safely extract and validate fullName
      String fullName = map['fullName']?.toString() ?? '';
      String email = map['email']?.toString() ?? '';

      // Ensure fullName is never empty - use fallbacks
      if (fullName.trim().isEmpty) {
        if (email.isNotEmpty) {
          // Extract name from email (part before @)
          fullName = email
              .split('@')[0]
              .replaceAll('.', ' ')
              .replaceAll('_', ' ');
          // Capitalize each word
          fullName = fullName
              .split(' ')
              .map(
                (word) => word.isNotEmpty
                    ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                    : '',
              )
              .where((word) => word.isNotEmpty)
              .join(' ');
        }

        // Final fallback if email parsing fails
        if (fullName.trim().isEmpty) {
          fullName = 'Unknown User';
        }
      }

      return UserModel(
        id: map['id']?.toString() ?? '',
        fullName: fullName,
        email: email,
        role: map['role']?.toString() ?? 'user',
        status: map['status']?.toString() ?? 'active',
        createdBy: map['createdBy']?.toString(),
        createdAt: _parseTimestamp(map['createdAt']),
        lastLogin: _parseTimestamp(map['lastLogin']),
        profileImage: map['profileImage']?.toString(),
        permissions: UserPermissions.fromMap(_parseMap(map['permissions'])),
      );
    } catch (e) {
      throw Exception('Error parsing user data from Map: ${e.toString()}');
    }
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'role': role,
      'status': status,
      'createdBy': createdBy,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'lastLogin': lastLogin != null ? Timestamp.fromDate(lastLogin!) : null,
      'profileImage': profileImage,
      'permissions': permissions.toMap(),
    };
  }

  // Copy with method
  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? role,
    String? status,
    String? createdBy,
    DateTime? createdAt,
    DateTime? lastLogin,
    String? profileImage,
    UserPermissions? permissions,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      profileImage: profileImage ?? this.profileImage,
      permissions: permissions ?? this.permissions,
    );
  }

  // Check if user is admin
  bool get isAdmin => role == 'admin';

  // Check if user is active
  bool get isActive => status == 'active';

  @override
  String toString() {
    return 'UserModel(id: $id, fullName: $fullName, email: $email, role: $role, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class UserPermissions {
  final List<String> documents;
  final List<String> categories;
  final List<String> system;

  UserPermissions({
    required this.documents,
    required this.categories,
    required this.system,
  });

  factory UserPermissions.fromMap(Map<String, dynamic> map) {
    return UserPermissions(
      documents: _parseStringList(map['documents']),
      categories: _parseStringList(map['categories']),
      system: _parseStringList(map['system']),
    );
  }

  // Helper method to safely parse list of strings
  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];

    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }

    if (value is String) {
      return [value];
    }

    return [];
  }

  Map<String, dynamic> toMap() {
    return {'documents': documents, 'categories': categories, 'system': system};
  }

  // Default permissions for admin
  factory UserPermissions.admin() {
    return UserPermissions(
      documents: ['view', 'upload', 'delete', 'approve'],
      categories: [],
      system: ['user_management', 'analytics'],
    );
  }

  // Default permissions for user
  factory UserPermissions.user() {
    return UserPermissions(
      documents: ['view', 'upload'],
      categories: [],
      system: [],
    );
  }

  // Check if user has specific document permission
  bool hasDocumentPermission(String permission) {
    return documents.contains(permission);
  }

  // Check if user has access to specific category
  bool hasCategoryAccess(String categoryId) {
    return categories.contains(categoryId);
  }

  // Check if user has specific system permission
  bool hasSystemPermission(String permission) {
    return system.contains(permission);
  }

  UserPermissions copyWith({
    List<String>? documents,
    List<String>? categories,
    List<String>? system,
  }) {
    return UserPermissions(
      documents: documents ?? this.documents,
      categories: categories ?? this.categories,
      system: system ?? this.system,
    );
  }
}
