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
exports.documentFunctions = void 0;
const functions = __importStar(require("firebase-functions/v1"));
const admin = __importStar(require("firebase-admin"));
/**
 * Approve a document
 */
const approveDocument = functions.https.onCall(async (data, context) => {
    var _a;
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
        if (!user || !((_a = user.permissions) === null || _a === void 0 ? void 0 : _a.canApproveDocuments)) {
            throw new functions.https.HttpsError("permission-denied", "User does not have permission to approve documents");
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
        if ((documentData === null || documentData === void 0 ? void 0 : documentData.status) !== "pending") {
            throw new functions.https.HttpsError("failed-precondition", "Document is not in pending status");
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
            details: `Document "${documentData === null || documentData === void 0 ? void 0 : documentData.fileName}" approved`,
        });
        console.log(`Document approved successfully: ${documentId}`);
        return {
            success: true,
            message: "Document approved successfully",
        };
    }
    catch (error) {
        console.error("Error approving document:", error);
        if (error instanceof functions.https.HttpsError) {
            throw error;
        }
        throw new functions.https.HttpsError("internal", `Failed to approve document: ${error}`);
    }
});
/**
 * Reject a document
 */
const rejectDocument = functions.https.onCall(async (data, context) => {
    var _a;
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
        if (!user || !((_a = user.permissions) === null || _a === void 0 ? void 0 : _a.canApproveDocuments)) {
            throw new functions.https.HttpsError("permission-denied", "User does not have permission to reject documents");
        }
        const { documentId, rejectionReason } = data;
        if (!rejectionReason || rejectionReason.trim().length === 0) {
            throw new functions.https.HttpsError("invalid-argument", "Rejection reason is required");
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
        if ((documentData === null || documentData === void 0 ? void 0 : documentData.status) !== "pending") {
            throw new functions.https.HttpsError("failed-precondition", "Document is not in pending status");
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
            details: `Document "${documentData === null || documentData === void 0 ? void 0 : documentData.fileName}" rejected: ${rejectionReason}`,
        });
        console.log(`Document rejected successfully: ${documentId}`);
        return {
            success: true,
            message: "Document rejected successfully",
        };
    }
    catch (error) {
        console.error("Error rejecting document:", error);
        if (error instanceof functions.https.HttpsError) {
            throw error;
        }
        throw new functions.https.HttpsError("internal", `Failed to reject document: ${error}`);
    }
});
/**
 * Bulk document operations
 */
const bulkDocumentOperations = functions.https.onCall(async (data, context) => {
    var _a;
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
        if (!user || !((_a = user.permissions) === null || _a === void 0 ? void 0 : _a.canApproveDocuments)) {
            throw new functions.https.HttpsError("permission-denied", "User does not have permission for bulk document operations");
        }
        const { operation, documentIds, reason } = data;
        if (!documentIds || documentIds.length === 0) {
            throw new functions.https.HttpsError("invalid-argument", "No documents specified");
        }
        if ((operation === "reject" || operation === "delete") &&
            (!reason || reason.trim().length === 0)) {
            throw new functions.https.HttpsError("invalid-argument", `Reason is required for ${operation} operation`);
        }
        const results = {
            success: 0,
            failed: 0,
            errors: [],
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
                    const updateData = {
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
                }
                catch (error) {
                    results.failed++;
                    results.errors.push(`Failed to ${operation} document ${documentId}: ${error}`);
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
    }
    catch (error) {
        console.error("Error in bulk document operations:", error);
        if (error instanceof functions.https.HttpsError) {
            throw error;
        }
        throw new functions.https.HttpsError("internal", `Failed to perform bulk document operations: ${error}`);
    }
});
/**
 * Generate document report
 */
const generateDocumentReport = functions.https.onCall(async (data, context) => {
    var _a;
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
        if (!user || !((_a = user.permissions) === null || _a === void 0 ? void 0 : _a.canViewAllDocuments)) {
            throw new functions.https.HttpsError("permission-denied", "User does not have permission to generate reports");
        }
        const { startDate, endDate, categoryId, userId, status } = data;
        // Build query
        let query = admin
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
        const documents = snapshot.docs.map((doc) => (Object.assign({ id: doc.id }, doc.data())));
        // Generate statistics
        const stats = {
            totalDocuments: documents.length,
            byStatus: {},
            byCategory: {},
            byFileType: {},
            totalSize: 0,
            averageSize: 0,
        };
        documents.forEach((doc) => {
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
    }
    catch (error) {
        console.error("Error generating document report:", error);
        if (error instanceof functions.https.HttpsError) {
            throw error;
        }
        throw new functions.https.HttpsError("internal", `Failed to generate document report: ${error}`);
    }
});
exports.documentFunctions = {
    approveDocument,
    rejectDocument,
    bulkDocumentOperations,
    generateDocumentReport,
};
//# sourceMappingURL=documentManagement.js.map