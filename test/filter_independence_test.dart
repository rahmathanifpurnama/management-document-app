import 'package:flutter_test/flutter_test.dart';
import 'package:managementdoc/widgets/common/file_filter_widget.dart';
import 'package:managementdoc/core/utils/context_filter_utils.dart';
import 'package:managementdoc/models/document_model.dart';

void main() {
  group('Filter Independence Tests', () {
    late List<DocumentModel> testDocuments;

    setUp(() {
      // Create test documents
      testDocuments = [
        DocumentModel(
          id: '1',
          fileName: 'test1.pdf',
          fileType: 'PDF',
          fileSize: 1024,
          filePath: '/test/test1.pdf',
          uploadedBy: 'test_user',
          uploadedAt: DateTime.now(),
          category: 'general',
          permissions: ['read'],
          metadata: DocumentMetadata(
            description: 'Test PDF document',
            tags: ['test', 'pdf'],
            version: '1.0',
          ),
        ),
        DocumentModel(
          id: '2',
          fileName: 'test2.xlsx',
          fileType: 'Excel',
          fileSize: 2048,
          filePath: '/test/test2.xlsx',
          uploadedBy: 'test_user',
          uploadedAt: DateTime.now().subtract(const Duration(days: 1)),
          category: 'category1',
          permissions: ['read'],
          metadata: DocumentMetadata(
            description: 'Test Excel document',
            tags: ['test', 'excel'],
            version: '1.0',
          ),
        ),
        DocumentModel(
          id: '3',
          fileName: 'test3.docx',
          fileType: 'Word',
          fileSize: 1536,
          filePath: '/test/test3.docx',
          uploadedBy: 'test_user',
          uploadedAt: DateTime.now().subtract(const Duration(days: 2)),
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

    test('Filter states should be independent across contexts', () {
      // Get filter states for different contexts
      final homeState = FilterStateManager.getState(FilterContext.homeScreen);
      final categoryState = FilterStateManager.getState(
        FilterContext.categoryFiles,
      );
      final addFilesState = FilterStateManager.getState(FilterContext.addFiles);

      // Verify initial states are independent
      expect(homeState, isNot(same(categoryState)));
      expect(categoryState, isNot(same(addFilesState)));
      expect(homeState, isNot(same(addFilesState)));

      // Modify home screen filter
      homeState.selectedFileType = 'PDF';
      homeState.searchQuery = 'home search';

      // Verify other contexts are not affected
      expect(categoryState.selectedFileType, equals('all'));
      expect(categoryState.searchQuery, equals(''));
      expect(addFilesState.selectedFileType, equals('all'));
      expect(addFilesState.searchQuery, equals(''));
    });

    test('Context-aware filtering should work correctly for home screen', () {
      final homeState = FilterStateManager.getState(FilterContext.homeScreen);
      homeState.selectedFileType = 'PDF';

      final filteredDocs = ContextFilterUtils.applyContextFilters(
        documents: testDocuments,
        context: FilterContext.homeScreen,
        filterState: homeState,
      );

      // Should only return PDF documents
      expect(filteredDocs.length, equals(1));
      expect(filteredDocs.first.fileType, equals('PDF'));
    });

    test(
      'Context-aware filtering should work correctly for category files',
      () {
        final categoryState = FilterStateManager.getState(
          FilterContext.categoryFiles,
        );
        categoryState.selectedFileType = 'all';

        final filteredDocs = ContextFilterUtils.applyContextFilters(
          documents: testDocuments,
          context: FilterContext.categoryFiles,
          filterState: categoryState,
          categoryId: 'category1',
        );

        // Should only return documents in category1
        expect(filteredDocs.length, equals(1));
        expect(filteredDocs.first.category, equals('category1'));
      },
    );

    test('Context-aware filtering should work correctly for add files', () {
      final addFilesState = FilterStateManager.getState(FilterContext.addFiles);
      addFilesState.selectedFileType = 'all';

      final filteredDocs = ContextFilterUtils.applyContextFilters(
        documents: testDocuments,
        context: FilterContext.addFiles,
        filterState: addFilesState,
        categoryId: 'category1',
      );

      // Should exclude documents already in category1
      expect(filteredDocs.length, equals(2));
      expect(filteredDocs.every((doc) => doc.category != 'category1'), isTrue);
    });

    test('Search filtering should work independently per context', () {
      final homeState = FilterStateManager.getState(FilterContext.homeScreen);
      final categoryState = FilterStateManager.getState(
        FilterContext.categoryFiles,
      );

      // Set different search queries
      homeState.searchQuery = 'pdf';
      categoryState.searchQuery = 'excel';

      // Test home screen filtering
      final homeFiltered = ContextFilterUtils.applyContextFilters(
        documents: testDocuments,
        context: FilterContext.homeScreen,
        filterState: homeState,
      );

      // Test category screen filtering
      final categoryFiltered = ContextFilterUtils.applyContextFilters(
        documents: testDocuments,
        context: FilterContext.categoryFiles,
        filterState: categoryState,
        categoryId: 'category1',
      );

      // Home should find PDF document
      expect(homeFiltered.length, equals(1));
      expect(homeFiltered.first.fileName.toLowerCase(), contains('pdf'));

      // Category should find Excel document in category1
      expect(categoryFiltered.length, equals(1));
      expect(categoryFiltered.first.fileName.toLowerCase(), contains('xlsx'));
    });

    test('Filter reset should only affect specific context', () {
      // Set filters for all contexts
      final homeState = FilterStateManager.getState(FilterContext.homeScreen);
      final categoryState = FilterStateManager.getState(
        FilterContext.categoryFiles,
      );
      final addFilesState = FilterStateManager.getState(FilterContext.addFiles);

      homeState.selectedFileType = 'PDF';
      homeState.searchQuery = 'home';
      categoryState.selectedFileType = 'Excel';
      categoryState.searchQuery = 'category';
      addFilesState.selectedFileType = 'Word';
      addFilesState.searchQuery = 'add';

      // Reset only home state
      FilterStateManager.resetState(FilterContext.homeScreen);

      // Verify only home state is reset
      expect(homeState.selectedFileType, equals('all'));
      expect(homeState.searchQuery, equals(''));
      expect(categoryState.selectedFileType, equals('Excel'));
      expect(categoryState.searchQuery, equals('category'));
      expect(addFilesState.selectedFileType, equals('Word'));
      expect(addFilesState.searchQuery, equals('add'));
    });

    test('Sorting should work independently per context', () {
      final homeState = FilterStateManager.getState(FilterContext.homeScreen);
      final categoryState = FilterStateManager.getState(
        FilterContext.categoryFiles,
      );

      // Set different sorting options
      homeState.sortBy = 'fileName';
      homeState.sortAscending = true;
      categoryState.sortBy = 'uploadedAt';
      categoryState.sortAscending = false;

      // Test home screen sorting
      final homeFiltered = ContextFilterUtils.applyContextFilters(
        documents: testDocuments,
        context: FilterContext.homeScreen,
        filterState: homeState,
      );

      // Test category screen sorting
      final categoryFiltered = ContextFilterUtils.applyContextFilters(
        documents: testDocuments,
        context: FilterContext.categoryFiles,
        filterState: categoryState,
        categoryId: 'category1',
      );

      // Home should be sorted by fileName ascending
      expect(homeFiltered.first.fileName, equals('test1.pdf'));

      // Category should be sorted by uploadedAt descending (newest first)
      if (categoryFiltered.isNotEmpty) {
        expect(categoryFiltered.first.category, equals('category1'));
      }
    });

    tearDown(() {
      // Reset all filter states after each test
      FilterStateManager.resetAllStates();
    });
  });
}
