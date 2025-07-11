import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cross_file/cross_file.dart';

import '../../../services/hybrid_upload_service.dart';
import '../../../models/upload_file_model.dart' as legacy;
import '../../../models/upload_result_model.dart';
import '../models/upload_file_model.dart';
import 'upload_repository.dart';

/// Upload Repository Implementation
///
/// This implementation provides upload functionality using the HybridUploadService.
/// It manages upload queues, progress tracking, and file upload operations.
class UploadRepositoryImpl implements UploadRepository {
  static final UploadRepositoryImpl _instance =
      UploadRepositoryImpl._internal();
  factory UploadRepositoryImpl() => _instance;
  UploadRepositoryImpl._internal();

  static UploadRepositoryImpl get instance => _instance;

  final HybridUploadService _uploadService = HybridUploadService();
  final List<UploadFileModel> _uploadQueue = [];
  final Map<String, StreamController<double>> _progressControllers = {};
  final Map<String, StreamController<UploadStatus>> _statusControllers = {};
  final StreamController<double> _overallProgressController =
      StreamController<double>.broadcast();

  bool _isUploading = false;
  int _maxConcurrentUploads = 3;
  int _chunkSize = 1024 * 1024; // 1MB
  int _retryAttempts = 3;

  @override
  Future<List<UploadFileModel>> addFilesToQueue(
    List<XFile> files, {
    String? categoryId,
    Map<String, String>? customMetadata,
    bool checkDuplicates = true,
  }) async {
    try {
      debugPrint('📁 UploadRepository: Adding ${files.length} files to queue');

      // Validate files first
      final validationErrors = await validateFiles(files);
      if (validationErrors.isNotEmpty) {
        throw Exception(
          'File validation failed: ${validationErrors.join(', ')}',
        );
      }

      final uploadFiles = <UploadFileModel>[];

      for (final file in files) {
        final uploadFile = await UploadFileModel.fromXFile(
          file,
          categoryId: categoryId,
          customMetadata: customMetadata,
        );

        // Create progress and status controllers
        _progressControllers[uploadFile.id] =
            StreamController<double>.broadcast();
        _statusControllers[uploadFile.id] =
            StreamController<UploadStatus>.broadcast();

        _uploadQueue.add(uploadFile);
        uploadFiles.add(uploadFile);

        debugPrint(
          '✅ UploadRepository: Added file ${uploadFile.fileName} to queue',
        );
      }

      // Check for duplicates if enabled
      if (checkDuplicates) {
        final duplicates = await checkForDuplicates(uploadFiles);
        if (duplicates.isNotEmpty) {
          // Remove duplicates from queue
          for (final file in uploadFiles) {
            _uploadQueue.removeWhere((f) => f.id == file.id);
            _progressControllers[file.id]?.close();
            _statusControllers[file.id]?.close();
            _progressControllers.remove(file.id);
            _statusControllers.remove(file.id);
          }

          final duplicateNames = duplicates
              .map((d) => d['fileName'])
              .join(', ');
          throw Exception('Duplicate files detected: $duplicateNames');
        }
      }

      return uploadFiles;
    } catch (e) {
      debugPrint('❌ UploadRepository: Error adding files to queue: $e');
      rethrow;
    }
  }

  @override
  Future<void> startUpload() async {
    if (_isUploading) {
      debugPrint('⚠️ UploadRepository: Upload already in progress');
      return;
    }

    if (_uploadQueue.isEmpty) {
      debugPrint('⚠️ UploadRepository: No files in queue to upload');
      return;
    }

    _isUploading = true;
    debugPrint('🚀 UploadRepository: Starting upload process');

    try {
      // Get pending files
      final pendingFiles = _uploadQueue
          .where(
            (file) =>
                file.status == UploadStatus.pending ||
                file.status == UploadStatus.paused,
          )
          .toList();

      if (pendingFiles.isEmpty) {
        debugPrint('✅ UploadRepository: No pending files to upload');
        return;
      }

      // Process files in concurrent batches
      await _processConcurrentUploads(pendingFiles);

      debugPrint('✅ UploadRepository: Upload process completed');
    } catch (e) {
      debugPrint('❌ UploadRepository: Upload process failed: $e');
      rethrow;
    } finally {
      _isUploading = false;
    }
  }

  @override
  Future<void> pauseUpload(String fileId) async {
    final fileIndex = _uploadQueue.indexWhere((f) => f.id == fileId);
    if (fileIndex == -1) return;

    final file = _uploadQueue[fileIndex];
    if (file.status == UploadStatus.uploading) {
      final updatedFile = file.copyWith(status: UploadStatus.paused);
      _uploadQueue[fileIndex] = updatedFile;
      _statusControllers[fileId]?.add(UploadStatus.paused);

      debugPrint('⏸️ UploadRepository: Paused upload for ${file.fileName}');
    }
  }

  @override
  Future<void> resumeUpload(String fileId) async {
    final fileIndex = _uploadQueue.indexWhere((f) => f.id == fileId);
    if (fileIndex == -1) return;

    final file = _uploadQueue[fileIndex];
    if (file.status == UploadStatus.paused) {
      final updatedFile = file.copyWith(status: UploadStatus.pending);
      _uploadQueue[fileIndex] = updatedFile;
      _statusControllers[fileId]?.add(UploadStatus.pending);

      debugPrint('▶️ UploadRepository: Resumed upload for ${file.fileName}');

      // Restart upload process if not already running
      if (!_isUploading) {
        startUpload();
      }
    }
  }

  @override
  Future<void> cancelUpload(String fileId) async {
    final fileIndex = _uploadQueue.indexWhere((f) => f.id == fileId);
    if (fileIndex == -1) return;

    final file = _uploadQueue[fileIndex];
    final updatedFile = file.copyWith(status: UploadStatus.cancelled);
    _uploadQueue[fileIndex] = updatedFile;
    _statusControllers[fileId]?.add(UploadStatus.cancelled);

    debugPrint('❌ UploadRepository: Cancelled upload for ${file.fileName}');
  }

  @override
  Future<void> retryUpload(String fileId) async {
    final fileIndex = _uploadQueue.indexWhere((f) => f.id == fileId);
    if (fileIndex == -1) return;

    final file = _uploadQueue[fileIndex];
    if (file.status == UploadStatus.failed) {
      final updatedFile = file.copyWith(
        status: UploadStatus.pending,
        progress: 0.0,
        retryAttempts: file.retryAttempts + 1,
        errorMessage: null,
      );
      _uploadQueue[fileIndex] = updatedFile;
      _statusControllers[fileId]?.add(UploadStatus.pending);
      _progressControllers[fileId]?.add(0.0);

      debugPrint('🔄 UploadRepository: Retrying upload for ${file.fileName}');

      // Restart upload process if not already running
      if (!_isUploading) {
        startUpload();
      }
    }
  }

  @override
  Future<void> removeFromQueue(String fileId) async {
    final fileIndex = _uploadQueue.indexWhere((f) => f.id == fileId);
    if (fileIndex == -1) return;

    final file = _uploadQueue[fileIndex];
    _uploadQueue.removeAt(fileIndex);

    // Clean up controllers
    _progressControllers[fileId]?.close();
    _statusControllers[fileId]?.close();
    _progressControllers.remove(fileId);
    _statusControllers.remove(fileId);

    debugPrint('🗑️ UploadRepository: Removed ${file.fileName} from queue');
  }

  @override
  Future<void> clearQueue() async {
    // Close all controllers
    for (final controller in _progressControllers.values) {
      controller.close();
    }
    for (final controller in _statusControllers.values) {
      controller.close();
    }

    _progressControllers.clear();
    _statusControllers.clear();
    _uploadQueue.clear();

    debugPrint('🧹 UploadRepository: Cleared upload queue');
  }

  @override
  List<UploadFileModel> getUploadQueue() {
    return List.unmodifiable(_uploadQueue);
  }

  @override
  Stream<double> getUploadProgress(String fileId) {
    if (!_progressControllers.containsKey(fileId)) {
      _progressControllers[fileId] = StreamController<double>.broadcast();
    }
    return _progressControllers[fileId]!.stream;
  }

  @override
  Stream<double> getOverallProgress() {
    return _overallProgressController.stream;
  }

  @override
  Stream<UploadStatus> getUploadStatus(String fileId) {
    if (!_statusControllers.containsKey(fileId)) {
      _statusControllers[fileId] = StreamController<UploadStatus>.broadcast();
    }
    return _statusControllers[fileId]!.stream;
  }

  @override
  bool get isUploading => _isUploading;

  @override
  Map<String, dynamic> getUploadStatistics() {
    final total = _uploadQueue.length;
    final completed = _uploadQueue
        .where((f) => f.status == UploadStatus.completed)
        .length;
    final failed = _uploadQueue
        .where((f) => f.status == UploadStatus.failed)
        .length;
    final pending = _uploadQueue
        .where((f) => f.status == UploadStatus.pending)
        .length;
    final uploading = _uploadQueue
        .where((f) => f.status == UploadStatus.uploading)
        .length;

    return {
      'total': total,
      'completed': completed,
      'failed': failed,
      'pending': pending,
      'uploading': uploading,
      'success_rate': total > 0
          ? (completed / total * 100).toStringAsFixed(1)
          : '0.0',
    };
  }

  @override
  Future<List<String>> validateFiles(List<XFile> files) async {
    final errors = <String>[];

    for (final file in files) {
      try {
        // Check file size
        final fileSize = await file.length();
        if (fileSize > 100 * 1024 * 1024) {
          // 100MB limit
          errors.add('${file.name}: File size exceeds 100MB limit');
          continue;
        }

        if (fileSize == 0) {
          errors.add('${file.name}: File is empty');
          continue;
        }

        // Check file extension
        final fileName = file.name.toLowerCase();
        final allowedExtensions = [
          '.pdf',
          '.doc',
          '.docx',
          '.txt',
          '.rtf',
          '.jpg',
          '.jpeg',
          '.png',
          '.gif',
          '.bmp',
          '.mp4',
          '.avi',
          '.mov',
          '.wmv',
          '.flv',
          '.mp3',
          '.wav',
          '.aac',
          '.flac',
          '.zip',
          '.rar',
          '.7z',
          '.xls',
          '.xlsx',
          '.ppt',
          '.pptx',
        ];

        final hasValidExtension = allowedExtensions.any(
          (ext) => fileName.endsWith(ext),
        );

        if (!hasValidExtension) {
          errors.add('${file.name}: Unsupported file type');
          continue;
        }

        // Check if file exists and is readable
        if (file.path.isNotEmpty) {
          final fileExists = await File(file.path).exists();
          if (!fileExists) {
            errors.add('${file.name}: File not found');
            continue;
          }
        }
      } catch (e) {
        errors.add('${file.name}: Validation error - $e');
      }
    }

    return errors;
  }

  @override
  Future<List<Map<String, dynamic>>> checkForDuplicates(
    List<UploadFileModel> files,
  ) async {
    final duplicates = <Map<String, dynamic>>[];

    try {
      // Convert to legacy format for duplicate checking
      final legacyFiles = <legacy.UploadFileModel>[];
      for (final file in files) {
        final legacyFile = legacy.UploadFileModel(
          id: file.id,
          fileName: file.fileName,
          fileSize: file.fileSize,
          fileType: file.fileType,
          file: file.file!,
          categoryId: file.categoryId,
          customMetadata: file.customMetadata,
        );
        legacyFiles.add(legacyFile);
      }

      // Use existing duplicate check logic from HybridUploadProvider
      // This is a simplified version - in real implementation,
      // you would call the actual duplicate check service
      for (final file in files) {
        // Simulate duplicate check
        // In real implementation, this would query Firestore
        final isDuplicate = false; // Placeholder

        if (isDuplicate) {
          duplicates.add({
            'fileName': file.fileName,
            'fileSize': file.fileSize,
            'existingId': 'existing_document_id',
          });
        }
      }
    } catch (e) {
      debugPrint('❌ UploadRepository: Error checking duplicates: $e');
      // Don't throw error for duplicate check failure
      // Let upload proceed
    }

    return duplicates;
  }

  @override
  void updateSettings({
    int? maxConcurrentUploads,
    int? chunkSize,
    int? retryAttempts,
  }) {
    if (maxConcurrentUploads != null) {
      _maxConcurrentUploads = maxConcurrentUploads;
    }
    if (chunkSize != null) {
      _chunkSize = chunkSize;
    }
    if (retryAttempts != null) {
      _retryAttempts = retryAttempts;
    }

    debugPrint(
      '⚙️ UploadRepository: Updated settings - '
      'maxConcurrent: $_maxConcurrentUploads, '
      'chunkSize: $_chunkSize, '
      'retryAttempts: $_retryAttempts',
    );
  }

  @override
  void dispose() {
    // Close all controllers
    for (final controller in _progressControllers.values) {
      controller.close();
    }
    for (final controller in _statusControllers.values) {
      controller.close();
    }
    _overallProgressController.close();

    _progressControllers.clear();
    _statusControllers.clear();
    _uploadQueue.clear();

    debugPrint('🧹 UploadRepository: Disposed resources');
  }

  /// Process concurrent uploads
  Future<void> _processConcurrentUploads(List<UploadFileModel> files) async {
    final futures = <Future>[];
    final semaphore = Semaphore(_maxConcurrentUploads);

    for (final file in files) {
      if (file.status == UploadStatus.cancelled) continue;

      final future = semaphore.acquire().then((_) async {
        try {
          await _uploadSingleFile(file);
        } finally {
          semaphore.release();
        }
      });

      futures.add(future);
    }

    await Future.wait(futures);
    _updateOverallProgress();
  }

  /// Upload single file
  Future<void> _uploadSingleFile(UploadFileModel file) async {
    try {
      final fileIndex = _uploadQueue.indexWhere((f) => f.id == file.id);
      if (fileIndex == -1) return;

      // Update status to uploading
      _uploadQueue[fileIndex] = file.copyWith(
        status: UploadStatus.uploading,
        startTime: DateTime.now(),
      );
      _statusControllers[file.id]?.add(UploadStatus.uploading);

      // Convert to legacy format for upload service
      final legacyFile = legacy.UploadFileModel(
        id: file.id,
        fileName: file.fileName,
        fileSize: file.fileSize,
        fileType: file.fileType,
        file: file.file!,
        categoryId: file.categoryId,
        customMetadata: file.customMetadata,
      );

      // Upload using HybridUploadService
      final result = await _uploadService.uploadFile(
        legacyFile,
        onProgress: (progress) {
          _progressControllers[file.id]?.add(progress);

          // Update file progress
          final currentFileIndex = _uploadQueue.indexWhere(
            (f) => f.id == file.id,
          );
          if (currentFileIndex != -1) {
            _uploadQueue[currentFileIndex] = _uploadQueue[currentFileIndex]
                .copyWith(
                  progress: progress,
                  bytesUploaded: (file.fileSize * progress).round(),
                );
          }

          _updateOverallProgress();
        },
        categoryId: file.categoryId,
        customMetadata: file.customMetadata,
      );

      // Update file status based on result
      final currentFileIndex = _uploadQueue.indexWhere((f) => f.id == file.id);
      if (currentFileIndex != -1) {
        if (result['success'] == true) {
          _uploadQueue[currentFileIndex] = _uploadQueue[currentFileIndex]
              .copyWith(
                status: UploadStatus.completed,
                progress: 1.0,
                bytesUploaded: file.fileSize,
                downloadUrl: result['downloadUrl'],
                documentId: result['documentId'],
                completionTime: DateTime.now(),
              );
          _statusControllers[file.id]?.add(UploadStatus.completed);
          _progressControllers[file.id]?.add(1.0);
        } else {
          throw Exception(result['message'] ?? 'Upload failed');
        }
      }
    } catch (e) {
      debugPrint('❌ UploadRepository: Upload failed for ${file.fileName}: $e');

      final fileIndex = _uploadQueue.indexWhere((f) => f.id == file.id);
      if (fileIndex != -1) {
        _uploadQueue[fileIndex] = _uploadQueue[fileIndex].copyWith(
          status: UploadStatus.failed,
          errorMessage: e.toString(),
          completionTime: DateTime.now(),
        );
        _statusControllers[file.id]?.add(UploadStatus.failed);
      }
    }
  }

  /// Update overall progress
  void _updateOverallProgress() {
    if (_uploadQueue.isEmpty) {
      _overallProgressController.add(0.0);
      return;
    }

    final totalProgress = _uploadQueue.fold<double>(
      0.0,
      (sum, file) => sum + file.progress,
    );

    final overallProgress = totalProgress / _uploadQueue.length;
    _overallProgressController.add(overallProgress);
  }

  /// Update file status in queue and notify listeners
  void _updateFileStatus(String fileId, UploadStatus status) {
    final fileIndex = _uploadQueue.indexWhere((f) => f.id == fileId);
    if (fileIndex != -1) {
      final file = _uploadQueue[fileIndex];
      final updatedFile = file.copyWith(status: status);
      _uploadQueue[fileIndex] = updatedFile;
      _statusControllers[fileId]?.add(status);
    }
  }

  /// Update file progress in queue and notify listeners
  void _updateProgress(String fileId, double progress) {
    final fileIndex = _uploadQueue.indexWhere((f) => f.id == fileId);
    if (fileIndex != -1) {
      final file = _uploadQueue[fileIndex];
      final updatedFile = file.copyWith(progress: progress);
      _uploadQueue[fileIndex] = updatedFile;
      _progressControllers[fileId]?.add(progress);
      _updateOverallProgress();
    }
  }

  @override
  Future<List<UploadResult>> uploadFiles(List<UploadFileModel> files) async {
    try {
      debugPrint(
        '📤 UploadRepository: Starting upload for ${files.length} files',
      );

      final results = <UploadResult>[];

      for (final file in files) {
        try {
          // Update status to uploading
          _updateFileStatus(file.id, UploadStatus.uploading);

          // Convert to legacy format for upload service
          final legacyFile = legacy.UploadFileModel(
            id: file.id,
            fileName: file.fileName,
            fileSize: file.fileSize,
            fileType: file.fileType,
            file: file.file!,
            categoryId: file.categoryId,
            customMetadata: file.customMetadata,
          );

          // Perform upload using hybrid service
          final result = await _uploadService.uploadFile(
            legacyFile,
            onProgress: (progress) {
              _updateProgress(file.id, progress);
            },
            categoryId: file.categoryId,
            customMetadata: file.customMetadata,
          );

          if (result['success'] == true) {
            results.add(
              UploadResult.success(
                fileId: file.id,
                fileName: file.fileName,
                downloadUrl: result['downloadUrl'],
                fileSize: file.fileSize,
                category: file.categoryId,
              ),
            );
            _updateFileStatus(file.id, UploadStatus.completed);
          } else {
            results.add(
              UploadResult.failure(
                fileId: file.id,
                fileName: file.fileName,
                error: result['error'] ?? 'Upload failed',
              ),
            );
            _updateFileStatus(file.id, UploadStatus.failed);
          }
        } catch (e) {
          results.add(
            UploadResult.failure(
              fileId: file.id,
              fileName: file.fileName,
              error: e.toString(),
            ),
          );
          _updateFileStatus(file.id, UploadStatus.failed);
        }
      }

      return results;
    } catch (e) {
      debugPrint('❌ UploadRepository: Error uploading files: $e');
      rethrow;
    }
  }

  @override
  Future<List<UploadResult>> uploadFilesWithProgress(
    List<UploadFileModel> files,
  ) async {
    try {
      debugPrint(
        '📤 UploadRepository: Starting upload with progress for ${files.length} files',
      );

      final results = <UploadResult>[];

      for (final file in files) {
        try {
          // Update status to uploading
          _updateFileStatus(file.id, UploadStatus.uploading);

          // Convert to legacy format for upload service
          final legacyFile = legacy.UploadFileModel(
            id: file.id,
            fileName: file.fileName,
            fileSize: file.fileSize,
            fileType: file.fileType,
            file: file.file!,
            categoryId: file.categoryId,
            customMetadata: file.customMetadata,
          );

          // Perform upload with progress tracking
          final result = await _uploadService.uploadFile(
            legacyFile,
            onProgress: (progress) {
              _updateProgress(file.id, progress);
            },
            categoryId: file.categoryId,
            customMetadata: file.customMetadata,
          );

          if (result['success'] == true) {
            results.add(
              UploadResult.success(
                fileId: file.id,
                fileName: file.fileName,
                downloadUrl: result['downloadUrl'],
                fileSize: file.fileSize,
                category: file.categoryId,
              ),
            );
            _updateFileStatus(file.id, UploadStatus.completed);
          } else {
            results.add(
              UploadResult.failure(
                fileId: file.id,
                fileName: file.fileName,
                error: result['error'] ?? 'Upload failed',
              ),
            );
            _updateFileStatus(file.id, UploadStatus.failed);
          }
        } catch (e) {
          results.add(
            UploadResult.failure(
              fileId: file.id,
              fileName: file.fileName,
              error: e.toString(),
            ),
          );
          _updateFileStatus(file.id, UploadStatus.failed);
        }
      }

      return results;
    } catch (e) {
      debugPrint('❌ UploadRepository: Error uploading files with progress: $e');
      rethrow;
    }
  }

  @override
  Future<List<UploadResult>> retryFailedUploads(
    List<UploadFileModel> failedFiles,
  ) async {
    try {
      debugPrint(
        '🔄 UploadRepository: Retrying ${failedFiles.length} failed uploads',
      );

      // Reset status for failed files
      for (final file in failedFiles) {
        _updateFileStatus(file.id, UploadStatus.pending);
      }

      // Use uploadFiles method to retry
      return await uploadFiles(failedFiles);
    } catch (e) {
      debugPrint('❌ UploadRepository: Error retrying failed uploads: $e');
      rethrow;
    }
  }
}

/// Simple semaphore implementation for controlling concurrent uploads
class Semaphore {
  final int maxCount;
  int _currentCount;
  final Queue<Completer<void>> _waitQueue = Queue<Completer<void>>();

  Semaphore(this.maxCount) : _currentCount = maxCount;

  Future<void> acquire() async {
    if (_currentCount > 0) {
      _currentCount--;
      return;
    }

    final completer = Completer<void>();
    _waitQueue.add(completer);
    return completer.future;
  }

  void release() {
    if (_waitQueue.isNotEmpty) {
      final completer = _waitQueue.removeFirst();
      completer.complete();
    } else {
      _currentCount++;
    }
  }
}
