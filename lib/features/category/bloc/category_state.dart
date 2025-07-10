import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../models/category_model.dart';

part 'category_state.freezed.dart';

/// Category States for CategoryBloc
/// 
/// These states represent all possible states of the category management system.
@freezed
class CategoryState with _$CategoryState {
  /// Initial state when CategoryBloc is first created
  const factory CategoryState.initial() = CategoryInitial;

  /// Loading state when categories are being fetched
  /// 
  /// [message] - Optional loading message to display
  const factory CategoryState.loading({
    String? message,
  }) = CategoryLoading;

  /// Loaded state when categories have been successfully fetched
  /// 
  /// [categories] - All categories from the repository
  /// [filteredCategories] - Categories after applying filters and search
  /// [searchQuery] - Current search query
  /// [isActiveFilter] - Filter by active status (null for all)
  /// [userIdFilter] - Filter by user access (null for all)
  /// [sortBy] - Current sort field (name, createdAt, documentCount)
  /// [sortAscending] - Current sort order
  /// [isListening] - Whether real-time listening is active
  /// [statistics] - Category statistics (optional)
  /// [lastLoadTime] - Timestamp of last successful load
  const factory CategoryState.loaded({
    required List<CategoryModel> categories,
    required List<CategoryModel> filteredCategories,
    @Default('') String searchQuery,
    bool? isActiveFilter,
    String? userIdFilter,
    @Default('name') String sortBy,
    @Default(true) bool sortAscending,
    @Default(false) bool isListening,
    Map<String, dynamic>? statistics,
    DateTime? lastLoadTime,
  }) = CategoryLoaded;

  /// Error state when an operation fails
  /// 
  /// [message] - Error message to display
  /// [canRetry] - Whether the operation can be retried
  /// [previousState] - Previous state before error (optional)
  const factory CategoryState.error({
    required String message,
    @Default(true) bool canRetry,
    CategoryState? previousState,
  }) = CategoryError;

  /// Processing state when performing operations like add/update/delete
  /// 
  /// [message] - Processing message to display
  /// [categories] - Current categories list (optional)
  const factory CategoryState.processing({
    required String message,
    List<CategoryModel>? categories,
  }) = CategoryProcessing;

  /// Success state after successful operations
  /// 
  /// [message] - Success message to display
  /// [categories] - Updated categories list
  /// [operation] - Type of operation completed
  const factory CategoryState.success({
    required String message,
    required List<CategoryModel> categories,
    required String operation,
  }) = CategorySuccess;
}

/// Extension methods for CategoryState
extension CategoryStateExtension on CategoryState {
  /// Get the current list of categories regardless of state
  List<CategoryModel> get currentCategories {
    return when(
      initial: () => <CategoryModel>[],
      loading: (_) => <CategoryModel>[],
      loaded: (categories, _, __, ___, ____, _____, ______, _______, ________, _________) => categories,
      error: (_, __, previousState) => previousState?.currentCategories ?? <CategoryModel>[],
      processing: (_, categories) => categories ?? <CategoryModel>[],
      success: (_, categories, __) => categories,
    );
  }

  /// Get the current filtered categories
  List<CategoryModel> get currentFilteredCategories {
    return when(
      initial: () => <CategoryModel>[],
      loading: (_) => <CategoryModel>[],
      loaded: (_, filteredCategories, __, ___, ____, _____, ______, _______, ________, _________) => filteredCategories,
      error: (_, __, ___) => <CategoryModel>[],
      processing: (_, categories) => categories ?? <CategoryModel>[],
      success: (_, categories, __) => categories,
    );
  }

  /// Check if categories are loading
  bool get isLoading {
    return when(
      initial: () => false,
      loading: (_) => true,
      loaded: (_, __, ___, ____, _____, ______, _______, ________, _________, __________) => false,
      error: (_, __, ___) => false,
      processing: (_, __) => true,
      success: (_, __, ___) => false,
    );
  }

  /// Check if there's an error
  bool get hasError {
    return when(
      initial: () => false,
      loading: (_) => false,
      loaded: (_, __, ___, ____, _____, ______, _______, ________, _________, __________) => false,
      error: (_, __, ___) => true,
      processing: (_, __) => false,
      success: (_, __, ___) => false,
    );
  }

  /// Check if categories are loaded
  bool get isLoaded {
    return when(
      initial: () => false,
      loading: (_) => false,
      loaded: (_, __, ___, ____, _____, ______, _______, ________, _________, __________) => true,
      error: (_, __, ___) => false,
      processing: (_, __) => false,
      success: (_, __, ___) => true,
    );
  }

  /// Get current search query
  String get searchQuery {
    return when(
      initial: () => '',
      loading: (_) => '',
      loaded: (_, __, searchQuery, ___, ____, _____, ______, _______, ________, _________) => searchQuery,
      error: (_, __, ___) => '',
      processing: (_, __) => '',
      success: (_, __, ___) => '',
    );
  }

  /// Get active categories count
  int get activeCategoriesCount {
    return currentCategories.where((c) => c.isActive).length;
  }

  /// Get total document count across all categories
  int get totalDocumentCount {
    return currentCategories.fold(0, (sum, category) => sum + (category.documentCount ?? 0));
  }
}
