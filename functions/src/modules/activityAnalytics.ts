import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";

const db = admin.firestore();

/**
 * Get aggregated activity statistics for dashboard
 * Returns statistics for today, this week, active users, and suspicious activities
 */
export const getActivityStatistics = functions.https.onCall(
  async (data: any, context: functions.https.CallableContext) => {
    // Verify authentication
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'User must be authenticated to access activity statistics.'
      );
    }

    try {
      const now = new Date();
      const todayStart = new Date(now.getFullYear(), now.getMonth(), now.getDate());
      const weekStart = new Date(now.getTime() - (now.getDay() * 24 * 60 * 60 * 1000));
      const dayAgo = new Date(now.getTime() - (24 * 60 * 60 * 1000));

      console.log('📊 Getting activity statistics for user:', context.auth.uid);

      // Get today's activities count
      const todayQuery = await db
        .collection('activities')
        .where('timestamp', '>=', admin.firestore.Timestamp.fromDate(todayStart))
        .get();

      // Get this week's activities count
      const weekQuery = await db
        .collection('activities')
        .where('timestamp', '>=', admin.firestore.Timestamp.fromDate(weekStart))
        .get();

      // Get active users (users who performed activities in the last 24 hours)
      const activeUsersQuery = await db
        .collection('activities')
        .where('timestamp', '>=', admin.firestore.Timestamp.fromDate(dayAgo))
        .get();

      const activeUserIds = new Set<string>();
      activeUsersQuery.docs.forEach(doc => {
        const userId = doc.data().userId;
        if (userId) {
          activeUserIds.add(userId);
        }
      });

      // Get suspicious activities count (last week)
      const suspiciousQuery = await db
        .collection('activities')
        .where('isSuspicious', '==', true)
        .where('timestamp', '>=', admin.firestore.Timestamp.fromDate(weekStart))
        .get();

      const statistics = {
        todayCount: todayQuery.size,
        weekCount: weekQuery.size,
        activeUsers: activeUserIds.size,
        suspiciousCount: suspiciousQuery.size,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      };

      console.log('📈 Activity statistics calculated:', statistics);
      return statistics;

    } catch (error) {
      console.error('❌ Error getting activity statistics:', error);
      throw new functions.https.HttpsError(
        'internal',
        'Failed to get activity statistics',
        error
      );
    }
  }
);

/**
 * Get filtered activities with pagination and search
 * Supports filtering by type, date range, search query, and pagination
 */
export const getFilteredActivities = functions.https.onCall(
  async (data: any, context: functions.https.CallableContext) => {
    // Verify authentication
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'User must be authenticated to access activities.'
      );
    }

    try {
      const {
        filter = 'all',
        searchQuery,
        dateRange,
        limit = 50,
        startAfterTimestamp,
      } = data;

      console.log('🔍 Getting filtered activities with params:', {
        filter,
        searchQuery,
        dateRange,
        limit,
        startAfterTimestamp,
      });

      let query: admin.firestore.Query = db.collection('activities');

      // Apply date range filter
      if (dateRange && dateRange.start && dateRange.end) {
        const startDate = admin.firestore.Timestamp.fromDate(new Date(dateRange.start));
        const endDate = admin.firestore.Timestamp.fromDate(new Date(dateRange.end));
        
        query = query
          .where('timestamp', '>=', startDate)
          .where('timestamp', '<=', endDate);
      }

      // Apply activity type filter
      if (filter !== 'all') {
        switch (filter) {
          case 'login':
            query = query.where('type', 'in', ['login', 'logout']);
            break;
          case 'file':
            query = query.where('type', 'in', ['upload', 'download', 'delete', 'view']);
            break;
          case 'suspicious':
            query = query.where('isSuspicious', '==', true);
            break;
          default:
            query = query.where('type', '==', filter);
        }
      }

      // Order by timestamp (most recent first) first
      query = query.orderBy('timestamp', 'desc');

      // Apply pagination after ordering
      if (startAfterTimestamp) {
        const startAfterDate = admin.firestore.Timestamp.fromDate(new Date(startAfterTimestamp));
        query = query.startAfter(startAfterDate);
      }

      // Apply limit
      query = query.limit(Math.min(limit, 100)); // Cap at 100

      const querySnapshot = await query.get();
      const activities: any[] = [];

      querySnapshot.docs.forEach(doc => {
        try {
          const data = doc.data();
          const activity = {
            id: doc.id,
            userId: data.userId || '',
            type: data.type || data.action || '',
            description: data.description || data.resource || '',
            timestamp: data.timestamp?.toDate?.()?.toISOString() || new Date().toISOString(),
            userName: data.userName,
            userEmail: data.userEmail,
            documentId: data.documentId,
            categoryId: data.categoryId,
            isSuspicious: data.isSuspicious || false,
            ipAddress: data.ipAddress,
            userAgent: data.userAgent,
            details: data.details || {},
          };

          // Apply search filter if provided
          if (searchQuery && searchQuery.trim()) {
            const searchLower = searchQuery.toLowerCase();
            const matchesSearch = 
              activity.description.toLowerCase().includes(searchLower) ||
              (activity.userName && activity.userName.toLowerCase().includes(searchLower)) ||
              activity.type.toLowerCase().includes(searchLower);
            
            if (!matchesSearch) {
              return; // Skip this activity
            }
          }

          activities.push(activity);
        } catch (error) {
          console.error('Error parsing activity document:', doc.id, error);
        }
      });

      const result = {
        activities,
        hasMore: querySnapshot.size === limit,
        lastTimestamp: activities.length > 0 ? activities[activities.length - 1].timestamp : null,
      };

      console.log(`📋 Retrieved ${activities.length} filtered activities`);
      return result;

    } catch (error) {
      console.error('❌ Error getting filtered activities:', error);
      throw new functions.https.HttpsError(
        'internal',
        'Failed to get filtered activities',
        error
      );
    }
  }
);
