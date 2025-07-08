import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteModel {
  final String id;
  final String userId;
  final String folderPath;
  final String folderName;
  final String? categoryId;
  final DateTime addedAt;
  final String? description;
  final Map<String, dynamic>? metadata;

  FavoriteModel({
    required this.id,
    required this.userId,
    required this.folderPath,
    required this.folderName,
    this.categoryId,
    required this.addedAt,
    this.description,
    this.metadata,
  });

  // Factory constructor from Firestore document
  factory FavoriteModel.fromFirestore(DocumentSnapshot doc) {
    try {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      return FavoriteModel(
        id: doc.id,
        userId: data['userId'] ?? '',
        folderPath: data['folderPath'] ?? '',
        folderName: data['folderName'] ?? '',
        categoryId: data['categoryId'],
        addedAt: (data['addedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        description: data['description'],
        metadata: data['metadata'],
      );
    } catch (e) {
      throw Exception(
        'Error parsing favorite data from Firestore: ${e.toString()}',
      );
    }
  }

  // Factory constructor from Map
  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      folderPath: map['folderPath'] ?? '',
      folderName: map['folderName'] ?? '',
      categoryId: map['categoryId'],
      addedAt: map['addedAt']?.toDate() ?? DateTime.now(),
      description: map['description'],
      metadata: map['metadata'],
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'folderPath': folderPath,
      'folderName': folderName,
      'categoryId': categoryId,
      'addedAt': Timestamp.fromDate(addedAt),
      'description': description,
      'metadata': metadata,
    };
  }

  // Create new favorite
  factory FavoriteModel.create({
    required String userId,
    required String folderPath,
    required String folderName,
    String? categoryId,
    String? description,
    Map<String, dynamic>? metadata,
  }) {
    return FavoriteModel(
      id: '', // Will be set by Firestore
      userId: userId,
      folderPath: folderPath,
      folderName: folderName,
      categoryId: categoryId,
      addedAt: DateTime.now(),
      description: description,
      metadata: metadata ?? {'createdFrom': 'mobile_app', 'version': '1.0'},
    );
  }

  // Copy with method
  FavoriteModel copyWith({
    String? id,
    String? userId,
    String? folderPath,
    String? folderName,
    String? categoryId,
    DateTime? addedAt,
    String? description,
    Map<String, dynamic>? metadata,
  }) {
    return FavoriteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      folderPath: folderPath ?? this.folderPath,
      folderName: folderName ?? this.folderName,
      categoryId: categoryId ?? this.categoryId,
      addedAt: addedAt ?? this.addedAt,
      description: description ?? this.description,
      metadata: metadata ?? this.metadata,
    );
  }

  // Get display name (folder name or last part of path)
  String get displayName {
    if (folderName.isNotEmpty) return folderName;
    return folderPath.split('/').last;
  }

  // Get formatted date
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(addedAt);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    }
  }

  // Get folder depth (number of levels in path)
  int get folderDepth =>
      folderPath.split('/').where((part) => part.isNotEmpty).length;

  // Check if this is a root folder
  bool get isRootFolder => folderDepth <= 1;

  // Get parent folder path
  String get parentFolderPath {
    final parts = folderPath
        .split('/')
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.length <= 1) return '/';
    return '/${parts.sublist(0, parts.length - 1).join('/')}';
  }

  @override
  String toString() {
    return 'FavoriteModel(id: $id, userId: $userId, folderPath: $folderPath, folderName: $folderName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoriteModel &&
        other.id == id &&
        other.userId == userId &&
        other.folderPath == folderPath;
  }

  @override
  int get hashCode => Object.hash(id, userId, folderPath);
}
