import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/cloud_sync_service.dart';
import '../../widgets/common/app_bottom_navigation.dart';

class SyncManagementScreen extends StatefulWidget {
  const SyncManagementScreen({super.key});

  @override
  State<SyncManagementScreen> createState() => _SyncManagementScreenState();
}

class _SyncManagementScreenState extends State<SyncManagementScreen> {
  final CloudSyncService _syncService = CloudSyncService.instance;
  bool _isLoading = false;
  String? _lastSyncResult;
  DateTime? _lastSyncTime;

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWithNavigation(
      title: 'Sync Management',
      currentNavIndex: 4, // Profile index for admin
      body: RefreshIndicator(
        onRefresh: _refreshSyncStatus,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSyncStatusCard(),
              const SizedBox(height: 16),
              _buildSyncActionsCard(),
              const SizedBox(height: 16),
              _buildScheduledSyncCard(),
              const SizedBox(height: 16),
              if (_lastSyncResult != null) _buildLastSyncResultCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSyncStatusCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  'Sync Status',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatusItem(
              'Last Sync',
              _lastSyncTime != null ? _formatDateTime(_lastSyncTime!) : 'Never',
              Icons.schedule,
            ),
            const SizedBox(height: 8),
            _buildStatusItem(
              'Sync Status',
              _isLoading ? 'Running...' : 'Ready',
              _isLoading ? Icons.sync : Icons.check_circle,
              color: _isLoading ? AppColors.warning : AppColors.success,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color ?? AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: color ?? AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSyncActionsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sync Actions',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildSyncActionButton(
              'Comprehensive Sync',
              'Sync all files and cleanup orphaned data',
              Icons.sync_alt,
              () => _performSync('comprehensive'),
              AppColors.primary,
            ),
            const SizedBox(height: 12),
            _buildSyncActionButton(
              'Storage Sync',
              'Sync Firebase Storage with Firestore',
              Icons.cloud_sync,
              () => _performSync('storage'),
              AppColors.info,
            ),
            const SizedBox(height: 12),
            _buildSyncActionButton(
              'Cleanup Orphaned Data',
              'Remove orphaned metadata records',
              Icons.cleaning_services,
              () => _performSync('cleanup'),
              AppColors.warning,
            ),
            const SizedBox(height: 12),
            _buildSyncActionButton(
              'Emergency Sync',
              'Run all sync operations sequentially',
              Icons.emergency,
              () => _performSync('emergency'),
              AppColors.error,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncActionButton(
    String title,
    String description,
    IconData icon,
    VoidCallback onPressed,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        description,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScheduledSyncCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.schedule, color: AppColors.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Scheduled Sync',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildScheduleItem(
              'Daily Cleanup',
              'Every day at 2:00 AM (Jakarta Time)',
              Icons.today,
            ),
            const SizedBox(height: 8),
            _buildScheduleItem(
              'Weekly Comprehensive Sync',
              'Every Sunday at 3:00 AM (Jakarta Time)',
              Icons.calendar_view_week,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(String title, String schedule, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                schedule,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLastSyncResultCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Sync Result',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                _lastSyncResult!,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshSyncStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _syncService.getSyncStatus();
      if (mounted) {
        setState(() {
          _lastSyncTime = DateTime.now();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh sync status: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _performSync(String syncType) async {
    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic> result;

      switch (syncType) {
        case 'comprehensive':
          result = await _syncService.performComprehensiveSync();
          break;
        case 'storage':
          result = await _syncService.syncStorageWithFirestore();
          break;
        case 'cleanup':
          result = await _syncService.cleanupOrphanedMetadata();
          break;
        case 'emergency':
          result = await _syncService.emergencySync();
          break;
        default:
          throw Exception('Unknown sync type: $syncType');
      }

      if (mounted) {
        setState(() {
          _lastSyncResult = _syncService.getSyncSummary(result);
          _lastSyncTime = DateTime.now();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_lastSyncResult!),
            backgroundColor: result['success'] == true
                ? AppColors.success
                : AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _lastSyncResult = 'Sync failed: $e';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
