import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:managementdoc/services/optimized_deletion_service.dart';
import 'package:managementdoc/services/direct_storage_deletion_service.dart';
import 'package:managementdoc/core/services/document_service.dart';
import 'package:managementdoc/core/services/firebase_service.dart';
import 'package:managementdoc/models/document_model.dart';

// Generate mocks
@GenerateMocks([
  DirectStorageDeletionService,
  DocumentService,
  FirebaseService,
])
import 'optimized_deletion_service_test.mocks.dart';

void main() {
  group('OptimizedDeletionService', () {
    late OptimizedDeletionService service;
    late MockDirectStorageDeletionService mockDirectStorageService;
    late MockDocumentService mockDocumentService;
    late MockFirebaseService mockFirebaseService;

    setUp(() {
      service = OptimizedDeletionService.instance;
      mockDirectStorageService = MockDirectStorageDeletionService();
      mockDocumentService = MockDocumentService();
      mockFirebaseService = MockFirebaseService();
    });

    group('deleteDocument', () {
      final testDocument = DocumentModel(
        id: 'test-doc-id',
        fileName: 'test_file.pdf',
        fileSize: 1024,
        fileType: 'application/pdf',
        filePath: 'documents/test_file.pdf',
        uploadedBy: 'admin-user-id',
        uploadedAt: DateTime.now(),
        category: 'general',
        permissions: ['admin'],
        metadata: DocumentMetadata(
          description: 'Test document',
          tags: ['test'],
          downloadUrl: 'https://firebasestorage.googleapis.com/v0/b/test-bucket/o/documents%2Ftest_file.pdf?alt=media&token=abc123',
        ),
      );

      test('should successfully delete document using optimized method', () async {
        // Arrange
        when(mockDirectStorageService.deleteDocumentDirect(any))
            .thenAnswer((_) async => StorageDeletionResult.success(
                  path: 'documents/test_file.pdf',
                  fileName: 'test_file.pdf',
                  message: 'File deleted successfully',
                ));

        // Act
        final result = await service.deleteDocument(testDocument, 'admin-user-id');

        // Assert
        expect(result.success, isTrue);
        expect(result.documentId, equals('test-doc-id'));
        expect(result.fileName, equals('test_file.pdf'));
        expect(result.method, equals(DeletionMethod.directStorage));
        verify(mockDirectStorageService.deleteDocumentDirect(testDocument)).called(1);
      });

      test('should fall back to traditional method when optimized fails', () async {
        // Arrange
        when(mockDirectStorageService.deleteDocumentDirect(any))
            .thenAnswer((_) async => StorageDeletionResult.error(
                  path: 'documents/test_file.pdf',
                  message: 'Direct deletion failed',
                  errorCode: 'DIRECT_DELETION_FAILED',
                ));

        when(mockDocumentService.deleteDocument(any, any))
            .thenAnswer((_) async => {});

        // Act
        final result = await service.deleteDocument(testDocument, 'admin-user-id');

        // Assert
        expect(result.success, isTrue);
        expect(result.method, equals(DeletionMethod.traditional));
        verify(mockDirectStorageService.deleteDocumentDirect(testDocument)).called(1);
        verify(mockDocumentService.deleteDocument('test-doc-id', 'admin-user-id')).called(1);
      });

      test('should return unauthorized result for non-admin user', () async {
        // Act
        final result = await service.deleteDocument(testDocument, 'regular-user-id');

        // Assert
        expect(result.success, isFalse);
        expect(result.errorCode, equals('UNAUTHORIZED'));
        expect(result.message, contains('Only administrators can delete files'));
        verifyNever(mockDirectStorageService.deleteDocumentDirect(any));
        verifyNever(mockDocumentService.deleteDocument(any, any));
      });

      test('should use traditional method when forceTraditional is true', () async {
        // Arrange
        when(mockDocumentService.deleteDocument(any, any))
            .thenAnswer((_) async => {});

        // Act
        final result = await service.deleteDocument(
          testDocument,
          'admin-user-id',
          forceTraditional: true,
        );

        // Assert
        expect(result.success, isTrue);
        expect(result.method, equals(DeletionMethod.traditional));
        verifyNever(mockDirectStorageService.deleteDocumentDirect(any));
        verify(mockDocumentService.deleteDocument('test-doc-id', 'admin-user-id')).called(1);
      });

      test('should handle document not found error gracefully', () async {
        // Arrange
        when(mockDirectStorageService.deleteDocumentDirect(any))
            .thenAnswer((_) async => StorageDeletionResult.error(
                  path: 'documents/test_file.pdf',
                  message: 'Direct deletion failed',
                  errorCode: 'DIRECT_DELETION_FAILED',
                ));

        when(mockDocumentService.deleteDocument(any, any))
            .thenThrow(Exception('Document not found'));

        // Act
        final result = await service.deleteDocument(testDocument, 'admin-user-id');

        // Assert
        expect(result.success, isTrue);
        expect(result.method, equals(DeletionMethod.notFoundCleanup));
        expect(result.message, contains('Document not found in backend'));
      });

      test('should measure deletion duration', () async {
        // Arrange
        when(mockDirectStorageService.deleteDocumentDirect(any))
            .thenAnswer((_) async {
              await Future.delayed(Duration(milliseconds: 100));
              return StorageDeletionResult.success(
                path: 'documents/test_file.pdf',
                fileName: 'test_file.pdf',
                message: 'File deleted successfully',
              );
            });

        // Act
        final result = await service.deleteDocument(testDocument, 'admin-user-id');

        // Assert
        expect(result.success, isTrue);
        expect(result.duration.inMilliseconds, greaterThan(50));
        expect(result.formattedDuration, isNotEmpty);
      });
    });

    group('deleteDocumentByUrl', () {
      const testUrl = 'https://firebasestorage.googleapis.com/v0/b/test-bucket/o/documents%2Ftest_file.pdf?alt=media&token=abc123';

      test('should successfully delete document by URL', () async {
        // Arrange
        when(mockDirectStorageService.deleteFileByPath(any))
            .thenAnswer((_) async => StorageDeletionResult.success(
                  path: 'documents/test_file.pdf',
                  fileName: 'test_file.pdf',
                  message: 'File deleted successfully',
                ));

        // Act
        final result = await service.deleteDocumentByUrl(testUrl, 'admin-user-id');

        // Assert
        expect(result.success, isTrue);
        expect(result.method, equals(DeletionMethod.directUrl));
        expect(result.fileName, equals('test_file.pdf'));
        verify(mockDirectStorageService.deleteFileByPath('documents/test_file.pdf')).called(1);
      });

      test('should return error for invalid URL', () async {
        // Act
        final result = await service.deleteDocumentByUrl('invalid-url', 'admin-user-id');

        // Assert
        expect(result.success, isFalse);
        expect(result.errorCode, equals('INVALID_URL'));
        expect(result.message, contains('Could not extract storage path from URL'));
        verifyNever(mockDirectStorageService.deleteFileByPath(any));
      });

      test('should return unauthorized result for non-admin user', () async {
        // Act
        final result = await service.deleteDocumentByUrl(testUrl, 'regular-user-id');

        // Assert
        expect(result.success, isFalse);
        expect(result.errorCode, equals('UNAUTHORIZED'));
        verifyNever(mockDirectStorageService.deleteFileByPath(any));
      });

      test('should handle storage deletion failure', () async {
        // Arrange
        when(mockDirectStorageService.deleteFileByPath(any))
            .thenAnswer((_) async => StorageDeletionResult.error(
                  path: 'documents/test_file.pdf',
                  message: 'Storage deletion failed',
                  errorCode: 'STORAGE_ERROR',
                ));

        // Act
        final result = await service.deleteDocumentByUrl(testUrl, 'admin-user-id');

        // Assert
        expect(result.success, isFalse);
        expect(result.errorCode, equals('STORAGE_ERROR'));
        expect(result.message, contains('URL-based deletion failed'));
      });
    });

    group('OptimizedDeletionResult', () {
      test('should create successful result correctly', () {
        final result = OptimizedDeletionResult.success(
          documentId: 'test-id',
          fileName: 'test.pdf',
          message: 'Success',
          method: DeletionMethod.directStorage,
          duration: Duration(milliseconds: 500),
          storageDeleted: true,
          firestoreDeleted: true,
        );

        expect(result.success, isTrue);
        expect(result.documentId, equals('test-id'));
        expect(result.fileName, equals('test.pdf'));
        expect(result.methodName, equals('Direct Storage'));
        expect(result.formattedDuration, equals('0.5s'));
        expect(result.storageDeleted, isTrue);
        expect(result.firestoreDeleted, isTrue);
      });

      test('should create error result correctly', () {
        final result = OptimizedDeletionResult.error(
          documentId: 'test-id',
          fileName: 'test.pdf',
          message: 'Error occurred',
          errorCode: 'TEST_ERROR',
          duration: Duration(milliseconds: 100),
        );

        expect(result.success, isFalse);
        expect(result.errorCode, equals('TEST_ERROR'));
        expect(result.formattedDuration, equals('100ms'));
        expect(result.storageDeleted, isFalse);
        expect(result.firestoreDeleted, isFalse);
      });

      test('should create unauthorized result correctly', () {
        final result = OptimizedDeletionResult.unauthorized(
          documentId: 'test-id',
          fileName: 'test.pdf',
          message: 'Unauthorized',
        );

        expect(result.success, isFalse);
        expect(result.errorCode, equals('UNAUTHORIZED'));
        expect(result.duration, equals(Duration.zero));
      });

      test('should format duration correctly', () {
        final shortResult = OptimizedDeletionResult.error(
          documentId: 'test',
          fileName: 'test.pdf',
          message: 'Error',
          errorCode: 'ERROR',
          duration: Duration(milliseconds: 250),
        );

        final longResult = OptimizedDeletionResult.error(
          documentId: 'test',
          fileName: 'test.pdf',
          message: 'Error',
          errorCode: 'ERROR',
          duration: Duration(milliseconds: 1500),
        );

        expect(shortResult.formattedDuration, equals('250ms'));
        expect(longResult.formattedDuration, equals('1.5s'));
      });

      test('should return correct method names', () {
        expect(DeletionMethod.directStorage.toString(), contains('directStorage'));
        expect(DeletionMethod.directUrl.toString(), contains('directUrl'));
        expect(DeletionMethod.traditional.toString(), contains('traditional'));
        expect(DeletionMethod.notFoundCleanup.toString(), contains('notFoundCleanup'));
      });
    });
  });
}
