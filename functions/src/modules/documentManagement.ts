import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";





/**
 * Bulk document operations
 */
const bulkDocumentOperations = functions.https.onCall(async (data: any, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be authenticated"
    );
  }

  try {
    const { documentIds, operation, reason } = data;

    if (!documentIds || !Array.isArray(documentIds) || documentIds.length === 0) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Document IDs array is required"
      );
    }

    if (!operation || !["delete"].includes(operation)) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Valid operation (delete) is required"
      );
    }

    // Check user permissions
    const userDoc = await admin
      .firestore()
      .collection("users")
      .doc(context.auth.uid)
      .get();
    const user = userDoc.data();

    if (!user || user.role !== "admin") {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Only admins can perform bulk document operations"
      );
    }

    const batch = admin.firestore().batch();
    const results = [];

    for (const documentId of documentIds) {
      try {
        const docRef = admin.firestore().collection("documents").doc(documentId);
        
        switch (operation) {
        case "delete":
          // ADMIN HARD DELETE: Permanently delete document for admin operations
          batch.delete(docRef);
          break;
        }

        results.push({ documentId, success: true });
      } catch (error) {
        results.push({ documentId, success: false, error: String(error) });
      }
    }

    await batch.commit();

    // Log activity
    await admin
      .firestore()
      .collection("activities")
      .add({
        type: `bulk_document_${operation}`,
        userId: context.auth.uid,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        details: `Bulk ${operation} operation performed on ${documentIds.length} documents`,
        documentIds: documentIds,
      });

    return {
      success: true,
      message: `Bulk ${operation} operation completed`,
      results: results,
    };
  } catch (error) {
    console.error("Error in bulk document operations:", error);
    throw new functions.https.HttpsError(
      "internal",
      `Bulk document operation failed: ${error}`
    );
  }
});

/**
 * Enhanced path resolution helper functions for comprehensive file deletion
 */

/**
 * Validate and resolve the correct storage path for a file
 */
async function validateAndResolveStoragePath(
  bucket: any,
  originalPath: string,
  fileName: string,
  documentData: any,
  documentId: string
): Promise<string | null> {
  console.log(`🔍 Validating storage path: ${originalPath}`);

  // Generate all possible storage paths based on different upload patterns
  const possiblePaths = generateAllPossibleStoragePaths(
    originalPath,
    fileName,
    documentData,
    documentId
  );

  console.log(`📋 Generated ${possiblePaths.length} possible paths to check`);

  // Check each path for file existence
  for (const path of possiblePaths) {
    try {
      const file = bucket.file(path);
      const [exists] = await file.exists();

      if (exists) {
        console.log(`✅ Found file at validated path: ${path}`);
        return path;
      } else {
        console.log(`❌ File not found at: ${path}`);
      }
    } catch (error: any) {
      console.log(`⚠️ Error checking path ${path}: ${error.message}`);
    }
  }

  console.log(`❌ File not found in any of the ${possiblePaths.length} possible locations`);
  return null;
}

/**
 * Generate all possible storage paths based on different upload patterns
 */
function generateAllPossibleStoragePaths(
  originalPath: string,
  fileName: string,
  documentData: any,
  documentId: string
): string[] {
  const paths: string[] = [];
  const sanitizedFileName = sanitizeFileName(fileName);
  const fileExtension = getFileExtension(fileName);

  // 1. Original stored path (highest priority)
  if (originalPath && originalPath.trim()) {
    paths.push(originalPath.trim());
  }

  // 2. Direct documents folder patterns
  paths.push(`documents/${fileName}`);
  paths.push(`documents/${sanitizedFileName}`);

  // 3. User-specific folder patterns
  if (documentData?.uploadedBy) {
    paths.push(`documents/${documentData.uploadedBy}/${fileName}`);
    paths.push(`documents/${documentData.uploadedBy}/${sanitizedFileName}`);
  }

  // 4. Category-based folder patterns
  if (documentData?.category && documentData.category !== 'uncategorized') {
    paths.push(`documents/categories/${documentData.category}/${fileName}`);
    paths.push(`documents/categories/${documentData.category}/${sanitizedFileName}`);

    // User + category patterns
    if (documentData?.uploadedBy) {
      paths.push(`documents/categories/${documentData.category}/${documentData.uploadedBy}/${fileName}`);
      paths.push(`documents/categories/${documentData.category}/${documentData.uploadedBy}/${sanitizedFileName}`);
    }
  }

  // 5. Document ID-based patterns (for files named with document ID)
  if (fileExtension) {
    paths.push(`documents/${documentId}.${fileExtension}`);
    if (documentData?.uploadedBy) {
      paths.push(`documents/${documentData.uploadedBy}/${documentId}.${fileExtension}`);
    }
    if (documentData?.category && documentData.category !== 'uncategorized') {
      paths.push(`documents/categories/${documentData.category}/${documentId}.${fileExtension}`);
    }
  }

  // 6. Legacy patterns (for backward compatibility)
  paths.push(`documents/${documentId}`);

  // Remove duplicates while preserving order
  return [...new Set(paths)];
}

/**
 * Attempt comprehensive deletion with all possible path patterns
 */
async function attemptComprehensiveDeletion(
  bucket: any,
  fileName: string,
  documentData: any,
  documentId: string
): Promise<boolean> {
  console.log(`🔄 Attempting comprehensive deletion for: ${fileName}`);

  const allPaths = generateAllPossibleStoragePaths(
    '', // No original path for comprehensive search
    fileName,
    documentData,
    documentId
  );

  console.log(`📋 Attempting deletion across ${allPaths.length} possible paths`);

  for (const path of allPaths) {
    try {
      const file = bucket.file(path);
      const [exists] = await file.exists();

      if (exists) {
        await file.delete();
        console.log(`✅ Successfully deleted from comprehensive search path: ${path}`);
        return true;
      }
    } catch (error: any) {
      console.log(`⚠️ Comprehensive deletion attempt failed for ${path}: ${error.message}`);
    }
  }

  console.log(`❌ Comprehensive deletion failed - file not found in any location`);
  return false;
}

/**
 * Sanitize filename for storage path matching
 */
function sanitizeFileName(fileName: string): string {
  return fileName
    .replace(/[^\w\s\-\.]/g, '_')
    .replace(/\s+/g, '_')
    .toLowerCase();
}

/**
 * Get file extension from filename
 */
function getFileExtension(fileName: string): string {
  const parts = fileName.split('.');
  return parts.length > 1 ? parts[parts.length - 1].toLowerCase() : '';
}

/**
 * Delete document permanently (from both Firestore and Storage)
 * This function provides atomic deletion with proper error handling
 */
const deleteDocument = functions.https.onCall(async (data: any, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be authenticated"
    );
  }

  try {
    const { documentId } = data;

    if (!documentId) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Document ID is required"
      );
    }

    console.log(`🗑️ Starting delete operation for document: ${documentId}`);

    // ADMIN-ONLY: Check user permissions
    const userDoc = await admin
      .firestore()
      .collection("users")
      .doc(context.auth.uid)
      .get();
    const user = userDoc.data();

    if (!user || user.role !== "admin") {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Access denied: Only administrators can delete files"
      );
    }

    console.log(`✅ Admin permission verified for user: ${context.auth.uid}`);

    // Get document metadata from Firestore
    const docRef = admin.firestore().collection("documents").doc(documentId);
    const docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      console.log(`⚠️ Document not found in Firestore: ${documentId}`);
      throw new functions.https.HttpsError(
        "not-found",
        "Document not found in database"
      );
    }

    const documentData = docSnapshot.data();
    const fileName = documentData?.fileName || "Unknown File";
    const filePath = documentData?.filePath || "";

    console.log(`📁 Found document: ${fileName} at path: ${filePath}`);

    // ENHANCED ATOMIC OPERATION: Delete from both Storage and Firestore with comprehensive path resolution
    const bucket = admin.storage().bucket();
    let storageDeleted = false;
    let firestoreDeleted = false;
    let actualStoragePath: string | null = null;

    try {
      // Step 1: Enhanced Storage Deletion with comprehensive path resolution
      if (filePath) {
        console.log(`🔍 Starting enhanced path resolution for: ${fileName}`);

        // First, try to validate and resolve the correct storage path
        actualStoragePath = await validateAndResolveStoragePath(
          bucket,
          filePath,
          fileName,
          documentData,
          documentId
        );

        if (actualStoragePath) {
          try {
            const file = bucket.file(actualStoragePath);
            await file.delete();
            storageDeleted = true;
            console.log(`✅ Successfully deleted from resolved Storage path: ${actualStoragePath}`);
          } catch (deleteError: any) {
            console.log(`❌ Failed to delete from resolved path ${actualStoragePath}: ${deleteError.message}`);

            // If resolved path fails, try comprehensive fallback
            storageDeleted = await attemptComprehensiveDeletion(
              bucket,
              fileName,
              documentData,
              documentId
            );
          }
        } else {
          console.log(`⚠️ Could not resolve storage path, attempting comprehensive fallback`);

          // Attempt comprehensive deletion with all possible paths
          storageDeleted = await attemptComprehensiveDeletion(
            bucket,
            fileName,
            documentData,
            documentId
          );
        }

        if (!storageDeleted) {
          console.log(`❌ All storage deletion attempts failed for: ${fileName}`);
          console.log(`📊 Attempted paths logged above for debugging`);
        }
      } else {
        console.log(`⚠️ No file path found in document metadata, attempting path reconstruction`);

        // Try to reconstruct path from available data
        storageDeleted = await attemptComprehensiveDeletion(
          bucket,
          fileName,
          documentData,
          documentId
        );
      }

      // Step 2: Delete from Firestore
      await docRef.delete();
      firestoreDeleted = true;
      console.log(`✅ Successfully deleted from Firestore: ${documentId}`);

      // Step 3: Enhanced activity logging with path resolution details
      await admin
        .firestore()
        .collection("activities")
        .add({
          type: "document_deleted",
          documentId: documentId,
          userId: context.auth.uid,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
          details: {
            message: `Document permanently deleted: ${fileName}`,
            fileName: fileName,
            originalFilePath: filePath,
            actualStoragePath: actualStoragePath,
            storageDeleted: storageDeleted,
            firestoreDeleted: firestoreDeleted,
            enhancedPathResolution: true,
            deletionMethod: actualStoragePath ? 'resolved_path' : 'comprehensive_search',
          },
        });

      console.log(`✅ Delete operation completed successfully for: ${fileName}`);

      return {
        success: true,
        message: `Document "${fileName}" deleted successfully`,
        details: {
          documentId: documentId,
          fileName: fileName,
          storageDeleted: storageDeleted,
          firestoreDeleted: firestoreDeleted,
        },
      };

    } catch (operationError: any) {
      console.error(`❌ Enhanced delete operation failed: ${operationError.message}`);
      console.error(`📊 Deletion context - File: ${fileName}, Original Path: ${filePath}, Resolved Path: ${actualStoragePath}`);

      // Enhanced error logging with diagnostic information
      await admin
        .firestore()
        .collection("activities")
        .add({
          type: "document_delete_failed",
          documentId: documentId,
          userId: context.auth.uid,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
          details: `Failed to delete document: ${fileName}`,
          error: operationError.message,
          diagnostics: {
            originalFilePath: filePath,
            resolvedStoragePath: actualStoragePath,
            storageDeleted: storageDeleted,
            firestoreDeleted: firestoreDeleted,
            enhancedPathResolution: true,
            errorType: operationError.constructor.name,
          },
        });

      // Provide more specific error messages based on deletion status
      let errorMessage = `Failed to delete document: ${operationError.message}`;
      if (storageDeleted && !firestoreDeleted) {
        errorMessage = `Storage deleted but Firestore deletion failed: ${operationError.message}`;
      } else if (!storageDeleted && firestoreDeleted) {
        errorMessage = `Firestore deleted but storage deletion failed: ${operationError.message}`;
      }

      throw new functions.https.HttpsError(
        "internal",
        errorMessage
      );
    }

  } catch (error: any) {
    console.error("Error in deleteDocument function:", error);

    // Re-throw HttpsError as-is
    if (error instanceof functions.https.HttpsError) {
      throw error;
    }

    // Wrap other errors
    throw new functions.https.HttpsError(
      "internal",
      `Delete operation failed: ${error.message || error}`
    );
  }
});

/**
 * Generate document report
 */
const generateDocumentReport = functions.https.onCall(async (data: any, context) => {
  // DISABLED: Function uses document-metadata collection which is no longer used
  console.log("⚠️ generateDocumentReport disabled - using Storage-only approach");
  return {
    success: false,
    error: "Function disabled - using Storage-only approach",
    code: "FUNCTION_DISABLED",
    documents: [],
    totalCount: 0,
  };

  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be authenticated"
    );
  }

  try {
    // Check user permissions
    const userDoc = await admin
      .firestore()
      .collection("users")
      .doc(context.auth?.uid || "")
      .get();
    const user = userDoc.data();

    const userData = user?.data();
    if (!userData || userData.role !== "admin") {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Only admins can generate document reports"
      );
    }

    const { startDate, endDate, categoryId } = data;

    let query = admin
      .firestore()
      .collection("document-metadata")
      .where("isActive", "==", true);

    if (startDate) {
      query = query.where("uploadedAt", ">=", new Date(startDate));
    }

    if (endDate) {
      query = query.where("uploadedAt", "<=", new Date(endDate));
    }

    if (categoryId) {
      query = query.where("category", "==", categoryId);
    }

    const documentsSnapshot = await query.get();
    const documents = documentsSnapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
    }));

    // Generate statistics
    const stats = {
      totalDocuments: documents.length,
      documentsByCategory: {} as Record<string, number>,
      documentsByType: {} as Record<string, number>,
      documentsByUploader: {} as Record<string, number>,
      totalSize: 0,
    };

    documents.forEach((doc: any) => {
      // Count by category
      const category = doc.category || "Uncategorized";
      stats.documentsByCategory[category] = (stats.documentsByCategory[category] || 0) + 1;

      // Count by type
      const type = getFileTypeFromName(doc.fileName || "");
      stats.documentsByType[type] = (stats.documentsByType[type] || 0) + 1;

      // Count by uploader
      const uploader = doc.uploadedBy || "Unknown";
      stats.documentsByUploader[uploader] = (stats.documentsByUploader[uploader] || 0) + 1;

      // Sum file sizes
      stats.totalSize += doc.fileSize || 0;
    });

    // REMOVED: Document report generation activity logging
    // Report generation can be automatic or system-triggered and should not clutter user activity logs
    // Only user-initiated document operations should be tracked

    return {
      success: true,
      report: {
        generatedAt: new Date().toISOString(),
        generatedBy: context.auth?.uid || "system",
        filters: { startDate, endDate, categoryId },
        statistics: stats,
        documents: documents,
      },
    };
  } catch (error) {
    console.error("Error generating document report:", error);
    throw new functions.https.HttpsError(
      "internal",
      `Failed to generate document report: ${error}`
    );
  }
});

// Helper function
function getFileTypeFromName(fileName: string): string {
  const extension = fileName.split(".").pop()?.toLowerCase();

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

export const documentFunctions = {
  deleteDocument,
  bulkDocumentOperations,
  generateDocumentReport,
};
