part of '../home_screen.dart';

/// Stateless widget for displaying dashboard statistics
/// Uses composition pattern with individual stat cards
/// Now includes responsive design for different mobile screen sizes
class HomeDashboardStats extends StatelessWidget {
  const HomeDashboardStats({super.key});

  /// Factory constructor for admin-only stats
  factory HomeDashboardStats.forAdmin() {
    return const HomeDashboardStats();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<DocumentProvider, UserProvider, CategoryProvider>(
      builder: (context, documentProvider, userProvider, categoryProvider, child) {
        return FutureBuilder<Map<String, dynamic>>(
          future: _getStorageStatistics(),
          builder: (context, snapshot) {
            // Show loading state while Firebase Storage statistics are being fetched
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingStats(context);
            }

            // Use Firebase Storage statistics only, no fallback to avoid flickering
            final storageStats = snapshot.data ?? {};
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
      },
    );
  }

  /// Get Firebase Storage statistics
  Future<Map<String, dynamic>> _getStorageStatistics() async {
    try {
      final storageService = FirebaseStorageDirectService.instance;
      return await storageService.getStorageStatistics();
    } catch (e) {
      debugPrint('❌ Failed to get storage statistics: $e');
      return {};
    }
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
        mainAxisAlignment: MainAxisAlignment.center, // Tambahkan untuk center
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

// OPTIONAL: Jika Anda ingin tetap menggunakan ResponsiveUtils,
// pastikan nilai-nilai berikut di class ResponsiveUtils:
/*
class ResponsiveUtils {
  static EdgeInsetsGeometry getResponsiveMargin(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) {
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
    } else if (width < 600) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    } else {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);

    }
  }

  static double getResponsiveSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return 8;
    else if (width < 600) return 12;
    else return 16;
  }

  static double getStatsCardAspectRatio(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return 1.2;
    else if (width < 600) return 1.3;
    else return 1.4;
  }

  static double getResponsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return 10;
    else if (width < 600) return 12;
    else return 16;
  }

  static double getResponsiveFontSize(BuildContext context, {required double baseSize}) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return baseSize * 0.85;
    else if (width < 600) return baseSize * 0.9;
    else return baseSize;
  }

  static double getResponsiveIconSize(BuildContext context, {required double baseSize}) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return baseSize * 0.8;
    else if (width < 600) return baseSize * 0.85;
    else return baseSize;
  }
}
*/
