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
exports.weeklySync = exports.dailyCleanup = exports.onFileUpload = exports.onUserCreate = exports.onDocumentCreate = exports.api = exports.healthCheck = exports.onDocumentStatusChange = exports.validateUserSession = exports.handleLogoutOperations = exports.handlePostLoginOperations = exports.cleanupQueue = exports.getQueueStatus = exports.addToProcessingQueue = exports.processQueue = exports.processActivityLog = exports.sendNotification = exports.performComprehensiveSync = exports.cleanupOrphanedMetadata = exports.syncStorageWithFirestore = exports.generateDocumentReport = exports.bulkDocumentOperations = exports.rejectDocument = exports.approveDocument = exports.bulkUserOperations = exports.deleteUser = exports.updateUserPermissions = exports.createUser = exports.refreshCategoryContents = exports.getCategoryDocumentsEnhanced = exports.removeFilesFromCategory = exports.addFilesToCategory = exports.deleteCategory = exports.updateCategory = exports.createCategory = exports.batchProcessFiles = exports.cleanupOrphanedFiles = exports.getFileAccessUrl = exports.getStorageQuota = exports.extractMetadata = exports.checkDuplicateFile = exports.validateFile = exports.generateThumbnail = exports.processFileUpload = void 0;
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
const processingQueue_1 = require("./modules/processingQueue");
Object.defineProperty(exports, "processQueue", { enumerable: true, get: function () { return processingQueue_1.processQueue; } });
Object.defineProperty(exports, "addToProcessingQueue", { enumerable: true, get: function () { return processingQueue_1.addToProcessingQueue; } });
Object.defineProperty(exports, "getQueueStatus", { enumerable: true, get: function () { return processingQueue_1.getQueueStatus; } });
Object.defineProperty(exports, "cleanupQueue", { enumerable: true, get: function () { return processingQueue_1.cleanupQueue; } });
const authOperations_1 = require("./auth/authOperations");
Object.defineProperty(exports, "handlePostLoginOperations", { enumerable: true, get: function () { return authOperations_1.handlePostLoginOperations; } });
Object.defineProperty(exports, "handleLogoutOperations", { enumerable: true, get: function () { return authOperations_1.handleLogoutOperations; } });
Object.defineProperty(exports, "validateUserSession", { enumerable: true, get: function () { return authOperations_1.validateUserSession; } });
// File Upload Functions
exports.processFileUpload = fileUpload_1.fileUploadFunctions.processFileUpload;
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
    .document("documents/{documentId}")
    .onCreate(async (snap, context) => {
    const document = snap.data();
    const documentId = context.params.documentId;
    // Log activity
    await admin
        .firestore()
        .collection("activities")
        .add({
        type: "document_created",
        documentId: documentId,
        userId: document.uploadedBy,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        details: `Document ${document.fileName} uploaded`,
    });
});
exports.onUserCreate = functions.firestore
    .document("users/{userId}")
    .onCreate(async (snap, context) => {
    const user = snap.data();
    const userId = context.params.userId;
    // Log activity
    await admin
        .firestore()
        .collection("activities")
        .add({
        type: "user_created",
        userId: userId,
        createdBy: user.createdBy,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        details: `User ${user.fullName} created`,
    });
});
// Storage Triggers
exports.onFileUpload = functions.storage
    .object()
    .onFinalize(async (object) => {
    const filePath = object.name;
    const contentType = object.contentType;
    if (!filePath || !filePath.startsWith("documents/")) {
        return;
    }
    // File upload processing queue removed since status management is removed
    console.log(`File uploaded: ${filePath}`);
});
// Scheduled Functions
exports.dailyCleanup = functions.pubsub
    .schedule("0 2 * * *") // Run daily at 2 AM
    .timeZone("Asia/Jakarta")
    .onRun(async () => {
    console.log("Starting daily cleanup...");
    // Clean up orphaned metadata
    console.log("Running orphaned metadata cleanup...");
    // Clean up old activity logs (older than 90 days)
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - 90);
    const oldActivities = await admin
        .firestore()
        .collection("activities")
        .where("timestamp", "<", cutoffDate)
        .get();
    const batch = admin.firestore().batch();
    oldActivities.docs.forEach((doc) => {
        batch.delete(doc.ref);
    });
    await batch.commit();
    console.log(`Cleaned up ${oldActivities.size} old activity logs`);
});
// Weekly Sync Function
exports.weeklySync = functions.pubsub
    .schedule("0 3 * * 0") // Run weekly on Sunday at 3 AM
    .timeZone("Asia/Jakarta")
    .onRun(async () => {
    console.log("Starting weekly comprehensive sync...");
    console.log("Comprehensive sync completed");
});
//# sourceMappingURL=index.js.map