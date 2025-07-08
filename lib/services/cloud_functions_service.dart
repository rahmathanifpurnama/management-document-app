import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

class CloudFunctionsService {
  static CloudFunctionsService? _instance;
  static CloudFunctionsService get instance =>
      _instance ??= CloudFunctionsService._();

  CloudFunctionsService._();

  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  // Configure functions for local development if needed
  void configureForDevelopment() {
    if (kDebugMode) {
      // Uncomment for local emulator
      // _functions.useFunctionsEmulator('localhost', 5001);
    }
  }

  // File Upload Functions

  /// Process file upload after it's uploaded to Storage
  Future<Map<String, dynamic>> processFileUpload({
    required String filePath,
    String? fileName,
    String? contentType,
    Map<String, dynamic>? metadata,
    String? categoryId,
  }) async {
    try {
      debugPrint('🔄 Processing file upload via Cloud Function: $filePath');

      final callable = _functions.httpsCallable('processFileUpload');
      final result = await callable.call({
        'filePath': filePath,
        'fileName': fileName,
        'contentType': contentType,
        'metadata': metadata,
        'categoryId': categoryId,
      });

      debugPrint('✅ File upload processed successfully');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Error processing file upload: $e');
      rethrow;
    }
  }

  /// Validate file before upload
  /// DEPRECATED: This functionality is now integrated into hybridProcessFileUpload
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

  /// Generate thumbnail for image files
  /// DEPRECATED: Thumbnail generation removed due to implementation complexity
  @Deprecated(
    'Thumbnail generation removed - too complex to implement and maintain',
  )
  Future<String?> generateThumbnail(String filePath) async {
    debugPrint('⚠️ DEPRECATED: generateThumbnail() is deprecated and removed.');
    return null; // Always return null - no thumbnail generation
  }

  /// Extract metadata from uploaded file
  /// DEPRECATED: This functionality is now integrated into hybridProcessFileUpload
  @Deprecated(
    'Use hybridProcessFileUpload instead - metadata extraction is integrated',
  )
  Future<Map<String, dynamic>> extractMetadata({
    required String filePath,
    required String contentType,
  }) async {
    debugPrint(
      '⚠️ DEPRECATED: extractMetadata() is deprecated. Use hybridProcessFileUpload instead.',
    );

    // Return basic metadata for backward compatibility
    return {
      'fileName': filePath.split('/').last,
      'contentType': contentType,
      'message': 'Metadata extraction moved to hybridProcessFileUpload',
      'deprecated': true,
    };
  }

  /// Check for duplicate files before upload
  /// DEPRECATED: This functionality is now integrated into hybridProcessFileUpload
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

  /// Get storage quota information
  Future<Map<String, dynamic>> getStorageQuota() async {
    try {
      final callable = _functions.httpsCallable('getStorageQuota');
      final result = await callable.call();

      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Failed to get storage quota: $e');
      rethrow;
    }
  }

  /// Check if storage quota is exceeded
  Future<bool> isStorageQuotaExceeded() async {
    try {
      final quota = await getStorageQuota();
      final used = quota['used'] as int? ?? 0;
      final limit = quota['limit'] as int? ?? 0;

      if (limit == 0) return false; // No limit set

      final usagePercentage = (used / limit) * 100;
      return usagePercentage >= 95; // Consider 95% as exceeded
    } catch (e) {
      debugPrint('❌ Failed to check storage quota: $e');
      return false; // Assume not exceeded if check fails
    }
  }

  /// Get storage usage statistics
  Future<Map<String, dynamic>> getStorageStats() async {
    try {
      final quota = await getStorageQuota();
      final used = quota['used'] as int? ?? 0;
      final limit = quota['limit'] as int? ?? 0;

      double usagePercentage = 0;
      if (limit > 0) {
        usagePercentage = (used / limit) * 100;
      }

      return {
        'used': used,
        'limit': limit,
        'usagePercentage': usagePercentage,
        'remainingBytes': limit > 0 ? limit - used : -1,
        'isNearLimit': usagePercentage >= 80,
        'isExceeded': usagePercentage >= 95,
      };
    } catch (e) {
      debugPrint('❌ Failed to get storage stats: $e');
      return {
        'used': 0,
        'limit': 0,
        'usagePercentage': 0.0,
        'remainingBytes': -1,
        'isNearLimit': false,
        'isExceeded': false,
      };
    }
  }

  /// Get file access URL with expiration
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

      final callable = _functions.httpsCallable('getFileAccessUrl');
      final result = await callable.call({
        'filePath': sanitizedPath,
        'expirationMinutes': expiration?.inMinutes ?? 60, // Default 1 hour
      });

      final data = Map<String, dynamic>.from(result.data);
      debugPrint('✅ File access URL retrieved successfully');
      return data['url'] as String;
    } catch (e) {
      debugPrint('❌ Failed to get file access URL: $e');
      rethrow;
    }
  }

  // Category Management Functions

  /// Create a new category
  Future<String> createCategory({
    required String name,
    String? description,
    List<String>? permissions,
    bool isActive = true,
  }) async {
    try {
      debugPrint('🔄 Creating category via Cloud Function: $name');

      final callable = _functions.httpsCallable('createCategory');
      final result = await callable.call({
        'name': name,
        'description': description,
        'permissions': permissions,
        'isActive': isActive,
      });

      debugPrint('✅ Category created successfully');
      return result.data['categoryId'];
    } catch (e) {
      debugPrint('❌ Error creating category: $e');
      rethrow;
    }
  }

  /// Update an existing category
  Future<void> updateCategory({
    required String categoryId,
    String? name,
    String? description,
    List<String>? permissions,
    bool? isActive,
  }) async {
    try {
      debugPrint('🔄 Updating category via Cloud Function: $categoryId');

      final callable = _functions.httpsCallable('updateCategory');
      await callable.call({
        'categoryId': categoryId,
        'name': name,
        'description': description,
        'permissions': permissions,
        'isActive': isActive,
      });

      debugPrint('✅ Category updated successfully');
    } catch (e) {
      debugPrint('❌ Error updating category: $e');
      rethrow;
    }
  }

  /// Delete a category
  Future<Map<String, dynamic>> deleteCategory(String categoryId) async {
    try {
      debugPrint('🔄 Deleting category via Cloud Function: $categoryId');

      final callable = _functions.httpsCallable('deleteCategory');
      final result = await callable.call({'categoryId': categoryId});

      debugPrint('✅ Category deleted successfully');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Error deleting category: $e');
      rethrow;
    }
  }

  /// Add files to a category
  Future<void> addFilesToCategory({
    required String categoryId,
    required List<String> documentIds,
  }) async {
    try {
      debugPrint(
        '🔄 Adding ${documentIds.length} files to category: $categoryId',
      );

      final callable = _functions.httpsCallable('addFilesToCategory');
      await callable.call({
        'categoryId': categoryId,
        'documentIds': documentIds,
      });

      debugPrint('✅ Files added to category successfully');
    } catch (e) {
      debugPrint('❌ Error adding files to category: $e');
      rethrow;
    }
  }

  /// Remove files from a category
  Future<void> removeFilesFromCategory({
    required String categoryId,
    required List<String> documentIds,
  }) async {
    try {
      debugPrint(
        '🔄 Removing ${documentIds.length} files from category: $categoryId',
      );

      final callable = _functions.httpsCallable('removeFilesFromCategory');
      await callable.call({
        'categoryId': categoryId,
        'documentIds': documentIds,
      });

      debugPrint('✅ Files removed from category successfully');
    } catch (e) {
      debugPrint('❌ Error removing files from category: $e');
      rethrow;
    }
  }

  // User Management Functions

  /// Create a new user
  Future<String> createUser({
    required String fullName,
    required String email,
    required String password,
    required String role,
    Map<String, dynamic>? permissions,
  }) async {
    try {
      debugPrint('🔄 Creating user via Cloud Function: $email');

      final callable = _functions.httpsCallable('createUser');
      final result = await callable.call({
        'fullName': fullName,
        'email': email,
        'password': password,
        'role': role,
        'permissions': permissions,
      });

      debugPrint('✅ User created successfully');
      return result.data['userId'];
    } catch (e) {
      debugPrint('❌ Error creating user: $e');
      rethrow;
    }
  }

  /// Auto-sync all Firebase Auth users to Firestore
  Future<Map<String, dynamic>> autoSyncFirebaseAuthUsers() async {
    try {
      debugPrint('🔄 Auto-syncing Firebase Auth users');

      final callable = _functions.httpsCallable('autoSyncFirebaseAuthUsers');
      final result = await callable.call();

      debugPrint('✅ Firebase Auth users auto-synced successfully');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Error auto-syncing Firebase Auth users: $e');
      rethrow;
    }
  }

  /// Update user permissions
  Future<void> updateUserPermissions({
    required String userId,
    required Map<String, dynamic> permissions,
  }) async {
    try {
      debugPrint('🔄 Updating user permissions via Cloud Function: $userId');

      final callable = _functions.httpsCallable('updateUserPermissions');
      await callable.call({'userId': userId, 'permissions': permissions});

      debugPrint('✅ User permissions updated successfully');
    } catch (e) {
      debugPrint('❌ Error updating user permissions: $e');
      rethrow;
    }
  }

  /// Delete a user
  Future<void> deleteUser(String userId) async {
    try {
      debugPrint('🔄 Deleting user via Cloud Function: $userId');

      final callable = _functions.httpsCallable('deleteUser');
      await callable.call({'userId': userId});

      debugPrint('✅ User deleted successfully');
    } catch (e) {
      debugPrint('❌ Error deleting user: $e');
      rethrow;
    }
  }

  /// Bulk user operations
  Future<Map<String, dynamic>> bulkUserOperations({
    required String operation,
    required List<String> userIds,
  }) async {
    try {
      debugPrint('🔄 Performing bulk $operation on ${userIds.length} users');

      final callable = _functions.httpsCallable('bulkUserOperations');
      final result = await callable.call({
        'operation': operation,
        'userIds': userIds,
      });

      debugPrint('✅ Bulk user operation completed');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Error in bulk user operations: $e');
      rethrow;
    }
  }

  // Document Management Functions

  /// Delete a document permanently
  Future<Map<String, dynamic>> deleteDocument(String documentId) async {
    try {
      debugPrint('🔄 Deleting document via Cloud Function: $documentId');

      final callable = _functions.httpsCallable('deleteDocument');
      final result = await callable.call({'documentId': documentId});

      debugPrint('✅ Document deleted successfully');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Error deleting document: $e');
      rethrow;
    }
  }

  /// Bulk document operations
  Future<Map<String, dynamic>> bulkDocumentOperations({
    required String operation,
    required List<String> documentIds,
    String? reason,
  }) async {
    try {
      debugPrint(
        '🔄 Performing bulk $operation on ${documentIds.length} documents',
      );

      final callable = _functions.httpsCallable('bulkDocumentOperations');
      final result = await callable.call({
        'operation': operation,
        'documentIds': documentIds,
        'reason': reason,
      });

      debugPrint('✅ Bulk document operation completed');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Error in bulk document operations: $e');
      rethrow;
    }
  }

  /// Generate document report
  Future<Map<String, dynamic>> generateDocumentReport({
    required String startDate,
    required String endDate,
    String? categoryId,
    String? userId,
    String? status,
  }) async {
    try {
      debugPrint('🔄 Generating document report via Cloud Function');

      final callable = _functions.httpsCallable('generateDocumentReport');
      final result = await callable.call({
        'startDate': startDate,
        'endDate': endDate,
        'categoryId': categoryId,
        'userId': userId,
        'status': status,
      });

      debugPrint('✅ Document report generated successfully');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Error generating document report: $e');
      rethrow;
    }
  }

  // Sync Operations Functions

  /// Sync Firebase Storage with Firestore
  Future<Map<String, dynamic>> syncStorageWithFirestore() async {
    try {
      debugPrint('🔄 Starting Storage to Firestore sync via Cloud Function');

      final callable = _functions.httpsCallable('syncStorageWithFirestore');
      final result = await callable.call({});

      debugPrint('✅ Storage sync completed successfully');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Error in storage sync: $e');
      rethrow;
    }
  }

  /// Clean up orphaned metadata
  Future<Map<String, dynamic>> cleanupOrphanedMetadata() async {
    try {
      debugPrint('🔄 Starting orphaned metadata cleanup via Cloud Function');

      final callable = _functions.httpsCallable('cleanupOrphanedMetadata');
      final result = await callable.call({});

      debugPrint('✅ Orphaned metadata cleanup completed successfully');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Error in orphaned metadata cleanup: $e');
      rethrow;
    }
  }

  /// Perform comprehensive sync
  Future<Map<String, dynamic>> performComprehensiveSync() async {
    try {
      debugPrint('🔄 Starting comprehensive sync via Cloud Function');

      final callable = _functions.httpsCallable('performComprehensiveSync');
      final result = await callable.call({});

      debugPrint('✅ Comprehensive sync completed successfully');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Error in comprehensive sync: $e');
      rethrow;
    }
  }

  /// Clean up orphaned files
  Future<Map<String, dynamic>> cleanupOrphanedFiles() async {
    try {
      debugPrint('🔄 Starting orphaned files cleanup via Cloud Function');

      final callable = _functions.httpsCallable('cleanupOrphanedFiles');
      final result = await callable.call({});

      debugPrint('✅ Orphaned files cleanup completed successfully');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Error in orphaned files cleanup: $e');
      rethrow;
    }
  }

  /// Batch process files
  Future<List<Map<String, dynamic>>> batchProcessFiles({
    required List<String> filePaths,
    required String operation,
    Map<String, dynamic>? options,
  }) async {
    try {
      debugPrint(
        '🔄 Batch processing ${filePaths.length} files with operation: $operation',
      );

      final callable = _functions.httpsCallable('batchProcessFiles');
      final result = await callable.call({
        'filePaths': filePaths,
        'operation': operation,
        'options': options,
      });

      debugPrint('✅ Batch file processing completed successfully');
      return List<Map<String, dynamic>>.from(result.data['results'] ?? []);
    } catch (e) {
      debugPrint('❌ Error in batch file processing: $e');
      rethrow;
    }
  }

  // Notification Functions

  /// Send notification to a user
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String message,
    String type = 'info',
    Map<String, dynamic>? data,
  }) async {
    try {
      final callable = _functions.httpsCallable('sendNotification');
      await callable.call({
        'userId': userId,
        'title': title,
        'message': message,
        'type': type,
        'data': data,
      });

      debugPrint('✅ Notification sent successfully');
    } catch (e) {
      debugPrint('❌ Error sending notification: $e');
      rethrow;
    }
  }

  /// Process activity log
  Future<void> processActivityLog({
    required String type,
    required String userId,
    required String details,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final callable = _functions.httpsCallable('processActivityLog');
      await callable.call({
        'type': type,
        'userId': userId,
        'details': details,
        'metadata': metadata,
      });

      debugPrint('✅ Activity log processed successfully');
    } catch (e) {
      debugPrint('❌ Error processing activity log: $e');
      rethrow;
    }
  }

  /// Get category documents with enhanced features
  Future<Map<String, dynamic>> getCategoryDocumentsEnhanced({
    required String categoryId,
    bool includeMetadata = true,
  }) async {
    try {
      debugPrint(
        '🔄 Getting enhanced category documents via Cloud Functions: $categoryId',
      );

      final callable = _functions.httpsCallable('getCategoryDocumentsEnhanced');
      final result = await callable.call({
        'categoryId': categoryId,
        'includeMetadata': includeMetadata,
      });

      debugPrint('✅ Enhanced category documents retrieved successfully');
      return result.data as Map<String, dynamic>;
    } catch (e) {
      debugPrint('❌ Error getting enhanced category documents: $e');
      rethrow;
    }
  }

  /// Force refresh category contents from Firebase
  Future<Map<String, dynamic>> refreshCategoryContents({
    String? categoryId,
  }) async {
    try {
      debugPrint(
        '🔄 Refreshing category contents via Cloud Functions: ${categoryId ?? 'all'}',
      );

      final callable = _functions.httpsCallable('refreshCategoryContents');
      final result = await callable.call({'categoryId': categoryId});

      debugPrint('✅ Category contents refreshed successfully');
      return result.data as Map<String, dynamic>;
    } catch (e) {
      debugPrint('❌ Error refreshing category contents: $e');
      rethrow;
    }
  }

  // Sync Operations Functions

  /// Sync orphaned Storage files to Firestore
  Future<Map<String, dynamic>> syncStorageToFirestore() async {
    try {
      debugPrint('🔄 Starting storage-to-firestore sync via Cloud Function');

      final callable = _functions.httpsCallable('syncStorageToFirestore');
      final result = await callable.call({});

      debugPrint('✅ Storage sync completed successfully');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Error in storage sync: $e');
      rethrow;
    }
  }

  /// Generic function caller for any Cloud Function
  Future<Map<String, dynamic>> callFunction(
    String functionName,
    Map<String, dynamic> data,
  ) async {
    try {
      debugPrint('🔄 Calling Cloud Function: $functionName');

      final callable = _functions.httpsCallable(functionName);
      final result = await callable.call(data);

      debugPrint('✅ Cloud Function $functionName completed successfully');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      debugPrint('❌ Error calling Cloud Function $functionName: $e');
      rethrow;
    }
  }
}
