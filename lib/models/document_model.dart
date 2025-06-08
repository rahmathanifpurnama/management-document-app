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
  final String status;
  final String? approvedBy;
  final DateTime? approvedAt;
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
    required this.status,
    this.approvedBy,
    this.approvedAt,
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
      status: data['status'] ?? 'pending',
      approvedBy: data['approvedBy'],
      approvedAt: data['approvedAt']?.toDate(),
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
      status: map['status'] ?? 'pending',
      approvedBy: map['approvedBy'],
      approvedAt: map['approvedAt']?.toDate(),
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
      'status': status,
      'approvedBy': approvedBy,
      'approvedAt': approvedAt != null ? Timestamp.fromDate(approvedAt!) : null,
      'permissions': permissions,
      'metadata': metadata.toMap(),
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
      'status': status,
      'approvedBy': approvedBy,
      'approvedAt': approvedAt?.toIso8601String(),
      'permissions': permissions,
      'metadata': metadata.toMap(),
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
      status: map['status'] ?? 'pending',
      approvedBy: map['approvedBy'],
      approvedAt: map['approvedAt'] != null
          ? DateTime.parse(map['approvedAt'])
          : null,
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
    String? status,
    String? approvedBy,
    DateTime? approvedAt,
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
      status: status ?? this.status,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
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

  // Check if document is pending
  bool get isPending => status == 'pending';

  // Check if document is approved
  bool get isApproved => status == 'approved';

  // Check if document is rejected
  bool get isRejected => status == 'rejected';

  // Check if user has permission to access this document
  bool hasPermission(String userId) {
    return permissions.contains(userId) || uploadedBy == userId;
  }

  @override
  String toString() {
    return 'DocumentModel(id: $id, fileName: $fileName, status: $status, category: $category)';
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

  DocumentMetadata({required this.description, required this.tags});

  factory DocumentMetadata.fromMap(Map<String, dynamic> map) {
    return DocumentMetadata(
      description: map['description'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {'description': description, 'tags': tags};
  }

  DocumentMetadata copyWith({String? description, List<String>? tags}) {
    return DocumentMetadata(
      description: description ?? this.description,
      tags: tags ?? this.tags,
    );
  }
}
