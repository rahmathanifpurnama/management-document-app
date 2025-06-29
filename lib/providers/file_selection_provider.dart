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
      'FileSelectionProvider: Entered selection mode with file: ${initialFile.fileName} (ID: ${initialFile.id})',
    );
    debugPrint(
      'FileSelectionProvider: Available files count: ${availableFiles.length}',
    );
    debugPrint(
      'FileSelectionProvider: File exists in available files: ${availableFiles.any((f) => f.id == initialFile.id)}',
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
    debugPrint(
      'FileSelectionProvider: Cleared all selections, staying in selection mode',
    );
    notifyListeners();
  }

  /// Check if we should show selection UI (true when in selection mode, regardless of selection count)
  bool get shouldShowSelectionUI => _isSelectionMode;

  /// Update available files (useful when files list changes)
  /// Enhanced with better race condition prevention and state validation
  void updateAvailableFiles(List<DocumentModel> files) {
    // CRITICAL FIX: Don't update available files while in selection mode to prevent race conditions
    // The files are already set when entering selection mode
    if (_isSelectionMode) {
      debugPrint(
        'FileSelectionProvider: Skipping updateAvailableFiles while in selection mode to prevent conflicts',
      );
      return;
    }

    // ENHANCED: Prevent multiple rapid updates by checking if files actually changed
    final currentFilesHash = _generateFilesHash(files);
    if (_lastAvailableFilesHash == currentFilesHash ||
        _isUpdatingAvailableFiles) {
      debugPrint(
        'FileSelectionProvider: Skipping duplicate updateAvailableFiles call',
      );
      return; // Skip if files haven't changed or update is in progress
    }

    _isUpdatingAvailableFiles = true;
    _lastAvailableFilesHash = currentFilesHash;

    try {
      _availableFiles = List.from(
        files,
      ); // Create a copy to prevent external modifications

      debugPrint(
        'FileSelectionProvider: Updated available files count: ${files.length}',
      );

      // CRITICAL: Never modify selections in updateAvailableFiles to prevent race conditions
      // Selections should only be modified through explicit user actions

      // ENHANCED: Validate selection state consistency
      _validateSelectionState();
    } finally {
      _isUpdatingAvailableFiles = false;
    }
  }

  /// Validate selection state consistency to prevent UI issues
  void _validateSelectionState() {
    if (!_isSelectionMode) return;

    // Remove any selected files that are no longer in available files
    final availableFileIds = _availableFiles.map((f) => f.id).toSet();
    final invalidSelections = _selectedFileIds
        .where((id) => !availableFileIds.contains(id))
        .toList();

    if (invalidSelections.isNotEmpty) {
      debugPrint(
        'FileSelectionProvider: Removing ${invalidSelections.length} invalid selections',
      );
      for (final invalidId in invalidSelections) {
        _selectedFileIds.remove(invalidId);
      }
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
