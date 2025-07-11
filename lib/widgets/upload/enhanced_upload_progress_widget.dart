import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/config/upload_config.dart';
import '../../features/upload/models/upload_file_model.dart';
import '../../features/upload/bloc/upload_bloc.dart';
import '../../features/upload/bloc/upload_state.dart' as upload_states;
import '../../features/upload/bloc/upload_event.dart' as upload_events;

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
    return BlocBuilder<UploadBloc, upload_states.UploadState>(
      builder: (context, state) {
        final queuedFiles = state.currentFiles;
        final isProcessing = state.isUploading;
        final hasActiveFiles = queuedFiles.any(
          (file) =>
              file.status == UploadStatus.uploading ||
              file.status == UploadStatus.pending,
        );

        // Hide widget if no files or only completed/failed files remain
        if (queuedFiles.isEmpty || (!isProcessing && !hasActiveFiles)) {
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
              if (showQueueStats) _buildHeader(state),

              // Queue management controls
              if (allowQueueManagement && queuedFiles.isNotEmpty)
                _buildQueueControls(context, state),

              // Individual file progress with enhanced visibility
              if (showIndividualProgress) ...[
                _buildScrollableFileList(
                  context,
                  queuedFiles,
                  state,
                  isProcessing,
                ),
              ],

              // Overall progress
              if (isProcessing) _buildOverallProgress(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(upload_states.UploadState state) {
    final queuedFiles = state.currentFiles;
    final isProcessing = state.isUploading;

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

  Widget _buildQueueControls(
    BuildContext context,
    upload_states.UploadState state,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildControlButton(
            icon: Icons.clear_all,
            label: 'Clear Queue',
            onPressed: () => context.read<UploadBloc>().add(
              const upload_events.UploadEvent.clearQueue(),
            ),
            color: AppColors.textSecondary,
          ),
          const Spacer(),
          Text(
            '${state.currentFiles.length} files in queue',
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

  /// Build scrollable file list with enhanced visibility for bulk uploads
  Widget _buildScrollableFileList(
    BuildContext context,
    List<UploadFileModel> queuedFiles,
    upload_states.UploadState state,
    bool isProcessing,
  ) {
    final maxVisibleItems = UploadConfig.maxVisibleQueueItems;
    final showScrollable = queuedFiles.length > maxVisibleItems;

    if (showScrollable) {
      // Show scrollable list for many files
      return Container(
        constraints: const BoxConstraints(maxHeight: 400), // Limit height
        child: Column(
          children: [
            // Show first few items normally
            ...queuedFiles
                .take(3)
                .map(
                  (file) => _buildFileProgressItem(
                    context,
                    file,
                    state,
                    isActive: isProcessing,
                  ),
                ),

            // Scrollable section for remaining files
            if (queuedFiles.length > 3)
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: AppColors.lightGray.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: queuedFiles.length - 3,
                    itemBuilder: (context, index) {
                      final file = queuedFiles[index + 3];
                      return _buildFileProgressItem(
                        context,
                        file,
                        state,
                        isActive: isProcessing,
                      );
                    },
                  ),
                ),
              ),

            // Summary indicator
            if (queuedFiles.length > maxVisibleItems)
              _buildQueueSummary(queuedFiles.length),
          ],
        ),
      );
    } else {
      // Show all files normally for smaller lists
      return Column(
        children: queuedFiles
            .map(
              (file) => _buildFileProgressItem(
                context,
                file,
                state,
                isActive: isProcessing,
              ),
            )
            .toList(),
      );
    }
  }

  Widget _buildFileProgressItem(
    BuildContext context,
    UploadFileModel file,
    upload_states.UploadState state, {
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
              _buildFileActions(context, file, state, isActive),
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
    BuildContext context,
    UploadFileModel file,
    upload_states.UploadState state,
    bool isActive,
  ) {
    switch (file.status) {
      case UploadStatus.failed:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.refresh, size: 18),
              onPressed: () => context.read<UploadBloc>().add(
                upload_events.UploadEvent.retryUpload(failedFiles: [file]),
              ),
              tooltip: 'Retry upload',
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () => context.read<UploadBloc>().add(
                upload_events.UploadEvent.removeFile(fileId: file.id),
              ),
              tooltip: 'Remove',
            ),
          ],
        );
      case UploadStatus.completed:
        return IconButton(
          icon: const Icon(Icons.check_circle, size: 18, color: Colors.green),
          onPressed: () => context.read<UploadBloc>().add(
            upload_events.UploadEvent.removeFile(fileId: file.id),
          ),
          tooltip: 'Remove from list',
        );
      default:
        return IconButton(
          icon: const Icon(Icons.remove_circle_outline, size: 18),
          onPressed: () => context.read<UploadBloc>().add(
            upload_events.UploadEvent.removeFile(fileId: file.id),
          ),
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

  Widget _buildQueueSummary(int totalFiles) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withValues(alpha: 0.05),
        border: Border(
          top: BorderSide(
            color: AppColors.lightGray.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.queue, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(
            'Total: $totalFiles files in queue',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallProgress(upload_states.UploadState state) {
    final total = state.totalFiles;
    final completed = state.when(
      initial: () => 0,
      validating: (_) => 0,
      ready: (_, __, ___, ____, _____) => 0,
      uploading:
          (
            _,
            __,
            completedFiles,
            ___,
            ____,
            _____,
            ______,
            _______,
            ________,
            _________,
          ) => completedFiles,
      paused: (_, completedFiles, __, ___, ____, _____, ______, _______) =>
          completedFiles,
      completed: (_, completedFiles, __, ___, ____, _____, ______) =>
          completedFiles,
      error: (_, __, ___, ____) => 0,
      cancelled: (_, completedFiles, __) => completedFiles,
      success: (uploadedFiles, _, __) => uploadedFiles.length,
      inProgress: (_, __, ___, ____) => 0,
      partialSuccess: (successfulFiles, _, __) => successfulFiles.length,
      networkError: (_, __) => 0,
      storageError: (_, __) => 0,
      validationError: (_, __) => 0,
    );
    final progress = state.progress;

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
