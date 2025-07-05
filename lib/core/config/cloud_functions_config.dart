import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Configuration for Cloud Functions integration
class CloudFunctionsConfig {
  // Cloud Functions availability
  static bool _isAvailable = false;
  static bool _isInitialized = false;

  // Function endpoints
  static const String processFileUploadFunction = 'processFileUpload';
  static const String hybridProcessFileUploadFunction =
      'hybridProcessFileUpload';
  static const String validateFileFunction = 'validateFile';
  static const String checkDuplicateFileFunction = 'checkDuplicateFile';
  static const String generateThumbnailFunction = 'generateThumbnail';
  static const String extractMetadataFunction = 'extractMetadata';
  static const String createCategoryFunction = 'createCategory';
  static const String updateCategoryFunction = 'updateCategory';
  static const String deleteCategoryFunction = 'deleteCategory';
  static const String addFilesToCategoryFunction = 'addFilesToCategory';
  static const String removeFilesFromCategoryFunction =
      'removeFilesFromCategory';
  static const String deleteDocumentFunction = 'deleteDocument';
  static const String createUserFunction = 'createUser';
  static const String updateUserPermissionsFunction = 'updateUserPermissions';
  static const String deleteUserFunction = 'deleteUser';
  static const String syncStorageWithFirestoreFunction =
      'syncStorageWithFirestore';
  static const String cleanupOrphanedMetadataFunction =
      'cleanupOrphanedMetadata';
  static const String performComprehensiveSyncFunction =
      'performComprehensiveSync';
  static const String sendNotificationFunction = 'sendNotification';
  static const String healthCheckFunction = 'healthCheck';
  static const String getStorageQuotaFunction = 'getStorageQuota';
  static const String getFileAccessUrlFunction = 'getFileAccessUrl';
  static const String cleanupOrphanedFilesFunction = 'cleanupOrphanedFiles';
  static const String batchProcessFilesFunction = 'batchProcessFiles';

  // Timeout settings
  static const Duration defaultTimeout = Duration(minutes: 2);
  static const Duration uploadTimeout = Duration(minutes: 5);
  static const Duration validationTimeout = Duration(seconds: 30);

  // Retry settings
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  /// Initialize Cloud Functions and check availability
  static Future<bool> initialize() async {
    if (_isInitialized) return _isAvailable;

    try {
      debugPrint('🔄 Initializing Cloud Functions...');

      // Test health check endpoint to verify availability
      final functions = FirebaseFunctions.instance;
      final healthCheck = functions.httpsCallable(healthCheckFunction);

      final result = await healthCheck.call().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Health check timeout');
        },
      );

      if (result.data['status'] == 'healthy') {
        _isAvailable = true;
        debugPrint('✅ Cloud Functions are available and healthy');
      } else {
        _isAvailable = false;
        debugPrint('❌ Cloud Functions health check failed');
      }
    } catch (e) {
      debugPrint('❌ Health check failed: $e');

      // Try to test a different function to verify availability
      try {
        debugPrint('🔄 Testing alternative function for availability...');
        final functions = FirebaseFunctions.instance;
        final testFunction = functions.httpsCallable('validateFile');

        // Call with minimal test data
        await testFunction
            .call({
              'fileName': 'test.txt',
              'fileSize': 100,
              'contentType': 'text/plain',
            })
            .timeout(
              const Duration(seconds: 5),
              onTimeout: () {
                throw Exception('Alternative test timeout');
              },
            );

        // If we get here, functions are available
        _isAvailable = true;
        debugPrint(
          '✅ Cloud Functions are available (verified via alternative test)',
        );
      } catch (altError) {
        _isAvailable = false;
        debugPrint('❌ Cloud Functions not available: $altError');
      }
    }

    _isInitialized = true;
    return _isAvailable;
  }

  /// Check if Cloud Functions are available
  static bool get isAvailable => _isAvailable;

  /// Force re-check availability
  static Future<bool> recheckAvailability() async {
    _isInitialized = false;
    return await initialize();
  }

  /// Get callable function with error handling
  static HttpsCallable getCallableFunction(String functionName) {
    final functions = FirebaseFunctions.instance;
    return functions.httpsCallable(functionName);
  }

  /// Call function with retry logic
  static Future<T> callFunctionWithRetry<T>(
    String functionName,
    Map<String, dynamic>? data, {
    Duration? timeout,
    int? maxRetries,
  }) async {
    final callable = getCallableFunction(functionName);
    final actualTimeout = timeout ?? defaultTimeout;
    final actualMaxRetries = maxRetries ?? CloudFunctionsConfig.maxRetries;

    // CRITICAL DEBUG: Check authentication state before calling function
    final currentUser = FirebaseAuth.instance.currentUser;
    debugPrint('🔐 AUTH DEBUG - Before calling $functionName:');
    debugPrint('   User: ${currentUser?.email}');
    debugPrint('   UID: ${currentUser?.uid}');
    debugPrint('   Email verified: ${currentUser?.emailVerified}');
    debugPrint('   Token available: ${currentUser != null}');

    for (int attempt = 1; attempt <= actualMaxRetries; attempt++) {
      try {
        debugPrint(
          '🔄 Calling $functionName (attempt $attempt/$actualMaxRetries)',
        );

        final result = await callable
            .call(data)
            .timeout(
              actualTimeout,
              onTimeout: () {
                throw Exception('Function call timeout');
              },
            );

        debugPrint('✅ $functionName completed successfully');
        return result.data as T;
      } catch (e) {
        debugPrint('❌ $functionName attempt $attempt failed: $e');

        // Additional debug for authentication errors
        if (e.toString().contains('unauthenticated') ||
            e.toString().contains('UNAUTHENTICATED')) {
          final user = FirebaseAuth.instance.currentUser;
          debugPrint('🔐 AUTH ERROR DEBUG:');
          debugPrint('   Current user: ${user?.email}');
          debugPrint('   User UID: ${user?.uid}');
          debugPrint('   Email verified: ${user?.emailVerified}');
          debugPrint('   ID token available: ${user != null}');
        }

        if (attempt == actualMaxRetries) {
          rethrow;
        }

        // Wait before retry
        await Future.delayed(retryDelay * attempt);
      }
    }

    throw Exception('All retry attempts failed');
  }

  /// Validate file using Cloud Functions
  static Future<Map<String, dynamic>> validateFile({
    required String fileName,
    required int fileSize,
    required String contentType,
  }) async {
    if (!_isAvailable) {
      throw Exception('Cloud Functions not available');
    }

    return await callFunctionWithRetry<Map<String, dynamic>>(
      validateFileFunction,
      {'fileName': fileName, 'fileSize': fileSize, 'contentType': contentType},
      timeout: validationTimeout,
    );
  }

  /// Check for duplicate files before upload
  static Future<Map<String, dynamic>> checkDuplicateFile({
    required String fileName,
    required int fileSize,
    required String contentType,
    String? fileHash,
  }) async {
    if (!_isAvailable) {
      throw Exception('Cloud Functions not available');
    }

    return await callFunctionWithRetry<Map<String, dynamic>>(
      checkDuplicateFileFunction,
      {
        'fileName': fileName,
        'fileSize': fileSize,
        'contentType': contentType,
        'fileHash': fileHash,
      },
      timeout: const Duration(seconds: 30),
    );
  }

  /// Process file upload using HYBRID Cloud Functions (Optimized)
  /// Uses server-side heavy processing for better performance
  static Future<Map<String, dynamic>> processFileUpload({
    required String filePath,
    required String fileName,
    required String contentType,
    String? categoryId,
    Map<String, String>? metadata,
  }) async {
    debugPrint('🔧 CloudFunctionsConfig.processFileUpload called');
    debugPrint('📍 Function: $hybridProcessFileUploadFunction');
    debugPrint('📁 File: $fileName');
    debugPrint('🔗 Path: $filePath');
    debugPrint('🔧 Available: $_isAvailable');

    if (!_isAvailable) {
      debugPrint('❌ Cloud Functions not available');
      throw Exception('Cloud Functions not available');
    }

    debugPrint('📞 Calling function with retry...');
    final result = await callFunctionWithRetry<Map<String, dynamic>>(
      hybridProcessFileUploadFunction,
      {
        'filePath': filePath,
        'fileName': fileName,
        'contentType': contentType,
        'categoryId': categoryId,
        'metadata': metadata ?? {},
      },
      timeout: uploadTimeout,
    );

    debugPrint('✅ Function call completed: $result');
    return result;
  }

  /// Legacy process file upload (fallback)
  static Future<Map<String, dynamic>> legacyProcessFileUpload({
    required String filePath,
    required String fileName,
    required String contentType,
    String? categoryId,
    Map<String, String>? metadata,
  }) async {
    if (!_isAvailable) {
      throw Exception('Cloud Functions not available');
    }

    return await callFunctionWithRetry<Map<String, dynamic>>(
      processFileUploadFunction,
      {
        'filePath': filePath,
        'fileName': fileName,
        'contentType': contentType,
        'categoryId': categoryId,
        'metadata': metadata ?? {},
      },
      timeout: uploadTimeout,
    );
  }

  /// Create category using Cloud Functions
  static Future<Map<String, dynamic>> createCategory({
    required String name,
    String? description,
    List<String>? permissions,
    bool? isActive,
  }) async {
    if (!_isAvailable) {
      throw Exception('Cloud Functions not available');
    }

    return await callFunctionWithRetry<Map<String, dynamic>>(
      createCategoryFunction,
      {
        'name': name,
        'description': description ?? '',
        'permissions': permissions ?? [],
        'isActive': isActive ?? true,
      },
    );
  }

  /// Update category using Cloud Functions
  static Future<Map<String, dynamic>> updateCategory({
    required String categoryId,
    String? name,
    String? description,
    List<String>? permissions,
    bool? isActive,
  }) async {
    if (!_isAvailable) {
      throw Exception('Cloud Functions not available');
    }

    return await callFunctionWithRetry<Map<String, dynamic>>(
      updateCategoryFunction,
      {
        'categoryId': categoryId,
        'name': name,
        'description': description,
        'permissions': permissions,
        'isActive': isActive,
      },
    );
  }

  /// Delete category using Cloud Functions
  static Future<Map<String, dynamic>> deleteCategory(String categoryId) async {
    if (!_isAvailable) {
      throw Exception('Cloud Functions not available');
    }

    return await callFunctionWithRetry<Map<String, dynamic>>(
      deleteCategoryFunction,
      {'categoryId': categoryId},
    );
  }

  /// Delete document using Cloud Functions
  static Future<Map<String, dynamic>> deleteDocument(String documentId) async {
    if (!_isAvailable) {
      throw Exception('Cloud Functions not available');
    }

    return await callFunctionWithRetry<Map<String, dynamic>>(
      deleteDocumentFunction,
      {'documentId': documentId},
      timeout: const Duration(
        minutes: 3,
      ), // Longer timeout for delete operations
    );
  }

  /// Sync storage with Firestore using Cloud Functions
  static Future<Map<String, dynamic>> syncStorageWithFirestore() async {
    if (!_isAvailable) {
      throw Exception('Cloud Functions not available');
    }

    return await callFunctionWithRetry<Map<String, dynamic>>(
      syncStorageWithFirestoreFunction,
      {},
      timeout: const Duration(
        minutes: 10,
      ), // Longer timeout for sync operations
    );
  }

  /// Perform comprehensive sync using Cloud Functions
  static Future<Map<String, dynamic>> performComprehensiveSync() async {
    if (!_isAvailable) {
      throw Exception('Cloud Functions not available');
    }

    return await callFunctionWithRetry<Map<String, dynamic>>(
      performComprehensiveSyncFunction,
      {},
      timeout: const Duration(
        minutes: 15,
      ), // Longer timeout for comprehensive sync
    );
  }

  /// Get storage quota using Cloud Functions
  static Future<Map<String, dynamic>> getStorageQuota() async {
    if (!_isAvailable) {
      throw Exception('Cloud Functions not available');
    }

    return await callFunctionWithRetry<Map<String, dynamic>>(
      getStorageQuotaFunction,
      {},
    );
  }

  /// Get file access URL using Cloud Functions
  static Future<String> getFileAccessUrl({
    required String filePath,
    int? expirationMinutes,
  }) async {
    if (!_isAvailable) {
      throw Exception('Cloud Functions not available');
    }

    final result = await callFunctionWithRetry<Map<String, dynamic>>(
      getFileAccessUrlFunction,
      {'filePath': filePath, 'expirationMinutes': expirationMinutes ?? 60},
    );

    return result['url'] as String;
  }

  /// Send notification using Cloud Functions
  static Future<Map<String, dynamic>> sendNotification({
    required String userId,
    required String title,
    required String message,
    String type = 'info',
    Map<String, dynamic>? data,
  }) async {
    if (!_isAvailable) {
      throw Exception('Cloud Functions not available');
    }

    return await callFunctionWithRetry<Map<String, dynamic>>(
      sendNotificationFunction,
      {
        'userId': userId,
        'title': title,
        'message': message,
        'type': type,
        'data': data ?? {},
      },
    );
  }
}
