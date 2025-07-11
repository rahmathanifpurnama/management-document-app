// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UploadResult _$UploadResultFromJson(Map<String, dynamic> json) {
  return _UploadResult.fromJson(json);
}

/// @nodoc
mixin _$UploadResult {
  bool get success => throw _privateConstructorUsedError;
  String get fileId => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  String? get downloadUrl => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get errorCode => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  int get fileSize => throw _privateConstructorUsedError;
  DateTime? get uploadedAt => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this UploadResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UploadResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UploadResultCopyWith<UploadResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UploadResultCopyWith<$Res> {
  factory $UploadResultCopyWith(
    UploadResult value,
    $Res Function(UploadResult) then,
  ) = _$UploadResultCopyWithImpl<$Res, UploadResult>;
  @useResult
  $Res call({
    bool success,
    String fileId,
    String fileName,
    String? downloadUrl,
    String? thumbnailUrl,
    String? error,
    String? errorCode,
    Map<String, dynamic>? metadata,
    int fileSize,
    DateTime? uploadedAt,
    String? category,
    String? description,
  });
}

/// @nodoc
class _$UploadResultCopyWithImpl<$Res, $Val extends UploadResult>
    implements $UploadResultCopyWith<$Res> {
  _$UploadResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UploadResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? fileId = null,
    Object? fileName = null,
    Object? downloadUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? error = freezed,
    Object? errorCode = freezed,
    Object? metadata = freezed,
    Object? fileSize = null,
    Object? uploadedAt = freezed,
    Object? category = freezed,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            fileId: null == fileId
                ? _value.fileId
                : fileId // ignore: cast_nullable_to_non_nullable
                      as String,
            fileName: null == fileName
                ? _value.fileName
                : fileName // ignore: cast_nullable_to_non_nullable
                      as String,
            downloadUrl: freezed == downloadUrl
                ? _value.downloadUrl
                : downloadUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            thumbnailUrl: freezed == thumbnailUrl
                ? _value.thumbnailUrl
                : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
            errorCode: freezed == errorCode
                ? _value.errorCode
                : errorCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            fileSize: null == fileSize
                ? _value.fileSize
                : fileSize // ignore: cast_nullable_to_non_nullable
                      as int,
            uploadedAt: freezed == uploadedAt
                ? _value.uploadedAt
                : uploadedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UploadResultImplCopyWith<$Res>
    implements $UploadResultCopyWith<$Res> {
  factory _$$UploadResultImplCopyWith(
    _$UploadResultImpl value,
    $Res Function(_$UploadResultImpl) then,
  ) = __$$UploadResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool success,
    String fileId,
    String fileName,
    String? downloadUrl,
    String? thumbnailUrl,
    String? error,
    String? errorCode,
    Map<String, dynamic>? metadata,
    int fileSize,
    DateTime? uploadedAt,
    String? category,
    String? description,
  });
}

/// @nodoc
class __$$UploadResultImplCopyWithImpl<$Res>
    extends _$UploadResultCopyWithImpl<$Res, _$UploadResultImpl>
    implements _$$UploadResultImplCopyWith<$Res> {
  __$$UploadResultImplCopyWithImpl(
    _$UploadResultImpl _value,
    $Res Function(_$UploadResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? fileId = null,
    Object? fileName = null,
    Object? downloadUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? error = freezed,
    Object? errorCode = freezed,
    Object? metadata = freezed,
    Object? fileSize = null,
    Object? uploadedAt = freezed,
    Object? category = freezed,
    Object? description = freezed,
  }) {
    return _then(
      _$UploadResultImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        fileId: null == fileId
            ? _value.fileId
            : fileId // ignore: cast_nullable_to_non_nullable
                  as String,
        fileName: null == fileName
            ? _value.fileName
            : fileName // ignore: cast_nullable_to_non_nullable
                  as String,
        downloadUrl: freezed == downloadUrl
            ? _value.downloadUrl
            : downloadUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        thumbnailUrl: freezed == thumbnailUrl
            ? _value.thumbnailUrl
            : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
        errorCode: freezed == errorCode
            ? _value.errorCode
            : errorCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        fileSize: null == fileSize
            ? _value.fileSize
            : fileSize // ignore: cast_nullable_to_non_nullable
                  as int,
        uploadedAt: freezed == uploadedAt
            ? _value.uploadedAt
            : uploadedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UploadResultImpl implements _UploadResult {
  const _$UploadResultImpl({
    required this.success,
    required this.fileId,
    required this.fileName,
    this.downloadUrl,
    this.thumbnailUrl,
    this.error,
    this.errorCode,
    final Map<String, dynamic>? metadata,
    this.fileSize = 0,
    this.uploadedAt,
    this.category,
    this.description,
  }) : _metadata = metadata;

  factory _$UploadResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$UploadResultImplFromJson(json);

  @override
  final bool success;
  @override
  final String fileId;
  @override
  final String fileName;
  @override
  final String? downloadUrl;
  @override
  final String? thumbnailUrl;
  @override
  final String? error;
  @override
  final String? errorCode;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final int fileSize;
  @override
  final DateTime? uploadedAt;
  @override
  final String? category;
  @override
  final String? description;

  @override
  String toString() {
    return 'UploadResult(success: $success, fileId: $fileId, fileName: $fileName, downloadUrl: $downloadUrl, thumbnailUrl: $thumbnailUrl, error: $error, errorCode: $errorCode, metadata: $metadata, fileSize: $fileSize, uploadedAt: $uploadedAt, category: $category, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadResultImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.fileId, fileId) || other.fileId == fileId) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.downloadUrl, downloadUrl) ||
                other.downloadUrl == downloadUrl) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.uploadedAt, uploadedAt) ||
                other.uploadedAt == uploadedAt) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    success,
    fileId,
    fileName,
    downloadUrl,
    thumbnailUrl,
    error,
    errorCode,
    const DeepCollectionEquality().hash(_metadata),
    fileSize,
    uploadedAt,
    category,
    description,
  );

  /// Create a copy of UploadResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadResultImplCopyWith<_$UploadResultImpl> get copyWith =>
      __$$UploadResultImplCopyWithImpl<_$UploadResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UploadResultImplToJson(this);
  }
}

abstract class _UploadResult implements UploadResult {
  const factory _UploadResult({
    required final bool success,
    required final String fileId,
    required final String fileName,
    final String? downloadUrl,
    final String? thumbnailUrl,
    final String? error,
    final String? errorCode,
    final Map<String, dynamic>? metadata,
    final int fileSize,
    final DateTime? uploadedAt,
    final String? category,
    final String? description,
  }) = _$UploadResultImpl;

  factory _UploadResult.fromJson(Map<String, dynamic> json) =
      _$UploadResultImpl.fromJson;

  @override
  bool get success;
  @override
  String get fileId;
  @override
  String get fileName;
  @override
  String? get downloadUrl;
  @override
  String? get thumbnailUrl;
  @override
  String? get error;
  @override
  String? get errorCode;
  @override
  Map<String, dynamic>? get metadata;
  @override
  int get fileSize;
  @override
  DateTime? get uploadedAt;
  @override
  String? get category;
  @override
  String? get description;

  /// Create a copy of UploadResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadResultImplCopyWith<_$UploadResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BatchUploadResult _$BatchUploadResultFromJson(Map<String, dynamic> json) {
  return _BatchUploadResult.fromJson(json);
}

/// @nodoc
mixin _$BatchUploadResult {
  List<UploadResult> get results => throw _privateConstructorUsedError;
  int get totalFiles => throw _privateConstructorUsedError;
  int get successCount => throw _privateConstructorUsedError;
  int get failureCount => throw _privateConstructorUsedError;
  List<String> get errors => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this BatchUploadResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BatchUploadResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BatchUploadResultCopyWith<BatchUploadResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BatchUploadResultCopyWith<$Res> {
  factory $BatchUploadResultCopyWith(
    BatchUploadResult value,
    $Res Function(BatchUploadResult) then,
  ) = _$BatchUploadResultCopyWithImpl<$Res, BatchUploadResult>;
  @useResult
  $Res call({
    List<UploadResult> results,
    int totalFiles,
    int successCount,
    int failureCount,
    List<String> errors,
    DateTime? completedAt,
  });
}

/// @nodoc
class _$BatchUploadResultCopyWithImpl<$Res, $Val extends BatchUploadResult>
    implements $BatchUploadResultCopyWith<$Res> {
  _$BatchUploadResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BatchUploadResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? results = null,
    Object? totalFiles = null,
    Object? successCount = null,
    Object? failureCount = null,
    Object? errors = null,
    Object? completedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            results: null == results
                ? _value.results
                : results // ignore: cast_nullable_to_non_nullable
                      as List<UploadResult>,
            totalFiles: null == totalFiles
                ? _value.totalFiles
                : totalFiles // ignore: cast_nullable_to_non_nullable
                      as int,
            successCount: null == successCount
                ? _value.successCount
                : successCount // ignore: cast_nullable_to_non_nullable
                      as int,
            failureCount: null == failureCount
                ? _value.failureCount
                : failureCount // ignore: cast_nullable_to_non_nullable
                      as int,
            errors: null == errors
                ? _value.errors
                : errors // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BatchUploadResultImplCopyWith<$Res>
    implements $BatchUploadResultCopyWith<$Res> {
  factory _$$BatchUploadResultImplCopyWith(
    _$BatchUploadResultImpl value,
    $Res Function(_$BatchUploadResultImpl) then,
  ) = __$$BatchUploadResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<UploadResult> results,
    int totalFiles,
    int successCount,
    int failureCount,
    List<String> errors,
    DateTime? completedAt,
  });
}

/// @nodoc
class __$$BatchUploadResultImplCopyWithImpl<$Res>
    extends _$BatchUploadResultCopyWithImpl<$Res, _$BatchUploadResultImpl>
    implements _$$BatchUploadResultImplCopyWith<$Res> {
  __$$BatchUploadResultImplCopyWithImpl(
    _$BatchUploadResultImpl _value,
    $Res Function(_$BatchUploadResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BatchUploadResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? results = null,
    Object? totalFiles = null,
    Object? successCount = null,
    Object? failureCount = null,
    Object? errors = null,
    Object? completedAt = freezed,
  }) {
    return _then(
      _$BatchUploadResultImpl(
        results: null == results
            ? _value._results
            : results // ignore: cast_nullable_to_non_nullable
                  as List<UploadResult>,
        totalFiles: null == totalFiles
            ? _value.totalFiles
            : totalFiles // ignore: cast_nullable_to_non_nullable
                  as int,
        successCount: null == successCount
            ? _value.successCount
            : successCount // ignore: cast_nullable_to_non_nullable
                  as int,
        failureCount: null == failureCount
            ? _value.failureCount
            : failureCount // ignore: cast_nullable_to_non_nullable
                  as int,
        errors: null == errors
            ? _value._errors
            : errors // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BatchUploadResultImpl implements _BatchUploadResult {
  const _$BatchUploadResultImpl({
    required final List<UploadResult> results,
    required this.totalFiles,
    required this.successCount,
    required this.failureCount,
    final List<String> errors = const [],
    this.completedAt,
  }) : _results = results,
       _errors = errors;

  factory _$BatchUploadResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$BatchUploadResultImplFromJson(json);

  final List<UploadResult> _results;
  @override
  List<UploadResult> get results {
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  @override
  final int totalFiles;
  @override
  final int successCount;
  @override
  final int failureCount;
  final List<String> _errors;
  @override
  @JsonKey()
  List<String> get errors {
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_errors);
  }

  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'BatchUploadResult(results: $results, totalFiles: $totalFiles, successCount: $successCount, failureCount: $failureCount, errors: $errors, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BatchUploadResultImpl &&
            const DeepCollectionEquality().equals(other._results, _results) &&
            (identical(other.totalFiles, totalFiles) ||
                other.totalFiles == totalFiles) &&
            (identical(other.successCount, successCount) ||
                other.successCount == successCount) &&
            (identical(other.failureCount, failureCount) ||
                other.failureCount == failureCount) &&
            const DeepCollectionEquality().equals(other._errors, _errors) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_results),
    totalFiles,
    successCount,
    failureCount,
    const DeepCollectionEquality().hash(_errors),
    completedAt,
  );

  /// Create a copy of BatchUploadResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BatchUploadResultImplCopyWith<_$BatchUploadResultImpl> get copyWith =>
      __$$BatchUploadResultImplCopyWithImpl<_$BatchUploadResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BatchUploadResultImplToJson(this);
  }
}

abstract class _BatchUploadResult implements BatchUploadResult {
  const factory _BatchUploadResult({
    required final List<UploadResult> results,
    required final int totalFiles,
    required final int successCount,
    required final int failureCount,
    final List<String> errors,
    final DateTime? completedAt,
  }) = _$BatchUploadResultImpl;

  factory _BatchUploadResult.fromJson(Map<String, dynamic> json) =
      _$BatchUploadResultImpl.fromJson;

  @override
  List<UploadResult> get results;
  @override
  int get totalFiles;
  @override
  int get successCount;
  @override
  int get failureCount;
  @override
  List<String> get errors;
  @override
  DateTime? get completedAt;

  /// Create a copy of BatchUploadResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BatchUploadResultImplCopyWith<_$BatchUploadResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
