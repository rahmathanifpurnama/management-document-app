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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.manualCleanupActivityLogs = exports.onFileUpload = exports.onUserCreate = exports.onDocumentCreate = exports.api = exports.healthCheck = exports.validateUserSession = exports.handleLogoutOperations = exports.handlePostLoginOperations = exports.processActivityLog = exports.sendNotification = exports.performComprehensiveSync = exports.cleanupOrphanedMetadata = exports.syncStorageWithFirestore = exports.generateDocumentReport = exports.bulkDocumentOperations = exports.rejectDocument = exports.approveDocument = exports.bulkUserOperations = exports.deleteUser = exports.updateUserPermissions = exports.createUser = exports.refreshCategoryContents = exports.getCategoryDocumentsEnhanced = exports.removeFilesFromCategory = exports.addFilesToCategory = exports.deleteCategory = exports.updateCategory = exports.createCategory = exports.batchProcessFiles = exports.cleanupOrphanedFiles = exports.getFileAccessUrl = exports.getStorageQuota = exports.extractMetadata = exports.checkDuplicateFile = exports.validateFile = exports.generateThumbnail = exports.streamingUpload = exports.processFileUpload = void 0;
const functions = __importStar(require("firebase-functions/v1"));
const admin = __importStar(require("firebase-admin"));
const cors_1 = __importDefault(require("cors"));
const express_1 = __importDefault(require("express"));
// Initialize Firebase Admin
admin.initializeApp();
// Initialize Express app with CORS
const app = (0, express_1.default)();
app.use((0, cors_1.default)({ origin: true }));
// Import function modules
const fileUpload_1 = require("./modules/fileUpload");
const categoryManagement_1 = require("./modules/categoryManagement");
const userManagement_1 = require("./modules/userManagement");
const documentManagement_1 = require("./modules/documentManagement");
const syncOperations_1 = require("./modules/syncOperations");
const notifications_1 = require("./modules/notifications");
const authOperations_1 = require("./auth/authOperations");
Object.defineProperty(exports, "handlePostLoginOperations", { enumerable: true, get: function () { return authOperations_1.handlePostLoginOperations; } });
Object.defineProperty(exports, "handleLogoutOperations", { enumerable: true, get: function () { return authOperations_1.handleLogoutOperations; } });
Object.defineProperty(exports, "validateUserSession", { enumerable: true, get: function () { return authOperations_1.validateUserSession; } });
// File Upload Functions
exports.processFileUpload = fileUpload_1.fileUploadFunctions.processFileUpload;
exports.streamingUpload = fileUpload_1.fileUploadFunctions.streamingUpload;
exports.generateThumbnail = fileUpload_1.fileUploadFunctions.generateThumbnail;
exports.validateFile = fileUpload_1.fileUploadFunctions.validateFile;
exports.checkDuplicateFile = fileUpload_1.fileUploadFunctions.checkDuplicateFile;
exports.extractMetadata = fileUpload_1.fileUploadFunctions.extractMetadata;
exports.getStorageQuota = fileUpload_1.fileUploadFunctions.getStorageQuota;
exports.getFileAccessUrl = fileUpload_1.fileUploadFunctions.getFileAccessUrl;
exports.cleanupOrphanedFiles = fileUpload_1.fileUploadFunctions.cleanupOrphanedFiles;
exports.batchProcessFiles = fileUpload_1.fileUploadFunctions.batchProcessFiles;
// Category Management Functions
exports.createCategory = categoryManagement_1.categoryFunctions.createCategory;
exports.updateCategory = categoryManagement_1.categoryFunctions.updateCategory;
exports.deleteCategory = categoryManagement_1.categoryFunctions.deleteCategory;
exports.addFilesToCategory = categoryManagement_1.categoryFunctions.addFilesToCategory;
exports.removeFilesFromCategory = categoryManagement_1.categoryFunctions.removeFilesFromCategory;
exports.getCategoryDocumentsEnhanced = categoryManagement_1.categoryFunctions.getCategoryDocumentsEnhanced;
exports.refreshCategoryContents = categoryManagement_1.categoryFunctions.refreshCategoryContents;
// User Management Functions
exports.createUser = userManagement_1.userFunctions.createUser;
exports.updateUserPermissions = userManagement_1.userFunctions.updateUserPermissions;
exports.deleteUser = userManagement_1.userFunctions.deleteUser;
exports.bulkUserOperations = userManagement_1.userFunctions.bulkUserOperations;
// Document Management Functions
exports.approveDocument = documentManagement_1.documentFunctions.approveDocument;
exports.rejectDocument = documentManagement_1.documentFunctions.rejectDocument;
exports.bulkDocumentOperations = documentManagement_1.documentFunctions.bulkDocumentOperations;
exports.generateDocumentReport = documentManagement_1.documentFunctions.generateDocumentReport;
// Sync Operations Functions
exports.syncStorageWithFirestore = syncOperations_1.syncFunctions.syncStorageWithFirestore;
exports.cleanupOrphanedMetadata = syncOperations_1.syncFunctions.cleanupOrphanedMetadata;
exports.performComprehensiveSync = syncOperations_1.syncFunctions.performComprehensiveSync;
// Notification Functions
exports.sendNotification = notifications_1.notificationFunctions.sendNotification;
exports.processActivityLog = notifications_1.notificationFunctions.processActivityLog;
// Document status change trigger removed since status management is removed
// Health Check Function
exports.healthCheck = functions.https.onCall(async (data, context) => {
    return {
        status: "healthy",
        timestamp: new Date().toISOString(),
        version: "1.0.0",
        authenticated: !!context.auth,
    };
});
// API Gateway Function
exports.api = functions.https.onRequest(app);
// Firestore Triggers
exports.onDocumentCreate = functions.firestore
    .document("document-metadata/{documentId}")
    .onCreate(async (snap, context) => {
    const document = snap.data();
    const documentId = context.params.documentId;
    // Document created - no activity logging needed
    console.log(`Document created: ${documentId} - ${document.fileName}`);
});
exports.onUserCreate = functions.firestore
    .document("users/{userId}")
    .onCreate(async (snap, context) => {
    const user = snap.data();
    const userId = context.params.userId;
    // User created - no activity logging needed
    console.log(`User created: ${userId} - ${user.fullName}`);
});
// Storage Triggers
exports.onFileUpload = functions.storage
    .object()
    .onFinalize(async (object) => {
    const filePath = object.name;
    if (!filePath || !filePath.startsWith("documents/")) {
        return;
    }
    // File upload processing is now handled directly in upload functions
    console.log(`File uploaded: ${filePath}`);
});
// DISABLED: Automatic cleanup functions to prevent unwanted deletions
// These functions were causing automatic deletion of files and metadata
// All cleanup operations should now be manual and require admin approval
// export const dailyCleanup = functions
//   .runWith({
//     timeoutSeconds: 540, // 9 minutes timeout
//     memory: "1GB", // Increased memory for batch operations
//   })
//   .pubsub
//   .schedule("0 3 * * 0") // Run weekly on Sunday at 3 AM (reduced frequency)
//   .timeZone("Asia/Jakarta")
//   .onRun(async () => {
//     console.log("Starting weekly cleanup...");
//     // DISABLED: Automatic deletion operations
//   });
// Manual cleanup function that requires admin authentication
exports.manualCleanupActivityLogs = functions.https.onCall(async (data, context) => {
    // Require authentication and admin role
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        // Check user permissions
        const userDoc = await admin.firestore().collection("users").doc(context.auth.uid).get();
        const user = userDoc.data();
        if (!user || user.role !== "admin") {
            throw new functions.https.HttpsError("permission-denied", "Only admins can perform cleanup operations");
        }
        console.log(`Manual activity log cleanup initiated by admin: ${context.auth.uid}`);
        // PERFORMANCE FIX: Clean up old activity logs with smaller batches
        const cutoffDate = new Date();
        cutoffDate.setDate(cutoffDate.getDate() - 90);
        console.log("Cleaning old activity logs...");
        // Process in smaller batches to prevent timeout
        const batchSize = 100; // Reduced batch size
        let totalDeleted = 0;
        let hasMore = true;
        while (hasMore) {
            const oldActivities = await admin
                .firestore()
                .collection("activities")
                .where("timestamp", "<", cutoffDate)
                .limit(batchSize)
                .get();
            if (oldActivities.empty) {
                hasMore = false;
                break;
            }
            const batch = admin.firestore().batch();
            oldActivities.docs.forEach((doc) => {
                batch.delete(doc.ref);
            });
            await batch.commit();
            totalDeleted += oldActivities.size;
            console.log(`Deleted batch of ${oldActivities.size} activities`);
            // Small delay between batches to prevent overwhelming Firestore
            await new Promise(resolve => setTimeout(resolve, 1000));
        }
        console.log(`✅ Manual cleanup completed. Deleted ${totalDeleted} old activity logs`);
        return {
            success: true,
            deletedCount: totalDeleted,
            message: `Successfully deleted ${totalDeleted} old activity logs`
        };
    }
    catch (error) {
        console.error("❌ Manual cleanup failed:", error);
        throw new functions.https.HttpsError("internal", `Manual cleanup failed: ${error}`);
    }
});
// DISABLED: Weekly automatic sync to prevent unwanted operations
// export const weeklySync = functions.pubsub
//   .schedule("0 3 * * 0") // Run weekly on Sunday at 3 AM
//   .timeZone("Asia/Jakarta")
//   .onRun(async () => {
//     console.log("Starting weekly comprehensive sync...");
//     console.log("Comprehensive sync completed");
//   });
//# sourceMappingURL=index.js.map