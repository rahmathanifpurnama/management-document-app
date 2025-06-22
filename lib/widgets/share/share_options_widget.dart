import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/document_model.dart';
import '../../services/share_service.dart';
import '../../services/google_drive_service.dart';
import '../dialogs/share_message_editor_dialog.dart';

/// Simplified widget for sharing documents via Google Drive only
class ShareOptionsWidget extends StatelessWidget {
  final DocumentModel document;
  final String? ownerName;

  const ShareOptionsWidget({super.key, required this.document, this.ownerName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.drive_file_move, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Share via Google Drive',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                color: AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Document info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  _getFileIcon(document.fileType),
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    document.fileName,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Single Google Drive share option
          _buildShareOption(
            context,
            icon: Icons.drive_file_move,
            title: 'Share Google Drive Link',
            subtitle: 'Share a link to this file on Google Drive',
            onTap: () => _shareGoogleDriveLink(context),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildShareOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareGoogleDriveLink(BuildContext context) async {
    Navigator.pop(context);

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Get Google Drive service and prepare link
      final shareService = ShareService();
      final googleDriveService = GoogleDriveService();
      await googleDriveService.initialize();

      String shareableLink;

      // Check if filePath is already a Google Drive file ID
      if (shareService.isGoogleDriveFileId(document.filePath)) {
        shareableLink = googleDriveService.getShareableLink(document.filePath);
      } else {
        // Upload file to Google Drive first
        final fileId = await googleDriveService.uploadDocumentToGoogleDrive(
          document,
          onProgress: (progress) {
            debugPrint('Upload progress: ${(progress * 100).toInt()}%');
          },
        );

        if (fileId == null) {
          throw Exception('Failed to upload file to Google Drive');
        }

        shareableLink = googleDriveService.getShareableLink(fileId);
      }

      // Hide loading indicator
      if (context.mounted) {
        Navigator.pop(context);
      }

      // Get default message template
      final defaultMessage = shareService.getDefaultShareMessage(document);

      // Show message editor dialog
      if (context.mounted) {
        await ShareMessageEditorDialog.show(
          context: context,
          document: document,
          googleDriveLink: shareableLink,
          defaultMessage: defaultMessage,
          onShare: (customMessage) async {
            // Share with custom message
            await shareService.shareGoogleDriveLink(
              document,
              customMessage: customMessage,
            );

            // Show success message
            if (context.mounted) {
              _showSuccessMessage(context, 'Document shared successfully!');
            }
          },
        );
      }
    } catch (e) {
      // Hide loading indicator if still showing
      if (context.mounted) {
        Navigator.pop(context);
        _showErrorMessage(context, 'Failed to share Google Drive link: $e');
      }
    }
  }

  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  IconData _getFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xlsx':
      case 'xls':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  /// Static method to show share options
  static void show(
    BuildContext context,
    DocumentModel document, {
    String? ownerName,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          ShareOptionsWidget(document: document, ownerName: ownerName),
    );
  }
}
