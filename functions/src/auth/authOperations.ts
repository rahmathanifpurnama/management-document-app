import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";
import { logger } from "firebase-functions";

// Initialize Firebase Admin if not already initialized
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

/**
 * Cloud Function to handle post-login operations
 * This reduces ANR risk by moving heavy operations to the backend
 */
export const handlePostLoginOperations = functions.https.onCall(
  async (data: any, context) => {
    try {
      // Verify authentication
      if (!context.auth) {
        throw new functions.https.HttpsError(
          "unauthenticated",
          "User must be authenticated to perform this operation."
        );
      }

      const { userId, email, deviceInfo } = data;

      if (!userId || !email) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "Missing required parameters: userId and email are required."
        );
      }

      logger.info(`Processing post-login operations for user: ${userId}`);

      // Execute operations in parallel for better performance
      const operations = [
        updateLastLogin(userId),
        logLoginActivity(userId, deviceInfo),
        updateUserStats(userId),
      ];

      // Execute all operations concurrently
      await Promise.allSettled(operations);

      logger.info(`Post-login operations completed for user: ${userId}`);

      return {
        success: true,
        message: "Post-login operations completed successfully",
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      };
    } catch (error) {
      logger.error("Error in post-login operations:", error);

      // Don't throw error for non-critical operations
      // Return success to prevent login failure
      return {
        success: true,
        message: "Login successful, some background operations may have failed",
        error: error instanceof Error ? error.message : "Unknown error",
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      };
    }
  }
);

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

/**
 * Log user login activity
 */
async function logLoginActivity(
  userId: string,
  deviceInfo?: any
): Promise<void> {
  try {
    await db.collection("activities").add({
      type: "login",
      userId: userId,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      description: "User Login",
      details: {
        userAgent: deviceInfo?.userAgent || "Unknown",
        platform: deviceInfo?.platform || "Unknown",
        ipAddress: deviceInfo?.ipAddress,
      },
    });

    logger.info(`Login activity logged for user: ${userId}`);
  } catch (error) {
    logger.error(`Failed to log login activity for user ${userId}:`, error);
    // Don't throw - this is non-critical
  }
}

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

/**
 * Cloud Function to handle logout operations
 */
export const handleLogoutOperations = functions.https.onCall(
  async (data: any, context) => {
    try {
      // Verify authentication
      if (!context.auth) {
        throw new functions.https.HttpsError(
          "unauthenticated",
          "User must be authenticated to perform this operation."
        );
      }

      const { userId, deviceInfo } = data;

      if (!userId) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "Missing required parameter: userId is required."
        );
      }

      logger.info(`Processing logout operations for user: ${userId}`);

      // Log logout activity
      await logLogoutActivity(userId, deviceInfo);

      logger.info(`Logout operations completed for user: ${userId}`);

      return {
        success: true,
        message: "Logout operations completed successfully",
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      };
    } catch (error) {
      logger.error("Error in logout operations:", error);

      return {
        success: true,
        message:
          "Logout successful, some background operations may have failed",
        error: error instanceof Error ? error.message : "Unknown error",
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      };
    }
  }
);

/**
 * Log user logout activity
 */
async function logLogoutActivity(
  userId: string,
  deviceInfo?: any
): Promise<void> {
  try {
    await db.collection("activities").add({
      type: "logout",
      userId: userId,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      description: "User Logout",
      details: {
        userAgent: deviceInfo?.userAgent || "Unknown",
        platform: deviceInfo?.platform || "Unknown",
        ipAddress: deviceInfo?.ipAddress,
      },
    });

    logger.info(`Logout activity logged for user: ${userId}`);
  } catch (error) {
    logger.error(`Failed to log logout activity for user ${userId}:`, error);
    // Don't throw - this is non-critical
  }
}

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
