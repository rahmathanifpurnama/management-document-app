// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UserState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )
    loaded,
    required TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      String operationType,
    )
    performingOperation,
    required TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )
    syncing,
    required TResult Function(
      String message,
      List<UserModel>? users,
      List<UserModel>? filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      bool canRetry,
      String? lastFailedOperation,
    )
    error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    loaded,
    TResult? Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      String operationType,
    )?
    performingOperation,
    TResult? Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    syncing,
    TResult? Function(
      String message,
      List<UserModel>? users,
      List<UserModel>? filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      bool canRetry,
      String? lastFailedOperation,
    )?
    error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    loaded,
    TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      String operationType,
    )?
    performingOperation,
    TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    syncing,
    TResult Function(
      String message,
      List<UserModel>? users,
      List<UserModel>? filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      bool canRetry,
      String? lastFailedOperation,
    )?
    error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserInitial value) initial,
    required TResult Function(UserLoading value) loading,
    required TResult Function(UserLoaded value) loaded,
    required TResult Function(UserPerformingOperation value)
    performingOperation,
    required TResult Function(UserSyncing value) syncing,
    required TResult Function(UserError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserInitial value)? initial,
    TResult? Function(UserLoading value)? loading,
    TResult? Function(UserLoaded value)? loaded,
    TResult? Function(UserPerformingOperation value)? performingOperation,
    TResult? Function(UserSyncing value)? syncing,
    TResult? Function(UserError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserInitial value)? initial,
    TResult Function(UserLoading value)? loading,
    TResult Function(UserLoaded value)? loaded,
    TResult Function(UserPerformingOperation value)? performingOperation,
    TResult Function(UserSyncing value)? syncing,
    TResult Function(UserError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStateCopyWith<$Res> {
  factory $UserStateCopyWith(UserState value, $Res Function(UserState) then) =
      _$UserStateCopyWithImpl<$Res, UserState>;
}

/// @nodoc
class _$UserStateCopyWithImpl<$Res, $Val extends UserState>
    implements $UserStateCopyWith<$Res> {
  _$UserStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$UserInitialImplCopyWith<$Res> {
  factory _$$UserInitialImplCopyWith(
    _$UserInitialImpl value,
    $Res Function(_$UserInitialImpl) then,
  ) = __$$UserInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UserInitialImplCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$UserInitialImpl>
    implements _$$UserInitialImplCopyWith<$Res> {
  __$$UserInitialImplCopyWithImpl(
    _$UserInitialImpl _value,
    $Res Function(_$UserInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UserInitialImpl implements UserInitial {
  const _$UserInitialImpl();

  @override
  String toString() {
    return 'UserState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UserInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )
    loaded,
    required TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      String operationType,
    )
    performingOperation,
    required TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )
    syncing,
    required TResult Function(
      String message,
      List<UserModel>? users,
      List<UserModel>? filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      bool canRetry,
      String? lastFailedOperation,
    )
    error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    loaded,
    TResult? Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      String operationType,
    )?
    performingOperation,
    TResult? Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    syncing,
    TResult? Function(
      String message,
      List<UserModel>? users,
      List<UserModel>? filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      bool canRetry,
      String? lastFailedOperation,
    )?
    error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    loaded,
    TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      String operationType,
    )?
    performingOperation,
    TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    syncing,
    TResult Function(
      String message,
      List<UserModel>? users,
      List<UserModel>? filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      bool canRetry,
      String? lastFailedOperation,
    )?
    error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserInitial value) initial,
    required TResult Function(UserLoading value) loading,
    required TResult Function(UserLoaded value) loaded,
    required TResult Function(UserPerformingOperation value)
    performingOperation,
    required TResult Function(UserSyncing value) syncing,
    required TResult Function(UserError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserInitial value)? initial,
    TResult? Function(UserLoading value)? loading,
    TResult? Function(UserLoaded value)? loaded,
    TResult? Function(UserPerformingOperation value)? performingOperation,
    TResult? Function(UserSyncing value)? syncing,
    TResult? Function(UserError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserInitial value)? initial,
    TResult Function(UserLoading value)? loading,
    TResult Function(UserLoaded value)? loaded,
    TResult Function(UserPerformingOperation value)? performingOperation,
    TResult Function(UserSyncing value)? syncing,
    TResult Function(UserError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class UserInitial implements UserState {
  const factory UserInitial() = _$UserInitialImpl;
}

/// @nodoc
abstract class _$$UserLoadingImplCopyWith<$Res> {
  factory _$$UserLoadingImplCopyWith(
    _$UserLoadingImpl value,
    $Res Function(_$UserLoadingImpl) then,
  ) = __$$UserLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UserLoadingImplCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$UserLoadingImpl>
    implements _$$UserLoadingImplCopyWith<$Res> {
  __$$UserLoadingImplCopyWithImpl(
    _$UserLoadingImpl _value,
    $Res Function(_$UserLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UserLoadingImpl implements UserLoading {
  const _$UserLoadingImpl();

  @override
  String toString() {
    return 'UserState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UserLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )
    loaded,
    required TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      String operationType,
    )
    performingOperation,
    required TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )
    syncing,
    required TResult Function(
      String message,
      List<UserModel>? users,
      List<UserModel>? filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      bool canRetry,
      String? lastFailedOperation,
    )
    error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    loaded,
    TResult? Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      String operationType,
    )?
    performingOperation,
    TResult? Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    syncing,
    TResult? Function(
      String message,
      List<UserModel>? users,
      List<UserModel>? filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      bool canRetry,
      String? lastFailedOperation,
    )?
    error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    loaded,
    TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      String operationType,
    )?
    performingOperation,
    TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    syncing,
    TResult Function(
      String message,
      List<UserModel>? users,
      List<UserModel>? filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      bool canRetry,
      String? lastFailedOperation,
    )?
    error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserInitial value) initial,
    required TResult Function(UserLoading value) loading,
    required TResult Function(UserLoaded value) loaded,
    required TResult Function(UserPerformingOperation value)
    performingOperation,
    required TResult Function(UserSyncing value) syncing,
    required TResult Function(UserError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserInitial value)? initial,
    TResult? Function(UserLoading value)? loading,
    TResult? Function(UserLoaded value)? loaded,
    TResult? Function(UserPerformingOperation value)? performingOperation,
    TResult? Function(UserSyncing value)? syncing,
    TResult? Function(UserError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserInitial value)? initial,
    TResult Function(UserLoading value)? loading,
    TResult Function(UserLoaded value)? loaded,
    TResult Function(UserPerformingOperation value)? performingOperation,
    TResult Function(UserSyncing value)? syncing,
    TResult Function(UserError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class UserLoading implements UserState {
  const factory UserLoading() = _$UserLoadingImpl;
}

/// @nodoc
abstract class _$$UserLoadedImplCopyWith<$Res> {
  factory _$$UserLoadedImplCopyWith(
    _$UserLoadedImpl value,
    $Res Function(_$UserLoadedImpl) then,
  ) = __$$UserLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<UserModel> users,
    List<UserModel> filteredUsers,
    String searchQuery,
    String selectedRole,
    String selectedStatus,
    bool isFiltered,
  });
}

/// @nodoc
class __$$UserLoadedImplCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$UserLoadedImpl>
    implements _$$UserLoadedImplCopyWith<$Res> {
  __$$UserLoadedImplCopyWithImpl(
    _$UserLoadedImpl _value,
    $Res Function(_$UserLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? filteredUsers = null,
    Object? searchQuery = null,
    Object? selectedRole = null,
    Object? selectedStatus = null,
    Object? isFiltered = null,
  }) {
    return _then(
      _$UserLoadedImpl(
        users: null == users
            ? _value._users
            : users // ignore: cast_nullable_to_non_nullable
                  as List<UserModel>,
        filteredUsers: null == filteredUsers
            ? _value._filteredUsers
            : filteredUsers // ignore: cast_nullable_to_non_nullable
                  as List<UserModel>,
        searchQuery: null == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedRole: null == selectedRole
            ? _value.selectedRole
            : selectedRole // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedStatus: null == selectedStatus
            ? _value.selectedStatus
            : selectedStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        isFiltered: null == isFiltered
            ? _value.isFiltered
            : isFiltered // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$UserLoadedImpl implements UserLoaded {
  const _$UserLoadedImpl({
    required final List<UserModel> users,
    required final List<UserModel> filteredUsers,
    this.searchQuery = '',
    this.selectedRole = 'all',
    this.selectedStatus = 'all',
    this.isFiltered = false,
  }) : _users = users,
       _filteredUsers = filteredUsers;

  final List<UserModel> _users;
  @override
  List<UserModel> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  final List<UserModel> _filteredUsers;
  @override
  List<UserModel> get filteredUsers {
    if (_filteredUsers is EqualUnmodifiableListView) return _filteredUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredUsers);
  }

  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final String selectedRole;
  @override
  @JsonKey()
  final String selectedStatus;
  @override
  @JsonKey()
  final bool isFiltered;

  @override
  String toString() {
    return 'UserState.loaded(users: $users, filteredUsers: $filteredUsers, searchQuery: $searchQuery, selectedRole: $selectedRole, selectedStatus: $selectedStatus, isFiltered: $isFiltered)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserLoadedImpl &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            const DeepCollectionEquality().equals(
              other._filteredUsers,
              _filteredUsers,
            ) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.selectedRole, selectedRole) ||
                other.selectedRole == selectedRole) &&
            (identical(other.selectedStatus, selectedStatus) ||
                other.selectedStatus == selectedStatus) &&
            (identical(other.isFiltered, isFiltered) ||
                other.isFiltered == isFiltered));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_users),
    const DeepCollectionEquality().hash(_filteredUsers),
    searchQuery,
    selectedRole,
    selectedStatus,
    isFiltered,
  );

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserLoadedImplCopyWith<_$UserLoadedImpl> get copyWith =>
      __$$UserLoadedImplCopyWithImpl<_$UserLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )
    loaded,
    required TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      String operationType,
    )
    performingOperation,
    required TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )
    syncing,
    required TResult Function(
      String message,
      List<UserModel>? users,
      List<UserModel>? filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      bool canRetry,
      String? lastFailedOperation,
    )
    error,
  }) {
    return loaded(
      users,
      filteredUsers,
      searchQuery,
      selectedRole,
      selectedStatus,
      isFiltered,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    loaded,
    TResult? Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      String operationType,
    )?
    performingOperation,
    TResult? Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    syncing,
    TResult? Function(
      String message,
      List<UserModel>? users,
      List<UserModel>? filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      bool canRetry,
      String? lastFailedOperation,
    )?
    error,
  }) {
    return loaded?.call(
      users,
      filteredUsers,
      searchQuery,
      selectedRole,
      selectedStatus,
      isFiltered,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    loaded,
    TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      String operationType,
    )?
    performingOperation,
    TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    syncing,
    TResult Function(
      String message,
      List<UserModel>? users,
      List<UserModel>? filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      bool canRetry,
      String? lastFailedOperation,
    )?
    error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(
        users,
        filteredUsers,
        searchQuery,
        selectedRole,
        selectedStatus,
        isFiltered,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserInitial value) initial,
    required TResult Function(UserLoading value) loading,
    required TResult Function(UserLoaded value) loaded,
    required TResult Function(UserPerformingOperation value)
    performingOperation,
    required TResult Function(UserSyncing value) syncing,
    required TResult Function(UserError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserInitial value)? initial,
    TResult? Function(UserLoading value)? loading,
    TResult? Function(UserLoaded value)? loaded,
    TResult? Function(UserPerformingOperation value)? performingOperation,
    TResult? Function(UserSyncing value)? syncing,
    TResult? Function(UserError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserInitial value)? initial,
    TResult Function(UserLoading value)? loading,
    TResult Function(UserLoaded value)? loaded,
    TResult Function(UserPerformingOperation value)? performingOperation,
    TResult Function(UserSyncing value)? syncing,
    TResult Function(UserError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class UserLoaded implements UserState {
  const factory UserLoaded({
    required final List<UserModel> users,
    required final List<UserModel> filteredUsers,
    final String searchQuery,
    final String selectedRole,
    final String selectedStatus,
    final bool isFiltered,
  }) = _$UserLoadedImpl;

  List<UserModel> get users;
  List<UserModel> get filteredUsers;
  String get searchQuery;
  String get selectedRole;
  String get selectedStatus;
  bool get isFiltered;

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserLoadedImplCopyWith<_$UserLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UserPerformingOperationImplCopyWith<$Res> {
  factory _$$UserPerformingOperationImplCopyWith(
    _$UserPerformingOperationImpl value,
    $Res Function(_$UserPerformingOperationImpl) then,
  ) = __$$UserPerformingOperationImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<UserModel> users,
    List<UserModel> filteredUsers,
    String searchQuery,
    String selectedRole,
    String selectedStatus,
    bool isFiltered,
    String operationType,
  });
}

/// @nodoc
class __$$UserPerformingOperationImplCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$UserPerformingOperationImpl>
    implements _$$UserPerformingOperationImplCopyWith<$Res> {
  __$$UserPerformingOperationImplCopyWithImpl(
    _$UserPerformingOperationImpl _value,
    $Res Function(_$UserPerformingOperationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? filteredUsers = null,
    Object? searchQuery = null,
    Object? selectedRole = null,
    Object? selectedStatus = null,
    Object? isFiltered = null,
    Object? operationType = null,
  }) {
    return _then(
      _$UserPerformingOperationImpl(
        users: null == users
            ? _value._users
            : users // ignore: cast_nullable_to_non_nullable
                  as List<UserModel>,
        filteredUsers: null == filteredUsers
            ? _value._filteredUsers
            : filteredUsers // ignore: cast_nullable_to_non_nullable
                  as List<UserModel>,
        searchQuery: null == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedRole: null == selectedRole
            ? _value.selectedRole
            : selectedRole // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedStatus: null == selectedStatus
            ? _value.selectedStatus
            : selectedStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        isFiltered: null == isFiltered
            ? _value.isFiltered
            : isFiltered // ignore: cast_nullable_to_non_nullable
                  as bool,
        operationType: null == operationType
            ? _value.operationType
            : operationType // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UserPerformingOperationImpl implements UserPerformingOperation {
  const _$UserPerformingOperationImpl({
    required final List<UserModel> users,
    required final List<UserModel> filteredUsers,
    this.searchQuery = '',
    this.selectedRole = 'all',
    this.selectedStatus = 'all',
    this.isFiltered = false,
    required this.operationType,
  }) : _users = users,
       _filteredUsers = filteredUsers;

  final List<UserModel> _users;
  @override
  List<UserModel> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  final List<UserModel> _filteredUsers;
  @override
  List<UserModel> get filteredUsers {
    if (_filteredUsers is EqualUnmodifiableListView) return _filteredUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredUsers);
  }

  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final String selectedRole;
  @override
  @JsonKey()
  final String selectedStatus;
  @override
  @JsonKey()
  final bool isFiltered;
  @override
  final String operationType;

  @override
  String toString() {
    return 'UserState.performingOperation(users: $users, filteredUsers: $filteredUsers, searchQuery: $searchQuery, selectedRole: $selectedRole, selectedStatus: $selectedStatus, isFiltered: $isFiltered, operationType: $operationType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPerformingOperationImpl &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            const DeepCollectionEquality().equals(
              other._filteredUsers,
              _filteredUsers,
            ) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.selectedRole, selectedRole) ||
                other.selectedRole == selectedRole) &&
            (identical(other.selectedStatus, selectedStatus) ||
                other.selectedStatus == selectedStatus) &&
            (identical(other.isFiltered, isFiltered) ||
                other.isFiltered == isFiltered) &&
            (identical(other.operationType, operationType) ||
                other.operationType == operationType));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_users),
    const DeepCollectionEquality().hash(_filteredUsers),
    searchQuery,
    selectedRole,
    selectedStatus,
    isFiltered,
    operationType,
  );

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPerformingOperationImplCopyWith<_$UserPerformingOperationImpl>
  get copyWith =>
      __$$UserPerformingOperationImplCopyWithImpl<
        _$UserPerformingOperationImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )
    loaded,
    required TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      String operationType,
    )
    performingOperation,
    required TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )
    syncing,
    required TResult Function(
      String message,
      List<UserModel>? users,
      List<UserModel>? filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      bool canRetry,
      String? lastFailedOperation,
    )
    error,
  }) {
    return performingOperation(
      users,
      filteredUsers,
      searchQuery,
      selectedRole,
      selectedStatus,
      isFiltered,
      operationType,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    loaded,
    TResult? Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      String operationType,
    )?
    performingOperation,
    TResult? Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    syncing,
    TResult? Function(
      String message,
      List<UserModel>? users,
      List<UserModel>? filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      bool canRetry,
      String? lastFailedOperation,
    )?
    error,
  }) {
    return performingOperation?.call(
      users,
      filteredUsers,
      searchQuery,
      selectedRole,
      selectedStatus,
      isFiltered,
      operationType,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    loaded,
    TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      String operationType,
    )?
    performingOperation,
    TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    syncing,
    TResult Function(
      String message,
      List<UserModel>? users,
      List<UserModel>? filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      bool canRetry,
      String? lastFailedOperation,
    )?
    error,
    required TResult orElse(),
  }) {
    if (performingOperation != null) {
      return performingOperation(
        users,
        filteredUsers,
        searchQuery,
        selectedRole,
        selectedStatus,
        isFiltered,
        operationType,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserInitial value) initial,
    required TResult Function(UserLoading value) loading,
    required TResult Function(UserLoaded value) loaded,
    required TResult Function(UserPerformingOperation value)
    performingOperation,
    required TResult Function(UserSyncing value) syncing,
    required TResult Function(UserError value) error,
  }) {
    return performingOperation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserInitial value)? initial,
    TResult? Function(UserLoading value)? loading,
    TResult? Function(UserLoaded value)? loaded,
    TResult? Function(UserPerformingOperation value)? performingOperation,
    TResult? Function(UserSyncing value)? syncing,
    TResult? Function(UserError value)? error,
  }) {
    return performingOperation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserInitial value)? initial,
    TResult Function(UserLoading value)? loading,
    TResult Function(UserLoaded value)? loaded,
    TResult Function(UserPerformingOperation value)? performingOperation,
    TResult Function(UserSyncing value)? syncing,
    TResult Function(UserError value)? error,
    required TResult orElse(),
  }) {
    if (performingOperation != null) {
      return performingOperation(this);
    }
    return orElse();
  }
}

abstract class UserPerformingOperation implements UserState {
  const factory UserPerformingOperation({
    required final List<UserModel> users,
    required final List<UserModel> filteredUsers,
    final String searchQuery,
    final String selectedRole,
    final String selectedStatus,
    final bool isFiltered,
    required final String operationType,
  }) = _$UserPerformingOperationImpl;

  List<UserModel> get users;
  List<UserModel> get filteredUsers;
  String get searchQuery;
  String get selectedRole;
  String get selectedStatus;
  bool get isFiltered;
  String get operationType;

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserPerformingOperationImplCopyWith<_$UserPerformingOperationImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UserSyncingImplCopyWith<$Res> {
  factory _$$UserSyncingImplCopyWith(
    _$UserSyncingImpl value,
    $Res Function(_$UserSyncingImpl) then,
  ) = __$$UserSyncingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<UserModel> users,
    List<UserModel> filteredUsers,
    String searchQuery,
    String selectedRole,
    String selectedStatus,
    bool isFiltered,
  });
}

/// @nodoc
class __$$UserSyncingImplCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$UserSyncingImpl>
    implements _$$UserSyncingImplCopyWith<$Res> {
  __$$UserSyncingImplCopyWithImpl(
    _$UserSyncingImpl _value,
    $Res Function(_$UserSyncingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? filteredUsers = null,
    Object? searchQuery = null,
    Object? selectedRole = null,
    Object? selectedStatus = null,
    Object? isFiltered = null,
  }) {
    return _then(
      _$UserSyncingImpl(
        users: null == users
            ? _value._users
            : users // ignore: cast_nullable_to_non_nullable
                  as List<UserModel>,
        filteredUsers: null == filteredUsers
            ? _value._filteredUsers
            : filteredUsers // ignore: cast_nullable_to_non_nullable
                  as List<UserModel>,
        searchQuery: null == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedRole: null == selectedRole
            ? _value.selectedRole
            : selectedRole // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedStatus: null == selectedStatus
            ? _value.selectedStatus
            : selectedStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        isFiltered: null == isFiltered
            ? _value.isFiltered
            : isFiltered // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$UserSyncingImpl implements UserSyncing {
  const _$UserSyncingImpl({
    required final List<UserModel> users,
    required final List<UserModel> filteredUsers,
    this.searchQuery = '',
    this.selectedRole = 'all',
    this.selectedStatus = 'all',
    this.isFiltered = false,
  }) : _users = users,
       _filteredUsers = filteredUsers;

  final List<UserModel> _users;
  @override
  List<UserModel> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  final List<UserModel> _filteredUsers;
  @override
  List<UserModel> get filteredUsers {
    if (_filteredUsers is EqualUnmodifiableListView) return _filteredUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredUsers);
  }

  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final String selectedRole;
  @override
  @JsonKey()
  final String selectedStatus;
  @override
  @JsonKey()
  final bool isFiltered;

  @override
  String toString() {
    return 'UserState.syncing(users: $users, filteredUsers: $filteredUsers, searchQuery: $searchQuery, selectedRole: $selectedRole, selectedStatus: $selectedStatus, isFiltered: $isFiltered)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSyncingImpl &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            const DeepCollectionEquality().equals(
              other._filteredUsers,
              _filteredUsers,
            ) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.selectedRole, selectedRole) ||
                other.selectedRole == selectedRole) &&
            (identical(other.selectedStatus, selectedStatus) ||
                other.selectedStatus == selectedStatus) &&
            (identical(other.isFiltered, isFiltered) ||
                other.isFiltered == isFiltered));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_users),
    const DeepCollectionEquality().hash(_filteredUsers),
    searchQuery,
    selectedRole,
    selectedStatus,
    isFiltered,
  );

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSyncingImplCopyWith<_$UserSyncingImpl> get copyWith =>
      __$$UserSyncingImplCopyWithImpl<_$UserSyncingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )
    loaded,
    required TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      String operationType,
    )
    performingOperation,
    required TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )
    syncing,
    required TResult Function(
      String message,
      List<UserModel>? users,
      List<UserModel>? filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      bool canRetry,
      String? lastFailedOperation,
    )
    error,
  }) {
    return syncing(
      users,
      filteredUsers,
      searchQuery,
      selectedRole,
      selectedStatus,
      isFiltered,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    loaded,
    TResult? Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      String operationType,
    )?
    performingOperation,
    TResult? Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    syncing,
    TResult? Function(
      String message,
      List<UserModel>? users,
      List<UserModel>? filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      bool canRetry,
      String? lastFailedOperation,
    )?
    error,
  }) {
    return syncing?.call(
      users,
      filteredUsers,
      searchQuery,
      selectedRole,
      selectedStatus,
      isFiltered,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    loaded,
    TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      String operationType,
    )?
    performingOperation,
    TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    syncing,
    TResult Function(
      String message,
      List<UserModel>? users,
      List<UserModel>? filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      bool canRetry,
      String? lastFailedOperation,
    )?
    error,
    required TResult orElse(),
  }) {
    if (syncing != null) {
      return syncing(
        users,
        filteredUsers,
        searchQuery,
        selectedRole,
        selectedStatus,
        isFiltered,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserInitial value) initial,
    required TResult Function(UserLoading value) loading,
    required TResult Function(UserLoaded value) loaded,
    required TResult Function(UserPerformingOperation value)
    performingOperation,
    required TResult Function(UserSyncing value) syncing,
    required TResult Function(UserError value) error,
  }) {
    return syncing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserInitial value)? initial,
    TResult? Function(UserLoading value)? loading,
    TResult? Function(UserLoaded value)? loaded,
    TResult? Function(UserPerformingOperation value)? performingOperation,
    TResult? Function(UserSyncing value)? syncing,
    TResult? Function(UserError value)? error,
  }) {
    return syncing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserInitial value)? initial,
    TResult Function(UserLoading value)? loading,
    TResult Function(UserLoaded value)? loaded,
    TResult Function(UserPerformingOperation value)? performingOperation,
    TResult Function(UserSyncing value)? syncing,
    TResult Function(UserError value)? error,
    required TResult orElse(),
  }) {
    if (syncing != null) {
      return syncing(this);
    }
    return orElse();
  }
}

abstract class UserSyncing implements UserState {
  const factory UserSyncing({
    required final List<UserModel> users,
    required final List<UserModel> filteredUsers,
    final String searchQuery,
    final String selectedRole,
    final String selectedStatus,
    final bool isFiltered,
  }) = _$UserSyncingImpl;

  List<UserModel> get users;
  List<UserModel> get filteredUsers;
  String get searchQuery;
  String get selectedRole;
  String get selectedStatus;
  bool get isFiltered;

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSyncingImplCopyWith<_$UserSyncingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UserErrorImplCopyWith<$Res> {
  factory _$$UserErrorImplCopyWith(
    _$UserErrorImpl value,
    $Res Function(_$UserErrorImpl) then,
  ) = __$$UserErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String message,
    List<UserModel>? users,
    List<UserModel>? filteredUsers,
    String searchQuery,
    String selectedRole,
    String selectedStatus,
    bool isFiltered,
    bool canRetry,
    String? lastFailedOperation,
  });
}

/// @nodoc
class __$$UserErrorImplCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$UserErrorImpl>
    implements _$$UserErrorImplCopyWith<$Res> {
  __$$UserErrorImplCopyWithImpl(
    _$UserErrorImpl _value,
    $Res Function(_$UserErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? users = freezed,
    Object? filteredUsers = freezed,
    Object? searchQuery = null,
    Object? selectedRole = null,
    Object? selectedStatus = null,
    Object? isFiltered = null,
    Object? canRetry = null,
    Object? lastFailedOperation = freezed,
  }) {
    return _then(
      _$UserErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        users: freezed == users
            ? _value._users
            : users // ignore: cast_nullable_to_non_nullable
                  as List<UserModel>?,
        filteredUsers: freezed == filteredUsers
            ? _value._filteredUsers
            : filteredUsers // ignore: cast_nullable_to_non_nullable
                  as List<UserModel>?,
        searchQuery: null == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedRole: null == selectedRole
            ? _value.selectedRole
            : selectedRole // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedStatus: null == selectedStatus
            ? _value.selectedStatus
            : selectedStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        isFiltered: null == isFiltered
            ? _value.isFiltered
            : isFiltered // ignore: cast_nullable_to_non_nullable
                  as bool,
        canRetry: null == canRetry
            ? _value.canRetry
            : canRetry // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastFailedOperation: freezed == lastFailedOperation
            ? _value.lastFailedOperation
            : lastFailedOperation // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$UserErrorImpl implements UserError {
  const _$UserErrorImpl({
    required this.message,
    final List<UserModel>? users,
    final List<UserModel>? filteredUsers,
    this.searchQuery = '',
    this.selectedRole = 'all',
    this.selectedStatus = 'all',
    this.isFiltered = false,
    this.canRetry = false,
    this.lastFailedOperation,
  }) : _users = users,
       _filteredUsers = filteredUsers;

  @override
  final String message;
  final List<UserModel>? _users;
  @override
  List<UserModel>? get users {
    final value = _users;
    if (value == null) return null;
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<UserModel>? _filteredUsers;
  @override
  List<UserModel>? get filteredUsers {
    final value = _filteredUsers;
    if (value == null) return null;
    if (_filteredUsers is EqualUnmodifiableListView) return _filteredUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final String selectedRole;
  @override
  @JsonKey()
  final String selectedStatus;
  @override
  @JsonKey()
  final bool isFiltered;
  @override
  @JsonKey()
  final bool canRetry;
  @override
  final String? lastFailedOperation;

  @override
  String toString() {
    return 'UserState.error(message: $message, users: $users, filteredUsers: $filteredUsers, searchQuery: $searchQuery, selectedRole: $selectedRole, selectedStatus: $selectedStatus, isFiltered: $isFiltered, canRetry: $canRetry, lastFailedOperation: $lastFailedOperation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            const DeepCollectionEquality().equals(
              other._filteredUsers,
              _filteredUsers,
            ) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.selectedRole, selectedRole) ||
                other.selectedRole == selectedRole) &&
            (identical(other.selectedStatus, selectedStatus) ||
                other.selectedStatus == selectedStatus) &&
            (identical(other.isFiltered, isFiltered) ||
                other.isFiltered == isFiltered) &&
            (identical(other.canRetry, canRetry) ||
                other.canRetry == canRetry) &&
            (identical(other.lastFailedOperation, lastFailedOperation) ||
                other.lastFailedOperation == lastFailedOperation));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(_users),
    const DeepCollectionEquality().hash(_filteredUsers),
    searchQuery,
    selectedRole,
    selectedStatus,
    isFiltered,
    canRetry,
    lastFailedOperation,
  );

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserErrorImplCopyWith<_$UserErrorImpl> get copyWith =>
      __$$UserErrorImplCopyWithImpl<_$UserErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )
    loaded,
    required TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      String operationType,
    )
    performingOperation,
    required TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )
    syncing,
    required TResult Function(
      String message,
      List<UserModel>? users,
      List<UserModel>? filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      bool canRetry,
      String? lastFailedOperation,
    )
    error,
  }) {
    return error(
      message,
      users,
      filteredUsers,
      searchQuery,
      selectedRole,
      selectedStatus,
      isFiltered,
      canRetry,
      lastFailedOperation,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    loaded,
    TResult? Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      String operationType,
    )?
    performingOperation,
    TResult? Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    syncing,
    TResult? Function(
      String message,
      List<UserModel>? users,
      List<UserModel>? filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      bool canRetry,
      String? lastFailedOperation,
    )?
    error,
  }) {
    return error?.call(
      message,
      users,
      filteredUsers,
      searchQuery,
      selectedRole,
      selectedStatus,
      isFiltered,
      canRetry,
      lastFailedOperation,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    loaded,
    TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      String operationType,
    )?
    performingOperation,
    TResult Function(
      List<UserModel> users,
      List<UserModel> filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
    )?
    syncing,
    TResult Function(
      String message,
      List<UserModel>? users,
      List<UserModel>? filteredUsers,
      String searchQuery,
      String selectedRole,
      String selectedStatus,
      bool isFiltered,
      bool canRetry,
      String? lastFailedOperation,
    )?
    error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(
        message,
        users,
        filteredUsers,
        searchQuery,
        selectedRole,
        selectedStatus,
        isFiltered,
        canRetry,
        lastFailedOperation,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserInitial value) initial,
    required TResult Function(UserLoading value) loading,
    required TResult Function(UserLoaded value) loaded,
    required TResult Function(UserPerformingOperation value)
    performingOperation,
    required TResult Function(UserSyncing value) syncing,
    required TResult Function(UserError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserInitial value)? initial,
    TResult? Function(UserLoading value)? loading,
    TResult? Function(UserLoaded value)? loaded,
    TResult? Function(UserPerformingOperation value)? performingOperation,
    TResult? Function(UserSyncing value)? syncing,
    TResult? Function(UserError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserInitial value)? initial,
    TResult Function(UserLoading value)? loading,
    TResult Function(UserLoaded value)? loaded,
    TResult Function(UserPerformingOperation value)? performingOperation,
    TResult Function(UserSyncing value)? syncing,
    TResult Function(UserError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class UserError implements UserState {
  const factory UserError({
    required final String message,
    final List<UserModel>? users,
    final List<UserModel>? filteredUsers,
    final String searchQuery,
    final String selectedRole,
    final String selectedStatus,
    final bool isFiltered,
    final bool canRetry,
    final String? lastFailedOperation,
  }) = _$UserErrorImpl;

  String get message;
  List<UserModel>? get users;
  List<UserModel>? get filteredUsers;
  String get searchQuery;
  String get selectedRole;
  String get selectedStatus;
  bool get isFiltered;
  bool get canRetry;
  String? get lastFailedOperation;

  /// Create a copy of UserState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserErrorImplCopyWith<_$UserErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
