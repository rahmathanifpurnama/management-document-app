import 'dart:collection';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_selector/file_selector.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/cloud_functions_service.dart';

/// Enhanced Upload Widget that integrates with Firebase Cloud Functions APIs
class ApiEnhancedUploadWidget extends StatefulWidget {
  final List<XFile> selectedFiles;
  final String? categoryId;
  final Function(List<UploadResult>)? onUploadComplete;
  final Function(String)? onUploadProgress;
  final bool allowRetry;
  final int maxConcurrentUploads;

  const ApiEnhancedUploadWidget({
    super.key,
    required this.selectedFiles,
    this.categoryId,
    this.onUploadComplete,
    this.onUploadProgress,
    this.allowRetry = true,
    this.maxConcurrentUploads = 3,
  });

  @override
  State<ApiEnhancedUploadWidget> createState() =>
      _ApiEnhancedUploadWidgetState();
}

class _ApiEnhancedUploadWidgetState extends State<ApiEnhancedUploadWidget> {
  final CloudFunctionsService _cloudFunctions = CloudFunctionsService.instance;

  List<UploadItem> _uploadItems = [];
  bool _isUploading = false;
  int _completedUploads = 0;
  int _failedUploads = 0;

  @override
  void initState() {
    super.initState();
    _initializeUploadItems();
  }

  @override
  void didUpdateWidget(ApiEnhancedUploadWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedFiles != oldWidget.selectedFiles) {
      _initializeUploadItems();
    }
  }

  void _initializeUploadItems() {
    setState(() {
      _uploadItems = widget.selectedFiles
          .map(
            (file) => UploadItem(
              file: file,
              status: UploadItemStatus.pending,
              progress: 0.0,
            ),
          )
          .toList();
      _completedUploads = 0;
      _failedUploads = 0;
    });
  }

  Future<void> startUpload() async {
    if (_isUploading) return;

    setState(() {
      _isUploading = true;
      _completedUploads = 0;
      _failedUploads = 0;
    });

    // Reset all items to pending
    for (final item in _uploadItems) {
      item.status = UploadItemStatus.pending;
      item.progress = 0.0;
      item.error = null;
    }

    // Process uploads with concurrency control
    await _processUploadsWithConcurrency();

    setState(() {
      _isUploading = false;
    });

    // Notify completion
    if (widget.onUploadComplete != null) {
      final results = _uploadItems
          .map(
            (item) => UploadResult(
              fileName: item.file.name,
              success: item.status == UploadItemStatus.completed,
              error: item.error,
              documentId: item.documentId,
            ),
          )
          .toList();

      widget.onUploadComplete!(results);
    }
  }

  Future<void> _processUploadsWithConcurrency() async {
    final semaphore = Semaphore(widget.maxConcurrentUploads);
    final futures = _uploadItems.map(
      (item) => semaphore.acquire().then(
        (_) => _uploadSingleFile(item).whenComplete(() => semaphore.release()),
      ),
    );

    await Future.wait(futures);
  }

  Future<void> _uploadSingleFile(UploadItem item) async {
    try {
      // Update status to uploading
      setState(() {
        item.status = UploadItemStatus.uploading;
        item.progress = 0.1;
      });

      // Step 1: Validate file
      await _validateFile(item);

      // Step 2: Check for duplicates
      await _checkDuplicates(item);

      // Step 3: Process upload
      await _processUpload(item);

      // Step 4: Generate thumbnail if needed
      if (item.file.mimeType?.startsWith('image/') == true) {
        await _generateThumbnail(item);
      }

      // Mark as completed
      setState(() {
        item.status = UploadItemStatus.completed;
        item.progress = 1.0;
        _completedUploads++;
      });
    } catch (e) {
      setState(() {
        item.status = UploadItemStatus.failed;
        item.error = e.toString();
        _failedUploads++;
      });
    }
  }

  Future<void> _validateFile(UploadItem item) async {
    setState(() {
      item.progress = 0.2;
    });

    final fileSize = await item.file.length();
    final validation = await _cloudFunctions.validateFile(
      fileName: item.file.name,
      fileSize: fileSize,
      contentType: item.file.mimeType ?? 'application/octet-stream',
    );

    if (!(validation['isValid'] ?? false)) {
      throw Exception(validation['error'] ?? 'File validation failed');
    }
  }

  Future<void> _checkDuplicates(UploadItem item) async {
    setState(() {
      item.progress = 0.4;
    });

    final fileSize = await item.file.length();
    final duplicateCheck = await _cloudFunctions.checkDuplicateFile(
      fileName: item.file.name,
      fileSize: fileSize,
      contentType: item.file.mimeType ?? 'application/octet-stream',
    );

    if (duplicateCheck['isDuplicate'] == true) {
      throw Exception('File already exists: ${item.file.name}');
    }
  }

  Future<void> _processUpload(UploadItem item) async {
    setState(() {
      item.progress = 0.6;
    });

    // For this example, we'll simulate the upload process
    // In a real implementation, you would upload the file to Firebase Storage first
    // then call the processFileUpload API

    final result = await _cloudFunctions.processFileUpload(
      filePath:
          'documents/temp/${item.file.name}', // This would be the actual uploaded path
      fileName: item.file.name,
      contentType: item.file.mimeType ?? 'application/octet-stream',
      categoryId: widget.categoryId,
    );

    if (result['success'] == true) {
      item.documentId = result['documentId'];
    } else {
      throw Exception(result['message'] ?? 'Upload processing failed');
    }

    setState(() {
      item.progress = 0.8;
    });
  }

  Future<void> _generateThumbnail(UploadItem item) async {
    try {
      setState(() {
        item.progress = 0.9;
      });

      await _cloudFunctions.generateThumbnail(
        filePath: 'documents/temp/${item.file.name}',
      );
    } catch (e) {
      // Thumbnail generation is optional, don't fail the upload
      debugPrint('Thumbnail generation failed: $e');
    }
  }

  Future<void> retryFailedUploads() async {
    final failedItems = _uploadItems
        .where((item) => item.status == UploadItemStatus.failed)
        .toList();

    if (failedItems.isEmpty) return;

    setState(() {
      _isUploading = true;
      _failedUploads = 0;
    });

    for (final item in failedItems) {
      await _uploadSingleFile(item);
    }

    setState(() {
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadItems.isEmpty) {
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
          _buildOverallProgress(),
          const SizedBox(height: 16),
          _buildUploadControls(),
          const SizedBox(height: 16),
          ..._uploadItems.map((item) => _buildUploadItem(item)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.cloud_upload, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          'Enhanced Upload',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        Text(
          '${_completedUploads + _failedUploads}/${_uploadItems.length}',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildOverallProgress() {
    final totalProgress = _uploadItems.isEmpty
        ? 0.0
        : _uploadItems.map((item) => item.progress).reduce((a, b) => a + b) /
              _uploadItems.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overall Progress',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: totalProgress,
          backgroundColor: AppColors.lightGray,
          valueColor: AlwaysStoppedAnimation<Color>(
            _failedUploads > 0 ? AppColors.error : AppColors.primary,
          ),
          minHeight: 8,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (_completedUploads > 0) ...[
              Icon(Icons.check_circle, size: 16, color: AppColors.success),
              const SizedBox(width: 4),
              Text(
                '$_completedUploads completed',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 16),
            ],
            if (_failedUploads > 0) ...[
              Icon(Icons.error, size: 16, color: AppColors.error),
              const SizedBox(width: 4),
              Text(
                '$_failedUploads failed',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.error,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildUploadControls() {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: _isUploading ? null : startUpload,
          icon: _isUploading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.upload, size: 16),
          label: Text(
            _isUploading ? 'Uploading...' : 'Start Upload',
            style: GoogleFonts.poppins(),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        if (widget.allowRetry && _failedUploads > 0 && !_isUploading)
          TextButton.icon(
            onPressed: retryFailedUploads,
            icon: const Icon(Icons.refresh, size: 16),
            label: Text('Retry Failed', style: GoogleFonts.poppins()),
            style: TextButton.styleFrom(foregroundColor: AppColors.warning),
          ),
      ],
    );
  }

  Widget _buildUploadItem(UploadItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getStatusColor(item.status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getStatusColor(item.status), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getStatusIcon(item.status),
                color: _getStatusColor(item.status),
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.file.name,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${(item.progress * 100).toInt()}%',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: item.progress,
            backgroundColor: AppColors.lightGray,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getStatusColor(item.status),
            ),
            minHeight: 4,
          ),
          if (item.error != null) ...[
            const SizedBox(height: 8),
            Text(
              item.error!,
              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.error),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(UploadItemStatus status) {
    switch (status) {
      case UploadItemStatus.pending:
        return AppColors.textSecondary;
      case UploadItemStatus.uploading:
        return AppColors.primary;
      case UploadItemStatus.completed:
        return AppColors.success;
      case UploadItemStatus.failed:
        return AppColors.error;
    }
  }

  IconData _getStatusIcon(UploadItemStatus status) {
    switch (status) {
      case UploadItemStatus.pending:
        return Icons.schedule;
      case UploadItemStatus.uploading:
        return Icons.cloud_upload;
      case UploadItemStatus.completed:
        return Icons.check_circle;
      case UploadItemStatus.failed:
        return Icons.error;
    }
  }
}

// Helper classes
class UploadItem {
  final XFile file;
  UploadItemStatus status;
  double progress;
  String? error;
  String? documentId;

  UploadItem({
    required this.file,
    required this.status,
    required this.progress,
    this.error,
    this.documentId,
  });
}

enum UploadItemStatus { pending, uploading, completed, failed }

class UploadResult {
  final String fileName;
  final bool success;
  final String? error;
  final String? documentId;

  UploadResult({
    required this.fileName,
    required this.success,
    this.error,
    this.documentId,
  });
}

class Semaphore {
  final int maxCount;
  int _currentCount;
  final Queue<Completer<void>> _waitQueue = Queue<Completer<void>>();

  Semaphore(this.maxCount) : _currentCount = maxCount;

  Future<void> acquire() async {
    if (_currentCount > 0) {
      _currentCount--;
      return;
    }

    final completer = Completer<void>();
    _waitQueue.add(completer);
    return completer.future;
  }

  void release() {
    if (_waitQueue.isNotEmpty) {
      final completer = _waitQueue.removeFirst();
      completer.complete();
    } else {
      _currentCount++;
    }
  }
}
