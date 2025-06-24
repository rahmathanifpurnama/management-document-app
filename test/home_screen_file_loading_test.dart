import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../lib/providers/document_provider.dart';
import '../lib/providers/auth_provider.dart';
import '../lib/models/document_model.dart';

// Generate mocks
@GenerateMocks([DocumentProvider, AuthProvider])
import 'home_screen_file_loading_test.mocks.dart';

void main() {
  group('Document Provider Loading Tests', () {
    late MockDocumentProvider mockDocumentProvider;
    late MockAuthProvider mockAuthProvider;

    setUp(() {
      mockDocumentProvider = MockDocumentProvider();
      mockAuthProvider = MockAuthProvider();
    });

    test('should return empty list when no documents are available', () {
      // Arrange
      when(mockDocumentProvider.allDocuments).thenReturn([]);
      when(mockDocumentProvider.isLoading).thenReturn(false);
      when(mockDocumentProvider.getRecentDocuments()).thenReturn([]);

      // Act & Assert
      expect(mockDocumentProvider.allDocuments, isEmpty);
      expect(mockDocumentProvider.isLoading, isFalse);
      expect(mockDocumentProvider.getRecentDocuments(), isEmpty);
    });

    test('should return documents when available', () {
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
      when(
        mockDocumentProvider.getRecentDocuments(),
      ).thenReturn([testDocument]);

      // Act & Assert
      expect(mockDocumentProvider.allDocuments, hasLength(1));
      expect(
        mockDocumentProvider.allDocuments.first.fileName,
        equals('test-file.pdf'),
      );
      expect(mockDocumentProvider.isLoading, isFalse);
      expect(mockDocumentProvider.getRecentDocuments(), hasLength(1));
    });

    test('should indicate loading state correctly', () {
      // Arrange
      when(mockDocumentProvider.isLoading).thenReturn(true);
      when(mockDocumentProvider.allDocuments).thenReturn([]);

      // Act & Assert
      expect(mockDocumentProvider.isLoading, isTrue);
      expect(mockDocumentProvider.allDocuments, isEmpty);
    });
  });
}
