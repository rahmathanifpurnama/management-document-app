import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/upload_file_model.dart';
import '../services/hybrid_upload_service.dart';
import '../services/file_hash_service.dart';
import '../services/statistics_notification_service.dart';
import '../core/config/cloud_functions_config.dart';
import '../core/config/upload_config.dart';
import '../services/error_message_service.dart';

/// Hybrid Upload Provider
///
/// This provider manages the upload queue and state for the hybrid upload service.
/// It provides the same functionality as ConsolidatedUploadProvider but uses
/// the optimized HybridUploadService for better performance and battery efficiency.
///
/// Key Features:
/// - ⚡ Fast upload (direct to Firebase Storage)
/// - 🔋 Battery friendly (minimal client processing)
/// - 📱 Light on device resources
/// - 🛡️ Advanced server-side security & processing
/// - 🔄 Complete feature parity with ConsolidatedUploadProvider
class HybridUploadProvider with ChangeNotifier {
  static final HybridUploadProvider _instance =
      HybridUploadProvider._internal();
  factory HybridUploadProvider() => _instance;
  HybridUploadProvider._internal();

  final HybridUploadService _uploadService = HybridUploadService();
  final FileHashService _hashService = FileHashService();
  final StatisticsNotificationService _statisticsService =
      StatisticsNotificationService.instance;
  final List<UploadFileModel> _uploadQueue = [];
  final Map<String, StreamController<double>> _progressControllers = {};
  final Map<String, double> _lastProgressUpdate =
      {}; // Track last progress update per file
  Timer? _uiUpdateTimer; // Timer for batched UI updates

  bool _isUploading = false;

  // Cloud Functions settings (maintained for compatibility)
  bool _useCloudFunctions = true; // Enabled by default for hybrid system
  bool _cloudFunctionsAvailable = false;

  // Getters - EXACT SAME as ConsolidatedUploadProvider
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

  /// Check if there are successful uploads (FEATURE PARITY)
  bool get hasSuccessfulUploads => completedFiles > 0;

  /// Add files to upload queue with duplicate checking
  /// FEATURE PARITY: Exact same functionality as ConsolidatedUploadProvider
  Future<void> addFiles(
    List<XFile> files, {
    String? categoryId,
    Map<String, String>? customMetadata,
    bool checkDuplicates = true,
  }) async {
    try {
      debugPrint('📁 HYBRID: Adding ${files.length} files to upload queue');

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

      debugPrint('✅ HYBRID: ${files.length} files added to queue');
      notifyListeners();

      // Auto-start upload if not already uploading
      if (!_isUploading) {
        await startUpload();
      }
    } catch (e) {
      debugPrint('❌ HYBRID: Failed to add files: $e');
      rethrow;
    }
  }

  /// Check for duplicate files using hybrid approach
  /// FEATURE PARITY: Same duplicate detection logic
  Future<List<Map<String, dynamic>>> _checkForDuplicates(
    List<XFile> files,
  ) async {
    final duplicates = <Map<String, dynamic>>[];

    try {
      for (final file in files) {
        // Quick local duplicate check first (lightweight)
        final existingFile = _uploadQueue.firstWhere(
          (uploadFile) => uploadFile.fileName == file.name,
          orElse: () => UploadFileModel(
            id: '',
            fileName: '',
            file: file,
            fileSize: 0,
            fileType: '',
            status: UploadStatus.pending,
          ),
        );

        if (existingFile.fileName.isNotEmpty) {
          duplicates.add({
            'fileName': file.name,
            'reason': 'Already in upload queue',
          });
          continue;
        }

        // Advanced duplicate check via Cloud Functions (if available)
        if (_useCloudFunctions && CloudFunctionsConfig.isAvailable) {
          try {
            final fileHash = await _hashService.calculateXFileHash(file);
            final duplicateResult =
                await CloudFunctionsConfig.checkDuplicateFile(
                  fileName: file.name,
                  fileSize: await file.length(),
                  contentType: _getContentType(file.name),
                  fileHash: fileHash,
                );

            if (duplicateResult['isDuplicate'] == true) {
              duplicates.add({
                'fileName': file.name,
                'reason': 'File already exists in system',
                'existingDocument': duplicateResult['existingDocument'],
              });
            }
          } catch (e) {
            debugPrint('⚠️ HYBRID: Cloud Functions duplicate check failed: $e');
            // Continue without duplicate check if CF unavailable
          }
        }
      }
    } catch (e) {
      debugPrint('❌ HYBRID: Duplicate check failed: $e');
      // Return empty list to allow upload to proceed
    }

    return duplicates;
  }

  /// Get content type for file
  String _getContentType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    const mimeTypeMap = {
      'pdf': 'application/pdf',
      'doc': 'application/msword',
      'docx':
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'xls': 'application/vnd.ms-excel',
      'xlsx':
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'ppt': 'application/vnd.ms-powerpoint',
      'pptx':
          'application/vnd.openxmlformats-officedocument.presentationml.presentation',
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      'txt': 'text/plain',
    };
    return mimeTypeMap[extension] ?? 'application/octet-stream';
  }

  /// Start upload process
  /// FEATURE PARITY: Same upload orchestration logic
  Future<void> startUpload() async {
    if (_isUploading) {
      debugPrint('⚠️ HYBRID: Upload already in progress');
      return;
    }

    _isUploading = true;
    notifyListeners();

    try {
      // Get pending files that need to be uploaded
      final pendingFiles = _uploadQueue
          .where(
            (file) =>
                file.status != UploadStatus.completed &&
                file.status != UploadStatus.failed,
          )
          .toList();

      if (pendingFiles.isEmpty) {
        debugPrint('✅ HYBRID: No pending files to upload');
        return;
      }

      // Process files in concurrent batches (same as original)
      await _processConcurrentUploads(pendingFiles);

      // Perform memory cleanup after bulk upload
      _performMemoryCleanup();

      debugPrint('✅ HYBRID: Concurrent upload process completed');
    } catch (e) {
      debugPrint('❌ HYBRID: Upload process failed: $e');
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  /// Process concurrent uploads with hybrid service
  /// FEATURE PARITY: Same concurrent processing logic
  Future<void> _processConcurrentUploads(List<UploadFileModel> files) async {
    const int maxConcurrentUploads = UploadConfig.maxConcurrentUploads;
    const Duration fileTimeout = Duration(
      minutes: 10,
    ); // Increased for hybrid processing

    debugPrint(
      '🚀 HYBRID: Processing ${files.length} files with max $maxConcurrentUploads concurrent uploads',
    );

    // Process files in batches
    for (int i = 0; i < files.length; i += maxConcurrentUploads) {
      final batch = files.skip(i).take(maxConcurrentUploads).toList();

      // Process batch concurrently
      final futures = batch.map((file) => _uploadSingleFile(file, fileTimeout));
      await Future.wait(futures, eagerError: false);

      // Small delay between batches to prevent overwhelming the system
      if (i + maxConcurrentUploads < files.length) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  /// Upload single file with hybrid service
  /// FEATURE PARITY: Same individual upload logic but using HybridUploadService
  Future<void> _uploadSingleFile(
    UploadFileModel file,
    Duration fileTimeout,
  ) async {
    try {
      debugPrint('📤 HYBRID: Starting upload for ${file.fileName}');

      // Update file status to uploading
      file.status = UploadStatus.uploading;
      notifyListeners();

      // Upload with progress tracking and individual timeout
      final result = await Future.any([
        _uploadService.uploadFile(
          file,
          onProgress: (progress) {
            _updateFileProgress(file.id, progress);
          },
          categoryId: file.categoryId,
          customMetadata: file.customMetadata,
        ),
        Future.delayed(fileTimeout).then(
          (_) => throw TimeoutException(
            'File upload timeout after ${fileTimeout.inSeconds} seconds',
            fileTimeout,
          ),
        ),
      ]);

      // Validate upload result
      if (result['success'] != true) {
        throw Exception(
          result['message'] ?? 'Upload failed without specific error',
        );
      }

      // Update file status to completed
      file.status = UploadStatus.completed;
      file.documentId = result['documentId'];
      file.downloadUrl = result['downloadUrl'];

      debugPrint('✅ HYBRID: Upload completed for ${file.fileName}');

      // Update statistics - FEATURE PARITY: Same statistics notification
      try {
        _statisticsService.notifyFileUploaded(
          fileId: result['documentId'] ?? file.id,
          fileName: file.fileName,
          category: file.categoryId ?? 'uncategorized',
          fileSize: file.fileSize,
        );
        debugPrint(
          '📊 HYBRID: Statistics notification sent for uploaded file: ${file.fileName}',
        );
      } catch (statsError) {
        debugPrint(
          '⚠️ HYBRID: Statistics notification failed (non-critical): $statsError',
        );
        // Don't fail the upload if statistics update fails
      }
    } catch (e) {
      debugPrint('❌ HYBRID: Upload failed for ${file.fileName}: $e');
      file.status = UploadStatus.failed;
      file.errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  /// Update file progress with batched UI updates
  /// FEATURE PARITY: Same progress tracking mechanism
  void _updateFileProgress(String fileId, double progress) {
    _lastProgressUpdate[fileId] = progress;

    // Batch UI updates to prevent excessive rebuilds
    _uiUpdateTimer?.cancel();
    _uiUpdateTimer = Timer(const Duration(milliseconds: 100), () {
      _progressControllers[fileId]?.add(progress);
      notifyListeners();
    });
  }

  /// Get progress stream for specific file
  /// FEATURE PARITY: Same progress streaming
  Stream<double> getProgressStream(String fileId) {
    return _progressControllers[fileId]?.stream ??
        Stream.value(_lastProgressUpdate[fileId] ?? 0.0);
  }

  /// Remove file from queue
  /// FEATURE PARITY: Same file removal logic
  void removeFile(String fileId) {
    _uploadQueue.removeWhere((file) => file.id == fileId);
    _progressControllers[fileId]?.close();
    _progressControllers.remove(fileId);
    _lastProgressUpdate.remove(fileId);
    notifyListeners();
    debugPrint('🗑️ HYBRID: Removed file $fileId from queue');
  }

  /// Clear completed files
  /// FEATURE PARITY: Same cleanup logic
  void clearCompletedFiles() {
    final completedFileIds = _uploadQueue
        .where((file) => file.status == UploadStatus.completed)
        .map((file) => file.id)
        .toList();

    for (final fileId in completedFileIds) {
      removeFile(fileId);
    }
    debugPrint('🧹 HYBRID: Cleared ${completedFileIds.length} completed files');
  }

  /// Clear all files
  /// FEATURE PARITY: Same clear all logic
  void clearAllFiles() {
    final fileIds = _uploadQueue.map((file) => file.id).toList();
    for (final fileId in fileIds) {
      _progressControllers[fileId]?.close();
    }

    _uploadQueue.clear();
    _progressControllers.clear();
    _lastProgressUpdate.clear();
    notifyListeners();
    debugPrint('🧹 HYBRID: Cleared all files from queue');
  }

  /// Clear all files and reset state (FEATURE PARITY with ConsolidatedUploadProvider)
  void clearAllAndReset() {
    clearAllFiles();
    _isUploading = false;
    debugPrint('🔄 HYBRID: Reset upload state');
  }

  /// Clear completed files (alias for clearCompletedFiles)
  /// FEATURE PARITY: Same method name as ConsolidatedUploadProvider
  void clearCompleted() {
    clearCompletedFiles();
  }

  /// Retry failed uploads (alias for retryFailedUploads)
  /// FEATURE PARITY: Same method name as ConsolidatedUploadProvider
  Future<void> retryFailed() async {
    await retryFailedUploads();
  }

  /// Clear all files (alias for clearAllFiles)
  /// FEATURE PARITY: Same method name as ConsolidatedUploadProvider
  void clearAll() {
    clearAllFiles();
  }

  /// Retry failed uploads
  /// FEATURE PARITY: Same retry mechanism
  Future<void> retryFailedUploads() async {
    final failedFiles = _uploadQueue
        .where((file) => file.status == UploadStatus.failed)
        .toList();

    if (failedFiles.isEmpty) {
      debugPrint('ℹ️ HYBRID: No failed files to retry');
      return;
    }

    debugPrint('🔄 HYBRID: Retrying ${failedFiles.length} failed uploads');

    // Reset failed files to pending
    for (final file in failedFiles) {
      file.status = UploadStatus.pending;
      file.errorMessage = null;
    }

    notifyListeners();

    // Start upload process
    await startUpload();
  }

  /// Pause upload process
  /// FEATURE PARITY: Same pause logic
  void pauseUpload() {
    _isUploading = false;

    // Update uploading files to pending
    for (final file in _uploadQueue) {
      if (file.status == UploadStatus.uploading) {
        file.status = UploadStatus.pending;
      }
    }

    notifyListeners();
    debugPrint('⏸️ HYBRID: Upload process paused');
  }

  /// Resume upload process
  /// FEATURE PARITY: Same resume logic
  Future<void> resumeUpload() async {
    if (_isUploading) {
      debugPrint('⚠️ HYBRID: Upload already in progress');
      return;
    }

    debugPrint('▶️ HYBRID: Resuming upload process');
    await startUpload();
  }

  /// Check Cloud Functions availability
  /// FEATURE PARITY: Same CF availability check
  Future<void> checkCloudFunctionsAvailability() async {
    try {
      await CloudFunctionsConfig.initialize();
      _cloudFunctionsAvailable = CloudFunctionsConfig.isAvailable;
      debugPrint(
        '🔧 HYBRID: Cloud Functions available: $_cloudFunctionsAvailable',
      );
    } catch (e) {
      _cloudFunctionsAvailable = false;
      debugPrint('❌ HYBRID: Cloud Functions check failed: $e');
    }
    notifyListeners();
  }

  /// Toggle Cloud Functions usage
  /// FEATURE PARITY: Same CF toggle
  void toggleCloudFunctions(bool enabled) {
    _useCloudFunctions = enabled;
    debugPrint('🔧 HYBRID: Cloud Functions usage: $enabled');
    notifyListeners();
  }

  /// Perform memory cleanup
  /// FEATURE PARITY: Same memory management
  void _performMemoryCleanup() {
    // Close completed progress controllers
    final completedFiles = _uploadQueue
        .where((file) => file.status == UploadStatus.completed)
        .toList();

    for (final file in completedFiles) {
      _progressControllers[file.id]?.close();
      _progressControllers.remove(file.id);
    }

    // Cancel UI update timer
    _uiUpdateTimer?.cancel();
    _uiUpdateTimer = null;

    debugPrint('🧹 HYBRID: Memory cleanup completed');
  }

  /// Get upload statistics
  /// FEATURE PARITY: Same statistics
  Map<String, dynamic> getUploadStatistics() {
    return {
      'totalFiles': totalFiles,
      'completedFiles': completedFiles,
      'failedFiles': failedFiles,
      'pendingFiles': pendingFiles,
      'uploadingFiles': uploadingFiles,
      'overallProgress': overallProgress,
      'isUploading': isUploading,
      'cloudFunctionsAvailable': _cloudFunctionsAvailable,
      'useCloudFunctions': _useCloudFunctions,
    };
  }

  /// Dispose resources
  /// FEATURE PARITY: Same disposal logic
  @override
  void dispose() {
    _uiUpdateTimer?.cancel();

    for (final controller in _progressControllers.values) {
      controller.close();
    }

    _progressControllers.clear();
    _lastProgressUpdate.clear();

    super.dispose();
    debugPrint('🧹 HYBRID: HybridUploadProvider disposed');
  }
}
