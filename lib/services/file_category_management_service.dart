import 'package:flutter/foundation.dart';
import '../core/services/firebase_service.dart';
import '../core/services/document_service.dart';
import '../core/services/category_service.dart';
import '../models/document_model.dart';
import 'firebase_storage_category_service.dart';

/// Service for managing file organization between categories and recent files
class FileCategoryManagementService {
  final FirebaseService _firebaseService = FirebaseService.instance;
  final DocumentService _documentService = DocumentService.instance;
  final CategoryService _categoryService = CategoryService();
  final FirebaseStorageCategoryService _storageService =
      FirebaseStorageCategoryService();

  /// Move file from recent files to a specific category
  Future<void> moveFileToCategory(String documentId, String categoryId) async {
    try {
      // Get document details
      final document = await _documentService.getDocumentById(documentId);
      if (document == null) {
        throw Exception('Document not found');
      }

      // Get category details
      final category = await _categoryService.getCategoryById(categoryId);
      if (category == null) {
        throw Exception('Category not found');
      }

      // Move file in Firebase Storage
      final newFilePath = await _storageService.moveFileToCategory(
        document.filePath,
        categoryId,
        category.name,
        document.fileName,
      );

      // Update document metadata in Firestore
      final updatedDocument = document.copyWith(
        category: categoryId,
        filePath: newFilePath,
      );

      await _documentService.updateDocument(updatedDocument);

      debugPrint(
        '✅ Moved file ${document.fileName} to category ${category.name}',
      );
    } catch (e) {
      debugPrint('❌ Failed to move file to category: $e');
      rethrow;
    }
  }

  /// Move file from category back to uncategorized (recent files)
  Future<void> moveFileToUncategorized(String documentId) async {
    try {
      // Get document details
      final document = await _documentService.getDocumentById(documentId);
      if (document == null) {
        throw Exception('Document not found');
      }

      // Move file to uncategorized folder in Firebase Storage
      final newFilePath = await _storageService.moveFileToCategory(
        document.filePath,
        'uncategorized',
        'uncategorized',
        document.fileName,
      );

      // Update document metadata in Firestore
      final updatedDocument = document.copyWith(
        category: 'uncategorized',
        filePath: newFilePath,
      );

      await _documentService.updateDocument(updatedDocument);

      debugPrint('✅ Moved file ${document.fileName} to uncategorized');
    } catch (e) {
      debugPrint('❌ Failed to move file to uncategorized: $e');
      rethrow;
    }
  }

  /// Move multiple files to a category
  Future<void> moveMultipleFilesToCategory(
    List<String> documentIds,
    String categoryId,
  ) async {
    try {
      final category = await _categoryService.getCategoryById(categoryId);
      if (category == null) {
        throw Exception('Category not found');
      }

      int successCount = 0;
      int failureCount = 0;

      for (final documentId in documentIds) {
        try {
          await moveFileToCategory(documentId, categoryId);
          successCount++;
        } catch (e) {
          debugPrint('⚠️ Failed to move document $documentId: $e');
          failureCount++;
        }
      }

      debugPrint(
        '✅ Batch move completed: $successCount success, $failureCount failures',
      );
    } catch (e) {
      debugPrint('❌ Failed to move multiple files: $e');
      rethrow;
    }
  }

  /// Get recent files (files uploaded in the last 7 days, regardless of category)
  Future<List<DocumentModel>> getRecentFiles({int days = 7}) async {
    try {
      final allDocuments = await _documentService.getAllDocuments();
      final cutoffDate = DateTime.now().subtract(Duration(days: days));

      return allDocuments
          .where((doc) => doc.uploadedAt.isAfter(cutoffDate))
          .toList()
        ..sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
    } catch (e) {
      debugPrint('❌ Failed to get recent files: $e');
      return [];
    }
  }

  /// Get files by category
  Future<List<DocumentModel>> getFilesByCategory(String categoryId) async {
    try {
      return await _documentService.getDocumentsByCategory(categoryId);
    } catch (e) {
      debugPrint('❌ Failed to get files by category: $e');
      return [];
    }
  }

  /// Get uncategorized files
  Future<List<DocumentModel>> getUncategorizedFiles() async {
    try {
      return await _documentService.getDocumentsByCategory('uncategorized');
    } catch (e) {
      debugPrint('❌ Failed to get uncategorized files: $e');
      return [];
    }
  }

  /// Organize existing files into category structure
  Future<void> organizeExistingFiles() async {
    try {
      debugPrint('🔄 Starting file organization...');

      // Get all documents
      final allDocuments = await _documentService.getAllDocuments();

      // Get all categories
      final categories = await _categoryService.getAllCategories();
      final categoryMap = {for (var cat in categories) cat.id: cat};

      int organizedCount = 0;
      int errorCount = 0;

      for (final document in allDocuments) {
        try {
          // Skip if already in proper folder structure
          if (document.filePath.contains('/') &&
              document.filePath.split('/').length > 2) {
            continue;
          }

          String targetCategoryId = document.category;
          String targetCategoryName = 'uncategorized';

          // Check if document has a valid category
          if (categoryMap.containsKey(document.category)) {
            targetCategoryName = categoryMap[document.category]!.name;
          } else {
            targetCategoryId = 'uncategorized';
          }

          // Move file to proper folder structure
          final newFilePath = await _storageService.moveFileToCategory(
            document.filePath,
            targetCategoryId,
            targetCategoryName,
            document.fileName,
          );

          // Update document metadata
          final updatedDocument = document.copyWith(
            filePath: newFilePath,
            category: targetCategoryId,
          );

          await _documentService.updateDocument(updatedDocument);
          organizedCount++;

          debugPrint('📁 Organized: ${document.fileName}');
        } catch (e) {
          debugPrint('⚠️ Failed to organize ${document.fileName}: $e');
          errorCount++;
        }
      }

      debugPrint(
        '✅ File organization completed: $organizedCount organized, $errorCount errors',
      );
    } catch (e) {
      debugPrint('❌ Failed to organize existing files: $e');
      rethrow;
    }
  }

  /// Sync category folders with Firebase Storage (DEPRECATED - No longer needed)
  /// Categories now use metadata-based organization instead of physical folders
  @Deprecated('Use metadata-based categorization instead of folder sync')
  Future<void> syncCategoryFolders() async {
    debugPrint(
      '⚠️ syncCategoryFolders is deprecated - using metadata-based categorization',
    );
    // No longer sync folders - categories are managed through metadata only
    return;
  }

  /// Get file statistics by category
  Future<Map<String, int>> getFileStatsByCategory() async {
    try {
      final allDocuments = await _documentService.getAllDocuments();
      final stats = <String, int>{};

      for (final document in allDocuments) {
        final category = document.category;
        stats[category] = (stats[category] ?? 0) + 1;
      }

      return stats;
    } catch (e) {
      debugPrint('❌ Failed to get file stats: $e');
      return {};
    }
  }

  /// DISABLED: Clean up orphaned files to prevent automatic deletions
  /// This function has been disabled to prevent unwanted metadata deletion
  Future<int> cleanupOrphanedFiles() async {
    debugPrint(
      '⚠️ Orphaned files cleanup has been disabled to prevent automatic deletions',
    );
    debugPrint('   Use manual cleanup functions with admin approval instead');
    return 0;
  }

  /// Manual identification of orphaned files (for admin review only)
  Future<List<DocumentModel>> identifyOrphanedFiles() async {
    try {
      debugPrint('🔍 Identifying orphaned files for manual review...');

      final allDocuments = await _documentService.getAllDocuments();
      final orphanedDocuments = <DocumentModel>[];

      for (final document in allDocuments) {
        try {
          // Check if file exists in Storage
          final fileRef = _firebaseService.storage.ref().child(
            document.filePath,
          );
          await fileRef.getMetadata();
        } catch (e) {
          // File doesn't exist in Storage, mark as orphaned
          orphanedDocuments.add(document);
          debugPrint('🔍 Found orphaned metadata: ${document.fileName}');
        }
      }

      debugPrint(
        '✅ Identification completed: ${orphanedDocuments.length} orphaned files found',
      );
      return orphanedDocuments;
    } catch (e) {
      debugPrint('❌ Failed to identify orphaned files: $e');
      return [];
    }
  }
}
