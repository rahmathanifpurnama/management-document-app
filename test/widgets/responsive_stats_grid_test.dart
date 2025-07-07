import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../lib/widgets/statistics/responsive_stats_grid.dart';
import '../../lib/core/constants/app_colors.dart';

void main() {
  group('ResponsiveStatsGrid Tests', () {
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

    testWidgets('should render all stat widgets', (WidgetTester tester) async {
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
    });

    testWidgets('should show values for Recent Files, Categories, Users, and Total Files', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveStatsGrid(
              statsData: mockStatsData,
            ),
          ),
        ),
      );

      // Verify numeric values are shown for these widgets
      expect(find.text('25'), findsOneWidget); // Recent Files
      expect(find.text('8'), findsOneWidget);  // Categories
      expect(find.text('12'), findsOneWidget); // Users
      expect(find.text('150'), findsOneWidget); // Total Files
    });

    testWidgets('should NOT show values for Recycle Bin and Favorites', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveStatsGrid(
              statsData: mockStatsData,
            ),
          ),
        ),
      );

      // Verify numeric values are NOT shown for these widgets
      expect(find.text('5'), findsNothing);  // Recycle Bin count should not be visible
      expect(find.text('18'), findsNothing); // Favorites count should not be visible
    });

    testWidgets('should use SVG icons for Recycle Bin and Favorites', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveStatsGrid(
              statsData: mockStatsData,
            ),
          ),
        ),
      );

      // Verify SVG icons are used
      expect(find.byType(SvgPicture), findsAtLeastNWidgets(2));
    });

    testWidgets('should handle tap events', (WidgetTester tester) async {
      String? tappedStat;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveStatsGrid(
              statsData: mockStatsData,
              onStatTap: (stat) => tappedStat = stat,
            ),
          ),
        ),
      );

      // Test tapping on Recent Files
      await tester.tap(find.text('Recent Files'));
      await tester.pump();
      expect(tappedStat, equals('recent'));

      // Test tapping on Recycle Bin
      await tester.tap(find.text('Recycle Bin'));
      await tester.pump();
      expect(tappedStat, equals('recycle'));

      // Test tapping on Favorites
      await tester.tap(find.text('Favorites'));
      await tester.pump();
      expect(tappedStat, equals('favorites'));
    });

    testWidgets('should use Wrap widget for responsive layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveStatsGrid(
              statsData: mockStatsData,
            ),
          ),
        ),
      );

      // Verify Wrap widget is used instead of GridView
      expect(find.byType(Wrap), findsOneWidget);
      expect(find.byType(GridView), findsNothing);
    });

    testWidgets('should use LayoutBuilder for responsive behavior', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveStatsGrid(
              statsData: mockStatsData,
            ),
          ),
        ),
      );

      // Verify LayoutBuilder is used
      expect(find.byType(LayoutBuilder), findsOneWidget);
    });

    testWidgets('should show loading state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveStatsGrid(
              statsData: mockStatsData,
              isLoading: true,
            ),
          ),
        ),
      );

      // Verify loading containers are shown for widgets that display values
      expect(find.byType(Container), findsAtLeastNWidgets(4)); // For the 4 widgets that show values
    });

    group('Responsive Layout Tests', () {
      testWidgets('should adapt to very small screens (< 300px)', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(250, 600));
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ResponsiveStatsGrid(
                statsData: mockStatsData,
              ),
            ),
          ),
        );

        // Should have 1 widget per row on very small screens
        final wrap = tester.widget<Wrap>(find.byType(Wrap));
        expect(wrap.spacing, equals(4.0));
      });

      testWidgets('should adapt to small screens (< 400px)', (WidgetTester tester) async {
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

        // Should have 2 widgets per row on small screens
        final wrap = tester.widget<Wrap>(find.byType(Wrap));
        expect(wrap.spacing, equals(4.0));
      });

      testWidgets('should adapt to medium screens (400-600px)', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(500, 600));
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ResponsiveStatsGrid(
                statsData: mockStatsData,
              ),
            ),
          ),
        );

        // Should have 3 widgets per row on medium screens
        final wrap = tester.widget<Wrap>(find.byType(Wrap));
        expect(wrap.spacing, equals(6.0));
      });

      testWidgets('should adapt to current screen width (600-900px)', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(750, 600));
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ResponsiveStatsGrid(
                statsData: mockStatsData,
              ),
            ),
          ),
        );

        // Should have 4 widgets per row on current screen width
        final wrap = tester.widget<Wrap>(find.byType(Wrap));
        expect(wrap.spacing, equals(8.0));
      });

      testWidgets('should adapt to extra wide screens (> 900px)', (WidgetTester tester) async {
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

        // Should have 5 widgets per row on extra wide screens
        final wrap = tester.widget<Wrap>(find.byType(Wrap));
        expect(wrap.spacing, equals(10.0));
      });
    });

    group('StatWidget Tests', () {
      testWidgets('should show value when showValue is true', (WidgetTester tester) async {
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

      testWidgets('should hide value when showValue is false', (WidgetTester tester) async {
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
      });
    });
  });
}
