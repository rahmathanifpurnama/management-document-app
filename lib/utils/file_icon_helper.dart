import 'package:flutter/material.dart';

/// Helper class for determining file icons based on file extensions
class FileIconHelper {
  /// Get appropriate icon for a file based on its name/extension
  static IconData getFileIcon(String fileName) {
    final extension = _getFileExtension(fileName).toLowerCase();

    switch (extension) {
      // Document files
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'txt':
        return Icons.text_snippet;
      case 'rtf':
        return Icons.text_fields;

      // Spreadsheet files
      case 'xls':
      case 'xlsx':
      case 'csv':
        return Icons.table_chart;

      // Presentation files
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;

      // Image files
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'webp':
        return Icons.image;
      case 'svg':
        return Icons.image;

      // Video files
      case 'mp4':
      case 'avi':
      case 'mov':
      case 'wmv':
      case 'flv':
      case 'webm':
        return Icons.video_file;

      // Audio files
      case 'mp3':
      case 'wav':
      case 'flac':
      case 'aac':
      case 'ogg':
        return Icons.audio_file;

      // Archive files
      case 'zip':
      case 'rar':
      case '7z':
      case 'tar':
      case 'gz':
        return Icons.archive;

      // Code files
      case 'dart':
      case 'js':
      case 'ts':
      case 'html':
      case 'css':
      case 'json':
      case 'xml':
      case 'yaml':
      case 'yml':
        return Icons.code;

      // Default for unknown file types
      default:
        return Icons.insert_drive_file;
    }
  }

  /// Get file extension from filename
  static String _getFileExtension(String fileName) {
    final lastDotIndex = fileName.lastIndexOf('.');
    if (lastDotIndex == -1 || lastDotIndex == fileName.length - 1) {
      return '';
    }
    return fileName.substring(lastDotIndex + 1);
  }

  /// Get file type category for grouping
  static String getFileCategory(String fileName) {
    final extension = _getFileExtension(fileName).toLowerCase();

    if (['pdf', 'doc', 'docx', 'txt', 'rtf'].contains(extension)) {
      return 'Document';
    } else if (['xls', 'xlsx', 'csv'].contains(extension)) {
      return 'Spreadsheet';
    } else if (['ppt', 'pptx'].contains(extension)) {
      return 'Presentation';
    } else if ([
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp',
      'webp',
      'svg',
    ].contains(extension)) {
      return 'Image';
    } else if ([
      'mp4',
      'avi',
      'mov',
      'wmv',
      'flv',
      'webm',
    ].contains(extension)) {
      return 'Video';
    } else if (['mp3', 'wav', 'flac', 'aac', 'ogg'].contains(extension)) {
      return 'Audio';
    } else if (['zip', 'rar', '7z', 'tar', 'gz'].contains(extension)) {
      return 'Archive';
    } else if ([
      'dart',
      'js',
      'ts',
      'html',
      'css',
      'json',
      'xml',
      'yaml',
      'yml',
    ].contains(extension)) {
      return 'Code';
    } else {
      return 'Other';
    }
  }

  /// Check if file is an image
  static bool isImageFile(String fileName) {
    final extension = _getFileExtension(fileName).toLowerCase();
    return [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp',
      'webp',
      'svg',
    ].contains(extension);
  }

  /// Check if file is a document
  static bool isDocumentFile(String fileName) {
    final extension = _getFileExtension(fileName).toLowerCase();
    return ['pdf', 'doc', 'docx', 'txt', 'rtf'].contains(extension);
  }

  /// Check if file is a video
  static bool isVideoFile(String fileName) {
    final extension = _getFileExtension(fileName).toLowerCase();
    return ['mp4', 'avi', 'mov', 'wmv', 'flv', 'webm'].contains(extension);
  }

  /// Check if file is an audio file
  static bool isAudioFile(String fileName) {
    final extension = _getFileExtension(fileName).toLowerCase();
    return ['mp3', 'wav', 'flac', 'aac', 'ogg'].contains(extension);
  }

  /// Get color for file type
  static Color getFileTypeColor(String fileName) {
    final extension = _getFileExtension(fileName).toLowerCase();

    switch (extension) {
      case 'pdf':
        return const Color(0xFFD32F2F); // Red
      case 'doc':
      case 'docx':
        return const Color(0xFF1976D2); // Blue
      case 'xls':
      case 'xlsx':
        return const Color(0xFF388E3C); // Green
      case 'ppt':
      case 'pptx':
        return const Color(0xFFD84315); // Orange
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return const Color(0xFF7B1FA2); // Purple
      case 'mp4':
      case 'avi':
      case 'mov':
        return const Color(0xFFE91E63); // Pink
      case 'mp3':
      case 'wav':
        return const Color(0xFF00BCD4); // Cyan
      case 'zip':
      case 'rar':
        return const Color(0xFF795548); // Brown
      default:
        return const Color(0xFF616161); // Grey
    }
  }
}
