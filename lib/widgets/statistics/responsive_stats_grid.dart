import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

/// Responsive stats grid widget with Unified-style equal sizing
///
/// Features:
/// - Unified-style layout: uses Expanded widgets for equal sizing like UnifiedStatsWidget
/// - Equal-sized containers: all widgets have the same width in each row
/// - Dynamic responsive breakpoints:
///   - Small screens (< 400px): 2 widgets per row
///   - Small-medium screens (400-600px): 3 widgets per row
///   - Medium screens (600-900px): 4 widgets per row
///   - Large screens (> 900px): 5 widgets per row
/// - Row-based layout: widgets organized in rows with Column and Row structure
/// - Automatic space distribution: Expanded widgets distribute available space equally
/// - Compact sizing with maintained readability
/// - SVG icon support for recycle bin and favorites
/// - Recycle Bin and Favorites widgets display only titles and icons (no values)
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final statWidgets = _buildStatWidgets();

        // Calculate responsive layout parameters
        final layoutConfig = _getLayoutConfig(screenWidth);

        return _buildCSSGridLayout(statWidgets, layoutConfig);
      },
    );
  }

  /// Build Unified-style layout with equal-sized widgets using Expanded
  Widget _buildCSSGridLayout(
    List<Widget> statWidgets,
    _LayoutConfig layoutConfig,
  ) {
    final itemsPerRow = layoutConfig.itemsPerRow;
    final spacing = layoutConfig.spacing;

    // Group widgets into rows based on itemsPerRow
    final rows = <Widget>[];

    for (int i = 0; i < statWidgets.length; i += itemsPerRow) {
      final rowWidgets = <Widget>[];

      // Add widgets for this row
      for (int j = 0; j < itemsPerRow; j++) {
        final widgetIndex = i + j;

        if (widgetIndex < statWidgets.length) {
          // Add actual widget with Expanded for equal sizing
          rowWidgets.add(Expanded(child: statWidgets[widgetIndex]));
        } else {
          // Add empty expanded space for incomplete rows
          rowWidgets.add(
            Expanded(
              child: Container(), // Empty container to maintain layout
            ),
          );
        }

        // Add spacing between widgets (except for last widget in row)
        if (j < itemsPerRow - 1) {
          rowWidgets.add(SizedBox(width: spacing));
        }
      }

      // Create row with equal-sized widgets
      rows.add(Row(children: rowWidgets));

      // Add spacing between rows (except for last row)
      if (i + itemsPerRow < statWidgets.length) {
        rows.add(SizedBox(height: spacing));
      }
    }

    return Column(children: rows);
  }

  /// Get layout configuration based on screen width
  _LayoutConfig _getLayoutConfig(double screenWidth) {
    int itemsPerRow;
    double spacing;

    if (screenWidth < 400) {
      // Small screens: 2 widgets per row
      itemsPerRow = 2;
      spacing = 8.0;
    } else if (screenWidth < 600) {
      // Small-medium screens: 3 widgets per row
      itemsPerRow = 3;
      spacing = 10.0;
    } else if (screenWidth < 900) {
      // Medium screens: 4 widgets per row
      itemsPerRow = 4;
      spacing = 12.0;
    } else {
      // Large screens: 5 widgets per row
      itemsPerRow = 5;
      spacing = 16.0;
    }

    // No need for itemWidth calculation since we use Expanded widgets
    // Expanded automatically distributes available space equally

    return _LayoutConfig(
      itemsPerRow: itemsPerRow,
      spacing: spacing,
      itemWidth: 0, // Not used with Expanded layout
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
        showValue: true,
      ),
      _buildStatWidget(
        title: 'Categories',
        value: (statsData['totalCategories'] ?? 0).toString(),
        icon: Icons.folder,
        color: AppColors.info,
        onTap: () => onStatTap?.call('categories'),
        isClickable: true,
        showValue: true,
      ),
      _buildStatWidget(
        title: 'Users',
        value: (statsData['activeUsers'] ?? 0).toString(),
        icon: Icons.people,
        color: AppColors.warning,
        onTap: () => onStatTap?.call('users'),
        isClickable: true,
        showValue: true,
      ),
      _buildStatWidget(
        title: 'Total Files',
        value: (statsData['totalFiles'] ?? 0).toString(),
        icon: Icons.description,
        color: AppColors.primary,
        onTap: () => onStatTap?.call('total'),
        isClickable: false,
        showValue: true,
      ),
      _buildStatWidget(
        title: 'Recycle Bin',
        value: (statsData['recycleBinCount'] ?? 0).toString(),
        iconAsset: 'assets/icon/recycle-bin.svg',
        color: Colors.grey,
        onTap: () => onStatTap?.call('recycle'),
        isClickable: true,
        showValue: false, // Remove numeric value for Recycle Bin
      ),
      _buildStatWidget(
        title: 'Favorites',
        value: (statsData['favoritesCount'] ?? 0).toString(),
        iconAsset: 'assets/icon/user-folder.svg',
        color: Colors.red,
        onTap: () => onStatTap?.call('favorites'),
        isClickable: true,
        showValue: false, // Remove numeric value for Favorites
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
    bool showValue = true,
  }) {
    return StatWidget(
      title: title,
      value: value,
      icon: icon,
      iconAsset: iconAsset,
      color: color,
      onTap: isClickable ? onTap : null,
      isLoading: isLoading,
      showValue: showValue,
    );
  }
}

/// Layout configuration class for responsive grid
class _LayoutConfig {
  final int itemsPerRow;
  final double spacing;
  final double itemWidth;

  const _LayoutConfig({
    required this.itemsPerRow,
    required this.spacing,
    required this.itemWidth,
  });
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
  final bool showValue;

  const StatWidget({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.iconAsset,
    required this.color,
    this.onTap,
    this.isLoading = false,
    this.showValue = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final isMediumScreen = screenWidth < 600;
    final isLargeScreen = screenWidth < 900;

    // Optimized compact padding for better space utilization
    final padding = EdgeInsets.all(
      isSmallScreen
          ? 6.0 // Maintain touch targets on mobile
          : (isMediumScreen
                ? 6.0
                : (isLargeScreen
                      ? 8.0
                      : 8.0)), // More compact for larger screens
    );
    final borderRadius = isSmallScreen
        ? 8.0
        : 12.0; // Unified style - larger radius
    final spacing = isSmallScreen ? 4.0 : 8.0; // Unified style - more spacing
    final valueFontSize = isSmallScreen
        ? 14.0 // Unified style - slightly larger
        : (isMediumScreen ? 16.0 : (isLargeScreen ? 18.0 : 20.0));
    final titleFontSize = isSmallScreen
        ? 9.0 // Unified style - more readable
        : (isMediumScreen ? 10.0 : (isLargeScreen ? 11.0 : 12.0));
    final iconSize = isSmallScreen
        ? 16.0 // Unified style - larger icons
        : (isMediumScreen ? 18.0 : (isLargeScreen ? 20.0 : 22.0));

    // Calculate consistent minimum height for all widgets (Unified style)
    final iconContainerHeight = iconSize + (spacing * 2); // Icon + padding
    final baseContentHeight =
        iconContainerHeight +
        spacing +
        (valueFontSize * 1.1) +
        (spacing / 2) +
        (titleFontSize *
            1.3 *
            3); // Icon container + spacing + value area + title (up to 3 lines)
    final minHeight = baseContentHeight + (padding.vertical);

    Widget content = Container(
      padding: padding,
      constraints: BoxConstraints(
        minHeight: minHeight, // Ensure consistent minimum height
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: color.withValues(alpha: 0.1),
          width: 1,
        ), // Unified style - lighter border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ), // Unified style - slightly more shadow
            blurRadius: 4, // Unified style - more blur
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // Minimize vertical space
        children: [
          // Icon with Unified style - background container
          Container(
            padding: EdgeInsets.all(spacing),
            decoration: BoxDecoration(
              color: color.withValues(
                alpha: 0.1,
              ), // Unified style - background for icon
              borderRadius: BorderRadius.circular(borderRadius / 1.5),
            ),
            child: iconAsset != null
                ? SvgPicture.asset(
                    iconAsset!,
                    width: iconSize,
                    height: iconSize,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  )
                : icon != null
                ? Icon(icon, size: iconSize, color: color)
                : const SizedBox.shrink(),
          ),

          SizedBox(height: spacing),

          // Value section with consistent spacing for visual alignment
          if (showValue) ...[
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
              height: spacing / 2,
            ), // Unified style - half spacing before title
          ] else ...[
            // When value is hidden, maintain same visual space as value + spacing
            // This ensures consistent container heights across all widgets
            SizedBox(
              height: (valueFontSize * 1.1) + (spacing / 2),
            ), // Same total height as value text + spacing
          ],
          // Title with optimized text wrapping
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              height:
                  1.3, // Slightly increased for better wrapped text readability
            ),
            textAlign: TextAlign.center,
            maxLines: 3, // Allow up to 3 lines for better text wrapping
            overflow: TextOverflow.visible, // Allow text to wrap naturally
            softWrap: true, // Enable soft wrapping
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
