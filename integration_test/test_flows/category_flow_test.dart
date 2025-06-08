import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_helpers.dart';

class CategoryFlowTest {
  /// Run create category flow test
  static Future<void> runCreateCategoryFlow(WidgetTester tester) async {
    // Ensure user is logged in
    await TestHelpers.loginWithTestCredentials(tester);
    
    // Navigate to categories
    await _navigateToCategories(tester);
    
    // Navigate to manage categories
    await _navigateToManageCategories(tester);
    
    // Create new category
    await _createNewCategory(tester);
    
    // Verify category creation
    await _verifyCategoryCreation(tester);
    
    await TestHelpers.takeScreenshot(tester, 'create_category_complete');
  }

  /// Run edit category flow test
  static Future<void> runEditCategoryFlow(WidgetTester tester) async {
    // Ensure user is logged in
    await TestHelpers.loginWithTestCredentials(tester);
    
    // Navigate to categories
    await _navigateToCategories(tester);
    
    // Navigate to manage categories
    await _navigateToManageCategories(tester);
    
    // Select category to edit
    await _selectCategoryToEdit(tester);
    
    // Edit category details
    await _editCategoryDetails(tester);
    
    // Save changes
    await _saveCategoryChanges(tester);
    
    await TestHelpers.takeScreenshot(tester, 'edit_category_complete');
  }

  /// Run delete category flow test
  static Future<void> runDeleteCategoryFlow(WidgetTester tester) async {
    // Ensure user is logged in
    await TestHelpers.loginWithTestCredentials(tester);
    
    // Navigate to categories
    await _navigateToCategories(tester);
    
    // Navigate to manage categories
    await _navigateToManageCategories(tester);
    
    // Select category to delete
    await _selectCategoryToDelete(tester);
    
    // Confirm deletion
    await _confirmCategoryDeletion(tester);
    
    // Verify deletion
    await _verifyCategoryDeletion(tester);
    
    await TestHelpers.takeScreenshot(tester, 'delete_category_complete');
  }

  /// Run add files to category flow test
  static Future<void> runAddFilesToCategoryFlow(WidgetTester tester) async {
    // Ensure user is logged in
    await TestHelpers.loginWithTestCredentials(tester);
    
    // Navigate to categories
    await _navigateToCategories(tester);
    
    // Select a category
    await _selectCategory(tester);
    
    // Add files to category
    await _addFilesToCategory(tester);
    
    // Verify files added
    await _verifyFilesAdded(tester);
    
    await TestHelpers.takeScreenshot(tester, 'add_files_to_category_complete');
  }

  /// Navigate to categories screen
  static Future<void> _navigateToCategories(WidgetTester tester) async {
    // Navigate to categories tab
    final categoriesTab = find.text('Categories');
    final categoriesIcon = find.byIcon(Icons.category);

    if (categoriesTab.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, categoriesTab);
    } else if (categoriesIcon.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, categoriesIcon);
    }

    await TestHelpers.waitForText(tester, 'Categories');
    await TestHelpers.takeScreenshot(tester, 'categories_screen');
  }

  /// Navigate to manage categories
  static Future<void> _navigateToManageCategories(WidgetTester tester) async {
    // Look for manage categories button
    final manageCategoriesButton = find.text('Manage Categories');
    final settingsIcon = find.byIcon(Icons.settings);
    final moreIcon = find.byIcon(Icons.more_vert);

    if (manageCategoriesButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, manageCategoriesButton);
    } else if (settingsIcon.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, settingsIcon);
    } else if (moreIcon.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, moreIcon);
      await TestHelpers.waitForText(tester, 'Manage Categories');
      await TestHelpers.tapAndWait(tester, find.text('Manage Categories'));
    }

    await TestHelpers.waitForText(tester, 'Manage Categories');
    await TestHelpers.takeScreenshot(tester, 'manage_categories_screen');
  }

  /// Create new category
  static Future<void> _createNewCategory(WidgetTester tester) async {
    // Look for add/create button
    final addButton = find.byIcon(Icons.add);
    final createButton = find.text('Create Category');
    final fabButton = find.byType(FloatingActionButton);

    if (addButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, addButton);
    } else if (createButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, createButton);
    } else if (fabButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, fabButton);
    }

    await TestHelpers.waitForText(tester, 'Create Category');
    
    // Fill category form
    await _fillCategoryForm(tester, 'Test Category', 'Test category description');
    
    await TestHelpers.takeScreenshot(tester, 'category_form_filled');
  }

  /// Fill category form
  static Future<void> _fillCategoryForm(
    WidgetTester tester,
    String name,
    String description,
  ) async {
    // Fill category name
    final nameField = find.byKey(const Key('category_name_field'));
    if (nameField.evaluate().isNotEmpty) {
      await TestHelpers.enterText(tester, nameField, name);
    } else {
      // Fallback to first text field
      final textFields = find.byType(TextField);
      if (textFields.evaluate().isNotEmpty) {
        await TestHelpers.enterText(tester, textFields.first, name);
      }
    }

    // Fill category description
    final descriptionField = find.byKey(const Key('category_description_field'));
    if (descriptionField.evaluate().isNotEmpty) {
      await TestHelpers.enterText(tester, descriptionField, description);
    } else {
      // Fallback to second text field
      final textFields = find.byType(TextField);
      if (textFields.evaluate().length > 1) {
        await TestHelpers.enterText(tester, textFields.at(1), description);
      }
    }

    // Select category color if available
    await _selectCategoryColor(tester);

    // Select category icon if available
    await _selectCategoryIcon(tester);
  }

  /// Select category color
  static Future<void> _selectCategoryColor(WidgetTester tester) async {
    // Look for color picker
    final colorPicker = find.byKey(const Key('category_color_picker'));
    if (colorPicker.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, colorPicker);
      
      // Select a color
      final colorOption = find.byType(Container).first;
      if (colorOption.evaluate().isNotEmpty) {
        await TestHelpers.tapAndWait(tester, colorOption);
      }
    }
  }

  /// Select category icon
  static Future<void> _selectCategoryIcon(WidgetTester tester) async {
    // Look for icon picker
    final iconPicker = find.byKey(const Key('category_icon_picker'));
    if (iconPicker.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, iconPicker);
      
      // Select an icon
      final iconOption = find.byIcon(Icons.folder).first;
      if (iconOption.evaluate().isNotEmpty) {
        await TestHelpers.tapAndWait(tester, iconOption);
      }
    }
  }

  /// Verify category creation
  static Future<void> _verifyCategoryCreation(WidgetTester tester) async {
    // Submit form
    final createButton = find.text('Create');
    final saveButton = find.text('Save');

    if (createButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, createButton);
    } else if (saveButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, saveButton);
    }

    // Wait for creation to complete
    await TestHelpers.waitForLoadingToComplete(tester);

    // Verify success message
    await TestHelpers.waitForText(tester, 'Category created successfully');

    // Verify category appears in list
    await TestHelpers.waitForText(tester, 'Test Category');
  }

  /// Select category to edit
  static Future<void> _selectCategoryToEdit(WidgetTester tester) async {
    // Find first category in list
    final categoryTile = find.byType(ListTile).first;
    if (categoryTile.evaluate().isNotEmpty) {
      // Look for edit button
      final editButton = find.byIcon(Icons.edit);
      if (editButton.evaluate().isNotEmpty) {
        await TestHelpers.tapAndWait(tester, editButton.first);
      } else {
        // Tap on category tile
        await TestHelpers.tapAndWait(tester, categoryTile);
        
        // Look for edit option
        final editOption = find.text('Edit');
        if (editOption.evaluate().isNotEmpty) {
          await TestHelpers.tapAndWait(tester, editOption);
        }
      }
    }

    await TestHelpers.waitForText(tester, 'Edit Category');
    await TestHelpers.takeScreenshot(tester, 'edit_category_screen');
  }

  /// Edit category details
  static Future<void> _editCategoryDetails(WidgetTester tester) async {
    // Update category name
    final nameField = find.byKey(const Key('category_name_field'));
    if (nameField.evaluate().isNotEmpty) {
      await tester.tap(nameField);
      await tester.pumpAndSettle();
      await tester.enterText(nameField, 'Updated Test Category');
    }

    // Update description
    final descriptionField = find.byKey(const Key('category_description_field'));
    if (descriptionField.evaluate().isNotEmpty) {
      await tester.tap(descriptionField);
      await tester.pumpAndSettle();
      await tester.enterText(descriptionField, 'Updated category description');
    }

    await TestHelpers.takeScreenshot(tester, 'category_details_updated');
  }

  /// Save category changes
  static Future<void> _saveCategoryChanges(WidgetTester tester) async {
    // Find and tap save button
    final saveButton = find.text('Save');
    final updateButton = find.text('Update');

    if (saveButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, saveButton);
    } else if (updateButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, updateButton);
    }

    // Wait for update to complete
    await TestHelpers.waitForLoadingToComplete(tester);

    // Verify success message
    await TestHelpers.waitForText(tester, 'Category updated successfully');
  }

  /// Select category to delete
  static Future<void> _selectCategoryToDelete(WidgetTester tester) async {
    // Find category to delete
    final categoryTile = find.byType(ListTile).last;
    if (categoryTile.evaluate().isNotEmpty) {
      // Look for delete button
      final deleteButton = find.byIcon(Icons.delete);
      if (deleteButton.evaluate().isNotEmpty) {
        await TestHelpers.tapAndWait(tester, deleteButton.last);
      } else {
        // Long press on category tile
        await tester.longPress(categoryTile);
        await tester.pumpAndSettle();
        
        // Look for delete option
        final deleteOption = find.text('Delete');
        if (deleteOption.evaluate().isNotEmpty) {
          await TestHelpers.tapAndWait(tester, deleteOption);
        }
      }
    }

    await TestHelpers.takeScreenshot(tester, 'delete_category_confirmation');
  }

  /// Confirm category deletion
  static Future<void> _confirmCategoryDeletion(WidgetTester tester) async {
    // Look for confirmation dialog
    final confirmButton = find.text('Confirm');
    final deleteButton = find.text('Delete');
    final yesButton = find.text('Yes');

    if (confirmButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, confirmButton);
    } else if (deleteButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, deleteButton);
    } else if (yesButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, yesButton);
    }

    // Wait for deletion to complete
    await TestHelpers.waitForLoadingToComplete(tester);
  }

  /// Verify category deletion
  static Future<void> _verifyCategoryDeletion(WidgetTester tester) async {
    // Verify success message
    await TestHelpers.waitForText(tester, 'Category deleted successfully');

    // Verify category no longer appears in list
    expect(find.text('Test Category'), findsNothing);
  }

  /// Select a category
  static Future<void> _selectCategory(WidgetTester tester) async {
    // Find first category
    final categoryCard = find.byType(Card).first;
    final categoryTile = find.byType(ListTile).first;

    if (categoryCard.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, categoryCard);
    } else if (categoryTile.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, categoryTile);
    }

    await TestHelpers.waitForText(tester, 'Category Files');
    await TestHelpers.takeScreenshot(tester, 'category_files_screen');
  }

  /// Add files to category
  static Future<void> _addFilesToCategory(WidgetTester tester) async {
    // Look for add files button
    final addFilesButton = find.text('Add Files');
    final addButton = find.byIcon(Icons.add);

    if (addFilesButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, addFilesButton);
    } else if (addButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, addButton);
    }

    await TestHelpers.waitForText(tester, 'Add Files to Category');
    
    // Select files to add
    await _selectFilesToAdd(tester);
    
    await TestHelpers.takeScreenshot(tester, 'files_selected_for_category');
  }

  /// Select files to add
  static Future<void> _selectFilesToAdd(WidgetTester tester) async {
    // Wait for files list to load
    await tester.pumpAndSettle();

    // Select first few files
    final checkboxes = find.byType(Checkbox);
    if (checkboxes.evaluate().isNotEmpty) {
      // Select first 3 files
      for (int i = 0; i < 3 && i < checkboxes.evaluate().length; i++) {
        await TestHelpers.tapAndWait(tester, checkboxes.at(i));
      }
    }

    // Add selected files
    final addSelectedButton = find.text('Add Selected');
    if (addSelectedButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, addSelectedButton);
    }

    // Wait for addition to complete
    await TestHelpers.waitForLoadingToComplete(tester);
  }

  /// Verify files added
  static Future<void> _verifyFilesAdded(WidgetTester tester) async {
    // Verify success message
    await TestHelpers.waitForText(tester, 'Files added to category');

    // Navigate back to category files
    final backButton = find.byIcon(Icons.arrow_back);
    if (backButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, backButton);
    }

    // Verify files appear in category
    expect(find.byType(ListTile), findsAtLeastNWidgets(1));
  }

  /// Test category filtering
  static Future<void> testCategoryFiltering(WidgetTester tester) async {
    // Ensure user is logged in
    await TestHelpers.loginWithTestCredentials(tester);
    
    // Navigate to categories
    await _navigateToCategories(tester);
    
    // Test search/filter functionality
    final searchField = find.byType(TextField);
    if (searchField.evaluate().isNotEmpty) {
      await TestHelpers.enterText(tester, searchField.first, 'test');
      await tester.pumpAndSettle();
      
      // Verify filtered results
      expect(find.textContaining('test'), findsAtLeastNWidgets(1));
    }
    
    await TestHelpers.takeScreenshot(tester, 'category_filtering_complete');
  }
}
