import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';

/// Navigation button widget for Total Files page
/// Can be used in dashboard, drawer, or any other location
class TotalFilesNavigationButton extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final bool showIcon;
  final bool isCard;
  final VoidCallback? onTap;

  const TotalFilesNavigationButton({
    super.key,
    this.title,
    this.icon,
    this.showIcon = true,
    this.isCard = false,
    this.onTap,
  });

  /// Factory constructor for card style button
  factory TotalFilesNavigationButton.card({
    String? title,
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return TotalFilesNavigationButton(
      title: title,
      icon: icon,
      isCard: true,
      onTap: onTap,
    );
  }

  /// Factory constructor for simple button
  factory TotalFilesNavigationButton.simple({
    String? title,
    IconData? icon,
    bool showIcon = true,
    VoidCallback? onTap,
  }) {
    return TotalFilesNavigationButton(
      title: title,
      icon: icon,
      showIcon: showIcon,
      isCard: false,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = title ?? 'Semua File';
    final displayIcon = icon ?? Icons.folder_open;

    if (isCard) {
      return _buildCardButton(context, displayTitle, displayIcon);
    } else {
      return _buildSimpleButton(context, displayTitle, displayIcon);
    }
  }

  Widget _buildCardButton(BuildContext context, String title, IconData icon) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final cardPadding = EdgeInsets.all(isSmallScreen ? 12.0 : 16.0);
    final borderRadius = isSmallScreen ? 8.0 : 12.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: () => _navigateToTotalFiles(context),
        child: Padding(
          padding: cardPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showIcon) ...[
                Container(
                  width: isSmallScreen ? 40 : 48,
                  height: isSmallScreen ? 40 : 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.primary,
                    size: isSmallScreen ? 20 : 24,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 8 : 12),
              ],
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 13 : 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleButton(BuildContext context, String title, IconData icon) {
    return ListTile(
      leading: showIcon
          ? Icon(
              icon,
              color: AppColors.primary,
            )
          : null,
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
      ),
      onTap: () => _navigateToTotalFiles(context),
    );
  }

  void _navigateToTotalFiles(BuildContext context) {
    if (onTap != null) {
      onTap!();
    } else {
      Navigator.pushNamed(context, AppRoutes.totalFiles);
    }
  }
}

/// Example usage widget showing different ways to use TotalFilesNavigationButton
class TotalFilesNavigationExamples extends StatelessWidget {
  const TotalFilesNavigationExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Total Files Navigation Examples'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card style example
            Text(
              'Card Style Button:',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 120,
              child: TotalFilesNavigationButton.card(),
            ),
            
            const SizedBox(height: 24),
            
            // Simple list tile example
            Text(
              'List Tile Style Button:',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TotalFilesNavigationButton.simple(),
            
            const SizedBox(height: 24),
            
            // Custom example
            Text(
              'Custom Button:',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.totalFiles);
              },
              icon: const Icon(Icons.folder_open),
              label: const Text('Lihat Semua File'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Grid example
            Text(
              'Grid Style (Dashboard):',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                TotalFilesNavigationButton.card(
                  title: 'Semua File',
                  icon: Icons.folder_open,
                ),
                TotalFilesNavigationButton.card(
                  title: 'File Terbaru',
                  icon: Icons.access_time,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
