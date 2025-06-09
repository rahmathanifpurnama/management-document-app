import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../models/document_model.dart';
import 'google_drive_service.dart';

/// Simplified service for sharing documents via Google Drive links only
class ShareService {
  static final ShareService _instance = ShareService._internal();
  factory ShareService() => _instance;
  ShareService._internal();

  final GoogleDriveService _googleDriveService = GoogleDriveService();

  /// Share Google Drive link for document
  Future<void> shareGoogleDriveLink(DocumentModel document) async {
    try {
      // Check if document has Google Drive file ID
      if (document.filePath.isEmpty) {
        throw Exception('Document does not have a Google Drive file ID');
      }

      // Generate Google Drive shareable link
      final shareableLink = _googleDriveService.getShareableLink(
        document.filePath,
      );

      final shareText = _generateGoogleDriveShareText(document, shareableLink);

      await Share.share(
        shareText,
        subject: 'Shared Document: ${document.fileName}',
      );

      debugPrint(
        '✅ Google Drive link shared successfully: ${document.fileName}',
      );
    } catch (e) {
      debugPrint('❌ Failed to share Google Drive link: $e');
      rethrow;
    }
  }

  /// Legacy method for backward compatibility - now uses Google Drive
  Future<void> shareFileWithLink({
    required DocumentModel document,
    Duration? linkExpiration,
    String? customMessage,
  }) async {
    await shareGoogleDriveLink(document);
  }

  /// Legacy method for backward compatibility - now uses Google Drive
  Future<void> shareFileInfo(DocumentModel document) async {
    await shareGoogleDriveLink(document);
  }

  /// Legacy method for backward compatibility - now uses Google Drive
  Future<void> shareFileDetails({
    required DocumentModel document,
    String? ownerName,
  }) async {
    await shareGoogleDriveLink(document);
  }

  /// Legacy method for bulk sharing - now uses Google Drive
  Future<void> shareBulkFiles({
    required List<DocumentModel> documents,
    Duration? linkExpiration,
    String? customMessage,
  }) async {
    if (documents.isEmpty) {
      throw ArgumentError('No documents provided for sharing');
    }

    try {
      debugPrint(
        '🔄 Starting bulk Google Drive share for ${documents.length} files',
      );

      // Generate share text for all files
      final buffer = StringBuffer();
      buffer.writeln('📄 Shared Documents (${documents.length} files)\n');

      for (int i = 0; i < documents.length; i++) {
        final doc = documents[i];
        final shareableLink = _googleDriveService.getShareableLink(
          doc.filePath,
        );

        buffer.writeln('${i + 1}. ${doc.fileName}');
        buffer.writeln(
          '   ${doc.fileType.toUpperCase()} • ${_formatFileSize(doc.fileSize)}',
        );
        buffer.writeln('   🔗 Google Drive Link: $shareableLink');
        if (i < documents.length - 1) buffer.writeln();
      }

      buffer.writeln('\n📱 Shared via Management Doc App');

      await Share.share(
        buffer.toString(),
        subject: 'Shared Documents (${documents.length} files)',
      );

      debugPrint('✅ Bulk Google Drive share completed successfully');
    } catch (e) {
      debugPrint('❌ Bulk Google Drive share failed: $e');
      rethrow;
    }
  }

  /// Generate share text for Google Drive link
  String _generateGoogleDriveShareText(
    DocumentModel document,
    String shareableLink,
  ) {
    return '''
📄 I'm sharing a document with you:

📄 ${document.fileName}
📊 ${document.fileType.toUpperCase()} • ${_formatFileSize(document.fileSize)}
📂 Category: ${document.category}

🔗 Google Drive Link: $shareableLink

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
