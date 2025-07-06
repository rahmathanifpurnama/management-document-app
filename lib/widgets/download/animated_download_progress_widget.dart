import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/document_model.dart';

/// Download states for progress tracking
enum DownloadState { starting, downloading, paused, completed, failed }

/// Enhanced animated download progress widget with network-aware timing
class AnimatedDownloadProgressWidget extends StatefulWidget {
  final DocumentModel document;
  final double progress;
  final DownloadState state;
  final String? errorMessage;
  final VoidCallback? onCancel;
  final VoidCallback? onRetry;
  final Duration? networkSpeed; // For animation timing adjustment

  const AnimatedDownloadProgressWidget({
    super.key,
    required this.document,
    required this.progress,
    required this.state,
    this.errorMessage,
    this.onCancel,
    this.onRetry,
    this.networkSpeed,
  });

  @override
  State<AnimatedDownloadProgressWidget> createState() =>
      _AnimatedDownloadProgressWidgetState();
}

class _AnimatedDownloadProgressWidgetState
    extends State<AnimatedDownloadProgressWidget>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;

  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  double _displayProgress = 0.0;
  double _targetProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Main progress animation controller
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Pulse animation for active downloads
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Shimmer animation for loading state
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Progress animation with smooth curve
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOutCubic),
    );

    // Pulse animation for visual feedback
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Shimmer animation for loading effect
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    // Start appropriate animations based on initial state
    _updateAnimationsForState();
  }

  @override
  void didUpdateWidget(AnimatedDownloadProgressWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.progress != widget.progress) {
      _updateProgress(widget.progress);
    }

    if (oldWidget.state != widget.state) {
      _updateAnimationsForState();
    }
  }

  void _updateProgress(double newProgress) {
    _targetProgress = newProgress.clamp(0.0, 1.0);

    // Calculate animation duration based on network speed
    Duration animationDuration = _calculateAnimationDuration(
      _displayProgress,
      _targetProgress,
    );

    _progressController.duration = animationDuration;

    // Animate from current display progress to target
    final animation = Tween<double>(
      begin: _displayProgress,
      end: _targetProgress,
    ).animate(_progressController);

    animation.addListener(() {
      setState(() {
        _displayProgress = animation.value;
      });
    });

    _progressController.forward(from: 0.0);
  }

  Duration _calculateAnimationDuration(double from, double to) {
    final progressDelta = (to - from).abs();

    // Base duration for smooth animation
    const baseDuration = Duration(milliseconds: 300);

    // Adjust based on network speed if available
    if (widget.networkSpeed != null) {
      final speedFactor = widget.networkSpeed!.inMilliseconds / 1000.0;

      // Fast network (>1MB/s): Minimum 1-2 seconds for visibility
      if (speedFactor > 1.0) {
        return Duration(
          milliseconds: (1000 + (progressDelta * 1000))
              .clamp(300, 2000)
              .round(),
        );
      }
      // Slow network (<100KB/s): Reflect actual speed
      else if (speedFactor < 0.1) {
        return Duration(
          milliseconds: (progressDelta * 5000).clamp(300, 10000).round(),
        );
      }
    }

    // Default smooth animation
    return Duration(
      milliseconds: (baseDuration.inMilliseconds * (1 + progressDelta)).round(),
    );
  }

  void _updateAnimationsForState() {
    switch (widget.state) {
      case DownloadState.starting:
        _shimmerController.repeat();
        _pulseController.stop();
        break;
      case DownloadState.downloading:
        _shimmerController.stop();
        _pulseController.repeat(reverse: true);
        break;
      case DownloadState.paused:
        _shimmerController.stop();
        _pulseController.stop();
        break;
      case DownloadState.completed:
        _shimmerController.stop();
        _pulseController.stop();
        // Brief success animation
        _progressController.animateTo(1.0);
        break;
      case DownloadState.failed:
        _shimmerController.stop();
        _pulseController.stop();
        break;
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _progressAnimation,
        _pulseAnimation,
        _shimmerAnimation,
      ]),
      builder: (context, child) {
        return _buildProgressWidget();
      },
    );
  }

  Widget _buildProgressWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          _buildProgressBar(),
          const SizedBox(height: 8),
          _buildProgressInfo(),
          if (widget.state == DownloadState.failed) ...[
            const SizedBox(height: 12),
            _buildErrorSection(),
          ],
          if (widget.state != DownloadState.completed) ...[
            const SizedBox(height: 12),
            _buildActionButtons(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // File icon with pulse animation for active downloads
        Transform.scale(
          scale: widget.state == DownloadState.downloading
              ? _pulseAnimation.value
              : 1.0,
          child: Icon(_getFileIcon(), color: _getStateColor(), size: 24),
        ),
        const SizedBox(width: 12),
        // File name and size
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.document.fileName,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (widget.document.fileSize != null) ...[
                const SizedBox(height: 2),
                Text(
                  _formatFileSize(widget.document.fileSize!),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        // State indicator
        _buildStateIndicator(),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        // Custom animated progress bar
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.circular(3),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Stack(
              children: [
                // Background
                Container(width: double.infinity, color: AppColors.lightGray),
                // Progress fill
                FractionallySizedBox(
                  widthFactor: _displayProgress,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getStateColor(),
                          _getStateColor().withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                ),
                // Shimmer effect for starting state
                if (widget.state == DownloadState.starting)
                  _buildShimmerEffect(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerEffect() {
    return Transform.translate(
      offset: Offset(_shimmerAnimation.value * 200, 0),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.white.withValues(alpha: 0.4),
              Colors.transparent,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _getStateText(),
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '${(_displayProgress * 100).toStringAsFixed(0)}%',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _getStateColor(),
          ),
        ),
      ],
    );
  }

  Widget _buildStateIndicator() {
    switch (widget.state) {
      case DownloadState.starting:
        return SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(_getStateColor()),
          ),
        );
      case DownloadState.downloading:
        return Icon(Icons.download, color: _getStateColor(), size: 16);
      case DownloadState.paused:
        return Icon(
          Icons.pause_circle_outline,
          color: _getStateColor(),
          size: 16,
        );
      case DownloadState.completed:
        return Icon(Icons.check_circle, color: _getStateColor(), size: 16);
      case DownloadState.failed:
        return Icon(Icons.error_outline, color: _getStateColor(), size: 16);
    }
  }

  Widget _buildErrorSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.errorMessage ?? 'Download failed',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (widget.state == DownloadState.failed && widget.onRetry != null) ...[
          TextButton.icon(
            onPressed: widget.onRetry,
            icon: const Icon(Icons.refresh, size: 16),
            label: Text('Retry', style: GoogleFonts.poppins(fontSize: 12)),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
          ),
          const SizedBox(width: 8),
        ],
        if (widget.state != DownloadState.completed &&
            widget.state != DownloadState.failed &&
            widget.onCancel != null) ...[
          TextButton.icon(
            onPressed: widget.onCancel,
            icon: const Icon(Icons.close, size: 16),
            label: Text('Cancel', style: GoogleFonts.poppins(fontSize: 12)),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
          ),
        ],
      ],
    );
  }

  // Helper methods
  IconData _getFileIcon() {
    final extension = widget.document.fileName.split('.').last.toLowerCase();
    switch (extension) {
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
      case 'gif':
        return Icons.image;
      case 'mp4':
      case 'avi':
      case 'mov':
        return Icons.video_file;
      case 'mp3':
      case 'wav':
        return Icons.audio_file;
      case 'zip':
      case 'rar':
        return Icons.archive;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getStateColor() {
    switch (widget.state) {
      case DownloadState.starting:
        return AppColors.warning;
      case DownloadState.downloading:
        return AppColors.primary;
      case DownloadState.paused:
        return AppColors.textSecondary;
      case DownloadState.completed:
        return AppColors.success;
      case DownloadState.failed:
        return AppColors.error;
    }
  }

  String _getStateText() {
    switch (widget.state) {
      case DownloadState.starting:
        return 'Preparing download...';
      case DownloadState.downloading:
        return 'Downloading...';
      case DownloadState.paused:
        return 'Paused';
      case DownloadState.completed:
        return 'Download completed';
      case DownloadState.failed:
        return 'Download failed';
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
