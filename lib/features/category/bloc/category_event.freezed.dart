// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CategoryEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool forceRefresh) loadCategories,
    required TResult Function(CategoryModel category) addCategory,
    required TResult Function(CategoryModel category) updateCategory,
    required TResult Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )
    deleteCategory,
    required TResult Function(String categoryId) toggleCategoryStatus,
    required TResult Function(String query) searchCategories,
    required TResult Function(bool? isActive, String? userId) filterCategories,
    required TResult Function(String sortBy, bool ascending) sortCategories,
    required TResult Function(bool forceRefresh) refreshCategories,
    required TResult Function(String userId) loadCategoriesForUser,
    required TResult Function() loadCategoryStatistics,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<CategoryModel> categories) categoriesUpdated,
    required TResult Function() resetState,
    required TResult Function() syncCategories,
    required TResult Function(String categoryId) queryAvailableDocuments,
    required TResult Function(List<CategoryModel> categories)
    bulkUpdateCategories,
    required TResult Function(String categoryId) initializeEmptyCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    addFilesToCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    removeFilesFromCategory,
    required TResult Function() refreshDocumentCounts,
    required TResult Function(String categoryId, List<String> permissions)
    setCategoryPermissions,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh)? loadCategories,
    TResult? Function(CategoryModel category)? addCategory,
    TResult? Function(CategoryModel category)? updateCategory,
    TResult? Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )?
    deleteCategory,
    TResult? Function(String categoryId)? toggleCategoryStatus,
    TResult? Function(String query)? searchCategories,
    TResult? Function(bool? isActive, String? userId)? filterCategories,
    TResult? Function(String sortBy, bool ascending)? sortCategories,
    TResult? Function(bool forceRefresh)? refreshCategories,
    TResult? Function(String userId)? loadCategoriesForUser,
    TResult? Function()? loadCategoryStatistics,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult? Function()? resetState,
    TResult? Function()? syncCategories,
    TResult? Function(String categoryId)? queryAvailableDocuments,
    TResult? Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult? Function(String categoryId)? initializeEmptyCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult? Function()? refreshDocumentCounts,
    TResult? Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh)? loadCategories,
    TResult Function(CategoryModel category)? addCategory,
    TResult Function(CategoryModel category)? updateCategory,
    TResult Function(String categoryId, String userId, String? moveDocumentsTo)?
    deleteCategory,
    TResult Function(String categoryId)? toggleCategoryStatus,
    TResult Function(String query)? searchCategories,
    TResult Function(bool? isActive, String? userId)? filterCategories,
    TResult Function(String sortBy, bool ascending)? sortCategories,
    TResult Function(bool forceRefresh)? refreshCategories,
    TResult Function(String userId)? loadCategoriesForUser,
    TResult Function()? loadCategoryStatistics,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult Function()? resetState,
    TResult Function()? syncCategories,
    TResult Function(String categoryId)? queryAvailableDocuments,
    TResult Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult Function(String categoryId)? initializeEmptyCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult Function()? refreshDocumentCounts,
    TResult Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(AddCategory value) addCategory,
    required TResult Function(UpdateCategory value) updateCategory,
    required TResult Function(DeleteCategory value) deleteCategory,
    required TResult Function(ToggleCategoryStatus value) toggleCategoryStatus,
    required TResult Function(SearchCategories value) searchCategories,
    required TResult Function(FilterCategories value) filterCategories,
    required TResult Function(SortCategories value) sortCategories,
    required TResult Function(RefreshCategories value) refreshCategories,
    required TResult Function(LoadCategoriesForUser value)
    loadCategoriesForUser,
    required TResult Function(LoadCategoryStatistics value)
    loadCategoryStatistics,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(CategoriesUpdated value) categoriesUpdated,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SyncCategories value) syncCategories,
    required TResult Function(QueryAvailableDocuments value)
    queryAvailableDocuments,
    required TResult Function(BulkUpdateCategories value) bulkUpdateCategories,
    required TResult Function(InitializeEmptyCategory value)
    initializeEmptyCategory,
    required TResult Function(AddFilesToCategory value) addFilesToCategory,
    required TResult Function(RemoveFilesFromCategory value)
    removeFilesFromCategory,
    required TResult Function(RefreshDocumentCounts value)
    refreshDocumentCounts,
    required TResult Function(SetCategoryPermissions value)
    setCategoryPermissions,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(AddCategory value)? addCategory,
    TResult? Function(UpdateCategory value)? updateCategory,
    TResult? Function(DeleteCategory value)? deleteCategory,
    TResult? Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult? Function(SearchCategories value)? searchCategories,
    TResult? Function(FilterCategories value)? filterCategories,
    TResult? Function(SortCategories value)? sortCategories,
    TResult? Function(RefreshCategories value)? refreshCategories,
    TResult? Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult? Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(CategoriesUpdated value)? categoriesUpdated,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SyncCategories value)? syncCategories,
    TResult? Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult? Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult? Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult? Function(AddFilesToCategory value)? addFilesToCategory,
    TResult? Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult? Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult? Function(SetCategoryPermissions value)? setCategoryPermissions,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(AddCategory value)? addCategory,
    TResult Function(UpdateCategory value)? updateCategory,
    TResult Function(DeleteCategory value)? deleteCategory,
    TResult Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult Function(SearchCategories value)? searchCategories,
    TResult Function(FilterCategories value)? filterCategories,
    TResult Function(SortCategories value)? sortCategories,
    TResult Function(RefreshCategories value)? refreshCategories,
    TResult Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(CategoriesUpdated value)? categoriesUpdated,
    TResult Function(ResetState value)? resetState,
    TResult Function(SyncCategories value)? syncCategories,
    TResult Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult Function(AddFilesToCategory value)? addFilesToCategory,
    TResult Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult Function(SetCategoryPermissions value)? setCategoryPermissions,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryEventCopyWith<$Res> {
  factory $CategoryEventCopyWith(
    CategoryEvent value,
    $Res Function(CategoryEvent) then,
  ) = _$CategoryEventCopyWithImpl<$Res, CategoryEvent>;
}

/// @nodoc
class _$CategoryEventCopyWithImpl<$Res, $Val extends CategoryEvent>
    implements $CategoryEventCopyWith<$Res> {
  _$CategoryEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadCategoriesImplCopyWith<$Res> {
  factory _$$LoadCategoriesImplCopyWith(
    _$LoadCategoriesImpl value,
    $Res Function(_$LoadCategoriesImpl) then,
  ) = __$$LoadCategoriesImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool forceRefresh});
}

/// @nodoc
class __$$LoadCategoriesImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$LoadCategoriesImpl>
    implements _$$LoadCategoriesImplCopyWith<$Res> {
  __$$LoadCategoriesImplCopyWithImpl(
    _$LoadCategoriesImpl _value,
    $Res Function(_$LoadCategoriesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? forceRefresh = null}) {
    return _then(
      _$LoadCategoriesImpl(
        forceRefresh: null == forceRefresh
            ? _value.forceRefresh
            : forceRefresh // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$LoadCategoriesImpl implements LoadCategories {
  const _$LoadCategoriesImpl({this.forceRefresh = false});

  @override
  @JsonKey()
  final bool forceRefresh;

  @override
  String toString() {
    return 'CategoryEvent.loadCategories(forceRefresh: $forceRefresh)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadCategoriesImpl &&
            (identical(other.forceRefresh, forceRefresh) ||
                other.forceRefresh == forceRefresh));
  }

  @override
  int get hashCode => Object.hash(runtimeType, forceRefresh);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadCategoriesImplCopyWith<_$LoadCategoriesImpl> get copyWith =>
      __$$LoadCategoriesImplCopyWithImpl<_$LoadCategoriesImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool forceRefresh) loadCategories,
    required TResult Function(CategoryModel category) addCategory,
    required TResult Function(CategoryModel category) updateCategory,
    required TResult Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )
    deleteCategory,
    required TResult Function(String categoryId) toggleCategoryStatus,
    required TResult Function(String query) searchCategories,
    required TResult Function(bool? isActive, String? userId) filterCategories,
    required TResult Function(String sortBy, bool ascending) sortCategories,
    required TResult Function(bool forceRefresh) refreshCategories,
    required TResult Function(String userId) loadCategoriesForUser,
    required TResult Function() loadCategoryStatistics,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<CategoryModel> categories) categoriesUpdated,
    required TResult Function() resetState,
    required TResult Function() syncCategories,
    required TResult Function(String categoryId) queryAvailableDocuments,
    required TResult Function(List<CategoryModel> categories)
    bulkUpdateCategories,
    required TResult Function(String categoryId) initializeEmptyCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    addFilesToCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    removeFilesFromCategory,
    required TResult Function() refreshDocumentCounts,
    required TResult Function(String categoryId, List<String> permissions)
    setCategoryPermissions,
  }) {
    return loadCategories(forceRefresh);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh)? loadCategories,
    TResult? Function(CategoryModel category)? addCategory,
    TResult? Function(CategoryModel category)? updateCategory,
    TResult? Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )?
    deleteCategory,
    TResult? Function(String categoryId)? toggleCategoryStatus,
    TResult? Function(String query)? searchCategories,
    TResult? Function(bool? isActive, String? userId)? filterCategories,
    TResult? Function(String sortBy, bool ascending)? sortCategories,
    TResult? Function(bool forceRefresh)? refreshCategories,
    TResult? Function(String userId)? loadCategoriesForUser,
    TResult? Function()? loadCategoryStatistics,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult? Function()? resetState,
    TResult? Function()? syncCategories,
    TResult? Function(String categoryId)? queryAvailableDocuments,
    TResult? Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult? Function(String categoryId)? initializeEmptyCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult? Function()? refreshDocumentCounts,
    TResult? Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
  }) {
    return loadCategories?.call(forceRefresh);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh)? loadCategories,
    TResult Function(CategoryModel category)? addCategory,
    TResult Function(CategoryModel category)? updateCategory,
    TResult Function(String categoryId, String userId, String? moveDocumentsTo)?
    deleteCategory,
    TResult Function(String categoryId)? toggleCategoryStatus,
    TResult Function(String query)? searchCategories,
    TResult Function(bool? isActive, String? userId)? filterCategories,
    TResult Function(String sortBy, bool ascending)? sortCategories,
    TResult Function(bool forceRefresh)? refreshCategories,
    TResult Function(String userId)? loadCategoriesForUser,
    TResult Function()? loadCategoryStatistics,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult Function()? resetState,
    TResult Function()? syncCategories,
    TResult Function(String categoryId)? queryAvailableDocuments,
    TResult Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult Function(String categoryId)? initializeEmptyCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult Function()? refreshDocumentCounts,
    TResult Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (loadCategories != null) {
      return loadCategories(forceRefresh);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(AddCategory value) addCategory,
    required TResult Function(UpdateCategory value) updateCategory,
    required TResult Function(DeleteCategory value) deleteCategory,
    required TResult Function(ToggleCategoryStatus value) toggleCategoryStatus,
    required TResult Function(SearchCategories value) searchCategories,
    required TResult Function(FilterCategories value) filterCategories,
    required TResult Function(SortCategories value) sortCategories,
    required TResult Function(RefreshCategories value) refreshCategories,
    required TResult Function(LoadCategoriesForUser value)
    loadCategoriesForUser,
    required TResult Function(LoadCategoryStatistics value)
    loadCategoryStatistics,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(CategoriesUpdated value) categoriesUpdated,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SyncCategories value) syncCategories,
    required TResult Function(QueryAvailableDocuments value)
    queryAvailableDocuments,
    required TResult Function(BulkUpdateCategories value) bulkUpdateCategories,
    required TResult Function(InitializeEmptyCategory value)
    initializeEmptyCategory,
    required TResult Function(AddFilesToCategory value) addFilesToCategory,
    required TResult Function(RemoveFilesFromCategory value)
    removeFilesFromCategory,
    required TResult Function(RefreshDocumentCounts value)
    refreshDocumentCounts,
    required TResult Function(SetCategoryPermissions value)
    setCategoryPermissions,
  }) {
    return loadCategories(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(AddCategory value)? addCategory,
    TResult? Function(UpdateCategory value)? updateCategory,
    TResult? Function(DeleteCategory value)? deleteCategory,
    TResult? Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult? Function(SearchCategories value)? searchCategories,
    TResult? Function(FilterCategories value)? filterCategories,
    TResult? Function(SortCategories value)? sortCategories,
    TResult? Function(RefreshCategories value)? refreshCategories,
    TResult? Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult? Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(CategoriesUpdated value)? categoriesUpdated,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SyncCategories value)? syncCategories,
    TResult? Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult? Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult? Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult? Function(AddFilesToCategory value)? addFilesToCategory,
    TResult? Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult? Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult? Function(SetCategoryPermissions value)? setCategoryPermissions,
  }) {
    return loadCategories?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(AddCategory value)? addCategory,
    TResult Function(UpdateCategory value)? updateCategory,
    TResult Function(DeleteCategory value)? deleteCategory,
    TResult Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult Function(SearchCategories value)? searchCategories,
    TResult Function(FilterCategories value)? filterCategories,
    TResult Function(SortCategories value)? sortCategories,
    TResult Function(RefreshCategories value)? refreshCategories,
    TResult Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(CategoriesUpdated value)? categoriesUpdated,
    TResult Function(ResetState value)? resetState,
    TResult Function(SyncCategories value)? syncCategories,
    TResult Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult Function(AddFilesToCategory value)? addFilesToCategory,
    TResult Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult Function(SetCategoryPermissions value)? setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (loadCategories != null) {
      return loadCategories(this);
    }
    return orElse();
  }
}

abstract class LoadCategories implements CategoryEvent {
  const factory LoadCategories({final bool forceRefresh}) =
      _$LoadCategoriesImpl;

  bool get forceRefresh;

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadCategoriesImplCopyWith<_$LoadCategoriesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AddCategoryImplCopyWith<$Res> {
  factory _$$AddCategoryImplCopyWith(
    _$AddCategoryImpl value,
    $Res Function(_$AddCategoryImpl) then,
  ) = __$$AddCategoryImplCopyWithImpl<$Res>;
  @useResult
  $Res call({CategoryModel category});
}

/// @nodoc
class __$$AddCategoryImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$AddCategoryImpl>
    implements _$$AddCategoryImplCopyWith<$Res> {
  __$$AddCategoryImplCopyWithImpl(
    _$AddCategoryImpl _value,
    $Res Function(_$AddCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? category = null}) {
    return _then(
      _$AddCategoryImpl(
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as CategoryModel,
      ),
    );
  }
}

/// @nodoc

class _$AddCategoryImpl implements AddCategory {
  const _$AddCategoryImpl({required this.category});

  @override
  final CategoryModel category;

  @override
  String toString() {
    return 'CategoryEvent.addCategory(category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddCategoryImpl &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode => Object.hash(runtimeType, category);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddCategoryImplCopyWith<_$AddCategoryImpl> get copyWith =>
      __$$AddCategoryImplCopyWithImpl<_$AddCategoryImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool forceRefresh) loadCategories,
    required TResult Function(CategoryModel category) addCategory,
    required TResult Function(CategoryModel category) updateCategory,
    required TResult Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )
    deleteCategory,
    required TResult Function(String categoryId) toggleCategoryStatus,
    required TResult Function(String query) searchCategories,
    required TResult Function(bool? isActive, String? userId) filterCategories,
    required TResult Function(String sortBy, bool ascending) sortCategories,
    required TResult Function(bool forceRefresh) refreshCategories,
    required TResult Function(String userId) loadCategoriesForUser,
    required TResult Function() loadCategoryStatistics,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<CategoryModel> categories) categoriesUpdated,
    required TResult Function() resetState,
    required TResult Function() syncCategories,
    required TResult Function(String categoryId) queryAvailableDocuments,
    required TResult Function(List<CategoryModel> categories)
    bulkUpdateCategories,
    required TResult Function(String categoryId) initializeEmptyCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    addFilesToCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    removeFilesFromCategory,
    required TResult Function() refreshDocumentCounts,
    required TResult Function(String categoryId, List<String> permissions)
    setCategoryPermissions,
  }) {
    return addCategory(category);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh)? loadCategories,
    TResult? Function(CategoryModel category)? addCategory,
    TResult? Function(CategoryModel category)? updateCategory,
    TResult? Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )?
    deleteCategory,
    TResult? Function(String categoryId)? toggleCategoryStatus,
    TResult? Function(String query)? searchCategories,
    TResult? Function(bool? isActive, String? userId)? filterCategories,
    TResult? Function(String sortBy, bool ascending)? sortCategories,
    TResult? Function(bool forceRefresh)? refreshCategories,
    TResult? Function(String userId)? loadCategoriesForUser,
    TResult? Function()? loadCategoryStatistics,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult? Function()? resetState,
    TResult? Function()? syncCategories,
    TResult? Function(String categoryId)? queryAvailableDocuments,
    TResult? Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult? Function(String categoryId)? initializeEmptyCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult? Function()? refreshDocumentCounts,
    TResult? Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
  }) {
    return addCategory?.call(category);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh)? loadCategories,
    TResult Function(CategoryModel category)? addCategory,
    TResult Function(CategoryModel category)? updateCategory,
    TResult Function(String categoryId, String userId, String? moveDocumentsTo)?
    deleteCategory,
    TResult Function(String categoryId)? toggleCategoryStatus,
    TResult Function(String query)? searchCategories,
    TResult Function(bool? isActive, String? userId)? filterCategories,
    TResult Function(String sortBy, bool ascending)? sortCategories,
    TResult Function(bool forceRefresh)? refreshCategories,
    TResult Function(String userId)? loadCategoriesForUser,
    TResult Function()? loadCategoryStatistics,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult Function()? resetState,
    TResult Function()? syncCategories,
    TResult Function(String categoryId)? queryAvailableDocuments,
    TResult Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult Function(String categoryId)? initializeEmptyCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult Function()? refreshDocumentCounts,
    TResult Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (addCategory != null) {
      return addCategory(category);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(AddCategory value) addCategory,
    required TResult Function(UpdateCategory value) updateCategory,
    required TResult Function(DeleteCategory value) deleteCategory,
    required TResult Function(ToggleCategoryStatus value) toggleCategoryStatus,
    required TResult Function(SearchCategories value) searchCategories,
    required TResult Function(FilterCategories value) filterCategories,
    required TResult Function(SortCategories value) sortCategories,
    required TResult Function(RefreshCategories value) refreshCategories,
    required TResult Function(LoadCategoriesForUser value)
    loadCategoriesForUser,
    required TResult Function(LoadCategoryStatistics value)
    loadCategoryStatistics,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(CategoriesUpdated value) categoriesUpdated,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SyncCategories value) syncCategories,
    required TResult Function(QueryAvailableDocuments value)
    queryAvailableDocuments,
    required TResult Function(BulkUpdateCategories value) bulkUpdateCategories,
    required TResult Function(InitializeEmptyCategory value)
    initializeEmptyCategory,
    required TResult Function(AddFilesToCategory value) addFilesToCategory,
    required TResult Function(RemoveFilesFromCategory value)
    removeFilesFromCategory,
    required TResult Function(RefreshDocumentCounts value)
    refreshDocumentCounts,
    required TResult Function(SetCategoryPermissions value)
    setCategoryPermissions,
  }) {
    return addCategory(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(AddCategory value)? addCategory,
    TResult? Function(UpdateCategory value)? updateCategory,
    TResult? Function(DeleteCategory value)? deleteCategory,
    TResult? Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult? Function(SearchCategories value)? searchCategories,
    TResult? Function(FilterCategories value)? filterCategories,
    TResult? Function(SortCategories value)? sortCategories,
    TResult? Function(RefreshCategories value)? refreshCategories,
    TResult? Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult? Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(CategoriesUpdated value)? categoriesUpdated,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SyncCategories value)? syncCategories,
    TResult? Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult? Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult? Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult? Function(AddFilesToCategory value)? addFilesToCategory,
    TResult? Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult? Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult? Function(SetCategoryPermissions value)? setCategoryPermissions,
  }) {
    return addCategory?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(AddCategory value)? addCategory,
    TResult Function(UpdateCategory value)? updateCategory,
    TResult Function(DeleteCategory value)? deleteCategory,
    TResult Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult Function(SearchCategories value)? searchCategories,
    TResult Function(FilterCategories value)? filterCategories,
    TResult Function(SortCategories value)? sortCategories,
    TResult Function(RefreshCategories value)? refreshCategories,
    TResult Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(CategoriesUpdated value)? categoriesUpdated,
    TResult Function(ResetState value)? resetState,
    TResult Function(SyncCategories value)? syncCategories,
    TResult Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult Function(AddFilesToCategory value)? addFilesToCategory,
    TResult Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult Function(SetCategoryPermissions value)? setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (addCategory != null) {
      return addCategory(this);
    }
    return orElse();
  }
}

abstract class AddCategory implements CategoryEvent {
  const factory AddCategory({required final CategoryModel category}) =
      _$AddCategoryImpl;

  CategoryModel get category;

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddCategoryImplCopyWith<_$AddCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateCategoryImplCopyWith<$Res> {
  factory _$$UpdateCategoryImplCopyWith(
    _$UpdateCategoryImpl value,
    $Res Function(_$UpdateCategoryImpl) then,
  ) = __$$UpdateCategoryImplCopyWithImpl<$Res>;
  @useResult
  $Res call({CategoryModel category});
}

/// @nodoc
class __$$UpdateCategoryImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$UpdateCategoryImpl>
    implements _$$UpdateCategoryImplCopyWith<$Res> {
  __$$UpdateCategoryImplCopyWithImpl(
    _$UpdateCategoryImpl _value,
    $Res Function(_$UpdateCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? category = null}) {
    return _then(
      _$UpdateCategoryImpl(
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as CategoryModel,
      ),
    );
  }
}

/// @nodoc

class _$UpdateCategoryImpl implements UpdateCategory {
  const _$UpdateCategoryImpl({required this.category});

  @override
  final CategoryModel category;

  @override
  String toString() {
    return 'CategoryEvent.updateCategory(category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateCategoryImpl &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode => Object.hash(runtimeType, category);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateCategoryImplCopyWith<_$UpdateCategoryImpl> get copyWith =>
      __$$UpdateCategoryImplCopyWithImpl<_$UpdateCategoryImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool forceRefresh) loadCategories,
    required TResult Function(CategoryModel category) addCategory,
    required TResult Function(CategoryModel category) updateCategory,
    required TResult Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )
    deleteCategory,
    required TResult Function(String categoryId) toggleCategoryStatus,
    required TResult Function(String query) searchCategories,
    required TResult Function(bool? isActive, String? userId) filterCategories,
    required TResult Function(String sortBy, bool ascending) sortCategories,
    required TResult Function(bool forceRefresh) refreshCategories,
    required TResult Function(String userId) loadCategoriesForUser,
    required TResult Function() loadCategoryStatistics,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<CategoryModel> categories) categoriesUpdated,
    required TResult Function() resetState,
    required TResult Function() syncCategories,
    required TResult Function(String categoryId) queryAvailableDocuments,
    required TResult Function(List<CategoryModel> categories)
    bulkUpdateCategories,
    required TResult Function(String categoryId) initializeEmptyCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    addFilesToCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    removeFilesFromCategory,
    required TResult Function() refreshDocumentCounts,
    required TResult Function(String categoryId, List<String> permissions)
    setCategoryPermissions,
  }) {
    return updateCategory(category);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh)? loadCategories,
    TResult? Function(CategoryModel category)? addCategory,
    TResult? Function(CategoryModel category)? updateCategory,
    TResult? Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )?
    deleteCategory,
    TResult? Function(String categoryId)? toggleCategoryStatus,
    TResult? Function(String query)? searchCategories,
    TResult? Function(bool? isActive, String? userId)? filterCategories,
    TResult? Function(String sortBy, bool ascending)? sortCategories,
    TResult? Function(bool forceRefresh)? refreshCategories,
    TResult? Function(String userId)? loadCategoriesForUser,
    TResult? Function()? loadCategoryStatistics,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult? Function()? resetState,
    TResult? Function()? syncCategories,
    TResult? Function(String categoryId)? queryAvailableDocuments,
    TResult? Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult? Function(String categoryId)? initializeEmptyCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult? Function()? refreshDocumentCounts,
    TResult? Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
  }) {
    return updateCategory?.call(category);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh)? loadCategories,
    TResult Function(CategoryModel category)? addCategory,
    TResult Function(CategoryModel category)? updateCategory,
    TResult Function(String categoryId, String userId, String? moveDocumentsTo)?
    deleteCategory,
    TResult Function(String categoryId)? toggleCategoryStatus,
    TResult Function(String query)? searchCategories,
    TResult Function(bool? isActive, String? userId)? filterCategories,
    TResult Function(String sortBy, bool ascending)? sortCategories,
    TResult Function(bool forceRefresh)? refreshCategories,
    TResult Function(String userId)? loadCategoriesForUser,
    TResult Function()? loadCategoryStatistics,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult Function()? resetState,
    TResult Function()? syncCategories,
    TResult Function(String categoryId)? queryAvailableDocuments,
    TResult Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult Function(String categoryId)? initializeEmptyCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult Function()? refreshDocumentCounts,
    TResult Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (updateCategory != null) {
      return updateCategory(category);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(AddCategory value) addCategory,
    required TResult Function(UpdateCategory value) updateCategory,
    required TResult Function(DeleteCategory value) deleteCategory,
    required TResult Function(ToggleCategoryStatus value) toggleCategoryStatus,
    required TResult Function(SearchCategories value) searchCategories,
    required TResult Function(FilterCategories value) filterCategories,
    required TResult Function(SortCategories value) sortCategories,
    required TResult Function(RefreshCategories value) refreshCategories,
    required TResult Function(LoadCategoriesForUser value)
    loadCategoriesForUser,
    required TResult Function(LoadCategoryStatistics value)
    loadCategoryStatistics,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(CategoriesUpdated value) categoriesUpdated,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SyncCategories value) syncCategories,
    required TResult Function(QueryAvailableDocuments value)
    queryAvailableDocuments,
    required TResult Function(BulkUpdateCategories value) bulkUpdateCategories,
    required TResult Function(InitializeEmptyCategory value)
    initializeEmptyCategory,
    required TResult Function(AddFilesToCategory value) addFilesToCategory,
    required TResult Function(RemoveFilesFromCategory value)
    removeFilesFromCategory,
    required TResult Function(RefreshDocumentCounts value)
    refreshDocumentCounts,
    required TResult Function(SetCategoryPermissions value)
    setCategoryPermissions,
  }) {
    return updateCategory(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(AddCategory value)? addCategory,
    TResult? Function(UpdateCategory value)? updateCategory,
    TResult? Function(DeleteCategory value)? deleteCategory,
    TResult? Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult? Function(SearchCategories value)? searchCategories,
    TResult? Function(FilterCategories value)? filterCategories,
    TResult? Function(SortCategories value)? sortCategories,
    TResult? Function(RefreshCategories value)? refreshCategories,
    TResult? Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult? Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(CategoriesUpdated value)? categoriesUpdated,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SyncCategories value)? syncCategories,
    TResult? Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult? Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult? Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult? Function(AddFilesToCategory value)? addFilesToCategory,
    TResult? Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult? Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult? Function(SetCategoryPermissions value)? setCategoryPermissions,
  }) {
    return updateCategory?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(AddCategory value)? addCategory,
    TResult Function(UpdateCategory value)? updateCategory,
    TResult Function(DeleteCategory value)? deleteCategory,
    TResult Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult Function(SearchCategories value)? searchCategories,
    TResult Function(FilterCategories value)? filterCategories,
    TResult Function(SortCategories value)? sortCategories,
    TResult Function(RefreshCategories value)? refreshCategories,
    TResult Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(CategoriesUpdated value)? categoriesUpdated,
    TResult Function(ResetState value)? resetState,
    TResult Function(SyncCategories value)? syncCategories,
    TResult Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult Function(AddFilesToCategory value)? addFilesToCategory,
    TResult Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult Function(SetCategoryPermissions value)? setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (updateCategory != null) {
      return updateCategory(this);
    }
    return orElse();
  }
}

abstract class UpdateCategory implements CategoryEvent {
  const factory UpdateCategory({required final CategoryModel category}) =
      _$UpdateCategoryImpl;

  CategoryModel get category;

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateCategoryImplCopyWith<_$UpdateCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeleteCategoryImplCopyWith<$Res> {
  factory _$$DeleteCategoryImplCopyWith(
    _$DeleteCategoryImpl value,
    $Res Function(_$DeleteCategoryImpl) then,
  ) = __$$DeleteCategoryImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String categoryId, String userId, String? moveDocumentsTo});
}

/// @nodoc
class __$$DeleteCategoryImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$DeleteCategoryImpl>
    implements _$$DeleteCategoryImplCopyWith<$Res> {
  __$$DeleteCategoryImplCopyWithImpl(
    _$DeleteCategoryImpl _value,
    $Res Function(_$DeleteCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? userId = null,
    Object? moveDocumentsTo = freezed,
  }) {
    return _then(
      _$DeleteCategoryImpl(
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        moveDocumentsTo: freezed == moveDocumentsTo
            ? _value.moveDocumentsTo
            : moveDocumentsTo // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$DeleteCategoryImpl implements DeleteCategory {
  const _$DeleteCategoryImpl({
    required this.categoryId,
    required this.userId,
    this.moveDocumentsTo,
  });

  @override
  final String categoryId;
  @override
  final String userId;
  @override
  final String? moveDocumentsTo;

  @override
  String toString() {
    return 'CategoryEvent.deleteCategory(categoryId: $categoryId, userId: $userId, moveDocumentsTo: $moveDocumentsTo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteCategoryImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.moveDocumentsTo, moveDocumentsTo) ||
                other.moveDocumentsTo == moveDocumentsTo));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, categoryId, userId, moveDocumentsTo);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteCategoryImplCopyWith<_$DeleteCategoryImpl> get copyWith =>
      __$$DeleteCategoryImplCopyWithImpl<_$DeleteCategoryImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool forceRefresh) loadCategories,
    required TResult Function(CategoryModel category) addCategory,
    required TResult Function(CategoryModel category) updateCategory,
    required TResult Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )
    deleteCategory,
    required TResult Function(String categoryId) toggleCategoryStatus,
    required TResult Function(String query) searchCategories,
    required TResult Function(bool? isActive, String? userId) filterCategories,
    required TResult Function(String sortBy, bool ascending) sortCategories,
    required TResult Function(bool forceRefresh) refreshCategories,
    required TResult Function(String userId) loadCategoriesForUser,
    required TResult Function() loadCategoryStatistics,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<CategoryModel> categories) categoriesUpdated,
    required TResult Function() resetState,
    required TResult Function() syncCategories,
    required TResult Function(String categoryId) queryAvailableDocuments,
    required TResult Function(List<CategoryModel> categories)
    bulkUpdateCategories,
    required TResult Function(String categoryId) initializeEmptyCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    addFilesToCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    removeFilesFromCategory,
    required TResult Function() refreshDocumentCounts,
    required TResult Function(String categoryId, List<String> permissions)
    setCategoryPermissions,
  }) {
    return deleteCategory(categoryId, userId, moveDocumentsTo);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh)? loadCategories,
    TResult? Function(CategoryModel category)? addCategory,
    TResult? Function(CategoryModel category)? updateCategory,
    TResult? Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )?
    deleteCategory,
    TResult? Function(String categoryId)? toggleCategoryStatus,
    TResult? Function(String query)? searchCategories,
    TResult? Function(bool? isActive, String? userId)? filterCategories,
    TResult? Function(String sortBy, bool ascending)? sortCategories,
    TResult? Function(bool forceRefresh)? refreshCategories,
    TResult? Function(String userId)? loadCategoriesForUser,
    TResult? Function()? loadCategoryStatistics,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult? Function()? resetState,
    TResult? Function()? syncCategories,
    TResult? Function(String categoryId)? queryAvailableDocuments,
    TResult? Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult? Function(String categoryId)? initializeEmptyCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult? Function()? refreshDocumentCounts,
    TResult? Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
  }) {
    return deleteCategory?.call(categoryId, userId, moveDocumentsTo);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh)? loadCategories,
    TResult Function(CategoryModel category)? addCategory,
    TResult Function(CategoryModel category)? updateCategory,
    TResult Function(String categoryId, String userId, String? moveDocumentsTo)?
    deleteCategory,
    TResult Function(String categoryId)? toggleCategoryStatus,
    TResult Function(String query)? searchCategories,
    TResult Function(bool? isActive, String? userId)? filterCategories,
    TResult Function(String sortBy, bool ascending)? sortCategories,
    TResult Function(bool forceRefresh)? refreshCategories,
    TResult Function(String userId)? loadCategoriesForUser,
    TResult Function()? loadCategoryStatistics,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult Function()? resetState,
    TResult Function()? syncCategories,
    TResult Function(String categoryId)? queryAvailableDocuments,
    TResult Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult Function(String categoryId)? initializeEmptyCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult Function()? refreshDocumentCounts,
    TResult Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (deleteCategory != null) {
      return deleteCategory(categoryId, userId, moveDocumentsTo);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(AddCategory value) addCategory,
    required TResult Function(UpdateCategory value) updateCategory,
    required TResult Function(DeleteCategory value) deleteCategory,
    required TResult Function(ToggleCategoryStatus value) toggleCategoryStatus,
    required TResult Function(SearchCategories value) searchCategories,
    required TResult Function(FilterCategories value) filterCategories,
    required TResult Function(SortCategories value) sortCategories,
    required TResult Function(RefreshCategories value) refreshCategories,
    required TResult Function(LoadCategoriesForUser value)
    loadCategoriesForUser,
    required TResult Function(LoadCategoryStatistics value)
    loadCategoryStatistics,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(CategoriesUpdated value) categoriesUpdated,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SyncCategories value) syncCategories,
    required TResult Function(QueryAvailableDocuments value)
    queryAvailableDocuments,
    required TResult Function(BulkUpdateCategories value) bulkUpdateCategories,
    required TResult Function(InitializeEmptyCategory value)
    initializeEmptyCategory,
    required TResult Function(AddFilesToCategory value) addFilesToCategory,
    required TResult Function(RemoveFilesFromCategory value)
    removeFilesFromCategory,
    required TResult Function(RefreshDocumentCounts value)
    refreshDocumentCounts,
    required TResult Function(SetCategoryPermissions value)
    setCategoryPermissions,
  }) {
    return deleteCategory(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(AddCategory value)? addCategory,
    TResult? Function(UpdateCategory value)? updateCategory,
    TResult? Function(DeleteCategory value)? deleteCategory,
    TResult? Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult? Function(SearchCategories value)? searchCategories,
    TResult? Function(FilterCategories value)? filterCategories,
    TResult? Function(SortCategories value)? sortCategories,
    TResult? Function(RefreshCategories value)? refreshCategories,
    TResult? Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult? Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(CategoriesUpdated value)? categoriesUpdated,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SyncCategories value)? syncCategories,
    TResult? Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult? Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult? Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult? Function(AddFilesToCategory value)? addFilesToCategory,
    TResult? Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult? Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult? Function(SetCategoryPermissions value)? setCategoryPermissions,
  }) {
    return deleteCategory?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(AddCategory value)? addCategory,
    TResult Function(UpdateCategory value)? updateCategory,
    TResult Function(DeleteCategory value)? deleteCategory,
    TResult Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult Function(SearchCategories value)? searchCategories,
    TResult Function(FilterCategories value)? filterCategories,
    TResult Function(SortCategories value)? sortCategories,
    TResult Function(RefreshCategories value)? refreshCategories,
    TResult Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(CategoriesUpdated value)? categoriesUpdated,
    TResult Function(ResetState value)? resetState,
    TResult Function(SyncCategories value)? syncCategories,
    TResult Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult Function(AddFilesToCategory value)? addFilesToCategory,
    TResult Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult Function(SetCategoryPermissions value)? setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (deleteCategory != null) {
      return deleteCategory(this);
    }
    return orElse();
  }
}

abstract class DeleteCategory implements CategoryEvent {
  const factory DeleteCategory({
    required final String categoryId,
    required final String userId,
    final String? moveDocumentsTo,
  }) = _$DeleteCategoryImpl;

  String get categoryId;
  String get userId;
  String? get moveDocumentsTo;

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteCategoryImplCopyWith<_$DeleteCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ToggleCategoryStatusImplCopyWith<$Res> {
  factory _$$ToggleCategoryStatusImplCopyWith(
    _$ToggleCategoryStatusImpl value,
    $Res Function(_$ToggleCategoryStatusImpl) then,
  ) = __$$ToggleCategoryStatusImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String categoryId});
}

/// @nodoc
class __$$ToggleCategoryStatusImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$ToggleCategoryStatusImpl>
    implements _$$ToggleCategoryStatusImplCopyWith<$Res> {
  __$$ToggleCategoryStatusImplCopyWithImpl(
    _$ToggleCategoryStatusImpl _value,
    $Res Function(_$ToggleCategoryStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? categoryId = null}) {
    return _then(
      _$ToggleCategoryStatusImpl(
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ToggleCategoryStatusImpl implements ToggleCategoryStatus {
  const _$ToggleCategoryStatusImpl({required this.categoryId});

  @override
  final String categoryId;

  @override
  String toString() {
    return 'CategoryEvent.toggleCategoryStatus(categoryId: $categoryId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToggleCategoryStatusImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, categoryId);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ToggleCategoryStatusImplCopyWith<_$ToggleCategoryStatusImpl>
  get copyWith =>
      __$$ToggleCategoryStatusImplCopyWithImpl<_$ToggleCategoryStatusImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool forceRefresh) loadCategories,
    required TResult Function(CategoryModel category) addCategory,
    required TResult Function(CategoryModel category) updateCategory,
    required TResult Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )
    deleteCategory,
    required TResult Function(String categoryId) toggleCategoryStatus,
    required TResult Function(String query) searchCategories,
    required TResult Function(bool? isActive, String? userId) filterCategories,
    required TResult Function(String sortBy, bool ascending) sortCategories,
    required TResult Function(bool forceRefresh) refreshCategories,
    required TResult Function(String userId) loadCategoriesForUser,
    required TResult Function() loadCategoryStatistics,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<CategoryModel> categories) categoriesUpdated,
    required TResult Function() resetState,
    required TResult Function() syncCategories,
    required TResult Function(String categoryId) queryAvailableDocuments,
    required TResult Function(List<CategoryModel> categories)
    bulkUpdateCategories,
    required TResult Function(String categoryId) initializeEmptyCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    addFilesToCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    removeFilesFromCategory,
    required TResult Function() refreshDocumentCounts,
    required TResult Function(String categoryId, List<String> permissions)
    setCategoryPermissions,
  }) {
    return toggleCategoryStatus(categoryId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh)? loadCategories,
    TResult? Function(CategoryModel category)? addCategory,
    TResult? Function(CategoryModel category)? updateCategory,
    TResult? Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )?
    deleteCategory,
    TResult? Function(String categoryId)? toggleCategoryStatus,
    TResult? Function(String query)? searchCategories,
    TResult? Function(bool? isActive, String? userId)? filterCategories,
    TResult? Function(String sortBy, bool ascending)? sortCategories,
    TResult? Function(bool forceRefresh)? refreshCategories,
    TResult? Function(String userId)? loadCategoriesForUser,
    TResult? Function()? loadCategoryStatistics,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult? Function()? resetState,
    TResult? Function()? syncCategories,
    TResult? Function(String categoryId)? queryAvailableDocuments,
    TResult? Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult? Function(String categoryId)? initializeEmptyCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult? Function()? refreshDocumentCounts,
    TResult? Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
  }) {
    return toggleCategoryStatus?.call(categoryId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh)? loadCategories,
    TResult Function(CategoryModel category)? addCategory,
    TResult Function(CategoryModel category)? updateCategory,
    TResult Function(String categoryId, String userId, String? moveDocumentsTo)?
    deleteCategory,
    TResult Function(String categoryId)? toggleCategoryStatus,
    TResult Function(String query)? searchCategories,
    TResult Function(bool? isActive, String? userId)? filterCategories,
    TResult Function(String sortBy, bool ascending)? sortCategories,
    TResult Function(bool forceRefresh)? refreshCategories,
    TResult Function(String userId)? loadCategoriesForUser,
    TResult Function()? loadCategoryStatistics,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult Function()? resetState,
    TResult Function()? syncCategories,
    TResult Function(String categoryId)? queryAvailableDocuments,
    TResult Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult Function(String categoryId)? initializeEmptyCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult Function()? refreshDocumentCounts,
    TResult Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (toggleCategoryStatus != null) {
      return toggleCategoryStatus(categoryId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(AddCategory value) addCategory,
    required TResult Function(UpdateCategory value) updateCategory,
    required TResult Function(DeleteCategory value) deleteCategory,
    required TResult Function(ToggleCategoryStatus value) toggleCategoryStatus,
    required TResult Function(SearchCategories value) searchCategories,
    required TResult Function(FilterCategories value) filterCategories,
    required TResult Function(SortCategories value) sortCategories,
    required TResult Function(RefreshCategories value) refreshCategories,
    required TResult Function(LoadCategoriesForUser value)
    loadCategoriesForUser,
    required TResult Function(LoadCategoryStatistics value)
    loadCategoryStatistics,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(CategoriesUpdated value) categoriesUpdated,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SyncCategories value) syncCategories,
    required TResult Function(QueryAvailableDocuments value)
    queryAvailableDocuments,
    required TResult Function(BulkUpdateCategories value) bulkUpdateCategories,
    required TResult Function(InitializeEmptyCategory value)
    initializeEmptyCategory,
    required TResult Function(AddFilesToCategory value) addFilesToCategory,
    required TResult Function(RemoveFilesFromCategory value)
    removeFilesFromCategory,
    required TResult Function(RefreshDocumentCounts value)
    refreshDocumentCounts,
    required TResult Function(SetCategoryPermissions value)
    setCategoryPermissions,
  }) {
    return toggleCategoryStatus(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(AddCategory value)? addCategory,
    TResult? Function(UpdateCategory value)? updateCategory,
    TResult? Function(DeleteCategory value)? deleteCategory,
    TResult? Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult? Function(SearchCategories value)? searchCategories,
    TResult? Function(FilterCategories value)? filterCategories,
    TResult? Function(SortCategories value)? sortCategories,
    TResult? Function(RefreshCategories value)? refreshCategories,
    TResult? Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult? Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(CategoriesUpdated value)? categoriesUpdated,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SyncCategories value)? syncCategories,
    TResult? Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult? Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult? Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult? Function(AddFilesToCategory value)? addFilesToCategory,
    TResult? Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult? Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult? Function(SetCategoryPermissions value)? setCategoryPermissions,
  }) {
    return toggleCategoryStatus?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(AddCategory value)? addCategory,
    TResult Function(UpdateCategory value)? updateCategory,
    TResult Function(DeleteCategory value)? deleteCategory,
    TResult Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult Function(SearchCategories value)? searchCategories,
    TResult Function(FilterCategories value)? filterCategories,
    TResult Function(SortCategories value)? sortCategories,
    TResult Function(RefreshCategories value)? refreshCategories,
    TResult Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(CategoriesUpdated value)? categoriesUpdated,
    TResult Function(ResetState value)? resetState,
    TResult Function(SyncCategories value)? syncCategories,
    TResult Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult Function(AddFilesToCategory value)? addFilesToCategory,
    TResult Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult Function(SetCategoryPermissions value)? setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (toggleCategoryStatus != null) {
      return toggleCategoryStatus(this);
    }
    return orElse();
  }
}

abstract class ToggleCategoryStatus implements CategoryEvent {
  const factory ToggleCategoryStatus({required final String categoryId}) =
      _$ToggleCategoryStatusImpl;

  String get categoryId;

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ToggleCategoryStatusImplCopyWith<_$ToggleCategoryStatusImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SearchCategoriesImplCopyWith<$Res> {
  factory _$$SearchCategoriesImplCopyWith(
    _$SearchCategoriesImpl value,
    $Res Function(_$SearchCategoriesImpl) then,
  ) = __$$SearchCategoriesImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String query});
}

/// @nodoc
class __$$SearchCategoriesImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$SearchCategoriesImpl>
    implements _$$SearchCategoriesImplCopyWith<$Res> {
  __$$SearchCategoriesImplCopyWithImpl(
    _$SearchCategoriesImpl _value,
    $Res Function(_$SearchCategoriesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? query = null}) {
    return _then(
      _$SearchCategoriesImpl(
        query: null == query
            ? _value.query
            : query // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SearchCategoriesImpl implements SearchCategories {
  const _$SearchCategoriesImpl({required this.query});

  @override
  final String query;

  @override
  String toString() {
    return 'CategoryEvent.searchCategories(query: $query)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchCategoriesImpl &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(runtimeType, query);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchCategoriesImplCopyWith<_$SearchCategoriesImpl> get copyWith =>
      __$$SearchCategoriesImplCopyWithImpl<_$SearchCategoriesImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool forceRefresh) loadCategories,
    required TResult Function(CategoryModel category) addCategory,
    required TResult Function(CategoryModel category) updateCategory,
    required TResult Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )
    deleteCategory,
    required TResult Function(String categoryId) toggleCategoryStatus,
    required TResult Function(String query) searchCategories,
    required TResult Function(bool? isActive, String? userId) filterCategories,
    required TResult Function(String sortBy, bool ascending) sortCategories,
    required TResult Function(bool forceRefresh) refreshCategories,
    required TResult Function(String userId) loadCategoriesForUser,
    required TResult Function() loadCategoryStatistics,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<CategoryModel> categories) categoriesUpdated,
    required TResult Function() resetState,
    required TResult Function() syncCategories,
    required TResult Function(String categoryId) queryAvailableDocuments,
    required TResult Function(List<CategoryModel> categories)
    bulkUpdateCategories,
    required TResult Function(String categoryId) initializeEmptyCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    addFilesToCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    removeFilesFromCategory,
    required TResult Function() refreshDocumentCounts,
    required TResult Function(String categoryId, List<String> permissions)
    setCategoryPermissions,
  }) {
    return searchCategories(query);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh)? loadCategories,
    TResult? Function(CategoryModel category)? addCategory,
    TResult? Function(CategoryModel category)? updateCategory,
    TResult? Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )?
    deleteCategory,
    TResult? Function(String categoryId)? toggleCategoryStatus,
    TResult? Function(String query)? searchCategories,
    TResult? Function(bool? isActive, String? userId)? filterCategories,
    TResult? Function(String sortBy, bool ascending)? sortCategories,
    TResult? Function(bool forceRefresh)? refreshCategories,
    TResult? Function(String userId)? loadCategoriesForUser,
    TResult? Function()? loadCategoryStatistics,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult? Function()? resetState,
    TResult? Function()? syncCategories,
    TResult? Function(String categoryId)? queryAvailableDocuments,
    TResult? Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult? Function(String categoryId)? initializeEmptyCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult? Function()? refreshDocumentCounts,
    TResult? Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
  }) {
    return searchCategories?.call(query);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh)? loadCategories,
    TResult Function(CategoryModel category)? addCategory,
    TResult Function(CategoryModel category)? updateCategory,
    TResult Function(String categoryId, String userId, String? moveDocumentsTo)?
    deleteCategory,
    TResult Function(String categoryId)? toggleCategoryStatus,
    TResult Function(String query)? searchCategories,
    TResult Function(bool? isActive, String? userId)? filterCategories,
    TResult Function(String sortBy, bool ascending)? sortCategories,
    TResult Function(bool forceRefresh)? refreshCategories,
    TResult Function(String userId)? loadCategoriesForUser,
    TResult Function()? loadCategoryStatistics,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult Function()? resetState,
    TResult Function()? syncCategories,
    TResult Function(String categoryId)? queryAvailableDocuments,
    TResult Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult Function(String categoryId)? initializeEmptyCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult Function()? refreshDocumentCounts,
    TResult Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (searchCategories != null) {
      return searchCategories(query);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(AddCategory value) addCategory,
    required TResult Function(UpdateCategory value) updateCategory,
    required TResult Function(DeleteCategory value) deleteCategory,
    required TResult Function(ToggleCategoryStatus value) toggleCategoryStatus,
    required TResult Function(SearchCategories value) searchCategories,
    required TResult Function(FilterCategories value) filterCategories,
    required TResult Function(SortCategories value) sortCategories,
    required TResult Function(RefreshCategories value) refreshCategories,
    required TResult Function(LoadCategoriesForUser value)
    loadCategoriesForUser,
    required TResult Function(LoadCategoryStatistics value)
    loadCategoryStatistics,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(CategoriesUpdated value) categoriesUpdated,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SyncCategories value) syncCategories,
    required TResult Function(QueryAvailableDocuments value)
    queryAvailableDocuments,
    required TResult Function(BulkUpdateCategories value) bulkUpdateCategories,
    required TResult Function(InitializeEmptyCategory value)
    initializeEmptyCategory,
    required TResult Function(AddFilesToCategory value) addFilesToCategory,
    required TResult Function(RemoveFilesFromCategory value)
    removeFilesFromCategory,
    required TResult Function(RefreshDocumentCounts value)
    refreshDocumentCounts,
    required TResult Function(SetCategoryPermissions value)
    setCategoryPermissions,
  }) {
    return searchCategories(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(AddCategory value)? addCategory,
    TResult? Function(UpdateCategory value)? updateCategory,
    TResult? Function(DeleteCategory value)? deleteCategory,
    TResult? Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult? Function(SearchCategories value)? searchCategories,
    TResult? Function(FilterCategories value)? filterCategories,
    TResult? Function(SortCategories value)? sortCategories,
    TResult? Function(RefreshCategories value)? refreshCategories,
    TResult? Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult? Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(CategoriesUpdated value)? categoriesUpdated,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SyncCategories value)? syncCategories,
    TResult? Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult? Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult? Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult? Function(AddFilesToCategory value)? addFilesToCategory,
    TResult? Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult? Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult? Function(SetCategoryPermissions value)? setCategoryPermissions,
  }) {
    return searchCategories?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(AddCategory value)? addCategory,
    TResult Function(UpdateCategory value)? updateCategory,
    TResult Function(DeleteCategory value)? deleteCategory,
    TResult Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult Function(SearchCategories value)? searchCategories,
    TResult Function(FilterCategories value)? filterCategories,
    TResult Function(SortCategories value)? sortCategories,
    TResult Function(RefreshCategories value)? refreshCategories,
    TResult Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(CategoriesUpdated value)? categoriesUpdated,
    TResult Function(ResetState value)? resetState,
    TResult Function(SyncCategories value)? syncCategories,
    TResult Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult Function(AddFilesToCategory value)? addFilesToCategory,
    TResult Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult Function(SetCategoryPermissions value)? setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (searchCategories != null) {
      return searchCategories(this);
    }
    return orElse();
  }
}

abstract class SearchCategories implements CategoryEvent {
  const factory SearchCategories({required final String query}) =
      _$SearchCategoriesImpl;

  String get query;

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchCategoriesImplCopyWith<_$SearchCategoriesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FilterCategoriesImplCopyWith<$Res> {
  factory _$$FilterCategoriesImplCopyWith(
    _$FilterCategoriesImpl value,
    $Res Function(_$FilterCategoriesImpl) then,
  ) = __$$FilterCategoriesImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool? isActive, String? userId});
}

/// @nodoc
class __$$FilterCategoriesImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$FilterCategoriesImpl>
    implements _$$FilterCategoriesImplCopyWith<$Res> {
  __$$FilterCategoriesImplCopyWithImpl(
    _$FilterCategoriesImpl _value,
    $Res Function(_$FilterCategoriesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isActive = freezed, Object? userId = freezed}) {
    return _then(
      _$FilterCategoriesImpl(
        isActive: freezed == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool?,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$FilterCategoriesImpl implements FilterCategories {
  const _$FilterCategoriesImpl({this.isActive, this.userId});

  @override
  final bool? isActive;
  @override
  final String? userId;

  @override
  String toString() {
    return 'CategoryEvent.filterCategories(isActive: $isActive, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterCategoriesImpl &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isActive, userId);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterCategoriesImplCopyWith<_$FilterCategoriesImpl> get copyWith =>
      __$$FilterCategoriesImplCopyWithImpl<_$FilterCategoriesImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool forceRefresh) loadCategories,
    required TResult Function(CategoryModel category) addCategory,
    required TResult Function(CategoryModel category) updateCategory,
    required TResult Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )
    deleteCategory,
    required TResult Function(String categoryId) toggleCategoryStatus,
    required TResult Function(String query) searchCategories,
    required TResult Function(bool? isActive, String? userId) filterCategories,
    required TResult Function(String sortBy, bool ascending) sortCategories,
    required TResult Function(bool forceRefresh) refreshCategories,
    required TResult Function(String userId) loadCategoriesForUser,
    required TResult Function() loadCategoryStatistics,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<CategoryModel> categories) categoriesUpdated,
    required TResult Function() resetState,
    required TResult Function() syncCategories,
    required TResult Function(String categoryId) queryAvailableDocuments,
    required TResult Function(List<CategoryModel> categories)
    bulkUpdateCategories,
    required TResult Function(String categoryId) initializeEmptyCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    addFilesToCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    removeFilesFromCategory,
    required TResult Function() refreshDocumentCounts,
    required TResult Function(String categoryId, List<String> permissions)
    setCategoryPermissions,
  }) {
    return filterCategories(isActive, userId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh)? loadCategories,
    TResult? Function(CategoryModel category)? addCategory,
    TResult? Function(CategoryModel category)? updateCategory,
    TResult? Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )?
    deleteCategory,
    TResult? Function(String categoryId)? toggleCategoryStatus,
    TResult? Function(String query)? searchCategories,
    TResult? Function(bool? isActive, String? userId)? filterCategories,
    TResult? Function(String sortBy, bool ascending)? sortCategories,
    TResult? Function(bool forceRefresh)? refreshCategories,
    TResult? Function(String userId)? loadCategoriesForUser,
    TResult? Function()? loadCategoryStatistics,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult? Function()? resetState,
    TResult? Function()? syncCategories,
    TResult? Function(String categoryId)? queryAvailableDocuments,
    TResult? Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult? Function(String categoryId)? initializeEmptyCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult? Function()? refreshDocumentCounts,
    TResult? Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
  }) {
    return filterCategories?.call(isActive, userId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh)? loadCategories,
    TResult Function(CategoryModel category)? addCategory,
    TResult Function(CategoryModel category)? updateCategory,
    TResult Function(String categoryId, String userId, String? moveDocumentsTo)?
    deleteCategory,
    TResult Function(String categoryId)? toggleCategoryStatus,
    TResult Function(String query)? searchCategories,
    TResult Function(bool? isActive, String? userId)? filterCategories,
    TResult Function(String sortBy, bool ascending)? sortCategories,
    TResult Function(bool forceRefresh)? refreshCategories,
    TResult Function(String userId)? loadCategoriesForUser,
    TResult Function()? loadCategoryStatistics,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult Function()? resetState,
    TResult Function()? syncCategories,
    TResult Function(String categoryId)? queryAvailableDocuments,
    TResult Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult Function(String categoryId)? initializeEmptyCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult Function()? refreshDocumentCounts,
    TResult Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (filterCategories != null) {
      return filterCategories(isActive, userId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(AddCategory value) addCategory,
    required TResult Function(UpdateCategory value) updateCategory,
    required TResult Function(DeleteCategory value) deleteCategory,
    required TResult Function(ToggleCategoryStatus value) toggleCategoryStatus,
    required TResult Function(SearchCategories value) searchCategories,
    required TResult Function(FilterCategories value) filterCategories,
    required TResult Function(SortCategories value) sortCategories,
    required TResult Function(RefreshCategories value) refreshCategories,
    required TResult Function(LoadCategoriesForUser value)
    loadCategoriesForUser,
    required TResult Function(LoadCategoryStatistics value)
    loadCategoryStatistics,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(CategoriesUpdated value) categoriesUpdated,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SyncCategories value) syncCategories,
    required TResult Function(QueryAvailableDocuments value)
    queryAvailableDocuments,
    required TResult Function(BulkUpdateCategories value) bulkUpdateCategories,
    required TResult Function(InitializeEmptyCategory value)
    initializeEmptyCategory,
    required TResult Function(AddFilesToCategory value) addFilesToCategory,
    required TResult Function(RemoveFilesFromCategory value)
    removeFilesFromCategory,
    required TResult Function(RefreshDocumentCounts value)
    refreshDocumentCounts,
    required TResult Function(SetCategoryPermissions value)
    setCategoryPermissions,
  }) {
    return filterCategories(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(AddCategory value)? addCategory,
    TResult? Function(UpdateCategory value)? updateCategory,
    TResult? Function(DeleteCategory value)? deleteCategory,
    TResult? Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult? Function(SearchCategories value)? searchCategories,
    TResult? Function(FilterCategories value)? filterCategories,
    TResult? Function(SortCategories value)? sortCategories,
    TResult? Function(RefreshCategories value)? refreshCategories,
    TResult? Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult? Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(CategoriesUpdated value)? categoriesUpdated,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SyncCategories value)? syncCategories,
    TResult? Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult? Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult? Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult? Function(AddFilesToCategory value)? addFilesToCategory,
    TResult? Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult? Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult? Function(SetCategoryPermissions value)? setCategoryPermissions,
  }) {
    return filterCategories?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(AddCategory value)? addCategory,
    TResult Function(UpdateCategory value)? updateCategory,
    TResult Function(DeleteCategory value)? deleteCategory,
    TResult Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult Function(SearchCategories value)? searchCategories,
    TResult Function(FilterCategories value)? filterCategories,
    TResult Function(SortCategories value)? sortCategories,
    TResult Function(RefreshCategories value)? refreshCategories,
    TResult Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(CategoriesUpdated value)? categoriesUpdated,
    TResult Function(ResetState value)? resetState,
    TResult Function(SyncCategories value)? syncCategories,
    TResult Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult Function(AddFilesToCategory value)? addFilesToCategory,
    TResult Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult Function(SetCategoryPermissions value)? setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (filterCategories != null) {
      return filterCategories(this);
    }
    return orElse();
  }
}

abstract class FilterCategories implements CategoryEvent {
  const factory FilterCategories({final bool? isActive, final String? userId}) =
      _$FilterCategoriesImpl;

  bool? get isActive;
  String? get userId;

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FilterCategoriesImplCopyWith<_$FilterCategoriesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SortCategoriesImplCopyWith<$Res> {
  factory _$$SortCategoriesImplCopyWith(
    _$SortCategoriesImpl value,
    $Res Function(_$SortCategoriesImpl) then,
  ) = __$$SortCategoriesImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String sortBy, bool ascending});
}

/// @nodoc
class __$$SortCategoriesImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$SortCategoriesImpl>
    implements _$$SortCategoriesImplCopyWith<$Res> {
  __$$SortCategoriesImplCopyWithImpl(
    _$SortCategoriesImpl _value,
    $Res Function(_$SortCategoriesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? sortBy = null, Object? ascending = null}) {
    return _then(
      _$SortCategoriesImpl(
        sortBy: null == sortBy
            ? _value.sortBy
            : sortBy // ignore: cast_nullable_to_non_nullable
                  as String,
        ascending: null == ascending
            ? _value.ascending
            : ascending // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$SortCategoriesImpl implements SortCategories {
  const _$SortCategoriesImpl({required this.sortBy, this.ascending = true});

  @override
  final String sortBy;
  @override
  @JsonKey()
  final bool ascending;

  @override
  String toString() {
    return 'CategoryEvent.sortCategories(sortBy: $sortBy, ascending: $ascending)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SortCategoriesImpl &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.ascending, ascending) ||
                other.ascending == ascending));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sortBy, ascending);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SortCategoriesImplCopyWith<_$SortCategoriesImpl> get copyWith =>
      __$$SortCategoriesImplCopyWithImpl<_$SortCategoriesImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool forceRefresh) loadCategories,
    required TResult Function(CategoryModel category) addCategory,
    required TResult Function(CategoryModel category) updateCategory,
    required TResult Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )
    deleteCategory,
    required TResult Function(String categoryId) toggleCategoryStatus,
    required TResult Function(String query) searchCategories,
    required TResult Function(bool? isActive, String? userId) filterCategories,
    required TResult Function(String sortBy, bool ascending) sortCategories,
    required TResult Function(bool forceRefresh) refreshCategories,
    required TResult Function(String userId) loadCategoriesForUser,
    required TResult Function() loadCategoryStatistics,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<CategoryModel> categories) categoriesUpdated,
    required TResult Function() resetState,
    required TResult Function() syncCategories,
    required TResult Function(String categoryId) queryAvailableDocuments,
    required TResult Function(List<CategoryModel> categories)
    bulkUpdateCategories,
    required TResult Function(String categoryId) initializeEmptyCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    addFilesToCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    removeFilesFromCategory,
    required TResult Function() refreshDocumentCounts,
    required TResult Function(String categoryId, List<String> permissions)
    setCategoryPermissions,
  }) {
    return sortCategories(sortBy, ascending);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh)? loadCategories,
    TResult? Function(CategoryModel category)? addCategory,
    TResult? Function(CategoryModel category)? updateCategory,
    TResult? Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )?
    deleteCategory,
    TResult? Function(String categoryId)? toggleCategoryStatus,
    TResult? Function(String query)? searchCategories,
    TResult? Function(bool? isActive, String? userId)? filterCategories,
    TResult? Function(String sortBy, bool ascending)? sortCategories,
    TResult? Function(bool forceRefresh)? refreshCategories,
    TResult? Function(String userId)? loadCategoriesForUser,
    TResult? Function()? loadCategoryStatistics,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult? Function()? resetState,
    TResult? Function()? syncCategories,
    TResult? Function(String categoryId)? queryAvailableDocuments,
    TResult? Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult? Function(String categoryId)? initializeEmptyCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult? Function()? refreshDocumentCounts,
    TResult? Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
  }) {
    return sortCategories?.call(sortBy, ascending);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh)? loadCategories,
    TResult Function(CategoryModel category)? addCategory,
    TResult Function(CategoryModel category)? updateCategory,
    TResult Function(String categoryId, String userId, String? moveDocumentsTo)?
    deleteCategory,
    TResult Function(String categoryId)? toggleCategoryStatus,
    TResult Function(String query)? searchCategories,
    TResult Function(bool? isActive, String? userId)? filterCategories,
    TResult Function(String sortBy, bool ascending)? sortCategories,
    TResult Function(bool forceRefresh)? refreshCategories,
    TResult Function(String userId)? loadCategoriesForUser,
    TResult Function()? loadCategoryStatistics,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult Function()? resetState,
    TResult Function()? syncCategories,
    TResult Function(String categoryId)? queryAvailableDocuments,
    TResult Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult Function(String categoryId)? initializeEmptyCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult Function()? refreshDocumentCounts,
    TResult Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (sortCategories != null) {
      return sortCategories(sortBy, ascending);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(AddCategory value) addCategory,
    required TResult Function(UpdateCategory value) updateCategory,
    required TResult Function(DeleteCategory value) deleteCategory,
    required TResult Function(ToggleCategoryStatus value) toggleCategoryStatus,
    required TResult Function(SearchCategories value) searchCategories,
    required TResult Function(FilterCategories value) filterCategories,
    required TResult Function(SortCategories value) sortCategories,
    required TResult Function(RefreshCategories value) refreshCategories,
    required TResult Function(LoadCategoriesForUser value)
    loadCategoriesForUser,
    required TResult Function(LoadCategoryStatistics value)
    loadCategoryStatistics,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(CategoriesUpdated value) categoriesUpdated,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SyncCategories value) syncCategories,
    required TResult Function(QueryAvailableDocuments value)
    queryAvailableDocuments,
    required TResult Function(BulkUpdateCategories value) bulkUpdateCategories,
    required TResult Function(InitializeEmptyCategory value)
    initializeEmptyCategory,
    required TResult Function(AddFilesToCategory value) addFilesToCategory,
    required TResult Function(RemoveFilesFromCategory value)
    removeFilesFromCategory,
    required TResult Function(RefreshDocumentCounts value)
    refreshDocumentCounts,
    required TResult Function(SetCategoryPermissions value)
    setCategoryPermissions,
  }) {
    return sortCategories(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(AddCategory value)? addCategory,
    TResult? Function(UpdateCategory value)? updateCategory,
    TResult? Function(DeleteCategory value)? deleteCategory,
    TResult? Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult? Function(SearchCategories value)? searchCategories,
    TResult? Function(FilterCategories value)? filterCategories,
    TResult? Function(SortCategories value)? sortCategories,
    TResult? Function(RefreshCategories value)? refreshCategories,
    TResult? Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult? Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(CategoriesUpdated value)? categoriesUpdated,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SyncCategories value)? syncCategories,
    TResult? Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult? Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult? Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult? Function(AddFilesToCategory value)? addFilesToCategory,
    TResult? Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult? Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult? Function(SetCategoryPermissions value)? setCategoryPermissions,
  }) {
    return sortCategories?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(AddCategory value)? addCategory,
    TResult Function(UpdateCategory value)? updateCategory,
    TResult Function(DeleteCategory value)? deleteCategory,
    TResult Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult Function(SearchCategories value)? searchCategories,
    TResult Function(FilterCategories value)? filterCategories,
    TResult Function(SortCategories value)? sortCategories,
    TResult Function(RefreshCategories value)? refreshCategories,
    TResult Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(CategoriesUpdated value)? categoriesUpdated,
    TResult Function(ResetState value)? resetState,
    TResult Function(SyncCategories value)? syncCategories,
    TResult Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult Function(AddFilesToCategory value)? addFilesToCategory,
    TResult Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult Function(SetCategoryPermissions value)? setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (sortCategories != null) {
      return sortCategories(this);
    }
    return orElse();
  }
}

abstract class SortCategories implements CategoryEvent {
  const factory SortCategories({
    required final String sortBy,
    final bool ascending,
  }) = _$SortCategoriesImpl;

  String get sortBy;
  bool get ascending;

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SortCategoriesImplCopyWith<_$SortCategoriesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RefreshCategoriesImplCopyWith<$Res> {
  factory _$$RefreshCategoriesImplCopyWith(
    _$RefreshCategoriesImpl value,
    $Res Function(_$RefreshCategoriesImpl) then,
  ) = __$$RefreshCategoriesImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool forceRefresh});
}

/// @nodoc
class __$$RefreshCategoriesImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$RefreshCategoriesImpl>
    implements _$$RefreshCategoriesImplCopyWith<$Res> {
  __$$RefreshCategoriesImplCopyWithImpl(
    _$RefreshCategoriesImpl _value,
    $Res Function(_$RefreshCategoriesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? forceRefresh = null}) {
    return _then(
      _$RefreshCategoriesImpl(
        forceRefresh: null == forceRefresh
            ? _value.forceRefresh
            : forceRefresh // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$RefreshCategoriesImpl implements RefreshCategories {
  const _$RefreshCategoriesImpl({this.forceRefresh = false});

  @override
  @JsonKey()
  final bool forceRefresh;

  @override
  String toString() {
    return 'CategoryEvent.refreshCategories(forceRefresh: $forceRefresh)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefreshCategoriesImpl &&
            (identical(other.forceRefresh, forceRefresh) ||
                other.forceRefresh == forceRefresh));
  }

  @override
  int get hashCode => Object.hash(runtimeType, forceRefresh);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefreshCategoriesImplCopyWith<_$RefreshCategoriesImpl> get copyWith =>
      __$$RefreshCategoriesImplCopyWithImpl<_$RefreshCategoriesImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool forceRefresh) loadCategories,
    required TResult Function(CategoryModel category) addCategory,
    required TResult Function(CategoryModel category) updateCategory,
    required TResult Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )
    deleteCategory,
    required TResult Function(String categoryId) toggleCategoryStatus,
    required TResult Function(String query) searchCategories,
    required TResult Function(bool? isActive, String? userId) filterCategories,
    required TResult Function(String sortBy, bool ascending) sortCategories,
    required TResult Function(bool forceRefresh) refreshCategories,
    required TResult Function(String userId) loadCategoriesForUser,
    required TResult Function() loadCategoryStatistics,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<CategoryModel> categories) categoriesUpdated,
    required TResult Function() resetState,
    required TResult Function() syncCategories,
    required TResult Function(String categoryId) queryAvailableDocuments,
    required TResult Function(List<CategoryModel> categories)
    bulkUpdateCategories,
    required TResult Function(String categoryId) initializeEmptyCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    addFilesToCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    removeFilesFromCategory,
    required TResult Function() refreshDocumentCounts,
    required TResult Function(String categoryId, List<String> permissions)
    setCategoryPermissions,
  }) {
    return refreshCategories(forceRefresh);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh)? loadCategories,
    TResult? Function(CategoryModel category)? addCategory,
    TResult? Function(CategoryModel category)? updateCategory,
    TResult? Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )?
    deleteCategory,
    TResult? Function(String categoryId)? toggleCategoryStatus,
    TResult? Function(String query)? searchCategories,
    TResult? Function(bool? isActive, String? userId)? filterCategories,
    TResult? Function(String sortBy, bool ascending)? sortCategories,
    TResult? Function(bool forceRefresh)? refreshCategories,
    TResult? Function(String userId)? loadCategoriesForUser,
    TResult? Function()? loadCategoryStatistics,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult? Function()? resetState,
    TResult? Function()? syncCategories,
    TResult? Function(String categoryId)? queryAvailableDocuments,
    TResult? Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult? Function(String categoryId)? initializeEmptyCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult? Function()? refreshDocumentCounts,
    TResult? Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
  }) {
    return refreshCategories?.call(forceRefresh);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh)? loadCategories,
    TResult Function(CategoryModel category)? addCategory,
    TResult Function(CategoryModel category)? updateCategory,
    TResult Function(String categoryId, String userId, String? moveDocumentsTo)?
    deleteCategory,
    TResult Function(String categoryId)? toggleCategoryStatus,
    TResult Function(String query)? searchCategories,
    TResult Function(bool? isActive, String? userId)? filterCategories,
    TResult Function(String sortBy, bool ascending)? sortCategories,
    TResult Function(bool forceRefresh)? refreshCategories,
    TResult Function(String userId)? loadCategoriesForUser,
    TResult Function()? loadCategoryStatistics,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult Function()? resetState,
    TResult Function()? syncCategories,
    TResult Function(String categoryId)? queryAvailableDocuments,
    TResult Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult Function(String categoryId)? initializeEmptyCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult Function()? refreshDocumentCounts,
    TResult Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (refreshCategories != null) {
      return refreshCategories(forceRefresh);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(AddCategory value) addCategory,
    required TResult Function(UpdateCategory value) updateCategory,
    required TResult Function(DeleteCategory value) deleteCategory,
    required TResult Function(ToggleCategoryStatus value) toggleCategoryStatus,
    required TResult Function(SearchCategories value) searchCategories,
    required TResult Function(FilterCategories value) filterCategories,
    required TResult Function(SortCategories value) sortCategories,
    required TResult Function(RefreshCategories value) refreshCategories,
    required TResult Function(LoadCategoriesForUser value)
    loadCategoriesForUser,
    required TResult Function(LoadCategoryStatistics value)
    loadCategoryStatistics,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(CategoriesUpdated value) categoriesUpdated,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SyncCategories value) syncCategories,
    required TResult Function(QueryAvailableDocuments value)
    queryAvailableDocuments,
    required TResult Function(BulkUpdateCategories value) bulkUpdateCategories,
    required TResult Function(InitializeEmptyCategory value)
    initializeEmptyCategory,
    required TResult Function(AddFilesToCategory value) addFilesToCategory,
    required TResult Function(RemoveFilesFromCategory value)
    removeFilesFromCategory,
    required TResult Function(RefreshDocumentCounts value)
    refreshDocumentCounts,
    required TResult Function(SetCategoryPermissions value)
    setCategoryPermissions,
  }) {
    return refreshCategories(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(AddCategory value)? addCategory,
    TResult? Function(UpdateCategory value)? updateCategory,
    TResult? Function(DeleteCategory value)? deleteCategory,
    TResult? Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult? Function(SearchCategories value)? searchCategories,
    TResult? Function(FilterCategories value)? filterCategories,
    TResult? Function(SortCategories value)? sortCategories,
    TResult? Function(RefreshCategories value)? refreshCategories,
    TResult? Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult? Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(CategoriesUpdated value)? categoriesUpdated,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SyncCategories value)? syncCategories,
    TResult? Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult? Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult? Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult? Function(AddFilesToCategory value)? addFilesToCategory,
    TResult? Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult? Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult? Function(SetCategoryPermissions value)? setCategoryPermissions,
  }) {
    return refreshCategories?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(AddCategory value)? addCategory,
    TResult Function(UpdateCategory value)? updateCategory,
    TResult Function(DeleteCategory value)? deleteCategory,
    TResult Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult Function(SearchCategories value)? searchCategories,
    TResult Function(FilterCategories value)? filterCategories,
    TResult Function(SortCategories value)? sortCategories,
    TResult Function(RefreshCategories value)? refreshCategories,
    TResult Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(CategoriesUpdated value)? categoriesUpdated,
    TResult Function(ResetState value)? resetState,
    TResult Function(SyncCategories value)? syncCategories,
    TResult Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult Function(AddFilesToCategory value)? addFilesToCategory,
    TResult Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult Function(SetCategoryPermissions value)? setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (refreshCategories != null) {
      return refreshCategories(this);
    }
    return orElse();
  }
}

abstract class RefreshCategories implements CategoryEvent {
  const factory RefreshCategories({final bool forceRefresh}) =
      _$RefreshCategoriesImpl;

  bool get forceRefresh;

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefreshCategoriesImplCopyWith<_$RefreshCategoriesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadCategoriesForUserImplCopyWith<$Res> {
  factory _$$LoadCategoriesForUserImplCopyWith(
    _$LoadCategoriesForUserImpl value,
    $Res Function(_$LoadCategoriesForUserImpl) then,
  ) = __$$LoadCategoriesForUserImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String userId});
}

/// @nodoc
class __$$LoadCategoriesForUserImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$LoadCategoriesForUserImpl>
    implements _$$LoadCategoriesForUserImplCopyWith<$Res> {
  __$$LoadCategoriesForUserImplCopyWithImpl(
    _$LoadCategoriesForUserImpl _value,
    $Res Function(_$LoadCategoriesForUserImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? userId = null}) {
    return _then(
      _$LoadCategoriesForUserImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$LoadCategoriesForUserImpl implements LoadCategoriesForUser {
  const _$LoadCategoriesForUserImpl({required this.userId});

  @override
  final String userId;

  @override
  String toString() {
    return 'CategoryEvent.loadCategoriesForUser(userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadCategoriesForUserImpl &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadCategoriesForUserImplCopyWith<_$LoadCategoriesForUserImpl>
  get copyWith =>
      __$$LoadCategoriesForUserImplCopyWithImpl<_$LoadCategoriesForUserImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool forceRefresh) loadCategories,
    required TResult Function(CategoryModel category) addCategory,
    required TResult Function(CategoryModel category) updateCategory,
    required TResult Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )
    deleteCategory,
    required TResult Function(String categoryId) toggleCategoryStatus,
    required TResult Function(String query) searchCategories,
    required TResult Function(bool? isActive, String? userId) filterCategories,
    required TResult Function(String sortBy, bool ascending) sortCategories,
    required TResult Function(bool forceRefresh) refreshCategories,
    required TResult Function(String userId) loadCategoriesForUser,
    required TResult Function() loadCategoryStatistics,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<CategoryModel> categories) categoriesUpdated,
    required TResult Function() resetState,
    required TResult Function() syncCategories,
    required TResult Function(String categoryId) queryAvailableDocuments,
    required TResult Function(List<CategoryModel> categories)
    bulkUpdateCategories,
    required TResult Function(String categoryId) initializeEmptyCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    addFilesToCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    removeFilesFromCategory,
    required TResult Function() refreshDocumentCounts,
    required TResult Function(String categoryId, List<String> permissions)
    setCategoryPermissions,
  }) {
    return loadCategoriesForUser(userId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh)? loadCategories,
    TResult? Function(CategoryModel category)? addCategory,
    TResult? Function(CategoryModel category)? updateCategory,
    TResult? Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )?
    deleteCategory,
    TResult? Function(String categoryId)? toggleCategoryStatus,
    TResult? Function(String query)? searchCategories,
    TResult? Function(bool? isActive, String? userId)? filterCategories,
    TResult? Function(String sortBy, bool ascending)? sortCategories,
    TResult? Function(bool forceRefresh)? refreshCategories,
    TResult? Function(String userId)? loadCategoriesForUser,
    TResult? Function()? loadCategoryStatistics,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult? Function()? resetState,
    TResult? Function()? syncCategories,
    TResult? Function(String categoryId)? queryAvailableDocuments,
    TResult? Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult? Function(String categoryId)? initializeEmptyCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult? Function()? refreshDocumentCounts,
    TResult? Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
  }) {
    return loadCategoriesForUser?.call(userId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh)? loadCategories,
    TResult Function(CategoryModel category)? addCategory,
    TResult Function(CategoryModel category)? updateCategory,
    TResult Function(String categoryId, String userId, String? moveDocumentsTo)?
    deleteCategory,
    TResult Function(String categoryId)? toggleCategoryStatus,
    TResult Function(String query)? searchCategories,
    TResult Function(bool? isActive, String? userId)? filterCategories,
    TResult Function(String sortBy, bool ascending)? sortCategories,
    TResult Function(bool forceRefresh)? refreshCategories,
    TResult Function(String userId)? loadCategoriesForUser,
    TResult Function()? loadCategoryStatistics,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult Function()? resetState,
    TResult Function()? syncCategories,
    TResult Function(String categoryId)? queryAvailableDocuments,
    TResult Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult Function(String categoryId)? initializeEmptyCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult Function()? refreshDocumentCounts,
    TResult Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (loadCategoriesForUser != null) {
      return loadCategoriesForUser(userId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(AddCategory value) addCategory,
    required TResult Function(UpdateCategory value) updateCategory,
    required TResult Function(DeleteCategory value) deleteCategory,
    required TResult Function(ToggleCategoryStatus value) toggleCategoryStatus,
    required TResult Function(SearchCategories value) searchCategories,
    required TResult Function(FilterCategories value) filterCategories,
    required TResult Function(SortCategories value) sortCategories,
    required TResult Function(RefreshCategories value) refreshCategories,
    required TResult Function(LoadCategoriesForUser value)
    loadCategoriesForUser,
    required TResult Function(LoadCategoryStatistics value)
    loadCategoryStatistics,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(CategoriesUpdated value) categoriesUpdated,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SyncCategories value) syncCategories,
    required TResult Function(QueryAvailableDocuments value)
    queryAvailableDocuments,
    required TResult Function(BulkUpdateCategories value) bulkUpdateCategories,
    required TResult Function(InitializeEmptyCategory value)
    initializeEmptyCategory,
    required TResult Function(AddFilesToCategory value) addFilesToCategory,
    required TResult Function(RemoveFilesFromCategory value)
    removeFilesFromCategory,
    required TResult Function(RefreshDocumentCounts value)
    refreshDocumentCounts,
    required TResult Function(SetCategoryPermissions value)
    setCategoryPermissions,
  }) {
    return loadCategoriesForUser(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(AddCategory value)? addCategory,
    TResult? Function(UpdateCategory value)? updateCategory,
    TResult? Function(DeleteCategory value)? deleteCategory,
    TResult? Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult? Function(SearchCategories value)? searchCategories,
    TResult? Function(FilterCategories value)? filterCategories,
    TResult? Function(SortCategories value)? sortCategories,
    TResult? Function(RefreshCategories value)? refreshCategories,
    TResult? Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult? Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(CategoriesUpdated value)? categoriesUpdated,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SyncCategories value)? syncCategories,
    TResult? Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult? Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult? Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult? Function(AddFilesToCategory value)? addFilesToCategory,
    TResult? Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult? Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult? Function(SetCategoryPermissions value)? setCategoryPermissions,
  }) {
    return loadCategoriesForUser?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(AddCategory value)? addCategory,
    TResult Function(UpdateCategory value)? updateCategory,
    TResult Function(DeleteCategory value)? deleteCategory,
    TResult Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult Function(SearchCategories value)? searchCategories,
    TResult Function(FilterCategories value)? filterCategories,
    TResult Function(SortCategories value)? sortCategories,
    TResult Function(RefreshCategories value)? refreshCategories,
    TResult Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(CategoriesUpdated value)? categoriesUpdated,
    TResult Function(ResetState value)? resetState,
    TResult Function(SyncCategories value)? syncCategories,
    TResult Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult Function(AddFilesToCategory value)? addFilesToCategory,
    TResult Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult Function(SetCategoryPermissions value)? setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (loadCategoriesForUser != null) {
      return loadCategoriesForUser(this);
    }
    return orElse();
  }
}

abstract class LoadCategoriesForUser implements CategoryEvent {
  const factory LoadCategoriesForUser({required final String userId}) =
      _$LoadCategoriesForUserImpl;

  String get userId;

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadCategoriesForUserImplCopyWith<_$LoadCategoriesForUserImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadCategoryStatisticsImplCopyWith<$Res> {
  factory _$$LoadCategoryStatisticsImplCopyWith(
    _$LoadCategoryStatisticsImpl value,
    $Res Function(_$LoadCategoryStatisticsImpl) then,
  ) = __$$LoadCategoryStatisticsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadCategoryStatisticsImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$LoadCategoryStatisticsImpl>
    implements _$$LoadCategoryStatisticsImplCopyWith<$Res> {
  __$$LoadCategoryStatisticsImplCopyWithImpl(
    _$LoadCategoryStatisticsImpl _value,
    $Res Function(_$LoadCategoryStatisticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadCategoryStatisticsImpl implements LoadCategoryStatistics {
  const _$LoadCategoryStatisticsImpl();

  @override
  String toString() {
    return 'CategoryEvent.loadCategoryStatistics()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadCategoryStatisticsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool forceRefresh) loadCategories,
    required TResult Function(CategoryModel category) addCategory,
    required TResult Function(CategoryModel category) updateCategory,
    required TResult Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )
    deleteCategory,
    required TResult Function(String categoryId) toggleCategoryStatus,
    required TResult Function(String query) searchCategories,
    required TResult Function(bool? isActive, String? userId) filterCategories,
    required TResult Function(String sortBy, bool ascending) sortCategories,
    required TResult Function(bool forceRefresh) refreshCategories,
    required TResult Function(String userId) loadCategoriesForUser,
    required TResult Function() loadCategoryStatistics,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<CategoryModel> categories) categoriesUpdated,
    required TResult Function() resetState,
    required TResult Function() syncCategories,
    required TResult Function(String categoryId) queryAvailableDocuments,
    required TResult Function(List<CategoryModel> categories)
    bulkUpdateCategories,
    required TResult Function(String categoryId) initializeEmptyCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    addFilesToCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    removeFilesFromCategory,
    required TResult Function() refreshDocumentCounts,
    required TResult Function(String categoryId, List<String> permissions)
    setCategoryPermissions,
  }) {
    return loadCategoryStatistics();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh)? loadCategories,
    TResult? Function(CategoryModel category)? addCategory,
    TResult? Function(CategoryModel category)? updateCategory,
    TResult? Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )?
    deleteCategory,
    TResult? Function(String categoryId)? toggleCategoryStatus,
    TResult? Function(String query)? searchCategories,
    TResult? Function(bool? isActive, String? userId)? filterCategories,
    TResult? Function(String sortBy, bool ascending)? sortCategories,
    TResult? Function(bool forceRefresh)? refreshCategories,
    TResult? Function(String userId)? loadCategoriesForUser,
    TResult? Function()? loadCategoryStatistics,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult? Function()? resetState,
    TResult? Function()? syncCategories,
    TResult? Function(String categoryId)? queryAvailableDocuments,
    TResult? Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult? Function(String categoryId)? initializeEmptyCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult? Function()? refreshDocumentCounts,
    TResult? Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
  }) {
    return loadCategoryStatistics?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh)? loadCategories,
    TResult Function(CategoryModel category)? addCategory,
    TResult Function(CategoryModel category)? updateCategory,
    TResult Function(String categoryId, String userId, String? moveDocumentsTo)?
    deleteCategory,
    TResult Function(String categoryId)? toggleCategoryStatus,
    TResult Function(String query)? searchCategories,
    TResult Function(bool? isActive, String? userId)? filterCategories,
    TResult Function(String sortBy, bool ascending)? sortCategories,
    TResult Function(bool forceRefresh)? refreshCategories,
    TResult Function(String userId)? loadCategoriesForUser,
    TResult Function()? loadCategoryStatistics,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult Function()? resetState,
    TResult Function()? syncCategories,
    TResult Function(String categoryId)? queryAvailableDocuments,
    TResult Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult Function(String categoryId)? initializeEmptyCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult Function()? refreshDocumentCounts,
    TResult Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (loadCategoryStatistics != null) {
      return loadCategoryStatistics();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(AddCategory value) addCategory,
    required TResult Function(UpdateCategory value) updateCategory,
    required TResult Function(DeleteCategory value) deleteCategory,
    required TResult Function(ToggleCategoryStatus value) toggleCategoryStatus,
    required TResult Function(SearchCategories value) searchCategories,
    required TResult Function(FilterCategories value) filterCategories,
    required TResult Function(SortCategories value) sortCategories,
    required TResult Function(RefreshCategories value) refreshCategories,
    required TResult Function(LoadCategoriesForUser value)
    loadCategoriesForUser,
    required TResult Function(LoadCategoryStatistics value)
    loadCategoryStatistics,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(CategoriesUpdated value) categoriesUpdated,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SyncCategories value) syncCategories,
    required TResult Function(QueryAvailableDocuments value)
    queryAvailableDocuments,
    required TResult Function(BulkUpdateCategories value) bulkUpdateCategories,
    required TResult Function(InitializeEmptyCategory value)
    initializeEmptyCategory,
    required TResult Function(AddFilesToCategory value) addFilesToCategory,
    required TResult Function(RemoveFilesFromCategory value)
    removeFilesFromCategory,
    required TResult Function(RefreshDocumentCounts value)
    refreshDocumentCounts,
    required TResult Function(SetCategoryPermissions value)
    setCategoryPermissions,
  }) {
    return loadCategoryStatistics(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(AddCategory value)? addCategory,
    TResult? Function(UpdateCategory value)? updateCategory,
    TResult? Function(DeleteCategory value)? deleteCategory,
    TResult? Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult? Function(SearchCategories value)? searchCategories,
    TResult? Function(FilterCategories value)? filterCategories,
    TResult? Function(SortCategories value)? sortCategories,
    TResult? Function(RefreshCategories value)? refreshCategories,
    TResult? Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult? Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(CategoriesUpdated value)? categoriesUpdated,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SyncCategories value)? syncCategories,
    TResult? Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult? Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult? Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult? Function(AddFilesToCategory value)? addFilesToCategory,
    TResult? Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult? Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult? Function(SetCategoryPermissions value)? setCategoryPermissions,
  }) {
    return loadCategoryStatistics?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(AddCategory value)? addCategory,
    TResult Function(UpdateCategory value)? updateCategory,
    TResult Function(DeleteCategory value)? deleteCategory,
    TResult Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult Function(SearchCategories value)? searchCategories,
    TResult Function(FilterCategories value)? filterCategories,
    TResult Function(SortCategories value)? sortCategories,
    TResult Function(RefreshCategories value)? refreshCategories,
    TResult Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(CategoriesUpdated value)? categoriesUpdated,
    TResult Function(ResetState value)? resetState,
    TResult Function(SyncCategories value)? syncCategories,
    TResult Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult Function(AddFilesToCategory value)? addFilesToCategory,
    TResult Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult Function(SetCategoryPermissions value)? setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (loadCategoryStatistics != null) {
      return loadCategoryStatistics(this);
    }
    return orElse();
  }
}

abstract class LoadCategoryStatistics implements CategoryEvent {
  const factory LoadCategoryStatistics() = _$LoadCategoryStatisticsImpl;
}

/// @nodoc
abstract class _$$ClearFiltersImplCopyWith<$Res> {
  factory _$$ClearFiltersImplCopyWith(
    _$ClearFiltersImpl value,
    $Res Function(_$ClearFiltersImpl) then,
  ) = __$$ClearFiltersImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ClearFiltersImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$ClearFiltersImpl>
    implements _$$ClearFiltersImplCopyWith<$Res> {
  __$$ClearFiltersImplCopyWithImpl(
    _$ClearFiltersImpl _value,
    $Res Function(_$ClearFiltersImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ClearFiltersImpl implements ClearFilters {
  const _$ClearFiltersImpl();

  @override
  String toString() {
    return 'CategoryEvent.clearFilters()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ClearFiltersImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool forceRefresh) loadCategories,
    required TResult Function(CategoryModel category) addCategory,
    required TResult Function(CategoryModel category) updateCategory,
    required TResult Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )
    deleteCategory,
    required TResult Function(String categoryId) toggleCategoryStatus,
    required TResult Function(String query) searchCategories,
    required TResult Function(bool? isActive, String? userId) filterCategories,
    required TResult Function(String sortBy, bool ascending) sortCategories,
    required TResult Function(bool forceRefresh) refreshCategories,
    required TResult Function(String userId) loadCategoriesForUser,
    required TResult Function() loadCategoryStatistics,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<CategoryModel> categories) categoriesUpdated,
    required TResult Function() resetState,
    required TResult Function() syncCategories,
    required TResult Function(String categoryId) queryAvailableDocuments,
    required TResult Function(List<CategoryModel> categories)
    bulkUpdateCategories,
    required TResult Function(String categoryId) initializeEmptyCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    addFilesToCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    removeFilesFromCategory,
    required TResult Function() refreshDocumentCounts,
    required TResult Function(String categoryId, List<String> permissions)
    setCategoryPermissions,
  }) {
    return clearFilters();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh)? loadCategories,
    TResult? Function(CategoryModel category)? addCategory,
    TResult? Function(CategoryModel category)? updateCategory,
    TResult? Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )?
    deleteCategory,
    TResult? Function(String categoryId)? toggleCategoryStatus,
    TResult? Function(String query)? searchCategories,
    TResult? Function(bool? isActive, String? userId)? filterCategories,
    TResult? Function(String sortBy, bool ascending)? sortCategories,
    TResult? Function(bool forceRefresh)? refreshCategories,
    TResult? Function(String userId)? loadCategoriesForUser,
    TResult? Function()? loadCategoryStatistics,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult? Function()? resetState,
    TResult? Function()? syncCategories,
    TResult? Function(String categoryId)? queryAvailableDocuments,
    TResult? Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult? Function(String categoryId)? initializeEmptyCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult? Function()? refreshDocumentCounts,
    TResult? Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
  }) {
    return clearFilters?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh)? loadCategories,
    TResult Function(CategoryModel category)? addCategory,
    TResult Function(CategoryModel category)? updateCategory,
    TResult Function(String categoryId, String userId, String? moveDocumentsTo)?
    deleteCategory,
    TResult Function(String categoryId)? toggleCategoryStatus,
    TResult Function(String query)? searchCategories,
    TResult Function(bool? isActive, String? userId)? filterCategories,
    TResult Function(String sortBy, bool ascending)? sortCategories,
    TResult Function(bool forceRefresh)? refreshCategories,
    TResult Function(String userId)? loadCategoriesForUser,
    TResult Function()? loadCategoryStatistics,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult Function()? resetState,
    TResult Function()? syncCategories,
    TResult Function(String categoryId)? queryAvailableDocuments,
    TResult Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult Function(String categoryId)? initializeEmptyCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult Function()? refreshDocumentCounts,
    TResult Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (clearFilters != null) {
      return clearFilters();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(AddCategory value) addCategory,
    required TResult Function(UpdateCategory value) updateCategory,
    required TResult Function(DeleteCategory value) deleteCategory,
    required TResult Function(ToggleCategoryStatus value) toggleCategoryStatus,
    required TResult Function(SearchCategories value) searchCategories,
    required TResult Function(FilterCategories value) filterCategories,
    required TResult Function(SortCategories value) sortCategories,
    required TResult Function(RefreshCategories value) refreshCategories,
    required TResult Function(LoadCategoriesForUser value)
    loadCategoriesForUser,
    required TResult Function(LoadCategoryStatistics value)
    loadCategoryStatistics,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(CategoriesUpdated value) categoriesUpdated,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SyncCategories value) syncCategories,
    required TResult Function(QueryAvailableDocuments value)
    queryAvailableDocuments,
    required TResult Function(BulkUpdateCategories value) bulkUpdateCategories,
    required TResult Function(InitializeEmptyCategory value)
    initializeEmptyCategory,
    required TResult Function(AddFilesToCategory value) addFilesToCategory,
    required TResult Function(RemoveFilesFromCategory value)
    removeFilesFromCategory,
    required TResult Function(RefreshDocumentCounts value)
    refreshDocumentCounts,
    required TResult Function(SetCategoryPermissions value)
    setCategoryPermissions,
  }) {
    return clearFilters(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(AddCategory value)? addCategory,
    TResult? Function(UpdateCategory value)? updateCategory,
    TResult? Function(DeleteCategory value)? deleteCategory,
    TResult? Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult? Function(SearchCategories value)? searchCategories,
    TResult? Function(FilterCategories value)? filterCategories,
    TResult? Function(SortCategories value)? sortCategories,
    TResult? Function(RefreshCategories value)? refreshCategories,
    TResult? Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult? Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(CategoriesUpdated value)? categoriesUpdated,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SyncCategories value)? syncCategories,
    TResult? Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult? Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult? Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult? Function(AddFilesToCategory value)? addFilesToCategory,
    TResult? Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult? Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult? Function(SetCategoryPermissions value)? setCategoryPermissions,
  }) {
    return clearFilters?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(AddCategory value)? addCategory,
    TResult Function(UpdateCategory value)? updateCategory,
    TResult Function(DeleteCategory value)? deleteCategory,
    TResult Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult Function(SearchCategories value)? searchCategories,
    TResult Function(FilterCategories value)? filterCategories,
    TResult Function(SortCategories value)? sortCategories,
    TResult Function(RefreshCategories value)? refreshCategories,
    TResult Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(CategoriesUpdated value)? categoriesUpdated,
    TResult Function(ResetState value)? resetState,
    TResult Function(SyncCategories value)? syncCategories,
    TResult Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult Function(AddFilesToCategory value)? addFilesToCategory,
    TResult Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult Function(SetCategoryPermissions value)? setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (clearFilters != null) {
      return clearFilters(this);
    }
    return orElse();
  }
}

abstract class ClearFilters implements CategoryEvent {
  const factory ClearFilters() = _$ClearFiltersImpl;
}

/// @nodoc
abstract class _$$StartListeningImplCopyWith<$Res> {
  factory _$$StartListeningImplCopyWith(
    _$StartListeningImpl value,
    $Res Function(_$StartListeningImpl) then,
  ) = __$$StartListeningImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StartListeningImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$StartListeningImpl>
    implements _$$StartListeningImplCopyWith<$Res> {
  __$$StartListeningImplCopyWithImpl(
    _$StartListeningImpl _value,
    $Res Function(_$StartListeningImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StartListeningImpl implements StartListening {
  const _$StartListeningImpl();

  @override
  String toString() {
    return 'CategoryEvent.startListening()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StartListeningImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool forceRefresh) loadCategories,
    required TResult Function(CategoryModel category) addCategory,
    required TResult Function(CategoryModel category) updateCategory,
    required TResult Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )
    deleteCategory,
    required TResult Function(String categoryId) toggleCategoryStatus,
    required TResult Function(String query) searchCategories,
    required TResult Function(bool? isActive, String? userId) filterCategories,
    required TResult Function(String sortBy, bool ascending) sortCategories,
    required TResult Function(bool forceRefresh) refreshCategories,
    required TResult Function(String userId) loadCategoriesForUser,
    required TResult Function() loadCategoryStatistics,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<CategoryModel> categories) categoriesUpdated,
    required TResult Function() resetState,
    required TResult Function() syncCategories,
    required TResult Function(String categoryId) queryAvailableDocuments,
    required TResult Function(List<CategoryModel> categories)
    bulkUpdateCategories,
    required TResult Function(String categoryId) initializeEmptyCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    addFilesToCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    removeFilesFromCategory,
    required TResult Function() refreshDocumentCounts,
    required TResult Function(String categoryId, List<String> permissions)
    setCategoryPermissions,
  }) {
    return startListening();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh)? loadCategories,
    TResult? Function(CategoryModel category)? addCategory,
    TResult? Function(CategoryModel category)? updateCategory,
    TResult? Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )?
    deleteCategory,
    TResult? Function(String categoryId)? toggleCategoryStatus,
    TResult? Function(String query)? searchCategories,
    TResult? Function(bool? isActive, String? userId)? filterCategories,
    TResult? Function(String sortBy, bool ascending)? sortCategories,
    TResult? Function(bool forceRefresh)? refreshCategories,
    TResult? Function(String userId)? loadCategoriesForUser,
    TResult? Function()? loadCategoryStatistics,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult? Function()? resetState,
    TResult? Function()? syncCategories,
    TResult? Function(String categoryId)? queryAvailableDocuments,
    TResult? Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult? Function(String categoryId)? initializeEmptyCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult? Function()? refreshDocumentCounts,
    TResult? Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
  }) {
    return startListening?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh)? loadCategories,
    TResult Function(CategoryModel category)? addCategory,
    TResult Function(CategoryModel category)? updateCategory,
    TResult Function(String categoryId, String userId, String? moveDocumentsTo)?
    deleteCategory,
    TResult Function(String categoryId)? toggleCategoryStatus,
    TResult Function(String query)? searchCategories,
    TResult Function(bool? isActive, String? userId)? filterCategories,
    TResult Function(String sortBy, bool ascending)? sortCategories,
    TResult Function(bool forceRefresh)? refreshCategories,
    TResult Function(String userId)? loadCategoriesForUser,
    TResult Function()? loadCategoryStatistics,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult Function()? resetState,
    TResult Function()? syncCategories,
    TResult Function(String categoryId)? queryAvailableDocuments,
    TResult Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult Function(String categoryId)? initializeEmptyCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult Function()? refreshDocumentCounts,
    TResult Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (startListening != null) {
      return startListening();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(AddCategory value) addCategory,
    required TResult Function(UpdateCategory value) updateCategory,
    required TResult Function(DeleteCategory value) deleteCategory,
    required TResult Function(ToggleCategoryStatus value) toggleCategoryStatus,
    required TResult Function(SearchCategories value) searchCategories,
    required TResult Function(FilterCategories value) filterCategories,
    required TResult Function(SortCategories value) sortCategories,
    required TResult Function(RefreshCategories value) refreshCategories,
    required TResult Function(LoadCategoriesForUser value)
    loadCategoriesForUser,
    required TResult Function(LoadCategoryStatistics value)
    loadCategoryStatistics,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(CategoriesUpdated value) categoriesUpdated,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SyncCategories value) syncCategories,
    required TResult Function(QueryAvailableDocuments value)
    queryAvailableDocuments,
    required TResult Function(BulkUpdateCategories value) bulkUpdateCategories,
    required TResult Function(InitializeEmptyCategory value)
    initializeEmptyCategory,
    required TResult Function(AddFilesToCategory value) addFilesToCategory,
    required TResult Function(RemoveFilesFromCategory value)
    removeFilesFromCategory,
    required TResult Function(RefreshDocumentCounts value)
    refreshDocumentCounts,
    required TResult Function(SetCategoryPermissions value)
    setCategoryPermissions,
  }) {
    return startListening(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(AddCategory value)? addCategory,
    TResult? Function(UpdateCategory value)? updateCategory,
    TResult? Function(DeleteCategory value)? deleteCategory,
    TResult? Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult? Function(SearchCategories value)? searchCategories,
    TResult? Function(FilterCategories value)? filterCategories,
    TResult? Function(SortCategories value)? sortCategories,
    TResult? Function(RefreshCategories value)? refreshCategories,
    TResult? Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult? Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(CategoriesUpdated value)? categoriesUpdated,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SyncCategories value)? syncCategories,
    TResult? Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult? Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult? Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult? Function(AddFilesToCategory value)? addFilesToCategory,
    TResult? Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult? Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult? Function(SetCategoryPermissions value)? setCategoryPermissions,
  }) {
    return startListening?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(AddCategory value)? addCategory,
    TResult Function(UpdateCategory value)? updateCategory,
    TResult Function(DeleteCategory value)? deleteCategory,
    TResult Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult Function(SearchCategories value)? searchCategories,
    TResult Function(FilterCategories value)? filterCategories,
    TResult Function(SortCategories value)? sortCategories,
    TResult Function(RefreshCategories value)? refreshCategories,
    TResult Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(CategoriesUpdated value)? categoriesUpdated,
    TResult Function(ResetState value)? resetState,
    TResult Function(SyncCategories value)? syncCategories,
    TResult Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult Function(AddFilesToCategory value)? addFilesToCategory,
    TResult Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult Function(SetCategoryPermissions value)? setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (startListening != null) {
      return startListening(this);
    }
    return orElse();
  }
}

abstract class StartListening implements CategoryEvent {
  const factory StartListening() = _$StartListeningImpl;
}

/// @nodoc
abstract class _$$StopListeningImplCopyWith<$Res> {
  factory _$$StopListeningImplCopyWith(
    _$StopListeningImpl value,
    $Res Function(_$StopListeningImpl) then,
  ) = __$$StopListeningImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StopListeningImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$StopListeningImpl>
    implements _$$StopListeningImplCopyWith<$Res> {
  __$$StopListeningImplCopyWithImpl(
    _$StopListeningImpl _value,
    $Res Function(_$StopListeningImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StopListeningImpl implements StopListening {
  const _$StopListeningImpl();

  @override
  String toString() {
    return 'CategoryEvent.stopListening()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StopListeningImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool forceRefresh) loadCategories,
    required TResult Function(CategoryModel category) addCategory,
    required TResult Function(CategoryModel category) updateCategory,
    required TResult Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )
    deleteCategory,
    required TResult Function(String categoryId) toggleCategoryStatus,
    required TResult Function(String query) searchCategories,
    required TResult Function(bool? isActive, String? userId) filterCategories,
    required TResult Function(String sortBy, bool ascending) sortCategories,
    required TResult Function(bool forceRefresh) refreshCategories,
    required TResult Function(String userId) loadCategoriesForUser,
    required TResult Function() loadCategoryStatistics,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<CategoryModel> categories) categoriesUpdated,
    required TResult Function() resetState,
    required TResult Function() syncCategories,
    required TResult Function(String categoryId) queryAvailableDocuments,
    required TResult Function(List<CategoryModel> categories)
    bulkUpdateCategories,
    required TResult Function(String categoryId) initializeEmptyCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    addFilesToCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    removeFilesFromCategory,
    required TResult Function() refreshDocumentCounts,
    required TResult Function(String categoryId, List<String> permissions)
    setCategoryPermissions,
  }) {
    return stopListening();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh)? loadCategories,
    TResult? Function(CategoryModel category)? addCategory,
    TResult? Function(CategoryModel category)? updateCategory,
    TResult? Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )?
    deleteCategory,
    TResult? Function(String categoryId)? toggleCategoryStatus,
    TResult? Function(String query)? searchCategories,
    TResult? Function(bool? isActive, String? userId)? filterCategories,
    TResult? Function(String sortBy, bool ascending)? sortCategories,
    TResult? Function(bool forceRefresh)? refreshCategories,
    TResult? Function(String userId)? loadCategoriesForUser,
    TResult? Function()? loadCategoryStatistics,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult? Function()? resetState,
    TResult? Function()? syncCategories,
    TResult? Function(String categoryId)? queryAvailableDocuments,
    TResult? Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult? Function(String categoryId)? initializeEmptyCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult? Function()? refreshDocumentCounts,
    TResult? Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
  }) {
    return stopListening?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh)? loadCategories,
    TResult Function(CategoryModel category)? addCategory,
    TResult Function(CategoryModel category)? updateCategory,
    TResult Function(String categoryId, String userId, String? moveDocumentsTo)?
    deleteCategory,
    TResult Function(String categoryId)? toggleCategoryStatus,
    TResult Function(String query)? searchCategories,
    TResult Function(bool? isActive, String? userId)? filterCategories,
    TResult Function(String sortBy, bool ascending)? sortCategories,
    TResult Function(bool forceRefresh)? refreshCategories,
    TResult Function(String userId)? loadCategoriesForUser,
    TResult Function()? loadCategoryStatistics,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult Function()? resetState,
    TResult Function()? syncCategories,
    TResult Function(String categoryId)? queryAvailableDocuments,
    TResult Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult Function(String categoryId)? initializeEmptyCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult Function()? refreshDocumentCounts,
    TResult Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (stopListening != null) {
      return stopListening();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(AddCategory value) addCategory,
    required TResult Function(UpdateCategory value) updateCategory,
    required TResult Function(DeleteCategory value) deleteCategory,
    required TResult Function(ToggleCategoryStatus value) toggleCategoryStatus,
    required TResult Function(SearchCategories value) searchCategories,
    required TResult Function(FilterCategories value) filterCategories,
    required TResult Function(SortCategories value) sortCategories,
    required TResult Function(RefreshCategories value) refreshCategories,
    required TResult Function(LoadCategoriesForUser value)
    loadCategoriesForUser,
    required TResult Function(LoadCategoryStatistics value)
    loadCategoryStatistics,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(CategoriesUpdated value) categoriesUpdated,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SyncCategories value) syncCategories,
    required TResult Function(QueryAvailableDocuments value)
    queryAvailableDocuments,
    required TResult Function(BulkUpdateCategories value) bulkUpdateCategories,
    required TResult Function(InitializeEmptyCategory value)
    initializeEmptyCategory,
    required TResult Function(AddFilesToCategory value) addFilesToCategory,
    required TResult Function(RemoveFilesFromCategory value)
    removeFilesFromCategory,
    required TResult Function(RefreshDocumentCounts value)
    refreshDocumentCounts,
    required TResult Function(SetCategoryPermissions value)
    setCategoryPermissions,
  }) {
    return stopListening(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(AddCategory value)? addCategory,
    TResult? Function(UpdateCategory value)? updateCategory,
    TResult? Function(DeleteCategory value)? deleteCategory,
    TResult? Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult? Function(SearchCategories value)? searchCategories,
    TResult? Function(FilterCategories value)? filterCategories,
    TResult? Function(SortCategories value)? sortCategories,
    TResult? Function(RefreshCategories value)? refreshCategories,
    TResult? Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult? Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(CategoriesUpdated value)? categoriesUpdated,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SyncCategories value)? syncCategories,
    TResult? Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult? Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult? Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult? Function(AddFilesToCategory value)? addFilesToCategory,
    TResult? Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult? Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult? Function(SetCategoryPermissions value)? setCategoryPermissions,
  }) {
    return stopListening?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(AddCategory value)? addCategory,
    TResult Function(UpdateCategory value)? updateCategory,
    TResult Function(DeleteCategory value)? deleteCategory,
    TResult Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult Function(SearchCategories value)? searchCategories,
    TResult Function(FilterCategories value)? filterCategories,
    TResult Function(SortCategories value)? sortCategories,
    TResult Function(RefreshCategories value)? refreshCategories,
    TResult Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(CategoriesUpdated value)? categoriesUpdated,
    TResult Function(ResetState value)? resetState,
    TResult Function(SyncCategories value)? syncCategories,
    TResult Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult Function(AddFilesToCategory value)? addFilesToCategory,
    TResult Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult Function(SetCategoryPermissions value)? setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (stopListening != null) {
      return stopListening(this);
    }
    return orElse();
  }
}

abstract class StopListening implements CategoryEvent {
  const factory StopListening() = _$StopListeningImpl;
}

/// @nodoc
abstract class _$$CategoriesUpdatedImplCopyWith<$Res> {
  factory _$$CategoriesUpdatedImplCopyWith(
    _$CategoriesUpdatedImpl value,
    $Res Function(_$CategoriesUpdatedImpl) then,
  ) = __$$CategoriesUpdatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<CategoryModel> categories});
}

/// @nodoc
class __$$CategoriesUpdatedImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$CategoriesUpdatedImpl>
    implements _$$CategoriesUpdatedImplCopyWith<$Res> {
  __$$CategoriesUpdatedImplCopyWithImpl(
    _$CategoriesUpdatedImpl _value,
    $Res Function(_$CategoriesUpdatedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? categories = null}) {
    return _then(
      _$CategoriesUpdatedImpl(
        categories: null == categories
            ? _value._categories
            : categories // ignore: cast_nullable_to_non_nullable
                  as List<CategoryModel>,
      ),
    );
  }
}

/// @nodoc

class _$CategoriesUpdatedImpl implements CategoriesUpdated {
  const _$CategoriesUpdatedImpl({required final List<CategoryModel> categories})
    : _categories = categories;

  final List<CategoryModel> _categories;
  @override
  List<CategoryModel> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  String toString() {
    return 'CategoryEvent.categoriesUpdated(categories: $categories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoriesUpdatedImpl &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_categories),
  );

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoriesUpdatedImplCopyWith<_$CategoriesUpdatedImpl> get copyWith =>
      __$$CategoriesUpdatedImplCopyWithImpl<_$CategoriesUpdatedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool forceRefresh) loadCategories,
    required TResult Function(CategoryModel category) addCategory,
    required TResult Function(CategoryModel category) updateCategory,
    required TResult Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )
    deleteCategory,
    required TResult Function(String categoryId) toggleCategoryStatus,
    required TResult Function(String query) searchCategories,
    required TResult Function(bool? isActive, String? userId) filterCategories,
    required TResult Function(String sortBy, bool ascending) sortCategories,
    required TResult Function(bool forceRefresh) refreshCategories,
    required TResult Function(String userId) loadCategoriesForUser,
    required TResult Function() loadCategoryStatistics,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<CategoryModel> categories) categoriesUpdated,
    required TResult Function() resetState,
    required TResult Function() syncCategories,
    required TResult Function(String categoryId) queryAvailableDocuments,
    required TResult Function(List<CategoryModel> categories)
    bulkUpdateCategories,
    required TResult Function(String categoryId) initializeEmptyCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    addFilesToCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    removeFilesFromCategory,
    required TResult Function() refreshDocumentCounts,
    required TResult Function(String categoryId, List<String> permissions)
    setCategoryPermissions,
  }) {
    return categoriesUpdated(categories);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh)? loadCategories,
    TResult? Function(CategoryModel category)? addCategory,
    TResult? Function(CategoryModel category)? updateCategory,
    TResult? Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )?
    deleteCategory,
    TResult? Function(String categoryId)? toggleCategoryStatus,
    TResult? Function(String query)? searchCategories,
    TResult? Function(bool? isActive, String? userId)? filterCategories,
    TResult? Function(String sortBy, bool ascending)? sortCategories,
    TResult? Function(bool forceRefresh)? refreshCategories,
    TResult? Function(String userId)? loadCategoriesForUser,
    TResult? Function()? loadCategoryStatistics,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult? Function()? resetState,
    TResult? Function()? syncCategories,
    TResult? Function(String categoryId)? queryAvailableDocuments,
    TResult? Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult? Function(String categoryId)? initializeEmptyCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult? Function()? refreshDocumentCounts,
    TResult? Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
  }) {
    return categoriesUpdated?.call(categories);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh)? loadCategories,
    TResult Function(CategoryModel category)? addCategory,
    TResult Function(CategoryModel category)? updateCategory,
    TResult Function(String categoryId, String userId, String? moveDocumentsTo)?
    deleteCategory,
    TResult Function(String categoryId)? toggleCategoryStatus,
    TResult Function(String query)? searchCategories,
    TResult Function(bool? isActive, String? userId)? filterCategories,
    TResult Function(String sortBy, bool ascending)? sortCategories,
    TResult Function(bool forceRefresh)? refreshCategories,
    TResult Function(String userId)? loadCategoriesForUser,
    TResult Function()? loadCategoryStatistics,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult Function()? resetState,
    TResult Function()? syncCategories,
    TResult Function(String categoryId)? queryAvailableDocuments,
    TResult Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult Function(String categoryId)? initializeEmptyCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult Function()? refreshDocumentCounts,
    TResult Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (categoriesUpdated != null) {
      return categoriesUpdated(categories);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(AddCategory value) addCategory,
    required TResult Function(UpdateCategory value) updateCategory,
    required TResult Function(DeleteCategory value) deleteCategory,
    required TResult Function(ToggleCategoryStatus value) toggleCategoryStatus,
    required TResult Function(SearchCategories value) searchCategories,
    required TResult Function(FilterCategories value) filterCategories,
    required TResult Function(SortCategories value) sortCategories,
    required TResult Function(RefreshCategories value) refreshCategories,
    required TResult Function(LoadCategoriesForUser value)
    loadCategoriesForUser,
    required TResult Function(LoadCategoryStatistics value)
    loadCategoryStatistics,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(CategoriesUpdated value) categoriesUpdated,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SyncCategories value) syncCategories,
    required TResult Function(QueryAvailableDocuments value)
    queryAvailableDocuments,
    required TResult Function(BulkUpdateCategories value) bulkUpdateCategories,
    required TResult Function(InitializeEmptyCategory value)
    initializeEmptyCategory,
    required TResult Function(AddFilesToCategory value) addFilesToCategory,
    required TResult Function(RemoveFilesFromCategory value)
    removeFilesFromCategory,
    required TResult Function(RefreshDocumentCounts value)
    refreshDocumentCounts,
    required TResult Function(SetCategoryPermissions value)
    setCategoryPermissions,
  }) {
    return categoriesUpdated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(AddCategory value)? addCategory,
    TResult? Function(UpdateCategory value)? updateCategory,
    TResult? Function(DeleteCategory value)? deleteCategory,
    TResult? Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult? Function(SearchCategories value)? searchCategories,
    TResult? Function(FilterCategories value)? filterCategories,
    TResult? Function(SortCategories value)? sortCategories,
    TResult? Function(RefreshCategories value)? refreshCategories,
    TResult? Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult? Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(CategoriesUpdated value)? categoriesUpdated,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SyncCategories value)? syncCategories,
    TResult? Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult? Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult? Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult? Function(AddFilesToCategory value)? addFilesToCategory,
    TResult? Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult? Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult? Function(SetCategoryPermissions value)? setCategoryPermissions,
  }) {
    return categoriesUpdated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(AddCategory value)? addCategory,
    TResult Function(UpdateCategory value)? updateCategory,
    TResult Function(DeleteCategory value)? deleteCategory,
    TResult Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult Function(SearchCategories value)? searchCategories,
    TResult Function(FilterCategories value)? filterCategories,
    TResult Function(SortCategories value)? sortCategories,
    TResult Function(RefreshCategories value)? refreshCategories,
    TResult Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(CategoriesUpdated value)? categoriesUpdated,
    TResult Function(ResetState value)? resetState,
    TResult Function(SyncCategories value)? syncCategories,
    TResult Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult Function(AddFilesToCategory value)? addFilesToCategory,
    TResult Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult Function(SetCategoryPermissions value)? setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (categoriesUpdated != null) {
      return categoriesUpdated(this);
    }
    return orElse();
  }
}

abstract class CategoriesUpdated implements CategoryEvent {
  const factory CategoriesUpdated({
    required final List<CategoryModel> categories,
  }) = _$CategoriesUpdatedImpl;

  List<CategoryModel> get categories;

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoriesUpdatedImplCopyWith<_$CategoriesUpdatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ResetStateImplCopyWith<$Res> {
  factory _$$ResetStateImplCopyWith(
    _$ResetStateImpl value,
    $Res Function(_$ResetStateImpl) then,
  ) = __$$ResetStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ResetStateImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$ResetStateImpl>
    implements _$$ResetStateImplCopyWith<$Res> {
  __$$ResetStateImplCopyWithImpl(
    _$ResetStateImpl _value,
    $Res Function(_$ResetStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ResetStateImpl implements ResetState {
  const _$ResetStateImpl();

  @override
  String toString() {
    return 'CategoryEvent.resetState()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ResetStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool forceRefresh) loadCategories,
    required TResult Function(CategoryModel category) addCategory,
    required TResult Function(CategoryModel category) updateCategory,
    required TResult Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )
    deleteCategory,
    required TResult Function(String categoryId) toggleCategoryStatus,
    required TResult Function(String query) searchCategories,
    required TResult Function(bool? isActive, String? userId) filterCategories,
    required TResult Function(String sortBy, bool ascending) sortCategories,
    required TResult Function(bool forceRefresh) refreshCategories,
    required TResult Function(String userId) loadCategoriesForUser,
    required TResult Function() loadCategoryStatistics,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<CategoryModel> categories) categoriesUpdated,
    required TResult Function() resetState,
    required TResult Function() syncCategories,
    required TResult Function(String categoryId) queryAvailableDocuments,
    required TResult Function(List<CategoryModel> categories)
    bulkUpdateCategories,
    required TResult Function(String categoryId) initializeEmptyCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    addFilesToCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    removeFilesFromCategory,
    required TResult Function() refreshDocumentCounts,
    required TResult Function(String categoryId, List<String> permissions)
    setCategoryPermissions,
  }) {
    return resetState();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh)? loadCategories,
    TResult? Function(CategoryModel category)? addCategory,
    TResult? Function(CategoryModel category)? updateCategory,
    TResult? Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )?
    deleteCategory,
    TResult? Function(String categoryId)? toggleCategoryStatus,
    TResult? Function(String query)? searchCategories,
    TResult? Function(bool? isActive, String? userId)? filterCategories,
    TResult? Function(String sortBy, bool ascending)? sortCategories,
    TResult? Function(bool forceRefresh)? refreshCategories,
    TResult? Function(String userId)? loadCategoriesForUser,
    TResult? Function()? loadCategoryStatistics,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult? Function()? resetState,
    TResult? Function()? syncCategories,
    TResult? Function(String categoryId)? queryAvailableDocuments,
    TResult? Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult? Function(String categoryId)? initializeEmptyCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult? Function()? refreshDocumentCounts,
    TResult? Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
  }) {
    return resetState?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh)? loadCategories,
    TResult Function(CategoryModel category)? addCategory,
    TResult Function(CategoryModel category)? updateCategory,
    TResult Function(String categoryId, String userId, String? moveDocumentsTo)?
    deleteCategory,
    TResult Function(String categoryId)? toggleCategoryStatus,
    TResult Function(String query)? searchCategories,
    TResult Function(bool? isActive, String? userId)? filterCategories,
    TResult Function(String sortBy, bool ascending)? sortCategories,
    TResult Function(bool forceRefresh)? refreshCategories,
    TResult Function(String userId)? loadCategoriesForUser,
    TResult Function()? loadCategoryStatistics,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult Function()? resetState,
    TResult Function()? syncCategories,
    TResult Function(String categoryId)? queryAvailableDocuments,
    TResult Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult Function(String categoryId)? initializeEmptyCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult Function()? refreshDocumentCounts,
    TResult Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (resetState != null) {
      return resetState();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(AddCategory value) addCategory,
    required TResult Function(UpdateCategory value) updateCategory,
    required TResult Function(DeleteCategory value) deleteCategory,
    required TResult Function(ToggleCategoryStatus value) toggleCategoryStatus,
    required TResult Function(SearchCategories value) searchCategories,
    required TResult Function(FilterCategories value) filterCategories,
    required TResult Function(SortCategories value) sortCategories,
    required TResult Function(RefreshCategories value) refreshCategories,
    required TResult Function(LoadCategoriesForUser value)
    loadCategoriesForUser,
    required TResult Function(LoadCategoryStatistics value)
    loadCategoryStatistics,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(CategoriesUpdated value) categoriesUpdated,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SyncCategories value) syncCategories,
    required TResult Function(QueryAvailableDocuments value)
    queryAvailableDocuments,
    required TResult Function(BulkUpdateCategories value) bulkUpdateCategories,
    required TResult Function(InitializeEmptyCategory value)
    initializeEmptyCategory,
    required TResult Function(AddFilesToCategory value) addFilesToCategory,
    required TResult Function(RemoveFilesFromCategory value)
    removeFilesFromCategory,
    required TResult Function(RefreshDocumentCounts value)
    refreshDocumentCounts,
    required TResult Function(SetCategoryPermissions value)
    setCategoryPermissions,
  }) {
    return resetState(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(AddCategory value)? addCategory,
    TResult? Function(UpdateCategory value)? updateCategory,
    TResult? Function(DeleteCategory value)? deleteCategory,
    TResult? Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult? Function(SearchCategories value)? searchCategories,
    TResult? Function(FilterCategories value)? filterCategories,
    TResult? Function(SortCategories value)? sortCategories,
    TResult? Function(RefreshCategories value)? refreshCategories,
    TResult? Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult? Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(CategoriesUpdated value)? categoriesUpdated,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SyncCategories value)? syncCategories,
    TResult? Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult? Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult? Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult? Function(AddFilesToCategory value)? addFilesToCategory,
    TResult? Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult? Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult? Function(SetCategoryPermissions value)? setCategoryPermissions,
  }) {
    return resetState?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(AddCategory value)? addCategory,
    TResult Function(UpdateCategory value)? updateCategory,
    TResult Function(DeleteCategory value)? deleteCategory,
    TResult Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult Function(SearchCategories value)? searchCategories,
    TResult Function(FilterCategories value)? filterCategories,
    TResult Function(SortCategories value)? sortCategories,
    TResult Function(RefreshCategories value)? refreshCategories,
    TResult Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(CategoriesUpdated value)? categoriesUpdated,
    TResult Function(ResetState value)? resetState,
    TResult Function(SyncCategories value)? syncCategories,
    TResult Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult Function(AddFilesToCategory value)? addFilesToCategory,
    TResult Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult Function(SetCategoryPermissions value)? setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (resetState != null) {
      return resetState(this);
    }
    return orElse();
  }
}

abstract class ResetState implements CategoryEvent {
  const factory ResetState() = _$ResetStateImpl;
}

/// @nodoc
abstract class _$$SyncCategoriesImplCopyWith<$Res> {
  factory _$$SyncCategoriesImplCopyWith(
    _$SyncCategoriesImpl value,
    $Res Function(_$SyncCategoriesImpl) then,
  ) = __$$SyncCategoriesImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SyncCategoriesImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$SyncCategoriesImpl>
    implements _$$SyncCategoriesImplCopyWith<$Res> {
  __$$SyncCategoriesImplCopyWithImpl(
    _$SyncCategoriesImpl _value,
    $Res Function(_$SyncCategoriesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SyncCategoriesImpl implements SyncCategories {
  const _$SyncCategoriesImpl();

  @override
  String toString() {
    return 'CategoryEvent.syncCategories()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SyncCategoriesImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool forceRefresh) loadCategories,
    required TResult Function(CategoryModel category) addCategory,
    required TResult Function(CategoryModel category) updateCategory,
    required TResult Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )
    deleteCategory,
    required TResult Function(String categoryId) toggleCategoryStatus,
    required TResult Function(String query) searchCategories,
    required TResult Function(bool? isActive, String? userId) filterCategories,
    required TResult Function(String sortBy, bool ascending) sortCategories,
    required TResult Function(bool forceRefresh) refreshCategories,
    required TResult Function(String userId) loadCategoriesForUser,
    required TResult Function() loadCategoryStatistics,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<CategoryModel> categories) categoriesUpdated,
    required TResult Function() resetState,
    required TResult Function() syncCategories,
    required TResult Function(String categoryId) queryAvailableDocuments,
    required TResult Function(List<CategoryModel> categories)
    bulkUpdateCategories,
    required TResult Function(String categoryId) initializeEmptyCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    addFilesToCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    removeFilesFromCategory,
    required TResult Function() refreshDocumentCounts,
    required TResult Function(String categoryId, List<String> permissions)
    setCategoryPermissions,
  }) {
    return syncCategories();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh)? loadCategories,
    TResult? Function(CategoryModel category)? addCategory,
    TResult? Function(CategoryModel category)? updateCategory,
    TResult? Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )?
    deleteCategory,
    TResult? Function(String categoryId)? toggleCategoryStatus,
    TResult? Function(String query)? searchCategories,
    TResult? Function(bool? isActive, String? userId)? filterCategories,
    TResult? Function(String sortBy, bool ascending)? sortCategories,
    TResult? Function(bool forceRefresh)? refreshCategories,
    TResult? Function(String userId)? loadCategoriesForUser,
    TResult? Function()? loadCategoryStatistics,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult? Function()? resetState,
    TResult? Function()? syncCategories,
    TResult? Function(String categoryId)? queryAvailableDocuments,
    TResult? Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult? Function(String categoryId)? initializeEmptyCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult? Function()? refreshDocumentCounts,
    TResult? Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
  }) {
    return syncCategories?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh)? loadCategories,
    TResult Function(CategoryModel category)? addCategory,
    TResult Function(CategoryModel category)? updateCategory,
    TResult Function(String categoryId, String userId, String? moveDocumentsTo)?
    deleteCategory,
    TResult Function(String categoryId)? toggleCategoryStatus,
    TResult Function(String query)? searchCategories,
    TResult Function(bool? isActive, String? userId)? filterCategories,
    TResult Function(String sortBy, bool ascending)? sortCategories,
    TResult Function(bool forceRefresh)? refreshCategories,
    TResult Function(String userId)? loadCategoriesForUser,
    TResult Function()? loadCategoryStatistics,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult Function()? resetState,
    TResult Function()? syncCategories,
    TResult Function(String categoryId)? queryAvailableDocuments,
    TResult Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult Function(String categoryId)? initializeEmptyCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult Function()? refreshDocumentCounts,
    TResult Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (syncCategories != null) {
      return syncCategories();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(AddCategory value) addCategory,
    required TResult Function(UpdateCategory value) updateCategory,
    required TResult Function(DeleteCategory value) deleteCategory,
    required TResult Function(ToggleCategoryStatus value) toggleCategoryStatus,
    required TResult Function(SearchCategories value) searchCategories,
    required TResult Function(FilterCategories value) filterCategories,
    required TResult Function(SortCategories value) sortCategories,
    required TResult Function(RefreshCategories value) refreshCategories,
    required TResult Function(LoadCategoriesForUser value)
    loadCategoriesForUser,
    required TResult Function(LoadCategoryStatistics value)
    loadCategoryStatistics,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(CategoriesUpdated value) categoriesUpdated,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SyncCategories value) syncCategories,
    required TResult Function(QueryAvailableDocuments value)
    queryAvailableDocuments,
    required TResult Function(BulkUpdateCategories value) bulkUpdateCategories,
    required TResult Function(InitializeEmptyCategory value)
    initializeEmptyCategory,
    required TResult Function(AddFilesToCategory value) addFilesToCategory,
    required TResult Function(RemoveFilesFromCategory value)
    removeFilesFromCategory,
    required TResult Function(RefreshDocumentCounts value)
    refreshDocumentCounts,
    required TResult Function(SetCategoryPermissions value)
    setCategoryPermissions,
  }) {
    return syncCategories(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(AddCategory value)? addCategory,
    TResult? Function(UpdateCategory value)? updateCategory,
    TResult? Function(DeleteCategory value)? deleteCategory,
    TResult? Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult? Function(SearchCategories value)? searchCategories,
    TResult? Function(FilterCategories value)? filterCategories,
    TResult? Function(SortCategories value)? sortCategories,
    TResult? Function(RefreshCategories value)? refreshCategories,
    TResult? Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult? Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(CategoriesUpdated value)? categoriesUpdated,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SyncCategories value)? syncCategories,
    TResult? Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult? Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult? Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult? Function(AddFilesToCategory value)? addFilesToCategory,
    TResult? Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult? Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult? Function(SetCategoryPermissions value)? setCategoryPermissions,
  }) {
    return syncCategories?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(AddCategory value)? addCategory,
    TResult Function(UpdateCategory value)? updateCategory,
    TResult Function(DeleteCategory value)? deleteCategory,
    TResult Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult Function(SearchCategories value)? searchCategories,
    TResult Function(FilterCategories value)? filterCategories,
    TResult Function(SortCategories value)? sortCategories,
    TResult Function(RefreshCategories value)? refreshCategories,
    TResult Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(CategoriesUpdated value)? categoriesUpdated,
    TResult Function(ResetState value)? resetState,
    TResult Function(SyncCategories value)? syncCategories,
    TResult Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult Function(AddFilesToCategory value)? addFilesToCategory,
    TResult Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult Function(SetCategoryPermissions value)? setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (syncCategories != null) {
      return syncCategories(this);
    }
    return orElse();
  }
}

abstract class SyncCategories implements CategoryEvent {
  const factory SyncCategories() = _$SyncCategoriesImpl;
}

/// @nodoc
abstract class _$$QueryAvailableDocumentsImplCopyWith<$Res> {
  factory _$$QueryAvailableDocumentsImplCopyWith(
    _$QueryAvailableDocumentsImpl value,
    $Res Function(_$QueryAvailableDocumentsImpl) then,
  ) = __$$QueryAvailableDocumentsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String categoryId});
}

/// @nodoc
class __$$QueryAvailableDocumentsImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$QueryAvailableDocumentsImpl>
    implements _$$QueryAvailableDocumentsImplCopyWith<$Res> {
  __$$QueryAvailableDocumentsImplCopyWithImpl(
    _$QueryAvailableDocumentsImpl _value,
    $Res Function(_$QueryAvailableDocumentsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? categoryId = null}) {
    return _then(
      _$QueryAvailableDocumentsImpl(
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$QueryAvailableDocumentsImpl implements QueryAvailableDocuments {
  const _$QueryAvailableDocumentsImpl({required this.categoryId});

  @override
  final String categoryId;

  @override
  String toString() {
    return 'CategoryEvent.queryAvailableDocuments(categoryId: $categoryId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QueryAvailableDocumentsImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, categoryId);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QueryAvailableDocumentsImplCopyWith<_$QueryAvailableDocumentsImpl>
  get copyWith =>
      __$$QueryAvailableDocumentsImplCopyWithImpl<
        _$QueryAvailableDocumentsImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool forceRefresh) loadCategories,
    required TResult Function(CategoryModel category) addCategory,
    required TResult Function(CategoryModel category) updateCategory,
    required TResult Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )
    deleteCategory,
    required TResult Function(String categoryId) toggleCategoryStatus,
    required TResult Function(String query) searchCategories,
    required TResult Function(bool? isActive, String? userId) filterCategories,
    required TResult Function(String sortBy, bool ascending) sortCategories,
    required TResult Function(bool forceRefresh) refreshCategories,
    required TResult Function(String userId) loadCategoriesForUser,
    required TResult Function() loadCategoryStatistics,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<CategoryModel> categories) categoriesUpdated,
    required TResult Function() resetState,
    required TResult Function() syncCategories,
    required TResult Function(String categoryId) queryAvailableDocuments,
    required TResult Function(List<CategoryModel> categories)
    bulkUpdateCategories,
    required TResult Function(String categoryId) initializeEmptyCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    addFilesToCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    removeFilesFromCategory,
    required TResult Function() refreshDocumentCounts,
    required TResult Function(String categoryId, List<String> permissions)
    setCategoryPermissions,
  }) {
    return queryAvailableDocuments(categoryId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh)? loadCategories,
    TResult? Function(CategoryModel category)? addCategory,
    TResult? Function(CategoryModel category)? updateCategory,
    TResult? Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )?
    deleteCategory,
    TResult? Function(String categoryId)? toggleCategoryStatus,
    TResult? Function(String query)? searchCategories,
    TResult? Function(bool? isActive, String? userId)? filterCategories,
    TResult? Function(String sortBy, bool ascending)? sortCategories,
    TResult? Function(bool forceRefresh)? refreshCategories,
    TResult? Function(String userId)? loadCategoriesForUser,
    TResult? Function()? loadCategoryStatistics,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult? Function()? resetState,
    TResult? Function()? syncCategories,
    TResult? Function(String categoryId)? queryAvailableDocuments,
    TResult? Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult? Function(String categoryId)? initializeEmptyCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult? Function()? refreshDocumentCounts,
    TResult? Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
  }) {
    return queryAvailableDocuments?.call(categoryId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh)? loadCategories,
    TResult Function(CategoryModel category)? addCategory,
    TResult Function(CategoryModel category)? updateCategory,
    TResult Function(String categoryId, String userId, String? moveDocumentsTo)?
    deleteCategory,
    TResult Function(String categoryId)? toggleCategoryStatus,
    TResult Function(String query)? searchCategories,
    TResult Function(bool? isActive, String? userId)? filterCategories,
    TResult Function(String sortBy, bool ascending)? sortCategories,
    TResult Function(bool forceRefresh)? refreshCategories,
    TResult Function(String userId)? loadCategoriesForUser,
    TResult Function()? loadCategoryStatistics,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult Function()? resetState,
    TResult Function()? syncCategories,
    TResult Function(String categoryId)? queryAvailableDocuments,
    TResult Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult Function(String categoryId)? initializeEmptyCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult Function()? refreshDocumentCounts,
    TResult Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (queryAvailableDocuments != null) {
      return queryAvailableDocuments(categoryId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(AddCategory value) addCategory,
    required TResult Function(UpdateCategory value) updateCategory,
    required TResult Function(DeleteCategory value) deleteCategory,
    required TResult Function(ToggleCategoryStatus value) toggleCategoryStatus,
    required TResult Function(SearchCategories value) searchCategories,
    required TResult Function(FilterCategories value) filterCategories,
    required TResult Function(SortCategories value) sortCategories,
    required TResult Function(RefreshCategories value) refreshCategories,
    required TResult Function(LoadCategoriesForUser value)
    loadCategoriesForUser,
    required TResult Function(LoadCategoryStatistics value)
    loadCategoryStatistics,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(CategoriesUpdated value) categoriesUpdated,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SyncCategories value) syncCategories,
    required TResult Function(QueryAvailableDocuments value)
    queryAvailableDocuments,
    required TResult Function(BulkUpdateCategories value) bulkUpdateCategories,
    required TResult Function(InitializeEmptyCategory value)
    initializeEmptyCategory,
    required TResult Function(AddFilesToCategory value) addFilesToCategory,
    required TResult Function(RemoveFilesFromCategory value)
    removeFilesFromCategory,
    required TResult Function(RefreshDocumentCounts value)
    refreshDocumentCounts,
    required TResult Function(SetCategoryPermissions value)
    setCategoryPermissions,
  }) {
    return queryAvailableDocuments(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(AddCategory value)? addCategory,
    TResult? Function(UpdateCategory value)? updateCategory,
    TResult? Function(DeleteCategory value)? deleteCategory,
    TResult? Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult? Function(SearchCategories value)? searchCategories,
    TResult? Function(FilterCategories value)? filterCategories,
    TResult? Function(SortCategories value)? sortCategories,
    TResult? Function(RefreshCategories value)? refreshCategories,
    TResult? Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult? Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(CategoriesUpdated value)? categoriesUpdated,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SyncCategories value)? syncCategories,
    TResult? Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult? Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult? Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult? Function(AddFilesToCategory value)? addFilesToCategory,
    TResult? Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult? Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult? Function(SetCategoryPermissions value)? setCategoryPermissions,
  }) {
    return queryAvailableDocuments?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(AddCategory value)? addCategory,
    TResult Function(UpdateCategory value)? updateCategory,
    TResult Function(DeleteCategory value)? deleteCategory,
    TResult Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult Function(SearchCategories value)? searchCategories,
    TResult Function(FilterCategories value)? filterCategories,
    TResult Function(SortCategories value)? sortCategories,
    TResult Function(RefreshCategories value)? refreshCategories,
    TResult Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(CategoriesUpdated value)? categoriesUpdated,
    TResult Function(ResetState value)? resetState,
    TResult Function(SyncCategories value)? syncCategories,
    TResult Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult Function(AddFilesToCategory value)? addFilesToCategory,
    TResult Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult Function(SetCategoryPermissions value)? setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (queryAvailableDocuments != null) {
      return queryAvailableDocuments(this);
    }
    return orElse();
  }
}

abstract class QueryAvailableDocuments implements CategoryEvent {
  const factory QueryAvailableDocuments({required final String categoryId}) =
      _$QueryAvailableDocumentsImpl;

  String get categoryId;

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QueryAvailableDocumentsImplCopyWith<_$QueryAvailableDocumentsImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BulkUpdateCategoriesImplCopyWith<$Res> {
  factory _$$BulkUpdateCategoriesImplCopyWith(
    _$BulkUpdateCategoriesImpl value,
    $Res Function(_$BulkUpdateCategoriesImpl) then,
  ) = __$$BulkUpdateCategoriesImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<CategoryModel> categories});
}

/// @nodoc
class __$$BulkUpdateCategoriesImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$BulkUpdateCategoriesImpl>
    implements _$$BulkUpdateCategoriesImplCopyWith<$Res> {
  __$$BulkUpdateCategoriesImplCopyWithImpl(
    _$BulkUpdateCategoriesImpl _value,
    $Res Function(_$BulkUpdateCategoriesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? categories = null}) {
    return _then(
      _$BulkUpdateCategoriesImpl(
        categories: null == categories
            ? _value._categories
            : categories // ignore: cast_nullable_to_non_nullable
                  as List<CategoryModel>,
      ),
    );
  }
}

/// @nodoc

class _$BulkUpdateCategoriesImpl implements BulkUpdateCategories {
  const _$BulkUpdateCategoriesImpl({
    required final List<CategoryModel> categories,
  }) : _categories = categories;

  final List<CategoryModel> _categories;
  @override
  List<CategoryModel> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  String toString() {
    return 'CategoryEvent.bulkUpdateCategories(categories: $categories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BulkUpdateCategoriesImpl &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_categories),
  );

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BulkUpdateCategoriesImplCopyWith<_$BulkUpdateCategoriesImpl>
  get copyWith =>
      __$$BulkUpdateCategoriesImplCopyWithImpl<_$BulkUpdateCategoriesImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool forceRefresh) loadCategories,
    required TResult Function(CategoryModel category) addCategory,
    required TResult Function(CategoryModel category) updateCategory,
    required TResult Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )
    deleteCategory,
    required TResult Function(String categoryId) toggleCategoryStatus,
    required TResult Function(String query) searchCategories,
    required TResult Function(bool? isActive, String? userId) filterCategories,
    required TResult Function(String sortBy, bool ascending) sortCategories,
    required TResult Function(bool forceRefresh) refreshCategories,
    required TResult Function(String userId) loadCategoriesForUser,
    required TResult Function() loadCategoryStatistics,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<CategoryModel> categories) categoriesUpdated,
    required TResult Function() resetState,
    required TResult Function() syncCategories,
    required TResult Function(String categoryId) queryAvailableDocuments,
    required TResult Function(List<CategoryModel> categories)
    bulkUpdateCategories,
    required TResult Function(String categoryId) initializeEmptyCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    addFilesToCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    removeFilesFromCategory,
    required TResult Function() refreshDocumentCounts,
    required TResult Function(String categoryId, List<String> permissions)
    setCategoryPermissions,
  }) {
    return bulkUpdateCategories(categories);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh)? loadCategories,
    TResult? Function(CategoryModel category)? addCategory,
    TResult? Function(CategoryModel category)? updateCategory,
    TResult? Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )?
    deleteCategory,
    TResult? Function(String categoryId)? toggleCategoryStatus,
    TResult? Function(String query)? searchCategories,
    TResult? Function(bool? isActive, String? userId)? filterCategories,
    TResult? Function(String sortBy, bool ascending)? sortCategories,
    TResult? Function(bool forceRefresh)? refreshCategories,
    TResult? Function(String userId)? loadCategoriesForUser,
    TResult? Function()? loadCategoryStatistics,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult? Function()? resetState,
    TResult? Function()? syncCategories,
    TResult? Function(String categoryId)? queryAvailableDocuments,
    TResult? Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult? Function(String categoryId)? initializeEmptyCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult? Function()? refreshDocumentCounts,
    TResult? Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
  }) {
    return bulkUpdateCategories?.call(categories);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh)? loadCategories,
    TResult Function(CategoryModel category)? addCategory,
    TResult Function(CategoryModel category)? updateCategory,
    TResult Function(String categoryId, String userId, String? moveDocumentsTo)?
    deleteCategory,
    TResult Function(String categoryId)? toggleCategoryStatus,
    TResult Function(String query)? searchCategories,
    TResult Function(bool? isActive, String? userId)? filterCategories,
    TResult Function(String sortBy, bool ascending)? sortCategories,
    TResult Function(bool forceRefresh)? refreshCategories,
    TResult Function(String userId)? loadCategoriesForUser,
    TResult Function()? loadCategoryStatistics,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult Function()? resetState,
    TResult Function()? syncCategories,
    TResult Function(String categoryId)? queryAvailableDocuments,
    TResult Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult Function(String categoryId)? initializeEmptyCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult Function()? refreshDocumentCounts,
    TResult Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (bulkUpdateCategories != null) {
      return bulkUpdateCategories(categories);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(AddCategory value) addCategory,
    required TResult Function(UpdateCategory value) updateCategory,
    required TResult Function(DeleteCategory value) deleteCategory,
    required TResult Function(ToggleCategoryStatus value) toggleCategoryStatus,
    required TResult Function(SearchCategories value) searchCategories,
    required TResult Function(FilterCategories value) filterCategories,
    required TResult Function(SortCategories value) sortCategories,
    required TResult Function(RefreshCategories value) refreshCategories,
    required TResult Function(LoadCategoriesForUser value)
    loadCategoriesForUser,
    required TResult Function(LoadCategoryStatistics value)
    loadCategoryStatistics,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(CategoriesUpdated value) categoriesUpdated,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SyncCategories value) syncCategories,
    required TResult Function(QueryAvailableDocuments value)
    queryAvailableDocuments,
    required TResult Function(BulkUpdateCategories value) bulkUpdateCategories,
    required TResult Function(InitializeEmptyCategory value)
    initializeEmptyCategory,
    required TResult Function(AddFilesToCategory value) addFilesToCategory,
    required TResult Function(RemoveFilesFromCategory value)
    removeFilesFromCategory,
    required TResult Function(RefreshDocumentCounts value)
    refreshDocumentCounts,
    required TResult Function(SetCategoryPermissions value)
    setCategoryPermissions,
  }) {
    return bulkUpdateCategories(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(AddCategory value)? addCategory,
    TResult? Function(UpdateCategory value)? updateCategory,
    TResult? Function(DeleteCategory value)? deleteCategory,
    TResult? Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult? Function(SearchCategories value)? searchCategories,
    TResult? Function(FilterCategories value)? filterCategories,
    TResult? Function(SortCategories value)? sortCategories,
    TResult? Function(RefreshCategories value)? refreshCategories,
    TResult? Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult? Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(CategoriesUpdated value)? categoriesUpdated,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SyncCategories value)? syncCategories,
    TResult? Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult? Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult? Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult? Function(AddFilesToCategory value)? addFilesToCategory,
    TResult? Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult? Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult? Function(SetCategoryPermissions value)? setCategoryPermissions,
  }) {
    return bulkUpdateCategories?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(AddCategory value)? addCategory,
    TResult Function(UpdateCategory value)? updateCategory,
    TResult Function(DeleteCategory value)? deleteCategory,
    TResult Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult Function(SearchCategories value)? searchCategories,
    TResult Function(FilterCategories value)? filterCategories,
    TResult Function(SortCategories value)? sortCategories,
    TResult Function(RefreshCategories value)? refreshCategories,
    TResult Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(CategoriesUpdated value)? categoriesUpdated,
    TResult Function(ResetState value)? resetState,
    TResult Function(SyncCategories value)? syncCategories,
    TResult Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult Function(AddFilesToCategory value)? addFilesToCategory,
    TResult Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult Function(SetCategoryPermissions value)? setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (bulkUpdateCategories != null) {
      return bulkUpdateCategories(this);
    }
    return orElse();
  }
}

abstract class BulkUpdateCategories implements CategoryEvent {
  const factory BulkUpdateCategories({
    required final List<CategoryModel> categories,
  }) = _$BulkUpdateCategoriesImpl;

  List<CategoryModel> get categories;

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BulkUpdateCategoriesImplCopyWith<_$BulkUpdateCategoriesImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InitializeEmptyCategoryImplCopyWith<$Res> {
  factory _$$InitializeEmptyCategoryImplCopyWith(
    _$InitializeEmptyCategoryImpl value,
    $Res Function(_$InitializeEmptyCategoryImpl) then,
  ) = __$$InitializeEmptyCategoryImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String categoryId});
}

/// @nodoc
class __$$InitializeEmptyCategoryImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$InitializeEmptyCategoryImpl>
    implements _$$InitializeEmptyCategoryImplCopyWith<$Res> {
  __$$InitializeEmptyCategoryImplCopyWithImpl(
    _$InitializeEmptyCategoryImpl _value,
    $Res Function(_$InitializeEmptyCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? categoryId = null}) {
    return _then(
      _$InitializeEmptyCategoryImpl(
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$InitializeEmptyCategoryImpl implements InitializeEmptyCategory {
  const _$InitializeEmptyCategoryImpl({required this.categoryId});

  @override
  final String categoryId;

  @override
  String toString() {
    return 'CategoryEvent.initializeEmptyCategory(categoryId: $categoryId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InitializeEmptyCategoryImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, categoryId);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InitializeEmptyCategoryImplCopyWith<_$InitializeEmptyCategoryImpl>
  get copyWith =>
      __$$InitializeEmptyCategoryImplCopyWithImpl<
        _$InitializeEmptyCategoryImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool forceRefresh) loadCategories,
    required TResult Function(CategoryModel category) addCategory,
    required TResult Function(CategoryModel category) updateCategory,
    required TResult Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )
    deleteCategory,
    required TResult Function(String categoryId) toggleCategoryStatus,
    required TResult Function(String query) searchCategories,
    required TResult Function(bool? isActive, String? userId) filterCategories,
    required TResult Function(String sortBy, bool ascending) sortCategories,
    required TResult Function(bool forceRefresh) refreshCategories,
    required TResult Function(String userId) loadCategoriesForUser,
    required TResult Function() loadCategoryStatistics,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<CategoryModel> categories) categoriesUpdated,
    required TResult Function() resetState,
    required TResult Function() syncCategories,
    required TResult Function(String categoryId) queryAvailableDocuments,
    required TResult Function(List<CategoryModel> categories)
    bulkUpdateCategories,
    required TResult Function(String categoryId) initializeEmptyCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    addFilesToCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    removeFilesFromCategory,
    required TResult Function() refreshDocumentCounts,
    required TResult Function(String categoryId, List<String> permissions)
    setCategoryPermissions,
  }) {
    return initializeEmptyCategory(categoryId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh)? loadCategories,
    TResult? Function(CategoryModel category)? addCategory,
    TResult? Function(CategoryModel category)? updateCategory,
    TResult? Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )?
    deleteCategory,
    TResult? Function(String categoryId)? toggleCategoryStatus,
    TResult? Function(String query)? searchCategories,
    TResult? Function(bool? isActive, String? userId)? filterCategories,
    TResult? Function(String sortBy, bool ascending)? sortCategories,
    TResult? Function(bool forceRefresh)? refreshCategories,
    TResult? Function(String userId)? loadCategoriesForUser,
    TResult? Function()? loadCategoryStatistics,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult? Function()? resetState,
    TResult? Function()? syncCategories,
    TResult? Function(String categoryId)? queryAvailableDocuments,
    TResult? Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult? Function(String categoryId)? initializeEmptyCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult? Function()? refreshDocumentCounts,
    TResult? Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
  }) {
    return initializeEmptyCategory?.call(categoryId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh)? loadCategories,
    TResult Function(CategoryModel category)? addCategory,
    TResult Function(CategoryModel category)? updateCategory,
    TResult Function(String categoryId, String userId, String? moveDocumentsTo)?
    deleteCategory,
    TResult Function(String categoryId)? toggleCategoryStatus,
    TResult Function(String query)? searchCategories,
    TResult Function(bool? isActive, String? userId)? filterCategories,
    TResult Function(String sortBy, bool ascending)? sortCategories,
    TResult Function(bool forceRefresh)? refreshCategories,
    TResult Function(String userId)? loadCategoriesForUser,
    TResult Function()? loadCategoryStatistics,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult Function()? resetState,
    TResult Function()? syncCategories,
    TResult Function(String categoryId)? queryAvailableDocuments,
    TResult Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult Function(String categoryId)? initializeEmptyCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult Function()? refreshDocumentCounts,
    TResult Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (initializeEmptyCategory != null) {
      return initializeEmptyCategory(categoryId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(AddCategory value) addCategory,
    required TResult Function(UpdateCategory value) updateCategory,
    required TResult Function(DeleteCategory value) deleteCategory,
    required TResult Function(ToggleCategoryStatus value) toggleCategoryStatus,
    required TResult Function(SearchCategories value) searchCategories,
    required TResult Function(FilterCategories value) filterCategories,
    required TResult Function(SortCategories value) sortCategories,
    required TResult Function(RefreshCategories value) refreshCategories,
    required TResult Function(LoadCategoriesForUser value)
    loadCategoriesForUser,
    required TResult Function(LoadCategoryStatistics value)
    loadCategoryStatistics,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(CategoriesUpdated value) categoriesUpdated,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SyncCategories value) syncCategories,
    required TResult Function(QueryAvailableDocuments value)
    queryAvailableDocuments,
    required TResult Function(BulkUpdateCategories value) bulkUpdateCategories,
    required TResult Function(InitializeEmptyCategory value)
    initializeEmptyCategory,
    required TResult Function(AddFilesToCategory value) addFilesToCategory,
    required TResult Function(RemoveFilesFromCategory value)
    removeFilesFromCategory,
    required TResult Function(RefreshDocumentCounts value)
    refreshDocumentCounts,
    required TResult Function(SetCategoryPermissions value)
    setCategoryPermissions,
  }) {
    return initializeEmptyCategory(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(AddCategory value)? addCategory,
    TResult? Function(UpdateCategory value)? updateCategory,
    TResult? Function(DeleteCategory value)? deleteCategory,
    TResult? Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult? Function(SearchCategories value)? searchCategories,
    TResult? Function(FilterCategories value)? filterCategories,
    TResult? Function(SortCategories value)? sortCategories,
    TResult? Function(RefreshCategories value)? refreshCategories,
    TResult? Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult? Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(CategoriesUpdated value)? categoriesUpdated,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SyncCategories value)? syncCategories,
    TResult? Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult? Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult? Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult? Function(AddFilesToCategory value)? addFilesToCategory,
    TResult? Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult? Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult? Function(SetCategoryPermissions value)? setCategoryPermissions,
  }) {
    return initializeEmptyCategory?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(AddCategory value)? addCategory,
    TResult Function(UpdateCategory value)? updateCategory,
    TResult Function(DeleteCategory value)? deleteCategory,
    TResult Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult Function(SearchCategories value)? searchCategories,
    TResult Function(FilterCategories value)? filterCategories,
    TResult Function(SortCategories value)? sortCategories,
    TResult Function(RefreshCategories value)? refreshCategories,
    TResult Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(CategoriesUpdated value)? categoriesUpdated,
    TResult Function(ResetState value)? resetState,
    TResult Function(SyncCategories value)? syncCategories,
    TResult Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult Function(AddFilesToCategory value)? addFilesToCategory,
    TResult Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult Function(SetCategoryPermissions value)? setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (initializeEmptyCategory != null) {
      return initializeEmptyCategory(this);
    }
    return orElse();
  }
}

abstract class InitializeEmptyCategory implements CategoryEvent {
  const factory InitializeEmptyCategory({required final String categoryId}) =
      _$InitializeEmptyCategoryImpl;

  String get categoryId;

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InitializeEmptyCategoryImplCopyWith<_$InitializeEmptyCategoryImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AddFilesToCategoryImplCopyWith<$Res> {
  factory _$$AddFilesToCategoryImplCopyWith(
    _$AddFilesToCategoryImpl value,
    $Res Function(_$AddFilesToCategoryImpl) then,
  ) = __$$AddFilesToCategoryImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String categoryId, List<String> documentIds});
}

/// @nodoc
class __$$AddFilesToCategoryImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$AddFilesToCategoryImpl>
    implements _$$AddFilesToCategoryImplCopyWith<$Res> {
  __$$AddFilesToCategoryImplCopyWithImpl(
    _$AddFilesToCategoryImpl _value,
    $Res Function(_$AddFilesToCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? categoryId = null, Object? documentIds = null}) {
    return _then(
      _$AddFilesToCategoryImpl(
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String,
        documentIds: null == documentIds
            ? _value._documentIds
            : documentIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc

class _$AddFilesToCategoryImpl implements AddFilesToCategory {
  const _$AddFilesToCategoryImpl({
    required this.categoryId,
    required final List<String> documentIds,
  }) : _documentIds = documentIds;

  @override
  final String categoryId;
  final List<String> _documentIds;
  @override
  List<String> get documentIds {
    if (_documentIds is EqualUnmodifiableListView) return _documentIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_documentIds);
  }

  @override
  String toString() {
    return 'CategoryEvent.addFilesToCategory(categoryId: $categoryId, documentIds: $documentIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddFilesToCategoryImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            const DeepCollectionEquality().equals(
              other._documentIds,
              _documentIds,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    categoryId,
    const DeepCollectionEquality().hash(_documentIds),
  );

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddFilesToCategoryImplCopyWith<_$AddFilesToCategoryImpl> get copyWith =>
      __$$AddFilesToCategoryImplCopyWithImpl<_$AddFilesToCategoryImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool forceRefresh) loadCategories,
    required TResult Function(CategoryModel category) addCategory,
    required TResult Function(CategoryModel category) updateCategory,
    required TResult Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )
    deleteCategory,
    required TResult Function(String categoryId) toggleCategoryStatus,
    required TResult Function(String query) searchCategories,
    required TResult Function(bool? isActive, String? userId) filterCategories,
    required TResult Function(String sortBy, bool ascending) sortCategories,
    required TResult Function(bool forceRefresh) refreshCategories,
    required TResult Function(String userId) loadCategoriesForUser,
    required TResult Function() loadCategoryStatistics,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<CategoryModel> categories) categoriesUpdated,
    required TResult Function() resetState,
    required TResult Function() syncCategories,
    required TResult Function(String categoryId) queryAvailableDocuments,
    required TResult Function(List<CategoryModel> categories)
    bulkUpdateCategories,
    required TResult Function(String categoryId) initializeEmptyCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    addFilesToCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    removeFilesFromCategory,
    required TResult Function() refreshDocumentCounts,
    required TResult Function(String categoryId, List<String> permissions)
    setCategoryPermissions,
  }) {
    return addFilesToCategory(categoryId, documentIds);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh)? loadCategories,
    TResult? Function(CategoryModel category)? addCategory,
    TResult? Function(CategoryModel category)? updateCategory,
    TResult? Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )?
    deleteCategory,
    TResult? Function(String categoryId)? toggleCategoryStatus,
    TResult? Function(String query)? searchCategories,
    TResult? Function(bool? isActive, String? userId)? filterCategories,
    TResult? Function(String sortBy, bool ascending)? sortCategories,
    TResult? Function(bool forceRefresh)? refreshCategories,
    TResult? Function(String userId)? loadCategoriesForUser,
    TResult? Function()? loadCategoryStatistics,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult? Function()? resetState,
    TResult? Function()? syncCategories,
    TResult? Function(String categoryId)? queryAvailableDocuments,
    TResult? Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult? Function(String categoryId)? initializeEmptyCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult? Function()? refreshDocumentCounts,
    TResult? Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
  }) {
    return addFilesToCategory?.call(categoryId, documentIds);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh)? loadCategories,
    TResult Function(CategoryModel category)? addCategory,
    TResult Function(CategoryModel category)? updateCategory,
    TResult Function(String categoryId, String userId, String? moveDocumentsTo)?
    deleteCategory,
    TResult Function(String categoryId)? toggleCategoryStatus,
    TResult Function(String query)? searchCategories,
    TResult Function(bool? isActive, String? userId)? filterCategories,
    TResult Function(String sortBy, bool ascending)? sortCategories,
    TResult Function(bool forceRefresh)? refreshCategories,
    TResult Function(String userId)? loadCategoriesForUser,
    TResult Function()? loadCategoryStatistics,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult Function()? resetState,
    TResult Function()? syncCategories,
    TResult Function(String categoryId)? queryAvailableDocuments,
    TResult Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult Function(String categoryId)? initializeEmptyCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult Function()? refreshDocumentCounts,
    TResult Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (addFilesToCategory != null) {
      return addFilesToCategory(categoryId, documentIds);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(AddCategory value) addCategory,
    required TResult Function(UpdateCategory value) updateCategory,
    required TResult Function(DeleteCategory value) deleteCategory,
    required TResult Function(ToggleCategoryStatus value) toggleCategoryStatus,
    required TResult Function(SearchCategories value) searchCategories,
    required TResult Function(FilterCategories value) filterCategories,
    required TResult Function(SortCategories value) sortCategories,
    required TResult Function(RefreshCategories value) refreshCategories,
    required TResult Function(LoadCategoriesForUser value)
    loadCategoriesForUser,
    required TResult Function(LoadCategoryStatistics value)
    loadCategoryStatistics,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(CategoriesUpdated value) categoriesUpdated,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SyncCategories value) syncCategories,
    required TResult Function(QueryAvailableDocuments value)
    queryAvailableDocuments,
    required TResult Function(BulkUpdateCategories value) bulkUpdateCategories,
    required TResult Function(InitializeEmptyCategory value)
    initializeEmptyCategory,
    required TResult Function(AddFilesToCategory value) addFilesToCategory,
    required TResult Function(RemoveFilesFromCategory value)
    removeFilesFromCategory,
    required TResult Function(RefreshDocumentCounts value)
    refreshDocumentCounts,
    required TResult Function(SetCategoryPermissions value)
    setCategoryPermissions,
  }) {
    return addFilesToCategory(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(AddCategory value)? addCategory,
    TResult? Function(UpdateCategory value)? updateCategory,
    TResult? Function(DeleteCategory value)? deleteCategory,
    TResult? Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult? Function(SearchCategories value)? searchCategories,
    TResult? Function(FilterCategories value)? filterCategories,
    TResult? Function(SortCategories value)? sortCategories,
    TResult? Function(RefreshCategories value)? refreshCategories,
    TResult? Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult? Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(CategoriesUpdated value)? categoriesUpdated,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SyncCategories value)? syncCategories,
    TResult? Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult? Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult? Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult? Function(AddFilesToCategory value)? addFilesToCategory,
    TResult? Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult? Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult? Function(SetCategoryPermissions value)? setCategoryPermissions,
  }) {
    return addFilesToCategory?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(AddCategory value)? addCategory,
    TResult Function(UpdateCategory value)? updateCategory,
    TResult Function(DeleteCategory value)? deleteCategory,
    TResult Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult Function(SearchCategories value)? searchCategories,
    TResult Function(FilterCategories value)? filterCategories,
    TResult Function(SortCategories value)? sortCategories,
    TResult Function(RefreshCategories value)? refreshCategories,
    TResult Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(CategoriesUpdated value)? categoriesUpdated,
    TResult Function(ResetState value)? resetState,
    TResult Function(SyncCategories value)? syncCategories,
    TResult Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult Function(AddFilesToCategory value)? addFilesToCategory,
    TResult Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult Function(SetCategoryPermissions value)? setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (addFilesToCategory != null) {
      return addFilesToCategory(this);
    }
    return orElse();
  }
}

abstract class AddFilesToCategory implements CategoryEvent {
  const factory AddFilesToCategory({
    required final String categoryId,
    required final List<String> documentIds,
  }) = _$AddFilesToCategoryImpl;

  String get categoryId;
  List<String> get documentIds;

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddFilesToCategoryImplCopyWith<_$AddFilesToCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RemoveFilesFromCategoryImplCopyWith<$Res> {
  factory _$$RemoveFilesFromCategoryImplCopyWith(
    _$RemoveFilesFromCategoryImpl value,
    $Res Function(_$RemoveFilesFromCategoryImpl) then,
  ) = __$$RemoveFilesFromCategoryImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String categoryId, List<String> documentIds});
}

/// @nodoc
class __$$RemoveFilesFromCategoryImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$RemoveFilesFromCategoryImpl>
    implements _$$RemoveFilesFromCategoryImplCopyWith<$Res> {
  __$$RemoveFilesFromCategoryImplCopyWithImpl(
    _$RemoveFilesFromCategoryImpl _value,
    $Res Function(_$RemoveFilesFromCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? categoryId = null, Object? documentIds = null}) {
    return _then(
      _$RemoveFilesFromCategoryImpl(
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String,
        documentIds: null == documentIds
            ? _value._documentIds
            : documentIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc

class _$RemoveFilesFromCategoryImpl implements RemoveFilesFromCategory {
  const _$RemoveFilesFromCategoryImpl({
    required this.categoryId,
    required final List<String> documentIds,
  }) : _documentIds = documentIds;

  @override
  final String categoryId;
  final List<String> _documentIds;
  @override
  List<String> get documentIds {
    if (_documentIds is EqualUnmodifiableListView) return _documentIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_documentIds);
  }

  @override
  String toString() {
    return 'CategoryEvent.removeFilesFromCategory(categoryId: $categoryId, documentIds: $documentIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RemoveFilesFromCategoryImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            const DeepCollectionEquality().equals(
              other._documentIds,
              _documentIds,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    categoryId,
    const DeepCollectionEquality().hash(_documentIds),
  );

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RemoveFilesFromCategoryImplCopyWith<_$RemoveFilesFromCategoryImpl>
  get copyWith =>
      __$$RemoveFilesFromCategoryImplCopyWithImpl<
        _$RemoveFilesFromCategoryImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool forceRefresh) loadCategories,
    required TResult Function(CategoryModel category) addCategory,
    required TResult Function(CategoryModel category) updateCategory,
    required TResult Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )
    deleteCategory,
    required TResult Function(String categoryId) toggleCategoryStatus,
    required TResult Function(String query) searchCategories,
    required TResult Function(bool? isActive, String? userId) filterCategories,
    required TResult Function(String sortBy, bool ascending) sortCategories,
    required TResult Function(bool forceRefresh) refreshCategories,
    required TResult Function(String userId) loadCategoriesForUser,
    required TResult Function() loadCategoryStatistics,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<CategoryModel> categories) categoriesUpdated,
    required TResult Function() resetState,
    required TResult Function() syncCategories,
    required TResult Function(String categoryId) queryAvailableDocuments,
    required TResult Function(List<CategoryModel> categories)
    bulkUpdateCategories,
    required TResult Function(String categoryId) initializeEmptyCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    addFilesToCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    removeFilesFromCategory,
    required TResult Function() refreshDocumentCounts,
    required TResult Function(String categoryId, List<String> permissions)
    setCategoryPermissions,
  }) {
    return removeFilesFromCategory(categoryId, documentIds);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh)? loadCategories,
    TResult? Function(CategoryModel category)? addCategory,
    TResult? Function(CategoryModel category)? updateCategory,
    TResult? Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )?
    deleteCategory,
    TResult? Function(String categoryId)? toggleCategoryStatus,
    TResult? Function(String query)? searchCategories,
    TResult? Function(bool? isActive, String? userId)? filterCategories,
    TResult? Function(String sortBy, bool ascending)? sortCategories,
    TResult? Function(bool forceRefresh)? refreshCategories,
    TResult? Function(String userId)? loadCategoriesForUser,
    TResult? Function()? loadCategoryStatistics,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult? Function()? resetState,
    TResult? Function()? syncCategories,
    TResult? Function(String categoryId)? queryAvailableDocuments,
    TResult? Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult? Function(String categoryId)? initializeEmptyCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult? Function()? refreshDocumentCounts,
    TResult? Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
  }) {
    return removeFilesFromCategory?.call(categoryId, documentIds);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh)? loadCategories,
    TResult Function(CategoryModel category)? addCategory,
    TResult Function(CategoryModel category)? updateCategory,
    TResult Function(String categoryId, String userId, String? moveDocumentsTo)?
    deleteCategory,
    TResult Function(String categoryId)? toggleCategoryStatus,
    TResult Function(String query)? searchCategories,
    TResult Function(bool? isActive, String? userId)? filterCategories,
    TResult Function(String sortBy, bool ascending)? sortCategories,
    TResult Function(bool forceRefresh)? refreshCategories,
    TResult Function(String userId)? loadCategoriesForUser,
    TResult Function()? loadCategoryStatistics,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult Function()? resetState,
    TResult Function()? syncCategories,
    TResult Function(String categoryId)? queryAvailableDocuments,
    TResult Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult Function(String categoryId)? initializeEmptyCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult Function()? refreshDocumentCounts,
    TResult Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (removeFilesFromCategory != null) {
      return removeFilesFromCategory(categoryId, documentIds);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(AddCategory value) addCategory,
    required TResult Function(UpdateCategory value) updateCategory,
    required TResult Function(DeleteCategory value) deleteCategory,
    required TResult Function(ToggleCategoryStatus value) toggleCategoryStatus,
    required TResult Function(SearchCategories value) searchCategories,
    required TResult Function(FilterCategories value) filterCategories,
    required TResult Function(SortCategories value) sortCategories,
    required TResult Function(RefreshCategories value) refreshCategories,
    required TResult Function(LoadCategoriesForUser value)
    loadCategoriesForUser,
    required TResult Function(LoadCategoryStatistics value)
    loadCategoryStatistics,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(CategoriesUpdated value) categoriesUpdated,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SyncCategories value) syncCategories,
    required TResult Function(QueryAvailableDocuments value)
    queryAvailableDocuments,
    required TResult Function(BulkUpdateCategories value) bulkUpdateCategories,
    required TResult Function(InitializeEmptyCategory value)
    initializeEmptyCategory,
    required TResult Function(AddFilesToCategory value) addFilesToCategory,
    required TResult Function(RemoveFilesFromCategory value)
    removeFilesFromCategory,
    required TResult Function(RefreshDocumentCounts value)
    refreshDocumentCounts,
    required TResult Function(SetCategoryPermissions value)
    setCategoryPermissions,
  }) {
    return removeFilesFromCategory(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(AddCategory value)? addCategory,
    TResult? Function(UpdateCategory value)? updateCategory,
    TResult? Function(DeleteCategory value)? deleteCategory,
    TResult? Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult? Function(SearchCategories value)? searchCategories,
    TResult? Function(FilterCategories value)? filterCategories,
    TResult? Function(SortCategories value)? sortCategories,
    TResult? Function(RefreshCategories value)? refreshCategories,
    TResult? Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult? Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(CategoriesUpdated value)? categoriesUpdated,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SyncCategories value)? syncCategories,
    TResult? Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult? Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult? Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult? Function(AddFilesToCategory value)? addFilesToCategory,
    TResult? Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult? Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult? Function(SetCategoryPermissions value)? setCategoryPermissions,
  }) {
    return removeFilesFromCategory?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(AddCategory value)? addCategory,
    TResult Function(UpdateCategory value)? updateCategory,
    TResult Function(DeleteCategory value)? deleteCategory,
    TResult Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult Function(SearchCategories value)? searchCategories,
    TResult Function(FilterCategories value)? filterCategories,
    TResult Function(SortCategories value)? sortCategories,
    TResult Function(RefreshCategories value)? refreshCategories,
    TResult Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(CategoriesUpdated value)? categoriesUpdated,
    TResult Function(ResetState value)? resetState,
    TResult Function(SyncCategories value)? syncCategories,
    TResult Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult Function(AddFilesToCategory value)? addFilesToCategory,
    TResult Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult Function(SetCategoryPermissions value)? setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (removeFilesFromCategory != null) {
      return removeFilesFromCategory(this);
    }
    return orElse();
  }
}

abstract class RemoveFilesFromCategory implements CategoryEvent {
  const factory RemoveFilesFromCategory({
    required final String categoryId,
    required final List<String> documentIds,
  }) = _$RemoveFilesFromCategoryImpl;

  String get categoryId;
  List<String> get documentIds;

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RemoveFilesFromCategoryImplCopyWith<_$RemoveFilesFromCategoryImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RefreshDocumentCountsImplCopyWith<$Res> {
  factory _$$RefreshDocumentCountsImplCopyWith(
    _$RefreshDocumentCountsImpl value,
    $Res Function(_$RefreshDocumentCountsImpl) then,
  ) = __$$RefreshDocumentCountsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RefreshDocumentCountsImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$RefreshDocumentCountsImpl>
    implements _$$RefreshDocumentCountsImplCopyWith<$Res> {
  __$$RefreshDocumentCountsImplCopyWithImpl(
    _$RefreshDocumentCountsImpl _value,
    $Res Function(_$RefreshDocumentCountsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RefreshDocumentCountsImpl implements RefreshDocumentCounts {
  const _$RefreshDocumentCountsImpl();

  @override
  String toString() {
    return 'CategoryEvent.refreshDocumentCounts()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefreshDocumentCountsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool forceRefresh) loadCategories,
    required TResult Function(CategoryModel category) addCategory,
    required TResult Function(CategoryModel category) updateCategory,
    required TResult Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )
    deleteCategory,
    required TResult Function(String categoryId) toggleCategoryStatus,
    required TResult Function(String query) searchCategories,
    required TResult Function(bool? isActive, String? userId) filterCategories,
    required TResult Function(String sortBy, bool ascending) sortCategories,
    required TResult Function(bool forceRefresh) refreshCategories,
    required TResult Function(String userId) loadCategoriesForUser,
    required TResult Function() loadCategoryStatistics,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<CategoryModel> categories) categoriesUpdated,
    required TResult Function() resetState,
    required TResult Function() syncCategories,
    required TResult Function(String categoryId) queryAvailableDocuments,
    required TResult Function(List<CategoryModel> categories)
    bulkUpdateCategories,
    required TResult Function(String categoryId) initializeEmptyCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    addFilesToCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    removeFilesFromCategory,
    required TResult Function() refreshDocumentCounts,
    required TResult Function(String categoryId, List<String> permissions)
    setCategoryPermissions,
  }) {
    return refreshDocumentCounts();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh)? loadCategories,
    TResult? Function(CategoryModel category)? addCategory,
    TResult? Function(CategoryModel category)? updateCategory,
    TResult? Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )?
    deleteCategory,
    TResult? Function(String categoryId)? toggleCategoryStatus,
    TResult? Function(String query)? searchCategories,
    TResult? Function(bool? isActive, String? userId)? filterCategories,
    TResult? Function(String sortBy, bool ascending)? sortCategories,
    TResult? Function(bool forceRefresh)? refreshCategories,
    TResult? Function(String userId)? loadCategoriesForUser,
    TResult? Function()? loadCategoryStatistics,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult? Function()? resetState,
    TResult? Function()? syncCategories,
    TResult? Function(String categoryId)? queryAvailableDocuments,
    TResult? Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult? Function(String categoryId)? initializeEmptyCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult? Function()? refreshDocumentCounts,
    TResult? Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
  }) {
    return refreshDocumentCounts?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh)? loadCategories,
    TResult Function(CategoryModel category)? addCategory,
    TResult Function(CategoryModel category)? updateCategory,
    TResult Function(String categoryId, String userId, String? moveDocumentsTo)?
    deleteCategory,
    TResult Function(String categoryId)? toggleCategoryStatus,
    TResult Function(String query)? searchCategories,
    TResult Function(bool? isActive, String? userId)? filterCategories,
    TResult Function(String sortBy, bool ascending)? sortCategories,
    TResult Function(bool forceRefresh)? refreshCategories,
    TResult Function(String userId)? loadCategoriesForUser,
    TResult Function()? loadCategoryStatistics,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult Function()? resetState,
    TResult Function()? syncCategories,
    TResult Function(String categoryId)? queryAvailableDocuments,
    TResult Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult Function(String categoryId)? initializeEmptyCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult Function()? refreshDocumentCounts,
    TResult Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (refreshDocumentCounts != null) {
      return refreshDocumentCounts();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(AddCategory value) addCategory,
    required TResult Function(UpdateCategory value) updateCategory,
    required TResult Function(DeleteCategory value) deleteCategory,
    required TResult Function(ToggleCategoryStatus value) toggleCategoryStatus,
    required TResult Function(SearchCategories value) searchCategories,
    required TResult Function(FilterCategories value) filterCategories,
    required TResult Function(SortCategories value) sortCategories,
    required TResult Function(RefreshCategories value) refreshCategories,
    required TResult Function(LoadCategoriesForUser value)
    loadCategoriesForUser,
    required TResult Function(LoadCategoryStatistics value)
    loadCategoryStatistics,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(CategoriesUpdated value) categoriesUpdated,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SyncCategories value) syncCategories,
    required TResult Function(QueryAvailableDocuments value)
    queryAvailableDocuments,
    required TResult Function(BulkUpdateCategories value) bulkUpdateCategories,
    required TResult Function(InitializeEmptyCategory value)
    initializeEmptyCategory,
    required TResult Function(AddFilesToCategory value) addFilesToCategory,
    required TResult Function(RemoveFilesFromCategory value)
    removeFilesFromCategory,
    required TResult Function(RefreshDocumentCounts value)
    refreshDocumentCounts,
    required TResult Function(SetCategoryPermissions value)
    setCategoryPermissions,
  }) {
    return refreshDocumentCounts(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(AddCategory value)? addCategory,
    TResult? Function(UpdateCategory value)? updateCategory,
    TResult? Function(DeleteCategory value)? deleteCategory,
    TResult? Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult? Function(SearchCategories value)? searchCategories,
    TResult? Function(FilterCategories value)? filterCategories,
    TResult? Function(SortCategories value)? sortCategories,
    TResult? Function(RefreshCategories value)? refreshCategories,
    TResult? Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult? Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(CategoriesUpdated value)? categoriesUpdated,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SyncCategories value)? syncCategories,
    TResult? Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult? Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult? Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult? Function(AddFilesToCategory value)? addFilesToCategory,
    TResult? Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult? Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult? Function(SetCategoryPermissions value)? setCategoryPermissions,
  }) {
    return refreshDocumentCounts?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(AddCategory value)? addCategory,
    TResult Function(UpdateCategory value)? updateCategory,
    TResult Function(DeleteCategory value)? deleteCategory,
    TResult Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult Function(SearchCategories value)? searchCategories,
    TResult Function(FilterCategories value)? filterCategories,
    TResult Function(SortCategories value)? sortCategories,
    TResult Function(RefreshCategories value)? refreshCategories,
    TResult Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(CategoriesUpdated value)? categoriesUpdated,
    TResult Function(ResetState value)? resetState,
    TResult Function(SyncCategories value)? syncCategories,
    TResult Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult Function(AddFilesToCategory value)? addFilesToCategory,
    TResult Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult Function(SetCategoryPermissions value)? setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (refreshDocumentCounts != null) {
      return refreshDocumentCounts(this);
    }
    return orElse();
  }
}

abstract class RefreshDocumentCounts implements CategoryEvent {
  const factory RefreshDocumentCounts() = _$RefreshDocumentCountsImpl;
}

/// @nodoc
abstract class _$$SetCategoryPermissionsImplCopyWith<$Res> {
  factory _$$SetCategoryPermissionsImplCopyWith(
    _$SetCategoryPermissionsImpl value,
    $Res Function(_$SetCategoryPermissionsImpl) then,
  ) = __$$SetCategoryPermissionsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String categoryId, List<String> permissions});
}

/// @nodoc
class __$$SetCategoryPermissionsImplCopyWithImpl<$Res>
    extends _$CategoryEventCopyWithImpl<$Res, _$SetCategoryPermissionsImpl>
    implements _$$SetCategoryPermissionsImplCopyWith<$Res> {
  __$$SetCategoryPermissionsImplCopyWithImpl(
    _$SetCategoryPermissionsImpl _value,
    $Res Function(_$SetCategoryPermissionsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? categoryId = null, Object? permissions = null}) {
    return _then(
      _$SetCategoryPermissionsImpl(
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String,
        permissions: null == permissions
            ? _value._permissions
            : permissions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc

class _$SetCategoryPermissionsImpl implements SetCategoryPermissions {
  const _$SetCategoryPermissionsImpl({
    required this.categoryId,
    required final List<String> permissions,
  }) : _permissions = permissions;

  @override
  final String categoryId;
  final List<String> _permissions;
  @override
  List<String> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  @override
  String toString() {
    return 'CategoryEvent.setCategoryPermissions(categoryId: $categoryId, permissions: $permissions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetCategoryPermissionsImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            const DeepCollectionEquality().equals(
              other._permissions,
              _permissions,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    categoryId,
    const DeepCollectionEquality().hash(_permissions),
  );

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SetCategoryPermissionsImplCopyWith<_$SetCategoryPermissionsImpl>
  get copyWith =>
      __$$SetCategoryPermissionsImplCopyWithImpl<_$SetCategoryPermissionsImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool forceRefresh) loadCategories,
    required TResult Function(CategoryModel category) addCategory,
    required TResult Function(CategoryModel category) updateCategory,
    required TResult Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )
    deleteCategory,
    required TResult Function(String categoryId) toggleCategoryStatus,
    required TResult Function(String query) searchCategories,
    required TResult Function(bool? isActive, String? userId) filterCategories,
    required TResult Function(String sortBy, bool ascending) sortCategories,
    required TResult Function(bool forceRefresh) refreshCategories,
    required TResult Function(String userId) loadCategoriesForUser,
    required TResult Function() loadCategoryStatistics,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<CategoryModel> categories) categoriesUpdated,
    required TResult Function() resetState,
    required TResult Function() syncCategories,
    required TResult Function(String categoryId) queryAvailableDocuments,
    required TResult Function(List<CategoryModel> categories)
    bulkUpdateCategories,
    required TResult Function(String categoryId) initializeEmptyCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    addFilesToCategory,
    required TResult Function(String categoryId, List<String> documentIds)
    removeFilesFromCategory,
    required TResult Function() refreshDocumentCounts,
    required TResult Function(String categoryId, List<String> permissions)
    setCategoryPermissions,
  }) {
    return setCategoryPermissions(categoryId, permissions);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh)? loadCategories,
    TResult? Function(CategoryModel category)? addCategory,
    TResult? Function(CategoryModel category)? updateCategory,
    TResult? Function(
      String categoryId,
      String userId,
      String? moveDocumentsTo,
    )?
    deleteCategory,
    TResult? Function(String categoryId)? toggleCategoryStatus,
    TResult? Function(String query)? searchCategories,
    TResult? Function(bool? isActive, String? userId)? filterCategories,
    TResult? Function(String sortBy, bool ascending)? sortCategories,
    TResult? Function(bool forceRefresh)? refreshCategories,
    TResult? Function(String userId)? loadCategoriesForUser,
    TResult? Function()? loadCategoryStatistics,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult? Function()? resetState,
    TResult? Function()? syncCategories,
    TResult? Function(String categoryId)? queryAvailableDocuments,
    TResult? Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult? Function(String categoryId)? initializeEmptyCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult? Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult? Function()? refreshDocumentCounts,
    TResult? Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
  }) {
    return setCategoryPermissions?.call(categoryId, permissions);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh)? loadCategories,
    TResult Function(CategoryModel category)? addCategory,
    TResult Function(CategoryModel category)? updateCategory,
    TResult Function(String categoryId, String userId, String? moveDocumentsTo)?
    deleteCategory,
    TResult Function(String categoryId)? toggleCategoryStatus,
    TResult Function(String query)? searchCategories,
    TResult Function(bool? isActive, String? userId)? filterCategories,
    TResult Function(String sortBy, bool ascending)? sortCategories,
    TResult Function(bool forceRefresh)? refreshCategories,
    TResult Function(String userId)? loadCategoriesForUser,
    TResult Function()? loadCategoryStatistics,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<CategoryModel> categories)? categoriesUpdated,
    TResult Function()? resetState,
    TResult Function()? syncCategories,
    TResult Function(String categoryId)? queryAvailableDocuments,
    TResult Function(List<CategoryModel> categories)? bulkUpdateCategories,
    TResult Function(String categoryId)? initializeEmptyCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    addFilesToCategory,
    TResult Function(String categoryId, List<String> documentIds)?
    removeFilesFromCategory,
    TResult Function()? refreshDocumentCounts,
    TResult Function(String categoryId, List<String> permissions)?
    setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (setCategoryPermissions != null) {
      return setCategoryPermissions(categoryId, permissions);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadCategories value) loadCategories,
    required TResult Function(AddCategory value) addCategory,
    required TResult Function(UpdateCategory value) updateCategory,
    required TResult Function(DeleteCategory value) deleteCategory,
    required TResult Function(ToggleCategoryStatus value) toggleCategoryStatus,
    required TResult Function(SearchCategories value) searchCategories,
    required TResult Function(FilterCategories value) filterCategories,
    required TResult Function(SortCategories value) sortCategories,
    required TResult Function(RefreshCategories value) refreshCategories,
    required TResult Function(LoadCategoriesForUser value)
    loadCategoriesForUser,
    required TResult Function(LoadCategoryStatistics value)
    loadCategoryStatistics,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(CategoriesUpdated value) categoriesUpdated,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SyncCategories value) syncCategories,
    required TResult Function(QueryAvailableDocuments value)
    queryAvailableDocuments,
    required TResult Function(BulkUpdateCategories value) bulkUpdateCategories,
    required TResult Function(InitializeEmptyCategory value)
    initializeEmptyCategory,
    required TResult Function(AddFilesToCategory value) addFilesToCategory,
    required TResult Function(RemoveFilesFromCategory value)
    removeFilesFromCategory,
    required TResult Function(RefreshDocumentCounts value)
    refreshDocumentCounts,
    required TResult Function(SetCategoryPermissions value)
    setCategoryPermissions,
  }) {
    return setCategoryPermissions(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadCategories value)? loadCategories,
    TResult? Function(AddCategory value)? addCategory,
    TResult? Function(UpdateCategory value)? updateCategory,
    TResult? Function(DeleteCategory value)? deleteCategory,
    TResult? Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult? Function(SearchCategories value)? searchCategories,
    TResult? Function(FilterCategories value)? filterCategories,
    TResult? Function(SortCategories value)? sortCategories,
    TResult? Function(RefreshCategories value)? refreshCategories,
    TResult? Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult? Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(CategoriesUpdated value)? categoriesUpdated,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SyncCategories value)? syncCategories,
    TResult? Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult? Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult? Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult? Function(AddFilesToCategory value)? addFilesToCategory,
    TResult? Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult? Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult? Function(SetCategoryPermissions value)? setCategoryPermissions,
  }) {
    return setCategoryPermissions?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadCategories value)? loadCategories,
    TResult Function(AddCategory value)? addCategory,
    TResult Function(UpdateCategory value)? updateCategory,
    TResult Function(DeleteCategory value)? deleteCategory,
    TResult Function(ToggleCategoryStatus value)? toggleCategoryStatus,
    TResult Function(SearchCategories value)? searchCategories,
    TResult Function(FilterCategories value)? filterCategories,
    TResult Function(SortCategories value)? sortCategories,
    TResult Function(RefreshCategories value)? refreshCategories,
    TResult Function(LoadCategoriesForUser value)? loadCategoriesForUser,
    TResult Function(LoadCategoryStatistics value)? loadCategoryStatistics,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(CategoriesUpdated value)? categoriesUpdated,
    TResult Function(ResetState value)? resetState,
    TResult Function(SyncCategories value)? syncCategories,
    TResult Function(QueryAvailableDocuments value)? queryAvailableDocuments,
    TResult Function(BulkUpdateCategories value)? bulkUpdateCategories,
    TResult Function(InitializeEmptyCategory value)? initializeEmptyCategory,
    TResult Function(AddFilesToCategory value)? addFilesToCategory,
    TResult Function(RemoveFilesFromCategory value)? removeFilesFromCategory,
    TResult Function(RefreshDocumentCounts value)? refreshDocumentCounts,
    TResult Function(SetCategoryPermissions value)? setCategoryPermissions,
    required TResult orElse(),
  }) {
    if (setCategoryPermissions != null) {
      return setCategoryPermissions(this);
    }
    return orElse();
  }
}

abstract class SetCategoryPermissions implements CategoryEvent {
  const factory SetCategoryPermissions({
    required final String categoryId,
    required final List<String> permissions,
  }) = _$SetCategoryPermissionsImpl;

  String get categoryId;
  List<String> get permissions;

  /// Create a copy of CategoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SetCategoryPermissionsImplCopyWith<_$SetCategoryPermissionsImpl>
  get copyWith => throw _privateConstructorUsedError;
}
