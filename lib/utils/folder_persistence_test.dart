import 'package:flutter/material.dart';
import '../providers/document_provider.dart';
import '../providers/category_provider.dart';

/// Test utility to verify folder/category file persistence functionality
class FolderPersistenceTest {
  static Future<Map<String, dynamic>> runPersistenceTest({
    required DocumentProvider documentProvider,
    required CategoryProvider categoryProvider,
  }) async {
    final results = <String, dynamic>{
      'success': false,
      'tests': <String, bool>{},
      'errors': <String>[],
      'details': <String, dynamic>{},
    };

    try {
      debugPrint('🧪 Starting folder persistence test...');

      // Test 1: Check if categories are properly loaded
      await categoryProvider.loadCategories();
      final categories = categoryProvider.categories;
      results['tests']['categories_loaded'] = categories.isNotEmpty;
      results['details']['categories_count'] = categories.length;
      debugPrint(
        '✅ Test 1: Categories loaded - ${categories.length} categories',
      );

      if (categories.isEmpty) {
        results['errors'].add(
          'No categories found - cannot test file persistence',
        );
        return results;
      }

      // Test 2: Check if documents are properly loaded
      await documentProvider.loadDocuments();
      final allDocuments = documentProvider.allDocuments;
      results['tests']['documents_loaded'] = allDocuments.isNotEmpty;
      results['details']['documents_count'] = allDocuments.length;
      debugPrint(
        '✅ Test 2: Documents loaded - ${allDocuments.length} documents',
      );

      // Test 3: Check category-document associations
      final categoryDocumentCounts = <String, int>{};
      for (final category in categories) {
        final categoryDocs = documentProvider.getDocumentsByCategory(
          category.id,
        );
        categoryDocumentCounts[category.name] = categoryDocs.length;
        debugPrint(
          '📁 Category "${category.name}": ${categoryDocs.length} documents',
        );
      }
      results['details']['category_document_counts'] = categoryDocumentCounts;
      results['tests']['category_associations_exist'] = categoryDocumentCounts
          .values
          .any((count) => count > 0);

      // Test 4: Test async Firebase fallback for empty categories
      bool asyncFallbackWorks = true;
      for (final category in categories.take(3)) {
        // Test first 3 categories
        try {
          final asyncDocs = await documentProvider.getDocumentsByCategoryAsync(
            category.id,
          );
          debugPrint(
            '🔄 Async fallback for "${category.name}": ${asyncDocs.length} documents',
          );
        } catch (e) {
          debugPrint('❌ Async fallback failed for "${category.name}": $e');
          asyncFallbackWorks = false;
          results['errors'].add(
            'Async fallback failed for category ${category.name}: $e',
          );
        }
      }
      results['tests']['async_fallback_works'] = asyncFallbackWorks;

      // Test 5: Test folder refresh functionality
      bool refreshWorks = true;
      try {
        await documentProvider.refreshFolderContents();
        debugPrint('✅ Folder refresh completed successfully');
      } catch (e) {
        debugPrint('❌ Folder refresh failed: $e');
        refreshWorks = false;
        results['errors'].add('Folder refresh failed: $e');
      }
      results['tests']['folder_refresh_works'] = refreshWorks;

      // Test 6: Check if documents persist across provider reloads
      final documentsBeforeReload = documentProvider.allDocuments.length;
      await documentProvider.loadDocuments();
      final documentsAfterReload = documentProvider.allDocuments.length;
      results['tests']['documents_persist_reload'] =
          documentsBeforeReload == documentsAfterReload;
      results['details']['documents_before_reload'] = documentsBeforeReload;
      results['details']['documents_after_reload'] = documentsAfterReload;
      debugPrint(
        '🔄 Documents before reload: $documentsBeforeReload, after reload: $documentsAfterReload',
      );

      // Overall success check
      final allTestsPassed = results['tests'].values.every(
        (test) => test == true,
      );
      results['success'] = allTestsPassed && results['errors'].isEmpty;

      debugPrint('🧪 Folder persistence test completed');
      debugPrint('📊 Results: ${results['tests']}');
      if (results['errors'].isNotEmpty) {
        debugPrint('❌ Errors: ${results['errors']}');
      }

      return results;
    } catch (e) {
      debugPrint('❌ Folder persistence test failed: $e');
      results['errors'].add('Test execution failed: $e');
      results['success'] = false;
      return results;
    }
  }

  /// Quick diagnostic check for folder persistence issues
  static Future<String> quickDiagnostic({
    required DocumentProvider documentProvider,
    required CategoryProvider categoryProvider,
  }) async {
    final buffer = StringBuffer();
    buffer.writeln('🔍 FOLDER PERSISTENCE DIAGNOSTIC');
    buffer.writeln('================================');

    try {
      // Check categories
      await categoryProvider.loadCategories();
      final categories = categoryProvider.categories;
      buffer.writeln('📁 Categories: ${categories.length}');

      // Check documents
      await documentProvider.loadDocuments();
      final documents = documentProvider.allDocuments;
      buffer.writeln('📄 Total Documents: ${documents.length}');

      // Check category distributions
      buffer.writeln('\n📊 CATEGORY DISTRIBUTION:');
      for (final category in categories.take(10)) {
        // Show first 10 categories
        final categoryDocs = documentProvider.getDocumentsByCategory(
          category.id,
        );
        buffer.writeln('  • ${category.name}: ${categoryDocs.length} files');
      }

      // Check for empty categories
      final emptyCategories = categories.where((cat) {
        final docs = documentProvider.getDocumentsByCategory(cat.id);
        return docs.isEmpty;
      }).toList();

      if (emptyCategories.isNotEmpty) {
        buffer.writeln('\n⚠️  EMPTY CATEGORIES (${emptyCategories.length}):');
        for (final cat in emptyCategories.take(5)) {
          buffer.writeln('  • ${cat.name}');
        }
      }

      // Check uncategorized documents
      final uncategorizedDocs = documentProvider.getDocumentsByCategory(
        'uncategorized',
      );
      buffer.writeln(
        '\n📋 Uncategorized Documents: ${uncategorizedDocs.length}',
      );

      buffer.writeln('\n✅ Diagnostic completed successfully');
    } catch (e) {
      buffer.writeln('\n❌ Diagnostic failed: $e');
    }

    return buffer.toString();
  }

  /// Test adding files to a category
  static Future<bool> testAddFilesToCategory({
    required DocumentProvider documentProvider,
    required CategoryProvider categoryProvider,
    required String categoryId,
    required List<String> documentIds,
  }) async {
    try {
      debugPrint('🧪 Testing add files to category: $categoryId');

      // Get initial count
      final initialDocs = documentProvider.getDocumentsByCategory(categoryId);
      final initialCount = initialDocs.length;

      // Add files to category
      await documentProvider.updateMultipleDocumentsCategory(
        documentIds,
        categoryId,
      );

      // Check if files were added
      final finalDocs = documentProvider.getDocumentsByCategory(categoryId);
      final finalCount = finalDocs.length;

      final success = finalCount > initialCount;
      debugPrint(
        '📊 Add files test: Initial: $initialCount, Final: $finalCount, Success: $success',
      );

      return success;
    } catch (e) {
      debugPrint('❌ Add files test failed: $e');
      return false;
    }
  }
}
