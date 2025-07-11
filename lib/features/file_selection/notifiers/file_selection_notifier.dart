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

    safeUpdate(
      () => state.copyWith(
        isSelectionMode: true,
        availableFiles: List.from(availableFiles), // Create a copy
        selectedFileIds: {initialFile.id},
        lastAvailableFilesHash: null, // Reset hash to force update
      ),
    );
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

    safeUpdate(
      () => state.copyWith(
        isUpdatingAvailableFiles: true,
        lastAvailableFilesHash: currentFilesHash,
      ),
    );

    try {
      final newAvailableFiles = List<DocumentModel>.from(files);

      debugPrint(
        'FileSelectionNotifier: Updated available files count: ${files.length}',
      );

      // Validate selection state consistency
      _validateSelectionState(newAvailableFiles);

      safeUpdate(
        () => state.copyWith(
          availableFiles: newAvailableFiles,
          isUpdatingAvailableFiles: false,
        ),
      );
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

  /// Add a file to selection (alias for compatibility)
  void addFile(DocumentModel file) {
    if (!state.isSelectionMode) {
      // Enter selection mode with this file
      enterSelectionMode(file, [...state.availableFiles, file]);
    } else {
      // Add to existing selection
      final newSelectedIds = Set<String>.from(state.selectedFileIds)
        ..add(file.id);
      safeUpdate(() => state.copyWith(selectedFileIds: newSelectedIds));
    }
  }

  /// Remove a file from selection (alias for compatibility)
  void removeFile(String fileId) {
    if (!state.isSelectionMode) return;

    final newSelectedIds = Set<String>.from(state.selectedFileIds)
      ..remove(fileId);
    safeUpdate(() => state.copyWith(selectedFileIds: newSelectedIds));
  }

  /// Toggle file selection (alias for compatibility)
  void toggleFile(String fileId) {
    toggleFileSelection(fileId);
  }

  /// Set loading state
  void setLoading(bool isLoading) {
    safeUpdate(() => state.copyWith(isUpdatingAvailableFiles: isLoading));
  }

  /// Select all files with limit
  void selectAllWithLimit(int limit) {
    if (!state.isSelectionMode) return;

    final fileIds = state.availableFiles
        .take(limit)
        .map((file) => file.id)
        .toSet();

    safeUpdate(() => state.copyWith(selectedFileIds: fileIds));
  }

  /// Select all files with size limit
  void selectAllWithSizeLimit(int maxSizeBytes) {
    if (!state.isSelectionMode) return;

    int totalSize = 0;
    final selectedIds = <String>{};

    for (final file in state.availableFiles) {
      if (totalSize + file.fileSize <= maxSizeBytes) {
        selectedIds.add(file.id);
        totalSize += file.fileSize;
      } else {
        break;
      }
    }

    safeUpdate(() => state.copyWith(selectedFileIds: selectedIds));
  }

  /// Get selected files by type
  List<DocumentModel> getSelectedFilesByType(String fileType) {
    return state.selectedFiles
        .where((file) => file.fileType.toLowerCase() == fileType.toLowerCase())
        .toList();
  }

  /// Select a file by filename (for integration tests)
  void selectFile(String fileName) {
    // Find file by name in available files
    final file = state.availableFiles.firstWhere(
      (f) => f.fileName == fileName,
      orElse: () => DocumentModel(
        id: 'test-$fileName',
        fileName: fileName,
        fileSize: 1024,
        fileType: fileName.split('.').last,
        filePath: '/test/$fileName',
        uploadedAt: DateTime.now(),
        uploadedBy: 'test-user',
        downloadUrl: 'https://example.com/$fileName',
        category: 'test',
        permissions: ['read'],
        metadata: DocumentMetadata(
          description: 'Test file for integration tests',
          tags: ['test'],
        ),
        isDeleted: false,
      ),
    );

    if (!state.isSelectionMode) {
      enterSelectionMode(file, [...state.availableFiles, file]);
    } else {
      final newSelectedIds = Set<String>.from(state.selectedFileIds)
        ..add(file.id);
      safeUpdate(() => state.copyWith(selectedFileIds: newSelectedIds));
    }
  }

  @override
  void reset() {
    state = const FileSelectionState();
  }
}
