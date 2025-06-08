import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/upload_file_model.dart';

class UploadFileItemWidget extends StatefulWidget {
  final UploadFileModel file;
  final VoidCallback onPause;
  final VoidCallback onCancel;
  final VoidCallback onRetry;

  const UploadFileItemWidget({
    super.key,
    required this.file,
    required this.onPause,
    required this.onCancel,
    required this.onRetry,
  });

  @override
  State<UploadFileItemWidget> createState() => _UploadFileItemWidgetState();
}

class _UploadFileItemWidgetState extends State<UploadFileItemWidget>
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    if (widget.file.status == UploadStatus.uploading) {
      _shimmerController.repeat();
    }
  }

  @override
  void didUpdateWidget(UploadFileItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.file.status == UploadStatus.uploading &&
        oldWidget.file.status != UploadStatus.uploading) {
      _shimmerController.repeat();
    } else if (widget.file.status != UploadStatus.uploading) {
      _shimmerController.stop();
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              // File Icon
              _buildFileIcon(),
              const SizedBox(width: 12),

              // File Info - takes most space
              Expanded(flex: 3, child: _buildFileInfo()),

              const SizedBox(width: 8),

              // Action Buttons - fixed width
              SizedBox(
                width: 80, // Fixed width to prevent overflow
                child: _buildActionButtons(),
              ),
            ],
          ),

          // AI Processing Badge
          if (widget.file.isAiProcessing) _buildAiProcessingBadge(),
        ],
      ),
    );
  }

  Widget _buildFileIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF6B7280), const Color(0xFF4B5563)],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          widget.file.fileTypeIcon,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildFileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // File Name
        Flexible(
          child: Text(
            widget.file.fileName,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        const SizedBox(height: 4),

        // Status and Size
        Flexible(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  _getStatusText(),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: _getStatusColor(),
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.file.fileSize > 0) ...[
                Text(
                  ' • ${widget.file.formattedFileSize}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Progress Bar
        if (widget.file.status == UploadStatus.uploading ||
            widget.file.status == UploadStatus.paused) ...[
          _buildProgressBar(),
        ],
      ],
    );
  }

  Widget _buildProgressBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: widget.file.progress / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.success,
                          AppColors.success.withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                if (widget.file.status == UploadStatus.uploading)
                  AnimatedBuilder(
                    animation: _shimmerAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_shimmerAnimation.value * 100, 0),
                        child: Container(
                          width: 30,
                          height: 6,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.white.withValues(alpha: 0.4),
                                Colors.transparent,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${widget.file.progress.round()}%',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.file.status == UploadStatus.uploading ||
            widget.file.status == UploadStatus.paused) ...[
          _buildActionButton(
            icon: widget.file.status == UploadStatus.paused
                ? Icons.play_arrow
                : Icons.pause,
            color: AppColors.warning,
            backgroundColor: const Color(0xFFFFF3CD),
            onPressed: widget.onPause,
          ),
          if (widget.file.status != UploadStatus.completed)
            const SizedBox(height: 4),
        ],

        if (widget.file.status == UploadStatus.failed) ...[
          _buildActionButton(
            icon: Icons.refresh,
            color: AppColors.info,
            backgroundColor: AppColors.info.withValues(alpha: 0.1),
            onPressed: widget.onRetry,
          ),
          const SizedBox(height: 4),
        ],

        if (widget.file.status != UploadStatus.completed)
          _buildActionButton(
            icon: Icons.close,
            color: const Color(0xFF721C24),
            backgroundColor: const Color(0xFFF8D7DA),
            onPressed: widget.onCancel,
          ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  Widget _buildAiProcessingBadge() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF8B5CF6), const Color(0xFFA855F7)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          'AI',
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String _getStatusText() {
    switch (widget.file.status) {
      case UploadStatus.pending:
        return 'Waiting...';
      case UploadStatus.uploading:
        return widget.file.estimatedTimeRemaining;
      case UploadStatus.paused:
        return 'Paused';
      case UploadStatus.completed:
        return 'Completed';
      case UploadStatus.failed:
        return widget.file.errorMessage ?? 'Failed';
      case UploadStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color _getStatusColor() {
    switch (widget.file.status) {
      case UploadStatus.pending:
        return AppColors.textSecondary;
      case UploadStatus.uploading:
        return AppColors.info;
      case UploadStatus.paused:
        return AppColors.warning;
      case UploadStatus.completed:
        return AppColors.success;
      case UploadStatus.failed:
        return AppColors.error;
      case UploadStatus.cancelled:
        return AppColors.textSecondary;
    }
  }
}
