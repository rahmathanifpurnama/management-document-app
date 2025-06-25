import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';

class AppScaffoldWithNavigation extends StatelessWidget {
  final String title;
  final Widget body;
  final int currentNavIndex;
  final bool showAppBar;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const AppScaffoldWithNavigation({
    super.key,
    required this.title,
    required this.body,
    required this.currentNavIndex,
    this.showAppBar = true,
    this.actions,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: Text(title),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              actions: actions,
            )
          : null,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentNavIndex >= 0 ? currentNavIndex : 0,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      onTap: (index) => _onNavTap(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Categories'),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  void _onNavTap(BuildContext context, int index) {
    if (index == currentNavIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.categories);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.uploadDocument);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.profile);
        break;
    }
  }
}
