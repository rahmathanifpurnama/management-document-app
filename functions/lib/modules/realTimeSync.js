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
exports.onAuthUserDeleted = exports.onAuthUserCreated = exports.onStorageFileDeleted = exports.onStorageFileCreated = void 0;
const functions = __importStar(require("firebase-functions/v1"));
const admin = __importStar(require("firebase-admin"));
/**
 * REAL-TIME SYNCHRONIZATION SYSTEM
 * Handles automatic detection and synchronization of changes from Firebase Storage,
 * Firebase Authentication, and Firestore for real-time UI updates
 */
// Constants for real-time sync
const SYNC_COLLECTION = "sync-operations";
const METADATA_COLLECTION = "document-metadata";
const USERS_COLLECTION = "users";
const ACTIVITIES_COLLECTION = "activities";
/**
 * STORAGE CHANGE DETECTION
 * Automatically detects when files are added to Firebase Storage
 * and creates corresponding metadata in Firestore
 */
exports.onStorageFileCreated = functions.storage.object().onFinalize(async (object) => {
    try {
        console.log("🔄 Storage file created trigger activated");
        console.log("📁 File details:", {
            name: object.name,
            bucket: object.bucket,
            contentType: object.contentType,
            size: object.size,
            timeCreated: object.timeCreated,
        });
        // Only process files in the documents folder
        if (!object.name || !object.name.startsWith("documents/")) {
            console.log("⏭️ Skipping non-document file:", object.name);
            return;
        }
        // Extract file information
        const filePath = object.name;
        const fileName = filePath.split("/").pop() || "Unknown File";
        const fileSize = parseInt(object.size || "0");
        const contentType = object.contentType || "application/octet-stream";
        // Enhanced duplicate prevention check
        const duplicateCheck = await checkForExistingDocumentEnhanced(filePath, fileName, fileSize);
        if (duplicateCheck.hasDuplicates) {
            console.log("✅ Document already exists in Firestore:", fileName);
            console.log("📊 Duplicate check details:", duplicateCheck);
            return;
        }
        // Create metadata document
        const documentId = generateDocumentId(filePath);
        const metadata = {
            id: documentId,
            fileName: fileName,
            filePath: filePath,
            fileSize: fileSize,
            fileType: getFileTypeFromContentType(contentType),
            contentType: contentType,
            uploadedAt: admin.firestore.FieldValue.serverTimestamp(),
            uploadedBy: "system", // Will be updated if we can determine the actual user
            isActive: true,
            category: extractCategoryFromPath(filePath),
            source: "storage_trigger",
            syncedAt: admin.firestore.FieldValue.serverTimestamp(),
        };
        // Create document in Firestore
        await admin
            .firestore()
            .collection(METADATA_COLLECTION)
            .doc(documentId)
            .set(metadata);
        console.log("✅ Created metadata document:", documentId);
        // Log activity
        await logSyncActivity("document_created", {
            documentId: documentId,
            fileName: fileName,
            filePath: filePath,
            source: "storage_trigger",
        });
        // Invalidate statistics cache to trigger real-time updates
        await invalidateStatisticsCache();
        console.log("🎉 Storage sync completed successfully");
    }
    catch (error) {
        console.error("❌ Error in storage file created trigger:", error);
        // Log error for monitoring
        await logSyncActivity("sync_error", {
            error: error instanceof Error ? error.message : String(error),
            source: "storage_trigger",
            filePath: object.name,
        });
    }
});
/**
 * STORAGE FILE DELETION DETECTION
 * Automatically marks documents as inactive when files are deleted from Storage
 */
exports.onStorageFileDeleted = functions.storage.object().onDelete(async (object) => {
    try {
        console.log("🗑️ Storage file deleted trigger activated");
        console.log("📁 Deleted file:", object.name);
        if (!object.name || !object.name.startsWith("documents/")) {
            console.log("⏭️ Skipping non-document file deletion:", object.name);
            return;
        }
        const filePath = object.name;
        // Find and mark document as inactive
        const querySnapshot = await admin
            .firestore()
            .collection(METADATA_COLLECTION)
            .where("filePath", "==", filePath)
            .where("isActive", "==", true)
            .get();
        if (querySnapshot.empty) {
            console.log("⚠️ No active document found for deleted file:", filePath);
            return;
        }
        const batch = admin.firestore().batch();
        querySnapshot.docs.forEach((doc) => {
            batch.update(doc.ref, {
                isActive: false,
                deletedAt: admin.firestore.FieldValue.serverTimestamp(),
                deletedBy: "system",
                source: "storage_deletion_trigger",
            });
        });
        await batch.commit();
        console.log(`✅ Marked ${querySnapshot.docs.length} documents as inactive`);
        // Log activity
        await logSyncActivity("document_deleted", {
            filePath: filePath,
            documentsAffected: querySnapshot.docs.length,
            source: "storage_deletion_trigger",
        });
        // Invalidate statistics cache
        await invalidateStatisticsCache();
        console.log("🎉 Storage deletion sync completed");
    }
    catch (error) {
        console.error("❌ Error in storage file deleted trigger:", error);
        await logSyncActivity("sync_error", {
            error: error instanceof Error ? error.message : String(error),
            source: "storage_deletion_trigger",
            filePath: object.name,
        });
    }
});
/**
 * FIREBASE AUTH USER CREATION DETECTION
 * Automatically creates user profile in Firestore when new user is created in Firebase Auth
 */
exports.onAuthUserCreated = functions.auth.user().onCreate(async (user) => {
    var _a;
    try {
        console.log("👤 Auth user created trigger activated");
        console.log("📧 User details:", {
            uid: user.uid,
            email: user.email,
            displayName: user.displayName,
            creationTime: user.metadata.creationTime,
        });
        // Check for existing user document
        const existingUser = await admin
            .firestore()
            .collection(USERS_COLLECTION)
            .doc(user.uid)
            .get();
        if (existingUser.exists) {
            console.log("✅ User document already exists:", user.uid);
            return;
        }
        // Create user profile document
        const userProfile = {
            uid: user.uid,
            email: user.email || "",
            displayName: user.displayName || ((_a = user.email) === null || _a === void 0 ? void 0 : _a.split("@")[0]) || "User",
            photoURL: user.photoURL || "",
            isActive: true,
            role: "user", // Default role
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            lastLoginAt: admin.firestore.FieldValue.serverTimestamp(),
            documentCount: 0,
            source: "auth_trigger",
            syncedAt: admin.firestore.FieldValue.serverTimestamp(),
        };
        await admin
            .firestore()
            .collection(USERS_COLLECTION)
            .doc(user.uid)
            .set(userProfile);
        console.log("✅ Created user profile document:", user.uid);
        // Log activity
        await logSyncActivity("user_created", {
            userId: user.uid,
            email: user.email,
            source: "auth_trigger",
        });
        // Invalidate statistics cache
        await invalidateStatisticsCache();
        console.log("🎉 Auth user sync completed successfully");
    }
    catch (error) {
        console.error("❌ Error in auth user created trigger:", error);
        await logSyncActivity("sync_error", {
            error: error instanceof Error ? error.message : String(error),
            source: "auth_trigger",
            userId: user.uid,
        });
    }
});
/**
 * FIREBASE AUTH USER DELETION DETECTION
 * Automatically marks user as inactive when deleted from Firebase Auth
 */
exports.onAuthUserDeleted = functions.auth.user().onDelete(async (user) => {
    try {
        console.log("🗑️ Auth user deleted trigger activated");
        console.log("👤 Deleted user:", user.uid);
        // Mark user as inactive instead of deleting
        const userRef = admin.firestore().collection(USERS_COLLECTION).doc(user.uid);
        const userDoc = await userRef.get();
        if (userDoc.exists) {
            await userRef.update({
                isActive: false,
                deletedAt: admin.firestore.FieldValue.serverTimestamp(),
                source: "auth_deletion_trigger",
            });
            console.log("✅ Marked user as inactive:", user.uid);
        }
        else {
            console.log("⚠️ User document not found:", user.uid);
        }
        // Log activity
        await logSyncActivity("user_deleted", {
            userId: user.uid,
            source: "auth_deletion_trigger",
        });
        // Invalidate statistics cache
        await invalidateStatisticsCache();
        console.log("🎉 Auth user deletion sync completed");
    }
    catch (error) {
        console.error("❌ Error in auth user deleted trigger:", error);
        await logSyncActivity("sync_error", {
            error: error instanceof Error ? error.message : String(error),
            source: "auth_deletion_trigger",
            userId: user.uid,
        });
    }
});
/**
 * HELPER FUNCTIONS
 */
// Enhanced duplicate prevention check
async function checkForExistingDocumentEnhanced(filePath, fileName, fileSize) {
    try {
        // Check 1: Exact file path match
        const pathQuery = await admin
            .firestore()
            .collection(METADATA_COLLECTION)
            .where("filePath", "==", filePath)
            .where("isActive", "==", true)
            .limit(1)
            .get();
        if (!pathQuery.empty) {
            return {
                hasDuplicates: true,
                details: {
                    reason: "exact_path_match",
                    existingDoc: pathQuery.docs[0].data(),
                }
            };
        }
        // Check 2: Same file name and size
        const nameQuery = await admin
            .firestore()
            .collection(METADATA_COLLECTION)
            .where("fileName", "==", fileName)
            .where("fileSize", "==", fileSize)
            .where("isActive", "==", true)
            .limit(1)
            .get();
        if (!nameQuery.empty) {
            return {
                hasDuplicates: true,
                details: {
                    reason: "name_and_size_match",
                    existingDoc: nameQuery.docs[0].data(),
                }
            };
        }
        return { hasDuplicates: false, details: null };
    }
    catch (error) {
        console.error("❌ Error in duplicate check:", error);
        return { hasDuplicates: false, details: { error: error instanceof Error ? error.message : String(error) } };
    }
}
// Check if document already exists in Firestore (legacy function)
async function checkForExistingDocument(filePath) {
    const querySnapshot = await admin
        .firestore()
        .collection(METADATA_COLLECTION)
        .where("filePath", "==", filePath)
        .where("isActive", "==", true)
        .limit(1)
        .get();
    return !querySnapshot.empty;
}
// Generate consistent document ID from file path
function generateDocumentId(filePath) {
    // Use a hash of the file path to ensure consistency
    const crypto = require("crypto");
    return crypto.createHash("md5").update(filePath).digest("hex");
}
// Extract file type from content type
function getFileTypeFromContentType(contentType) {
    if (contentType.startsWith("image/"))
        return "image";
    if (contentType.includes("pdf"))
        return "pdf";
    if (contentType.includes("word") || contentType.includes("document"))
        return "document";
    if (contentType.includes("spreadsheet") || contentType.includes("excel"))
        return "spreadsheet";
    if (contentType.includes("presentation") || contentType.includes("powerpoint"))
        return "presentation";
    return "other";
}
// Extract category from file path
function extractCategoryFromPath(filePath) {
    const pathParts = filePath.split("/");
    if (pathParts.length >= 3) {
        return pathParts[1]; // documents/category/file.ext
    }
    return "uncategorized";
}
// Log sync activity for monitoring
async function logSyncActivity(type, details) {
    try {
        await admin
            .firestore()
            .collection(ACTIVITIES_COLLECTION)
            .add({
            type: type,
            details: details,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            source: "real_time_sync",
        });
    }
    catch (error) {
        console.error("❌ Error logging sync activity:", error);
    }
}
// Invalidate statistics cache to trigger real-time updates
async function invalidateStatisticsCache() {
    try {
        await admin
            .firestore()
            .collection("statistics-cache")
            .doc("global-stats")
            .delete();
        console.log("🔄 Statistics cache invalidated");
    }
    catch (error) {
        console.error("❌ Error invalidating statistics cache:", error);
    }
}
//# sourceMappingURL=realTimeSync.js.map