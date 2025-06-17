import 'package:file_selector/file_selector.dart';
import '../utils/filename_utils.dart';

enum UploadStatus { pending, uploading, paused, completed, failed, cancelled }

class UploadFileModel {
  final String id;
  final String fileName;
  final int fileSize;
  final String fileType;
  final XFile file;
  final String? categoryId;
  final Map<String, String>? customMetadata;

  UploadStatus status;
  double progress;
  String? errorMessage;
  String? downloadUrl;
  String? documentId;
  DateTime? uploadStartTime;
  DateTime? uploadEndTime;
  bool isAiProcessing;

  UploadFileModel({
    required this.id,
    required this.fileName,
    required this.fileSize,
    required this.fileType,
    required this.file,
    this.categoryId,
    this.customMetadata,
    this.status = UploadStatus.pending,
    this.progress = 0.0,
    this.errorMessage,
    this.downloadUrl,
    this.documentId,
    this.uploadStartTime,
    this.uploadEndTime,
    this.isAiProcessing = false,
  });

  // Create from XFile
  static Future<UploadFileModel> fromXFile(
    XFile file, {
    String? categoryId,
    Map<String, String>? customMetadata,
  }) async {
    final fileSize = await file.length();
    return UploadFileModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fileName: file.name,
      fileSize: fileSize,
      fileType: _getFileType(file.name),
      file: file,
      categoryId: categoryId,
      customMetadata: customMetadata,
    );
  }

  // Get file type from extension
  static String _getFileType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case 'txt':
        return 'text/plain';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'xls':
        return 'application/vnd.ms-excel';
      default:
        return 'application/octet-stream';
    }
  }

  // Get clean display filename without timestamp prefix
  String get displayFileName {
    return FilenameUtils.getDisplayFileName(fileName);
  }

  // Get file type icon
  String get fileTypeIcon {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'PDF';
      case 'doc':
      case 'docx':
        return 'DOC';
      case 'pptx':
        return 'PPT';
      case 'txt':
        return 'TXT';
      case 'jpg':
      case 'jpeg':
      case 'png':
        return 'IMG';
      case 'xlsx':
      case 'xls':
        return 'XLS';
      default:
        return 'FILE';
    }
  }

  // Get formatted file size
  String get formattedFileSize {
    if (fileSize == 0) return '0 B';

    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var size = fileSize.toDouble();
    var suffixIndex = 0;

    while (size >= 1024 && suffixIndex < suffixes.length - 1) {
      size /= 1024;
      suffixIndex++;
    }

    return '${size.toStringAsFixed(size < 10 ? 1 : 0)} ${suffixes[suffixIndex]}';
  }

  // Get estimated time remaining
  String get estimatedTimeRemaining {
    if (status == UploadStatus.completed) return 'Completed';
    if (status == UploadStatus.failed) return 'Failed';
    if (status == UploadStatus.cancelled) return 'Cancelled';
    if (status == UploadStatus.paused) return 'Paused';
    if (progress == 0) return 'Calculating...';

    final elapsed = uploadStartTime != null
        ? DateTime.now().difference(uploadStartTime!).inSeconds
        : 0;

    if (elapsed == 0 || progress == 0) return 'Calculating...';

    final totalEstimated = elapsed / (progress / 100);
    final remaining = totalEstimated - elapsed;

    if (remaining <= 0) return 'Almost done';
    if (remaining < 60) return '${remaining.round()}s';
    if (remaining < 3600) return '${(remaining / 60).round()}m';

    return '${(remaining / 3600).round()}h';
  }

  // Copy with new values
  UploadFileModel copyWith({
    UploadStatus? status,
    double? progress,
    String? errorMessage,
    String? downloadUrl,
    String? documentId,
    DateTime? uploadStartTime,
    DateTime? uploadEndTime,
    bool? isAiProcessing,
    int? fileSize,
    String? categoryId,
    Map<String, String>? customMetadata,
  }) {
    return UploadFileModel(
      id: id,
      fileName: fileName,
      fileSize: fileSize ?? this.fileSize,
      fileType: fileType,
      file: file,
      categoryId: categoryId ?? this.categoryId,
      customMetadata: customMetadata ?? this.customMetadata,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      errorMessage: errorMessage ?? this.errorMessage,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      documentId: documentId ?? this.documentId,
      uploadStartTime: uploadStartTime ?? this.uploadStartTime,
      uploadEndTime: uploadEndTime ?? this.uploadEndTime,
      isAiProcessing: isAiProcessing ?? this.isAiProcessing,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'fileSize': fileSize,
      'fileType': fileType,
      'status': status.name,
      'progress': progress,
      'errorMessage': errorMessage,
      'downloadUrl': downloadUrl,
      'uploadStartTime': uploadStartTime?.toIso8601String(),
      'uploadEndTime': uploadEndTime?.toIso8601String(),
      'isAiProcessing': isAiProcessing,
    };
  }
}
