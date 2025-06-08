import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/cloud_functions_service.dart';

/// Storage Quota Widget that integrates with Firebase Cloud Functions API
class ApiStorageQuotaWidget extends StatefulWidget {
  final bool showCleanupButton;
  final bool autoRefresh;
  final Duration refreshInterval;

  const ApiStorageQuotaWidget({
    super.key,
    this.showCleanupButton = true,
    this.autoRefresh = false,
    this.refreshInterval = const Duration(minutes: 5),
  });

  @override
  State<ApiStorageQuotaWidget> createState() => _ApiStorageQuotaWidgetState();
}

class _ApiStorageQuotaWidgetState extends State<ApiStorageQuotaWidget> {
  final CloudFunctionsService _cloudFunctions = CloudFunctionsService.instance;

  Map<String, dynamic>? _storageData;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStorageQuota();

    if (widget.autoRefresh) {
      _startAutoRefresh();
    }
  }

  void _startAutoRefresh() {
    Future.delayed(widget.refreshInterval, () {
      if (mounted) {
        _loadStorageQuota();
        _startAutoRefresh();
      }
    });
  }

  Future<void> _loadStorageQuota() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await _cloudFunctions.getStorageQuota();

      if (mounted) {
        setState(() {
          _storageData = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _cleanupOrphanedFiles() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _cloudFunctions.cleanupOrphanedFiles();

      // Refresh quota after cleanup
      await _loadStorageQuota();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Storage cleanup completed successfully',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cleanup failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return _buildErrorWidget();
    }

    if (_isLoading && _storageData == null) {
      return _buildLoadingWidget();
    }

    if (_storageData == null) {
      return const SizedBox.shrink();
    }

    return _buildStorageQuotaWidget();
  }

  Widget _buildErrorWidget() {
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
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 32),
          const SizedBox(height: 8),
          Text(
            'Failed to load storage quota',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _loadStorageQuota,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text('Retry', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
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
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading storage quota...',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageQuotaWidget() {
    final used = _storageData!['used'] as int? ?? 0;
    final limit = _storageData!['limit'] as int? ?? 0;
    final available = _storageData!['available'] as int? ?? 0;

    final usagePercentage = limit > 0 ? (used / limit) : 0.0;
    final isNearLimit = usagePercentage > 0.8;
    final isExceeded = usagePercentage >= 1.0;

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
          // Header
          Row(
            children: [
              Icon(
                isExceeded
                    ? Icons.error
                    : isNearLimit
                    ? Icons.warning
                    : Icons.storage,
                color: isExceeded
                    ? AppColors.error
                    : isNearLimit
                    ? AppColors.warning
                    : AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Storage Usage',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (widget.showCleanupButton) _buildCleanupButton(),
              IconButton(
                icon: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh, size: 18),
                onPressed: _isLoading ? null : _loadStorageQuota,
                tooltip: 'Refresh storage stats',
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress Bar
          LinearProgressIndicator(
            value: usagePercentage.clamp(0.0, 1.0),
            backgroundColor: AppColors.lightGray,
            valueColor: AlwaysStoppedAnimation<Color>(
              isExceeded
                  ? AppColors.error
                  : isNearLimit
                  ? AppColors.warning
                  : AppColors.primary,
            ),
            minHeight: 8,
          ),

          const SizedBox(height: 12),

          // Usage Text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_formatBytes(used)} used',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${(usagePercentage * 100).toStringAsFixed(1)}%',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isExceeded
                      ? AppColors.error
                      : isNearLimit
                      ? AppColors.warning
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Storage Details
          _buildStorageDetails(used, limit, available),

          // Warning Message
          if (isNearLimit || isExceeded) ...[
            const SizedBox(height: 12),
            _buildWarningMessage(isExceeded),
          ],
        ],
      ),
    );
  }

  Widget _buildCleanupButton() {
    return TextButton.icon(
      onPressed: _isLoading ? null : _cleanupOrphanedFiles,
      icon: const Icon(Icons.cleaning_services, size: 16),
      label: Text('Cleanup', style: GoogleFonts.poppins(fontSize: 12)),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    );
  }

  Widget _buildStorageDetails(int used, int limit, int available) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildDetailRow('Used', _formatBytes(used)),
          const SizedBox(height: 4),
          _buildDetailRow('Total', _formatBytes(limit)),
          if (available >= 0) ...[
            const SizedBox(height: 4),
            _buildDetailRow('Available', _formatBytes(available)),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildWarningMessage(bool isExceeded) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (isExceeded ? AppColors.error : AppColors.warning).withValues(
          alpha: 0.1,
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isExceeded ? AppColors.error : AppColors.warning,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isExceeded ? Icons.error : Icons.warning,
            color: isExceeded ? AppColors.error : AppColors.warning,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isExceeded
                  ? 'Storage limit exceeded! Please delete some files or contact administrator.'
                  : 'Storage is almost full. Consider cleaning up old files.',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: isExceeded ? AppColors.error : AppColors.warning,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
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
}
