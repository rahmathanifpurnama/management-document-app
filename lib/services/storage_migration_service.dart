import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import '../core/services/firebase_service.dart';
import '../core/services/user_service.dart';
import '../models/document_model.dart';

/// Service to handle migration from UID-based to email-based storage structure
class StorageMigrationService {
  static StorageMigrationService? _instance;
  static StorageMigrationService get instance =>
      _instance ??= StorageMigrationService._();

  StorageMigrationService._();

  final FirebaseService _firebaseService = FirebaseService.instance;
  final UserService _userService = UserService.instance;

  /// Check if migration is needed by analyzing existing storage structure
  Future<MigrationStatus> checkMigrationStatus() async {
    try {
      debugPrint('🔍 Checking storage migration status...');

      // Get all documents from Firestore
      final documentsSnapshot = await _firebaseService.documentsCollection
          .get();

      if (documentsSnapshot.docs.isEmpty) {
        return MigrationStatus(
          isNeeded: false,
          totalFiles: 0,
          uidBasedFiles: 0,
          emailBasedFiles: 0,
          message: 'No documents found - migration not needed',
        );
      }

      int totalFiles = 0;
      int uidBasedFiles = 0;
      int emailBasedFiles = 0;

      // Analyze storage paths to determine structure
      for (final doc in documentsSnapshot.docs) {
        final document = DocumentModel.fromFirestore(doc);
        totalFiles++;

        // Check if file exists in storage and determine structure
        final storageAnalysis = await _analyzeFileStorageStructure(document);

        if (storageAnalysis.isUidBased) {
          uidBasedFiles++;
        } else if (storageAnalysis.isEmailBased) {
          emailBasedFiles++;
        }
      }

      final isNeeded = uidBasedFiles > 0;

      return MigrationStatus(
        isNeeded: isNeeded,
        totalFiles: totalFiles,
        uidBasedFiles: uidBasedFiles,
        emailBasedFiles: emailBasedFiles,
        message: isNeeded
            ? 'Migration needed: $uidBasedFiles files using old UID structure'
            : 'All files already using new email structure',
      );
    } catch (e) {
      debugPrint('❌ Error checking migration status: $e');
      return MigrationStatus(
        isNeeded: false,
        totalFiles: 0,
        uidBasedFiles: 0,
        emailBasedFiles: 0,
        message: 'Error checking migration status: $e',
      );
    }
  }

  /// Analyze a single file's storage structure
  Future<StorageAnalysis> _analyzeFileStorageStructure(
    DocumentModel document,
  ) async {
    try {
      // Try UID-based path first
      final uidPath = 'documents/${document.uploadedBy}/${document.fileName}';
      final uidRef = FirebaseStorage.instance.ref().child(uidPath);

      bool uidExists = false;
      try {
        await uidRef.getMetadata();
        uidExists = true;
      } catch (e) {
        uidExists = false;
      }

      if (uidExists) {
        return StorageAnalysis(
          actualPath: uidPath,
          isUidBased: true,
          isEmailBased: false,
          exists: true,
        );
      }

      // Try email-based path
      final user = await _userService.getUserById(document.uploadedBy);
      if (user != null) {
        final sanitizedEmail = _sanitizeEmailForStorage(user.email);
        final emailPath = 'documents/$sanitizedEmail/${document.fileName}';
        final emailRef = FirebaseStorage.instance.ref().child(emailPath);

        bool emailExists = false;
        try {
          await emailRef.getMetadata();
          emailExists = true;
        } catch (e) {
          emailExists = false;
        }

        if (emailExists) {
          return StorageAnalysis(
            actualPath: emailPath,
            isUidBased: false,
            isEmailBased: true,
            exists: true,
          );
        }
      }

      // File not found in either structure
      return StorageAnalysis(
        actualPath: null,
        isUidBased: false,
        isEmailBased: false,
        exists: false,
      );
    } catch (e) {
      debugPrint('❌ Error analyzing file storage: $e');
      return StorageAnalysis(
        actualPath: null,
        isUidBased: false,
        isEmailBased: false,
        exists: false,
      );
    }
  }

  /// Perform migration for a single file
  Future<MigrationResult> migrateFile(DocumentModel document) async {
    try {
      debugPrint('🔄 Migrating file: ${document.fileName}');

      // Get user data for email-based path
      final user = await _userService.getUserById(document.uploadedBy);
      if (user == null) {
        return MigrationResult(
          success: false,
          message: 'User not found for file: ${document.fileName}',
        );
      }

      final oldPath = 'documents/${document.uploadedBy}/${document.fileName}';
      final sanitizedEmail = _sanitizeEmailForStorage(user.email);
      final newPath = 'documents/$sanitizedEmail/${document.fileName}';

      // Check if old file exists
      final oldRef = FirebaseStorage.instance.ref().child(oldPath);
      bool oldExists = false;
      try {
        await oldRef.getMetadata();
        oldExists = true;
      } catch (e) {
        oldExists = false;
      }

      if (!oldExists) {
        return MigrationResult(
          success: false,
          message: 'Source file not found: $oldPath',
        );
      }

      // Check if new file already exists
      final newRef = FirebaseStorage.instance.ref().child(newPath);
      bool newExists = false;
      try {
        await newRef.getMetadata();
        newExists = true;
      } catch (e) {
        newExists = false;
      }

      if (newExists) {
        return MigrationResult(
          success: false,
          message: 'Target file already exists: $newPath',
        );
      }

      // Copy file to new location
      await _copyFile(oldRef, newRef);

      // Verify copy was successful
      bool copyExists = false;
      try {
        await newRef.getMetadata();
        copyExists = true;
      } catch (e) {
        copyExists = false;
      }

      if (!copyExists) {
        return MigrationResult(
          success: false,
          message: 'Failed to copy file to new location',
        );
      }

      // Delete old file
      await oldRef.delete();

      debugPrint('✅ Successfully migrated: $oldPath -> $newPath');
      return MigrationResult(
        success: true,
        message: 'Successfully migrated: ${document.fileName}',
      );
    } catch (e) {
      debugPrint('❌ Error migrating file: $e');
      return MigrationResult(success: false, message: 'Migration failed: $e');
    }
  }

  /// Copy file from old location to new location
  Future<void> _copyFile(Reference source, Reference destination) async {
    // Download file data
    final data = await source.getData();
    if (data == null) {
      throw Exception('Failed to download source file');
    }

    // Get metadata
    final metadata = await source.getMetadata();

    // Upload to new location with same metadata
    await destination.putData(
      data,
      SettableMetadata(
        contentType: metadata.contentType,
        customMetadata: metadata.customMetadata,
      ),
    );
  }

  /// Sanitize email address for Firebase Storage path compatibility
  String _sanitizeEmailForStorage(String email) {
    return email
        .replaceAll('@', '-at-')
        .replaceAll('.', '-dot-')
        .replaceAll('+', '-plus-')
        .replaceAll(' ', '-')
        .toLowerCase();
  }

  /// Perform batch migration with progress tracking
  Future<BatchMigrationResult> performBatchMigration({
    required Function(int current, int total, String fileName) onProgress,
  }) async {
    try {
      debugPrint('🚀 Starting batch migration...');

      // Get migration status first
      final status = await checkMigrationStatus();
      if (!status.isNeeded) {
        return BatchMigrationResult(
          success: true,
          totalFiles: 0,
          migratedFiles: 0,
          failedFiles: 0,
          message: 'No migration needed',
        );
      }

      // Get all documents that need migration
      final documentsSnapshot = await _firebaseService.documentsCollection
          .get();
      final documents = documentsSnapshot.docs
          .map((doc) => DocumentModel.fromFirestore(doc))
          .toList();

      int migratedFiles = 0;
      int failedFiles = 0;
      final failedFilesList = <String>[];

      for (int i = 0; i < documents.length; i++) {
        final document = documents[i];
        onProgress(i + 1, documents.length, document.fileName);

        // Check if file needs migration
        final analysis = await _analyzeFileStorageStructure(document);
        if (!analysis.isUidBased) {
          continue; // Skip files that don't need migration
        }

        // Perform migration
        final result = await migrateFile(document);
        if (result.success) {
          migratedFiles++;
        } else {
          failedFiles++;
          failedFilesList.add('${document.fileName}: ${result.message}');
        }

        // Add small delay to prevent overwhelming Firebase
        await Future.delayed(const Duration(milliseconds: 100));
      }

      final message = failedFiles > 0
          ? 'Migration completed with errors. Failed files: ${failedFilesList.join(', ')}'
          : 'Migration completed successfully';

      return BatchMigrationResult(
        success: failedFiles == 0,
        totalFiles: documents.length,
        migratedFiles: migratedFiles,
        failedFiles: failedFiles,
        message: message,
      );
    } catch (e) {
      debugPrint('❌ Batch migration failed: $e');
      return BatchMigrationResult(
        success: false,
        totalFiles: 0,
        migratedFiles: 0,
        failedFiles: 0,
        message: 'Batch migration failed: $e',
      );
    }
  }
}

/// Migration status information
class MigrationStatus {
  final bool isNeeded;
  final int totalFiles;
  final int uidBasedFiles;
  final int emailBasedFiles;
  final String message;

  MigrationStatus({
    required this.isNeeded,
    required this.totalFiles,
    required this.uidBasedFiles,
    required this.emailBasedFiles,
    required this.message,
  });
}

/// Storage analysis result for a single file
class StorageAnalysis {
  final String? actualPath;
  final bool isUidBased;
  final bool isEmailBased;
  final bool exists;

  StorageAnalysis({
    required this.actualPath,
    required this.isUidBased,
    required this.isEmailBased,
    required this.exists,
  });
}

/// Migration result for a single file
class MigrationResult {
  final bool success;
  final String message;

  MigrationResult({required this.success, required this.message});
}

/// Batch migration result
class BatchMigrationResult {
  final bool success;
  final int totalFiles;
  final int migratedFiles;
  final int failedFiles;
  final String message;

  BatchMigrationResult({
    required this.success,
    required this.totalFiles,
    required this.migratedFiles,
    required this.failedFiles,
    required this.message,
  });
}
