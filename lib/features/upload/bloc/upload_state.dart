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
  const factory UploadState.validating({
    String? message,
  }) = UploadValidating;

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
}

/// Extension methods for UploadState
extension UploadStateExtension on UploadState {
  /// Get the current list of files regardless of state
  List<UploadFileModel> get currentFiles {
    return when(
      initial: () => <UploadFileModel>[],
      validating: (_) => <UploadFileModel>[],
      ready: (files, _, __, ___, ____) => files,
      uploading: (files, _, __, ___, ____, _____, ______, _______, ________, _________) => files,
      paused: (files, _, __, ___, ____, _____, ______, _______) => files,
      completed: (files, _, __, ___, ____, _____, ______) => files,
      error: (_, files, __, ___) => files ?? <UploadFileModel>[],
      cancelled: (files, _, __) => files,
    );
  }

  /// Check if upload is in progress
  bool get isUploading {
    return when(
      initial: () => false,
      validating: (_) => false,
      ready: (_, __, ___, ____, _____) => false,
      uploading: (_, __, ___, ____, _____, ______, _______, ________, _________, __________) => true,
      paused: (_, __, ___, ____, _____, ______, _______, ________) => false,
      completed: (_, __, ___, ____, _____, ______, _______) => false,
      error: (_, __, ___, ____) => false,
      cancelled: (_, __, ___) => false,
    );
  }

  /// Check if upload is paused
  bool get isPaused {
    return when(
      initial: () => false,
      validating: (_) => false,
      ready: (_, __, ___, ____, _____) => false,
      uploading: (_, __, ___, ____, _____, ______, _______, ________, _________, __________) => false,
      paused: (_, __, ___, ____, _____, ______, _______, ________) => true,
      completed: (_, __, ___, ____, _____, ______, _______) => false,
      error: (_, __, ___, ____) => false,
      cancelled: (_, __, ___) => false,
    );
  }

  /// Check if upload is completed
  bool get isCompleted {
    return when(
      initial: () => false,
      validating: (_) => false,
      ready: (_, __, ___, ____, _____) => false,
      uploading: (_, __, ___, ____, _____, ______, _______, ________, _________, __________) => false,
      paused: (_, __, ___, ____, _____, ______, _______, ________) => false,
      completed: (_, __, ___, ____, _____, ______, _______) => true,
      error: (_, __, ___, ____) => false,
      cancelled: (_, __, ___) => false,
    );
  }

  /// Check if there's an error
  bool get hasError {
    return when(
      initial: () => false,
      validating: (_) => false,
      ready: (_, __, ___, ____, _____) => false,
      uploading: (_, __, ___, ____, _____, ______, _______, ________, _________, __________) => false,
      paused: (_, __, ___, ____, _____, ______, _______, ________) => false,
      completed: (_, __, ___, ____, _____, ______, _______) => false,
      error: (_, __, ___, ____) => true,
      cancelled: (_, __, ___) => false,
    );
  }

  /// Get total number of files
  int get totalFiles {
    return when(
      initial: () => 0,
      validating: (_) => 0,
      ready: (_, totalFiles, __, ___, ____) => totalFiles,
      uploading: (_, __, ___, ____, totalFiles, _____, ______, _______, ________, _________) => totalFiles,
      paused: (_, __, ___, totalFiles, ____, _____, ______, _______) => totalFiles,
      completed: (_, __, ___, totalFiles, ____, _____, ______) => totalFiles,
      error: (_, files, __, ___) => files?.length ?? 0,
      cancelled: (files, _, __) => files.length,
    );
  }

  /// Get overall progress
  double get progress {
    return when(
      initial: () => 0.0,
      validating: (_) => 0.0,
      ready: (_, __, ___, ____, _____) => 0.0,
      uploading: (_, __, ___, ____, _____, overallProgress, ______, _______, ________, _________) => overallProgress,
      paused: (_, __, ___, ____, overallProgress, _____, ______, _______) => overallProgress,
      completed: (_, __, ___, ____, _____, ______, _______) => 1.0,
      error: (_, __, ___, ____) => 0.0,
      cancelled: (_, __, ___) => 0.0,
    );
  }
}
