import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

import '../lib/providers/file_selection_provider.dart';
import '../lib/widgets/admin/enhanced_bulk_operations.dart';
import '../lib/widgets/common/file_selection_bar.dart';
import '../lib/widgets/common/isolated_file_selection_provider.dart';
import '../lib/models/document_model.dart';

// Mock classes
class MockFileSelectionProvider extends Mock implements FileSelectionProvider {}

void main() {
  group('Bulk Selection Fixes Tests', () {
    late FileSelectionProvider provider;
    late List<DocumentModel> testDocuments;

    setUp(() {
      provider = FileSelectionProvider();
      testDocuments = [
        DocumentModel(
          id: 'doc1',
          fileName: 'test1.pdf',
          fileSize: 1024,
          fileType: 'pdf',
          filePath: '/test1.pdf',
          uploadedBy: 'user1',
          uploadedAt: DateTime.now(),
          category: 'Test',
          permissions: [],
        ),
        DocumentModel(
          id: 'doc2',
          fileName: 'test2.pdf',
          fileSize: 2048,
          fileType: 'pdf',
          filePath: '/test2.pdf',
          uploadedBy: 'user1',
          uploadedAt: DateTime.now(),
          category: 'Test',
          permissions: [],
        ),
      ];
    });

    tearDown(() {
      provider.dispose();
    });

    group('FileSelectionProvider Clear All Fix', () {
      test('shouldShowSelectionUI returns true when in selection mode', () {
        // Enter selection mode
        provider.enterSelectionMode(testDocuments.first, testDocuments);
        
        expect(provider.shouldShowSelectionUI, isTrue);
        expect(provider.hasSelection, isTrue);
        
        // Clear selection but stay in selection mode
        provider.clearSelection();
        
        expect(provider.shouldShowSelectionUI, isTrue);
        expect(provider.hasSelection, isFalse);
        expect(provider.isSelectionMode, isTrue);
      });

      test('clearSelection maintains selection mode', () {
        provider.enterSelectionMode(testDocuments.first, testDocuments);
        
        expect(provider.isSelectionMode, isTrue);
        expect(provider.selectedCount, equals(1));
        
        provider.clearSelection();
        
        expect(provider.isSelectionMode, isTrue);
        expect(provider.selectedCount, equals(0));
        expect(provider.hasSelection, isFalse);
      });

      test('selectAll works after clearSelection', () {
        provider.enterSelectionMode(testDocuments.first, testDocuments);
        provider.clearSelection();
        
        expect(provider.selectedCount, equals(0));
        
        provider.selectAll();
        
        expect(provider.selectedCount, equals(testDocuments.length));
        expect(provider.isAllSelected, isTrue);
      });
    });

    group('Enhanced Bulk Operations Widget Fix', () {
      testWidgets('shows UI when in selection mode even with no selections', (WidgetTester tester) async {
        provider.enterSelectionMode(testDocuments.first, testDocuments);
        provider.clearSelection(); // Clear selections but stay in selection mode

        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider<FileSelectionProvider>.value(
              value: provider,
              child: const Scaffold(
                body: EnhancedBulkOperations(),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should show the widget even with no selections
        expect(find.byType(EnhancedBulkOperations), findsOneWidget);
        expect(find.text('Select All'), findsOneWidget);
      });
    });

    group('File Selection Bar Widget Fix', () {
      testWidgets('shows Select All button when in selection mode with no selections', (WidgetTester tester) async {
        provider.enterSelectionMode(testDocuments.first, testDocuments);
        provider.clearSelection(); // Clear selections but stay in selection mode

        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider<FileSelectionProvider>.value(
              value: provider,
              child: const Scaffold(
                body: FileSelectionBar(),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should show Select All button
        expect(find.text('Select All'), findsOneWidget);
        // Should not show bulk operations button when no files selected
        expect(find.byIcon(Icons.more_vert), findsNothing);
      });
    });

    group('Isolated File Selection Provider', () {
      testWidgets('creates isolated provider instance', (WidgetTester tester) async {
        FileSelectionProvider? capturedProvider;

        await tester.pumpWidget(
          MaterialApp(
            home: IsolatedFileSelectionProvider(
              screenId: 'TestScreen',
              child: Consumer<FileSelectionProvider>(
                builder: (context, provider, child) {
                  capturedProvider = provider;
                  return Container();
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(capturedProvider, isNotNull);
        expect(capturedProvider, isNot(equals(provider))); // Should be different instance
      });
    });
  });
}
