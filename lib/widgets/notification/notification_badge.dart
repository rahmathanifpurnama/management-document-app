import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/notification_provider.dart';

class NotificationBadge extends StatelessWidget {
  final Widget child;
  final bool showBadge;
  final int? customCount;
  final Color? badgeColor;
  final Color? textColor;
  final double? badgeSize;
  final EdgeInsets? badgeOffset;

  const NotificationBadge({
    super.key,
    required this.child,
    this.showBadge = true,
    this.customCount,
    this.badgeColor,
    this.textColor,
    this.badgeSize,
    this.badgeOffset,
  });

  @override
  Widget build(BuildContext context) {
    if (!showBadge) return child;

    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, _) {
        final count = customCount ?? notificationProvider.unreadCount;

        if (count <= 0) return child;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            child,
            Positioned(
              right: (badgeOffset?.right ?? -8),
              top: (badgeOffset?.top ?? -8),
              child: Container(
                width: badgeSize ?? 18,
                height: badgeSize ?? 18,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: badgeColor ?? AppColors.error,
                  borderRadius: BorderRadius.circular((badgeSize ?? 18) / 2),
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    count > 99 ? '99+' : count.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: (badgeSize ?? 18) * 0.6,
                      fontWeight: FontWeight.w600,
                      color: textColor ?? Colors.white,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class NotificationIcon extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final double size;
  final Color? color;
  final bool showBadge;

  const NotificationIcon({
    super.key,
    this.onTap,
    this.icon = Icons.notifications_outlined,
    this.size = 24,
    this.color,
    this.showBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationBadge(
      showBadge: showBadge,
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, size: size, color: color ?? AppColors.textPrimary),
        tooltip: 'Notifications',
      ),
    );
  }
}

class NotificationMenuItem extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool showBadge;

  const NotificationMenuItem({
    super.key,
    this.onTap,
    required this.title,
    required this.subtitle,
    this.icon = Icons.notifications_outlined,
    this.showBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationBadge(
      showBadge: showBadge,
      badgeOffset: const EdgeInsets.only(right: 8, top: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }
}

class NotificationSummaryCard extends StatelessWidget {
  final VoidCallback? onTap;

  const NotificationSummaryCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, child) {
        final stats = notificationProvider.stats;

        return Card(
          elevation: 2,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.notifications,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Notifications',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      if (stats.unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            stats.unreadCount.toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildStatItem('Total', stats.totalCount.toString()),
                      const SizedBox(width: 16),
                      _buildStatItem('Unread', stats.unreadCount.toString()),
                      const SizedBox(width: 16),
                      _buildStatItem('Today', stats.todayCount.toString()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class NotificationFloatingButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const NotificationFloatingButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, child) {
        if (notificationProvider.unreadCount <= 0) {
          return const SizedBox.shrink();
        }

        return Positioned(
          bottom: 100,
          right: 16,
          child: NotificationBadge(
            badgeOffset: const EdgeInsets.only(right: -4, top: -4),
            child: FloatingActionButton(
              onPressed: onPressed,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.notifications, color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
