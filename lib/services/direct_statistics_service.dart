import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../core/services/firebase_service.dart';

/// Direct Statistics Service
/// Performs real-time queries to Firebase collections without caching
/// Ensures statistics always reflect current database state
class DirectStatisticsService {
  static final DirectStatisticsService _instance = DirectStatisticsService._internal();
  static DirectStatisticsService get instance => _instance;
  DirectStatisticsService._internal();

  final FirebaseService _firebaseService = FirebaseService.instance;

  /// Get real-time category statistics directly from Firestore
  Future<Map<String, dynamic>> getCategoryStatistics() async {
    try {
      debugPrint('📊 DirectStatisticsService: Getting category statistics...');
      
      final firestore = _firebaseService.firestore;
      
      // Direct count query to categories collection
      final categoriesCountResult = await firestore
          .collection('categories')
          .count()
          .get();
      
      final totalCategories = categoriesCountResult.count ?? 0;
      
      // Get active categories count
      final activeCategoriesResult = await firestore
          .collection('categories')
          .where('isActive', isEqualTo: true)
          .count()
          .get();
      
      final activeCategories = activeCategoriesResult.count ?? 0;
      
      debugPrint('📊 Category Statistics: Total=$totalCategories, Active=$activeCategories');
      
      return {
        'totalCategories': totalCategories,
        'activeCategories': activeCategories,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('❌ DirectStatisticsService: Error getting category statistics - $e');
      return {
        'totalCategories': 0,
        'activeCategories': 0,
        'error': e.toString(),
        'lastUpdated': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Get real-time user statistics from both Firestore and Firebase Authentication
  Future<Map<String, dynamic>> getUserStatistics() async {
    try {
      debugPrint('📊 DirectStatisticsService: Getting user statistics...');
      
      final firestore = _firebaseService.firestore;
      final auth = _firebaseService.auth;
      
      // Direct count query to users collection (Firestore users)
      final usersCountResult = await firestore
          .collection('users')
          .count()
          .get();
      
      final totalUsers = usersCountResult.count ?? 0;
      
      // Get active users count
      final activeUsersResult = await firestore
          .collection('users')
          .where('isActive', isEqualTo: true)
          .count()
          .get();
      
      final activeUsers = activeUsersResult.count ?? 0;
      
      // Get admin users count
      final adminUsersResult = await firestore
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .count()
          .get();
      
      final adminUsers = adminUsersResult.count ?? 0;
      
      // Get current authenticated user info for debugging
      final currentUser = auth.currentUser;
      final currentUserEmail = currentUser?.email ?? 'Not authenticated';
      
      debugPrint(
        '📊 User Statistics: Total=$totalUsers, Active=$activeUsers, Admin=$adminUsers',
      );
      debugPrint('📊 Current Auth User: $currentUserEmail');
      
      return {
        'totalUsers': totalUsers,
        'activeUsers': activeUsers,
        'adminUsers': adminUsers,
        'regularUsers': totalUsers - adminUsers,
        'currentAuthUser': currentUserEmail,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint(
        '❌ DirectStatisticsService: Error getting user statistics - $e',
      );
      return {
        'totalUsers': 0,
        'activeUsers': 0,
        'adminUsers': 0,
        'regularUsers': 0,
        'error': e.toString(),
        'lastUpdated': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Get real-time file statistics directly from document-metadata collection
  Future<Map<String, dynamic>> getFileStatistics() async {
    try {
      debugPrint('📊 DirectStatisticsService: Getting file statistics...');
      
      final firestore = _firebaseService.firestore;
      
      // Direct count query to document-metadata collection
      final filesCountResult = await firestore
          .collection('document-metadata')
          .count()
          .get();
      
      final totalFiles = filesCountResult.count ?? 0;
      
      // Get active files count
      final activeFilesResult = await firestore
          .collection('document-metadata')
          .where('isActive', isEqualTo: true)
          .count()
          .get();
      
      final activeFiles = activeFilesResult.count ?? 0;
      
      debugPrint('📊 File Statistics: Total=$totalFiles, Active=$activeFiles');
      
      return {
        'totalFiles': totalFiles,
        'activeFiles': activeFiles,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('❌ DirectStatisticsService: Error getting file statistics - $e');
      return {
        'totalFiles': 0,
        'activeFiles': 0,
        'error': e.toString(),
        'lastUpdated': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Get all statistics in one call for dashboard
  Future<Map<String, dynamic>> getAllStatistics() async {
    try {
      debugPrint('📊 DirectStatisticsService: Getting all statistics...');
      
      final startTime = DateTime.now();
      
      // Execute all queries in parallel for better performance
      final results = await Future.wait([
        getCategoryStatistics(),
        getUserStatistics(),
        getFileStatistics(),
      ]);
      
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;
      
      final categoryStats = results[0];
      final userStats = results[1];
      final fileStats = results[2];
      
      final allStats = {
        'categories': categoryStats,
        'users': userStats,
        'files': fileStats,
        'performance': {
          'queryDurationMs': duration,
          'timestamp': DateTime.now().toIso8601String(),
        },
      };
      
      debugPrint('📊 All statistics retrieved in ${duration}ms');
      return allStats;
    } catch (e) {
      debugPrint(
        '❌ DirectStatisticsService: Error getting all statistics - $e',
      );
      return {
        'categories': {'totalCategories': 0, 'activeCategories': 0},
        'users': {
          'totalUsers': 0,
          'activeUsers': 0,
          'adminUsers': 0,
          'regularUsers': 0,
        },
        'files': {'totalFiles': 0, 'activeFiles': 0},
        'error': e.toString(),
        'performance': {
          'queryDurationMs': 0,
          'timestamp': DateTime.now().toIso8601String(),
        },
      };
    }
  }

  /// Diagnostic method to help identify Firebase Auth vs Firestore sync issues
  /// This method provides detailed information about user synchronization
  Future<Map<String, dynamic>> getUserSyncDiagnostics() async {
    try {
      debugPrint(
        '🔍 DirectStatisticsService: Running user sync diagnostics...',
      );

      final firestore = _firebaseService.firestore;
      final auth = _firebaseService.auth;

      // Get current Firebase Auth user
      final currentAuthUser = auth.currentUser;

      // Get all Firestore users
      final firestoreUsersSnapshot = await firestore.collection('users').get();

      final firestoreUsers = firestoreUsersSnapshot.docs;
      final firestoreUserIds = firestoreUsers.map((doc) => doc.id).toList();

      // Diagnostic information
      final diagnostics = {
        'currentAuthUser': {
          'uid': currentAuthUser?.uid ?? 'Not authenticated',
          'email': currentAuthUser?.email ?? 'No email',
          'emailVerified': currentAuthUser?.emailVerified ?? false,
          'creationTime':
              currentAuthUser?.metadata.creationTime?.toIso8601String() ??
              'Unknown',
        },
        'firestoreUsers': {
          'totalCount': firestoreUsers.length,
          'userIds': firestoreUserIds,
          'userEmails': firestoreUsers.map((doc) {
            final data = doc.data();
            return data['email'] ?? 'No email';
          }).toList(),
        },
        'syncStatus': {
          'currentUserInFirestore': currentAuthUser != null
              ? firestoreUserIds.contains(currentAuthUser.uid)
              : false,
          'potentialSyncIssue':
              firestoreUsers.length < 2, // Assuming there should be more users
        },
        'recommendations': _generateSyncRecommendations(
          currentAuthUser,
          firestoreUsers.length,
          firestoreUserIds,
        ),
        'timestamp': DateTime.now().toIso8601String(),
      };

      debugPrint('🔍 User Sync Diagnostics: ${diagnostics['syncStatus']}');
      return diagnostics;
    } catch (e) {
      debugPrint(
        '❌ DirectStatisticsService: Error in user sync diagnostics - $e',
      );
      return {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  List<String> _generateSyncRecommendations(
    User? currentAuthUser,
    int firestoreUserCount,
    List<String> firestoreUserIds,
  ) {
    final recommendations = <String>[];

    if (currentAuthUser == null) {
      recommendations.add('User is not authenticated - please log in');
    } else if (!firestoreUserIds.contains(currentAuthUser.uid)) {
      recommendations.add(
        'Current user missing from Firestore - sync required',
      );
      recommendations.add('Check user registration process');
    }

    if (firestoreUserCount < 2) {
      recommendations.add(
        'Very few users in Firestore - check if Firebase Auth users were properly synced',
      );
      recommendations.add('Consider running user sync operation');
    }

    if (recommendations.isEmpty) {
      recommendations.add('User sync appears to be working correctly');
    }

    return recommendations;
  }
}
