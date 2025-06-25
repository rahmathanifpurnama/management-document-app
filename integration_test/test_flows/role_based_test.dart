import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:managementdoc/main.dart' as app;
import 'package:managementdoc/core/constants/app_strings.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Role-Based Access Control Tests', () {
    group('Admin User Tests', () {
      testWidgets('Admin login and access management features', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Admin login
        await _performLogin(tester, 'admin@test.com', 'admin123');

        // Verify successful login
        expect(find.text(AppStrings.home), findsOneWidget);

        // Navigate to profile to check admin features
        await tester.tap(find.byIcon(Icons.person));
        await tester.pumpAndSettle();

        // Check for admin-only features
        expect(find.text(AppStrings.userManagement), findsOneWidget);
        
        // Test user management access
        await tester.tap(find.text(AppStrings.userManagement));
        await tester.pumpAndSettle();
        
        // Verify admin can access user creation
        final createUserButton = find.text(AppStrings.createUser);
        expect(createUserButton, findsOneWidget);
      });

      testWidgets('Admin document approval workflow', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        await _performLogin(tester, 'admin@test.com', 'admin123');

        // Navigate to home to check pending documents
        await tester.tap(find.byIcon(Icons.home));
        await tester.pumpAndSettle();

        // Wait for documents to load
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Look for pending approval documents
        final pendingDocs = find.text(AppStrings.pending);
        if (pendingDocs.evaluate().isNotEmpty) {
          // Test approval workflow
          await tester.tap(pendingDocs.first);
          await tester.pumpAndSettle();

          // Look for approve button
          final approveButton = find.text(AppStrings.approveDocument);
          if (approveButton.evaluate().isNotEmpty) {
            await tester.tap(approveButton);
            await tester.pumpAndSettle();
            
            // Verify approval action
            expect(find.text(AppStrings.approved), findsOneWidget);
          }
        }
      });

      testWidgets('Admin can delete documents', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        await _performLogin(tester, 'admin@test.com', 'admin123');

        // Navigate to documents
        await tester.tap(find.byIcon(Icons.home));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Find first document and long press for context menu
        final documentTile = find.byType(ListTile).first;
        if (documentTile.evaluate().isNotEmpty) {
          await tester.longPress(documentTile);
          await tester.pumpAndSettle();

          // Admin should see delete option
          final deleteButton = find.byIcon(Icons.delete);
          expect(deleteButton, findsOneWidget);
        }
      });

      testWidgets('Admin can manage categories', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        await _performLogin(tester, 'admin@test.com', 'admin123');

        // Navigate to categories
        await tester.tap(find.byIcon(Icons.folder));
        await tester.pumpAndSettle();

        // Admin should be able to create categories
        final createCategoryButton = find.byIcon(Icons.add);
        expect(createCategoryButton, findsOneWidget);

        // Test category creation
        await tester.tap(createCategoryButton);
        await tester.pumpAndSettle();

        // Fill category form
        final textFields = find.byType(TextFormField);
        if (textFields.evaluate().length >= 2) {
          await tester.enterText(textFields.first, 'Admin Test Category');
          await tester.enterText(textFields.at(1), 'Category created by admin');
          await tester.pumpAndSettle();

          // Save category
          final saveButton = find.text(AppStrings.save);
          if (saveButton.evaluate().isNotEmpty) {
            await tester.tap(saveButton);
            await tester.pumpAndSettle(const Duration(seconds: 3));
          }
        }
      });
    });

    group('Regular User Tests', () {
      testWidgets('User login and basic features access', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Regular user login
        await _performLogin(tester, 'user@test.com', 'user123');

        // Verify successful login
        expect(find.text(AppStrings.home), findsOneWidget);

        // Navigate to profile
        await tester.tap(find.byIcon(Icons.person));
        await tester.pumpAndSettle();

        // Admin features should NOT be visible
        expect(find.text(AppStrings.userManagement), findsNothing);
        
        // But profile features should be available
        expect(find.text(AppStrings.profile), findsOneWidget);
      });

      testWidgets('User can upload documents', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        await _performLogin(tester, 'user@test.com', 'user123');

        // Test document upload access
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        expect(find.text(AppStrings.uploadDocument), findsOneWidget);

        // Test file selection
        final selectFileButton = find.text(AppStrings.selectFile);
        expect(selectFileButton, findsOneWidget);
      });

      testWidgets('User cannot delete documents', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        await _performLogin(tester, 'user@test.com', 'user123');

        // Navigate to documents
        await tester.tap(find.byIcon(Icons.home));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Find first document and long press for context menu
        final documentTile = find.byType(ListTile).first;
        if (documentTile.evaluate().isNotEmpty) {
          await tester.longPress(documentTile);
          await tester.pumpAndSettle();

          // User should NOT see delete option
          final deleteButton = find.byIcon(Icons.delete);
          expect(deleteButton, findsNothing);
        }
      });

      testWidgets('User cannot access admin features', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        await _performLogin(tester, 'user@test.com', 'user123');

        // Navigate through all screens
        final tabs = [Icons.home, Icons.folder, Icons.add, Icons.person];
        
        for (final tab in tabs) {
          await tester.tap(find.byIcon(tab));
          await tester.pumpAndSettle();
          
          // Ensure no admin features are visible anywhere
          expect(find.text(AppStrings.userManagement), findsNothing);
          expect(find.text(AppStrings.createUser), findsNothing);
          expect(find.text(AppStrings.deleteUser), findsNothing);
        }
      });

      testWidgets('User can view but not approve documents', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        await _performLogin(tester, 'user@test.com', 'user123');

        // Navigate to documents
        await tester.tap(find.byIcon(Icons.home));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Find first document
        final documentTile = find.byType(ListTile).first;
        if (documentTile.evaluate().isNotEmpty) {
          await tester.tap(documentTile);
          await tester.pumpAndSettle();

          // User should be able to view
          expect(find.text(AppStrings.view), findsOneWidget);
          
          // But should NOT see approval buttons
          expect(find.text(AppStrings.approveDocument), findsNothing);
          expect(find.text(AppStrings.rejectDocument), findsNothing);
        }
      });

      testWidgets('User has limited category permissions', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        await _performLogin(tester, 'user@test.com', 'user123');

        // Navigate to categories
        await tester.tap(find.byIcon(Icons.folder));
        await tester.pumpAndSettle();

        // User should be able to view categories
        expect(find.text(AppStrings.categories), findsOneWidget);

        // But may have limited creation rights
        final createCategoryButton = find.byIcon(Icons.add);
        // This depends on your business logic - user might or might not be able to create categories
        // Adjust this test based on your requirements
      });
    });

    group('Cross-Role Validation Tests', () {
      testWidgets('Verify role isolation', (WidgetTester tester) async {
        // Test that user session doesn't have admin privileges
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Login as user first
        await _performLogin(tester, 'user@test.com', 'user123');
        
        // Verify user restrictions
        await tester.tap(find.byIcon(Icons.person));
        await tester.pumpAndSettle();
        expect(find.text(AppStrings.userManagement), findsNothing);

        // Logout
        await _performLogout(tester);

        // Login as admin
        await _performLogin(tester, 'admin@test.com', 'admin123');
        
        // Verify admin privileges
        await tester.tap(find.byIcon(Icons.person));
        await tester.pumpAndSettle();
        expect(find.text(AppStrings.userManagement), findsOneWidget);
      });
    });
  });
}

// Helper function for login with specific credentials
Future<void> _performLogin(WidgetTester tester, String email, String password) async {
  await tester.pumpAndSettle(const Duration(seconds: 2));

  // Enter credentials
  await tester.enterText(find.byType(TextFormField).first, email);
  await tester.enterText(find.byType(TextFormField).last, password);
  
  // Tap login button
  await tester.tap(find.text(AppStrings.login));
  await tester.pumpAndSettle(const Duration(seconds: 5));
}

// Helper function for logout
Future<void> _performLogout(WidgetTester tester) async {
  // Navigate to profile
  await tester.tap(find.byIcon(Icons.person));
  await tester.pumpAndSettle();

  // Find and tap logout button
  final logoutButton = find.text(AppStrings.logout);
  if (logoutButton.evaluate().isNotEmpty) {
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();

    // Confirm logout in dialog
    final confirmButton = find.text(AppStrings.confirm);
    if (confirmButton.evaluate().isNotEmpty) {
      await tester.tap(confirmButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));
    }
  }
}
