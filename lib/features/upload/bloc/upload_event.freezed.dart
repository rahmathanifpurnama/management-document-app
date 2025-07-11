// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UploadEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )
    addFiles,
    required TResult Function(List<UploadFileModel> files) startUpload,
    required TResult Function(String? fileId) pauseUpload,
    required TResult Function(String? fileId) resumeUpload,
    required TResult Function(String? fileId) cancelUpload,
    required TResult Function(List<UploadFileModel> failedFiles) retryUpload,
    required TResult Function(String fileId) removeFile,
    required TResult Function() clearQueue,
    required TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )
    updateProgress,
    required TResult Function(
      String fileId,
      String downloadUrl,
      String? documentId,
    )
    fileCompleted,
    required TResult Function(String fileId, String error) fileFailed,
    required TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )
    updateSettings,
    required TResult Function(List<XFile> files) validateFiles,
    required TResult Function() resetState,
    required TResult Function(String categoryId) setCategory,
    required TResult Function(Map<String, String> metadata) setMetadata,
    required TResult Function() processQueue,
    required TResult Function() uploadCompleted,
    required TResult Function(String error) uploadError,
    required TResult Function(double progress) overallProgressUpdated,
    required TResult Function(String fileId, double progress)
    fileProgressUpdated,
    required TResult Function(String fileId, UploadStatus status)
    fileStatusUpdated,
    required TResult Function(List<UploadFileModel> files)
    startUploadWithProgress,
    required TResult Function() clearUploadState,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult? Function(List<UploadFileModel> files)? startUpload,
    TResult? Function(String? fileId)? pauseUpload,
    TResult? Function(String? fileId)? resumeUpload,
    TResult? Function(String? fileId)? cancelUpload,
    TResult? Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult? Function(String fileId)? removeFile,
    TResult? Function()? clearQueue,
    TResult? Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult? Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult? Function(String fileId, String error)? fileFailed,
    TResult? Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult? Function(List<XFile> files)? validateFiles,
    TResult? Function()? resetState,
    TResult? Function(String categoryId)? setCategory,
    TResult? Function(Map<String, String> metadata)? setMetadata,
    TResult? Function()? processQueue,
    TResult? Function()? uploadCompleted,
    TResult? Function(String error)? uploadError,
    TResult? Function(double progress)? overallProgressUpdated,
    TResult? Function(String fileId, double progress)? fileProgressUpdated,
    TResult? Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult? Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult? Function()? clearUploadState,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult Function(List<UploadFileModel> files)? startUpload,
    TResult Function(String? fileId)? pauseUpload,
    TResult Function(String? fileId)? resumeUpload,
    TResult Function(String? fileId)? cancelUpload,
    TResult Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult Function(String fileId)? removeFile,
    TResult Function()? clearQueue,
    TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult Function(String fileId, String error)? fileFailed,
    TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult Function(List<XFile> files)? validateFiles,
    TResult Function()? resetState,
    TResult Function(String categoryId)? setCategory,
    TResult Function(Map<String, String> metadata)? setMetadata,
    TResult Function()? processQueue,
    TResult Function()? uploadCompleted,
    TResult Function(String error)? uploadError,
    TResult Function(double progress)? overallProgressUpdated,
    TResult Function(String fileId, double progress)? fileProgressUpdated,
    TResult Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult Function()? clearUploadState,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddFiles value) addFiles,
    required TResult Function(StartUpload value) startUpload,
    required TResult Function(PauseUpload value) pauseUpload,
    required TResult Function(ResumeUpload value) resumeUpload,
    required TResult Function(CancelUpload value) cancelUpload,
    required TResult Function(RetryUpload value) retryUpload,
    required TResult Function(RemoveFile value) removeFile,
    required TResult Function(ClearQueue value) clearQueue,
    required TResult Function(UpdateProgress value) updateProgress,
    required TResult Function(FileCompleted value) fileCompleted,
    required TResult Function(FileFailed value) fileFailed,
    required TResult Function(UpdateSettings value) updateSettings,
    required TResult Function(ValidateFiles value) validateFiles,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SetCategory value) setCategory,
    required TResult Function(SetMetadata value) setMetadata,
    required TResult Function(ProcessQueue value) processQueue,
    required TResult Function(UploadCompleted value) uploadCompleted,
    required TResult Function(UploadError value) uploadError,
    required TResult Function(OverallProgressUpdated value)
    overallProgressUpdated,
    required TResult Function(FileProgressUpdated value) fileProgressUpdated,
    required TResult Function(FileStatusUpdated value) fileStatusUpdated,
    required TResult Function(StartUploadWithProgress value)
    startUploadWithProgress,
    required TResult Function(ClearUploadState value) clearUploadState,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddFiles value)? addFiles,
    TResult? Function(StartUpload value)? startUpload,
    TResult? Function(PauseUpload value)? pauseUpload,
    TResult? Function(ResumeUpload value)? resumeUpload,
    TResult? Function(CancelUpload value)? cancelUpload,
    TResult? Function(RetryUpload value)? retryUpload,
    TResult? Function(RemoveFile value)? removeFile,
    TResult? Function(ClearQueue value)? clearQueue,
    TResult? Function(UpdateProgress value)? updateProgress,
    TResult? Function(FileCompleted value)? fileCompleted,
    TResult? Function(FileFailed value)? fileFailed,
    TResult? Function(UpdateSettings value)? updateSettings,
    TResult? Function(ValidateFiles value)? validateFiles,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SetCategory value)? setCategory,
    TResult? Function(SetMetadata value)? setMetadata,
    TResult? Function(ProcessQueue value)? processQueue,
    TResult? Function(UploadCompleted value)? uploadCompleted,
    TResult? Function(UploadError value)? uploadError,
    TResult? Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult? Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult? Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult? Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult? Function(ClearUploadState value)? clearUploadState,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddFiles value)? addFiles,
    TResult Function(StartUpload value)? startUpload,
    TResult Function(PauseUpload value)? pauseUpload,
    TResult Function(ResumeUpload value)? resumeUpload,
    TResult Function(CancelUpload value)? cancelUpload,
    TResult Function(RetryUpload value)? retryUpload,
    TResult Function(RemoveFile value)? removeFile,
    TResult Function(ClearQueue value)? clearQueue,
    TResult Function(UpdateProgress value)? updateProgress,
    TResult Function(FileCompleted value)? fileCompleted,
    TResult Function(FileFailed value)? fileFailed,
    TResult Function(UpdateSettings value)? updateSettings,
    TResult Function(ValidateFiles value)? validateFiles,
    TResult Function(ResetState value)? resetState,
    TResult Function(SetCategory value)? setCategory,
    TResult Function(SetMetadata value)? setMetadata,
    TResult Function(ProcessQueue value)? processQueue,
    TResult Function(UploadCompleted value)? uploadCompleted,
    TResult Function(UploadError value)? uploadError,
    TResult Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult Function(ClearUploadState value)? clearUploadState,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UploadEventCopyWith<$Res> {
  factory $UploadEventCopyWith(
    UploadEvent value,
    $Res Function(UploadEvent) then,
  ) = _$UploadEventCopyWithImpl<$Res, UploadEvent>;
}

/// @nodoc
class _$UploadEventCopyWithImpl<$Res, $Val extends UploadEvent>
    implements $UploadEventCopyWith<$Res> {
  _$UploadEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AddFilesImplCopyWith<$Res> {
  factory _$$AddFilesImplCopyWith(
    _$AddFilesImpl value,
    $Res Function(_$AddFilesImpl) then,
  ) = __$$AddFilesImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<XFile> files,
    String? categoryId,
    Map<String, String>? customMetadata,
    bool checkDuplicates,
  });
}

/// @nodoc
class __$$AddFilesImplCopyWithImpl<$Res>
    extends _$UploadEventCopyWithImpl<$Res, _$AddFilesImpl>
    implements _$$AddFilesImplCopyWith<$Res> {
  __$$AddFilesImplCopyWithImpl(
    _$AddFilesImpl _value,
    $Res Function(_$AddFilesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? files = null,
    Object? categoryId = freezed,
    Object? customMetadata = freezed,
    Object? checkDuplicates = null,
  }) {
    return _then(
      _$AddFilesImpl(
        files: null == files
            ? _value._files
            : files // ignore: cast_nullable_to_non_nullable
                  as List<XFile>,
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        customMetadata: freezed == customMetadata
            ? _value._customMetadata
            : customMetadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
        checkDuplicates: null == checkDuplicates
            ? _value.checkDuplicates
            : checkDuplicates // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$AddFilesImpl implements AddFiles {
  const _$AddFilesImpl({
    required final List<XFile> files,
    this.categoryId,
    final Map<String, String>? customMetadata,
    this.checkDuplicates = true,
  }) : _files = files,
       _customMetadata = customMetadata;

  final List<XFile> _files;
  @override
  List<XFile> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

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
  @JsonKey()
  final bool checkDuplicates;

  @override
  String toString() {
    return 'UploadEvent.addFiles(files: $files, categoryId: $categoryId, customMetadata: $customMetadata, checkDuplicates: $checkDuplicates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddFilesImpl &&
            const DeepCollectionEquality().equals(other._files, _files) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            const DeepCollectionEquality().equals(
              other._customMetadata,
              _customMetadata,
            ) &&
            (identical(other.checkDuplicates, checkDuplicates) ||
                other.checkDuplicates == checkDuplicates));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_files),
    categoryId,
    const DeepCollectionEquality().hash(_customMetadata),
    checkDuplicates,
  );

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddFilesImplCopyWith<_$AddFilesImpl> get copyWith =>
      __$$AddFilesImplCopyWithImpl<_$AddFilesImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )
    addFiles,
    required TResult Function(List<UploadFileModel> files) startUpload,
    required TResult Function(String? fileId) pauseUpload,
    required TResult Function(String? fileId) resumeUpload,
    required TResult Function(String? fileId) cancelUpload,
    required TResult Function(List<UploadFileModel> failedFiles) retryUpload,
    required TResult Function(String fileId) removeFile,
    required TResult Function() clearQueue,
    required TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )
    updateProgress,
    required TResult Function(
      String fileId,
      String downloadUrl,
      String? documentId,
    )
    fileCompleted,
    required TResult Function(String fileId, String error) fileFailed,
    required TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )
    updateSettings,
    required TResult Function(List<XFile> files) validateFiles,
    required TResult Function() resetState,
    required TResult Function(String categoryId) setCategory,
    required TResult Function(Map<String, String> metadata) setMetadata,
    required TResult Function() processQueue,
    required TResult Function() uploadCompleted,
    required TResult Function(String error) uploadError,
    required TResult Function(double progress) overallProgressUpdated,
    required TResult Function(String fileId, double progress)
    fileProgressUpdated,
    required TResult Function(String fileId, UploadStatus status)
    fileStatusUpdated,
    required TResult Function(List<UploadFileModel> files)
    startUploadWithProgress,
    required TResult Function() clearUploadState,
  }) {
    return addFiles(files, categoryId, customMetadata, checkDuplicates);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult? Function(List<UploadFileModel> files)? startUpload,
    TResult? Function(String? fileId)? pauseUpload,
    TResult? Function(String? fileId)? resumeUpload,
    TResult? Function(String? fileId)? cancelUpload,
    TResult? Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult? Function(String fileId)? removeFile,
    TResult? Function()? clearQueue,
    TResult? Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult? Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult? Function(String fileId, String error)? fileFailed,
    TResult? Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult? Function(List<XFile> files)? validateFiles,
    TResult? Function()? resetState,
    TResult? Function(String categoryId)? setCategory,
    TResult? Function(Map<String, String> metadata)? setMetadata,
    TResult? Function()? processQueue,
    TResult? Function()? uploadCompleted,
    TResult? Function(String error)? uploadError,
    TResult? Function(double progress)? overallProgressUpdated,
    TResult? Function(String fileId, double progress)? fileProgressUpdated,
    TResult? Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult? Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult? Function()? clearUploadState,
  }) {
    return addFiles?.call(files, categoryId, customMetadata, checkDuplicates);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult Function(List<UploadFileModel> files)? startUpload,
    TResult Function(String? fileId)? pauseUpload,
    TResult Function(String? fileId)? resumeUpload,
    TResult Function(String? fileId)? cancelUpload,
    TResult Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult Function(String fileId)? removeFile,
    TResult Function()? clearQueue,
    TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult Function(String fileId, String error)? fileFailed,
    TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult Function(List<XFile> files)? validateFiles,
    TResult Function()? resetState,
    TResult Function(String categoryId)? setCategory,
    TResult Function(Map<String, String> metadata)? setMetadata,
    TResult Function()? processQueue,
    TResult Function()? uploadCompleted,
    TResult Function(String error)? uploadError,
    TResult Function(double progress)? overallProgressUpdated,
    TResult Function(String fileId, double progress)? fileProgressUpdated,
    TResult Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult Function()? clearUploadState,
    required TResult orElse(),
  }) {
    if (addFiles != null) {
      return addFiles(files, categoryId, customMetadata, checkDuplicates);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddFiles value) addFiles,
    required TResult Function(StartUpload value) startUpload,
    required TResult Function(PauseUpload value) pauseUpload,
    required TResult Function(ResumeUpload value) resumeUpload,
    required TResult Function(CancelUpload value) cancelUpload,
    required TResult Function(RetryUpload value) retryUpload,
    required TResult Function(RemoveFile value) removeFile,
    required TResult Function(ClearQueue value) clearQueue,
    required TResult Function(UpdateProgress value) updateProgress,
    required TResult Function(FileCompleted value) fileCompleted,
    required TResult Function(FileFailed value) fileFailed,
    required TResult Function(UpdateSettings value) updateSettings,
    required TResult Function(ValidateFiles value) validateFiles,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SetCategory value) setCategory,
    required TResult Function(SetMetadata value) setMetadata,
    required TResult Function(ProcessQueue value) processQueue,
    required TResult Function(UploadCompleted value) uploadCompleted,
    required TResult Function(UploadError value) uploadError,
    required TResult Function(OverallProgressUpdated value)
    overallProgressUpdated,
    required TResult Function(FileProgressUpdated value) fileProgressUpdated,
    required TResult Function(FileStatusUpdated value) fileStatusUpdated,
    required TResult Function(StartUploadWithProgress value)
    startUploadWithProgress,
    required TResult Function(ClearUploadState value) clearUploadState,
  }) {
    return addFiles(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddFiles value)? addFiles,
    TResult? Function(StartUpload value)? startUpload,
    TResult? Function(PauseUpload value)? pauseUpload,
    TResult? Function(ResumeUpload value)? resumeUpload,
    TResult? Function(CancelUpload value)? cancelUpload,
    TResult? Function(RetryUpload value)? retryUpload,
    TResult? Function(RemoveFile value)? removeFile,
    TResult? Function(ClearQueue value)? clearQueue,
    TResult? Function(UpdateProgress value)? updateProgress,
    TResult? Function(FileCompleted value)? fileCompleted,
    TResult? Function(FileFailed value)? fileFailed,
    TResult? Function(UpdateSettings value)? updateSettings,
    TResult? Function(ValidateFiles value)? validateFiles,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SetCategory value)? setCategory,
    TResult? Function(SetMetadata value)? setMetadata,
    TResult? Function(ProcessQueue value)? processQueue,
    TResult? Function(UploadCompleted value)? uploadCompleted,
    TResult? Function(UploadError value)? uploadError,
    TResult? Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult? Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult? Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult? Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult? Function(ClearUploadState value)? clearUploadState,
  }) {
    return addFiles?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddFiles value)? addFiles,
    TResult Function(StartUpload value)? startUpload,
    TResult Function(PauseUpload value)? pauseUpload,
    TResult Function(ResumeUpload value)? resumeUpload,
    TResult Function(CancelUpload value)? cancelUpload,
    TResult Function(RetryUpload value)? retryUpload,
    TResult Function(RemoveFile value)? removeFile,
    TResult Function(ClearQueue value)? clearQueue,
    TResult Function(UpdateProgress value)? updateProgress,
    TResult Function(FileCompleted value)? fileCompleted,
    TResult Function(FileFailed value)? fileFailed,
    TResult Function(UpdateSettings value)? updateSettings,
    TResult Function(ValidateFiles value)? validateFiles,
    TResult Function(ResetState value)? resetState,
    TResult Function(SetCategory value)? setCategory,
    TResult Function(SetMetadata value)? setMetadata,
    TResult Function(ProcessQueue value)? processQueue,
    TResult Function(UploadCompleted value)? uploadCompleted,
    TResult Function(UploadError value)? uploadError,
    TResult Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult Function(ClearUploadState value)? clearUploadState,
    required TResult orElse(),
  }) {
    if (addFiles != null) {
      return addFiles(this);
    }
    return orElse();
  }
}

abstract class AddFiles implements UploadEvent {
  const factory AddFiles({
    required final List<XFile> files,
    final String? categoryId,
    final Map<String, String>? customMetadata,
    final bool checkDuplicates,
  }) = _$AddFilesImpl;

  List<XFile> get files;
  String? get categoryId;
  Map<String, String>? get customMetadata;
  bool get checkDuplicates;

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddFilesImplCopyWith<_$AddFilesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StartUploadImplCopyWith<$Res> {
  factory _$$StartUploadImplCopyWith(
    _$StartUploadImpl value,
    $Res Function(_$StartUploadImpl) then,
  ) = __$$StartUploadImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<UploadFileModel> files});
}

/// @nodoc
class __$$StartUploadImplCopyWithImpl<$Res>
    extends _$UploadEventCopyWithImpl<$Res, _$StartUploadImpl>
    implements _$$StartUploadImplCopyWith<$Res> {
  __$$StartUploadImplCopyWithImpl(
    _$StartUploadImpl _value,
    $Res Function(_$StartUploadImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? files = null}) {
    return _then(
      _$StartUploadImpl(
        files: null == files
            ? _value._files
            : files // ignore: cast_nullable_to_non_nullable
                  as List<UploadFileModel>,
      ),
    );
  }
}

/// @nodoc

class _$StartUploadImpl implements StartUpload {
  const _$StartUploadImpl({required final List<UploadFileModel> files})
    : _files = files;

  final List<UploadFileModel> _files;
  @override
  List<UploadFileModel> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  @override
  String toString() {
    return 'UploadEvent.startUpload(files: $files)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StartUploadImpl &&
            const DeepCollectionEquality().equals(other._files, _files));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_files));

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StartUploadImplCopyWith<_$StartUploadImpl> get copyWith =>
      __$$StartUploadImplCopyWithImpl<_$StartUploadImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )
    addFiles,
    required TResult Function(List<UploadFileModel> files) startUpload,
    required TResult Function(String? fileId) pauseUpload,
    required TResult Function(String? fileId) resumeUpload,
    required TResult Function(String? fileId) cancelUpload,
    required TResult Function(List<UploadFileModel> failedFiles) retryUpload,
    required TResult Function(String fileId) removeFile,
    required TResult Function() clearQueue,
    required TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )
    updateProgress,
    required TResult Function(
      String fileId,
      String downloadUrl,
      String? documentId,
    )
    fileCompleted,
    required TResult Function(String fileId, String error) fileFailed,
    required TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )
    updateSettings,
    required TResult Function(List<XFile> files) validateFiles,
    required TResult Function() resetState,
    required TResult Function(String categoryId) setCategory,
    required TResult Function(Map<String, String> metadata) setMetadata,
    required TResult Function() processQueue,
    required TResult Function() uploadCompleted,
    required TResult Function(String error) uploadError,
    required TResult Function(double progress) overallProgressUpdated,
    required TResult Function(String fileId, double progress)
    fileProgressUpdated,
    required TResult Function(String fileId, UploadStatus status)
    fileStatusUpdated,
    required TResult Function(List<UploadFileModel> files)
    startUploadWithProgress,
    required TResult Function() clearUploadState,
  }) {
    return startUpload(files);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult? Function(List<UploadFileModel> files)? startUpload,
    TResult? Function(String? fileId)? pauseUpload,
    TResult? Function(String? fileId)? resumeUpload,
    TResult? Function(String? fileId)? cancelUpload,
    TResult? Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult? Function(String fileId)? removeFile,
    TResult? Function()? clearQueue,
    TResult? Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult? Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult? Function(String fileId, String error)? fileFailed,
    TResult? Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult? Function(List<XFile> files)? validateFiles,
    TResult? Function()? resetState,
    TResult? Function(String categoryId)? setCategory,
    TResult? Function(Map<String, String> metadata)? setMetadata,
    TResult? Function()? processQueue,
    TResult? Function()? uploadCompleted,
    TResult? Function(String error)? uploadError,
    TResult? Function(double progress)? overallProgressUpdated,
    TResult? Function(String fileId, double progress)? fileProgressUpdated,
    TResult? Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult? Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult? Function()? clearUploadState,
  }) {
    return startUpload?.call(files);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult Function(List<UploadFileModel> files)? startUpload,
    TResult Function(String? fileId)? pauseUpload,
    TResult Function(String? fileId)? resumeUpload,
    TResult Function(String? fileId)? cancelUpload,
    TResult Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult Function(String fileId)? removeFile,
    TResult Function()? clearQueue,
    TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult Function(String fileId, String error)? fileFailed,
    TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult Function(List<XFile> files)? validateFiles,
    TResult Function()? resetState,
    TResult Function(String categoryId)? setCategory,
    TResult Function(Map<String, String> metadata)? setMetadata,
    TResult Function()? processQueue,
    TResult Function()? uploadCompleted,
    TResult Function(String error)? uploadError,
    TResult Function(double progress)? overallProgressUpdated,
    TResult Function(String fileId, double progress)? fileProgressUpdated,
    TResult Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult Function()? clearUploadState,
    required TResult orElse(),
  }) {
    if (startUpload != null) {
      return startUpload(files);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddFiles value) addFiles,
    required TResult Function(StartUpload value) startUpload,
    required TResult Function(PauseUpload value) pauseUpload,
    required TResult Function(ResumeUpload value) resumeUpload,
    required TResult Function(CancelUpload value) cancelUpload,
    required TResult Function(RetryUpload value) retryUpload,
    required TResult Function(RemoveFile value) removeFile,
    required TResult Function(ClearQueue value) clearQueue,
    required TResult Function(UpdateProgress value) updateProgress,
    required TResult Function(FileCompleted value) fileCompleted,
    required TResult Function(FileFailed value) fileFailed,
    required TResult Function(UpdateSettings value) updateSettings,
    required TResult Function(ValidateFiles value) validateFiles,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SetCategory value) setCategory,
    required TResult Function(SetMetadata value) setMetadata,
    required TResult Function(ProcessQueue value) processQueue,
    required TResult Function(UploadCompleted value) uploadCompleted,
    required TResult Function(UploadError value) uploadError,
    required TResult Function(OverallProgressUpdated value)
    overallProgressUpdated,
    required TResult Function(FileProgressUpdated value) fileProgressUpdated,
    required TResult Function(FileStatusUpdated value) fileStatusUpdated,
    required TResult Function(StartUploadWithProgress value)
    startUploadWithProgress,
    required TResult Function(ClearUploadState value) clearUploadState,
  }) {
    return startUpload(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddFiles value)? addFiles,
    TResult? Function(StartUpload value)? startUpload,
    TResult? Function(PauseUpload value)? pauseUpload,
    TResult? Function(ResumeUpload value)? resumeUpload,
    TResult? Function(CancelUpload value)? cancelUpload,
    TResult? Function(RetryUpload value)? retryUpload,
    TResult? Function(RemoveFile value)? removeFile,
    TResult? Function(ClearQueue value)? clearQueue,
    TResult? Function(UpdateProgress value)? updateProgress,
    TResult? Function(FileCompleted value)? fileCompleted,
    TResult? Function(FileFailed value)? fileFailed,
    TResult? Function(UpdateSettings value)? updateSettings,
    TResult? Function(ValidateFiles value)? validateFiles,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SetCategory value)? setCategory,
    TResult? Function(SetMetadata value)? setMetadata,
    TResult? Function(ProcessQueue value)? processQueue,
    TResult? Function(UploadCompleted value)? uploadCompleted,
    TResult? Function(UploadError value)? uploadError,
    TResult? Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult? Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult? Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult? Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult? Function(ClearUploadState value)? clearUploadState,
  }) {
    return startUpload?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddFiles value)? addFiles,
    TResult Function(StartUpload value)? startUpload,
    TResult Function(PauseUpload value)? pauseUpload,
    TResult Function(ResumeUpload value)? resumeUpload,
    TResult Function(CancelUpload value)? cancelUpload,
    TResult Function(RetryUpload value)? retryUpload,
    TResult Function(RemoveFile value)? removeFile,
    TResult Function(ClearQueue value)? clearQueue,
    TResult Function(UpdateProgress value)? updateProgress,
    TResult Function(FileCompleted value)? fileCompleted,
    TResult Function(FileFailed value)? fileFailed,
    TResult Function(UpdateSettings value)? updateSettings,
    TResult Function(ValidateFiles value)? validateFiles,
    TResult Function(ResetState value)? resetState,
    TResult Function(SetCategory value)? setCategory,
    TResult Function(SetMetadata value)? setMetadata,
    TResult Function(ProcessQueue value)? processQueue,
    TResult Function(UploadCompleted value)? uploadCompleted,
    TResult Function(UploadError value)? uploadError,
    TResult Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult Function(ClearUploadState value)? clearUploadState,
    required TResult orElse(),
  }) {
    if (startUpload != null) {
      return startUpload(this);
    }
    return orElse();
  }
}

abstract class StartUpload implements UploadEvent {
  const factory StartUpload({required final List<UploadFileModel> files}) =
      _$StartUploadImpl;

  List<UploadFileModel> get files;

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StartUploadImplCopyWith<_$StartUploadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PauseUploadImplCopyWith<$Res> {
  factory _$$PauseUploadImplCopyWith(
    _$PauseUploadImpl value,
    $Res Function(_$PauseUploadImpl) then,
  ) = __$$PauseUploadImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? fileId});
}

/// @nodoc
class __$$PauseUploadImplCopyWithImpl<$Res>
    extends _$UploadEventCopyWithImpl<$Res, _$PauseUploadImpl>
    implements _$$PauseUploadImplCopyWith<$Res> {
  __$$PauseUploadImplCopyWithImpl(
    _$PauseUploadImpl _value,
    $Res Function(_$PauseUploadImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? fileId = freezed}) {
    return _then(
      _$PauseUploadImpl(
        fileId: freezed == fileId
            ? _value.fileId
            : fileId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$PauseUploadImpl implements PauseUpload {
  const _$PauseUploadImpl({this.fileId});

  @override
  final String? fileId;

  @override
  String toString() {
    return 'UploadEvent.pauseUpload(fileId: $fileId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PauseUploadImpl &&
            (identical(other.fileId, fileId) || other.fileId == fileId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fileId);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PauseUploadImplCopyWith<_$PauseUploadImpl> get copyWith =>
      __$$PauseUploadImplCopyWithImpl<_$PauseUploadImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )
    addFiles,
    required TResult Function(List<UploadFileModel> files) startUpload,
    required TResult Function(String? fileId) pauseUpload,
    required TResult Function(String? fileId) resumeUpload,
    required TResult Function(String? fileId) cancelUpload,
    required TResult Function(List<UploadFileModel> failedFiles) retryUpload,
    required TResult Function(String fileId) removeFile,
    required TResult Function() clearQueue,
    required TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )
    updateProgress,
    required TResult Function(
      String fileId,
      String downloadUrl,
      String? documentId,
    )
    fileCompleted,
    required TResult Function(String fileId, String error) fileFailed,
    required TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )
    updateSettings,
    required TResult Function(List<XFile> files) validateFiles,
    required TResult Function() resetState,
    required TResult Function(String categoryId) setCategory,
    required TResult Function(Map<String, String> metadata) setMetadata,
    required TResult Function() processQueue,
    required TResult Function() uploadCompleted,
    required TResult Function(String error) uploadError,
    required TResult Function(double progress) overallProgressUpdated,
    required TResult Function(String fileId, double progress)
    fileProgressUpdated,
    required TResult Function(String fileId, UploadStatus status)
    fileStatusUpdated,
    required TResult Function(List<UploadFileModel> files)
    startUploadWithProgress,
    required TResult Function() clearUploadState,
  }) {
    return pauseUpload(fileId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult? Function(List<UploadFileModel> files)? startUpload,
    TResult? Function(String? fileId)? pauseUpload,
    TResult? Function(String? fileId)? resumeUpload,
    TResult? Function(String? fileId)? cancelUpload,
    TResult? Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult? Function(String fileId)? removeFile,
    TResult? Function()? clearQueue,
    TResult? Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult? Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult? Function(String fileId, String error)? fileFailed,
    TResult? Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult? Function(List<XFile> files)? validateFiles,
    TResult? Function()? resetState,
    TResult? Function(String categoryId)? setCategory,
    TResult? Function(Map<String, String> metadata)? setMetadata,
    TResult? Function()? processQueue,
    TResult? Function()? uploadCompleted,
    TResult? Function(String error)? uploadError,
    TResult? Function(double progress)? overallProgressUpdated,
    TResult? Function(String fileId, double progress)? fileProgressUpdated,
    TResult? Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult? Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult? Function()? clearUploadState,
  }) {
    return pauseUpload?.call(fileId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult Function(List<UploadFileModel> files)? startUpload,
    TResult Function(String? fileId)? pauseUpload,
    TResult Function(String? fileId)? resumeUpload,
    TResult Function(String? fileId)? cancelUpload,
    TResult Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult Function(String fileId)? removeFile,
    TResult Function()? clearQueue,
    TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult Function(String fileId, String error)? fileFailed,
    TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult Function(List<XFile> files)? validateFiles,
    TResult Function()? resetState,
    TResult Function(String categoryId)? setCategory,
    TResult Function(Map<String, String> metadata)? setMetadata,
    TResult Function()? processQueue,
    TResult Function()? uploadCompleted,
    TResult Function(String error)? uploadError,
    TResult Function(double progress)? overallProgressUpdated,
    TResult Function(String fileId, double progress)? fileProgressUpdated,
    TResult Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult Function()? clearUploadState,
    required TResult orElse(),
  }) {
    if (pauseUpload != null) {
      return pauseUpload(fileId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddFiles value) addFiles,
    required TResult Function(StartUpload value) startUpload,
    required TResult Function(PauseUpload value) pauseUpload,
    required TResult Function(ResumeUpload value) resumeUpload,
    required TResult Function(CancelUpload value) cancelUpload,
    required TResult Function(RetryUpload value) retryUpload,
    required TResult Function(RemoveFile value) removeFile,
    required TResult Function(ClearQueue value) clearQueue,
    required TResult Function(UpdateProgress value) updateProgress,
    required TResult Function(FileCompleted value) fileCompleted,
    required TResult Function(FileFailed value) fileFailed,
    required TResult Function(UpdateSettings value) updateSettings,
    required TResult Function(ValidateFiles value) validateFiles,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SetCategory value) setCategory,
    required TResult Function(SetMetadata value) setMetadata,
    required TResult Function(ProcessQueue value) processQueue,
    required TResult Function(UploadCompleted value) uploadCompleted,
    required TResult Function(UploadError value) uploadError,
    required TResult Function(OverallProgressUpdated value)
    overallProgressUpdated,
    required TResult Function(FileProgressUpdated value) fileProgressUpdated,
    required TResult Function(FileStatusUpdated value) fileStatusUpdated,
    required TResult Function(StartUploadWithProgress value)
    startUploadWithProgress,
    required TResult Function(ClearUploadState value) clearUploadState,
  }) {
    return pauseUpload(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddFiles value)? addFiles,
    TResult? Function(StartUpload value)? startUpload,
    TResult? Function(PauseUpload value)? pauseUpload,
    TResult? Function(ResumeUpload value)? resumeUpload,
    TResult? Function(CancelUpload value)? cancelUpload,
    TResult? Function(RetryUpload value)? retryUpload,
    TResult? Function(RemoveFile value)? removeFile,
    TResult? Function(ClearQueue value)? clearQueue,
    TResult? Function(UpdateProgress value)? updateProgress,
    TResult? Function(FileCompleted value)? fileCompleted,
    TResult? Function(FileFailed value)? fileFailed,
    TResult? Function(UpdateSettings value)? updateSettings,
    TResult? Function(ValidateFiles value)? validateFiles,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SetCategory value)? setCategory,
    TResult? Function(SetMetadata value)? setMetadata,
    TResult? Function(ProcessQueue value)? processQueue,
    TResult? Function(UploadCompleted value)? uploadCompleted,
    TResult? Function(UploadError value)? uploadError,
    TResult? Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult? Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult? Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult? Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult? Function(ClearUploadState value)? clearUploadState,
  }) {
    return pauseUpload?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddFiles value)? addFiles,
    TResult Function(StartUpload value)? startUpload,
    TResult Function(PauseUpload value)? pauseUpload,
    TResult Function(ResumeUpload value)? resumeUpload,
    TResult Function(CancelUpload value)? cancelUpload,
    TResult Function(RetryUpload value)? retryUpload,
    TResult Function(RemoveFile value)? removeFile,
    TResult Function(ClearQueue value)? clearQueue,
    TResult Function(UpdateProgress value)? updateProgress,
    TResult Function(FileCompleted value)? fileCompleted,
    TResult Function(FileFailed value)? fileFailed,
    TResult Function(UpdateSettings value)? updateSettings,
    TResult Function(ValidateFiles value)? validateFiles,
    TResult Function(ResetState value)? resetState,
    TResult Function(SetCategory value)? setCategory,
    TResult Function(SetMetadata value)? setMetadata,
    TResult Function(ProcessQueue value)? processQueue,
    TResult Function(UploadCompleted value)? uploadCompleted,
    TResult Function(UploadError value)? uploadError,
    TResult Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult Function(ClearUploadState value)? clearUploadState,
    required TResult orElse(),
  }) {
    if (pauseUpload != null) {
      return pauseUpload(this);
    }
    return orElse();
  }
}

abstract class PauseUpload implements UploadEvent {
  const factory PauseUpload({final String? fileId}) = _$PauseUploadImpl;

  String? get fileId;

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PauseUploadImplCopyWith<_$PauseUploadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ResumeUploadImplCopyWith<$Res> {
  factory _$$ResumeUploadImplCopyWith(
    _$ResumeUploadImpl value,
    $Res Function(_$ResumeUploadImpl) then,
  ) = __$$ResumeUploadImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? fileId});
}

/// @nodoc
class __$$ResumeUploadImplCopyWithImpl<$Res>
    extends _$UploadEventCopyWithImpl<$Res, _$ResumeUploadImpl>
    implements _$$ResumeUploadImplCopyWith<$Res> {
  __$$ResumeUploadImplCopyWithImpl(
    _$ResumeUploadImpl _value,
    $Res Function(_$ResumeUploadImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? fileId = freezed}) {
    return _then(
      _$ResumeUploadImpl(
        fileId: freezed == fileId
            ? _value.fileId
            : fileId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ResumeUploadImpl implements ResumeUpload {
  const _$ResumeUploadImpl({this.fileId});

  @override
  final String? fileId;

  @override
  String toString() {
    return 'UploadEvent.resumeUpload(fileId: $fileId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResumeUploadImpl &&
            (identical(other.fileId, fileId) || other.fileId == fileId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fileId);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResumeUploadImplCopyWith<_$ResumeUploadImpl> get copyWith =>
      __$$ResumeUploadImplCopyWithImpl<_$ResumeUploadImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )
    addFiles,
    required TResult Function(List<UploadFileModel> files) startUpload,
    required TResult Function(String? fileId) pauseUpload,
    required TResult Function(String? fileId) resumeUpload,
    required TResult Function(String? fileId) cancelUpload,
    required TResult Function(List<UploadFileModel> failedFiles) retryUpload,
    required TResult Function(String fileId) removeFile,
    required TResult Function() clearQueue,
    required TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )
    updateProgress,
    required TResult Function(
      String fileId,
      String downloadUrl,
      String? documentId,
    )
    fileCompleted,
    required TResult Function(String fileId, String error) fileFailed,
    required TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )
    updateSettings,
    required TResult Function(List<XFile> files) validateFiles,
    required TResult Function() resetState,
    required TResult Function(String categoryId) setCategory,
    required TResult Function(Map<String, String> metadata) setMetadata,
    required TResult Function() processQueue,
    required TResult Function() uploadCompleted,
    required TResult Function(String error) uploadError,
    required TResult Function(double progress) overallProgressUpdated,
    required TResult Function(String fileId, double progress)
    fileProgressUpdated,
    required TResult Function(String fileId, UploadStatus status)
    fileStatusUpdated,
    required TResult Function(List<UploadFileModel> files)
    startUploadWithProgress,
    required TResult Function() clearUploadState,
  }) {
    return resumeUpload(fileId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult? Function(List<UploadFileModel> files)? startUpload,
    TResult? Function(String? fileId)? pauseUpload,
    TResult? Function(String? fileId)? resumeUpload,
    TResult? Function(String? fileId)? cancelUpload,
    TResult? Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult? Function(String fileId)? removeFile,
    TResult? Function()? clearQueue,
    TResult? Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult? Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult? Function(String fileId, String error)? fileFailed,
    TResult? Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult? Function(List<XFile> files)? validateFiles,
    TResult? Function()? resetState,
    TResult? Function(String categoryId)? setCategory,
    TResult? Function(Map<String, String> metadata)? setMetadata,
    TResult? Function()? processQueue,
    TResult? Function()? uploadCompleted,
    TResult? Function(String error)? uploadError,
    TResult? Function(double progress)? overallProgressUpdated,
    TResult? Function(String fileId, double progress)? fileProgressUpdated,
    TResult? Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult? Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult? Function()? clearUploadState,
  }) {
    return resumeUpload?.call(fileId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult Function(List<UploadFileModel> files)? startUpload,
    TResult Function(String? fileId)? pauseUpload,
    TResult Function(String? fileId)? resumeUpload,
    TResult Function(String? fileId)? cancelUpload,
    TResult Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult Function(String fileId)? removeFile,
    TResult Function()? clearQueue,
    TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult Function(String fileId, String error)? fileFailed,
    TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult Function(List<XFile> files)? validateFiles,
    TResult Function()? resetState,
    TResult Function(String categoryId)? setCategory,
    TResult Function(Map<String, String> metadata)? setMetadata,
    TResult Function()? processQueue,
    TResult Function()? uploadCompleted,
    TResult Function(String error)? uploadError,
    TResult Function(double progress)? overallProgressUpdated,
    TResult Function(String fileId, double progress)? fileProgressUpdated,
    TResult Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult Function()? clearUploadState,
    required TResult orElse(),
  }) {
    if (resumeUpload != null) {
      return resumeUpload(fileId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddFiles value) addFiles,
    required TResult Function(StartUpload value) startUpload,
    required TResult Function(PauseUpload value) pauseUpload,
    required TResult Function(ResumeUpload value) resumeUpload,
    required TResult Function(CancelUpload value) cancelUpload,
    required TResult Function(RetryUpload value) retryUpload,
    required TResult Function(RemoveFile value) removeFile,
    required TResult Function(ClearQueue value) clearQueue,
    required TResult Function(UpdateProgress value) updateProgress,
    required TResult Function(FileCompleted value) fileCompleted,
    required TResult Function(FileFailed value) fileFailed,
    required TResult Function(UpdateSettings value) updateSettings,
    required TResult Function(ValidateFiles value) validateFiles,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SetCategory value) setCategory,
    required TResult Function(SetMetadata value) setMetadata,
    required TResult Function(ProcessQueue value) processQueue,
    required TResult Function(UploadCompleted value) uploadCompleted,
    required TResult Function(UploadError value) uploadError,
    required TResult Function(OverallProgressUpdated value)
    overallProgressUpdated,
    required TResult Function(FileProgressUpdated value) fileProgressUpdated,
    required TResult Function(FileStatusUpdated value) fileStatusUpdated,
    required TResult Function(StartUploadWithProgress value)
    startUploadWithProgress,
    required TResult Function(ClearUploadState value) clearUploadState,
  }) {
    return resumeUpload(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddFiles value)? addFiles,
    TResult? Function(StartUpload value)? startUpload,
    TResult? Function(PauseUpload value)? pauseUpload,
    TResult? Function(ResumeUpload value)? resumeUpload,
    TResult? Function(CancelUpload value)? cancelUpload,
    TResult? Function(RetryUpload value)? retryUpload,
    TResult? Function(RemoveFile value)? removeFile,
    TResult? Function(ClearQueue value)? clearQueue,
    TResult? Function(UpdateProgress value)? updateProgress,
    TResult? Function(FileCompleted value)? fileCompleted,
    TResult? Function(FileFailed value)? fileFailed,
    TResult? Function(UpdateSettings value)? updateSettings,
    TResult? Function(ValidateFiles value)? validateFiles,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SetCategory value)? setCategory,
    TResult? Function(SetMetadata value)? setMetadata,
    TResult? Function(ProcessQueue value)? processQueue,
    TResult? Function(UploadCompleted value)? uploadCompleted,
    TResult? Function(UploadError value)? uploadError,
    TResult? Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult? Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult? Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult? Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult? Function(ClearUploadState value)? clearUploadState,
  }) {
    return resumeUpload?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddFiles value)? addFiles,
    TResult Function(StartUpload value)? startUpload,
    TResult Function(PauseUpload value)? pauseUpload,
    TResult Function(ResumeUpload value)? resumeUpload,
    TResult Function(CancelUpload value)? cancelUpload,
    TResult Function(RetryUpload value)? retryUpload,
    TResult Function(RemoveFile value)? removeFile,
    TResult Function(ClearQueue value)? clearQueue,
    TResult Function(UpdateProgress value)? updateProgress,
    TResult Function(FileCompleted value)? fileCompleted,
    TResult Function(FileFailed value)? fileFailed,
    TResult Function(UpdateSettings value)? updateSettings,
    TResult Function(ValidateFiles value)? validateFiles,
    TResult Function(ResetState value)? resetState,
    TResult Function(SetCategory value)? setCategory,
    TResult Function(SetMetadata value)? setMetadata,
    TResult Function(ProcessQueue value)? processQueue,
    TResult Function(UploadCompleted value)? uploadCompleted,
    TResult Function(UploadError value)? uploadError,
    TResult Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult Function(ClearUploadState value)? clearUploadState,
    required TResult orElse(),
  }) {
    if (resumeUpload != null) {
      return resumeUpload(this);
    }
    return orElse();
  }
}

abstract class ResumeUpload implements UploadEvent {
  const factory ResumeUpload({final String? fileId}) = _$ResumeUploadImpl;

  String? get fileId;

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResumeUploadImplCopyWith<_$ResumeUploadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CancelUploadImplCopyWith<$Res> {
  factory _$$CancelUploadImplCopyWith(
    _$CancelUploadImpl value,
    $Res Function(_$CancelUploadImpl) then,
  ) = __$$CancelUploadImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? fileId});
}

/// @nodoc
class __$$CancelUploadImplCopyWithImpl<$Res>
    extends _$UploadEventCopyWithImpl<$Res, _$CancelUploadImpl>
    implements _$$CancelUploadImplCopyWith<$Res> {
  __$$CancelUploadImplCopyWithImpl(
    _$CancelUploadImpl _value,
    $Res Function(_$CancelUploadImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? fileId = freezed}) {
    return _then(
      _$CancelUploadImpl(
        fileId: freezed == fileId
            ? _value.fileId
            : fileId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$CancelUploadImpl implements CancelUpload {
  const _$CancelUploadImpl({this.fileId});

  @override
  final String? fileId;

  @override
  String toString() {
    return 'UploadEvent.cancelUpload(fileId: $fileId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CancelUploadImpl &&
            (identical(other.fileId, fileId) || other.fileId == fileId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fileId);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CancelUploadImplCopyWith<_$CancelUploadImpl> get copyWith =>
      __$$CancelUploadImplCopyWithImpl<_$CancelUploadImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )
    addFiles,
    required TResult Function(List<UploadFileModel> files) startUpload,
    required TResult Function(String? fileId) pauseUpload,
    required TResult Function(String? fileId) resumeUpload,
    required TResult Function(String? fileId) cancelUpload,
    required TResult Function(List<UploadFileModel> failedFiles) retryUpload,
    required TResult Function(String fileId) removeFile,
    required TResult Function() clearQueue,
    required TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )
    updateProgress,
    required TResult Function(
      String fileId,
      String downloadUrl,
      String? documentId,
    )
    fileCompleted,
    required TResult Function(String fileId, String error) fileFailed,
    required TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )
    updateSettings,
    required TResult Function(List<XFile> files) validateFiles,
    required TResult Function() resetState,
    required TResult Function(String categoryId) setCategory,
    required TResult Function(Map<String, String> metadata) setMetadata,
    required TResult Function() processQueue,
    required TResult Function() uploadCompleted,
    required TResult Function(String error) uploadError,
    required TResult Function(double progress) overallProgressUpdated,
    required TResult Function(String fileId, double progress)
    fileProgressUpdated,
    required TResult Function(String fileId, UploadStatus status)
    fileStatusUpdated,
    required TResult Function(List<UploadFileModel> files)
    startUploadWithProgress,
    required TResult Function() clearUploadState,
  }) {
    return cancelUpload(fileId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult? Function(List<UploadFileModel> files)? startUpload,
    TResult? Function(String? fileId)? pauseUpload,
    TResult? Function(String? fileId)? resumeUpload,
    TResult? Function(String? fileId)? cancelUpload,
    TResult? Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult? Function(String fileId)? removeFile,
    TResult? Function()? clearQueue,
    TResult? Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult? Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult? Function(String fileId, String error)? fileFailed,
    TResult? Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult? Function(List<XFile> files)? validateFiles,
    TResult? Function()? resetState,
    TResult? Function(String categoryId)? setCategory,
    TResult? Function(Map<String, String> metadata)? setMetadata,
    TResult? Function()? processQueue,
    TResult? Function()? uploadCompleted,
    TResult? Function(String error)? uploadError,
    TResult? Function(double progress)? overallProgressUpdated,
    TResult? Function(String fileId, double progress)? fileProgressUpdated,
    TResult? Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult? Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult? Function()? clearUploadState,
  }) {
    return cancelUpload?.call(fileId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult Function(List<UploadFileModel> files)? startUpload,
    TResult Function(String? fileId)? pauseUpload,
    TResult Function(String? fileId)? resumeUpload,
    TResult Function(String? fileId)? cancelUpload,
    TResult Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult Function(String fileId)? removeFile,
    TResult Function()? clearQueue,
    TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult Function(String fileId, String error)? fileFailed,
    TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult Function(List<XFile> files)? validateFiles,
    TResult Function()? resetState,
    TResult Function(String categoryId)? setCategory,
    TResult Function(Map<String, String> metadata)? setMetadata,
    TResult Function()? processQueue,
    TResult Function()? uploadCompleted,
    TResult Function(String error)? uploadError,
    TResult Function(double progress)? overallProgressUpdated,
    TResult Function(String fileId, double progress)? fileProgressUpdated,
    TResult Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult Function()? clearUploadState,
    required TResult orElse(),
  }) {
    if (cancelUpload != null) {
      return cancelUpload(fileId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddFiles value) addFiles,
    required TResult Function(StartUpload value) startUpload,
    required TResult Function(PauseUpload value) pauseUpload,
    required TResult Function(ResumeUpload value) resumeUpload,
    required TResult Function(CancelUpload value) cancelUpload,
    required TResult Function(RetryUpload value) retryUpload,
    required TResult Function(RemoveFile value) removeFile,
    required TResult Function(ClearQueue value) clearQueue,
    required TResult Function(UpdateProgress value) updateProgress,
    required TResult Function(FileCompleted value) fileCompleted,
    required TResult Function(FileFailed value) fileFailed,
    required TResult Function(UpdateSettings value) updateSettings,
    required TResult Function(ValidateFiles value) validateFiles,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SetCategory value) setCategory,
    required TResult Function(SetMetadata value) setMetadata,
    required TResult Function(ProcessQueue value) processQueue,
    required TResult Function(UploadCompleted value) uploadCompleted,
    required TResult Function(UploadError value) uploadError,
    required TResult Function(OverallProgressUpdated value)
    overallProgressUpdated,
    required TResult Function(FileProgressUpdated value) fileProgressUpdated,
    required TResult Function(FileStatusUpdated value) fileStatusUpdated,
    required TResult Function(StartUploadWithProgress value)
    startUploadWithProgress,
    required TResult Function(ClearUploadState value) clearUploadState,
  }) {
    return cancelUpload(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddFiles value)? addFiles,
    TResult? Function(StartUpload value)? startUpload,
    TResult? Function(PauseUpload value)? pauseUpload,
    TResult? Function(ResumeUpload value)? resumeUpload,
    TResult? Function(CancelUpload value)? cancelUpload,
    TResult? Function(RetryUpload value)? retryUpload,
    TResult? Function(RemoveFile value)? removeFile,
    TResult? Function(ClearQueue value)? clearQueue,
    TResult? Function(UpdateProgress value)? updateProgress,
    TResult? Function(FileCompleted value)? fileCompleted,
    TResult? Function(FileFailed value)? fileFailed,
    TResult? Function(UpdateSettings value)? updateSettings,
    TResult? Function(ValidateFiles value)? validateFiles,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SetCategory value)? setCategory,
    TResult? Function(SetMetadata value)? setMetadata,
    TResult? Function(ProcessQueue value)? processQueue,
    TResult? Function(UploadCompleted value)? uploadCompleted,
    TResult? Function(UploadError value)? uploadError,
    TResult? Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult? Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult? Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult? Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult? Function(ClearUploadState value)? clearUploadState,
  }) {
    return cancelUpload?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddFiles value)? addFiles,
    TResult Function(StartUpload value)? startUpload,
    TResult Function(PauseUpload value)? pauseUpload,
    TResult Function(ResumeUpload value)? resumeUpload,
    TResult Function(CancelUpload value)? cancelUpload,
    TResult Function(RetryUpload value)? retryUpload,
    TResult Function(RemoveFile value)? removeFile,
    TResult Function(ClearQueue value)? clearQueue,
    TResult Function(UpdateProgress value)? updateProgress,
    TResult Function(FileCompleted value)? fileCompleted,
    TResult Function(FileFailed value)? fileFailed,
    TResult Function(UpdateSettings value)? updateSettings,
    TResult Function(ValidateFiles value)? validateFiles,
    TResult Function(ResetState value)? resetState,
    TResult Function(SetCategory value)? setCategory,
    TResult Function(SetMetadata value)? setMetadata,
    TResult Function(ProcessQueue value)? processQueue,
    TResult Function(UploadCompleted value)? uploadCompleted,
    TResult Function(UploadError value)? uploadError,
    TResult Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult Function(ClearUploadState value)? clearUploadState,
    required TResult orElse(),
  }) {
    if (cancelUpload != null) {
      return cancelUpload(this);
    }
    return orElse();
  }
}

abstract class CancelUpload implements UploadEvent {
  const factory CancelUpload({final String? fileId}) = _$CancelUploadImpl;

  String? get fileId;

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CancelUploadImplCopyWith<_$CancelUploadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RetryUploadImplCopyWith<$Res> {
  factory _$$RetryUploadImplCopyWith(
    _$RetryUploadImpl value,
    $Res Function(_$RetryUploadImpl) then,
  ) = __$$RetryUploadImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<UploadFileModel> failedFiles});
}

/// @nodoc
class __$$RetryUploadImplCopyWithImpl<$Res>
    extends _$UploadEventCopyWithImpl<$Res, _$RetryUploadImpl>
    implements _$$RetryUploadImplCopyWith<$Res> {
  __$$RetryUploadImplCopyWithImpl(
    _$RetryUploadImpl _value,
    $Res Function(_$RetryUploadImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? failedFiles = null}) {
    return _then(
      _$RetryUploadImpl(
        failedFiles: null == failedFiles
            ? _value._failedFiles
            : failedFiles // ignore: cast_nullable_to_non_nullable
                  as List<UploadFileModel>,
      ),
    );
  }
}

/// @nodoc

class _$RetryUploadImpl implements RetryUpload {
  const _$RetryUploadImpl({required final List<UploadFileModel> failedFiles})
    : _failedFiles = failedFiles;

  final List<UploadFileModel> _failedFiles;
  @override
  List<UploadFileModel> get failedFiles {
    if (_failedFiles is EqualUnmodifiableListView) return _failedFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_failedFiles);
  }

  @override
  String toString() {
    return 'UploadEvent.retryUpload(failedFiles: $failedFiles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RetryUploadImpl &&
            const DeepCollectionEquality().equals(
              other._failedFiles,
              _failedFiles,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_failedFiles),
  );

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RetryUploadImplCopyWith<_$RetryUploadImpl> get copyWith =>
      __$$RetryUploadImplCopyWithImpl<_$RetryUploadImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )
    addFiles,
    required TResult Function(List<UploadFileModel> files) startUpload,
    required TResult Function(String? fileId) pauseUpload,
    required TResult Function(String? fileId) resumeUpload,
    required TResult Function(String? fileId) cancelUpload,
    required TResult Function(List<UploadFileModel> failedFiles) retryUpload,
    required TResult Function(String fileId) removeFile,
    required TResult Function() clearQueue,
    required TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )
    updateProgress,
    required TResult Function(
      String fileId,
      String downloadUrl,
      String? documentId,
    )
    fileCompleted,
    required TResult Function(String fileId, String error) fileFailed,
    required TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )
    updateSettings,
    required TResult Function(List<XFile> files) validateFiles,
    required TResult Function() resetState,
    required TResult Function(String categoryId) setCategory,
    required TResult Function(Map<String, String> metadata) setMetadata,
    required TResult Function() processQueue,
    required TResult Function() uploadCompleted,
    required TResult Function(String error) uploadError,
    required TResult Function(double progress) overallProgressUpdated,
    required TResult Function(String fileId, double progress)
    fileProgressUpdated,
    required TResult Function(String fileId, UploadStatus status)
    fileStatusUpdated,
    required TResult Function(List<UploadFileModel> files)
    startUploadWithProgress,
    required TResult Function() clearUploadState,
  }) {
    return retryUpload(failedFiles);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult? Function(List<UploadFileModel> files)? startUpload,
    TResult? Function(String? fileId)? pauseUpload,
    TResult? Function(String? fileId)? resumeUpload,
    TResult? Function(String? fileId)? cancelUpload,
    TResult? Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult? Function(String fileId)? removeFile,
    TResult? Function()? clearQueue,
    TResult? Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult? Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult? Function(String fileId, String error)? fileFailed,
    TResult? Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult? Function(List<XFile> files)? validateFiles,
    TResult? Function()? resetState,
    TResult? Function(String categoryId)? setCategory,
    TResult? Function(Map<String, String> metadata)? setMetadata,
    TResult? Function()? processQueue,
    TResult? Function()? uploadCompleted,
    TResult? Function(String error)? uploadError,
    TResult? Function(double progress)? overallProgressUpdated,
    TResult? Function(String fileId, double progress)? fileProgressUpdated,
    TResult? Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult? Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult? Function()? clearUploadState,
  }) {
    return retryUpload?.call(failedFiles);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult Function(List<UploadFileModel> files)? startUpload,
    TResult Function(String? fileId)? pauseUpload,
    TResult Function(String? fileId)? resumeUpload,
    TResult Function(String? fileId)? cancelUpload,
    TResult Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult Function(String fileId)? removeFile,
    TResult Function()? clearQueue,
    TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult Function(String fileId, String error)? fileFailed,
    TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult Function(List<XFile> files)? validateFiles,
    TResult Function()? resetState,
    TResult Function(String categoryId)? setCategory,
    TResult Function(Map<String, String> metadata)? setMetadata,
    TResult Function()? processQueue,
    TResult Function()? uploadCompleted,
    TResult Function(String error)? uploadError,
    TResult Function(double progress)? overallProgressUpdated,
    TResult Function(String fileId, double progress)? fileProgressUpdated,
    TResult Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult Function()? clearUploadState,
    required TResult orElse(),
  }) {
    if (retryUpload != null) {
      return retryUpload(failedFiles);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddFiles value) addFiles,
    required TResult Function(StartUpload value) startUpload,
    required TResult Function(PauseUpload value) pauseUpload,
    required TResult Function(ResumeUpload value) resumeUpload,
    required TResult Function(CancelUpload value) cancelUpload,
    required TResult Function(RetryUpload value) retryUpload,
    required TResult Function(RemoveFile value) removeFile,
    required TResult Function(ClearQueue value) clearQueue,
    required TResult Function(UpdateProgress value) updateProgress,
    required TResult Function(FileCompleted value) fileCompleted,
    required TResult Function(FileFailed value) fileFailed,
    required TResult Function(UpdateSettings value) updateSettings,
    required TResult Function(ValidateFiles value) validateFiles,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SetCategory value) setCategory,
    required TResult Function(SetMetadata value) setMetadata,
    required TResult Function(ProcessQueue value) processQueue,
    required TResult Function(UploadCompleted value) uploadCompleted,
    required TResult Function(UploadError value) uploadError,
    required TResult Function(OverallProgressUpdated value)
    overallProgressUpdated,
    required TResult Function(FileProgressUpdated value) fileProgressUpdated,
    required TResult Function(FileStatusUpdated value) fileStatusUpdated,
    required TResult Function(StartUploadWithProgress value)
    startUploadWithProgress,
    required TResult Function(ClearUploadState value) clearUploadState,
  }) {
    return retryUpload(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddFiles value)? addFiles,
    TResult? Function(StartUpload value)? startUpload,
    TResult? Function(PauseUpload value)? pauseUpload,
    TResult? Function(ResumeUpload value)? resumeUpload,
    TResult? Function(CancelUpload value)? cancelUpload,
    TResult? Function(RetryUpload value)? retryUpload,
    TResult? Function(RemoveFile value)? removeFile,
    TResult? Function(ClearQueue value)? clearQueue,
    TResult? Function(UpdateProgress value)? updateProgress,
    TResult? Function(FileCompleted value)? fileCompleted,
    TResult? Function(FileFailed value)? fileFailed,
    TResult? Function(UpdateSettings value)? updateSettings,
    TResult? Function(ValidateFiles value)? validateFiles,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SetCategory value)? setCategory,
    TResult? Function(SetMetadata value)? setMetadata,
    TResult? Function(ProcessQueue value)? processQueue,
    TResult? Function(UploadCompleted value)? uploadCompleted,
    TResult? Function(UploadError value)? uploadError,
    TResult? Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult? Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult? Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult? Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult? Function(ClearUploadState value)? clearUploadState,
  }) {
    return retryUpload?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddFiles value)? addFiles,
    TResult Function(StartUpload value)? startUpload,
    TResult Function(PauseUpload value)? pauseUpload,
    TResult Function(ResumeUpload value)? resumeUpload,
    TResult Function(CancelUpload value)? cancelUpload,
    TResult Function(RetryUpload value)? retryUpload,
    TResult Function(RemoveFile value)? removeFile,
    TResult Function(ClearQueue value)? clearQueue,
    TResult Function(UpdateProgress value)? updateProgress,
    TResult Function(FileCompleted value)? fileCompleted,
    TResult Function(FileFailed value)? fileFailed,
    TResult Function(UpdateSettings value)? updateSettings,
    TResult Function(ValidateFiles value)? validateFiles,
    TResult Function(ResetState value)? resetState,
    TResult Function(SetCategory value)? setCategory,
    TResult Function(SetMetadata value)? setMetadata,
    TResult Function(ProcessQueue value)? processQueue,
    TResult Function(UploadCompleted value)? uploadCompleted,
    TResult Function(UploadError value)? uploadError,
    TResult Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult Function(ClearUploadState value)? clearUploadState,
    required TResult orElse(),
  }) {
    if (retryUpload != null) {
      return retryUpload(this);
    }
    return orElse();
  }
}

abstract class RetryUpload implements UploadEvent {
  const factory RetryUpload({
    required final List<UploadFileModel> failedFiles,
  }) = _$RetryUploadImpl;

  List<UploadFileModel> get failedFiles;

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RetryUploadImplCopyWith<_$RetryUploadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RemoveFileImplCopyWith<$Res> {
  factory _$$RemoveFileImplCopyWith(
    _$RemoveFileImpl value,
    $Res Function(_$RemoveFileImpl) then,
  ) = __$$RemoveFileImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String fileId});
}

/// @nodoc
class __$$RemoveFileImplCopyWithImpl<$Res>
    extends _$UploadEventCopyWithImpl<$Res, _$RemoveFileImpl>
    implements _$$RemoveFileImplCopyWith<$Res> {
  __$$RemoveFileImplCopyWithImpl(
    _$RemoveFileImpl _value,
    $Res Function(_$RemoveFileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? fileId = null}) {
    return _then(
      _$RemoveFileImpl(
        fileId: null == fileId
            ? _value.fileId
            : fileId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$RemoveFileImpl implements RemoveFile {
  const _$RemoveFileImpl({required this.fileId});

  @override
  final String fileId;

  @override
  String toString() {
    return 'UploadEvent.removeFile(fileId: $fileId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RemoveFileImpl &&
            (identical(other.fileId, fileId) || other.fileId == fileId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fileId);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RemoveFileImplCopyWith<_$RemoveFileImpl> get copyWith =>
      __$$RemoveFileImplCopyWithImpl<_$RemoveFileImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )
    addFiles,
    required TResult Function(List<UploadFileModel> files) startUpload,
    required TResult Function(String? fileId) pauseUpload,
    required TResult Function(String? fileId) resumeUpload,
    required TResult Function(String? fileId) cancelUpload,
    required TResult Function(List<UploadFileModel> failedFiles) retryUpload,
    required TResult Function(String fileId) removeFile,
    required TResult Function() clearQueue,
    required TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )
    updateProgress,
    required TResult Function(
      String fileId,
      String downloadUrl,
      String? documentId,
    )
    fileCompleted,
    required TResult Function(String fileId, String error) fileFailed,
    required TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )
    updateSettings,
    required TResult Function(List<XFile> files) validateFiles,
    required TResult Function() resetState,
    required TResult Function(String categoryId) setCategory,
    required TResult Function(Map<String, String> metadata) setMetadata,
    required TResult Function() processQueue,
    required TResult Function() uploadCompleted,
    required TResult Function(String error) uploadError,
    required TResult Function(double progress) overallProgressUpdated,
    required TResult Function(String fileId, double progress)
    fileProgressUpdated,
    required TResult Function(String fileId, UploadStatus status)
    fileStatusUpdated,
    required TResult Function(List<UploadFileModel> files)
    startUploadWithProgress,
    required TResult Function() clearUploadState,
  }) {
    return removeFile(fileId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult? Function(List<UploadFileModel> files)? startUpload,
    TResult? Function(String? fileId)? pauseUpload,
    TResult? Function(String? fileId)? resumeUpload,
    TResult? Function(String? fileId)? cancelUpload,
    TResult? Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult? Function(String fileId)? removeFile,
    TResult? Function()? clearQueue,
    TResult? Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult? Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult? Function(String fileId, String error)? fileFailed,
    TResult? Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult? Function(List<XFile> files)? validateFiles,
    TResult? Function()? resetState,
    TResult? Function(String categoryId)? setCategory,
    TResult? Function(Map<String, String> metadata)? setMetadata,
    TResult? Function()? processQueue,
    TResult? Function()? uploadCompleted,
    TResult? Function(String error)? uploadError,
    TResult? Function(double progress)? overallProgressUpdated,
    TResult? Function(String fileId, double progress)? fileProgressUpdated,
    TResult? Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult? Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult? Function()? clearUploadState,
  }) {
    return removeFile?.call(fileId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult Function(List<UploadFileModel> files)? startUpload,
    TResult Function(String? fileId)? pauseUpload,
    TResult Function(String? fileId)? resumeUpload,
    TResult Function(String? fileId)? cancelUpload,
    TResult Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult Function(String fileId)? removeFile,
    TResult Function()? clearQueue,
    TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult Function(String fileId, String error)? fileFailed,
    TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult Function(List<XFile> files)? validateFiles,
    TResult Function()? resetState,
    TResult Function(String categoryId)? setCategory,
    TResult Function(Map<String, String> metadata)? setMetadata,
    TResult Function()? processQueue,
    TResult Function()? uploadCompleted,
    TResult Function(String error)? uploadError,
    TResult Function(double progress)? overallProgressUpdated,
    TResult Function(String fileId, double progress)? fileProgressUpdated,
    TResult Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult Function()? clearUploadState,
    required TResult orElse(),
  }) {
    if (removeFile != null) {
      return removeFile(fileId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddFiles value) addFiles,
    required TResult Function(StartUpload value) startUpload,
    required TResult Function(PauseUpload value) pauseUpload,
    required TResult Function(ResumeUpload value) resumeUpload,
    required TResult Function(CancelUpload value) cancelUpload,
    required TResult Function(RetryUpload value) retryUpload,
    required TResult Function(RemoveFile value) removeFile,
    required TResult Function(ClearQueue value) clearQueue,
    required TResult Function(UpdateProgress value) updateProgress,
    required TResult Function(FileCompleted value) fileCompleted,
    required TResult Function(FileFailed value) fileFailed,
    required TResult Function(UpdateSettings value) updateSettings,
    required TResult Function(ValidateFiles value) validateFiles,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SetCategory value) setCategory,
    required TResult Function(SetMetadata value) setMetadata,
    required TResult Function(ProcessQueue value) processQueue,
    required TResult Function(UploadCompleted value) uploadCompleted,
    required TResult Function(UploadError value) uploadError,
    required TResult Function(OverallProgressUpdated value)
    overallProgressUpdated,
    required TResult Function(FileProgressUpdated value) fileProgressUpdated,
    required TResult Function(FileStatusUpdated value) fileStatusUpdated,
    required TResult Function(StartUploadWithProgress value)
    startUploadWithProgress,
    required TResult Function(ClearUploadState value) clearUploadState,
  }) {
    return removeFile(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddFiles value)? addFiles,
    TResult? Function(StartUpload value)? startUpload,
    TResult? Function(PauseUpload value)? pauseUpload,
    TResult? Function(ResumeUpload value)? resumeUpload,
    TResult? Function(CancelUpload value)? cancelUpload,
    TResult? Function(RetryUpload value)? retryUpload,
    TResult? Function(RemoveFile value)? removeFile,
    TResult? Function(ClearQueue value)? clearQueue,
    TResult? Function(UpdateProgress value)? updateProgress,
    TResult? Function(FileCompleted value)? fileCompleted,
    TResult? Function(FileFailed value)? fileFailed,
    TResult? Function(UpdateSettings value)? updateSettings,
    TResult? Function(ValidateFiles value)? validateFiles,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SetCategory value)? setCategory,
    TResult? Function(SetMetadata value)? setMetadata,
    TResult? Function(ProcessQueue value)? processQueue,
    TResult? Function(UploadCompleted value)? uploadCompleted,
    TResult? Function(UploadError value)? uploadError,
    TResult? Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult? Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult? Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult? Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult? Function(ClearUploadState value)? clearUploadState,
  }) {
    return removeFile?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddFiles value)? addFiles,
    TResult Function(StartUpload value)? startUpload,
    TResult Function(PauseUpload value)? pauseUpload,
    TResult Function(ResumeUpload value)? resumeUpload,
    TResult Function(CancelUpload value)? cancelUpload,
    TResult Function(RetryUpload value)? retryUpload,
    TResult Function(RemoveFile value)? removeFile,
    TResult Function(ClearQueue value)? clearQueue,
    TResult Function(UpdateProgress value)? updateProgress,
    TResult Function(FileCompleted value)? fileCompleted,
    TResult Function(FileFailed value)? fileFailed,
    TResult Function(UpdateSettings value)? updateSettings,
    TResult Function(ValidateFiles value)? validateFiles,
    TResult Function(ResetState value)? resetState,
    TResult Function(SetCategory value)? setCategory,
    TResult Function(SetMetadata value)? setMetadata,
    TResult Function(ProcessQueue value)? processQueue,
    TResult Function(UploadCompleted value)? uploadCompleted,
    TResult Function(UploadError value)? uploadError,
    TResult Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult Function(ClearUploadState value)? clearUploadState,
    required TResult orElse(),
  }) {
    if (removeFile != null) {
      return removeFile(this);
    }
    return orElse();
  }
}

abstract class RemoveFile implements UploadEvent {
  const factory RemoveFile({required final String fileId}) = _$RemoveFileImpl;

  String get fileId;

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RemoveFileImplCopyWith<_$RemoveFileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ClearQueueImplCopyWith<$Res> {
  factory _$$ClearQueueImplCopyWith(
    _$ClearQueueImpl value,
    $Res Function(_$ClearQueueImpl) then,
  ) = __$$ClearQueueImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ClearQueueImplCopyWithImpl<$Res>
    extends _$UploadEventCopyWithImpl<$Res, _$ClearQueueImpl>
    implements _$$ClearQueueImplCopyWith<$Res> {
  __$$ClearQueueImplCopyWithImpl(
    _$ClearQueueImpl _value,
    $Res Function(_$ClearQueueImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ClearQueueImpl implements ClearQueue {
  const _$ClearQueueImpl();

  @override
  String toString() {
    return 'UploadEvent.clearQueue()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ClearQueueImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )
    addFiles,
    required TResult Function(List<UploadFileModel> files) startUpload,
    required TResult Function(String? fileId) pauseUpload,
    required TResult Function(String? fileId) resumeUpload,
    required TResult Function(String? fileId) cancelUpload,
    required TResult Function(List<UploadFileModel> failedFiles) retryUpload,
    required TResult Function(String fileId) removeFile,
    required TResult Function() clearQueue,
    required TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )
    updateProgress,
    required TResult Function(
      String fileId,
      String downloadUrl,
      String? documentId,
    )
    fileCompleted,
    required TResult Function(String fileId, String error) fileFailed,
    required TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )
    updateSettings,
    required TResult Function(List<XFile> files) validateFiles,
    required TResult Function() resetState,
    required TResult Function(String categoryId) setCategory,
    required TResult Function(Map<String, String> metadata) setMetadata,
    required TResult Function() processQueue,
    required TResult Function() uploadCompleted,
    required TResult Function(String error) uploadError,
    required TResult Function(double progress) overallProgressUpdated,
    required TResult Function(String fileId, double progress)
    fileProgressUpdated,
    required TResult Function(String fileId, UploadStatus status)
    fileStatusUpdated,
    required TResult Function(List<UploadFileModel> files)
    startUploadWithProgress,
    required TResult Function() clearUploadState,
  }) {
    return clearQueue();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult? Function(List<UploadFileModel> files)? startUpload,
    TResult? Function(String? fileId)? pauseUpload,
    TResult? Function(String? fileId)? resumeUpload,
    TResult? Function(String? fileId)? cancelUpload,
    TResult? Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult? Function(String fileId)? removeFile,
    TResult? Function()? clearQueue,
    TResult? Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult? Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult? Function(String fileId, String error)? fileFailed,
    TResult? Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult? Function(List<XFile> files)? validateFiles,
    TResult? Function()? resetState,
    TResult? Function(String categoryId)? setCategory,
    TResult? Function(Map<String, String> metadata)? setMetadata,
    TResult? Function()? processQueue,
    TResult? Function()? uploadCompleted,
    TResult? Function(String error)? uploadError,
    TResult? Function(double progress)? overallProgressUpdated,
    TResult? Function(String fileId, double progress)? fileProgressUpdated,
    TResult? Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult? Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult? Function()? clearUploadState,
  }) {
    return clearQueue?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult Function(List<UploadFileModel> files)? startUpload,
    TResult Function(String? fileId)? pauseUpload,
    TResult Function(String? fileId)? resumeUpload,
    TResult Function(String? fileId)? cancelUpload,
    TResult Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult Function(String fileId)? removeFile,
    TResult Function()? clearQueue,
    TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult Function(String fileId, String error)? fileFailed,
    TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult Function(List<XFile> files)? validateFiles,
    TResult Function()? resetState,
    TResult Function(String categoryId)? setCategory,
    TResult Function(Map<String, String> metadata)? setMetadata,
    TResult Function()? processQueue,
    TResult Function()? uploadCompleted,
    TResult Function(String error)? uploadError,
    TResult Function(double progress)? overallProgressUpdated,
    TResult Function(String fileId, double progress)? fileProgressUpdated,
    TResult Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult Function()? clearUploadState,
    required TResult orElse(),
  }) {
    if (clearQueue != null) {
      return clearQueue();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddFiles value) addFiles,
    required TResult Function(StartUpload value) startUpload,
    required TResult Function(PauseUpload value) pauseUpload,
    required TResult Function(ResumeUpload value) resumeUpload,
    required TResult Function(CancelUpload value) cancelUpload,
    required TResult Function(RetryUpload value) retryUpload,
    required TResult Function(RemoveFile value) removeFile,
    required TResult Function(ClearQueue value) clearQueue,
    required TResult Function(UpdateProgress value) updateProgress,
    required TResult Function(FileCompleted value) fileCompleted,
    required TResult Function(FileFailed value) fileFailed,
    required TResult Function(UpdateSettings value) updateSettings,
    required TResult Function(ValidateFiles value) validateFiles,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SetCategory value) setCategory,
    required TResult Function(SetMetadata value) setMetadata,
    required TResult Function(ProcessQueue value) processQueue,
    required TResult Function(UploadCompleted value) uploadCompleted,
    required TResult Function(UploadError value) uploadError,
    required TResult Function(OverallProgressUpdated value)
    overallProgressUpdated,
    required TResult Function(FileProgressUpdated value) fileProgressUpdated,
    required TResult Function(FileStatusUpdated value) fileStatusUpdated,
    required TResult Function(StartUploadWithProgress value)
    startUploadWithProgress,
    required TResult Function(ClearUploadState value) clearUploadState,
  }) {
    return clearQueue(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddFiles value)? addFiles,
    TResult? Function(StartUpload value)? startUpload,
    TResult? Function(PauseUpload value)? pauseUpload,
    TResult? Function(ResumeUpload value)? resumeUpload,
    TResult? Function(CancelUpload value)? cancelUpload,
    TResult? Function(RetryUpload value)? retryUpload,
    TResult? Function(RemoveFile value)? removeFile,
    TResult? Function(ClearQueue value)? clearQueue,
    TResult? Function(UpdateProgress value)? updateProgress,
    TResult? Function(FileCompleted value)? fileCompleted,
    TResult? Function(FileFailed value)? fileFailed,
    TResult? Function(UpdateSettings value)? updateSettings,
    TResult? Function(ValidateFiles value)? validateFiles,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SetCategory value)? setCategory,
    TResult? Function(SetMetadata value)? setMetadata,
    TResult? Function(ProcessQueue value)? processQueue,
    TResult? Function(UploadCompleted value)? uploadCompleted,
    TResult? Function(UploadError value)? uploadError,
    TResult? Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult? Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult? Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult? Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult? Function(ClearUploadState value)? clearUploadState,
  }) {
    return clearQueue?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddFiles value)? addFiles,
    TResult Function(StartUpload value)? startUpload,
    TResult Function(PauseUpload value)? pauseUpload,
    TResult Function(ResumeUpload value)? resumeUpload,
    TResult Function(CancelUpload value)? cancelUpload,
    TResult Function(RetryUpload value)? retryUpload,
    TResult Function(RemoveFile value)? removeFile,
    TResult Function(ClearQueue value)? clearQueue,
    TResult Function(UpdateProgress value)? updateProgress,
    TResult Function(FileCompleted value)? fileCompleted,
    TResult Function(FileFailed value)? fileFailed,
    TResult Function(UpdateSettings value)? updateSettings,
    TResult Function(ValidateFiles value)? validateFiles,
    TResult Function(ResetState value)? resetState,
    TResult Function(SetCategory value)? setCategory,
    TResult Function(SetMetadata value)? setMetadata,
    TResult Function(ProcessQueue value)? processQueue,
    TResult Function(UploadCompleted value)? uploadCompleted,
    TResult Function(UploadError value)? uploadError,
    TResult Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult Function(ClearUploadState value)? clearUploadState,
    required TResult orElse(),
  }) {
    if (clearQueue != null) {
      return clearQueue(this);
    }
    return orElse();
  }
}

abstract class ClearQueue implements UploadEvent {
  const factory ClearQueue() = _$ClearQueueImpl;
}

/// @nodoc
abstract class _$$UpdateProgressImplCopyWith<$Res> {
  factory _$$UpdateProgressImplCopyWith(
    _$UpdateProgressImpl value,
    $Res Function(_$UpdateProgressImpl) then,
  ) = __$$UpdateProgressImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String fileId,
    double progress,
    int bytesUploaded,
    int totalBytes,
  });
}

/// @nodoc
class __$$UpdateProgressImplCopyWithImpl<$Res>
    extends _$UploadEventCopyWithImpl<$Res, _$UpdateProgressImpl>
    implements _$$UpdateProgressImplCopyWith<$Res> {
  __$$UpdateProgressImplCopyWithImpl(
    _$UpdateProgressImpl _value,
    $Res Function(_$UpdateProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileId = null,
    Object? progress = null,
    Object? bytesUploaded = null,
    Object? totalBytes = null,
  }) {
    return _then(
      _$UpdateProgressImpl(
        fileId: null == fileId
            ? _value.fileId
            : fileId // ignore: cast_nullable_to_non_nullable
                  as String,
        progress: null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as double,
        bytesUploaded: null == bytesUploaded
            ? _value.bytesUploaded
            : bytesUploaded // ignore: cast_nullable_to_non_nullable
                  as int,
        totalBytes: null == totalBytes
            ? _value.totalBytes
            : totalBytes // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$UpdateProgressImpl implements UpdateProgress {
  const _$UpdateProgressImpl({
    required this.fileId,
    required this.progress,
    required this.bytesUploaded,
    required this.totalBytes,
  });

  @override
  final String fileId;
  @override
  final double progress;
  @override
  final int bytesUploaded;
  @override
  final int totalBytes;

  @override
  String toString() {
    return 'UploadEvent.updateProgress(fileId: $fileId, progress: $progress, bytesUploaded: $bytesUploaded, totalBytes: $totalBytes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateProgressImpl &&
            (identical(other.fileId, fileId) || other.fileId == fileId) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.bytesUploaded, bytesUploaded) ||
                other.bytesUploaded == bytesUploaded) &&
            (identical(other.totalBytes, totalBytes) ||
                other.totalBytes == totalBytes));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, fileId, progress, bytesUploaded, totalBytes);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateProgressImplCopyWith<_$UpdateProgressImpl> get copyWith =>
      __$$UpdateProgressImplCopyWithImpl<_$UpdateProgressImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )
    addFiles,
    required TResult Function(List<UploadFileModel> files) startUpload,
    required TResult Function(String? fileId) pauseUpload,
    required TResult Function(String? fileId) resumeUpload,
    required TResult Function(String? fileId) cancelUpload,
    required TResult Function(List<UploadFileModel> failedFiles) retryUpload,
    required TResult Function(String fileId) removeFile,
    required TResult Function() clearQueue,
    required TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )
    updateProgress,
    required TResult Function(
      String fileId,
      String downloadUrl,
      String? documentId,
    )
    fileCompleted,
    required TResult Function(String fileId, String error) fileFailed,
    required TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )
    updateSettings,
    required TResult Function(List<XFile> files) validateFiles,
    required TResult Function() resetState,
    required TResult Function(String categoryId) setCategory,
    required TResult Function(Map<String, String> metadata) setMetadata,
    required TResult Function() processQueue,
    required TResult Function() uploadCompleted,
    required TResult Function(String error) uploadError,
    required TResult Function(double progress) overallProgressUpdated,
    required TResult Function(String fileId, double progress)
    fileProgressUpdated,
    required TResult Function(String fileId, UploadStatus status)
    fileStatusUpdated,
    required TResult Function(List<UploadFileModel> files)
    startUploadWithProgress,
    required TResult Function() clearUploadState,
  }) {
    return updateProgress(fileId, progress, bytesUploaded, totalBytes);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult? Function(List<UploadFileModel> files)? startUpload,
    TResult? Function(String? fileId)? pauseUpload,
    TResult? Function(String? fileId)? resumeUpload,
    TResult? Function(String? fileId)? cancelUpload,
    TResult? Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult? Function(String fileId)? removeFile,
    TResult? Function()? clearQueue,
    TResult? Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult? Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult? Function(String fileId, String error)? fileFailed,
    TResult? Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult? Function(List<XFile> files)? validateFiles,
    TResult? Function()? resetState,
    TResult? Function(String categoryId)? setCategory,
    TResult? Function(Map<String, String> metadata)? setMetadata,
    TResult? Function()? processQueue,
    TResult? Function()? uploadCompleted,
    TResult? Function(String error)? uploadError,
    TResult? Function(double progress)? overallProgressUpdated,
    TResult? Function(String fileId, double progress)? fileProgressUpdated,
    TResult? Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult? Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult? Function()? clearUploadState,
  }) {
    return updateProgress?.call(fileId, progress, bytesUploaded, totalBytes);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult Function(List<UploadFileModel> files)? startUpload,
    TResult Function(String? fileId)? pauseUpload,
    TResult Function(String? fileId)? resumeUpload,
    TResult Function(String? fileId)? cancelUpload,
    TResult Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult Function(String fileId)? removeFile,
    TResult Function()? clearQueue,
    TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult Function(String fileId, String error)? fileFailed,
    TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult Function(List<XFile> files)? validateFiles,
    TResult Function()? resetState,
    TResult Function(String categoryId)? setCategory,
    TResult Function(Map<String, String> metadata)? setMetadata,
    TResult Function()? processQueue,
    TResult Function()? uploadCompleted,
    TResult Function(String error)? uploadError,
    TResult Function(double progress)? overallProgressUpdated,
    TResult Function(String fileId, double progress)? fileProgressUpdated,
    TResult Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult Function()? clearUploadState,
    required TResult orElse(),
  }) {
    if (updateProgress != null) {
      return updateProgress(fileId, progress, bytesUploaded, totalBytes);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddFiles value) addFiles,
    required TResult Function(StartUpload value) startUpload,
    required TResult Function(PauseUpload value) pauseUpload,
    required TResult Function(ResumeUpload value) resumeUpload,
    required TResult Function(CancelUpload value) cancelUpload,
    required TResult Function(RetryUpload value) retryUpload,
    required TResult Function(RemoveFile value) removeFile,
    required TResult Function(ClearQueue value) clearQueue,
    required TResult Function(UpdateProgress value) updateProgress,
    required TResult Function(FileCompleted value) fileCompleted,
    required TResult Function(FileFailed value) fileFailed,
    required TResult Function(UpdateSettings value) updateSettings,
    required TResult Function(ValidateFiles value) validateFiles,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SetCategory value) setCategory,
    required TResult Function(SetMetadata value) setMetadata,
    required TResult Function(ProcessQueue value) processQueue,
    required TResult Function(UploadCompleted value) uploadCompleted,
    required TResult Function(UploadError value) uploadError,
    required TResult Function(OverallProgressUpdated value)
    overallProgressUpdated,
    required TResult Function(FileProgressUpdated value) fileProgressUpdated,
    required TResult Function(FileStatusUpdated value) fileStatusUpdated,
    required TResult Function(StartUploadWithProgress value)
    startUploadWithProgress,
    required TResult Function(ClearUploadState value) clearUploadState,
  }) {
    return updateProgress(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddFiles value)? addFiles,
    TResult? Function(StartUpload value)? startUpload,
    TResult? Function(PauseUpload value)? pauseUpload,
    TResult? Function(ResumeUpload value)? resumeUpload,
    TResult? Function(CancelUpload value)? cancelUpload,
    TResult? Function(RetryUpload value)? retryUpload,
    TResult? Function(RemoveFile value)? removeFile,
    TResult? Function(ClearQueue value)? clearQueue,
    TResult? Function(UpdateProgress value)? updateProgress,
    TResult? Function(FileCompleted value)? fileCompleted,
    TResult? Function(FileFailed value)? fileFailed,
    TResult? Function(UpdateSettings value)? updateSettings,
    TResult? Function(ValidateFiles value)? validateFiles,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SetCategory value)? setCategory,
    TResult? Function(SetMetadata value)? setMetadata,
    TResult? Function(ProcessQueue value)? processQueue,
    TResult? Function(UploadCompleted value)? uploadCompleted,
    TResult? Function(UploadError value)? uploadError,
    TResult? Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult? Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult? Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult? Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult? Function(ClearUploadState value)? clearUploadState,
  }) {
    return updateProgress?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddFiles value)? addFiles,
    TResult Function(StartUpload value)? startUpload,
    TResult Function(PauseUpload value)? pauseUpload,
    TResult Function(ResumeUpload value)? resumeUpload,
    TResult Function(CancelUpload value)? cancelUpload,
    TResult Function(RetryUpload value)? retryUpload,
    TResult Function(RemoveFile value)? removeFile,
    TResult Function(ClearQueue value)? clearQueue,
    TResult Function(UpdateProgress value)? updateProgress,
    TResult Function(FileCompleted value)? fileCompleted,
    TResult Function(FileFailed value)? fileFailed,
    TResult Function(UpdateSettings value)? updateSettings,
    TResult Function(ValidateFiles value)? validateFiles,
    TResult Function(ResetState value)? resetState,
    TResult Function(SetCategory value)? setCategory,
    TResult Function(SetMetadata value)? setMetadata,
    TResult Function(ProcessQueue value)? processQueue,
    TResult Function(UploadCompleted value)? uploadCompleted,
    TResult Function(UploadError value)? uploadError,
    TResult Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult Function(ClearUploadState value)? clearUploadState,
    required TResult orElse(),
  }) {
    if (updateProgress != null) {
      return updateProgress(this);
    }
    return orElse();
  }
}

abstract class UpdateProgress implements UploadEvent {
  const factory UpdateProgress({
    required final String fileId,
    required final double progress,
    required final int bytesUploaded,
    required final int totalBytes,
  }) = _$UpdateProgressImpl;

  String get fileId;
  double get progress;
  int get bytesUploaded;
  int get totalBytes;

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateProgressImplCopyWith<_$UpdateProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FileCompletedImplCopyWith<$Res> {
  factory _$$FileCompletedImplCopyWith(
    _$FileCompletedImpl value,
    $Res Function(_$FileCompletedImpl) then,
  ) = __$$FileCompletedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String fileId, String downloadUrl, String? documentId});
}

/// @nodoc
class __$$FileCompletedImplCopyWithImpl<$Res>
    extends _$UploadEventCopyWithImpl<$Res, _$FileCompletedImpl>
    implements _$$FileCompletedImplCopyWith<$Res> {
  __$$FileCompletedImplCopyWithImpl(
    _$FileCompletedImpl _value,
    $Res Function(_$FileCompletedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileId = null,
    Object? downloadUrl = null,
    Object? documentId = freezed,
  }) {
    return _then(
      _$FileCompletedImpl(
        fileId: null == fileId
            ? _value.fileId
            : fileId // ignore: cast_nullable_to_non_nullable
                  as String,
        downloadUrl: null == downloadUrl
            ? _value.downloadUrl
            : downloadUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        documentId: freezed == documentId
            ? _value.documentId
            : documentId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$FileCompletedImpl implements FileCompleted {
  const _$FileCompletedImpl({
    required this.fileId,
    required this.downloadUrl,
    this.documentId,
  });

  @override
  final String fileId;
  @override
  final String downloadUrl;
  @override
  final String? documentId;

  @override
  String toString() {
    return 'UploadEvent.fileCompleted(fileId: $fileId, downloadUrl: $downloadUrl, documentId: $documentId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileCompletedImpl &&
            (identical(other.fileId, fileId) || other.fileId == fileId) &&
            (identical(other.downloadUrl, downloadUrl) ||
                other.downloadUrl == downloadUrl) &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fileId, downloadUrl, documentId);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileCompletedImplCopyWith<_$FileCompletedImpl> get copyWith =>
      __$$FileCompletedImplCopyWithImpl<_$FileCompletedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )
    addFiles,
    required TResult Function(List<UploadFileModel> files) startUpload,
    required TResult Function(String? fileId) pauseUpload,
    required TResult Function(String? fileId) resumeUpload,
    required TResult Function(String? fileId) cancelUpload,
    required TResult Function(List<UploadFileModel> failedFiles) retryUpload,
    required TResult Function(String fileId) removeFile,
    required TResult Function() clearQueue,
    required TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )
    updateProgress,
    required TResult Function(
      String fileId,
      String downloadUrl,
      String? documentId,
    )
    fileCompleted,
    required TResult Function(String fileId, String error) fileFailed,
    required TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )
    updateSettings,
    required TResult Function(List<XFile> files) validateFiles,
    required TResult Function() resetState,
    required TResult Function(String categoryId) setCategory,
    required TResult Function(Map<String, String> metadata) setMetadata,
    required TResult Function() processQueue,
    required TResult Function() uploadCompleted,
    required TResult Function(String error) uploadError,
    required TResult Function(double progress) overallProgressUpdated,
    required TResult Function(String fileId, double progress)
    fileProgressUpdated,
    required TResult Function(String fileId, UploadStatus status)
    fileStatusUpdated,
    required TResult Function(List<UploadFileModel> files)
    startUploadWithProgress,
    required TResult Function() clearUploadState,
  }) {
    return fileCompleted(fileId, downloadUrl, documentId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult? Function(List<UploadFileModel> files)? startUpload,
    TResult? Function(String? fileId)? pauseUpload,
    TResult? Function(String? fileId)? resumeUpload,
    TResult? Function(String? fileId)? cancelUpload,
    TResult? Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult? Function(String fileId)? removeFile,
    TResult? Function()? clearQueue,
    TResult? Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult? Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult? Function(String fileId, String error)? fileFailed,
    TResult? Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult? Function(List<XFile> files)? validateFiles,
    TResult? Function()? resetState,
    TResult? Function(String categoryId)? setCategory,
    TResult? Function(Map<String, String> metadata)? setMetadata,
    TResult? Function()? processQueue,
    TResult? Function()? uploadCompleted,
    TResult? Function(String error)? uploadError,
    TResult? Function(double progress)? overallProgressUpdated,
    TResult? Function(String fileId, double progress)? fileProgressUpdated,
    TResult? Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult? Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult? Function()? clearUploadState,
  }) {
    return fileCompleted?.call(fileId, downloadUrl, documentId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult Function(List<UploadFileModel> files)? startUpload,
    TResult Function(String? fileId)? pauseUpload,
    TResult Function(String? fileId)? resumeUpload,
    TResult Function(String? fileId)? cancelUpload,
    TResult Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult Function(String fileId)? removeFile,
    TResult Function()? clearQueue,
    TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult Function(String fileId, String error)? fileFailed,
    TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult Function(List<XFile> files)? validateFiles,
    TResult Function()? resetState,
    TResult Function(String categoryId)? setCategory,
    TResult Function(Map<String, String> metadata)? setMetadata,
    TResult Function()? processQueue,
    TResult Function()? uploadCompleted,
    TResult Function(String error)? uploadError,
    TResult Function(double progress)? overallProgressUpdated,
    TResult Function(String fileId, double progress)? fileProgressUpdated,
    TResult Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult Function()? clearUploadState,
    required TResult orElse(),
  }) {
    if (fileCompleted != null) {
      return fileCompleted(fileId, downloadUrl, documentId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddFiles value) addFiles,
    required TResult Function(StartUpload value) startUpload,
    required TResult Function(PauseUpload value) pauseUpload,
    required TResult Function(ResumeUpload value) resumeUpload,
    required TResult Function(CancelUpload value) cancelUpload,
    required TResult Function(RetryUpload value) retryUpload,
    required TResult Function(RemoveFile value) removeFile,
    required TResult Function(ClearQueue value) clearQueue,
    required TResult Function(UpdateProgress value) updateProgress,
    required TResult Function(FileCompleted value) fileCompleted,
    required TResult Function(FileFailed value) fileFailed,
    required TResult Function(UpdateSettings value) updateSettings,
    required TResult Function(ValidateFiles value) validateFiles,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SetCategory value) setCategory,
    required TResult Function(SetMetadata value) setMetadata,
    required TResult Function(ProcessQueue value) processQueue,
    required TResult Function(UploadCompleted value) uploadCompleted,
    required TResult Function(UploadError value) uploadError,
    required TResult Function(OverallProgressUpdated value)
    overallProgressUpdated,
    required TResult Function(FileProgressUpdated value) fileProgressUpdated,
    required TResult Function(FileStatusUpdated value) fileStatusUpdated,
    required TResult Function(StartUploadWithProgress value)
    startUploadWithProgress,
    required TResult Function(ClearUploadState value) clearUploadState,
  }) {
    return fileCompleted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddFiles value)? addFiles,
    TResult? Function(StartUpload value)? startUpload,
    TResult? Function(PauseUpload value)? pauseUpload,
    TResult? Function(ResumeUpload value)? resumeUpload,
    TResult? Function(CancelUpload value)? cancelUpload,
    TResult? Function(RetryUpload value)? retryUpload,
    TResult? Function(RemoveFile value)? removeFile,
    TResult? Function(ClearQueue value)? clearQueue,
    TResult? Function(UpdateProgress value)? updateProgress,
    TResult? Function(FileCompleted value)? fileCompleted,
    TResult? Function(FileFailed value)? fileFailed,
    TResult? Function(UpdateSettings value)? updateSettings,
    TResult? Function(ValidateFiles value)? validateFiles,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SetCategory value)? setCategory,
    TResult? Function(SetMetadata value)? setMetadata,
    TResult? Function(ProcessQueue value)? processQueue,
    TResult? Function(UploadCompleted value)? uploadCompleted,
    TResult? Function(UploadError value)? uploadError,
    TResult? Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult? Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult? Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult? Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult? Function(ClearUploadState value)? clearUploadState,
  }) {
    return fileCompleted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddFiles value)? addFiles,
    TResult Function(StartUpload value)? startUpload,
    TResult Function(PauseUpload value)? pauseUpload,
    TResult Function(ResumeUpload value)? resumeUpload,
    TResult Function(CancelUpload value)? cancelUpload,
    TResult Function(RetryUpload value)? retryUpload,
    TResult Function(RemoveFile value)? removeFile,
    TResult Function(ClearQueue value)? clearQueue,
    TResult Function(UpdateProgress value)? updateProgress,
    TResult Function(FileCompleted value)? fileCompleted,
    TResult Function(FileFailed value)? fileFailed,
    TResult Function(UpdateSettings value)? updateSettings,
    TResult Function(ValidateFiles value)? validateFiles,
    TResult Function(ResetState value)? resetState,
    TResult Function(SetCategory value)? setCategory,
    TResult Function(SetMetadata value)? setMetadata,
    TResult Function(ProcessQueue value)? processQueue,
    TResult Function(UploadCompleted value)? uploadCompleted,
    TResult Function(UploadError value)? uploadError,
    TResult Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult Function(ClearUploadState value)? clearUploadState,
    required TResult orElse(),
  }) {
    if (fileCompleted != null) {
      return fileCompleted(this);
    }
    return orElse();
  }
}

abstract class FileCompleted implements UploadEvent {
  const factory FileCompleted({
    required final String fileId,
    required final String downloadUrl,
    final String? documentId,
  }) = _$FileCompletedImpl;

  String get fileId;
  String get downloadUrl;
  String? get documentId;

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileCompletedImplCopyWith<_$FileCompletedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FileFailedImplCopyWith<$Res> {
  factory _$$FileFailedImplCopyWith(
    _$FileFailedImpl value,
    $Res Function(_$FileFailedImpl) then,
  ) = __$$FileFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String fileId, String error});
}

/// @nodoc
class __$$FileFailedImplCopyWithImpl<$Res>
    extends _$UploadEventCopyWithImpl<$Res, _$FileFailedImpl>
    implements _$$FileFailedImplCopyWith<$Res> {
  __$$FileFailedImplCopyWithImpl(
    _$FileFailedImpl _value,
    $Res Function(_$FileFailedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? fileId = null, Object? error = null}) {
    return _then(
      _$FileFailedImpl(
        fileId: null == fileId
            ? _value.fileId
            : fileId // ignore: cast_nullable_to_non_nullable
                  as String,
        error: null == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$FileFailedImpl implements FileFailed {
  const _$FileFailedImpl({required this.fileId, required this.error});

  @override
  final String fileId;
  @override
  final String error;

  @override
  String toString() {
    return 'UploadEvent.fileFailed(fileId: $fileId, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileFailedImpl &&
            (identical(other.fileId, fileId) || other.fileId == fileId) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fileId, error);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileFailedImplCopyWith<_$FileFailedImpl> get copyWith =>
      __$$FileFailedImplCopyWithImpl<_$FileFailedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )
    addFiles,
    required TResult Function(List<UploadFileModel> files) startUpload,
    required TResult Function(String? fileId) pauseUpload,
    required TResult Function(String? fileId) resumeUpload,
    required TResult Function(String? fileId) cancelUpload,
    required TResult Function(List<UploadFileModel> failedFiles) retryUpload,
    required TResult Function(String fileId) removeFile,
    required TResult Function() clearQueue,
    required TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )
    updateProgress,
    required TResult Function(
      String fileId,
      String downloadUrl,
      String? documentId,
    )
    fileCompleted,
    required TResult Function(String fileId, String error) fileFailed,
    required TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )
    updateSettings,
    required TResult Function(List<XFile> files) validateFiles,
    required TResult Function() resetState,
    required TResult Function(String categoryId) setCategory,
    required TResult Function(Map<String, String> metadata) setMetadata,
    required TResult Function() processQueue,
    required TResult Function() uploadCompleted,
    required TResult Function(String error) uploadError,
    required TResult Function(double progress) overallProgressUpdated,
    required TResult Function(String fileId, double progress)
    fileProgressUpdated,
    required TResult Function(String fileId, UploadStatus status)
    fileStatusUpdated,
    required TResult Function(List<UploadFileModel> files)
    startUploadWithProgress,
    required TResult Function() clearUploadState,
  }) {
    return fileFailed(fileId, error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult? Function(List<UploadFileModel> files)? startUpload,
    TResult? Function(String? fileId)? pauseUpload,
    TResult? Function(String? fileId)? resumeUpload,
    TResult? Function(String? fileId)? cancelUpload,
    TResult? Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult? Function(String fileId)? removeFile,
    TResult? Function()? clearQueue,
    TResult? Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult? Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult? Function(String fileId, String error)? fileFailed,
    TResult? Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult? Function(List<XFile> files)? validateFiles,
    TResult? Function()? resetState,
    TResult? Function(String categoryId)? setCategory,
    TResult? Function(Map<String, String> metadata)? setMetadata,
    TResult? Function()? processQueue,
    TResult? Function()? uploadCompleted,
    TResult? Function(String error)? uploadError,
    TResult? Function(double progress)? overallProgressUpdated,
    TResult? Function(String fileId, double progress)? fileProgressUpdated,
    TResult? Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult? Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult? Function()? clearUploadState,
  }) {
    return fileFailed?.call(fileId, error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult Function(List<UploadFileModel> files)? startUpload,
    TResult Function(String? fileId)? pauseUpload,
    TResult Function(String? fileId)? resumeUpload,
    TResult Function(String? fileId)? cancelUpload,
    TResult Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult Function(String fileId)? removeFile,
    TResult Function()? clearQueue,
    TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult Function(String fileId, String error)? fileFailed,
    TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult Function(List<XFile> files)? validateFiles,
    TResult Function()? resetState,
    TResult Function(String categoryId)? setCategory,
    TResult Function(Map<String, String> metadata)? setMetadata,
    TResult Function()? processQueue,
    TResult Function()? uploadCompleted,
    TResult Function(String error)? uploadError,
    TResult Function(double progress)? overallProgressUpdated,
    TResult Function(String fileId, double progress)? fileProgressUpdated,
    TResult Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult Function()? clearUploadState,
    required TResult orElse(),
  }) {
    if (fileFailed != null) {
      return fileFailed(fileId, error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddFiles value) addFiles,
    required TResult Function(StartUpload value) startUpload,
    required TResult Function(PauseUpload value) pauseUpload,
    required TResult Function(ResumeUpload value) resumeUpload,
    required TResult Function(CancelUpload value) cancelUpload,
    required TResult Function(RetryUpload value) retryUpload,
    required TResult Function(RemoveFile value) removeFile,
    required TResult Function(ClearQueue value) clearQueue,
    required TResult Function(UpdateProgress value) updateProgress,
    required TResult Function(FileCompleted value) fileCompleted,
    required TResult Function(FileFailed value) fileFailed,
    required TResult Function(UpdateSettings value) updateSettings,
    required TResult Function(ValidateFiles value) validateFiles,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SetCategory value) setCategory,
    required TResult Function(SetMetadata value) setMetadata,
    required TResult Function(ProcessQueue value) processQueue,
    required TResult Function(UploadCompleted value) uploadCompleted,
    required TResult Function(UploadError value) uploadError,
    required TResult Function(OverallProgressUpdated value)
    overallProgressUpdated,
    required TResult Function(FileProgressUpdated value) fileProgressUpdated,
    required TResult Function(FileStatusUpdated value) fileStatusUpdated,
    required TResult Function(StartUploadWithProgress value)
    startUploadWithProgress,
    required TResult Function(ClearUploadState value) clearUploadState,
  }) {
    return fileFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddFiles value)? addFiles,
    TResult? Function(StartUpload value)? startUpload,
    TResult? Function(PauseUpload value)? pauseUpload,
    TResult? Function(ResumeUpload value)? resumeUpload,
    TResult? Function(CancelUpload value)? cancelUpload,
    TResult? Function(RetryUpload value)? retryUpload,
    TResult? Function(RemoveFile value)? removeFile,
    TResult? Function(ClearQueue value)? clearQueue,
    TResult? Function(UpdateProgress value)? updateProgress,
    TResult? Function(FileCompleted value)? fileCompleted,
    TResult? Function(FileFailed value)? fileFailed,
    TResult? Function(UpdateSettings value)? updateSettings,
    TResult? Function(ValidateFiles value)? validateFiles,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SetCategory value)? setCategory,
    TResult? Function(SetMetadata value)? setMetadata,
    TResult? Function(ProcessQueue value)? processQueue,
    TResult? Function(UploadCompleted value)? uploadCompleted,
    TResult? Function(UploadError value)? uploadError,
    TResult? Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult? Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult? Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult? Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult? Function(ClearUploadState value)? clearUploadState,
  }) {
    return fileFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddFiles value)? addFiles,
    TResult Function(StartUpload value)? startUpload,
    TResult Function(PauseUpload value)? pauseUpload,
    TResult Function(ResumeUpload value)? resumeUpload,
    TResult Function(CancelUpload value)? cancelUpload,
    TResult Function(RetryUpload value)? retryUpload,
    TResult Function(RemoveFile value)? removeFile,
    TResult Function(ClearQueue value)? clearQueue,
    TResult Function(UpdateProgress value)? updateProgress,
    TResult Function(FileCompleted value)? fileCompleted,
    TResult Function(FileFailed value)? fileFailed,
    TResult Function(UpdateSettings value)? updateSettings,
    TResult Function(ValidateFiles value)? validateFiles,
    TResult Function(ResetState value)? resetState,
    TResult Function(SetCategory value)? setCategory,
    TResult Function(SetMetadata value)? setMetadata,
    TResult Function(ProcessQueue value)? processQueue,
    TResult Function(UploadCompleted value)? uploadCompleted,
    TResult Function(UploadError value)? uploadError,
    TResult Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult Function(ClearUploadState value)? clearUploadState,
    required TResult orElse(),
  }) {
    if (fileFailed != null) {
      return fileFailed(this);
    }
    return orElse();
  }
}

abstract class FileFailed implements UploadEvent {
  const factory FileFailed({
    required final String fileId,
    required final String error,
  }) = _$FileFailedImpl;

  String get fileId;
  String get error;

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileFailedImplCopyWith<_$FileFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateSettingsImplCopyWith<$Res> {
  factory _$$UpdateSettingsImplCopyWith(
    _$UpdateSettingsImpl value,
    $Res Function(_$UpdateSettingsImpl) then,
  ) = __$$UpdateSettingsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int? maxConcurrentUploads, int? chunkSize, int? retryAttempts});
}

/// @nodoc
class __$$UpdateSettingsImplCopyWithImpl<$Res>
    extends _$UploadEventCopyWithImpl<$Res, _$UpdateSettingsImpl>
    implements _$$UpdateSettingsImplCopyWith<$Res> {
  __$$UpdateSettingsImplCopyWithImpl(
    _$UpdateSettingsImpl _value,
    $Res Function(_$UpdateSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxConcurrentUploads = freezed,
    Object? chunkSize = freezed,
    Object? retryAttempts = freezed,
  }) {
    return _then(
      _$UpdateSettingsImpl(
        maxConcurrentUploads: freezed == maxConcurrentUploads
            ? _value.maxConcurrentUploads
            : maxConcurrentUploads // ignore: cast_nullable_to_non_nullable
                  as int?,
        chunkSize: freezed == chunkSize
            ? _value.chunkSize
            : chunkSize // ignore: cast_nullable_to_non_nullable
                  as int?,
        retryAttempts: freezed == retryAttempts
            ? _value.retryAttempts
            : retryAttempts // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$UpdateSettingsImpl implements UpdateSettings {
  const _$UpdateSettingsImpl({
    this.maxConcurrentUploads,
    this.chunkSize,
    this.retryAttempts,
  });

  @override
  final int? maxConcurrentUploads;
  @override
  final int? chunkSize;
  @override
  final int? retryAttempts;

  @override
  String toString() {
    return 'UploadEvent.updateSettings(maxConcurrentUploads: $maxConcurrentUploads, chunkSize: $chunkSize, retryAttempts: $retryAttempts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateSettingsImpl &&
            (identical(other.maxConcurrentUploads, maxConcurrentUploads) ||
                other.maxConcurrentUploads == maxConcurrentUploads) &&
            (identical(other.chunkSize, chunkSize) ||
                other.chunkSize == chunkSize) &&
            (identical(other.retryAttempts, retryAttempts) ||
                other.retryAttempts == retryAttempts));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, maxConcurrentUploads, chunkSize, retryAttempts);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateSettingsImplCopyWith<_$UpdateSettingsImpl> get copyWith =>
      __$$UpdateSettingsImplCopyWithImpl<_$UpdateSettingsImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )
    addFiles,
    required TResult Function(List<UploadFileModel> files) startUpload,
    required TResult Function(String? fileId) pauseUpload,
    required TResult Function(String? fileId) resumeUpload,
    required TResult Function(String? fileId) cancelUpload,
    required TResult Function(List<UploadFileModel> failedFiles) retryUpload,
    required TResult Function(String fileId) removeFile,
    required TResult Function() clearQueue,
    required TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )
    updateProgress,
    required TResult Function(
      String fileId,
      String downloadUrl,
      String? documentId,
    )
    fileCompleted,
    required TResult Function(String fileId, String error) fileFailed,
    required TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )
    updateSettings,
    required TResult Function(List<XFile> files) validateFiles,
    required TResult Function() resetState,
    required TResult Function(String categoryId) setCategory,
    required TResult Function(Map<String, String> metadata) setMetadata,
    required TResult Function() processQueue,
    required TResult Function() uploadCompleted,
    required TResult Function(String error) uploadError,
    required TResult Function(double progress) overallProgressUpdated,
    required TResult Function(String fileId, double progress)
    fileProgressUpdated,
    required TResult Function(String fileId, UploadStatus status)
    fileStatusUpdated,
    required TResult Function(List<UploadFileModel> files)
    startUploadWithProgress,
    required TResult Function() clearUploadState,
  }) {
    return updateSettings(maxConcurrentUploads, chunkSize, retryAttempts);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult? Function(List<UploadFileModel> files)? startUpload,
    TResult? Function(String? fileId)? pauseUpload,
    TResult? Function(String? fileId)? resumeUpload,
    TResult? Function(String? fileId)? cancelUpload,
    TResult? Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult? Function(String fileId)? removeFile,
    TResult? Function()? clearQueue,
    TResult? Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult? Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult? Function(String fileId, String error)? fileFailed,
    TResult? Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult? Function(List<XFile> files)? validateFiles,
    TResult? Function()? resetState,
    TResult? Function(String categoryId)? setCategory,
    TResult? Function(Map<String, String> metadata)? setMetadata,
    TResult? Function()? processQueue,
    TResult? Function()? uploadCompleted,
    TResult? Function(String error)? uploadError,
    TResult? Function(double progress)? overallProgressUpdated,
    TResult? Function(String fileId, double progress)? fileProgressUpdated,
    TResult? Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult? Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult? Function()? clearUploadState,
  }) {
    return updateSettings?.call(maxConcurrentUploads, chunkSize, retryAttempts);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult Function(List<UploadFileModel> files)? startUpload,
    TResult Function(String? fileId)? pauseUpload,
    TResult Function(String? fileId)? resumeUpload,
    TResult Function(String? fileId)? cancelUpload,
    TResult Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult Function(String fileId)? removeFile,
    TResult Function()? clearQueue,
    TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult Function(String fileId, String error)? fileFailed,
    TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult Function(List<XFile> files)? validateFiles,
    TResult Function()? resetState,
    TResult Function(String categoryId)? setCategory,
    TResult Function(Map<String, String> metadata)? setMetadata,
    TResult Function()? processQueue,
    TResult Function()? uploadCompleted,
    TResult Function(String error)? uploadError,
    TResult Function(double progress)? overallProgressUpdated,
    TResult Function(String fileId, double progress)? fileProgressUpdated,
    TResult Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult Function()? clearUploadState,
    required TResult orElse(),
  }) {
    if (updateSettings != null) {
      return updateSettings(maxConcurrentUploads, chunkSize, retryAttempts);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddFiles value) addFiles,
    required TResult Function(StartUpload value) startUpload,
    required TResult Function(PauseUpload value) pauseUpload,
    required TResult Function(ResumeUpload value) resumeUpload,
    required TResult Function(CancelUpload value) cancelUpload,
    required TResult Function(RetryUpload value) retryUpload,
    required TResult Function(RemoveFile value) removeFile,
    required TResult Function(ClearQueue value) clearQueue,
    required TResult Function(UpdateProgress value) updateProgress,
    required TResult Function(FileCompleted value) fileCompleted,
    required TResult Function(FileFailed value) fileFailed,
    required TResult Function(UpdateSettings value) updateSettings,
    required TResult Function(ValidateFiles value) validateFiles,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SetCategory value) setCategory,
    required TResult Function(SetMetadata value) setMetadata,
    required TResult Function(ProcessQueue value) processQueue,
    required TResult Function(UploadCompleted value) uploadCompleted,
    required TResult Function(UploadError value) uploadError,
    required TResult Function(OverallProgressUpdated value)
    overallProgressUpdated,
    required TResult Function(FileProgressUpdated value) fileProgressUpdated,
    required TResult Function(FileStatusUpdated value) fileStatusUpdated,
    required TResult Function(StartUploadWithProgress value)
    startUploadWithProgress,
    required TResult Function(ClearUploadState value) clearUploadState,
  }) {
    return updateSettings(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddFiles value)? addFiles,
    TResult? Function(StartUpload value)? startUpload,
    TResult? Function(PauseUpload value)? pauseUpload,
    TResult? Function(ResumeUpload value)? resumeUpload,
    TResult? Function(CancelUpload value)? cancelUpload,
    TResult? Function(RetryUpload value)? retryUpload,
    TResult? Function(RemoveFile value)? removeFile,
    TResult? Function(ClearQueue value)? clearQueue,
    TResult? Function(UpdateProgress value)? updateProgress,
    TResult? Function(FileCompleted value)? fileCompleted,
    TResult? Function(FileFailed value)? fileFailed,
    TResult? Function(UpdateSettings value)? updateSettings,
    TResult? Function(ValidateFiles value)? validateFiles,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SetCategory value)? setCategory,
    TResult? Function(SetMetadata value)? setMetadata,
    TResult? Function(ProcessQueue value)? processQueue,
    TResult? Function(UploadCompleted value)? uploadCompleted,
    TResult? Function(UploadError value)? uploadError,
    TResult? Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult? Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult? Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult? Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult? Function(ClearUploadState value)? clearUploadState,
  }) {
    return updateSettings?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddFiles value)? addFiles,
    TResult Function(StartUpload value)? startUpload,
    TResult Function(PauseUpload value)? pauseUpload,
    TResult Function(ResumeUpload value)? resumeUpload,
    TResult Function(CancelUpload value)? cancelUpload,
    TResult Function(RetryUpload value)? retryUpload,
    TResult Function(RemoveFile value)? removeFile,
    TResult Function(ClearQueue value)? clearQueue,
    TResult Function(UpdateProgress value)? updateProgress,
    TResult Function(FileCompleted value)? fileCompleted,
    TResult Function(FileFailed value)? fileFailed,
    TResult Function(UpdateSettings value)? updateSettings,
    TResult Function(ValidateFiles value)? validateFiles,
    TResult Function(ResetState value)? resetState,
    TResult Function(SetCategory value)? setCategory,
    TResult Function(SetMetadata value)? setMetadata,
    TResult Function(ProcessQueue value)? processQueue,
    TResult Function(UploadCompleted value)? uploadCompleted,
    TResult Function(UploadError value)? uploadError,
    TResult Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult Function(ClearUploadState value)? clearUploadState,
    required TResult orElse(),
  }) {
    if (updateSettings != null) {
      return updateSettings(this);
    }
    return orElse();
  }
}

abstract class UpdateSettings implements UploadEvent {
  const factory UpdateSettings({
    final int? maxConcurrentUploads,
    final int? chunkSize,
    final int? retryAttempts,
  }) = _$UpdateSettingsImpl;

  int? get maxConcurrentUploads;
  int? get chunkSize;
  int? get retryAttempts;

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateSettingsImplCopyWith<_$UpdateSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ValidateFilesImplCopyWith<$Res> {
  factory _$$ValidateFilesImplCopyWith(
    _$ValidateFilesImpl value,
    $Res Function(_$ValidateFilesImpl) then,
  ) = __$$ValidateFilesImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<XFile> files});
}

/// @nodoc
class __$$ValidateFilesImplCopyWithImpl<$Res>
    extends _$UploadEventCopyWithImpl<$Res, _$ValidateFilesImpl>
    implements _$$ValidateFilesImplCopyWith<$Res> {
  __$$ValidateFilesImplCopyWithImpl(
    _$ValidateFilesImpl _value,
    $Res Function(_$ValidateFilesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? files = null}) {
    return _then(
      _$ValidateFilesImpl(
        files: null == files
            ? _value._files
            : files // ignore: cast_nullable_to_non_nullable
                  as List<XFile>,
      ),
    );
  }
}

/// @nodoc

class _$ValidateFilesImpl implements ValidateFiles {
  const _$ValidateFilesImpl({required final List<XFile> files})
    : _files = files;

  final List<XFile> _files;
  @override
  List<XFile> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  @override
  String toString() {
    return 'UploadEvent.validateFiles(files: $files)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidateFilesImpl &&
            const DeepCollectionEquality().equals(other._files, _files));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_files));

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidateFilesImplCopyWith<_$ValidateFilesImpl> get copyWith =>
      __$$ValidateFilesImplCopyWithImpl<_$ValidateFilesImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )
    addFiles,
    required TResult Function(List<UploadFileModel> files) startUpload,
    required TResult Function(String? fileId) pauseUpload,
    required TResult Function(String? fileId) resumeUpload,
    required TResult Function(String? fileId) cancelUpload,
    required TResult Function(List<UploadFileModel> failedFiles) retryUpload,
    required TResult Function(String fileId) removeFile,
    required TResult Function() clearQueue,
    required TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )
    updateProgress,
    required TResult Function(
      String fileId,
      String downloadUrl,
      String? documentId,
    )
    fileCompleted,
    required TResult Function(String fileId, String error) fileFailed,
    required TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )
    updateSettings,
    required TResult Function(List<XFile> files) validateFiles,
    required TResult Function() resetState,
    required TResult Function(String categoryId) setCategory,
    required TResult Function(Map<String, String> metadata) setMetadata,
    required TResult Function() processQueue,
    required TResult Function() uploadCompleted,
    required TResult Function(String error) uploadError,
    required TResult Function(double progress) overallProgressUpdated,
    required TResult Function(String fileId, double progress)
    fileProgressUpdated,
    required TResult Function(String fileId, UploadStatus status)
    fileStatusUpdated,
    required TResult Function(List<UploadFileModel> files)
    startUploadWithProgress,
    required TResult Function() clearUploadState,
  }) {
    return validateFiles(files);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult? Function(List<UploadFileModel> files)? startUpload,
    TResult? Function(String? fileId)? pauseUpload,
    TResult? Function(String? fileId)? resumeUpload,
    TResult? Function(String? fileId)? cancelUpload,
    TResult? Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult? Function(String fileId)? removeFile,
    TResult? Function()? clearQueue,
    TResult? Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult? Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult? Function(String fileId, String error)? fileFailed,
    TResult? Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult? Function(List<XFile> files)? validateFiles,
    TResult? Function()? resetState,
    TResult? Function(String categoryId)? setCategory,
    TResult? Function(Map<String, String> metadata)? setMetadata,
    TResult? Function()? processQueue,
    TResult? Function()? uploadCompleted,
    TResult? Function(String error)? uploadError,
    TResult? Function(double progress)? overallProgressUpdated,
    TResult? Function(String fileId, double progress)? fileProgressUpdated,
    TResult? Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult? Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult? Function()? clearUploadState,
  }) {
    return validateFiles?.call(files);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult Function(List<UploadFileModel> files)? startUpload,
    TResult Function(String? fileId)? pauseUpload,
    TResult Function(String? fileId)? resumeUpload,
    TResult Function(String? fileId)? cancelUpload,
    TResult Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult Function(String fileId)? removeFile,
    TResult Function()? clearQueue,
    TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult Function(String fileId, String error)? fileFailed,
    TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult Function(List<XFile> files)? validateFiles,
    TResult Function()? resetState,
    TResult Function(String categoryId)? setCategory,
    TResult Function(Map<String, String> metadata)? setMetadata,
    TResult Function()? processQueue,
    TResult Function()? uploadCompleted,
    TResult Function(String error)? uploadError,
    TResult Function(double progress)? overallProgressUpdated,
    TResult Function(String fileId, double progress)? fileProgressUpdated,
    TResult Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult Function()? clearUploadState,
    required TResult orElse(),
  }) {
    if (validateFiles != null) {
      return validateFiles(files);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddFiles value) addFiles,
    required TResult Function(StartUpload value) startUpload,
    required TResult Function(PauseUpload value) pauseUpload,
    required TResult Function(ResumeUpload value) resumeUpload,
    required TResult Function(CancelUpload value) cancelUpload,
    required TResult Function(RetryUpload value) retryUpload,
    required TResult Function(RemoveFile value) removeFile,
    required TResult Function(ClearQueue value) clearQueue,
    required TResult Function(UpdateProgress value) updateProgress,
    required TResult Function(FileCompleted value) fileCompleted,
    required TResult Function(FileFailed value) fileFailed,
    required TResult Function(UpdateSettings value) updateSettings,
    required TResult Function(ValidateFiles value) validateFiles,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SetCategory value) setCategory,
    required TResult Function(SetMetadata value) setMetadata,
    required TResult Function(ProcessQueue value) processQueue,
    required TResult Function(UploadCompleted value) uploadCompleted,
    required TResult Function(UploadError value) uploadError,
    required TResult Function(OverallProgressUpdated value)
    overallProgressUpdated,
    required TResult Function(FileProgressUpdated value) fileProgressUpdated,
    required TResult Function(FileStatusUpdated value) fileStatusUpdated,
    required TResult Function(StartUploadWithProgress value)
    startUploadWithProgress,
    required TResult Function(ClearUploadState value) clearUploadState,
  }) {
    return validateFiles(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddFiles value)? addFiles,
    TResult? Function(StartUpload value)? startUpload,
    TResult? Function(PauseUpload value)? pauseUpload,
    TResult? Function(ResumeUpload value)? resumeUpload,
    TResult? Function(CancelUpload value)? cancelUpload,
    TResult? Function(RetryUpload value)? retryUpload,
    TResult? Function(RemoveFile value)? removeFile,
    TResult? Function(ClearQueue value)? clearQueue,
    TResult? Function(UpdateProgress value)? updateProgress,
    TResult? Function(FileCompleted value)? fileCompleted,
    TResult? Function(FileFailed value)? fileFailed,
    TResult? Function(UpdateSettings value)? updateSettings,
    TResult? Function(ValidateFiles value)? validateFiles,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SetCategory value)? setCategory,
    TResult? Function(SetMetadata value)? setMetadata,
    TResult? Function(ProcessQueue value)? processQueue,
    TResult? Function(UploadCompleted value)? uploadCompleted,
    TResult? Function(UploadError value)? uploadError,
    TResult? Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult? Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult? Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult? Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult? Function(ClearUploadState value)? clearUploadState,
  }) {
    return validateFiles?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddFiles value)? addFiles,
    TResult Function(StartUpload value)? startUpload,
    TResult Function(PauseUpload value)? pauseUpload,
    TResult Function(ResumeUpload value)? resumeUpload,
    TResult Function(CancelUpload value)? cancelUpload,
    TResult Function(RetryUpload value)? retryUpload,
    TResult Function(RemoveFile value)? removeFile,
    TResult Function(ClearQueue value)? clearQueue,
    TResult Function(UpdateProgress value)? updateProgress,
    TResult Function(FileCompleted value)? fileCompleted,
    TResult Function(FileFailed value)? fileFailed,
    TResult Function(UpdateSettings value)? updateSettings,
    TResult Function(ValidateFiles value)? validateFiles,
    TResult Function(ResetState value)? resetState,
    TResult Function(SetCategory value)? setCategory,
    TResult Function(SetMetadata value)? setMetadata,
    TResult Function(ProcessQueue value)? processQueue,
    TResult Function(UploadCompleted value)? uploadCompleted,
    TResult Function(UploadError value)? uploadError,
    TResult Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult Function(ClearUploadState value)? clearUploadState,
    required TResult orElse(),
  }) {
    if (validateFiles != null) {
      return validateFiles(this);
    }
    return orElse();
  }
}

abstract class ValidateFiles implements UploadEvent {
  const factory ValidateFiles({required final List<XFile> files}) =
      _$ValidateFilesImpl;

  List<XFile> get files;

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidateFilesImplCopyWith<_$ValidateFilesImpl> get copyWith =>
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
    extends _$UploadEventCopyWithImpl<$Res, _$ResetStateImpl>
    implements _$$ResetStateImplCopyWith<$Res> {
  __$$ResetStateImplCopyWithImpl(
    _$ResetStateImpl _value,
    $Res Function(_$ResetStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ResetStateImpl implements ResetState {
  const _$ResetStateImpl();

  @override
  String toString() {
    return 'UploadEvent.resetState()';
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
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )
    addFiles,
    required TResult Function(List<UploadFileModel> files) startUpload,
    required TResult Function(String? fileId) pauseUpload,
    required TResult Function(String? fileId) resumeUpload,
    required TResult Function(String? fileId) cancelUpload,
    required TResult Function(List<UploadFileModel> failedFiles) retryUpload,
    required TResult Function(String fileId) removeFile,
    required TResult Function() clearQueue,
    required TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )
    updateProgress,
    required TResult Function(
      String fileId,
      String downloadUrl,
      String? documentId,
    )
    fileCompleted,
    required TResult Function(String fileId, String error) fileFailed,
    required TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )
    updateSettings,
    required TResult Function(List<XFile> files) validateFiles,
    required TResult Function() resetState,
    required TResult Function(String categoryId) setCategory,
    required TResult Function(Map<String, String> metadata) setMetadata,
    required TResult Function() processQueue,
    required TResult Function() uploadCompleted,
    required TResult Function(String error) uploadError,
    required TResult Function(double progress) overallProgressUpdated,
    required TResult Function(String fileId, double progress)
    fileProgressUpdated,
    required TResult Function(String fileId, UploadStatus status)
    fileStatusUpdated,
    required TResult Function(List<UploadFileModel> files)
    startUploadWithProgress,
    required TResult Function() clearUploadState,
  }) {
    return resetState();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult? Function(List<UploadFileModel> files)? startUpload,
    TResult? Function(String? fileId)? pauseUpload,
    TResult? Function(String? fileId)? resumeUpload,
    TResult? Function(String? fileId)? cancelUpload,
    TResult? Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult? Function(String fileId)? removeFile,
    TResult? Function()? clearQueue,
    TResult? Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult? Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult? Function(String fileId, String error)? fileFailed,
    TResult? Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult? Function(List<XFile> files)? validateFiles,
    TResult? Function()? resetState,
    TResult? Function(String categoryId)? setCategory,
    TResult? Function(Map<String, String> metadata)? setMetadata,
    TResult? Function()? processQueue,
    TResult? Function()? uploadCompleted,
    TResult? Function(String error)? uploadError,
    TResult? Function(double progress)? overallProgressUpdated,
    TResult? Function(String fileId, double progress)? fileProgressUpdated,
    TResult? Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult? Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult? Function()? clearUploadState,
  }) {
    return resetState?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult Function(List<UploadFileModel> files)? startUpload,
    TResult Function(String? fileId)? pauseUpload,
    TResult Function(String? fileId)? resumeUpload,
    TResult Function(String? fileId)? cancelUpload,
    TResult Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult Function(String fileId)? removeFile,
    TResult Function()? clearQueue,
    TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult Function(String fileId, String error)? fileFailed,
    TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult Function(List<XFile> files)? validateFiles,
    TResult Function()? resetState,
    TResult Function(String categoryId)? setCategory,
    TResult Function(Map<String, String> metadata)? setMetadata,
    TResult Function()? processQueue,
    TResult Function()? uploadCompleted,
    TResult Function(String error)? uploadError,
    TResult Function(double progress)? overallProgressUpdated,
    TResult Function(String fileId, double progress)? fileProgressUpdated,
    TResult Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult Function()? clearUploadState,
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
    required TResult Function(AddFiles value) addFiles,
    required TResult Function(StartUpload value) startUpload,
    required TResult Function(PauseUpload value) pauseUpload,
    required TResult Function(ResumeUpload value) resumeUpload,
    required TResult Function(CancelUpload value) cancelUpload,
    required TResult Function(RetryUpload value) retryUpload,
    required TResult Function(RemoveFile value) removeFile,
    required TResult Function(ClearQueue value) clearQueue,
    required TResult Function(UpdateProgress value) updateProgress,
    required TResult Function(FileCompleted value) fileCompleted,
    required TResult Function(FileFailed value) fileFailed,
    required TResult Function(UpdateSettings value) updateSettings,
    required TResult Function(ValidateFiles value) validateFiles,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SetCategory value) setCategory,
    required TResult Function(SetMetadata value) setMetadata,
    required TResult Function(ProcessQueue value) processQueue,
    required TResult Function(UploadCompleted value) uploadCompleted,
    required TResult Function(UploadError value) uploadError,
    required TResult Function(OverallProgressUpdated value)
    overallProgressUpdated,
    required TResult Function(FileProgressUpdated value) fileProgressUpdated,
    required TResult Function(FileStatusUpdated value) fileStatusUpdated,
    required TResult Function(StartUploadWithProgress value)
    startUploadWithProgress,
    required TResult Function(ClearUploadState value) clearUploadState,
  }) {
    return resetState(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddFiles value)? addFiles,
    TResult? Function(StartUpload value)? startUpload,
    TResult? Function(PauseUpload value)? pauseUpload,
    TResult? Function(ResumeUpload value)? resumeUpload,
    TResult? Function(CancelUpload value)? cancelUpload,
    TResult? Function(RetryUpload value)? retryUpload,
    TResult? Function(RemoveFile value)? removeFile,
    TResult? Function(ClearQueue value)? clearQueue,
    TResult? Function(UpdateProgress value)? updateProgress,
    TResult? Function(FileCompleted value)? fileCompleted,
    TResult? Function(FileFailed value)? fileFailed,
    TResult? Function(UpdateSettings value)? updateSettings,
    TResult? Function(ValidateFiles value)? validateFiles,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SetCategory value)? setCategory,
    TResult? Function(SetMetadata value)? setMetadata,
    TResult? Function(ProcessQueue value)? processQueue,
    TResult? Function(UploadCompleted value)? uploadCompleted,
    TResult? Function(UploadError value)? uploadError,
    TResult? Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult? Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult? Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult? Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult? Function(ClearUploadState value)? clearUploadState,
  }) {
    return resetState?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddFiles value)? addFiles,
    TResult Function(StartUpload value)? startUpload,
    TResult Function(PauseUpload value)? pauseUpload,
    TResult Function(ResumeUpload value)? resumeUpload,
    TResult Function(CancelUpload value)? cancelUpload,
    TResult Function(RetryUpload value)? retryUpload,
    TResult Function(RemoveFile value)? removeFile,
    TResult Function(ClearQueue value)? clearQueue,
    TResult Function(UpdateProgress value)? updateProgress,
    TResult Function(FileCompleted value)? fileCompleted,
    TResult Function(FileFailed value)? fileFailed,
    TResult Function(UpdateSettings value)? updateSettings,
    TResult Function(ValidateFiles value)? validateFiles,
    TResult Function(ResetState value)? resetState,
    TResult Function(SetCategory value)? setCategory,
    TResult Function(SetMetadata value)? setMetadata,
    TResult Function(ProcessQueue value)? processQueue,
    TResult Function(UploadCompleted value)? uploadCompleted,
    TResult Function(UploadError value)? uploadError,
    TResult Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult Function(ClearUploadState value)? clearUploadState,
    required TResult orElse(),
  }) {
    if (resetState != null) {
      return resetState(this);
    }
    return orElse();
  }
}

abstract class ResetState implements UploadEvent {
  const factory ResetState() = _$ResetStateImpl;
}

/// @nodoc
abstract class _$$SetCategoryImplCopyWith<$Res> {
  factory _$$SetCategoryImplCopyWith(
    _$SetCategoryImpl value,
    $Res Function(_$SetCategoryImpl) then,
  ) = __$$SetCategoryImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String categoryId});
}

/// @nodoc
class __$$SetCategoryImplCopyWithImpl<$Res>
    extends _$UploadEventCopyWithImpl<$Res, _$SetCategoryImpl>
    implements _$$SetCategoryImplCopyWith<$Res> {
  __$$SetCategoryImplCopyWithImpl(
    _$SetCategoryImpl _value,
    $Res Function(_$SetCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? categoryId = null}) {
    return _then(
      _$SetCategoryImpl(
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SetCategoryImpl implements SetCategory {
  const _$SetCategoryImpl({required this.categoryId});

  @override
  final String categoryId;

  @override
  String toString() {
    return 'UploadEvent.setCategory(categoryId: $categoryId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetCategoryImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, categoryId);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SetCategoryImplCopyWith<_$SetCategoryImpl> get copyWith =>
      __$$SetCategoryImplCopyWithImpl<_$SetCategoryImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )
    addFiles,
    required TResult Function(List<UploadFileModel> files) startUpload,
    required TResult Function(String? fileId) pauseUpload,
    required TResult Function(String? fileId) resumeUpload,
    required TResult Function(String? fileId) cancelUpload,
    required TResult Function(List<UploadFileModel> failedFiles) retryUpload,
    required TResult Function(String fileId) removeFile,
    required TResult Function() clearQueue,
    required TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )
    updateProgress,
    required TResult Function(
      String fileId,
      String downloadUrl,
      String? documentId,
    )
    fileCompleted,
    required TResult Function(String fileId, String error) fileFailed,
    required TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )
    updateSettings,
    required TResult Function(List<XFile> files) validateFiles,
    required TResult Function() resetState,
    required TResult Function(String categoryId) setCategory,
    required TResult Function(Map<String, String> metadata) setMetadata,
    required TResult Function() processQueue,
    required TResult Function() uploadCompleted,
    required TResult Function(String error) uploadError,
    required TResult Function(double progress) overallProgressUpdated,
    required TResult Function(String fileId, double progress)
    fileProgressUpdated,
    required TResult Function(String fileId, UploadStatus status)
    fileStatusUpdated,
    required TResult Function(List<UploadFileModel> files)
    startUploadWithProgress,
    required TResult Function() clearUploadState,
  }) {
    return setCategory(categoryId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult? Function(List<UploadFileModel> files)? startUpload,
    TResult? Function(String? fileId)? pauseUpload,
    TResult? Function(String? fileId)? resumeUpload,
    TResult? Function(String? fileId)? cancelUpload,
    TResult? Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult? Function(String fileId)? removeFile,
    TResult? Function()? clearQueue,
    TResult? Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult? Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult? Function(String fileId, String error)? fileFailed,
    TResult? Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult? Function(List<XFile> files)? validateFiles,
    TResult? Function()? resetState,
    TResult? Function(String categoryId)? setCategory,
    TResult? Function(Map<String, String> metadata)? setMetadata,
    TResult? Function()? processQueue,
    TResult? Function()? uploadCompleted,
    TResult? Function(String error)? uploadError,
    TResult? Function(double progress)? overallProgressUpdated,
    TResult? Function(String fileId, double progress)? fileProgressUpdated,
    TResult? Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult? Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult? Function()? clearUploadState,
  }) {
    return setCategory?.call(categoryId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult Function(List<UploadFileModel> files)? startUpload,
    TResult Function(String? fileId)? pauseUpload,
    TResult Function(String? fileId)? resumeUpload,
    TResult Function(String? fileId)? cancelUpload,
    TResult Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult Function(String fileId)? removeFile,
    TResult Function()? clearQueue,
    TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult Function(String fileId, String error)? fileFailed,
    TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult Function(List<XFile> files)? validateFiles,
    TResult Function()? resetState,
    TResult Function(String categoryId)? setCategory,
    TResult Function(Map<String, String> metadata)? setMetadata,
    TResult Function()? processQueue,
    TResult Function()? uploadCompleted,
    TResult Function(String error)? uploadError,
    TResult Function(double progress)? overallProgressUpdated,
    TResult Function(String fileId, double progress)? fileProgressUpdated,
    TResult Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult Function()? clearUploadState,
    required TResult orElse(),
  }) {
    if (setCategory != null) {
      return setCategory(categoryId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddFiles value) addFiles,
    required TResult Function(StartUpload value) startUpload,
    required TResult Function(PauseUpload value) pauseUpload,
    required TResult Function(ResumeUpload value) resumeUpload,
    required TResult Function(CancelUpload value) cancelUpload,
    required TResult Function(RetryUpload value) retryUpload,
    required TResult Function(RemoveFile value) removeFile,
    required TResult Function(ClearQueue value) clearQueue,
    required TResult Function(UpdateProgress value) updateProgress,
    required TResult Function(FileCompleted value) fileCompleted,
    required TResult Function(FileFailed value) fileFailed,
    required TResult Function(UpdateSettings value) updateSettings,
    required TResult Function(ValidateFiles value) validateFiles,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SetCategory value) setCategory,
    required TResult Function(SetMetadata value) setMetadata,
    required TResult Function(ProcessQueue value) processQueue,
    required TResult Function(UploadCompleted value) uploadCompleted,
    required TResult Function(UploadError value) uploadError,
    required TResult Function(OverallProgressUpdated value)
    overallProgressUpdated,
    required TResult Function(FileProgressUpdated value) fileProgressUpdated,
    required TResult Function(FileStatusUpdated value) fileStatusUpdated,
    required TResult Function(StartUploadWithProgress value)
    startUploadWithProgress,
    required TResult Function(ClearUploadState value) clearUploadState,
  }) {
    return setCategory(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddFiles value)? addFiles,
    TResult? Function(StartUpload value)? startUpload,
    TResult? Function(PauseUpload value)? pauseUpload,
    TResult? Function(ResumeUpload value)? resumeUpload,
    TResult? Function(CancelUpload value)? cancelUpload,
    TResult? Function(RetryUpload value)? retryUpload,
    TResult? Function(RemoveFile value)? removeFile,
    TResult? Function(ClearQueue value)? clearQueue,
    TResult? Function(UpdateProgress value)? updateProgress,
    TResult? Function(FileCompleted value)? fileCompleted,
    TResult? Function(FileFailed value)? fileFailed,
    TResult? Function(UpdateSettings value)? updateSettings,
    TResult? Function(ValidateFiles value)? validateFiles,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SetCategory value)? setCategory,
    TResult? Function(SetMetadata value)? setMetadata,
    TResult? Function(ProcessQueue value)? processQueue,
    TResult? Function(UploadCompleted value)? uploadCompleted,
    TResult? Function(UploadError value)? uploadError,
    TResult? Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult? Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult? Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult? Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult? Function(ClearUploadState value)? clearUploadState,
  }) {
    return setCategory?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddFiles value)? addFiles,
    TResult Function(StartUpload value)? startUpload,
    TResult Function(PauseUpload value)? pauseUpload,
    TResult Function(ResumeUpload value)? resumeUpload,
    TResult Function(CancelUpload value)? cancelUpload,
    TResult Function(RetryUpload value)? retryUpload,
    TResult Function(RemoveFile value)? removeFile,
    TResult Function(ClearQueue value)? clearQueue,
    TResult Function(UpdateProgress value)? updateProgress,
    TResult Function(FileCompleted value)? fileCompleted,
    TResult Function(FileFailed value)? fileFailed,
    TResult Function(UpdateSettings value)? updateSettings,
    TResult Function(ValidateFiles value)? validateFiles,
    TResult Function(ResetState value)? resetState,
    TResult Function(SetCategory value)? setCategory,
    TResult Function(SetMetadata value)? setMetadata,
    TResult Function(ProcessQueue value)? processQueue,
    TResult Function(UploadCompleted value)? uploadCompleted,
    TResult Function(UploadError value)? uploadError,
    TResult Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult Function(ClearUploadState value)? clearUploadState,
    required TResult orElse(),
  }) {
    if (setCategory != null) {
      return setCategory(this);
    }
    return orElse();
  }
}

abstract class SetCategory implements UploadEvent {
  const factory SetCategory({required final String categoryId}) =
      _$SetCategoryImpl;

  String get categoryId;

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SetCategoryImplCopyWith<_$SetCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SetMetadataImplCopyWith<$Res> {
  factory _$$SetMetadataImplCopyWith(
    _$SetMetadataImpl value,
    $Res Function(_$SetMetadataImpl) then,
  ) = __$$SetMetadataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Map<String, String> metadata});
}

/// @nodoc
class __$$SetMetadataImplCopyWithImpl<$Res>
    extends _$UploadEventCopyWithImpl<$Res, _$SetMetadataImpl>
    implements _$$SetMetadataImplCopyWith<$Res> {
  __$$SetMetadataImplCopyWithImpl(
    _$SetMetadataImpl _value,
    $Res Function(_$SetMetadataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? metadata = null}) {
    return _then(
      _$SetMetadataImpl(
        metadata: null == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
      ),
    );
  }
}

/// @nodoc

class _$SetMetadataImpl implements SetMetadata {
  const _$SetMetadataImpl({required final Map<String, String> metadata})
    : _metadata = metadata;

  final Map<String, String> _metadata;
  @override
  Map<String, String> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'UploadEvent.setMetadata(metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetMetadataImpl &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SetMetadataImplCopyWith<_$SetMetadataImpl> get copyWith =>
      __$$SetMetadataImplCopyWithImpl<_$SetMetadataImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )
    addFiles,
    required TResult Function(List<UploadFileModel> files) startUpload,
    required TResult Function(String? fileId) pauseUpload,
    required TResult Function(String? fileId) resumeUpload,
    required TResult Function(String? fileId) cancelUpload,
    required TResult Function(List<UploadFileModel> failedFiles) retryUpload,
    required TResult Function(String fileId) removeFile,
    required TResult Function() clearQueue,
    required TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )
    updateProgress,
    required TResult Function(
      String fileId,
      String downloadUrl,
      String? documentId,
    )
    fileCompleted,
    required TResult Function(String fileId, String error) fileFailed,
    required TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )
    updateSettings,
    required TResult Function(List<XFile> files) validateFiles,
    required TResult Function() resetState,
    required TResult Function(String categoryId) setCategory,
    required TResult Function(Map<String, String> metadata) setMetadata,
    required TResult Function() processQueue,
    required TResult Function() uploadCompleted,
    required TResult Function(String error) uploadError,
    required TResult Function(double progress) overallProgressUpdated,
    required TResult Function(String fileId, double progress)
    fileProgressUpdated,
    required TResult Function(String fileId, UploadStatus status)
    fileStatusUpdated,
    required TResult Function(List<UploadFileModel> files)
    startUploadWithProgress,
    required TResult Function() clearUploadState,
  }) {
    return setMetadata(metadata);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult? Function(List<UploadFileModel> files)? startUpload,
    TResult? Function(String? fileId)? pauseUpload,
    TResult? Function(String? fileId)? resumeUpload,
    TResult? Function(String? fileId)? cancelUpload,
    TResult? Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult? Function(String fileId)? removeFile,
    TResult? Function()? clearQueue,
    TResult? Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult? Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult? Function(String fileId, String error)? fileFailed,
    TResult? Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult? Function(List<XFile> files)? validateFiles,
    TResult? Function()? resetState,
    TResult? Function(String categoryId)? setCategory,
    TResult? Function(Map<String, String> metadata)? setMetadata,
    TResult? Function()? processQueue,
    TResult? Function()? uploadCompleted,
    TResult? Function(String error)? uploadError,
    TResult? Function(double progress)? overallProgressUpdated,
    TResult? Function(String fileId, double progress)? fileProgressUpdated,
    TResult? Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult? Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult? Function()? clearUploadState,
  }) {
    return setMetadata?.call(metadata);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult Function(List<UploadFileModel> files)? startUpload,
    TResult Function(String? fileId)? pauseUpload,
    TResult Function(String? fileId)? resumeUpload,
    TResult Function(String? fileId)? cancelUpload,
    TResult Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult Function(String fileId)? removeFile,
    TResult Function()? clearQueue,
    TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult Function(String fileId, String error)? fileFailed,
    TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult Function(List<XFile> files)? validateFiles,
    TResult Function()? resetState,
    TResult Function(String categoryId)? setCategory,
    TResult Function(Map<String, String> metadata)? setMetadata,
    TResult Function()? processQueue,
    TResult Function()? uploadCompleted,
    TResult Function(String error)? uploadError,
    TResult Function(double progress)? overallProgressUpdated,
    TResult Function(String fileId, double progress)? fileProgressUpdated,
    TResult Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult Function()? clearUploadState,
    required TResult orElse(),
  }) {
    if (setMetadata != null) {
      return setMetadata(metadata);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddFiles value) addFiles,
    required TResult Function(StartUpload value) startUpload,
    required TResult Function(PauseUpload value) pauseUpload,
    required TResult Function(ResumeUpload value) resumeUpload,
    required TResult Function(CancelUpload value) cancelUpload,
    required TResult Function(RetryUpload value) retryUpload,
    required TResult Function(RemoveFile value) removeFile,
    required TResult Function(ClearQueue value) clearQueue,
    required TResult Function(UpdateProgress value) updateProgress,
    required TResult Function(FileCompleted value) fileCompleted,
    required TResult Function(FileFailed value) fileFailed,
    required TResult Function(UpdateSettings value) updateSettings,
    required TResult Function(ValidateFiles value) validateFiles,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SetCategory value) setCategory,
    required TResult Function(SetMetadata value) setMetadata,
    required TResult Function(ProcessQueue value) processQueue,
    required TResult Function(UploadCompleted value) uploadCompleted,
    required TResult Function(UploadError value) uploadError,
    required TResult Function(OverallProgressUpdated value)
    overallProgressUpdated,
    required TResult Function(FileProgressUpdated value) fileProgressUpdated,
    required TResult Function(FileStatusUpdated value) fileStatusUpdated,
    required TResult Function(StartUploadWithProgress value)
    startUploadWithProgress,
    required TResult Function(ClearUploadState value) clearUploadState,
  }) {
    return setMetadata(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddFiles value)? addFiles,
    TResult? Function(StartUpload value)? startUpload,
    TResult? Function(PauseUpload value)? pauseUpload,
    TResult? Function(ResumeUpload value)? resumeUpload,
    TResult? Function(CancelUpload value)? cancelUpload,
    TResult? Function(RetryUpload value)? retryUpload,
    TResult? Function(RemoveFile value)? removeFile,
    TResult? Function(ClearQueue value)? clearQueue,
    TResult? Function(UpdateProgress value)? updateProgress,
    TResult? Function(FileCompleted value)? fileCompleted,
    TResult? Function(FileFailed value)? fileFailed,
    TResult? Function(UpdateSettings value)? updateSettings,
    TResult? Function(ValidateFiles value)? validateFiles,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SetCategory value)? setCategory,
    TResult? Function(SetMetadata value)? setMetadata,
    TResult? Function(ProcessQueue value)? processQueue,
    TResult? Function(UploadCompleted value)? uploadCompleted,
    TResult? Function(UploadError value)? uploadError,
    TResult? Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult? Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult? Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult? Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult? Function(ClearUploadState value)? clearUploadState,
  }) {
    return setMetadata?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddFiles value)? addFiles,
    TResult Function(StartUpload value)? startUpload,
    TResult Function(PauseUpload value)? pauseUpload,
    TResult Function(ResumeUpload value)? resumeUpload,
    TResult Function(CancelUpload value)? cancelUpload,
    TResult Function(RetryUpload value)? retryUpload,
    TResult Function(RemoveFile value)? removeFile,
    TResult Function(ClearQueue value)? clearQueue,
    TResult Function(UpdateProgress value)? updateProgress,
    TResult Function(FileCompleted value)? fileCompleted,
    TResult Function(FileFailed value)? fileFailed,
    TResult Function(UpdateSettings value)? updateSettings,
    TResult Function(ValidateFiles value)? validateFiles,
    TResult Function(ResetState value)? resetState,
    TResult Function(SetCategory value)? setCategory,
    TResult Function(SetMetadata value)? setMetadata,
    TResult Function(ProcessQueue value)? processQueue,
    TResult Function(UploadCompleted value)? uploadCompleted,
    TResult Function(UploadError value)? uploadError,
    TResult Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult Function(ClearUploadState value)? clearUploadState,
    required TResult orElse(),
  }) {
    if (setMetadata != null) {
      return setMetadata(this);
    }
    return orElse();
  }
}

abstract class SetMetadata implements UploadEvent {
  const factory SetMetadata({required final Map<String, String> metadata}) =
      _$SetMetadataImpl;

  Map<String, String> get metadata;

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SetMetadataImplCopyWith<_$SetMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ProcessQueueImplCopyWith<$Res> {
  factory _$$ProcessQueueImplCopyWith(
    _$ProcessQueueImpl value,
    $Res Function(_$ProcessQueueImpl) then,
  ) = __$$ProcessQueueImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ProcessQueueImplCopyWithImpl<$Res>
    extends _$UploadEventCopyWithImpl<$Res, _$ProcessQueueImpl>
    implements _$$ProcessQueueImplCopyWith<$Res> {
  __$$ProcessQueueImplCopyWithImpl(
    _$ProcessQueueImpl _value,
    $Res Function(_$ProcessQueueImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ProcessQueueImpl implements ProcessQueue {
  const _$ProcessQueueImpl();

  @override
  String toString() {
    return 'UploadEvent.processQueue()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ProcessQueueImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )
    addFiles,
    required TResult Function(List<UploadFileModel> files) startUpload,
    required TResult Function(String? fileId) pauseUpload,
    required TResult Function(String? fileId) resumeUpload,
    required TResult Function(String? fileId) cancelUpload,
    required TResult Function(List<UploadFileModel> failedFiles) retryUpload,
    required TResult Function(String fileId) removeFile,
    required TResult Function() clearQueue,
    required TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )
    updateProgress,
    required TResult Function(
      String fileId,
      String downloadUrl,
      String? documentId,
    )
    fileCompleted,
    required TResult Function(String fileId, String error) fileFailed,
    required TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )
    updateSettings,
    required TResult Function(List<XFile> files) validateFiles,
    required TResult Function() resetState,
    required TResult Function(String categoryId) setCategory,
    required TResult Function(Map<String, String> metadata) setMetadata,
    required TResult Function() processQueue,
    required TResult Function() uploadCompleted,
    required TResult Function(String error) uploadError,
    required TResult Function(double progress) overallProgressUpdated,
    required TResult Function(String fileId, double progress)
    fileProgressUpdated,
    required TResult Function(String fileId, UploadStatus status)
    fileStatusUpdated,
    required TResult Function(List<UploadFileModel> files)
    startUploadWithProgress,
    required TResult Function() clearUploadState,
  }) {
    return processQueue();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult? Function(List<UploadFileModel> files)? startUpload,
    TResult? Function(String? fileId)? pauseUpload,
    TResult? Function(String? fileId)? resumeUpload,
    TResult? Function(String? fileId)? cancelUpload,
    TResult? Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult? Function(String fileId)? removeFile,
    TResult? Function()? clearQueue,
    TResult? Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult? Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult? Function(String fileId, String error)? fileFailed,
    TResult? Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult? Function(List<XFile> files)? validateFiles,
    TResult? Function()? resetState,
    TResult? Function(String categoryId)? setCategory,
    TResult? Function(Map<String, String> metadata)? setMetadata,
    TResult? Function()? processQueue,
    TResult? Function()? uploadCompleted,
    TResult? Function(String error)? uploadError,
    TResult? Function(double progress)? overallProgressUpdated,
    TResult? Function(String fileId, double progress)? fileProgressUpdated,
    TResult? Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult? Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult? Function()? clearUploadState,
  }) {
    return processQueue?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult Function(List<UploadFileModel> files)? startUpload,
    TResult Function(String? fileId)? pauseUpload,
    TResult Function(String? fileId)? resumeUpload,
    TResult Function(String? fileId)? cancelUpload,
    TResult Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult Function(String fileId)? removeFile,
    TResult Function()? clearQueue,
    TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult Function(String fileId, String error)? fileFailed,
    TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult Function(List<XFile> files)? validateFiles,
    TResult Function()? resetState,
    TResult Function(String categoryId)? setCategory,
    TResult Function(Map<String, String> metadata)? setMetadata,
    TResult Function()? processQueue,
    TResult Function()? uploadCompleted,
    TResult Function(String error)? uploadError,
    TResult Function(double progress)? overallProgressUpdated,
    TResult Function(String fileId, double progress)? fileProgressUpdated,
    TResult Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult Function()? clearUploadState,
    required TResult orElse(),
  }) {
    if (processQueue != null) {
      return processQueue();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddFiles value) addFiles,
    required TResult Function(StartUpload value) startUpload,
    required TResult Function(PauseUpload value) pauseUpload,
    required TResult Function(ResumeUpload value) resumeUpload,
    required TResult Function(CancelUpload value) cancelUpload,
    required TResult Function(RetryUpload value) retryUpload,
    required TResult Function(RemoveFile value) removeFile,
    required TResult Function(ClearQueue value) clearQueue,
    required TResult Function(UpdateProgress value) updateProgress,
    required TResult Function(FileCompleted value) fileCompleted,
    required TResult Function(FileFailed value) fileFailed,
    required TResult Function(UpdateSettings value) updateSettings,
    required TResult Function(ValidateFiles value) validateFiles,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SetCategory value) setCategory,
    required TResult Function(SetMetadata value) setMetadata,
    required TResult Function(ProcessQueue value) processQueue,
    required TResult Function(UploadCompleted value) uploadCompleted,
    required TResult Function(UploadError value) uploadError,
    required TResult Function(OverallProgressUpdated value)
    overallProgressUpdated,
    required TResult Function(FileProgressUpdated value) fileProgressUpdated,
    required TResult Function(FileStatusUpdated value) fileStatusUpdated,
    required TResult Function(StartUploadWithProgress value)
    startUploadWithProgress,
    required TResult Function(ClearUploadState value) clearUploadState,
  }) {
    return processQueue(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddFiles value)? addFiles,
    TResult? Function(StartUpload value)? startUpload,
    TResult? Function(PauseUpload value)? pauseUpload,
    TResult? Function(ResumeUpload value)? resumeUpload,
    TResult? Function(CancelUpload value)? cancelUpload,
    TResult? Function(RetryUpload value)? retryUpload,
    TResult? Function(RemoveFile value)? removeFile,
    TResult? Function(ClearQueue value)? clearQueue,
    TResult? Function(UpdateProgress value)? updateProgress,
    TResult? Function(FileCompleted value)? fileCompleted,
    TResult? Function(FileFailed value)? fileFailed,
    TResult? Function(UpdateSettings value)? updateSettings,
    TResult? Function(ValidateFiles value)? validateFiles,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SetCategory value)? setCategory,
    TResult? Function(SetMetadata value)? setMetadata,
    TResult? Function(ProcessQueue value)? processQueue,
    TResult? Function(UploadCompleted value)? uploadCompleted,
    TResult? Function(UploadError value)? uploadError,
    TResult? Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult? Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult? Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult? Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult? Function(ClearUploadState value)? clearUploadState,
  }) {
    return processQueue?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddFiles value)? addFiles,
    TResult Function(StartUpload value)? startUpload,
    TResult Function(PauseUpload value)? pauseUpload,
    TResult Function(ResumeUpload value)? resumeUpload,
    TResult Function(CancelUpload value)? cancelUpload,
    TResult Function(RetryUpload value)? retryUpload,
    TResult Function(RemoveFile value)? removeFile,
    TResult Function(ClearQueue value)? clearQueue,
    TResult Function(UpdateProgress value)? updateProgress,
    TResult Function(FileCompleted value)? fileCompleted,
    TResult Function(FileFailed value)? fileFailed,
    TResult Function(UpdateSettings value)? updateSettings,
    TResult Function(ValidateFiles value)? validateFiles,
    TResult Function(ResetState value)? resetState,
    TResult Function(SetCategory value)? setCategory,
    TResult Function(SetMetadata value)? setMetadata,
    TResult Function(ProcessQueue value)? processQueue,
    TResult Function(UploadCompleted value)? uploadCompleted,
    TResult Function(UploadError value)? uploadError,
    TResult Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult Function(ClearUploadState value)? clearUploadState,
    required TResult orElse(),
  }) {
    if (processQueue != null) {
      return processQueue(this);
    }
    return orElse();
  }
}

abstract class ProcessQueue implements UploadEvent {
  const factory ProcessQueue() = _$ProcessQueueImpl;
}

/// @nodoc
abstract class _$$UploadCompletedImplCopyWith<$Res> {
  factory _$$UploadCompletedImplCopyWith(
    _$UploadCompletedImpl value,
    $Res Function(_$UploadCompletedImpl) then,
  ) = __$$UploadCompletedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UploadCompletedImplCopyWithImpl<$Res>
    extends _$UploadEventCopyWithImpl<$Res, _$UploadCompletedImpl>
    implements _$$UploadCompletedImplCopyWith<$Res> {
  __$$UploadCompletedImplCopyWithImpl(
    _$UploadCompletedImpl _value,
    $Res Function(_$UploadCompletedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UploadCompletedImpl implements UploadCompleted {
  const _$UploadCompletedImpl();

  @override
  String toString() {
    return 'UploadEvent.uploadCompleted()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UploadCompletedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )
    addFiles,
    required TResult Function(List<UploadFileModel> files) startUpload,
    required TResult Function(String? fileId) pauseUpload,
    required TResult Function(String? fileId) resumeUpload,
    required TResult Function(String? fileId) cancelUpload,
    required TResult Function(List<UploadFileModel> failedFiles) retryUpload,
    required TResult Function(String fileId) removeFile,
    required TResult Function() clearQueue,
    required TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )
    updateProgress,
    required TResult Function(
      String fileId,
      String downloadUrl,
      String? documentId,
    )
    fileCompleted,
    required TResult Function(String fileId, String error) fileFailed,
    required TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )
    updateSettings,
    required TResult Function(List<XFile> files) validateFiles,
    required TResult Function() resetState,
    required TResult Function(String categoryId) setCategory,
    required TResult Function(Map<String, String> metadata) setMetadata,
    required TResult Function() processQueue,
    required TResult Function() uploadCompleted,
    required TResult Function(String error) uploadError,
    required TResult Function(double progress) overallProgressUpdated,
    required TResult Function(String fileId, double progress)
    fileProgressUpdated,
    required TResult Function(String fileId, UploadStatus status)
    fileStatusUpdated,
    required TResult Function(List<UploadFileModel> files)
    startUploadWithProgress,
    required TResult Function() clearUploadState,
  }) {
    return uploadCompleted();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult? Function(List<UploadFileModel> files)? startUpload,
    TResult? Function(String? fileId)? pauseUpload,
    TResult? Function(String? fileId)? resumeUpload,
    TResult? Function(String? fileId)? cancelUpload,
    TResult? Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult? Function(String fileId)? removeFile,
    TResult? Function()? clearQueue,
    TResult? Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult? Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult? Function(String fileId, String error)? fileFailed,
    TResult? Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult? Function(List<XFile> files)? validateFiles,
    TResult? Function()? resetState,
    TResult? Function(String categoryId)? setCategory,
    TResult? Function(Map<String, String> metadata)? setMetadata,
    TResult? Function()? processQueue,
    TResult? Function()? uploadCompleted,
    TResult? Function(String error)? uploadError,
    TResult? Function(double progress)? overallProgressUpdated,
    TResult? Function(String fileId, double progress)? fileProgressUpdated,
    TResult? Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult? Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult? Function()? clearUploadState,
  }) {
    return uploadCompleted?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult Function(List<UploadFileModel> files)? startUpload,
    TResult Function(String? fileId)? pauseUpload,
    TResult Function(String? fileId)? resumeUpload,
    TResult Function(String? fileId)? cancelUpload,
    TResult Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult Function(String fileId)? removeFile,
    TResult Function()? clearQueue,
    TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult Function(String fileId, String error)? fileFailed,
    TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult Function(List<XFile> files)? validateFiles,
    TResult Function()? resetState,
    TResult Function(String categoryId)? setCategory,
    TResult Function(Map<String, String> metadata)? setMetadata,
    TResult Function()? processQueue,
    TResult Function()? uploadCompleted,
    TResult Function(String error)? uploadError,
    TResult Function(double progress)? overallProgressUpdated,
    TResult Function(String fileId, double progress)? fileProgressUpdated,
    TResult Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult Function()? clearUploadState,
    required TResult orElse(),
  }) {
    if (uploadCompleted != null) {
      return uploadCompleted();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddFiles value) addFiles,
    required TResult Function(StartUpload value) startUpload,
    required TResult Function(PauseUpload value) pauseUpload,
    required TResult Function(ResumeUpload value) resumeUpload,
    required TResult Function(CancelUpload value) cancelUpload,
    required TResult Function(RetryUpload value) retryUpload,
    required TResult Function(RemoveFile value) removeFile,
    required TResult Function(ClearQueue value) clearQueue,
    required TResult Function(UpdateProgress value) updateProgress,
    required TResult Function(FileCompleted value) fileCompleted,
    required TResult Function(FileFailed value) fileFailed,
    required TResult Function(UpdateSettings value) updateSettings,
    required TResult Function(ValidateFiles value) validateFiles,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SetCategory value) setCategory,
    required TResult Function(SetMetadata value) setMetadata,
    required TResult Function(ProcessQueue value) processQueue,
    required TResult Function(UploadCompleted value) uploadCompleted,
    required TResult Function(UploadError value) uploadError,
    required TResult Function(OverallProgressUpdated value)
    overallProgressUpdated,
    required TResult Function(FileProgressUpdated value) fileProgressUpdated,
    required TResult Function(FileStatusUpdated value) fileStatusUpdated,
    required TResult Function(StartUploadWithProgress value)
    startUploadWithProgress,
    required TResult Function(ClearUploadState value) clearUploadState,
  }) {
    return uploadCompleted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddFiles value)? addFiles,
    TResult? Function(StartUpload value)? startUpload,
    TResult? Function(PauseUpload value)? pauseUpload,
    TResult? Function(ResumeUpload value)? resumeUpload,
    TResult? Function(CancelUpload value)? cancelUpload,
    TResult? Function(RetryUpload value)? retryUpload,
    TResult? Function(RemoveFile value)? removeFile,
    TResult? Function(ClearQueue value)? clearQueue,
    TResult? Function(UpdateProgress value)? updateProgress,
    TResult? Function(FileCompleted value)? fileCompleted,
    TResult? Function(FileFailed value)? fileFailed,
    TResult? Function(UpdateSettings value)? updateSettings,
    TResult? Function(ValidateFiles value)? validateFiles,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SetCategory value)? setCategory,
    TResult? Function(SetMetadata value)? setMetadata,
    TResult? Function(ProcessQueue value)? processQueue,
    TResult? Function(UploadCompleted value)? uploadCompleted,
    TResult? Function(UploadError value)? uploadError,
    TResult? Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult? Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult? Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult? Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult? Function(ClearUploadState value)? clearUploadState,
  }) {
    return uploadCompleted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddFiles value)? addFiles,
    TResult Function(StartUpload value)? startUpload,
    TResult Function(PauseUpload value)? pauseUpload,
    TResult Function(ResumeUpload value)? resumeUpload,
    TResult Function(CancelUpload value)? cancelUpload,
    TResult Function(RetryUpload value)? retryUpload,
    TResult Function(RemoveFile value)? removeFile,
    TResult Function(ClearQueue value)? clearQueue,
    TResult Function(UpdateProgress value)? updateProgress,
    TResult Function(FileCompleted value)? fileCompleted,
    TResult Function(FileFailed value)? fileFailed,
    TResult Function(UpdateSettings value)? updateSettings,
    TResult Function(ValidateFiles value)? validateFiles,
    TResult Function(ResetState value)? resetState,
    TResult Function(SetCategory value)? setCategory,
    TResult Function(SetMetadata value)? setMetadata,
    TResult Function(ProcessQueue value)? processQueue,
    TResult Function(UploadCompleted value)? uploadCompleted,
    TResult Function(UploadError value)? uploadError,
    TResult Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult Function(ClearUploadState value)? clearUploadState,
    required TResult orElse(),
  }) {
    if (uploadCompleted != null) {
      return uploadCompleted(this);
    }
    return orElse();
  }
}

abstract class UploadCompleted implements UploadEvent {
  const factory UploadCompleted() = _$UploadCompletedImpl;
}

/// @nodoc
abstract class _$$UploadErrorImplCopyWith<$Res> {
  factory _$$UploadErrorImplCopyWith(
    _$UploadErrorImpl value,
    $Res Function(_$UploadErrorImpl) then,
  ) = __$$UploadErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String error});
}

/// @nodoc
class __$$UploadErrorImplCopyWithImpl<$Res>
    extends _$UploadEventCopyWithImpl<$Res, _$UploadErrorImpl>
    implements _$$UploadErrorImplCopyWith<$Res> {
  __$$UploadErrorImplCopyWithImpl(
    _$UploadErrorImpl _value,
    $Res Function(_$UploadErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? error = null}) {
    return _then(
      _$UploadErrorImpl(
        error: null == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UploadErrorImpl implements UploadError {
  const _$UploadErrorImpl({required this.error});

  @override
  final String error;

  @override
  String toString() {
    return 'UploadEvent.uploadError(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadErrorImpl &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadErrorImplCopyWith<_$UploadErrorImpl> get copyWith =>
      __$$UploadErrorImplCopyWithImpl<_$UploadErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )
    addFiles,
    required TResult Function(List<UploadFileModel> files) startUpload,
    required TResult Function(String? fileId) pauseUpload,
    required TResult Function(String? fileId) resumeUpload,
    required TResult Function(String? fileId) cancelUpload,
    required TResult Function(List<UploadFileModel> failedFiles) retryUpload,
    required TResult Function(String fileId) removeFile,
    required TResult Function() clearQueue,
    required TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )
    updateProgress,
    required TResult Function(
      String fileId,
      String downloadUrl,
      String? documentId,
    )
    fileCompleted,
    required TResult Function(String fileId, String error) fileFailed,
    required TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )
    updateSettings,
    required TResult Function(List<XFile> files) validateFiles,
    required TResult Function() resetState,
    required TResult Function(String categoryId) setCategory,
    required TResult Function(Map<String, String> metadata) setMetadata,
    required TResult Function() processQueue,
    required TResult Function() uploadCompleted,
    required TResult Function(String error) uploadError,
    required TResult Function(double progress) overallProgressUpdated,
    required TResult Function(String fileId, double progress)
    fileProgressUpdated,
    required TResult Function(String fileId, UploadStatus status)
    fileStatusUpdated,
    required TResult Function(List<UploadFileModel> files)
    startUploadWithProgress,
    required TResult Function() clearUploadState,
  }) {
    return uploadError(error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult? Function(List<UploadFileModel> files)? startUpload,
    TResult? Function(String? fileId)? pauseUpload,
    TResult? Function(String? fileId)? resumeUpload,
    TResult? Function(String? fileId)? cancelUpload,
    TResult? Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult? Function(String fileId)? removeFile,
    TResult? Function()? clearQueue,
    TResult? Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult? Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult? Function(String fileId, String error)? fileFailed,
    TResult? Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult? Function(List<XFile> files)? validateFiles,
    TResult? Function()? resetState,
    TResult? Function(String categoryId)? setCategory,
    TResult? Function(Map<String, String> metadata)? setMetadata,
    TResult? Function()? processQueue,
    TResult? Function()? uploadCompleted,
    TResult? Function(String error)? uploadError,
    TResult? Function(double progress)? overallProgressUpdated,
    TResult? Function(String fileId, double progress)? fileProgressUpdated,
    TResult? Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult? Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult? Function()? clearUploadState,
  }) {
    return uploadError?.call(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult Function(List<UploadFileModel> files)? startUpload,
    TResult Function(String? fileId)? pauseUpload,
    TResult Function(String? fileId)? resumeUpload,
    TResult Function(String? fileId)? cancelUpload,
    TResult Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult Function(String fileId)? removeFile,
    TResult Function()? clearQueue,
    TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult Function(String fileId, String error)? fileFailed,
    TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult Function(List<XFile> files)? validateFiles,
    TResult Function()? resetState,
    TResult Function(String categoryId)? setCategory,
    TResult Function(Map<String, String> metadata)? setMetadata,
    TResult Function()? processQueue,
    TResult Function()? uploadCompleted,
    TResult Function(String error)? uploadError,
    TResult Function(double progress)? overallProgressUpdated,
    TResult Function(String fileId, double progress)? fileProgressUpdated,
    TResult Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult Function()? clearUploadState,
    required TResult orElse(),
  }) {
    if (uploadError != null) {
      return uploadError(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddFiles value) addFiles,
    required TResult Function(StartUpload value) startUpload,
    required TResult Function(PauseUpload value) pauseUpload,
    required TResult Function(ResumeUpload value) resumeUpload,
    required TResult Function(CancelUpload value) cancelUpload,
    required TResult Function(RetryUpload value) retryUpload,
    required TResult Function(RemoveFile value) removeFile,
    required TResult Function(ClearQueue value) clearQueue,
    required TResult Function(UpdateProgress value) updateProgress,
    required TResult Function(FileCompleted value) fileCompleted,
    required TResult Function(FileFailed value) fileFailed,
    required TResult Function(UpdateSettings value) updateSettings,
    required TResult Function(ValidateFiles value) validateFiles,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SetCategory value) setCategory,
    required TResult Function(SetMetadata value) setMetadata,
    required TResult Function(ProcessQueue value) processQueue,
    required TResult Function(UploadCompleted value) uploadCompleted,
    required TResult Function(UploadError value) uploadError,
    required TResult Function(OverallProgressUpdated value)
    overallProgressUpdated,
    required TResult Function(FileProgressUpdated value) fileProgressUpdated,
    required TResult Function(FileStatusUpdated value) fileStatusUpdated,
    required TResult Function(StartUploadWithProgress value)
    startUploadWithProgress,
    required TResult Function(ClearUploadState value) clearUploadState,
  }) {
    return uploadError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddFiles value)? addFiles,
    TResult? Function(StartUpload value)? startUpload,
    TResult? Function(PauseUpload value)? pauseUpload,
    TResult? Function(ResumeUpload value)? resumeUpload,
    TResult? Function(CancelUpload value)? cancelUpload,
    TResult? Function(RetryUpload value)? retryUpload,
    TResult? Function(RemoveFile value)? removeFile,
    TResult? Function(ClearQueue value)? clearQueue,
    TResult? Function(UpdateProgress value)? updateProgress,
    TResult? Function(FileCompleted value)? fileCompleted,
    TResult? Function(FileFailed value)? fileFailed,
    TResult? Function(UpdateSettings value)? updateSettings,
    TResult? Function(ValidateFiles value)? validateFiles,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SetCategory value)? setCategory,
    TResult? Function(SetMetadata value)? setMetadata,
    TResult? Function(ProcessQueue value)? processQueue,
    TResult? Function(UploadCompleted value)? uploadCompleted,
    TResult? Function(UploadError value)? uploadError,
    TResult? Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult? Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult? Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult? Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult? Function(ClearUploadState value)? clearUploadState,
  }) {
    return uploadError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddFiles value)? addFiles,
    TResult Function(StartUpload value)? startUpload,
    TResult Function(PauseUpload value)? pauseUpload,
    TResult Function(ResumeUpload value)? resumeUpload,
    TResult Function(CancelUpload value)? cancelUpload,
    TResult Function(RetryUpload value)? retryUpload,
    TResult Function(RemoveFile value)? removeFile,
    TResult Function(ClearQueue value)? clearQueue,
    TResult Function(UpdateProgress value)? updateProgress,
    TResult Function(FileCompleted value)? fileCompleted,
    TResult Function(FileFailed value)? fileFailed,
    TResult Function(UpdateSettings value)? updateSettings,
    TResult Function(ValidateFiles value)? validateFiles,
    TResult Function(ResetState value)? resetState,
    TResult Function(SetCategory value)? setCategory,
    TResult Function(SetMetadata value)? setMetadata,
    TResult Function(ProcessQueue value)? processQueue,
    TResult Function(UploadCompleted value)? uploadCompleted,
    TResult Function(UploadError value)? uploadError,
    TResult Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult Function(ClearUploadState value)? clearUploadState,
    required TResult orElse(),
  }) {
    if (uploadError != null) {
      return uploadError(this);
    }
    return orElse();
  }
}

abstract class UploadError implements UploadEvent {
  const factory UploadError({required final String error}) = _$UploadErrorImpl;

  String get error;

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadErrorImplCopyWith<_$UploadErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OverallProgressUpdatedImplCopyWith<$Res> {
  factory _$$OverallProgressUpdatedImplCopyWith(
    _$OverallProgressUpdatedImpl value,
    $Res Function(_$OverallProgressUpdatedImpl) then,
  ) = __$$OverallProgressUpdatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({double progress});
}

/// @nodoc
class __$$OverallProgressUpdatedImplCopyWithImpl<$Res>
    extends _$UploadEventCopyWithImpl<$Res, _$OverallProgressUpdatedImpl>
    implements _$$OverallProgressUpdatedImplCopyWith<$Res> {
  __$$OverallProgressUpdatedImplCopyWithImpl(
    _$OverallProgressUpdatedImpl _value,
    $Res Function(_$OverallProgressUpdatedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? progress = null}) {
    return _then(
      _$OverallProgressUpdatedImpl(
        progress: null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$OverallProgressUpdatedImpl implements OverallProgressUpdated {
  const _$OverallProgressUpdatedImpl({required this.progress});

  @override
  final double progress;

  @override
  String toString() {
    return 'UploadEvent.overallProgressUpdated(progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OverallProgressUpdatedImpl &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @override
  int get hashCode => Object.hash(runtimeType, progress);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OverallProgressUpdatedImplCopyWith<_$OverallProgressUpdatedImpl>
  get copyWith =>
      __$$OverallProgressUpdatedImplCopyWithImpl<_$OverallProgressUpdatedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )
    addFiles,
    required TResult Function(List<UploadFileModel> files) startUpload,
    required TResult Function(String? fileId) pauseUpload,
    required TResult Function(String? fileId) resumeUpload,
    required TResult Function(String? fileId) cancelUpload,
    required TResult Function(List<UploadFileModel> failedFiles) retryUpload,
    required TResult Function(String fileId) removeFile,
    required TResult Function() clearQueue,
    required TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )
    updateProgress,
    required TResult Function(
      String fileId,
      String downloadUrl,
      String? documentId,
    )
    fileCompleted,
    required TResult Function(String fileId, String error) fileFailed,
    required TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )
    updateSettings,
    required TResult Function(List<XFile> files) validateFiles,
    required TResult Function() resetState,
    required TResult Function(String categoryId) setCategory,
    required TResult Function(Map<String, String> metadata) setMetadata,
    required TResult Function() processQueue,
    required TResult Function() uploadCompleted,
    required TResult Function(String error) uploadError,
    required TResult Function(double progress) overallProgressUpdated,
    required TResult Function(String fileId, double progress)
    fileProgressUpdated,
    required TResult Function(String fileId, UploadStatus status)
    fileStatusUpdated,
    required TResult Function(List<UploadFileModel> files)
    startUploadWithProgress,
    required TResult Function() clearUploadState,
  }) {
    return overallProgressUpdated(progress);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult? Function(List<UploadFileModel> files)? startUpload,
    TResult? Function(String? fileId)? pauseUpload,
    TResult? Function(String? fileId)? resumeUpload,
    TResult? Function(String? fileId)? cancelUpload,
    TResult? Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult? Function(String fileId)? removeFile,
    TResult? Function()? clearQueue,
    TResult? Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult? Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult? Function(String fileId, String error)? fileFailed,
    TResult? Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult? Function(List<XFile> files)? validateFiles,
    TResult? Function()? resetState,
    TResult? Function(String categoryId)? setCategory,
    TResult? Function(Map<String, String> metadata)? setMetadata,
    TResult? Function()? processQueue,
    TResult? Function()? uploadCompleted,
    TResult? Function(String error)? uploadError,
    TResult? Function(double progress)? overallProgressUpdated,
    TResult? Function(String fileId, double progress)? fileProgressUpdated,
    TResult? Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult? Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult? Function()? clearUploadState,
  }) {
    return overallProgressUpdated?.call(progress);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult Function(List<UploadFileModel> files)? startUpload,
    TResult Function(String? fileId)? pauseUpload,
    TResult Function(String? fileId)? resumeUpload,
    TResult Function(String? fileId)? cancelUpload,
    TResult Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult Function(String fileId)? removeFile,
    TResult Function()? clearQueue,
    TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult Function(String fileId, String error)? fileFailed,
    TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult Function(List<XFile> files)? validateFiles,
    TResult Function()? resetState,
    TResult Function(String categoryId)? setCategory,
    TResult Function(Map<String, String> metadata)? setMetadata,
    TResult Function()? processQueue,
    TResult Function()? uploadCompleted,
    TResult Function(String error)? uploadError,
    TResult Function(double progress)? overallProgressUpdated,
    TResult Function(String fileId, double progress)? fileProgressUpdated,
    TResult Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult Function()? clearUploadState,
    required TResult orElse(),
  }) {
    if (overallProgressUpdated != null) {
      return overallProgressUpdated(progress);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddFiles value) addFiles,
    required TResult Function(StartUpload value) startUpload,
    required TResult Function(PauseUpload value) pauseUpload,
    required TResult Function(ResumeUpload value) resumeUpload,
    required TResult Function(CancelUpload value) cancelUpload,
    required TResult Function(RetryUpload value) retryUpload,
    required TResult Function(RemoveFile value) removeFile,
    required TResult Function(ClearQueue value) clearQueue,
    required TResult Function(UpdateProgress value) updateProgress,
    required TResult Function(FileCompleted value) fileCompleted,
    required TResult Function(FileFailed value) fileFailed,
    required TResult Function(UpdateSettings value) updateSettings,
    required TResult Function(ValidateFiles value) validateFiles,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SetCategory value) setCategory,
    required TResult Function(SetMetadata value) setMetadata,
    required TResult Function(ProcessQueue value) processQueue,
    required TResult Function(UploadCompleted value) uploadCompleted,
    required TResult Function(UploadError value) uploadError,
    required TResult Function(OverallProgressUpdated value)
    overallProgressUpdated,
    required TResult Function(FileProgressUpdated value) fileProgressUpdated,
    required TResult Function(FileStatusUpdated value) fileStatusUpdated,
    required TResult Function(StartUploadWithProgress value)
    startUploadWithProgress,
    required TResult Function(ClearUploadState value) clearUploadState,
  }) {
    return overallProgressUpdated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddFiles value)? addFiles,
    TResult? Function(StartUpload value)? startUpload,
    TResult? Function(PauseUpload value)? pauseUpload,
    TResult? Function(ResumeUpload value)? resumeUpload,
    TResult? Function(CancelUpload value)? cancelUpload,
    TResult? Function(RetryUpload value)? retryUpload,
    TResult? Function(RemoveFile value)? removeFile,
    TResult? Function(ClearQueue value)? clearQueue,
    TResult? Function(UpdateProgress value)? updateProgress,
    TResult? Function(FileCompleted value)? fileCompleted,
    TResult? Function(FileFailed value)? fileFailed,
    TResult? Function(UpdateSettings value)? updateSettings,
    TResult? Function(ValidateFiles value)? validateFiles,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SetCategory value)? setCategory,
    TResult? Function(SetMetadata value)? setMetadata,
    TResult? Function(ProcessQueue value)? processQueue,
    TResult? Function(UploadCompleted value)? uploadCompleted,
    TResult? Function(UploadError value)? uploadError,
    TResult? Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult? Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult? Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult? Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult? Function(ClearUploadState value)? clearUploadState,
  }) {
    return overallProgressUpdated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddFiles value)? addFiles,
    TResult Function(StartUpload value)? startUpload,
    TResult Function(PauseUpload value)? pauseUpload,
    TResult Function(ResumeUpload value)? resumeUpload,
    TResult Function(CancelUpload value)? cancelUpload,
    TResult Function(RetryUpload value)? retryUpload,
    TResult Function(RemoveFile value)? removeFile,
    TResult Function(ClearQueue value)? clearQueue,
    TResult Function(UpdateProgress value)? updateProgress,
    TResult Function(FileCompleted value)? fileCompleted,
    TResult Function(FileFailed value)? fileFailed,
    TResult Function(UpdateSettings value)? updateSettings,
    TResult Function(ValidateFiles value)? validateFiles,
    TResult Function(ResetState value)? resetState,
    TResult Function(SetCategory value)? setCategory,
    TResult Function(SetMetadata value)? setMetadata,
    TResult Function(ProcessQueue value)? processQueue,
    TResult Function(UploadCompleted value)? uploadCompleted,
    TResult Function(UploadError value)? uploadError,
    TResult Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult Function(ClearUploadState value)? clearUploadState,
    required TResult orElse(),
  }) {
    if (overallProgressUpdated != null) {
      return overallProgressUpdated(this);
    }
    return orElse();
  }
}

abstract class OverallProgressUpdated implements UploadEvent {
  const factory OverallProgressUpdated({required final double progress}) =
      _$OverallProgressUpdatedImpl;

  double get progress;

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OverallProgressUpdatedImplCopyWith<_$OverallProgressUpdatedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FileProgressUpdatedImplCopyWith<$Res> {
  factory _$$FileProgressUpdatedImplCopyWith(
    _$FileProgressUpdatedImpl value,
    $Res Function(_$FileProgressUpdatedImpl) then,
  ) = __$$FileProgressUpdatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String fileId, double progress});
}

/// @nodoc
class __$$FileProgressUpdatedImplCopyWithImpl<$Res>
    extends _$UploadEventCopyWithImpl<$Res, _$FileProgressUpdatedImpl>
    implements _$$FileProgressUpdatedImplCopyWith<$Res> {
  __$$FileProgressUpdatedImplCopyWithImpl(
    _$FileProgressUpdatedImpl _value,
    $Res Function(_$FileProgressUpdatedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? fileId = null, Object? progress = null}) {
    return _then(
      _$FileProgressUpdatedImpl(
        fileId: null == fileId
            ? _value.fileId
            : fileId // ignore: cast_nullable_to_non_nullable
                  as String,
        progress: null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$FileProgressUpdatedImpl implements FileProgressUpdated {
  const _$FileProgressUpdatedImpl({
    required this.fileId,
    required this.progress,
  });

  @override
  final String fileId;
  @override
  final double progress;

  @override
  String toString() {
    return 'UploadEvent.fileProgressUpdated(fileId: $fileId, progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileProgressUpdatedImpl &&
            (identical(other.fileId, fileId) || other.fileId == fileId) &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fileId, progress);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileProgressUpdatedImplCopyWith<_$FileProgressUpdatedImpl> get copyWith =>
      __$$FileProgressUpdatedImplCopyWithImpl<_$FileProgressUpdatedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )
    addFiles,
    required TResult Function(List<UploadFileModel> files) startUpload,
    required TResult Function(String? fileId) pauseUpload,
    required TResult Function(String? fileId) resumeUpload,
    required TResult Function(String? fileId) cancelUpload,
    required TResult Function(List<UploadFileModel> failedFiles) retryUpload,
    required TResult Function(String fileId) removeFile,
    required TResult Function() clearQueue,
    required TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )
    updateProgress,
    required TResult Function(
      String fileId,
      String downloadUrl,
      String? documentId,
    )
    fileCompleted,
    required TResult Function(String fileId, String error) fileFailed,
    required TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )
    updateSettings,
    required TResult Function(List<XFile> files) validateFiles,
    required TResult Function() resetState,
    required TResult Function(String categoryId) setCategory,
    required TResult Function(Map<String, String> metadata) setMetadata,
    required TResult Function() processQueue,
    required TResult Function() uploadCompleted,
    required TResult Function(String error) uploadError,
    required TResult Function(double progress) overallProgressUpdated,
    required TResult Function(String fileId, double progress)
    fileProgressUpdated,
    required TResult Function(String fileId, UploadStatus status)
    fileStatusUpdated,
    required TResult Function(List<UploadFileModel> files)
    startUploadWithProgress,
    required TResult Function() clearUploadState,
  }) {
    return fileProgressUpdated(fileId, progress);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult? Function(List<UploadFileModel> files)? startUpload,
    TResult? Function(String? fileId)? pauseUpload,
    TResult? Function(String? fileId)? resumeUpload,
    TResult? Function(String? fileId)? cancelUpload,
    TResult? Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult? Function(String fileId)? removeFile,
    TResult? Function()? clearQueue,
    TResult? Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult? Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult? Function(String fileId, String error)? fileFailed,
    TResult? Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult? Function(List<XFile> files)? validateFiles,
    TResult? Function()? resetState,
    TResult? Function(String categoryId)? setCategory,
    TResult? Function(Map<String, String> metadata)? setMetadata,
    TResult? Function()? processQueue,
    TResult? Function()? uploadCompleted,
    TResult? Function(String error)? uploadError,
    TResult? Function(double progress)? overallProgressUpdated,
    TResult? Function(String fileId, double progress)? fileProgressUpdated,
    TResult? Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult? Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult? Function()? clearUploadState,
  }) {
    return fileProgressUpdated?.call(fileId, progress);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult Function(List<UploadFileModel> files)? startUpload,
    TResult Function(String? fileId)? pauseUpload,
    TResult Function(String? fileId)? resumeUpload,
    TResult Function(String? fileId)? cancelUpload,
    TResult Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult Function(String fileId)? removeFile,
    TResult Function()? clearQueue,
    TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult Function(String fileId, String error)? fileFailed,
    TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult Function(List<XFile> files)? validateFiles,
    TResult Function()? resetState,
    TResult Function(String categoryId)? setCategory,
    TResult Function(Map<String, String> metadata)? setMetadata,
    TResult Function()? processQueue,
    TResult Function()? uploadCompleted,
    TResult Function(String error)? uploadError,
    TResult Function(double progress)? overallProgressUpdated,
    TResult Function(String fileId, double progress)? fileProgressUpdated,
    TResult Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult Function()? clearUploadState,
    required TResult orElse(),
  }) {
    if (fileProgressUpdated != null) {
      return fileProgressUpdated(fileId, progress);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddFiles value) addFiles,
    required TResult Function(StartUpload value) startUpload,
    required TResult Function(PauseUpload value) pauseUpload,
    required TResult Function(ResumeUpload value) resumeUpload,
    required TResult Function(CancelUpload value) cancelUpload,
    required TResult Function(RetryUpload value) retryUpload,
    required TResult Function(RemoveFile value) removeFile,
    required TResult Function(ClearQueue value) clearQueue,
    required TResult Function(UpdateProgress value) updateProgress,
    required TResult Function(FileCompleted value) fileCompleted,
    required TResult Function(FileFailed value) fileFailed,
    required TResult Function(UpdateSettings value) updateSettings,
    required TResult Function(ValidateFiles value) validateFiles,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SetCategory value) setCategory,
    required TResult Function(SetMetadata value) setMetadata,
    required TResult Function(ProcessQueue value) processQueue,
    required TResult Function(UploadCompleted value) uploadCompleted,
    required TResult Function(UploadError value) uploadError,
    required TResult Function(OverallProgressUpdated value)
    overallProgressUpdated,
    required TResult Function(FileProgressUpdated value) fileProgressUpdated,
    required TResult Function(FileStatusUpdated value) fileStatusUpdated,
    required TResult Function(StartUploadWithProgress value)
    startUploadWithProgress,
    required TResult Function(ClearUploadState value) clearUploadState,
  }) {
    return fileProgressUpdated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddFiles value)? addFiles,
    TResult? Function(StartUpload value)? startUpload,
    TResult? Function(PauseUpload value)? pauseUpload,
    TResult? Function(ResumeUpload value)? resumeUpload,
    TResult? Function(CancelUpload value)? cancelUpload,
    TResult? Function(RetryUpload value)? retryUpload,
    TResult? Function(RemoveFile value)? removeFile,
    TResult? Function(ClearQueue value)? clearQueue,
    TResult? Function(UpdateProgress value)? updateProgress,
    TResult? Function(FileCompleted value)? fileCompleted,
    TResult? Function(FileFailed value)? fileFailed,
    TResult? Function(UpdateSettings value)? updateSettings,
    TResult? Function(ValidateFiles value)? validateFiles,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SetCategory value)? setCategory,
    TResult? Function(SetMetadata value)? setMetadata,
    TResult? Function(ProcessQueue value)? processQueue,
    TResult? Function(UploadCompleted value)? uploadCompleted,
    TResult? Function(UploadError value)? uploadError,
    TResult? Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult? Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult? Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult? Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult? Function(ClearUploadState value)? clearUploadState,
  }) {
    return fileProgressUpdated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddFiles value)? addFiles,
    TResult Function(StartUpload value)? startUpload,
    TResult Function(PauseUpload value)? pauseUpload,
    TResult Function(ResumeUpload value)? resumeUpload,
    TResult Function(CancelUpload value)? cancelUpload,
    TResult Function(RetryUpload value)? retryUpload,
    TResult Function(RemoveFile value)? removeFile,
    TResult Function(ClearQueue value)? clearQueue,
    TResult Function(UpdateProgress value)? updateProgress,
    TResult Function(FileCompleted value)? fileCompleted,
    TResult Function(FileFailed value)? fileFailed,
    TResult Function(UpdateSettings value)? updateSettings,
    TResult Function(ValidateFiles value)? validateFiles,
    TResult Function(ResetState value)? resetState,
    TResult Function(SetCategory value)? setCategory,
    TResult Function(SetMetadata value)? setMetadata,
    TResult Function(ProcessQueue value)? processQueue,
    TResult Function(UploadCompleted value)? uploadCompleted,
    TResult Function(UploadError value)? uploadError,
    TResult Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult Function(ClearUploadState value)? clearUploadState,
    required TResult orElse(),
  }) {
    if (fileProgressUpdated != null) {
      return fileProgressUpdated(this);
    }
    return orElse();
  }
}

abstract class FileProgressUpdated implements UploadEvent {
  const factory FileProgressUpdated({
    required final String fileId,
    required final double progress,
  }) = _$FileProgressUpdatedImpl;

  String get fileId;
  double get progress;

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileProgressUpdatedImplCopyWith<_$FileProgressUpdatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FileStatusUpdatedImplCopyWith<$Res> {
  factory _$$FileStatusUpdatedImplCopyWith(
    _$FileStatusUpdatedImpl value,
    $Res Function(_$FileStatusUpdatedImpl) then,
  ) = __$$FileStatusUpdatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String fileId, UploadStatus status});
}

/// @nodoc
class __$$FileStatusUpdatedImplCopyWithImpl<$Res>
    extends _$UploadEventCopyWithImpl<$Res, _$FileStatusUpdatedImpl>
    implements _$$FileStatusUpdatedImplCopyWith<$Res> {
  __$$FileStatusUpdatedImplCopyWithImpl(
    _$FileStatusUpdatedImpl _value,
    $Res Function(_$FileStatusUpdatedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? fileId = null, Object? status = null}) {
    return _then(
      _$FileStatusUpdatedImpl(
        fileId: null == fileId
            ? _value.fileId
            : fileId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as UploadStatus,
      ),
    );
  }
}

/// @nodoc

class _$FileStatusUpdatedImpl implements FileStatusUpdated {
  const _$FileStatusUpdatedImpl({required this.fileId, required this.status});

  @override
  final String fileId;
  @override
  final UploadStatus status;

  @override
  String toString() {
    return 'UploadEvent.fileStatusUpdated(fileId: $fileId, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileStatusUpdatedImpl &&
            (identical(other.fileId, fileId) || other.fileId == fileId) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fileId, status);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileStatusUpdatedImplCopyWith<_$FileStatusUpdatedImpl> get copyWith =>
      __$$FileStatusUpdatedImplCopyWithImpl<_$FileStatusUpdatedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )
    addFiles,
    required TResult Function(List<UploadFileModel> files) startUpload,
    required TResult Function(String? fileId) pauseUpload,
    required TResult Function(String? fileId) resumeUpload,
    required TResult Function(String? fileId) cancelUpload,
    required TResult Function(List<UploadFileModel> failedFiles) retryUpload,
    required TResult Function(String fileId) removeFile,
    required TResult Function() clearQueue,
    required TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )
    updateProgress,
    required TResult Function(
      String fileId,
      String downloadUrl,
      String? documentId,
    )
    fileCompleted,
    required TResult Function(String fileId, String error) fileFailed,
    required TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )
    updateSettings,
    required TResult Function(List<XFile> files) validateFiles,
    required TResult Function() resetState,
    required TResult Function(String categoryId) setCategory,
    required TResult Function(Map<String, String> metadata) setMetadata,
    required TResult Function() processQueue,
    required TResult Function() uploadCompleted,
    required TResult Function(String error) uploadError,
    required TResult Function(double progress) overallProgressUpdated,
    required TResult Function(String fileId, double progress)
    fileProgressUpdated,
    required TResult Function(String fileId, UploadStatus status)
    fileStatusUpdated,
    required TResult Function(List<UploadFileModel> files)
    startUploadWithProgress,
    required TResult Function() clearUploadState,
  }) {
    return fileStatusUpdated(fileId, status);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult? Function(List<UploadFileModel> files)? startUpload,
    TResult? Function(String? fileId)? pauseUpload,
    TResult? Function(String? fileId)? resumeUpload,
    TResult? Function(String? fileId)? cancelUpload,
    TResult? Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult? Function(String fileId)? removeFile,
    TResult? Function()? clearQueue,
    TResult? Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult? Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult? Function(String fileId, String error)? fileFailed,
    TResult? Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult? Function(List<XFile> files)? validateFiles,
    TResult? Function()? resetState,
    TResult? Function(String categoryId)? setCategory,
    TResult? Function(Map<String, String> metadata)? setMetadata,
    TResult? Function()? processQueue,
    TResult? Function()? uploadCompleted,
    TResult? Function(String error)? uploadError,
    TResult? Function(double progress)? overallProgressUpdated,
    TResult? Function(String fileId, double progress)? fileProgressUpdated,
    TResult? Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult? Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult? Function()? clearUploadState,
  }) {
    return fileStatusUpdated?.call(fileId, status);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult Function(List<UploadFileModel> files)? startUpload,
    TResult Function(String? fileId)? pauseUpload,
    TResult Function(String? fileId)? resumeUpload,
    TResult Function(String? fileId)? cancelUpload,
    TResult Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult Function(String fileId)? removeFile,
    TResult Function()? clearQueue,
    TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult Function(String fileId, String error)? fileFailed,
    TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult Function(List<XFile> files)? validateFiles,
    TResult Function()? resetState,
    TResult Function(String categoryId)? setCategory,
    TResult Function(Map<String, String> metadata)? setMetadata,
    TResult Function()? processQueue,
    TResult Function()? uploadCompleted,
    TResult Function(String error)? uploadError,
    TResult Function(double progress)? overallProgressUpdated,
    TResult Function(String fileId, double progress)? fileProgressUpdated,
    TResult Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult Function()? clearUploadState,
    required TResult orElse(),
  }) {
    if (fileStatusUpdated != null) {
      return fileStatusUpdated(fileId, status);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddFiles value) addFiles,
    required TResult Function(StartUpload value) startUpload,
    required TResult Function(PauseUpload value) pauseUpload,
    required TResult Function(ResumeUpload value) resumeUpload,
    required TResult Function(CancelUpload value) cancelUpload,
    required TResult Function(RetryUpload value) retryUpload,
    required TResult Function(RemoveFile value) removeFile,
    required TResult Function(ClearQueue value) clearQueue,
    required TResult Function(UpdateProgress value) updateProgress,
    required TResult Function(FileCompleted value) fileCompleted,
    required TResult Function(FileFailed value) fileFailed,
    required TResult Function(UpdateSettings value) updateSettings,
    required TResult Function(ValidateFiles value) validateFiles,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SetCategory value) setCategory,
    required TResult Function(SetMetadata value) setMetadata,
    required TResult Function(ProcessQueue value) processQueue,
    required TResult Function(UploadCompleted value) uploadCompleted,
    required TResult Function(UploadError value) uploadError,
    required TResult Function(OverallProgressUpdated value)
    overallProgressUpdated,
    required TResult Function(FileProgressUpdated value) fileProgressUpdated,
    required TResult Function(FileStatusUpdated value) fileStatusUpdated,
    required TResult Function(StartUploadWithProgress value)
    startUploadWithProgress,
    required TResult Function(ClearUploadState value) clearUploadState,
  }) {
    return fileStatusUpdated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddFiles value)? addFiles,
    TResult? Function(StartUpload value)? startUpload,
    TResult? Function(PauseUpload value)? pauseUpload,
    TResult? Function(ResumeUpload value)? resumeUpload,
    TResult? Function(CancelUpload value)? cancelUpload,
    TResult? Function(RetryUpload value)? retryUpload,
    TResult? Function(RemoveFile value)? removeFile,
    TResult? Function(ClearQueue value)? clearQueue,
    TResult? Function(UpdateProgress value)? updateProgress,
    TResult? Function(FileCompleted value)? fileCompleted,
    TResult? Function(FileFailed value)? fileFailed,
    TResult? Function(UpdateSettings value)? updateSettings,
    TResult? Function(ValidateFiles value)? validateFiles,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SetCategory value)? setCategory,
    TResult? Function(SetMetadata value)? setMetadata,
    TResult? Function(ProcessQueue value)? processQueue,
    TResult? Function(UploadCompleted value)? uploadCompleted,
    TResult? Function(UploadError value)? uploadError,
    TResult? Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult? Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult? Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult? Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult? Function(ClearUploadState value)? clearUploadState,
  }) {
    return fileStatusUpdated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddFiles value)? addFiles,
    TResult Function(StartUpload value)? startUpload,
    TResult Function(PauseUpload value)? pauseUpload,
    TResult Function(ResumeUpload value)? resumeUpload,
    TResult Function(CancelUpload value)? cancelUpload,
    TResult Function(RetryUpload value)? retryUpload,
    TResult Function(RemoveFile value)? removeFile,
    TResult Function(ClearQueue value)? clearQueue,
    TResult Function(UpdateProgress value)? updateProgress,
    TResult Function(FileCompleted value)? fileCompleted,
    TResult Function(FileFailed value)? fileFailed,
    TResult Function(UpdateSettings value)? updateSettings,
    TResult Function(ValidateFiles value)? validateFiles,
    TResult Function(ResetState value)? resetState,
    TResult Function(SetCategory value)? setCategory,
    TResult Function(SetMetadata value)? setMetadata,
    TResult Function(ProcessQueue value)? processQueue,
    TResult Function(UploadCompleted value)? uploadCompleted,
    TResult Function(UploadError value)? uploadError,
    TResult Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult Function(ClearUploadState value)? clearUploadState,
    required TResult orElse(),
  }) {
    if (fileStatusUpdated != null) {
      return fileStatusUpdated(this);
    }
    return orElse();
  }
}

abstract class FileStatusUpdated implements UploadEvent {
  const factory FileStatusUpdated({
    required final String fileId,
    required final UploadStatus status,
  }) = _$FileStatusUpdatedImpl;

  String get fileId;
  UploadStatus get status;

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileStatusUpdatedImplCopyWith<_$FileStatusUpdatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StartUploadWithProgressImplCopyWith<$Res> {
  factory _$$StartUploadWithProgressImplCopyWith(
    _$StartUploadWithProgressImpl value,
    $Res Function(_$StartUploadWithProgressImpl) then,
  ) = __$$StartUploadWithProgressImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<UploadFileModel> files});
}

/// @nodoc
class __$$StartUploadWithProgressImplCopyWithImpl<$Res>
    extends _$UploadEventCopyWithImpl<$Res, _$StartUploadWithProgressImpl>
    implements _$$StartUploadWithProgressImplCopyWith<$Res> {
  __$$StartUploadWithProgressImplCopyWithImpl(
    _$StartUploadWithProgressImpl _value,
    $Res Function(_$StartUploadWithProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? files = null}) {
    return _then(
      _$StartUploadWithProgressImpl(
        files: null == files
            ? _value._files
            : files // ignore: cast_nullable_to_non_nullable
                  as List<UploadFileModel>,
      ),
    );
  }
}

/// @nodoc

class _$StartUploadWithProgressImpl implements StartUploadWithProgress {
  const _$StartUploadWithProgressImpl({
    required final List<UploadFileModel> files,
  }) : _files = files;

  final List<UploadFileModel> _files;
  @override
  List<UploadFileModel> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  @override
  String toString() {
    return 'UploadEvent.startUploadWithProgress(files: $files)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StartUploadWithProgressImpl &&
            const DeepCollectionEquality().equals(other._files, _files));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_files));

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StartUploadWithProgressImplCopyWith<_$StartUploadWithProgressImpl>
  get copyWith =>
      __$$StartUploadWithProgressImplCopyWithImpl<
        _$StartUploadWithProgressImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )
    addFiles,
    required TResult Function(List<UploadFileModel> files) startUpload,
    required TResult Function(String? fileId) pauseUpload,
    required TResult Function(String? fileId) resumeUpload,
    required TResult Function(String? fileId) cancelUpload,
    required TResult Function(List<UploadFileModel> failedFiles) retryUpload,
    required TResult Function(String fileId) removeFile,
    required TResult Function() clearQueue,
    required TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )
    updateProgress,
    required TResult Function(
      String fileId,
      String downloadUrl,
      String? documentId,
    )
    fileCompleted,
    required TResult Function(String fileId, String error) fileFailed,
    required TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )
    updateSettings,
    required TResult Function(List<XFile> files) validateFiles,
    required TResult Function() resetState,
    required TResult Function(String categoryId) setCategory,
    required TResult Function(Map<String, String> metadata) setMetadata,
    required TResult Function() processQueue,
    required TResult Function() uploadCompleted,
    required TResult Function(String error) uploadError,
    required TResult Function(double progress) overallProgressUpdated,
    required TResult Function(String fileId, double progress)
    fileProgressUpdated,
    required TResult Function(String fileId, UploadStatus status)
    fileStatusUpdated,
    required TResult Function(List<UploadFileModel> files)
    startUploadWithProgress,
    required TResult Function() clearUploadState,
  }) {
    return startUploadWithProgress(files);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult? Function(List<UploadFileModel> files)? startUpload,
    TResult? Function(String? fileId)? pauseUpload,
    TResult? Function(String? fileId)? resumeUpload,
    TResult? Function(String? fileId)? cancelUpload,
    TResult? Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult? Function(String fileId)? removeFile,
    TResult? Function()? clearQueue,
    TResult? Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult? Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult? Function(String fileId, String error)? fileFailed,
    TResult? Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult? Function(List<XFile> files)? validateFiles,
    TResult? Function()? resetState,
    TResult? Function(String categoryId)? setCategory,
    TResult? Function(Map<String, String> metadata)? setMetadata,
    TResult? Function()? processQueue,
    TResult? Function()? uploadCompleted,
    TResult? Function(String error)? uploadError,
    TResult? Function(double progress)? overallProgressUpdated,
    TResult? Function(String fileId, double progress)? fileProgressUpdated,
    TResult? Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult? Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult? Function()? clearUploadState,
  }) {
    return startUploadWithProgress?.call(files);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult Function(List<UploadFileModel> files)? startUpload,
    TResult Function(String? fileId)? pauseUpload,
    TResult Function(String? fileId)? resumeUpload,
    TResult Function(String? fileId)? cancelUpload,
    TResult Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult Function(String fileId)? removeFile,
    TResult Function()? clearQueue,
    TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult Function(String fileId, String error)? fileFailed,
    TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult Function(List<XFile> files)? validateFiles,
    TResult Function()? resetState,
    TResult Function(String categoryId)? setCategory,
    TResult Function(Map<String, String> metadata)? setMetadata,
    TResult Function()? processQueue,
    TResult Function()? uploadCompleted,
    TResult Function(String error)? uploadError,
    TResult Function(double progress)? overallProgressUpdated,
    TResult Function(String fileId, double progress)? fileProgressUpdated,
    TResult Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult Function()? clearUploadState,
    required TResult orElse(),
  }) {
    if (startUploadWithProgress != null) {
      return startUploadWithProgress(files);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddFiles value) addFiles,
    required TResult Function(StartUpload value) startUpload,
    required TResult Function(PauseUpload value) pauseUpload,
    required TResult Function(ResumeUpload value) resumeUpload,
    required TResult Function(CancelUpload value) cancelUpload,
    required TResult Function(RetryUpload value) retryUpload,
    required TResult Function(RemoveFile value) removeFile,
    required TResult Function(ClearQueue value) clearQueue,
    required TResult Function(UpdateProgress value) updateProgress,
    required TResult Function(FileCompleted value) fileCompleted,
    required TResult Function(FileFailed value) fileFailed,
    required TResult Function(UpdateSettings value) updateSettings,
    required TResult Function(ValidateFiles value) validateFiles,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SetCategory value) setCategory,
    required TResult Function(SetMetadata value) setMetadata,
    required TResult Function(ProcessQueue value) processQueue,
    required TResult Function(UploadCompleted value) uploadCompleted,
    required TResult Function(UploadError value) uploadError,
    required TResult Function(OverallProgressUpdated value)
    overallProgressUpdated,
    required TResult Function(FileProgressUpdated value) fileProgressUpdated,
    required TResult Function(FileStatusUpdated value) fileStatusUpdated,
    required TResult Function(StartUploadWithProgress value)
    startUploadWithProgress,
    required TResult Function(ClearUploadState value) clearUploadState,
  }) {
    return startUploadWithProgress(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddFiles value)? addFiles,
    TResult? Function(StartUpload value)? startUpload,
    TResult? Function(PauseUpload value)? pauseUpload,
    TResult? Function(ResumeUpload value)? resumeUpload,
    TResult? Function(CancelUpload value)? cancelUpload,
    TResult? Function(RetryUpload value)? retryUpload,
    TResult? Function(RemoveFile value)? removeFile,
    TResult? Function(ClearQueue value)? clearQueue,
    TResult? Function(UpdateProgress value)? updateProgress,
    TResult? Function(FileCompleted value)? fileCompleted,
    TResult? Function(FileFailed value)? fileFailed,
    TResult? Function(UpdateSettings value)? updateSettings,
    TResult? Function(ValidateFiles value)? validateFiles,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SetCategory value)? setCategory,
    TResult? Function(SetMetadata value)? setMetadata,
    TResult? Function(ProcessQueue value)? processQueue,
    TResult? Function(UploadCompleted value)? uploadCompleted,
    TResult? Function(UploadError value)? uploadError,
    TResult? Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult? Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult? Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult? Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult? Function(ClearUploadState value)? clearUploadState,
  }) {
    return startUploadWithProgress?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddFiles value)? addFiles,
    TResult Function(StartUpload value)? startUpload,
    TResult Function(PauseUpload value)? pauseUpload,
    TResult Function(ResumeUpload value)? resumeUpload,
    TResult Function(CancelUpload value)? cancelUpload,
    TResult Function(RetryUpload value)? retryUpload,
    TResult Function(RemoveFile value)? removeFile,
    TResult Function(ClearQueue value)? clearQueue,
    TResult Function(UpdateProgress value)? updateProgress,
    TResult Function(FileCompleted value)? fileCompleted,
    TResult Function(FileFailed value)? fileFailed,
    TResult Function(UpdateSettings value)? updateSettings,
    TResult Function(ValidateFiles value)? validateFiles,
    TResult Function(ResetState value)? resetState,
    TResult Function(SetCategory value)? setCategory,
    TResult Function(SetMetadata value)? setMetadata,
    TResult Function(ProcessQueue value)? processQueue,
    TResult Function(UploadCompleted value)? uploadCompleted,
    TResult Function(UploadError value)? uploadError,
    TResult Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult Function(ClearUploadState value)? clearUploadState,
    required TResult orElse(),
  }) {
    if (startUploadWithProgress != null) {
      return startUploadWithProgress(this);
    }
    return orElse();
  }
}

abstract class StartUploadWithProgress implements UploadEvent {
  const factory StartUploadWithProgress({
    required final List<UploadFileModel> files,
  }) = _$StartUploadWithProgressImpl;

  List<UploadFileModel> get files;

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StartUploadWithProgressImplCopyWith<_$StartUploadWithProgressImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ClearUploadStateImplCopyWith<$Res> {
  factory _$$ClearUploadStateImplCopyWith(
    _$ClearUploadStateImpl value,
    $Res Function(_$ClearUploadStateImpl) then,
  ) = __$$ClearUploadStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ClearUploadStateImplCopyWithImpl<$Res>
    extends _$UploadEventCopyWithImpl<$Res, _$ClearUploadStateImpl>
    implements _$$ClearUploadStateImplCopyWith<$Res> {
  __$$ClearUploadStateImplCopyWithImpl(
    _$ClearUploadStateImpl _value,
    $Res Function(_$ClearUploadStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UploadEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ClearUploadStateImpl implements ClearUploadState {
  const _$ClearUploadStateImpl();

  @override
  String toString() {
    return 'UploadEvent.clearUploadState()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ClearUploadStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )
    addFiles,
    required TResult Function(List<UploadFileModel> files) startUpload,
    required TResult Function(String? fileId) pauseUpload,
    required TResult Function(String? fileId) resumeUpload,
    required TResult Function(String? fileId) cancelUpload,
    required TResult Function(List<UploadFileModel> failedFiles) retryUpload,
    required TResult Function(String fileId) removeFile,
    required TResult Function() clearQueue,
    required TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )
    updateProgress,
    required TResult Function(
      String fileId,
      String downloadUrl,
      String? documentId,
    )
    fileCompleted,
    required TResult Function(String fileId, String error) fileFailed,
    required TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )
    updateSettings,
    required TResult Function(List<XFile> files) validateFiles,
    required TResult Function() resetState,
    required TResult Function(String categoryId) setCategory,
    required TResult Function(Map<String, String> metadata) setMetadata,
    required TResult Function() processQueue,
    required TResult Function() uploadCompleted,
    required TResult Function(String error) uploadError,
    required TResult Function(double progress) overallProgressUpdated,
    required TResult Function(String fileId, double progress)
    fileProgressUpdated,
    required TResult Function(String fileId, UploadStatus status)
    fileStatusUpdated,
    required TResult Function(List<UploadFileModel> files)
    startUploadWithProgress,
    required TResult Function() clearUploadState,
  }) {
    return clearUploadState();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult? Function(List<UploadFileModel> files)? startUpload,
    TResult? Function(String? fileId)? pauseUpload,
    TResult? Function(String? fileId)? resumeUpload,
    TResult? Function(String? fileId)? cancelUpload,
    TResult? Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult? Function(String fileId)? removeFile,
    TResult? Function()? clearQueue,
    TResult? Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult? Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult? Function(String fileId, String error)? fileFailed,
    TResult? Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult? Function(List<XFile> files)? validateFiles,
    TResult? Function()? resetState,
    TResult? Function(String categoryId)? setCategory,
    TResult? Function(Map<String, String> metadata)? setMetadata,
    TResult? Function()? processQueue,
    TResult? Function()? uploadCompleted,
    TResult? Function(String error)? uploadError,
    TResult? Function(double progress)? overallProgressUpdated,
    TResult? Function(String fileId, double progress)? fileProgressUpdated,
    TResult? Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult? Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult? Function()? clearUploadState,
  }) {
    return clearUploadState?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      List<XFile> files,
      String? categoryId,
      Map<String, String>? customMetadata,
      bool checkDuplicates,
    )?
    addFiles,
    TResult Function(List<UploadFileModel> files)? startUpload,
    TResult Function(String? fileId)? pauseUpload,
    TResult Function(String? fileId)? resumeUpload,
    TResult Function(String? fileId)? cancelUpload,
    TResult Function(List<UploadFileModel> failedFiles)? retryUpload,
    TResult Function(String fileId)? removeFile,
    TResult Function()? clearQueue,
    TResult Function(
      String fileId,
      double progress,
      int bytesUploaded,
      int totalBytes,
    )?
    updateProgress,
    TResult Function(String fileId, String downloadUrl, String? documentId)?
    fileCompleted,
    TResult Function(String fileId, String error)? fileFailed,
    TResult Function(
      int? maxConcurrentUploads,
      int? chunkSize,
      int? retryAttempts,
    )?
    updateSettings,
    TResult Function(List<XFile> files)? validateFiles,
    TResult Function()? resetState,
    TResult Function(String categoryId)? setCategory,
    TResult Function(Map<String, String> metadata)? setMetadata,
    TResult Function()? processQueue,
    TResult Function()? uploadCompleted,
    TResult Function(String error)? uploadError,
    TResult Function(double progress)? overallProgressUpdated,
    TResult Function(String fileId, double progress)? fileProgressUpdated,
    TResult Function(String fileId, UploadStatus status)? fileStatusUpdated,
    TResult Function(List<UploadFileModel> files)? startUploadWithProgress,
    TResult Function()? clearUploadState,
    required TResult orElse(),
  }) {
    if (clearUploadState != null) {
      return clearUploadState();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddFiles value) addFiles,
    required TResult Function(StartUpload value) startUpload,
    required TResult Function(PauseUpload value) pauseUpload,
    required TResult Function(ResumeUpload value) resumeUpload,
    required TResult Function(CancelUpload value) cancelUpload,
    required TResult Function(RetryUpload value) retryUpload,
    required TResult Function(RemoveFile value) removeFile,
    required TResult Function(ClearQueue value) clearQueue,
    required TResult Function(UpdateProgress value) updateProgress,
    required TResult Function(FileCompleted value) fileCompleted,
    required TResult Function(FileFailed value) fileFailed,
    required TResult Function(UpdateSettings value) updateSettings,
    required TResult Function(ValidateFiles value) validateFiles,
    required TResult Function(ResetState value) resetState,
    required TResult Function(SetCategory value) setCategory,
    required TResult Function(SetMetadata value) setMetadata,
    required TResult Function(ProcessQueue value) processQueue,
    required TResult Function(UploadCompleted value) uploadCompleted,
    required TResult Function(UploadError value) uploadError,
    required TResult Function(OverallProgressUpdated value)
    overallProgressUpdated,
    required TResult Function(FileProgressUpdated value) fileProgressUpdated,
    required TResult Function(FileStatusUpdated value) fileStatusUpdated,
    required TResult Function(StartUploadWithProgress value)
    startUploadWithProgress,
    required TResult Function(ClearUploadState value) clearUploadState,
  }) {
    return clearUploadState(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddFiles value)? addFiles,
    TResult? Function(StartUpload value)? startUpload,
    TResult? Function(PauseUpload value)? pauseUpload,
    TResult? Function(ResumeUpload value)? resumeUpload,
    TResult? Function(CancelUpload value)? cancelUpload,
    TResult? Function(RetryUpload value)? retryUpload,
    TResult? Function(RemoveFile value)? removeFile,
    TResult? Function(ClearQueue value)? clearQueue,
    TResult? Function(UpdateProgress value)? updateProgress,
    TResult? Function(FileCompleted value)? fileCompleted,
    TResult? Function(FileFailed value)? fileFailed,
    TResult? Function(UpdateSettings value)? updateSettings,
    TResult? Function(ValidateFiles value)? validateFiles,
    TResult? Function(ResetState value)? resetState,
    TResult? Function(SetCategory value)? setCategory,
    TResult? Function(SetMetadata value)? setMetadata,
    TResult? Function(ProcessQueue value)? processQueue,
    TResult? Function(UploadCompleted value)? uploadCompleted,
    TResult? Function(UploadError value)? uploadError,
    TResult? Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult? Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult? Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult? Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult? Function(ClearUploadState value)? clearUploadState,
  }) {
    return clearUploadState?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddFiles value)? addFiles,
    TResult Function(StartUpload value)? startUpload,
    TResult Function(PauseUpload value)? pauseUpload,
    TResult Function(ResumeUpload value)? resumeUpload,
    TResult Function(CancelUpload value)? cancelUpload,
    TResult Function(RetryUpload value)? retryUpload,
    TResult Function(RemoveFile value)? removeFile,
    TResult Function(ClearQueue value)? clearQueue,
    TResult Function(UpdateProgress value)? updateProgress,
    TResult Function(FileCompleted value)? fileCompleted,
    TResult Function(FileFailed value)? fileFailed,
    TResult Function(UpdateSettings value)? updateSettings,
    TResult Function(ValidateFiles value)? validateFiles,
    TResult Function(ResetState value)? resetState,
    TResult Function(SetCategory value)? setCategory,
    TResult Function(SetMetadata value)? setMetadata,
    TResult Function(ProcessQueue value)? processQueue,
    TResult Function(UploadCompleted value)? uploadCompleted,
    TResult Function(UploadError value)? uploadError,
    TResult Function(OverallProgressUpdated value)? overallProgressUpdated,
    TResult Function(FileProgressUpdated value)? fileProgressUpdated,
    TResult Function(FileStatusUpdated value)? fileStatusUpdated,
    TResult Function(StartUploadWithProgress value)? startUploadWithProgress,
    TResult Function(ClearUploadState value)? clearUploadState,
    required TResult orElse(),
  }) {
    if (clearUploadState != null) {
      return clearUploadState(this);
    }
    return orElse();
  }
}

abstract class ClearUploadState implements UploadEvent {
  const factory ClearUploadState() = _$ClearUploadStateImpl;
}
