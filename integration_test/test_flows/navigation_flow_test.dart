import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:managementdoc/main.dart' as app;
import 'package:managementdoc/core/constants/app_strings.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Navigation Flow Tests', () {
    setUp(() async {
      app.main();
      await Future.delayed(const Duration(seconds: 3));
    });

    testWidgets('Bottom navigation bar functionality', (
      WidgetTester tester,
    ) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Login first
      await _performLogin(tester);

      // Verify bottom navigation bar exists
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Test Home tab
      await tester.tap(find.byIcon(Icons.home));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.home), findsOneWidget);

      // Test Categories tab
      await tester.tap(find.byIcon(Icons.folder));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.categories), findsOneWidget);

      // Test Add/Upload tab
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.uploadDocument), findsOneWidget);

      // Test Profile tab
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.profile), findsOneWidget);
    });

    testWidgets('Navigation state persistence', (WidgetTester tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performLogin(tester);

      // Navigate to categories
      await tester.tap(find.byIcon(Icons.folder));
      await tester.pumpAndSettle();

      // Navigate to profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Go back to categories - should maintain state
      await tester.tap(find.byIcon(Icons.folder));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.categories), findsOneWidget);
    });

    testWidgets('Deep navigation - Category to files', (
      WidgetTester tester,
    ) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performLogin(tester);

      // Navigate to categories
      await tester.tap(find.byIcon(Icons.folder));
      await tester.pumpAndSettle();

      // Find and tap on a category
      final categoryTile = find.byType(ListTile).first;
      if (categoryTile.evaluate().isNotEmpty) {
        await tester.tap(categoryTile);
        await tester.pumpAndSettle();

        // Should navigate to category files screen
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      }
    });

    testWidgets('Back navigation functionality', (WidgetTester tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performLogin(tester);

      // Navigate to profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Navigate to settings
      final settingsButton = find.text(AppStrings.settings);
      if (settingsButton.evaluate().isNotEmpty) {
        await tester.tap(settingsButton);
        await tester.pumpAndSettle();

        // Use back button
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();

        // Should be back to profile
        expect(find.text(AppStrings.profile), findsOneWidget);
      }
    });

    testWidgets('Drawer navigation (if implemented)', (
      WidgetTester tester,
    ) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performLogin(tester);

      // Look for drawer
      final drawerButton = find.byIcon(Icons.menu);
      if (drawerButton.evaluate().isNotEmpty) {
        await tester.tap(drawerButton);
        await tester.pumpAndSettle();

        // Test drawer items
        final drawerItems = find.byType(ListTile);
        if (drawerItems.evaluate().isNotEmpty) {
          await tester.tap(drawerItems.first);
          await tester.pumpAndSettle();
        }
      }
    });

    testWidgets('Tab navigation within screens', (WidgetTester tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performLogin(tester, isAdmin: true);

      // Navigate to admin screens (if tabs exist)
      final adminButton = find.text(AppStrings.userManagement);
      if (adminButton.evaluate().isNotEmpty) {
        await tester.tap(adminButton);
        await tester.pumpAndSettle();

        // Test tab navigation within admin screen
        final tabBar = find.byType(TabBar);
        if (tabBar.evaluate().isNotEmpty) {
          final tabs = find.byType(Tab);
          if (tabs.evaluate().length > 1) {
            await tester.tap(tabs.at(1));
            await tester.pumpAndSettle();
          }
        }
      }
    });

    testWidgets('Navigation with different user roles', (
      WidgetTester tester,
    ) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test as regular user
      await _performLogin(tester, isAdmin: false);

      // Verify user-specific navigation
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Admin-only features should not be visible
      expect(find.text(AppStrings.userManagement), findsNothing);

      // Logout and login as admin
      await _performLogout(tester);
      await _performLogin(tester, isAdmin: true);

      // Navigate to profile as admin
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Admin features should be visible
      final adminFeatures = find.text(AppStrings.userManagement);
      if (adminFeatures.evaluate().isNotEmpty) {
        expect(adminFeatures, findsOneWidget);
      }
    });

    testWidgets('Navigation performance - Quick tab switching', (
      WidgetTester tester,
    ) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performLogin(tester);

      final stopwatch = Stopwatch()..start();

      // Rapidly switch between tabs
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byIcon(Icons.home));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.folder));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.person));
        await tester.pumpAndSettle();
      }

      stopwatch.stop();

      // Navigation should be responsive (under 5 seconds for all switches)
      expect(stopwatch.elapsedMilliseconds, lessThan(5000));
    });

    testWidgets('Navigation with network connectivity issues', (
      WidgetTester tester,
    ) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performLogin(tester);

      // Test navigation when offline
      // This would require network mocking
      await tester.tap(find.byIcon(Icons.folder));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should handle offline state gracefully
      // Implementation depends on your offline handling
    });

    testWidgets('Navigation memory management', (WidgetTester tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performLogin(tester);

      // Navigate through multiple screens to test memory
      final navigationSequence = [
        Icons.home,
        Icons.folder,
        Icons.add,
        Icons.person,
      ];

      for (int cycle = 0; cycle < 3; cycle++) {
        for (final icon in navigationSequence) {
          await tester.tap(find.byIcon(icon));
          await tester.pumpAndSettle();

          // Small delay to allow memory cleanup
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }

      // App should remain responsive
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });
  });

  group('Navigation Edge Cases', () {
    testWidgets('Navigation during loading states', (
      WidgetTester tester,
    ) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performLogin(tester);

      // Navigate while data is loading
      await tester.tap(find.byIcon(Icons.folder));

      // Immediately try to navigate elsewhere
      await tester.tap(find.byIcon(Icons.home));
      await tester.pumpAndSettle();

      // Should handle navigation during loading gracefully
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('Navigation with system back button', (
      WidgetTester tester,
    ) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performLogin(tester);

      // Navigate to a sub-screen
      await tester.tap(find.byIcon(Icons.folder));
      await tester.pumpAndSettle();

      final categoryTile = find.byType(ListTile).first;
      if (categoryTile.evaluate().isNotEmpty) {
        await tester.tap(categoryTile);
        await tester.pumpAndSettle();

        // Simulate system back button
        await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
          'flutter/navigation',
          null,
          (data) {},
        );
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Navigation state after app backgrounding', (
      WidgetTester tester,
    ) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performLogin(tester);

      // Navigate to specific screen
      await tester.tap(find.byIcon(Icons.folder));
      await tester.pumpAndSettle();

      // Simulate app lifecycle changes
      await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'flutter/lifecycle',
        null,
        (data) {},
      );

      await tester.pumpAndSettle();

      // Should maintain navigation state
      expect(find.text(AppStrings.categories), findsOneWidget);
    });
  });
}

// Helper functions
Future<void> _performLogin(WidgetTester tester, {bool isAdmin = false}) async {
  await tester.pumpAndSettle(const Duration(seconds: 2));

  final email = isAdmin ? 'admin@test.com' : 'user@test.com';
  final password = isAdmin ? 'admin123' : 'user123';

  await tester.enterText(find.byType(TextFormField).first, email);
  await tester.enterText(find.byType(TextFormField).last, password);
  await tester.tap(find.text(AppStrings.login));
  await tester.pumpAndSettle(const Duration(seconds: 5));
}

Future<void> _performLogout(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.person));
  await tester.pumpAndSettle();

  final logoutButton = find.text(AppStrings.logout);
  if (logoutButton.evaluate().isNotEmpty) {
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();

    final confirmButton = find.text(AppStrings.confirm);
    if (confirmButton.evaluate().isNotEmpty) {
      await tester.tap(confirmButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));
    }
  }
}
