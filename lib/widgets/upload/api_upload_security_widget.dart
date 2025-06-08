import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_selector/file_selector.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/cloud_functions_service.dart';

/// Upload Security Widget that integrates with Firebase Cloud Functions validation API
class ApiUploadSecurityWidget extends StatefulWidget {
  final List<XFile>? selectedFiles;
  final Function(List<Map<String, dynamic>>)? onValidationComplete;
  final bool showSecurityStatus;

  const ApiUploadSecurityWidget({
    super.key,
    this.selectedFiles,
    this.onValidationComplete,
    this.showSecurityStatus = true,
  });

  @override
  State<ApiUploadSecurityWidget> createState() =>
      _ApiUploadSecurityWidgetState();
}

class _ApiUploadSecurityWidgetState extends State<ApiUploadSecurityWidget> {
  final CloudFunctionsService _cloudFunctions = CloudFunctionsService.instance;

  List<Map<String, dynamic>> _validationResults = [];
  bool _isValidating = false;
  bool _hasValidationErrors = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedFiles != null && widget.selectedFiles!.isNotEmpty) {
      _validateFiles();
    }
  }

  @override
  void didUpdateWidget(ApiUploadSecurityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Re-validate if files changed
    if (widget.selectedFiles != oldWidget.selectedFiles) {
      if (widget.selectedFiles != null && widget.selectedFiles!.isNotEmpty) {
        _validateFiles();
      } else {
        setState(() {
          _validationResults.clear();
          _hasValidationErrors = false;
        });
      }
    }
  }

  Future<void> _validateFiles() async {
    if (widget.selectedFiles == null || widget.selectedFiles!.isEmpty) {
      return;
    }

    setState(() {
      _isValidating = true;
      _validationResults.clear();
      _hasValidationErrors = false;
    });

    final results = <Map<String, dynamic>>[];

    for (final file in widget.selectedFiles!) {
      try {
        final fileSize = await file.length();
        final fileName = file.name;
        final mimeType = file.mimeType ?? 'application/octet-stream';

        // Call Firebase Cloud Functions validation API
        final validationResult = await _cloudFunctions.validateFile(
          fileName: fileName,
          fileSize: fileSize,
          contentType: mimeType,
        );

        results.add({
          'file': file,
          'fileName': fileName,
          'fileSize': fileSize,
          'mimeType': mimeType,
          'validation': validationResult,
          'isValid': validationResult['isValid'] ?? false,
          'error': validationResult['error'],
        });

        // Check for validation errors
        if (!(validationResult['isValid'] ?? false)) {
          _hasValidationErrors = true;
        }
      } catch (e) {
        results.add({
          'file': file,
          'fileName': file.name,
          'fileSize': 0,
          'mimeType': 'unknown',
          'validation': {'isValid': false, 'error': e.toString()},
          'isValid': false,
          'error': e.toString(),
        });
        _hasValidationErrors = true;
      }
    }

    if (mounted) {
      setState(() {
        _validationResults = results;
        _isValidating = false;
      });

      // Notify parent widget
      if (widget.onValidationComplete != null) {
        widget.onValidationComplete!(results);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showSecurityStatus && _validationResults.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
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
          _buildHeader(),
          const SizedBox(height: 16),

          if (_isValidating)
            _buildValidatingWidget()
          else if (_validationResults.isEmpty)
            _buildEmptyState()
          else
            _buildValidationResults(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          _hasValidationErrors ? Icons.security_outlined : Icons.verified_user,
          color: _hasValidationErrors ? AppColors.warning : AppColors.success,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          'Upload Security',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        if (_validationResults.isNotEmpty && !_isValidating)
          IconButton(
            icon: const Icon(Icons.refresh, size: 18),
            onPressed: _validateFiles,
            tooltip: 'Re-validate files',
          ),
      ],
    );
  }

  Widget _buildValidatingWidget() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Validating files...',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(
            Icons.shield_outlined,
            size: 48,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No files to validate',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select files to see security validation results',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildValidationResults() {
    return Column(
      children: [
        // Summary
        _buildValidationSummary(),
        const SizedBox(height: 16),

        // Individual file results
        ...(_validationResults.map(
          (result) => _buildFileValidationItem(result),
        )),
      ],
    );
  }

  Widget _buildValidationSummary() {
    final totalFiles = _validationResults.length;
    final validFiles = _validationResults
        .where((r) => r['isValid'] == true)
        .length;
    final invalidFiles = totalFiles - validFiles;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _hasValidationErrors
            ? AppColors.error.withValues(alpha: 0.1)
            : AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _hasValidationErrors ? AppColors.error : AppColors.success,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _hasValidationErrors ? Icons.warning : Icons.check_circle,
            color: _hasValidationErrors ? AppColors.error : AppColors.success,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _hasValidationErrors
                      ? 'Security Issues Detected'
                      : 'All Files Validated',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _hasValidationErrors
                        ? AppColors.error
                        : AppColors.success,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$validFiles valid, $invalidFiles invalid out of $totalFiles files',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: _hasValidationErrors
                        ? AppColors.error
                        : AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileValidationItem(Map<String, dynamic> result) {
    final fileName = result['fileName'] as String;
    final fileSize = result['fileSize'] as int;
    final mimeType = result['mimeType'] as String;
    final isValid = result['isValid'] as bool;
    final error = result['error'] as String?;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isValid
            ? AppColors.lightBlue.withValues(alpha: 0.1)
            : AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isValid ? AppColors.lightBlue : AppColors.error,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isValid ? Icons.check_circle : Icons.error,
                color: isValid ? AppColors.success : AppColors.error,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  fileName,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // File details
          Row(
            children: [
              _buildDetailChip('Size', _formatBytes(fileSize)),
              const SizedBox(width: 8),
              _buildDetailChip('Type', _getFileTypeDisplay(mimeType)),
            ],
          ),

          // Error message if invalid
          if (!isValid && error != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.error, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      error,
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
    );
  }

  Widget _buildDetailChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$label: $value',
        style: GoogleFonts.poppins(
          fontSize: 10,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _getFileTypeDisplay(String mimeType) {
    switch (mimeType) {
      case 'application/pdf':
        return 'PDF';
      case 'application/msword':
      case 'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
        return 'DOC';
      case 'application/vnd.ms-excel':
      case 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
        return 'Excel';
      case 'application/vnd.ms-powerpoint':
      case 'application/vnd.openxmlformats-officedocument.presentationml.presentation':
        return 'PPT';
      case 'image/jpeg':
      case 'image/png':
      case 'image/gif':
        return 'Image';
      case 'text/plain':
        return 'Text';
      default:
        return 'Other';
    }
  }
}
