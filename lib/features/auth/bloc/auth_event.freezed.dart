// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AuthEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password, bool rememberMe)
    login,
    required TResult Function() logout,
    required TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )
    register,
    required TResult Function(String email) resetPassword,
    required TResult Function(
      String? fullName,
      String? phoneNumber,
      String? photoUrl,
    )
    updateProfile,
    required TResult Function(String currentPassword, String newPassword)
    changePassword,
    required TResult Function() sendEmailVerification,
    required TResult Function() refreshUserData,
    required TResult Function(String userId, UserPermissions permissions)
    updateUserPermissions,
    required TResult Function() refreshPermissions,
    required TResult Function(String actionCode) verifyEmail,
    required TResult Function(String actionCode, String newPassword)
    confirmPasswordReset,
    required TResult Function(String password) reauthenticate,
    required TResult Function(String password) deleteAccount,
    required TResult Function(String provider) linkAccount,
    required TResult Function(String provider) unlinkAccount,
    required TResult Function(String newEmail, String password) updateEmail,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
    required TResult Function() initialize,
    required TResult Function(bool isAuthenticated, String? userId)
    authStateChanged,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)? login,
    TResult? Function()? logout,
    TResult? Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult? Function(String email)? resetPassword,
    TResult? Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult? Function(String currentPassword, String newPassword)?
    changePassword,
    TResult? Function()? sendEmailVerification,
    TResult? Function()? refreshUserData,
    TResult? Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult? Function()? refreshPermissions,
    TResult? Function(String actionCode)? verifyEmail,
    TResult? Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult? Function(String password)? reauthenticate,
    TResult? Function(String password)? deleteAccount,
    TResult? Function(String provider)? linkAccount,
    TResult? Function(String provider)? unlinkAccount,
    TResult? Function(String newEmail, String password)? updateEmail,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
    TResult? Function()? initialize,
    TResult? Function(bool isAuthenticated, String? userId)? authStateChanged,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)? login,
    TResult Function()? logout,
    TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult Function(String email)? resetPassword,
    TResult Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult Function(String currentPassword, String newPassword)?
    changePassword,
    TResult Function()? sendEmailVerification,
    TResult Function()? refreshUserData,
    TResult Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult Function()? refreshPermissions,
    TResult Function(String actionCode)? verifyEmail,
    TResult Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult Function(String password)? reauthenticate,
    TResult Function(String password)? deleteAccount,
    TResult Function(String provider)? linkAccount,
    TResult Function(String provider)? unlinkAccount,
    TResult Function(String newEmail, String password)? updateEmail,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    TResult Function()? initialize,
    TResult Function(bool isAuthenticated, String? userId)? authStateChanged,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Login value) login,
    required TResult Function(Logout value) logout,
    required TResult Function(Register value) register,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(SendEmailVerification value)
    sendEmailVerification,
    required TResult Function(RefreshUserData value) refreshUserData,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(RefreshPermissions value) refreshPermissions,
    required TResult Function(VerifyEmail value) verifyEmail,
    required TResult Function(ConfirmPasswordReset value) confirmPasswordReset,
    required TResult Function(Reauthenticate value) reauthenticate,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(LinkAccount value) linkAccount,
    required TResult Function(UnlinkAccount value) unlinkAccount,
    required TResult Function(UpdateEmail value) updateEmail,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
    required TResult Function(Initialize value) initialize,
    required TResult Function(AuthStateChanged value) authStateChanged,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Login value)? login,
    TResult? Function(Logout value)? logout,
    TResult? Function(Register value)? register,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(SendEmailVerification value)? sendEmailVerification,
    TResult? Function(RefreshUserData value)? refreshUserData,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(RefreshPermissions value)? refreshPermissions,
    TResult? Function(VerifyEmail value)? verifyEmail,
    TResult? Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult? Function(Reauthenticate value)? reauthenticate,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(LinkAccount value)? linkAccount,
    TResult? Function(UnlinkAccount value)? unlinkAccount,
    TResult? Function(UpdateEmail value)? updateEmail,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
    TResult? Function(Initialize value)? initialize,
    TResult? Function(AuthStateChanged value)? authStateChanged,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Login value)? login,
    TResult Function(Logout value)? logout,
    TResult Function(Register value)? register,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(SendEmailVerification value)? sendEmailVerification,
    TResult Function(RefreshUserData value)? refreshUserData,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(RefreshPermissions value)? refreshPermissions,
    TResult Function(VerifyEmail value)? verifyEmail,
    TResult Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult Function(Reauthenticate value)? reauthenticate,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(LinkAccount value)? linkAccount,
    TResult Function(UnlinkAccount value)? unlinkAccount,
    TResult Function(UpdateEmail value)? updateEmail,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    TResult Function(Initialize value)? initialize,
    TResult Function(AuthStateChanged value)? authStateChanged,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthEventCopyWith<$Res> {
  factory $AuthEventCopyWith(AuthEvent value, $Res Function(AuthEvent) then) =
      _$AuthEventCopyWithImpl<$Res, AuthEvent>;
}

/// @nodoc
class _$AuthEventCopyWithImpl<$Res, $Val extends AuthEvent>
    implements $AuthEventCopyWith<$Res> {
  _$AuthEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoginImplCopyWith<$Res> {
  factory _$$LoginImplCopyWith(
    _$LoginImpl value,
    $Res Function(_$LoginImpl) then,
  ) = __$$LoginImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email, String password, bool rememberMe});
}

/// @nodoc
class __$$LoginImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$LoginImpl>
    implements _$$LoginImplCopyWith<$Res> {
  __$$LoginImplCopyWithImpl(
    _$LoginImpl _value,
    $Res Function(_$LoginImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? rememberMe = null,
  }) {
    return _then(
      _$LoginImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        rememberMe: null == rememberMe
            ? _value.rememberMe
            : rememberMe // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$LoginImpl implements Login {
  const _$LoginImpl({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  @override
  final String email;
  @override
  final String password;
  @override
  @JsonKey()
  final bool rememberMe;

  @override
  String toString() {
    return 'AuthEvent.login(email: $email, password: $password, rememberMe: $rememberMe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.rememberMe, rememberMe) ||
                other.rememberMe == rememberMe));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, password, rememberMe);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginImplCopyWith<_$LoginImpl> get copyWith =>
      __$$LoginImplCopyWithImpl<_$LoginImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password, bool rememberMe)
    login,
    required TResult Function() logout,
    required TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )
    register,
    required TResult Function(String email) resetPassword,
    required TResult Function(
      String? fullName,
      String? phoneNumber,
      String? photoUrl,
    )
    updateProfile,
    required TResult Function(String currentPassword, String newPassword)
    changePassword,
    required TResult Function() sendEmailVerification,
    required TResult Function() refreshUserData,
    required TResult Function(String userId, UserPermissions permissions)
    updateUserPermissions,
    required TResult Function() refreshPermissions,
    required TResult Function(String actionCode) verifyEmail,
    required TResult Function(String actionCode, String newPassword)
    confirmPasswordReset,
    required TResult Function(String password) reauthenticate,
    required TResult Function(String password) deleteAccount,
    required TResult Function(String provider) linkAccount,
    required TResult Function(String provider) unlinkAccount,
    required TResult Function(String newEmail, String password) updateEmail,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
    required TResult Function() initialize,
    required TResult Function(bool isAuthenticated, String? userId)
    authStateChanged,
  }) {
    return login(email, password, rememberMe);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)? login,
    TResult? Function()? logout,
    TResult? Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult? Function(String email)? resetPassword,
    TResult? Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult? Function(String currentPassword, String newPassword)?
    changePassword,
    TResult? Function()? sendEmailVerification,
    TResult? Function()? refreshUserData,
    TResult? Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult? Function()? refreshPermissions,
    TResult? Function(String actionCode)? verifyEmail,
    TResult? Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult? Function(String password)? reauthenticate,
    TResult? Function(String password)? deleteAccount,
    TResult? Function(String provider)? linkAccount,
    TResult? Function(String provider)? unlinkAccount,
    TResult? Function(String newEmail, String password)? updateEmail,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
    TResult? Function()? initialize,
    TResult? Function(bool isAuthenticated, String? userId)? authStateChanged,
  }) {
    return login?.call(email, password, rememberMe);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)? login,
    TResult Function()? logout,
    TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult Function(String email)? resetPassword,
    TResult Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult Function(String currentPassword, String newPassword)?
    changePassword,
    TResult Function()? sendEmailVerification,
    TResult Function()? refreshUserData,
    TResult Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult Function()? refreshPermissions,
    TResult Function(String actionCode)? verifyEmail,
    TResult Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult Function(String password)? reauthenticate,
    TResult Function(String password)? deleteAccount,
    TResult Function(String provider)? linkAccount,
    TResult Function(String provider)? unlinkAccount,
    TResult Function(String newEmail, String password)? updateEmail,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    TResult Function()? initialize,
    TResult Function(bool isAuthenticated, String? userId)? authStateChanged,
    required TResult orElse(),
  }) {
    if (login != null) {
      return login(email, password, rememberMe);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Login value) login,
    required TResult Function(Logout value) logout,
    required TResult Function(Register value) register,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(SendEmailVerification value)
    sendEmailVerification,
    required TResult Function(RefreshUserData value) refreshUserData,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(RefreshPermissions value) refreshPermissions,
    required TResult Function(VerifyEmail value) verifyEmail,
    required TResult Function(ConfirmPasswordReset value) confirmPasswordReset,
    required TResult Function(Reauthenticate value) reauthenticate,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(LinkAccount value) linkAccount,
    required TResult Function(UnlinkAccount value) unlinkAccount,
    required TResult Function(UpdateEmail value) updateEmail,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
    required TResult Function(Initialize value) initialize,
    required TResult Function(AuthStateChanged value) authStateChanged,
  }) {
    return login(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Login value)? login,
    TResult? Function(Logout value)? logout,
    TResult? Function(Register value)? register,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(SendEmailVerification value)? sendEmailVerification,
    TResult? Function(RefreshUserData value)? refreshUserData,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(RefreshPermissions value)? refreshPermissions,
    TResult? Function(VerifyEmail value)? verifyEmail,
    TResult? Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult? Function(Reauthenticate value)? reauthenticate,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(LinkAccount value)? linkAccount,
    TResult? Function(UnlinkAccount value)? unlinkAccount,
    TResult? Function(UpdateEmail value)? updateEmail,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
    TResult? Function(Initialize value)? initialize,
    TResult? Function(AuthStateChanged value)? authStateChanged,
  }) {
    return login?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Login value)? login,
    TResult Function(Logout value)? logout,
    TResult Function(Register value)? register,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(SendEmailVerification value)? sendEmailVerification,
    TResult Function(RefreshUserData value)? refreshUserData,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(RefreshPermissions value)? refreshPermissions,
    TResult Function(VerifyEmail value)? verifyEmail,
    TResult Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult Function(Reauthenticate value)? reauthenticate,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(LinkAccount value)? linkAccount,
    TResult Function(UnlinkAccount value)? unlinkAccount,
    TResult Function(UpdateEmail value)? updateEmail,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    TResult Function(Initialize value)? initialize,
    TResult Function(AuthStateChanged value)? authStateChanged,
    required TResult orElse(),
  }) {
    if (login != null) {
      return login(this);
    }
    return orElse();
  }
}

abstract class Login implements AuthEvent {
  const factory Login({
    required final String email,
    required final String password,
    final bool rememberMe,
  }) = _$LoginImpl;

  String get email;
  String get password;
  bool get rememberMe;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginImplCopyWith<_$LoginImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LogoutImplCopyWith<$Res> {
  factory _$$LogoutImplCopyWith(
    _$LogoutImpl value,
    $Res Function(_$LogoutImpl) then,
  ) = __$$LogoutImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LogoutImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$LogoutImpl>
    implements _$$LogoutImplCopyWith<$Res> {
  __$$LogoutImplCopyWithImpl(
    _$LogoutImpl _value,
    $Res Function(_$LogoutImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LogoutImpl implements Logout {
  const _$LogoutImpl();

  @override
  String toString() {
    return 'AuthEvent.logout()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LogoutImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password, bool rememberMe)
    login,
    required TResult Function() logout,
    required TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )
    register,
    required TResult Function(String email) resetPassword,
    required TResult Function(
      String? fullName,
      String? phoneNumber,
      String? photoUrl,
    )
    updateProfile,
    required TResult Function(String currentPassword, String newPassword)
    changePassword,
    required TResult Function() sendEmailVerification,
    required TResult Function() refreshUserData,
    required TResult Function(String userId, UserPermissions permissions)
    updateUserPermissions,
    required TResult Function() refreshPermissions,
    required TResult Function(String actionCode) verifyEmail,
    required TResult Function(String actionCode, String newPassword)
    confirmPasswordReset,
    required TResult Function(String password) reauthenticate,
    required TResult Function(String password) deleteAccount,
    required TResult Function(String provider) linkAccount,
    required TResult Function(String provider) unlinkAccount,
    required TResult Function(String newEmail, String password) updateEmail,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
    required TResult Function() initialize,
    required TResult Function(bool isAuthenticated, String? userId)
    authStateChanged,
  }) {
    return logout();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)? login,
    TResult? Function()? logout,
    TResult? Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult? Function(String email)? resetPassword,
    TResult? Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult? Function(String currentPassword, String newPassword)?
    changePassword,
    TResult? Function()? sendEmailVerification,
    TResult? Function()? refreshUserData,
    TResult? Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult? Function()? refreshPermissions,
    TResult? Function(String actionCode)? verifyEmail,
    TResult? Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult? Function(String password)? reauthenticate,
    TResult? Function(String password)? deleteAccount,
    TResult? Function(String provider)? linkAccount,
    TResult? Function(String provider)? unlinkAccount,
    TResult? Function(String newEmail, String password)? updateEmail,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
    TResult? Function()? initialize,
    TResult? Function(bool isAuthenticated, String? userId)? authStateChanged,
  }) {
    return logout?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)? login,
    TResult Function()? logout,
    TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult Function(String email)? resetPassword,
    TResult Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult Function(String currentPassword, String newPassword)?
    changePassword,
    TResult Function()? sendEmailVerification,
    TResult Function()? refreshUserData,
    TResult Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult Function()? refreshPermissions,
    TResult Function(String actionCode)? verifyEmail,
    TResult Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult Function(String password)? reauthenticate,
    TResult Function(String password)? deleteAccount,
    TResult Function(String provider)? linkAccount,
    TResult Function(String provider)? unlinkAccount,
    TResult Function(String newEmail, String password)? updateEmail,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    TResult Function()? initialize,
    TResult Function(bool isAuthenticated, String? userId)? authStateChanged,
    required TResult orElse(),
  }) {
    if (logout != null) {
      return logout();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Login value) login,
    required TResult Function(Logout value) logout,
    required TResult Function(Register value) register,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(SendEmailVerification value)
    sendEmailVerification,
    required TResult Function(RefreshUserData value) refreshUserData,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(RefreshPermissions value) refreshPermissions,
    required TResult Function(VerifyEmail value) verifyEmail,
    required TResult Function(ConfirmPasswordReset value) confirmPasswordReset,
    required TResult Function(Reauthenticate value) reauthenticate,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(LinkAccount value) linkAccount,
    required TResult Function(UnlinkAccount value) unlinkAccount,
    required TResult Function(UpdateEmail value) updateEmail,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
    required TResult Function(Initialize value) initialize,
    required TResult Function(AuthStateChanged value) authStateChanged,
  }) {
    return logout(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Login value)? login,
    TResult? Function(Logout value)? logout,
    TResult? Function(Register value)? register,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(SendEmailVerification value)? sendEmailVerification,
    TResult? Function(RefreshUserData value)? refreshUserData,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(RefreshPermissions value)? refreshPermissions,
    TResult? Function(VerifyEmail value)? verifyEmail,
    TResult? Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult? Function(Reauthenticate value)? reauthenticate,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(LinkAccount value)? linkAccount,
    TResult? Function(UnlinkAccount value)? unlinkAccount,
    TResult? Function(UpdateEmail value)? updateEmail,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
    TResult? Function(Initialize value)? initialize,
    TResult? Function(AuthStateChanged value)? authStateChanged,
  }) {
    return logout?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Login value)? login,
    TResult Function(Logout value)? logout,
    TResult Function(Register value)? register,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(SendEmailVerification value)? sendEmailVerification,
    TResult Function(RefreshUserData value)? refreshUserData,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(RefreshPermissions value)? refreshPermissions,
    TResult Function(VerifyEmail value)? verifyEmail,
    TResult Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult Function(Reauthenticate value)? reauthenticate,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(LinkAccount value)? linkAccount,
    TResult Function(UnlinkAccount value)? unlinkAccount,
    TResult Function(UpdateEmail value)? updateEmail,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    TResult Function(Initialize value)? initialize,
    TResult Function(AuthStateChanged value)? authStateChanged,
    required TResult orElse(),
  }) {
    if (logout != null) {
      return logout(this);
    }
    return orElse();
  }
}

abstract class Logout implements AuthEvent {
  const factory Logout() = _$LogoutImpl;
}

/// @nodoc
abstract class _$$RegisterImplCopyWith<$Res> {
  factory _$$RegisterImplCopyWith(
    _$RegisterImpl value,
    $Res Function(_$RegisterImpl) then,
  ) = __$$RegisterImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String email,
    String password,
    String fullName,
    String? phoneNumber,
  });
}

/// @nodoc
class __$$RegisterImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$RegisterImpl>
    implements _$$RegisterImplCopyWith<$Res> {
  __$$RegisterImplCopyWithImpl(
    _$RegisterImpl _value,
    $Res Function(_$RegisterImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? fullName = null,
    Object? phoneNumber = freezed,
  }) {
    return _then(
      _$RegisterImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        phoneNumber: freezed == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$RegisterImpl implements Register {
  const _$RegisterImpl({
    required this.email,
    required this.password,
    required this.fullName,
    this.phoneNumber,
  });

  @override
  final String email;
  @override
  final String password;
  @override
  final String fullName;
  @override
  final String? phoneNumber;

  @override
  String toString() {
    return 'AuthEvent.register(email: $email, password: $password, fullName: $fullName, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, email, password, fullName, phoneNumber);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterImplCopyWith<_$RegisterImpl> get copyWith =>
      __$$RegisterImplCopyWithImpl<_$RegisterImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password, bool rememberMe)
    login,
    required TResult Function() logout,
    required TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )
    register,
    required TResult Function(String email) resetPassword,
    required TResult Function(
      String? fullName,
      String? phoneNumber,
      String? photoUrl,
    )
    updateProfile,
    required TResult Function(String currentPassword, String newPassword)
    changePassword,
    required TResult Function() sendEmailVerification,
    required TResult Function() refreshUserData,
    required TResult Function(String userId, UserPermissions permissions)
    updateUserPermissions,
    required TResult Function() refreshPermissions,
    required TResult Function(String actionCode) verifyEmail,
    required TResult Function(String actionCode, String newPassword)
    confirmPasswordReset,
    required TResult Function(String password) reauthenticate,
    required TResult Function(String password) deleteAccount,
    required TResult Function(String provider) linkAccount,
    required TResult Function(String provider) unlinkAccount,
    required TResult Function(String newEmail, String password) updateEmail,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
    required TResult Function() initialize,
    required TResult Function(bool isAuthenticated, String? userId)
    authStateChanged,
  }) {
    return register(email, password, fullName, phoneNumber);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)? login,
    TResult? Function()? logout,
    TResult? Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult? Function(String email)? resetPassword,
    TResult? Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult? Function(String currentPassword, String newPassword)?
    changePassword,
    TResult? Function()? sendEmailVerification,
    TResult? Function()? refreshUserData,
    TResult? Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult? Function()? refreshPermissions,
    TResult? Function(String actionCode)? verifyEmail,
    TResult? Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult? Function(String password)? reauthenticate,
    TResult? Function(String password)? deleteAccount,
    TResult? Function(String provider)? linkAccount,
    TResult? Function(String provider)? unlinkAccount,
    TResult? Function(String newEmail, String password)? updateEmail,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
    TResult? Function()? initialize,
    TResult? Function(bool isAuthenticated, String? userId)? authStateChanged,
  }) {
    return register?.call(email, password, fullName, phoneNumber);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)? login,
    TResult Function()? logout,
    TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult Function(String email)? resetPassword,
    TResult Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult Function(String currentPassword, String newPassword)?
    changePassword,
    TResult Function()? sendEmailVerification,
    TResult Function()? refreshUserData,
    TResult Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult Function()? refreshPermissions,
    TResult Function(String actionCode)? verifyEmail,
    TResult Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult Function(String password)? reauthenticate,
    TResult Function(String password)? deleteAccount,
    TResult Function(String provider)? linkAccount,
    TResult Function(String provider)? unlinkAccount,
    TResult Function(String newEmail, String password)? updateEmail,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    TResult Function()? initialize,
    TResult Function(bool isAuthenticated, String? userId)? authStateChanged,
    required TResult orElse(),
  }) {
    if (register != null) {
      return register(email, password, fullName, phoneNumber);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Login value) login,
    required TResult Function(Logout value) logout,
    required TResult Function(Register value) register,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(SendEmailVerification value)
    sendEmailVerification,
    required TResult Function(RefreshUserData value) refreshUserData,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(RefreshPermissions value) refreshPermissions,
    required TResult Function(VerifyEmail value) verifyEmail,
    required TResult Function(ConfirmPasswordReset value) confirmPasswordReset,
    required TResult Function(Reauthenticate value) reauthenticate,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(LinkAccount value) linkAccount,
    required TResult Function(UnlinkAccount value) unlinkAccount,
    required TResult Function(UpdateEmail value) updateEmail,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
    required TResult Function(Initialize value) initialize,
    required TResult Function(AuthStateChanged value) authStateChanged,
  }) {
    return register(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Login value)? login,
    TResult? Function(Logout value)? logout,
    TResult? Function(Register value)? register,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(SendEmailVerification value)? sendEmailVerification,
    TResult? Function(RefreshUserData value)? refreshUserData,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(RefreshPermissions value)? refreshPermissions,
    TResult? Function(VerifyEmail value)? verifyEmail,
    TResult? Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult? Function(Reauthenticate value)? reauthenticate,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(LinkAccount value)? linkAccount,
    TResult? Function(UnlinkAccount value)? unlinkAccount,
    TResult? Function(UpdateEmail value)? updateEmail,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
    TResult? Function(Initialize value)? initialize,
    TResult? Function(AuthStateChanged value)? authStateChanged,
  }) {
    return register?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Login value)? login,
    TResult Function(Logout value)? logout,
    TResult Function(Register value)? register,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(SendEmailVerification value)? sendEmailVerification,
    TResult Function(RefreshUserData value)? refreshUserData,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(RefreshPermissions value)? refreshPermissions,
    TResult Function(VerifyEmail value)? verifyEmail,
    TResult Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult Function(Reauthenticate value)? reauthenticate,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(LinkAccount value)? linkAccount,
    TResult Function(UnlinkAccount value)? unlinkAccount,
    TResult Function(UpdateEmail value)? updateEmail,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    TResult Function(Initialize value)? initialize,
    TResult Function(AuthStateChanged value)? authStateChanged,
    required TResult orElse(),
  }) {
    if (register != null) {
      return register(this);
    }
    return orElse();
  }
}

abstract class Register implements AuthEvent {
  const factory Register({
    required final String email,
    required final String password,
    required final String fullName,
    final String? phoneNumber,
  }) = _$RegisterImpl;

  String get email;
  String get password;
  String get fullName;
  String? get phoneNumber;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterImplCopyWith<_$RegisterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ResetPasswordImplCopyWith<$Res> {
  factory _$$ResetPasswordImplCopyWith(
    _$ResetPasswordImpl value,
    $Res Function(_$ResetPasswordImpl) then,
  ) = __$$ResetPasswordImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email});
}

/// @nodoc
class __$$ResetPasswordImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$ResetPasswordImpl>
    implements _$$ResetPasswordImplCopyWith<$Res> {
  __$$ResetPasswordImplCopyWithImpl(
    _$ResetPasswordImpl _value,
    $Res Function(_$ResetPasswordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null}) {
    return _then(
      _$ResetPasswordImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ResetPasswordImpl implements ResetPassword {
  const _$ResetPasswordImpl({required this.email});

  @override
  final String email;

  @override
  String toString() {
    return 'AuthEvent.resetPassword(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResetPasswordImpl &&
            (identical(other.email, email) || other.email == email));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResetPasswordImplCopyWith<_$ResetPasswordImpl> get copyWith =>
      __$$ResetPasswordImplCopyWithImpl<_$ResetPasswordImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password, bool rememberMe)
    login,
    required TResult Function() logout,
    required TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )
    register,
    required TResult Function(String email) resetPassword,
    required TResult Function(
      String? fullName,
      String? phoneNumber,
      String? photoUrl,
    )
    updateProfile,
    required TResult Function(String currentPassword, String newPassword)
    changePassword,
    required TResult Function() sendEmailVerification,
    required TResult Function() refreshUserData,
    required TResult Function(String userId, UserPermissions permissions)
    updateUserPermissions,
    required TResult Function() refreshPermissions,
    required TResult Function(String actionCode) verifyEmail,
    required TResult Function(String actionCode, String newPassword)
    confirmPasswordReset,
    required TResult Function(String password) reauthenticate,
    required TResult Function(String password) deleteAccount,
    required TResult Function(String provider) linkAccount,
    required TResult Function(String provider) unlinkAccount,
    required TResult Function(String newEmail, String password) updateEmail,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
    required TResult Function() initialize,
    required TResult Function(bool isAuthenticated, String? userId)
    authStateChanged,
  }) {
    return resetPassword(email);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)? login,
    TResult? Function()? logout,
    TResult? Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult? Function(String email)? resetPassword,
    TResult? Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult? Function(String currentPassword, String newPassword)?
    changePassword,
    TResult? Function()? sendEmailVerification,
    TResult? Function()? refreshUserData,
    TResult? Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult? Function()? refreshPermissions,
    TResult? Function(String actionCode)? verifyEmail,
    TResult? Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult? Function(String password)? reauthenticate,
    TResult? Function(String password)? deleteAccount,
    TResult? Function(String provider)? linkAccount,
    TResult? Function(String provider)? unlinkAccount,
    TResult? Function(String newEmail, String password)? updateEmail,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
    TResult? Function()? initialize,
    TResult? Function(bool isAuthenticated, String? userId)? authStateChanged,
  }) {
    return resetPassword?.call(email);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)? login,
    TResult Function()? logout,
    TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult Function(String email)? resetPassword,
    TResult Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult Function(String currentPassword, String newPassword)?
    changePassword,
    TResult Function()? sendEmailVerification,
    TResult Function()? refreshUserData,
    TResult Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult Function()? refreshPermissions,
    TResult Function(String actionCode)? verifyEmail,
    TResult Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult Function(String password)? reauthenticate,
    TResult Function(String password)? deleteAccount,
    TResult Function(String provider)? linkAccount,
    TResult Function(String provider)? unlinkAccount,
    TResult Function(String newEmail, String password)? updateEmail,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    TResult Function()? initialize,
    TResult Function(bool isAuthenticated, String? userId)? authStateChanged,
    required TResult orElse(),
  }) {
    if (resetPassword != null) {
      return resetPassword(email);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Login value) login,
    required TResult Function(Logout value) logout,
    required TResult Function(Register value) register,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(SendEmailVerification value)
    sendEmailVerification,
    required TResult Function(RefreshUserData value) refreshUserData,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(RefreshPermissions value) refreshPermissions,
    required TResult Function(VerifyEmail value) verifyEmail,
    required TResult Function(ConfirmPasswordReset value) confirmPasswordReset,
    required TResult Function(Reauthenticate value) reauthenticate,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(LinkAccount value) linkAccount,
    required TResult Function(UnlinkAccount value) unlinkAccount,
    required TResult Function(UpdateEmail value) updateEmail,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
    required TResult Function(Initialize value) initialize,
    required TResult Function(AuthStateChanged value) authStateChanged,
  }) {
    return resetPassword(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Login value)? login,
    TResult? Function(Logout value)? logout,
    TResult? Function(Register value)? register,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(SendEmailVerification value)? sendEmailVerification,
    TResult? Function(RefreshUserData value)? refreshUserData,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(RefreshPermissions value)? refreshPermissions,
    TResult? Function(VerifyEmail value)? verifyEmail,
    TResult? Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult? Function(Reauthenticate value)? reauthenticate,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(LinkAccount value)? linkAccount,
    TResult? Function(UnlinkAccount value)? unlinkAccount,
    TResult? Function(UpdateEmail value)? updateEmail,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
    TResult? Function(Initialize value)? initialize,
    TResult? Function(AuthStateChanged value)? authStateChanged,
  }) {
    return resetPassword?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Login value)? login,
    TResult Function(Logout value)? logout,
    TResult Function(Register value)? register,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(SendEmailVerification value)? sendEmailVerification,
    TResult Function(RefreshUserData value)? refreshUserData,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(RefreshPermissions value)? refreshPermissions,
    TResult Function(VerifyEmail value)? verifyEmail,
    TResult Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult Function(Reauthenticate value)? reauthenticate,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(LinkAccount value)? linkAccount,
    TResult Function(UnlinkAccount value)? unlinkAccount,
    TResult Function(UpdateEmail value)? updateEmail,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    TResult Function(Initialize value)? initialize,
    TResult Function(AuthStateChanged value)? authStateChanged,
    required TResult orElse(),
  }) {
    if (resetPassword != null) {
      return resetPassword(this);
    }
    return orElse();
  }
}

abstract class ResetPassword implements AuthEvent {
  const factory ResetPassword({required final String email}) =
      _$ResetPasswordImpl;

  String get email;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResetPasswordImplCopyWith<_$ResetPasswordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateProfileImplCopyWith<$Res> {
  factory _$$UpdateProfileImplCopyWith(
    _$UpdateProfileImpl value,
    $Res Function(_$UpdateProfileImpl) then,
  ) = __$$UpdateProfileImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? fullName, String? phoneNumber, String? photoUrl});
}

/// @nodoc
class __$$UpdateProfileImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$UpdateProfileImpl>
    implements _$$UpdateProfileImplCopyWith<$Res> {
  __$$UpdateProfileImplCopyWithImpl(
    _$UpdateProfileImpl _value,
    $Res Function(_$UpdateProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = freezed,
    Object? phoneNumber = freezed,
    Object? photoUrl = freezed,
  }) {
    return _then(
      _$UpdateProfileImpl(
        fullName: freezed == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String?,
        phoneNumber: freezed == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoUrl: freezed == photoUrl
            ? _value.photoUrl
            : photoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$UpdateProfileImpl implements UpdateProfile {
  const _$UpdateProfileImpl({this.fullName, this.phoneNumber, this.photoUrl});

  @override
  final String? fullName;
  @override
  final String? phoneNumber;
  @override
  final String? photoUrl;

  @override
  String toString() {
    return 'AuthEvent.updateProfile(fullName: $fullName, phoneNumber: $phoneNumber, photoUrl: $photoUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateProfileImpl &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fullName, phoneNumber, photoUrl);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateProfileImplCopyWith<_$UpdateProfileImpl> get copyWith =>
      __$$UpdateProfileImplCopyWithImpl<_$UpdateProfileImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password, bool rememberMe)
    login,
    required TResult Function() logout,
    required TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )
    register,
    required TResult Function(String email) resetPassword,
    required TResult Function(
      String? fullName,
      String? phoneNumber,
      String? photoUrl,
    )
    updateProfile,
    required TResult Function(String currentPassword, String newPassword)
    changePassword,
    required TResult Function() sendEmailVerification,
    required TResult Function() refreshUserData,
    required TResult Function(String userId, UserPermissions permissions)
    updateUserPermissions,
    required TResult Function() refreshPermissions,
    required TResult Function(String actionCode) verifyEmail,
    required TResult Function(String actionCode, String newPassword)
    confirmPasswordReset,
    required TResult Function(String password) reauthenticate,
    required TResult Function(String password) deleteAccount,
    required TResult Function(String provider) linkAccount,
    required TResult Function(String provider) unlinkAccount,
    required TResult Function(String newEmail, String password) updateEmail,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
    required TResult Function() initialize,
    required TResult Function(bool isAuthenticated, String? userId)
    authStateChanged,
  }) {
    return updateProfile(fullName, phoneNumber, photoUrl);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)? login,
    TResult? Function()? logout,
    TResult? Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult? Function(String email)? resetPassword,
    TResult? Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult? Function(String currentPassword, String newPassword)?
    changePassword,
    TResult? Function()? sendEmailVerification,
    TResult? Function()? refreshUserData,
    TResult? Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult? Function()? refreshPermissions,
    TResult? Function(String actionCode)? verifyEmail,
    TResult? Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult? Function(String password)? reauthenticate,
    TResult? Function(String password)? deleteAccount,
    TResult? Function(String provider)? linkAccount,
    TResult? Function(String provider)? unlinkAccount,
    TResult? Function(String newEmail, String password)? updateEmail,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
    TResult? Function()? initialize,
    TResult? Function(bool isAuthenticated, String? userId)? authStateChanged,
  }) {
    return updateProfile?.call(fullName, phoneNumber, photoUrl);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)? login,
    TResult Function()? logout,
    TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult Function(String email)? resetPassword,
    TResult Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult Function(String currentPassword, String newPassword)?
    changePassword,
    TResult Function()? sendEmailVerification,
    TResult Function()? refreshUserData,
    TResult Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult Function()? refreshPermissions,
    TResult Function(String actionCode)? verifyEmail,
    TResult Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult Function(String password)? reauthenticate,
    TResult Function(String password)? deleteAccount,
    TResult Function(String provider)? linkAccount,
    TResult Function(String provider)? unlinkAccount,
    TResult Function(String newEmail, String password)? updateEmail,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    TResult Function()? initialize,
    TResult Function(bool isAuthenticated, String? userId)? authStateChanged,
    required TResult orElse(),
  }) {
    if (updateProfile != null) {
      return updateProfile(fullName, phoneNumber, photoUrl);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Login value) login,
    required TResult Function(Logout value) logout,
    required TResult Function(Register value) register,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(SendEmailVerification value)
    sendEmailVerification,
    required TResult Function(RefreshUserData value) refreshUserData,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(RefreshPermissions value) refreshPermissions,
    required TResult Function(VerifyEmail value) verifyEmail,
    required TResult Function(ConfirmPasswordReset value) confirmPasswordReset,
    required TResult Function(Reauthenticate value) reauthenticate,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(LinkAccount value) linkAccount,
    required TResult Function(UnlinkAccount value) unlinkAccount,
    required TResult Function(UpdateEmail value) updateEmail,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
    required TResult Function(Initialize value) initialize,
    required TResult Function(AuthStateChanged value) authStateChanged,
  }) {
    return updateProfile(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Login value)? login,
    TResult? Function(Logout value)? logout,
    TResult? Function(Register value)? register,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(SendEmailVerification value)? sendEmailVerification,
    TResult? Function(RefreshUserData value)? refreshUserData,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(RefreshPermissions value)? refreshPermissions,
    TResult? Function(VerifyEmail value)? verifyEmail,
    TResult? Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult? Function(Reauthenticate value)? reauthenticate,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(LinkAccount value)? linkAccount,
    TResult? Function(UnlinkAccount value)? unlinkAccount,
    TResult? Function(UpdateEmail value)? updateEmail,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
    TResult? Function(Initialize value)? initialize,
    TResult? Function(AuthStateChanged value)? authStateChanged,
  }) {
    return updateProfile?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Login value)? login,
    TResult Function(Logout value)? logout,
    TResult Function(Register value)? register,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(SendEmailVerification value)? sendEmailVerification,
    TResult Function(RefreshUserData value)? refreshUserData,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(RefreshPermissions value)? refreshPermissions,
    TResult Function(VerifyEmail value)? verifyEmail,
    TResult Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult Function(Reauthenticate value)? reauthenticate,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(LinkAccount value)? linkAccount,
    TResult Function(UnlinkAccount value)? unlinkAccount,
    TResult Function(UpdateEmail value)? updateEmail,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    TResult Function(Initialize value)? initialize,
    TResult Function(AuthStateChanged value)? authStateChanged,
    required TResult orElse(),
  }) {
    if (updateProfile != null) {
      return updateProfile(this);
    }
    return orElse();
  }
}

abstract class UpdateProfile implements AuthEvent {
  const factory UpdateProfile({
    final String? fullName,
    final String? phoneNumber,
    final String? photoUrl,
  }) = _$UpdateProfileImpl;

  String? get fullName;
  String? get phoneNumber;
  String? get photoUrl;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateProfileImplCopyWith<_$UpdateProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ChangePasswordImplCopyWith<$Res> {
  factory _$$ChangePasswordImplCopyWith(
    _$ChangePasswordImpl value,
    $Res Function(_$ChangePasswordImpl) then,
  ) = __$$ChangePasswordImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String currentPassword, String newPassword});
}

/// @nodoc
class __$$ChangePasswordImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$ChangePasswordImpl>
    implements _$$ChangePasswordImplCopyWith<$Res> {
  __$$ChangePasswordImplCopyWithImpl(
    _$ChangePasswordImpl _value,
    $Res Function(_$ChangePasswordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? currentPassword = null, Object? newPassword = null}) {
    return _then(
      _$ChangePasswordImpl(
        currentPassword: null == currentPassword
            ? _value.currentPassword
            : currentPassword // ignore: cast_nullable_to_non_nullable
                  as String,
        newPassword: null == newPassword
            ? _value.newPassword
            : newPassword // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ChangePasswordImpl implements ChangePassword {
  const _$ChangePasswordImpl({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  final String currentPassword;
  @override
  final String newPassword;

  @override
  String toString() {
    return 'AuthEvent.changePassword(currentPassword: $currentPassword, newPassword: $newPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangePasswordImpl &&
            (identical(other.currentPassword, currentPassword) ||
                other.currentPassword == currentPassword) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentPassword, newPassword);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangePasswordImplCopyWith<_$ChangePasswordImpl> get copyWith =>
      __$$ChangePasswordImplCopyWithImpl<_$ChangePasswordImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password, bool rememberMe)
    login,
    required TResult Function() logout,
    required TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )
    register,
    required TResult Function(String email) resetPassword,
    required TResult Function(
      String? fullName,
      String? phoneNumber,
      String? photoUrl,
    )
    updateProfile,
    required TResult Function(String currentPassword, String newPassword)
    changePassword,
    required TResult Function() sendEmailVerification,
    required TResult Function() refreshUserData,
    required TResult Function(String userId, UserPermissions permissions)
    updateUserPermissions,
    required TResult Function() refreshPermissions,
    required TResult Function(String actionCode) verifyEmail,
    required TResult Function(String actionCode, String newPassword)
    confirmPasswordReset,
    required TResult Function(String password) reauthenticate,
    required TResult Function(String password) deleteAccount,
    required TResult Function(String provider) linkAccount,
    required TResult Function(String provider) unlinkAccount,
    required TResult Function(String newEmail, String password) updateEmail,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
    required TResult Function() initialize,
    required TResult Function(bool isAuthenticated, String? userId)
    authStateChanged,
  }) {
    return changePassword(currentPassword, newPassword);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)? login,
    TResult? Function()? logout,
    TResult? Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult? Function(String email)? resetPassword,
    TResult? Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult? Function(String currentPassword, String newPassword)?
    changePassword,
    TResult? Function()? sendEmailVerification,
    TResult? Function()? refreshUserData,
    TResult? Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult? Function()? refreshPermissions,
    TResult? Function(String actionCode)? verifyEmail,
    TResult? Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult? Function(String password)? reauthenticate,
    TResult? Function(String password)? deleteAccount,
    TResult? Function(String provider)? linkAccount,
    TResult? Function(String provider)? unlinkAccount,
    TResult? Function(String newEmail, String password)? updateEmail,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
    TResult? Function()? initialize,
    TResult? Function(bool isAuthenticated, String? userId)? authStateChanged,
  }) {
    return changePassword?.call(currentPassword, newPassword);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)? login,
    TResult Function()? logout,
    TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult Function(String email)? resetPassword,
    TResult Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult Function(String currentPassword, String newPassword)?
    changePassword,
    TResult Function()? sendEmailVerification,
    TResult Function()? refreshUserData,
    TResult Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult Function()? refreshPermissions,
    TResult Function(String actionCode)? verifyEmail,
    TResult Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult Function(String password)? reauthenticate,
    TResult Function(String password)? deleteAccount,
    TResult Function(String provider)? linkAccount,
    TResult Function(String provider)? unlinkAccount,
    TResult Function(String newEmail, String password)? updateEmail,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    TResult Function()? initialize,
    TResult Function(bool isAuthenticated, String? userId)? authStateChanged,
    required TResult orElse(),
  }) {
    if (changePassword != null) {
      return changePassword(currentPassword, newPassword);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Login value) login,
    required TResult Function(Logout value) logout,
    required TResult Function(Register value) register,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(SendEmailVerification value)
    sendEmailVerification,
    required TResult Function(RefreshUserData value) refreshUserData,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(RefreshPermissions value) refreshPermissions,
    required TResult Function(VerifyEmail value) verifyEmail,
    required TResult Function(ConfirmPasswordReset value) confirmPasswordReset,
    required TResult Function(Reauthenticate value) reauthenticate,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(LinkAccount value) linkAccount,
    required TResult Function(UnlinkAccount value) unlinkAccount,
    required TResult Function(UpdateEmail value) updateEmail,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
    required TResult Function(Initialize value) initialize,
    required TResult Function(AuthStateChanged value) authStateChanged,
  }) {
    return changePassword(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Login value)? login,
    TResult? Function(Logout value)? logout,
    TResult? Function(Register value)? register,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(SendEmailVerification value)? sendEmailVerification,
    TResult? Function(RefreshUserData value)? refreshUserData,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(RefreshPermissions value)? refreshPermissions,
    TResult? Function(VerifyEmail value)? verifyEmail,
    TResult? Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult? Function(Reauthenticate value)? reauthenticate,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(LinkAccount value)? linkAccount,
    TResult? Function(UnlinkAccount value)? unlinkAccount,
    TResult? Function(UpdateEmail value)? updateEmail,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
    TResult? Function(Initialize value)? initialize,
    TResult? Function(AuthStateChanged value)? authStateChanged,
  }) {
    return changePassword?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Login value)? login,
    TResult Function(Logout value)? logout,
    TResult Function(Register value)? register,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(SendEmailVerification value)? sendEmailVerification,
    TResult Function(RefreshUserData value)? refreshUserData,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(RefreshPermissions value)? refreshPermissions,
    TResult Function(VerifyEmail value)? verifyEmail,
    TResult Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult Function(Reauthenticate value)? reauthenticate,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(LinkAccount value)? linkAccount,
    TResult Function(UnlinkAccount value)? unlinkAccount,
    TResult Function(UpdateEmail value)? updateEmail,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    TResult Function(Initialize value)? initialize,
    TResult Function(AuthStateChanged value)? authStateChanged,
    required TResult orElse(),
  }) {
    if (changePassword != null) {
      return changePassword(this);
    }
    return orElse();
  }
}

abstract class ChangePassword implements AuthEvent {
  const factory ChangePassword({
    required final String currentPassword,
    required final String newPassword,
  }) = _$ChangePasswordImpl;

  String get currentPassword;
  String get newPassword;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChangePasswordImplCopyWith<_$ChangePasswordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SendEmailVerificationImplCopyWith<$Res> {
  factory _$$SendEmailVerificationImplCopyWith(
    _$SendEmailVerificationImpl value,
    $Res Function(_$SendEmailVerificationImpl) then,
  ) = __$$SendEmailVerificationImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SendEmailVerificationImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$SendEmailVerificationImpl>
    implements _$$SendEmailVerificationImplCopyWith<$Res> {
  __$$SendEmailVerificationImplCopyWithImpl(
    _$SendEmailVerificationImpl _value,
    $Res Function(_$SendEmailVerificationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SendEmailVerificationImpl implements SendEmailVerification {
  const _$SendEmailVerificationImpl();

  @override
  String toString() {
    return 'AuthEvent.sendEmailVerification()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SendEmailVerificationImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password, bool rememberMe)
    login,
    required TResult Function() logout,
    required TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )
    register,
    required TResult Function(String email) resetPassword,
    required TResult Function(
      String? fullName,
      String? phoneNumber,
      String? photoUrl,
    )
    updateProfile,
    required TResult Function(String currentPassword, String newPassword)
    changePassword,
    required TResult Function() sendEmailVerification,
    required TResult Function() refreshUserData,
    required TResult Function(String userId, UserPermissions permissions)
    updateUserPermissions,
    required TResult Function() refreshPermissions,
    required TResult Function(String actionCode) verifyEmail,
    required TResult Function(String actionCode, String newPassword)
    confirmPasswordReset,
    required TResult Function(String password) reauthenticate,
    required TResult Function(String password) deleteAccount,
    required TResult Function(String provider) linkAccount,
    required TResult Function(String provider) unlinkAccount,
    required TResult Function(String newEmail, String password) updateEmail,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
    required TResult Function() initialize,
    required TResult Function(bool isAuthenticated, String? userId)
    authStateChanged,
  }) {
    return sendEmailVerification();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)? login,
    TResult? Function()? logout,
    TResult? Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult? Function(String email)? resetPassword,
    TResult? Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult? Function(String currentPassword, String newPassword)?
    changePassword,
    TResult? Function()? sendEmailVerification,
    TResult? Function()? refreshUserData,
    TResult? Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult? Function()? refreshPermissions,
    TResult? Function(String actionCode)? verifyEmail,
    TResult? Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult? Function(String password)? reauthenticate,
    TResult? Function(String password)? deleteAccount,
    TResult? Function(String provider)? linkAccount,
    TResult? Function(String provider)? unlinkAccount,
    TResult? Function(String newEmail, String password)? updateEmail,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
    TResult? Function()? initialize,
    TResult? Function(bool isAuthenticated, String? userId)? authStateChanged,
  }) {
    return sendEmailVerification?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)? login,
    TResult Function()? logout,
    TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult Function(String email)? resetPassword,
    TResult Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult Function(String currentPassword, String newPassword)?
    changePassword,
    TResult Function()? sendEmailVerification,
    TResult Function()? refreshUserData,
    TResult Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult Function()? refreshPermissions,
    TResult Function(String actionCode)? verifyEmail,
    TResult Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult Function(String password)? reauthenticate,
    TResult Function(String password)? deleteAccount,
    TResult Function(String provider)? linkAccount,
    TResult Function(String provider)? unlinkAccount,
    TResult Function(String newEmail, String password)? updateEmail,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    TResult Function()? initialize,
    TResult Function(bool isAuthenticated, String? userId)? authStateChanged,
    required TResult orElse(),
  }) {
    if (sendEmailVerification != null) {
      return sendEmailVerification();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Login value) login,
    required TResult Function(Logout value) logout,
    required TResult Function(Register value) register,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(SendEmailVerification value)
    sendEmailVerification,
    required TResult Function(RefreshUserData value) refreshUserData,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(RefreshPermissions value) refreshPermissions,
    required TResult Function(VerifyEmail value) verifyEmail,
    required TResult Function(ConfirmPasswordReset value) confirmPasswordReset,
    required TResult Function(Reauthenticate value) reauthenticate,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(LinkAccount value) linkAccount,
    required TResult Function(UnlinkAccount value) unlinkAccount,
    required TResult Function(UpdateEmail value) updateEmail,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
    required TResult Function(Initialize value) initialize,
    required TResult Function(AuthStateChanged value) authStateChanged,
  }) {
    return sendEmailVerification(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Login value)? login,
    TResult? Function(Logout value)? logout,
    TResult? Function(Register value)? register,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(SendEmailVerification value)? sendEmailVerification,
    TResult? Function(RefreshUserData value)? refreshUserData,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(RefreshPermissions value)? refreshPermissions,
    TResult? Function(VerifyEmail value)? verifyEmail,
    TResult? Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult? Function(Reauthenticate value)? reauthenticate,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(LinkAccount value)? linkAccount,
    TResult? Function(UnlinkAccount value)? unlinkAccount,
    TResult? Function(UpdateEmail value)? updateEmail,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
    TResult? Function(Initialize value)? initialize,
    TResult? Function(AuthStateChanged value)? authStateChanged,
  }) {
    return sendEmailVerification?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Login value)? login,
    TResult Function(Logout value)? logout,
    TResult Function(Register value)? register,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(SendEmailVerification value)? sendEmailVerification,
    TResult Function(RefreshUserData value)? refreshUserData,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(RefreshPermissions value)? refreshPermissions,
    TResult Function(VerifyEmail value)? verifyEmail,
    TResult Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult Function(Reauthenticate value)? reauthenticate,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(LinkAccount value)? linkAccount,
    TResult Function(UnlinkAccount value)? unlinkAccount,
    TResult Function(UpdateEmail value)? updateEmail,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    TResult Function(Initialize value)? initialize,
    TResult Function(AuthStateChanged value)? authStateChanged,
    required TResult orElse(),
  }) {
    if (sendEmailVerification != null) {
      return sendEmailVerification(this);
    }
    return orElse();
  }
}

abstract class SendEmailVerification implements AuthEvent {
  const factory SendEmailVerification() = _$SendEmailVerificationImpl;
}

/// @nodoc
abstract class _$$RefreshUserDataImplCopyWith<$Res> {
  factory _$$RefreshUserDataImplCopyWith(
    _$RefreshUserDataImpl value,
    $Res Function(_$RefreshUserDataImpl) then,
  ) = __$$RefreshUserDataImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RefreshUserDataImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$RefreshUserDataImpl>
    implements _$$RefreshUserDataImplCopyWith<$Res> {
  __$$RefreshUserDataImplCopyWithImpl(
    _$RefreshUserDataImpl _value,
    $Res Function(_$RefreshUserDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RefreshUserDataImpl implements RefreshUserData {
  const _$RefreshUserDataImpl();

  @override
  String toString() {
    return 'AuthEvent.refreshUserData()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RefreshUserDataImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password, bool rememberMe)
    login,
    required TResult Function() logout,
    required TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )
    register,
    required TResult Function(String email) resetPassword,
    required TResult Function(
      String? fullName,
      String? phoneNumber,
      String? photoUrl,
    )
    updateProfile,
    required TResult Function(String currentPassword, String newPassword)
    changePassword,
    required TResult Function() sendEmailVerification,
    required TResult Function() refreshUserData,
    required TResult Function(String userId, UserPermissions permissions)
    updateUserPermissions,
    required TResult Function() refreshPermissions,
    required TResult Function(String actionCode) verifyEmail,
    required TResult Function(String actionCode, String newPassword)
    confirmPasswordReset,
    required TResult Function(String password) reauthenticate,
    required TResult Function(String password) deleteAccount,
    required TResult Function(String provider) linkAccount,
    required TResult Function(String provider) unlinkAccount,
    required TResult Function(String newEmail, String password) updateEmail,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
    required TResult Function() initialize,
    required TResult Function(bool isAuthenticated, String? userId)
    authStateChanged,
  }) {
    return refreshUserData();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)? login,
    TResult? Function()? logout,
    TResult? Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult? Function(String email)? resetPassword,
    TResult? Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult? Function(String currentPassword, String newPassword)?
    changePassword,
    TResult? Function()? sendEmailVerification,
    TResult? Function()? refreshUserData,
    TResult? Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult? Function()? refreshPermissions,
    TResult? Function(String actionCode)? verifyEmail,
    TResult? Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult? Function(String password)? reauthenticate,
    TResult? Function(String password)? deleteAccount,
    TResult? Function(String provider)? linkAccount,
    TResult? Function(String provider)? unlinkAccount,
    TResult? Function(String newEmail, String password)? updateEmail,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
    TResult? Function()? initialize,
    TResult? Function(bool isAuthenticated, String? userId)? authStateChanged,
  }) {
    return refreshUserData?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)? login,
    TResult Function()? logout,
    TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult Function(String email)? resetPassword,
    TResult Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult Function(String currentPassword, String newPassword)?
    changePassword,
    TResult Function()? sendEmailVerification,
    TResult Function()? refreshUserData,
    TResult Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult Function()? refreshPermissions,
    TResult Function(String actionCode)? verifyEmail,
    TResult Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult Function(String password)? reauthenticate,
    TResult Function(String password)? deleteAccount,
    TResult Function(String provider)? linkAccount,
    TResult Function(String provider)? unlinkAccount,
    TResult Function(String newEmail, String password)? updateEmail,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    TResult Function()? initialize,
    TResult Function(bool isAuthenticated, String? userId)? authStateChanged,
    required TResult orElse(),
  }) {
    if (refreshUserData != null) {
      return refreshUserData();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Login value) login,
    required TResult Function(Logout value) logout,
    required TResult Function(Register value) register,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(SendEmailVerification value)
    sendEmailVerification,
    required TResult Function(RefreshUserData value) refreshUserData,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(RefreshPermissions value) refreshPermissions,
    required TResult Function(VerifyEmail value) verifyEmail,
    required TResult Function(ConfirmPasswordReset value) confirmPasswordReset,
    required TResult Function(Reauthenticate value) reauthenticate,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(LinkAccount value) linkAccount,
    required TResult Function(UnlinkAccount value) unlinkAccount,
    required TResult Function(UpdateEmail value) updateEmail,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
    required TResult Function(Initialize value) initialize,
    required TResult Function(AuthStateChanged value) authStateChanged,
  }) {
    return refreshUserData(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Login value)? login,
    TResult? Function(Logout value)? logout,
    TResult? Function(Register value)? register,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(SendEmailVerification value)? sendEmailVerification,
    TResult? Function(RefreshUserData value)? refreshUserData,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(RefreshPermissions value)? refreshPermissions,
    TResult? Function(VerifyEmail value)? verifyEmail,
    TResult? Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult? Function(Reauthenticate value)? reauthenticate,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(LinkAccount value)? linkAccount,
    TResult? Function(UnlinkAccount value)? unlinkAccount,
    TResult? Function(UpdateEmail value)? updateEmail,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
    TResult? Function(Initialize value)? initialize,
    TResult? Function(AuthStateChanged value)? authStateChanged,
  }) {
    return refreshUserData?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Login value)? login,
    TResult Function(Logout value)? logout,
    TResult Function(Register value)? register,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(SendEmailVerification value)? sendEmailVerification,
    TResult Function(RefreshUserData value)? refreshUserData,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(RefreshPermissions value)? refreshPermissions,
    TResult Function(VerifyEmail value)? verifyEmail,
    TResult Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult Function(Reauthenticate value)? reauthenticate,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(LinkAccount value)? linkAccount,
    TResult Function(UnlinkAccount value)? unlinkAccount,
    TResult Function(UpdateEmail value)? updateEmail,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    TResult Function(Initialize value)? initialize,
    TResult Function(AuthStateChanged value)? authStateChanged,
    required TResult orElse(),
  }) {
    if (refreshUserData != null) {
      return refreshUserData(this);
    }
    return orElse();
  }
}

abstract class RefreshUserData implements AuthEvent {
  const factory RefreshUserData() = _$RefreshUserDataImpl;
}

/// @nodoc
abstract class _$$UpdateUserPermissionsImplCopyWith<$Res> {
  factory _$$UpdateUserPermissionsImplCopyWith(
    _$UpdateUserPermissionsImpl value,
    $Res Function(_$UpdateUserPermissionsImpl) then,
  ) = __$$UpdateUserPermissionsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String userId, UserPermissions permissions});
}

/// @nodoc
class __$$UpdateUserPermissionsImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$UpdateUserPermissionsImpl>
    implements _$$UpdateUserPermissionsImplCopyWith<$Res> {
  __$$UpdateUserPermissionsImplCopyWithImpl(
    _$UpdateUserPermissionsImpl _value,
    $Res Function(_$UpdateUserPermissionsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? userId = null, Object? permissions = null}) {
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
      ),
    );
  }
}

/// @nodoc

class _$UpdateUserPermissionsImpl implements UpdateUserPermissions {
  const _$UpdateUserPermissionsImpl({
    required this.userId,
    required this.permissions,
  });

  @override
  final String userId;
  @override
  final UserPermissions permissions;

  @override
  String toString() {
    return 'AuthEvent.updateUserPermissions(userId: $userId, permissions: $permissions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateUserPermissionsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.permissions, permissions) ||
                other.permissions == permissions));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, permissions);

  /// Create a copy of AuthEvent
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
    required TResult Function(String email, String password, bool rememberMe)
    login,
    required TResult Function() logout,
    required TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )
    register,
    required TResult Function(String email) resetPassword,
    required TResult Function(
      String? fullName,
      String? phoneNumber,
      String? photoUrl,
    )
    updateProfile,
    required TResult Function(String currentPassword, String newPassword)
    changePassword,
    required TResult Function() sendEmailVerification,
    required TResult Function() refreshUserData,
    required TResult Function(String userId, UserPermissions permissions)
    updateUserPermissions,
    required TResult Function() refreshPermissions,
    required TResult Function(String actionCode) verifyEmail,
    required TResult Function(String actionCode, String newPassword)
    confirmPasswordReset,
    required TResult Function(String password) reauthenticate,
    required TResult Function(String password) deleteAccount,
    required TResult Function(String provider) linkAccount,
    required TResult Function(String provider) unlinkAccount,
    required TResult Function(String newEmail, String password) updateEmail,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
    required TResult Function() initialize,
    required TResult Function(bool isAuthenticated, String? userId)
    authStateChanged,
  }) {
    return updateUserPermissions(userId, permissions);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)? login,
    TResult? Function()? logout,
    TResult? Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult? Function(String email)? resetPassword,
    TResult? Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult? Function(String currentPassword, String newPassword)?
    changePassword,
    TResult? Function()? sendEmailVerification,
    TResult? Function()? refreshUserData,
    TResult? Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult? Function()? refreshPermissions,
    TResult? Function(String actionCode)? verifyEmail,
    TResult? Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult? Function(String password)? reauthenticate,
    TResult? Function(String password)? deleteAccount,
    TResult? Function(String provider)? linkAccount,
    TResult? Function(String provider)? unlinkAccount,
    TResult? Function(String newEmail, String password)? updateEmail,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
    TResult? Function()? initialize,
    TResult? Function(bool isAuthenticated, String? userId)? authStateChanged,
  }) {
    return updateUserPermissions?.call(userId, permissions);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)? login,
    TResult Function()? logout,
    TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult Function(String email)? resetPassword,
    TResult Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult Function(String currentPassword, String newPassword)?
    changePassword,
    TResult Function()? sendEmailVerification,
    TResult Function()? refreshUserData,
    TResult Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult Function()? refreshPermissions,
    TResult Function(String actionCode)? verifyEmail,
    TResult Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult Function(String password)? reauthenticate,
    TResult Function(String password)? deleteAccount,
    TResult Function(String provider)? linkAccount,
    TResult Function(String provider)? unlinkAccount,
    TResult Function(String newEmail, String password)? updateEmail,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    TResult Function()? initialize,
    TResult Function(bool isAuthenticated, String? userId)? authStateChanged,
    required TResult orElse(),
  }) {
    if (updateUserPermissions != null) {
      return updateUserPermissions(userId, permissions);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Login value) login,
    required TResult Function(Logout value) logout,
    required TResult Function(Register value) register,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(SendEmailVerification value)
    sendEmailVerification,
    required TResult Function(RefreshUserData value) refreshUserData,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(RefreshPermissions value) refreshPermissions,
    required TResult Function(VerifyEmail value) verifyEmail,
    required TResult Function(ConfirmPasswordReset value) confirmPasswordReset,
    required TResult Function(Reauthenticate value) reauthenticate,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(LinkAccount value) linkAccount,
    required TResult Function(UnlinkAccount value) unlinkAccount,
    required TResult Function(UpdateEmail value) updateEmail,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
    required TResult Function(Initialize value) initialize,
    required TResult Function(AuthStateChanged value) authStateChanged,
  }) {
    return updateUserPermissions(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Login value)? login,
    TResult? Function(Logout value)? logout,
    TResult? Function(Register value)? register,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(SendEmailVerification value)? sendEmailVerification,
    TResult? Function(RefreshUserData value)? refreshUserData,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(RefreshPermissions value)? refreshPermissions,
    TResult? Function(VerifyEmail value)? verifyEmail,
    TResult? Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult? Function(Reauthenticate value)? reauthenticate,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(LinkAccount value)? linkAccount,
    TResult? Function(UnlinkAccount value)? unlinkAccount,
    TResult? Function(UpdateEmail value)? updateEmail,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
    TResult? Function(Initialize value)? initialize,
    TResult? Function(AuthStateChanged value)? authStateChanged,
  }) {
    return updateUserPermissions?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Login value)? login,
    TResult Function(Logout value)? logout,
    TResult Function(Register value)? register,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(SendEmailVerification value)? sendEmailVerification,
    TResult Function(RefreshUserData value)? refreshUserData,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(RefreshPermissions value)? refreshPermissions,
    TResult Function(VerifyEmail value)? verifyEmail,
    TResult Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult Function(Reauthenticate value)? reauthenticate,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(LinkAccount value)? linkAccount,
    TResult Function(UnlinkAccount value)? unlinkAccount,
    TResult Function(UpdateEmail value)? updateEmail,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    TResult Function(Initialize value)? initialize,
    TResult Function(AuthStateChanged value)? authStateChanged,
    required TResult orElse(),
  }) {
    if (updateUserPermissions != null) {
      return updateUserPermissions(this);
    }
    return orElse();
  }
}

abstract class UpdateUserPermissions implements AuthEvent {
  const factory UpdateUserPermissions({
    required final String userId,
    required final UserPermissions permissions,
  }) = _$UpdateUserPermissionsImpl;

  String get userId;
  UserPermissions get permissions;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateUserPermissionsImplCopyWith<_$UpdateUserPermissionsImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RefreshPermissionsImplCopyWith<$Res> {
  factory _$$RefreshPermissionsImplCopyWith(
    _$RefreshPermissionsImpl value,
    $Res Function(_$RefreshPermissionsImpl) then,
  ) = __$$RefreshPermissionsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RefreshPermissionsImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$RefreshPermissionsImpl>
    implements _$$RefreshPermissionsImplCopyWith<$Res> {
  __$$RefreshPermissionsImplCopyWithImpl(
    _$RefreshPermissionsImpl _value,
    $Res Function(_$RefreshPermissionsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RefreshPermissionsImpl implements RefreshPermissions {
  const _$RefreshPermissionsImpl();

  @override
  String toString() {
    return 'AuthEvent.refreshPermissions()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RefreshPermissionsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password, bool rememberMe)
    login,
    required TResult Function() logout,
    required TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )
    register,
    required TResult Function(String email) resetPassword,
    required TResult Function(
      String? fullName,
      String? phoneNumber,
      String? photoUrl,
    )
    updateProfile,
    required TResult Function(String currentPassword, String newPassword)
    changePassword,
    required TResult Function() sendEmailVerification,
    required TResult Function() refreshUserData,
    required TResult Function(String userId, UserPermissions permissions)
    updateUserPermissions,
    required TResult Function() refreshPermissions,
    required TResult Function(String actionCode) verifyEmail,
    required TResult Function(String actionCode, String newPassword)
    confirmPasswordReset,
    required TResult Function(String password) reauthenticate,
    required TResult Function(String password) deleteAccount,
    required TResult Function(String provider) linkAccount,
    required TResult Function(String provider) unlinkAccount,
    required TResult Function(String newEmail, String password) updateEmail,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
    required TResult Function() initialize,
    required TResult Function(bool isAuthenticated, String? userId)
    authStateChanged,
  }) {
    return refreshPermissions();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)? login,
    TResult? Function()? logout,
    TResult? Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult? Function(String email)? resetPassword,
    TResult? Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult? Function(String currentPassword, String newPassword)?
    changePassword,
    TResult? Function()? sendEmailVerification,
    TResult? Function()? refreshUserData,
    TResult? Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult? Function()? refreshPermissions,
    TResult? Function(String actionCode)? verifyEmail,
    TResult? Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult? Function(String password)? reauthenticate,
    TResult? Function(String password)? deleteAccount,
    TResult? Function(String provider)? linkAccount,
    TResult? Function(String provider)? unlinkAccount,
    TResult? Function(String newEmail, String password)? updateEmail,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
    TResult? Function()? initialize,
    TResult? Function(bool isAuthenticated, String? userId)? authStateChanged,
  }) {
    return refreshPermissions?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)? login,
    TResult Function()? logout,
    TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult Function(String email)? resetPassword,
    TResult Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult Function(String currentPassword, String newPassword)?
    changePassword,
    TResult Function()? sendEmailVerification,
    TResult Function()? refreshUserData,
    TResult Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult Function()? refreshPermissions,
    TResult Function(String actionCode)? verifyEmail,
    TResult Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult Function(String password)? reauthenticate,
    TResult Function(String password)? deleteAccount,
    TResult Function(String provider)? linkAccount,
    TResult Function(String provider)? unlinkAccount,
    TResult Function(String newEmail, String password)? updateEmail,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    TResult Function()? initialize,
    TResult Function(bool isAuthenticated, String? userId)? authStateChanged,
    required TResult orElse(),
  }) {
    if (refreshPermissions != null) {
      return refreshPermissions();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Login value) login,
    required TResult Function(Logout value) logout,
    required TResult Function(Register value) register,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(SendEmailVerification value)
    sendEmailVerification,
    required TResult Function(RefreshUserData value) refreshUserData,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(RefreshPermissions value) refreshPermissions,
    required TResult Function(VerifyEmail value) verifyEmail,
    required TResult Function(ConfirmPasswordReset value) confirmPasswordReset,
    required TResult Function(Reauthenticate value) reauthenticate,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(LinkAccount value) linkAccount,
    required TResult Function(UnlinkAccount value) unlinkAccount,
    required TResult Function(UpdateEmail value) updateEmail,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
    required TResult Function(Initialize value) initialize,
    required TResult Function(AuthStateChanged value) authStateChanged,
  }) {
    return refreshPermissions(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Login value)? login,
    TResult? Function(Logout value)? logout,
    TResult? Function(Register value)? register,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(SendEmailVerification value)? sendEmailVerification,
    TResult? Function(RefreshUserData value)? refreshUserData,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(RefreshPermissions value)? refreshPermissions,
    TResult? Function(VerifyEmail value)? verifyEmail,
    TResult? Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult? Function(Reauthenticate value)? reauthenticate,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(LinkAccount value)? linkAccount,
    TResult? Function(UnlinkAccount value)? unlinkAccount,
    TResult? Function(UpdateEmail value)? updateEmail,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
    TResult? Function(Initialize value)? initialize,
    TResult? Function(AuthStateChanged value)? authStateChanged,
  }) {
    return refreshPermissions?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Login value)? login,
    TResult Function(Logout value)? logout,
    TResult Function(Register value)? register,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(SendEmailVerification value)? sendEmailVerification,
    TResult Function(RefreshUserData value)? refreshUserData,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(RefreshPermissions value)? refreshPermissions,
    TResult Function(VerifyEmail value)? verifyEmail,
    TResult Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult Function(Reauthenticate value)? reauthenticate,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(LinkAccount value)? linkAccount,
    TResult Function(UnlinkAccount value)? unlinkAccount,
    TResult Function(UpdateEmail value)? updateEmail,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    TResult Function(Initialize value)? initialize,
    TResult Function(AuthStateChanged value)? authStateChanged,
    required TResult orElse(),
  }) {
    if (refreshPermissions != null) {
      return refreshPermissions(this);
    }
    return orElse();
  }
}

abstract class RefreshPermissions implements AuthEvent {
  const factory RefreshPermissions() = _$RefreshPermissionsImpl;
}

/// @nodoc
abstract class _$$VerifyEmailImplCopyWith<$Res> {
  factory _$$VerifyEmailImplCopyWith(
    _$VerifyEmailImpl value,
    $Res Function(_$VerifyEmailImpl) then,
  ) = __$$VerifyEmailImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String actionCode});
}

/// @nodoc
class __$$VerifyEmailImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$VerifyEmailImpl>
    implements _$$VerifyEmailImplCopyWith<$Res> {
  __$$VerifyEmailImplCopyWithImpl(
    _$VerifyEmailImpl _value,
    $Res Function(_$VerifyEmailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? actionCode = null}) {
    return _then(
      _$VerifyEmailImpl(
        actionCode: null == actionCode
            ? _value.actionCode
            : actionCode // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$VerifyEmailImpl implements VerifyEmail {
  const _$VerifyEmailImpl({required this.actionCode});

  @override
  final String actionCode;

  @override
  String toString() {
    return 'AuthEvent.verifyEmail(actionCode: $actionCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyEmailImpl &&
            (identical(other.actionCode, actionCode) ||
                other.actionCode == actionCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, actionCode);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyEmailImplCopyWith<_$VerifyEmailImpl> get copyWith =>
      __$$VerifyEmailImplCopyWithImpl<_$VerifyEmailImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password, bool rememberMe)
    login,
    required TResult Function() logout,
    required TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )
    register,
    required TResult Function(String email) resetPassword,
    required TResult Function(
      String? fullName,
      String? phoneNumber,
      String? photoUrl,
    )
    updateProfile,
    required TResult Function(String currentPassword, String newPassword)
    changePassword,
    required TResult Function() sendEmailVerification,
    required TResult Function() refreshUserData,
    required TResult Function(String userId, UserPermissions permissions)
    updateUserPermissions,
    required TResult Function() refreshPermissions,
    required TResult Function(String actionCode) verifyEmail,
    required TResult Function(String actionCode, String newPassword)
    confirmPasswordReset,
    required TResult Function(String password) reauthenticate,
    required TResult Function(String password) deleteAccount,
    required TResult Function(String provider) linkAccount,
    required TResult Function(String provider) unlinkAccount,
    required TResult Function(String newEmail, String password) updateEmail,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
    required TResult Function() initialize,
    required TResult Function(bool isAuthenticated, String? userId)
    authStateChanged,
  }) {
    return verifyEmail(actionCode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)? login,
    TResult? Function()? logout,
    TResult? Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult? Function(String email)? resetPassword,
    TResult? Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult? Function(String currentPassword, String newPassword)?
    changePassword,
    TResult? Function()? sendEmailVerification,
    TResult? Function()? refreshUserData,
    TResult? Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult? Function()? refreshPermissions,
    TResult? Function(String actionCode)? verifyEmail,
    TResult? Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult? Function(String password)? reauthenticate,
    TResult? Function(String password)? deleteAccount,
    TResult? Function(String provider)? linkAccount,
    TResult? Function(String provider)? unlinkAccount,
    TResult? Function(String newEmail, String password)? updateEmail,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
    TResult? Function()? initialize,
    TResult? Function(bool isAuthenticated, String? userId)? authStateChanged,
  }) {
    return verifyEmail?.call(actionCode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)? login,
    TResult Function()? logout,
    TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult Function(String email)? resetPassword,
    TResult Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult Function(String currentPassword, String newPassword)?
    changePassword,
    TResult Function()? sendEmailVerification,
    TResult Function()? refreshUserData,
    TResult Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult Function()? refreshPermissions,
    TResult Function(String actionCode)? verifyEmail,
    TResult Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult Function(String password)? reauthenticate,
    TResult Function(String password)? deleteAccount,
    TResult Function(String provider)? linkAccount,
    TResult Function(String provider)? unlinkAccount,
    TResult Function(String newEmail, String password)? updateEmail,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    TResult Function()? initialize,
    TResult Function(bool isAuthenticated, String? userId)? authStateChanged,
    required TResult orElse(),
  }) {
    if (verifyEmail != null) {
      return verifyEmail(actionCode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Login value) login,
    required TResult Function(Logout value) logout,
    required TResult Function(Register value) register,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(SendEmailVerification value)
    sendEmailVerification,
    required TResult Function(RefreshUserData value) refreshUserData,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(RefreshPermissions value) refreshPermissions,
    required TResult Function(VerifyEmail value) verifyEmail,
    required TResult Function(ConfirmPasswordReset value) confirmPasswordReset,
    required TResult Function(Reauthenticate value) reauthenticate,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(LinkAccount value) linkAccount,
    required TResult Function(UnlinkAccount value) unlinkAccount,
    required TResult Function(UpdateEmail value) updateEmail,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
    required TResult Function(Initialize value) initialize,
    required TResult Function(AuthStateChanged value) authStateChanged,
  }) {
    return verifyEmail(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Login value)? login,
    TResult? Function(Logout value)? logout,
    TResult? Function(Register value)? register,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(SendEmailVerification value)? sendEmailVerification,
    TResult? Function(RefreshUserData value)? refreshUserData,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(RefreshPermissions value)? refreshPermissions,
    TResult? Function(VerifyEmail value)? verifyEmail,
    TResult? Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult? Function(Reauthenticate value)? reauthenticate,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(LinkAccount value)? linkAccount,
    TResult? Function(UnlinkAccount value)? unlinkAccount,
    TResult? Function(UpdateEmail value)? updateEmail,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
    TResult? Function(Initialize value)? initialize,
    TResult? Function(AuthStateChanged value)? authStateChanged,
  }) {
    return verifyEmail?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Login value)? login,
    TResult Function(Logout value)? logout,
    TResult Function(Register value)? register,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(SendEmailVerification value)? sendEmailVerification,
    TResult Function(RefreshUserData value)? refreshUserData,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(RefreshPermissions value)? refreshPermissions,
    TResult Function(VerifyEmail value)? verifyEmail,
    TResult Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult Function(Reauthenticate value)? reauthenticate,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(LinkAccount value)? linkAccount,
    TResult Function(UnlinkAccount value)? unlinkAccount,
    TResult Function(UpdateEmail value)? updateEmail,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    TResult Function(Initialize value)? initialize,
    TResult Function(AuthStateChanged value)? authStateChanged,
    required TResult orElse(),
  }) {
    if (verifyEmail != null) {
      return verifyEmail(this);
    }
    return orElse();
  }
}

abstract class VerifyEmail implements AuthEvent {
  const factory VerifyEmail({required final String actionCode}) =
      _$VerifyEmailImpl;

  String get actionCode;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerifyEmailImplCopyWith<_$VerifyEmailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ConfirmPasswordResetImplCopyWith<$Res> {
  factory _$$ConfirmPasswordResetImplCopyWith(
    _$ConfirmPasswordResetImpl value,
    $Res Function(_$ConfirmPasswordResetImpl) then,
  ) = __$$ConfirmPasswordResetImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String actionCode, String newPassword});
}

/// @nodoc
class __$$ConfirmPasswordResetImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$ConfirmPasswordResetImpl>
    implements _$$ConfirmPasswordResetImplCopyWith<$Res> {
  __$$ConfirmPasswordResetImplCopyWithImpl(
    _$ConfirmPasswordResetImpl _value,
    $Res Function(_$ConfirmPasswordResetImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? actionCode = null, Object? newPassword = null}) {
    return _then(
      _$ConfirmPasswordResetImpl(
        actionCode: null == actionCode
            ? _value.actionCode
            : actionCode // ignore: cast_nullable_to_non_nullable
                  as String,
        newPassword: null == newPassword
            ? _value.newPassword
            : newPassword // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ConfirmPasswordResetImpl implements ConfirmPasswordReset {
  const _$ConfirmPasswordResetImpl({
    required this.actionCode,
    required this.newPassword,
  });

  @override
  final String actionCode;
  @override
  final String newPassword;

  @override
  String toString() {
    return 'AuthEvent.confirmPasswordReset(actionCode: $actionCode, newPassword: $newPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfirmPasswordResetImpl &&
            (identical(other.actionCode, actionCode) ||
                other.actionCode == actionCode) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword));
  }

  @override
  int get hashCode => Object.hash(runtimeType, actionCode, newPassword);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfirmPasswordResetImplCopyWith<_$ConfirmPasswordResetImpl>
  get copyWith =>
      __$$ConfirmPasswordResetImplCopyWithImpl<_$ConfirmPasswordResetImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password, bool rememberMe)
    login,
    required TResult Function() logout,
    required TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )
    register,
    required TResult Function(String email) resetPassword,
    required TResult Function(
      String? fullName,
      String? phoneNumber,
      String? photoUrl,
    )
    updateProfile,
    required TResult Function(String currentPassword, String newPassword)
    changePassword,
    required TResult Function() sendEmailVerification,
    required TResult Function() refreshUserData,
    required TResult Function(String userId, UserPermissions permissions)
    updateUserPermissions,
    required TResult Function() refreshPermissions,
    required TResult Function(String actionCode) verifyEmail,
    required TResult Function(String actionCode, String newPassword)
    confirmPasswordReset,
    required TResult Function(String password) reauthenticate,
    required TResult Function(String password) deleteAccount,
    required TResult Function(String provider) linkAccount,
    required TResult Function(String provider) unlinkAccount,
    required TResult Function(String newEmail, String password) updateEmail,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
    required TResult Function() initialize,
    required TResult Function(bool isAuthenticated, String? userId)
    authStateChanged,
  }) {
    return confirmPasswordReset(actionCode, newPassword);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)? login,
    TResult? Function()? logout,
    TResult? Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult? Function(String email)? resetPassword,
    TResult? Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult? Function(String currentPassword, String newPassword)?
    changePassword,
    TResult? Function()? sendEmailVerification,
    TResult? Function()? refreshUserData,
    TResult? Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult? Function()? refreshPermissions,
    TResult? Function(String actionCode)? verifyEmail,
    TResult? Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult? Function(String password)? reauthenticate,
    TResult? Function(String password)? deleteAccount,
    TResult? Function(String provider)? linkAccount,
    TResult? Function(String provider)? unlinkAccount,
    TResult? Function(String newEmail, String password)? updateEmail,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
    TResult? Function()? initialize,
    TResult? Function(bool isAuthenticated, String? userId)? authStateChanged,
  }) {
    return confirmPasswordReset?.call(actionCode, newPassword);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)? login,
    TResult Function()? logout,
    TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult Function(String email)? resetPassword,
    TResult Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult Function(String currentPassword, String newPassword)?
    changePassword,
    TResult Function()? sendEmailVerification,
    TResult Function()? refreshUserData,
    TResult Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult Function()? refreshPermissions,
    TResult Function(String actionCode)? verifyEmail,
    TResult Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult Function(String password)? reauthenticate,
    TResult Function(String password)? deleteAccount,
    TResult Function(String provider)? linkAccount,
    TResult Function(String provider)? unlinkAccount,
    TResult Function(String newEmail, String password)? updateEmail,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    TResult Function()? initialize,
    TResult Function(bool isAuthenticated, String? userId)? authStateChanged,
    required TResult orElse(),
  }) {
    if (confirmPasswordReset != null) {
      return confirmPasswordReset(actionCode, newPassword);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Login value) login,
    required TResult Function(Logout value) logout,
    required TResult Function(Register value) register,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(SendEmailVerification value)
    sendEmailVerification,
    required TResult Function(RefreshUserData value) refreshUserData,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(RefreshPermissions value) refreshPermissions,
    required TResult Function(VerifyEmail value) verifyEmail,
    required TResult Function(ConfirmPasswordReset value) confirmPasswordReset,
    required TResult Function(Reauthenticate value) reauthenticate,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(LinkAccount value) linkAccount,
    required TResult Function(UnlinkAccount value) unlinkAccount,
    required TResult Function(UpdateEmail value) updateEmail,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
    required TResult Function(Initialize value) initialize,
    required TResult Function(AuthStateChanged value) authStateChanged,
  }) {
    return confirmPasswordReset(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Login value)? login,
    TResult? Function(Logout value)? logout,
    TResult? Function(Register value)? register,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(SendEmailVerification value)? sendEmailVerification,
    TResult? Function(RefreshUserData value)? refreshUserData,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(RefreshPermissions value)? refreshPermissions,
    TResult? Function(VerifyEmail value)? verifyEmail,
    TResult? Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult? Function(Reauthenticate value)? reauthenticate,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(LinkAccount value)? linkAccount,
    TResult? Function(UnlinkAccount value)? unlinkAccount,
    TResult? Function(UpdateEmail value)? updateEmail,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
    TResult? Function(Initialize value)? initialize,
    TResult? Function(AuthStateChanged value)? authStateChanged,
  }) {
    return confirmPasswordReset?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Login value)? login,
    TResult Function(Logout value)? logout,
    TResult Function(Register value)? register,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(SendEmailVerification value)? sendEmailVerification,
    TResult Function(RefreshUserData value)? refreshUserData,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(RefreshPermissions value)? refreshPermissions,
    TResult Function(VerifyEmail value)? verifyEmail,
    TResult Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult Function(Reauthenticate value)? reauthenticate,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(LinkAccount value)? linkAccount,
    TResult Function(UnlinkAccount value)? unlinkAccount,
    TResult Function(UpdateEmail value)? updateEmail,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    TResult Function(Initialize value)? initialize,
    TResult Function(AuthStateChanged value)? authStateChanged,
    required TResult orElse(),
  }) {
    if (confirmPasswordReset != null) {
      return confirmPasswordReset(this);
    }
    return orElse();
  }
}

abstract class ConfirmPasswordReset implements AuthEvent {
  const factory ConfirmPasswordReset({
    required final String actionCode,
    required final String newPassword,
  }) = _$ConfirmPasswordResetImpl;

  String get actionCode;
  String get newPassword;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConfirmPasswordResetImplCopyWith<_$ConfirmPasswordResetImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ReauthenticateImplCopyWith<$Res> {
  factory _$$ReauthenticateImplCopyWith(
    _$ReauthenticateImpl value,
    $Res Function(_$ReauthenticateImpl) then,
  ) = __$$ReauthenticateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String password});
}

/// @nodoc
class __$$ReauthenticateImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$ReauthenticateImpl>
    implements _$$ReauthenticateImplCopyWith<$Res> {
  __$$ReauthenticateImplCopyWithImpl(
    _$ReauthenticateImpl _value,
    $Res Function(_$ReauthenticateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? password = null}) {
    return _then(
      _$ReauthenticateImpl(
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ReauthenticateImpl implements Reauthenticate {
  const _$ReauthenticateImpl({required this.password});

  @override
  final String password;

  @override
  String toString() {
    return 'AuthEvent.reauthenticate(password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReauthenticateImpl &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, password);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReauthenticateImplCopyWith<_$ReauthenticateImpl> get copyWith =>
      __$$ReauthenticateImplCopyWithImpl<_$ReauthenticateImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password, bool rememberMe)
    login,
    required TResult Function() logout,
    required TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )
    register,
    required TResult Function(String email) resetPassword,
    required TResult Function(
      String? fullName,
      String? phoneNumber,
      String? photoUrl,
    )
    updateProfile,
    required TResult Function(String currentPassword, String newPassword)
    changePassword,
    required TResult Function() sendEmailVerification,
    required TResult Function() refreshUserData,
    required TResult Function(String userId, UserPermissions permissions)
    updateUserPermissions,
    required TResult Function() refreshPermissions,
    required TResult Function(String actionCode) verifyEmail,
    required TResult Function(String actionCode, String newPassword)
    confirmPasswordReset,
    required TResult Function(String password) reauthenticate,
    required TResult Function(String password) deleteAccount,
    required TResult Function(String provider) linkAccount,
    required TResult Function(String provider) unlinkAccount,
    required TResult Function(String newEmail, String password) updateEmail,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
    required TResult Function() initialize,
    required TResult Function(bool isAuthenticated, String? userId)
    authStateChanged,
  }) {
    return reauthenticate(password);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)? login,
    TResult? Function()? logout,
    TResult? Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult? Function(String email)? resetPassword,
    TResult? Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult? Function(String currentPassword, String newPassword)?
    changePassword,
    TResult? Function()? sendEmailVerification,
    TResult? Function()? refreshUserData,
    TResult? Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult? Function()? refreshPermissions,
    TResult? Function(String actionCode)? verifyEmail,
    TResult? Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult? Function(String password)? reauthenticate,
    TResult? Function(String password)? deleteAccount,
    TResult? Function(String provider)? linkAccount,
    TResult? Function(String provider)? unlinkAccount,
    TResult? Function(String newEmail, String password)? updateEmail,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
    TResult? Function()? initialize,
    TResult? Function(bool isAuthenticated, String? userId)? authStateChanged,
  }) {
    return reauthenticate?.call(password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)? login,
    TResult Function()? logout,
    TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult Function(String email)? resetPassword,
    TResult Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult Function(String currentPassword, String newPassword)?
    changePassword,
    TResult Function()? sendEmailVerification,
    TResult Function()? refreshUserData,
    TResult Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult Function()? refreshPermissions,
    TResult Function(String actionCode)? verifyEmail,
    TResult Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult Function(String password)? reauthenticate,
    TResult Function(String password)? deleteAccount,
    TResult Function(String provider)? linkAccount,
    TResult Function(String provider)? unlinkAccount,
    TResult Function(String newEmail, String password)? updateEmail,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    TResult Function()? initialize,
    TResult Function(bool isAuthenticated, String? userId)? authStateChanged,
    required TResult orElse(),
  }) {
    if (reauthenticate != null) {
      return reauthenticate(password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Login value) login,
    required TResult Function(Logout value) logout,
    required TResult Function(Register value) register,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(SendEmailVerification value)
    sendEmailVerification,
    required TResult Function(RefreshUserData value) refreshUserData,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(RefreshPermissions value) refreshPermissions,
    required TResult Function(VerifyEmail value) verifyEmail,
    required TResult Function(ConfirmPasswordReset value) confirmPasswordReset,
    required TResult Function(Reauthenticate value) reauthenticate,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(LinkAccount value) linkAccount,
    required TResult Function(UnlinkAccount value) unlinkAccount,
    required TResult Function(UpdateEmail value) updateEmail,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
    required TResult Function(Initialize value) initialize,
    required TResult Function(AuthStateChanged value) authStateChanged,
  }) {
    return reauthenticate(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Login value)? login,
    TResult? Function(Logout value)? logout,
    TResult? Function(Register value)? register,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(SendEmailVerification value)? sendEmailVerification,
    TResult? Function(RefreshUserData value)? refreshUserData,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(RefreshPermissions value)? refreshPermissions,
    TResult? Function(VerifyEmail value)? verifyEmail,
    TResult? Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult? Function(Reauthenticate value)? reauthenticate,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(LinkAccount value)? linkAccount,
    TResult? Function(UnlinkAccount value)? unlinkAccount,
    TResult? Function(UpdateEmail value)? updateEmail,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
    TResult? Function(Initialize value)? initialize,
    TResult? Function(AuthStateChanged value)? authStateChanged,
  }) {
    return reauthenticate?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Login value)? login,
    TResult Function(Logout value)? logout,
    TResult Function(Register value)? register,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(SendEmailVerification value)? sendEmailVerification,
    TResult Function(RefreshUserData value)? refreshUserData,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(RefreshPermissions value)? refreshPermissions,
    TResult Function(VerifyEmail value)? verifyEmail,
    TResult Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult Function(Reauthenticate value)? reauthenticate,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(LinkAccount value)? linkAccount,
    TResult Function(UnlinkAccount value)? unlinkAccount,
    TResult Function(UpdateEmail value)? updateEmail,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    TResult Function(Initialize value)? initialize,
    TResult Function(AuthStateChanged value)? authStateChanged,
    required TResult orElse(),
  }) {
    if (reauthenticate != null) {
      return reauthenticate(this);
    }
    return orElse();
  }
}

abstract class Reauthenticate implements AuthEvent {
  const factory Reauthenticate({required final String password}) =
      _$ReauthenticateImpl;

  String get password;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReauthenticateImplCopyWith<_$ReauthenticateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeleteAccountImplCopyWith<$Res> {
  factory _$$DeleteAccountImplCopyWith(
    _$DeleteAccountImpl value,
    $Res Function(_$DeleteAccountImpl) then,
  ) = __$$DeleteAccountImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String password});
}

/// @nodoc
class __$$DeleteAccountImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$DeleteAccountImpl>
    implements _$$DeleteAccountImplCopyWith<$Res> {
  __$$DeleteAccountImplCopyWithImpl(
    _$DeleteAccountImpl _value,
    $Res Function(_$DeleteAccountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? password = null}) {
    return _then(
      _$DeleteAccountImpl(
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$DeleteAccountImpl implements DeleteAccount {
  const _$DeleteAccountImpl({required this.password});

  @override
  final String password;

  @override
  String toString() {
    return 'AuthEvent.deleteAccount(password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteAccountImpl &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, password);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteAccountImplCopyWith<_$DeleteAccountImpl> get copyWith =>
      __$$DeleteAccountImplCopyWithImpl<_$DeleteAccountImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password, bool rememberMe)
    login,
    required TResult Function() logout,
    required TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )
    register,
    required TResult Function(String email) resetPassword,
    required TResult Function(
      String? fullName,
      String? phoneNumber,
      String? photoUrl,
    )
    updateProfile,
    required TResult Function(String currentPassword, String newPassword)
    changePassword,
    required TResult Function() sendEmailVerification,
    required TResult Function() refreshUserData,
    required TResult Function(String userId, UserPermissions permissions)
    updateUserPermissions,
    required TResult Function() refreshPermissions,
    required TResult Function(String actionCode) verifyEmail,
    required TResult Function(String actionCode, String newPassword)
    confirmPasswordReset,
    required TResult Function(String password) reauthenticate,
    required TResult Function(String password) deleteAccount,
    required TResult Function(String provider) linkAccount,
    required TResult Function(String provider) unlinkAccount,
    required TResult Function(String newEmail, String password) updateEmail,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
    required TResult Function() initialize,
    required TResult Function(bool isAuthenticated, String? userId)
    authStateChanged,
  }) {
    return deleteAccount(password);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)? login,
    TResult? Function()? logout,
    TResult? Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult? Function(String email)? resetPassword,
    TResult? Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult? Function(String currentPassword, String newPassword)?
    changePassword,
    TResult? Function()? sendEmailVerification,
    TResult? Function()? refreshUserData,
    TResult? Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult? Function()? refreshPermissions,
    TResult? Function(String actionCode)? verifyEmail,
    TResult? Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult? Function(String password)? reauthenticate,
    TResult? Function(String password)? deleteAccount,
    TResult? Function(String provider)? linkAccount,
    TResult? Function(String provider)? unlinkAccount,
    TResult? Function(String newEmail, String password)? updateEmail,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
    TResult? Function()? initialize,
    TResult? Function(bool isAuthenticated, String? userId)? authStateChanged,
  }) {
    return deleteAccount?.call(password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)? login,
    TResult Function()? logout,
    TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult Function(String email)? resetPassword,
    TResult Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult Function(String currentPassword, String newPassword)?
    changePassword,
    TResult Function()? sendEmailVerification,
    TResult Function()? refreshUserData,
    TResult Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult Function()? refreshPermissions,
    TResult Function(String actionCode)? verifyEmail,
    TResult Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult Function(String password)? reauthenticate,
    TResult Function(String password)? deleteAccount,
    TResult Function(String provider)? linkAccount,
    TResult Function(String provider)? unlinkAccount,
    TResult Function(String newEmail, String password)? updateEmail,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    TResult Function()? initialize,
    TResult Function(bool isAuthenticated, String? userId)? authStateChanged,
    required TResult orElse(),
  }) {
    if (deleteAccount != null) {
      return deleteAccount(password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Login value) login,
    required TResult Function(Logout value) logout,
    required TResult Function(Register value) register,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(SendEmailVerification value)
    sendEmailVerification,
    required TResult Function(RefreshUserData value) refreshUserData,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(RefreshPermissions value) refreshPermissions,
    required TResult Function(VerifyEmail value) verifyEmail,
    required TResult Function(ConfirmPasswordReset value) confirmPasswordReset,
    required TResult Function(Reauthenticate value) reauthenticate,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(LinkAccount value) linkAccount,
    required TResult Function(UnlinkAccount value) unlinkAccount,
    required TResult Function(UpdateEmail value) updateEmail,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
    required TResult Function(Initialize value) initialize,
    required TResult Function(AuthStateChanged value) authStateChanged,
  }) {
    return deleteAccount(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Login value)? login,
    TResult? Function(Logout value)? logout,
    TResult? Function(Register value)? register,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(SendEmailVerification value)? sendEmailVerification,
    TResult? Function(RefreshUserData value)? refreshUserData,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(RefreshPermissions value)? refreshPermissions,
    TResult? Function(VerifyEmail value)? verifyEmail,
    TResult? Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult? Function(Reauthenticate value)? reauthenticate,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(LinkAccount value)? linkAccount,
    TResult? Function(UnlinkAccount value)? unlinkAccount,
    TResult? Function(UpdateEmail value)? updateEmail,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
    TResult? Function(Initialize value)? initialize,
    TResult? Function(AuthStateChanged value)? authStateChanged,
  }) {
    return deleteAccount?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Login value)? login,
    TResult Function(Logout value)? logout,
    TResult Function(Register value)? register,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(SendEmailVerification value)? sendEmailVerification,
    TResult Function(RefreshUserData value)? refreshUserData,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(RefreshPermissions value)? refreshPermissions,
    TResult Function(VerifyEmail value)? verifyEmail,
    TResult Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult Function(Reauthenticate value)? reauthenticate,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(LinkAccount value)? linkAccount,
    TResult Function(UnlinkAccount value)? unlinkAccount,
    TResult Function(UpdateEmail value)? updateEmail,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    TResult Function(Initialize value)? initialize,
    TResult Function(AuthStateChanged value)? authStateChanged,
    required TResult orElse(),
  }) {
    if (deleteAccount != null) {
      return deleteAccount(this);
    }
    return orElse();
  }
}

abstract class DeleteAccount implements AuthEvent {
  const factory DeleteAccount({required final String password}) =
      _$DeleteAccountImpl;

  String get password;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteAccountImplCopyWith<_$DeleteAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LinkAccountImplCopyWith<$Res> {
  factory _$$LinkAccountImplCopyWith(
    _$LinkAccountImpl value,
    $Res Function(_$LinkAccountImpl) then,
  ) = __$$LinkAccountImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String provider});
}

/// @nodoc
class __$$LinkAccountImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$LinkAccountImpl>
    implements _$$LinkAccountImplCopyWith<$Res> {
  __$$LinkAccountImplCopyWithImpl(
    _$LinkAccountImpl _value,
    $Res Function(_$LinkAccountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? provider = null}) {
    return _then(
      _$LinkAccountImpl(
        provider: null == provider
            ? _value.provider
            : provider // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$LinkAccountImpl implements LinkAccount {
  const _$LinkAccountImpl({required this.provider});

  @override
  final String provider;

  @override
  String toString() {
    return 'AuthEvent.linkAccount(provider: $provider)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LinkAccountImpl &&
            (identical(other.provider, provider) ||
                other.provider == provider));
  }

  @override
  int get hashCode => Object.hash(runtimeType, provider);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LinkAccountImplCopyWith<_$LinkAccountImpl> get copyWith =>
      __$$LinkAccountImplCopyWithImpl<_$LinkAccountImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password, bool rememberMe)
    login,
    required TResult Function() logout,
    required TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )
    register,
    required TResult Function(String email) resetPassword,
    required TResult Function(
      String? fullName,
      String? phoneNumber,
      String? photoUrl,
    )
    updateProfile,
    required TResult Function(String currentPassword, String newPassword)
    changePassword,
    required TResult Function() sendEmailVerification,
    required TResult Function() refreshUserData,
    required TResult Function(String userId, UserPermissions permissions)
    updateUserPermissions,
    required TResult Function() refreshPermissions,
    required TResult Function(String actionCode) verifyEmail,
    required TResult Function(String actionCode, String newPassword)
    confirmPasswordReset,
    required TResult Function(String password) reauthenticate,
    required TResult Function(String password) deleteAccount,
    required TResult Function(String provider) linkAccount,
    required TResult Function(String provider) unlinkAccount,
    required TResult Function(String newEmail, String password) updateEmail,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
    required TResult Function() initialize,
    required TResult Function(bool isAuthenticated, String? userId)
    authStateChanged,
  }) {
    return linkAccount(provider);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)? login,
    TResult? Function()? logout,
    TResult? Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult? Function(String email)? resetPassword,
    TResult? Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult? Function(String currentPassword, String newPassword)?
    changePassword,
    TResult? Function()? sendEmailVerification,
    TResult? Function()? refreshUserData,
    TResult? Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult? Function()? refreshPermissions,
    TResult? Function(String actionCode)? verifyEmail,
    TResult? Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult? Function(String password)? reauthenticate,
    TResult? Function(String password)? deleteAccount,
    TResult? Function(String provider)? linkAccount,
    TResult? Function(String provider)? unlinkAccount,
    TResult? Function(String newEmail, String password)? updateEmail,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
    TResult? Function()? initialize,
    TResult? Function(bool isAuthenticated, String? userId)? authStateChanged,
  }) {
    return linkAccount?.call(provider);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)? login,
    TResult Function()? logout,
    TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult Function(String email)? resetPassword,
    TResult Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult Function(String currentPassword, String newPassword)?
    changePassword,
    TResult Function()? sendEmailVerification,
    TResult Function()? refreshUserData,
    TResult Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult Function()? refreshPermissions,
    TResult Function(String actionCode)? verifyEmail,
    TResult Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult Function(String password)? reauthenticate,
    TResult Function(String password)? deleteAccount,
    TResult Function(String provider)? linkAccount,
    TResult Function(String provider)? unlinkAccount,
    TResult Function(String newEmail, String password)? updateEmail,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    TResult Function()? initialize,
    TResult Function(bool isAuthenticated, String? userId)? authStateChanged,
    required TResult orElse(),
  }) {
    if (linkAccount != null) {
      return linkAccount(provider);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Login value) login,
    required TResult Function(Logout value) logout,
    required TResult Function(Register value) register,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(SendEmailVerification value)
    sendEmailVerification,
    required TResult Function(RefreshUserData value) refreshUserData,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(RefreshPermissions value) refreshPermissions,
    required TResult Function(VerifyEmail value) verifyEmail,
    required TResult Function(ConfirmPasswordReset value) confirmPasswordReset,
    required TResult Function(Reauthenticate value) reauthenticate,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(LinkAccount value) linkAccount,
    required TResult Function(UnlinkAccount value) unlinkAccount,
    required TResult Function(UpdateEmail value) updateEmail,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
    required TResult Function(Initialize value) initialize,
    required TResult Function(AuthStateChanged value) authStateChanged,
  }) {
    return linkAccount(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Login value)? login,
    TResult? Function(Logout value)? logout,
    TResult? Function(Register value)? register,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(SendEmailVerification value)? sendEmailVerification,
    TResult? Function(RefreshUserData value)? refreshUserData,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(RefreshPermissions value)? refreshPermissions,
    TResult? Function(VerifyEmail value)? verifyEmail,
    TResult? Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult? Function(Reauthenticate value)? reauthenticate,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(LinkAccount value)? linkAccount,
    TResult? Function(UnlinkAccount value)? unlinkAccount,
    TResult? Function(UpdateEmail value)? updateEmail,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
    TResult? Function(Initialize value)? initialize,
    TResult? Function(AuthStateChanged value)? authStateChanged,
  }) {
    return linkAccount?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Login value)? login,
    TResult Function(Logout value)? logout,
    TResult Function(Register value)? register,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(SendEmailVerification value)? sendEmailVerification,
    TResult Function(RefreshUserData value)? refreshUserData,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(RefreshPermissions value)? refreshPermissions,
    TResult Function(VerifyEmail value)? verifyEmail,
    TResult Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult Function(Reauthenticate value)? reauthenticate,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(LinkAccount value)? linkAccount,
    TResult Function(UnlinkAccount value)? unlinkAccount,
    TResult Function(UpdateEmail value)? updateEmail,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    TResult Function(Initialize value)? initialize,
    TResult Function(AuthStateChanged value)? authStateChanged,
    required TResult orElse(),
  }) {
    if (linkAccount != null) {
      return linkAccount(this);
    }
    return orElse();
  }
}

abstract class LinkAccount implements AuthEvent {
  const factory LinkAccount({required final String provider}) =
      _$LinkAccountImpl;

  String get provider;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LinkAccountImplCopyWith<_$LinkAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnlinkAccountImplCopyWith<$Res> {
  factory _$$UnlinkAccountImplCopyWith(
    _$UnlinkAccountImpl value,
    $Res Function(_$UnlinkAccountImpl) then,
  ) = __$$UnlinkAccountImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String provider});
}

/// @nodoc
class __$$UnlinkAccountImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$UnlinkAccountImpl>
    implements _$$UnlinkAccountImplCopyWith<$Res> {
  __$$UnlinkAccountImplCopyWithImpl(
    _$UnlinkAccountImpl _value,
    $Res Function(_$UnlinkAccountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? provider = null}) {
    return _then(
      _$UnlinkAccountImpl(
        provider: null == provider
            ? _value.provider
            : provider // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UnlinkAccountImpl implements UnlinkAccount {
  const _$UnlinkAccountImpl({required this.provider});

  @override
  final String provider;

  @override
  String toString() {
    return 'AuthEvent.unlinkAccount(provider: $provider)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnlinkAccountImpl &&
            (identical(other.provider, provider) ||
                other.provider == provider));
  }

  @override
  int get hashCode => Object.hash(runtimeType, provider);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnlinkAccountImplCopyWith<_$UnlinkAccountImpl> get copyWith =>
      __$$UnlinkAccountImplCopyWithImpl<_$UnlinkAccountImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password, bool rememberMe)
    login,
    required TResult Function() logout,
    required TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )
    register,
    required TResult Function(String email) resetPassword,
    required TResult Function(
      String? fullName,
      String? phoneNumber,
      String? photoUrl,
    )
    updateProfile,
    required TResult Function(String currentPassword, String newPassword)
    changePassword,
    required TResult Function() sendEmailVerification,
    required TResult Function() refreshUserData,
    required TResult Function(String userId, UserPermissions permissions)
    updateUserPermissions,
    required TResult Function() refreshPermissions,
    required TResult Function(String actionCode) verifyEmail,
    required TResult Function(String actionCode, String newPassword)
    confirmPasswordReset,
    required TResult Function(String password) reauthenticate,
    required TResult Function(String password) deleteAccount,
    required TResult Function(String provider) linkAccount,
    required TResult Function(String provider) unlinkAccount,
    required TResult Function(String newEmail, String password) updateEmail,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
    required TResult Function() initialize,
    required TResult Function(bool isAuthenticated, String? userId)
    authStateChanged,
  }) {
    return unlinkAccount(provider);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)? login,
    TResult? Function()? logout,
    TResult? Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult? Function(String email)? resetPassword,
    TResult? Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult? Function(String currentPassword, String newPassword)?
    changePassword,
    TResult? Function()? sendEmailVerification,
    TResult? Function()? refreshUserData,
    TResult? Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult? Function()? refreshPermissions,
    TResult? Function(String actionCode)? verifyEmail,
    TResult? Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult? Function(String password)? reauthenticate,
    TResult? Function(String password)? deleteAccount,
    TResult? Function(String provider)? linkAccount,
    TResult? Function(String provider)? unlinkAccount,
    TResult? Function(String newEmail, String password)? updateEmail,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
    TResult? Function()? initialize,
    TResult? Function(bool isAuthenticated, String? userId)? authStateChanged,
  }) {
    return unlinkAccount?.call(provider);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)? login,
    TResult Function()? logout,
    TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult Function(String email)? resetPassword,
    TResult Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult Function(String currentPassword, String newPassword)?
    changePassword,
    TResult Function()? sendEmailVerification,
    TResult Function()? refreshUserData,
    TResult Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult Function()? refreshPermissions,
    TResult Function(String actionCode)? verifyEmail,
    TResult Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult Function(String password)? reauthenticate,
    TResult Function(String password)? deleteAccount,
    TResult Function(String provider)? linkAccount,
    TResult Function(String provider)? unlinkAccount,
    TResult Function(String newEmail, String password)? updateEmail,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    TResult Function()? initialize,
    TResult Function(bool isAuthenticated, String? userId)? authStateChanged,
    required TResult orElse(),
  }) {
    if (unlinkAccount != null) {
      return unlinkAccount(provider);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Login value) login,
    required TResult Function(Logout value) logout,
    required TResult Function(Register value) register,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(SendEmailVerification value)
    sendEmailVerification,
    required TResult Function(RefreshUserData value) refreshUserData,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(RefreshPermissions value) refreshPermissions,
    required TResult Function(VerifyEmail value) verifyEmail,
    required TResult Function(ConfirmPasswordReset value) confirmPasswordReset,
    required TResult Function(Reauthenticate value) reauthenticate,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(LinkAccount value) linkAccount,
    required TResult Function(UnlinkAccount value) unlinkAccount,
    required TResult Function(UpdateEmail value) updateEmail,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
    required TResult Function(Initialize value) initialize,
    required TResult Function(AuthStateChanged value) authStateChanged,
  }) {
    return unlinkAccount(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Login value)? login,
    TResult? Function(Logout value)? logout,
    TResult? Function(Register value)? register,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(SendEmailVerification value)? sendEmailVerification,
    TResult? Function(RefreshUserData value)? refreshUserData,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(RefreshPermissions value)? refreshPermissions,
    TResult? Function(VerifyEmail value)? verifyEmail,
    TResult? Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult? Function(Reauthenticate value)? reauthenticate,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(LinkAccount value)? linkAccount,
    TResult? Function(UnlinkAccount value)? unlinkAccount,
    TResult? Function(UpdateEmail value)? updateEmail,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
    TResult? Function(Initialize value)? initialize,
    TResult? Function(AuthStateChanged value)? authStateChanged,
  }) {
    return unlinkAccount?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Login value)? login,
    TResult Function(Logout value)? logout,
    TResult Function(Register value)? register,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(SendEmailVerification value)? sendEmailVerification,
    TResult Function(RefreshUserData value)? refreshUserData,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(RefreshPermissions value)? refreshPermissions,
    TResult Function(VerifyEmail value)? verifyEmail,
    TResult Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult Function(Reauthenticate value)? reauthenticate,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(LinkAccount value)? linkAccount,
    TResult Function(UnlinkAccount value)? unlinkAccount,
    TResult Function(UpdateEmail value)? updateEmail,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    TResult Function(Initialize value)? initialize,
    TResult Function(AuthStateChanged value)? authStateChanged,
    required TResult orElse(),
  }) {
    if (unlinkAccount != null) {
      return unlinkAccount(this);
    }
    return orElse();
  }
}

abstract class UnlinkAccount implements AuthEvent {
  const factory UnlinkAccount({required final String provider}) =
      _$UnlinkAccountImpl;

  String get provider;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnlinkAccountImplCopyWith<_$UnlinkAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateEmailImplCopyWith<$Res> {
  factory _$$UpdateEmailImplCopyWith(
    _$UpdateEmailImpl value,
    $Res Function(_$UpdateEmailImpl) then,
  ) = __$$UpdateEmailImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String newEmail, String password});
}

/// @nodoc
class __$$UpdateEmailImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$UpdateEmailImpl>
    implements _$$UpdateEmailImplCopyWith<$Res> {
  __$$UpdateEmailImplCopyWithImpl(
    _$UpdateEmailImpl _value,
    $Res Function(_$UpdateEmailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? newEmail = null, Object? password = null}) {
    return _then(
      _$UpdateEmailImpl(
        newEmail: null == newEmail
            ? _value.newEmail
            : newEmail // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UpdateEmailImpl implements UpdateEmail {
  const _$UpdateEmailImpl({required this.newEmail, required this.password});

  @override
  final String newEmail;
  @override
  final String password;

  @override
  String toString() {
    return 'AuthEvent.updateEmail(newEmail: $newEmail, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateEmailImpl &&
            (identical(other.newEmail, newEmail) ||
                other.newEmail == newEmail) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, newEmail, password);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateEmailImplCopyWith<_$UpdateEmailImpl> get copyWith =>
      __$$UpdateEmailImplCopyWithImpl<_$UpdateEmailImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password, bool rememberMe)
    login,
    required TResult Function() logout,
    required TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )
    register,
    required TResult Function(String email) resetPassword,
    required TResult Function(
      String? fullName,
      String? phoneNumber,
      String? photoUrl,
    )
    updateProfile,
    required TResult Function(String currentPassword, String newPassword)
    changePassword,
    required TResult Function() sendEmailVerification,
    required TResult Function() refreshUserData,
    required TResult Function(String userId, UserPermissions permissions)
    updateUserPermissions,
    required TResult Function() refreshPermissions,
    required TResult Function(String actionCode) verifyEmail,
    required TResult Function(String actionCode, String newPassword)
    confirmPasswordReset,
    required TResult Function(String password) reauthenticate,
    required TResult Function(String password) deleteAccount,
    required TResult Function(String provider) linkAccount,
    required TResult Function(String provider) unlinkAccount,
    required TResult Function(String newEmail, String password) updateEmail,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
    required TResult Function() initialize,
    required TResult Function(bool isAuthenticated, String? userId)
    authStateChanged,
  }) {
    return updateEmail(newEmail, password);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)? login,
    TResult? Function()? logout,
    TResult? Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult? Function(String email)? resetPassword,
    TResult? Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult? Function(String currentPassword, String newPassword)?
    changePassword,
    TResult? Function()? sendEmailVerification,
    TResult? Function()? refreshUserData,
    TResult? Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult? Function()? refreshPermissions,
    TResult? Function(String actionCode)? verifyEmail,
    TResult? Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult? Function(String password)? reauthenticate,
    TResult? Function(String password)? deleteAccount,
    TResult? Function(String provider)? linkAccount,
    TResult? Function(String provider)? unlinkAccount,
    TResult? Function(String newEmail, String password)? updateEmail,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
    TResult? Function()? initialize,
    TResult? Function(bool isAuthenticated, String? userId)? authStateChanged,
  }) {
    return updateEmail?.call(newEmail, password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)? login,
    TResult Function()? logout,
    TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult Function(String email)? resetPassword,
    TResult Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult Function(String currentPassword, String newPassword)?
    changePassword,
    TResult Function()? sendEmailVerification,
    TResult Function()? refreshUserData,
    TResult Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult Function()? refreshPermissions,
    TResult Function(String actionCode)? verifyEmail,
    TResult Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult Function(String password)? reauthenticate,
    TResult Function(String password)? deleteAccount,
    TResult Function(String provider)? linkAccount,
    TResult Function(String provider)? unlinkAccount,
    TResult Function(String newEmail, String password)? updateEmail,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    TResult Function()? initialize,
    TResult Function(bool isAuthenticated, String? userId)? authStateChanged,
    required TResult orElse(),
  }) {
    if (updateEmail != null) {
      return updateEmail(newEmail, password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Login value) login,
    required TResult Function(Logout value) logout,
    required TResult Function(Register value) register,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(SendEmailVerification value)
    sendEmailVerification,
    required TResult Function(RefreshUserData value) refreshUserData,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(RefreshPermissions value) refreshPermissions,
    required TResult Function(VerifyEmail value) verifyEmail,
    required TResult Function(ConfirmPasswordReset value) confirmPasswordReset,
    required TResult Function(Reauthenticate value) reauthenticate,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(LinkAccount value) linkAccount,
    required TResult Function(UnlinkAccount value) unlinkAccount,
    required TResult Function(UpdateEmail value) updateEmail,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
    required TResult Function(Initialize value) initialize,
    required TResult Function(AuthStateChanged value) authStateChanged,
  }) {
    return updateEmail(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Login value)? login,
    TResult? Function(Logout value)? logout,
    TResult? Function(Register value)? register,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(SendEmailVerification value)? sendEmailVerification,
    TResult? Function(RefreshUserData value)? refreshUserData,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(RefreshPermissions value)? refreshPermissions,
    TResult? Function(VerifyEmail value)? verifyEmail,
    TResult? Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult? Function(Reauthenticate value)? reauthenticate,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(LinkAccount value)? linkAccount,
    TResult? Function(UnlinkAccount value)? unlinkAccount,
    TResult? Function(UpdateEmail value)? updateEmail,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
    TResult? Function(Initialize value)? initialize,
    TResult? Function(AuthStateChanged value)? authStateChanged,
  }) {
    return updateEmail?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Login value)? login,
    TResult Function(Logout value)? logout,
    TResult Function(Register value)? register,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(SendEmailVerification value)? sendEmailVerification,
    TResult Function(RefreshUserData value)? refreshUserData,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(RefreshPermissions value)? refreshPermissions,
    TResult Function(VerifyEmail value)? verifyEmail,
    TResult Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult Function(Reauthenticate value)? reauthenticate,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(LinkAccount value)? linkAccount,
    TResult Function(UnlinkAccount value)? unlinkAccount,
    TResult Function(UpdateEmail value)? updateEmail,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    TResult Function(Initialize value)? initialize,
    TResult Function(AuthStateChanged value)? authStateChanged,
    required TResult orElse(),
  }) {
    if (updateEmail != null) {
      return updateEmail(this);
    }
    return orElse();
  }
}

abstract class UpdateEmail implements AuthEvent {
  const factory UpdateEmail({
    required final String newEmail,
    required final String password,
  }) = _$UpdateEmailImpl;

  String get newEmail;
  String get password;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateEmailImplCopyWith<_$UpdateEmailImpl> get copyWith =>
      throw _privateConstructorUsedError;
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
    extends _$AuthEventCopyWithImpl<$Res, _$ClearErrorImpl>
    implements _$$ClearErrorImplCopyWith<$Res> {
  __$$ClearErrorImplCopyWithImpl(
    _$ClearErrorImpl _value,
    $Res Function(_$ClearErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ClearErrorImpl implements ClearError {
  const _$ClearErrorImpl();

  @override
  String toString() {
    return 'AuthEvent.clearError()';
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
    required TResult Function(String email, String password, bool rememberMe)
    login,
    required TResult Function() logout,
    required TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )
    register,
    required TResult Function(String email) resetPassword,
    required TResult Function(
      String? fullName,
      String? phoneNumber,
      String? photoUrl,
    )
    updateProfile,
    required TResult Function(String currentPassword, String newPassword)
    changePassword,
    required TResult Function() sendEmailVerification,
    required TResult Function() refreshUserData,
    required TResult Function(String userId, UserPermissions permissions)
    updateUserPermissions,
    required TResult Function() refreshPermissions,
    required TResult Function(String actionCode) verifyEmail,
    required TResult Function(String actionCode, String newPassword)
    confirmPasswordReset,
    required TResult Function(String password) reauthenticate,
    required TResult Function(String password) deleteAccount,
    required TResult Function(String provider) linkAccount,
    required TResult Function(String provider) unlinkAccount,
    required TResult Function(String newEmail, String password) updateEmail,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
    required TResult Function() initialize,
    required TResult Function(bool isAuthenticated, String? userId)
    authStateChanged,
  }) {
    return clearError();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)? login,
    TResult? Function()? logout,
    TResult? Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult? Function(String email)? resetPassword,
    TResult? Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult? Function(String currentPassword, String newPassword)?
    changePassword,
    TResult? Function()? sendEmailVerification,
    TResult? Function()? refreshUserData,
    TResult? Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult? Function()? refreshPermissions,
    TResult? Function(String actionCode)? verifyEmail,
    TResult? Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult? Function(String password)? reauthenticate,
    TResult? Function(String password)? deleteAccount,
    TResult? Function(String provider)? linkAccount,
    TResult? Function(String provider)? unlinkAccount,
    TResult? Function(String newEmail, String password)? updateEmail,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
    TResult? Function()? initialize,
    TResult? Function(bool isAuthenticated, String? userId)? authStateChanged,
  }) {
    return clearError?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)? login,
    TResult Function()? logout,
    TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult Function(String email)? resetPassword,
    TResult Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult Function(String currentPassword, String newPassword)?
    changePassword,
    TResult Function()? sendEmailVerification,
    TResult Function()? refreshUserData,
    TResult Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult Function()? refreshPermissions,
    TResult Function(String actionCode)? verifyEmail,
    TResult Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult Function(String password)? reauthenticate,
    TResult Function(String password)? deleteAccount,
    TResult Function(String provider)? linkAccount,
    TResult Function(String provider)? unlinkAccount,
    TResult Function(String newEmail, String password)? updateEmail,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    TResult Function()? initialize,
    TResult Function(bool isAuthenticated, String? userId)? authStateChanged,
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
    required TResult Function(Login value) login,
    required TResult Function(Logout value) logout,
    required TResult Function(Register value) register,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(SendEmailVerification value)
    sendEmailVerification,
    required TResult Function(RefreshUserData value) refreshUserData,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(RefreshPermissions value) refreshPermissions,
    required TResult Function(VerifyEmail value) verifyEmail,
    required TResult Function(ConfirmPasswordReset value) confirmPasswordReset,
    required TResult Function(Reauthenticate value) reauthenticate,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(LinkAccount value) linkAccount,
    required TResult Function(UnlinkAccount value) unlinkAccount,
    required TResult Function(UpdateEmail value) updateEmail,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
    required TResult Function(Initialize value) initialize,
    required TResult Function(AuthStateChanged value) authStateChanged,
  }) {
    return clearError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Login value)? login,
    TResult? Function(Logout value)? logout,
    TResult? Function(Register value)? register,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(SendEmailVerification value)? sendEmailVerification,
    TResult? Function(RefreshUserData value)? refreshUserData,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(RefreshPermissions value)? refreshPermissions,
    TResult? Function(VerifyEmail value)? verifyEmail,
    TResult? Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult? Function(Reauthenticate value)? reauthenticate,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(LinkAccount value)? linkAccount,
    TResult? Function(UnlinkAccount value)? unlinkAccount,
    TResult? Function(UpdateEmail value)? updateEmail,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
    TResult? Function(Initialize value)? initialize,
    TResult? Function(AuthStateChanged value)? authStateChanged,
  }) {
    return clearError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Login value)? login,
    TResult Function(Logout value)? logout,
    TResult Function(Register value)? register,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(SendEmailVerification value)? sendEmailVerification,
    TResult Function(RefreshUserData value)? refreshUserData,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(RefreshPermissions value)? refreshPermissions,
    TResult Function(VerifyEmail value)? verifyEmail,
    TResult Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult Function(Reauthenticate value)? reauthenticate,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(LinkAccount value)? linkAccount,
    TResult Function(UnlinkAccount value)? unlinkAccount,
    TResult Function(UpdateEmail value)? updateEmail,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    TResult Function(Initialize value)? initialize,
    TResult Function(AuthStateChanged value)? authStateChanged,
    required TResult orElse(),
  }) {
    if (clearError != null) {
      return clearError(this);
    }
    return orElse();
  }
}

abstract class ClearError implements AuthEvent {
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
    extends _$AuthEventCopyWithImpl<$Res, _$RetryLastOperationImpl>
    implements _$$RetryLastOperationImplCopyWith<$Res> {
  __$$RetryLastOperationImplCopyWithImpl(
    _$RetryLastOperationImpl _value,
    $Res Function(_$RetryLastOperationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RetryLastOperationImpl implements RetryLastOperation {
  const _$RetryLastOperationImpl();

  @override
  String toString() {
    return 'AuthEvent.retryLastOperation()';
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
    required TResult Function(String email, String password, bool rememberMe)
    login,
    required TResult Function() logout,
    required TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )
    register,
    required TResult Function(String email) resetPassword,
    required TResult Function(
      String? fullName,
      String? phoneNumber,
      String? photoUrl,
    )
    updateProfile,
    required TResult Function(String currentPassword, String newPassword)
    changePassword,
    required TResult Function() sendEmailVerification,
    required TResult Function() refreshUserData,
    required TResult Function(String userId, UserPermissions permissions)
    updateUserPermissions,
    required TResult Function() refreshPermissions,
    required TResult Function(String actionCode) verifyEmail,
    required TResult Function(String actionCode, String newPassword)
    confirmPasswordReset,
    required TResult Function(String password) reauthenticate,
    required TResult Function(String password) deleteAccount,
    required TResult Function(String provider) linkAccount,
    required TResult Function(String provider) unlinkAccount,
    required TResult Function(String newEmail, String password) updateEmail,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
    required TResult Function() initialize,
    required TResult Function(bool isAuthenticated, String? userId)
    authStateChanged,
  }) {
    return retryLastOperation();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)? login,
    TResult? Function()? logout,
    TResult? Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult? Function(String email)? resetPassword,
    TResult? Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult? Function(String currentPassword, String newPassword)?
    changePassword,
    TResult? Function()? sendEmailVerification,
    TResult? Function()? refreshUserData,
    TResult? Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult? Function()? refreshPermissions,
    TResult? Function(String actionCode)? verifyEmail,
    TResult? Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult? Function(String password)? reauthenticate,
    TResult? Function(String password)? deleteAccount,
    TResult? Function(String provider)? linkAccount,
    TResult? Function(String provider)? unlinkAccount,
    TResult? Function(String newEmail, String password)? updateEmail,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
    TResult? Function()? initialize,
    TResult? Function(bool isAuthenticated, String? userId)? authStateChanged,
  }) {
    return retryLastOperation?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)? login,
    TResult Function()? logout,
    TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult Function(String email)? resetPassword,
    TResult Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult Function(String currentPassword, String newPassword)?
    changePassword,
    TResult Function()? sendEmailVerification,
    TResult Function()? refreshUserData,
    TResult Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult Function()? refreshPermissions,
    TResult Function(String actionCode)? verifyEmail,
    TResult Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult Function(String password)? reauthenticate,
    TResult Function(String password)? deleteAccount,
    TResult Function(String provider)? linkAccount,
    TResult Function(String provider)? unlinkAccount,
    TResult Function(String newEmail, String password)? updateEmail,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    TResult Function()? initialize,
    TResult Function(bool isAuthenticated, String? userId)? authStateChanged,
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
    required TResult Function(Login value) login,
    required TResult Function(Logout value) logout,
    required TResult Function(Register value) register,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(SendEmailVerification value)
    sendEmailVerification,
    required TResult Function(RefreshUserData value) refreshUserData,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(RefreshPermissions value) refreshPermissions,
    required TResult Function(VerifyEmail value) verifyEmail,
    required TResult Function(ConfirmPasswordReset value) confirmPasswordReset,
    required TResult Function(Reauthenticate value) reauthenticate,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(LinkAccount value) linkAccount,
    required TResult Function(UnlinkAccount value) unlinkAccount,
    required TResult Function(UpdateEmail value) updateEmail,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
    required TResult Function(Initialize value) initialize,
    required TResult Function(AuthStateChanged value) authStateChanged,
  }) {
    return retryLastOperation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Login value)? login,
    TResult? Function(Logout value)? logout,
    TResult? Function(Register value)? register,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(SendEmailVerification value)? sendEmailVerification,
    TResult? Function(RefreshUserData value)? refreshUserData,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(RefreshPermissions value)? refreshPermissions,
    TResult? Function(VerifyEmail value)? verifyEmail,
    TResult? Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult? Function(Reauthenticate value)? reauthenticate,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(LinkAccount value)? linkAccount,
    TResult? Function(UnlinkAccount value)? unlinkAccount,
    TResult? Function(UpdateEmail value)? updateEmail,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
    TResult? Function(Initialize value)? initialize,
    TResult? Function(AuthStateChanged value)? authStateChanged,
  }) {
    return retryLastOperation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Login value)? login,
    TResult Function(Logout value)? logout,
    TResult Function(Register value)? register,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(SendEmailVerification value)? sendEmailVerification,
    TResult Function(RefreshUserData value)? refreshUserData,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(RefreshPermissions value)? refreshPermissions,
    TResult Function(VerifyEmail value)? verifyEmail,
    TResult Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult Function(Reauthenticate value)? reauthenticate,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(LinkAccount value)? linkAccount,
    TResult Function(UnlinkAccount value)? unlinkAccount,
    TResult Function(UpdateEmail value)? updateEmail,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    TResult Function(Initialize value)? initialize,
    TResult Function(AuthStateChanged value)? authStateChanged,
    required TResult orElse(),
  }) {
    if (retryLastOperation != null) {
      return retryLastOperation(this);
    }
    return orElse();
  }
}

abstract class RetryLastOperation implements AuthEvent {
  const factory RetryLastOperation() = _$RetryLastOperationImpl;
}

/// @nodoc
abstract class _$$InitializeImplCopyWith<$Res> {
  factory _$$InitializeImplCopyWith(
    _$InitializeImpl value,
    $Res Function(_$InitializeImpl) then,
  ) = __$$InitializeImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitializeImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$InitializeImpl>
    implements _$$InitializeImplCopyWith<$Res> {
  __$$InitializeImplCopyWithImpl(
    _$InitializeImpl _value,
    $Res Function(_$InitializeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitializeImpl implements Initialize {
  const _$InitializeImpl();

  @override
  String toString() {
    return 'AuthEvent.initialize()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitializeImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password, bool rememberMe)
    login,
    required TResult Function() logout,
    required TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )
    register,
    required TResult Function(String email) resetPassword,
    required TResult Function(
      String? fullName,
      String? phoneNumber,
      String? photoUrl,
    )
    updateProfile,
    required TResult Function(String currentPassword, String newPassword)
    changePassword,
    required TResult Function() sendEmailVerification,
    required TResult Function() refreshUserData,
    required TResult Function(String userId, UserPermissions permissions)
    updateUserPermissions,
    required TResult Function() refreshPermissions,
    required TResult Function(String actionCode) verifyEmail,
    required TResult Function(String actionCode, String newPassword)
    confirmPasswordReset,
    required TResult Function(String password) reauthenticate,
    required TResult Function(String password) deleteAccount,
    required TResult Function(String provider) linkAccount,
    required TResult Function(String provider) unlinkAccount,
    required TResult Function(String newEmail, String password) updateEmail,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
    required TResult Function() initialize,
    required TResult Function(bool isAuthenticated, String? userId)
    authStateChanged,
  }) {
    return initialize();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)? login,
    TResult? Function()? logout,
    TResult? Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult? Function(String email)? resetPassword,
    TResult? Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult? Function(String currentPassword, String newPassword)?
    changePassword,
    TResult? Function()? sendEmailVerification,
    TResult? Function()? refreshUserData,
    TResult? Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult? Function()? refreshPermissions,
    TResult? Function(String actionCode)? verifyEmail,
    TResult? Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult? Function(String password)? reauthenticate,
    TResult? Function(String password)? deleteAccount,
    TResult? Function(String provider)? linkAccount,
    TResult? Function(String provider)? unlinkAccount,
    TResult? Function(String newEmail, String password)? updateEmail,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
    TResult? Function()? initialize,
    TResult? Function(bool isAuthenticated, String? userId)? authStateChanged,
  }) {
    return initialize?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)? login,
    TResult Function()? logout,
    TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult Function(String email)? resetPassword,
    TResult Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult Function(String currentPassword, String newPassword)?
    changePassword,
    TResult Function()? sendEmailVerification,
    TResult Function()? refreshUserData,
    TResult Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult Function()? refreshPermissions,
    TResult Function(String actionCode)? verifyEmail,
    TResult Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult Function(String password)? reauthenticate,
    TResult Function(String password)? deleteAccount,
    TResult Function(String provider)? linkAccount,
    TResult Function(String provider)? unlinkAccount,
    TResult Function(String newEmail, String password)? updateEmail,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    TResult Function()? initialize,
    TResult Function(bool isAuthenticated, String? userId)? authStateChanged,
    required TResult orElse(),
  }) {
    if (initialize != null) {
      return initialize();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Login value) login,
    required TResult Function(Logout value) logout,
    required TResult Function(Register value) register,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(SendEmailVerification value)
    sendEmailVerification,
    required TResult Function(RefreshUserData value) refreshUserData,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(RefreshPermissions value) refreshPermissions,
    required TResult Function(VerifyEmail value) verifyEmail,
    required TResult Function(ConfirmPasswordReset value) confirmPasswordReset,
    required TResult Function(Reauthenticate value) reauthenticate,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(LinkAccount value) linkAccount,
    required TResult Function(UnlinkAccount value) unlinkAccount,
    required TResult Function(UpdateEmail value) updateEmail,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
    required TResult Function(Initialize value) initialize,
    required TResult Function(AuthStateChanged value) authStateChanged,
  }) {
    return initialize(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Login value)? login,
    TResult? Function(Logout value)? logout,
    TResult? Function(Register value)? register,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(SendEmailVerification value)? sendEmailVerification,
    TResult? Function(RefreshUserData value)? refreshUserData,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(RefreshPermissions value)? refreshPermissions,
    TResult? Function(VerifyEmail value)? verifyEmail,
    TResult? Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult? Function(Reauthenticate value)? reauthenticate,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(LinkAccount value)? linkAccount,
    TResult? Function(UnlinkAccount value)? unlinkAccount,
    TResult? Function(UpdateEmail value)? updateEmail,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
    TResult? Function(Initialize value)? initialize,
    TResult? Function(AuthStateChanged value)? authStateChanged,
  }) {
    return initialize?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Login value)? login,
    TResult Function(Logout value)? logout,
    TResult Function(Register value)? register,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(SendEmailVerification value)? sendEmailVerification,
    TResult Function(RefreshUserData value)? refreshUserData,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(RefreshPermissions value)? refreshPermissions,
    TResult Function(VerifyEmail value)? verifyEmail,
    TResult Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult Function(Reauthenticate value)? reauthenticate,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(LinkAccount value)? linkAccount,
    TResult Function(UnlinkAccount value)? unlinkAccount,
    TResult Function(UpdateEmail value)? updateEmail,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    TResult Function(Initialize value)? initialize,
    TResult Function(AuthStateChanged value)? authStateChanged,
    required TResult orElse(),
  }) {
    if (initialize != null) {
      return initialize(this);
    }
    return orElse();
  }
}

abstract class Initialize implements AuthEvent {
  const factory Initialize() = _$InitializeImpl;
}

/// @nodoc
abstract class _$$AuthStateChangedImplCopyWith<$Res> {
  factory _$$AuthStateChangedImplCopyWith(
    _$AuthStateChangedImpl value,
    $Res Function(_$AuthStateChangedImpl) then,
  ) = __$$AuthStateChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool isAuthenticated, String? userId});
}

/// @nodoc
class __$$AuthStateChangedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthStateChangedImpl>
    implements _$$AuthStateChangedImplCopyWith<$Res> {
  __$$AuthStateChangedImplCopyWithImpl(
    _$AuthStateChangedImpl _value,
    $Res Function(_$AuthStateChangedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isAuthenticated = null, Object? userId = freezed}) {
    return _then(
      _$AuthStateChangedImpl(
        isAuthenticated: null == isAuthenticated
            ? _value.isAuthenticated
            : isAuthenticated // ignore: cast_nullable_to_non_nullable
                  as bool,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$AuthStateChangedImpl implements AuthStateChanged {
  const _$AuthStateChangedImpl({required this.isAuthenticated, this.userId});

  @override
  final bool isAuthenticated;
  @override
  final String? userId;

  @override
  String toString() {
    return 'AuthEvent.authStateChanged(isAuthenticated: $isAuthenticated, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthStateChangedImpl &&
            (identical(other.isAuthenticated, isAuthenticated) ||
                other.isAuthenticated == isAuthenticated) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isAuthenticated, userId);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthStateChangedImplCopyWith<_$AuthStateChangedImpl> get copyWith =>
      __$$AuthStateChangedImplCopyWithImpl<_$AuthStateChangedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password, bool rememberMe)
    login,
    required TResult Function() logout,
    required TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )
    register,
    required TResult Function(String email) resetPassword,
    required TResult Function(
      String? fullName,
      String? phoneNumber,
      String? photoUrl,
    )
    updateProfile,
    required TResult Function(String currentPassword, String newPassword)
    changePassword,
    required TResult Function() sendEmailVerification,
    required TResult Function() refreshUserData,
    required TResult Function(String userId, UserPermissions permissions)
    updateUserPermissions,
    required TResult Function() refreshPermissions,
    required TResult Function(String actionCode) verifyEmail,
    required TResult Function(String actionCode, String newPassword)
    confirmPasswordReset,
    required TResult Function(String password) reauthenticate,
    required TResult Function(String password) deleteAccount,
    required TResult Function(String provider) linkAccount,
    required TResult Function(String provider) unlinkAccount,
    required TResult Function(String newEmail, String password) updateEmail,
    required TResult Function() clearError,
    required TResult Function() retryLastOperation,
    required TResult Function() initialize,
    required TResult Function(bool isAuthenticated, String? userId)
    authStateChanged,
  }) {
    return authStateChanged(isAuthenticated, userId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password, bool rememberMe)? login,
    TResult? Function()? logout,
    TResult? Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult? Function(String email)? resetPassword,
    TResult? Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult? Function(String currentPassword, String newPassword)?
    changePassword,
    TResult? Function()? sendEmailVerification,
    TResult? Function()? refreshUserData,
    TResult? Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult? Function()? refreshPermissions,
    TResult? Function(String actionCode)? verifyEmail,
    TResult? Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult? Function(String password)? reauthenticate,
    TResult? Function(String password)? deleteAccount,
    TResult? Function(String provider)? linkAccount,
    TResult? Function(String provider)? unlinkAccount,
    TResult? Function(String newEmail, String password)? updateEmail,
    TResult? Function()? clearError,
    TResult? Function()? retryLastOperation,
    TResult? Function()? initialize,
    TResult? Function(bool isAuthenticated, String? userId)? authStateChanged,
  }) {
    return authStateChanged?.call(isAuthenticated, userId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password, bool rememberMe)? login,
    TResult Function()? logout,
    TResult Function(
      String email,
      String password,
      String fullName,
      String? phoneNumber,
    )?
    register,
    TResult Function(String email)? resetPassword,
    TResult Function(String? fullName, String? phoneNumber, String? photoUrl)?
    updateProfile,
    TResult Function(String currentPassword, String newPassword)?
    changePassword,
    TResult Function()? sendEmailVerification,
    TResult Function()? refreshUserData,
    TResult Function(String userId, UserPermissions permissions)?
    updateUserPermissions,
    TResult Function()? refreshPermissions,
    TResult Function(String actionCode)? verifyEmail,
    TResult Function(String actionCode, String newPassword)?
    confirmPasswordReset,
    TResult Function(String password)? reauthenticate,
    TResult Function(String password)? deleteAccount,
    TResult Function(String provider)? linkAccount,
    TResult Function(String provider)? unlinkAccount,
    TResult Function(String newEmail, String password)? updateEmail,
    TResult Function()? clearError,
    TResult Function()? retryLastOperation,
    TResult Function()? initialize,
    TResult Function(bool isAuthenticated, String? userId)? authStateChanged,
    required TResult orElse(),
  }) {
    if (authStateChanged != null) {
      return authStateChanged(isAuthenticated, userId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Login value) login,
    required TResult Function(Logout value) logout,
    required TResult Function(Register value) register,
    required TResult Function(ResetPassword value) resetPassword,
    required TResult Function(UpdateProfile value) updateProfile,
    required TResult Function(ChangePassword value) changePassword,
    required TResult Function(SendEmailVerification value)
    sendEmailVerification,
    required TResult Function(RefreshUserData value) refreshUserData,
    required TResult Function(UpdateUserPermissions value)
    updateUserPermissions,
    required TResult Function(RefreshPermissions value) refreshPermissions,
    required TResult Function(VerifyEmail value) verifyEmail,
    required TResult Function(ConfirmPasswordReset value) confirmPasswordReset,
    required TResult Function(Reauthenticate value) reauthenticate,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(LinkAccount value) linkAccount,
    required TResult Function(UnlinkAccount value) unlinkAccount,
    required TResult Function(UpdateEmail value) updateEmail,
    required TResult Function(ClearError value) clearError,
    required TResult Function(RetryLastOperation value) retryLastOperation,
    required TResult Function(Initialize value) initialize,
    required TResult Function(AuthStateChanged value) authStateChanged,
  }) {
    return authStateChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Login value)? login,
    TResult? Function(Logout value)? logout,
    TResult? Function(Register value)? register,
    TResult? Function(ResetPassword value)? resetPassword,
    TResult? Function(UpdateProfile value)? updateProfile,
    TResult? Function(ChangePassword value)? changePassword,
    TResult? Function(SendEmailVerification value)? sendEmailVerification,
    TResult? Function(RefreshUserData value)? refreshUserData,
    TResult? Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult? Function(RefreshPermissions value)? refreshPermissions,
    TResult? Function(VerifyEmail value)? verifyEmail,
    TResult? Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult? Function(Reauthenticate value)? reauthenticate,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(LinkAccount value)? linkAccount,
    TResult? Function(UnlinkAccount value)? unlinkAccount,
    TResult? Function(UpdateEmail value)? updateEmail,
    TResult? Function(ClearError value)? clearError,
    TResult? Function(RetryLastOperation value)? retryLastOperation,
    TResult? Function(Initialize value)? initialize,
    TResult? Function(AuthStateChanged value)? authStateChanged,
  }) {
    return authStateChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Login value)? login,
    TResult Function(Logout value)? logout,
    TResult Function(Register value)? register,
    TResult Function(ResetPassword value)? resetPassword,
    TResult Function(UpdateProfile value)? updateProfile,
    TResult Function(ChangePassword value)? changePassword,
    TResult Function(SendEmailVerification value)? sendEmailVerification,
    TResult Function(RefreshUserData value)? refreshUserData,
    TResult Function(UpdateUserPermissions value)? updateUserPermissions,
    TResult Function(RefreshPermissions value)? refreshPermissions,
    TResult Function(VerifyEmail value)? verifyEmail,
    TResult Function(ConfirmPasswordReset value)? confirmPasswordReset,
    TResult Function(Reauthenticate value)? reauthenticate,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(LinkAccount value)? linkAccount,
    TResult Function(UnlinkAccount value)? unlinkAccount,
    TResult Function(UpdateEmail value)? updateEmail,
    TResult Function(ClearError value)? clearError,
    TResult Function(RetryLastOperation value)? retryLastOperation,
    TResult Function(Initialize value)? initialize,
    TResult Function(AuthStateChanged value)? authStateChanged,
    required TResult orElse(),
  }) {
    if (authStateChanged != null) {
      return authStateChanged(this);
    }
    return orElse();
  }
}

abstract class AuthStateChanged implements AuthEvent {
  const factory AuthStateChanged({
    required final bool isAuthenticated,
    final String? userId,
  }) = _$AuthStateChangedImpl;

  bool get isAuthenticated;
  String? get userId;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthStateChangedImplCopyWith<_$AuthStateChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
