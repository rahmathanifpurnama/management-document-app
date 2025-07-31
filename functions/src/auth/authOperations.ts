import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";
import { logger } from "firebase-functions";

// Initialize Firebase Admin if not already initialized
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

// ✅ CLEANUP: Removed handlePostLoginOperations Cloud Function
// This is now handled by direct ActivityService calls in AuthService

/**
 * Update user's last login timestamp
 */
async function updateLastLogin(userId: string): Promise<void> {
  try {
    await db.collection("users").doc(userId).update({
      lastLogin: admin.firestore.FieldValue.serverTimestamp(),
      lastActiveAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    logger.info(`Updated last login for user: ${userId}`);
  } catch (error) {
    logger.error(`Failed to update last login for user ${userId}:`, error);
    // Don't throw - this is non-critical
  }
}

// ✅ CLEANUP: Removed logLoginActivity function
// This is now handled by direct ActivityService calls in AuthService

/**
 * Update user statistics
 */
async function updateUserStats(userId: string): Promise<void> {
  try {
    const userRef = db.collection("users").doc(userId);

    await db.runTransaction(async (transaction) => {
      const userDoc = await transaction.get(userRef);

      if (userDoc.exists) {
        const userData = userDoc.data();
        const currentLoginCount = userData?.loginCount || 0;

        transaction.update(userRef, {
          loginCount: currentLoginCount + 1,
          lastStatsUpdate: admin.firestore.FieldValue.serverTimestamp(),
        });
      }
    });

    logger.info(`Updated user stats for user: ${userId}`);
  } catch (error) {
    logger.error(`Failed to update user stats for user ${userId}:`, error);
    // Don't throw - this is non-critical
  }
}

// ✅ CLEANUP: Removed handleLogoutOperations Cloud Function
// This is now handled by direct ActivityService calls in AuthService

// ✅ CLEANUP: Removed logLogoutActivity function
// This is now handled by direct ActivityService calls in AuthService

/**
 * Cloud Function to validate user session
 * This can be called periodically to ensure user is still active
 */
export const validateUserSession = functions.https.onCall(
  async (data: any, context) => {
    try {
      if (!context.auth) {
        throw new functions.https.HttpsError(
          "unauthenticated",
          "User must be authenticated to validate session."
        );
      }

      const { userId } = data;
      const uid = context.auth.uid;

      // Ensure user can only validate their own session
      if (userId !== uid) {
        throw new functions.https.HttpsError(
          "permission-denied",
          "User can only validate their own session."
        );
      }

      // Get user data from Firestore
      const userDoc = await db.collection("users").doc(userId).get();

      if (!userDoc.exists) {
        throw new functions.https.HttpsError(
          "not-found",
          "User data not found in database."
        );
      }

      const userData = userDoc.data();

      // Check if user is active
      if (!userData?.isActive) {
        throw new functions.https.HttpsError(
          "permission-denied",
          "User account is not active."
        );
      }

      return {
        success: true,
        user: {
          id: userDoc.id,
          email: userData.email,
          fullName: userData.fullName,
          role: userData.role,
          isActive: userData.isActive,
          lastLogin: userData.lastLogin,
        },
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      };
    } catch (error) {
      logger.error("Error validating user session:", error);
      throw error;
    }
  }
);

/**
 * Enhanced activity logging Cloud Function
 * Centralizes all activity logging with server-side validation
 */
export const logActivity = functions.https.onCall(
  async (data: any, context) => {
    try {
      // Verify authentication
      if (!context.auth) {
        throw new functions.https.HttpsError(
          "unauthenticated",
          "User must be authenticated to log activities."
        );
      }

      const { type, description, documentId, categoryId, additionalData, isSuspicious = false } = data;

      if (!type || !description) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "Missing required parameters: type and description are required."
        );
      }

      const userId = context.auth.uid;

      logger.info(`Logging activity - Type: ${type}, User: ${userId}`);

      // Filter out system-generated activity types
      const userInitiatedTypes = [
        'login', 'logout', 'upload', 'download', 'delete', 'view', 'create', 'edit', 'update',
        'password_change', 'profile_update', 'category_create', 'category_update', 'category_delete'
      ];

      if (!userInitiatedTypes.includes(type)) {
        logger.warn(`Skipping system-generated activity type: ${type}`);
        return { success: true, message: "System-generated activity type skipped" };
      }

      // Get user information for enhanced logging
      let userName: string | null = null;
      let userRole: string | null = null;
      let userEmail: string | null = null;

      try {
        const userDoc = await db.collection("users").doc(userId).get();
        if (userDoc.exists) {
          const userData = userDoc.data();

          // Try multiple field names for user name
          userName = userData?.fullName || userData?.name || userData?.displayName || userData?.email;
          userRole = userData?.role;
          userEmail = userData?.email;
        } else {
          // Fallback to Firebase Auth user data
          try {
            const authUser = await admin.auth().getUser(userId);
            userEmail = authUser.email || null;
            userName = authUser.displayName || authUser.email || null;
          } catch (authError) {
            logger.error(`Failed to get Auth user data for activity ${userId}:`, authError);
          }
        }
      } catch (error) {
        logger.error(`Error getting user info for activity log: ${error}`);
      }

      const activityData: any = {
        type: type,
        description: description,
        userId: userId,
        userName: userName || userEmail || "Unknown User",
        userEmail: userEmail,
        userRole: userRole || "user",
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        isSuspicious: isSuspicious,
        ipAddress: null, // Could be enhanced with request IP
        userAgent: null, // Could be enhanced with request headers
        details: {
          source: "server-side",
          ...additionalData,
        },
      };

      // Add optional fields
      if (documentId) {
        activityData.documentId = documentId;
      }
      if (categoryId) {
        activityData.categoryId = categoryId;
      }

      await db.collection("activities").add(activityData);

      logger.info(`Activity logged successfully - Type: ${type}, User: ${userName}, Description: ${description}`);

      return {
        success: true,
        message: "Activity logged successfully",
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      };
    } catch (error) {
      logger.error("Error logging activity:", error);
      throw new functions.https.HttpsError("internal", `Failed to log activity: ${error}`);
    }
  }
);
