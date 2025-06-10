import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";

/**
 * Approve a document (simplified without status management)
 */
const approveDocument = functions.https.onCall(async (data: any, context) => {
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
        "Only admins can approve documents"
      );
    }

    // Update document
    await admin
      .firestore()
      .collection("documents")
      .doc(documentId)
      .update({
        approvedBy: context.auth.uid,
        approvedAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

    // Log activity
    await admin
      .firestore()
      .collection("activities")
      .add({
        type: "document_approved",
        documentId: documentId,
        userId: context.auth.uid,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        details: `Document approved by admin`,
      });

    return {
      success: true,
      message: "Document approved successfully",
    };
  } catch (error) {
    console.error("Error approving document:", error);
    throw new functions.https.HttpsError(
      "internal",
      `Failed to approve document: ${error}`
    );
  }
});

/**
 * Reject a document (simplified without status management)
 */
const rejectDocument = functions.https.onCall(async (data: any, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be authenticated"
    );
  }

  try {
    const { documentId, reason } = data;

    if (!documentId) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Document ID is required"
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
        "Only admins can reject documents"
      );
    }

    // Update document
    await admin
      .firestore()
      .collection("documents")
      .doc(documentId)
      .update({
        rejectedBy: context.auth.uid,
        rejectedAt: admin.firestore.FieldValue.serverTimestamp(),
        rejectionReason: reason || "No reason provided",
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

    // Log activity
    await admin
      .firestore()
      .collection("activities")
      .add({
        type: "document_rejected",
        documentId: documentId,
        userId: context.auth.uid,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        details: `Document rejected by admin: ${reason || "No reason provided"}`,
      });

    return {
      success: true,
      message: "Document rejected successfully",
    };
  } catch (error) {
    console.error("Error rejecting document:", error);
    throw new functions.https.HttpsError(
      "internal",
      `Failed to reject document: ${error}`
    );
  }
});

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

    if (!operation || !["approve", "reject", "delete"].includes(operation)) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Valid operation (approve, reject, delete) is required"
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
          case "approve":
            batch.update(docRef, {
              approvedBy: context.auth.uid,
              approvedAt: admin.firestore.FieldValue.serverTimestamp(),
              updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            });
            break;
          case "reject":
            batch.update(docRef, {
              rejectedBy: context.auth.uid,
              rejectedAt: admin.firestore.FieldValue.serverTimestamp(),
              rejectionReason: reason || "Bulk rejection",
              updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            });
            break;
          case "delete":
            batch.update(docRef, {
              isActive: false,
              deletedBy: context.auth.uid,
              deletedAt: admin.firestore.FieldValue.serverTimestamp(),
              updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            });
            break;
        }

        results.push({ documentId, success: true });
      } catch (error) {
        results.push({ documentId, success: false, error: error.toString() });
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
 * Generate document report
 */
const generateDocumentReport = functions.https.onCall(async (data: any, context) => {
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
      .doc(context.auth.uid)
      .get();
    const user = userDoc.data();

    if (!user || user.role !== "admin") {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Only admins can generate document reports"
      );
    }

    const { startDate, endDate, categoryId } = data;

    let query = admin
      .firestore()
      .collection("documents")
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
      documentsByCategory: {},
      documentsByType: {},
      documentsByUploader: {},
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

    // Log activity
    await admin
      .firestore()
      .collection("activities")
      .add({
        type: "document_report_generated",
        userId: context.auth.uid,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        details: `Document report generated for ${documents.length} documents`,
      });

    return {
      success: true,
      report: {
        generatedAt: new Date().toISOString(),
        generatedBy: context.auth.uid,
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
  approveDocument,
  rejectDocument,
  bulkDocumentOperations,
  generateDocumentReport,
};
