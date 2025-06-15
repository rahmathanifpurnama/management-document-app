import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
      debugPrint('🔄 Starting file categorization process...');
      debugPrint('   Document ID: $documentId');
      debugPrint('   Target Category ID: $categoryId');

      // Step 1: Get document details with validation
      final document = await _documentService.getDocumentById(documentId);
      if (document == null) {
        debugPrint('❌ Document not found in Firestore: $documentId');
        throw Exception('Document not found in database: $documentId');
      }

      debugPrint('✅ Document found: ${document.fileName}');
      debugPrint('   Current file path: ${document.filePath}');
      debugPrint('   Current category: ${document.category}');

      // Step 2: Get category details with validation
      final category = await _categoryService.getCategoryById(categoryId);
      if (category == null) {
        debugPrint('❌ Category not found: $categoryId');
        throw Exception('Category not found: $categoryId');
      }

      debugPrint('✅ Category found: ${category.name}');

      // Step 3: Move file in Firebase Storage with enhanced error handling
      try {
        final newFilePath = await _storageService.moveFileToCategory(
          document.filePath,
          categoryId,
          category.name,
          document.fileName,
        );

        debugPrint('✅ File storage operation completed');
        debugPrint('   New file path: $newFilePath');

        // Step 4: Update document metadata in Firestore
        final updatedDocument = document.copyWith(
          category: categoryId,
          filePath: newFilePath,
        );

        await _documentService.updateDocument(updatedDocument);

        debugPrint(
          '✅ Successfully moved file ${document.fileName} to category ${category.name}',
        );
      } catch (storageError) {
        debugPrint('❌ Firebase Storage operation failed: $storageError');
        debugPrint('   Document: ${document.fileName}');
        debugPrint('   File Path: ${document.filePath}');
        debugPrint('   Target Category: ${category.name}');

        // Re-throw with more context
        throw Exception(
          'Failed to move file "${document.fileName}" to category "${category.name}": $storageError',
        );
      }
    } catch (e) {
      debugPrint('❌ Failed to move file to category: $e');
      debugPrint('   Document ID: $documentId');
      debugPrint('   Category ID: $categoryId');
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
          String targetCategoryName = 'general';

          // Check if document has a valid category
          if (categoryMap.containsKey(document.category)) {
            targetCategoryName = categoryMap[document.category]!.name;
          } else {
            targetCategoryId = 'general';
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

  /// Diagnostic method to check file path consistency
  Future<Map<String, dynamic>> diagnoseFilePathIssues() async {
    try {
      debugPrint('🔍 Starting file path diagnostic...');

      final allDocuments = await _documentService.getAllDocuments();
      final diagnosticResults = <String, dynamic>{
        'totalFiles': allDocuments.length,
        'validFiles': 0,
        'invalidFiles': 0,
        'pathMismatches': <Map<String, String>>[],
        'missingFiles': <Map<String, String>>[],
        'pathPatterns': <String, int>{},
      };

      for (final document in allDocuments) {
        try {
          // Analyze path pattern
          final pathPattern = _getPathPattern(document.filePath);
          diagnosticResults['pathPatterns'][pathPattern] =
              (diagnosticResults['pathPatterns'][pathPattern] ?? 0) + 1;

          // Check if file exists at exact path
          final exactRef = _firebaseService.storage.ref().child(
            document.filePath,
          );

          try {
            await exactRef.getMetadata();
            diagnosticResults['validFiles']++;
            debugPrint('✅ Valid: ${document.fileName} -> ${document.filePath}');
          } catch (e) {
            diagnosticResults['invalidFiles']++;

            // Try to find the file using the enhanced search
            final foundRef = await _searchFileInStorage(document.fileName);

            if (foundRef != null) {
              diagnosticResults['pathMismatches'].add({
                'fileName': document.fileName,
                'storedPath': document.filePath,
                'actualPath': foundRef.fullPath,
                'documentId': document.id,
              });
              debugPrint('⚠️ Path mismatch: ${document.fileName}');
              debugPrint('   Stored: ${document.filePath}');
              debugPrint('   Actual: ${foundRef.fullPath}');
            } else {
              diagnosticResults['missingFiles'].add({
                'fileName': document.fileName,
                'storedPath': document.filePath,
                'documentId': document.id,
              });
              debugPrint(
                '❌ Missing: ${document.fileName} -> ${document.filePath}',
              );
            }
          }
        } catch (e) {
          debugPrint('❌ Error checking ${document.fileName}: $e');
        }
      }

      debugPrint('🔍 Diagnostic completed:');
      debugPrint('   Total files: ${diagnosticResults['totalFiles']}');
      debugPrint('   Valid files: ${diagnosticResults['validFiles']}');
      debugPrint('   Invalid files: ${diagnosticResults['invalidFiles']}');
      debugPrint(
        '   Path mismatches: ${diagnosticResults['pathMismatches'].length}',
      );
      debugPrint(
        '   Missing files: ${diagnosticResults['missingFiles'].length}',
      );
      debugPrint('   Path patterns: ${diagnosticResults['pathPatterns']}');

      return diagnosticResults;
    } catch (e) {
      debugPrint('❌ Failed to run diagnostic: $e');
      return {'error': e.toString()};
    }
  }

  /// Get path pattern for analysis
  String _getPathPattern(String filePath) {
    final parts = filePath.split('/');
    if (parts.length >= 3 && parts[1] == 'categories') {
      return 'documents/categories/[categoryId]/[file]';
    } else if (parts.length == 2 && parts[0] == 'documents') {
      return 'documents/[file]';
    } else {
      return 'other: ${parts.take(2).join('/')}';
    }
  }

  /// Search for file in storage by name (for diagnostic purposes)
  Future<Reference?> _searchFileInStorage(String fileName) async {
    try {
      final searchPaths = ['documents/', 'documents/categories/'];

      for (final basePath in searchPaths) {
        try {
          final folderRef = _firebaseService.storage.ref().child(basePath);
          final listResult = await folderRef.listAll();

          // Search in direct files
          for (final fileRef in listResult.items) {
            if (_isFileNameMatch(fileRef.name, fileName)) {
              return fileRef;
            }
          }

          // Search in subfolders
          for (final folderRef in listResult.prefixes) {
            try {
              final subListResult = await folderRef.listAll();
              for (final fileRef in subListResult.items) {
                if (_isFileNameMatch(fileRef.name, fileName)) {
                  return fileRef;
                }
              }
            } catch (e) {
              continue;
            }
          }
        } catch (e) {
          continue;
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Check if file names match (simplified version for diagnostic)
  bool _isFileNameMatch(String storageName, String originalName) {
    if (storageName == originalName) return true;
    if (storageName.contains(originalName)) return true;

    // Check timestamp_filename pattern
    final parts = storageName.split('_');
    if (parts.length > 1) {
      final nameWithoutTimestamp = parts.sublist(1).join('_');
      if (nameWithoutTimestamp == originalName) return true;
    }

    return false;
  }
}
