import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/document_model.dart';

/// Reusable document menu widget with responsive design
class DocumentMenuWidget extends StatelessWidget {
  final DocumentModel document;
  final VoidCallback? onDownload;
  final VoidCallback? onShare;
  final VoidCallback? onDetails;
  final VoidCallback? onRemoveFromFolder;
  final VoidCallback? onDelete;
  final bool showRemoveFromFolder;
  final String? categoryName;

  const DocumentMenuWidget({
    super.key,
    required this.document,
    this.onDownload,
    this.onShare,
    this.onDetails,
    this.onRemoveFromFolder,
    this.onDelete,
    this.showRemoveFromFolder = true,
    this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    final isSmallScreen = screenWidth < 400;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Document info header
          _buildDocumentHeader(isSmallScreen, isTablet),
          
          const Divider(height: 24),

          // Menu options
          _buildMenuOptions(isSmallScreen, isTablet),
          
          SizedBox(height: isSmallScreen ? 8 : 16),
        ],
      ),
    );
  }

  Widget _buildDocumentHeader(bool isSmallScreen, bool isTablet) {
    return Row(
      children: [
        Container(
          width: isSmallScreen ? 36 : 40,
          height: isSmallScreen ? 36 : 40,
          decoration: BoxDecoration(
            color: _getFileTypeColor(),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getFileTypeIcon(),
            color: Colors.white,
            size: isSmallScreen ? 18 : 20,
          ),
        ),
        SizedBox(width: isSmallScreen ? 8 : 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                document.fileName,
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 14 : (isTablet ? 18 : 16),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                document.fileSizeFormatted,
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 10 : (isTablet ? 14 : 12),
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuOptions(bool isSmallScreen, bool isTablet) {
    final fontSize = isSmallScreen ? 14.0 : (isTablet ? 18.0 : 16.0);
    
    return Column(
      children: [
        if (onDownload != null)
          _buildMenuItem(
            icon: Icons.download,
            title: 'Download',
            onTap: onDownload!,
            fontSize: fontSize,
          ),
        if (onShare != null)
          _buildMenuItem(
            icon: Icons.share,
            title: 'Share',
            onTap: onShare!,
            fontSize: fontSize,
          ),
        if (onDetails != null)
          _buildMenuItem(
            icon: Icons.info_outline,
            title: 'Details',
            onTap: onDetails!,
            fontSize: fontSize,
          ),
        if (showRemoveFromFolder && onRemoveFromFolder != null)
          _buildMenuItem(
            icon: Icons.remove_circle,
            title: categoryName != null 
              ? 'Remove from $categoryName'
              : 'Remove from Folder',
            onTap: onRemoveFromFolder!,
            fontSize: fontSize,
            color: Colors.orange,
          ),
        if (onDelete != null)
          _buildMenuItem(
            icon: Icons.delete,
            title: 'Delete File Permanently',
            onTap: onDelete!,
            fontSize: fontSize,
            color: Colors.red,
          ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required double fontSize,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.primary),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: color ?? AppColors.textPrimary,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
    );
  }

  Color _getFileTypeColor() {
    final extension = document.fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'xls':
      case 'xlsx':
        return Colors.green;
      case 'ppt':
      case 'pptx':
        return Colors.orange;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Colors.purple;
      default:
        return AppColors.primary;
    }
  }

  IconData _getFileTypeIcon() {
    final extension = document.fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }
}
