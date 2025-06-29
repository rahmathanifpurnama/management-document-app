import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../services/optimized_statistics_service.dart';
import '../../services/statistics_notification_service.dart';
import '../../services/real_time_sync_service.dart';

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

class _RealTimeStatsWidgetState extends State<RealTimeStatsWidget> {
  final OptimizedStatisticsService _statsService =
      OptimizedStatisticsService.instance;
  final StatisticsNotificationService _notificationService =
      StatisticsNotificationService.instance;
  final RealTimeSyncService _realTimeSyncService = RealTimeSyncService.instance;

  // State management
  Map<String, dynamic> _statsData = {};
  bool _isLoading = true;
  bool _hasError = false;
  bool _isRealTimeSyncEnabled = false;

  // Stream subscriptions
  StreamSubscription? _statisticsSubscription;
  StreamSubscription? _fileCountSubscription;
  StreamSubscription? _syncEventsSubscription;

  @override
  void initState() {
    super.initState();
    _initializeRealTimeSync();
  }

  /// Initialize real-time synchronization and load statistics
  Future<void> _initializeRealTimeSync() async {
    try {
      // Initialize real-time sync service
      await _statsService.initializeRealTimeSync();

      setState(() {
        _isRealTimeSyncEnabled = true;
      });

      // Setup enhanced real-time listeners
      _setupEnhancedRealTimeListeners();

      // Load initial statistics
      await _loadStatistics();
    } catch (e) {
      // Fallback to traditional loading
      _setupRealTimeListeners();
      _loadStatistics();
    }
  }

  /// Setup enhanced real-time listeners with sync events
  void _setupEnhancedRealTimeListeners() {
    try {
      // Listen to enhanced statistics stream
      _statisticsSubscription = _statsService
          .getEnhancedStatisticsStream()
          .listen(
            (stats) {
              if (mounted) {
                setState(() {
                  _statsData = stats;
                  _isLoading = false;
                  _hasError = false;
                });
              }
            },
            onError: (error) {
              debugPrint('❌ Enhanced statistics stream error: $error');
              if (mounted) {
                setState(() {
                  _hasError = true;
                  _isLoading = false;
                });
              }
            },
          );

      // Listen to sync events for UI feedback
      _syncEventsSubscription = _realTimeSyncService.syncEventsStream.listen(
        (event) {
          if (mounted) {
            _handleSyncEvent(event);
          }
        },
        onError: (error) {
          debugPrint('❌ Sync events stream error: $error');
        },
      );

      debugPrint('✅ Enhanced real-time listeners setup complete');
    } catch (e) {
      debugPrint('❌ Error setting up enhanced listeners: $e');
      // Fallback to traditional listeners
      _setupRealTimeListeners();
    }
  }

  /// Handle sync events for UI feedback
  void _handleSyncEvent(SyncEvent event) {
    // Silently handle sync events without notifications
    switch (event.type) {
      case SyncEventType.documentAdded:
      case SyncEventType.userAdded:
      case SyncEventType.statisticsUpdated:
      case SyncEventType.error:
      default:
        break;
    }
  }

  void _setupRealTimeListeners() {
    // Listen to statistics updates
    _statisticsSubscription = _notificationService.statisticsUpdates.listen((
      event,
    ) {
      _loadStatistics();
    });

    // Listen to file count updates
    _fileCountSubscription = _notificationService.fileCountUpdates.listen((
      event,
    ) {
      _loadStatistics();
    });
  }

  Future<void> _loadStatistics() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Use optimized service with built-in fallback to direct Firestore
      // This service already handles Cloud Function -> Direct Firestore fallback
      final stats = await _statsService.getAggregatedStatistics();

      if (mounted) {
        setState(() {
          _statsData = stats;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _statisticsSubscription?.cancel();
    _fileCountSubscription?.cancel();
    _syncEventsSubscription?.cancel();
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
          vertical: 0.0,
        );

    final containerPadding =
        widget.padding ??
        EdgeInsets.all(isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 20.0));

    final responsiveElevation = 2.0;

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
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: responsiveElevation * 2,
            offset: Offset(0, responsiveElevation / 2),
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
    return SizedBox(
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

    return Row(
      children: statCards.map((cardData) {
        final isLast = statCards.indexOf(cardData) == statCards.length - 1;
        return Expanded(
          child: Row(
            children: [
              Expanded(child: _buildStatCard(cardData)),
              if (!isLast) SizedBox(width: isSmallScreen ? 8 : 12),
            ],
          ),
        );
      }).toList(),
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
