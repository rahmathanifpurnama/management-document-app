part of '../home_screen.dart';

/// FIXED: Stateful widget for displaying dashboard statistics with caching
/// Uses composition pattern with individual stat cards
/// Now includes responsive design and prevents unnecessary rebuilds during search/filter
/// 
/// ROOT CAUSE FIX: Removed DocumentProvider dependency to prevent statistics
/// from showing loading state when search/filter operations are performed
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
  // Cache for storage statistics to prevent unnecessary Firebase calls
  Map<String, dynamic>? _cachedStorageStats;
  DateTime? _lastFetchTime;
  bool _isLoading = false;
  
  // Cache duration - 5 minutes to balance freshness and performance
  static const Duration _cacheDuration = Duration(minutes: 5);

  @override
  void initState() {
    super.initState();
    _loadStorageStatistics();
  }

  /// Load storage statistics with intelligent caching mechanism
  Future<void> _loadStorageStatistics() async {
    // Check if we have valid cached data
    if (_cachedStorageStats != null && 
        _lastFetchTime != null && 
        DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
      return; // Use cached data, no need to fetch
    }

    if (_isLoading) return; // Prevent multiple simultaneous calls

    setState(() {
      _isLoading = true;
    });

    try {
      final stats = await _getStorageStatistics();
      if (mounted) {
        setState(() {
          _cachedStorageStats = stats;
          _lastFetchTime = DateTime.now();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      debugPrint('❌ Failed to load storage statistics: $e');
    }
  }

  /// Get Firebase Storage statistics with error handling
  Future<Map<String, dynamic>> _getStorageStatistics() async {
    try {
      final storageService = FirebaseStorageDirectService.instance;
      return await storageService.getStorageStatistics();
    } catch (e) {
      debugPrint('❌ Failed to get storage statistics: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    // ARCHITECTURAL FIX: Only listen to UserProvider and CategoryProvider
    // Removed DocumentProvider dependency to prevent unnecessary rebuilds during search/filter
    return Consumer2<UserProvider, CategoryProvider>(
      builder: (context, userProvider, categoryProvider, child) {
        // Show loading only on initial load, not during search/filter operations
        if (_isLoading && _cachedStorageStats == null) {
          return _buildLoadingStats(context);
        }

        // Use cached storage statistics to prevent flickering
        final storageStats = _cachedStorageStats ?? {};
        final totalDocuments = storageStats['totalFiles'] ?? 0;
        final recentDocuments = storageStats['recentFiles'] ?? 0;
        final totalUsers = userProvider.users.length;
        final totalCategories = categoryProvider.categories.length;

        // DEBUG: Gunakan nilai fixed untuk margin dan spacing
        // Ganti ResponsiveUtils dengan nilai yang lebih kecil
        final screenWidth = MediaQuery.of(context).size.width;
        final responsiveMargin = EdgeInsets.symmetric(
          horizontal: screenWidth < 400
              ? 8.0
              : 16.0, // Lebih kecil untuk layar kecil
          vertical: 8.0,
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
      vertical: 8.0,
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
    final responsivePadding = EdgeInsets.all(
      isSmallScreen ? 8.0 : (isMediumScreen ? 10.0 : 12.0),
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
