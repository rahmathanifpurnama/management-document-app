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

/// Real-time statistics widget with robust fallback mechanisms
/// Ensures statistics are always displayed with accurate, up-to-date data
class RealTimeStatsWidget extends StatefulWidget {
  final bool enablePullToRefresh;
  final VoidCallback? onRefresh;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const RealTimeStatsWidget({
    super.key,
    this.enablePullToRefresh = true,
    this.onRefresh,
    this.margin,
    this.padding,
  });

  @override
  State<RealTimeStatsWidget> createState() => _RealTimeStatsWidgetState();
}

class _RealTimeStatsWidgetState extends State<RealTimeStatsWidget>
    with TickerProviderStateMixin {
  final OptimizedStatisticsService _statsService =
      OptimizedStatisticsService.instance;
  final StatisticsNotificationService _notificationService =
      StatisticsNotificationService.instance;

  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _refreshController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _refreshAnimation;

  // State management
  Map<String, dynamic> _statsData = {};
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  // Stream subscriptions
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
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _refreshAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _refreshController, curve: Curves.elasticOut),
    );
  }

  void _setupRealTimeListeners() {
    // Listen to statistics updates
    _statisticsSubscription = _notificationService.statisticsUpdates.listen((
      event,
    ) {
      debugPrint('📊 Real-time stats update: ${event.type}');
      _loadStatistics();
    });

    // Listen to file count updates
    _fileCountSubscription = _notificationService.fileCountUpdates.listen((
      event,
    ) {
      debugPrint('📊 File count update: ${event.type}');
      _loadStatistics();
    });
  }

  Future<void> _loadStatistics() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
    });

    try {
      // Try optimized service first
      final stats = await _statsService.getAggregatedStatistics();

      if (mounted) {
        setState(() {
          _statsData = stats;
          _isLoading = false;
        });

        // Trigger refresh animation
        _refreshController.forward().then((_) {
          _refreshController.reverse();
        });
      }
    } catch (e) {
      debugPrint('❌ Stats service failed, using provider fallback: $e');

      // Fallback to provider data
      try {
        final fallbackStats = await _getStatsFromProviders();

        if (mounted) {
          setState(() {
            _statsData = fallbackStats;
            _isLoading = false;
            _hasError = false;
          });

          // Trigger refresh animation
          _refreshController.forward().then((_) {
            _refreshController.reverse();
          });
        }
      } catch (fallbackError) {
        debugPrint('❌ Provider fallback failed: $fallbackError');

        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasError = true;
            _errorMessage = 'Unable to load statistics';
          });
        }
      }
    }
  }

  Future<Map<String, dynamic>> _getStatsFromProviders() async {
    if (!mounted) return {};

    try {
      final docProvider = Provider.of<DocumentProvider>(context, listen: false);
      final catProvider = Provider.of<CategoryProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // Ensure providers have loaded data
      if (docProvider.documents.isEmpty && !docProvider.isLoading) {
        debugPrint('📊 DocumentProvider empty, loading documents...');
        await docProvider.loadDocuments();
      }

      if (catProvider.categories.isEmpty && !catProvider.isLoading) {
        debugPrint('📊 CategoryProvider empty, loading categories...');
        await catProvider.loadCategories();
      }

      if (userProvider.users.isEmpty && !userProvider.isLoading) {
        debugPrint('📊 UserProvider empty, loading users...');
        await userProvider.loadUsers();
      }

      // Calculate recent files (last 7 days)
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));

      final recentFiles = docProvider.documents.where((doc) {
        return doc.uploadedAt.isAfter(sevenDaysAgo);
      }).length;

      final stats = {
        'totalFiles': docProvider.documents.length,
        'activeUsers': userProvider.users.length,
        'totalCategories': catProvider.categories.length,
        'recentFiles': recentFiles,
        'fileTypeStats': <String, int>{},
        'totalStorageSize': 0,
        'lastCalculated': DateTime.now().toIso8601String(),
        'calculationDurationMs': 0,
      };

      debugPrint('📊 Provider fallback stats: $stats');
      return stats;
    } catch (e) {
      debugPrint('❌ Error getting stats from providers: $e');
      return {
        'totalFiles': 0,
        'activeUsers': 0,
        'totalCategories': 0,
        'recentFiles': 0,
        'fileTypeStats': <String, int>{},
        'totalStorageSize': 0,
        'lastCalculated': DateTime.now().toIso8601String(),
        'calculationDurationMs': 0,
      };
    }
  }

  @override
  void dispose() {
    _statisticsSubscription?.cancel();
    _fileCountSubscription?.cancel();
    _pulseController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final isMediumScreen = screenWidth < 600;

    final containerMargin =
        widget.margin ??
        EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 20.0),
          vertical: 8.0,
        );

    final containerPadding =
        widget.padding ??
        EdgeInsets.all(isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 20.0));

    Widget content = _buildStatsContent();

    if (widget.enablePullToRefresh) {
      content = RefreshIndicator(
        onRefresh: () async {
          await _statsService.invalidateCache(reason: 'Pull to refresh');
          await _loadStatistics();
          widget.onRefresh?.call();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: content,
        ),
      );
    }

    return Container(
      margin: containerMargin,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(padding: containerPadding, child: content),
    );
  }

  Widget _buildStatsContent() {
    if (_hasError) {
      return _buildErrorState();
    }

    if (_isLoading && _statsData.isEmpty) {
      return _buildLoadingState();
    }

    return _buildStatsGrid();
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 80,
      child: Row(
        children: List.generate(4, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
              child: _buildLoadingCard(),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 20,
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 30,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      height: 80,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: AppColors.error, size: 24),
            const SizedBox(height: 8),
            Text(
              'Unable to load statistics',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _loadStatistics,
              icon: const Icon(Icons.refresh, size: 14),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                textStyle: GoogleFonts.poppins(fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final isMediumScreen = screenWidth < 600;

    final statCards = [
      _StatCardData(
        title: 'Total',
        value: (_statsData['totalFiles'] ?? 0).toString(),
        icon: Icons.description,
        color: AppColors.primary,
      ),
      _StatCardData(
        title: 'Recent',
        value: (_statsData['recentFiles'] ?? 0).toString(),
        icon: Icons.access_time,
        color: AppColors.success,
      ),
      _StatCardData(
        title: 'Users',
        value: (_statsData['activeUsers'] ?? 0).toString(),
        icon: Icons.people,
        color: AppColors.warning,
      ),
      _StatCardData(
        title: 'Categories',
        value: (_statsData['totalCategories'] ?? 0).toString(),
        icon: Icons.folder,
        color: AppColors.info,
      ),
    ];

    return AnimatedBuilder(
      animation: _refreshAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _refreshAnimation.value,
          child: Row(
            children: statCards.map((cardData) {
              final isLast =
                  statCards.indexOf(cardData) == statCards.length - 1;
              return Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildStatCard(cardData)),
                    if (!isLast) SizedBox(width: isSmallScreen ? 8 : 12),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(_StatCardData cardData) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final isMediumScreen = screenWidth < 600;

    final padding = EdgeInsets.all(
      isSmallScreen ? 8.0 : (isMediumScreen ? 10.0 : 12.0),
    );
    final borderRadius = isSmallScreen ? 8.0 : 12.0;
    final spacing = isSmallScreen ? 4.0 : 8.0;
    final valueFontSize = isSmallScreen ? 14.0 : (isMediumScreen ? 16.0 : 18.0);
    final titleFontSize = isSmallScreen ? 9.0 : (isMediumScreen ? 10.0 : 11.0);
    final iconSize = isSmallScreen ? 16.0 : (isMediumScreen ? 18.0 : 20.0);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: cardData.color.withValues(alpha: 0.1),
          width: 1,
        ),
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
              color: cardData.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(borderRadius / 1.5),
            ),
            child: Icon(cardData.icon, color: cardData.color, size: iconSize),
          ),
          SizedBox(height: spacing),
          Text(
            cardData.value,
            style: GoogleFonts.poppins(
              fontSize: valueFontSize,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing / 2),
          Text(
            cardData.title,
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
