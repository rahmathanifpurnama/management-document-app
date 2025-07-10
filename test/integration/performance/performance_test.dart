import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:managementdoc/main.dart' as app;
import 'package:managementdoc/core/monitoring/performance_monitor.dart';
import 'package:managementdoc/core/optimization/startup_optimizer.dart';
import 'package:managementdoc/core/optimization/memory_optimizer.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Performance Integration Tests', () {
    
    setUpAll(() {
      // Initialize performance monitoring
      StartupOptimizer.initialize();
      MemoryOptimizer.startMonitoring(interval: const Duration(seconds: 30));
    });

    tearDownAll(() {
      // Cleanup performance monitoring
      MemoryOptimizer.stopMonitoring();
      MemoryOptimizer.dispose();
    });

    testWidgets('App Startup Performance Test', (tester) async {
      final startTime = DateTime.now();
      
      // Mark startup milestone
      StartupOptimizer.markMilestone('test_start');
      
      // Start the app
      await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();
      
      final endTime = DateTime.now();
      final startupDuration = endTime.difference(startTime);
      
      // Mark completion milestone
      StartupOptimizer.markMilestone('test_complete');
      
      // Verify app started within reasonable time (adjust threshold as needed)
      expect(startupDuration.inMilliseconds, lessThan(5000), 
        reason: 'App startup took ${startupDuration.inMilliseconds}ms, which exceeds 5000ms threshold');
      
      // Verify main UI elements are present
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      
      print('✅ App startup completed in ${startupDuration.inMilliseconds}ms');
    });

    testWidgets('Navigation Performance Test', (tester) async {
      await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();

      final navigationTimes = <String, Duration>{};

      // Test navigation to different tabs
      final tabs = [
        {'key': 'upload_tab', 'name': 'Upload'},
        {'key': 'documents_tab', 'name': 'Documents'},
        {'key': 'categories_tab', 'name': 'Categories'},
        {'key': 'profile_tab', 'name': 'Profile'},
        {'key': 'home_tab', 'name': 'Home'},
      ];

      for (final tab in tabs) {
        final startTime = DateTime.now();
        
        final tabWidget = find.byKey(Key(tab['key']!));
        if (tabWidget.evaluate().isNotEmpty) {
          await tester.tap(tabWidget);
          await tester.pumpAndSettle();
          
          final endTime = DateTime.now();
          final navigationTime = endTime.difference(startTime);
          navigationTimes[tab['name']!] = navigationTime;
          
          // Track navigation performance
          PerformanceMonitor.trackNavigation(tab['name']!, navigationTime);
          
          // Verify navigation completed within reasonable time
          expect(navigationTime.inMilliseconds, lessThan(2000),
            reason: 'Navigation to ${tab['name']} took ${navigationTime.inMilliseconds}ms');
          
          print('📍 Navigation to ${tab['name']}: ${navigationTime.inMilliseconds}ms');
        }
      }

      // Print navigation summary
      print('\n📊 Navigation Performance Summary:');
      navigationTimes.forEach((tab, duration) {
        print('  $tab: ${duration.inMilliseconds}ms');
      });
    });

    testWidgets('Widget Rebuild Performance Test', (tester) async {
      await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();

      // Clear previous rebuild counts
      PerformanceMonitor.clearMetrics();

      // Perform actions that might trigger rebuilds
      final actions = [
        () async {
          // Navigate to upload tab
          final uploadTab = find.byKey(const Key('upload_tab'));
          if (uploadTab.evaluate().isNotEmpty) {
            await tester.tap(uploadTab);
            await tester.pumpAndSettle();
          }
        },
        () async {
          // Open file selection
          final selectFileButton = find.byKey(const Key('select_file_button'));
          if (selectFileButton.evaluate().isNotEmpty) {
            await tester.tap(selectFileButton);
            await tester.pumpAndSettle();
          }
        },
        () async {
          // Navigate to settings
          final profileTab = find.byKey(const Key('profile_tab'));
          if (profileTab.evaluate().isNotEmpty) {
            await tester.tap(profileTab);
            await tester.pumpAndSettle();
            
            final settingsButton = find.byKey(const Key('settings_button'));
            if (settingsButton.evaluate().isNotEmpty) {
              await tester.tap(settingsButton);
              await tester.pumpAndSettle();
            }
          }
        },
      ];

      for (int i = 0; i < actions.length; i++) {
        print('🔄 Performing action ${i + 1}/${actions.length}');
        await actions[i]();
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Get rebuild statistics
      final report = PerformanceMonitor.getReport();
      final topRebuildingWidgets = PerformanceMonitor.getTopRebuildingWidgets(limit: 5);

      print('\n🔄 Widget Rebuild Summary:');
      for (final entry in topRebuildingWidgets) {
        print('  ${entry.key}: ${entry.value} rebuilds');
        
        // Warn about excessive rebuilds
        if (entry.value > 10) {
          print('  ⚠️ ${entry.key} has high rebuild count (${entry.value})');
        }
      }

      // Verify no widget has excessive rebuilds
      for (final entry in topRebuildingWidgets) {
        expect(entry.value, lessThan(20),
          reason: '${entry.key} has excessive rebuilds (${entry.value})');
      }
    });

    testWidgets('Memory Usage Performance Test', (tester) async {
      await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();

      // Track initial memory
      await PerformanceMonitor.trackMemoryUsage();
      
      // Perform memory-intensive operations
      final operations = [
        () async {
          // Navigate through all tabs multiple times
          final tabs = ['upload_tab', 'documents_tab', 'categories_tab', 'profile_tab'];
          for (int i = 0; i < 3; i++) {
            for (final tabKey in tabs) {
              final tab = find.byKey(Key(tabKey));
              if (tab.evaluate().isNotEmpty) {
                await tester.tap(tab);
                await tester.pumpAndSettle();
              }
            }
          }
        },
        () async {
          // Simulate file operations
          final uploadTab = find.byKey(const Key('upload_tab'));
          if (uploadTab.evaluate().isNotEmpty) {
            await tester.tap(uploadTab);
            await tester.pumpAndSettle();
            
            // Simulate multiple file selections
            for (int i = 0; i < 5; i++) {
              final selectButton = find.byKey(const Key('select_file_button'));
              if (selectButton.evaluate().isNotEmpty) {
                await tester.tap(selectButton);
                await tester.pumpAndSettle();
                await tester.pump(const Duration(milliseconds: 500));
              }
            }
          }
        },
      ];

      for (int i = 0; i < operations.length; i++) {
        print('💾 Performing memory operation ${i + 1}/${operations.length}');
        await operations[i]();
        await PerformanceMonitor.trackMemoryUsage();
        await tester.pump(const Duration(milliseconds: 500));
      }

      // Get memory report
      final memoryReport = MemoryOptimizer.getMemoryReport();
      print('\n💾 Memory Usage Report:');
      print(memoryReport.getFormattedReport());

      // Verify memory usage is within acceptable limits
      expect(memoryReport.trackedObjectCount, lessThan(100),
        reason: 'Too many tracked objects (${memoryReport.trackedObjectCount})');
      
      // Check for memory optimization suggestions
      if (memoryReport.suggestions.isNotEmpty) {
        print('\n💡 Memory Optimization Suggestions:');
        for (final suggestion in memoryReport.suggestions) {
          print('  • $suggestion');
        }
      }
    });

    testWidgets('Scroll Performance Test', (tester) async {
      await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();

      // Navigate to a screen with scrollable content
      final documentsTab = find.byKey(const Key('documents_tab'));
      if (documentsTab.evaluate().isNotEmpty) {
        await tester.tap(documentsTab);
        await tester.pumpAndSettle();

        // Find scrollable widget
        final scrollableWidget = find.byType(Scrollable).first;
        
        if (scrollableWidget.evaluate().isNotEmpty) {
          final startTime = DateTime.now();
          
          // Perform scroll operations
          await tester.drag(scrollableWidget, const Offset(0, -300));
          await tester.pumpAndSettle();
          
          await tester.drag(scrollableWidget, const Offset(0, 300));
          await tester.pumpAndSettle();
          
          final endTime = DateTime.now();
          final scrollDuration = endTime.difference(startTime);
          
          print('📜 Scroll performance: ${scrollDuration.inMilliseconds}ms');
          
          // Verify scroll performance
          expect(scrollDuration.inMilliseconds, lessThan(1000),
            reason: 'Scroll operation took too long (${scrollDuration.inMilliseconds}ms)');
        }
      }
    });

    testWidgets('Overall Performance Summary', (tester) async {
      // Generate comprehensive performance report
      final performanceReport = PerformanceMonitor.getReport();
      final startupMetrics = StartupOptimizer.getMetrics();
      final memoryReport = MemoryOptimizer.getMemoryReport();

      print('\n📊 Overall Performance Summary');
      print('=' * 50);
      
      // Startup metrics
      if (startupMetrics.startupDuration != null) {
        print('⚡ Startup Time: ${startupMetrics.startupDuration!.inMilliseconds}ms');
      }
      
      // Widget rebuild summary
      final topWidgets = PerformanceMonitor.getTopRebuildingWidgets(limit: 3);
      if (topWidgets.isNotEmpty) {
        print('\n🔄 Top Rebuilding Widgets:');
        for (final entry in topWidgets) {
          print('  ${entry.key}: ${entry.value} rebuilds');
        }
      }
      
      // Memory summary
      print('\n💾 Memory Usage:');
      print('  Tracked Objects: ${memoryReport.trackedObjectCount}');
      print('  Image Cache: ${memoryReport.imageCacheSize}/${memoryReport.maxImageCacheSize}');
      
      // Performance recommendations
      final startupRecommendations = StartupOptimizer.getPerformanceRecommendations();
      final memoryRecommendations = memoryReport.suggestions;
      
      if (startupRecommendations.isNotEmpty || memoryRecommendations.isNotEmpty) {
        print('\n💡 Performance Recommendations:');
        for (final rec in startupRecommendations) {
          print('  • $rec');
        }
        for (final rec in memoryRecommendations) {
          print('  • $rec');
        }
      }
      
      print('\n✅ Performance testing completed successfully!');
    });
  });
}
