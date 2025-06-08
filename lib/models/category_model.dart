import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String name;
  final String description;
  final String createdBy;
  final DateTime createdAt;
  final List<String> permissions;
  final bool isActive;
  final int? documentCount;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    required this.permissions,
    required this.isActive,
    this.documentCount,
  });

  // Factory constructor from Firestore document
  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      createdBy: data['createdBy'] ?? '',
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
      permissions: List<String>.from(data['permissions'] ?? []),
      isActive: data['isActive'] ?? true,
      documentCount: data['documentCount'],
    );
  }

  // Factory constructor from Map
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      createdBy: map['createdBy'] ?? '',
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      permissions: List<String>.from(map['permissions'] ?? []),
      isActive: map['isActive'] ?? true,
      documentCount: map['documentCount'],
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'permissions': permissions,
      'isActive': isActive,
      'documentCount': documentCount ?? 0,
    };
  }

  // Copy with method
  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? createdBy,
    DateTime? createdAt,
    List<String>? permissions,
    bool? isActive,
    int? documentCount,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      permissions: permissions ?? this.permissions,
      isActive: isActive ?? this.isActive,
      documentCount: documentCount ?? this.documentCount,
    );
  }

  // Check if user has permission to access this category
  bool hasPermission(String userId) {
    return permissions.contains(userId) || createdBy == userId;
  }

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
