import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:managementdoc/main.dart' as app;
import '../helpers/test_helpers.dart';

class AuthFlowTest {
  /// Run complete authentication flow test
  static Future<void> runCompleteAuthFlow(WidgetTester tester) async {
    // Launch app
    await TestHelpers.verifyAppLaunched(tester);
    await TestHelpers.takeScreenshot(tester, 'auth_flow_start');

    // Wait for splash screen to complete
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Should navigate to login screen
    await TestHelpers.waitForText(tester, 'Login');
    await TestHelpers.takeScreenshot(tester, 'login_screen');

    // Test login form validation
    await _testLoginFormValidation(tester);

    // Perform successful login
    await _performSuccessfulLogin(tester);

    // Verify home screen
    await _verifyHomeScreen(tester);

    await TestHelpers.takeScreenshot(tester, 'auth_flow_complete');
  }

  /// Run invalid login flow test
  static Future<void> runInvalidLoginFlow(WidgetTester tester) async {
    await TestHelpers.verifyAppLaunched(tester);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Navigate to login screen
    await TestHelpers.waitForText(tester, 'Login');

    // Test with empty credentials
    await _testEmptyCredentials(tester);

    // Test with invalid email format
    await _testInvalidEmailFormat(tester);

    // Test with wrong credentials
    await _testWrongCredentials(tester);

    await TestHelpers.takeScreenshot(tester, 'invalid_login_complete');
  }

  /// Run logout flow test
  static Future<void> runLogoutFlow(WidgetTester tester) async {
    // First login
    await runCompleteAuthFlow(tester);

    // Navigate to profile screen
    await _navigateToProfile(tester);

    // Perform logout
    await _performLogout(tester);

    // Verify return to login screen
    await TestHelpers.waitForText(tester, 'Login');
    await TestHelpers.takeScreenshot(tester, 'logout_complete');
  }

  /// Test login form validation
  static Future<void> _testLoginFormValidation(WidgetTester tester) async {
    // Find email and password fields
    final emailField = find.byKey(const Key('email_field'));
    final loginButton = find.byKey(const Key('login_button'));

    // If keys are not available, use type-based finders
    final loginButtonFallback = find.text('Login');

    // Test empty form submission
    await TestHelpers.tapAndWait(
      tester,
      emailField.evaluate().isNotEmpty ? loginButton : loginButtonFallback,
    );

    // Should show validation errors
    final hasRequiredError = find
        .textContaining('required')
        .evaluate()
        .isNotEmpty;
    final hasEmptyError = find.textContaining('empty').evaluate().isNotEmpty;
    expect(hasRequiredError || hasEmptyError, isTrue);

    await TestHelpers.takeScreenshot(tester, 'validation_errors');
  }

  /// Test empty credentials
  static Future<void> _testEmptyCredentials(WidgetTester tester) async {
    final loginButton = find.text('Login');

    // Tap login with empty fields
    await TestHelpers.tapAndWait(tester, loginButton);

    // Should show validation message
    await TestHelpers.waitForText(tester, 'Please enter email');
  }

  /// Test invalid email format
  static Future<void> _testInvalidEmailFormat(WidgetTester tester) async {
    final emailField = find.byType(TextField).first;
    final loginButton = find.text('Login');

    // Enter invalid email
    await TestHelpers.enterText(tester, emailField, 'invalid-email');
    await TestHelpers.tapAndWait(tester, loginButton);

    // Should show email format error
    final hasValidEmailError = find
        .textContaining('valid email')
        .evaluate()
        .isNotEmpty;
    final hasEmailFormatError = find
        .textContaining('email format')
        .evaluate()
        .isNotEmpty;
    expect(hasValidEmailError || hasEmailFormatError, isTrue);
  }

  /// Test wrong credentials
  static Future<void> _testWrongCredentials(WidgetTester tester) async {
    final emailField = find.byType(TextField).first;
    final passwordField = find.byType(TextField).last;
    final loginButton = find.text('Login');

    // Clear fields first
    await tester.tap(emailField);
    await tester.pumpAndSettle();
    await tester.enterText(emailField, '');
    await tester.pumpAndSettle();

    // Enter wrong credentials
    await TestHelpers.enterText(tester, emailField, 'wrong@example.com');
    await TestHelpers.enterText(tester, passwordField, 'wrongpassword');
    await TestHelpers.tapAndWait(tester, loginButton);

    // Should show authentication error
    await TestHelpers.waitForText(tester, 'Invalid credentials');
  }

  /// Perform successful login
  static Future<void> _performSuccessfulLogin(WidgetTester tester) async {
    final emailField = find.byType(TextField).first;
    final passwordField = find.byType(TextField).last;
    final loginButton = find.text('Login');

    // Clear fields first
    await tester.tap(emailField);
    await tester.pumpAndSettle();
    await tester.enterText(emailField, '');
    await tester.pumpAndSettle();

    await tester.tap(passwordField);
    await tester.pumpAndSettle();
    await tester.enterText(passwordField, '');
    await tester.pumpAndSettle();

    // Enter valid credentials
    await TestHelpers.enterText(tester, emailField, TestHelpers.testEmail);
    await TestHelpers.enterText(
      tester,
      passwordField,
      TestHelpers.testPassword,
    );

    // Tap login button
    await TestHelpers.tapAndWait(tester, loginButton);

    // Wait for loading to complete
    await TestHelpers.waitForLoadingToComplete(tester);
  }

  /// Verify home screen after login
  static Future<void> _verifyHomeScreen(WidgetTester tester) async {
    // Wait for home screen elements
    await TestHelpers.waitForText(tester, 'Home');

    // Verify bottom navigation
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Verify main content areas
    expect(find.text('Documents'), findsAtLeastNWidgets(1));
    expect(find.text('Categories'), findsAtLeastNWidgets(1));

    // Verify user is logged in (check for profile/logout option)
    expect(find.byIcon(Icons.person), findsAtLeastNWidgets(1));
  }

  /// Navigate to profile screen
  static Future<void> _navigateToProfile(WidgetTester tester) async {
    // Tap on profile tab in bottom navigation
    final profileTab = find.byIcon(Icons.person);
    if (profileTab.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, profileTab);
    } else {
      // Alternative: look for profile text
      await TestHelpers.tapAndWait(tester, find.text('Profile'));
    }

    // Wait for profile screen
    await TestHelpers.waitForText(tester, 'Profile');
    await TestHelpers.takeScreenshot(tester, 'profile_screen');
  }

  /// Perform logout
  static Future<void> _performLogout(WidgetTester tester) async {
    // Look for logout button or menu
    final logoutButton = find.text('Logout');
    final settingsButton = find.text('Settings');

    if (logoutButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, logoutButton);
    } else if (settingsButton.evaluate().isNotEmpty) {
      // Navigate to settings first
      await TestHelpers.tapAndWait(tester, settingsButton);
      await TestHelpers.waitForText(tester, 'Logout');
      await TestHelpers.tapAndWait(tester, find.text('Logout'));
    } else {
      // Look for menu icon
      final menuIcon = find.byIcon(Icons.menu);
      if (menuIcon.evaluate().isNotEmpty) {
        await TestHelpers.tapAndWait(tester, menuIcon);
        await TestHelpers.waitForText(tester, 'Logout');
        await TestHelpers.tapAndWait(tester, find.text('Logout'));
      }
    }

    // Handle confirmation dialog if present
    if (find.text('Confirm').evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, find.text('Confirm'));
    } else if (find.text('Yes').evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, find.text('Yes'));
    }

    // Wait for logout to complete
    await tester.pumpAndSettle();
  }

  /// Test password reset flow
  static Future<void> testPasswordResetFlow(WidgetTester tester) async {
    await TestHelpers.verifyAppLaunched(tester);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Navigate to login screen
    await TestHelpers.waitForText(tester, 'Login');

    // Look for forgot password link
    final forgotPasswordLink = find.text('Forgot Password?');
    if (forgotPasswordLink.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, forgotPasswordLink);

      // Enter email for password reset
      final emailField = find.byType(TextField).first;
      await TestHelpers.enterText(tester, emailField, TestHelpers.testEmail);

      // Tap reset button
      await TestHelpers.tapAndWait(tester, find.text('Reset Password'));

      // Verify success message
      await TestHelpers.waitForText(tester, 'Password reset email sent');
    }

    await TestHelpers.takeScreenshot(tester, 'password_reset_complete');
  }

  /// Test session persistence
  static Future<void> testSessionPersistence(WidgetTester tester) async {
    // Login first
    await runCompleteAuthFlow(tester);

    // Restart app (simulate app restart)
    await tester.binding.reassembleApplication();
    app.main();
    await tester.pumpAndSettle();

    // Should remain logged in
    await TestHelpers.waitForText(tester, 'Home');
    expect(find.text('Login'), findsNothing);

    await TestHelpers.takeScreenshot(tester, 'session_persistence_verified');
  }
}
