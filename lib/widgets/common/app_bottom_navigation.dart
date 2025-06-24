import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_routes.dart';
import '../../providers/auth_provider.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return _CustomBottomNavigationBar(
          currentIndex: currentIndex,
          isAdmin: authProvider.isAdmin,
          onTap: (index) => _handleNavigation(context, index, authProvider),
        );
      },
    );
  }

  void _handleNavigation(
    BuildContext context,
    int index,
    AuthProvider authProvider,
  ) {
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
        if (authProvider.isAdmin) {
          // Add User (Admin only)
          Navigator.pushNamed(context, AppRoutes.userManagement);
        } else {
          // Profile (Non-admin)
          Navigator.pushNamed(context, AppRoutes.profile);
        }
        break;
      case 4:
        // Profile (Admin only - index 4)
        if (authProvider.isAdmin) {
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
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildNavigationItems(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNavigationItems(BuildContext context) {
    List<Widget> items = [
      // Home
      _buildNavItem(
        context: context,
        index: 0,
        iconPath: currentIndex == 0
            ? 'assets/icon/home-filled.svg'
            : 'assets/icon/home.svg',
        label: AppStrings.home,
        isSelected: currentIndex == 0,
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
      ),

      // YouTube-style Plus Button (prominent)
      _buildPlusButton(context),
    ];

    if (isAdmin) {
      // Add User (Admin only)
      items.add(
        _buildNavItem(
          context: context,
          index: 3,
          iconPath: currentIndex == 3
              ? 'assets/icon/add-user-filled.svg'
              : 'assets/icon/add-user.svg',
          label: 'Add User',
          isSelected: currentIndex == 3,
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
        ),
      );
    }

    return items;
  }

  /// Build regular navigation item
  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required String iconPath,
    required String label,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                iconPath,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  isSelected ? AppColors.primary : AppColors.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
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

  /// Build YouTube-style prominent plus button
  Widget _buildPlusButton(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(2),
      child: Container(
        width: 56,
        height: 56,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icon/plus.svg',
            width: 28,
            height: 28,
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
