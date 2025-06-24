import '../../models/document_model.dart';
import 'base_filter_state.dart';

/// Filter state specifically for the Category Files Screen
/// Handles filtering of documents within a specific category
class CategoryFilesFilterState extends BaseFilterState {
  final String categoryId;

  CategoryFilesFilterState({required this.categoryId});

  /// Check if a document matches the current filter criteria
  /// Note: Category filtering is implicit since this screen only shows files from one category
  @override
  bool matchesFilters(dynamic document) {
    if (document is! DocumentModel) return false;

    // Implicit category filter - only documents from this category should be passed here
    // but we'll double-check for safety
    if (document.category != categoryId) return false;

    // Search filter
    bool matchesSearch = searchQuery.isEmpty ||
        document.fileName.toLowerCase().contains(searchQuery.toLowerCase()) ||
        document.metadata.description
            .toLowerCase()
            .contains(searchQuery.toLowerCase()) ||
        document.metadata.tags
            .any((tag) => tag.toLowerCase().contains(searchQuery.toLowerCase()));

    // File type filter
    bool matchesFileType = selectedFileType == 'all' ||
        getFileTypeCategory(document.fileType) == selectedFileType;

    return matchesSearch && matchesFileType;
  }

  /// Apply filters to a list of documents from this category
  List<DocumentModel> applyFilters(List<DocumentModel> documents) {
    List<DocumentModel> filteredDocuments = documents.where((document) {
      return matchesFilters(document);
    }).toList();

    // Apply sorting
    filteredDocuments.sort((a, b) {
      int comparison = 0;

      switch (sortBy) {
        case 'fileName':
          comparison = a.fileName.compareTo(b.fileName);
          break;
        case 'fileSize':
          comparison = a.fileSize.compareTo(b.fileSize);
          break;
        case 'uploadedAt':
          comparison = a.uploadedAt.compareTo(b.uploadedAt);
          break;
        default:
          comparison = a.uploadedAt.compareTo(b.uploadedAt);
      }

      return sortAscending ? comparison : -comparison;
    });

    return filteredDocuments;
  }

  /// Get display name for the category this filter is associated with
  String get categoryDisplayName => 'Category Files';
}
