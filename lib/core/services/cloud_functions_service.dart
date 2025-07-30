import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

class CloudFunctionsService {
  static CloudFunctionsService? _instance;
  static CloudFunctionsService get instance =>
      _instance ??= CloudFunctionsService._();

  CloudFunctionsService._();

  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  // Category Management Functions

  /// Create a new category using Cloud Functions
  Future<Map<String, dynamic>> createCategory({
    required String name,
    String? description,
    List<String>? permissions,
    bool? isActive,
  }) async {
    try {
      debugPrint('🔄 Creating category via Cloud Functions: $name');

      final HttpsCallable callable = _functions.httpsCallable('createCategory');
      final result = await callable.call({
        'name': name,
        'description': description ?? '',
        'permissions': permissions ?? [],
        'isActive': isActive ?? true,
      });

      debugPrint('✅ Category created successfully: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Failed to create category: $e');
      rethrow;
    }
  }

  /// Update an existing category using Cloud Functions
  Future<Map<String, dynamic>> updateCategory({
    required String categoryId,
    String? name,
    String? description,
    List<String>? permissions,
    bool? isActive,
  }) async {
    try {
      debugPrint('🔄 Updating category via Cloud Functions: $categoryId');

      final HttpsCallable callable = _functions.httpsCallable('updateCategory');
      final result = await callable.call({
        'categoryId': categoryId,
        'name': name,
        'description': description,
        'permissions': permissions,
        'isActive': isActive,
      });

      debugPrint('✅ Category updated successfully: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Failed to update category: $e');
      rethrow;
    }
  }

  /// Delete a category using Cloud Functions
  Future<Map<String, dynamic>> deleteCategory(String categoryId) async {
    try {
      debugPrint('🔄 Deleting category via Cloud Functions: $categoryId');

      final HttpsCallable callable = _functions.httpsCallable('deleteCategory');
      final result = await callable.call({'categoryId': categoryId});

      debugPrint('✅ Category deleted successfully: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Failed to delete category: $e');
      rethrow;
    }
  }

  /// Delete a document permanently using Cloud Functions
  Future<Map<String, dynamic>> deleteDocument(String documentId) async {
    try {
      debugPrint('🔄 Deleting document via Cloud Functions: $documentId');

      final HttpsCallable callable = _functions.httpsCallable('deleteDocument');
      final result = await callable.call({'documentId': documentId});

      debugPrint('✅ Document deleted successfully: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Failed to delete document: $e');
      rethrow;
    }
  }

  /// Add files to a category using Cloud Functions
  Future<Map<String, dynamic>> addFilesToCategory({
    required String categoryId,
    required List<String> documentIds,
  }) async {
    try {
      debugPrint(
        '🔄 Adding ${documentIds.length} files to category via Cloud Functions: $categoryId',
      );

      final HttpsCallable callable = _functions.httpsCallable(
        'addFilesToCategory',
      );
      final result = await callable.call({
        'categoryId': categoryId,
        'documentIds': documentIds,
      });

      debugPrint('✅ Files added to category successfully: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Failed to add files to category: $e');
      rethrow;
    }
  }

  /// Remove files from a category using Cloud Functions
  Future<Map<String, dynamic>> removeFilesFromCategory({
    required String categoryId,
    required List<String> documentIds,
  }) async {
    try {
      debugPrint(
        '🔄 Removing ${documentIds.length} files from category via Cloud Functions: $categoryId',
      );

      final HttpsCallable callable = _functions.httpsCallable(
        'removeFilesFromCategory',
      );
      final result = await callable.call({
        'categoryId': categoryId,
        'documentIds': documentIds,
      });

      debugPrint('✅ Files removed from category successfully: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Failed to remove files from category: $e');
      rethrow;
    }
  }

  // File Upload Functions

  /// Process file upload using Cloud Functions
  Future<Map<String, dynamic>> processFileUpload({
    required String filePath,
    required String fileName,
    required String contentType,
    Map<String, String>? metadata,
    String? categoryId,
  }) async {
    try {
      debugPrint('🔄 Processing file upload via Cloud Functions: $fileName');

      final HttpsCallable callable = _functions.httpsCallable(
        'processFileUpload',
      );
      final result = await callable.call({
        'filePath': filePath,
        'contentType': contentType,
        'metadata': metadata ?? {},
        'categoryId': categoryId,
      });

      debugPrint('✅ File upload processed successfully: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Failed to process file upload: $e');
      rethrow;
    }
  }

  /// Validate file before upload using Cloud Functions
  /// DEPRECATED: This functionality is now integrated into hybridProcessFileUpload
  /// Use hybridProcessFileUpload instead for complete file processing
  @Deprecated('Use hybridProcessFileUpload instead - validation is integrated')
  Future<Map<String, dynamic>> validateFile({
    required String fileName,
    required int fileSize,
    required String contentType,
  }) async {
    debugPrint(
      '⚠️ DEPRECATED: validateFile() is deprecated. Use hybridProcessFileUpload instead.',
    );

    // Return basic validation for backward compatibility
    return {
      'isValid': true,
      'message': 'Validation moved to hybridProcessFileUpload',
      'deprecated': true,
    };
  }

  /// Get storage quota information using Cloud Functions
  Future<Map<String, dynamic>> getStorageQuota() async {
    try {
      debugPrint('🔄 Getting storage quota via Cloud Functions');

      final HttpsCallable callable = _functions.httpsCallable(
        'getStorageQuota',
      );
      final result = await callable.call({});

      debugPrint('✅ Storage quota retrieved: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Failed to get storage quota: $e');
      rethrow;
    }
  }

  /// Check for duplicate files using Cloud Functions
  /// DEPRECATED: This functionality is now integrated into hybridProcessFileUpload
  /// Use hybridProcessFileUpload instead for complete file processing including duplicate checking
  @Deprecated(
    'Use hybridProcessFileUpload instead - duplicate checking is integrated',
  )
  Future<Map<String, dynamic>> checkDuplicateFile({
    required String fileName,
    required int fileSize,
    required String contentType,
    String? fileHash,
  }) async {
    debugPrint(
      '⚠️ DEPRECATED: checkDuplicateFile() is deprecated. Use hybridProcessFileUpload instead.',
    );

    // Return no duplicates for backward compatibility
    return {
      'isDuplicate': false,
      'message': 'Duplicate checking moved to hybridProcessFileUpload',
      'deprecated': true,
    };
  }

  /// Generate thumbnail using Cloud Functions
  /// DEPRECATED: Thumbnail generation removed due to implementation complexity
  @Deprecated(
    'Thumbnail generation removed - too complex to implement and maintain',
  )
  Future<Map<String, dynamic>> generateThumbnail({
    required String filePath,
  }) async {
    debugPrint('⚠️ DEPRECATED: generateThumbnail() is deprecated and removed.');

    return {
      'success': false,
      'message': 'Thumbnail generation removed due to complexity',
      'deprecated': true,
    };
  }

  // Sync Operations Functions

  /// Perform comprehensive sync using Cloud Functions
  Future<Map<String, dynamic>> performComprehensiveSync() async {
    try {
      debugPrint('🔄 Performing comprehensive sync via Cloud Functions');

      final HttpsCallable callable = _functions.httpsCallable(
        'performComprehensiveSync',
      );
      final result = await callable.call({});

      debugPrint('✅ Comprehensive sync completed: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Failed to perform comprehensive sync: $e');
      rethrow;
    }
  }

  /// Sync storage with Firestore using Cloud Functions
  Future<Map<String, dynamic>> syncStorageWithFirestore() async {
    try {
      debugPrint('🔄 Syncing storage with Firestore via Cloud Functions');

      final HttpsCallable callable = _functions.httpsCallable(
        'syncStorageWithFirestore',
      );
      final result = await callable.call({});

      debugPrint('✅ Storage sync completed: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Failed to sync storage: $e');
      rethrow;
    }
  }

  /// Cleanup orphaned metadata using Cloud Functions
  Future<Map<String, dynamic>> cleanupOrphanedMetadata() async {
    try {
      debugPrint('🔄 Cleaning up orphaned metadata via Cloud Functions');

      final HttpsCallable callable = _functions.httpsCallable(
        'cleanupOrphanedMetadata',
      );
      final result = await callable.call({});

      debugPrint('✅ Orphaned metadata cleanup completed: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Failed to cleanup orphaned metadata: $e');
      rethrow;
    }
  }

  /// Monitor sync consistency between collections
  Future<Map<String, dynamic>> monitorSyncConsistency() async {
    try {
      debugPrint(
        '🔍 Starting sync consistency monitoring via Cloud Functions...',
      );

      final HttpsCallable callable = _functions.httpsCallable(
        'monitorSyncConsistency',
      );
      final result = await callable.call({});

      debugPrint('✅ Sync consistency monitoring completed: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Failed to monitor sync consistency: $e');
      rethrow;
    }
  }

  /// Repair sync inconsistencies
  Future<Map<String, dynamic>> repairSyncInconsistencies({
    required String repairType,
    required List<Map<String, dynamic>> inconsistencies,
  }) async {
    try {
      debugPrint('🔧 Starting sync repair via Cloud Functions...');

      final HttpsCallable callable = _functions.httpsCallable(
        'repairSyncInconsistencies',
      );
      final result = await callable.call({
        'repairType': repairType,
        'inconsistencies': inconsistencies,
      });

      debugPrint('✅ Sync repair completed: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Failed to repair sync inconsistencies: $e');
      rethrow;
    }
  }

  // Notification Functions

  /// Send notification using Cloud Functions
  Future<Map<String, dynamic>> sendNotification({
    required String userId,
    required String title,
    required String message,
    String type = 'info',
    Map<String, dynamic>? data,
  }) async {
    try {
      debugPrint('🔄 Sending notification via Cloud Functions to: $userId');

      final HttpsCallable callable = _functions.httpsCallable(
        'sendNotification',
      );
      final result = await callable.call({
        'userId': userId,
        'title': title,
        'message': message,
        'type': type,
        'data': data ?? {},
      });

      debugPrint('✅ Notification sent successfully: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Failed to send notification: $e');
      rethrow;
    }
  }

  // User Management Functions

  /// Create user using Cloud Functions
  Future<Map<String, dynamic>> createUser({
    required String email,
    required String password,
    required String fullName,
    required String userType,
    List<String>? permissions,
  }) async {
    try {
      debugPrint('🔄 Creating user via Cloud Functions: $email');

      final HttpsCallable callable = _functions.httpsCallable('createUser');
      final result = await callable.call({
        'email': email,
        'password': password,
        'fullName': fullName,
        'userType': userType,
        'permissions': permissions ?? [],
      });

      debugPrint('✅ User created successfully: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Failed to create user: $e');
      rethrow;
    }
  }

  /// Update user permissions using Cloud Functions
  Future<Map<String, dynamic>> updateUserPermissions({
    required String userId,
    required List<String> permissions,
    String? userType,
  }) async {
    try {
      debugPrint('🔄 Updating user permissions via Cloud Functions: $userId');

      final HttpsCallable callable = _functions.httpsCallable(
        'updateUserPermissions',
      );
      final result = await callable.call({
        'userId': userId,
        'permissions': permissions,
        'userType': userType,
      });

      debugPrint('✅ User permissions updated successfully: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Failed to update user permissions: $e');
      rethrow;
    }
  }

  /// Delete user using Cloud Functions
  Future<Map<String, dynamic>> deleteUser(String userId) async {
    try {
      debugPrint('🔄 Deleting user via Cloud Functions: $userId');

      final HttpsCallable callable = _functions.httpsCallable('deleteUser');
      final result = await callable.call({'userId': userId});

      debugPrint('✅ User deleted successfully: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Failed to delete user: $e');
      rethrow;
    }
  }

  // Storage Management Functions

  /// Get storage statistics using Cloud Functions
  Future<Map<String, dynamic>> getStorageStats() async {
    try {
      debugPrint('🔄 Getting storage stats via Cloud Functions');

      final HttpsCallable callable = _functions.httpsCallable(
        'getStorageStats',
      );
      final result = await callable.call({});

      debugPrint('✅ Storage stats retrieved successfully: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Failed to get storage stats: $e');
      rethrow;
    }
  }

  /// Cleanup orphaned files using Cloud Functions
  Future<Map<String, dynamic>> cleanupOrphanedFiles() async {
    try {
      debugPrint('🔄 Cleaning up orphaned files via Cloud Functions');

      final HttpsCallable callable = _functions.httpsCallable(
        'cleanupOrphanedFiles',
      );
      final result = await callable.call({});

      debugPrint('✅ Orphaned files cleanup completed: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Failed to cleanup orphaned files: $e');
      rethrow;
    }
  }

  /// Get file access URL with expiration using Cloud Functions
  Future<String> getFileAccessUrl({
    required String filePath,
    Duration? expiration,
  }) async {
    try {
      // Validate filePath parameter
      if (filePath.trim().isEmpty) {
        throw ArgumentError('File path cannot be empty');
      }

      final sanitizedPath = filePath.trim();
      debugPrint(
        '🔄 Getting file access URL via Cloud Functions: $sanitizedPath',
      );

      final HttpsCallable callable = _functions.httpsCallable(
        'getFileAccessUrl',
      );
      final result = await callable.call({
        'filePath': sanitizedPath,
        'expirationMinutes': expiration?.inMinutes ?? 60, // Default 1 hour
      });

      final url = result.data['url'] as String;
      debugPrint('✅ File access URL retrieved successfully');
      return url;
    } catch (e) {
      debugPrint('❌ Failed to get file access URL: $e');
      rethrow;
    }
  }

  /// Batch process files using Cloud Functions
  Future<List<Map<String, dynamic>>> batchProcessFiles({
    required List<String> filePaths,
    required String operation,
    Map<String, dynamic>? options,
  }) async {
    try {
      debugPrint(
        '🔄 Batch processing ${filePaths.length} files via Cloud Functions: $operation',
      );

      final HttpsCallable callable = _functions.httpsCallable(
        'batchProcessFiles',
      );
      final result = await callable.call({
        'filePaths': filePaths,
        'operation': operation,
        'options': options ?? {},
      });

      final results = (result.data['results'] as List)
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      debugPrint('✅ Batch processing completed successfully');
      return results;
    } catch (e) {
      debugPrint('❌ Failed to batch process files: $e');
      rethrow;
    }
  }

  // Authentication Functions (ANR Prevention)

  /// Handle post-login operations using Cloud Functions
  Future<Map<String, dynamic>> handlePostLoginOperations({
    required String userId,
    required String email,
    Map<String, dynamic>? deviceInfo,
  }) async {
    try {
      debugPrint('🔄 Processing post-login operations for user: $userId');

      final callable = _functions.httpsCallable('handlePostLoginOperations');
      final result = await callable.call({
        'userId': userId,
        'email': email,
        'deviceInfo': deviceInfo ?? {},
      });

      debugPrint('✅ Post-login operations completed successfully');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Error in post-login operations: $e');
      rethrow;
    }
  }

  /// Handle logout operations using Cloud Functions
  Future<Map<String, dynamic>> handleLogoutOperations({
    required String userId,
    Map<String, dynamic>? deviceInfo,
  }) async {
    try {
      debugPrint('🔄 Handling logout operations via Cloud Functions: $userId');

      final HttpsCallable callable = _functions.httpsCallable(
        'handleLogoutOperations',
      );
      final result = await callable.call({
        'userId': userId,
        'deviceInfo': deviceInfo ?? {},
      });

      debugPrint('✅ Logout operations completed: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Failed to handle logout operations: $e');
      rethrow;
    }
  }

  /// Enhanced activity logging using Cloud Functions
  /// This replaces direct client-side Firestore operations for better security
  Future<Map<String, dynamic>> logActivity({
    required String type,
    required String description,
    String? documentId,
    String? categoryId,
    Map<String, dynamic>? additionalData,
    bool isSuspicious = false,
  }) async {
    try {
      debugPrint('🔄 Logging activity via Cloud Functions: $type');

      final HttpsCallable callable = _functions.httpsCallable('logActivity');
      final result = await callable.call({
        'type': type,
        'description': description,
        'documentId': documentId,
        'categoryId': categoryId,
        'additionalData': additionalData ?? {},
        'isSuspicious': isSuspicious,
      });

      debugPrint('✅ Activity logged successfully via Cloud Functions: $type');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Failed to log activity via Cloud Functions: $e');
      rethrow;
    }
  }

  /// Validate user session using Cloud Functions
  Future<Map<String, dynamic>> validateUserSession({
    required String userId,
  }) async {
    try {
      debugPrint('🔄 Validating user session via Cloud Functions: $userId');

      final HttpsCallable callable = _functions.httpsCallable(
        'validateUserSession',
      );
      final result = await callable.call({'userId': userId});

      debugPrint('✅ User session validated: ${result.data}');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Failed to validate user session: $e');
      rethrow;
    }
  }
}
