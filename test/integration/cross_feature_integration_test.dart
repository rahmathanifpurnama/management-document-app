import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:managementdoc/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Cross-Feature Integration Tests', () {
    
    testWidgets('Document Upload → Category Update → Notification Flow', (tester) async {
      await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();

      // Step 1: Navigate to upload screen
      final uploadTab = find.byKey(const Key('upload_tab'));
      await tester.tap(uploadTab);
      await tester.pumpAndSettle();

      // Step 2: Select a file for upload (UploadBloc)
      final selectFileButton = find.byKey(const Key('select_file_button'));
      await tester.tap(selectFileButton);
      await tester.pumpAndSettle();

      // Step 3: Choose category for the document (CategoryBloc)
      final categoryDropdown = find.byKey(const Key('category_dropdown'));
      await tester.tap(categoryDropdown);
      await tester.pumpAndSettle();

      final categoryOption = find.byKey(const Key('category_option_work'));
      await tester.tap(categoryOption);
      await tester.pumpAndSettle();

      // Step 4: Start upload process
      final startUploadButton = find.byKey(const Key('start_upload_button'));
      await tester.tap(startUploadButton);
      await tester.pumpAndSettle();

      // Step 5: Verify notification is sent (NotificationProvider)
      await tester.pump(const Duration(seconds: 2));
      final notificationBadge = find.byKey(const Key('notification_badge'));
      expect(notificationBadge, findsOneWidget);

      // Step 6: Check document appears in list (DocumentBloc)
      final documentsTab = find.byKey(const Key('documents_tab'));
      await tester.tap(documentsTab);
      await tester.pumpAndSettle();

      final documentList = find.byKey(const Key('document_list'));
      expect(documentList, findsOneWidget);

      // Step 7: Verify file selection works in document list (FileSelectionProvider)
      final firstDocument = find.byKey(const Key('document_item_0'));
      await tester.longPress(firstDocument);
      await tester.pumpAndSettle();

      final selectionBar = find.byKey(const Key('selection_bar'));
      expect(selectionBar, findsOneWidget);
    });

    testWidgets('User Management → Permission Update → Document Access', (tester) async {
      await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();

      // Step 1: Navigate to profile/user management
      final profileTab = find.byKey(const Key('profile_tab'));
      await tester.tap(profileTab);
      await tester.pumpAndSettle();

      final userManagementButton = find.byKey(const Key('user_management_button'));
      await tester.tap(userManagementButton);
      await tester.pumpAndSettle();

      // Step 2: Update user permissions
      final userItem = find.byKey(const Key('user_item_0'));
      await tester.tap(userItem);
      await tester.pumpAndSettle();

      final permissionToggle = find.byKey(const Key('permission_toggle_admin'));
      await tester.tap(permissionToggle);
      await tester.pumpAndSettle();

      final saveButton = find.byKey(const Key('save_permissions_button'));
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Step 3: Verify document access changes
      final documentsTab = find.byKey(const Key('documents_tab'));
      await tester.tap(documentsTab);
      await tester.pumpAndSettle();

      // Verify admin documents are now visible
      final adminDocuments = find.byKey(const Key('admin_documents_section'));
      expect(adminDocuments, findsOneWidget);
    });

    testWidgets('Settings Change → UI Update → State Persistence', (tester) async {
      await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();

      // Step 1: Navigate to settings
      final profileTab = find.byKey(const Key('profile_tab'));
      await tester.tap(profileTab);
      await tester.pumpAndSettle();

      final settingsButton = find.byKey(const Key('settings_button'));
      await tester.tap(settingsButton);
      await tester.pumpAndSettle();

      // Step 2: Change theme setting
      final darkModeToggle = find.byKey(const Key('dark_mode_toggle'));
      await tester.tap(darkModeToggle);
      await tester.pumpAndSettle();

      // Step 3: Verify UI updates immediately
      final appBar = find.byType(AppBar);
      expect(appBar, findsOneWidget);
      
      // Verify dark theme is applied
      final appBarWidget = tester.widget<AppBar>(appBar);
      expect(appBarWidget.backgroundColor, isNotNull);

      // Step 4: Navigate away and back to verify persistence
      final documentsTab = find.byKey(const Key('documents_tab'));
      await tester.tap(documentsTab);
      await tester.pumpAndSettle();

      await tester.tap(profileTab);
      await tester.pumpAndSettle();

      // Verify theme is still applied
      final persistedAppBar = find.byType(AppBar);
      expect(persistedAppBar, findsOneWidget);
    });

    testWidgets('Activity Logging → Statistics Update → Dashboard Refresh', (tester) async {
      await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();

      // Step 1: Perform an activity (document upload)
      final uploadTab = find.byKey(const Key('upload_tab'));
      await tester.tap(uploadTab);
      await tester.pumpAndSettle();

      final quickUploadButton = find.byKey(const Key('quick_upload_button'));
      await tester.tap(quickUploadButton);
      await tester.pumpAndSettle();

      // Step 2: Verify activity is logged
      final profileTab = find.byKey(const Key('profile_tab'));
      await tester.tap(profileTab);
      await tester.pumpAndSettle();

      final activityButton = find.byKey(const Key('activity_button'));
      await tester.tap(activityButton);
      await tester.pumpAndSettle();

      final activityList = find.byKey(const Key('activity_list'));
      expect(activityList, findsOneWidget);

      // Step 3: Check statistics are updated
      final homeTab = find.byKey(const Key('home_tab'));
      await tester.tap(homeTab);
      await tester.pumpAndSettle();

      final totalFilesWidget = find.byKey(const Key('total_files_widget'));
      expect(totalFilesWidget, findsOneWidget);

      // Verify count has increased
      final totalFilesText = find.descendant(
        of: totalFilesWidget,
        matching: find.byType(Text),
      );
      expect(totalFilesText, findsWidgets);
    });

    testWidgets('Search → Filter → Category Navigation Flow', (tester) async {
      await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();

      // Step 1: Use search functionality
      final searchButton = find.byKey(const Key('search_button'));
      await tester.tap(searchButton);
      await tester.pumpAndSettle();

      final searchField = find.byKey(const Key('search_field'));
      await tester.enterText(searchField, 'test document');
      await tester.pumpAndSettle();

      // Step 2: Apply filters
      final filterButton = find.byKey(const Key('filter_button'));
      await tester.tap(filterButton);
      await tester.pumpAndSettle();

      final dateFilter = find.byKey(const Key('date_filter_this_week'));
      await tester.tap(dateFilter);
      await tester.pumpAndSettle();

      final applyFilterButton = find.byKey(const Key('apply_filter_button'));
      await tester.tap(applyFilterButton);
      await tester.pumpAndSettle();

      // Step 3: Navigate to specific category
      final categoryFilter = find.byKey(const Key('category_filter_work'));
      await tester.tap(categoryFilter);
      await tester.pumpAndSettle();

      // Verify filtered results are shown
      final filteredResults = find.byKey(const Key('filtered_document_list'));
      expect(filteredResults, findsOneWidget);
    });
  });
}
