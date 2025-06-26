import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/document_model.dart';
import '../../services/share_service.dart';
import '../../services/google_drive_service.dart';
import '../dialogs/share_message_editor_dialog.dart';

enum ShareButtonStyle { icon, iconWithText, text, menu }

/// Simplified share button widget for Google Drive sharing only
class ShareButtonWidget extends StatefulWidget {
  final DocumentModel document;
  final ShareButtonStyle style;
  final String? ownerName;
  final VoidCallback? onShareStart;
  final VoidCallback? onShareComplete;
  final Function(String)? onShareError;
  final Color? iconColor;
  final Color? backgroundColor;
  final double? iconSize;
  final EdgeInsets? padding;
  final String? customTooltip;

  const ShareButtonWidget({
    super.key,
    required this.document,
    this.style = ShareButtonStyle.icon,
    this.ownerName,
    this.onShareStart,
    this.onShareComplete,
    this.onShareError,
    this.iconColor,
    this.backgroundColor,
    this.iconSize,
    this.padding,
    this.customTooltip,
  });

  @override
  State<ShareButtonWidget> createState() => _ShareButtonWidgetState();
}

class _ShareButtonWidgetState extends State<ShareButtonWidget> {
  final ShareService _shareService = ShareService();
  bool _isSharing = false;

  @override
  Widget build(BuildContext context) {
    switch (widget.style) {
      case ShareButtonStyle.icon:
        return _buildIconButton();
      case ShareButtonStyle.iconWithText:
        return _buildIconWithTextButton();
      case ShareButtonStyle.text:
        return _buildTextButton();
      case ShareButtonStyle.menu:
        return _buildMenuButton();
    }
  }

  Widget _buildIconButton() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: IconButton(
        onPressed: _isSharing ? null : _handleShare,
        icon: _isSharing
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.iconColor ?? AppColors.textSecondary,
                  ),
                ),
              )
            : Icon(
                Icons.share,
                color: widget.iconColor ?? AppColors.textSecondary,
                size: widget.iconSize ?? 18,
              ),
        padding: widget.padding ?? EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        tooltip: widget.customTooltip ?? 'Share Document',
      ),
    );
  }

  Widget _buildIconWithTextButton() {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _isSharing ? null : _handleShare,
          child: Padding(
            padding:
                widget.padding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isSharing
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            widget.iconColor ?? AppColors.primary,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.share,
                        color: widget.iconColor ?? AppColors.primary,
                        size: widget.iconSize ?? 18,
                      ),
                const SizedBox(width: 8),
                Text(
                  _isSharing ? 'Sharing...' : 'Share',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: widget.iconColor ?? AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextButton() {
    return TextButton(
      onPressed: _isSharing ? null : _handleShare,
      child: Text(
        _isSharing ? 'Sharing...' : 'Share',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: widget.iconColor ?? AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildMenuButton() {
    return PopupMenuButton<ShareType>(
      enabled: !_isSharing,
      icon: _isSharing
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.iconColor ?? AppColors.textSecondary,
                ),
              ),
            )
          : Icon(
              Icons.share,
              color: widget.iconColor ?? AppColors.textSecondary,
              size: widget.iconSize ?? 18,
            ),
      tooltip: widget.customTooltip ?? 'Upload to Google Drive & Share',
      onSelected: (_) => _handleShare(),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ShareType.shareableLink,
          child: Row(
            children: [
              Icon(ShareService.getShareIcon(null), size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      ShareService.getShareTypeName(null),
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    Text(
                      'Upload to your Google Drive',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleShare() async {
    if (_isSharing) return;

    // Show confirmation dialog
    final confirmed = await _showShareConfirmationDialog();
    if (!confirmed) return;

    try {
      // First, prepare Google Drive link (upload if needed)
      setState(() {
        _isSharing = true;
      });

      widget.onShareStart?.call();

      // Show progress snackbar
      if (mounted) {
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
                    'Preparing ${widget.document.displayFileName} for sharing...',
                  ),
                ),
              ],
            ),
            duration: const Duration(minutes: 5),
            backgroundColor: Colors.blue,
          ),
        );
      }

      // Get Google Drive service and prepare link
      final googleDriveService = GoogleDriveService();
      await googleDriveService.initialize();

      String shareableLink;

      // Check if filePath is already a Google Drive file ID
      if (_shareService.isGoogleDriveFileId(widget.document.filePath)) {
        shareableLink = googleDriveService.getShareableLink(
          widget.document.filePath,
        );
      } else {
        // Upload file to Google Drive first
        final fileId = await googleDriveService.uploadDocumentToGoogleDrive(
          widget.document,
          onProgress: (progress) {
            debugPrint('Upload progress: ${(progress * 100).toInt()}%');
          },
        );

        if (fileId == null) {
          throw Exception('Failed to upload file to Google Drive');
        }

        shareableLink = googleDriveService.getShareableLink(fileId);
      }

      // Hide progress snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }

      // Get default message template
      final defaultMessage = _shareService.getDefaultShareMessage(
        widget.document,
      );

      // Show message editor dialog
      if (mounted) {
        await ShareMessageEditorDialog.show(
          context: context,
          document: widget.document,
          googleDriveLink: shareableLink,
          defaultMessage: defaultMessage,
          onShare: (customMessage) async {
            // Share with custom message
            await _shareService.shareGoogleDriveLink(
              widget.document,
              customMessage: customMessage,
            );

            // Show success message
            if (mounted) {
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
                          '${widget.document.displayFileName} shared successfully!',
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 3),
                ),
              );
            }

            widget.onShareComplete?.call();
          },
        );
      }
    } catch (e) {
      final errorMessage =
          'Failed to prepare file for sharing: ${e.toString()}';
      widget.onShareError?.call(errorMessage);

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(errorMessage)),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  /// Show confirmation dialog before sharing with link
  Future<bool> _showShareConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.drive_file_move, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Upload to Google Drive',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload "${widget.document.displayFileName}" to your Google Drive and share?',
                    style: GoogleFonts.poppins(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.cloud_upload,
                              color: Colors.blue.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'This will:',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• Upload the file to your Google Drive\n• Create a shareable link\n• Open your device\'s share menu',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(color: AppColors.textSecondary),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(true),
                  icon: const Icon(Icons.drive_file_move, size: 18),
                  label: Text(
                    'Upload & Share',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textWhite,
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}

/// Helper widget for creating share buttons in different contexts
class ShareButtonHelper {
  /// Create a share button for file table actions
  static Widget forFileTable({
    required DocumentModel document,
    String? ownerName,
    VoidCallback? onShareComplete,
  }) {
    return ShareButtonWidget(
      document: document,
      style: ShareButtonStyle.icon,
      ownerName: ownerName,
      onShareComplete: onShareComplete,
    );
  }

  /// Create a share button for document menus
  static Widget forDocumentMenu({
    required DocumentModel document,
    String? ownerName,
    VoidCallback? onShareComplete,
  }) {
    return ShareButtonWidget(
      document: document,
      style: ShareButtonStyle.menu,
      ownerName: ownerName,
      onShareComplete: onShareComplete,
    );
  }

  /// Create a share button for action bars
  static Widget forActionBar({
    required DocumentModel document,
    String? ownerName,
    VoidCallback? onShareComplete,
  }) {
    return ShareButtonWidget(
      document: document,
      style: ShareButtonStyle.iconWithText,
      ownerName: ownerName,
      onShareComplete: onShareComplete,
    );
  }
}
