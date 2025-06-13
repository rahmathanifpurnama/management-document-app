import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../config/anr_config.dart';
import '../utils/anr_prevention.dart';

/// HIGH PRIORITY: Optimized file service to prevent ANR during file operations
class OptimizedFileService {
  static OptimizedFileService? _instance;
  static OptimizedFileService get instance =>
      _instance ??= OptimizedFileService._();

  OptimizedFileService._();

  int _activeOperations = 0;

  /// HIGH PRIORITY: Download file directly without caching
  Future<Uint8List?> downloadFileOptimized(
    String filePath, {
    bool useCache = false, // Disabled caching
    Function(double progress)? onProgress,
  }) async {
    // Limit concurrent operations
    if (_activeOperations >= ANRConfig.maxConcurrentFileOps) {
      debugPrint('⚠️ Too many concurrent file operations, queuing...');
      await _waitForSlot();
    }

    _activeOperations++;

    try {
      debugPrint('📁 Downloading file directly: $filePath');
      final result = await _downloadFileInBackground(filePath, onProgress);
      return result;
    } catch (e) {
      debugPrint('❌ File download failed: $filePath - $e');
      return null;
    } finally {
      _activeOperations--;
    }
  }

  /// Download file in background isolate
  Future<Uint8List?> _downloadFileInBackground(
    String filePath,
    Function(double progress)? onProgress,
  ) async {
    return await ANRPrevention.executeInBackground(
      () async {
        final ref = FirebaseStorage.instance.ref().child(filePath);

        // Get file metadata first
        final metadata = await ANRPrevention.executeWithTimeout(
          ref.getMetadata(),
          timeout: ANRConfig.storageMetadataTimeout,
          operationName: 'File Metadata - $filePath',
        );

        if (metadata == null) {
          throw Exception('Failed to get file metadata');
        }

        final fileSize = metadata.size ?? 0;
        debugPrint(
          '📁 Downloading file: $filePath (${_formatFileSize(fileSize)})',
        );

        // Choose download strategy based on file size
        if (fileSize > 5 * 1024 * 1024) {
          // > 5MB
          final result = await _downloadLargeFile(ref, fileSize, onProgress);
          if (result == null) {
            throw Exception('Failed to download large file');
          }
          return result;
        } else {
          final result = await _downloadSmallFile(ref, onProgress);
          if (result == null) {
            throw Exception('Failed to download small file');
          }
          return result;
        }
      },
      timeout: _getTimeoutForFileSize(0), // Will be updated with actual size
      operationName: 'File Download - $filePath',
    );
  }

  /// Download small file (< 5MB)
  Future<Uint8List?> _downloadSmallFile(
    Reference ref,
    Function(double progress)? onProgress,
  ) async {
    try {
      final data = await ref.getData();
      return data;
    } catch (e) {
      debugPrint('❌ Small file download failed: $e');
      return null;
    }
  }

  /// Download large file with chunking (>= 5MB)
  Future<Uint8List?> _downloadLargeFile(
    Reference ref,
    int fileSize,
    Function(double progress)? onProgress,
  ) async {
    const chunkSize = 1024 * 1024; // 1MB chunks
    final chunks = <Uint8List>[];
    int downloadedBytes = 0;

    try {
      while (downloadedBytes < fileSize) {
        final start = downloadedBytes;
        final end = (downloadedBytes + chunkSize - 1).clamp(0, fileSize - 1);

        final chunkData = await ANRPrevention.executeWithTimeout(
          ref.getData(end - start + 1),
          timeout: ANRConfig.largeFileReadTimeout,
          operationName: 'File Chunk Download',
        );

        if (chunkData == null) {
          throw Exception('Failed to download chunk');
        }

        chunks.add(chunkData);
        downloadedBytes = end + 1;

        // Report progress
        final progress = downloadedBytes / fileSize;
        onProgress?.call(progress);

        // Yield to UI thread
        await ANRPrevention.yieldToUI();
      }

      // Combine chunks
      final totalBytes = chunks.fold<int>(
        0,
        (sum, chunk) => sum + chunk.length,
      );
      final result = Uint8List(totalBytes);
      int offset = 0;

      for (final chunk in chunks) {
        result.setRange(offset, offset + chunk.length, chunk);
        offset += chunk.length;

        // Yield periodically during combination
        if (offset % (chunkSize * 2) == 0) {
          await ANRPrevention.yieldToUI();
        }
      }

      return result;
    } catch (e) {
      debugPrint('❌ Large file download failed: $e');
      return null;
    }
  }

  /// HIGH PRIORITY: Upload file with chunking
  Future<String?> uploadFileOptimized(
    Uint8List fileData,
    String fileName,
    String contentType, {
    Function(double progress)? onProgress,
    Map<String, String>? metadata,
  }) async {
    // Limit concurrent operations
    if (_activeOperations >= ANRConfig.maxConcurrentFileOps) {
      debugPrint('⚠️ Too many concurrent file operations, queuing...');
      await _waitForSlot();
    }

    _activeOperations++;

    try {
      final filePath =
          'documents/${DateTime.now().millisecondsSinceEpoch}_$fileName';
      final ref = FirebaseStorage.instance.ref().child(filePath);

      debugPrint(
        '📤 Uploading file: $fileName (${_formatFileSize(fileData.length)})',
      );

      // Choose upload strategy based on file size
      if (fileData.length > 5 * 1024 * 1024) {
        // > 5MB
        return await _uploadLargeFile(
          ref,
          fileData,
          contentType,
          metadata,
          onProgress,
        );
      } else {
        return await _uploadSmallFile(
          ref,
          fileData,
          contentType,
          metadata,
          onProgress,
        );
      }
    } catch (e) {
      debugPrint('❌ File upload failed: $fileName - $e');
      return null;
    } finally {
      _activeOperations--;
    }
  }

  /// Upload small file
  Future<String?> _uploadSmallFile(
    Reference ref,
    Uint8List fileData,
    String contentType,
    Map<String, String>? metadata,
    Function(double progress)? onProgress,
  ) async {
    final uploadTask = ref.putData(
      fileData,
      SettableMetadata(contentType: contentType, customMetadata: metadata),
    );

    // Monitor progress
    uploadTask.snapshotEvents.listen((snapshot) {
      final progress = snapshot.bytesTransferred / snapshot.totalBytes;
      onProgress?.call(progress);
    });

    final result = await ANRPrevention.executeWithTimeout(
      uploadTask,
      timeout: ANRConfig.storageUploadTimeout,
      operationName: 'Small File Upload',
    );

    return result?.ref.fullPath;
  }

  /// Upload large file with chunking
  Future<String?> _uploadLargeFile(
    Reference ref,
    Uint8List fileData,
    String contentType,
    Map<String, String>? metadata,
    Function(double progress)? onProgress,
  ) async {
    // For now, use standard upload but with better progress tracking
    // In a production app, you might want to implement multipart upload
    return await _uploadSmallFile(
      ref,
      fileData,
      contentType,
      metadata,
      onProgress,
    );
  }

  /// Wait for available operation slot
  Future<void> _waitForSlot() async {
    while (_activeOperations >= ANRConfig.maxConcurrentFileOps) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  /// Get timeout based on file size
  Duration _getTimeoutForFileSize(int fileSize) {
    if (fileSize > 5 * 1024 * 1024) {
      return ANRConfig.largeFileReadTimeout;
    }
    return ANRConfig.smallFileReadTimeout;
  }

  /// Format file size for display
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Clear all cache (no-op for compatibility)
  void clearCache() {
    debugPrint('🧹 File cache clearing (no cache to clear)');
  }

  /// Get operation statistics
  Map<String, dynamic> getCacheStats() {
    return {
      'cachedFiles': 0, // No caching
      'activeOperations': _activeOperations,
    };
  }
}

/// Extension for ANR prevention utilities
extension ANRPreventionExtension on ANRPrevention {
  /// Yield control to UI thread
  static Future<void> yieldToUI() async {
    await Future.delayed(ANRConfig.yieldDelay);
  }
}
