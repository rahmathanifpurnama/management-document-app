import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../models/user_model.dart';

part 'auth_event.freezed.dart';

/// Events for Auth BLoC
/// Handles complex authentication operations that require state management
@freezed
class AuthEvent with _$AuthEvent {
  /// Login with email and password
  const factory AuthEvent.login({
    required String email,
    required String password,
    @Default(false) bool rememberMe,
  }) = Login;

  /// Logout current user
  const factory AuthEvent.logout() = Logout;

  /// Register new user account
  const factory AuthEvent.register({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) = Register;

  /// Reset password via email
  const factory AuthEvent.resetPassword({required String email}) =
      ResetPassword;

  /// Update user profile
  const factory AuthEvent.updateProfile({
    String? fullName,
    String? phoneNumber,
    String? photoUrl,
  }) = UpdateProfile;

  /// Change password
  const factory AuthEvent.changePassword({
    required String currentPassword,
    required String newPassword,
  }) = ChangePassword;

  /// Send email verification
  const factory AuthEvent.sendEmailVerification() = SendEmailVerification;

  /// Refresh current user data
  const factory AuthEvent.refreshUserData() = RefreshUserData;

  /// Update user permissions (admin only)
  const factory AuthEvent.updateUserPermissions({
    required String userId,
    required UserPermissions permissions,
  }) = UpdateUserPermissions;

  /// Check and refresh permissions
  const factory AuthEvent.refreshPermissions() = RefreshPermissions;

  /// Verify email with action code
  const factory AuthEvent.verifyEmail({required String actionCode}) =
      VerifyEmail;

  /// Confirm password reset with action code
  const factory AuthEvent.confirmPasswordReset({
    required String actionCode,
    required String newPassword,
  }) = ConfirmPasswordReset;

  /// Re-authenticate user (for sensitive operations)
  const factory AuthEvent.reauthenticate({required String password}) =
      Reauthenticate;

  /// Delete user account
  const factory AuthEvent.deleteAccount({required String password}) =
      DeleteAccount;

  /// Link account with provider (Google, Facebook, etc.)
  const factory AuthEvent.linkAccount({required String provider}) = LinkAccount;

  /// Unlink account from provider
  const factory AuthEvent.unlinkAccount({required String provider}) =
      UnlinkAccount;

  /// Update email address
  const factory AuthEvent.updateEmail({
    required String newEmail,
    required String password,
  }) = UpdateEmail;

  /// Clear error state
  const factory AuthEvent.clearError() = ClearError;

  /// Retry last failed operation
  const factory AuthEvent.retryLastOperation() = RetryLastOperation;

  /// Initialize auth state
  const factory AuthEvent.initialize() = Initialize;

  /// Handle auth state changes from Firebase
  const factory AuthEvent.authStateChanged({
    required bool isAuthenticated,
    String? userId,
  }) = AuthStateChanged;
}
