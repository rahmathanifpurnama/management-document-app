import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../services/user_sync_service.dart';

/// Widget for admin to manage user synchronization between Firebase Auth and Firestore
class UserSyncWidget extends StatefulWidget {
  const UserSyncWidget({super.key});

  @override
  State<UserSyncWidget> createState() => _UserSyncWidgetState();
}

class _UserSyncWidgetState extends State<UserSyncWidget> {
  final UserSyncService _userSyncService = UserSyncService.instance;

  bool _isLoading = false;
  Map<String, dynamic>? _lastSyncResult;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.sync, color: AppColors.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  'User Synchronization',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text(
              'Synchronize users from Firebase Authentication to Firestore for accurate statistics.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),

            // Sync Status
            _buildSyncStatus(),
            const SizedBox(height: 16),

            // Sync Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _performSync,
                icon: _isLoading
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.surface,
                          ),
                        ),
                      )
                    : Icon(Icons.sync),
                label: Text(_isLoading ? 'Syncing...' : 'Sync Users'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.surface,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            // Last Sync Result
            if (_lastSyncResult != null) ...[
              const SizedBox(height: 16),
              _buildSyncResult(),
            ],

            // Error Message
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              _buildErrorMessage(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSyncStatus() {
    final status = _userSyncService.getSyncStatus();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sync Status',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Icon(
                status['isInitialized'] ? Icons.check_circle : Icons.error,
                color: status['isInitialized'] ? Colors.green : Colors.orange,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Service: ${status['isInitialized'] ? 'Initialized' : 'Not Initialized'}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),

          if (status['isSyncing']) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Currently syncing...',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ],

          if (status['lastSyncTime'] != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.schedule, color: AppColors.textSecondary, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Last sync: ${_formatDateTime(status['lastSyncTime'])}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSyncResult() {
    final result = _lastSyncResult!;
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
          Row(
            children: [
              Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                color: isSuccess ? Colors.green : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Sync Result',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSuccess ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (result['syncedCount'] != null)
            Text('Synced: ${result['syncedCount']} users'),
          if (result['totalAuthUsers'] != null)
            Text('Total Auth Users: ${result['totalAuthUsers']}'),
          if (result['totalFirestoreUsers'] != null)
            Text('Total Firestore Users: ${result['totalFirestoreUsers']}'),
          if (result['message'] != null) Text(result['message']),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _performSync() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _lastSyncResult = null;
    });

    try {
      final result = await _userSyncService.manualSync();

      setState(() {
        _lastSyncResult = result;
        _isLoading = false;
      });

      if (result['success'] == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User sync completed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatDateTime(String? isoString) {
    if (isoString == null) return 'Never';

    try {
      final dateTime = DateTime.parse(isoString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Invalid date';
    }
  }
}
