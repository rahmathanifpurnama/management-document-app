import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/file_selection_provider.dart';
import '../../services/bulk_operations_service.dart';

/// Widget that appears at the top when files are selected
class FileSelectionBar extends StatefulWidget {
  final VoidCallback? onExitSelection;
  final String? categoryId;

  const FileSelectionBar({super.key, this.onExitSelection, this.categoryId});

  @override
  State<FileSelectionBar> createState() => _FileSelectionBarState();
}

class _FileSelectionBarState extends State<FileSelectionBar> {
  bool _isExiting = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<FileSelectionProvider>(
      builder: (context, selectionProvider, child) {
        if (!selectionProvider.isSelectionMode) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            border: Border(
              bottom: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // Close selection mode button
              IconButton(
                onPressed: _isExiting
                    ? null
                    : () async {
                        try {
                          setState(() {
                            _isExiting = true;
                          });

                          // Exit selection mode safely
                          selectionProvider.exitSelectionMode();

                          // Brief delay for smooth transition
                          await Future.delayed(
                            const Duration(milliseconds: 150),
                          );

                          // Call the exit callback if provided
                          widget.onExitSelection?.call();
                        } catch (e) {
                          // Handle any errors gracefully
                          debugPrint('Error during selection mode exit: $e');

                          // Ensure selection mode is exited even if there's an error
                          try {
                            selectionProvider.exitSelectionMode();
                          } catch (retryError) {
                            debugPrint(
                              'Retry exit selection mode failed: $retryError',
                            );
                          }

                          // Still call the callback to ensure UI consistency
                          widget.onExitSelection?.call();
                        } finally {
                          if (mounted) {
                            setState(() {
                              _isExiting = false;
                            });
                          }
                        }
                      },
                icon: _isExiting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      )
                    : const Icon(Icons.close),
                color: AppColors.primary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),

              const SizedBox(width: 12),

              // Selection count
              Expanded(
                child: Text(
                  selectionProvider.getSelectionSummary(),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),

              // Select All / Clear Selection (always show when in selection mode)
              TextButton(
                onPressed: selectionProvider.isAllSelected
                    ? selectionProvider.clearSelection
                    : selectionProvider.selectAll,
                child: Text(
                  selectionProvider.isAllSelected ? 'Clear All' : 'Select All',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Bulk operations button (only show when files are selected)
              if (selectionProvider.hasSelection)
                IconButton(
                  onPressed: () =>
                      _showBulkOperations(context, selectionProvider),
                  icon: const Icon(Icons.more_vert),
                  color: AppColors.primary,
                  tooltip: 'Bulk Operations',
                ),
            ],
          ),
        );
      },
    );
  }

  void _showBulkOperations(
    BuildContext context,
    FileSelectionProvider selectionProvider,
  ) {
    if (selectionProvider.selectedFiles.isEmpty) return;

    BulkOperationsService.showBulkOperationsMenu(
      context: context,
      selectedFiles: selectionProvider.selectedFiles,
      categoryId: widget.categoryId,
      onOperationComplete: () {
        try {
          // Exit selection mode safely
          selectionProvider.exitSelectionMode();

          // Call the exit callback if provided
          widget.onExitSelection?.call();
        } catch (e) {
          // Handle any errors gracefully
          debugPrint('Error during bulk operation completion: $e');

          // Ensure selection mode is exited even if there's an error
          try {
            selectionProvider.exitSelectionMode();
          } catch (retryError) {
            debugPrint('Retry exit selection mode failed: $retryError');
          }

          // Still call the callback to ensure UI consistency
          widget.onExitSelection?.call();
        }
      },
    );
  }
}
