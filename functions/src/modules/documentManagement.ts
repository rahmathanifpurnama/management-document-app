import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";

interface ApproveDocumentData {
  documentId: string;
  approvalNotes?: string;
}

interface RejectDocumentData {
  documentId: string;
  rejectionReason: string;
}

interface BulkDocumentOperationData {
  operation: "approve" | "reject" | "delete" | "archive";
  documentIds: string[];
  reason?: string;
}

interface GenerateReportData {
  startDate: string;
  endDate: string;
  categoryId?: string;
  userId?: string;
  status?: string;
}

/**
 * Approve a document
 */
const approveDocument = functions.https.onCall(
  async (data: ApproveDocumentData, context) => {
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

      if (!user || !user.permissions?.canApproveDocuments) {
        throw new functions.https.HttpsError(
          "permission-denied",
          "User does not have permission to approve documents"
        );
      }

      const { documentId, approvalNotes } = data;

      // Validate document exists
      const documentRef = admin
        .firestore()
        .collection("documents")
        .doc(documentId);
      const documentDoc = await documentRef.get();

      if (!documentDoc.exists) {
        throw new functions.https.HttpsError("not-found", "Document not found");
      }

      const documentData = documentDoc.data();

      // Check if document is in pending status
      if (documentData?.status !== "pending") {
        throw new functions.https.HttpsError(
          "failed-precondition",
          "Document is not in pending status"
        );
      }

      // Update document status
      await documentRef.update({
        status: "approved",
        approvedBy: context.auth.uid,
        approvedAt: admin.firestore.FieldValue.serverTimestamp(),
        approvalNotes: approvalNotes || "",
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Log activity
      await admin
        .firestore()
        .collection("activities")
        .add({
          type: "document_approved",
          documentId,
          userId: context.auth.uid,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
          details: `Document "${documentData?.fileName}" approved`,
        });

      console.log(`Document approved successfully: ${documentId}`);

      return {
        success: true,
        message: "Document approved successfully",
      };
    } catch (error) {
      console.error("Error approving document:", error);
      if (error instanceof functions.https.HttpsError) {
        throw error;
      }
      throw new functions.https.HttpsError(
        "internal",
        `Failed to approve document: ${error}`
      );
    }
  }
);

/**
 * Reject a document
 */
const rejectDocument = functions.https.onCall(
  async (data: RejectDocumentData, context) => {
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

      if (!user || !user.permissions?.canApproveDocuments) {
        throw new functions.https.HttpsError(
          "permission-denied",
          "User does not have permission to reject documents"
        );
      }

      const { documentId, rejectionReason } = data;

      if (!rejectionReason || rejectionReason.trim().length === 0) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "Rejection reason is required"
        );
      }

      // Validate document exists
      const documentRef = admin
        .firestore()
        .collection("documents")
        .doc(documentId);
      const documentDoc = await documentRef.get();

      if (!documentDoc.exists) {
        throw new functions.https.HttpsError("not-found", "Document not found");
      }

      const documentData = documentDoc.data();

      // Check if document is in pending status
      if (documentData?.status !== "pending") {
        throw new functions.https.HttpsError(
          "failed-precondition",
          "Document is not in pending status"
        );
      }

      // Update document status
      await documentRef.update({
        status: "rejected",
        rejectedBy: context.auth.uid,
        rejectedAt: admin.firestore.FieldValue.serverTimestamp(),
        rejectionReason: rejectionReason.trim(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Log activity
      await admin
        .firestore()
        .collection("activities")
        .add({
          type: "document_rejected",
          documentId,
          userId: context.auth.uid,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
          details: `Document "${documentData?.fileName}" rejected: ${rejectionReason}`,
        });

      console.log(`Document rejected successfully: ${documentId}`);

      return {
        success: true,
        message: "Document rejected successfully",
      };
    } catch (error) {
      console.error("Error rejecting document:", error);
      if (error instanceof functions.https.HttpsError) {
        throw error;
      }
      throw new functions.https.HttpsError(
        "internal",
        `Failed to reject document: ${error}`
      );
    }
  }
);

/**
 * Bulk document operations
 */
const bulkDocumentOperations = functions.https.onCall(
  async (data: BulkDocumentOperationData, context) => {
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

      if (!user || !user.permissions?.canApproveDocuments) {
        throw new functions.https.HttpsError(
          "permission-denied",
          "User does not have permission for bulk document operations"
        );
      }

      const { operation, documentIds, reason } = data;

      if (!documentIds || documentIds.length === 0) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "No documents specified"
        );
      }

      if (
        (operation === "reject" || operation === "delete") &&
        (!reason || reason.trim().length === 0)
      ) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          `Reason is required for ${operation} operation`
        );
      }

      const results = {
        success: 0,
        failed: 0,
        errors: [] as string[],
      };

      // Process documents in batches
      const batchSize = 500;
      for (let i = 0; i < documentIds.length; i += batchSize) {
        const batch = admin.firestore().batch();
        const batchDocumentIds = documentIds.slice(i, i + batchSize);

        for (const documentId of batchDocumentIds) {
          try {
            const docRef = admin
              .firestore()
              .collection("documents")
              .doc(documentId);
            const docSnapshot = await docRef.get();

            if (!docSnapshot.exists) {
              results.failed++;
              results.errors.push(`Document ${documentId} not found`);
              continue;
            }

            const updateData: any = {
              updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            };

            switch (operation) {
            case "approve":
              updateData.status = "approved";
              updateData.approvedBy = context.auth.uid;
              updateData.approvedAt =
                  admin.firestore.FieldValue.serverTimestamp();
              break;

            case "reject":
              updateData.status = "rejected";
              updateData.rejectedBy = context.auth.uid;
              updateData.rejectedAt =
                  admin.firestore.FieldValue.serverTimestamp();
              updateData.rejectionReason = reason;
              break;

            case "delete":
              updateData.isActive = false;
              updateData.deletedBy = context.auth.uid;
              updateData.deletedAt =
                  admin.firestore.FieldValue.serverTimestamp();
              updateData.deletionReason = reason;
              break;

            case "archive":
              updateData.status = "archived";
              updateData.archivedBy = context.auth.uid;
              updateData.archivedAt =
                  admin.firestore.FieldValue.serverTimestamp();
              break;
            }

            batch.update(docRef, updateData);
            results.success++;
          } catch (error) {
            results.failed++;
            results.errors.push(
              `Failed to ${operation} document ${documentId}: ${error}`
            );
          }
        }

        await batch.commit();
      }

      // Log activity
      await admin
        .firestore()
        .collection("activities")
        .add({
          type: "bulk_document_operation",
          operation,
          userId: context.auth.uid,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
          details: `Bulk ${operation} operation: ${results.success} successful, ${results.failed} failed`,
        });

      console.log(`Bulk ${operation} operation completed:`, results);

      return {
        success: true,
        results,
        message: `Bulk ${operation} operation completed`,
      };
    } catch (error) {
      console.error("Error in bulk document operations:", error);
      if (error instanceof functions.https.HttpsError) {
        throw error;
      }
      throw new functions.https.HttpsError(
        "internal",
        `Failed to perform bulk document operations: ${error}`
      );
    }
  }
);

/**
 * Generate document report
 */
const generateDocumentReport = functions.https.onCall(
  async (data: GenerateReportData, context) => {
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

      if (!user || !user.permissions?.canViewAllDocuments) {
        throw new functions.https.HttpsError(
          "permission-denied",
          "User does not have permission to generate reports"
        );
      }

      const { startDate, endDate, categoryId, userId, status } = data;

      // Build query
      let query: admin.firestore.Query = admin
        .firestore()
        .collection("documents");

      // Add date filters
      if (startDate) {
        query = query.where("uploadedAt", ">=", new Date(startDate));
      }
      if (endDate) {
        query = query.where("uploadedAt", "<=", new Date(endDate));
      }

      // Add additional filters
      if (categoryId) {
        query = query.where("category", "==", categoryId);
      }
      if (userId) {
        query = query.where("uploadedBy", "==", userId);
      }
      if (status) {
        query = query.where("status", "==", status);
      }

      // Execute query
      const snapshot = await query.get();
      const documents = snapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      }));

      // Generate statistics
      const stats = {
        totalDocuments: documents.length,
        byStatus: {} as Record<string, number>,
        byCategory: {} as Record<string, number>,
        byFileType: {} as Record<string, number>,
        totalSize: 0,
        averageSize: 0,
      };

      documents.forEach((doc: any) => {
        // Count by status
        stats.byStatus[doc.status] = (stats.byStatus[doc.status] || 0) + 1;

        // Count by category
        stats.byCategory[doc.category] =
          (stats.byCategory[doc.category] || 0) + 1;

        // Count by file type
        stats.byFileType[doc.fileType] =
          (stats.byFileType[doc.fileType] || 0) + 1;

        // Calculate total size
        if (doc.fileSize) {
          stats.totalSize += doc.fileSize;
        }
      });

      stats.averageSize =
        documents.length > 0 ? stats.totalSize / documents.length : 0;

      // Log activity
      await admin
        .firestore()
        .collection("activities")
        .add({
          type: "report_generated",
          userId: context.auth.uid,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
          details: `Document report generated for ${documents.length} documents`,
        });

      console.log(`Document report generated: ${documents.length} documents`);

      return {
        success: true,
        report: {
          documents,
          statistics: stats,
          generatedAt: new Date().toISOString(),
          generatedBy: context.auth.uid,
          filters: { startDate, endDate, categoryId, userId, status },
        },
      };
    } catch (error) {
      console.error("Error generating document report:", error);
      if (error instanceof functions.https.HttpsError) {
        throw error;
      }
      throw new functions.https.HttpsError(
        "internal",
        `Failed to generate document report: ${error}`
      );
    }
  }
);

export const documentFunctions = {
  approveDocument,
  rejectDocument,
  bulkDocumentOperations,
  generateDocumentReport,
};
