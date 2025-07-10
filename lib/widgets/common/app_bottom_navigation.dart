import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_routes.dart';
import '../../features/auth/providers/auth_providers.dart';

/// Responsive configuration for navigation bar
class _ResponsiveNavConfig {
  final double containerHeight;
  final double horizontalPadding;
  final double verticalPadding;
  final double regularIconSize;
  final double plusButtonSize;
  final double plusIconSize;
  final double fontSize;
  final double plusButtonMargin;

  const _ResponsiveNavConfig({
    required this.containerHeight,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.regularIconSize,
    required this.plusButtonSize,
    required this.plusIconSize,
    required this.fontSize,
    required this.plusButtonMargin,
  });
}

class AppBottomNavigation extends ConsumerWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isAdminProvider);

    return _CustomBottomNavigationBar(
      currentIndex: currentIndex,
      isAdmin: isAdmin,
      onTap: (index) => _handleNavigation(context, index, ref),
    );
  }

  void _handleNavigation(BuildContext context, int index, WidgetRef ref) {
    // Call the onTap callback if provided
    if (onTap != null) {
      onTap!(index);
      return;
    }

    // Default navigation behavior
    switch (index) {
      case 0:
        // Home
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          (route) => false,
        );
        break;
      case 1:
        // Category
        Navigator.pushNamed(context, AppRoutes.manageCategories);
        break;
      case 2:
        // Upload
        Navigator.pushNamed(context, AppRoutes.uploadDocument);
        break;
      case 3:
        final isAdmin = ref.read(isAdminProvider);
        if (isAdmin) {
          // Activity (Admin only)
          Navigator.pushNamed(context, AppRoutes.activity);
        } else {
          // Profile (Non-admin)
          Navigator.pushNamed(context, AppRoutes.profile);
        }
        break;
      case 4:
        // Profile (Admin only - index 4)
        final isAdminProfile = ref.read(isAdminProvider);
        if (isAdminProfile) {
          Navigator.pushNamed(context, AppRoutes.profile);
        }
        break;
    }
  }
}

/// Custom bottom navigation bar with YouTube-style prominent plus button
class _CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final bool isAdmin;
  final Function(int) onTap;

  const _CustomBottomNavigationBar({
    required this.currentIndex,
    required this.isAdmin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveConfig = _getResponsiveConfig(screenWidth);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: responsiveConfig.containerHeight,
          padding: EdgeInsets.symmetric(
            horizontal: responsiveConfig.horizontalPadding,
            vertical: responsiveConfig.verticalPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildNavigationItems(context, responsiveConfig),
          ),
        ),
      ),
    );
  }

  /// Get responsive configuration based on screen width
  _ResponsiveNavConfig _getResponsiveConfig(double screenWidth) {
    if (screenWidth >= 1200) {
      // Desktop/Large screens - Fixed overflow
      return const _ResponsiveNavConfig(
        containerHeight: 64, // Increased from 60 to 64 (+4px)
        horizontalPadding: 16,
        verticalPadding: 8,
        regularIconSize: 22,
        plusButtonSize: 40, // Reduced from 48px to 40px
        plusIconSize: 20, // Reduced from 24px to 20px
        fontSize: 11,
        plusButtonMargin: 14, // Increased margin for better spacing
      );
    } else if (screenWidth >= 768) {
      // Tablet screens - Fixed overflow
      return const _ResponsiveNavConfig(
        containerHeight: 68, // Increased from 64 to 68 (+4px)
        horizontalPadding: 12,
        verticalPadding: 8,
        regularIconSize: 23,
        plusButtonSize: 42, // Reduced from 52px to 42px
        plusIconSize: 21, // Reduced from 26px to 21px
        fontSize: 11.5,
        plusButtonMargin: 13, // Increased margin for better spacing
      );
    } else {
      // Mobile screens - Fixed overflow
      return const _ResponsiveNavConfig(
        containerHeight:
            64, // Increased from 60 to 64 (+4px) to fix 2px overflow
        horizontalPadding: 8,
        verticalPadding: 6, // Reduced from 8px
        regularIconSize: 24,
        plusButtonSize: 44, // Dikecilkan dari 56px ke 44px
        plusIconSize: 22, // Dikecilkan dari 28px ke 22px
        fontSize: 12,
        plusButtonMargin: 12, // Diperbesar dari 8px ke 12px untuk spacing
      );
    }
  }

  List<Widget> _buildNavigationItems(
    BuildContext context,
    _ResponsiveNavConfig config,
  ) {
    List<Widget> items = [
      // Home
      _buildNavItem(
        context: context,
        index: 0,
        iconPath: currentIndex == 0
            ? 'assets/icon/home-filled.svg'
            : 'assets/icon/Home.svg', // Fixed: Use correct case (uppercase H)
        label: AppStrings.home,
        isSelected: currentIndex == 0,
        config: config,
      ),

      // Category
      _buildNavItem(
        context: context,
        index: 1,
        iconPath: currentIndex == 1
            ? 'assets/icon/folder-filled.svg'
            : 'assets/icon/folder.svg',
        label: 'Category',
        isSelected: currentIndex == 1,
        config: config,
      ),

      // YouTube-style Plus Button (prominent)
      _buildPlusButton(context, config),
    ];

    if (isAdmin) {
      // Activity (Admin only)
      items.add(
        _buildNavItem(
          context: context,
          index: 3,
          iconPath: 'assets/icon/Activity.svg',
          label: 'Activity',
          isSelected: currentIndex == 3,
          config: config,
        ),
      );

      // Profile (Admin)
      items.add(
        _buildNavItem(
          context: context,
          index: 4,
          iconPath: currentIndex == 4
              ? 'assets/icon/user-filled.svg'
              : 'assets/icon/user.svg',
          label: 'Profile',
          isSelected: currentIndex == 4,
          config: config,
        ),
      );
    } else {
      // Profile (Non-admin)
      items.add(
        _buildNavItem(
          context: context,
          index: 3,
          iconPath: currentIndex == 3
              ? 'assets/icon/user-filled.svg'
              : 'assets/icon/user.svg',
          label: 'Profile',
          isSelected: currentIndex == 3,
          config: config,
        ),
      );
    }

    return items;
  }

  /// Get fallback icon for missing SVG assets
  IconData _getFallbackIcon(String iconPath) {
    if (iconPath.contains('home')) {
      return Icons.home;
    } else if (iconPath.contains('folder')) {
      return Icons.folder;
    } else if (iconPath.contains('user') || iconPath.contains('add-user')) {
      return Icons.person;
    } else if (iconPath.contains('Activity')) {
      return Icons.analytics;
    } else if (iconPath.contains('plus')) {
      return Icons.add;
    } else {
      return Icons.help_outline; // Default fallback
    }
  }

  /// Build regular navigation item with responsive sizing
  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required String iconPath,
    required String label,
    required bool isSelected,
    required _ResponsiveNavConfig config,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: config.verticalPadding / 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                iconPath,
                width: config.regularIconSize,
                height: config.regularIconSize,
                colorFilter: ColorFilter.mode(
                  isSelected ? AppColors.primary : AppColors.textSecondary,
                  BlendMode.srcIn,
                ),
                // Add error handling for missing assets
                placeholderBuilder: (context) => Icon(
                  _getFallbackIcon(iconPath),
                  size: config.regularIconSize,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ),
              SizedBox(height: config.verticalPadding / 2),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: config.fontSize,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build YouTube-style prominent plus button with responsive sizing
  Widget _buildPlusButton(BuildContext context, _ResponsiveNavConfig config) {
    return GestureDetector(
      onTap: () => onTap(2),
      child: Container(
        width: config.plusButtonSize,
        height: config.plusButtonSize,
        margin: EdgeInsets.symmetric(horizontal: config.plusButtonMargin),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(config.plusButtonSize / 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: config.plusButtonSize * 0.15, // Proportional blur
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icon/plus.svg',
            width: config.plusIconSize,
            height: config.plusIconSize,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}

// Helper widget for pages that need bottom navigation
class AppScaffoldWithNavigation extends StatefulWidget {
  final Widget body;
  final String title;
  final List<Widget>? actions;
  final int currentNavIndex;
  final bool showAppBar;
  final Widget? leading;
  final Color? appBarBackgroundColor;
  final Color? appBarForegroundColor;
  final Widget? floatingActionButton;

  const AppScaffoldWithNavigation({
    super.key,
    required this.body,
    required this.title,
    required this.currentNavIndex,
    this.actions,
    this.showAppBar = true,
    this.leading,
    this.appBarBackgroundColor,
    this.appBarForegroundColor,
    this.floatingActionButton,
  });

  @override
  State<AppScaffoldWithNavigation> createState() =>
      _AppScaffoldWithNavigationState();
}

class _AppScaffoldWithNavigationState extends State<AppScaffoldWithNavigation> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentNavIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(
                widget.title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: widget.appBarForegroundColor ?? AppColors.textWhite,
                ),
              ),
              backgroundColor:
                  widget.appBarBackgroundColor ?? AppColors.primary,
              foregroundColor:
                  widget.appBarForegroundColor ?? AppColors.textWhite,
              elevation: 0,
              actions: widget.actions,
              centerTitle: true,
              automaticallyImplyLeading:
                  widget.leading ==
                  null, // Only auto-imply if no custom leading
              leading: widget.leading, // Use custom leading if provided
            )
          : null,
      body: widget.body,
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        // Don't provide onTap callback, let it use default navigation
      ),
      floatingActionButton: widget.floatingActionButton,
    );
  }
}
