import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../models/category_model.dart';

part 'category_event.freezed.dart';

/// Category Events for CategoryBloc
///
/// These events represent all possible actions that can be performed
/// on categories in the application.
@freezed
class CategoryEvent with _$CategoryEvent {
  /// Load all categories
  ///
  /// [forceRefresh] - Whether to force refresh from server
  const factory CategoryEvent.loadCategories({
    @Default(false) bool forceRefresh,
  }) = LoadCategories;

  /// Add new category
  ///
  /// [category] - Category to add
  const factory CategoryEvent.addCategory({required CategoryModel category}) =
      AddCategory;

  /// Update existing category
  ///
  /// [category] - Updated category data
  const factory CategoryEvent.updateCategory({
    required CategoryModel category,
  }) = UpdateCategory;

  /// Delete category
  ///
  /// [categoryId] - ID of category to delete
  /// [userId] - ID of user performing the deletion
  /// [moveDocumentsTo] - Category ID to move documents to (optional)
  const factory CategoryEvent.deleteCategory({
    required String categoryId,
    required String userId,
    String? moveDocumentsTo,
  }) = DeleteCategory;

  /// Toggle category active status
  ///
  /// [categoryId] - ID of category to toggle
  const factory CategoryEvent.toggleCategoryStatus({
    required String categoryId,
  }) = ToggleCategoryStatus;

  /// Search categories
  ///
  /// [query] - Search query string
  const factory CategoryEvent.searchCategories({required String query}) =
      SearchCategories;

  /// Filter categories
  ///
  /// [isActive] - Filter by active status (null for all)
  /// [userId] - Filter by user access (null for all)
  const factory CategoryEvent.filterCategories({
    bool? isActive,
    String? userId,
  }) = FilterCategories;

  /// Sort categories
  ///
  /// [sortBy] - Field to sort by (name, createdAt, documentCount)
  /// [ascending] - Sort direction
  const factory CategoryEvent.sortCategories({
    required String sortBy,
    @Default(true) bool ascending,
  }) = SortCategories;

  /// Refresh categories
  ///
  /// [forceRefresh] - Whether to force refresh from server
  const factory CategoryEvent.refreshCategories({
    @Default(false) bool forceRefresh,
  }) = RefreshCategories;

  /// Load categories for specific user
  ///
  /// [userId] - User ID to load categories for
  const factory CategoryEvent.loadCategoriesForUser({required String userId}) =
      LoadCategoriesForUser;

  /// Load category statistics
  const factory CategoryEvent.loadCategoryStatistics() = LoadCategoryStatistics;

  /// Clear filters and search
  const factory CategoryEvent.clearFilters() = ClearFilters;

  /// Start listening to real-time updates
  const factory CategoryEvent.startListening() = StartListening;

  /// Stop listening to real-time updates
  const factory CategoryEvent.stopListening() = StopListening;

  /// Handle real-time category updates (internal event)
  ///
  /// [categories] - Updated categories list
  const factory CategoryEvent.categoriesUpdated({
    required List<CategoryModel> categories,
  }) = CategoriesUpdated;

  /// Reset state to initial
  const factory CategoryEvent.resetState() = ResetState;

  /// Sync categories with external sources
  const factory CategoryEvent.syncCategories() = SyncCategories;

  /// Query available documents for category assignment
  ///
  /// [categoryId] - Category ID to query documents for
  const factory CategoryEvent.queryAvailableDocuments({
    required String categoryId,
  }) = QueryAvailableDocuments;

  /// Bulk update categories
  ///
  /// [categories] - List of categories to update
  const factory CategoryEvent.bulkUpdateCategories({
    required List<CategoryModel> categories,
  }) = BulkUpdateCategories;

  /// Initialize empty category
  ///
  /// [categoryId] - Category ID to initialize
  const factory CategoryEvent.initializeEmptyCategory({
    required String categoryId,
  }) = InitializeEmptyCategory;

  /// Add files to category
  ///
  /// [categoryId] - Category ID
  /// [documentIds] - List of document IDs to add
  const factory CategoryEvent.addFilesToCategory({
    required String categoryId,
    required List<String> documentIds,
  }) = AddFilesToCategory;

  /// Remove files from category
  ///
  /// [categoryId] - Category ID
  /// [documentIds] - List of document IDs to remove
  const factory CategoryEvent.removeFilesFromCategory({
    required String categoryId,
    required List<String> documentIds,
  }) = RemoveFilesFromCategory;

  /// Refresh category document counts
  const factory CategoryEvent.refreshDocumentCounts() = RefreshDocumentCounts;

  /// Set category permissions
  ///
  /// [categoryId] - Category ID
  /// [permissions] - List of user IDs with permissions
  const factory CategoryEvent.setCategoryPermissions({
    required String categoryId,
    required List<String> permissions,
  }) = SetCategoryPermissions;
}
