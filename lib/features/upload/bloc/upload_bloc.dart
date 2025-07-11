import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/upload_file_model.dart';
import '../repositories/upload_repository.dart';
import '../repositories/upload_repository_impl.dart';
import 'upload_event.dart' as events;
import 'upload_state.dart' as states;

/// Upload BLoC
///
/// This BLoC manages all upload-related business logic and state.
/// It replaces the HybridUploadProvider with a more structured approach.
///
/// Features:
/// - File upload queue management
/// - Progress tracking per file and overall
/// - Pause/Resume functionality
/// - Error handling and retry logic
/// - Concurrent upload management
/// - File validation
/// - Duplicate detection
/// - Upload statistics
class UploadBloc extends Bloc<events.UploadEvent, states.UploadState> {
  final UploadRepository _repository;

  // Stream subscriptions for real-time updates
  final Map<String, StreamSubscription<double>> _progressSubscriptions = {};
  final Map<String, StreamSubscription<UploadStatus>> _statusSubscriptions = {};
  StreamSubscription<double>? _overallProgressSubscription;

  // Current upload settings
  int _maxConcurrentUploads = 3;
  int _chunkSize = 1024 * 1024; // 1MB
  int _retryAttempts = 3;

  UploadBloc({UploadRepository? repository})
    : _repository = repository ?? UploadRepositoryImpl.instance,
      super(const states.UploadState.initial()) {
    // Register event handlers
    on<events.AddFiles>(_onAddFiles);
    on<events.StartUpload>(_onStartUpload);
    on<events.PauseUpload>(_onPauseUpload);
    on<events.ResumeUpload>(_onResumeUpload);
    on<events.CancelUpload>(_onCancelUpload);
    on<events.RetryUpload>(_onRetryUpload);
    on<events.RemoveFile>(_onRemoveFromQueue);
    on<events.ClearQueue>(_onClearQueue);
    on<events.UpdateProgress>(_onUpdateProgress);
    on<events.FileCompleted>(_onFileCompleted);
    on<events.FileFailed>(_onFileFailed);
    on<events.UpdateSettings>(_onUpdateSettings);
    on<events.ValidateFiles>(_onValidateFiles);
    on<events.ResetState>(_onResetState);
    on<events.SetCategory>(_onSetCategory);
    on<events.SetMetadata>(_onSetMetadata);
    on<events.ProcessQueue>(_onProcessQueue);
    on<events.UploadCompleted>(_onUploadCompleted);
    on<events.UploadError>(_onUploadError);

    // Additional event handlers for missing events
    on<events.OverallProgressUpdated>(_onOverallProgressUpdated);
    on<events.FileProgressUpdated>(_onFileProgressUpdated);
    on<events.FileStatusUpdated>(_onFileStatusUpdated);

    // Start listening to overall progress
    _startListeningToOverallProgress();
  }

  /// Add files to upload queue
  Future<void> _onAddFiles(
    events.AddFiles event,
    Emitter<states.UploadState> emit,
  ) async {
    try {
      emit(const states.UploadState.validating(message: 'Validating files...'));

      // Validate files first
      final validationErrors = await _repository.validateFiles(event.files);
      if (validationErrors.isNotEmpty) {
        emit(
          states.UploadState.error(
            message: 'File validation failed: ${validationErrors.join(', ')}',
            canRetry: false,
          ),
        );
        return;
      }

      // Add files to repository queue
      final uploadFiles = await _repository.addFilesToQueue(
        event.files,
        categoryId: event.categoryId,
        customMetadata: event.customMetadata,
        checkDuplicates: event.checkDuplicates,
      );

      // Start listening to progress for each file
      for (final file in uploadFiles) {
        _startListeningToFileProgress(file.id);
        _startListeningToFileStatus(file.id);
      }

      final currentQueue = _repository.getUploadQueue();

      emit(
        states.UploadState.ready(
          files: currentQueue,
          totalFiles: currentQueue.length,
          totalSize: currentQueue.fold(0, (sum, file) => sum + file.fileSize),
        ),
      );

      debugPrint('📁 UploadBloc: Added ${uploadFiles.length} files to queue');
    } catch (e) {
      emit(
        states.UploadState.error(
          message: 'Failed to add files to queue: ${e.toString()}',
          canRetry: true,
        ),
      );
      debugPrint('❌ UploadBloc: Error adding files: $e');
    }
  }

  /// Start upload process
  Future<void> _onStartUpload(
    events.StartUpload event,
    Emitter<states.UploadState> emit,
  ) async {
    try {
      final currentQueue = _repository.getUploadQueue();
      if (currentQueue.isEmpty) {
        emit(
          const states.UploadState.error(
            message: 'No files in queue to upload',
            canRetry: false,
          ),
        );
        return;
      }

      emit(
        states.UploadState.uploading(
          files: currentQueue,
          activeUploads: currentQueue
              .where((f) => f.status == UploadStatus.uploading)
              .length,
          completedFiles: currentQueue
              .where((f) => f.status == UploadStatus.completed)
              .length,
          failedFiles: currentQueue
              .where((f) => f.status == UploadStatus.failed)
              .length,
          totalFiles: currentQueue.length,
          overallProgress: 0.0,
        ),
      );

      await _repository.startUpload();

      debugPrint('🚀 UploadBloc: Upload process started');
    } catch (e) {
      emit(
        states.UploadState.error(
          message: 'Failed to start upload: ${e.toString()}',
          canRetry: true,
        ),
      );
      debugPrint('❌ UploadBloc: Error starting upload: $e');
    }
  }

  /// Pause upload for specific file
  Future<void> _onPauseUpload(
    events.PauseUpload event,
    Emitter<states.UploadState> emit,
  ) async {
    try {
      if (event.fileId != null) {
        await _repository.pauseUpload(event.fileId!);
      } else {
        // Pause all uploads - implement if needed
        debugPrint('⏸️ UploadBloc: Pause all uploads not implemented');
        return;
      }

      final currentQueue = _repository.getUploadQueue();

      emit(
        states.UploadState.paused(
          files: currentQueue,
          completedFiles: currentQueue
              .where((f) => f.status == UploadStatus.completed)
              .length,
          failedFiles: currentQueue
              .where((f) => f.status == UploadStatus.failed)
              .length,
          totalFiles: currentQueue.length,
          overallProgress: _calculateOverallProgress(currentQueue),
          pausedFiles: currentQueue
              .where((f) => f.status == UploadStatus.paused)
              .length,
        ),
      );

      debugPrint('⏸️ UploadBloc: Paused upload for file ${event.fileId}');
    } catch (e) {
      debugPrint('❌ UploadBloc: Error pausing upload: $e');
    }
  }

  /// Resume upload for specific file
  Future<void> _onResumeUpload(
    events.ResumeUpload event,
    Emitter<states.UploadState> emit,
  ) async {
    try {
      if (event.fileId != null) {
        await _repository.resumeUpload(event.fileId!);
      } else {
        // Resume all uploads - implement if needed
        debugPrint('▶️ UploadBloc: Resume all uploads not implemented');
        return;
      }

      final currentQueue = _repository.getUploadQueue();

      emit(
        states.UploadState.uploading(
          files: currentQueue,
          activeUploads: currentQueue
              .where((f) => f.status == UploadStatus.uploading)
              .length,
          completedFiles: currentQueue
              .where((f) => f.status == UploadStatus.completed)
              .length,
          failedFiles: currentQueue
              .where((f) => f.status == UploadStatus.failed)
              .length,
          totalFiles: currentQueue.length,
          overallProgress: _calculateOverallProgress(currentQueue),
        ),
      );

      debugPrint('▶️ UploadBloc: Resumed upload for file ${event.fileId}');
    } catch (e) {
      debugPrint('❌ UploadBloc: Error resuming upload: $e');
    }
  }

  /// Cancel upload for specific file
  Future<void> _onCancelUpload(
    events.CancelUpload event,
    Emitter<states.UploadState> emit,
  ) async {
    try {
      if (event.fileId != null) {
        await _repository.cancelUpload(event.fileId!);
        // Stop listening to this file's progress
        _stopListeningToFile(event.fileId!);
      } else {
        // Cancel all uploads - implement if needed
        debugPrint('❌ UploadBloc: Cancel all uploads not implemented');
        return;
      }

      final currentQueue = _repository.getUploadQueue();

      emit(
        states.UploadState.cancelled(
          files: currentQueue,
          completedFiles: currentQueue
              .where((f) => f.status == UploadStatus.completed)
              .length,
          cancelledFiles: currentQueue
              .where((f) => f.status == UploadStatus.cancelled)
              .length,
        ),
      );

      debugPrint('❌ UploadBloc: Cancelled upload for file ${event.fileId}');
    } catch (e) {
      debugPrint('❌ UploadBloc: Error cancelling upload: $e');
    }
  }

  /// Retry failed upload
  Future<void> _onRetryUpload(
    events.RetryUpload event,
    Emitter<states.UploadState> emit,
  ) async {
    try {
      final currentQueue = _repository.getUploadQueue();

      emit(
        states.UploadState.uploading(
          files: currentQueue,
          activeUploads: currentQueue
              .where((f) => f.status == UploadStatus.uploading)
              .length,
          completedFiles: currentQueue
              .where((f) => f.status == UploadStatus.completed)
              .length,
          failedFiles: currentQueue
              .where((f) => f.status == UploadStatus.failed)
              .length,
          totalFiles: currentQueue.length,
          overallProgress: _calculateOverallProgress(currentQueue),
        ),
      );

      debugPrint(
        '🔄 UploadBloc: Retrying upload for ${event.failedFiles.length} failed files',
      );
    } catch (e) {
      debugPrint('❌ UploadBloc: Error retrying upload: $e');
    }
  }

  /// Remove file from queue
  Future<void> _onRemoveFromQueue(
    events.RemoveFile event,
    Emitter<states.UploadState> emit,
  ) async {
    try {
      await _repository.removeFromQueue(event.fileId);

      // Stop listening to this file's progress
      _stopListeningToFile(event.fileId);

      final currentQueue = _repository.getUploadQueue();

      if (currentQueue.isEmpty) {
        emit(const states.UploadState.initial());
      } else {
        emit(
          states.UploadState.ready(
            files: currentQueue,
            totalFiles: currentQueue.length,
            totalSize: currentQueue.fold(0, (sum, file) => sum + file.fileSize),
          ),
        );
      }

      debugPrint('🗑️ UploadBloc: Removed file ${event.fileId} from queue');
    } catch (e) {
      debugPrint('❌ UploadBloc: Error removing file from queue: $e');
    }
  }

  /// Clear upload queue
  Future<void> _onClearQueue(
    events.ClearQueue event,
    Emitter<states.UploadState> emit,
  ) async {
    try {
      await _repository.clearQueue();

      // Stop all progress listeners
      _stopAllListeners();

      emit(const states.UploadState.initial());

      debugPrint('🧹 UploadBloc: Cleared upload queue');
    } catch (e) {
      debugPrint('❌ UploadBloc: Error clearing queue: $e');
    }
  }

  /// Handle progress updates
  Future<void> _onUpdateProgress(
    events.UpdateProgress event,
    Emitter<states.UploadState> emit,
  ) async {
    final currentQueue = _repository.getUploadQueue();
    final overallProgress = _calculateOverallProgress(currentQueue);

    final currentState = state;
    if (currentState is states.UploadUploading) {
      emit(
        currentState.copyWith(
          files: currentQueue,
          overallProgress: overallProgress,
        ),
      );
    }
  }

  /// Handle file completion
  Future<void> _onFileCompleted(
    events.FileCompleted event,
    Emitter<states.UploadState> emit,
  ) async {
    debugPrint('✅ UploadBloc: File ${event.fileId} completed successfully');

    // Stop listening to this file's progress
    _stopListeningToFile(event.fileId);

    // Update state with current queue
    final currentQueue = _repository.getUploadQueue();
    _emitUpdatedState(emit, currentQueue);
  }

  /// Handle file failure
  Future<void> _onFileFailed(
    events.FileFailed event,
    Emitter<states.UploadState> emit,
  ) async {
    debugPrint('❌ UploadBloc: File ${event.fileId} failed: ${event.error}');

    // Update state with current queue
    final currentQueue = _repository.getUploadQueue();
    _emitUpdatedState(emit, currentQueue);
  }

  /// Update upload settings
  Future<void> _onUpdateSettings(
    events.UpdateSettings event,
    Emitter<states.UploadState> emit,
  ) async {
    if (event.maxConcurrentUploads != null) {
      _maxConcurrentUploads = event.maxConcurrentUploads!;
    }
    if (event.chunkSize != null) {
      _chunkSize = event.chunkSize!;
    }
    if (event.retryAttempts != null) {
      _retryAttempts = event.retryAttempts!;
    }

    _repository.updateSettings(
      maxConcurrentUploads: _maxConcurrentUploads,
      chunkSize: _chunkSize,
      retryAttempts: _retryAttempts,
    );

    debugPrint(
      '⚙️ UploadBloc: Updated settings - '
      'maxConcurrent: $_maxConcurrentUploads, '
      'chunkSize: $_chunkSize, '
      'retryAttempts: $_retryAttempts',
    );
  }

  /// Validate files
  Future<void> _onValidateFiles(
    events.ValidateFiles event,
    Emitter<states.UploadState> emit,
  ) async {
    try {
      emit(const states.UploadState.validating(message: 'Validating files...'));

      final validationErrors = await _repository.validateFiles(event.files);

      if (validationErrors.isNotEmpty) {
        emit(
          states.UploadState.error(
            message: 'File validation failed: ${validationErrors.join(', ')}',
            canRetry: false,
          ),
        );
      } else {
        emit(const states.UploadState.initial());
      }
    } catch (e) {
      emit(
        states.UploadState.error(
          message: 'Validation error: ${e.toString()}',
          canRetry: true,
        ),
      );
    }
  }

  /// Reset state to initial
  Future<void> _onResetState(
    events.ResetState event,
    Emitter<states.UploadState> emit,
  ) async {
    // Stop all listeners
    _stopAllListeners();

    // Clear repository
    await _repository.clearQueue();

    emit(const states.UploadState.initial());
    debugPrint('🔄 UploadBloc: State reset to initial');
  }

  /// Set category for uploads
  Future<void> _onSetCategory(
    events.SetCategory event,
    Emitter<states.UploadState> emit,
  ) async {
    // This would be used for setting default category for new uploads
    debugPrint('📁 UploadBloc: Set default category to ${event.categoryId}');
  }

  /// Set metadata for uploads
  Future<void> _onSetMetadata(
    events.SetMetadata event,
    Emitter<states.UploadState> emit,
  ) async {
    // This would be used for setting default metadata for new uploads
    debugPrint('📝 UploadBloc: Set default metadata');
  }

  /// Process upload queue
  Future<void> _onProcessQueue(
    events.ProcessQueue event,
    Emitter<states.UploadState> emit,
  ) async {
    final currentQueue = _repository.getUploadQueue();
    final pendingFiles = currentQueue
        .where((f) => f.status == UploadStatus.pending)
        .toList();

    if (pendingFiles.isNotEmpty) {
      add(events.StartUpload(files: pendingFiles));
    }
  }

  /// Handle upload completion
  Future<void> _onUploadCompleted(
    events.UploadCompleted event,
    Emitter<states.UploadState> emit,
  ) async {
    final currentQueue = _repository.getUploadQueue();

    emit(
      states.UploadState.completed(
        files: currentQueue,
        completedFiles: currentQueue
            .where((f) => f.status == UploadStatus.completed)
            .length,
        failedFiles: currentQueue
            .where((f) => f.status == UploadStatus.failed)
            .length,
        totalFiles: currentQueue.length,
      ),
    );

    debugPrint('✅ UploadBloc: All uploads completed');
  }

  /// Handle upload error
  Future<void> _onUploadError(
    events.UploadError event,
    Emitter<states.UploadState> emit,
  ) async {
    emit(states.UploadState.error(message: event.error, canRetry: true));

    debugPrint('❌ UploadBloc: Upload error: ${event.error}');
  }

  /// Handle overall progress update
  Future<void> _onOverallProgressUpdated(
    events.OverallProgressUpdated event,
    Emitter<states.UploadState> emit,
  ) async {
    final currentQueue = _repository.getUploadQueue();
    final currentState = state;

    if (currentState is states.UploadUploading) {
      emit(
        currentState.copyWith(
          files: currentQueue,
          overallProgress: event.progress,
        ),
      );
    }
  }

  /// Handle file progress update
  Future<void> _onFileProgressUpdated(
    events.FileProgressUpdated event,
    Emitter<states.UploadState> emit,
  ) async {
    final currentQueue = _repository.getUploadQueue();
    _emitUpdatedState(emit, currentQueue);
  }

  /// Handle file status update
  Future<void> _onFileStatusUpdated(
    events.FileStatusUpdated event,
    Emitter<states.UploadState> emit,
  ) async {
    final currentQueue = _repository.getUploadQueue();
    _emitUpdatedState(emit, currentQueue);
  }

  /// Start listening to overall progress
  void _startListeningToOverallProgress() {
    _overallProgressSubscription = _repository.getOverallProgress().listen(
      (progress) {
        add(events.OverallProgressUpdated(progress: progress));
      },
      onError: (error) {
        debugPrint('❌ UploadBloc: Overall progress stream error: $error');
      },
    );
  }

  /// Start listening to file progress
  void _startListeningToFileProgress(String fileId) {
    _progressSubscriptions[fileId] = _repository
        .getUploadProgress(fileId)
        .listen(
          (progress) {
            add(events.FileProgressUpdated(fileId: fileId, progress: progress));
          },
          onError: (error) {
            debugPrint(
              '❌ UploadBloc: File progress stream error for $fileId: $error',
            );
          },
        );
  }

  /// Start listening to file status
  void _startListeningToFileStatus(String fileId) {
    _statusSubscriptions[fileId] = _repository
        .getUploadStatus(fileId)
        .listen(
          (status) {
            add(events.FileStatusUpdated(fileId: fileId, status: status));

            // Handle completion and failure
            if (status == UploadStatus.completed) {
              // Get the file to extract download URL
              final file = _repository.getUploadQueue().firstWhere(
                (f) => f.id == fileId,
                orElse: () => throw StateError('File not found'),
              );
              add(
                events.FileCompleted(
                  fileId: fileId,
                  downloadUrl: file.downloadUrl ?? '',
                  documentId: file.documentId,
                ),
              );
            } else if (status == UploadStatus.failed) {
              add(events.FileFailed(fileId: fileId, error: 'Upload failed'));
            }
          },
          onError: (error) {
            debugPrint(
              '❌ UploadBloc: File status stream error for $fileId: $error',
            );
          },
        );
  }

  /// Stop listening to specific file
  void _stopListeningToFile(String fileId) {
    _progressSubscriptions[fileId]?.cancel();
    _statusSubscriptions[fileId]?.cancel();
    _progressSubscriptions.remove(fileId);
    _statusSubscriptions.remove(fileId);
  }

  /// Stop all listeners
  void _stopAllListeners() {
    _overallProgressSubscription?.cancel();
    _overallProgressSubscription = null;

    for (final subscription in _progressSubscriptions.values) {
      subscription.cancel();
    }
    for (final subscription in _statusSubscriptions.values) {
      subscription.cancel();
    }

    _progressSubscriptions.clear();
    _statusSubscriptions.clear();
  }

  /// Calculate overall progress from file list
  double _calculateOverallProgress(List<UploadFileModel> files) {
    if (files.isEmpty) return 0.0;

    final totalProgress = files.fold<double>(
      0.0,
      (sum, file) => sum + file.progress,
    );

    return totalProgress / files.length;
  }

  /// Emit updated state based on current queue
  void _emitUpdatedState(
    Emitter<states.UploadState> emit,
    List<UploadFileModel> files,
  ) {
    final overallProgress = _calculateOverallProgress(files);
    final isUploading = _repository.isUploading;

    final activeUploads = files
        .where((f) => f.status == UploadStatus.uploading)
        .length;
    final completedFiles = files
        .where((f) => f.status == UploadStatus.completed)
        .length;
    final failedFiles = files
        .where((f) => f.status == UploadStatus.failed)
        .length;
    final pausedFiles = files
        .where((f) => f.status == UploadStatus.paused)
        .length;

    if (isUploading && activeUploads > 0) {
      emit(
        states.UploadState.uploading(
          files: files,
          activeUploads: activeUploads,
          completedFiles: completedFiles,
          failedFiles: failedFiles,
          totalFiles: files.length,
          overallProgress: overallProgress,
        ),
      );
    } else if (pausedFiles > 0) {
      emit(
        states.UploadState.paused(
          files: files,
          completedFiles: completedFiles,
          failedFiles: failedFiles,
          totalFiles: files.length,
          overallProgress: overallProgress,
          pausedFiles: pausedFiles,
        ),
      );
    } else if (completedFiles == files.length && files.isNotEmpty) {
      emit(
        states.UploadState.completed(
          files: files,
          completedFiles: completedFiles,
          failedFiles: failedFiles,
          totalFiles: files.length,
        ),
      );
    } else if (files.isNotEmpty) {
      emit(
        states.UploadState.ready(
          files: files,
          totalFiles: files.length,
          totalSize: files.fold(0, (sum, file) => sum + file.fileSize),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _stopAllListeners();
    _repository.dispose();
    return super.close();
  }
}
