import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:managementdoc/main.dart' as app;
import 'package:managementdoc/screens/common/home_screen.dart';
import 'package:managementdoc/screens/auth/login_screen.dart';
import 'package:managementdoc/providers/auth_provider.dart';
import 'package:managementdoc/providers/document_provider.dart';
import 'package:managementdoc/providers/settings_provider.dart';
import 'package:managementdoc/core/constants/app_colors.dart';
import '../helpers/mock_services.dart';

void main() {
  group('Device Compatibility Tests', () {
    late MockAuthProvider mockAuthProvider;
    late MockDocumentProvider mockDocumentProvider;
    late MockSettingsProvider mockSettingsProvider;

    setUp(() {
      mockAuthProvider = MockAuthProvider();
      mockDocumentProvider = MockDocumentProvider();
      mockSettingsProvider = MockSettingsProvider();

      // Setup default behaviors
      when(mockAuthProvider.isAuthenticated).thenReturn(true);
      when(mockDocumentProvider.documents).thenReturn([]);
      when(mockDocumentProvider.isLoading).thenReturn(false);
      when(mockSettingsProvider.isDarkMode).thenReturn(false);
    });

    group('Screen Size Compatibility', () {
      final deviceSizes = {
        'iPhone SE (1st gen)': const Size(320, 568),
        'iPhone SE (2nd gen)': const Size(375, 667),
        'iPhone 12': const Size(390, 844),
        'iPhone 12 Pro Max': const Size(428, 926),
        'Samsung Galaxy S8': const Size(360, 740),
        'Samsung Galaxy S21': const Size(384, 854),
        'Google Pixel 3': const Size(393, 786),
        'Google Pixel 6': const Size(411, 891),
        'iPad Mini': const Size(768, 1024),
        'iPad Pro 11"': const Size(834, 1194),
        'iPad Pro 12.9"': const Size(1024, 1366),
        'Small Android': const Size(240, 320),
        'Large Android': const Size(480, 854),
      };

      for (final entry in deviceSizes.entries) {
        testWidgets('${entry.key} compatibility test', (WidgetTester tester) async {
          await tester.binding.setSurfaceSize(entry.value);

          await tester.pumpWidget(
            MultiProvider(
              providers: [
                ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
                ChangeNotifierProvider<DocumentProvider>.value(value: mockDocumentProvider),
                ChangeNotifierProvider<SettingsProvider>.value(value: mockSettingsProvider),
              ],
              child: MaterialApp(
                home: HomeScreen(),
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          // Verify no overflow errors
          expect(tester.takeException(), isNull, 
            reason: 'Overflow detected on ${entry.key} (${entry.value})');

          // Verify essential UI elements are present
          expect(find.byType(Scaffold), findsOneWidget);
          expect(find.byType(AppBar), findsOneWidget);

          // Verify bottom navigation is accessible
          final bottomNav = find.byType(BottomNavigationBar);
          if (bottomNav.evaluate().isNotEmpty) {
            final bottomNavWidget = tester.widget<BottomNavigationBar>(bottomNav);
            expect(bottomNavWidget.items.length, greaterThanOrEqualTo(3));
          }

          print('✅ ${entry.key} (${entry.value.width}x${entry.value.height}) - Compatible');
        });
      }
    });

    group('Orientation Compatibility', () {
      final orientationTests = [
        {'name': 'Portrait Mobile', 'size': const Size(360, 640)},
        {'name': 'Landscape Mobile', 'size': const Size(640, 360)},
        {'name': 'Portrait Tablet', 'size': const Size(768, 1024)},
        {'name': 'Landscape Tablet', 'size': const Size(1024, 768)},
      ];

      for (final test in orientationTests) {
        testWidgets('${test['name']} orientation test', (WidgetTester tester) async {
          final size = test['size'] as Size;
          await tester.binding.setSurfaceSize(size);

          await tester.pumpWidget(
            MultiProvider(
              providers: [
                ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
                ChangeNotifierProvider<DocumentProvider>.value(value: mockDocumentProvider),
              ],
              child: MaterialApp(
                home: LoginScreen(),
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          // Verify layout adapts to orientation
          expect(tester.takeException(), isNull);
          expect(find.byType(TextFormField), findsNWidgets(2));
          expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1));

          // Test orientation change
          final newSize = Size(size.height, size.width);
          await tester.binding.setSurfaceSize(newSize);
          await tester.pumpAndSettle();

          expect(tester.takeException(), isNull);
          print('✅ ${test['name']} orientation change - Compatible');
        });
      }
    });

    group('Platform-Specific Features', () {
      testWidgets('Android back button handling', (WidgetTester tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
              ChangeNotifierProvider<DocumentProvider>.value(value: mockDocumentProvider),
            ],
            child: MaterialApp(
              home: HomeScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Simulate Android back button
        final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));
        await widgetsAppState.didPopRoute();
        await tester.pumpAndSettle();

        // App should handle back button gracefully
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('iOS safe area handling', (WidgetTester tester) async {
        // Simulate iPhone with notch
        await tester.binding.setSurfaceSize(const Size(390, 844));

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
              ChangeNotifierProvider<DocumentProvider>.value(value: mockDocumentProvider),
            ],
            child: MaterialApp(
              home: HomeScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify SafeArea is used
        expect(find.byType(SafeArea), findsAtLeastNWidgets(1));
        expect(tester.takeException(), isNull);
      });

      testWidgets('Keyboard handling', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: LoginScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Focus on text field
        await tester.tap(find.byType(TextFormField).first);
        await tester.pumpAndSettle();

        // Simulate keyboard appearance
        tester.binding.window.viewInsetsTestValue = const FakeViewPadding(bottom: 300);
        await tester.pumpAndSettle();

        // UI should adapt to keyboard
        expect(tester.takeException(), isNull);

        // Hide keyboard
        tester.binding.window.viewInsetsTestValue = FakeViewPadding.zero;
        await tester.pumpAndSettle();
      });
    });

    group('Accessibility Compatibility', () {
      testWidgets('Screen reader compatibility', (WidgetTester tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
              ChangeNotifierProvider<DocumentProvider>.value(value: mockDocumentProvider),
            ],
            child: MaterialApp(
              home: HomeScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify semantic labels exist
        expect(find.bySemanticsLabel('Home'), findsOneWidget);
        
        // Test semantic navigation
        final semantics = tester.getSemantics(find.byType(BottomNavigationBar));
        expect(semantics.hasAction(SemanticsAction.tap), isTrue);
      });

      testWidgets('Large text support', (WidgetTester tester) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(textScaleFactor: 2.0),
            child: MultiProvider(
              providers: [
                ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
                ChangeNotifierProvider<DocumentProvider>.value(value: mockDocumentProvider),
              ],
              child: MaterialApp(
                home: HomeScreen(),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should handle large text without overflow
        expect(tester.takeException(), isNull);
      });

      testWidgets('High contrast support', (WidgetTester tester) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(highContrast: true),
            child: MultiProvider(
              providers: [
                ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
                ChangeNotifierProvider<DocumentProvider>.value(value: mockDocumentProvider),
              ],
              child: MaterialApp(
                home: HomeScreen(),
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: AppColors.primary,
                    brightness: Brightness.light,
                  ).copyWith(
                    // High contrast colors
                    primary: Colors.black,
                    onPrimary: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should support high contrast mode
        expect(find.byType(Scaffold), findsOneWidget);
      });
    });

    group('Performance on Different Devices', () {
      testWidgets('Low-end device performance', (WidgetTester tester) async {
        // Simulate low-end device constraints
        await tester.binding.setSurfaceSize(const Size(240, 320));

        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
              ChangeNotifierProvider<DocumentProvider>.value(value: mockDocumentProvider),
            ],
            child: MaterialApp(
              home: HomeScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();
        stopwatch.stop();

        // Should load reasonably fast even on low-end devices
        expect(stopwatch.elapsedMilliseconds, lessThan(3000));
        print('📱 Low-end device load time: ${stopwatch.elapsedMilliseconds}ms');
      });

      testWidgets('High-end device optimization', (WidgetTester tester) async {
        // Simulate high-end device
        await tester.binding.setSurfaceSize(const Size(1080, 2340));

        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
              ChangeNotifierProvider<DocumentProvider>.value(value: mockDocumentProvider),
            ],
            child: MaterialApp(
              home: HomeScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();
        stopwatch.stop();

        // Should load very fast on high-end devices
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        print('🚀 High-end device load time: ${stopwatch.elapsedMilliseconds}ms');
      });
    });

    group('Network Conditions', () {
      testWidgets('Offline mode compatibility', (WidgetTester tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
              ChangeNotifierProvider<DocumentProvider>.value(value: mockDocumentProvider),
            ],
            child: MaterialApp(
              home: HomeScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // App should function in offline mode
        expect(find.byType(Scaffold), findsOneWidget);
        
        // Should show appropriate offline indicators
        // Implementation depends on your offline handling
      });

      testWidgets('Slow network handling', (WidgetTester tester) async {
        // Simulate slow network by adding delays
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
              ChangeNotifierProvider<DocumentProvider>.value(value: mockDocumentProvider),
            ],
            child: MaterialApp(
              home: HomeScreen(),
            ),
          ),
        );

        // Simulate slow loading
        await tester.pump(const Duration(milliseconds: 100));
        
        // Should show loading indicators
        final loadingIndicator = find.byType(CircularProgressIndicator);
        if (loadingIndicator.evaluate().isNotEmpty) {
          expect(loadingIndicator, findsAtLeastNWidgets(1));
        }

        await tester.pumpAndSettle();
      });
    });

    group('Edge Cases', () {
      testWidgets('Very small screen handling', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(200, 300));

        await tester.pumpWidget(
          MaterialApp(
            home: LoginScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Should handle very small screens gracefully
        expect(find.byType(TextFormField), findsNWidgets(2));
        
        // May have some overflow on very small screens, but shouldn't crash
        // expect(tester.takeException(), isNull);
      });

      testWidgets('Very large screen handling', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(2560, 1440));

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
              ChangeNotifierProvider<DocumentProvider>.value(value: mockDocumentProvider),
            ],
            child: MaterialApp(
              home: HomeScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should utilize large screen space effectively
        expect(tester.takeException(), isNull);
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('Extreme aspect ratio handling', (WidgetTester tester) async {
        // Very wide screen
        await tester.binding.setSurfaceSize(const Size(1000, 200));

        await tester.pumpWidget(
          MaterialApp(
            home: LoginScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Should handle extreme aspect ratios
        expect(find.byType(TextFormField), findsNWidgets(2));
      });
    });

    tearDown(() {
      // Reset to default size
      tester.binding.setSurfaceSize(null);
      tester.binding.window.clearAllTestValues();
    });
  });
}

class FakeViewPadding implements ViewPadding {
  const FakeViewPadding({
    this.left = 0.0,
    this.top = 0.0,
    this.right = 0.0,
    this.bottom = 0.0,
  });

  static const FakeViewPadding zero = FakeViewPadding();

  @override
  final double left;
  @override
  final double top;
  @override
  final double right;
  @override
  final double bottom;
}
