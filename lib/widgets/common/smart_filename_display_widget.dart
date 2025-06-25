import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/document_model.dart';
import '../../utils/filename_utils.dart';
import '../../theme/app_colors.dart';

/// Smart filename display widget that automatically handles truncation
/// and adds file extensions when names are truncated for better UX
class SmartFilenameDisplayWidget extends StatelessWidget {
  final DocumentModel document;
  final TextStyle? style;
  final int maxLines;
  final TextAlign textAlign;
  final bool showExtensionOnTruncation;
  final double? maxWidth;
  final int? maxCharacters;

  const SmartFilenameDisplayWidget({
    super.key,
    required this.document,
    this.style,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    this.showExtensionOnTruncation = true,
    this.maxWidth,
    this.maxCharacters,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = style ?? GoogleFonts.poppins(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    );

    // Get the clean display filename
    final displayName = document.displayFileName;

    // If no constraints are specified, show full name
    if (maxWidth == null && maxCharacters == null) {
      return Text(
        displayName,
        style: defaultStyle,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
      );
    }

    // Use character-based truncation if specified
    if (maxCharacters != null) {
      final formattedName = FilenameUtils.formatForDisplay(
        displayName,
        maxLength: maxCharacters,
      );
      
      return Text(
        formattedName,
        style: defaultStyle,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
      );
    }

    // Use width-based smart truncation
    if (maxWidth != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = maxWidth! < constraints.maxWidth 
              ? maxWidth! 
              : constraints.maxWidth;

          if (showExtensionOnTruncation) {
            final smartName = FilenameUtils.formatForDisplaySmart(
              displayName,
              availableWidth: availableWidth,
              textStyle: defaultStyle,
              maxLines: maxLines,
            );
            
            return Text(
              smartName,
              style: defaultStyle,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              textAlign: textAlign,
            );
          } else {
            return Text(
              displayName,
              style: defaultStyle,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              textAlign: textAlign,
            );
          }
        },
      );
    }

    // Fallback
    return Text(
      displayName,
      style: defaultStyle,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }
}

/// Factory constructors for common use cases
extension SmartFilenameDisplayWidgetFactory on SmartFilenameDisplayWidget {
  /// For file list items with standard styling
  static Widget forFileList({
    required DocumentModel document,
    bool isSmallScreen = false,
    bool isTablet = false,
  }) {
    return SmartFilenameDisplayWidget(
      document: document,
      style: GoogleFonts.poppins(
        fontSize: isSmallScreen ? 13 : (isTablet ? 16 : 15),
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      maxLines: 1,
      showExtensionOnTruncation: true,
      maxCharacters: isSmallScreen ? 25 : (isTablet ? 40 : 30),
    );
  }

  /// For file grid items with compact styling
  static Widget forFileGrid({
    required DocumentModel document,
    bool isSmallScreen = false,
    bool isTablet = false,
  }) {
    return SmartFilenameDisplayWidget(
      document: document,
      style: GoogleFonts.poppins(
        fontSize: isSmallScreen ? 11 : (isTablet ? 14 : 12),
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      maxLines: 2,
      showExtensionOnTruncation: true,
      maxCharacters: isSmallScreen ? 20 : (isTablet ? 35 : 25),
    );
  }

  /// For file table cells with minimal styling
  static Widget forFileTable({
    required DocumentModel document,
    bool isSmallScreen = false,
  }) {
    return SmartFilenameDisplayWidget(
      document: document,
      style: GoogleFonts.poppins(
        fontSize: isSmallScreen ? 12 : 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      maxLines: 1,
      showExtensionOnTruncation: true,
      maxCharacters: isSmallScreen ? 20 : 30,
    );
  }

  /// For upload items with larger text
  static Widget forUploadItem({
    required DocumentModel document,
    bool isSmallScreen = false,
  }) {
    return SmartFilenameDisplayWidget(
      document: document,
      style: GoogleFonts.poppins(
        fontSize: isSmallScreen ? 14 : 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      maxLines: 1,
      showExtensionOnTruncation: true,
      maxCharacters: isSmallScreen ? 25 : 35,
    );
  }

  /// For detail views with full filename display
  static Widget forDetailView({
    required DocumentModel document,
    bool isSmallScreen = false,
  }) {
    return SmartFilenameDisplayWidget(
      document: document,
      style: GoogleFonts.poppins(
        fontSize: isSmallScreen ? 14 : 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      maxLines: 2,
      showExtensionOnTruncation: false, // Show full name in details
    );
  }
}

/// Helper widget for filename display with tooltip on truncation
class SmartFilenameWithTooltip extends StatelessWidget {
  final DocumentModel document;
  final Widget child;
  final bool showTooltipOnTruncation;

  const SmartFilenameWithTooltip({
    super.key,
    required this.document,
    required this.child,
    this.showTooltipOnTruncation = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!showTooltipOnTruncation) {
      return child;
    }

    return Tooltip(
      message: document.displayFileName,
      waitDuration: const Duration(milliseconds: 500),
      child: child,
    );
  }
}

/// Responsive filename display that adapts to screen size
class ResponsiveFilenameDisplay extends StatelessWidget {
  final DocumentModel document;
  final FilenameDisplayMode mode;

  const ResponsiveFilenameDisplay({
    super.key,
    required this.document,
    this.mode = FilenameDisplayMode.list,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final isTablet = screenWidth >= 768;

    Widget filenameWidget;

    switch (mode) {
      case FilenameDisplayMode.list:
        filenameWidget = SmartFilenameDisplayWidgetFactory.forFileList(
          document: document,
          isSmallScreen: isSmallScreen,
          isTablet: isTablet,
        );
        break;
      case FilenameDisplayMode.grid:
        filenameWidget = SmartFilenameDisplayWidgetFactory.forFileGrid(
          document: document,
          isSmallScreen: isSmallScreen,
          isTablet: isTablet,
        );
        break;
      case FilenameDisplayMode.table:
        filenameWidget = SmartFilenameDisplayWidgetFactory.forFileTable(
          document: document,
          isSmallScreen: isSmallScreen,
        );
        break;
      case FilenameDisplayMode.upload:
        filenameWidget = SmartFilenameDisplayWidgetFactory.forUploadItem(
          document: document,
          isSmallScreen: isSmallScreen,
        );
        break;
      case FilenameDisplayMode.detail:
        filenameWidget = SmartFilenameDisplayWidgetFactory.forDetailView(
          document: document,
          isSmallScreen: isSmallScreen,
        );
        break;
    }

    return SmartFilenameWithTooltip(
      document: document,
      child: filenameWidget,
    );
  }
}

/// Display modes for different UI contexts
enum FilenameDisplayMode {
  list,
  grid,
  table,
  upload,
  detail,
}
