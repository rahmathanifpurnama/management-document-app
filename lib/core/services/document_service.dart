import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../services/firebase_service.dart';
import '../config/anr_config.dart';
import '../../config/firebase_config.dart';
import '../utils/anr_prevention.dart';
import '../../models/activity_model.dart';
import 'optimized_network_service.dart';
import 'unified_id_system.dart';
import '../../models/document_model.dart';
import '../../utils/deletion_diagnostic.dart';

class DocumentService {
  static DocumentService? _instance;
  static DocumentService get instance => _instance ??= DocumentService._();

  DocumentService._();

  final FirebaseService _firebaseService = FirebaseService.instance;
  final UnifiedIdSystem _unifiedIdSystem = UnifiedIdSystem.instance;

  // HIGH PRIORITY: Get all documents with pagination and optimization
  Future<List<DocumentModel>> getAllDocuments({
    int? limit,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      final networkService = OptimizedNetworkService.instance;

      // CRITICAL FIX: Use correct collection name and optimized query with proper timeout and error handling
      final querySnapshot = await networkService.executeFirestoreOperation(
        () async {
          Query query = _firebaseService.firestore
              .collection('document-metadata')
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

  // Get document by ID using direct lookup only (simplified)
  Future<DocumentModel?> getDocumentById(String documentId) async {
    try {
      debugPrint('🔍 Searching for document with ID: $documentId');

      // Direct lookup only - no complex resolution needed with UUID system
      DocumentSnapshot doc = await _firebaseService.documentsCollection
          .doc(documentId)
          .get();

      if (doc.exists) {
        debugPrint('✅ Document found: $documentId');
        return DocumentModel.fromFirestore(doc);
      }

      debugPrint('⚠️ Document not found: $documentId');
      return null;
    } catch (e) {
      debugPrint('❌ Error in getDocumentById: $e');
      throw Exception('Failed to get document: ${e.toString()}');
    }
  }

  // Add document using unified ID system
  Future<String> addDocument(DocumentModel document) async {
    try {
      String documentId;

      // UNIFIED ID SYSTEM: Use existing ID if valid, otherwise create with unified system
      if (document.id.isNotEmpty &&
          await _unifiedIdSystem.validateDocumentId(document.id)) {
        // Document already has a valid Firestore ID
        documentId = document.id;
        await _firebaseService.documentsCollection
            .doc(documentId)
            .set(document.toMap());
      } else {
        // Create new document with unified ID system
        documentId = await _unifiedIdSystem.createDocumentWithUnifiedId(
          fileName: document.fileName,
          filePath: document.filePath,
          uploadedBy: document.uploadedBy,
          category: document.category,
          fileSize: document.fileSize,
          fileType: document.fileType,
          additionalMetadata: document.metadata.toMap(),
        );
      }

      // Log activity
      await _logActivity(
        document.uploadedBy,
        ActivityType.upload,
        'Document: ${document.fileName}',
      );

      return documentId;
    } catch (e) {
      throw Exception('Failed to add document: ${e.toString()}');
    }
  }

  // CRITICAL FIX: Add document without activity logging (for sync operations)
  Future<String> addDocumentSilent(DocumentModel document) async {
    try {
      String documentId;

      // UNIFIED ID SYSTEM: Use existing ID if valid, otherwise create with unified system
      if (document.id.isNotEmpty &&
          await _unifiedIdSystem.validateDocumentId(document.id)) {
        // Document already has a valid Firestore ID
        documentId = document.id;
        await _firebaseService.documentsCollection
            .doc(documentId)
            .set(document.toMap());
      } else {
        // Create new document with unified ID system
        documentId = await _unifiedIdSystem.createDocumentWithUnifiedId(
          fileName: document.fileName,
          filePath: document.filePath,
          uploadedBy: document.uploadedBy,
          category: document.category,
          fileSize: document.fileSize,
          fileType: document.fileType,
          additionalMetadata: document.metadata.toMap(),
        );
      }

      debugPrint(
        '✅ Document added silently (no activity log): ${document.fileName}',
      );
      return documentId;
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
      debugPrint('🗑️ Starting delete operation for document: $documentId');

      // ADMIN-ONLY: Verify that the user performing deletion is an admin
      final isAdmin = await _verifyAdminStatus(deletedBy);
      if (!isAdmin) {
        throw Exception('Access denied: Only administrators can delete files');
      }

      // ENHANCED DELETE FIX: Try multiple approaches to find and delete the document
      DocumentModel? document;
      bool documentFoundInFirestore = false;

      // Step 1: Try to get document from Firestore with enhanced lookup
      try {
        document = await getDocumentById(documentId);
        if (document != null) {
          documentFoundInFirestore = true;
          debugPrint('✅ Document found in Firestore: ${document.fileName}');
          debugPrint('📁 Firestore document filePath: ${document.filePath}');
          debugPrint(
            '👤 Firestore document uploadedBy: ${document.uploadedBy}',
          );
        } else {
          // ENHANCED FIX: Try alternative Firestore lookup methods
          debugPrint(
            '🔍 Document not found by ID, trying alternative lookups...',
          );
          document = await _findDocumentInFirestoreByAlternativeMethods(
            documentId,
          );
          if (document != null) {
            documentFoundInFirestore = true;
            debugPrint(
              '✅ Document found via alternative Firestore lookup: ${document.fileName}',
            );
          }
        }
      } catch (e) {
        debugPrint('⚠️ Error getting document from Firestore: $e');
      }

      // Step 2: If not found in Firestore, try comprehensive Firebase Storage search
      if (document == null) {
        debugPrint(
          '🔍 Document not found in Firestore, searching Firebase Storage comprehensively...',
        );
        document = await _findDocumentInStorage(
          documentId,
          uploadedBy: deletedBy,
        );
      }

      // Step 3: If still not found, create a minimal document for cleanup
      if (document == null) {
        debugPrint(
          '⚠️ Document not found anywhere, creating minimal record for cleanup',
        );
        document = DocumentModel(
          id: documentId,
          fileName: 'Unknown File (ID: $documentId)',
          fileSize: 0,
          fileType: 'unknown',
          filePath: '',
          uploadedBy: deletedBy,
          uploadedAt: DateTime.now(),
          category: '',
          permissions: [],
          metadata: DocumentMetadata(
            description: 'Cleanup operation',
            tags: [],
          ),
        );
      }

      // Step 3.5: Run diagnostic if document wasn't found in expected places
      if (document.fileName.contains('Unknown File')) {
        debugPrint('🔍 Running deletion diagnostic for troubleshooting...');
        try {
          final diagnostic = DeletionDiagnostic();
          final diagnosticResults = await diagnostic.runDiagnostic(documentId);
          debugPrint('📋 Diagnostic Results: $diagnosticResults');

          // Log recommendations for manual review
          final recommendations =
              diagnosticResults['recommendations'] as List<String>?;
          if (recommendations != null && recommendations.isNotEmpty) {
            debugPrint('💡 Diagnostic Recommendations:');
            for (final recommendation in recommendations) {
              debugPrint('   - $recommendation');
            }
          }
        } catch (e) {
          debugPrint('⚠️ Diagnostic failed: $e');
        }
      }

      // Step 4: Delete from Firebase Storage with comprehensive approach
      final storageDeleted = await _deleteFromFirebaseStorage(
        document,
        documentId,
      );

      // Step 4.5: Verify storage deletion and handle failures
      if (storageDeleted) {
        final verificationResult = await _verifyStorageDeletion(
          document,
          documentId,
        );
        if (!verificationResult) {
          debugPrint(
            '⚠️ Storage deletion verification failed - attempting force deletion',
          );
          try {
            await forceDeleteFromStorage(documentId, document.fileName);
            debugPrint('✅ Force deletion completed successfully');
          } catch (e) {
            debugPrint('❌ Force deletion also failed: $e');
            // Log this as a critical issue but don't fail the entire operation
            await _logActivity(
              deletedBy,
              ActivityType.delete,
              'CRITICAL: Failed to delete storage file: ${document.fileName} (ID: $documentId) - Manual cleanup required',
            );
          }
        }
      } else {
        debugPrint(
          '⚠️ Storage deletion failed - attempting force deletion as fallback',
        );
        try {
          await forceDeleteFromStorage(documentId, document.fileName);
          debugPrint('✅ Force deletion fallback completed successfully');
        } catch (e) {
          debugPrint('❌ Force deletion fallback also failed: $e');
          // Log this as a critical issue
          await _logActivity(
            deletedBy,
            ActivityType.delete,
            'CRITICAL: All storage deletion attempts failed: ${document.fileName} (ID: $documentId) - Manual cleanup required',
          );
        }
      }

      // Step 5: Delete from Firestore (only if document was found there)
      if (documentFoundInFirestore) {
        try {
          debugPrint('🗑️ Deleting from Firestore: $documentId');
          await _firebaseService.documentsCollection.doc(documentId).delete();
          debugPrint('✅ Successfully deleted from Firestore');
        } catch (firestoreError) {
          debugPrint('⚠️ Failed to delete from Firestore: $firestoreError');
          // Don't throw here as the document might have been already deleted
        }
      } else {
        debugPrint(
          'ℹ️ Skipping Firestore deletion - document was not found in Firestore',
        );
      }

      // Step 6: Log activity (always log, even for cleanup operations)
      try {
        await _logActivity(
          deletedBy,
          ActivityType.delete,
          'Document: ${document.fileName} (ID: $documentId)',
        );
        debugPrint('✅ Activity logged successfully');
      } catch (activityError) {
        debugPrint('⚠️ Failed to log activity: $activityError');
        // Don't throw here as the main deletion operation succeeded
      }

      debugPrint('✅ Delete operation completed for document: $documentId');
    } catch (e) {
      debugPrint('❌ Delete operation failed for document $documentId: $e');
      throw Exception('Failed to delete document: ${e.toString()}');
    }
  }

  // Helper method to determine file type from filename
  String _getFileTypeFromName(String fileName) {
    if (fileName.isEmpty) return 'unknown';

    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'pdf';
      case 'doc':
      case 'docx':
        return 'document';
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return 'image';
      case 'mp4':
      case 'avi':
      case 'mov':
        return 'video';
      case 'mp3':
      case 'wav':
        return 'audio';
      default:
        return extension.isNotEmpty ? extension : 'unknown';
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

  // ENHANCED DELETE FIX: Comprehensive Firebase Storage search
  Future<DocumentModel?> _findDocumentInStorage(
    String documentId, {
    String? uploadedBy,
  }) async {
    try {
      debugPrint('🔍 Searching Firebase Storage for document: $documentId');
      if (uploadedBy != null) {
        debugPrint('🔍 Searching with user context: $uploadedBy');
      }

      // PRIORITY 1: Search in user-specific folder first if we have user context
      if (uploadedBy != null && uploadedBy.isNotEmpty) {
        final userRef = _firebaseService.storage.ref().child(
          'documents/$uploadedBy',
        );
        try {
          final userListResult = await userRef.listAll();
          for (final item in userListResult.items) {
            try {
              if (_isMatchingDocument(documentId, item.name, item.fullPath)) {
                debugPrint(
                  '✅ Found matching file in user folder: ${item.fullPath}',
                );
                final metadata = await item.getMetadata();
                return DocumentModel(
                  id: documentId,
                  fileName: item.name,
                  fileSize: metadata.size ?? 0,
                  fileType: _getFileTypeFromName(item.name),
                  filePath: item.fullPath,
                  uploadedBy: uploadedBy,
                  uploadedAt: metadata.timeCreated ?? DateTime.now(),
                  category: _extractCategoryFromStoragePath(item.fullPath),
                  permissions: [],
                  metadata: DocumentMetadata(
                    description: 'Storage-only file',
                    tags: ['storage-sourced'],
                  ),
                );
              }
            } catch (e) {
              debugPrint(
                '⚠️ Error checking user storage item ${item.name}: $e',
              );
              continue;
            }
          }
        } catch (e) {
          debugPrint('⚠️ Error searching user folder: $e');
        }
      }

      // PRIORITY 2: Search in main documents folder
      final documentsRef = _firebaseService.storage.ref().child('documents');
      final listResult = await documentsRef.listAll();

      // Search through all files and subdirectories
      for (final item in listResult.items) {
        try {
          final metadata = await item.getMetadata();
          final fileName = item.name;

          // Check if this could be our document by comparing various identifiers
          if (_isMatchingDocument(documentId, fileName, item.fullPath)) {
            debugPrint('✅ Found matching file in storage: ${item.fullPath}');

            return DocumentModel(
              id: documentId,
              fileName: fileName,
              fileSize: metadata.size ?? 0,
              fileType: _getFileTypeFromName(fileName),
              filePath: item.fullPath,
              uploadedBy: 'system',
              uploadedAt: metadata.timeCreated ?? DateTime.now(),
              category: _extractCategoryFromStoragePath(item.fullPath),
              permissions: [],
              metadata: DocumentMetadata(
                description: 'Storage-only file',
                tags: ['storage-sourced'],
              ),
            );
          }
        } catch (e) {
          debugPrint('⚠️ Error checking storage item ${item.name}: $e');
          continue;
        }
      }

      // Also search in category subdirectories
      for (final prefix in listResult.prefixes) {
        final categoryResult = await _searchInStoragePrefix(prefix, documentId);
        if (categoryResult != null) {
          return categoryResult;
        }
      }

      debugPrint('❌ Document not found in Firebase Storage');
      return null;
    } catch (e) {
      debugPrint('❌ Error searching Firebase Storage: $e');
      return null;
    }
  }

  // Helper method to search in storage prefixes (subdirectories)
  Future<DocumentModel?> _searchInStoragePrefix(
    Reference prefix,
    String documentId,
  ) async {
    try {
      final listResult = await prefix.listAll();

      for (final item in listResult.items) {
        try {
          final metadata = await item.getMetadata();
          final fileName = item.name;

          if (_isMatchingDocument(documentId, fileName, item.fullPath)) {
            debugPrint('✅ Found matching file in category: ${item.fullPath}');

            return DocumentModel(
              id: documentId,
              fileName: fileName,
              fileSize: metadata.size ?? 0,
              fileType: _getFileTypeFromName(fileName),
              filePath: item.fullPath,
              uploadedBy: 'system',
              uploadedAt: metadata.timeCreated ?? DateTime.now(),
              category: _extractCategoryFromStoragePath(item.fullPath),
              permissions: [],
              metadata: DocumentMetadata(
                description: 'Storage-only file',
                tags: ['storage-sourced'],
              ),
            );
          }
        } catch (e) {
          debugPrint('⚠️ Error checking category item ${item.name}: $e');
          continue;
        }
      }

      // Recursively search in nested prefixes
      for (final nestedPrefix in listResult.prefixes) {
        final result = await _searchInStoragePrefix(nestedPrefix, documentId);
        if (result != null) {
          return result;
        }
      }

      return null;
    } catch (e) {
      debugPrint('⚠️ Error searching storage prefix: $e');
      return null;
    }
  }

  // Helper method to check if a storage file matches the document we're looking for
  bool _isMatchingDocument(
    String documentId,
    String fileName,
    String fullPath,
  ) {
    debugPrint(
      '🔍 Checking match: documentId=$documentId, fileName=$fileName, fullPath=$fullPath',
    );

    // Check various matching patterns:
    // 1. Document ID matches filename (without extension)
    final fileNameWithoutExt = fileName.split('.').first;
    if (fileNameWithoutExt == documentId) {
      debugPrint(
        '✅ Match found: Document ID matches filename without extension',
      );
      return true;
    }

    // 2. Document ID is contained in the filename
    if (fileName.contains(documentId)) {
      debugPrint('✅ Match found: Document ID contained in filename');
      return true;
    }

    // 3. Full path contains document ID
    if (fullPath.contains(documentId)) {
      debugPrint('✅ Match found: Document ID contained in full path');
      return true;
    }

    // 4. ENHANCED: Check if filename matches common patterns
    final commonPatterns = [
      documentId,
      '${documentId}.pdf',
      '${documentId}.doc',
      '${documentId}.docx',
      '${documentId}.jpg',
      '${documentId}.jpeg',
      '${documentId}.png',
      '${documentId}.txt',
    ];

    for (final pattern in commonPatterns) {
      if (fileName == pattern || fullPath.endsWith(pattern)) {
        debugPrint('✅ Match found: Filename matches common pattern: $pattern');
        return true;
      }
    }

    debugPrint('❌ No match found for document ID: $documentId');
    return false;
  }

  // Extract category from storage path
  String _extractCategoryFromStoragePath(String filePath) {
    final pathParts = filePath.split('/');

    // Check for category-specific paths: documents/categories/categoryId/file.pdf
    if (pathParts.length >= 4 && pathParts[1] == 'categories') {
      return pathParts[2];
    }

    // Files directly in documents/ folder are uncategorized (empty string)
    return '';
  }

  // ENHANCED DELETE FIX: Comprehensive Firebase Storage deletion
  Future<bool> _deleteFromFirebaseStorage(
    DocumentModel document,
    String documentId,
  ) async {
    bool deletionSuccessful = false;
    List<String> attemptedPaths = [];

    try {
      debugPrint(
        '🗑️ Starting Firebase Storage deletion for: ${document.fileName}',
      );
      debugPrint('📁 Document filePath: ${document.filePath}');

      // Attempt 1: Use the document's filePath if available
      if (document.filePath.isNotEmpty) {
        try {
          debugPrint(
            '🗑️ Attempting deletion using document filePath: ${document.filePath}',
          );
          final storageRef = _firebaseService.storage.ref().child(
            document.filePath,
          );
          await storageRef.delete();

          // Verify deletion by trying to get metadata
          try {
            await storageRef.getMetadata();
            debugPrint('⚠️ File still exists after deletion attempt');
          } catch (e) {
            // File not found means deletion was successful
            debugPrint(
              '✅ Successfully deleted from Firebase Storage: ${document.filePath}',
            );
            deletionSuccessful = true;
            return true;
          }
        } catch (e) {
          debugPrint('⚠️ Failed to delete using filePath: $e');
          debugPrint('🔍 Error type: ${e.runtimeType}');
          debugPrint('🔍 Error details: ${e.toString()}');

          if (e.toString().contains('permission') ||
              e.toString().contains('unauthorized')) {
            debugPrint(
              '🚨 PERMISSION DENIED: Check Firebase Storage security rules',
            );
          } else if (e.toString().contains('Object does not exist') ||
              e.toString().contains('404') ||
              e.toString().contains('Not Found')) {
            debugPrint(
              '📁 FILE NOT FOUND: File may have been moved or deleted',
            );
          } else if (e.toString().contains('Too many attempts')) {
            debugPrint('⏱️ RATE LIMIT: Too many requests to Firebase Storage');
          }

          attemptedPaths.add(document.filePath);
        }
      }

      // Attempt 2: Search for the file and delete using actual storage path
      if (!deletionSuccessful) {
        debugPrint('🔍 Searching for file in storage to delete...');
        final foundDocument = await _findDocumentInStorage(
          documentId,
          uploadedBy: document.uploadedBy,
        );

        if (foundDocument != null && foundDocument.filePath.isNotEmpty) {
          try {
            debugPrint(
              '🗑️ Attempting deletion using found filePath: ${foundDocument.filePath}',
            );
            final storageRef = _firebaseService.storage.ref().child(
              foundDocument.filePath,
            );
            await storageRef.delete();

            // Verify deletion
            try {
              await storageRef.getMetadata();
              debugPrint('⚠️ File still exists after deletion attempt');
            } catch (e) {
              debugPrint(
                '✅ Successfully deleted from Firebase Storage: ${foundDocument.filePath}',
              );
              deletionSuccessful = true;
              return true;
            }
          } catch (e) {
            debugPrint('⚠️ Failed to delete using found filePath: $e');
            attemptedPaths.add(foundDocument.filePath);
          }
        }
      }

      // Attempt 3: Try common path patterns based on filename
      if (!deletionSuccessful && document.fileName.isNotEmpty) {
        final pathPatterns = _generateStoragePathPatterns(
          document.fileName,
          documentId,
          uploadedBy: document.uploadedBy,
        );

        for (final pattern in pathPatterns) {
          if (attemptedPaths.contains(pattern)) {
            continue; // Skip already attempted paths
          }

          try {
            debugPrint('🗑️ Attempting deletion using pattern: $pattern');
            final storageRef = _firebaseService.storage.ref().child(pattern);

            // First check if file exists
            await storageRef.getMetadata();

            // If we get here, file exists, so delete it
            await storageRef.delete();

            // Verify deletion
            try {
              await storageRef.getMetadata();
              debugPrint('⚠️ File still exists after deletion attempt');
            } catch (e) {
              debugPrint(
                '✅ Successfully deleted from Firebase Storage: $pattern',
              );
              deletionSuccessful = true;
              return true;
            }
          } catch (e) {
            // File doesn't exist at this path, continue to next pattern
            debugPrint('⚠️ File not found at pattern: $pattern');
            continue;
          }
        }
      }

      if (!deletionSuccessful) {
        debugPrint(
          '❌ Failed to delete file from Firebase Storage after all attempts',
        );
        debugPrint('📋 Attempted paths: ${attemptedPaths.join(', ')}');
        // Don't throw error - continue with Firestore deletion
      }

      return deletionSuccessful;
    } catch (e) {
      debugPrint('❌ Error during Firebase Storage deletion: $e');
      // Don't throw error - continue with Firestore deletion
      return false;
    }
  }

  // Generate possible storage path patterns for a file
  List<String> _generateStoragePathPatterns(
    String fileName,
    String documentId, {
    String? uploadedBy,
  }) {
    final patterns = <String>[];

    // CRITICAL FIX: Pattern 1 - User-specific path (most likely correct path)
    if (uploadedBy != null && uploadedBy.isNotEmpty) {
      patterns.add('documents/$uploadedBy/$fileName');

      // Also try with document ID as filename in user folder
      final commonExtensions = [
        'pdf',
        'docx',
        'doc',
        'jpg',
        'jpeg',
        'png',
        'txt',
      ];
      for (final ext in commonExtensions) {
        patterns.add('documents/$uploadedBy/$documentId.$ext');
      }
    }

    // Pattern 2: Direct filename in documents folder (legacy)
    patterns.add('documents/$fileName');

    // Pattern 3: Document ID as filename with common extensions
    final commonExtensions = [
      'pdf',
      'docx',
      'doc',
      'jpg',
      'jpeg',
      'png',
      'txt',
    ];
    for (final ext in commonExtensions) {
      patterns.add('documents/$documentId.$ext');
    }

    // Pattern 4: Filename in categories folder (try common category patterns)
    patterns.add('documents/categories/general/$fileName');
    patterns.add('documents/categories/documents/$fileName');
    patterns.add('documents/categories/files/$fileName');

    // Pattern 5: User-based paths (try common user folder patterns)
    patterns.add('documents/users/$fileName');
    patterns.add('documents/user/$fileName');

    // Pattern 6: Just the document ID
    patterns.add('documents/$documentId');

    // ENHANCED: PDF-specific patterns (addresses known PDF deletion issues)
    if (fileName.toLowerCase().endsWith('.pdf')) {
      debugPrint('🔍 Adding PDF-specific path patterns for: $fileName');

      // PDF-specific storage patterns
      patterns.addAll([
        'documents/pdfs/$fileName',
        'documents/files/pdf/$fileName',
      ]);

      if (uploadedBy != null && uploadedBy.isNotEmpty) {
        patterns.addAll([
          'documents/pdfs/$uploadedBy/$fileName',
          'documents/$uploadedBy/pdfs/$fileName',
          'documents/files/pdf/$uploadedBy/$fileName',
        ]);
      }

      // PDF with sanitized names (common issue)
      final sanitizedName = fileName.replaceAll(RegExp(r'[^\w\-_\.]'), '_');
      if (sanitizedName != fileName) {
        patterns.addAll([
          'documents/$sanitizedName',
          'documents/pdfs/$sanitizedName',
        ]);

        if (uploadedBy != null && uploadedBy.isNotEmpty) {
          patterns.addAll([
            'documents/$uploadedBy/$sanitizedName',
            'documents/pdfs/$uploadedBy/$sanitizedName',
          ]);
        }
      }

      // PDF with encoded names (URL encoding issues)
      final encodedName = Uri.encodeComponent(fileName);
      if (encodedName != fileName) {
        patterns.addAll(['documents/$encodedName']);

        if (uploadedBy != null && uploadedBy.isNotEmpty) {
          patterns.add('documents/$uploadedBy/$encodedName');
        }
      }
    }

    return patterns;
  }

  // ENHANCED DELETE FIX: Verify that file was actually deleted from Firebase Storage
  Future<bool> _verifyStorageDeletion(
    DocumentModel document,
    String documentId,
  ) async {
    try {
      debugPrint('🔍 Verifying storage deletion for: ${document.fileName}');

      // Check the original filePath first
      if (document.filePath.isNotEmpty) {
        try {
          final storageRef = _firebaseService.storage.ref().child(
            document.filePath,
          );
          await storageRef.getMetadata();
          // If we get here, file still exists
          debugPrint(
            '❌ Verification failed: File still exists at ${document.filePath}',
          );
          return false;
        } catch (e) {
          // File not found is good - it means deletion was successful
          debugPrint(
            '✅ Verification passed: File not found at ${document.filePath}',
          );
        }
      }

      // Double-check by searching for the file in storage
      final foundDocument = await _findDocumentInStorage(
        documentId,
        uploadedBy: document.uploadedBy,
      );
      if (foundDocument != null) {
        debugPrint('❌ Verification failed: File still found in storage search');
        debugPrint('📁 Found at: ${foundDocument.filePath}');
        return false;
      }

      debugPrint('✅ Storage deletion verification successful');
      return true;
    } catch (e) {
      debugPrint('⚠️ Error during storage deletion verification: $e');
      // If verification fails due to error, assume deletion was successful
      // to avoid blocking the operation
      return true;
    }
  }

  // ENHANCED DELETE FIX: Force delete all instances of a file from storage
  Future<void> forceDeleteFromStorage(
    String documentId,
    String fileName,
  ) async {
    try {
      debugPrint(
        '🗑️ Force deleting all instances of file: $fileName (ID: $documentId)',
      );

      // Search for all instances of the file
      final documentsRef = _firebaseService.storage.ref().child('documents');
      final listResult = await documentsRef.listAll();

      int deletedCount = 0;

      // Check all files in the main documents folder
      for (final item in listResult.items) {
        if (_isMatchingDocument(documentId, item.name, item.fullPath)) {
          try {
            await item.delete();
            debugPrint('✅ Force deleted: ${item.fullPath}');
            deletedCount++;
          } catch (e) {
            debugPrint('⚠️ Failed to force delete ${item.fullPath}: $e');
          }
        }
      }

      // Check all subdirectories
      for (final prefix in listResult.prefixes) {
        deletedCount += await _forceDeleteFromPrefix(prefix, documentId);
      }

      debugPrint(
        '✅ Force deletion completed. Deleted $deletedCount instances.',
      );
    } catch (e) {
      debugPrint('❌ Error during force deletion: $e');
      throw Exception('Failed to force delete from storage: ${e.toString()}');
    }
  }

  // Helper method for recursive force deletion in prefixes
  Future<int> _forceDeleteFromPrefix(
    Reference prefix,
    String documentId,
  ) async {
    int deletedCount = 0;

    try {
      final listResult = await prefix.listAll();

      // Check files in this prefix
      for (final item in listResult.items) {
        if (_isMatchingDocument(documentId, item.name, item.fullPath)) {
          try {
            await item.delete();
            debugPrint('✅ Force deleted from category: ${item.fullPath}');
            deletedCount++;
          } catch (e) {
            debugPrint('⚠️ Failed to force delete ${item.fullPath}: $e');
          }
        }
      }

      // Recursively check nested prefixes
      for (final nestedPrefix in listResult.prefixes) {
        deletedCount += await _forceDeleteFromPrefix(nestedPrefix, documentId);
      }
    } catch (e) {
      debugPrint('⚠️ Error in force delete prefix: $e');
    }

    return deletedCount;
  }

  /// Alternative Firestore lookup methods for documents that might be stored differently
  Future<DocumentModel?> _findDocumentInFirestoreByAlternativeMethods(
    String documentId,
  ) async {
    try {
      debugPrint(
        '🔍 Trying alternative Firestore lookup methods for: $documentId',
      );

      // Method 1: Search by fileName containing the documentId
      final queryByFileName = await _firebaseService.documentsCollection
          .where('fileName', isGreaterThanOrEqualTo: documentId)
          .where('fileName', isLessThanOrEqualTo: '$documentId\uf8ff')
          .limit(1)
          .get();

      if (queryByFileName.docs.isNotEmpty) {
        debugPrint('✅ Found document by fileName search');
        return DocumentModel.fromFirestore(queryByFileName.docs.first);
      }

      // Method 2: Search by filePath containing the documentId
      final queryByFilePath = await _firebaseService.documentsCollection
          .where('filePath', isGreaterThanOrEqualTo: documentId)
          .where('filePath', isLessThanOrEqualTo: '$documentId\uf8ff')
          .limit(1)
          .get();

      if (queryByFilePath.docs.isNotEmpty) {
        debugPrint('✅ Found document by filePath search');
        return DocumentModel.fromFirestore(queryByFilePath.docs.first);
      }

      // Method 3: Get all documents and search manually (last resort)
      final allDocs = await _firebaseService.documentsCollection
          .where('isActive', isEqualTo: true)
          .get();

      for (final doc in allDocs.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final fileName = data['fileName']?.toString() ?? '';
        final filePath = data['filePath']?.toString() ?? '';

        if (doc.id == documentId ||
            fileName.contains(documentId) ||
            filePath.contains(documentId)) {
          debugPrint('✅ Found document by manual search: ${doc.id}');
          return DocumentModel.fromFirestore(doc);
        }
      }

      debugPrint('❌ Document not found in any Firestore lookup method');
      return null;
    } catch (e) {
      debugPrint('❌ Error in alternative Firestore lookup: $e');
      return null;
    }
  }

  /// Verify that the user has admin privileges
  Future<bool> _verifyAdminStatus(String userId) async {
    try {
      debugPrint('🔐 Verifying admin status for user: $userId');

      // Get user document from Firestore
      final userDoc = await _firebaseService.firestore
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        debugPrint('❌ User document not found: $userId');
        return false;
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final userRole = userData['role']?.toString() ?? 'user';

      final isAdmin = userRole == 'admin';
      debugPrint('🔐 User role: $userRole, isAdmin: $isAdmin');

      return isAdmin;
    } catch (e) {
      debugPrint('❌ Error verifying admin status: $e');
      return false;
    }
  }
}
