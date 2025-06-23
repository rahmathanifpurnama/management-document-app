/// Centralized file configuration for upload functionality
class FileConfig {
  // Allowed file extensions
  static const List<String> allowedExtensions = [
    'pdf',
    'doc',
    'docx',
    'pptx',
    'txt',
    'jpg',
    'jpeg',
    'png',
    'xlsx',
    'xls',
    'csv',
  ];

  // Maximum file size (15MB)
  static const int maxFileSize = 15 * 1024 * 1024;

  // MIME type mappings
  static const Map<String, String> mimeTypeMap = {
    'pdf': 'application/pdf',
    'doc': 'application/msword',
    'docx':
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'xls': 'application/vnd.ms-excel',
    'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'csv': 'text/csv',
    'ppt': 'application/vnd.ms-powerpoint',
    'pptx':
        'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'gif': 'image/gif',
    'txt': 'text/plain',
  };

  // File type groups for display
  static const Map<String, List<String>> fileTypeGroups = {
    'document': ['pdf', 'doc', 'docx', 'txt'],
    'spreadsheet': ['xls', 'xlsx', 'csv'],
    'presentation': ['ppt', 'pptx'],
    'image': ['jpg', 'jpeg', 'png', 'gif'],
  };

  // Display names for file types
  static const Map<String, String> fileTypeDisplayNames = {
    'pdf': 'PDF',
    'doc': 'Word Document',
    'docx': 'Word Document',
    'xls': 'Excel Spreadsheet',
    'xlsx': 'Excel Spreadsheet',
    'csv': 'CSV Spreadsheet',
    'ppt': 'PowerPoint Presentation',
    'pptx': 'PowerPoint Presentation',
    'jpg': 'Image',
    'jpeg': 'Image',
    'png': 'Image',
    'gif': 'Image',
    'txt': 'Text Document',
  };

  /// Get MIME type for file extension
  static String getMimeType(String fileName) {
    final extension = getFileExtension(fileName);
    return mimeTypeMap[extension] ?? 'application/octet-stream';
  }

  /// Get file extension from filename
  static String getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }

  /// Check if file extension is allowed
  static bool isExtensionAllowed(String fileName) {
    final extension = getFileExtension(fileName);
    return allowedExtensions.contains(extension);
  }

  /// Check if file size is allowed
  static bool isFileSizeAllowed(int fileSize) {
    return fileSize > 0 && fileSize <= maxFileSize;
  }

  /// Get file type category
  static String getFileTypeCategory(String fileName) {
    final extension = getFileExtension(fileName);

    for (final entry in fileTypeGroups.entries) {
      if (entry.value.contains(extension)) {
        return entry.key;
      }
    }

    return 'other';
  }

  /// Get display name for file type
  static String getFileTypeDisplayName(String fileName) {
    final extension = getFileExtension(fileName);
    return fileTypeDisplayNames[extension] ?? 'Unknown';
  }

  /// Format file size for display
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  /// Get maximum file size formatted
  static String get maxFileSizeFormatted => formatFileSize(maxFileSize);
}
