import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_result_model.freezed.dart';
part 'upload_result_model.g.dart';

/// Model representing the result of an upload operation
@freezed
class UploadResult with _$UploadResult {
  const factory UploadResult({
    required bool success,
    required String fileId,
    required String fileName,
    String? downloadUrl,
    String? thumbnailUrl,
    String? error,
    String? errorCode,
    Map<String, dynamic>? metadata,
    @Default(0) int fileSize,
    DateTime? uploadedAt,
    String? category,
    String? description,
  }) = _UploadResult;

  factory UploadResult.fromJson(Map<String, dynamic> json) =>
      _$UploadResultFromJson(json);

  /// Create a successful upload result
  factory UploadResult.success({
    required String fileId,
    required String fileName,
    String? downloadUrl,
    String? thumbnailUrl,
    Map<String, dynamic>? metadata,
    int fileSize = 0,
    String? category,
    String? description,
  }) {
    return UploadResult(
      success: true,
      fileId: fileId,
      fileName: fileName,
      downloadUrl: downloadUrl,
      thumbnailUrl: thumbnailUrl,
      metadata: metadata,
      fileSize: fileSize,
      uploadedAt: DateTime.now(),
      category: category,
      description: description,
    );
  }

  /// Create a failed upload result
  factory UploadResult.failure({
    required String fileId,
    required String fileName,
    required String error,
    String? errorCode,
    Map<String, dynamic>? metadata,
  }) {
    return UploadResult(
      success: false,
      fileId: fileId,
      fileName: fileName,
      error: error,
      errorCode: errorCode,
      metadata: metadata,
    );
  }

  /// Create a network error result
  factory UploadResult.networkError({
    required String fileId,
    required String fileName,
  }) {
    return UploadResult.failure(
      fileId: fileId,
      fileName: fileName,
      error: 'Network connection failed',
      errorCode: 'NETWORK_ERROR',
    );
  }

  /// Create a storage error result
  factory UploadResult.storageError({
    required String fileId,
    required String fileName,
    String? specificError,
  }) {
    return UploadResult.failure(
      fileId: fileId,
      fileName: fileName,
      error: specificError ?? 'Storage operation failed',
      errorCode: 'STORAGE_ERROR',
    );
  }

  /// Create a validation error result
  factory UploadResult.validationError({
    required String fileId,
    required String fileName,
    required String validationMessage,
  }) {
    return UploadResult.failure(
      fileId: fileId,
      fileName: fileName,
      error: validationMessage,
      errorCode: 'VALIDATION_ERROR',
    );
  }
}

/// Extension methods for UploadResult
extension UploadResultExtension on UploadResult {
  /// Check if this is a network error
  bool get isNetworkError => errorCode == 'NETWORK_ERROR';

  /// Check if this is a storage error
  bool get isStorageError => errorCode == 'STORAGE_ERROR';

  /// Check if this is a validation error
  bool get isValidationError => errorCode == 'VALIDATION_ERROR';

  /// Get formatted file size
  String get formattedFileSize {
    if (fileSize < 1024) return '$fileSize B';
    if (fileSize < 1024 * 1024) return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    if (fileSize < 1024 * 1024 * 1024) return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(fileSize / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Get user-friendly error message
  String get userFriendlyError {
    if (success) return '';
    
    switch (errorCode) {
      case 'NETWORK_ERROR':
        return 'Please check your internet connection and try again.';
      case 'STORAGE_ERROR':
        return 'There was a problem saving your file. Please try again.';
      case 'VALIDATION_ERROR':
        return error ?? 'The file did not pass validation.';
      default:
        return error ?? 'An unknown error occurred during upload.';
    }
  }

  /// Check if upload can be retried
  bool get canRetry {
    return !success && (isNetworkError || isStorageError);
  }
}

/// Batch upload result containing multiple upload results
@freezed
class BatchUploadResult with _$BatchUploadResult {
  const factory BatchUploadResult({
    required List<UploadResult> results,
    required int totalFiles,
    required int successCount,
    required int failureCount,
    @Default([]) List<String> errors,
    DateTime? completedAt,
  }) = _BatchUploadResult;

  factory BatchUploadResult.fromJson(Map<String, dynamic> json) =>
      _$BatchUploadResultFromJson(json);

  factory BatchUploadResult.fromResults(List<UploadResult> results) {
    final successCount = results.where((r) => r.success).length;
    final failureCount = results.length - successCount;
    final errors = results
        .where((r) => !r.success)
        .map((r) => r.error ?? 'Unknown error')
        .toList();

    return BatchUploadResult(
      results: results,
      totalFiles: results.length,
      successCount: successCount,
      failureCount: failureCount,
      errors: errors,
      completedAt: DateTime.now(),
    );
  }
}

/// Extension methods for BatchUploadResult
extension BatchUploadResultExtension on BatchUploadResult {
  /// Check if all uploads were successful
  bool get allSuccessful => failureCount == 0;

  /// Check if all uploads failed
  bool get allFailed => successCount == 0;

  /// Check if some uploads were successful
  bool get partialSuccess => successCount > 0 && failureCount > 0;

  /// Get success rate as percentage
  double get successRate => totalFiles > 0 ? (successCount / totalFiles) * 100 : 0;

  /// Get list of successful results
  List<UploadResult> get successfulResults => results.where((r) => r.success).toList();

  /// Get list of failed results
  List<UploadResult> get failedResults => results.where((r) => !r.success).toList();

  /// Get list of retryable failed results
  List<UploadResult> get retryableResults => failedResults.where((r) => r.canRetry).toList();
}
