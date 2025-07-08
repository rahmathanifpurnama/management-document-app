import 'package:cloud_firestore/cloud_firestore.dart';
import 'document_model.dart';

class RecycleBinModel {
  final String id;
  final String originalDocumentId;
  final DocumentModel originalDocument;
  final String deletedBy;
  final DateTime deletedAt;
  final String originalLocation;
  final String? deleteReason;
  final Map<String, dynamic>? originalMetadata;

  RecycleBinModel({
    required this.id,
    required this.originalDocumentId,
    required this.originalDocument,
    required this.deletedBy,
    required this.deletedAt,
    required this.originalLocation,
    this.deleteReason,
    this.originalMetadata,
  });

  // Factory constructor from Firestore document
  factory RecycleBinModel.fromFirestore(DocumentSnapshot doc) {
    try {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      return RecycleBinModel(
        id: doc.id,
        originalDocumentId: data['originalDocumentId'] ?? '',
        originalDocument: DocumentModel.fromMap(data['originalDocument'] ?? {}),
        deletedBy: data['deletedBy'] ?? '',
        deletedAt:
            (data['deletedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        originalLocation: data['originalLocation'] ?? '',
        deleteReason: data['deleteReason'],
        originalMetadata: data['originalMetadata'],
      );
    } catch (e) {
      throw Exception(
        'Error parsing recycle bin data from Firestore: ${e.toString()}',
      );
    }
  }

  // Factory constructor from Map
  factory RecycleBinModel.fromMap(Map<String, dynamic> map) {
    return RecycleBinModel(
      id: map['id'] ?? '',
      originalDocumentId: map['originalDocumentId'] ?? '',
      originalDocument: DocumentModel.fromMap(map['originalDocument'] ?? {}),
      deletedBy: map['deletedBy'] ?? '',
      deletedAt: map['deletedAt']?.toDate() ?? DateTime.now(),
      originalLocation: map['originalLocation'] ?? '',
      deleteReason: map['deleteReason'],
      originalMetadata: map['originalMetadata'],
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'originalDocumentId': originalDocumentId,
      'originalDocument': originalDocument.toMap(),
      'deletedBy': deletedBy,
      'deletedAt': Timestamp.fromDate(deletedAt),
      'originalLocation': originalLocation,
      'deleteReason': deleteReason,
      'originalMetadata': originalMetadata,
    };
  }

  // Create from existing document for soft delete
  factory RecycleBinModel.fromDocument({
    required DocumentModel document,
    required String deletedBy,
    required String originalLocation,
    String? deleteReason,
  }) {
    return RecycleBinModel(
      id: '', // Will be set by Firestore
      originalDocumentId: document.id,
      originalDocument: document,
      deletedBy: deletedBy,
      deletedAt: DateTime.now(),
      originalLocation: originalLocation,
      deleteReason: deleteReason,
      originalMetadata: {
        'category': document.category,
        'permissions': document.permissions,
        'uploadedBy': document.uploadedBy,
        'uploadedAt': document.uploadedAt.toIso8601String(),
      },
    );
  }

  // Copy with method
  RecycleBinModel copyWith({
    String? id,
    String? originalDocumentId,
    DocumentModel? originalDocument,
    String? deletedBy,
    DateTime? deletedAt,
    String? originalLocation,
    String? deleteReason,
    Map<String, dynamic>? originalMetadata,
  }) {
    return RecycleBinModel(
      id: id ?? this.id,
      originalDocumentId: originalDocumentId ?? this.originalDocumentId,
      originalDocument: originalDocument ?? this.originalDocument,
      deletedBy: deletedBy ?? this.deletedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      originalLocation: originalLocation ?? this.originalLocation,
      deleteReason: deleteReason ?? this.deleteReason,
      originalMetadata: originalMetadata ?? this.originalMetadata,
    );
  }

  // Get display name for the deleted document
  String get displayName => originalDocument.displayFileName;

  // Get file size formatted
  String get formattedFileSize => originalDocument.fileSizeFormatted;

  // Get file type
  String get fileType => originalDocument.fileType;

  // Get days since deletion
  int get daysSinceDeletion => DateTime.now().difference(deletedAt).inDays;

  // Check if can be restored (within 30 days)
  bool get canBeRestored => daysSinceDeletion <= 30;

  @override
  String toString() {
    return 'RecycleBinModel(id: $id, originalDocumentId: $originalDocumentId, deletedBy: $deletedBy, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RecycleBinModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
