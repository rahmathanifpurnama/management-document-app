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
        List<BottomNavigationBarItem> items = [
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 32, // Fixed height for all icons
              child: Center(
                child: SvgPicture.asset(
                  currentIndex == 0
                      ? 'assets/icon/home-filled.svg'
                      : 'assets/icon/home.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    currentIndex == 0
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 32, // Fixed height for all icons
              child: Center(
                child: SvgPicture.asset(
                  currentIndex == 1
                      ? 'assets/icon/folder-filled.svg'
                      : 'assets/icon/folder.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    currentIndex == 1
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 32, // Fixed height for all icons
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(4), // Minimal padding
                  decoration: BoxDecoration(
                    color: currentIndex == 2
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.transparent,
                    border: Border.all(
                      color: currentIndex == 2
                          ? AppColors.primary
                          : AppColors.textSecondary.withValues(alpha: 0.5),
                      width: 1.2, // Thin border
                    ),
                    borderRadius: BorderRadius.circular(16), // Smaller radius
                  ),
                  child: SvgPicture.asset(
                    'assets/icon/plus.svg',
                    width: 18, // Smaller icon to fit within container
                    height: 18,
                    colorFilter: ColorFilter.mode(
                      currentIndex == 2
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            label: '',
          ),
        ];

        if (authProvider.isAdmin) {
          items.addAll([
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 32, // Fixed height for all icons
                child: Center(
                  child: SvgPicture.asset(
                    currentIndex == 3
                        ? 'assets/icon/add-user-filled.svg'
                        : 'assets/icon/add-user.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      currentIndex == 3
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              label: 'Add User',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 32, // Fixed height for all icons
                child: Center(
                  child: SvgPicture.asset(
                    currentIndex == 4
                        ? 'assets/icon/user-filled.svg'
                        : 'assets/icon/user.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      currentIndex == 4
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              label: 'Profile',
            ),
          ]);
        } else {
          // For non-admin users, add only Profile tab
          items.add(
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 32, // Fixed height for all icons
                child: Center(
                  child: SvgPicture.asset(
                    currentIndex == 3
                        ? 'assets/icon/user-filled.svg'
                        : 'assets/icon/user.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      currentIndex == 3
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              label: 'Profile',
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: SizedBox(
              height: 80, // Increased height to accommodate fixed icon heights
              child: BottomNavigationBar(
                currentIndex: currentIndex,
                onTap: (index) =>
                    _handleNavigation(context, index, authProvider),
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: AppColors.textSecondary,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedLabelStyle: GoogleFonts.poppins(
                  fontSize: 10, // Reduced font size to prevent overflow
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: GoogleFonts.poppins(
                  fontSize: 10, // Reduced font size to prevent overflow
                  fontWeight: FontWeight.w400,
                ),
                iconSize: 24, // Reduced icon size to prevent overflow
                elevation: 0,
                backgroundColor: Colors.transparent,
                items: items,
              ),
            ),
          ),
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
