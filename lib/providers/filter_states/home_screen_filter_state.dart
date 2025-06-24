import '../../models/document_model.dart';
import 'base_filter_state.dart';

/// Filter state specifically for the Home Screen
/// Handles filtering of all documents displayed on the home screen
class HomeScreenFilterState extends BaseFilterState {
  String _selectedCategory = 'all';

  // Additional getter for category filtering (home screen specific)
  String get selectedCategory => _selectedCategory;

  @override
  bool get hasActiveFilters =>
      super.hasActiveFilters || _selectedCategory != 'all';

  // Filter by category (home screen specific)
  void filterByCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  @override
  void clearFilters() {
    super.clearFilters();
    _selectedCategory = 'all';
    notifyListeners();
  }

  /// Check if a document matches the current filter criteria
  @override
  bool matchesFilters(dynamic document) {
    if (document is! DocumentModel) return false;

    // Search filter
    bool matchesSearch = searchQuery.isEmpty ||
        document.fileName.toLowerCase().contains(searchQuery.toLowerCase()) ||
        document.metadata.description
            .toLowerCase()
            .contains(searchQuery.toLowerCase()) ||
        document.metadata.tags
            .any((tag) => tag.toLowerCase().contains(searchQuery.toLowerCase()));

    // Category filter
    bool matchesCategory =
        _selectedCategory == 'all' || document.category == _selectedCategory;

    // File type filter
    bool matchesFileType = selectedFileType == 'all' ||
        getFileTypeCategory(document.fileType) == selectedFileType;

    return matchesSearch && matchesCategory && matchesFileType;
  }

  /// Apply filters to a list of documents
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
        case 'category':
          comparison = a.category.compareTo(b.category);
          break;
        default:
          comparison = a.uploadedAt.compareTo(b.uploadedAt);
      }

      return sortAscending ? comparison : -comparison;
    });

    return filteredDocuments;
  }
}
