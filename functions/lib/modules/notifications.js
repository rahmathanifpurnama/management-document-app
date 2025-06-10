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
exports.notificationFunctions = exports.onDocumentStatusChange = void 0;
const functions = __importStar(require("firebase-functions/v1"));
const admin = __importStar(require("firebase-admin"));
/**
 * Send notification to a user
 */
const sendNotification = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        const { userId, title, message, type, data: notificationData } = data;
        // Validate required fields
        if (!userId || !title || !message) {
            throw new functions.https.HttpsError("invalid-argument", "Missing required fields");
        }
        // Check if target user exists
        const userDoc = await admin
            .firestore()
            .collection("users")
            .doc(userId)
            .get();
        if (!userDoc.exists) {
            throw new functions.https.HttpsError("not-found", "Target user not found");
        }
        // Create notification record
        const notificationId = admin
            .firestore()
            .collection("notifications")
            .doc().id;
        const notification = {
            id: notificationId,
            userId,
            title,
            message,
            type: type || "info",
            data: notificationData || {},
            isRead: false,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            createdBy: context.auth.uid,
        };
        await admin
            .firestore()
            .collection("notifications")
            .doc(notificationId)
            .set(notification);
        // Try to send push notification if FCM token is available
        const userData = userDoc.data();
        if (userData === null || userData === void 0 ? void 0 : userData.fcmToken) {
            try {
                await admin.messaging().send({
                    token: userData.fcmToken,
                    notification: {
                        title,
                        body: message,
                    },
                    data: Object.assign({ type: type || "info", notificationId }, notificationData),
                });
            }
            catch (fcmError) {
                console.warn(`Failed to send FCM notification to ${userId}:`, fcmError);
                // Don't throw error, just log it
            }
        }
        console.log(`Notification sent successfully to user: ${userId}`);
        return {
            success: true,
            notificationId,
            message: "Notification sent successfully",
        };
    }
    catch (error) {
        console.error("Error sending notification:", error);
        if (error instanceof functions.https.HttpsError) {
            throw error;
        }
        throw new functions.https.HttpsError("internal", `Failed to send notification: ${error}`);
    }
});
/**
 * Process activity log and send relevant notifications
 */
const processActivityLog = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        const { type, userId, details, metadata } = data;
        // Create activity log entry
        const activityId = admin.firestore().collection("activities").doc().id;
        const activity = {
            id: activityId,
            type,
            userId,
            details,
            metadata: metadata || {},
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            createdBy: context.auth.uid,
        };
        await admin
            .firestore()
            .collection("activities")
            .doc(activityId)
            .set(activity);
        // Determine if notifications should be sent based on activity type
        const notificationConfig = getNotificationConfig(type);
        if (notificationConfig.shouldNotify) {
            const targetUsers = await getTargetUsers(type, userId, metadata);
            // Send notifications to relevant users
            for (const targetUserId of targetUsers) {
                if (targetUserId !== context.auth.uid) {
                    // Don't notify the actor
                    await sendNotificationInternal({
                        userId: targetUserId,
                        title: notificationConfig.title,
                        message: notificationConfig.getMessage(details, metadata),
                        type: notificationConfig.type,
                        data: Object.assign({ activityId, activityType: type }, metadata),
                    });
                }
            }
        }
        console.log(`Activity logged: ${type} for user ${userId}`);
        return {
            success: true,
            activityId,
            notificationsSent: notificationConfig.shouldNotify,
        };
    }
    catch (error) {
        console.error("Error processing activity log:", error);
        if (error instanceof functions.https.HttpsError) {
            throw error;
        }
        throw new functions.https.HttpsError("internal", `Failed to process activity log: ${error}`);
    }
});
// Helper functions
async function sendNotificationInternal(data) {
    try {
        const notificationId = admin
            .firestore()
            .collection("notifications")
            .doc().id;
        const notification = {
            id: notificationId,
            userId: data.userId,
            title: data.title,
            message: data.message,
            type: data.type || "info",
            data: data.data || {},
            isRead: false,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            createdBy: "system",
        };
        await admin
            .firestore()
            .collection("notifications")
            .doc(notificationId)
            .set(notification);
        // Try to send push notification
        const userDoc = await admin
            .firestore()
            .collection("users")
            .doc(data.userId)
            .get();
        const userData = userDoc.data();
        if (userData === null || userData === void 0 ? void 0 : userData.fcmToken) {
            try {
                await admin.messaging().send({
                    token: userData.fcmToken,
                    notification: {
                        title: data.title,
                        body: data.message,
                    },
                    data: Object.assign({ type: data.type || "info", notificationId }, data.data),
                });
            }
            catch (fcmError) {
                console.warn(`Failed to send FCM notification to ${data.userId}:`, fcmError);
            }
        }
    }
    catch (error) {
        console.error("Error sending internal notification:", error);
    }
}
function getNotificationConfig(activityType) {
    const configs = {
        document_approved: {
            shouldNotify: true,
            title: "Document Approved",
            type: "success",
            getMessage: (details) => `Your document has been approved: ${details}`,
        },
        document_rejected: {
            shouldNotify: true,
            title: "Document Rejected",
            type: "warning",
            getMessage: (details) => `Your document has been rejected: ${details}`,
        },
        user_created: {
            shouldNotify: true,
            title: "Welcome!",
            type: "info",
            getMessage: () => "Your account has been created successfully. Welcome to the system!",
        },
        category_created: {
            shouldNotify: false,
            title: "New Category",
            type: "info",
            getMessage: (details) => `New category created: ${details}`,
        },
        file_uploaded: {
            shouldNotify: false,
            title: "File Uploaded",
            type: "success",
            getMessage: (details) => `File uploaded successfully: ${details}`,
        },
        bulk_operation_completed: {
            shouldNotify: true,
            title: "Bulk Operation Completed",
            type: "info",
            getMessage: (details) => `Bulk operation completed: ${details}`,
        },
    };
    return (configs[activityType] || {
        shouldNotify: false,
        title: "System Activity",
        type: "info",
        getMessage: (details) => details,
    });
}
async function getTargetUsers(activityType, userId, metadata // or more specific type
) {
    const targetUsers = [];
    switch (activityType) {
        case "document_approved":
        case "document_rejected": {
            // Notify the document owner
            targetUsers.push(userId);
            // If metadata exists, notify other stakeholders
            if (metadata === null || metadata === void 0 ? void 0 : metadata.approvers) {
                targetUsers.push(...metadata.approvers);
            }
            if (metadata === null || metadata === void 0 ? void 0 : metadata.reviewers) {
                targetUsers.push(...metadata.reviewers);
            }
            break;
        }
        case "user_created":
            // Notify the new user
            targetUsers.push(userId);
            // If supervisor exists in metadata
            if (metadata === null || metadata === void 0 ? void 0 : metadata.supervisorId) {
                targetUsers.push(metadata.supervisorId);
            }
            break;
        case "bulk_operation_completed": {
            // Notify admins
            const adminUsers = await admin
                .firestore()
                .collection("users")
                .where("role", "==", "admin")
                .where("isActive", "==", true)
                .get();
            adminUsers.docs.forEach((doc) => {
                targetUsers.push(doc.id);
            });
            // If specific users exist in metadata
            if (metadata === null || metadata === void 0 ? void 0 : metadata.specificUsers) {
                targetUsers.push(...metadata.specificUsers);
            }
            break;
        }
        case "category_created":
        case "category_deleted": {
            // Notify users with category management permissions
            const categoryManagers = await admin
                .firestore()
                .collection("users")
                .where("permissions.canManageCategories", "==", true)
                .where("isActive", "==", true)
                .get();
            categoryManagers.docs.forEach((doc) => {
                targetUsers.push(doc.id);
            });
            break;
        }
    }
    // Remove duplicates
    return [...new Set(targetUsers)];
}
// Document status change notifications removed since status management is removed
exports.notificationFunctions = {
    sendNotification,
    processActivityLog,
};
//# sourceMappingURL=notifications.js.map