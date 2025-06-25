import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:managementdoc/widgets/common/loading_widget.dart';
import 'package:managementdoc/widgets/common/file_filter_widget.dart';
import 'package:managementdoc/widgets/common/file_selection_bar.dart';
import 'package:managementdoc/widgets/common/app_bottom_navigation.dart';
import 'package:managementdoc/widgets/common/reusable_file_list_widget.dart';
import 'package:managementdoc/providers/file_selection_provider.dart';
import 'package:managementdoc/providers/document_provider.dart';
import 'package:managementdoc/models/document_model.dart';
import 'package:managementdoc/core/constants/app_colors.dart';
import '../helpers/mock_services.dart';

void main() {
  group('Component Widget Tests', () {
    late MockFileSelectionProvider mockFileSelectionProvider;
    late MockDocumentProvider mockDocumentProvider;

    setUp(() {
      mockFileSelectionProvider = MockFileSelectionProvider();
      mockDocumentProvider = MockDocumentProvider();

      // Setup default mock behaviors
      when(mockFileSelectionProvider.selectedFiles).thenReturn([]);
      when(mockFileSelectionProvider.isSelectionMode).thenReturn(false);
      when(mockDocumentProvider.documents).thenReturn([]);
      when(mockDocumentProvider.isLoading).thenReturn(false);
    });

    group('Loading Widget Tests', () {
      testWidgets('LoadingWidget displays correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LoadingWidget(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify loading widget components
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
      });

      testWidgets('LoadingWidget with custom message', (WidgetTester tester) async {
        const customMessage = 'Loading documents...';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LoadingWidget(message: customMessage),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text(customMessage), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('LoadingWidget animation test', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LoadingWidget(),
            ),
          ),
        );

        // Test animation frames
        await tester.pump();
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pump(const Duration(milliseconds: 100));
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('File Filter Widget Tests', () {
      testWidgets('FileFilterWidget displays filter options', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FileFilterWidget(
                onFilterChanged: (filter) {},
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify filter widget structure
        expect(find.byType(Row), findsAtLeastNWidgets(1));
        
        // Look for filter chips or buttons
        final filterChips = find.byType(FilterChip);
        final choiceChips = find.byType(ChoiceChip);
        final buttons = find.byType(ElevatedButton);

        expect(
          filterChips.evaluate().isNotEmpty ||
          choiceChips.evaluate().isNotEmpty ||
          buttons.evaluate().isNotEmpty,
          isTrue,
        );
      });

      testWidgets('FileFilterWidget filter selection', (WidgetTester tester) async {
        String? selectedFilter;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FileFilterWidget(
                onFilterChanged: (filter) {
                  selectedFilter = filter;
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Find and tap a filter option
        final filterOptions = find.byType(FilterChip);
        if (filterOptions.evaluate().isNotEmpty) {
          await tester.tap(filterOptions.first);
          await tester.pumpAndSettle();

          expect(selectedFilter, isNotNull);
        }
      });

      testWidgets('FileFilterWidget responsive layout', (WidgetTester tester) async {
        // Test on different screen sizes
        await tester.binding.setSurfaceSize(const Size(360, 640));

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FileFilterWidget(
                onFilterChanged: (filter) {},
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should not overflow on mobile
        expect(tester.takeException(), isNull);

        // Test on tablet size
        await tester.binding.setSurfaceSize(const Size(768, 1024));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      });
    });

    group('File Selection Bar Tests', () {
      testWidgets('FileSelectionBar displays when in selection mode', (WidgetTester tester) async {
        when(mockFileSelectionProvider.isSelectionMode).thenReturn(true);
        when(mockFileSelectionProvider.selectedFiles).thenReturn(['file1', 'file2']);

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<FileSelectionProvider>.value(
                value: mockFileSelectionProvider,
              ),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: FileSelectionBar(),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify selection bar components
        expect(find.text('2 selected'), findsOneWidget);
        expect(find.byIcon(Icons.close), findsOneWidget);
      });

      testWidgets('FileSelectionBar action buttons', (WidgetTester tester) async {
        when(mockFileSelectionProvider.isSelectionMode).thenReturn(true);
        when(mockFileSelectionProvider.selectedFiles).thenReturn(['file1']);

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<FileSelectionProvider>.value(
                value: mockFileSelectionProvider,
              ),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: FileSelectionBar(),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Test action buttons
        final downloadButton = find.byIcon(Icons.download);
        final shareButton = find.byIcon(Icons.share);
        final deleteButton = find.byIcon(Icons.delete);

        if (downloadButton.evaluate().isNotEmpty) {
          await tester.tap(downloadButton);
          await tester.pumpAndSettle();
        }

        if (shareButton.evaluate().isNotEmpty) {
          await tester.tap(shareButton);
          await tester.pumpAndSettle();
        }
      });

      testWidgets('FileSelectionBar close selection', (WidgetTester tester) async {
        when(mockFileSelectionProvider.isSelectionMode).thenReturn(true);

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<FileSelectionProvider>.value(
                value: mockFileSelectionProvider,
              ),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: FileSelectionBar(),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Tap close button
        final closeButton = find.byIcon(Icons.close);
        if (closeButton.evaluate().isNotEmpty) {
          await tester.tap(closeButton);
          await tester.pumpAndSettle();

          verify(mockFileSelectionProvider.clearSelection()).called(1);
        }
      });
    });

    group('Bottom Navigation Tests', () {
      testWidgets('AppBottomNavigation displays all tabs', (WidgetTester tester) async {
        int selectedIndex = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              bottomNavigationBar: AppBottomNavigation(
                currentIndex: selectedIndex,
                onTap: (index) {
                  selectedIndex = index;
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify navigation bar
        expect(find.byType(BottomNavigationBar), findsOneWidget);
        
        // Check for navigation items
        expect(find.byIcon(Icons.home), findsOneWidget);
        expect(find.byIcon(Icons.folder), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.byIcon(Icons.person), findsOneWidget);
      });

      testWidgets('AppBottomNavigation tab selection', (WidgetTester tester) async {
        int selectedIndex = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              bottomNavigationBar: AppBottomNavigation(
                currentIndex: selectedIndex,
                onTap: (index) {
                  selectedIndex = index;
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Tap different tabs
        await tester.tap(find.byIcon(Icons.folder));
        await tester.pumpAndSettle();

        expect(selectedIndex, equals(1));

        await tester.tap(find.byIcon(Icons.person));
        await tester.pumpAndSettle();

        expect(selectedIndex, equals(3));
      });

      testWidgets('AppBottomNavigation responsive design', (WidgetTester tester) async {
        // Test on different screen sizes
        await tester.binding.setSurfaceSize(const Size(360, 640));

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              bottomNavigationBar: AppBottomNavigation(
                currentIndex: 0,
                onTap: (index) {},
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should fit on mobile
        expect(tester.takeException(), isNull);

        // Test on tablet
        await tester.binding.setSurfaceSize(const Size(768, 1024));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      });
    });

    group('Reusable File List Widget Tests', () {
      testWidgets('ReusableFileListWidget displays empty state', (WidgetTester tester) async {
        when(mockDocumentProvider.documents).thenReturn([]);
        when(mockDocumentProvider.isLoading).thenReturn(false);

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<DocumentProvider>.value(
                value: mockDocumentProvider,
              ),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: ReusableFileListWidget(),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should show empty state
        expect(find.text('No documents found'), findsOneWidget);
      });

      testWidgets('ReusableFileListWidget displays loading state', (WidgetTester tester) async {
        when(mockDocumentProvider.isLoading).thenReturn(true);

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<DocumentProvider>.value(
                value: mockDocumentProvider,
              ),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: ReusableFileListWidget(),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should show loading widget
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('ReusableFileListWidget displays document list', (WidgetTester tester) async {
        final mockDocuments = [
          DocumentModel(
            id: '1',
            fileName: 'test1.pdf',
            fileSize: 1024,
            fileType: 'pdf',
            filePath: 'path/test1.pdf',
            uploadedBy: 'user1',
            uploadedAt: DateTime.now(),
            category: 'documents',
            permissions: ['user1'],
            metadata: DocumentMetadata(
              description: 'Test document 1',
              tags: ['test'],
              version: '1.0',
              contentType: 'application/pdf',
            ),
          ),
          DocumentModel(
            id: '2',
            fileName: 'test2.docx',
            fileSize: 2048,
            fileType: 'docx',
            filePath: 'path/test2.docx',
            uploadedBy: 'user1',
            uploadedAt: DateTime.now(),
            category: 'documents',
            permissions: ['user1'],
            metadata: DocumentMetadata(
              description: 'Test document 2',
              tags: ['test'],
              version: '1.0',
              contentType: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            ),
          ),
        ];

        when(mockDocumentProvider.documents).thenReturn(mockDocuments);
        when(mockDocumentProvider.isLoading).thenReturn(false);

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<DocumentProvider>.value(
                value: mockDocumentProvider,
              ),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: ReusableFileListWidget(),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should display document list
        expect(find.text('test1.pdf'), findsOneWidget);
        expect(find.text('test2.docx'), findsOneWidget);
        expect(find.byType(ListTile), findsNWidgets(2));
      });

      testWidgets('ReusableFileListWidget grid/list view toggle', (WidgetTester tester) async {
        final mockDocuments = [
          DocumentModel(
            id: '1',
            fileName: 'test1.pdf',
            fileSize: 1024,
            fileType: 'pdf',
            filePath: 'path/test1.pdf',
            uploadedBy: 'user1',
            uploadedAt: DateTime.now(),
            category: 'documents',
            permissions: ['user1'],
            metadata: DocumentMetadata(
              description: 'Test document 1',
              tags: ['test'],
              version: '1.0',
              contentType: 'application/pdf',
            ),
          ),
        ];

        when(mockDocumentProvider.documents).thenReturn(mockDocuments);
        when(mockDocumentProvider.isLoading).thenReturn(false);

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<DocumentProvider>.value(
                value: mockDocumentProvider,
              ),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: ReusableFileListWidget(),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Look for view toggle button
        final viewToggleButton = find.byIcon(Icons.view_module);
        if (viewToggleButton.evaluate().isNotEmpty) {
          await tester.tap(viewToggleButton);
          await tester.pumpAndSettle();

          // Should switch to grid view
          expect(find.byType(GridView), findsOneWidget);
        }
      });
    });

    tearDown(() {
      // Reset surface size
      tester.binding.setSurfaceSize(null);
    });
  });
}
