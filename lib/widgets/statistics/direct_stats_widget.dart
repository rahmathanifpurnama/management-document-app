import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../services/direct_statistics_service.dart';

/// Direct Statistics Widget
/// Uses DirectStatisticsService for real-time data without caching
/// Designed for integration with main pull-to-refresh mechanism
class DirectStatsWidget extends StatefulWidget {
  final Function(VoidCallback)? onRefreshCallbackSet;
  final bool showLoadingAnimation;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const DirectStatsWidget({
    super.key,
    this.onRefreshCallbackSet,
    this.showLoadingAnimation = true,
    this.padding,
    this.margin,
  });

  @override
  State<DirectStatsWidget> createState() => _DirectStatsWidgetState();
}

class _DirectStatsWidgetState extends State<DirectStatsWidget> {
  final DirectStatisticsService _directStatsService =
      DirectStatisticsService.instance;

  Map<String, dynamic>? _statsData;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadStatistics();

    // Set up refresh callback for parent
    if (widget.onRefreshCallbackSet != null) {
      widget.onRefreshCallbackSet!(refreshStatistics);
    }
  }

  Future<void> _loadStatistics() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final stats = await _directStatsService.getAllStatistics();

      if (mounted) {
        setState(() {
          _statsData = stats;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  /// Public method to refresh statistics (called from parent)
  Future<void> refreshStatistics() async {
    await _loadStatistics();
  }

  /// Show user sync diagnostics dialog (debug mode only)
  Future<void> _showUserSyncDiagnostics() async {
    try {
      final diagnostics = await _directStatsService.getUserSyncDiagnostics();

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('User Sync Diagnostics'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Current Auth User: ${diagnostics['currentAuthUser']?['email'] ?? 'Unknown'}',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Firestore Users: ${diagnostics['firestoreUsers']?['totalCount'] ?? 0}',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sync Issue: ${diagnostics['syncStatus']?['potentialSyncIssue'] ?? false}',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Recommendations:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...((diagnostics['recommendations'] as List<dynamic>?) ?? [])
                      .map(
                        (rec) => Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text('• $rec'),
                        ),
                      ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint('Error showing user sync diagnostics: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          widget.margin ??
          const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 4.0,
          ), // Reduced vertical margin
      padding: widget.padding ?? const EdgeInsets.all(12.0), // Reduced padding
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // Minimal shadow
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dashboard Statistics',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              if (_isLoading && widget.showLoadingAnimation)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 12), // Reduced spacing
          // Statistics Content
          if (_errorMessage != null)
            _buildErrorState()
          else if (_statsData != null)
            _buildStatsContent()
          else if (_isLoading)
            _buildLoadingState()
          else
            _buildEmptyState(),
        ],
      ),
    );
  }

  Widget _buildStatsContent() {
    final categories = _statsData!['categories'] as Map<String, dynamic>;
    final users = _statsData!['users'] as Map<String, dynamic>;
    final files = _statsData!['files'] as Map<String, dynamic>;

    return Column(
      children: [
        // Statistics Grid
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Categories',
                '${categories['totalCategories'] ?? 0}',
                Icons.folder_outlined,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Users',
                '${users['totalUsers'] ?? 0}',
                Icons.people_outline,
                AppColors.secondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Files',
                '${files['totalFiles'] ?? 0}',
                Icons.description_outlined,
                AppColors.info,
              ),
            ),
          ],
        ),

        // Performance Info (Debug)
        if (_statsData!['performance'] != null) ...[
          const SizedBox(height: 8),
          Text(
            'Query time: ${_statsData!['performance']['queryDurationMs']}ms',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ],

        // User Sync Diagnostic Button (Debug mode only)
        if (kDebugMode) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _showUserSyncDiagnostics,
            icon: const Icon(Icons.bug_report, size: 16),
            label: const Text('User Sync Diagnostics'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              textStyle: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(8.0), // Reduced padding
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20), // Reduced icon size
          const SizedBox(height: 6), // Reduced spacing
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2), // Reduced spacing
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: 16),
            Text(
              'Failed to load statistics',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.error),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadStatistics,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Text('No statistics available'),
      ),
    );
  }
}
