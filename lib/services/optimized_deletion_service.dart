import 'package:flutter/foundation.dart';
import '../models/document_model.dart';
import '../services/direct_storage_deletion_service.dart';
import '../core/services/document_service.dart';
import '../core/services/firebase_service.dart';
import '../utils/firebase_storage_url_parser.dart';

/// Optimized Deletion Service with STORAGE-FIRST approach and comprehensive error handling
///
/// This service provides a storage-first approach to file deletion:
/// 1. PRIORITY: Deletes from Firebase Storage FIRST using direct storage access
/// 2. SECONDARY: Cleans up Firestore metadata AFTER storage deletion
/// 3. FALLBACK: Falls back to traditional Firestore-based deletion if direct storage fails
/// 4. Provides comprehensive error handling and recovery
/// 5. Maintains admin-only permissions throughout
class OptimizedDeletionService {
  static final OptimizedDeletionService _instance =
      OptimizedDeletionService._internal();
  static OptimizedDeletionService get instance => _instance;
  OptimizedDeletionService._internal();

  final DirectStorageDeletionService _directStorageService =
      DirectStorageDeletionService.instance;
  final DocumentService _documentService = DocumentService.instance;
  final FirebaseService _firebaseService = FirebaseService.instance;

  /// Delete a document using the optimized hybrid approach
  ///
  /// [document] - The DocumentModel to delete
  /// [deletedBy] - User ID of the person performing the deletion
  /// [forceTraditional] - If true, skips direct deletion and uses traditional method
  ///
  /// Returns [OptimizedDeletionResult] with detailed operation information
  Future<OptimizedDeletionResult> deleteDocument(
    DocumentModel document,
    String deletedBy, {
    bool forceTraditional = false,
  }) async {
    final startTime = DateTime.now();
    debugPrint(
      '🗑️ OptimizedDeletionService: Starting deletion for ${document.fileName}',
    );

    try {
      // Verify admin permissions first
      final isAdmin = await _verifyAdminPermissions(deletedBy);
      if (!isAdmin) {
        return OptimizedDeletionResult.unauthorized(
          documentId: document.id,
          fileName: document.fileName,
          message: 'Access denied: Only administrators can delete files',
        );
      }

      // Choose deletion strategy
      if (forceTraditional) {
        debugPrint('🔄 Using traditional deletion method (forced)');
        return await _performTraditionalDeletion(
          document,
          deletedBy,
          startTime,
        );
      }

      // Try optimized deletion first
      final optimizedResult = await _attemptOptimizedDeletion(
        document,
        deletedBy,
        startTime,
      );
      if (optimizedResult.success) {
        return optimizedResult;
      }

      // Fall back to traditional deletion
      debugPrint(
        '⚠️ Optimized deletion failed, falling back to traditional method',
      );
      return await _performTraditionalDeletion(document, deletedBy, startTime);
    } catch (e) {
      debugPrint(
        '❌ OptimizedDeletionService: Unexpected error during deletion: $e',
      );
      return OptimizedDeletionResult.error(
        documentId: document.id,
        fileName: document.fileName,
        message: 'Unexpected error during deletion: ${e.toString()}',
        errorCode: 'UNEXPECTED_ERROR',
        duration: DateTime.now().difference(startTime),
      );
    }
  }

  /// Delete a document by URL (when only download URL is available)
  ///
  /// [downloadUrl] - Firebase Storage download URL
  /// [deletedBy] - User ID of the person performing the deletion
  ///
  /// Returns [OptimizedDeletionResult] with detailed operation information
  Future<OptimizedDeletionResult> deleteDocumentByUrl(
    String downloadUrl,
    String deletedBy,
  ) async {
    final startTime = DateTime.now();
    debugPrint('🗑️ OptimizedDeletionService: Starting URL-based deletion');

    try {
      // Verify admin permissions
      final isAdmin = await _verifyAdminPermissions(deletedBy);
      if (!isAdmin) {
        return OptimizedDeletionResult.unauthorized(
          documentId: 'url-based',
          fileName:
              FirebaseStorageUrlParser.getFileName(downloadUrl) ?? 'unknown',
          message: 'Access denied: Only administrators can delete files',
        );
      }

      // Extract storage path from URL
      final storagePath = FirebaseStorageUrlParser.extractStoragePathFromUrl(
        downloadUrl,
      );
      if (storagePath == null) {
        return OptimizedDeletionResult.error(
          documentId: 'url-based',
          fileName: 'unknown',
          message: 'Could not extract storage path from URL',
          errorCode: 'INVALID_URL',
          duration: DateTime.now().difference(startTime),
        );
      }

      // Perform direct storage deletion
      final directResult = await _directStorageService.deleteFileByPath(
        storagePath,
      );

      if (directResult.success) {
        debugPrint('✅ URL-based deletion completed successfully');
        return OptimizedDeletionResult.success(
          documentId: 'url-based',
          fileName:
              directResult.fileName ??
              FirebaseStorageUrlParser.getFileName(downloadUrl) ??
              'unknown',
          message: 'File deleted successfully using URL-based deletion',
          method: DeletionMethod.directUrl,
          duration: DateTime.now().difference(startTime),
          storageDeleted: true,
          firestoreDeleted: false, // No Firestore cleanup for URL-only deletion
        );
      } else {
        return OptimizedDeletionResult.error(
          documentId: 'url-based',
          fileName:
              FirebaseStorageUrlParser.getFileName(downloadUrl) ?? 'unknown',
          message: 'URL-based deletion failed: ${directResult.message}',
          errorCode: directResult.errorCode ?? 'URL_DELETION_FAILED',
          duration: DateTime.now().difference(startTime),
        );
      }
    } catch (e) {
      debugPrint('❌ OptimizedDeletionService: URL-based deletion error: $e');
      return OptimizedDeletionResult.error(
        documentId: 'url-based',
        fileName:
            FirebaseStorageUrlParser.getFileName(downloadUrl) ?? 'unknown',
        message: 'URL-based deletion error: ${e.toString()}',
        errorCode: 'URL_DELETION_ERROR',
        duration: DateTime.now().difference(startTime),
      );
    }
  }

  /// Attempt optimized deletion using STORAGE-FIRST approach
  /// Deletes from Firebase Storage first, then cleans up Firestore metadata
  Future<OptimizedDeletionResult> _attemptOptimizedDeletion(
    DocumentModel document,
    String deletedBy,
    DateTime startTime,
  ) async {
    try {
      debugPrint('🚀 Attempting STORAGE-FIRST optimized deletion...');

      // STEP 1: Delete from Firebase Storage FIRST (priority)
      debugPrint(
        '🗑️ STEP 1: Deleting file from Firebase Storage (PRIORITY)...',
      );
      final directResult = await _directStorageService.deleteDocumentDirect(
        document,
      );

      if (directResult.success) {
        debugPrint('✅ Direct storage deletion successful');

        // STEP 2: Clean up Firestore metadata AFTER storage deletion
        debugPrint('🗑️ STEP 2: Cleaning up Firestore metadata (SECONDARY)...');
        bool firestoreDeleted = false;
        try {
          await _firebaseService.documentsCollection.doc(document.id).delete();
          firestoreDeleted = true;
          debugPrint('✅ Firestore metadata cleanup completed');
        } catch (firestoreError) {
          debugPrint(
            '⚠️ Firestore cleanup failed (non-critical): $firestoreError',
          );
          // Non-critical error - storage deletion was successful
        }

        return OptimizedDeletionResult.success(
          documentId: document.id,
          fileName: document.fileName,
          message:
              'File deleted successfully using optimized direct storage deletion',
          method: DeletionMethod.directStorage,
          duration: DateTime.now().difference(startTime),
          storageDeleted: true,
          firestoreDeleted: firestoreDeleted,
        );
      } else {
        debugPrint(
          '⚠️ Direct storage deletion failed: ${directResult.message}',
        );
        return OptimizedDeletionResult.error(
          documentId: document.id,
          fileName: document.fileName,
          message: 'Direct storage deletion failed: ${directResult.message}',
          errorCode: directResult.errorCode ?? 'DIRECT_DELETION_FAILED',
          duration: DateTime.now().difference(startTime),
        );
      }
    } catch (e) {
      debugPrint('❌ Optimized deletion attempt failed: $e');
      return OptimizedDeletionResult.error(
        documentId: document.id,
        fileName: document.fileName,
        message: 'Optimized deletion attempt failed: ${e.toString()}',
        errorCode: 'OPTIMIZED_DELETION_ERROR',
        duration: DateTime.now().difference(startTime),
      );
    }
  }

  /// Perform traditional deletion using DocumentService
  Future<OptimizedDeletionResult> _performTraditionalDeletion(
    DocumentModel document,
    String deletedBy,
    DateTime startTime,
  ) async {
    try {
      debugPrint('🔄 Performing traditional DocumentService deletion...');

      await _documentService.deleteDocument(document.id, deletedBy);

      debugPrint('✅ Traditional deletion completed successfully');
      return OptimizedDeletionResult.success(
        documentId: document.id,
        fileName: document.fileName,
        message: 'File deleted successfully using traditional method',
        method: DeletionMethod.traditional,
        duration: DateTime.now().difference(startTime),
        storageDeleted: true,
        firestoreDeleted: true,
      );
    } catch (e) {
      debugPrint('❌ Traditional deletion failed: $e');

      // Handle specific error cases
      if (e.toString().contains('Document not found')) {
        return OptimizedDeletionResult.success(
          documentId: document.id,
          fileName: document.fileName,
          message: 'Document not found in backend - cleanup completed',
          method: DeletionMethod.notFoundCleanup,
          duration: DateTime.now().difference(startTime),
          storageDeleted: false,
          firestoreDeleted: false,
        );
      }

      return OptimizedDeletionResult.error(
        documentId: document.id,
        fileName: document.fileName,
        message: 'Traditional deletion failed: ${e.toString()}',
        errorCode: 'TRADITIONAL_DELETION_FAILED',
        duration: DateTime.now().difference(startTime),
      );
    }
  }

  /// Verify admin permissions for deletion
  Future<bool> _verifyAdminPermissions(String userId) async {
    try {
      // Get user document from Firestore
      final userDoc = await _firebaseService.firestore
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        debugPrint('⚠️ User document not found: $userId');
        return false;
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final isAdmin = userData['isAdmin'] as bool? ?? false;

      debugPrint('🔐 Admin verification for $userId: $isAdmin');
      return isAdmin;
    } catch (e) {
      debugPrint('❌ Error verifying admin permissions: $e');
      return false;
    }
  }
}

/// Enumeration of deletion methods
enum DeletionMethod { directStorage, directUrl, traditional, notFoundCleanup }

/// Result of optimized deletion operation
class OptimizedDeletionResult {
  final bool success;
  final String documentId;
  final String fileName;
  final String message;
  final DeletionMethod? method;
  final Duration duration;
  final bool storageDeleted;
  final bool firestoreDeleted;
  final String? errorCode;
  final DateTime timestamp;

  OptimizedDeletionResult({
    required this.success,
    required this.documentId,
    required this.fileName,
    required this.message,
    this.method,
    required this.duration,
    this.storageDeleted = false,
    this.firestoreDeleted = false,
    this.errorCode,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Create a successful deletion result
  factory OptimizedDeletionResult.success({
    required String documentId,
    required String fileName,
    required String message,
    required DeletionMethod method,
    required Duration duration,
    required bool storageDeleted,
    required bool firestoreDeleted,
  }) {
    return OptimizedDeletionResult(
      success: true,
      documentId: documentId,
      fileName: fileName,
      message: message,
      method: method,
      duration: duration,
      storageDeleted: storageDeleted,
      firestoreDeleted: firestoreDeleted,
    );
  }

  /// Create an error deletion result
  factory OptimizedDeletionResult.error({
    required String documentId,
    required String fileName,
    required String message,
    required String errorCode,
    required Duration duration,
  }) {
    return OptimizedDeletionResult(
      success: false,
      documentId: documentId,
      fileName: fileName,
      message: message,
      duration: duration,
      errorCode: errorCode,
    );
  }

  /// Create an unauthorized deletion result
  factory OptimizedDeletionResult.unauthorized({
    required String documentId,
    required String fileName,
    required String message,
  }) {
    return OptimizedDeletionResult(
      success: false,
      documentId: documentId,
      fileName: fileName,
      message: message,
      duration: Duration.zero,
      errorCode: 'UNAUTHORIZED',
    );
  }

  /// Get human-readable method name
  String get methodName {
    switch (method) {
      case DeletionMethod.directStorage:
        return 'Direct Storage';
      case DeletionMethod.directUrl:
        return 'Direct URL';
      case DeletionMethod.traditional:
        return 'Traditional';
      case DeletionMethod.notFoundCleanup:
        return 'Not Found Cleanup';
      default:
        return 'Unknown';
    }
  }

  /// Get formatted duration
  String get formattedDuration {
    if (duration.inMilliseconds < 1000) {
      return '${duration.inMilliseconds}ms';
    } else {
      return '${(duration.inMilliseconds / 1000).toStringAsFixed(1)}s';
    }
  }
}
