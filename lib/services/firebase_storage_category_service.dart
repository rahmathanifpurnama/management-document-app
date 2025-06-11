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
      // Get reference to current file
      final currentRef = _firebaseService.storage.ref().child(currentFilePath);

      // Get current metadata
      final metadata = await currentRef.getMetadata();

      // Update metadata with category information (no file move needed)
      final updatedMetadata = SettableMetadata(
        contentType: metadata.contentType,
        customMetadata: {
          ...metadata.customMetadata ?? {},
          'categoryId': categoryId,
          'categoryName': categoryName,
          'movedAt': DateTime.now().millisecondsSinceEpoch.toString(),
        },
      );

      await currentRef.updateMetadata(updatedMetadata);

      debugPrint(
        '✅ Updated file category metadata: $currentFilePath -> $categoryName',
      );
      return currentFilePath; // Return same path since file doesn't move
    } catch (e) {
      debugPrint('❌ Failed to update file category metadata: $e');
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
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final sanitizedFileName = _sanitizeFileName(fileName);
    return 'documents/${timestamp}_$sanitizedFileName';
  }

  /// Sanitize file name
  String _sanitizeFileName(String fileName) {
    // Keep original extension but sanitize the name part
    final parts = fileName.split('.');
    final extension = parts.length > 1 ? parts.last : '';
    final nameWithoutExt = parts.length > 1
        ? parts.sublist(0, parts.length - 1).join('.')
        : fileName;

    final sanitizedName = nameWithoutExt
        .replaceAll(RegExp(r'[^\w\s.-]'), '')
        .replaceAll(RegExp(r'\s+'), '_');

    return extension.isNotEmpty ? '$sanitizedName.$extension' : sanitizedName;
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
