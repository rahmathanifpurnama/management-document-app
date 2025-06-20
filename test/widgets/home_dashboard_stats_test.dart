import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:managementdoc/screens/common/components/home_dashboard_stats.dart';
import 'package:managementdoc/providers/user_provider.dart';
import 'package:managementdoc/providers/category_provider.dart';
import 'package:managementdoc/services/statistics_notification_service.dart';

// Mock providers for testing
class MockUserProvider extends ChangeNotifier implements UserProvider {
  @override
  List<dynamic> get users => [
    {'id': '1', 'name': 'User 1'},
    {'id': '2', 'name': 'User 2'},
  ];

  @override
  bool get isLoading => false;

  @override
  String? get errorMessage => null;

  // Add other required methods as no-ops for testing
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockCategoryProvider extends ChangeNotifier implements CategoryProvider {
  @override
  List<dynamic> get categories => [
    {'id': '1', 'name': 'Category 1'},
    {'id': '2', 'name': 'Category 2'},
    {'id': '3', 'name': 'Category 3'},
  ];

  @override
  bool get isLoading => false;

  @override
  String? get errorMessage => null;

  // Add other required methods as no-ops for testing
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('HomeDashboardStats Widget Tests', () {
    late MockUserProvider mockUserProvider;
    late MockCategoryProvider mockCategoryProvider;
    late StatisticsNotificationService statisticsService;

    setUp(() {
      mockUserProvider = MockUserProvider();
      mockCategoryProvider = MockCategoryProvider();
      statisticsService = StatisticsNotificationService.instance;
    });

    tearDown(() {
      statisticsService.dispose();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: Scaffold(
          body: MultiProvider(
            providers: [
              ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
              ChangeNotifierProvider<CategoryProvider>.value(value: mockCategoryProvider),
            ],
            child: const HomeDashboardStats(),
          ),
        ),
      );
    }

    testWidgets('should display statistics cards', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Total'), findsOneWidget);
      expect(find.text('Recent'), findsOneWidget);
      expect(find.text('Users'), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget);

      // Check that user and category counts are displayed correctly
      expect(find.text('2'), findsOneWidget); // Users count
      expect(find.text('3'), findsOneWidget); // Categories count
    });

    testWidgets('should show loading state initially', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget());

      // Assert - should show loading dots initially
      expect(find.text('...'), findsWidgets);
    });

    testWidgets('should respond to statistics updates', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act - Trigger a statistics update
      statisticsService.notifyFileDeleted(
        fileId: 'test-file',
        fileName: 'test.pdf',
        category: 'documents',
        fileSize: 1024,
      );

      // Wait for the animation and state update
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Assert - Widget should still be present and functional
      expect(find.text('Total'), findsOneWidget);
      expect(find.text('Recent'), findsOneWidget);
    });

    testWidgets('should handle file upload notifications', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act - Trigger a file upload notification
      statisticsService.notifyFileUploaded(
        fileId: 'new-file',
        fileName: 'new-file.pdf',
        category: 'documents',
        fileSize: 2048,
      );

      // Wait for the animation and state update
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Assert - Widget should still be present and functional
      expect(find.text('Total'), findsOneWidget);
      expect(find.text('Recent'), findsOneWidget);
    });

    testWidgets('should handle storage stats updates', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act - Trigger storage stats update
      statisticsService.notifyStorageStatsUpdate({
        'totalFiles': 25,
        'recentFiles': 8,
        'totalSize': 1024000,
      });

      // Wait for the animation and state update
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Assert - Should eventually show updated stats
      await tester.pumpAndSettle();
      expect(find.text('25'), findsOneWidget); // Total files
      expect(find.text('8'), findsOneWidget);  // Recent files
    });

    testWidgets('should handle refresh requests', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act - Request statistics refresh
      statisticsService.requestStatisticsRefresh(reason: 'Test refresh');

      // Wait for the animation and state update
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Assert - Widget should still be functional
      expect(find.text('Total'), findsOneWidget);
      expect(find.text('Recent'), findsOneWidget);
    });

    testWidgets('should display correct icon types', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert - Check for specific icons
      expect(find.byIcon(Icons.description), findsOneWidget); // Total files icon
      expect(find.byIcon(Icons.access_time), findsOneWidget); // Recent files icon
      expect(find.byIcon(Icons.people), findsOneWidget);      // Users icon
      expect(find.byIcon(Icons.folder), findsOneWidget);      // Categories icon
    });

    testWidgets('should handle multiple rapid updates gracefully', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act - Send multiple rapid updates
      for (int i = 0; i < 5; i++) {
        statisticsService.notifyFileDeleted(
          fileId: 'file-$i',
          fileName: 'file-$i.pdf',
          category: 'test',
          fileSize: 1000,
        );
      }

      // Wait for animations to complete
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Assert - Widget should still be stable
      expect(find.text('Total'), findsOneWidget);
      expect(find.text('Recent'), findsOneWidget);
      expect(find.text('Users'), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget);
    });
  });
}
