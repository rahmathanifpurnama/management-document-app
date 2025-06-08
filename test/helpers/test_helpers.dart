import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

/// Helper class for creating test files and data
class TestHelpers {
  /// Create a temporary directory for tests
  static Future<Directory> createTempDirectory(String prefix) async {
    return await Directory.systemTemp.createTemp('${prefix}_test_');
  }

  /// Clean up temporary directory
  static Future<void> cleanupTempDirectory(Directory dir) async {
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  /// Create a test file with specified content
  static Future<File> createTestFile(
    Directory tempDir,
    String fileName,
    String content,
  ) async {
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsString(content);
    return file;
  }

  /// Create a test file with binary content
  static Future<File> createBinaryTestFile(
    Directory tempDir,
    String fileName,
    Uint8List bytes,
  ) async {
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }

  /// Create a large test file for performance testing
  static Future<File> createLargeTestFile(
    Directory tempDir,
    String fileName,
    int sizeInBytes,
  ) async {
    final file = File('${tempDir.path}/$fileName');
    final content = 'A' * sizeInBytes;
    await file.writeAsString(content);
    return file;
  }

  /// Create multiple test files with different content
  static Future<List<File>> createMultipleTestFiles(
    Directory tempDir,
    int count, {
    String prefix = 'test',
    String extension = 'txt',
  }) async {
    final files = <File>[];
    for (int i = 0; i < count; i++) {
      final fileName = '${prefix}_$i.$extension';
      final content = 'Test content for file $i';
      final file = await createTestFile(tempDir, fileName, content);
      files.add(file);
    }
    return files;
  }

  /// Create XFile from File
  static XFile fileToXFile(File file) {
    return XFile(file.path);
  }

  /// Create multiple XFiles from Files
  static List<XFile> filesToXFiles(List<File> files) {
    return files.map((file) => XFile(file.path)).toList();
  }

  /// Generate test content of specific size
  static String generateTestContent(int sizeInBytes, {String pattern = 'A'}) {
    return pattern * (sizeInBytes ~/ pattern.length);
  }

  /// Generate binary test data
  static Uint8List generateBinaryTestData(int sizeInBytes) {
    final bytes = Uint8List(sizeInBytes);
    for (int i = 0; i < sizeInBytes; i++) {
      bytes[i] = i % 256;
    }
    return bytes;
  }

  /// Create test files with specific file types
  static Future<Map<String, File>> createTestFilesByType(
    Directory tempDir,
  ) async {
    final files = <String, File>{};

    // Text file
    files['txt'] = await createTestFile(
      tempDir,
      'test.txt',
      'This is a text file for testing.',
    );

    // PDF-like file (mock content)
    files['pdf'] = await createTestFile(
      tempDir,
      'test.pdf',
      '%PDF-1.4\nMock PDF content for testing.',
    );

    // Image-like file (mock content)
    files['jpg'] = await createBinaryTestFile(
      tempDir,
      'test.jpg',
      Uint8List.fromList([0xFF, 0xD8, 0xFF, 0xE0]), // JPEG header
    );

    // Document-like file (mock content)
    files['docx'] = await createBinaryTestFile(
      tempDir,
      'test.docx',
      Uint8List.fromList([0x50, 0x4B, 0x03, 0x04]), // ZIP header (DOCX is ZIP)
    );

    return files;
  }

  /// Create identical test files for duplicate testing
  static Future<List<File>> createIdenticalTestFiles(
    Directory tempDir,
    String content,
    int count, {
    String prefix = 'identical',
    String extension = 'txt',
  }) async {
    final files = <File>[];
    for (int i = 0; i < count; i++) {
      final fileName = '${prefix}_$i.$extension';
      final file = await createTestFile(tempDir, fileName, content);
      files.add(file);
    }
    return files;
  }

  /// Verify file exists and has expected size
  static Future<bool> verifyFile(File file, {int? expectedSize}) async {
    if (!await file.exists()) return false;
    
    if (expectedSize != null) {
      final actualSize = await file.length();
      return actualSize == expectedSize;
    }
    
    return true;
  }

  /// Get file extension from filename
  static String getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }

  /// Get MIME type for file extension
  static String getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'txt':
        return 'text/plain';
      case 'pdf':
        return 'application/pdf';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
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

  /// Create test files with various sizes for performance testing
  static Future<Map<String, File>> createPerformanceTestFiles(
    Directory tempDir,
  ) async {
    final files = <String, File>{};

    // Small file (1KB)
    files['small'] = await createLargeTestFile(
      tempDir,
      'small.txt',
      1024,
    );

    // Medium file (1MB)
    files['medium'] = await createLargeTestFile(
      tempDir,
      'medium.txt',
      1024 * 1024,
    );

    // Large file (10MB)
    files['large'] = await createLargeTestFile(
      tempDir,
      'large.txt',
      10 * 1024 * 1024,
    );

    return files;
  }

  /// Wait for a condition to be true with timeout
  static Future<bool> waitForCondition(
    bool Function() condition, {
    Duration timeout = const Duration(seconds: 10),
    Duration interval = const Duration(milliseconds: 100),
  }) async {
    final stopwatch = Stopwatch()..start();
    
    while (stopwatch.elapsed < timeout) {
      if (condition()) {
        return true;
      }
      await Future.delayed(interval);
    }
    
    return false;
  }

  /// Measure execution time of a function
  static Future<Duration> measureExecutionTime(Future<void> Function() function) async {
    final stopwatch = Stopwatch()..start();
    await function();
    stopwatch.stop();
    return stopwatch.elapsed;
  }

  /// Create test data for batch operations
  static Future<List<Map<String, dynamic>>> createBatchTestData(
    Directory tempDir,
    int count,
  ) async {
    final testData = <Map<String, dynamic>>[];
    
    for (int i = 0; i < count; i++) {
      final file = await createTestFile(
        tempDir,
        'batch_$i.txt',
        'Batch test content $i',
      );
      
      testData.add({
        'file': file,
        'xFile': XFile(file.path),
        'index': i,
        'expectedContent': 'Batch test content $i',
      });
    }
    
    return testData;
  }

  /// Validate test results
  static bool validateTestResults(
    Map<String, dynamic> results,
    List<String> requiredKeys,
  ) {
    for (final key in requiredKeys) {
      if (!results.containsKey(key)) {
        return false;
      }
    }
    return true;
  }

  /// Create mock file metadata
  static Map<String, dynamic> createMockFileMetadata({
    required String fileName,
    required int fileSize,
    required String contentType,
    String? fileHash,
    DateTime? uploadTime,
    String? uploadedBy,
  }) {
    return {
      'fileName': fileName,
      'fileSize': fileSize,
      'contentType': contentType,
      'fileHash': fileHash,
      'uploadTime': uploadTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'uploadedBy': uploadedBy ?? 'test_user',
      'status': 'uploaded',
    };
  }

  /// Create mock duplicate check result
  static Map<String, dynamic> createMockDuplicateResult({
    required bool isDuplicate,
    required double confidence,
    required String reason,
    Map<String, dynamic>? existingDocument,
    String detectionMethod = 'test',
  }) {
    return {
      'isDuplicate': isDuplicate,
      'confidence': confidence,
      'reason': reason,
      'existingDocument': existingDocument,
      'detectionMethod': detectionMethod,
    };
  }

  /// Cleanup multiple temporary directories
  static Future<void> cleanupMultipleTempDirectories(List<Directory> directories) async {
    for (final dir in directories) {
      await cleanupTempDirectory(dir);
    }
  }

  /// Create test environment with multiple file types and sizes
  static Future<Map<String, dynamic>> createTestEnvironment() async {
    final tempDir = await createTempDirectory('test_environment');
    
    final filesByType = await createTestFilesByType(tempDir);
    final filesBySize = await createPerformanceTestFiles(tempDir);
    final multipleFiles = await createMultipleTestFiles(tempDir, 5);
    
    return {
      'tempDir': tempDir,
      'filesByType': filesByType,
      'filesBySize': filesBySize,
      'multipleFiles': multipleFiles,
      'cleanup': () => cleanupTempDirectory(tempDir),
    };
  }
}
