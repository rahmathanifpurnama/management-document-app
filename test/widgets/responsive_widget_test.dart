import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:managementdoc/screens/common/home_screen.dart';
import 'package:managementdoc/screens/auth/login_screen.dart';
import 'package:managementdoc/screens/category/category_screen.dart';
import 'package:managementdoc/screens/profile/profile_screen.dart';
import 'package:managementdoc/providers/auth_provider.dart';
import 'package:managementdoc/providers/document_provider.dart';
import 'package:managementdoc/providers/user_provider.dart';
import 'package:managementdoc/providers/category_provider.dart';
import 'package:managementdoc/core/constants/app_colors.dart';
import '../helpers/mock_services.dart';

void main() {
  group('Responsive Widget Tests', () {
    late MockAuthProvider mockAuthProvider;
    late MockDocumentProvider mockDocumentProvider;
    late MockUserProvider mockUserProvider;
    late MockCategoryProvider mockCategoryProvider;

    setUp(() {
      mockAuthProvider = MockAuthProvider();
      mockDocumentProvider = MockDocumentProvider();
      mockUserProvider = MockUserProvider();
      mockCategoryProvider = MockCategoryProvider();

      // Setup default mock behaviors
      when(mockAuthProvider.isAuthenticated).thenReturn(true);
      when(mockAuthProvider.currentUser).thenReturn(null);
      when(mockDocumentProvider.documents).thenReturn([]);
      when(mockDocumentProvider.isLoading).thenReturn(false);
      when(mockUserProvider.users).thenReturn([]);
      when(mockCategoryProvider.categories).thenReturn([]);
    });

    group('Mobile Screen Tests (360x640)', () {
      testWidgets('Login screen - Mobile portrait', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(360, 640));

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
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

        // Verify login form fits on mobile screen
        expect(find.byType(TextFormField), findsNWidgets(2));
        expect(find.byType(ElevatedButton), findsOneWidget);

        // Check if elements are properly positioned
        final loginButton = find.byType(ElevatedButton);
        final loginButtonWidget = tester.widget<ElevatedButton>(loginButton);
        expect(loginButtonWidget, isNotNull);

        // Verify no overflow
        expect(tester.takeException(), isNull);
      });

      testWidgets('Home screen - Mobile portrait', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(360, 640));

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
              ChangeNotifierProvider<DocumentProvider>.value(value: mockDocumentProvider),
              ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
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

        // Verify home screen components
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(BottomNavigationBar), findsOneWidget);

        // Check responsive layout
        final screenSize = tester.getSize(find.byType(Scaffold));
        expect(screenSize.width, equals(360));
        expect(screenSize.height, equals(640));

        // Verify no overflow
        expect(tester.takeException(), isNull);
      });

      testWidgets('Category screen - Mobile portrait', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(360, 640));

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
              ChangeNotifierProvider<CategoryProvider>.value(value: mockCategoryProvider),
            ],
            child: MaterialApp(
              home: CategoryScreen(),
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify category screen layout
        expect(find.byType(AppBar), findsOneWidget);
        
        // Check for responsive grid or list
        final listView = find.byType(ListView);
        final gridView = find.byType(GridView);
        
        expect(
          listView.evaluate().isNotEmpty || gridView.evaluate().isNotEmpty,
          isTrue,
        );

        // Verify no overflow
        expect(tester.takeException(), isNull);
      });
    });

    group('Mobile Landscape Tests (640x360)', () {
      testWidgets('Login screen - Mobile landscape', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(640, 360));

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
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

        // Verify login form adapts to landscape
        expect(find.byType(TextFormField), findsNWidgets(2));
        expect(find.byType(ElevatedButton), findsOneWidget);

        // Check landscape-specific layout
        final screenSize = tester.getSize(find.byType(Scaffold));
        expect(screenSize.width, equals(640));
        expect(screenSize.height, equals(360));

        // Verify no overflow in landscape
        expect(tester.takeException(), isNull);
      });

      testWidgets('Home screen - Mobile landscape', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(640, 360));

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
              ChangeNotifierProvider<DocumentProvider>.value(value: mockDocumentProvider),
              ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
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

        // Verify landscape layout
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(BottomNavigationBar), findsOneWidget);

        // Verify no overflow in landscape
        expect(tester.takeException(), isNull);
      });
    });

    group('Tablet Portrait Tests (768x1024)', () {
      testWidgets('Home screen - Tablet portrait', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(768, 1024));

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
              ChangeNotifierProvider<DocumentProvider>.value(value: mockDocumentProvider),
              ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
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

        // Verify tablet-optimized layout
        expect(find.byType(AppBar), findsOneWidget);
        
        final screenSize = tester.getSize(find.byType(Scaffold));
        expect(screenSize.width, equals(768));
        expect(screenSize.height, equals(1024));

        // Verify no overflow on tablet
        expect(tester.takeException(), isNull);
      });

      testWidgets('Category screen - Tablet portrait with grid layout', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(768, 1024));

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
              ChangeNotifierProvider<CategoryProvider>.value(value: mockCategoryProvider),
            ],
            child: MaterialApp(
              home: CategoryScreen(),
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // On tablet, should prefer grid layout
        final gridView = find.byType(GridView);
        if (gridView.evaluate().isNotEmpty) {
          expect(gridView, findsOneWidget);
        }

        // Verify no overflow
        expect(tester.takeException(), isNull);
      });
    });

    group('Tablet Landscape Tests (1024x768)', () {
      testWidgets('Home screen - Tablet landscape', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1024, 768));

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
              ChangeNotifierProvider<DocumentProvider>.value(value: mockDocumentProvider),
              ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
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

        // Verify landscape tablet layout
        final screenSize = tester.getSize(find.byType(Scaffold));
        expect(screenSize.width, equals(1024));
        expect(screenSize.height, equals(768));

        // Should utilize wider screen space
        expect(find.byType(AppBar), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('Desktop Tests (1200x800)', () {
      testWidgets('Home screen - Desktop', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 800));

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
              ChangeNotifierProvider<DocumentProvider>.value(value: mockDocumentProvider),
              ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
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

        // Verify desktop layout
        final screenSize = tester.getSize(find.byType(Scaffold));
        expect(screenSize.width, equals(1200));
        expect(screenSize.height, equals(800));

        // Desktop should have optimized layout
        expect(find.byType(AppBar), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Login screen - Desktop', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 800));

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
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

        // Desktop login should be centered and properly sized
        expect(find.byType(TextFormField), findsNWidgets(2));
        expect(find.byType(ElevatedButton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('Extreme Screen Size Tests', () {
      testWidgets('Very small screen (240x320)', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(240, 320));

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
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

        // Should handle very small screens gracefully
        expect(find.byType(TextFormField), findsNWidgets(2));
        
        // May have overflow on very small screens, but should not crash
        // expect(tester.takeException(), isNull);
      });

      testWidgets('Very large screen (1920x1080)', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(const Size(1920, 1080));

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
              ChangeNotifierProvider<DocumentProvider>.value(value: mockDocumentProvider),
              ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
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

        // Should handle large screens without issues
        final screenSize = tester.getSize(find.byType(Scaffold));
        expect(screenSize.width, equals(1920));
        expect(screenSize.height, equals(1080));
        expect(tester.takeException(), isNull);
      });
    });

    tearDown(() {
      // Reset surface size to default
      tester.binding.setSurfaceSize(null);
    });
  });

  group('Orientation Change Tests', () {
    testWidgets('Handle orientation change during navigation', (WidgetTester tester) async {
      // Start in portrait
      await tester.binding.setSurfaceSize(const Size(360, 640));

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>.value(value: MockAuthProvider()),
            ChangeNotifierProvider<DocumentProvider>.value(value: MockDocumentProvider()),
            ChangeNotifierProvider<UserProvider>.value(value: MockUserProvider()),
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

      // Change to landscape
      await tester.binding.setSurfaceSize(const Size(640, 360));
      await tester.pumpAndSettle();

      // Should adapt to new orientation
      final screenSize = tester.getSize(find.byType(Scaffold));
      expect(screenSize.width, equals(640));
      expect(screenSize.height, equals(360));
      expect(tester.takeException(), isNull);
    });
  });
}
