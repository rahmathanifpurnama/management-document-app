import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_selector/file_selector.dart';

import '../models/upload_file_model.dart';
import '../repositories/upload_repository.dart';
import '../repositories/upload_repository_impl.dart';
import 'upload_event.dart' hide UploadCompleted, UploadError;
import 'upload_state.dart' hide UploadCompleted, UploadError;
import 'upload_event.dart' as events show UploadCompleted, UploadError;

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
class UploadBloc extends Bloc<UploadEvent, UploadState> {
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
      super(const UploadState.initial()) {
    // Register event handlers
    on<AddFiles>(_onAddFiles);
    on<StartUpload>(_onStartUpload);
    on<PauseUpload>(_onPauseUpload);
    on<ResumeUpload>(_onResumeUpload);
    on<CancelUpload>(_onCancelUpload);
    on<RetryUpload>(_onRetryUpload);
    on<RemoveFile>(_onRemoveFromQueue);
    on<ClearQueue>(_onClearQueue);
    on<UpdateProgress>(_onUpdateProgress);
    on<FileCompleted>(_onFileCompleted);
    on<FileFailed>(_onFileFailed);
    on<UpdateSettings>(_onUpdateSettings);
    on<ValidateFiles>(_onValidateFiles);
    on<ResetState>(_onResetState);
    on<SetCategory>(_onSetCategory);
    on<SetMetadata>(_onSetMetadata);
    on<ProcessQueue>(_onProcessQueue);
    on<events.UploadCompleted>(_onUploadCompleted);
    on<events.UploadError>(_onUploadError);

    // Start listening to overall progress
    _startListeningToOverallProgress();
  }

  /// Add files to upload queue
  Future<void> _onAddFiles(AddFiles event, Emitter<UploadState> emit) async {
    try {
      emit(const UploadState.validating(message: 'Validating files...'));

      // Validate files first
      final validationErrors = await _repository.validateFiles(event.files);
      if (validationErrors.isNotEmpty) {
        emit(
          UploadState.error(
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
        UploadState.ready(
          files: currentQueue,
          totalFiles: currentQueue.length,
          totalSize: currentQueue.fold(0, (sum, file) => sum + file.fileSize),
        ),
      );

      debugPrint('📁 UploadBloc: Added ${uploadFiles.length} files to queue');
    } catch (e) {
      emit(
        UploadState.error(
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
    PauseUpload event,
    Emitter<UploadState> emit,
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
        UploadState.paused(
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
    ResumeUpload event,
    Emitter<UploadState> emit,
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
        UploadState.uploading(
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
    CancelUpload event,
    Emitter<UploadState> emit,
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
        UploadState.cancelled(
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
    RetryUpload event,
    Emitter<UploadState> emit,
  ) async {
    try {
      await _repository.retryUpload(event.fileId);

      final currentQueue = _repository.getUploadQueue();

      emit(
        UploadState.uploading(
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

      debugPrint('🔄 UploadBloc: Retrying upload for file ${event.fileId}');
    } catch (e) {
      debugPrint('❌ UploadBloc: Error retrying upload: $e');
    }
  }

  /// Remove file from queue
  Future<void> _onRemoveFromQueue(
    RemoveFile event,
    Emitter<UploadState> emit,
  ) async {
    try {
      await _repository.removeFromQueue(event.fileId);

      // Stop listening to this file's progress
      _stopListeningToFile(event.fileId);

      final currentQueue = _repository.getUploadQueue();
      final statistics = _repository.getUploadStatistics();

      emit(
        UploadState.queueUpdated(
          files: currentQueue,
          statistics: statistics,
          isUploading: _repository.isUploading,
          overallProgress: _calculateOverallProgress(currentQueue),
        ),
      );

      debugPrint('🗑️ UploadBloc: Removed file ${event.fileId} from queue');
    } catch (e) {
      debugPrint('❌ UploadBloc: Error removing file from queue: $e');
    }
  }

  /// Clear upload queue
  Future<void> _onClearQueue(
    ClearQueue event,
    Emitter<UploadState> emit,
  ) async {
    try {
      await _repository.clearQueue();

      // Stop all progress listeners
      _stopAllListeners();

      emit(
        const UploadState.queueUpdated(
          files: [],
          statistics: {
            'total': 0,
            'completed': 0,
            'failed': 0,
            'pending': 0,
            'uploading': 0,
            'success_rate': '0.0',
          },
          isUploading: false,
          overallProgress: 0.0,
        ),
      );

      debugPrint('🧹 UploadBloc: Cleared upload queue');
    } catch (e) {
      debugPrint('❌ UploadBloc: Error clearing queue: $e');
    }
  }

  /// Handle progress updates
  Future<void> _onUpdateProgress(
    UpdateProgress event,
    Emitter<UploadState> emit,
  ) async {
    final currentQueue = _repository.getUploadQueue();
    final statistics = _repository.getUploadStatistics();
    final overallProgress = _calculateOverallProgress(currentQueue);

    final currentState = state;
    if (currentState is UploadUploading) {
      emit(
        currentState.copyWith(
          files: currentQueue,
          statistics: statistics,
          overallProgress: overallProgress,
        ),
      );
    }
  }

  /// Handle file completion
  Future<void> _onFileCompleted(
    FileCompleted event,
    Emitter<UploadState> emit,
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
    FileFailed event,
    Emitter<UploadState> emit,
  ) async {
    debugPrint('❌ UploadBloc: File ${event.fileId} failed: ${event.error}');

    // Update state with current queue
    final currentQueue = _repository.getUploadQueue();
    _emitUpdatedState(emit, currentQueue);
  }

  /// Update upload settings
  Future<void> _onUpdateSettings(
    UpdateSettings event,
    Emitter<UploadState> emit,
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
    ValidateFiles event,
    Emitter<UploadState> emit,
  ) async {
    try {
      emit(const UploadState.validating(message: 'Validating files...'));

      final validationErrors = await _repository.validateFiles(event.files);

      if (validationErrors.isNotEmpty) {
        emit(
          UploadState.error(
            message: 'File validation failed',
            details: validationErrors,
            canRetry: false,
          ),
        );
      } else {
        emit(const UploadState.initial());
      }
    } catch (e) {
      emit(
        UploadState.error(
          message: 'Validation error: ${e.toString()}',
          canRetry: true,
        ),
      );
    }
  }

  /// Reset state to initial
  Future<void> _onResetState(
    ResetState event,
    Emitter<UploadState> emit,
  ) async {
    // Stop all listeners
    _stopAllListeners();

    // Clear repository
    await _repository.clearQueue();

    emit(const UploadState.initial());
    debugPrint('🔄 UploadBloc: State reset to initial');
  }

  /// Set category for uploads
  Future<void> _onSetCategory(
    SetCategory event,
    Emitter<UploadState> emit,
  ) async {
    // This would be used for setting default category for new uploads
    debugPrint('📁 UploadBloc: Set default category to ${event.categoryId}');
  }

  /// Set metadata for uploads
  Future<void> _onSetMetadata(
    SetMetadata event,
    Emitter<UploadState> emit,
  ) async {
    // This would be used for setting default metadata for new uploads
    debugPrint('📝 UploadBloc: Set default metadata');
  }

  /// Process upload queue
  Future<void> _onProcessQueue(
    ProcessQueue event,
    Emitter<UploadState> emit,
  ) async {
    add(const StartUpload());
  }

  /// Handle upload completion
  Future<void> _onUploadCompleted(
    UploadCompleted event,
    Emitter<UploadState> emit,
  ) async {
    final currentQueue = _repository.getUploadQueue();
    final statistics = _repository.getUploadStatistics();

    emit(
      UploadState.completed(
        files: currentQueue,
        statistics: statistics,
        message: 'All uploads completed successfully',
      ),
    );

    debugPrint('✅ UploadBloc: All uploads completed');
  }

  /// Handle upload error
  Future<void> _onUploadError(
    UploadError event,
    Emitter<UploadState> emit,
  ) async {
    emit(UploadState.error(message: event.error, canRetry: true));

    debugPrint('❌ UploadBloc: Upload error: ${event.error}');
  }

  /// Start listening to overall progress
  void _startListeningToOverallProgress() {
    _overallProgressSubscription = _repository.getOverallProgress().listen(
      (progress) {
        add(OverallProgressUpdated(progress: progress));
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
            add(FileProgressUpdated(fileId: fileId, progress: progress));
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
            add(FileStatusUpdated(fileId: fileId, status: status));

            // Handle completion and failure
            if (status == UploadStatus.completed) {
              add(FileCompleted(fileId: fileId));
            } else if (status == UploadStatus.failed) {
              add(FileFailed(fileId: fileId, error: 'Upload failed'));
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

  @override
  Future<void> close() {
    _stopAllListeners();
    _repository.dispose();
    return super.close();
  }
}
