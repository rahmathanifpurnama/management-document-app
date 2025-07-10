import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../core/services/user_service.dart';
import '../../../services/cloud_functions_service.dart';
import '../../../services/statistics_sync_service.dart';
import '../../../services/activity_service.dart';
import '../../../models/user_model.dart';
import 'user_repository.dart';

/// Implementation of UserRepository using existing services
/// Provides timeout handling, activity logging, and non-blocking operations
class UserRepositoryImpl implements UserRepository {
  final UserService _userService = UserService.instance;
  final CloudFunctionsService _cloudFunctions = CloudFunctionsService.instance;
  final StatisticsSyncService _statisticsSync = StatisticsSyncService.instance;
  final ActivityService _activityService = ActivityService.instance;

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      debugPrint('📋 UserRepository: Loading all users...');

      // Add timeout to prevent hanging
      final users = await _userService.getAllUsers().timeout(
        const Duration(seconds: 10),
      );

      debugPrint('✅ UserRepository: Loaded ${users.length} users');
      return users;
    } catch (e) {
      debugPrint('❌ UserRepository: Failed to load users - $e');
      throw Exception('Failed to load users: $e');
    }
  }

  @override
  Future<UserModel?> getUserById(String userId) async {
    try {
      debugPrint('🔍 UserRepository: Getting user by ID: $userId');

      final user = await _userService
          .getUserById(userId)
          .timeout(const Duration(seconds: 5));

      if (user != null) {
        debugPrint('✅ UserRepository: Found user: ${user.fullName}');
      } else {
        debugPrint('⚠️ UserRepository: User not found: $userId');
      }

      return user;
    } catch (e) {
      debugPrint('❌ UserRepository: Failed to get user by ID - $e');
      throw Exception('Failed to get user: $e');
    }
  }

  @override
  Future<UserModel> createUser({
    required String fullName,
    required String email,
    required String password,
    required String role,
    required String createdBy,
    UserPermissions? permissions,
  }) async {
    try {
      debugPrint('🔄 UserRepository: Creating user: $email');

      final user = await _userService
          .createUser(
            fullName: fullName,
            email: email,
            password: password,
            role: role,
            createdBy: createdBy,
            permissions: permissions,
          )
          .timeout(const Duration(seconds: 15));

      // Log activity
      await _activityService.logActivity(
        userId: createdBy,
        action: 'create',
        targetType: 'user',
        targetId: user.id,
        details: {'userName': fullName, 'userEmail': email, 'userRole': role},
      );

      debugPrint('✅ UserRepository: User created successfully: ${user.id}');
      return user;
    } catch (e) {
      debugPrint('❌ UserRepository: Failed to create user - $e');
      rethrow;
    }
  }

  @override
  Future<void> updateUser(UserModel user, String updatedBy) async {
    try {
      debugPrint('🔄 UserRepository: Updating user: ${user.id}');

      await _userService
          .updateUser(user, updatedBy)
          .timeout(const Duration(seconds: 10));

      // Log activity
      await _activityService.logActivity(
        userId: updatedBy,
        action: 'edit',
        targetType: 'user',
        targetId: user.id,
        details: {'userName': user.fullName, 'userEmail': user.email},
      );

      debugPrint('✅ UserRepository: User updated successfully: ${user.id}');
    } catch (e) {
      debugPrint('❌ UserRepository: Failed to update user - $e');
      throw Exception('Failed to update user: $e');
    }
  }

  @override
  Future<void> updateUserStatus(
    String userId,
    String status,
    String updatedBy,
  ) async {
    try {
      debugPrint('🔄 UserRepository: Updating user status: $userId -> $status');

      await _userService
          .updateUserStatus(userId, status, updatedBy)
          .timeout(const Duration(seconds: 5));

      // Log activity
      await _activityService.logActivity(
        userId: updatedBy,
        action: 'edit',
        targetType: 'user',
        targetId: userId,
        details: {'statusChanged': status},
      );

      debugPrint('✅ UserRepository: User status updated successfully');
    } catch (e) {
      debugPrint('❌ UserRepository: Failed to update user status - $e');
      throw Exception('Failed to update user status: $e');
    }
  }

  @override
  Future<void> updateUserPermissions(
    String userId,
    UserPermissions permissions,
    String updatedBy,
  ) async {
    try {
      debugPrint('🔄 UserRepository: Updating user permissions: $userId');

      await _userService
          .updateUserPermissions(userId, permissions, updatedBy)
          .timeout(const Duration(seconds: 10));

      // Log activity
      await _activityService.logActivity(
        userId: updatedBy,
        action: 'edit',
        targetType: 'user',
        targetId: userId,
        details: {'permissionsUpdated': permissions.toMap()},
      );

      debugPrint('✅ UserRepository: User permissions updated successfully');
    } catch (e) {
      debugPrint('❌ UserRepository: Failed to update user permissions - $e');
      throw Exception('Failed to update user permissions: $e');
    }
  }

  @override
  Future<void> deleteUser(String userId, String deletedBy) async {
    try {
      debugPrint('🔄 UserRepository: Deleting user: $userId');

      // Get user info before deletion for logging
      final user = await getUserById(userId);
      final userName = user?.fullName ?? 'Unknown User';

      await _userService
          .deleteUser(userId, deletedBy)
          .timeout(const Duration(seconds: 15));

      // Log activity
      await _activityService.logActivity(
        userId: deletedBy,
        action: 'delete',
        targetType: 'user',
        targetId: userId,
        details: {'userName': userName},
      );

      // Trigger statistics refresh
      _statisticsSync.notifyUserDeleted(userId: userId, userName: userName);

      debugPrint('✅ UserRepository: User deleted successfully: $userId');
    } catch (e) {
      debugPrint('❌ UserRepository: Failed to delete user - $e');
      throw Exception('Failed to delete user: $e');
    }
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      debugPrint('🔍 UserRepository: Searching users: $query');

      final users = await _userService
          .searchUsers(query)
          .timeout(const Duration(seconds: 8));

      debugPrint(
        '✅ UserRepository: Found ${users.length} users matching: $query',
      );
      return users;
    } catch (e) {
      debugPrint('❌ UserRepository: Failed to search users - $e');
      throw Exception('Failed to search users: $e');
    }
  }

  @override
  Future<List<UserModel>> getUsersByRole(String role) async {
    try {
      debugPrint('🔍 UserRepository: Getting users by role: $role');

      final users = await _userService
          .getUsersByRole(role)
          .timeout(const Duration(seconds: 8));

      debugPrint(
        '✅ UserRepository: Found ${users.length} users with role: $role',
      );
      return users;
    } catch (e) {
      debugPrint('❌ UserRepository: Failed to get users by role - $e');
      throw Exception('Failed to get users by role: $e');
    }
  }

  @override
  Future<List<UserModel>> getUsersByStatus(String status) async {
    try {
      debugPrint('🔍 UserRepository: Getting users by status: $status');

      final allUsers = await getAllUsers();
      final filteredUsers = allUsers
          .where((user) => user.status == status)
          .toList();

      debugPrint(
        '✅ UserRepository: Found ${filteredUsers.length} users with status: $status',
      );
      return filteredUsers;
    } catch (e) {
      debugPrint('❌ UserRepository: Failed to get users by status - $e');
      throw Exception('Failed to get users by status: $e');
    }
  }

  @override
  Future<Map<String, int>> getUserStatistics() async {
    try {
      debugPrint('📊 UserRepository: Getting user statistics...');

      final users = await getAllUsers();

      final stats = {
        'total': users.length,
        'active': users.where((u) => u.status == 'active').length,
        'inactive': users.where((u) => u.status == 'inactive').length,
        'admin': users.where((u) => u.role == 'admin').length,
        'user': users.where((u) => u.role == 'user').length,
      };

      debugPrint('✅ UserRepository: User statistics calculated: $stats');
      return stats;
    } catch (e) {
      debugPrint('❌ UserRepository: Failed to get user statistics - $e');
      throw Exception('Failed to get user statistics: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> syncFirebaseAuthUsers({
    bool silent = false,
  }) async {
    try {
      if (!silent) {
        debugPrint('🔄 UserRepository: Syncing Firebase Auth users...');
      }

      final result = await _cloudFunctions.autoSyncFirebaseAuthUsers().timeout(
        const Duration(seconds: 30),
      );

      if (!silent) {
        debugPrint('✅ UserRepository: Firebase Auth users synced: $result');
      }

      return result;
    } catch (e) {
      if (!silent) {
        debugPrint('❌ UserRepository: Failed to sync Firebase Auth users - $e');
      }
      throw Exception('Failed to sync Firebase Auth users: $e');
    }
  }

  @override
  Stream<List<UserModel>> getUsersStream() {
    try {
      debugPrint('📡 UserRepository: Setting up users stream...');
      return _userService.getUsersStream();
    } catch (e) {
      debugPrint('❌ UserRepository: Failed to setup users stream - $e');
      throw Exception('Failed to setup users stream: $e');
    }
  }
}
