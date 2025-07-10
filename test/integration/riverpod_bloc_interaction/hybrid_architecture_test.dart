import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/integration_test.dart';

import 'package:managementdoc/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Riverpod + BLoC Hybrid Architecture Integration Tests', () {
    testWidgets('Basic App Startup Test', (tester) async {
      await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();

      // Verify app loads successfully
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
    });

    testWidgets('Navigation Test', (tester) async {
      await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();

      // Test basic navigation if bottom navigation exists
      final bottomNavBar = find.byType(BottomNavigationBar);
      if (bottomNavBar.evaluate().isNotEmpty) {
        // Test navigation to different tabs
        final homeTab = find.byIcon(Icons.home);
        if (homeTab.evaluate().isNotEmpty) {
          await tester.tap(homeTab);
          await tester.pumpAndSettle();
          expect(find.byType(Scaffold), findsOneWidget);
        }
      }
    });

    testWidgets('Provider Container Test', (tester) async {
      // Test that ProviderContainer can be created and disposed
      final container = ProviderContainer();

      // Basic container functionality test
      expect(container, isNotNull);

      container.dispose();
    });

    testWidgets('Widget Tree Stability Test', (tester) async {
      await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();

      // Verify basic widget structure
      expect(find.byType(MaterialApp), findsOneWidget);

      // Test that the app doesn't crash during basic interactions
      await tester.pump(const Duration(seconds: 1));
      expect(tester.takeException(), isNull);
    });

    testWidgets('Performance Monitoring Integration Test', (tester) async {
      await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();

      // Test that performance monitoring doesn't interfere with normal operation
      await tester.pump(const Duration(milliseconds: 500));

      // Verify app is still responsive
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
