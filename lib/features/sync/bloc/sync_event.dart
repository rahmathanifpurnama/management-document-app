import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_event.freezed.dart';

@freezed
class SyncEvent with _$SyncEvent {
  const factory SyncEvent.initialize() = _Initialize;
  const factory SyncEvent.performAutoSync({@Default(false) bool force}) = _PerformAutoSync;
  const factory SyncEvent.syncWithProviders({
    dynamic documentProvider,
    dynamic categoryProvider,
    dynamic notificationProvider,
  }) = _SyncWithProviders;
  const factory SyncEvent.onAppResumed() = _OnAppResumed;
  const factory SyncEvent.onPullToRefresh({
    dynamic documentProvider,
    dynamic categoryProvider,
    dynamic notificationProvider,
  }) = _OnPullToRefresh;
  const factory SyncEvent.setSyncIndicatorVisible(bool visible) = _SetSyncIndicatorVisible;
  const factory SyncEvent.hideSyncIndicator() = _HideSyncIndicator;
  const factory SyncEvent.clearSyncMessage() = _ClearSyncMessage;
  const factory SyncEvent.reset() = _Reset;
}
