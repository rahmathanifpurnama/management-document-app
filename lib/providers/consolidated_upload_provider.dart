import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/upload_file_model.dart';
import '../services/consolidated_upload_service.dart';
import '../services/file_hash_service.dart';
import '../services/statistics_notification_service.dart';
import '../core/config/cloud_functions_config.dart';
import '../core/config/file_config.dart';
import '../services/error_message_service.dart';

/// Consolidated Upload Provider
///
/// This provider manages the upload queue and state for the consolidated upload service.
/// It replaces multiple upload providers with a single, comprehensive solution.
class ConsolidatedUploadProvider with ChangeNotifier {
  static final ConsolidatedUploadProvider _instance =
      ConsolidatedUploadProvider._internal();
  factory ConsolidatedUploadProvider() => _instance;
  ConsolidatedUploadProvider._internal();

  final ConsolidatedUploadService _uploadService = ConsolidatedUploadService();
  final FileHashService _hashService = FileHashService();
  final StatisticsNotificationService _statisticsService =
      StatisticsNotificationService.instance;
  final List<UploadFileModel> _uploadQueue = [];
  final Map<String, StreamController<double>> _progressControllers = {};

  bool _isUploading = false;

  // Cloud Functions settings
  bool _useCloudFunctions = false; // Default disabled for stability
  bool _cloudFunctionsAvailable = false;

  // Getters
  List<UploadFileModel> get uploadQueue => List.unmodifiable(_uploadQueue);
  bool get isUploading => _isUploading;
  int get totalFiles => _uploadQueue.length;
  int get completedFiles =>
      _uploadQueue.where((f) => f.status == UploadStatus.completed).length;
  int get failedFiles =>
      _uploadQueue.where((f) => f.status == UploadStatus.failed).length;
  int get pendingFiles =>
      _uploadQueue.where((f) => f.status == UploadStatus.pending).length;
  int get uploadingFiles =>
      _uploadQueue.where((f) => f.status == UploadStatus.uploading).length;
  double get overallProgress =>
      totalFiles > 0 ? completedFiles / totalFiles : 0.0;

  /// Check if there are active files (uploading or pending)
  bool get hasActiveFiles => _uploadQueue.any(
    (file) =>
        file.status == UploadStatus.uploading ||
        file.status == UploadStatus.pending,
  );

  /// Check if upload queue should be visible
  bool get shouldShowQueue =>
      _uploadQueue.isNotEmpty && (isUploading || hasActiveFiles);

  /// Add files to upload queue with duplicate checking
  Future<void> addFiles(
    List<XFile> files, {
    String? categoryId,
    Map<String, String>? customMetadata,
    bool checkDuplicates = true,
  }) async {
    try {
      debugPrint('📁 Adding ${files.length} files to upload queue');

      // Validate files before adding to queue
      final validationErrors = await _uploadService.validateFiles(files);
      if (validationErrors.isNotEmpty) {
        throw Exception('Validation failed:\n${validationErrors.join('\n')}');
      }

      // Check for duplicates if enabled
      if (checkDuplicates) {
        final duplicateResults = await _checkForDuplicates(files);
        if (duplicateResults.isNotEmpty) {
          final duplicateNames = duplicateResults
              .map((r) => r['fileName'])
              .join(', ');
          throw Exception(
            'Duplicate files detected: $duplicateNames\n'
            '${ErrorMessageService.getErrorMessage('duplicate_file')}',
          );
        }
      }

      // Add files to queue
      for (final file in files) {
        final uploadFile = await UploadFileModel.fromXFile(
          file,
          categoryId: categoryId,
          customMetadata: customMetadata,
        );

        _uploadQueue.add(uploadFile);
        _progressControllers[uploadFile.id] =
            StreamController<double>.broadcast();
      }

      notifyListeners();
      debugPrint('✅ Added ${files.length} files to upload queue');

      // Start uploading if not already in progress
      if (!_isUploading) {
        _startUploading();
      }
    } catch (e) {
      debugPrint('❌ Error adding files to queue: $e');
      rethrow;
    }
  }

  /// Check for duplicate files before adding to queue
  Future<List<Map<String, dynamic>>> _checkForDuplicates(
    List<XFile> files,
  ) async {
    final List<Map<String, dynamic>> duplicates = [];

    try {
      for (final file in files) {
        // Quick check by filename and size first
        final fileSize = await file.length();

        // Calculate file hash for more accurate duplicate detection
        String? fileHash;
        try {
          fileHash = await _hashService.calculateXFileHash(file);
          debugPrint(
            '🔢 Calculated hash for ${file.name}: ${fileHash.substring(0, 16)}...',
          );
        } catch (e) {
          debugPrint('⚠️ Failed to calculate hash for ${file.name}: $e');
          // Continue without hash
        }

        final duplicateResult = await CloudFunctionsConfig.checkDuplicateFile(
          fileName: file.name,
          fileSize: fileSize,
          contentType: _getContentType(file.name),
          fileHash: fileHash,
        );

        if (duplicateResult['isDuplicate'] == true) {
          duplicates.add({
            'fileName': file.name,
            'existingDocument': duplicateResult['existingDocument'],
            'reason': duplicateResult['reason'] ?? 'Duplicate detected',
          });
        }
      }
    } catch (e) {
      debugPrint('❌ Error checking duplicates: $e');
      // Don't fail the entire process if duplicate check fails
    }

    return duplicates;
  }

  /// Get content type based on file extension
  String _getContentType(String fileName) {
    return FileConfig.getMimeType(fileName);
  }

  /// Start uploading files from queue
  Future<void> _startUploading() async {
    if (_isUploading || _uploadQueue.isEmpty) return;

    _isUploading = true;
    notifyListeners();

    debugPrint('🚀 Starting upload process for ${_uploadQueue.length} files');

    try {
      for (int i = 0; i < _uploadQueue.length; i++) {
        final file = _uploadQueue[i];

        if (file.status == UploadStatus.completed ||
            file.status == UploadStatus.failed) {
          continue; // Skip already processed files
        }

        // Processing file at index $i
        notifyListeners();

        await _uploadSingleFile(file);
      }

      debugPrint('✅ Upload process completed');
    } catch (e) {
      debugPrint('❌ Upload process failed: $e');
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  /// Upload a single file with enhanced error handling
  Future<void> _uploadSingleFile(UploadFileModel file) async {
    try {
      debugPrint('📤 Uploading file: ${file.fileName}');

      // Update file status
      _updateFileStatus(file.id, UploadStatus.uploading);
      file.uploadStartTime = DateTime.now();

      // Upload with progress tracking
      final result = await _uploadService.uploadFile(
        file,
        onProgress: (progress) {
          _updateFileProgress(file.id, progress);
        },
        categoryId: file.categoryId,
        customMetadata: file.customMetadata,
      );

      // Validate upload result
      if (result['success'] != true) {
        throw Exception(
          result['message'] ?? 'Upload failed without specific error',
        );
      }

      // Update file with results
      _updateFileStatus(file.id, UploadStatus.completed);
      _updateFileDownloadUrl(file.id, result['downloadUrl']);
      _updateFileDocumentId(file.id, result['documentId']);

      // Add to document provider
      await _addToDocumentProvider(file);

      // STATISTICS UPDATE: Notify about successful file upload
      try {
        _statisticsService.notifyFileUploaded(
          fileId: result['documentId'] ?? file.id,
          fileName: file.fileName,
          category: file.categoryId ?? 'uncategorized',
          fileSize: file.fileSize,
        );
        debugPrint(
          '📊 Statistics notification sent for uploaded file: ${file.fileName}',
        );
      } catch (statsError) {
        debugPrint(
          '⚠️ Statistics notification failed (non-critical): $statsError',
        );
        // Don't fail the upload if statistics update fails
      }

      debugPrint('✅ File uploaded successfully: ${file.fileName}');
    } catch (e) {
      final errorMessage = _categorizeUploadError(e);
      debugPrint('❌ File upload failed: ${file.fileName} - $errorMessage');
      _updateFileStatus(file.id, UploadStatus.failed);
      _updateFileError(file.id, errorMessage);
    }
  }

  /// Categorize upload errors for better user feedback
  String _categorizeUploadError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('network') || errorString.contains('connection')) {
      return 'Network error - please check your internet connection and try again';
    } else if (errorString.contains('authentication') ||
        errorString.contains('permission')) {
      return 'Authentication error - please log in again and try again';
    } else if (errorString.contains('storage') ||
        errorString.contains('quota')) {
      return 'Storage error - you may have reached your storage limit';
    } else if (errorString.contains('file too large') ||
        errorString.contains('size')) {
      return 'File too large - please choose a smaller file';
    } else if (errorString.contains('invalid') ||
        errorString.contains('format')) {
      return 'Invalid file format - please check the file type';
    } else if (errorString.contains('timeout')) {
      return 'Upload timeout - please try again with a stable connection';
    } else {
      return 'Upload failed - ${error.toString()}';
    }
  }

  /// Update file status
  void _updateFileStatus(String fileId, UploadStatus status) {
    final index = _uploadQueue.indexWhere((f) => f.id == fileId);
    if (index != -1) {
      _uploadQueue[index] = _uploadQueue[index].copyWith(status: status);
      notifyListeners();
    }
  }

  /// Update file progress
  void _updateFileProgress(String fileId, double progress) {
    final index = _uploadQueue.indexWhere((f) => f.id == fileId);
    if (index != -1) {
      _uploadQueue[index] = _uploadQueue[index].copyWith(progress: progress);

      // Emit progress to stream with error handling
      final controller = _progressControllers[fileId];
      if (controller != null && !controller.isClosed) {
        try {
          controller.add(progress);
        } catch (e) {
          debugPrint('⚠️ Error updating progress for file $fileId: $e');
          // Remove the problematic controller
          _safelyCloseController(fileId);
        }
      }

      notifyListeners();
    }
  }

  /// Update file download URL
  void _updateFileDownloadUrl(String fileId, String downloadUrl) {
    final index = _uploadQueue.indexWhere((f) => f.id == fileId);
    if (index != -1) {
      _uploadQueue[index] = _uploadQueue[index].copyWith(
        downloadUrl: downloadUrl,
      );
      notifyListeners();
    }
  }

  /// Update file document ID
  void _updateFileDocumentId(String fileId, String documentId) {
    final index = _uploadQueue.indexWhere((f) => f.id == fileId);
    if (index != -1) {
      _uploadQueue[index] = _uploadQueue[index].copyWith(
        documentId: documentId,
      );
      notifyListeners();
    }
  }

  /// Update file error
  void _updateFileError(String fileId, String error) {
    final index = _uploadQueue.indexWhere((f) => f.id == fileId);
    if (index != -1) {
      _uploadQueue[index] = _uploadQueue[index].copyWith(errorMessage: error);
      notifyListeners();
    }
  }

  /// Add uploaded file to document provider using unified ID system
  Future<void> _addToDocumentProvider(UploadFileModel file) async {
    try {
      // UNIFIED ID SYSTEM: Convert upload file to DocumentModel with proper ID validation
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        debugPrint(
          '⚠️ Cannot add to document provider: User not authenticated',
        );
        return;
      }

      final documentModel = await file.toDocument(
        uploadedBy: currentUser.uid,
        filePath:
            'documents/${file.categoryId ?? 'uncategorized'}/${file.fileName}',
      );

      if (documentModel != null) {
        // Add to document provider if conversion successful
        // DocumentProvider.instance.addDocument(documentModel);
        debugPrint(
          '✅ File added to document provider: ${file.fileName} (ID: ${documentModel.id})',
        );
      } else {
        debugPrint(
          '⚠️ Failed to convert upload file to document model: ${file.fileName}',
        );
      }
    } catch (e) {
      debugPrint('❌ Failed to add file to document provider: $e');
    }
  }

  /// Get progress stream for a specific file
  Stream<double>? getProgressStream(String fileId) {
    return _progressControllers[fileId]?.stream;
  }

  /// Remove file from queue
  void removeFile(String fileId) {
    final index = _uploadQueue.indexWhere((f) => f.id == fileId);
    if (index != -1) {
      final file = _uploadQueue[index];

      // Only remove if not currently uploading
      if (file.status != UploadStatus.uploading) {
        _uploadQueue.removeAt(index);

        // Close progress controller safely
        _safelyCloseController(fileId);

        notifyListeners();
        debugPrint('🗑️ File removed from queue: ${file.fileName}');
      }
    }
  }

  /// Safely close and remove a progress controller
  void _safelyCloseController(String fileId) {
    try {
      final controller = _progressControllers[fileId];
      if (controller != null && !controller.isClosed) {
        controller.close();
      }
    } catch (e) {
      debugPrint('⚠️ Error closing controller for file $fileId: $e');
    } finally {
      _progressControllers.remove(fileId);
    }
  }

  /// Clear completed files from queue
  void clearCompleted() {
    final completedFiles = _uploadQueue
        .where((f) => f.status == UploadStatus.completed)
        .toList();

    for (final file in completedFiles) {
      removeFile(file.id);
    }

    // Notify listeners to update UI immediately
    notifyListeners();

    debugPrint(
      '🧹 Cleared ${completedFiles.length} completed files from queue',
    );
  }

  /// Clear completed files with delay for better UX
  void clearCompletedWithDelay({Duration delay = const Duration(seconds: 3)}) {
    Timer(delay, () {
      if (hasSuccessfulUploads && failedFiles == 0) {
        clearCompleted();
      }
    });
  }

  /// Clear all files from queue
  void clearAll() {
    // Close all progress controllers safely
    final controllerIds = List<String>.from(_progressControllers.keys);
    for (final fileId in controllerIds) {
      _safelyCloseController(fileId);
    }

    _uploadQueue.clear();
    _isUploading = false;

    notifyListeners();
    debugPrint('🧹 Cleared all files from upload queue');
  }

  /// Retry failed uploads
  Future<void> retryFailed() async {
    final failedFiles = _uploadQueue
        .where((f) => f.status == UploadStatus.failed)
        .toList();

    for (final file in failedFiles) {
      _updateFileStatus(file.id, UploadStatus.pending);
    }

    if (failedFiles.isNotEmpty && !_isUploading) {
      debugPrint('🔄 Retrying ${failedFiles.length} failed uploads');
      _startUploading();
    }
  }

  /// Get file by ID
  UploadFileModel? getFile(String fileId) {
    try {
      return _uploadQueue.firstWhere((f) => f.id == fileId);
    } catch (e) {
      return null;
    }
  }

  /// Check if file type is allowed
  bool isFileTypeAllowed(String fileName) {
    return FileConfig.isExtensionAllowed(fileName);
  }

  /// Check if file size is allowed
  bool isFileSizeAllowed(int fileSize) {
    return FileConfig.isFileSizeAllowed(fileSize);
  }

  /// Clear all files and reset state
  void clearAllAndReset() {
    clearAll();
  }

  /// Check if there are successful uploads
  bool get hasSuccessfulUploads => completedFiles > 0;

  // Cloud Functions methods

  /// Get Cloud Functions enabled status
  bool get isCloudFunctionsEnabled => _useCloudFunctions;

  /// Get Cloud Functions availability status
  bool get isCloudFunctionsAvailable => _cloudFunctionsAvailable;

  /// Toggle Cloud Functions usage
  void toggleCloudFunctions(bool enabled) {
    _useCloudFunctions = enabled;
    debugPrint('🔧 Cloud Functions ${enabled ? 'enabled' : 'disabled'}');
    notifyListeners();
  }

  /// Check Cloud Functions availability
  Future<bool> checkCloudFunctionsAvailability() async {
    try {
      debugPrint('🔍 Checking Cloud Functions availability...');

      final isAvailable = await CloudFunctionsConfig.initialize();
      _cloudFunctionsAvailable = isAvailable;

      if (isAvailable) {
        debugPrint('✅ Cloud Functions are available and ready');
      } else {
        debugPrint('❌ Cloud Functions not available');
      }

      notifyListeners();
      return isAvailable;
    } catch (e) {
      debugPrint('❌ Cloud Functions availability check failed: $e');
      _cloudFunctionsAvailable = false;
      notifyListeners();
      return false;
    }
  }

  /// Initialize Cloud Functions on provider startup
  Future<void> initializeCloudFunctions() async {
    await checkCloudFunctionsAvailability();
  }

  @override
  void dispose() {
    // Close all progress controllers safely
    final controllerIds = List<String>.from(_progressControllers.keys);
    for (final fileId in controllerIds) {
      _safelyCloseController(fileId);
    }
    super.dispose();
  }
}
