import '../../../models/user_model.dart';

/// Repository interface for user operations
/// Defines contract for all user-related data operations
abstract class UserRepository {
  /// Get all users from the data source
  Future<List<UserModel>> getAllUsers();

  /// Get user by ID
  Future<UserModel?> getUserById(String userId);

  /// Create a new user
  Future<UserModel> createUser({
    required String fullName,
    required String email,
    required String password,
    required String role,
    required String createdBy,
    UserPermissions? permissions,
  });

  /// Update existing user
  Future<void> updateUser(UserModel user, String updatedBy);

  /// Update user status (active/inactive)
  Future<void> updateUserStatus(String userId, String status, String updatedBy);

  /// Update user permissions
  Future<void> updateUserPermissions(
    String userId,
    UserPermissions permissions,
    String updatedBy,
  );

  /// Delete user
  Future<void> deleteUser(String userId, String deletedBy);

  /// Search users by query (name or email)
  Future<List<UserModel>> searchUsers(String query);

  /// Get users by role
  Future<List<UserModel>> getUsersByRole(String role);

  /// Get users by status
  Future<List<UserModel>> getUsersByStatus(String status);

  /// Get user statistics
  Future<Map<String, int>> getUserStatistics();

  /// Sync Firebase Auth users to Firestore
  Future<Map<String, dynamic>?> syncFirebaseAuthUsers({bool silent = false});

  /// Get users stream for real-time updates
  Stream<List<UserModel>> getUsersStream();
}
