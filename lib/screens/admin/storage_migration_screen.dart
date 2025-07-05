import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/storage_migration_service.dart';
import '../../widgets/common/app_scaffold_with_navigation.dart';

class StorageMigrationScreen extends StatefulWidget {
  const StorageMigrationScreen({super.key});

  @override
  State<StorageMigrationScreen> createState() => _StorageMigrationScreenState();
}

class _StorageMigrationScreenState extends State<StorageMigrationScreen> {
  final StorageMigrationService _migrationService = StorageMigrationService.instance;
  
  MigrationStatus? _migrationStatus;
  bool _isLoading = false;
  bool _isMigrating = false;
  double _migrationProgress = 0.0;
  String _currentFileName = '';
  BatchMigrationResult? _migrationResult;

  @override
  void initState() {
    super.initState();
    _checkMigrationStatus();
  }

  Future<void> _checkMigrationStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final status = await _migrationService.checkMigrationStatus();
      setState(() {
        _migrationStatus = status;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to check migration status: $e');
    }
  }

  Future<void> _performMigration() async {
    if (_migrationStatus == null || !_migrationStatus!.isNeeded) {
      return;
    }

    // Show confirmation dialog
    final confirmed = await _showConfirmationDialog();
    if (!confirmed) return;

    setState(() {
      _isMigrating = true;
      _migrationProgress = 0.0;
      _currentFileName = '';
      _migrationResult = null;
    });

    try {
      final result = await _migrationService.performBatchMigration(
        onProgress: (current, total, fileName) {
          setState(() {
            _migrationProgress = current / total;
            _currentFileName = fileName;
          });
        },
      );

      setState(() {
        _isMigrating = false;
        _migrationResult = result;
      });

      if (result.success) {
        _showSuccessSnackBar('Migration completed successfully!');
        // Refresh migration status
        await _checkMigrationStatus();
      } else {
        _showErrorSnackBar('Migration completed with errors: ${result.message}');
      }
    } catch (e) {
      setState(() {
        _isMigrating = false;
      });
      _showErrorSnackBar('Migration failed: $e');
    }
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirm Migration',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will migrate ${_migrationStatus!.uidBasedFiles} files from UID-based to email-based folder structure.',
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 16),
            Text(
              'This process:',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            Text(
              '• Copies files to new email-based folders\n'
              '• Deletes files from old UID-based folders\n'
              '• Cannot be undone',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange.shade600, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Make sure you have a backup before proceeding!',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: Text('Proceed', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    ) ?? false;
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWithNavigation(
      title: 'Storage Migration',
      currentNavIndex: -1, // Not in main navigation
      showAppBar: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Storage Structure Migration',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Migrate from UID-based to email-based folder structure for better organization.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Migration Status Card
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_migrationStatus != null)
              _buildStatusCard(),

            const SizedBox(height: 24),

            // Migration Progress
            if (_isMigrating) _buildMigrationProgress(),

            // Migration Result
            if (_migrationResult != null) _buildMigrationResult(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    final status = _migrationStatus!;
    final needsMigration = status.isNeeded;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  needsMigration ? Icons.warning : Icons.check_circle,
                  color: needsMigration ? Colors.orange : Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  needsMigration ? 'Migration Required' : 'Migration Complete',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: needsMigration ? Colors.orange : Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Statistics
            _buildStatRow('Total Files', status.totalFiles.toString()),
            _buildStatRow('UID-based Files', status.uidBasedFiles.toString()),
            _buildStatRow('Email-based Files', status.emailBasedFiles.toString()),
            
            const SizedBox(height: 16),
            Text(
              status.message,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            
            if (needsMigration) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isMigrating ? null : _performMigration,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Start Migration',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins()),
          Text(
            value,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildMigrationProgress() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Migration in Progress',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: _migrationProgress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 8),
            Text(
              '${(_migrationProgress * 100).toInt()}% complete',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            if (_currentFileName.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Current file: $_currentFileName',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMigrationResult() {
    final result = _migrationResult!;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  result.success ? Icons.check_circle : Icons.error,
                  color: result.success ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  'Migration Result',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatRow('Total Files', result.totalFiles.toString()),
            _buildStatRow('Migrated Files', result.migratedFiles.toString()),
            _buildStatRow('Failed Files', result.failedFiles.toString()),
            const SizedBox(height: 16),
            Text(
              result.message,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
