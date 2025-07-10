import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../bloc/sync_bloc.dart';
import '../bloc/sync_event.dart';
import '../models/sync_state.dart';

// Sync BLoC provider
final syncBlocProvider = Provider<SyncBloc>((ref) {
  final bloc = SyncBloc();
  
  // Initialize the bloc
  bloc.add(const SyncEvent.initialize());
  
  // Dispose when no longer needed
  ref.onDispose(() {
    bloc.close();
  });
  
  return bloc;
});

// Sync state provider
final syncStateProvider = StreamProvider<SyncState>((ref) {
  final bloc = ref.watch(syncBlocProvider);
  return bloc.stream;
});

// Convenience providers for specific state properties
final syncStatusProvider = Provider<SyncStatus>((ref) {
  final asyncState = ref.watch(syncStateProvider);
  return asyncState.when(
    data: (state) => state.syncStatus,
    loading: () => SyncStatus.idle,
    error: (_, __) => SyncStatus.error,
  );
});

final isSyncingProvider = Provider<bool>((ref) {
  final asyncState = ref.watch(syncStateProvider);
  return asyncState.when(
    data: (state) => state.isSyncing,
    loading: () => false,
    error: (_, __) => false,
  );
});

final syncMessageProvider = Provider<String?>((ref) {
  final asyncState = ref.watch(syncStateProvider);
  return asyncState.when(
    data: (state) => state.syncMessage,
    loading: () => null,
    error: (_, __) => null,
  );
});

final lastSyncTimeProvider = Provider<DateTime?>((ref) {
  final asyncState = ref.watch(syncStateProvider);
  return asyncState.when(
    data: (state) => state.lastSyncTime,
    loading: () => null,
    error: (_, __) => null,
  );
});

final showSyncIndicatorProvider = Provider<bool>((ref) {
  final asyncState = ref.watch(syncStateProvider);
  return asyncState.when(
    data: (state) => state.showSyncIndicator,
    loading: () => false,
    error: (_, __) => false,
  );
});
