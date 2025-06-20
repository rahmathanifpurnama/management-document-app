import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';
import '../../models/document_model.dart';
import 'unified_id_system.dart';
import 'database_version_tracker.dart';

/// ID Reconciliation Service
///
/// Periodically syncs and reconciles document IDs between Firebase Storage
/// file metadata, Firestore document-metadata collection, and local cache.
class IdReconciliationService {
  static final IdReconciliationService _instance =
      IdReconciliationService._internal();
  static IdReconciliationService get instance => _instance;
  IdReconciliationService._internal();

  final FirebaseService _firebaseService = FirebaseService.instance;
  final UnifiedIdSystem _unifiedIdSystem = UnifiedIdSystem.instance;
  final DatabaseVersionTracker _versionTracker =
      DatabaseVersionTracker.instance;

  bool _isReconciling = false;

  /// Perform full reconciliation between Storage, Firestore, and local cache
  Future<ReconciliationResult> performFullReconciliation() async {
    if (_isReconciling) {
      debugPrint(
        '⚠️ IdReconciliationService: Reconciliation already in progress',
      );
      return ReconciliationResult()
        ..success = false
        ..message = 'Reconciliation already in progress';
    }

    _isReconciling = true;
    final result = ReconciliationResult();

    try {
      debugPrint('🔄 IdReconciliationService: Starting full reconciliation...');
      final startTime = DateTime.now();

      // Step 1: Get all files from Firebase Storage
      final storageFiles = await _getAllStorageFiles();
      result.storageFileCount = storageFiles.length;
      debugPrint('📁 Found ${storageFiles.length} files in Firebase Storage');

      // Step 2: Get all documents from Firestore
      final firestoreDocuments = await _getAllFirestoreDocuments();
      result.firestoreDocumentCount = firestoreDocuments.length;
      debugPrint(
        '📄 Found ${firestoreDocuments.length} documents in Firestore',
      );

      // Step 3: Reconcile Storage files with Firestore documents
      final storageReconciliation = await _reconcileStorageWithFirestore(
        storageFiles,
        firestoreDocuments,
      );
      result.storageReconciliationResults = storageReconciliation;

      // Step 4: Identify orphaned Firestore documents (no corresponding Storage file)
      final orphanedDocuments = await _findOrphanedFirestoreDocuments(
        storageFiles,
        firestoreDocuments,
      );
      result.orphanedDocuments = orphanedDocuments;

      // Step 5: Create missing Firestore documents for Storage files
      final missingDocuments = await _createMissingFirestoreDocuments(
        storageReconciliation.unmatchedStorageFiles,
      );
      result.createdDocuments = missingDocuments;

      // Step 6: Update database version to reflect reconciliation
      await _versionTracker.updateDatabaseVersion(
        reason: 'ID reconciliation completed',
      );

      result.success = true;
      result.duration = DateTime.now().difference(startTime);
      result.message = 'Reconciliation completed successfully';

      debugPrint(
        '✅ IdReconciliationService: Reconciliation completed in ${result.duration!.inSeconds}s',
      );
      debugPrint(
        '📊 Results: ${result.createdDocuments.length} created, ${result.orphanedDocuments.length} orphaned',
      );

      return result;
    } catch (e) {
      debugPrint('❌ IdReconciliationService: Reconciliation failed: $e');
      result.success = false;
      result.message = 'Reconciliation failed: ${e.toString()}';
      return result;
    } finally {
      _isReconciling = false;
    }
  }

  /// Quick reconciliation for specific documents
  Future<List<DocumentModel>> reconcileSpecificDocuments(
    List<DocumentModel> documents,
  ) async {
    try {
      debugPrint(
        '🔄 IdReconciliationService: Reconciling ${documents.length} specific documents...',
      );

      final reconciledDocuments = <DocumentModel>[];

      for (final document in documents) {
        // Try to normalize the document ID using the unified system
        final normalizedDocument = await _unifiedIdSystem.normalizeDocumentId(
          document,
        );

        if (normalizedDocument != null) {
          reconciledDocuments.add(normalizedDocument);
        } else {
          // If normalization fails, try to find or create the document
          final reconciledDocument = await _reconcileSingleDocument(document);
          if (reconciledDocument != null) {
            reconciledDocuments.add(reconciledDocument);
          }
        }
      }

      debugPrint(
        '✅ IdReconciliationService: Reconciled ${reconciledDocuments.length}/${documents.length} documents',
      );
      return reconciledDocuments;
    } catch (e) {
      debugPrint(
        '❌ IdReconciliationService: Error reconciling specific documents: $e',
      );
      return [];
    }
  }

  /// Get all files from Firebase Storage
  Future<List<StorageFileInfo>> _getAllStorageFiles() async {
    final files = <StorageFileInfo>[];

    try {
      final storageRef = _firebaseService.storage.ref().child('documents');
      await _listFilesRecursively(storageRef, files);
      return files;
    } catch (e) {
      debugPrint('❌ IdReconciliationService: Error getting storage files: $e');
      return [];
    }
  }

  /// Recursively list all files in storage
  Future<void> _listFilesRecursively(
    Reference ref,
    List<StorageFileInfo> files,
  ) async {
    try {
      final listResult = await ref.listAll();

      // Add files from current directory
      for (final item in listResult.items) {
        try {
          final metadata = await item.getMetadata();
          files.add(
            StorageFileInfo(
              reference: item,
              name: item.name,
              fullPath: item.fullPath,
              size: metadata.size ?? 0,
              timeCreated: metadata.timeCreated ?? DateTime.now(),
              contentType: metadata.contentType,
            ),
          );
        } catch (e) {
          debugPrint(
            '⚠️ IdReconciliationService: Error getting metadata for ${item.fullPath}: $e',
          );
        }
      }

      // Recursively process subdirectories
      for (final prefix in listResult.prefixes) {
        await _listFilesRecursively(prefix, files);
      }
    } catch (e) {
      debugPrint(
        '❌ IdReconciliationService: Error listing files in ${ref.fullPath}: $e',
      );
    }
  }

  /// Get all documents from Firestore
  Future<List<DocumentModel>> _getAllFirestoreDocuments() async {
    try {
      final querySnapshot = await _firebaseService.documentsCollection
          .where('isActive', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => DocumentModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint(
        '❌ IdReconciliationService: Error getting Firestore documents: $e',
      );
      return [];
    }
  }

  /// Reconcile Storage files with Firestore documents
  Future<StorageReconciliationResult> _reconcileStorageWithFirestore(
    List<StorageFileInfo> storageFiles,
    List<DocumentModel> firestoreDocuments,
  ) async {
    final result = StorageReconciliationResult();

    // Create lookup map for Firestore documents by file path
    final firestoreByPath = <String, DocumentModel>{};
    for (final doc in firestoreDocuments) {
      if (doc.filePath.isNotEmpty) {
        firestoreByPath[doc.filePath] = doc;
      }
    }

    // Match storage files with Firestore documents
    for (final storageFile in storageFiles) {
      final matchingDocument = firestoreByPath[storageFile.fullPath];

      if (matchingDocument != null) {
        result.matchedFiles.add(
          StorageFirestoreMatch(
            storageFile: storageFile,
            firestoreDocument: matchingDocument,
          ),
        );
      } else {
        result.unmatchedStorageFiles.add(storageFile);
      }
    }

    debugPrint(
      '🔗 IdReconciliationService: Matched ${result.matchedFiles.length}/${storageFiles.length} storage files',
    );
    return result;
  }

  /// Find orphaned Firestore documents (no corresponding Storage file)
  Future<List<DocumentModel>> _findOrphanedFirestoreDocuments(
    List<StorageFileInfo> storageFiles,
    List<DocumentModel> firestoreDocuments,
  ) async {
    final storagePathSet = storageFiles.map((f) => f.fullPath).toSet();

    final orphanedDocuments = firestoreDocuments
        .where(
          (doc) =>
              doc.filePath.isNotEmpty && !storagePathSet.contains(doc.filePath),
        )
        .toList();

    debugPrint(
      '🗑️ IdReconciliationService: Found ${orphanedDocuments.length} orphaned Firestore documents',
    );
    return orphanedDocuments;
  }

  /// Create missing Firestore documents for unmatched Storage files
  Future<List<DocumentModel>> _createMissingFirestoreDocuments(
    List<StorageFileInfo> unmatchedFiles,
  ) async {
    final createdDocuments = <DocumentModel>[];

    debugPrint(
      '📝 IdReconciliationService: Creating ${unmatchedFiles.length} missing Firestore documents...',
    );

    for (final storageFile in unmatchedFiles) {
      try {
        // Extract metadata from storage file
        final fileName = storageFile.name;
        final fileType = _getFileTypeFromName(fileName);
        final category = _extractCategoryFromPath(storageFile.fullPath);

        // Create document using unified ID system
        final documentId = await _unifiedIdSystem.createDocumentWithUnifiedId(
          fileName: fileName,
          filePath: storageFile.fullPath,
          uploadedBy: 'system', // Default for reconciliation
          category: category,
          fileSize: storageFile.size,
          fileType: fileType,
          additionalMetadata: {
            'createdBy': 'reconciliation_service',
            'reconciliationTimestamp': DateTime.now().toIso8601String(),
          },
        );

        // Create DocumentModel for the created document
        final documentModel = DocumentModel(
          id: documentId,
          fileName: fileName,
          fileSize: storageFile.size,
          fileType: fileType,
          filePath: storageFile.fullPath,
          uploadedBy: 'system',
          uploadedAt: storageFile.timeCreated,
          category: category,
          permissions: ['system'],
          metadata: DocumentMetadata(
            description: 'Created by reconciliation service',
            tags: ['reconciled'],
            version: '1.0',
            contentType: storageFile.contentType ?? 'application/octet-stream',
          ),
        );

        createdDocuments.add(documentModel);
        debugPrint('✅ Created Firestore document for: $fileName');
      } catch (e) {
        debugPrint(
          '❌ Failed to create Firestore document for ${storageFile.name}: $e',
        );
      }
    }

    debugPrint(
      '✅ IdReconciliationService: Created ${createdDocuments.length} Firestore documents',
    );
    return createdDocuments;
  }

  /// Reconcile a single document
  Future<DocumentModel?> _reconcileSingleDocument(
    DocumentModel document,
  ) async {
    try {
      // Check if the document exists in Firestore with current ID
      if (await _unifiedIdSystem.validateDocumentId(document.id)) {
        return document; // Already valid
      }

      // Try to find the document by file path
      final correctId = await _unifiedIdSystem.getFirestoreIdFromStoragePath(
        document.filePath,
      );
      if (correctId != null) {
        // Return document with correct ID
        return DocumentModel(
          id: correctId,
          fileName: document.fileName,
          fileSize: document.fileSize,
          fileType: document.fileType,
          filePath: document.filePath,
          uploadedBy: document.uploadedBy,
          uploadedAt: document.uploadedAt,
          category: document.category,
          permissions: document.permissions,
          metadata: document.metadata,
        );
      }

      return null; // Could not reconcile
    } catch (e) {
      debugPrint(
        '❌ IdReconciliationService: Error reconciling single document: $e',
      );
      return null;
    }
  }

  /// Extract file type from filename
  String _getFileTypeFromName(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'PDF';
      case 'doc':
      case 'docx':
        return 'DOC';
      case 'xls':
      case 'xlsx':
        return 'Excel';
      case 'ppt':
      case 'pptx':
        return 'PPT';
      case 'jpg':
      case 'jpeg':
      case 'png':
        return 'Image';
      case 'txt':
        return 'Text';
      default:
        return 'Other';
    }
  }

  /// Extract category from storage path
  String _extractCategoryFromPath(String path) {
    final parts = path.split('/');
    if (parts.length > 2) {
      return parts[1]; // Assume format: documents/category/file
    }
    return 'uncategorized';
  }
}

/// Information about a file in Firebase Storage
class StorageFileInfo {
  final Reference reference;
  final String name;
  final String fullPath;
  final int size;
  final DateTime timeCreated;
  final String? contentType;

  StorageFileInfo({
    required this.reference,
    required this.name,
    required this.fullPath,
    required this.size,
    required this.timeCreated,
    this.contentType,
  });

  @override
  String toString() {
    return 'StorageFileInfo(name: $name, path: $fullPath, size: $size)';
  }
}

/// Result of reconciliation operation
class ReconciliationResult {
  bool success = false;
  String message = '';
  Duration? duration;

  int storageFileCount = 0;
  int firestoreDocumentCount = 0;

  StorageReconciliationResult? storageReconciliationResults;
  List<DocumentModel> orphanedDocuments = [];
  List<DocumentModel> createdDocuments = [];

  @override
  String toString() {
    return 'ReconciliationResult(success: $success, message: $message, '
        'storage: $storageFileCount, firestore: $firestoreDocumentCount, '
        'created: ${createdDocuments.length}, orphaned: ${orphanedDocuments.length})';
  }
}

/// Result of storage-to-Firestore reconciliation
class StorageReconciliationResult {
  List<StorageFirestoreMatch> matchedFiles = [];
  List<StorageFileInfo> unmatchedStorageFiles = [];

  int get totalMatched => matchedFiles.length;
  int get totalUnmatched => unmatchedStorageFiles.length;
}

/// Match between a Storage file and Firestore document
class StorageFirestoreMatch {
  final StorageFileInfo storageFile;
  final DocumentModel firestoreDocument;

  StorageFirestoreMatch({
    required this.storageFile,
    required this.firestoreDocument,
  });

  @override
  String toString() {
    return 'StorageFirestoreMatch(file: ${storageFile.name}, doc: ${firestoreDocument.fileName})';
  }
}
