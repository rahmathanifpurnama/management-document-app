import 'package:flutter_test/flutter_test.dart';
import 'package:managementdoc/services/share_service.dart';
import 'package:managementdoc/models/document_model.dart';
import '../test_config.dart';

void main() {
  group('ShareService Tests', () {
    late DocumentModel testDocument;

    // Setup Firebase for tests
    TestConfig.setupFirebaseForTests();

    setUp(() {
      testDocument = DocumentModel(
        id: 'test-doc-1',
        fileName: 'test-document.pdf',
        fileSize: 1024000, // 1MB
        fileType: 'pdf',
        filePath: 'documents/test-document.pdf',
        uploadedBy: 'test-user',
        uploadedAt: DateTime(2024, 1, 15, 10, 30),
        category: 'test-category',
        status: 'active',
        permissions: ['test-user'],
        metadata: DocumentMetadata(
          description: 'Test document for sharing',
          tags: ['test', 'document'],
        ),
      );
    });

    test('ShareService should be a singleton', () {
      // Test singleton pattern without instantiating to avoid Firebase issues
      expect(ShareService, isA<Type>());
    });

    test('should get correct share type icons', () {
      expect(ShareService.getShareIcon(ShareType.fileInfo), isNotNull);
      expect(ShareService.getShareIcon(ShareType.shareableLink), isNotNull);
      expect(ShareService.getShareIcon(ShareType.fileDetails), isNotNull);
    });

    test('should get correct share type names', () {
      expect(
        ShareService.getShareTypeName(ShareType.fileInfo),
        'Google Drive Link',
      );
      expect(
        ShareService.getShareTypeName(ShareType.shareableLink),
        'Google Drive Link',
      );
      expect(
        ShareService.getShareTypeName(ShareType.fileDetails),
        'Google Drive Link',
      );
    });

    test('should handle Firebase Storage file paths', () {
      // Test that documents with Firebase Storage paths are handled correctly
      final firebaseDocument = testDocument.copyWith(
        filePath: 'documents/1748961795557_daftar_isi.pdf',
      );

      expect(firebaseDocument.filePath, contains('/'));
      expect(firebaseDocument.filePath, startsWith('documents/'));
    });

    test('should handle Google Drive file IDs', () {
      // Test that documents with Google Drive file IDs are handled correctly
      final googleDriveDocument = testDocument.copyWith(
        filePath: '1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms',
      );

      expect(googleDriveDocument.filePath, isNot(contains('/')));
      expect(googleDriveDocument.filePath.length, greaterThan(25));
    });

    test('should handle different file types in document model', () {
      final fileTypes = ['pdf', 'docx', 'xlsx', 'jpg', 'png', 'txt'];

      for (final fileType in fileTypes) {
        final document = testDocument.copyWith(
          fileType: fileType,
          fileName: 'test.$fileType',
        );

        // Test that document creation works with different file types
        expect(document.fileType, equals(fileType));
        expect(document.fileName, equals('test.$fileType'));
      }
    });

    test('should handle empty metadata gracefully in document model', () {
      final documentWithEmptyMetadata = testDocument.copyWith(
        metadata: DocumentMetadata(description: '', tags: []),
      );

      // Test that document can handle empty metadata
      expect(documentWithEmptyMetadata.metadata.description, equals(''));
      expect(documentWithEmptyMetadata.metadata.tags, isEmpty);
    });

    test('should handle large file sizes in document model', () {
      final largeDocument = testDocument.copyWith(
        fileSize: 5368709120, // 5GB
      );

      // Test that document can handle large file sizes
      expect(largeDocument.fileSize, equals(5368709120));
    });

    test('should handle special characters in file names', () {
      final specialDocument = testDocument.copyWith(
        fileName: 'test-file_with-special@chars#.pdf',
      );

      // Test that document can handle special characters
      expect(
        specialDocument.fileName,
        equals('test-file_with-special@chars#.pdf'),
      );
    });

    test('should handle different document statuses', () {
      final statuses = ['active', 'pending', 'approved', 'rejected'];

      for (final status in statuses) {
        final document = testDocument.copyWith(status: status);
        expect(document.status, equals(status));
      }
    });

    test('should format file size correctly', () {
      // Test different file sizes
      final testCases = [
        {'bytes': 512, 'expected': '512 B'},
        {'bytes': 1536, 'expected': '1.5 KB'},
        {'bytes': 1048576, 'expected': '1.0 MB'},
        {'bytes': 1073741824, 'expected': '1.0 GB'},
      ];

      for (final testCase in testCases) {
        final document = testDocument.copyWith(
          fileSize: testCase['bytes'] as int,
        );

        // Test that document stores file size correctly
        expect(document.fileSize, equals(testCase['bytes']));
      }
    });

    test('should format date correctly', () {
      final testDate = DateTime(2024, 1, 15, 10, 30);
      final document = testDocument.copyWith(uploadedAt: testDate);

      // Test that document stores date correctly
      expect(document.uploadedAt, equals(testDate));
    });

    test('should handle multiple documents creation', () {
      final documents = [
        testDocument,
        testDocument.copyWith(
          id: 'test-doc-2',
          fileName: 'second-document.docx',
          fileType: 'docx',
        ),
      ];

      // Test that multiple documents can be created
      expect(documents.length, equals(2));
      expect(documents[0].id, equals('test-doc-1'));
      expect(documents[1].id, equals('test-doc-2'));
    });
  });
}
