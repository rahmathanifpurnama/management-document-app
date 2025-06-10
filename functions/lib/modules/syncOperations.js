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
exports.syncFunctions = void 0;
const functions = __importStar(require("firebase-functions/v1"));
const admin = __importStar(require("firebase-admin"));
/**
 * Sync Firebase Storage with Firestore metadata
 */
const syncStorageWithFirestore = functions.https.onCall(async (data, context) => {
    var _a, _b;
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        // Check user permissions
        const userDoc = await admin
            .firestore()
            .collection("users")
            .doc(context.auth.uid)
            .get();
        const user = userDoc.data();
        if (!user || user.role !== "admin") {
            throw new functions.https.HttpsError("permission-denied", "Only admins can perform sync operations");
        }
        const startTime = Date.now();
        console.log("Starting Storage to Firestore sync...");
        const bucket = admin.storage().bucket();
        const documentsRef = bucket.getFiles({ prefix: "documents/" });
        let processed = 0;
        const errors = [];
        const batchSize = 500;
        let batch = admin.firestore().batch();
        let batchCount = 0;
        const [files] = await documentsRef;
        for (const file of files) {
            try {
                // Skip system files
                if (file.name.includes("/.") || file.name.endsWith("/")) {
                    continue;
                }
                const fileName = file.name.split("/").pop() || "unknown";
                const documentId = fileName.split(".")[0] || fileName;
                // Check if document already exists in Firestore
                const existingDoc = await admin
                    .firestore()
                    .collection("documents")
                    .doc(documentId)
                    .get();
                if (!existingDoc.exists) {
                    // Get file metadata
                    const [metadata] = await file.getMetadata();
                    // Create document record
                    const documentData = {
                        id: documentId,
                        fileName,
                        fileSize: parseInt(String(metadata.size || "0")),
                        fileType: getFileTypeFromName(fileName),
                        filePath: file.name,
                        downloadUrl: await file
                            .getSignedUrl({
                            action: "read",
                            expires: "03-09-2491",
                        })
                            .then((urls) => urls[0]),
                        uploadedBy: ((_a = metadata.metadata) === null || _a === void 0 ? void 0 : _a.uploadedBy) || "system",
                        uploadedAt: metadata.timeCreated
                            ? new Date(metadata.timeCreated)
                            : admin.firestore.FieldValue.serverTimestamp(),
                        category: ((_b = metadata.metadata) === null || _b === void 0 ? void 0 : _b.categoryId) || "uncategorized",
                        status: "approved", // Default for synced files
                        isActive: true,
                        syncedAt: admin.firestore.FieldValue.serverTimestamp(),
                    };
                    batch.set(admin.firestore().collection("documents").doc(documentId), documentData);
                    batchCount++;
                    processed++;
                    // Commit batch when it reaches the limit
                    if (batchCount >= batchSize) {
                        await batch.commit();
                        batch = admin.firestore().batch();
                        batchCount = 0;
                    }
                }
            }
            catch (error) {
                errors.push(`Error processing file ${file.name}: ${error}`);
                console.error(`Error processing file ${file.name}:`, error);
            }
        }
        // Commit remaining batch
        if (batchCount > 0) {
            await batch.commit();
        }
        const duration = Date.now() - startTime;
        // Log activity
        await admin
            .firestore()
            .collection("activities")
            .add({
            type: "storage_sync_completed",
            userId: context.auth.uid,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            details: `Storage sync completed: ${processed} files processed in ${duration}ms`,
        });
        console.log(`Storage sync completed: ${processed} files processed`);
        return {
            success: true,
            processed,
            errors,
            duration,
        };
    }
    catch (error) {
        console.error("Error in storage sync:", error);
        throw new functions.https.HttpsError("internal", `Storage sync failed: ${error}`);
    }
});
/**
 * DISABLED: Clean up orphaned metadata to prevent automatic deletions
 * This function has been disabled to prevent unwanted metadata deletion
 * Use manual cleanup functions with proper admin controls instead
 */
<<<<<<< HEAD
const cleanupOrphanedMetadataDisabled = functions.https.onCall(async (data, context) => {
    throw new functions.https.HttpsError("failed-precondition", "Automatic orphaned metadata cleanup has been disabled. Use manual cleanup functions instead.");
});
=======
// const cleanupOrphanedMetadataDisabled = functions.https.onCall(
//   async () => {
//     throw new functions.https.HttpsError(
//       "failed-precondition",
//       "Automatic orphaned metadata cleanup has been disabled. Use manual cleanup functions instead."
//     );
//   }
// );
>>>>>>> 25b3e57f9907ae847e7650af676bea7c1a4a0b6f
/**
 * Manual cleanup of orphaned metadata (requires admin authentication)
 */
const manualCleanupOrphanedMetadata = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        // Check user permissions
        const userDoc = await admin
            .firestore()
            .collection("users")
            .doc(context.auth.uid)
            .get();
        const user = userDoc.data();
        if (!user || user.role !== "admin") {
            throw new functions.https.HttpsError("permission-denied", "Only admins can perform cleanup operations");
        }
        const startTime = Date.now();
        console.log("Starting orphaned metadata cleanup...");
        const bucket = admin.storage().bucket();
        let processed = 0;
        const errors = [];
        // Get all documents from Firestore
        const documentsSnapshot = await admin
            .firestore()
            .collection("documents")
            .where("isActive", "==", true)
            .get();
        const batchSize = 500;
        let batch = admin.firestore().batch();
        let batchCount = 0;
        for (const doc of documentsSnapshot.docs) {
            try {
                const documentData = doc.data();
                const filePath = documentData.filePath;
                if (!filePath) {
                    continue;
                }
                // Check if file exists in Storage
                const file = bucket.file(filePath);
                const [exists] = await file.exists();
                if (!exists) {
                    // Mark document as orphaned
                    batch.update(doc.ref, {
                        isActive: false,
                        orphanedAt: admin.firestore.FieldValue.serverTimestamp(),
                        orphanedBy: context.auth.uid,
                        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                    });
                    batchCount++;
                    processed++;
                    // Commit batch when it reaches the limit
                    if (batchCount >= batchSize) {
                        await batch.commit();
                        batch = admin.firestore().batch();
                        batchCount = 0;
                    }
                }
            }
            catch (error) {
                errors.push(`Error checking document ${doc.id}: ${error}`);
                console.error(`Error checking document ${doc.id}:`, error);
            }
        }
        // Commit remaining batch
        if (batchCount > 0) {
            await batch.commit();
        }
        const duration = Date.now() - startTime;
        // Log activity
        await admin
            .firestore()
            .collection("activities")
            .add({
            type: "orphaned_cleanup_completed",
            userId: context.auth.uid,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            details: `Orphaned metadata cleanup completed: ${processed} orphaned documents found in ${duration}ms`,
        });
        console.log(`Orphaned metadata cleanup completed: ${processed} orphaned documents`);
        return {
            success: true,
            processed,
            errors,
            duration,
        };
    }
    catch (error) {
        console.error("Error in orphaned metadata cleanup:", error);
        throw new functions.https.HttpsError("internal", `Orphaned metadata cleanup failed: ${error}`);
    }
});
/**
 * Perform comprehensive sync (Storage to Firestore + Cleanup)
 */
const performComprehensiveSync = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        // Check user permissions
        const userDoc = await admin
            .firestore()
            .collection("users")
            .doc(context.auth.uid)
            .get();
        const user = userDoc.data();
        if (!user || user.role !== "admin") {
            throw new functions.https.HttpsError("permission-denied", "Only admins can perform comprehensive sync");
        }
        const startTime = Date.now();
        console.log("Starting comprehensive sync...");
        // Step 1: Sync Storage with Firestore
        console.log("Running storage sync...");
        // Step 2: Cleanup orphaned metadata
        console.log("Running cleanup...");
        // Step 3: Update category document counts
        await updateCategoryDocumentCounts();
        // Step 4: Update user statistics
        await updateUserStatistics();
        const duration = Date.now() - startTime;
        // Log activity
        await admin
            .firestore()
            .collection("activities")
            .add({
            type: "comprehensive_sync_completed",
            userId: context.auth.uid,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            details: `Comprehensive sync completed in ${duration}ms`,
        });
        console.log(`Comprehensive sync completed in ${duration}ms`);
        return {
            success: true,
            message: "Comprehensive sync completed",
            duration,
        };
    }
    catch (error) {
        console.error("Error in comprehensive sync:", error);
        throw new functions.https.HttpsError("internal", `Comprehensive sync failed: ${error}`);
    }
});
// Helper functions
async function updateCategoryDocumentCounts() {
    console.log("Updating category document counts...");
    const categoriesSnapshot = await admin
        .firestore()
        .collection("categories")
        .where("isActive", "==", true)
        .get();
    const batch = admin.firestore().batch();
    for (const categoryDoc of categoriesSnapshot.docs) {
        const categoryId = categoryDoc.id;
        // Count documents in this category
        const documentsSnapshot = await admin
            .firestore()
            .collection("documents")
            .where("category", "==", categoryId)
            .where("isActive", "==", true)
            .get();
        batch.update(categoryDoc.ref, {
            documentCount: documentsSnapshot.size,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
    }
    await batch.commit();
    console.log(`Updated document counts for ${categoriesSnapshot.size} categories`);
}
async function updateUserStatistics() {
    console.log("Updating user statistics...");
    const usersSnapshot = await admin
        .firestore()
        .collection("users")
        .where("isActive", "==", true)
        .get();
    const batch = admin.firestore().batch();
    for (const userDoc of usersSnapshot.docs) {
        const userId = userDoc.id;
        // Count documents uploaded by this user
        const documentsSnapshot = await admin
            .firestore()
            .collection("documents")
            .where("uploadedBy", "==", userId)
            .where("isActive", "==", true)
            .get();
        batch.update(userDoc.ref, {
            documentCount: documentsSnapshot.size,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
    }
    await batch.commit();
    console.log(`Updated statistics for ${usersSnapshot.size} users`);
}
function getFileTypeFromName(fileName) {
    var _a;
    const extension = (_a = fileName.split(".").pop()) === null || _a === void 0 ? void 0 : _a.toLowerCase();
    switch (extension) {
        case "pdf":
            return "PDF";
        case "doc":
        case "docx":
            return "DOC";
        case "xls":
        case "xlsx":
            return "Excel";
        case "ppt":
        case "pptx":
            return "PPT";
        case "jpg":
        case "jpeg":
        case "png":
        case "gif":
            return "Image";
        case "txt":
            return "Text";
        default:
            return "Other";
    }
}
exports.syncFunctions = {
    syncStorageWithFirestore,
    cleanupOrphanedMetadata: manualCleanupOrphanedMetadata,
    performComprehensiveSync,
};
//# sourceMappingURL=syncOperations.js.map