import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/document_model.dart';
import '../widgets/download/animated_download_progress_widget.dart';
import 'file_download_service.dart';
import '../core/services/optimized_file_service.dart';

/// Enhanced download service with network-aware animation timing
class EnhancedDownloadService extends ChangeNotifier {
  static final EnhancedDownloadService _instance =
      EnhancedDownloadService._internal();
  factory EnhancedDownloadService() => _instance;
  EnhancedDownloadService._internal();

  final FileDownloadService _fileDownloadService = FileDownloadService();
  final OptimizedFileService _optimizedFileService =
      OptimizedFileService.instance;

  // Active downloads tracking
  final Map<String, DownloadProgress> _activeDownloads = {};
  final Map<String, StreamController<DownloadProgress>> _progressControllers =
      {};
  final Map<String, DateTime> _downloadStartTimes = {};
  final Map<String, int> _downloadedBytes = {};

  /// Get stream of download progress for a specific document
  Stream<DownloadProgress> getDownloadProgress(String documentId) {
    if (!_progressControllers.containsKey(documentId)) {
      _progressControllers[documentId] =
          StreamController<DownloadProgress>.broadcast();
    }
    return _progressControllers[documentId]!.stream;
  }

  /// Start download with enhanced progress tracking and error handling
  Future<String?> downloadWithProgress(
    DocumentModel document, {
    String? customPath,
    int maxRetries = 3,
  }) async {
    final documentId = document.id;

    // Check if already downloading
    if (isDownloading(documentId)) {
      debugPrint('⚠️ Download already in progress for: ${document.fileName}');
      return null;
    }

    // Initialize download tracking
    _activeDownloads[documentId] = DownloadProgress(
      document: document,
      progress: 0.0,
      state: DownloadState.starting,
    );
    _downloadStartTimes[documentId] = DateTime.now();
    _downloadedBytes[documentId] = 0;

    _notifyProgress(documentId);

    int retryCount = 0;
    String? lastError;

    while (retryCount <= maxRetries) {
      try {
        // Update state to downloading
        _updateDownloadState(documentId, DownloadState.downloading);

        // Check network connectivity
        if (!await _checkNetworkConnectivity()) {
          throw Exception('No network connection available');
        }

        // Use optimized service for better progress tracking
        final result = await _optimizedFileService.downloadFileOptimized(
          document.filePath,
          onProgress: (progress) {
            // Check if download was cancelled
            if (!_activeDownloads.containsKey(documentId)) {
              throw Exception('Download cancelled by user');
            }
            _updateDownloadProgress(documentId, progress, document.fileSize);
          },
        );

        if (result != null) {
          // Save to device storage using existing service
          final filePath = await _fileDownloadService.downloadFile(
            document,
            customPath: customPath,
            onProgress: (progress) {
              // Check if download was cancelled during save
              if (!_activeDownloads.containsKey(documentId)) {
                throw Exception('Download cancelled by user');
              }
              // This is for the final save operation
              _updateDownloadProgress(
                documentId,
                0.9 + (progress * 0.1),
                document.fileSize,
              );
            },
          );

          _updateDownloadState(documentId, DownloadState.completed);
          return filePath;
        } else {
          throw Exception('Failed to download file - no data received');
        }
      } catch (e) {
        lastError = e.toString();
        retryCount++;

        debugPrint('❌ Download attempt $retryCount failed: $lastError');

        if (retryCount <= maxRetries) {
          // Pause before retry with exponential backoff
          final delaySeconds = retryCount * 2;
          _updateDownloadState(
            documentId,
            DownloadState.paused,
            errorMessage:
                'Retrying in $delaySeconds seconds... (Attempt $retryCount/$maxRetries)',
          );

          await Future.delayed(Duration(seconds: delaySeconds));

          // Check if download was cancelled during retry delay
          if (!_activeDownloads.containsKey(documentId)) {
            return null;
          }
        }
      }
    }

    // All retries failed
    _updateDownloadState(
      documentId,
      DownloadState.failed,
      errorMessage: 'Download failed after $maxRetries attempts: $lastError',
    );

    // Clean up after delay to allow UI to show failure
    Timer(const Duration(seconds: 5), () {
      _cleanupDownload(documentId);
    });

    return null;
  }

  /// Check network connectivity
  Future<bool> _checkNetworkConnectivity() async {
    try {
      // Simple connectivity check - could be enhanced with connectivity_plus package
      return true; // Placeholder - implement actual connectivity check
    } catch (e) {
      return false;
    }
  }

  /// Cancel active download
  Future<void> cancelDownload(String documentId) async {
    if (_activeDownloads.containsKey(documentId)) {
      _updateDownloadState(
        documentId,
        DownloadState.failed,
        errorMessage: 'Cancelled by user',
      );
      _cleanupDownload(documentId);
    }
  }

  /// Retry failed download
  Future<String?> retryDownload(String documentId) async {
    final downloadProgress = _activeDownloads[documentId];
    if (downloadProgress != null) {
      return await downloadWithProgress(downloadProgress.document);
    }
    return null;
  }

  void _updateDownloadProgress(
    String documentId,
    double progress,
    int? fileSize,
  ) {
    if (!_activeDownloads.containsKey(documentId)) return;

    final currentTime = DateTime.now();
    final startTime = _downloadStartTimes[documentId];

    if (startTime != null && fileSize != null) {
      final elapsedTime = currentTime.difference(startTime);
      final currentBytes = (progress * fileSize).round();
      _downloadedBytes[documentId] = currentBytes;

      // Calculate network speed for animation timing
      Duration? networkSpeed;
      if (elapsedTime.inMilliseconds > 0 && currentBytes > 0) {
        final bytesPerSecond =
            currentBytes / (elapsedTime.inMilliseconds / 1000.0);
        networkSpeed = Duration(
          milliseconds: (1000 / bytesPerSecond * 1024).round(),
        ); // Time per KB
      }

      _activeDownloads[documentId] = _activeDownloads[documentId]!.copyWith(
        progress: progress,
        networkSpeed: networkSpeed,
      );
    } else {
      _activeDownloads[documentId] = _activeDownloads[documentId]!.copyWith(
        progress: progress,
      );
    }

    _notifyProgress(documentId);
  }

  void _updateDownloadState(
    String documentId,
    DownloadState state, {
    String? errorMessage,
  }) {
    if (!_activeDownloads.containsKey(documentId)) return;

    _activeDownloads[documentId] = _activeDownloads[documentId]!.copyWith(
      state: state,
      errorMessage: errorMessage,
    );

    _notifyProgress(documentId);
  }

  void _notifyProgress(String documentId) {
    final progress = _activeDownloads[documentId];
    if (progress != null && _progressControllers.containsKey(documentId)) {
      _progressControllers[documentId]!.add(progress);
    }
    notifyListeners();
  }

  void _cleanupDownload(String documentId) {
    _activeDownloads.remove(documentId);
    _downloadStartTimes.remove(documentId);
    _downloadedBytes.remove(documentId);

    final controller = _progressControllers.remove(documentId);
    controller?.close();

    notifyListeners();
  }

  /// Get current active downloads
  Map<String, DownloadProgress> get activeDownloads =>
      Map.unmodifiable(_activeDownloads);

  /// Check if document is currently downloading
  bool isDownloading(String documentId) {
    final progress = _activeDownloads[documentId];
    return progress?.state == DownloadState.downloading ||
        progress?.state == DownloadState.starting;
  }

  @override
  void dispose() {
    for (final controller in _progressControllers.values) {
      controller.close();
    }
    _progressControllers.clear();
    _activeDownloads.clear();
    _downloadStartTimes.clear();
    _downloadedBytes.clear();
    super.dispose();
  }
}

/// Download progress data class
class DownloadProgress {
  final DocumentModel document;
  final double progress;
  final DownloadState state;
  final String? errorMessage;
  final Duration? networkSpeed;

  const DownloadProgress({
    required this.document,
    required this.progress,
    required this.state,
    this.errorMessage,
    this.networkSpeed,
  });

  DownloadProgress copyWith({
    DocumentModel? document,
    double? progress,
    DownloadState? state,
    String? errorMessage,
    Duration? networkSpeed,
  }) {
    return DownloadProgress(
      document: document ?? this.document,
      progress: progress ?? this.progress,
      state: state ?? this.state,
      errorMessage: errorMessage ?? this.errorMessage,
      networkSpeed: networkSpeed ?? this.networkSpeed,
    );
  }
}
