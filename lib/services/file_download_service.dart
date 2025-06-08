import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:external_path/external_path.dart';
import '../models/document_model.dart';
import '../core/services/firebase_service.dart';

class FileDownloadService {
  static final FileDownloadService _instance = FileDownloadService._internal();
  factory FileDownloadService() => _instance;
  FileDownloadService._internal();

  final Dio _dio = Dio();
  final Map<String, CancelToken> _downloadTokens = {};
  final FirebaseService _firebaseService = FirebaseService.instance;

  /// Download file from Firebase Storage and save to device
  Future<String> downloadFile(
    DocumentModel document, {
    Function(double)? onProgress,
    String? customPath,
  }) async {
    try {
      // Request storage permission
      if (!await _requestStoragePermission()) {
        throw Exception('Storage permission denied');
      }

      // Get download URL from Firebase Storage
      final downloadUrl = await _getDownloadUrl(document);
      if (downloadUrl.isEmpty) {
        throw Exception('Download URL not available');
      }

      // Get save directory
      final saveDir = await _getSaveDirectory(customPath);

      // Create unique filename to avoid conflicts
      final fileName = _createUniqueFileName(document.fileName, saveDir);
      final filePath = '${saveDir.path}/$fileName';

      // Create cancel token for this download
      final cancelToken = CancelToken();
      _downloadTokens[document.id] = cancelToken;

      // Download file with progress tracking
      await _dio.download(
        downloadUrl,
        filePath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (total > 0 && onProgress != null) {
            final progress = received / total;
            onProgress(progress);
          }
        },
        options: Options(
          headers: {'Accept': '*/*', 'User-Agent': 'ManagementDoc-Mobile-App'},
          receiveTimeout: const Duration(minutes: 10),
          sendTimeout: const Duration(minutes: 10),
        ),
      );

      // Clean up
      _downloadTokens.remove(document.id);

      // Verify file was downloaded successfully
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File download failed - file not found');
      }

      // Verify file size matches expected size (if available)
      final fileSize = await file.length();
      if (document.fileSize > 0 && fileSize != document.fileSize) {
        debugPrint(
          'Warning: Downloaded file size ($fileSize) differs from expected size (${document.fileSize})',
        );
      }

      return filePath;
    } catch (e) {
      // Clean up on error
      _downloadTokens.remove(document.id);

      if (e is DioException) {
        if (e.type == DioExceptionType.cancel) {
          throw Exception('Download cancelled');
        } else if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          throw Exception(
            'Download timeout - please check your internet connection',
          );
        } else if (e.response?.statusCode == 403) {
          throw Exception(
            'Access denied - file may have been moved or deleted',
          );
        } else if (e.response?.statusCode == 404) {
          throw Exception('File not found on server');
        } else {
          throw Exception('Network error: ${e.message}');
        }
      }

      rethrow;
    }
  }

  /// Cancel ongoing download
  void cancelDownload(String documentId) {
    final cancelToken = _downloadTokens[documentId];
    if (cancelToken != null && !cancelToken.isCancelled) {
      cancelToken.cancel('Download cancelled by user');
      _downloadTokens.remove(documentId);
    }
  }

  /// Get download URL from document
  Future<String> _getDownloadUrl(DocumentModel document) async {
    try {
      // If document already has a download URL in filePath, use it
      if (document.filePath.startsWith('http')) {
        return document.filePath;
      }

      // Otherwise, get download URL from Firebase Storage using the storage path
      if (document.filePath.isNotEmpty) {
        final storageRef = _firebaseService.storage.ref().child(
          document.filePath,
        );
        final downloadUrl = await storageRef.getDownloadURL();
        return downloadUrl;
      }

      throw Exception('No file path available for download');
    } catch (e) {
      if (e is FirebaseException) {
        switch (e.code) {
          case 'object-not-found':
            throw Exception('File not found in storage');
          case 'unauthorized':
            throw Exception('Access denied - please check permissions');
          case 'unauthenticated':
            throw Exception('Authentication required');
          default:
            throw Exception('Failed to get download URL: ${e.message}');
        }
      }
      throw Exception('Failed to get download URL: ${e.toString()}');
    }
  }

  /// Request storage permission
  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      // For Android 13+ (API 33+), we need different permissions
      if (await _isAndroid13OrHigher()) {
        // Android 13+ doesn't need WRITE_EXTERNAL_STORAGE for app-specific directories
        return true;
      } else {
        // For older Android versions
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    } else if (Platform.isIOS) {
      // iOS doesn't need explicit storage permission for app documents
      return true;
    }

    return true; // For other platforms
  }

  /// Check if Android version is 13 or higher
  Future<bool> _isAndroid13OrHigher() async {
    if (!Platform.isAndroid) return false;

    try {
      // This is a simplified check - in production you might want to use
      // device_info_plus package for more accurate version detection
      return true; // Assume modern Android for now
    } catch (e) {
      return false;
    }
  }

  /// Get directory to save downloaded files
  Future<Directory> _getSaveDirectory(String? customPath) async {
    if (customPath != null) {
      final dir = Directory(customPath);
      if (await dir.exists()) {
        return dir;
      }
    }

    if (Platform.isAndroid) {
      try {
        // Get the public Downloads directory
        final downloadsPath =
            await ExternalPath.getExternalStoragePublicDirectory(
              ExternalPath.DIRECTORY_DOWNLOAD,
            );
        final downloadDir = Directory('$downloadsPath/ManagementDoc');

        if (!await downloadDir.exists()) {
          await downloadDir.create(recursive: true);
        }

        debugPrint('📁 Download directory: ${downloadDir.path}');
        return downloadDir;
      } catch (e) {
        debugPrint('❌ Failed to access Downloads directory: $e');

        // Fallback 1: Try standard Downloads path
        try {
          final standardDownloads = Directory(
            '/storage/emulated/0/Download/ManagementDoc',
          );
          if (!await standardDownloads.exists()) {
            await standardDownloads.create(recursive: true);
          }
          debugPrint(
            '📁 Fallback download directory: ${standardDownloads.path}',
          );
          return standardDownloads;
        } catch (e2) {
          debugPrint('❌ Standard Downloads also failed: $e2');

          // Fallback 2: App external storage
          try {
            final externalDir = await getExternalStorageDirectory();
            if (externalDir != null) {
              final downloadDir = Directory('${externalDir.path}/Downloads');
              if (!await downloadDir.exists()) {
                await downloadDir.create(recursive: true);
              }
              debugPrint('📁 External storage directory: ${downloadDir.path}');
              return downloadDir;
            }
          } catch (e3) {
            debugPrint('❌ External storage failed: $e3');
          }

          // Final fallback: App documents directory
          final appDir = await getApplicationDocumentsDirectory();
          final downloadDir = Directory('${appDir.path}/Downloads');
          if (!await downloadDir.exists()) {
            await downloadDir.create(recursive: true);
          }
          debugPrint('📁 App documents directory: ${downloadDir.path}');
          return downloadDir;
        }
      }
    } else if (Platform.isIOS) {
      // iOS: Use app documents directory
      final appDir = await getApplicationDocumentsDirectory();
      final downloadDir = Directory('${appDir.path}/Downloads');
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }
      debugPrint('📁 iOS download directory: ${downloadDir.path}');
      return downloadDir;
    } else {
      // Other platforms: use app documents directory
      final appDir = await getApplicationDocumentsDirectory();
      debugPrint('📁 Other platform directory: ${appDir.path}');
      return appDir;
    }
  }

  /// Create unique filename to avoid conflicts
  String _createUniqueFileName(String originalName, Directory saveDir) {
    String fileName = originalName;
    String nameWithoutExt = fileName;
    String extension = '';

    // Extract extension
    final lastDotIndex = fileName.lastIndexOf('.');
    if (lastDotIndex != -1) {
      nameWithoutExt = fileName.substring(0, lastDotIndex);
      extension = fileName.substring(lastDotIndex);
    }

    // Check if file already exists and create unique name
    int counter = 1;
    while (File('${saveDir.path}/$fileName').existsSync()) {
      fileName = '${nameWithoutExt}_$counter$extension';
      counter++;
    }

    return fileName;
  }

  /// Get readable file size string
  static String getReadableFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Check if file exists in downloads
  Future<bool> isFileDownloaded(DocumentModel document) async {
    try {
      final saveDir = await _getSaveDirectory(null);
      final filePath = '${saveDir.path}/${document.fileName}';
      return File(filePath).existsSync();
    } catch (e) {
      return false;
    }
  }

  /// Get downloaded file path if exists
  Future<String?> getDownloadedFilePath(DocumentModel document) async {
    try {
      final saveDir = await _getSaveDirectory(null);
      final filePath = '${saveDir.path}/${document.fileName}';
      if (File(filePath).existsSync()) {
        return filePath;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get user-friendly download location description
  Future<String> getDownloadLocationDescription() async {
    try {
      final saveDir = await _getSaveDirectory(null);
      final path = saveDir.path;

      if (Platform.isAndroid) {
        if (path.contains('/storage/emulated/0/Download')) {
          return 'Downloads > ManagementDoc';
        } else if (path.contains('/Android/data/')) {
          return 'App Storage > Downloads';
        } else {
          return 'Internal Storage > ${path.split('/').last}';
        }
      } else if (Platform.isIOS) {
        return 'App Documents > Downloads';
      } else {
        return 'Documents';
      }
    } catch (e) {
      return 'App Storage';
    }
  }

  /// Get the actual download directory path for debugging
  Future<String> getDownloadDirectoryPath() async {
    try {
      final saveDir = await _getSaveDirectory(null);
      return saveDir.path;
    } catch (e) {
      return 'Unknown';
    }
  }

  /// Check if we can access public Downloads directory
  Future<bool> canAccessPublicDownloads() async {
    if (!Platform.isAndroid) return false;

    try {
      final downloadsPath =
          await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOAD,
          );
      final testDir = Directory('$downloadsPath/ManagementDoc');

      // Try to create directory to test access
      if (!await testDir.exists()) {
        await testDir.create(recursive: true);
      }

      return await testDir.exists();
    } catch (e) {
      return false;
    }
  }

  /// Dispose resources
  void dispose() {
    // Cancel all ongoing downloads
    for (final token in _downloadTokens.values) {
      if (!token.isCancelled) {
        token.cancel('Service disposed');
      }
    }
    _downloadTokens.clear();
    _dio.close();
  }
}
