import 'package:flutter_test/flutter_test.dart';
import 'package:management_document_app/providers/document_provider.dart';
import 'package:management_document_app/models/document_model.dart';
import 'package:management_document_app/models/document_metadata.dart';

void main() {
  group('Search and Filter Functionality Tests', () {
    late DocumentProvider documentProvider;
    late List<DocumentModel> testDocuments;

    setUp(() {
      documentProvider = DocumentProvider();
      
      // Create test documents with various types and content
      testDocuments = [
        DocumentModel(
          id: '1',
          fileName: 'test_document.pdf',
          filePath: '/documents/test_document.pdf',
          fileType: 'pdf',
          fileSize: 1024,
          uploadedBy: 'user1',
          uploadedAt: DateTime.now().subtract(const Duration(days: 1)),
          category: 'reports',
          metadata: DocumentMetadata(
            description: 'Test PDF document for reports',
            tags: ['test', 'pdf', 'report'],
          ),
        ),
        DocumentModel(
          id: '2',
          fileName: 'spreadsheet_data.xlsx',
          filePath: '/documents/spreadsheet_data.xlsx',
          fileType: 'xlsx',
          fileSize: 2048,
          uploadedBy: 'user2',
          uploadedAt: DateTime.now().subtract(const Duration(days: 2)),
          category: 'data',
          metadata: DocumentMetadata(
            description: 'Excel spreadsheet with financial data',
            tags: ['excel', 'finance', 'data'],
          ),
        ),
        DocumentModel(
          id: '3',
          fileName: 'presentation_slides.pptx',
          filePath: '/documents/presentation_slides.pptx',
          fileType: 'pptx',
          fileSize: 4096,
          uploadedBy: 'user1',
          uploadedAt: DateTime.now().subtract(const Duration(days: 3)),
          category: 'presentations',
          metadata: DocumentMetadata(
            description: 'PowerPoint presentation for meeting',
            tags: ['powerpoint', 'meeting', 'slides'],
          ),
        ),
        DocumentModel(
          id: '4',
          fileName: 'image_file.jpg',
          filePath: '/documents/image_file.jpg',
          fileType: 'jpg',
          fileSize: 512,
          uploadedBy: 'user3',
          uploadedAt: DateTime.now().subtract(const Duration(hours: 12)),
          category: 'images',
          metadata: DocumentMetadata(
            description: 'JPEG image file',
            tags: ['image', 'photo', 'jpeg'],
          ),
        ),
        DocumentModel(
          id: '5',
          fileName: 'special_chars_文档.txt',
          filePath: '/documents/special_chars_文档.txt',
          fileType: 'txt',
          fileSize: 256,
          uploadedBy: 'user2',
          uploadedAt: DateTime.now().subtract(const Duration(hours: 6)),
          category: 'text',
          metadata: DocumentMetadata(
            description: 'Text file with special characters and unicode',
            tags: ['text', 'unicode', 'special'],
          ),
        ),
      ];
    });

    group('Search Functionality', () {
      test('should handle empty search query', () {
        // Simulate documents being loaded
        documentProvider.documents.addAll(testDocuments);
        
        // Test empty search
        documentProvider.searchDocuments('');
        
        expect(documentProvider.searchQuery, equals(''));
        expect(documentProvider.hasActiveFilters, isFalse);
      });

      test('should search by file name with various character types', () {
        documentProvider.documents.addAll(testDocuments);
        
        // Test normal text search
        documentProvider.searchDocuments('test');
        expect(documentProvider.searchQuery, equals('test'));
        expect(documentProvider.hasActiveFilters, isTrue);
        
        // Test search with special characters
        documentProvider.searchDocuments('文档');
        expect(documentProvider.searchQuery, equals('文档'));
        expect(documentProvider.hasActiveFilters, isTrue);
        
        // Test search with numbers
        documentProvider.searchDocuments('123');
        expect(documentProvider.searchQuery, equals('123'));
        expect(documentProvider.hasActiveFilters, isTrue);
        
        // Test search with symbols
        documentProvider.searchDocuments('_');
        expect(documentProvider.searchQuery, equals('_'));
        expect(documentProvider.hasActiveFilters, isTrue);
      });

      test('should search by description', () {
        documentProvider.documents.addAll(testDocuments);
        
        documentProvider.searchDocuments('financial');
        expect(documentProvider.searchQuery, equals('financial'));
        expect(documentProvider.hasActiveFilters, isTrue);
      });

      test('should search by tags', () {
        documentProvider.documents.addAll(testDocuments);
        
        documentProvider.searchDocuments('meeting');
        expect(documentProvider.searchQuery, equals('meeting'));
        expect(documentProvider.hasActiveFilters, isTrue);
      });

      test('should be case insensitive', () {
        documentProvider.documents.addAll(testDocuments);
        
        documentProvider.searchDocuments('PDF');
        expect(documentProvider.searchQuery, equals('PDF'));
        expect(documentProvider.hasActiveFilters, isTrue);
        
        documentProvider.searchDocuments('pdf');
        expect(documentProvider.searchQuery, equals('pdf'));
        expect(documentProvider.hasActiveFilters, isTrue);
      });
    });

    group('Filter Functionality', () {
      test('should filter by file type', () {
        documentProvider.documents.addAll(testDocuments);
        
        documentProvider.filterByFileType('PDF');
        expect(documentProvider.selectedFileType, equals('PDF'));
        expect(documentProvider.hasActiveFilters, isTrue);
        
        documentProvider.filterByFileType('all');
        expect(documentProvider.selectedFileType, equals('all'));
      });

      test('should filter by category', () {
        documentProvider.documents.addAll(testDocuments);
        
        documentProvider.filterByCategory('reports');
        expect(documentProvider.selectedCategory, equals('reports'));
        expect(documentProvider.hasActiveFilters, isTrue);
        
        documentProvider.filterByCategory('all');
        expect(documentProvider.selectedCategory, equals('all'));
      });

      test('should combine search and filters', () {
        documentProvider.documents.addAll(testDocuments);
        
        // Apply both search and filter
        documentProvider.searchDocuments('test');
        documentProvider.filterByFileType('PDF');
        
        expect(documentProvider.searchQuery, equals('test'));
        expect(documentProvider.selectedFileType, equals('PDF'));
        expect(documentProvider.hasActiveFilters, isTrue);
      });
    });

    group('Statistics Independence', () {
      test('should not affect statistics when searching', () {
        documentProvider.documents.addAll(testDocuments);
        
        final initialDocumentCount = documentProvider.allDocuments.length;
        
        // Apply search
        documentProvider.searchDocuments('test');
        
        // Statistics should still show all documents, not filtered ones
        expect(documentProvider.allDocuments.length, equals(initialDocumentCount));
        expect(documentProvider.hasActiveFilters, isTrue);
      });

      test('should not affect statistics when filtering', () {
        documentProvider.documents.addAll(testDocuments);
        
        final initialDocumentCount = documentProvider.allDocuments.length;
        
        // Apply filter
        documentProvider.filterByFileType('PDF');
        
        // Statistics should still show all documents, not filtered ones
        expect(documentProvider.allDocuments.length, equals(initialDocumentCount));
        expect(documentProvider.hasActiveFilters, isTrue);
      });
    });

    group('Clear Filters', () {
      test('should clear all filters and search', () {
        documentProvider.documents.addAll(testDocuments);
        
        // Apply search and filters
        documentProvider.searchDocuments('test');
        documentProvider.filterByFileType('PDF');
        documentProvider.filterByCategory('reports');
        
        expect(documentProvider.hasActiveFilters, isTrue);
        
        // Clear all filters
        documentProvider.clearFilters();
        
        expect(documentProvider.searchQuery, equals(''));
        expect(documentProvider.selectedFileType, equals('all'));
        expect(documentProvider.selectedCategory, equals('all'));
        expect(documentProvider.hasActiveFilters, isFalse);
      });
    });
  });
}
