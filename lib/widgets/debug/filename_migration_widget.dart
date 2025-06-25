import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../services/filename_migration_service.dart';
import '../../utils/filename_utils.dart';

/// Debug widget for filename migration operations
///
/// Provides UI for checking migration status and running filename cleanup
class FilenameMigrationWidget extends StatefulWidget {
  const FilenameMigrationWidget({super.key});

  @override
  State<FilenameMigrationWidget> createState() =>
      _FilenameMigrationWidgetState();
}

class _FilenameMigrationWidgetState extends State<FilenameMigrationWidget> {
  final FilenameMigrationService _migrationService = FilenameMigrationService();

  bool _isLoading = false;
  Map<String, dynamic>? _migrationStatus;
  Map<String, dynamic>? _migrationResult;
  Map<String, dynamic>? _statistics;

  @override
  void initState() {
    super.initState();
    _checkDocumentStatus();
  }

  Future<void> _checkDocumentStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final status = await _migrationService.checkDocumentStatus();
      final stats = await _migrationService.getDocumentStatistics();

      setState(() {
        _migrationStatus = status;
        _statistics = stats;
      });
    } catch (e) {
      _showErrorSnackBar('Failed to check document status: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _runValidation() async {
    final confirmed = await _showConfirmationDialog(
      'Run Filename Validation',
      'This will validate all document filenames for proper format. Continue?',
    );

    if (!confirmed) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _migrationService.validateAllDocuments();

      setState(() {
        _migrationResult = result;
      });

      if (result['success'] == true) {
        _showSuccessSnackBar(
          'Validation completed! ${result['validFiles']} valid files found.',
        );
        await _checkDocumentStatus(); // Refresh status
      } else {
        _showErrorSnackBar('Validation failed: ${result['error']}');
      }
    } catch (e) {
      _showErrorSnackBar('Validation failed: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _cleanupMetadata() async {
    final confirmed = await _showConfirmationDialog(
      'Cleanup Old Metadata',
      'This will remove old migration-related metadata from documents. Continue?',
    );

    if (!confirmed) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _migrationService.cleanupOldMetadata();

      if (result['success'] == true) {
        _showSuccessSnackBar(
          'Cleanup completed! ${result['totalCleaned']} documents cleaned.',
        );
        await _checkDocumentStatus(); // Refresh status
      } else {
        _showErrorSnackBar('Cleanup failed: ${result['error']}');
      }
    } catch (e) {
      _showErrorSnackBar('Cleanup failed: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _showConfirmationDialog(String title, String content) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              title,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: Text(content, style: GoogleFonts.poppins()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel', style: GoogleFonts.poppins()),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Continue',
                  style: GoogleFonts.poppins(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.drive_file_rename_outline, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Filename Migration',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Status Section
            if (_migrationStatus != null) ...[
              _buildStatusSection(),
              const SizedBox(height: 16),
            ],

            // Statistics Section
            if (_statistics != null) ...[
              _buildStatisticsSection(),
              const SizedBox(height: 16),
            ],

            // Sample Files Section
            if (_migrationStatus?['sampleTimestampFiles'] != null) ...[
              _buildSampleFilesSection(),
              const SizedBox(height: 16),
            ],

            // Migration Result Section
            if (_migrationResult != null) ...[
              _buildResultSection(),
              const SizedBox(height: 16),
            ],

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection() {
    final status = _migrationStatus!;
    final needsMigration = status['migrationNeeded'] == true;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: needsMigration
            ? Colors.orange.withValues(alpha: 0.1)
            : Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: needsMigration ? Colors.orange : Colors.green,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                needsMigration ? Icons.warning : Icons.check_circle,
                color: needsMigration ? Colors.orange : Colors.green,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                needsMigration ? 'Migration Needed' : 'All Files Clean',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: needsMigration ? Colors.orange : Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Total Documents: ${status['totalDocuments']}',
            style: GoogleFonts.poppins(fontSize: 12),
          ),
          Text(
            'Need Migration: ${status['documentsWithTimestamp']}',
            style: GoogleFonts.poppins(fontSize: 12),
          ),
          Text(
            'Already Clean: ${status['documentsAlreadyClean']}',
            style: GoogleFonts.poppins(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    final stats = _statistics!;
    final progress = stats['migrationProgress'] ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Migration Progress',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress / 100,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            '${progress.toStringAsFixed(1)}% Complete',
            style: GoogleFonts.poppins(fontSize: 12),
          ),
          Text(
            'Migrated: ${stats['migratedDocuments']} / ${stats['totalDocuments']}',
            style: GoogleFonts.poppins(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSampleFilesSection() {
    final sampleFiles = _migrationStatus!['sampleTimestampFiles'] as List;

    if (sampleFiles.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sample Files with Timestamps',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ...sampleFiles.map((fileName) {
            final cleanName = FilenameUtils.getDisplayFileName(fileName);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      fileName,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.red[700],
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward, size: 16),
                  Expanded(
                    child: Text(
                      cleanName,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.green[700],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildResultSection() {
    final result = _migrationResult!;
    final isSuccess = result['success'] == true;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSuccess
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isSuccess ? Colors.green : Colors.red),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Migration Result',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (isSuccess) ...[
            Text(
              'Processed: ${result['totalProcessed']}',
              style: GoogleFonts.poppins(fontSize: 12),
            ),
            Text(
              'Migrated: ${result['successfulMigrations']}',
              style: GoogleFonts.poppins(fontSize: 12),
            ),
            Text(
              'Already Clean: ${result['alreadyClean']}',
              style: GoogleFonts.poppins(fontSize: 12),
            ),
            Text(
              'Failures: ${result['failures']}',
              style: GoogleFonts.poppins(fontSize: 12),
            ),
          ] else ...[
            Text(
              'Error: ${result['error']}',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.red),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _checkDocumentStatus,
            icon: const Icon(Icons.refresh),
            label: Text('Refresh Status', style: GoogleFonts.poppins()),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _runValidation,
            icon: const Icon(Icons.check_circle),
            label: Text('Validate Files', style: GoogleFonts.poppins()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _cleanupMetadata,
            icon: const Icon(Icons.cleaning_services),
            label: Text('Cleanup', style: GoogleFonts.poppins()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
