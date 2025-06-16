import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/document_model.dart';
import '../providers/document_provider.dart';
import '../providers/auth_provider.dart';
import '../services/file_download_service.dart';
import '../services/share_service.dart';
import '../core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

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

  /// Download multiple files with parallel processing and progress tracking
  static Future<void> downloadSelectedFiles({
    required BuildContext context,
    required List<DocumentModel> files,
  }) async {
    final downloadService = FileDownloadService();
    int completedDownloads = 0;
    int failedDownloads = 0;
    final List<String> failedFiles = [];

    try {
      // Show initial progress indicator
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
                child: Text('Starting download of ${files.length} files...'),
              ),
            ],
          ),
          duration: Duration(
            seconds: files.length * 5,
          ), // Reduced estimate time
          backgroundColor: AppColors.primary,
        ),
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

            // Update progress in UI if possible
            if (context.mounted) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Downloaded $completedDownloads of ${files.length} files...',
                  ),
                  backgroundColor: AppColors.primary,
                  duration: const Duration(seconds: 1),
                ),
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

      // Show final result
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        if (failedDownloads == 0) {
          // All successful
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '✅ Successfully downloaded all ${files.length} files',
                    ),
                  ),
                ],
              ),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 4),
            ),
          );
        } else if (completedDownloads > 0) {
          // Partial success
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '⚠️ Downloaded $completedDownloads files, $failedDownloads failed\n'
                'Failed: ${failedFiles.take(3).join(', ')}${failedFiles.length > 3 ? '...' : ''}',
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 6),
              action: SnackBarAction(
                label: 'Retry Failed',
                textColor: Colors.white,
                onPressed: () {
                  final failedDocuments = files
                      .where((f) => failedFiles.contains(f.fileName))
                      .toList();
                  downloadSelectedFiles(
                    context: context,
                    files: failedDocuments,
                  );
                },
              ),
            ),
          );
        } else {
          // All failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Failed to download all files'),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'Retry All',
                textColor: Colors.white,
                onPressed: () {
                  downloadSelectedFiles(context: context, files: files);
                },
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download files: ${e.toString()}'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () {
                downloadSelectedFiles(context: context, files: files);
              },
            ),
          ),
        );
      }
    }
  }

  /// Delete multiple files with parallel processing and error handling
  static Future<void> deleteSelectedFiles({
    required BuildContext context,
    required List<DocumentModel> files,
  }) async {
    // Show confirmation dialog
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

    // Get providers before async operations to avoid context issues
    final documentProvider = Provider.of<DocumentProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserId = authProvider.currentUser?.id ?? 'unknown';

    int completedDeletes = 0;
    int failedDeletes = 0;
    final List<String> failedFiles = [];

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
                  child: Text('Starting deletion of ${files.length} files...'),
                ),
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

        // Process batch in parallel
        final futures = batch.map((file) async {
          try {
            await documentProvider.removeDocument(file.id, currentUserId);
            completedDeletes++;
            debugPrint(
              '✅ Deleted: ${file.fileName} ($completedDeletes/${files.length})',
            );

            // Update progress in UI
            if (context.mounted) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Deleted $completedDeletes of ${files.length} files...',
                  ),
                  backgroundColor: AppColors.warning,
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          } catch (e) {
            failedDeletes++;
            failedFiles.add(file.fileName);
            debugPrint('❌ Failed to delete: ${file.fileName} - $e');
          }
        });

        // Wait for batch to complete
        await Future.wait(futures);

        // Small delay between batches
        if (i + batchSize < files.length) {
          await Future.delayed(const Duration(milliseconds: 800));
        }
      }

      // Show final result
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

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
          // Partial success
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '⚠️ Deleted $completedDeletes files, $failedDeletes failed\n'
                'Failed: ${failedFiles.take(3).join(', ')}${failedFiles.length > 3 ? '...' : ''}',
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 6),
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
          // All failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Failed to delete all files'),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 4),
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

  /// Share multiple files with consolidated operation
  static Future<void> shareSelectedFiles({
    required BuildContext context,
    required List<DocumentModel> files,
  }) async {
    final shareService = ShareService();

    try {
      // Show single progress indicator
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
                  child: Text(
                    'Generating share links for ${files.length} files...',
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 30),
            backgroundColor: AppColors.primary,
          ),
        );
      }

      // Use consolidated bulk share operation
      await shareService.shareBulkFiles(
        documents: files,
        linkExpiration: const Duration(hours: 24),
        customMessage: 'Sharing ${files.length} files from Management Doc:',
      );

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Successfully shared ${files.length} files'),
                ),
              ],
            ),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
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

          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: Text(
              'Delete All',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
            subtitle: Text(
              'Permanently delete ${selectedFiles.length} files',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.red.withValues(alpha: 0.7),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              BulkOperationsService.deleteSelectedFiles(
                context: context,
                files: selectedFiles,
              );
              onOperationComplete();
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
