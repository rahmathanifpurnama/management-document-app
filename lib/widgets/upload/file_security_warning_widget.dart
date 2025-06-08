import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../services/file_validation_service.dart';

class FileSecurityWarningWidget extends StatelessWidget {
  final List<FileValidationError> errors;
  final String? customMessage;
  final VoidCallback? onDismiss;
  final bool showIcon;

  const FileSecurityWarningWidget({
    super.key,
    required this.errors,
    this.customMessage,
    this.onDismiss,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    if (errors.isEmpty && customMessage == null) {
      return const SizedBox.shrink();
    }

    final severity = _getErrorSeverity(errors);
    final color = _getColorForSeverity(severity);
    final icon = _getIconForSeverity(severity);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showIcon) ...[
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTitle(severity),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  customMessage ?? _generateMessage(errors),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (_shouldShowRecommendations(errors)) ...[
                  const SizedBox(height: 8),
                  _buildRecommendations(errors),
                ],
              ],
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: onDismiss,
              icon: const Icon(Icons.close),
              iconSize: 20,
              color: AppColors.textSecondary,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            ),
          ],
        ],
      ),
    );
  }

  SecuritySeverity _getErrorSeverity(List<FileValidationError> errors) {
    if (errors.contains(FileValidationError.dangerousExtension) ||
        errors.contains(FileValidationError.suspiciousFilename)) {
      return SecuritySeverity.danger;
    }

    if (errors.contains(FileValidationError.invalidMagicNumber) ||
        errors.contains(FileValidationError.invalidMimeType)) {
      return SecuritySeverity.warning;
    }

    return SecuritySeverity.info;
  }

  Color _getColorForSeverity(SecuritySeverity severity) {
    switch (severity) {
      case SecuritySeverity.danger:
        return AppColors.securityDanger;
      case SecuritySeverity.warning:
        return AppColors.securityWarning;
      case SecuritySeverity.info:
        return AppColors.info;
    }
  }

  IconData _getIconForSeverity(SecuritySeverity severity) {
    switch (severity) {
      case SecuritySeverity.danger:
        return Icons.dangerous;
      case SecuritySeverity.warning:
        return Icons.warning;
      case SecuritySeverity.info:
        return Icons.info;
    }
  }

  String _getTitle(SecuritySeverity severity) {
    switch (severity) {
      case SecuritySeverity.danger:
        return 'Security Risk Detected';
      case SecuritySeverity.warning:
        return 'File Validation Warning';
      case SecuritySeverity.info:
        return 'File Information';
    }
  }

  String _generateMessage(List<FileValidationError> errors) {
    if (errors.isEmpty) return '';

    final messages = <String>[];
    for (final error in errors) {
      switch (error) {
        case FileValidationError.dangerousExtension:
          messages.add(
            'This file type is potentially dangerous and cannot be uploaded for security reasons.',
          );
          break;
        case FileValidationError.suspiciousFilename:
          messages.add(
            'The filename contains suspicious patterns that may indicate malware.',
          );
          break;
        case FileValidationError.invalidMagicNumber:
          messages.add(
            'The file content does not match its extension. This could indicate file corruption or tampering.',
          );
          break;
        case FileValidationError.invalidExtension:
          messages.add(
            'This file type is not supported. Please use one of the allowed file formats.',
          );
          break;
        case FileValidationError.fileTooLarge:
          messages.add('The file size exceeds the maximum allowed limit.');
          break;
        case FileValidationError.invalidMimeType:
          messages.add('The file format is not valid or supported.');
          break;
        case FileValidationError.filenameTooLong:
          messages.add('The filename is too long. Please use a shorter name.');
          break;
        case FileValidationError.filenameTooShort:
          messages.add(
            'The filename is too short. Please provide a proper name.',
          );
          break;
        case FileValidationError.cannotReadFile:
          messages.add(
            'Unable to read the file. It may be corrupted or inaccessible.',
          );
          break;
        case FileValidationError.emptyFile:
          messages.add('The file appears to be empty.');
          break;
      }
    }

    return messages.join(' ');
  }

  bool _shouldShowRecommendations(List<FileValidationError> errors) {
    return errors.contains(FileValidationError.invalidExtension) ||
        errors.contains(FileValidationError.fileTooLarge) ||
        errors.contains(FileValidationError.dangerousExtension);
  }

  Widget _buildRecommendations(List<FileValidationError> errors) {
    final recommendations = <String>[];

    if (errors.contains(FileValidationError.invalidExtension) ||
        errors.contains(FileValidationError.dangerousExtension)) {
      recommendations.add(
        '• Use supported formats: PDF, DOC, DOCX, PPTX, TXT, JPG, PNG, XLSX, XLS',
      );
    }

    if (errors.contains(FileValidationError.fileTooLarge)) {
      recommendations.add(
        '• Compress your file or split it into smaller parts',
      );
      recommendations.add(
        '• Maximum size: 10MB for most files, 5MB for images',
      );
    }

    if (recommendations.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommendations:',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          ...recommendations.map(
            (rec) => Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                rec,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum SecuritySeverity { info, warning, danger }

// Helper widget for showing file validation summary
class FileValidationSummaryWidget extends StatelessWidget {
  final Map<String, FileValidationResult> validationResults;
  final VoidCallback? onRetry;

  const FileValidationSummaryWidget({
    super.key,
    required this.validationResults,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final validFiles = validationResults.values.where((r) => r.isValid).length;
    final invalidFiles = validationResults.values
        .where((r) => !r.isValid)
        .length;
    final totalFiles = validationResults.length;

    if (totalFiles == 0) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                invalidFiles > 0 ? Icons.warning : Icons.check_circle,
                color: invalidFiles > 0 ? AppColors.warning : AppColors.success,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'File Validation Summary',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildSummaryItem('Total', totalFiles.toString(), AppColors.info),
              const SizedBox(width: 16),
              _buildSummaryItem(
                'Valid',
                validFiles.toString(),
                AppColors.success,
              ),
              const SizedBox(width: 16),
              _buildSummaryItem(
                'Invalid',
                invalidFiles.toString(),
                AppColors.error,
              ),
            ],
          ),
          if (invalidFiles > 0 && onRetry != null) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 16),
              label: Text(
                'Select Different Files',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
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
