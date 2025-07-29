import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/activity_model.dart';
import '../../services/export_service.dart';
import '../common/app_container.dart';

class ActivityListHeader extends StatefulWidget {
  final int activityCount;
  final VoidCallback? onRefresh;
  final VoidCallback? onExport;
  final List<BaseActivity>? activities;
  final bool isLoading;
  final bool showExportButton;
  final bool showRefreshButton;
  final String? title;
  final Widget? trailing;

  const ActivityListHeader({
    super.key,
    required this.activityCount,
    this.onRefresh,
    this.onExport,
    this.activities,
    this.isLoading = false,
    this.showExportButton = true,
    this.showRefreshButton = true,
    this.title,
    this.trailing,
  });

  @override
  State<ActivityListHeader> createState() => _ActivityListHeaderState();
}

class _ActivityListHeaderState extends State<ActivityListHeader> {
  final ExportService _exportService = ExportService();
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    return AppContainer.bordered(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildCountInfo(), _buildActions()],
      ),
    );
  }

  Widget _buildCountInfo() {
    return Expanded(
      child: Row(
        children: [
          Icon(Icons.list_alt, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title ?? _getCountText(),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (widget.title != null)
                  Text(
                    _getCountText(),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.trailing != null) ...[
          widget.trailing!,
          const SizedBox(width: 8),
        ],
        if (widget.showExportButton) ...[
          _buildExportButton(),
          const SizedBox(width: 8),
        ],
        if (widget.showRefreshButton) _buildRefreshButton(),
      ],
    );
  }

  Widget _buildExportButton() {
    return IconButton(
      onPressed: _isExporting || widget.isLoading ? null : _handleExport,
      icon: _isExporting
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            )
          : const Icon(Icons.file_download),
      tooltip: 'Export Activities',
      style: IconButton.styleFrom(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        foregroundColor: AppColors.primary,
        disabledBackgroundColor: AppColors.background,
        disabledForegroundColor: AppColors.textSecondary,
        padding: const EdgeInsets.all(8),
        minimumSize: const Size(36, 36),
      ),
    );
  }

  Widget _buildRefreshButton() {
    return IconButton(
      onPressed: widget.isLoading ? null : widget.onRefresh,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: widget.isLoading
            ? SizedBox(
                key: const ValueKey('loading'),
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            : const Icon(Icons.refresh, key: ValueKey('refresh')),
      ),
      tooltip: 'Refresh Activities',
      style: IconButton.styleFrom(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        foregroundColor: AppColors.primary,
        disabledBackgroundColor: AppColors.background,
        disabledForegroundColor: AppColors.textSecondary,
        padding: const EdgeInsets.all(8),
        minimumSize: const Size(36, 36),
      ),
    );
  }

  String _getCountText() {
    if (widget.isLoading) {
      return 'Loading activities...';
    }

    final count = widget.activityCount;
    if (count == 0) {
      return 'No activities found';
    } else if (count == 1) {
      return '1 activity';
    } else {
      return '$count activities';
    }
  }

  Future<void> _handleExport() async {
    if (widget.onExport != null) {
      widget.onExport!();
      return;
    }

    if (widget.activities == null || widget.activities!.isEmpty) {
      _showSnackBar('No activities to export');
      return;
    }

    setState(() => _isExporting = true);

    try {
      _showSnackBar('Exporting activities...');

      await _exportService.exportActivitiesToExcel(widget.activities!);

      _showSnackBar('Activities exported successfully');
    } catch (e) {
      debugPrint('Export failed: $e');
      _showSnackBar('Export failed: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

/// Extension for creating different header configurations
extension ActivityListHeaderExtensions on ActivityListHeader {
  /// Create a minimal header with just count and refresh
  static ActivityListHeader minimal({
    required int activityCount,
    VoidCallback? onRefresh,
    bool isLoading = false,
  }) {
    return ActivityListHeader(
      activityCount: activityCount,
      onRefresh: onRefresh,
      isLoading: isLoading,
      showExportButton: false,
      showRefreshButton: true,
    );
  }

  /// Create a full-featured header with all options
  static ActivityListHeader full({
    required int activityCount,
    VoidCallback? onRefresh,
    VoidCallback? onExport,
    List<ActivityModel>? activities,
    bool isLoading = false,
    String? title,
    Widget? trailing,
  }) {
    return ActivityListHeader(
      activityCount: activityCount,
      onRefresh: onRefresh,
      onExport: onExport,
      activities: activities,
      isLoading: isLoading,
      showExportButton: true,
      showRefreshButton: true,
      title: title,
      trailing: trailing,
    );
  }

  /// Create a header with custom actions
  static ActivityListHeader withActions({
    required int activityCount,
    VoidCallback? onRefresh,
    bool isLoading = false,
    String? title,
    required Widget trailing,
  }) {
    return ActivityListHeader(
      activityCount: activityCount,
      onRefresh: onRefresh,
      isLoading: isLoading,
      showExportButton: false,
      showRefreshButton: true,
      title: title,
      trailing: trailing,
    );
  }

  /// Create a read-only header (no actions)
  static ActivityListHeader readOnly({
    required int activityCount,
    String? title,
    bool isLoading = false,
  }) {
    return ActivityListHeader(
      activityCount: activityCount,
      isLoading: isLoading,
      showExportButton: false,
      showRefreshButton: false,
      title: title,
    );
  }
}
