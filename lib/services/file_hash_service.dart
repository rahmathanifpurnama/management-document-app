import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// Service for calculating file hashes for duplicate detection
class FileHashService {
  static final FileHashService _instance = FileHashService._internal();
  factory FileHashService() => _instance;
  FileHashService._internal();

  /// Calculate SHA-256 hash of a file
  Future<String> calculateFileHash(File file) async {
    try {
      debugPrint('🔢 Calculating hash for file: ${file.path}');

      // Read file in chunks to handle large files efficiently
      final fileStream = file.openRead();
      final digest = await sha256.bind(fileStream).first;
      final hash = digest.toString();

      debugPrint('✅ Hash calculated: ${hash.substring(0, 16)}...');
      return hash;
    } catch (e) {
      debugPrint('❌ Error calculating file hash: $e');
      rethrow;
    }
  }

  /// Calculate SHA-256 hash of an XFile
  Future<String> calculateXFileHash(XFile file) async {
    try {
      debugPrint('🔢 Calculating hash for XFile: ${file.name}');

      final bytes = await file.readAsBytes();
      final digest = sha256.convert(bytes);
      final hash = digest.toString();

      debugPrint('✅ Hash calculated: ${hash.substring(0, 16)}...');
      return hash;
    } catch (e) {
      debugPrint('❌ Error calculating XFile hash: $e');
      rethrow;
    }
  }

  /// Calculate hash for multiple files
  Future<Map<String, String>> calculateMultipleFileHashes(
    List<XFile> files,
  ) async {
    final Map<String, String> hashes = {};

    for (final file in files) {
      try {
        final hash = await calculateXFileHash(file);
        hashes[file.name] = hash;
      } catch (e) {
        debugPrint('❌ Failed to calculate hash for ${file.name}: $e');
        // Continue with other files even if one fails
      }
    }

    return hashes;
  }

  /// Calculate hash with progress callback for large files
  Future<String> calculateFileHashWithProgress(
    File file, {
    Function(double)? onProgress,
  }) async {
    try {
      debugPrint('🔢 Calculating hash with progress for: ${file.path}');

      final fileSize = await file.length();
      final fileStream = file.openRead();

      // Use a simpler approach for progress tracking
      final chunks = <List<int>>[];
      int bytesRead = 0;

      await for (final chunk in fileStream) {
        chunks.add(chunk);
        bytesRead += chunk.length;

        if (onProgress != null && fileSize > 0) {
          final progress = bytesRead / fileSize;
          onProgress(progress);
        }
      }

      // Combine all chunks and calculate hash
      final allBytes = <int>[];
      for (final chunk in chunks) {
        allBytes.addAll(chunk);
      }

      final digest = sha256.convert(allBytes);
      final hash = digest.toString();

      onProgress?.call(1.0); // Complete
      debugPrint(
        '✅ Hash calculated with progress: ${hash.substring(0, 16)}...',
      );
      return hash;
    } catch (e) {
      debugPrint('❌ Error calculating file hash with progress: $e');
      rethrow;
    }
  }

  /// Quick hash calculation for small files (< 5MB)
  Future<String> calculateQuickHash(XFile file) async {
    try {
      final fileSize = await file.length();

      if (fileSize <= 5 * 1024 * 1024) {
        // For small files, read all at once
        final fileBytes = await file.readAsBytes();
        return sha256.convert(fileBytes).toString();
      } else {
        // For large files, use streaming approach
        return await calculateXFileHash(file);
      }
    } catch (e) {
      debugPrint('❌ Error calculating quick hash: $e');
      rethrow;
    }
  }

  /// Validate if two files have the same hash
  Future<bool> areFilesIdentical(XFile file1, XFile file2) async {
    try {
      // Quick size check first
      final size1 = await file1.length();
      final size2 = await file2.length();

      if (size1 != size2) {
        return false;
      }

      // Calculate hashes
      final hash1 = await calculateXFileHash(file1);
      final hash2 = await calculateXFileHash(file2);

      return hash1 == hash2;
    } catch (e) {
      debugPrint('❌ Error comparing files: $e');
      return false;
    }
  }

  /// Generate a unique identifier combining hash and metadata
  String generateFileFingerprint({
    required String hash,
    required String fileName,
    required int fileSize,
    required String contentType,
  }) {
    final metadata = '$fileName:$fileSize:$contentType';
    final metadataHash = sha256.convert(metadata.codeUnits).toString();
    return '${hash.substring(0, 32)}_${metadataHash.substring(0, 16)}';
  }

  /// Check if hash is valid SHA-256 format
  bool isValidHash(String hash) {
    if (hash.length != 64) return false;
    return RegExp(r'^[a-fA-F0-9]{64}$').hasMatch(hash);
  }

  /// Get hash from file metadata if available
  String? getHashFromMetadata(Map<String, dynamic>? metadata) {
    if (metadata == null) return null;

    final hash = metadata['fileHash'] as String?;
    if (hash != null && isValidHash(hash)) {
      return hash;
    }

    return null;
  }

  /// Create hash-based cache key for file operations
  String createCacheKey(String hash, String operation) {
    return '${operation}_${hash.substring(0, 16)}';
  }

  /// Batch hash calculation with concurrency control
  Future<Map<String, String>> calculateBatchHashes(
    List<XFile> files, {
    int maxConcurrency = 3,
    Function(int completed, int total)? onProgress,
  }) async {
    final Map<String, String> results = {};
    int completed = 0;

    // Process files in batches to control memory usage
    for (int i = 0; i < files.length; i += maxConcurrency) {
      final batch = files.skip(i).take(maxConcurrency).toList();

      final batchFutures = batch.map((file) async {
        try {
          final hash = await calculateXFileHash(file);
          results[file.name] = hash;
        } catch (e) {
          debugPrint('❌ Failed to hash ${file.name}: $e');
        } finally {
          completed++;
          onProgress?.call(completed, files.length);
        }
      });

      // Wait for current batch to complete before starting next
      await Future.wait(batchFutures);
    }

    return results;
  }

  /// Memory-efficient hash calculation for very large files
  Future<String> calculateLargeFileHash(
    File file, {
    int chunkSize = 1024 * 1024, // 1MB chunks
    Function(double)? onProgress,
  }) async {
    try {
      debugPrint('🔢 Calculating hash for large file: ${file.path}');

      final fileSize = await file.length();
      final randomAccessFile = await file.open();

      // Use streaming approach for very large files
      final chunks = <List<int>>[];
      int bytesRead = 0;

      try {
        while (bytesRead < fileSize) {
          final remainingBytes = fileSize - bytesRead;
          final currentChunkSize = remainingBytes < chunkSize
              ? remainingBytes
              : chunkSize;

          final chunk = await randomAccessFile.read(currentChunkSize);
          chunks.add(chunk);

          bytesRead += chunk.length;

          if (onProgress != null && fileSize > 0) {
            final progress = bytesRead / fileSize;
            onProgress(progress);
          }

          // Small delay to prevent blocking UI
          if (bytesRead % (chunkSize * 10) == 0) {
            await Future.delayed(const Duration(milliseconds: 1));
          }
        }
      } finally {
        await randomAccessFile.close();
      }

      // Combine all chunks and calculate hash
      final allBytes = <int>[];
      for (final chunk in chunks) {
        allBytes.addAll(chunk);
      }

      final digest = sha256.convert(allBytes);
      final hash = digest.toString();

      onProgress?.call(1.0);
      debugPrint('✅ Large file hash calculated: ${hash.substring(0, 16)}...');
      return hash;
    } catch (e) {
      debugPrint('❌ Error calculating large file hash: $e');
      rethrow;
    }
  }

  /// Get file size category for hash calculation strategy
  String getFileSizeCategory(int fileSize) {
    if (fileSize < 1024 * 1024) return 'small'; // < 1MB
    if (fileSize < 10 * 1024 * 1024) return 'medium'; // < 10MB
    if (fileSize < 100 * 1024 * 1024) return 'large'; // < 100MB
    return 'very_large'; // >= 100MB
  }

  /// Calculate hash using appropriate strategy based on file size
  Future<String> calculateOptimalHash(
    XFile file, {
    Function(double)? onProgress,
  }) async {
    final fileSize = await file.length();
    final category = getFileSizeCategory(fileSize);

    switch (category) {
      case 'small':
      case 'medium':
        return await calculateXFileHash(file);
      case 'large':
        if (onProgress != null) {
          return await calculateFileHashWithProgress(
            File(file.path),
            onProgress: onProgress,
          );
        } else {
          return await calculateXFileHash(file);
        }
      case 'very_large':
        return await calculateLargeFileHash(
          File(file.path),
          onProgress: onProgress,
        );
      default:
        return await calculateXFileHash(file);
    }
  }
}
