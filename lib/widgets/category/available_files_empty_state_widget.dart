import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

/// Reusable empty state widget for available files with responsive design
class AvailableFilesEmptyStateWidget extends StatelessWidget {
  final String? customMessage;
  final String? customSubMessage;
  final IconData? customIcon;
  final EdgeInsets? padding;

  const AvailableFilesEmptyStateWidget({
    super.key,
    this.customMessage,
    this.customSubMessage,
    this.customIcon,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    final isSmallScreen = screenWidth < 400;

    return Container(
      padding: padding ?? EdgeInsets.all(isSmallScreen ? 16 : 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            customIcon ?? Icons.folder_open,
            size: isSmallScreen ? 40 : (isTablet ? 64 : 48),
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Text(
            customMessage ?? 'No available files found',
            style: GoogleFonts.poppins(
              fontSize: isSmallScreen ? 14 : (isTablet ? 18 : 16),
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Text(
            customSubMessage ?? 
            'All files are already in categories or try adjusting your search',
            style: GoogleFonts.poppins(
              fontSize: isSmallScreen ? 12 : (isTablet ? 16 : 14),
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
        ],
      ),
    );
  }
}
