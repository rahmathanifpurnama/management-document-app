import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/activity_model.dart';
import '../models/activity_types.dart';
import '../models/document_model.dart';

class ExportService {
  static final ExportService _instance = ExportService._internal();
  factory ExportService() => _instance;
  ExportService._internal();

  /// Export activities to CSV file
  Future<void> exportActivitiesToExcel(List<BaseActivity> activities) async {
    try {
      final csvContent = _createActivitiesCSV(activities);
      final csvBytes = Uint8List.fromList(csvContent.codeUnits);

      await _saveAndShareFile(
        csvBytes,
        'activities_export_${DateTime.now().millisecondsSinceEpoch}.csv',
        'text/csv',
      );
    } catch (e) {
      debugPrint('Error exporting activities to CSV: $e');
      rethrow;
    }
  }

  /// Create backup ZIP of selected files
  Future<void> createBackupZip(List<DocumentModel> documents) async {
    try {
      final archive = Archive();

      // Add a manifest file with document information
      final manifest = _createManifest(documents);
      final manifestBytes = Uint8List.fromList(manifest.codeUnits);
      archive.addFile(
        ArchiveFile('manifest.txt', manifestBytes.length, manifestBytes),
      );

      // Create CSV file with document metadata
      final csvContent = _createDocumentCSV(documents);
      final csvBytes = Uint8List.fromList(csvContent.codeUnits);
      archive.addFile(
        ArchiveFile('documents_metadata.csv', csvBytes.length, csvBytes),
      );

      // Note: In a real implementation, you would download the actual files
      // and add them to the archive. For now, we're just creating metadata.

      // Encode the archive
      final zipBytes = ZipEncoder().encode(archive);
      if (zipBytes != null) {
        await _saveAndShareFile(
          zipBytes,
          'backup_${DateTime.now().millisecondsSinceEpoch}.zip',
          'application/zip',
        );
      }
    } catch (e) {
      debugPrint('Error creating backup ZIP: $e');
      rethrow;
    }
  }

  /// Export document list to CSV
  Future<void> exportDocumentsToExcel(List<DocumentModel> documents) async {
    try {
      final csvContent = _createDocumentCSV(documents);
      final csvBytes = Uint8List.fromList(csvContent.codeUnits);

      await _saveAndShareFile(
        csvBytes,
        'documents_export_${DateTime.now().millisecondsSinceEpoch}.csv',
        'text/csv',
      );
    } catch (e) {
      debugPrint('Error exporting documents to CSV: $e');
      rethrow;
    }
  }

  /// Save file and share it
  Future<void> _saveAndShareFile(
    List<int> bytes,
    String fileName,
    String mimeType,
  ) async {
    try {
      if (kIsWeb) {
        // For web, we would use different approach
        // This is a placeholder for web implementation
        throw UnsupportedError('Web export not implemented yet');
      } else {
        // For mobile/desktop
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(bytes);

        // Share the file
        await Share.shareXFiles([
          XFile(file.path, mimeType: mimeType),
        ], text: 'Exported file: $fileName');
      }
    } catch (e) {
      debugPrint('Error saving and sharing file: $e');
      rethrow;
    }
  }

  /// Create manifest file content
  String _createManifest(List<DocumentModel> documents) {
    final buffer = StringBuffer();
    buffer.writeln('Document Management System - Backup Manifest');
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln('Total Documents: ${documents.length}');
    buffer.writeln('');
    buffer.writeln('This backup contains:');
    buffer.writeln('- manifest.txt: This file');
    buffer.writeln('- documents_metadata.csv: Document metadata in CSV format');
    buffer.writeln('');
    buffer.writeln('Note: This backup contains metadata only.');
    buffer.writeln(
      'Actual file content would require additional implementation.',
    );
    buffer.writeln('');
    buffer.writeln('Documents included:');

    for (final doc in documents) {
      buffer.writeln('- ${doc.fileName} (${_formatFileSize(doc.fileSize)})');
    }

    return buffer.toString();
  }

  /// Create CSV content for documents
  String _createDocumentCSV(List<DocumentModel> documents) {
    final buffer = StringBuffer();

    // CSV headers
    buffer.writeln(
      'File Name,File Type,File Size (Bytes),Upload Date,Uploaded By,Category,Status,Download URL',
    );

    // CSV data
    for (final doc in documents) {
      final row = [
        _escapeCsvField(doc.fileName),
        _escapeCsvField(doc.fileType),
        doc.fileSize.toString(),
        _formatDateTime(doc.uploadedAt),
        _escapeCsvField(doc.uploadedBy),
        _escapeCsvField(doc.category),
        _escapeCsvField(doc.status ?? 'active'),
        _escapeCsvField(doc.downloadUrl ?? ''),
      ];
      buffer.writeln(row.join(','));
    }

    return buffer.toString();
  }

  /// Escape CSV field if it contains special characters
  String _escapeCsvField(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      return '"${field.replaceAll('"', '""')}"';
    }
    return field;
  }

  /// Format DateTime for export
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Format file size for display
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Create CSV content for activities
  String _createActivitiesCSV(List<BaseActivity> activities) {
    final buffer = StringBuffer();

    // CSV headers
    buffer.writeln(
      'Timestamp,Type,Description,User Name,User Email,User ID,Document ID,Category ID,Is Suspicious,IP Address,User Agent',
    );

    // CSV data
    for (final activity in activities) {
      final row = [
        _escapeCsvField(_formatDateTime(activity.timestamp)),
        _escapeCsvField(activity.type),
        _escapeCsvField(activity.description),
        _escapeCsvField(activity.userName ?? ''),
        _escapeCsvField(activity.userEmail ?? ''),
        _escapeCsvField(activity.userId),
        _escapeCsvField(_getDocumentId(activity)),
        _escapeCsvField(_getCategoryId(activity)),
        activity.isSuspicious ? 'Yes' : 'No',
        _escapeCsvField(activity.ipAddress ?? ''),
        _escapeCsvField(activity.userAgent ?? ''),
      ];
      buffer.writeln(row.join(','));
    }

    return buffer.toString();
  }

  /// Export storage statistics to CSV
  Future<void> exportStorageStatsToExcel(Map<String, dynamic> stats) async {
    try {
      final buffer = StringBuffer();

      // Add title and generation date
      buffer.writeln('Storage Statistics Report');
      buffer.writeln('Generated: ${_formatDateTime(DateTime.now())}');
      buffer.writeln('');
      buffer.writeln('Statistic,Value');

      // Add statistics
      for (final entry in stats.entries) {
        buffer.writeln(
          '${_escapeCsvField(entry.key)},${_escapeCsvField(entry.value.toString())}',
        );
      }

      final csvBytes = Uint8List.fromList(buffer.toString().codeUnits);

      await _saveAndShareFile(
        csvBytes,
        'storage_stats_${DateTime.now().millisecondsSinceEpoch}.csv',
        'text/csv',
      );
    } catch (e) {
      debugPrint('Error exporting storage stats to CSV: $e');
      rethrow;
    }
  }

  /// Get document ID from polymorphic activity
  String _getDocumentId(BaseActivity activity) {
    if (activity is ActivityModel) {
      return activity.documentId ?? '';
    } else if (activity is FileActivity) {
      return activity.documentId ?? '';
    }
    return '';
  }

  /// Get category ID from polymorphic activity
  String _getCategoryId(BaseActivity activity) {
    if (activity is ActivityModel) {
      return activity.categoryId ?? '';
    } else if (activity is FileUploadActivity) {
      return activity.categoryId ?? '';
    }
    return '';
  }
}
