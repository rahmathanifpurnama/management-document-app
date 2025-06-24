import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../core/services/firebase_service.dart';
import '../core/services/auth_service.dart';
import '../config/firebase_config.dart';
import '../core/utils/anr_prevention.dart';
import '../core/config/anr_config.dart';

/// Enhanced Authentication Service with improved role-based access control
class EnhancedAuthService {
  static EnhancedAuthService? _instance;
  static EnhancedAuthService get instance =>
      _instance ??= EnhancedAuthService._();

  EnhancedAuthService._();

  final FirebaseService _firebaseService = FirebaseService.instance;
  final AuthService _authService = AuthService.instance;

  // Permission cache to improve performance
  final Map<String, UserPermissions> _permissionCache = {};
  final Map<String, DateTime> _permissionCacheTimestamp = {};
  static const Duration _permissionCacheExpiry = Duration(minutes: 15);

  // Current user cache to avoid repeated Firestore calls
  UserModel? _cachedCurrentUser;
  DateTime? _userCacheTimestamp;
  static const Duration _userCacheExpiry = Duration(minutes: 5);

  /// Get current user model with caching
  Future<UserModel?> get currentUserModel async {
    final now = DateTime.now();

    // Check if we have cached user data that's still valid
    if (_cachedCurrentUser != null && _userCacheTimestamp != null) {
      if (now.difference(_userCacheTimestamp!) < _userCacheExpiry) {
        return _cachedCurrentUser;
      }
    }

    // Get fresh user data
    try {
      final userData = await _authService.getCurrentUserData();
      _cachedCurrentUser = userData;
      _userCacheTimestamp = now;
      return userData;
    } catch (e) {
      debugPrint('❌ Failed to get current user data: $e');
      return null;
    }
  }

  /// Clear user cache
  void clearUserCache() {
    _cachedCurrentUser = null;
    _userCacheTimestamp = null;
  }

  /// Check if current user has admin privileges
  Future<bool> get isCurrentUserAdmin async {
    final currentUser = await currentUserModel;
    return currentUser?.isAdmin == true;
  }

  /// Check if current user has specific document permission
  Future<bool> hasDocumentPermission(String permission) async {
    final currentUser = await currentUserModel;
    if (currentUser == null) return false;

    // Admin users have all permissions
    if (currentUser.isAdmin) return true;

    // Get cached or fresh permissions
    final permissions = await _getUserPermissions(currentUser.id);
    return permissions.hasDocumentPermission(permission);
  }

  /// Check if current user can access specific category
  Future<bool> hasCategoryAccess(String categoryId) async {
    final currentUser = await currentUserModel;
    if (currentUser == null) return false;

    // Admin users have access to all categories
    if (currentUser.isAdmin) return true;

    // Get cached or fresh permissions
    final permissions = await _getUserPermissions(currentUser.id);
    return permissions.hasCategoryAccess(categoryId);
  }

  /// Check if current user has specific system permission
  Future<bool> hasSystemPermission(String permission) async {
    final currentUser = await currentUserModel;
    if (currentUser == null) return false;

    // Admin users have all system permissions
    if (currentUser.isAdmin) return true;

    // Get cached or fresh permissions
    final permissions = await _getUserPermissions(currentUser.id);
    return permissions.hasSystemPermission(permission);
  }

  /// Get user permissions with caching
  Future<UserPermissions> _getUserPermissions(String userId) async {
    final now = DateTime.now();
    final cacheKey = userId;

    // Check if we have cached permissions that are still valid
    if (_permissionCache.containsKey(cacheKey) &&
        _permissionCacheTimestamp.containsKey(cacheKey)) {
      final cacheTime = _permissionCacheTimestamp[cacheKey]!;
      if (now.difference(cacheTime) < _permissionCacheExpiry) {
        debugPrint('📋 Using cached permissions for user $userId');
        return _permissionCache[cacheKey]!;
      }
    }

    try {
      // Get fresh permissions from Firestore
      final userDoc = await ANRPrevention.executeWithTimeout(
        _firebaseService.usersCollection.doc(userId).get(),
        timeout: ANRConfig.firestoreQueryTimeout,
        operationName: 'Get User Permissions',
      );

      if (userDoc?.exists == true) {
        final userData = userDoc!.data() as Map<String, dynamic>;
        final permissions = UserPermissions.fromMap(
          userData['permissions'] ?? {},
        );

        // Cache the permissions
        _permissionCache[cacheKey] = permissions;
        _permissionCacheTimestamp[cacheKey] = now;

        debugPrint('💾 Cached fresh permissions for user $userId');
        return permissions;
      }
    } catch (e) {
      debugPrint('❌ Failed to get user permissions for $userId: $e');
    }

    // Return default permissions if failed
    return UserPermissions.user();
  }

  /// Clear permission cache for a specific user
  void clearUserPermissionCache(String userId) {
    _permissionCache.remove(userId);
    _permissionCacheTimestamp.remove(userId);
    debugPrint('🗑️ Cleared permission cache for user $userId');
  }

  /// Clear all permission cache
  void clearAllPermissionCache() {
    _permissionCache.clear();
    _permissionCacheTimestamp.clear();
    debugPrint('🗑️ Cleared all permission cache');
  }

  /// Update user permissions
  Future<bool> updateUserPermissions(
    String userId,
    UserPermissions permissions,
  ) async {
    try {
      // Only admin can update permissions
      if (!(await isCurrentUserAdmin)) {
        debugPrint(
          '⚠️ Permission denied: Only admin can update user permissions',
        );
        return false;
      }

      await _firebaseService.usersCollection.doc(userId).update({
        'permissions': permissions.toMap(),
      });

      // Clear cache for this user to force refresh
      clearUserPermissionCache(userId);

      debugPrint('✅ Updated permissions for user $userId');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to update permissions for user $userId: $e');
      return false;
    }
  }

  /// Check if user can perform unlimited queries
  Future<bool> canPerformUnlimitedQueries() async {
    return (await isCurrentUserAdmin) &&
        FirebaseConfig.shouldEnableUnlimitedQueries;
  }

  /// Check if user can access storage management
  Future<bool> canAccessStorageManagement() async {
    return (await isCurrentUserAdmin) || FirebaseConfig.shouldEnableStorageSync;
  }

  /// Check if user can manage other users
  Future<bool> canManageUsers() async {
    return await hasSystemPermission('user_management');
  }

  /// Check if user can view analytics
  Future<bool> canViewAnalytics() async {
    return await hasSystemPermission('analytics');
  }

  /// Check if user can upload files
  Future<bool> canUploadFiles() async {
    return await hasDocumentPermission('upload');
  }

  /// Check if user can delete files
  Future<bool> canDeleteFiles() async {
    return await hasDocumentPermission('delete');
  }

  /// Check if user can approve files
  Future<bool> canApproveFiles() async {
    return await hasDocumentPermission('approve');
  }

  /// Get user role display name
  String getUserRoleDisplayName(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'Administrator';
      case 'user':
        return 'User';
      case 'moderator':
        return 'Moderator';
      case 'viewer':
        return 'Viewer';
      default:
        return 'Unknown';
    }
  }

  /// Get available permissions for a role
  UserPermissions getDefaultPermissionsForRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return UserPermissions.admin();
      case 'user':
        return UserPermissions.user();
      case 'moderator':
        return UserPermissions(
          documents: ['view', 'upload', 'approve'],
          categories: [],
          system: ['analytics'],
        );
      case 'viewer':
        return UserPermissions(documents: ['view'], categories: [], system: []);
      default:
        return UserPermissions.user();
    }
  }

  /// Validate user permissions
  bool validatePermissions(UserPermissions permissions) {
    // Check if permissions are valid
    final validDocumentPermissions = [
      'view',
      'upload',
      'delete',
      'approve',
      'edit',
    ];
    final validSystemPermissions = [
      'user_management',
      'analytics',
      'system_settings',
    ];

    // Validate document permissions
    for (final permission in permissions.documents) {
      if (!validDocumentPermissions.contains(permission)) {
        debugPrint('⚠️ Invalid document permission: $permission');
        return false;
      }
    }

    // Validate system permissions
    for (final permission in permissions.system) {
      if (!validSystemPermissions.contains(permission)) {
        debugPrint('⚠️ Invalid system permission: $permission');
        return false;
      }
    }

    return true;
  }

  /// Get current user's permission summary
  Future<Map<String, dynamic>> getCurrentUserPermissionSummary() async {
    final currentUser = await currentUserModel;
    if (currentUser == null) {
      return {'error': 'No user logged in'};
    }

    final permissions = await _getUserPermissions(currentUser.id);

    return {
      'userId': currentUser.id,
      'role': currentUser.role,
      'isAdmin': currentUser.isAdmin,
      'permissions': {
        'documents': permissions.documents,
        'categories': permissions.categories,
        'system': permissions.system,
      },
      'capabilities': {
        'canPerformUnlimitedQueries': await canPerformUnlimitedQueries(),
        'canAccessStorageManagement': await canAccessStorageManagement(),
        'canManageUsers': await canManageUsers(),
        'canViewAnalytics': await canViewAnalytics(),
        'canUploadFiles': await canUploadFiles(),
        'canDeleteFiles': await canDeleteFiles(),
        'canApproveFiles': await canApproveFiles(),
      },
    };
  }

  /// Refresh current user permissions
  Future<void> refreshCurrentUserPermissions() async {
    final currentUser = await currentUserModel;
    if (currentUser != null) {
      clearUserPermissionCache(currentUser.id);
      clearUserCache(); // Also clear user cache to force refresh
      await _getUserPermissions(currentUser.id);
      debugPrint('🔄 Refreshed permissions for current user');
    }
  }

  /// Check if user has access to specific document
  Future<bool> hasDocumentAccess(String documentId, String action) async {
    final currentUser = await currentUserModel;
    if (currentUser == null) return false;

    // Admin users have access to all documents
    if (currentUser.isAdmin) return true;

    try {
      // Get document to check ownership
      final docSnapshot = await _firebaseService.documentsCollection
          .doc(documentId)
          .get();

      if (!docSnapshot.exists) return false;

      final docData = docSnapshot.data() as Map<String, dynamic>;
      final uploadedBy = docData['uploadedBy'] as String?;

      // Check if user owns the document
      if (uploadedBy == currentUser.id) return true;

      // Check if user has general permission for this action
      return await hasDocumentPermission(action);
    } catch (e) {
      debugPrint('❌ Failed to check document access: $e');
      return false;
    }
  }
}
