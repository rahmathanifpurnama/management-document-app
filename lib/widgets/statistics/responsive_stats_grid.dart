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
          _buildIconContainer(
            iconSize: iconSize,
            spacing: spacing,
            borderRadius: borderRadius,
          ),

          // Spacing between icon and content
          if (showValue) ...[
            // Row 1 spacing (normal)
            SizedBox(height: spacing),
          ] else ...[
            // Row 2 spacing (custom - same as row 1 for now)
            _buildRow2IconSpacing(spacing: spacing),
          ],

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
            // Row 2: Custom value spacing (same as row 1 for now)
            _buildRow2ValueSpacing(
              spacing: spacing,
              valueFontSize: valueFontSize,
            ),
          ],
          // Title with custom styling for each row
          if (showValue) ...[
            // Row 1 title (normal)
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
          ] else ...[
            // Row 2 title (custom - same as row 1 for now)
            _buildRow2Title(title: title, titleFontSize: titleFontSize),
          ],
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

  /// Build custom icon spacing for Row 2 widgets (Recycle Bin & Favorites)
  /// Currently same as Row 1 - modify values here for custom spacing
  Widget _buildRow2IconSpacing({required double spacing}) {
    // Row 2 icon spacing - same as row 1 for now
    // You can modify this value directly: spacing = 8.0
    return SizedBox(height: spacing); // Same as row 1 (8px)
  }

  /// Build custom value spacing for Row 2 widgets (Recycle Bin & Favorites)
  /// Currently same as Row 1 - modify values here for custom spacing
  Widget _buildRow2ValueSpacing({
    required double spacing,
    required double valueFontSize,
  }) {
    // Row 2 value area spacing - same as row 1 for now
    // You can modify these calculations directly
    final valueHeight = valueFontSize * 1.1; // Same as row 1 (19.8px)
    final titleSpacing = spacing / 2; // Same as row 1 (4px)

    return SizedBox(
      height: valueHeight + titleSpacing, // Same total as row 1 (23.8px)
    );
  }

  /// Build custom title for Row 2 widgets (Recycle Bin & Favorites)
  /// Currently same as Row 1 - modify values here for custom styling
  Widget _buildRow2Title({
    required String title,
    required double titleFontSize,
  }) {
    // Row 2 title styling - same as row 1 for now
    // You can modify these values directly:
    final customFontSize = titleFontSize; // Same as row 1 (11px)
    final customLineHeight = 1.3; // Same as row 1
    final customFontWeight = FontWeight.w500; // Same as row 1

    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: customFontSize,
        fontWeight: customFontWeight,
        color: AppColors.textSecondary,
        height: customLineHeight,
      ),
      textAlign: TextAlign.center,
      maxLines: 3, // Allow up to 3 lines for better text wrapping
      overflow: TextOverflow.visible, // Allow text to wrap naturally
      softWrap: true, // Enable soft wrapping
    );
  }
}
