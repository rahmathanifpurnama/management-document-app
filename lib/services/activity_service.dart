import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../models/activity_model.dart';
import '../models/activity_factory.dart';
import '../models/activity_types.dart';

class ActivityService {
  static final ActivityService _instance = ActivityService._internal();
  factory ActivityService() => _instance;
  ActivityService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Get activity statistics using Cloud Functions (with fallback)
  Future<Map<String, dynamic>> getActivityStatistics() async {
    try {
      // Try Cloud Function first for better performance
      return await _getActivityStatisticsCloudFunction();
    } catch (e) {
      debugPrint(
        '⚠️ Cloud Function failed, falling back to local processing: $e',
      );
      try {
        // Fallback to local Firestore processing
        return await _getActivityStatisticsLocal();
      } catch (localError) {
        debugPrint('❌ Local processing also failed: $localError');
        // Return default values to prevent app crash
        return {
          'todayCount': 0,
          'weekCount': 0,
          'activeUsers': 0,
          'suspiciousCount': 0,
        };
      }
    }
  }

  /// Get activity statistics using Cloud Functions
  Future<Map<String, dynamic>> _getActivityStatisticsCloudFunction() async {
    try {
      debugPrint('📊 Getting activity statistics via Cloud Function');

      final callable = _functions.httpsCallable('getActivityStatistics');
      final result = await callable.call().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Cloud Function timeout after 10 seconds');
        },
      );

      debugPrint('✅ Activity statistics retrieved via Cloud Function');

      // Safe type casting
      final data = result.data;
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      } else {
        throw Exception('Invalid response format from Cloud Function');
      }
    } catch (e) {
      debugPrint('❌ Error getting activity statistics via Cloud Function: $e');
      rethrow;
    }
  }

  /// Get activity statistics using local Firestore processing (fallback)
  Future<Map<String, dynamic>> _getActivityStatisticsLocal() async {
    try {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final weekStart = now.subtract(Duration(days: now.weekday - 1));

      // Get today's activities count
      final todayQuery = await _firestore
          .collection('activities')
          .where(
            'timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart),
          )
          .get();

      // Get this week's activities count
      final weekQuery = await _firestore
          .collection('activities')
          .where(
            'timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(weekStart),
          )
          .get();

      // Get active users (users who performed activities in the last 24 hours)
      final activeUsersQuery = await _firestore
          .collection('activities')
          .where(
            'timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(
              now.subtract(const Duration(days: 1)),
            ),
          )
          .get();

      final activeUserIds = <String>{};
      for (final doc in activeUsersQuery.docs) {
        final userId = doc.data()['userId'] as String?;
        if (userId != null) {
          activeUserIds.add(userId);
        }
      }

      // Get suspicious activities count (failed logins, multiple rapid actions, etc.)
      // Split query to avoid composite index requirement
      final suspiciousQuery = await _firestore
          .collection('activities')
          .where('isSuspicious', isEqualTo: true)
          .get();

      // Filter by timestamp in memory to avoid composite index
      final suspiciousCount = suspiciousQuery.docs.where((doc) {
        final timestamp = doc.data()['timestamp'] as Timestamp?;
        return timestamp != null && timestamp.toDate().isAfter(weekStart);
      }).length;

      return {
        'todayCount': todayQuery.docs.length,
        'weekCount': weekQuery.docs.length,
        'activeUsers': activeUserIds.length,
        'suspiciousCount': suspiciousCount,
      };
    } catch (e) {
      debugPrint('Error getting activity statistics: $e');
      return {
        'todayCount': 0,
        'weekCount': 0,
        'activeUsers': 0,
        'suspiciousCount': 0,
      };
    }
  }

  /// Get activities with filtering options (returns polymorphic activities)
  Future<List<BaseActivity>> getActivities({
    String filter = 'all',
    String? searchQuery,
    DateTimeRange? dateRange,
    int limit = 50,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      Query query = _firestore.collection('activities');

      // Apply date range filter
      if (dateRange != null) {
        query = query
            .where(
              'timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(dateRange.start),
            )
            .where(
              'timestamp',
              isLessThanOrEqualTo: Timestamp.fromDate(dateRange.end),
            );
      }

      // Apply activity type filter
      if (filter != 'all') {
        switch (filter) {
          case 'login':
            query = query.where('type', whereIn: ['login', 'logout']);
            break;
          case 'file':
            query = query.where(
              'type',
              whereIn: [
                'upload',
                'download',
                'delete',
                'view',
                'file_uploaded',
              ],
            );
            break;
          case 'suspicious':
            query = query.where('isSuspicious', isEqualTo: true);
            break;
          default:
            query = query.where('type', isEqualTo: filter);
        }
      }

      // Order by timestamp (most recent first) first
      query = query.orderBy('timestamp', descending: true);

      // Apply pagination after ordering
      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      // Apply limit
      query = query.limit(limit);

      final querySnapshot = await query.get();
      final activities = <BaseActivity>[];

      for (final doc in querySnapshot.docs) {
        try {
          // Use factory to create polymorphic activity instances
          final activity = ActivityFactory.fromFirestore(doc);

          // Apply search filter if provided
          if (searchQuery != null && searchQuery.isNotEmpty) {
            final searchLower = searchQuery.toLowerCase();
            if (!activity.description.toLowerCase().contains(searchLower) &&
                !(activity.userName?.toLowerCase().contains(searchLower) ??
                    false) &&
                !activity.type.toLowerCase().contains(searchLower)) {
              continue;
            }
          }

          activities.add(activity);
        } catch (e) {
          debugPrint('Error parsing activity document ${doc.id}: $e');
          // Fallback to basic ActivityModel for problematic documents
          try {
            final data = doc.data() as Map<String, dynamic>;
            final fallbackActivity = ActivityModel(
              id: doc.id,
              userId: data['userId'] ?? '',
              type: data['type'] ?? 'unknown',
              description: data['description'] ?? 'Unknown activity',
              timestamp:
                  (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
              userName: data['userName'],
              userEmail: data['userEmail'],
              documentId: data['documentId'],
              categoryId: data['categoryId'],
              isSuspicious: data['isSuspicious'] ?? false,
              ipAddress: data['ipAddress'],
              userAgent: data['userAgent'],
              details: data['details'] is Map
                  ? Map<String, dynamic>.from(data['details'])
                  : {},
            );
            activities.add(fallbackActivity);
          } catch (fallbackError) {
            debugPrint(
              'Failed to create fallback activity for ${doc.id}: $fallbackError',
            );
          }
        }
      }

      return activities;
    } catch (e) {
      debugPrint('Error getting activities: $e');
      return [];
    }
  }

  /// Legacy method for backward compatibility
  Future<List<ActivityModel>> getActivitiesLegacy({
    String filter = 'all',
    String? searchQuery,
    DateTimeRange? dateRange,
    int limit = 50,
    DocumentSnapshot? startAfter,
  }) async {
    final activities = await getActivities(
      filter: filter,
      searchQuery: searchQuery,
      dateRange: dateRange,
      limit: limit,
      startAfter: startAfter,
    );

    // Convert to legacy ActivityModel for backward compatibility
    return activities.map((activity) {
      if (activity is ActivityModel) {
        return activity;
      } else {
        // Convert polymorphic activity to legacy ActivityModel
        return ActivityModel(
          id: activity.id,
          userId: activity.userId,
          type: activity.type,
          description: activity.description,
          timestamp: activity.timestamp,
          userName: activity.userName,
          userEmail: activity.userEmail,
          documentId: activity is FileActivity ? activity.documentId : null,
          categoryId: activity is FileUploadActivity
              ? activity.categoryId
              : null,
          isSuspicious: activity.isSuspicious,
          ipAddress: activity.ipAddress,
          userAgent: activity.userAgent,
          details: activity.details,
        );
      }
    }).toList();
  }

  /// Get filtered activities using Cloud Functions (with fallback)
  Future<Map<String, dynamic>> getFilteredActivities({
    String filter = 'all',
    String? searchQuery,
    DateTimeRange? dateRange,
    int limit = 50,
    String? startAfterTimestamp,
  }) async {
    try {
      // Try Cloud Function first for better performance
      return await _getFilteredActivitiesCloudFunction(
        filter: filter,
        searchQuery: searchQuery,
        dateRange: dateRange,
        limit: limit,
        startAfterTimestamp: startAfterTimestamp,
      );
    } catch (e) {
      debugPrint(
        '⚠️ Cloud Function failed, falling back to local processing: $e',
      );
      try {
        // Fallback to local Firestore processing
        return await _getFilteredActivitiesLocal(
          filter: filter,
          searchQuery: searchQuery,
          dateRange: dateRange,
          limit: limit,
          startAfterTimestamp: startAfterTimestamp,
        );
      } catch (localError) {
        debugPrint('❌ Local processing also failed: $localError');
        // Return empty result to prevent app crash
        return {
          'activities': <Map<String, dynamic>>[],
          'hasMore': false,
          'lastTimestamp': null,
        };
      }
    }
  }

  /// Get filtered activities using Cloud Functions
  Future<Map<String, dynamic>> _getFilteredActivitiesCloudFunction({
    String filter = 'all',
    String? searchQuery,
    DateTimeRange? dateRange,
    int limit = 50,
    String? startAfterTimestamp,
  }) async {
    try {
      debugPrint('🔍 Getting filtered activities via Cloud Function');

      final callable = _functions.httpsCallable('getFilteredActivities');
      final result = await callable.call({
        'filter': filter,
        'searchQuery': searchQuery,
        'dateRange': dateRange != null
            ? {
                'start': dateRange.start.toIso8601String(),
                'end': dateRange.end.toIso8601String(),
              }
            : null,
        'limit': limit,
        'startAfterTimestamp': startAfterTimestamp,
      });

      debugPrint('✅ Filtered activities retrieved via Cloud Function');

      // Safe type casting
      final data = result.data;
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      } else {
        throw Exception('Invalid response format from Cloud Function');
      }
    } catch (e) {
      debugPrint('❌ Error getting filtered activities via Cloud Function: $e');
      rethrow;
    }
  }

  /// Get filtered activities using local Firestore processing (fallback)
  Future<Map<String, dynamic>> _getFilteredActivitiesLocal({
    String filter = 'all',
    String? searchQuery,
    DateTimeRange? dateRange,
    int limit = 50,
    String? startAfterTimestamp,
  }) async {
    try {
      // Use existing getActivities method for local processing
      DocumentSnapshot? startAfter;
      if (startAfterTimestamp != null) {
        // Find document by timestamp for pagination
        final timestampQuery = await _firestore
            .collection('activities')
            .where(
              'timestamp',
              isEqualTo: Timestamp.fromDate(
                DateTime.parse(startAfterTimestamp),
              ),
            )
            .limit(1)
            .get();

        if (timestampQuery.docs.isNotEmpty) {
          startAfter = timestampQuery.docs.first;
        }
      }

      final activities = await getActivities(
        filter: filter,
        searchQuery: searchQuery,
        dateRange: dateRange,
        limit: limit,
        startAfter: startAfter,
      );

      // Convert BaseActivity list to Map format for consistency with Cloud Function
      final activitiesData = activities
          .map(
            (activity) => {
              'id': activity.id,
              'userId': activity.userId,
              'type': activity.type,
              'description': activity.description,
              'timestamp': activity.timestamp.toIso8601String(),
              'userName': activity.userName,
              'userEmail': activity.userEmail,
              'documentId': activity is FileActivity
                  ? activity.documentId
                  : activity is ActivityModel
                  ? activity.documentId
                  : null,
              'categoryId': activity is FileUploadActivity
                  ? activity.categoryId
                  : activity is ActivityModel
                  ? activity.categoryId
                  : null,
              'isSuspicious': activity.isSuspicious,
              'ipAddress': activity.ipAddress,
              'userAgent': activity.userAgent,
              'details': activity.details,
            },
          )
          .toList();

      return {
        'activities': activitiesData,
        'hasMore': activities.length == limit,
        'lastTimestamp': activities.isNotEmpty
            ? activities.last.timestamp.toIso8601String()
            : null,
      };
    } catch (e) {
      debugPrint('Error getting filtered activities locally: $e');
      return {
        'activities': <Map<String, dynamic>>[],
        'hasMore': false,
        'lastTimestamp': null,
      };
    }
  }

  /// Log a new activity
  Future<void> logActivity({
    required String type,
    required String description,
    String? documentId,
    String? categoryId,
    Map<String, dynamic>? additionalData,
    bool isSuspicious = false,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      // Get user information
      String? userName;
      try {
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          final userData = userDoc.data();
          userName =
              userData?['name'] as String? ?? userData?['email'] as String?;
        }
      } catch (e) {
        debugPrint('Error getting user info for activity log: $e');
      }

      final activityData = {
        'type': type,
        'description': description,
        'userId': user.uid,
        'userName': userName ?? user.email ?? 'Unknown User',
        'userEmail': user.email,
        'timestamp': FieldValue.serverTimestamp(),
        'isSuspicious': isSuspicious,
        'ipAddress': null, // Would need additional setup to capture IP
        'userAgent': null, // Would need additional setup to capture user agent
      };

      // Add optional fields
      if (documentId != null) {
        activityData['documentId'] = documentId;
      }
      if (categoryId != null) {
        activityData['categoryId'] = categoryId;
      }
      if (additionalData != null) {
        activityData.addAll(additionalData);
      }

      await _firestore.collection('activities').add(activityData);

      debugPrint('Activity logged: $type - $description');
    } catch (e) {
      debugPrint('Error logging activity: $e');
    }
  }

  /// Lock a user account
  Future<bool> lockUserAccount(String userId, String reason) async {
    try {
      // Update user document to set locked status
      await _firestore.collection('users').doc(userId).update({
        'isLocked': true,
        'lockedAt': FieldValue.serverTimestamp(),
        'lockedReason': reason,
        'lockedBy': _auth.currentUser?.uid,
      });

      // Log the account lock activity
      await logActivity(
        type: 'account_lock',
        description: 'User account locked: $reason',
        additionalData: {'targetUserId': userId, 'reason': reason},
      );

      return true;
    } catch (e) {
      debugPrint('Error locking user account: $e');
      return false;
    }
  }

  /// Unlock a user account
  Future<bool> unlockUserAccount(String userId) async {
    try {
      // Update user document to remove locked status
      await _firestore.collection('users').doc(userId).update({
        'isLocked': false,
        'unlockedAt': FieldValue.serverTimestamp(),
        'unlockedBy': _auth.currentUser?.uid,
        'lockedReason': FieldValue.delete(),
      });

      // Log the account unlock activity
      await logActivity(
        type: 'account_unlock',
        description: 'User account unlocked',
        additionalData: {'targetUserId': userId},
      );

      return true;
    } catch (e) {
      debugPrint('Error unlocking user account: $e');
      return false;
    }
  }

  /// Get user activities for a specific user
  Future<List<ActivityModel>> getUserActivities(
    String userId, {
    int limit = 20,
  }) async {
    try {
      final query = await _firestore
          .collection('activities')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return query.docs.map((doc) => ActivityModel.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('Error getting user activities: $e');
      return [];
    }
  }

  /// Check for suspicious activity patterns
  Future<bool> checkSuspiciousActivity(String userId) async {
    try {
      final now = DateTime.now();
      final oneHourAgo = now.subtract(const Duration(hours: 1));

      // Check for rapid successive activities (more than 20 in an hour)
      final recentActivities = await _firestore
          .collection('activities')
          .where('userId', isEqualTo: userId)
          .where(
            'timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(oneHourAgo),
          )
          .get();

      if (recentActivities.docs.length > 20) {
        // Log suspicious activity
        await logActivity(
          type: 'suspicious_activity',
          description: 'Rapid successive activities detected',
          isSuspicious: true,
          additionalData: {
            'activityCount': recentActivities.docs.length,
            'timeWindow': '1 hour',
          },
        );
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error checking suspicious activity: $e');
      return false;
    }
  }

  /// Delete old activities (cleanup)
  Future<void> cleanupOldActivities({int daysToKeep = 90}) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));

      final oldActivities = await _firestore
          .collection('activities')
          .where('timestamp', isLessThan: Timestamp.fromDate(cutoffDate))
          .get();

      final batch = _firestore.batch();
      for (final doc in oldActivities.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      debugPrint('Cleaned up ${oldActivities.docs.length} old activities');
    } catch (e) {
      debugPrint('Error cleaning up old activities: $e');
    }
  }
}
