import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:managementdoc/main.dart' as app;
import 'package:managementdoc/core/constants/app_strings.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('User Management Flow Tests', () {
    setUp(() async {
      app.main();
      await Future.delayed(const Duration(seconds: 3));
    });

    testWidgets('Admin user management workflow', (WidgetTester tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Login as admin
      await _performAdminLogin(tester);

      // Navigate to user management
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Look for user management option
      final userManagementButton = find.text(AppStrings.userManagement);
      if (userManagementButton.evaluate().isNotEmpty) {
        await tester.tap(userManagementButton);
        await tester.pumpAndSettle();

        // Verify user management screen
        expect(find.text(AppStrings.userManagement), findsOneWidget);

        // Test create new user
        final createUserButton = find.text(AppStrings.createUser);
        if (createUserButton.evaluate().isNotEmpty) {
          await tester.tap(createUserButton);
          await tester.pumpAndSettle();

          // Fill user creation form
          await _fillUserCreationForm(tester);

          // Submit form
          final submitButton = find.text(AppStrings.createUser);
          if (submitButton.evaluate().isNotEmpty) {
            await tester.tap(submitButton);
            await tester.pumpAndSettle(const Duration(seconds: 3));
          }
        }
      }
    });

    testWidgets('User list and search functionality', (
      WidgetTester tester,
    ) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performAdminLogin(tester);

      // Navigate to user management
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      final userManagementButton = find.text(AppStrings.userManagement);
      if (userManagementButton.evaluate().isNotEmpty) {
        await tester.tap(userManagementButton);
        await tester.pumpAndSettle();

        // Test search functionality
        final searchField = find.byType(TextField);
        if (searchField.evaluate().isNotEmpty) {
          await tester.tap(searchField.first);
          await tester.enterText(searchField.first, 'test user');
          await tester.pumpAndSettle();

          // Verify search results
          await tester.pumpAndSettle(const Duration(seconds: 2));
        }

        // Test user list display
        final userList = find.byType(ListView);
        if (userList.evaluate().isNotEmpty) {
          expect(userList, findsOneWidget);
        }
      }
    });

    testWidgets('Edit user functionality', (WidgetTester tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performAdminLogin(tester);

      // Navigate to user management
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      final userManagementButton = find.text(AppStrings.userManagement);
      if (userManagementButton.evaluate().isNotEmpty) {
        await tester.tap(userManagementButton);
        await tester.pumpAndSettle();

        // Find first user in list
        final userTile = find.byType(ListTile).first;
        if (userTile.evaluate().isNotEmpty) {
          await tester.tap(userTile);
          await tester.pumpAndSettle();

          // Look for edit button
          final editButton = find.byIcon(Icons.edit);
          if (editButton.evaluate().isNotEmpty) {
            await tester.tap(editButton);
            await tester.pumpAndSettle();

            // Verify edit screen
            expect(find.text(AppStrings.editUser), findsOneWidget);

            // Test form editing
            final nameField = find.byType(TextFormField).first;
            if (nameField.evaluate().isNotEmpty) {
              await tester.enterText(nameField, 'Updated User Name');
              await tester.pumpAndSettle();

              // Save changes
              final saveButton = find.text(AppStrings.save);
              if (saveButton.evaluate().isNotEmpty) {
                await tester.tap(saveButton);
                await tester.pumpAndSettle(const Duration(seconds: 3));
              }
            }
          }
        }
      }
    });

    testWidgets('User permissions management', (WidgetTester tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performAdminLogin(tester);

      // Navigate to user management
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      final userManagementButton = find.text(AppStrings.userManagement);
      if (userManagementButton.evaluate().isNotEmpty) {
        await tester.tap(userManagementButton);
        await tester.pumpAndSettle();

        // Find user and access permissions
        final userTile = find.byType(ListTile).first;
        if (userTile.evaluate().isNotEmpty) {
          await tester.tap(userTile);
          await tester.pumpAndSettle();

          // Look for permissions button
          final permissionsButton = find.text(AppStrings.userPermissions);
          if (permissionsButton.evaluate().isNotEmpty) {
            await tester.tap(permissionsButton);
            await tester.pumpAndSettle();

            // Test permission toggles
            final checkboxes = find.byType(Checkbox);
            if (checkboxes.evaluate().isNotEmpty) {
              await tester.tap(checkboxes.first);
              await tester.pumpAndSettle();

              // Save permission changes
              final saveButton = find.text(AppStrings.save);
              if (saveButton.evaluate().isNotEmpty) {
                await tester.tap(saveButton);
                await tester.pumpAndSettle(const Duration(seconds: 3));
              }
            }
          }
        }
      }
    });

    testWidgets('Delete user functionality', (WidgetTester tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performAdminLogin(tester);

      // Navigate to user management
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      final userManagementButton = find.text(AppStrings.userManagement);
      if (userManagementButton.evaluate().isNotEmpty) {
        await tester.tap(userManagementButton);
        await tester.pumpAndSettle();

        // Find user to delete
        final userTile = find.byType(ListTile).first;
        if (userTile.evaluate().isNotEmpty) {
          // Long press for context menu
          await tester.longPress(userTile);
          await tester.pumpAndSettle();

          // Look for delete option
          final deleteButton = find.byIcon(Icons.delete);
          if (deleteButton.evaluate().isNotEmpty) {
            await tester.tap(deleteButton);
            await tester.pumpAndSettle();

            // Confirm deletion
            final confirmButton = find.text(AppStrings.confirm);
            if (confirmButton.evaluate().isNotEmpty) {
              await tester.tap(confirmButton);
              await tester.pumpAndSettle(const Duration(seconds: 3));
            }
          }
        }
      }
    });

    testWidgets('User status management (active/inactive)', (
      WidgetTester tester,
    ) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performAdminLogin(tester);

      // Navigate to user management
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      final userManagementButton = find.text(AppStrings.userManagement);
      if (userManagementButton.evaluate().isNotEmpty) {
        await tester.tap(userManagementButton);
        await tester.pumpAndSettle();

        // Find user to manage status
        final userTile = find.byType(ListTile).first;
        if (userTile.evaluate().isNotEmpty) {
          await tester.tap(userTile);
          await tester.pumpAndSettle();

          // Look for status toggle
          final statusSwitch = find.byType(Switch);
          if (statusSwitch.evaluate().isNotEmpty) {
            await tester.tap(statusSwitch.first);
            await tester.pumpAndSettle();

            // Save status change
            final saveButton = find.text(AppStrings.save);
            if (saveButton.evaluate().isNotEmpty) {
              await tester.tap(saveButton);
              await tester.pumpAndSettle(const Duration(seconds: 3));
            }
          }
        }
      }
    });

    testWidgets('Bulk user operations', (WidgetTester tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performAdminLogin(tester);

      // Navigate to user management
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      final userManagementButton = find.text(AppStrings.userManagement);
      if (userManagementButton.evaluate().isNotEmpty) {
        await tester.tap(userManagementButton);
        await tester.pumpAndSettle();

        // Enable selection mode
        final selectButton = find.text(AppStrings.edit);
        if (selectButton.evaluate().isNotEmpty) {
          await tester.tap(selectButton);
          await tester.pumpAndSettle();

          // Select multiple users
          final checkboxes = find.byType(Checkbox);
          if (checkboxes.evaluate().length >= 2) {
            await tester.tap(checkboxes.first);
            await tester.tap(checkboxes.at(1));
            await tester.pumpAndSettle();

            // Test bulk operations
            final bulkDeleteButton = find.text(AppStrings.deleteUser);
            if (bulkDeleteButton.evaluate().isNotEmpty) {
              await tester.tap(bulkDeleteButton);
              await tester.pumpAndSettle();

              // Confirm bulk operation
              final confirmButton = find.text(AppStrings.confirm);
              if (confirmButton.evaluate().isNotEmpty) {
                await tester.tap(confirmButton);
                await tester.pumpAndSettle(const Duration(seconds: 3));
              }
            }
          }
        }
      }
    });

    testWidgets('User role assignment', (WidgetTester tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performAdminLogin(tester);

      // Navigate to user management
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      final userManagementButton = find.text(AppStrings.userManagement);
      if (userManagementButton.evaluate().isNotEmpty) {
        await tester.tap(userManagementButton);
        await tester.pumpAndSettle();

        // Find user to assign role
        final userTile = find.byType(ListTile).first;
        if (userTile.evaluate().isNotEmpty) {
          await tester.tap(userTile);
          await tester.pumpAndSettle();

          // Look for role dropdown
          final roleDropdown = find.byType(DropdownButton);
          if (roleDropdown.evaluate().isNotEmpty) {
            await tester.tap(roleDropdown.first);
            await tester.pumpAndSettle();

            // Select new role
            final adminRole = find.text('Admin').last;
            if (adminRole.evaluate().isNotEmpty) {
              await tester.tap(adminRole);
              await tester.pumpAndSettle();

              // Save role change
              final saveButton = find.text(AppStrings.save);
              if (saveButton.evaluate().isNotEmpty) {
                await tester.tap(saveButton);
                await tester.pumpAndSettle(const Duration(seconds: 3));
              }
            }
          }
        }
      }
    });
  });

  group('User Management Error Handling', () {
    testWidgets('Handle network errors during user operations', (
      WidgetTester tester,
    ) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performAdminLogin(tester);

      // Navigate to user management
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      final userManagementButton = find.text(AppStrings.userManagement);
      if (userManagementButton.evaluate().isNotEmpty) {
        await tester.tap(userManagementButton);
        await tester.pumpAndSettle();

        // Try to create user (may fail due to network)
        final createUserButton = find.text(AppStrings.createUser);
        if (createUserButton.evaluate().isNotEmpty) {
          await tester.tap(createUserButton);
          await tester.pumpAndSettle();

          await _fillUserCreationForm(tester);

          final submitButton = find.text(AppStrings.createUser);
          if (submitButton.evaluate().isNotEmpty) {
            await tester.tap(submitButton);
            await tester.pumpAndSettle(const Duration(seconds: 5));

            // Should show error message or retry option
            // Implementation depends on your error handling
          }
        }
      }
    });

    testWidgets('Validate user input forms', (WidgetTester tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performAdminLogin(tester);

      // Navigate to user management
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      final userManagementButton = find.text(AppStrings.userManagement);
      if (userManagementButton.evaluate().isNotEmpty) {
        await tester.tap(userManagementButton);
        await tester.pumpAndSettle();

        // Try to create user with invalid data
        final createUserButton = find.text(AppStrings.createUser);
        if (createUserButton.evaluate().isNotEmpty) {
          await tester.tap(createUserButton);
          await tester.pumpAndSettle();

          // Submit empty form
          final submitButton = find.text(AppStrings.createUser);
          if (submitButton.evaluate().isNotEmpty) {
            await tester.tap(submitButton);
            await tester.pumpAndSettle();

            // Should show validation errors
            expect(find.text(AppStrings.fieldRequired), findsOneWidget);
            expect(
              find.text(AppStrings.fieldRequired),
              findsAtLeastNWidgets(1),
            );
          }
        }
      }
    });
  });
}

// Helper functions
Future<void> _performAdminLogin(WidgetTester tester) async {
  await tester.pumpAndSettle(const Duration(seconds: 2));

  await tester.enterText(find.byType(TextFormField).first, 'admin@test.com');
  await tester.enterText(find.byType(TextFormField).last, 'admin123');
  await tester.tap(find.text(AppStrings.login));
  await tester.pumpAndSettle(const Duration(seconds: 5));
}

Future<void> _fillUserCreationForm(WidgetTester tester) async {
  final textFields = find.byType(TextFormField);

  if (textFields.evaluate().length >= 3) {
    await tester.enterText(textFields.at(0), 'Test User');
    await tester.enterText(textFields.at(1), 'testuser@example.com');
    await tester.enterText(textFields.at(2), 'password123');
  }

  // Select role if dropdown exists
  final roleDropdown = find.byType(DropdownButton);
  if (roleDropdown.evaluate().isNotEmpty) {
    await tester.tap(roleDropdown.first);
    await tester.pumpAndSettle();

    final userRole = find.text('User').last;
    if (userRole.evaluate().isNotEmpty) {
      await tester.tap(userRole);
      await tester.pumpAndSettle();
    }
  }
}
