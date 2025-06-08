import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/file_selection_provider.dart';
import '../../services/bulk_operations_service.dart';

/// Widget that appears at the top when files are selected
class FileSelectionBar extends StatelessWidget {
  final VoidCallback? onExitSelection;

  const FileSelectionBar({
    super.key,
    this.onExitSelection,
  });

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
                onPressed: () {
                  selectionProvider.exitSelectionMode();
                  onExitSelection?.call();
                },
                icon: const Icon(Icons.close),
                color: AppColors.primary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
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

              // Select All / Clear Selection
              if (selectionProvider.hasSelection) ...[
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

                // Bulk operations button
                IconButton(
                  onPressed: () => _showBulkOperations(context, selectionProvider),
                  icon: const Icon(Icons.more_vert),
                  color: AppColors.primary,
                  tooltip: 'Bulk Operations',
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _showBulkOperations(BuildContext context, FileSelectionProvider selectionProvider) {
    if (selectionProvider.selectedFiles.isEmpty) return;

    BulkOperationsService.showBulkOperationsMenu(
      context: context,
      selectedFiles: selectionProvider.selectedFiles,
      onOperationComplete: () {
        selectionProvider.exitSelectionMode();
        onExitSelection?.call();
      },
    );
  }
}
