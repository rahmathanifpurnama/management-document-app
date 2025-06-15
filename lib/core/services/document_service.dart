import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../services/firebase_service.dart';
import '../config/anr_config.dart';
import '../../config/firebase_config.dart';
import '../utils/anr_prevention.dart';
import '../../models/activity_model.dart';
import 'optimized_network_service.dart';
import '../../models/document_model.dart';
import '../../services/document_id_generator.dart';

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

          // ENTERPRISE SCALE: Support unlimited queries for enterprise mode
          if (limit != null) {
            query = query.limit(limit);
          } else if (!FirebaseConfig.shouldEnableUnlimitedFiles) {
            // Apply default limit only if not in enterprise mode
            query = query.limit(ANRConfig.defaultPageSize);
          }
          // No limit applied for enterprise mode when limit is null

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

      debugPrint(
        '📊 DocumentService: Query returned ${querySnapshot.docs.length} raw documents',
      );

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

      debugPrint(
        '✅ DocumentService: Successfully parsed ${documents.length} documents',
      );

      if (documents.isEmpty) {
        debugPrint(
          '⚠️ DocumentService: No documents found in Firestore collection',
        );
      } else {
        debugPrint(
          '📋 DocumentService: Latest document: ${documents.first.fileName}',
        );
      }

      return documents;
    } catch (e) {
      debugPrint('❌ Failed to fetch documents: $e');
      return [];
    }
  }

  // Get document by ID with enhanced resolution for legacy document IDs
  Future<DocumentModel?> getDocumentById(String documentId) async {
    try {
      debugPrint('🔍 Searching for document with ID: $documentId');

      // First, try direct lookup
      DocumentSnapshot doc = await _firebaseService.documentsCollection
          .doc(documentId)
          .get();

      if (doc.exists) {
        debugPrint('✅ Document found with direct lookup: $documentId');
        return DocumentModel.fromFirestore(doc);
      }

      debugPrint(
        '⚠️ Document not found with direct lookup, trying alternative strategies...',
      );

      // If direct lookup fails, try to find document using alternative ID strategies
      return await _findDocumentWithAlternativeIds(documentId);
    } catch (e) {
      debugPrint('❌ Error in getDocumentById: $e');
      throw Exception('Failed to get document: ${e.toString()}');
    }
  }

  // Enhanced document resolution using multiple ID generation strategies
  Future<DocumentModel?> _findDocumentWithAlternativeIds(
    String originalId,
  ) async {
    try {
      debugPrint(
        '🔍 Attempting alternative document ID resolution for: $originalId',
      );

      // Generate possible document IDs based on the original ID
      final possibleIds = DocumentIdGenerator.generatePossibleIds(originalId);

      // Try each possible ID
      for (final possibleId in possibleIds) {
        if (possibleId == originalId) {
          continue; // Skip the original ID we already tried
        }

        try {
          debugPrint('🔍 Trying alternative ID: $possibleId');

          final doc = await _firebaseService.documentsCollection
              .doc(possibleId)
              .get();

          if (doc.exists) {
            debugPrint('✅ Document found with alternative ID: $possibleId');
            return DocumentModel.fromFirestore(doc);
          }
        } catch (e) {
          debugPrint('⚠️ Failed to check alternative ID $possibleId: $e');
          continue;
        }
      }

      // If no direct ID match, try searching by filename patterns
      return await _searchDocumentByFilename(originalId);
    } catch (e) {
      debugPrint('❌ Error in alternative document resolution: $e');
      return null;
    }
  }

  // Search for document by filename patterns when ID resolution fails
  Future<DocumentModel?> _searchDocumentByFilename(String searchTerm) async {
    try {
      debugPrint('🔍 Searching documents by filename pattern: $searchTerm');

      // Try to extract potential filename from the search term
      String searchPattern = searchTerm;

      // Remove common prefixes that might be in document IDs
      searchPattern = searchPattern.replaceAll(RegExp(r'^(doc_|sync_)'), '');
      searchPattern = searchPattern.replaceAll(RegExp(r'_hash_[a-f0-9]+'), '');
      searchPattern = searchPattern.replaceAll(RegExp(r'^[a-f0-9]+_'), '');

      if (searchPattern.isEmpty) {
        debugPrint('⚠️ No valid search pattern extracted from: $searchTerm');
        return null;
      }

      debugPrint('🔍 Using search pattern: $searchPattern');

      // Search for documents with filename containing the pattern
      final querySnapshot = await _firebaseService.documentsCollection
          .where('isActive', isEqualTo: true)
          .where('fileName', isGreaterThanOrEqualTo: searchPattern)
          .where('fileName', isLessThanOrEqualTo: '$searchPattern\uf8ff')
          .limit(5) // Limit to prevent excessive queries
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        debugPrint(
          '✅ Found ${querySnapshot.docs.length} documents matching filename pattern',
        );

        // Return the first match (most likely candidate)
        final document = DocumentModel.fromFirestore(querySnapshot.docs.first);
        debugPrint(
          '✅ Selected document: ${document.fileName} (ID: ${document.id})',
        );
        return document;
      }

      debugPrint(
        '⚠️ No documents found matching filename pattern: $searchPattern',
      );
      return null;
    } catch (e) {
      debugPrint('❌ Error searching document by filename: $e');
      return null;
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

          // ENTERPRISE SCALE: Support unlimited queries for enterprise mode
          if (FirebaseConfig.shouldEnableUnlimitedFiles &&
              limit > ANRConfig.maxItemsPerPage) {
            // Allow unlimited queries for enterprise mode
            query = query.limit(limit);
          } else {
            // Apply safe limit for standard mode
            final effectiveLimit = limit > ANRConfig.maxItemsPerPage
                ? ANRConfig.maxItemsPerPage
                : limit;
            query = query.limit(effectiveLimit);
          }

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
