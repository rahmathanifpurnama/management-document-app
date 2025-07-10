// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UserEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadUsers,
    required TResult Function(bool clearFilters) refreshUsers,
    required TResult Function(String query) searchUsers,
    required TResult Function(String role) filterByRole,
    required TResult Function(String status) filterByStatus,
    required TResult Function() clearFilters,
    required TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )
    createUser,
    required TResult Function(UserModel user, String updatedBy) updateUser,
    required TResult Function(String userId, String status, String updatedBy)
    updateUserStatus,
    required TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )
    updateUserPermissions,
    required TResult Function(String userId, String deletedBy) deleteUser,
    required TResult Function(bool silent) syncFirebaseAuthUsers,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadUsers,
    TResult? Function(bool clearFilters)? refreshUsers,
    TResult? Function(String query)? searchUsers,
    TResult? Function(String role)? filterByRole,
    TResult? Function(String status)? filterByStatus,
    TResult? Function()? clearFilters,
    TResult? Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult? Function(UserModel user, String updatedBy)? updateUser,
    TResult? Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult? Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult? Function(String userId, String deletedBy)? deleteUser,
    TResult? Function(bool silent)? syncFirebaseAuthUsers,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadUsers,
    TResult Function(bool clearFilters)? refreshUsers,
    TResult Function(String query)? searchUsers,
    TResult Function(String role)? filterByRole,
    TResult Function(String status)? filterByStatus,
    TResult Function()? clearFilters,
    TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult Function(UserModel user, String updatedBy)? updateUser,
    TResult Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult Function(String userId, String deletedBy)? deleteUser,
    TResult Function(bool silent)? syncFirebaseAuthUsers,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadUsers value) loadUsers,
    required TResult Function(RefreshUsers value) refreshUsers,
    required TResult Function(SearchUsers value) searchUsers,
    required TResult Function(FilterByRole value) filterByRole,
    required TResult Function(FilterByStatus value) filterByStatus,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(CreateUser value) createUser,
    required TResult Function(UpdateUser value) updateUser,
    required TResult Function(UpdateUserStatus value) updateUserStatus,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(DeleteUser value) deleteUser,
    required TResult Function(SyncFirebaseAuthUsers value)
    syncFirebaseAuthUsers,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadUsers value)? loadUsers,
    TResult? Function(RefreshUsers value)? refreshUsers,
    TResult? Function(SearchUsers value)? searchUsers,
    TResult? Function(FilterByRole value)? filterByRole,
    TResult? Function(FilterByStatus value)? filterByStatus,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(CreateUser value)? createUser,
    TResult? Function(UpdateUser value)? updateUser,
    TResult? Function(UpdateUserStatus value)? updateUserStatus,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(DeleteUser value)? deleteUser,
    TResult? Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadUsers value)? loadUsers,
    TResult Function(RefreshUsers value)? refreshUsers,
    TResult Function(SearchUsers value)? searchUsers,
    TResult Function(FilterByRole value)? filterByRole,
    TResult Function(FilterByStatus value)? filterByStatus,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(CreateUser value)? createUser,
    TResult Function(UpdateUser value)? updateUser,
    TResult Function(UpdateUserStatus value)? updateUserStatus,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(DeleteUser value)? deleteUser,
    TResult Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserEventCopyWith<$Res> {
  factory $UserEventCopyWith(UserEvent value, $Res Function(UserEvent) then) =
      _$UserEventCopyWithImpl<$Res, UserEvent>;
}

/// @nodoc
class _$UserEventCopyWithImpl<$Res, $Val extends UserEvent>
    implements $UserEventCopyWith<$Res> {
  _$UserEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadUsersImplCopyWith<$Res> {
  factory _$$LoadUsersImplCopyWith(
    _$LoadUsersImpl value,
    $Res Function(_$LoadUsersImpl) then,
  ) = __$$LoadUsersImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadUsersImplCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$LoadUsersImpl>
    implements _$$LoadUsersImplCopyWith<$Res> {
  __$$LoadUsersImplCopyWithImpl(
    _$LoadUsersImpl _value,
    $Res Function(_$LoadUsersImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadUsersImpl implements LoadUsers {
  const _$LoadUsersImpl();

  @override
  String toString() {
    return 'UserEvent.loadUsers()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadUsersImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadUsers,
    required TResult Function(bool clearFilters) refreshUsers,
    required TResult Function(String query) searchUsers,
    required TResult Function(String role) filterByRole,
    required TResult Function(String status) filterByStatus,
    required TResult Function() clearFilters,
    required TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )
    createUser,
    required TResult Function(UserModel user, String updatedBy) updateUser,
    required TResult Function(String userId, String status, String updatedBy)
    updateUserStatus,
    required TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )
    updateUserPermissions,
    required TResult Function(String userId, String deletedBy) deleteUser,
    required TResult Function(bool silent) syncFirebaseAuthUsers,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
  }) {
    return loadUsers();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadUsers,
    TResult? Function(bool clearFilters)? refreshUsers,
    TResult? Function(String query)? searchUsers,
    TResult? Function(String role)? filterByRole,
    TResult? Function(String status)? filterByStatus,
    TResult? Function()? clearFilters,
    TResult? Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult? Function(UserModel user, String updatedBy)? updateUser,
    TResult? Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult? Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult? Function(String userId, String deletedBy)? deleteUser,
    TResult? Function(bool silent)? syncFirebaseAuthUsers,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
  }) {
    return loadUsers?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadUsers,
    TResult Function(bool clearFilters)? refreshUsers,
    TResult Function(String query)? searchUsers,
    TResult Function(String role)? filterByRole,
    TResult Function(String status)? filterByStatus,
    TResult Function()? clearFilters,
    TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult Function(UserModel user, String updatedBy)? updateUser,
    TResult Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult Function(String userId, String deletedBy)? deleteUser,
    TResult Function(bool silent)? syncFirebaseAuthUsers,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    required TResult orElse(),
  }) {
    if (loadUsers != null) {
      return loadUsers();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadUsers value) loadUsers,
    required TResult Function(RefreshUsers value) refreshUsers,
    required TResult Function(SearchUsers value) searchUsers,
    required TResult Function(FilterByRole value) filterByRole,
    required TResult Function(FilterByStatus value) filterByStatus,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(CreateUser value) createUser,
    required TResult Function(UpdateUser value) updateUser,
    required TResult Function(UpdateUserStatus value) updateUserStatus,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(DeleteUser value) deleteUser,
    required TResult Function(SyncFirebaseAuthUsers value)
    syncFirebaseAuthUsers,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
  }) {
    return loadUsers(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadUsers value)? loadUsers,
    TResult? Function(RefreshUsers value)? refreshUsers,
    TResult? Function(SearchUsers value)? searchUsers,
    TResult? Function(FilterByRole value)? filterByRole,
    TResult? Function(FilterByStatus value)? filterByStatus,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(CreateUser value)? createUser,
    TResult? Function(UpdateUser value)? updateUser,
    TResult? Function(UpdateUserStatus value)? updateUserStatus,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(DeleteUser value)? deleteUser,
    TResult? Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
  }) {
    return loadUsers?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadUsers value)? loadUsers,
    TResult Function(RefreshUsers value)? refreshUsers,
    TResult Function(SearchUsers value)? searchUsers,
    TResult Function(FilterByRole value)? filterByRole,
    TResult Function(FilterByStatus value)? filterByStatus,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(CreateUser value)? createUser,
    TResult Function(UpdateUser value)? updateUser,
    TResult Function(UpdateUserStatus value)? updateUserStatus,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(DeleteUser value)? deleteUser,
    TResult Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    required TResult orElse(),
  }) {
    if (loadUsers != null) {
      return loadUsers(this);
    }
    return orElse();
  }
}

abstract class LoadUsers implements UserEvent {
  const factory LoadUsers() = _$LoadUsersImpl;
}

/// @nodoc
abstract class _$$RefreshUsersImplCopyWith<$Res> {
  factory _$$RefreshUsersImplCopyWith(
    _$RefreshUsersImpl value,
    $Res Function(_$RefreshUsersImpl) then,
  ) = __$$RefreshUsersImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool clearFilters});
}

/// @nodoc
class __$$RefreshUsersImplCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$RefreshUsersImpl>
    implements _$$RefreshUsersImplCopyWith<$Res> {
  __$$RefreshUsersImplCopyWithImpl(
    _$RefreshUsersImpl _value,
    $Res Function(_$RefreshUsersImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? clearFilters = null}) {
    return _then(
      _$RefreshUsersImpl(
        clearFilters: null == clearFilters
            ? _value.clearFilters
            : clearFilters // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$RefreshUsersImpl implements RefreshUsers {
  const _$RefreshUsersImpl({this.clearFilters = false});

  @override
  @JsonKey()
  final bool clearFilters;

  @override
  String toString() {
    return 'UserEvent.refreshUsers(clearFilters: $clearFilters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefreshUsersImpl &&
            (identical(other.clearFilters, clearFilters) ||
                other.clearFilters == clearFilters));
  }

  @override
  int get hashCode => Object.hash(runtimeType, clearFilters);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefreshUsersImplCopyWith<_$RefreshUsersImpl> get copyWith =>
      __$$RefreshUsersImplCopyWithImpl<_$RefreshUsersImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadUsers,
    required TResult Function(bool clearFilters) refreshUsers,
    required TResult Function(String query) searchUsers,
    required TResult Function(String role) filterByRole,
    required TResult Function(String status) filterByStatus,
    required TResult Function() clearFilters,
    required TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )
    createUser,
    required TResult Function(UserModel user, String updatedBy) updateUser,
    required TResult Function(String userId, String status, String updatedBy)
    updateUserStatus,
    required TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )
    updateUserPermissions,
    required TResult Function(String userId, String deletedBy) deleteUser,
    required TResult Function(bool silent) syncFirebaseAuthUsers,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
  }) {
    return refreshUsers(this.clearFilters);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadUsers,
    TResult? Function(bool clearFilters)? refreshUsers,
    TResult? Function(String query)? searchUsers,
    TResult? Function(String role)? filterByRole,
    TResult? Function(String status)? filterByStatus,
    TResult? Function()? clearFilters,
    TResult? Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult? Function(UserModel user, String updatedBy)? updateUser,
    TResult? Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult? Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult? Function(String userId, String deletedBy)? deleteUser,
    TResult? Function(bool silent)? syncFirebaseAuthUsers,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
  }) {
    return refreshUsers?.call(this.clearFilters);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadUsers,
    TResult Function(bool clearFilters)? refreshUsers,
    TResult Function(String query)? searchUsers,
    TResult Function(String role)? filterByRole,
    TResult Function(String status)? filterByStatus,
    TResult Function()? clearFilters,
    TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult Function(UserModel user, String updatedBy)? updateUser,
    TResult Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult Function(String userId, String deletedBy)? deleteUser,
    TResult Function(bool silent)? syncFirebaseAuthUsers,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    required TResult orElse(),
  }) {
    if (refreshUsers != null) {
      return refreshUsers(this.clearFilters);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadUsers value) loadUsers,
    required TResult Function(RefreshUsers value) refreshUsers,
    required TResult Function(SearchUsers value) searchUsers,
    required TResult Function(FilterByRole value) filterByRole,
    required TResult Function(FilterByStatus value) filterByStatus,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(CreateUser value) createUser,
    required TResult Function(UpdateUser value) updateUser,
    required TResult Function(UpdateUserStatus value) updateUserStatus,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(DeleteUser value) deleteUser,
    required TResult Function(SyncFirebaseAuthUsers value)
    syncFirebaseAuthUsers,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
  }) {
    return refreshUsers(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadUsers value)? loadUsers,
    TResult? Function(RefreshUsers value)? refreshUsers,
    TResult? Function(SearchUsers value)? searchUsers,
    TResult? Function(FilterByRole value)? filterByRole,
    TResult? Function(FilterByStatus value)? filterByStatus,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(CreateUser value)? createUser,
    TResult? Function(UpdateUser value)? updateUser,
    TResult? Function(UpdateUserStatus value)? updateUserStatus,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(DeleteUser value)? deleteUser,
    TResult? Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
  }) {
    return refreshUsers?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadUsers value)? loadUsers,
    TResult Function(RefreshUsers value)? refreshUsers,
    TResult Function(SearchUsers value)? searchUsers,
    TResult Function(FilterByRole value)? filterByRole,
    TResult Function(FilterByStatus value)? filterByStatus,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(CreateUser value)? createUser,
    TResult Function(UpdateUser value)? updateUser,
    TResult Function(UpdateUserStatus value)? updateUserStatus,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(DeleteUser value)? deleteUser,
    TResult Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    required TResult orElse(),
  }) {
    if (refreshUsers != null) {
      return refreshUsers(this);
    }
    return orElse();
  }
}

abstract class RefreshUsers implements UserEvent {
  const factory RefreshUsers({final bool clearFilters}) = _$RefreshUsersImpl;

  bool get clearFilters;

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefreshUsersImplCopyWith<_$RefreshUsersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SearchUsersImplCopyWith<$Res> {
  factory _$$SearchUsersImplCopyWith(
    _$SearchUsersImpl value,
    $Res Function(_$SearchUsersImpl) then,
  ) = __$$SearchUsersImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String query});
}

/// @nodoc
class __$$SearchUsersImplCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$SearchUsersImpl>
    implements _$$SearchUsersImplCopyWith<$Res> {
  __$$SearchUsersImplCopyWithImpl(
    _$SearchUsersImpl _value,
    $Res Function(_$SearchUsersImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? query = null}) {
    return _then(
      _$SearchUsersImpl(
        null == query
            ? _value.query
            : query // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SearchUsersImpl implements SearchUsers {
  const _$SearchUsersImpl(this.query);

  @override
  final String query;

  @override
  String toString() {
    return 'UserEvent.searchUsers(query: $query)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchUsersImpl &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(runtimeType, query);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchUsersImplCopyWith<_$SearchUsersImpl> get copyWith =>
      __$$SearchUsersImplCopyWithImpl<_$SearchUsersImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadUsers,
    required TResult Function(bool clearFilters) refreshUsers,
    required TResult Function(String query) searchUsers,
    required TResult Function(String role) filterByRole,
    required TResult Function(String status) filterByStatus,
    required TResult Function() clearFilters,
    required TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )
    createUser,
    required TResult Function(UserModel user, String updatedBy) updateUser,
    required TResult Function(String userId, String status, String updatedBy)
    updateUserStatus,
    required TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )
    updateUserPermissions,
    required TResult Function(String userId, String deletedBy) deleteUser,
    required TResult Function(bool silent) syncFirebaseAuthUsers,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
  }) {
    return searchUsers(query);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadUsers,
    TResult? Function(bool clearFilters)? refreshUsers,
    TResult? Function(String query)? searchUsers,
    TResult? Function(String role)? filterByRole,
    TResult? Function(String status)? filterByStatus,
    TResult? Function()? clearFilters,
    TResult? Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult? Function(UserModel user, String updatedBy)? updateUser,
    TResult? Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult? Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult? Function(String userId, String deletedBy)? deleteUser,
    TResult? Function(bool silent)? syncFirebaseAuthUsers,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
  }) {
    return searchUsers?.call(query);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadUsers,
    TResult Function(bool clearFilters)? refreshUsers,
    TResult Function(String query)? searchUsers,
    TResult Function(String role)? filterByRole,
    TResult Function(String status)? filterByStatus,
    TResult Function()? clearFilters,
    TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult Function(UserModel user, String updatedBy)? updateUser,
    TResult Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult Function(String userId, String deletedBy)? deleteUser,
    TResult Function(bool silent)? syncFirebaseAuthUsers,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    required TResult orElse(),
  }) {
    if (searchUsers != null) {
      return searchUsers(query);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadUsers value) loadUsers,
    required TResult Function(RefreshUsers value) refreshUsers,
    required TResult Function(SearchUsers value) searchUsers,
    required TResult Function(FilterByRole value) filterByRole,
    required TResult Function(FilterByStatus value) filterByStatus,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(CreateUser value) createUser,
    required TResult Function(UpdateUser value) updateUser,
    required TResult Function(UpdateUserStatus value) updateUserStatus,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(DeleteUser value) deleteUser,
    required TResult Function(SyncFirebaseAuthUsers value)
    syncFirebaseAuthUsers,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
  }) {
    return searchUsers(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadUsers value)? loadUsers,
    TResult? Function(RefreshUsers value)? refreshUsers,
    TResult? Function(SearchUsers value)? searchUsers,
    TResult? Function(FilterByRole value)? filterByRole,
    TResult? Function(FilterByStatus value)? filterByStatus,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(CreateUser value)? createUser,
    TResult? Function(UpdateUser value)? updateUser,
    TResult? Function(UpdateUserStatus value)? updateUserStatus,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(DeleteUser value)? deleteUser,
    TResult? Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
  }) {
    return searchUsers?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadUsers value)? loadUsers,
    TResult Function(RefreshUsers value)? refreshUsers,
    TResult Function(SearchUsers value)? searchUsers,
    TResult Function(FilterByRole value)? filterByRole,
    TResult Function(FilterByStatus value)? filterByStatus,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(CreateUser value)? createUser,
    TResult Function(UpdateUser value)? updateUser,
    TResult Function(UpdateUserStatus value)? updateUserStatus,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(DeleteUser value)? deleteUser,
    TResult Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    required TResult orElse(),
  }) {
    if (searchUsers != null) {
      return searchUsers(this);
    }
    return orElse();
  }
}

abstract class SearchUsers implements UserEvent {
  const factory SearchUsers(final String query) = _$SearchUsersImpl;

  String get query;

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchUsersImplCopyWith<_$SearchUsersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FilterByRoleImplCopyWith<$Res> {
  factory _$$FilterByRoleImplCopyWith(
    _$FilterByRoleImpl value,
    $Res Function(_$FilterByRoleImpl) then,
  ) = __$$FilterByRoleImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String role});
}

/// @nodoc
class __$$FilterByRoleImplCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$FilterByRoleImpl>
    implements _$$FilterByRoleImplCopyWith<$Res> {
  __$$FilterByRoleImplCopyWithImpl(
    _$FilterByRoleImpl _value,
    $Res Function(_$FilterByRoleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? role = null}) {
    return _then(
      _$FilterByRoleImpl(
        null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$FilterByRoleImpl implements FilterByRole {
  const _$FilterByRoleImpl(this.role);

  @override
  final String role;

  @override
  String toString() {
    return 'UserEvent.filterByRole(role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterByRoleImpl &&
            (identical(other.role, role) || other.role == role));
  }

  @override
  int get hashCode => Object.hash(runtimeType, role);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterByRoleImplCopyWith<_$FilterByRoleImpl> get copyWith =>
      __$$FilterByRoleImplCopyWithImpl<_$FilterByRoleImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadUsers,
    required TResult Function(bool clearFilters) refreshUsers,
    required TResult Function(String query) searchUsers,
    required TResult Function(String role) filterByRole,
    required TResult Function(String status) filterByStatus,
    required TResult Function() clearFilters,
    required TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )
    createUser,
    required TResult Function(UserModel user, String updatedBy) updateUser,
    required TResult Function(String userId, String status, String updatedBy)
    updateUserStatus,
    required TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )
    updateUserPermissions,
    required TResult Function(String userId, String deletedBy) deleteUser,
    required TResult Function(bool silent) syncFirebaseAuthUsers,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
  }) {
    return filterByRole(role);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadUsers,
    TResult? Function(bool clearFilters)? refreshUsers,
    TResult? Function(String query)? searchUsers,
    TResult? Function(String role)? filterByRole,
    TResult? Function(String status)? filterByStatus,
    TResult? Function()? clearFilters,
    TResult? Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult? Function(UserModel user, String updatedBy)? updateUser,
    TResult? Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult? Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult? Function(String userId, String deletedBy)? deleteUser,
    TResult? Function(bool silent)? syncFirebaseAuthUsers,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
  }) {
    return filterByRole?.call(role);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadUsers,
    TResult Function(bool clearFilters)? refreshUsers,
    TResult Function(String query)? searchUsers,
    TResult Function(String role)? filterByRole,
    TResult Function(String status)? filterByStatus,
    TResult Function()? clearFilters,
    TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult Function(UserModel user, String updatedBy)? updateUser,
    TResult Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult Function(String userId, String deletedBy)? deleteUser,
    TResult Function(bool silent)? syncFirebaseAuthUsers,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    required TResult orElse(),
  }) {
    if (filterByRole != null) {
      return filterByRole(role);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadUsers value) loadUsers,
    required TResult Function(RefreshUsers value) refreshUsers,
    required TResult Function(SearchUsers value) searchUsers,
    required TResult Function(FilterByRole value) filterByRole,
    required TResult Function(FilterByStatus value) filterByStatus,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(CreateUser value) createUser,
    required TResult Function(UpdateUser value) updateUser,
    required TResult Function(UpdateUserStatus value) updateUserStatus,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(DeleteUser value) deleteUser,
    required TResult Function(SyncFirebaseAuthUsers value)
    syncFirebaseAuthUsers,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
  }) {
    return filterByRole(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadUsers value)? loadUsers,
    TResult? Function(RefreshUsers value)? refreshUsers,
    TResult? Function(SearchUsers value)? searchUsers,
    TResult? Function(FilterByRole value)? filterByRole,
    TResult? Function(FilterByStatus value)? filterByStatus,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(CreateUser value)? createUser,
    TResult? Function(UpdateUser value)? updateUser,
    TResult? Function(UpdateUserStatus value)? updateUserStatus,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(DeleteUser value)? deleteUser,
    TResult? Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
  }) {
    return filterByRole?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadUsers value)? loadUsers,
    TResult Function(RefreshUsers value)? refreshUsers,
    TResult Function(SearchUsers value)? searchUsers,
    TResult Function(FilterByRole value)? filterByRole,
    TResult Function(FilterByStatus value)? filterByStatus,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(CreateUser value)? createUser,
    TResult Function(UpdateUser value)? updateUser,
    TResult Function(UpdateUserStatus value)? updateUserStatus,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(DeleteUser value)? deleteUser,
    TResult Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    required TResult orElse(),
  }) {
    if (filterByRole != null) {
      return filterByRole(this);
    }
    return orElse();
  }
}

abstract class FilterByRole implements UserEvent {
  const factory FilterByRole(final String role) = _$FilterByRoleImpl;

  String get role;

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FilterByRoleImplCopyWith<_$FilterByRoleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FilterByStatusImplCopyWith<$Res> {
  factory _$$FilterByStatusImplCopyWith(
    _$FilterByStatusImpl value,
    $Res Function(_$FilterByStatusImpl) then,
  ) = __$$FilterByStatusImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String status});
}

/// @nodoc
class __$$FilterByStatusImplCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$FilterByStatusImpl>
    implements _$$FilterByStatusImplCopyWith<$Res> {
  __$$FilterByStatusImplCopyWithImpl(
    _$FilterByStatusImpl _value,
    $Res Function(_$FilterByStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null}) {
    return _then(
      _$FilterByStatusImpl(
        null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$FilterByStatusImpl implements FilterByStatus {
  const _$FilterByStatusImpl(this.status);

  @override
  final String status;

  @override
  String toString() {
    return 'UserEvent.filterByStatus(status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterByStatusImpl &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterByStatusImplCopyWith<_$FilterByStatusImpl> get copyWith =>
      __$$FilterByStatusImplCopyWithImpl<_$FilterByStatusImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadUsers,
    required TResult Function(bool clearFilters) refreshUsers,
    required TResult Function(String query) searchUsers,
    required TResult Function(String role) filterByRole,
    required TResult Function(String status) filterByStatus,
    required TResult Function() clearFilters,
    required TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )
    createUser,
    required TResult Function(UserModel user, String updatedBy) updateUser,
    required TResult Function(String userId, String status, String updatedBy)
    updateUserStatus,
    required TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )
    updateUserPermissions,
    required TResult Function(String userId, String deletedBy) deleteUser,
    required TResult Function(bool silent) syncFirebaseAuthUsers,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
  }) {
    return filterByStatus(status);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadUsers,
    TResult? Function(bool clearFilters)? refreshUsers,
    TResult? Function(String query)? searchUsers,
    TResult? Function(String role)? filterByRole,
    TResult? Function(String status)? filterByStatus,
    TResult? Function()? clearFilters,
    TResult? Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult? Function(UserModel user, String updatedBy)? updateUser,
    TResult? Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult? Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult? Function(String userId, String deletedBy)? deleteUser,
    TResult? Function(bool silent)? syncFirebaseAuthUsers,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
  }) {
    return filterByStatus?.call(status);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadUsers,
    TResult Function(bool clearFilters)? refreshUsers,
    TResult Function(String query)? searchUsers,
    TResult Function(String role)? filterByRole,
    TResult Function(String status)? filterByStatus,
    TResult Function()? clearFilters,
    TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult Function(UserModel user, String updatedBy)? updateUser,
    TResult Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult Function(String userId, String deletedBy)? deleteUser,
    TResult Function(bool silent)? syncFirebaseAuthUsers,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    required TResult orElse(),
  }) {
    if (filterByStatus != null) {
      return filterByStatus(status);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadUsers value) loadUsers,
    required TResult Function(RefreshUsers value) refreshUsers,
    required TResult Function(SearchUsers value) searchUsers,
    required TResult Function(FilterByRole value) filterByRole,
    required TResult Function(FilterByStatus value) filterByStatus,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(CreateUser value) createUser,
    required TResult Function(UpdateUser value) updateUser,
    required TResult Function(UpdateUserStatus value) updateUserStatus,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(DeleteUser value) deleteUser,
    required TResult Function(SyncFirebaseAuthUsers value)
    syncFirebaseAuthUsers,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
  }) {
    return filterByStatus(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadUsers value)? loadUsers,
    TResult? Function(RefreshUsers value)? refreshUsers,
    TResult? Function(SearchUsers value)? searchUsers,
    TResult? Function(FilterByRole value)? filterByRole,
    TResult? Function(FilterByStatus value)? filterByStatus,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(CreateUser value)? createUser,
    TResult? Function(UpdateUser value)? updateUser,
    TResult? Function(UpdateUserStatus value)? updateUserStatus,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(DeleteUser value)? deleteUser,
    TResult? Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
  }) {
    return filterByStatus?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadUsers value)? loadUsers,
    TResult Function(RefreshUsers value)? refreshUsers,
    TResult Function(SearchUsers value)? searchUsers,
    TResult Function(FilterByRole value)? filterByRole,
    TResult Function(FilterByStatus value)? filterByStatus,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(CreateUser value)? createUser,
    TResult Function(UpdateUser value)? updateUser,
    TResult Function(UpdateUserStatus value)? updateUserStatus,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(DeleteUser value)? deleteUser,
    TResult Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    required TResult orElse(),
  }) {
    if (filterByStatus != null) {
      return filterByStatus(this);
    }
    return orElse();
  }
}

abstract class FilterByStatus implements UserEvent {
  const factory FilterByStatus(final String status) = _$FilterByStatusImpl;

  String get status;

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FilterByStatusImplCopyWith<_$FilterByStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ClearFiltersImplCopyWith<$Res> {
  factory _$$ClearFiltersImplCopyWith(
    _$ClearFiltersImpl value,
    $Res Function(_$ClearFiltersImpl) then,
  ) = __$$ClearFiltersImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ClearFiltersImplCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$ClearFiltersImpl>
    implements _$$ClearFiltersImplCopyWith<$Res> {
  __$$ClearFiltersImplCopyWithImpl(
    _$ClearFiltersImpl _value,
    $Res Function(_$ClearFiltersImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ClearFiltersImpl implements ClearFilters {
  const _$ClearFiltersImpl();

  @override
  String toString() {
    return 'UserEvent.clearFilters()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ClearFiltersImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadUsers,
    required TResult Function(bool clearFilters) refreshUsers,
    required TResult Function(String query) searchUsers,
    required TResult Function(String role) filterByRole,
    required TResult Function(String status) filterByStatus,
    required TResult Function() clearFilters,
    required TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )
    createUser,
    required TResult Function(UserModel user, String updatedBy) updateUser,
    required TResult Function(String userId, String status, String updatedBy)
    updateUserStatus,
    required TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )
    updateUserPermissions,
    required TResult Function(String userId, String deletedBy) deleteUser,
    required TResult Function(bool silent) syncFirebaseAuthUsers,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
  }) {
    return clearFilters();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadUsers,
    TResult? Function(bool clearFilters)? refreshUsers,
    TResult? Function(String query)? searchUsers,
    TResult? Function(String role)? filterByRole,
    TResult? Function(String status)? filterByStatus,
    TResult? Function()? clearFilters,
    TResult? Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult? Function(UserModel user, String updatedBy)? updateUser,
    TResult? Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult? Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult? Function(String userId, String deletedBy)? deleteUser,
    TResult? Function(bool silent)? syncFirebaseAuthUsers,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
  }) {
    return clearFilters?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadUsers,
    TResult Function(bool clearFilters)? refreshUsers,
    TResult Function(String query)? searchUsers,
    TResult Function(String role)? filterByRole,
    TResult Function(String status)? filterByStatus,
    TResult Function()? clearFilters,
    TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult Function(UserModel user, String updatedBy)? updateUser,
    TResult Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult Function(String userId, String deletedBy)? deleteUser,
    TResult Function(bool silent)? syncFirebaseAuthUsers,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    required TResult orElse(),
  }) {
    if (clearFilters != null) {
      return clearFilters();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadUsers value) loadUsers,
    required TResult Function(RefreshUsers value) refreshUsers,
    required TResult Function(SearchUsers value) searchUsers,
    required TResult Function(FilterByRole value) filterByRole,
    required TResult Function(FilterByStatus value) filterByStatus,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(CreateUser value) createUser,
    required TResult Function(UpdateUser value) updateUser,
    required TResult Function(UpdateUserStatus value) updateUserStatus,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(DeleteUser value) deleteUser,
    required TResult Function(SyncFirebaseAuthUsers value)
    syncFirebaseAuthUsers,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
  }) {
    return clearFilters(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadUsers value)? loadUsers,
    TResult? Function(RefreshUsers value)? refreshUsers,
    TResult? Function(SearchUsers value)? searchUsers,
    TResult? Function(FilterByRole value)? filterByRole,
    TResult? Function(FilterByStatus value)? filterByStatus,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(CreateUser value)? createUser,
    TResult? Function(UpdateUser value)? updateUser,
    TResult? Function(UpdateUserStatus value)? updateUserStatus,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(DeleteUser value)? deleteUser,
    TResult? Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
  }) {
    return clearFilters?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadUsers value)? loadUsers,
    TResult Function(RefreshUsers value)? refreshUsers,
    TResult Function(SearchUsers value)? searchUsers,
    TResult Function(FilterByRole value)? filterByRole,
    TResult Function(FilterByStatus value)? filterByStatus,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(CreateUser value)? createUser,
    TResult Function(UpdateUser value)? updateUser,
    TResult Function(UpdateUserStatus value)? updateUserStatus,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(DeleteUser value)? deleteUser,
    TResult Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    required TResult orElse(),
  }) {
    if (clearFilters != null) {
      return clearFilters(this);
    }
    return orElse();
  }
}

abstract class ClearFilters implements UserEvent {
  const factory ClearFilters() = _$ClearFiltersImpl;
}

/// @nodoc
abstract class _$$CreateUserImplCopyWith<$Res> {
  factory _$$CreateUserImplCopyWith(
    _$CreateUserImpl value,
    $Res Function(_$CreateUserImpl) then,
  ) = __$$CreateUserImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String fullName,
    String email,
    String password,
    String role,
    String createdBy,
    UserPermissions? permissions,
  });
}

/// @nodoc
class __$$CreateUserImplCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$CreateUserImpl>
    implements _$$CreateUserImplCopyWith<$Res> {
  __$$CreateUserImplCopyWithImpl(
    _$CreateUserImpl _value,
    $Res Function(_$CreateUserImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? email = null,
    Object? password = null,
    Object? role = null,
    Object? createdBy = null,
    Object? permissions = freezed,
  }) {
    return _then(
      _$CreateUserImpl(
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        createdBy: null == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String,
        permissions: freezed == permissions
            ? _value.permissions
            : permissions // ignore: cast_nullable_to_non_nullable
                  as UserPermissions?,
      ),
    );
  }
}

/// @nodoc

class _$CreateUserImpl implements CreateUser {
  const _$CreateUserImpl({
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
    required this.createdBy,
    this.permissions,
  });

  @override
  final String fullName;
  @override
  final String email;
  @override
  final String password;
  @override
  final String role;
  @override
  final String createdBy;
  @override
  final UserPermissions? permissions;

  @override
  String toString() {
    return 'UserEvent.createUser(fullName: $fullName, email: $email, password: $password, role: $role, createdBy: $createdBy, permissions: $permissions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateUserImpl &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.permissions, permissions) ||
                other.permissions == permissions));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    fullName,
    email,
    password,
    role,
    createdBy,
    permissions,
  );

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateUserImplCopyWith<_$CreateUserImpl> get copyWith =>
      __$$CreateUserImplCopyWithImpl<_$CreateUserImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadUsers,
    required TResult Function(bool clearFilters) refreshUsers,
    required TResult Function(String query) searchUsers,
    required TResult Function(String role) filterByRole,
    required TResult Function(String status) filterByStatus,
    required TResult Function() clearFilters,
    required TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )
    createUser,
    required TResult Function(UserModel user, String updatedBy) updateUser,
    required TResult Function(String userId, String status, String updatedBy)
    updateUserStatus,
    required TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )
    updateUserPermissions,
    required TResult Function(String userId, String deletedBy) deleteUser,
    required TResult Function(bool silent) syncFirebaseAuthUsers,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
  }) {
    return createUser(fullName, email, password, role, createdBy, permissions);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadUsers,
    TResult? Function(bool clearFilters)? refreshUsers,
    TResult? Function(String query)? searchUsers,
    TResult? Function(String role)? filterByRole,
    TResult? Function(String status)? filterByStatus,
    TResult? Function()? clearFilters,
    TResult? Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult? Function(UserModel user, String updatedBy)? updateUser,
    TResult? Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult? Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult? Function(String userId, String deletedBy)? deleteUser,
    TResult? Function(bool silent)? syncFirebaseAuthUsers,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
  }) {
    return createUser?.call(
      fullName,
      email,
      password,
      role,
      createdBy,
      permissions,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadUsers,
    TResult Function(bool clearFilters)? refreshUsers,
    TResult Function(String query)? searchUsers,
    TResult Function(String role)? filterByRole,
    TResult Function(String status)? filterByStatus,
    TResult Function()? clearFilters,
    TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult Function(UserModel user, String updatedBy)? updateUser,
    TResult Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult Function(String userId, String deletedBy)? deleteUser,
    TResult Function(bool silent)? syncFirebaseAuthUsers,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    required TResult orElse(),
  }) {
    if (createUser != null) {
      return createUser(
        fullName,
        email,
        password,
        role,
        createdBy,
        permissions,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadUsers value) loadUsers,
    required TResult Function(RefreshUsers value) refreshUsers,
    required TResult Function(SearchUsers value) searchUsers,
    required TResult Function(FilterByRole value) filterByRole,
    required TResult Function(FilterByStatus value) filterByStatus,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(CreateUser value) createUser,
    required TResult Function(UpdateUser value) updateUser,
    required TResult Function(UpdateUserStatus value) updateUserStatus,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(DeleteUser value) deleteUser,
    required TResult Function(SyncFirebaseAuthUsers value)
    syncFirebaseAuthUsers,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
  }) {
    return createUser(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadUsers value)? loadUsers,
    TResult? Function(RefreshUsers value)? refreshUsers,
    TResult? Function(SearchUsers value)? searchUsers,
    TResult? Function(FilterByRole value)? filterByRole,
    TResult? Function(FilterByStatus value)? filterByStatus,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(CreateUser value)? createUser,
    TResult? Function(UpdateUser value)? updateUser,
    TResult? Function(UpdateUserStatus value)? updateUserStatus,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(DeleteUser value)? deleteUser,
    TResult? Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
  }) {
    return createUser?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadUsers value)? loadUsers,
    TResult Function(RefreshUsers value)? refreshUsers,
    TResult Function(SearchUsers value)? searchUsers,
    TResult Function(FilterByRole value)? filterByRole,
    TResult Function(FilterByStatus value)? filterByStatus,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(CreateUser value)? createUser,
    TResult Function(UpdateUser value)? updateUser,
    TResult Function(UpdateUserStatus value)? updateUserStatus,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(DeleteUser value)? deleteUser,
    TResult Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    required TResult orElse(),
  }) {
    if (createUser != null) {
      return createUser(this);
    }
    return orElse();
  }
}

abstract class CreateUser implements UserEvent {
  const factory CreateUser({
    required final String fullName,
    required final String email,
    required final String password,
    required final String role,
    required final String createdBy,
    final UserPermissions? permissions,
  }) = _$CreateUserImpl;

  String get fullName;
  String get email;
  String get password;
  String get role;
  String get createdBy;
  UserPermissions? get permissions;

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateUserImplCopyWith<_$CreateUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateUserImplCopyWith<$Res> {
  factory _$$UpdateUserImplCopyWith(
    _$UpdateUserImpl value,
    $Res Function(_$UpdateUserImpl) then,
  ) = __$$UpdateUserImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UserModel user, String updatedBy});
}

/// @nodoc
class __$$UpdateUserImplCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$UpdateUserImpl>
    implements _$$UpdateUserImplCopyWith<$Res> {
  __$$UpdateUserImplCopyWithImpl(
    _$UpdateUserImpl _value,
    $Res Function(_$UpdateUserImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null, Object? updatedBy = null}) {
    return _then(
      _$UpdateUserImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        updatedBy: null == updatedBy
            ? _value.updatedBy
            : updatedBy // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UpdateUserImpl implements UpdateUser {
  const _$UpdateUserImpl({required this.user, required this.updatedBy});

  @override
  final UserModel user;
  @override
  final String updatedBy;

  @override
  String toString() {
    return 'UserEvent.updateUser(user: $user, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateUserImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, updatedBy);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateUserImplCopyWith<_$UpdateUserImpl> get copyWith =>
      __$$UpdateUserImplCopyWithImpl<_$UpdateUserImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadUsers,
    required TResult Function(bool clearFilters) refreshUsers,
    required TResult Function(String query) searchUsers,
    required TResult Function(String role) filterByRole,
    required TResult Function(String status) filterByStatus,
    required TResult Function() clearFilters,
    required TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )
    createUser,
    required TResult Function(UserModel user, String updatedBy) updateUser,
    required TResult Function(String userId, String status, String updatedBy)
    updateUserStatus,
    required TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )
    updateUserPermissions,
    required TResult Function(String userId, String deletedBy) deleteUser,
    required TResult Function(bool silent) syncFirebaseAuthUsers,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
  }) {
    return updateUser(user, updatedBy);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadUsers,
    TResult? Function(bool clearFilters)? refreshUsers,
    TResult? Function(String query)? searchUsers,
    TResult? Function(String role)? filterByRole,
    TResult? Function(String status)? filterByStatus,
    TResult? Function()? clearFilters,
    TResult? Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult? Function(UserModel user, String updatedBy)? updateUser,
    TResult? Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult? Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult? Function(String userId, String deletedBy)? deleteUser,
    TResult? Function(bool silent)? syncFirebaseAuthUsers,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
  }) {
    return updateUser?.call(user, updatedBy);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadUsers,
    TResult Function(bool clearFilters)? refreshUsers,
    TResult Function(String query)? searchUsers,
    TResult Function(String role)? filterByRole,
    TResult Function(String status)? filterByStatus,
    TResult Function()? clearFilters,
    TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult Function(UserModel user, String updatedBy)? updateUser,
    TResult Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult Function(String userId, String deletedBy)? deleteUser,
    TResult Function(bool silent)? syncFirebaseAuthUsers,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    required TResult orElse(),
  }) {
    if (updateUser != null) {
      return updateUser(user, updatedBy);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadUsers value) loadUsers,
    required TResult Function(RefreshUsers value) refreshUsers,
    required TResult Function(SearchUsers value) searchUsers,
    required TResult Function(FilterByRole value) filterByRole,
    required TResult Function(FilterByStatus value) filterByStatus,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(CreateUser value) createUser,
    required TResult Function(UpdateUser value) updateUser,
    required TResult Function(UpdateUserStatus value) updateUserStatus,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(DeleteUser value) deleteUser,
    required TResult Function(SyncFirebaseAuthUsers value)
    syncFirebaseAuthUsers,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
  }) {
    return updateUser(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadUsers value)? loadUsers,
    TResult? Function(RefreshUsers value)? refreshUsers,
    TResult? Function(SearchUsers value)? searchUsers,
    TResult? Function(FilterByRole value)? filterByRole,
    TResult? Function(FilterByStatus value)? filterByStatus,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(CreateUser value)? createUser,
    TResult? Function(UpdateUser value)? updateUser,
    TResult? Function(UpdateUserStatus value)? updateUserStatus,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(DeleteUser value)? deleteUser,
    TResult? Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
  }) {
    return updateUser?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadUsers value)? loadUsers,
    TResult Function(RefreshUsers value)? refreshUsers,
    TResult Function(SearchUsers value)? searchUsers,
    TResult Function(FilterByRole value)? filterByRole,
    TResult Function(FilterByStatus value)? filterByStatus,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(CreateUser value)? createUser,
    TResult Function(UpdateUser value)? updateUser,
    TResult Function(UpdateUserStatus value)? updateUserStatus,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(DeleteUser value)? deleteUser,
    TResult Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    required TResult orElse(),
  }) {
    if (updateUser != null) {
      return updateUser(this);
    }
    return orElse();
  }
}

abstract class UpdateUser implements UserEvent {
  const factory UpdateUser({
    required final UserModel user,
    required final String updatedBy,
  }) = _$UpdateUserImpl;

  UserModel get user;
  String get updatedBy;

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateUserImplCopyWith<_$UpdateUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateUserStatusImplCopyWith<$Res> {
  factory _$$UpdateUserStatusImplCopyWith(
    _$UpdateUserStatusImpl value,
    $Res Function(_$UpdateUserStatusImpl) then,
  ) = __$$UpdateUserStatusImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String userId, String status, String updatedBy});
}

/// @nodoc
class __$$UpdateUserStatusImplCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$UpdateUserStatusImpl>
    implements _$$UpdateUserStatusImplCopyWith<$Res> {
  __$$UpdateUserStatusImplCopyWithImpl(
    _$UpdateUserStatusImpl _value,
    $Res Function(_$UpdateUserStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? status = null,
    Object? updatedBy = null,
  }) {
    return _then(
      _$UpdateUserStatusImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedBy: null == updatedBy
            ? _value.updatedBy
            : updatedBy // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UpdateUserStatusImpl implements UpdateUserStatus {
  const _$UpdateUserStatusImpl({
    required this.userId,
    required this.status,
    required this.updatedBy,
  });

  @override
  final String userId;
  @override
  final String status;
  @override
  final String updatedBy;

  @override
  String toString() {
    return 'UserEvent.updateUserStatus(userId: $userId, status: $status, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateUserStatusImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, status, updatedBy);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateUserStatusImplCopyWith<_$UpdateUserStatusImpl> get copyWith =>
      __$$UpdateUserStatusImplCopyWithImpl<_$UpdateUserStatusImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadUsers,
    required TResult Function(bool clearFilters) refreshUsers,
    required TResult Function(String query) searchUsers,
    required TResult Function(String role) filterByRole,
    required TResult Function(String status) filterByStatus,
    required TResult Function() clearFilters,
    required TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )
    createUser,
    required TResult Function(UserModel user, String updatedBy) updateUser,
    required TResult Function(String userId, String status, String updatedBy)
    updateUserStatus,
    required TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )
    updateUserPermissions,
    required TResult Function(String userId, String deletedBy) deleteUser,
    required TResult Function(bool silent) syncFirebaseAuthUsers,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
  }) {
    return updateUserStatus(userId, status, updatedBy);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadUsers,
    TResult? Function(bool clearFilters)? refreshUsers,
    TResult? Function(String query)? searchUsers,
    TResult? Function(String role)? filterByRole,
    TResult? Function(String status)? filterByStatus,
    TResult? Function()? clearFilters,
    TResult? Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult? Function(UserModel user, String updatedBy)? updateUser,
    TResult? Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult? Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult? Function(String userId, String deletedBy)? deleteUser,
    TResult? Function(bool silent)? syncFirebaseAuthUsers,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
  }) {
    return updateUserStatus?.call(userId, status, updatedBy);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadUsers,
    TResult Function(bool clearFilters)? refreshUsers,
    TResult Function(String query)? searchUsers,
    TResult Function(String role)? filterByRole,
    TResult Function(String status)? filterByStatus,
    TResult Function()? clearFilters,
    TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult Function(UserModel user, String updatedBy)? updateUser,
    TResult Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult Function(String userId, String deletedBy)? deleteUser,
    TResult Function(bool silent)? syncFirebaseAuthUsers,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    required TResult orElse(),
  }) {
    if (updateUserStatus != null) {
      return updateUserStatus(userId, status, updatedBy);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadUsers value) loadUsers,
    required TResult Function(RefreshUsers value) refreshUsers,
    required TResult Function(SearchUsers value) searchUsers,
    required TResult Function(FilterByRole value) filterByRole,
    required TResult Function(FilterByStatus value) filterByStatus,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(CreateUser value) createUser,
    required TResult Function(UpdateUser value) updateUser,
    required TResult Function(UpdateUserStatus value) updateUserStatus,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(DeleteUser value) deleteUser,
    required TResult Function(SyncFirebaseAuthUsers value)
    syncFirebaseAuthUsers,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
  }) {
    return updateUserStatus(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadUsers value)? loadUsers,
    TResult? Function(RefreshUsers value)? refreshUsers,
    TResult? Function(SearchUsers value)? searchUsers,
    TResult? Function(FilterByRole value)? filterByRole,
    TResult? Function(FilterByStatus value)? filterByStatus,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(CreateUser value)? createUser,
    TResult? Function(UpdateUser value)? updateUser,
    TResult? Function(UpdateUserStatus value)? updateUserStatus,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(DeleteUser value)? deleteUser,
    TResult? Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
  }) {
    return updateUserStatus?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadUsers value)? loadUsers,
    TResult Function(RefreshUsers value)? refreshUsers,
    TResult Function(SearchUsers value)? searchUsers,
    TResult Function(FilterByRole value)? filterByRole,
    TResult Function(FilterByStatus value)? filterByStatus,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(CreateUser value)? createUser,
    TResult Function(UpdateUser value)? updateUser,
    TResult Function(UpdateUserStatus value)? updateUserStatus,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(DeleteUser value)? deleteUser,
    TResult Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    required TResult orElse(),
  }) {
    if (updateUserStatus != null) {
      return updateUserStatus(this);
    }
    return orElse();
  }
}

abstract class UpdateUserStatus implements UserEvent {
  const factory UpdateUserStatus({
    required final String userId,
    required final String status,
    required final String updatedBy,
  }) = _$UpdateUserStatusImpl;

  String get userId;
  String get status;
  String get updatedBy;

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateUserStatusImplCopyWith<_$UpdateUserStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateUserPermissionsImplCopyWith<$Res> {
  factory _$$UpdateUserPermissionsImplCopyWith(
    _$UpdateUserPermissionsImpl value,
    $Res Function(_$UpdateUserPermissionsImpl) then,
  ) = __$$UpdateUserPermissionsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String userId, UserPermissions permissions, String updatedBy});
}

/// @nodoc
class __$$UpdateUserPermissionsImplCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$UpdateUserPermissionsImpl>
    implements _$$UpdateUserPermissionsImplCopyWith<$Res> {
  __$$UpdateUserPermissionsImplCopyWithImpl(
    _$UpdateUserPermissionsImpl _value,
    $Res Function(_$UpdateUserPermissionsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? permissions = null,
    Object? updatedBy = null,
  }) {
    return _then(
      _$UpdateUserPermissionsImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        permissions: null == permissions
            ? _value.permissions
            : permissions // ignore: cast_nullable_to_non_nullable
                  as UserPermissions,
        updatedBy: null == updatedBy
            ? _value.updatedBy
            : updatedBy // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UpdateUserPermissionsImpl implements UpdateUserPermissions {
  const _$UpdateUserPermissionsImpl({
    required this.userId,
    required this.permissions,
    required this.updatedBy,
  });

  @override
  final String userId;
  @override
  final UserPermissions permissions;
  @override
  final String updatedBy;

  @override
  String toString() {
    return 'UserEvent.updateUserPermissions(userId: $userId, permissions: $permissions, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateUserPermissionsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.permissions, permissions) ||
                other.permissions == permissions) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, permissions, updatedBy);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateUserPermissionsImplCopyWith<_$UpdateUserPermissionsImpl>
  get copyWith =>
      __$$UpdateUserPermissionsImplCopyWithImpl<_$UpdateUserPermissionsImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadUsers,
    required TResult Function(bool clearFilters) refreshUsers,
    required TResult Function(String query) searchUsers,
    required TResult Function(String role) filterByRole,
    required TResult Function(String status) filterByStatus,
    required TResult Function() clearFilters,
    required TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )
    createUser,
    required TResult Function(UserModel user, String updatedBy) updateUser,
    required TResult Function(String userId, String status, String updatedBy)
    updateUserStatus,
    required TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )
    updateUserPermissions,
    required TResult Function(String userId, String deletedBy) deleteUser,
    required TResult Function(bool silent) syncFirebaseAuthUsers,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
  }) {
    return updateUserPermissions(userId, permissions, updatedBy);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadUsers,
    TResult? Function(bool clearFilters)? refreshUsers,
    TResult? Function(String query)? searchUsers,
    TResult? Function(String role)? filterByRole,
    TResult? Function(String status)? filterByStatus,
    TResult? Function()? clearFilters,
    TResult? Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult? Function(UserModel user, String updatedBy)? updateUser,
    TResult? Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult? Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult? Function(String userId, String deletedBy)? deleteUser,
    TResult? Function(bool silent)? syncFirebaseAuthUsers,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
  }) {
    return updateUserPermissions?.call(userId, permissions, updatedBy);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadUsers,
    TResult Function(bool clearFilters)? refreshUsers,
    TResult Function(String query)? searchUsers,
    TResult Function(String role)? filterByRole,
    TResult Function(String status)? filterByStatus,
    TResult Function()? clearFilters,
    TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult Function(UserModel user, String updatedBy)? updateUser,
    TResult Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult Function(String userId, String deletedBy)? deleteUser,
    TResult Function(bool silent)? syncFirebaseAuthUsers,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    required TResult orElse(),
  }) {
    if (updateUserPermissions != null) {
      return updateUserPermissions(userId, permissions, updatedBy);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadUsers value) loadUsers,
    required TResult Function(RefreshUsers value) refreshUsers,
    required TResult Function(SearchUsers value) searchUsers,
    required TResult Function(FilterByRole value) filterByRole,
    required TResult Function(FilterByStatus value) filterByStatus,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(CreateUser value) createUser,
    required TResult Function(UpdateUser value) updateUser,
    required TResult Function(UpdateUserStatus value) updateUserStatus,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(DeleteUser value) deleteUser,
    required TResult Function(SyncFirebaseAuthUsers value)
    syncFirebaseAuthUsers,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
  }) {
    return updateUserPermissions(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadUsers value)? loadUsers,
    TResult? Function(RefreshUsers value)? refreshUsers,
    TResult? Function(SearchUsers value)? searchUsers,
    TResult? Function(FilterByRole value)? filterByRole,
    TResult? Function(FilterByStatus value)? filterByStatus,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(CreateUser value)? createUser,
    TResult? Function(UpdateUser value)? updateUser,
    TResult? Function(UpdateUserStatus value)? updateUserStatus,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(DeleteUser value)? deleteUser,
    TResult? Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
  }) {
    return updateUserPermissions?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadUsers value)? loadUsers,
    TResult Function(RefreshUsers value)? refreshUsers,
    TResult Function(SearchUsers value)? searchUsers,
    TResult Function(FilterByRole value)? filterByRole,
    TResult Function(FilterByStatus value)? filterByStatus,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(CreateUser value)? createUser,
    TResult Function(UpdateUser value)? updateUser,
    TResult Function(UpdateUserStatus value)? updateUserStatus,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(DeleteUser value)? deleteUser,
    TResult Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    required TResult orElse(),
  }) {
    if (updateUserPermissions != null) {
      return updateUserPermissions(this);
    }
    return orElse();
  }
}

abstract class UpdateUserPermissions implements UserEvent {
  const factory UpdateUserPermissions({
    required final String userId,
    required final UserPermissions permissions,
    required final String updatedBy,
  }) = _$UpdateUserPermissionsImpl;

  String get userId;
  UserPermissions get permissions;
  String get updatedBy;

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateUserPermissionsImplCopyWith<_$UpdateUserPermissionsImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeleteUserImplCopyWith<$Res> {
  factory _$$DeleteUserImplCopyWith(
    _$DeleteUserImpl value,
    $Res Function(_$DeleteUserImpl) then,
  ) = __$$DeleteUserImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String userId, String deletedBy});
}

/// @nodoc
class __$$DeleteUserImplCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$DeleteUserImpl>
    implements _$$DeleteUserImplCopyWith<$Res> {
  __$$DeleteUserImplCopyWithImpl(
    _$DeleteUserImpl _value,
    $Res Function(_$DeleteUserImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? userId = null, Object? deletedBy = null}) {
    return _then(
      _$DeleteUserImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        deletedBy: null == deletedBy
            ? _value.deletedBy
            : deletedBy // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$DeleteUserImpl implements DeleteUser {
  const _$DeleteUserImpl({required this.userId, required this.deletedBy});

  @override
  final String userId;
  @override
  final String deletedBy;

  @override
  String toString() {
    return 'UserEvent.deleteUser(userId: $userId, deletedBy: $deletedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteUserImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.deletedBy, deletedBy) ||
                other.deletedBy == deletedBy));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, deletedBy);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteUserImplCopyWith<_$DeleteUserImpl> get copyWith =>
      __$$DeleteUserImplCopyWithImpl<_$DeleteUserImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadUsers,
    required TResult Function(bool clearFilters) refreshUsers,
    required TResult Function(String query) searchUsers,
    required TResult Function(String role) filterByRole,
    required TResult Function(String status) filterByStatus,
    required TResult Function() clearFilters,
    required TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )
    createUser,
    required TResult Function(UserModel user, String updatedBy) updateUser,
    required TResult Function(String userId, String status, String updatedBy)
    updateUserStatus,
    required TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )
    updateUserPermissions,
    required TResult Function(String userId, String deletedBy) deleteUser,
    required TResult Function(bool silent) syncFirebaseAuthUsers,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
  }) {
    return deleteUser(userId, deletedBy);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadUsers,
    TResult? Function(bool clearFilters)? refreshUsers,
    TResult? Function(String query)? searchUsers,
    TResult? Function(String role)? filterByRole,
    TResult? Function(String status)? filterByStatus,
    TResult? Function()? clearFilters,
    TResult? Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult? Function(UserModel user, String updatedBy)? updateUser,
    TResult? Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult? Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult? Function(String userId, String deletedBy)? deleteUser,
    TResult? Function(bool silent)? syncFirebaseAuthUsers,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
  }) {
    return deleteUser?.call(userId, deletedBy);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadUsers,
    TResult Function(bool clearFilters)? refreshUsers,
    TResult Function(String query)? searchUsers,
    TResult Function(String role)? filterByRole,
    TResult Function(String status)? filterByStatus,
    TResult Function()? clearFilters,
    TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult Function(UserModel user, String updatedBy)? updateUser,
    TResult Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult Function(String userId, String deletedBy)? deleteUser,
    TResult Function(bool silent)? syncFirebaseAuthUsers,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    required TResult orElse(),
  }) {
    if (deleteUser != null) {
      return deleteUser(userId, deletedBy);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadUsers value) loadUsers,
    required TResult Function(RefreshUsers value) refreshUsers,
    required TResult Function(SearchUsers value) searchUsers,
    required TResult Function(FilterByRole value) filterByRole,
    required TResult Function(FilterByStatus value) filterByStatus,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(CreateUser value) createUser,
    required TResult Function(UpdateUser value) updateUser,
    required TResult Function(UpdateUserStatus value) updateUserStatus,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(DeleteUser value) deleteUser,
    required TResult Function(SyncFirebaseAuthUsers value)
    syncFirebaseAuthUsers,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
  }) {
    return deleteUser(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadUsers value)? loadUsers,
    TResult? Function(RefreshUsers value)? refreshUsers,
    TResult? Function(SearchUsers value)? searchUsers,
    TResult? Function(FilterByRole value)? filterByRole,
    TResult? Function(FilterByStatus value)? filterByStatus,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(CreateUser value)? createUser,
    TResult? Function(UpdateUser value)? updateUser,
    TResult? Function(UpdateUserStatus value)? updateUserStatus,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(DeleteUser value)? deleteUser,
    TResult? Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
  }) {
    return deleteUser?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadUsers value)? loadUsers,
    TResult Function(RefreshUsers value)? refreshUsers,
    TResult Function(SearchUsers value)? searchUsers,
    TResult Function(FilterByRole value)? filterByRole,
    TResult Function(FilterByStatus value)? filterByStatus,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(CreateUser value)? createUser,
    TResult Function(UpdateUser value)? updateUser,
    TResult Function(UpdateUserStatus value)? updateUserStatus,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(DeleteUser value)? deleteUser,
    TResult Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    required TResult orElse(),
  }) {
    if (deleteUser != null) {
      return deleteUser(this);
    }
    return orElse();
  }
}

abstract class DeleteUser implements UserEvent {
  const factory DeleteUser({
    required final String userId,
    required final String deletedBy,
  }) = _$DeleteUserImpl;

  String get userId;
  String get deletedBy;

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteUserImplCopyWith<_$DeleteUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SyncFirebaseAuthUsersImplCopyWith<$Res> {
  factory _$$SyncFirebaseAuthUsersImplCopyWith(
    _$SyncFirebaseAuthUsersImpl value,
    $Res Function(_$SyncFirebaseAuthUsersImpl) then,
  ) = __$$SyncFirebaseAuthUsersImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool silent});
}

/// @nodoc
class __$$SyncFirebaseAuthUsersImplCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$SyncFirebaseAuthUsersImpl>
    implements _$$SyncFirebaseAuthUsersImplCopyWith<$Res> {
  __$$SyncFirebaseAuthUsersImplCopyWithImpl(
    _$SyncFirebaseAuthUsersImpl _value,
    $Res Function(_$SyncFirebaseAuthUsersImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? silent = null}) {
    return _then(
      _$SyncFirebaseAuthUsersImpl(
        silent: null == silent
            ? _value.silent
            : silent // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$SyncFirebaseAuthUsersImpl implements SyncFirebaseAuthUsers {
  const _$SyncFirebaseAuthUsersImpl({this.silent = false});

  @override
  @JsonKey()
  final bool silent;

  @override
  String toString() {
    return 'UserEvent.syncFirebaseAuthUsers(silent: $silent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncFirebaseAuthUsersImpl &&
            (identical(other.silent, silent) || other.silent == silent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, silent);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncFirebaseAuthUsersImplCopyWith<_$SyncFirebaseAuthUsersImpl>
  get copyWith =>
      __$$SyncFirebaseAuthUsersImplCopyWithImpl<_$SyncFirebaseAuthUsersImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadUsers,
    required TResult Function(bool clearFilters) refreshUsers,
    required TResult Function(String query) searchUsers,
    required TResult Function(String role) filterByRole,
    required TResult Function(String status) filterByStatus,
    required TResult Function() clearFilters,
    required TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )
    createUser,
    required TResult Function(UserModel user, String updatedBy) updateUser,
    required TResult Function(String userId, String status, String updatedBy)
    updateUserStatus,
    required TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )
    updateUserPermissions,
    required TResult Function(String userId, String deletedBy) deleteUser,
    required TResult Function(bool silent) syncFirebaseAuthUsers,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
  }) {
    return syncFirebaseAuthUsers(silent);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadUsers,
    TResult? Function(bool clearFilters)? refreshUsers,
    TResult? Function(String query)? searchUsers,
    TResult? Function(String role)? filterByRole,
    TResult? Function(String status)? filterByStatus,
    TResult? Function()? clearFilters,
    TResult? Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult? Function(UserModel user, String updatedBy)? updateUser,
    TResult? Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult? Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult? Function(String userId, String deletedBy)? deleteUser,
    TResult? Function(bool silent)? syncFirebaseAuthUsers,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
  }) {
    return syncFirebaseAuthUsers?.call(silent);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadUsers,
    TResult Function(bool clearFilters)? refreshUsers,
    TResult Function(String query)? searchUsers,
    TResult Function(String role)? filterByRole,
    TResult Function(String status)? filterByStatus,
    TResult Function()? clearFilters,
    TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult Function(UserModel user, String updatedBy)? updateUser,
    TResult Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult Function(String userId, String deletedBy)? deleteUser,
    TResult Function(bool silent)? syncFirebaseAuthUsers,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    required TResult orElse(),
  }) {
    if (syncFirebaseAuthUsers != null) {
      return syncFirebaseAuthUsers(silent);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadUsers value) loadUsers,
    required TResult Function(RefreshUsers value) refreshUsers,
    required TResult Function(SearchUsers value) searchUsers,
    required TResult Function(FilterByRole value) filterByRole,
    required TResult Function(FilterByStatus value) filterByStatus,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(CreateUser value) createUser,
    required TResult Function(UpdateUser value) updateUser,
    required TResult Function(UpdateUserStatus value) updateUserStatus,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(DeleteUser value) deleteUser,
    required TResult Function(SyncFirebaseAuthUsers value)
    syncFirebaseAuthUsers,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
  }) {
    return syncFirebaseAuthUsers(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadUsers value)? loadUsers,
    TResult? Function(RefreshUsers value)? refreshUsers,
    TResult? Function(SearchUsers value)? searchUsers,
    TResult? Function(FilterByRole value)? filterByRole,
    TResult? Function(FilterByStatus value)? filterByStatus,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(CreateUser value)? createUser,
    TResult? Function(UpdateUser value)? updateUser,
    TResult? Function(UpdateUserStatus value)? updateUserStatus,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(DeleteUser value)? deleteUser,
    TResult? Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
  }) {
    return syncFirebaseAuthUsers?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadUsers value)? loadUsers,
    TResult Function(RefreshUsers value)? refreshUsers,
    TResult Function(SearchUsers value)? searchUsers,
    TResult Function(FilterByRole value)? filterByRole,
    TResult Function(FilterByStatus value)? filterByStatus,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(CreateUser value)? createUser,
    TResult Function(UpdateUser value)? updateUser,
    TResult Function(UpdateUserStatus value)? updateUserStatus,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(DeleteUser value)? deleteUser,
    TResult Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    required TResult orElse(),
  }) {
    if (syncFirebaseAuthUsers != null) {
      return syncFirebaseAuthUsers(this);
    }
    return orElse();
  }
}

abstract class SyncFirebaseAuthUsers implements UserEvent {
  const factory SyncFirebaseAuthUsers({final bool silent}) =
      _$SyncFirebaseAuthUsersImpl;

  bool get silent;

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncFirebaseAuthUsersImplCopyWith<_$SyncFirebaseAuthUsersImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ClearErrorImplCopyWith<$Res> {
  factory _$$ClearErrorImplCopyWith(
    _$ClearErrorImpl value,
    $Res Function(_$ClearErrorImpl) then,
  ) = __$$ClearErrorImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ClearErrorImplCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$ClearErrorImpl>
    implements _$$ClearErrorImplCopyWith<$Res> {
  __$$ClearErrorImplCopyWithImpl(
    _$ClearErrorImpl _value,
    $Res Function(_$ClearErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ClearErrorImpl implements ClearError {
  const _$ClearErrorImpl();

  @override
  String toString() {
    return 'UserEvent.clearError()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ClearErrorImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadUsers,
    required TResult Function(bool clearFilters) refreshUsers,
    required TResult Function(String query) searchUsers,
    required TResult Function(String role) filterByRole,
    required TResult Function(String status) filterByStatus,
    required TResult Function() clearFilters,
    required TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )
    createUser,
    required TResult Function(UserModel user, String updatedBy) updateUser,
    required TResult Function(String userId, String status, String updatedBy)
    updateUserStatus,
    required TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )
    updateUserPermissions,
    required TResult Function(String userId, String deletedBy) deleteUser,
    required TResult Function(bool silent) syncFirebaseAuthUsers,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
  }) {
    return clearError();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadUsers,
    TResult? Function(bool clearFilters)? refreshUsers,
    TResult? Function(String query)? searchUsers,
    TResult? Function(String role)? filterByRole,
    TResult? Function(String status)? filterByStatus,
    TResult? Function()? clearFilters,
    TResult? Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult? Function(UserModel user, String updatedBy)? updateUser,
    TResult? Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult? Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult? Function(String userId, String deletedBy)? deleteUser,
    TResult? Function(bool silent)? syncFirebaseAuthUsers,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
  }) {
    return clearError?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadUsers,
    TResult Function(bool clearFilters)? refreshUsers,
    TResult Function(String query)? searchUsers,
    TResult Function(String role)? filterByRole,
    TResult Function(String status)? filterByStatus,
    TResult Function()? clearFilters,
    TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult Function(UserModel user, String updatedBy)? updateUser,
    TResult Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult Function(String userId, String deletedBy)? deleteUser,
    TResult Function(bool silent)? syncFirebaseAuthUsers,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    required TResult orElse(),
  }) {
    if (clearError != null) {
      return clearError();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadUsers value) loadUsers,
    required TResult Function(RefreshUsers value) refreshUsers,
    required TResult Function(SearchUsers value) searchUsers,
    required TResult Function(FilterByRole value) filterByRole,
    required TResult Function(FilterByStatus value) filterByStatus,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(CreateUser value) createUser,
    required TResult Function(UpdateUser value) updateUser,
    required TResult Function(UpdateUserStatus value) updateUserStatus,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(DeleteUser value) deleteUser,
    required TResult Function(SyncFirebaseAuthUsers value)
    syncFirebaseAuthUsers,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
  }) {
    return clearError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadUsers value)? loadUsers,
    TResult? Function(RefreshUsers value)? refreshUsers,
    TResult? Function(SearchUsers value)? searchUsers,
    TResult? Function(FilterByRole value)? filterByRole,
    TResult? Function(FilterByStatus value)? filterByStatus,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(CreateUser value)? createUser,
    TResult? Function(UpdateUser value)? updateUser,
    TResult? Function(UpdateUserStatus value)? updateUserStatus,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(DeleteUser value)? deleteUser,
    TResult? Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
  }) {
    return clearError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadUsers value)? loadUsers,
    TResult Function(RefreshUsers value)? refreshUsers,
    TResult Function(SearchUsers value)? searchUsers,
    TResult Function(FilterByRole value)? filterByRole,
    TResult Function(FilterByStatus value)? filterByStatus,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(CreateUser value)? createUser,
    TResult Function(UpdateUser value)? updateUser,
    TResult Function(UpdateUserStatus value)? updateUserStatus,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(DeleteUser value)? deleteUser,
    TResult Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    required TResult orElse(),
  }) {
    if (clearError != null) {
      return clearError(this);
    }
    return orElse();
  }
}

abstract class ClearError implements UserEvent {
  const factory ClearError() = _$ClearErrorImpl;
}

/// @nodoc
abstract class _$$RetryLastOperationImplCopyWith<$Res> {
  factory _$$RetryLastOperationImplCopyWith(
    _$RetryLastOperationImpl value,
    $Res Function(_$RetryLastOperationImpl) then,
  ) = __$$RetryLastOperationImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RetryLastOperationImplCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$RetryLastOperationImpl>
    implements _$$RetryLastOperationImplCopyWith<$Res> {
  __$$RetryLastOperationImplCopyWithImpl(
    _$RetryLastOperationImpl _value,
    $Res Function(_$RetryLastOperationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RetryLastOperationImpl implements RetryLastOperation {
  const _$RetryLastOperationImpl();

  @override
  String toString() {
    return 'UserEvent.retryLastOperation()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RetryLastOperationImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadUsers,
    required TResult Function(bool clearFilters) refreshUsers,
    required TResult Function(String query) searchUsers,
    required TResult Function(String role) filterByRole,
    required TResult Function(String status) filterByStatus,
    required TResult Function() clearFilters,
    required TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )
    createUser,
    required TResult Function(UserModel user, String updatedBy) updateUser,
    required TResult Function(String userId, String status, String updatedBy)
    updateUserStatus,
    required TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )
    updateUserPermissions,
    required TResult Function(String userId, String deletedBy) deleteUser,
    required TResult Function(bool silent) syncFirebaseAuthUsers,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
  }) {
    return retryLastOperation();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadUsers,
    TResult? Function(bool clearFilters)? refreshUsers,
    TResult? Function(String query)? searchUsers,
    TResult? Function(String role)? filterByRole,
    TResult? Function(String status)? filterByStatus,
    TResult? Function()? clearFilters,
    TResult? Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult? Function(UserModel user, String updatedBy)? updateUser,
    TResult? Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult? Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult? Function(String userId, String deletedBy)? deleteUser,
    TResult? Function(bool silent)? syncFirebaseAuthUsers,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
  }) {
    return retryLastOperation?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadUsers,
    TResult Function(bool clearFilters)? refreshUsers,
    TResult Function(String query)? searchUsers,
    TResult Function(String role)? filterByRole,
    TResult Function(String status)? filterByStatus,
    TResult Function()? clearFilters,
    TResult Function(
      String fullName,
      String email,
      String password,
      String role,
      String createdBy,
      UserPermissions? permissions,
    )?
    createUser,
    TResult Function(UserModel user, String updatedBy)? updateUser,
    TResult Function(String userId, String status, String updatedBy)?
    updateUserStatus,
    TResult Function(
      String userId,
      UserPermissions permissions,
      String updatedBy,
    )?
    updateUserPermissions,
    TResult Function(String userId, String deletedBy)? deleteUser,
    TResult Function(bool silent)? syncFirebaseAuthUsers,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    required TResult orElse(),
  }) {
    if (retryLastOperation != null) {
      return retryLastOperation();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadUsers value) loadUsers,
    required TResult Function(RefreshUsers value) refreshUsers,
    required TResult Function(SearchUsers value) searchUsers,
    required TResult Function(FilterByRole value) filterByRole,
    required TResult Function(FilterByStatus value) filterByStatus,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(CreateUser value) createUser,
    required TResult Function(UpdateUser value) updateUser,
    required TResult Function(UpdateUserStatus value) updateUserStatus,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(DeleteUser value) deleteUser,
    required TResult Function(SyncFirebaseAuthUsers value)
    syncFirebaseAuthUsers,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
  }) {
    return retryLastOperation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadUsers value)? loadUsers,
    TResult? Function(RefreshUsers value)? refreshUsers,
    TResult? Function(SearchUsers value)? searchUsers,
    TResult? Function(FilterByRole value)? filterByRole,
    TResult? Function(FilterByStatus value)? filterByStatus,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(CreateUser value)? createUser,
    TResult? Function(UpdateUser value)? updateUser,
    TResult? Function(UpdateUserStatus value)? updateUserStatus,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(DeleteUser value)? deleteUser,
    TResult? Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
  }) {
    return retryLastOperation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadUsers value)? loadUsers,
    TResult Function(RefreshUsers value)? refreshUsers,
    TResult Function(SearchUsers value)? searchUsers,
    TResult Function(FilterByRole value)? filterByRole,
    TResult Function(FilterByStatus value)? filterByStatus,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(CreateUser value)? createUser,
    TResult Function(UpdateUser value)? updateUser,
    TResult Function(UpdateUserStatus value)? updateUserStatus,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(DeleteUser value)? deleteUser,
    TResult Function(SyncFirebaseAuthUsers value)? syncFirebaseAuthUsers,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    required TResult orElse(),
  }) {
    if (retryLastOperation != null) {
      return retryLastOperation(this);
    }
    return orElse();
  }
}

abstract class RetryLastOperation implements UserEvent {
  const factory RetryLastOperation() = _$RetryLastOperationImpl;
}
