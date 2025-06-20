import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/config/cloud_functions_config.dart';
import '../models/upload_file_model.dart';
import '../core/services/firebase_service.dart';
import '../core/services/unified_id_system.dart';
import '../services/image_compression_service.dart';
import '../services/file_hash_service.dart';
import '../services/google_drive_service.dart';
import '../core/config/file_config.dart';

/// Consolidated Upload Service
///
/// This service combines all upload functionality into a single, comprehensive
/// service that handles file validation, security, compression, and Cloud Functions
/// integration with proper error handling and performance optimization.
class ConsolidatedUploadService {
  static final ConsolidatedUploadService _instance =
      ConsolidatedUploadService._internal();
  factory ConsolidatedUploadService() => _instance;
  ConsolidatedUploadService._internal();

  final FirebaseStorage _storage = FirebaseService.instance.storage;
  final ImageCompressionService _compressionService =
      ImageCompressionService.instance;
  final FileHashService _hashService = FileHashService();

  // Configuration constants
  static const Duration uploadTimeout = Duration(minutes: 5);
  static const int maxRetries = 3;

  // Use centralized file configuration
  static int get maxFileSize => FileConfig.maxFileSize;
  static List<String> get allowedExtensions => FileConfig.allowedExtensions;

  static const Map<String, List<String>> mimeTypeMap = {
    'application/pdf': ['pdf'],
    'application/msword': ['doc'],
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document': [
      'docx',
    ],
    'application/vnd.ms-excel': ['xls'],
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet': [
      'xlsx',
    ],
    'application/vnd.ms-powerpoint': ['ppt'],
    'application/vnd.openxmlformats-officedocument.presentationml.presentation':
        ['pptx'],
    'image/jpeg': ['jpg', 'jpeg'],
    'image/png': ['png'],
    'image/gif': ['gif'],
    'text/plain': ['txt'],
  };

  /// Upload file with comprehensive validation and Google Drive integration
  Future<Map<String, dynamic>> uploadFile(
    UploadFileModel file, {
    required Function(double) onProgress,
    String? categoryId,
    Map<String, String>? customMetadata,
  }) async {
    try {
      debugPrint('🔄 Starting consolidated file upload: ${file.fileName}');

      // Step 1: Authentication check
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Step 2: Client-side validation
      await _validateFile(file);
      onProgress(10);

      // Step 3: Calculate file hash for duplicate detection
      debugPrint('🔢 Calculating file hash for duplicate detection...');
      final fileHash = await _hashService.calculateXFileHash(file.file);
      onProgress(15);

      // Step 4: Initialize Google Drive service
      final googleDriveService = GoogleDriveService();
      await googleDriveService.initialize();
      onProgress(20);

      // Step 4: Check for duplicates (with fallback)
      debugPrint('🔍 Checking for duplicate files...');
      try {
        final duplicateResult = await CloudFunctionsConfig.checkDuplicateFile(
          fileName: file.fileName,
          fileSize: await file.file.length(),
          contentType: _getContentType(file.fileName),
          fileHash: fileHash,
        );

        if (duplicateResult['isDuplicate'] == true) {
          final existingDoc = duplicateResult['existingDocument'];
          final existingFileName = existingDoc?['fileName'] ?? 'Unknown';
          throw Exception(
            'File already exists in the system. Original file: $existingFileName\n'
            'Upload cancelled to prevent duplication.',
          );
        }
      } catch (e) {
        if (e.toString().contains('Cloud Functions not available')) {
          debugPrint(
            '⚠️ Cloud Functions not available for duplicate check, skipping...',
          );
        } else {
          rethrow;
        }
      }
      onProgress(20);

      // Step 5: Cloud Functions validation (with fallback)
      try {
        final validationResult = await CloudFunctionsConfig.validateFile(
          fileName: file.fileName,
          contentType: _getContentType(file.fileName),
          fileSize: await file.file.length(),
        );

        if (!validationResult['isValid']) {
          throw Exception(
            validationResult['error'] ?? 'File validation failed',
          );
        }
      } catch (e) {
        if (e.toString().contains('Cloud Functions not available')) {
          debugPrint(
            '⚠️ Cloud Functions not available for validation, proceeding with basic validation...',
          );
          // Perform basic local validation as fallback (no content scanning)
          await _validateFile(file);
        } else {
          rethrow;
        }
      }
      onProgress(25);

      // Step 6: Image compression if needed
      File processedFile = File(file.file.path);
      File? tempFile;
      try {
        if (_isImageFile(file.fileName)) {
          final compressionResult = await _compressionService.compressImage(
            imageFile: file.file,
            maxFileSize: 5 * 1024 * 1024, // 5MB max for images
          );

          if (compressionResult.wasCompressed) {
            // Write compressed bytes to a temporary file
            tempFile = File('${file.file.path}_compressed');
            await tempFile.writeAsBytes(compressionResult.compressedBytes);
            processedFile = tempFile;
            debugPrint('📷 Image compressed successfully');
          }
        }
        onProgress(30);

        // Step 5: Upload to Firebase Storage with retry logic
        final downloadUrl = await _uploadWithRetry(
          processedFile,
          file.fileName,
          currentUser.uid,
          categoryId,
          onProgress: (progress) => onProgress(30 + (progress * 0.4)), // 30-70%
        );
        onProgress(70);

        // Step 7: Process with Cloud Functions (with fallback)
        String? documentId;
        try {
          final processingResult = await CloudFunctionsConfig.processFileUpload(
            filePath: _getStoragePath(
              file.fileName,
              currentUser.uid,
              categoryId,
            ),
            fileName: file.fileName,
            contentType: _getContentType(file.fileName),
            categoryId: categoryId,
            metadata: {
              'uploadedBy': currentUser.uid,
              'downloadUrl': downloadUrl,
              'fileSize': (await processedFile.length()).toString(),
              'fileHash': fileHash, // Include file hash for duplicate detection
              'deviceId': 'flutter_app',
              'timestamp': DateTime.now().toIso8601String(),
              'duplicateChecked': 'true',
              ...?customMetadata,
            },
          );
          documentId = processingResult['documentId'];
        } catch (e) {
          if (e.toString().contains('Cloud Functions not available')) {
            debugPrint(
              '⚠️ Cloud Functions not available for processing, creating document locally...',
            );
            // Create document record locally as fallback
            documentId = await _createDocumentLocally(
              file,
              downloadUrl,
              currentUser.uid,
              categoryId,
              fileHash,
              customMetadata,
            );
          } else {
            rethrow;
          }
        }
        onProgress(100);

        debugPrint('✅ File upload completed successfully');
        return {
          'success': true,
          'downloadUrl': downloadUrl,
          'documentId': documentId,
          'message': 'File uploaded and processed successfully',
        };
      } finally {
        // Clean up temporary file if it was created
        if (tempFile != null && await tempFile.exists()) {
          try {
            await tempFile.delete();
            debugPrint('🧹 Temporary file cleaned up: ${tempFile.path}');
          } catch (e) {
            debugPrint('⚠️ Failed to clean up temporary file: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Upload failed: $e');
      rethrow;
    }
  }

  /// Validate file before upload
  Future<void> _validateFile(UploadFileModel file) async {
    // Check file size
    final fileSize = await file.file.length();
    if (fileSize > maxFileSize) {
      throw Exception(
        'File size exceeds maximum limit of ${maxFileSize ~/ (1024 * 1024)}MB',
      );
    }

    if (fileSize <= 0) {
      throw Exception('Invalid file size');
    }

    // Check file extension
    final extension = file.fileName.split('.').last.toLowerCase();
    if (!allowedExtensions.contains(extension)) {
      throw Exception('File type .$extension is not allowed');
    }

    // Check MIME type consistency
    final contentType = _getContentType(file.fileName);
    final expectedExtensions = mimeTypeMap[contentType];
    if (expectedExtensions != null && !expectedExtensions.contains(extension)) {
      throw Exception('File extension does not match content type');
    }
  }

  /// Upload file with retry logic
  Future<String> _uploadWithRetry(
    File file,
    String fileName,
    String userId,
    String? categoryId, {
    required Function(double) onProgress,
  }) async {
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        final storagePath = _getStoragePath(fileName, userId, categoryId);
        final ref = _storage.ref().child(storagePath);

        final uploadTask = ref.putFile(
          file,
          SettableMetadata(
            contentType: _getContentType(fileName),
            customMetadata: {
              'uploadedBy': userId,
              'originalName': fileName,
              'uploadTimestamp': DateTime.now().toIso8601String(),
            },
          ),
        );

        // Monitor upload progress
        uploadTask.snapshotEvents.listen((snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });

        final snapshot = await uploadTask.timeout(uploadTimeout);
        return await snapshot.ref.getDownloadURL();
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          throw Exception('Upload failed after $maxRetries attempts: $e');
        }

        // Exponential backoff
        await Future.delayed(Duration(seconds: retryCount * 2));
        debugPrint('🔄 Retrying upload (attempt $retryCount)');
      }
    }

    throw Exception('Upload failed after maximum retries');
  }

  /// Generate storage path for file (without timestamp)
  String _getStoragePath(String fileName, String userId, String? categoryId) {
    final sanitizedFileName = _sanitizeFileName(fileName);

    if (categoryId != null && categoryId.isNotEmpty) {
      return 'documents/categories/$categoryId/$sanitizedFileName';
    } else {
      return 'documents/$sanitizedFileName';
    }
  }

  /// Get clean display filename (without timestamp)
  String _getDisplayFileName(String fileName) {
    return _sanitizeFileName(fileName);
  }

  /// Sanitize filename for storage
  String _sanitizeFileName(String fileName) {
    return fileName
        .replaceAll(RegExp(r'[^\w\s\-\.]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
  }

  /// Get content type based on file extension
  String _getContentType(String fileName) {
    return FileConfig.getMimeType(fileName);
  }

  /// Check if file is an image
  bool _isImageFile(String fileName) {
    return FileConfig.getFileTypeCategory(fileName) == 'image';
  }

  /// Validate multiple files
  Future<List<String>> validateFiles(List<XFile> files) async {
    final errors = <String>[];

    for (final file in files) {
      try {
        final uploadFile = await UploadFileModel.fromXFile(file);
        await _validateFile(uploadFile);
      } catch (e) {
        errors.add('${file.name}: $e');
      }
    }

    return errors;
  }

  /// Check if file type is allowed
  bool isFileTypeAllowed(String fileName) {
    return FileConfig.isExtensionAllowed(fileName);
  }

  /// Check if file size is allowed
  bool isFileSizeAllowed(int fileSize) {
    return FileConfig.isFileSizeAllowed(fileSize);
  }

  /// Create document record locally when Cloud Functions are not available
  /// Uses unified ID system for consistency
  Future<String> _createDocumentLocally(
    UploadFileModel file,
    String downloadUrl,
    String userId,
    String? categoryId,
    String fileHash,
    Map<String, String>? customMetadata,
  ) async {
    try {
      // UNIFIED ID SYSTEM: Use UnifiedIdSystem for consistent ID generation
      final unifiedIdSystem = UnifiedIdSystem.instance;
      final documentId = await unifiedIdSystem.createDocumentWithUnifiedId(
        fileName: _getDisplayFileName(file.fileName),
        filePath: _getStoragePath(file.fileName, userId, categoryId),
        uploadedBy: userId,
        category: categoryId ?? 'uncategorized',
        fileSize: await file.file.length(),
        fileType: _getFileType(file.fileName),
        additionalMetadata: {
          'downloadUrl': downloadUrl,
          'fileHash': fileHash,
          'createdBy': 'flutter_upload_service',
          'uploadMethod': 'local_fallback',
          ...?customMetadata,
        },
      );

      debugPrint(
        '✅ ConsolidatedUploadService: Document created with unified ID: $documentId',
      );
      return documentId;
    } catch (e) {
      debugPrint('❌ Failed to create document locally: $e');
      rethrow;
    }
  }

  /// Get file type based on extension
  String _getFileType(String fileName) {
    return FileConfig.getFileTypeDisplayName(fileName);
  }
}
