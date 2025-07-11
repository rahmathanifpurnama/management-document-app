import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:managementdoc/features/documents/bloc/document_bloc.dart';
import 'package:managementdoc/features/documents/bloc/document_state.dart';
import 'package:managementdoc/features/documents/bloc/document_event.dart';
import 'package:managementdoc/features/documents/repositories/document_repository.dart';
import 'package:managementdoc/models/document_model.dart';

class MockDocumentRepository extends Mock implements DocumentRepository {}

void main() {
  group('DocumentBloc Tests', () {
    late DocumentBloc documentBloc;
    late MockDocumentRepository mockRepository;

    setUp(() {
      mockRepository = MockDocumentRepository();
      documentBloc = DocumentBloc(repository: mockRepository);
    });

    tearDown(() {
      documentBloc.close();
    });

    blocTest<DocumentBloc, DocumentState>(
      'emits [loading, loaded] when LoadDocuments is added',
      build: () {
        when(
          mockRepository.getAllDocuments(),
        ).thenAnswer((_) async => [_createMockDocument()]);
        return documentBloc;
      },
      act: (bloc) => bloc.add(const DocumentEvent.loadDocuments()),
      expect: () => [const DocumentState.loading(), isA<DocumentLoaded>()],
    );

    blocTest<DocumentBloc, DocumentState>(
      'emits [loading, error] when repository throws exception',
      build: () {
        when(
          mockRepository.getAllDocuments(),
        ).thenThrow(Exception('Network error'));
        return documentBloc;
      },
      act: (bloc) => bloc.add(const DocumentEvent.loadDocuments()),
      expect: () => [const DocumentState.loading(), isA<DocumentError>()],
    );

    blocTest<DocumentBloc, DocumentState>(
      'filters documents correctly when FilterDocuments is added',
      build: () {
        when(mockRepository.getAllDocuments()).thenAnswer(
          (_) async => [
            _createMockDocument(category: 'Category1'),
            _createMockDocument(category: 'Category2'),
          ],
        );
        return documentBloc;
      },
      act: (bloc) => bloc
        ..add(const DocumentEvent.loadDocuments())
        ..add(const DocumentEvent.filterDocuments(category: 'Category1')),
      expect: () => [
        const DocumentState.loading(),
        isA<DocumentLoaded>(),
        isA<DocumentLoaded>(),
      ],
      verify: (bloc) {
        final state = bloc.state as DocumentLoaded;
        expect(state.filteredDocuments.length, 1);
        expect(state.filteredDocuments.first.category, 'Category1');
      },
    );

    blocTest<DocumentBloc, DocumentState>(
      'searches documents correctly when SearchDocuments is added',
      build: () {
        when(mockRepository.getAllDocuments()).thenAnswer(
          (_) async => [
            _createMockDocument(fileName: 'test1.pdf'),
            _createMockDocument(fileName: 'document2.docx'),
            _createMockDocument(fileName: 'test3.pdf'),
          ],
        );
        return documentBloc;
      },
      act: (bloc) => bloc
        ..add(const DocumentEvent.loadDocuments())
        ..add(const DocumentEvent.searchDocuments(query: 'test')),
      expect: () => [
        const DocumentState.loading(),
        isA<DocumentLoaded>(),
        isA<DocumentLoaded>(),
      ],
      verify: (bloc) {
        final state = bloc.state as DocumentLoaded;
        expect(state.filteredDocuments.length, 2);
        expect(
          state.filteredDocuments.every((doc) => doc.fileName.contains('test')),
          true,
        );
      },
    );

    blocTest<DocumentBloc, DocumentState>(
      'sorts documents correctly when SortDocuments is added',
      build: () {
        final doc1 = _createMockDocument(
          fileName: 'a.pdf',
          uploadedAt: DateTime(2023, 1, 1),
        );
        final doc2 = _createMockDocument(
          fileName: 'b.pdf',
          uploadedAt: DateTime(2023, 1, 2),
        );
        final doc3 = _createMockDocument(
          fileName: 'c.pdf',
          uploadedAt: DateTime(2023, 1, 3),
        );

        when(
          mockRepository.getAllDocuments(),
        ).thenAnswer((_) async => [doc2, doc1, doc3]);
        return documentBloc;
      },
      act: (bloc) => bloc
        ..add(const DocumentEvent.loadDocuments())
        ..add(
          const DocumentEvent.sortDocuments(
            sortBy: 'uploadedAt',
            ascending: false,
          ),
        ),
      expect: () => [
        const DocumentState.loading(),
        isA<DocumentLoaded>(),
        isA<DocumentLoaded>(),
      ],
      verify: (bloc) {
        final state = bloc.state as DocumentLoaded;
        expect(state.filteredDocuments.length, 3);
        expect(state.filteredDocuments.first.fileName, 'c.pdf');
        expect(state.filteredDocuments.last.fileName, 'a.pdf');
      },
    );

    blocTest<DocumentBloc, DocumentState>(
      'deletes document correctly when DeleteDocument is added',
      build: () {
        when(
          mockRepository.getAllDocuments(),
        ).thenAnswer((_) async => [_createMockDocument()]);
        when(
          mockRepository.deleteDocument('test-id', 'user1'),
        ).thenAnswer((_) async => true);
        return documentBloc;
      },
      act: (bloc) => bloc
        ..add(const DocumentEvent.loadDocuments())
        ..add(
          const DocumentEvent.deleteDocument(
            documentId: 'test-id',
            userId: 'user1',
          ),
        ),
      expect: () => [
        const DocumentState.loading(),
        isA<DocumentLoaded>(),
        const DocumentState.loading(),
        isA<DocumentLoaded>(),
      ],
    );

    blocTest<DocumentBloc, DocumentState>(
      'handles bulk operations correctly',
      build: () {
        when(mockRepository.getAllDocuments()).thenAnswer(
          (_) async => [
            _createMockDocument(id: 'doc1'),
            _createMockDocument(id: 'doc2'),
            _createMockDocument(id: 'doc3'),
          ],
        );
        when(
          mockRepository.bulkDeleteDocuments(['doc1', 'doc2'], 'user1'),
        ).thenAnswer((_) async => true);
        return documentBloc;
      },
      act: (bloc) => bloc
        ..add(const DocumentEvent.loadDocuments())
        ..add(
          const DocumentEvent.bulkDeleteDocuments(
            documentIds: ['doc1', 'doc2'],
            userId: 'user1',
          ),
        ),
      expect: () => [
        const DocumentState.loading(),
        isA<DocumentLoaded>(),
        const DocumentState.loading(),
        isA<DocumentLoaded>(),
      ],
    );
  });
}

DocumentModel _createMockDocument({
  String? id,
  String? fileName,
  String? category,
  DateTime? uploadedAt,
}) {
  return DocumentModel(
    id: id ?? 'test-id',
    fileName: fileName ?? 'test.pdf',
    fileSize: 1024,
    fileType: 'pdf',
    filePath: '/test/path',
    uploadedBy: 'test-user',
    uploadedAt: uploadedAt ?? DateTime.now(),
    category: category ?? 'Test Category',
    permissions: ['read'],
    metadata: DocumentMetadata(description: 'Test document', tags: ['test']),
  );
}
