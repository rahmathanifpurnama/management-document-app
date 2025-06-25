import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/document_model.dart';

enum BulkOperationType { approve, reject, delete }

class BulkOperationsDialog extends StatefulWidget {
  final List<DocumentModel> selectedDocuments;
  final BulkOperationType operationType;
  final Function(String? reason) onConfirm;
  final VoidCallback onCancel;

  const BulkOperationsDialog({
    super.key,
    required this.selectedDocuments,
    required this.operationType,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<BulkOperationsDialog> createState() => _BulkOperationsDialogState();
}

class _BulkOperationsDialogState extends State<BulkOperationsDialog> {
  final TextEditingController _reasonController = TextEditingController();
  final bool _isProcessing = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(_getOperationIcon(), color: _getOperationColor(), size: 24),
          const SizedBox(width: 8),
          Text(
            _getOperationTitle(),
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Operation description
            Text(
              _getOperationDescription(),
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),

            // Selected files summary
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Files (${widget.selectedDocuments.length})',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: widget.selectedDocuments.length > 3 ? 120 : null,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.selectedDocuments.length,
                      itemBuilder: (context, index) {
                        final document = widget.selectedDocuments[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Icon(
                                Icons.description,
                                size: 16,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  document.fileName,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Reason input for reject operation
            if (widget.operationType == BulkOperationType.reject) ...[
              const SizedBox(height: 16),
              Text(
                'Rejection Reason *',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _reasonController,
                decoration: InputDecoration(
                  hintText: 'Enter reason for rejection...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
                maxLines: 3,
                enabled: !_isProcessing,
              ),
            ],

            // Warning for delete operation
            if (widget.operationType == BulkOperationType.delete) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: AppColors.error, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This action cannot be undone. The files will be permanently deleted.',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isProcessing ? null : widget.onCancel,
          child: Text(
            'Cancel',
            style: GoogleFonts.poppins(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: _isProcessing ? null : _handleConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: _getOperationColor(),
            foregroundColor: Colors.white,
          ),
          child: _isProcessing
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  _getConfirmButtonText(),
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
        ),
      ],
    );
  }

  void _handleConfirm() {
    // Validate reason for reject operation
    if (widget.operationType == BulkOperationType.reject) {
      final reason = _reasonController.text.trim();
      if (reason.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a reason for rejection'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
      widget.onConfirm(reason);
    } else {
      widget.onConfirm(null);
    }
  }

  IconData _getOperationIcon() {
    switch (widget.operationType) {
      case BulkOperationType.approve:
        return Icons.check_circle;
      case BulkOperationType.reject:
        return Icons.cancel;
      case BulkOperationType.delete:
        return Icons.delete;
    }
  }

  Color _getOperationColor() {
    switch (widget.operationType) {
      case BulkOperationType.approve:
        return AppColors.success;
      case BulkOperationType.reject:
        return AppColors.warning;
      case BulkOperationType.delete:
        return AppColors.error;
    }
  }

  String _getOperationTitle() {
    switch (widget.operationType) {
      case BulkOperationType.approve:
        return 'Bulk Approve';
      case BulkOperationType.reject:
        return 'Bulk Reject';
      case BulkOperationType.delete:
        return 'Bulk Delete';
    }
  }

  String _getOperationDescription() {
    final count = widget.selectedDocuments.length;
    switch (widget.operationType) {
      case BulkOperationType.approve:
        return 'Are you sure you want to approve $count document${count > 1 ? 's' : ''}?';
      case BulkOperationType.reject:
        return 'Are you sure you want to reject $count document${count > 1 ? 's' : ''}?';
      case BulkOperationType.delete:
        return 'Are you sure you want to delete $count document${count > 1 ? 's' : ''}?';
    }
  }

  String _getConfirmButtonText() {
    switch (widget.operationType) {
      case BulkOperationType.approve:
        return 'Approve All';
      case BulkOperationType.reject:
        return 'Reject All';
      case BulkOperationType.delete:
        return 'Delete All';
    }
  }
}

/// Progress dialog for bulk operations
class BulkOperationProgressDialog extends StatelessWidget {
  final String operationName;
  final int totalItems;
  final int processedItems;
  final int successCount;
  final int errorCount;
  final List<String> errors;
  final bool isCompleted;
  final VoidCallback? onClose;

  const BulkOperationProgressDialog({
    super.key,
    required this.operationName,
    required this.totalItems,
    required this.processedItems,
    required this.successCount,
    required this.errorCount,
    required this.errors,
    required this.isCompleted,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalItems > 0 ? processedItems / totalItems : 0.0;

    return AlertDialog(
      title: Text(
        operationName,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.border.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              isCompleted
                  ? (errorCount > 0 ? AppColors.warning : AppColors.success)
                  : AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),

          // Progress text
          Text(
            '$processedItems of $totalItems processed',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),

          // Results summary
          if (isCompleted) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildResultItem('Success', successCount, AppColors.success),
                _buildResultItem('Errors', errorCount, AppColors.error),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Error list
          if (errors.isNotEmpty) ...[
            Container(
              height: 100,
              width: double.maxFinite,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Errors:',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: ListView.builder(
                      itemCount: errors.length,
                      itemBuilder: (context, index) {
                        return Text(
                          '• ${errors[index]}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: AppColors.error,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actions: [
        if (isCompleted)
          ElevatedButton(
            onPressed: onClose ?? () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Close'),
          ),
      ],
    );
  }

  Widget _buildResultItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
