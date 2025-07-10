import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/category_model.dart';
import '../repositories/category_repository.dart';
import '../repositories/category_repository_impl.dart';
import 'category_event.dart' as events;
import 'category_state.dart' as states;

/// Category BLoC
///
/// This BLoC manages all category-related business logic and state.
/// It replaces the CategoryProvider with a more structured approach.
///
/// Features:
/// - Category CRUD operations
/// - Real-time category updates
/// - Search and filtering
/// - Sorting and pagination
/// - File assignment to categories
/// - Permission management
/// - Statistics and analytics
/// - Bulk operations
class CategoryBloc extends Bloc<events.CategoryEvent, states.CategoryState> {
  final CategoryRepository _repository;

  // Stream subscription for real-time updates
  StreamSubscription<List<CategoryModel>>? _categoriesSubscription;

  // Current filters and search state
  String _currentSearchQuery = '';
  bool? _currentIsActiveFilter;
  String? _currentUserIdFilter;
  String _currentSortBy = 'name';
  bool _currentSortAscending = true;

  CategoryBloc({CategoryRepository? repository})
    : _repository = repository ?? CategoryRepositoryImpl.instance,
      super(const states.CategoryState.initial()) {
    // Register event handlers
    on<events.LoadCategories>(_onLoadCategories);
    on<events.AddCategory>(_onAddCategory);
    on<events.UpdateCategory>(_onUpdateCategory);
    on<events.DeleteCategory>(_onDeleteCategory);
    on<events.ToggleCategoryStatus>(_onToggleCategoryStatus);
    on<events.SearchCategories>(_onSearchCategories);
    on<events.FilterCategories>(_onFilterCategories);
    on<events.SortCategories>(_onSortCategories);
    on<events.RefreshCategories>(_onRefreshCategories);
    on<events.LoadCategoriesForUser>(_onLoadCategoriesForUser);
    on<events.LoadCategoryStatistics>(_onLoadCategoryStatistics);
    on<events.ClearFilters>(_onClearFilters);
    on<events.StartListening>(_onStartListening);
    on<events.StopListening>(_onStopListening);
    on<events.CategoriesUpdated>(_onCategoriesUpdated);
    on<events.ResetState>(_onResetState);
    on<events.SyncCategories>(_onSyncCategories);
    on<events.QueryAvailableDocuments>(_onQueryAvailableDocuments);
    on<events.BulkUpdateCategories>(_onBulkUpdateCategories);
    on<events.InitializeEmptyCategory>(_onInitializeEmptyCategory);
    on<events.AddFilesToCategory>(_onAddFilesToCategory);
    on<events.RemoveFilesFromCategory>(_onRemoveFilesFromCategory);
    on<events.RefreshDocumentCounts>(_onRefreshDocumentCounts);
    on<events.SetCategoryPermissions>(_onSetCategoryPermissions);
  }

  /// Load all categories
  Future<void> _onLoadCategories(
    events.LoadCategories event,
    Emitter<states.CategoryState> emit,
  ) async {
    try {
      if (!event.forceRefresh && state is states.CategoryLoaded) {
        debugPrint('📁 CategoryBloc: Categories already loaded, skipping');
        return;
      }

      emit(
        const states.CategoryState.loading(message: 'Loading categories...'),
      );

      final categories = await _repository.getAllCategories();
      final filteredCategories = _applyFiltersAndSearch(categories);

      emit(
        states.CategoryState.loaded(
          categories: categories,
          filteredCategories: filteredCategories,
          searchQuery: _currentSearchQuery,
          isActiveFilter: _currentIsActiveFilter,
          userIdFilter: _currentUserIdFilter,
          sortBy: _currentSortBy,
          sortAscending: _currentSortAscending,
          lastLoadTime: DateTime.now(),
        ),
      );

      debugPrint('✅ CategoryBloc: Loaded ${categories.length} categories');
    } catch (e) {
      emit(
        states.CategoryState.error(
          message: 'Failed to load categories: ${e.toString()}',
          canRetry: true,
        ),
      );
      debugPrint('❌ CategoryBloc: Error loading categories: $e');
    }
  }

  /// Add new category
  Future<void> _onAddCategory(
    events.AddCategory event,
    Emitter<states.CategoryState> emit,
  ) async {
    try {
      emit(
        states.CategoryState.processing(
          message: 'Adding category "${event.category.name}"...',
          categories: state.currentCategories,
        ),
      );

      final categoryId = await _repository.addCategory(event.category);

      // Reload categories to get the updated list
      final categories = await _repository.getAllCategories();
      final filteredCategories = _applyFiltersAndSearch(categories);

      emit(
        states.CategoryState.success(
          message: 'Category "${event.category.name}" added successfully',
          categories: categories,
          operation: 'add',
        ),
      );

      // Transition back to loaded state
      emit(
        states.CategoryState.loaded(
          categories: categories,
          filteredCategories: filteredCategories,
          searchQuery: _currentSearchQuery,
          isActiveFilter: _currentIsActiveFilter,
          userIdFilter: _currentUserIdFilter,
          sortBy: _currentSortBy,
          sortAscending: _currentSortAscending,
          lastLoadTime: DateTime.now(),
        ),
      );

      debugPrint('✅ CategoryBloc: Category added successfully: $categoryId');
    } catch (e) {
      emit(
        states.CategoryState.error(
          message: 'Failed to add category: ${e.toString()}',
          canRetry: true,
          previousState: state,
        ),
      );
      debugPrint('❌ CategoryBloc: Error adding category: $e');
    }
  }

  /// Update existing category
  Future<void> _onUpdateCategory(
    events.UpdateCategory event,
    Emitter<states.CategoryState> emit,
  ) async {
    try {
      emit(
        states.CategoryState.processing(
          message: 'Updating category "${event.category.name}"...',
          categories: state.currentCategories,
        ),
      );

      await _repository.updateCategory(event.category.id, event.category);

      // Reload categories to get the updated list
      final categories = await _repository.getAllCategories();
      final filteredCategories = _applyFiltersAndSearch(categories);

      emit(
        states.CategoryState.success(
          message: 'Category "${event.category.name}" updated successfully',
          categories: categories,
          operation: 'update',
        ),
      );

      // Transition back to loaded state
      emit(
        states.CategoryState.loaded(
          categories: categories,
          filteredCategories: filteredCategories,
          searchQuery: _currentSearchQuery,
          isActiveFilter: _currentIsActiveFilter,
          userIdFilter: _currentUserIdFilter,
          sortBy: _currentSortBy,
          sortAscending: _currentSortAscending,
          lastLoadTime: DateTime.now(),
        ),
      );

      debugPrint(
        '✅ CategoryBloc: Category updated successfully: ${event.category.id}',
      );
    } catch (e) {
      emit(
        states.CategoryState.error(
          message: 'Failed to update category: ${e.toString()}',
          canRetry: true,
          previousState: state,
        ),
      );
      debugPrint('❌ CategoryBloc: Error updating category: $e');
    }
  }

  /// Delete category
  Future<void> _onDeleteCategory(
    events.DeleteCategory event,
    Emitter<states.CategoryState> emit,
  ) async {
    try {
      // Find the category name for the message
      final category = state.currentCategories.firstWhere(
        (c) => c.id == event.categoryId,
        orElse: () => CategoryModel(
          id: event.categoryId,
          name: 'Unknown',
          description: '',
          createdBy: '',
          createdAt: DateTime.now(),
          permissions: [],
          isActive: true,
        ),
      );

      emit(
        states.CategoryState.processing(
          message: 'Deleting category "${category.name}"...',
          categories: state.currentCategories,
        ),
      );

      await _repository.deleteCategory(
        event.categoryId,
        event.userId,
        moveDocumentsTo: event.moveDocumentsTo,
      );

      // Reload categories to get the updated list
      final categories = await _repository.getAllCategories();
      final filteredCategories = _applyFiltersAndSearch(categories);

      emit(
        states.CategoryState.success(
          message: 'Category "${category.name}" deleted successfully',
          categories: categories,
          operation: 'delete',
        ),
      );

      // Transition back to loaded state
      emit(
        states.CategoryState.loaded(
          categories: categories,
          filteredCategories: filteredCategories,
          searchQuery: _currentSearchQuery,
          isActiveFilter: _currentIsActiveFilter,
          userIdFilter: _currentUserIdFilter,
          sortBy: _currentSortBy,
          sortAscending: _currentSortAscending,
          lastLoadTime: DateTime.now(),
        ),
      );

      debugPrint(
        '✅ CategoryBloc: Category deleted successfully: ${event.categoryId}',
      );
    } catch (e) {
      emit(
        states.CategoryState.error(
          message: 'Failed to delete category: ${e.toString()}',
          canRetry: true,
          previousState: state,
        ),
      );
      debugPrint('❌ CategoryBloc: Error deleting category: $e');
    }
  }

  /// Apply current filters and search to categories list
  List<CategoryModel> _applyFiltersAndSearch(List<CategoryModel> categories) {
    var filtered = categories;

    // Apply search filter
    if (_currentSearchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (category) =>
                category.name.toLowerCase().contains(
                  _currentSearchQuery.toLowerCase(),
                ) ||
                category.description.toLowerCase().contains(
                  _currentSearchQuery.toLowerCase(),
                ),
          )
          .toList();
    }

    // Apply active status filter
    if (_currentIsActiveFilter != null) {
      filtered = filtered
          .where((category) => category.isActive == _currentIsActiveFilter)
          .toList();
    }

    // Apply user filter
    if (_currentUserIdFilter != null) {
      filtered = filtered
          .where(
            (category) =>
                category.permissions.isEmpty || // Universal access
                category.permissions.contains(_currentUserIdFilter) ||
                category.createdBy == _currentUserIdFilter,
          )
          .toList();
    }

    // Apply sorting
    filtered.sort((a, b) {
      int comparison = 0;
      switch (_currentSortBy) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'createdAt':
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
        case 'documentCount':
          comparison = (a.documentCount ?? 0).compareTo(b.documentCount ?? 0);
          break;
        default:
          comparison = a.name.compareTo(b.name);
      }
      return _currentSortAscending ? comparison : -comparison;
    });

    return filtered;
  }

  /// Toggle category active status
  Future<void> _onToggleCategoryStatus(
    events.ToggleCategoryStatus event,
    Emitter<states.CategoryState> emit,
  ) async {
    try {
      emit(
        states.CategoryState.processing(
          message: 'Toggling category status...',
          categories: state.currentCategories,
        ),
      );

      final updatedCategory = await _repository.toggleCategoryStatus(
        event.categoryId,
      );

      // Reload categories to get the updated list
      final categories = await _repository.getAllCategories();
      final filteredCategories = _applyFiltersAndSearch(categories);

      emit(
        states.CategoryState.success(
          message:
              'Category status updated to ${updatedCategory.isActive ? "active" : "inactive"}',
          categories: categories,
          operation: 'toggle',
        ),
      );

      // Transition back to loaded state
      emit(
        states.CategoryState.loaded(
          categories: categories,
          filteredCategories: filteredCategories,
          searchQuery: _currentSearchQuery,
          isActiveFilter: _currentIsActiveFilter,
          userIdFilter: _currentUserIdFilter,
          sortBy: _currentSortBy,
          sortAscending: _currentSortAscending,
          lastLoadTime: DateTime.now(),
        ),
      );

      debugPrint(
        '✅ CategoryBloc: Category status toggled: ${event.categoryId}',
      );
    } catch (e) {
      emit(
        states.CategoryState.error(
          message: 'Failed to toggle category status: ${e.toString()}',
          canRetry: true,
          previousState: state,
        ),
      );
      debugPrint('❌ CategoryBloc: Error toggling category status: $e');
    }
  }

  /// Search categories
  Future<void> _onSearchCategories(
    events.SearchCategories event,
    Emitter<states.CategoryState> emit,
  ) async {
    _currentSearchQuery = event.query;

    if (state is states.CategoryLoaded) {
      final currentState = state as states.CategoryLoaded;
      final filteredCategories = _applyFiltersAndSearch(
        currentState.categories,
      );

      emit(
        currentState.copyWith(
          filteredCategories: filteredCategories,
          searchQuery: _currentSearchQuery,
        ),
      );

      debugPrint(
        '🔍 CategoryBloc: Search applied: "${event.query}" - ${filteredCategories.length} results',
      );
    }
  }

  /// Filter categories
  Future<void> _onFilterCategories(
    events.FilterCategories event,
    Emitter<states.CategoryState> emit,
  ) async {
    _currentIsActiveFilter = event.isActive;
    _currentUserIdFilter = event.userId;

    if (state is states.CategoryLoaded) {
      final currentState = state as states.CategoryLoaded;
      final filteredCategories = _applyFiltersAndSearch(
        currentState.categories,
      );

      emit(
        currentState.copyWith(
          filteredCategories: filteredCategories,
          isActiveFilter: _currentIsActiveFilter,
          userIdFilter: _currentUserIdFilter,
        ),
      );

      debugPrint(
        '🔍 CategoryBloc: Filters applied - ${filteredCategories.length} results',
      );
    }
  }

  /// Sort categories
  Future<void> _onSortCategories(
    events.SortCategories event,
    Emitter<states.CategoryState> emit,
  ) async {
    _currentSortBy = event.sortBy;
    _currentSortAscending = event.ascending;

    if (state is states.CategoryLoaded) {
      final currentState = state as states.CategoryLoaded;
      final filteredCategories = _applyFiltersAndSearch(
        currentState.categories,
      );

      emit(
        currentState.copyWith(
          filteredCategories: filteredCategories,
          sortBy: _currentSortBy,
          sortAscending: _currentSortAscending,
        ),
      );

      debugPrint(
        '📊 CategoryBloc: Sort applied: ${event.sortBy} ${event.ascending ? "ASC" : "DESC"}',
      );
    }
  }

  /// Refresh categories
  Future<void> _onRefreshCategories(
    events.RefreshCategories event,
    Emitter<states.CategoryState> emit,
  ) async {
    add(events.LoadCategories(forceRefresh: event.forceRefresh));
  }

  /// Load categories for specific user
  Future<void> _onLoadCategoriesForUser(
    events.LoadCategoriesForUser event,
    Emitter<states.CategoryState> emit,
  ) async {
    try {
      emit(
        const states.CategoryState.loading(
          message: 'Loading user categories...',
        ),
      );

      final categories = await _repository.getCategoriesForUser(event.userId);
      final filteredCategories = _applyFiltersAndSearch(categories);

      emit(
        states.CategoryState.loaded(
          categories: categories,
          filteredCategories: filteredCategories,
          searchQuery: _currentSearchQuery,
          isActiveFilter: _currentIsActiveFilter,
          userIdFilter: event.userId,
          sortBy: _currentSortBy,
          sortAscending: _currentSortAscending,
          lastLoadTime: DateTime.now(),
        ),
      );

      debugPrint(
        '✅ CategoryBloc: Loaded ${categories.length} categories for user: ${event.userId}',
      );
    } catch (e) {
      emit(
        states.CategoryState.error(
          message: 'Failed to load user categories: ${e.toString()}',
          canRetry: true,
        ),
      );
      debugPrint('❌ CategoryBloc: Error loading user categories: $e');
    }
  }

  /// Load category statistics
  Future<void> _onLoadCategoryStatistics(
    events.LoadCategoryStatistics event,
    Emitter<states.CategoryState> emit,
  ) async {
    try {
      if (state is states.CategoryLoaded) {
        final currentState = state as states.CategoryLoaded;
        final statistics = await _repository.getCategoryStatistics();

        emit(currentState.copyWith(statistics: statistics));

        debugPrint('📊 CategoryBloc: Statistics loaded');
      }
    } catch (e) {
      debugPrint('❌ CategoryBloc: Error loading statistics: $e');
      // Don't emit error for statistics as it's not critical
    }
  }

  /// Clear filters and search
  Future<void> _onClearFilters(
    events.ClearFilters event,
    Emitter<states.CategoryState> emit,
  ) async {
    _currentSearchQuery = '';
    _currentIsActiveFilter = null;
    _currentUserIdFilter = null;

    if (state is states.CategoryLoaded) {
      final currentState = state as states.CategoryLoaded;
      final filteredCategories = _applyFiltersAndSearch(
        currentState.categories,
      );

      emit(
        currentState.copyWith(
          filteredCategories: filteredCategories,
          searchQuery: _currentSearchQuery,
          isActiveFilter: _currentIsActiveFilter,
          userIdFilter: _currentUserIdFilter,
        ),
      );

      debugPrint('🧹 CategoryBloc: Filters cleared');
    }
  }

  /// Start listening to real-time updates
  Future<void> _onStartListening(
    events.StartListening event,
    Emitter<states.CategoryState> emit,
  ) async {
    try {
      _categoriesSubscription?.cancel();
      _categoriesSubscription = _repository.getCategoriesStream().listen(
        (categories) {
          add(events.CategoriesUpdated(categories: categories));
        },
        onError: (error) {
          debugPrint('❌ CategoryBloc: Stream error: $error');
        },
      );

      if (state is states.CategoryLoaded) {
        final currentState = state as states.CategoryLoaded;
        emit(currentState.copyWith(isListening: true));
      }

      debugPrint('📡 CategoryBloc: Started listening to real-time updates');
    } catch (e) {
      debugPrint('❌ CategoryBloc: Error starting real-time listening: $e');
    }
  }

  /// Stop listening to real-time updates
  Future<void> _onStopListening(
    events.StopListening event,
    Emitter<states.CategoryState> emit,
  ) async {
    _categoriesSubscription?.cancel();
    _categoriesSubscription = null;

    if (state is states.CategoryLoaded) {
      final currentState = state as states.CategoryLoaded;
      emit(currentState.copyWith(isListening: false));
    }

    debugPrint('📡 CategoryBloc: Stopped listening to real-time updates');
  }

  /// Handle real-time category updates
  Future<void> _onCategoriesUpdated(
    events.CategoriesUpdated event,
    Emitter<states.CategoryState> emit,
  ) async {
    if (state is states.CategoryLoaded) {
      final currentState = state as states.CategoryLoaded;
      final filteredCategories = _applyFiltersAndSearch(event.categories);

      emit(
        currentState.copyWith(
          categories: event.categories,
          filteredCategories: filteredCategories,
          lastLoadTime: DateTime.now(),
        ),
      );

      debugPrint(
        '📡 CategoryBloc: Real-time update - ${event.categories.length} categories',
      );
    }
  }

  /// Reset state to initial
  Future<void> _onResetState(
    events.ResetState event,
    Emitter<states.CategoryState> emit,
  ) async {
    _categoriesSubscription?.cancel();
    _categoriesSubscription = null;

    _currentSearchQuery = '';
    _currentIsActiveFilter = null;
    _currentUserIdFilter = null;
    _currentSortBy = 'name';
    _currentSortAscending = true;

    emit(const states.CategoryState.initial());
    debugPrint('🔄 CategoryBloc: State reset to initial');
  }

  /// Sync categories with external sources
  Future<void> _onSyncCategories(
    events.SyncCategories event,
    Emitter<states.CategoryState> emit,
  ) async {
    try {
      emit(
        states.CategoryState.processing(
          message: 'Syncing categories...',
          categories: state.currentCategories,
        ),
      );

      await _repository.syncCategories();

      // Reload categories after sync
      final categories = await _repository.getAllCategories();
      final filteredCategories = _applyFiltersAndSearch(categories);

      emit(
        states.CategoryState.loaded(
          categories: categories,
          filteredCategories: filteredCategories,
          searchQuery: _currentSearchQuery,
          isActiveFilter: _currentIsActiveFilter,
          userIdFilter: _currentUserIdFilter,
          sortBy: _currentSortBy,
          sortAscending: _currentSortAscending,
          lastLoadTime: DateTime.now(),
        ),
      );

      debugPrint('✅ CategoryBloc: Categories synced successfully');
    } catch (e) {
      emit(
        states.CategoryState.error(
          message: 'Failed to sync categories: ${e.toString()}',
          canRetry: true,
          previousState: state,
        ),
      );
      debugPrint('❌ CategoryBloc: Error syncing categories: $e');
    }
  }

  /// Query available documents for category assignment
  Future<void> _onQueryAvailableDocuments(
    events.QueryAvailableDocuments event,
    Emitter<states.CategoryState> emit,
  ) async {
    try {
      debugPrint(
        '🔍 CategoryBloc: Querying available documents for category: ${event.categoryId}',
      );

      final documentIds = await _repository.queryAvailableDocuments(
        event.categoryId,
      );

      debugPrint(
        '📊 CategoryBloc: Found ${documentIds.length} available documents',
      );
      // This could emit a specific state or trigger other actions if needed
    } catch (e) {
      debugPrint('❌ CategoryBloc: Error querying available documents: $e');
    }
  }

  /// Bulk update categories
  Future<void> _onBulkUpdateCategories(
    events.BulkUpdateCategories event,
    Emitter<states.CategoryState> emit,
  ) async {
    try {
      emit(
        states.CategoryState.processing(
          message: 'Updating ${event.categories.length} categories...',
          categories: state.currentCategories,
        ),
      );

      await _repository.bulkUpdateCategories(event.categories);

      // Reload categories after bulk update
      final categories = await _repository.getAllCategories();
      final filteredCategories = _applyFiltersAndSearch(categories);

      emit(
        states.CategoryState.success(
          message: '${event.categories.length} categories updated successfully',
          categories: categories,
          operation: 'bulk_update',
        ),
      );

      // Transition back to loaded state
      emit(
        states.CategoryState.loaded(
          categories: categories,
          filteredCategories: filteredCategories,
          searchQuery: _currentSearchQuery,
          isActiveFilter: _currentIsActiveFilter,
          userIdFilter: _currentUserIdFilter,
          sortBy: _currentSortBy,
          sortAscending: _currentSortAscending,
          lastLoadTime: DateTime.now(),
        ),
      );

      debugPrint(
        '✅ CategoryBloc: Bulk update completed for ${event.categories.length} categories',
      );
    } catch (e) {
      emit(
        states.CategoryState.error(
          message: 'Failed to bulk update categories: ${e.toString()}',
          canRetry: true,
          previousState: state,
        ),
      );
      debugPrint('❌ CategoryBloc: Error in bulk update: $e');
    }
  }

  /// Initialize empty category
  Future<void> _onInitializeEmptyCategory(
    events.InitializeEmptyCategory event,
    Emitter<states.CategoryState> emit,
  ) async {
    try {
      await _repository.initializeEmptyCategory(event.categoryId);
      debugPrint('✅ CategoryBloc: Category initialized: ${event.categoryId}');
    } catch (e) {
      debugPrint('❌ CategoryBloc: Error initializing category: $e');
      // Don't emit error as this is not critical
    }
  }

  /// Add files to category
  Future<void> _onAddFilesToCategory(
    events.AddFilesToCategory event,
    Emitter<states.CategoryState> emit,
  ) async {
    try {
      emit(
        states.CategoryState.processing(
          message: 'Adding ${event.documentIds.length} files to category...',
          categories: state.currentCategories,
        ),
      );

      await _repository.addFilesToCategory(event.categoryId, event.documentIds);

      // Reload categories to get updated document counts
      final categories = await _repository.getAllCategories();
      final filteredCategories = _applyFiltersAndSearch(categories);

      emit(
        states.CategoryState.success(
          message:
              '${event.documentIds.length} files added to category successfully',
          categories: categories,
          operation: 'add_files',
        ),
      );

      // Transition back to loaded state
      emit(
        states.CategoryState.loaded(
          categories: categories,
          filteredCategories: filteredCategories,
          searchQuery: _currentSearchQuery,
          isActiveFilter: _currentIsActiveFilter,
          userIdFilter: _currentUserIdFilter,
          sortBy: _currentSortBy,
          sortAscending: _currentSortAscending,
          lastLoadTime: DateTime.now(),
        ),
      );

      debugPrint(
        '✅ CategoryBloc: Added ${event.documentIds.length} files to category: ${event.categoryId}',
      );
    } catch (e) {
      emit(
        states.CategoryState.error(
          message: 'Failed to add files to category: ${e.toString()}',
          canRetry: true,
          previousState: state,
        ),
      );
      debugPrint('❌ CategoryBloc: Error adding files to category: $e');
    }
  }

  /// Remove files from category
  Future<void> _onRemoveFilesFromCategory(
    events.RemoveFilesFromCategory event,
    Emitter<states.CategoryState> emit,
  ) async {
    try {
      emit(
        states.CategoryState.processing(
          message:
              'Removing ${event.documentIds.length} files from category...',
          categories: state.currentCategories,
        ),
      );

      await _repository.removeFilesFromCategory(
        event.categoryId,
        event.documentIds,
      );

      // Reload categories to get updated document counts
      final categories = await _repository.getAllCategories();
      final filteredCategories = _applyFiltersAndSearch(categories);

      emit(
        states.CategoryState.success(
          message:
              '${event.documentIds.length} files removed from category successfully',
          categories: categories,
          operation: 'remove_files',
        ),
      );

      // Transition back to loaded state
      emit(
        states.CategoryState.loaded(
          categories: categories,
          filteredCategories: filteredCategories,
          searchQuery: _currentSearchQuery,
          isActiveFilter: _currentIsActiveFilter,
          userIdFilter: _currentUserIdFilter,
          sortBy: _currentSortBy,
          sortAscending: _currentSortAscending,
          lastLoadTime: DateTime.now(),
        ),
      );

      debugPrint(
        '✅ CategoryBloc: Removed ${event.documentIds.length} files from category: ${event.categoryId}',
      );
    } catch (e) {
      emit(
        states.CategoryState.error(
          message: 'Failed to remove files from category: ${e.toString()}',
          canRetry: true,
          previousState: state,
        ),
      );
      debugPrint('❌ CategoryBloc: Error removing files from category: $e');
    }
  }

  /// Refresh document counts
  Future<void> _onRefreshDocumentCounts(
    events.RefreshDocumentCounts event,
    Emitter<states.CategoryState> emit,
  ) async {
    try {
      emit(
        states.CategoryState.processing(
          message: 'Refreshing document counts...',
          categories: state.currentCategories,
        ),
      );

      await _repository.refreshDocumentCounts();

      // Reload categories to get updated counts
      final categories = await _repository.getAllCategories();
      final filteredCategories = _applyFiltersAndSearch(categories);

      emit(
        states.CategoryState.loaded(
          categories: categories,
          filteredCategories: filteredCategories,
          searchQuery: _currentSearchQuery,
          isActiveFilter: _currentIsActiveFilter,
          userIdFilter: _currentUserIdFilter,
          sortBy: _currentSortBy,
          sortAscending: _currentSortAscending,
          lastLoadTime: DateTime.now(),
        ),
      );

      debugPrint('✅ CategoryBloc: Document counts refreshed');
    } catch (e) {
      emit(
        states.CategoryState.error(
          message: 'Failed to refresh document counts: ${e.toString()}',
          canRetry: true,
          previousState: state,
        ),
      );
      debugPrint('❌ CategoryBloc: Error refreshing document counts: $e');
    }
  }

  /// Set category permissions
  Future<void> _onSetCategoryPermissions(
    events.SetCategoryPermissions event,
    Emitter<states.CategoryState> emit,
  ) async {
    try {
      emit(
        states.CategoryState.processing(
          message: 'Updating category permissions...',
          categories: state.currentCategories,
        ),
      );

      await _repository.setCategoryPermissions(
        event.categoryId,
        event.permissions,
      );

      // Reload categories to get updated permissions
      final categories = await _repository.getAllCategories();
      final filteredCategories = _applyFiltersAndSearch(categories);

      emit(
        states.CategoryState.success(
          message: 'Category permissions updated successfully',
          categories: categories,
          operation: 'set_permissions',
        ),
      );

      // Transition back to loaded state
      emit(
        states.CategoryState.loaded(
          categories: categories,
          filteredCategories: filteredCategories,
          searchQuery: _currentSearchQuery,
          isActiveFilter: _currentIsActiveFilter,
          userIdFilter: _currentUserIdFilter,
          sortBy: _currentSortBy,
          sortAscending: _currentSortAscending,
          lastLoadTime: DateTime.now(),
        ),
      );

      debugPrint(
        '✅ CategoryBloc: Category permissions updated: ${event.categoryId}',
      );
    } catch (e) {
      emit(
        states.CategoryState.error(
          message: 'Failed to update category permissions: ${e.toString()}',
          canRetry: true,
          previousState: state,
        ),
      );
      debugPrint('❌ CategoryBloc: Error updating category permissions: $e');
    }
  }

  @override
  Future<void> close() {
    _categoriesSubscription?.cancel();
    _repository.dispose();
    return super.close();
  }
}
