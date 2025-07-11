import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cross_file/cross_file.dart';

part 'selected_file_model.freezed.dart';
part 'selected_file_model.g.dart';

/// Model representing a selected file for upload
@freezed
class SelectedFileModel with _$SelectedFileModel {
  const factory SelectedFileModel({
    required String id,
    required String name,
    required String path,
    required int size,
    required String type,
    required DateTime selectedAt,
    @Default(false) bool isUploading,
    @Default(0.0) double uploadProgress,
    String? category,
    String? description,
    Map<String, dynamic>? metadata,
    @JsonKey(includeFromJson: false, includeToJson: false) XFile? file,
  }) = _SelectedFileModel;

  factory SelectedFileModel.fromJson(Map<String, dynamic> json) =>
      _$SelectedFileModelFromJson(json);

  factory SelectedFileModel.fromXFile(
    XFile file, {
    String? category,
    String? description,
    Map<String, dynamic>? metadata,
  }) {
    return SelectedFileModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: file.name,
      path: file.path,
      size: 0, // Will be updated when file size is available
      type: file.mimeType ?? _getFileTypeFromExtension(file.name),
      selectedAt: DateTime.now(),
      category: category,
      description: description,
      metadata: metadata,
      file: file,
    );
  }

  static String _getFileTypeFromExtension(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
      case 'docx':
        return 'application/msword';
      case 'xls':
      case 'xlsx':
        return 'application/vnd.ms-excel';
      case 'ppt':
      case 'pptx':
        return 'application/vnd.ms-powerpoint';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'txt':
        return 'text/plain';
      default:
        return 'application/octet-stream';
    }
  }
}

/// Extension methods for SelectedFileModel
extension SelectedFileModelExtension on SelectedFileModel {
  /// Check if file is an image
  bool get isImage => type.startsWith('image/');

  /// Check if file is a document
  bool get isDocument =>
      type.contains('pdf') ||
      type.contains('word') ||
      type.contains('excel') ||
      type.contains('powerpoint');

  /// Get formatted file size
  String get formattedSize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    if (size < 1024 * 1024 * 1024) {
      return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Get file extension
  String get extension => name.split('.').last.toLowerCase();

  /// Create a copy with updated upload progress
  SelectedFileModel withProgress(double progress) {
    return copyWith(uploadProgress: progress);
  }

  /// Create a copy marking as uploading
  SelectedFileModel asUploading() {
    return copyWith(isUploading: true, uploadProgress: 0.0);
  }

  /// Create a copy marking upload as complete
  SelectedFileModel asUploadComplete() {
    return copyWith(isUploading: false, uploadProgress: 1.0);
  }
}
