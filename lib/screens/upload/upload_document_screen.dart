import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_selector/file_selector.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/upload_ui_constants.dart';

import '../../providers/consolidated_upload_provider.dart';
import '../../widgets/upload/duplicate_file_dialog.dart';

import '../../models/upload_file_model.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/upload/upload_zone_widget.dart';

import '../../services/ui_refresh_service.dart';
import '../../widgets/common/file_filter_widget.dart';

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

      // Provider is ready to use
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

    // Show notification when uploads are completed
    if (currentCompletedCount > _lastCompletedCount) {
      _lastCompletedCount = currentCompletedCount;
      _hasCompletedUploads = true;

      // Schedule notification to show after build completes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final failedCount = uploadProvider.failedFiles;
          _showFinalUploadNotification(currentCompletedCount, failedCount);
        }
      });

      // Trigger comprehensive UI refresh using service
      UIRefreshService.refreshAfterUpload(
        context,
        categoryId: widget.categoryId,
      );

      // Schedule delayed cleanup
      _scheduleDelayedQueueCleanup();

      debugPrint(
        '🔄 UI refreshed after upload completion ($currentCompletedCount files completed)',
      );
    }
  }

  // Show final upload notification with accurate counts
  void _showFinalUploadNotification(int successCount, int failedCount) {
    if (!mounted) return;

    try {
      final bool hasFailures = failedCount > 0;
      final String message = hasFailures
          ? '$successCount files uploaded successfully, $failedCount failed'
          : '$successCount file(s) uploaded successfully!';

      // Prevent showing "0 files uploaded" by checking counts
      if (successCount == 0 && failedCount == 0) {
        debugPrint(
          '⚠️ Skipping notification: No files to report (0 success, 0 failed)',
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                hasFailures ? Icons.warning : Icons.check_circle,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: hasFailures ? AppColors.warning : AppColors.success,
          duration: const Duration(seconds: 4),
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

      debugPrint(
        '✅ Final upload notification shown: $successCount success, $failedCount failed',
      );
    } catch (e) {
      debugPrint('❌ Error showing final upload notification: $e');
    }
  }

  // Trigger UI refresh when exiting upload screen
  void _triggerUIRefreshOnExit() {
    UIRefreshService.refreshOnNavigationExit(context);
  }

  // Schedule delayed queue cleanup after user sees final notification
  void _scheduleDelayedQueueCleanup() {
    if (!mounted) return;

    // Wait longer to ensure user sees the final notification
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        final uploadProvider = Provider.of<ConsolidatedUploadProvider>(
          context,
          listen: false,
        );

        // Clear completed files from queue to hide progress components
        if (uploadProvider.hasSuccessfulUploads) {
          uploadProvider.clearCompleted();
          debugPrint('🧹 Delayed queue cleanup completed');
        }
      }
    });
  }

  // Determine if upload progress should be shown
  bool _shouldShowUploadProgress(ConsolidatedUploadProvider uploadProvider) {
    // Use the provider's built-in logic for determining visibility
    return uploadProvider.shouldShowQueue;
  }

  // Build file upload information widget
  Widget _buildFileUploadInfo() {
    return Container(
      padding: UploadUIConstants.smallContainerPadding,
      decoration: UploadUIConstants.infoContainerDecoration,
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.info,
            size: UploadUIConstants.smallIconSize,
          ),
          SizedBox(width: UploadUIConstants.smallSpacing),
          Expanded(
            child: Text(
              'Files will be uploaded with their original names. Make sure your filenames are descriptive and unique.',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
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
                  // Upload Zone - Always visible for consistency
                  UploadZoneWidget(
                    onFilesSelected: (files) => _handleFilesSelected(files),
                    isEnabled: !uploadProvider.isUploading,
                    showValidationWarnings:
                        false, // Disable security warnings to prevent false positives
                  ),

                  // File upload info - Show helpful information about file upload
                  if (uploadProvider.uploadQueue.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildFileUploadInfo(),
                  ],

                  const SizedBox(height: 16),

                  // Upload Progress - Only show when files are actively being processed
                  if (_shouldShowUploadProgress(uploadProvider)) ...[
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
      final uploadProvider = Provider.of<ConsolidatedUploadProvider>(
        context,
        listen: false,
      );

      try {
        // Add files to upload queue
        await uploadProvider.addFiles(files, categoryId: widget.categoryId);
      } catch (e) {
        if (mounted) {
          final errorMessage = e.toString();

          // Check if it's a duplicate file error
          if (errorMessage.contains('Duplicate files detected')) {
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

  /// Extract duplicate file names from error message
  List<String> _extractDuplicateNames(String errorMessage) {
    try {
      // Extract names between "detected: " and "\n"
      final startIndex = errorMessage.indexOf('detected: ') + 10;
      final endIndex = errorMessage.indexOf('\n', startIndex);

      if (startIndex > 9 && endIndex > startIndex) {
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
    final uploadingFiles = uploadProvider.uploadingFiles;
    final progress = totalFiles > 0 ? (completedFiles / totalFiles) : 0.0;

    return Container(
      padding: UploadUIConstants.containerPadding,
      decoration: UploadUIConstants.defaultContainerDecoration,
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
          SizedBox(height: UploadUIConstants.smallSpacing),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              failedFiles > 0 ? AppColors.error : AppColors.primary,
            ),
            minHeight: UploadUIConstants.progressIndicatorHeight,
          ),
          SizedBox(height: UploadUIConstants.smallSpacing),
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

  // Apply file type filter to upload queue (simplified - no filtering for now)
  List<UploadFileModel> _applyFileTypeFilter(List<UploadFileModel> files) {
    return files; // Return all files without filtering
  }

  // Consistent file list that always shows container
  Widget _buildConsistentFileList(ConsolidatedUploadProvider uploadProvider) {
    final allFiles = uploadProvider.uploadQueue;
    final files = _applyFileTypeFilter(allFiles);

    return Container(
      padding: UploadUIConstants.containerPadding,
      decoration: UploadUIConstants.defaultContainerDecoration,
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
                value: file.progress,
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
