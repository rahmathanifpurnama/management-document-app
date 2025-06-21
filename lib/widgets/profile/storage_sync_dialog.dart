import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../services/storage_firestore_sync_service.dart';
import '../../services/cloud_functions_service.dart';

/// Dialog for admin users to sync orphaned Storage files to Firestore
class StorageSyncDialog extends StatefulWidget {
  const StorageSyncDialog({super.key});

  @override
  State<StorageSyncDialog> createState() => _StorageSyncDialogState();
}

class _StorageSyncDialogState extends State<StorageSyncDialog> {
  bool _isLoading = false;
  bool _syncCompleted = false;
  StorageSyncProgress? _currentProgress;
  StorageSyncResult? _syncResult;
  String _statusMessage = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.sync,
                  color: AppColors.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Storage Sync',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (!_isLoading)
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Description
            if (!_syncCompleted) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.blue.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue[700],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'What does this do?',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This will scan Firebase Storage for files that don\'t have corresponding database records and create them automatically. This fixes issues with PDF files and other files uploaded directly to Storage.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Progress Section
            if (_isLoading) ...[
              _buildProgressSection(),
            ] else if (_syncCompleted && _syncResult != null) ...[
              _buildResultsSection(),
            ] else ...[
              _buildStartSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ready to sync orphaned files?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'This process will:',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 8),
        _buildBulletPoint('Scan all files in Firebase Storage'),
        _buildBulletPoint('Check which files are missing from database'),
        _buildBulletPoint('Create database records for orphaned files'),
        _buildBulletPoint('Assign ownership to admin user'),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _startSync,
              icon: const Icon(Icons.sync, size: 18),
              label: const Text('Start Sync'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Syncing Storage Files...',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        
        // Progress Bar
        if (_currentProgress != null) ...[
          LinearProgressIndicator(
            value: _currentProgress!.progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            '${(_currentProgress!.progress * 100).toInt()}% Complete',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 16),
        ] else ...[
          const LinearProgressIndicator(),
          const SizedBox(height: 16),
        ],

        // Status Message
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _statusMessage.isNotEmpty 
                    ? _statusMessage 
                    : 'Initializing sync...',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        const Text(
          'Please wait while we sync your files. This may take a few minutes.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildResultsSection() {
    final result = _syncResult!;
    final isSuccess = result.success;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: isSuccess ? Colors.green : Colors.red,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              isSuccess ? 'Sync Completed!' : 'Sync Failed',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isSuccess ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Results Summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSuccess 
              ? Colors.green.withValues(alpha: 0.1)
              : Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSuccess 
                ? Colors.green.withValues(alpha: 0.3)
                : Colors.red.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildResultRow('Total Storage Files', '${result.totalStorageFiles}'),
              _buildResultRow('Orphaned Files Found', '${result.orphanedFiles}'),
              _buildResultRow('Records Created', '${result.createdRecords}'),
              if (result.errors.isNotEmpty)
                _buildResultRow('Errors', '${result.errors.length}'),
              if (result.duration != null)
                _buildResultRow('Duration', '${result.duration!.inSeconds}s'),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Message
        Text(
          result.message,
          style: const TextStyle(fontSize: 14),
        ),

        // Error Details
        if (result.errors.isNotEmpty) ...[
          const SizedBox(height: 16),
          ExpansionTile(
            title: Text(
              'Error Details (${result.errors.length})',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            children: result.errors.map((error) => 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  '• $error',
                  style: const TextStyle(fontSize: 12, color: Colors.red),
                ),
              ),
            ).toList(),
          ),
        ],

        const SizedBox(height: 24),

        // Close Button
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Close'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 14)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _startSync() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Initializing sync operation...';
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentUser = authProvider.currentUser;
      
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Use Cloud Function for better performance and reliability
      final cloudFunctions = CloudFunctionsService.instance;
      
      setState(() {
        _statusMessage = 'Calling sync service...';
      });

      final result = await cloudFunctions.callFunction(
        'syncStorageToFirestore',
        {},
      );

      if (result['success'] == true) {
        final results = result['results'] as Map<String, dynamic>;
        _syncResult = StorageSyncResult(
          success: true,
          message: result['message'] ?? 'Sync completed successfully',
          totalStorageFiles: results['totalStorageFiles'] ?? 0,
          orphanedFiles: results['orphanedFiles'] ?? 0,
          createdRecords: results['createdRecords'] ?? 0,
          errors: List<String>.from(results['errors'] ?? []),
          duration: results['processingTime'] != null 
            ? Duration(milliseconds: results['processingTime'])
            : null,
        );
      } else {
        _syncResult = StorageSyncResult.error(
          message: result['message'] ?? 'Sync operation failed',
        );
      }

    } catch (e) {
      _syncResult = StorageSyncResult.error(
        message: 'Sync failed: ${e.toString()}',
      );
    }

    setState(() {
      _isLoading = false;
      _syncCompleted = true;
    });
  }
}
