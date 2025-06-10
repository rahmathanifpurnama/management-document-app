import 'package:flutter/material.dart';

/// Responsive layout widget that adapts to different screen sizes
class ResponsiveLayoutWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final double tabletBreakpoint;
  final double desktopBreakpoint;

  const ResponsiveLayoutWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.tabletBreakpoint = 768,
    this.desktopBreakpoint = 1200,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= desktopBreakpoint && desktop != null) {
      return desktop!;
    } else if (screenWidth >= tabletBreakpoint && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}

/// Helper class for responsive values
class ResponsiveHelper {
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 400;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 768 && 
           MediaQuery.of(context).size.width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  static double getResponsiveFontSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth >= 1200 && desktop != null) {
      return desktop;
    } else if (screenWidth >= 768 && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }

  static EdgeInsets getResponsivePadding(
    BuildContext context, {
    required EdgeInsets mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth >= 1200 && desktop != null) {
      return desktop;
    } else if (screenWidth >= 768 && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }

  static double getResponsiveValue(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth >= 1200 && desktop != null) {
      return desktop;
    } else if (screenWidth >= 768 && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }

  static int getResponsiveGridCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth >= 1200) {
      return 4; // Desktop: 4 columns
    } else if (screenWidth >= 768) {
      return 3; // Tablet: 3 columns
    } else if (screenWidth >= 600) {
      return 2; // Large mobile: 2 columns
    } else {
      return 2; // Small mobile: 2 columns
    }
  }

  static double getResponsiveAspectRatio(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth >= 1200) {
      return 0.85; // Desktop
    } else if (screenWidth >= 768) {
      return 0.90; // Tablet
    } else {
      return 0.90; // Mobile
    }
  }
}
