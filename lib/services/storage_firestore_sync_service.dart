import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../core/services/firebase_service.dart';
import 'admin_permission_service.dart';

/// Service for synchronizing Firebase Storage files with Firestore metadata
/// Handles orphaned files that exist in Storage but not in Firestore
class StorageFirestoreSyncService {
  static const String _logPrefix = '🔄 STORAGE_SYNC';

  final FirebaseService _firebaseService = FirebaseService.instance;
  final AdminPermissionService _adminService = AdminPermissionService.instance;

  static StorageFirestoreSyncService? _instance;
  static StorageFirestoreSyncService get instance {
    _instance ??= StorageFirestoreSyncService._internal();
    return _instance!;
  }

  StorageFirestoreSyncService._internal();

  /// Sync all orphaned files from Storage to Firestore
  /// Only admin users can perform this operation
  Future<StorageSyncResult> syncStorageToFirestore({
    required String adminUserId,
    Function(StorageSyncProgress)? onProgress,
  }) async {
    try {
      debugPrint('$_logPrefix Starting storage-to-firestore sync...');

      // Verify admin permissions
      final isAdmin = await _adminService.isUserAdmin(adminUserId);
      if (!isAdmin) {
        return StorageSyncResult.unauthorized(
          message: 'Only administrators can perform storage sync operations',
        );
      }

      final startTime = DateTime.now();
      var result = StorageSyncResult();

      // Step 1: Get all files from Firebase Storage
      onProgress?.call(
        StorageSyncProgress(
          phase: SyncPhase.scanningStorage,
          message: 'Scanning Firebase Storage for files...',
          processedFiles: 0,
          totalFiles: 0,
        ),
      );

      final storageFiles = await _getAllStorageFiles();
      result = result.copyWith(totalStorageFiles: storageFiles.length);

      debugPrint('$_logPrefix Found ${storageFiles.length} files in Storage');

      if (storageFiles.isEmpty) {
        return result.copyWith(
          success: true,
          message: 'No files found in Firebase Storage',
          duration: DateTime.now().difference(startTime),
        );
      }

      // Step 2: Check which files are missing from Firestore
      onProgress?.call(
        StorageSyncProgress(
          phase: SyncPhase.checkingFirestore,
          message: 'Checking Firestore for existing records...',
          processedFiles: 0,
          totalFiles: storageFiles.length,
        ),
      );

      final orphanedFiles = <StorageFileInfo>[];
      int processedCount = 0;

      for (final file in storageFiles) {
        final existsInFirestore = await _checkFileExistsInFirestore(file.path);
        if (!existsInFirestore) {
          orphanedFiles.add(file);
        }

        processedCount++;
        if (processedCount % 10 == 0) {
          onProgress?.call(
            StorageSyncProgress(
              phase: SyncPhase.checkingFirestore,
              message:
                  'Checked $processedCount/${storageFiles.length} files...',
              processedFiles: processedCount,
              totalFiles: storageFiles.length,
            ),
          );
        }
      }

      result = result.copyWith(orphanedFiles: orphanedFiles.length);
      debugPrint('$_logPrefix Found ${orphanedFiles.length} orphaned files');

      if (orphanedFiles.isEmpty) {
        return result.copyWith(
          success: true,
          message: 'All storage files already have Firestore records',
          duration: DateTime.now().difference(startTime),
        );
      }

      // Step 3: Create Firestore records for orphaned files
      onProgress?.call(
        StorageSyncProgress(
          phase: SyncPhase.creatingRecords,
          message: 'Creating Firestore records for orphaned files...',
          processedFiles: 0,
          totalFiles: orphanedFiles.length,
        ),
      );

      int createdCount = 0;
      int errorCount = 0;
      final errors = <String>[];

      for (int i = 0; i < orphanedFiles.length; i++) {
        final file = orphanedFiles[i];

        try {
          await _createFirestoreRecord(file, adminUserId);
          createdCount++;

          onProgress?.call(
            StorageSyncProgress(
              phase: SyncPhase.creatingRecords,
              message:
                  'Created $createdCount/${orphanedFiles.length} records...',
              processedFiles: i + 1,
              totalFiles: orphanedFiles.length,
            ),
          );
        } catch (e) {
          errorCount++;
          final errorMsg = 'Failed to create record for ${file.name}: $e';
          errors.add(errorMsg);
          debugPrint('$_logPrefix ❌ $errorMsg');
        }
      }

      result = result.copyWith(createdRecords: createdCount, errors: errors);

      final duration = DateTime.now().difference(startTime);
      final success = createdCount > 0 || orphanedFiles.isEmpty;

      onProgress?.call(
        StorageSyncProgress(
          phase: SyncPhase.completed,
          message: success
              ? 'Sync completed successfully!'
              : 'Sync completed with errors',
          processedFiles: orphanedFiles.length,
          totalFiles: orphanedFiles.length,
        ),
      );

      return result.copyWith(
        success: success,
        message: _generateSyncSummary(
          createdCount,
          errorCount,
          orphanedFiles.length,
        ),
        duration: duration,
      );
    } catch (e) {
      debugPrint('$_logPrefix ❌ Sync operation failed: $e');
      return StorageSyncResult.error(
        message: 'Sync operation failed: ${e.toString()}',
      );
    }
  }

  /// Get all files from Firebase Storage documents folder
  Future<List<StorageFileInfo>> _getAllStorageFiles() async {
    final files = <StorageFileInfo>[];

    try {
      final storageRef = _firebaseService.storage.ref().child('documents');
      final listResult = await storageRef.listAll();

      // Process files in root documents folder
      for (final item in listResult.items) {
        final metadata = await item.getMetadata();
        files.add(
          StorageFileInfo(
            name: item.name,
            path: item.fullPath,
            size: metadata.size ?? 0,
            contentType: metadata.contentType ?? 'application/octet-stream',
            timeCreated: metadata.timeCreated ?? DateTime.now(),
          ),
        );
      }

      // Process subdirectories (categories, user folders)
      for (final prefix in listResult.prefixes) {
        final subFiles = await _getFilesFromPrefix(prefix);
        files.addAll(subFiles);
      }
    } catch (e) {
      debugPrint('$_logPrefix ❌ Error scanning storage: $e');
    }

    return files;
  }

  /// Recursively get files from a storage prefix
  Future<List<StorageFileInfo>> _getFilesFromPrefix(Reference prefix) async {
    final files = <StorageFileInfo>[];

    try {
      final listResult = await prefix.listAll();

      // Add files from this level
      for (final item in listResult.items) {
        final metadata = await item.getMetadata();
        files.add(
          StorageFileInfo(
            name: item.name,
            path: item.fullPath,
            size: metadata.size ?? 0,
            contentType: metadata.contentType ?? 'application/octet-stream',
            timeCreated: metadata.timeCreated ?? DateTime.now(),
          ),
        );
      }

      // Recursively process subdirectories
      for (final subPrefix in listResult.prefixes) {
        final subFiles = await _getFilesFromPrefix(subPrefix);
        files.addAll(subFiles);
      }
    } catch (e) {
      debugPrint('$_logPrefix ⚠️ Error scanning prefix ${prefix.fullPath}: $e');
    }

    return files;
  }

  /// Check if a file exists in Firestore by file path
  Future<bool> _checkFileExistsInFirestore(String filePath) async {
    try {
      final querySnapshot = await _firebaseService.documentsCollection
          .where('filePath', isEqualTo: filePath)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint('$_logPrefix ⚠️ Error checking Firestore for $filePath: $e');
      return false;
    }
  }

  /// Create Firestore record for orphaned storage file
  Future<void> _createFirestoreRecord(
    StorageFileInfo file,
    String adminUserId,
  ) async {
    final documentId = _generateDocumentId();

    // Generate download URL for the file
    String? downloadUrl;
    try {
      final storageRef = _firebaseService.storage.ref().child(file.path);
      downloadUrl = await storageRef.getDownloadURL();
    } catch (e) {
      debugPrint(
        '$_logPrefix ⚠️ Failed to generate download URL for ${file.name}: $e',
      );
    }

    final documentData = {
      'id': documentId,
      'fileName': file.name,
      'filePath': file.path,
      'fileSize': file.size,
      'fileType': _getFileTypeFromContentType(file.contentType),
      'uploadedBy': adminUserId,
      'uploadedAt': Timestamp.fromDate(file.timeCreated),
      'downloadUrl': downloadUrl,
      'category': _extractCategoryFromPath(file.path),
      'status': 'active',
      'isActive': true,
      'permissions': [adminUserId],
      'metadata': {
        'description': 'Auto-synced from Storage',
        'tags': ['storage-synced'],
        'version': '1.0',
        'contentType': file.contentType,
        'syncedAt': FieldValue.serverTimestamp(),
        'createdBy': 'storage_sync_service',
        'unifiedIdSystem': true,
      },
    };

    // ENHANCED: Use atomic transaction to ensure both collections are updated together
    final batch = _firebaseService.firestore.batch();

    // Add document-metadata record to batch
    final docRef = _firebaseService.documentsCollection.doc(documentId);
    batch.set(docRef, documentData);

    // Add activity log to batch
    final activityRef = _firebaseService.firestore
        .collection('activities')
        .doc();
    batch.set(activityRef, {
      'type': 'file_synced',
      'documentId': documentId,
      'userId': adminUserId,
      'timestamp': FieldValue.serverTimestamp(),
      'details': 'File ${file.name} synced from Storage to Firestore',
      'syncSource': 'storage_sync_service',
    });

    // Commit both operations atomically
    await batch.commit();

    debugPrint(
      '$_logPrefix ✅ Created Firestore record and activity log for: ${file.name}',
    );
  }

  /// Generate unique document ID
  String _generateDocumentId() {
    return _firebaseService.documentsCollection.doc().id;
  }

  /// Extract file type from content type
  String _getFileTypeFromContentType(String contentType) {
    if (contentType.contains('pdf')) return 'PDF';
    if (contentType.contains('image')) return 'Image';
    if (contentType.contains('word') || contentType.contains('document')) {
      return 'Document';
    }
    if (contentType.contains('sheet') ||
        contentType.contains('excel') ||
        contentType.contains('csv')) {
      // Added CSV support
      return 'Excel'; // Group CSV with Excel for filtering
    }
    return 'Other';
  }

  /// Extract category from file path
  String _extractCategoryFromPath(String filePath) {
    final parts = filePath.split('/');
    if (parts.length >= 3 && parts[1] == 'categories') {
      return parts[2];
    }
    return 'general';
  }

  /// Generate sync operation summary message
  String _generateSyncSummary(int created, int errors, int total) {
    if (errors == 0) {
      return 'Successfully created $created Firestore records for orphaned files';
    } else {
      return 'Created $created records, $errors errors out of $total orphaned files';
    }
  }
}

/// Information about a file in Firebase Storage
class StorageFileInfo {
  final String name;
  final String path;
  final int size;
  final String contentType;
  final DateTime timeCreated;

  StorageFileInfo({
    required this.name,
    required this.path,
    required this.size,
    required this.contentType,
    required this.timeCreated,
  });
}

/// Result of storage sync operation
class StorageSyncResult {
  final bool success;
  final String message;
  final Duration? duration;
  final int totalStorageFiles;
  final int orphanedFiles;
  final int createdRecords;
  final List<String> errors;

  StorageSyncResult({
    this.success = false,
    this.message = '',
    this.duration,
    this.totalStorageFiles = 0,
    this.orphanedFiles = 0,
    this.createdRecords = 0,
    this.errors = const [],
  });

  factory StorageSyncResult.unauthorized({required String message}) {
    return StorageSyncResult(success: false, message: message);
  }

  factory StorageSyncResult.error({required String message}) {
    return StorageSyncResult(success: false, message: message);
  }

  StorageSyncResult copyWith({
    bool? success,
    String? message,
    Duration? duration,
    int? totalStorageFiles,
    int? orphanedFiles,
    int? createdRecords,
    List<String>? errors,
  }) {
    return StorageSyncResult(
      success: success ?? this.success,
      message: message ?? this.message,
      duration: duration ?? this.duration,
      totalStorageFiles: totalStorageFiles ?? this.totalStorageFiles,
      orphanedFiles: orphanedFiles ?? this.orphanedFiles,
      createdRecords: createdRecords ?? this.createdRecords,
      errors: errors ?? this.errors,
    );
  }
}

/// Progress information for sync operation
class StorageSyncProgress {
  final SyncPhase phase;
  final String message;
  final int processedFiles;
  final int totalFiles;

  StorageSyncProgress({
    required this.phase,
    required this.message,
    required this.processedFiles,
    required this.totalFiles,
  });

  double get progress {
    if (totalFiles == 0) return 0.0;
    return processedFiles / totalFiles;
  }
}

/// Phases of sync operation
enum SyncPhase {
  scanningStorage,
  checkingFirestore,
  creatingRecords,
  completed,
}
