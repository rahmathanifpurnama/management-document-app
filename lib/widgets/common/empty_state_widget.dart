import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? actionButton;
  final double iconSize;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool showContainer;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionButton,
    this.iconSize = 64,
    this.padding,
    this.margin,
    this.showContainer = true,
  });

  // Factory constructors for common empty states
  factory EmptyStateWidget.noFiles({
    Widget? actionButton,
    EdgeInsets? padding,
    EdgeInsets? margin,
    bool showContainer =
        false, // Default to no container (same as loading state)
  }) {
    return EmptyStateWidget(
      icon: Icons.folder_open,
      title: 'No files found',
      subtitle: 'Files will appear here when available',
      actionButton: actionButton,
      padding: padding,
      margin: margin,
      showContainer: showContainer,
    );
  }

  factory EmptyStateWidget.noDocuments({
    Widget? actionButton,
    EdgeInsets? padding,
    EdgeInsets? margin,
    bool showContainer =
        false, // Default to no container (same as loading state)
  }) {
    return EmptyStateWidget(
      icon: Icons.folder_open,
      title: 'No documents found',
      subtitle: 'Upload your first document to get started',
      actionButton: actionButton,
      padding: padding,
      margin: margin,
      showContainer: showContainer,
    );
  }

  factory EmptyStateWidget.noAvailableFiles({
    Widget? actionButton,
    EdgeInsets? padding,
    EdgeInsets? margin,
    bool showContainer =
        false, // Default to no container (same as loading state)
  }) {
    return EmptyStateWidget(
      icon: Icons.folder_open,
      title: 'No available files found',
      subtitle:
          'All files are already in categories or try adjusting your search',
      actionButton: actionButton,
      padding: padding,
      margin: margin,
      showContainer: showContainer,
    );
  }

  factory EmptyStateWidget.noCategories({
    Widget? actionButton,
    EdgeInsets? padding,
    EdgeInsets? margin,
    bool showContainer =
        false, // Default to no container (same as loading state)
  }) {
    return EmptyStateWidget(
      icon: Icons.folder_outlined,
      title: 'No Categories Found',
      subtitle: 'Create your first category to organize documents',
      actionButton: actionButton,
      padding: padding,
      margin: margin,
      showContainer: showContainer,
    );
  }

  factory EmptyStateWidget.noUsers({
    Widget? actionButton,
    EdgeInsets? padding,
    EdgeInsets? margin,
    bool showContainer = true,
  }) {
    return EmptyStateWidget(
      icon: Icons.people_outline,
      title: 'No Users Found',
      subtitle: 'Add users to manage document access',
      actionButton: actionButton,
      padding: padding,
      margin: margin,
      showContainer: showContainer,
    );
  }

  factory EmptyStateWidget.searchNoResults({
    String? searchQuery,
    Widget? actionButton,
    EdgeInsets? padding,
    EdgeInsets? margin,
    bool showContainer = true,
  }) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      title: 'No results found',
      subtitle: searchQuery != null
          ? 'No results for "$searchQuery". Try different keywords'
          : 'Try adjusting your search criteria',
      actionButton: actionButton,
      padding: padding,
      margin: margin,
      showContainer: showContainer,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Responsive design implementation (same as loading state)
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    // Calculate responsive values (same as loading state)
    final responsiveIconSize = isSmallScreen ? 48.0 : 56.0;
    final textSpacing = isSmallScreen ? 12.0 : 16.0;
    final fontSize = isSmallScreen ? 15.0 : 16.0;
    final subtitleFontSize = isSmallScreen ? 13.0 : 14.0;

    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: responsiveIconSize,
          color: AppColors.textSecondary, // Same color as loading state
        ),
        SizedBox(height: textSpacing),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary, // Same color as loading state
          ),
          textAlign: TextAlign.center,
        ),
        if (subtitle.isNotEmpty) ...[
          SizedBox(height: textSpacing / 2),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: subtitleFontSize,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
        if (actionButton != null) ...[
          SizedBox(height: textSpacing * 1.5),
          actionButton!,
        ],
      ],
    );

    if (!showContainer) {
      return Padding(
        padding:
            padding ??
            EdgeInsets.symmetric(vertical: isSmallScreen ? 60.0 : 80.0),
        child: Center(child: content),
      );
    }

    return Container(
      width: double.infinity,
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 60, horizontal: 32),
      margin: margin ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: content,
    );
  }
}

// Specialized empty state for file tables
class FileTableEmptyState extends StatelessWidget {
  final String? customTitle;
  final String? customSubtitle;
  final Widget? actionButton;

  const FileTableEmptyState({
    super.key,
    this.customTitle,
    this.customSubtitle,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive design implementation (same as loading state)
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    // Calculate responsive values (same as loading state)
    final iconSize = isSmallScreen ? 48.0 : 56.0;
    final textSpacing = isSmallScreen ? 12.0 : 16.0;
    final fontSize = isSmallScreen ? 15.0 : 16.0;
    final subtitleFontSize = isSmallScreen ? 13.0 : 14.0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 60.0 : 80.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_open,
              size: iconSize,
              color: AppColors.textSecondary, // Same color as loading state
            ),
            SizedBox(height: textSpacing),
            Text(
              customTitle ?? 'No files found',
              style: GoogleFonts.poppins(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary, // Same color as loading state
              ),
              textAlign: TextAlign.center,
            ),
            if ((customSubtitle ?? 'Files will appear here when available')
                .isNotEmpty) ...[
              SizedBox(height: textSpacing / 2),
              Text(
                customSubtitle ?? 'Files will appear here when available',
                style: GoogleFonts.poppins(
                  fontSize: subtitleFontSize,
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionButton != null) ...[
              SizedBox(height: textSpacing * 1.5),
              actionButton!,
            ],
          ],
        ),
      ),
    );
  }
}
