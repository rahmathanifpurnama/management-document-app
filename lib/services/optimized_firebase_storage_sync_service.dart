import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../core/services/firebase_service.dart';
import '../core/services/document_service.dart';
import '../core/services/optimized_network_service.dart';
import '../core/config/anr_config.dart';
import '../core/utils/anr_prevention.dart';
import '../models/document_model.dart';

/// Optimized Firebase Storage Sync Service to prevent ANR issues
class OptimizedFirebaseStorageSyncService {
  static OptimizedFirebaseStorageSyncService? _instance;
  static OptimizedFirebaseStorageSyncService get instance =>
      _instance ??= OptimizedFirebaseStorageSyncService._();

  OptimizedFirebaseStorageSyncService._();

  final FirebaseService _firebaseService = FirebaseService.instance;
  final DocumentService _documentService = DocumentService.instance;

  // Use optimized batch sizes from ANRConfig to prevent UI blocking
  static int get _batchSize => ANRConfig.defaultBatchSize;
  static Duration get _batchDelay => ANRConfig.batchDelay;

  /// HIGH PRIORITY: Optimized sync with batching and parallel operations to prevent ANR
  Future<List<DocumentModel>> syncStorageWithFirestoreOptimized() async {
    try {
      debugPrint('🔄 Starting optimized Firebase Storage sync...');

      // Use optimized network service for concurrent operations
      final networkService = OptimizedNetworkService.instance;

      // Run initial operations with controlled concurrency
      final results = await Future.wait([
        networkService.executeStorageOperation(
          () => _listAllStorageFiles(),
          operationId:
              'list_storage_files_${DateTime.now().millisecondsSinceEpoch}',
          operationName: 'List Storage Files',
          priority: 3,
        ),
        networkService.executeFirestoreOperation(
          () => _documentService.getAllDocuments(),
          operationId:
              'get_all_documents_${DateTime.now().millisecondsSinceEpoch}',
          operationName: 'Get All Documents',
          priority: 3,
        ),
      ]);

      final storageFiles = (results[0] as List<Reference>?) ?? [];
      final firestoreDocuments = (results[1] as List<DocumentModel>?) ?? [];

      debugPrint('📁 Found ${storageFiles.length} files in Firebase Storage');
      debugPrint(
        '📄 Found ${firestoreDocuments.length} documents in Firestore',
      );

      // Find orphaned files efficiently with smaller batches
      final orphanedFiles = await _findOrphanedFilesOptimized(
        storageFiles,
        firestoreDocuments,
      );
      debugPrint('🔍 Found ${orphanedFiles.length} orphaned files');

      // Create metadata for orphaned files in batches
      final newDocuments = await _createMetadataForOrphanedFilesBatched(
        orphanedFiles,
      );
      debugPrint(
        '✅ Created metadata for ${newDocuments.length} orphaned files',
      );

      // Combine existing and new documents
      final allDocuments = [...firestoreDocuments, ...newDocuments];

      // Verify file accessibility in batches
      final accessibleDocuments = await _verifyFileAccessibilityBatched(
        allDocuments,
      );
      debugPrint('✅ Verified ${accessibleDocuments.length} accessible files');

      debugPrint('🎉 Optimized Firebase Storage sync completed successfully');
      return accessibleDocuments;
    } catch (e) {
      debugPrint('❌ Optimized Firebase Storage sync failed: $e');
      rethrow;
    }
  }

  /// List all files in Firebase Storage with timeout and pagination to prevent ANR
  Future<List<Reference>> _listAllStorageFiles() async {
    try {
      final documentsRef = _firebaseService.storage.ref().child('documents');
      final allFiles = <Reference>[];

      // Use pagination to prevent ANR on large storage buckets
      String? pageToken;
      int pageCount = 0;
      const maxPages = 10; // Limit to prevent infinite loops

      do {
        // Add timeout and pagination to prevent hanging
        final listResult = await ANRPrevention.executeWithTimeout(
          documentsRef.list(
            ListOptions(
              maxResults: 100, // Smaller batch size to prevent ANR
              pageToken: pageToken,
            ),
          ),
          timeout: const Duration(seconds: 15), // Reduced timeout
          operationName: 'Storage File Listing (Page ${pageCount + 1})',
        );

        if (listResult == null) {
          debugPrint('⚠️ Storage listing timed out on page ${pageCount + 1}');
          break;
        }

        // Filter out system files like .keep
        final validFiles = listResult.items
            .where((ref) => !ref.name.startsWith('.') && ref.name.isNotEmpty)
            .toList();

        allFiles.addAll(validFiles);
        pageToken = listResult.nextPageToken;
        pageCount++;

        // Small delay between pages to prevent UI blocking
        if (pageCount < maxPages) {
          await Future.delayed(const Duration(milliseconds: 100));
        }

        debugPrint('📄 Listed page $pageCount: ${validFiles.length} files');
      } while (pageToken != null && pageCount < maxPages);

      debugPrint('📁 Total files found: ${allFiles.length}');
      return allFiles;
    } catch (e) {
      debugPrint('❌ Failed to list storage files: $e');
      return [];
    }
  }

  /// Optimized orphaned file detection using Set for O(1) lookups
  Future<List<Reference>> _findOrphanedFilesOptimized(
    List<Reference> storageFiles,
    List<DocumentModel> firestoreDocuments,
  ) async {
    // Create a Set of file paths for O(1) lookup instead of O(n) for each file
    final firestorePaths = <String>{};
    final firestoreNames = <String>{};

    for (final doc in firestoreDocuments) {
      firestorePaths.add(doc.filePath);
      if (doc.filePath.isNotEmpty) {
        // Extract filename from path for comparison
        final fileName = doc.filePath.split('/').last;
        firestoreNames.add(fileName);
      }
    }

    final orphanedFiles = <Reference>[];

    for (final storageFile in storageFiles) {
      final storagePath = storageFile.fullPath;
      final storageFileName = storageFile.name;

      // Check if this storage file has corresponding Firestore metadata
      final hasMetadata =
          firestorePaths.contains(storagePath) ||
          firestoreNames.contains(storageFileName);

      if (!hasMetadata) {
        orphanedFiles.add(storageFile);
      }
    }

    return orphanedFiles;
  }

  /// Create metadata for orphaned files in batches to prevent UI blocking
  Future<List<DocumentModel>> _createMetadataForOrphanedFilesBatched(
    List<Reference> orphanedFiles,
  ) async {
    if (orphanedFiles.isEmpty) return [];

    debugPrint(
      '🔄 Creating metadata for ${orphanedFiles.length} files in batches...',
    );

    final allNewDocuments = <DocumentModel>[];

    // Process files in batches to prevent UI blocking
    for (int i = 0; i < orphanedFiles.length; i += _batchSize) {
      final batch = orphanedFiles.skip(i).take(_batchSize).toList();

      // Process batch with timeout
      final batchResults =
          await Future.wait(
            batch.map((fileRef) => _createSingleMetadata(fileRef)),
            eagerError: false,
          ).timeout(
            const Duration(minutes: 2),
            onTimeout: () {
              debugPrint('⚠️ Batch metadata creation timeout');
              return <DocumentModel?>[];
            },
          );

      // Add successful results
      for (final doc in batchResults) {
        if (doc != null) {
          allNewDocuments.add(doc);
        }
      }

      // Small delay between batches to prevent overwhelming the system
      if (i + _batchSize < orphanedFiles.length) {
        await Future.delayed(_batchDelay);
      }

      debugPrint(
        '📝 Processed batch ${(i / _batchSize).floor() + 1}/${(orphanedFiles.length / _batchSize).ceil()}',
      );
    }

    return allNewDocuments;
  }

  /// Create metadata for a single file with error handling
  Future<DocumentModel?> _createSingleMetadata(Reference fileRef) async {
    try {
      // Get file metadata from Storage with timeout
      final metadata = await fileRef.getMetadata().timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Metadata fetch timeout'),
      );

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

      // Save to Firestore with timeout
      await _documentService
          .addDocument(document)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Firestore save timeout'),
          );

      return document;
    } catch (e) {
      debugPrint('❌ Failed to create metadata for ${fileRef.name}: $e');
      return null;
    }
  }

  /// Verify file accessibility in batches to prevent ANR
  Future<List<DocumentModel>> _verifyFileAccessibilityBatched(
    List<DocumentModel> documents,
  ) async {
    if (documents.isEmpty) return [];

    debugPrint(
      '🔍 Verifying accessibility for ${documents.length} files in batches...',
    );

    final accessibleDocuments = <DocumentModel>[];

    // Process documents in batches
    for (int i = 0; i < documents.length; i += _batchSize) {
      final batch = documents.skip(i).take(_batchSize).toList();

      // Process batch with timeout
      final batchResults =
          await Future.wait(
            batch.map((doc) => _verifySingleFileAccessibility(doc)),
            eagerError: false,
          ).timeout(
            const Duration(minutes: 1),
            onTimeout: () {
              debugPrint('⚠️ Batch verification timeout');
              return <DocumentModel?>[];
            },
          );

      // Add accessible documents
      for (final doc in batchResults) {
        if (doc != null) {
          accessibleDocuments.add(doc);
        }
      }

      // Small delay between batches
      if (i + _batchSize < documents.length) {
        await Future.delayed(_batchDelay);
      }

      debugPrint(
        '✅ Verified batch ${(i / _batchSize).floor() + 1}/${(documents.length / _batchSize).ceil()}',
      );
    }

    return accessibleDocuments;
  }

  /// Verify accessibility of a single file
  Future<DocumentModel?> _verifySingleFileAccessibility(
    DocumentModel document,
  ) async {
    try {
      if (document.filePath.startsWith('http')) {
        // Already has download URL, assume accessible
        return document;
      } else {
        // Verify file exists in Storage with timeout
        final storageRef = _firebaseService.storage.ref().child(
          document.filePath,
        );
        await storageRef.getMetadata().timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw TimeoutException('File verification timeout'),
        );
        return document;
      }
    } catch (e) {
      debugPrint('⚠️ File not accessible: ${document.fileName}');
      return null;
    }
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
}
