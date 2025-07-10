import 'package:file_selector/file_selector.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_file_model.freezed.dart';
part 'upload_file_model.g.dart';

/// Upload File Status
enum UploadStatus {
  pending,
  validating,
  uploading,
  paused,
  completed,
  failed,
  cancelled,
}

/// Upload File Model
///
/// Represents a file in the upload queue with its current status and progress.
@freezed
class UploadFileModel with _$UploadFileModel {
  const factory UploadFileModel({
    /// Unique identifier for this upload
    required String id,

    /// Original file (not serialized)
    @JsonKey(includeFromJson: false, includeToJson: false) XFile? file,

    /// File name
    required String fileName,

    /// File size in bytes
    required int fileSize,

    /// File type/extension
    required String fileType,

    /// MIME type
    required String mimeType,

    /// Current upload status
    @Default(UploadStatus.pending) UploadStatus status,

    /// Upload progress (0.0 to 1.0)
    @Default(0.0) double progress,

    /// Bytes uploaded
    @Default(0) int bytesUploaded,

    /// Upload speed in bytes per second
    int? uploadSpeed,

    /// Estimated time remaining in seconds
    int? estimatedTimeRemaining,

    /// Error message if upload failed
    String? errorMessage,

    /// Number of retry attempts
    @Default(0) int retryAttempts,

    /// Maximum retry attempts allowed
    @Default(3) int maxRetryAttempts,

    /// Category ID for this file
    String? categoryId,

    /// Custom metadata for this file
    Map<String, String>? customMetadata,

    /// Download URL after successful upload
    String? downloadUrl,

    /// Document ID in Firestore after successful upload
    String? documentId,

    /// Upload start time
    DateTime? startTime,

    /// Upload completion time
    DateTime? completionTime,

    /// File hash for duplicate detection
    String? fileHash,

    /// Validation errors
    List<String>? validationErrors,
  }) = _UploadFileModel;

  factory UploadFileModel.fromJson(Map<String, dynamic> json) =>
      _$UploadFileModelFromJson(json);

  /// Create UploadFileModel from XFile
  static Future<UploadFileModel> fromXFile(
    XFile xFile, {
    String? categoryId,
    Map<String, String>? customMetadata,
  }) async {
    final fileSize = await xFile.length();
    final fileName = xFile.name;
    final fileType = _getFileType(fileName);
    final mimeType = xFile.mimeType ?? _getMimeType(fileName);

    // Generate unique ID for upload tracking
    final uploadId = DateTime.now().millisecondsSinceEpoch.toString();

    return UploadFileModel(
      id: uploadId,
      file: xFile,
      fileName: fileName,
      fileSize: fileSize,
      fileType: fileType,
      mimeType: mimeType,
      categoryId: categoryId,
      customMetadata: customMetadata,
    );
  }

  /// Get file type from file name
  static String _getFileType(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    return extension.isNotEmpty ? extension : 'unknown';
  }

  /// Get MIME type from file name
  static String _getMimeType(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;

    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'txt':
        return 'text/plain';
      case 'rtf':
        return 'application/rtf';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'bmp':
        return 'image/bmp';
      case 'mp4':
        return 'video/mp4';
      case 'avi':
        return 'video/x-msvideo';
      case 'mov':
        return 'video/quicktime';
      case 'wmv':
        return 'video/x-ms-wmv';
      case 'flv':
        return 'video/x-flv';
      case 'mp3':
        return 'audio/mpeg';
      case 'wav':
        return 'audio/wav';
      case 'aac':
        return 'audio/aac';
      case 'flac':
        return 'audio/flac';
      case 'zip':
        return 'application/zip';
      case 'rar':
        return 'application/x-rar-compressed';
      case '7z':
        return 'application/x-7z-compressed';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'ppt':
        return 'application/vnd.ms-powerpoint';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      default:
        return 'application/octet-stream';
    }
  }
}

/// Extension methods for UploadFileModel
extension UploadFileModelExtension on UploadFileModel {
  /// Check if file can be uploaded
  bool get canUpload {
    return status == UploadStatus.pending ||
        status == UploadStatus.paused ||
        (status == UploadStatus.failed && retryAttempts < maxRetryAttempts);
  }

  /// Check if file can be paused
  bool get canPause {
    return status == UploadStatus.uploading;
  }

  /// Check if file can be resumed
  bool get canResume {
    return status == UploadStatus.paused;
  }

  /// Check if file can be cancelled
  bool get canCancel {
    return status == UploadStatus.pending ||
        status == UploadStatus.validating ||
        status == UploadStatus.uploading ||
        status == UploadStatus.paused;
  }

  /// Check if file can be retried
  bool get canRetry {
    return status == UploadStatus.failed && retryAttempts < maxRetryAttempts;
  }

  /// Check if file is in progress
  bool get isInProgress {
    return status == UploadStatus.validating ||
        status == UploadStatus.uploading;
  }

  /// Check if file is completed
  bool get isCompleted {
    return status == UploadStatus.completed;
  }

  /// Check if file has failed
  bool get hasFailed {
    return status == UploadStatus.failed;
  }

  /// Check if file is cancelled
  bool get isCancelled {
    return status == UploadStatus.cancelled;
  }

  /// Get upload duration in seconds
  int? get uploadDuration {
    if (startTime == null) return null;
    final endTime = completionTime ?? DateTime.now();
    return endTime.difference(startTime!).inSeconds;
  }

  /// Get formatted file size
  String get formattedFileSize {
    if (fileSize < 1024) {
      return '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    } else if (fileSize < 1024 * 1024 * 1024) {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(fileSize / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Get formatted upload speed
  String? get formattedUploadSpeed {
    if (uploadSpeed == null) return null;

    if (uploadSpeed! < 1024) {
      return '$uploadSpeed B/s';
    } else if (uploadSpeed! < 1024 * 1024) {
      return '${(uploadSpeed! / 1024).toStringAsFixed(1)} KB/s';
    } else {
      return '${(uploadSpeed! / (1024 * 1024)).toStringAsFixed(1)} MB/s';
    }
  }

  /// Get formatted estimated time remaining
  String? get formattedTimeRemaining {
    if (estimatedTimeRemaining == null) return null;

    final duration = Duration(seconds: estimatedTimeRemaining!);
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  /// Get status display text
  String get statusText {
    switch (status) {
      case UploadStatus.pending:
        return 'Pending';
      case UploadStatus.validating:
        return 'Validating';
      case UploadStatus.uploading:
        return 'Uploading';
      case UploadStatus.paused:
        return 'Paused';
      case UploadStatus.completed:
        return 'Completed';
      case UploadStatus.failed:
        return 'Failed';
      case UploadStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// Get progress percentage
  String get progressPercentage {
    return '${(progress * 100).toStringAsFixed(1)}%';
  }

  /// Create a copy with updated progress
  UploadFileModel withProgress({
    required double progress,
    required int bytesUploaded,
    int? uploadSpeed,
    int? estimatedTimeRemaining,
  }) {
    return copyWith(
      progress: progress,
      bytesUploaded: bytesUploaded,
      uploadSpeed: uploadSpeed,
      estimatedTimeRemaining: estimatedTimeRemaining,
      status: progress >= 1.0 ? UploadStatus.completed : UploadStatus.uploading,
    );
  }

  /// Create a copy with error
  UploadFileModel withError(String error) {
    return copyWith(
      status: UploadStatus.failed,
      errorMessage: error,
      retryAttempts: retryAttempts + 1,
    );
  }

  /// Create a copy with completion
  UploadFileModel withCompletion({
    required String downloadUrl,
    String? documentId,
  }) {
    return copyWith(
      status: UploadStatus.completed,
      progress: 1.0,
      bytesUploaded: fileSize,
      downloadUrl: downloadUrl,
      documentId: documentId,
      completionTime: DateTime.now(),
    );
  }
}
