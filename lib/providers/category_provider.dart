import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../core/services/category_service.dart';
import '../core/services/cloud_functions_service.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  final CloudFunctionsService _cloudFunctions = CloudFunctionsService.instance;
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

  // Add category using Cloud Functions
  Future<void> addCategory(CategoryModel category) async {
    try {
      debugPrint('🔄 Adding category via Cloud Functions: ${category.name}');

      // Use Cloud Functions to create category
      final result = await _cloudFunctions.createCategory(
        name: category.name,
        description: category.description,
        permissions: category.permissions,
        isActive: category.isActive,
      );

      if (result['success'] == true) {
        final categoryId = result['categoryId'] as String;

        // Update local list with the new ID from Cloud Functions
        final updatedCategory = category.copyWith(id: categoryId);
        _categories.insert(0, updatedCategory);

        // Initialize empty category in DocumentProvider
        _initializeEmptyCategory(categoryId);

        debugPrint(
          '✅ Category added successfully via Cloud Functions: $categoryId',
        );
        notifyListeners();
      } else {
        throw Exception('Failed to create category: ${result['message']}');
      }
    } catch (e) {
      debugPrint('❌ Failed to add category via Cloud Functions: $e');

      // Fallback: try using direct Firebase service
      try {
        debugPrint('🔄 Falling back to direct Firebase service...');
        final categoryId = await _categoryService.addCategory(category);

        final updatedCategory = category.copyWith(id: categoryId);
        _categories.insert(0, updatedCategory);
        _initializeEmptyCategory(categoryId);

        debugPrint('✅ Category added via fallback method: $categoryId');
        notifyListeners();
      } catch (fallbackError) {
        debugPrint('❌ Fallback also failed: $fallbackError');

        // Last resort: add locally only
        _categories.insert(0, category);
        _initializeEmptyCategory(category.id);
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
        // Remove from local list
        _categories.removeWhere((c) => c.id == categoryId);
        debugPrint(
          '✅ Category removed successfully via Cloud Functions: $categoryId',
        );
        debugPrint(
          '📊 Moved ${result['movedDocuments']} documents to uncategorized',
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
        await _categoryService.deleteCategory(categoryId);

        _categories.removeWhere((c) => c.id == categoryId);
        debugPrint('✅ Category removed via fallback method: $categoryId');
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
  List<CategoryModel> getCategoriesForUser(String userId) {
    return _categories.where((category) {
      return category.isActive &&
          (category.permissions.isEmpty || category.hasPermission(userId));
    }).toList();
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
