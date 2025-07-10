// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AuthState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? operationType) loading,
    required TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )
    authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )
    error,
    required TResult Function() registering,
    required TResult Function(String email, bool needsEmailVerification)
    registrationComplete,
    required TResult Function(String email) passwordResetSent,
    required TResult Function() emailVerificationSent,
    required TResult Function(UserModel user) updatingProfile,
    required TResult Function(UserModel user) profileUpdated,
    required TResult Function(UserModel user) changingPassword,
    required TResult Function(UserModel user) passwordChanged,
    required TResult Function(String operation, UserModel user)
    reauthenticationRequired,
    required TResult Function(UserModel user) reauthenticating,
    required TResult Function(UserModel user) deletingAccount,
    required TResult Function() accountDeleted,
    required TResult Function(UserModel user, String provider) linkingAccount,
    required TResult Function(UserModel user, String provider) accountLinked,
    required TResult Function(UserModel user, String provider) unlinkingAccount,
    required TResult Function(UserModel user, String provider) accountUnlinked,
    required TResult Function(UserModel user, String newEmail) updatingEmail,
    required TResult Function(UserModel user, String newEmail) emailUpdated,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? operationType)? loading,
    TResult? Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult? Function()? registering,
    TResult? Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult? Function(String email)? passwordResetSent,
    TResult? Function()? emailVerificationSent,
    TResult? Function(UserModel user)? updatingProfile,
    TResult? Function(UserModel user)? profileUpdated,
    TResult? Function(UserModel user)? changingPassword,
    TResult? Function(UserModel user)? passwordChanged,
    TResult? Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult? Function(UserModel user)? reauthenticating,
    TResult? Function(UserModel user)? deletingAccount,
    TResult? Function()? accountDeleted,
    TResult? Function(UserModel user, String provider)? linkingAccount,
    TResult? Function(UserModel user, String provider)? accountLinked,
    TResult? Function(UserModel user, String provider)? unlinkingAccount,
    TResult? Function(UserModel user, String provider)? accountUnlinked,
    TResult? Function(UserModel user, String newEmail)? updatingEmail,
    TResult? Function(UserModel user, String newEmail)? emailUpdated,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? operationType)? loading,
    TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult Function()? unauthenticated,
    TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult Function()? registering,
    TResult Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult Function(String email)? passwordResetSent,
    TResult Function()? emailVerificationSent,
    TResult Function(UserModel user)? updatingProfile,
    TResult Function(UserModel user)? profileUpdated,
    TResult Function(UserModel user)? changingPassword,
    TResult Function(UserModel user)? passwordChanged,
    TResult Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult Function(UserModel user)? reauthenticating,
    TResult Function(UserModel user)? deletingAccount,
    TResult Function()? accountDeleted,
    TResult Function(UserModel user, String provider)? linkingAccount,
    TResult Function(UserModel user, String provider)? accountLinked,
    TResult Function(UserModel user, String provider)? unlinkingAccount,
    TResult Function(UserModel user, String provider)? accountUnlinked,
    TResult Function(UserModel user, String newEmail)? updatingEmail,
    TResult Function(UserModel user, String newEmail)? emailUpdated,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthRegistering value) registering,
    required TResult Function(AuthRegistrationComplete value)
    registrationComplete,
    required TResult Function(AuthPasswordResetSent value) passwordResetSent,
    required TResult Function(AuthEmailVerificationSent value)
    emailVerificationSent,
    required TResult Function(AuthUpdatingProfile value) updatingProfile,
    required TResult Function(AuthProfileUpdated value) profileUpdated,
    required TResult Function(AuthChangingPassword value) changingPassword,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthReauthenticationRequired value)
    reauthenticationRequired,
    required TResult Function(AuthReauthenticating value) reauthenticating,
    required TResult Function(AuthDeletingAccount value) deletingAccount,
    required TResult Function(AuthAccountDeleted value) accountDeleted,
    required TResult Function(AuthLinkingAccount value) linkingAccount,
    required TResult Function(AuthAccountLinked value) accountLinked,
    required TResult Function(AuthUnlinkingAccount value) unlinkingAccount,
    required TResult Function(AuthAccountUnlinked value) accountUnlinked,
    required TResult Function(AuthUpdatingEmail value) updatingEmail,
    required TResult Function(AuthEmailUpdated value) emailUpdated,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthRegistering value)? registering,
    TResult? Function(AuthRegistrationComplete value)? registrationComplete,
    TResult? Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult? Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult? Function(AuthUpdatingProfile value)? updatingProfile,
    TResult? Function(AuthProfileUpdated value)? profileUpdated,
    TResult? Function(AuthChangingPassword value)? changingPassword,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult? Function(AuthReauthenticating value)? reauthenticating,
    TResult? Function(AuthDeletingAccount value)? deletingAccount,
    TResult? Function(AuthAccountDeleted value)? accountDeleted,
    TResult? Function(AuthLinkingAccount value)? linkingAccount,
    TResult? Function(AuthAccountLinked value)? accountLinked,
    TResult? Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult? Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult? Function(AuthUpdatingEmail value)? updatingEmail,
    TResult? Function(AuthEmailUpdated value)? emailUpdated,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? error,
    TResult Function(AuthRegistering value)? registering,
    TResult Function(AuthRegistrationComplete value)? registrationComplete,
    TResult Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult Function(AuthUpdatingProfile value)? updatingProfile,
    TResult Function(AuthProfileUpdated value)? profileUpdated,
    TResult Function(AuthChangingPassword value)? changingPassword,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult Function(AuthReauthenticating value)? reauthenticating,
    TResult Function(AuthDeletingAccount value)? deletingAccount,
    TResult Function(AuthAccountDeleted value)? accountDeleted,
    TResult Function(AuthLinkingAccount value)? linkingAccount,
    TResult Function(AuthAccountLinked value)? accountLinked,
    TResult Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult Function(AuthUpdatingEmail value)? updatingEmail,
    TResult Function(AuthEmailUpdated value)? emailUpdated,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AuthInitialImplCopyWith<$Res> {
  factory _$$AuthInitialImplCopyWith(
    _$AuthInitialImpl value,
    $Res Function(_$AuthInitialImpl) then,
  ) = __$$AuthInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthInitialImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthInitialImpl>
    implements _$$AuthInitialImplCopyWith<$Res> {
  __$$AuthInitialImplCopyWithImpl(
    _$AuthInitialImpl _value,
    $Res Function(_$AuthInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthInitialImpl implements AuthInitial {
  const _$AuthInitialImpl();

  @override
  String toString() {
    return 'AuthState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? operationType) loading,
    required TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )
    authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )
    error,
    required TResult Function() registering,
    required TResult Function(String email, bool needsEmailVerification)
    registrationComplete,
    required TResult Function(String email) passwordResetSent,
    required TResult Function() emailVerificationSent,
    required TResult Function(UserModel user) updatingProfile,
    required TResult Function(UserModel user) profileUpdated,
    required TResult Function(UserModel user) changingPassword,
    required TResult Function(UserModel user) passwordChanged,
    required TResult Function(String operation, UserModel user)
    reauthenticationRequired,
    required TResult Function(UserModel user) reauthenticating,
    required TResult Function(UserModel user) deletingAccount,
    required TResult Function() accountDeleted,
    required TResult Function(UserModel user, String provider) linkingAccount,
    required TResult Function(UserModel user, String provider) accountLinked,
    required TResult Function(UserModel user, String provider) unlinkingAccount,
    required TResult Function(UserModel user, String provider) accountUnlinked,
    required TResult Function(UserModel user, String newEmail) updatingEmail,
    required TResult Function(UserModel user, String newEmail) emailUpdated,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? operationType)? loading,
    TResult? Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult? Function()? registering,
    TResult? Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult? Function(String email)? passwordResetSent,
    TResult? Function()? emailVerificationSent,
    TResult? Function(UserModel user)? updatingProfile,
    TResult? Function(UserModel user)? profileUpdated,
    TResult? Function(UserModel user)? changingPassword,
    TResult? Function(UserModel user)? passwordChanged,
    TResult? Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult? Function(UserModel user)? reauthenticating,
    TResult? Function(UserModel user)? deletingAccount,
    TResult? Function()? accountDeleted,
    TResult? Function(UserModel user, String provider)? linkingAccount,
    TResult? Function(UserModel user, String provider)? accountLinked,
    TResult? Function(UserModel user, String provider)? unlinkingAccount,
    TResult? Function(UserModel user, String provider)? accountUnlinked,
    TResult? Function(UserModel user, String newEmail)? updatingEmail,
    TResult? Function(UserModel user, String newEmail)? emailUpdated,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? operationType)? loading,
    TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult Function()? unauthenticated,
    TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult Function()? registering,
    TResult Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult Function(String email)? passwordResetSent,
    TResult Function()? emailVerificationSent,
    TResult Function(UserModel user)? updatingProfile,
    TResult Function(UserModel user)? profileUpdated,
    TResult Function(UserModel user)? changingPassword,
    TResult Function(UserModel user)? passwordChanged,
    TResult Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult Function(UserModel user)? reauthenticating,
    TResult Function(UserModel user)? deletingAccount,
    TResult Function()? accountDeleted,
    TResult Function(UserModel user, String provider)? linkingAccount,
    TResult Function(UserModel user, String provider)? accountLinked,
    TResult Function(UserModel user, String provider)? unlinkingAccount,
    TResult Function(UserModel user, String provider)? accountUnlinked,
    TResult Function(UserModel user, String newEmail)? updatingEmail,
    TResult Function(UserModel user, String newEmail)? emailUpdated,
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
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthRegistering value) registering,
    required TResult Function(AuthRegistrationComplete value)
    registrationComplete,
    required TResult Function(AuthPasswordResetSent value) passwordResetSent,
    required TResult Function(AuthEmailVerificationSent value)
    emailVerificationSent,
    required TResult Function(AuthUpdatingProfile value) updatingProfile,
    required TResult Function(AuthProfileUpdated value) profileUpdated,
    required TResult Function(AuthChangingPassword value) changingPassword,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthReauthenticationRequired value)
    reauthenticationRequired,
    required TResult Function(AuthReauthenticating value) reauthenticating,
    required TResult Function(AuthDeletingAccount value) deletingAccount,
    required TResult Function(AuthAccountDeleted value) accountDeleted,
    required TResult Function(AuthLinkingAccount value) linkingAccount,
    required TResult Function(AuthAccountLinked value) accountLinked,
    required TResult Function(AuthUnlinkingAccount value) unlinkingAccount,
    required TResult Function(AuthAccountUnlinked value) accountUnlinked,
    required TResult Function(AuthUpdatingEmail value) updatingEmail,
    required TResult Function(AuthEmailUpdated value) emailUpdated,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthRegistering value)? registering,
    TResult? Function(AuthRegistrationComplete value)? registrationComplete,
    TResult? Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult? Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult? Function(AuthUpdatingProfile value)? updatingProfile,
    TResult? Function(AuthProfileUpdated value)? profileUpdated,
    TResult? Function(AuthChangingPassword value)? changingPassword,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult? Function(AuthReauthenticating value)? reauthenticating,
    TResult? Function(AuthDeletingAccount value)? deletingAccount,
    TResult? Function(AuthAccountDeleted value)? accountDeleted,
    TResult? Function(AuthLinkingAccount value)? linkingAccount,
    TResult? Function(AuthAccountLinked value)? accountLinked,
    TResult? Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult? Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult? Function(AuthUpdatingEmail value)? updatingEmail,
    TResult? Function(AuthEmailUpdated value)? emailUpdated,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? error,
    TResult Function(AuthRegistering value)? registering,
    TResult Function(AuthRegistrationComplete value)? registrationComplete,
    TResult Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult Function(AuthUpdatingProfile value)? updatingProfile,
    TResult Function(AuthProfileUpdated value)? profileUpdated,
    TResult Function(AuthChangingPassword value)? changingPassword,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult Function(AuthReauthenticating value)? reauthenticating,
    TResult Function(AuthDeletingAccount value)? deletingAccount,
    TResult Function(AuthAccountDeleted value)? accountDeleted,
    TResult Function(AuthLinkingAccount value)? linkingAccount,
    TResult Function(AuthAccountLinked value)? accountLinked,
    TResult Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult Function(AuthUpdatingEmail value)? updatingEmail,
    TResult Function(AuthEmailUpdated value)? emailUpdated,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class AuthInitial implements AuthState {
  const factory AuthInitial() = _$AuthInitialImpl;
}

/// @nodoc
abstract class _$$AuthLoadingImplCopyWith<$Res> {
  factory _$$AuthLoadingImplCopyWith(
    _$AuthLoadingImpl value,
    $Res Function(_$AuthLoadingImpl) then,
  ) = __$$AuthLoadingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? operationType});
}

/// @nodoc
class __$$AuthLoadingImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthLoadingImpl>
    implements _$$AuthLoadingImplCopyWith<$Res> {
  __$$AuthLoadingImplCopyWithImpl(
    _$AuthLoadingImpl _value,
    $Res Function(_$AuthLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? operationType = freezed}) {
    return _then(
      _$AuthLoadingImpl(
        operationType: freezed == operationType
            ? _value.operationType
            : operationType // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$AuthLoadingImpl implements AuthLoading {
  const _$AuthLoadingImpl({this.operationType});

  @override
  final String? operationType;

  @override
  String toString() {
    return 'AuthState.loading(operationType: $operationType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthLoadingImpl &&
            (identical(other.operationType, operationType) ||
                other.operationType == operationType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, operationType);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthLoadingImplCopyWith<_$AuthLoadingImpl> get copyWith =>
      __$$AuthLoadingImplCopyWithImpl<_$AuthLoadingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? operationType) loading,
    required TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )
    authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )
    error,
    required TResult Function() registering,
    required TResult Function(String email, bool needsEmailVerification)
    registrationComplete,
    required TResult Function(String email) passwordResetSent,
    required TResult Function() emailVerificationSent,
    required TResult Function(UserModel user) updatingProfile,
    required TResult Function(UserModel user) profileUpdated,
    required TResult Function(UserModel user) changingPassword,
    required TResult Function(UserModel user) passwordChanged,
    required TResult Function(String operation, UserModel user)
    reauthenticationRequired,
    required TResult Function(UserModel user) reauthenticating,
    required TResult Function(UserModel user) deletingAccount,
    required TResult Function() accountDeleted,
    required TResult Function(UserModel user, String provider) linkingAccount,
    required TResult Function(UserModel user, String provider) accountLinked,
    required TResult Function(UserModel user, String provider) unlinkingAccount,
    required TResult Function(UserModel user, String provider) accountUnlinked,
    required TResult Function(UserModel user, String newEmail) updatingEmail,
    required TResult Function(UserModel user, String newEmail) emailUpdated,
  }) {
    return loading(operationType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? operationType)? loading,
    TResult? Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult? Function()? registering,
    TResult? Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult? Function(String email)? passwordResetSent,
    TResult? Function()? emailVerificationSent,
    TResult? Function(UserModel user)? updatingProfile,
    TResult? Function(UserModel user)? profileUpdated,
    TResult? Function(UserModel user)? changingPassword,
    TResult? Function(UserModel user)? passwordChanged,
    TResult? Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult? Function(UserModel user)? reauthenticating,
    TResult? Function(UserModel user)? deletingAccount,
    TResult? Function()? accountDeleted,
    TResult? Function(UserModel user, String provider)? linkingAccount,
    TResult? Function(UserModel user, String provider)? accountLinked,
    TResult? Function(UserModel user, String provider)? unlinkingAccount,
    TResult? Function(UserModel user, String provider)? accountUnlinked,
    TResult? Function(UserModel user, String newEmail)? updatingEmail,
    TResult? Function(UserModel user, String newEmail)? emailUpdated,
  }) {
    return loading?.call(operationType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? operationType)? loading,
    TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult Function()? unauthenticated,
    TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult Function()? registering,
    TResult Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult Function(String email)? passwordResetSent,
    TResult Function()? emailVerificationSent,
    TResult Function(UserModel user)? updatingProfile,
    TResult Function(UserModel user)? profileUpdated,
    TResult Function(UserModel user)? changingPassword,
    TResult Function(UserModel user)? passwordChanged,
    TResult Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult Function(UserModel user)? reauthenticating,
    TResult Function(UserModel user)? deletingAccount,
    TResult Function()? accountDeleted,
    TResult Function(UserModel user, String provider)? linkingAccount,
    TResult Function(UserModel user, String provider)? accountLinked,
    TResult Function(UserModel user, String provider)? unlinkingAccount,
    TResult Function(UserModel user, String provider)? accountUnlinked,
    TResult Function(UserModel user, String newEmail)? updatingEmail,
    TResult Function(UserModel user, String newEmail)? emailUpdated,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(operationType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthRegistering value) registering,
    required TResult Function(AuthRegistrationComplete value)
    registrationComplete,
    required TResult Function(AuthPasswordResetSent value) passwordResetSent,
    required TResult Function(AuthEmailVerificationSent value)
    emailVerificationSent,
    required TResult Function(AuthUpdatingProfile value) updatingProfile,
    required TResult Function(AuthProfileUpdated value) profileUpdated,
    required TResult Function(AuthChangingPassword value) changingPassword,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthReauthenticationRequired value)
    reauthenticationRequired,
    required TResult Function(AuthReauthenticating value) reauthenticating,
    required TResult Function(AuthDeletingAccount value) deletingAccount,
    required TResult Function(AuthAccountDeleted value) accountDeleted,
    required TResult Function(AuthLinkingAccount value) linkingAccount,
    required TResult Function(AuthAccountLinked value) accountLinked,
    required TResult Function(AuthUnlinkingAccount value) unlinkingAccount,
    required TResult Function(AuthAccountUnlinked value) accountUnlinked,
    required TResult Function(AuthUpdatingEmail value) updatingEmail,
    required TResult Function(AuthEmailUpdated value) emailUpdated,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthRegistering value)? registering,
    TResult? Function(AuthRegistrationComplete value)? registrationComplete,
    TResult? Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult? Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult? Function(AuthUpdatingProfile value)? updatingProfile,
    TResult? Function(AuthProfileUpdated value)? profileUpdated,
    TResult? Function(AuthChangingPassword value)? changingPassword,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult? Function(AuthReauthenticating value)? reauthenticating,
    TResult? Function(AuthDeletingAccount value)? deletingAccount,
    TResult? Function(AuthAccountDeleted value)? accountDeleted,
    TResult? Function(AuthLinkingAccount value)? linkingAccount,
    TResult? Function(AuthAccountLinked value)? accountLinked,
    TResult? Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult? Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult? Function(AuthUpdatingEmail value)? updatingEmail,
    TResult? Function(AuthEmailUpdated value)? emailUpdated,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? error,
    TResult Function(AuthRegistering value)? registering,
    TResult Function(AuthRegistrationComplete value)? registrationComplete,
    TResult Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult Function(AuthUpdatingProfile value)? updatingProfile,
    TResult Function(AuthProfileUpdated value)? profileUpdated,
    TResult Function(AuthChangingPassword value)? changingPassword,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult Function(AuthReauthenticating value)? reauthenticating,
    TResult Function(AuthDeletingAccount value)? deletingAccount,
    TResult Function(AuthAccountDeleted value)? accountDeleted,
    TResult Function(AuthLinkingAccount value)? linkingAccount,
    TResult Function(AuthAccountLinked value)? accountLinked,
    TResult Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult Function(AuthUpdatingEmail value)? updatingEmail,
    TResult Function(AuthEmailUpdated value)? emailUpdated,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class AuthLoading implements AuthState {
  const factory AuthLoading({final String? operationType}) = _$AuthLoadingImpl;

  String? get operationType;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthLoadingImplCopyWith<_$AuthLoadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthAuthenticatedImplCopyWith<$Res> {
  factory _$$AuthAuthenticatedImplCopyWith(
    _$AuthAuthenticatedImpl value,
    $Res Function(_$AuthAuthenticatedImpl) then,
  ) = __$$AuthAuthenticatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    UserModel user,
    bool isEmailVerified,
    Map<String, dynamic>? permissions,
  });
}

/// @nodoc
class __$$AuthAuthenticatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthAuthenticatedImpl>
    implements _$$AuthAuthenticatedImplCopyWith<$Res> {
  __$$AuthAuthenticatedImplCopyWithImpl(
    _$AuthAuthenticatedImpl _value,
    $Res Function(_$AuthAuthenticatedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? isEmailVerified = null,
    Object? permissions = freezed,
  }) {
    return _then(
      _$AuthAuthenticatedImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        isEmailVerified: null == isEmailVerified
            ? _value.isEmailVerified
            : isEmailVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        permissions: freezed == permissions
            ? _value._permissions
            : permissions // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc

class _$AuthAuthenticatedImpl implements AuthAuthenticated {
  const _$AuthAuthenticatedImpl({
    required this.user,
    this.isEmailVerified = false,
    final Map<String, dynamic>? permissions,
  }) : _permissions = permissions;

  @override
  final UserModel user;
  @override
  @JsonKey()
  final bool isEmailVerified;
  final Map<String, dynamic>? _permissions;
  @override
  Map<String, dynamic>? get permissions {
    final value = _permissions;
    if (value == null) return null;
    if (_permissions is EqualUnmodifiableMapView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'AuthState.authenticated(user: $user, isEmailVerified: $isEmailVerified, permissions: $permissions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthAuthenticatedImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.isEmailVerified, isEmailVerified) ||
                other.isEmailVerified == isEmailVerified) &&
            const DeepCollectionEquality().equals(
              other._permissions,
              _permissions,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    user,
    isEmailVerified,
    const DeepCollectionEquality().hash(_permissions),
  );

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthAuthenticatedImplCopyWith<_$AuthAuthenticatedImpl> get copyWith =>
      __$$AuthAuthenticatedImplCopyWithImpl<_$AuthAuthenticatedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? operationType) loading,
    required TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )
    authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )
    error,
    required TResult Function() registering,
    required TResult Function(String email, bool needsEmailVerification)
    registrationComplete,
    required TResult Function(String email) passwordResetSent,
    required TResult Function() emailVerificationSent,
    required TResult Function(UserModel user) updatingProfile,
    required TResult Function(UserModel user) profileUpdated,
    required TResult Function(UserModel user) changingPassword,
    required TResult Function(UserModel user) passwordChanged,
    required TResult Function(String operation, UserModel user)
    reauthenticationRequired,
    required TResult Function(UserModel user) reauthenticating,
    required TResult Function(UserModel user) deletingAccount,
    required TResult Function() accountDeleted,
    required TResult Function(UserModel user, String provider) linkingAccount,
    required TResult Function(UserModel user, String provider) accountLinked,
    required TResult Function(UserModel user, String provider) unlinkingAccount,
    required TResult Function(UserModel user, String provider) accountUnlinked,
    required TResult Function(UserModel user, String newEmail) updatingEmail,
    required TResult Function(UserModel user, String newEmail) emailUpdated,
  }) {
    return authenticated(user, isEmailVerified, permissions);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? operationType)? loading,
    TResult? Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult? Function()? registering,
    TResult? Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult? Function(String email)? passwordResetSent,
    TResult? Function()? emailVerificationSent,
    TResult? Function(UserModel user)? updatingProfile,
    TResult? Function(UserModel user)? profileUpdated,
    TResult? Function(UserModel user)? changingPassword,
    TResult? Function(UserModel user)? passwordChanged,
    TResult? Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult? Function(UserModel user)? reauthenticating,
    TResult? Function(UserModel user)? deletingAccount,
    TResult? Function()? accountDeleted,
    TResult? Function(UserModel user, String provider)? linkingAccount,
    TResult? Function(UserModel user, String provider)? accountLinked,
    TResult? Function(UserModel user, String provider)? unlinkingAccount,
    TResult? Function(UserModel user, String provider)? accountUnlinked,
    TResult? Function(UserModel user, String newEmail)? updatingEmail,
    TResult? Function(UserModel user, String newEmail)? emailUpdated,
  }) {
    return authenticated?.call(user, isEmailVerified, permissions);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? operationType)? loading,
    TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult Function()? unauthenticated,
    TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult Function()? registering,
    TResult Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult Function(String email)? passwordResetSent,
    TResult Function()? emailVerificationSent,
    TResult Function(UserModel user)? updatingProfile,
    TResult Function(UserModel user)? profileUpdated,
    TResult Function(UserModel user)? changingPassword,
    TResult Function(UserModel user)? passwordChanged,
    TResult Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult Function(UserModel user)? reauthenticating,
    TResult Function(UserModel user)? deletingAccount,
    TResult Function()? accountDeleted,
    TResult Function(UserModel user, String provider)? linkingAccount,
    TResult Function(UserModel user, String provider)? accountLinked,
    TResult Function(UserModel user, String provider)? unlinkingAccount,
    TResult Function(UserModel user, String provider)? accountUnlinked,
    TResult Function(UserModel user, String newEmail)? updatingEmail,
    TResult Function(UserModel user, String newEmail)? emailUpdated,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(user, isEmailVerified, permissions);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthRegistering value) registering,
    required TResult Function(AuthRegistrationComplete value)
    registrationComplete,
    required TResult Function(AuthPasswordResetSent value) passwordResetSent,
    required TResult Function(AuthEmailVerificationSent value)
    emailVerificationSent,
    required TResult Function(AuthUpdatingProfile value) updatingProfile,
    required TResult Function(AuthProfileUpdated value) profileUpdated,
    required TResult Function(AuthChangingPassword value) changingPassword,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthReauthenticationRequired value)
    reauthenticationRequired,
    required TResult Function(AuthReauthenticating value) reauthenticating,
    required TResult Function(AuthDeletingAccount value) deletingAccount,
    required TResult Function(AuthAccountDeleted value) accountDeleted,
    required TResult Function(AuthLinkingAccount value) linkingAccount,
    required TResult Function(AuthAccountLinked value) accountLinked,
    required TResult Function(AuthUnlinkingAccount value) unlinkingAccount,
    required TResult Function(AuthAccountUnlinked value) accountUnlinked,
    required TResult Function(AuthUpdatingEmail value) updatingEmail,
    required TResult Function(AuthEmailUpdated value) emailUpdated,
  }) {
    return authenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthRegistering value)? registering,
    TResult? Function(AuthRegistrationComplete value)? registrationComplete,
    TResult? Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult? Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult? Function(AuthUpdatingProfile value)? updatingProfile,
    TResult? Function(AuthProfileUpdated value)? profileUpdated,
    TResult? Function(AuthChangingPassword value)? changingPassword,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult? Function(AuthReauthenticating value)? reauthenticating,
    TResult? Function(AuthDeletingAccount value)? deletingAccount,
    TResult? Function(AuthAccountDeleted value)? accountDeleted,
    TResult? Function(AuthLinkingAccount value)? linkingAccount,
    TResult? Function(AuthAccountLinked value)? accountLinked,
    TResult? Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult? Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult? Function(AuthUpdatingEmail value)? updatingEmail,
    TResult? Function(AuthEmailUpdated value)? emailUpdated,
  }) {
    return authenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? error,
    TResult Function(AuthRegistering value)? registering,
    TResult Function(AuthRegistrationComplete value)? registrationComplete,
    TResult Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult Function(AuthUpdatingProfile value)? updatingProfile,
    TResult Function(AuthProfileUpdated value)? profileUpdated,
    TResult Function(AuthChangingPassword value)? changingPassword,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult Function(AuthReauthenticating value)? reauthenticating,
    TResult Function(AuthDeletingAccount value)? deletingAccount,
    TResult Function(AuthAccountDeleted value)? accountDeleted,
    TResult Function(AuthLinkingAccount value)? linkingAccount,
    TResult Function(AuthAccountLinked value)? accountLinked,
    TResult Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult Function(AuthUpdatingEmail value)? updatingEmail,
    TResult Function(AuthEmailUpdated value)? emailUpdated,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(this);
    }
    return orElse();
  }
}

abstract class AuthAuthenticated implements AuthState {
  const factory AuthAuthenticated({
    required final UserModel user,
    final bool isEmailVerified,
    final Map<String, dynamic>? permissions,
  }) = _$AuthAuthenticatedImpl;

  UserModel get user;
  bool get isEmailVerified;
  Map<String, dynamic>? get permissions;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthAuthenticatedImplCopyWith<_$AuthAuthenticatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthUnauthenticatedImplCopyWith<$Res> {
  factory _$$AuthUnauthenticatedImplCopyWith(
    _$AuthUnauthenticatedImpl value,
    $Res Function(_$AuthUnauthenticatedImpl) then,
  ) = __$$AuthUnauthenticatedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthUnauthenticatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthUnauthenticatedImpl>
    implements _$$AuthUnauthenticatedImplCopyWith<$Res> {
  __$$AuthUnauthenticatedImplCopyWithImpl(
    _$AuthUnauthenticatedImpl _value,
    $Res Function(_$AuthUnauthenticatedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthUnauthenticatedImpl implements AuthUnauthenticated {
  const _$AuthUnauthenticatedImpl();

  @override
  String toString() {
    return 'AuthState.unauthenticated()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthUnauthenticatedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? operationType) loading,
    required TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )
    authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )
    error,
    required TResult Function() registering,
    required TResult Function(String email, bool needsEmailVerification)
    registrationComplete,
    required TResult Function(String email) passwordResetSent,
    required TResult Function() emailVerificationSent,
    required TResult Function(UserModel user) updatingProfile,
    required TResult Function(UserModel user) profileUpdated,
    required TResult Function(UserModel user) changingPassword,
    required TResult Function(UserModel user) passwordChanged,
    required TResult Function(String operation, UserModel user)
    reauthenticationRequired,
    required TResult Function(UserModel user) reauthenticating,
    required TResult Function(UserModel user) deletingAccount,
    required TResult Function() accountDeleted,
    required TResult Function(UserModel user, String provider) linkingAccount,
    required TResult Function(UserModel user, String provider) accountLinked,
    required TResult Function(UserModel user, String provider) unlinkingAccount,
    required TResult Function(UserModel user, String provider) accountUnlinked,
    required TResult Function(UserModel user, String newEmail) updatingEmail,
    required TResult Function(UserModel user, String newEmail) emailUpdated,
  }) {
    return unauthenticated();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? operationType)? loading,
    TResult? Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult? Function()? registering,
    TResult? Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult? Function(String email)? passwordResetSent,
    TResult? Function()? emailVerificationSent,
    TResult? Function(UserModel user)? updatingProfile,
    TResult? Function(UserModel user)? profileUpdated,
    TResult? Function(UserModel user)? changingPassword,
    TResult? Function(UserModel user)? passwordChanged,
    TResult? Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult? Function(UserModel user)? reauthenticating,
    TResult? Function(UserModel user)? deletingAccount,
    TResult? Function()? accountDeleted,
    TResult? Function(UserModel user, String provider)? linkingAccount,
    TResult? Function(UserModel user, String provider)? accountLinked,
    TResult? Function(UserModel user, String provider)? unlinkingAccount,
    TResult? Function(UserModel user, String provider)? accountUnlinked,
    TResult? Function(UserModel user, String newEmail)? updatingEmail,
    TResult? Function(UserModel user, String newEmail)? emailUpdated,
  }) {
    return unauthenticated?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? operationType)? loading,
    TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult Function()? unauthenticated,
    TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult Function()? registering,
    TResult Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult Function(String email)? passwordResetSent,
    TResult Function()? emailVerificationSent,
    TResult Function(UserModel user)? updatingProfile,
    TResult Function(UserModel user)? profileUpdated,
    TResult Function(UserModel user)? changingPassword,
    TResult Function(UserModel user)? passwordChanged,
    TResult Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult Function(UserModel user)? reauthenticating,
    TResult Function(UserModel user)? deletingAccount,
    TResult Function()? accountDeleted,
    TResult Function(UserModel user, String provider)? linkingAccount,
    TResult Function(UserModel user, String provider)? accountLinked,
    TResult Function(UserModel user, String provider)? unlinkingAccount,
    TResult Function(UserModel user, String provider)? accountUnlinked,
    TResult Function(UserModel user, String newEmail)? updatingEmail,
    TResult Function(UserModel user, String newEmail)? emailUpdated,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthRegistering value) registering,
    required TResult Function(AuthRegistrationComplete value)
    registrationComplete,
    required TResult Function(AuthPasswordResetSent value) passwordResetSent,
    required TResult Function(AuthEmailVerificationSent value)
    emailVerificationSent,
    required TResult Function(AuthUpdatingProfile value) updatingProfile,
    required TResult Function(AuthProfileUpdated value) profileUpdated,
    required TResult Function(AuthChangingPassword value) changingPassword,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthReauthenticationRequired value)
    reauthenticationRequired,
    required TResult Function(AuthReauthenticating value) reauthenticating,
    required TResult Function(AuthDeletingAccount value) deletingAccount,
    required TResult Function(AuthAccountDeleted value) accountDeleted,
    required TResult Function(AuthLinkingAccount value) linkingAccount,
    required TResult Function(AuthAccountLinked value) accountLinked,
    required TResult Function(AuthUnlinkingAccount value) unlinkingAccount,
    required TResult Function(AuthAccountUnlinked value) accountUnlinked,
    required TResult Function(AuthUpdatingEmail value) updatingEmail,
    required TResult Function(AuthEmailUpdated value) emailUpdated,
  }) {
    return unauthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthRegistering value)? registering,
    TResult? Function(AuthRegistrationComplete value)? registrationComplete,
    TResult? Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult? Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult? Function(AuthUpdatingProfile value)? updatingProfile,
    TResult? Function(AuthProfileUpdated value)? profileUpdated,
    TResult? Function(AuthChangingPassword value)? changingPassword,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult? Function(AuthReauthenticating value)? reauthenticating,
    TResult? Function(AuthDeletingAccount value)? deletingAccount,
    TResult? Function(AuthAccountDeleted value)? accountDeleted,
    TResult? Function(AuthLinkingAccount value)? linkingAccount,
    TResult? Function(AuthAccountLinked value)? accountLinked,
    TResult? Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult? Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult? Function(AuthUpdatingEmail value)? updatingEmail,
    TResult? Function(AuthEmailUpdated value)? emailUpdated,
  }) {
    return unauthenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? error,
    TResult Function(AuthRegistering value)? registering,
    TResult Function(AuthRegistrationComplete value)? registrationComplete,
    TResult Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult Function(AuthUpdatingProfile value)? updatingProfile,
    TResult Function(AuthProfileUpdated value)? profileUpdated,
    TResult Function(AuthChangingPassword value)? changingPassword,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult Function(AuthReauthenticating value)? reauthenticating,
    TResult Function(AuthDeletingAccount value)? deletingAccount,
    TResult Function(AuthAccountDeleted value)? accountDeleted,
    TResult Function(AuthLinkingAccount value)? linkingAccount,
    TResult Function(AuthAccountLinked value)? accountLinked,
    TResult Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult Function(AuthUpdatingEmail value)? updatingEmail,
    TResult Function(AuthEmailUpdated value)? emailUpdated,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated(this);
    }
    return orElse();
  }
}

abstract class AuthUnauthenticated implements AuthState {
  const factory AuthUnauthenticated() = _$AuthUnauthenticatedImpl;
}

/// @nodoc
abstract class _$$AuthErrorImplCopyWith<$Res> {
  factory _$$AuthErrorImplCopyWith(
    _$AuthErrorImpl value,
    $Res Function(_$AuthErrorImpl) then,
  ) = __$$AuthErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String message,
    bool canRetry,
    String? lastFailedOperation,
    UserModel? user,
  });
}

/// @nodoc
class __$$AuthErrorImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthErrorImpl>
    implements _$$AuthErrorImplCopyWith<$Res> {
  __$$AuthErrorImplCopyWithImpl(
    _$AuthErrorImpl _value,
    $Res Function(_$AuthErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? canRetry = null,
    Object? lastFailedOperation = freezed,
    Object? user = freezed,
  }) {
    return _then(
      _$AuthErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        canRetry: null == canRetry
            ? _value.canRetry
            : canRetry // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastFailedOperation: freezed == lastFailedOperation
            ? _value.lastFailedOperation
            : lastFailedOperation // ignore: cast_nullable_to_non_nullable
                  as String?,
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel?,
      ),
    );
  }
}

/// @nodoc

class _$AuthErrorImpl implements AuthError {
  const _$AuthErrorImpl({
    required this.message,
    this.canRetry = false,
    this.lastFailedOperation,
    this.user,
  });

  @override
  final String message;
  @override
  @JsonKey()
  final bool canRetry;
  @override
  final String? lastFailedOperation;
  @override
  final UserModel? user;

  @override
  String toString() {
    return 'AuthState.error(message: $message, canRetry: $canRetry, lastFailedOperation: $lastFailedOperation, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.canRetry, canRetry) ||
                other.canRetry == canRetry) &&
            (identical(other.lastFailedOperation, lastFailedOperation) ||
                other.lastFailedOperation == lastFailedOperation) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, message, canRetry, lastFailedOperation, user);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthErrorImplCopyWith<_$AuthErrorImpl> get copyWith =>
      __$$AuthErrorImplCopyWithImpl<_$AuthErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? operationType) loading,
    required TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )
    authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )
    error,
    required TResult Function() registering,
    required TResult Function(String email, bool needsEmailVerification)
    registrationComplete,
    required TResult Function(String email) passwordResetSent,
    required TResult Function() emailVerificationSent,
    required TResult Function(UserModel user) updatingProfile,
    required TResult Function(UserModel user) profileUpdated,
    required TResult Function(UserModel user) changingPassword,
    required TResult Function(UserModel user) passwordChanged,
    required TResult Function(String operation, UserModel user)
    reauthenticationRequired,
    required TResult Function(UserModel user) reauthenticating,
    required TResult Function(UserModel user) deletingAccount,
    required TResult Function() accountDeleted,
    required TResult Function(UserModel user, String provider) linkingAccount,
    required TResult Function(UserModel user, String provider) accountLinked,
    required TResult Function(UserModel user, String provider) unlinkingAccount,
    required TResult Function(UserModel user, String provider) accountUnlinked,
    required TResult Function(UserModel user, String newEmail) updatingEmail,
    required TResult Function(UserModel user, String newEmail) emailUpdated,
  }) {
    return error(message, canRetry, lastFailedOperation, user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? operationType)? loading,
    TResult? Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult? Function()? registering,
    TResult? Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult? Function(String email)? passwordResetSent,
    TResult? Function()? emailVerificationSent,
    TResult? Function(UserModel user)? updatingProfile,
    TResult? Function(UserModel user)? profileUpdated,
    TResult? Function(UserModel user)? changingPassword,
    TResult? Function(UserModel user)? passwordChanged,
    TResult? Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult? Function(UserModel user)? reauthenticating,
    TResult? Function(UserModel user)? deletingAccount,
    TResult? Function()? accountDeleted,
    TResult? Function(UserModel user, String provider)? linkingAccount,
    TResult? Function(UserModel user, String provider)? accountLinked,
    TResult? Function(UserModel user, String provider)? unlinkingAccount,
    TResult? Function(UserModel user, String provider)? accountUnlinked,
    TResult? Function(UserModel user, String newEmail)? updatingEmail,
    TResult? Function(UserModel user, String newEmail)? emailUpdated,
  }) {
    return error?.call(message, canRetry, lastFailedOperation, user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? operationType)? loading,
    TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult Function()? unauthenticated,
    TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult Function()? registering,
    TResult Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult Function(String email)? passwordResetSent,
    TResult Function()? emailVerificationSent,
    TResult Function(UserModel user)? updatingProfile,
    TResult Function(UserModel user)? profileUpdated,
    TResult Function(UserModel user)? changingPassword,
    TResult Function(UserModel user)? passwordChanged,
    TResult Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult Function(UserModel user)? reauthenticating,
    TResult Function(UserModel user)? deletingAccount,
    TResult Function()? accountDeleted,
    TResult Function(UserModel user, String provider)? linkingAccount,
    TResult Function(UserModel user, String provider)? accountLinked,
    TResult Function(UserModel user, String provider)? unlinkingAccount,
    TResult Function(UserModel user, String provider)? accountUnlinked,
    TResult Function(UserModel user, String newEmail)? updatingEmail,
    TResult Function(UserModel user, String newEmail)? emailUpdated,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message, canRetry, lastFailedOperation, user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthRegistering value) registering,
    required TResult Function(AuthRegistrationComplete value)
    registrationComplete,
    required TResult Function(AuthPasswordResetSent value) passwordResetSent,
    required TResult Function(AuthEmailVerificationSent value)
    emailVerificationSent,
    required TResult Function(AuthUpdatingProfile value) updatingProfile,
    required TResult Function(AuthProfileUpdated value) profileUpdated,
    required TResult Function(AuthChangingPassword value) changingPassword,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthReauthenticationRequired value)
    reauthenticationRequired,
    required TResult Function(AuthReauthenticating value) reauthenticating,
    required TResult Function(AuthDeletingAccount value) deletingAccount,
    required TResult Function(AuthAccountDeleted value) accountDeleted,
    required TResult Function(AuthLinkingAccount value) linkingAccount,
    required TResult Function(AuthAccountLinked value) accountLinked,
    required TResult Function(AuthUnlinkingAccount value) unlinkingAccount,
    required TResult Function(AuthAccountUnlinked value) accountUnlinked,
    required TResult Function(AuthUpdatingEmail value) updatingEmail,
    required TResult Function(AuthEmailUpdated value) emailUpdated,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthRegistering value)? registering,
    TResult? Function(AuthRegistrationComplete value)? registrationComplete,
    TResult? Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult? Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult? Function(AuthUpdatingProfile value)? updatingProfile,
    TResult? Function(AuthProfileUpdated value)? profileUpdated,
    TResult? Function(AuthChangingPassword value)? changingPassword,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult? Function(AuthReauthenticating value)? reauthenticating,
    TResult? Function(AuthDeletingAccount value)? deletingAccount,
    TResult? Function(AuthAccountDeleted value)? accountDeleted,
    TResult? Function(AuthLinkingAccount value)? linkingAccount,
    TResult? Function(AuthAccountLinked value)? accountLinked,
    TResult? Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult? Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult? Function(AuthUpdatingEmail value)? updatingEmail,
    TResult? Function(AuthEmailUpdated value)? emailUpdated,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? error,
    TResult Function(AuthRegistering value)? registering,
    TResult Function(AuthRegistrationComplete value)? registrationComplete,
    TResult Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult Function(AuthUpdatingProfile value)? updatingProfile,
    TResult Function(AuthProfileUpdated value)? profileUpdated,
    TResult Function(AuthChangingPassword value)? changingPassword,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult Function(AuthReauthenticating value)? reauthenticating,
    TResult Function(AuthDeletingAccount value)? deletingAccount,
    TResult Function(AuthAccountDeleted value)? accountDeleted,
    TResult Function(AuthLinkingAccount value)? linkingAccount,
    TResult Function(AuthAccountLinked value)? accountLinked,
    TResult Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult Function(AuthUpdatingEmail value)? updatingEmail,
    TResult Function(AuthEmailUpdated value)? emailUpdated,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class AuthError implements AuthState {
  const factory AuthError({
    required final String message,
    final bool canRetry,
    final String? lastFailedOperation,
    final UserModel? user,
  }) = _$AuthErrorImpl;

  String get message;
  bool get canRetry;
  String? get lastFailedOperation;
  UserModel? get user;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthErrorImplCopyWith<_$AuthErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthRegisteringImplCopyWith<$Res> {
  factory _$$AuthRegisteringImplCopyWith(
    _$AuthRegisteringImpl value,
    $Res Function(_$AuthRegisteringImpl) then,
  ) = __$$AuthRegisteringImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthRegisteringImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthRegisteringImpl>
    implements _$$AuthRegisteringImplCopyWith<$Res> {
  __$$AuthRegisteringImplCopyWithImpl(
    _$AuthRegisteringImpl _value,
    $Res Function(_$AuthRegisteringImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthRegisteringImpl implements AuthRegistering {
  const _$AuthRegisteringImpl();

  @override
  String toString() {
    return 'AuthState.registering()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthRegisteringImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? operationType) loading,
    required TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )
    authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )
    error,
    required TResult Function() registering,
    required TResult Function(String email, bool needsEmailVerification)
    registrationComplete,
    required TResult Function(String email) passwordResetSent,
    required TResult Function() emailVerificationSent,
    required TResult Function(UserModel user) updatingProfile,
    required TResult Function(UserModel user) profileUpdated,
    required TResult Function(UserModel user) changingPassword,
    required TResult Function(UserModel user) passwordChanged,
    required TResult Function(String operation, UserModel user)
    reauthenticationRequired,
    required TResult Function(UserModel user) reauthenticating,
    required TResult Function(UserModel user) deletingAccount,
    required TResult Function() accountDeleted,
    required TResult Function(UserModel user, String provider) linkingAccount,
    required TResult Function(UserModel user, String provider) accountLinked,
    required TResult Function(UserModel user, String provider) unlinkingAccount,
    required TResult Function(UserModel user, String provider) accountUnlinked,
    required TResult Function(UserModel user, String newEmail) updatingEmail,
    required TResult Function(UserModel user, String newEmail) emailUpdated,
  }) {
    return registering();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? operationType)? loading,
    TResult? Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult? Function()? registering,
    TResult? Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult? Function(String email)? passwordResetSent,
    TResult? Function()? emailVerificationSent,
    TResult? Function(UserModel user)? updatingProfile,
    TResult? Function(UserModel user)? profileUpdated,
    TResult? Function(UserModel user)? changingPassword,
    TResult? Function(UserModel user)? passwordChanged,
    TResult? Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult? Function(UserModel user)? reauthenticating,
    TResult? Function(UserModel user)? deletingAccount,
    TResult? Function()? accountDeleted,
    TResult? Function(UserModel user, String provider)? linkingAccount,
    TResult? Function(UserModel user, String provider)? accountLinked,
    TResult? Function(UserModel user, String provider)? unlinkingAccount,
    TResult? Function(UserModel user, String provider)? accountUnlinked,
    TResult? Function(UserModel user, String newEmail)? updatingEmail,
    TResult? Function(UserModel user, String newEmail)? emailUpdated,
  }) {
    return registering?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? operationType)? loading,
    TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult Function()? unauthenticated,
    TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult Function()? registering,
    TResult Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult Function(String email)? passwordResetSent,
    TResult Function()? emailVerificationSent,
    TResult Function(UserModel user)? updatingProfile,
    TResult Function(UserModel user)? profileUpdated,
    TResult Function(UserModel user)? changingPassword,
    TResult Function(UserModel user)? passwordChanged,
    TResult Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult Function(UserModel user)? reauthenticating,
    TResult Function(UserModel user)? deletingAccount,
    TResult Function()? accountDeleted,
    TResult Function(UserModel user, String provider)? linkingAccount,
    TResult Function(UserModel user, String provider)? accountLinked,
    TResult Function(UserModel user, String provider)? unlinkingAccount,
    TResult Function(UserModel user, String provider)? accountUnlinked,
    TResult Function(UserModel user, String newEmail)? updatingEmail,
    TResult Function(UserModel user, String newEmail)? emailUpdated,
    required TResult orElse(),
  }) {
    if (registering != null) {
      return registering();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthRegistering value) registering,
    required TResult Function(AuthRegistrationComplete value)
    registrationComplete,
    required TResult Function(AuthPasswordResetSent value) passwordResetSent,
    required TResult Function(AuthEmailVerificationSent value)
    emailVerificationSent,
    required TResult Function(AuthUpdatingProfile value) updatingProfile,
    required TResult Function(AuthProfileUpdated value) profileUpdated,
    required TResult Function(AuthChangingPassword value) changingPassword,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthReauthenticationRequired value)
    reauthenticationRequired,
    required TResult Function(AuthReauthenticating value) reauthenticating,
    required TResult Function(AuthDeletingAccount value) deletingAccount,
    required TResult Function(AuthAccountDeleted value) accountDeleted,
    required TResult Function(AuthLinkingAccount value) linkingAccount,
    required TResult Function(AuthAccountLinked value) accountLinked,
    required TResult Function(AuthUnlinkingAccount value) unlinkingAccount,
    required TResult Function(AuthAccountUnlinked value) accountUnlinked,
    required TResult Function(AuthUpdatingEmail value) updatingEmail,
    required TResult Function(AuthEmailUpdated value) emailUpdated,
  }) {
    return registering(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthRegistering value)? registering,
    TResult? Function(AuthRegistrationComplete value)? registrationComplete,
    TResult? Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult? Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult? Function(AuthUpdatingProfile value)? updatingProfile,
    TResult? Function(AuthProfileUpdated value)? profileUpdated,
    TResult? Function(AuthChangingPassword value)? changingPassword,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult? Function(AuthReauthenticating value)? reauthenticating,
    TResult? Function(AuthDeletingAccount value)? deletingAccount,
    TResult? Function(AuthAccountDeleted value)? accountDeleted,
    TResult? Function(AuthLinkingAccount value)? linkingAccount,
    TResult? Function(AuthAccountLinked value)? accountLinked,
    TResult? Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult? Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult? Function(AuthUpdatingEmail value)? updatingEmail,
    TResult? Function(AuthEmailUpdated value)? emailUpdated,
  }) {
    return registering?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? error,
    TResult Function(AuthRegistering value)? registering,
    TResult Function(AuthRegistrationComplete value)? registrationComplete,
    TResult Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult Function(AuthUpdatingProfile value)? updatingProfile,
    TResult Function(AuthProfileUpdated value)? profileUpdated,
    TResult Function(AuthChangingPassword value)? changingPassword,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult Function(AuthReauthenticating value)? reauthenticating,
    TResult Function(AuthDeletingAccount value)? deletingAccount,
    TResult Function(AuthAccountDeleted value)? accountDeleted,
    TResult Function(AuthLinkingAccount value)? linkingAccount,
    TResult Function(AuthAccountLinked value)? accountLinked,
    TResult Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult Function(AuthUpdatingEmail value)? updatingEmail,
    TResult Function(AuthEmailUpdated value)? emailUpdated,
    required TResult orElse(),
  }) {
    if (registering != null) {
      return registering(this);
    }
    return orElse();
  }
}

abstract class AuthRegistering implements AuthState {
  const factory AuthRegistering() = _$AuthRegisteringImpl;
}

/// @nodoc
abstract class _$$AuthRegistrationCompleteImplCopyWith<$Res> {
  factory _$$AuthRegistrationCompleteImplCopyWith(
    _$AuthRegistrationCompleteImpl value,
    $Res Function(_$AuthRegistrationCompleteImpl) then,
  ) = __$$AuthRegistrationCompleteImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email, bool needsEmailVerification});
}

/// @nodoc
class __$$AuthRegistrationCompleteImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthRegistrationCompleteImpl>
    implements _$$AuthRegistrationCompleteImplCopyWith<$Res> {
  __$$AuthRegistrationCompleteImplCopyWithImpl(
    _$AuthRegistrationCompleteImpl _value,
    $Res Function(_$AuthRegistrationCompleteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? needsEmailVerification = null}) {
    return _then(
      _$AuthRegistrationCompleteImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        needsEmailVerification: null == needsEmailVerification
            ? _value.needsEmailVerification
            : needsEmailVerification // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$AuthRegistrationCompleteImpl implements AuthRegistrationComplete {
  const _$AuthRegistrationCompleteImpl({
    required this.email,
    this.needsEmailVerification = false,
  });

  @override
  final String email;
  @override
  @JsonKey()
  final bool needsEmailVerification;

  @override
  String toString() {
    return 'AuthState.registrationComplete(email: $email, needsEmailVerification: $needsEmailVerification)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthRegistrationCompleteImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.needsEmailVerification, needsEmailVerification) ||
                other.needsEmailVerification == needsEmailVerification));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, needsEmailVerification);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthRegistrationCompleteImplCopyWith<_$AuthRegistrationCompleteImpl>
  get copyWith =>
      __$$AuthRegistrationCompleteImplCopyWithImpl<
        _$AuthRegistrationCompleteImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? operationType) loading,
    required TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )
    authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )
    error,
    required TResult Function() registering,
    required TResult Function(String email, bool needsEmailVerification)
    registrationComplete,
    required TResult Function(String email) passwordResetSent,
    required TResult Function() emailVerificationSent,
    required TResult Function(UserModel user) updatingProfile,
    required TResult Function(UserModel user) profileUpdated,
    required TResult Function(UserModel user) changingPassword,
    required TResult Function(UserModel user) passwordChanged,
    required TResult Function(String operation, UserModel user)
    reauthenticationRequired,
    required TResult Function(UserModel user) reauthenticating,
    required TResult Function(UserModel user) deletingAccount,
    required TResult Function() accountDeleted,
    required TResult Function(UserModel user, String provider) linkingAccount,
    required TResult Function(UserModel user, String provider) accountLinked,
    required TResult Function(UserModel user, String provider) unlinkingAccount,
    required TResult Function(UserModel user, String provider) accountUnlinked,
    required TResult Function(UserModel user, String newEmail) updatingEmail,
    required TResult Function(UserModel user, String newEmail) emailUpdated,
  }) {
    return registrationComplete(email, needsEmailVerification);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? operationType)? loading,
    TResult? Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult? Function()? registering,
    TResult? Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult? Function(String email)? passwordResetSent,
    TResult? Function()? emailVerificationSent,
    TResult? Function(UserModel user)? updatingProfile,
    TResult? Function(UserModel user)? profileUpdated,
    TResult? Function(UserModel user)? changingPassword,
    TResult? Function(UserModel user)? passwordChanged,
    TResult? Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult? Function(UserModel user)? reauthenticating,
    TResult? Function(UserModel user)? deletingAccount,
    TResult? Function()? accountDeleted,
    TResult? Function(UserModel user, String provider)? linkingAccount,
    TResult? Function(UserModel user, String provider)? accountLinked,
    TResult? Function(UserModel user, String provider)? unlinkingAccount,
    TResult? Function(UserModel user, String provider)? accountUnlinked,
    TResult? Function(UserModel user, String newEmail)? updatingEmail,
    TResult? Function(UserModel user, String newEmail)? emailUpdated,
  }) {
    return registrationComplete?.call(email, needsEmailVerification);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? operationType)? loading,
    TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult Function()? unauthenticated,
    TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult Function()? registering,
    TResult Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult Function(String email)? passwordResetSent,
    TResult Function()? emailVerificationSent,
    TResult Function(UserModel user)? updatingProfile,
    TResult Function(UserModel user)? profileUpdated,
    TResult Function(UserModel user)? changingPassword,
    TResult Function(UserModel user)? passwordChanged,
    TResult Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult Function(UserModel user)? reauthenticating,
    TResult Function(UserModel user)? deletingAccount,
    TResult Function()? accountDeleted,
    TResult Function(UserModel user, String provider)? linkingAccount,
    TResult Function(UserModel user, String provider)? accountLinked,
    TResult Function(UserModel user, String provider)? unlinkingAccount,
    TResult Function(UserModel user, String provider)? accountUnlinked,
    TResult Function(UserModel user, String newEmail)? updatingEmail,
    TResult Function(UserModel user, String newEmail)? emailUpdated,
    required TResult orElse(),
  }) {
    if (registrationComplete != null) {
      return registrationComplete(email, needsEmailVerification);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthRegistering value) registering,
    required TResult Function(AuthRegistrationComplete value)
    registrationComplete,
    required TResult Function(AuthPasswordResetSent value) passwordResetSent,
    required TResult Function(AuthEmailVerificationSent value)
    emailVerificationSent,
    required TResult Function(AuthUpdatingProfile value) updatingProfile,
    required TResult Function(AuthProfileUpdated value) profileUpdated,
    required TResult Function(AuthChangingPassword value) changingPassword,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthReauthenticationRequired value)
    reauthenticationRequired,
    required TResult Function(AuthReauthenticating value) reauthenticating,
    required TResult Function(AuthDeletingAccount value) deletingAccount,
    required TResult Function(AuthAccountDeleted value) accountDeleted,
    required TResult Function(AuthLinkingAccount value) linkingAccount,
    required TResult Function(AuthAccountLinked value) accountLinked,
    required TResult Function(AuthUnlinkingAccount value) unlinkingAccount,
    required TResult Function(AuthAccountUnlinked value) accountUnlinked,
    required TResult Function(AuthUpdatingEmail value) updatingEmail,
    required TResult Function(AuthEmailUpdated value) emailUpdated,
  }) {
    return registrationComplete(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthRegistering value)? registering,
    TResult? Function(AuthRegistrationComplete value)? registrationComplete,
    TResult? Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult? Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult? Function(AuthUpdatingProfile value)? updatingProfile,
    TResult? Function(AuthProfileUpdated value)? profileUpdated,
    TResult? Function(AuthChangingPassword value)? changingPassword,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult? Function(AuthReauthenticating value)? reauthenticating,
    TResult? Function(AuthDeletingAccount value)? deletingAccount,
    TResult? Function(AuthAccountDeleted value)? accountDeleted,
    TResult? Function(AuthLinkingAccount value)? linkingAccount,
    TResult? Function(AuthAccountLinked value)? accountLinked,
    TResult? Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult? Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult? Function(AuthUpdatingEmail value)? updatingEmail,
    TResult? Function(AuthEmailUpdated value)? emailUpdated,
  }) {
    return registrationComplete?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? error,
    TResult Function(AuthRegistering value)? registering,
    TResult Function(AuthRegistrationComplete value)? registrationComplete,
    TResult Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult Function(AuthUpdatingProfile value)? updatingProfile,
    TResult Function(AuthProfileUpdated value)? profileUpdated,
    TResult Function(AuthChangingPassword value)? changingPassword,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult Function(AuthReauthenticating value)? reauthenticating,
    TResult Function(AuthDeletingAccount value)? deletingAccount,
    TResult Function(AuthAccountDeleted value)? accountDeleted,
    TResult Function(AuthLinkingAccount value)? linkingAccount,
    TResult Function(AuthAccountLinked value)? accountLinked,
    TResult Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult Function(AuthUpdatingEmail value)? updatingEmail,
    TResult Function(AuthEmailUpdated value)? emailUpdated,
    required TResult orElse(),
  }) {
    if (registrationComplete != null) {
      return registrationComplete(this);
    }
    return orElse();
  }
}

abstract class AuthRegistrationComplete implements AuthState {
  const factory AuthRegistrationComplete({
    required final String email,
    final bool needsEmailVerification,
  }) = _$AuthRegistrationCompleteImpl;

  String get email;
  bool get needsEmailVerification;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthRegistrationCompleteImplCopyWith<_$AuthRegistrationCompleteImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthPasswordResetSentImplCopyWith<$Res> {
  factory _$$AuthPasswordResetSentImplCopyWith(
    _$AuthPasswordResetSentImpl value,
    $Res Function(_$AuthPasswordResetSentImpl) then,
  ) = __$$AuthPasswordResetSentImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email});
}

/// @nodoc
class __$$AuthPasswordResetSentImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthPasswordResetSentImpl>
    implements _$$AuthPasswordResetSentImplCopyWith<$Res> {
  __$$AuthPasswordResetSentImplCopyWithImpl(
    _$AuthPasswordResetSentImpl _value,
    $Res Function(_$AuthPasswordResetSentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null}) {
    return _then(
      _$AuthPasswordResetSentImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$AuthPasswordResetSentImpl implements AuthPasswordResetSent {
  const _$AuthPasswordResetSentImpl({required this.email});

  @override
  final String email;

  @override
  String toString() {
    return 'AuthState.passwordResetSent(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthPasswordResetSentImpl &&
            (identical(other.email, email) || other.email == email));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthPasswordResetSentImplCopyWith<_$AuthPasswordResetSentImpl>
  get copyWith =>
      __$$AuthPasswordResetSentImplCopyWithImpl<_$AuthPasswordResetSentImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? operationType) loading,
    required TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )
    authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )
    error,
    required TResult Function() registering,
    required TResult Function(String email, bool needsEmailVerification)
    registrationComplete,
    required TResult Function(String email) passwordResetSent,
    required TResult Function() emailVerificationSent,
    required TResult Function(UserModel user) updatingProfile,
    required TResult Function(UserModel user) profileUpdated,
    required TResult Function(UserModel user) changingPassword,
    required TResult Function(UserModel user) passwordChanged,
    required TResult Function(String operation, UserModel user)
    reauthenticationRequired,
    required TResult Function(UserModel user) reauthenticating,
    required TResult Function(UserModel user) deletingAccount,
    required TResult Function() accountDeleted,
    required TResult Function(UserModel user, String provider) linkingAccount,
    required TResult Function(UserModel user, String provider) accountLinked,
    required TResult Function(UserModel user, String provider) unlinkingAccount,
    required TResult Function(UserModel user, String provider) accountUnlinked,
    required TResult Function(UserModel user, String newEmail) updatingEmail,
    required TResult Function(UserModel user, String newEmail) emailUpdated,
  }) {
    return passwordResetSent(email);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? operationType)? loading,
    TResult? Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult? Function()? registering,
    TResult? Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult? Function(String email)? passwordResetSent,
    TResult? Function()? emailVerificationSent,
    TResult? Function(UserModel user)? updatingProfile,
    TResult? Function(UserModel user)? profileUpdated,
    TResult? Function(UserModel user)? changingPassword,
    TResult? Function(UserModel user)? passwordChanged,
    TResult? Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult? Function(UserModel user)? reauthenticating,
    TResult? Function(UserModel user)? deletingAccount,
    TResult? Function()? accountDeleted,
    TResult? Function(UserModel user, String provider)? linkingAccount,
    TResult? Function(UserModel user, String provider)? accountLinked,
    TResult? Function(UserModel user, String provider)? unlinkingAccount,
    TResult? Function(UserModel user, String provider)? accountUnlinked,
    TResult? Function(UserModel user, String newEmail)? updatingEmail,
    TResult? Function(UserModel user, String newEmail)? emailUpdated,
  }) {
    return passwordResetSent?.call(email);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? operationType)? loading,
    TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult Function()? unauthenticated,
    TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult Function()? registering,
    TResult Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult Function(String email)? passwordResetSent,
    TResult Function()? emailVerificationSent,
    TResult Function(UserModel user)? updatingProfile,
    TResult Function(UserModel user)? profileUpdated,
    TResult Function(UserModel user)? changingPassword,
    TResult Function(UserModel user)? passwordChanged,
    TResult Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult Function(UserModel user)? reauthenticating,
    TResult Function(UserModel user)? deletingAccount,
    TResult Function()? accountDeleted,
    TResult Function(UserModel user, String provider)? linkingAccount,
    TResult Function(UserModel user, String provider)? accountLinked,
    TResult Function(UserModel user, String provider)? unlinkingAccount,
    TResult Function(UserModel user, String provider)? accountUnlinked,
    TResult Function(UserModel user, String newEmail)? updatingEmail,
    TResult Function(UserModel user, String newEmail)? emailUpdated,
    required TResult orElse(),
  }) {
    if (passwordResetSent != null) {
      return passwordResetSent(email);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthRegistering value) registering,
    required TResult Function(AuthRegistrationComplete value)
    registrationComplete,
    required TResult Function(AuthPasswordResetSent value) passwordResetSent,
    required TResult Function(AuthEmailVerificationSent value)
    emailVerificationSent,
    required TResult Function(AuthUpdatingProfile value) updatingProfile,
    required TResult Function(AuthProfileUpdated value) profileUpdated,
    required TResult Function(AuthChangingPassword value) changingPassword,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthReauthenticationRequired value)
    reauthenticationRequired,
    required TResult Function(AuthReauthenticating value) reauthenticating,
    required TResult Function(AuthDeletingAccount value) deletingAccount,
    required TResult Function(AuthAccountDeleted value) accountDeleted,
    required TResult Function(AuthLinkingAccount value) linkingAccount,
    required TResult Function(AuthAccountLinked value) accountLinked,
    required TResult Function(AuthUnlinkingAccount value) unlinkingAccount,
    required TResult Function(AuthAccountUnlinked value) accountUnlinked,
    required TResult Function(AuthUpdatingEmail value) updatingEmail,
    required TResult Function(AuthEmailUpdated value) emailUpdated,
  }) {
    return passwordResetSent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthRegistering value)? registering,
    TResult? Function(AuthRegistrationComplete value)? registrationComplete,
    TResult? Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult? Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult? Function(AuthUpdatingProfile value)? updatingProfile,
    TResult? Function(AuthProfileUpdated value)? profileUpdated,
    TResult? Function(AuthChangingPassword value)? changingPassword,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult? Function(AuthReauthenticating value)? reauthenticating,
    TResult? Function(AuthDeletingAccount value)? deletingAccount,
    TResult? Function(AuthAccountDeleted value)? accountDeleted,
    TResult? Function(AuthLinkingAccount value)? linkingAccount,
    TResult? Function(AuthAccountLinked value)? accountLinked,
    TResult? Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult? Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult? Function(AuthUpdatingEmail value)? updatingEmail,
    TResult? Function(AuthEmailUpdated value)? emailUpdated,
  }) {
    return passwordResetSent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? error,
    TResult Function(AuthRegistering value)? registering,
    TResult Function(AuthRegistrationComplete value)? registrationComplete,
    TResult Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult Function(AuthUpdatingProfile value)? updatingProfile,
    TResult Function(AuthProfileUpdated value)? profileUpdated,
    TResult Function(AuthChangingPassword value)? changingPassword,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult Function(AuthReauthenticating value)? reauthenticating,
    TResult Function(AuthDeletingAccount value)? deletingAccount,
    TResult Function(AuthAccountDeleted value)? accountDeleted,
    TResult Function(AuthLinkingAccount value)? linkingAccount,
    TResult Function(AuthAccountLinked value)? accountLinked,
    TResult Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult Function(AuthUpdatingEmail value)? updatingEmail,
    TResult Function(AuthEmailUpdated value)? emailUpdated,
    required TResult orElse(),
  }) {
    if (passwordResetSent != null) {
      return passwordResetSent(this);
    }
    return orElse();
  }
}

abstract class AuthPasswordResetSent implements AuthState {
  const factory AuthPasswordResetSent({required final String email}) =
      _$AuthPasswordResetSentImpl;

  String get email;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthPasswordResetSentImplCopyWith<_$AuthPasswordResetSentImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthEmailVerificationSentImplCopyWith<$Res> {
  factory _$$AuthEmailVerificationSentImplCopyWith(
    _$AuthEmailVerificationSentImpl value,
    $Res Function(_$AuthEmailVerificationSentImpl) then,
  ) = __$$AuthEmailVerificationSentImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthEmailVerificationSentImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthEmailVerificationSentImpl>
    implements _$$AuthEmailVerificationSentImplCopyWith<$Res> {
  __$$AuthEmailVerificationSentImplCopyWithImpl(
    _$AuthEmailVerificationSentImpl _value,
    $Res Function(_$AuthEmailVerificationSentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthEmailVerificationSentImpl implements AuthEmailVerificationSent {
  const _$AuthEmailVerificationSentImpl();

  @override
  String toString() {
    return 'AuthState.emailVerificationSent()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthEmailVerificationSentImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? operationType) loading,
    required TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )
    authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )
    error,
    required TResult Function() registering,
    required TResult Function(String email, bool needsEmailVerification)
    registrationComplete,
    required TResult Function(String email) passwordResetSent,
    required TResult Function() emailVerificationSent,
    required TResult Function(UserModel user) updatingProfile,
    required TResult Function(UserModel user) profileUpdated,
    required TResult Function(UserModel user) changingPassword,
    required TResult Function(UserModel user) passwordChanged,
    required TResult Function(String operation, UserModel user)
    reauthenticationRequired,
    required TResult Function(UserModel user) reauthenticating,
    required TResult Function(UserModel user) deletingAccount,
    required TResult Function() accountDeleted,
    required TResult Function(UserModel user, String provider) linkingAccount,
    required TResult Function(UserModel user, String provider) accountLinked,
    required TResult Function(UserModel user, String provider) unlinkingAccount,
    required TResult Function(UserModel user, String provider) accountUnlinked,
    required TResult Function(UserModel user, String newEmail) updatingEmail,
    required TResult Function(UserModel user, String newEmail) emailUpdated,
  }) {
    return emailVerificationSent();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? operationType)? loading,
    TResult? Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult? Function()? registering,
    TResult? Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult? Function(String email)? passwordResetSent,
    TResult? Function()? emailVerificationSent,
    TResult? Function(UserModel user)? updatingProfile,
    TResult? Function(UserModel user)? profileUpdated,
    TResult? Function(UserModel user)? changingPassword,
    TResult? Function(UserModel user)? passwordChanged,
    TResult? Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult? Function(UserModel user)? reauthenticating,
    TResult? Function(UserModel user)? deletingAccount,
    TResult? Function()? accountDeleted,
    TResult? Function(UserModel user, String provider)? linkingAccount,
    TResult? Function(UserModel user, String provider)? accountLinked,
    TResult? Function(UserModel user, String provider)? unlinkingAccount,
    TResult? Function(UserModel user, String provider)? accountUnlinked,
    TResult? Function(UserModel user, String newEmail)? updatingEmail,
    TResult? Function(UserModel user, String newEmail)? emailUpdated,
  }) {
    return emailVerificationSent?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? operationType)? loading,
    TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult Function()? unauthenticated,
    TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult Function()? registering,
    TResult Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult Function(String email)? passwordResetSent,
    TResult Function()? emailVerificationSent,
    TResult Function(UserModel user)? updatingProfile,
    TResult Function(UserModel user)? profileUpdated,
    TResult Function(UserModel user)? changingPassword,
    TResult Function(UserModel user)? passwordChanged,
    TResult Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult Function(UserModel user)? reauthenticating,
    TResult Function(UserModel user)? deletingAccount,
    TResult Function()? accountDeleted,
    TResult Function(UserModel user, String provider)? linkingAccount,
    TResult Function(UserModel user, String provider)? accountLinked,
    TResult Function(UserModel user, String provider)? unlinkingAccount,
    TResult Function(UserModel user, String provider)? accountUnlinked,
    TResult Function(UserModel user, String newEmail)? updatingEmail,
    TResult Function(UserModel user, String newEmail)? emailUpdated,
    required TResult orElse(),
  }) {
    if (emailVerificationSent != null) {
      return emailVerificationSent();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthRegistering value) registering,
    required TResult Function(AuthRegistrationComplete value)
    registrationComplete,
    required TResult Function(AuthPasswordResetSent value) passwordResetSent,
    required TResult Function(AuthEmailVerificationSent value)
    emailVerificationSent,
    required TResult Function(AuthUpdatingProfile value) updatingProfile,
    required TResult Function(AuthProfileUpdated value) profileUpdated,
    required TResult Function(AuthChangingPassword value) changingPassword,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthReauthenticationRequired value)
    reauthenticationRequired,
    required TResult Function(AuthReauthenticating value) reauthenticating,
    required TResult Function(AuthDeletingAccount value) deletingAccount,
    required TResult Function(AuthAccountDeleted value) accountDeleted,
    required TResult Function(AuthLinkingAccount value) linkingAccount,
    required TResult Function(AuthAccountLinked value) accountLinked,
    required TResult Function(AuthUnlinkingAccount value) unlinkingAccount,
    required TResult Function(AuthAccountUnlinked value) accountUnlinked,
    required TResult Function(AuthUpdatingEmail value) updatingEmail,
    required TResult Function(AuthEmailUpdated value) emailUpdated,
  }) {
    return emailVerificationSent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthRegistering value)? registering,
    TResult? Function(AuthRegistrationComplete value)? registrationComplete,
    TResult? Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult? Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult? Function(AuthUpdatingProfile value)? updatingProfile,
    TResult? Function(AuthProfileUpdated value)? profileUpdated,
    TResult? Function(AuthChangingPassword value)? changingPassword,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult? Function(AuthReauthenticating value)? reauthenticating,
    TResult? Function(AuthDeletingAccount value)? deletingAccount,
    TResult? Function(AuthAccountDeleted value)? accountDeleted,
    TResult? Function(AuthLinkingAccount value)? linkingAccount,
    TResult? Function(AuthAccountLinked value)? accountLinked,
    TResult? Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult? Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult? Function(AuthUpdatingEmail value)? updatingEmail,
    TResult? Function(AuthEmailUpdated value)? emailUpdated,
  }) {
    return emailVerificationSent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? error,
    TResult Function(AuthRegistering value)? registering,
    TResult Function(AuthRegistrationComplete value)? registrationComplete,
    TResult Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult Function(AuthUpdatingProfile value)? updatingProfile,
    TResult Function(AuthProfileUpdated value)? profileUpdated,
    TResult Function(AuthChangingPassword value)? changingPassword,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult Function(AuthReauthenticating value)? reauthenticating,
    TResult Function(AuthDeletingAccount value)? deletingAccount,
    TResult Function(AuthAccountDeleted value)? accountDeleted,
    TResult Function(AuthLinkingAccount value)? linkingAccount,
    TResult Function(AuthAccountLinked value)? accountLinked,
    TResult Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult Function(AuthUpdatingEmail value)? updatingEmail,
    TResult Function(AuthEmailUpdated value)? emailUpdated,
    required TResult orElse(),
  }) {
    if (emailVerificationSent != null) {
      return emailVerificationSent(this);
    }
    return orElse();
  }
}

abstract class AuthEmailVerificationSent implements AuthState {
  const factory AuthEmailVerificationSent() = _$AuthEmailVerificationSentImpl;
}

/// @nodoc
abstract class _$$AuthUpdatingProfileImplCopyWith<$Res> {
  factory _$$AuthUpdatingProfileImplCopyWith(
    _$AuthUpdatingProfileImpl value,
    $Res Function(_$AuthUpdatingProfileImpl) then,
  ) = __$$AuthUpdatingProfileImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UserModel user});
}

/// @nodoc
class __$$AuthUpdatingProfileImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthUpdatingProfileImpl>
    implements _$$AuthUpdatingProfileImplCopyWith<$Res> {
  __$$AuthUpdatingProfileImplCopyWithImpl(
    _$AuthUpdatingProfileImpl _value,
    $Res Function(_$AuthUpdatingProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null}) {
    return _then(
      _$AuthUpdatingProfileImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
      ),
    );
  }
}

/// @nodoc

class _$AuthUpdatingProfileImpl implements AuthUpdatingProfile {
  const _$AuthUpdatingProfileImpl({required this.user});

  @override
  final UserModel user;

  @override
  String toString() {
    return 'AuthState.updatingProfile(user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthUpdatingProfileImpl &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthUpdatingProfileImplCopyWith<_$AuthUpdatingProfileImpl> get copyWith =>
      __$$AuthUpdatingProfileImplCopyWithImpl<_$AuthUpdatingProfileImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? operationType) loading,
    required TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )
    authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )
    error,
    required TResult Function() registering,
    required TResult Function(String email, bool needsEmailVerification)
    registrationComplete,
    required TResult Function(String email) passwordResetSent,
    required TResult Function() emailVerificationSent,
    required TResult Function(UserModel user) updatingProfile,
    required TResult Function(UserModel user) profileUpdated,
    required TResult Function(UserModel user) changingPassword,
    required TResult Function(UserModel user) passwordChanged,
    required TResult Function(String operation, UserModel user)
    reauthenticationRequired,
    required TResult Function(UserModel user) reauthenticating,
    required TResult Function(UserModel user) deletingAccount,
    required TResult Function() accountDeleted,
    required TResult Function(UserModel user, String provider) linkingAccount,
    required TResult Function(UserModel user, String provider) accountLinked,
    required TResult Function(UserModel user, String provider) unlinkingAccount,
    required TResult Function(UserModel user, String provider) accountUnlinked,
    required TResult Function(UserModel user, String newEmail) updatingEmail,
    required TResult Function(UserModel user, String newEmail) emailUpdated,
  }) {
    return updatingProfile(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? operationType)? loading,
    TResult? Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult? Function()? registering,
    TResult? Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult? Function(String email)? passwordResetSent,
    TResult? Function()? emailVerificationSent,
    TResult? Function(UserModel user)? updatingProfile,
    TResult? Function(UserModel user)? profileUpdated,
    TResult? Function(UserModel user)? changingPassword,
    TResult? Function(UserModel user)? passwordChanged,
    TResult? Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult? Function(UserModel user)? reauthenticating,
    TResult? Function(UserModel user)? deletingAccount,
    TResult? Function()? accountDeleted,
    TResult? Function(UserModel user, String provider)? linkingAccount,
    TResult? Function(UserModel user, String provider)? accountLinked,
    TResult? Function(UserModel user, String provider)? unlinkingAccount,
    TResult? Function(UserModel user, String provider)? accountUnlinked,
    TResult? Function(UserModel user, String newEmail)? updatingEmail,
    TResult? Function(UserModel user, String newEmail)? emailUpdated,
  }) {
    return updatingProfile?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? operationType)? loading,
    TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult Function()? unauthenticated,
    TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult Function()? registering,
    TResult Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult Function(String email)? passwordResetSent,
    TResult Function()? emailVerificationSent,
    TResult Function(UserModel user)? updatingProfile,
    TResult Function(UserModel user)? profileUpdated,
    TResult Function(UserModel user)? changingPassword,
    TResult Function(UserModel user)? passwordChanged,
    TResult Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult Function(UserModel user)? reauthenticating,
    TResult Function(UserModel user)? deletingAccount,
    TResult Function()? accountDeleted,
    TResult Function(UserModel user, String provider)? linkingAccount,
    TResult Function(UserModel user, String provider)? accountLinked,
    TResult Function(UserModel user, String provider)? unlinkingAccount,
    TResult Function(UserModel user, String provider)? accountUnlinked,
    TResult Function(UserModel user, String newEmail)? updatingEmail,
    TResult Function(UserModel user, String newEmail)? emailUpdated,
    required TResult orElse(),
  }) {
    if (updatingProfile != null) {
      return updatingProfile(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthRegistering value) registering,
    required TResult Function(AuthRegistrationComplete value)
    registrationComplete,
    required TResult Function(AuthPasswordResetSent value) passwordResetSent,
    required TResult Function(AuthEmailVerificationSent value)
    emailVerificationSent,
    required TResult Function(AuthUpdatingProfile value) updatingProfile,
    required TResult Function(AuthProfileUpdated value) profileUpdated,
    required TResult Function(AuthChangingPassword value) changingPassword,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthReauthenticationRequired value)
    reauthenticationRequired,
    required TResult Function(AuthReauthenticating value) reauthenticating,
    required TResult Function(AuthDeletingAccount value) deletingAccount,
    required TResult Function(AuthAccountDeleted value) accountDeleted,
    required TResult Function(AuthLinkingAccount value) linkingAccount,
    required TResult Function(AuthAccountLinked value) accountLinked,
    required TResult Function(AuthUnlinkingAccount value) unlinkingAccount,
    required TResult Function(AuthAccountUnlinked value) accountUnlinked,
    required TResult Function(AuthUpdatingEmail value) updatingEmail,
    required TResult Function(AuthEmailUpdated value) emailUpdated,
  }) {
    return updatingProfile(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthRegistering value)? registering,
    TResult? Function(AuthRegistrationComplete value)? registrationComplete,
    TResult? Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult? Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult? Function(AuthUpdatingProfile value)? updatingProfile,
    TResult? Function(AuthProfileUpdated value)? profileUpdated,
    TResult? Function(AuthChangingPassword value)? changingPassword,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult? Function(AuthReauthenticating value)? reauthenticating,
    TResult? Function(AuthDeletingAccount value)? deletingAccount,
    TResult? Function(AuthAccountDeleted value)? accountDeleted,
    TResult? Function(AuthLinkingAccount value)? linkingAccount,
    TResult? Function(AuthAccountLinked value)? accountLinked,
    TResult? Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult? Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult? Function(AuthUpdatingEmail value)? updatingEmail,
    TResult? Function(AuthEmailUpdated value)? emailUpdated,
  }) {
    return updatingProfile?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? error,
    TResult Function(AuthRegistering value)? registering,
    TResult Function(AuthRegistrationComplete value)? registrationComplete,
    TResult Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult Function(AuthUpdatingProfile value)? updatingProfile,
    TResult Function(AuthProfileUpdated value)? profileUpdated,
    TResult Function(AuthChangingPassword value)? changingPassword,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult Function(AuthReauthenticating value)? reauthenticating,
    TResult Function(AuthDeletingAccount value)? deletingAccount,
    TResult Function(AuthAccountDeleted value)? accountDeleted,
    TResult Function(AuthLinkingAccount value)? linkingAccount,
    TResult Function(AuthAccountLinked value)? accountLinked,
    TResult Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult Function(AuthUpdatingEmail value)? updatingEmail,
    TResult Function(AuthEmailUpdated value)? emailUpdated,
    required TResult orElse(),
  }) {
    if (updatingProfile != null) {
      return updatingProfile(this);
    }
    return orElse();
  }
}

abstract class AuthUpdatingProfile implements AuthState {
  const factory AuthUpdatingProfile({required final UserModel user}) =
      _$AuthUpdatingProfileImpl;

  UserModel get user;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthUpdatingProfileImplCopyWith<_$AuthUpdatingProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthProfileUpdatedImplCopyWith<$Res> {
  factory _$$AuthProfileUpdatedImplCopyWith(
    _$AuthProfileUpdatedImpl value,
    $Res Function(_$AuthProfileUpdatedImpl) then,
  ) = __$$AuthProfileUpdatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UserModel user});
}

/// @nodoc
class __$$AuthProfileUpdatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthProfileUpdatedImpl>
    implements _$$AuthProfileUpdatedImplCopyWith<$Res> {
  __$$AuthProfileUpdatedImplCopyWithImpl(
    _$AuthProfileUpdatedImpl _value,
    $Res Function(_$AuthProfileUpdatedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null}) {
    return _then(
      _$AuthProfileUpdatedImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
      ),
    );
  }
}

/// @nodoc

class _$AuthProfileUpdatedImpl implements AuthProfileUpdated {
  const _$AuthProfileUpdatedImpl({required this.user});

  @override
  final UserModel user;

  @override
  String toString() {
    return 'AuthState.profileUpdated(user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthProfileUpdatedImpl &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthProfileUpdatedImplCopyWith<_$AuthProfileUpdatedImpl> get copyWith =>
      __$$AuthProfileUpdatedImplCopyWithImpl<_$AuthProfileUpdatedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? operationType) loading,
    required TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )
    authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )
    error,
    required TResult Function() registering,
    required TResult Function(String email, bool needsEmailVerification)
    registrationComplete,
    required TResult Function(String email) passwordResetSent,
    required TResult Function() emailVerificationSent,
    required TResult Function(UserModel user) updatingProfile,
    required TResult Function(UserModel user) profileUpdated,
    required TResult Function(UserModel user) changingPassword,
    required TResult Function(UserModel user) passwordChanged,
    required TResult Function(String operation, UserModel user)
    reauthenticationRequired,
    required TResult Function(UserModel user) reauthenticating,
    required TResult Function(UserModel user) deletingAccount,
    required TResult Function() accountDeleted,
    required TResult Function(UserModel user, String provider) linkingAccount,
    required TResult Function(UserModel user, String provider) accountLinked,
    required TResult Function(UserModel user, String provider) unlinkingAccount,
    required TResult Function(UserModel user, String provider) accountUnlinked,
    required TResult Function(UserModel user, String newEmail) updatingEmail,
    required TResult Function(UserModel user, String newEmail) emailUpdated,
  }) {
    return profileUpdated(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? operationType)? loading,
    TResult? Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult? Function()? registering,
    TResult? Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult? Function(String email)? passwordResetSent,
    TResult? Function()? emailVerificationSent,
    TResult? Function(UserModel user)? updatingProfile,
    TResult? Function(UserModel user)? profileUpdated,
    TResult? Function(UserModel user)? changingPassword,
    TResult? Function(UserModel user)? passwordChanged,
    TResult? Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult? Function(UserModel user)? reauthenticating,
    TResult? Function(UserModel user)? deletingAccount,
    TResult? Function()? accountDeleted,
    TResult? Function(UserModel user, String provider)? linkingAccount,
    TResult? Function(UserModel user, String provider)? accountLinked,
    TResult? Function(UserModel user, String provider)? unlinkingAccount,
    TResult? Function(UserModel user, String provider)? accountUnlinked,
    TResult? Function(UserModel user, String newEmail)? updatingEmail,
    TResult? Function(UserModel user, String newEmail)? emailUpdated,
  }) {
    return profileUpdated?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? operationType)? loading,
    TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult Function()? unauthenticated,
    TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult Function()? registering,
    TResult Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult Function(String email)? passwordResetSent,
    TResult Function()? emailVerificationSent,
    TResult Function(UserModel user)? updatingProfile,
    TResult Function(UserModel user)? profileUpdated,
    TResult Function(UserModel user)? changingPassword,
    TResult Function(UserModel user)? passwordChanged,
    TResult Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult Function(UserModel user)? reauthenticating,
    TResult Function(UserModel user)? deletingAccount,
    TResult Function()? accountDeleted,
    TResult Function(UserModel user, String provider)? linkingAccount,
    TResult Function(UserModel user, String provider)? accountLinked,
    TResult Function(UserModel user, String provider)? unlinkingAccount,
    TResult Function(UserModel user, String provider)? accountUnlinked,
    TResult Function(UserModel user, String newEmail)? updatingEmail,
    TResult Function(UserModel user, String newEmail)? emailUpdated,
    required TResult orElse(),
  }) {
    if (profileUpdated != null) {
      return profileUpdated(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthRegistering value) registering,
    required TResult Function(AuthRegistrationComplete value)
    registrationComplete,
    required TResult Function(AuthPasswordResetSent value) passwordResetSent,
    required TResult Function(AuthEmailVerificationSent value)
    emailVerificationSent,
    required TResult Function(AuthUpdatingProfile value) updatingProfile,
    required TResult Function(AuthProfileUpdated value) profileUpdated,
    required TResult Function(AuthChangingPassword value) changingPassword,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthReauthenticationRequired value)
    reauthenticationRequired,
    required TResult Function(AuthReauthenticating value) reauthenticating,
    required TResult Function(AuthDeletingAccount value) deletingAccount,
    required TResult Function(AuthAccountDeleted value) accountDeleted,
    required TResult Function(AuthLinkingAccount value) linkingAccount,
    required TResult Function(AuthAccountLinked value) accountLinked,
    required TResult Function(AuthUnlinkingAccount value) unlinkingAccount,
    required TResult Function(AuthAccountUnlinked value) accountUnlinked,
    required TResult Function(AuthUpdatingEmail value) updatingEmail,
    required TResult Function(AuthEmailUpdated value) emailUpdated,
  }) {
    return profileUpdated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthRegistering value)? registering,
    TResult? Function(AuthRegistrationComplete value)? registrationComplete,
    TResult? Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult? Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult? Function(AuthUpdatingProfile value)? updatingProfile,
    TResult? Function(AuthProfileUpdated value)? profileUpdated,
    TResult? Function(AuthChangingPassword value)? changingPassword,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult? Function(AuthReauthenticating value)? reauthenticating,
    TResult? Function(AuthDeletingAccount value)? deletingAccount,
    TResult? Function(AuthAccountDeleted value)? accountDeleted,
    TResult? Function(AuthLinkingAccount value)? linkingAccount,
    TResult? Function(AuthAccountLinked value)? accountLinked,
    TResult? Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult? Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult? Function(AuthUpdatingEmail value)? updatingEmail,
    TResult? Function(AuthEmailUpdated value)? emailUpdated,
  }) {
    return profileUpdated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? error,
    TResult Function(AuthRegistering value)? registering,
    TResult Function(AuthRegistrationComplete value)? registrationComplete,
    TResult Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult Function(AuthUpdatingProfile value)? updatingProfile,
    TResult Function(AuthProfileUpdated value)? profileUpdated,
    TResult Function(AuthChangingPassword value)? changingPassword,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult Function(AuthReauthenticating value)? reauthenticating,
    TResult Function(AuthDeletingAccount value)? deletingAccount,
    TResult Function(AuthAccountDeleted value)? accountDeleted,
    TResult Function(AuthLinkingAccount value)? linkingAccount,
    TResult Function(AuthAccountLinked value)? accountLinked,
    TResult Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult Function(AuthUpdatingEmail value)? updatingEmail,
    TResult Function(AuthEmailUpdated value)? emailUpdated,
    required TResult orElse(),
  }) {
    if (profileUpdated != null) {
      return profileUpdated(this);
    }
    return orElse();
  }
}

abstract class AuthProfileUpdated implements AuthState {
  const factory AuthProfileUpdated({required final UserModel user}) =
      _$AuthProfileUpdatedImpl;

  UserModel get user;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthProfileUpdatedImplCopyWith<_$AuthProfileUpdatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthChangingPasswordImplCopyWith<$Res> {
  factory _$$AuthChangingPasswordImplCopyWith(
    _$AuthChangingPasswordImpl value,
    $Res Function(_$AuthChangingPasswordImpl) then,
  ) = __$$AuthChangingPasswordImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UserModel user});
}

/// @nodoc
class __$$AuthChangingPasswordImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthChangingPasswordImpl>
    implements _$$AuthChangingPasswordImplCopyWith<$Res> {
  __$$AuthChangingPasswordImplCopyWithImpl(
    _$AuthChangingPasswordImpl _value,
    $Res Function(_$AuthChangingPasswordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null}) {
    return _then(
      _$AuthChangingPasswordImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
      ),
    );
  }
}

/// @nodoc

class _$AuthChangingPasswordImpl implements AuthChangingPassword {
  const _$AuthChangingPasswordImpl({required this.user});

  @override
  final UserModel user;

  @override
  String toString() {
    return 'AuthState.changingPassword(user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthChangingPasswordImpl &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthChangingPasswordImplCopyWith<_$AuthChangingPasswordImpl>
  get copyWith =>
      __$$AuthChangingPasswordImplCopyWithImpl<_$AuthChangingPasswordImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? operationType) loading,
    required TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )
    authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )
    error,
    required TResult Function() registering,
    required TResult Function(String email, bool needsEmailVerification)
    registrationComplete,
    required TResult Function(String email) passwordResetSent,
    required TResult Function() emailVerificationSent,
    required TResult Function(UserModel user) updatingProfile,
    required TResult Function(UserModel user) profileUpdated,
    required TResult Function(UserModel user) changingPassword,
    required TResult Function(UserModel user) passwordChanged,
    required TResult Function(String operation, UserModel user)
    reauthenticationRequired,
    required TResult Function(UserModel user) reauthenticating,
    required TResult Function(UserModel user) deletingAccount,
    required TResult Function() accountDeleted,
    required TResult Function(UserModel user, String provider) linkingAccount,
    required TResult Function(UserModel user, String provider) accountLinked,
    required TResult Function(UserModel user, String provider) unlinkingAccount,
    required TResult Function(UserModel user, String provider) accountUnlinked,
    required TResult Function(UserModel user, String newEmail) updatingEmail,
    required TResult Function(UserModel user, String newEmail) emailUpdated,
  }) {
    return changingPassword(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? operationType)? loading,
    TResult? Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult? Function()? registering,
    TResult? Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult? Function(String email)? passwordResetSent,
    TResult? Function()? emailVerificationSent,
    TResult? Function(UserModel user)? updatingProfile,
    TResult? Function(UserModel user)? profileUpdated,
    TResult? Function(UserModel user)? changingPassword,
    TResult? Function(UserModel user)? passwordChanged,
    TResult? Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult? Function(UserModel user)? reauthenticating,
    TResult? Function(UserModel user)? deletingAccount,
    TResult? Function()? accountDeleted,
    TResult? Function(UserModel user, String provider)? linkingAccount,
    TResult? Function(UserModel user, String provider)? accountLinked,
    TResult? Function(UserModel user, String provider)? unlinkingAccount,
    TResult? Function(UserModel user, String provider)? accountUnlinked,
    TResult? Function(UserModel user, String newEmail)? updatingEmail,
    TResult? Function(UserModel user, String newEmail)? emailUpdated,
  }) {
    return changingPassword?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? operationType)? loading,
    TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult Function()? unauthenticated,
    TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult Function()? registering,
    TResult Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult Function(String email)? passwordResetSent,
    TResult Function()? emailVerificationSent,
    TResult Function(UserModel user)? updatingProfile,
    TResult Function(UserModel user)? profileUpdated,
    TResult Function(UserModel user)? changingPassword,
    TResult Function(UserModel user)? passwordChanged,
    TResult Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult Function(UserModel user)? reauthenticating,
    TResult Function(UserModel user)? deletingAccount,
    TResult Function()? accountDeleted,
    TResult Function(UserModel user, String provider)? linkingAccount,
    TResult Function(UserModel user, String provider)? accountLinked,
    TResult Function(UserModel user, String provider)? unlinkingAccount,
    TResult Function(UserModel user, String provider)? accountUnlinked,
    TResult Function(UserModel user, String newEmail)? updatingEmail,
    TResult Function(UserModel user, String newEmail)? emailUpdated,
    required TResult orElse(),
  }) {
    if (changingPassword != null) {
      return changingPassword(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthRegistering value) registering,
    required TResult Function(AuthRegistrationComplete value)
    registrationComplete,
    required TResult Function(AuthPasswordResetSent value) passwordResetSent,
    required TResult Function(AuthEmailVerificationSent value)
    emailVerificationSent,
    required TResult Function(AuthUpdatingProfile value) updatingProfile,
    required TResult Function(AuthProfileUpdated value) profileUpdated,
    required TResult Function(AuthChangingPassword value) changingPassword,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthReauthenticationRequired value)
    reauthenticationRequired,
    required TResult Function(AuthReauthenticating value) reauthenticating,
    required TResult Function(AuthDeletingAccount value) deletingAccount,
    required TResult Function(AuthAccountDeleted value) accountDeleted,
    required TResult Function(AuthLinkingAccount value) linkingAccount,
    required TResult Function(AuthAccountLinked value) accountLinked,
    required TResult Function(AuthUnlinkingAccount value) unlinkingAccount,
    required TResult Function(AuthAccountUnlinked value) accountUnlinked,
    required TResult Function(AuthUpdatingEmail value) updatingEmail,
    required TResult Function(AuthEmailUpdated value) emailUpdated,
  }) {
    return changingPassword(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthRegistering value)? registering,
    TResult? Function(AuthRegistrationComplete value)? registrationComplete,
    TResult? Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult? Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult? Function(AuthUpdatingProfile value)? updatingProfile,
    TResult? Function(AuthProfileUpdated value)? profileUpdated,
    TResult? Function(AuthChangingPassword value)? changingPassword,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult? Function(AuthReauthenticating value)? reauthenticating,
    TResult? Function(AuthDeletingAccount value)? deletingAccount,
    TResult? Function(AuthAccountDeleted value)? accountDeleted,
    TResult? Function(AuthLinkingAccount value)? linkingAccount,
    TResult? Function(AuthAccountLinked value)? accountLinked,
    TResult? Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult? Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult? Function(AuthUpdatingEmail value)? updatingEmail,
    TResult? Function(AuthEmailUpdated value)? emailUpdated,
  }) {
    return changingPassword?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? error,
    TResult Function(AuthRegistering value)? registering,
    TResult Function(AuthRegistrationComplete value)? registrationComplete,
    TResult Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult Function(AuthUpdatingProfile value)? updatingProfile,
    TResult Function(AuthProfileUpdated value)? profileUpdated,
    TResult Function(AuthChangingPassword value)? changingPassword,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult Function(AuthReauthenticating value)? reauthenticating,
    TResult Function(AuthDeletingAccount value)? deletingAccount,
    TResult Function(AuthAccountDeleted value)? accountDeleted,
    TResult Function(AuthLinkingAccount value)? linkingAccount,
    TResult Function(AuthAccountLinked value)? accountLinked,
    TResult Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult Function(AuthUpdatingEmail value)? updatingEmail,
    TResult Function(AuthEmailUpdated value)? emailUpdated,
    required TResult orElse(),
  }) {
    if (changingPassword != null) {
      return changingPassword(this);
    }
    return orElse();
  }
}

abstract class AuthChangingPassword implements AuthState {
  const factory AuthChangingPassword({required final UserModel user}) =
      _$AuthChangingPasswordImpl;

  UserModel get user;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthChangingPasswordImplCopyWith<_$AuthChangingPasswordImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthPasswordChangedImplCopyWith<$Res> {
  factory _$$AuthPasswordChangedImplCopyWith(
    _$AuthPasswordChangedImpl value,
    $Res Function(_$AuthPasswordChangedImpl) then,
  ) = __$$AuthPasswordChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UserModel user});
}

/// @nodoc
class __$$AuthPasswordChangedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthPasswordChangedImpl>
    implements _$$AuthPasswordChangedImplCopyWith<$Res> {
  __$$AuthPasswordChangedImplCopyWithImpl(
    _$AuthPasswordChangedImpl _value,
    $Res Function(_$AuthPasswordChangedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null}) {
    return _then(
      _$AuthPasswordChangedImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
      ),
    );
  }
}

/// @nodoc

class _$AuthPasswordChangedImpl implements AuthPasswordChanged {
  const _$AuthPasswordChangedImpl({required this.user});

  @override
  final UserModel user;

  @override
  String toString() {
    return 'AuthState.passwordChanged(user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthPasswordChangedImpl &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthPasswordChangedImplCopyWith<_$AuthPasswordChangedImpl> get copyWith =>
      __$$AuthPasswordChangedImplCopyWithImpl<_$AuthPasswordChangedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? operationType) loading,
    required TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )
    authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )
    error,
    required TResult Function() registering,
    required TResult Function(String email, bool needsEmailVerification)
    registrationComplete,
    required TResult Function(String email) passwordResetSent,
    required TResult Function() emailVerificationSent,
    required TResult Function(UserModel user) updatingProfile,
    required TResult Function(UserModel user) profileUpdated,
    required TResult Function(UserModel user) changingPassword,
    required TResult Function(UserModel user) passwordChanged,
    required TResult Function(String operation, UserModel user)
    reauthenticationRequired,
    required TResult Function(UserModel user) reauthenticating,
    required TResult Function(UserModel user) deletingAccount,
    required TResult Function() accountDeleted,
    required TResult Function(UserModel user, String provider) linkingAccount,
    required TResult Function(UserModel user, String provider) accountLinked,
    required TResult Function(UserModel user, String provider) unlinkingAccount,
    required TResult Function(UserModel user, String provider) accountUnlinked,
    required TResult Function(UserModel user, String newEmail) updatingEmail,
    required TResult Function(UserModel user, String newEmail) emailUpdated,
  }) {
    return passwordChanged(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? operationType)? loading,
    TResult? Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult? Function()? registering,
    TResult? Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult? Function(String email)? passwordResetSent,
    TResult? Function()? emailVerificationSent,
    TResult? Function(UserModel user)? updatingProfile,
    TResult? Function(UserModel user)? profileUpdated,
    TResult? Function(UserModel user)? changingPassword,
    TResult? Function(UserModel user)? passwordChanged,
    TResult? Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult? Function(UserModel user)? reauthenticating,
    TResult? Function(UserModel user)? deletingAccount,
    TResult? Function()? accountDeleted,
    TResult? Function(UserModel user, String provider)? linkingAccount,
    TResult? Function(UserModel user, String provider)? accountLinked,
    TResult? Function(UserModel user, String provider)? unlinkingAccount,
    TResult? Function(UserModel user, String provider)? accountUnlinked,
    TResult? Function(UserModel user, String newEmail)? updatingEmail,
    TResult? Function(UserModel user, String newEmail)? emailUpdated,
  }) {
    return passwordChanged?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? operationType)? loading,
    TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult Function()? unauthenticated,
    TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult Function()? registering,
    TResult Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult Function(String email)? passwordResetSent,
    TResult Function()? emailVerificationSent,
    TResult Function(UserModel user)? updatingProfile,
    TResult Function(UserModel user)? profileUpdated,
    TResult Function(UserModel user)? changingPassword,
    TResult Function(UserModel user)? passwordChanged,
    TResult Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult Function(UserModel user)? reauthenticating,
    TResult Function(UserModel user)? deletingAccount,
    TResult Function()? accountDeleted,
    TResult Function(UserModel user, String provider)? linkingAccount,
    TResult Function(UserModel user, String provider)? accountLinked,
    TResult Function(UserModel user, String provider)? unlinkingAccount,
    TResult Function(UserModel user, String provider)? accountUnlinked,
    TResult Function(UserModel user, String newEmail)? updatingEmail,
    TResult Function(UserModel user, String newEmail)? emailUpdated,
    required TResult orElse(),
  }) {
    if (passwordChanged != null) {
      return passwordChanged(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthRegistering value) registering,
    required TResult Function(AuthRegistrationComplete value)
    registrationComplete,
    required TResult Function(AuthPasswordResetSent value) passwordResetSent,
    required TResult Function(AuthEmailVerificationSent value)
    emailVerificationSent,
    required TResult Function(AuthUpdatingProfile value) updatingProfile,
    required TResult Function(AuthProfileUpdated value) profileUpdated,
    required TResult Function(AuthChangingPassword value) changingPassword,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthReauthenticationRequired value)
    reauthenticationRequired,
    required TResult Function(AuthReauthenticating value) reauthenticating,
    required TResult Function(AuthDeletingAccount value) deletingAccount,
    required TResult Function(AuthAccountDeleted value) accountDeleted,
    required TResult Function(AuthLinkingAccount value) linkingAccount,
    required TResult Function(AuthAccountLinked value) accountLinked,
    required TResult Function(AuthUnlinkingAccount value) unlinkingAccount,
    required TResult Function(AuthAccountUnlinked value) accountUnlinked,
    required TResult Function(AuthUpdatingEmail value) updatingEmail,
    required TResult Function(AuthEmailUpdated value) emailUpdated,
  }) {
    return passwordChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthRegistering value)? registering,
    TResult? Function(AuthRegistrationComplete value)? registrationComplete,
    TResult? Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult? Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult? Function(AuthUpdatingProfile value)? updatingProfile,
    TResult? Function(AuthProfileUpdated value)? profileUpdated,
    TResult? Function(AuthChangingPassword value)? changingPassword,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult? Function(AuthReauthenticating value)? reauthenticating,
    TResult? Function(AuthDeletingAccount value)? deletingAccount,
    TResult? Function(AuthAccountDeleted value)? accountDeleted,
    TResult? Function(AuthLinkingAccount value)? linkingAccount,
    TResult? Function(AuthAccountLinked value)? accountLinked,
    TResult? Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult? Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult? Function(AuthUpdatingEmail value)? updatingEmail,
    TResult? Function(AuthEmailUpdated value)? emailUpdated,
  }) {
    return passwordChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? error,
    TResult Function(AuthRegistering value)? registering,
    TResult Function(AuthRegistrationComplete value)? registrationComplete,
    TResult Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult Function(AuthUpdatingProfile value)? updatingProfile,
    TResult Function(AuthProfileUpdated value)? profileUpdated,
    TResult Function(AuthChangingPassword value)? changingPassword,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult Function(AuthReauthenticating value)? reauthenticating,
    TResult Function(AuthDeletingAccount value)? deletingAccount,
    TResult Function(AuthAccountDeleted value)? accountDeleted,
    TResult Function(AuthLinkingAccount value)? linkingAccount,
    TResult Function(AuthAccountLinked value)? accountLinked,
    TResult Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult Function(AuthUpdatingEmail value)? updatingEmail,
    TResult Function(AuthEmailUpdated value)? emailUpdated,
    required TResult orElse(),
  }) {
    if (passwordChanged != null) {
      return passwordChanged(this);
    }
    return orElse();
  }
}

abstract class AuthPasswordChanged implements AuthState {
  const factory AuthPasswordChanged({required final UserModel user}) =
      _$AuthPasswordChangedImpl;

  UserModel get user;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthPasswordChangedImplCopyWith<_$AuthPasswordChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthReauthenticationRequiredImplCopyWith<$Res> {
  factory _$$AuthReauthenticationRequiredImplCopyWith(
    _$AuthReauthenticationRequiredImpl value,
    $Res Function(_$AuthReauthenticationRequiredImpl) then,
  ) = __$$AuthReauthenticationRequiredImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String operation, UserModel user});
}

/// @nodoc
class __$$AuthReauthenticationRequiredImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthReauthenticationRequiredImpl>
    implements _$$AuthReauthenticationRequiredImplCopyWith<$Res> {
  __$$AuthReauthenticationRequiredImplCopyWithImpl(
    _$AuthReauthenticationRequiredImpl _value,
    $Res Function(_$AuthReauthenticationRequiredImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? operation = null, Object? user = null}) {
    return _then(
      _$AuthReauthenticationRequiredImpl(
        operation: null == operation
            ? _value.operation
            : operation // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
      ),
    );
  }
}

/// @nodoc

class _$AuthReauthenticationRequiredImpl
    implements AuthReauthenticationRequired {
  const _$AuthReauthenticationRequiredImpl({
    required this.operation,
    required this.user,
  });

  @override
  final String operation;
  @override
  final UserModel user;

  @override
  String toString() {
    return 'AuthState.reauthenticationRequired(operation: $operation, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthReauthenticationRequiredImpl &&
            (identical(other.operation, operation) ||
                other.operation == operation) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, operation, user);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthReauthenticationRequiredImplCopyWith<
    _$AuthReauthenticationRequiredImpl
  >
  get copyWith =>
      __$$AuthReauthenticationRequiredImplCopyWithImpl<
        _$AuthReauthenticationRequiredImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? operationType) loading,
    required TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )
    authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )
    error,
    required TResult Function() registering,
    required TResult Function(String email, bool needsEmailVerification)
    registrationComplete,
    required TResult Function(String email) passwordResetSent,
    required TResult Function() emailVerificationSent,
    required TResult Function(UserModel user) updatingProfile,
    required TResult Function(UserModel user) profileUpdated,
    required TResult Function(UserModel user) changingPassword,
    required TResult Function(UserModel user) passwordChanged,
    required TResult Function(String operation, UserModel user)
    reauthenticationRequired,
    required TResult Function(UserModel user) reauthenticating,
    required TResult Function(UserModel user) deletingAccount,
    required TResult Function() accountDeleted,
    required TResult Function(UserModel user, String provider) linkingAccount,
    required TResult Function(UserModel user, String provider) accountLinked,
    required TResult Function(UserModel user, String provider) unlinkingAccount,
    required TResult Function(UserModel user, String provider) accountUnlinked,
    required TResult Function(UserModel user, String newEmail) updatingEmail,
    required TResult Function(UserModel user, String newEmail) emailUpdated,
  }) {
    return reauthenticationRequired(operation, user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? operationType)? loading,
    TResult? Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult? Function()? registering,
    TResult? Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult? Function(String email)? passwordResetSent,
    TResult? Function()? emailVerificationSent,
    TResult? Function(UserModel user)? updatingProfile,
    TResult? Function(UserModel user)? profileUpdated,
    TResult? Function(UserModel user)? changingPassword,
    TResult? Function(UserModel user)? passwordChanged,
    TResult? Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult? Function(UserModel user)? reauthenticating,
    TResult? Function(UserModel user)? deletingAccount,
    TResult? Function()? accountDeleted,
    TResult? Function(UserModel user, String provider)? linkingAccount,
    TResult? Function(UserModel user, String provider)? accountLinked,
    TResult? Function(UserModel user, String provider)? unlinkingAccount,
    TResult? Function(UserModel user, String provider)? accountUnlinked,
    TResult? Function(UserModel user, String newEmail)? updatingEmail,
    TResult? Function(UserModel user, String newEmail)? emailUpdated,
  }) {
    return reauthenticationRequired?.call(operation, user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? operationType)? loading,
    TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult Function()? unauthenticated,
    TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult Function()? registering,
    TResult Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult Function(String email)? passwordResetSent,
    TResult Function()? emailVerificationSent,
    TResult Function(UserModel user)? updatingProfile,
    TResult Function(UserModel user)? profileUpdated,
    TResult Function(UserModel user)? changingPassword,
    TResult Function(UserModel user)? passwordChanged,
    TResult Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult Function(UserModel user)? reauthenticating,
    TResult Function(UserModel user)? deletingAccount,
    TResult Function()? accountDeleted,
    TResult Function(UserModel user, String provider)? linkingAccount,
    TResult Function(UserModel user, String provider)? accountLinked,
    TResult Function(UserModel user, String provider)? unlinkingAccount,
    TResult Function(UserModel user, String provider)? accountUnlinked,
    TResult Function(UserModel user, String newEmail)? updatingEmail,
    TResult Function(UserModel user, String newEmail)? emailUpdated,
    required TResult orElse(),
  }) {
    if (reauthenticationRequired != null) {
      return reauthenticationRequired(operation, user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthRegistering value) registering,
    required TResult Function(AuthRegistrationComplete value)
    registrationComplete,
    required TResult Function(AuthPasswordResetSent value) passwordResetSent,
    required TResult Function(AuthEmailVerificationSent value)
    emailVerificationSent,
    required TResult Function(AuthUpdatingProfile value) updatingProfile,
    required TResult Function(AuthProfileUpdated value) profileUpdated,
    required TResult Function(AuthChangingPassword value) changingPassword,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthReauthenticationRequired value)
    reauthenticationRequired,
    required TResult Function(AuthReauthenticating value) reauthenticating,
    required TResult Function(AuthDeletingAccount value) deletingAccount,
    required TResult Function(AuthAccountDeleted value) accountDeleted,
    required TResult Function(AuthLinkingAccount value) linkingAccount,
    required TResult Function(AuthAccountLinked value) accountLinked,
    required TResult Function(AuthUnlinkingAccount value) unlinkingAccount,
    required TResult Function(AuthAccountUnlinked value) accountUnlinked,
    required TResult Function(AuthUpdatingEmail value) updatingEmail,
    required TResult Function(AuthEmailUpdated value) emailUpdated,
  }) {
    return reauthenticationRequired(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthRegistering value)? registering,
    TResult? Function(AuthRegistrationComplete value)? registrationComplete,
    TResult? Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult? Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult? Function(AuthUpdatingProfile value)? updatingProfile,
    TResult? Function(AuthProfileUpdated value)? profileUpdated,
    TResult? Function(AuthChangingPassword value)? changingPassword,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult? Function(AuthReauthenticating value)? reauthenticating,
    TResult? Function(AuthDeletingAccount value)? deletingAccount,
    TResult? Function(AuthAccountDeleted value)? accountDeleted,
    TResult? Function(AuthLinkingAccount value)? linkingAccount,
    TResult? Function(AuthAccountLinked value)? accountLinked,
    TResult? Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult? Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult? Function(AuthUpdatingEmail value)? updatingEmail,
    TResult? Function(AuthEmailUpdated value)? emailUpdated,
  }) {
    return reauthenticationRequired?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? error,
    TResult Function(AuthRegistering value)? registering,
    TResult Function(AuthRegistrationComplete value)? registrationComplete,
    TResult Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult Function(AuthUpdatingProfile value)? updatingProfile,
    TResult Function(AuthProfileUpdated value)? profileUpdated,
    TResult Function(AuthChangingPassword value)? changingPassword,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult Function(AuthReauthenticating value)? reauthenticating,
    TResult Function(AuthDeletingAccount value)? deletingAccount,
    TResult Function(AuthAccountDeleted value)? accountDeleted,
    TResult Function(AuthLinkingAccount value)? linkingAccount,
    TResult Function(AuthAccountLinked value)? accountLinked,
    TResult Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult Function(AuthUpdatingEmail value)? updatingEmail,
    TResult Function(AuthEmailUpdated value)? emailUpdated,
    required TResult orElse(),
  }) {
    if (reauthenticationRequired != null) {
      return reauthenticationRequired(this);
    }
    return orElse();
  }
}

abstract class AuthReauthenticationRequired implements AuthState {
  const factory AuthReauthenticationRequired({
    required final String operation,
    required final UserModel user,
  }) = _$AuthReauthenticationRequiredImpl;

  String get operation;
  UserModel get user;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthReauthenticationRequiredImplCopyWith<
    _$AuthReauthenticationRequiredImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthReauthenticatingImplCopyWith<$Res> {
  factory _$$AuthReauthenticatingImplCopyWith(
    _$AuthReauthenticatingImpl value,
    $Res Function(_$AuthReauthenticatingImpl) then,
  ) = __$$AuthReauthenticatingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UserModel user});
}

/// @nodoc
class __$$AuthReauthenticatingImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthReauthenticatingImpl>
    implements _$$AuthReauthenticatingImplCopyWith<$Res> {
  __$$AuthReauthenticatingImplCopyWithImpl(
    _$AuthReauthenticatingImpl _value,
    $Res Function(_$AuthReauthenticatingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null}) {
    return _then(
      _$AuthReauthenticatingImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
      ),
    );
  }
}

/// @nodoc

class _$AuthReauthenticatingImpl implements AuthReauthenticating {
  const _$AuthReauthenticatingImpl({required this.user});

  @override
  final UserModel user;

  @override
  String toString() {
    return 'AuthState.reauthenticating(user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthReauthenticatingImpl &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthReauthenticatingImplCopyWith<_$AuthReauthenticatingImpl>
  get copyWith =>
      __$$AuthReauthenticatingImplCopyWithImpl<_$AuthReauthenticatingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? operationType) loading,
    required TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )
    authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )
    error,
    required TResult Function() registering,
    required TResult Function(String email, bool needsEmailVerification)
    registrationComplete,
    required TResult Function(String email) passwordResetSent,
    required TResult Function() emailVerificationSent,
    required TResult Function(UserModel user) updatingProfile,
    required TResult Function(UserModel user) profileUpdated,
    required TResult Function(UserModel user) changingPassword,
    required TResult Function(UserModel user) passwordChanged,
    required TResult Function(String operation, UserModel user)
    reauthenticationRequired,
    required TResult Function(UserModel user) reauthenticating,
    required TResult Function(UserModel user) deletingAccount,
    required TResult Function() accountDeleted,
    required TResult Function(UserModel user, String provider) linkingAccount,
    required TResult Function(UserModel user, String provider) accountLinked,
    required TResult Function(UserModel user, String provider) unlinkingAccount,
    required TResult Function(UserModel user, String provider) accountUnlinked,
    required TResult Function(UserModel user, String newEmail) updatingEmail,
    required TResult Function(UserModel user, String newEmail) emailUpdated,
  }) {
    return reauthenticating(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? operationType)? loading,
    TResult? Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult? Function()? registering,
    TResult? Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult? Function(String email)? passwordResetSent,
    TResult? Function()? emailVerificationSent,
    TResult? Function(UserModel user)? updatingProfile,
    TResult? Function(UserModel user)? profileUpdated,
    TResult? Function(UserModel user)? changingPassword,
    TResult? Function(UserModel user)? passwordChanged,
    TResult? Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult? Function(UserModel user)? reauthenticating,
    TResult? Function(UserModel user)? deletingAccount,
    TResult? Function()? accountDeleted,
    TResult? Function(UserModel user, String provider)? linkingAccount,
    TResult? Function(UserModel user, String provider)? accountLinked,
    TResult? Function(UserModel user, String provider)? unlinkingAccount,
    TResult? Function(UserModel user, String provider)? accountUnlinked,
    TResult? Function(UserModel user, String newEmail)? updatingEmail,
    TResult? Function(UserModel user, String newEmail)? emailUpdated,
  }) {
    return reauthenticating?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? operationType)? loading,
    TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult Function()? unauthenticated,
    TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult Function()? registering,
    TResult Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult Function(String email)? passwordResetSent,
    TResult Function()? emailVerificationSent,
    TResult Function(UserModel user)? updatingProfile,
    TResult Function(UserModel user)? profileUpdated,
    TResult Function(UserModel user)? changingPassword,
    TResult Function(UserModel user)? passwordChanged,
    TResult Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult Function(UserModel user)? reauthenticating,
    TResult Function(UserModel user)? deletingAccount,
    TResult Function()? accountDeleted,
    TResult Function(UserModel user, String provider)? linkingAccount,
    TResult Function(UserModel user, String provider)? accountLinked,
    TResult Function(UserModel user, String provider)? unlinkingAccount,
    TResult Function(UserModel user, String provider)? accountUnlinked,
    TResult Function(UserModel user, String newEmail)? updatingEmail,
    TResult Function(UserModel user, String newEmail)? emailUpdated,
    required TResult orElse(),
  }) {
    if (reauthenticating != null) {
      return reauthenticating(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthRegistering value) registering,
    required TResult Function(AuthRegistrationComplete value)
    registrationComplete,
    required TResult Function(AuthPasswordResetSent value) passwordResetSent,
    required TResult Function(AuthEmailVerificationSent value)
    emailVerificationSent,
    required TResult Function(AuthUpdatingProfile value) updatingProfile,
    required TResult Function(AuthProfileUpdated value) profileUpdated,
    required TResult Function(AuthChangingPassword value) changingPassword,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthReauthenticationRequired value)
    reauthenticationRequired,
    required TResult Function(AuthReauthenticating value) reauthenticating,
    required TResult Function(AuthDeletingAccount value) deletingAccount,
    required TResult Function(AuthAccountDeleted value) accountDeleted,
    required TResult Function(AuthLinkingAccount value) linkingAccount,
    required TResult Function(AuthAccountLinked value) accountLinked,
    required TResult Function(AuthUnlinkingAccount value) unlinkingAccount,
    required TResult Function(AuthAccountUnlinked value) accountUnlinked,
    required TResult Function(AuthUpdatingEmail value) updatingEmail,
    required TResult Function(AuthEmailUpdated value) emailUpdated,
  }) {
    return reauthenticating(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthRegistering value)? registering,
    TResult? Function(AuthRegistrationComplete value)? registrationComplete,
    TResult? Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult? Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult? Function(AuthUpdatingProfile value)? updatingProfile,
    TResult? Function(AuthProfileUpdated value)? profileUpdated,
    TResult? Function(AuthChangingPassword value)? changingPassword,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult? Function(AuthReauthenticating value)? reauthenticating,
    TResult? Function(AuthDeletingAccount value)? deletingAccount,
    TResult? Function(AuthAccountDeleted value)? accountDeleted,
    TResult? Function(AuthLinkingAccount value)? linkingAccount,
    TResult? Function(AuthAccountLinked value)? accountLinked,
    TResult? Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult? Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult? Function(AuthUpdatingEmail value)? updatingEmail,
    TResult? Function(AuthEmailUpdated value)? emailUpdated,
  }) {
    return reauthenticating?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? error,
    TResult Function(AuthRegistering value)? registering,
    TResult Function(AuthRegistrationComplete value)? registrationComplete,
    TResult Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult Function(AuthUpdatingProfile value)? updatingProfile,
    TResult Function(AuthProfileUpdated value)? profileUpdated,
    TResult Function(AuthChangingPassword value)? changingPassword,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult Function(AuthReauthenticating value)? reauthenticating,
    TResult Function(AuthDeletingAccount value)? deletingAccount,
    TResult Function(AuthAccountDeleted value)? accountDeleted,
    TResult Function(AuthLinkingAccount value)? linkingAccount,
    TResult Function(AuthAccountLinked value)? accountLinked,
    TResult Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult Function(AuthUpdatingEmail value)? updatingEmail,
    TResult Function(AuthEmailUpdated value)? emailUpdated,
    required TResult orElse(),
  }) {
    if (reauthenticating != null) {
      return reauthenticating(this);
    }
    return orElse();
  }
}

abstract class AuthReauthenticating implements AuthState {
  const factory AuthReauthenticating({required final UserModel user}) =
      _$AuthReauthenticatingImpl;

  UserModel get user;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthReauthenticatingImplCopyWith<_$AuthReauthenticatingImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthDeletingAccountImplCopyWith<$Res> {
  factory _$$AuthDeletingAccountImplCopyWith(
    _$AuthDeletingAccountImpl value,
    $Res Function(_$AuthDeletingAccountImpl) then,
  ) = __$$AuthDeletingAccountImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UserModel user});
}

/// @nodoc
class __$$AuthDeletingAccountImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthDeletingAccountImpl>
    implements _$$AuthDeletingAccountImplCopyWith<$Res> {
  __$$AuthDeletingAccountImplCopyWithImpl(
    _$AuthDeletingAccountImpl _value,
    $Res Function(_$AuthDeletingAccountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null}) {
    return _then(
      _$AuthDeletingAccountImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
      ),
    );
  }
}

/// @nodoc

class _$AuthDeletingAccountImpl implements AuthDeletingAccount {
  const _$AuthDeletingAccountImpl({required this.user});

  @override
  final UserModel user;

  @override
  String toString() {
    return 'AuthState.deletingAccount(user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthDeletingAccountImpl &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthDeletingAccountImplCopyWith<_$AuthDeletingAccountImpl> get copyWith =>
      __$$AuthDeletingAccountImplCopyWithImpl<_$AuthDeletingAccountImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? operationType) loading,
    required TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )
    authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )
    error,
    required TResult Function() registering,
    required TResult Function(String email, bool needsEmailVerification)
    registrationComplete,
    required TResult Function(String email) passwordResetSent,
    required TResult Function() emailVerificationSent,
    required TResult Function(UserModel user) updatingProfile,
    required TResult Function(UserModel user) profileUpdated,
    required TResult Function(UserModel user) changingPassword,
    required TResult Function(UserModel user) passwordChanged,
    required TResult Function(String operation, UserModel user)
    reauthenticationRequired,
    required TResult Function(UserModel user) reauthenticating,
    required TResult Function(UserModel user) deletingAccount,
    required TResult Function() accountDeleted,
    required TResult Function(UserModel user, String provider) linkingAccount,
    required TResult Function(UserModel user, String provider) accountLinked,
    required TResult Function(UserModel user, String provider) unlinkingAccount,
    required TResult Function(UserModel user, String provider) accountUnlinked,
    required TResult Function(UserModel user, String newEmail) updatingEmail,
    required TResult Function(UserModel user, String newEmail) emailUpdated,
  }) {
    return deletingAccount(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? operationType)? loading,
    TResult? Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult? Function()? registering,
    TResult? Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult? Function(String email)? passwordResetSent,
    TResult? Function()? emailVerificationSent,
    TResult? Function(UserModel user)? updatingProfile,
    TResult? Function(UserModel user)? profileUpdated,
    TResult? Function(UserModel user)? changingPassword,
    TResult? Function(UserModel user)? passwordChanged,
    TResult? Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult? Function(UserModel user)? reauthenticating,
    TResult? Function(UserModel user)? deletingAccount,
    TResult? Function()? accountDeleted,
    TResult? Function(UserModel user, String provider)? linkingAccount,
    TResult? Function(UserModel user, String provider)? accountLinked,
    TResult? Function(UserModel user, String provider)? unlinkingAccount,
    TResult? Function(UserModel user, String provider)? accountUnlinked,
    TResult? Function(UserModel user, String newEmail)? updatingEmail,
    TResult? Function(UserModel user, String newEmail)? emailUpdated,
  }) {
    return deletingAccount?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? operationType)? loading,
    TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult Function()? unauthenticated,
    TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult Function()? registering,
    TResult Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult Function(String email)? passwordResetSent,
    TResult Function()? emailVerificationSent,
    TResult Function(UserModel user)? updatingProfile,
    TResult Function(UserModel user)? profileUpdated,
    TResult Function(UserModel user)? changingPassword,
    TResult Function(UserModel user)? passwordChanged,
    TResult Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult Function(UserModel user)? reauthenticating,
    TResult Function(UserModel user)? deletingAccount,
    TResult Function()? accountDeleted,
    TResult Function(UserModel user, String provider)? linkingAccount,
    TResult Function(UserModel user, String provider)? accountLinked,
    TResult Function(UserModel user, String provider)? unlinkingAccount,
    TResult Function(UserModel user, String provider)? accountUnlinked,
    TResult Function(UserModel user, String newEmail)? updatingEmail,
    TResult Function(UserModel user, String newEmail)? emailUpdated,
    required TResult orElse(),
  }) {
    if (deletingAccount != null) {
      return deletingAccount(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthRegistering value) registering,
    required TResult Function(AuthRegistrationComplete value)
    registrationComplete,
    required TResult Function(AuthPasswordResetSent value) passwordResetSent,
    required TResult Function(AuthEmailVerificationSent value)
    emailVerificationSent,
    required TResult Function(AuthUpdatingProfile value) updatingProfile,
    required TResult Function(AuthProfileUpdated value) profileUpdated,
    required TResult Function(AuthChangingPassword value) changingPassword,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthReauthenticationRequired value)
    reauthenticationRequired,
    required TResult Function(AuthReauthenticating value) reauthenticating,
    required TResult Function(AuthDeletingAccount value) deletingAccount,
    required TResult Function(AuthAccountDeleted value) accountDeleted,
    required TResult Function(AuthLinkingAccount value) linkingAccount,
    required TResult Function(AuthAccountLinked value) accountLinked,
    required TResult Function(AuthUnlinkingAccount value) unlinkingAccount,
    required TResult Function(AuthAccountUnlinked value) accountUnlinked,
    required TResult Function(AuthUpdatingEmail value) updatingEmail,
    required TResult Function(AuthEmailUpdated value) emailUpdated,
  }) {
    return deletingAccount(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthRegistering value)? registering,
    TResult? Function(AuthRegistrationComplete value)? registrationComplete,
    TResult? Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult? Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult? Function(AuthUpdatingProfile value)? updatingProfile,
    TResult? Function(AuthProfileUpdated value)? profileUpdated,
    TResult? Function(AuthChangingPassword value)? changingPassword,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult? Function(AuthReauthenticating value)? reauthenticating,
    TResult? Function(AuthDeletingAccount value)? deletingAccount,
    TResult? Function(AuthAccountDeleted value)? accountDeleted,
    TResult? Function(AuthLinkingAccount value)? linkingAccount,
    TResult? Function(AuthAccountLinked value)? accountLinked,
    TResult? Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult? Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult? Function(AuthUpdatingEmail value)? updatingEmail,
    TResult? Function(AuthEmailUpdated value)? emailUpdated,
  }) {
    return deletingAccount?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? error,
    TResult Function(AuthRegistering value)? registering,
    TResult Function(AuthRegistrationComplete value)? registrationComplete,
    TResult Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult Function(AuthUpdatingProfile value)? updatingProfile,
    TResult Function(AuthProfileUpdated value)? profileUpdated,
    TResult Function(AuthChangingPassword value)? changingPassword,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult Function(AuthReauthenticating value)? reauthenticating,
    TResult Function(AuthDeletingAccount value)? deletingAccount,
    TResult Function(AuthAccountDeleted value)? accountDeleted,
    TResult Function(AuthLinkingAccount value)? linkingAccount,
    TResult Function(AuthAccountLinked value)? accountLinked,
    TResult Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult Function(AuthUpdatingEmail value)? updatingEmail,
    TResult Function(AuthEmailUpdated value)? emailUpdated,
    required TResult orElse(),
  }) {
    if (deletingAccount != null) {
      return deletingAccount(this);
    }
    return orElse();
  }
}

abstract class AuthDeletingAccount implements AuthState {
  const factory AuthDeletingAccount({required final UserModel user}) =
      _$AuthDeletingAccountImpl;

  UserModel get user;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthDeletingAccountImplCopyWith<_$AuthDeletingAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthAccountDeletedImplCopyWith<$Res> {
  factory _$$AuthAccountDeletedImplCopyWith(
    _$AuthAccountDeletedImpl value,
    $Res Function(_$AuthAccountDeletedImpl) then,
  ) = __$$AuthAccountDeletedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthAccountDeletedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthAccountDeletedImpl>
    implements _$$AuthAccountDeletedImplCopyWith<$Res> {
  __$$AuthAccountDeletedImplCopyWithImpl(
    _$AuthAccountDeletedImpl _value,
    $Res Function(_$AuthAccountDeletedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthAccountDeletedImpl implements AuthAccountDeleted {
  const _$AuthAccountDeletedImpl();

  @override
  String toString() {
    return 'AuthState.accountDeleted()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthAccountDeletedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? operationType) loading,
    required TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )
    authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )
    error,
    required TResult Function() registering,
    required TResult Function(String email, bool needsEmailVerification)
    registrationComplete,
    required TResult Function(String email) passwordResetSent,
    required TResult Function() emailVerificationSent,
    required TResult Function(UserModel user) updatingProfile,
    required TResult Function(UserModel user) profileUpdated,
    required TResult Function(UserModel user) changingPassword,
    required TResult Function(UserModel user) passwordChanged,
    required TResult Function(String operation, UserModel user)
    reauthenticationRequired,
    required TResult Function(UserModel user) reauthenticating,
    required TResult Function(UserModel user) deletingAccount,
    required TResult Function() accountDeleted,
    required TResult Function(UserModel user, String provider) linkingAccount,
    required TResult Function(UserModel user, String provider) accountLinked,
    required TResult Function(UserModel user, String provider) unlinkingAccount,
    required TResult Function(UserModel user, String provider) accountUnlinked,
    required TResult Function(UserModel user, String newEmail) updatingEmail,
    required TResult Function(UserModel user, String newEmail) emailUpdated,
  }) {
    return accountDeleted();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? operationType)? loading,
    TResult? Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult? Function()? registering,
    TResult? Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult? Function(String email)? passwordResetSent,
    TResult? Function()? emailVerificationSent,
    TResult? Function(UserModel user)? updatingProfile,
    TResult? Function(UserModel user)? profileUpdated,
    TResult? Function(UserModel user)? changingPassword,
    TResult? Function(UserModel user)? passwordChanged,
    TResult? Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult? Function(UserModel user)? reauthenticating,
    TResult? Function(UserModel user)? deletingAccount,
    TResult? Function()? accountDeleted,
    TResult? Function(UserModel user, String provider)? linkingAccount,
    TResult? Function(UserModel user, String provider)? accountLinked,
    TResult? Function(UserModel user, String provider)? unlinkingAccount,
    TResult? Function(UserModel user, String provider)? accountUnlinked,
    TResult? Function(UserModel user, String newEmail)? updatingEmail,
    TResult? Function(UserModel user, String newEmail)? emailUpdated,
  }) {
    return accountDeleted?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? operationType)? loading,
    TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult Function()? unauthenticated,
    TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult Function()? registering,
    TResult Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult Function(String email)? passwordResetSent,
    TResult Function()? emailVerificationSent,
    TResult Function(UserModel user)? updatingProfile,
    TResult Function(UserModel user)? profileUpdated,
    TResult Function(UserModel user)? changingPassword,
    TResult Function(UserModel user)? passwordChanged,
    TResult Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult Function(UserModel user)? reauthenticating,
    TResult Function(UserModel user)? deletingAccount,
    TResult Function()? accountDeleted,
    TResult Function(UserModel user, String provider)? linkingAccount,
    TResult Function(UserModel user, String provider)? accountLinked,
    TResult Function(UserModel user, String provider)? unlinkingAccount,
    TResult Function(UserModel user, String provider)? accountUnlinked,
    TResult Function(UserModel user, String newEmail)? updatingEmail,
    TResult Function(UserModel user, String newEmail)? emailUpdated,
    required TResult orElse(),
  }) {
    if (accountDeleted != null) {
      return accountDeleted();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthRegistering value) registering,
    required TResult Function(AuthRegistrationComplete value)
    registrationComplete,
    required TResult Function(AuthPasswordResetSent value) passwordResetSent,
    required TResult Function(AuthEmailVerificationSent value)
    emailVerificationSent,
    required TResult Function(AuthUpdatingProfile value) updatingProfile,
    required TResult Function(AuthProfileUpdated value) profileUpdated,
    required TResult Function(AuthChangingPassword value) changingPassword,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthReauthenticationRequired value)
    reauthenticationRequired,
    required TResult Function(AuthReauthenticating value) reauthenticating,
    required TResult Function(AuthDeletingAccount value) deletingAccount,
    required TResult Function(AuthAccountDeleted value) accountDeleted,
    required TResult Function(AuthLinkingAccount value) linkingAccount,
    required TResult Function(AuthAccountLinked value) accountLinked,
    required TResult Function(AuthUnlinkingAccount value) unlinkingAccount,
    required TResult Function(AuthAccountUnlinked value) accountUnlinked,
    required TResult Function(AuthUpdatingEmail value) updatingEmail,
    required TResult Function(AuthEmailUpdated value) emailUpdated,
  }) {
    return accountDeleted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthRegistering value)? registering,
    TResult? Function(AuthRegistrationComplete value)? registrationComplete,
    TResult? Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult? Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult? Function(AuthUpdatingProfile value)? updatingProfile,
    TResult? Function(AuthProfileUpdated value)? profileUpdated,
    TResult? Function(AuthChangingPassword value)? changingPassword,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult? Function(AuthReauthenticating value)? reauthenticating,
    TResult? Function(AuthDeletingAccount value)? deletingAccount,
    TResult? Function(AuthAccountDeleted value)? accountDeleted,
    TResult? Function(AuthLinkingAccount value)? linkingAccount,
    TResult? Function(AuthAccountLinked value)? accountLinked,
    TResult? Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult? Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult? Function(AuthUpdatingEmail value)? updatingEmail,
    TResult? Function(AuthEmailUpdated value)? emailUpdated,
  }) {
    return accountDeleted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? error,
    TResult Function(AuthRegistering value)? registering,
    TResult Function(AuthRegistrationComplete value)? registrationComplete,
    TResult Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult Function(AuthUpdatingProfile value)? updatingProfile,
    TResult Function(AuthProfileUpdated value)? profileUpdated,
    TResult Function(AuthChangingPassword value)? changingPassword,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult Function(AuthReauthenticating value)? reauthenticating,
    TResult Function(AuthDeletingAccount value)? deletingAccount,
    TResult Function(AuthAccountDeleted value)? accountDeleted,
    TResult Function(AuthLinkingAccount value)? linkingAccount,
    TResult Function(AuthAccountLinked value)? accountLinked,
    TResult Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult Function(AuthUpdatingEmail value)? updatingEmail,
    TResult Function(AuthEmailUpdated value)? emailUpdated,
    required TResult orElse(),
  }) {
    if (accountDeleted != null) {
      return accountDeleted(this);
    }
    return orElse();
  }
}

abstract class AuthAccountDeleted implements AuthState {
  const factory AuthAccountDeleted() = _$AuthAccountDeletedImpl;
}

/// @nodoc
abstract class _$$AuthLinkingAccountImplCopyWith<$Res> {
  factory _$$AuthLinkingAccountImplCopyWith(
    _$AuthLinkingAccountImpl value,
    $Res Function(_$AuthLinkingAccountImpl) then,
  ) = __$$AuthLinkingAccountImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UserModel user, String provider});
}

/// @nodoc
class __$$AuthLinkingAccountImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthLinkingAccountImpl>
    implements _$$AuthLinkingAccountImplCopyWith<$Res> {
  __$$AuthLinkingAccountImplCopyWithImpl(
    _$AuthLinkingAccountImpl _value,
    $Res Function(_$AuthLinkingAccountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null, Object? provider = null}) {
    return _then(
      _$AuthLinkingAccountImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        provider: null == provider
            ? _value.provider
            : provider // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$AuthLinkingAccountImpl implements AuthLinkingAccount {
  const _$AuthLinkingAccountImpl({required this.user, required this.provider});

  @override
  final UserModel user;
  @override
  final String provider;

  @override
  String toString() {
    return 'AuthState.linkingAccount(user: $user, provider: $provider)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthLinkingAccountImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.provider, provider) ||
                other.provider == provider));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, provider);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthLinkingAccountImplCopyWith<_$AuthLinkingAccountImpl> get copyWith =>
      __$$AuthLinkingAccountImplCopyWithImpl<_$AuthLinkingAccountImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? operationType) loading,
    required TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )
    authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )
    error,
    required TResult Function() registering,
    required TResult Function(String email, bool needsEmailVerification)
    registrationComplete,
    required TResult Function(String email) passwordResetSent,
    required TResult Function() emailVerificationSent,
    required TResult Function(UserModel user) updatingProfile,
    required TResult Function(UserModel user) profileUpdated,
    required TResult Function(UserModel user) changingPassword,
    required TResult Function(UserModel user) passwordChanged,
    required TResult Function(String operation, UserModel user)
    reauthenticationRequired,
    required TResult Function(UserModel user) reauthenticating,
    required TResult Function(UserModel user) deletingAccount,
    required TResult Function() accountDeleted,
    required TResult Function(UserModel user, String provider) linkingAccount,
    required TResult Function(UserModel user, String provider) accountLinked,
    required TResult Function(UserModel user, String provider) unlinkingAccount,
    required TResult Function(UserModel user, String provider) accountUnlinked,
    required TResult Function(UserModel user, String newEmail) updatingEmail,
    required TResult Function(UserModel user, String newEmail) emailUpdated,
  }) {
    return linkingAccount(user, provider);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? operationType)? loading,
    TResult? Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult? Function()? registering,
    TResult? Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult? Function(String email)? passwordResetSent,
    TResult? Function()? emailVerificationSent,
    TResult? Function(UserModel user)? updatingProfile,
    TResult? Function(UserModel user)? profileUpdated,
    TResult? Function(UserModel user)? changingPassword,
    TResult? Function(UserModel user)? passwordChanged,
    TResult? Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult? Function(UserModel user)? reauthenticating,
    TResult? Function(UserModel user)? deletingAccount,
    TResult? Function()? accountDeleted,
    TResult? Function(UserModel user, String provider)? linkingAccount,
    TResult? Function(UserModel user, String provider)? accountLinked,
    TResult? Function(UserModel user, String provider)? unlinkingAccount,
    TResult? Function(UserModel user, String provider)? accountUnlinked,
    TResult? Function(UserModel user, String newEmail)? updatingEmail,
    TResult? Function(UserModel user, String newEmail)? emailUpdated,
  }) {
    return linkingAccount?.call(user, provider);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? operationType)? loading,
    TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult Function()? unauthenticated,
    TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult Function()? registering,
    TResult Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult Function(String email)? passwordResetSent,
    TResult Function()? emailVerificationSent,
    TResult Function(UserModel user)? updatingProfile,
    TResult Function(UserModel user)? profileUpdated,
    TResult Function(UserModel user)? changingPassword,
    TResult Function(UserModel user)? passwordChanged,
    TResult Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult Function(UserModel user)? reauthenticating,
    TResult Function(UserModel user)? deletingAccount,
    TResult Function()? accountDeleted,
    TResult Function(UserModel user, String provider)? linkingAccount,
    TResult Function(UserModel user, String provider)? accountLinked,
    TResult Function(UserModel user, String provider)? unlinkingAccount,
    TResult Function(UserModel user, String provider)? accountUnlinked,
    TResult Function(UserModel user, String newEmail)? updatingEmail,
    TResult Function(UserModel user, String newEmail)? emailUpdated,
    required TResult orElse(),
  }) {
    if (linkingAccount != null) {
      return linkingAccount(user, provider);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthRegistering value) registering,
    required TResult Function(AuthRegistrationComplete value)
    registrationComplete,
    required TResult Function(AuthPasswordResetSent value) passwordResetSent,
    required TResult Function(AuthEmailVerificationSent value)
    emailVerificationSent,
    required TResult Function(AuthUpdatingProfile value) updatingProfile,
    required TResult Function(AuthProfileUpdated value) profileUpdated,
    required TResult Function(AuthChangingPassword value) changingPassword,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthReauthenticationRequired value)
    reauthenticationRequired,
    required TResult Function(AuthReauthenticating value) reauthenticating,
    required TResult Function(AuthDeletingAccount value) deletingAccount,
    required TResult Function(AuthAccountDeleted value) accountDeleted,
    required TResult Function(AuthLinkingAccount value) linkingAccount,
    required TResult Function(AuthAccountLinked value) accountLinked,
    required TResult Function(AuthUnlinkingAccount value) unlinkingAccount,
    required TResult Function(AuthAccountUnlinked value) accountUnlinked,
    required TResult Function(AuthUpdatingEmail value) updatingEmail,
    required TResult Function(AuthEmailUpdated value) emailUpdated,
  }) {
    return linkingAccount(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthRegistering value)? registering,
    TResult? Function(AuthRegistrationComplete value)? registrationComplete,
    TResult? Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult? Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult? Function(AuthUpdatingProfile value)? updatingProfile,
    TResult? Function(AuthProfileUpdated value)? profileUpdated,
    TResult? Function(AuthChangingPassword value)? changingPassword,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult? Function(AuthReauthenticating value)? reauthenticating,
    TResult? Function(AuthDeletingAccount value)? deletingAccount,
    TResult? Function(AuthAccountDeleted value)? accountDeleted,
    TResult? Function(AuthLinkingAccount value)? linkingAccount,
    TResult? Function(AuthAccountLinked value)? accountLinked,
    TResult? Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult? Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult? Function(AuthUpdatingEmail value)? updatingEmail,
    TResult? Function(AuthEmailUpdated value)? emailUpdated,
  }) {
    return linkingAccount?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? error,
    TResult Function(AuthRegistering value)? registering,
    TResult Function(AuthRegistrationComplete value)? registrationComplete,
    TResult Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult Function(AuthUpdatingProfile value)? updatingProfile,
    TResult Function(AuthProfileUpdated value)? profileUpdated,
    TResult Function(AuthChangingPassword value)? changingPassword,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult Function(AuthReauthenticating value)? reauthenticating,
    TResult Function(AuthDeletingAccount value)? deletingAccount,
    TResult Function(AuthAccountDeleted value)? accountDeleted,
    TResult Function(AuthLinkingAccount value)? linkingAccount,
    TResult Function(AuthAccountLinked value)? accountLinked,
    TResult Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult Function(AuthUpdatingEmail value)? updatingEmail,
    TResult Function(AuthEmailUpdated value)? emailUpdated,
    required TResult orElse(),
  }) {
    if (linkingAccount != null) {
      return linkingAccount(this);
    }
    return orElse();
  }
}

abstract class AuthLinkingAccount implements AuthState {
  const factory AuthLinkingAccount({
    required final UserModel user,
    required final String provider,
  }) = _$AuthLinkingAccountImpl;

  UserModel get user;
  String get provider;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthLinkingAccountImplCopyWith<_$AuthLinkingAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthAccountLinkedImplCopyWith<$Res> {
  factory _$$AuthAccountLinkedImplCopyWith(
    _$AuthAccountLinkedImpl value,
    $Res Function(_$AuthAccountLinkedImpl) then,
  ) = __$$AuthAccountLinkedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UserModel user, String provider});
}

/// @nodoc
class __$$AuthAccountLinkedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthAccountLinkedImpl>
    implements _$$AuthAccountLinkedImplCopyWith<$Res> {
  __$$AuthAccountLinkedImplCopyWithImpl(
    _$AuthAccountLinkedImpl _value,
    $Res Function(_$AuthAccountLinkedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null, Object? provider = null}) {
    return _then(
      _$AuthAccountLinkedImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        provider: null == provider
            ? _value.provider
            : provider // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$AuthAccountLinkedImpl implements AuthAccountLinked {
  const _$AuthAccountLinkedImpl({required this.user, required this.provider});

  @override
  final UserModel user;
  @override
  final String provider;

  @override
  String toString() {
    return 'AuthState.accountLinked(user: $user, provider: $provider)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthAccountLinkedImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.provider, provider) ||
                other.provider == provider));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, provider);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthAccountLinkedImplCopyWith<_$AuthAccountLinkedImpl> get copyWith =>
      __$$AuthAccountLinkedImplCopyWithImpl<_$AuthAccountLinkedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? operationType) loading,
    required TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )
    authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )
    error,
    required TResult Function() registering,
    required TResult Function(String email, bool needsEmailVerification)
    registrationComplete,
    required TResult Function(String email) passwordResetSent,
    required TResult Function() emailVerificationSent,
    required TResult Function(UserModel user) updatingProfile,
    required TResult Function(UserModel user) profileUpdated,
    required TResult Function(UserModel user) changingPassword,
    required TResult Function(UserModel user) passwordChanged,
    required TResult Function(String operation, UserModel user)
    reauthenticationRequired,
    required TResult Function(UserModel user) reauthenticating,
    required TResult Function(UserModel user) deletingAccount,
    required TResult Function() accountDeleted,
    required TResult Function(UserModel user, String provider) linkingAccount,
    required TResult Function(UserModel user, String provider) accountLinked,
    required TResult Function(UserModel user, String provider) unlinkingAccount,
    required TResult Function(UserModel user, String provider) accountUnlinked,
    required TResult Function(UserModel user, String newEmail) updatingEmail,
    required TResult Function(UserModel user, String newEmail) emailUpdated,
  }) {
    return accountLinked(user, provider);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? operationType)? loading,
    TResult? Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult? Function()? registering,
    TResult? Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult? Function(String email)? passwordResetSent,
    TResult? Function()? emailVerificationSent,
    TResult? Function(UserModel user)? updatingProfile,
    TResult? Function(UserModel user)? profileUpdated,
    TResult? Function(UserModel user)? changingPassword,
    TResult? Function(UserModel user)? passwordChanged,
    TResult? Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult? Function(UserModel user)? reauthenticating,
    TResult? Function(UserModel user)? deletingAccount,
    TResult? Function()? accountDeleted,
    TResult? Function(UserModel user, String provider)? linkingAccount,
    TResult? Function(UserModel user, String provider)? accountLinked,
    TResult? Function(UserModel user, String provider)? unlinkingAccount,
    TResult? Function(UserModel user, String provider)? accountUnlinked,
    TResult? Function(UserModel user, String newEmail)? updatingEmail,
    TResult? Function(UserModel user, String newEmail)? emailUpdated,
  }) {
    return accountLinked?.call(user, provider);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? operationType)? loading,
    TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult Function()? unauthenticated,
    TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult Function()? registering,
    TResult Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult Function(String email)? passwordResetSent,
    TResult Function()? emailVerificationSent,
    TResult Function(UserModel user)? updatingProfile,
    TResult Function(UserModel user)? profileUpdated,
    TResult Function(UserModel user)? changingPassword,
    TResult Function(UserModel user)? passwordChanged,
    TResult Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult Function(UserModel user)? reauthenticating,
    TResult Function(UserModel user)? deletingAccount,
    TResult Function()? accountDeleted,
    TResult Function(UserModel user, String provider)? linkingAccount,
    TResult Function(UserModel user, String provider)? accountLinked,
    TResult Function(UserModel user, String provider)? unlinkingAccount,
    TResult Function(UserModel user, String provider)? accountUnlinked,
    TResult Function(UserModel user, String newEmail)? updatingEmail,
    TResult Function(UserModel user, String newEmail)? emailUpdated,
    required TResult orElse(),
  }) {
    if (accountLinked != null) {
      return accountLinked(user, provider);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthRegistering value) registering,
    required TResult Function(AuthRegistrationComplete value)
    registrationComplete,
    required TResult Function(AuthPasswordResetSent value) passwordResetSent,
    required TResult Function(AuthEmailVerificationSent value)
    emailVerificationSent,
    required TResult Function(AuthUpdatingProfile value) updatingProfile,
    required TResult Function(AuthProfileUpdated value) profileUpdated,
    required TResult Function(AuthChangingPassword value) changingPassword,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthReauthenticationRequired value)
    reauthenticationRequired,
    required TResult Function(AuthReauthenticating value) reauthenticating,
    required TResult Function(AuthDeletingAccount value) deletingAccount,
    required TResult Function(AuthAccountDeleted value) accountDeleted,
    required TResult Function(AuthLinkingAccount value) linkingAccount,
    required TResult Function(AuthAccountLinked value) accountLinked,
    required TResult Function(AuthUnlinkingAccount value) unlinkingAccount,
    required TResult Function(AuthAccountUnlinked value) accountUnlinked,
    required TResult Function(AuthUpdatingEmail value) updatingEmail,
    required TResult Function(AuthEmailUpdated value) emailUpdated,
  }) {
    return accountLinked(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthRegistering value)? registering,
    TResult? Function(AuthRegistrationComplete value)? registrationComplete,
    TResult? Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult? Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult? Function(AuthUpdatingProfile value)? updatingProfile,
    TResult? Function(AuthProfileUpdated value)? profileUpdated,
    TResult? Function(AuthChangingPassword value)? changingPassword,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult? Function(AuthReauthenticating value)? reauthenticating,
    TResult? Function(AuthDeletingAccount value)? deletingAccount,
    TResult? Function(AuthAccountDeleted value)? accountDeleted,
    TResult? Function(AuthLinkingAccount value)? linkingAccount,
    TResult? Function(AuthAccountLinked value)? accountLinked,
    TResult? Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult? Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult? Function(AuthUpdatingEmail value)? updatingEmail,
    TResult? Function(AuthEmailUpdated value)? emailUpdated,
  }) {
    return accountLinked?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? error,
    TResult Function(AuthRegistering value)? registering,
    TResult Function(AuthRegistrationComplete value)? registrationComplete,
    TResult Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult Function(AuthUpdatingProfile value)? updatingProfile,
    TResult Function(AuthProfileUpdated value)? profileUpdated,
    TResult Function(AuthChangingPassword value)? changingPassword,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult Function(AuthReauthenticating value)? reauthenticating,
    TResult Function(AuthDeletingAccount value)? deletingAccount,
    TResult Function(AuthAccountDeleted value)? accountDeleted,
    TResult Function(AuthLinkingAccount value)? linkingAccount,
    TResult Function(AuthAccountLinked value)? accountLinked,
    TResult Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult Function(AuthUpdatingEmail value)? updatingEmail,
    TResult Function(AuthEmailUpdated value)? emailUpdated,
    required TResult orElse(),
  }) {
    if (accountLinked != null) {
      return accountLinked(this);
    }
    return orElse();
  }
}

abstract class AuthAccountLinked implements AuthState {
  const factory AuthAccountLinked({
    required final UserModel user,
    required final String provider,
  }) = _$AuthAccountLinkedImpl;

  UserModel get user;
  String get provider;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthAccountLinkedImplCopyWith<_$AuthAccountLinkedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthUnlinkingAccountImplCopyWith<$Res> {
  factory _$$AuthUnlinkingAccountImplCopyWith(
    _$AuthUnlinkingAccountImpl value,
    $Res Function(_$AuthUnlinkingAccountImpl) then,
  ) = __$$AuthUnlinkingAccountImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UserModel user, String provider});
}

/// @nodoc
class __$$AuthUnlinkingAccountImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthUnlinkingAccountImpl>
    implements _$$AuthUnlinkingAccountImplCopyWith<$Res> {
  __$$AuthUnlinkingAccountImplCopyWithImpl(
    _$AuthUnlinkingAccountImpl _value,
    $Res Function(_$AuthUnlinkingAccountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null, Object? provider = null}) {
    return _then(
      _$AuthUnlinkingAccountImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        provider: null == provider
            ? _value.provider
            : provider // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$AuthUnlinkingAccountImpl implements AuthUnlinkingAccount {
  const _$AuthUnlinkingAccountImpl({
    required this.user,
    required this.provider,
  });

  @override
  final UserModel user;
  @override
  final String provider;

  @override
  String toString() {
    return 'AuthState.unlinkingAccount(user: $user, provider: $provider)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthUnlinkingAccountImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.provider, provider) ||
                other.provider == provider));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, provider);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthUnlinkingAccountImplCopyWith<_$AuthUnlinkingAccountImpl>
  get copyWith =>
      __$$AuthUnlinkingAccountImplCopyWithImpl<_$AuthUnlinkingAccountImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? operationType) loading,
    required TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )
    authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )
    error,
    required TResult Function() registering,
    required TResult Function(String email, bool needsEmailVerification)
    registrationComplete,
    required TResult Function(String email) passwordResetSent,
    required TResult Function() emailVerificationSent,
    required TResult Function(UserModel user) updatingProfile,
    required TResult Function(UserModel user) profileUpdated,
    required TResult Function(UserModel user) changingPassword,
    required TResult Function(UserModel user) passwordChanged,
    required TResult Function(String operation, UserModel user)
    reauthenticationRequired,
    required TResult Function(UserModel user) reauthenticating,
    required TResult Function(UserModel user) deletingAccount,
    required TResult Function() accountDeleted,
    required TResult Function(UserModel user, String provider) linkingAccount,
    required TResult Function(UserModel user, String provider) accountLinked,
    required TResult Function(UserModel user, String provider) unlinkingAccount,
    required TResult Function(UserModel user, String provider) accountUnlinked,
    required TResult Function(UserModel user, String newEmail) updatingEmail,
    required TResult Function(UserModel user, String newEmail) emailUpdated,
  }) {
    return unlinkingAccount(user, provider);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? operationType)? loading,
    TResult? Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult? Function()? registering,
    TResult? Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult? Function(String email)? passwordResetSent,
    TResult? Function()? emailVerificationSent,
    TResult? Function(UserModel user)? updatingProfile,
    TResult? Function(UserModel user)? profileUpdated,
    TResult? Function(UserModel user)? changingPassword,
    TResult? Function(UserModel user)? passwordChanged,
    TResult? Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult? Function(UserModel user)? reauthenticating,
    TResult? Function(UserModel user)? deletingAccount,
    TResult? Function()? accountDeleted,
    TResult? Function(UserModel user, String provider)? linkingAccount,
    TResult? Function(UserModel user, String provider)? accountLinked,
    TResult? Function(UserModel user, String provider)? unlinkingAccount,
    TResult? Function(UserModel user, String provider)? accountUnlinked,
    TResult? Function(UserModel user, String newEmail)? updatingEmail,
    TResult? Function(UserModel user, String newEmail)? emailUpdated,
  }) {
    return unlinkingAccount?.call(user, provider);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? operationType)? loading,
    TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult Function()? unauthenticated,
    TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult Function()? registering,
    TResult Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult Function(String email)? passwordResetSent,
    TResult Function()? emailVerificationSent,
    TResult Function(UserModel user)? updatingProfile,
    TResult Function(UserModel user)? profileUpdated,
    TResult Function(UserModel user)? changingPassword,
    TResult Function(UserModel user)? passwordChanged,
    TResult Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult Function(UserModel user)? reauthenticating,
    TResult Function(UserModel user)? deletingAccount,
    TResult Function()? accountDeleted,
    TResult Function(UserModel user, String provider)? linkingAccount,
    TResult Function(UserModel user, String provider)? accountLinked,
    TResult Function(UserModel user, String provider)? unlinkingAccount,
    TResult Function(UserModel user, String provider)? accountUnlinked,
    TResult Function(UserModel user, String newEmail)? updatingEmail,
    TResult Function(UserModel user, String newEmail)? emailUpdated,
    required TResult orElse(),
  }) {
    if (unlinkingAccount != null) {
      return unlinkingAccount(user, provider);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthRegistering value) registering,
    required TResult Function(AuthRegistrationComplete value)
    registrationComplete,
    required TResult Function(AuthPasswordResetSent value) passwordResetSent,
    required TResult Function(AuthEmailVerificationSent value)
    emailVerificationSent,
    required TResult Function(AuthUpdatingProfile value) updatingProfile,
    required TResult Function(AuthProfileUpdated value) profileUpdated,
    required TResult Function(AuthChangingPassword value) changingPassword,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthReauthenticationRequired value)
    reauthenticationRequired,
    required TResult Function(AuthReauthenticating value) reauthenticating,
    required TResult Function(AuthDeletingAccount value) deletingAccount,
    required TResult Function(AuthAccountDeleted value) accountDeleted,
    required TResult Function(AuthLinkingAccount value) linkingAccount,
    required TResult Function(AuthAccountLinked value) accountLinked,
    required TResult Function(AuthUnlinkingAccount value) unlinkingAccount,
    required TResult Function(AuthAccountUnlinked value) accountUnlinked,
    required TResult Function(AuthUpdatingEmail value) updatingEmail,
    required TResult Function(AuthEmailUpdated value) emailUpdated,
  }) {
    return unlinkingAccount(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthRegistering value)? registering,
    TResult? Function(AuthRegistrationComplete value)? registrationComplete,
    TResult? Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult? Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult? Function(AuthUpdatingProfile value)? updatingProfile,
    TResult? Function(AuthProfileUpdated value)? profileUpdated,
    TResult? Function(AuthChangingPassword value)? changingPassword,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult? Function(AuthReauthenticating value)? reauthenticating,
    TResult? Function(AuthDeletingAccount value)? deletingAccount,
    TResult? Function(AuthAccountDeleted value)? accountDeleted,
    TResult? Function(AuthLinkingAccount value)? linkingAccount,
    TResult? Function(AuthAccountLinked value)? accountLinked,
    TResult? Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult? Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult? Function(AuthUpdatingEmail value)? updatingEmail,
    TResult? Function(AuthEmailUpdated value)? emailUpdated,
  }) {
    return unlinkingAccount?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? error,
    TResult Function(AuthRegistering value)? registering,
    TResult Function(AuthRegistrationComplete value)? registrationComplete,
    TResult Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult Function(AuthUpdatingProfile value)? updatingProfile,
    TResult Function(AuthProfileUpdated value)? profileUpdated,
    TResult Function(AuthChangingPassword value)? changingPassword,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult Function(AuthReauthenticating value)? reauthenticating,
    TResult Function(AuthDeletingAccount value)? deletingAccount,
    TResult Function(AuthAccountDeleted value)? accountDeleted,
    TResult Function(AuthLinkingAccount value)? linkingAccount,
    TResult Function(AuthAccountLinked value)? accountLinked,
    TResult Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult Function(AuthUpdatingEmail value)? updatingEmail,
    TResult Function(AuthEmailUpdated value)? emailUpdated,
    required TResult orElse(),
  }) {
    if (unlinkingAccount != null) {
      return unlinkingAccount(this);
    }
    return orElse();
  }
}

abstract class AuthUnlinkingAccount implements AuthState {
  const factory AuthUnlinkingAccount({
    required final UserModel user,
    required final String provider,
  }) = _$AuthUnlinkingAccountImpl;

  UserModel get user;
  String get provider;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthUnlinkingAccountImplCopyWith<_$AuthUnlinkingAccountImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthAccountUnlinkedImplCopyWith<$Res> {
  factory _$$AuthAccountUnlinkedImplCopyWith(
    _$AuthAccountUnlinkedImpl value,
    $Res Function(_$AuthAccountUnlinkedImpl) then,
  ) = __$$AuthAccountUnlinkedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UserModel user, String provider});
}

/// @nodoc
class __$$AuthAccountUnlinkedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthAccountUnlinkedImpl>
    implements _$$AuthAccountUnlinkedImplCopyWith<$Res> {
  __$$AuthAccountUnlinkedImplCopyWithImpl(
    _$AuthAccountUnlinkedImpl _value,
    $Res Function(_$AuthAccountUnlinkedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null, Object? provider = null}) {
    return _then(
      _$AuthAccountUnlinkedImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        provider: null == provider
            ? _value.provider
            : provider // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$AuthAccountUnlinkedImpl implements AuthAccountUnlinked {
  const _$AuthAccountUnlinkedImpl({required this.user, required this.provider});

  @override
  final UserModel user;
  @override
  final String provider;

  @override
  String toString() {
    return 'AuthState.accountUnlinked(user: $user, provider: $provider)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthAccountUnlinkedImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.provider, provider) ||
                other.provider == provider));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, provider);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthAccountUnlinkedImplCopyWith<_$AuthAccountUnlinkedImpl> get copyWith =>
      __$$AuthAccountUnlinkedImplCopyWithImpl<_$AuthAccountUnlinkedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? operationType) loading,
    required TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )
    authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )
    error,
    required TResult Function() registering,
    required TResult Function(String email, bool needsEmailVerification)
    registrationComplete,
    required TResult Function(String email) passwordResetSent,
    required TResult Function() emailVerificationSent,
    required TResult Function(UserModel user) updatingProfile,
    required TResult Function(UserModel user) profileUpdated,
    required TResult Function(UserModel user) changingPassword,
    required TResult Function(UserModel user) passwordChanged,
    required TResult Function(String operation, UserModel user)
    reauthenticationRequired,
    required TResult Function(UserModel user) reauthenticating,
    required TResult Function(UserModel user) deletingAccount,
    required TResult Function() accountDeleted,
    required TResult Function(UserModel user, String provider) linkingAccount,
    required TResult Function(UserModel user, String provider) accountLinked,
    required TResult Function(UserModel user, String provider) unlinkingAccount,
    required TResult Function(UserModel user, String provider) accountUnlinked,
    required TResult Function(UserModel user, String newEmail) updatingEmail,
    required TResult Function(UserModel user, String newEmail) emailUpdated,
  }) {
    return accountUnlinked(user, provider);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? operationType)? loading,
    TResult? Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult? Function()? registering,
    TResult? Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult? Function(String email)? passwordResetSent,
    TResult? Function()? emailVerificationSent,
    TResult? Function(UserModel user)? updatingProfile,
    TResult? Function(UserModel user)? profileUpdated,
    TResult? Function(UserModel user)? changingPassword,
    TResult? Function(UserModel user)? passwordChanged,
    TResult? Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult? Function(UserModel user)? reauthenticating,
    TResult? Function(UserModel user)? deletingAccount,
    TResult? Function()? accountDeleted,
    TResult? Function(UserModel user, String provider)? linkingAccount,
    TResult? Function(UserModel user, String provider)? accountLinked,
    TResult? Function(UserModel user, String provider)? unlinkingAccount,
    TResult? Function(UserModel user, String provider)? accountUnlinked,
    TResult? Function(UserModel user, String newEmail)? updatingEmail,
    TResult? Function(UserModel user, String newEmail)? emailUpdated,
  }) {
    return accountUnlinked?.call(user, provider);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? operationType)? loading,
    TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult Function()? unauthenticated,
    TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult Function()? registering,
    TResult Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult Function(String email)? passwordResetSent,
    TResult Function()? emailVerificationSent,
    TResult Function(UserModel user)? updatingProfile,
    TResult Function(UserModel user)? profileUpdated,
    TResult Function(UserModel user)? changingPassword,
    TResult Function(UserModel user)? passwordChanged,
    TResult Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult Function(UserModel user)? reauthenticating,
    TResult Function(UserModel user)? deletingAccount,
    TResult Function()? accountDeleted,
    TResult Function(UserModel user, String provider)? linkingAccount,
    TResult Function(UserModel user, String provider)? accountLinked,
    TResult Function(UserModel user, String provider)? unlinkingAccount,
    TResult Function(UserModel user, String provider)? accountUnlinked,
    TResult Function(UserModel user, String newEmail)? updatingEmail,
    TResult Function(UserModel user, String newEmail)? emailUpdated,
    required TResult orElse(),
  }) {
    if (accountUnlinked != null) {
      return accountUnlinked(user, provider);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthRegistering value) registering,
    required TResult Function(AuthRegistrationComplete value)
    registrationComplete,
    required TResult Function(AuthPasswordResetSent value) passwordResetSent,
    required TResult Function(AuthEmailVerificationSent value)
    emailVerificationSent,
    required TResult Function(AuthUpdatingProfile value) updatingProfile,
    required TResult Function(AuthProfileUpdated value) profileUpdated,
    required TResult Function(AuthChangingPassword value) changingPassword,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthReauthenticationRequired value)
    reauthenticationRequired,
    required TResult Function(AuthReauthenticating value) reauthenticating,
    required TResult Function(AuthDeletingAccount value) deletingAccount,
    required TResult Function(AuthAccountDeleted value) accountDeleted,
    required TResult Function(AuthLinkingAccount value) linkingAccount,
    required TResult Function(AuthAccountLinked value) accountLinked,
    required TResult Function(AuthUnlinkingAccount value) unlinkingAccount,
    required TResult Function(AuthAccountUnlinked value) accountUnlinked,
    required TResult Function(AuthUpdatingEmail value) updatingEmail,
    required TResult Function(AuthEmailUpdated value) emailUpdated,
  }) {
    return accountUnlinked(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthRegistering value)? registering,
    TResult? Function(AuthRegistrationComplete value)? registrationComplete,
    TResult? Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult? Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult? Function(AuthUpdatingProfile value)? updatingProfile,
    TResult? Function(AuthProfileUpdated value)? profileUpdated,
    TResult? Function(AuthChangingPassword value)? changingPassword,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult? Function(AuthReauthenticating value)? reauthenticating,
    TResult? Function(AuthDeletingAccount value)? deletingAccount,
    TResult? Function(AuthAccountDeleted value)? accountDeleted,
    TResult? Function(AuthLinkingAccount value)? linkingAccount,
    TResult? Function(AuthAccountLinked value)? accountLinked,
    TResult? Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult? Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult? Function(AuthUpdatingEmail value)? updatingEmail,
    TResult? Function(AuthEmailUpdated value)? emailUpdated,
  }) {
    return accountUnlinked?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? error,
    TResult Function(AuthRegistering value)? registering,
    TResult Function(AuthRegistrationComplete value)? registrationComplete,
    TResult Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult Function(AuthUpdatingProfile value)? updatingProfile,
    TResult Function(AuthProfileUpdated value)? profileUpdated,
    TResult Function(AuthChangingPassword value)? changingPassword,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult Function(AuthReauthenticating value)? reauthenticating,
    TResult Function(AuthDeletingAccount value)? deletingAccount,
    TResult Function(AuthAccountDeleted value)? accountDeleted,
    TResult Function(AuthLinkingAccount value)? linkingAccount,
    TResult Function(AuthAccountLinked value)? accountLinked,
    TResult Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult Function(AuthUpdatingEmail value)? updatingEmail,
    TResult Function(AuthEmailUpdated value)? emailUpdated,
    required TResult orElse(),
  }) {
    if (accountUnlinked != null) {
      return accountUnlinked(this);
    }
    return orElse();
  }
}

abstract class AuthAccountUnlinked implements AuthState {
  const factory AuthAccountUnlinked({
    required final UserModel user,
    required final String provider,
  }) = _$AuthAccountUnlinkedImpl;

  UserModel get user;
  String get provider;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthAccountUnlinkedImplCopyWith<_$AuthAccountUnlinkedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthUpdatingEmailImplCopyWith<$Res> {
  factory _$$AuthUpdatingEmailImplCopyWith(
    _$AuthUpdatingEmailImpl value,
    $Res Function(_$AuthUpdatingEmailImpl) then,
  ) = __$$AuthUpdatingEmailImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UserModel user, String newEmail});
}

/// @nodoc
class __$$AuthUpdatingEmailImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthUpdatingEmailImpl>
    implements _$$AuthUpdatingEmailImplCopyWith<$Res> {
  __$$AuthUpdatingEmailImplCopyWithImpl(
    _$AuthUpdatingEmailImpl _value,
    $Res Function(_$AuthUpdatingEmailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null, Object? newEmail = null}) {
    return _then(
      _$AuthUpdatingEmailImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        newEmail: null == newEmail
            ? _value.newEmail
            : newEmail // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$AuthUpdatingEmailImpl implements AuthUpdatingEmail {
  const _$AuthUpdatingEmailImpl({required this.user, required this.newEmail});

  @override
  final UserModel user;
  @override
  final String newEmail;

  @override
  String toString() {
    return 'AuthState.updatingEmail(user: $user, newEmail: $newEmail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthUpdatingEmailImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.newEmail, newEmail) ||
                other.newEmail == newEmail));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, newEmail);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthUpdatingEmailImplCopyWith<_$AuthUpdatingEmailImpl> get copyWith =>
      __$$AuthUpdatingEmailImplCopyWithImpl<_$AuthUpdatingEmailImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? operationType) loading,
    required TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )
    authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )
    error,
    required TResult Function() registering,
    required TResult Function(String email, bool needsEmailVerification)
    registrationComplete,
    required TResult Function(String email) passwordResetSent,
    required TResult Function() emailVerificationSent,
    required TResult Function(UserModel user) updatingProfile,
    required TResult Function(UserModel user) profileUpdated,
    required TResult Function(UserModel user) changingPassword,
    required TResult Function(UserModel user) passwordChanged,
    required TResult Function(String operation, UserModel user)
    reauthenticationRequired,
    required TResult Function(UserModel user) reauthenticating,
    required TResult Function(UserModel user) deletingAccount,
    required TResult Function() accountDeleted,
    required TResult Function(UserModel user, String provider) linkingAccount,
    required TResult Function(UserModel user, String provider) accountLinked,
    required TResult Function(UserModel user, String provider) unlinkingAccount,
    required TResult Function(UserModel user, String provider) accountUnlinked,
    required TResult Function(UserModel user, String newEmail) updatingEmail,
    required TResult Function(UserModel user, String newEmail) emailUpdated,
  }) {
    return updatingEmail(user, newEmail);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? operationType)? loading,
    TResult? Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult? Function()? registering,
    TResult? Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult? Function(String email)? passwordResetSent,
    TResult? Function()? emailVerificationSent,
    TResult? Function(UserModel user)? updatingProfile,
    TResult? Function(UserModel user)? profileUpdated,
    TResult? Function(UserModel user)? changingPassword,
    TResult? Function(UserModel user)? passwordChanged,
    TResult? Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult? Function(UserModel user)? reauthenticating,
    TResult? Function(UserModel user)? deletingAccount,
    TResult? Function()? accountDeleted,
    TResult? Function(UserModel user, String provider)? linkingAccount,
    TResult? Function(UserModel user, String provider)? accountLinked,
    TResult? Function(UserModel user, String provider)? unlinkingAccount,
    TResult? Function(UserModel user, String provider)? accountUnlinked,
    TResult? Function(UserModel user, String newEmail)? updatingEmail,
    TResult? Function(UserModel user, String newEmail)? emailUpdated,
  }) {
    return updatingEmail?.call(user, newEmail);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? operationType)? loading,
    TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult Function()? unauthenticated,
    TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult Function()? registering,
    TResult Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult Function(String email)? passwordResetSent,
    TResult Function()? emailVerificationSent,
    TResult Function(UserModel user)? updatingProfile,
    TResult Function(UserModel user)? profileUpdated,
    TResult Function(UserModel user)? changingPassword,
    TResult Function(UserModel user)? passwordChanged,
    TResult Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult Function(UserModel user)? reauthenticating,
    TResult Function(UserModel user)? deletingAccount,
    TResult Function()? accountDeleted,
    TResult Function(UserModel user, String provider)? linkingAccount,
    TResult Function(UserModel user, String provider)? accountLinked,
    TResult Function(UserModel user, String provider)? unlinkingAccount,
    TResult Function(UserModel user, String provider)? accountUnlinked,
    TResult Function(UserModel user, String newEmail)? updatingEmail,
    TResult Function(UserModel user, String newEmail)? emailUpdated,
    required TResult orElse(),
  }) {
    if (updatingEmail != null) {
      return updatingEmail(user, newEmail);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthRegistering value) registering,
    required TResult Function(AuthRegistrationComplete value)
    registrationComplete,
    required TResult Function(AuthPasswordResetSent value) passwordResetSent,
    required TResult Function(AuthEmailVerificationSent value)
    emailVerificationSent,
    required TResult Function(AuthUpdatingProfile value) updatingProfile,
    required TResult Function(AuthProfileUpdated value) profileUpdated,
    required TResult Function(AuthChangingPassword value) changingPassword,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthReauthenticationRequired value)
    reauthenticationRequired,
    required TResult Function(AuthReauthenticating value) reauthenticating,
    required TResult Function(AuthDeletingAccount value) deletingAccount,
    required TResult Function(AuthAccountDeleted value) accountDeleted,
    required TResult Function(AuthLinkingAccount value) linkingAccount,
    required TResult Function(AuthAccountLinked value) accountLinked,
    required TResult Function(AuthUnlinkingAccount value) unlinkingAccount,
    required TResult Function(AuthAccountUnlinked value) accountUnlinked,
    required TResult Function(AuthUpdatingEmail value) updatingEmail,
    required TResult Function(AuthEmailUpdated value) emailUpdated,
  }) {
    return updatingEmail(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthRegistering value)? registering,
    TResult? Function(AuthRegistrationComplete value)? registrationComplete,
    TResult? Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult? Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult? Function(AuthUpdatingProfile value)? updatingProfile,
    TResult? Function(AuthProfileUpdated value)? profileUpdated,
    TResult? Function(AuthChangingPassword value)? changingPassword,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult? Function(AuthReauthenticating value)? reauthenticating,
    TResult? Function(AuthDeletingAccount value)? deletingAccount,
    TResult? Function(AuthAccountDeleted value)? accountDeleted,
    TResult? Function(AuthLinkingAccount value)? linkingAccount,
    TResult? Function(AuthAccountLinked value)? accountLinked,
    TResult? Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult? Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult? Function(AuthUpdatingEmail value)? updatingEmail,
    TResult? Function(AuthEmailUpdated value)? emailUpdated,
  }) {
    return updatingEmail?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? error,
    TResult Function(AuthRegistering value)? registering,
    TResult Function(AuthRegistrationComplete value)? registrationComplete,
    TResult Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult Function(AuthUpdatingProfile value)? updatingProfile,
    TResult Function(AuthProfileUpdated value)? profileUpdated,
    TResult Function(AuthChangingPassword value)? changingPassword,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult Function(AuthReauthenticating value)? reauthenticating,
    TResult Function(AuthDeletingAccount value)? deletingAccount,
    TResult Function(AuthAccountDeleted value)? accountDeleted,
    TResult Function(AuthLinkingAccount value)? linkingAccount,
    TResult Function(AuthAccountLinked value)? accountLinked,
    TResult Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult Function(AuthUpdatingEmail value)? updatingEmail,
    TResult Function(AuthEmailUpdated value)? emailUpdated,
    required TResult orElse(),
  }) {
    if (updatingEmail != null) {
      return updatingEmail(this);
    }
    return orElse();
  }
}

abstract class AuthUpdatingEmail implements AuthState {
  const factory AuthUpdatingEmail({
    required final UserModel user,
    required final String newEmail,
  }) = _$AuthUpdatingEmailImpl;

  UserModel get user;
  String get newEmail;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthUpdatingEmailImplCopyWith<_$AuthUpdatingEmailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthEmailUpdatedImplCopyWith<$Res> {
  factory _$$AuthEmailUpdatedImplCopyWith(
    _$AuthEmailUpdatedImpl value,
    $Res Function(_$AuthEmailUpdatedImpl) then,
  ) = __$$AuthEmailUpdatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UserModel user, String newEmail});
}

/// @nodoc
class __$$AuthEmailUpdatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthEmailUpdatedImpl>
    implements _$$AuthEmailUpdatedImplCopyWith<$Res> {
  __$$AuthEmailUpdatedImplCopyWithImpl(
    _$AuthEmailUpdatedImpl _value,
    $Res Function(_$AuthEmailUpdatedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user = null, Object? newEmail = null}) {
    return _then(
      _$AuthEmailUpdatedImpl(
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
        newEmail: null == newEmail
            ? _value.newEmail
            : newEmail // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$AuthEmailUpdatedImpl implements AuthEmailUpdated {
  const _$AuthEmailUpdatedImpl({required this.user, required this.newEmail});

  @override
  final UserModel user;
  @override
  final String newEmail;

  @override
  String toString() {
    return 'AuthState.emailUpdated(user: $user, newEmail: $newEmail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthEmailUpdatedImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.newEmail, newEmail) ||
                other.newEmail == newEmail));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, newEmail);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthEmailUpdatedImplCopyWith<_$AuthEmailUpdatedImpl> get copyWith =>
      __$$AuthEmailUpdatedImplCopyWithImpl<_$AuthEmailUpdatedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String? operationType) loading,
    required TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )
    authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )
    error,
    required TResult Function() registering,
    required TResult Function(String email, bool needsEmailVerification)
    registrationComplete,
    required TResult Function(String email) passwordResetSent,
    required TResult Function() emailVerificationSent,
    required TResult Function(UserModel user) updatingProfile,
    required TResult Function(UserModel user) profileUpdated,
    required TResult Function(UserModel user) changingPassword,
    required TResult Function(UserModel user) passwordChanged,
    required TResult Function(String operation, UserModel user)
    reauthenticationRequired,
    required TResult Function(UserModel user) reauthenticating,
    required TResult Function(UserModel user) deletingAccount,
    required TResult Function() accountDeleted,
    required TResult Function(UserModel user, String provider) linkingAccount,
    required TResult Function(UserModel user, String provider) accountLinked,
    required TResult Function(UserModel user, String provider) unlinkingAccount,
    required TResult Function(UserModel user, String provider) accountUnlinked,
    required TResult Function(UserModel user, String newEmail) updatingEmail,
    required TResult Function(UserModel user, String newEmail) emailUpdated,
  }) {
    return emailUpdated(user, newEmail);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String? operationType)? loading,
    TResult? Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult? Function()? registering,
    TResult? Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult? Function(String email)? passwordResetSent,
    TResult? Function()? emailVerificationSent,
    TResult? Function(UserModel user)? updatingProfile,
    TResult? Function(UserModel user)? profileUpdated,
    TResult? Function(UserModel user)? changingPassword,
    TResult? Function(UserModel user)? passwordChanged,
    TResult? Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult? Function(UserModel user)? reauthenticating,
    TResult? Function(UserModel user)? deletingAccount,
    TResult? Function()? accountDeleted,
    TResult? Function(UserModel user, String provider)? linkingAccount,
    TResult? Function(UserModel user, String provider)? accountLinked,
    TResult? Function(UserModel user, String provider)? unlinkingAccount,
    TResult? Function(UserModel user, String provider)? accountUnlinked,
    TResult? Function(UserModel user, String newEmail)? updatingEmail,
    TResult? Function(UserModel user, String newEmail)? emailUpdated,
  }) {
    return emailUpdated?.call(user, newEmail);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String? operationType)? loading,
    TResult Function(
      UserModel user,
      bool isEmailVerified,
      Map<String, dynamic>? permissions,
    )?
    authenticated,
    TResult Function()? unauthenticated,
    TResult Function(
      String message,
      bool canRetry,
      String? lastFailedOperation,
      UserModel? user,
    )?
    error,
    TResult Function()? registering,
    TResult Function(String email, bool needsEmailVerification)?
    registrationComplete,
    TResult Function(String email)? passwordResetSent,
    TResult Function()? emailVerificationSent,
    TResult Function(UserModel user)? updatingProfile,
    TResult Function(UserModel user)? profileUpdated,
    TResult Function(UserModel user)? changingPassword,
    TResult Function(UserModel user)? passwordChanged,
    TResult Function(String operation, UserModel user)?
    reauthenticationRequired,
    TResult Function(UserModel user)? reauthenticating,
    TResult Function(UserModel user)? deletingAccount,
    TResult Function()? accountDeleted,
    TResult Function(UserModel user, String provider)? linkingAccount,
    TResult Function(UserModel user, String provider)? accountLinked,
    TResult Function(UserModel user, String provider)? unlinkingAccount,
    TResult Function(UserModel user, String provider)? accountUnlinked,
    TResult Function(UserModel user, String newEmail)? updatingEmail,
    TResult Function(UserModel user, String newEmail)? emailUpdated,
    required TResult orElse(),
  }) {
    if (emailUpdated != null) {
      return emailUpdated(user, newEmail);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthInitial value) initial,
    required TResult Function(AuthLoading value) loading,
    required TResult Function(AuthAuthenticated value) authenticated,
    required TResult Function(AuthUnauthenticated value) unauthenticated,
    required TResult Function(AuthError value) error,
    required TResult Function(AuthRegistering value) registering,
    required TResult Function(AuthRegistrationComplete value)
    registrationComplete,
    required TResult Function(AuthPasswordResetSent value) passwordResetSent,
    required TResult Function(AuthEmailVerificationSent value)
    emailVerificationSent,
    required TResult Function(AuthUpdatingProfile value) updatingProfile,
    required TResult Function(AuthProfileUpdated value) profileUpdated,
    required TResult Function(AuthChangingPassword value) changingPassword,
    required TResult Function(AuthPasswordChanged value) passwordChanged,
    required TResult Function(AuthReauthenticationRequired value)
    reauthenticationRequired,
    required TResult Function(AuthReauthenticating value) reauthenticating,
    required TResult Function(AuthDeletingAccount value) deletingAccount,
    required TResult Function(AuthAccountDeleted value) accountDeleted,
    required TResult Function(AuthLinkingAccount value) linkingAccount,
    required TResult Function(AuthAccountLinked value) accountLinked,
    required TResult Function(AuthUnlinkingAccount value) unlinkingAccount,
    required TResult Function(AuthAccountUnlinked value) accountUnlinked,
    required TResult Function(AuthUpdatingEmail value) updatingEmail,
    required TResult Function(AuthEmailUpdated value) emailUpdated,
  }) {
    return emailUpdated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthInitial value)? initial,
    TResult? Function(AuthLoading value)? loading,
    TResult? Function(AuthAuthenticated value)? authenticated,
    TResult? Function(AuthUnauthenticated value)? unauthenticated,
    TResult? Function(AuthError value)? error,
    TResult? Function(AuthRegistering value)? registering,
    TResult? Function(AuthRegistrationComplete value)? registrationComplete,
    TResult? Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult? Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult? Function(AuthUpdatingProfile value)? updatingProfile,
    TResult? Function(AuthProfileUpdated value)? profileUpdated,
    TResult? Function(AuthChangingPassword value)? changingPassword,
    TResult? Function(AuthPasswordChanged value)? passwordChanged,
    TResult? Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult? Function(AuthReauthenticating value)? reauthenticating,
    TResult? Function(AuthDeletingAccount value)? deletingAccount,
    TResult? Function(AuthAccountDeleted value)? accountDeleted,
    TResult? Function(AuthLinkingAccount value)? linkingAccount,
    TResult? Function(AuthAccountLinked value)? accountLinked,
    TResult? Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult? Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult? Function(AuthUpdatingEmail value)? updatingEmail,
    TResult? Function(AuthEmailUpdated value)? emailUpdated,
  }) {
    return emailUpdated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthInitial value)? initial,
    TResult Function(AuthLoading value)? loading,
    TResult Function(AuthAuthenticated value)? authenticated,
    TResult Function(AuthUnauthenticated value)? unauthenticated,
    TResult Function(AuthError value)? error,
    TResult Function(AuthRegistering value)? registering,
    TResult Function(AuthRegistrationComplete value)? registrationComplete,
    TResult Function(AuthPasswordResetSent value)? passwordResetSent,
    TResult Function(AuthEmailVerificationSent value)? emailVerificationSent,
    TResult Function(AuthUpdatingProfile value)? updatingProfile,
    TResult Function(AuthProfileUpdated value)? profileUpdated,
    TResult Function(AuthChangingPassword value)? changingPassword,
    TResult Function(AuthPasswordChanged value)? passwordChanged,
    TResult Function(AuthReauthenticationRequired value)?
    reauthenticationRequired,
    TResult Function(AuthReauthenticating value)? reauthenticating,
    TResult Function(AuthDeletingAccount value)? deletingAccount,
    TResult Function(AuthAccountDeleted value)? accountDeleted,
    TResult Function(AuthLinkingAccount value)? linkingAccount,
    TResult Function(AuthAccountLinked value)? accountLinked,
    TResult Function(AuthUnlinkingAccount value)? unlinkingAccount,
    TResult Function(AuthAccountUnlinked value)? accountUnlinked,
    TResult Function(AuthUpdatingEmail value)? updatingEmail,
    TResult Function(AuthEmailUpdated value)? emailUpdated,
    required TResult orElse(),
  }) {
    if (emailUpdated != null) {
      return emailUpdated(this);
    }
    return orElse();
  }
}

abstract class AuthEmailUpdated implements AuthState {
  const factory AuthEmailUpdated({
    required final UserModel user,
    required final String newEmail,
  }) = _$AuthEmailUpdatedImpl;

  UserModel get user;
  String get newEmail;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthEmailUpdatedImplCopyWith<_$AuthEmailUpdatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
