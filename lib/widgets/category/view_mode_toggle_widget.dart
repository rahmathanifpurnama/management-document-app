import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Enum for view modes
enum ViewMode { list, grid }

/// Reusable view mode toggle widget with responsive design
class ViewModeToggleWidget extends StatelessWidget {
  final ViewMode currentMode;
  final ValueChanged<ViewMode> onModeChanged;
  final Color? iconColor;
  final double? iconSize;

  const ViewModeToggleWidget({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
    this.iconColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final effectiveIconSize = iconSize ?? (isSmallScreen ? 20.0 : 24.0);
    final effectiveIconColor = iconColor ?? AppColors.textWhite;

    return IconButton(
      onPressed: () {
        final newMode = currentMode == ViewMode.list 
          ? ViewMode.grid 
          : ViewMode.list;
        onModeChanged(newMode);
      },
      icon: Icon(
        currentMode == ViewMode.list
          ? Icons.grid_view
          : Icons.view_list,
        color: effectiveIconColor,
        size: effectiveIconSize,
      ),
      tooltip: currentMode == ViewMode.list
        ? 'Switch to Grid View'
        : 'Switch to List View',
      padding: EdgeInsets.all(isSmallScreen ? 8.0 : 12.0),
      constraints: BoxConstraints(
        minWidth: isSmallScreen ? 40 : 48,
        minHeight: isSmallScreen ? 40 : 48,
      ),
    );
  }
}

/// Extension to convert ViewMode to string for easier usage
extension ViewModeExtension on ViewMode {
  String get name {
    switch (this) {
      case ViewMode.list:
        return 'list';
      case ViewMode.grid:
        return 'grid';
    }
  }

  static ViewMode fromString(String value) {
    switch (value.toLowerCase()) {
      case 'grid':
        return ViewMode.grid;
      case 'list':
      default:
        return ViewMode.list;
    }
  }
}
