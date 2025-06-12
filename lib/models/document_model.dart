import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentModel {
  final String id;
  final String fileName;
  final int fileSize;
  final String fileType;
  final String filePath;
  final String uploadedBy;
  final DateTime uploadedAt;
  final String category;
  final List<String> permissions;
  final DocumentMetadata metadata;

  DocumentModel({
    required this.id,
    required this.fileName,
    required this.fileSize,
    required this.fileType,
    required this.filePath,
    required this.uploadedBy,
    required this.uploadedAt,
    required this.category,
    required this.permissions,
    required this.metadata,
  });

  // Factory constructor from Firestore document
  factory DocumentModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return DocumentModel(
      id: doc.id,
      fileName: data['fileName'] ?? '',
      fileSize: data['fileSize'] ?? 0,
      fileType: data['fileType'] ?? '',
      filePath: data['filePath'] ?? '',
      uploadedBy: data['uploadedBy'] ?? '',
      uploadedAt: data['uploadedAt']?.toDate() ?? DateTime.now(),
      category: data['category'] ?? '',
      permissions: List<String>.from(data['permissions'] ?? []),
      metadata: DocumentMetadata.fromMap(data['metadata'] ?? {}),
    );
  }

  // Factory constructor from Map
  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['id'] ?? '',
      fileName: map['fileName'] ?? '',
      fileSize: map['fileSize'] ?? 0,
      fileType: map['fileType'] ?? '',
      filePath: map['filePath'] ?? '',
      uploadedBy: map['uploadedBy'] ?? '',
      uploadedAt: map['uploadedAt']?.toDate() ?? DateTime.now(),
      category: map['category'] ?? '',
      permissions: List<String>.from(map['permissions'] ?? []),
      metadata: DocumentMetadata.fromMap(map['metadata'] ?? {}),
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'fileName': fileName,
      'fileSize': fileSize,
      'fileType': fileType,
      'filePath': filePath,
      'uploadedBy': uploadedBy,
      'uploadedAt': Timestamp.fromDate(uploadedAt),
      'category': category,
      'permissions': permissions,
      'metadata': metadata.toMap(),
      'isActive': true, // All files are active by default
    };
  }

  // Convert to Map for local storage (using String for DateTime)
  Map<String, dynamic> toMapForStorage() {
    return {
      'id': id,
      'fileName': fileName,
      'fileSize': fileSize,
      'fileType': fileType,
      'filePath': filePath,
      'uploadedBy': uploadedBy,
      'uploadedAt': uploadedAt.toIso8601String(),
      'category': category,
      'permissions': permissions,
      'metadata': metadata.toMap(),
      'isActive': true, // All files are active by default
    };
  }

  // Factory constructor from Map for local storage
  factory DocumentModel.fromMapForStorage(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['id'] ?? '',
      fileName: map['fileName'] ?? '',
      fileSize: map['fileSize'] ?? 0,
      fileType: map['fileType'] ?? '',
      filePath: map['filePath'] ?? '',
      uploadedBy: map['uploadedBy'] ?? '',
      uploadedAt: map['uploadedAt'] != null
          ? DateTime.parse(map['uploadedAt'])
          : DateTime.now(),
      category: map['category'] ?? '',
      permissions: List<String>.from(map['permissions'] ?? []),
      metadata: DocumentMetadata.fromMap(map['metadata'] ?? {}),
    );
  }

  // Copy with method
  DocumentModel copyWith({
    String? id,
    String? fileName,
    int? fileSize,
    String? fileType,
    String? filePath,
    String? uploadedBy,
    DateTime? uploadedAt,
    String? category,
    List<String>? permissions,
    DocumentMetadata? metadata,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      fileType: fileType ?? this.fileType,
      filePath: filePath ?? this.filePath,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      category: category ?? this.category,
      permissions: permissions ?? this.permissions,
      metadata: metadata ?? this.metadata,
    );
  }

  // Get file size in readable format
  String get fileSizeFormatted {
    if (fileSize < 1024) {
      return '$fileSize bytes';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    } else if (fileSize < 1024 * 1024 * 1024) {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(fileSize / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  // Get file extension
  String get fileExtension {
    return fileName.split('.').last.toLowerCase();
  }

  // Check if user has permission to access this document
  bool hasPermission(String userId) {
    return permissions.contains(userId) || uploadedBy == userId;
  }

  @override
  String toString() {
    return 'DocumentModel(id: $id, fileName: $fileName, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DocumentModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class DocumentMetadata {
  final String description;
  final List<String> tags;
  final String version;
  final String? contentType;
  final String? downloadUrl;

  DocumentMetadata({
    required this.description,
    required this.tags,
    this.version = '1.0',
    this.contentType,
    this.downloadUrl,
  });

  factory DocumentMetadata.fromMap(Map<String, dynamic> map) {
    return DocumentMetadata(
      description: map['description'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      version: map['version'] ?? '1.0',
      contentType: map['contentType'],
      downloadUrl: map['downloadUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'tags': tags,
      'version': version,
      'contentType': contentType,
      'downloadUrl': downloadUrl,
    };
  }

  DocumentMetadata copyWith({
    String? description,
    List<String>? tags,
    String? version,
    String? contentType,
    String? downloadUrl,
  }) {
    return DocumentMetadata(
      description: description ?? this.description,
      tags: tags ?? this.tags,
      version: version ?? this.version,
      contentType: contentType ?? this.contentType,
      downloadUrl: downloadUrl ?? this.downloadUrl,
    );
  }
}
