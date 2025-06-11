import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../services/firebase_service.dart';
import '../config/anr_config.dart';
import '../utils/anr_prevention.dart';
import '../../models/activity_model.dart';
import 'optimized_network_service.dart';
import '../../models/document_model.dart';

class DocumentService {
  static DocumentService? _instance;
  static DocumentService get instance => _instance ??= DocumentService._();

  DocumentService._();

  final FirebaseService _firebaseService = FirebaseService.instance;

  // HIGH PRIORITY: Get all documents with pagination and optimization
  Future<List<DocumentModel>> getAllDocuments({
    int? limit,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      final networkService = OptimizedNetworkService.instance;

      // CRITICAL FIX: Optimized query with proper timeout and error handling
      final querySnapshot = await networkService.executeFirestoreOperation(
        () async {
          Query query = _firebaseService.documentsCollection
              .where('isActive', isEqualTo: true)
              .orderBy('uploadedAt', descending: true);

          if (startAfter != null) {
            query = query.startAfterDocument(startAfter);
          }

          // PERFORMANCE FIX: Use smaller page sizes to prevent ANR
          final effectiveLimit =
              limit ?? ANRConfig.smallPageSize; // Use smaller default
          query = query.limit(effectiveLimit);

          return await query.get();
        },
        operationId:
            'get_all_documents_${DateTime.now().millisecondsSinceEpoch}',
        operationName: 'Get All Documents',
        priority: 3,
      );

      if (querySnapshot == null) {
        debugPrint('⚠️ Failed to fetch documents - query timeout');
        return [];
      }

      // Process documents in batches to prevent ANR
      final documents = <DocumentModel>[];
      await ANRPrevention.batchProcess(
        querySnapshot.docs,
        (doc) async {
          try {
            return DocumentModel.fromFirestore(doc);
          } catch (e) {
            debugPrint('❌ Error parsing document ${doc.id}: $e');
            return null;
          }
        },
        batchSize: ANRConfig.smallBatchSize,
        operationName: 'Document Parsing',
      ).then((results) {
        documents.addAll(
          results.where((doc) => doc != null).cast<DocumentModel>(),
        );
      });

      return documents;
    } catch (e) {
      debugPrint('❌ Failed to fetch documents: $e');
      return [];
    }
  }

  // Get document by ID
  Future<DocumentModel?> getDocumentById(String documentId) async {
    try {
      DocumentSnapshot doc = await _firebaseService.documentsCollection
          .doc(documentId)
          .get();

      if (doc.exists) {
        return DocumentModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get document: ${e.toString()}');
    }
  }

  // Add document
  Future<String> addDocument(DocumentModel document) async {
    try {
      DocumentReference docRef = await _firebaseService.documentsCollection.add(
        document.toMap(),
      );

      // Log activity
      await _logActivity(
        document.uploadedBy,
        ActivityType.upload,
        'Document: ${document.fileName}',
      );

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add document: ${e.toString()}');
    }
  }

  // CRITICAL FIX: Add document without activity logging (for sync operations)
  Future<String> addDocumentSilent(DocumentModel document) async {
    try {
      DocumentReference docRef = await _firebaseService.documentsCollection.add(
        document.toMap(),
      );

      debugPrint(
        '✅ Document added silently (no activity log): ${document.fileName}',
      );
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add document silently: ${e.toString()}');
    }
  }

  // Update document
  Future<void> updateDocument(DocumentModel document) async {
    try {
      await _firebaseService.documentsCollection
          .doc(document.id)
          .update(document.toMap());
    } catch (e) {
      throw Exception('Failed to update document: ${e.toString()}');
    }
  }

  // Delete document permanently (from both Firestore and Storage)
  Future<void> deleteDocument(String documentId, String deletedBy) async {
    try {
      // Get document data first
      DocumentModel? document = await getDocumentById(documentId);

      if (document == null) {
        throw Exception('Document not found');
      }

      // Delete from Firebase Storage if filePath exists
      if (document.filePath.isNotEmpty) {
        try {
          // Create storage reference from file path
          Reference storageRef = _firebaseService.storage.ref().child(
            document.filePath,
          );
          await storageRef.delete();
        } catch (storageError) {
          // Log storage deletion error but continue with Firestore deletion
          // Warning: Failed to delete file from storage, but continue with Firestore deletion
          // Don't throw here, continue with Firestore deletion
        }
      }

      // Delete from Firestore
      await _firebaseService.documentsCollection.doc(documentId).delete();

      // Log activity
      await _logActivity(
        deletedBy,
        ActivityType.delete,
        'Document: ${document.fileName}',
      );
    } catch (e) {
      throw Exception('Failed to delete document: ${e.toString()}');
    }
  }

  // Delete document from storage only (for cleanup)
  Future<void> deleteDocumentFromStorage(String filePath) async {
    try {
      if (filePath.isNotEmpty) {
        Reference storageRef = _firebaseService.storage.ref().child(filePath);
        await storageRef.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete file from storage: ${e.toString()}');
    }
  }

  // Get documents by category with optimized pagination
  Future<List<DocumentModel>> getDocumentsByCategory(
    String categoryId, {
    int? limit,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      final networkService = OptimizedNetworkService.instance;

      final querySnapshot = await networkService.executeFirestoreOperation(
        () async {
          Query query = _firebaseService.documentsCollection
              .where('isActive', isEqualTo: true) // Add isActive filter
              .where('category', isEqualTo: categoryId)
              .orderBy('uploadedAt', descending: true);

          if (startAfter != null) {
            query = query.startAfterDocument(startAfter);
          }

          // Use pagination to prevent ANR
          final effectiveLimit = limit ?? ANRConfig.defaultPageSize;
          query = query.limit(effectiveLimit);

          return await query.get();
        },
        operationId:
            'get_category_documents_${DateTime.now().millisecondsSinceEpoch}',
        operationName: 'Get Documents by Category',
        priority: 3,
      );

      if (querySnapshot == null) {
        debugPrint('⚠️ Failed to fetch category documents - query timeout');
        return [];
      }

      return querySnapshot.docs
          .map((doc) => DocumentModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('❌ Error getting documents by category: $e');
      throw Exception('Failed to get documents by category: ${e.toString()}');
    }
  }

  // Get documents by user
  Future<List<DocumentModel>> getDocumentsByUser(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firebaseService.documentsCollection
          .where('uploadedBy', isEqualTo: userId)
          .orderBy('uploadedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => DocumentModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get documents by user: ${e.toString()}');
    }
  }

  // Update document category
  Future<void> updateDocumentCategory(
    String documentId,
    String newCategoryId,
  ) async {
    try {
      await _firebaseService.documentsCollection.doc(documentId).update({
        'category': newCategoryId,
      });
    } catch (e) {
      throw Exception('Failed to update document category: ${e.toString()}');
    }
  }

  // Status update method removed since status management is removed

  // Search documents with optimized pagination and ANR prevention
  Future<List<DocumentModel>> searchDocuments(
    String query, {
    int? limit,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      final networkService = OptimizedNetworkService.instance;

      final querySnapshot = await networkService.executeFirestoreOperation(
        () async {
          Query searchQuery = _firebaseService.documentsCollection
              .where(
                'isActive',
                isEqualTo: true,
              ) // Only search active documents
              .where('fileName', isGreaterThanOrEqualTo: query)
              .where('fileName', isLessThanOrEqualTo: '$query\uf8ff')
              .orderBy('fileName')
              .orderBy('uploadedAt', descending: true);

          if (startAfter != null) {
            searchQuery = searchQuery.startAfterDocument(startAfter);
          }

          // Use pagination to prevent ANR
          final effectiveLimit = limit ?? ANRConfig.defaultPageSize;
          searchQuery = searchQuery.limit(effectiveLimit);

          return await searchQuery.get();
        },
        operationId:
            'search_documents_${DateTime.now().millisecondsSinceEpoch}',
        operationName: 'Search Documents',
        priority: 3,
      );

      if (querySnapshot == null) {
        debugPrint('⚠️ Failed to search documents - query timeout');
        return [];
      }

      return querySnapshot.docs
          .map((doc) => DocumentModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('❌ Error searching documents: $e');
      throw Exception('Failed to search documents: ${e.toString()}');
    }
  }

  // Get recent documents with optimized query and ANR prevention
  Future<List<DocumentModel>> getRecentDocuments({
    int limit = 10,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      final networkService = OptimizedNetworkService.instance;

      final querySnapshot = await networkService.executeFirestoreOperation(
        () async {
          Query query = _firebaseService.documentsCollection
              .where('isActive', isEqualTo: true) // Only get active documents
              .orderBy('uploadedAt', descending: true);

          if (startAfter != null) {
            query = query.startAfterDocument(startAfter);
          }

          // Limit to prevent ANR
          final effectiveLimit = limit > ANRConfig.maxItemsPerPage
              ? ANRConfig.maxItemsPerPage
              : limit;
          query = query.limit(effectiveLimit);

          return await query.get();
        },
        operationId:
            'get_recent_documents_${DateTime.now().millisecondsSinceEpoch}',
        operationName: 'Get Recent Documents',
        priority: 3,
      );

      if (querySnapshot == null) {
        debugPrint('⚠️ Failed to fetch recent documents - query timeout');
        return [];
      }

      return querySnapshot.docs
          .map((doc) => DocumentModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('❌ Error getting recent documents: $e');
      throw Exception('Failed to get recent documents: ${e.toString()}');
    }
  }

  // Log activity
  Future<void> _logActivity(
    String userId,
    ActivityType action,
    String resource,
  ) async {
    try {
      ActivityModel activity = ActivityModel(
        id: '',
        userId: userId,
        action: action.value,
        resource: resource,
        timestamp: DateTime.now(),
        details: {'userAgent': 'Flutter App', 'platform': 'Mobile'},
      );

      await _firebaseService.activitiesCollection.add(activity.toMap());
    } catch (e) {
      // Don't throw error for activity logging
      // Failed to log activity, but continue execution
      debugPrint('Failed to log activity: $e');
    }
  }
}
