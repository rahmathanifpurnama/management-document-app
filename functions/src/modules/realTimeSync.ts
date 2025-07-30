import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";

/**
 * REAL-TIME SYNCHRONIZATION SYSTEM
 * Handles automatic detection and synchronization of changes from Firebase Storage, 
 * Firebase Authentication, and Firestore for real-time UI updates
 */

// Constants for real-time sync
const SYNC_COLLECTION = "sync-operations";
const METADATA_COLLECTION = "documents";
const USERS_COLLECTION = "users";
const ACTIVITIES_COLLECTION = "activities";

/**
 * STORAGE CHANGE DETECTION
 * Automatically detects when files are added to Firebase Storage
 * and creates corresponding metadata in Firestore
 */
export const onStorageFileCreated = functions.storage.object().onFinalize(
  async (object) => {
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
      const objectName = object.name as string;
      if (!objectName || !objectName.startsWith("documents/")) {
        console.log("⏭️ Skipping non-document file:", objectName);
        return;
      }

      // Extract file information
      const filePath = objectName;
      const fileName = filePath?.split("/").pop() || "Unknown File";
      const fileSize = parseInt(object.size || "0");
      const contentType = object.contentType || "application/octet-stream";

      // Enhanced duplicate prevention check
      if (!filePath) {
        console.error("File path is undefined");
        return;
      }

      // DISABLED: Document creation is now handled by upload functions only
      // This prevents duplicate document creation between upload functions and storage triggers
      console.log("📝 File uploaded to storage:", filePath);
      console.log("⚠️ Document metadata creation is handled by upload functions");

      const duplicateCheck = await checkForExistingDocumentEnhanced(filePath, fileName, fileSize);
      if (duplicateCheck.hasDuplicates) {
        console.log("✅ Document metadata already exists in Firestore:", fileName);
        console.log("📊 Duplicate check details:", duplicateCheck);
      } else {
        console.log("⚠️ No metadata found for uploaded file:", filePath);
        console.log("💡 This might indicate upload function failed to create metadata");
        console.log("🔧 Consider checking upload function logs for errors");
      }

      // Skip document creation to prevent duplicates
      console.log("⏭️ Skipping document creation (handled by upload functions)");

      // Note: Sync activity logging removed - system-generated operations
      // should not clutter user activity logs

      // Invalidate statistics cache to trigger real-time updates
      await invalidateStatisticsCache();

      console.log("🎉 Storage sync completed successfully");
    } catch (error: unknown) {
      console.error("❌ Error in storage file created trigger:", error);

      // Note: Error logging removed - system-generated operations
      // should not clutter user activity logs
    }
  }
);

/**
 * STORAGE FILE DELETION DETECTION
 * Automatically marks documents as inactive when files are deleted from Storage
 */
export const onStorageFileDeleted = functions.storage.object().onDelete(
  async (object) => {
    try {
      console.log("🗑️ Storage file deleted trigger activated");
      console.log("📁 Deleted file:", object.name);

      const objectName = object.name as string;
      if (!objectName || !objectName.startsWith("documents/")) {
        console.log("⏭️ Skipping non-document file deletion:", objectName);
        return;
      }

      const filePath = objectName;
      
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
        batch.delete(doc.ref);
      });

      await batch.commit();
      console.log(`✅ Deleted ${querySnapshot.docs.length} documents`);

      // Note: Sync activity logging removed - system-generated operations
      // should not clutter user activity logs

      // Invalidate statistics cache
      await invalidateStatisticsCache();

      console.log("🎉 Storage deletion sync completed");
    } catch (error: unknown) {
      console.error("❌ Error in storage file deleted trigger:", error);

      // Note: Error logging removed - system-generated operations
      // should not clutter user activity logs
    }
  }
);

/**
 * FIREBASE AUTH USER CREATION DETECTION
 * Automatically creates user profile in Firestore when new user is created in Firebase Auth
 */
export const onAuthUserCreated = functions.auth.user().onCreate(
  async (user) => {
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

      // RATE LIMITING: Prevent rapid user creation loops
      const recentUsers = await admin
        .firestore()
        .collection(USERS_COLLECTION)
        .where("email", "==", user.email)
        .where("createdAt", ">", new Date(Date.now() - 60000)) // Last 1 minute
        .get();

      if (!recentUsers.empty) {
        console.log("⚠️ User with same email created recently, skipping:", user.email);
        return;
      }

      // Create user profile document
      const userProfile = {
        uid: user.uid,
        email: user.email || "",
        displayName: user.displayName || user.email?.split("@")[0] || "User",
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

      // Note: Sync activity logging removed - system-generated operations
      // should not clutter user activity logs

      // Invalidate statistics cache
      await invalidateStatisticsCache();

      console.log("🎉 Auth user sync completed successfully");
    } catch (error) {
      console.error("❌ Error in auth user created trigger:", error);

      // Note: Error logging removed - system-generated operations
      // should not clutter user activity logs
    }
  }
);

/**
 * FIREBASE AUTH USER DELETION DETECTION
 * Automatically marks user as inactive when deleted from Firebase Auth
 */
export const onAuthUserDeleted = functions.auth.user().onDelete(
  async (user) => {
    try {
      console.log("🗑️ Auth user deleted trigger activated");
      console.log("👤 Deleted user:", user.uid);

      // Mark user as inactive instead of deleting
      const userRef = admin.firestore().collection(USERS_COLLECTION).doc(user.uid);
      const userDoc = await userRef.get();

      if (userDoc.exists) {
        await userRef.delete();

        console.log("✅ Deleted user document:", user.uid);
      } else {
        console.log("⚠️ User document not found:", user.uid);
      }

      // Note: Sync activity logging removed - system-generated operations
      // should not clutter user activity logs

      // Invalidate statistics cache
      await invalidateStatisticsCache();

      console.log("🎉 Auth user deletion sync completed");
    } catch (error) {
      console.error("❌ Error in auth user deleted trigger:", error);

      // Note: Error logging removed - system-generated operations
      // should not clutter user activity logs
    }
  }
);

/**
 * HELPER FUNCTIONS
 */

// Enhanced duplicate prevention check
async function checkForExistingDocumentEnhanced(
  filePath: string,
  fileName: string,
  fileSize: number
): Promise<{hasDuplicates: boolean, details: any}> {
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
  } catch (error) {
    console.error("❌ Error in duplicate check:", error);
    return { hasDuplicates: false, details: { error: error instanceof Error ? error.message : String(error) } };
  }
}

// Check if document already exists in Firestore (legacy function)
async function checkForExistingDocument(filePath: string): Promise<boolean> {
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
function generateDocumentId(filePath: string): string {
  // Use a hash of the file path to ensure consistency
  const crypto = require("crypto");
  return crypto.createHash("md5").update(filePath).digest("hex");
}

// Extract file type from content type
function getFileTypeFromContentType(contentType: string): string {
  if (contentType.startsWith("image/")) return "image";
  if (contentType.includes("pdf")) return "pdf";
  if (contentType.includes("word") || contentType.includes("document")) return "document";
  if (contentType.includes("spreadsheet") || contentType.includes("excel")) return "spreadsheet";
  if (contentType.includes("presentation") || contentType.includes("powerpoint")) return "presentation";
  return "other";
}

// Extract category from file path
function extractCategoryFromPath(filePath: string): string {
  const pathParts = filePath.split("/");
  if (pathParts.length >= 3) {
    return pathParts[1]; // documents/category/file.ext
  }
  return "uncategorized";
}

// REMOVED: System-generated sync activity logging
// Sync operations are automatic system processes and should not clutter user activity logs
// Only user-initiated actions should be tracked in the activities collection

// Invalidate statistics cache to trigger real-time updates
async function invalidateStatisticsCache(): Promise<void> {
  try {
    await admin
      .firestore()
      .collection("statistics-cache")
      .doc("global-stats")
      .delete();
    
    console.log("🔄 Statistics cache invalidated");
  } catch (error) {
    console.error("❌ Error invalidating statistics cache:", error);
  }
}
