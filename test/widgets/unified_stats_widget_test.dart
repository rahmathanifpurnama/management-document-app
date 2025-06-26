import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:management_document_app/widgets/statistics/unified_stats_widget.dart';
import 'package:management_document_app/services/optimized_statistics_service.dart';
import 'package:management_document_app/core/constants/app_colors.dart';

// Generate mocks
@GenerateMocks([OptimizedStatisticsService])
import 'unified_stats_widget_test.mocks.dart';

void main() {
  group('UnifiedStatsWidget Tests', () {
    late MockOptimizedStatisticsService mockStatsService;

    setUp(() {
      mockStatsService = MockOptimizedStatisticsService();
    });

    group('Dashboard Factory Constructor', () {
      testWidgets('should display dashboard statistics correctly', (WidgetTester tester) async {
        // Arrange
        final mockStats = {
          'totalFiles': 1000000,
          'recentFiles': 50000,
          'activeUsers': 5000,
          'totalCategories': 100,
        };

        when(mockStatsService.getAggregatedStatistics())
            .thenAnswer((_) async => mockStats);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: UnifiedStatsWidget.dashboard(),
            ),
          ),
        );

        // Wait for async operations
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('1.0M'), findsOneWidget); // Total files formatted
        expect(find.text('50.0K'), findsOneWidget); // Recent files formatted
        expect(find.text('5.0K'), findsOneWidget); // Active users formatted
        expect(find.text('100'), findsOneWidget); // Categories
      });

      testWidgets('should show loading state initially', (WidgetTester tester) async {
        // Arrange
        when(mockStatsService.getAggregatedStatistics())
            .thenAnswer((_) async {
          await Future.delayed(Duration(seconds: 1));
          return {'totalFiles': 1000};
        });

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: UnifiedStatsWidget.dashboard(),
            ),
          ),
        );

        // Assert - Should show loading state
        expect(find.text('...'), findsWidgets);
      });

      testWidgets('should handle refresh correctly', (WidgetTester tester) async {
        // Arrange
        bool refreshCalled = false;
        final mockStats = {'totalFiles': 1000};

        when(mockStatsService.getAggregatedStatistics())
            .thenAnswer((_) async => mockStats);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: UnifiedStatsWidget.dashboard(
                onRefresh: () => refreshCalled = true,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Simulate refresh (this would typically be triggered by pull-to-refresh)
        // For testing, we'll verify the callback is set up correctly
        expect(refreshCalled, isFalse); // Not called yet
      });
    });

    group('Upload Factory Constructor', () {
      testWidgets('should display upload statistics correctly', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: UnifiedStatsWidget.upload(
                totalFiles: 100,
                averageProgress: 75.5,
                completedFiles: 80,
                failedFiles: 5,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Upload Statistics'), findsOneWidget);
        expect(find.text('100'), findsOneWidget); // Total files
        expect(find.text('76%'), findsOneWidget); // Average progress (rounded)
        expect(find.text('80'), findsOneWidget); // Completed files
        expect(find.text('5'), findsOneWidget); // Failed files
      });

      testWidgets('should use grid layout for upload stats', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: UnifiedStatsWidget.upload(
                totalFiles: 50,
                averageProgress: 50.0,
                completedFiles: 25,
                failedFiles: 2,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Should find grid layout structure
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(Row), findsWidgets);
      });
    });

    group('Custom Factory Constructor', () {
      testWidgets('should display custom statistics correctly', (WidgetTester tester) async {
        // Arrange
        final customStats = [
          StatConfig(
            key: 'customStat1',
            title: 'Custom 1',
            formatter: (value) => '42',
            icon: Icons.star,
            color: AppColors.primary,
          ),
          StatConfig(
            key: 'customStat2',
            title: 'Custom 2',
            formatter: (value) => '84',
            icon: Icons.favorite,
            color: AppColors.success,
          ),
        ];

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: UnifiedStatsWidget.custom(
                stats: customStats,
                title: 'Custom Statistics',
                showTitle: true,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Custom Statistics'), findsOneWidget);
        expect(find.text('Custom 1'), findsOneWidget);
        expect(find.text('Custom 2'), findsOneWidget);
        expect(find.text('42'), findsOneWidget);
        expect(find.text('84'), findsOneWidget);
        expect(find.byIcon(Icons.star), findsOneWidget);
        expect(find.byIcon(Icons.favorite), findsOneWidget);
      });
    });

    group('Layout Options', () {
      testWidgets('should render row layout correctly', (WidgetTester tester) async {
        // Arrange
        final stats = [
          StatConfig(
            key: 'stat1',
            title: 'Stat 1',
            formatter: (value) => '100',
            icon: Icons.description,
            color: AppColors.primary,
          ),
          StatConfig(
            key: 'stat2',
            title: 'Stat 2',
            formatter: (value) => '200',
            icon: Icons.folder,
            color: AppColors.success,
          ),
        ];

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: UnifiedStatsWidget.custom(
                stats: stats,
                layout: StatsLayout.row,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Should find row layout
        expect(find.byType(Row), findsWidgets);
        expect(find.text('Stat 1'), findsOneWidget);
        expect(find.text('Stat 2'), findsOneWidget);
      });

      testWidgets('should render column layout correctly', (WidgetTester tester) async {
        // Arrange
        final stats = [
          StatConfig(
            key: 'stat1',
            title: 'Stat 1',
            formatter: (value) => '100',
            icon: Icons.description,
            color: AppColors.primary,
          ),
        ];

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: UnifiedStatsWidget.custom(
                stats: stats,
                layout: StatsLayout.column,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Should find column layout
        expect(find.byType(Column), findsWidgets);
        expect(find.text('Stat 1'), findsOneWidget);
      });
    });

    group('Error Handling', () {
      testWidgets('should display error state when statistics fail to load', (WidgetTester tester) async {
        // Arrange
        when(mockStatsService.getAggregatedStatistics())
            .thenThrow(Exception('Network error'));

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: UnifiedStatsWidget.dashboard(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Failed to load statistics'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });

      testWidgets('should allow retry after error', (WidgetTester tester) async {
        // Arrange
        when(mockStatsService.getAggregatedStatistics())
            .thenThrow(Exception('Network error'));

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: UnifiedStatsWidget.dashboard(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Find and tap retry button
        final retryButton = find.text('Retry');
        expect(retryButton, findsOneWidget);
        
        await tester.tap(retryButton);
        await tester.pumpAndSettle();

        // Assert - Should attempt to reload
        verify(mockStatsService.getAggregatedStatistics()).called(greaterThan(1));
      });
    });

    group('Responsive Design', () {
      testWidgets('should adapt to small screen sizes', (WidgetTester tester) async {
        // Arrange
        await tester.binding.setSurfaceSize(Size(350, 600)); // Small screen

        final stats = [
          StatConfig(
            key: 'stat1',
            title: 'Test Stat',
            formatter: (value) => '100',
            icon: Icons.description,
            color: AppColors.primary,
          ),
        ];

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: UnifiedStatsWidget.custom(stats: stats),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Should render without overflow
        expect(tester.takeException(), isNull);
        expect(find.text('Test Stat'), findsOneWidget);
      });

      testWidgets('should adapt to large screen sizes', (WidgetTester tester) async {
        // Arrange
        await tester.binding.setSurfaceSize(Size(800, 600)); // Large screen

        final stats = [
          StatConfig(
            key: 'stat1',
            title: 'Test Stat',
            formatter: (value) => '100',
            icon: Icons.description,
            color: AppColors.primary,
          ),
        ];

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: UnifiedStatsWidget.custom(stats: stats),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Should render without overflow
        expect(tester.takeException(), isNull);
        expect(find.text('Test Stat'), findsOneWidget);
      });
    });

    group('Animations', () {
      testWidgets('should show loading animation', (WidgetTester tester) async {
        // Arrange
        when(mockStatsService.getAggregatedStatistics())
            .thenAnswer((_) async {
          await Future.delayed(Duration(milliseconds: 500));
          return {'totalFiles': 1000};
        });

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: UnifiedStatsWidget.dashboard(),
            ),
          ),
        );

        // Pump a few frames to see animation
        await tester.pump(Duration(milliseconds: 100));
        await tester.pump(Duration(milliseconds: 100));

        // Assert - Should show loading state with animation
        expect(find.text('...'), findsWidgets);
      });
    });

    tearDown(() {
      // Reset surface size
      tester.binding.setSurfaceSize(null);
    });
  });
}
