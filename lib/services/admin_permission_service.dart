import 'package:flutter/foundation.dart';
import '../core/services/firebase_service.dart';
import '../core/utils/anr_prevention.dart';

/// Service to handle admin permission checks on client-side
/// This replaces Firebase Storage rules admin checks to prevent ANR
class AdminPermissionService {
  static AdminPermissionService? _instance;
  static AdminPermissionService get instance =>
      _instance ??= AdminPermissionService._();

  AdminPermissionService._();

  final FirebaseService _firebaseService = FirebaseService.instance;

  // Cache admin status to prevent repeated Firestore queries
  final Map<String, bool> _adminCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheExpiry = Duration(minutes: 15);

  /// Check if current user is admin with caching
  Future<bool> isCurrentUserAdmin() async {
    final currentUser = _firebaseService.auth.currentUser;
    if (currentUser == null) return false;

    return isUserAdmin(currentUser.uid);
  }

  /// Check if specific user is admin with caching
  Future<bool> isUserAdmin(String userId) async {
    try {
      // Check cache first
      if (_isAdminCacheValid(userId)) {
        final cachedResult = _adminCache[userId] ?? false;
        debugPrint('📋 Admin status from cache for $userId: $cachedResult');
        return cachedResult;
      }

      // Query Firestore with timeout to prevent ANR
      final isAdmin = await ANRPrevention.executeWithTimeout(
        _queryUserAdminStatus(userId),
        timeout: const Duration(seconds: 5),
        operationName: 'Admin Status Check',
      );

      final result = isAdmin ?? false;

      // Cache the result
      _adminCache[userId] = result;
      _cacheTimestamps[userId] = DateTime.now();

      debugPrint('✅ Admin status for $userId: $result');
      return result;
    } catch (e) {
      debugPrint('❌ Failed to check admin status for $userId: $e');
      // Return cached value if available, otherwise false
      return _adminCache[userId] ?? false;
    }
  }

  /// Query user admin status from Firestore
  Future<bool> _queryUserAdminStatus(String userId) async {
    try {
      final userDoc = await _firebaseService.usersCollection.doc(userId).get();

      if (!userDoc.exists) {
        debugPrint('⚠️ User document not found: $userId');
        return false;
      }

      final userData = userDoc.data() as Map<String, dynamic>?;
      final role = userData?['role'] as String?;

      return role == 'admin';
    } catch (e) {
      debugPrint('❌ Error querying user admin status: $e');
      return false;
    }
  }

  /// Check if admin cache is valid for user
  bool _isAdminCacheValid(String userId) {
    final timestamp = _cacheTimestamps[userId];
    if (timestamp == null) return false;

    final now = DateTime.now();
    return now.difference(timestamp) < _cacheExpiry;
  }

  /// Check if user can delete file (owner or admin)
  Future<bool> canDeleteFile(String fileOwnerId) async {
    final currentUser = _firebaseService.auth.currentUser;
    if (currentUser == null) return false;

    // Owner can always delete
    if (currentUser.uid == fileOwnerId) return true;

    // Check if current user is admin
    return await isCurrentUserAdmin();
  }

  /// Check if user can update file (owner or admin)
  Future<bool> canUpdateFile(String fileOwnerId) async {
    final currentUser = _firebaseService.auth.currentUser;
    if (currentUser == null) return false;

    // Owner can always update
    if (currentUser.uid == fileOwnerId) return true;

    // Check if current user is admin
    return await isCurrentUserAdmin();
  }

  /// Check if user can manage categories (admin only)
  Future<bool> canManageCategories() async {
    return await isCurrentUserAdmin();
  }

  /// Check if user can manage users (admin only)
  Future<bool> canManageUsers() async {
    return await isCurrentUserAdmin();
  }

  /// Check if user can view all files (admin only)
  Future<bool> canViewAllFiles() async {
    return await isCurrentUserAdmin();
  }

  /// Batch check admin status for multiple users
  Future<Map<String, bool>> batchCheckAdminStatus(List<String> userIds) async {
    final results = <String, bool>{};

    // Separate cached and uncached users
    final uncachedUsers = <String>[];
    for (final userId in userIds) {
      if (_isAdminCacheValid(userId)) {
        results[userId] = _adminCache[userId] ?? false;
      } else {
        uncachedUsers.add(userId);
      }
    }

    // Query uncached users in batches to prevent ANR
    if (uncachedUsers.isNotEmpty) {
      final batchResults = await ANRPrevention.batchProcess(
        uncachedUsers,
        (userId) async {
          final isAdmin = await _queryUserAdminStatus(userId);
          _adminCache[userId] = isAdmin;
          _cacheTimestamps[userId] = DateTime.now();
          return MapEntry(userId, isAdmin);
        },
        batchSize: 5, // Small batch size for admin checks
        operationName: 'Batch Admin Status Check',
      );

      for (final entry in batchResults) {
        results[entry.key] = entry.value;
      }
    }

    return results;
  }

  /// Clear admin cache for specific user
  void clearAdminCache(String userId) {
    _adminCache.remove(userId);
    _cacheTimestamps.remove(userId);
    debugPrint('🧹 Cleared admin cache for $userId');
  }

  /// Clear all admin cache
  void clearAllAdminCache() {
    _adminCache.clear();
    _cacheTimestamps.clear();
    debugPrint('🧹 Cleared all admin cache');
  }

  /// Refresh admin status for current user
  Future<bool> refreshCurrentUserAdminStatus() async {
    final currentUser = _firebaseService.auth.currentUser;
    if (currentUser == null) return false;

    clearAdminCache(currentUser.uid);
    return await isCurrentUserAdmin();
  }

  /// Get admin cache statistics
  Map<String, dynamic> getAdminCacheStats() {
    final now = DateTime.now();
    int validEntries = 0;
    int expiredEntries = 0;

    for (final entry in _cacheTimestamps.entries) {
      if (now.difference(entry.value) < _cacheExpiry) {
        validEntries++;
      } else {
        expiredEntries++;
      }
    }

    return {
      'totalEntries': _adminCache.length,
      'validEntries': validEntries,
      'expiredEntries': expiredEntries,
      'cacheHitRate': _adminCache.isNotEmpty
          ? '${(validEntries / _adminCache.length * 100).toStringAsFixed(1)}%'
          : '0%',
    };
  }

  /// Clean up expired cache entries
  void cleanupExpiredCache() {
    final now = DateTime.now();
    final expiredUsers = <String>[];

    for (final entry in _cacheTimestamps.entries) {
      if (now.difference(entry.value) >= _cacheExpiry) {
        expiredUsers.add(entry.key);
      }
    }

    for (final userId in expiredUsers) {
      _adminCache.remove(userId);
      _cacheTimestamps.remove(userId);
    }

    if (expiredUsers.isNotEmpty) {
      debugPrint(
        '🧹 Cleaned up ${expiredUsers.length} expired admin cache entries',
      );
    }
  }

  /// Dispose and cleanup
  void dispose() {
    clearAllAdminCache();
    debugPrint('🧹 AdminPermissionService disposed');
  }
}
