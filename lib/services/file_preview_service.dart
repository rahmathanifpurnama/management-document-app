import 'package:flutter/foundation.dart';
import '../models/document_model.dart';
import '../core/services/firebase_service.dart';

enum FilePreviewType { image, pdf, document, video, audio, text, unsupported }

class FilePreviewService {
  final FirebaseService _firebaseService = FirebaseService.instance;

  /// Get the preview type for a document
  FilePreviewType getPreviewType(DocumentModel document) {
    final extension = document.fileExtension.toLowerCase();
    final fileType = document.fileType.toLowerCase();

    // Image files
    if (_isImageFile(extension, fileType)) {
      return FilePreviewType.image;
    }

    // PDF files
    if (_isPdfFile(extension, fileType)) {
      return FilePreviewType.pdf;
    }

    // Video files
    if (_isVideoFile(extension, fileType)) {
      return FilePreviewType.video;
    }

    // Audio files
    if (_isAudioFile(extension, fileType)) {
      return FilePreviewType.audio;
    }

    // Text files
    if (_isTextFile(extension, fileType)) {
      return FilePreviewType.text;
    }

    // Document files (Word, Excel, PowerPoint)
    if (_isDocumentFile(extension, fileType)) {
      return FilePreviewType.document;
    }

    return FilePreviewType.unsupported;
  }

  /// Get download URL for file preview
  Future<String> getPreviewUrl(DocumentModel document) async {
    try {
      // If document already has a download URL in filePath, use it
      if (document.filePath.startsWith('http')) {
        return document.filePath;
      }

      // Otherwise, get download URL from Firebase Storage using the storage path
      if (document.filePath.isNotEmpty) {
        final storageRef = _firebaseService.storage.ref().child(
          document.filePath,
        );
        final downloadUrl = await storageRef.getDownloadURL();
        return downloadUrl;
      }

      throw Exception('No valid file path found');
    } catch (e) {
      debugPrint('Error getting preview URL: $e');
      rethrow;
    }
  }

  /// Check if file can be previewed
  bool canPreview(DocumentModel document) {
    return getPreviewType(document) != FilePreviewType.unsupported;
  }

  /// Get appropriate viewer URL for document files (Word, Excel, PowerPoint, CSV)
  String getDocumentViewerUrl(String downloadUrl, FilePreviewType type) {
    // Use Google Docs Viewer for document files
    // This supports Word, Excel, PowerPoint, and CSV files
    final encodedUrl = Uri.encodeComponent(downloadUrl);
    return 'https://docs.google.com/gview?embedded=true&url=$encodedUrl';
  }

  /// Get file type display name
  String getFileTypeDisplayName(FilePreviewType type) {
    switch (type) {
      case FilePreviewType.image:
        return 'Image';
      case FilePreviewType.pdf:
        return 'PDF Document';
      case FilePreviewType.document:
        return 'Document';
      case FilePreviewType.video:
        return 'Video';
      case FilePreviewType.audio:
        return 'Audio';
      case FilePreviewType.text:
        return 'Text File';
      case FilePreviewType.unsupported:
        return 'Unsupported Format';
    }
  }

  // Helper methods for file type detection
  bool _isImageFile(String extension, String fileType) {
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension) ||
        fileType.contains('image');
  }

  bool _isPdfFile(String extension, String fileType) {
    return extension == 'pdf' || fileType.contains('pdf');
  }

  bool _isVideoFile(String extension, String fileType) {
    return ['mp4', 'avi', 'mov', 'mkv', 'webm', '3gp'].contains(extension) ||
        fileType.contains('video');
  }

  bool _isAudioFile(String extension, String fileType) {
    return ['mp3', 'wav', 'aac', 'm4a', 'ogg'].contains(extension) ||
        fileType.contains('audio');
  }

  bool _isTextFile(String extension, String fileType) {
    return ['txt', 'md', 'json', 'xml'].contains(extension) ||
        fileType.contains('text');
  }

  bool _isDocumentFile(String extension, String fileType) {
    return [
          'doc',
          'docx',
          'xls',
          'xlsx',
          'csv',
          'ppt',
          'pptx',
        ].contains(extension) ||
        fileType.contains('word') ||
        fileType.contains('excel') ||
        fileType.contains('powerpoint') ||
        fileType.contains('sheet') ||
        fileType.contains('presentation') ||
        fileType.contains('csv');
  }
}
