import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/document_model.dart';
import '../../services/share_service.dart';

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
      tooltip: widget.customTooltip ?? 'Share via Google Drive',
      onSelected: (_) => _handleShare(),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ShareType.shareableLink,
          child: Row(
            children: [
              Icon(ShareService.getShareIcon(null), size: 18),
              const SizedBox(width: 12),
              Text(
                ShareService.getShareTypeName(null),
                style: GoogleFonts.poppins(fontSize: 14),
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

    setState(() {
      _isSharing = true;
    });

    widget.onShareStart?.call();

    try {
      // Always use Google Drive sharing
      await _shareService.shareGoogleDriveLink(widget.document);
      widget.onShareComplete?.call();
    } catch (e) {
      final errorMessage = 'Failed to share document: ${e.toString()}';
      widget.onShareError?.call(errorMessage);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
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
              title: Text(
                'Confirm Share',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              content: Text(
                'Are you sure you want to share "${widget.document.fileName}"? This will generate a shareable link for this file.',
                style: GoogleFonts.poppins(color: AppColors.textSecondary),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(color: AppColors.textSecondary),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
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
