import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

/// Responsive stats grid widget with optimized compact design
///
/// Features:
/// - Mobile (< 400px): 2 components per row
/// - Tablet (400-900px): 3-4 components per row
/// - Desktop (> 900px): Maximum 5 components per row
/// - Compact sizing with maintained readability
/// - SVG icon support for recycle bin and favorites
class ResponsiveStatsGrid extends StatelessWidget {
  final Map<String, dynamic> statsData;
  final Function(String)? onStatTap;
  final bool isLoading;

  const ResponsiveStatsGrid({
    super.key,
    required this.statsData,
    this.onStatTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Optimized responsive layout with refined breakpoints
    int crossAxisCount;
    double childAspectRatio;
    double spacing;

    if (screenWidth < 400) {
      // Mobile screens: 2 components per row
      crossAxisCount = 2;
      childAspectRatio =
          1.4; // Slightly taller for better readability on small screens
      spacing = 4.0; // Reduced spacing for more compact design
    } else if (screenWidth < 600) {
      // Large mobile/small tablet: 3 components per row
      crossAxisCount = 3;
      childAspectRatio = 1.3; // Optimized aspect ratio
      spacing = 6.0;
    } else if (screenWidth < 900) {
      // Tablet screens: 4 components per row
      crossAxisCount = 4;
      childAspectRatio = 1.2; // Balanced aspect ratio for tablets
      spacing = 8.0;
    } else {
      // Desktop screens: Maximum 5 components per row
      crossAxisCount = 5;
      childAspectRatio = 1.1; // Compact but readable on large screens
      spacing = 10.0;
    }

    final statWidgets = _buildStatWidgets();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: statWidgets.length,
      itemBuilder: (context, index) => statWidgets[index],
    );
  }

  List<Widget> _buildStatWidgets() {
    return [
      _buildStatWidget(
        title: 'Recent Files',
        value: (statsData['recentFiles'] ?? 0).toString(),
        icon: Icons.access_time,
        color: AppColors.success,
        onTap: () => onStatTap?.call('recent'),
        isClickable: true,
      ),
      _buildStatWidget(
        title: 'Categories',
        value: (statsData['totalCategories'] ?? 0).toString(),
        icon: Icons.folder,
        color: AppColors.info,
        onTap: () => onStatTap?.call('categories'),
        isClickable: true,
      ),
      _buildStatWidget(
        title: 'Users',
        value: (statsData['activeUsers'] ?? 0).toString(),
        icon: Icons.people,
        color: AppColors.warning,
        onTap: () => onStatTap?.call('users'),
        isClickable: true,
      ),
      _buildStatWidget(
        title: 'Total Files',
        value: (statsData['totalFiles'] ?? 0).toString(),
        icon: Icons.description,
        color: AppColors.primary,
        onTap: () => onStatTap?.call('total'),
        isClickable: false,
      ),
      _buildStatWidget(
        title: 'Recycle Bin',
        value: (statsData['recycleBinCount'] ?? 0).toString(),
        iconAsset: 'assets/icon/recycle-bin.svg',
        color: Colors.grey,
        onTap: () => onStatTap?.call('recycle'),
        isClickable: true,
      ),
      _buildStatWidget(
        title: 'Favorites',
        value: (statsData['favoritesCount'] ?? 0).toString(),
        iconAsset: 'assets/icon/user-folder.svg',
        color: Colors.red,
        onTap: () => onStatTap?.call('favorites'),
        isClickable: true,
      ),
    ];
  }

  Widget _buildStatWidget({
    required String title,
    required String value,
    IconData? icon,
    String? iconAsset,
    required Color color,
    VoidCallback? onTap,
    bool isClickable = true,
  }) {
    return StatWidget(
      title: title,
      value: value,
      icon: icon,
      iconAsset: iconAsset,
      color: color,
      onTap: isClickable ? onTap : null,
      isLoading: isLoading,
    );
  }
}

/// Individual stat widget with responsive design
class StatWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final String? iconAsset;
  final Color color;
  final VoidCallback? onTap;
  final bool isLoading;

  const StatWidget({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.iconAsset,
    required this.color,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final isMediumScreen = screenWidth < 600;
    final isLargeScreen = screenWidth < 900;

    // Optimized compact sizing while maintaining readability
    final padding = EdgeInsets.all(
      isSmallScreen
          ? 4.0 // More compact on mobile
          : (isMediumScreen ? 6.0 : (isLargeScreen ? 8.0 : 10.0)),
    );
    final borderRadius = isSmallScreen ? 6.0 : 8.0;
    final spacing = isSmallScreen
        ? 2.0
        : (isMediumScreen ? 3.0 : 4.0); // Reduced spacing
    final valueFontSize = isSmallScreen
        ? 13.0 // Slightly smaller but still readable
        : (isMediumScreen ? 15.0 : (isLargeScreen ? 17.0 : 19.0));
    final titleFontSize = isSmallScreen
        ? 8.5 // Compact title size
        : (isMediumScreen ? 9.5 : (isLargeScreen ? 10.5 : 11.5));
    final iconSize = isSmallScreen
        ? 14.0 // Smaller icons for compact design
        : (isMediumScreen ? 16.0 : (isLargeScreen ? 18.0 : 20.0));

    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04), // Subtle shadow
            blurRadius: 3, // Reduced blur for compact design
            offset: const Offset(0, 1), // Smaller offset
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // Minimize vertical space
        children: [
          // Icon with optimized sizing
          if (iconAsset != null)
            SvgPicture.asset(
              iconAsset!,
              width: iconSize,
              height: iconSize,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            )
          else if (icon != null)
            Icon(icon, size: iconSize, color: color),

          SizedBox(height: spacing),

          // Value with optimized loading state
          if (isLoading)
            Container(
              width: isSmallScreen ? 24 : 30, // Responsive loading width
              height: valueFontSize * 0.8, // Proportional to font size
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            )
          else
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: valueFontSize,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.1, // Tighter line height
              ),
              textAlign: TextAlign.center,
            ),

          SizedBox(
            height: spacing * 0.7,
          ), // Reduced spacing between value and title
          // Title with optimized spacing
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              height: 1.2, // Optimized line height
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    // Wrap with InkWell if clickable
    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: content,
        ),
      );
    }

    return content;
  }
}
