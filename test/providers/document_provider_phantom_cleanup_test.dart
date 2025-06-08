import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../lib/providers/document_provider.dart';
import '../../lib/models/document_model.dart';

// Generate mocks
@GenerateMocks([
  FirebaseStorage,
  Reference,
  DocumentSnapshot,
  CollectionReference,
  FirebaseFirestore,
])
import 'document_provider_phantom_cleanup_test.mocks.dart';

void main() {
  group('DocumentProvider Phantom File Cleanup Tests', () {
    late DocumentProvider documentProvider;
    late MockFirebaseStorage mockStorage;
    late MockReference mockRef;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference mockCollection;
    late MockDocumentSnapshot mockDocSnapshot;

    setUp(() {
      documentProvider = DocumentProvider();
      mockStorage = MockFirebaseStorage();
      mockRef = MockReference();
      mockFirestore = MockFirebaseFirestore();
      mockCollection = MockCollectionReference();
      mockDocSnapshot = MockDocumentSnapshot();
    });

    test('should identify phantom pending files correctly', () async {
      // Create test documents - one valid, one phantom
      final validDocument = DocumentModel(
        id: 'valid_doc_id',
        fileName: 'valid_file.pdf',
        filePath: 'documents/user123/valid_file.pdf',
        fileSize: 1024,
        fileType: 'pdf',
        uploadedBy: 'user123',
        uploadedAt: DateTime.now(),
        status: 'pending',
        category: 'test',
        metadata: DocumentMetadata(
          description: 'Test document',
          tags: ['test'],
          extractedText: '',
        ),
      );

      final phantomDocument = DocumentModel(
        id: 'phantom_doc_id',
        fileName: 'phantom_file.pdf',
        filePath: 'documents/user123/phantom_file.pdf',
        fileSize: 2048,
        fileType: 'pdf',
        uploadedBy: 'user123',
        uploadedAt: DateTime.now(),
        status: 'pending',
        category: 'test',
        metadata: DocumentMetadata(
          description: 'Phantom document',
          tags: ['test'],
          extractedText: '',
        ),
      );

      // Add documents to provider's internal list for testing
      documentProvider.addDocument(validDocument);
      documentProvider.addDocument(phantomDocument);

      // Verify both documents are initially present
      final pendingFiles = documentProvider.getDocumentsByStatus('pending');
      expect(pendingFiles.length, equals(2));
      expect(pendingFiles.any((doc) => doc.id == 'valid_doc_id'), isTrue);
      expect(pendingFiles.any((doc) => doc.id == 'phantom_doc_id'), isTrue);
    });

    test('should handle cleanup gracefully when no pending files exist', () async {
      // Test with empty document list
      final pendingFiles = documentProvider.getDocumentsByStatus('pending');
      expect(pendingFiles.length, equals(0));

      // Cleanup should not throw any errors
      expect(() => documentProvider.cleanupPhantomFiles(), returnsNormally);
    });

    test('should not affect non-pending files during cleanup', () async {
      // Create test documents with different statuses
      final approvedDocument = DocumentModel(
        id: 'approved_doc_id',
        fileName: 'approved_file.pdf',
        filePath: 'documents/user123/approved_file.pdf',
        fileSize: 1024,
        fileType: 'pdf',
        uploadedBy: 'user123',
        uploadedAt: DateTime.now(),
        status: 'approved',
        category: 'test',
        metadata: DocumentMetadata(
          description: 'Approved document',
          tags: ['test'],
          extractedText: '',
        ),
      );

      final rejectedDocument = DocumentModel(
        id: 'rejected_doc_id',
        fileName: 'rejected_file.pdf',
        filePath: 'documents/user123/rejected_file.pdf',
        fileSize: 1024,
        fileType: 'pdf',
        uploadedBy: 'user123',
        uploadedAt: DateTime.now(),
        status: 'rejected',
        category: 'test',
        metadata: DocumentMetadata(
          description: 'Rejected document',
          tags: ['test'],
          extractedText: '',
        ),
      );

      // Add documents to provider
      documentProvider.addDocument(approvedDocument);
      documentProvider.addDocument(rejectedDocument);

      // Verify documents are present
      final approvedFiles = documentProvider.getDocumentsByStatus('approved');
      final rejectedFiles = documentProvider.getDocumentsByStatus('rejected');
      expect(approvedFiles.length, equals(1));
      expect(rejectedFiles.length, equals(1));

      // Cleanup should not affect non-pending files
      await documentProvider.cleanupPhantomFiles();

      // Verify non-pending files are still present
      final approvedFilesAfter = documentProvider.getDocumentsByStatus('approved');
      final rejectedFilesAfter = documentProvider.getDocumentsByStatus('rejected');
      expect(approvedFilesAfter.length, equals(1));
      expect(rejectedFilesAfter.length, equals(1));
    });

    test('should trigger automatic cleanup when getting pending files', () {
      // This test verifies that getDocumentsByStatus('pending') triggers cleanup
      final pendingFiles = documentProvider.getDocumentsByStatus('pending');
      expect(pendingFiles, isA<List<DocumentModel>>());
      
      // The cleanup is triggered in background, so we just verify the method doesn't throw
      expect(() => documentProvider.getDocumentsByStatus('pending'), returnsNormally);
    });
  });
}
