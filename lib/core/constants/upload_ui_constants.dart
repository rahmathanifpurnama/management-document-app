import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Shared UI constants for upload components to ensure consistency
class UploadUIConstants {
  // Container styling
  static const EdgeInsets containerPadding = EdgeInsets.all(16);
  static const EdgeInsets smallContainerPadding = EdgeInsets.all(12);
  static const double containerBorderRadius = 12;
  static const double smallBorderRadius = 8;
  
  // Box shadows
  static List<BoxShadow> get defaultBoxShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> get elevatedBoxShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
  
  // Container decorations
  static BoxDecoration get defaultContainerDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(containerBorderRadius),
    boxShadow: defaultBoxShadow,
  );
  
  static BoxDecoration get infoContainerDecoration => BoxDecoration(
    color: AppColors.lightBlue.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(smallBorderRadius),
    border: Border.all(
      color: AppColors.lightBlue.withValues(alpha: 0.3),
      width: 1,
    ),
  );
  
  static BoxDecoration get fileItemDecoration => BoxDecoration(
    color: AppColors.background,
    borderRadius: BorderRadius.circular(smallBorderRadius),
    border: Border.all(color: AppColors.border),
  );
  
  // Spacing constants
  static const double defaultSpacing = 16;
  static const double smallSpacing = 8;
  static const double largeSpacing = 24;
  static const double extraLargeSpacing = 32;
  
  // Icon sizes
  static const double smallIconSize = 16;
  static const double defaultIconSize = 20;
  static const double largeIconSize = 24;
  static const double extraLargeIconSize = 28;
  
  // Progress indicator styling
  static const double progressIndicatorHeight = 8;
  static const double smallProgressIndicatorHeight = 4;
  
  // File item styling
  static const double fileIconSize = 40;
  static const EdgeInsets fileItemMargin = EdgeInsets.only(bottom: 12);
  static const EdgeInsets fileItemPadding = EdgeInsets.all(12);
  
  // Upload zone styling
  static const EdgeInsets uploadZonePadding = EdgeInsets.symmetric(vertical: 50, horizontal: 20);
  static const double uploadIconSize = 60;
  static const double uploadIconBorderRadius = 12;
  
  // Format chip styling
  static const EdgeInsets formatChipPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  static const double formatChipBorderRadius = 12;
  static const double formatChipSpacing = 8;
  
  // Animation durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 150);
  static const Duration longAnimationDuration = Duration(milliseconds: 300);
  
  // Text styles helpers
  static TextStyle get titleTextStyle => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static TextStyle get subtitleTextStyle => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
  
  static TextStyle get bodyTextStyle => const TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );
  
  static TextStyle get captionTextStyle => const TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
  
  // Status colors for file items
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.warning;
      case 'uploading':
        return AppColors.primary;
      case 'completed':
        return AppColors.success;
      case 'failed':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }
  
  // Status icons for file items
  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'uploading':
        return Icons.cloud_upload;
      case 'completed':
        return Icons.check_circle;
      case 'failed':
        return Icons.error;
      default:
        return Icons.help;
    }
  }
}
