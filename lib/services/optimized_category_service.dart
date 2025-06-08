import 'package:flutter/foundation.dart';
import '../models/category_model.dart';
import '../core/services/firebase_service.dart';
import 'cloud_functions_service.dart';

/// Optimized category service using Cloud Functions for heavy operations
class OptimizedCategoryService {
  final FirebaseService _firebaseService = FirebaseService.instance;
  final CloudFunctionsService _cloudFunctions = CloudFunctionsService.instance;

  /// Create a new category using Cloud Functions
  Future<String> createCategory({
    required String name,
    String? description,
    List<String>? permissions,
    bool isActive = true,
  }) async {
    try {
      debugPrint('🔄 Creating category via Cloud Functions: $name');

      // Use Cloud Functions for heavy processing
      final categoryId = await _cloudFunctions.createCategory(
        name: name,
        description: description,
        permissions: permissions,
        isActive: isActive,
      );

      debugPrint('✅ Category created successfully: $categoryId');
      return categoryId;
    } catch (e) {
      debugPrint('❌ Error creating category: $e');
      rethrow;
    }
  }

  /// Update an existing category using Cloud Functions
  Future<void> updateCategory({
    required String categoryId,
    String? name,
    String? description,
    List<String>? permissions,
    bool? isActive,
  }) async {
    try {
      debugPrint('🔄 Updating category via Cloud Functions: $categoryId');

      // Use Cloud Functions for heavy processing
      await _cloudFunctions.updateCategory(
        categoryId: categoryId,
        name: name,
        description: description,
        permissions: permissions,
        isActive: isActive,
      );

      debugPrint('✅ Category updated successfully');
    } catch (e) {
      debugPrint('❌ Error updating category: $e');
      rethrow;
    }
  }

  /// Delete a category using Cloud Functions
  Future<Map<String, dynamic>> deleteCategory(String categoryId) async {
    try {
      debugPrint('🔄 Deleting category via Cloud Functions: $categoryId');

      // Use Cloud Functions for heavy processing (handles document migration)
      final result = await _cloudFunctions.deleteCategory(categoryId);

      debugPrint('✅ Category deleted successfully');
      return result;
    } catch (e) {
      debugPrint('❌ Error deleting category: $e');
      rethrow;
    }
  }

  /// Get all categories (lightweight Firestore query)
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      debugPrint('📋 Loading categories from Firestore...');

      final snapshot = await _firebaseService.categoriesCollection
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      final categories = snapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc))
          .toList();

      debugPrint('✅ Loaded ${categories.length} categories');
      return categories;
    } catch (e) {
      debugPrint('❌ Error loading categories: $e');
      rethrow;
    }
  }

  /// Get category by ID (lightweight Firestore query)
  Future<CategoryModel?> getCategoryById(String categoryId) async {
    try {
      final doc = await _firebaseService.categoriesCollection
          .doc(categoryId)
          .get();

      if (doc.exists) {
        return CategoryModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error getting category: $e');
      return null;
    }
  }

  /// Add files to category using Cloud Functions
  Future<void> addFilesToCategory({
    required String categoryId,
    required List<String> documentIds,
  }) async {
    try {
      debugPrint(
        '🔄 Adding ${documentIds.length} files to category: $categoryId',
      );

      // Use Cloud Functions for batch operations
      await _cloudFunctions.addFilesToCategory(
        categoryId: categoryId,
        documentIds: documentIds,
      );

      debugPrint('✅ Files added to category successfully');
    } catch (e) {
      debugPrint('❌ Error adding files to category: $e');
      rethrow;
    }
  }

  /// Remove files from category using Cloud Functions
  Future<void> removeFilesFromCategory({
    required String categoryId,
    required List<String> documentIds,
  }) async {
    try {
      debugPrint(
        '🔄 Removing ${documentIds.length} files from category: $categoryId',
      );

      // Use Cloud Functions for batch operations
      await _cloudFunctions.removeFilesFromCategory(
        categoryId: categoryId,
        documentIds: documentIds,
      );

      debugPrint('✅ Files removed from category successfully');
    } catch (e) {
      debugPrint('❌ Error removing files from category: $e');
      rethrow;
    }
  }

  /// Get categories with document counts (lightweight aggregation)
  Future<List<Map<String, dynamic>>> getCategoriesWithCounts() async {
    try {
      debugPrint('📊 Loading categories with document counts...');

      final categories = await getAllCategories();
      final categoriesWithCounts = <Map<String, dynamic>>[];

      for (final category in categories) {
        // Get document count from category document (updated by Cloud Functions)
        final categoryData = {
          'category': category,
          'documentCount': category.documentCount ?? 0,
        };
        categoriesWithCounts.add(categoryData);
      }

      debugPrint(
        '✅ Loaded ${categoriesWithCounts.length} categories with counts',
      );
      return categoriesWithCounts;
    } catch (e) {
      debugPrint('❌ Error loading categories with counts: $e');
      rethrow;
    }
  }

  /// Search categories by name (lightweight client-side filtering)
  Future<List<CategoryModel>> searchCategories(String query) async {
    try {
      if (query.isEmpty) {
        return await getAllCategories();
      }

      final allCategories = await getAllCategories();
      final filteredCategories = allCategories
          .where(
            (category) =>
                category.name.toLowerCase().contains(query.toLowerCase()) ||
                category.description.toLowerCase().contains(
                  query.toLowerCase(),
                ),
          )
          .toList();

      debugPrint(
        '🔍 Found ${filteredCategories.length} categories matching "$query"',
      );
      return filteredCategories;
    } catch (e) {
      debugPrint('❌ Error searching categories: $e');
      rethrow;
    }
  }

  /// Get categories stream for real-time updates
  Stream<List<CategoryModel>> getCategoriesStream() {
    try {
      return _firebaseService.categoriesCollection
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => CategoryModel.fromFirestore(doc))
                .toList(),
          );
    } catch (e) {
      debugPrint('❌ Error creating categories stream: $e');
      rethrow;
    }
  }

  /// Bulk category operations using Cloud Functions
  Future<Map<String, dynamic>> bulkCategoryOperations({
    required String operation,
    required List<String> categoryIds,
    String? reason,
  }) async {
    try {
      debugPrint(
        '🔄 Performing bulk $operation on ${categoryIds.length} categories',
      );

      // This would require implementing bulk operations in Cloud Functions
      // For now, we'll process them individually
      final results = {'success': 0, 'failed': 0, 'errors': <String>[]};

      for (final categoryId in categoryIds) {
        try {
          switch (operation) {
            case 'delete':
              await deleteCategory(categoryId);
              break;
            case 'activate':
              await updateCategory(categoryId: categoryId, isActive: true);
              break;
            case 'deactivate':
              await updateCategory(categoryId: categoryId, isActive: false);
              break;
            default:
              throw Exception('Unknown operation: $operation');
          }
          results['success'] = (results['success'] as int) + 1;
        } catch (e) {
          results['failed'] = (results['failed'] as int) + 1;
          (results['errors'] as List<String>).add(
            'Failed to $operation category $categoryId: $e',
          );
        }
      }

      debugPrint(
        '✅ Bulk $operation completed: ${results['success']} successful, ${results['failed']} failed',
      );
      return results;
    } catch (e) {
      debugPrint('❌ Error in bulk category operations: $e');
      rethrow;
    }
  }

  /// Get category statistics
  Future<Map<String, dynamic>> getCategoryStatistics() async {
    try {
      debugPrint('📊 Calculating category statistics...');

      final categories = await getAllCategories();

      final stats = {
        'totalCategories': categories.length,
        'activeCategories': categories.where((c) => c.isActive).length,
        'totalDocuments': categories.fold<int>(
          0,
          (sum, c) => sum + (c.documentCount ?? 0),
        ),
        'averageDocumentsPerCategory': categories.isNotEmpty
            ? categories.fold<int>(
                    0,
                    (sum, c) => sum + (c.documentCount ?? 0),
                  ) /
                  categories.length
            : 0,
        'categoriesWithDocuments': categories
            .where((c) => (c.documentCount ?? 0) > 0)
            .length,
        'emptyCategoriesCount': categories
            .where((c) => (c.documentCount ?? 0) == 0)
            .length,
      };

      debugPrint('✅ Category statistics calculated');
      return stats;
    } catch (e) {
      debugPrint('❌ Error calculating category statistics: $e');
      rethrow;
    }
  }

  /// Validate category name (client-side validation)
  Future<bool> validateCategoryName(
    String name, {
    String? excludeCategoryId,
  }) async {
    try {
      if (name.trim().isEmpty) {
        return false;
      }

      final categories = await getAllCategories();
      final existingCategory = categories.firstWhere(
        (category) =>
            category.name.toLowerCase() == name.trim().toLowerCase() &&
            category.id != excludeCategoryId,
        orElse: () => CategoryModel(
          id: '',
          name: '',
          description: '',
          createdBy: '',
          createdAt: DateTime.now(),
          permissions: [],
          isActive: false,
        ),
      );

      return existingCategory.id.isEmpty;
    } catch (e) {
      debugPrint('❌ Error validating category name: $e');
      return false;
    }
  }
}
