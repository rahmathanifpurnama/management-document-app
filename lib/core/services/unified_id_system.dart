import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_service.dart';
import '../../models/document_model.dart';

/// Unified ID System - Single Source of Truth for Document IDs
///
/// This service ensures that Firestore document IDs are used consistently
/// across all components (Flutter app, Cloud Functions, storage services).
/// It prevents ID mismatches that cause "Document not found" errors.
class UnifiedIdSystem {
  static final UnifiedIdSystem _instance = UnifiedIdSystem._internal();
  static UnifiedIdSystem get instance => _instance;
  UnifiedIdSystem._internal();

  final FirebaseService _firebaseService = FirebaseService.instance;

  // Cache for ID mappings to improve performance
  final Map<String, String> _storagePathToFirestoreId = {};
  final Map<String, String> _firestoreIdToStoragePath = {};

  /// Generate a new document ID using Firestore's auto-generation
  /// This ensures consistency with Firestore's ID format
  String generateDocumentId() {
    return FirebaseFirestore.instance.collection('document-metadata').doc().id;
  }

  /// Get Firestore document ID from storage path
  /// This is the primary method for ID resolution
  Future<String?> getFirestoreIdFromStoragePath(String storagePath) async {
    try {
      debugPrint(
        '🔍 UnifiedIdSystem: Resolving Firestore ID for storage path: $storagePath',
      );

      // Check cache first
      if (_storagePathToFirestoreId.containsKey(storagePath)) {
        final cachedId = _storagePathToFirestoreId[storagePath]!;
        debugPrint('✅ Found cached ID: $cachedId');
        return cachedId;
      }

      // Query Firestore to find document with matching filePath
      final querySnapshot = await _firebaseService.documentsCollection
          .where('filePath', isEqualTo: storagePath)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final firestoreId = querySnapshot.docs.first.id;

        // Cache the mapping
        _storagePathToFirestoreId[storagePath] = firestoreId;
        _firestoreIdToStoragePath[firestoreId] = storagePath;

        debugPrint(
          '✅ Resolved Firestore ID: $firestoreId for path: $storagePath',
        );
        return firestoreId;
      }

      debugPrint(
        '⚠️ No Firestore document found for storage path: $storagePath',
      );
      return null;
    } catch (e) {
      debugPrint('❌ Error resolving Firestore ID: $e');
      return null;
    }
  }

  /// Get storage path from Firestore document ID
  Future<String?> getStoragePathFromFirestoreId(String firestoreId) async {
    try {
      debugPrint(
        '🔍 UnifiedIdSystem: Resolving storage path for Firestore ID: $firestoreId',
      );

      // Check cache first
      if (_firestoreIdToStoragePath.containsKey(firestoreId)) {
        final cachedPath = _firestoreIdToStoragePath[firestoreId]!;
        debugPrint('✅ Found cached path: $cachedPath');
        return cachedPath;
      }

      // Get document from Firestore
      final docSnapshot = await _firebaseService.documentsCollection
          .doc(firestoreId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final storagePath = data['filePath'] as String?;

        if (storagePath != null && storagePath.isNotEmpty) {
          // Cache the mapping
          _firestoreIdToStoragePath[firestoreId] = storagePath;
          _storagePathToFirestoreId[storagePath] = firestoreId;

          debugPrint(
            '✅ Resolved storage path: $storagePath for ID: $firestoreId',
          );
          return storagePath;
        }
      }

      debugPrint('⚠️ No storage path found for Firestore ID: $firestoreId');
      return null;
    } catch (e) {
      debugPrint('❌ Error resolving storage path: $e');
      return null;
    }
  }

  /// Create a new document with unified ID management
  /// This ensures the same ID is used in both Firestore and local cache
  Future<String> createDocumentWithUnifiedId({
    required String fileName,
    required String filePath,
    required String uploadedBy,
    required String category,
    required int fileSize,
    required String fileType,
    Map<String, dynamic>? additionalMetadata,
  }) async {
    try {
      // Generate Firestore document ID (single source of truth)
      final documentId = generateDocumentId();

      debugPrint('🆔 UnifiedIdSystem: Creating document with ID: $documentId');

      // Debug authentication info
      final currentUser = FirebaseAuth.instance.currentUser;
      debugPrint('🔍 FIRESTORE DEBUG - Authentication Info:');
      debugPrint('   Current user: ${currentUser?.email}');
      debugPrint('   User UID: ${currentUser?.uid}');
      debugPrint('   Email verified: ${currentUser?.emailVerified}');
      debugPrint('   uploadedBy parameter: $uploadedBy');
      debugPrint('   Match: ${currentUser?.uid == uploadedBy}');

      // Create document data
      final documentData = {
        'id': documentId, // Store ID in document for consistency
        'fileName': fileName,
        'filePath': filePath,
        'uploadedBy': uploadedBy,
        'category': category,
        'fileSize': fileSize,
        'fileType': fileType,
        'uploadedAt': FieldValue.serverTimestamp(),
        'status': 'active', // Add status field for Firestore Rules compliance
        'isActive': true,
        'permissions': [uploadedBy],
        'metadata': {
          'description': '',
          'tags': [],
          'version': '1.0',
          'contentType': _getContentTypeFromFileType(fileType),
          ...?additionalMetadata,
        },
      };

      // Debug document data before creation
      debugPrint('📋 Document data to create:');
      debugPrint('   ID: $documentId');
      debugPrint('   fileName: $fileName');
      debugPrint('   uploadedBy: $uploadedBy');
      debugPrint('   status: ${documentData['status']}');
      debugPrint(
        '   Required fields present: ${['id', 'fileName', 'uploadedAt'].every((field) => documentData.containsKey(field))}',
      );

      // Create document in Firestore with the generated ID
      await _firebaseService.documentsCollection
          .doc(documentId)
          .set(documentData);

      // Cache the ID mapping
      _firestoreIdToStoragePath[documentId] = filePath;
      _storagePathToFirestoreId[filePath] = documentId;

      debugPrint(
        '✅ UnifiedIdSystem: Document created successfully with ID: $documentId',
      );
      return documentId;
    } catch (e) {
      debugPrint('❌ UnifiedIdSystem: Error creating document: $e');
      debugPrint('   Error type: ${e.runtimeType}');
      if (e.toString().contains('permission-denied')) {
        debugPrint(
          '🚫 PERMISSION DENIED - Check user authentication and Firestore Rules',
        );
        debugPrint(
          '   Current user authenticated: ${FirebaseAuth.instance.currentUser != null}',
        );
        debugPrint(
          '   User email: ${FirebaseAuth.instance.currentUser?.email}',
        );
      }
      rethrow;
    }
  }

  /// Validate that a document ID exists in Firestore
  /// This prevents operations on stale/invalid IDs
  Future<bool> validateDocumentId(String documentId) async {
    try {
      final docSnapshot = await _firebaseService.documentsCollection
          .doc(documentId)
          .get();

      final exists = docSnapshot.exists;
      debugPrint(
        '🔍 UnifiedIdSystem: Document ID $documentId validation: $exists',
      );
      return exists;
    } catch (e) {
      debugPrint('❌ UnifiedIdSystem: Error validating document ID: $e');
      return false;
    }
  }

  /// Clear ID mapping cache
  /// Should be called when database is recreated or major sync issues occur
  void clearCache() {
    _storagePathToFirestoreId.clear();
    _firestoreIdToStoragePath.clear();
    debugPrint('🧹 UnifiedIdSystem: ID mapping cache cleared');
  }

  /// Get cache statistics for debugging
  Map<String, dynamic> getCacheStats() {
    return {
      'storagePathMappings': _storagePathToFirestoreId.length,
      'firestoreIdMappings': _firestoreIdToStoragePath.length,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Bulk resolve Firestore IDs from storage paths
  /// Useful for reconciliation operations
  Future<Map<String, String?>> bulkResolveFirestoreIds(
    List<String> storagePaths,
  ) async {
    final results = <String, String?>{};

    debugPrint(
      '🔍 UnifiedIdSystem: Bulk resolving ${storagePaths.length} storage paths',
    );

    // Process in batches to avoid overwhelming Firestore
    const batchSize = 10;
    for (int i = 0; i < storagePaths.length; i += batchSize) {
      final batch = storagePaths.skip(i).take(batchSize).toList();

      // Query Firestore for this batch
      final querySnapshot = await _firebaseService.documentsCollection
          .where('filePath', whereIn: batch)
          .get();

      // Map results
      for (final doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final filePath = data['filePath'] as String?;
        if (filePath != null) {
          results[filePath] = doc.id;
          // Cache the mapping
          _storagePathToFirestoreId[filePath] = doc.id;
          _firestoreIdToStoragePath[doc.id] = filePath;
        }
      }

      // Mark unresolved paths
      for (final path in batch) {
        if (!results.containsKey(path)) {
          results[path] = null;
        }
      }
    }

    debugPrint(
      '✅ UnifiedIdSystem: Bulk resolved ${results.values.where((id) => id != null).length}/${storagePaths.length} IDs',
    );
    return results;
  }

  /// Convert DocumentModel to use Firestore ID if it has a different ID
  /// This helps migrate existing documents to the unified system
  Future<DocumentModel?> normalizeDocumentId(DocumentModel document) async {
    try {
      // If document already has a valid Firestore ID, return as-is
      if (await validateDocumentId(document.id)) {
        return document;
      }

      // Try to find the correct Firestore ID using storage path
      final correctId = await getFirestoreIdFromStoragePath(document.filePath);
      if (correctId != null) {
        debugPrint(
          '🔄 UnifiedIdSystem: Normalizing document ID from ${document.id} to $correctId',
        );

        // Create new DocumentModel with correct ID
        return DocumentModel(
          id: correctId, // Use the correct Firestore ID
          fileName: document.fileName,
          fileSize: document.fileSize,
          fileType: document.fileType,
          filePath: document.filePath,
          uploadedBy: document.uploadedBy,
          uploadedAt: document.uploadedAt,
          category: document.category,
          permissions: document.permissions,
          metadata: document.metadata,
        );
      }

      debugPrint(
        '⚠️ UnifiedIdSystem: Could not normalize document ID for ${document.fileName}',
      );
      return null;
    } catch (e) {
      debugPrint('❌ UnifiedIdSystem: Error normalizing document ID: $e');
      return null;
    }
  }

  /// Batch normalize a list of documents
  Future<List<DocumentModel>> normalizeDocumentIds(
    List<DocumentModel> documents,
  ) async {
    final normalizedDocuments = <DocumentModel>[];

    debugPrint(
      '🔄 UnifiedIdSystem: Normalizing ${documents.length} document IDs',
    );

    for (final document in documents) {
      final normalized = await normalizeDocumentId(document);
      if (normalized != null) {
        normalizedDocuments.add(normalized);
      } else {
        debugPrint(
          '⚠️ UnifiedIdSystem: Skipping document with unresolvable ID: ${document.fileName}',
        );
      }
    }

    debugPrint(
      '✅ UnifiedIdSystem: Normalized ${normalizedDocuments.length}/${documents.length} documents',
    );
    return normalizedDocuments;
  }

  /// Helper method to get content type from file type
  String _getContentTypeFromFileType(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
      case 'docx':
        return 'application/msword';
      case 'xls':
      case 'xlsx':
        return 'application/vnd.ms-excel';
      case 'ppt':
      case 'pptx':
        return 'application/vnd.ms-powerpoint';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'txt':
        return 'text/plain';
      default:
        return 'application/octet-stream';
    }
  }
}
