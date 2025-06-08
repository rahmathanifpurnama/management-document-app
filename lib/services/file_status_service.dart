import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/document_model.dart';
import '../core/services/firebase_service.dart';
import 'admin_permission_service.dart';

class FileStatusService {
  final FirebaseService _firebaseService = FirebaseService.instance;
  final AdminPermissionService _adminService = AdminPermissionService.instance;

  /// Get all files with pending status or missing metadata
  Future<List<DocumentModel>> getPendingFiles() async {
    // Check admin permissions
    final isAdmin = await _adminService.isCurrentUserAdmin();
    if (!isAdmin) {
      throw Exception('Access denied. Admin privileges required.');
    }

    try {
      // Query for pending files
      final pendingQuery = await _firebaseService.documentsCollection
          .where('status', isEqualTo: 'pending')
          .get();

      // Query for files with missing metadata (empty description)
      final missingMetadataQuery = await _firebaseService.documentsCollection
          .where('metadata.description', isEqualTo: '')
          .get();

      final List<DocumentModel> pendingFiles = [];
      final Set<String> addedIds = <String>{};

      // Add pending files
      for (var doc in pendingQuery.docs) {
        final document = DocumentModel.fromFirestore(doc);
        pendingFiles.add(document);
        addedIds.add(document.id);
      }

      // Add files with missing metadata (avoid duplicates)
      for (var doc in missingMetadataQuery.docs) {
        final document = DocumentModel.fromFirestore(doc);
        if (!addedIds.contains(document.id)) {
          pendingFiles.add(document);
          addedIds.add(document.id);
        }
      }

      // Sort by upload date (newest first)
      pendingFiles.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));

      return pendingFiles;
    } catch (e) {
      throw Exception('Failed to fetch pending files: ${e.toString()}');
    }
  }

  /// Update file status
  Future<void> updateFileStatus(
    String documentId,
    String newStatus,
    String updatedBy,
  ) async {
    // Check admin permissions
    final isAdmin = await _adminService.isCurrentUserAdmin();
    if (!isAdmin) {
      throw Exception('Access denied. Admin privileges required.');
    }

    try {
      final updateData = <String, dynamic>{
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Add approval fields if status is approved
      if (newStatus == 'approved') {
        updateData['approvedBy'] = updatedBy;
        updateData['approvedAt'] = FieldValue.serverTimestamp();
      }

      await _firebaseService.documentsCollection
          .doc(documentId)
          .update(updateData);

      // Log activity
      await _logStatusChangeActivity(documentId, newStatus, updatedBy);
    } catch (e) {
      throw Exception('Failed to update file status: ${e.toString()}');
    }
  }

  /// Get files by status
  Future<List<DocumentModel>> getFilesByStatus(String status) async {
    try {
      final query = await _firebaseService.documentsCollection
          .where('status', isEqualTo: status)
          .orderBy('uploadedAt', descending: true)
          .get();

      return query.docs.map((doc) => DocumentModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch files by status: ${e.toString()}');
    }
  }

  /// Get file status statistics
  Future<Map<String, int>> getStatusStatistics() async {
    try {
      final allDocs = await _firebaseService.documentsCollection.get();

      final Map<String, int> stats = {
        'pending': 0,
        'approved': 0,
        'rejected': 0,
        'active': 0,
        'missing_metadata': 0,
      };

      for (var doc in allDocs.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final status = data['status'] ?? 'unknown';
        final metadata = data['metadata'] as Map<String, dynamic>? ?? {};
        final description = metadata['description'] ?? '';

        // Count by status
        if (stats.containsKey(status)) {
          stats[status] = stats[status]! + 1;
        }

        // Count missing metadata
        if (description.isEmpty) {
          stats['missing_metadata'] = stats['missing_metadata']! + 1;
        }
      }

      return stats;
    } catch (e) {
      throw Exception('Failed to get status statistics: ${e.toString()}');
    }
  }

  /// Bulk update file statuses
  Future<void> bulkUpdateStatus(
    List<String> documentIds,
    String newStatus,
    String updatedBy,
  ) async {
    // Check admin permissions
    final isAdmin = await _adminService.isCurrentUserAdmin();
    if (!isAdmin) {
      throw Exception('Access denied. Admin privileges required.');
    }

    try {
      final batch = _firebaseService.batch;

      for (String documentId in documentIds) {
        final docRef = _firebaseService.documentsCollection.doc(documentId);

        final updateData = <String, dynamic>{
          'status': newStatus,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        if (newStatus == 'approved') {
          updateData['approvedBy'] = updatedBy;
          updateData['approvedAt'] = FieldValue.serverTimestamp();
        }

        batch.update(docRef, updateData);
      }

      await batch.commit();

      // Log bulk activity
      await _logBulkStatusChangeActivity(documentIds, newStatus, updatedBy);
    } catch (e) {
      throw Exception('Failed to bulk update statuses: ${e.toString()}');
    }
  }

  /// Check if file needs metadata processing
  bool needsMetadataProcessing(DocumentModel document) {
    return document.metadata.description.isEmpty ||
        document.metadata.tags.isEmpty ||
        document.status == 'pending';
  }

  /// Get files that need processing
  Future<List<DocumentModel>> getFilesNeedingProcessing() async {
    try {
      final allFiles = await getPendingFiles();
      return allFiles.where(needsMetadataProcessing).toList();
    } catch (e) {
      throw Exception(
        'Failed to get files needing processing: ${e.toString()}',
      );
    }
  }

  /// Log status change activity
  Future<void> _logStatusChangeActivity(
    String documentId,
    String newStatus,
    String userId,
  ) async {
    try {
      await _firebaseService.activitiesCollection.add({
        'type': 'status_change',
        'documentId': documentId,
        'userId': userId,
        'newStatus': newStatus,
        'timestamp': FieldValue.serverTimestamp(),
        'details': 'File status changed to $newStatus',
      });
    } catch (e) {
      // Log error but don't throw - activity logging shouldn't break the main operation
      print('Failed to log status change activity: $e');
    }
  }

  /// Log bulk status change activity
  Future<void> _logBulkStatusChangeActivity(
    List<String> documentIds,
    String newStatus,
    String userId,
  ) async {
    try {
      await _firebaseService.activitiesCollection.add({
        'type': 'bulk_status_change',
        'documentIds': documentIds,
        'userId': userId,
        'newStatus': newStatus,
        'timestamp': FieldValue.serverTimestamp(),
        'details':
            'Bulk status change: ${documentIds.length} files changed to $newStatus',
      });
    } catch (e) {
      // Log error but don't throw - activity logging shouldn't break the main operation
      print('Failed to log bulk status change activity: $e');
    }
  }
}
