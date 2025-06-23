import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

/// Reusable loading widget for file list sections
/// Simple, clean animation without complex effects
class FileListLoadingWidget extends StatefulWidget {
  final String loadingText;
  final String? subText;
  final Duration animationDuration;
  final EdgeInsets? padding;
  final double? indicatorSize;
  final bool showContainer;

  const FileListLoadingWidget({
    super.key,
    this.loadingText = 'Loading files...',
    this.subText,
    this.animationDuration = const Duration(milliseconds: 800),
    this.padding,
    this.indicatorSize = 32.0,
    this.showContainer = true,
  });

  /// Factory constructor for file list sections
  factory FileListLoadingWidget.forFileList({
    String? customText,
    String? subText,
  }) {
    return FileListLoadingWidget(
      loadingText: customText ?? 'Loading files...',
      subText: subText ?? 'Please wait while we fetch your documents',
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
    );
  }

  /// Factory constructor for simple loading
  factory FileListLoadingWidget.simple({String? text}) {
    return FileListLoadingWidget(
      loadingText: text ?? 'Loading...',
      padding: const EdgeInsets.all(20),
      indicatorSize: 24.0,
      showContainer: false,
    );
  }

  /// Factory constructor for pull to refresh
  factory FileListLoadingWidget.pullToRefresh({
    String? customText,
    String? subText,
  }) {
    return FileListLoadingWidget(
      loadingText: customText ?? 'Refreshing files...',
      subText: subText ?? 'Getting latest updates from database',
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      animationDuration: const Duration(milliseconds: 600),
      indicatorSize: 28.0,
    );
  }

  @override
  State<FileListLoadingWidget> createState() => _FileListLoadingWidgetState();
}

class _FileListLoadingWidgetState extends State<FileListLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Simple loading indicator
              SizedBox(
                width: widget.indicatorSize,
                height: widget.indicatorSize,
                child: const CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),

              const SizedBox(height: 16),

              // Loading text
              Text(
                widget.loadingText,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              // Optional subtitle
              if (widget.subText != null) ...[
                const SizedBox(height: 8),
                Text(
                  widget.subText!,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (!widget.showContainer) {
      return content;
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: content,
    );
  }
}

// Note: For advanced usage, you can access the animation controller
// through a GlobalKey<_FileListLoadingWidgetState> if needed

/// Example usage:
///
/// ```dart
/// // For file list sections
/// FileListLoadingWidget.forFileList(
///   customText: 'Loading your files...',
///   subText: 'Checking database for your documents',
/// )
///
/// // For pull to refresh
/// FileListLoadingWidget.pullToRefresh(
///   customText: 'Refreshing files...',
///   subText: 'Getting latest updates from database',
/// )
///
/// // For simple loading
/// FileListLoadingWidget.simple(text: 'Loading...')
///
/// // Custom configuration
/// FileListLoadingWidget(
///   loadingText: 'Custom loading message',
///   subText: 'Custom subtitle',
///   animationDuration: Duration(milliseconds: 1000),
///   indicatorSize: 40.0,
///   showContainer: true,
/// )
/// ```
