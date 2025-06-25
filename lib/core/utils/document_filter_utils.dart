import 'package:flutter/material.dart';
import '../../models/document_model.dart';
import '../../widgets/common/advanced_search_filter.dart';

class DocumentFilterUtils {
  /// Apply search and filter state to a list of documents
  static List<DocumentModel> applyFilters(
    List<DocumentModel> documents,
    SearchFilterState filterState,
  ) {
    List<DocumentModel> filtered = List.from(documents);

    // Apply search query
    if (filterState.searchQuery.isNotEmpty) {
      filtered = _applySearchQuery(filtered, filterState.searchQuery);
    }

    // Apply status filter
    filtered = _applyStatusFilter(filtered, filterState.selectedFilter);

    // Apply file type filter
    if (filterState.selectedFileTypes.isNotEmpty) {
      filtered = _applyFileTypeFilter(filtered, filterState.selectedFileTypes);
    }

    // Apply date range filter
    if (filterState.dateRange != null) {
      filtered = _applyDateRangeFilter(filtered, filterState.dateRange!);
    }

    // Apply favorites filter
    if (filterState.showOnlyFavorites) {
      filtered = _applyFavoritesFilter(filtered);
    }

    // Apply sorting
    filtered = _applySorting(filtered, filterState.sortOption);

    return filtered;
  }

  /// Apply search query to documents
  static List<DocumentModel> _applySearchQuery(
    List<DocumentModel> documents,
    String query,
  ) {
    final lowercaseQuery = query.toLowerCase();

    return documents.where((document) {
      // Search in file name
      if (document.fileName.toLowerCase().contains(lowercaseQuery)) {
        return true;
      }

      // Search in uploader name
      if (document.uploadedBy.toLowerCase().contains(lowercaseQuery)) {
        return true;
      }

      // Search in description
      if (document.metadata.description.toLowerCase().contains(
        lowercaseQuery,
      )) {
        return true;
      }

      // Search in tags
      if (document.metadata.tags.any(
        (tag) => tag.toLowerCase().contains(lowercaseQuery),
      )) {
        return true;
      }

      // Search in category
      if (document.category.toLowerCase().contains(lowercaseQuery)) {
        return true;
      }

      return false;
    }).toList();
  }

  /// Apply status filter to documents
  static List<DocumentModel> _applyStatusFilter(
    List<DocumentModel> documents,
    String statusFilter,
  ) {
    switch (statusFilter.toLowerCase()) {
      case 'pending':
        return documents.where((doc) => doc.metadata.isPending).toList();
      case 'approved':
        return documents.where((doc) => doc.metadata.isApproved).toList();
      case 'rejected':
        return documents.where((doc) => doc.metadata.isRejected).toList();
      case 'recent':
        final weekAgo = DateTime.now().subtract(const Duration(days: 7));
        return documents
            .where((doc) => doc.uploadedAt.isAfter(weekAgo))
            .toList();
      case 'all':
      default:
        return documents;
    }
  }

  /// Apply file type filter to documents
  static List<DocumentModel> _applyFileTypeFilter(
    List<DocumentModel> documents,
    List<String> fileTypes,
  ) {
    return documents.where((document) {
      final fileExtension = _getFileExtension(document.fileName).toLowerCase();
      return fileTypes.any(
        (type) =>
            type.toLowerCase() == fileExtension ||
            _isFileTypeMatch(fileExtension, type.toLowerCase()),
      );
    }).toList();
  }

  /// Apply date range filter to documents
  static List<DocumentModel> _applyDateRangeFilter(
    List<DocumentModel> documents,
    DateTimeRange dateRange,
  ) {
    return documents.where((document) {
      final uploadDate = DateTime(
        document.uploadedAt.year,
        document.uploadedAt.month,
        document.uploadedAt.day,
      );

      return uploadDate.isAfter(
            dateRange.start.subtract(const Duration(days: 1)),
          ) &&
          uploadDate.isBefore(dateRange.end.add(const Duration(days: 1)));
    }).toList();
  }

  /// Apply favorites filter to documents
  static List<DocumentModel> _applyFavoritesFilter(
    List<DocumentModel> documents,
  ) {
    // Note: This would require a favorites field in the document model
    // For now, we'll return all documents
    return documents;
  }

  /// Apply sorting to documents
  static List<DocumentModel> _applySorting(
    List<DocumentModel> documents,
    SortOption sortOption,
  ) {
    final sortedDocuments = List<DocumentModel>.from(documents);

    switch (sortOption) {
      case SortOption.nameAsc:
        sortedDocuments.sort(
          (a, b) =>
              a.fileName.toLowerCase().compareTo(b.fileName.toLowerCase()),
        );
        break;
      case SortOption.nameDesc:
        sortedDocuments.sort(
          (a, b) =>
              b.fileName.toLowerCase().compareTo(a.fileName.toLowerCase()),
        );
        break;
      case SortOption.dateAsc:
        sortedDocuments.sort((a, b) => a.uploadedAt.compareTo(b.uploadedAt));
        break;
      case SortOption.dateDesc:
        sortedDocuments.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
        break;
      case SortOption.sizeAsc:
        sortedDocuments.sort((a, b) => a.fileSize.compareTo(b.fileSize));
        break;
      case SortOption.sizeDesc:
        sortedDocuments.sort((a, b) => b.fileSize.compareTo(a.fileSize));
        break;
    }

    return sortedDocuments;
  }

  /// Get file extension from filename
  static String _getFileExtension(String fileName) {
    final lastDotIndex = fileName.lastIndexOf('.');
    if (lastDotIndex == -1 || lastDotIndex == fileName.length - 1) {
      return '';
    }
    return fileName.substring(lastDotIndex + 1);
  }

  /// Check if file extension matches a file type category
  static bool _isFileTypeMatch(String extension, String category) {
    switch (category) {
      case 'document':
      case 'doc':
        return ['pdf', 'doc', 'docx', 'txt', 'rtf'].contains(extension);
      case 'spreadsheet':
      case 'excel':
        return ['xls', 'xlsx', 'csv'].contains(extension);
      case 'presentation':
      case 'powerpoint':
        return ['ppt', 'pptx'].contains(extension);
      case 'image':
        return [
          'jpg',
          'jpeg',
          'png',
          'gif',
          'bmp',
          'svg',
          'webp',
        ].contains(extension);
      case 'video':
        return [
          'mp4',
          'avi',
          'mov',
          'wmv',
          'flv',
          'webm',
          'mkv',
        ].contains(extension);
      case 'audio':
        return ['mp3', 'wav', 'flac', 'aac', 'ogg', 'wma'].contains(extension);
      case 'archive':
        return ['zip', 'rar', '7z', 'tar', 'gz', 'bz2'].contains(extension);
      default:
        return false;
    }
  }

  /// Get available file types from a list of documents
  static List<String> getAvailableFileTypes(List<DocumentModel> documents) {
    final Set<String> fileTypes = {};

    for (final document in documents) {
      final extension = _getFileExtension(document.fileName).toLowerCase();
      if (extension.isNotEmpty) {
        fileTypes.add(extension);
      }
    }

    return fileTypes.toList()..sort();
  }

  /// Get file type categories from a list of documents
  static List<String> getFileTypeCategories(List<DocumentModel> documents) {
    final Set<String> categories = {};

    for (final document in documents) {
      final extension = _getFileExtension(document.fileName).toLowerCase();
      final category = _getFileTypeCategory(extension);
      if (category.isNotEmpty) {
        categories.add(category);
      }
    }

    return categories.toList()..sort();
  }

  /// Get file type category for an extension
  static String _getFileTypeCategory(String extension) {
    if (['pdf', 'doc', 'docx', 'txt', 'rtf'].contains(extension)) {
      return 'document';
    } else if (['xls', 'xlsx', 'csv'].contains(extension)) {
      return 'excel';
    } else if (['ppt', 'pptx'].contains(extension)) {
      return 'presentation';
    } else if ([
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp',
      'svg',
      'webp',
    ].contains(extension)) {
      return 'image';
    } else if ([
      'mp4',
      'avi',
      'mov',
      'wmv',
      'flv',
      'webm',
      'mkv',
    ].contains(extension)) {
      return 'video';
    } else if ([
      'mp3',
      'wav',
      'flac',
      'aac',
      'ogg',
      'wma',
    ].contains(extension)) {
      return 'audio';
    } else if (['zip', 'rar', '7z', 'tar', 'gz', 'bz2'].contains(extension)) {
      return 'archive';
    }
    return '';
  }

  /// Get filter statistics for a list of documents
  static Map<String, int> getFilterStatistics(List<DocumentModel> documents) {
    int pendingCount = 0;
    int approvedCount = 0;
    int rejectedCount = 0;
    int recentCount = 0;

    final weekAgo = DateTime.now().subtract(const Duration(days: 7));

    for (final document in documents) {
      if (document.metadata.isPending) pendingCount++;
      if (document.metadata.isApproved) approvedCount++;
      if (document.metadata.isRejected) rejectedCount++;
      if (document.uploadedAt.isAfter(weekAgo)) recentCount++;
    }

    return {
      'all': documents.length,
      'pending': pendingCount,
      'approved': approvedCount,
      'rejected': rejectedCount,
      'recent': recentCount,
    };
  }

  /// Create a search filter state with smart defaults
  static SearchFilterState createDefaultFilterState({
    List<DocumentModel>? documents,
    String? initialFilter,
  }) {
    return SearchFilterState(
      selectedFilter: initialFilter ?? 'all',
      selectedFileTypes: [],
      sortOption: SortOption.dateDesc,
    );
  }

  /// Check if any filters are active
  static bool hasActiveFilters(SearchFilterState filterState) {
    return filterState.searchQuery.isNotEmpty ||
        filterState.selectedFilter != 'all' ||
        filterState.selectedFileTypes.isNotEmpty ||
        filterState.dateRange != null ||
        filterState.showOnlyFavorites;
  }

  /// Get a summary of active filters
  static String getActiveFiltersSummary(SearchFilterState filterState) {
    final List<String> activeFilters = [];

    if (filterState.searchQuery.isNotEmpty) {
      activeFilters.add('Search: "${filterState.searchQuery}"');
    }

    if (filterState.selectedFilter != 'all') {
      activeFilters.add('Status: ${filterState.selectedFilter}');
    }

    if (filterState.selectedFileTypes.isNotEmpty) {
      activeFilters.add('Types: ${filterState.selectedFileTypes.join(', ')}');
    }

    if (filterState.dateRange != null) {
      activeFilters.add('Date range selected');
    }

    if (filterState.showOnlyFavorites) {
      activeFilters.add('Favorites only');
    }

    return activeFilters.isEmpty
        ? 'No filters active'
        : activeFilters.join(' • ');
  }
}
