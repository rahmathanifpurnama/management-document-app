import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/document_model.dart';
import '../core/services/firebase_service.dart';
import '../core/services/unified_id_system.dart';
import '../core/utils/anr_prevention.dart';
import '../core/config/anr_config.dart';
import '../core/utils/circuit_breaker.dart';

/// Service for direct Firebase Storage access without Firestore dependency
/// This service fetches files directly from Firebase Storage and creates DocumentModel objects
class FirebaseStorageDirectService {
  static FirebaseStorageDirectService? _instance;
  static FirebaseStorageDirectService get instance =>
      _instance ??= FirebaseStorageDirectService._();

  FirebaseStorageDirectService._();

  final FirebaseService _firebaseService = FirebaseService.instance;
  final UnifiedIdSystem _unifiedIdSystem = UnifiedIdSystem.instance;

  /// ARCHITECTURAL FIX: Optimized file fetching with proper empty state handling
  Future<List<DocumentModel>> getAllFilesFromStorage() async {
    try {
      // REDUCED LOGGING: Only log when actually fetching, not on every call

      final documentsRef = _firebaseService.storage.ref().child('documents');

      // Use timeout to prevent hanging
      final listResult = await ANRPrevention.executeWithTimeout(
        documentsRef.listAll(),
        timeout: ANRConfig.storageListTimeout,
        operationName: 'Storage List All Files',
      );

      if (listResult == null) {
        debugPrint('⚠️ Storage listing timed out');
        return [];
      }

      // EMPTY STATE FIX: Properly handle empty storage
      if (listResult.items.isEmpty) {
        // REDUCED LOGGING: Only log empty state once
        debugPrint('📁 Firebase Storage is empty');
        // Set circuit breaker to prevent retries for empty storage
        CircuitBreaker.execute('storage_empty_state', () async {
          return true; // Mark as successful empty state
        }, operationName: 'Storage Empty State Confirmation');
        return [];
      }

      final documents = <DocumentModel>[];

      // OPTIMIZED: Process files in smaller batches with better error handling
      const batchSize = 5; // Reduced batch size for better performance
      for (int i = 0; i < listResult.items.length; i += batchSize) {
        final batch = listResult.items.skip(i).take(batchSize);

        try {
          final batchDocuments = await Future.wait(
            batch.map((ref) => _createDocumentFromStorageRef(ref)),
            eagerError: false, // Continue processing even if some files fail
          );

          // Filter out null results and add to documents
          documents.addAll(
            batchDocuments.where((doc) => doc != null).cast<DocumentModel>(),
          );

          // Reduced delay for better responsiveness
          if (i + batchSize < listResult.items.length) {
            await Future.delayed(const Duration(milliseconds: 25));
          }
        } catch (e) {
          debugPrint('⚠️ Batch processing error (continuing): $e');
          // Continue with next batch even if current batch fails
        }
      }

      // Sort by upload time (newest first)
      documents.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));

      debugPrint('✅ Fetched ${documents.length} files from Firebase Storage');
      return documents;
    } catch (e) {
      debugPrint('❌ Failed to fetch files from Firebase Storage: $e');
      return [];
    }
  }

  /// Get recent files directly from Firebase Storage
  Future<List<DocumentModel>> getRecentFilesFromStorage({
    int limit = 50,
  }) async {
    try {
      final allFiles = await getAllFilesFromStorage();

      // Return recent files with limit
      return allFiles.take(limit).toList();
    } catch (e) {
      debugPrint('❌ Failed to get recent files from Storage: $e');
      return [];
    }
  }

  /// Create DocumentModel from Firebase Storage Reference
  Future<DocumentModel?> _createDocumentFromStorageRef(Reference ref) async {
    try {
      // Get file metadata
      final metadata = await ANRPrevention.executeWithTimeout(
        ref.getMetadata(),
        timeout: ANRConfig.storageMetadataTimeout,
        operationName: 'Storage Metadata - ${ref.name}',
      );

      if (metadata == null) {
        debugPrint('⚠️ Failed to get metadata for ${ref.name}');
        return null;
      }

      // Extract file information
      final fileName = ref.name;
      final fileSize = metadata.size ?? 0;
      final uploadedAt = metadata.timeCreated ?? DateTime.now();

      // UNIFIED ID SYSTEM: Try to resolve existing Firestore ID first
      String documentId;
      final existingId = await _unifiedIdSystem.getFirestoreIdFromStoragePath(
        ref.fullPath,
      );

      if (existingId != null) {
        // Use existing Firestore ID for consistency
        documentId = existingId;
        debugPrint(
          '🔗 Using existing Firestore ID: $documentId for ${ref.name}',
        );
      } else {
        // Generate new UUID as fallback (will be reconciled later)
        documentId = const Uuid().v4();
        debugPrint(
          '⚠️ Generated fallback UUID: $documentId for ${ref.name} (needs reconciliation)',
        );
      }

      // Determine file type from extension
      final fileType = _getFileTypeFromName(fileName);

      // Get download URL with circuit breaker protection
      final circuitKey = 'download_url_${ref.name}';
      final downloadUrl = await CircuitBreaker.execute(circuitKey, () async {
        final url = await ANRPrevention.executeWithTimeout(
          ref.getDownloadURL(),
          timeout: ANRConfig.storageMetadataTimeout,
          operationName: 'Storage Download URL - ${ref.name}',
        );

        if (url == null) {
          throw Exception('Failed to get download URL');
        }

        return url;
      }, operationName: 'Download URL - ${ref.name}');

      if (downloadUrl == null) {
        debugPrint(
          '⚠️ Failed to get download URL for ${ref.name} (circuit breaker)',
        );
        return null;
      }

      // Create DocumentModel
      return DocumentModel(
        id: documentId,
        fileName: fileName,
        fileSize: fileSize,
        fileType: fileType,
        filePath: ref.fullPath,
        uploadedBy:
            'system', // Default value since we don't have user info from Storage
        uploadedAt: uploadedAt,
        category: _extractCategoryFromPath(ref.fullPath),
        permissions: ['read'], // Default permissions
        metadata: DocumentMetadata(
          description: 'File from Firebase Storage',
          tags: ['storage-sourced'],
        ),
      );
    } catch (e) {
      debugPrint(
        '❌ Failed to create document from storage ref ${ref.name}: $e',
      );
      return null;
    }
  }

  /// Get file type from filename
  String _getFileTypeFromName(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();

    switch (extension) {
      case 'pdf':
        return 'pdf';
      case 'doc':
      case 'docx':
        return 'document';
      case 'xls':
      case 'xlsx':
        return 'spreadsheet';
      case 'csv': // Added CSV support
        return 'spreadsheet'; // Group CSV with spreadsheets
      case 'ppt':
      case 'pptx':
        return 'presentation';
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return 'image';
      case 'mp4':
      case 'avi':
      case 'mov':
        return 'video';
      case 'mp3':
      case 'wav':
        return 'audio';
      case 'txt':
        return 'text';
      default:
        return 'other';
    }
  }

  /// Extract category from file path with Firestore metadata check
  String _extractCategoryFromPath(String filePath) {
    // FIXED: Updated after uncategorized folder deletion
    final pathParts = filePath.split('/');

    // Check for category-specific paths: documents/categories/categoryId/file.pdf
    if (pathParts.length >= 3 && pathParts[1] == 'categories') {
      final categoryFromPath = pathParts[2];
      debugPrint(
        '📁 Detected category from path: $categoryFromPath for $filePath',
      );
      return categoryFromPath;
    }

    // Files directly in documents/ folder should have category checked from Firestore
    if (pathParts.length >= 2 && pathParts[0] == 'documents') {
      debugPrint(
        '📁 File in main documents folder, category will be resolved from Firestore: $filePath',
      );
      // Return empty string to indicate category needs to be resolved from Firestore
      return '';
    }

    // Default fallback
    debugPrint(
      '📁 No specific category detected, using empty category: $filePath',
    );
    return '';
  }

  /// Get storage statistics
  Future<Map<String, dynamic>> getStorageStatistics() async {
    try {
      final allFiles = await getAllFilesFromStorage();

      final totalSize = allFiles.fold<int>(0, (sum, doc) => sum + doc.fileSize);
      final recentFiles = allFiles
          .where((doc) => DateTime.now().difference(doc.uploadedAt).inDays <= 7)
          .length;

      // Group by file type
      final fileTypeStats = <String, int>{};
      for (final doc in allFiles) {
        fileTypeStats[doc.fileType] = (fileTypeStats[doc.fileType] ?? 0) + 1;
      }

      return {
        'totalFiles': allFiles.length,
        'totalSize': totalSize,
        'recentFiles': recentFiles,
        'fileTypeStats': fileTypeStats,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('❌ Failed to get storage statistics: $e');
      return {
        'totalFiles': 0,
        'totalSize': 0,
        'recentFiles': 0,
        'fileTypeStats': <String, int>{},
        'lastUpdated': DateTime.now().toIso8601String(),
      };
    }
  }
}
