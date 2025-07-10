import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../features/notification/providers/notification_providers.dart';

/// Bell notification widget with Lottie animation for AppBar
class BellNotificationWidget extends ConsumerStatefulWidget {
  const BellNotificationWidget({super.key});

  @override
  ConsumerState<BellNotificationWidget> createState() =>
      _BellNotificationWidgetState();
}

class _BellNotificationWidgetState extends ConsumerState<BellNotificationWidget>
    with TickerProviderStateMixin {
  late AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  void _navigateToNotificationCenter(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.notificationCenter);
  }

  @override
  Widget build(BuildContext context) {
    final hasNotifications = ref.watch(hasAnyNotificationsProvider);
    final notificationCount = ref.watch(totalNotificationCountProvider);

    // Control Lottie animation based on notification state
    if (hasNotifications) {
      _lottieController.repeat();
    } else {
      _lottieController.stop();
      _lottieController.reset();
    }

    return Stack(
      children: [
        IconButton(
          onPressed: () => _navigateToNotificationCenter(context),
          icon: hasNotifications
              ? Lottie.asset(
                  'assets/animation/bell.json',
                  controller: _lottieController,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                )
              : Icon(
                  Icons.notifications_outlined,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
          tooltip: 'Notifikasi',
        ),

        // Notification badge
        if (hasNotifications && notificationCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                notificationCount > 99 ? '99+' : notificationCount.toString(),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
