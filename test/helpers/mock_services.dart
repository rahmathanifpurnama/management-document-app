import 'package:flutter/foundation.dart';
import '../../lib/models/user_model.dart';

/// Mock Cloud Functions Service for testing
class MockCloudFunctionsService {
  static MockCloudFunctionsService? _instance;
  static MockCloudFunctionsService get instance =>
      _instance ??= MockCloudFunctionsService._();

  MockCloudFunctionsService._();

  @override
  Future<String> getFileAccessUrl({
    required String filePath,
    Duration? expiration,
  }) async {
    // Return a mock URL for testing
    return 'https://mock-storage.example.com/$filePath?token=mock-token';
  }

  @override
  Future<Map<String, dynamic>> checkDuplicateFile({
    required String fileName,
    required int fileSize,
    required String contentType,
    String? fileHash,
  }) async {
    // Return mock duplicate check result
    return {
      'isDuplicate': false,
      'confidence': 0.0,
      'reason': 'No duplicates found (mock)',
      'existingDocument': null,
      'detectionMethod': 'mock',
    };
  }

  @override
  Future<Map<String, dynamic>> processFileUpload({
    required String filePath,
    required String fileName,
    required String contentType,
    Map<String, String>? metadata,
    String? categoryId,
  }) async {
    // Return mock upload result
    return {
      'success': true,
      'documentId': 'mock-doc-id-${DateTime.now().millisecondsSinceEpoch}',
      'downloadUrl': 'https://mock-storage.example.com/$filePath',
      'message': 'File uploaded successfully (mock)',
    };
  }

  @override
  Future<bool> healthCheck() async {
    // Always return healthy for mock
    return true;
  }

  @override
  Future<Map<String, dynamic>> createUser({
    required String email,
    required String password,
    required String fullName,
    required String userType,
    List<String>? permissions,
  }) async {
    // Return mock user creation result
    return {
      'success': true,
      'uid': 'mock-uid-${DateTime.now().millisecondsSinceEpoch}',
      'message': 'User created successfully (mock)',
    };
  }

  @override
  Future<Map<String, dynamic>> generateThumbnail({
    required String filePath,
  }) async {
    // Return mock thumbnail result
    return {
      'success': true,
      'thumbnailUrl': 'https://mock-storage.example.com/thumbnails/$filePath',
      'message': 'Thumbnail generated successfully (mock)',
    };
  }

  @override
  Future<Map<String, dynamic>> cleanupOrphanedFiles() async {
    // Return mock cleanup result
    return {
      'success': true,
      'deletedCount': 0,
      'message': 'No orphaned files found (mock)',
    };
  }

  @override
  Future<List<Map<String, dynamic>>> batchProcessFiles({
    required List<String> filePaths,
    required String operation,
    Map<String, dynamic>? options,
  }) async {
    // Return mock batch processing results
    return filePaths
        .map(
          (path) => {
            'filePath': path,
            'success': true,
            'result': 'Processed successfully (mock)',
          },
        )
        .toList();
  }

  void configureForDevelopment() {
    debugPrint('🔧 Mock Cloud Functions configured for development');
  }

  void configureForProduction() {
    debugPrint('🔧 Mock Cloud Functions configured for production');
  }
}

/// Mock Firebase Service for testing
class MockFirebaseService {
  static MockFirebaseService? _mockInstance;
  static MockFirebaseService get mockInstance =>
      _mockInstance ??= MockFirebaseService._();

  MockFirebaseService._();

  Future<bool> checkConnection() async {
    // Always return connected for mock
    return true;
  }

  Future<void> enableNetwork() async {
    debugPrint('🔧 Mock Firebase network enabled');
  }

  Future<void> disableNetwork() async {
    debugPrint('🔧 Mock Firebase network disabled');
  }

  Future<void> clearPersistence() async {
    debugPrint('🔧 Mock Firebase persistence cleared');
  }

  Future<void> terminate() async {
    debugPrint('🔧 Mock Firebase terminated');
  }
}

/// Helper class to setup mock services for testing
class MockServiceHelper {
  static bool _initialized = false;

  /// Initialize mock services for testing
  static void initializeMockServices() {
    if (_initialized) return;

    // Initialize mock services
    MockCloudFunctionsService.instance;
    MockFirebaseService.mockInstance;

    _initialized = true;
    debugPrint('✅ Mock services initialized for testing');
  }

  /// Reset mock services
  static void resetMockServices() {
    MockCloudFunctionsService._instance = null;
    MockFirebaseService._mockInstance = null;
    _initialized = false;
    debugPrint('🔄 Mock services reset');
  }

  /// Check if mock services are initialized
  static bool get isInitialized => _initialized;
}
