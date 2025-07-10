// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload_file_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UploadFileModel _$UploadFileModelFromJson(Map<String, dynamic> json) {
  return _UploadFileModel.fromJson(json);
}

/// @nodoc
mixin _$UploadFileModel {
  /// Unique identifier for this upload
  String get id => throw _privateConstructorUsedError;

  /// Original file (not serialized)
  @JsonKey(includeFromJson: false, includeToJson: false)
  XFile? get file => throw _privateConstructorUsedError;

  /// File name
  String get fileName => throw _privateConstructorUsedError;

  /// File size in bytes
  int get fileSize => throw _privateConstructorUsedError;

  /// File type/extension
  String get fileType => throw _privateConstructorUsedError;

  /// MIME type
  String get mimeType => throw _privateConstructorUsedError;

  /// Current upload status
  UploadStatus get status => throw _privateConstructorUsedError;

  /// Upload progress (0.0 to 1.0)
  double get progress => throw _privateConstructorUsedError;

  /// Bytes uploaded
  int get bytesUploaded => throw _privateConstructorUsedError;

  /// Upload speed in bytes per second
  int? get uploadSpeed => throw _privateConstructorUsedError;

  /// Estimated time remaining in seconds
  int? get estimatedTimeRemaining => throw _privateConstructorUsedError;

  /// Error message if upload failed
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Number of retry attempts
  int get retryAttempts => throw _privateConstructorUsedError;

  /// Maximum retry attempts allowed
  int get maxRetryAttempts => throw _privateConstructorUsedError;

  /// Category ID for this file
  String? get categoryId => throw _privateConstructorUsedError;

  /// Custom metadata for this file
  Map<String, String>? get customMetadata => throw _privateConstructorUsedError;

  /// Download URL after successful upload
  String? get downloadUrl => throw _privateConstructorUsedError;

  /// Document ID in Firestore after successful upload
  String? get documentId => throw _privateConstructorUsedError;

  /// Upload start time
  DateTime? get startTime => throw _privateConstructorUsedError;

  /// Upload completion time
  DateTime? get completionTime => throw _privateConstructorUsedError;

  /// File hash for duplicate detection
  String? get fileHash => throw _privateConstructorUsedError;

  /// Validation errors
  List<String>? get validationErrors => throw _privateConstructorUsedError;

  /// Serializes this UploadFileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UploadFileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UploadFileModelCopyWith<UploadFileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UploadFileModelCopyWith<$Res> {
  factory $UploadFileModelCopyWith(
    UploadFileModel value,
    $Res Function(UploadFileModel) then,
  ) = _$UploadFileModelCopyWithImpl<$Res, UploadFileModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(includeFromJson: false, includeToJson: false) XFile? file,
    String fileName,
    int fileSize,
    String fileType,
    String mimeType,
    UploadStatus status,
    double progress,
    int bytesUploaded,
    int? uploadSpeed,
    int? estimatedTimeRemaining,
    String? errorMessage,
    int retryAttempts,
    int maxRetryAttempts,
    String? categoryId,
    Map<String, String>? customMetadata,
    String? downloadUrl,
    String? documentId,
    DateTime? startTime,
    DateTime? completionTime,
    String? fileHash,
    List<String>? validationErrors,
  });
}

/// @nodoc
class _$UploadFileModelCopyWithImpl<$Res, $Val extends UploadFileModel>
    implements $UploadFileModelCopyWith<$Res> {
  _$UploadFileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UploadFileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? file = freezed,
    Object? fileName = null,
    Object? fileSize = null,
    Object? fileType = null,
    Object? mimeType = null,
    Object? status = null,
    Object? progress = null,
    Object? bytesUploaded = null,
    Object? uploadSpeed = freezed,
    Object? estimatedTimeRemaining = freezed,
    Object? errorMessage = freezed,
    Object? retryAttempts = null,
    Object? maxRetryAttempts = null,
    Object? categoryId = freezed,
    Object? customMetadata = freezed,
    Object? downloadUrl = freezed,
    Object? documentId = freezed,
    Object? startTime = freezed,
    Object? completionTime = freezed,
    Object? fileHash = freezed,
    Object? validationErrors = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            file: freezed == file
                ? _value.file
                : file // ignore: cast_nullable_to_non_nullable
                      as XFile?,
            fileName: null == fileName
                ? _value.fileName
                : fileName // ignore: cast_nullable_to_non_nullable
                      as String,
            fileSize: null == fileSize
                ? _value.fileSize
                : fileSize // ignore: cast_nullable_to_non_nullable
                      as int,
            fileType: null == fileType
                ? _value.fileType
                : fileType // ignore: cast_nullable_to_non_nullable
                      as String,
            mimeType: null == mimeType
                ? _value.mimeType
                : mimeType // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as UploadStatus,
            progress: null == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                      as double,
            bytesUploaded: null == bytesUploaded
                ? _value.bytesUploaded
                : bytesUploaded // ignore: cast_nullable_to_non_nullable
                      as int,
            uploadSpeed: freezed == uploadSpeed
                ? _value.uploadSpeed
                : uploadSpeed // ignore: cast_nullable_to_non_nullable
                      as int?,
            estimatedTimeRemaining: freezed == estimatedTimeRemaining
                ? _value.estimatedTimeRemaining
                : estimatedTimeRemaining // ignore: cast_nullable_to_non_nullable
                      as int?,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            retryAttempts: null == retryAttempts
                ? _value.retryAttempts
                : retryAttempts // ignore: cast_nullable_to_non_nullable
                      as int,
            maxRetryAttempts: null == maxRetryAttempts
                ? _value.maxRetryAttempts
                : maxRetryAttempts // ignore: cast_nullable_to_non_nullable
                      as int,
            categoryId: freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            customMetadata: freezed == customMetadata
                ? _value.customMetadata
                : customMetadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>?,
            downloadUrl: freezed == downloadUrl
                ? _value.downloadUrl
                : downloadUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            documentId: freezed == documentId
                ? _value.documentId
                : documentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            startTime: freezed == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completionTime: freezed == completionTime
                ? _value.completionTime
                : completionTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            fileHash: freezed == fileHash
                ? _value.fileHash
                : fileHash // ignore: cast_nullable_to_non_nullable
                      as String?,
            validationErrors: freezed == validationErrors
                ? _value.validationErrors
                : validationErrors // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UploadFileModelImplCopyWith<$Res>
    implements $UploadFileModelCopyWith<$Res> {
  factory _$$UploadFileModelImplCopyWith(
    _$UploadFileModelImpl value,
    $Res Function(_$UploadFileModelImpl) then,
  ) = __$$UploadFileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(includeFromJson: false, includeToJson: false) XFile? file,
    String fileName,
    int fileSize,
    String fileType,
    String mimeType,
    UploadStatus status,
    double progress,
    int bytesUploaded,
    int? uploadSpeed,
    int? estimatedTimeRemaining,
    String? errorMessage,
    int retryAttempts,
    int maxRetryAttempts,
    String? categoryId,
    Map<String, String>? customMetadata,
    String? downloadUrl,
    String? documentId,
    DateTime? startTime,
    DateTime? completionTime,
    String? fileHash,
    List<String>? validationErrors,
  });
}

/// @nodoc
class __$$UploadFileModelImplCopyWithImpl<$Res>
    extends _$UploadFileModelCopyWithImpl<$Res, _$UploadFileModelImpl>
    implements _$$UploadFileModelImplCopyWith<$Res> {
  __$$UploadFileModelImplCopyWithImpl(
    _$UploadFileModelImpl _value,
    $Res Function(_$UploadFileModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadFileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? file = freezed,
    Object? fileName = null,
    Object? fileSize = null,
    Object? fileType = null,
    Object? mimeType = null,
    Object? status = null,
    Object? progress = null,
    Object? bytesUploaded = null,
    Object? uploadSpeed = freezed,
    Object? estimatedTimeRemaining = freezed,
    Object? errorMessage = freezed,
    Object? retryAttempts = null,
    Object? maxRetryAttempts = null,
    Object? categoryId = freezed,
    Object? customMetadata = freezed,
    Object? downloadUrl = freezed,
    Object? documentId = freezed,
    Object? startTime = freezed,
    Object? completionTime = freezed,
    Object? fileHash = freezed,
    Object? validationErrors = freezed,
  }) {
    return _then(
      _$UploadFileModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        file: freezed == file
            ? _value.file
            : file // ignore: cast_nullable_to_non_nullable
                  as XFile?,
        fileName: null == fileName
            ? _value.fileName
            : fileName // ignore: cast_nullable_to_non_nullable
                  as String,
        fileSize: null == fileSize
            ? _value.fileSize
            : fileSize // ignore: cast_nullable_to_non_nullable
                  as int,
        fileType: null == fileType
            ? _value.fileType
            : fileType // ignore: cast_nullable_to_non_nullable
                  as String,
        mimeType: null == mimeType
            ? _value.mimeType
            : mimeType // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as UploadStatus,
        progress: null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as double,
        bytesUploaded: null == bytesUploaded
            ? _value.bytesUploaded
            : bytesUploaded // ignore: cast_nullable_to_non_nullable
                  as int,
        uploadSpeed: freezed == uploadSpeed
            ? _value.uploadSpeed
            : uploadSpeed // ignore: cast_nullable_to_non_nullable
                  as int?,
        estimatedTimeRemaining: freezed == estimatedTimeRemaining
            ? _value.estimatedTimeRemaining
            : estimatedTimeRemaining // ignore: cast_nullable_to_non_nullable
                  as int?,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        retryAttempts: null == retryAttempts
            ? _value.retryAttempts
            : retryAttempts // ignore: cast_nullable_to_non_nullable
                  as int,
        maxRetryAttempts: null == maxRetryAttempts
            ? _value.maxRetryAttempts
            : maxRetryAttempts // ignore: cast_nullable_to_non_nullable
                  as int,
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        customMetadata: freezed == customMetadata
            ? _value._customMetadata
            : customMetadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
        downloadUrl: freezed == downloadUrl
            ? _value.downloadUrl
            : downloadUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        documentId: freezed == documentId
            ? _value.documentId
            : documentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        startTime: freezed == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completionTime: freezed == completionTime
            ? _value.completionTime
            : completionTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        fileHash: freezed == fileHash
            ? _value.fileHash
            : fileHash // ignore: cast_nullable_to_non_nullable
                  as String?,
        validationErrors: freezed == validationErrors
            ? _value._validationErrors
            : validationErrors // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UploadFileModelImpl implements _UploadFileModel {
  const _$UploadFileModelImpl({
    required this.id,
    @JsonKey(includeFromJson: false, includeToJson: false) this.file,
    required this.fileName,
    required this.fileSize,
    required this.fileType,
    required this.mimeType,
    this.status = UploadStatus.pending,
    this.progress = 0.0,
    this.bytesUploaded = 0,
    this.uploadSpeed,
    this.estimatedTimeRemaining,
    this.errorMessage,
    this.retryAttempts = 0,
    this.maxRetryAttempts = 3,
    this.categoryId,
    final Map<String, String>? customMetadata,
    this.downloadUrl,
    this.documentId,
    this.startTime,
    this.completionTime,
    this.fileHash,
    final List<String>? validationErrors,
  }) : _customMetadata = customMetadata,
       _validationErrors = validationErrors;

  factory _$UploadFileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UploadFileModelImplFromJson(json);

  /// Unique identifier for this upload
  @override
  final String id;

  /// Original file (not serialized)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final XFile? file;

  /// File name
  @override
  final String fileName;

  /// File size in bytes
  @override
  final int fileSize;

  /// File type/extension
  @override
  final String fileType;

  /// MIME type
  @override
  final String mimeType;

  /// Current upload status
  @override
  @JsonKey()
  final UploadStatus status;

  /// Upload progress (0.0 to 1.0)
  @override
  @JsonKey()
  final double progress;

  /// Bytes uploaded
  @override
  @JsonKey()
  final int bytesUploaded;

  /// Upload speed in bytes per second
  @override
  final int? uploadSpeed;

  /// Estimated time remaining in seconds
  @override
  final int? estimatedTimeRemaining;

  /// Error message if upload failed
  @override
  final String? errorMessage;

  /// Number of retry attempts
  @override
  @JsonKey()
  final int retryAttempts;

  /// Maximum retry attempts allowed
  @override
  @JsonKey()
  final int maxRetryAttempts;

  /// Category ID for this file
  @override
  final String? categoryId;

  /// Custom metadata for this file
  final Map<String, String>? _customMetadata;

  /// Custom metadata for this file
  @override
  Map<String, String>? get customMetadata {
    final value = _customMetadata;
    if (value == null) return null;
    if (_customMetadata is EqualUnmodifiableMapView) return _customMetadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Download URL after successful upload
  @override
  final String? downloadUrl;

  /// Document ID in Firestore after successful upload
  @override
  final String? documentId;

  /// Upload start time
  @override
  final DateTime? startTime;

  /// Upload completion time
  @override
  final DateTime? completionTime;

  /// File hash for duplicate detection
  @override
  final String? fileHash;

  /// Validation errors
  final List<String>? _validationErrors;

  /// Validation errors
  @override
  List<String>? get validationErrors {
    final value = _validationErrors;
    if (value == null) return null;
    if (_validationErrors is EqualUnmodifiableListView)
      return _validationErrors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'UploadFileModel(id: $id, file: $file, fileName: $fileName, fileSize: $fileSize, fileType: $fileType, mimeType: $mimeType, status: $status, progress: $progress, bytesUploaded: $bytesUploaded, uploadSpeed: $uploadSpeed, estimatedTimeRemaining: $estimatedTimeRemaining, errorMessage: $errorMessage, retryAttempts: $retryAttempts, maxRetryAttempts: $maxRetryAttempts, categoryId: $categoryId, customMetadata: $customMetadata, downloadUrl: $downloadUrl, documentId: $documentId, startTime: $startTime, completionTime: $completionTime, fileHash: $fileHash, validationErrors: $validationErrors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadFileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.file, file) || other.file == file) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.fileType, fileType) ||
                other.fileType == fileType) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.bytesUploaded, bytesUploaded) ||
                other.bytesUploaded == bytesUploaded) &&
            (identical(other.uploadSpeed, uploadSpeed) ||
                other.uploadSpeed == uploadSpeed) &&
            (identical(other.estimatedTimeRemaining, estimatedTimeRemaining) ||
                other.estimatedTimeRemaining == estimatedTimeRemaining) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.retryAttempts, retryAttempts) ||
                other.retryAttempts == retryAttempts) &&
            (identical(other.maxRetryAttempts, maxRetryAttempts) ||
                other.maxRetryAttempts == maxRetryAttempts) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            const DeepCollectionEquality().equals(
              other._customMetadata,
              _customMetadata,
            ) &&
            (identical(other.downloadUrl, downloadUrl) ||
                other.downloadUrl == downloadUrl) &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.completionTime, completionTime) ||
                other.completionTime == completionTime) &&
            (identical(other.fileHash, fileHash) ||
                other.fileHash == fileHash) &&
            const DeepCollectionEquality().equals(
              other._validationErrors,
              _validationErrors,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    file,
    fileName,
    fileSize,
    fileType,
    mimeType,
    status,
    progress,
    bytesUploaded,
    uploadSpeed,
    estimatedTimeRemaining,
    errorMessage,
    retryAttempts,
    maxRetryAttempts,
    categoryId,
    const DeepCollectionEquality().hash(_customMetadata),
    downloadUrl,
    documentId,
    startTime,
    completionTime,
    fileHash,
    const DeepCollectionEquality().hash(_validationErrors),
  ]);

  /// Create a copy of UploadFileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadFileModelImplCopyWith<_$UploadFileModelImpl> get copyWith =>
      __$$UploadFileModelImplCopyWithImpl<_$UploadFileModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UploadFileModelImplToJson(this);
  }
}

abstract class _UploadFileModel implements UploadFileModel {
  const factory _UploadFileModel({
    required final String id,
    @JsonKey(includeFromJson: false, includeToJson: false) final XFile? file,
    required final String fileName,
    required final int fileSize,
    required final String fileType,
    required final String mimeType,
    final UploadStatus status,
    final double progress,
    final int bytesUploaded,
    final int? uploadSpeed,
    final int? estimatedTimeRemaining,
    final String? errorMessage,
    final int retryAttempts,
    final int maxRetryAttempts,
    final String? categoryId,
    final Map<String, String>? customMetadata,
    final String? downloadUrl,
    final String? documentId,
    final DateTime? startTime,
    final DateTime? completionTime,
    final String? fileHash,
    final List<String>? validationErrors,
  }) = _$UploadFileModelImpl;

  factory _UploadFileModel.fromJson(Map<String, dynamic> json) =
      _$UploadFileModelImpl.fromJson;

  /// Unique identifier for this upload
  @override
  String get id;

  /// Original file (not serialized)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  XFile? get file;

  /// File name
  @override
  String get fileName;

  /// File size in bytes
  @override
  int get fileSize;

  /// File type/extension
  @override
  String get fileType;

  /// MIME type
  @override
  String get mimeType;

  /// Current upload status
  @override
  UploadStatus get status;

  /// Upload progress (0.0 to 1.0)
  @override
  double get progress;

  /// Bytes uploaded
  @override
  int get bytesUploaded;

  /// Upload speed in bytes per second
  @override
  int? get uploadSpeed;

  /// Estimated time remaining in seconds
  @override
  int? get estimatedTimeRemaining;

  /// Error message if upload failed
  @override
  String? get errorMessage;

  /// Number of retry attempts
  @override
  int get retryAttempts;

  /// Maximum retry attempts allowed
  @override
  int get maxRetryAttempts;

  /// Category ID for this file
  @override
  String? get categoryId;

  /// Custom metadata for this file
  @override
  Map<String, String>? get customMetadata;

  /// Download URL after successful upload
  @override
  String? get downloadUrl;

  /// Document ID in Firestore after successful upload
  @override
  String? get documentId;

  /// Upload start time
  @override
  DateTime? get startTime;

  /// Upload completion time
  @override
  DateTime? get completionTime;

  /// File hash for duplicate detection
  @override
  String? get fileHash;

  /// Validation errors
  @override
  List<String>? get validationErrors;

  /// Create a copy of UploadFileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadFileModelImplCopyWith<_$UploadFileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
