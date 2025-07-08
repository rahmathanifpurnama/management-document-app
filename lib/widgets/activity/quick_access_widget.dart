import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../services/activity_service.dart';
import '../common/app_container.dart';

class QuickAccessWidget extends StatefulWidget {
  final VoidCallback? onRefresh;
  final Function(String)? onStatTap;
  final bool showRefreshButton;
  final double? height;

  const QuickAccessWidget({
    super.key,
    this.onRefresh,
    this.onStatTap,
    this.showRefreshButton = true,
    this.height,
  });

  @override
  State<QuickAccessWidget> createState() => _QuickAccessWidgetState();
}

class _QuickAccessWidgetState extends State<QuickAccessWidget> {
  final ActivityService _activityService = ActivityService();

  Map<String, dynamic> _statistics = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() => _isLoading = true);

    try {
      final stats = await _activityService.getActivityStatistics();
      setState(() => _statistics = stats);
    } catch (e) {
      debugPrint('Error loading activity statistics: $e');
      // Set default values on error
      setState(() {
        _statistics = {
          'todayCount': 0,
          'weekCount': 0,
          'activeUsers': 0,
          'suspiciousCount': 0,
        };
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRefresh() async {
    await _loadStatistics();
    widget.onRefresh?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer.card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildStatisticsCards(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Quick Access',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        if (widget.showRefreshButton)
          IconButton(
            onPressed: _isLoading ? null : _handleRefresh,
            icon: _isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  )
                : const Icon(Icons.refresh),
            iconSize: 20,
            color: AppColors.primary,
            tooltip: 'Refresh Statistics',
          ),
      ],
    );
  }

  Widget _buildStatisticsCards() {
    if (_isLoading && _statistics.isEmpty) {
      return SizedBox(
        height: widget.height ?? 120,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final statCards = [
      _StatCardData(
        key: 'today',
        title: "Today's Activities",
        value: (_statistics['todayCount'] ?? 0).toString(),
        icon: Icons.today,
        color: AppColors.primary,
        subtitle: 'Activities today',
      ),
      _StatCardData(
        key: 'week',
        title: 'Weekly Activities',
        value: (_statistics['weekCount'] ?? 0).toString(),
        icon: Icons.date_range,
        color: AppColors.success,
        subtitle: 'This week',
      ),
      _StatCardData(
        key: 'users',
        title: 'Active Users',
        value: (_statistics['activeUsers'] ?? 0).toString(),
        icon: Icons.people,
        color: AppColors.info,
        subtitle: 'Last 24 hours',
      ),
      _StatCardData(
        key: 'suspicious',
        title: 'Suspicious Activities',
        value: (_statistics['suspiciousCount'] ?? 0).toString(),
        icon: Icons.security,
        color: AppColors.warning,
        subtitle: 'This week',
      ),
    ];

    return SizedBox(
      height: widget.height ?? 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: statCards.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final card = statCards[index];
          return _buildStatCard(card);
        },
      ),
    );
  }

  Widget _buildStatCard(_StatCardData card) {
    return GestureDetector(
      onTap: () => widget.onStatTap?.call(card.key),
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: card.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: card.color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(card.icon, color: card.color, size: 24),
                if (card.key == 'suspicious' &&
                    int.tryParse(card.value) != null &&
                    int.parse(card.value) > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Alert',
                      style: GoogleFonts.poppins(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                card.value,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: card.color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                card.title,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: Text(
                card.subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCardData {
  final String key;
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String subtitle;

  const _StatCardData({
    required this.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.subtitle,
  });
}

/// Extension for creating quick access widgets with different configurations
extension QuickAccessWidgetExtensions on QuickAccessWidget {
  /// Create a compact version of the quick access widget
  static QuickAccessWidget compact({
    VoidCallback? onRefresh,
    Function(String)? onStatTap,
  }) {
    return QuickAccessWidget(
      height: 100,
      showRefreshButton: false,
      onRefresh: onRefresh,
      onStatTap: onStatTap,
    );
  }

  /// Create a full-featured version with all options
  static QuickAccessWidget full({
    VoidCallback? onRefresh,
    Function(String)? onStatTap,
    bool showRefreshButton = true,
  }) {
    return QuickAccessWidget(
      height: 120,
      showRefreshButton: showRefreshButton,
      onRefresh: onRefresh,
      onStatTap: onStatTap,
    );
  }

  /// Create a minimal version for dashboard
  static QuickAccessWidget minimal({
    VoidCallback? onRefresh,
    Function(String)? onStatTap,
  }) {
    return QuickAccessWidget(
      height: 80,
      showRefreshButton: false,
      onRefresh: onRefresh,
      onStatTap: onStatTap,
    );
  }
}
