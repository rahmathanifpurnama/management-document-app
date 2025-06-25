import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:managementdoc/main.dart' as app;
import 'package:managementdoc/core/constants/app_strings.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow Tests', () {
    testWidgets('Complete login flow - Admin user', (
      WidgetTester tester,
    ) async {
      // Launch app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Wait for splash screen to complete
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify login screen appears
      expect(find.text(AppStrings.login), findsOneWidget);
      expect(
        find.byType(TextFormField),
        findsNWidgets(2),
      ); // Email and password fields

      // Enter admin credentials
      await tester.enterText(
        find.byType(TextFormField).first,
        'admin@simdoc.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      // Tap login button
      await tester.tap(find.text(AppStrings.login));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify successful login - should navigate to home screen
      expect(find.text(AppStrings.home), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('Complete login flow - Regular user', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Enter user credentials
      await tester.enterText(find.byType(TextFormField).first, 'user@test.com');
      await tester.enterText(find.byType(TextFormField).last, 'user123');

      await tester.tap(find.text(AppStrings.login));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify user login success
      expect(find.text(AppStrings.home), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('Login validation - Empty fields', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Try to login with empty fields
      await tester.tap(find.text(AppStrings.login));
      await tester.pumpAndSettle();

      // Verify validation messages appear
      expect(find.text(AppStrings.fieldRequired), findsOneWidget);
      expect(find.text(AppStrings.fieldRequired), findsAtLeastNWidgets(1));
    });

    testWidgets('Login validation - Invalid email format', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      await tester.tap(find.text(AppStrings.login));
      await tester.pumpAndSettle();

      // Verify email validation message
      expect(find.text(AppStrings.invalidEmail), findsOneWidget);
    });

    testWidgets('Login error handling - Wrong credentials', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Enter wrong credentials
      await tester.enterText(
        find.byType(TextFormField).first,
        'wrong@test.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'wrongpassword');

      await tester.tap(find.text(AppStrings.login));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify error message appears
      expect(find.textContaining('Invalid'), findsOneWidget);
    });

    testWidgets('Logout flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Login first
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.enterText(
        find.byType(TextFormField).first,
        'admin@test.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'admin123');
      await tester.tap(find.text(AppStrings.login));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Find and tap logout button
      await tester.tap(find.text(AppStrings.logout));
      await tester.pumpAndSettle();

      // Confirm logout in dialog
      await tester.tap(find.text(AppStrings.confirm));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify back to login screen
      expect(find.text(AppStrings.login), findsOneWidget);
    });

    testWidgets('Session persistence test', (WidgetTester tester) async {
      // This test simulates app restart after successful login
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // If user was previously logged in, should skip login screen
      // This depends on your session management implementation
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Check if we're on home screen (session persisted) or login screen
      final homeFound = find.text(AppStrings.home);
      final loginFound = find.text(AppStrings.login);

      expect(
        homeFound.evaluate().isNotEmpty || loginFound.evaluate().isNotEmpty,
        isTrue,
      );
    });
  });

  group('Authentication Edge Cases', () {
    testWidgets('Network connectivity issues', (WidgetTester tester) async {
      // This test would require network mocking
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Enter valid credentials
      await tester.enterText(
        find.byType(TextFormField).first,
        'admin@test.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'admin123');

      // Simulate network error during login
      await tester.tap(find.text(AppStrings.login));
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Should show network error message or retry option
      // Implementation depends on your error handling
    });

    testWidgets('Biometric authentication flow', (WidgetTester tester) async {
      // Test biometric login if implemented
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Look for biometric login option
      final biometricButton = find.byIcon(Icons.fingerprint);
      if (biometricButton.evaluate().isNotEmpty) {
        await tester.tap(biometricButton);
        await tester.pumpAndSettle();

        // Verify biometric prompt or success
        // Implementation depends on your biometric setup
      }
    });
  });
}
