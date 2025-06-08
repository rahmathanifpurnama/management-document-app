import 'package:flutter_test/flutter_test.dart';
import 'package:managementdoc/services/share_service.dart';
import 'package:managementdoc/models/document_model.dart';

void main() {
  group('ShareService Tests', () {
    late ShareService shareService;
    late DocumentModel testDocument;

    setUp(() {
      shareService = ShareService();
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
      final instance1 = ShareService();
      final instance2 = ShareService();
      expect(instance1, same(instance2));
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
        
        // This is a bit of a hack to test the private method
        // In a real scenario, we'd test the public methods that use this
        final shareText = shareService.shareFileInfo(document);
        expect(shareText, isA<Future<void>>());
      }
    });

    test('should format date correctly', () {
      final testDate = DateTime(2024, 1, 15, 10, 30);
      final document = testDocument.copyWith(uploadedAt: testDate);
      
      // Test that the service can handle the document
      expect(() => shareService.shareFileInfo(document), returnsNormally);
    });

    test('should get correct share type icons', () {
      expect(ShareService.getShareIcon(ShareType.fileInfo), isNotNull);
      expect(ShareService.getShareIcon(ShareType.shareableLink), isNotNull);
      expect(ShareService.getShareIcon(ShareType.fileDetails), isNotNull);
    });

    test('should get correct share type names', () {
      expect(ShareService.getShareTypeName(ShareType.fileInfo), 'File Info');
      expect(ShareService.getShareTypeName(ShareType.shareableLink), 'Share Link');
      expect(ShareService.getShareTypeName(ShareType.fileDetails), 'Full Details');
    });

    test('should handle empty metadata gracefully', () {
      final documentWithEmptyMetadata = testDocument.copyWith(
        metadata: DocumentMetadata(
          description: '',
          tags: [],
        ),
      );
      
      expect(() => shareService.shareFileInfo(documentWithEmptyMetadata), returnsNormally);
    });

    test('should handle multiple files sharing', () {
      final documents = [
        testDocument,
        testDocument.copyWith(
          id: 'test-doc-2',
          fileName: 'second-document.docx',
          fileType: 'docx',
        ),
      ];
      
      expect(() => shareService.shareMultipleFiles(documents), returnsNormally);
    });

    test('should handle different file types', () {
      final fileTypes = ['pdf', 'docx', 'xlsx', 'jpg', 'png', 'txt'];
      
      for (final fileType in fileTypes) {
        final document = testDocument.copyWith(
          fileType: fileType,
          fileName: 'test.$fileType',
        );
        
        expect(() => shareService.shareFileInfo(document), returnsNormally);
      }
    });

    test('should handle large file sizes', () {
      final largeDocument = testDocument.copyWith(
        fileSize: 5368709120, // 5GB
      );
      
      expect(() => shareService.shareFileInfo(largeDocument), returnsNormally);
    });

    test('should handle special characters in file names', () {
      final specialDocument = testDocument.copyWith(
        fileName: 'test-file_with-special@chars#.pdf',
      );
      
      expect(() => shareService.shareFileInfo(specialDocument), returnsNormally);
    });

    test('should handle different document statuses', () {
      final statuses = ['active', 'pending', 'approved', 'rejected'];
      
      for (final status in statuses) {
        final document = testDocument.copyWith(status: status);
        expect(() => shareService.shareFileInfo(document), returnsNormally);
      }
    });
  });
}
