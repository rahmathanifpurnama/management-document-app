import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';
import '../core/services/category_service.dart';
import '../core/services/cloud_functions_service.dart';
import '../services/direct_statistics_update_service.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  final CloudFunctionsService _cloudFunctions = CloudFunctionsService.instance;
  final DirectStatisticsUpdateService _directStatisticsService =
      DirectStatisticsUpdateService.instance;
  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<CategoryModel> get categories => _categories;
  List<CategoryModel> get activeCategories =>
      _categories.where((c) => c.isActive).toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load categories
  Future<void> loadCategories() async {
    _setLoading(true);
    _clearError();

    try {
      // Try to load from Firebase first
      try {
        _categories = await _categoryService.getAllCategories();
      } catch (firebaseError) {
        // If Firebase fails, start with empty categories
        _categories = [];
        _setError('Failed to load categories: $firebaseError');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Add category using Cloud Functions with auto-query system
  // ENHANCED: Support unlimited category creation with universal visibility and auto-document discovery
  Future<void> addCategory(CategoryModel category) async {
    try {
      debugPrint(
        '🔄 Adding unlimited category via Cloud Functions: ${category.name}',
      );

      // UNLIMITED CATEGORIES: Create category with universal permissions
      final enhancedCategory = category.copyWith(
        permissions: [], // Empty permissions for universal access
        isActive: true, // Ensure category is active
        documentCount: 0, // Initialize with 0 documents
      );

      // STEP 1: Create category in Firestore first
      final categoryRef = FirebaseFirestore.instance
          .collection('categories')
          .doc(enhancedCategory.id);
      await categoryRef.set(enhancedCategory.toMap());

      debugPrint('✅ Category created in Firestore: ${enhancedCategory.id}');

      // STEP 2: Query available documents for potential assignment
      await _queryAvailableDocumentsForCategory(enhancedCategory.id);

      // STEP 3: Add to local list immediately (Firestore creation was successful)
      _categories.insert(0, enhancedCategory);
      _initializeEmptyCategory(enhancedCategory.id);

      debugPrint('✅ Category added successfully: ${enhancedCategory.name}');
      notifyListeners();

      // STEP 4: Use Cloud Functions for additional processing if needed (optional)
      try {
        final result = await _cloudFunctions.createCategory(
          name: enhancedCategory.name,
          description: enhancedCategory.description,
          permissions: enhancedCategory.permissions,
          isActive: enhancedCategory.isActive,
        );

        if (result['success'] == true) {
          debugPrint(
            '✅ Category also processed via Cloud Functions successfully',
          );
        }
      } catch (cloudError) {
        debugPrint(
          '⚠️ Cloud Functions processing failed, but category creation succeeded: $cloudError',
        );
        // Continue execution as main creation was successful
      }

      // Return early since we've successfully created the category
      return;
    } catch (e) {
      debugPrint('❌ Failed to add category via Cloud Functions: $e');

      // Fallback: try using direct Firebase service
      try {
        debugPrint('🔄 Falling back to direct Firebase service...');
        final enhancedCategory = category.copyWith(
          permissions: [], // Empty permissions for universal access
          isActive: true,
        );
        final categoryId = await _categoryService.addCategory(enhancedCategory);

        final updatedCategory = enhancedCategory.copyWith(id: categoryId);
        _categories.insert(0, updatedCategory);
        _initializeEmptyCategory(categoryId);

        debugPrint(
          '✅ Unlimited category added via fallback method: $categoryId',
        );
        notifyListeners();
      } catch (fallbackError) {
        debugPrint('❌ Fallback also failed: $fallbackError');

        // Last resort: add locally only with universal access
        final enhancedCategory = category.copyWith(
          permissions: [], // Empty permissions for universal access
          isActive: true,
        );
        _categories.insert(0, enhancedCategory);
        _initializeEmptyCategory(enhancedCategory.id);
        notifyListeners();
        rethrow;
      }
    }
  }

  // Initialize empty category in DocumentProvider
  void _initializeEmptyCategory(String categoryId) {
    // This will be called by DocumentProvider when needed
    // We don't need to import DocumentProvider here to avoid circular dependency
  }

  // Query available documents for potential assignment to new category
  Future<void> _queryAvailableDocumentsForCategory(String categoryId) async {
    try {
      debugPrint('🔍 Querying available documents for category: $categoryId');

      // Query documents that are available for categorization
      final querySnapshot = await FirebaseFirestore.instance
          .collection('document-metadata')
          .where('isActive', isEqualTo: true)
          .where('category', whereIn: ['', 'general', 'null'])
          .limit(100) // Limit to prevent performance issues
          .get();

      final availableDocuments = querySnapshot.docs;

      debugPrint(
        '📊 Found ${availableDocuments.length} documents available for categorization',
      );

      // Store document IDs for potential assignment
      final documentIds = availableDocuments.map((doc) => doc.id).toList();

      // Log available documents for category assignment
      if (documentIds.isNotEmpty) {
        debugPrint(
          '📋 Documents available for category "$categoryId": ${documentIds.take(5).join(", ")}${documentIds.length > 5 ? "..." : ""}',
        );
      } else {
        debugPrint('📭 No documents available for categorization');
      }

      // Store the available document IDs in category metadata for reference
      if (documentIds.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('categories')
            .doc(categoryId)
            .update({
              'availableDocumentIds': documentIds,
              'availableDocumentCount': documentIds.length,
              'lastQueryAt': FieldValue.serverTimestamp(),
            });

        debugPrint(
          '✅ Stored ${documentIds.length} available document IDs in category metadata',
        );
      }
    } catch (e) {
      debugPrint('❌ Failed to query available documents for category: $e');
      // Don't throw error as this is not critical for category creation
    }
  }

  // Update category using Cloud Functions
  Future<void> updateCategory(CategoryModel category) async {
    try {
      debugPrint('🔄 Updating category via Cloud Functions: ${category.id}');

      // Use Cloud Functions to update category
      final result = await _cloudFunctions.updateCategory(
        categoryId: category.id,
        name: category.name,
        description: category.description,
        permissions: category.permissions,
        isActive: category.isActive,
      );

      if (result['success'] == true) {
        // Update local list
        int index = _categories.indexWhere((c) => c.id == category.id);
        if (index != -1) {
          _categories[index] = category;
          debugPrint(
            '✅ Category updated successfully via Cloud Functions: ${category.id}',
          );
          notifyListeners();
        }
      } else {
        throw Exception('Failed to update category: ${result['message']}');
      }
    } catch (e) {
      debugPrint('❌ Failed to update category via Cloud Functions: $e');

      // Fallback: try using direct Firebase service
      try {
        debugPrint('🔄 Falling back to direct Firebase service...');
        await _categoryService.updateCategory(category.id, category);

        int index = _categories.indexWhere((c) => c.id == category.id);
        if (index != -1) {
          _categories[index] = category;
          debugPrint('✅ Category updated via fallback method: ${category.id}');
          notifyListeners();
        }
      } catch (fallbackError) {
        debugPrint('❌ Fallback also failed: $fallbackError');

        // Last resort: update locally only
        int index = _categories.indexWhere((c) => c.id == category.id);
        if (index != -1) {
          _categories[index] = category;
          notifyListeners();
        }
        rethrow;
      }
    }
  }

  // Remove category using Cloud Functions
  Future<void> removeCategory(String categoryId) async {
    try {
      debugPrint('🔄 Removing category via Cloud Functions: $categoryId');

      // Use Cloud Functions to delete category
      final result = await _cloudFunctions.deleteCategory(categoryId);

      if (result['success'] == true) {
        // Get category name before removal for statistics
        final categoryName = _categories
            .firstWhere(
              (c) => c.id == categoryId,
              orElse: () => CategoryModel(
                id: categoryId,
                name: 'Unknown Category',
                description: '',
                isActive: false,
                createdAt: DateTime.now(),
                createdBy: '',
                permissions: [],
              ),
            )
            .name;

        // Remove from local list
        _categories.removeWhere((c) => c.id == categoryId);
        debugPrint(
          '✅ Category removed successfully via Cloud Functions: $categoryId',
        );
        debugPrint(
          '📊 Moved ${result['movedDocuments']} documents to uncategorized',
        );

        // Update statistics immediately using direct queries
        await _directStatisticsService.notifyCategoryDeleted(
          categoryId: categoryId,
          categoryName: categoryName,
          movedDocuments: result['movedDocuments'] as int?,
        );

        notifyListeners();
      } else {
        throw Exception('Failed to delete category: ${result['message']}');
      }
    } catch (e) {
      debugPrint('❌ Failed to remove category via Cloud Functions: $e');

      // Fallback: try using direct Firebase service
      try {
        debugPrint('🔄 Falling back to direct Firebase service...');

        // Get category name before removal for statistics
        final categoryName = _categories
            .firstWhere(
              (c) => c.id == categoryId,
              orElse: () => CategoryModel(
                id: categoryId,
                name: 'Unknown Category',
                description: '',
                isActive: false,
                createdAt: DateTime.now(),
                createdBy: '',
                permissions: [],
              ),
            )
            .name;

        await _categoryService.deleteCategory(categoryId);

        _categories.removeWhere((c) => c.id == categoryId);
        debugPrint('✅ Category removed via fallback method: $categoryId');

        // Update statistics immediately using direct queries
        await _directStatisticsService.notifyCategoryDeleted(
          categoryId: categoryId,
          categoryName: categoryName,
        );

        notifyListeners();
      } catch (fallbackError) {
        debugPrint('❌ Fallback also failed: $fallbackError');

        // Last resort: remove locally only
        _categories.removeWhere((c) => c.id == categoryId);
        notifyListeners();
        rethrow;
      }
    }
  }

  // Toggle category status
  void toggleCategoryStatus(String categoryId) {
    int index = _categories.indexWhere((c) => c.id == categoryId);
    if (index != -1) {
      _categories[index] = _categories[index].copyWith(
        isActive: !_categories[index].isActive,
      );
      notifyListeners();
    }
  }

  // Get category by ID
  CategoryModel? getCategoryById(String categoryId) {
    try {
      return _categories.firstWhere((category) => category.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  // Get category by name
  CategoryModel? getCategoryByName(String name) {
    try {
      return _categories.firstWhere((category) => category.name == name);
    } catch (e) {
      return null;
    }
  }

  // Get categories that user has access to
  // ENHANCED: Universal visibility for all authenticated users
  List<CategoryModel> getCategoriesForUser(String userId) {
    // UNLIMITED CATEGORIES: All active categories are visible to all authenticated users
    return _categories.where((category) {
      return category
          .isActive; // Remove permission restrictions for universal access
    }).toList();
  }

  // ENHANCED: Get all categories without user restrictions (for admin/universal access)
  List<CategoryModel> getAllCategoriesUniversal() {
    return _categories.where((category) => category.isActive).toList();
  }

  // Get total categories count
  int get totalCategoriesCount {
    return _categories.length;
  }

  // Get active categories count
  int get activeCategoriesCount {
    return _categories.where((category) => category.isActive).length;
  }

  // Get inactive categories count
  int get inactiveCategoriesCount {
    return _categories.where((category) => !category.isActive).length;
  }

  // Search categories
  List<CategoryModel> searchCategories(String query) {
    if (query.isEmpty) return _categories;

    return _categories.where((category) {
      return category.name.toLowerCase().contains(query.toLowerCase()) ||
          category.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Add files to category using Cloud Functions
  Future<void> addFilesToCategory(
    String categoryId,
    List<String> documentIds,
  ) async {
    try {
      debugPrint(
        '🔄 Adding ${documentIds.length} files to category via Cloud Functions: $categoryId',
      );

      final result = await _cloudFunctions.addFilesToCategory(
        categoryId: categoryId,
        documentIds: documentIds,
      );

      if (result['success'] == true) {
        debugPrint(
          '✅ Files added to category successfully via Cloud Functions',
        );
        // Refresh categories to get updated document counts
        await loadCategories();
      } else {
        throw Exception(
          'Failed to add files to category: ${result['message']}',
        );
      }
    } catch (e) {
      debugPrint('❌ Failed to add files to category via Cloud Functions: $e');
      rethrow;
    }
  }

  // Remove files from category using Cloud Functions
  Future<void> removeFilesFromCategory(
    String categoryId,
    List<String> documentIds,
  ) async {
    try {
      debugPrint(
        '🔄 Removing ${documentIds.length} files from category via Cloud Functions: $categoryId',
      );

      final result = await _cloudFunctions.removeFilesFromCategory(
        categoryId: categoryId,
        documentIds: documentIds,
      );

      if (result['success'] == true) {
        debugPrint(
          '✅ Files removed from category successfully via Cloud Functions',
        );
        // Refresh categories to get updated document counts
        await loadCategories();
      } else {
        throw Exception(
          'Failed to remove files from category: ${result['message']}',
        );
      }
    } catch (e) {
      debugPrint(
        '❌ Failed to remove files from category via Cloud Functions: $e',
      );
      rethrow;
    }
  }

  // Refresh categories
  Future<void> refreshCategories() async {
    await loadCategories();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear error manually
  void clearError() {
    _clearError();
  }
}
