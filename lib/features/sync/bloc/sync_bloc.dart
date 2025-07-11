import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/sync_state.dart';
import 'sync_event.dart';
import '../../../core/services/auto_sync_service.dart' as auto_sync;

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final auto_sync.AutoSyncService _autoSyncService =
      auto_sync.AutoSyncService();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _periodicSyncTimer;

  SyncBloc() : super(const SyncState()) {
    on<SyncEvent>((event, emit) async {
      event.when(
        initialize: () => _handleInitialize(emit),
        performAutoSync: (force) => _handlePerformAutoSync(emit, force),
        syncWithProviders:
            (documentProvider, categoryProvider, notificationProvider) =>
                _handleSyncWithProviders(
                  emit,
                  documentProvider,
                  categoryProvider,
                  notificationProvider,
                ),
        onAppResumed: () => _handleOnAppResumed(emit),
        onPullToRefresh: (documentBloc, categoryBloc, notificationBloc) =>
            _handleOnPullToRefresh(emit, documentBloc),
        setSyncIndicatorVisible: (visible) =>
            _handleSetSyncIndicatorVisible(emit, visible),
        hideSyncIndicator: () => _handleHideSyncIndicator(emit),
        clearSyncMessage: () => _handleClearSyncMessage(emit),
        reset: () => _handleReset(emit),
      );
    });

    // Initialize auto-sync service callbacks
    _initializeServiceCallbacks();
  }

  void _initializeServiceCallbacks() {
    _autoSyncService.onSyncStatusChanged = (status) {
      add(
        SyncEvent.setSyncIndicatorVisible(
          status == auto_sync.SyncStatus.syncing,
        ),
      );
    };

    _autoSyncService.onLoadingStateChanged = (isLoading) {
      // Handle loading state changes through events instead of direct emit
      // This will be handled in the event handlers
    };

    _autoSyncService.onSyncMessage = (message) {
      // Handle sync messages through events instead of direct emit
      // This will be handled in the event handlers
    };
  }

  Future<void> _handleInitialize(Emitter<SyncState> emit) async {
    if (state.isInitialized) return;

    try {
      debugPrint('🔄 Initializing SyncBloc...');

      // Initialize auto-sync service
      await _autoSyncService.initialize();

      // Listen to connectivity changes
      final connectivity = Connectivity();
      _connectivitySubscription = connectivity.onConnectivityChanged.listen(
        _handleConnectivityChange,
      );

      // Start periodic sync (every 5 minutes)
      _startPeriodicSync();

      emit(
        state.copyWith(
          isInitialized: true,
          syncStatus: _autoSyncService.syncStatus,
          lastSyncTime: _autoSyncService.lastSyncTime,
          lastSyncError: _autoSyncService.lastSyncError,
        ),
      );

      debugPrint('✅ SyncBloc initialized successfully');
    } catch (e) {
      debugPrint('❌ Failed to initialize SyncBloc: $e');
      emit(
        state.copyWith(
          syncStatus: SyncStatus.error,
          lastSyncError: e.toString(),
        ),
      );
    }
  }

  Future<void> _handlePerformAutoSync(
    Emitter<SyncState> emit,
    bool force,
  ) async {
    if (!state.isInitialized) {
      add(const SyncEvent.initialize());
      return;
    }

    if (state.isSyncing && !force) {
      debugPrint('⚠️ Sync already in progress, skipping...');
      return;
    }

    // Check connectivity
    final connectivity = Connectivity();
    final connectivityResults = await connectivity.checkConnectivity();
    if (connectivityResults.contains(ConnectivityResult.none) ||
        connectivityResults.isEmpty) {
      debugPrint('❌ No internet connection, skipping sync');
      return;
    }

    emit(
      state.copyWith(
        syncStatus: SyncStatus.syncing,
        isLoading: true,
        showSyncIndicator: true,
      ),
    );

    try {
      debugPrint('🔄 Starting auto-sync...');

      await _autoSyncService.performAutoSync(force: force);

      emit(
        state.copyWith(
          syncStatus: SyncStatus.success,
          isLoading: false,
          lastSyncTime: DateTime.now(),
          lastSyncError: null,
          syncMessage: 'Sync completed successfully',
        ),
      );

      debugPrint('✅ Auto-sync completed successfully');
    } catch (e) {
      emit(
        state.copyWith(
          syncStatus: SyncStatus.error,
          isLoading: false,
          lastSyncError: e.toString(),
          syncMessage: 'Sync failed: ${e.toString()}',
        ),
      );

      debugPrint('❌ Auto-sync failed: $e');
    }
  }

  Future<void> _handleSyncWithProviders(
    Emitter<SyncState> emit,
    dynamic documentProvider,
    dynamic categoryProvider,
    dynamic notificationProvider,
  ) async {
    if (state.isSyncing) return;

    emit(
      state.copyWith(
        syncStatus: SyncStatus.syncing,
        isLoading: true,
        showSyncIndicator: true,
      ),
    );

    try {
      debugPrint('🔄 Syncing with BLoCs...');

      // Sync documents using DocumentBloc
      if (documentProvider != null) {
        // DocumentProvider is now replaced with DocumentBloc
        // The sync will be handled by the DocumentBloc
        debugPrint('  ✅ Documents sync handled by DocumentBloc');
      }

      // Sync categories - handled by CategoryBloc
      debugPrint('  ✅ Categories handled by CategoryBloc');

      // Notifications are handled separately
      debugPrint('  ✅ Notifications handled separately');

      emit(
        state.copyWith(
          syncStatus: SyncStatus.success,
          isLoading: false,
          lastSyncTime: DateTime.now(),
          lastSyncError: null,
          syncMessage: 'Data synchronized successfully',
        ),
      );

      debugPrint('✅ Provider sync completed successfully');
    } catch (e) {
      emit(
        state.copyWith(
          syncStatus: SyncStatus.error,
          isLoading: false,
          lastSyncError: e.toString(),
          syncMessage: 'Sync failed: ${e.toString()}',
        ),
      );

      debugPrint('❌ Provider sync failed: $e');
    }
  }

  Future<void> _handleOnAppResumed(Emitter<SyncState> emit) async {
    debugPrint('📱 App resumed, checking for sync...');

    // Only sync if last sync was more than 2 minutes ago
    if (state.lastSyncTime == null ||
        DateTime.now().difference(state.lastSyncTime!).inMinutes > 2) {
      add(const SyncEvent.performAutoSync());
    }
  }

  Future<void> _handleOnPullToRefresh(
    Emitter<SyncState> emit,
    dynamic documentBloc,
  ) async {
    await _autoSyncService.onPullToRefresh(documentBloc: documentBloc);

    emit(
      state.copyWith(
        syncStatus: _autoSyncService.syncStatus,
        lastSyncTime: _autoSyncService.lastSyncTime,
        lastSyncError: _autoSyncService.lastSyncError,
      ),
    );
  }

  void _handleSetSyncIndicatorVisible(Emitter<SyncState> emit, bool visible) {
    emit(state.copyWith(showSyncIndicator: visible));
  }

  void _handleHideSyncIndicator(Emitter<SyncState> emit) {
    emit(state.copyWith(showSyncIndicator: false));
  }

  void _handleClearSyncMessage(Emitter<SyncState> emit) {
    emit(state.copyWith(syncMessage: null));
  }

  void _handleReset(Emitter<SyncState> emit) {
    _autoSyncService.reset();
    emit(const SyncState());
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    if (results.isNotEmpty && !results.contains(ConnectivityResult.none)) {
      // Connection restored, trigger sync
      add(const SyncEvent.performAutoSync());
    }
  }

  void _startPeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      if (!isClosed) {
        add(const SyncEvent.performAutoSync());
      }
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _periodicSyncTimer?.cancel();
    _autoSyncService.dispose();
    return super.close();
  }
}
