import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/services/auto_sync_service.dart' as auto_sync;

part 'sync_state.freezed.dart';

// Use the existing SyncStatus from auto_sync_service
typedef SyncStatus = auto_sync.SyncStatus;

@freezed
class SyncState with _$SyncState {
  const factory SyncState({
    @Default(SyncStatus.idle) SyncStatus syncStatus,
    @Default(false) bool isLoading,
    @Default(false) bool showSyncIndicator,
    DateTime? lastSyncTime,
    String? lastSyncError,
    String? syncMessage,
    @Default(false) bool isInitialized,
  }) = _SyncState;

  const SyncState._();

  // Computed properties
  bool get isSyncing => syncStatus == SyncStatus.syncing;

  String get syncStatusText {
    switch (syncStatus) {
      case SyncStatus.idle:
        return 'Ready';
      case SyncStatus.syncing:
        return 'Syncing...';
      case SyncStatus.success:
        return 'Up to date';
      case SyncStatus.error:
        return 'Sync failed';
    }
  }

  String get lastSyncTimeText {
    if (lastSyncTime == null) return 'Never';

    final now = DateTime.now();
    final difference = now.difference(lastSyncTime!);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
