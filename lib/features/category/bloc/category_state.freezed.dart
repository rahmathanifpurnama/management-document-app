// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CategoryState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) loading,
    required TResult Function(
      List<CategoryModel> categories,
      List<CategoryModel> filteredCategories,
      String searchQuery,
      bool? isActiveFilter,
      String? userIdFilter,
      String sortBy,
      bool sortAscending,
      bool isListening,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )
    loaded,
    required TResult Function(
      String message,
      bool canRetry,
      CategoryState? previousState,
    )
    error,
    required TResult Function(String message, List<CategoryModel>? categories)
    processing,
    required TResult Function(
      String message,
      List<CategoryModel> categories,
      String operation,
    )
    success,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? loading,
    TResult? Function(
      List<CategoryModel> categories,
      List<CategoryModel> filteredCategories,
      String searchQuery,
      bool? isActiveFilter,
      String? userIdFilter,
      String sortBy,
      bool sortAscending,
      bool isListening,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult? Function(
      String message,
      bool canRetry,
      CategoryState? previousState,
    )?
    error,
    TResult? Function(String message, List<CategoryModel>? categories)?
    processing,
    TResult? Function(
      String message,
      List<CategoryModel> categories,
      String operation,
    )?
    success,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? loading,
    TResult Function(
      List<CategoryModel> categories,
      List<CategoryModel> filteredCategories,
      String searchQuery,
      bool? isActiveFilter,
      String? userIdFilter,
      String sortBy,
      bool sortAscending,
      bool isListening,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult Function(
      String message,
      bool canRetry,
      CategoryState? previousState,
    )?
    error,
    TResult Function(String message, List<CategoryModel>? categories)?
    processing,
    TResult Function(
      String message,
      List<CategoryModel> categories,
      String operation,
    )?
    success,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CategoryInitial value) initial,
    required TResult Function(CategoryLoading value) loading,
    required TResult Function(CategoryLoaded value) loaded,
    required TResult Function(CategoryError value) error,
    required TResult Function(CategoryProcessing value) processing,
    required TResult Function(CategorySuccess value) success,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CategoryInitial value)? initial,
    TResult? Function(CategoryLoading value)? loading,
    TResult? Function(CategoryLoaded value)? loaded,
    TResult? Function(CategoryError value)? error,
    TResult? Function(CategoryProcessing value)? processing,
    TResult? Function(CategorySuccess value)? success,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CategoryInitial value)? initial,
    TResult Function(CategoryLoading value)? loading,
    TResult Function(CategoryLoaded value)? loaded,
    TResult Function(CategoryError value)? error,
    TResult Function(CategoryProcessing value)? processing,
    TResult Function(CategorySuccess value)? success,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryStateCopyWith<$Res> {
  factory $CategoryStateCopyWith(
    CategoryState value,
    $Res Function(CategoryState) then,
  ) = _$CategoryStateCopyWithImpl<$Res, CategoryState>;
}

/// @nodoc
class _$CategoryStateCopyWithImpl<$Res, $Val extends CategoryState>
    implements $CategoryStateCopyWith<$Res> {
  _$CategoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$CategoryInitialImplCopyWith<$Res> {
  factory _$$CategoryInitialImplCopyWith(
    _$CategoryInitialImpl value,
    $Res Function(_$CategoryInitialImpl) then,
  ) = __$$CategoryInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CategoryInitialImplCopyWithImpl<$Res>
    extends _$CategoryStateCopyWithImpl<$Res, _$CategoryInitialImpl>
    implements _$$CategoryInitialImplCopyWith<$Res> {
  __$$CategoryInitialImplCopyWithImpl(
    _$CategoryInitialImpl _value,
    $Res Function(_$CategoryInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CategoryInitialImpl implements CategoryInitial {
  const _$CategoryInitialImpl();

  @override
  String toString() {
    return 'CategoryState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CategoryInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) loading,
    required TResult Function(
      List<CategoryModel> categories,
      List<CategoryModel> filteredCategories,
      String searchQuery,
      bool? isActiveFilter,
      String? userIdFilter,
      String sortBy,
      bool sortAscending,
      bool isListening,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )
    loaded,
    required TResult Function(
      String message,
      bool canRetry,
      CategoryState? previousState,
    )
    error,
    required TResult Function(String message, List<CategoryModel>? categories)
    processing,
    required TResult Function(
      String message,
      List<CategoryModel> categories,
      String operation,
    )
    success,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? loading,
    TResult? Function(
      List<CategoryModel> categories,
      List<CategoryModel> filteredCategories,
      String searchQuery,
      bool? isActiveFilter,
      String? userIdFilter,
      String sortBy,
      bool sortAscending,
      bool isListening,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult? Function(
      String message,
      bool canRetry,
      CategoryState? previousState,
    )?
    error,
    TResult? Function(String message, List<CategoryModel>? categories)?
    processing,
    TResult? Function(
      String message,
      List<CategoryModel> categories,
      String operation,
    )?
    success,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? loading,
    TResult Function(
      List<CategoryModel> categories,
      List<CategoryModel> filteredCategories,
      String searchQuery,
      bool? isActiveFilter,
      String? userIdFilter,
      String sortBy,
      bool sortAscending,
      bool isListening,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult Function(
      String message,
      bool canRetry,
      CategoryState? previousState,
    )?
    error,
    TResult Function(String message, List<CategoryModel>? categories)?
    processing,
    TResult Function(
      String message,
      List<CategoryModel> categories,
      String operation,
    )?
    success,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CategoryInitial value) initial,
    required TResult Function(CategoryLoading value) loading,
    required TResult Function(CategoryLoaded value) loaded,
    required TResult Function(CategoryError value) error,
    required TResult Function(CategoryProcessing value) processing,
    required TResult Function(CategorySuccess value) success,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CategoryInitial value)? initial,
    TResult? Function(CategoryLoading value)? loading,
    TResult? Function(CategoryLoaded value)? loaded,
    TResult? Function(CategoryError value)? error,
    TResult? Function(CategoryProcessing value)? processing,
    TResult? Function(CategorySuccess value)? success,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CategoryInitial value)? initial,
    TResult Function(CategoryLoading value)? loading,
    TResult Function(CategoryLoaded value)? loaded,
    TResult Function(CategoryError value)? error,
    TResult Function(CategoryProcessing value)? processing,
    TResult Function(CategorySuccess value)? success,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class CategoryInitial implements CategoryState {
  const factory CategoryInitial() = _$CategoryInitialImpl;
}

/// @nodoc
abstract class _$$CategoryLoadingImplCopyWith<$Res> {
  factory _$$CategoryLoadingImplCopyWith(
    _$CategoryLoadingImpl value,
    $Res Function(_$CategoryLoadingImpl) then,
  ) = __$$CategoryLoadingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$CategoryLoadingImplCopyWithImpl<$Res>
    extends _$CategoryStateCopyWithImpl<$Res, _$CategoryLoadingImpl>
    implements _$$CategoryLoadingImplCopyWith<$Res> {
  __$$CategoryLoadingImplCopyWithImpl(
    _$CategoryLoadingImpl _value,
    $Res Function(_$CategoryLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = freezed}) {
    return _then(
      _$CategoryLoadingImpl(
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$CategoryLoadingImpl implements CategoryLoading {
  const _$CategoryLoadingImpl({this.message});

  @override
  final String? message;

  @override
  String toString() {
    return 'CategoryState.loading(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryLoadingImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryLoadingImplCopyWith<_$CategoryLoadingImpl> get copyWith =>
      __$$CategoryLoadingImplCopyWithImpl<_$CategoryLoadingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) loading,
    required TResult Function(
      List<CategoryModel> categories,
      List<CategoryModel> filteredCategories,
      String searchQuery,
      bool? isActiveFilter,
      String? userIdFilter,
      String sortBy,
      bool sortAscending,
      bool isListening,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )
    loaded,
    required TResult Function(
      String message,
      bool canRetry,
      CategoryState? previousState,
    )
    error,
    required TResult Function(String message, List<CategoryModel>? categories)
    processing,
    required TResult Function(
      String message,
      List<CategoryModel> categories,
      String operation,
    )
    success,
  }) {
    return loading(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? loading,
    TResult? Function(
      List<CategoryModel> categories,
      List<CategoryModel> filteredCategories,
      String searchQuery,
      bool? isActiveFilter,
      String? userIdFilter,
      String sortBy,
      bool sortAscending,
      bool isListening,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult? Function(
      String message,
      bool canRetry,
      CategoryState? previousState,
    )?
    error,
    TResult? Function(String message, List<CategoryModel>? categories)?
    processing,
    TResult? Function(
      String message,
      List<CategoryModel> categories,
      String operation,
    )?
    success,
  }) {
    return loading?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? loading,
    TResult Function(
      List<CategoryModel> categories,
      List<CategoryModel> filteredCategories,
      String searchQuery,
      bool? isActiveFilter,
      String? userIdFilter,
      String sortBy,
      bool sortAscending,
      bool isListening,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult Function(
      String message,
      bool canRetry,
      CategoryState? previousState,
    )?
    error,
    TResult Function(String message, List<CategoryModel>? categories)?
    processing,
    TResult Function(
      String message,
      List<CategoryModel> categories,
      String operation,
    )?
    success,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CategoryInitial value) initial,
    required TResult Function(CategoryLoading value) loading,
    required TResult Function(CategoryLoaded value) loaded,
    required TResult Function(CategoryError value) error,
    required TResult Function(CategoryProcessing value) processing,
    required TResult Function(CategorySuccess value) success,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CategoryInitial value)? initial,
    TResult? Function(CategoryLoading value)? loading,
    TResult? Function(CategoryLoaded value)? loaded,
    TResult? Function(CategoryError value)? error,
    TResult? Function(CategoryProcessing value)? processing,
    TResult? Function(CategorySuccess value)? success,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CategoryInitial value)? initial,
    TResult Function(CategoryLoading value)? loading,
    TResult Function(CategoryLoaded value)? loaded,
    TResult Function(CategoryError value)? error,
    TResult Function(CategoryProcessing value)? processing,
    TResult Function(CategorySuccess value)? success,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class CategoryLoading implements CategoryState {
  const factory CategoryLoading({final String? message}) =
      _$CategoryLoadingImpl;

  String? get message;

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryLoadingImplCopyWith<_$CategoryLoadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CategoryLoadedImplCopyWith<$Res> {
  factory _$$CategoryLoadedImplCopyWith(
    _$CategoryLoadedImpl value,
    $Res Function(_$CategoryLoadedImpl) then,
  ) = __$$CategoryLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<CategoryModel> categories,
    List<CategoryModel> filteredCategories,
    String searchQuery,
    bool? isActiveFilter,
    String? userIdFilter,
    String sortBy,
    bool sortAscending,
    bool isListening,
    Map<String, dynamic>? statistics,
    DateTime? lastLoadTime,
  });
}

/// @nodoc
class __$$CategoryLoadedImplCopyWithImpl<$Res>
    extends _$CategoryStateCopyWithImpl<$Res, _$CategoryLoadedImpl>
    implements _$$CategoryLoadedImplCopyWith<$Res> {
  __$$CategoryLoadedImplCopyWithImpl(
    _$CategoryLoadedImpl _value,
    $Res Function(_$CategoryLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categories = null,
    Object? filteredCategories = null,
    Object? searchQuery = null,
    Object? isActiveFilter = freezed,
    Object? userIdFilter = freezed,
    Object? sortBy = null,
    Object? sortAscending = null,
    Object? isListening = null,
    Object? statistics = freezed,
    Object? lastLoadTime = freezed,
  }) {
    return _then(
      _$CategoryLoadedImpl(
        categories: null == categories
            ? _value._categories
            : categories // ignore: cast_nullable_to_non_nullable
                  as List<CategoryModel>,
        filteredCategories: null == filteredCategories
            ? _value._filteredCategories
            : filteredCategories // ignore: cast_nullable_to_non_nullable
                  as List<CategoryModel>,
        searchQuery: null == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String,
        isActiveFilter: freezed == isActiveFilter
            ? _value.isActiveFilter
            : isActiveFilter // ignore: cast_nullable_to_non_nullable
                  as bool?,
        userIdFilter: freezed == userIdFilter
            ? _value.userIdFilter
            : userIdFilter // ignore: cast_nullable_to_non_nullable
                  as String?,
        sortBy: null == sortBy
            ? _value.sortBy
            : sortBy // ignore: cast_nullable_to_non_nullable
                  as String,
        sortAscending: null == sortAscending
            ? _value.sortAscending
            : sortAscending // ignore: cast_nullable_to_non_nullable
                  as bool,
        isListening: null == isListening
            ? _value.isListening
            : isListening // ignore: cast_nullable_to_non_nullable
                  as bool,
        statistics: freezed == statistics
            ? _value._statistics
            : statistics // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        lastLoadTime: freezed == lastLoadTime
            ? _value.lastLoadTime
            : lastLoadTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$CategoryLoadedImpl implements CategoryLoaded {
  const _$CategoryLoadedImpl({
    required final List<CategoryModel> categories,
    required final List<CategoryModel> filteredCategories,
    this.searchQuery = '',
    this.isActiveFilter,
    this.userIdFilter,
    this.sortBy = 'name',
    this.sortAscending = true,
    this.isListening = false,
    final Map<String, dynamic>? statistics,
    this.lastLoadTime,
  }) : _categories = categories,
       _filteredCategories = filteredCategories,
       _statistics = statistics;

  final List<CategoryModel> _categories;
  @override
  List<CategoryModel> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final List<CategoryModel> _filteredCategories;
  @override
  List<CategoryModel> get filteredCategories {
    if (_filteredCategories is EqualUnmodifiableListView)
      return _filteredCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredCategories);
  }

  @override
  @JsonKey()
  final String searchQuery;
  @override
  final bool? isActiveFilter;
  @override
  final String? userIdFilter;
  @override
  @JsonKey()
  final String sortBy;
  @override
  @JsonKey()
  final bool sortAscending;
  @override
  @JsonKey()
  final bool isListening;
  final Map<String, dynamic>? _statistics;
  @override
  Map<String, dynamic>? get statistics {
    final value = _statistics;
    if (value == null) return null;
    if (_statistics is EqualUnmodifiableMapView) return _statistics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime? lastLoadTime;

  @override
  String toString() {
    return 'CategoryState.loaded(categories: $categories, filteredCategories: $filteredCategories, searchQuery: $searchQuery, isActiveFilter: $isActiveFilter, userIdFilter: $userIdFilter, sortBy: $sortBy, sortAscending: $sortAscending, isListening: $isListening, statistics: $statistics, lastLoadTime: $lastLoadTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryLoadedImpl &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ) &&
            const DeepCollectionEquality().equals(
              other._filteredCategories,
              _filteredCategories,
            ) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.isActiveFilter, isActiveFilter) ||
                other.isActiveFilter == isActiveFilter) &&
            (identical(other.userIdFilter, userIdFilter) ||
                other.userIdFilter == userIdFilter) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.sortAscending, sortAscending) ||
                other.sortAscending == sortAscending) &&
            (identical(other.isListening, isListening) ||
                other.isListening == isListening) &&
            const DeepCollectionEquality().equals(
              other._statistics,
              _statistics,
            ) &&
            (identical(other.lastLoadTime, lastLoadTime) ||
                other.lastLoadTime == lastLoadTime));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_categories),
    const DeepCollectionEquality().hash(_filteredCategories),
    searchQuery,
    isActiveFilter,
    userIdFilter,
    sortBy,
    sortAscending,
    isListening,
    const DeepCollectionEquality().hash(_statistics),
    lastLoadTime,
  );

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryLoadedImplCopyWith<_$CategoryLoadedImpl> get copyWith =>
      __$$CategoryLoadedImplCopyWithImpl<_$CategoryLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) loading,
    required TResult Function(
      List<CategoryModel> categories,
      List<CategoryModel> filteredCategories,
      String searchQuery,
      bool? isActiveFilter,
      String? userIdFilter,
      String sortBy,
      bool sortAscending,
      bool isListening,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )
    loaded,
    required TResult Function(
      String message,
      bool canRetry,
      CategoryState? previousState,
    )
    error,
    required TResult Function(String message, List<CategoryModel>? categories)
    processing,
    required TResult Function(
      String message,
      List<CategoryModel> categories,
      String operation,
    )
    success,
  }) {
    return loaded(
      categories,
      filteredCategories,
      searchQuery,
      isActiveFilter,
      userIdFilter,
      sortBy,
      sortAscending,
      isListening,
      statistics,
      lastLoadTime,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? loading,
    TResult? Function(
      List<CategoryModel> categories,
      List<CategoryModel> filteredCategories,
      String searchQuery,
      bool? isActiveFilter,
      String? userIdFilter,
      String sortBy,
      bool sortAscending,
      bool isListening,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult? Function(
      String message,
      bool canRetry,
      CategoryState? previousState,
    )?
    error,
    TResult? Function(String message, List<CategoryModel>? categories)?
    processing,
    TResult? Function(
      String message,
      List<CategoryModel> categories,
      String operation,
    )?
    success,
  }) {
    return loaded?.call(
      categories,
      filteredCategories,
      searchQuery,
      isActiveFilter,
      userIdFilter,
      sortBy,
      sortAscending,
      isListening,
      statistics,
      lastLoadTime,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? loading,
    TResult Function(
      List<CategoryModel> categories,
      List<CategoryModel> filteredCategories,
      String searchQuery,
      bool? isActiveFilter,
      String? userIdFilter,
      String sortBy,
      bool sortAscending,
      bool isListening,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult Function(
      String message,
      bool canRetry,
      CategoryState? previousState,
    )?
    error,
    TResult Function(String message, List<CategoryModel>? categories)?
    processing,
    TResult Function(
      String message,
      List<CategoryModel> categories,
      String operation,
    )?
    success,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(
        categories,
        filteredCategories,
        searchQuery,
        isActiveFilter,
        userIdFilter,
        sortBy,
        sortAscending,
        isListening,
        statistics,
        lastLoadTime,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CategoryInitial value) initial,
    required TResult Function(CategoryLoading value) loading,
    required TResult Function(CategoryLoaded value) loaded,
    required TResult Function(CategoryError value) error,
    required TResult Function(CategoryProcessing value) processing,
    required TResult Function(CategorySuccess value) success,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CategoryInitial value)? initial,
    TResult? Function(CategoryLoading value)? loading,
    TResult? Function(CategoryLoaded value)? loaded,
    TResult? Function(CategoryError value)? error,
    TResult? Function(CategoryProcessing value)? processing,
    TResult? Function(CategorySuccess value)? success,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CategoryInitial value)? initial,
    TResult Function(CategoryLoading value)? loading,
    TResult Function(CategoryLoaded value)? loaded,
    TResult Function(CategoryError value)? error,
    TResult Function(CategoryProcessing value)? processing,
    TResult Function(CategorySuccess value)? success,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class CategoryLoaded implements CategoryState {
  const factory CategoryLoaded({
    required final List<CategoryModel> categories,
    required final List<CategoryModel> filteredCategories,
    final String searchQuery,
    final bool? isActiveFilter,
    final String? userIdFilter,
    final String sortBy,
    final bool sortAscending,
    final bool isListening,
    final Map<String, dynamic>? statistics,
    final DateTime? lastLoadTime,
  }) = _$CategoryLoadedImpl;

  List<CategoryModel> get categories;
  List<CategoryModel> get filteredCategories;
  String get searchQuery;
  bool? get isActiveFilter;
  String? get userIdFilter;
  String get sortBy;
  bool get sortAscending;
  bool get isListening;
  Map<String, dynamic>? get statistics;
  DateTime? get lastLoadTime;

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryLoadedImplCopyWith<_$CategoryLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CategoryErrorImplCopyWith<$Res> {
  factory _$$CategoryErrorImplCopyWith(
    _$CategoryErrorImpl value,
    $Res Function(_$CategoryErrorImpl) then,
  ) = __$$CategoryErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, bool canRetry, CategoryState? previousState});

  $CategoryStateCopyWith<$Res>? get previousState;
}

/// @nodoc
class __$$CategoryErrorImplCopyWithImpl<$Res>
    extends _$CategoryStateCopyWithImpl<$Res, _$CategoryErrorImpl>
    implements _$$CategoryErrorImplCopyWith<$Res> {
  __$$CategoryErrorImplCopyWithImpl(
    _$CategoryErrorImpl _value,
    $Res Function(_$CategoryErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? canRetry = null,
    Object? previousState = freezed,
  }) {
    return _then(
      _$CategoryErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        canRetry: null == canRetry
            ? _value.canRetry
            : canRetry // ignore: cast_nullable_to_non_nullable
                  as bool,
        previousState: freezed == previousState
            ? _value.previousState
            : previousState // ignore: cast_nullable_to_non_nullable
                  as CategoryState?,
      ),
    );
  }

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryStateCopyWith<$Res>? get previousState {
    if (_value.previousState == null) {
      return null;
    }

    return $CategoryStateCopyWith<$Res>(_value.previousState!, (value) {
      return _then(_value.copyWith(previousState: value));
    });
  }
}

/// @nodoc

class _$CategoryErrorImpl implements CategoryError {
  const _$CategoryErrorImpl({
    required this.message,
    this.canRetry = true,
    this.previousState,
  });

  @override
  final String message;
  @override
  @JsonKey()
  final bool canRetry;
  @override
  final CategoryState? previousState;

  @override
  String toString() {
    return 'CategoryState.error(message: $message, canRetry: $canRetry, previousState: $previousState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.canRetry, canRetry) ||
                other.canRetry == canRetry) &&
            (identical(other.previousState, previousState) ||
                other.previousState == previousState));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, message, canRetry, previousState);

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryErrorImplCopyWith<_$CategoryErrorImpl> get copyWith =>
      __$$CategoryErrorImplCopyWithImpl<_$CategoryErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) loading,
    required TResult Function(
      List<CategoryModel> categories,
      List<CategoryModel> filteredCategories,
      String searchQuery,
      bool? isActiveFilter,
      String? userIdFilter,
      String sortBy,
      bool sortAscending,
      bool isListening,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )
    loaded,
    required TResult Function(
      String message,
      bool canRetry,
      CategoryState? previousState,
    )
    error,
    required TResult Function(String message, List<CategoryModel>? categories)
    processing,
    required TResult Function(
      String message,
      List<CategoryModel> categories,
      String operation,
    )
    success,
  }) {
    return error(message, canRetry, previousState);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? loading,
    TResult? Function(
      List<CategoryModel> categories,
      List<CategoryModel> filteredCategories,
      String searchQuery,
      bool? isActiveFilter,
      String? userIdFilter,
      String sortBy,
      bool sortAscending,
      bool isListening,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult? Function(
      String message,
      bool canRetry,
      CategoryState? previousState,
    )?
    error,
    TResult? Function(String message, List<CategoryModel>? categories)?
    processing,
    TResult? Function(
      String message,
      List<CategoryModel> categories,
      String operation,
    )?
    success,
  }) {
    return error?.call(message, canRetry, previousState);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? loading,
    TResult Function(
      List<CategoryModel> categories,
      List<CategoryModel> filteredCategories,
      String searchQuery,
      bool? isActiveFilter,
      String? userIdFilter,
      String sortBy,
      bool sortAscending,
      bool isListening,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult Function(
      String message,
      bool canRetry,
      CategoryState? previousState,
    )?
    error,
    TResult Function(String message, List<CategoryModel>? categories)?
    processing,
    TResult Function(
      String message,
      List<CategoryModel> categories,
      String operation,
    )?
    success,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message, canRetry, previousState);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CategoryInitial value) initial,
    required TResult Function(CategoryLoading value) loading,
    required TResult Function(CategoryLoaded value) loaded,
    required TResult Function(CategoryError value) error,
    required TResult Function(CategoryProcessing value) processing,
    required TResult Function(CategorySuccess value) success,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CategoryInitial value)? initial,
    TResult? Function(CategoryLoading value)? loading,
    TResult? Function(CategoryLoaded value)? loaded,
    TResult? Function(CategoryError value)? error,
    TResult? Function(CategoryProcessing value)? processing,
    TResult? Function(CategorySuccess value)? success,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CategoryInitial value)? initial,
    TResult Function(CategoryLoading value)? loading,
    TResult Function(CategoryLoaded value)? loaded,
    TResult Function(CategoryError value)? error,
    TResult Function(CategoryProcessing value)? processing,
    TResult Function(CategorySuccess value)? success,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class CategoryError implements CategoryState {
  const factory CategoryError({
    required final String message,
    final bool canRetry,
    final CategoryState? previousState,
  }) = _$CategoryErrorImpl;

  String get message;
  bool get canRetry;
  CategoryState? get previousState;

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryErrorImplCopyWith<_$CategoryErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CategoryProcessingImplCopyWith<$Res> {
  factory _$$CategoryProcessingImplCopyWith(
    _$CategoryProcessingImpl value,
    $Res Function(_$CategoryProcessingImpl) then,
  ) = __$$CategoryProcessingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, List<CategoryModel>? categories});
}

/// @nodoc
class __$$CategoryProcessingImplCopyWithImpl<$Res>
    extends _$CategoryStateCopyWithImpl<$Res, _$CategoryProcessingImpl>
    implements _$$CategoryProcessingImplCopyWith<$Res> {
  __$$CategoryProcessingImplCopyWithImpl(
    _$CategoryProcessingImpl _value,
    $Res Function(_$CategoryProcessingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? categories = freezed}) {
    return _then(
      _$CategoryProcessingImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        categories: freezed == categories
            ? _value._categories
            : categories // ignore: cast_nullable_to_non_nullable
                  as List<CategoryModel>?,
      ),
    );
  }
}

/// @nodoc

class _$CategoryProcessingImpl implements CategoryProcessing {
  const _$CategoryProcessingImpl({
    required this.message,
    final List<CategoryModel>? categories,
  }) : _categories = categories;

  @override
  final String message;
  final List<CategoryModel>? _categories;
  @override
  List<CategoryModel>? get categories {
    final value = _categories;
    if (value == null) return null;
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CategoryState.processing(message: $message, categories: $categories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryProcessingImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(_categories),
  );

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryProcessingImplCopyWith<_$CategoryProcessingImpl> get copyWith =>
      __$$CategoryProcessingImplCopyWithImpl<_$CategoryProcessingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) loading,
    required TResult Function(
      List<CategoryModel> categories,
      List<CategoryModel> filteredCategories,
      String searchQuery,
      bool? isActiveFilter,
      String? userIdFilter,
      String sortBy,
      bool sortAscending,
      bool isListening,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )
    loaded,
    required TResult Function(
      String message,
      bool canRetry,
      CategoryState? previousState,
    )
    error,
    required TResult Function(String message, List<CategoryModel>? categories)
    processing,
    required TResult Function(
      String message,
      List<CategoryModel> categories,
      String operation,
    )
    success,
  }) {
    return processing(message, categories);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? loading,
    TResult? Function(
      List<CategoryModel> categories,
      List<CategoryModel> filteredCategories,
      String searchQuery,
      bool? isActiveFilter,
      String? userIdFilter,
      String sortBy,
      bool sortAscending,
      bool isListening,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult? Function(
      String message,
      bool canRetry,
      CategoryState? previousState,
    )?
    error,
    TResult? Function(String message, List<CategoryModel>? categories)?
    processing,
    TResult? Function(
      String message,
      List<CategoryModel> categories,
      String operation,
    )?
    success,
  }) {
    return processing?.call(message, categories);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? loading,
    TResult Function(
      List<CategoryModel> categories,
      List<CategoryModel> filteredCategories,
      String searchQuery,
      bool? isActiveFilter,
      String? userIdFilter,
      String sortBy,
      bool sortAscending,
      bool isListening,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult Function(
      String message,
      bool canRetry,
      CategoryState? previousState,
    )?
    error,
    TResult Function(String message, List<CategoryModel>? categories)?
    processing,
    TResult Function(
      String message,
      List<CategoryModel> categories,
      String operation,
    )?
    success,
    required TResult orElse(),
  }) {
    if (processing != null) {
      return processing(message, categories);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CategoryInitial value) initial,
    required TResult Function(CategoryLoading value) loading,
    required TResult Function(CategoryLoaded value) loaded,
    required TResult Function(CategoryError value) error,
    required TResult Function(CategoryProcessing value) processing,
    required TResult Function(CategorySuccess value) success,
  }) {
    return processing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CategoryInitial value)? initial,
    TResult? Function(CategoryLoading value)? loading,
    TResult? Function(CategoryLoaded value)? loaded,
    TResult? Function(CategoryError value)? error,
    TResult? Function(CategoryProcessing value)? processing,
    TResult? Function(CategorySuccess value)? success,
  }) {
    return processing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CategoryInitial value)? initial,
    TResult Function(CategoryLoading value)? loading,
    TResult Function(CategoryLoaded value)? loaded,
    TResult Function(CategoryError value)? error,
    TResult Function(CategoryProcessing value)? processing,
    TResult Function(CategorySuccess value)? success,
    required TResult orElse(),
  }) {
    if (processing != null) {
      return processing(this);
    }
    return orElse();
  }
}

abstract class CategoryProcessing implements CategoryState {
  const factory CategoryProcessing({
    required final String message,
    final List<CategoryModel>? categories,
  }) = _$CategoryProcessingImpl;

  String get message;
  List<CategoryModel>? get categories;

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryProcessingImplCopyWith<_$CategoryProcessingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CategorySuccessImplCopyWith<$Res> {
  factory _$$CategorySuccessImplCopyWith(
    _$CategorySuccessImpl value,
    $Res Function(_$CategorySuccessImpl) then,
  ) = __$$CategorySuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, List<CategoryModel> categories, String operation});
}

/// @nodoc
class __$$CategorySuccessImplCopyWithImpl<$Res>
    extends _$CategoryStateCopyWithImpl<$Res, _$CategorySuccessImpl>
    implements _$$CategorySuccessImplCopyWith<$Res> {
  __$$CategorySuccessImplCopyWithImpl(
    _$CategorySuccessImpl _value,
    $Res Function(_$CategorySuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? categories = null,
    Object? operation = null,
  }) {
    return _then(
      _$CategorySuccessImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        categories: null == categories
            ? _value._categories
            : categories // ignore: cast_nullable_to_non_nullable
                  as List<CategoryModel>,
        operation: null == operation
            ? _value.operation
            : operation // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$CategorySuccessImpl implements CategorySuccess {
  const _$CategorySuccessImpl({
    required this.message,
    required final List<CategoryModel> categories,
    required this.operation,
  }) : _categories = categories;

  @override
  final String message;
  final List<CategoryModel> _categories;
  @override
  List<CategoryModel> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  final String operation;

  @override
  String toString() {
    return 'CategoryState.success(message: $message, categories: $categories, operation: $operation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategorySuccessImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ) &&
            (identical(other.operation, operation) ||
                other.operation == operation));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(_categories),
    operation,
  );

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategorySuccessImplCopyWith<_$CategorySuccessImpl> get copyWith =>
      __$$CategorySuccessImplCopyWithImpl<_$CategorySuccessImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) loading,
    required TResult Function(
      List<CategoryModel> categories,
      List<CategoryModel> filteredCategories,
      String searchQuery,
      bool? isActiveFilter,
      String? userIdFilter,
      String sortBy,
      bool sortAscending,
      bool isListening,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )
    loaded,
    required TResult Function(
      String message,
      bool canRetry,
      CategoryState? previousState,
    )
    error,
    required TResult Function(String message, List<CategoryModel>? categories)
    processing,
    required TResult Function(
      String message,
      List<CategoryModel> categories,
      String operation,
    )
    success,
  }) {
    return success(message, categories, operation);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? loading,
    TResult? Function(
      List<CategoryModel> categories,
      List<CategoryModel> filteredCategories,
      String searchQuery,
      bool? isActiveFilter,
      String? userIdFilter,
      String sortBy,
      bool sortAscending,
      bool isListening,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult? Function(
      String message,
      bool canRetry,
      CategoryState? previousState,
    )?
    error,
    TResult? Function(String message, List<CategoryModel>? categories)?
    processing,
    TResult? Function(
      String message,
      List<CategoryModel> categories,
      String operation,
    )?
    success,
  }) {
    return success?.call(message, categories, operation);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? loading,
    TResult Function(
      List<CategoryModel> categories,
      List<CategoryModel> filteredCategories,
      String searchQuery,
      bool? isActiveFilter,
      String? userIdFilter,
      String sortBy,
      bool sortAscending,
      bool isListening,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult Function(
      String message,
      bool canRetry,
      CategoryState? previousState,
    )?
    error,
    TResult Function(String message, List<CategoryModel>? categories)?
    processing,
    TResult Function(
      String message,
      List<CategoryModel> categories,
      String operation,
    )?
    success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(message, categories, operation);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CategoryInitial value) initial,
    required TResult Function(CategoryLoading value) loading,
    required TResult Function(CategoryLoaded value) loaded,
    required TResult Function(CategoryError value) error,
    required TResult Function(CategoryProcessing value) processing,
    required TResult Function(CategorySuccess value) success,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CategoryInitial value)? initial,
    TResult? Function(CategoryLoading value)? loading,
    TResult? Function(CategoryLoaded value)? loaded,
    TResult? Function(CategoryError value)? error,
    TResult? Function(CategoryProcessing value)? processing,
    TResult? Function(CategorySuccess value)? success,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CategoryInitial value)? initial,
    TResult Function(CategoryLoading value)? loading,
    TResult Function(CategoryLoaded value)? loaded,
    TResult Function(CategoryError value)? error,
    TResult Function(CategoryProcessing value)? processing,
    TResult Function(CategorySuccess value)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class CategorySuccess implements CategoryState {
  const factory CategorySuccess({
    required final String message,
    required final List<CategoryModel> categories,
    required final String operation,
  }) = _$CategorySuccessImpl;

  String get message;
  List<CategoryModel> get categories;
  String get operation;

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategorySuccessImplCopyWith<_$CategorySuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
