import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_selector/file_selector.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../providers/consolidated_upload_provider.dart';
import '../../widgets/upload/duplicate_file_dialog.dart';

import '../../models/upload_file_model.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/upload/upload_zone_widget.dart';
import '../../widgets/upload/upload_success_dialog.dart';
import '../../widgets/upload/api_storage_quota_widget.dart';
import '../../widgets/upload/api_upload_security_widget.dart';
import '../../widgets/upload/api_enhanced_upload_widget.dart';
import '../../services/ui_refresh_service.dart';
import '../../widgets/common/file_filter_widget.dart';
import '../../widgets/common/file_selection_bar.dart';

class UploadDocumentScreen extends StatefulWidget {
  final String? categoryId;

  const UploadDocumentScreen({super.key, this.categoryId});

  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen>
    with DuplicateFileHandler {
  bool _hasCompletedUploads = false;
  int _lastCompletedCount = 0;

  // API Integration state
  List<XFile> _selectedFiles = [];
  List<Map<String, dynamic>> _validationResults = [];
  bool _showApiWidgets = false;

  // Filter state
  final String _selectedFileTypeFilter = 'all';

  @override
  void initState() {
    super.initState();

    // Initialize upload provider context after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final uploadProvider = Provider.of<ConsolidatedUploadProvider>(
        context,
        listen: false,
      );

      // Clear any previous upload state for clean UI
      uploadProvider.clearAllAndReset();

      // Set up provider
      uploadProvider.setContext(context);
      uploadProvider.setUploadCompletionCallback(_showSuccessDialog);

      // Set category if provided
      if (widget.categoryId != null) {
        uploadProvider.setCurrentCategory(widget.categoryId);
      }
    });
  }

  @override
  void dispose() {
    // Trigger UI refresh when leaving upload screen if uploads were completed
    if (_hasCompletedUploads) {
      _triggerUIRefreshOnExit();
    }
    super.dispose();
  }

  // Check for completed uploads and trigger UI refresh
  void _checkForCompletedUploads(ConsolidatedUploadProvider uploadProvider) {
    final currentCompletedCount = uploadProvider.completedFiles;

    // If new uploads have completed since last check
    if (currentCompletedCount > _lastCompletedCount) {
      _lastCompletedCount = currentCompletedCount;
      _hasCompletedUploads = true;

      // Schedule notification to show after build completes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showUploadSuccessNotification(currentCompletedCount);
        }
      });

      // Trigger comprehensive UI refresh using service
      UIRefreshService.refreshAfterUpload(
        context,
        categoryId: widget.categoryId,
      );

      // Schedule auto-clear for successful uploads
      _scheduleAutoClear();

      debugPrint(
        '🔄 UI refreshed after upload completion ($currentCompletedCount files completed)',
      );
    }
  }

  // Show success notification
  void _showUploadSuccessNotification(int completedCount) {
    // Safety check to ensure widget is still mounted and context is valid
    if (!mounted) return;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$completedCount file(s) uploaded successfully!',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () {
              if (mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }
            },
          ),
        ),
      );
    } catch (e) {
      debugPrint('❌ Error showing success notification: $e');
    }
  }

  // Trigger UI refresh when exiting upload screen
  void _triggerUIRefreshOnExit() {
    UIRefreshService.refreshOnNavigationExit(context);
  }

  // Show success dialog when all uploads are completed
  void _showSuccessDialog() {
    if (!mounted) return;

    final uploadProvider = Provider.of<ConsolidatedUploadProvider>(
      context,
      listen: false,
    );

    // Only show dialog if there are completed uploads
    if (uploadProvider.hasSuccessfulUploads || uploadProvider.failedFiles > 0) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => UploadSuccessDialog(
          completedFiles: uploadProvider.completedFiles,
          failedFiles: uploadProvider.failedFiles,
          onBackToHome: () {
            // Clear upload state before navigating
            uploadProvider.clearAllAndReset();
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
          },
        ),
      );
    }
  }

  // Auto-clear completed uploads after a delay to keep UI clean
  void _scheduleAutoClear() {
    if (!mounted) return;

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        final uploadProvider = Provider.of<ConsolidatedUploadProvider>(
          context,
          listen: false,
        );
        if (uploadProvider.hasSuccessfulUploads &&
            uploadProvider.failedFiles == 0) {
          // Only auto-clear if all uploads succeeded (no failed uploads to retry)
          uploadProvider.clearCompleted();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: CustomAppBar(
        title: 'Upload File',
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        leading: Container(
          margin: const EdgeInsets.only(
            left: 12,
          ), // Add margin to align with body content
          child: Material(
            color: Colors.transparent, // Transparent background
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.textWhite,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Consumer<ConsolidatedUploadProvider>(
          builder: (context, uploadProvider, child) {
            // Schedule check for completed uploads after build completes
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _checkForCompletedUploads(uploadProvider);
              }
            });

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Storage Quota Widget - Always visible
                  const ApiStorageQuotaWidget(
                    showCleanupButton: true,
                    autoRefresh: true,
                  ),

                  const SizedBox(height: 16),

                  // Upload Zone - Always visible for consistency
                  UploadZoneWidget(
                    onFilesSelected: (files) => _handleFilesSelected(files),
                    isEnabled: !uploadProvider.isUploading,
                  ),

                  const SizedBox(height: 16),

                  // Upload Security Widget - Show when files are selected
                  if (_showApiWidgets && _selectedFiles.isNotEmpty) ...[
                    ApiUploadSecurityWidget(
                      selectedFiles: _selectedFiles,
                      onValidationComplete: _onValidationComplete,
                      showSecurityStatus: true,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Enhanced Upload Widget - Show when files are selected
                  if (_showApiWidgets && _selectedFiles.isNotEmpty) ...[
                    ApiEnhancedUploadWidget(
                      selectedFiles: _selectedFiles,
                      categoryId: widget.categoryId,
                      onUploadComplete: _onUploadComplete,
                      allowRetry: true,
                      maxConcurrentUploads: 3,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Upload Progress - Only show when files are being processed
                  if (uploadProvider.uploadQueue.isNotEmpty) ...[
                    _buildImprovedProgress(uploadProvider),
                    const SizedBox(height: 24),
                  ],

                  // File List - Always show container for consistency
                  _buildConsistentFileList(uploadProvider),

                  // Add some bottom padding for better scroll experience
                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Handle file selection
  Future<void> _handleFilesSelected(List<XFile> files) async {
    if (files.isNotEmpty) {
      // Update selected files for API widgets
      setState(() {
        _selectedFiles = files;
        _showApiWidgets = true;
      });

      final uploadProvider = Provider.of<ConsolidatedUploadProvider>(
        context,
        listen: false,
      );

      try {
        // Ensure context is set before adding files
        uploadProvider.setContext(context);
        await uploadProvider.addFiles(files, categoryId: widget.categoryId);
      } catch (e) {
        if (mounted) {
          final errorMessage = e.toString();

          // Check if it's a duplicate file error
          if (errorMessage.contains('duplikasi terdeteksi')) {
            // Extract duplicate file names from error message
            final duplicateNames = _extractDuplicateNames(errorMessage);
            showDuplicateWarning(
              context,
              duplicateNames.map((name) => {'fileName': name}).toList(),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error uploading files: $e'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        }
      }
    }
  }

  // Handle validation completion from security widget
  void _onValidationComplete(List<Map<String, dynamic>> results) {
    setState(() {
      _validationResults = results;
    });
  }

  // Handle upload completion from enhanced upload widget
  void _onUploadComplete(List<UploadResult> results) {
    final successCount = results.where((r) => r.success).length;
    final failedCount = results.where((r) => !r.success).length;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$successCount files uploaded successfully${failedCount > 0 ? ', $failedCount failed' : ''}',
          ),
          backgroundColor: failedCount > 0
              ? AppColors.warning
              : AppColors.success,
        ),
      );

      // Clear selected files after upload
      setState(() {
        _selectedFiles = [];
        _validationResults = [];
        _showApiWidgets = false;
      });
    }
  }

  /// Extract duplicate file names from error message
  List<String> _extractDuplicateNames(String errorMessage) {
    try {
      // Extract names between "terdeteksi: " and "\n"
      final startIndex = errorMessage.indexOf('terdeteksi: ') + 12;
      final endIndex = errorMessage.indexOf('\n', startIndex);

      if (startIndex > 11 && endIndex > startIndex) {
        final namesString = errorMessage.substring(startIndex, endIndex);
        return namesString.split(', ').map((name) => name.trim()).toList();
      }
    } catch (e) {
      debugPrint('Error extracting duplicate names: $e');
    }

    return [];
  }

  // Retry failed upload
  void _retryUpload(String fileId) {
    final uploadProvider = Provider.of<ConsolidatedUploadProvider>(
      context,
      listen: false,
    );
    uploadProvider.retryFailed();
  }

  // Improved progress widget with better visual feedback
  Widget _buildImprovedProgress(ConsolidatedUploadProvider uploadProvider) {
    final totalFiles = uploadProvider.totalFiles;
    final completedFiles = uploadProvider.completedFiles;
    final failedFiles = uploadProvider.failedFiles;
    final uploadingFiles = uploadProvider.uploadQueue
        .where((file) => file.status == UploadStatus.uploading)
        .length;
    final progress = totalFiles > 0 ? (completedFiles / totalFiles) : 0.0;

    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upload Progress',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '$completedFiles/$totalFiles',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              failedFiles > 0 ? AppColors.error : AppColors.primary,
            ),
            minHeight: 8,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (uploadingFiles > 0) ...[
                Icon(Icons.cloud_upload, size: 16, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  '$uploadingFiles uploading',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              if (completedFiles > 0) ...[
                Icon(Icons.check_circle, size: 16, color: AppColors.success),
                const SizedBox(width: 4),
                Text(
                  '$completedFiles completed',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              if (failedFiles > 0) ...[
                Icon(Icons.error, size: 16, color: AppColors.error),
                const SizedBox(width: 4),
                Text(
                  '$failedFiles failed',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // Show file filter dialog
  void _showFileFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => FileFilterWidget(
        onFilterApplied: () {
          setState(() {
            // Trigger UI refresh to apply filters
          });
        },
      ),
    );
  }

  // Apply file type filter to upload queue
  List<UploadFileModel> _applyFileTypeFilter(List<UploadFileModel> files) {
    if (_selectedFileTypeFilter == 'all') return files;

    return files.where((file) {
      final fileExtension = file.fileName.split('.').last.toLowerCase();
      switch (_selectedFileTypeFilter) {
        case 'pdf':
          return fileExtension == 'pdf';
        case 'doc':
          return ['doc', 'docx'].contains(fileExtension);
        case 'xls':
          return ['xls', 'xlsx'].contains(fileExtension);
        case 'ppt':
          return ['ppt', 'pptx'].contains(fileExtension);
        case 'image':
          return ['jpg', 'jpeg', 'png', 'gif'].contains(fileExtension);
        default:
          return true;
      }
    }).toList();
  }

  // Consistent file list that always shows container
  Widget _buildConsistentFileList(ConsolidatedUploadProvider uploadProvider) {
    final allFiles = uploadProvider.uploadQueue;
    final files = _applyFileTypeFilter(allFiles);

    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Files',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  if (allFiles.isNotEmpty) ...[
                    Text(
                      files.length != allFiles.length
                          ? '${files.length}/${allFiles.length}'
                          : '${files.length}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _showFileFilter,
                      icon: const Icon(
                        Icons.filter_list,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                      tooltip: 'Filter Files',
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (files.isEmpty)
            _buildEmptyFileState()
          else
            ...files.map((file) => _buildConsistentFileItem(file)),
        ],
      ),
    );
  }

  // Empty state for file list
  Widget _buildEmptyFileState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            size: 48,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No files selected',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the upload zone above to select files',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Consistent file item with improved styling
  Widget _buildConsistentFileItem(UploadFileModel file) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (file.status) {
      case UploadStatus.pending:
        statusColor = AppColors.warning;
        statusIcon = Icons.schedule;
        statusText = 'Pending';
        break;
      case UploadStatus.uploading:
        statusColor = AppColors.primary;
        statusIcon = Icons.cloud_upload;
        statusText = 'Uploading ${file.progress.round()}%';
        break;
      case UploadStatus.completed:
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle;
        statusText = 'Completed';
        break;
      case UploadStatus.failed:
        statusColor = AppColors.error;
        statusIcon = Icons.error;
        statusText = file.errorMessage ?? 'Failed';
        break;
      default:
        statusColor = AppColors.textSecondary;
        statusIcon = Icons.help;
        statusText = 'Unknown';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(statusIcon, color: statusColor, size: 20),
          ),
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
                const SizedBox(height: 4),
                Text(
                  statusText,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (file.status == UploadStatus.uploading)
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                value: file.progress / 100,
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
            ),
          if (file.status == UploadStatus.failed)
            IconButton(
              onPressed: () => _retryUpload(file.id),
              icon: const Icon(Icons.refresh, size: 20),
              color: AppColors.primary,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
        ],
      ),
    );
  }
}
