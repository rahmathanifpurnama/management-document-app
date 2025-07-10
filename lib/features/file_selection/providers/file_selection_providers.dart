import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/document_model.dart';
import '../notifiers/file_selection_notifier.dart';
import '../models/file_selection_state.dart';

/// Main file selection provider
final fileSelectionProvider =
    StateNotifierProvider<FileSelectionNotifier, FileSelectionState>((ref) {
      return FileSelectionNotifier();
    });

/// Computed providers for specific file selection properties
final isSelectionModeProvider = Provider<bool>((ref) {
  return ref.watch(fileSelectionProvider).isSelectionMode;
});

final selectedFileIdsProvider = Provider<Set<String>>((ref) {
  return ref.watch(fileSelectionProvider).selectedFileIds;
});

final selectedFilesProvider = Provider<List<DocumentModel>>((ref) {
  return ref.watch(fileSelectionProvider).selectedFiles;
});

final selectedCountProvider = Provider<int>((ref) {
  return ref.watch(fileSelectionProvider).selectedCount;
});

final hasSelectionProvider = Provider<bool>((ref) {
  return ref.watch(fileSelectionProvider).hasSelection;
});

final isAllSelectedProvider = Provider<bool>((ref) {
  return ref.watch(fileSelectionProvider).isAllSelected;
});

final shouldShowSelectionUIProvider = Provider<bool>((ref) {
  return ref.watch(fileSelectionProvider).shouldShowSelectionUI;
});

final availableFilesProvider = Provider<List<DocumentModel>>((ref) {
  return ref.watch(fileSelectionProvider).availableFiles;
});

/// Provider for selection summary text
final selectionSummaryProvider = Provider<String>((ref) {
  return ref.watch(fileSelectionProvider).getSelectionSummary();
});

/// Provider to check if a specific file is selected
final isFileSelectedProvider = Provider.family<bool, String>((ref, fileId) {
  return ref.watch(fileSelectionProvider).isFileSelected(fileId);
});

/// File selection actions provider
final fileSelectionActionsProvider = Provider<FileSelectionActions>((ref) {
  return FileSelectionActions(ref);
});

/// File selection actions class for easy access to notifier methods
class FileSelectionActions {
  final Ref _ref;

  FileSelectionActions(this._ref);

  FileSelectionNotifier get _notifier =>
      _ref.read(fileSelectionProvider.notifier);

  void enterSelectionMode(
    DocumentModel initialFile,
    List<DocumentModel> availableFiles,
  ) {
    _notifier.enterSelectionMode(initialFile, availableFiles);
  }

  void exitSelectionMode() {
    _notifier.exitSelectionMode();
  }

  void toggleFileSelection(String fileId) {
    _notifier.toggleFileSelection(fileId);
  }

  void selectAll() {
    _notifier.selectAll();
  }

  void clearSelection() {
    _notifier.clearSelection();
  }

  void updateAvailableFiles(List<DocumentModel> files) {
    _notifier.updateAvailableFiles(files);
  }
}

/// Provider for isolated file selection (for screens that need separate instances)
final isolatedFileSelectionProvider =
    StateNotifierProvider.family<
      FileSelectionNotifier,
      FileSelectionState,
      String
    >((ref, screenId) {
      return FileSelectionNotifier();
    });

/// Actions provider for isolated file selection
final isolatedFileSelectionActionsProvider =
    Provider.family<IsolatedFileSelectionActions, String>((ref, screenId) {
      return IsolatedFileSelectionActions(ref, screenId);
    });

/// Isolated file selection actions class
class IsolatedFileSelectionActions {
  final Ref _ref;
  final String _screenId;

  IsolatedFileSelectionActions(this._ref, this._screenId);

  FileSelectionNotifier get _notifier =>
      _ref.read(isolatedFileSelectionProvider(_screenId).notifier);

  void enterSelectionMode(
    DocumentModel initialFile,
    List<DocumentModel> availableFiles,
  ) {
    _notifier.enterSelectionMode(initialFile, availableFiles);
  }

  void exitSelectionMode() {
    _notifier.exitSelectionMode();
  }

  void toggleFileSelection(String fileId) {
    _notifier.toggleFileSelection(fileId);
  }

  void selectAll() {
    _notifier.selectAll();
  }

  void clearSelection() {
    _notifier.clearSelection();
  }

  void updateAvailableFiles(List<DocumentModel> files) {
    _notifier.updateAvailableFiles(files);
  }
}
