import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../core/services/firebase_service.dart';
import '../core/services/document_service.dart';
import '../models/document_model.dart';

/// Service to synchronize Firebase Storage files with Firestore metadata
class FirebaseStorageSyncService {
  static FirebaseStorageSyncService? _instance;
  static FirebaseStorageSyncService get instance =>
      _instance ??= FirebaseStorageSyncService._();

  FirebaseStorageSyncService._();

  final FirebaseService _firebaseService = FirebaseService.instance;
  final DocumentService _documentService = DocumentService.instance;

  /// Sync all files from Firebase Storage with Firestore metadata
  Future<List<DocumentModel>> syncStorageWithFirestore() async {
    try {
      // Get all files from Firebase Storage /documents/ path
      final storageFiles = await _listAllStorageFiles();

      // Get all documents from Firestore
      final firestoreDocuments = await _documentService.getAllDocuments();

      // Find orphaned files (in Storage but not in Firestore)
      final orphanedFiles = await _findOrphanedFiles(
        storageFiles,
        firestoreDocuments,
      );

      // Create metadata for orphaned files
      final newDocuments = await _createMetadataForOrphanedFiles(orphanedFiles);

      // Combine existing and new documents
      final allDocuments = [...firestoreDocuments, ...newDocuments];

      // Verify file accessibility
      final accessibleDocuments = await _verifyFileAccessibility(allDocuments);

      // Only log if there are significant changes
      if (newDocuments.isNotEmpty || orphanedFiles.isNotEmpty) {
        debugPrint('📁 Found ${storageFiles.length} files in Firebase Storage');
        debugPrint(
          '📄 Found ${firestoreDocuments.length} documents in Firestore',
        );
        debugPrint('🔍 Found ${orphanedFiles.length} orphaned files');
        debugPrint(
          '✅ Created metadata for ${newDocuments.length} orphaned files',
        );
        debugPrint('✅ Verified ${accessibleDocuments.length} accessible files');
        debugPrint('🎉 Firebase Storage sync completed successfully');
      }

      return accessibleDocuments;
    } catch (e) {
      debugPrint('❌ Firebase Storage sync failed: $e');
      rethrow;
    }
  }

  /// List all files in Firebase Storage /documents/ path
  Future<List<Reference>> _listAllStorageFiles() async {
    try {
      final documentsRef = _firebaseService.storage.ref().child('documents');
      final listResult = await documentsRef.listAll();

      // Filter out system files like .keep
      final validFiles = listResult.items
          .where((ref) => !ref.name.startsWith('.') && ref.name.isNotEmpty)
          .toList();

      return validFiles;
    } catch (e) {
      debugPrint('❌ Failed to list storage files: $e');
      return [];
    }
  }

  /// Find files that exist in Storage but not in Firestore
  Future<List<Reference>> _findOrphanedFiles(
    List<Reference> storageFiles,
    List<DocumentModel> firestoreDocuments,
  ) async {
    final orphanedFiles = <Reference>[];

    for (final storageFile in storageFiles) {
      final storagePath = storageFile.fullPath;

      // Check if this storage file has corresponding Firestore metadata
      final hasMetadata = firestoreDocuments.any(
        (doc) =>
            doc.filePath == storagePath ||
            doc.filePath.contains(storageFile.name),
      );

      if (!hasMetadata) {
        orphanedFiles.add(storageFile);
        debugPrint('🔍 Orphaned file found: ${storageFile.name}');
      }
    }

    return orphanedFiles;
  }

  /// Create Firestore metadata for orphaned files
  Future<List<DocumentModel>> _createMetadataForOrphanedFiles(
    List<Reference> orphanedFiles,
  ) async {
    final newDocuments = <DocumentModel>[];

    for (final fileRef in orphanedFiles) {
      try {
        // Get file metadata from Storage
        final metadata = await fileRef.getMetadata();

        // Extract original filename and other info from custom metadata
        final originalName =
            metadata.customMetadata?['originalName'] ?? fileRef.name;
        final uploadedBy = metadata.customMetadata?['uploadedBy'] ?? 'unknown';
        final categoryId =
            metadata.customMetadata?['categoryId'] ?? 'uncategorized';
        final fileSize =
            int.tryParse(metadata.customMetadata?['fileSize'] ?? '0') ??
            metadata.size ??
            0;

        // Create document model
        final document = DocumentModel(
          id: _generateDocumentId(fileRef.name),
          fileName: originalName,
          fileSize: fileSize,
          fileType: _getFileTypeFromName(originalName),
          filePath: fileRef.fullPath,
          uploadedBy: uploadedBy,
          uploadedAt: metadata.timeCreated ?? DateTime.now(),
          category: categoryId,
          status: 'active',
          permissions: [uploadedBy],
          metadata: DocumentMetadata(
            description: 'Synced from Firebase Storage',
            tags: _generateTagsFromFileName(originalName),
          ),
        );

        // Save to Firestore
        await _documentService.addDocument(document);
        newDocuments.add(document);

        debugPrint('✅ Created metadata for: $originalName');
      } catch (e) {
        debugPrint('❌ Failed to create metadata for ${fileRef.name}: $e');
      }
    }

    return newDocuments;
  }

  /// Verify that all documents have accessible files in Storage
  Future<List<DocumentModel>> _verifyFileAccessibility(
    List<DocumentModel> documents,
  ) async {
    final accessibleDocuments = <DocumentModel>[];

    for (final document in documents) {
      try {
        if (document.filePath.startsWith('http')) {
          // Already has download URL, assume accessible
          accessibleDocuments.add(document);
        } else {
          // Verify file exists in Storage
          final storageRef = _firebaseService.storage.ref().child(
            document.filePath,
          );
          await storageRef
              .getMetadata(); // This will throw if file doesn't exist
          accessibleDocuments.add(document);
        }
      } catch (e) {
        debugPrint(
          '⚠️ File not accessible: ${document.fileName} (${e.toString()})',
        );
        // Optionally, you could mark these documents as inaccessible or remove them
      }
    }

    return accessibleDocuments;
  }

  /// Generate a unique document ID based on filename and timestamp
  String _generateDocumentId(String fileName) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final cleanName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    return 'doc_${timestamp}_$cleanName';
  }

  /// Get file type from filename extension
  String _getFileTypeFromName(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'PDF';
      case 'doc':
      case 'docx':
        return 'Word Document';
      case 'ppt':
      case 'pptx':
        return 'PowerPoint';
      case 'xls':
      case 'xlsx':
        return 'Excel';
      case 'jpg':
      case 'jpeg':
      case 'png':
        return 'Image';
      case 'txt':
        return 'Text';
      default:
        return 'Document';
    }
  }

  /// Generate tags from filename
  List<String> _generateTagsFromFileName(String fileName) {
    final baseName = fileName.split('.').first.toLowerCase();
    final words = baseName.split(RegExp(r'[_\-\s]+'));
    return words.where((word) => word.length > 2).toList();
  }

  /// Quick check to see if sync is needed
  Future<bool> isSyncNeeded() async {
    try {
      final storageFiles = await _listAllStorageFiles();
      final firestoreDocuments = await _documentService.getAllDocuments();

      // Simple check: if Storage has more files than Firestore, sync is needed
      return storageFiles.length > firestoreDocuments.length;
    } catch (e) {
      debugPrint('❌ Failed to check sync status: $e');
      return true; // Assume sync is needed if we can't check
    }
  }

  /// Get sync status information
  Future<Map<String, dynamic>> getSyncStatus() async {
    try {
      final storageFiles = await _listAllStorageFiles();
      final firestoreDocuments = await _documentService.getAllDocuments();
      final orphanedFiles = await _findOrphanedFiles(
        storageFiles,
        firestoreDocuments,
      );

      return {
        'storageFileCount': storageFiles.length,
        'firestoreDocumentCount': firestoreDocuments.length,
        'orphanedFileCount': orphanedFiles.length,
        'syncNeeded': orphanedFiles.isNotEmpty,
        'lastSyncCheck': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'error': e.toString(),
        'syncNeeded': true,
        'lastSyncCheck': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Force refresh all file metadata from Storage
  Future<void> refreshAllFileMetadata() async {
    try {
      debugPrint('🔄 Refreshing all file metadata from Storage...');

      final firestoreDocuments = await _documentService.getAllDocuments();
      int updatedCount = 0;

      for (final document in firestoreDocuments) {
        try {
          if (!document.filePath.startsWith('http') &&
              document.filePath.isNotEmpty) {
            final storageRef = _firebaseService.storage.ref().child(
              document.filePath,
            );
            final metadata = await storageRef.getMetadata();

            // Update document with fresh metadata if needed
            final updatedDocument = document.copyWith(
              fileSize: metadata.size ?? document.fileSize,
              uploadedAt: metadata.timeCreated ?? document.uploadedAt,
            );

            if (updatedDocument != document) {
              await _documentService.updateDocument(updatedDocument);
              updatedCount++;
            }
          }
        } catch (e) {
          debugPrint(
            '⚠️ Failed to refresh metadata for ${document.fileName}: $e',
          );
        }
      }

      debugPrint('✅ Refreshed metadata for $updatedCount documents');
    } catch (e) {
      debugPrint('❌ Failed to refresh file metadata: $e');
      rethrow;
    }
  }

  /// DISABLED: Clean up orphaned Firestore documents to prevent automatic deletions
  /// This function has been disabled to prevent unwanted metadata deletion
  Future<int> cleanupOrphanedMetadata() async {
    debugPrint(
      '⚠️ Orphaned metadata cleanup has been disabled to prevent automatic deletions',
    );
    debugPrint('   Use manual cleanup functions with admin approval instead');
    return 0;
  }

  /// Manual cleanup of orphaned metadata (for admin use only)
  Future<int> manualCleanupOrphanedMetadata({
    required bool adminConfirmed,
  }) async {
    if (!adminConfirmed) {
      throw Exception(
        'Admin confirmation required for manual cleanup operations',
      );
    }

    try {
      debugPrint('🧹 Manual cleanup of orphaned metadata initiated...');

      final firestoreDocuments = await _documentService.getAllDocuments();
      final storageFiles = await _listAllStorageFiles();
      final storageFilePaths = storageFiles.map((ref) => ref.fullPath).toSet();

      int orphanedCount = 0;
      final orphanedDocuments = <DocumentModel>[];

      // First, identify orphaned documents without deleting
      for (final document in firestoreDocuments) {
        if (!document.filePath.startsWith('http') &&
            document.filePath.isNotEmpty &&
            !storageFilePaths.contains(document.filePath)) {
          // Verify file doesn't exist
          try {
            final storageRef = _firebaseService.storage.ref().child(
              document.filePath,
            );
            await storageRef.getMetadata();
            // File exists, don't mark as orphaned
          } catch (e) {
            // File doesn't exist, mark as orphaned
            orphanedDocuments.add(document);
            orphanedCount++;
            debugPrint('🔍 Found orphaned metadata: ${document.fileName}');
          }
        }
      }

      debugPrint('✅ Found $orphanedCount orphaned metadata entries');
      debugPrint('   Use additional confirmation to proceed with deletion');
      return orphanedCount;
    } catch (e) {
      debugPrint('❌ Failed to identify orphaned metadata: $e');
      return 0;
    }
  }

  /// Perform comprehensive sync (create missing metadata only - no automatic cleanup)
  Future<Map<String, int>> performComprehensiveSync() async {
    try {
      debugPrint('🔄 Starting comprehensive Firebase Storage sync...');

      // First, sync Storage files to Firestore
      final syncedDocuments = await syncStorageWithFirestore();

      // DISABLED: Automatic cleanup to prevent unwanted deletions
      // final cleanedCount = await cleanupOrphanedMetadata();
      debugPrint(
        '⚠️ Automatic cleanup disabled - use manual cleanup if needed',
      );

      // Refresh metadata for all documents
      await refreshAllFileMetadata();

      final result = {
        'totalDocuments': syncedDocuments.length,
        'cleanedMetadata': 0, // No automatic cleanup performed
      };

      debugPrint('🎉 Comprehensive sync completed (no cleanup): $result');
      return result;
    } catch (e) {
      debugPrint('❌ Comprehensive sync failed: $e');
      rethrow;
    }
  }
}
