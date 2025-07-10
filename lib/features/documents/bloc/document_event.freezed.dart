// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DocumentEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      bool forceRefresh,
      int? limit,
      DocumentModel? startAfter,
    )
    loadDocuments,
    required TResult Function(String query, int? limit) searchDocuments,
    required TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )
    filterDocuments,
    required TResult Function(String sortBy, bool ascending) sortDocuments,
    required TResult Function(String documentId, String userId) deleteDocument,
    required TResult Function(String documentId, String userId)
    permanentlyDeleteDocument,
    required TResult Function(String documentId, String userId) restoreDocument,
    required TResult Function(DocumentModel document) updateDocument,
    required TResult Function(bool forceRefresh) refreshDocuments,
    required TResult Function(int? limit) loadRecentDocuments,
    required TResult Function(int? limit) loadDeletedDocuments,
    required TResult Function(String category, int? limit)
    loadDocumentsByCategory,
    required TResult Function(String userId, int? limit) loadDocumentsByUser,
    required TResult Function() loadDocumentStatistics,
    required TResult Function() syncDocuments,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<DocumentModel> documents) documentsUpdated,
    required TResult Function(int? limit) loadMoreDocuments,
    required TResult Function() resetState,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult? Function(String query, int? limit)? searchDocuments,
    TResult? Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult? Function(String sortBy, bool ascending)? sortDocuments,
    TResult? Function(String documentId, String userId)? deleteDocument,
    TResult? Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult? Function(String documentId, String userId)? restoreDocument,
    TResult? Function(DocumentModel document)? updateDocument,
    TResult? Function(bool forceRefresh)? refreshDocuments,
    TResult? Function(int? limit)? loadRecentDocuments,
    TResult? Function(int? limit)? loadDeletedDocuments,
    TResult? Function(String category, int? limit)? loadDocumentsByCategory,
    TResult? Function(String userId, int? limit)? loadDocumentsByUser,
    TResult? Function()? loadDocumentStatistics,
    TResult? Function()? syncDocuments,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<DocumentModel> documents)? documentsUpdated,
    TResult? Function(int? limit)? loadMoreDocuments,
    TResult? Function()? resetState,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult Function(String query, int? limit)? searchDocuments,
    TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult Function(String sortBy, bool ascending)? sortDocuments,
    TResult Function(String documentId, String userId)? deleteDocument,
    TResult Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult Function(String documentId, String userId)? restoreDocument,
    TResult Function(DocumentModel document)? updateDocument,
    TResult Function(bool forceRefresh)? refreshDocuments,
    TResult Function(int? limit)? loadRecentDocuments,
    TResult Function(int? limit)? loadDeletedDocuments,
    TResult Function(String category, int? limit)? loadDocumentsByCategory,
    TResult Function(String userId, int? limit)? loadDocumentsByUser,
    TResult Function()? loadDocumentStatistics,
    TResult Function()? syncDocuments,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<DocumentModel> documents)? documentsUpdated,
    TResult Function(int? limit)? loadMoreDocuments,
    TResult Function()? resetState,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadDocuments value) loadDocuments,
    required TResult Function(SearchDocuments value) searchDocuments,
    required TResult Function(FilterDocuments value) filterDocuments,
    required TResult Function(SortDocuments value) sortDocuments,
    required TResult Function(DeleteDocument value) deleteDocument,
    required TResult Function(PermanentlyDeleteDocument value)
    permanentlyDeleteDocument,
    required TResult Function(RestoreDocument value) restoreDocument,
    required TResult Function(UpdateDocument value) updateDocument,
    required TResult Function(RefreshDocuments value) refreshDocuments,
    required TResult Function(LoadRecentDocuments value) loadRecentDocuments,
    required TResult Function(LoadDeletedDocuments value) loadDeletedDocuments,
    required TResult Function(LoadDocumentsByCategory value)
    loadDocumentsByCategory,
    required TResult Function(LoadDocumentsByUser value) loadDocumentsByUser,
    required TResult Function(LoadDocumentStatistics value)
    loadDocumentStatistics,
    required TResult Function(SyncDocuments value) syncDocuments,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(DocumentsUpdated value) documentsUpdated,
    required TResult Function(LoadMoreDocuments value) loadMoreDocuments,
    required TResult Function(ResetState value) resetState,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadDocuments value)? loadDocuments,
    TResult? Function(SearchDocuments value)? searchDocuments,
    TResult? Function(FilterDocuments value)? filterDocuments,
    TResult? Function(SortDocuments value)? sortDocuments,
    TResult? Function(DeleteDocument value)? deleteDocument,
    TResult? Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult? Function(RestoreDocument value)? restoreDocument,
    TResult? Function(UpdateDocument value)? updateDocument,
    TResult? Function(RefreshDocuments value)? refreshDocuments,
    TResult? Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult? Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult? Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult? Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult? Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult? Function(SyncDocuments value)? syncDocuments,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(DocumentsUpdated value)? documentsUpdated,
    TResult? Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult? Function(ResetState value)? resetState,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadDocuments value)? loadDocuments,
    TResult Function(SearchDocuments value)? searchDocuments,
    TResult Function(FilterDocuments value)? filterDocuments,
    TResult Function(SortDocuments value)? sortDocuments,
    TResult Function(DeleteDocument value)? deleteDocument,
    TResult Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult Function(RestoreDocument value)? restoreDocument,
    TResult Function(UpdateDocument value)? updateDocument,
    TResult Function(RefreshDocuments value)? refreshDocuments,
    TResult Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult Function(SyncDocuments value)? syncDocuments,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(DocumentsUpdated value)? documentsUpdated,
    TResult Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult Function(ResetState value)? resetState,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentEventCopyWith<$Res> {
  factory $DocumentEventCopyWith(
    DocumentEvent value,
    $Res Function(DocumentEvent) then,
  ) = _$DocumentEventCopyWithImpl<$Res, DocumentEvent>;
}

/// @nodoc
class _$DocumentEventCopyWithImpl<$Res, $Val extends DocumentEvent>
    implements $DocumentEventCopyWith<$Res> {
  _$DocumentEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadDocumentsImplCopyWith<$Res> {
  factory _$$LoadDocumentsImplCopyWith(
    _$LoadDocumentsImpl value,
    $Res Function(_$LoadDocumentsImpl) then,
  ) = __$$LoadDocumentsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool forceRefresh, int? limit, DocumentModel? startAfter});
}

/// @nodoc
class __$$LoadDocumentsImplCopyWithImpl<$Res>
    extends _$DocumentEventCopyWithImpl<$Res, _$LoadDocumentsImpl>
    implements _$$LoadDocumentsImplCopyWith<$Res> {
  __$$LoadDocumentsImplCopyWithImpl(
    _$LoadDocumentsImpl _value,
    $Res Function(_$LoadDocumentsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? forceRefresh = null,
    Object? limit = freezed,
    Object? startAfter = freezed,
  }) {
    return _then(
      _$LoadDocumentsImpl(
        forceRefresh: null == forceRefresh
            ? _value.forceRefresh
            : forceRefresh // ignore: cast_nullable_to_non_nullable
                  as bool,
        limit: freezed == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
        startAfter: freezed == startAfter
            ? _value.startAfter
            : startAfter // ignore: cast_nullable_to_non_nullable
                  as DocumentModel?,
      ),
    );
  }
}

/// @nodoc

class _$LoadDocumentsImpl implements LoadDocuments {
  const _$LoadDocumentsImpl({
    this.forceRefresh = false,
    this.limit,
    this.startAfter,
  });

  @override
  @JsonKey()
  final bool forceRefresh;
  @override
  final int? limit;
  @override
  final DocumentModel? startAfter;

  @override
  String toString() {
    return 'DocumentEvent.loadDocuments(forceRefresh: $forceRefresh, limit: $limit, startAfter: $startAfter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadDocumentsImpl &&
            (identical(other.forceRefresh, forceRefresh) ||
                other.forceRefresh == forceRefresh) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.startAfter, startAfter) ||
                other.startAfter == startAfter));
  }

  @override
  int get hashCode => Object.hash(runtimeType, forceRefresh, limit, startAfter);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadDocumentsImplCopyWith<_$LoadDocumentsImpl> get copyWith =>
      __$$LoadDocumentsImplCopyWithImpl<_$LoadDocumentsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      bool forceRefresh,
      int? limit,
      DocumentModel? startAfter,
    )
    loadDocuments,
    required TResult Function(String query, int? limit) searchDocuments,
    required TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )
    filterDocuments,
    required TResult Function(String sortBy, bool ascending) sortDocuments,
    required TResult Function(String documentId, String userId) deleteDocument,
    required TResult Function(String documentId, String userId)
    permanentlyDeleteDocument,
    required TResult Function(String documentId, String userId) restoreDocument,
    required TResult Function(DocumentModel document) updateDocument,
    required TResult Function(bool forceRefresh) refreshDocuments,
    required TResult Function(int? limit) loadRecentDocuments,
    required TResult Function(int? limit) loadDeletedDocuments,
    required TResult Function(String category, int? limit)
    loadDocumentsByCategory,
    required TResult Function(String userId, int? limit) loadDocumentsByUser,
    required TResult Function() loadDocumentStatistics,
    required TResult Function() syncDocuments,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<DocumentModel> documents) documentsUpdated,
    required TResult Function(int? limit) loadMoreDocuments,
    required TResult Function() resetState,
  }) {
    return loadDocuments(forceRefresh, limit, startAfter);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult? Function(String query, int? limit)? searchDocuments,
    TResult? Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult? Function(String sortBy, bool ascending)? sortDocuments,
    TResult? Function(String documentId, String userId)? deleteDocument,
    TResult? Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult? Function(String documentId, String userId)? restoreDocument,
    TResult? Function(DocumentModel document)? updateDocument,
    TResult? Function(bool forceRefresh)? refreshDocuments,
    TResult? Function(int? limit)? loadRecentDocuments,
    TResult? Function(int? limit)? loadDeletedDocuments,
    TResult? Function(String category, int? limit)? loadDocumentsByCategory,
    TResult? Function(String userId, int? limit)? loadDocumentsByUser,
    TResult? Function()? loadDocumentStatistics,
    TResult? Function()? syncDocuments,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<DocumentModel> documents)? documentsUpdated,
    TResult? Function(int? limit)? loadMoreDocuments,
    TResult? Function()? resetState,
  }) {
    return loadDocuments?.call(forceRefresh, limit, startAfter);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult Function(String query, int? limit)? searchDocuments,
    TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult Function(String sortBy, bool ascending)? sortDocuments,
    TResult Function(String documentId, String userId)? deleteDocument,
    TResult Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult Function(String documentId, String userId)? restoreDocument,
    TResult Function(DocumentModel document)? updateDocument,
    TResult Function(bool forceRefresh)? refreshDocuments,
    TResult Function(int? limit)? loadRecentDocuments,
    TResult Function(int? limit)? loadDeletedDocuments,
    TResult Function(String category, int? limit)? loadDocumentsByCategory,
    TResult Function(String userId, int? limit)? loadDocumentsByUser,
    TResult Function()? loadDocumentStatistics,
    TResult Function()? syncDocuments,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<DocumentModel> documents)? documentsUpdated,
    TResult Function(int? limit)? loadMoreDocuments,
    TResult Function()? resetState,
    required TResult orElse(),
  }) {
    if (loadDocuments != null) {
      return loadDocuments(forceRefresh, limit, startAfter);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadDocuments value) loadDocuments,
    required TResult Function(SearchDocuments value) searchDocuments,
    required TResult Function(FilterDocuments value) filterDocuments,
    required TResult Function(SortDocuments value) sortDocuments,
    required TResult Function(DeleteDocument value) deleteDocument,
    required TResult Function(PermanentlyDeleteDocument value)
    permanentlyDeleteDocument,
    required TResult Function(RestoreDocument value) restoreDocument,
    required TResult Function(UpdateDocument value) updateDocument,
    required TResult Function(RefreshDocuments value) refreshDocuments,
    required TResult Function(LoadRecentDocuments value) loadRecentDocuments,
    required TResult Function(LoadDeletedDocuments value) loadDeletedDocuments,
    required TResult Function(LoadDocumentsByCategory value)
    loadDocumentsByCategory,
    required TResult Function(LoadDocumentsByUser value) loadDocumentsByUser,
    required TResult Function(LoadDocumentStatistics value)
    loadDocumentStatistics,
    required TResult Function(SyncDocuments value) syncDocuments,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(DocumentsUpdated value) documentsUpdated,
    required TResult Function(LoadMoreDocuments value) loadMoreDocuments,
    required TResult Function(ResetState value) resetState,
  }) {
    return loadDocuments(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadDocuments value)? loadDocuments,
    TResult? Function(SearchDocuments value)? searchDocuments,
    TResult? Function(FilterDocuments value)? filterDocuments,
    TResult? Function(SortDocuments value)? sortDocuments,
    TResult? Function(DeleteDocument value)? deleteDocument,
    TResult? Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult? Function(RestoreDocument value)? restoreDocument,
    TResult? Function(UpdateDocument value)? updateDocument,
    TResult? Function(RefreshDocuments value)? refreshDocuments,
    TResult? Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult? Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult? Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult? Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult? Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult? Function(SyncDocuments value)? syncDocuments,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(DocumentsUpdated value)? documentsUpdated,
    TResult? Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult? Function(ResetState value)? resetState,
  }) {
    return loadDocuments?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadDocuments value)? loadDocuments,
    TResult Function(SearchDocuments value)? searchDocuments,
    TResult Function(FilterDocuments value)? filterDocuments,
    TResult Function(SortDocuments value)? sortDocuments,
    TResult Function(DeleteDocument value)? deleteDocument,
    TResult Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult Function(RestoreDocument value)? restoreDocument,
    TResult Function(UpdateDocument value)? updateDocument,
    TResult Function(RefreshDocuments value)? refreshDocuments,
    TResult Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult Function(SyncDocuments value)? syncDocuments,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(DocumentsUpdated value)? documentsUpdated,
    TResult Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult Function(ResetState value)? resetState,
    required TResult orElse(),
  }) {
    if (loadDocuments != null) {
      return loadDocuments(this);
    }
    return orElse();
  }
}

abstract class LoadDocuments implements DocumentEvent {
  const factory LoadDocuments({
    final bool forceRefresh,
    final int? limit,
    final DocumentModel? startAfter,
  }) = _$LoadDocumentsImpl;

  bool get forceRefresh;
  int? get limit;
  DocumentModel? get startAfter;

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadDocumentsImplCopyWith<_$LoadDocumentsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SearchDocumentsImplCopyWith<$Res> {
  factory _$$SearchDocumentsImplCopyWith(
    _$SearchDocumentsImpl value,
    $Res Function(_$SearchDocumentsImpl) then,
  ) = __$$SearchDocumentsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String query, int? limit});
}

/// @nodoc
class __$$SearchDocumentsImplCopyWithImpl<$Res>
    extends _$DocumentEventCopyWithImpl<$Res, _$SearchDocumentsImpl>
    implements _$$SearchDocumentsImplCopyWith<$Res> {
  __$$SearchDocumentsImplCopyWithImpl(
    _$SearchDocumentsImpl _value,
    $Res Function(_$SearchDocumentsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? query = null, Object? limit = freezed}) {
    return _then(
      _$SearchDocumentsImpl(
        query: null == query
            ? _value.query
            : query // ignore: cast_nullable_to_non_nullable
                  as String,
        limit: freezed == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$SearchDocumentsImpl implements SearchDocuments {
  const _$SearchDocumentsImpl({required this.query, this.limit});

  @override
  final String query;
  @override
  final int? limit;

  @override
  String toString() {
    return 'DocumentEvent.searchDocuments(query: $query, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchDocumentsImpl &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @override
  int get hashCode => Object.hash(runtimeType, query, limit);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchDocumentsImplCopyWith<_$SearchDocumentsImpl> get copyWith =>
      __$$SearchDocumentsImplCopyWithImpl<_$SearchDocumentsImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      bool forceRefresh,
      int? limit,
      DocumentModel? startAfter,
    )
    loadDocuments,
    required TResult Function(String query, int? limit) searchDocuments,
    required TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )
    filterDocuments,
    required TResult Function(String sortBy, bool ascending) sortDocuments,
    required TResult Function(String documentId, String userId) deleteDocument,
    required TResult Function(String documentId, String userId)
    permanentlyDeleteDocument,
    required TResult Function(String documentId, String userId) restoreDocument,
    required TResult Function(DocumentModel document) updateDocument,
    required TResult Function(bool forceRefresh) refreshDocuments,
    required TResult Function(int? limit) loadRecentDocuments,
    required TResult Function(int? limit) loadDeletedDocuments,
    required TResult Function(String category, int? limit)
    loadDocumentsByCategory,
    required TResult Function(String userId, int? limit) loadDocumentsByUser,
    required TResult Function() loadDocumentStatistics,
    required TResult Function() syncDocuments,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<DocumentModel> documents) documentsUpdated,
    required TResult Function(int? limit) loadMoreDocuments,
    required TResult Function() resetState,
  }) {
    return searchDocuments(query, limit);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult? Function(String query, int? limit)? searchDocuments,
    TResult? Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult? Function(String sortBy, bool ascending)? sortDocuments,
    TResult? Function(String documentId, String userId)? deleteDocument,
    TResult? Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult? Function(String documentId, String userId)? restoreDocument,
    TResult? Function(DocumentModel document)? updateDocument,
    TResult? Function(bool forceRefresh)? refreshDocuments,
    TResult? Function(int? limit)? loadRecentDocuments,
    TResult? Function(int? limit)? loadDeletedDocuments,
    TResult? Function(String category, int? limit)? loadDocumentsByCategory,
    TResult? Function(String userId, int? limit)? loadDocumentsByUser,
    TResult? Function()? loadDocumentStatistics,
    TResult? Function()? syncDocuments,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<DocumentModel> documents)? documentsUpdated,
    TResult? Function(int? limit)? loadMoreDocuments,
    TResult? Function()? resetState,
  }) {
    return searchDocuments?.call(query, limit);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult Function(String query, int? limit)? searchDocuments,
    TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult Function(String sortBy, bool ascending)? sortDocuments,
    TResult Function(String documentId, String userId)? deleteDocument,
    TResult Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult Function(String documentId, String userId)? restoreDocument,
    TResult Function(DocumentModel document)? updateDocument,
    TResult Function(bool forceRefresh)? refreshDocuments,
    TResult Function(int? limit)? loadRecentDocuments,
    TResult Function(int? limit)? loadDeletedDocuments,
    TResult Function(String category, int? limit)? loadDocumentsByCategory,
    TResult Function(String userId, int? limit)? loadDocumentsByUser,
    TResult Function()? loadDocumentStatistics,
    TResult Function()? syncDocuments,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<DocumentModel> documents)? documentsUpdated,
    TResult Function(int? limit)? loadMoreDocuments,
    TResult Function()? resetState,
    required TResult orElse(),
  }) {
    if (searchDocuments != null) {
      return searchDocuments(query, limit);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadDocuments value) loadDocuments,
    required TResult Function(SearchDocuments value) searchDocuments,
    required TResult Function(FilterDocuments value) filterDocuments,
    required TResult Function(SortDocuments value) sortDocuments,
    required TResult Function(DeleteDocument value) deleteDocument,
    required TResult Function(PermanentlyDeleteDocument value)
    permanentlyDeleteDocument,
    required TResult Function(RestoreDocument value) restoreDocument,
    required TResult Function(UpdateDocument value) updateDocument,
    required TResult Function(RefreshDocuments value) refreshDocuments,
    required TResult Function(LoadRecentDocuments value) loadRecentDocuments,
    required TResult Function(LoadDeletedDocuments value) loadDeletedDocuments,
    required TResult Function(LoadDocumentsByCategory value)
    loadDocumentsByCategory,
    required TResult Function(LoadDocumentsByUser value) loadDocumentsByUser,
    required TResult Function(LoadDocumentStatistics value)
    loadDocumentStatistics,
    required TResult Function(SyncDocuments value) syncDocuments,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(DocumentsUpdated value) documentsUpdated,
    required TResult Function(LoadMoreDocuments value) loadMoreDocuments,
    required TResult Function(ResetState value) resetState,
  }) {
    return searchDocuments(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadDocuments value)? loadDocuments,
    TResult? Function(SearchDocuments value)? searchDocuments,
    TResult? Function(FilterDocuments value)? filterDocuments,
    TResult? Function(SortDocuments value)? sortDocuments,
    TResult? Function(DeleteDocument value)? deleteDocument,
    TResult? Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult? Function(RestoreDocument value)? restoreDocument,
    TResult? Function(UpdateDocument value)? updateDocument,
    TResult? Function(RefreshDocuments value)? refreshDocuments,
    TResult? Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult? Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult? Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult? Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult? Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult? Function(SyncDocuments value)? syncDocuments,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(DocumentsUpdated value)? documentsUpdated,
    TResult? Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult? Function(ResetState value)? resetState,
  }) {
    return searchDocuments?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadDocuments value)? loadDocuments,
    TResult Function(SearchDocuments value)? searchDocuments,
    TResult Function(FilterDocuments value)? filterDocuments,
    TResult Function(SortDocuments value)? sortDocuments,
    TResult Function(DeleteDocument value)? deleteDocument,
    TResult Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult Function(RestoreDocument value)? restoreDocument,
    TResult Function(UpdateDocument value)? updateDocument,
    TResult Function(RefreshDocuments value)? refreshDocuments,
    TResult Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult Function(SyncDocuments value)? syncDocuments,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(DocumentsUpdated value)? documentsUpdated,
    TResult Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult Function(ResetState value)? resetState,
    required TResult orElse(),
  }) {
    if (searchDocuments != null) {
      return searchDocuments(this);
    }
    return orElse();
  }
}

abstract class SearchDocuments implements DocumentEvent {
  const factory SearchDocuments({
    required final String query,
    final int? limit,
  }) = _$SearchDocumentsImpl;

  String get query;
  int? get limit;

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchDocumentsImplCopyWith<_$SearchDocumentsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FilterDocumentsImplCopyWith<$Res> {
  factory _$$FilterDocumentsImplCopyWith(
    _$FilterDocumentsImpl value,
    $Res Function(_$FilterDocumentsImpl) then,
  ) = __$$FilterDocumentsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String? category,
    String? status,
    String? fileType,
    String? userId,
    bool? isDeleted,
    DateTime? startDate,
    DateTime? endDate,
  });
}

/// @nodoc
class __$$FilterDocumentsImplCopyWithImpl<$Res>
    extends _$DocumentEventCopyWithImpl<$Res, _$FilterDocumentsImpl>
    implements _$$FilterDocumentsImplCopyWith<$Res> {
  __$$FilterDocumentsImplCopyWithImpl(
    _$FilterDocumentsImpl _value,
    $Res Function(_$FilterDocumentsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = freezed,
    Object? status = freezed,
    Object? fileType = freezed,
    Object? userId = freezed,
    Object? isDeleted = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
  }) {
    return _then(
      _$FilterDocumentsImpl(
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        fileType: freezed == fileType
            ? _value.fileType
            : fileType // ignore: cast_nullable_to_non_nullable
                  as String?,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isDeleted: freezed == isDeleted
            ? _value.isDeleted
            : isDeleted // ignore: cast_nullable_to_non_nullable
                  as bool?,
        startDate: freezed == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$FilterDocumentsImpl implements FilterDocuments {
  const _$FilterDocumentsImpl({
    this.category,
    this.status,
    this.fileType,
    this.userId,
    this.isDeleted,
    this.startDate,
    this.endDate,
  });

  @override
  final String? category;
  @override
  final String? status;
  @override
  final String? fileType;
  @override
  final String? userId;
  @override
  final bool? isDeleted;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;

  @override
  String toString() {
    return 'DocumentEvent.filterDocuments(category: $category, status: $status, fileType: $fileType, userId: $userId, isDeleted: $isDeleted, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterDocumentsImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.fileType, fileType) ||
                other.fileType == fileType) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    category,
    status,
    fileType,
    userId,
    isDeleted,
    startDate,
    endDate,
  );

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterDocumentsImplCopyWith<_$FilterDocumentsImpl> get copyWith =>
      __$$FilterDocumentsImplCopyWithImpl<_$FilterDocumentsImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      bool forceRefresh,
      int? limit,
      DocumentModel? startAfter,
    )
    loadDocuments,
    required TResult Function(String query, int? limit) searchDocuments,
    required TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )
    filterDocuments,
    required TResult Function(String sortBy, bool ascending) sortDocuments,
    required TResult Function(String documentId, String userId) deleteDocument,
    required TResult Function(String documentId, String userId)
    permanentlyDeleteDocument,
    required TResult Function(String documentId, String userId) restoreDocument,
    required TResult Function(DocumentModel document) updateDocument,
    required TResult Function(bool forceRefresh) refreshDocuments,
    required TResult Function(int? limit) loadRecentDocuments,
    required TResult Function(int? limit) loadDeletedDocuments,
    required TResult Function(String category, int? limit)
    loadDocumentsByCategory,
    required TResult Function(String userId, int? limit) loadDocumentsByUser,
    required TResult Function() loadDocumentStatistics,
    required TResult Function() syncDocuments,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<DocumentModel> documents) documentsUpdated,
    required TResult Function(int? limit) loadMoreDocuments,
    required TResult Function() resetState,
  }) {
    return filterDocuments(
      category,
      status,
      fileType,
      userId,
      isDeleted,
      startDate,
      endDate,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult? Function(String query, int? limit)? searchDocuments,
    TResult? Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult? Function(String sortBy, bool ascending)? sortDocuments,
    TResult? Function(String documentId, String userId)? deleteDocument,
    TResult? Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult? Function(String documentId, String userId)? restoreDocument,
    TResult? Function(DocumentModel document)? updateDocument,
    TResult? Function(bool forceRefresh)? refreshDocuments,
    TResult? Function(int? limit)? loadRecentDocuments,
    TResult? Function(int? limit)? loadDeletedDocuments,
    TResult? Function(String category, int? limit)? loadDocumentsByCategory,
    TResult? Function(String userId, int? limit)? loadDocumentsByUser,
    TResult? Function()? loadDocumentStatistics,
    TResult? Function()? syncDocuments,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<DocumentModel> documents)? documentsUpdated,
    TResult? Function(int? limit)? loadMoreDocuments,
    TResult? Function()? resetState,
  }) {
    return filterDocuments?.call(
      category,
      status,
      fileType,
      userId,
      isDeleted,
      startDate,
      endDate,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult Function(String query, int? limit)? searchDocuments,
    TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult Function(String sortBy, bool ascending)? sortDocuments,
    TResult Function(String documentId, String userId)? deleteDocument,
    TResult Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult Function(String documentId, String userId)? restoreDocument,
    TResult Function(DocumentModel document)? updateDocument,
    TResult Function(bool forceRefresh)? refreshDocuments,
    TResult Function(int? limit)? loadRecentDocuments,
    TResult Function(int? limit)? loadDeletedDocuments,
    TResult Function(String category, int? limit)? loadDocumentsByCategory,
    TResult Function(String userId, int? limit)? loadDocumentsByUser,
    TResult Function()? loadDocumentStatistics,
    TResult Function()? syncDocuments,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<DocumentModel> documents)? documentsUpdated,
    TResult Function(int? limit)? loadMoreDocuments,
    TResult Function()? resetState,
    required TResult orElse(),
  }) {
    if (filterDocuments != null) {
      return filterDocuments(
        category,
        status,
        fileType,
        userId,
        isDeleted,
        startDate,
        endDate,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadDocuments value) loadDocuments,
    required TResult Function(SearchDocuments value) searchDocuments,
    required TResult Function(FilterDocuments value) filterDocuments,
    required TResult Function(SortDocuments value) sortDocuments,
    required TResult Function(DeleteDocument value) deleteDocument,
    required TResult Function(PermanentlyDeleteDocument value)
    permanentlyDeleteDocument,
    required TResult Function(RestoreDocument value) restoreDocument,
    required TResult Function(UpdateDocument value) updateDocument,
    required TResult Function(RefreshDocuments value) refreshDocuments,
    required TResult Function(LoadRecentDocuments value) loadRecentDocuments,
    required TResult Function(LoadDeletedDocuments value) loadDeletedDocuments,
    required TResult Function(LoadDocumentsByCategory value)
    loadDocumentsByCategory,
    required TResult Function(LoadDocumentsByUser value) loadDocumentsByUser,
    required TResult Function(LoadDocumentStatistics value)
    loadDocumentStatistics,
    required TResult Function(SyncDocuments value) syncDocuments,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(DocumentsUpdated value) documentsUpdated,
    required TResult Function(LoadMoreDocuments value) loadMoreDocuments,
    required TResult Function(ResetState value) resetState,
  }) {
    return filterDocuments(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadDocuments value)? loadDocuments,
    TResult? Function(SearchDocuments value)? searchDocuments,
    TResult? Function(FilterDocuments value)? filterDocuments,
    TResult? Function(SortDocuments value)? sortDocuments,
    TResult? Function(DeleteDocument value)? deleteDocument,
    TResult? Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult? Function(RestoreDocument value)? restoreDocument,
    TResult? Function(UpdateDocument value)? updateDocument,
    TResult? Function(RefreshDocuments value)? refreshDocuments,
    TResult? Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult? Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult? Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult? Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult? Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult? Function(SyncDocuments value)? syncDocuments,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(DocumentsUpdated value)? documentsUpdated,
    TResult? Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult? Function(ResetState value)? resetState,
  }) {
    return filterDocuments?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadDocuments value)? loadDocuments,
    TResult Function(SearchDocuments value)? searchDocuments,
    TResult Function(FilterDocuments value)? filterDocuments,
    TResult Function(SortDocuments value)? sortDocuments,
    TResult Function(DeleteDocument value)? deleteDocument,
    TResult Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult Function(RestoreDocument value)? restoreDocument,
    TResult Function(UpdateDocument value)? updateDocument,
    TResult Function(RefreshDocuments value)? refreshDocuments,
    TResult Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult Function(SyncDocuments value)? syncDocuments,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(DocumentsUpdated value)? documentsUpdated,
    TResult Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult Function(ResetState value)? resetState,
    required TResult orElse(),
  }) {
    if (filterDocuments != null) {
      return filterDocuments(this);
    }
    return orElse();
  }
}

abstract class FilterDocuments implements DocumentEvent {
  const factory FilterDocuments({
    final String? category,
    final String? status,
    final String? fileType,
    final String? userId,
    final bool? isDeleted,
    final DateTime? startDate,
    final DateTime? endDate,
  }) = _$FilterDocumentsImpl;

  String? get category;
  String? get status;
  String? get fileType;
  String? get userId;
  bool? get isDeleted;
  DateTime? get startDate;
  DateTime? get endDate;

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FilterDocumentsImplCopyWith<_$FilterDocumentsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SortDocumentsImplCopyWith<$Res> {
  factory _$$SortDocumentsImplCopyWith(
    _$SortDocumentsImpl value,
    $Res Function(_$SortDocumentsImpl) then,
  ) = __$$SortDocumentsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String sortBy, bool ascending});
}

/// @nodoc
class __$$SortDocumentsImplCopyWithImpl<$Res>
    extends _$DocumentEventCopyWithImpl<$Res, _$SortDocumentsImpl>
    implements _$$SortDocumentsImplCopyWith<$Res> {
  __$$SortDocumentsImplCopyWithImpl(
    _$SortDocumentsImpl _value,
    $Res Function(_$SortDocumentsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? sortBy = null, Object? ascending = null}) {
    return _then(
      _$SortDocumentsImpl(
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

class _$SortDocumentsImpl implements SortDocuments {
  const _$SortDocumentsImpl({required this.sortBy, this.ascending = false});

  @override
  final String sortBy;
  @override
  @JsonKey()
  final bool ascending;

  @override
  String toString() {
    return 'DocumentEvent.sortDocuments(sortBy: $sortBy, ascending: $ascending)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SortDocumentsImpl &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.ascending, ascending) ||
                other.ascending == ascending));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sortBy, ascending);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SortDocumentsImplCopyWith<_$SortDocumentsImpl> get copyWith =>
      __$$SortDocumentsImplCopyWithImpl<_$SortDocumentsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      bool forceRefresh,
      int? limit,
      DocumentModel? startAfter,
    )
    loadDocuments,
    required TResult Function(String query, int? limit) searchDocuments,
    required TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )
    filterDocuments,
    required TResult Function(String sortBy, bool ascending) sortDocuments,
    required TResult Function(String documentId, String userId) deleteDocument,
    required TResult Function(String documentId, String userId)
    permanentlyDeleteDocument,
    required TResult Function(String documentId, String userId) restoreDocument,
    required TResult Function(DocumentModel document) updateDocument,
    required TResult Function(bool forceRefresh) refreshDocuments,
    required TResult Function(int? limit) loadRecentDocuments,
    required TResult Function(int? limit) loadDeletedDocuments,
    required TResult Function(String category, int? limit)
    loadDocumentsByCategory,
    required TResult Function(String userId, int? limit) loadDocumentsByUser,
    required TResult Function() loadDocumentStatistics,
    required TResult Function() syncDocuments,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<DocumentModel> documents) documentsUpdated,
    required TResult Function(int? limit) loadMoreDocuments,
    required TResult Function() resetState,
  }) {
    return sortDocuments(sortBy, ascending);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult? Function(String query, int? limit)? searchDocuments,
    TResult? Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult? Function(String sortBy, bool ascending)? sortDocuments,
    TResult? Function(String documentId, String userId)? deleteDocument,
    TResult? Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult? Function(String documentId, String userId)? restoreDocument,
    TResult? Function(DocumentModel document)? updateDocument,
    TResult? Function(bool forceRefresh)? refreshDocuments,
    TResult? Function(int? limit)? loadRecentDocuments,
    TResult? Function(int? limit)? loadDeletedDocuments,
    TResult? Function(String category, int? limit)? loadDocumentsByCategory,
    TResult? Function(String userId, int? limit)? loadDocumentsByUser,
    TResult? Function()? loadDocumentStatistics,
    TResult? Function()? syncDocuments,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<DocumentModel> documents)? documentsUpdated,
    TResult? Function(int? limit)? loadMoreDocuments,
    TResult? Function()? resetState,
  }) {
    return sortDocuments?.call(sortBy, ascending);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult Function(String query, int? limit)? searchDocuments,
    TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult Function(String sortBy, bool ascending)? sortDocuments,
    TResult Function(String documentId, String userId)? deleteDocument,
    TResult Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult Function(String documentId, String userId)? restoreDocument,
    TResult Function(DocumentModel document)? updateDocument,
    TResult Function(bool forceRefresh)? refreshDocuments,
    TResult Function(int? limit)? loadRecentDocuments,
    TResult Function(int? limit)? loadDeletedDocuments,
    TResult Function(String category, int? limit)? loadDocumentsByCategory,
    TResult Function(String userId, int? limit)? loadDocumentsByUser,
    TResult Function()? loadDocumentStatistics,
    TResult Function()? syncDocuments,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<DocumentModel> documents)? documentsUpdated,
    TResult Function(int? limit)? loadMoreDocuments,
    TResult Function()? resetState,
    required TResult orElse(),
  }) {
    if (sortDocuments != null) {
      return sortDocuments(sortBy, ascending);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadDocuments value) loadDocuments,
    required TResult Function(SearchDocuments value) searchDocuments,
    required TResult Function(FilterDocuments value) filterDocuments,
    required TResult Function(SortDocuments value) sortDocuments,
    required TResult Function(DeleteDocument value) deleteDocument,
    required TResult Function(PermanentlyDeleteDocument value)
    permanentlyDeleteDocument,
    required TResult Function(RestoreDocument value) restoreDocument,
    required TResult Function(UpdateDocument value) updateDocument,
    required TResult Function(RefreshDocuments value) refreshDocuments,
    required TResult Function(LoadRecentDocuments value) loadRecentDocuments,
    required TResult Function(LoadDeletedDocuments value) loadDeletedDocuments,
    required TResult Function(LoadDocumentsByCategory value)
    loadDocumentsByCategory,
    required TResult Function(LoadDocumentsByUser value) loadDocumentsByUser,
    required TResult Function(LoadDocumentStatistics value)
    loadDocumentStatistics,
    required TResult Function(SyncDocuments value) syncDocuments,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(DocumentsUpdated value) documentsUpdated,
    required TResult Function(LoadMoreDocuments value) loadMoreDocuments,
    required TResult Function(ResetState value) resetState,
  }) {
    return sortDocuments(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadDocuments value)? loadDocuments,
    TResult? Function(SearchDocuments value)? searchDocuments,
    TResult? Function(FilterDocuments value)? filterDocuments,
    TResult? Function(SortDocuments value)? sortDocuments,
    TResult? Function(DeleteDocument value)? deleteDocument,
    TResult? Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult? Function(RestoreDocument value)? restoreDocument,
    TResult? Function(UpdateDocument value)? updateDocument,
    TResult? Function(RefreshDocuments value)? refreshDocuments,
    TResult? Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult? Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult? Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult? Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult? Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult? Function(SyncDocuments value)? syncDocuments,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(DocumentsUpdated value)? documentsUpdated,
    TResult? Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult? Function(ResetState value)? resetState,
  }) {
    return sortDocuments?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadDocuments value)? loadDocuments,
    TResult Function(SearchDocuments value)? searchDocuments,
    TResult Function(FilterDocuments value)? filterDocuments,
    TResult Function(SortDocuments value)? sortDocuments,
    TResult Function(DeleteDocument value)? deleteDocument,
    TResult Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult Function(RestoreDocument value)? restoreDocument,
    TResult Function(UpdateDocument value)? updateDocument,
    TResult Function(RefreshDocuments value)? refreshDocuments,
    TResult Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult Function(SyncDocuments value)? syncDocuments,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(DocumentsUpdated value)? documentsUpdated,
    TResult Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult Function(ResetState value)? resetState,
    required TResult orElse(),
  }) {
    if (sortDocuments != null) {
      return sortDocuments(this);
    }
    return orElse();
  }
}

abstract class SortDocuments implements DocumentEvent {
  const factory SortDocuments({
    required final String sortBy,
    final bool ascending,
  }) = _$SortDocumentsImpl;

  String get sortBy;
  bool get ascending;

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SortDocumentsImplCopyWith<_$SortDocumentsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeleteDocumentImplCopyWith<$Res> {
  factory _$$DeleteDocumentImplCopyWith(
    _$DeleteDocumentImpl value,
    $Res Function(_$DeleteDocumentImpl) then,
  ) = __$$DeleteDocumentImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String documentId, String userId});
}

/// @nodoc
class __$$DeleteDocumentImplCopyWithImpl<$Res>
    extends _$DocumentEventCopyWithImpl<$Res, _$DeleteDocumentImpl>
    implements _$$DeleteDocumentImplCopyWith<$Res> {
  __$$DeleteDocumentImplCopyWithImpl(
    _$DeleteDocumentImpl _value,
    $Res Function(_$DeleteDocumentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? documentId = null, Object? userId = null}) {
    return _then(
      _$DeleteDocumentImpl(
        documentId: null == documentId
            ? _value.documentId
            : documentId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$DeleteDocumentImpl implements DeleteDocument {
  const _$DeleteDocumentImpl({required this.documentId, required this.userId});

  @override
  final String documentId;
  @override
  final String userId;

  @override
  String toString() {
    return 'DocumentEvent.deleteDocument(documentId: $documentId, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteDocumentImpl &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, documentId, userId);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteDocumentImplCopyWith<_$DeleteDocumentImpl> get copyWith =>
      __$$DeleteDocumentImplCopyWithImpl<_$DeleteDocumentImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      bool forceRefresh,
      int? limit,
      DocumentModel? startAfter,
    )
    loadDocuments,
    required TResult Function(String query, int? limit) searchDocuments,
    required TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )
    filterDocuments,
    required TResult Function(String sortBy, bool ascending) sortDocuments,
    required TResult Function(String documentId, String userId) deleteDocument,
    required TResult Function(String documentId, String userId)
    permanentlyDeleteDocument,
    required TResult Function(String documentId, String userId) restoreDocument,
    required TResult Function(DocumentModel document) updateDocument,
    required TResult Function(bool forceRefresh) refreshDocuments,
    required TResult Function(int? limit) loadRecentDocuments,
    required TResult Function(int? limit) loadDeletedDocuments,
    required TResult Function(String category, int? limit)
    loadDocumentsByCategory,
    required TResult Function(String userId, int? limit) loadDocumentsByUser,
    required TResult Function() loadDocumentStatistics,
    required TResult Function() syncDocuments,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<DocumentModel> documents) documentsUpdated,
    required TResult Function(int? limit) loadMoreDocuments,
    required TResult Function() resetState,
  }) {
    return deleteDocument(documentId, userId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult? Function(String query, int? limit)? searchDocuments,
    TResult? Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult? Function(String sortBy, bool ascending)? sortDocuments,
    TResult? Function(String documentId, String userId)? deleteDocument,
    TResult? Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult? Function(String documentId, String userId)? restoreDocument,
    TResult? Function(DocumentModel document)? updateDocument,
    TResult? Function(bool forceRefresh)? refreshDocuments,
    TResult? Function(int? limit)? loadRecentDocuments,
    TResult? Function(int? limit)? loadDeletedDocuments,
    TResult? Function(String category, int? limit)? loadDocumentsByCategory,
    TResult? Function(String userId, int? limit)? loadDocumentsByUser,
    TResult? Function()? loadDocumentStatistics,
    TResult? Function()? syncDocuments,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<DocumentModel> documents)? documentsUpdated,
    TResult? Function(int? limit)? loadMoreDocuments,
    TResult? Function()? resetState,
  }) {
    return deleteDocument?.call(documentId, userId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult Function(String query, int? limit)? searchDocuments,
    TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult Function(String sortBy, bool ascending)? sortDocuments,
    TResult Function(String documentId, String userId)? deleteDocument,
    TResult Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult Function(String documentId, String userId)? restoreDocument,
    TResult Function(DocumentModel document)? updateDocument,
    TResult Function(bool forceRefresh)? refreshDocuments,
    TResult Function(int? limit)? loadRecentDocuments,
    TResult Function(int? limit)? loadDeletedDocuments,
    TResult Function(String category, int? limit)? loadDocumentsByCategory,
    TResult Function(String userId, int? limit)? loadDocumentsByUser,
    TResult Function()? loadDocumentStatistics,
    TResult Function()? syncDocuments,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<DocumentModel> documents)? documentsUpdated,
    TResult Function(int? limit)? loadMoreDocuments,
    TResult Function()? resetState,
    required TResult orElse(),
  }) {
    if (deleteDocument != null) {
      return deleteDocument(documentId, userId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadDocuments value) loadDocuments,
    required TResult Function(SearchDocuments value) searchDocuments,
    required TResult Function(FilterDocuments value) filterDocuments,
    required TResult Function(SortDocuments value) sortDocuments,
    required TResult Function(DeleteDocument value) deleteDocument,
    required TResult Function(PermanentlyDeleteDocument value)
    permanentlyDeleteDocument,
    required TResult Function(RestoreDocument value) restoreDocument,
    required TResult Function(UpdateDocument value) updateDocument,
    required TResult Function(RefreshDocuments value) refreshDocuments,
    required TResult Function(LoadRecentDocuments value) loadRecentDocuments,
    required TResult Function(LoadDeletedDocuments value) loadDeletedDocuments,
    required TResult Function(LoadDocumentsByCategory value)
    loadDocumentsByCategory,
    required TResult Function(LoadDocumentsByUser value) loadDocumentsByUser,
    required TResult Function(LoadDocumentStatistics value)
    loadDocumentStatistics,
    required TResult Function(SyncDocuments value) syncDocuments,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(DocumentsUpdated value) documentsUpdated,
    required TResult Function(LoadMoreDocuments value) loadMoreDocuments,
    required TResult Function(ResetState value) resetState,
  }) {
    return deleteDocument(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadDocuments value)? loadDocuments,
    TResult? Function(SearchDocuments value)? searchDocuments,
    TResult? Function(FilterDocuments value)? filterDocuments,
    TResult? Function(SortDocuments value)? sortDocuments,
    TResult? Function(DeleteDocument value)? deleteDocument,
    TResult? Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult? Function(RestoreDocument value)? restoreDocument,
    TResult? Function(UpdateDocument value)? updateDocument,
    TResult? Function(RefreshDocuments value)? refreshDocuments,
    TResult? Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult? Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult? Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult? Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult? Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult? Function(SyncDocuments value)? syncDocuments,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(DocumentsUpdated value)? documentsUpdated,
    TResult? Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult? Function(ResetState value)? resetState,
  }) {
    return deleteDocument?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadDocuments value)? loadDocuments,
    TResult Function(SearchDocuments value)? searchDocuments,
    TResult Function(FilterDocuments value)? filterDocuments,
    TResult Function(SortDocuments value)? sortDocuments,
    TResult Function(DeleteDocument value)? deleteDocument,
    TResult Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult Function(RestoreDocument value)? restoreDocument,
    TResult Function(UpdateDocument value)? updateDocument,
    TResult Function(RefreshDocuments value)? refreshDocuments,
    TResult Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult Function(SyncDocuments value)? syncDocuments,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(DocumentsUpdated value)? documentsUpdated,
    TResult Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult Function(ResetState value)? resetState,
    required TResult orElse(),
  }) {
    if (deleteDocument != null) {
      return deleteDocument(this);
    }
    return orElse();
  }
}

abstract class DeleteDocument implements DocumentEvent {
  const factory DeleteDocument({
    required final String documentId,
    required final String userId,
  }) = _$DeleteDocumentImpl;

  String get documentId;
  String get userId;

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteDocumentImplCopyWith<_$DeleteDocumentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PermanentlyDeleteDocumentImplCopyWith<$Res> {
  factory _$$PermanentlyDeleteDocumentImplCopyWith(
    _$PermanentlyDeleteDocumentImpl value,
    $Res Function(_$PermanentlyDeleteDocumentImpl) then,
  ) = __$$PermanentlyDeleteDocumentImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String documentId, String userId});
}

/// @nodoc
class __$$PermanentlyDeleteDocumentImplCopyWithImpl<$Res>
    extends _$DocumentEventCopyWithImpl<$Res, _$PermanentlyDeleteDocumentImpl>
    implements _$$PermanentlyDeleteDocumentImplCopyWith<$Res> {
  __$$PermanentlyDeleteDocumentImplCopyWithImpl(
    _$PermanentlyDeleteDocumentImpl _value,
    $Res Function(_$PermanentlyDeleteDocumentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? documentId = null, Object? userId = null}) {
    return _then(
      _$PermanentlyDeleteDocumentImpl(
        documentId: null == documentId
            ? _value.documentId
            : documentId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PermanentlyDeleteDocumentImpl implements PermanentlyDeleteDocument {
  const _$PermanentlyDeleteDocumentImpl({
    required this.documentId,
    required this.userId,
  });

  @override
  final String documentId;
  @override
  final String userId;

  @override
  String toString() {
    return 'DocumentEvent.permanentlyDeleteDocument(documentId: $documentId, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermanentlyDeleteDocumentImpl &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, documentId, userId);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PermanentlyDeleteDocumentImplCopyWith<_$PermanentlyDeleteDocumentImpl>
  get copyWith =>
      __$$PermanentlyDeleteDocumentImplCopyWithImpl<
        _$PermanentlyDeleteDocumentImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      bool forceRefresh,
      int? limit,
      DocumentModel? startAfter,
    )
    loadDocuments,
    required TResult Function(String query, int? limit) searchDocuments,
    required TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )
    filterDocuments,
    required TResult Function(String sortBy, bool ascending) sortDocuments,
    required TResult Function(String documentId, String userId) deleteDocument,
    required TResult Function(String documentId, String userId)
    permanentlyDeleteDocument,
    required TResult Function(String documentId, String userId) restoreDocument,
    required TResult Function(DocumentModel document) updateDocument,
    required TResult Function(bool forceRefresh) refreshDocuments,
    required TResult Function(int? limit) loadRecentDocuments,
    required TResult Function(int? limit) loadDeletedDocuments,
    required TResult Function(String category, int? limit)
    loadDocumentsByCategory,
    required TResult Function(String userId, int? limit) loadDocumentsByUser,
    required TResult Function() loadDocumentStatistics,
    required TResult Function() syncDocuments,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<DocumentModel> documents) documentsUpdated,
    required TResult Function(int? limit) loadMoreDocuments,
    required TResult Function() resetState,
  }) {
    return permanentlyDeleteDocument(documentId, userId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult? Function(String query, int? limit)? searchDocuments,
    TResult? Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult? Function(String sortBy, bool ascending)? sortDocuments,
    TResult? Function(String documentId, String userId)? deleteDocument,
    TResult? Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult? Function(String documentId, String userId)? restoreDocument,
    TResult? Function(DocumentModel document)? updateDocument,
    TResult? Function(bool forceRefresh)? refreshDocuments,
    TResult? Function(int? limit)? loadRecentDocuments,
    TResult? Function(int? limit)? loadDeletedDocuments,
    TResult? Function(String category, int? limit)? loadDocumentsByCategory,
    TResult? Function(String userId, int? limit)? loadDocumentsByUser,
    TResult? Function()? loadDocumentStatistics,
    TResult? Function()? syncDocuments,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<DocumentModel> documents)? documentsUpdated,
    TResult? Function(int? limit)? loadMoreDocuments,
    TResult? Function()? resetState,
  }) {
    return permanentlyDeleteDocument?.call(documentId, userId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult Function(String query, int? limit)? searchDocuments,
    TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult Function(String sortBy, bool ascending)? sortDocuments,
    TResult Function(String documentId, String userId)? deleteDocument,
    TResult Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult Function(String documentId, String userId)? restoreDocument,
    TResult Function(DocumentModel document)? updateDocument,
    TResult Function(bool forceRefresh)? refreshDocuments,
    TResult Function(int? limit)? loadRecentDocuments,
    TResult Function(int? limit)? loadDeletedDocuments,
    TResult Function(String category, int? limit)? loadDocumentsByCategory,
    TResult Function(String userId, int? limit)? loadDocumentsByUser,
    TResult Function()? loadDocumentStatistics,
    TResult Function()? syncDocuments,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<DocumentModel> documents)? documentsUpdated,
    TResult Function(int? limit)? loadMoreDocuments,
    TResult Function()? resetState,
    required TResult orElse(),
  }) {
    if (permanentlyDeleteDocument != null) {
      return permanentlyDeleteDocument(documentId, userId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadDocuments value) loadDocuments,
    required TResult Function(SearchDocuments value) searchDocuments,
    required TResult Function(FilterDocuments value) filterDocuments,
    required TResult Function(SortDocuments value) sortDocuments,
    required TResult Function(DeleteDocument value) deleteDocument,
    required TResult Function(PermanentlyDeleteDocument value)
    permanentlyDeleteDocument,
    required TResult Function(RestoreDocument value) restoreDocument,
    required TResult Function(UpdateDocument value) updateDocument,
    required TResult Function(RefreshDocuments value) refreshDocuments,
    required TResult Function(LoadRecentDocuments value) loadRecentDocuments,
    required TResult Function(LoadDeletedDocuments value) loadDeletedDocuments,
    required TResult Function(LoadDocumentsByCategory value)
    loadDocumentsByCategory,
    required TResult Function(LoadDocumentsByUser value) loadDocumentsByUser,
    required TResult Function(LoadDocumentStatistics value)
    loadDocumentStatistics,
    required TResult Function(SyncDocuments value) syncDocuments,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(DocumentsUpdated value) documentsUpdated,
    required TResult Function(LoadMoreDocuments value) loadMoreDocuments,
    required TResult Function(ResetState value) resetState,
  }) {
    return permanentlyDeleteDocument(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadDocuments value)? loadDocuments,
    TResult? Function(SearchDocuments value)? searchDocuments,
    TResult? Function(FilterDocuments value)? filterDocuments,
    TResult? Function(SortDocuments value)? sortDocuments,
    TResult? Function(DeleteDocument value)? deleteDocument,
    TResult? Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult? Function(RestoreDocument value)? restoreDocument,
    TResult? Function(UpdateDocument value)? updateDocument,
    TResult? Function(RefreshDocuments value)? refreshDocuments,
    TResult? Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult? Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult? Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult? Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult? Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult? Function(SyncDocuments value)? syncDocuments,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(DocumentsUpdated value)? documentsUpdated,
    TResult? Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult? Function(ResetState value)? resetState,
  }) {
    return permanentlyDeleteDocument?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadDocuments value)? loadDocuments,
    TResult Function(SearchDocuments value)? searchDocuments,
    TResult Function(FilterDocuments value)? filterDocuments,
    TResult Function(SortDocuments value)? sortDocuments,
    TResult Function(DeleteDocument value)? deleteDocument,
    TResult Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult Function(RestoreDocument value)? restoreDocument,
    TResult Function(UpdateDocument value)? updateDocument,
    TResult Function(RefreshDocuments value)? refreshDocuments,
    TResult Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult Function(SyncDocuments value)? syncDocuments,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(DocumentsUpdated value)? documentsUpdated,
    TResult Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult Function(ResetState value)? resetState,
    required TResult orElse(),
  }) {
    if (permanentlyDeleteDocument != null) {
      return permanentlyDeleteDocument(this);
    }
    return orElse();
  }
}

abstract class PermanentlyDeleteDocument implements DocumentEvent {
  const factory PermanentlyDeleteDocument({
    required final String documentId,
    required final String userId,
  }) = _$PermanentlyDeleteDocumentImpl;

  String get documentId;
  String get userId;

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PermanentlyDeleteDocumentImplCopyWith<_$PermanentlyDeleteDocumentImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RestoreDocumentImplCopyWith<$Res> {
  factory _$$RestoreDocumentImplCopyWith(
    _$RestoreDocumentImpl value,
    $Res Function(_$RestoreDocumentImpl) then,
  ) = __$$RestoreDocumentImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String documentId, String userId});
}

/// @nodoc
class __$$RestoreDocumentImplCopyWithImpl<$Res>
    extends _$DocumentEventCopyWithImpl<$Res, _$RestoreDocumentImpl>
    implements _$$RestoreDocumentImplCopyWith<$Res> {
  __$$RestoreDocumentImplCopyWithImpl(
    _$RestoreDocumentImpl _value,
    $Res Function(_$RestoreDocumentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? documentId = null, Object? userId = null}) {
    return _then(
      _$RestoreDocumentImpl(
        documentId: null == documentId
            ? _value.documentId
            : documentId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$RestoreDocumentImpl implements RestoreDocument {
  const _$RestoreDocumentImpl({required this.documentId, required this.userId});

  @override
  final String documentId;
  @override
  final String userId;

  @override
  String toString() {
    return 'DocumentEvent.restoreDocument(documentId: $documentId, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RestoreDocumentImpl &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, documentId, userId);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RestoreDocumentImplCopyWith<_$RestoreDocumentImpl> get copyWith =>
      __$$RestoreDocumentImplCopyWithImpl<_$RestoreDocumentImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      bool forceRefresh,
      int? limit,
      DocumentModel? startAfter,
    )
    loadDocuments,
    required TResult Function(String query, int? limit) searchDocuments,
    required TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )
    filterDocuments,
    required TResult Function(String sortBy, bool ascending) sortDocuments,
    required TResult Function(String documentId, String userId) deleteDocument,
    required TResult Function(String documentId, String userId)
    permanentlyDeleteDocument,
    required TResult Function(String documentId, String userId) restoreDocument,
    required TResult Function(DocumentModel document) updateDocument,
    required TResult Function(bool forceRefresh) refreshDocuments,
    required TResult Function(int? limit) loadRecentDocuments,
    required TResult Function(int? limit) loadDeletedDocuments,
    required TResult Function(String category, int? limit)
    loadDocumentsByCategory,
    required TResult Function(String userId, int? limit) loadDocumentsByUser,
    required TResult Function() loadDocumentStatistics,
    required TResult Function() syncDocuments,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<DocumentModel> documents) documentsUpdated,
    required TResult Function(int? limit) loadMoreDocuments,
    required TResult Function() resetState,
  }) {
    return restoreDocument(documentId, userId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult? Function(String query, int? limit)? searchDocuments,
    TResult? Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult? Function(String sortBy, bool ascending)? sortDocuments,
    TResult? Function(String documentId, String userId)? deleteDocument,
    TResult? Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult? Function(String documentId, String userId)? restoreDocument,
    TResult? Function(DocumentModel document)? updateDocument,
    TResult? Function(bool forceRefresh)? refreshDocuments,
    TResult? Function(int? limit)? loadRecentDocuments,
    TResult? Function(int? limit)? loadDeletedDocuments,
    TResult? Function(String category, int? limit)? loadDocumentsByCategory,
    TResult? Function(String userId, int? limit)? loadDocumentsByUser,
    TResult? Function()? loadDocumentStatistics,
    TResult? Function()? syncDocuments,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<DocumentModel> documents)? documentsUpdated,
    TResult? Function(int? limit)? loadMoreDocuments,
    TResult? Function()? resetState,
  }) {
    return restoreDocument?.call(documentId, userId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult Function(String query, int? limit)? searchDocuments,
    TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult Function(String sortBy, bool ascending)? sortDocuments,
    TResult Function(String documentId, String userId)? deleteDocument,
    TResult Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult Function(String documentId, String userId)? restoreDocument,
    TResult Function(DocumentModel document)? updateDocument,
    TResult Function(bool forceRefresh)? refreshDocuments,
    TResult Function(int? limit)? loadRecentDocuments,
    TResult Function(int? limit)? loadDeletedDocuments,
    TResult Function(String category, int? limit)? loadDocumentsByCategory,
    TResult Function(String userId, int? limit)? loadDocumentsByUser,
    TResult Function()? loadDocumentStatistics,
    TResult Function()? syncDocuments,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<DocumentModel> documents)? documentsUpdated,
    TResult Function(int? limit)? loadMoreDocuments,
    TResult Function()? resetState,
    required TResult orElse(),
  }) {
    if (restoreDocument != null) {
      return restoreDocument(documentId, userId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadDocuments value) loadDocuments,
    required TResult Function(SearchDocuments value) searchDocuments,
    required TResult Function(FilterDocuments value) filterDocuments,
    required TResult Function(SortDocuments value) sortDocuments,
    required TResult Function(DeleteDocument value) deleteDocument,
    required TResult Function(PermanentlyDeleteDocument value)
    permanentlyDeleteDocument,
    required TResult Function(RestoreDocument value) restoreDocument,
    required TResult Function(UpdateDocument value) updateDocument,
    required TResult Function(RefreshDocuments value) refreshDocuments,
    required TResult Function(LoadRecentDocuments value) loadRecentDocuments,
    required TResult Function(LoadDeletedDocuments value) loadDeletedDocuments,
    required TResult Function(LoadDocumentsByCategory value)
    loadDocumentsByCategory,
    required TResult Function(LoadDocumentsByUser value) loadDocumentsByUser,
    required TResult Function(LoadDocumentStatistics value)
    loadDocumentStatistics,
    required TResult Function(SyncDocuments value) syncDocuments,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(DocumentsUpdated value) documentsUpdated,
    required TResult Function(LoadMoreDocuments value) loadMoreDocuments,
    required TResult Function(ResetState value) resetState,
  }) {
    return restoreDocument(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadDocuments value)? loadDocuments,
    TResult? Function(SearchDocuments value)? searchDocuments,
    TResult? Function(FilterDocuments value)? filterDocuments,
    TResult? Function(SortDocuments value)? sortDocuments,
    TResult? Function(DeleteDocument value)? deleteDocument,
    TResult? Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult? Function(RestoreDocument value)? restoreDocument,
    TResult? Function(UpdateDocument value)? updateDocument,
    TResult? Function(RefreshDocuments value)? refreshDocuments,
    TResult? Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult? Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult? Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult? Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult? Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult? Function(SyncDocuments value)? syncDocuments,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(DocumentsUpdated value)? documentsUpdated,
    TResult? Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult? Function(ResetState value)? resetState,
  }) {
    return restoreDocument?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadDocuments value)? loadDocuments,
    TResult Function(SearchDocuments value)? searchDocuments,
    TResult Function(FilterDocuments value)? filterDocuments,
    TResult Function(SortDocuments value)? sortDocuments,
    TResult Function(DeleteDocument value)? deleteDocument,
    TResult Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult Function(RestoreDocument value)? restoreDocument,
    TResult Function(UpdateDocument value)? updateDocument,
    TResult Function(RefreshDocuments value)? refreshDocuments,
    TResult Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult Function(SyncDocuments value)? syncDocuments,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(DocumentsUpdated value)? documentsUpdated,
    TResult Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult Function(ResetState value)? resetState,
    required TResult orElse(),
  }) {
    if (restoreDocument != null) {
      return restoreDocument(this);
    }
    return orElse();
  }
}

abstract class RestoreDocument implements DocumentEvent {
  const factory RestoreDocument({
    required final String documentId,
    required final String userId,
  }) = _$RestoreDocumentImpl;

  String get documentId;
  String get userId;

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RestoreDocumentImplCopyWith<_$RestoreDocumentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateDocumentImplCopyWith<$Res> {
  factory _$$UpdateDocumentImplCopyWith(
    _$UpdateDocumentImpl value,
    $Res Function(_$UpdateDocumentImpl) then,
  ) = __$$UpdateDocumentImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DocumentModel document});
}

/// @nodoc
class __$$UpdateDocumentImplCopyWithImpl<$Res>
    extends _$DocumentEventCopyWithImpl<$Res, _$UpdateDocumentImpl>
    implements _$$UpdateDocumentImplCopyWith<$Res> {
  __$$UpdateDocumentImplCopyWithImpl(
    _$UpdateDocumentImpl _value,
    $Res Function(_$UpdateDocumentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? document = null}) {
    return _then(
      _$UpdateDocumentImpl(
        document: null == document
            ? _value.document
            : document // ignore: cast_nullable_to_non_nullable
                  as DocumentModel,
      ),
    );
  }
}

/// @nodoc

class _$UpdateDocumentImpl implements UpdateDocument {
  const _$UpdateDocumentImpl({required this.document});

  @override
  final DocumentModel document;

  @override
  String toString() {
    return 'DocumentEvent.updateDocument(document: $document)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateDocumentImpl &&
            (identical(other.document, document) ||
                other.document == document));
  }

  @override
  int get hashCode => Object.hash(runtimeType, document);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateDocumentImplCopyWith<_$UpdateDocumentImpl> get copyWith =>
      __$$UpdateDocumentImplCopyWithImpl<_$UpdateDocumentImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      bool forceRefresh,
      int? limit,
      DocumentModel? startAfter,
    )
    loadDocuments,
    required TResult Function(String query, int? limit) searchDocuments,
    required TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )
    filterDocuments,
    required TResult Function(String sortBy, bool ascending) sortDocuments,
    required TResult Function(String documentId, String userId) deleteDocument,
    required TResult Function(String documentId, String userId)
    permanentlyDeleteDocument,
    required TResult Function(String documentId, String userId) restoreDocument,
    required TResult Function(DocumentModel document) updateDocument,
    required TResult Function(bool forceRefresh) refreshDocuments,
    required TResult Function(int? limit) loadRecentDocuments,
    required TResult Function(int? limit) loadDeletedDocuments,
    required TResult Function(String category, int? limit)
    loadDocumentsByCategory,
    required TResult Function(String userId, int? limit) loadDocumentsByUser,
    required TResult Function() loadDocumentStatistics,
    required TResult Function() syncDocuments,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<DocumentModel> documents) documentsUpdated,
    required TResult Function(int? limit) loadMoreDocuments,
    required TResult Function() resetState,
  }) {
    return updateDocument(document);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult? Function(String query, int? limit)? searchDocuments,
    TResult? Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult? Function(String sortBy, bool ascending)? sortDocuments,
    TResult? Function(String documentId, String userId)? deleteDocument,
    TResult? Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult? Function(String documentId, String userId)? restoreDocument,
    TResult? Function(DocumentModel document)? updateDocument,
    TResult? Function(bool forceRefresh)? refreshDocuments,
    TResult? Function(int? limit)? loadRecentDocuments,
    TResult? Function(int? limit)? loadDeletedDocuments,
    TResult? Function(String category, int? limit)? loadDocumentsByCategory,
    TResult? Function(String userId, int? limit)? loadDocumentsByUser,
    TResult? Function()? loadDocumentStatistics,
    TResult? Function()? syncDocuments,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<DocumentModel> documents)? documentsUpdated,
    TResult? Function(int? limit)? loadMoreDocuments,
    TResult? Function()? resetState,
  }) {
    return updateDocument?.call(document);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult Function(String query, int? limit)? searchDocuments,
    TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult Function(String sortBy, bool ascending)? sortDocuments,
    TResult Function(String documentId, String userId)? deleteDocument,
    TResult Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult Function(String documentId, String userId)? restoreDocument,
    TResult Function(DocumentModel document)? updateDocument,
    TResult Function(bool forceRefresh)? refreshDocuments,
    TResult Function(int? limit)? loadRecentDocuments,
    TResult Function(int? limit)? loadDeletedDocuments,
    TResult Function(String category, int? limit)? loadDocumentsByCategory,
    TResult Function(String userId, int? limit)? loadDocumentsByUser,
    TResult Function()? loadDocumentStatistics,
    TResult Function()? syncDocuments,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<DocumentModel> documents)? documentsUpdated,
    TResult Function(int? limit)? loadMoreDocuments,
    TResult Function()? resetState,
    required TResult orElse(),
  }) {
    if (updateDocument != null) {
      return updateDocument(document);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadDocuments value) loadDocuments,
    required TResult Function(SearchDocuments value) searchDocuments,
    required TResult Function(FilterDocuments value) filterDocuments,
    required TResult Function(SortDocuments value) sortDocuments,
    required TResult Function(DeleteDocument value) deleteDocument,
    required TResult Function(PermanentlyDeleteDocument value)
    permanentlyDeleteDocument,
    required TResult Function(RestoreDocument value) restoreDocument,
    required TResult Function(UpdateDocument value) updateDocument,
    required TResult Function(RefreshDocuments value) refreshDocuments,
    required TResult Function(LoadRecentDocuments value) loadRecentDocuments,
    required TResult Function(LoadDeletedDocuments value) loadDeletedDocuments,
    required TResult Function(LoadDocumentsByCategory value)
    loadDocumentsByCategory,
    required TResult Function(LoadDocumentsByUser value) loadDocumentsByUser,
    required TResult Function(LoadDocumentStatistics value)
    loadDocumentStatistics,
    required TResult Function(SyncDocuments value) syncDocuments,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(DocumentsUpdated value) documentsUpdated,
    required TResult Function(LoadMoreDocuments value) loadMoreDocuments,
    required TResult Function(ResetState value) resetState,
  }) {
    return updateDocument(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadDocuments value)? loadDocuments,
    TResult? Function(SearchDocuments value)? searchDocuments,
    TResult? Function(FilterDocuments value)? filterDocuments,
    TResult? Function(SortDocuments value)? sortDocuments,
    TResult? Function(DeleteDocument value)? deleteDocument,
    TResult? Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult? Function(RestoreDocument value)? restoreDocument,
    TResult? Function(UpdateDocument value)? updateDocument,
    TResult? Function(RefreshDocuments value)? refreshDocuments,
    TResult? Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult? Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult? Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult? Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult? Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult? Function(SyncDocuments value)? syncDocuments,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(DocumentsUpdated value)? documentsUpdated,
    TResult? Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult? Function(ResetState value)? resetState,
  }) {
    return updateDocument?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadDocuments value)? loadDocuments,
    TResult Function(SearchDocuments value)? searchDocuments,
    TResult Function(FilterDocuments value)? filterDocuments,
    TResult Function(SortDocuments value)? sortDocuments,
    TResult Function(DeleteDocument value)? deleteDocument,
    TResult Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult Function(RestoreDocument value)? restoreDocument,
    TResult Function(UpdateDocument value)? updateDocument,
    TResult Function(RefreshDocuments value)? refreshDocuments,
    TResult Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult Function(SyncDocuments value)? syncDocuments,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(DocumentsUpdated value)? documentsUpdated,
    TResult Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult Function(ResetState value)? resetState,
    required TResult orElse(),
  }) {
    if (updateDocument != null) {
      return updateDocument(this);
    }
    return orElse();
  }
}

abstract class UpdateDocument implements DocumentEvent {
  const factory UpdateDocument({required final DocumentModel document}) =
      _$UpdateDocumentImpl;

  DocumentModel get document;

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateDocumentImplCopyWith<_$UpdateDocumentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RefreshDocumentsImplCopyWith<$Res> {
  factory _$$RefreshDocumentsImplCopyWith(
    _$RefreshDocumentsImpl value,
    $Res Function(_$RefreshDocumentsImpl) then,
  ) = __$$RefreshDocumentsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool forceRefresh});
}

/// @nodoc
class __$$RefreshDocumentsImplCopyWithImpl<$Res>
    extends _$DocumentEventCopyWithImpl<$Res, _$RefreshDocumentsImpl>
    implements _$$RefreshDocumentsImplCopyWith<$Res> {
  __$$RefreshDocumentsImplCopyWithImpl(
    _$RefreshDocumentsImpl _value,
    $Res Function(_$RefreshDocumentsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? forceRefresh = null}) {
    return _then(
      _$RefreshDocumentsImpl(
        forceRefresh: null == forceRefresh
            ? _value.forceRefresh
            : forceRefresh // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$RefreshDocumentsImpl implements RefreshDocuments {
  const _$RefreshDocumentsImpl({this.forceRefresh = true});

  @override
  @JsonKey()
  final bool forceRefresh;

  @override
  String toString() {
    return 'DocumentEvent.refreshDocuments(forceRefresh: $forceRefresh)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefreshDocumentsImpl &&
            (identical(other.forceRefresh, forceRefresh) ||
                other.forceRefresh == forceRefresh));
  }

  @override
  int get hashCode => Object.hash(runtimeType, forceRefresh);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefreshDocumentsImplCopyWith<_$RefreshDocumentsImpl> get copyWith =>
      __$$RefreshDocumentsImplCopyWithImpl<_$RefreshDocumentsImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      bool forceRefresh,
      int? limit,
      DocumentModel? startAfter,
    )
    loadDocuments,
    required TResult Function(String query, int? limit) searchDocuments,
    required TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )
    filterDocuments,
    required TResult Function(String sortBy, bool ascending) sortDocuments,
    required TResult Function(String documentId, String userId) deleteDocument,
    required TResult Function(String documentId, String userId)
    permanentlyDeleteDocument,
    required TResult Function(String documentId, String userId) restoreDocument,
    required TResult Function(DocumentModel document) updateDocument,
    required TResult Function(bool forceRefresh) refreshDocuments,
    required TResult Function(int? limit) loadRecentDocuments,
    required TResult Function(int? limit) loadDeletedDocuments,
    required TResult Function(String category, int? limit)
    loadDocumentsByCategory,
    required TResult Function(String userId, int? limit) loadDocumentsByUser,
    required TResult Function() loadDocumentStatistics,
    required TResult Function() syncDocuments,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<DocumentModel> documents) documentsUpdated,
    required TResult Function(int? limit) loadMoreDocuments,
    required TResult Function() resetState,
  }) {
    return refreshDocuments(forceRefresh);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult? Function(String query, int? limit)? searchDocuments,
    TResult? Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult? Function(String sortBy, bool ascending)? sortDocuments,
    TResult? Function(String documentId, String userId)? deleteDocument,
    TResult? Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult? Function(String documentId, String userId)? restoreDocument,
    TResult? Function(DocumentModel document)? updateDocument,
    TResult? Function(bool forceRefresh)? refreshDocuments,
    TResult? Function(int? limit)? loadRecentDocuments,
    TResult? Function(int? limit)? loadDeletedDocuments,
    TResult? Function(String category, int? limit)? loadDocumentsByCategory,
    TResult? Function(String userId, int? limit)? loadDocumentsByUser,
    TResult? Function()? loadDocumentStatistics,
    TResult? Function()? syncDocuments,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<DocumentModel> documents)? documentsUpdated,
    TResult? Function(int? limit)? loadMoreDocuments,
    TResult? Function()? resetState,
  }) {
    return refreshDocuments?.call(forceRefresh);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult Function(String query, int? limit)? searchDocuments,
    TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult Function(String sortBy, bool ascending)? sortDocuments,
    TResult Function(String documentId, String userId)? deleteDocument,
    TResult Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult Function(String documentId, String userId)? restoreDocument,
    TResult Function(DocumentModel document)? updateDocument,
    TResult Function(bool forceRefresh)? refreshDocuments,
    TResult Function(int? limit)? loadRecentDocuments,
    TResult Function(int? limit)? loadDeletedDocuments,
    TResult Function(String category, int? limit)? loadDocumentsByCategory,
    TResult Function(String userId, int? limit)? loadDocumentsByUser,
    TResult Function()? loadDocumentStatistics,
    TResult Function()? syncDocuments,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<DocumentModel> documents)? documentsUpdated,
    TResult Function(int? limit)? loadMoreDocuments,
    TResult Function()? resetState,
    required TResult orElse(),
  }) {
    if (refreshDocuments != null) {
      return refreshDocuments(forceRefresh);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadDocuments value) loadDocuments,
    required TResult Function(SearchDocuments value) searchDocuments,
    required TResult Function(FilterDocuments value) filterDocuments,
    required TResult Function(SortDocuments value) sortDocuments,
    required TResult Function(DeleteDocument value) deleteDocument,
    required TResult Function(PermanentlyDeleteDocument value)
    permanentlyDeleteDocument,
    required TResult Function(RestoreDocument value) restoreDocument,
    required TResult Function(UpdateDocument value) updateDocument,
    required TResult Function(RefreshDocuments value) refreshDocuments,
    required TResult Function(LoadRecentDocuments value) loadRecentDocuments,
    required TResult Function(LoadDeletedDocuments value) loadDeletedDocuments,
    required TResult Function(LoadDocumentsByCategory value)
    loadDocumentsByCategory,
    required TResult Function(LoadDocumentsByUser value) loadDocumentsByUser,
    required TResult Function(LoadDocumentStatistics value)
    loadDocumentStatistics,
    required TResult Function(SyncDocuments value) syncDocuments,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(DocumentsUpdated value) documentsUpdated,
    required TResult Function(LoadMoreDocuments value) loadMoreDocuments,
    required TResult Function(ResetState value) resetState,
  }) {
    return refreshDocuments(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadDocuments value)? loadDocuments,
    TResult? Function(SearchDocuments value)? searchDocuments,
    TResult? Function(FilterDocuments value)? filterDocuments,
    TResult? Function(SortDocuments value)? sortDocuments,
    TResult? Function(DeleteDocument value)? deleteDocument,
    TResult? Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult? Function(RestoreDocument value)? restoreDocument,
    TResult? Function(UpdateDocument value)? updateDocument,
    TResult? Function(RefreshDocuments value)? refreshDocuments,
    TResult? Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult? Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult? Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult? Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult? Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult? Function(SyncDocuments value)? syncDocuments,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(DocumentsUpdated value)? documentsUpdated,
    TResult? Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult? Function(ResetState value)? resetState,
  }) {
    return refreshDocuments?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadDocuments value)? loadDocuments,
    TResult Function(SearchDocuments value)? searchDocuments,
    TResult Function(FilterDocuments value)? filterDocuments,
    TResult Function(SortDocuments value)? sortDocuments,
    TResult Function(DeleteDocument value)? deleteDocument,
    TResult Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult Function(RestoreDocument value)? restoreDocument,
    TResult Function(UpdateDocument value)? updateDocument,
    TResult Function(RefreshDocuments value)? refreshDocuments,
    TResult Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult Function(SyncDocuments value)? syncDocuments,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(DocumentsUpdated value)? documentsUpdated,
    TResult Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult Function(ResetState value)? resetState,
    required TResult orElse(),
  }) {
    if (refreshDocuments != null) {
      return refreshDocuments(this);
    }
    return orElse();
  }
}

abstract class RefreshDocuments implements DocumentEvent {
  const factory RefreshDocuments({final bool forceRefresh}) =
      _$RefreshDocumentsImpl;

  bool get forceRefresh;

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefreshDocumentsImplCopyWith<_$RefreshDocumentsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadRecentDocumentsImplCopyWith<$Res> {
  factory _$$LoadRecentDocumentsImplCopyWith(
    _$LoadRecentDocumentsImpl value,
    $Res Function(_$LoadRecentDocumentsImpl) then,
  ) = __$$LoadRecentDocumentsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int? limit});
}

/// @nodoc
class __$$LoadRecentDocumentsImplCopyWithImpl<$Res>
    extends _$DocumentEventCopyWithImpl<$Res, _$LoadRecentDocumentsImpl>
    implements _$$LoadRecentDocumentsImplCopyWith<$Res> {
  __$$LoadRecentDocumentsImplCopyWithImpl(
    _$LoadRecentDocumentsImpl _value,
    $Res Function(_$LoadRecentDocumentsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? limit = freezed}) {
    return _then(
      _$LoadRecentDocumentsImpl(
        limit: freezed == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$LoadRecentDocumentsImpl implements LoadRecentDocuments {
  const _$LoadRecentDocumentsImpl({this.limit});

  @override
  final int? limit;

  @override
  String toString() {
    return 'DocumentEvent.loadRecentDocuments(limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadRecentDocumentsImpl &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @override
  int get hashCode => Object.hash(runtimeType, limit);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadRecentDocumentsImplCopyWith<_$LoadRecentDocumentsImpl> get copyWith =>
      __$$LoadRecentDocumentsImplCopyWithImpl<_$LoadRecentDocumentsImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      bool forceRefresh,
      int? limit,
      DocumentModel? startAfter,
    )
    loadDocuments,
    required TResult Function(String query, int? limit) searchDocuments,
    required TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )
    filterDocuments,
    required TResult Function(String sortBy, bool ascending) sortDocuments,
    required TResult Function(String documentId, String userId) deleteDocument,
    required TResult Function(String documentId, String userId)
    permanentlyDeleteDocument,
    required TResult Function(String documentId, String userId) restoreDocument,
    required TResult Function(DocumentModel document) updateDocument,
    required TResult Function(bool forceRefresh) refreshDocuments,
    required TResult Function(int? limit) loadRecentDocuments,
    required TResult Function(int? limit) loadDeletedDocuments,
    required TResult Function(String category, int? limit)
    loadDocumentsByCategory,
    required TResult Function(String userId, int? limit) loadDocumentsByUser,
    required TResult Function() loadDocumentStatistics,
    required TResult Function() syncDocuments,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<DocumentModel> documents) documentsUpdated,
    required TResult Function(int? limit) loadMoreDocuments,
    required TResult Function() resetState,
  }) {
    return loadRecentDocuments(limit);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult? Function(String query, int? limit)? searchDocuments,
    TResult? Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult? Function(String sortBy, bool ascending)? sortDocuments,
    TResult? Function(String documentId, String userId)? deleteDocument,
    TResult? Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult? Function(String documentId, String userId)? restoreDocument,
    TResult? Function(DocumentModel document)? updateDocument,
    TResult? Function(bool forceRefresh)? refreshDocuments,
    TResult? Function(int? limit)? loadRecentDocuments,
    TResult? Function(int? limit)? loadDeletedDocuments,
    TResult? Function(String category, int? limit)? loadDocumentsByCategory,
    TResult? Function(String userId, int? limit)? loadDocumentsByUser,
    TResult? Function()? loadDocumentStatistics,
    TResult? Function()? syncDocuments,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<DocumentModel> documents)? documentsUpdated,
    TResult? Function(int? limit)? loadMoreDocuments,
    TResult? Function()? resetState,
  }) {
    return loadRecentDocuments?.call(limit);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult Function(String query, int? limit)? searchDocuments,
    TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult Function(String sortBy, bool ascending)? sortDocuments,
    TResult Function(String documentId, String userId)? deleteDocument,
    TResult Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult Function(String documentId, String userId)? restoreDocument,
    TResult Function(DocumentModel document)? updateDocument,
    TResult Function(bool forceRefresh)? refreshDocuments,
    TResult Function(int? limit)? loadRecentDocuments,
    TResult Function(int? limit)? loadDeletedDocuments,
    TResult Function(String category, int? limit)? loadDocumentsByCategory,
    TResult Function(String userId, int? limit)? loadDocumentsByUser,
    TResult Function()? loadDocumentStatistics,
    TResult Function()? syncDocuments,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<DocumentModel> documents)? documentsUpdated,
    TResult Function(int? limit)? loadMoreDocuments,
    TResult Function()? resetState,
    required TResult orElse(),
  }) {
    if (loadRecentDocuments != null) {
      return loadRecentDocuments(limit);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadDocuments value) loadDocuments,
    required TResult Function(SearchDocuments value) searchDocuments,
    required TResult Function(FilterDocuments value) filterDocuments,
    required TResult Function(SortDocuments value) sortDocuments,
    required TResult Function(DeleteDocument value) deleteDocument,
    required TResult Function(PermanentlyDeleteDocument value)
    permanentlyDeleteDocument,
    required TResult Function(RestoreDocument value) restoreDocument,
    required TResult Function(UpdateDocument value) updateDocument,
    required TResult Function(RefreshDocuments value) refreshDocuments,
    required TResult Function(LoadRecentDocuments value) loadRecentDocuments,
    required TResult Function(LoadDeletedDocuments value) loadDeletedDocuments,
    required TResult Function(LoadDocumentsByCategory value)
    loadDocumentsByCategory,
    required TResult Function(LoadDocumentsByUser value) loadDocumentsByUser,
    required TResult Function(LoadDocumentStatistics value)
    loadDocumentStatistics,
    required TResult Function(SyncDocuments value) syncDocuments,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(DocumentsUpdated value) documentsUpdated,
    required TResult Function(LoadMoreDocuments value) loadMoreDocuments,
    required TResult Function(ResetState value) resetState,
  }) {
    return loadRecentDocuments(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadDocuments value)? loadDocuments,
    TResult? Function(SearchDocuments value)? searchDocuments,
    TResult? Function(FilterDocuments value)? filterDocuments,
    TResult? Function(SortDocuments value)? sortDocuments,
    TResult? Function(DeleteDocument value)? deleteDocument,
    TResult? Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult? Function(RestoreDocument value)? restoreDocument,
    TResult? Function(UpdateDocument value)? updateDocument,
    TResult? Function(RefreshDocuments value)? refreshDocuments,
    TResult? Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult? Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult? Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult? Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult? Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult? Function(SyncDocuments value)? syncDocuments,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(DocumentsUpdated value)? documentsUpdated,
    TResult? Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult? Function(ResetState value)? resetState,
  }) {
    return loadRecentDocuments?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadDocuments value)? loadDocuments,
    TResult Function(SearchDocuments value)? searchDocuments,
    TResult Function(FilterDocuments value)? filterDocuments,
    TResult Function(SortDocuments value)? sortDocuments,
    TResult Function(DeleteDocument value)? deleteDocument,
    TResult Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult Function(RestoreDocument value)? restoreDocument,
    TResult Function(UpdateDocument value)? updateDocument,
    TResult Function(RefreshDocuments value)? refreshDocuments,
    TResult Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult Function(SyncDocuments value)? syncDocuments,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(DocumentsUpdated value)? documentsUpdated,
    TResult Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult Function(ResetState value)? resetState,
    required TResult orElse(),
  }) {
    if (loadRecentDocuments != null) {
      return loadRecentDocuments(this);
    }
    return orElse();
  }
}

abstract class LoadRecentDocuments implements DocumentEvent {
  const factory LoadRecentDocuments({final int? limit}) =
      _$LoadRecentDocumentsImpl;

  int? get limit;

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadRecentDocumentsImplCopyWith<_$LoadRecentDocumentsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadDeletedDocumentsImplCopyWith<$Res> {
  factory _$$LoadDeletedDocumentsImplCopyWith(
    _$LoadDeletedDocumentsImpl value,
    $Res Function(_$LoadDeletedDocumentsImpl) then,
  ) = __$$LoadDeletedDocumentsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int? limit});
}

/// @nodoc
class __$$LoadDeletedDocumentsImplCopyWithImpl<$Res>
    extends _$DocumentEventCopyWithImpl<$Res, _$LoadDeletedDocumentsImpl>
    implements _$$LoadDeletedDocumentsImplCopyWith<$Res> {
  __$$LoadDeletedDocumentsImplCopyWithImpl(
    _$LoadDeletedDocumentsImpl _value,
    $Res Function(_$LoadDeletedDocumentsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? limit = freezed}) {
    return _then(
      _$LoadDeletedDocumentsImpl(
        limit: freezed == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$LoadDeletedDocumentsImpl implements LoadDeletedDocuments {
  const _$LoadDeletedDocumentsImpl({this.limit});

  @override
  final int? limit;

  @override
  String toString() {
    return 'DocumentEvent.loadDeletedDocuments(limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadDeletedDocumentsImpl &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @override
  int get hashCode => Object.hash(runtimeType, limit);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadDeletedDocumentsImplCopyWith<_$LoadDeletedDocumentsImpl>
  get copyWith =>
      __$$LoadDeletedDocumentsImplCopyWithImpl<_$LoadDeletedDocumentsImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      bool forceRefresh,
      int? limit,
      DocumentModel? startAfter,
    )
    loadDocuments,
    required TResult Function(String query, int? limit) searchDocuments,
    required TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )
    filterDocuments,
    required TResult Function(String sortBy, bool ascending) sortDocuments,
    required TResult Function(String documentId, String userId) deleteDocument,
    required TResult Function(String documentId, String userId)
    permanentlyDeleteDocument,
    required TResult Function(String documentId, String userId) restoreDocument,
    required TResult Function(DocumentModel document) updateDocument,
    required TResult Function(bool forceRefresh) refreshDocuments,
    required TResult Function(int? limit) loadRecentDocuments,
    required TResult Function(int? limit) loadDeletedDocuments,
    required TResult Function(String category, int? limit)
    loadDocumentsByCategory,
    required TResult Function(String userId, int? limit) loadDocumentsByUser,
    required TResult Function() loadDocumentStatistics,
    required TResult Function() syncDocuments,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<DocumentModel> documents) documentsUpdated,
    required TResult Function(int? limit) loadMoreDocuments,
    required TResult Function() resetState,
  }) {
    return loadDeletedDocuments(limit);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult? Function(String query, int? limit)? searchDocuments,
    TResult? Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult? Function(String sortBy, bool ascending)? sortDocuments,
    TResult? Function(String documentId, String userId)? deleteDocument,
    TResult? Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult? Function(String documentId, String userId)? restoreDocument,
    TResult? Function(DocumentModel document)? updateDocument,
    TResult? Function(bool forceRefresh)? refreshDocuments,
    TResult? Function(int? limit)? loadRecentDocuments,
    TResult? Function(int? limit)? loadDeletedDocuments,
    TResult? Function(String category, int? limit)? loadDocumentsByCategory,
    TResult? Function(String userId, int? limit)? loadDocumentsByUser,
    TResult? Function()? loadDocumentStatistics,
    TResult? Function()? syncDocuments,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<DocumentModel> documents)? documentsUpdated,
    TResult? Function(int? limit)? loadMoreDocuments,
    TResult? Function()? resetState,
  }) {
    return loadDeletedDocuments?.call(limit);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult Function(String query, int? limit)? searchDocuments,
    TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult Function(String sortBy, bool ascending)? sortDocuments,
    TResult Function(String documentId, String userId)? deleteDocument,
    TResult Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult Function(String documentId, String userId)? restoreDocument,
    TResult Function(DocumentModel document)? updateDocument,
    TResult Function(bool forceRefresh)? refreshDocuments,
    TResult Function(int? limit)? loadRecentDocuments,
    TResult Function(int? limit)? loadDeletedDocuments,
    TResult Function(String category, int? limit)? loadDocumentsByCategory,
    TResult Function(String userId, int? limit)? loadDocumentsByUser,
    TResult Function()? loadDocumentStatistics,
    TResult Function()? syncDocuments,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<DocumentModel> documents)? documentsUpdated,
    TResult Function(int? limit)? loadMoreDocuments,
    TResult Function()? resetState,
    required TResult orElse(),
  }) {
    if (loadDeletedDocuments != null) {
      return loadDeletedDocuments(limit);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadDocuments value) loadDocuments,
    required TResult Function(SearchDocuments value) searchDocuments,
    required TResult Function(FilterDocuments value) filterDocuments,
    required TResult Function(SortDocuments value) sortDocuments,
    required TResult Function(DeleteDocument value) deleteDocument,
    required TResult Function(PermanentlyDeleteDocument value)
    permanentlyDeleteDocument,
    required TResult Function(RestoreDocument value) restoreDocument,
    required TResult Function(UpdateDocument value) updateDocument,
    required TResult Function(RefreshDocuments value) refreshDocuments,
    required TResult Function(LoadRecentDocuments value) loadRecentDocuments,
    required TResult Function(LoadDeletedDocuments value) loadDeletedDocuments,
    required TResult Function(LoadDocumentsByCategory value)
    loadDocumentsByCategory,
    required TResult Function(LoadDocumentsByUser value) loadDocumentsByUser,
    required TResult Function(LoadDocumentStatistics value)
    loadDocumentStatistics,
    required TResult Function(SyncDocuments value) syncDocuments,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(DocumentsUpdated value) documentsUpdated,
    required TResult Function(LoadMoreDocuments value) loadMoreDocuments,
    required TResult Function(ResetState value) resetState,
  }) {
    return loadDeletedDocuments(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadDocuments value)? loadDocuments,
    TResult? Function(SearchDocuments value)? searchDocuments,
    TResult? Function(FilterDocuments value)? filterDocuments,
    TResult? Function(SortDocuments value)? sortDocuments,
    TResult? Function(DeleteDocument value)? deleteDocument,
    TResult? Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult? Function(RestoreDocument value)? restoreDocument,
    TResult? Function(UpdateDocument value)? updateDocument,
    TResult? Function(RefreshDocuments value)? refreshDocuments,
    TResult? Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult? Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult? Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult? Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult? Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult? Function(SyncDocuments value)? syncDocuments,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(DocumentsUpdated value)? documentsUpdated,
    TResult? Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult? Function(ResetState value)? resetState,
  }) {
    return loadDeletedDocuments?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadDocuments value)? loadDocuments,
    TResult Function(SearchDocuments value)? searchDocuments,
    TResult Function(FilterDocuments value)? filterDocuments,
    TResult Function(SortDocuments value)? sortDocuments,
    TResult Function(DeleteDocument value)? deleteDocument,
    TResult Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult Function(RestoreDocument value)? restoreDocument,
    TResult Function(UpdateDocument value)? updateDocument,
    TResult Function(RefreshDocuments value)? refreshDocuments,
    TResult Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult Function(SyncDocuments value)? syncDocuments,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(DocumentsUpdated value)? documentsUpdated,
    TResult Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult Function(ResetState value)? resetState,
    required TResult orElse(),
  }) {
    if (loadDeletedDocuments != null) {
      return loadDeletedDocuments(this);
    }
    return orElse();
  }
}

abstract class LoadDeletedDocuments implements DocumentEvent {
  const factory LoadDeletedDocuments({final int? limit}) =
      _$LoadDeletedDocumentsImpl;

  int? get limit;

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadDeletedDocumentsImplCopyWith<_$LoadDeletedDocumentsImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadDocumentsByCategoryImplCopyWith<$Res> {
  factory _$$LoadDocumentsByCategoryImplCopyWith(
    _$LoadDocumentsByCategoryImpl value,
    $Res Function(_$LoadDocumentsByCategoryImpl) then,
  ) = __$$LoadDocumentsByCategoryImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String category, int? limit});
}

/// @nodoc
class __$$LoadDocumentsByCategoryImplCopyWithImpl<$Res>
    extends _$DocumentEventCopyWithImpl<$Res, _$LoadDocumentsByCategoryImpl>
    implements _$$LoadDocumentsByCategoryImplCopyWith<$Res> {
  __$$LoadDocumentsByCategoryImplCopyWithImpl(
    _$LoadDocumentsByCategoryImpl _value,
    $Res Function(_$LoadDocumentsByCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? category = null, Object? limit = freezed}) {
    return _then(
      _$LoadDocumentsByCategoryImpl(
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        limit: freezed == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$LoadDocumentsByCategoryImpl implements LoadDocumentsByCategory {
  const _$LoadDocumentsByCategoryImpl({required this.category, this.limit});

  @override
  final String category;
  @override
  final int? limit;

  @override
  String toString() {
    return 'DocumentEvent.loadDocumentsByCategory(category: $category, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadDocumentsByCategoryImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @override
  int get hashCode => Object.hash(runtimeType, category, limit);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadDocumentsByCategoryImplCopyWith<_$LoadDocumentsByCategoryImpl>
  get copyWith =>
      __$$LoadDocumentsByCategoryImplCopyWithImpl<
        _$LoadDocumentsByCategoryImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      bool forceRefresh,
      int? limit,
      DocumentModel? startAfter,
    )
    loadDocuments,
    required TResult Function(String query, int? limit) searchDocuments,
    required TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )
    filterDocuments,
    required TResult Function(String sortBy, bool ascending) sortDocuments,
    required TResult Function(String documentId, String userId) deleteDocument,
    required TResult Function(String documentId, String userId)
    permanentlyDeleteDocument,
    required TResult Function(String documentId, String userId) restoreDocument,
    required TResult Function(DocumentModel document) updateDocument,
    required TResult Function(bool forceRefresh) refreshDocuments,
    required TResult Function(int? limit) loadRecentDocuments,
    required TResult Function(int? limit) loadDeletedDocuments,
    required TResult Function(String category, int? limit)
    loadDocumentsByCategory,
    required TResult Function(String userId, int? limit) loadDocumentsByUser,
    required TResult Function() loadDocumentStatistics,
    required TResult Function() syncDocuments,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<DocumentModel> documents) documentsUpdated,
    required TResult Function(int? limit) loadMoreDocuments,
    required TResult Function() resetState,
  }) {
    return loadDocumentsByCategory(category, limit);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult? Function(String query, int? limit)? searchDocuments,
    TResult? Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult? Function(String sortBy, bool ascending)? sortDocuments,
    TResult? Function(String documentId, String userId)? deleteDocument,
    TResult? Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult? Function(String documentId, String userId)? restoreDocument,
    TResult? Function(DocumentModel document)? updateDocument,
    TResult? Function(bool forceRefresh)? refreshDocuments,
    TResult? Function(int? limit)? loadRecentDocuments,
    TResult? Function(int? limit)? loadDeletedDocuments,
    TResult? Function(String category, int? limit)? loadDocumentsByCategory,
    TResult? Function(String userId, int? limit)? loadDocumentsByUser,
    TResult? Function()? loadDocumentStatistics,
    TResult? Function()? syncDocuments,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<DocumentModel> documents)? documentsUpdated,
    TResult? Function(int? limit)? loadMoreDocuments,
    TResult? Function()? resetState,
  }) {
    return loadDocumentsByCategory?.call(category, limit);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult Function(String query, int? limit)? searchDocuments,
    TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult Function(String sortBy, bool ascending)? sortDocuments,
    TResult Function(String documentId, String userId)? deleteDocument,
    TResult Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult Function(String documentId, String userId)? restoreDocument,
    TResult Function(DocumentModel document)? updateDocument,
    TResult Function(bool forceRefresh)? refreshDocuments,
    TResult Function(int? limit)? loadRecentDocuments,
    TResult Function(int? limit)? loadDeletedDocuments,
    TResult Function(String category, int? limit)? loadDocumentsByCategory,
    TResult Function(String userId, int? limit)? loadDocumentsByUser,
    TResult Function()? loadDocumentStatistics,
    TResult Function()? syncDocuments,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<DocumentModel> documents)? documentsUpdated,
    TResult Function(int? limit)? loadMoreDocuments,
    TResult Function()? resetState,
    required TResult orElse(),
  }) {
    if (loadDocumentsByCategory != null) {
      return loadDocumentsByCategory(category, limit);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadDocuments value) loadDocuments,
    required TResult Function(SearchDocuments value) searchDocuments,
    required TResult Function(FilterDocuments value) filterDocuments,
    required TResult Function(SortDocuments value) sortDocuments,
    required TResult Function(DeleteDocument value) deleteDocument,
    required TResult Function(PermanentlyDeleteDocument value)
    permanentlyDeleteDocument,
    required TResult Function(RestoreDocument value) restoreDocument,
    required TResult Function(UpdateDocument value) updateDocument,
    required TResult Function(RefreshDocuments value) refreshDocuments,
    required TResult Function(LoadRecentDocuments value) loadRecentDocuments,
    required TResult Function(LoadDeletedDocuments value) loadDeletedDocuments,
    required TResult Function(LoadDocumentsByCategory value)
    loadDocumentsByCategory,
    required TResult Function(LoadDocumentsByUser value) loadDocumentsByUser,
    required TResult Function(LoadDocumentStatistics value)
    loadDocumentStatistics,
    required TResult Function(SyncDocuments value) syncDocuments,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(DocumentsUpdated value) documentsUpdated,
    required TResult Function(LoadMoreDocuments value) loadMoreDocuments,
    required TResult Function(ResetState value) resetState,
  }) {
    return loadDocumentsByCategory(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadDocuments value)? loadDocuments,
    TResult? Function(SearchDocuments value)? searchDocuments,
    TResult? Function(FilterDocuments value)? filterDocuments,
    TResult? Function(SortDocuments value)? sortDocuments,
    TResult? Function(DeleteDocument value)? deleteDocument,
    TResult? Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult? Function(RestoreDocument value)? restoreDocument,
    TResult? Function(UpdateDocument value)? updateDocument,
    TResult? Function(RefreshDocuments value)? refreshDocuments,
    TResult? Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult? Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult? Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult? Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult? Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult? Function(SyncDocuments value)? syncDocuments,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(DocumentsUpdated value)? documentsUpdated,
    TResult? Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult? Function(ResetState value)? resetState,
  }) {
    return loadDocumentsByCategory?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadDocuments value)? loadDocuments,
    TResult Function(SearchDocuments value)? searchDocuments,
    TResult Function(FilterDocuments value)? filterDocuments,
    TResult Function(SortDocuments value)? sortDocuments,
    TResult Function(DeleteDocument value)? deleteDocument,
    TResult Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult Function(RestoreDocument value)? restoreDocument,
    TResult Function(UpdateDocument value)? updateDocument,
    TResult Function(RefreshDocuments value)? refreshDocuments,
    TResult Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult Function(SyncDocuments value)? syncDocuments,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(DocumentsUpdated value)? documentsUpdated,
    TResult Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult Function(ResetState value)? resetState,
    required TResult orElse(),
  }) {
    if (loadDocumentsByCategory != null) {
      return loadDocumentsByCategory(this);
    }
    return orElse();
  }
}

abstract class LoadDocumentsByCategory implements DocumentEvent {
  const factory LoadDocumentsByCategory({
    required final String category,
    final int? limit,
  }) = _$LoadDocumentsByCategoryImpl;

  String get category;
  int? get limit;

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadDocumentsByCategoryImplCopyWith<_$LoadDocumentsByCategoryImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadDocumentsByUserImplCopyWith<$Res> {
  factory _$$LoadDocumentsByUserImplCopyWith(
    _$LoadDocumentsByUserImpl value,
    $Res Function(_$LoadDocumentsByUserImpl) then,
  ) = __$$LoadDocumentsByUserImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String userId, int? limit});
}

/// @nodoc
class __$$LoadDocumentsByUserImplCopyWithImpl<$Res>
    extends _$DocumentEventCopyWithImpl<$Res, _$LoadDocumentsByUserImpl>
    implements _$$LoadDocumentsByUserImplCopyWith<$Res> {
  __$$LoadDocumentsByUserImplCopyWithImpl(
    _$LoadDocumentsByUserImpl _value,
    $Res Function(_$LoadDocumentsByUserImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? userId = null, Object? limit = freezed}) {
    return _then(
      _$LoadDocumentsByUserImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        limit: freezed == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$LoadDocumentsByUserImpl implements LoadDocumentsByUser {
  const _$LoadDocumentsByUserImpl({required this.userId, this.limit});

  @override
  final String userId;
  @override
  final int? limit;

  @override
  String toString() {
    return 'DocumentEvent.loadDocumentsByUser(userId: $userId, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadDocumentsByUserImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, limit);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadDocumentsByUserImplCopyWith<_$LoadDocumentsByUserImpl> get copyWith =>
      __$$LoadDocumentsByUserImplCopyWithImpl<_$LoadDocumentsByUserImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      bool forceRefresh,
      int? limit,
      DocumentModel? startAfter,
    )
    loadDocuments,
    required TResult Function(String query, int? limit) searchDocuments,
    required TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )
    filterDocuments,
    required TResult Function(String sortBy, bool ascending) sortDocuments,
    required TResult Function(String documentId, String userId) deleteDocument,
    required TResult Function(String documentId, String userId)
    permanentlyDeleteDocument,
    required TResult Function(String documentId, String userId) restoreDocument,
    required TResult Function(DocumentModel document) updateDocument,
    required TResult Function(bool forceRefresh) refreshDocuments,
    required TResult Function(int? limit) loadRecentDocuments,
    required TResult Function(int? limit) loadDeletedDocuments,
    required TResult Function(String category, int? limit)
    loadDocumentsByCategory,
    required TResult Function(String userId, int? limit) loadDocumentsByUser,
    required TResult Function() loadDocumentStatistics,
    required TResult Function() syncDocuments,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<DocumentModel> documents) documentsUpdated,
    required TResult Function(int? limit) loadMoreDocuments,
    required TResult Function() resetState,
  }) {
    return loadDocumentsByUser(userId, limit);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult? Function(String query, int? limit)? searchDocuments,
    TResult? Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult? Function(String sortBy, bool ascending)? sortDocuments,
    TResult? Function(String documentId, String userId)? deleteDocument,
    TResult? Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult? Function(String documentId, String userId)? restoreDocument,
    TResult? Function(DocumentModel document)? updateDocument,
    TResult? Function(bool forceRefresh)? refreshDocuments,
    TResult? Function(int? limit)? loadRecentDocuments,
    TResult? Function(int? limit)? loadDeletedDocuments,
    TResult? Function(String category, int? limit)? loadDocumentsByCategory,
    TResult? Function(String userId, int? limit)? loadDocumentsByUser,
    TResult? Function()? loadDocumentStatistics,
    TResult? Function()? syncDocuments,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<DocumentModel> documents)? documentsUpdated,
    TResult? Function(int? limit)? loadMoreDocuments,
    TResult? Function()? resetState,
  }) {
    return loadDocumentsByUser?.call(userId, limit);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult Function(String query, int? limit)? searchDocuments,
    TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult Function(String sortBy, bool ascending)? sortDocuments,
    TResult Function(String documentId, String userId)? deleteDocument,
    TResult Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult Function(String documentId, String userId)? restoreDocument,
    TResult Function(DocumentModel document)? updateDocument,
    TResult Function(bool forceRefresh)? refreshDocuments,
    TResult Function(int? limit)? loadRecentDocuments,
    TResult Function(int? limit)? loadDeletedDocuments,
    TResult Function(String category, int? limit)? loadDocumentsByCategory,
    TResult Function(String userId, int? limit)? loadDocumentsByUser,
    TResult Function()? loadDocumentStatistics,
    TResult Function()? syncDocuments,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<DocumentModel> documents)? documentsUpdated,
    TResult Function(int? limit)? loadMoreDocuments,
    TResult Function()? resetState,
    required TResult orElse(),
  }) {
    if (loadDocumentsByUser != null) {
      return loadDocumentsByUser(userId, limit);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadDocuments value) loadDocuments,
    required TResult Function(SearchDocuments value) searchDocuments,
    required TResult Function(FilterDocuments value) filterDocuments,
    required TResult Function(SortDocuments value) sortDocuments,
    required TResult Function(DeleteDocument value) deleteDocument,
    required TResult Function(PermanentlyDeleteDocument value)
    permanentlyDeleteDocument,
    required TResult Function(RestoreDocument value) restoreDocument,
    required TResult Function(UpdateDocument value) updateDocument,
    required TResult Function(RefreshDocuments value) refreshDocuments,
    required TResult Function(LoadRecentDocuments value) loadRecentDocuments,
    required TResult Function(LoadDeletedDocuments value) loadDeletedDocuments,
    required TResult Function(LoadDocumentsByCategory value)
    loadDocumentsByCategory,
    required TResult Function(LoadDocumentsByUser value) loadDocumentsByUser,
    required TResult Function(LoadDocumentStatistics value)
    loadDocumentStatistics,
    required TResult Function(SyncDocuments value) syncDocuments,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(DocumentsUpdated value) documentsUpdated,
    required TResult Function(LoadMoreDocuments value) loadMoreDocuments,
    required TResult Function(ResetState value) resetState,
  }) {
    return loadDocumentsByUser(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadDocuments value)? loadDocuments,
    TResult? Function(SearchDocuments value)? searchDocuments,
    TResult? Function(FilterDocuments value)? filterDocuments,
    TResult? Function(SortDocuments value)? sortDocuments,
    TResult? Function(DeleteDocument value)? deleteDocument,
    TResult? Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult? Function(RestoreDocument value)? restoreDocument,
    TResult? Function(UpdateDocument value)? updateDocument,
    TResult? Function(RefreshDocuments value)? refreshDocuments,
    TResult? Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult? Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult? Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult? Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult? Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult? Function(SyncDocuments value)? syncDocuments,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(DocumentsUpdated value)? documentsUpdated,
    TResult? Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult? Function(ResetState value)? resetState,
  }) {
    return loadDocumentsByUser?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadDocuments value)? loadDocuments,
    TResult Function(SearchDocuments value)? searchDocuments,
    TResult Function(FilterDocuments value)? filterDocuments,
    TResult Function(SortDocuments value)? sortDocuments,
    TResult Function(DeleteDocument value)? deleteDocument,
    TResult Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult Function(RestoreDocument value)? restoreDocument,
    TResult Function(UpdateDocument value)? updateDocument,
    TResult Function(RefreshDocuments value)? refreshDocuments,
    TResult Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult Function(SyncDocuments value)? syncDocuments,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(DocumentsUpdated value)? documentsUpdated,
    TResult Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult Function(ResetState value)? resetState,
    required TResult orElse(),
  }) {
    if (loadDocumentsByUser != null) {
      return loadDocumentsByUser(this);
    }
    return orElse();
  }
}

abstract class LoadDocumentsByUser implements DocumentEvent {
  const factory LoadDocumentsByUser({
    required final String userId,
    final int? limit,
  }) = _$LoadDocumentsByUserImpl;

  String get userId;
  int? get limit;

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadDocumentsByUserImplCopyWith<_$LoadDocumentsByUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadDocumentStatisticsImplCopyWith<$Res> {
  factory _$$LoadDocumentStatisticsImplCopyWith(
    _$LoadDocumentStatisticsImpl value,
    $Res Function(_$LoadDocumentStatisticsImpl) then,
  ) = __$$LoadDocumentStatisticsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadDocumentStatisticsImplCopyWithImpl<$Res>
    extends _$DocumentEventCopyWithImpl<$Res, _$LoadDocumentStatisticsImpl>
    implements _$$LoadDocumentStatisticsImplCopyWith<$Res> {
  __$$LoadDocumentStatisticsImplCopyWithImpl(
    _$LoadDocumentStatisticsImpl _value,
    $Res Function(_$LoadDocumentStatisticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadDocumentStatisticsImpl implements LoadDocumentStatistics {
  const _$LoadDocumentStatisticsImpl();

  @override
  String toString() {
    return 'DocumentEvent.loadDocumentStatistics()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadDocumentStatisticsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      bool forceRefresh,
      int? limit,
      DocumentModel? startAfter,
    )
    loadDocuments,
    required TResult Function(String query, int? limit) searchDocuments,
    required TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )
    filterDocuments,
    required TResult Function(String sortBy, bool ascending) sortDocuments,
    required TResult Function(String documentId, String userId) deleteDocument,
    required TResult Function(String documentId, String userId)
    permanentlyDeleteDocument,
    required TResult Function(String documentId, String userId) restoreDocument,
    required TResult Function(DocumentModel document) updateDocument,
    required TResult Function(bool forceRefresh) refreshDocuments,
    required TResult Function(int? limit) loadRecentDocuments,
    required TResult Function(int? limit) loadDeletedDocuments,
    required TResult Function(String category, int? limit)
    loadDocumentsByCategory,
    required TResult Function(String userId, int? limit) loadDocumentsByUser,
    required TResult Function() loadDocumentStatistics,
    required TResult Function() syncDocuments,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<DocumentModel> documents) documentsUpdated,
    required TResult Function(int? limit) loadMoreDocuments,
    required TResult Function() resetState,
  }) {
    return loadDocumentStatistics();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult? Function(String query, int? limit)? searchDocuments,
    TResult? Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult? Function(String sortBy, bool ascending)? sortDocuments,
    TResult? Function(String documentId, String userId)? deleteDocument,
    TResult? Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult? Function(String documentId, String userId)? restoreDocument,
    TResult? Function(DocumentModel document)? updateDocument,
    TResult? Function(bool forceRefresh)? refreshDocuments,
    TResult? Function(int? limit)? loadRecentDocuments,
    TResult? Function(int? limit)? loadDeletedDocuments,
    TResult? Function(String category, int? limit)? loadDocumentsByCategory,
    TResult? Function(String userId, int? limit)? loadDocumentsByUser,
    TResult? Function()? loadDocumentStatistics,
    TResult? Function()? syncDocuments,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<DocumentModel> documents)? documentsUpdated,
    TResult? Function(int? limit)? loadMoreDocuments,
    TResult? Function()? resetState,
  }) {
    return loadDocumentStatistics?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult Function(String query, int? limit)? searchDocuments,
    TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult Function(String sortBy, bool ascending)? sortDocuments,
    TResult Function(String documentId, String userId)? deleteDocument,
    TResult Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult Function(String documentId, String userId)? restoreDocument,
    TResult Function(DocumentModel document)? updateDocument,
    TResult Function(bool forceRefresh)? refreshDocuments,
    TResult Function(int? limit)? loadRecentDocuments,
    TResult Function(int? limit)? loadDeletedDocuments,
    TResult Function(String category, int? limit)? loadDocumentsByCategory,
    TResult Function(String userId, int? limit)? loadDocumentsByUser,
    TResult Function()? loadDocumentStatistics,
    TResult Function()? syncDocuments,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<DocumentModel> documents)? documentsUpdated,
    TResult Function(int? limit)? loadMoreDocuments,
    TResult Function()? resetState,
    required TResult orElse(),
  }) {
    if (loadDocumentStatistics != null) {
      return loadDocumentStatistics();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadDocuments value) loadDocuments,
    required TResult Function(SearchDocuments value) searchDocuments,
    required TResult Function(FilterDocuments value) filterDocuments,
    required TResult Function(SortDocuments value) sortDocuments,
    required TResult Function(DeleteDocument value) deleteDocument,
    required TResult Function(PermanentlyDeleteDocument value)
    permanentlyDeleteDocument,
    required TResult Function(RestoreDocument value) restoreDocument,
    required TResult Function(UpdateDocument value) updateDocument,
    required TResult Function(RefreshDocuments value) refreshDocuments,
    required TResult Function(LoadRecentDocuments value) loadRecentDocuments,
    required TResult Function(LoadDeletedDocuments value) loadDeletedDocuments,
    required TResult Function(LoadDocumentsByCategory value)
    loadDocumentsByCategory,
    required TResult Function(LoadDocumentsByUser value) loadDocumentsByUser,
    required TResult Function(LoadDocumentStatistics value)
    loadDocumentStatistics,
    required TResult Function(SyncDocuments value) syncDocuments,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(DocumentsUpdated value) documentsUpdated,
    required TResult Function(LoadMoreDocuments value) loadMoreDocuments,
    required TResult Function(ResetState value) resetState,
  }) {
    return loadDocumentStatistics(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadDocuments value)? loadDocuments,
    TResult? Function(SearchDocuments value)? searchDocuments,
    TResult? Function(FilterDocuments value)? filterDocuments,
    TResult? Function(SortDocuments value)? sortDocuments,
    TResult? Function(DeleteDocument value)? deleteDocument,
    TResult? Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult? Function(RestoreDocument value)? restoreDocument,
    TResult? Function(UpdateDocument value)? updateDocument,
    TResult? Function(RefreshDocuments value)? refreshDocuments,
    TResult? Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult? Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult? Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult? Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult? Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult? Function(SyncDocuments value)? syncDocuments,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(DocumentsUpdated value)? documentsUpdated,
    TResult? Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult? Function(ResetState value)? resetState,
  }) {
    return loadDocumentStatistics?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadDocuments value)? loadDocuments,
    TResult Function(SearchDocuments value)? searchDocuments,
    TResult Function(FilterDocuments value)? filterDocuments,
    TResult Function(SortDocuments value)? sortDocuments,
    TResult Function(DeleteDocument value)? deleteDocument,
    TResult Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult Function(RestoreDocument value)? restoreDocument,
    TResult Function(UpdateDocument value)? updateDocument,
    TResult Function(RefreshDocuments value)? refreshDocuments,
    TResult Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult Function(SyncDocuments value)? syncDocuments,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(DocumentsUpdated value)? documentsUpdated,
    TResult Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult Function(ResetState value)? resetState,
    required TResult orElse(),
  }) {
    if (loadDocumentStatistics != null) {
      return loadDocumentStatistics(this);
    }
    return orElse();
  }
}

abstract class LoadDocumentStatistics implements DocumentEvent {
  const factory LoadDocumentStatistics() = _$LoadDocumentStatisticsImpl;
}

/// @nodoc
abstract class _$$SyncDocumentsImplCopyWith<$Res> {
  factory _$$SyncDocumentsImplCopyWith(
    _$SyncDocumentsImpl value,
    $Res Function(_$SyncDocumentsImpl) then,
  ) = __$$SyncDocumentsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SyncDocumentsImplCopyWithImpl<$Res>
    extends _$DocumentEventCopyWithImpl<$Res, _$SyncDocumentsImpl>
    implements _$$SyncDocumentsImplCopyWith<$Res> {
  __$$SyncDocumentsImplCopyWithImpl(
    _$SyncDocumentsImpl _value,
    $Res Function(_$SyncDocumentsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SyncDocumentsImpl implements SyncDocuments {
  const _$SyncDocumentsImpl();

  @override
  String toString() {
    return 'DocumentEvent.syncDocuments()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SyncDocumentsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      bool forceRefresh,
      int? limit,
      DocumentModel? startAfter,
    )
    loadDocuments,
    required TResult Function(String query, int? limit) searchDocuments,
    required TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )
    filterDocuments,
    required TResult Function(String sortBy, bool ascending) sortDocuments,
    required TResult Function(String documentId, String userId) deleteDocument,
    required TResult Function(String documentId, String userId)
    permanentlyDeleteDocument,
    required TResult Function(String documentId, String userId) restoreDocument,
    required TResult Function(DocumentModel document) updateDocument,
    required TResult Function(bool forceRefresh) refreshDocuments,
    required TResult Function(int? limit) loadRecentDocuments,
    required TResult Function(int? limit) loadDeletedDocuments,
    required TResult Function(String category, int? limit)
    loadDocumentsByCategory,
    required TResult Function(String userId, int? limit) loadDocumentsByUser,
    required TResult Function() loadDocumentStatistics,
    required TResult Function() syncDocuments,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<DocumentModel> documents) documentsUpdated,
    required TResult Function(int? limit) loadMoreDocuments,
    required TResult Function() resetState,
  }) {
    return syncDocuments();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult? Function(String query, int? limit)? searchDocuments,
    TResult? Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult? Function(String sortBy, bool ascending)? sortDocuments,
    TResult? Function(String documentId, String userId)? deleteDocument,
    TResult? Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult? Function(String documentId, String userId)? restoreDocument,
    TResult? Function(DocumentModel document)? updateDocument,
    TResult? Function(bool forceRefresh)? refreshDocuments,
    TResult? Function(int? limit)? loadRecentDocuments,
    TResult? Function(int? limit)? loadDeletedDocuments,
    TResult? Function(String category, int? limit)? loadDocumentsByCategory,
    TResult? Function(String userId, int? limit)? loadDocumentsByUser,
    TResult? Function()? loadDocumentStatistics,
    TResult? Function()? syncDocuments,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<DocumentModel> documents)? documentsUpdated,
    TResult? Function(int? limit)? loadMoreDocuments,
    TResult? Function()? resetState,
  }) {
    return syncDocuments?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult Function(String query, int? limit)? searchDocuments,
    TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult Function(String sortBy, bool ascending)? sortDocuments,
    TResult Function(String documentId, String userId)? deleteDocument,
    TResult Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult Function(String documentId, String userId)? restoreDocument,
    TResult Function(DocumentModel document)? updateDocument,
    TResult Function(bool forceRefresh)? refreshDocuments,
    TResult Function(int? limit)? loadRecentDocuments,
    TResult Function(int? limit)? loadDeletedDocuments,
    TResult Function(String category, int? limit)? loadDocumentsByCategory,
    TResult Function(String userId, int? limit)? loadDocumentsByUser,
    TResult Function()? loadDocumentStatistics,
    TResult Function()? syncDocuments,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<DocumentModel> documents)? documentsUpdated,
    TResult Function(int? limit)? loadMoreDocuments,
    TResult Function()? resetState,
    required TResult orElse(),
  }) {
    if (syncDocuments != null) {
      return syncDocuments();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadDocuments value) loadDocuments,
    required TResult Function(SearchDocuments value) searchDocuments,
    required TResult Function(FilterDocuments value) filterDocuments,
    required TResult Function(SortDocuments value) sortDocuments,
    required TResult Function(DeleteDocument value) deleteDocument,
    required TResult Function(PermanentlyDeleteDocument value)
    permanentlyDeleteDocument,
    required TResult Function(RestoreDocument value) restoreDocument,
    required TResult Function(UpdateDocument value) updateDocument,
    required TResult Function(RefreshDocuments value) refreshDocuments,
    required TResult Function(LoadRecentDocuments value) loadRecentDocuments,
    required TResult Function(LoadDeletedDocuments value) loadDeletedDocuments,
    required TResult Function(LoadDocumentsByCategory value)
    loadDocumentsByCategory,
    required TResult Function(LoadDocumentsByUser value) loadDocumentsByUser,
    required TResult Function(LoadDocumentStatistics value)
    loadDocumentStatistics,
    required TResult Function(SyncDocuments value) syncDocuments,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(DocumentsUpdated value) documentsUpdated,
    required TResult Function(LoadMoreDocuments value) loadMoreDocuments,
    required TResult Function(ResetState value) resetState,
  }) {
    return syncDocuments(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadDocuments value)? loadDocuments,
    TResult? Function(SearchDocuments value)? searchDocuments,
    TResult? Function(FilterDocuments value)? filterDocuments,
    TResult? Function(SortDocuments value)? sortDocuments,
    TResult? Function(DeleteDocument value)? deleteDocument,
    TResult? Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult? Function(RestoreDocument value)? restoreDocument,
    TResult? Function(UpdateDocument value)? updateDocument,
    TResult? Function(RefreshDocuments value)? refreshDocuments,
    TResult? Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult? Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult? Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult? Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult? Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult? Function(SyncDocuments value)? syncDocuments,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(DocumentsUpdated value)? documentsUpdated,
    TResult? Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult? Function(ResetState value)? resetState,
  }) {
    return syncDocuments?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadDocuments value)? loadDocuments,
    TResult Function(SearchDocuments value)? searchDocuments,
    TResult Function(FilterDocuments value)? filterDocuments,
    TResult Function(SortDocuments value)? sortDocuments,
    TResult Function(DeleteDocument value)? deleteDocument,
    TResult Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult Function(RestoreDocument value)? restoreDocument,
    TResult Function(UpdateDocument value)? updateDocument,
    TResult Function(RefreshDocuments value)? refreshDocuments,
    TResult Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult Function(SyncDocuments value)? syncDocuments,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(DocumentsUpdated value)? documentsUpdated,
    TResult Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult Function(ResetState value)? resetState,
    required TResult orElse(),
  }) {
    if (syncDocuments != null) {
      return syncDocuments(this);
    }
    return orElse();
  }
}

abstract class SyncDocuments implements DocumentEvent {
  const factory SyncDocuments() = _$SyncDocumentsImpl;
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
    extends _$DocumentEventCopyWithImpl<$Res, _$ClearFiltersImpl>
    implements _$$ClearFiltersImplCopyWith<$Res> {
  __$$ClearFiltersImplCopyWithImpl(
    _$ClearFiltersImpl _value,
    $Res Function(_$ClearFiltersImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ClearFiltersImpl implements ClearFilters {
  const _$ClearFiltersImpl();

  @override
  String toString() {
    return 'DocumentEvent.clearFilters()';
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
    required TResult Function(
      bool forceRefresh,
      int? limit,
      DocumentModel? startAfter,
    )
    loadDocuments,
    required TResult Function(String query, int? limit) searchDocuments,
    required TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )
    filterDocuments,
    required TResult Function(String sortBy, bool ascending) sortDocuments,
    required TResult Function(String documentId, String userId) deleteDocument,
    required TResult Function(String documentId, String userId)
    permanentlyDeleteDocument,
    required TResult Function(String documentId, String userId) restoreDocument,
    required TResult Function(DocumentModel document) updateDocument,
    required TResult Function(bool forceRefresh) refreshDocuments,
    required TResult Function(int? limit) loadRecentDocuments,
    required TResult Function(int? limit) loadDeletedDocuments,
    required TResult Function(String category, int? limit)
    loadDocumentsByCategory,
    required TResult Function(String userId, int? limit) loadDocumentsByUser,
    required TResult Function() loadDocumentStatistics,
    required TResult Function() syncDocuments,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<DocumentModel> documents) documentsUpdated,
    required TResult Function(int? limit) loadMoreDocuments,
    required TResult Function() resetState,
  }) {
    return clearFilters();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult? Function(String query, int? limit)? searchDocuments,
    TResult? Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult? Function(String sortBy, bool ascending)? sortDocuments,
    TResult? Function(String documentId, String userId)? deleteDocument,
    TResult? Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult? Function(String documentId, String userId)? restoreDocument,
    TResult? Function(DocumentModel document)? updateDocument,
    TResult? Function(bool forceRefresh)? refreshDocuments,
    TResult? Function(int? limit)? loadRecentDocuments,
    TResult? Function(int? limit)? loadDeletedDocuments,
    TResult? Function(String category, int? limit)? loadDocumentsByCategory,
    TResult? Function(String userId, int? limit)? loadDocumentsByUser,
    TResult? Function()? loadDocumentStatistics,
    TResult? Function()? syncDocuments,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<DocumentModel> documents)? documentsUpdated,
    TResult? Function(int? limit)? loadMoreDocuments,
    TResult? Function()? resetState,
  }) {
    return clearFilters?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult Function(String query, int? limit)? searchDocuments,
    TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult Function(String sortBy, bool ascending)? sortDocuments,
    TResult Function(String documentId, String userId)? deleteDocument,
    TResult Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult Function(String documentId, String userId)? restoreDocument,
    TResult Function(DocumentModel document)? updateDocument,
    TResult Function(bool forceRefresh)? refreshDocuments,
    TResult Function(int? limit)? loadRecentDocuments,
    TResult Function(int? limit)? loadDeletedDocuments,
    TResult Function(String category, int? limit)? loadDocumentsByCategory,
    TResult Function(String userId, int? limit)? loadDocumentsByUser,
    TResult Function()? loadDocumentStatistics,
    TResult Function()? syncDocuments,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<DocumentModel> documents)? documentsUpdated,
    TResult Function(int? limit)? loadMoreDocuments,
    TResult Function()? resetState,
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
    required TResult Function(LoadDocuments value) loadDocuments,
    required TResult Function(SearchDocuments value) searchDocuments,
    required TResult Function(FilterDocuments value) filterDocuments,
    required TResult Function(SortDocuments value) sortDocuments,
    required TResult Function(DeleteDocument value) deleteDocument,
    required TResult Function(PermanentlyDeleteDocument value)
    permanentlyDeleteDocument,
    required TResult Function(RestoreDocument value) restoreDocument,
    required TResult Function(UpdateDocument value) updateDocument,
    required TResult Function(RefreshDocuments value) refreshDocuments,
    required TResult Function(LoadRecentDocuments value) loadRecentDocuments,
    required TResult Function(LoadDeletedDocuments value) loadDeletedDocuments,
    required TResult Function(LoadDocumentsByCategory value)
    loadDocumentsByCategory,
    required TResult Function(LoadDocumentsByUser value) loadDocumentsByUser,
    required TResult Function(LoadDocumentStatistics value)
    loadDocumentStatistics,
    required TResult Function(SyncDocuments value) syncDocuments,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(DocumentsUpdated value) documentsUpdated,
    required TResult Function(LoadMoreDocuments value) loadMoreDocuments,
    required TResult Function(ResetState value) resetState,
  }) {
    return clearFilters(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadDocuments value)? loadDocuments,
    TResult? Function(SearchDocuments value)? searchDocuments,
    TResult? Function(FilterDocuments value)? filterDocuments,
    TResult? Function(SortDocuments value)? sortDocuments,
    TResult? Function(DeleteDocument value)? deleteDocument,
    TResult? Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult? Function(RestoreDocument value)? restoreDocument,
    TResult? Function(UpdateDocument value)? updateDocument,
    TResult? Function(RefreshDocuments value)? refreshDocuments,
    TResult? Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult? Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult? Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult? Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult? Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult? Function(SyncDocuments value)? syncDocuments,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(DocumentsUpdated value)? documentsUpdated,
    TResult? Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult? Function(ResetState value)? resetState,
  }) {
    return clearFilters?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadDocuments value)? loadDocuments,
    TResult Function(SearchDocuments value)? searchDocuments,
    TResult Function(FilterDocuments value)? filterDocuments,
    TResult Function(SortDocuments value)? sortDocuments,
    TResult Function(DeleteDocument value)? deleteDocument,
    TResult Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult Function(RestoreDocument value)? restoreDocument,
    TResult Function(UpdateDocument value)? updateDocument,
    TResult Function(RefreshDocuments value)? refreshDocuments,
    TResult Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult Function(SyncDocuments value)? syncDocuments,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(DocumentsUpdated value)? documentsUpdated,
    TResult Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult Function(ResetState value)? resetState,
    required TResult orElse(),
  }) {
    if (clearFilters != null) {
      return clearFilters(this);
    }
    return orElse();
  }
}

abstract class ClearFilters implements DocumentEvent {
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
    extends _$DocumentEventCopyWithImpl<$Res, _$StartListeningImpl>
    implements _$$StartListeningImplCopyWith<$Res> {
  __$$StartListeningImplCopyWithImpl(
    _$StartListeningImpl _value,
    $Res Function(_$StartListeningImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StartListeningImpl implements StartListening {
  const _$StartListeningImpl();

  @override
  String toString() {
    return 'DocumentEvent.startListening()';
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
    required TResult Function(
      bool forceRefresh,
      int? limit,
      DocumentModel? startAfter,
    )
    loadDocuments,
    required TResult Function(String query, int? limit) searchDocuments,
    required TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )
    filterDocuments,
    required TResult Function(String sortBy, bool ascending) sortDocuments,
    required TResult Function(String documentId, String userId) deleteDocument,
    required TResult Function(String documentId, String userId)
    permanentlyDeleteDocument,
    required TResult Function(String documentId, String userId) restoreDocument,
    required TResult Function(DocumentModel document) updateDocument,
    required TResult Function(bool forceRefresh) refreshDocuments,
    required TResult Function(int? limit) loadRecentDocuments,
    required TResult Function(int? limit) loadDeletedDocuments,
    required TResult Function(String category, int? limit)
    loadDocumentsByCategory,
    required TResult Function(String userId, int? limit) loadDocumentsByUser,
    required TResult Function() loadDocumentStatistics,
    required TResult Function() syncDocuments,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<DocumentModel> documents) documentsUpdated,
    required TResult Function(int? limit) loadMoreDocuments,
    required TResult Function() resetState,
  }) {
    return startListening();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult? Function(String query, int? limit)? searchDocuments,
    TResult? Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult? Function(String sortBy, bool ascending)? sortDocuments,
    TResult? Function(String documentId, String userId)? deleteDocument,
    TResult? Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult? Function(String documentId, String userId)? restoreDocument,
    TResult? Function(DocumentModel document)? updateDocument,
    TResult? Function(bool forceRefresh)? refreshDocuments,
    TResult? Function(int? limit)? loadRecentDocuments,
    TResult? Function(int? limit)? loadDeletedDocuments,
    TResult? Function(String category, int? limit)? loadDocumentsByCategory,
    TResult? Function(String userId, int? limit)? loadDocumentsByUser,
    TResult? Function()? loadDocumentStatistics,
    TResult? Function()? syncDocuments,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<DocumentModel> documents)? documentsUpdated,
    TResult? Function(int? limit)? loadMoreDocuments,
    TResult? Function()? resetState,
  }) {
    return startListening?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult Function(String query, int? limit)? searchDocuments,
    TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult Function(String sortBy, bool ascending)? sortDocuments,
    TResult Function(String documentId, String userId)? deleteDocument,
    TResult Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult Function(String documentId, String userId)? restoreDocument,
    TResult Function(DocumentModel document)? updateDocument,
    TResult Function(bool forceRefresh)? refreshDocuments,
    TResult Function(int? limit)? loadRecentDocuments,
    TResult Function(int? limit)? loadDeletedDocuments,
    TResult Function(String category, int? limit)? loadDocumentsByCategory,
    TResult Function(String userId, int? limit)? loadDocumentsByUser,
    TResult Function()? loadDocumentStatistics,
    TResult Function()? syncDocuments,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<DocumentModel> documents)? documentsUpdated,
    TResult Function(int? limit)? loadMoreDocuments,
    TResult Function()? resetState,
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
    required TResult Function(LoadDocuments value) loadDocuments,
    required TResult Function(SearchDocuments value) searchDocuments,
    required TResult Function(FilterDocuments value) filterDocuments,
    required TResult Function(SortDocuments value) sortDocuments,
    required TResult Function(DeleteDocument value) deleteDocument,
    required TResult Function(PermanentlyDeleteDocument value)
    permanentlyDeleteDocument,
    required TResult Function(RestoreDocument value) restoreDocument,
    required TResult Function(UpdateDocument value) updateDocument,
    required TResult Function(RefreshDocuments value) refreshDocuments,
    required TResult Function(LoadRecentDocuments value) loadRecentDocuments,
    required TResult Function(LoadDeletedDocuments value) loadDeletedDocuments,
    required TResult Function(LoadDocumentsByCategory value)
    loadDocumentsByCategory,
    required TResult Function(LoadDocumentsByUser value) loadDocumentsByUser,
    required TResult Function(LoadDocumentStatistics value)
    loadDocumentStatistics,
    required TResult Function(SyncDocuments value) syncDocuments,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(DocumentsUpdated value) documentsUpdated,
    required TResult Function(LoadMoreDocuments value) loadMoreDocuments,
    required TResult Function(ResetState value) resetState,
  }) {
    return startListening(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadDocuments value)? loadDocuments,
    TResult? Function(SearchDocuments value)? searchDocuments,
    TResult? Function(FilterDocuments value)? filterDocuments,
    TResult? Function(SortDocuments value)? sortDocuments,
    TResult? Function(DeleteDocument value)? deleteDocument,
    TResult? Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult? Function(RestoreDocument value)? restoreDocument,
    TResult? Function(UpdateDocument value)? updateDocument,
    TResult? Function(RefreshDocuments value)? refreshDocuments,
    TResult? Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult? Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult? Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult? Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult? Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult? Function(SyncDocuments value)? syncDocuments,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(DocumentsUpdated value)? documentsUpdated,
    TResult? Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult? Function(ResetState value)? resetState,
  }) {
    return startListening?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadDocuments value)? loadDocuments,
    TResult Function(SearchDocuments value)? searchDocuments,
    TResult Function(FilterDocuments value)? filterDocuments,
    TResult Function(SortDocuments value)? sortDocuments,
    TResult Function(DeleteDocument value)? deleteDocument,
    TResult Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult Function(RestoreDocument value)? restoreDocument,
    TResult Function(UpdateDocument value)? updateDocument,
    TResult Function(RefreshDocuments value)? refreshDocuments,
    TResult Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult Function(SyncDocuments value)? syncDocuments,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(DocumentsUpdated value)? documentsUpdated,
    TResult Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult Function(ResetState value)? resetState,
    required TResult orElse(),
  }) {
    if (startListening != null) {
      return startListening(this);
    }
    return orElse();
  }
}

abstract class StartListening implements DocumentEvent {
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
    extends _$DocumentEventCopyWithImpl<$Res, _$StopListeningImpl>
    implements _$$StopListeningImplCopyWith<$Res> {
  __$$StopListeningImplCopyWithImpl(
    _$StopListeningImpl _value,
    $Res Function(_$StopListeningImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StopListeningImpl implements StopListening {
  const _$StopListeningImpl();

  @override
  String toString() {
    return 'DocumentEvent.stopListening()';
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
    required TResult Function(
      bool forceRefresh,
      int? limit,
      DocumentModel? startAfter,
    )
    loadDocuments,
    required TResult Function(String query, int? limit) searchDocuments,
    required TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )
    filterDocuments,
    required TResult Function(String sortBy, bool ascending) sortDocuments,
    required TResult Function(String documentId, String userId) deleteDocument,
    required TResult Function(String documentId, String userId)
    permanentlyDeleteDocument,
    required TResult Function(String documentId, String userId) restoreDocument,
    required TResult Function(DocumentModel document) updateDocument,
    required TResult Function(bool forceRefresh) refreshDocuments,
    required TResult Function(int? limit) loadRecentDocuments,
    required TResult Function(int? limit) loadDeletedDocuments,
    required TResult Function(String category, int? limit)
    loadDocumentsByCategory,
    required TResult Function(String userId, int? limit) loadDocumentsByUser,
    required TResult Function() loadDocumentStatistics,
    required TResult Function() syncDocuments,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<DocumentModel> documents) documentsUpdated,
    required TResult Function(int? limit) loadMoreDocuments,
    required TResult Function() resetState,
  }) {
    return stopListening();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult? Function(String query, int? limit)? searchDocuments,
    TResult? Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult? Function(String sortBy, bool ascending)? sortDocuments,
    TResult? Function(String documentId, String userId)? deleteDocument,
    TResult? Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult? Function(String documentId, String userId)? restoreDocument,
    TResult? Function(DocumentModel document)? updateDocument,
    TResult? Function(bool forceRefresh)? refreshDocuments,
    TResult? Function(int? limit)? loadRecentDocuments,
    TResult? Function(int? limit)? loadDeletedDocuments,
    TResult? Function(String category, int? limit)? loadDocumentsByCategory,
    TResult? Function(String userId, int? limit)? loadDocumentsByUser,
    TResult? Function()? loadDocumentStatistics,
    TResult? Function()? syncDocuments,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<DocumentModel> documents)? documentsUpdated,
    TResult? Function(int? limit)? loadMoreDocuments,
    TResult? Function()? resetState,
  }) {
    return stopListening?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult Function(String query, int? limit)? searchDocuments,
    TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult Function(String sortBy, bool ascending)? sortDocuments,
    TResult Function(String documentId, String userId)? deleteDocument,
    TResult Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult Function(String documentId, String userId)? restoreDocument,
    TResult Function(DocumentModel document)? updateDocument,
    TResult Function(bool forceRefresh)? refreshDocuments,
    TResult Function(int? limit)? loadRecentDocuments,
    TResult Function(int? limit)? loadDeletedDocuments,
    TResult Function(String category, int? limit)? loadDocumentsByCategory,
    TResult Function(String userId, int? limit)? loadDocumentsByUser,
    TResult Function()? loadDocumentStatistics,
    TResult Function()? syncDocuments,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<DocumentModel> documents)? documentsUpdated,
    TResult Function(int? limit)? loadMoreDocuments,
    TResult Function()? resetState,
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
    required TResult Function(LoadDocuments value) loadDocuments,
    required TResult Function(SearchDocuments value) searchDocuments,
    required TResult Function(FilterDocuments value) filterDocuments,
    required TResult Function(SortDocuments value) sortDocuments,
    required TResult Function(DeleteDocument value) deleteDocument,
    required TResult Function(PermanentlyDeleteDocument value)
    permanentlyDeleteDocument,
    required TResult Function(RestoreDocument value) restoreDocument,
    required TResult Function(UpdateDocument value) updateDocument,
    required TResult Function(RefreshDocuments value) refreshDocuments,
    required TResult Function(LoadRecentDocuments value) loadRecentDocuments,
    required TResult Function(LoadDeletedDocuments value) loadDeletedDocuments,
    required TResult Function(LoadDocumentsByCategory value)
    loadDocumentsByCategory,
    required TResult Function(LoadDocumentsByUser value) loadDocumentsByUser,
    required TResult Function(LoadDocumentStatistics value)
    loadDocumentStatistics,
    required TResult Function(SyncDocuments value) syncDocuments,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(DocumentsUpdated value) documentsUpdated,
    required TResult Function(LoadMoreDocuments value) loadMoreDocuments,
    required TResult Function(ResetState value) resetState,
  }) {
    return stopListening(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadDocuments value)? loadDocuments,
    TResult? Function(SearchDocuments value)? searchDocuments,
    TResult? Function(FilterDocuments value)? filterDocuments,
    TResult? Function(SortDocuments value)? sortDocuments,
    TResult? Function(DeleteDocument value)? deleteDocument,
    TResult? Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult? Function(RestoreDocument value)? restoreDocument,
    TResult? Function(UpdateDocument value)? updateDocument,
    TResult? Function(RefreshDocuments value)? refreshDocuments,
    TResult? Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult? Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult? Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult? Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult? Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult? Function(SyncDocuments value)? syncDocuments,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(DocumentsUpdated value)? documentsUpdated,
    TResult? Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult? Function(ResetState value)? resetState,
  }) {
    return stopListening?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadDocuments value)? loadDocuments,
    TResult Function(SearchDocuments value)? searchDocuments,
    TResult Function(FilterDocuments value)? filterDocuments,
    TResult Function(SortDocuments value)? sortDocuments,
    TResult Function(DeleteDocument value)? deleteDocument,
    TResult Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult Function(RestoreDocument value)? restoreDocument,
    TResult Function(UpdateDocument value)? updateDocument,
    TResult Function(RefreshDocuments value)? refreshDocuments,
    TResult Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult Function(SyncDocuments value)? syncDocuments,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(DocumentsUpdated value)? documentsUpdated,
    TResult Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult Function(ResetState value)? resetState,
    required TResult orElse(),
  }) {
    if (stopListening != null) {
      return stopListening(this);
    }
    return orElse();
  }
}

abstract class StopListening implements DocumentEvent {
  const factory StopListening() = _$StopListeningImpl;
}

/// @nodoc
abstract class _$$DocumentsUpdatedImplCopyWith<$Res> {
  factory _$$DocumentsUpdatedImplCopyWith(
    _$DocumentsUpdatedImpl value,
    $Res Function(_$DocumentsUpdatedImpl) then,
  ) = __$$DocumentsUpdatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<DocumentModel> documents});
}

/// @nodoc
class __$$DocumentsUpdatedImplCopyWithImpl<$Res>
    extends _$DocumentEventCopyWithImpl<$Res, _$DocumentsUpdatedImpl>
    implements _$$DocumentsUpdatedImplCopyWith<$Res> {
  __$$DocumentsUpdatedImplCopyWithImpl(
    _$DocumentsUpdatedImpl _value,
    $Res Function(_$DocumentsUpdatedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? documents = null}) {
    return _then(
      _$DocumentsUpdatedImpl(
        documents: null == documents
            ? _value._documents
            : documents // ignore: cast_nullable_to_non_nullable
                  as List<DocumentModel>,
      ),
    );
  }
}

/// @nodoc

class _$DocumentsUpdatedImpl implements DocumentsUpdated {
  const _$DocumentsUpdatedImpl({required final List<DocumentModel> documents})
    : _documents = documents;

  final List<DocumentModel> _documents;
  @override
  List<DocumentModel> get documents {
    if (_documents is EqualUnmodifiableListView) return _documents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_documents);
  }

  @override
  String toString() {
    return 'DocumentEvent.documentsUpdated(documents: $documents)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentsUpdatedImpl &&
            const DeepCollectionEquality().equals(
              other._documents,
              _documents,
            ));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_documents));

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentsUpdatedImplCopyWith<_$DocumentsUpdatedImpl> get copyWith =>
      __$$DocumentsUpdatedImplCopyWithImpl<_$DocumentsUpdatedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      bool forceRefresh,
      int? limit,
      DocumentModel? startAfter,
    )
    loadDocuments,
    required TResult Function(String query, int? limit) searchDocuments,
    required TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )
    filterDocuments,
    required TResult Function(String sortBy, bool ascending) sortDocuments,
    required TResult Function(String documentId, String userId) deleteDocument,
    required TResult Function(String documentId, String userId)
    permanentlyDeleteDocument,
    required TResult Function(String documentId, String userId) restoreDocument,
    required TResult Function(DocumentModel document) updateDocument,
    required TResult Function(bool forceRefresh) refreshDocuments,
    required TResult Function(int? limit) loadRecentDocuments,
    required TResult Function(int? limit) loadDeletedDocuments,
    required TResult Function(String category, int? limit)
    loadDocumentsByCategory,
    required TResult Function(String userId, int? limit) loadDocumentsByUser,
    required TResult Function() loadDocumentStatistics,
    required TResult Function() syncDocuments,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<DocumentModel> documents) documentsUpdated,
    required TResult Function(int? limit) loadMoreDocuments,
    required TResult Function() resetState,
  }) {
    return documentsUpdated(documents);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult? Function(String query, int? limit)? searchDocuments,
    TResult? Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult? Function(String sortBy, bool ascending)? sortDocuments,
    TResult? Function(String documentId, String userId)? deleteDocument,
    TResult? Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult? Function(String documentId, String userId)? restoreDocument,
    TResult? Function(DocumentModel document)? updateDocument,
    TResult? Function(bool forceRefresh)? refreshDocuments,
    TResult? Function(int? limit)? loadRecentDocuments,
    TResult? Function(int? limit)? loadDeletedDocuments,
    TResult? Function(String category, int? limit)? loadDocumentsByCategory,
    TResult? Function(String userId, int? limit)? loadDocumentsByUser,
    TResult? Function()? loadDocumentStatistics,
    TResult? Function()? syncDocuments,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<DocumentModel> documents)? documentsUpdated,
    TResult? Function(int? limit)? loadMoreDocuments,
    TResult? Function()? resetState,
  }) {
    return documentsUpdated?.call(documents);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult Function(String query, int? limit)? searchDocuments,
    TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult Function(String sortBy, bool ascending)? sortDocuments,
    TResult Function(String documentId, String userId)? deleteDocument,
    TResult Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult Function(String documentId, String userId)? restoreDocument,
    TResult Function(DocumentModel document)? updateDocument,
    TResult Function(bool forceRefresh)? refreshDocuments,
    TResult Function(int? limit)? loadRecentDocuments,
    TResult Function(int? limit)? loadDeletedDocuments,
    TResult Function(String category, int? limit)? loadDocumentsByCategory,
    TResult Function(String userId, int? limit)? loadDocumentsByUser,
    TResult Function()? loadDocumentStatistics,
    TResult Function()? syncDocuments,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<DocumentModel> documents)? documentsUpdated,
    TResult Function(int? limit)? loadMoreDocuments,
    TResult Function()? resetState,
    required TResult orElse(),
  }) {
    if (documentsUpdated != null) {
      return documentsUpdated(documents);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadDocuments value) loadDocuments,
    required TResult Function(SearchDocuments value) searchDocuments,
    required TResult Function(FilterDocuments value) filterDocuments,
    required TResult Function(SortDocuments value) sortDocuments,
    required TResult Function(DeleteDocument value) deleteDocument,
    required TResult Function(PermanentlyDeleteDocument value)
    permanentlyDeleteDocument,
    required TResult Function(RestoreDocument value) restoreDocument,
    required TResult Function(UpdateDocument value) updateDocument,
    required TResult Function(RefreshDocuments value) refreshDocuments,
    required TResult Function(LoadRecentDocuments value) loadRecentDocuments,
    required TResult Function(LoadDeletedDocuments value) loadDeletedDocuments,
    required TResult Function(LoadDocumentsByCategory value)
    loadDocumentsByCategory,
    required TResult Function(LoadDocumentsByUser value) loadDocumentsByUser,
    required TResult Function(LoadDocumentStatistics value)
    loadDocumentStatistics,
    required TResult Function(SyncDocuments value) syncDocuments,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(DocumentsUpdated value) documentsUpdated,
    required TResult Function(LoadMoreDocuments value) loadMoreDocuments,
    required TResult Function(ResetState value) resetState,
  }) {
    return documentsUpdated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadDocuments value)? loadDocuments,
    TResult? Function(SearchDocuments value)? searchDocuments,
    TResult? Function(FilterDocuments value)? filterDocuments,
    TResult? Function(SortDocuments value)? sortDocuments,
    TResult? Function(DeleteDocument value)? deleteDocument,
    TResult? Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult? Function(RestoreDocument value)? restoreDocument,
    TResult? Function(UpdateDocument value)? updateDocument,
    TResult? Function(RefreshDocuments value)? refreshDocuments,
    TResult? Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult? Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult? Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult? Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult? Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult? Function(SyncDocuments value)? syncDocuments,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(DocumentsUpdated value)? documentsUpdated,
    TResult? Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult? Function(ResetState value)? resetState,
  }) {
    return documentsUpdated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadDocuments value)? loadDocuments,
    TResult Function(SearchDocuments value)? searchDocuments,
    TResult Function(FilterDocuments value)? filterDocuments,
    TResult Function(SortDocuments value)? sortDocuments,
    TResult Function(DeleteDocument value)? deleteDocument,
    TResult Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult Function(RestoreDocument value)? restoreDocument,
    TResult Function(UpdateDocument value)? updateDocument,
    TResult Function(RefreshDocuments value)? refreshDocuments,
    TResult Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult Function(SyncDocuments value)? syncDocuments,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(DocumentsUpdated value)? documentsUpdated,
    TResult Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult Function(ResetState value)? resetState,
    required TResult orElse(),
  }) {
    if (documentsUpdated != null) {
      return documentsUpdated(this);
    }
    return orElse();
  }
}

abstract class DocumentsUpdated implements DocumentEvent {
  const factory DocumentsUpdated({
    required final List<DocumentModel> documents,
  }) = _$DocumentsUpdatedImpl;

  List<DocumentModel> get documents;

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentsUpdatedImplCopyWith<_$DocumentsUpdatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadMoreDocumentsImplCopyWith<$Res> {
  factory _$$LoadMoreDocumentsImplCopyWith(
    _$LoadMoreDocumentsImpl value,
    $Res Function(_$LoadMoreDocumentsImpl) then,
  ) = __$$LoadMoreDocumentsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int? limit});
}

/// @nodoc
class __$$LoadMoreDocumentsImplCopyWithImpl<$Res>
    extends _$DocumentEventCopyWithImpl<$Res, _$LoadMoreDocumentsImpl>
    implements _$$LoadMoreDocumentsImplCopyWith<$Res> {
  __$$LoadMoreDocumentsImplCopyWithImpl(
    _$LoadMoreDocumentsImpl _value,
    $Res Function(_$LoadMoreDocumentsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? limit = freezed}) {
    return _then(
      _$LoadMoreDocumentsImpl(
        limit: freezed == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$LoadMoreDocumentsImpl implements LoadMoreDocuments {
  const _$LoadMoreDocumentsImpl({this.limit});

  @override
  final int? limit;

  @override
  String toString() {
    return 'DocumentEvent.loadMoreDocuments(limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadMoreDocumentsImpl &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @override
  int get hashCode => Object.hash(runtimeType, limit);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadMoreDocumentsImplCopyWith<_$LoadMoreDocumentsImpl> get copyWith =>
      __$$LoadMoreDocumentsImplCopyWithImpl<_$LoadMoreDocumentsImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      bool forceRefresh,
      int? limit,
      DocumentModel? startAfter,
    )
    loadDocuments,
    required TResult Function(String query, int? limit) searchDocuments,
    required TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )
    filterDocuments,
    required TResult Function(String sortBy, bool ascending) sortDocuments,
    required TResult Function(String documentId, String userId) deleteDocument,
    required TResult Function(String documentId, String userId)
    permanentlyDeleteDocument,
    required TResult Function(String documentId, String userId) restoreDocument,
    required TResult Function(DocumentModel document) updateDocument,
    required TResult Function(bool forceRefresh) refreshDocuments,
    required TResult Function(int? limit) loadRecentDocuments,
    required TResult Function(int? limit) loadDeletedDocuments,
    required TResult Function(String category, int? limit)
    loadDocumentsByCategory,
    required TResult Function(String userId, int? limit) loadDocumentsByUser,
    required TResult Function() loadDocumentStatistics,
    required TResult Function() syncDocuments,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<DocumentModel> documents) documentsUpdated,
    required TResult Function(int? limit) loadMoreDocuments,
    required TResult Function() resetState,
  }) {
    return loadMoreDocuments(limit);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult? Function(String query, int? limit)? searchDocuments,
    TResult? Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult? Function(String sortBy, bool ascending)? sortDocuments,
    TResult? Function(String documentId, String userId)? deleteDocument,
    TResult? Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult? Function(String documentId, String userId)? restoreDocument,
    TResult? Function(DocumentModel document)? updateDocument,
    TResult? Function(bool forceRefresh)? refreshDocuments,
    TResult? Function(int? limit)? loadRecentDocuments,
    TResult? Function(int? limit)? loadDeletedDocuments,
    TResult? Function(String category, int? limit)? loadDocumentsByCategory,
    TResult? Function(String userId, int? limit)? loadDocumentsByUser,
    TResult? Function()? loadDocumentStatistics,
    TResult? Function()? syncDocuments,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<DocumentModel> documents)? documentsUpdated,
    TResult? Function(int? limit)? loadMoreDocuments,
    TResult? Function()? resetState,
  }) {
    return loadMoreDocuments?.call(limit);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult Function(String query, int? limit)? searchDocuments,
    TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult Function(String sortBy, bool ascending)? sortDocuments,
    TResult Function(String documentId, String userId)? deleteDocument,
    TResult Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult Function(String documentId, String userId)? restoreDocument,
    TResult Function(DocumentModel document)? updateDocument,
    TResult Function(bool forceRefresh)? refreshDocuments,
    TResult Function(int? limit)? loadRecentDocuments,
    TResult Function(int? limit)? loadDeletedDocuments,
    TResult Function(String category, int? limit)? loadDocumentsByCategory,
    TResult Function(String userId, int? limit)? loadDocumentsByUser,
    TResult Function()? loadDocumentStatistics,
    TResult Function()? syncDocuments,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<DocumentModel> documents)? documentsUpdated,
    TResult Function(int? limit)? loadMoreDocuments,
    TResult Function()? resetState,
    required TResult orElse(),
  }) {
    if (loadMoreDocuments != null) {
      return loadMoreDocuments(limit);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadDocuments value) loadDocuments,
    required TResult Function(SearchDocuments value) searchDocuments,
    required TResult Function(FilterDocuments value) filterDocuments,
    required TResult Function(SortDocuments value) sortDocuments,
    required TResult Function(DeleteDocument value) deleteDocument,
    required TResult Function(PermanentlyDeleteDocument value)
    permanentlyDeleteDocument,
    required TResult Function(RestoreDocument value) restoreDocument,
    required TResult Function(UpdateDocument value) updateDocument,
    required TResult Function(RefreshDocuments value) refreshDocuments,
    required TResult Function(LoadRecentDocuments value) loadRecentDocuments,
    required TResult Function(LoadDeletedDocuments value) loadDeletedDocuments,
    required TResult Function(LoadDocumentsByCategory value)
    loadDocumentsByCategory,
    required TResult Function(LoadDocumentsByUser value) loadDocumentsByUser,
    required TResult Function(LoadDocumentStatistics value)
    loadDocumentStatistics,
    required TResult Function(SyncDocuments value) syncDocuments,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(DocumentsUpdated value) documentsUpdated,
    required TResult Function(LoadMoreDocuments value) loadMoreDocuments,
    required TResult Function(ResetState value) resetState,
  }) {
    return loadMoreDocuments(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadDocuments value)? loadDocuments,
    TResult? Function(SearchDocuments value)? searchDocuments,
    TResult? Function(FilterDocuments value)? filterDocuments,
    TResult? Function(SortDocuments value)? sortDocuments,
    TResult? Function(DeleteDocument value)? deleteDocument,
    TResult? Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult? Function(RestoreDocument value)? restoreDocument,
    TResult? Function(UpdateDocument value)? updateDocument,
    TResult? Function(RefreshDocuments value)? refreshDocuments,
    TResult? Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult? Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult? Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult? Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult? Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult? Function(SyncDocuments value)? syncDocuments,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(DocumentsUpdated value)? documentsUpdated,
    TResult? Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult? Function(ResetState value)? resetState,
  }) {
    return loadMoreDocuments?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadDocuments value)? loadDocuments,
    TResult Function(SearchDocuments value)? searchDocuments,
    TResult Function(FilterDocuments value)? filterDocuments,
    TResult Function(SortDocuments value)? sortDocuments,
    TResult Function(DeleteDocument value)? deleteDocument,
    TResult Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult Function(RestoreDocument value)? restoreDocument,
    TResult Function(UpdateDocument value)? updateDocument,
    TResult Function(RefreshDocuments value)? refreshDocuments,
    TResult Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult Function(SyncDocuments value)? syncDocuments,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(DocumentsUpdated value)? documentsUpdated,
    TResult Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult Function(ResetState value)? resetState,
    required TResult orElse(),
  }) {
    if (loadMoreDocuments != null) {
      return loadMoreDocuments(this);
    }
    return orElse();
  }
}

abstract class LoadMoreDocuments implements DocumentEvent {
  const factory LoadMoreDocuments({final int? limit}) = _$LoadMoreDocumentsImpl;

  int? get limit;

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadMoreDocumentsImplCopyWith<_$LoadMoreDocumentsImpl> get copyWith =>
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
    extends _$DocumentEventCopyWithImpl<$Res, _$ResetStateImpl>
    implements _$$ResetStateImplCopyWith<$Res> {
  __$$ResetStateImplCopyWithImpl(
    _$ResetStateImpl _value,
    $Res Function(_$ResetStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ResetStateImpl implements ResetState {
  const _$ResetStateImpl();

  @override
  String toString() {
    return 'DocumentEvent.resetState()';
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
    required TResult Function(
      bool forceRefresh,
      int? limit,
      DocumentModel? startAfter,
    )
    loadDocuments,
    required TResult Function(String query, int? limit) searchDocuments,
    required TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )
    filterDocuments,
    required TResult Function(String sortBy, bool ascending) sortDocuments,
    required TResult Function(String documentId, String userId) deleteDocument,
    required TResult Function(String documentId, String userId)
    permanentlyDeleteDocument,
    required TResult Function(String documentId, String userId) restoreDocument,
    required TResult Function(DocumentModel document) updateDocument,
    required TResult Function(bool forceRefresh) refreshDocuments,
    required TResult Function(int? limit) loadRecentDocuments,
    required TResult Function(int? limit) loadDeletedDocuments,
    required TResult Function(String category, int? limit)
    loadDocumentsByCategory,
    required TResult Function(String userId, int? limit) loadDocumentsByUser,
    required TResult Function() loadDocumentStatistics,
    required TResult Function() syncDocuments,
    required TResult Function() clearFilters,
    required TResult Function() startListening,
    required TResult Function() stopListening,
    required TResult Function(List<DocumentModel> documents) documentsUpdated,
    required TResult Function(int? limit) loadMoreDocuments,
    required TResult Function() resetState,
  }) {
    return resetState();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult? Function(String query, int? limit)? searchDocuments,
    TResult? Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult? Function(String sortBy, bool ascending)? sortDocuments,
    TResult? Function(String documentId, String userId)? deleteDocument,
    TResult? Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult? Function(String documentId, String userId)? restoreDocument,
    TResult? Function(DocumentModel document)? updateDocument,
    TResult? Function(bool forceRefresh)? refreshDocuments,
    TResult? Function(int? limit)? loadRecentDocuments,
    TResult? Function(int? limit)? loadDeletedDocuments,
    TResult? Function(String category, int? limit)? loadDocumentsByCategory,
    TResult? Function(String userId, int? limit)? loadDocumentsByUser,
    TResult? Function()? loadDocumentStatistics,
    TResult? Function()? syncDocuments,
    TResult? Function()? clearFilters,
    TResult? Function()? startListening,
    TResult? Function()? stopListening,
    TResult? Function(List<DocumentModel> documents)? documentsUpdated,
    TResult? Function(int? limit)? loadMoreDocuments,
    TResult? Function()? resetState,
  }) {
    return resetState?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool forceRefresh, int? limit, DocumentModel? startAfter)?
    loadDocuments,
    TResult Function(String query, int? limit)? searchDocuments,
    TResult Function(
      String? category,
      String? status,
      String? fileType,
      String? userId,
      bool? isDeleted,
      DateTime? startDate,
      DateTime? endDate,
    )?
    filterDocuments,
    TResult Function(String sortBy, bool ascending)? sortDocuments,
    TResult Function(String documentId, String userId)? deleteDocument,
    TResult Function(String documentId, String userId)?
    permanentlyDeleteDocument,
    TResult Function(String documentId, String userId)? restoreDocument,
    TResult Function(DocumentModel document)? updateDocument,
    TResult Function(bool forceRefresh)? refreshDocuments,
    TResult Function(int? limit)? loadRecentDocuments,
    TResult Function(int? limit)? loadDeletedDocuments,
    TResult Function(String category, int? limit)? loadDocumentsByCategory,
    TResult Function(String userId, int? limit)? loadDocumentsByUser,
    TResult Function()? loadDocumentStatistics,
    TResult Function()? syncDocuments,
    TResult Function()? clearFilters,
    TResult Function()? startListening,
    TResult Function()? stopListening,
    TResult Function(List<DocumentModel> documents)? documentsUpdated,
    TResult Function(int? limit)? loadMoreDocuments,
    TResult Function()? resetState,
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
    required TResult Function(LoadDocuments value) loadDocuments,
    required TResult Function(SearchDocuments value) searchDocuments,
    required TResult Function(FilterDocuments value) filterDocuments,
    required TResult Function(SortDocuments value) sortDocuments,
    required TResult Function(DeleteDocument value) deleteDocument,
    required TResult Function(PermanentlyDeleteDocument value)
    permanentlyDeleteDocument,
    required TResult Function(RestoreDocument value) restoreDocument,
    required TResult Function(UpdateDocument value) updateDocument,
    required TResult Function(RefreshDocuments value) refreshDocuments,
    required TResult Function(LoadRecentDocuments value) loadRecentDocuments,
    required TResult Function(LoadDeletedDocuments value) loadDeletedDocuments,
    required TResult Function(LoadDocumentsByCategory value)
    loadDocumentsByCategory,
    required TResult Function(LoadDocumentsByUser value) loadDocumentsByUser,
    required TResult Function(LoadDocumentStatistics value)
    loadDocumentStatistics,
    required TResult Function(SyncDocuments value) syncDocuments,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(StartListening value) startListening,
    required TResult Function(StopListening value) stopListening,
    required TResult Function(DocumentsUpdated value) documentsUpdated,
    required TResult Function(LoadMoreDocuments value) loadMoreDocuments,
    required TResult Function(ResetState value) resetState,
  }) {
    return resetState(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadDocuments value)? loadDocuments,
    TResult? Function(SearchDocuments value)? searchDocuments,
    TResult? Function(FilterDocuments value)? filterDocuments,
    TResult? Function(SortDocuments value)? sortDocuments,
    TResult? Function(DeleteDocument value)? deleteDocument,
    TResult? Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult? Function(RestoreDocument value)? restoreDocument,
    TResult? Function(UpdateDocument value)? updateDocument,
    TResult? Function(RefreshDocuments value)? refreshDocuments,
    TResult? Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult? Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult? Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult? Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult? Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult? Function(SyncDocuments value)? syncDocuments,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(StartListening value)? startListening,
    TResult? Function(StopListening value)? stopListening,
    TResult? Function(DocumentsUpdated value)? documentsUpdated,
    TResult? Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult? Function(ResetState value)? resetState,
  }) {
    return resetState?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadDocuments value)? loadDocuments,
    TResult Function(SearchDocuments value)? searchDocuments,
    TResult Function(FilterDocuments value)? filterDocuments,
    TResult Function(SortDocuments value)? sortDocuments,
    TResult Function(DeleteDocument value)? deleteDocument,
    TResult Function(PermanentlyDeleteDocument value)?
    permanentlyDeleteDocument,
    TResult Function(RestoreDocument value)? restoreDocument,
    TResult Function(UpdateDocument value)? updateDocument,
    TResult Function(RefreshDocuments value)? refreshDocuments,
    TResult Function(LoadRecentDocuments value)? loadRecentDocuments,
    TResult Function(LoadDeletedDocuments value)? loadDeletedDocuments,
    TResult Function(LoadDocumentsByCategory value)? loadDocumentsByCategory,
    TResult Function(LoadDocumentsByUser value)? loadDocumentsByUser,
    TResult Function(LoadDocumentStatistics value)? loadDocumentStatistics,
    TResult Function(SyncDocuments value)? syncDocuments,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(StartListening value)? startListening,
    TResult Function(StopListening value)? stopListening,
    TResult Function(DocumentsUpdated value)? documentsUpdated,
    TResult Function(LoadMoreDocuments value)? loadMoreDocuments,
    TResult Function(ResetState value)? resetState,
    required TResult orElse(),
  }) {
    if (resetState != null) {
      return resetState(this);
    }
    return orElse();
  }
}

abstract class ResetState implements DocumentEvent {
  const factory ResetState() = _$ResetStateImpl;
}
