import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../models/user_model.dart';

part 'user_event.freezed.dart';

/// Events for User BLoC
/// Handles all user-related operations and state changes
@freezed
class UserEvent with _$UserEvent {
  /// Load all users
  const factory UserEvent.loadUsers() = LoadUsers;

  /// Refresh users (reload from source)
  const factory UserEvent.refreshUsers({@Default(false) bool clearFilters}) =
      RefreshUsers;

  /// Search users by query
  const factory UserEvent.searchUsers(String query) = SearchUsers;

  /// Filter users by role
  const factory UserEvent.filterByRole(String role) = FilterByRole;

  /// Filter users by status
  const factory UserEvent.filterByStatus(String status) = FilterByStatus;

  /// Clear all filters
  const factory UserEvent.clearFilters() = ClearFilters;

  /// Create new user
  const factory UserEvent.createUser({
    required String fullName,
    required String email,
    required String password,
    required String role,
    required String createdBy,
    UserPermissions? permissions,
  }) = CreateUser;

  /// Update existing user
  const factory UserEvent.updateUser({
    required UserModel user,
    required String updatedBy,
  }) = UpdateUser;

  /// Update user status
  const factory UserEvent.updateUserStatus({
    required String userId,
    required String status,
    required String updatedBy,
  }) = UpdateUserStatus;

  /// Update user permissions
  const factory UserEvent.updateUserPermissions({
    required String userId,
    required UserPermissions permissions,
    required String updatedBy,
  }) = UpdateUserPermissions;

  /// Delete user
  const factory UserEvent.deleteUser({
    required String userId,
    required String deletedBy,
  }) = DeleteUser;

  /// Sync Firebase Auth users
  const factory UserEvent.syncFirebaseAuthUsers({@Default(false) bool silent}) =
      SyncFirebaseAuthUsers;

  /// Clear error state
  const factory UserEvent.clearError() = ClearError;

  /// Retry last failed operation
  const factory UserEvent.retryLastOperation() = RetryLastOperation;
}
