import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/document_model.dart';
import '../models/user_model.dart';
import '../core/services/firebase_service.dart';
import '../core/services/auth_service.dart';
import '../config/firebase_config.dart';
import '../core/utils/anr_prevention.dart';
import '../core/config/anr_config.dart';

/// Enhanced Document Service with unlimited query support and role-based access
class EnhancedDocumentService {
  static EnhancedDocumentService? _instance;
  static EnhancedDocumentService get instance =>
      _instance ??= EnhancedDocumentService._();

  EnhancedDocumentService._();

  final FirebaseService _firebaseService = FirebaseService.instance;
  final AuthService _authService = AuthService.instance;

  /// Get current user data
  Future<UserModel?> get _currentUser async {
    return await _authService.getCurrentUserData();
  }

  /// Get all documents with unlimited query support (admin only)
  Future<List<DocumentModel>> getAllDocumentsUnlimited({
    String? categoryFilter,
    String? searchQuery,
    bool activeOnly = true,
  }) async {
    try {
      // Check if user is admin for unlimited access
      final currentUser = await _currentUser;
      if (currentUser == null || !currentUser.isAdmin) {
        debugPrint(
          '⚠️ Unlimited query access denied - admin privileges required',
        );
        return await getAllDocumentsLimited();
      }

      debugPrint('🔓 Admin unlimited query access granted');

      List<DocumentModel> allDocuments = [];
      DocumentSnapshot? lastDocument;
      bool hasMore = true;
      int batchCount = 0;
      final batchSize = FirebaseConfig.getUnlimitedQueryBatchSize;

      while (hasMore && batchCount < 50) {
        // Safety limit of 5000 documents
        Query query = _firebaseService.firestore.collection(
          'document-metadata',
        );

        // Apply filters
        if (activeOnly) {
          query = query.where('isActive', isEqualTo: true);
        }

        if (categoryFilter != null && categoryFilter.isNotEmpty) {
          query = query.where('category', isEqualTo: categoryFilter);
        }

        // Apply search filter if provided
        if (searchQuery != null && searchQuery.isNotEmpty) {
          query = query
              .where('fileName', isGreaterThanOrEqualTo: searchQuery)
              .where('fileName', isLessThanOrEqualTo: '$searchQuery\uf8ff');
        }

        // Order and pagination
        query = query.orderBy('uploadedAt', descending: true);

        if (lastDocument != null) {
          query = query.startAfterDocument(lastDocument);
        }

        query = query.limit(batchSize);

        // Execute query with timeout
        final querySnapshot = await ANRPrevention.executeWithTimeout(
          query.get(),
          timeout: ANRConfig.firestoreQueryTimeout,
          operationName: 'Unlimited Query Batch ${batchCount + 1}',
        );

        if (querySnapshot == null || querySnapshot.docs.isEmpty) {
          hasMore = false;
          break;
        }

        // Process documents
        final batchDocuments = querySnapshot.docs
            .map((doc) {
              try {
                return DocumentModel.fromFirestore(doc);
              } catch (e) {
                debugPrint('❌ Error parsing document ${doc.id}: $e');
                return null;
              }
            })
            .where((doc) => doc != null)
            .cast<DocumentModel>()
            .toList();

        allDocuments.addAll(batchDocuments);
        lastDocument = querySnapshot.docs.last;
        batchCount++;

        // Check if we got fewer documents than requested (end of data)
        if (querySnapshot.docs.length < batchSize) {
          hasMore = false;
        }

        debugPrint(
          '📊 Batch $batchCount: ${batchDocuments.length} documents, Total: ${allDocuments.length}',
        );

        // Small delay to prevent overwhelming Firebase
        if (hasMore) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }

      debugPrint(
        '✅ Unlimited query completed: ${allDocuments.length} documents in $batchCount batches',
      );
      return allDocuments;
    } catch (e) {
      debugPrint('❌ Unlimited query failed: $e');
      // Fallback to limited query
      return await getAllDocumentsLimited();
    }
  }

  /// Get all documents with standard pagination (for regular users)
  Future<List<DocumentModel>> getAllDocumentsLimited({
    int? limit,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      Query query = _firebaseService.firestore
          .collection('document-metadata')
          .where('isActive', isEqualTo: true)
          .orderBy('uploadedAt', descending: true);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final effectiveLimit = limit ?? FirebaseConfig.batchSize;
      query = query.limit(effectiveLimit);

      final querySnapshot = await ANRPrevention.executeWithTimeout(
        query.get(),
        timeout: ANRConfig.firestoreQueryTimeout,
        operationName: 'Limited Document Query',
      );

      if (querySnapshot == null) {
        return [];
      }

      return querySnapshot.docs
          .map((doc) {
            try {
              return DocumentModel.fromFirestore(doc);
            } catch (e) {
              debugPrint('❌ Error parsing document ${doc.id}: $e');
              return null;
            }
          })
          .where((doc) => doc != null)
          .cast<DocumentModel>()
          .toList();
    } catch (e) {
      debugPrint('❌ Limited query failed: $e');
      return [];
    }
  }

  /// Get documents by category with unlimited support
  Future<List<DocumentModel>> getDocumentsByCategoryUnlimited(
    String categoryId,
  ) async {
    return await getAllDocumentsUnlimited(
      categoryFilter: categoryId,
      activeOnly: true,
    );
  }

  /// Search documents with unlimited support
  Future<List<DocumentModel>> searchDocumentsUnlimited(
    String searchQuery,
  ) async {
    return await getAllDocumentsUnlimited(
      searchQuery: searchQuery,
      activeOnly: true,
    );
  }

  /// Get recent documents with enhanced loading
  Future<List<DocumentModel>> getRecentDocumentsEnhanced({int? limit}) async {
    final currentUser = await _currentUser;
    final effectiveLimit = currentUser?.isAdmin == true
        ? (limit ?? FirebaseConfig.getUnlimitedQueryBatchSize)
        : (limit ?? FirebaseConfig.batchSize);

    // ENTERPRISE SCALE: Use unlimited queries for enterprise mode or admin users
    if ((currentUser?.isAdmin == true && (limit == null || limit > 100)) ||
        FirebaseConfig.shouldEnableUnlimitedFiles) {
      // Use unlimited query for admin users or enterprise mode
      final allDocs = await getAllDocumentsUnlimited();
      return limit != null ? allDocs.take(limit).toList() : allDocs;
    }

    return await getAllDocumentsLimited(limit: effectiveLimit);
  }

  /// Check if current user can perform unlimited queries
  Future<bool> get canPerformUnlimitedQueries async {
    final currentUser = await _currentUser;
    return currentUser?.isAdmin == true &&
        FirebaseConfig.shouldEnableUnlimitedQueries;
  }

  /// Get total document count (admin only)
  Future<int> getTotalDocumentCount() async {
    if (!(await canPerformUnlimitedQueries)) {
      return 0;
    }

    try {
      final allDocs = await getAllDocumentsUnlimited();
      return allDocs.length;
    } catch (e) {
      debugPrint('❌ Failed to get total document count: $e');
      return 0;
    }
  }

  /// Get documents statistics (admin only)
  Future<Map<String, int>> getDocumentStatistics() async {
    if (!(await canPerformUnlimitedQueries)) {
      return {};
    }

    try {
      final allDocs = await getAllDocumentsUnlimited();

      final stats = <String, int>{
        'total': allDocs.length,
        'active': allDocs
            .where((doc) => doc.metadata.description != 'deleted')
            .length,
      };

      // Count by category
      final categoryStats = <String, int>{};
      for (final doc in allDocs) {
        categoryStats[doc.category] = (categoryStats[doc.category] ?? 0) + 1;
      }

      stats.addAll(categoryStats);
      return stats;
    } catch (e) {
      debugPrint('❌ Failed to get document statistics: $e');
      return {};
    }
  }
}
