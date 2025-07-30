"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.logActivity = exports.validateUserSession = exports.handleLogoutOperations = exports.handlePostLoginOperations = void 0;
const functions = __importStar(require("firebase-functions/v1"));
const admin = __importStar(require("firebase-admin"));
const firebase_functions_1 = require("firebase-functions");
// Initialize Firebase Admin if not already initialized
if (!admin.apps.length) {
    admin.initializeApp();
}
const db = admin.firestore();
/**
 * Cloud Function to handle post-login operations
 * This reduces ANR risk by moving heavy operations to the backend
 */
exports.handlePostLoginOperations = functions.https.onCall(async (data, context) => {
    try {
        // Verify authentication
        if (!context.auth) {
            throw new functions.https.HttpsError("unauthenticated", "User must be authenticated to perform this operation.");
        }
        const { userId, email, deviceInfo } = data;
        if (!userId || !email) {
            throw new functions.https.HttpsError("invalid-argument", "Missing required parameters: userId and email are required.");
        }
        firebase_functions_1.logger.info(`Processing post-login operations for user: ${userId}`);
        // Execute operations in parallel for better performance
        const operations = [
            updateLastLogin(userId),
            logLoginActivity(userId, deviceInfo),
            updateUserStats(userId),
        ];
        // Execute all operations concurrently
        await Promise.allSettled(operations);
        firebase_functions_1.logger.info(`Post-login operations completed for user: ${userId}`);
        return {
            success: true,
            message: "Post-login operations completed successfully",
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
        };
    }
    catch (error) {
        firebase_functions_1.logger.error("Error in post-login operations:", error);
        // Don't throw error for non-critical operations
        // Return success to prevent login failure
        return {
            success: true,
            message: "Login successful, some background operations may have failed",
            error: error instanceof Error ? error.message : "Unknown error",
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
        };
    }
});
/**
 * Update user's last login timestamp
 */
async function updateLastLogin(userId) {
    try {
        await db.collection("users").doc(userId).update({
            lastLogin: admin.firestore.FieldValue.serverTimestamp(),
            lastActiveAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        firebase_functions_1.logger.info(`Updated last login for user: ${userId}`);
    }
    catch (error) {
        firebase_functions_1.logger.error(`Failed to update last login for user ${userId}:`, error);
        // Don't throw - this is non-critical
    }
}
/**
 * Enhanced login activity logging with user context
 */
async function logLoginActivity(userId, deviceInfo) {
    try {
        // Get user information for enhanced logging
        let userName = null;
        let userRole = null;
        let userEmail = null;
        try {
            const userDoc = await db.collection("users").doc(userId).get();
            if (userDoc.exists) {
                const userData = userDoc.data();
                firebase_functions_1.logger.info(`User data found for activity logging: ${Object.keys(userData || {}).join(', ')}`);
                // Try multiple field names for user name
                userName = (userData === null || userData === void 0 ? void 0 : userData.fullName) || (userData === null || userData === void 0 ? void 0 : userData.name) || (userData === null || userData === void 0 ? void 0 : userData.displayName) || (userData === null || userData === void 0 ? void 0 : userData.email);
                userRole = userData === null || userData === void 0 ? void 0 : userData.role;
                userEmail = userData === null || userData === void 0 ? void 0 : userData.email;
                firebase_functions_1.logger.info(`User info for activity: Name: ${userName}, Role: ${userRole}, Email: ${userEmail}`);
            }
            else {
                firebase_functions_1.logger.warn(`User document not found in Firestore for UID: ${userId}`);
                // Fallback to Firebase Auth user data
                try {
                    const authUser = await admin.auth().getUser(userId);
                    userEmail = authUser.email || null;
                    userName = authUser.displayName || authUser.email || null;
                    firebase_functions_1.logger.info(`Fallback to Auth user data: ${userName}, ${userEmail}`);
                }
                catch (authError) {
                    firebase_functions_1.logger.error(`Failed to get Auth user data for ${userId}:`, authError);
                }
            }
        }
        catch (error) {
            firebase_functions_1.logger.error(`Error getting user info for activity log: ${error}`);
        }
        const activityData = {
            type: "login",
            userId: userId,
            userName: userName || userEmail || "Unknown User",
            userEmail: userEmail,
            userRole: userRole || "user",
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            description: "User Login",
            isSuspicious: false,
            ipAddress: (deviceInfo === null || deviceInfo === void 0 ? void 0 : deviceInfo.ipAddress) || null,
            userAgent: (deviceInfo === null || deviceInfo === void 0 ? void 0 : deviceInfo.userAgent) || "Unknown",
            details: {
                userAgent: (deviceInfo === null || deviceInfo === void 0 ? void 0 : deviceInfo.userAgent) || "Unknown",
                platform: (deviceInfo === null || deviceInfo === void 0 ? void 0 : deviceInfo.platform) || "Unknown",
                ipAddress: deviceInfo === null || deviceInfo === void 0 ? void 0 : deviceInfo.ipAddress,
                source: "server-side",
            },
        };
        await db.collection("activities").add(activityData);
        firebase_functions_1.logger.info(`Enhanced login activity logged for user: ${userId} (${userName})`);
    }
    catch (error) {
        firebase_functions_1.logger.error(`Failed to log login activity for user ${userId}:`, error);
        // Don't throw - this is non-critical
    }
}
/**
 * Update user statistics
 */
async function updateUserStats(userId) {
    try {
        const userRef = db.collection("users").doc(userId);
        await db.runTransaction(async (transaction) => {
            const userDoc = await transaction.get(userRef);
            if (userDoc.exists) {
                const userData = userDoc.data();
                const currentLoginCount = (userData === null || userData === void 0 ? void 0 : userData.loginCount) || 0;
                transaction.update(userRef, {
                    loginCount: currentLoginCount + 1,
                    lastStatsUpdate: admin.firestore.FieldValue.serverTimestamp(),
                });
            }
        });
        firebase_functions_1.logger.info(`Updated user stats for user: ${userId}`);
    }
    catch (error) {
        firebase_functions_1.logger.error(`Failed to update user stats for user ${userId}:`, error);
        // Don't throw - this is non-critical
    }
}
/**
 * Cloud Function to handle logout operations
 */
exports.handleLogoutOperations = functions.https.onCall(async (data, context) => {
    try {
        // Verify authentication
        if (!context.auth) {
            throw new functions.https.HttpsError("unauthenticated", "User must be authenticated to perform this operation.");
        }
        const { userId, deviceInfo } = data;
        if (!userId) {
            throw new functions.https.HttpsError("invalid-argument", "Missing required parameter: userId is required.");
        }
        firebase_functions_1.logger.info(`Processing logout operations for user: ${userId}`);
        // Log logout activity
        await logLogoutActivity(userId, deviceInfo);
        firebase_functions_1.logger.info(`Logout operations completed for user: ${userId}`);
        return {
            success: true,
            message: "Logout operations completed successfully",
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
        };
    }
    catch (error) {
        firebase_functions_1.logger.error("Error in logout operations:", error);
        return {
            success: true,
            message: "Logout successful, some background operations may have failed",
            error: error instanceof Error ? error.message : "Unknown error",
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
        };
    }
});
/**
 * Enhanced logout activity logging with user context
 */
async function logLogoutActivity(userId, deviceInfo) {
    try {
        // Get user information for enhanced logging
        let userName = null;
        let userRole = null;
        let userEmail = null;
        try {
            const userDoc = await db.collection("users").doc(userId).get();
            if (userDoc.exists) {
                const userData = userDoc.data();
                // Try multiple field names for user name
                userName = (userData === null || userData === void 0 ? void 0 : userData.fullName) || (userData === null || userData === void 0 ? void 0 : userData.name) || (userData === null || userData === void 0 ? void 0 : userData.displayName) || (userData === null || userData === void 0 ? void 0 : userData.email);
                userRole = userData === null || userData === void 0 ? void 0 : userData.role;
                userEmail = userData === null || userData === void 0 ? void 0 : userData.email;
            }
            else {
                // Fallback to Firebase Auth user data
                try {
                    const authUser = await admin.auth().getUser(userId);
                    userEmail = authUser.email || null;
                    userName = authUser.displayName || authUser.email || null;
                }
                catch (authError) {
                    firebase_functions_1.logger.error(`Failed to get Auth user data for logout ${userId}:`, authError);
                }
            }
        }
        catch (error) {
            firebase_functions_1.logger.error(`Error getting user info for logout activity log: ${error}`);
        }
        const activityData = {
            type: "logout",
            userId: userId,
            userName: userName || userEmail || "Unknown User",
            userEmail: userEmail,
            userRole: userRole || "user",
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            description: "User Logout",
            isSuspicious: false,
            ipAddress: (deviceInfo === null || deviceInfo === void 0 ? void 0 : deviceInfo.ipAddress) || null,
            userAgent: (deviceInfo === null || deviceInfo === void 0 ? void 0 : deviceInfo.userAgent) || "Unknown",
            details: {
                userAgent: (deviceInfo === null || deviceInfo === void 0 ? void 0 : deviceInfo.userAgent) || "Unknown",
                platform: (deviceInfo === null || deviceInfo === void 0 ? void 0 : deviceInfo.platform) || "Unknown",
                ipAddress: deviceInfo === null || deviceInfo === void 0 ? void 0 : deviceInfo.ipAddress,
                source: "server-side",
            },
        };
        await db.collection("activities").add(activityData);
        firebase_functions_1.logger.info(`Enhanced logout activity logged for user: ${userId} (${userName})`);
    }
    catch (error) {
        firebase_functions_1.logger.error(`Failed to log logout activity for user ${userId}:`, error);
        // Don't throw - this is non-critical
    }
}
/**
 * Cloud Function to validate user session
 * This can be called periodically to ensure user is still active
 */
exports.validateUserSession = functions.https.onCall(async (data, context) => {
    try {
        if (!context.auth) {
            throw new functions.https.HttpsError("unauthenticated", "User must be authenticated to validate session.");
        }
        const { userId } = data;
        const uid = context.auth.uid;
        // Ensure user can only validate their own session
        if (userId !== uid) {
            throw new functions.https.HttpsError("permission-denied", "User can only validate their own session.");
        }
        // Get user data from Firestore
        const userDoc = await db.collection("users").doc(userId).get();
        if (!userDoc.exists) {
            throw new functions.https.HttpsError("not-found", "User data not found in database.");
        }
        const userData = userDoc.data();
        // Check if user is active
        if (!(userData === null || userData === void 0 ? void 0 : userData.isActive)) {
            throw new functions.https.HttpsError("permission-denied", "User account is not active.");
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
    }
    catch (error) {
        firebase_functions_1.logger.error("Error validating user session:", error);
        throw error;
    }
});
/**
 * Enhanced activity logging Cloud Function
 * Centralizes all activity logging with server-side validation
 */
exports.logActivity = functions.https.onCall(async (data, context) => {
    try {
        // Verify authentication
        if (!context.auth) {
            throw new functions.https.HttpsError("unauthenticated", "User must be authenticated to log activities.");
        }
        const { type, description, documentId, categoryId, additionalData, isSuspicious = false } = data;
        if (!type || !description) {
            throw new functions.https.HttpsError("invalid-argument", "Missing required parameters: type and description are required.");
        }
        const userId = context.auth.uid;
        firebase_functions_1.logger.info(`Logging activity - Type: ${type}, User: ${userId}`);
        // Filter out system-generated activity types
        const userInitiatedTypes = [
            'login', 'logout', 'upload', 'download', 'delete', 'view', 'create', 'edit', 'update',
            'password_change', 'profile_update', 'category_create', 'category_update', 'category_delete'
        ];
        if (!userInitiatedTypes.includes(type)) {
            firebase_functions_1.logger.warn(`Skipping system-generated activity type: ${type}`);
            return { success: true, message: "System-generated activity type skipped" };
        }
        // Get user information for enhanced logging
        let userName = null;
        let userRole = null;
        let userEmail = null;
        try {
            const userDoc = await db.collection("users").doc(userId).get();
            if (userDoc.exists) {
                const userData = userDoc.data();
                // Try multiple field names for user name
                userName = (userData === null || userData === void 0 ? void 0 : userData.fullName) || (userData === null || userData === void 0 ? void 0 : userData.name) || (userData === null || userData === void 0 ? void 0 : userData.displayName) || (userData === null || userData === void 0 ? void 0 : userData.email);
                userRole = userData === null || userData === void 0 ? void 0 : userData.role;
                userEmail = userData === null || userData === void 0 ? void 0 : userData.email;
            }
            else {
                // Fallback to Firebase Auth user data
                try {
                    const authUser = await admin.auth().getUser(userId);
                    userEmail = authUser.email || null;
                    userName = authUser.displayName || authUser.email || null;
                }
                catch (authError) {
                    firebase_functions_1.logger.error(`Failed to get Auth user data for activity ${userId}:`, authError);
                }
            }
        }
        catch (error) {
            firebase_functions_1.logger.error(`Error getting user info for activity log: ${error}`);
        }
        const activityData = {
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
            details: Object.assign({ source: "server-side" }, additionalData),
        };
        // Add optional fields
        if (documentId) {
            activityData.documentId = documentId;
        }
        if (categoryId) {
            activityData.categoryId = categoryId;
        }
        await db.collection("activities").add(activityData);
        firebase_functions_1.logger.info(`Activity logged successfully - Type: ${type}, User: ${userName}, Description: ${description}`);
        return {
            success: true,
            message: "Activity logged successfully",
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
        };
    }
    catch (error) {
        firebase_functions_1.logger.error("Error logging activity:", error);
        throw new functions.https.HttpsError("internal", `Failed to log activity: ${error}`);
    }
});
//# sourceMappingURL=authOperations.js.map