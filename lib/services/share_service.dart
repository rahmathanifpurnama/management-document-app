import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/document_model.dart';
import 'google_drive_service.dart';

/// Simplified service for sharing documents via Google Drive links only
class ShareService {
  static final ShareService _instance = ShareService._internal();
  factory ShareService() => _instance;
  ShareService._internal();

  final GoogleDriveService _googleDriveService = GoogleDriveService();

  /// Share document link (Firebase Storage or Google Drive)
  Future<void> shareGoogleDriveLink(DocumentModel document) async {
    try {
      // Check if document has file path
      if (document.filePath.isEmpty) {
        throw Exception('Document does not have a file path');
      }

      String shareableLink;

      // Check if filePath is a Google Drive file ID (short alphanumeric string)
      if (_isGoogleDriveFileId(document.filePath)) {
        // Use Google Drive link
        shareableLink = _googleDriveService.getShareableLink(document.filePath);
      } else {
        // Generate Firebase Storage download link
        shareableLink = await _getFirebaseStorageDownloadUrl(document.filePath);
      }

      final shareText = _generateShareText(document, shareableLink);

      await Share.share(
        shareText,
        subject: 'Shared Document: ${document.fileName}',
      );

      debugPrint('✅ Document link shared successfully: ${document.fileName}');
    } catch (e) {
      debugPrint('❌ Failed to share document link: $e');
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

        String shareableLink;
        if (_isGoogleDriveFileId(doc.filePath)) {
          shareableLink = _googleDriveService.getShareableLink(doc.filePath);
        } else {
          shareableLink = await _getFirebaseStorageDownloadUrl(doc.filePath);
        }

        buffer.writeln('${i + 1}. ${doc.fileName}');
        buffer.writeln(
          '   ${doc.fileType.toUpperCase()} • ${_formatFileSize(doc.fileSize)}',
        );
        buffer.writeln('   🔗 Download Link: $shareableLink');
        if (i < documents.length - 1) buffer.writeln();
      }

      buffer.writeln('\n📱 Shared via Management Doc App');

      await Share.share(
        buffer.toString(),
        subject: 'Shared Documents (${documents.length} files)',
      );

      debugPrint('✅ Bulk document share completed successfully');
    } catch (e) {
      debugPrint('❌ Bulk document share failed: $e');
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

  /// Get Firebase Storage download URL
  Future<String> _getFirebaseStorageDownloadUrl(String filePath) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(filePath);
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint('❌ Failed to get Firebase Storage download URL: $e');
      // Fallback: return a generic Firebase Storage URL (may not work without proper permissions)
      return 'https://firebasestorage.googleapis.com/v0/b/document-management-c5a96.firebasestorage.app/o/${Uri.encodeComponent(filePath)}?alt=media';
    }
  }

  /// Generate share text for document link
  String _generateShareText(DocumentModel document, String shareableLink) {
    return '''
📄 I'm sharing a document with you:

📄 ${document.fileName}
📊 ${document.fileType.toUpperCase()} • ${_formatFileSize(document.fileSize)}
📂 Category: ${document.category}

🔗 Download Link: $shareableLink

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
