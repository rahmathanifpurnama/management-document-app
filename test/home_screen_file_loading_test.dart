import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../lib/providers/document_provider.dart';
import '../lib/providers/auth_provider.dart';
import '../lib/providers/file_selection_provider.dart';
import '../lib/screens/common/components/home_file_list_section.dart';
import '../lib/models/document_model.dart';
import '../lib/models/user_model.dart';

// Generate mocks
@GenerateMocks([DocumentProvider, AuthProvider])
import 'home_screen_file_loading_test.mocks.dart';

void main() {
  group('Home Screen File Loading Tests', () {
    late MockDocumentProvider mockDocumentProvider;
    late MockAuthProvider mockAuthProvider;
    late FileSelectionProvider fileSelectionProvider;

    setUp(() {
      mockDocumentProvider = MockDocumentProvider();
      mockAuthProvider = MockAuthProvider();
      fileSelectionProvider = FileSelectionProvider();
    });

    testWidgets('should show loading indicator when documents are loading', (WidgetTester tester) async {
      // Arrange
      when(mockDocumentProvider.allDocuments).thenReturn([]);
      when(mockDocumentProvider.isLoading).thenReturn(true);
      when(mockDocumentProvider.getRecentDocuments()).thenReturn([]);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<DocumentProvider>.value(value: mockDocumentProvider),
              ChangeNotifierProvider<FileSelectionProvider>.value(value: fileSelectionProvider),
            ],
            child: const Scaffold(
              body: HomeFileListSection(
                searchQuery: '',
                onDocumentTap: null,
                onDocumentMenu: null,
                onFilterTap: null,
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading files...'), findsOneWidget);
    });

    testWidgets('should show empty state when no documents are available', (WidgetTester tester) async {
      // Arrange
      when(mockDocumentProvider.allDocuments).thenReturn([]);
      when(mockDocumentProvider.isLoading).thenReturn(false);
      when(mockDocumentProvider.getRecentDocuments()).thenReturn([]);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<DocumentProvider>.value(value: mockDocumentProvider),
              ChangeNotifierProvider<FileSelectionProvider>.value(value: fileSelectionProvider),
            ],
            child: const Scaffold(
              body: HomeFileListSection(
                searchQuery: '',
                onDocumentTap: null,
                onDocumentMenu: null,
                onFilterTap: null,
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('No files found'), findsOneWidget);
      expect(find.text('Files will appear here once uploaded'), findsOneWidget);
      expect(find.byIcon(Icons.folder_open), findsOneWidget);
    });

    testWidgets('should trigger document loading when documents are empty', (WidgetTester tester) async {
      // Arrange
      when(mockDocumentProvider.allDocuments).thenReturn([]);
      when(mockDocumentProvider.isLoading).thenReturn(false);
      when(mockDocumentProvider.getRecentDocuments()).thenReturn([]);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<DocumentProvider>.value(value: mockDocumentProvider),
              ChangeNotifierProvider<FileSelectionProvider>.value(value: fileSelectionProvider),
            ],
            child: const Scaffold(
              body: HomeFileListSection(
                searchQuery: '',
                onDocumentTap: null,
                onDocumentMenu: null,
                onFilterTap: null,
              ),
            ),
          ),
        ),
      );

      // Wait for post frame callbacks
      await tester.pump();

      // Assert
      verify(mockDocumentProvider.loadDocuments()).called(greaterThan(0));
    });

    testWidgets('should display documents when available', (WidgetTester tester) async {
      // Arrange
      final testDocument = DocumentModel(
        id: 'test-id',
        fileName: 'test-file.pdf',
        fileSize: 1024,
        fileType: 'pdf',
        filePath: 'test/path',
        uploadedBy: 'user-id',
        uploadedAt: DateTime.now(),
        category: 'test-category',
        permissions: ['read'],
        metadata: DocumentMetadata(
          description: 'Test document',
          tags: ['test'],
          version: '1.0',
        ),
      );

      when(mockDocumentProvider.allDocuments).thenReturn([testDocument]);
      when(mockDocumentProvider.isLoading).thenReturn(false);
      when(mockDocumentProvider.getRecentDocuments()).thenReturn([testDocument]);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<DocumentProvider>.value(value: mockDocumentProvider),
              ChangeNotifierProvider<FileSelectionProvider>.value(value: fileSelectionProvider),
            ],
            child: const Scaffold(
              body: HomeFileListSection(
                searchQuery: '',
                onDocumentTap: null,
                onDocumentMenu: null,
                onFilterTap: null,
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('test-file.pdf'), findsOneWidget);
      expect(find.text('Recent Files'), findsOneWidget);
    });
  });
}
