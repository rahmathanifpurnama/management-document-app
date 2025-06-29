import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/auto_sync_service.dart';

class SyncProvider with ChangeNotifier {
  static final SyncProvider _instance = SyncProvider._internal();
  factory SyncProvider() => _instance;
  SyncProvider._internal() {
    _initializeService();
  }

  final AutoSyncService _autoSyncService = AutoSyncService();

  bool _isLoading = false;
  String? _syncMessage;
  bool _showSyncIndicator = false;

  // Getters
  bool get isLoading => _isLoading;
  bool get isSyncing => _autoSyncService.isSyncing;
  SyncStatus get syncStatus => _autoSyncService.syncStatus;
  DateTime? get lastSyncTime => _autoSyncService.lastSyncTime;
  String? get lastSyncError => _autoSyncService.lastSyncError;
  String? get syncMessage => _syncMessage;
  bool get showSyncIndicator => _showSyncIndicator;

  // Display getters
  String get syncStatusText => _autoSyncService.getSyncStatusText();
  String get lastSyncTimeText => _autoSyncService.getLastSyncTimeText();

  /// Initialize the auto-sync service
  void _initializeService() {
    _autoSyncService.onSyncStatusChanged = _handleSyncStatusChanged;
    _autoSyncService.onLoadingStateChanged = _handleLoadingStateChanged;
    _autoSyncService.onSyncMessage = _handleSyncMessage;
    _autoSyncService.initialize();
  }

  /// Handle sync status changes
  void _handleSyncStatusChanged(SyncStatus status) {
    _showSyncIndicator = status == SyncStatus.syncing;
    notifyListeners();
  }

  /// Handle loading state changes
  void _handleLoadingStateChanged(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  /// Handle sync messages
  void _handleSyncMessage(String message) {
    _syncMessage = message;
    notifyListeners();

    // Clear message after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (_syncMessage == message) {
        _syncMessage = null;
        notifyListeners();
      }
    });
  }

  /// Perform auto sync
  Future<void> performAutoSync({bool force = false}) async {
    await _autoSyncService.performAutoSync(force: force);
  }

  /// Sync with providers
  Future<void> syncWithProviders({
    dynamic documentProvider,
    dynamic categoryProvider,
    dynamic notificationProvider,
  }) async {
    await _autoSyncService.syncWithProviders(
      documentProvider: documentProvider,
      categoryProvider: categoryProvider,
      notificationProvider: notificationProvider,
    );
  }

  /// Handle app resume
  void onAppResumed() {
    _autoSyncService.onAppResumed();
  }

  /// Handle pull-to-refresh
  Future<void> onPullToRefresh({
    dynamic documentProvider,
    dynamic categoryProvider,
    dynamic notificationProvider,
  }) async {
    await _autoSyncService.onPullToRefresh(
      documentProvider: documentProvider,
      categoryProvider: categoryProvider,
      notificationProvider: notificationProvider,
    );
  }

  /// Show sync indicator manually
  void setSyncIndicatorVisible(bool visible) {
    _showSyncIndicator = visible;
    notifyListeners();
  }

  /// Hide sync indicator manually
  void hideSyncIndicator() {
    _showSyncIndicator = false;
    notifyListeners();
  }

  /// Clear sync message
  void clearSyncMessage() {
    _syncMessage = null;
    notifyListeners();
  }

  /// Reset sync state
  void reset() {
    _autoSyncService.reset();
    _isLoading = false;
    _syncMessage = null;
    _showSyncIndicator = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _autoSyncService.dispose();
    super.dispose();
  }
}

/// Sync indicator widget for showing sync status
class SyncIndicatorWidget extends StatelessWidget {
  final bool showText;
  final double size;

  const SyncIndicatorWidget({super.key, this.showText = true, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Consumer<SyncProvider>(
      builder: (context, syncProvider, child) {
        if (!syncProvider.showSyncIndicator) {
          return const SizedBox.shrink();
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            if (showText) ...[
              const SizedBox(width: 8),
              Text(
                'Syncing...',
                style: TextStyle(fontSize: size * 0.8, color: Colors.blue),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Sync status widget for showing detailed sync information
class SyncStatusWidget extends StatelessWidget {
  final bool showLastSyncTime;
  final bool showSyncMessage;

  const SyncStatusWidget({
    super.key,
    this.showLastSyncTime = true,
    this.showSyncMessage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SyncProvider>(
      builder: (context, syncProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sync status
            Row(
              children: [
                _buildStatusIcon(syncProvider.syncStatus),
                const SizedBox(width: 8),
                Text(
                  syncProvider.syncStatusText,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: _getStatusColor(syncProvider.syncStatus),
                  ),
                ),
                if (syncProvider.isSyncing) ...[
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
            if (showLastSyncTime && !syncProvider.isSyncing) ...[
              const SizedBox(height: 4),
              Text(
                'Last sync: ${syncProvider.lastSyncTimeText}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],

            // Sync message
            if (showSyncMessage && syncProvider.syncMessage != null) ...[
              const SizedBox(height: 4),
              Text(
                syncProvider.syncMessage!,
                style: const TextStyle(fontSize: 12, color: Colors.blue),
              ),
            ],

            // Error message
            if (syncProvider.syncStatus == SyncStatus.error &&
                syncProvider.lastSyncError != null) ...[
              const SizedBox(height: 4),
              Text(
                syncProvider.lastSyncError!,
                style: const TextStyle(fontSize: 12, color: Colors.red),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        );
      },
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
}
