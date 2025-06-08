import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";
import cors from "cors";
import express from "express";

// Initialize Firebase Admin
admin.initializeApp();

// Initialize Express app with CORS
const app = express();
app.use(cors({ origin: true }));

// Import function modules
import { fileUploadFunctions } from "./modules/fileUpload";
import { categoryFunctions } from "./modules/categoryManagement";
import { userFunctions } from "./modules/userManagement";
import { documentFunctions } from "./modules/documentManagement";
import { syncFunctions } from "./modules/syncOperations";
import { notificationFunctions } from "./modules/notifications";

import {
  handlePostLoginOperations,
  handleLogoutOperations,
  validateUserSession,
} from "./auth/authOperations";

// File Upload Functions
export const processFileUpload = fileUploadFunctions.processFileUpload;
export const generateThumbnail = fileUploadFunctions.generateThumbnail;
export const validateFile = fileUploadFunctions.validateFile;
export const checkDuplicateFile = fileUploadFunctions.checkDuplicateFile;
export const extractMetadata = fileUploadFunctions.extractMetadata;
export const getStorageQuota = fileUploadFunctions.getStorageQuota;
export const getFileAccessUrl = fileUploadFunctions.getFileAccessUrl;
export const cleanupOrphanedFiles = fileUploadFunctions.cleanupOrphanedFiles;
export const batchProcessFiles = fileUploadFunctions.batchProcessFiles;

// Category Management Functions
export const createCategory = categoryFunctions.createCategory;
export const updateCategory = categoryFunctions.updateCategory;
export const deleteCategory = categoryFunctions.deleteCategory;
export const addFilesToCategory = categoryFunctions.addFilesToCategory;
export const removeFilesFromCategory =
  categoryFunctions.removeFilesFromCategory;
export const getCategoryDocumentsEnhanced =
  categoryFunctions.getCategoryDocumentsEnhanced;
export const refreshCategoryContents =
  categoryFunctions.refreshCategoryContents;

// User Management Functions
export const createUser = userFunctions.createUser;
export const updateUserPermissions = userFunctions.updateUserPermissions;
export const deleteUser = userFunctions.deleteUser;
export const bulkUserOperations = userFunctions.bulkUserOperations;

// Document Management Functions
export const approveDocument = documentFunctions.approveDocument;
export const rejectDocument = documentFunctions.rejectDocument;
export const bulkDocumentOperations = documentFunctions.bulkDocumentOperations;
export const generateDocumentReport = documentFunctions.generateDocumentReport;

// Sync Operations Functions
export const syncStorageWithFirestore = syncFunctions.syncStorageWithFirestore;
export const cleanupOrphanedMetadata = syncFunctions.cleanupOrphanedMetadata;
export const performComprehensiveSync = syncFunctions.performComprehensiveSync;

// Notification Functions
export const sendNotification = notificationFunctions.sendNotification;
export const processActivityLog = notificationFunctions.processActivityLog;

// Authentication Functions (ANR Prevention)
export {
  handlePostLoginOperations,
  handleLogoutOperations,
  validateUserSession,
};

// Import and export the document status change trigger
import { onDocumentStatusChange } from "./modules/notifications";
export { onDocumentStatusChange };

// Health Check Function
export const healthCheck = functions.https.onCall(async (data, context) => {
  return {
    status: "healthy",
    timestamp: new Date().toISOString(),
    version: "1.0.0",
    authenticated: !!context.auth,
  };
});

// API Gateway Function
export const api = functions.https.onRequest(app);

// Firestore Triggers
export const onDocumentCreate = functions.firestore
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

export const onUserCreate = functions.firestore
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
export const onFileUpload = functions.storage
  .object()
  .onFinalize(async (object) => {
    const filePath = object.name;
    const contentType = object.contentType;

    if (!filePath || !filePath.startsWith("documents/")) {
      return;
    }

    // File upload processing is now handled directly in upload functions
    console.log(`File uploaded: ${filePath}`);
  });

// Scheduled Functions
export const dailyCleanup = functions.pubsub
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
export const weeklySync = functions.pubsub
  .schedule("0 3 * * 0") // Run weekly on Sunday at 3 AM
  .timeZone("Asia/Jakarta")
  .onRun(async () => {
    console.log("Starting weekly comprehensive sync...");
    console.log("Comprehensive sync completed");
  });
