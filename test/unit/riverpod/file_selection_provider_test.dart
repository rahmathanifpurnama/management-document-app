import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:managementdoc/features/file_selection/providers/file_selection_providers.dart';
import 'package:managementdoc/features/file_selection/models/file_selection_state.dart';
import 'package:managementdoc/models/document_model.dart';

void main() {
  group('File Selection Riverpod Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize with empty file selection', () {
      final fileSelection = container.read(fileSelectionProvider);

      expect(fileSelection.selectedFiles, isEmpty);
      expect(fileSelection.isSelectionMode, false);
      expect(fileSelection.totalSize, 0);
      expect(fileSelection.isLoading, false);
    });

    test('should add file to selection', () {
      final notifier = container.read(fileSelectionProvider.notifier);
      final testFile = _createMockSelectedFile();

      notifier.addFile(testFile);

      final fileSelection = container.read(fileSelectionProvider);
      expect(fileSelection.selectedFiles.length, 1);
      expect(fileSelection.selectedFiles.first.id, testFile.id);
      expect(fileSelection.isSelectionMode, true);
    });

    test('should remove file from selection', () {
      final notifier = container.read(fileSelectionProvider.notifier);
      final testFile = _createMockSelectedFile();

      // Add file first
      notifier.addFile(testFile);

      // Remove file
      notifier.removeFile(testFile.id);

      final fileSelection = container.read(fileSelectionProvider);
      expect(fileSelection.selectedFiles, isEmpty);
      expect(fileSelection.isSelectionMode, false);
    });

    test('should toggle file selection', () {
      final notifier = container.read(fileSelectionProvider.notifier);
      final testFile = _createMockSelectedFile();

      // Enter selection mode first
      notifier.updateAvailableFiles([testFile]);
      notifier.enterSelectionMode(testFile, [testFile]);

      // Toggle to remove (file is already selected when entering selection mode)
      notifier.toggleFile(testFile.id);

      var fileSelection = container.read(fileSelectionProvider);
      expect(fileSelection.selectedFiles, isEmpty);

      // Toggle to add back
      notifier.toggleFile(testFile.id);

      fileSelection = container.read(fileSelectionProvider);
      expect(fileSelection.selectedFiles.length, 1);
    });

    test('should select all files', () {
      final notifier = container.read(fileSelectionProvider.notifier);
      final testFiles = [
        _createMockSelectedFile(id: 'file1'),
        _createMockSelectedFile(id: 'file2'),
        _createMockSelectedFile(id: 'file3'),
      ];

      // First update available files and enter selection mode
      notifier.updateAvailableFiles(testFiles);
      notifier.enterSelectionMode(testFiles.first, testFiles);
      notifier.selectAll();

      final fileSelection = container.read(fileSelectionProvider);
      expect(fileSelection.selectedFiles.length, 3);
      expect(fileSelection.isSelectionMode, true);
    });

    test('should clear all selections', () {
      final notifier = container.read(fileSelectionProvider.notifier);
      final testFiles = [
        _createMockSelectedFile(id: 'file1'),
        _createMockSelectedFile(id: 'file2'),
      ];

      // Add files first
      notifier.updateAvailableFiles(testFiles);
      notifier.enterSelectionMode(testFiles.first, testFiles);
      notifier.selectAll();

      // Clear all
      notifier.clearSelection();

      final fileSelection = container.read(fileSelectionProvider);
      expect(fileSelection.selectedFiles, isEmpty);
      expect(
        fileSelection.isSelectionMode,
        true,
      ); // Should stay in selection mode
    });

    test('should calculate total size correctly', () {
      final notifier = container.read(fileSelectionProvider.notifier);
      final testFiles = [
        _createMockSelectedFile(id: 'file1', size: 1024),
        _createMockSelectedFile(id: 'file2', size: 2048),
        _createMockSelectedFile(id: 'file3', size: 512),
      ];

      notifier.updateAvailableFiles(testFiles);
      notifier.enterSelectionMode(testFiles.first, testFiles);
      notifier.selectAll();

      final fileSelection = container.read(fileSelectionProvider);
      expect(fileSelection.totalSize, 3584); // 1024 + 2048 + 512
    });

    test('should handle duplicate file additions', () {
      final notifier = container.read(fileSelectionProvider.notifier);
      final testFile = _createMockSelectedFile();

      // Add file twice
      notifier.addFile(testFile);
      notifier.addFile(testFile);

      final fileSelection = container.read(fileSelectionProvider);
      expect(fileSelection.selectedFiles.length, 1); // Should not duplicate
    });

    test('should filter selected files by type', () {
      final notifier = container.read(fileSelectionProvider.notifier);
      final testFiles = [
        _createMockSelectedFile(id: 'file1', type: 'pdf'),
        _createMockSelectedFile(id: 'file2', type: 'docx'),
        _createMockSelectedFile(id: 'file3', type: 'pdf'),
      ];

      notifier.updateAvailableFiles(testFiles);
      notifier.enterSelectionMode(testFiles.first, testFiles);
      notifier.selectAll();

      final pdfFiles = notifier.getSelectedFilesByType('pdf');
      expect(pdfFiles.length, 2);
      expect(pdfFiles.every((file) => file.fileType == 'pdf'), true);
    });

    test('should handle loading states correctly', () {
      final notifier = container.read(fileSelectionProvider.notifier);

      // Start loading
      notifier.setLoading(true);

      var fileSelection = container.read(fileSelectionProvider);
      expect(fileSelection.isUpdatingAvailableFiles, true);

      // Stop loading
      notifier.setLoading(false);

      fileSelection = container.read(fileSelectionProvider);
      expect(fileSelection.isUpdatingAvailableFiles, false);
    });

    test('should validate file selection limits', () {
      final notifier = container.read(fileSelectionProvider.notifier);
      final maxFiles = 10;

      // Create more files than the limit
      final testFiles = List.generate(
        maxFiles + 5,
        (index) => _createMockSelectedFile(id: 'file$index'),
      );

      // Set up available files first
      notifier.updateAvailableFiles(testFiles);
      notifier.enterSelectionMode(testFiles.first, testFiles);

      // Try to select all files with limit
      notifier.selectAllWithLimit(maxFiles);

      final fileSelection = container.read(fileSelectionProvider);
      expect(fileSelection.selectedFiles.length, lessThanOrEqualTo(maxFiles));
    });

    test('should validate total size limits', () {
      final notifier = container.read(fileSelectionProvider.notifier);
      final maxSize = 1024 * 1024; // 1MB

      // Create files that exceed size limit
      final testFiles = [
        _createMockSelectedFile(id: 'file1', size: 512 * 1024),
        _createMockSelectedFile(id: 'file2', size: 600 * 1024), // Total > 1MB
      ];

      // Set up available files first
      notifier.updateAvailableFiles(testFiles);
      notifier.enterSelectionMode(testFiles.first, testFiles);

      // Try to select all files with size limit
      notifier.selectAllWithSizeLimit(maxSize);

      final fileSelection = container.read(fileSelectionProvider);
      expect(fileSelection.totalSize, lessThanOrEqualTo(maxSize));
    });
  });
}

DocumentModel _createMockSelectedFile({
  String? id,
  String? name,
  String? type,
  int? size,
}) {
  return DocumentModel(
    id: id ?? 'test-file-id',
    fileName: name ?? 'test-file.pdf',
    fileType: type ?? 'pdf',
    fileSize: size ?? 1024,
    filePath: '/test/path',
    uploadedBy: 'test-user',
    uploadedAt: DateTime.now(),
    category: 'test',
    permissions: ['read'],
    metadata: DocumentMetadata(description: 'Test file', tags: ['test']),
    isDeleted: false,
  );
}
