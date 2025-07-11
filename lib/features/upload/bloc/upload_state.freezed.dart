// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UploadState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) validating,
    required TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    ready,
    required TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    uploading,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    paused,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    completed,
    required TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )
    error,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )
    cancelled,
    required TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )
    success,
    required TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )
    inProgress,
    required TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )
    partialSuccess,
    required TResult Function(String message, List<UploadFileModel> files)
    networkError,
    required TResult Function(String message, List<UploadFileModel> files)
    storageError,
    required TResult Function(
      String message,
      List<UploadFileModel> invalidFiles,
    )
    validationError,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? validating,
    TResult? Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult? Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult? Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult? Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult? Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult? Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult? Function(String message, List<UploadFileModel> files)?
    networkError,
    TResult? Function(String message, List<UploadFileModel> files)?
    storageError,
    TResult? Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? validating,
    TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult Function(String message, List<UploadFileModel> files)? networkError,
    TResult Function(String message, List<UploadFileModel> files)? storageError,
    TResult Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UploadInitial value) initial,
    required TResult Function(UploadValidating value) validating,
    required TResult Function(UploadReady value) ready,
    required TResult Function(UploadUploading value) uploading,
    required TResult Function(UploadPaused value) paused,
    required TResult Function(UploadCompleted value) completed,
    required TResult Function(UploadError value) error,
    required TResult Function(UploadCancelled value) cancelled,
    required TResult Function(UploadSuccess value) success,
    required TResult Function(UploadInProgress value) inProgress,
    required TResult Function(UploadPartialSuccess value) partialSuccess,
    required TResult Function(UploadNetworkError value) networkError,
    required TResult Function(UploadStorageError value) storageError,
    required TResult Function(UploadValidationError value) validationError,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UploadInitial value)? initial,
    TResult? Function(UploadValidating value)? validating,
    TResult? Function(UploadReady value)? ready,
    TResult? Function(UploadUploading value)? uploading,
    TResult? Function(UploadPaused value)? paused,
    TResult? Function(UploadCompleted value)? completed,
    TResult? Function(UploadError value)? error,
    TResult? Function(UploadCancelled value)? cancelled,
    TResult? Function(UploadSuccess value)? success,
    TResult? Function(UploadInProgress value)? inProgress,
    TResult? Function(UploadPartialSuccess value)? partialSuccess,
    TResult? Function(UploadNetworkError value)? networkError,
    TResult? Function(UploadStorageError value)? storageError,
    TResult? Function(UploadValidationError value)? validationError,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UploadInitial value)? initial,
    TResult Function(UploadValidating value)? validating,
    TResult Function(UploadReady value)? ready,
    TResult Function(UploadUploading value)? uploading,
    TResult Function(UploadPaused value)? paused,
    TResult Function(UploadCompleted value)? completed,
    TResult Function(UploadError value)? error,
    TResult Function(UploadCancelled value)? cancelled,
    TResult Function(UploadSuccess value)? success,
    TResult Function(UploadInProgress value)? inProgress,
    TResult Function(UploadPartialSuccess value)? partialSuccess,
    TResult Function(UploadNetworkError value)? networkError,
    TResult Function(UploadStorageError value)? storageError,
    TResult Function(UploadValidationError value)? validationError,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UploadStateCopyWith<$Res> {
  factory $UploadStateCopyWith(
    UploadState value,
    $Res Function(UploadState) then,
  ) = _$UploadStateCopyWithImpl<$Res, UploadState>;
}

/// @nodoc
class _$UploadStateCopyWithImpl<$Res, $Val extends UploadState>
    implements $UploadStateCopyWith<$Res> {
  _$UploadStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$UploadInitialImplCopyWith<$Res> {
  factory _$$UploadInitialImplCopyWith(
    _$UploadInitialImpl value,
    $Res Function(_$UploadInitialImpl) then,
  ) = __$$UploadInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UploadInitialImplCopyWithImpl<$Res>
    extends _$UploadStateCopyWithImpl<$Res, _$UploadInitialImpl>
    implements _$$UploadInitialImplCopyWith<$Res> {
  __$$UploadInitialImplCopyWithImpl(
    _$UploadInitialImpl _value,
    $Res Function(_$UploadInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UploadInitialImpl implements UploadInitial {
  const _$UploadInitialImpl();

  @override
  String toString() {
    return 'UploadState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UploadInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) validating,
    required TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    ready,
    required TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    uploading,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    paused,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    completed,
    required TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )
    error,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )
    cancelled,
    required TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )
    success,
    required TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )
    inProgress,
    required TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )
    partialSuccess,
    required TResult Function(String message, List<UploadFileModel> files)
    networkError,
    required TResult Function(String message, List<UploadFileModel> files)
    storageError,
    required TResult Function(
      String message,
      List<UploadFileModel> invalidFiles,
    )
    validationError,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? validating,
    TResult? Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult? Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult? Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult? Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult? Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult? Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult? Function(String message, List<UploadFileModel> files)?
    networkError,
    TResult? Function(String message, List<UploadFileModel> files)?
    storageError,
    TResult? Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? validating,
    TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult Function(String message, List<UploadFileModel> files)? networkError,
    TResult Function(String message, List<UploadFileModel> files)? storageError,
    TResult Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
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
    required TResult Function(UploadInitial value) initial,
    required TResult Function(UploadValidating value) validating,
    required TResult Function(UploadReady value) ready,
    required TResult Function(UploadUploading value) uploading,
    required TResult Function(UploadPaused value) paused,
    required TResult Function(UploadCompleted value) completed,
    required TResult Function(UploadError value) error,
    required TResult Function(UploadCancelled value) cancelled,
    required TResult Function(UploadSuccess value) success,
    required TResult Function(UploadInProgress value) inProgress,
    required TResult Function(UploadPartialSuccess value) partialSuccess,
    required TResult Function(UploadNetworkError value) networkError,
    required TResult Function(UploadStorageError value) storageError,
    required TResult Function(UploadValidationError value) validationError,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UploadInitial value)? initial,
    TResult? Function(UploadValidating value)? validating,
    TResult? Function(UploadReady value)? ready,
    TResult? Function(UploadUploading value)? uploading,
    TResult? Function(UploadPaused value)? paused,
    TResult? Function(UploadCompleted value)? completed,
    TResult? Function(UploadError value)? error,
    TResult? Function(UploadCancelled value)? cancelled,
    TResult? Function(UploadSuccess value)? success,
    TResult? Function(UploadInProgress value)? inProgress,
    TResult? Function(UploadPartialSuccess value)? partialSuccess,
    TResult? Function(UploadNetworkError value)? networkError,
    TResult? Function(UploadStorageError value)? storageError,
    TResult? Function(UploadValidationError value)? validationError,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UploadInitial value)? initial,
    TResult Function(UploadValidating value)? validating,
    TResult Function(UploadReady value)? ready,
    TResult Function(UploadUploading value)? uploading,
    TResult Function(UploadPaused value)? paused,
    TResult Function(UploadCompleted value)? completed,
    TResult Function(UploadError value)? error,
    TResult Function(UploadCancelled value)? cancelled,
    TResult Function(UploadSuccess value)? success,
    TResult Function(UploadInProgress value)? inProgress,
    TResult Function(UploadPartialSuccess value)? partialSuccess,
    TResult Function(UploadNetworkError value)? networkError,
    TResult Function(UploadStorageError value)? storageError,
    TResult Function(UploadValidationError value)? validationError,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class UploadInitial implements UploadState {
  const factory UploadInitial() = _$UploadInitialImpl;
}

/// @nodoc
abstract class _$$UploadValidatingImplCopyWith<$Res> {
  factory _$$UploadValidatingImplCopyWith(
    _$UploadValidatingImpl value,
    $Res Function(_$UploadValidatingImpl) then,
  ) = __$$UploadValidatingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$UploadValidatingImplCopyWithImpl<$Res>
    extends _$UploadStateCopyWithImpl<$Res, _$UploadValidatingImpl>
    implements _$$UploadValidatingImplCopyWith<$Res> {
  __$$UploadValidatingImplCopyWithImpl(
    _$UploadValidatingImpl _value,
    $Res Function(_$UploadValidatingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = freezed}) {
    return _then(
      _$UploadValidatingImpl(
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$UploadValidatingImpl implements UploadValidating {
  const _$UploadValidatingImpl({this.message});

  @override
  final String? message;

  @override
  String toString() {
    return 'UploadState.validating(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadValidatingImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadValidatingImplCopyWith<_$UploadValidatingImpl> get copyWith =>
      __$$UploadValidatingImplCopyWithImpl<_$UploadValidatingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) validating,
    required TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    ready,
    required TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    uploading,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    paused,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    completed,
    required TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )
    error,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )
    cancelled,
    required TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )
    success,
    required TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )
    inProgress,
    required TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )
    partialSuccess,
    required TResult Function(String message, List<UploadFileModel> files)
    networkError,
    required TResult Function(String message, List<UploadFileModel> files)
    storageError,
    required TResult Function(
      String message,
      List<UploadFileModel> invalidFiles,
    )
    validationError,
  }) {
    return validating(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? validating,
    TResult? Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult? Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult? Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult? Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult? Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult? Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult? Function(String message, List<UploadFileModel> files)?
    networkError,
    TResult? Function(String message, List<UploadFileModel> files)?
    storageError,
    TResult? Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
  }) {
    return validating?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? validating,
    TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult Function(String message, List<UploadFileModel> files)? networkError,
    TResult Function(String message, List<UploadFileModel> files)? storageError,
    TResult Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
    required TResult orElse(),
  }) {
    if (validating != null) {
      return validating(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UploadInitial value) initial,
    required TResult Function(UploadValidating value) validating,
    required TResult Function(UploadReady value) ready,
    required TResult Function(UploadUploading value) uploading,
    required TResult Function(UploadPaused value) paused,
    required TResult Function(UploadCompleted value) completed,
    required TResult Function(UploadError value) error,
    required TResult Function(UploadCancelled value) cancelled,
    required TResult Function(UploadSuccess value) success,
    required TResult Function(UploadInProgress value) inProgress,
    required TResult Function(UploadPartialSuccess value) partialSuccess,
    required TResult Function(UploadNetworkError value) networkError,
    required TResult Function(UploadStorageError value) storageError,
    required TResult Function(UploadValidationError value) validationError,
  }) {
    return validating(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UploadInitial value)? initial,
    TResult? Function(UploadValidating value)? validating,
    TResult? Function(UploadReady value)? ready,
    TResult? Function(UploadUploading value)? uploading,
    TResult? Function(UploadPaused value)? paused,
    TResult? Function(UploadCompleted value)? completed,
    TResult? Function(UploadError value)? error,
    TResult? Function(UploadCancelled value)? cancelled,
    TResult? Function(UploadSuccess value)? success,
    TResult? Function(UploadInProgress value)? inProgress,
    TResult? Function(UploadPartialSuccess value)? partialSuccess,
    TResult? Function(UploadNetworkError value)? networkError,
    TResult? Function(UploadStorageError value)? storageError,
    TResult? Function(UploadValidationError value)? validationError,
  }) {
    return validating?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UploadInitial value)? initial,
    TResult Function(UploadValidating value)? validating,
    TResult Function(UploadReady value)? ready,
    TResult Function(UploadUploading value)? uploading,
    TResult Function(UploadPaused value)? paused,
    TResult Function(UploadCompleted value)? completed,
    TResult Function(UploadError value)? error,
    TResult Function(UploadCancelled value)? cancelled,
    TResult Function(UploadSuccess value)? success,
    TResult Function(UploadInProgress value)? inProgress,
    TResult Function(UploadPartialSuccess value)? partialSuccess,
    TResult Function(UploadNetworkError value)? networkError,
    TResult Function(UploadStorageError value)? storageError,
    TResult Function(UploadValidationError value)? validationError,
    required TResult orElse(),
  }) {
    if (validating != null) {
      return validating(this);
    }
    return orElse();
  }
}

abstract class UploadValidating implements UploadState {
  const factory UploadValidating({final String? message}) =
      _$UploadValidatingImpl;

  String? get message;

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadValidatingImplCopyWith<_$UploadValidatingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UploadReadyImplCopyWith<$Res> {
  factory _$$UploadReadyImplCopyWith(
    _$UploadReadyImpl value,
    $Res Function(_$UploadReadyImpl) then,
  ) = __$$UploadReadyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<UploadFileModel> files,
    int totalFiles,
    int totalSize,
    String? categoryId,
    Map<String, String>? customMetadata,
  });
}

/// @nodoc
class __$$UploadReadyImplCopyWithImpl<$Res>
    extends _$UploadStateCopyWithImpl<$Res, _$UploadReadyImpl>
    implements _$$UploadReadyImplCopyWith<$Res> {
  __$$UploadReadyImplCopyWithImpl(
    _$UploadReadyImpl _value,
    $Res Function(_$UploadReadyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? files = null,
    Object? totalFiles = null,
    Object? totalSize = null,
    Object? categoryId = freezed,
    Object? customMetadata = freezed,
  }) {
    return _then(
      _$UploadReadyImpl(
        files: null == files
            ? _value._files
            : files // ignore: cast_nullable_to_non_nullable
                  as List<UploadFileModel>,
        totalFiles: null == totalFiles
            ? _value.totalFiles
            : totalFiles // ignore: cast_nullable_to_non_nullable
                  as int,
        totalSize: null == totalSize
            ? _value.totalSize
            : totalSize // ignore: cast_nullable_to_non_nullable
                  as int,
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        customMetadata: freezed == customMetadata
            ? _value._customMetadata
            : customMetadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
      ),
    );
  }
}

/// @nodoc

class _$UploadReadyImpl implements UploadReady {
  const _$UploadReadyImpl({
    required final List<UploadFileModel> files,
    required this.totalFiles,
    required this.totalSize,
    this.categoryId,
    final Map<String, String>? customMetadata,
  }) : _files = files,
       _customMetadata = customMetadata;

  final List<UploadFileModel> _files;
  @override
  List<UploadFileModel> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  @override
  final int totalFiles;
  @override
  final int totalSize;
  @override
  final String? categoryId;
  final Map<String, String>? _customMetadata;
  @override
  Map<String, String>? get customMetadata {
    final value = _customMetadata;
    if (value == null) return null;
    if (_customMetadata is EqualUnmodifiableMapView) return _customMetadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'UploadState.ready(files: $files, totalFiles: $totalFiles, totalSize: $totalSize, categoryId: $categoryId, customMetadata: $customMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadReadyImpl &&
            const DeepCollectionEquality().equals(other._files, _files) &&
            (identical(other.totalFiles, totalFiles) ||
                other.totalFiles == totalFiles) &&
            (identical(other.totalSize, totalSize) ||
                other.totalSize == totalSize) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            const DeepCollectionEquality().equals(
              other._customMetadata,
              _customMetadata,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_files),
    totalFiles,
    totalSize,
    categoryId,
    const DeepCollectionEquality().hash(_customMetadata),
  );

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadReadyImplCopyWith<_$UploadReadyImpl> get copyWith =>
      __$$UploadReadyImplCopyWithImpl<_$UploadReadyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) validating,
    required TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    ready,
    required TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    uploading,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    paused,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    completed,
    required TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )
    error,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )
    cancelled,
    required TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )
    success,
    required TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )
    inProgress,
    required TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )
    partialSuccess,
    required TResult Function(String message, List<UploadFileModel> files)
    networkError,
    required TResult Function(String message, List<UploadFileModel> files)
    storageError,
    required TResult Function(
      String message,
      List<UploadFileModel> invalidFiles,
    )
    validationError,
  }) {
    return ready(files, totalFiles, totalSize, categoryId, customMetadata);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? validating,
    TResult? Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult? Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult? Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult? Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult? Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult? Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult? Function(String message, List<UploadFileModel> files)?
    networkError,
    TResult? Function(String message, List<UploadFileModel> files)?
    storageError,
    TResult? Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
  }) {
    return ready?.call(
      files,
      totalFiles,
      totalSize,
      categoryId,
      customMetadata,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? validating,
    TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult Function(String message, List<UploadFileModel> files)? networkError,
    TResult Function(String message, List<UploadFileModel> files)? storageError,
    TResult Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
    required TResult orElse(),
  }) {
    if (ready != null) {
      return ready(files, totalFiles, totalSize, categoryId, customMetadata);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UploadInitial value) initial,
    required TResult Function(UploadValidating value) validating,
    required TResult Function(UploadReady value) ready,
    required TResult Function(UploadUploading value) uploading,
    required TResult Function(UploadPaused value) paused,
    required TResult Function(UploadCompleted value) completed,
    required TResult Function(UploadError value) error,
    required TResult Function(UploadCancelled value) cancelled,
    required TResult Function(UploadSuccess value) success,
    required TResult Function(UploadInProgress value) inProgress,
    required TResult Function(UploadPartialSuccess value) partialSuccess,
    required TResult Function(UploadNetworkError value) networkError,
    required TResult Function(UploadStorageError value) storageError,
    required TResult Function(UploadValidationError value) validationError,
  }) {
    return ready(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UploadInitial value)? initial,
    TResult? Function(UploadValidating value)? validating,
    TResult? Function(UploadReady value)? ready,
    TResult? Function(UploadUploading value)? uploading,
    TResult? Function(UploadPaused value)? paused,
    TResult? Function(UploadCompleted value)? completed,
    TResult? Function(UploadError value)? error,
    TResult? Function(UploadCancelled value)? cancelled,
    TResult? Function(UploadSuccess value)? success,
    TResult? Function(UploadInProgress value)? inProgress,
    TResult? Function(UploadPartialSuccess value)? partialSuccess,
    TResult? Function(UploadNetworkError value)? networkError,
    TResult? Function(UploadStorageError value)? storageError,
    TResult? Function(UploadValidationError value)? validationError,
  }) {
    return ready?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UploadInitial value)? initial,
    TResult Function(UploadValidating value)? validating,
    TResult Function(UploadReady value)? ready,
    TResult Function(UploadUploading value)? uploading,
    TResult Function(UploadPaused value)? paused,
    TResult Function(UploadCompleted value)? completed,
    TResult Function(UploadError value)? error,
    TResult Function(UploadCancelled value)? cancelled,
    TResult Function(UploadSuccess value)? success,
    TResult Function(UploadInProgress value)? inProgress,
    TResult Function(UploadPartialSuccess value)? partialSuccess,
    TResult Function(UploadNetworkError value)? networkError,
    TResult Function(UploadStorageError value)? storageError,
    TResult Function(UploadValidationError value)? validationError,
    required TResult orElse(),
  }) {
    if (ready != null) {
      return ready(this);
    }
    return orElse();
  }
}

abstract class UploadReady implements UploadState {
  const factory UploadReady({
    required final List<UploadFileModel> files,
    required final int totalFiles,
    required final int totalSize,
    final String? categoryId,
    final Map<String, String>? customMetadata,
  }) = _$UploadReadyImpl;

  List<UploadFileModel> get files;
  int get totalFiles;
  int get totalSize;
  String? get categoryId;
  Map<String, String>? get customMetadata;

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadReadyImplCopyWith<_$UploadReadyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UploadUploadingImplCopyWith<$Res> {
  factory _$$UploadUploadingImplCopyWith(
    _$UploadUploadingImpl value,
    $Res Function(_$UploadUploadingImpl) then,
  ) = __$$UploadUploadingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<UploadFileModel> files,
    int activeUploads,
    int completedFiles,
    int failedFiles,
    int totalFiles,
    double overallProgress,
    int? uploadSpeed,
    int? estimatedTimeRemaining,
    String? categoryId,
    Map<String, String>? customMetadata,
  });
}

/// @nodoc
class __$$UploadUploadingImplCopyWithImpl<$Res>
    extends _$UploadStateCopyWithImpl<$Res, _$UploadUploadingImpl>
    implements _$$UploadUploadingImplCopyWith<$Res> {
  __$$UploadUploadingImplCopyWithImpl(
    _$UploadUploadingImpl _value,
    $Res Function(_$UploadUploadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? files = null,
    Object? activeUploads = null,
    Object? completedFiles = null,
    Object? failedFiles = null,
    Object? totalFiles = null,
    Object? overallProgress = null,
    Object? uploadSpeed = freezed,
    Object? estimatedTimeRemaining = freezed,
    Object? categoryId = freezed,
    Object? customMetadata = freezed,
  }) {
    return _then(
      _$UploadUploadingImpl(
        files: null == files
            ? _value._files
            : files // ignore: cast_nullable_to_non_nullable
                  as List<UploadFileModel>,
        activeUploads: null == activeUploads
            ? _value.activeUploads
            : activeUploads // ignore: cast_nullable_to_non_nullable
                  as int,
        completedFiles: null == completedFiles
            ? _value.completedFiles
            : completedFiles // ignore: cast_nullable_to_non_nullable
                  as int,
        failedFiles: null == failedFiles
            ? _value.failedFiles
            : failedFiles // ignore: cast_nullable_to_non_nullable
                  as int,
        totalFiles: null == totalFiles
            ? _value.totalFiles
            : totalFiles // ignore: cast_nullable_to_non_nullable
                  as int,
        overallProgress: null == overallProgress
            ? _value.overallProgress
            : overallProgress // ignore: cast_nullable_to_non_nullable
                  as double,
        uploadSpeed: freezed == uploadSpeed
            ? _value.uploadSpeed
            : uploadSpeed // ignore: cast_nullable_to_non_nullable
                  as int?,
        estimatedTimeRemaining: freezed == estimatedTimeRemaining
            ? _value.estimatedTimeRemaining
            : estimatedTimeRemaining // ignore: cast_nullable_to_non_nullable
                  as int?,
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        customMetadata: freezed == customMetadata
            ? _value._customMetadata
            : customMetadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
      ),
    );
  }
}

/// @nodoc

class _$UploadUploadingImpl implements UploadUploading {
  const _$UploadUploadingImpl({
    required final List<UploadFileModel> files,
    required this.activeUploads,
    required this.completedFiles,
    required this.failedFiles,
    required this.totalFiles,
    required this.overallProgress,
    this.uploadSpeed,
    this.estimatedTimeRemaining,
    this.categoryId,
    final Map<String, String>? customMetadata,
  }) : _files = files,
       _customMetadata = customMetadata;

  final List<UploadFileModel> _files;
  @override
  List<UploadFileModel> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  @override
  final int activeUploads;
  @override
  final int completedFiles;
  @override
  final int failedFiles;
  @override
  final int totalFiles;
  @override
  final double overallProgress;
  @override
  final int? uploadSpeed;
  @override
  final int? estimatedTimeRemaining;
  @override
  final String? categoryId;
  final Map<String, String>? _customMetadata;
  @override
  Map<String, String>? get customMetadata {
    final value = _customMetadata;
    if (value == null) return null;
    if (_customMetadata is EqualUnmodifiableMapView) return _customMetadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'UploadState.uploading(files: $files, activeUploads: $activeUploads, completedFiles: $completedFiles, failedFiles: $failedFiles, totalFiles: $totalFiles, overallProgress: $overallProgress, uploadSpeed: $uploadSpeed, estimatedTimeRemaining: $estimatedTimeRemaining, categoryId: $categoryId, customMetadata: $customMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadUploadingImpl &&
            const DeepCollectionEquality().equals(other._files, _files) &&
            (identical(other.activeUploads, activeUploads) ||
                other.activeUploads == activeUploads) &&
            (identical(other.completedFiles, completedFiles) ||
                other.completedFiles == completedFiles) &&
            (identical(other.failedFiles, failedFiles) ||
                other.failedFiles == failedFiles) &&
            (identical(other.totalFiles, totalFiles) ||
                other.totalFiles == totalFiles) &&
            (identical(other.overallProgress, overallProgress) ||
                other.overallProgress == overallProgress) &&
            (identical(other.uploadSpeed, uploadSpeed) ||
                other.uploadSpeed == uploadSpeed) &&
            (identical(other.estimatedTimeRemaining, estimatedTimeRemaining) ||
                other.estimatedTimeRemaining == estimatedTimeRemaining) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            const DeepCollectionEquality().equals(
              other._customMetadata,
              _customMetadata,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_files),
    activeUploads,
    completedFiles,
    failedFiles,
    totalFiles,
    overallProgress,
    uploadSpeed,
    estimatedTimeRemaining,
    categoryId,
    const DeepCollectionEquality().hash(_customMetadata),
  );

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadUploadingImplCopyWith<_$UploadUploadingImpl> get copyWith =>
      __$$UploadUploadingImplCopyWithImpl<_$UploadUploadingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) validating,
    required TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    ready,
    required TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    uploading,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    paused,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    completed,
    required TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )
    error,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )
    cancelled,
    required TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )
    success,
    required TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )
    inProgress,
    required TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )
    partialSuccess,
    required TResult Function(String message, List<UploadFileModel> files)
    networkError,
    required TResult Function(String message, List<UploadFileModel> files)
    storageError,
    required TResult Function(
      String message,
      List<UploadFileModel> invalidFiles,
    )
    validationError,
  }) {
    return uploading(
      files,
      activeUploads,
      completedFiles,
      failedFiles,
      totalFiles,
      overallProgress,
      uploadSpeed,
      estimatedTimeRemaining,
      categoryId,
      customMetadata,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? validating,
    TResult? Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult? Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult? Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult? Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult? Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult? Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult? Function(String message, List<UploadFileModel> files)?
    networkError,
    TResult? Function(String message, List<UploadFileModel> files)?
    storageError,
    TResult? Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
  }) {
    return uploading?.call(
      files,
      activeUploads,
      completedFiles,
      failedFiles,
      totalFiles,
      overallProgress,
      uploadSpeed,
      estimatedTimeRemaining,
      categoryId,
      customMetadata,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? validating,
    TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult Function(String message, List<UploadFileModel> files)? networkError,
    TResult Function(String message, List<UploadFileModel> files)? storageError,
    TResult Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
    required TResult orElse(),
  }) {
    if (uploading != null) {
      return uploading(
        files,
        activeUploads,
        completedFiles,
        failedFiles,
        totalFiles,
        overallProgress,
        uploadSpeed,
        estimatedTimeRemaining,
        categoryId,
        customMetadata,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UploadInitial value) initial,
    required TResult Function(UploadValidating value) validating,
    required TResult Function(UploadReady value) ready,
    required TResult Function(UploadUploading value) uploading,
    required TResult Function(UploadPaused value) paused,
    required TResult Function(UploadCompleted value) completed,
    required TResult Function(UploadError value) error,
    required TResult Function(UploadCancelled value) cancelled,
    required TResult Function(UploadSuccess value) success,
    required TResult Function(UploadInProgress value) inProgress,
    required TResult Function(UploadPartialSuccess value) partialSuccess,
    required TResult Function(UploadNetworkError value) networkError,
    required TResult Function(UploadStorageError value) storageError,
    required TResult Function(UploadValidationError value) validationError,
  }) {
    return uploading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UploadInitial value)? initial,
    TResult? Function(UploadValidating value)? validating,
    TResult? Function(UploadReady value)? ready,
    TResult? Function(UploadUploading value)? uploading,
    TResult? Function(UploadPaused value)? paused,
    TResult? Function(UploadCompleted value)? completed,
    TResult? Function(UploadError value)? error,
    TResult? Function(UploadCancelled value)? cancelled,
    TResult? Function(UploadSuccess value)? success,
    TResult? Function(UploadInProgress value)? inProgress,
    TResult? Function(UploadPartialSuccess value)? partialSuccess,
    TResult? Function(UploadNetworkError value)? networkError,
    TResult? Function(UploadStorageError value)? storageError,
    TResult? Function(UploadValidationError value)? validationError,
  }) {
    return uploading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UploadInitial value)? initial,
    TResult Function(UploadValidating value)? validating,
    TResult Function(UploadReady value)? ready,
    TResult Function(UploadUploading value)? uploading,
    TResult Function(UploadPaused value)? paused,
    TResult Function(UploadCompleted value)? completed,
    TResult Function(UploadError value)? error,
    TResult Function(UploadCancelled value)? cancelled,
    TResult Function(UploadSuccess value)? success,
    TResult Function(UploadInProgress value)? inProgress,
    TResult Function(UploadPartialSuccess value)? partialSuccess,
    TResult Function(UploadNetworkError value)? networkError,
    TResult Function(UploadStorageError value)? storageError,
    TResult Function(UploadValidationError value)? validationError,
    required TResult orElse(),
  }) {
    if (uploading != null) {
      return uploading(this);
    }
    return orElse();
  }
}

abstract class UploadUploading implements UploadState {
  const factory UploadUploading({
    required final List<UploadFileModel> files,
    required final int activeUploads,
    required final int completedFiles,
    required final int failedFiles,
    required final int totalFiles,
    required final double overallProgress,
    final int? uploadSpeed,
    final int? estimatedTimeRemaining,
    final String? categoryId,
    final Map<String, String>? customMetadata,
  }) = _$UploadUploadingImpl;

  List<UploadFileModel> get files;
  int get activeUploads;
  int get completedFiles;
  int get failedFiles;
  int get totalFiles;
  double get overallProgress;
  int? get uploadSpeed;
  int? get estimatedTimeRemaining;
  String? get categoryId;
  Map<String, String>? get customMetadata;

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadUploadingImplCopyWith<_$UploadUploadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UploadPausedImplCopyWith<$Res> {
  factory _$$UploadPausedImplCopyWith(
    _$UploadPausedImpl value,
    $Res Function(_$UploadPausedImpl) then,
  ) = __$$UploadPausedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<UploadFileModel> files,
    int completedFiles,
    int failedFiles,
    int totalFiles,
    double overallProgress,
    int pausedFiles,
    String? categoryId,
    Map<String, String>? customMetadata,
  });
}

/// @nodoc
class __$$UploadPausedImplCopyWithImpl<$Res>
    extends _$UploadStateCopyWithImpl<$Res, _$UploadPausedImpl>
    implements _$$UploadPausedImplCopyWith<$Res> {
  __$$UploadPausedImplCopyWithImpl(
    _$UploadPausedImpl _value,
    $Res Function(_$UploadPausedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? files = null,
    Object? completedFiles = null,
    Object? failedFiles = null,
    Object? totalFiles = null,
    Object? overallProgress = null,
    Object? pausedFiles = null,
    Object? categoryId = freezed,
    Object? customMetadata = freezed,
  }) {
    return _then(
      _$UploadPausedImpl(
        files: null == files
            ? _value._files
            : files // ignore: cast_nullable_to_non_nullable
                  as List<UploadFileModel>,
        completedFiles: null == completedFiles
            ? _value.completedFiles
            : completedFiles // ignore: cast_nullable_to_non_nullable
                  as int,
        failedFiles: null == failedFiles
            ? _value.failedFiles
            : failedFiles // ignore: cast_nullable_to_non_nullable
                  as int,
        totalFiles: null == totalFiles
            ? _value.totalFiles
            : totalFiles // ignore: cast_nullable_to_non_nullable
                  as int,
        overallProgress: null == overallProgress
            ? _value.overallProgress
            : overallProgress // ignore: cast_nullable_to_non_nullable
                  as double,
        pausedFiles: null == pausedFiles
            ? _value.pausedFiles
            : pausedFiles // ignore: cast_nullable_to_non_nullable
                  as int,
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        customMetadata: freezed == customMetadata
            ? _value._customMetadata
            : customMetadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
      ),
    );
  }
}

/// @nodoc

class _$UploadPausedImpl implements UploadPaused {
  const _$UploadPausedImpl({
    required final List<UploadFileModel> files,
    required this.completedFiles,
    required this.failedFiles,
    required this.totalFiles,
    required this.overallProgress,
    required this.pausedFiles,
    this.categoryId,
    final Map<String, String>? customMetadata,
  }) : _files = files,
       _customMetadata = customMetadata;

  final List<UploadFileModel> _files;
  @override
  List<UploadFileModel> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  @override
  final int completedFiles;
  @override
  final int failedFiles;
  @override
  final int totalFiles;
  @override
  final double overallProgress;
  @override
  final int pausedFiles;
  @override
  final String? categoryId;
  final Map<String, String>? _customMetadata;
  @override
  Map<String, String>? get customMetadata {
    final value = _customMetadata;
    if (value == null) return null;
    if (_customMetadata is EqualUnmodifiableMapView) return _customMetadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'UploadState.paused(files: $files, completedFiles: $completedFiles, failedFiles: $failedFiles, totalFiles: $totalFiles, overallProgress: $overallProgress, pausedFiles: $pausedFiles, categoryId: $categoryId, customMetadata: $customMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadPausedImpl &&
            const DeepCollectionEquality().equals(other._files, _files) &&
            (identical(other.completedFiles, completedFiles) ||
                other.completedFiles == completedFiles) &&
            (identical(other.failedFiles, failedFiles) ||
                other.failedFiles == failedFiles) &&
            (identical(other.totalFiles, totalFiles) ||
                other.totalFiles == totalFiles) &&
            (identical(other.overallProgress, overallProgress) ||
                other.overallProgress == overallProgress) &&
            (identical(other.pausedFiles, pausedFiles) ||
                other.pausedFiles == pausedFiles) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            const DeepCollectionEquality().equals(
              other._customMetadata,
              _customMetadata,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_files),
    completedFiles,
    failedFiles,
    totalFiles,
    overallProgress,
    pausedFiles,
    categoryId,
    const DeepCollectionEquality().hash(_customMetadata),
  );

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadPausedImplCopyWith<_$UploadPausedImpl> get copyWith =>
      __$$UploadPausedImplCopyWithImpl<_$UploadPausedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) validating,
    required TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    ready,
    required TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    uploading,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    paused,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    completed,
    required TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )
    error,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )
    cancelled,
    required TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )
    success,
    required TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )
    inProgress,
    required TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )
    partialSuccess,
    required TResult Function(String message, List<UploadFileModel> files)
    networkError,
    required TResult Function(String message, List<UploadFileModel> files)
    storageError,
    required TResult Function(
      String message,
      List<UploadFileModel> invalidFiles,
    )
    validationError,
  }) {
    return paused(
      files,
      completedFiles,
      failedFiles,
      totalFiles,
      overallProgress,
      pausedFiles,
      categoryId,
      customMetadata,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? validating,
    TResult? Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult? Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult? Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult? Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult? Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult? Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult? Function(String message, List<UploadFileModel> files)?
    networkError,
    TResult? Function(String message, List<UploadFileModel> files)?
    storageError,
    TResult? Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
  }) {
    return paused?.call(
      files,
      completedFiles,
      failedFiles,
      totalFiles,
      overallProgress,
      pausedFiles,
      categoryId,
      customMetadata,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? validating,
    TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult Function(String message, List<UploadFileModel> files)? networkError,
    TResult Function(String message, List<UploadFileModel> files)? storageError,
    TResult Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
    required TResult orElse(),
  }) {
    if (paused != null) {
      return paused(
        files,
        completedFiles,
        failedFiles,
        totalFiles,
        overallProgress,
        pausedFiles,
        categoryId,
        customMetadata,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UploadInitial value) initial,
    required TResult Function(UploadValidating value) validating,
    required TResult Function(UploadReady value) ready,
    required TResult Function(UploadUploading value) uploading,
    required TResult Function(UploadPaused value) paused,
    required TResult Function(UploadCompleted value) completed,
    required TResult Function(UploadError value) error,
    required TResult Function(UploadCancelled value) cancelled,
    required TResult Function(UploadSuccess value) success,
    required TResult Function(UploadInProgress value) inProgress,
    required TResult Function(UploadPartialSuccess value) partialSuccess,
    required TResult Function(UploadNetworkError value) networkError,
    required TResult Function(UploadStorageError value) storageError,
    required TResult Function(UploadValidationError value) validationError,
  }) {
    return paused(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UploadInitial value)? initial,
    TResult? Function(UploadValidating value)? validating,
    TResult? Function(UploadReady value)? ready,
    TResult? Function(UploadUploading value)? uploading,
    TResult? Function(UploadPaused value)? paused,
    TResult? Function(UploadCompleted value)? completed,
    TResult? Function(UploadError value)? error,
    TResult? Function(UploadCancelled value)? cancelled,
    TResult? Function(UploadSuccess value)? success,
    TResult? Function(UploadInProgress value)? inProgress,
    TResult? Function(UploadPartialSuccess value)? partialSuccess,
    TResult? Function(UploadNetworkError value)? networkError,
    TResult? Function(UploadStorageError value)? storageError,
    TResult? Function(UploadValidationError value)? validationError,
  }) {
    return paused?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UploadInitial value)? initial,
    TResult Function(UploadValidating value)? validating,
    TResult Function(UploadReady value)? ready,
    TResult Function(UploadUploading value)? uploading,
    TResult Function(UploadPaused value)? paused,
    TResult Function(UploadCompleted value)? completed,
    TResult Function(UploadError value)? error,
    TResult Function(UploadCancelled value)? cancelled,
    TResult Function(UploadSuccess value)? success,
    TResult Function(UploadInProgress value)? inProgress,
    TResult Function(UploadPartialSuccess value)? partialSuccess,
    TResult Function(UploadNetworkError value)? networkError,
    TResult Function(UploadStorageError value)? storageError,
    TResult Function(UploadValidationError value)? validationError,
    required TResult orElse(),
  }) {
    if (paused != null) {
      return paused(this);
    }
    return orElse();
  }
}

abstract class UploadPaused implements UploadState {
  const factory UploadPaused({
    required final List<UploadFileModel> files,
    required final int completedFiles,
    required final int failedFiles,
    required final int totalFiles,
    required final double overallProgress,
    required final int pausedFiles,
    final String? categoryId,
    final Map<String, String>? customMetadata,
  }) = _$UploadPausedImpl;

  List<UploadFileModel> get files;
  int get completedFiles;
  int get failedFiles;
  int get totalFiles;
  double get overallProgress;
  int get pausedFiles;
  String? get categoryId;
  Map<String, String>? get customMetadata;

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadPausedImplCopyWith<_$UploadPausedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UploadCompletedImplCopyWith<$Res> {
  factory _$$UploadCompletedImplCopyWith(
    _$UploadCompletedImpl value,
    $Res Function(_$UploadCompletedImpl) then,
  ) = __$$UploadCompletedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<UploadFileModel> files,
    int completedFiles,
    int failedFiles,
    int totalFiles,
    int? totalUploadTime,
    String? categoryId,
    Map<String, String>? customMetadata,
  });
}

/// @nodoc
class __$$UploadCompletedImplCopyWithImpl<$Res>
    extends _$UploadStateCopyWithImpl<$Res, _$UploadCompletedImpl>
    implements _$$UploadCompletedImplCopyWith<$Res> {
  __$$UploadCompletedImplCopyWithImpl(
    _$UploadCompletedImpl _value,
    $Res Function(_$UploadCompletedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? files = null,
    Object? completedFiles = null,
    Object? failedFiles = null,
    Object? totalFiles = null,
    Object? totalUploadTime = freezed,
    Object? categoryId = freezed,
    Object? customMetadata = freezed,
  }) {
    return _then(
      _$UploadCompletedImpl(
        files: null == files
            ? _value._files
            : files // ignore: cast_nullable_to_non_nullable
                  as List<UploadFileModel>,
        completedFiles: null == completedFiles
            ? _value.completedFiles
            : completedFiles // ignore: cast_nullable_to_non_nullable
                  as int,
        failedFiles: null == failedFiles
            ? _value.failedFiles
            : failedFiles // ignore: cast_nullable_to_non_nullable
                  as int,
        totalFiles: null == totalFiles
            ? _value.totalFiles
            : totalFiles // ignore: cast_nullable_to_non_nullable
                  as int,
        totalUploadTime: freezed == totalUploadTime
            ? _value.totalUploadTime
            : totalUploadTime // ignore: cast_nullable_to_non_nullable
                  as int?,
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        customMetadata: freezed == customMetadata
            ? _value._customMetadata
            : customMetadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
      ),
    );
  }
}

/// @nodoc

class _$UploadCompletedImpl implements UploadCompleted {
  const _$UploadCompletedImpl({
    required final List<UploadFileModel> files,
    required this.completedFiles,
    required this.failedFiles,
    required this.totalFiles,
    this.totalUploadTime,
    this.categoryId,
    final Map<String, String>? customMetadata,
  }) : _files = files,
       _customMetadata = customMetadata;

  final List<UploadFileModel> _files;
  @override
  List<UploadFileModel> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  @override
  final int completedFiles;
  @override
  final int failedFiles;
  @override
  final int totalFiles;
  @override
  final int? totalUploadTime;
  @override
  final String? categoryId;
  final Map<String, String>? _customMetadata;
  @override
  Map<String, String>? get customMetadata {
    final value = _customMetadata;
    if (value == null) return null;
    if (_customMetadata is EqualUnmodifiableMapView) return _customMetadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'UploadState.completed(files: $files, completedFiles: $completedFiles, failedFiles: $failedFiles, totalFiles: $totalFiles, totalUploadTime: $totalUploadTime, categoryId: $categoryId, customMetadata: $customMetadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadCompletedImpl &&
            const DeepCollectionEquality().equals(other._files, _files) &&
            (identical(other.completedFiles, completedFiles) ||
                other.completedFiles == completedFiles) &&
            (identical(other.failedFiles, failedFiles) ||
                other.failedFiles == failedFiles) &&
            (identical(other.totalFiles, totalFiles) ||
                other.totalFiles == totalFiles) &&
            (identical(other.totalUploadTime, totalUploadTime) ||
                other.totalUploadTime == totalUploadTime) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            const DeepCollectionEquality().equals(
              other._customMetadata,
              _customMetadata,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_files),
    completedFiles,
    failedFiles,
    totalFiles,
    totalUploadTime,
    categoryId,
    const DeepCollectionEquality().hash(_customMetadata),
  );

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadCompletedImplCopyWith<_$UploadCompletedImpl> get copyWith =>
      __$$UploadCompletedImplCopyWithImpl<_$UploadCompletedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) validating,
    required TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    ready,
    required TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    uploading,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    paused,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    completed,
    required TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )
    error,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )
    cancelled,
    required TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )
    success,
    required TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )
    inProgress,
    required TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )
    partialSuccess,
    required TResult Function(String message, List<UploadFileModel> files)
    networkError,
    required TResult Function(String message, List<UploadFileModel> files)
    storageError,
    required TResult Function(
      String message,
      List<UploadFileModel> invalidFiles,
    )
    validationError,
  }) {
    return completed(
      files,
      completedFiles,
      failedFiles,
      totalFiles,
      totalUploadTime,
      categoryId,
      customMetadata,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? validating,
    TResult? Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult? Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult? Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult? Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult? Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult? Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult? Function(String message, List<UploadFileModel> files)?
    networkError,
    TResult? Function(String message, List<UploadFileModel> files)?
    storageError,
    TResult? Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
  }) {
    return completed?.call(
      files,
      completedFiles,
      failedFiles,
      totalFiles,
      totalUploadTime,
      categoryId,
      customMetadata,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? validating,
    TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult Function(String message, List<UploadFileModel> files)? networkError,
    TResult Function(String message, List<UploadFileModel> files)? storageError,
    TResult Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(
        files,
        completedFiles,
        failedFiles,
        totalFiles,
        totalUploadTime,
        categoryId,
        customMetadata,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UploadInitial value) initial,
    required TResult Function(UploadValidating value) validating,
    required TResult Function(UploadReady value) ready,
    required TResult Function(UploadUploading value) uploading,
    required TResult Function(UploadPaused value) paused,
    required TResult Function(UploadCompleted value) completed,
    required TResult Function(UploadError value) error,
    required TResult Function(UploadCancelled value) cancelled,
    required TResult Function(UploadSuccess value) success,
    required TResult Function(UploadInProgress value) inProgress,
    required TResult Function(UploadPartialSuccess value) partialSuccess,
    required TResult Function(UploadNetworkError value) networkError,
    required TResult Function(UploadStorageError value) storageError,
    required TResult Function(UploadValidationError value) validationError,
  }) {
    return completed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UploadInitial value)? initial,
    TResult? Function(UploadValidating value)? validating,
    TResult? Function(UploadReady value)? ready,
    TResult? Function(UploadUploading value)? uploading,
    TResult? Function(UploadPaused value)? paused,
    TResult? Function(UploadCompleted value)? completed,
    TResult? Function(UploadError value)? error,
    TResult? Function(UploadCancelled value)? cancelled,
    TResult? Function(UploadSuccess value)? success,
    TResult? Function(UploadInProgress value)? inProgress,
    TResult? Function(UploadPartialSuccess value)? partialSuccess,
    TResult? Function(UploadNetworkError value)? networkError,
    TResult? Function(UploadStorageError value)? storageError,
    TResult? Function(UploadValidationError value)? validationError,
  }) {
    return completed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UploadInitial value)? initial,
    TResult Function(UploadValidating value)? validating,
    TResult Function(UploadReady value)? ready,
    TResult Function(UploadUploading value)? uploading,
    TResult Function(UploadPaused value)? paused,
    TResult Function(UploadCompleted value)? completed,
    TResult Function(UploadError value)? error,
    TResult Function(UploadCancelled value)? cancelled,
    TResult Function(UploadSuccess value)? success,
    TResult Function(UploadInProgress value)? inProgress,
    TResult Function(UploadPartialSuccess value)? partialSuccess,
    TResult Function(UploadNetworkError value)? networkError,
    TResult Function(UploadStorageError value)? storageError,
    TResult Function(UploadValidationError value)? validationError,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(this);
    }
    return orElse();
  }
}

abstract class UploadCompleted implements UploadState {
  const factory UploadCompleted({
    required final List<UploadFileModel> files,
    required final int completedFiles,
    required final int failedFiles,
    required final int totalFiles,
    final int? totalUploadTime,
    final String? categoryId,
    final Map<String, String>? customMetadata,
  }) = _$UploadCompletedImpl;

  List<UploadFileModel> get files;
  int get completedFiles;
  int get failedFiles;
  int get totalFiles;
  int? get totalUploadTime;
  String? get categoryId;
  Map<String, String>? get customMetadata;

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadCompletedImplCopyWith<_$UploadCompletedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UploadErrorImplCopyWith<$Res> {
  factory _$$UploadErrorImplCopyWith(
    _$UploadErrorImpl value,
    $Res Function(_$UploadErrorImpl) then,
  ) = __$$UploadErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String message,
    List<UploadFileModel>? files,
    bool canRetry,
    UploadState? previousState,
  });

  $UploadStateCopyWith<$Res>? get previousState;
}

/// @nodoc
class __$$UploadErrorImplCopyWithImpl<$Res>
    extends _$UploadStateCopyWithImpl<$Res, _$UploadErrorImpl>
    implements _$$UploadErrorImplCopyWith<$Res> {
  __$$UploadErrorImplCopyWithImpl(
    _$UploadErrorImpl _value,
    $Res Function(_$UploadErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? files = freezed,
    Object? canRetry = null,
    Object? previousState = freezed,
  }) {
    return _then(
      _$UploadErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        files: freezed == files
            ? _value._files
            : files // ignore: cast_nullable_to_non_nullable
                  as List<UploadFileModel>?,
        canRetry: null == canRetry
            ? _value.canRetry
            : canRetry // ignore: cast_nullable_to_non_nullable
                  as bool,
        previousState: freezed == previousState
            ? _value.previousState
            : previousState // ignore: cast_nullable_to_non_nullable
                  as UploadState?,
      ),
    );
  }

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UploadStateCopyWith<$Res>? get previousState {
    if (_value.previousState == null) {
      return null;
    }

    return $UploadStateCopyWith<$Res>(_value.previousState!, (value) {
      return _then(_value.copyWith(previousState: value));
    });
  }
}

/// @nodoc

class _$UploadErrorImpl implements UploadError {
  const _$UploadErrorImpl({
    required this.message,
    final List<UploadFileModel>? files,
    this.canRetry = true,
    this.previousState,
  }) : _files = files;

  @override
  final String message;
  final List<UploadFileModel>? _files;
  @override
  List<UploadFileModel>? get files {
    final value = _files;
    if (value == null) return null;
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final bool canRetry;
  @override
  final UploadState? previousState;

  @override
  String toString() {
    return 'UploadState.error(message: $message, files: $files, canRetry: $canRetry, previousState: $previousState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._files, _files) &&
            (identical(other.canRetry, canRetry) ||
                other.canRetry == canRetry) &&
            (identical(other.previousState, previousState) ||
                other.previousState == previousState));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(_files),
    canRetry,
    previousState,
  );

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadErrorImplCopyWith<_$UploadErrorImpl> get copyWith =>
      __$$UploadErrorImplCopyWithImpl<_$UploadErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) validating,
    required TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    ready,
    required TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    uploading,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    paused,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    completed,
    required TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )
    error,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )
    cancelled,
    required TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )
    success,
    required TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )
    inProgress,
    required TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )
    partialSuccess,
    required TResult Function(String message, List<UploadFileModel> files)
    networkError,
    required TResult Function(String message, List<UploadFileModel> files)
    storageError,
    required TResult Function(
      String message,
      List<UploadFileModel> invalidFiles,
    )
    validationError,
  }) {
    return error(message, files, canRetry, previousState);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? validating,
    TResult? Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult? Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult? Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult? Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult? Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult? Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult? Function(String message, List<UploadFileModel> files)?
    networkError,
    TResult? Function(String message, List<UploadFileModel> files)?
    storageError,
    TResult? Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
  }) {
    return error?.call(message, files, canRetry, previousState);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? validating,
    TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult Function(String message, List<UploadFileModel> files)? networkError,
    TResult Function(String message, List<UploadFileModel> files)? storageError,
    TResult Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message, files, canRetry, previousState);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UploadInitial value) initial,
    required TResult Function(UploadValidating value) validating,
    required TResult Function(UploadReady value) ready,
    required TResult Function(UploadUploading value) uploading,
    required TResult Function(UploadPaused value) paused,
    required TResult Function(UploadCompleted value) completed,
    required TResult Function(UploadError value) error,
    required TResult Function(UploadCancelled value) cancelled,
    required TResult Function(UploadSuccess value) success,
    required TResult Function(UploadInProgress value) inProgress,
    required TResult Function(UploadPartialSuccess value) partialSuccess,
    required TResult Function(UploadNetworkError value) networkError,
    required TResult Function(UploadStorageError value) storageError,
    required TResult Function(UploadValidationError value) validationError,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UploadInitial value)? initial,
    TResult? Function(UploadValidating value)? validating,
    TResult? Function(UploadReady value)? ready,
    TResult? Function(UploadUploading value)? uploading,
    TResult? Function(UploadPaused value)? paused,
    TResult? Function(UploadCompleted value)? completed,
    TResult? Function(UploadError value)? error,
    TResult? Function(UploadCancelled value)? cancelled,
    TResult? Function(UploadSuccess value)? success,
    TResult? Function(UploadInProgress value)? inProgress,
    TResult? Function(UploadPartialSuccess value)? partialSuccess,
    TResult? Function(UploadNetworkError value)? networkError,
    TResult? Function(UploadStorageError value)? storageError,
    TResult? Function(UploadValidationError value)? validationError,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UploadInitial value)? initial,
    TResult Function(UploadValidating value)? validating,
    TResult Function(UploadReady value)? ready,
    TResult Function(UploadUploading value)? uploading,
    TResult Function(UploadPaused value)? paused,
    TResult Function(UploadCompleted value)? completed,
    TResult Function(UploadError value)? error,
    TResult Function(UploadCancelled value)? cancelled,
    TResult Function(UploadSuccess value)? success,
    TResult Function(UploadInProgress value)? inProgress,
    TResult Function(UploadPartialSuccess value)? partialSuccess,
    TResult Function(UploadNetworkError value)? networkError,
    TResult Function(UploadStorageError value)? storageError,
    TResult Function(UploadValidationError value)? validationError,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class UploadError implements UploadState {
  const factory UploadError({
    required final String message,
    final List<UploadFileModel>? files,
    final bool canRetry,
    final UploadState? previousState,
  }) = _$UploadErrorImpl;

  String get message;
  List<UploadFileModel>? get files;
  bool get canRetry;
  UploadState? get previousState;

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadErrorImplCopyWith<_$UploadErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UploadCancelledImplCopyWith<$Res> {
  factory _$$UploadCancelledImplCopyWith(
    _$UploadCancelledImpl value,
    $Res Function(_$UploadCancelledImpl) then,
  ) = __$$UploadCancelledImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<UploadFileModel> files,
    int completedFiles,
    int cancelledFiles,
  });
}

/// @nodoc
class __$$UploadCancelledImplCopyWithImpl<$Res>
    extends _$UploadStateCopyWithImpl<$Res, _$UploadCancelledImpl>
    implements _$$UploadCancelledImplCopyWith<$Res> {
  __$$UploadCancelledImplCopyWithImpl(
    _$UploadCancelledImpl _value,
    $Res Function(_$UploadCancelledImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? files = null,
    Object? completedFiles = null,
    Object? cancelledFiles = null,
  }) {
    return _then(
      _$UploadCancelledImpl(
        files: null == files
            ? _value._files
            : files // ignore: cast_nullable_to_non_nullable
                  as List<UploadFileModel>,
        completedFiles: null == completedFiles
            ? _value.completedFiles
            : completedFiles // ignore: cast_nullable_to_non_nullable
                  as int,
        cancelledFiles: null == cancelledFiles
            ? _value.cancelledFiles
            : cancelledFiles // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$UploadCancelledImpl implements UploadCancelled {
  const _$UploadCancelledImpl({
    required final List<UploadFileModel> files,
    required this.completedFiles,
    required this.cancelledFiles,
  }) : _files = files;

  final List<UploadFileModel> _files;
  @override
  List<UploadFileModel> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  @override
  final int completedFiles;
  @override
  final int cancelledFiles;

  @override
  String toString() {
    return 'UploadState.cancelled(files: $files, completedFiles: $completedFiles, cancelledFiles: $cancelledFiles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadCancelledImpl &&
            const DeepCollectionEquality().equals(other._files, _files) &&
            (identical(other.completedFiles, completedFiles) ||
                other.completedFiles == completedFiles) &&
            (identical(other.cancelledFiles, cancelledFiles) ||
                other.cancelledFiles == cancelledFiles));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_files),
    completedFiles,
    cancelledFiles,
  );

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadCancelledImplCopyWith<_$UploadCancelledImpl> get copyWith =>
      __$$UploadCancelledImplCopyWithImpl<_$UploadCancelledImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) validating,
    required TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    ready,
    required TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    uploading,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    paused,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    completed,
    required TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )
    error,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )
    cancelled,
    required TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )
    success,
    required TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )
    inProgress,
    required TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )
    partialSuccess,
    required TResult Function(String message, List<UploadFileModel> files)
    networkError,
    required TResult Function(String message, List<UploadFileModel> files)
    storageError,
    required TResult Function(
      String message,
      List<UploadFileModel> invalidFiles,
    )
    validationError,
  }) {
    return cancelled(files, completedFiles, cancelledFiles);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? validating,
    TResult? Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult? Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult? Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult? Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult? Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult? Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult? Function(String message, List<UploadFileModel> files)?
    networkError,
    TResult? Function(String message, List<UploadFileModel> files)?
    storageError,
    TResult? Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
  }) {
    return cancelled?.call(files, completedFiles, cancelledFiles);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? validating,
    TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult Function(String message, List<UploadFileModel> files)? networkError,
    TResult Function(String message, List<UploadFileModel> files)? storageError,
    TResult Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
    required TResult orElse(),
  }) {
    if (cancelled != null) {
      return cancelled(files, completedFiles, cancelledFiles);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UploadInitial value) initial,
    required TResult Function(UploadValidating value) validating,
    required TResult Function(UploadReady value) ready,
    required TResult Function(UploadUploading value) uploading,
    required TResult Function(UploadPaused value) paused,
    required TResult Function(UploadCompleted value) completed,
    required TResult Function(UploadError value) error,
    required TResult Function(UploadCancelled value) cancelled,
    required TResult Function(UploadSuccess value) success,
    required TResult Function(UploadInProgress value) inProgress,
    required TResult Function(UploadPartialSuccess value) partialSuccess,
    required TResult Function(UploadNetworkError value) networkError,
    required TResult Function(UploadStorageError value) storageError,
    required TResult Function(UploadValidationError value) validationError,
  }) {
    return cancelled(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UploadInitial value)? initial,
    TResult? Function(UploadValidating value)? validating,
    TResult? Function(UploadReady value)? ready,
    TResult? Function(UploadUploading value)? uploading,
    TResult? Function(UploadPaused value)? paused,
    TResult? Function(UploadCompleted value)? completed,
    TResult? Function(UploadError value)? error,
    TResult? Function(UploadCancelled value)? cancelled,
    TResult? Function(UploadSuccess value)? success,
    TResult? Function(UploadInProgress value)? inProgress,
    TResult? Function(UploadPartialSuccess value)? partialSuccess,
    TResult? Function(UploadNetworkError value)? networkError,
    TResult? Function(UploadStorageError value)? storageError,
    TResult? Function(UploadValidationError value)? validationError,
  }) {
    return cancelled?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UploadInitial value)? initial,
    TResult Function(UploadValidating value)? validating,
    TResult Function(UploadReady value)? ready,
    TResult Function(UploadUploading value)? uploading,
    TResult Function(UploadPaused value)? paused,
    TResult Function(UploadCompleted value)? completed,
    TResult Function(UploadError value)? error,
    TResult Function(UploadCancelled value)? cancelled,
    TResult Function(UploadSuccess value)? success,
    TResult Function(UploadInProgress value)? inProgress,
    TResult Function(UploadPartialSuccess value)? partialSuccess,
    TResult Function(UploadNetworkError value)? networkError,
    TResult Function(UploadStorageError value)? storageError,
    TResult Function(UploadValidationError value)? validationError,
    required TResult orElse(),
  }) {
    if (cancelled != null) {
      return cancelled(this);
    }
    return orElse();
  }
}

abstract class UploadCancelled implements UploadState {
  const factory UploadCancelled({
    required final List<UploadFileModel> files,
    required final int completedFiles,
    required final int cancelledFiles,
  }) = _$UploadCancelledImpl;

  List<UploadFileModel> get files;
  int get completedFiles;
  int get cancelledFiles;

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadCancelledImplCopyWith<_$UploadCancelledImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UploadSuccessImplCopyWith<$Res> {
  factory _$$UploadSuccessImplCopyWith(
    _$UploadSuccessImpl value,
    $Res Function(_$UploadSuccessImpl) then,
  ) = __$$UploadSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<UploadFileModel> uploadedFiles,
    int totalFiles,
    int? totalUploadTime,
  });
}

/// @nodoc
class __$$UploadSuccessImplCopyWithImpl<$Res>
    extends _$UploadStateCopyWithImpl<$Res, _$UploadSuccessImpl>
    implements _$$UploadSuccessImplCopyWith<$Res> {
  __$$UploadSuccessImplCopyWithImpl(
    _$UploadSuccessImpl _value,
    $Res Function(_$UploadSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uploadedFiles = null,
    Object? totalFiles = null,
    Object? totalUploadTime = freezed,
  }) {
    return _then(
      _$UploadSuccessImpl(
        uploadedFiles: null == uploadedFiles
            ? _value._uploadedFiles
            : uploadedFiles // ignore: cast_nullable_to_non_nullable
                  as List<UploadFileModel>,
        totalFiles: null == totalFiles
            ? _value.totalFiles
            : totalFiles // ignore: cast_nullable_to_non_nullable
                  as int,
        totalUploadTime: freezed == totalUploadTime
            ? _value.totalUploadTime
            : totalUploadTime // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$UploadSuccessImpl implements UploadSuccess {
  const _$UploadSuccessImpl({
    required final List<UploadFileModel> uploadedFiles,
    required this.totalFiles,
    this.totalUploadTime,
  }) : _uploadedFiles = uploadedFiles;

  final List<UploadFileModel> _uploadedFiles;
  @override
  List<UploadFileModel> get uploadedFiles {
    if (_uploadedFiles is EqualUnmodifiableListView) return _uploadedFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_uploadedFiles);
  }

  @override
  final int totalFiles;
  @override
  final int? totalUploadTime;

  @override
  String toString() {
    return 'UploadState.success(uploadedFiles: $uploadedFiles, totalFiles: $totalFiles, totalUploadTime: $totalUploadTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadSuccessImpl &&
            const DeepCollectionEquality().equals(
              other._uploadedFiles,
              _uploadedFiles,
            ) &&
            (identical(other.totalFiles, totalFiles) ||
                other.totalFiles == totalFiles) &&
            (identical(other.totalUploadTime, totalUploadTime) ||
                other.totalUploadTime == totalUploadTime));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_uploadedFiles),
    totalFiles,
    totalUploadTime,
  );

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadSuccessImplCopyWith<_$UploadSuccessImpl> get copyWith =>
      __$$UploadSuccessImplCopyWithImpl<_$UploadSuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) validating,
    required TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    ready,
    required TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    uploading,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    paused,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    completed,
    required TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )
    error,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )
    cancelled,
    required TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )
    success,
    required TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )
    inProgress,
    required TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )
    partialSuccess,
    required TResult Function(String message, List<UploadFileModel> files)
    networkError,
    required TResult Function(String message, List<UploadFileModel> files)
    storageError,
    required TResult Function(
      String message,
      List<UploadFileModel> invalidFiles,
    )
    validationError,
  }) {
    return success(uploadedFiles, totalFiles, totalUploadTime);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? validating,
    TResult? Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult? Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult? Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult? Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult? Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult? Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult? Function(String message, List<UploadFileModel> files)?
    networkError,
    TResult? Function(String message, List<UploadFileModel> files)?
    storageError,
    TResult? Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
  }) {
    return success?.call(uploadedFiles, totalFiles, totalUploadTime);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? validating,
    TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult Function(String message, List<UploadFileModel> files)? networkError,
    TResult Function(String message, List<UploadFileModel> files)? storageError,
    TResult Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(uploadedFiles, totalFiles, totalUploadTime);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UploadInitial value) initial,
    required TResult Function(UploadValidating value) validating,
    required TResult Function(UploadReady value) ready,
    required TResult Function(UploadUploading value) uploading,
    required TResult Function(UploadPaused value) paused,
    required TResult Function(UploadCompleted value) completed,
    required TResult Function(UploadError value) error,
    required TResult Function(UploadCancelled value) cancelled,
    required TResult Function(UploadSuccess value) success,
    required TResult Function(UploadInProgress value) inProgress,
    required TResult Function(UploadPartialSuccess value) partialSuccess,
    required TResult Function(UploadNetworkError value) networkError,
    required TResult Function(UploadStorageError value) storageError,
    required TResult Function(UploadValidationError value) validationError,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UploadInitial value)? initial,
    TResult? Function(UploadValidating value)? validating,
    TResult? Function(UploadReady value)? ready,
    TResult? Function(UploadUploading value)? uploading,
    TResult? Function(UploadPaused value)? paused,
    TResult? Function(UploadCompleted value)? completed,
    TResult? Function(UploadError value)? error,
    TResult? Function(UploadCancelled value)? cancelled,
    TResult? Function(UploadSuccess value)? success,
    TResult? Function(UploadInProgress value)? inProgress,
    TResult? Function(UploadPartialSuccess value)? partialSuccess,
    TResult? Function(UploadNetworkError value)? networkError,
    TResult? Function(UploadStorageError value)? storageError,
    TResult? Function(UploadValidationError value)? validationError,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UploadInitial value)? initial,
    TResult Function(UploadValidating value)? validating,
    TResult Function(UploadReady value)? ready,
    TResult Function(UploadUploading value)? uploading,
    TResult Function(UploadPaused value)? paused,
    TResult Function(UploadCompleted value)? completed,
    TResult Function(UploadError value)? error,
    TResult Function(UploadCancelled value)? cancelled,
    TResult Function(UploadSuccess value)? success,
    TResult Function(UploadInProgress value)? inProgress,
    TResult Function(UploadPartialSuccess value)? partialSuccess,
    TResult Function(UploadNetworkError value)? networkError,
    TResult Function(UploadStorageError value)? storageError,
    TResult Function(UploadValidationError value)? validationError,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class UploadSuccess implements UploadState {
  const factory UploadSuccess({
    required final List<UploadFileModel> uploadedFiles,
    required final int totalFiles,
    final int? totalUploadTime,
  }) = _$UploadSuccessImpl;

  List<UploadFileModel> get uploadedFiles;
  int get totalFiles;
  int? get totalUploadTime;

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadSuccessImplCopyWith<_$UploadSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UploadInProgressImplCopyWith<$Res> {
  factory _$$UploadInProgressImplCopyWith(
    _$UploadInProgressImpl value,
    $Res Function(_$UploadInProgressImpl) then,
  ) = __$$UploadInProgressImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<UploadFileModel> files,
    UploadFileModel currentFile,
    double progress,
    int? uploadSpeed,
  });

  $UploadFileModelCopyWith<$Res> get currentFile;
}

/// @nodoc
class __$$UploadInProgressImplCopyWithImpl<$Res>
    extends _$UploadStateCopyWithImpl<$Res, _$UploadInProgressImpl>
    implements _$$UploadInProgressImplCopyWith<$Res> {
  __$$UploadInProgressImplCopyWithImpl(
    _$UploadInProgressImpl _value,
    $Res Function(_$UploadInProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? files = null,
    Object? currentFile = null,
    Object? progress = null,
    Object? uploadSpeed = freezed,
  }) {
    return _then(
      _$UploadInProgressImpl(
        files: null == files
            ? _value._files
            : files // ignore: cast_nullable_to_non_nullable
                  as List<UploadFileModel>,
        currentFile: null == currentFile
            ? _value.currentFile
            : currentFile // ignore: cast_nullable_to_non_nullable
                  as UploadFileModel,
        progress: null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as double,
        uploadSpeed: freezed == uploadSpeed
            ? _value.uploadSpeed
            : uploadSpeed // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UploadFileModelCopyWith<$Res> get currentFile {
    return $UploadFileModelCopyWith<$Res>(_value.currentFile, (value) {
      return _then(_value.copyWith(currentFile: value));
    });
  }
}

/// @nodoc

class _$UploadInProgressImpl implements UploadInProgress {
  const _$UploadInProgressImpl({
    required final List<UploadFileModel> files,
    required this.currentFile,
    required this.progress,
    this.uploadSpeed,
  }) : _files = files;

  final List<UploadFileModel> _files;
  @override
  List<UploadFileModel> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  @override
  final UploadFileModel currentFile;
  @override
  final double progress;
  @override
  final int? uploadSpeed;

  @override
  String toString() {
    return 'UploadState.inProgress(files: $files, currentFile: $currentFile, progress: $progress, uploadSpeed: $uploadSpeed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadInProgressImpl &&
            const DeepCollectionEquality().equals(other._files, _files) &&
            (identical(other.currentFile, currentFile) ||
                other.currentFile == currentFile) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.uploadSpeed, uploadSpeed) ||
                other.uploadSpeed == uploadSpeed));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_files),
    currentFile,
    progress,
    uploadSpeed,
  );

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadInProgressImplCopyWith<_$UploadInProgressImpl> get copyWith =>
      __$$UploadInProgressImplCopyWithImpl<_$UploadInProgressImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) validating,
    required TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    ready,
    required TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    uploading,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    paused,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    completed,
    required TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )
    error,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )
    cancelled,
    required TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )
    success,
    required TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )
    inProgress,
    required TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )
    partialSuccess,
    required TResult Function(String message, List<UploadFileModel> files)
    networkError,
    required TResult Function(String message, List<UploadFileModel> files)
    storageError,
    required TResult Function(
      String message,
      List<UploadFileModel> invalidFiles,
    )
    validationError,
  }) {
    return inProgress(files, currentFile, progress, uploadSpeed);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? validating,
    TResult? Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult? Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult? Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult? Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult? Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult? Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult? Function(String message, List<UploadFileModel> files)?
    networkError,
    TResult? Function(String message, List<UploadFileModel> files)?
    storageError,
    TResult? Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
  }) {
    return inProgress?.call(files, currentFile, progress, uploadSpeed);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? validating,
    TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult Function(String message, List<UploadFileModel> files)? networkError,
    TResult Function(String message, List<UploadFileModel> files)? storageError,
    TResult Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
    required TResult orElse(),
  }) {
    if (inProgress != null) {
      return inProgress(files, currentFile, progress, uploadSpeed);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UploadInitial value) initial,
    required TResult Function(UploadValidating value) validating,
    required TResult Function(UploadReady value) ready,
    required TResult Function(UploadUploading value) uploading,
    required TResult Function(UploadPaused value) paused,
    required TResult Function(UploadCompleted value) completed,
    required TResult Function(UploadError value) error,
    required TResult Function(UploadCancelled value) cancelled,
    required TResult Function(UploadSuccess value) success,
    required TResult Function(UploadInProgress value) inProgress,
    required TResult Function(UploadPartialSuccess value) partialSuccess,
    required TResult Function(UploadNetworkError value) networkError,
    required TResult Function(UploadStorageError value) storageError,
    required TResult Function(UploadValidationError value) validationError,
  }) {
    return inProgress(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UploadInitial value)? initial,
    TResult? Function(UploadValidating value)? validating,
    TResult? Function(UploadReady value)? ready,
    TResult? Function(UploadUploading value)? uploading,
    TResult? Function(UploadPaused value)? paused,
    TResult? Function(UploadCompleted value)? completed,
    TResult? Function(UploadError value)? error,
    TResult? Function(UploadCancelled value)? cancelled,
    TResult? Function(UploadSuccess value)? success,
    TResult? Function(UploadInProgress value)? inProgress,
    TResult? Function(UploadPartialSuccess value)? partialSuccess,
    TResult? Function(UploadNetworkError value)? networkError,
    TResult? Function(UploadStorageError value)? storageError,
    TResult? Function(UploadValidationError value)? validationError,
  }) {
    return inProgress?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UploadInitial value)? initial,
    TResult Function(UploadValidating value)? validating,
    TResult Function(UploadReady value)? ready,
    TResult Function(UploadUploading value)? uploading,
    TResult Function(UploadPaused value)? paused,
    TResult Function(UploadCompleted value)? completed,
    TResult Function(UploadError value)? error,
    TResult Function(UploadCancelled value)? cancelled,
    TResult Function(UploadSuccess value)? success,
    TResult Function(UploadInProgress value)? inProgress,
    TResult Function(UploadPartialSuccess value)? partialSuccess,
    TResult Function(UploadNetworkError value)? networkError,
    TResult Function(UploadStorageError value)? storageError,
    TResult Function(UploadValidationError value)? validationError,
    required TResult orElse(),
  }) {
    if (inProgress != null) {
      return inProgress(this);
    }
    return orElse();
  }
}

abstract class UploadInProgress implements UploadState {
  const factory UploadInProgress({
    required final List<UploadFileModel> files,
    required final UploadFileModel currentFile,
    required final double progress,
    final int? uploadSpeed,
  }) = _$UploadInProgressImpl;

  List<UploadFileModel> get files;
  UploadFileModel get currentFile;
  double get progress;
  int? get uploadSpeed;

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadInProgressImplCopyWith<_$UploadInProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UploadPartialSuccessImplCopyWith<$Res> {
  factory _$$UploadPartialSuccessImplCopyWith(
    _$UploadPartialSuccessImpl value,
    $Res Function(_$UploadPartialSuccessImpl) then,
  ) = __$$UploadPartialSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<UploadFileModel> successfulFiles,
    List<UploadFileModel> failedFiles,
    int totalFiles,
  });
}

/// @nodoc
class __$$UploadPartialSuccessImplCopyWithImpl<$Res>
    extends _$UploadStateCopyWithImpl<$Res, _$UploadPartialSuccessImpl>
    implements _$$UploadPartialSuccessImplCopyWith<$Res> {
  __$$UploadPartialSuccessImplCopyWithImpl(
    _$UploadPartialSuccessImpl _value,
    $Res Function(_$UploadPartialSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? successfulFiles = null,
    Object? failedFiles = null,
    Object? totalFiles = null,
  }) {
    return _then(
      _$UploadPartialSuccessImpl(
        successfulFiles: null == successfulFiles
            ? _value._successfulFiles
            : successfulFiles // ignore: cast_nullable_to_non_nullable
                  as List<UploadFileModel>,
        failedFiles: null == failedFiles
            ? _value._failedFiles
            : failedFiles // ignore: cast_nullable_to_non_nullable
                  as List<UploadFileModel>,
        totalFiles: null == totalFiles
            ? _value.totalFiles
            : totalFiles // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$UploadPartialSuccessImpl implements UploadPartialSuccess {
  const _$UploadPartialSuccessImpl({
    required final List<UploadFileModel> successfulFiles,
    required final List<UploadFileModel> failedFiles,
    required this.totalFiles,
  }) : _successfulFiles = successfulFiles,
       _failedFiles = failedFiles;

  final List<UploadFileModel> _successfulFiles;
  @override
  List<UploadFileModel> get successfulFiles {
    if (_successfulFiles is EqualUnmodifiableListView) return _successfulFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_successfulFiles);
  }

  final List<UploadFileModel> _failedFiles;
  @override
  List<UploadFileModel> get failedFiles {
    if (_failedFiles is EqualUnmodifiableListView) return _failedFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_failedFiles);
  }

  @override
  final int totalFiles;

  @override
  String toString() {
    return 'UploadState.partialSuccess(successfulFiles: $successfulFiles, failedFiles: $failedFiles, totalFiles: $totalFiles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadPartialSuccessImpl &&
            const DeepCollectionEquality().equals(
              other._successfulFiles,
              _successfulFiles,
            ) &&
            const DeepCollectionEquality().equals(
              other._failedFiles,
              _failedFiles,
            ) &&
            (identical(other.totalFiles, totalFiles) ||
                other.totalFiles == totalFiles));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_successfulFiles),
    const DeepCollectionEquality().hash(_failedFiles),
    totalFiles,
  );

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadPartialSuccessImplCopyWith<_$UploadPartialSuccessImpl>
  get copyWith =>
      __$$UploadPartialSuccessImplCopyWithImpl<_$UploadPartialSuccessImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) validating,
    required TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    ready,
    required TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    uploading,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    paused,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    completed,
    required TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )
    error,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )
    cancelled,
    required TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )
    success,
    required TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )
    inProgress,
    required TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )
    partialSuccess,
    required TResult Function(String message, List<UploadFileModel> files)
    networkError,
    required TResult Function(String message, List<UploadFileModel> files)
    storageError,
    required TResult Function(
      String message,
      List<UploadFileModel> invalidFiles,
    )
    validationError,
  }) {
    return partialSuccess(successfulFiles, failedFiles, totalFiles);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? validating,
    TResult? Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult? Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult? Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult? Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult? Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult? Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult? Function(String message, List<UploadFileModel> files)?
    networkError,
    TResult? Function(String message, List<UploadFileModel> files)?
    storageError,
    TResult? Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
  }) {
    return partialSuccess?.call(successfulFiles, failedFiles, totalFiles);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? validating,
    TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult Function(String message, List<UploadFileModel> files)? networkError,
    TResult Function(String message, List<UploadFileModel> files)? storageError,
    TResult Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
    required TResult orElse(),
  }) {
    if (partialSuccess != null) {
      return partialSuccess(successfulFiles, failedFiles, totalFiles);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UploadInitial value) initial,
    required TResult Function(UploadValidating value) validating,
    required TResult Function(UploadReady value) ready,
    required TResult Function(UploadUploading value) uploading,
    required TResult Function(UploadPaused value) paused,
    required TResult Function(UploadCompleted value) completed,
    required TResult Function(UploadError value) error,
    required TResult Function(UploadCancelled value) cancelled,
    required TResult Function(UploadSuccess value) success,
    required TResult Function(UploadInProgress value) inProgress,
    required TResult Function(UploadPartialSuccess value) partialSuccess,
    required TResult Function(UploadNetworkError value) networkError,
    required TResult Function(UploadStorageError value) storageError,
    required TResult Function(UploadValidationError value) validationError,
  }) {
    return partialSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UploadInitial value)? initial,
    TResult? Function(UploadValidating value)? validating,
    TResult? Function(UploadReady value)? ready,
    TResult? Function(UploadUploading value)? uploading,
    TResult? Function(UploadPaused value)? paused,
    TResult? Function(UploadCompleted value)? completed,
    TResult? Function(UploadError value)? error,
    TResult? Function(UploadCancelled value)? cancelled,
    TResult? Function(UploadSuccess value)? success,
    TResult? Function(UploadInProgress value)? inProgress,
    TResult? Function(UploadPartialSuccess value)? partialSuccess,
    TResult? Function(UploadNetworkError value)? networkError,
    TResult? Function(UploadStorageError value)? storageError,
    TResult? Function(UploadValidationError value)? validationError,
  }) {
    return partialSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UploadInitial value)? initial,
    TResult Function(UploadValidating value)? validating,
    TResult Function(UploadReady value)? ready,
    TResult Function(UploadUploading value)? uploading,
    TResult Function(UploadPaused value)? paused,
    TResult Function(UploadCompleted value)? completed,
    TResult Function(UploadError value)? error,
    TResult Function(UploadCancelled value)? cancelled,
    TResult Function(UploadSuccess value)? success,
    TResult Function(UploadInProgress value)? inProgress,
    TResult Function(UploadPartialSuccess value)? partialSuccess,
    TResult Function(UploadNetworkError value)? networkError,
    TResult Function(UploadStorageError value)? storageError,
    TResult Function(UploadValidationError value)? validationError,
    required TResult orElse(),
  }) {
    if (partialSuccess != null) {
      return partialSuccess(this);
    }
    return orElse();
  }
}

abstract class UploadPartialSuccess implements UploadState {
  const factory UploadPartialSuccess({
    required final List<UploadFileModel> successfulFiles,
    required final List<UploadFileModel> failedFiles,
    required final int totalFiles,
  }) = _$UploadPartialSuccessImpl;

  List<UploadFileModel> get successfulFiles;
  List<UploadFileModel> get failedFiles;
  int get totalFiles;

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadPartialSuccessImplCopyWith<_$UploadPartialSuccessImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UploadNetworkErrorImplCopyWith<$Res> {
  factory _$$UploadNetworkErrorImplCopyWith(
    _$UploadNetworkErrorImpl value,
    $Res Function(_$UploadNetworkErrorImpl) then,
  ) = __$$UploadNetworkErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, List<UploadFileModel> files});
}

/// @nodoc
class __$$UploadNetworkErrorImplCopyWithImpl<$Res>
    extends _$UploadStateCopyWithImpl<$Res, _$UploadNetworkErrorImpl>
    implements _$$UploadNetworkErrorImplCopyWith<$Res> {
  __$$UploadNetworkErrorImplCopyWithImpl(
    _$UploadNetworkErrorImpl _value,
    $Res Function(_$UploadNetworkErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? files = null}) {
    return _then(
      _$UploadNetworkErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        files: null == files
            ? _value._files
            : files // ignore: cast_nullable_to_non_nullable
                  as List<UploadFileModel>,
      ),
    );
  }
}

/// @nodoc

class _$UploadNetworkErrorImpl implements UploadNetworkError {
  const _$UploadNetworkErrorImpl({
    required this.message,
    required final List<UploadFileModel> files,
  }) : _files = files;

  @override
  final String message;
  final List<UploadFileModel> _files;
  @override
  List<UploadFileModel> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  @override
  String toString() {
    return 'UploadState.networkError(message: $message, files: $files)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadNetworkErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._files, _files));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(_files),
  );

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadNetworkErrorImplCopyWith<_$UploadNetworkErrorImpl> get copyWith =>
      __$$UploadNetworkErrorImplCopyWithImpl<_$UploadNetworkErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) validating,
    required TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    ready,
    required TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    uploading,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    paused,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    completed,
    required TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )
    error,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )
    cancelled,
    required TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )
    success,
    required TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )
    inProgress,
    required TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )
    partialSuccess,
    required TResult Function(String message, List<UploadFileModel> files)
    networkError,
    required TResult Function(String message, List<UploadFileModel> files)
    storageError,
    required TResult Function(
      String message,
      List<UploadFileModel> invalidFiles,
    )
    validationError,
  }) {
    return networkError(message, files);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? validating,
    TResult? Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult? Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult? Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult? Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult? Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult? Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult? Function(String message, List<UploadFileModel> files)?
    networkError,
    TResult? Function(String message, List<UploadFileModel> files)?
    storageError,
    TResult? Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
  }) {
    return networkError?.call(message, files);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? validating,
    TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult Function(String message, List<UploadFileModel> files)? networkError,
    TResult Function(String message, List<UploadFileModel> files)? storageError,
    TResult Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
    required TResult orElse(),
  }) {
    if (networkError != null) {
      return networkError(message, files);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UploadInitial value) initial,
    required TResult Function(UploadValidating value) validating,
    required TResult Function(UploadReady value) ready,
    required TResult Function(UploadUploading value) uploading,
    required TResult Function(UploadPaused value) paused,
    required TResult Function(UploadCompleted value) completed,
    required TResult Function(UploadError value) error,
    required TResult Function(UploadCancelled value) cancelled,
    required TResult Function(UploadSuccess value) success,
    required TResult Function(UploadInProgress value) inProgress,
    required TResult Function(UploadPartialSuccess value) partialSuccess,
    required TResult Function(UploadNetworkError value) networkError,
    required TResult Function(UploadStorageError value) storageError,
    required TResult Function(UploadValidationError value) validationError,
  }) {
    return networkError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UploadInitial value)? initial,
    TResult? Function(UploadValidating value)? validating,
    TResult? Function(UploadReady value)? ready,
    TResult? Function(UploadUploading value)? uploading,
    TResult? Function(UploadPaused value)? paused,
    TResult? Function(UploadCompleted value)? completed,
    TResult? Function(UploadError value)? error,
    TResult? Function(UploadCancelled value)? cancelled,
    TResult? Function(UploadSuccess value)? success,
    TResult? Function(UploadInProgress value)? inProgress,
    TResult? Function(UploadPartialSuccess value)? partialSuccess,
    TResult? Function(UploadNetworkError value)? networkError,
    TResult? Function(UploadStorageError value)? storageError,
    TResult? Function(UploadValidationError value)? validationError,
  }) {
    return networkError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UploadInitial value)? initial,
    TResult Function(UploadValidating value)? validating,
    TResult Function(UploadReady value)? ready,
    TResult Function(UploadUploading value)? uploading,
    TResult Function(UploadPaused value)? paused,
    TResult Function(UploadCompleted value)? completed,
    TResult Function(UploadError value)? error,
    TResult Function(UploadCancelled value)? cancelled,
    TResult Function(UploadSuccess value)? success,
    TResult Function(UploadInProgress value)? inProgress,
    TResult Function(UploadPartialSuccess value)? partialSuccess,
    TResult Function(UploadNetworkError value)? networkError,
    TResult Function(UploadStorageError value)? storageError,
    TResult Function(UploadValidationError value)? validationError,
    required TResult orElse(),
  }) {
    if (networkError != null) {
      return networkError(this);
    }
    return orElse();
  }
}

abstract class UploadNetworkError implements UploadState {
  const factory UploadNetworkError({
    required final String message,
    required final List<UploadFileModel> files,
  }) = _$UploadNetworkErrorImpl;

  String get message;
  List<UploadFileModel> get files;

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadNetworkErrorImplCopyWith<_$UploadNetworkErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UploadStorageErrorImplCopyWith<$Res> {
  factory _$$UploadStorageErrorImplCopyWith(
    _$UploadStorageErrorImpl value,
    $Res Function(_$UploadStorageErrorImpl) then,
  ) = __$$UploadStorageErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, List<UploadFileModel> files});
}

/// @nodoc
class __$$UploadStorageErrorImplCopyWithImpl<$Res>
    extends _$UploadStateCopyWithImpl<$Res, _$UploadStorageErrorImpl>
    implements _$$UploadStorageErrorImplCopyWith<$Res> {
  __$$UploadStorageErrorImplCopyWithImpl(
    _$UploadStorageErrorImpl _value,
    $Res Function(_$UploadStorageErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? files = null}) {
    return _then(
      _$UploadStorageErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        files: null == files
            ? _value._files
            : files // ignore: cast_nullable_to_non_nullable
                  as List<UploadFileModel>,
      ),
    );
  }
}

/// @nodoc

class _$UploadStorageErrorImpl implements UploadStorageError {
  const _$UploadStorageErrorImpl({
    required this.message,
    required final List<UploadFileModel> files,
  }) : _files = files;

  @override
  final String message;
  final List<UploadFileModel> _files;
  @override
  List<UploadFileModel> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  @override
  String toString() {
    return 'UploadState.storageError(message: $message, files: $files)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadStorageErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._files, _files));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(_files),
  );

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadStorageErrorImplCopyWith<_$UploadStorageErrorImpl> get copyWith =>
      __$$UploadStorageErrorImplCopyWithImpl<_$UploadStorageErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) validating,
    required TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    ready,
    required TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    uploading,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    paused,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    completed,
    required TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )
    error,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )
    cancelled,
    required TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )
    success,
    required TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )
    inProgress,
    required TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )
    partialSuccess,
    required TResult Function(String message, List<UploadFileModel> files)
    networkError,
    required TResult Function(String message, List<UploadFileModel> files)
    storageError,
    required TResult Function(
      String message,
      List<UploadFileModel> invalidFiles,
    )
    validationError,
  }) {
    return storageError(message, files);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? validating,
    TResult? Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult? Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult? Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult? Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult? Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult? Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult? Function(String message, List<UploadFileModel> files)?
    networkError,
    TResult? Function(String message, List<UploadFileModel> files)?
    storageError,
    TResult? Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
  }) {
    return storageError?.call(message, files);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? validating,
    TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult Function(String message, List<UploadFileModel> files)? networkError,
    TResult Function(String message, List<UploadFileModel> files)? storageError,
    TResult Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
    required TResult orElse(),
  }) {
    if (storageError != null) {
      return storageError(message, files);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UploadInitial value) initial,
    required TResult Function(UploadValidating value) validating,
    required TResult Function(UploadReady value) ready,
    required TResult Function(UploadUploading value) uploading,
    required TResult Function(UploadPaused value) paused,
    required TResult Function(UploadCompleted value) completed,
    required TResult Function(UploadError value) error,
    required TResult Function(UploadCancelled value) cancelled,
    required TResult Function(UploadSuccess value) success,
    required TResult Function(UploadInProgress value) inProgress,
    required TResult Function(UploadPartialSuccess value) partialSuccess,
    required TResult Function(UploadNetworkError value) networkError,
    required TResult Function(UploadStorageError value) storageError,
    required TResult Function(UploadValidationError value) validationError,
  }) {
    return storageError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UploadInitial value)? initial,
    TResult? Function(UploadValidating value)? validating,
    TResult? Function(UploadReady value)? ready,
    TResult? Function(UploadUploading value)? uploading,
    TResult? Function(UploadPaused value)? paused,
    TResult? Function(UploadCompleted value)? completed,
    TResult? Function(UploadError value)? error,
    TResult? Function(UploadCancelled value)? cancelled,
    TResult? Function(UploadSuccess value)? success,
    TResult? Function(UploadInProgress value)? inProgress,
    TResult? Function(UploadPartialSuccess value)? partialSuccess,
    TResult? Function(UploadNetworkError value)? networkError,
    TResult? Function(UploadStorageError value)? storageError,
    TResult? Function(UploadValidationError value)? validationError,
  }) {
    return storageError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UploadInitial value)? initial,
    TResult Function(UploadValidating value)? validating,
    TResult Function(UploadReady value)? ready,
    TResult Function(UploadUploading value)? uploading,
    TResult Function(UploadPaused value)? paused,
    TResult Function(UploadCompleted value)? completed,
    TResult Function(UploadError value)? error,
    TResult Function(UploadCancelled value)? cancelled,
    TResult Function(UploadSuccess value)? success,
    TResult Function(UploadInProgress value)? inProgress,
    TResult Function(UploadPartialSuccess value)? partialSuccess,
    TResult Function(UploadNetworkError value)? networkError,
    TResult Function(UploadStorageError value)? storageError,
    TResult Function(UploadValidationError value)? validationError,
    required TResult orElse(),
  }) {
    if (storageError != null) {
      return storageError(this);
    }
    return orElse();
  }
}

abstract class UploadStorageError implements UploadState {
  const factory UploadStorageError({
    required final String message,
    required final List<UploadFileModel> files,
  }) = _$UploadStorageErrorImpl;

  String get message;
  List<UploadFileModel> get files;

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadStorageErrorImplCopyWith<_$UploadStorageErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UploadValidationErrorImplCopyWith<$Res> {
  factory _$$UploadValidationErrorImplCopyWith(
    _$UploadValidationErrorImpl value,
    $Res Function(_$UploadValidationErrorImpl) then,
  ) = __$$UploadValidationErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, List<UploadFileModel> invalidFiles});
}

/// @nodoc
class __$$UploadValidationErrorImplCopyWithImpl<$Res>
    extends _$UploadStateCopyWithImpl<$Res, _$UploadValidationErrorImpl>
    implements _$$UploadValidationErrorImplCopyWith<$Res> {
  __$$UploadValidationErrorImplCopyWithImpl(
    _$UploadValidationErrorImpl _value,
    $Res Function(_$UploadValidationErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? invalidFiles = null}) {
    return _then(
      _$UploadValidationErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        invalidFiles: null == invalidFiles
            ? _value._invalidFiles
            : invalidFiles // ignore: cast_nullable_to_non_nullable
                  as List<UploadFileModel>,
      ),
    );
  }
}

/// @nodoc

class _$UploadValidationErrorImpl implements UploadValidationError {
  const _$UploadValidationErrorImpl({
    required this.message,
    required final List<UploadFileModel> invalidFiles,
  }) : _invalidFiles = invalidFiles;

  @override
  final String message;
  final List<UploadFileModel> _invalidFiles;
  @override
  List<UploadFileModel> get invalidFiles {
    if (_invalidFiles is EqualUnmodifiableListView) return _invalidFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_invalidFiles);
  }

  @override
  String toString() {
    return 'UploadState.validationError(message: $message, invalidFiles: $invalidFiles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadValidationErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(
              other._invalidFiles,
              _invalidFiles,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(_invalidFiles),
  );

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadValidationErrorImplCopyWith<_$UploadValidationErrorImpl>
  get copyWith =>
      __$$UploadValidationErrorImplCopyWithImpl<_$UploadValidationErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? message) validating,
    required TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    ready,
    required TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    uploading,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    paused,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )
    completed,
    required TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )
    error,
    required TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )
    cancelled,
    required TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )
    success,
    required TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )
    inProgress,
    required TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )
    partialSuccess,
    required TResult Function(String message, List<UploadFileModel> files)
    networkError,
    required TResult Function(String message, List<UploadFileModel> files)
    storageError,
    required TResult Function(
      String message,
      List<UploadFileModel> invalidFiles,
    )
    validationError,
  }) {
    return validationError(message, invalidFiles);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? message)? validating,
    TResult? Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult? Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult? Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult? Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult? Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult? Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult? Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult? Function(String message, List<UploadFileModel> files)?
    networkError,
    TResult? Function(String message, List<UploadFileModel> files)?
    storageError,
    TResult? Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
  }) {
    return validationError?.call(message, invalidFiles);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? message)? validating,
    TResult Function(
      List<UploadFileModel> files,
      int totalFiles,
      int totalSize,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    ready,
    TResult Function(
      List<UploadFileModel> files,
      int activeUploads,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int? uploadSpeed,
      int? estimatedTimeRemaining,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    uploading,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      double overallProgress,
      int pausedFiles,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    paused,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int failedFiles,
      int totalFiles,
      int? totalUploadTime,
      String? categoryId,
      Map<String, String>? customMetadata,
    )?
    completed,
    TResult Function(
      String message,
      List<UploadFileModel>? files,
      bool canRetry,
      UploadState? previousState,
    )?
    error,
    TResult Function(
      List<UploadFileModel> files,
      int completedFiles,
      int cancelledFiles,
    )?
    cancelled,
    TResult Function(
      List<UploadFileModel> uploadedFiles,
      int totalFiles,
      int? totalUploadTime,
    )?
    success,
    TResult Function(
      List<UploadFileModel> files,
      UploadFileModel currentFile,
      double progress,
      int? uploadSpeed,
    )?
    inProgress,
    TResult Function(
      List<UploadFileModel> successfulFiles,
      List<UploadFileModel> failedFiles,
      int totalFiles,
    )?
    partialSuccess,
    TResult Function(String message, List<UploadFileModel> files)? networkError,
    TResult Function(String message, List<UploadFileModel> files)? storageError,
    TResult Function(String message, List<UploadFileModel> invalidFiles)?
    validationError,
    required TResult orElse(),
  }) {
    if (validationError != null) {
      return validationError(message, invalidFiles);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UploadInitial value) initial,
    required TResult Function(UploadValidating value) validating,
    required TResult Function(UploadReady value) ready,
    required TResult Function(UploadUploading value) uploading,
    required TResult Function(UploadPaused value) paused,
    required TResult Function(UploadCompleted value) completed,
    required TResult Function(UploadError value) error,
    required TResult Function(UploadCancelled value) cancelled,
    required TResult Function(UploadSuccess value) success,
    required TResult Function(UploadInProgress value) inProgress,
    required TResult Function(UploadPartialSuccess value) partialSuccess,
    required TResult Function(UploadNetworkError value) networkError,
    required TResult Function(UploadStorageError value) storageError,
    required TResult Function(UploadValidationError value) validationError,
  }) {
    return validationError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UploadInitial value)? initial,
    TResult? Function(UploadValidating value)? validating,
    TResult? Function(UploadReady value)? ready,
    TResult? Function(UploadUploading value)? uploading,
    TResult? Function(UploadPaused value)? paused,
    TResult? Function(UploadCompleted value)? completed,
    TResult? Function(UploadError value)? error,
    TResult? Function(UploadCancelled value)? cancelled,
    TResult? Function(UploadSuccess value)? success,
    TResult? Function(UploadInProgress value)? inProgress,
    TResult? Function(UploadPartialSuccess value)? partialSuccess,
    TResult? Function(UploadNetworkError value)? networkError,
    TResult? Function(UploadStorageError value)? storageError,
    TResult? Function(UploadValidationError value)? validationError,
  }) {
    return validationError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UploadInitial value)? initial,
    TResult Function(UploadValidating value)? validating,
    TResult Function(UploadReady value)? ready,
    TResult Function(UploadUploading value)? uploading,
    TResult Function(UploadPaused value)? paused,
    TResult Function(UploadCompleted value)? completed,
    TResult Function(UploadError value)? error,
    TResult Function(UploadCancelled value)? cancelled,
    TResult Function(UploadSuccess value)? success,
    TResult Function(UploadInProgress value)? inProgress,
    TResult Function(UploadPartialSuccess value)? partialSuccess,
    TResult Function(UploadNetworkError value)? networkError,
    TResult Function(UploadStorageError value)? storageError,
    TResult Function(UploadValidationError value)? validationError,
    required TResult orElse(),
  }) {
    if (validationError != null) {
      return validationError(this);
    }
    return orElse();
  }
}

abstract class UploadValidationError implements UploadState {
  const factory UploadValidationError({
    required final String message,
    required final List<UploadFileModel> invalidFiles,
  }) = _$UploadValidationErrorImpl;

  String get message;
  List<UploadFileModel> get invalidFiles;

  /// Create a copy of UploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadValidationErrorImplCopyWith<_$UploadValidationErrorImpl>
  get copyWith => throw _privateConstructorUsedError;
}
