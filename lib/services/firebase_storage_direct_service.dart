import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/document_model.dart';
import '../core/services/firebase_service.dart';
import '../core/utils/anr_prevention.dart';
import '../core/config/anr_config.dart';

/// Service for direct Firebase Storage access without Firestore dependency
/// This service fetches files directly from Firebase Storage and creates DocumentModel objects
class FirebaseStorageDirectService {
  static FirebaseStorageDirectService? _instance;
  static FirebaseStorageDirectService get instance =>
      _instance ??= FirebaseStorageDirectService._();

  FirebaseStorageDirectService._();

  final FirebaseService _firebaseService = FirebaseService.instance;

  /// Get all files directly from Firebase Storage
  Future<List<DocumentModel>> getAllFilesFromStorage() async {
    try {
      debugPrint('🔄 Fetching files directly from Firebase Storage...');
      
      final documentsRef = _firebaseService.storage.ref().child('documents');
      final listResult = await documentsRef.listAll();
      
      final documents = <DocumentModel>[];
      
      // Process files in batches to prevent ANR
      const batchSize = 10;
      for (int i = 0; i < listResult.items.length; i += batchSize) {
        final batch = listResult.items.skip(i).take(batchSize);
        
        final batchDocuments = await Future.wait(
          batch.map((ref) => _createDocumentFromStorageRef(ref)),
        );
        
        // Filter out null results
        documents.addAll(batchDocuments.where((doc) => doc != null).cast<DocumentModel>());
        
        // Add small delay between batches to prevent ANR
        if (i + batchSize < listResult.items.length) {
          await Future.delayed(const Duration(milliseconds: 50));
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
  Future<List<DocumentModel>> getRecentFilesFromStorage({int limit = 50}) async {
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
      final contentType = metadata.contentType ?? 'application/octet-stream';
      
      // Generate document ID from filename (remove timestamp prefix if exists)
      final documentId = _generateDocumentId(fileName);
      
      // Determine file type from extension
      final fileType = _getFileTypeFromName(fileName);
      
      // Get download URL
      final downloadUrl = await ANRPrevention.executeWithTimeout(
        ref.getDownloadURL(),
        timeout: ANRConfig.storageMetadataTimeout,
        operationName: 'Storage Download URL - ${ref.name}',
      );
      
      if (downloadUrl == null) {
        debugPrint('⚠️ Failed to get download URL for ${ref.name}');
        return null;
      }
      
      // Create DocumentModel
      return DocumentModel(
        id: documentId,
        fileName: fileName,
        fileSize: fileSize,
        fileType: fileType,
        filePath: ref.fullPath,
        uploadedBy: 'system', // Default value since we don't have user info from Storage
        uploadedAt: uploadedAt,
        category: _extractCategoryFromPath(ref.fullPath),
        permissions: ['read'], // Default permissions
        metadata: DocumentMetadata(
          description: '',
          tags: [],
          version: '1.0',
          downloadUrl: downloadUrl,
        ),
      );
      
    } catch (e) {
      debugPrint('❌ Failed to create document from storage ref ${ref.name}: $e');
      return null;
    }
  }

  /// Generate document ID from filename
  String _generateDocumentId(String fileName) {
    // Remove file extension and timestamp prefix if exists
    final nameWithoutExt = fileName.split('.').first;
    
    // If filename starts with timestamp, remove it
    if (RegExp(r'^\d+_').hasMatch(nameWithoutExt)) {
      return nameWithoutExt.split('_').skip(1).join('_');
    }
    
    return nameWithoutExt;
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

  /// Extract category from file path
  String _extractCategoryFromPath(String filePath) {
    // Default category extraction logic
    // You can customize this based on your folder structure
    if (filePath.contains('/categories/')) {
      final parts = filePath.split('/categories/');
      if (parts.length > 1) {
        return parts[1].split('/').first;
      }
    }
    
    return 'uncategorized';
  }

  /// Get storage statistics
  Future<Map<String, dynamic>> getStorageStatistics() async {
    try {
      final allFiles = await getAllFilesFromStorage();
      
      final totalSize = allFiles.fold<int>(0, (sum, doc) => sum + doc.fileSize);
      final recentFiles = allFiles.where(
        (doc) => DateTime.now().difference(doc.uploadedAt).inDays <= 7,
      ).length;
      
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
