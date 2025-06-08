import 'package:flutter/material.dart';

/// Responsive utility class for handling different screen sizes
/// Provides breakpoints and responsive values for mobile devices
class ResponsiveUtils {
  // Screen size breakpoints for mobile devices
  static const double smallPhoneWidth = 360.0;
  static const double standardPhoneWidth = 414.0;
  static const double largePhoneWidth = 768.0;

  // Screen size categories
  static const double smallPhoneMaxWidth = 359.0;
  static const double standardPhoneMaxWidth = 413.0;
  static const double largePhoneMaxWidth = 767.0;

  /// Get current screen size category
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width <= smallPhoneMaxWidth) {
      return ScreenSize.smallPhone;
    } else if (width <= standardPhoneMaxWidth) {
      return ScreenSize.standardPhone;
    } else if (width <= largePhoneMaxWidth) {
      return ScreenSize.largePhone;
    } else {
      return ScreenSize.tablet;
    }
  }

  /// Get responsive value based on screen size
  static T getResponsiveValue<T>(
    BuildContext context, {
    required T smallPhone,
    required T standardPhone,
    required T largePhone,
    required T tablet,
  }) {
    final screenSize = getScreenSize(context);

    switch (screenSize) {
      case ScreenSize.smallPhone:
        return smallPhone;
      case ScreenSize.standardPhone:
        return standardPhone;
      case ScreenSize.largePhone:
        return largePhone;
      case ScreenSize.tablet:
        return tablet;
    }
  }

  /// Get responsive padding - OPTIMIZED FOR MOBILE
  static EdgeInsets getResponsivePadding(BuildContext context) {
    return getResponsiveValue(
      context,
      smallPhone: const EdgeInsets.all(12.0),
      standardPhone: const EdgeInsets.all(16.0),
      largePhone: const EdgeInsets.all(18.0),
      tablet: const EdgeInsets.all(20.0),
    );
  }

  /// Get responsive margin - OPTIMIZED FOR MOBILE
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    return getResponsiveValue(
      context,
      smallPhone: const EdgeInsets.symmetric(horizontal: 12.0),
      standardPhone: const EdgeInsets.symmetric(horizontal: 16.0),
      largePhone: const EdgeInsets.symmetric(horizontal: 18.0),
      tablet: const EdgeInsets.symmetric(horizontal: 20.0),
    );
  }

  /// Get responsive font size - OPTIMIZED
  static double getResponsiveFontSize(
    BuildContext context, {
    required double baseSize,
  }) {
    return getResponsiveValue(
      context,
      smallPhone: baseSize * 0.9,
      standardPhone: baseSize,
      largePhone: baseSize * 1.05,
      tablet: baseSize * 1.1,
    );
  }

  /// Get responsive spacing - REDUCED VALUES
  static double getResponsiveSpacing(BuildContext context) {
    return getResponsiveValue(
      context,
      smallPhone: 8.0,
      standardPhone: 12.0,
      largePhone: 16.0,
      tablet: 20.0,
    );
  }

  /// Get responsive border radius
  static double getResponsiveBorderRadius(BuildContext context) {
    return getResponsiveValue(
      context,
      smallPhone: 12.0,
      standardPhone: 16.0,
      largePhone: 16.0,
      tablet: 18.0,
    );
  }

  /// Get responsive icon size
  static double getResponsiveIconSize(
    BuildContext context, {
    required double baseSize,
  }) {
    return getResponsiveValue(
      context,
      smallPhone: baseSize * 0.9,
      standardPhone: baseSize,
      largePhone: baseSize * 1.05,
      tablet: baseSize * 1.1,
    );
  }

  /// Get responsive avatar size - OPTIMIZED
  static double getResponsiveAvatarSize(BuildContext context) {
    return getResponsiveValue(
      context,
      smallPhone: 50.0,
      standardPhone: 60.0,
      largePhone: 65.0,
      tablet: 70.0,
    );
  }

  /// Get responsive container height - OPTIMIZED
  static double getResponsiveContainerHeight(BuildContext context) {
    return getResponsiveValue(
      context,
      smallPhone: 50.0,
      standardPhone: 60.0,
      largePhone: 65.0,
      tablet: 70.0,
    );
  }

  /// Get responsive grid columns for dashboard stats
  static int getStatsGridColumns(BuildContext context) {
    return getResponsiveValue(
      context,
      smallPhone: 4, // Changed to 4 for single row
      standardPhone: 4,
      largePhone: 4,
      tablet: 4,
    );
  }

  /// Get responsive stats card aspect ratio
  static double getStatsCardAspectRatio(BuildContext context) {
    return getResponsiveValue(
      context,
      smallPhone: 1.3, // Adjusted for single row
      standardPhone: 1.2,
      largePhone: 1.2,
      tablet: 1.3,
    );
  }

  /// Check if screen is small
  static bool isSmallScreen(BuildContext context) {
    return getScreenSize(context) == ScreenSize.smallPhone;
  }

  /// Check if screen is tablet size
  static bool isTabletSize(BuildContext context) {
    return getScreenSize(context) == ScreenSize.tablet;
  }

  /// Get responsive text scale factor
  static double getTextScaleFactor(BuildContext context) {
    return getResponsiveValue(
      context,
      smallPhone: 0.95,
      standardPhone: 1.0,
      largePhone: 1.02,
      tablet: 1.05,
    );
  }

  /// Get responsive elevation - REDUCED VALUES
  static double getResponsiveElevation(BuildContext context) {
    return getResponsiveValue(
      context,
      smallPhone: 2.0,
      standardPhone: 2.0,
      largePhone: 3.0,
      tablet: 4.0,
    );
  }
}

/// Screen size enumeration
enum ScreenSize {
  smallPhone, // < 360px
  standardPhone, // 360px - 414px
  largePhone, // 414px - 768px
  tablet, // > 768px
}

/// Extension for easier access to responsive values
extension ResponsiveContext on BuildContext {
  ScreenSize get screenSize => ResponsiveUtils.getScreenSize(this);
  bool get isSmallScreen => ResponsiveUtils.isSmallScreen(this);
  bool get isTabletSize => ResponsiveUtils.isTabletSize(this);

  EdgeInsets get responsivePadding =>
      ResponsiveUtils.getResponsivePadding(this);
  EdgeInsets get responsiveMargin => ResponsiveUtils.getResponsiveMargin(this);
  double get responsiveSpacing => ResponsiveUtils.getResponsiveSpacing(this);
  double get responsiveBorderRadius =>
      ResponsiveUtils.getResponsiveBorderRadius(this);
  double get responsiveAvatarSize =>
      ResponsiveUtils.getResponsiveAvatarSize(this);
  double get responsiveContainerHeight =>
      ResponsiveUtils.getResponsiveContainerHeight(this);
  int get statsGridColumns => ResponsiveUtils.getStatsGridColumns(this);
  double get statsCardAspectRatio =>
      ResponsiveUtils.getStatsCardAspectRatio(this);
  double get textScaleFactor => ResponsiveUtils.getTextScaleFactor(this);
  double get responsiveElevation =>
      ResponsiveUtils.getResponsiveElevation(this);
}
