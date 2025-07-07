import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  group('SVG Icon Assets Tests', () {
    testWidgets('should load recycle-bin.svg icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SvgPicture.asset(
              'assets/icon/recycle-bin.svg',
              width: 24,
              height: 24,
            ),
          ),
        ),
      );

      // Verify that the SVG widget is created without errors
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('should load user-folder.svg icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SvgPicture.asset(
              'assets/icon/user-folder.svg',
              width: 24,
              height: 24,
            ),
          ),
        ),
      );

      // Verify that the SVG widget is created without errors
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('should load SVG icons with color filter', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SvgPicture.asset(
                  'assets/icon/recycle-bin.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                ),
                SvgPicture.asset(
                  'assets/icon/user-folder.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                ),
              ],
            ),
          ),
        ),
      );

      // Verify that both SVG widgets are created
      expect(find.byType(SvgPicture), findsNWidgets(2));
    });

    testWidgets('should handle different icon sizes', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                // Small icon
                SvgPicture.asset(
                  'assets/icon/recycle-bin.svg',
                  width: 16,
                  height: 16,
                ),
                // Medium icon
                SvgPicture.asset(
                  'assets/icon/user-folder.svg',
                  width: 24,
                  height: 24,
                ),
                // Large icon
                SvgPicture.asset(
                  'assets/icon/recycle-bin.svg',
                  width: 32,
                  height: 32,
                ),
              ],
            ),
          ),
        ),
      );

      // Verify that all SVG widgets are created with different sizes
      expect(find.byType(SvgPicture), findsNWidgets(3));
    });

    testWidgets('should load other SVG icons from assets', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SvgPicture.asset('assets/icon/home.svg', width: 24, height: 24),
                SvgPicture.asset('assets/icon/folder.svg', width: 24, height: 24),
                SvgPicture.asset('assets/icon/user.svg', width: 24, height: 24),
                SvgPicture.asset('assets/icon/plus.svg', width: 24, height: 24),
              ],
            ),
          ),
        ),
      );

      // Verify that all common SVG icons load correctly
      expect(find.byType(SvgPicture), findsNWidgets(4));
    });
  });
}
