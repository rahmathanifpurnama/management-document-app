import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../models/upload_file_model.dart';
import '../core/config/cloud_functions_config.dart';
import '../core/config/file_config.dart';
import '../services/google_drive_service.dart';

/// HYBRID UPLOAD SERVICE
/// =====================
/// Client: Light operations only (basic validation + direct upload)
/// Server: Heavy processing (hashing, compression, metadata extraction, advanced validation)
///
/// Benefits:
/// - ⚡ Fast upload (direct to storage)
/// - 🔋 Battery friendly (minimal client processing)
/// - 📱 Light on device resources
/// - 🚀 Consistent performance across devices
/// - 🛡️ Advanced server-side security & processing
class HybridUploadService {
  // File size limits
  static const int maxFileSize = 100 * 1024 * 1024; // 100MB
  static const int maxImageSize = 10 * 1024 * 1024; // 10MB for images

  // Allowed file types (basic validation only)
  static const Map<String, List<String>> allowedTypes = {
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

  /// HYBRID UPLOAD: Light client + Heavy server processing
  /// Client: Basic validation + Direct upload only
  /// Server: Advanced processing, hashing, compression, metadata extraction
  Future<Map<String, dynamic>> uploadFile(
    UploadFileModel file, {
    required Function(double) onProgress,
    String? categoryId,
    Map<String, String>? customMetadata,
  }) async {
    try {
      debugPrint('🚀 Starting HYBRID file upload: ${file.fileName}');

      // PHASE 1: LIGHT CLIENT OPERATIONS (10% progress)
      // ================================================

      // Step 1: Authentication check (lightweight)
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        debugPrint('❌ UPLOAD FAILED: User not authenticated');
        throw Exception('User not authenticated');
      }
      debugPrint('✅ User authenticated: ${currentUser.uid}');
      onProgress(2);

      // Step 2: Basic client-side validation ONLY (no heavy processing)
      await _basicValidation(file);
      debugPrint('✅ Basic validation passed');
      onProgress(5);

      // Step 3: Initialize Google Drive service (lightweight)
      final googleDriveService = GoogleDriveService();
      await googleDriveService.initialize();
      onProgress(8);

      // Step 4: Quick duplicate check (filename + size only, no hashing)
      await _quickDuplicateCheck(file, currentUser.uid);
      debugPrint('✅ Quick duplicate check passed');
      onProgress(10);

      // PHASE 2: DIRECT UPLOAD TO STORAGE (80% progress)
      // ================================================

      debugPrint('📤 Starting direct upload to Firebase Storage...');
      final downloadUrl = await _directUploadToStorage(
        file,
        currentUser.uid,
        categoryId,
        onProgress: (progress) => onProgress(10 + (progress * 0.8)), // 10-90%
      );
      debugPrint('✅ Direct upload completed: $downloadUrl');
      onProgress(90);

      // PHASE 3: BACKGROUND SERVER PROCESSING (10% progress)
      // ===================================================

      debugPrint('⚙️ Triggering background server processing...');

      // Small delay to ensure file is fully committed to Storage
      await Future.delayed(const Duration(milliseconds: 500));

      String? documentId;

      try {
        // Trigger Cloud Functions for heavy processing (non-blocking)
        final processingResult = await _triggerServerProcessing(
          filePath: _getStoragePath(file.fileName, currentUser.uid, categoryId),
          fileName: file.fileName,
          downloadUrl: downloadUrl,
          currentUser: currentUser,
          categoryId: categoryId,
          customMetadata: customMetadata,
        );
        documentId = processingResult['documentId'];
        debugPrint('✅ Server processing completed');
      } catch (e) {
        debugPrint('❌ Server processing failed: $e');
        // IMPORTANT: Don't create fallback document to prevent duplicates
        // Let the upload fail and show error to user
        throw Exception('Upload processing failed: $e');
      }

      onProgress(100);

      debugPrint('🎉 HYBRID upload completed successfully!');
      return {
        'success': true,
        'downloadUrl': downloadUrl,
        'documentId': documentId,
        'message':
            'File uploaded successfully. Advanced processing in background.',
        'processingMode': 'hybrid',
      };
    } catch (e) {
      debugPrint('❌ Hybrid upload failed: $e');
      rethrow;
    }
  }

  /// Basic validation (lightweight, client-side only)
  Future<void> _basicValidation(UploadFileModel file) async {
    // Check file size only
    final fileSize = await file.file.length();
    if (fileSize > maxFileSize) {
      throw Exception(
        'File too large. Maximum size: ${(maxFileSize / (1024 * 1024)).toStringAsFixed(0)}MB',
      );
    }

    // Check file extension only (no content analysis)
    final extension = file.fileName.split('.').last.toLowerCase();
    final isAllowed = allowedTypes.values.any(
      (exts) => exts.contains(extension),
    );

    if (!isAllowed) {
      throw Exception('File type not supported: .$extension');
    }

    debugPrint(
      '✅ Basic validation: Size ${(fileSize / 1024).toStringAsFixed(1)}KB, Type: .$extension',
    );
  }

  /// Quick duplicate check (filename + size only, no hashing)
  Future<void> _quickDuplicateCheck(UploadFileModel file, String userId) async {
    try {
      final fileSize = await file.file.length();

      // Simple query: same filename + same size + same user
      final existingDocs = await FirebaseFirestore.instance
          .collection('documents')
          .where('fileName', isEqualTo: file.fileName)
          .where('fileSize', isEqualTo: fileSize)
          .where('uploadedBy', isEqualTo: userId)
          .limit(1)
          .get();

      if (existingDocs.docs.isNotEmpty) {
        throw Exception(
          'File with same name and size already exists.\n'
          'Upload cancelled to prevent duplication.',
        );
      }

      debugPrint('✅ Quick duplicate check: No duplicates found');
    } catch (e) {
      if (e.toString().contains('already exists')) {
        rethrow;
      }
      // If query fails, continue (don't block upload for connectivity issues)
      debugPrint('⚠️ Quick duplicate check failed, continuing: $e');
    }
  }

  /// Direct upload to Firebase Storage (no compression, no processing)
  Future<String> _directUploadToStorage(
    UploadFileModel file,
    String userId,
    String? categoryId, {
    required Function(double) onProgress,
  }) async {
    try {
      final filePath = _getStoragePath(file.fileName, userId, categoryId);
      final storageRef = FirebaseStorage.instance.ref().child(filePath);

      debugPrint('📤 Uploading to: $filePath');

      // Read file as bytes
      final fileBytes = await file.file.readAsBytes();

      // Upload with progress tracking
      final uploadTask = storageRef.putData(
        fileBytes,
        SettableMetadata(
          contentType: _getContentType(file.fileName),
          customMetadata: {
            'uploadedBy': userId,
            'originalFileName': file.fileName,
            'uploadTimestamp': DateTime.now().toIso8601String(),
            'processingStatus': 'pending', // Will be updated by server
          },
        ),
      );

      // Track upload progress
      uploadTask.snapshotEvents.listen((snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress(progress);
      });

      // Wait for completion
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      debugPrint(
        '✅ Direct upload completed: ${snapshot.bytesTransferred} bytes',
      );
      return downloadUrl;
    } catch (e) {
      debugPrint('❌ Direct upload failed: $e');
      rethrow;
    }
  }

  /// Get storage path for file using human-readable email-based folders
  String _getStoragePath(String fileName, String userId, String? categoryId) {
    // Get user email for human-readable folder structure
    final userEmail = _getUserEmailFromId(userId);
    final sanitizedEmail = _sanitizeEmailForStorage(userEmail);

    // New path structure: documents/sanitized-email/fileName
    return 'documents/$sanitizedEmail/$fileName';
  }

  /// Get user email from userId (Firebase UID)
  String _getUserEmailFromId(String userId) {
    try {
      // Try to get email from current Firebase user if it matches
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null && currentUser.uid == userId) {
        return currentUser.email ?? userId; // Fallback to userId if no email
      }

      // For other users, we'll need to fallback to userId
      // In a real implementation, you might want to cache user emails
      // or make a Firestore query, but for performance we'll use fallback
      debugPrint(
        '⚠️ Could not resolve email for userId: $userId, using fallback',
      );
      return userId; // Fallback to original behavior
    } catch (e) {
      debugPrint('❌ Error getting user email: $e');
      return userId; // Fallback to original behavior
    }
  }

  /// Sanitize email address for Firebase Storage path compatibility
  String _sanitizeEmailForStorage(String email) {
    // Convert email to storage-safe format
    // john.doe@company.com -> john-dot-doe-at-company-dot-com
    return email
        .replaceAll('@', '-at-')
        .replaceAll('.', '-dot-')
        .replaceAll('+', '-plus-')
        .replaceAll(' ', '-')
        .toLowerCase();
  }

  /// Get content type from filename
  String _getContentType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();

    for (final entry in allowedTypes.entries) {
      if (entry.value.contains(extension)) {
        return entry.key;
      }
    }

    return 'application/octet-stream'; // Default
  }

  /// Trigger server processing (heavy operations on Cloud Functions)
  Future<Map<String, dynamic>> _triggerServerProcessing({
    required String filePath,
    required String fileName,
    required String downloadUrl,
    required User currentUser,
    String? categoryId,
    Map<String, String>? customMetadata,
  }) async {
    try {
      debugPrint('⚙️ Triggering server processing for: $fileName');
      debugPrint('📍 File path: $filePath');
      debugPrint('🔗 Download URL: $downloadUrl');
      debugPrint('👤 User ID: ${currentUser.uid}');
      debugPrint('📁 Category ID: $categoryId');

      // Check Cloud Functions availability first
      final isAvailable = await CloudFunctionsConfig.initialize();
      debugPrint('🔧 Cloud Functions available: $isAvailable');

      if (!isAvailable) {
        throw Exception('Cloud Functions not available');
      }

      // Call Cloud Function for heavy processing
      debugPrint('📞 Calling hybridProcessFileUpload function...');
      final result = await CloudFunctionsConfig.processFileUpload(
        filePath: filePath,
        fileName: fileName,
        contentType: _getContentType(fileName),
        categoryId: categoryId,
        metadata: {
          'uploadedBy': currentUser.uid,
          'downloadUrl': downloadUrl,
          'deviceId': 'flutter_app_hybrid',
          'timestamp': DateTime.now().toIso8601String(),
          'processingMode': 'server_heavy',
          ...?customMetadata,
        },
      );

      debugPrint('✅ Server processing completed: ${result['documentId']}');
      return result;
    } catch (e) {
      debugPrint('❌ Server processing failed: $e');
      debugPrint('❌ Error type: ${e.runtimeType}');
      debugPrint('❌ Error details: ${e.toString()}');
      rethrow;
    }
  }

  /// Validate multiple files (FEATURE PARITY with ConsolidatedUploadService)
  Future<List<String>> validateFiles(List<XFile> files) async {
    final errors = <String>[];

    for (final file in files) {
      try {
        // Basic validation for each file
        final fileSize = await file.length();
        final fileName = file.name;

        // Check file size
        if (fileSize > FileConfig.maxFileSize) {
          errors.add(
            '$fileName: File size (${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB) '
            'exceeds maximum allowed size (${(FileConfig.maxFileSize / (1024 * 1024)).toStringAsFixed(1)}MB)',
          );
          continue;
        }

        // Check file extension
        final extension = fileName.split('.').last.toLowerCase();
        if (!FileConfig.allowedExtensions.contains(extension)) {
          errors.add(
            '$fileName: File type .$extension is not allowed. '
            'Allowed types: ${FileConfig.allowedExtensions.join(', ')}',
          );
          continue;
        }

        // Check file name
        if (fileName.isEmpty || fileName.length > 255) {
          errors.add('$fileName: Invalid file name length');
          continue;
        }

        debugPrint('✅ HYBRID: File validation passed for $fileName');
      } catch (e) {
        errors.add('${file.name}: Validation error - $e');
      }
    }

    if (errors.isNotEmpty) {
      debugPrint(
        '❌ HYBRID: File validation failed with ${errors.length} errors',
      );
    } else {
      debugPrint('✅ HYBRID: All ${files.length} files passed validation');
    }

    return errors;
  }
}
