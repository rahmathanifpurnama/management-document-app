import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/file_selection_provider.dart';
import '../../models/document_model.dart';
import 'bulk_operations_dialog.dart';

class EnhancedBulkOperations extends StatelessWidget {
  final Function(List<DocumentModel> documents, String? reason)? onApprove;
  final Function(List<DocumentModel> documents, String? reason)? onReject;
  final Function(List<DocumentModel> documents)? onDelete;
  final Function(List<DocumentModel> documents)? onDownload;
  final Function(List<DocumentModel> documents)? onMove;
  final bool showApprovalActions;
  final bool showFileActions;
  final bool showMoveAction;

  const EnhancedBulkOperations({
    super.key,
    this.onApprove,
    this.onReject,
    this.onDelete,
    this.onDownload,
    this.onMove,
    this.showApprovalActions = true,
    this.showFileActions = true,
    this.showMoveAction = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FileSelectionProvider>(
      builder: (context, selectionProvider, child) {
        if (!selectionProvider.hasSelection) {
          return const SizedBox.shrink();
        }

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
                      '${selectionProvider.selectedCount} selected',
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
                    onPressed: () => _toggleSelectAll(selectionProvider),
                    icon: Icon(
                      selectionProvider.isAllSelected
                          ? Icons.deselect
                          : Icons.select_all,
                      size: 16,
                    ),
                    label: Text(
                      selectionProvider.isAllSelected
                          ? 'Clear All'
                          : 'Select All',
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Action buttons
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // Approval actions
                  if (showApprovalActions && onApprove != null)
                    _buildActionButton(
                      context: context,
                      icon: Icons.check_circle,
                      label: 'Approve',
                      color: AppColors.success,
                      onPressed: () => _showBulkDialog(
                        context,
                        BulkOperationType.approve,
                        selectionProvider.selectedFiles,
                        onApprove!,
                      ),
                    ),

                  if (showApprovalActions && onReject != null)
                    _buildActionButton(
                      context: context,
                      icon: Icons.cancel,
                      label: 'Reject',
                      color: AppColors.warning,
                      onPressed: () => _showBulkDialog(
                        context,
                        BulkOperationType.reject,
                        selectionProvider.selectedFiles,
                        onReject!,
                      ),
                    ),

                  // File actions
                  if (showFileActions && onDownload != null)
                    _buildActionButton(
                      context: context,
                      icon: Icons.download,
                      label: 'Download',
                      color: AppColors.primary,
                      onPressed: () =>
                          onDownload!(selectionProvider.selectedFiles),
                    ),

                  if (showMoveAction && onMove != null)
                    _buildActionButton(
                      context: context,
                      icon: Icons.folder_open,
                      label: 'Move',
                      color: AppColors.primary,
                      onPressed: () => onMove!(selectionProvider.selectedFiles),
                    ),

                  if (showFileActions && onDelete != null)
                    _buildActionButton(
                      context: context,
                      icon: Icons.delete,
                      label: 'Delete',
                      color: AppColors.error,
                      onPressed: () => _showBulkDialog(
                        context,
                        BulkOperationType.delete,
                        selectionProvider.selectedFiles,
                        (documents, reason) => onDelete!(documents),
                      ),
                    ),

                  // Clear selection
                  _buildActionButton(
                    context: context,
                    icon: Icons.clear,
                    label: 'Clear',
                    color: AppColors.textSecondary,
                    onPressed: () => selectionProvider.clearSelection(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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

  void _toggleSelectAll(FileSelectionProvider selectionProvider) {
    if (selectionProvider.isAllSelected) {
      selectionProvider.clearSelection();
    } else {
      selectionProvider.selectAll();
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
class CompactBulkOperations extends StatelessWidget {
  final Function(List<DocumentModel> documents, String? reason)? onApprove;
  final Function(List<DocumentModel> documents, String? reason)? onReject;
  final Function(List<DocumentModel> documents)? onDelete;

  const CompactBulkOperations({
    super.key,
    this.onApprove,
    this.onReject,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FileSelectionProvider>(
      builder: (context, selectionProvider, child) {
        if (!selectionProvider.hasSelection) {
          return const SizedBox.shrink();
        }

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
                '${selectionProvider.selectedCount} selected',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Spacer(),

              // Action buttons
              if (onApprove != null)
                IconButton(
                  onPressed: () => _showBulkDialog(
                    context,
                    BulkOperationType.approve,
                    selectionProvider.selectedFiles,
                    onApprove!,
                  ),
                  icon: const Icon(Icons.check, color: Colors.white),
                  tooltip: 'Approve',
                ),

              if (onReject != null)
                IconButton(
                  onPressed: () => _showBulkDialog(
                    context,
                    BulkOperationType.reject,
                    selectionProvider.selectedFiles,
                    onReject!,
                  ),
                  icon: const Icon(Icons.close, color: Colors.white),
                  tooltip: 'Reject',
                ),

              if (onDelete != null)
                IconButton(
                  onPressed: () => _showBulkDialog(
                    context,
                    BulkOperationType.delete,
                    selectionProvider.selectedFiles,
                    (documents, reason) => onDelete!(documents),
                  ),
                  icon: const Icon(Icons.delete, color: Colors.white),
                  tooltip: 'Delete',
                ),

              // Clear selection
              IconButton(
                onPressed: () => selectionProvider.clearSelection(),
                icon: const Icon(Icons.clear, color: Colors.white),
                tooltip: 'Clear selection',
              ),
            ],
          ),
        );
      },
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
