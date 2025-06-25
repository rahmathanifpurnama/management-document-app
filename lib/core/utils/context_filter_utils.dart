import '../../models/document_model.dart';
import '../../widgets/common/file_filter_widget.dart';

/// Utility class for applying context-specific filters to document lists
class ContextFilterUtils {
  /// Apply filters based on context and filter state
  static List<DocumentModel> applyContextFilters({
    required List<DocumentModel> documents,
    required FilterContext context,
    required ContextFilterState filterState,
    String? categoryId, // For category-specific filtering
  }) {
    var filteredDocuments = documents;

    // Apply search filter
    if (filterState.searchQuery.isNotEmpty) {
      filteredDocuments = filteredDocuments.where((document) {
        final query = filterState.searchQuery.toLowerCase();
        return document.fileName.toLowerCase().contains(query) ||
            document.metadata.description.toLowerCase().contains(query) ||
            document.metadata.tags.any(
              (tag) => tag.toLowerCase().contains(query),
            );
      }).toList();
    }

    // Apply file type filter
    if (filterState.selectedFileType != 'all') {
      filteredDocuments = filteredDocuments.where((document) {
        return _getFileTypeCategory(document.fileType) == filterState.selectedFileType;
      }).toList();
    }

    // Apply context-specific filters
    switch (context) {
      case FilterContext.homeScreen:
        // Home screen shows all documents (no additional filtering)
        break;
      case FilterContext.categoryFiles:
        // Category files screen shows only documents in specific category
        if (categoryId != null) {
          filteredDocuments = filteredDocuments.where((document) {
            return document.category == categoryId ||
                document.category.toLowerCase() == categoryId.toLowerCase();
          }).toList();
        }
        break;
      case FilterContext.addFiles:
        // Add files screen excludes documents already in target category
        if (categoryId != null) {
          filteredDocuments = filteredDocuments.where((document) {
            return document.category != categoryId &&
                document.category.toLowerCase() != categoryId.toLowerCase();
          }).toList();
        }
        break;
    }

    // Apply sorting
    filteredDocuments.sort((a, b) {
      int comparison = 0;

      switch (filterState.sortBy) {
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

      return filterState.sortAscending ? comparison : -comparison;
    });

    return filteredDocuments;
  }

  /// Get file type category for filtering (matches DocumentProvider logic)
  static String _getFileTypeCategory(String fileType) {
    final lowerFileType = fileType.toLowerCase();
    
    if (lowerFileType.contains('pdf')) {
      return 'PDF';
    } else if (lowerFileType.contains('doc') || lowerFileType.contains('docx')) {
      return 'DOC';
    } else if (lowerFileType.contains('xls') || lowerFileType.contains('xlsx')) {
      return 'Excel';
    } else if (lowerFileType.contains('csv')) {
      return 'CSV';
    } else if (lowerFileType.contains('ppt') || lowerFileType.contains('pptx')) {
      return 'PPT';
    } else if (lowerFileType.contains('txt')) {
      return 'TXT';
    } else if (lowerFileType.contains('jpg') || 
               lowerFileType.contains('jpeg') || 
               lowerFileType.contains('png') || 
               lowerFileType.contains('gif') || 
               lowerFileType.contains('bmp') || 
               lowerFileType.contains('webp')) {
      return 'Image';
    } else {
      return 'Other';
    }
  }

  /// Check if documents match search query (for real-time search)
  static bool matchesSearchQuery(DocumentModel document, String query) {
    if (query.isEmpty) return true;
    
    final lowerQuery = query.toLowerCase();
    return document.fileName.toLowerCase().contains(lowerQuery) ||
        document.metadata.description.toLowerCase().contains(lowerQuery) ||
        document.metadata.tags.any(
          (tag) => tag.toLowerCase().contains(lowerQuery),
        );
  }

  /// Get context-appropriate title for filter UI
  static String getContextTitle(FilterContext context) {
    switch (context) {
      case FilterContext.homeScreen:
        return 'Filter All Files';
      case FilterContext.categoryFiles:
        return 'Filter Category Files';
      case FilterContext.addFiles:
        return 'Filter Available Files';
    }
  }

  /// Get context-appropriate empty state message
  static String getContextEmptyMessage(FilterContext context) {
    switch (context) {
      case FilterContext.homeScreen:
        return 'No files match your filters';
      case FilterContext.categoryFiles:
        return 'No files in this category match your filters';
      case FilterContext.addFiles:
        return 'No available files match your filters';
    }
  }

  /// Check if context should show category filter option
  static bool shouldShowCategoryFilter(FilterContext context) {
    switch (context) {
      case FilterContext.homeScreen:
        return true; // Home screen can filter by category
      case FilterContext.categoryFiles:
        return false; // Category screen already filtered by category
      case FilterContext.addFiles:
        return false; // Add files screen excludes target category
    }
  }
}
