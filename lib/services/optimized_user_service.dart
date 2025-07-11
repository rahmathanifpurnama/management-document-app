import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../core/services/firebase_service.dart';
import 'cloud_functions_service.dart';

/// Optimized user service using Cloud Functions for heavy operations
class OptimizedUserService {
  final FirebaseService _firebaseService = FirebaseService.instance;
  final CloudFunctionsService _cloudFunctions = CloudFunctionsService.instance;

  /// Create a new user using Cloud Functions
  Future<String> createUser({
    required String fullName,
    required String email,
    required String password,
    required String role,
    Map<String, dynamic>? permissions,
  }) async {
    try {
      debugPrint('🔄 Creating user via Cloud Functions: $email');

      // Use Cloud Functions for secure user creation
      final userId = await _cloudFunctions.createUser(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
        permissions: permissions,
      );

      debugPrint('✅ User created successfully: $userId');
      return userId;
    } catch (e) {
      debugPrint('❌ Error creating user: $e');
      rethrow;
    }
  }

  /// Update user permissions using Cloud Functions
  Future<void> updateUserPermissions({
    required String userId,
    required Map<String, dynamic> permissions,
  }) async {
    try {
      debugPrint('🔄 Updating user permissions via Cloud Functions: $userId');

      // Use Cloud Functions for secure permission updates
      await _cloudFunctions.updateUserPermissions(
        userId: userId,
        permissions: permissions,
      );

      debugPrint('✅ User permissions updated successfully');
    } catch (e) {
      debugPrint('❌ Error updating user permissions: $e');
      rethrow;
    }
  }

  /// Delete a user using Cloud Functions
  Future<void> deleteUser(String userId) async {
    try {
      debugPrint('🔄 Deleting user via Cloud Functions: $userId');

      // Use Cloud Functions for secure user deletion
      await _cloudFunctions.deleteUser(userId);

      debugPrint('✅ User deleted successfully');
    } catch (e) {
      debugPrint('❌ Error deleting user: $e');
      rethrow;
    }
  }

  /// Get all users (lightweight Firestore query)
  Future<List<UserModel>> getAllUsers() async {
    try {
      debugPrint('📋 Loading users from Firestore...');

      final snapshot = await _firebaseService.usersCollection
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      final users = snapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();

      debugPrint('✅ Loaded ${users.length} users');
      return users;
    } catch (e) {
      debugPrint('❌ Error loading users: $e');
      rethrow;
    }
  }

  /// Get user by ID (lightweight Firestore query)
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firebaseService.usersCollection.doc(userId).get();

      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error getting user: $e');
      return null;
    }
  }

  /// Search users by name or email (lightweight client-side filtering)
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      if (query.isEmpty) {
        return await getAllUsers();
      }

      final allUsers = await getAllUsers();
      final filteredUsers = allUsers
          .where(
            (user) =>
                user.fullName.toLowerCase().contains(query.toLowerCase()) ||
                user.email.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();

      debugPrint('🔍 Found ${filteredUsers.length} users matching "$query"');
      return filteredUsers;
    } catch (e) {
      debugPrint('❌ Error searching users: $e');
      rethrow;
    }
  }

  /// Filter users by role (lightweight client-side filtering)
  Future<List<UserModel>> getUsersByRole(String role) async {
    try {
      final allUsers = await getAllUsers();
      final filteredUsers = allUsers
          .where((user) => user.role.toLowerCase() == role.toLowerCase())
          .toList();

      debugPrint('🔍 Found ${filteredUsers.length} users with role "$role"');
      return filteredUsers;
    } catch (e) {
      debugPrint('❌ Error filtering users by role: $e');
      rethrow;
    }
  }

  /// Get users stream for real-time updates
  Stream<List<UserModel>> getUsersStream() {
    try {
      return _firebaseService.usersCollection
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => UserModel.fromFirestore(doc))
                .toList(),
          );
    } catch (e) {
      debugPrint('❌ Error creating users stream: $e');
      rethrow;
    }
  }

  /// Bulk user operations using Cloud Functions
  Future<Map<String, dynamic>> bulkUserOperations({
    required String operation,
    required List<String> userIds,
  }) async {
    try {
      debugPrint('🔄 Performing bulk $operation on ${userIds.length} users');

      // Use Cloud Functions for bulk operations
      final result = await _cloudFunctions.bulkUserOperations(
        operation: operation,
        userIds: userIds,
      );

      debugPrint('✅ Bulk user operation completed');
      return result;
    } catch (e) {
      debugPrint('❌ Error in bulk user operations: $e');
      rethrow;
    }
  }

  /// Get user statistics
  Future<Map<String, dynamic>> getUserStatistics() async {
    try {
      debugPrint('📊 Calculating user statistics...');

      final users = await getAllUsers();

      final stats = {
        'totalUsers': users.length,
        'activeUsers': users.where((u) => u.isActive).length,
        'adminUsers': users.where((u) => u.role == 'admin').length,
        'regularUsers': users.where((u) => u.role == 'user').length,
        'recentlyCreated': users
            .where(
              (u) =>
                  u.createdAt != null &&
                  DateTime.now().difference(u.createdAt!).inDays <= 7,
            )
            .length,
        'usersWithDocuments':
            0, // This would need to be calculated with document counts
      };

      // Calculate users with documents (lightweight aggregation)
      for (final user in users) {
        final documentsSnapshot = await _firebaseService.documentsCollection
            .where('uploadedBy', isEqualTo: user.id)
            .where('isActive', isEqualTo: true)
            .limit(1)
            .get();

        if (documentsSnapshot.docs.isNotEmpty) {
          stats['usersWithDocuments'] =
              (stats['usersWithDocuments'] as int) + 1;
        }
      }

      debugPrint('✅ User statistics calculated');
      return stats;
    } catch (e) {
      debugPrint('❌ Error calculating user statistics: $e');
      rethrow;
    }
  }

  /// Update user profile (lightweight Firestore update)
  Future<void> updateUserProfile({
    required String userId,
    String? fullName,
    String? profileImageUrl,
  }) async {
    try {
      debugPrint('🔄 Updating user profile: $userId');

      final updateData = <String, dynamic>{
        'updatedAt': _firebaseService.serverTimestamp,
      };

      if (fullName != null) updateData['fullName'] = fullName;
      if (profileImageUrl != null) {
        updateData['profileImageUrl'] = profileImageUrl;
      }

      await _firebaseService.usersCollection.doc(userId).update(updateData);

      debugPrint('✅ User profile updated successfully');
    } catch (e) {
      debugPrint('❌ Error updating user profile: $e');
      rethrow;
    }
  }

  /// Update last login timestamp (lightweight Firestore update)
  Future<void> updateLastLogin(String userId) async {
    try {
      await _firebaseService.usersCollection.doc(userId).update({
        'lastLogin': _firebaseService.serverTimestamp,
        'updatedAt': _firebaseService.serverTimestamp,
      });
    } catch (e) {
      debugPrint('❌ Error updating last login: $e');
      // Don't rethrow as this is not critical
    }
  }

  /// Validate email format (client-side validation)
  bool validateEmail(String email) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(email);
  }

  /// Check if email exists (lightweight Firestore query)
  Future<bool> emailExists(String email, {String? excludeUserId}) async {
    try {
      final snapshot = await _firebaseService.usersCollection
          .where('email', isEqualTo: email.toLowerCase())
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return false;
      }

      // If excluding a specific user ID, check if the found user is different
      if (excludeUserId != null) {
        return snapshot.docs.first.id != excludeUserId;
      }

      return true;
    } catch (e) {
      debugPrint('❌ Error checking email existence: $e');
      return false;
    }
  }

  /// Get user permissions (lightweight Firestore query)
  Future<Map<String, dynamic>?> getUserPermissions(String userId) async {
    try {
      final user = await getUserById(userId);
      return user?.permissions.toMap();
    } catch (e) {
      debugPrint('❌ Error getting user permissions: $e');
      return null;
    }
  }

  /// Check if user has specific permission
  Future<bool> hasPermission(String userId, String permission) async {
    try {
      final permissions = await getUserPermissions(userId);
      return permissions?[permission] == true;
    } catch (e) {
      debugPrint('❌ Error checking user permission: $e');
      return false;
    }
  }

  /// Get users by permission (lightweight client-side filtering)
  Future<List<UserModel>> getUsersByPermission(String permission) async {
    try {
      final allUsers = await getAllUsers();
      final filteredUsers = allUsers
          .where((user) => user.permissions.toMap()[permission] == true)
          .toList();

      debugPrint(
        '🔍 Found ${filteredUsers.length} users with permission "$permission"',
      );
      return filteredUsers;
    } catch (e) {
      debugPrint('❌ Error filtering users by permission: $e');
      rethrow;
    }
  }

  /// Get user activity summary (lightweight aggregation)
  Future<Map<String, dynamic>> getUserActivitySummary(String userId) async {
    try {
      debugPrint('📊 Getting activity summary for user: $userId');

      // Get document count
      final documentsSnapshot = await _firebaseService.documentsCollection
          .where('uploadedBy', isEqualTo: userId)
          .where('status', isEqualTo: 'active')
          .get();

      // Activities collection has been removed - return empty list
      final activitiesSnapshot = <Map<String, dynamic>>[];

      final summary = {
        'documentsUploaded': documentsSnapshot.size,
        'recentActivities': activitiesSnapshot, // Empty list
        'lastActivity': null, // No activities available
      };

      debugPrint('✅ User activity summary retrieved');
      return summary;
    } catch (e) {
      debugPrint('❌ Error getting user activity summary: $e');
      rethrow;
    }
  }
}
