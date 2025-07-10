import 'package:flutter/foundation.dart';
import '../../../core/riverpod/notifiers.dart';
import '../../../models/document_model.dart';
import '../models/file_selection_state.dart';

class FileSelectionNotifier extends BaseNotifier<FileSelectionState> {
  FileSelectionNotifier() : super(const FileSelectionState());

  /// Enter selection mode with an initial file
  void enterSelectionMode(
    DocumentModel initialFile,
    List<DocumentModel> availableFiles,
  ) {
    debugPrint(
      'FileSelectionNotifier: Entering selection mode with file: ${initialFile.fileName} (ID: ${initialFile.id})',
    );
    debugPrint(
      'FileSelectionNotifier: Available files count: ${availableFiles.length}',
    );
    debugPrint(
      'FileSelectionNotifier: File exists in available files: ${availableFiles.any((f) => f.id == initialFile.id)}',
    );

    safeUpdate(() => state.copyWith(
      isSelectionMode: true,
      availableFiles: List.from(availableFiles), // Create a copy
      selectedFileIds: {initialFile.id},
      lastAvailableFilesHash: null, // Reset hash to force update
    ));
  }

  /// Exit selection mode
  void exitSelectionMode() {
    debugPrint('FileSelectionNotifier: Exiting selection mode');
    
    safeUpdate(() => const FileSelectionState());
  }

  /// Toggle selection of a specific file
  void toggleFileSelection(String fileId) {
    if (!state.isSelectionMode) {
      debugPrint(
        'FileSelectionNotifier: Cannot toggle selection - not in selection mode',
      );
      return;
    }

    final wasSelected = state.selectedFileIds.contains(fileId);
    final newSelectedIds = Set<String>.from(state.selectedFileIds);
    
    if (wasSelected) {
      newSelectedIds.remove(fileId);
      debugPrint('FileSelectionNotifier: Deselected file: $fileId');
    } else {
      newSelectedIds.add(fileId);
      debugPrint('FileSelectionNotifier: Selected file: $fileId');
    }

    debugPrint(
      'FileSelectionNotifier: Total selected: ${newSelectedIds.length}',
    );

    safeUpdate(() => state.copyWith(selectedFileIds: newSelectedIds));
  }

  /// Select all available files
  void selectAll() {
    if (!state.isSelectionMode) return;

    final allFileIds = state.availableFiles.map((file) => file.id).toSet();
    
    safeUpdate(() => state.copyWith(selectedFileIds: allFileIds));
  }

  /// Clear all selections but stay in selection mode
  void clearSelection() {
    if (!state.isSelectionMode) return;

    debugPrint(
      'FileSelectionNotifier: Cleared all selections, staying in selection mode',
    );
    
    safeUpdate(() => state.copyWith(selectedFileIds: {}));
  }

  /// Update available files (useful when files list changes)
  void updateAvailableFiles(List<DocumentModel> files) {
    // Don't update available files while in selection mode to prevent race conditions
    if (state.isSelectionMode) {
      debugPrint(
        'FileSelectionNotifier: Skipping updateAvailableFiles while in selection mode to prevent conflicts',
      );
      return;
    }

    // Check if files have actually changed
    if (!state.hasFilesChanged(files)) {
      return; // No changes, skip update
    }

    if (state.isUpdatingAvailableFiles) {
      debugPrint(
        'FileSelectionNotifier: Already updating available files, skipping',
      );
      return;
    }

    final currentFilesHash = state.generateFilesHash(files);
    
    safeUpdate(() => state.copyWith(
      isUpdatingAvailableFiles: true,
      lastAvailableFilesHash: currentFilesHash,
    ));

    try {
      final newAvailableFiles = List<DocumentModel>.from(files);
      
      debugPrint(
        'FileSelectionNotifier: Updated available files count: ${files.length}',
      );

      // Validate selection state consistency
      _validateSelectionState(newAvailableFiles);

      safeUpdate(() => state.copyWith(
        availableFiles: newAvailableFiles,
        isUpdatingAvailableFiles: false,
      ));
    } catch (e) {
      debugPrint('FileSelectionNotifier: Error updating available files: $e');
      safeUpdate(() => state.copyWith(isUpdatingAvailableFiles: false));
    }
  }

  /// Validate selection state consistency
  void _validateSelectionState(List<DocumentModel> availableFiles) {
    if (!state.isSelectionMode) return;

    final availableFileIds = availableFiles.map((f) => f.id).toSet();
    final invalidSelections = state.selectedFileIds
        .where((id) => !availableFileIds.contains(id))
        .toList();

    if (invalidSelections.isNotEmpty) {
      debugPrint(
        'FileSelectionNotifier: Found invalid selections: $invalidSelections',
      );
      
      // Remove invalid selections
      final validSelections = state.selectedFileIds
          .where((id) => availableFileIds.contains(id))
          .toSet();
      
      safeUpdate(() => state.copyWith(selectedFileIds: validSelections));
    }
  }

  @override
  void reset() {
    state = const FileSelectionState();
  }
}
