import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sync_providers.dart';
import '../models/sync_state.dart';

/// Sync status widget for showing detailed sync information using Riverpod
class SyncStatusWidget extends ConsumerWidget {
  final bool showLastSyncTime;
  final bool showSyncMessage;

  const SyncStatusWidget({
    super.key,
    this.showLastSyncTime = true,
    this.showSyncMessage = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStateAsync = ref.watch(syncStateProvider);

    return syncStateAsync.when(
      data: (syncState) => _buildSyncStatus(context, syncState),
      loading: () => const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (error, stack) => Row(
        children: [
          const Icon(Icons.error, size: 16, color: Colors.red),
          const SizedBox(width: 8),
          Text(
            'Sync Error',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncStatus(BuildContext context, SyncState syncState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Sync status
        Row(
          children: [
            _buildStatusIcon(syncState.syncStatus),
            const SizedBox(width: 8),
            Text(
              syncState.syncStatusText,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: _getStatusColor(syncState.syncStatus),
              ),
            ),
            if (syncState.isSyncing) ...[
              const SizedBox(width: 8),
              const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 1.5),
              ),
            ],
          ],
        ),

        // Last sync time
        if (showLastSyncTime) ...[
          const SizedBox(height: 4),
          Text(
            'Last sync: ${syncState.lastSyncTimeText}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],

        // Sync message
        if (showSyncMessage && syncState.syncMessage != null) ...[
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getMessageBackgroundColor(syncState.syncStatus),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              syncState.syncMessage!,
              style: TextStyle(
                fontSize: 12,
                color: _getMessageTextColor(syncState.syncStatus),
              ),
            ),
          ),
        ],

        // Error details
        if (syncState.syncStatus == SyncStatus.error && 
            syncState.lastSyncError != null) ...[
          const SizedBox(height: 4),
          Text(
            'Error: ${syncState.lastSyncError}',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.red,
              fontStyle: FontStyle.italic,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildStatusIcon(SyncStatus status) {
    switch (status) {
      case SyncStatus.idle:
        return const Icon(Icons.sync, size: 16, color: Colors.grey);
      case SyncStatus.syncing:
        return const Icon(Icons.sync, size: 16, color: Colors.blue);
      case SyncStatus.success:
        return const Icon(Icons.check_circle, size: 16, color: Colors.green);
      case SyncStatus.error:
        return const Icon(Icons.error, size: 16, color: Colors.red);
    }
  }

  Color _getStatusColor(SyncStatus status) {
    switch (status) {
      case SyncStatus.idle:
        return Colors.grey;
      case SyncStatus.syncing:
        return Colors.blue;
      case SyncStatus.success:
        return Colors.green;
      case SyncStatus.error:
        return Colors.red;
    }
  }

  Color _getMessageBackgroundColor(SyncStatus status) {
    switch (status) {
      case SyncStatus.idle:
        return Colors.grey.withOpacity(0.1);
      case SyncStatus.syncing:
        return Colors.blue.withOpacity(0.1);
      case SyncStatus.success:
        return Colors.green.withOpacity(0.1);
      case SyncStatus.error:
        return Colors.red.withOpacity(0.1);
    }
  }

  Color _getMessageTextColor(SyncStatus status) {
    switch (status) {
      case SyncStatus.idle:
        return Colors.grey.shade700;
      case SyncStatus.syncing:
        return Colors.blue.shade700;
      case SyncStatus.success:
        return Colors.green.shade700;
      case SyncStatus.error:
        return Colors.red.shade700;
    }
  }
}
