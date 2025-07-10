import 'dart:async';
import 'package:cross_file/cross_file.dart';

import '../models/upload_file_model.dart';

/// Upload Repository Interface
///
/// This interface defines the contract for upload operations.
/// It provides methods for managing upload queues, progress tracking,
/// and file upload operations.
abstract class UploadRepository {
  /// Add files to upload queue
  Future<List<UploadFileModel>> addFilesToQueue(
    List<XFile> files, {
    String? categoryId,
    Map<String, String>? customMetadata,
    bool checkDuplicates = true,
  });

  /// Start upload process
  Future<void> startUpload();

  /// Pause upload for specific file
  Future<void> pauseUpload(String fileId);

  /// Resume upload for specific file
  Future<void> resumeUpload(String fileId);

  /// Cancel upload for specific file
  Future<void> cancelUpload(String fileId);

  /// Retry failed upload
  Future<void> retryUpload(String fileId);

  /// Remove file from queue
  Future<void> removeFromQueue(String fileId);

  /// Clear upload queue
  Future<void> clearQueue();

  /// Get upload queue
  List<UploadFileModel> getUploadQueue();

  /// Get upload progress stream for specific file
  Stream<double> getUploadProgress(String fileId);

  /// Get overall upload progress
  Stream<double> getOverallProgress();

  /// Get upload status stream
  Stream<UploadStatus> getUploadStatus(String fileId);

  /// Check if upload is in progress
  bool get isUploading;

  /// Get upload statistics
  Map<String, dynamic> getUploadStatistics();

  /// Validate files before upload
  Future<List<String>> validateFiles(List<XFile> files);

  /// Check for duplicate files
  Future<List<Map<String, dynamic>>> checkForDuplicates(
    List<UploadFileModel> files,
  );

  /// Update upload settings
  void updateSettings({
    int? maxConcurrentUploads,
    int? chunkSize,
    int? retryAttempts,
  });

  /// Dispose resources
  void dispose();
}
