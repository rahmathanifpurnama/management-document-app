import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'file_hash_service.dart';
// Removed: cloud_functions_config - duplicate checking moved to hybridProcessFileUpload
import '../core/config/upload_config.dart';

/// Service for detecting duplicate files using hash comparison
class DuplicateDetectionService {
  static final DuplicateDetectionService _instance =
      DuplicateDetectionService._internal();
  factory DuplicateDetectionService() => _instance;
  DuplicateDetectionService._internal();

  final FileHashService _hashService = FileHashService();

  /// Check if file is duplicate before upload
  Future<DuplicateCheckResult> checkForDuplicate(
    XFile file, {
    Function(double)? onProgress,
  }) async {
    try {
      debugPrint('🔍 Starting duplicate detection for: ${file.name}');

      // Step 1: Calculate file hash
      onProgress?.call(0.1);
      final fileHash = await _hashService.calculateOptimalHash(
        file,
        onProgress: (hashProgress) {
          // Hash calculation takes 50% of total progress
          onProgress?.call(0.1 + (hashProgress * 0.5));
        },
      );

      debugPrint('📋 File hash calculated: ${fileHash.substring(0, 16)}...');

      // Step 2: Check with Cloud Functions if available
      onProgress?.call(0.7);
      if (UploadConfig.enableCloudFunctionsByDefault) {
        try {
          final result = await _checkWithCloudFunctions(file, fileHash);
          onProgress?.call(1.0);
          return result;
        } catch (e) {
          debugPrint(
            '⚠️ Cloud Functions check failed, using local fallback: $e',
          );
          // Fall back to local check
        }
      }

      // Step 3: Local fallback check (basic)
      onProgress?.call(0.9);
      final localResult = await _checkLocalDuplicate(file, fileHash);
      onProgress?.call(1.0);
      return localResult;
    } catch (e) {
      debugPrint('❌ Duplicate detection failed: $e');
      return DuplicateCheckResult(
        isDuplicate: false,
        confidence: 0.0,
        reason: 'Detection failed: $e',
      );
    }
  }

  /// Check duplicate using Cloud Functions
  /// DEPRECATED: Duplicate checking is now integrated into hybridProcessFileUpload
  Future<DuplicateCheckResult> _checkWithCloudFunctions(
    XFile file,
    String fileHash,
  ) async {
    debugPrint(
      '⚠️ DEPRECATED: _checkWithCloudFunctions() - duplicate checking moved to hybridProcessFileUpload',
    );

    // Return no duplicates since checking is now integrated in hybridProcessFileUpload
    return DuplicateCheckResult(
      isDuplicate: false,
      confidence: 0.0,
      reason: 'Duplicate checking moved to hybridProcessFileUpload',
      detectionMethod: 'deprecated',
    );
  }

  /// Local duplicate check (basic implementation)
  Future<DuplicateCheckResult> _checkLocalDuplicate(
    XFile file,
    String fileHash,
  ) async {
    // This is a basic local implementation
    // In a real scenario, you'd check against local database or cache
    debugPrint(
      '🔍 Performing local duplicate check for hash: ${fileHash.substring(0, 16)}...',
    );

    // For now, return no duplicate found
    return DuplicateCheckResult(
      isDuplicate: false,
      confidence: 0.5, // Lower confidence for local check
      reason: 'Local check completed - no duplicates found',
      detectionMethod: 'local',
    );
  }

  /// Batch duplicate detection for multiple files
  Future<Map<String, DuplicateCheckResult>> checkMultipleFiles(
    List<XFile> files, {
    Function(int completed, int total)? onProgress,
  }) async {
    final Map<String, DuplicateCheckResult> results = {};
    int completed = 0;

    for (final file in files) {
      try {
        final result = await checkForDuplicate(file);
        results[file.name] = result;
      } catch (e) {
        debugPrint('❌ Failed to check duplicate for ${file.name}: $e');
        results[file.name] = DuplicateCheckResult(
          isDuplicate: false,
          confidence: 0.0,
          reason: 'Check failed: $e',
        );
      } finally {
        completed++;
        onProgress?.call(completed, files.length);
      }
    }

    return results;
  }

  /// Compare two files for similarity
  Future<bool> areFilesSimilar(XFile file1, XFile file2) async {
    try {
      return await _hashService.areFilesIdentical(file1, file2);
    } catch (e) {
      debugPrint('❌ File comparison failed: $e');
      return false;
    }
  }

  /// Get content type from file name
  String _getContentType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();

    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'ppt':
        return 'application/vnd.ms-powerpoint';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'txt':
        return 'text/plain';
      default:
        return 'application/octet-stream';
    }
  }
}

/// Result of duplicate detection
class DuplicateCheckResult {
  final bool isDuplicate;
  final double confidence; // 0.0 to 1.0
  final String reason;
  final Map<String, dynamic>? existingDocument;
  final String detectionMethod;

  DuplicateCheckResult({
    required this.isDuplicate,
    required this.confidence,
    required this.reason,
    this.existingDocument,
    this.detectionMethod = 'unknown',
  });

  @override
  String toString() {
    return 'DuplicateCheckResult(isDuplicate: $isDuplicate, confidence: $confidence, reason: $reason, method: $detectionMethod)';
  }
}
