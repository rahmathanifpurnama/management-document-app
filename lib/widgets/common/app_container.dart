import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Reusable container widget with consistent styling for activity components
class AppContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final List<BoxShadow>? boxShadow;
  final double? elevation;
  final bool showBorder;
  final bool showShadow;
  final VoidCallback? onTap;
  final String? tooltip;

  const AppContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.boxShadow,
    this.elevation,
    this.showBorder = false,
    this.showShadow = true,
    this.onTap,
    this.tooltip,
  });

  /// Factory constructor for card-style containers
  factory AppContainer.card({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    VoidCallback? onTap,
    String? tooltip,
  }) {
    return AppContainer(
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8),
      borderRadius: 12,
      backgroundColor: AppColors.surface,
      showShadow: true,
      onTap: onTap,
      tooltip: tooltip,
      child: child,
    );
  }

  /// Factory constructor for bordered containers
  factory AppContainer.bordered({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Color? borderColor,
    double? borderWidth,
    VoidCallback? onTap,
    String? tooltip,
  }) {
    return AppContainer(
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8),
      borderRadius: 8,
      backgroundColor: AppColors.surface,
      borderColor: borderColor ?? AppColors.border,
      borderWidth: borderWidth ?? 1,
      showBorder: true,
      showShadow: false,
      onTap: onTap,
      tooltip: tooltip,
      child: child,
    );
  }

  /// Factory constructor for info containers
  factory AppContainer.info({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    VoidCallback? onTap,
    String? tooltip,
  }) {
    return AppContainer(
      padding: padding ?? const EdgeInsets.all(12),
      margin: margin ?? const EdgeInsets.symmetric(vertical: 4),
      borderRadius: 8,
      backgroundColor: AppColors.lightBlue.withValues(alpha: 0.1),
      borderColor: AppColors.lightBlue.withValues(alpha: 0.3),
      borderWidth: 1,
      showBorder: true,
      showShadow: false,
      onTap: onTap,
      tooltip: tooltip,
      child: child,
    );
  }

  /// Factory constructor for elevated containers
  factory AppContainer.elevated({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? elevation,
    VoidCallback? onTap,
    String? tooltip,
  }) {
    return AppContainer(
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8),
      borderRadius: 12,
      backgroundColor: AppColors.surface,
      elevation: elevation ?? 4,
      showShadow: true,
      onTap: onTap,
      tooltip: tooltip,
      child: child,
    );
  }

  /// Factory constructor for flat containers (no shadow, no border)
  factory AppContainer.flat({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Color? backgroundColor,
    VoidCallback? onTap,
    String? tooltip,
  }) {
    return AppContainer(
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin ?? const EdgeInsets.symmetric(vertical: 4),
      borderRadius: 8,
      backgroundColor: backgroundColor ?? AppColors.background,
      showBorder: false,
      showShadow: false,
      onTap: onTap,
      tooltip: tooltip,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget container = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
        border: showBorder
            ? Border.all(
                color: borderColor ?? AppColors.border,
                width: borderWidth ?? 1,
              )
            : null,
        boxShadow: showShadow ? _getBoxShadow() : null,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );

    // Wrap with Material for elevation if specified
    if (elevation != null && elevation! > 0) {
      container = Material(
        elevation: elevation!,
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
        color: backgroundColor ?? AppColors.surface,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      );
    }

    // Wrap with InkWell for tap functionality
    if (onTap != null) {
      container = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          child: container,
        ),
      );
    }

    // Wrap with Tooltip if provided
    if (tooltip != null) {
      container = Tooltip(
        message: tooltip!,
        child: container,
      );
    }

    return container;
  }

  List<BoxShadow> _getBoxShadow() {
    if (boxShadow != null) {
      return boxShadow!;
    }

    // Default shadow based on elevation or standard shadow
    if (elevation != null && elevation! > 0) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: elevation! * 2,
          offset: Offset(0, elevation! / 2),
        ),
      ];
    }

    // Standard default shadow
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ];
  }
}

/// Extension for common container styles
extension AppContainerStyles on AppContainer {
  /// Create a statistics card container
  static AppContainer statisticsCard({
    required Widget child,
    VoidCallback? onTap,
    String? tooltip,
  }) {
    return AppContainer.card(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      onTap: onTap,
      tooltip: tooltip,
      child: child,
    );
  }

  /// Create a section container
  static AppContainer section({
    required Widget child,
    String? title,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) {
    Widget content = child;
    
    if (title != null) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      );
    }

    return AppContainer.card(
      padding: padding ?? const EdgeInsets.all(20),
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8),
      child: content,
    );
  }

  /// Create a filter container
  static AppContainer filter({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) {
    return AppContainer.bordered(
      padding: padding ?? const EdgeInsets.all(12),
      margin: margin ?? const EdgeInsets.symmetric(vertical: 4),
      borderColor: AppColors.border,
      child: child,
    );
  }
}
