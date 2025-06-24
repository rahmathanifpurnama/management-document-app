import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';

enum FileFilterMode {
  modal, // Modal bottom sheet (default)
  embedded, // Embedded in page
}

/// DEPRECATED: This widget is deprecated in favor of screen-specific filter widgets:
/// - HomeScreenFilterWidget for home screen
/// - CategoryFilesFilterWidget for category files screen
/// - AddFilesFilterWidget for add files to category screen
///
/// This widget no longer works with the new filter state system and should not be used.
@Deprecated('Use screen-specific filter widgets instead')
class FileFilterWidget extends StatelessWidget {
  final VoidCallback? onFilterApplied;
  final VoidCallback? onClose;
  final FileFilterMode mode;

  const FileFilterWidget({
    super.key,
    this.onFilterApplied,
    this.onClose,
    this.mode = FileFilterMode.modal,
  });

  /// Factory constructor for modal filter (bottom sheet)
  factory FileFilterWidget.modal({VoidCallback? onFilterApplied}) {
    return FileFilterWidget(
      onFilterApplied: onFilterApplied,
      mode: FileFilterMode.modal,
    );
  }

  /// Factory constructor for embedded filter (in page)
  factory FileFilterWidget.embedded({
    VoidCallback? onFilterApplied,
    VoidCallback? onClose,
  }) {
    return FileFilterWidget(
      onFilterApplied: onFilterApplied,
      onClose: onClose,
      mode: FileFilterMode.embedded,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: mode == FileFilterMode.modal
          ? const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            )
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Deprecated Widget',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Deprecation message
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.error.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Icon(Icons.warning, color: AppColors.error, size: 48),
                const SizedBox(height: 12),
                Text(
                  'This widget is deprecated',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please use screen-specific filter widgets:\n'
                  '• HomeScreenFilterWidget for home screen\n'
                  '• CategoryFilesFilterWidget for category files\n'
                  '• AddFilesFilterWidget for add files screen',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Close button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (mode == FileFilterMode.modal) {
                  Navigator.pop(context);
                }
                onClose?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'Close',
                style: GoogleFonts.poppins(
                  color: AppColors.surface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // DEPRECATED: Old methods removed to eliminate dead code warnings
  // Use screen-specific filter widgets instead
}
