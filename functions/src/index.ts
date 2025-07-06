import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";
import cors from "cors";
import express from "express";

// Initialize Firebase Admin with service account
try {
  const serviceAccount = require("../config/service-account-key.json");
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    projectId: 'document-management-c5a96',
    storageBucket: 'document-management-c5a96.firebasestorage.app'
  });
  console.log('✅ Firebase Admin initialized with service account key and storage bucket');
} catch (error) {
  console.log('⚠️ Service account key not found, using default credentials');
  admin.initializeApp({
    projectId: 'document-management-c5a96',
    storageBucket: 'document-management-c5a96.firebasestorage.app'
  });
}

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
// Removed duplicate export - using hybrid version below
export const streamingUpload = fileUploadFunctions.streamingUpload;
export const generateThumbnail = fileUploadFunctions.generateThumbnail;
export const validateFile = fileUploadFunctions.validateFile;
export const checkDuplicateFile = fileUploadFunctions.checkDuplicateFile;
export const extractMetadata = fileUploadFunctions.extractMetadata;
export const getStorageQuota = fileUploadFunctions.getStorageQuota;
export const getFileAccessUrl = fileUploadFunctions.getFileAccessUrl;
export const cleanupOrphanedFiles = fileUploadFunctions.cleanupOrphanedFiles;
export const batchProcessFiles = fileUploadFunctions.batchProcessFiles;

// Hybrid File Processing Functions (Optimized for client-server separation)
import * as hybridProcessingFunctions from './modules/hybridFileProcessing';
export const hybridProcessFileUpload = hybridProcessingFunctions.processFileUpload;

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
export const setAdminClaims = userFunctions.setAdminClaims;
export const autoSyncFirebaseAuthUsers = userFunctions.autoSyncFirebaseAuthUsers;
export const debugAuthPermissions = userFunctions.debugAuthPermissions;
export const initializeAdmin = userFunctions.initializeAdmin;

// Document Management Functions
export const approveDocument = documentFunctions.approveDocument;
export const rejectDocument = documentFunctions.rejectDocument;
export const deleteDocument = documentFunctions.deleteDocument;
export const bulkDocumentOperations = documentFunctions.bulkDocumentOperations;
export const generateDocumentReport = documentFunctions.generateDocumentReport;

// Sync Operations Functions
export const syncStorageWithFirestore = syncFunctions.syncStorageWithFirestore;
export const syncStorageToFirestore = syncFunctions.syncStorageToFirestore;
export const cleanupOrphanedMetadata = syncFunctions.cleanupOrphanedMetadata;
export const performComprehensiveSync = syncFunctions.performComprehensiveSync;
export const monitorSyncConsistency = syncFunctions.monitorSyncConsistency;
export const repairSyncInconsistencies = syncFunctions.repairSyncInconsistencies;

// ENHANCED: Statistics Functions for Large Datasets (1M+ files)
export const getAggregatedStatistics = syncFunctions.getAggregatedStatistics;
export const getPaginatedFileStats = syncFunctions.getPaginatedFileStats;
export const invalidateStatisticsCache = syncFunctions.invalidateStatisticsCache;

// Notification Functions
export const sendNotification = notificationFunctions.sendNotification;
export const processActivityLog = notificationFunctions.processActivityLog;

// Real-time Synchronization Functions
import * as realTimeSyncFunctions from "./modules/realTimeSync";
export const onStorageFileCreated = realTimeSyncFunctions.onStorageFileCreated;
export const onStorageFileDeleted = realTimeSyncFunctions.onStorageFileDeleted;
export const onAuthUserCreated = realTimeSyncFunctions.onAuthUserCreated;
export const onAuthUserDeleted = realTimeSyncFunctions.onAuthUserDeleted;

// Authentication Functions (ANR Prevention)
export {
  handlePostLoginOperations,
  handleLogoutOperations,
  validateUserSession,
};

// Document status change trigger removed since status management is removed

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
  .document("document-metadata/{documentId}")
  .onCreate(async (snap, context) => {
    const document = snap.data();
    const documentId = context.params.documentId;

    // Document created - no activity logging needed
    console.log(`Document created: ${documentId} - ${document.fileName}`);
  });

export const onUserCreate = functions.firestore
  .document("users/{userId}")
  .onCreate(async (snap, context) => {
    const user = snap.data();
    const userId = context.params.userId;

    // User created - no activity logging needed
    console.log(`User created: ${userId} - ${user.fullName}`);
  });

// Storage Triggers
export const onFileUpload = functions.storage
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
export const manualCleanupActivityLogs = functions.https.onCall(async (data, context) => {
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
  } catch (error) {
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
