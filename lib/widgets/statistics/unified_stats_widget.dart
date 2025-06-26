import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../services/optimized_statistics_service.dart';
import '../../services/statistics_notification_service.dart';
import '../../providers/document_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/user_provider.dart';

/// Unified statistics widget that consolidates all stat displays
/// Supports dashboard stats, upload stats, and custom configurations
/// Optimized for large datasets with progressive loading and caching
class UnifiedStatsWidget extends StatefulWidget {
  final List<StatConfig> stats;
  final StatsLayout layout;
  final bool showLoadingAnimation;
  final VoidCallback? onRefresh;
  final String? title;
  final bool showTitle;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool enablePullToRefresh;
  final Duration animationDuration;

  const UnifiedStatsWidget({
    super.key,
    required this.stats,
    this.layout = StatsLayout.row,
    this.showLoadingAnimation = true,
    this.onRefresh,
    this.title,
    this.showTitle = false,
    this.padding,
    this.margin,
    this.enablePullToRefresh = false,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  /// Factory constructor for dashboard stats
  factory UnifiedStatsWidget.dashboard({
    Key? key,
    VoidCallback? onRefresh,
    bool enablePullToRefresh = false,
  }) {
    return UnifiedStatsWidget(
      key: key,
      stats: _getDashboardStats(),
      layout: StatsLayout.row,
      title: 'Dashboard Statistics',
      showTitle: false,
      onRefresh: onRefresh,
      enablePullToRefresh: enablePullToRefresh,
    );
  }

  /// Factory constructor for upload stats
  factory UnifiedStatsWidget.upload({
    Key? key,
    required int totalFiles,
    required double averageProgress,
    required int completedFiles,
    required int failedFiles,
    VoidCallback? onRefresh,
  }) {
    return UnifiedStatsWidget(
      key: key,
      stats: _getUploadStats(
        totalFiles,
        averageProgress,
        completedFiles,
        failedFiles,
      ),
      layout: StatsLayout.grid,
      title: 'Upload Statistics',
      showTitle: true,
      onRefresh: onRefresh,
    );
  }

  /// Factory constructor for custom stats
  factory UnifiedStatsWidget.custom({
    Key? key,
    required List<StatConfig> stats,
    StatsLayout layout = StatsLayout.row,
    String? title,
    bool showTitle = false,
    VoidCallback? onRefresh,
  }) {
    return UnifiedStatsWidget(
      key: key,
      stats: stats,
      layout: layout,
      title: title,
      showTitle: showTitle,
      onRefresh: onRefresh,
    );
  }

  @override
  State<UnifiedStatsWidget> createState() => _UnifiedStatsWidgetState();

  /// Get dashboard statistics configuration
  static List<StatConfig> _getDashboardStats() {
    return [
      StatConfig(
        key: 'totalFiles',
        title: 'Total',
        formatter: StatConfig.formatLargeNumber,
        icon: Icons.description,
        color: AppColors.primary,
      ),
      StatConfig(
        key: 'recentFiles',
        title: 'Recent',
        formatter: StatConfig.formatLargeNumber,
        icon: Icons.access_time,
        color: AppColors.success,
      ),
      StatConfig(
        key: 'activeUsers',
        title: 'Users',
        formatter: StatConfig.formatLargeNumber,
        icon: Icons.people,
        color: AppColors.warning,
      ),
      StatConfig(
        key: 'totalCategories',
        title: 'Categories',
        formatter: StatConfig.formatLargeNumber,
        icon: Icons.folder,
        color: AppColors.info,
      ),
    ];
  }

  /// Get upload statistics configuration
  static List<StatConfig> _getUploadStats(
    int totalFiles,
    double averageProgress,
    int completedFiles,
    int failedFiles,
  ) {
    return [
      StatConfig(
        key: 'totalFiles',
        title: 'Total Files',
        formatter: (value) => totalFiles.toString(),
        icon: Icons.description_outlined,
        color: AppColors.primary,
      ),
      StatConfig(
        key: 'averageProgress',
        title: 'Avg Progress',
        formatter: (value) => '${averageProgress.round()}%',
        icon: Icons.trending_up,
        color: AppColors.info,
      ),
      StatConfig(
        key: 'completedFiles',
        title: 'Completed',
        formatter: (value) => completedFiles.toString(),
        icon: Icons.check_circle_outline,
        color: AppColors.success,
      ),
      StatConfig(
        key: 'failedFiles',
        title: 'Failed',
        formatter: (value) => failedFiles.toString(),
        icon: Icons.error_outline,
        color: AppColors.error,
      ),
    ];
  }
}

/// Layout options for statistics display
enum StatsLayout {
  row, // Single row (1x4)
  column, // Single column (4x1)
  grid, // Grid layout (2x2)
  wrap, // Wrap layout (responsive)
}

class _UnifiedStatsWidgetState extends State<UnifiedStatsWidget>
    with TickerProviderStateMixin {
  final OptimizedStatisticsService _statsService =
      OptimizedStatisticsService.instance;
  final StatisticsNotificationService _notificationService =
      StatisticsNotificationService.instance;

  // Animation controllers
  late AnimationController _loadingAnimationController;
  late AnimationController _refreshAnimationController;
  late Animation<double> _loadingAnimation;
  late Animation<double> _refreshAnimation;

  // State management
  Map<String, dynamic> _statsData = {};
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  // Stream subscriptions for real-time updates
  StreamSubscription? _statisticsSubscription;
  StreamSubscription? _fileCountSubscription;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupRealTimeListeners();
    _loadStatistics();
  }

  void _initializeAnimations() {
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _refreshAnimationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _loadingAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _loadingAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _refreshAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _refreshAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    // Start loading animation
    _loadingAnimationController.repeat(reverse: true);
  }

  Future<void> _loadStatistics() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
    });

    try {
      // Try to get statistics from service
      final stats = await _statsService.getAggregatedStatistics();

      if (mounted) {
        setState(() {
          _statsData = stats;
          _isLoading = false;
        });

        // Stop loading animation
        _loadingAnimationController.stop();
        _loadingAnimationController.reset();

        // Trigger refresh animation
        _refreshAnimationController.forward().then((_) {
          _refreshAnimationController.reverse();
        });
      }
    } catch (e) {
      debugPrint('❌ Statistics service failed, trying provider fallback: $e');

      // Fallback to provider data
      try {
        final fallbackStats = await _getStatsFromProviders();

        if (mounted) {
          setState(() {
            _statsData = fallbackStats;
            _isLoading = false;
            _hasError = false; // Clear error since fallback worked
          });

          // Stop loading animation
          _loadingAnimationController.stop();
          _loadingAnimationController.reset();

          // Trigger refresh animation
          _refreshAnimationController.forward().then((_) {
            _refreshAnimationController.reverse();
          });
        }
      } catch (fallbackError) {
        debugPrint('❌ Provider fallback also failed: $fallbackError');

        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasError = true;
            _errorMessage = 'Unable to load statistics: ${e.toString()}';
          });

          _loadingAnimationController.stop();
          _loadingAnimationController.reset();
        }
      }
    }
  }

  /// Get statistics from local providers as fallback
  Future<Map<String, dynamic>> _getStatsFromProviders() async {
    if (!mounted) return {};

    final docProvider = Provider.of<DocumentProvider>(context, listen: false);
    final catProvider = Provider.of<CategoryProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Calculate recent files (last 7 days)
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    final recentFiles = docProvider.documents.where((doc) {
      return doc.uploadedAt.isAfter(sevenDaysAgo);
    }).length;

    return {
      'totalFiles': docProvider.documents.length,
      'activeUsers': userProvider.users.length,
      'totalCategories': catProvider.categories.length,
      'recentFiles': recentFiles,
      'fileTypeStats': <String, int>{},
      'totalStorageSize': 0,
      'lastCalculated': DateTime.now().toIso8601String(),
      'calculationDurationMs': 0,
    };
  }

  Future<void> _handleRefresh() async {
    if (widget.onRefresh != null) {
      widget.onRefresh!();
    }

    // Invalidate cache and reload
    await _statsService.invalidateCache(reason: 'Manual refresh');
    await _loadStatistics();
  }

  /// Setup real-time listeners for statistics updates
  void _setupRealTimeListeners() {
    // Listen to general statistics updates
    _statisticsSubscription = _notificationService.statisticsUpdates.listen((
      event,
    ) {
      debugPrint('📊 Statistics update received: ${event.type}');
      _loadStatistics();
    });

    // Listen to file count updates
    _fileCountSubscription = _notificationService.fileCountUpdates.listen((
      event,
    ) {
      debugPrint('📊 File count update received: ${event.type}');
      _loadStatistics();
    });
  }

  @override
  void dispose() {
    _statisticsSubscription?.cancel();
    _fileCountSubscription?.cancel();
    _loadingAnimationController.dispose();
    _refreshAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _buildStatsContent();

    // Add pull-to-refresh if enabled
    if (widget.enablePullToRefresh) {
      content = RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppColors.primary,
        child: content,
      );
    }

    // Add container with styling
    return Container(
      margin: widget.margin ?? _getDefaultMargin(),
      padding: widget.padding ?? _getDefaultPadding(),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showTitle && widget.title != null) ...[
            _buildTitle(),
            const SizedBox(height: 16),
          ],
          content,
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Icon(Icons.analytics_outlined, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          widget.title!,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsContent() {
    if (_isLoading && _statsData.isEmpty) {
      return _buildLoadingState();
    }

    if (_hasError && _statsData.isEmpty) {
      return _buildErrorState();
    }

    return AnimatedBuilder(
      animation: _refreshAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _refreshAnimation.value,
          child: _buildStatsLayout(),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return AnimatedBuilder(
      animation: _loadingAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _loadingAnimation.value,
          child: _buildStatsLayout(isLoading: true),
        );
      },
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 32),
          const SizedBox(height: 8),
          Text(
            'Failed to load statistics',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 4),
            Text(
              _errorMessage!,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _loadStatistics,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsLayout({bool isLoading = false}) {
    switch (widget.layout) {
      case StatsLayout.row:
        return _buildRowLayout(isLoading: isLoading);
      case StatsLayout.column:
        return _buildColumnLayout(isLoading: isLoading);
      case StatsLayout.grid:
        return _buildGridLayout(isLoading: isLoading);
      case StatsLayout.wrap:
        return _buildWrapLayout(isLoading: isLoading);
    }
  }

  Widget _buildRowLayout({bool isLoading = false}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final spacing = screenWidth < 400 ? 8.0 : 12.0;

    return Row(
      children: widget.stats.asMap().entries.map((entry) {
        final index = entry.key;
        final stat = entry.value;
        final isLast = index == widget.stats.length - 1;

        return Expanded(
          child: Row(
            children: [
              Expanded(child: _buildStatCard(stat, isLoading: isLoading)),
              if (!isLast) SizedBox(width: spacing),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildColumnLayout({bool isLoading = false}) {
    return Column(
      children: widget.stats.asMap().entries.map((entry) {
        final index = entry.key;
        final stat = entry.value;
        final isLast = index == widget.stats.length - 1;

        return Column(
          children: [
            _buildStatCard(stat, isLoading: isLoading),
            if (!isLast) const SizedBox(height: 12),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildGridLayout({bool isLoading = false}) {
    final stats = widget.stats;
    final rows = <Widget>[];

    for (int i = 0; i < stats.length; i += 2) {
      final leftStat = stats[i];
      final rightStat = i + 1 < stats.length ? stats[i + 1] : null;

      rows.add(
        Row(
          children: [
            Expanded(child: _buildStatCard(leftStat, isLoading: isLoading)),
            const SizedBox(width: 12),
            Expanded(
              child: rightStat != null
                  ? _buildStatCard(rightStat, isLoading: isLoading)
                  : const SizedBox(),
            ),
          ],
        ),
      );

      if (i + 2 < stats.length) {
        rows.add(const SizedBox(height: 12));
      }
    }

    return Column(children: rows);
  }

  Widget _buildWrapLayout({bool isLoading = false}) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: widget.stats.map((stat) {
        return SizedBox(
          width:
              (MediaQuery.of(context).size.width - 48) /
              2, // 2 columns with spacing
          child: _buildStatCard(stat, isLoading: isLoading),
        );
      }).toList(),
    );
  }

  Widget _buildStatCard(StatConfig stat, {bool isLoading = false}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final isMediumScreen = screenWidth < 600;

    // Responsive sizing
    final padding = EdgeInsets.all(
      isSmallScreen ? 8.0 : (isMediumScreen ? 10.0 : 12.0),
    );
    final borderRadius = isSmallScreen ? 8.0 : 12.0;
    final spacing = isSmallScreen ? 4.0 : 8.0;
    final valueFontSize = isSmallScreen ? 14.0 : (isMediumScreen ? 16.0 : 18.0);
    final titleFontSize = isSmallScreen ? 9.0 : (isMediumScreen ? 10.0 : 11.0);
    final iconSize = isSmallScreen ? 16.0 : (isMediumScreen ? 18.0 : 20.0);

    // Get value from stats data
    final value = isLoading ? '...' : _getStatValue(stat);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: stat.color.withValues(alpha: 0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(spacing),
            decoration: BoxDecoration(
              color: stat.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(borderRadius / 1.5),
            ),
            child: Icon(stat.icon, color: stat.color, size: iconSize),
          ),
          SizedBox(height: spacing),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: valueFontSize,
              fontWeight: FontWeight.w700,
              color: isLoading
                  ? AppColors.textSecondary
                  : AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing / 2),
          Text(
            stat.title,
            style: GoogleFonts.poppins(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (stat.subtitle != null) ...[
            SizedBox(height: spacing / 4),
            Text(
              stat.subtitle!,
              style: GoogleFonts.poppins(
                fontSize: titleFontSize - 1,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  String _getStatValue(StatConfig stat) {
    final rawValue = _statsData[stat.key];
    return stat.formatter(rawValue);
  }

  EdgeInsets _getDefaultMargin() {
    final screenWidth = MediaQuery.of(context).size.width;
    return EdgeInsets.symmetric(
      horizontal: screenWidth < 400 ? 8.0 : 16.0,
      vertical: 8.0,
    );
  }

  EdgeInsets _getDefaultPadding() {
    return const EdgeInsets.all(16);
  }
}
