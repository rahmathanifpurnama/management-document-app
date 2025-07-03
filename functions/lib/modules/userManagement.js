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
exports.userFunctions = void 0;
const functions = __importStar(require("firebase-functions/v1"));
const admin = __importStar(require("firebase-admin"));
/**
 * Create a new user
 */
const createUser = functions.https.onCall(async (data, context) => {
    // Verify authentication and admin privileges
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        // Check if current user is admin
        const currentUserDoc = await admin
            .firestore()
            .collection("users")
            .doc(context.auth.uid)
            .get();
        const currentUser = currentUserDoc.data();
        if (!currentUser || currentUser.role !== "admin") {
            throw new functions.https.HttpsError("permission-denied", "Only admins can create users");
        }
        const { fullName, email, password, role, permissions } = data;
        // Validate required fields
        if (!fullName || !email || !password || !role) {
            throw new functions.https.HttpsError("invalid-argument", "Missing required fields");
        }
        // Validate email format
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            throw new functions.https.HttpsError("invalid-argument", "Invalid email format");
        }
        // Validate password strength
        if (password.length < 6) {
            throw new functions.https.HttpsError("invalid-argument", "Password must be at least 6 characters");
        }
        // Create user in Firebase Auth
        const userRecord = await admin.auth().createUser({
            email,
            password,
            displayName: fullName,
            emailVerified: true,
        });
        // Set default permissions based on role - FIXED: Use array structure for Storage Rules compatibility
        const defaultPermissions = role === "admin"
            ? {
                documents: ["view", "upload", "delete", "approve"],
                categories: [],
                system: ["user_management", "analytics"],
            }
            : {
                documents: ["view", "upload"],
                categories: [],
                system: [],
            };
        // Create user document in Firestore
        const userData = {
            id: userRecord.uid,
            fullName,
            email,
            role,
            status: "active",
            createdBy: context.auth.uid,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            permissions: permissions || defaultPermissions,
            lastLogin: null,
            profileImageUrl: null,
        };
        await admin
            .firestore()
            .collection("users")
            .doc(userRecord.uid)
            .set(userData);
        // Log activity
        await admin
            .firestore()
            .collection("activities")
            .add({
            type: "user_created",
            userId: userRecord.uid,
            createdBy: context.auth.uid,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            details: `User ${fullName} (${email}) created with role ${role}`,
        });
        console.log(`User created successfully: ${userRecord.uid}`);
        return {
            success: true,
            userId: userRecord.uid,
            message: "User created successfully",
        };
    }
    catch (error) {
        console.error("Error creating user:", error);
        // Handle specific Firebase Auth errors
        if (error instanceof Error &&
            "code" in error &&
            error.code === "auth/email-already-exists") {
            throw new functions.https.HttpsError("already-exists", "Email already exists");
        }
        if (error instanceof functions.https.HttpsError) {
            throw error;
        }
        throw new functions.https.HttpsError("internal", `Failed to create user: ${error}`);
    }
});
/**
 * Update user permissions
 */
const updateUserPermissions = functions.https.onCall(async (data, context) => {
    var _a;
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        // Check if current user is admin
        const currentUserDoc = await admin
            .firestore()
            .collection("users")
            .doc(context.auth.uid)
            .get();
        const currentUser = currentUserDoc.data();
        if (!currentUser || currentUser.role !== "admin") {
            throw new functions.https.HttpsError("permission-denied", "Only admins can update user permissions");
        }
        const { userId, permissions } = data;
        // Validate user exists
        const userDoc = await admin
            .firestore()
            .collection("users")
            .doc(userId)
            .get();
        if (!userDoc.exists) {
            throw new functions.https.HttpsError("not-found", "User not found");
        }
        // Update user permissions
        await admin.firestore().collection("users").doc(userId).update({
            permissions,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            updatedBy: context.auth.uid,
        });
        // Log activity
        await admin
            .firestore()
            .collection("activities")
            .add({
            type: "user_permissions_updated",
            userId,
            updatedBy: context.auth.uid,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            details: `Permissions updated for user ${(_a = userDoc.data()) === null || _a === void 0 ? void 0 : _a.fullName}`,
        });
        console.log(`User permissions updated successfully: ${userId}`);
        return {
            success: true,
            message: "User permissions updated successfully",
        };
    }
    catch (error) {
        console.error("Error updating user permissions:", error);
        if (error instanceof functions.https.HttpsError) {
            throw error;
        }
        throw new functions.https.HttpsError("internal", `Failed to update user permissions: ${error}`);
    }
});
/**
 * Delete a user (soft delete)
 */
const deleteUser = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        // Check if current user is admin
        const currentUserDoc = await admin
            .firestore()
            .collection("users")
            .doc(context.auth.uid)
            .get();
        const currentUser = currentUserDoc.data();
        if (!currentUser || currentUser.role !== "admin") {
            throw new functions.https.HttpsError("permission-denied", "Only admins can delete users");
        }
        const { userId } = data;
        // Prevent self-deletion
        if (userId === context.auth.uid) {
            throw new functions.https.HttpsError("invalid-argument", "Cannot delete your own account");
        }
        // Validate user exists
        const userDoc = await admin
            .firestore()
            .collection("users")
            .doc(userId)
            .get();
        if (!userDoc.exists) {
            throw new functions.https.HttpsError("not-found", "User not found");
        }
        const userData = userDoc.data();
        // ADMIN HARD DELETE: Permanently delete user document for admin operations
        console.log(`🗑️ Deleting user document from Firestore: ${userId}`);
        await admin.firestore().collection("users").doc(userId).delete();
        // FIXED: Delete user from Firebase Auth completely (not just disable)
        // This prevents auto-sync from recreating the user
        await admin.auth().deleteUser(userId);
        // Log activity
        await admin
            .firestore()
            .collection("activities")
            .add({
            type: "user_deleted",
            userId,
            deletedBy: context.auth.uid,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            details: `User ${userData === null || userData === void 0 ? void 0 : userData.fullName} (${userData === null || userData === void 0 ? void 0 : userData.email}) deleted`,
        });
        console.log(`User deleted successfully: ${userId}`);
        return {
            success: true,
            message: "User deleted successfully",
        };
    }
    catch (error) {
        console.error("Error deleting user:", error);
        if (error instanceof functions.https.HttpsError) {
            throw error;
        }
        throw new functions.https.HttpsError("internal", `Failed to delete user: ${error}`);
    }
});
/**
 * Bulk user operations
 */
const bulkUserOperations = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        // Check if current user is admin
        const currentUserDoc = await admin
            .firestore()
            .collection("users")
            .doc(context.auth.uid)
            .get();
        const currentUser = currentUserDoc.data();
        if (!currentUser || currentUser.role !== "admin") {
            throw new functions.https.HttpsError("permission-denied", "Only admins can perform bulk operations");
        }
        const { operation, userIds } = data;
        if (!userIds || userIds.length === 0) {
            throw new functions.https.HttpsError("invalid-argument", "No users specified");
        }
        // Prevent operations on self
        if (userIds.includes(context.auth.uid)) {
            throw new functions.https.HttpsError("invalid-argument", "Cannot perform bulk operations on your own account");
        }
        const results = {
            success: 0,
            failed: 0,
            errors: [],
        };
        // Process users in batches
        const batchSize = 500;
        for (let i = 0; i < userIds.length; i += batchSize) {
            const batch = admin.firestore().batch();
            const batchUserIds = userIds.slice(i, i + batchSize);
            for (const userId of batchUserIds) {
                try {
                    const userRef = admin.firestore().collection("users").doc(userId);
                    switch (operation) {
                        case "activate":
                            batch.update(userRef, {
                                status: "active",
                                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                                updatedBy: context.auth.uid,
                            });
                            // Enable in Firebase Auth
                            await admin.auth().updateUser(userId, { disabled: false });
                            break;
                        case "deactivate":
                            batch.update(userRef, {
                                status: "inactive",
                                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                                updatedBy: context.auth.uid,
                            });
                            // Disable in Firebase Auth
                            await admin.auth().updateUser(userId, { disabled: true });
                            break;
                        case "delete":
                            // Hard delete: Remove from Firestore and Firebase Auth
                            batch.delete(userRef);
                            // Delete from Firebase Auth
                            await admin.auth().deleteUser(userId);
                            break;
                    }
                    results.success++;
                }
                catch (error) {
                    results.failed++;
                    results.errors.push(`Failed to ${operation} user ${userId}: ${error}`);
                }
            }
            await batch.commit();
        }
        // Log activity
        await admin
            .firestore()
            .collection("activities")
            .add({
            type: "bulk_user_operation",
            operation,
            userId: context.auth.uid,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            details: `Bulk ${operation} operation: ${results.success} successful, ${results.failed} failed`,
        });
        console.log(`Bulk ${operation} operation completed:`, results);
        return {
            success: true,
            results,
            message: `Bulk ${operation} operation completed`,
        };
    }
    catch (error) {
        console.error("Error in bulk user operations:", error);
        if (error instanceof functions.https.HttpsError) {
            throw error;
        }
        throw new functions.https.HttpsError("internal", `Failed to perform bulk user operations: ${error}`);
    }
});
/**
 * Set admin custom claims for a user
 */
const setAdminClaims = functions.https.onCall(async (data, context) => {
    // Only existing admins can set admin claims
    if (!context.auth || !context.auth.token.admin) {
        throw new functions.https.HttpsError("permission-denied", "Only administrators can set admin claims");
    }
    try {
        const { userId, isAdmin } = data;
        // Set custom claims
        await admin.auth().setCustomUserClaims(userId, { admin: isAdmin });
        // Update user document in Firestore
        await admin.firestore().collection("users").doc(userId).update({
            role: isAdmin ? "admin" : "user",
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            updatedBy: context.auth.uid,
        });
        console.log(`Admin claims set for user ${userId}: ${isAdmin}`);
        return {
            success: true,
            message: `User ${userId} ${isAdmin ? "granted" : "revoked"} admin privileges`,
        };
    }
    catch (error) {
        console.error("Error setting admin claims:", error);
        throw new functions.https.HttpsError("internal", `Failed to set admin claims: ${error}`);
    }
});
/**
 * Auto-sync all Firebase Auth users to Firestore (Admin only)
 */
const autoSyncFirebaseAuthUsers = functions.https.onCall(async (data, context) => {
    var _a;
    // Verify authentication and admin privileges
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        // Check if user is admin
        const adminDoc = await admin
            .firestore()
            .collection("users")
            .doc(context.auth.uid)
            .get();
        if (!adminDoc.exists || ((_a = adminDoc.data()) === null || _a === void 0 ? void 0 : _a.role) !== "admin") {
            throw new functions.https.HttpsError("permission-denied", "Only admins can auto-sync Firebase Auth users");
        }
        // Get all Firebase Auth users
        const listUsersResult = await admin.auth().listUsers(1000);
        const authUsers = listUsersResult.users;
        // Get existing Firestore users
        const firestoreUsersSnapshot = await admin
            .firestore()
            .collection("users")
            .get();
        const existingUserIds = new Set(firestoreUsersSnapshot.docs.map(doc => doc.id));
        // Find users that exist in Firebase Auth but not in Firestore
        const usersToSync = authUsers.filter(user => !existingUserIds.has(user.uid));
        let syncedCount = 0;
        const errors = [];
        // Sync each missing user
        for (const authUser of usersToSync) {
            try {
                // Generate a safe fullName with proper fallbacks
                let fullName = authUser.displayName || '';
                // If displayName is empty, extract from email
                if (!fullName.trim() && authUser.email) {
                    const emailPart = authUser.email.split('@')[0];
                    fullName = emailPart
                        .replace(/[._]/g, ' ')
                        .split(' ')
                        .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
                        .filter(word => word.length > 0)
                        .join(' ');
                }
                // Final fallback if all else fails
                if (!fullName.trim()) {
                    fullName = 'Unknown User';
                }
                const userData = {
                    id: authUser.uid,
                    fullName: fullName,
                    email: authUser.email || '',
                    role: "user", // Default role
                    status: authUser.disabled ? "inactive" : "active",
                    createdBy: context.auth.uid,
                    createdAt: admin.firestore.FieldValue.serverTimestamp(),
                    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                    permissions: {
                        documents: ["view", "upload"],
                        categories: [],
                        system: [],
                    },
                    lastLogin: authUser.metadata.lastSignInTime ?
                        admin.firestore.Timestamp.fromDate(new Date(authUser.metadata.lastSignInTime)) : null,
                    profileImageUrl: null,
                };
                await admin
                    .firestore()
                    .collection("users")
                    .doc(authUser.uid)
                    .set(userData);
                syncedCount++;
                console.log(`Auto-synced user: ${authUser.email || authUser.uid}`);
            }
            catch (error) {
                const errorMsg = `Failed to sync user ${authUser.email || authUser.uid}: ${error}`;
                errors.push(errorMsg);
                console.error(errorMsg);
            }
        }
        // Log activity
        await admin
            .firestore()
            .collection("activities")
            .add({
            type: "auto_sync_completed",
            userId: context.auth.uid,
            createdBy: context.auth.uid,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            details: `Auto-sync completed: ${syncedCount} users synced, ${errors.length} errors`,
        });
        console.log(`Auto-sync completed: ${syncedCount} users synced, ${errors.length} errors`);
        return {
            success: true,
            syncedCount,
            totalAuthUsers: authUsers.length,
            totalFirestoreUsers: firestoreUsersSnapshot.docs.length,
            errors: errors.length > 0 ? errors : undefined,
            message: `Auto-sync completed: ${syncedCount} users synced`,
        };
    }
    catch (error) {
        console.error("Error in auto-sync Firebase Auth users:", error);
        if (error instanceof functions.https.HttpsError) {
            throw error;
        }
        throw new functions.https.HttpsError("internal", `Failed to auto-sync Firebase Auth users: ${error}`);
    }
});
/**
 * Initialize admin user (for first-time setup)
 */
const initializeAdmin = functions.https.onCall(async (data, context) => {
    try {
        const { email } = data;
        // Get user by email
        const userRecord = await admin.auth().getUserByEmail(email);
        // Set admin claims
        await admin.auth().setCustomUserClaims(userRecord.uid, { admin: true });
        // Update user document in Firestore
        await admin.firestore().collection("users").doc(userRecord.uid).update({
            role: "admin",
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        console.log(`Admin initialized for user: ${email}`);
        return {
            success: true,
            message: `Admin privileges granted to ${email}`,
        };
    }
    catch (error) {
        console.error("Error initializing admin:", error);
        throw new functions.https.HttpsError("internal", `Failed to initialize admin: ${error}`);
    }
});
exports.userFunctions = {
    createUser,
    updateUserPermissions,
    deleteUser,
    bulkUserOperations,
    setAdminClaims,
    autoSyncFirebaseAuthUsers,
    initializeAdmin,
};
//# sourceMappingURL=userManagement.js.map