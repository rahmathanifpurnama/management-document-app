import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../core/services/firebase_service.dart';
import '../services/admin_permission_service.dart';
import '../utils/firebase_storage_url_parser.dart';
import '../models/document_model.dart';

/// Direct Firebase Storage Deletion Service
///
/// This service provides standalone file deletion functionality that:
/// - Works directly with Firebase Storage without Firestore dependencies
/// - Enforces admin-only deletion permissions
/// - Handles storage operations independently
/// - Provides comprehensive error handling for storage operations
class DirectStorageDeletionService {
  static DirectStorageDeletionService? _instance;
  static DirectStorageDeletionService get instance =>
      _instance ??= DirectStorageDeletionService._();

  DirectStorageDeletionService._();

  final FirebaseService _firebaseService = FirebaseService.instance;
  final AdminPermissionService _adminService = AdminPermissionService.instance;

  /// Delete a file directly from Firebase Storage using its download URL
  ///
  /// [downloadUrl] - The Firebase Storage download URL
  /// [forceDelete] - If true, bypasses some safety checks (admin only)
  ///
  /// Returns a [StorageDeletionResult] with operation details
  Future<StorageDeletionResult> deleteFileByUrl(
    String downloadUrl, {
    bool forceDelete = false,
  }) async {
    try {
      debugPrint('🗑️ Starting direct storage deletion by URL: $downloadUrl');

      // 1. Extract storage path from URL
      final storagePath = FirebaseStorageUrlParser.extractStoragePathFromUrl(
        downloadUrl,
      );
      if (storagePath == null) {
        return StorageDeletionResult.error(
          path: downloadUrl,
          message: 'Could not extract storage path from URL',
          errorCode: 'INVALID_URL',
        );
      }

      debugPrint('📁 Extracted storage path: $storagePath');

      // 2. Use existing deleteFileByPath method
      return await deleteFileByPath(storagePath, forceDelete: forceDelete);
    } catch (e) {
      debugPrint('❌ Direct storage deletion by URL failed: $e');
      return StorageDeletionResult.error(
        path: downloadUrl,
        message: 'URL-based deletion failed: ${e.toString()}',
        errorCode: 'URL_DELETION_FAILED',
      );
    }
  }

  /// Delete a document using DocumentModel (hybrid approach)
  ///
  /// This method tries multiple approaches in order:
  /// 1. Direct deletion using download URL if available
  /// 2. Direct deletion using filePath if available
  /// 3. Pattern-based search and deletion
  ///
  /// [document] - The DocumentModel containing file information
  /// [forceDelete] - If true, bypasses some safety checks (admin only)
  ///
  /// Returns a [StorageDeletionResult] with operation details
  Future<StorageDeletionResult> deleteDocumentDirect(
    DocumentModel document, {
    bool forceDelete = false,
  }) async {
    try {
      debugPrint('🗑️ Starting direct document deletion: ${document.fileName}');

      // Approach 1: Try deletion using download URL from metadata
      if (document.metadata.downloadUrl?.isNotEmpty == true) {
        debugPrint('🔗 Attempting deletion using download URL');
        final urlResult = await deleteFileByUrl(
          document.metadata.downloadUrl!,
          forceDelete: forceDelete,
        );
        if (urlResult.success) {
          debugPrint('✅ Successfully deleted using download URL');
          return urlResult;
        }
        debugPrint('⚠️ URL-based deletion failed: ${urlResult.message}');
      }

      // Approach 2: Try deletion using filePath
      if (document.filePath.isNotEmpty) {
        debugPrint(
          '📁 Attempting deletion using filePath: ${document.filePath}',
        );
        final pathResult = await deleteFileByPath(
          document.filePath,
          forceDelete: forceDelete,
        );
        if (pathResult.success) {
          debugPrint('✅ Successfully deleted using filePath');
          return pathResult;
        }
        debugPrint('⚠️ FilePath-based deletion failed: ${pathResult.message}');
      }

      // Approach 3: Pattern-based search and deletion
      debugPrint(
        '🔍 Attempting pattern-based deletion for: ${document.fileName}',
      );
      final patternResult = await deleteFilesByPattern(
        document.fileName,
        exactMatch: true,
      );

      if (patternResult.successCount > 0) {
        debugPrint('✅ Successfully deleted using pattern search');
        return StorageDeletionResult.success(
          path: 'pattern:${document.fileName}',
          fileName: document.fileName,
          message:
              'File deleted using pattern search (${patternResult.successCount} files)',
        );
      }

      // All approaches failed
      return StorageDeletionResult.error(
        path: document.filePath.isNotEmpty
            ? document.filePath
            : document.fileName,
        message: 'All deletion approaches failed for ${document.fileName}',
        errorCode: 'ALL_APPROACHES_FAILED',
      );
    } catch (e) {
      debugPrint('❌ Direct document deletion failed: $e');
      return StorageDeletionResult.error(
        path: document.fileName,
        message: 'Document deletion failed: ${e.toString()}',
        errorCode: 'DOCUMENT_DELETION_FAILED',
      );
    }
  }

  /// Delete a file directly from Firebase Storage using its full path
  ///
  /// [storagePath] - The full path to the file in Firebase Storage (e.g., 'documents/user123/file.pdf')
  /// [forceDelete] - If true, bypasses some safety checks (admin only)
  ///
  /// Returns a [StorageDeletionResult] with operation details
  Future<StorageDeletionResult> deleteFileByPath(
    String storagePath, {
    bool forceDelete = false,
  }) async {
    try {
      debugPrint('🗑️ Starting direct storage deletion for: $storagePath');

      // 1. Verify admin permissions
      final permissionResult = await _verifyAdminPermissions();
      if (!permissionResult.isAuthorized) {
        return StorageDeletionResult.unauthorized(
          path: storagePath,
          message: permissionResult.message,
        );
      }

      // 2. Validate storage path
      final validationResult = _validateStoragePath(storagePath);
      if (!validationResult.isValid) {
        return StorageDeletionResult.error(
          path: storagePath,
          message: validationResult.message,
          errorCode: 'INVALID_PATH',
        );
      }

      // 3. Check if file exists (unless force delete)
      if (!forceDelete) {
        final existsResult = await _checkFileExists(storagePath);
        if (!existsResult.exists) {
          return StorageDeletionResult.notFound(
            path: storagePath,
            message: existsResult.message,
          );
        }
      }

      // 4. Perform the deletion
      final deletionResult = await _performStorageDeletion(storagePath);

      debugPrint('✅ Direct storage deletion completed for: $storagePath');
      return deletionResult;
    } catch (e) {
      debugPrint('❌ Direct storage deletion failed for $storagePath: $e');
      return StorageDeletionResult.error(
        path: storagePath,
        message: 'Unexpected error during deletion: ${e.toString()}',
        errorCode: 'DELETION_FAILED',
      );
    }
  }

  /// Delete multiple files by their download URLs
  ///
  /// [downloadUrls] - List of Firebase Storage download URLs
  /// [continueOnError] - If true, continues deleting other files even if some fail
  ///
  /// Returns a [BatchDeletionResult] with details for each file
  Future<BatchDeletionResult> deleteMultipleFilesByUrl(
    List<String> downloadUrls, {
    bool continueOnError = true,
  }) async {
    try {
      debugPrint(
        '🗑️ Starting batch storage deletion by URL for ${downloadUrls.length} files',
      );

      // Verify admin permissions once for the batch
      final permissionResult = await _verifyAdminPermissions();
      if (!permissionResult.isAuthorized) {
        return BatchDeletionResult.unauthorized(
          paths: downloadUrls,
          message: permissionResult.message,
        );
      }

      final results = <StorageDeletionResult>[];
      int successCount = 0;
      int failureCount = 0;

      for (final url in downloadUrls) {
        try {
          final result = await deleteFileByUrl(url, forceDelete: false);
          results.add(result);

          if (result.success) {
            successCount++;
          } else {
            failureCount++;
            if (!continueOnError) {
              debugPrint(
                '❌ Stopping batch URL deletion due to error: ${result.message}',
              );
              break;
            }
          }
        } catch (e) {
          failureCount++;
          results.add(
            StorageDeletionResult.error(
              path: url,
              message: 'Batch URL deletion error: ${e.toString()}',
              errorCode: 'BATCH_URL_ERROR',
            ),
          );

          if (!continueOnError) {
            debugPrint('❌ Stopping batch URL deletion due to exception: $e');
            break;
          }
        }
      }

      debugPrint(
        '✅ Batch URL deletion completed: $successCount success, $failureCount failures',
      );

      return BatchDeletionResult(
        results: results,
        totalFiles: downloadUrls.length,
        successCount: successCount,
        failureCount: failureCount,
        completed: true,
      );
    } catch (e) {
      debugPrint('❌ Batch URL deletion failed: $e');
      return BatchDeletionResult.error(
        paths: downloadUrls,
        message: 'Batch URL deletion failed: ${e.toString()}',
      );
    }
  }

  /// Delete multiple documents using DocumentModel list (hybrid approach)
  ///
  /// [documents] - List of DocumentModel objects to delete
  /// [continueOnError] - If true, continues deleting other files even if some fail
  ///
  /// Returns a [BatchDeletionResult] with details for each file
  Future<BatchDeletionResult> deleteMultipleDocumentsDirect(
    List<DocumentModel> documents, {
    bool continueOnError = true,
  }) async {
    try {
      debugPrint(
        '🗑️ Starting batch direct document deletion for ${documents.length} documents',
      );

      // Verify admin permissions once for the batch
      final permissionResult = await _verifyAdminPermissions();
      if (!permissionResult.isAuthorized) {
        return BatchDeletionResult.unauthorized(
          paths: documents.map((d) => d.fileName).toList(),
          message: permissionResult.message,
        );
      }

      final results = <StorageDeletionResult>[];
      int successCount = 0;
      int failureCount = 0;

      for (final document in documents) {
        try {
          final result = await deleteDocumentDirect(
            document,
            forceDelete: false,
          );
          results.add(result);

          if (result.success) {
            successCount++;
          } else {
            failureCount++;
            if (!continueOnError) {
              debugPrint(
                '❌ Stopping batch document deletion due to error: ${result.message}',
              );
              break;
            }
          }
        } catch (e) {
          failureCount++;
          results.add(
            StorageDeletionResult.error(
              path: document.fileName,
              message: 'Batch document deletion error: ${e.toString()}',
              errorCode: 'BATCH_DOCUMENT_ERROR',
            ),
          );

          if (!continueOnError) {
            debugPrint(
              '❌ Stopping batch document deletion due to exception: $e',
            );
            break;
          }
        }
      }

      debugPrint(
        '✅ Batch document deletion completed: $successCount success, $failureCount failures',
      );

      return BatchDeletionResult(
        results: results,
        totalFiles: documents.length,
        successCount: successCount,
        failureCount: failureCount,
        completed: true,
      );
    } catch (e) {
      debugPrint('❌ Batch document deletion failed: $e');
      return BatchDeletionResult.error(
        paths: documents.map((d) => d.fileName).toList(),
        message: 'Batch document deletion failed: ${e.toString()}',
      );
    }
  }

  /// Delete multiple files by their storage paths
  ///
  /// [storagePaths] - List of full paths to files in Firebase Storage
  /// [continueOnError] - If true, continues deleting other files even if some fail
  ///
  /// Returns a [BatchDeletionResult] with details for each file
  Future<BatchDeletionResult> deleteMultipleFilesByPath(
    List<String> storagePaths, {
    bool continueOnError = true,
  }) async {
    try {
      debugPrint(
        '🗑️ Starting batch storage deletion for ${storagePaths.length} files',
      );

      // Verify admin permissions once for the batch
      final permissionResult = await _verifyAdminPermissions();
      if (!permissionResult.isAuthorized) {
        return BatchDeletionResult.unauthorized(
          paths: storagePaths,
          message: permissionResult.message,
        );
      }

      final results = <StorageDeletionResult>[];
      int successCount = 0;
      int failureCount = 0;

      for (final path in storagePaths) {
        try {
          final result = await deleteFileByPath(path, forceDelete: false);
          results.add(result);

          if (result.success) {
            successCount++;
          } else {
            failureCount++;
            if (!continueOnError) {
              debugPrint(
                '❌ Stopping batch deletion due to error: ${result.message}',
              );
              break;
            }
          }
        } catch (e) {
          failureCount++;
          results.add(
            StorageDeletionResult.error(
              path: path,
              message: 'Batch deletion error: ${e.toString()}',
              errorCode: 'BATCH_ERROR',
            ),
          );

          if (!continueOnError) {
            debugPrint('❌ Stopping batch deletion due to exception: $e');
            break;
          }
        }
      }

      debugPrint(
        '✅ Batch storage deletion completed: $successCount success, $failureCount failures',
      );

      return BatchDeletionResult(
        results: results,
        totalFiles: storagePaths.length,
        successCount: successCount,
        failureCount: failureCount,
        completed: true,
      );
    } catch (e) {
      debugPrint('❌ Batch storage deletion failed: $e');
      return BatchDeletionResult.error(
        paths: storagePaths,
        message: 'Batch deletion failed: ${e.toString()}',
      );
    }
  }

  /// Find and delete files by filename pattern
  ///
  /// [filenamePattern] - Pattern to match against filenames
  /// [searchPath] - Root path to search in (defaults to 'documents')
  /// [exactMatch] - If true, requires exact filename match
  ///
  /// Returns a [BatchDeletionResult] with details for found and deleted files
  Future<BatchDeletionResult> deleteFilesByPattern(
    String filenamePattern, {
    String searchPath = 'documents',
    bool exactMatch = false,
  }) async {
    try {
      debugPrint('🔍 Searching for files matching pattern: $filenamePattern');

      // Verify admin permissions
      final permissionResult = await _verifyAdminPermissions();
      if (!permissionResult.isAuthorized) {
        return BatchDeletionResult.unauthorized(
          paths: [],
          message: permissionResult.message,
        );
      }

      // Find matching files
      final matchingPaths = await _findFilesByPattern(
        filenamePattern,
        searchPath,
        exactMatch,
      );

      if (matchingPaths.isEmpty) {
        debugPrint('ℹ️ No files found matching pattern: $filenamePattern');
        return BatchDeletionResult(
          results: [],
          totalFiles: 0,
          successCount: 0,
          failureCount: 0,
          completed: true,
        );
      }

      debugPrint('🎯 Found ${matchingPaths.length} files matching pattern');

      // Delete the matching files
      return await deleteMultipleFilesByPath(matchingPaths);
    } catch (e) {
      debugPrint('❌ Pattern-based deletion failed: $e');
      return BatchDeletionResult.error(
        paths: [],
        message: 'Pattern deletion failed: ${e.toString()}',
      );
    }
  }

  /// Get file information without deleting it
  ///
  /// [storagePath] - The full path to the file in Firebase Storage
  ///
  /// Returns a [StorageFileInfo] with file details
  Future<StorageFileInfo> getFileInfo(String storagePath) async {
    try {
      debugPrint('ℹ️ Getting file info for: $storagePath');

      // Verify admin permissions
      final permissionResult = await _verifyAdminPermissions();
      if (!permissionResult.isAuthorized) {
        return StorageFileInfo.unauthorized(
          path: storagePath,
          message: permissionResult.message,
        );
      }

      // Get file reference
      final fileRef = _firebaseService.storage.ref().child(storagePath);

      // Get metadata
      final metadata = await fileRef.getMetadata();

      return StorageFileInfo.success(
        path: storagePath,
        name: fileRef.name,
        size: metadata.size ?? 0,
        contentType: metadata.contentType ?? 'unknown',
        timeCreated: metadata.timeCreated,
        customMetadata: metadata.customMetadata ?? {},
      );
    } catch (e) {
      debugPrint('❌ Failed to get file info for $storagePath: $e');

      if (e is FirebaseException && e.code == 'object-not-found') {
        return StorageFileInfo.notFound(
          path: storagePath,
          message: 'File not found in storage',
        );
      }

      return StorageFileInfo.error(
        path: storagePath,
        message: 'Failed to get file info: ${e.toString()}',
      );
    }
  }

  // ========== PRIVATE HELPER METHODS ==========

  /// Verify that the current user has admin permissions
  Future<AdminPermissionResult> _verifyAdminPermissions() async {
    try {
      final currentUser = _firebaseService.auth.currentUser;
      if (currentUser == null) {
        return AdminPermissionResult(
          isAuthorized: false,
          message: 'User not authenticated',
        );
      }

      final isAdmin = await _adminService.isCurrentUserAdmin();
      if (!isAdmin) {
        return AdminPermissionResult(
          isAuthorized: false,
          message: 'Admin privileges required for file deletion',
        );
      }

      return AdminPermissionResult(
        isAuthorized: true,
        message: 'Admin permissions verified',
        userId: currentUser.uid,
      );
    } catch (e) {
      debugPrint('❌ Error verifying admin permissions: $e');
      return AdminPermissionResult(
        isAuthorized: false,
        message: 'Failed to verify admin permissions: ${e.toString()}',
      );
    }
  }

  /// Validate the storage path format
  PathValidationResult _validateStoragePath(String storagePath) {
    if (storagePath.isEmpty) {
      return PathValidationResult(
        isValid: false,
        message: 'Storage path cannot be empty',
      );
    }

    if (storagePath.startsWith('/') || storagePath.endsWith('/')) {
      return PathValidationResult(
        isValid: false,
        message: 'Storage path should not start or end with forward slash',
      );
    }

    if (storagePath.contains('..')) {
      return PathValidationResult(
        isValid: false,
        message: 'Storage path contains invalid characters (..)',
      );
    }

    // Check for valid file extension
    if (!storagePath.contains('.')) {
      return PathValidationResult(
        isValid: false,
        message: 'Storage path should include file extension',
      );
    }

    return PathValidationResult(
      isValid: true,
      message: 'Storage path is valid',
    );
  }

  /// Check if a file exists in Firebase Storage
  Future<FileExistenceResult> _checkFileExists(String storagePath) async {
    try {
      final fileRef = _firebaseService.storage.ref().child(storagePath);

      // Try to get metadata to check existence
      await fileRef.getMetadata();

      return FileExistenceResult(
        exists: true,
        message: 'File exists in storage',
      );
    } catch (e) {
      if (e is FirebaseException && e.code == 'object-not-found') {
        return FileExistenceResult(
          exists: false,
          message: 'File not found in storage',
        );
      }

      debugPrint('❌ Error checking file existence: $e');
      return FileExistenceResult(
        exists: false,
        message: 'Error checking file existence: ${e.toString()}',
      );
    }
  }

  /// Perform the actual storage deletion
  Future<StorageDeletionResult> _performStorageDeletion(
    String storagePath,
  ) async {
    try {
      final fileRef = _firebaseService.storage.ref().child(storagePath);

      // Get file info before deletion for logging
      String fileName = fileRef.name;
      int? fileSize;

      try {
        final metadata = await fileRef.getMetadata();
        fileSize = metadata.size;
      } catch (e) {
        debugPrint('⚠️ Could not get file metadata before deletion: $e');
      }

      // Perform the deletion
      await fileRef.delete();

      debugPrint(
        '✅ Successfully deleted file: $fileName (${fileSize ?? 'unknown'} bytes)',
      );

      return StorageDeletionResult.success(
        path: storagePath,
        fileName: fileName,
        fileSize: fileSize,
        message: 'File successfully deleted from storage',
      );
    } catch (e) {
      debugPrint('❌ Storage deletion failed for $storagePath: $e');

      String errorCode = 'DELETION_FAILED';
      String message = 'Failed to delete file from storage';

      if (e is FirebaseException) {
        errorCode = e.code;
        message = e.message ?? message;
      }

      return StorageDeletionResult.error(
        path: storagePath,
        message: '$message: ${e.toString()}',
        errorCode: errorCode,
      );
    }
  }

  /// Find files by filename pattern in storage
  Future<List<String>> _findFilesByPattern(
    String filenamePattern,
    String searchPath,
    bool exactMatch,
  ) async {
    final matchingPaths = <String>[];

    try {
      final searchRef = _firebaseService.storage.ref().child(searchPath);
      await _searchFolderRecursively(
        searchRef,
        filenamePattern,
        exactMatch,
        matchingPaths,
      );
    } catch (e) {
      debugPrint('❌ Error searching for files by pattern: $e');
    }

    return matchingPaths;
  }

  /// Recursively search folders for matching files
  Future<void> _searchFolderRecursively(
    Reference folderRef,
    String pattern,
    bool exactMatch,
    List<String> matchingPaths,
  ) async {
    try {
      final listResult = await folderRef.listAll();

      // Check files in current folder
      for (final item in listResult.items) {
        final fileName = item.name;
        bool matches = false;

        if (exactMatch) {
          matches = fileName == pattern;
        } else {
          matches = fileName.toLowerCase().contains(pattern.toLowerCase());
        }

        if (matches) {
          matchingPaths.add(item.fullPath);
          debugPrint('🎯 Found matching file: ${item.fullPath}');
        }
      }

      // Recursively search subfolders
      for (final prefix in listResult.prefixes) {
        await _searchFolderRecursively(
          prefix,
          pattern,
          exactMatch,
          matchingPaths,
        );
      }
    } catch (e) {
      debugPrint('⚠️ Error searching folder ${folderRef.fullPath}: $e');
    }
  }
}

// ========== RESULT CLASSES ==========

/// Result of admin permission verification
class AdminPermissionResult {
  final bool isAuthorized;
  final String message;
  final String? userId;

  AdminPermissionResult({
    required this.isAuthorized,
    required this.message,
    this.userId,
  });
}

/// Result of storage path validation
class PathValidationResult {
  final bool isValid;
  final String message;

  PathValidationResult({required this.isValid, required this.message});
}

/// Result of file existence check
class FileExistenceResult {
  final bool exists;
  final String message;

  FileExistenceResult({required this.exists, required this.message});
}

/// Result of storage deletion operation
class StorageDeletionResult {
  final bool success;
  final String path;
  final String message;
  final String? errorCode;
  final String? fileName;
  final int? fileSize;
  final DateTime timestamp;

  StorageDeletionResult({
    required this.success,
    required this.path,
    required this.message,
    this.errorCode,
    this.fileName,
    this.fileSize,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Create a successful deletion result
  factory StorageDeletionResult.success({
    required String path,
    required String message,
    String? fileName,
    int? fileSize,
  }) {
    return StorageDeletionResult(
      success: true,
      path: path,
      message: message,
      fileName: fileName,
      fileSize: fileSize,
    );
  }

  /// Create an error deletion result
  factory StorageDeletionResult.error({
    required String path,
    required String message,
    String? errorCode,
  }) {
    return StorageDeletionResult(
      success: false,
      path: path,
      message: message,
      errorCode: errorCode,
    );
  }

  /// Create an unauthorized deletion result
  factory StorageDeletionResult.unauthorized({
    required String path,
    required String message,
  }) {
    return StorageDeletionResult(
      success: false,
      path: path,
      message: message,
      errorCode: 'UNAUTHORIZED',
    );
  }

  /// Create a not found deletion result
  factory StorageDeletionResult.notFound({
    required String path,
    required String message,
  }) {
    return StorageDeletionResult(
      success: false,
      path: path,
      message: message,
      errorCode: 'NOT_FOUND',
    );
  }
}

/// Result of batch deletion operation
class BatchDeletionResult {
  final List<StorageDeletionResult> results;
  final int totalFiles;
  final int successCount;
  final int failureCount;
  final bool completed;
  final String? errorMessage;
  final DateTime timestamp;

  BatchDeletionResult({
    required this.results,
    required this.totalFiles,
    required this.successCount,
    required this.failureCount,
    required this.completed,
    this.errorMessage,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Create an unauthorized batch deletion result
  factory BatchDeletionResult.unauthorized({
    required List<String> paths,
    required String message,
  }) {
    return BatchDeletionResult(
      results: paths
          .map(
            (path) => StorageDeletionResult.unauthorized(
              path: path,
              message: message,
            ),
          )
          .toList(),
      totalFiles: paths.length,
      successCount: 0,
      failureCount: paths.length,
      completed: true,
      errorMessage: message,
    );
  }

  /// Create an error batch deletion result
  factory BatchDeletionResult.error({
    required List<String> paths,
    required String message,
  }) {
    return BatchDeletionResult(
      results: paths
          .map(
            (path) => StorageDeletionResult.error(
              path: path,
              message: message,
              errorCode: 'BATCH_ERROR',
            ),
          )
          .toList(),
      totalFiles: paths.length,
      successCount: 0,
      failureCount: paths.length,
      completed: false,
      errorMessage: message,
    );
  }

  /// Get overall success status
  bool get success => failureCount == 0 && completed;

  /// Get list of successful deletions
  List<StorageDeletionResult> get successfulDeletions =>
      results.where((r) => r.success).toList();

  /// Get list of failed deletions
  List<StorageDeletionResult> get failedDeletions =>
      results.where((r) => !r.success).toList();
}

/// Information about a storage file
class StorageFileInfo {
  final bool success;
  final String path;
  final String message;
  final String? name;
  final int? size;
  final String? contentType;
  final DateTime? timeCreated;
  final Map<String, String>? customMetadata;
  final String? errorCode;
  final DateTime timestamp;

  StorageFileInfo({
    required this.success,
    required this.path,
    required this.message,
    this.name,
    this.size,
    this.contentType,
    this.timeCreated,
    this.customMetadata,
    this.errorCode,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Create a successful file info result
  factory StorageFileInfo.success({
    required String path,
    required String name,
    required int size,
    required String contentType,
    DateTime? timeCreated,
    Map<String, String>? customMetadata,
  }) {
    return StorageFileInfo(
      success: true,
      path: path,
      message: 'File information retrieved successfully',
      name: name,
      size: size,
      contentType: contentType,
      timeCreated: timeCreated,
      customMetadata: customMetadata,
    );
  }

  /// Create an unauthorized file info result
  factory StorageFileInfo.unauthorized({
    required String path,
    required String message,
  }) {
    return StorageFileInfo(
      success: false,
      path: path,
      message: message,
      errorCode: 'UNAUTHORIZED',
    );
  }

  /// Create a not found file info result
  factory StorageFileInfo.notFound({
    required String path,
    required String message,
  }) {
    return StorageFileInfo(
      success: false,
      path: path,
      message: message,
      errorCode: 'NOT_FOUND',
    );
  }

  /// Create an error file info result
  factory StorageFileInfo.error({
    required String path,
    required String message,
  }) {
    return StorageFileInfo(
      success: false,
      path: path,
      message: message,
      errorCode: 'ERROR',
    );
  }

  /// Get formatted file size
  String get formattedSize {
    if (size == null) return 'Unknown';

    const units = ['B', 'KB', 'MB', 'GB'];
    double fileSize = size!.toDouble();
    int unitIndex = 0;

    while (fileSize >= 1024 && unitIndex < units.length - 1) {
      fileSize /= 1024;
      unitIndex++;
    }

    return '${fileSize.toStringAsFixed(1)} ${units[unitIndex]}';
  }
}
