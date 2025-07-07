import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

/// Simple stats grid widget with equal-sized containers
///
/// Features:
/// - Fixed 4 widgets per row layout
/// - Equal-sized containers using Expanded widgets
/// - Unified-style design with icon backgrounds and shadows
/// - Simple grid structure without responsive breakpoints
/// - SVG icon support for recycle bin and favorites
/// - Recycle Bin and Favorites widgets display only titles and icons (no values)
class StatsGrid extends StatelessWidget {
  final Map<String, dynamic> statsData;
  final Function(String)? onStatTap;
  final bool isLoading;

  const StatsGrid({
    super.key,
    required this.statsData,
    this.onStatTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final statWidgets = _buildStatWidgets();
    return _buildSimpleGrid(statWidgets);
  }

  /// Build simple grid with fixed 4 widgets per row
  Widget _buildSimpleGrid(List<Widget> statWidgets) {
    const spacing = 6.0;
    const heightSpacing = 12.0;

    // First row: 4 widgets
    final firstRow = Row(
      children: [
        Expanded(child: statWidgets[0]),
        const SizedBox(width: spacing),
        Expanded(child: statWidgets[1]),
        const SizedBox(width: spacing),
        Expanded(child: statWidgets[2]),
        const SizedBox(width: spacing),
        Expanded(child: statWidgets[3]),
      ],
    );

    // Second row: 2 widgets centered
    final secondRow = Row(
      children: [
        Expanded(child: statWidgets[4]),
        const SizedBox(width: spacing),
        Expanded(child: statWidgets[5]),
        const SizedBox(width: spacing),
        Expanded(child: Container()), // Empty space
        const SizedBox(width: spacing),
        Expanded(child: Container()), // Empty space
      ],
    );

    return Column(
      children: [
        firstRow,
        const SizedBox(height: heightSpacing),
        secondRow,
      ],
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

/// Individual stat widget with simple design
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
    // Fixed sizing without responsive behavior
    const padding = EdgeInsets.all(8.0);
    const borderRadius = 12.0;
    const spacing = 8.0;
    const valueFontSize = 18.0;
    const titleFontSize = 11.0;
    const iconSize = 20.0;

    // Special larger icon size for widgets without values (Row 2: Recycle Bin & Favorites)
    const largeIconSize =
        28.0; // Increased from 20.0 to 28.0 for better visibility
    final effectiveIconSize = showValue ? iconSize : largeIconSize;

    // Calculate consistent minimum height for all widgets (Unified style)
    final iconContainerHeight =
        effectiveIconSize + (spacing * 2); // Icon + padding
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
          _buildIconContainer(
            iconSize: effectiveIconSize,
            spacing: spacing,
            borderRadius: borderRadius,
          ),

          SizedBox(height: spacing),

          // Value section with consistent spacing for visual alignment
          if (showValue) ...[
            if (isLoading)
              Container(
                width: 30, // Fixed loading width
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
            // Row 2 styling: Custom spacing to align with row 1 widgets
            _buildRow2ValueSpacing(
              spacing: spacing,
              valueFontSize: valueFontSize,
            ),
          ],
          // Title with custom styling for row 2
          _buildTitleSection(
            title: title,
            titleFontSize: titleFontSize,
            spacing: spacing,
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

  /// Build icon container with custom sizing for widgets without values
  Widget _buildIconContainer({
    required double iconSize,
    required double spacing,
    required double borderRadius,
  }) {
    return Container(
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
    );
  }

  /// Build custom spacing for Row 2 widgets (without values) to align with Row 1
  Widget _buildRow2ValueSpacing({
    required double spacing,
    required double valueFontSize,
  }) {
    // Row 2 gets slightly reduced spacing to center the title better
    // This compensates for the larger icon and creates better visual balance
    final adjustedSpacing =
        (valueFontSize * 1.1) +
        (spacing / 3); // Reduced from spacing/2 to spacing/3

    return SizedBox(height: adjustedSpacing);
  }

  /// Build title section with custom styling for Row 2 widgets
  Widget _buildTitleSection({
    required String title,
    required double titleFontSize,
    required double spacing,
  }) {
    // Row 2 widgets get slightly larger title font and adjusted spacing for better proportion
    final effectiveTitleFontSize = showValue
        ? titleFontSize
        : titleFontSize + 1.0; // +1px for row 2
    final effectiveLineHeight = showValue
        ? 1.3
        : 1.2; // Tighter line height for row 2

    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: effectiveTitleFontSize,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: effectiveLineHeight,
      ),
      textAlign: TextAlign.center,
      maxLines: 3, // Allow up to 3 lines for better text wrapping
      overflow: TextOverflow.visible, // Allow text to wrap naturally
      softWrap: true, // Enable soft wrapping
    );
  }
}
