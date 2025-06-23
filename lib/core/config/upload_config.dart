/// Upload configuration and constants
class UploadConfig {
  // File size limits
  static const int maxFileSizeBytes = 15 * 1024 * 1024; // 15MB
  static const int maxFileSizeBytesLocal =
      10 * 1024 * 1024; // 10MB for local validation

  // Timeout settings - ENHANCED FOR INDIVIDUAL FILES
  static const Duration uploadTimeout = Duration(
    minutes: 5,
  ); // Legacy batch timeout
  static const Duration individualFileTimeout = Duration(
    minutes: 2,
  ); // Per file timeout
  static const Duration cloudFunctionsTimeout = Duration(minutes: 3);
  static const Duration smallFileTimeout = Duration(seconds: 30); // < 5MB files
  static const Duration largeFileTimeout = Duration(minutes: 2); // >= 5MB files

  // Retry settings
  static const int maxRetries = 2;
  static const Duration retryDelay = Duration(seconds: 1);

  // Concurrent upload settings - ENHANCED FOR BULK UPLOADS
  static const int maxConcurrentUploads =
      4; // Increased from 3 to 4 for better performance
  static const Duration sequentialUploadDelay = Duration(milliseconds: 200);
  static const int concurrentUploadBatchSize =
      4; // Process 4 files simultaneously
  static const Duration concurrentUploadDelay = Duration(milliseconds: 100);

  // File count and total size limits - INCREASED LIMITS
  static const int maxFilesPerUpload =
      25; // Maximum 25 files per upload session (increased from 20)
  static const int maxTotalSizeBytes =
      250 * 1024 * 1024; // Maximum 250MB total size (increased from 200MB)

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

  // Cloud Functions settings
  static const bool enableCloudFunctionsByDefault = true;
  static const bool enableCloudFunctionsFallback = true;

  // Validation settings
  static const bool enableAdvancedValidation = true;
  static const bool enableSecurityValidation = true;

  // UI settings - OPTIMIZED FOR BULK UPLOADS
  static const Duration progressUpdateInterval = Duration(milliseconds: 100);
  static const bool showDetailedProgress = true;
  static const bool showAiProcessingIndicator = true;

  // Progress batching settings to prevent UI lag
  static const double progressBatchThreshold =
      0.05; // Update UI every 5% instead of 1%
  static const Duration uiUpdateDebounce = Duration(milliseconds: 200);
  static const int maxVisibleQueueItems = 10; // Show up to 10 items in queue UI

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
    'too_many_files': 'Terlalu banyak file (maksimal 25 file per upload)',
    'total_size_too_large': 'Total ukuran file terlalu besar (maksimal 250MB)',
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

  /// Get appropriate timeout based on file size
  static Duration getFileTimeout(int fileSizeBytes) {
    const int largeSizeThreshold = 5 * 1024 * 1024; // 5MB
    return fileSizeBytes >= largeSizeThreshold
        ? largeFileTimeout
        : smallFileTimeout;
  }

  /// Get timeout for individual file upload
  static Duration getIndividualFileTimeout() {
    return individualFileTimeout;
  }
}
