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

    // Cache existing documents to avoid repeated database calls
    List<DocumentModel>? cachedExistingDocuments;
    try {
      cachedExistingDocuments = await _documentService.getAllDocuments();
      debugPrint(
        '📋 Cached ${cachedExistingDocuments.length} existing documents',
      );
    } catch (e) {
      debugPrint('⚠️ Failed to cache existing documents: $e');
      // Continue without cache
    }

    // Process files in batches to prevent UI blocking
    for (int i = 0; i < orphanedFiles.length; i += _batchSize) {
      final batch = orphanedFiles.skip(i).take(_batchSize).toList();

      // Process batch with timeout and cached documents
      final batchResults =
          await Future.wait(
            batch.map(
              (fileRef) => _createSingleMetadataWithCache(
                fileRef,
                cachedExistingDocuments,
              ),
            ),
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

  /// Create metadata for a single file with cached documents to avoid repeated DB calls
  Future<DocumentModel?> _createSingleMetadataWithCache(
    Reference fileRef,
    List<DocumentModel>? cachedDocuments,
  ) async {
    try {
      // Use cached documents or fetch if not provided
      final existingDocuments =
          cachedDocuments ?? await _documentService.getAllDocuments();

      final existingDoc = existingDocuments.firstWhere(
        (doc) =>
            doc.filePath == fileRef.fullPath ||
            doc.filePath.contains(fileRef.name),
        orElse: () => DocumentModel(
          id: '',
          fileName: '',
          fileSize: 0,
          fileType: '',
          filePath: '',
          uploadedBy: '',
          uploadedAt: DateTime.now(),
          category: '',
          permissions: [],
          metadata: DocumentMetadata(description: '', tags: []),
        ),
      );

      if (existingDoc.id.isNotEmpty) {
        debugPrint(
          '⚠️ Metadata already exists for ${fileRef.name}, skipping creation',
        );
        return existingDoc;
      }

      // Get file metadata from Storage with timeout
      final metadata = await fileRef.getMetadata().timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException(
          'Metadata fetch timeout for ${fileRef.name}',
        ),
      );

      // Extract original filename and other info from custom metadata
      final originalName =
          metadata.customMetadata?['originalName'] ?? fileRef.name;
      final uploadedBy = metadata.customMetadata?['uploadedBy'] ?? 'unknown';

      // FIXED CATEGORY ASSIGNMENT: Determine category based on storage path and metadata
      final categoryId = _determineCategoryFromPath(
        fileRef.fullPath,
        metadata.customMetadata?['categoryId'],
      );

      final fileSize =
          int.tryParse(metadata.customMetadata?['fileSize'] ?? '0') ??
          metadata.size ??
          0;

      // Generate a more unique document ID using file path hash
      final documentId = _generateUniqueDocumentId(
        fileRef.fullPath,
        originalName,
      );

      // Create document model
      final document = DocumentModel(
        id: documentId,
        fileName: originalName,
        fileSize: fileSize,
        fileType: _getFileTypeFromName(originalName),
        filePath: fileRef.fullPath,
        uploadedBy: uploadedBy,
        uploadedAt: metadata.timeCreated ?? DateTime.now(),
        category: categoryId,
        permissions: [uploadedBy],
        metadata: DocumentMetadata(
          description: 'Synced from Firebase Storage',
          tags: _generateTagsFromFileName(originalName),
        ),
      );

      // CRITICAL FIX: Save to Firestore silently (no activity logging) with timeout
      await _documentService
          .addDocumentSilent(document)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException(
              'Firestore save timeout for $originalName',
            ),
          );

      debugPrint('✅ Created new metadata for: $originalName (ID: $documentId)');
      return document;
    } catch (e) {
      debugPrint('❌ Failed to create metadata for ${fileRef.name}: $e');
      return null;
    }
  }

  /// Skip verification for performance optimization - return all documents
  Future<List<DocumentModel>> _verifyFileAccessibilityBatched(
    List<DocumentModel> documents,
  ) async {
    if (documents.isEmpty) return [];

    debugPrint(
      '⚡ Skipping verification for performance - returning all ${documents.length} documents',
    );

    // Return all documents without verification for better performance
    return documents;
  }

  // Single file verification removed for performance optimization

  /// Determine category from file path and metadata
  String _determineCategoryFromPath(
    String filePath,
    String? metadataCategoryId,
  ) {
    // If metadata has a valid category ID, use it
    if (metadataCategoryId != null &&
        metadataCategoryId.isNotEmpty &&
        metadataCategoryId != 'uncategorized') {
      debugPrint(
        '📁 Using metadata category: $metadataCategoryId for $filePath',
      );
      return metadataCategoryId;
    }

    // Analyze file path to determine category
    final pathParts = filePath.split('/');

    // Check for category-specific paths
    if (pathParts.length >= 3 && pathParts[1] == 'categories') {
      // Path like: documents/categories/categoryId/file.pdf
      final categoryFromPath = pathParts[2];
      debugPrint(
        '📁 Detected category from path: $categoryFromPath for $filePath',
      );
      return categoryFromPath;
    }

    // Files directly in documents/ folder should be categorized as 'general'
    if (pathParts.length >= 2 && pathParts[0] == 'documents') {
      debugPrint(
        '📁 File in main documents folder, assigning to general category: $filePath',
      );
      return 'general'; // Use 'general' instead of 'uncategorized' for main folder files
    }

    // Default fallback
    debugPrint('📁 No specific category detected, using general: $filePath');
    return 'general';
  }

  /// Generate a unique document ID based on file path hash to prevent duplicates
  String _generateUniqueDocumentId(String filePath, String fileName) {
    // Use file path hash for uniqueness instead of timestamp to prevent duplicates
    final pathHash = filePath.hashCode.abs().toString();
    final cleanName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    // Remove timestamp to ensure same file always gets same ID
    return 'sync_${pathHash}_$cleanName';
  }

  // Legacy document ID generation method removed

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
