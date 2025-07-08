import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../services/activity_service.dart';

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
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final stats = await _activityService.getActivityStatistics();
      if (mounted) {
        setState(() => _statistics = stats);
      }
    } catch (e) {
      debugPrint('Error loading activity statistics: $e');
      // Set default values on error
      if (mounted) {
        setState(() {
          _statistics = {
            'todayCount': 0,
            'weekCount': 0,
            'activeUsers': 0,
            'suspiciousCount': 0,
          };
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildStatisticsGrid();
  }

  Widget _buildStatisticsGrid() {
    final widgets = _buildStatWidgets();

    return Column(
      children: [
        // Single row with 4 widgets
        Row(
          children:
              widgets.map((widget) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      child: widget,
                    ),
                  );
                }).toList()
                ..last = Expanded(
                  child: widgets.last,
                ), // Remove margin from last widget
        ),
      ],
    );
  }

  List<Widget> _buildStatWidgets() {
    return [
      _buildStatWidget(
        key: 'today',
        title: "Today's Activities",
        value: (_statistics['todayCount'] ?? 0).toString(),
        icon: Icons.today,
        color: AppColors.primary,
        isClickable: true,
        showValue: true,
      ),
      _buildStatWidget(
        key: 'week',
        title: 'Weekly Activities',
        value: (_statistics['weekCount'] ?? 0).toString(),
        icon: Icons.date_range,
        color: AppColors.success,
        isClickable: true,
        showValue: true,
      ),
      _buildStatWidget(
        key: 'users',
        title: 'Active Users',
        value: (_statistics['activeUsers'] ?? 0).toString(),
        icon: Icons.people,
        color: AppColors.info,
        isClickable: true,
        showValue: true,
      ),
      _buildStatWidget(
        key: 'suspicious',
        title: 'Suspicious Activities',
        value: (_statistics['suspiciousCount'] ?? 0).toString(),
        icon: Icons.security,
        color: AppColors.warning,
        isClickable: true,
        showValue: true,
      ),
    ];
  }

  Widget _buildStatWidget({
    required String key,
    required String title,
    required String value,
    IconData? icon,
    String? iconAsset,
    required Color color,
    bool isClickable = true,
    bool showValue = true,
  }) {
    return ActivityStatWidget(
      title: title,
      value: value,
      icon: icon,
      iconAsset: iconAsset,
      color: color,
      onTap: isClickable ? () => widget.onStatTap?.call(key) : null,
      isLoading: _isLoading,
      showValue: showValue,
      showAlert:
          key == 'suspicious' &&
          int.tryParse(value) != null &&
          int.parse(value) > 0,
    );
  }
}

/// Individual activity stat widget with dashboard-style design
class ActivityStatWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final String? iconAsset;
  final Color color;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool showValue;
  final bool showAlert;

  const ActivityStatWidget({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.iconAsset,
    required this.color,
    this.onTap,
    this.isLoading = false,
    this.showValue = true,
    this.showAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    // Fixed sizing similar to dashboard stats
    const padding = EdgeInsets.all(8.0);
    const borderRadius = 12.0;
    const spacing = 4.0;
    const valueFontSize = 18.0;
    const titleFontSize = 11.0;
    const iconSize = 20.0;

    // Calculate consistent minimum height for all widgets
    final iconContainerHeight = iconSize + (spacing * 2);
    final baseContentHeight =
        iconContainerHeight +
        spacing +
        (valueFontSize * 1.1) +
        (spacing / 2) +
        (titleFontSize * 1.3 * 3);
    final minHeight = baseContentHeight + (padding.vertical);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: minHeight,
        padding: padding,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container with alert badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconContainer(
                  iconSize: iconSize,
                  spacing: spacing,
                  borderRadius: borderRadius,
                ),
                if (showAlert)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Alert',
                      style: GoogleFonts.poppins(
                        fontSize: 7,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: spacing),
            // Value text (conditional display)
            if (showValue) ...[
              Text(
                isLoading ? '...' : value,
                style: GoogleFonts.poppins(
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.w700,
                  color: isLoading ? AppColors.textSecondary : color,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: spacing / 2),
            ],
            // Title text
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Build icon container with unified styling
  Widget _buildIconContainer({
    required double iconSize,
    required double spacing,
    required double borderRadius,
  }) {
    return Container(
      padding: EdgeInsets.all(spacing),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(borderRadius / 1.5),
      ),
      child: icon != null
          ? Icon(icon, size: iconSize, color: color)
          : const SizedBox.shrink(),
    );
  }
}
