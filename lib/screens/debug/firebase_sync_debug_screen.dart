import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/document_provider.dart';
import '../../services/firebase_storage_sync_service.dart';
import '../../widgets/common/custom_app_bar.dart';

class FirebaseSyncDebugScreen extends StatefulWidget {
  const FirebaseSyncDebugScreen({super.key});

  @override
  State<FirebaseSyncDebugScreen> createState() =>
      _FirebaseSyncDebugScreenState();
}

class _FirebaseSyncDebugScreenState extends State<FirebaseSyncDebugScreen> {
  final FirebaseStorageSyncService _syncService =
      FirebaseStorageSyncService.instance;
  Map<String, dynamic>? _syncStatus;
  bool _isLoading = false;
  String? _lastSyncResult;

  @override
  void initState() {
    super.initState();
    _loadSyncStatus();
  }

  Future<void> _loadSyncStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final status = await _syncService.getSyncStatus();
      setState(() {
        _syncStatus = status;
      });
    } catch (e) {
      setState(() {
        _syncStatus = {
          'error': e.toString(),
          'syncNeeded': true,
          'lastSyncCheck': DateTime.now().toIso8601String(),
        };
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _performSync() async {
    setState(() {
      _isLoading = true;
      _lastSyncResult = null;
    });

    try {
      final result = await _syncService.performComprehensiveSync();
      setState(() {
        _lastSyncResult =
            'Sync completed successfully!\n'
            'Total documents: ${result['totalDocuments']}\n'
            'Cleaned metadata: ${result['cleanedMetadata']}';
      });

      // Refresh the document provider
      if (mounted) {
        final documentProvider = Provider.of<DocumentProvider>(
          context,
          listen: false,
        );
        await documentProvider.loadDocuments();
      }

      // Reload sync status
      await _loadSyncStatus();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Firebase Storage sync completed successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _lastSyncResult = 'Sync failed: $e';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Firebase Storage Sync Debug',
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
      ),
      body: RefreshIndicator(
        onRefresh: _loadSyncStatus,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sync Status Card
              _buildSyncStatusCard(),
              const SizedBox(height: 16),

              // Actions Card
              _buildActionsCard(),
              const SizedBox(height: 16),

              // Last Sync Result Card
              if (_lastSyncResult != null) _buildLastSyncResultCard(),
              const SizedBox(height: 16),

              // Document Provider Status
              _buildDocumentProviderStatus(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSyncStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.sync, color: AppColors.primary),
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
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_syncStatus != null) ...[
              _buildStatusItem(
                'Storage Files',
                _syncStatus!['storageFileCount']?.toString() ?? 'Unknown',
                Icons.cloud,
              ),
              _buildStatusItem(
                'Firestore Documents',
                _syncStatus!['firestoreDocumentCount']?.toString() ?? 'Unknown',
                Icons.description,
              ),
              _buildStatusItem(
                'Orphaned Files',
                _syncStatus!['orphanedFileCount']?.toString() ?? 'Unknown',
                Icons.warning,
                color: _syncStatus!['orphanedFileCount'] > 0
                    ? AppColors.warning
                    : AppColors.success,
              ),
              _buildStatusItem(
                'Sync Needed',
                _syncStatus!['syncNeeded']?.toString() ?? 'Unknown',
                Icons.sync_problem,
                color: _syncStatus!['syncNeeded'] == true
                    ? AppColors.error
                    : AppColors.success,
              ),
              if (_syncStatus!['error'] != null)
                _buildStatusItem(
                  'Error',
                  _syncStatus!['error'].toString(),
                  Icons.error,
                  color: AppColors.error,
                ),
            ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color ?? AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: color ?? AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _performSync,
                icon: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.sync),
                label: Text(
                  _isLoading ? 'Syncing...' : 'Perform Comprehensive Sync',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textWhite,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isLoading ? null : _loadSyncStatus,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh Status'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastSyncResultCard() {
    final isError =
        _lastSyncResult!.contains('failed') ||
        _lastSyncResult!.contains('error');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isError ? Icons.error : Icons.check_circle,
                  color: isError ? AppColors.error : AppColors.success,
                ),
                const SizedBox(width: 8),
                Text(
                  'Last Sync Result',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isError
                    ? AppColors.error.withValues(alpha: 0.1)
                    : AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isError ? AppColors.error : AppColors.success,
                  width: 1,
                ),
              ),
              child: Text(
                _lastSyncResult!,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: isError ? AppColors.error : AppColors.success,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentProviderStatus() {
    return Consumer<DocumentProvider>(
      builder: (context, documentProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Document Provider Status',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildStatusItem(
                  'Total Documents',
                  documentProvider.allDocuments.length.toString(),
                  Icons.description,
                ),
                _buildStatusItem(
                  'Filtered Documents',
                  documentProvider.documents.length.toString(),
                  Icons.filter_list,
                ),

                if (documentProvider.errorMessage != null)
                  _buildStatusItem(
                    'Error',
                    documentProvider.errorMessage!,
                    Icons.error,
                    color: AppColors.error,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
