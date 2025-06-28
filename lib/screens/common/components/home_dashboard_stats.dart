part of '../home_screen.dart';

/// ENHANCED: Stateful widget for displaying dashboard statistics with real-time updates
/// Uses composition pattern with individual stat cards
/// Now includes responsive design, prevents unnecessary rebuilds during search/filter,
/// and automatically updates when files are deleted
///
/// ROOT CAUSE FIX: Removed DocumentProvider dependency to prevent statistics
/// from showing loading state when search/filter operations are performed
///
/// FEATURES:
/// - Real-time statistics updates via StatisticsNotificationService
/// - Direct Firebase queries for accurate data
/// - Automatic cache invalidation on file operations
/// - Clean UI without animation effects
class HomeDashboardStats extends StatefulWidget {
  const HomeDashboardStats({super.key});

  /// Factory constructor for admin-only stats
  factory HomeDashboardStats.forAdmin() {
    return const HomeDashboardStats();
  }

  @override
  State<HomeDashboardStats> createState() => _HomeDashboardStatsState();
}

class _HomeDashboardStatsState extends State<HomeDashboardStats> {
  // FIXED: Use unified statistics state management
  Map<String, dynamic>? _currentStats;
  bool _isLoading = false;

  // Key to force FutureBuilder refresh
  int _refreshKey = 0;

  // REMOVED: Animation controllers for cleaner UI without pop-out effects

  // Statistics notification service for real-time updates
  final StatisticsNotificationService _statisticsService =
      StatisticsNotificationService.instance;
  StreamSubscription<StatisticsUpdateEvent>? _statisticsSubscription;

  // FIXED: Direct statistics service for real-time queries
  final OptimizedStatisticsService _directStatsService =
      OptimizedStatisticsService.instance;

  @override
  void initState() {
    super.initState();
    _setupStatisticsListener();
    _loadStatistics();
  }

  /// Setup listener for real-time statistics updates
  void _setupStatisticsListener() {
    _statisticsSubscription = _statisticsService.statisticsUpdates.listen(
      (event) {
        debugPrint(
          '📊 HomeDashboardStats: Received statistics update - ${event.type}',
        );

        // FIXED: Reload statistics without animation for cleaner UI
        _invalidateCacheAndReload();
      },
      onError: (error) {
        debugPrint('❌ HomeDashboardStats: Statistics update error - $error');
      },
    );
  }

  @override
  void dispose() {
    _statisticsSubscription?.cancel();
    super.dispose();
  }

  /// REMOVED: Animation triggers for cleaner UI without pop-out effects

  /// Invalidate cache and reload statistics
  void _invalidateCacheAndReload() {
    if (mounted) {
      setState(() {
        _currentStats = null;
        _refreshKey++; // Force FutureBuilder to rebuild
      });

      // FIXED: Force refresh direct statistics service
      _directStatsService.invalidateCache(
        reason: 'Manual refresh from dashboard',
      );
    }
  }

  /// Load statistics using direct service
  Future<Map<String, dynamic>> _loadStatistics() async {
    if (_isLoading) return _currentStats ?? {};

    setState(() {
      _isLoading = true;
    });

    try {
      final stats = await _directStatsService.getAggregatedStatistics(
        forceRefresh: true,
      );
      if (mounted) {
        setState(() {
          _currentStats = stats;
          _isLoading = false;
        });
      }
      return stats;
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      debugPrint('❌ Failed to load statistics: $e');
      return _currentStats ?? {};
    }
  }

  @override
  Widget build(BuildContext context) {
    // FIXED: Use direct real-time statistics queries with proper refresh mechanism
    return FutureBuilder<Map<String, dynamic>>(
      key: ValueKey(_refreshKey), // Force rebuild when refresh key changes
      future: _directStatsService.getAggregatedStatistics(forceRefresh: false),
      builder: (context, snapshot) {
        // Show loading only on initial load
        if (snapshot.connectionState == ConnectionState.waiting &&
            _currentStats == null) {
          return _buildLoadingStats(context);
        }

        // Use direct statistics data or fallback to current stats
        final stats = snapshot.data ?? _currentStats ?? {};

        // FIXED: Use real-time statistics from direct queries
        final totalDocuments = stats['totalFiles'] ?? 0;
        final recentDocuments = stats['recentFiles'] ?? 0;
        final totalUsers = stats['activeUsers'] ?? 0; // Firebase Auth users
        final totalCategories =
            stats['totalCategories'] ?? 0; // Real-time categories

        // DEBUG: Gunakan nilai fixed untuk margin dan spacing
        // Ganti ResponsiveUtils dengan nilai yang lebih kecil
        final screenWidth = MediaQuery.of(context).size.width;
        final responsiveMargin = EdgeInsets.symmetric(
          horizontal: screenWidth < 400
              ? 8.0
              : 16.0, // Lebih kecil untuk layar kecil
          // Removed vertical padding for compact layout
        );
        final responsiveSpacing = screenWidth < 400
            ? 8.0
            : 12.0; // Spacing antar cards

        // Create stat cards data
        final statCards = [
          _StatCardData(
            title: 'Total',
            value: totalDocuments.toString(),
            icon: Icons.description,
            color: AppColors.primary,
          ),
          _StatCardData(
            title: 'Recent',
            value: recentDocuments.toString(),
            icon: Icons.access_time,
            color: AppColors.success,
          ),
          _StatCardData(
            title: 'Users',
            value: totalUsers.toString(),
            icon: Icons.people,
            color: AppColors.warning,
          ),
          _StatCardData(
            title: 'Categories',
            value: totalCategories.toString(),
            icon: Icons.folder,
            color: AppColors.info,
          ),
        ];

        return Container(
          margin: responsiveMargin,
          // PERUBAHAN: Selalu gunakan Row layout (1 baris)
          child: _buildRowLayout(context, statCards, responsiveSpacing),
        );
      },
    );
  }

  /// Build loading state for statistics cards
  Widget _buildLoadingStats(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveMargin = EdgeInsets.symmetric(
      horizontal: screenWidth < 400 ? 8.0 : 16.0,
      // Removed vertical padding for compact layout
    );
    final responsiveSpacing = screenWidth < 400 ? 8.0 : 12.0;

    // Create loading stat cards
    final loadingCards = [
      _StatCardData(
        title: 'Total',
        value: '...',
        icon: Icons.description,
        color: AppColors.primary,
      ),
      _StatCardData(
        title: 'Recent',
        value: '...',
        icon: Icons.access_time,
        color: AppColors.success,
      ),
      _StatCardData(
        title: 'Users',
        value: '...',
        icon: Icons.people,
        color: AppColors.warning,
      ),
      _StatCardData(
        title: 'Categories',
        value: '...',
        icon: Icons.folder,
        color: AppColors.info,
      ),
    ];

    return Container(
      margin: responsiveMargin,
      child: _buildRowLayout(context, loadingCards, responsiveSpacing),
    );
  }

  /// Build row layout for standard and larger screens (1x4)
  Widget _buildRowLayout(
    BuildContext context,
    List<_StatCardData> statCards,
    double spacing,
  ) {
    return Row(
      children: statCards.map((cardData) {
        final isLast = statCards.indexOf(cardData) == statCards.length - 1;
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: cardData.title,
                  value: cardData.value,
                  icon: cardData.icon,
                  color: cardData.color,
                ),
              ),
              if (!isLast) SizedBox(width: spacing),
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// Data class for stat card information
class _StatCardData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCardData({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}

/// Individual stat card component
/// Follows single responsibility principle
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Deteksi ukuran layar untuk menyesuaikan ukuran komponen
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final isMediumScreen = screenWidth < 600;

    // FIX: Gunakan nilai padding yang lebih kecil dan konsisten
    // Removed vertical padding components for compact layout
    final responsivePadding = EdgeInsets.symmetric(
      horizontal: isSmallScreen ? 8.0 : (isMediumScreen ? 10.0 : 12.0),
      vertical: isSmallScreen
          ? 4.0
          : (isMediumScreen ? 6.0 : 8.0), // Reduced vertical padding
    );
    final responsiveBorderRadius = isSmallScreen ? 8.0 : 12.0;
    final responsiveElevation = 2.0;
    final responsiveSpacing = isSmallScreen ? 4.0 : 8.0;

    // FIX: Sesuaikan ukuran font agar tidak terlalu besar
    final valueFontSize = isSmallScreen ? 14.0 : (isMediumScreen ? 16.0 : 18.0);
    final titleFontSize = isSmallScreen ? 9.0 : (isMediumScreen ? 10.0 : 11.0);
    final iconSize = isSmallScreen ? 16.0 : (isMediumScreen ? 18.0 : 20.0);

    return Container(
      padding: responsivePadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(responsiveBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: responsiveElevation * 2,
            offset: Offset(0, responsiveElevation / 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(responsiveSpacing),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(responsiveBorderRadius / 1.5),
            ),
            child: Icon(icon, color: color, size: iconSize),
          ),
          SizedBox(height: responsiveSpacing),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: valueFontSize,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: responsiveSpacing / 2),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
