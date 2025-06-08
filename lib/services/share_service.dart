import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../models/document_model.dart';
import '../core/services/cloud_functions_service.dart';
import '../core/services/firebase_service.dart';

enum ShareType { fileInfo, shareableLink, fileDetails }

class ShareService {
  static final ShareService _instance = ShareService._internal();
  factory ShareService() => _instance;
  ShareService._internal();

  final CloudFunctionsService _cloudFunctions = CloudFunctionsService.instance;
  final FirebaseService _firebaseService = FirebaseService.instance;

  /// Share file information as text
  Future<void> shareFileInfo(DocumentModel document) async {
    try {
      final fileInfo = _generateFileInfoText(document);

      await Share.share(fileInfo, subject: 'Document: ${document.fileName}');
    } catch (e) {
      debugPrint('❌ Failed to share file info: $e');
      rethrow;
    }
  }

  /// Share file with a temporary access link
  Future<void> shareFileWithLink({
    required DocumentModel document,
    Duration? linkExpiration,
    String? customMessage,
  }) async {
    try {
      // Validate document data
      if (document.fileName.trim().isEmpty) {
        throw ArgumentError('Document file name is empty or invalid');
      }

      debugPrint('🔄 Sharing file: ${document.fileName}');
      debugPrint('📁 Original file path: "${document.filePath}"');
      debugPrint('📊 File size: ${document.fileSize}');
      debugPrint('🏷️ File type: ${document.fileType}');
      debugPrint('🆔 Document ID: ${document.id}');
      debugPrint('👤 Uploaded by: ${document.uploadedBy}');
      debugPrint('📅 Uploaded at: ${document.uploadedAt}');
      debugPrint('📂 Category: ${document.category}');

      // Try to get access URL using multiple fallback strategies
      String? accessUrl;

      try {
        // Strategy 1: Try using Cloud Functions if available
        accessUrl = await _tryCloudFunctionsUrl(document, linkExpiration);
      } catch (e) {
        debugPrint('⚠️ Cloud Functions URL generation failed: $e');

        try {
          // Strategy 2: Try direct Firebase Storage signed URL
          accessUrl = await _tryDirectStorageUrl(document, linkExpiration);
        } catch (e2) {
          debugPrint('⚠️ Direct Storage URL generation failed: $e2');

          // Strategy 3: Fallback to sharing file info without URL
          debugPrint('🔄 Falling back to sharing file information only');
          await shareFileInfo(document);
          return;
        }
      }

      if (accessUrl != null) {
        final shareText = _generateShareTextWithLink(
          document: document,
          accessUrl: accessUrl,
          customMessage: customMessage,
          expiration: linkExpiration ?? const Duration(hours: 24),
        );

        await Share.share(
          shareText,
          subject: 'Shared Document: ${document.fileName}',
        );

        debugPrint('✅ File shared successfully with URL: ${document.fileName}');
      } else {
        // Final fallback: share file info only
        debugPrint('🔄 No URL available, sharing file info only');
        await shareFileInfo(document);
      }
    } catch (e) {
      debugPrint('❌ Failed to share file: $e');
      debugPrint('📄 Document details: ${document.toString()}');

      // Final fallback: try to share basic file info
      try {
        await shareFileInfo(document);
        debugPrint('✅ Shared file info as fallback');
      } catch (fallbackError) {
        debugPrint('❌ Even fallback sharing failed: $fallbackError');
        rethrow;
      }
    }
  }

  /// Try to get file URL using Cloud Functions
  Future<String?> _tryCloudFunctionsUrl(
    DocumentModel document,
    Duration? linkExpiration,
  ) async {
    final filePaths = _generatePossibleFilePaths(document);
    debugPrint(
      '🔍 Trying ${filePaths.length} possible file paths with Cloud Functions...',
    );

    // Try each possible path
    for (int i = 0; i < filePaths.length; i++) {
      final filePath = filePaths[i];
      debugPrint(
        '🔄 Cloud Functions attempt ${i + 1}: Trying path "$filePath"',
      );

      try {
        final accessUrl = await _cloudFunctions.getFileAccessUrl(
          filePath: filePath,
          expiration: linkExpiration ?? const Duration(hours: 24),
        );
        debugPrint('✅ Cloud Functions success with path: $filePath');
        return accessUrl;
      } catch (e) {
        debugPrint('❌ Cloud Functions failed with path "$filePath": $e');
        continue;
      }
    }

    // If all constructed paths fail, search Firebase Storage
    debugPrint(
      '🔍 All constructed paths failed, searching Firebase Storage...',
    );
    final foundPath = await _searchForFileInStorage(document);
    if (foundPath != null) {
      debugPrint('🎯 Found file at: $foundPath');
      try {
        return await _cloudFunctions.getFileAccessUrl(
          filePath: foundPath,
          expiration: linkExpiration ?? const Duration(hours: 24),
        );
      } catch (e) {
        debugPrint('❌ Cloud Functions failed with found path: $e');
        rethrow;
      }
    }

    throw Exception('File not found in Firebase Storage: ${document.fileName}');
  }

  /// Try to get file URL using direct Firebase Storage
  Future<String?> _tryDirectStorageUrl(
    DocumentModel document,
    Duration? linkExpiration,
  ) async {
    final filePaths = _generatePossibleFilePaths(document);
    debugPrint('🔍 Trying direct Firebase Storage URLs...');

    // Try each possible path
    for (int i = 0; i < filePaths.length; i++) {
      final filePath = filePaths[i];
      debugPrint('🔄 Direct Storage attempt ${i + 1}: Trying path "$filePath"');

      try {
        final fileRef = _firebaseService.storage.ref(filePath);
        final downloadUrl = await fileRef.getDownloadURL();
        debugPrint('✅ Direct Storage success with path: $filePath');
        return downloadUrl;
      } catch (e) {
        debugPrint('❌ Direct Storage failed with path "$filePath": $e');
        continue;
      }
    }

    // Search for file in storage
    final foundPath = await _searchForFileInStorage(document);
    if (foundPath != null) {
      try {
        final fileRef = _firebaseService.storage.ref(foundPath);
        final downloadUrl = await fileRef.getDownloadURL();
        debugPrint('✅ Direct Storage success with found path: $foundPath');
        return downloadUrl;
      } catch (e) {
        debugPrint('❌ Direct Storage failed with found path: $e');
        rethrow;
      }
    }

    throw Exception(
      'File not found for direct Storage access: ${document.fileName}',
    );
  }

  /// Share detailed file information
  Future<void> shareFileDetails({
    required DocumentModel document,
    String? ownerName,
  }) async {
    try {
      final detailsText = _generateDetailedFileInfo(
        document: document,
        ownerName: ownerName,
      );

      await Share.share(
        detailsText,
        subject: 'Document Details: ${document.fileName}',
      );
    } catch (e) {
      debugPrint('❌ Failed to share file details: $e');
      rethrow;
    }
  }

  /// Share multiple files information
  Future<void> shareMultipleFiles(List<DocumentModel> documents) async {
    try {
      final multiFileText = _generateMultipleFilesText(documents);

      await Share.share(
        multiFileText,
        subject: 'Shared Documents (${documents.length} files)',
      );
    } catch (e) {
      debugPrint('❌ Failed to share multiple files: $e');
      rethrow;
    }
  }

  /// Generate basic file information text
  String _generateFileInfoText(DocumentModel document) {
    return '''
📄 Document: ${document.fileName}

📊 File Details:
• Type: ${document.fileType.toUpperCase()}
• Size: ${_formatFileSize(document.fileSize)}
• Category: ${document.category}
• Status: ${document.status.toUpperCase()}
• Uploaded: ${_formatDate(document.uploadedAt)}

Shared via Management Doc App
''';
  }

  /// Generate share text with access link
  String _generateShareTextWithLink({
    required DocumentModel document,
    required String accessUrl,
    String? customMessage,
    required Duration expiration,
  }) {
    final expirationText = _formatDuration(expiration);

    return '''
${customMessage ?? '📄 I\'m sharing a document with you:'}

📄 ${document.fileName}
📊 ${document.fileType.toUpperCase()} • ${_formatFileSize(document.fileSize)}

🔗 Access Link: $accessUrl

⏰ This link expires in $expirationText
📱 Shared via Management Doc App
''';
  }

  /// Generate detailed file information
  String _generateDetailedFileInfo({
    required DocumentModel document,
    String? ownerName,
  }) {
    return '''
📄 Document Details

📋 Basic Information:
• Name: ${document.fileName}
• Type: ${document.fileType.toUpperCase()}
• Size: ${_formatFileSize(document.fileSize)}
• Category: ${document.category}

👤 Ownership:
• Owner: ${ownerName ?? document.uploadedBy}
• Uploaded: ${_formatDate(document.uploadedAt)}

📊 Status Information:
• Status: ${document.status.toUpperCase()}
${document.approvedBy != null ? '• Approved by: ${document.approvedBy}' : ''}
${document.approvedAt != null ? '• Approved: ${_formatDate(document.approvedAt!)}' : ''}

${document.metadata.description.isNotEmpty ? '📝 Description:\n${document.metadata.description}\n' : ''}
${document.metadata.tags.isNotEmpty ? '🏷️ Tags: ${document.metadata.tags.join(', ')}\n' : ''}

📱 Shared via Management Doc App
''';
  }

  /// Generate text for multiple files
  String _generateMultipleFilesText(List<DocumentModel> documents) {
    final buffer = StringBuffer();
    buffer.writeln('📄 Shared Documents (${documents.length} files)\n');

    for (int i = 0; i < documents.length; i++) {
      final doc = documents[i];
      buffer.writeln('${i + 1}. ${doc.fileName}');
      buffer.writeln(
        '   ${doc.fileType.toUpperCase()} • ${_formatFileSize(doc.fileSize)}',
      );
      buffer.writeln('   Category: ${doc.category}');
      if (i < documents.length - 1) buffer.writeln();
    }

    buffer.writeln('\n📱 Shared via Management Doc App');
    return buffer.toString();
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

  /// Format date in readable format
  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy • HH:mm').format(date);
  }

  /// Format duration in readable format
  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} day${duration.inDays > 1 ? 's' : ''}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}';
    } else {
      return '${duration.inMinutes} minute${duration.inMinutes > 1 ? 's' : ''}';
    }
  }

  /// Get appropriate share type icon
  static IconData getShareIcon(ShareType type) {
    switch (type) {
      case ShareType.fileInfo:
        return Icons.info_outline;
      case ShareType.shareableLink:
        return Icons.link;
      case ShareType.fileDetails:
        return Icons.description;
    }
  }

  /// Get share type display name
  static String getShareTypeName(ShareType type) {
    switch (type) {
      case ShareType.fileInfo:
        return 'File Info';
      case ShareType.shareableLink:
        return 'Share Link';
      case ShareType.fileDetails:
        return 'Full Details';
    }
  }

  /// Generate possible file paths based on different upload patterns
  List<String> _generatePossibleFilePaths(DocumentModel document) {
    final paths = <String>[];
    final fileName = document.fileName;
    final sanitizedFileName = _sanitizeFileName(fileName);
    final timestamp = document.uploadedAt.millisecondsSinceEpoch;
    final userId = document.uploadedBy;
    final category = document.category;

    // 1. Use the original filePath if available and not empty
    if (document.filePath.trim().isNotEmpty) {
      paths.add(document.filePath.trim());
    }

    // 2. Pattern: documents/{userId}/{timestamp}_{fileName}
    paths.add('documents/$userId/${timestamp}_$fileName');
    paths.add('documents/$userId/${timestamp}_$sanitizedFileName');

    // 3. Pattern: documents/categories/{categoryId}/{timestamp}_{fileName}
    if (category.isNotEmpty && category != 'uncategorized') {
      paths.add('documents/categories/$category/${timestamp}_$fileName');
      paths.add(
        'documents/categories/$category/${timestamp}_$sanitizedFileName',
      );
    }

    // 4. Pattern: documents/uncategorized/{timestamp}_{fileName}
    paths.add('documents/uncategorized/${timestamp}_$fileName');
    paths.add('documents/uncategorized/${timestamp}_$sanitizedFileName');

    // 5. Pattern: documents/{timestamp}_{fileName} (flat structure)
    paths.add('documents/${timestamp}_$fileName');
    paths.add('documents/${timestamp}_$sanitizedFileName');

    // 6. Pattern: documents/{fileName} (simple structure)
    paths.add('documents/$fileName');
    paths.add('documents/$sanitizedFileName');

    // 7. Pattern with document ID
    paths.add('documents/${document.id}_$fileName');
    paths.add('documents/${document.id}_$sanitizedFileName');

    // Remove duplicates while preserving order
    final uniquePaths = <String>[];
    for (final path in paths) {
      if (!uniquePaths.contains(path)) {
        uniquePaths.add(path);
      }
    }

    return uniquePaths;
  }

  /// Sanitize filename for storage (matching upload service logic)
  String _sanitizeFileName(String fileName) {
    return fileName
        .replaceAll(RegExp(r'[^\w\s\-\.]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
  }

  /// Search for a file in Firebase Storage by document information
  Future<String?> _searchForFileInStorage(DocumentModel document) async {
    try {
      final fileName = document.fileName;
      final sanitizedFileName = _sanitizeFileName(fileName);
      debugPrint('🔍 Searching for file in Firebase Storage: $fileName');
      debugPrint('🔍 Also searching for sanitized name: $sanitizedFileName');

      // Search in common directories with comprehensive subdirectory search
      final searchPaths = [
        'documents/',
        'documents/categories/',
        'documents/uncategorized/',
        'uploads/',
        'files/',
      ];

      for (final basePath in searchPaths) {
        try {
          final foundPath = await _searchInPath(
            basePath,
            fileName,
            sanitizedFileName,
          );
          if (foundPath != null) {
            return foundPath;
          }
        } catch (e) {
          debugPrint('⚠️ Error searching in $basePath: $e');
          continue;
        }
      }

      // Try searching with timestamp patterns
      final timestamp = document.uploadedAt.millisecondsSinceEpoch;
      final timestampPatterns = [
        '${timestamp}_$fileName',
        '${timestamp}_$sanitizedFileName',
      ];

      for (final pattern in timestampPatterns) {
        for (final basePath in searchPaths) {
          try {
            final foundPath = await _searchInPath(basePath, pattern, pattern);
            if (foundPath != null) {
              return foundPath;
            }
          } catch (e) {
            debugPrint(
              '⚠️ Error searching for pattern $pattern in $basePath: $e',
            );
            continue;
          }
        }
      }

      debugPrint('❌ File not found in Firebase Storage: $fileName');
      return null;
    } catch (e) {
      debugPrint('❌ Error searching for file: $e');
      return null;
    }
  }

  /// Search for files in a specific path
  Future<String?> _searchInPath(
    String basePath,
    String fileName,
    String altFileName,
  ) async {
    try {
      final listResult = await _firebaseService.storage.ref(basePath).listAll();

      // Search in direct files
      for (final item in listResult.items) {
        if (item.name == fileName || item.name == altFileName) {
          debugPrint('🎯 Found file: ${item.fullPath}');
          return item.fullPath;
        }
        // Also check if the file name contains the target name (for timestamped files)
        if (item.name.contains(fileName) || item.name.contains(altFileName)) {
          debugPrint('🎯 Found file with pattern match: ${item.fullPath}');
          return item.fullPath;
        }
      }

      // Search in subdirectories (up to 2 levels deep)
      for (final prefix in listResult.prefixes) {
        try {
          final subListResult = await prefix.listAll();
          for (final item in subListResult.items) {
            if (item.name == fileName || item.name == altFileName) {
              debugPrint('🎯 Found file in subdirectory: ${item.fullPath}');
              return item.fullPath;
            }
            // Also check if the file name contains the target name
            if (item.name.contains(fileName) ||
                item.name.contains(altFileName)) {
              debugPrint(
                '🎯 Found file with pattern match in subdirectory: ${item.fullPath}',
              );
              return item.fullPath;
            }
          }

          // Search one more level deep
          for (final subPrefix in subListResult.prefixes) {
            try {
              final deepListResult = await subPrefix.listAll();
              for (final item in deepListResult.items) {
                if (item.name == fileName || item.name == altFileName) {
                  debugPrint(
                    '🎯 Found file in deep subdirectory: ${item.fullPath}',
                  );
                  return item.fullPath;
                }
                if (item.name.contains(fileName) ||
                    item.name.contains(altFileName)) {
                  debugPrint(
                    '🎯 Found file with pattern match in deep subdirectory: ${item.fullPath}',
                  );
                  return item.fullPath;
                }
              }
            } catch (e) {
              debugPrint(
                '⚠️ Error searching in deep subdirectory ${subPrefix.fullPath}: $e',
              );
              continue;
            }
          }
        } catch (e) {
          debugPrint(
            '⚠️ Error searching in subdirectory ${prefix.fullPath}: $e',
          );
          continue;
        }
      }

      return null;
    } catch (e) {
      debugPrint('⚠️ Error searching in path $basePath: $e');
      return null;
    }
  }
}
