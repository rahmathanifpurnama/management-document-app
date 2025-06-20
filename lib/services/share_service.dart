import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/document_model.dart';
import 'google_drive_service.dart';

/// Enhanced service for sharing documents via Google Drive upload
class ShareService {
  static final ShareService _instance = ShareService._internal();
  factory ShareService() => _instance;
  ShareService._internal();

  final GoogleDriveService _googleDriveService = GoogleDriveService();

  /// Share document by uploading to Google Drive and sharing the link
  Future<void> shareGoogleDriveLink(
    DocumentModel document, {
    Function(double progress)? onProgress,
  }) async {
    try {
      debugPrint('🔄 Starting Google Drive share for: ${document.fileName}');

      // Check if document has file path
      if (document.filePath.isEmpty) {
        throw Exception('Document does not have a file path');
      }

      // Initialize Google Drive service
      await _googleDriveService.initialize();
      onProgress?.call(0.1);

      String shareableLink;

      // Check if filePath is already a Google Drive file ID
      if (_isGoogleDriveFileId(document.filePath)) {
        // Use existing Google Drive link
        shareableLink = _googleDriveService.getShareableLink(document.filePath);
        onProgress?.call(0.9);
      } else {
        // Upload file to Google Drive first
        debugPrint('📤 Uploading file to Google Drive...');

        final fileId = await _googleDriveService.uploadDocumentToGoogleDrive(
          document,
          onProgress: (uploadProgress) {
            // Map upload progress to 10-80% of total progress
            onProgress?.call(0.1 + (uploadProgress * 0.7));
          },
        );

        if (fileId == null) {
          throw Exception('Failed to upload file to Google Drive');
        }

        // Generate shareable link from uploaded file
        shareableLink = _googleDriveService.getShareableLink(fileId);
        onProgress?.call(0.9);
      }

      // Share the Google Drive link
      final shareText = _generateShareText(document, shareableLink);

      await Share.share(
        shareText,
        subject: 'Shared Document: ${document.displayFileName}',
      );

      onProgress?.call(1.0);
      debugPrint(
        '✅ Document shared via Google Drive successfully: ${document.fileName}',
      );
    } catch (e) {
      debugPrint('❌ Failed to share document via Google Drive: $e');
      rethrow;
    }
  }

  /// Legacy method for backward compatibility - now uses Google Drive upload
  Future<void> shareFileWithLink({
    required DocumentModel document,
    Duration? linkExpiration,
    String? customMessage,
    Function(double progress)? onProgress,
  }) async {
    await shareGoogleDriveLink(document, onProgress: onProgress);
  }

  /// Legacy method for backward compatibility - now uses Google Drive upload
  Future<void> shareFileInfo(
    DocumentModel document, {
    Function(double progress)? onProgress,
  }) async {
    await shareGoogleDriveLink(document, onProgress: onProgress);
  }

  /// Legacy method for backward compatibility - now uses Google Drive upload
  Future<void> shareFileDetails({
    required DocumentModel document,
    String? ownerName,
    Function(double progress)? onProgress,
  }) async {
    await shareGoogleDriveLink(document, onProgress: onProgress);
  }

  /// Enhanced bulk sharing with Google Drive upload
  Future<void> shareBulkFiles({
    required List<DocumentModel> documents,
    Duration? linkExpiration,
    String? customMessage,
    Function(int completed, int total, String currentFile)? onProgress,
  }) async {
    if (documents.isEmpty) {
      throw ArgumentError('No documents provided for sharing');
    }

    try {
      debugPrint(
        '🔄 Starting bulk Google Drive upload and share for ${documents.length} files',
      );

      // Initialize Google Drive service
      await _googleDriveService.initialize();

      // Upload all files to Google Drive
      final uploadedIds = await _googleDriveService.uploadMultipleDocuments(
        documents,
        onProgress: onProgress,
      );

      if (uploadedIds.isEmpty) {
        throw Exception('Failed to upload any files to Google Drive');
      }

      // Generate share text for all uploaded files
      final buffer = StringBuffer();
      buffer.writeln('📄 Shared Documents (${uploadedIds.length} files)\n');

      for (int i = 0; i < documents.length && i < uploadedIds.length; i++) {
        final doc = documents[i];
        final fileId = uploadedIds[i];
        final shareableLink = _googleDriveService.getShareableLink(fileId);

        buffer.writeln('${i + 1}. ${doc.displayFileName}');
        buffer.writeln(
          '   ${doc.fileType.toUpperCase()} • ${_formatFileSize(doc.fileSize)}',
        );
        buffer.writeln('   🔗 Google Drive Link: $shareableLink');
        if (i < uploadedIds.length - 1) buffer.writeln();
      }

      if (customMessage != null && customMessage.isNotEmpty) {
        buffer.writeln('\n📝 Message: $customMessage');
      }

      buffer.writeln('\n✨ Files uploaded to your Google Drive and shared!');

      await Share.share(
        buffer.toString(),
        subject:
            'Shared Documents via Google Drive (${uploadedIds.length} files)',
      );

      debugPrint(
        '✅ Bulk Google Drive share completed for ${uploadedIds.length} files',
      );
    } catch (e) {
      debugPrint('❌ Failed to bulk share files via Google Drive: $e');
      rethrow;
    }
  }

  /// Check if filePath is a Google Drive file ID
  bool _isGoogleDriveFileId(String filePath) {
    // Google Drive file IDs are typically 25-44 characters long, alphanumeric with some special chars
    // Firebase Storage paths contain slashes and are longer
    return !filePath.contains('/') &&
        filePath.length >= 25 &&
        filePath.length <= 44 &&
        RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(filePath);
  }

  /// Generate share text for Google Drive document link
  String _generateShareText(DocumentModel document, String shareableLink) {
    return '''
📄 I'm sharing a document with you via Google Drive:

📄 ${document.displayFileName}
📊 ${document.fileType.toUpperCase()} • ${_formatFileSize(document.fileSize)}
📂 Category: ${document.category}

🔗 Google Drive Link: $shareableLink

✨ This file has been uploaded to Google Drive for easy access!
📱 Shared via Management Doc App
''';
  }

  /// Format file size in human readable format
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Get Google Drive icon
  static IconData getShareIcon(ShareType? type) {
    return Icons.drive_file_move;
  }

  /// Get share type display name
  static String getShareTypeName(ShareType? type) {
    return 'Google Drive Link';
  }
}

/// Legacy enum for backward compatibility
enum ShareType { fileInfo, shareableLink, fileDetails }
