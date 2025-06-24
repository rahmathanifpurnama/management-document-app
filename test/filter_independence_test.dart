import 'package:flutter_test/flutter_test.dart';
import '../lib/providers/filter_states/home_screen_filter_state.dart';
import '../lib/providers/filter_states/category_files_filter_state.dart';
import '../lib/providers/filter_states/add_files_filter_state.dart';
import '../lib/models/document_model.dart';

void main() {
  group('Filter Independence Tests', () {
    late HomeScreenFilterState homeFilter;
    late CategoryFilesFilterState categoryFilter;
    late AddFilesFilterState addFilesFilter;

    setUp(() {
      homeFilter = HomeScreenFilterState();
      categoryFilter = CategoryFilesFilterState(categoryId: 'test-category');
      addFilesFilter = AddFilesFilterState(targetCategoryId: 'test-category');
    });

    test('Filter states should be independent', () {
      // Apply different filters to each state
      homeFilter.filterByFileType('PDF');
      categoryFilter.filterByFileType('Excel');
      addFilesFilter.filterByFileType('Image');

      // Verify each filter state maintains its own values
      expect(homeFilter.selectedFileType, equals('PDF'));
      expect(categoryFilter.selectedFileType, equals('Excel'));
      expect(addFilesFilter.selectedFileType, equals('Image'));
    });

    test('Search queries should be independent', () {
      // Apply different search queries
      homeFilter.searchDocuments('home search');
      categoryFilter.searchDocuments('category search');
      addFilesFilter.searchDocuments('add files search');

      // Verify each filter state maintains its own search query
      expect(homeFilter.searchQuery, equals('home search'));
      expect(categoryFilter.searchQuery, equals('category search'));
      expect(addFilesFilter.searchQuery, equals('add files search'));
    });

    test('Sort options should be independent', () {
      // Apply different sort options
      homeFilter.sortDocuments('fileName', ascending: true);
      categoryFilter.sortDocuments('fileSize', ascending: false);
      addFilesFilter.sortDocuments('uploadedAt', ascending: true);

      // Verify each filter state maintains its own sort settings
      expect(homeFilter.sortBy, equals('fileName'));
      expect(homeFilter.sortAscending, equals(true));

      expect(categoryFilter.sortBy, equals('fileSize'));
      expect(categoryFilter.sortAscending, equals(false));

      expect(addFilesFilter.sortBy, equals('uploadedAt'));
      expect(addFilesFilter.sortAscending, equals(true));
    });

    test('CSV files should be categorized as Excel', () {
      // Test CSV file categorization
      expect(homeFilter.getFileTypeCategory('test.csv'), equals('Excel'));
      expect(homeFilter.getFileTypeCategory('data.xlsx'), equals('Excel'));
      expect(
        homeFilter.getFileTypeCategory('spreadsheet.xls'),
        equals('Excel'),
      );

      // Test other file types remain unchanged
      expect(homeFilter.getFileTypeCategory('document.pdf'), equals('PDF'));
      expect(homeFilter.getFileTypeCategory('image.jpg'), equals('Image'));
    });

    test('Clear filters should only affect individual filter states', () {
      // Set up filters on all states
      homeFilter.filterByFileType('PDF');
      homeFilter.searchDocuments('test');

      categoryFilter.filterByFileType('Excel');
      categoryFilter.searchDocuments('category test');

      addFilesFilter.filterByFileType('Image');
      addFilesFilter.searchDocuments('add test');

      // Clear only home filter
      homeFilter.clearFilters();

      // Verify only home filter is cleared
      expect(homeFilter.selectedFileType, equals('all'));
      expect(homeFilter.searchQuery, equals(''));

      // Other filters should remain unchanged
      expect(categoryFilter.selectedFileType, equals('Excel'));
      expect(categoryFilter.searchQuery, equals('category test'));

      expect(addFilesFilter.selectedFileType, equals('Image'));
      expect(addFilesFilter.searchQuery, equals('add test'));
    });

    test('Document filtering should work correctly for each screen type', () {
      // Create test documents
      final categorizedDoc = DocumentModel(
        id: '1',
        fileName: 'categorized.pdf',
        fileType: 'application/pdf',
        filePath: '/path/to/categorized.pdf',
        uploadedBy: 'user1',
        fileSize: 1024,
        uploadedAt: DateTime.now(),
        category: 'test-category',
        permissions: ['user1'],
        metadata: DocumentMetadata(
          description: 'Test document',
          tags: ['test'],
        ),
      );

      final uncategorizedDoc = DocumentModel(
        id: '2',
        fileName: 'uncategorized.xlsx',
        fileType:
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        filePath: '/path/to/uncategorized.xlsx',
        uploadedBy: 'user2',
        fileSize: 2048,
        uploadedAt: DateTime.now(),
        category: '', // Uncategorized
        permissions: ['user2'],
        metadata: DocumentMetadata(
          description: 'Excel document',
          tags: ['excel'],
        ),
      );

      // Test home screen filter (should match both)
      expect(homeFilter.matchesFilters(categorizedDoc), isTrue);
      expect(homeFilter.matchesFilters(uncategorizedDoc), isTrue);

      // Test category filter (should only match categorized doc)
      expect(categoryFilter.matchesFilters(categorizedDoc), isTrue);
      expect(categoryFilter.matchesFilters(uncategorizedDoc), isFalse);

      // Test add files filter (should only match uncategorized doc)
      expect(addFilesFilter.matchesFilters(categorizedDoc), isFalse);
      expect(addFilesFilter.matchesFilters(uncategorizedDoc), isTrue);
    });
  });
}
