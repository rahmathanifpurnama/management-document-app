/// Upload configuration and constants
class UploadConfig {
  // File size limits
  static const int maxFileSizeBytes = 15 * 1024 * 1024; // 15MB
  static const int maxFileSizeBytesLocal =
      10 * 1024 * 1024; // 10MB for local validation

  // Timeout settings
  static const Duration uploadTimeout = Duration(minutes: 5);
  static const Duration cloudFunctionsTimeout = Duration(minutes: 3);

  // Retry settings
  static const int maxRetries = 2;
  static const Duration retryDelay = Duration(seconds: 1);

  // Concurrent upload settings
  static const int maxConcurrentUploads = 3;
  static const Duration sequentialUploadDelay = Duration(milliseconds: 200);

  // File count and total size limits
  static const int maxFilesPerUpload =
      20; // Maximum 20 files per upload session
  static const int maxTotalSizeBytes =
      200 * 1024 * 1024; // Maximum 200MB total size

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
  ];

  // Cloud Functions settings
  static const bool enableCloudFunctionsByDefault = true;
  static const bool enableCloudFunctionsFallback = true;

  // Validation settings
  static const bool enableAdvancedValidation = true;
  static const bool enableSecurityValidation = true;

  // UI settings
  static const Duration progressUpdateInterval = Duration(milliseconds: 100);
  static const bool showDetailedProgress = true;
  static const bool showAiProcessingIndicator = true;

  // Error messages
  static const Map<String, String> errorMessages = {
    'file_too_large': 'File terlalu besar (maksimal 15MB)',
    'invalid_extension': 'Jenis file tidak didukung',
    'upload_cancelled': 'Upload dibatalkan - silakan coba lagi',
    'authentication_required': 'Silakan login ulang dan coba lagi',
    'network_error': 'Error jaringan - periksa koneksi internet',
    'permission_denied': 'Akses ditolak - periksa hak akses',
    'storage_error': 'Error penyimpanan - silakan coba lagi',
    'upload_timeout': 'Upload timeout - coba file yang lebih kecil',
    'quota_exceeded': 'Kuota penyimpanan habis',
    'validation_failed': 'Validasi file gagal - periksa jenis file',
    'file_corrupted': 'File rusak saat upload - silakan coba lagi',
    'cloud_functions_unavailable':
        'Layanan cloud tidak tersedia - menggunakan upload standar',
    'cloud_validation_failed':
        'Validasi cloud gagal - menggunakan validasi lokal',
    'generic_error': 'Upload gagal - silakan coba lagi',
    'too_many_files': 'Terlalu banyak file (maksimal 20 file per upload)',
    'total_size_too_large': 'Total ukuran file terlalu besar (maksimal 200MB)',
  };

  // Helper methods
  static bool isFileSizeAllowed(int fileSize) {
    return fileSize <= maxFileSizeBytes;
  }

  static bool isExtensionAllowed(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return allowedExtensions.contains(extension);
  }

  static bool isFileCountAllowed(int fileCount) {
    return fileCount <= maxFilesPerUpload;
  }

  static bool isTotalSizeAllowed(int totalSize) {
    return totalSize <= maxTotalSizeBytes;
  }

  static String getFileSizeString(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  static String getErrorMessage(String errorKey) {
    return errorMessages[errorKey] ?? errorMessages['generic_error']!;
  }

  static Duration getRetryDelay(int retryCount) {
    return Duration(seconds: retryCount * retryDelay.inSeconds);
  }
}
