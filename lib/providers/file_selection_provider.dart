import 'package:flutter/foundation.dart';
import '../models/document_model.dart';

/// Provider for managing file selection state across the application
class FileSelectionProvider extends ChangeNotifier {
  // Selection state
  bool _isSelectionMode = false;
  final Set<String> _selectedFileIds = <String>{};
  List<DocumentModel> _availableFiles = [];

  // Getters
  bool get isSelectionMode => _isSelectionMode;
  Set<String> get selectedFileIds => Set.unmodifiable(_selectedFileIds);
  List<DocumentModel> get selectedFiles => _availableFiles
      .where((file) => _selectedFileIds.contains(file.id))
      .toList();
  int get selectedCount => _selectedFileIds.length;
  bool get hasSelection => _selectedFileIds.isNotEmpty;
  bool get isAllSelected =>
      _availableFiles.isNotEmpty &&
      _selectedFileIds.length == _availableFiles.length;

  /// Check if a specific file is selected
  bool isFileSelected(String fileId) {
    return _selectedFileIds.contains(fileId);
  }

  /// Enter selection mode with an initial file
  void enterSelectionMode(
    DocumentModel initialFile,
    List<DocumentModel> availableFiles,
  ) {
    _isSelectionMode = true;
    _availableFiles = availableFiles;
    _selectedFileIds.clear();
    _selectedFileIds.add(initialFile.id);
    notifyListeners();
  }

  /// Exit selection mode and clear all selections
  void exitSelectionMode() {
    _isSelectionMode = false;
    _selectedFileIds.clear();
    _availableFiles.clear();
    notifyListeners();
  }

  /// Toggle selection of a specific file
  void toggleFileSelection(String fileId) {
    if (!_isSelectionMode) return;

    if (_selectedFileIds.contains(fileId)) {
      _selectedFileIds.remove(fileId);
    } else {
      _selectedFileIds.add(fileId);
    }

    // Always notify listeners, don't auto-exit selection mode
    // Let user explicitly exit via close button or operation completion
    notifyListeners();
  }

  /// Select all available files
  void selectAll() {
    if (!_isSelectionMode) return;

    _selectedFileIds.clear();
    _selectedFileIds.addAll(_availableFiles.map((file) => file.id));
    notifyListeners();
  }

  /// Clear all selections but stay in selection mode
  void clearSelection() {
    if (!_isSelectionMode) return;

    _selectedFileIds.clear();
    // Stay in selection mode, just clear selections
    notifyListeners();
  }

  /// Update available files (useful when files list changes)
  void updateAvailableFiles(List<DocumentModel> files) {
    _availableFiles = files;

    // Remove selected files that are no longer available
    _selectedFileIds.removeWhere((id) => !files.any((file) => file.id == id));

    // Only notify listeners if in selection mode, don't auto-exit
    if (_isSelectionMode) {
      notifyListeners();
    }
  }

  /// Get selection summary text
  String getSelectionSummary() {
    if (!_isSelectionMode || _selectedFileIds.isEmpty) {
      return '';
    }

    final count = _selectedFileIds.length;
    return '$count file${count == 1 ? '' : 's'} selected';
  }
}
