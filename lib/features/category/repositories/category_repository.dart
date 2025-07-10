import '../../../models/category_model.dart';

/// Abstract repository interface for category operations
/// 
/// This interface defines all the operations that can be performed
/// on categories. It provides a clean separation between the business
/// logic (BLoC) and the data layer (implementation).
abstract class CategoryRepository {
  /// Get all categories
  /// 
  /// Returns a list of all categories from the data source.
  /// Throws an exception if the operation fails.
  Future<List<CategoryModel>> getAllCategories();

  /// Get categories for a specific user
  /// 
  /// [userId] - The ID of the user to get categories for
  /// Returns categories that the user has access to.
  Future<List<CategoryModel>> getCategoriesForUser(String userId);

  /// Get active categories only
  /// 
  /// Returns only categories where isActive is true.
  Future<List<CategoryModel>> getActiveCategories();

  /// Get category by ID
  /// 
  /// [categoryId] - The ID of the category to retrieve
  /// Returns the category if found, null otherwise.
  Future<CategoryModel?> getCategoryById(String categoryId);

  /// Add a new category
  /// 
  /// [category] - The category to add
  /// Returns the ID of the created category.
  /// Throws an exception if the operation fails.
  Future<String> addCategory(CategoryModel category);

  /// Update an existing category
  /// 
  /// [categoryId] - The ID of the category to update
  /// [category] - The updated category data
  /// Throws an exception if the operation fails.
  Future<void> updateCategory(String categoryId, CategoryModel category);

  /// Delete a category
  /// 
  /// [categoryId] - The ID of the category to delete
  /// [userId] - The ID of the user performing the deletion
  /// [moveDocumentsTo] - Optional category ID to move documents to
  /// Throws an exception if the operation fails.
  Future<void> deleteCategory(
    String categoryId,
    String userId, {
    String? moveDocumentsTo,
  });

  /// Toggle category active status
  /// 
  /// [categoryId] - The ID of the category to toggle
  /// Returns the updated category.
  /// Throws an exception if the operation fails.
  Future<CategoryModel> toggleCategoryStatus(String categoryId);

  /// Add files to a category
  /// 
  /// [categoryId] - The ID of the category
  /// [documentIds] - List of document IDs to add to the category
  /// Throws an exception if the operation fails.
  Future<void> addFilesToCategory(String categoryId, List<String> documentIds);

  /// Remove files from a category
  /// 
  /// [categoryId] - The ID of the category
  /// [documentIds] - List of document IDs to remove from the category
  /// Throws an exception if the operation fails.
  Future<void> removeFilesFromCategory(String categoryId, List<String> documentIds);

  /// Set category permissions
  /// 
  /// [categoryId] - The ID of the category
  /// [permissions] - List of user IDs with permissions
  /// Throws an exception if the operation fails.
  Future<void> setCategoryPermissions(String categoryId, List<String> permissions);

  /// Get category statistics
  /// 
  /// Returns statistics about categories such as total count,
  /// active count, document distribution, etc.
  Future<Map<String, dynamic>> getCategoryStatistics();

  /// Refresh document counts for all categories
  /// 
  /// Updates the document count for each category by querying
  /// the actual documents in the system.
  Future<void> refreshDocumentCounts();

  /// Query available documents for category assignment
  /// 
  /// [categoryId] - The category ID to query documents for
  /// Returns a list of document IDs that can be assigned to the category.
  Future<List<String>> queryAvailableDocuments(String categoryId);

  /// Bulk update categories
  /// 
  /// [categories] - List of categories to update
  /// Performs batch updates for better performance.
  /// Throws an exception if the operation fails.
  Future<void> bulkUpdateCategories(List<CategoryModel> categories);

  /// Initialize empty category
  /// 
  /// [categoryId] - The category ID to initialize
  /// Sets up initial state for a newly created category.
  Future<void> initializeEmptyCategory(String categoryId);

  /// Start listening to real-time category updates
  /// 
  /// Returns a stream of category lists that updates in real-time
  /// when categories are modified in the data source.
  Stream<List<CategoryModel>> getCategoriesStream();

  /// Sync categories with external sources
  /// 
  /// Synchronizes local category data with external systems
  /// or performs cleanup operations.
  Future<void> syncCategories();

  /// Dispose resources
  /// 
  /// Cleans up any resources used by the repository.
  /// Should be called when the repository is no longer needed.
  void dispose();
}
