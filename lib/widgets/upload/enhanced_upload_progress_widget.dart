import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/upload_file_model.dart';
import '../../providers/consolidated_upload_provider.dart';

/// Enhanced upload progress widget with queue management
class EnhancedUploadProgressWidget extends StatelessWidget {
  final bool showQueueStats;
  final bool showIndividualProgress;
  final bool allowQueueManagement;

  const EnhancedUploadProgressWidget({
    super.key,
    this.showQueueStats = true,
    this.showIndividualProgress = true,
    this.allowQueueManagement = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ConsolidatedUploadProvider>(
      builder: (context, uploadProvider, child) {
        final queuedFiles = uploadProvider.uploadQueue;
        final isProcessing = uploadProvider.isUploading;

        if (queuedFiles.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with queue stats
              if (showQueueStats) _buildHeader(uploadProvider),

              // Queue management controls
              if (allowQueueManagement && queuedFiles.isNotEmpty)
                _buildQueueControls(uploadProvider),

              // Individual file progress
              if (showIndividualProgress) ...[
                // Queued files
                ...queuedFiles
                    .take(5)
                    .map(
                      (file) => _buildFileProgressItem(
                        file,
                        uploadProvider,
                        isActive: isProcessing,
                      ),
                    ),

                // Show more indicator if there are many queued files
                if (queuedFiles.length > 5)
                  _buildShowMoreIndicator(queuedFiles.length - 5),
              ],

              // Overall progress
              if (isProcessing) _buildOverallProgress(uploadProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(ConsolidatedUploadProvider uploadProvider) {
    final queuedFiles = uploadProvider.uploadQueue;
    final isProcessing = uploadProvider.isUploading;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isProcessing ? Icons.cloud_upload : Icons.cloud_queue,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Upload Queue',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          _buildStatsChip(
            'Queued',
            queuedFiles.length,
            AppColors.textSecondary,
          ),
          if (isProcessing) ...[
            const SizedBox(width: 8),
            _buildStatsChip('Uploading', 1, AppColors.primary),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        '$label: $count',
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildQueueControls(ConsolidatedUploadProvider uploadProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildControlButton(
            icon: Icons.clear_all,
            label: 'Clear Queue',
            onPressed: uploadProvider.clearAll,
            color: AppColors.textSecondary,
          ),
          const Spacer(),
          Text(
            '${uploadProvider.uploadQueue.length} files in queue',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    );
  }

  Widget _buildFileProgressItem(
    UploadFileModel file,
    ConsolidatedUploadProvider uploadProvider, {
    required bool isActive,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.lightGray.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // File info row
          Row(
            children: [
              _buildFileIcon(file.fileType),
              const SizedBox(width: 12),
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
                    Text(
                      _formatFileSize(file.fileSize),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _buildFileActions(file, uploadProvider, isActive),
            ],
          ),

          // Progress bar and status
          if (isActive) ...[
            const SizedBox(height: 8),
            _buildProgressBar(file),
            const SizedBox(height: 4),
            _buildStatusText(file),
          ] else ...[
            const SizedBox(height: 4),
            Text(
              'Queued for upload',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFileIcon(String fileType) {
    IconData iconData;
    Color iconColor;

    switch (fileType.toLowerCase()) {
      case 'pdf':
        iconData = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case 'doc':
        iconData = Icons.description;
        iconColor = Colors.blue;
        break;
      case 'excel':
        iconData = Icons.table_chart;
        iconColor = Colors.green;
        break;
      case 'ppt':
        iconData = Icons.slideshow;
        iconColor = Colors.orange;
        break;
      case 'image':
        iconData = Icons.image;
        iconColor = Colors.purple;
        break;
      default:
        iconData = Icons.insert_drive_file;
        iconColor = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(iconData, color: iconColor, size: 20),
    );
  }

  Widget _buildFileActions(
    UploadFileModel file,
    ConsolidatedUploadProvider uploadProvider,
    bool isActive,
  ) {
    switch (file.status) {
      case UploadStatus.failed:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.refresh, size: 18),
              onPressed: uploadProvider.retryFailed,
              tooltip: 'Retry upload',
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () => uploadProvider.removeFile(file.id),
              tooltip: 'Remove',
            ),
          ],
        );
      case UploadStatus.completed:
        return IconButton(
          icon: const Icon(Icons.check_circle, size: 18, color: Colors.green),
          onPressed: () => uploadProvider.removeFile(file.id),
          tooltip: 'Remove from list',
        );
      default:
        return IconButton(
          icon: const Icon(Icons.remove_circle_outline, size: 18),
          onPressed: () => uploadProvider.removeFile(file.id),
          tooltip: 'Remove from queue',
        );
    }
  }

  Widget _buildProgressBar(UploadFileModel file) {
    Color progressColor;
    switch (file.status) {
      case UploadStatus.uploading:
        progressColor = AppColors.primary;
        break;
      case UploadStatus.completed:
        progressColor = AppColors.success;
        break;
      case UploadStatus.failed:
        progressColor = AppColors.error;
        break;
      case UploadStatus.paused:
        progressColor = AppColors.warning;
        break;
      default:
        progressColor = AppColors.lightGray;
    }

    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: file.progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: progressColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusText(UploadFileModel file) {
    String statusText;
    Color statusColor;

    switch (file.status) {
      case UploadStatus.uploading:
        statusText = 'Uploading... ${(file.progress * 100).toInt()}%';
        statusColor = AppColors.primary;
        break;
      case UploadStatus.completed:
        statusText = 'Upload completed';
        statusColor = AppColors.success;
        break;
      case UploadStatus.failed:
        statusText = file.errorMessage ?? 'Upload failed';
        statusColor = AppColors.error;
        break;
      case UploadStatus.paused:
        statusText = 'Upload paused';
        statusColor = AppColors.warning;
        break;
      default:
        statusText = 'Preparing...';
        statusColor = AppColors.textSecondary;
    }

    return Text(
      statusText,
      style: GoogleFonts.poppins(fontSize: 12, color: statusColor),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildShowMoreIndicator(int remainingCount) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Text(
        '... and $remainingCount more files in queue',
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: AppColors.textSecondary,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildOverallProgress(ConsolidatedUploadProvider uploadProvider) {
    final total = uploadProvider.totalFiles;
    final completed = uploadProvider.completedFiles;
    final progress = total > 0 ? uploadProvider.overallProgress : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withValues(alpha: 0.05),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overall Progress',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.lightGray,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(
            '$completed of $total files completed',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
