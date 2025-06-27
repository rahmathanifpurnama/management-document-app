import 'package:flutter/material.dart';
import '../services/storage_firestore_diagnostic_service.dart';
import '../core/constants/app_colors.dart';

/// Diagnostic screen for analyzing data consistency issues
class DiagnosticScreen extends StatefulWidget {
  const DiagnosticScreen({super.key});

  @override
  State<DiagnosticScreen> createState() => _DiagnosticScreenState();
}

class _DiagnosticScreenState extends State<DiagnosticScreen> {
  final StorageFirestoreDiagnosticService _diagnosticService =
      StorageFirestoreDiagnosticService.instance;

  DataConsistencyReport? _report;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _runDiagnostic();
  }

  Future<void> _runDiagnostic() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _report = null;
    });

    try {
      final report = await _diagnosticService.analyzeDataConsistency();
      setState(() {
        _report = report;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _cleanupOrphanedMetadata({bool dryRun = true}) async {
    if (_report?.orphanedMetadata.isEmpty ?? true) return;

    setState(() => _isLoading = true);

    try {
      final result = await _diagnosticService.cleanupOrphanedMetadata(
        orphanedRecords: _report!.orphanedMetadata,
        dryRun: dryRun,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              dryRun
                  ? 'Dry run completed: ${result.successCount} records would be cleaned'
                  : 'Cleanup completed: ${result.successCount} records cleaned',
            ),
            backgroundColor: dryRun ? Colors.blue : Colors.green,
          ),
        );

        if (!dryRun) {
          // Refresh the diagnostic after cleanup
          _runDiagnostic();
        } else {
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cleanup failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Data Consistency Diagnostic'),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _runDiagnostic,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _buildErrorView()
          : _report != null
          ? _buildReportView()
          : const Center(child: Text('No data available')),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $_error'),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _runDiagnostic, child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildReportView() {
    final report = _report!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Card
          Card(
            color: AppColors.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Consistency Summary',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryRow(
                    'Status',
                    report.isConsistent ? 'Consistent' : 'Inconsistent',
                    report.isConsistent ? Colors.green : Colors.red,
                  ),
                  _buildSummaryRow(
                    'Discrepancy Count',
                    '${report.discrepancyCount}',
                    report.discrepancyCount == 0 ? Colors.green : Colors.orange,
                  ),
                  const Divider(),
                  _buildSummaryRow(
                    'Firestore Total',
                    '${report.totalFirestoreRecords}',
                  ),
                  _buildSummaryRow(
                    'Firestore Active',
                    '${report.totalActiveFirestoreRecords}',
                  ),
                  _buildSummaryRow(
                    'Firestore Inactive',
                    '${report.totalInactiveFirestoreRecords}',
                  ),
                  _buildSummaryRow(
                    'Storage Files',
                    '${report.totalStorageFiles}',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Issues Section
          if (report.orphanedMetadata.isNotEmpty ||
              report.orphanedStorageFiles.isNotEmpty ||
              report.duplicateMetadata.isNotEmpty) ...[
            Card(
              color: AppColors.surface,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Identified Issues',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),

                    if (report.orphanedMetadata.isNotEmpty) ...[
                      _buildIssueSection(
                        'Orphaned Metadata Records',
                        '${report.orphanedMetadata.length} records exist in Firestore but not in Storage',
                        report.orphanedMetadata.map((f) => f.fileName).toList(),
                        Colors.orange,
                        onAction: () => _showCleanupDialog(),
                        actionLabel: 'Clean Up',
                      ),
                    ],

                    if (report.orphanedStorageFiles.isNotEmpty) ...[
                      _buildIssueSection(
                        'Orphaned Storage Files',
                        '${report.orphanedStorageFiles.length} files exist in Storage but not in Firestore',
                        report.orphanedStorageFiles
                            .map((f) => f.fileName)
                            .toList(),
                        Colors.red,
                      ),
                    ],

                    if (report.duplicateMetadata.isNotEmpty) ...[
                      _buildIssueSection(
                        'Duplicate Metadata',
                        '${report.duplicateMetadata.length} files have multiple Firestore records',
                        report.duplicateMetadata.keys.toList(),
                        Colors.purple,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ] else ...[
            Card(
              color: AppColors.surface,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'No data consistency issues found!',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, [Color? valueColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: valueColor),
          ),
        ],
      ),
    );
  }

  Widget _buildIssueSection(
    String title,
    String description,
    List<String> items,
    Color color, {
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.warning, color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
            ),
            if (onAction != null && actionLabel != null)
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                ),
                child: Text(actionLabel),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(description),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items.take(5).map((item) => Text('• $item')).toList()
              ..addAll(
                items.length > 5
                    ? [Text('... and ${items.length - 5} more')]
                    : [],
              ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showCleanupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clean Up Orphaned Metadata'),
        content: Text(
          'This will remove ${_report!.orphanedMetadata.length} orphaned metadata records from Firestore. '
          'These records exist in Firestore but their corresponding files are not in Firebase Storage.\n\n'
          'This action cannot be undone. Do you want to proceed?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cleanupOrphanedMetadata(dryRun: true);
            },
            child: const Text('Dry Run'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _cleanupOrphanedMetadata(dryRun: false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clean Up'),
          ),
        ],
      ),
    );
  }
}
