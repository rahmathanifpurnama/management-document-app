import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/config/upload_config.dart';
import '../../models/upload_file_model.dart';

class UploadStatusWidget extends StatelessWidget {
  final UploadFileModel file;
  final VoidCallback? onRetry;
  final VoidCallback? onCancel;

  const UploadStatusWidget({
    super.key,
    required this.file,
    this.onRetry,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getBorderColor(), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // File info row
          Row(
            children: [
              // File icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getIconBackgroundColor(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(_getFileIcon(), color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),

              // File details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.fileName,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      UploadConfig.getFileSizeString(file.fileSize),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Status indicator
              _buildStatusIndicator(),
            ],
          ),

          const SizedBox(height: 12),

          // Progress bar (only show for uploading files)
          if (file.status == UploadStatus.uploading) ...[
            LinearProgressIndicator(
              value: file.progress,
              backgroundColor: AppColors.lightGray,
              valueColor: AlwaysStoppedAnimation<Color>(
                file.isAiProcessing ? AppColors.warning : AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  file.isAiProcessing ? 'Processing...' : 'Uploading...',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${(file.progress * 100).toStringAsFixed(0)}%',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],

          // Error message (only show for failed files)
          if (file.status == UploadStatus.failed &&
              file.errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, size: 16, color: AppColors.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      file.errorMessage!,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Action buttons
          if (file.status == UploadStatus.failed ||
              file.status == UploadStatus.uploading) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (file.status == UploadStatus.failed && onRetry != null) ...[
                  TextButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh, size: 16),
                    label: Text(
                      'Retry',
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                    ),
                  ),
                ],
                if (file.status == UploadStatus.uploading &&
                    onCancel != null) ...[
                  TextButton.icon(
                    onPressed: onCancel,
                    icon: const Icon(Icons.close, size: 16),
                    label: Text(
                      'Cancel',
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getBorderColor() {
    switch (file.status) {
      case UploadStatus.completed:
        return AppColors.success;
      case UploadStatus.failed:
        return AppColors.error;
      case UploadStatus.uploading:
        return file.isAiProcessing ? AppColors.warning : AppColors.primary;
      case UploadStatus.paused:
        return AppColors.warning;
      default:
        return AppColors.lightGray;
    }
  }

  Color _getIconBackgroundColor() {
    switch (file.fileType.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'xls':
      case 'xlsx':
        return Colors.green;
      case 'ppt':
      case 'pptx':
        return Colors.orange;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Colors.purple;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getFileIcon() {
    switch (file.fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  Widget _buildStatusIndicator() {
    switch (file.status) {
      case UploadStatus.completed:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.success,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check, color: Colors.white, size: 12),
              const SizedBox(width: 4),
              Text(
                'Completed',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      case UploadStatus.failed:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.error,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, color: Colors.white, size: 12),
              const SizedBox(width: 4),
              Text(
                'Failed',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      case UploadStatus.uploading:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: file.isAiProcessing ? AppColors.warning : AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                file.isAiProcessing ? 'Processing' : 'Uploading',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      case UploadStatus.paused:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.warning,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.pause, color: Colors.white, size: 12),
              const SizedBox(width: 4),
              Text(
                'Paused',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      default:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Pending',
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
    }
  }
}
