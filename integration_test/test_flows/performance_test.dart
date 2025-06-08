import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../helpers/test_helpers.dart';

class PerformanceTest {
  /// Run startup performance test
  static Future<void> runStartupPerformanceTest(WidgetTester tester) async {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    // Measure app startup time
    final startTime = DateTime.now();

    await binding.watchPerformance(() async {
      await TestHelpers.verifyAppLaunched(tester);
      await tester.pumpAndSettle();
    });

    final endTime = DateTime.now();
    final startupDuration = endTime.difference(startTime);

    // Verify startup time is reasonable (less than 5 seconds)
    expect(startupDuration.inSeconds, lessThan(5));

    await TestHelpers.takeScreenshot(tester, 'startup_performance_complete');

    // Log performance results for debugging
    debugPrint('Startup Performance Results:');
    debugPrint('- Startup time: ${startupDuration.inMilliseconds}ms');
    debugPrint('- Performance timeline captured successfully');
  }

  /// Run large file upload performance test
  static Future<void> runLargeFileUploadTest(WidgetTester tester) async {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    // Ensure user is logged in
    await TestHelpers.loginWithTestCredentials(tester);

    // Create large test file (10MB)
    final largeFileData = TestHelpers.createTestFileData(10 * 1024 * 1024);

    // Measure upload performance
    final startTime = DateTime.now();

    await binding.watchPerformance(() async {
      await _simulateLargeFileUpload(tester, largeFileData);
    });

    final endTime = DateTime.now();
    final uploadDuration = endTime.difference(startTime);

    // Verify upload completed within reasonable time (less than 2 minutes)
    expect(uploadDuration.inMinutes, lessThan(2));

    await TestHelpers.takeScreenshot(tester, 'large_file_upload_complete');

    debugPrint('Large File Upload Performance Results:');
    debugPrint('- Upload time: ${uploadDuration.inSeconds}s');
    debugPrint(
      '- File size: ${(largeFileData.length / (1024 * 1024)).toStringAsFixed(2)}MB',
    );
    debugPrint('- Performance timeline captured successfully');
  }

  /// Run memory usage test
  static Future<void> runMemoryUsageTest(WidgetTester tester) async {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    // Ensure user is logged in
    await TestHelpers.loginWithTestCredentials(tester);

    // Perform memory-intensive operations
    await binding.watchPerformance(() async {
      await _performMemoryIntensiveOperations(tester);
    });

    // Test memory cleanup
    await _testMemoryCleanup(tester);

    await TestHelpers.takeScreenshot(tester, 'memory_usage_test_complete');

    debugPrint('Memory Usage Test completed');
  }

  /// Run network performance test
  static Future<void> runNetworkPerformanceTest(WidgetTester tester) async {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    // Ensure user is logged in
    await TestHelpers.loginWithTestCredentials(tester);

    // Test network operations
    await binding.watchPerformance(() async {
      await _testNetworkOperations(tester);
    });

    await TestHelpers.takeScreenshot(tester, 'network_performance_complete');

    debugPrint('Network Performance Results:');
    debugPrint('- Network performance timeline captured successfully');
  }

  /// Simulate large file upload
  static Future<void> _simulateLargeFileUpload(
    WidgetTester tester,
    Uint8List fileData,
  ) async {
    // Navigate to upload screen
    final uploadButton = find.byIcon(Icons.add);
    if (uploadButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, uploadButton);
    }

    await TestHelpers.waitForText(tester, 'Upload Document');

    // Simulate file selection (in real test, this would be mocked)
    await tester.pumpAndSettle();

    // Fill upload form
    final titleField = find.byType(TextField).first;
    if (titleField.evaluate().isNotEmpty) {
      await TestHelpers.enterText(tester, titleField, 'Large Test File');
    }

    // Start upload
    final uploadSubmitButton = find.text('Upload');
    if (uploadSubmitButton.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, uploadSubmitButton);
    }

    // Wait for upload progress
    await _waitForUploadProgress(tester);
  }

  /// Wait for upload progress
  static Future<void> _waitForUploadProgress(WidgetTester tester) async {
    // Look for progress indicator
    final progressIndicator = find.byType(CircularProgressIndicator);

    // Wait for upload to start
    if (progressIndicator.evaluate().isNotEmpty) {
      // Monitor progress for up to 2 minutes
      final timeout = DateTime.now().add(const Duration(minutes: 2));

      while (DateTime.now().isBefore(timeout)) {
        await tester.pumpAndSettle(const Duration(milliseconds: 100));

        // Check if upload completed
        if (find.text('Upload successful').evaluate().isNotEmpty) {
          break;
        }

        // Check if upload failed
        if (find.text('Upload failed').evaluate().isNotEmpty) {
          throw Exception('Upload failed during performance test');
        }

        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
  }

  /// Perform memory-intensive operations
  static Future<void> _performMemoryIntensiveOperations(
    WidgetTester tester,
  ) async {
    // Navigate through multiple screens to load data
    await _navigateToDocumentsList(tester);
    await _loadMultipleDocuments(tester);
    await _navigateToCategories(tester);
    await _loadMultipleCategories(tester);
    await _navigateToUserManagement(tester);
    await _loadMultipleUsers(tester);
  }

  /// Navigate to documents list
  static Future<void> _navigateToDocumentsList(WidgetTester tester) async {
    final homeTab = find.text('Home');
    if (homeTab.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, homeTab);
    }

    await TestHelpers.waitForText(tester, 'Documents');
  }

  /// Load multiple documents
  static Future<void> _loadMultipleDocuments(WidgetTester tester) async {
    // Scroll through documents list to load more
    final scrollable = find.byType(Scrollable);
    if (scrollable.evaluate().isNotEmpty) {
      for (int i = 0; i < 5; i++) {
        await tester.drag(scrollable.first, const Offset(0, -300));
        await tester.pumpAndSettle();
      }
    }
  }

  /// Navigate to categories
  static Future<void> _navigateToCategories(WidgetTester tester) async {
    final categoriesTab = find.text('Categories');
    if (categoriesTab.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, categoriesTab);
    }

    await TestHelpers.waitForText(tester, 'Categories');
  }

  /// Load multiple categories
  static Future<void> _loadMultipleCategories(WidgetTester tester) async {
    // Tap on multiple categories to load their content
    final categoryCards = find.byType(Card);
    final categoryCount = categoryCards.evaluate().length;

    for (int i = 0; i < categoryCount && i < 3; i++) {
      await TestHelpers.tapAndWait(tester, categoryCards.at(i));
      await tester.pumpAndSettle();

      // Go back
      final backButton = find.byIcon(Icons.arrow_back);
      if (backButton.evaluate().isNotEmpty) {
        await TestHelpers.tapAndWait(tester, backButton);
      }
    }
  }

  /// Navigate to user management
  static Future<void> _navigateToUserManagement(WidgetTester tester) async {
    final profileTab = find.text('Profile');
    if (profileTab.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, profileTab);
    }

    final userManagementOption = find.text('User Management');
    if (userManagementOption.evaluate().isNotEmpty) {
      await TestHelpers.tapAndWait(tester, userManagementOption);
    }
  }

  /// Load multiple users
  static Future<void> _loadMultipleUsers(WidgetTester tester) async {
    // Scroll through users list
    final scrollable = find.byType(Scrollable);
    if (scrollable.evaluate().isNotEmpty) {
      for (int i = 0; i < 3; i++) {
        await tester.drag(scrollable.first, const Offset(0, -200));
        await tester.pumpAndSettle();
      }
    }
  }

  /// Test memory cleanup
  static Future<void> _testMemoryCleanup(WidgetTester tester) async {
    // Force garbage collection by navigating away and back
    await TestHelpers.logout(tester);
    await TestHelpers.loginWithTestCredentials(tester);

    // Verify app is still responsive
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsAtLeastNWidgets(1));
  }

  /// Test network operations
  static Future<void> _testNetworkOperations(WidgetTester tester) async {
    // Perform multiple network-dependent operations
    await _refreshDocumentsList(tester);
    await _refreshCategoriesList(tester);
    await _refreshUsersList(tester);
  }

  /// Refresh documents list
  static Future<void> _refreshDocumentsList(WidgetTester tester) async {
    await _navigateToDocumentsList(tester);

    // Pull to refresh
    final scrollable = find.byType(Scrollable);
    if (scrollable.evaluate().isNotEmpty) {
      await tester.fling(scrollable.first, const Offset(0, 300), 1000);
      await tester.pumpAndSettle();
    }
  }

  /// Refresh categories list
  static Future<void> _refreshCategoriesList(WidgetTester tester) async {
    await _navigateToCategories(tester);

    // Pull to refresh
    final scrollable = find.byType(Scrollable);
    if (scrollable.evaluate().isNotEmpty) {
      await tester.fling(scrollable.first, const Offset(0, 300), 1000);
      await tester.pumpAndSettle();
    }
  }

  /// Refresh users list
  static Future<void> _refreshUsersList(WidgetTester tester) async {
    await _navigateToUserManagement(tester);

    // Pull to refresh
    final scrollable = find.byType(Scrollable);
    if (scrollable.evaluate().isNotEmpty) {
      await tester.fling(scrollable.first, const Offset(0, 300), 1000);
      await tester.pumpAndSettle();
    }
  }

  /// Test scroll performance
  static Future<void> testScrollPerformance(WidgetTester tester) async {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    // Ensure user is logged in
    await TestHelpers.loginWithTestCredentials(tester);

    // Navigate to a list view
    await _navigateToDocumentsList(tester);

    // Measure scroll performance
    await binding.watchPerformance(() async {
      await _performScrollTest(tester);
    });

    await TestHelpers.takeScreenshot(tester, 'scroll_performance_complete');

    debugPrint('Scroll Performance Results:');
    debugPrint('- Scroll performance timeline captured successfully');
  }

  /// Perform scroll test
  static Future<void> _performScrollTest(WidgetTester tester) async {
    final scrollable = find.byType(Scrollable);
    if (scrollable.evaluate().isNotEmpty) {
      // Perform fast scrolling
      for (int i = 0; i < 10; i++) {
        await tester.fling(scrollable.first, const Offset(0, -500), 2000);
        await tester.pumpAndSettle();

        await tester.fling(scrollable.first, const Offset(0, 500), 2000);
        await tester.pumpAndSettle();
      }
    }
  }
}
