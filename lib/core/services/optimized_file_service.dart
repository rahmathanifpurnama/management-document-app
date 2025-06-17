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

  final Map<String, Completer<Uint8List?>> _downloadCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  int _activeOperations = 0;

  /// HIGH PRIORITY: Download file with chunking and caching
  Future<Uint8List?> downloadFileOptimized(
    String filePath, {
    bool useCache = true,
    Function(double progress)? onProgress,
  }) async {
    // Check cache first
    if (useCache && _downloadCache.containsKey(filePath)) {
      final cacheTime = _cacheTimestamps[filePath];
      if (cacheTime != null &&
          DateTime.now().difference(cacheTime) < ANRConfig.cacheExpiry) {
        debugPrint('📦 Using cached file: $filePath');
        return await _downloadCache[filePath]!.future;
      }
    }

    // Limit concurrent operations
    if (_activeOperations >= ANRConfig.maxConcurrentFileOps) {
      debugPrint('⚠️ Too many concurrent file operations, queuing...');
      await _waitForSlot();
    }

    _activeOperations++;
    final completer = Completer<Uint8List?>();
    _downloadCache[filePath] = completer;
    _cacheTimestamps[filePath] = DateTime.now();

    try {
      final result = await _downloadFileInBackground(filePath, onProgress);
      completer.complete(result);
      return result;
    } catch (e) {
      debugPrint('❌ File download failed: $filePath - $e');
      completer.complete(null);
      return null;
    } finally {
      _activeOperations--;
      _cleanupOldCache();
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
      // CRITICAL FIX: Let Cloud Functions handle timestamp addition
      // Use clean filename here, Cloud Functions will add timestamp for storage uniqueness
      final filePath = 'documents/$fileName';
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

  /// Clean up old cache entries
  void _cleanupOldCache() {
    final now = DateTime.now();
    final keysToRemove = <String>[];

    for (final entry in _cacheTimestamps.entries) {
      if (now.difference(entry.value) > ANRConfig.cacheExpiry) {
        keysToRemove.add(entry.key);
      }
    }

    for (final key in keysToRemove) {
      _downloadCache.remove(key);
      _cacheTimestamps.remove(key);
    }

    // Limit cache size
    if (_downloadCache.length > ANRConfig.maxCacheSize) {
      final sortedEntries = _cacheTimestamps.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));

      final toRemove = sortedEntries.take(
        _downloadCache.length - ANRConfig.maxCacheSize,
      );
      for (final entry in toRemove) {
        _downloadCache.remove(entry.key);
        _cacheTimestamps.remove(entry.key);
      }
    }
  }

  /// Clear all cache
  void clearCache() {
    _downloadCache.clear();
    _cacheTimestamps.clear();
    debugPrint('🧹 File cache cleared');
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    return {
      'cachedFiles': _downloadCache.length,
      'activeOperations': _activeOperations,
      'oldestCacheEntry': _cacheTimestamps.values.isEmpty
          ? null
          : _cacheTimestamps.values.reduce((a, b) => a.isBefore(b) ? a : b),
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
