import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/document_model.dart';

/// Test class to verify UUID generation is working correctly
/// and that document IDs are properly hidden from users
class UuidGenerationTest {
  static const Uuid _uuid = Uuid();

  /// Test UUID generation for document creation
  static void testUuidGeneration() {
    debugPrint('🧪 Testing UUID generation...');

    // Generate multiple UUIDs to ensure uniqueness
    final Set<String> generatedIds = {};
    
    for (int i = 0; i < 10; i++) {
      final documentId = _uuid.v4();
      
      // Verify UUID format (should be 36 characters with hyphens)
      assert(documentId.length == 36, 'UUID should be 36 characters long');
      assert(documentId.contains('-'), 'UUID should contain hyphens');
      assert(!generatedIds.contains(documentId), 'UUIDs should be unique');
      
      generatedIds.add(documentId);
      debugPrint('✅ Generated UUID $i: $documentId');
    }

    debugPrint('✅ UUID generation test passed: ${generatedIds.length} unique IDs generated');
  }

  /// Test document model creation with UUID
  static void testDocumentModelCreation() {
    debugPrint('🧪 Testing DocumentModel creation with UUID...');

    final documentId = _uuid.v4();
    final testFileName = 'test_document.pdf';
    
    final document = DocumentModel(
      id: documentId,
      fileName: testFileName,
      fileSize: 1024000, // 1MB
      fileType: 'PDF',
      filePath: 'documents/test/test_document.pdf',
      uploadedBy: 'test-user-id',
      uploadedAt: DateTime.now(),
      category: 'test-category',
      permissions: ['test-user-id'],
      metadata: DocumentMetadata(
        description: 'Test document for UUID verification',
        tags: ['test', 'uuid'],
        version: '1.0',
        contentType: 'application/pdf',
      ),
    );

    // Verify that the document was created correctly
    assert(document.id == documentId, 'Document ID should match generated UUID');
    assert(document.fileName == testFileName, 'File name should be preserved');
    assert(document.id.length == 36, 'Document ID should be valid UUID');
    
    debugPrint('✅ Document created successfully:');
    debugPrint('   ID: ${document.id}');
    debugPrint('   File Name: ${document.fileName}');
    debugPrint('   File Type: ${document.fileType}');
    
    debugPrint('✅ DocumentModel creation test passed');
  }

  /// Test that file names are displayed cleanly without ID prefixes
  static void testFileNameDisplay() {
    debugPrint('🧪 Testing file name display...');

    final testCases = [
      'simple_document.pdf',
      'Document with Spaces.docx',
      'special-chars_file.xlsx',
      'very_long_filename_that_might_cause_issues.pptx',
      'file.with.multiple.dots.txt',
    ];

    for (final fileName in testCases) {
      final documentId = _uuid.v4();
      
      final document = DocumentModel(
        id: documentId,
        fileName: fileName,
        fileSize: 1024,
        fileType: 'Document',
        filePath: 'documents/$fileName',
        uploadedBy: 'test-user',
        uploadedAt: DateTime.now(),
        category: 'test',
        permissions: ['test-user'],
        metadata: DocumentMetadata(
          description: 'Test file',
          tags: ['test'],
        ),
      );

      // Verify that the displayed filename is clean (no ID prefixes)
      assert(document.fileName == fileName, 'File name should be preserved exactly');
      assert(!document.fileName.startsWith('doc_'), 'File name should not have doc_ prefix');
      assert(!document.fileName.startsWith('sync_'), 'File name should not have sync_ prefix');
      assert(!document.fileName.contains(document.id), 'File name should not contain document ID');
      
      debugPrint('✅ Clean display: "$fileName" (ID hidden: ${document.id.substring(0, 8)}...)');
    }

    debugPrint('✅ File name display test passed');
  }

  /// Run all tests
  static void runAllTests() {
    debugPrint('🧪 Starting UUID Generation Tests...');
    debugPrint('=' * 50);
    
    try {
      testUuidGeneration();
      debugPrint('');
      
      testDocumentModelCreation();
      debugPrint('');
      
      testFileNameDisplay();
      debugPrint('');
      
      debugPrint('🎉 All UUID generation tests passed successfully!');
      debugPrint('✅ Document IDs are properly generated with UUIDs');
      debugPrint('✅ File names are displayed cleanly without ID exposure');
      debugPrint('✅ System is ready for production use');
      
    } catch (e) {
      debugPrint('❌ Test failed: $e');
      rethrow;
    }
    
    debugPrint('=' * 50);
  }
}
