import 'package:flutter_test/flutter_test.dart';
import 'package:managementdoc/providers/document_provider.dart';
import 'package:managementdoc/core/utils/context_filter_utils.dart';
import 'package:managementdoc/models/document_model.dart';

void main() {
  group('CSV File Type Filter Tests', () {
    late DocumentProvider documentProvider;
    late List<DocumentModel> testDocuments;

    setUp(() {
      documentProvider = DocumentProvider();
      testDocuments = [
        DocumentModel(
          id: '1',
          fileName: 'test.pdf',
          fileType: 'PDF',
          fileSize: 1024,
          filePath: '/test/test.pdf',
          uploadedBy: 'test_user',
          uploadedAt: DateTime.now(),
          category: 'uncategorized',
          permissions: ['read'],
          metadata: DocumentMetadata(
            description: 'Test PDF document',
            tags: ['test', 'pdf'],
            version: '1.0',
          ),
        ),
        DocumentModel(
          id: '2',
          fileName: 'test.xlsx',
          fileType: 'Excel',
          fileSize: 2048,
          filePath: '/test/test.xlsx',
          uploadedBy: 'test_user',
          uploadedAt: DateTime.now(),
          category: 'uncategorized',
          permissions: ['read'],
          metadata: DocumentMetadata(
            description: 'Test Excel document',
            tags: ['test', 'excel'],
            version: '1.0',
          ),
        ),
        DocumentModel(
          id: '3',
          fileName: 'test.csv',
          fileType: 'CSV',
          fileSize: 512,
          filePath: '/test/test.csv',
          uploadedBy: 'test_user',
          uploadedAt: DateTime.now(),
          category: 'uncategorized',
          permissions: ['read'],
          metadata: DocumentMetadata(
            description: 'Test CSV document',
            tags: ['test', 'csv'],
            version: '1.0',
          ),
        ),
        DocumentModel(
          id: '4',
          fileName: 'test.docx',
          fileType: 'Word',
          fileSize: 1536,
          filePath: '/test/test.docx',
          uploadedBy: 'test_user',
          uploadedAt: DateTime.now(),
          category: 'uncategorized',
          permissions: ['read'],
          metadata: DocumentMetadata(
            description: 'Test Word document',
            tags: ['test', 'word'],
            version: '1.0',
          ),
        ),
      ];
    });

    test('DocumentProvider should categorize CSV files as Excel', () {
      // Set up documents in provider
      documentProvider.setDocuments(testDocuments);
      
      // Filter by Excel type
      documentProvider.filterByFileType('Excel');
      
      // Should return both Excel and CSV files
      final filteredDocs = documentProvider.filteredDocuments;
      expect(filteredDocs.length, equals(2));
      
      // Check that both xlsx and csv files are included
      final fileTypes = filteredDocs.map((doc) => doc.fileType).toList();
      expect(fileTypes.contains('Excel'), isTrue);
      expect(fileTypes.contains('CSV'), isTrue);
    });

    test('ContextFilterUtils should categorize CSV files as Excel', () {
      final filterState = FilterState();
      filterState.selectedFileType = 'Excel';
      
      final filteredDocs = ContextFilterUtils.applyContextFilters(
        documents: testDocuments,
        context: FilterContext.homeScreen,
        filterState: filterState,
      );
      
      // Should return both Excel and CSV files
      expect(filteredDocs.length, equals(2));
      
      // Check that both xlsx and csv files are included
      final fileTypes = filteredDocs.map((doc) => doc.fileType).toList();
      expect(fileTypes.contains('Excel'), isTrue);
      expect(fileTypes.contains('CSV'), isTrue);
    });

    test('PDF filter should not include CSV files', () {
      // Set up documents in provider
      documentProvider.setDocuments(testDocuments);
      
      // Filter by PDF type
      documentProvider.filterByFileType('PDF');
      
      // Should return only PDF files
      final filteredDocs = documentProvider.filteredDocuments;
      expect(filteredDocs.length, equals(1));
      expect(filteredDocs.first.fileType, equals('PDF'));
    });

    test('All files filter should include all documents', () {
      // Set up documents in provider
      documentProvider.setDocuments(testDocuments);
      
      // Filter by all files
      documentProvider.filterByFileType('all');
      
      // Should return all files
      final filteredDocs = documentProvider.filteredDocuments;
      expect(filteredDocs.length, equals(4));
    });
  });
}
