import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_helpers.dart';

class UserManagementFlowTest {
  /// Run create user flow test
  static Future<void> runCreateUserFlow(WidgetTester tester) async {
    // Ensure user is logged in as admin
    await TestHelpers.loginWithTestCredentials(tester);
    
    // Navigate to user management
    await _navigateToUserManagement(tester);
    
    // Navigate to create user screen
    await _navigateToCreateUser(tester);
    
    // Fill user creation form
    await _fillUserCreationForm(tester);
    
    // Submit form and verify creation
    await _submitUserCreationForm(tester);
    
    await TestHelpers.takeScreenshot(tester, 'create_user_complete');
  }

  /// Run edit user flow test
  static Future<void> runEditUserFlow(WidgetTester tester) async {
    // Ensure user is logged in as admin
    await TestHelpers.loginWithTestCredentials(tester);
    
    // Navigate to user management
    await _navigateToUserManagement(tester);
    
    // Select user to edit
    await _selectUserToEdit(tester);
    
    // Edit user information
    await _editUserInformation(tester);
    
    // Save changes and verify
    await _saveUserChanges(tester);
    
    await TestHelpers.takeScreenshot(tester, 'edit_user_complete');
  }

  /// Run profile management flow test
  static Future<void> runProfileManagementFlow(WidgetTester tester) async {
    // Ensure user is logged in
    await TestHelpers.loginWithTestCredentials(tester);
    
    // Navigate to profile
    await _navigateToProfile(tester);
    
    // Test personal info management
    await _testPersonalInfoManagement(tester);
    
    // Test settings management
    await _testSettingsManagement(tester);
    
    // Test password change
    await _testPasswordChange(tester);
    
    await TestHelpers.takeScreenshot(tester, 'profile_management_complete');
  }

  /// Navigate to user management
  static Future<void> _navigateToUserManagement(WidgetTester tester) async {
    // Navigate to profile tab
    final profileTab = find.text('Profile');
    if (profileTab.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, profileTab);
    }

    // Look for user management option
    final userManagementOption = find.text('User Management');
    if (userManagementOption.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, userManagementOption);
    } else {
      // Try through settings
      final settingsOption = find.text('Settings');
      if (settingsOption.evaluate().isNotEmpty) {
        await TestHelpers.tapAndWait(tester, settingsOption);
        await TestHelpers.waitForText(tester, 'User Management');
        await TestHelpers.tapAndWait(tester, find.text('User Management'));
      }
    }

    await TestHelpers.waitForText(tester, 'User Management');
    await TestHelpers.takeScreenshot(tester, 'user_management_screen');
  }

  /// Navigate to create user screen
  static Future<void> _navigateToCreateUser(WidgetTester tester) async {
    // Look for create user button
    final createUserButton = find.text('Create User');
    final addButton = find.byIcon(Icons.add);
    final fabButton = find.byType(FloatingActionButton);

    if (createUserButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, createUserButton);
    } else if (addButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, addButton);
    } else if (fabButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, fabButton);
    }

    await TestHelpers.waitForText(tester, 'Create User');
    await TestHelpers.takeScreenshot(tester, 'create_user_screen');
  }

  /// Fill user creation form
  static Future<void> _fillUserCreationForm(WidgetTester tester) async {
    // Fill name field
    final nameField = find.byKey(const Key('user_name_field'));
    if (nameField.evaluate().isNotEmpty) {
      await TestHelpers.enterText(tester, nameField, 'Test User');
    } else {
      // Fallback to first text field
      final textFields = find.byType(TextField);
      if (textFields.evaluate().isNotEmpty) {
        await TestHelpers.enterText(tester, textFields.first, 'Test User');
      }
    }

    // Fill email field
    final emailField = find.byKey(const Key('user_email_field'));
    if (emailField.evaluate().isNotEmpty) {
      await TestHelpers.enterText(tester, emailField, 'testuser@example.com');
    } else {
      // Fallback to second text field
      final textFields = find.byType(TextField);
      if (textFields.evaluate().length > 1) {
        await TestHelpers.enterText(tester, textFields.at(1), 'testuser@example.com');
      }
    }

    // Fill password field
    final passwordField = find.byKey(const Key('user_password_field'));
    if (passwordField.evaluate().isNotEmpty) {
      await TestHelpers.enterText(tester, passwordField, 'testPassword123');
    } else {
      // Look for password field by hint text
      final passwordHint = find.text('Password');
      if (passwordHint.evaluate().isNotEmpty) {
        await TestHelpers.enterText(tester, passwordHint, 'testPassword123');
      }
    }

    // Select user role
    await _selectUserRole(tester);

    await TestHelpers.takeScreenshot(tester, 'user_form_filled');
  }

  /// Select user role
  static Future<void> _selectUserRole(WidgetTester tester) async {
    // Look for role dropdown
    final roleDropdown = find.byKey(const Key('user_role_dropdown'));
    if (roleDropdown.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, roleDropdown);
      
      // Select 'User' role
      final userRole = find.text('User').last;
      if (userRole.evaluate().isNotEmpty) {
        await TestHelpers.tapAndWait(tester, userRole);
      }
    } else {
      // Look for radio buttons
      final userRoleRadio = find.text('User');
      if (userRoleRadio.evaluate().isNotEmpty) {
        await TestHelpers.tapAndWait(tester, userRoleRadio);
      }
    }
  }

  /// Submit user creation form
  static Future<void> _submitUserCreationForm(WidgetTester tester) async {
    // Find and tap create button
    final createButton = find.text('Create');
    final saveButton = find.text('Save');
    final submitButton = find.text('Submit');

    if (createButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, createButton);
    } else if (saveButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, saveButton);
    } else if (submitButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, submitButton);
    }

    // Wait for creation to complete
    await TestHelpers.waitForLoadingToComplete(tester);

    // Verify success message
    await TestHelpers.waitForText(tester, 'User created successfully');

    // Verify navigation back to user list
    await TestHelpers.waitForText(tester, 'User Management');
  }

  /// Select user to edit
  static Future<void> _selectUserToEdit(WidgetTester tester) async {
    // Wait for user list to load
    await tester.pumpAndSettle();

    // Find first user in list
    final userTile = find.byType(ListTile).first;
    if (userTile.evaluate().isNotEmpty) {
      // Look for edit button on the tile
      final editButton = find.byIcon(Icons.edit);
      if (editButton.evaluate().isNotEmpty) {
        await TestHelpers.tapAndWait(tester, editButton.first);
      } else {
        // Tap on the tile itself
        await TestHelpers.tapAndWait(tester, userTile);
        
        // Look for edit option in details screen
        final editOption = find.text('Edit');
        if (editOption.evaluate().isNotEmpty) {
          await TestHelpers.tapAndWait(tester, editOption);
        }
      }
    }

    await TestHelpers.waitForText(tester, 'Edit User');
    await TestHelpers.takeScreenshot(tester, 'edit_user_screen');
  }

  /// Edit user information
  static Future<void> _editUserInformation(WidgetTester tester) async {
    // Update name field
    final nameField = find.byKey(const Key('user_name_field'));
    if (nameField.evaluate().isNotEmpty) {
      await tester.tap(nameField);
      await tester.pumpAndSettle();
      await tester.enterText(nameField, 'Updated Test User');
    }

    // Update email field
    final emailField = find.byKey(const Key('user_email_field'));
    if (emailField.evaluate().isNotEmpty) {
      await tester.tap(emailField);
      await tester.pumpAndSettle();
      await tester.enterText(emailField, 'updated.testuser@example.com');
    }

    // Update role if needed
    await _updateUserRole(tester);

    await TestHelpers.takeScreenshot(tester, 'user_info_updated');
  }

  /// Update user role
  static Future<void> _updateUserRole(WidgetTester tester) async {
    // Look for role dropdown
    final roleDropdown = find.byKey(const Key('user_role_dropdown'));
    if (roleDropdown.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, roleDropdown);
      
      // Select 'Admin' role
      final adminRole = find.text('Admin').last;
      if (adminRole.evaluate().isNotEmpty) {
        await TestHelpers.tapAndWait(tester, adminRole);
      }
    }
  }

  /// Save user changes
  static Future<void> _saveUserChanges(WidgetTester tester) async {
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
    await TestHelpers.waitForText(tester, 'User updated successfully');
  }

  /// Navigate to profile
  static Future<void> _navigateToProfile(WidgetTester tester) async {
    // Navigate to profile tab
    final profileTab = find.text('Profile');
    final profileIcon = find.byIcon(Icons.person);

    if (profileTab.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, profileTab);
    } else if (profileIcon.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, profileIcon);
    }

    await TestHelpers.waitForText(tester, 'Profile');
    await TestHelpers.takeScreenshot(tester, 'profile_screen');
  }

  /// Test personal info management
  static Future<void> _testPersonalInfoManagement(WidgetTester tester) async {
    // Navigate to personal info
    final personalInfoOption = find.text('Personal Info');
    if (personalInfoOption.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, personalInfoOption);
      
      await TestHelpers.waitForText(tester, 'Personal Information');
      
      // Test editing personal info
      await _editPersonalInfo(tester);
      
      await TestHelpers.takeScreenshot(tester, 'personal_info_updated');
    }
  }

  /// Edit personal info
  static Future<void> _editPersonalInfo(WidgetTester tester) async {
    // Look for edit button
    final editButton = find.text('Edit');
    if (editButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, editButton);
      
      // Update name
      final nameField = find.byType(TextField).first;
      if (nameField.evaluate().isNotEmpty) {
        await TestHelpers.enterText(tester, nameField, 'Updated Name');
      }
      
      // Save changes
      final saveButton = find.text('Save');
      if (saveButton.evaluate().isNotEmpty) {
        await TestHelpers.tapAndWait(tester, saveButton);
      }
    }
  }

  /// Test settings management
  static Future<void> _testSettingsManagement(WidgetTester tester) async {
    // Navigate back to profile
    final backButton = find.byIcon(Icons.arrow_back);
    if (backButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, backButton);
    }

    // Navigate to settings
    final settingsOption = find.text('Settings');
    if (settingsOption.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, settingsOption);
      
      await TestHelpers.waitForText(tester, 'Settings');
      
      // Test various settings
      await _testNotificationSettings(tester);
      await _testPrivacySettings(tester);
      
      await TestHelpers.takeScreenshot(tester, 'settings_updated');
    }
  }

  /// Test notification settings
  static Future<void> _testNotificationSettings(WidgetTester tester) async {
    // Look for notification toggle
    final notificationToggle = find.byType(Switch).first;
    if (notificationToggle.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, notificationToggle);
    }
  }

  /// Test privacy settings
  static Future<void> _testPrivacySettings(WidgetTester tester) async {
    // Look for privacy options
    final privacyOption = find.text('Privacy');
    if (privacyOption.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, privacyOption);
      
      // Test privacy toggles
      final privacyToggles = find.byType(Switch);
      if (privacyToggles.evaluate().isNotEmpty) {
        await TestHelpers.tapAndWait(tester, privacyToggles.first);
      }
    }
  }

  /// Test password change
  static Future<void> _testPasswordChange(WidgetTester tester) async {
    // Look for change password option
    final changePasswordOption = find.text('Change Password');
    if (changePasswordOption.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, changePasswordOption);
      
      await TestHelpers.waitForText(tester, 'Change Password');
      
      // Fill password change form
      await _fillPasswordChangeForm(tester);
      
      await TestHelpers.takeScreenshot(tester, 'password_change_complete');
    }
  }

  /// Fill password change form
  static Future<void> _fillPasswordChangeForm(WidgetTester tester) async {
    final textFields = find.byType(TextField);
    
    if (textFields.evaluate().length >= 3) {
      // Current password
      await TestHelpers.enterText(tester, textFields.at(0), TestHelpers.testPassword);
      
      // New password
      await TestHelpers.enterText(tester, textFields.at(1), 'newPassword123');
      
      // Confirm password
      await TestHelpers.enterText(tester, textFields.at(2), 'newPassword123');
      
      // Submit
      final changeButton = find.text('Change Password');
      if (changeButton.evaluate().isNotEmpty) {
        await TestHelpers.tapAndWait(tester, changeButton);
      }
      
      // Verify success
      await TestHelpers.waitForText(tester, 'Password changed successfully');
    }
  }
}
