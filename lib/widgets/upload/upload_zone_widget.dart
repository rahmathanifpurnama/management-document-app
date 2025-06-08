import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_selector/file_selector.dart';
import '../../core/constants/app_colors.dart';
import '../../services/file_validation_service.dart';
import 'file_security_warning_widget.dart';

class UploadZoneWidget extends StatefulWidget {
  final Function(List<XFile>) onFilesSelected;
  final bool isEnabled;
  final bool showValidationWarnings;

  const UploadZoneWidget({
    super.key,
    required this.onFilesSelected,
    this.isEnabled = true,
    this.showValidationWarnings = true,
  });

  @override
  State<UploadZoneWidget> createState() => _UploadZoneWidgetState();
}

class _UploadZoneWidgetState extends State<UploadZoneWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  // Validation state - removed unused field
  final FileValidationService _validationService = FileValidationService();

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isEnabled ? _selectFiles : null,
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) => _scaleController.reverse(),
      onTapCancel: () => _scaleController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              decoration: BoxDecoration(
                color: widget.isEnabled
                    ? const Color(0xFFFAFBFC)
                    : const Color(0xFFF5F5F5),
                border: Border.all(
                  color: widget.isEnabled
                      ? const Color(0xFFD0D7DE)
                      : const Color(0xFFE0E0E0),
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Upload Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: widget.isEnabled
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: widget.isEnabled
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Icon(
                      widget.isEnabled
                          ? Icons.cloud_upload_outlined
                          : Icons.cloud_off_outlined,
                      color: AppColors.textWhite,
                      size: 28,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Main Text
                  Text(
                    widget.isEnabled
                        ? 'Select Multiple Files to Upload'
                        : 'Upload in Progress',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: widget.isEnabled
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  // Subtext
                  Text(
                    widget.isEnabled
                        ? 'Select multiple files at once for batch upload'
                        : 'Please wait while files are being uploaded',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: widget.isEnabled
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight: widget.isEnabled
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // Supported formats
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildFormatChip('PDF'),
                      _buildFormatChip('DOC'),
                      _buildFormatChip('DOCX'),
                      _buildFormatChip('PPTX'),
                      _buildFormatChip('TXT'),
                      _buildFormatChip('JPG'),
                      _buildFormatChip('PNG'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormatChip(String format) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: widget.isEnabled
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.textSecondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isEnabled
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.textSecondary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Text(
        format,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: widget.isEnabled ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }

  Future<void> _selectFiles() async {
    try {
      const typeGroup = XTypeGroup(
        label: 'Documents',
        extensions: [
          'pdf',
          'doc',
          'docx',
          'pptx',
          'txt',
          'jpg',
          'jpeg',
          'png',
          'xlsx',
          'xls',
        ],
      );

      final files = await openFiles(acceptedTypeGroups: [typeGroup]);
      if (files.isNotEmpty) {
        // Perform comprehensive validation
        await _validateAndProcessFiles(files);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting files: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _validateAndProcessFiles(List<XFile> files) async {
    // Show loading indicator
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 12),
              Text('Validating ${files.length} file(s)...'),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    try {
      // Validate all files
      final validationResults = await _validationService.validateFiles(files);

      // Separate valid and invalid files
      final validFiles = <XFile>[];
      final invalidFiles = <String, FileValidationResult>{};

      for (final entry in validationResults.entries) {
        if (entry.value.isValid) {
          final file = files.firstWhere((f) => f.name == entry.key);
          validFiles.add(file);
        } else {
          invalidFiles[entry.key] = entry.value;
        }
      }

      // Show validation warnings if enabled
      if (widget.showValidationWarnings && invalidFiles.isNotEmpty) {
        await _showValidationWarnings(invalidFiles);
      }

      // Process valid files
      if (validFiles.isNotEmpty) {
        widget.onFilesSelected(validFiles);

        if (mounted && invalidFiles.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${validFiles.length} file(s) selected, ${invalidFiles.length} file(s) rejected due to security concerns',
              ),
              backgroundColor: AppColors.warning,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } else if (invalidFiles.isNotEmpty) {
        // All files were invalid
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'All selected files were rejected due to security or validation issues',
              ),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File validation failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _showValidationWarnings(
    Map<String, FileValidationResult> invalidFiles,
  ) async {
    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.security, color: AppColors.securityWarning, size: 24),
            const SizedBox(width: 8),
            Text(
              'File Security Warning',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Some files could not be uploaded due to security or validation issues:',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              const SizedBox(height: 16),
              ...invalidFiles.entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: FileSecurityWarningWidget(
                    errors: entry.value.errors,
                    customMessage: '${entry.key}: ${entry.value.errorMessage}',
                    showIcon: false,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Understood',
              style: GoogleFonts.poppins(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
