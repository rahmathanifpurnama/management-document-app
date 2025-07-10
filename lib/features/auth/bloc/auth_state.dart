import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../models/user_model.dart';

part 'auth_state.freezed.dart';

/// States for Auth BLoC
/// Represents all possible states during authentication operations
@freezed
class AuthState with _$AuthState {
  /// Initial state when BLoC is first created
  const factory AuthState.initial() = AuthInitial;

  /// Loading state for authentication operations
  const factory AuthState.loading({String? operationType}) = AuthLoading;

  /// Authenticated state with user data
  const factory AuthState.authenticated({
    required UserModel user,
    @Default(false) bool isEmailVerified,
    Map<String, dynamic>? permissions,
  }) = AuthAuthenticated;

  /// Unauthenticated state
  const factory AuthState.unauthenticated() = AuthUnauthenticated;

  /// Error state with error message and retry capability
  const factory AuthState.error({
    required String message,
    @Default(false) bool canRetry,
    String? lastFailedOperation,
    UserModel? user,
  }) = AuthError;

  /// Registration in progress
  const factory AuthState.registering() = AuthRegistering;

  /// Registration completed successfully
  const factory AuthState.registrationComplete({
    required String email,
    @Default(false) bool needsEmailVerification,
  }) = AuthRegistrationComplete;

  /// Password reset email sent
  const factory AuthState.passwordResetSent({required String email}) =
      AuthPasswordResetSent;

  /// Email verification sent
  const factory AuthState.emailVerificationSent() = AuthEmailVerificationSent;

  /// Profile update in progress
  const factory AuthState.updatingProfile({required UserModel user}) =
      AuthUpdatingProfile;

  /// Profile updated successfully
  const factory AuthState.profileUpdated({required UserModel user}) =
      AuthProfileUpdated;

  /// Password change in progress
  const factory AuthState.changingPassword({required UserModel user}) =
      AuthChangingPassword;

  /// Password changed successfully
  const factory AuthState.passwordChanged({required UserModel user}) =
      AuthPasswordChanged;

  /// Re-authentication required
  const factory AuthState.reauthenticationRequired({
    required String operation,
    required UserModel user,
  }) = AuthReauthenticationRequired;

  /// Re-authentication in progress
  const factory AuthState.reauthenticating({required UserModel user}) =
      AuthReauthenticating;

  /// Account deletion in progress
  const factory AuthState.deletingAccount({required UserModel user}) =
      AuthDeletingAccount;

  /// Account deleted successfully
  const factory AuthState.accountDeleted() = AuthAccountDeleted;

  /// Account linking in progress
  const factory AuthState.linkingAccount({
    required UserModel user,
    required String provider,
  }) = AuthLinkingAccount;

  /// Account linked successfully
  const factory AuthState.accountLinked({
    required UserModel user,
    required String provider,
  }) = AuthAccountLinked;

  /// Account unlinking in progress
  const factory AuthState.unlinkingAccount({
    required UserModel user,
    required String provider,
  }) = AuthUnlinkingAccount;

  /// Account unlinked successfully
  const factory AuthState.accountUnlinked({
    required UserModel user,
    required String provider,
  }) = AuthAccountUnlinked;

  /// Email update in progress
  const factory AuthState.updatingEmail({
    required UserModel user,
    required String newEmail,
  }) = AuthUpdatingEmail;

  /// Email updated successfully
  const factory AuthState.emailUpdated({
    required UserModel user,
    required String newEmail,
  }) = AuthEmailUpdated;
}

/// Extension to provide convenient getters for AuthState
extension AuthStateExtension on AuthState {
  /// Check if state is loading
  bool get isLoading => when(
    initial: () => false,
    loading: (_) => true,
    authenticated: (_, __, ___) => false,
    unauthenticated: () => false,
    error: (_, __, ___, ____) => false,
    registering: () => true,
    registrationComplete: (_, __) => false,
    passwordResetSent: (_) => false,
    emailVerificationSent: () => false,
    updatingProfile: (_) => true,
    profileUpdated: (_) => false,
    changingPassword: (_) => true,
    passwordChanged: (_) => false,
    reauthenticationRequired: (_, __) => false,
    reauthenticating: (_) => true,
    deletingAccount: (_) => true,
    accountDeleted: () => false,
    linkingAccount: (_, __) => true,
    accountLinked: (_, __) => false,
    unlinkingAccount: (_, __) => true,
    accountUnlinked: (_, __) => false,
    updatingEmail: (_, __) => true,
    emailUpdated: (_, __) => false,
  );

  /// Check if user is authenticated
  bool get isAuthenticated => when(
    initial: () => false,
    loading: (_) => false,
    authenticated: (_, __, ___) => true,
    unauthenticated: () => false,
    error: (_, __, ___, user) => user != null,
    registering: () => false,
    registrationComplete: (_, __) => false,
    passwordResetSent: (_) => false,
    emailVerificationSent: () => false,
    updatingProfile: (_) => true,
    profileUpdated: (_) => true,
    changingPassword: (_) => true,
    passwordChanged: (_) => true,
    reauthenticationRequired: (_, __) => true,
    reauthenticating: (_) => true,
    deletingAccount: (_) => true,
    accountDeleted: () => false,
    linkingAccount: (_, __) => true,
    accountLinked: (_, __) => true,
    unlinkingAccount: (_, __) => true,
    accountUnlinked: (_, __) => true,
    updatingEmail: (_, __) => true,
    emailUpdated: (_, __) => true,
  );

  /// Get current user if available
  UserModel? get currentUser => when(
    initial: () => null,
    loading: (_) => null,
    authenticated: (user, _, __) => user,
    unauthenticated: () => null,
    error: (_, __, ___, user) => user,
    registering: () => null,
    registrationComplete: (_, __) => null,
    passwordResetSent: (_) => null,
    emailVerificationSent: () => null,
    updatingProfile: (user) => user,
    profileUpdated: (user) => user,
    changingPassword: (user) => user,
    passwordChanged: (user) => user,
    reauthenticationRequired: (_, user) => user,
    reauthenticating: (user) => user,
    deletingAccount: (user) => user,
    accountDeleted: () => null,
    linkingAccount: (user, _) => user,
    accountLinked: (user, _) => user,
    unlinkingAccount: (user, _) => user,
    accountUnlinked: (user, _) => user,
    updatingEmail: (user, _) => user,
    emailUpdated: (user, _) => user,
  );

  /// Check if state has error
  bool get hasError => when(
    initial: () => false,
    loading: (_) => false,
    authenticated: (_, __, ___) => false,
    unauthenticated: () => false,
    error: (_, __, ___, ____) => true,
    registering: () => false,
    registrationComplete: (_, __) => false,
    passwordResetSent: (_) => false,
    emailVerificationSent: () => false,
    updatingProfile: (_) => false,
    profileUpdated: (_) => false,
    changingPassword: (_) => false,
    passwordChanged: (_) => false,
    reauthenticationRequired: (_, __) => false,
    reauthenticating: (_) => false,
    deletingAccount: (_) => false,
    accountDeleted: () => false,
    linkingAccount: (_, __) => false,
    accountLinked: (_, __) => false,
    unlinkingAccount: (_, __) => false,
    accountUnlinked: (_, __) => false,
    updatingEmail: (_, __) => false,
    emailUpdated: (_, __) => false,
  );

  /// Get error message if available
  String? get errorMessage => when(
    initial: () => null,
    loading: (_) => null,
    authenticated: (_, __, ___) => null,
    unauthenticated: () => null,
    error: (message, _, __, ___) => message,
    registering: () => null,
    registrationComplete: (_, __) => null,
    passwordResetSent: (_) => null,
    emailVerificationSent: () => null,
    updatingProfile: (_) => null,
    profileUpdated: (_) => null,
    changingPassword: (_) => null,
    passwordChanged: (_) => null,
    reauthenticationRequired: (_, __) => null,
    reauthenticating: (_) => null,
    deletingAccount: (_) => null,
    accountDeleted: () => null,
    linkingAccount: (_, __) => null,
    accountLinked: (_, __) => null,
    unlinkingAccount: (_, __) => null,
    accountUnlinked: (_, __) => null,
    updatingEmail: (_, __) => null,
    emailUpdated: (_, __) => null,
  );
}
