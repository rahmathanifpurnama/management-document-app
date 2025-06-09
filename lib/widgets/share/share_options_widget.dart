import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../models/document_model.dart';
import '../../services/share_service.dart';

/// Widget that provides multiple share options for documents
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
              Icon(Icons.share, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Share Document',
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

          // Share options
          _buildShareOption(
            context,
            icon: Icons.info_outline,
            title: 'Share File Info',
            subtitle: 'Share basic file information',
            onTap: () => _shareFileInfo(context),
          ),
          _buildShareOption(
            context,
            icon: Icons.link,
            title: 'Share with Link',
            subtitle: 'Generate a temporary access link',
            onTap: () => _shareWithLink(context),
          ),
          _buildShareOption(
            context,
            icon: Icons.description,
            title: 'Share Full Details',
            subtitle: 'Share complete file information',
            onTap: () => _shareFullDetails(context),
          ),

          // Divider for social media options
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(color: AppColors.border),
          ),

          // Social Media Section Header
          Text(
            'Share to Social Media',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),

          // Social Media Options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialMediaOption(
                context,
                icon: Icons.chat,
                label: 'WhatsApp',
                color: const Color(0xFF25D366),
                onTap: () => _shareToWhatsApp(context),
              ),
              _buildSocialMediaOption(
                context,
                icon: Icons.telegram,
                label: 'Telegram',
                color: const Color(0xFF0088CC),
                onTap: () => _shareToTelegram(context),
              ),
              _buildSocialMediaOption(
                context,
                icon: Icons.email,
                label: 'Email',
                color: AppColors.primary,
                onTap: () => _shareToEmail(context),
              ),
              _buildSocialMediaOption(
                context,
                icon: Icons.more_horiz,
                label: 'More',
                color: AppColors.textSecondary,
                onTap: () => _shareToMore(context),
              ),
            ],
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
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
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

  Future<void> _shareFileInfo(BuildContext context) async {
    Navigator.pop(context);
    try {
      await ShareService().shareFileInfo(document);
      if (context.mounted) {
        _showSuccessMessage(context, 'File info shared successfully!');
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorMessage(context, 'Failed to share file info: $e');
      }
    }
  }

  Future<void> _shareWithLink(BuildContext context) async {
    Navigator.pop(context);
    try {
      await ShareService().shareFileWithLink(
        document: document,
        linkExpiration: const Duration(hours: 24),
        customMessage: 'I\'m sharing a document with you:',
      );
      if (context.mounted) {
        _showSuccessMessage(context, 'Document shared with link!');
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorMessage(context, 'Failed to share with link: $e');
      }
    }
  }

  Future<void> _shareFullDetails(BuildContext context) async {
    Navigator.pop(context);
    try {
      await ShareService().shareFileDetails(
        document: document,
        ownerName: ownerName,
      );
      if (context.mounted) {
        _showSuccessMessage(context, 'Full details shared successfully!');
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorMessage(context, 'Failed to share details: $e');
      }
    }
  }

  Widget _buildSocialMediaOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _shareToWhatsApp(BuildContext context) async {
    Navigator.pop(context);
    try {
      final shareText = await _generateShareText();
      final encodedText = Uri.encodeComponent(shareText);
      final whatsappUrl = 'https://wa.me/?text=$encodedText';

      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
        if (context.mounted) {
          _showSuccessMessage(context, 'Opened WhatsApp for sharing!');
        }
      } else {
        throw Exception('WhatsApp not available');
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorMessage(context, 'Failed to open WhatsApp: $e');
      }
    }
  }

  Future<void> _shareToTelegram(BuildContext context) async {
    Navigator.pop(context);
    try {
      final shareText = await _generateShareText();
      final encodedText = Uri.encodeComponent(shareText);
      final telegramUrl = 'https://t.me/share/url?text=$encodedText';

      if (await canLaunchUrl(Uri.parse(telegramUrl))) {
        await launchUrl(Uri.parse(telegramUrl), mode: LaunchMode.externalApplication);
        if (context.mounted) {
          _showSuccessMessage(context, 'Opened Telegram for sharing!');
        }
      } else {
        throw Exception('Telegram not available');
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorMessage(context, 'Failed to open Telegram: $e');
      }
    }
  }

  Future<void> _shareToEmail(BuildContext context) async {
    Navigator.pop(context);
    try {
      final shareText = await _generateShareText();
      final subject = Uri.encodeComponent('Shared Document: ${document.fileName}');
      final body = Uri.encodeComponent(shareText);
      final emailUrl = 'mailto:?subject=$subject&body=$body';

      if (await canLaunchUrl(Uri.parse(emailUrl))) {
        await launchUrl(Uri.parse(emailUrl));
        if (context.mounted) {
          _showSuccessMessage(context, 'Opened email client for sharing!');
        }
      } else {
        throw Exception('Email client not available');
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorMessage(context, 'Failed to open email client: $e');
      }
    }
  }

  Future<void> _shareToMore(BuildContext context) async {
    Navigator.pop(context);
    try {
      await ShareService().shareFileWithLink(
        document: document,
        linkExpiration: const Duration(hours: 24),
        customMessage: 'I\'m sharing a document with you:',
      );
      if (context.mounted) {
        _showSuccessMessage(context, 'Share options opened!');
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorMessage(context, 'Failed to open share options: $e');
      }
    }
  }

  Future<String> _generateShareText() async {
    // Generate basic share text for social media
    return '''
📄 Document: ${document.fileName}

📊 File Details:
• Type: ${document.fileType.toUpperCase()}
• Size: ${document.fileSizeFormatted}
• Category: ${document.category}

📱 Shared via Management Doc App
''';
  }

  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 5),
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
