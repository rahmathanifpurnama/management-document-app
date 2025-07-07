import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/document_model.dart';
import 'file_download_service.dart';

/// Enhanced download service with native notifications only
class EnhancedDownloadService {
  static final EnhancedDownloadService _instance =
      EnhancedDownloadService._internal();
  factory EnhancedDownloadService() => _instance;
  EnhancedDownloadService._internal();

  bool _isDisposed = false;

  final FileDownloadService _fileDownloadService = FileDownloadService();

  // Simple download tracking for preventing duplicates
  final Set<String> _activeDownloads = {};

  /// Start download with enhanced error handling and native notifications
  Future<String?> downloadWithProgress(
    DocumentModel document, {
    String? customPath,
    int maxRetries = 3,
  }) async {
    if (_isDisposed) {
      debugPrint(
        '⚠️ EnhancedDownloadService: Cannot start download - service disposed',
      );
      return null;
    }

    final documentId = document.id;

    // Check if already downloading
    if (isDownloading(documentId)) {
      debugPrint('⚠️ Download already in progress for: ${document.fileName}');
      return null;
    }

    // Add to active downloads tracking
    _activeDownloads.add(documentId);

    int retryCount = 0;
    String? lastError;

    try {
      while (retryCount <= maxRetries) {
        try {
          // Check network connectivity
          if (!await _checkNetworkConnectivity()) {
            throw Exception('No network connection available');
          }

          // Use the file download service directly (it handles native notifications)
          final filePath = await _fileDownloadService.downloadFile(
            document,
            customPath: customPath,
          );

          // Download completed successfully
          _activeDownloads.remove(documentId);
          debugPrint('✅ Download completed: ${document.fileName}');
          return filePath;
        } catch (e) {
          lastError = e.toString();
          retryCount++;

          debugPrint('❌ Download attempt $retryCount failed: $lastError');

          if (retryCount <= maxRetries) {
            // Pause before retry with exponential backoff
            final delaySeconds = retryCount * 2;
            debugPrint(
              '⏳ Retrying in $delaySeconds seconds... (Attempt $retryCount/$maxRetries)',
            );

            await Future.delayed(Duration(seconds: delaySeconds));

            // Check if download was cancelled during retry delay
            if (!_activeDownloads.contains(documentId)) {
              return null;
            }
          }
        }
      }

      // All retries failed
      _activeDownloads.remove(documentId);
      debugPrint('❌ Download failed after $maxRetries attempts: $lastError');
      throw Exception('Download failed after $maxRetries attempts: $lastError');
    } catch (e) {
      // Ensure cleanup on any error
      _activeDownloads.remove(documentId);
      rethrow;
    }
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
    _activeDownloads.remove(documentId);
    debugPrint('🚫 Download cancelled: $documentId');
  }

  /// Check if document is currently downloading
  bool isDownloading(String documentId) {
    if (_isDisposed) return false;
    return _activeDownloads.contains(documentId);
  }

  /// Force dispose for testing or app shutdown only
  void forceDispose() {
    if (_isDisposed) return;

    debugPrint('🗑️ EnhancedDownloadService: Force disposing singleton');
    _isDisposed = true;
    _activeDownloads.clear();
  }
}
