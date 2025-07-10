import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:file_selector/file_selector.dart';

part 'upload_event.freezed.dart';

/// Upload Events for UploadBloc
/// 
/// These events represent all possible actions that can be performed
/// during file upload operations.
@freezed
class UploadEvent with _$UploadEvent {
  /// Add files to upload queue
  /// 
  /// [files] - List of files to upload
  /// [categoryId] - Category to assign to uploaded files (optional)
  /// [customMetadata] - Additional metadata for files (optional)
  /// [checkDuplicates] - Whether to check for duplicate files
  const factory UploadEvent.addFiles({
    required List<XFile> files,
    String? categoryId,
    Map<String, String>? customMetadata,
    @Default(true) bool checkDuplicates,
  }) = AddFiles;

  /// Start upload process
  const factory UploadEvent.startUpload() = StartUpload;

  /// Pause upload process
  /// 
  /// [fileId] - Specific file to pause (optional, pauses all if null)
  const factory UploadEvent.pauseUpload({
    String? fileId,
  }) = PauseUpload;

  /// Resume upload process
  /// 
  /// [fileId] - Specific file to resume (optional, resumes all if null)
  const factory UploadEvent.resumeUpload({
    String? fileId,
  }) = ResumeUpload;

  /// Cancel upload process
  /// 
  /// [fileId] - Specific file to cancel (optional, cancels all if null)
  const factory UploadEvent.cancelUpload({
    String? fileId,
  }) = CancelUpload;

  /// Retry failed upload
  /// 
  /// [fileId] - Specific file to retry
  const factory UploadEvent.retryUpload({
    required String fileId,
  }) = RetryUpload;

  /// Remove file from upload queue
  /// 
  /// [fileId] - File to remove from queue
  const factory UploadEvent.removeFile({
    required String fileId,
  }) = RemoveFile;

  /// Clear all files from upload queue
  const factory UploadEvent.clearQueue() = ClearQueue;

  /// Update upload progress for a specific file
  /// 
  /// [fileId] - File being uploaded
  /// [progress] - Upload progress (0.0 to 1.0)
  /// [bytesUploaded] - Number of bytes uploaded
  /// [totalBytes] - Total file size in bytes
  const factory UploadEvent.updateProgress({
    required String fileId,
    required double progress,
    required int bytesUploaded,
    required int totalBytes,
  }) = UpdateProgress;

  /// Mark file upload as completed
  /// 
  /// [fileId] - File that completed upload
  /// [downloadUrl] - Download URL of uploaded file
  /// [documentId] - Document ID in Firestore
  const factory UploadEvent.fileCompleted({
    required String fileId,
    required String downloadUrl,
    String? documentId,
  }) = FileCompleted;

  /// Mark file upload as failed
  /// 
  /// [fileId] - File that failed to upload
  /// [error] - Error message
  const factory UploadEvent.fileFailed({
    required String fileId,
    required String error,
  }) = FileFailed;

  /// Update upload settings
  /// 
  /// [maxConcurrentUploads] - Maximum number of concurrent uploads
  /// [chunkSize] - Upload chunk size in bytes
  /// [retryAttempts] - Number of retry attempts for failed uploads
  const factory UploadEvent.updateSettings({
    int? maxConcurrentUploads,
    int? chunkSize,
    int? retryAttempts,
  }) = UpdateSettings;

  /// Validate files before upload
  /// 
  /// [files] - Files to validate
  const factory UploadEvent.validateFiles({
    required List<XFile> files,
  }) = ValidateFiles;

  /// Reset upload state
  const factory UploadEvent.resetState() = ResetState;

  /// Set category for pending uploads
  /// 
  /// [categoryId] - Category ID to assign
  const factory UploadEvent.setCategory({
    required String categoryId,
  }) = SetCategory;

  /// Set custom metadata for pending uploads
  /// 
  /// [metadata] - Custom metadata to assign
  const factory UploadEvent.setMetadata({
    required Map<String, String> metadata,
  }) = SetMetadata;

  /// Process upload queue (internal event)
  const factory UploadEvent.processQueue() = ProcessQueue;

  /// Handle upload completion (internal event)
  const factory UploadEvent.uploadCompleted() = UploadCompleted;

  /// Handle upload error (internal event)
  /// 
  /// [error] - Error that occurred
  const factory UploadEvent.uploadError({
    required String error,
  }) = UploadError;
}
