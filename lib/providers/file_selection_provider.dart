import 'package:flutter/foundation.dart';
import '../models/document_model.dart';

/// Provider for managing file selection state across the application
class FileSelectionProvider extends ChangeNotifier {
  // Selection state
  bool _isSelectionMode = false;
  final Set<String> _selectedFileIds = <String>{};
  List<DocumentModel> _availableFiles = [];

  // Debouncing mechanism to prevent multiple rapid updates
  String? _lastAvailableFilesHash;
  bool _isUpdatingAvailableFiles = false;

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

    // Force update available files when entering selection mode
    _lastAvailableFilesHash = null; // Reset hash to force update
    _availableFiles = availableFiles;

    _selectedFileIds.clear();
    _selectedFileIds.add(initialFile.id);

    debugPrint(
      'FileSelectionProvider: Entered selection mode with file: ${initialFile.fileName}',
    );
    notifyListeners();
  }

  /// Exit selection mode and clear all selections
  void exitSelectionMode() {
    debugPrint('FileSelectionProvider: Exiting selection mode');
    _isSelectionMode = false;
    _selectedFileIds.clear();
    // Don't clear _availableFiles immediately to prevent UI flicker
    // Files will be cleared when entering new selection mode
    notifyListeners();
  }

  /// Safely clear available files (called when needed)
  void clearAvailableFiles() {
    _availableFiles.clear();
    notifyListeners();
  }

  /// Toggle selection of a specific file
  void toggleFileSelection(String fileId) {
    if (!_isSelectionMode) {
      debugPrint(
        'FileSelectionProvider: Cannot toggle selection - not in selection mode',
      );
      return;
    }

    final wasSelected = _selectedFileIds.contains(fileId);
    if (wasSelected) {
      _selectedFileIds.remove(fileId);
      debugPrint('FileSelectionProvider: Deselected file: $fileId');
    } else {
      _selectedFileIds.add(fileId);
      debugPrint('FileSelectionProvider: Selected file: $fileId');
    }

    debugPrint(
      'FileSelectionProvider: Total selected: ${_selectedFileIds.length}',
    );

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
  /// Uses debouncing to prevent multiple rapid updates that can interfere with selection
  void updateAvailableFiles(List<DocumentModel> files) {
    // Prevent multiple rapid updates by checking if files actually changed
    final currentFilesHash = _generateFilesHash(files);
    if (_lastAvailableFilesHash == currentFilesHash ||
        _isUpdatingAvailableFiles) {
      return; // Skip if files haven't changed or update is in progress
    }

    _isUpdatingAvailableFiles = true;
    _lastAvailableFilesHash = currentFilesHash;

    try {
      _availableFiles = files;

      // Only remove selected files that are truly no longer available
      // Be more conservative to prevent accidental selection loss
      if (_isSelectionMode && _selectedFileIds.isNotEmpty) {
        final validFileIds = files.map((file) => file.id).toSet();
        final invalidSelections = _selectedFileIds
            .where((id) => !validFileIds.contains(id))
            .toList();

        // Only remove selections if we're sure they're invalid
        if (invalidSelections.isNotEmpty) {
          debugPrint(
            'FileSelectionProvider: Removing invalid selections: $invalidSelections',
          );
          _selectedFileIds.removeWhere((id) => !validFileIds.contains(id));
        }
      }

      // Only notify listeners if in selection mode, don't auto-exit
      if (_isSelectionMode) {
        notifyListeners();
      }
    } finally {
      _isUpdatingAvailableFiles = false;
    }
  }

  /// Generate a simple hash for files list to detect changes
  String _generateFilesHash(List<DocumentModel> files) {
    if (files.isEmpty) return 'empty';

    // Create a simple hash based on file IDs and count
    final fileIds = files.map((f) => f.id).toList()..sort();
    return '${files.length}_${fileIds.take(5).join('_')}';
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
