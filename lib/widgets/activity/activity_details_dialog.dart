import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/activity_model.dart';
import '../../models/activity_types.dart';

/// Polymorphic activity details dialog that adapts based on activity type
class ActivityDetailsDialog extends StatelessWidget {
  final BaseActivity activity;

  const ActivityDetailsDialog({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildContent(),
              ),
            ),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: activity.color.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: activity.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: activity.color.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              activity.icon,
              color: activity.color,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.displayTitle,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.displaySubtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (activity.isSuspicious)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.error, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.warning,
                    size: 16,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Suspicious',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Basic information
        _buildSection(
          'Basic Information',
          [
            _buildDetailRow('Activity Type', activity.activityType.actionDescription),
            _buildDetailRow('Timestamp', _formatTimestamp(activity.timestamp)),
            _buildDetailRow('User ID', activity.userId),
            if (activity.userName != null)
              _buildDetailRow('User Name', activity.userName!),
            if (activity.userEmail != null)
              _buildDetailRow('User Email', activity.userEmail!),
          ],
        ),

        // Type-specific information
        if (activity is AuthActivity) _buildAuthSection(activity as AuthActivity),
        if (activity is FileActivity) _buildFileSection(activity as FileActivity),
        if (activity is ActivityModel) _buildLegacySection(activity as ActivityModel),

        // Context information
        if (activity.contextInfo.isNotEmpty) _buildContextSection(),

        // Technical details
        _buildTechnicalSection(),

        // Additional details
        if (activity.details.isNotEmpty) _buildAdditionalDetailsSection(),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAuthSection(AuthActivity authActivity) {
    final details = <Widget>[];
    
    if (authActivity.deviceInfo != null) {
      details.add(_buildDetailRow('Device', authActivity.deviceInfo!));
    }
    
    if (authActivity.sessionId != null) {
      details.add(_buildDetailRow('Session ID', authActivity.sessionId!));
    }
    
    if (authActivity is LoginActivity) {
      final loginActivity = authActivity;
      details.add(_buildDetailRow(
        'Status', 
        loginActivity.isSuccessful ? 'Successful' : 'Failed',
        valueColor: loginActivity.isSuccessful ? AppColors.success : AppColors.error,
      ));
      
      if (!loginActivity.isSuccessful && loginActivity.failureReason != null) {
        details.add(_buildDetailRow('Failure Reason', loginActivity.failureReason!));
      }
    }
    
    if (authActivity is LogoutActivity) {
      final logoutActivity = authActivity;
      if (logoutActivity.reason != null) {
        details.add(_buildDetailRow('Reason', logoutActivity.reason!));
      }
    }
    
    if (details.isEmpty) return const SizedBox.shrink();
    
    return _buildSection('Authentication Details', details);
  }

  Widget _buildFileSection(FileActivity fileActivity) {
    final details = <Widget>[
      if (fileActivity.fileName != null)
        _buildDetailRow('File Name', fileActivity.fileName!),
      if (fileActivity.fileSize != null)
        _buildDetailRow('File Size', _formatFileSize(fileActivity.fileSize!)),
      if (fileActivity.fileType != null)
        _buildDetailRow('File Type', fileActivity.fileType!),
      if (fileActivity.filePath != null)
        _buildDetailRow('File Path', fileActivity.filePath!),
    ];
    
    if (fileActivity is FileUploadActivity) {
      final uploadActivity = fileActivity;
      if (uploadActivity.categoryId != null) {
        details.add(_buildDetailRow('Category ID', uploadActivity.categoryId!));
      }
      if (uploadActivity.uploadPath != null) {
        details.add(_buildDetailRow('Upload Path', uploadActivity.uploadPath!));
      }
      details.add(_buildDetailRow(
        'Upload Status',
        uploadActivity.isSuccessful ? 'Successful' : 'Failed',
        valueColor: uploadActivity.isSuccessful ? AppColors.success : AppColors.error,
      ));
      if (!uploadActivity.isSuccessful && uploadActivity.errorMessage != null) {
        details.add(_buildDetailRow('Error Message', uploadActivity.errorMessage!));
      }
    }
    
    if (fileActivity is FileDownloadActivity) {
      final downloadActivity = fileActivity;
      if (downloadActivity.downloadPath != null) {
        details.add(_buildDetailRow('Download Path', downloadActivity.downloadPath!));
      }
      details.add(_buildDetailRow(
        'Download Status',
        downloadActivity.isSuccessful ? 'Successful' : 'Failed',
        valueColor: downloadActivity.isSuccessful ? AppColors.success : AppColors.error,
      ));
      if (!downloadActivity.isSuccessful && downloadActivity.errorMessage != null) {
        details.add(_buildDetailRow('Error Message', downloadActivity.errorMessage!));
      }
    }
    
    if (details.isEmpty) return const SizedBox.shrink();
    
    return _buildSection('File Details', details);
  }

  Widget _buildLegacySection(ActivityModel legacyActivity) {
    final details = <Widget>[];
    
    if (legacyActivity.documentId != null) {
      details.add(_buildDetailRow('Document ID', legacyActivity.documentId!));
    }
    
    if (legacyActivity.categoryId != null) {
      details.add(_buildDetailRow('Category ID', legacyActivity.categoryId!));
    }
    
    if (details.isEmpty) return const SizedBox.shrink();
    
    return _buildSection('Legacy Details', details);
  }

  Widget _buildContextSection() {
    return _buildSection(
      'Context Information',
      activity.contextInfo.map((info) => _buildDetailRow('Info', info)).toList(),
    );
  }

  Widget _buildTechnicalSection() {
    final details = <Widget>[];
    
    if (activity.ipAddress != null) {
      details.add(_buildDetailRow('IP Address', activity.ipAddress!));
    }
    
    if (activity.userAgent != null) {
      details.add(_buildDetailRow('User Agent', activity.userAgent!));
    }
    
    details.add(_buildDetailRow('Activity ID', activity.id));
    
    return _buildSection('Technical Details', details);
  }

  Widget _buildAdditionalDetailsSection() {
    return _buildSection(
      'Additional Details',
      activity.details.entries.map((entry) => 
        _buildDetailRow(
          entry.key.toUpperCase(),
          entry.value.toString(),
        )
      ).toList(),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: valueColor ?? AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} at ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
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
