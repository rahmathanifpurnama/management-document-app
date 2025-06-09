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

  /// Download multiple files
  static Future<void> downloadSelectedFiles({
    required BuildContext context,
    required List<DocumentModel> files,
  }) async {
    final downloadService = FileDownloadService();

    try {
      // Show progress indicator
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
              Expanded(child: Text('Downloading ${files.length} files...')),
            ],
          ),
          duration: Duration(seconds: files.length * 10), // Estimate time
          backgroundColor: AppColors.primary,
        ),
      );

      // Download each file
      for (int i = 0; i < files.length; i++) {
        final file = files[i];
        await downloadService.downloadFile(file);

        // Update progress if needed
        debugPrint('Downloaded ${i + 1}/${files.length}: ${file.fileName}');
      }

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
                  child: Text('Successfully downloaded ${files.length} files'),
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
            content: Text('Failed to download files: ${e.toString()}'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Delete multiple files
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

    try {
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentUserId = authProvider.currentUser?.id ?? 'unknown';

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
                Expanded(child: Text('Deleting ${files.length} files...')),
              ],
            ),
            duration: Duration(seconds: files.length * 5),
            backgroundColor: AppColors.warning,
          ),
        );
      }

      // Delete each file
      for (final file in files) {
        await documentProvider.removeDocument(file.id, currentUserId);
      }

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully deleted ${files.length} files'),
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
            content: Text('Failed to delete files: ${e.toString()}'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
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
          'Are you sure you want to remove ${files.length} files from this folder? The files will not be deleted, only removed from this folder.',
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
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );

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
      for (final file in files) {
        await documentProvider.updateDocumentCategory(file.id, 'uncategorized');
      }

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Successfully removed ${files.length} files from folder',
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
