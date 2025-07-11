import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/upload_file_model.dart';

part 'upload_state.freezed.dart';

/// Upload States for UploadBloc
///
/// These states represent all possible states of the upload system.
@freezed
class UploadState with _$UploadState {
  /// Initial state when UploadBloc is first created
  const factory UploadState.initial() = UploadInitial;

  /// State when files are being validated
  ///
  /// [message] - Validation status message
  const factory UploadState.validating({String? message}) = UploadValidating;

  /// State when upload queue is ready but not started
  ///
  /// [files] - Files in upload queue
  /// [totalFiles] - Total number of files
  /// [totalSize] - Total size of all files in bytes
  /// [categoryId] - Selected category for uploads
  /// [customMetadata] - Custom metadata for uploads
  const factory UploadState.ready({
    required List<UploadFileModel> files,
    required int totalFiles,
    required int totalSize,
    String? categoryId,
    Map<String, String>? customMetadata,
  }) = UploadReady;

  /// State when upload is in progress
  ///
  /// [files] - Files in upload queue with current status
  /// [activeUploads] - Number of currently active uploads
  /// [completedFiles] - Number of completed uploads
  /// [failedFiles] - Number of failed uploads
  /// [totalFiles] - Total number of files
  /// [overallProgress] - Overall upload progress (0.0 to 1.0)
  /// [uploadSpeed] - Current upload speed in bytes per second
  /// [estimatedTimeRemaining] - Estimated time remaining in seconds
  /// [categoryId] - Selected category for uploads
  /// [customMetadata] - Custom metadata for uploads
  const factory UploadState.uploading({
    required List<UploadFileModel> files,
    required int activeUploads,
    required int completedFiles,
    required int failedFiles,
    required int totalFiles,
    required double overallProgress,
    int? uploadSpeed,
    int? estimatedTimeRemaining,
    String? categoryId,
    Map<String, String>? customMetadata,
  }) = UploadUploading;

  /// State when upload is paused
  ///
  /// [files] - Files in upload queue with current status
  /// [completedFiles] - Number of completed uploads
  /// [failedFiles] - Number of failed uploads
  /// [totalFiles] - Total number of files
  /// [overallProgress] - Overall upload progress (0.0 to 1.0)
  /// [pausedFiles] - Number of paused files
  /// [categoryId] - Selected category for uploads
  /// [customMetadata] - Custom metadata for uploads
  const factory UploadState.paused({
    required List<UploadFileModel> files,
    required int completedFiles,
    required int failedFiles,
    required int totalFiles,
    required double overallProgress,
    required int pausedFiles,
    String? categoryId,
    Map<String, String>? customMetadata,
  }) = UploadPaused;

  /// State when all uploads are completed
  ///
  /// [files] - All files with final status
  /// [completedFiles] - Number of successfully completed uploads
  /// [failedFiles] - Number of failed uploads
  /// [totalFiles] - Total number of files
  /// [totalUploadTime] - Total time taken for uploads in seconds
  /// [categoryId] - Category used for uploads
  /// [customMetadata] - Custom metadata used for uploads
  const factory UploadState.completed({
    required List<UploadFileModel> files,
    required int completedFiles,
    required int failedFiles,
    required int totalFiles,
    int? totalUploadTime,
    String? categoryId,
    Map<String, String>? customMetadata,
  }) = UploadCompleted;

  /// State when upload encounters an error
  ///
  /// [message] - Error message
  /// [files] - Files in upload queue (if any)
  /// [canRetry] - Whether the operation can be retried
  /// [previousState] - Previous state before error (optional)
  const factory UploadState.error({
    required String message,
    List<UploadFileModel>? files,
    @Default(true) bool canRetry,
    UploadState? previousState,
  }) = UploadError;

  /// State when upload is cancelled
  ///
  /// [files] - Files that were in upload queue
  /// [completedFiles] - Number of files that completed before cancellation
  /// [cancelledFiles] - Number of files that were cancelled
  const factory UploadState.cancelled({
    required List<UploadFileModel> files,
    required int completedFiles,
    required int cancelledFiles,
  }) = UploadCancelled;

  /// State when upload is successful
  ///
  /// [uploadedFiles] - Successfully uploaded files
  /// [totalFiles] - Total number of files
  /// [totalUploadTime] - Total time taken for upload
  const factory UploadState.success({
    required List<UploadFileModel> uploadedFiles,
    required int totalFiles,
    int? totalUploadTime,
  }) = UploadSuccess;

  /// State when upload is in progress with detailed progress
  ///
  /// [files] - Files being uploaded
  /// [currentFile] - Currently uploading file
  /// [progress] - Current progress (0.0 to 1.0)
  /// [uploadSpeed] - Current upload speed
  const factory UploadState.inProgress({
    required List<UploadFileModel> files,
    required UploadFileModel currentFile,
    required double progress,
    int? uploadSpeed,
  }) = UploadInProgress;

  /// State when upload has partial success
  ///
  /// [successfulFiles] - Successfully uploaded files
  /// [failedFiles] - Failed upload files
  /// [totalFiles] - Total number of files
  const factory UploadState.partialSuccess({
    required List<UploadFileModel> successfulFiles,
    required List<UploadFileModel> failedFiles,
    required int totalFiles,
  }) = UploadPartialSuccess;

  /// State when upload fails due to network error
  ///
  /// [message] - Network error message
  /// [files] - Files that failed to upload
  const factory UploadState.networkError({
    required String message,
    required List<UploadFileModel> files,
  }) = UploadNetworkError;

  /// State when upload fails due to storage error
  ///
  /// [message] - Storage error message
  /// [files] - Files that failed to upload
  const factory UploadState.storageError({
    required String message,
    required List<UploadFileModel> files,
  }) = UploadStorageError;

  /// State when upload validation fails
  ///
  /// [message] - Validation error message
  /// [invalidFiles] - Files that failed validation
  const factory UploadState.validationError({
    required String message,
    required List<UploadFileModel> invalidFiles,
  }) = UploadValidationError;
}

/// Extension methods for UploadState
extension UploadStateExtension on UploadState {
  /// Get the current list of files regardless of state
  List<UploadFileModel> get currentFiles {
    return when(
      initial: () => <UploadFileModel>[],
      validating: (_) => <UploadFileModel>[],
      ready: (files, _, __, ___, ____) => files,
      uploading:
          (
            files,
            _,
            __,
            ___,
            ____,
            _____,
            ______,
            _______,
            ________,
            _________,
          ) => files,
      paused: (files, _, __, ___, ____, _____, ______, _______) => files,
      completed: (files, _, __, ___, ____, _____, ______) => files,
      error: (_, files, __, ___) => files ?? <UploadFileModel>[],
      cancelled: (files, _, __) => files,
      success: (uploadedFiles, _, __) => uploadedFiles,
      inProgress: (files, _, __, ___) => files,
      partialSuccess: (successfulFiles, failedFiles, _) => [
        ...successfulFiles,
        ...failedFiles,
      ],
      networkError: (_, files) => files,
      storageError: (_, files) => files,
      validationError: (_, invalidFiles) => invalidFiles,
    );
  }

  /// Check if upload is in progress
  bool get isUploading {
    return when(
      initial: () => false,
      validating: (_) => false,
      ready: (_, __, ___, ____, _____) => false,
      uploading:
          (
            _,
            __,
            ___,
            ____,
            _____,
            ______,
            _______,
            ________,
            _________,
            __________,
          ) => true,
      paused: (_, __, ___, ____, _____, ______, _______, ________) => false,
      completed: (_, __, ___, ____, _____, ______, _______) => false,
      error: (_, __, ___, ____) => false,
      cancelled: (_, __, ___) => false,
      success: (_, __, ___) => false,
      inProgress: (_, __, ___, ____) => true,
      partialSuccess: (_, __, ___) => false,
      networkError: (_, __) => false,
      storageError: (_, __) => false,
      validationError: (_, __) => false,
    );
  }

  /// Check if upload is paused
  bool get isPaused {
    return when(
      initial: () => false,
      validating: (_) => false,
      ready: (_, __, ___, ____, _____) => false,
      uploading:
          (
            _,
            __,
            ___,
            ____,
            _____,
            ______,
            _______,
            ________,
            _________,
            __________,
          ) => false,
      paused: (_, __, ___, ____, _____, ______, _______, ________) => true,
      completed: (_, __, ___, ____, _____, ______, _______) => false,
      error: (_, __, ___, ____) => false,
      cancelled: (_, __, ___) => false,
      success: (_, __, ___) => false,
      inProgress: (_, __, ___, ____) => false,
      partialSuccess: (_, __, ___) => false,
      networkError: (_, __) => false,
      storageError: (_, __) => false,
      validationError: (_, __) => false,
    );
  }

  /// Check if upload is completed
  bool get isCompleted {
    return when(
      initial: () => false,
      validating: (_) => false,
      ready: (_, __, ___, ____, _____) => false,
      uploading:
          (
            _,
            __,
            ___,
            ____,
            _____,
            ______,
            _______,
            ________,
            _________,
            __________,
          ) => false,
      paused: (_, __, ___, ____, _____, ______, _______, ________) => false,
      completed: (_, __, ___, ____, _____, ______, _______) => true,
      error: (_, __, ___, ____) => false,
      cancelled: (_, __, ___) => false,
      success: (_, __, ___) => true,
      inProgress: (_, __, ___, ____) => false,
      partialSuccess: (_, __, ___) => true,
      networkError: (_, __) => false,
      storageError: (_, __) => false,
      validationError: (_, __) => false,
    );
  }

  /// Check if there's an error
  bool get hasError {
    return when(
      initial: () => false,
      validating: (_) => false,
      ready: (_, __, ___, ____, _____) => false,
      uploading:
          (
            _,
            __,
            ___,
            ____,
            _____,
            ______,
            _______,
            ________,
            _________,
            __________,
          ) => false,
      paused: (_, __, ___, ____, _____, ______, _______, ________) => false,
      completed: (_, __, ___, ____, _____, ______, _______) => false,
      error: (_, __, ___, ____) => true,
      cancelled: (_, __, ___) => false,
      success: (_, __, ___) => false,
      inProgress: (_, __, ___, ____) => false,
      partialSuccess: (_, __, ___) => false,
      networkError: (_, __) => true,
      storageError: (_, __) => true,
      validationError: (_, __) => true,
    );
  }

  /// Get total number of files
  int get totalFiles {
    return when(
      initial: () => 0,
      validating: (_) => 0,
      ready: (_, totalFiles, __, ___, ____) => totalFiles,
      uploading:
          (
            _,
            __,
            ___,
            ____,
            totalFiles,
            _____,
            ______,
            _______,
            ________,
            _________,
          ) => totalFiles,
      paused: (_, __, ___, totalFiles, ____, _____, ______, _______) =>
          totalFiles,
      completed: (_, __, ___, totalFiles, ____, _____, ______) => totalFiles,
      error: (_, files, __, ___) => files?.length ?? 0,
      cancelled: (files, _, __) => files.length,
      success: (_, totalFiles, __) => totalFiles,
      inProgress: (files, _, __, ___) => files.length,
      partialSuccess: (_, __, totalFiles) => totalFiles,
      networkError: (_, files) => files.length,
      storageError: (_, files) => files.length,
      validationError: (_, invalidFiles) => invalidFiles.length,
    );
  }

  /// Get overall progress
  double get progress {
    return when(
      initial: () => 0.0,
      validating: (_) => 0.0,
      ready: (_, __, ___, ____, _____) => 0.0,
      uploading:
          (
            _,
            __,
            ___,
            ____,
            _____,
            overallProgress,
            ______,
            _______,
            ________,
            _________,
          ) => overallProgress,
      paused: (_, __, ___, ____, overallProgress, _____, ______, _______) =>
          overallProgress,
      completed: (_, __, ___, ____, _____, ______, _______) => 1.0,
      error: (_, __, ___, ____) => 0.0,
      cancelled: (_, __, ___) => 0.0,
      success: (_, __, ___) => 1.0,
      inProgress: (_, __, progress, ___) => progress,
      partialSuccess: (successfulFiles, failedFiles, totalFiles) =>
          successfulFiles.length / totalFiles,
      networkError: (_, __) => 0.0,
      storageError: (_, __) => 0.0,
      validationError: (_, __) => 0.0,
    );
  }
}
