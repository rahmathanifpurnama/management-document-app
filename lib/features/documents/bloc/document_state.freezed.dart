// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DocumentState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) loading,
    required TResult Function(
      List<DocumentModel> documents,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
      bool hasMoreDocuments,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )
    loaded,
    required TResult Function(
      String message,
      DocumentState? previousState,
      bool canRetry,
    )
    error,
    required TResult Function(
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )
    loadingMore,
    required TResult Function(
      String operation,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )
    performingOperation,
    required TResult Function(
      String message,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
    )
    syncing,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? loading,
    TResult? Function(
      List<DocumentModel> documents,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
      bool hasMoreDocuments,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult? Function(
      String message,
      DocumentState? previousState,
      bool canRetry,
    )?
    error,
    TResult? Function(
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    loadingMore,
    TResult? Function(
      String operation,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    performingOperation,
    TResult? Function(
      String message,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
    )?
    syncing,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? loading,
    TResult Function(
      List<DocumentModel> documents,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
      bool hasMoreDocuments,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult Function(
      String message,
      DocumentState? previousState,
      bool canRetry,
    )?
    error,
    TResult Function(
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    loadingMore,
    TResult Function(
      String operation,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    performingOperation,
    TResult Function(
      String message,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
    )?
    syncing,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DocumentInitial value) initial,
    required TResult Function(DocumentLoading value) loading,
    required TResult Function(DocumentLoaded value) loaded,
    required TResult Function(DocumentError value) error,
    required TResult Function(DocumentLoadingMore value) loadingMore,
    required TResult Function(DocumentPerformingOperation value)
    performingOperation,
    required TResult Function(DocumentSyncing value) syncing,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DocumentInitial value)? initial,
    TResult? Function(DocumentLoading value)? loading,
    TResult? Function(DocumentLoaded value)? loaded,
    TResult? Function(DocumentError value)? error,
    TResult? Function(DocumentLoadingMore value)? loadingMore,
    TResult? Function(DocumentPerformingOperation value)? performingOperation,
    TResult? Function(DocumentSyncing value)? syncing,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DocumentInitial value)? initial,
    TResult Function(DocumentLoading value)? loading,
    TResult Function(DocumentLoaded value)? loaded,
    TResult Function(DocumentError value)? error,
    TResult Function(DocumentLoadingMore value)? loadingMore,
    TResult Function(DocumentPerformingOperation value)? performingOperation,
    TResult Function(DocumentSyncing value)? syncing,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentStateCopyWith<$Res> {
  factory $DocumentStateCopyWith(
    DocumentState value,
    $Res Function(DocumentState) then,
  ) = _$DocumentStateCopyWithImpl<$Res, DocumentState>;
}

/// @nodoc
class _$DocumentStateCopyWithImpl<$Res, $Val extends DocumentState>
    implements $DocumentStateCopyWith<$Res> {
  _$DocumentStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DocumentState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$DocumentInitialImplCopyWith<$Res> {
  factory _$$DocumentInitialImplCopyWith(
    _$DocumentInitialImpl value,
    $Res Function(_$DocumentInitialImpl) then,
  ) = __$$DocumentInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DocumentInitialImplCopyWithImpl<$Res>
    extends _$DocumentStateCopyWithImpl<$Res, _$DocumentInitialImpl>
    implements _$$DocumentInitialImplCopyWith<$Res> {
  __$$DocumentInitialImplCopyWithImpl(
    _$DocumentInitialImpl _value,
    $Res Function(_$DocumentInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DocumentInitialImpl implements DocumentInitial {
  const _$DocumentInitialImpl();

  @override
  String toString() {
    return 'DocumentState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DocumentInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) loading,
    required TResult Function(
      List<DocumentModel> documents,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
      bool hasMoreDocuments,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )
    loaded,
    required TResult Function(
      String message,
      DocumentState? previousState,
      bool canRetry,
    )
    error,
    required TResult Function(
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )
    loadingMore,
    required TResult Function(
      String operation,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )
    performingOperation,
    required TResult Function(
      String message,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
    )
    syncing,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? loading,
    TResult? Function(
      List<DocumentModel> documents,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
      bool hasMoreDocuments,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult? Function(
      String message,
      DocumentState? previousState,
      bool canRetry,
    )?
    error,
    TResult? Function(
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    loadingMore,
    TResult? Function(
      String operation,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    performingOperation,
    TResult? Function(
      String message,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
    )?
    syncing,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? loading,
    TResult Function(
      List<DocumentModel> documents,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
      bool hasMoreDocuments,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult Function(
      String message,
      DocumentState? previousState,
      bool canRetry,
    )?
    error,
    TResult Function(
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    loadingMore,
    TResult Function(
      String operation,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    performingOperation,
    TResult Function(
      String message,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
    )?
    syncing,
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
    required TResult Function(DocumentInitial value) initial,
    required TResult Function(DocumentLoading value) loading,
    required TResult Function(DocumentLoaded value) loaded,
    required TResult Function(DocumentError value) error,
    required TResult Function(DocumentLoadingMore value) loadingMore,
    required TResult Function(DocumentPerformingOperation value)
    performingOperation,
    required TResult Function(DocumentSyncing value) syncing,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DocumentInitial value)? initial,
    TResult? Function(DocumentLoading value)? loading,
    TResult? Function(DocumentLoaded value)? loaded,
    TResult? Function(DocumentError value)? error,
    TResult? Function(DocumentLoadingMore value)? loadingMore,
    TResult? Function(DocumentPerformingOperation value)? performingOperation,
    TResult? Function(DocumentSyncing value)? syncing,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DocumentInitial value)? initial,
    TResult Function(DocumentLoading value)? loading,
    TResult Function(DocumentLoaded value)? loaded,
    TResult Function(DocumentError value)? error,
    TResult Function(DocumentLoadingMore value)? loadingMore,
    TResult Function(DocumentPerformingOperation value)? performingOperation,
    TResult Function(DocumentSyncing value)? syncing,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class DocumentInitial implements DocumentState {
  const factory DocumentInitial() = _$DocumentInitialImpl;
}

/// @nodoc
abstract class _$$DocumentLoadingImplCopyWith<$Res> {
  factory _$$DocumentLoadingImplCopyWith(
    _$DocumentLoadingImpl value,
    $Res Function(_$DocumentLoadingImpl) then,
  ) = __$$DocumentLoadingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$DocumentLoadingImplCopyWithImpl<$Res>
    extends _$DocumentStateCopyWithImpl<$Res, _$DocumentLoadingImpl>
    implements _$$DocumentLoadingImplCopyWith<$Res> {
  __$$DocumentLoadingImplCopyWithImpl(
    _$DocumentLoadingImpl _value,
    $Res Function(_$DocumentLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = freezed}) {
    return _then(
      _$DocumentLoadingImpl(
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$DocumentLoadingImpl implements DocumentLoading {
  const _$DocumentLoadingImpl({this.message});

  @override
  final String? message;

  @override
  String toString() {
    return 'DocumentState.loading(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentLoadingImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of DocumentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentLoadingImplCopyWith<_$DocumentLoadingImpl> get copyWith =>
      __$$DocumentLoadingImplCopyWithImpl<_$DocumentLoadingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) loading,
    required TResult Function(
      List<DocumentModel> documents,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
      bool hasMoreDocuments,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )
    loaded,
    required TResult Function(
      String message,
      DocumentState? previousState,
      bool canRetry,
    )
    error,
    required TResult Function(
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )
    loadingMore,
    required TResult Function(
      String operation,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )
    performingOperation,
    required TResult Function(
      String message,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
    )
    syncing,
  }) {
    return loading(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? loading,
    TResult? Function(
      List<DocumentModel> documents,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
      bool hasMoreDocuments,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult? Function(
      String message,
      DocumentState? previousState,
      bool canRetry,
    )?
    error,
    TResult? Function(
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    loadingMore,
    TResult? Function(
      String operation,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    performingOperation,
    TResult? Function(
      String message,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
    )?
    syncing,
  }) {
    return loading?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? loading,
    TResult Function(
      List<DocumentModel> documents,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
      bool hasMoreDocuments,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult Function(
      String message,
      DocumentState? previousState,
      bool canRetry,
    )?
    error,
    TResult Function(
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    loadingMore,
    TResult Function(
      String operation,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    performingOperation,
    TResult Function(
      String message,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
    )?
    syncing,
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
    required TResult Function(DocumentInitial value) initial,
    required TResult Function(DocumentLoading value) loading,
    required TResult Function(DocumentLoaded value) loaded,
    required TResult Function(DocumentError value) error,
    required TResult Function(DocumentLoadingMore value) loadingMore,
    required TResult Function(DocumentPerformingOperation value)
    performingOperation,
    required TResult Function(DocumentSyncing value) syncing,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DocumentInitial value)? initial,
    TResult? Function(DocumentLoading value)? loading,
    TResult? Function(DocumentLoaded value)? loaded,
    TResult? Function(DocumentError value)? error,
    TResult? Function(DocumentLoadingMore value)? loadingMore,
    TResult? Function(DocumentPerformingOperation value)? performingOperation,
    TResult? Function(DocumentSyncing value)? syncing,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DocumentInitial value)? initial,
    TResult Function(DocumentLoading value)? loading,
    TResult Function(DocumentLoaded value)? loaded,
    TResult Function(DocumentError value)? error,
    TResult Function(DocumentLoadingMore value)? loadingMore,
    TResult Function(DocumentPerformingOperation value)? performingOperation,
    TResult Function(DocumentSyncing value)? syncing,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class DocumentLoading implements DocumentState {
  const factory DocumentLoading({final String? message}) =
      _$DocumentLoadingImpl;

  String? get message;

  /// Create a copy of DocumentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentLoadingImplCopyWith<_$DocumentLoadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DocumentLoadedImplCopyWith<$Res> {
  factory _$$DocumentLoadedImplCopyWith(
    _$DocumentLoadedImpl value,
    $Res Function(_$DocumentLoadedImpl) then,
  ) = __$$DocumentLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<DocumentModel> documents,
    List<DocumentModel> filteredDocuments,
    String searchQuery,
    String selectedCategory,
    String selectedStatus,
    String selectedFileType,
    String? selectedUserId,
    String sortBy,
    bool sortAscending,
    bool isListening,
    bool hasMoreDocuments,
    Map<String, dynamic>? statistics,
    DateTime? lastLoadTime,
  });
}

/// @nodoc
class __$$DocumentLoadedImplCopyWithImpl<$Res>
    extends _$DocumentStateCopyWithImpl<$Res, _$DocumentLoadedImpl>
    implements _$$DocumentLoadedImplCopyWith<$Res> {
  __$$DocumentLoadedImplCopyWithImpl(
    _$DocumentLoadedImpl _value,
    $Res Function(_$DocumentLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documents = null,
    Object? filteredDocuments = null,
    Object? searchQuery = null,
    Object? selectedCategory = null,
    Object? selectedStatus = null,
    Object? selectedFileType = null,
    Object? selectedUserId = freezed,
    Object? sortBy = null,
    Object? sortAscending = null,
    Object? isListening = null,
    Object? hasMoreDocuments = null,
    Object? statistics = freezed,
    Object? lastLoadTime = freezed,
  }) {
    return _then(
      _$DocumentLoadedImpl(
        documents: null == documents
            ? _value._documents
            : documents // ignore: cast_nullable_to_non_nullable
                  as List<DocumentModel>,
        filteredDocuments: null == filteredDocuments
            ? _value._filteredDocuments
            : filteredDocuments // ignore: cast_nullable_to_non_nullable
                  as List<DocumentModel>,
        searchQuery: null == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedCategory: null == selectedCategory
            ? _value.selectedCategory
            : selectedCategory // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedStatus: null == selectedStatus
            ? _value.selectedStatus
            : selectedStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedFileType: null == selectedFileType
            ? _value.selectedFileType
            : selectedFileType // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedUserId: freezed == selectedUserId
            ? _value.selectedUserId
            : selectedUserId // ignore: cast_nullable_to_non_nullable
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
        hasMoreDocuments: null == hasMoreDocuments
            ? _value.hasMoreDocuments
            : hasMoreDocuments // ignore: cast_nullable_to_non_nullable
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

class _$DocumentLoadedImpl implements DocumentLoaded {
  const _$DocumentLoadedImpl({
    required final List<DocumentModel> documents,
    required final List<DocumentModel> filteredDocuments,
    this.searchQuery = '',
    this.selectedCategory = 'all',
    this.selectedStatus = 'all',
    this.selectedFileType = 'all',
    this.selectedUserId,
    this.sortBy = 'uploadedAt',
    this.sortAscending = false,
    this.isListening = false,
    this.hasMoreDocuments = true,
    final Map<String, dynamic>? statistics,
    this.lastLoadTime,
  }) : _documents = documents,
       _filteredDocuments = filteredDocuments,
       _statistics = statistics;

  final List<DocumentModel> _documents;
  @override
  List<DocumentModel> get documents {
    if (_documents is EqualUnmodifiableListView) return _documents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_documents);
  }

  final List<DocumentModel> _filteredDocuments;
  @override
  List<DocumentModel> get filteredDocuments {
    if (_filteredDocuments is EqualUnmodifiableListView)
      return _filteredDocuments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredDocuments);
  }

  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final String selectedCategory;
  @override
  @JsonKey()
  final String selectedStatus;
  @override
  @JsonKey()
  final String selectedFileType;
  @override
  final String? selectedUserId;
  @override
  @JsonKey()
  final String sortBy;
  @override
  @JsonKey()
  final bool sortAscending;
  @override
  @JsonKey()
  final bool isListening;
  @override
  @JsonKey()
  final bool hasMoreDocuments;
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
    return 'DocumentState.loaded(documents: $documents, filteredDocuments: $filteredDocuments, searchQuery: $searchQuery, selectedCategory: $selectedCategory, selectedStatus: $selectedStatus, selectedFileType: $selectedFileType, selectedUserId: $selectedUserId, sortBy: $sortBy, sortAscending: $sortAscending, isListening: $isListening, hasMoreDocuments: $hasMoreDocuments, statistics: $statistics, lastLoadTime: $lastLoadTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentLoadedImpl &&
            const DeepCollectionEquality().equals(
              other._documents,
              _documents,
            ) &&
            const DeepCollectionEquality().equals(
              other._filteredDocuments,
              _filteredDocuments,
            ) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.selectedStatus, selectedStatus) ||
                other.selectedStatus == selectedStatus) &&
            (identical(other.selectedFileType, selectedFileType) ||
                other.selectedFileType == selectedFileType) &&
            (identical(other.selectedUserId, selectedUserId) ||
                other.selectedUserId == selectedUserId) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.sortAscending, sortAscending) ||
                other.sortAscending == sortAscending) &&
            (identical(other.isListening, isListening) ||
                other.isListening == isListening) &&
            (identical(other.hasMoreDocuments, hasMoreDocuments) ||
                other.hasMoreDocuments == hasMoreDocuments) &&
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
    const DeepCollectionEquality().hash(_documents),
    const DeepCollectionEquality().hash(_filteredDocuments),
    searchQuery,
    selectedCategory,
    selectedStatus,
    selectedFileType,
    selectedUserId,
    sortBy,
    sortAscending,
    isListening,
    hasMoreDocuments,
    const DeepCollectionEquality().hash(_statistics),
    lastLoadTime,
  );

  /// Create a copy of DocumentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentLoadedImplCopyWith<_$DocumentLoadedImpl> get copyWith =>
      __$$DocumentLoadedImplCopyWithImpl<_$DocumentLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) loading,
    required TResult Function(
      List<DocumentModel> documents,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
      bool hasMoreDocuments,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )
    loaded,
    required TResult Function(
      String message,
      DocumentState? previousState,
      bool canRetry,
    )
    error,
    required TResult Function(
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )
    loadingMore,
    required TResult Function(
      String operation,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )
    performingOperation,
    required TResult Function(
      String message,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
    )
    syncing,
  }) {
    return loaded(
      documents,
      filteredDocuments,
      searchQuery,
      selectedCategory,
      selectedStatus,
      selectedFileType,
      selectedUserId,
      sortBy,
      sortAscending,
      isListening,
      hasMoreDocuments,
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
      List<DocumentModel> documents,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
      bool hasMoreDocuments,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult? Function(
      String message,
      DocumentState? previousState,
      bool canRetry,
    )?
    error,
    TResult? Function(
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    loadingMore,
    TResult? Function(
      String operation,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    performingOperation,
    TResult? Function(
      String message,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
    )?
    syncing,
  }) {
    return loaded?.call(
      documents,
      filteredDocuments,
      searchQuery,
      selectedCategory,
      selectedStatus,
      selectedFileType,
      selectedUserId,
      sortBy,
      sortAscending,
      isListening,
      hasMoreDocuments,
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
      List<DocumentModel> documents,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
      bool hasMoreDocuments,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult Function(
      String message,
      DocumentState? previousState,
      bool canRetry,
    )?
    error,
    TResult Function(
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    loadingMore,
    TResult Function(
      String operation,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    performingOperation,
    TResult Function(
      String message,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
    )?
    syncing,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(
        documents,
        filteredDocuments,
        searchQuery,
        selectedCategory,
        selectedStatus,
        selectedFileType,
        selectedUserId,
        sortBy,
        sortAscending,
        isListening,
        hasMoreDocuments,
        statistics,
        lastLoadTime,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DocumentInitial value) initial,
    required TResult Function(DocumentLoading value) loading,
    required TResult Function(DocumentLoaded value) loaded,
    required TResult Function(DocumentError value) error,
    required TResult Function(DocumentLoadingMore value) loadingMore,
    required TResult Function(DocumentPerformingOperation value)
    performingOperation,
    required TResult Function(DocumentSyncing value) syncing,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DocumentInitial value)? initial,
    TResult? Function(DocumentLoading value)? loading,
    TResult? Function(DocumentLoaded value)? loaded,
    TResult? Function(DocumentError value)? error,
    TResult? Function(DocumentLoadingMore value)? loadingMore,
    TResult? Function(DocumentPerformingOperation value)? performingOperation,
    TResult? Function(DocumentSyncing value)? syncing,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DocumentInitial value)? initial,
    TResult Function(DocumentLoading value)? loading,
    TResult Function(DocumentLoaded value)? loaded,
    TResult Function(DocumentError value)? error,
    TResult Function(DocumentLoadingMore value)? loadingMore,
    TResult Function(DocumentPerformingOperation value)? performingOperation,
    TResult Function(DocumentSyncing value)? syncing,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class DocumentLoaded implements DocumentState {
  const factory DocumentLoaded({
    required final List<DocumentModel> documents,
    required final List<DocumentModel> filteredDocuments,
    final String searchQuery,
    final String selectedCategory,
    final String selectedStatus,
    final String selectedFileType,
    final String? selectedUserId,
    final String sortBy,
    final bool sortAscending,
    final bool isListening,
    final bool hasMoreDocuments,
    final Map<String, dynamic>? statistics,
    final DateTime? lastLoadTime,
  }) = _$DocumentLoadedImpl;

  List<DocumentModel> get documents;
  List<DocumentModel> get filteredDocuments;
  String get searchQuery;
  String get selectedCategory;
  String get selectedStatus;
  String get selectedFileType;
  String? get selectedUserId;
  String get sortBy;
  bool get sortAscending;
  bool get isListening;
  bool get hasMoreDocuments;
  Map<String, dynamic>? get statistics;
  DateTime? get lastLoadTime;

  /// Create a copy of DocumentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentLoadedImplCopyWith<_$DocumentLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DocumentErrorImplCopyWith<$Res> {
  factory _$$DocumentErrorImplCopyWith(
    _$DocumentErrorImpl value,
    $Res Function(_$DocumentErrorImpl) then,
  ) = __$$DocumentErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, DocumentState? previousState, bool canRetry});

  $DocumentStateCopyWith<$Res>? get previousState;
}

/// @nodoc
class __$$DocumentErrorImplCopyWithImpl<$Res>
    extends _$DocumentStateCopyWithImpl<$Res, _$DocumentErrorImpl>
    implements _$$DocumentErrorImplCopyWith<$Res> {
  __$$DocumentErrorImplCopyWithImpl(
    _$DocumentErrorImpl _value,
    $Res Function(_$DocumentErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? previousState = freezed,
    Object? canRetry = null,
  }) {
    return _then(
      _$DocumentErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        previousState: freezed == previousState
            ? _value.previousState
            : previousState // ignore: cast_nullable_to_non_nullable
                  as DocumentState?,
        canRetry: null == canRetry
            ? _value.canRetry
            : canRetry // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }

  /// Create a copy of DocumentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DocumentStateCopyWith<$Res>? get previousState {
    if (_value.previousState == null) {
      return null;
    }

    return $DocumentStateCopyWith<$Res>(_value.previousState!, (value) {
      return _then(_value.copyWith(previousState: value));
    });
  }
}

/// @nodoc

class _$DocumentErrorImpl implements DocumentError {
  const _$DocumentErrorImpl({
    required this.message,
    this.previousState,
    this.canRetry = true,
  });

  @override
  final String message;
  @override
  final DocumentState? previousState;
  @override
  @JsonKey()
  final bool canRetry;

  @override
  String toString() {
    return 'DocumentState.error(message: $message, previousState: $previousState, canRetry: $canRetry)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.previousState, previousState) ||
                other.previousState == previousState) &&
            (identical(other.canRetry, canRetry) ||
                other.canRetry == canRetry));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, message, previousState, canRetry);

  /// Create a copy of DocumentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentErrorImplCopyWith<_$DocumentErrorImpl> get copyWith =>
      __$$DocumentErrorImplCopyWithImpl<_$DocumentErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) loading,
    required TResult Function(
      List<DocumentModel> documents,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
      bool hasMoreDocuments,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )
    loaded,
    required TResult Function(
      String message,
      DocumentState? previousState,
      bool canRetry,
    )
    error,
    required TResult Function(
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )
    loadingMore,
    required TResult Function(
      String operation,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )
    performingOperation,
    required TResult Function(
      String message,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
    )
    syncing,
  }) {
    return error(message, previousState, canRetry);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? loading,
    TResult? Function(
      List<DocumentModel> documents,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
      bool hasMoreDocuments,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult? Function(
      String message,
      DocumentState? previousState,
      bool canRetry,
    )?
    error,
    TResult? Function(
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    loadingMore,
    TResult? Function(
      String operation,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    performingOperation,
    TResult? Function(
      String message,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
    )?
    syncing,
  }) {
    return error?.call(message, previousState, canRetry);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? loading,
    TResult Function(
      List<DocumentModel> documents,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
      bool hasMoreDocuments,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult Function(
      String message,
      DocumentState? previousState,
      bool canRetry,
    )?
    error,
    TResult Function(
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    loadingMore,
    TResult Function(
      String operation,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    performingOperation,
    TResult Function(
      String message,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
    )?
    syncing,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message, previousState, canRetry);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DocumentInitial value) initial,
    required TResult Function(DocumentLoading value) loading,
    required TResult Function(DocumentLoaded value) loaded,
    required TResult Function(DocumentError value) error,
    required TResult Function(DocumentLoadingMore value) loadingMore,
    required TResult Function(DocumentPerformingOperation value)
    performingOperation,
    required TResult Function(DocumentSyncing value) syncing,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DocumentInitial value)? initial,
    TResult? Function(DocumentLoading value)? loading,
    TResult? Function(DocumentLoaded value)? loaded,
    TResult? Function(DocumentError value)? error,
    TResult? Function(DocumentLoadingMore value)? loadingMore,
    TResult? Function(DocumentPerformingOperation value)? performingOperation,
    TResult? Function(DocumentSyncing value)? syncing,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DocumentInitial value)? initial,
    TResult Function(DocumentLoading value)? loading,
    TResult Function(DocumentLoaded value)? loaded,
    TResult Function(DocumentError value)? error,
    TResult Function(DocumentLoadingMore value)? loadingMore,
    TResult Function(DocumentPerformingOperation value)? performingOperation,
    TResult Function(DocumentSyncing value)? syncing,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class DocumentError implements DocumentState {
  const factory DocumentError({
    required final String message,
    final DocumentState? previousState,
    final bool canRetry,
  }) = _$DocumentErrorImpl;

  String get message;
  DocumentState? get previousState;
  bool get canRetry;

  /// Create a copy of DocumentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentErrorImplCopyWith<_$DocumentErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DocumentLoadingMoreImplCopyWith<$Res> {
  factory _$$DocumentLoadingMoreImplCopyWith(
    _$DocumentLoadingMoreImpl value,
    $Res Function(_$DocumentLoadingMoreImpl) then,
  ) = __$$DocumentLoadingMoreImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<DocumentModel> currentDocuments,
    List<DocumentModel> filteredDocuments,
    String searchQuery,
    String selectedCategory,
    String selectedStatus,
    String selectedFileType,
    String? selectedUserId,
    String sortBy,
    bool sortAscending,
    bool isListening,
  });
}

/// @nodoc
class __$$DocumentLoadingMoreImplCopyWithImpl<$Res>
    extends _$DocumentStateCopyWithImpl<$Res, _$DocumentLoadingMoreImpl>
    implements _$$DocumentLoadingMoreImplCopyWith<$Res> {
  __$$DocumentLoadingMoreImplCopyWithImpl(
    _$DocumentLoadingMoreImpl _value,
    $Res Function(_$DocumentLoadingMoreImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentDocuments = null,
    Object? filteredDocuments = null,
    Object? searchQuery = null,
    Object? selectedCategory = null,
    Object? selectedStatus = null,
    Object? selectedFileType = null,
    Object? selectedUserId = freezed,
    Object? sortBy = null,
    Object? sortAscending = null,
    Object? isListening = null,
  }) {
    return _then(
      _$DocumentLoadingMoreImpl(
        currentDocuments: null == currentDocuments
            ? _value._currentDocuments
            : currentDocuments // ignore: cast_nullable_to_non_nullable
                  as List<DocumentModel>,
        filteredDocuments: null == filteredDocuments
            ? _value._filteredDocuments
            : filteredDocuments // ignore: cast_nullable_to_non_nullable
                  as List<DocumentModel>,
        searchQuery: null == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedCategory: null == selectedCategory
            ? _value.selectedCategory
            : selectedCategory // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedStatus: null == selectedStatus
            ? _value.selectedStatus
            : selectedStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedFileType: null == selectedFileType
            ? _value.selectedFileType
            : selectedFileType // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedUserId: freezed == selectedUserId
            ? _value.selectedUserId
            : selectedUserId // ignore: cast_nullable_to_non_nullable
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
      ),
    );
  }
}

/// @nodoc

class _$DocumentLoadingMoreImpl implements DocumentLoadingMore {
  const _$DocumentLoadingMoreImpl({
    required final List<DocumentModel> currentDocuments,
    required final List<DocumentModel> filteredDocuments,
    this.searchQuery = '',
    this.selectedCategory = 'all',
    this.selectedStatus = 'all',
    this.selectedFileType = 'all',
    this.selectedUserId,
    this.sortBy = 'uploadedAt',
    this.sortAscending = false,
    this.isListening = false,
  }) : _currentDocuments = currentDocuments,
       _filteredDocuments = filteredDocuments;

  final List<DocumentModel> _currentDocuments;
  @override
  List<DocumentModel> get currentDocuments {
    if (_currentDocuments is EqualUnmodifiableListView)
      return _currentDocuments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currentDocuments);
  }

  final List<DocumentModel> _filteredDocuments;
  @override
  List<DocumentModel> get filteredDocuments {
    if (_filteredDocuments is EqualUnmodifiableListView)
      return _filteredDocuments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredDocuments);
  }

  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final String selectedCategory;
  @override
  @JsonKey()
  final String selectedStatus;
  @override
  @JsonKey()
  final String selectedFileType;
  @override
  final String? selectedUserId;
  @override
  @JsonKey()
  final String sortBy;
  @override
  @JsonKey()
  final bool sortAscending;
  @override
  @JsonKey()
  final bool isListening;

  @override
  String toString() {
    return 'DocumentState.loadingMore(currentDocuments: $currentDocuments, filteredDocuments: $filteredDocuments, searchQuery: $searchQuery, selectedCategory: $selectedCategory, selectedStatus: $selectedStatus, selectedFileType: $selectedFileType, selectedUserId: $selectedUserId, sortBy: $sortBy, sortAscending: $sortAscending, isListening: $isListening)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentLoadingMoreImpl &&
            const DeepCollectionEquality().equals(
              other._currentDocuments,
              _currentDocuments,
            ) &&
            const DeepCollectionEquality().equals(
              other._filteredDocuments,
              _filteredDocuments,
            ) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.selectedStatus, selectedStatus) ||
                other.selectedStatus == selectedStatus) &&
            (identical(other.selectedFileType, selectedFileType) ||
                other.selectedFileType == selectedFileType) &&
            (identical(other.selectedUserId, selectedUserId) ||
                other.selectedUserId == selectedUserId) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.sortAscending, sortAscending) ||
                other.sortAscending == sortAscending) &&
            (identical(other.isListening, isListening) ||
                other.isListening == isListening));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_currentDocuments),
    const DeepCollectionEquality().hash(_filteredDocuments),
    searchQuery,
    selectedCategory,
    selectedStatus,
    selectedFileType,
    selectedUserId,
    sortBy,
    sortAscending,
    isListening,
  );

  /// Create a copy of DocumentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentLoadingMoreImplCopyWith<_$DocumentLoadingMoreImpl> get copyWith =>
      __$$DocumentLoadingMoreImplCopyWithImpl<_$DocumentLoadingMoreImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) loading,
    required TResult Function(
      List<DocumentModel> documents,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
      bool hasMoreDocuments,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )
    loaded,
    required TResult Function(
      String message,
      DocumentState? previousState,
      bool canRetry,
    )
    error,
    required TResult Function(
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )
    loadingMore,
    required TResult Function(
      String operation,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )
    performingOperation,
    required TResult Function(
      String message,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
    )
    syncing,
  }) {
    return loadingMore(
      currentDocuments,
      filteredDocuments,
      searchQuery,
      selectedCategory,
      selectedStatus,
      selectedFileType,
      selectedUserId,
      sortBy,
      sortAscending,
      isListening,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? loading,
    TResult? Function(
      List<DocumentModel> documents,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
      bool hasMoreDocuments,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult? Function(
      String message,
      DocumentState? previousState,
      bool canRetry,
    )?
    error,
    TResult? Function(
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    loadingMore,
    TResult? Function(
      String operation,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    performingOperation,
    TResult? Function(
      String message,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
    )?
    syncing,
  }) {
    return loadingMore?.call(
      currentDocuments,
      filteredDocuments,
      searchQuery,
      selectedCategory,
      selectedStatus,
      selectedFileType,
      selectedUserId,
      sortBy,
      sortAscending,
      isListening,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? loading,
    TResult Function(
      List<DocumentModel> documents,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
      bool hasMoreDocuments,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult Function(
      String message,
      DocumentState? previousState,
      bool canRetry,
    )?
    error,
    TResult Function(
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    loadingMore,
    TResult Function(
      String operation,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    performingOperation,
    TResult Function(
      String message,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
    )?
    syncing,
    required TResult orElse(),
  }) {
    if (loadingMore != null) {
      return loadingMore(
        currentDocuments,
        filteredDocuments,
        searchQuery,
        selectedCategory,
        selectedStatus,
        selectedFileType,
        selectedUserId,
        sortBy,
        sortAscending,
        isListening,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DocumentInitial value) initial,
    required TResult Function(DocumentLoading value) loading,
    required TResult Function(DocumentLoaded value) loaded,
    required TResult Function(DocumentError value) error,
    required TResult Function(DocumentLoadingMore value) loadingMore,
    required TResult Function(DocumentPerformingOperation value)
    performingOperation,
    required TResult Function(DocumentSyncing value) syncing,
  }) {
    return loadingMore(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DocumentInitial value)? initial,
    TResult? Function(DocumentLoading value)? loading,
    TResult? Function(DocumentLoaded value)? loaded,
    TResult? Function(DocumentError value)? error,
    TResult? Function(DocumentLoadingMore value)? loadingMore,
    TResult? Function(DocumentPerformingOperation value)? performingOperation,
    TResult? Function(DocumentSyncing value)? syncing,
  }) {
    return loadingMore?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DocumentInitial value)? initial,
    TResult Function(DocumentLoading value)? loading,
    TResult Function(DocumentLoaded value)? loaded,
    TResult Function(DocumentError value)? error,
    TResult Function(DocumentLoadingMore value)? loadingMore,
    TResult Function(DocumentPerformingOperation value)? performingOperation,
    TResult Function(DocumentSyncing value)? syncing,
    required TResult orElse(),
  }) {
    if (loadingMore != null) {
      return loadingMore(this);
    }
    return orElse();
  }
}

abstract class DocumentLoadingMore implements DocumentState {
  const factory DocumentLoadingMore({
    required final List<DocumentModel> currentDocuments,
    required final List<DocumentModel> filteredDocuments,
    final String searchQuery,
    final String selectedCategory,
    final String selectedStatus,
    final String selectedFileType,
    final String? selectedUserId,
    final String sortBy,
    final bool sortAscending,
    final bool isListening,
  }) = _$DocumentLoadingMoreImpl;

  List<DocumentModel> get currentDocuments;
  List<DocumentModel> get filteredDocuments;
  String get searchQuery;
  String get selectedCategory;
  String get selectedStatus;
  String get selectedFileType;
  String? get selectedUserId;
  String get sortBy;
  bool get sortAscending;
  bool get isListening;

  /// Create a copy of DocumentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentLoadingMoreImplCopyWith<_$DocumentLoadingMoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DocumentPerformingOperationImplCopyWith<$Res> {
  factory _$$DocumentPerformingOperationImplCopyWith(
    _$DocumentPerformingOperationImpl value,
    $Res Function(_$DocumentPerformingOperationImpl) then,
  ) = __$$DocumentPerformingOperationImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String operation,
    List<DocumentModel> currentDocuments,
    List<DocumentModel> filteredDocuments,
    String searchQuery,
    String selectedCategory,
    String selectedStatus,
    String selectedFileType,
    String? selectedUserId,
    String sortBy,
    bool sortAscending,
    bool isListening,
  });
}

/// @nodoc
class __$$DocumentPerformingOperationImplCopyWithImpl<$Res>
    extends _$DocumentStateCopyWithImpl<$Res, _$DocumentPerformingOperationImpl>
    implements _$$DocumentPerformingOperationImplCopyWith<$Res> {
  __$$DocumentPerformingOperationImplCopyWithImpl(
    _$DocumentPerformingOperationImpl _value,
    $Res Function(_$DocumentPerformingOperationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? operation = null,
    Object? currentDocuments = null,
    Object? filteredDocuments = null,
    Object? searchQuery = null,
    Object? selectedCategory = null,
    Object? selectedStatus = null,
    Object? selectedFileType = null,
    Object? selectedUserId = freezed,
    Object? sortBy = null,
    Object? sortAscending = null,
    Object? isListening = null,
  }) {
    return _then(
      _$DocumentPerformingOperationImpl(
        operation: null == operation
            ? _value.operation
            : operation // ignore: cast_nullable_to_non_nullable
                  as String,
        currentDocuments: null == currentDocuments
            ? _value._currentDocuments
            : currentDocuments // ignore: cast_nullable_to_non_nullable
                  as List<DocumentModel>,
        filteredDocuments: null == filteredDocuments
            ? _value._filteredDocuments
            : filteredDocuments // ignore: cast_nullable_to_non_nullable
                  as List<DocumentModel>,
        searchQuery: null == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedCategory: null == selectedCategory
            ? _value.selectedCategory
            : selectedCategory // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedStatus: null == selectedStatus
            ? _value.selectedStatus
            : selectedStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedFileType: null == selectedFileType
            ? _value.selectedFileType
            : selectedFileType // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedUserId: freezed == selectedUserId
            ? _value.selectedUserId
            : selectedUserId // ignore: cast_nullable_to_non_nullable
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
      ),
    );
  }
}

/// @nodoc

class _$DocumentPerformingOperationImpl implements DocumentPerformingOperation {
  const _$DocumentPerformingOperationImpl({
    required this.operation,
    required final List<DocumentModel> currentDocuments,
    required final List<DocumentModel> filteredDocuments,
    this.searchQuery = '',
    this.selectedCategory = 'all',
    this.selectedStatus = 'all',
    this.selectedFileType = 'all',
    this.selectedUserId,
    this.sortBy = 'uploadedAt',
    this.sortAscending = false,
    this.isListening = false,
  }) : _currentDocuments = currentDocuments,
       _filteredDocuments = filteredDocuments;

  @override
  final String operation;
  final List<DocumentModel> _currentDocuments;
  @override
  List<DocumentModel> get currentDocuments {
    if (_currentDocuments is EqualUnmodifiableListView)
      return _currentDocuments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currentDocuments);
  }

  final List<DocumentModel> _filteredDocuments;
  @override
  List<DocumentModel> get filteredDocuments {
    if (_filteredDocuments is EqualUnmodifiableListView)
      return _filteredDocuments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredDocuments);
  }

  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final String selectedCategory;
  @override
  @JsonKey()
  final String selectedStatus;
  @override
  @JsonKey()
  final String selectedFileType;
  @override
  final String? selectedUserId;
  @override
  @JsonKey()
  final String sortBy;
  @override
  @JsonKey()
  final bool sortAscending;
  @override
  @JsonKey()
  final bool isListening;

  @override
  String toString() {
    return 'DocumentState.performingOperation(operation: $operation, currentDocuments: $currentDocuments, filteredDocuments: $filteredDocuments, searchQuery: $searchQuery, selectedCategory: $selectedCategory, selectedStatus: $selectedStatus, selectedFileType: $selectedFileType, selectedUserId: $selectedUserId, sortBy: $sortBy, sortAscending: $sortAscending, isListening: $isListening)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentPerformingOperationImpl &&
            (identical(other.operation, operation) ||
                other.operation == operation) &&
            const DeepCollectionEquality().equals(
              other._currentDocuments,
              _currentDocuments,
            ) &&
            const DeepCollectionEquality().equals(
              other._filteredDocuments,
              _filteredDocuments,
            ) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.selectedStatus, selectedStatus) ||
                other.selectedStatus == selectedStatus) &&
            (identical(other.selectedFileType, selectedFileType) ||
                other.selectedFileType == selectedFileType) &&
            (identical(other.selectedUserId, selectedUserId) ||
                other.selectedUserId == selectedUserId) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.sortAscending, sortAscending) ||
                other.sortAscending == sortAscending) &&
            (identical(other.isListening, isListening) ||
                other.isListening == isListening));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    operation,
    const DeepCollectionEquality().hash(_currentDocuments),
    const DeepCollectionEquality().hash(_filteredDocuments),
    searchQuery,
    selectedCategory,
    selectedStatus,
    selectedFileType,
    selectedUserId,
    sortBy,
    sortAscending,
    isListening,
  );

  /// Create a copy of DocumentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentPerformingOperationImplCopyWith<_$DocumentPerformingOperationImpl>
  get copyWith =>
      __$$DocumentPerformingOperationImplCopyWithImpl<
        _$DocumentPerformingOperationImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) loading,
    required TResult Function(
      List<DocumentModel> documents,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
      bool hasMoreDocuments,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )
    loaded,
    required TResult Function(
      String message,
      DocumentState? previousState,
      bool canRetry,
    )
    error,
    required TResult Function(
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )
    loadingMore,
    required TResult Function(
      String operation,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )
    performingOperation,
    required TResult Function(
      String message,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
    )
    syncing,
  }) {
    return performingOperation(
      operation,
      currentDocuments,
      filteredDocuments,
      searchQuery,
      selectedCategory,
      selectedStatus,
      selectedFileType,
      selectedUserId,
      sortBy,
      sortAscending,
      isListening,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? loading,
    TResult? Function(
      List<DocumentModel> documents,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
      bool hasMoreDocuments,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult? Function(
      String message,
      DocumentState? previousState,
      bool canRetry,
    )?
    error,
    TResult? Function(
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    loadingMore,
    TResult? Function(
      String operation,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    performingOperation,
    TResult? Function(
      String message,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
    )?
    syncing,
  }) {
    return performingOperation?.call(
      operation,
      currentDocuments,
      filteredDocuments,
      searchQuery,
      selectedCategory,
      selectedStatus,
      selectedFileType,
      selectedUserId,
      sortBy,
      sortAscending,
      isListening,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? loading,
    TResult Function(
      List<DocumentModel> documents,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
      bool hasMoreDocuments,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult Function(
      String message,
      DocumentState? previousState,
      bool canRetry,
    )?
    error,
    TResult Function(
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    loadingMore,
    TResult Function(
      String operation,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    performingOperation,
    TResult Function(
      String message,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
    )?
    syncing,
    required TResult orElse(),
  }) {
    if (performingOperation != null) {
      return performingOperation(
        operation,
        currentDocuments,
        filteredDocuments,
        searchQuery,
        selectedCategory,
        selectedStatus,
        selectedFileType,
        selectedUserId,
        sortBy,
        sortAscending,
        isListening,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DocumentInitial value) initial,
    required TResult Function(DocumentLoading value) loading,
    required TResult Function(DocumentLoaded value) loaded,
    required TResult Function(DocumentError value) error,
    required TResult Function(DocumentLoadingMore value) loadingMore,
    required TResult Function(DocumentPerformingOperation value)
    performingOperation,
    required TResult Function(DocumentSyncing value) syncing,
  }) {
    return performingOperation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DocumentInitial value)? initial,
    TResult? Function(DocumentLoading value)? loading,
    TResult? Function(DocumentLoaded value)? loaded,
    TResult? Function(DocumentError value)? error,
    TResult? Function(DocumentLoadingMore value)? loadingMore,
    TResult? Function(DocumentPerformingOperation value)? performingOperation,
    TResult? Function(DocumentSyncing value)? syncing,
  }) {
    return performingOperation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DocumentInitial value)? initial,
    TResult Function(DocumentLoading value)? loading,
    TResult Function(DocumentLoaded value)? loaded,
    TResult Function(DocumentError value)? error,
    TResult Function(DocumentLoadingMore value)? loadingMore,
    TResult Function(DocumentPerformingOperation value)? performingOperation,
    TResult Function(DocumentSyncing value)? syncing,
    required TResult orElse(),
  }) {
    if (performingOperation != null) {
      return performingOperation(this);
    }
    return orElse();
  }
}

abstract class DocumentPerformingOperation implements DocumentState {
  const factory DocumentPerformingOperation({
    required final String operation,
    required final List<DocumentModel> currentDocuments,
    required final List<DocumentModel> filteredDocuments,
    final String searchQuery,
    final String selectedCategory,
    final String selectedStatus,
    final String selectedFileType,
    final String? selectedUserId,
    final String sortBy,
    final bool sortAscending,
    final bool isListening,
  }) = _$DocumentPerformingOperationImpl;

  String get operation;
  List<DocumentModel> get currentDocuments;
  List<DocumentModel> get filteredDocuments;
  String get searchQuery;
  String get selectedCategory;
  String get selectedStatus;
  String get selectedFileType;
  String? get selectedUserId;
  String get sortBy;
  bool get sortAscending;
  bool get isListening;

  /// Create a copy of DocumentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentPerformingOperationImplCopyWith<_$DocumentPerformingOperationImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DocumentSyncingImplCopyWith<$Res> {
  factory _$$DocumentSyncingImplCopyWith(
    _$DocumentSyncingImpl value,
    $Res Function(_$DocumentSyncingImpl) then,
  ) = __$$DocumentSyncingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String message,
    List<DocumentModel> currentDocuments,
    List<DocumentModel> filteredDocuments,
  });
}

/// @nodoc
class __$$DocumentSyncingImplCopyWithImpl<$Res>
    extends _$DocumentStateCopyWithImpl<$Res, _$DocumentSyncingImpl>
    implements _$$DocumentSyncingImplCopyWith<$Res> {
  __$$DocumentSyncingImplCopyWithImpl(
    _$DocumentSyncingImpl _value,
    $Res Function(_$DocumentSyncingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? currentDocuments = null,
    Object? filteredDocuments = null,
  }) {
    return _then(
      _$DocumentSyncingImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        currentDocuments: null == currentDocuments
            ? _value._currentDocuments
            : currentDocuments // ignore: cast_nullable_to_non_nullable
                  as List<DocumentModel>,
        filteredDocuments: null == filteredDocuments
            ? _value._filteredDocuments
            : filteredDocuments // ignore: cast_nullable_to_non_nullable
                  as List<DocumentModel>,
      ),
    );
  }
}

/// @nodoc

class _$DocumentSyncingImpl implements DocumentSyncing {
  const _$DocumentSyncingImpl({
    required this.message,
    required final List<DocumentModel> currentDocuments,
    required final List<DocumentModel> filteredDocuments,
  }) : _currentDocuments = currentDocuments,
       _filteredDocuments = filteredDocuments;

  @override
  final String message;
  final List<DocumentModel> _currentDocuments;
  @override
  List<DocumentModel> get currentDocuments {
    if (_currentDocuments is EqualUnmodifiableListView)
      return _currentDocuments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currentDocuments);
  }

  final List<DocumentModel> _filteredDocuments;
  @override
  List<DocumentModel> get filteredDocuments {
    if (_filteredDocuments is EqualUnmodifiableListView)
      return _filteredDocuments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredDocuments);
  }

  @override
  String toString() {
    return 'DocumentState.syncing(message: $message, currentDocuments: $currentDocuments, filteredDocuments: $filteredDocuments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentSyncingImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(
              other._currentDocuments,
              _currentDocuments,
            ) &&
            const DeepCollectionEquality().equals(
              other._filteredDocuments,
              _filteredDocuments,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(_currentDocuments),
    const DeepCollectionEquality().hash(_filteredDocuments),
  );

  /// Create a copy of DocumentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentSyncingImplCopyWith<_$DocumentSyncingImpl> get copyWith =>
      __$$DocumentSyncingImplCopyWithImpl<_$DocumentSyncingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) loading,
    required TResult Function(
      List<DocumentModel> documents,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
      bool hasMoreDocuments,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )
    loaded,
    required TResult Function(
      String message,
      DocumentState? previousState,
      bool canRetry,
    )
    error,
    required TResult Function(
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )
    loadingMore,
    required TResult Function(
      String operation,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )
    performingOperation,
    required TResult Function(
      String message,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
    )
    syncing,
  }) {
    return syncing(message, currentDocuments, filteredDocuments);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? loading,
    TResult? Function(
      List<DocumentModel> documents,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
      bool hasMoreDocuments,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult? Function(
      String message,
      DocumentState? previousState,
      bool canRetry,
    )?
    error,
    TResult? Function(
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    loadingMore,
    TResult? Function(
      String operation,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    performingOperation,
    TResult? Function(
      String message,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
    )?
    syncing,
  }) {
    return syncing?.call(message, currentDocuments, filteredDocuments);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? loading,
    TResult Function(
      List<DocumentModel> documents,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
      bool hasMoreDocuments,
      Map<String, dynamic>? statistics,
      DateTime? lastLoadTime,
    )?
    loaded,
    TResult Function(
      String message,
      DocumentState? previousState,
      bool canRetry,
    )?
    error,
    TResult Function(
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    loadingMore,
    TResult Function(
      String operation,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
      String searchQuery,
      String selectedCategory,
      String selectedStatus,
      String selectedFileType,
      String? selectedUserId,
      String sortBy,
      bool sortAscending,
      bool isListening,
    )?
    performingOperation,
    TResult Function(
      String message,
      List<DocumentModel> currentDocuments,
      List<DocumentModel> filteredDocuments,
    )?
    syncing,
    required TResult orElse(),
  }) {
    if (syncing != null) {
      return syncing(message, currentDocuments, filteredDocuments);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DocumentInitial value) initial,
    required TResult Function(DocumentLoading value) loading,
    required TResult Function(DocumentLoaded value) loaded,
    required TResult Function(DocumentError value) error,
    required TResult Function(DocumentLoadingMore value) loadingMore,
    required TResult Function(DocumentPerformingOperation value)
    performingOperation,
    required TResult Function(DocumentSyncing value) syncing,
  }) {
    return syncing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DocumentInitial value)? initial,
    TResult? Function(DocumentLoading value)? loading,
    TResult? Function(DocumentLoaded value)? loaded,
    TResult? Function(DocumentError value)? error,
    TResult? Function(DocumentLoadingMore value)? loadingMore,
    TResult? Function(DocumentPerformingOperation value)? performingOperation,
    TResult? Function(DocumentSyncing value)? syncing,
  }) {
    return syncing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DocumentInitial value)? initial,
    TResult Function(DocumentLoading value)? loading,
    TResult Function(DocumentLoaded value)? loaded,
    TResult Function(DocumentError value)? error,
    TResult Function(DocumentLoadingMore value)? loadingMore,
    TResult Function(DocumentPerformingOperation value)? performingOperation,
    TResult Function(DocumentSyncing value)? syncing,
    required TResult orElse(),
  }) {
    if (syncing != null) {
      return syncing(this);
    }
    return orElse();
  }
}

abstract class DocumentSyncing implements DocumentState {
  const factory DocumentSyncing({
    required final String message,
    required final List<DocumentModel> currentDocuments,
    required final List<DocumentModel> filteredDocuments,
  }) = _$DocumentSyncingImpl;

  String get message;
  List<DocumentModel> get currentDocuments;
  List<DocumentModel> get filteredDocuments;

  /// Create a copy of DocumentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentSyncingImplCopyWith<_$DocumentSyncingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
