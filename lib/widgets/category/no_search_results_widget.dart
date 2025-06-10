import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

/// Reusable no search results widget with responsive design
class NoSearchResultsWidget extends StatelessWidget {
  final String? searchQuery;
  final String? customMessage;
  final String? customSubMessage;

  const NoSearchResultsWidget({
    super.key,
    this.searchQuery,
    this.customMessage,
    this.customSubMessage,
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
              Icons.search_off,
              size: isSmallScreen ? 48 : (isTablet ? 80 : 64),
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            Text(
              customMessage ?? 'No files found',
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 14 : (isTablet ? 20 : 16),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isSmallScreen ? 6 : 8),
            Text(
              customSubMessage ?? 
              (searchQuery != null 
                ? 'Try searching with different keywords'
                : 'No results match your search criteria'),
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 12 : (isTablet ? 16 : 14),
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (searchQuery != null) ...[
              SizedBox(height: isSmallScreen ? 8 : 12),
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
                  'Searched for: "$searchQuery"',
                  style: GoogleFonts.poppins(
                    fontSize: isSmallScreen ? 10 : (isTablet ? 14 : 12),
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
