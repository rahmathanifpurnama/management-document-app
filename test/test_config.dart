/// Test configuration and constants
class TestConfig {
  // Test timeouts
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration longTimeout = Duration(minutes: 2);
  static const Duration shortTimeout = Duration(seconds: 5);

  // Test file sizes
  static const int smallFileSize = 1024; // 1KB
  static const int mediumFileSize = 1024 * 1024; // 1MB
  static const int largeFileSize = 10 * 1024 * 1024; // 10MB
  static const int veryLargeFileSize = 100 * 1024 * 1024; // 100MB

  // Test batch sizes
  static const int smallBatchSize = 5;
  static const int mediumBatchSize = 10;
  static const int largeBatchSize = 20;

  // Test content patterns
  static const String defaultTestContent = 'Test content for file hash and duplicate detection';
  static const String duplicateTestContent = 'Identical content for duplicate testing';
  static const String uniqueTestContent = 'Unique content that should not have duplicates';

  // Test file extensions
  static const List<String> supportedExtensions = [
    'txt', 'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx',
    'jpg', 'jpeg', 'png', 'gif'
  ];

  // Test MIME types
  static const Map<String, String> mimeTypes = {
    'txt': 'text/plain',
    'pdf': 'application/pdf',
    'doc': 'application/msword',
    'docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'xls': 'application/vnd.ms-excel',
    'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'ppt': 'application/vnd.ms-powerpoint',
    'pptx': 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'gif': 'image/gif',
  };

  // Performance thresholds
  static const Duration maxHashCalculationTime = Duration(seconds: 10);
  static const Duration maxDuplicateDetectionTime = Duration(seconds: 15);
  static const Duration maxBatchProcessingTime = Duration(seconds: 30);
  static const Duration maxCloudFunctionResponseTime = Duration(seconds: 30);

  // Test data patterns
  static const List<String> testFileNames = [
    'test_document.pdf',
    'sample_image.jpg',
    'data_sheet.xlsx',
    'presentation.pptx',
    'readme.txt',
  ];

  // Error test cases
  static const List<String> invalidFileNames = [
    '',
    'file_without_extension',
    'file.invalid_extension',
    'very_long_filename_that_exceeds_normal_limits_and_might_cause_issues.txt',
  ];

  // Hash validation patterns
  static const String validHashPattern = r'^[a-fA-F0-9]{64}$';
  static const int sha256HashLength = 64;

  // Test environment settings
  static const bool enablePerformanceTests = true;
  static const bool enableCloudFunctionTests = true;
  static const bool enableLargeFileTests = true;
  static const bool enableConcurrencyTests = true;

  // Mock data
  static const String mockUserId = 'test_user_123';
  static const String mockDeviceId = 'test_device_456';
  static const String mockSessionId = 'test_session_789';

  // Test categories
  static const List<String> testCategories = [
    'Documents',
    'Images',
    'Spreadsheets',
    'Presentations',
    'Archives',
  ];

  // Expected error messages
  static const Map<String, String> expectedErrors = {
    'file_not_found': 'File not found',
    'invalid_file_type': 'Invalid file type',
    'file_too_large': 'File size exceeds limit',
    'network_error': 'Network connection failed',
    'authentication_error': 'Authentication required',
    'permission_error': 'Permission denied',
  };

  // Test result validation
  static bool isValidTestResult(Map<String, dynamic> result) {
    return result.containsKey('success') && 
           result.containsKey('timestamp') &&
           result['timestamp'] != null;
  }

  // Test data cleanup settings
  static const bool autoCleanupTempFiles = true;
  static const Duration tempFileRetentionTime = Duration(hours: 1);

  // Concurrency settings
  static const int maxConcurrentOperations = 5;
  static const Duration concurrencyTestTimeout = Duration(minutes: 5);

  // Memory usage thresholds (in bytes)
  static const int maxMemoryUsagePerFile = 50 * 1024 * 1024; // 50MB
  static const int maxTotalMemoryUsage = 200 * 1024 * 1024; // 200MB

  // Progress tracking settings
  static const double progressUpdateThreshold = 0.1; // 10%
  static const Duration progressUpdateInterval = Duration(milliseconds: 100);

  // Retry settings for flaky tests
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 1);

  // Test data generation settings
  static const int randomSeed = 12345;
  static const String testDataPrefix = 'test_';
  static const String tempDirPrefix = 'managementdoc_test_';

  // Validation thresholds
  static const double minDuplicateConfidence = 0.8;
  static const double maxAcceptableErrorRate = 0.05; // 5%
  static const int minBatchSize = 1;
  static const int maxBatchSize = 100;

  // File content patterns for testing
  static const Map<String, String> fileContentPatterns = {
    'text': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    'binary': 'Binary content pattern with special characters: \x00\x01\x02\x03',
    'large': 'A', // Will be repeated to create large files
    'unicode': 'Unicode test: 你好世界 🌍 émojis 🎉',
    'empty': '',
  };

  // Test environment validation
  static bool validateTestEnvironment() {
    // Add any environment validation logic here
    return true;
  }

  // Get test timeout based on operation type
  static Duration getTimeoutForOperation(String operation) {
    switch (operation) {
      case 'hash_calculation':
        return maxHashCalculationTime;
      case 'duplicate_detection':
        return maxDuplicateDetectionTime;
      case 'batch_processing':
        return maxBatchProcessingTime;
      case 'cloud_function':
        return maxCloudFunctionResponseTime;
      default:
        return defaultTimeout;
    }
  }

  // Get expected file size category
  static String getFileSizeCategory(int fileSize) {
    if (fileSize < mediumFileSize) return 'small';
    if (fileSize < largeFileSize) return 'medium';
    if (fileSize < veryLargeFileSize) return 'large';
    return 'very_large';
  }

  // Check if test should be skipped based on configuration
  static bool shouldSkipTest(String testType) {
    switch (testType) {
      case 'performance':
        return !enablePerformanceTests;
      case 'cloud_functions':
        return !enableCloudFunctionTests;
      case 'large_files':
        return !enableLargeFileTests;
      case 'concurrency':
        return !enableConcurrencyTests;
      default:
        return false;
    }
  }
}
