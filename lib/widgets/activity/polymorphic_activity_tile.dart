import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/activity_model.dart';
import '../../models/activity_types.dart';

/// Polymorphic activity tile that renders based on activity type
class PolymorphicActivityTile extends StatelessWidget {
  final BaseActivity activity;
  final bool isLast;
  final VoidCallback? onTap;
  final bool showContextInfo;
  final bool showTimestamp;

  const PolymorphicActivityTile({
    super.key,
    required this.activity,
    this.isLast = false,
    this.onTap,
    this.showContextInfo = true,
    this.showTimestamp = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildActivityIcon(),
                const SizedBox(width: 12),
                Expanded(child: _buildActivityContent()),
                if (activity.hasContext && showContextInfo)
                  _buildContextIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build activity icon with type-specific styling
  Widget _buildActivityIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: activity.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: activity.color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Icon(activity.icon, color: activity.color, size: 24),
    );
  }

  /// Build activity content based on type
  Widget _buildActivityContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title with type-specific formatting
        Text(
          activity.displayTitle,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),

        // Subtitle with user information
        Text(
          activity.displaySubtitle,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        // Context information for specific activity types
        if (showContextInfo && activity.contextInfo.isNotEmpty) ...[
          const SizedBox(height: 4),
          _buildContextInfo(),
        ],

        // Timestamp
        if (showTimestamp) ...[
          const SizedBox(height: 4),
          Text(
            _formatTimestamp(activity.timestamp),
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ],
    );
  }

  /// Build context information display
  Widget _buildContextInfo() {
    final contextInfo = activity.contextInfo
        .take(2)
        .toList(); // Show max 2 items

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: contextInfo
          .map(
            (info) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: activity.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: activity.color.withValues(alpha: 0.2),
                  width: 0.5,
                ),
              ),
              child: Text(
                info,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: activity.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  /// Build context indicator for activities with additional information
  Widget _buildContextIndicator() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(Icons.info_outline, size: 16, color: AppColors.primary),
    );
  }

  /// Format timestamp for display
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

/// Specialized tile for authentication activities
class AuthActivityTile extends PolymorphicActivityTile {
  const AuthActivityTile({
    super.key,
    required super.activity,
    super.isLast = false,
    super.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final authActivity = activity as AuthActivity;

    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildAuthIcon(authActivity),
                const SizedBox(width: 12),
                Expanded(child: _buildAuthContent(authActivity)),
                _buildAuthStatus(authActivity),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthIcon(AuthActivity authActivity) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: authActivity.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: authActivity.color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(authActivity.icon, color: authActivity.color, size: 24),
          ),
          if (authActivity.isSuspicious)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Icon(Icons.warning, size: 8, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAuthContent(AuthActivity authActivity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          authActivity.displayTitle,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          authActivity.displaySubtitle,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        if (authActivity.ipAddress != null) ...[
          const SizedBox(height: 4),
          Text(
            'IP: ${authActivity.ipAddress}',
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
              fontFamily: 'monospace',
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAuthStatus(AuthActivity authActivity) {
    if (authActivity is LoginActivity) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: authActivity.isSuccessful
              ? AppColors.success.withValues(alpha: 0.1)
              : AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          authActivity.isSuccessful ? 'Success' : 'Failed',
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: authActivity.isSuccessful
                ? AppColors.success
                : AppColors.error,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

/// Specialized tile for file activities
class FileActivityTile extends PolymorphicActivityTile {
  const FileActivityTile({
    super.key,
    required super.activity,
    super.isLast = false,
    super.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fileActivity = activity as FileActivity;

    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildFileIcon(fileActivity),
                const SizedBox(width: 12),
                Expanded(child: _buildFileContent(fileActivity)),
                _buildFileInfo(fileActivity),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileIcon(FileActivity fileActivity) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: fileActivity.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: fileActivity.color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              _getFileTypeIcon(fileActivity.fileType),
              color: fileActivity.color,
              size: 24,
            ),
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: fileActivity.color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Icon(fileActivity.icon, size: 10, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileContent(FileActivity fileActivity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fileActivity.displayTitle,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          fileActivity.displaySubtitle,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        if (fileActivity.fileName != null) ...[
          const SizedBox(height: 4),
          Text(
            fileActivity.fileName!,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppColors.textSecondary.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildFileInfo(FileActivity fileActivity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (fileActivity.fileSize != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _formatFileSize(fileActivity.fileSize!),
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.info,
              ),
            ),
          ),
        if (fileActivity is FileUploadActivity)
          _buildUploadStatus(fileActivity),
      ],
    );
  }

  Widget _buildUploadStatus(FileActivity fileActivity) {
    if (fileActivity is! FileUploadActivity) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: fileActivity.isSuccessful
                ? AppColors.success.withValues(alpha: 0.1)
                : AppColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            fileActivity.isSuccessful ? 'Success' : 'Failed',
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: fileActivity.isSuccessful
                  ? AppColors.success
                  : AppColors.error,
            ),
          ),
        ),
      ],
    );
  }

  IconData _getFileTypeIcon(String? fileType) {
    if (fileType == null) return Icons.insert_drive_file;

    final type = fileType.toLowerCase();
    if (type.contains('pdf')) return Icons.picture_as_pdf;
    if (type.contains('image') ||
        type.contains('jpg') ||
        type.contains('png')) {
      return Icons.image;
    }
    if (type.contains('video')) return Icons.video_file;
    if (type.contains('audio')) return Icons.audio_file;
    if (type.contains('text') || type.contains('doc')) return Icons.description;
    if (type.contains('zip') || type.contains('rar')) return Icons.archive;

    return Icons.insert_drive_file;
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
