import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

/// Reusable empty state widget for categories with responsive design
class CategoryEmptyStateWidget extends StatelessWidget {
  final String categoryName;
  final VoidCallback? onAddExisting;
  final VoidCallback? onUploadNew;

  const CategoryEmptyStateWidget({
    super.key,
    required this.categoryName,
    this.onAddExisting,
    this.onUploadNew,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    final isSmallScreen = screenWidth < 400;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: isSmallScreen ? 64 : (isTablet ? 100 : 80),
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            Text(
              'No Files in This Category',
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 16 : (isTablet ? 22 : 18),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isSmallScreen ? 6 : 8),
            Text(
              'Upload documents to this category to see them here',
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 12 : (isTablet ? 16 : 14),
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isSmallScreen ? 20 : 24),
            _buildActionButtons(isSmallScreen, isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isSmallScreen, bool isTablet) {
    if (isSmallScreen) {
      // Stack buttons vertically on small screens
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onAddExisting,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: AppColors.textWhite,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              icon: const Icon(Icons.add),
              label: Text('Add Existing Files', style: GoogleFonts.poppins()),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onUploadNew,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textWhite,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              icon: const Icon(Icons.upload_file),
              label: Text('Upload New', style: GoogleFonts.poppins()),
            ),
          ),
        ],
      );
    } else {
      // Side by side buttons for larger screens
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: onAddExisting,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: AppColors.textWhite,
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 24 : 20,
                vertical: isTablet ? 16 : 12,
              ),
            ),
            icon: const Icon(Icons.add),
            label: Text(
              'Add Existing Files',
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 16 : 14,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 20 : 16),
          ElevatedButton.icon(
            onPressed: onUploadNew,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textWhite,
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 24 : 20,
                vertical: isTablet ? 16 : 12,
              ),
            ),
            icon: const Icon(Icons.upload_file),
            label: Text(
              'Upload New',
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 16 : 14,
              ),
            ),
          ),
        ],
      );
    }
  }
}
