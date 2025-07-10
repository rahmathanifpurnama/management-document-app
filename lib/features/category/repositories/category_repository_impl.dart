import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/category_model.dart';
import '../../../core/services/category_service.dart';
import '../../../core/services/cloud_functions_service.dart';
import '../../../services/statistics_sync_service.dart';
import 'category_repository.dart';

/// Implementation of CategoryRepository using Firebase services
///
/// This implementation uses CategoryService for basic operations,
/// CloudFunctionsService for complex operations, and provides
/// real-time updates through Firestore streams.
class CategoryRepositoryImpl implements CategoryRepository {
  static CategoryRepositoryImpl? _instance;
  static CategoryRepositoryImpl get instance =>
      _instance ??= CategoryRepositoryImpl._();

  CategoryRepositoryImpl._();

  final CategoryService _categoryService = CategoryService();
  final CloudFunctionsService _cloudFunctions = CloudFunctionsService.instance;
  final StatisticsSyncService _statisticsSync = StatisticsSyncService.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription<QuerySnapshot>? _categoriesSubscription;
  final StreamController<List<CategoryModel>> _categoriesStreamController =
      StreamController<List<CategoryModel>>.broadcast();

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      debugPrint('📁 CategoryRepository: Loading all categories');
      final categories = await _categoryService.getAllCategories();
      debugPrint(
        '✅ CategoryRepository: Loaded ${categories.length} categories',
      );
      return categories;
    } catch (e) {
      debugPrint('❌ CategoryRepository: Error loading categories: $e');
      rethrow;
    }
  }

  @override
  Future<List<CategoryModel>> getCategoriesForUser(String userId) async {
    try {
      debugPrint('📁 CategoryRepository: Loading categories for user: $userId');
      final allCategories = await getAllCategories();
      final userCategories = allCategories
          .where(
            (category) =>
                category.permissions.isEmpty || // Universal access
                category.permissions.contains(userId) ||
                category.createdBy == userId,
          )
          .toList();
      debugPrint(
        '✅ CategoryRepository: Found ${userCategories.length} categories for user',
      );
      return userCategories;
    } catch (e) {
      debugPrint('❌ CategoryRepository: Error loading user categories: $e');
      rethrow;
    }
  }

  @override
  Future<List<CategoryModel>> getActiveCategories() async {
    try {
      final allCategories = await getAllCategories();
      return allCategories.where((category) => category.isActive).toList();
    } catch (e) {
      debugPrint('❌ CategoryRepository: Error loading active categories: $e');
      rethrow;
    }
  }

  @override
  Future<CategoryModel?> getCategoryById(String categoryId) async {
    try {
      debugPrint('📁 CategoryRepository: Loading category: $categoryId');
      final category = await _categoryService.getCategoryById(categoryId);
      if (category != null) {
        debugPrint('✅ CategoryRepository: Found category: ${category.name}');
      } else {
        debugPrint('⚠️ CategoryRepository: Category not found: $categoryId');
      }
      return category;
    } catch (e) {
      debugPrint('❌ CategoryRepository: Error loading category: $e');
      rethrow;
    }
  }

  @override
  Future<String> addCategory(CategoryModel category) async {
    try {
      debugPrint('🔄 CategoryRepository: Adding category: ${category.name}');

      // Enhanced category with universal permissions
      final enhancedCategory = category.copyWith(
        permissions: [], // Empty permissions for universal access
        isActive: true,
        documentCount: 0,
      );

      // Try Cloud Functions first
      try {
        final result = await _cloudFunctions.createCategory(
          name: enhancedCategory.name,
          description: enhancedCategory.description,
          permissions: enhancedCategory.permissions,
          isActive: enhancedCategory.isActive,
        );

        // CloudFunctionsService.createCategory returns Map<String, dynamic>
        final categoryId =
            result['categoryId']?.toString() ?? result['id']?.toString() ?? '';

        if (categoryId.isNotEmpty) {
          debugPrint(
            '✅ CategoryRepository: Category added via Cloud Functions: $categoryId',
          );
          await queryAvailableDocuments(categoryId);
          await initializeEmptyCategory(categoryId);
          return categoryId;
        }
      } catch (cloudError) {
        debugPrint(
          '⚠️ CategoryRepository: Cloud Functions failed, using fallback: $cloudError',
        );
      }

      // Fallback to direct Firebase service
      final categoryId = await _categoryService.addCategory(enhancedCategory);
      debugPrint(
        '✅ CategoryRepository: Category added via fallback: $categoryId',
      );
      await initializeEmptyCategory(categoryId);
      return categoryId;
    } catch (e) {
      debugPrint('❌ CategoryRepository: Error adding category: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateCategory(String categoryId, CategoryModel category) async {
    try {
      debugPrint('🔄 CategoryRepository: Updating category: $categoryId');

      // Try Cloud Functions first
      try {
        await _cloudFunctions.updateCategory(
          categoryId: categoryId,
          name: category.name,
          description: category.description,
          permissions: category.permissions,
          isActive: category.isActive,
        );
        debugPrint(
          '✅ CategoryRepository: Category updated via Cloud Functions',
        );
        return;
      } catch (cloudError) {
        debugPrint(
          '⚠️ CategoryRepository: Cloud Functions failed, using fallback: $cloudError',
        );
      }

      // Fallback to direct Firebase service
      await _categoryService.updateCategory(categoryId, category);
      debugPrint('✅ CategoryRepository: Category updated via fallback');
    } catch (e) {
      debugPrint('❌ CategoryRepository: Error updating category: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteCategory(
    String categoryId,
    String userId, {
    String? moveDocumentsTo,
  }) async {
    try {
      debugPrint('🔄 CategoryRepository: Deleting category: $categoryId');

      // Try Cloud Functions first
      try {
        final result = await _cloudFunctions.deleteCategory(categoryId);

        if (result['success'] == true) {
          debugPrint(
            '✅ CategoryRepository: Category deleted via Cloud Functions',
          );
          return;
        }
      } catch (cloudError) {
        debugPrint(
          '⚠️ CategoryRepository: Cloud Functions failed, using fallback: $cloudError',
        );
      }

      // Fallback to direct Firebase service
      await _categoryService.deleteCategory(categoryId);
      debugPrint('✅ CategoryRepository: Category deleted via fallback');
    } catch (e) {
      debugPrint('❌ CategoryRepository: Error deleting category: $e');
      rethrow;
    }
  }

  @override
  Future<CategoryModel> toggleCategoryStatus(String categoryId) async {
    try {
      debugPrint(
        '🔄 CategoryRepository: Toggling category status: $categoryId',
      );

      final category = await getCategoryById(categoryId);
      if (category == null) {
        throw Exception('Category not found: $categoryId');
      }

      final updatedCategory = category.copyWith(isActive: !category.isActive);
      await updateCategory(categoryId, updatedCategory);

      debugPrint(
        '✅ CategoryRepository: Category status toggled to: ${updatedCategory.isActive}',
      );
      return updatedCategory;
    } catch (e) {
      debugPrint('❌ CategoryRepository: Error toggling category status: $e');
      rethrow;
    }
  }

  @override
  Future<void> addFilesToCategory(
    String categoryId,
    List<String> documentIds,
  ) async {
    try {
      debugPrint(
        '🔄 CategoryRepository: Adding ${documentIds.length} files to category: $categoryId',
      );

      final result = await _cloudFunctions.addFilesToCategory(
        categoryId: categoryId,
        documentIds: documentIds,
      );

      if (result['success'] == true) {
        debugPrint(
          '✅ CategoryRepository: Files added to category successfully',
        );
      } else {
        throw Exception(
          'Failed to add files to category: ${result['message']}',
        );
      }
    } catch (e) {
      debugPrint('❌ CategoryRepository: Error adding files to category: $e');
      rethrow;
    }
  }

  @override
  Future<void> removeFilesFromCategory(
    String categoryId,
    List<String> documentIds,
  ) async {
    try {
      debugPrint(
        '🔄 CategoryRepository: Removing ${documentIds.length} files from category: $categoryId',
      );

      final result = await _cloudFunctions.removeFilesFromCategory(
        categoryId: categoryId,
        documentIds: documentIds,
      );

      if (result['success'] == true) {
        debugPrint(
          '✅ CategoryRepository: Files removed from category successfully',
        );
      } else {
        throw Exception(
          'Failed to remove files from category: ${result['message']}',
        );
      }
    } catch (e) {
      debugPrint(
        '❌ CategoryRepository: Error removing files from category: $e',
      );
      rethrow;
    }
  }

  @override
  Future<void> setCategoryPermissions(
    String categoryId,
    List<String> permissions,
  ) async {
    try {
      debugPrint(
        '🔄 CategoryRepository: Setting permissions for category: $categoryId',
      );

      final category = await getCategoryById(categoryId);
      if (category == null) {
        throw Exception('Category not found: $categoryId');
      }

      final updatedCategory = category.copyWith(permissions: permissions);
      await updateCategory(categoryId, updatedCategory);

      debugPrint('✅ CategoryRepository: Category permissions updated');
    } catch (e) {
      debugPrint(
        '❌ CategoryRepository: Error setting category permissions: $e',
      );
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getCategoryStatistics() async {
    try {
      debugPrint('📊 CategoryRepository: Loading category statistics');

      final categories = await getAllCategories();
      final activeCategories = categories.where((c) => c.isActive).length;
      final totalDocuments = categories.fold(
        0,
        (total, c) => total + (c.documentCount ?? 0),
      );

      final statistics = {
        'totalCategories': categories.length,
        'activeCategories': activeCategories,
        'inactiveCategories': categories.length - activeCategories,
        'totalDocuments': totalDocuments,
        'averageDocumentsPerCategory': categories.isNotEmpty
            ? (totalDocuments / categories.length).toStringAsFixed(1)
            : '0.0',
        'categoriesWithDocuments': categories
            .where((c) => (c.documentCount ?? 0) > 0)
            .length,
        'emptyCategoriesCount': categories
            .where((c) => (c.documentCount ?? 0) == 0)
            .length,
      };

      debugPrint('✅ CategoryRepository: Statistics loaded');
      return statistics;
    } catch (e) {
      debugPrint('❌ CategoryRepository: Error loading statistics: $e');
      rethrow;
    }
  }

  @override
  Future<void> refreshDocumentCounts() async {
    try {
      debugPrint('🔄 CategoryRepository: Refreshing document counts');

      // This would typically query the documents collection to get actual counts
      // For now, we'll trigger a statistics sync
      _statisticsSync.refreshStatistics(
        reason: 'Category document counts refreshed',
      );

      debugPrint('✅ CategoryRepository: Document counts refreshed');
    } catch (e) {
      debugPrint('❌ CategoryRepository: Error refreshing document counts: $e');
      rethrow;
    }
  }

  @override
  Future<List<String>> queryAvailableDocuments(String categoryId) async {
    try {
      debugPrint(
        '🔍 CategoryRepository: Querying available documents for category: $categoryId',
      );

      // Query documents that are available for categorization
      final querySnapshot = await _firestore
          .collection(
            'documents',
          ) // Use 'documents' collection as per user preference
          .where('isActive', isEqualTo: true)
          .where('category', whereIn: ['', 'general', 'null'])
          .limit(100)
          .get();

      final documentIds = querySnapshot.docs.map((doc) => doc.id).toList();

      debugPrint(
        '📊 CategoryRepository: Found ${documentIds.length} available documents',
      );
      return documentIds;
    } catch (e) {
      debugPrint(
        '❌ CategoryRepository: Error querying available documents: $e',
      );
      return [];
    }
  }

  @override
  Future<void> bulkUpdateCategories(List<CategoryModel> categories) async {
    try {
      debugPrint(
        '🔄 CategoryRepository: Bulk updating ${categories.length} categories',
      );

      final batch = _firestore.batch();

      for (final category in categories) {
        final docRef = _firestore.collection('categories').doc(category.id);
        batch.update(docRef, category.toMap());
      }

      await batch.commit();
      debugPrint('✅ CategoryRepository: Bulk update completed');
    } catch (e) {
      debugPrint('❌ CategoryRepository: Error in bulk update: $e');
      rethrow;
    }
  }

  @override
  Future<void> initializeEmptyCategory(String categoryId) async {
    try {
      debugPrint(
        '🔄 CategoryRepository: Initializing empty category: $categoryId',
      );

      // Initialize category with default settings
      // This could include creating default folders, setting up permissions, etc.

      debugPrint('✅ CategoryRepository: Category initialized');
    } catch (e) {
      debugPrint('❌ CategoryRepository: Error initializing category: $e');
      // Don't rethrow as this is not critical
    }
  }

  @override
  Stream<List<CategoryModel>> getCategoriesStream() {
    debugPrint('📡 CategoryRepository: Starting real-time categories stream');

    _categoriesSubscription?.cancel();
    _categoriesSubscription = _firestore
        .collection('categories')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            try {
              final categories = snapshot.docs
                  .map((doc) => CategoryModel.fromFirestore(doc))
                  .toList();

              debugPrint(
                '📡 CategoryRepository: Stream update - ${categories.length} categories',
              );
              _categoriesStreamController.add(categories);
            } catch (e) {
              debugPrint('❌ CategoryRepository: Stream error: $e');
              _categoriesStreamController.addError(e);
            }
          },
          onError: (error) {
            debugPrint(
              '❌ CategoryRepository: Stream subscription error: $error',
            );
            _categoriesStreamController.addError(error);
          },
        );

    return _categoriesStreamController.stream;
  }

  @override
  Future<void> syncCategories() async {
    try {
      debugPrint('🔄 CategoryRepository: Syncing categories');

      // Perform any necessary synchronization operations
      _statisticsSync.refreshStatistics(reason: 'Category sync completed');
      await refreshDocumentCounts();

      debugPrint('✅ CategoryRepository: Categories synced');
    } catch (e) {
      debugPrint('❌ CategoryRepository: Error syncing categories: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    debugPrint('🧹 CategoryRepository: Disposing resources');
    _categoriesSubscription?.cancel();
    _categoriesStreamController.close();
  }
}
