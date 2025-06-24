import '../../models/document_model.dart';
import 'base_filter_state.dart';

/// Filter state specifically for the Add Files to Category Screen
/// Handles filtering of uncategorized documents that can be added to a category
class AddFilesFilterState extends BaseFilterState {
  final String targetCategoryId;

  AddFilesFilterState({required this.targetCategoryId});

  /// Check if a document matches the current filter criteria
  /// Note: Only uncategorized documents (empty category) should be shown on this screen
  @override
  bool matchesFilters(dynamic document) {
    if (document is! DocumentModel) return false;

    // Only show uncategorized documents (empty category)
    // This is the key difference from other screens
    if (document.category.isNotEmpty) return false;

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

  /// Apply filters to a list of documents, showing only uncategorized ones
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

  /// Get display name for this filter context
  String get displayName => 'Available Files';

  /// Get the target category ID this filter is associated with
  String get categoryId => targetCategoryId;
}
