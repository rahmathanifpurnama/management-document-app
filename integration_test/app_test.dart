import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:managementdoc/main.dart' as app;

import 'test_flows/auth_flow_test.dart';
import 'test_flows/document_flow_test.dart';
import 'test_flows/navigation_flow_test.dart';
import 'test_flows/user_management_flow_test.dart';
import 'test_flows/category_flow_test.dart';
import 'test_flows/performance_test.dart';
import 'helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Management Document App Integration Tests', () {
    setUpAll(() async {
      // Initialize test environment
      await TestHelpers.initializeTestEnvironment();
    });

    tearDownAll(() async {
      // Cleanup test environment
      await TestHelpers.cleanupTestEnvironment();
    });

    group('Authentication Flow Tests', () {
      testWidgets('Complete authentication flow', (WidgetTester tester) async {
        await AuthFlowTest.runCompleteAuthFlow(tester);
      });

      testWidgets('Login with invalid credentials', (
        WidgetTester tester,
      ) async {
        await AuthFlowTest.runInvalidLoginFlow(tester);
      });

      testWidgets('Logout flow', (WidgetTester tester) async {
        await AuthFlowTest.runLogoutFlow(tester);
      });
    });

    group('Navigation Flow Tests', () {
      testWidgets('Bottom navigation flow', (WidgetTester tester) async {
        await NavigationFlowTest.runBottomNavigationFlow(tester);
      });

      testWidgets('Deep navigation flow', (WidgetTester tester) async {
        await NavigationFlowTest.runDeepNavigationFlow(tester);
      });

      testWidgets('Back navigation flow', (WidgetTester tester) async {
        await NavigationFlowTest.runBackNavigationFlow(tester);
      });
    });

    group('Document Management Flow Tests', () {
      testWidgets('Document upload flow', (WidgetTester tester) async {
        await DocumentFlowTest.runDocumentUploadFlow(tester);
      });

      testWidgets('Document view and download flow', (
        WidgetTester tester,
      ) async {
        await DocumentFlowTest.runDocumentViewFlow(tester);
      });

      testWidgets('Document search flow', (WidgetTester tester) async {
        await DocumentFlowTest.runDocumentSearchFlow(tester);
      });

      testWidgets('Document sharing flow', (WidgetTester tester) async {
        await DocumentFlowTest.runDocumentSharingFlow(tester);
      });
    });

    group('Category Management Flow Tests', () {
      testWidgets('Create category flow', (WidgetTester tester) async {
        await CategoryFlowTest.runCreateCategoryFlow(tester);
      });

      testWidgets('Edit category flow', (WidgetTester tester) async {
        await CategoryFlowTest.runEditCategoryFlow(tester);
      });

      testWidgets('Delete category flow', (WidgetTester tester) async {
        await CategoryFlowTest.runDeleteCategoryFlow(tester);
      });

      testWidgets('Add files to category flow', (WidgetTester tester) async {
        await CategoryFlowTest.runAddFilesToCategoryFlow(tester);
      });
    });

    group('User Management Flow Tests', () {
      testWidgets('Create user flow', (WidgetTester tester) async {
        await UserManagementFlowTest.runCreateUserFlow(tester);
      });

      testWidgets('Edit user flow', (WidgetTester tester) async {
        await UserManagementFlowTest.runEditUserFlow(tester);
      });

      testWidgets('User profile management flow', (WidgetTester tester) async {
        await UserManagementFlowTest.runProfileManagementFlow(tester);
      });
    });

    group('Performance Tests', () {
      testWidgets('App startup performance', (WidgetTester tester) async {
        await PerformanceTest.runStartupPerformanceTest(tester);
      });

      testWidgets('Large file upload performance', (WidgetTester tester) async {
        await PerformanceTest.runLargeFileUploadTest(tester);
      });

      testWidgets('Memory usage test', (WidgetTester tester) async {
        await PerformanceTest.runMemoryUsageTest(tester);
      });

      testWidgets('Network performance test', (WidgetTester tester) async {
        await PerformanceTest.runNetworkPerformanceTest(tester);
      });
    });

    group('Error Handling Tests', () {
      testWidgets('Network error handling', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Test network error scenarios
        await TestHelpers.simulateNetworkError();

        // Verify error handling UI
        expect(find.text('Network Error'), findsOneWidget);

        await TestHelpers.restoreNetwork();
      });

      testWidgets('Authentication error handling', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Test authentication error scenarios
        await TestHelpers.simulateAuthError();

        // Verify error handling
        expect(find.text('Authentication Error'), findsOneWidget);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('Screen reader accessibility', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Test semantic labels and accessibility
        await TestHelpers.verifyAccessibility(tester);
      });

      testWidgets('High contrast mode', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Test high contrast accessibility
        await TestHelpers.testHighContrastMode(tester);
      });
    });

    group('Localization Tests', () {
      testWidgets('Language switching', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Test language switching if supported
        await TestHelpers.testLanguageSwitching(tester);
      });
    });

    group('Data Persistence Tests', () {
      testWidgets('Offline data persistence', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Test offline data persistence
        await TestHelpers.testOfflineDataPersistence(tester);
      });

      testWidgets('App state restoration', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Test app state restoration after restart
        await TestHelpers.testAppStateRestoration(tester);
      });
    });
  });
}
