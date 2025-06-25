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
  static const Color textWhite = Color(0xFFFFFFFF);

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

/// Enhanced Dark Mode Colors with beautiful nighttime aesthetics
class AppColorsDark {
  // Primary colors - Enhanced for dark mode with better contrast
  static const Color primary = Color(
    0xFF64B5F6,
  ); // Lighter blue for better visibility
  static const Color primaryLight = Color(0xFF90CAF9);
  static const Color primaryDark = Color(0xFF42A5F5);

  // Secondary colors - Teal accent for dark mode
  static const Color secondary = Color(0xFF26A69A);
  static const Color secondaryLight = Color(0xFF4DB6AC);
  static const Color secondaryDark = Color(0xFF00695C);

  // Background colors - Deep dark with subtle variations
  static const Color background = Color(0xFF0A0A0A); // Very dark background
  static const Color surface = Color(0xFF1E1E1E); // Card/surface background
  static const Color surfaceVariant = Color(0xFF2D2D2D); // Elevated surfaces
  static const Color surfaceElevated = Color(0xFF383838); // Higher elevation

  // Text colors - High contrast for readability
  static const Color textPrimary = Color(0xFFE3F2FD); // Light blue-white
  static const Color textSecondary = Color(0xFFB0BEC5); // Muted blue-gray
  static const Color textHint = Color(0xFF78909C); // Darker hint text
  static const Color textWhite = Color(0xFFFFFFFF); // Pure white for emphasis

  // Status colors - Adjusted for dark backgrounds
  static const Color success = Color(0xFF66BB6A); // Softer green
  static const Color warning = Color(0xFFFFB74D); // Softer orange
  static const Color error = Color(0xFFEF5350); // Softer red
  static const Color info = Color(0xFF42A5F5); // Matches primary

  // Border and divider colors - Subtle in dark mode
  static const Color border = Color(0xFF424242);
  static const Color divider = Color(0xFF303030);

  // Shadow color - More prominent in dark mode
  static const Color shadow = Color(0xFF000000);

  // Disabled colors
  static const Color disabled = Color(0xFF616161);
  static const Color disabledBackground = Color(0xFF2D2D2D);

  // Card colors - Enhanced depth
  static const Color cardBackground = Color(0xFF1E1E1E);
  static const Color cardShadow = Color(0x40000000); // Stronger shadow

  // Input colors - Dark theme variants
  static const Color inputBackground = Color(0xFF2D2D2D);
  static const Color inputBorder = Color(0xFF424242);
  static const Color inputFocused = Color(0xFF64B5F6);

  // Gradient colors - Beautiful dark gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0A0A0A), Color(0xFF1A1A1A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Night sky gradient for special elements
  static const LinearGradient nightSkyGradient = LinearGradient(
    colors: [Color(0xFF0D1421), Color(0xFF1A237E), Color(0xFF283593)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Category specific colors - Dark mode variants
  static const Color categoryMail = Color(0xFF42A5F5);
  static const Color categoryReport = Color(0xFF66BB6A);
  static const Color categoryMeeting = Color(0xFFFFB74D);
  static const Color categoryDecision = Color(0xFFEF5350);
  static const Color categoryProposal = Color(0xFFBA68C8);
  static const Color categoryDefault = Color(0xFF78909C);

  // File type colors - Enhanced for dark mode
  static const Color filePdf = Color(0xFFEF5350);
  static const Color fileDoc = Color(0xFF42A5F5);
  static const Color fileXls = Color(0xFF66BB6A);
  static const Color filePpt = Color(0xFFFF7043);
  static const Color fileImg = Color(0xFFAB47BC);
  static const Color fileDefault = Color(0xFF90A4AE);

  // Accent colors for special UI elements
  static const Color accent = Color(0xFF00E5FF); // Cyan accent
  static const Color accentSecondary = Color(0xFFE91E63); // Pink accent
  static const Color highlight = Color(0xFFFFD54F); // Yellow highlight

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
