import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../lib/core/config/file_config.dart';
import '../lib/utils/file_icon_helper.dart';
import '../lib/services/file_preview_service.dart';
import '../lib/models/document_model.dart';

void main() {
  group('CSV File Support Tests', () {
    test('CSV extension should be in allowed extensions', () {
      expect(FileConfig.allowedExtensions.contains('csv'), true);
    });

    test('CSV should have correct MIME type mapping', () {
      expect(FileConfig.getMimeType('test.csv'), 'text/csv');
    });

    test('CSV should be categorized as spreadsheet', () {
      expect(FileConfig.getFileTypeCategory('test.csv'), 'spreadsheet');
    });

    test('CSV should have correct display name', () {
      expect(FileConfig.getFileTypeDisplayName('test.csv'), 'CSV Spreadsheet');
    });

    test('CSV should have distinct icon from Excel', () {
      final csvIcon = FileIconHelper.getFileIcon('test.csv');
      final excelIcon = FileIconHelper.getFileIcon('test.xlsx');

      expect(csvIcon, Icons.grid_on);
      expect(excelIcon, Icons.table_chart);
      expect(csvIcon != excelIcon, true);
    });

    test('CSV should have distinct color from Excel', () {
      final csvColor = FileIconHelper.getFileTypeColor('test.csv');
      final excelColor = FileIconHelper.getFileTypeColor('test.xlsx');

      expect(csvColor != excelColor, true);
    });

    test('CSV should be categorized correctly by FileIconHelper', () {
      expect(FileIconHelper.getFileCategory('test.csv'), 'CSV Spreadsheet');
      expect(FileIconHelper.getFileCategory('test.xlsx'), 'Excel Spreadsheet');
    });

    test('CSV files should be previewable', () {
      final previewService = FilePreviewService();
      final csvDocument = DocumentModel(
        id: 'test',
        fileName: 'test.csv',
        fileType: 'text/csv',
        filePath: 'test/path',
        fileSize: 1024,
        uploadedAt: DateTime.now(),
        uploadedBy: 'test',
        category: 'test',
        permissions: ['test'],
        metadata: DocumentMetadata(
          description: 'Test CSV file',
          tags: ['test', 'csv'],
        ),
      );

      expect(previewService.canPreview(csvDocument), true);
      expect(previewService.getPreviewType(csvDocument), FilePreviewType.text);
    });

    test('File extension validation should work correctly', () {
      expect(FileConfig.isExtensionAllowed('test.csv'), true);
      expect(FileConfig.isExtensionAllowed('test.xlsx'), true);
      expect(FileConfig.isExtensionAllowed('test.xls'), true);
    });
  });

  group('Excel File Enhancement Tests', () {
    test('Excel files should maintain proper support', () {
      expect(FileConfig.allowedExtensions.contains('xlsx'), true);
      expect(FileConfig.allowedExtensions.contains('xls'), true);
    });

    test('Excel files should have correct categorization', () {
      expect(FileConfig.getFileTypeCategory('test.xlsx'), 'spreadsheet');
      expect(FileConfig.getFileTypeCategory('test.xls'), 'spreadsheet');
    });

    test('Excel files should have correct display names', () {
      expect(
        FileConfig.getFileTypeDisplayName('test.xlsx'),
        'Excel Spreadsheet',
      );
      expect(
        FileConfig.getFileTypeDisplayName('test.xls'),
        'Excel Spreadsheet',
      );
    });
  });
}
