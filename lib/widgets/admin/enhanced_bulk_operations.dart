import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../features/file_selection/providers/file_selection_providers.dart';
import '../../models/document_model.dart';
import 'bulk_operations_dialog.dart';

class EnhancedBulkOperations extends ConsumerWidget {
  final Function(List<DocumentModel> documents)? onDelete;
  final Function(List<DocumentModel> documents)? onDownload;
  final Function(List<DocumentModel> documents)? onMove;
  final bool showApprovalActions;
  final bool showFileActions;
  final bool showMoveAction;

  const EnhancedBulkOperations({
    super.key,
    this.onDelete,
    this.onDownload,
    this.onMove,
    this.showApprovalActions = false,
    this.showFileActions = true,
    this.showMoveAction = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shouldShowSelectionUI = ref.watch(shouldShowSelectionUIProvider);

    // Show UI when in selection mode, regardless of selection count
    if (!shouldShowSelectionUI) {
      return const SizedBox.shrink();
    }

    final selectedCount = ref.watch(selectedCountProvider);
    final hasSelection = ref.watch(hasSelectionProvider);
    final isAllSelected = ref.watch(isAllSelectedProvider);
    final selectedFiles = ref.watch(selectedFilesProvider);
    final actions = ref.read(fileSelectionActionsProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Selection summary
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$selectedCount selected',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              // Select All / Clear All toggle
              TextButton.icon(
                onPressed: () => _toggleSelectAll(ref),
                icon: Icon(
                  isAllSelected ? Icons.deselect : Icons.select_all,
                  size: 16,
                ),
                label: Text(isAllSelected ? 'Clear All' : 'Select All'),
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Action buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // File actions (only show when files are selected)
              if (showFileActions && onDownload != null && hasSelection)
                _buildActionButton(
                  context: context,
                  icon: Icons.download,
                  label: 'Download',
                  color: AppColors.primary,
                  onPressed: () => onDownload!(selectedFiles),
                ),

              if (showMoveAction && onMove != null && hasSelection)
                _buildActionButton(
                  context: context,
                  icon: Icons.folder_open,
                  label: 'Move',
                  color: AppColors.primary,
                  onPressed: () => onMove!(selectedFiles),
                ),

              if (showFileActions && onDelete != null && hasSelection)
                _buildActionButton(
                  context: context,
                  icon: Icons.delete,
                  label: 'Delete',
                  color: AppColors.error,
                  onPressed: () => _showBulkDialog(
                    context,
                    BulkOperationType.delete,
                    selectedFiles,
                    (documents, reason) => onDelete!(documents),
                  ),
                ),

              // Exit selection mode button (always show when in selection mode)
              _buildActionButton(
                context: context,
                icon: Icons.close,
                label: 'Exit',
                color: AppColors.textSecondary,
                onPressed: () => actions.exitSelectionMode(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withValues(alpha: 0.3)),
        ),
      ),
    );
  }

  void _toggleSelectAll(WidgetRef ref) {
    final actions = ref.read(fileSelectionActionsProvider);
    final isAllSelected = ref.read(isAllSelectedProvider);

    if (isAllSelected) {
      actions.clearSelection();
    } else {
      actions.selectAll();
    }
  }

  void _showBulkDialog(
    BuildContext context,
    BulkOperationType operationType,
    List<DocumentModel> selectedDocuments,
    Function(List<DocumentModel> documents, String? reason) onConfirm,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BulkOperationsDialog(
        selectedDocuments: selectedDocuments,
        operationType: operationType,
        onConfirm: (reason) {
          Navigator.of(context).pop();
          onConfirm(selectedDocuments, reason);
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }
}

/// Compact bulk operations bar for smaller spaces
class CompactBulkOperations extends ConsumerWidget {
  final Function(List<DocumentModel> documents)? onDelete;

  const CompactBulkOperations({super.key, this.onDelete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shouldShowSelectionUI = ref.watch(shouldShowSelectionUIProvider);

    // Show UI when in selection mode, regardless of selection count
    if (!shouldShowSelectionUI) {
      return const SizedBox.shrink();
    }

    final selectedCount = ref.watch(selectedCountProvider);
    final selectedFiles = ref.watch(selectedFilesProvider);
    final actions = ref.read(fileSelectionActionsProvider);

    return Container(
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Selection count
          Text(
            '$selectedCount selected',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const Spacer(),

          // Action buttons
          if (onDelete != null)
            IconButton(
              onPressed: () => _showBulkDialog(
                context,
                BulkOperationType.delete,
                selectedFiles,
                (documents, reason) => onDelete!(documents),
              ),
              icon: const Icon(Icons.delete, color: Colors.white),
              tooltip: 'Delete',
            ),

          // Clear selection
          IconButton(
            onPressed: () => actions.clearSelection(),
            icon: const Icon(Icons.clear, color: Colors.white),
            tooltip: 'Clear selection',
          ),
        ],
      ),
    );
  }

  void _showBulkDialog(
    BuildContext context,
    BulkOperationType operationType,
    List<DocumentModel> selectedDocuments,
    Function(List<DocumentModel> documents, String? reason) onConfirm,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BulkOperationsDialog(
        selectedDocuments: selectedDocuments,
        operationType: operationType,
        onConfirm: (reason) {
          Navigator.of(context).pop();
          onConfirm(selectedDocuments, reason);
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }
}
