import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import '../core/services/firebase_service.dart';

/// Service for managing Firebase Storage category folder structure
class FirebaseStorageCategoryService {
  final FirebaseService _firebaseService = FirebaseService.instance;

  /// Create a category folder in Firebase Storage (DEPRECATED - No longer used)
  /// This method is kept for backward compatibility but should not be called
  @Deprecated('Use metadata-based categorization instead of physical folders')
  Future<void> createCategoryFolder(
    String categoryId,
    String categoryName,
  ) async {
    // No longer create physical folders - use metadata-based categorization
    debugPrint(
      '⚠️ createCategoryFolder is deprecated - using metadata-based categorization',
    );
    return;
  }

  /// Delete a category folder and all its contents
  Future<void> deleteCategoryFolder(
    String categoryId,
    String categoryName,
  ) async {
    try {
      final sanitizedName = _sanitizeFolderName(categoryName);
      final folderPath = 'documents/$categoryId-$sanitizedName';

      // List all files in the category folder
      final folderRef = _firebaseService.storage.ref().child(folderPath);
      final listResult = await folderRef.listAll();

      // Delete all files in the folder
      for (final item in listResult.items) {
        await item.delete();
        debugPrint('🗑️ Deleted file: ${item.name}');
      }

      debugPrint('✅ Deleted category folder: $folderPath');
    } catch (e) {
      debugPrint('❌ Failed to delete category folder: $e');
      rethrow;
    }
  }

  /// Update file category metadata (no physical move needed)
  Future<String> moveFileToCategory(
    String currentFilePath,
    String categoryId,
    String categoryName,
    String fileName,
  ) async {
    try {
      debugPrint('🔍 Starting file categorization process...');
      debugPrint('   File Path: $currentFilePath');
      debugPrint('   Category ID: $categoryId');
      debugPrint('   Category Name: $categoryName');
      debugPrint('   File Name: $fileName');

      // Step 1: Validate file existence with detailed logging
      final fileRef = await _validateAndGetFileReference(
        currentFilePath,
        fileName,
      );

      if (fileRef == null) {
        throw Exception(
          'File not found in Firebase Storage. '
          'Path: $currentFilePath, FileName: $fileName',
        );
      }

      debugPrint('✅ File reference validated: ${fileRef.fullPath}');

      // Step 2: Get current metadata with error handling
      final metadata = await _getFileMetadataWithRetry(fileRef);

      // Step 3: Update metadata with category information
      final updatedMetadata = SettableMetadata(
        contentType: metadata.contentType,
        customMetadata: {
          ...metadata.customMetadata ?? {},
          'categoryId': categoryId,
          'categoryName': categoryName,
          'movedAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'originalPath': currentFilePath, // Track original path for debugging
        },
      );

      await fileRef.updateMetadata(updatedMetadata);

      debugPrint(
        '✅ Updated file category metadata: ${fileRef.fullPath} -> $categoryName',
      );
      return fileRef.fullPath; // Return actual path from validated reference
    } catch (e) {
      debugPrint('❌ Failed to update file category metadata: $e');
      debugPrint('   Attempted Path: $currentFilePath');
      debugPrint('   File Name: $fileName');
      debugPrint('   Category: $categoryName');
      rethrow;
    }
  }

  /// Get category folder path
  String getCategoryFolderPath(String categoryId, String categoryName) {
    final sanitizedName = _sanitizeFolderName(categoryName);
    return 'documents/$categoryId-$sanitizedName';
  }

  /// List all files in a category folder
  Future<List<Reference>> listCategoryFiles(
    String categoryId,
    String categoryName,
  ) async {
    try {
      final folderPath = getCategoryFolderPath(categoryId, categoryName);
      final folderRef = _firebaseService.storage.ref().child(folderPath);
      final listResult = await folderRef.listAll();

      // Filter out placeholder files
      return listResult.items
          .where((ref) => !ref.name.startsWith('.'))
          .toList();
    } catch (e) {
      debugPrint('❌ Failed to list category files: $e');
      return [];
    }
  }

  /// Check if category folder exists
  Future<bool> categoryFolderExists(
    String categoryId,
    String categoryName,
  ) async {
    try {
      final folderPath = getCategoryFolderPath(categoryId, categoryName);
      final placeholderRef = _firebaseService.storage
          .ref()
          .child(folderPath)
          .child('.folder_placeholder');

      await placeholderRef.getMetadata();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Sanitize folder name for Firebase Storage
  String _sanitizeFolderName(String name) {
    // Remove special characters and replace spaces with underscores
    return name
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
  }

  /// Get upload path for new files (metadata-based categorization)
  String getUploadPath(
    String categoryId,
    String categoryName,
    String fileName,
  ) {
    // Use flat structure with metadata for categorization
    final secureFileName = _createSecureStoragePath(fileName);
    return 'documents/$secureFileName';
  }

  /// Sanitize file name for display (preserves spaces)
  String _sanitizeFileNameForDisplay(String fileName) {
    // Keep original extension but sanitize the name part
    final parts = fileName.split('.');
    final extension = parts.length > 1 ? parts.last : '';
    final nameWithoutExt = parts.length > 1
        ? parts.sublist(0, parts.length - 1).join('.')
        : fileName;

    final sanitizedName = nameWithoutExt
        .replaceAll(RegExp(r'[^\w\s.-]'), '')
        .trim(); // Preserve spaces for display

    return extension.isNotEmpty ? '$sanitizedName.$extension' : sanitizedName;
  }

  /// Create secure storage path (replaces spaces with underscores)
  String _createSecureStoragePath(String fileName) {
    // Keep original extension but sanitize the name part
    final parts = fileName.split('.');
    final extension = parts.length > 1 ? parts.last : '';
    final nameWithoutExt = parts.length > 1
        ? parts.sublist(0, parts.length - 1).join('.')
        : fileName;

    final secureName = nameWithoutExt
        .replaceAll(RegExp(r'[^\w\s.-]'), '')
        .replaceAll(RegExp(r'\s+'), '_'); // Replace spaces for storage

    return extension.isNotEmpty ? '$secureName.$extension' : secureName;
  }

  /// Validate file existence and get reference with fallback search
  Future<Reference?> _validateAndGetFileReference(
    String currentFilePath,
    String fileName,
  ) async {
    try {
      debugPrint('🔍 Validating file existence...');

      // Step 1: Try exact path first
      final exactRef = _firebaseService.storage.ref().child(currentFilePath);

      try {
        await exactRef.getMetadata();
        debugPrint('✅ File found at exact path: $currentFilePath');
        return exactRef;
      } catch (e) {
        debugPrint('⚠️ File not found at exact path: $currentFilePath');
        debugPrint('   Error: $e');
      }

      // Step 2: Search for file by name in common locations
      debugPrint('🔍 Searching for file by name: $fileName');
      final foundRef = await _searchFileByName(fileName);

      if (foundRef != null) {
        debugPrint('✅ File found at alternative path: ${foundRef.fullPath}');
        return foundRef;
      }

      debugPrint('❌ File not found in any location');
      return null;
    } catch (e) {
      debugPrint('❌ Error during file validation: $e');
      return null;
    }
  }

  /// Search for file by name in common storage locations
  Future<Reference?> _searchFileByName(String fileName) async {
    try {
      final searchPaths = ['documents/', 'documents/categories/'];

      for (final basePath in searchPaths) {
        try {
          debugPrint('🔍 Searching in: $basePath');
          final folderRef = _firebaseService.storage.ref().child(basePath);
          final listResult = await folderRef.listAll();

          // Search in direct files
          for (final fileRef in listResult.items) {
            if (_isFileNameMatch(fileRef.name, fileName)) {
              debugPrint('✅ Found file: ${fileRef.fullPath}');
              return fileRef;
            }
          }

          // Search in subfolders (for category structure)
          for (final folderRef in listResult.prefixes) {
            try {
              final subListResult = await folderRef.listAll();
              for (final fileRef in subListResult.items) {
                if (_isFileNameMatch(fileRef.name, fileName)) {
                  debugPrint('✅ Found file in subfolder: ${fileRef.fullPath}');
                  return fileRef;
                }
              }
            } catch (e) {
              debugPrint('⚠️ Error searching subfolder ${folderRef.name}: $e');
              continue;
            }
          }
        } catch (e) {
          debugPrint('⚠️ Error searching in $basePath: $e');
          continue;
        }
      }

      return null;
    } catch (e) {
      debugPrint('❌ Error during file search: $e');
      return null;
    }
  }

  /// Check if file names match (handles timestamp prefixes and sanitization)
  bool _isFileNameMatch(String storageName, String originalName) {
    // Direct match
    if (storageName == originalName) {
      return true;
    }

    // Check if storage name contains the original name (handles timestamp prefixes)
    if (storageName.contains(originalName)) {
      return true;
    }

    // Check with sanitized version
    final sanitizedOriginal = _createSecureStoragePath(originalName);
    if (storageName == sanitizedOriginal ||
        storageName.contains(sanitizedOriginal)) {
      return true;
    }

    // Check if storage name ends with original name (handles timestamp_filename pattern)
    if (storageName.endsWith(originalName) ||
        storageName.endsWith(sanitizedOriginal)) {
      return true;
    }

    // Extract filename without timestamp prefix (pattern: timestamp_filename)
    final parts = storageName.split('_');
    if (parts.length > 1) {
      final nameWithoutTimestamp = parts.sublist(1).join('_');
      if (nameWithoutTimestamp == originalName ||
          nameWithoutTimestamp == sanitizedOriginal) {
        return true;
      }
    }

    return false;
  }

  /// Get file metadata with retry mechanism
  Future<FullMetadata> _getFileMetadataWithRetry(Reference fileRef) async {
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 1);

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        debugPrint('📋 Getting metadata (attempt $attempt/$maxRetries)...');
        final metadata = await fileRef.getMetadata();
        debugPrint('✅ Metadata retrieved successfully');
        return metadata;
      } catch (e) {
        debugPrint('⚠️ Metadata retrieval failed (attempt $attempt): $e');

        if (attempt == maxRetries) {
          throw Exception(
            'Failed to get file metadata after $maxRetries attempts: $e',
          );
        }

        await Future.delayed(retryDelay);
      }
    }

    throw Exception('Unexpected error in metadata retrieval');
  }

  /// Migrate existing files to category structure (DEPRECATED - No longer needed)
  @Deprecated('Use metadata-based categorization instead of physical folders')
  Future<void> migrateExistingFilesToCategories() async {
    debugPrint(
      '⚠️ migrateExistingFilesToCategories is deprecated - using metadata-based categorization',
    );
    // No longer migrate files to physical folders - use metadata for categorization
    return;
  }
}
