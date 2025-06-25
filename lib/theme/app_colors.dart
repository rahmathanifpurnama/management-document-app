import 'package:flutter/material.dart';

/// Application color scheme
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryLight = Color(0xFF64B5F6);
  static const Color primaryDark = Color(0xFF1976D2);

  // Secondary colors
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryLight = Color(0xFF66FFF9);
  static const Color secondaryDark = Color(0xFF00A896);

  // Background colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8F9FA);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Border and divider colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);

  // Shadow color
  static const Color shadow = Color(0xFF000000);

  // Disabled colors
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color disabledBackground = Color(0xFFF5F5F5);

  // Card colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardShadow = Color(0x1A000000);

  // Input colors
  static const Color inputBackground = Color(0xFFF8F9FA);
  static const Color inputBorder = Color(0xFFE1E5E9);
  static const Color inputFocused = Color(0xFF2196F3);

  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Category specific colors
  static const Color categoryMail = Color(0xFF2196F3);
  static const Color categoryReport = Color(0xFF4CAF50);
  static const Color categoryMeeting = Color(0xFFFF9800);
  static const Color categoryDecision = Color(0xFFF44336);
  static const Color categoryProposal = Color(0xFF9C27B0);
  static const Color categoryDefault = Color(0xFF607D8B);

  // File type colors
  static const Color filePdf = Color(0xFFD32F2F);
  static const Color fileDoc = Color(0xFF1976D2);
  static const Color fileXls = Color(0xFF388E3C);
  static const Color filePpt = Color(0xFFD84315);
  static const Color fileImg = Color(0xFF7B1FA2);
  static const Color fileDefault = Color(0xFF616161);

  // Opacity variants
  static Color primaryWithOpacity(double opacity) =>
      primary.withValues(alpha: opacity);
  static Color surfaceWithOpacity(double opacity) =>
      surface.withValues(alpha: opacity);
  static Color shadowWithOpacity(double opacity) =>
      shadow.withValues(alpha: opacity);
  static Color textPrimaryWithOpacity(double opacity) =>
      textPrimary.withValues(alpha: opacity);
  static Color textSecondaryWithOpacity(double opacity) =>
      textSecondary.withValues(alpha: opacity);
}
