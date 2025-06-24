import 'package:flutter/foundation.dart';

/// Base class for screen-specific filter states
/// Provides common filtering functionality that can be extended by specific screens
abstract class BaseFilterState extends ChangeNotifier {
  String _searchQuery = '';
  String _selectedFileType = 'all';
  String _sortBy = 'uploadedAt';
  bool _sortAscending = false;

  // Getters
  String get searchQuery => _searchQuery;
  String get selectedFileType => _selectedFileType;
  String get sortBy => _sortBy;
  bool get sortAscending => _sortAscending;

  // Check if any filters are currently active
  bool get hasActiveFilters =>
      _searchQuery.isNotEmpty || _selectedFileType != 'all';

  // Search functionality
  void searchDocuments(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Filter by file type
  void filterByFileType(String fileType) {
    _selectedFileType = fileType;
    notifyListeners();
  }

  // Sort functionality
  void sortDocuments(String sortBy, {bool ascending = false}) {
    _sortBy = sortBy;
    _sortAscending = ascending;
    notifyListeners();
  }

  // Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedFileType = 'all';
    _sortBy = 'uploadedAt';
    _sortAscending = false;
    notifyListeners();
  }

  // Get file type category for filtering (consolidated CSV with Excel)
  String getFileTypeCategory(String fileType) {
    final lowerFileType = fileType.toLowerCase();

    if (lowerFileType.contains('pdf')) {
      return 'PDF';
    } else if (lowerFileType.contains('doc') ||
        lowerFileType.contains('word')) {
      return 'DOC';
    } else if (lowerFileType.contains('excel') ||
        lowerFileType.contains('sheet') ||
        lowerFileType.contains('xlsx') ||
        lowerFileType.contains('xls') ||
        lowerFileType.contains('csv')) {  // ← CSV consolidated with Excel
      return 'Excel';
    } else if (lowerFileType.contains('image') ||
        lowerFileType.contains('jpg') ||
        lowerFileType.contains('jpeg') ||
        lowerFileType.contains('png')) {
      return 'Image';
    } else if (lowerFileType.contains('powerpoint') ||
        lowerFileType.contains('presentation') ||
        lowerFileType.contains('pptx') ||
        lowerFileType.contains('ppt')) {
      return 'PPT';
    } else if (lowerFileType.contains('text') ||
        lowerFileType.contains('txt')) {
      return 'TXT';
    } else {
      return 'Other';
    }
  }

  // Abstract method for screen-specific filtering logic
  // Each screen can implement its own filtering behavior
  bool matchesFilters(dynamic document);
}
