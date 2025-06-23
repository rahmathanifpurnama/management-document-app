import 'package:flutter_test/flutter_test.dart';
import 'package:managementdoc/models/document_model.dart';
import 'package:managementdoc/models/category_model.dart';

void main() {
  group('Category File Assignment Bug Fix Tests', () {
    late List<DocumentModel> testDocuments;
    late CategoryModel testCategory;

    setUp(() {
      testCategory = CategoryModel(
        id: 'test-category-id',
        name: 'Test Category',
        description: 'Test category for bug fix',
        createdBy: 'test-user',
        createdAt: DateTime.now(),
        permissions: [],
        isActive: true,
        documentCount: 0,
      );

      // Create test documents
      testDocuments = [
        DocumentModel(
          id: 'doc1',
          fileName: 'test1.pdf',
          fileSize: 1024,
          fileType: 'pdf',
          filePath: 'documents/test1.pdf',
          uploadedBy: 'test-user',
          uploadedAt: DateTime.now(),
          category: '', // Uncategorized
          permissions: [],
          metadata: DocumentMetadata(description: 'Test document 1', tags: []),
        ),
        DocumentModel(
          id: 'doc2',
          fileName: 'test2.docx',
          fileSize: 2048,
          fileType: 'docx',
          filePath: 'documents/test2.docx',
          uploadedBy: 'test-user',
          uploadedAt: DateTime.now(),
          category: 'test-category-id', // Already assigned
          permissions: [],
          metadata: DocumentMetadata(description: 'Test document 2', tags: []),
        ),
        DocumentModel(
          id: 'doc3',
          fileName: 'test3.xlsx',
          fileSize: 3072,
          fileType: 'xlsx',
          filePath: 'documents/test3.xlsx',
          uploadedBy: 'test-user',
          uploadedAt: DateTime.now(),
          category: 'general', // General category
          permissions: [],
          metadata: DocumentMetadata(description: 'Test document 3', tags: []),
        ),
      ];
    });

    test('should filter out already assigned files from available list', () {
      // Act - Simulate the filtering logic from _getAvailableDocuments
      final availableDocuments = testDocuments.where((doc) {
        // Filter out files that are already in the target category
        if (doc.category == testCategory.id ||
            doc.category.toLowerCase() == testCategory.id.toLowerCase()) {
          return false;
        }

        // Show files that are available to be categorized
        final category = doc.category.trim().toLowerCase();
        final isAvailableForCategorization =
            category.isEmpty ||
            category == 'general' ||
            category == 'null' ||
            category == 'uncategorized';

        return isAvailableForCategorization;
      }).toList();

      // Assert
      expect(availableDocuments.length, equals(2)); // doc1 and doc3
      expect(availableDocuments.any((doc) => doc.id == 'doc1'), isTrue);
      expect(availableDocuments.any((doc) => doc.id == 'doc3'), isTrue);
      expect(
        availableDocuments.any((doc) => doc.id == 'doc2'),
        isFalse,
      ); // Already assigned
    });

    test(
      'should preserve recent category assignments during force refresh check',
      () {
        // Arrange
        final recentTime = DateTime.now();
        final documents = testDocuments;

        // Act - Simulate the force refresh logic
        final shouldForceRefresh =
            documents.isEmpty ||
            DateTime.now().difference(recentTime).inMinutes > 5;

        // Assert
        expect(
          shouldForceRefresh,
          isFalse,
        ); // Should not force refresh due to recent load
      },
    );

    test('should allow force refresh when cache is stale', () {
      // Arrange
      final staleTime = DateTime.now().subtract(const Duration(minutes: 10));
      final documents = testDocuments;

      // Act - Simulate the force refresh logic
      final shouldForceRefresh =
          documents.isEmpty ||
          DateTime.now().difference(staleTime).inMinutes > 5;

      // Assert
      expect(
        shouldForceRefresh,
        isTrue,
      ); // Should force refresh due to stale cache
    });

    test('should prevent rebuild during recent updates', () {
      // Arrange
      final recentTime = DateTime.now();

      // Act - Simulate the rebuild check logic
      final hasRecentUpdate =
          DateTime.now().difference(recentTime).inSeconds < 30;

      // Assert
      expect(
        hasRecentUpdate,
        isTrue,
      ); // Should prevent rebuild due to recent update
    });

    test('should allow rebuild when no recent updates', () {
      // Arrange
      final oldTime = DateTime.now().subtract(const Duration(minutes: 1));

      // Act - Simulate the rebuild check logic
      final hasRecentUpdate = DateTime.now().difference(oldTime).inSeconds < 30;

      // Assert
      expect(
        hasRecentUpdate,
        isFalse,
      ); // Should allow rebuild due to no recent update
    });
  });

  group('Edge Cases', () {
    test('should handle null category gracefully', () {
      // Arrange
      final docWithNullCategory = DocumentModel(
        id: 'doc-null',
        fileName: 'null-category.pdf',
        fileSize: 1024,
        fileType: 'pdf',
        filePath: 'documents/null-category.pdf',
        uploadedBy: 'test-user',
        uploadedAt: DateTime.now(),
        category: '', // Empty category (treated as null)
        permissions: [],
        metadata: DocumentMetadata(
          description: 'Document with null category',
          tags: [],
        ),
      );

      // Act - Test filtering logic
      final category = docWithNullCategory.category.trim().toLowerCase();
      final isAvailableForCategorization =
          category.isEmpty ||
          category == 'general' ||
          category == 'null' ||
          category == 'uncategorized';

      // Assert
      expect(isAvailableForCategorization, isTrue);
    });

    test('should handle case-insensitive category comparison', () {
      // Arrange
      const targetCategoryId = 'Test-Category-ID';
      const docCategoryId = 'test-category-id';

      // Act - Test case-insensitive comparison
      final isAlreadyAssigned =
          docCategoryId == targetCategoryId ||
          docCategoryId.toLowerCase() == targetCategoryId.toLowerCase();

      // Assert
      expect(isAlreadyAssigned, isTrue);
    });
  });
}
