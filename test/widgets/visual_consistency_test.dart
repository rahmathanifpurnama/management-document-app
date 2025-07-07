import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/widgets/statistics/responsive_stats_grid.dart';

void main() {
  group('ResponsiveStatsGrid Visual Consistency Tests', () {
    late Map<String, dynamic> mockStatsData;

    setUp(() {
      mockStatsData = {
        'recentFiles': 25,
        'totalCategories': 8,
        'activeUsers': 12,
        'totalFiles': 150,
        'recycleBinCount': 5,
        'favoritesCount': 18,
      };
    });

    testWidgets('should maintain consistent container heights across all widgets', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveStatsGrid(
              statsData: mockStatsData,
            ),
          ),
        ),
      );

      // Find all Container widgets (stat widgets)
      final containers = find.byType(Container);
      expect(containers, findsAtLeastNWidgets(6)); // Should find at least 6 stat containers

      // Verify all containers have consistent minimum height constraints
      for (int i = 0; i < 6; i++) {
        final container = tester.widget<Container>(containers.at(i));
        expect(container.constraints, isNotNull);
        expect(container.constraints!.minHeight, greaterThan(0));
      }
    });

    testWidgets('should show consistent visual spacing for widgets with and without values', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveStatsGrid(
              statsData: mockStatsData,
            ),
          ),
        ),
      );

      // Verify all 6 stat widgets are rendered
      expect(find.text('Recent Files'), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget);
      expect(find.text('Users'), findsOneWidget);
      expect(find.text('Total Files'), findsOneWidget);
      expect(find.text('Recycle Bin'), findsOneWidget);
      expect(find.text('Favorites'), findsOneWidget);

      // Verify values are shown for some widgets but not others
      expect(find.text('25'), findsOneWidget); // Recent Files
      expect(find.text('8'), findsOneWidget);  // Categories
      expect(find.text('12'), findsOneWidget); // Users
      expect(find.text('150'), findsOneWidget); // Total Files
      
      // Verify values are NOT shown for Recycle Bin and Favorites
      expect(find.text('5'), findsNothing);  // Recycle Bin count should not be visible
      expect(find.text('18'), findsNothing); // Favorites count should not be visible
    });

    testWidgets('should use LayoutBuilder and Wrap for responsive layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveStatsGrid(
              statsData: mockStatsData,
            ),
          ),
        ),
      );

      // Verify responsive layout components are used
      expect(find.byType(LayoutBuilder), findsOneWidget);
      expect(find.byType(Wrap), findsOneWidget);
      expect(find.byType(GridView), findsNothing); // Should not use GridView anymore
    });

    group('StatWidget Individual Tests', () {
      testWidgets('StatWidget with showValue=true should display value', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatWidget(
                title: 'Test Widget',
                value: '42',
                color: Colors.blue,
                showValue: true,
              ),
            ),
          ),
        );

        expect(find.text('42'), findsOneWidget);
        expect(find.text('Test Widget'), findsOneWidget);
      });

      testWidgets('StatWidget with showValue=false should not display value but maintain spacing', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatWidget(
                title: 'Test Widget',
                value: '42',
                color: Colors.blue,
                showValue: false,
              ),
            ),
          ),
        );

        expect(find.text('42'), findsNothing);
        expect(find.text('Test Widget'), findsOneWidget);
        
        // Verify container has minimum height constraint for consistent sizing
        final container = tester.widget<Container>(find.byType(Container));
        expect(container.constraints, isNotNull);
        expect(container.constraints!.minHeight, greaterThan(0));
      });

      testWidgets('StatWidget should have consistent container constraints', (WidgetTester tester) async {
        // Test widget with value
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatWidget(
                title: 'With Value',
                value: '100',
                color: Colors.green,
                showValue: true,
              ),
            ),
          ),
        );

        final containerWithValue = tester.widget<Container>(find.byType(Container));
        final heightWithValue = containerWithValue.constraints!.minHeight;

        // Test widget without value
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatWidget(
                title: 'Without Value',
                value: '100',
                color: Colors.red,
                showValue: false,
              ),
            ),
          ),
        );

        final containerWithoutValue = tester.widget<Container>(find.byType(Container));
        final heightWithoutValue = containerWithoutValue.constraints!.minHeight;

        // Both should have the same minimum height for visual consistency
        expect(heightWithValue, equals(heightWithoutValue));
      });
    });

    group('Responsive Behavior Tests', () {
      testWidgets('should adapt spacing for different screen sizes', (WidgetTester tester) async {
        // Test small screen
        await tester.binding.setSurfaceSize(const Size(350, 600));
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ResponsiveStatsGrid(
                statsData: mockStatsData,
              ),
            ),
          ),
        );

        final wrapSmall = tester.widget<Wrap>(find.byType(Wrap));
        final smallSpacing = wrapSmall.spacing;

        // Test large screen
        await tester.binding.setSurfaceSize(const Size(1200, 600));
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ResponsiveStatsGrid(
                statsData: mockStatsData,
              ),
            ),
          ),
        );

        final wrapLarge = tester.widget<Wrap>(find.byType(Wrap));
        final largeSpacing = wrapLarge.spacing;

        // Large screens should have more spacing than small screens
        expect(largeSpacing, greaterThan(smallSpacing));
      });
    });
  });
}
