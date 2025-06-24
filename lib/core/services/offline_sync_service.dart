import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../utils/anr_prevention.dart';
import '../config/anr_config.dart';
import '../../models/offline_auth_models.dart';
import 'connectivity_service.dart';
import 'secure_storage_service.dart';
import 'firebase_service.dart';

/// Service for managing offline actions and syncing them when connection is restored
/// Handles queuing, prioritization, and execution of offline operations
class OfflineSyncService {
  static OfflineSyncService? _instance;
  static OfflineSyncService get instance => _instance ??= OfflineSyncService._();

  OfflineSyncService._();

  // Service dependencies
  final ConnectivityService _connectivityService = ConnectivityService.instance;
  final SecureStorageService _secureStorage = SecureStorageService.instance;
  final FirebaseService _firebaseService = FirebaseService.instance;

  // Stream controllers for sync status
  final StreamController<OfflineSyncStatus> _syncStatusController = 
      StreamController<OfflineSyncStatus>.broadcast();

  // Current sync status
  OfflineSyncStatus _currentSyncStatus = OfflineSyncStatus(
    pendingActions: [],
    syncState: SyncState.idle,
  );

  Timer? _syncTimer;
  bool _isSyncing = false;

  // Constants
  static const Duration _syncInterval = Duration(minutes: 5);
  static const int _maxRetryAttempts = 3;
  static const Duration _retryDelay = Duration(seconds: 30);

  // Stream for external consumption
  Stream<OfflineSyncStatus> get syncStatusStream => _syncStatusController.stream;

  // Current state getters
  OfflineSyncStatus get currentSyncStatus => _currentSyncStatus;
  bool get isSyncing => _isSyncing;
  bool get hasPendingActions => _currentSyncStatus.pendingActions.isNotEmpty;

  /// Initialize the offline sync service
  Future<void> initialize() async {
    try {
      debugPrint('🔄 Initializing OfflineSyncService...');

      // Load pending actions from storage
      await _loadPendingActions();

      // Listen to connectivity changes
      _connectivityService.internetStream.listen(_onConnectivityChanged);

      // Start periodic sync timer
      _startSyncTimer();

      debugPrint('✅ OfflineSyncService initialized successfully');
    } catch (e) {
      debugPrint('❌ Failed to initialize OfflineSyncService: $e');
      rethrow;
    }
  }

  /// Handle connectivity changes
  void _onConnectivityChanged(bool isOnline) async {
    if (isOnline && hasPendingActions && !_isSyncing) {
      debugPrint('🌐 Connection restored, starting sync...');
      await syncPendingActions();
    }
  }

  /// Load pending actions from secure storage
  Future<void> _loadPendingActions() async {
    try {
      final actions = await _secureStorage.getOfflineActions();
      _currentSyncStatus = _currentSyncStatus.copyWith(
        pendingActions: actions.map((actionMap) => OfflineAction.fromJson(actionMap)).toList(),
      );
      
      _syncStatusController.add(_currentSyncStatus);
      debugPrint('📥 Loaded ${actions.length} pending actions');
    } catch (e) {
      debugPrint('❌ Failed to load pending actions: $e');
    }
  }

  /// Save pending actions to secure storage
  Future<void> _savePendingActions() async {
    try {
      final actionMaps = _currentSyncStatus.pendingActions
          .map((action) => action.toJson())
          .toList();
      
      await _secureStorage.storeOfflineActions(actionMaps);
      debugPrint('💾 Saved ${actionMaps.length} pending actions');
    } catch (e) {
      debugPrint('❌ Failed to save pending actions: $e');
    }
  }

  /// Queue an offline action
  Future<void> queueAction({
    required String type,
    required Map<String, dynamic> data,
    ActionPriority priority = ActionPriority.normal,
    DateTime? scheduledFor,
  }) async {
    try {
      final action = OfflineAction(
        id: const Uuid().v4(),
        type: type,
        data: data,
        createdAt: DateTime.now(),
        priority: priority,
        scheduledFor: scheduledFor,
      );

      final updatedActions = List<OfflineAction>.from(_currentSyncStatus.pendingActions);
      
      // Insert action based on priority
      _insertActionByPriority(updatedActions, action);

      _currentSyncStatus = _currentSyncStatus.copyWith(
        pendingActions: updatedActions,
      );

      await _savePendingActions();
      _syncStatusController.add(_currentSyncStatus);

      debugPrint('📝 Queued offline action: ${action.type} (${action.priority.name})');

      // Try to sync immediately if online
      if (_connectivityService.isOnline && !_isSyncing) {
        await syncPendingActions();
      }
    } catch (e) {
      debugPrint('❌ Failed to queue offline action: $e');
      rethrow;
    }
  }

  /// Insert action into list based on priority
  void _insertActionByPriority(List<OfflineAction> actions, OfflineAction newAction) {
    int insertIndex = actions.length;
    
    for (int i = 0; i < actions.length; i++) {
      if (_getPriorityValue(newAction.priority) > _getPriorityValue(actions[i].priority)) {
        insertIndex = i;
        break;
      }
    }
    
    actions.insert(insertIndex, newAction);
  }

  /// Get numeric value for priority comparison
  int _getPriorityValue(ActionPriority priority) {
    switch (priority) {
      case ActionPriority.critical:
        return 4;
      case ActionPriority.high:
        return 3;
      case ActionPriority.normal:
        return 2;
      case ActionPriority.low:
        return 1;
    }
  }

  /// Sync all pending actions
  Future<void> syncPendingActions() async {
    if (_isSyncing || !_connectivityService.isOnline) {
      return;
    }

    try {
      _isSyncing = true;
      debugPrint('🔄 Starting sync of ${_currentSyncStatus.pendingActions.length} actions...');

      _currentSyncStatus = _currentSyncStatus.copyWith(
        syncState: SyncState.syncing,
        lastSyncAttempt: DateTime.now(),
      );
      _syncStatusController.add(_currentSyncStatus);

      final actionsToSync = List<OfflineAction>.from(_currentSyncStatus.pendingActions);
      final syncedActions = <OfflineAction>[];
      final failedActions = <OfflineAction>[];

      for (final action in actionsToSync) {
        // Check if action is scheduled for future
        if (action.scheduledFor != null && DateTime.now().isBefore(action.scheduledFor!)) {
          continue;
        }

        try {
          final success = await _executeAction(action);
          if (success) {
            syncedActions.add(action);
            debugPrint('✅ Synced action: ${action.type}');
          } else {
            failedActions.add(action);
            debugPrint('❌ Failed to sync action: ${action.type}');
          }
        } catch (e) {
          debugPrint('❌ Error syncing action ${action.type}: $e');
          failedActions.add(action);
        }

        // Add small delay to prevent overwhelming the server
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Update pending actions (remove synced, update failed with retry count)
      final remainingActions = <OfflineAction>[];
      
      for (final action in failedActions) {
        if (action.retryCount < _maxRetryAttempts) {
          remainingActions.add(action.copyWith(
            retryCount: action.retryCount + 1,
            scheduledFor: DateTime.now().add(_retryDelay),
          ));
        } else {
          debugPrint('🗑️ Discarding action after max retries: ${action.type}');
        }
      }

      // Keep actions that weren't processed (scheduled for future)
      for (final action in actionsToSync) {
        if (!syncedActions.contains(action) && !failedActions.contains(action)) {
          remainingActions.add(action);
        }
      }

      _currentSyncStatus = _currentSyncStatus.copyWith(
        pendingActions: remainingActions,
        syncState: remainingActions.isEmpty ? SyncState.completed : SyncState.failed,
        lastSuccessfulSync: syncedActions.isNotEmpty ? DateTime.now() : _currentSyncStatus.lastSuccessfulSync,
        failedSyncAttempts: failedActions.isNotEmpty ? _currentSyncStatus.failedSyncAttempts + 1 : 0,
        lastSyncError: failedActions.isNotEmpty ? 'Some actions failed to sync' : null,
      );

      await _savePendingActions();
      _syncStatusController.add(_currentSyncStatus);

      debugPrint('✅ Sync completed: ${syncedActions.length} synced, ${failedActions.length} failed, ${remainingActions.length} remaining');

    } catch (e) {
      debugPrint('❌ Sync process failed: $e');
      _currentSyncStatus = _currentSyncStatus.copyWith(
        syncState: SyncState.failed,
        failedSyncAttempts: _currentSyncStatus.failedSyncAttempts + 1,
        lastSyncError: e.toString(),
      );
      _syncStatusController.add(_currentSyncStatus);
    } finally {
      _isSyncing = false;
    }
  }

  /// Execute a specific offline action
  Future<bool> _executeAction(OfflineAction action) async {
    try {
      switch (action.type) {
        case 'login_activity':
          return await _syncLoginActivity(action.data);
        case 'document_view':
          return await _syncDocumentView(action.data);
        case 'user_preference':
          return await _syncUserPreference(action.data);
        case 'activity_log':
          return await _syncActivityLog(action.data);
        default:
          debugPrint('⚠️ Unknown action type: ${action.type}');
          return false;
      }
    } catch (e) {
      debugPrint('❌ Failed to execute action ${action.type}: $e');
      return false;
    }
  }

  /// Sync login activity
  Future<bool> _syncLoginActivity(Map<String, dynamic> data) async {
    try {
      // Update user's last login time in Firestore
      final userId = data['userId'] as String?;
      final loginTime = DateTime.parse(data['loginTime'] as String);
      
      if (userId != null) {
        await ANRPrevention.executeWithTimeout(
          _firebaseService.usersCollection.doc(userId).update({
            'lastLogin': loginTime,
          }),
          timeout: ANRConfig.firestoreQueryTimeout,
          operationName: 'Sync Login Activity',
        );
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Failed to sync login activity: $e');
      return false;
    }
  }

  /// Sync document view activity
  Future<bool> _syncDocumentView(Map<String, dynamic> data) async {
    try {
      // Log document view activity
      await ANRPrevention.executeWithTimeout(
        _firebaseService.activitiesCollection.add({
          'type': 'document_view',
          'userId': data['userId'],
          'documentId': data['documentId'],
          'timestamp': DateTime.parse(data['timestamp'] as String),
          'metadata': data['metadata'] ?? {},
        }),
        timeout: ANRConfig.firestoreQueryTimeout,
        operationName: 'Sync Document View',
      );
      return true;
    } catch (e) {
      debugPrint('❌ Failed to sync document view: $e');
      return false;
    }
  }

  /// Sync user preference changes
  Future<bool> _syncUserPreference(Map<String, dynamic> data) async {
    try {
      final userId = data['userId'] as String?;
      final preferences = data['preferences'] as Map<String, dynamic>?;
      
      if (userId != null && preferences != null) {
        await ANRPrevention.executeWithTimeout(
          _firebaseService.usersCollection.doc(userId).update({
            'preferences': preferences,
          }),
          timeout: ANRConfig.firestoreQueryTimeout,
          operationName: 'Sync User Preferences',
        );
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Failed to sync user preferences: $e');
      return false;
    }
  }

  /// Sync activity log
  Future<bool> _syncActivityLog(Map<String, dynamic> data) async {
    try {
      await ANRPrevention.executeWithTimeout(
        _firebaseService.activitiesCollection.add(data),
        timeout: ANRConfig.firestoreQueryTimeout,
        operationName: 'Sync Activity Log',
      );
      return true;
    } catch (e) {
      debugPrint('❌ Failed to sync activity log: $e');
      return false;
    }
  }

  /// Clear all pending actions
  Future<void> clearPendingActions() async {
    try {
      _currentSyncStatus = _currentSyncStatus.copyWith(
        pendingActions: [],
        syncState: SyncState.idle,
      );
      
      await _savePendingActions();
      _syncStatusController.add(_currentSyncStatus);
      
      debugPrint('🗑️ Cleared all pending actions');
    } catch (e) {
      debugPrint('❌ Failed to clear pending actions: $e');
      rethrow;
    }
  }

  /// Get pending actions count by priority
  Map<ActionPriority, int> getPendingActionsByPriority() {
    final counts = <ActionPriority, int>{};
    
    for (final priority in ActionPriority.values) {
      counts[priority] = _currentSyncStatus.pendingActions
          .where((action) => action.priority == priority)
          .length;
    }
    
    return counts;
  }

  /// Start periodic sync timer
  void _startSyncTimer() {
    _syncTimer = Timer.periodic(_syncInterval, (_) {
      if (_connectivityService.isOnline && hasPendingActions && !_isSyncing) {
        syncPendingActions();
      }
    });
  }

  /// Dispose resources
  void dispose() {
    _syncTimer?.cancel();
    _syncStatusController.close();
  }
}
