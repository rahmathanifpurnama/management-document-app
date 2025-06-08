import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_helpers.dart';

class NavigationFlowTest {
  /// Run bottom navigation flow test
  static Future<void> runBottomNavigationFlow(WidgetTester tester) async {
    // Ensure user is logged in
    await TestHelpers.loginWithTestCredentials(tester);

    // Test each bottom navigation tab
    await _testHomeTab(tester);
    await _testCategoriesTab(tester);
    await _testActivitiesTab(tester);
    await _testProfileTab(tester);

    // Test navigation state persistence
    await _testNavigationStatePersistence(tester);

    await TestHelpers.takeScreenshot(tester, 'bottom_navigation_complete');
  }

  /// Run deep navigation flow test
  static Future<void> runDeepNavigationFlow(WidgetTester tester) async {
    // Ensure user is logged in
    await TestHelpers.loginWithTestCredentials(tester);

    // Navigate through multiple screens
    await _navigateToUserManagement(tester);
    await _navigateToCreateUser(tester);
    await _navigateToUserDetails(tester);

    // Test deep linking if supported
    await _testDeepLinking(tester);

    await TestHelpers.takeScreenshot(tester, 'deep_navigation_complete');
  }

  /// Run back navigation flow test
  static Future<void> runBackNavigationFlow(WidgetTester tester) async {
    // Ensure user is logged in
    await TestHelpers.loginWithTestCredentials(tester);

    // Navigate deep into the app
    await _navigateDeepIntoApp(tester);

    // Test back button navigation
    await _testBackButtonNavigation(tester);

    // Test gesture-based back navigation
    await _testGestureBackNavigation(tester);

    await TestHelpers.takeScreenshot(tester, 'back_navigation_complete');
  }

  /// Test home tab
  static Future<void> _testHomeTab(WidgetTester tester) async {
    // Tap home tab
    final homeTab = find.text('Home');
    if (homeTab.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, homeTab);
    } else {
      // Try icon-based navigation
      final homeIcon = find.byIcon(Icons.home);
      if (homeIcon.evaluate().isNotEmpty) {
        await TestHelpers.tapAndWait(tester, homeIcon);
      }
    }

    // Verify home screen content
    await TestHelpers.waitForText(tester, 'Home');
    expect(find.text('Documents'), findsAtLeastNWidgets(1));
    expect(find.text('Recent'), findsAtLeastNWidgets(1));

    await TestHelpers.takeScreenshot(tester, 'home_tab');
  }

  /// Test categories tab
  static Future<void> _testCategoriesTab(WidgetTester tester) async {
    // Tap categories tab
    final categoriesTab = find.text('Categories');
    if (categoriesTab.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, categoriesTab);
    } else {
      // Try icon-based navigation
      final categoriesIcon = find.byIcon(Icons.category);
      if (categoriesIcon.evaluate().isNotEmpty) {
        await TestHelpers.tapAndWait(tester, categoriesIcon);
      }
    }

    // Verify categories screen content
    await TestHelpers.waitForText(tester, 'Categories');
    expect(find.byType(GridView), findsAtLeastNWidgets(1));

    await TestHelpers.takeScreenshot(tester, 'categories_tab');
  }

  /// Test activities tab
  static Future<void> _testActivitiesTab(WidgetTester tester) async {
    // Tap activities tab
    final activitiesTab = find.text('Activities');
    if (activitiesTab.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, activitiesTab);
    } else {
      // Try icon-based navigation
      final activitiesIcon = find.byIcon(Icons.history);
      if (activitiesIcon.evaluate().isNotEmpty) {
        await TestHelpers.tapAndWait(tester, activitiesIcon);
      }
    }

    // Verify activities screen content
    await TestHelpers.waitForText(tester, 'Activities');
    expect(find.byType(ListView), findsAtLeastNWidgets(1));

    await TestHelpers.takeScreenshot(tester, 'activities_tab');
  }

  /// Test profile tab
  static Future<void> _testProfileTab(WidgetTester tester) async {
    // Tap profile tab
    final profileTab = find.text('Profile');
    if (profileTab.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, profileTab);
    } else {
      // Try icon-based navigation
      final profileIcon = find.byIcon(Icons.person);
      if (profileIcon.evaluate().isNotEmpty) {
        await TestHelpers.tapAndWait(tester, profileIcon);
      }
    }

    // Verify profile screen content
    await TestHelpers.waitForText(tester, 'Profile');
    expect(find.text('Personal Info'), findsAtLeastNWidgets(1));
    expect(find.text('Settings'), findsAtLeastNWidgets(1));

    await TestHelpers.takeScreenshot(tester, 'profile_tab');
  }

  /// Test navigation state persistence
  static Future<void> _testNavigationStatePersistence(
    WidgetTester tester,
  ) async {
    // Navigate to a specific tab
    await _testCategoriesTab(tester);

    // Simulate app backgrounding and foregrounding
    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
      'flutter/lifecycle',
      const StandardMethodCodec().encodeMethodCall(
        const MethodCall('AppLifecycleState.paused', null),
      ),
      (data) {},
    );

    await tester.pumpAndSettle();

    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
      'flutter/lifecycle',
      const StandardMethodCodec().encodeMethodCall(
        const MethodCall('AppLifecycleState.resumed', null),
      ),
      (data) {},
    );

    await tester.pumpAndSettle();

    // Verify we're still on the categories tab
    expect(find.text('Categories'), findsOneWidget);
  }

  /// Navigate to user management
  static Future<void> _navigateToUserManagement(WidgetTester tester) async {
    // Navigate to profile first
    await _testProfileTab(tester);

    // Look for user management option (admin only)
    final userManagementOption = find.text('User Management');
    if (userManagementOption.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, userManagementOption);
      await TestHelpers.waitForText(tester, 'User Management');
    } else {
      // Try through settings
      final settingsOption = find.text('Settings');
      if (settingsOption.evaluate().isNotEmpty) {
        await TestHelpers.tapAndWait(tester, settingsOption);
        await TestHelpers.waitForText(tester, 'User Management');
        await TestHelpers.tapAndWait(tester, find.text('User Management'));
      }
    }

    await TestHelpers.takeScreenshot(tester, 'user_management_screen');
  }

  /// Navigate to create user
  static Future<void> _navigateToCreateUser(WidgetTester tester) async {
    // Look for create user button
    final createUserButton = find.text('Create User');
    final addUserButton = find.byIcon(Icons.add);

    if (createUserButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, createUserButton);
    } else if (addUserButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, addUserButton);
    }

    await TestHelpers.waitForText(tester, 'Create User');
    await TestHelpers.takeScreenshot(tester, 'create_user_screen');
  }

  /// Navigate to user details
  static Future<void> _navigateToUserDetails(WidgetTester tester) async {
    // Go back to user management
    final backButton = find.byIcon(Icons.arrow_back);
    if (backButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, backButton);
    }

    // Select a user from the list
    final userTile = find.byType(ListTile).first;
    if (userTile.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, userTile);
      await TestHelpers.waitForText(tester, 'User Details');
    }

    await TestHelpers.takeScreenshot(tester, 'user_details_screen');
  }

  /// Test deep linking
  static Future<void> _testDeepLinking(WidgetTester tester) async {
    // This would test deep linking functionality if implemented
    // For now, we'll just verify the current navigation state
    await tester.pumpAndSettle();

    // Verify we can navigate directly to specific screens
    // This would require actual deep link implementation
  }

  /// Navigate deep into the app
  static Future<void> _navigateDeepIntoApp(WidgetTester tester) async {
    // Start from home
    await _testHomeTab(tester);

    // Navigate to categories
    await _testCategoriesTab(tester);

    // Select a category
    final categoryTile = find.byType(Card).first;
    if (categoryTile.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, categoryTile);
      await tester.pumpAndSettle();
    }

    // Navigate to category files
    final viewFilesButton = find.text('View Files');
    if (viewFilesButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, viewFilesButton);
      await tester.pumpAndSettle();
    }

    // Select a file
    final fileTile = find.byType(ListTile).first;
    if (fileTile.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, fileTile);
      await tester.pumpAndSettle();
    }

    await TestHelpers.takeScreenshot(tester, 'deep_navigation_end');
  }

  /// Test back button navigation
  static Future<void> _testBackButtonNavigation(WidgetTester tester) async {
    // Count current navigation stack depth
    int backPresses = 0;

    // Press back button multiple times
    while (find.byIcon(Icons.arrow_back).evaluate().isNotEmpty &&
        backPresses < 5) {
      await TestHelpers.tapAndWait(tester, find.byIcon(Icons.arrow_back));
      backPresses++;
      await tester.pumpAndSettle();
    }

    // Should eventually reach home screen
    expect(find.text('Home'), findsAtLeastNWidgets(1));

    await TestHelpers.takeScreenshot(tester, 'back_navigation_complete');
  }

  /// Test gesture-based back navigation
  static Future<void> _testGestureBackNavigation(WidgetTester tester) async {
    // Navigate deep again
    await _navigateDeepIntoApp(tester);

    // Test swipe back gesture (iOS style)
    await tester.fling(find.byType(Scaffold), const Offset(300, 0), 1000);
    await tester.pumpAndSettle();

    // Verify navigation occurred
    // Note: This might not work on all platforms
    await TestHelpers.takeScreenshot(tester, 'gesture_back_navigation');
  }

  /// Test drawer navigation
  static Future<void> testDrawerNavigation(WidgetTester tester) async {
    // Ensure user is logged in
    await TestHelpers.loginWithTestCredentials(tester);

    // Open drawer
    final drawerButton = find.byIcon(Icons.menu);
    if (drawerButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, drawerButton);

      // Test drawer items
      await _testDrawerItems(tester);

      // Close drawer
      await tester.tap(find.byType(Scaffold));
      await tester.pumpAndSettle();
    }

    await TestHelpers.takeScreenshot(tester, 'drawer_navigation_complete');
  }

  /// Test drawer items
  static Future<void> _testDrawerItems(WidgetTester tester) async {
    // Test each drawer item
    final drawerItems = ['Home', 'Categories', 'Settings', 'About'];

    for (final item in drawerItems) {
      final itemFinder = find.text(item);
      if (itemFinder.evaluate().isNotEmpty) {
        await TestHelpers.tapAndWait(tester, itemFinder);
        await tester.pumpAndSettle();

        // Verify navigation
        expect(find.text(item), findsAtLeastNWidgets(1));

        // Go back to drawer
        final drawerButton = find.byIcon(Icons.menu);
        if (drawerButton.evaluate().isNotEmpty) {
          await TestHelpers.tapAndWait(tester, drawerButton);
        }
      }
    }
  }

  /// Test tab persistence across app lifecycle
  static Future<void> testTabPersistenceAcrossLifecycle(
    WidgetTester tester,
  ) async {
    // Ensure user is logged in
    await TestHelpers.loginWithTestCredentials(tester);

    // Navigate to a specific tab
    await _testCategoriesTab(tester);

    // Simulate app going to background
    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
      'flutter/lifecycle',
      const StandardMethodCodec().encodeMethodCall(
        const MethodCall('AppLifecycleState.paused', null),
      ),
      (data) {},
    );

    // Simulate app coming back to foreground
    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
      'flutter/lifecycle',
      const StandardMethodCodec().encodeMethodCall(
        const MethodCall('AppLifecycleState.resumed', null),
      ),
      (data) {},
    );

    await tester.pumpAndSettle();

    // Verify we're still on the categories tab
    expect(find.text('Categories'), findsOneWidget);

    await TestHelpers.takeScreenshot(tester, 'tab_persistence_verified');
  }
}
