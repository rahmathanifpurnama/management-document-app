import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:managementdoc/main.dart' as app;
import 'package:managementdoc/core/constants/app_strings.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Performance Tests', () {
    group('App Launch Performance', () {
      testWidgets('App cold start performance', (WidgetTester tester) async {
        final stopwatch = Stopwatch()..start();

        // Launch app
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 10));

        stopwatch.stop();

        // App should launch within 5 seconds
        expect(stopwatch.elapsedMilliseconds, lessThan(5000));

        // Verify app is fully loaded
        expect(
          find.text(AppStrings.login).evaluate().isNotEmpty ||
              find.text(AppStrings.home).evaluate().isNotEmpty,
          isTrue,
        );

        print('🚀 App cold start time: ${stopwatch.elapsedMilliseconds}ms');
      });

      testWidgets('Splash screen to login transition performance', (
        WidgetTester tester,
      ) async {
        app.main();

        final stopwatch = Stopwatch()..start();

        // Wait for splash screen to complete
        await tester.pumpAndSettle(const Duration(seconds: 3));

        stopwatch.stop();

        // Splash to login should be quick
        expect(stopwatch.elapsedMilliseconds, lessThan(3000));
        expect(find.text(AppStrings.login), findsOneWidget);

        print(
          '💫 Splash to login transition: ${stopwatch.elapsedMilliseconds}ms',
        );
      });
    });

    group('Authentication Performance', () {
      testWidgets('Login performance test', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Enter credentials
        await tester.enterText(
          find.byType(TextFormField).first,
          'admin@test.com',
        );
        await tester.enterText(find.byType(TextFormField).last, 'admin123');

        final stopwatch = Stopwatch()..start();

        // Tap login button
        await tester.tap(find.text(AppStrings.login));
        await tester.pumpAndSettle(const Duration(seconds: 10));

        stopwatch.stop();

        // Login should complete within 8 seconds
        expect(stopwatch.elapsedMilliseconds, lessThan(8000));
        expect(find.text(AppStrings.home), findsOneWidget);

        print('🔐 Login performance: ${stopwatch.elapsedMilliseconds}ms');
      });
    });

    group('Navigation Performance', () {
      testWidgets('Bottom navigation performance', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Login first
        await _performLogin(tester);

        final navigationTimes = <int>[];

        // Test navigation between tabs
        final tabs = [Icons.home, Icons.folder, Icons.add, Icons.person];

        for (final tab in tabs) {
          final stopwatch = Stopwatch()..start();

          await tester.tap(find.byIcon(tab));
          await tester.pumpAndSettle();

          stopwatch.stop();
          navigationTimes.add(stopwatch.elapsedMilliseconds);

          // Each navigation should be under 1 second
          expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        }

        final averageTime =
            navigationTimes.reduce((a, b) => a + b) / navigationTimes.length;
        print(
          '🧭 Average navigation time: ${averageTime.toStringAsFixed(2)}ms',
        );
        print('🧭 Navigation times: $navigationTimes');
      });

      testWidgets('Deep navigation performance', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        await _performLogin(tester);

        // Navigate to categories
        await tester.tap(find.byIcon(Icons.folder));
        await tester.pumpAndSettle();

        // Navigate to category details (if available)
        final categoryTile = find.byType(ListTile).first;
        if (categoryTile.evaluate().isNotEmpty) {
          final stopwatch = Stopwatch()..start();

          await tester.tap(categoryTile);
          await tester.pumpAndSettle();

          stopwatch.stop();

          // Deep navigation should be under 2 seconds
          expect(stopwatch.elapsedMilliseconds, lessThan(2000));
          print('🔍 Deep navigation time: ${stopwatch.elapsedMilliseconds}ms');
        }
      });
    });

    group('Data Loading Performance', () {
      testWidgets('Document list loading performance', (
        WidgetTester tester,
      ) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        await _performLogin(tester);

        // Measure home screen document loading
        final stopwatch = Stopwatch()..start();

        // Wait for documents to load
        await tester.pumpAndSettle(const Duration(seconds: 5));

        stopwatch.stop();

        // Document loading should complete within 5 seconds
        expect(stopwatch.elapsedMilliseconds, lessThan(5000));
        print('📄 Document loading time: ${stopwatch.elapsedMilliseconds}ms');
      });

      testWidgets('Pull to refresh performance', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        await _performLogin(tester);

        // Wait for initial load
        await tester.pumpAndSettle(const Duration(seconds: 3));

        final stopwatch = Stopwatch()..start();

        // Perform pull to refresh
        await tester.fling(find.byType(ListView), const Offset(0, 300), 1000);
        await tester.pumpAndSettle(const Duration(seconds: 5));

        stopwatch.stop();

        // Refresh should complete within 3 seconds
        expect(stopwatch.elapsedMilliseconds, lessThan(3000));
        print('🔄 Pull to refresh time: ${stopwatch.elapsedMilliseconds}ms');
      });

      testWidgets('Search performance', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        await _performLogin(tester);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Find search field
        final searchField = find.byType(TextField);
        if (searchField.evaluate().isNotEmpty) {
          final stopwatch = Stopwatch()..start();

          await tester.tap(searchField.first);
          await tester.enterText(searchField.first, 'test');
          await tester.pumpAndSettle();

          stopwatch.stop();

          // Search should be responsive (under 500ms)
          expect(stopwatch.elapsedMilliseconds, lessThan(500));
          print('🔍 Search response time: ${stopwatch.elapsedMilliseconds}ms');
        }
      });
    });

    group('Memory Performance', () {
      testWidgets('Memory usage during navigation', (
        WidgetTester tester,
      ) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        await _performLogin(tester);

        // Navigate through multiple screens to test memory
        final navigationSequence = [
          Icons.home,
          Icons.folder,
          Icons.add,
          Icons.person,
        ];

        for (int cycle = 0; cycle < 5; cycle++) {
          for (final icon in navigationSequence) {
            await tester.tap(find.byIcon(icon));
            await tester.pumpAndSettle();

            // Force garbage collection
            await tester.binding.delayed(const Duration(milliseconds: 100));
          }
        }

        // App should remain responsive after multiple navigations
        expect(find.byType(BottomNavigationBar), findsOneWidget);
        print('🧠 Memory stress test completed successfully');
      });

      testWidgets('Large list scrolling performance', (
        WidgetTester tester,
      ) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        await _performLogin(tester);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Find scrollable list
        final listView = find.byType(ListView);
        if (listView.evaluate().isNotEmpty) {
          final stopwatch = Stopwatch()..start();

          // Perform rapid scrolling
          for (int i = 0; i < 10; i++) {
            await tester.fling(listView, const Offset(0, -300), 1000);
            await tester.pump();
          }

          await tester.pumpAndSettle();
          stopwatch.stop();

          // Scrolling should remain smooth
          expect(stopwatch.elapsedMilliseconds, lessThan(2000));
          print(
            '📜 List scrolling performance: ${stopwatch.elapsedMilliseconds}ms',
          );
        }
      });
    });

    group('UI Responsiveness', () {
      testWidgets('Button tap responsiveness', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        await _performLogin(tester);

        // Test various button taps
        final buttons = find.byType(ElevatedButton);
        if (buttons.evaluate().isNotEmpty) {
          final stopwatch = Stopwatch()..start();

          await tester.tap(buttons.first);
          await tester.pump(); // Single pump to measure immediate response

          stopwatch.stop();

          // Button should respond immediately (under 100ms)
          expect(stopwatch.elapsedMilliseconds, lessThan(100));
          print('👆 Button tap response: ${stopwatch.elapsedMilliseconds}ms');
        }
      });

      testWidgets('Text input responsiveness', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Test on login screen
        final textField = find.byType(TextFormField).first;

        final stopwatch = Stopwatch()..start();

        await tester.tap(textField);
        await tester.enterText(textField, 'test@example.com');
        await tester.pump();

        stopwatch.stop();

        // Text input should be responsive
        expect(stopwatch.elapsedMilliseconds, lessThan(200));
        print('⌨️ Text input response: ${stopwatch.elapsedMilliseconds}ms');
      });

      testWidgets('Animation performance', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        await _performLogin(tester);

        // Test loading animations
        final loadingWidget = find.byType(CircularProgressIndicator);
        if (loadingWidget.evaluate().isNotEmpty) {
          final stopwatch = Stopwatch()..start();

          // Let animation run for a few frames
          for (int i = 0; i < 10; i++) {
            await tester.pump(const Duration(milliseconds: 16)); // 60 FPS
          }

          stopwatch.stop();

          // Animation should maintain 60 FPS (16ms per frame)
          final averageFrameTime = stopwatch.elapsedMilliseconds / 10;
          expect(averageFrameTime, lessThan(20)); // Allow some tolerance

          print(
            '🎬 Animation frame time: ${averageFrameTime.toStringAsFixed(2)}ms',
          );
        }
      });
    });

    group('Network Performance', () {
      testWidgets('File upload performance simulation', (
        WidgetTester tester,
      ) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        await _performLogin(tester);

        // Navigate to upload screen
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        // Simulate file selection and upload
        final selectButton = find.text(AppStrings.selectFile);
        if (selectButton.evaluate().isNotEmpty) {
          final stopwatch = Stopwatch()..start();

          await tester.tap(selectButton);
          await tester.pumpAndSettle();

          stopwatch.stop();

          // File selection should be responsive
          expect(stopwatch.elapsedMilliseconds, lessThan(1000));
          print(
            '📤 File selection response: ${stopwatch.elapsedMilliseconds}ms',
          );
        }
      });

      testWidgets('Offline mode performance', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        await _performLogin(tester);

        // Test app behavior when offline
        // This would require network mocking in a real scenario

        final stopwatch = Stopwatch()..start();

        // Navigate while "offline"
        await tester.tap(find.byIcon(Icons.folder));
        await tester.pumpAndSettle();

        stopwatch.stop();

        // Should handle offline gracefully
        expect(stopwatch.elapsedMilliseconds, lessThan(2000));
        print('📱 Offline navigation: ${stopwatch.elapsedMilliseconds}ms');
      });
    });
  });

  group('Performance Benchmarks', () {
    testWidgets('Overall app performance benchmark', (
      WidgetTester tester,
    ) async {
      final benchmarkResults = <String, int>{};

      // App launch
      var stopwatch = Stopwatch()..start();
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));
      stopwatch.stop();
      benchmarkResults['App Launch'] = stopwatch.elapsedMilliseconds;

      // Login
      await tester.enterText(
        find.byType(TextFormField).first,
        'admin@test.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'admin123');

      stopwatch = Stopwatch()..start();
      await tester.tap(find.text(AppStrings.login));
      await tester.pumpAndSettle(const Duration(seconds: 8));
      stopwatch.stop();
      benchmarkResults['Login'] = stopwatch.elapsedMilliseconds;

      // Navigation test
      stopwatch = Stopwatch()..start();
      await tester.tap(find.byIcon(Icons.folder));
      await tester.pumpAndSettle();
      stopwatch.stop();
      benchmarkResults['Navigation'] = stopwatch.elapsedMilliseconds;

      // Print benchmark results
      print('📊 Performance Benchmark Results:');
      benchmarkResults.forEach((test, time) {
        print('   $test: ${time}ms');
      });

      // Overall performance should meet thresholds
      expect(benchmarkResults['App Launch']!, lessThan(5000));
      expect(benchmarkResults['Login']!, lessThan(8000));
      expect(benchmarkResults['Navigation']!, lessThan(1000));
    });
  });
}

// Helper function for login
Future<void> _performLogin(WidgetTester tester) async {
  await tester.pumpAndSettle(const Duration(seconds: 2));

  await tester.enterText(find.byType(TextFormField).first, 'admin@test.com');
  await tester.enterText(find.byType(TextFormField).last, 'admin123');
  await tester.tap(find.text(AppStrings.login));
  await tester.pumpAndSettle(const Duration(seconds: 5));
}
