// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SyncState {
  auto_sync.SyncStatus get syncStatus => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get showSyncIndicator => throw _privateConstructorUsedError;
  DateTime? get lastSyncTime => throw _privateConstructorUsedError;
  String? get lastSyncError => throw _privateConstructorUsedError;
  String? get syncMessage => throw _privateConstructorUsedError;
  bool get isInitialized => throw _privateConstructorUsedError;

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncStateCopyWith<SyncState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncStateCopyWith<$Res> {
  factory $SyncStateCopyWith(SyncState value, $Res Function(SyncState) then) =
      _$SyncStateCopyWithImpl<$Res, SyncState>;
  @useResult
  $Res call({
    auto_sync.SyncStatus syncStatus,
    bool isLoading,
    bool showSyncIndicator,
    DateTime? lastSyncTime,
    String? lastSyncError,
    String? syncMessage,
    bool isInitialized,
  });
}

/// @nodoc
class _$SyncStateCopyWithImpl<$Res, $Val extends SyncState>
    implements $SyncStateCopyWith<$Res> {
  _$SyncStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? syncStatus = null,
    Object? isLoading = null,
    Object? showSyncIndicator = null,
    Object? lastSyncTime = freezed,
    Object? lastSyncError = freezed,
    Object? syncMessage = freezed,
    Object? isInitialized = null,
  }) {
    return _then(
      _value.copyWith(
            syncStatus: null == syncStatus
                ? _value.syncStatus
                : syncStatus // ignore: cast_nullable_to_non_nullable
                      as auto_sync.SyncStatus,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            showSyncIndicator: null == showSyncIndicator
                ? _value.showSyncIndicator
                : showSyncIndicator // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastSyncTime: freezed == lastSyncTime
                ? _value.lastSyncTime
                : lastSyncTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            lastSyncError: freezed == lastSyncError
                ? _value.lastSyncError
                : lastSyncError // ignore: cast_nullable_to_non_nullable
                      as String?,
            syncMessage: freezed == syncMessage
                ? _value.syncMessage
                : syncMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            isInitialized: null == isInitialized
                ? _value.isInitialized
                : isInitialized // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SyncStateImplCopyWith<$Res>
    implements $SyncStateCopyWith<$Res> {
  factory _$$SyncStateImplCopyWith(
    _$SyncStateImpl value,
    $Res Function(_$SyncStateImpl) then,
  ) = __$$SyncStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    auto_sync.SyncStatus syncStatus,
    bool isLoading,
    bool showSyncIndicator,
    DateTime? lastSyncTime,
    String? lastSyncError,
    String? syncMessage,
    bool isInitialized,
  });
}

/// @nodoc
class __$$SyncStateImplCopyWithImpl<$Res>
    extends _$SyncStateCopyWithImpl<$Res, _$SyncStateImpl>
    implements _$$SyncStateImplCopyWith<$Res> {
  __$$SyncStateImplCopyWithImpl(
    _$SyncStateImpl _value,
    $Res Function(_$SyncStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? syncStatus = null,
    Object? isLoading = null,
    Object? showSyncIndicator = null,
    Object? lastSyncTime = freezed,
    Object? lastSyncError = freezed,
    Object? syncMessage = freezed,
    Object? isInitialized = null,
  }) {
    return _then(
      _$SyncStateImpl(
        syncStatus: null == syncStatus
            ? _value.syncStatus
            : syncStatus // ignore: cast_nullable_to_non_nullable
                  as auto_sync.SyncStatus,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        showSyncIndicator: null == showSyncIndicator
            ? _value.showSyncIndicator
            : showSyncIndicator // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastSyncTime: freezed == lastSyncTime
            ? _value.lastSyncTime
            : lastSyncTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastSyncError: freezed == lastSyncError
            ? _value.lastSyncError
            : lastSyncError // ignore: cast_nullable_to_non_nullable
                  as String?,
        syncMessage: freezed == syncMessage
            ? _value.syncMessage
            : syncMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        isInitialized: null == isInitialized
            ? _value.isInitialized
            : isInitialized // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$SyncStateImpl extends _SyncState {
  const _$SyncStateImpl({
    this.syncStatus = SyncStatus.idle,
    this.isLoading = false,
    this.showSyncIndicator = false,
    this.lastSyncTime,
    this.lastSyncError,
    this.syncMessage,
    this.isInitialized = false,
  }) : super._();

  @override
  @JsonKey()
  final auto_sync.SyncStatus syncStatus;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool showSyncIndicator;
  @override
  final DateTime? lastSyncTime;
  @override
  final String? lastSyncError;
  @override
  final String? syncMessage;
  @override
  @JsonKey()
  final bool isInitialized;

  @override
  String toString() {
    return 'SyncState(syncStatus: $syncStatus, isLoading: $isLoading, showSyncIndicator: $showSyncIndicator, lastSyncTime: $lastSyncTime, lastSyncError: $lastSyncError, syncMessage: $syncMessage, isInitialized: $isInitialized)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncStateImpl &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.showSyncIndicator, showSyncIndicator) ||
                other.showSyncIndicator == showSyncIndicator) &&
            (identical(other.lastSyncTime, lastSyncTime) ||
                other.lastSyncTime == lastSyncTime) &&
            (identical(other.lastSyncError, lastSyncError) ||
                other.lastSyncError == lastSyncError) &&
            (identical(other.syncMessage, syncMessage) ||
                other.syncMessage == syncMessage) &&
            (identical(other.isInitialized, isInitialized) ||
                other.isInitialized == isInitialized));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    syncStatus,
    isLoading,
    showSyncIndicator,
    lastSyncTime,
    lastSyncError,
    syncMessage,
    isInitialized,
  );

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncStateImplCopyWith<_$SyncStateImpl> get copyWith =>
      __$$SyncStateImplCopyWithImpl<_$SyncStateImpl>(this, _$identity);
}

abstract class _SyncState extends SyncState {
  const factory _SyncState({
    final auto_sync.SyncStatus syncStatus,
    final bool isLoading,
    final bool showSyncIndicator,
    final DateTime? lastSyncTime,
    final String? lastSyncError,
    final String? syncMessage,
    final bool isInitialized,
  }) = _$SyncStateImpl;
  const _SyncState._() : super._();

  @override
  auto_sync.SyncStatus get syncStatus;
  @override
  bool get isLoading;
  @override
  bool get showSyncIndicator;
  @override
  DateTime? get lastSyncTime;
  @override
  String? get lastSyncError;
  @override
  String? get syncMessage;
  @override
  bool get isInitialized;

  /// Create a copy of SyncState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncStateImplCopyWith<_$SyncStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
