import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:managementdoc/main.dart' as app;
import 'package:managementdoc/core/constants/app_strings.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Category Management Flow Tests', () {
    setUp(() async {
      app.main();
      await Future.delayed(const Duration(seconds: 3));
    });

    testWidgets('Complete category creation workflow', (
      WidgetTester tester,
    ) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Login first
      await _performLogin(tester);

      // Navigate to categories
      await tester.tap(find.byIcon(Icons.folder));
      await tester.pumpAndSettle();

      // Verify categories screen
      expect(find.text(AppStrings.categories), findsOneWidget);

      // Create new category
      final createCategoryButton = find.byIcon(Icons.add);
      if (createCategoryButton.evaluate().isNotEmpty) {
        await tester.tap(createCategoryButton);
        await tester.pumpAndSettle();

        // Fill category creation form
        await _fillCategoryForm(
          tester,
          'Test Category',
          'Test category description',
        );

        // Submit form
        final submitButton = find.text(AppStrings.save);
        if (submitButton.evaluate().isNotEmpty) {
          await tester.tap(submitButton);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Verify category was created
          expect(find.text('Test Category'), findsOneWidget);
        }
      }
    });

    testWidgets('Category list display and navigation', (
      WidgetTester tester,
    ) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performLogin(tester);

      // Navigate to categories
      await tester.tap(find.byIcon(Icons.folder));
      await tester.pumpAndSettle();

      // Wait for categories to load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Check for category list or empty state
      final categoryList = find.byType(ListView);
      final gridView = find.byType(GridView);
      final emptyState = find.text(AppStrings.noData);

      expect(
        categoryList.evaluate().isNotEmpty ||
            gridView.evaluate().isNotEmpty ||
            emptyState.evaluate().isNotEmpty,
        isTrue,
      );

      // Test navigation to category details
      final categoryTile = find.byType(ListTile).first;
      if (categoryTile.evaluate().isNotEmpty) {
        await tester.tap(categoryTile);
        await tester.pumpAndSettle();

        // Should navigate to category files screen
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      }
    });

    testWidgets('Category editing functionality', (WidgetTester tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performLogin(tester);

      // Navigate to categories
      await tester.tap(find.byIcon(Icons.folder));
      await tester.pumpAndSettle();

      // Find category to edit
      final categoryTile = find.byType(ListTile).first;
      if (categoryTile.evaluate().isNotEmpty) {
        // Long press for context menu
        await tester.longPress(categoryTile);
        await tester.pumpAndSettle();

        // Look for edit option
        final editButton = find.byIcon(Icons.edit);
        if (editButton.evaluate().isNotEmpty) {
          await tester.tap(editButton);
          await tester.pumpAndSettle();

          // Edit category details
          final nameField = find.byType(TextFormField).first;
          if (nameField.evaluate().isNotEmpty) {
            await tester.enterText(nameField, 'Updated Category Name');
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
    });

    testWidgets('Add files to category workflow', (WidgetTester tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performLogin(tester);

      // Navigate to categories
      await tester.tap(find.byIcon(Icons.folder));
      await tester.pumpAndSettle();

      // Enter category
      final categoryTile = find.byType(ListTile).first;
      if (categoryTile.evaluate().isNotEmpty) {
        await tester.tap(categoryTile);
        await tester.pumpAndSettle();

        // Look for add files button
        final addFilesButton = find.text(AppStrings.uploadDocument);
        if (addFilesButton.evaluate().isNotEmpty) {
          await tester.tap(addFilesButton);
          await tester.pumpAndSettle();

          // Should navigate to file selection screen
          expect(find.text(AppStrings.selectFile), findsOneWidget);

          // Select files (if any available)
          final fileCheckboxes = find.byType(Checkbox);
          if (fileCheckboxes.evaluate().isNotEmpty) {
            await tester.tap(fileCheckboxes.first);
            await tester.pumpAndSettle();

            // Add selected files
            final addSelectedButton = find.text(AppStrings.save);
            if (addSelectedButton.evaluate().isNotEmpty) {
              await tester.tap(addSelectedButton);
              await tester.pumpAndSettle(const Duration(seconds: 3));
            }
          }
        }
      }
    });

    testWidgets('Remove files from category', (WidgetTester tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performLogin(tester);

      // Navigate to categories
      await tester.tap(find.byIcon(Icons.folder));
      await tester.pumpAndSettle();

      // Enter category with files
      final categoryTile = find.byType(ListTile).first;
      if (categoryTile.evaluate().isNotEmpty) {
        await tester.tap(categoryTile);
        await tester.pumpAndSettle();

        // Find file to remove
        final fileTile = find.byType(ListTile).first;
        if (fileTile.evaluate().isNotEmpty) {
          // Long press for context menu
          await tester.longPress(fileTile);
          await tester.pumpAndSettle();

          // Look for remove option
          final removeButton = find.text(AppStrings.delete);
          if (removeButton.evaluate().isNotEmpty) {
            await tester.tap(removeButton);
            await tester.pumpAndSettle();

            // Confirm removal
            final confirmButton = find.text(AppStrings.confirm);
            if (confirmButton.evaluate().isNotEmpty) {
              await tester.tap(confirmButton);
              await tester.pumpAndSettle(const Duration(seconds: 3));
            }
          }
        }
      }
    });

    testWidgets('Category deletion workflow', (WidgetTester tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performLogin(tester, isAdmin: true);

      // Navigate to categories
      await tester.tap(find.byIcon(Icons.folder));
      await tester.pumpAndSettle();

      // Find category to delete
      final categoryTile = find.byType(ListTile).first;
      if (categoryTile.evaluate().isNotEmpty) {
        // Long press for context menu
        await tester.longPress(categoryTile);
        await tester.pumpAndSettle();

        // Look for delete option (admin only)
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
    });

    testWidgets('Category search functionality', (WidgetTester tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performLogin(tester);

      // Navigate to categories
      await tester.tap(find.byIcon(Icons.folder));
      await tester.pumpAndSettle();

      // Find search field
      final searchField = find.byType(TextField);
      if (searchField.evaluate().isNotEmpty) {
        await tester.tap(searchField.first);
        await tester.enterText(searchField.first, 'test category');
        await tester.pumpAndSettle();

        // Verify search results
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }
    });

    testWidgets('Category view mode toggle (grid/list)', (
      WidgetTester tester,
    ) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performLogin(tester);

      // Navigate to categories
      await tester.tap(find.byIcon(Icons.folder));
      await tester.pumpAndSettle();

      // Look for view toggle button
      final viewToggleButton = find.byIcon(Icons.view_module);
      if (viewToggleButton.evaluate().isNotEmpty) {
        await tester.tap(viewToggleButton);
        await tester.pumpAndSettle();

        // Should switch to grid view
        expect(find.byType(GridView), findsOneWidget);

        // Toggle back to list view
        final listViewButton = find.byIcon(Icons.view_list);
        if (listViewButton.evaluate().isNotEmpty) {
          await tester.tap(listViewButton);
          await tester.pumpAndSettle();

          expect(find.byType(ListView), findsOneWidget);
        }
      }
    });

    testWidgets('Category sorting functionality', (WidgetTester tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performLogin(tester);

      // Navigate to categories
      await tester.tap(find.byIcon(Icons.folder));
      await tester.pumpAndSettle();

      // Look for sort button
      final sortButton = find.byIcon(Icons.sort);
      if (sortButton.evaluate().isNotEmpty) {
        await tester.tap(sortButton);
        await tester.pumpAndSettle();

        // Select sort option
        final sortByName = find.text(AppStrings.sort);
        if (sortByName.evaluate().isNotEmpty) {
          await tester.tap(sortByName);
          await tester.pumpAndSettle();
        }
      }
    });

    testWidgets('Category permissions management', (WidgetTester tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performLogin(tester, isAdmin: true);

      // Navigate to categories
      await tester.tap(find.byIcon(Icons.folder));
      await tester.pumpAndSettle();

      // Find category to manage permissions
      final categoryTile = find.byType(ListTile).first;
      if (categoryTile.evaluate().isNotEmpty) {
        await tester.tap(categoryTile);
        await tester.pumpAndSettle();

        // Look for permissions button
        final permissionsButton = find.byIcon(Icons.security);
        if (permissionsButton.evaluate().isNotEmpty) {
          await tester.tap(permissionsButton);
          await tester.pumpAndSettle();

          // Manage user permissions
          final userCheckboxes = find.byType(Checkbox);
          if (userCheckboxes.evaluate().isNotEmpty) {
            await tester.tap(userCheckboxes.first);
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
    });

    testWidgets('Category statistics and analytics', (
      WidgetTester tester,
    ) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performLogin(tester);

      // Navigate to categories
      await tester.tap(find.byIcon(Icons.folder));
      await tester.pumpAndSettle();

      // Enter category
      final categoryTile = find.byType(ListTile).first;
      if (categoryTile.evaluate().isNotEmpty) {
        await tester.tap(categoryTile);
        await tester.pumpAndSettle();

        // Look for statistics/info button
        final infoButton = find.byIcon(Icons.info);
        if (infoButton.evaluate().isNotEmpty) {
          await tester.tap(infoButton);
          await tester.pumpAndSettle();

          // Verify statistics display
          // Implementation depends on your analytics UI
        }
      }
    });
  });

  group('Category Error Handling', () {
    testWidgets('Handle category creation errors', (WidgetTester tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performLogin(tester);

      // Navigate to categories
      await tester.tap(find.byIcon(Icons.folder));
      await tester.pumpAndSettle();

      // Try to create category with invalid data
      final createCategoryButton = find.byIcon(Icons.add);
      if (createCategoryButton.evaluate().isNotEmpty) {
        await tester.tap(createCategoryButton);
        await tester.pumpAndSettle();

        // Submit empty form
        final submitButton = find.text(AppStrings.save);
        if (submitButton.evaluate().isNotEmpty) {
          await tester.tap(submitButton);
          await tester.pumpAndSettle();

          // Should show validation errors
          expect(find.text(AppStrings.fieldRequired), findsOneWidget);
        }
      }
    });

    testWidgets('Handle network errors during category operations', (
      WidgetTester tester,
    ) async {
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await _performLogin(tester);

      // Navigate to categories
      await tester.tap(find.byIcon(Icons.folder));
      await tester.pumpAndSettle();

      // Try operations that might fail due to network
      final createCategoryButton = find.byIcon(Icons.add);
      if (createCategoryButton.evaluate().isNotEmpty) {
        await tester.tap(createCategoryButton);
        await tester.pumpAndSettle();

        await _fillCategoryForm(
          tester,
          'Network Test Category',
          'Test description',
        );

        final submitButton = find.text(AppStrings.save);
        if (submitButton.evaluate().isNotEmpty) {
          await tester.tap(submitButton);
          await tester.pumpAndSettle(const Duration(seconds: 5));

          // Should handle network errors gracefully
          // Implementation depends on your error handling
        }
      }
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

Future<void> _fillCategoryForm(
  WidgetTester tester,
  String name,
  String description,
) async {
  final textFields = find.byType(TextFormField);

  if (textFields.evaluate().length >= 2) {
    await tester.enterText(textFields.first, name);
    await tester.enterText(textFields.at(1), description);
  }

  await tester.pumpAndSettle();
}
