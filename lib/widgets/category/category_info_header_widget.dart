import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../models/category_model.dart';

/// Reusable category info header widget with responsive design
class CategoryInfoHeaderWidget extends StatelessWidget {
  final CategoryModel category;
  final int fileCount;
  final VoidCallback? onAddExisting;
  final VoidCallback? onUploadNew;

  const CategoryInfoHeaderWidget({
    super.key,
    required this.category,
    required this.fileCount,
    this.onAddExisting,
    this.onUploadNew,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    final isSmallScreen = screenWidth < 400;

    return Container(
      margin: EdgeInsets.fromLTRB(
        isSmallScreen ? 12 : 16,
        16,
        isSmallScreen ? 12 : 16,
        8,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderRow(isSmallScreen, isTablet),
            const SizedBox(height: 12),
            _buildActionButtons(isSmallScreen, isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(bool isSmallScreen, bool isTablet) {
    return Row(
      children: [
        Container(
          width: isSmallScreen ? 36 : 40,
          height: isSmallScreen ? 36 : 40,
          decoration: BoxDecoration(
            color: _getCategoryColor().withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getCategoryIcon(),
            color: _getCategoryColor(),
            size: isSmallScreen ? 20 : 24,
          ),
        ),
        SizedBox(width: isSmallScreen ? 8 : 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.name,
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 14 : (isTablet ? 18 : 16),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              if (category.description.isNotEmpty)
                Text(
                  category.description,
                  style: GoogleFonts.poppins(
                    fontSize: isSmallScreen ? 10 : (isTablet ? 14 : 12),
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 8 : 12,
            vertical: isSmallScreen ? 4 : 6,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '$fileCount files',
            style: GoogleFonts.poppins(
              fontSize: isSmallScreen ? 10 : (isTablet ? 14 : 12),
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isSmallScreen, bool isTablet) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onAddExisting,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: AppColors.textWhite,
              padding: EdgeInsets.symmetric(
                vertical: isSmallScreen ? 6 : 8,
              ),
            ),
            icon: Icon(Icons.add, size: isSmallScreen ? 14 : 16),
            label: Text(
              'Add Existing',
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 10 : (isTablet ? 14 : 11),
              ),
            ),
          ),
        ),
        SizedBox(width: isSmallScreen ? 6 : 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onUploadNew,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textWhite,
              padding: EdgeInsets.symmetric(
                vertical: isSmallScreen ? 6 : 8,
              ),
            ),
            icon: Icon(Icons.upload, size: isSmallScreen ? 14 : 16),
            label: Text(
              'Upload New',
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 10 : (isTablet ? 14 : 11),
              ),
            ),
          ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon() {
    final name = category.name.toLowerCase();
    if (name.contains('surat') || name.contains('mail')) {
      return Icons.mail;
    } else if (name.contains('laporan') || name.contains('report')) {
      return Icons.assessment;
    } else if (name.contains('notulen') || name.contains('meeting')) {
      return Icons.event_note;
    } else if (name.contains('sk') || name.contains('keputusan')) {
      return Icons.gavel;
    } else if (name.contains('proposal') || name.contains('project')) {
      return Icons.business_center;
    } else {
      return Icons.folder;
    }
  }

  Color _getCategoryColor() {
    final name = category.name.toLowerCase();
    if (name.contains('surat') || name.contains('mail')) {
      return Colors.blue;
    } else if (name.contains('laporan') || name.contains('report')) {
      return Colors.green;
    } else if (name.contains('notulen') || name.contains('meeting')) {
      return Colors.orange;
    } else if (name.contains('sk') || name.contains('keputusan')) {
      return Colors.red;
    } else if (name.contains('proposal') || name.contains('project')) {
      return Colors.purple;
    } else {
      return AppColors.primary;
    }
  }
}
