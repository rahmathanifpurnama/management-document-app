import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/document_model.dart';
import '../models/user_model.dart';
import '../core/services/firebase_service.dart';
import '../core/services/auth_service.dart';
import '../config/firebase_config.dart';
import '../core/utils/anr_prevention.dart';
import '../core/config/anr_config.dart';
import '../core/utils/circuit_breaker.dart';

/// Enhanced Firebase Storage Service with improved file display and retrieval
class EnhancedFirebaseStorageService {
  static EnhancedFirebaseStorageService? _instance;
  static EnhancedFirebaseStorageService get instance =>
      _instance ??= EnhancedFirebaseStorageService._();

  EnhancedFirebaseStorageService._();

  final FirebaseService _firebaseService = FirebaseService.instance;
  final AuthService _authService = AuthService.instance;

  // Cache for download URLs to prevent repeated requests
  final Map<String, String> _urlCache = {};
  final Map<String, DateTime> _urlCacheTimestamp = {};
  static const Duration _urlCacheExpiry = Duration(hours: 1);

  /// Get current user data
  Future<UserModel?> get _currentUser async {
    return await _authService.getCurrentUserData();
  }

  /// Get all files from Firebase Storage with unlimited access
  Future<List<DocumentModel>> getAllStorageFilesUnlimited({
    String? pathPrefix,
    bool includeMetadata = true,
  }) async {
    try {
      debugPrint('🔍 Starting unlimited storage file retrieval...');

      final storageRef = pathPrefix != null
          ? _firebaseService.storage.ref().child(pathPrefix)
          : _firebaseService.storage.ref().child('documents');

      final allFiles = <DocumentModel>[];
      await _getAllFilesRecursive(storageRef, allFiles, includeMetadata);

      debugPrint('✅ Retrieved ${allFiles.length} files from Firebase Storage');
      return allFiles;
    } catch (e) {
      debugPrint('❌ Failed to get all storage files: $e');
      return [];
    }
  }

  /// Recursively get all files from storage
  Future<void> _getAllFilesRecursive(
    Reference ref,
    List<DocumentModel> allFiles,
    bool includeMetadata,
  ) async {
    try {
      final listResult = await ANRPrevention.executeWithTimeout(
        ref.listAll(),
        timeout: ANRConfig.storageListTimeout,
        operationName: 'Storage List All - ${ref.fullPath}',
      );

      if (listResult == null) {
        debugPrint('⚠️ Storage list timeout for ${ref.fullPath}');
        return;
      }

      // Process files in current directory
      for (final fileRef in listResult.items) {
        final document = await _createDocumentFromStorageRef(
          fileRef,
          includeMetadata,
        );
        if (document != null) {
          allFiles.add(document);
        }
      }

      // Process subdirectories
      for (final folderRef in listResult.prefixes) {
        await _getAllFilesRecursive(folderRef, allFiles, includeMetadata);
      }
    } catch (e) {
      debugPrint('❌ Error in recursive file listing for ${ref.fullPath}: $e');
    }
  }

  /// Create DocumentModel from Firebase Storage reference
  Future<DocumentModel?> _createDocumentFromStorageRef(
    Reference ref,
    bool includeMetadata,
  ) async {
    try {
      // Get file metadata
      final metadata = includeMetadata
          ? await ANRPrevention.executeWithTimeout(
              ref.getMetadata(),
              timeout: ANRConfig.storageMetadataTimeout,
              operationName: 'Storage Metadata - ${ref.name}',
            )
          : null;

      // Get download URL with caching
      final downloadUrl = await _getDownloadUrlWithCache(ref);
      if (downloadUrl == null) {
        debugPrint('⚠️ Failed to get download URL for ${ref.name}');
        return null;
      }

      // Extract file information
      final fileName = ref.name;
      final fileSize = metadata?.size ?? 0;
      final uploadedAt = metadata?.timeCreated ?? DateTime.now();
      final contentType = metadata?.contentType ?? 'application/octet-stream';

      // Generate document ID from filename
      final documentId = _generateDocumentId(fileName);

      // Determine file type from extension
      final fileType = _getFileTypeFromName(fileName);

      // Extract category from path
      final category = _extractCategoryFromPath(ref.fullPath);

      // Create DocumentModel
      return DocumentModel(
        id: documentId,
        fileName: fileName,
        fileSize: fileSize,
        fileType: fileType,
        filePath: ref.fullPath,
        uploadedBy: _extractUploaderFromPath(ref.fullPath),
        uploadedAt: uploadedAt,
        category: category,
        permissions: ['read'], // Default permissions
        metadata: DocumentMetadata(
          description: 'File from Firebase Storage',
          tags: ['storage-sourced'],
          version: '1.0',
          contentType: contentType,
          downloadUrl: downloadUrl,
        ),
      );
    } catch (e) {
      debugPrint(
        '❌ Failed to create document from storage ref ${ref.name}: $e',
      );
      return null;
    }
  }

  /// Get download URL with caching and circuit breaker to prevent repeated requests
  Future<String?> _getDownloadUrlWithCache(Reference ref) async {
    final cacheKey = ref.fullPath;
    final now = DateTime.now();

    // Check if we have a cached URL that's still valid
    if (_urlCache.containsKey(cacheKey) &&
        _urlCacheTimestamp.containsKey(cacheKey)) {
      final cacheTime = _urlCacheTimestamp[cacheKey]!;
      if (now.difference(cacheTime) < _urlCacheExpiry) {
        debugPrint('📋 Using cached URL for ${ref.name}');
        return _urlCache[cacheKey];
      }
    }

    // Use circuit breaker to prevent repeated failures
    final circuitKey = 'download_url_${ref.name}';

    return await CircuitBreaker.execute(circuitKey, () async {
      // Get fresh download URL with timeout
      final downloadUrl = await ANRPrevention.executeWithTimeout(
        ref.getDownloadURL(),
        timeout: ANRConfig.storageMetadataTimeout,
        operationName: 'Storage Download URL - ${ref.name}',
      );

      if (downloadUrl != null) {
        // Cache the URL
        _urlCache[cacheKey] = downloadUrl;
        _urlCacheTimestamp[cacheKey] = now;
        debugPrint('💾 Cached new URL for ${ref.name}');
        return downloadUrl;
      }

      throw Exception('Failed to get download URL');
    }, operationName: 'Download URL - ${ref.name}');
  }

  /// Refresh download URL for a specific file
  Future<String?> refreshDownloadUrl(String filePath) async {
    try {
      final ref = _firebaseService.storage.ref().child(filePath);

      // Remove from cache to force refresh
      _urlCache.remove(filePath);
      _urlCacheTimestamp.remove(filePath);

      return await _getDownloadUrlWithCache(ref);
    } catch (e) {
      debugPrint('❌ Failed to refresh download URL for $filePath: $e');
      return null;
    }
  }

  /// Clear URL cache
  void clearUrlCache() {
    _urlCache.clear();
    _urlCacheTimestamp.clear();
    debugPrint('🗑️ Storage URL cache cleared');
  }

  /// Get files by category from storage
  Future<List<DocumentModel>> getStorageFilesByCategory(String category) async {
    final allFiles = await getAllStorageFilesUnlimited();
    return allFiles.where((file) => file.category == category).toList();
  }

  /// Search files in storage
  Future<List<DocumentModel>> searchStorageFiles(String query) async {
    final allFiles = await getAllStorageFilesUnlimited();
    return allFiles
        .where(
          (file) => file.fileName.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  /// Generate document ID from filename
  String _generateDocumentId(String fileName) {
    // Remove timestamp prefix if exists and create clean ID
    final cleanName = fileName.replaceAll(RegExp(r'^\d+_'), '');
    return cleanName.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_').toLowerCase();
  }

  /// Get file type from filename
  String _getFileTypeFromName(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();

    switch (extension) {
      case 'pdf':
        return 'PDF';
      case 'doc':
      case 'docx':
        return 'Word Document';
      case 'xls':
      case 'xlsx':
        return 'Excel Spreadsheet';
      case 'ppt':
      case 'pptx':
        return 'PowerPoint Presentation';
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return 'Image';
      case 'mp4':
      case 'avi':
      case 'mov':
        return 'Video';
      case 'mp3':
      case 'wav':
        return 'Audio';
      case 'txt':
        return 'Text Document';
      case 'zip':
      case 'rar':
        return 'Archive';
      default:
        return 'Unknown';
    }
  }

  /// Extract category from file path
  String _extractCategoryFromPath(String fullPath) {
    final pathParts = fullPath.split('/');
    if (pathParts.length > 2) {
      // Try to extract category from path structure
      return pathParts[1]; // Assuming structure: documents/category/file
    }
    return 'general';
  }

  /// Extract uploader ID from file path
  String _extractUploaderFromPath(String fullPath) {
    final pathParts = fullPath.split('/');
    // Try to extract user ID from filename or path
    for (final part in pathParts) {
      if (part.contains('_') && part.length > 10) {
        final possibleUid = part.split('_').first;
        if (possibleUid.length >= 20) {
          // Firebase UID length
          return possibleUid;
        }
      }
    }
    return 'system'; // Default fallback
  }

  /// Check if current user can access unlimited storage queries
  Future<bool> get canAccessUnlimitedStorage async {
    final currentUser = await _currentUser;
    return currentUser?.isAdmin == true ||
        FirebaseConfig.shouldEnableStorageSync;
  }

  /// Get storage usage statistics
  Future<Map<String, dynamic>> getStorageStatistics() async {
    if (!(await canAccessUnlimitedStorage)) {
      return {};
    }

    try {
      final allFiles = await getAllStorageFilesUnlimited();

      final totalSize = allFiles.fold<int>(
        0,
        (sum, file) => sum + file.fileSize,
      );

      final fileTypeStats = <String, int>{};
      final categorySizeStats = <String, int>{};

      for (final file in allFiles) {
        fileTypeStats[file.fileType] = (fileTypeStats[file.fileType] ?? 0) + 1;
        categorySizeStats[file.category] =
            (categorySizeStats[file.category] ?? 0) + file.fileSize;
      }

      return {
        'totalFiles': allFiles.length,
        'totalSize': totalSize,
        'fileTypes': fileTypeStats,
        'categorySize': categorySizeStats,
        'averageFileSize': allFiles.isNotEmpty
            ? totalSize / allFiles.length
            : 0,
      };
    } catch (e) {
      debugPrint('❌ Failed to get storage statistics: $e');
      return {};
    }
  }
}
