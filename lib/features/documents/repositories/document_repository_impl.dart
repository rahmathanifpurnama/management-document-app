import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../models/document_model.dart';
import '../../../core/services/document_service.dart';
import '../../../services/enhanced_document_service.dart';
import '../../../services/enhanced_firebase_storage_service.dart';
import '../../../services/cloud_functions_service.dart';
import '../../../services/activity_service.dart';
import '../../../core/services/firebase_service.dart';
import '../../../config/firebase_config.dart';
import 'document_repository.dart';

/// Implementation of DocumentRepository
///
/// This class implements the DocumentRepository interface using existing services
/// from the DocumentProvider. It provides a clean abstraction layer for the BLoC.
class DocumentRepositoryImpl implements DocumentRepository {
  // Singleton pattern
  static DocumentRepositoryImpl? _instance;
  static DocumentRepositoryImpl get instance =>
      _instance ??= DocumentRepositoryImpl._();

  DocumentRepositoryImpl._();

  // Services
  final DocumentService _documentService = DocumentService.instance;
  final EnhancedDocumentService _enhancedDocumentService =
      EnhancedDocumentService.instance;
  final EnhancedFirebaseStorageService _storageService =
      EnhancedFirebaseStorageService.instance;
  final CloudFunctionsService _cloudFunctions = CloudFunctionsService.instance;
  final ActivityService _activityService = ActivityService();
  final FirebaseService _firebaseService = FirebaseService.instance;

  // Stream controller for real-time updates
  StreamController<List<DocumentModel>>? _documentsStreamController;
  StreamSubscription<QuerySnapshot>? _firestoreSubscription;

  @override
  Future<List<DocumentModel>> getAllDocuments({
    int? limit,
    DocumentModel? startAfter,
  }) async {
    try {
      debugPrint(
        '📄 DocumentRepository: Getting all documents (limit: $limit)',
      );

      // Use enhanced service for unlimited queries if available
      if (limit == null || limit > FirebaseConfig.batchSize) {
        final canUnlimited =
            await _enhancedDocumentService.canPerformUnlimitedQueries;
        if (canUnlimited) {
          return await _enhancedDocumentService.getAllDocumentsUnlimited();
        }
      }

      // Use regular document service for limited queries
      return await _documentService.getAllDocuments(
        limit: limit,
        startAfter: startAfter != null
            ? await _getDocumentSnapshot(startAfter.id)
            : null,
      );
    } catch (e) {
      debugPrint('❌ DocumentRepository: Error getting all documents: $e');
      rethrow;
    }
  }

  @override
  Future<DocumentModel?> getDocumentById(String id) async {
    try {
      debugPrint('📄 DocumentRepository: Getting document by ID: $id');
      return await _documentService.getDocumentById(id);
    } catch (e) {
      debugPrint('❌ DocumentRepository: Error getting document by ID: $e');
      return null;
    }
  }

  @override
  Future<bool> deleteDocument(String id, String userId) async {
    try {
      debugPrint('🗑️ DocumentRepository: Deleting document: $id');

      // Use cloud functions for deletion
      final result = await _cloudFunctions.deleteDocument(id);

      if (result['success'] == true) {
        // Log activity
        await _activityService.logActivity(
          type: 'delete',
          description: 'Document moved to recycle bin',
          documentId: id,
        );
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('❌ DocumentRepository: Error deleting document: $e');
      return false;
    }
  }

  @override
  Future<bool> permanentlyDeleteDocument(String id, String userId) async {
    try {
      debugPrint('🗑️ DocumentRepository: Permanently deleting document: $id');

      // Use bulk operations for permanent deletion
      final result = await _cloudFunctions.bulkDocumentOperations(
        operation: 'permanent_delete',
        documentIds: [id],
        reason: 'Permanent deletion by user $userId',
      );

      if (result['success'] == true) {
        // Log activity
        await _activityService.logActivity(
          type: 'permanent_delete',
          description: 'Document permanently deleted',
          documentId: id,
        );
        return true;
      }

      return false;
    } catch (e) {
      debugPrint(
        '❌ DocumentRepository: Error permanently deleting document: $e',
      );
      return false;
    }
  }

  @override
  Future<bool> restoreDocument(String id, String userId) async {
    try {
      debugPrint('♻️ DocumentRepository: Restoring document: $id');

      // Use bulk operations for restoration
      final result = await _cloudFunctions.bulkDocumentOperations(
        operation: 'restore',
        documentIds: [id],
        reason: 'Document restoration by user $userId',
      );

      if (result['success'] == true) {
        // Log activity
        await _activityService.logActivity(
          type: 'restore',
          description: 'Document restored from recycle bin',
          documentId: id,
        );
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('❌ DocumentRepository: Error restoring document: $e');
      return false;
    }
  }

  @override
  Future<bool> updateDocument(DocumentModel document) async {
    try {
      debugPrint('📝 DocumentRepository: Updating document: ${document.id}');

      // Update document in Firestore
      await _firebaseService.documentsCollection
          .doc(document.id)
          .update(document.toMap());

      // Log activity
      await _activityService.logActivity(
        type: 'edit',
        description: 'Document updated',
        documentId: document.id,
        additionalData: {'fileName': document.fileName},
      );

      return true;
    } catch (e) {
      debugPrint('❌ DocumentRepository: Error updating document: $e');
      return false;
    }
  }

  @override
  Stream<List<DocumentModel>> watchDocuments() {
    debugPrint('👁️ DocumentRepository: Starting real-time document watching');

    _documentsStreamController?.close();
    _documentsStreamController =
        StreamController<List<DocumentModel>>.broadcast();

    _firestoreSubscription?.cancel();
    _firestoreSubscription = _firebaseService.documentsCollection
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            try {
              final documents = snapshot.docs
                  .map((doc) => DocumentModel.fromFirestore(doc))
                  .toList();

              _documentsStreamController?.add(documents);
              debugPrint(
                '👁️ DocumentRepository: Real-time update - ${documents.length} documents',
              );
            } catch (e) {
              debugPrint('❌ DocumentRepository: Error in real-time update: $e');
              _documentsStreamController?.addError(e);
            }
          },
          onError: (error) {
            debugPrint('❌ DocumentRepository: Real-time stream error: $error');
            _documentsStreamController?.addError(error);
          },
        );

    return _documentsStreamController!.stream;
  }

  @override
  Future<List<DocumentModel>> searchDocuments(
    String query, {
    int? limit,
  }) async {
    try {
      debugPrint('🔍 DocumentRepository: Searching documents: "$query"');

      if (query.isEmpty) {
        return await getAllDocuments(limit: limit);
      }

      // Get all documents and filter locally
      // Note: Firestore doesn't support full-text search natively
      final allDocuments = await getAllDocuments();
      final searchQuery = query.toLowerCase();

      final filteredDocuments = allDocuments.where((doc) {
        return doc.fileName.toLowerCase().contains(searchQuery) ||
            doc.category.toLowerCase().contains(searchQuery) ||
            (doc.searchTerms?.any(
                  (term) => term.toLowerCase().contains(searchQuery),
                ) ??
                false);
      }).toList();

      if (limit != null && filteredDocuments.length > limit) {
        return filteredDocuments.take(limit).toList();
      }

      return filteredDocuments;
    } catch (e) {
      debugPrint('❌ DocumentRepository: Error searching documents: $e');
      return [];
    }
  }

  @override
  Future<List<DocumentModel>> filterDocuments({
    String? category,
    String? status,
    String? fileType,
    String? userId,
    bool? isDeleted,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      debugPrint('🔍 DocumentRepository: Filtering documents');

      // Start with base query
      Query query = _firebaseService.documentsCollection;

      // Apply filters
      if (category != null && category != 'all') {
        query = query.where('category', isEqualTo: category);
      }

      if (fileType != null && fileType != 'all') {
        query = query.where('fileType', isEqualTo: fileType);
      }

      if (userId != null) {
        query = query.where('uploadedBy', isEqualTo: userId);
      }

      if (isDeleted != null) {
        query = query.where('isDeleted', isEqualTo: isDeleted);
      }

      if (startDate != null) {
        query = query.where('uploadedAt', isGreaterThanOrEqualTo: startDate);
      }

      if (endDate != null) {
        query = query.where('uploadedAt', isLessThanOrEqualTo: endDate);
      }

      // Execute query
      final snapshot = await query
          .orderBy('uploadedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => DocumentModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('❌ DocumentRepository: Error filtering documents: $e');
      return [];
    }
  }

  @override
  Future<List<DocumentModel>> getRecentDocuments({int? limit}) async {
    try {
      debugPrint('📅 DocumentRepository: Getting recent documents');

      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

      return await filterDocuments(startDate: sevenDaysAgo, isDeleted: false);
    } catch (e) {
      debugPrint('❌ DocumentRepository: Error getting recent documents: $e');
      return [];
    }
  }

  @override
  Future<List<DocumentModel>> getDeletedDocuments({int? limit}) async {
    try {
      debugPrint('🗑️ DocumentRepository: Getting deleted documents');

      return await filterDocuments(isDeleted: true);
    } catch (e) {
      debugPrint('❌ DocumentRepository: Error getting deleted documents: $e');
      return [];
    }
  }

  @override
  Future<List<DocumentModel>> getDocumentsByCategory(
    String category, {
    int? limit,
  }) async {
    try {
      debugPrint(
        '📁 DocumentRepository: Getting documents by category: $category',
      );

      return await filterDocuments(category: category, isDeleted: false);
    } catch (e) {
      debugPrint(
        '❌ DocumentRepository: Error getting documents by category: $e',
      );
      return [];
    }
  }

  @override
  Future<List<DocumentModel>> getDocumentsByUser(
    String userId, {
    int? limit,
  }) async {
    try {
      debugPrint('👤 DocumentRepository: Getting documents by user: $userId');

      return await filterDocuments(userId: userId, isDeleted: false);
    } catch (e) {
      debugPrint('❌ DocumentRepository: Error getting documents by user: $e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> getDocumentStatistics() async {
    try {
      debugPrint('📊 DocumentRepository: Getting document statistics');

      final allDocuments = await getAllDocuments();
      final deletedDocuments = allDocuments
          .where((doc) => doc.isDeleted)
          .toList();
      final activeDocuments = allDocuments
          .where((doc) => !doc.isDeleted)
          .toList();
      final recentDocuments = activeDocuments
          .where((doc) => doc.isRecent)
          .toList();

      // Calculate file type distribution
      final fileTypeCount = <String, int>{};
      for (final doc in activeDocuments) {
        fileTypeCount[doc.fileType] = (fileTypeCount[doc.fileType] ?? 0) + 1;
      }

      // Calculate category distribution
      final categoryCount = <String, int>{};
      for (final doc in activeDocuments) {
        final category = doc.category.isEmpty ? 'uncategorized' : doc.category;
        categoryCount[category] = (categoryCount[category] ?? 0) + 1;
      }

      // Calculate total file size
      final totalSize = activeDocuments.fold<int>(
        0,
        (total, doc) => total + doc.fileSize,
      );

      return {
        'totalDocuments': allDocuments.length,
        'activeDocuments': activeDocuments.length,
        'deletedDocuments': deletedDocuments.length,
        'recentDocuments': recentDocuments.length,
        'totalFileSize': totalSize,
        'fileTypeDistribution': fileTypeCount,
        'categoryDistribution': categoryCount,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('❌ DocumentRepository: Error getting statistics: $e');
      return {
        'error': e.toString(),
        'lastUpdated': DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  Future<List<DocumentModel>> refreshDocuments({
    bool forceRefresh = false,
  }) async {
    try {
      debugPrint(
        '🔄 DocumentRepository: Refreshing documents (force: $forceRefresh)',
      );

      if (forceRefresh) {
        // Use cloud functions for comprehensive refresh
        await _cloudFunctions.syncStorageWithFirestore();
      }

      return await getAllDocuments();
    } catch (e) {
      debugPrint('❌ DocumentRepository: Error refreshing documents: $e');
      rethrow;
    }
  }

  @override
  Future<bool> documentExists(String id) async {
    try {
      debugPrint('🔍 DocumentRepository: Checking if document exists: $id');

      final doc = await _firebaseService.documentsCollection.doc(id).get();
      return doc.exists;
    } catch (e) {
      debugPrint('❌ DocumentRepository: Error checking document existence: $e');
      return false;
    }
  }

  @override
  Future<int> getDocumentCount({bool includeDeleted = false}) async {
    try {
      debugPrint(
        '🔢 DocumentRepository: Getting document count (includeDeleted: $includeDeleted)',
      );

      if (includeDeleted) {
        final allDocuments = await getAllDocuments();
        return allDocuments.length;
      } else {
        final activeDocuments = await filterDocuments(isDeleted: false);
        return activeDocuments.length;
      }
    } catch (e) {
      debugPrint('❌ DocumentRepository: Error getting document count: $e');
      return 0;
    }
  }

  @override
  Future<bool> syncDocuments() async {
    try {
      debugPrint(
        '🔄 DocumentRepository: Syncing documents with external sources',
      );

      // Use cloud functions for synchronization
      final result = await _cloudFunctions.syncStorageWithFirestore();

      if (result['success'] == true) {
        // Log activity
        await _activityService.logActivity(
          type: 'sync',
          description: 'Documents synchronized with external sources',
          additionalData: result,
        );
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('❌ DocumentRepository: Error syncing documents: $e');
      return false;
    }
  }

  @override
  Future<bool> bulkDeleteDocuments(
    List<String> documentIds,
    String userId,
  ) async {
    try {
      debugPrint(
        '🗑️ DocumentRepository: Bulk deleting ${documentIds.length} documents',
      );

      // Use cloud functions for bulk deletion
      final result = await _cloudFunctions.bulkDocumentOperations(
        operation: 'delete',
        documentIds: documentIds,
        reason: 'Bulk deletion by user $userId',
      );

      if (result['success'] == true) {
        // Log activity for bulk deletion
        await _activityService.logActivity(
          type: 'bulk_delete',
          description: 'Bulk deleted ${documentIds.length} documents',
          additionalData: {
            'documentIds': documentIds,
            'userId': userId,
            'count': documentIds.length,
          },
        );
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('❌ DocumentRepository: Error bulk deleting documents: $e');
      return false;
    }
  }

  /// Helper method to get document snapshot for pagination
  Future<DocumentSnapshot?> _getDocumentSnapshot(String documentId) async {
    try {
      return await _firebaseService.documentsCollection.doc(documentId).get();
    } catch (e) {
      debugPrint('❌ DocumentRepository: Error getting document snapshot: $e');
      return null;
    }
  }

  /// Dispose resources
  void dispose() {
    _documentsStreamController?.close();
    _firestoreSubscription?.cancel();
  }
}
