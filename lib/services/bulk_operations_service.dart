import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/document_model.dart';
import '../providers/document_provider.dart';
import '../providers/auth_provider.dart';
import '../services/file_download_service.dart';
import '../services/share_service.dart';
import '../services/download_notification_service.dart';
import '../core/constants/app_colors.dart';
import 'deletion_diagnostics_service.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/google_drive_service.dart';
import '../widgets/dialogs/share_message_editor_dialog.dart';

/// Service for handling bulk operations on selected files
class BulkOperationsService {
  static final BulkOperationsService _instance =
      BulkOperationsService._internal();
  factory BulkOperationsService() => _instance;
  BulkOperationsService._internal();

  /// Show bulk operations menu
  static void showBulkOperationsMenu({
    required BuildContext context,
    required List<DocumentModel> selectedFiles,
    required VoidCallback onOperationComplete,
    String? categoryId, // Optional category ID for folder-specific operations
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _BulkOperationsMenu(
        selectedFiles: selectedFiles,
        onOperationComplete: onOperationComplete,
        categoryId: categoryId,
      ),
    );
  }

  /// Download multiple files with parallel processing and native notifications
  static Future<void> downloadSelectedFiles({
    required BuildContext context,
    required List<DocumentModel> files,
  }) async {
    final downloadService = FileDownloadService();
    final notificationService = DownloadNotificationService();
    int completedDownloads = 0;
    int failedDownloads = 0;
    final List<String> failedFiles = [];
    int? bulkNotificationId;
    DocumentModel? bulkDocument;

    try {
      // Initialize notification service
      await notificationService.initialize();
      await notificationService.requestPermissions();

      // Show bulk download started notification with unique identifier
      final bulkDocumentId =
          'bulk_download_${DateTime.now().millisecondsSinceEpoch}';
      bulkDocument = DocumentModel(
        id: bulkDocumentId,
        fileName: 'Bulk Download (${files.length} files)',
        fileSize: files.fold<int>(0, (sum, file) => sum + file.fileSize),
        fileType: 'bulk',
        filePath: 'bulk_download',
        uploadedBy: 'system',
        uploadedAt: DateTime.now(),
        category: 'Downloads',
        permissions: [],
        metadata: DocumentMetadata(
          description: 'Bulk download operation',
          tags: ['bulk', 'download'],
        ),
      );

      bulkNotificationId = await notificationService.showDownloadStarted(
        document: bulkDocument,
        isBulkDownload: true,
        totalFiles: files.length,
      );

      // Process downloads in batches of 3 to prevent overwhelming the system
      const batchSize = 3;
      for (int i = 0; i < files.length; i += batchSize) {
        final batch = files.skip(i).take(batchSize).toList();

        // Process batch in parallel
        final futures = batch.map((file) async {
          try {
            await downloadService.downloadFile(file);
            completedDownloads++;
            debugPrint(
              '✅ Downloaded: ${file.fileName} ($completedDownloads/${files.length})',
            );

            // Update bulk notification progress
            if (bulkNotificationId != null &&
                bulkNotificationId > 0 &&
                bulkDocument != null) {
              final progress = completedDownloads / files.length;
              await notificationService.updateDownloadProgress(
                notificationId: bulkNotificationId,
                document: bulkDocument,
                progress: progress,
                isBulkDownload: true,
                completedFiles: completedDownloads,
                totalFiles: files.length,
              );
            }
          } catch (e) {
            failedDownloads++;
            failedFiles.add(file.fileName);
            debugPrint('❌ Failed to download: ${file.fileName} - $e');
          }
        });

        // Wait for batch to complete
        await Future.wait(futures);

        // Small delay between batches to prevent overwhelming
        if (i + batchSize < files.length) {
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }

      // Show final result via notification
      if (bulkNotificationId > 0) {
        if (failedDownloads == 0) {
          // All successful
          await notificationService.showDownloadCompleted(
            notificationId: bulkNotificationId,
            document: bulkDocument,
            isBulkDownload: true,
            totalFiles: files.length,
            failedFiles: 0,
          );
        } else {
          // Some failed
          await notificationService.showDownloadCompleted(
            notificationId: bulkNotificationId,
            document: bulkDocument,
            isBulkDownload: true,
            totalFiles: files.length,
            failedFiles: failedDownloads,
          );
        }
      }
    } catch (e) {
      // Show error notification
      if (bulkNotificationId != null &&
          bulkNotificationId > 0 &&
          bulkDocument != null) {
        await notificationService.showDownloadFailed(
          notificationId: bulkNotificationId,
          document: bulkDocument,
          error: e.toString(),
          isBulkDownload: true,
        );
      }

      debugPrint('❌ Bulk download failed: $e');
    }
  }

  /// Analyze file type category for diagnostics
  static String _getFileTypeCategory(String fileType) {
    final lowerFileType = fileType.toLowerCase();
    if (lowerFileType.contains('pdf')) {
      return 'PDF';
    }
    if (lowerFileType.contains('image') ||
        lowerFileType.contains('jpg') ||
        lowerFileType.contains('png')) {
      return 'Image';
    }
    if (lowerFileType.contains('doc')) {
      return 'Document';
    }
    if (lowerFileType.contains('excel') || lowerFileType.contains('sheet')) {
      return 'Spreadsheet';
    }
    return 'Other';
  }

  /// Analyze error patterns to provide better user feedback
  static Map<String, dynamic> _analyzeErrorPatterns(
    Map<String, Map<String, dynamic>> errorDetails,
  ) {
    if (errorDetails.isEmpty) {
      return {};
    }

    final analysis = <String, dynamic>{};
    final errorTypes = <String, int>{};
    final fileTypeErrors = <String, int>{};
    final commonErrors = <String>[];

    // Analyze error types and patterns
    for (final error in errorDetails.values) {
      final errorType = error['errorType'] as String? ?? 'Unknown';
      final fileType = error['fileTypeCategory'] as String? ?? 'Unknown';
      final errorMessage = error['error'] as String? ?? '';

      errorTypes[errorType] = (errorTypes[errorType] ?? 0) + 1;
      fileTypeErrors[fileType] = (fileTypeErrors[fileType] ?? 0) + 1;

      // Identify common error patterns
      if (errorMessage.contains('not-found') ||
          errorMessage.contains('Document not found')) {
        commonErrors.add('File not found in storage');
      } else if (errorMessage.contains('permission') ||
          errorMessage.contains('Access denied')) {
        commonErrors.add('Permission denied');
      } else if (errorMessage.contains('timeout') ||
          errorMessage.contains('deadline')) {
        commonErrors.add('Operation timeout');
      } else if (errorMessage.contains('path') ||
          errorMessage.contains('storage')) {
        commonErrors.add('Storage path issue');
      }
    }

    // Determine most common error type
    if (errorTypes.isNotEmpty) {
      final mostCommonError = errorTypes.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );
      analysis['commonErrorType'] = mostCommonError.key;
      analysis['commonErrorCount'] = mostCommonError.value;
    }

    // Determine most affected file type
    if (fileTypeErrors.isNotEmpty) {
      final mostAffectedType = fileTypeErrors.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );
      analysis['mostAffectedFileType'] = mostAffectedType.key;
      analysis['affectedFileCount'] = mostAffectedType.value;
    }

    // Determine primary issue
    if (commonErrors.isNotEmpty) {
      final errorCounts = <String, int>{};
      for (final error in commonErrors) {
        errorCounts[error] = (errorCounts[error] ?? 0) + 1;
      }
      final primaryIssue = errorCounts.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );
      analysis['primaryIssue'] = primaryIssue.key;
    }

    analysis['totalErrors'] = errorDetails.length;
    analysis['errorTypes'] = errorTypes;
    analysis['fileTypeErrors'] = fileTypeErrors;

    return analysis;
  }

  /// Delete multiple files with parallel processing and error handling
  static Future<void> deleteSelectedFiles({
    required BuildContext context,
    required List<DocumentModel> files,
  }) async {
    // Get providers before any async operations to avoid context issues
    final documentProvider = Provider.of<DocumentProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Run enhanced diagnostics first
    final isAdmin = await authProvider.isCurrentUserAdmin;
    final currentUserId = authProvider.currentUser?.id ?? 'unknown';

    final diagnostics =
        await DeletionDiagnosticsService.analyzeDeletionOperation(
          files: files,
          operationType: 'bulk',
          userId: currentUserId,
          isAdmin: isAdmin,
        );

    // Check if user has admin permissions before proceeding
    if (!isAdmin) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '❌ Access denied: Only administrators can delete files',
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      }
      return;
    }

    // Check context before showing dialog
    if (!context.mounted) return;

    // Show confirmation dialog with risk assessment

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Files',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete ${files.length} files? This action cannot be undone.',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    int completedDeletes = 0;
    int failedDeletes = 0;
    final List<String> failedFiles = [];
    final Map<String, Map<String, dynamic>> errorDetails = {};

    try {
      // Show enhanced progress with diagnostics info
      if (context.mounted) {
        final fileTypeBreakdown =
            diagnostics['fileTypeAnalysis'] as Map<String, dynamic>? ?? {};
        final typeInfo = fileTypeBreakdown.entries
            .map((e) => '${e.key}: ${e.value}')
            .join(', ');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Starting enhanced deletion of ${files.length} files...',
                      ),
                    ),
                  ],
                ),
                if (typeInfo.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Types: $typeInfo',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ],
            ),
            duration: Duration(seconds: files.length * 3),
            backgroundColor: AppColors.warning,
          ),
        );
      }

      // Process deletions in batches of 2 to prevent overwhelming Firebase
      const batchSize = 2;
      for (int i = 0; i < files.length; i += batchSize) {
        final batch = files.skip(i).take(batchSize).toList();

        // Process batch in parallel with enhanced error handling
        final futures = batch.map((file) async {
          try {
            debugPrint(
              '🔄 Enhanced deletion starting for: ${file.fileName} (ID: ${file.id}, Type: ${_getFileTypeCategory(file.fileType)})',
            );

            // Track deletion start time for diagnostics
            final startTime = DateTime.now();

            await documentProvider.removeDocument(file.id, currentUserId);

            final duration = DateTime.now().difference(startTime);
            completedDeletes++;

            debugPrint(
              '✅ Successfully deleted: ${file.fileName} ($completedDeletes/${files.length}) in ${duration.inMilliseconds}ms',
            );

            // Update progress in UI with enhanced information
            if (context.mounted) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Deleted $completedDeletes of ${files.length} files... (${file.fileName})',
                  ),
                  backgroundColor: AppColors.warning,
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          } catch (e) {
            failedDeletes++;
            failedFiles.add(file.fileName);

            // Enhanced error logging with detailed context
            debugPrint('❌ ENHANCED BULK DELETE ERROR for ${file.fileName}:');
            debugPrint('   Error: $e');
            debugPrint('   Error type: ${e.runtimeType}');
            debugPrint('   File ID: ${file.id}');
            debugPrint('   File path: ${file.filePath}');
            debugPrint(
              '   File type: ${file.fileType} (${_getFileTypeCategory(file.fileType)})',
            );
            debugPrint('   User ID: $currentUserId');
            debugPrint(
              '   Batch position: ${batch.indexOf(file) + 1}/${batch.length}',
            );

            // Store detailed error information for potential retry
            errorDetails[file.id] = {
              'error': e.toString(),
              'errorType': e.runtimeType.toString(),
              'fileName': file.fileName,
              'filePath': file.filePath,
              'fileType': file.fileType,
              'fileTypeCategory': _getFileTypeCategory(file.fileType),
              'timestamp': DateTime.now().toIso8601String(),
              'batchPosition': batch.indexOf(file) + 1,
            };
          }
        });

        // Wait for batch to complete
        await Future.wait(futures);

        // Small delay between batches
        if (i + batchSize < files.length) {
          await Future.delayed(const Duration(milliseconds: 800));
        }
      }

      // Enhanced final result reporting with error analysis
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        // Analyze error patterns for better user feedback
        final errorAnalysis = _analyzeErrorPatterns(errorDetails);

        if (failedDeletes == 0) {
          // All successful
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Successfully deleted all ${files.length} files'),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 4),
            ),
          );
        } else if (completedDeletes > 0) {
          // Partial success with enhanced error information
          String errorSummary = '';
          if (errorAnalysis['commonErrorType'] != null) {
            errorSummary =
                '\nCommon issue: ${errorAnalysis['commonErrorType']}';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '⚠️ Deleted $completedDeletes files, $failedDeletes failed\n'
                'Failed: ${failedFiles.take(3).join(', ')}${failedFiles.length > 3 ? '...' : ''}'
                '$errorSummary',
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 8),
              action: SnackBarAction(
                label: 'Retry Failed',
                textColor: Colors.white,
                onPressed: () {
                  final failedDocuments = files
                      .where((f) => failedFiles.contains(f.fileName))
                      .toList();
                  deleteSelectedFiles(context: context, files: failedDocuments);
                },
              ),
            ),
          );
        } else {
          // All failed with diagnostic information
          String diagnosticInfo = '';
          if (errorAnalysis['primaryIssue'] != null) {
            diagnosticInfo =
                '\nPrimary issue: ${errorAnalysis['primaryIssue']}';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Failed to delete all files$diagnosticInfo'),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 6),
              action: SnackBarAction(
                label: 'Retry All',
                textColor: Colors.white,
                onPressed: () {
                  deleteSelectedFiles(context: context, files: files);
                },
              ),
            ),
          );
        }

        // Enhanced results analysis using diagnostics service
        final resultsAnalysis = DeletionDiagnosticsService.analyzeResults(
          totalFiles: files.length,
          successfulDeletions: completedDeletes,
          failedDeletions: failedDeletes,
          errorDetails: errorDetails,
        );

        // Log comprehensive operation summary
        debugPrint('📊 ENHANCED BULK DELETE OPERATION SUMMARY:');
        debugPrint('   Total files: ${files.length}');
        debugPrint('   Successful: $completedDeletes');
        debugPrint('   Failed: $failedDeletes');
        debugPrint('   Success rate: ${resultsAnalysis['successRate']}%');
        if (resultsAnalysis.containsKey('primaryErrorType')) {
          debugPrint(
            '   Primary error: ${resultsAnalysis['primaryErrorType']}',
          );
        }
        if (resultsAnalysis.containsKey('mostAffectedFileType')) {
          debugPrint(
            '   Most affected type: ${resultsAnalysis['mostAffectedFileType']}',
          );
        }
        if (errorAnalysis.isNotEmpty) {
          debugPrint('   Legacy error analysis: $errorAnalysis');
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete files: ${e.toString()}'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () {
                deleteSelectedFiles(context: context, files: files);
              },
            ),
          ),
        );
      }
    }
  }

  /// Remove multiple files from folder (remove file-folder association)
  static Future<void> removeFromFolderSelectedFiles({
    required BuildContext context,
    required List<DocumentModel> files,
    required String categoryId,
  }) async {
    debugPrint(
      '🚀 Starting bulk remove operation for ${files.length} files from category $categoryId',
    );

    // Get the provider before any async operations
    final documentProvider = Provider.of<DocumentProvider>(
      context,
      listen: false,
    );

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Remove Files from Folder',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to remove ${files.length} files from this folder?\n\n• Files will NOT be deleted\n• Files will become uncategorized\n• Files can be found in "Add Files to Category"\n• Recent Files will NOT be affected',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Remove',
              style: GoogleFonts.poppins(
                color: Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      // Show progress
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Removing ${files.length} files from folder...'),
                ),
              ],
            ),
            duration: Duration(seconds: files.length * 2),
            backgroundColor: AppColors.warning,
          ),
        );
      }

      // Remove each file from folder (move to uncategorized)
      int successCount = 0;
      int failureCount = 0;

      for (final file in files) {
        try {
          debugPrint(
            '🔄 Removing file ${file.fileName} (${file.id}) from category $categoryId',
          );
          await documentProvider.removeFileFromCategory(file.id, categoryId);
          successCount++;
          debugPrint('✅ Successfully removed ${file.fileName} from category');
        } catch (e) {
          failureCount++;
          debugPrint('❌ Failed to remove ${file.fileName} from category: $e');
          // Continue with other files even if one fails
        }
      }

      debugPrint(
        '📊 Bulk remove operation completed: $successCount success, $failureCount failures',
      );

      // Force refresh the DocumentProvider to ensure UI reflects changes
      if (context.mounted && successCount > 0) {
        try {
          debugPrint(
            '🔄 Refreshing DocumentProvider after bulk remove operation',
          );
          await documentProvider.refreshFolderContents();
          debugPrint('✅ DocumentProvider refresh completed');
        } catch (refreshError) {
          debugPrint('⚠️ Failed to refresh DocumentProvider: $refreshError');
          // Continue anyway, the operation was successful
        }
      }

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        if (failureCount == 0) {
          // All files removed successfully
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Successfully removed $successCount files from folder. Files are now uncategorized.',
              ),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 4),
            ),
          );
        } else if (successCount > 0) {
          // Partial success
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Removed $successCount files, $failureCount failed',
              ),
              backgroundColor: AppColors.warning,
              duration: const Duration(seconds: 4),
            ),
          );
        } else {
          // All failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to remove any files from folder'),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to remove files from folder: ${e.toString()}',
            ),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Share multiple files with consolidated operation and editable message
  static Future<void> shareSelectedFiles({
    required BuildContext context,
    required List<DocumentModel> files,
  }) async {
    final shareService = ShareService();
    final googleDriveService = GoogleDriveService();

    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Preparing ${files.length} files for sharing...',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            ],
          ),
        ),
      );

      // Initialize Google Drive service
      await googleDriveService.initialize();

      // Upload all files to Google Drive first
      final uploadedIds = await googleDriveService.uploadMultipleDocuments(
        files,
        onProgress: (completed, total, currentFile) {
          debugPrint('Bulk upload progress: $completed/$total - $currentFile');
        },
      );

      if (uploadedIds.isEmpty) {
        throw Exception('Failed to upload any files to Google Drive');
      }

      // Hide loading dialog
      if (context.mounted) {
        Navigator.pop(context);
      }

      // Generate default bulk message
      final defaultMessage =
          '''📄 I'm sharing ${files.length} documents with you via Google Drive:

${files.asMap().entries.map((entry) {
            final index = entry.key;
            final file = entry.value;
            return '${index + 1}. ${file.displayFileName}\n   ${file.fileType.toUpperCase()} • ${_formatFileSize(file.fileSize)}';
          }).join('\n\n')}

✨ All files have been uploaded to Google Drive for easy access!
📱 Shared via Management Doc App''';

      // Show message editor dialog for bulk sharing
      if (context.mounted) {
        await ShareMessageEditorDialog.show(
          context: context,
          document: files.first, // Use first file as representative
          googleDriveLink: 'Multiple Google Drive links will be included',
          defaultMessage: defaultMessage,
          onShare: (customMessage) async {
            // Use consolidated bulk share operation with custom message
            await shareService.shareBulkFiles(
              documents: files,
              linkExpiration: const Duration(hours: 24),
              customMessage: customMessage,
              onProgress: (completed, total, currentFile) {
                debugPrint(
                  'Bulk share progress: $completed/$total - $currentFile',
                );
              },
            );

            // Show success message
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${files.length} files shared successfully!',
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: AppColors.success,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
        );
      }
    } catch (e) {
      // Hide loading dialog if still showing
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share files: ${e.toString()}'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Format file size in human readable format
  static String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

/// Widget for displaying bulk operations menu
class _BulkOperationsMenu extends StatelessWidget {
  final List<DocumentModel> selectedFiles;
  final VoidCallback onOperationComplete;
  final String? categoryId;

  const _BulkOperationsMenu({
    required this.selectedFiles,
    required this.onOperationComplete,
    this.categoryId,
  });

  /// Check if current user has admin permissions
  Future<bool> _checkAdminPermission(BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      return await authProvider.isCurrentUserAdmin;
    } catch (e) {
      debugPrint('❌ Error checking admin permission: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(Icons.checklist, color: AppColors.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Bulk Operations',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  '${selectedFiles.length} files',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // Operations
          ListTile(
            leading: const Icon(Icons.download, color: AppColors.primary),
            title: Text('Download All', style: GoogleFonts.poppins()),
            subtitle: Text(
              'Download ${selectedFiles.length} files to device',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              BulkOperationsService.downloadSelectedFiles(
                context: context,
                files: selectedFiles,
              );
              onOperationComplete();
            },
          ),

          ListTile(
            leading: const Icon(Icons.share, color: AppColors.primary),
            title: Text('Share All', style: GoogleFonts.poppins()),
            subtitle: Text(
              'Share ${selectedFiles.length} files with others',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              // Show confirmation dialog before sharing
              _showShareConfirmationDialog(
                context: context,
                files: selectedFiles,
                onConfirm: () {
                  BulkOperationsService.shareSelectedFiles(
                    context: context,
                    files: selectedFiles,
                  );
                  onOperationComplete();
                },
              );
            },
          ),

          // Show "Remove from Folder" option only if categoryId is provided
          if (categoryId != null && categoryId!.isNotEmpty) ...[
            ListTile(
              leading: const Icon(Icons.folder_off, color: Colors.orange),
              title: Text(
                'Remove from Folder',
                style: GoogleFonts.poppins(color: Colors.orange),
              ),
              subtitle: Text(
                'Remove ${selectedFiles.length} files from this folder',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.orange.withValues(alpha: 0.7),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                BulkOperationsService.removeFromFolderSelectedFiles(
                  context: context,
                  files: selectedFiles,
                  categoryId: categoryId!,
                );
                onOperationComplete();
              },
            ),
          ],

          // ADMIN-ONLY: Show delete option only for admin users
          FutureBuilder<bool>(
            future: _checkAdminPermission(context),
            builder: (context, snapshot) {
              final isAdmin = snapshot.data ?? false;

              if (!isAdmin) {
                return const SizedBox.shrink(); // Hide delete option for non-admin users
              }

              return ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text(
                  'Delete All',
                  style: GoogleFonts.poppins(color: Colors.red),
                ),
                subtitle: Text(
                  'Permanently delete ${selectedFiles.length} files (Admin Only)',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.red.withValues(alpha: 0.7),
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);

                  // Double-check admin permission before proceeding
                  final isStillAdmin = await _checkAdminPermission(context);
                  if (!isStillAdmin) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            '❌ Access denied: Admin privileges required',
                          ),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                    return;
                  }

                  // Proceed with bulk delete (check context is still mounted)
                  if (context.mounted) {
                    BulkOperationsService.deleteSelectedFiles(
                      context: context,
                      files: selectedFiles,
                    );
                    onOperationComplete();
                  }
                },
              );
            },
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  /// Show confirmation dialog before sharing files
  static void _showShareConfirmationDialog({
    required BuildContext context,
    required List<DocumentModel> files,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Share Operation',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            'Are you sure you want to share ${files.length} file${files.length == 1 ? '' : 's'}? This will generate shareable links for the selected files.',
            style: GoogleFonts.poppins(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textWhite,
              ),
              child: Text(
                'Share',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );
      },
    );
  }
}
