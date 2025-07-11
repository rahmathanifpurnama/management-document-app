import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../models/document_model.dart';

part 'file_selection_state.freezed.dart';

@freezed
class FileSelectionState with _$FileSelectionState {
  const factory FileSelectionState({
    @Default(false) bool isSelectionMode,
    @Default({}) Set<String> selectedFileIds,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default([])
    List<DocumentModel> availableFiles,
    @Default(false) bool isUpdatingAvailableFiles,
    String? lastAvailableFilesHash,
  }) = _FileSelectionState;
}

/// Extension to provide computed properties
extension FileSelectionStateX on FileSelectionState {
  /// Get selected files from available files
  List<DocumentModel> get selectedFiles => availableFiles
      .where((file) => selectedFileIds.contains(file.id))
      .toList();

  /// Get count of selected files
  int get selectedCount => selectedFileIds.length;

  /// Get total size of selected files
  int get totalSize =>
      selectedFiles.fold(0, (sum, file) => sum + file.fileSize);

  /// Check if loading (alias for isUpdatingAvailableFiles)
  bool get isLoading => isUpdatingAvailableFiles;

  /// Check if any files are selected
  bool get hasSelection => selectedFileIds.isNotEmpty;

  /// Check if all available files are selected
  bool get isAllSelected =>
      availableFiles.isNotEmpty &&
      selectedFileIds.length == availableFiles.length;

  /// Check if a specific file is selected
  bool isFileSelected(String fileId) {
    return selectedFileIds.contains(fileId);
  }

  /// Check if we should show selection UI
  bool get shouldShowSelectionUI => isSelectionMode;

  /// Get selection summary text
  String getSelectionSummary() {
    if (!isSelectionMode || selectedFileIds.isEmpty) {
      return '';
    }

    final count = selectedFileIds.length;
    return '$count file${count == 1 ? '' : 's'} selected';
  }

  /// Generate a simple hash for files list to detect changes
  String generateFilesHash(List<DocumentModel> files) {
    if (files.isEmpty) return 'empty';

    // Create a simple hash based on file IDs and count
    final fileIds = files.map((f) => f.id).toList()..sort();
    return '${files.length}_${fileIds.take(5).join('_')}';
  }

  /// Check if files list has changed
  bool hasFilesChanged(List<DocumentModel> newFiles) {
    final newHash = generateFilesHash(newFiles);
    return lastAvailableFilesHash != newHash;
  }
}
