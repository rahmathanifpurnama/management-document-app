import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

/// Enhanced loading animation widget for deletion operations
class EnhancedDeletionLoading extends StatefulWidget {
  final String fileName;
  final String operationType; // 'single' or 'bulk'
  final int? currentProgress;
  final int? totalFiles;
  final VoidCallback? onCancel;
  final bool showProgress;

  const EnhancedDeletionLoading({
    super.key,
    required this.fileName,
    this.operationType = 'single',
    this.currentProgress,
    this.totalFiles,
    this.onCancel,
    this.showProgress = true,
  });

  @override
  State<EnhancedDeletionLoading> createState() =>
      _EnhancedDeletionLoadingState();
}

class _EnhancedDeletionLoadingState extends State<EnhancedDeletionLoading>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Rotation animation for the loading indicator
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    // Scale animation for the pulsing effect
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    // Start animations
    _rotationController.repeat();
    _scaleController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated loading indicator
          AnimatedBuilder(
            animation: Listenable.merge([_rotationAnimation, _scaleAnimation]),
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Transform.rotate(
                  angle: _rotationAnimation.value * 2 * 3.14159,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.error,
                          AppColors.error.withValues(alpha: 0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // Title
          Text(
            widget.operationType == 'bulk' ? 'Deleting Files' : 'Deleting File',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 8),

          // File name or progress
          if (widget.operationType == 'single') ...[
            Text(
              widget.fileName,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ] else ...[
            if (widget.showProgress &&
                widget.currentProgress != null &&
                widget.totalFiles != null) ...[
              Text(
                'Progress: ${widget.currentProgress}/${widget.totalFiles}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: widget.currentProgress! / widget.totalFiles!,
                backgroundColor: AppColors.error.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.error),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              'Current: ${widget.fileName}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          const SizedBox(height: 16),

          // Status message
          Text(
            widget.operationType == 'bulk'
                ? 'Please wait while files are being deleted...'
                : 'Please wait while the file is being deleted...',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          // Cancel button (optional)
          if (widget.onCancel != null) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: widget.onCancel,
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Show enhanced deletion loading dialog
Future<void> showEnhancedDeletionLoading({
  required BuildContext context,
  required String fileName,
  String operationType = 'single',
  int? currentProgress,
  int? totalFiles,
  VoidCallback? onCancel,
  bool showProgress = true,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: EnhancedDeletionLoading(
        fileName: fileName,
        operationType: operationType,
        currentProgress: currentProgress,
        totalFiles: totalFiles,
        onCancel: onCancel,
        showProgress: showProgress,
      ),
    ),
  );
}

/// Enhanced deletion result dialog
class EnhancedDeletionResult extends StatelessWidget {
  final bool success;
  final String message;
  final String? errorDetails;
  final VoidCallback? onRetry;
  final VoidCallback? onClose;

  const EnhancedDeletionResult({
    super.key,
    required this.success,
    required this.message,
    this.errorDetails,
    this.onRetry,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Result icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: success ? AppColors.success : AppColors.error,
              ),
              child: Icon(
                success ? Icons.check : Icons.error,
                color: Colors.white,
                size: 30,
              ),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              success ? 'Deletion Successful' : 'Deletion Failed',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            // Message
            Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            // Error details (if any)
            if (!success && errorDetails != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  errorDetails!,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!success && onRetry != null) ...[
                  Expanded(
                    child: TextButton(
                      onPressed: onRetry,
                      child: Text(
                        'Retry',
                        style: GoogleFonts.poppins(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: onClose ?? () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: success
                          ? AppColors.success
                          : AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
