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
exports.categoryFunctions = exports.refreshCategoryContents = exports.getCategoryDocumentsEnhanced = void 0;
const functions = __importStar(require("firebase-functions/v1"));
const admin = __importStar(require("firebase-admin"));
const uuid_1 = require("uuid");
/**
 * Create a new category
 */
const createCategory = functions.https.onCall(async (data, context) => {
    // Verify authentication
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        const { name, description, permissions, isActive } = data;
        const createdBy = context.auth.uid;
        // Validate required fields
        if (!name || name.trim().length === 0) {
            throw new functions.https.HttpsError("invalid-argument", "Category name is required");
        }
        // Check if category name already exists
        const existingCategory = await admin
            .firestore()
            .collection("categories")
            .where("name", "==", name.trim())
            .where("isActive", "==", true)
            .get();
        if (!existingCategory.empty) {
            throw new functions.https.HttpsError("already-exists", "Category with this name already exists");
        }
        // Create category
        const categoryId = (0, uuid_1.v4)();
        const categoryData = {
            id: categoryId,
            name: name.trim(),
            description: (description === null || description === void 0 ? void 0 : description.trim()) || "",
            permissions: permissions || [],
            isActive: isActive !== undefined ? isActive : true,
            createdBy,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            documentCount: 0,
        };
        await admin
            .firestore()
            .collection("categories")
            .doc(categoryId)
            .set(categoryData);
        // Log activity
        await admin
            .firestore()
            .collection("activities")
            .add({
            type: "category_created",
            categoryId,
            userId: createdBy,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            details: `Category "${name}" created`,
        });
        console.log(`Category created successfully: ${categoryId}`);
        return {
            success: true,
            categoryId,
            message: "Category created successfully",
        };
    }
    catch (error) {
        console.error("Error creating category:", error);
        if (error instanceof functions.https.HttpsError) {
            throw error;
        }
        throw new functions.https.HttpsError("internal", `Failed to create category: ${error}`);
    }
});
/**
 * Update an existing category
 */
const updateCategory = functions.https.onCall(async (data, context) => {
    var _a, _b;
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        const { categoryId, name, description, permissions, isActive } = data;
        const updatedBy = context.auth.uid;
        // Validate category exists
        const categoryRef = admin
            .firestore()
            .collection("categories")
            .doc(categoryId);
        const categoryDoc = await categoryRef.get();
        if (!categoryDoc.exists) {
            throw new functions.https.HttpsError("not-found", "Category not found");
        }
        // Check if new name already exists (if name is being updated)
        if (name && name.trim() !== ((_a = categoryDoc.data()) === null || _a === void 0 ? void 0 : _a.name)) {
            const existingCategory = await admin
                .firestore()
                .collection("categories")
                .where("name", "==", name.trim())
                .where("isActive", "==", true)
                .get();
            if (!existingCategory.empty) {
                throw new functions.https.HttpsError("already-exists", "Category with this name already exists");
            }
        }
        // Prepare update data
        const updateData = {
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            updatedBy,
        };
        if (name !== undefined)
            updateData.name = name.trim();
        if (description !== undefined)
            updateData.description = description.trim();
        if (permissions !== undefined)
            updateData.permissions = permissions;
        if (isActive !== undefined)
            updateData.isActive = isActive;
        await categoryRef.update(updateData);
        // Log activity
        await admin
            .firestore()
            .collection("activities")
            .add({
            type: "category_updated",
            categoryId,
            userId: updatedBy,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            details: `Category "${(_b = categoryDoc.data()) === null || _b === void 0 ? void 0 : _b.name}" updated`,
        });
        console.log(`Category updated successfully: ${categoryId}`);
        return {
            success: true,
            message: "Category updated successfully",
        };
    }
    catch (error) {
        console.error("Error updating category:", error);
        if (error instanceof functions.https.HttpsError) {
            throw error;
        }
        throw new functions.https.HttpsError("internal", `Failed to update category: ${error}`);
    }
});
/**
 * Delete a category (soft delete)
 */
const deleteCategory = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        const { categoryId } = data;
        const deletedBy = context.auth.uid;
        // Validate category exists
        const categoryRef = admin
            .firestore()
            .collection("categories")
            .doc(categoryId);
        const categoryDoc = await categoryRef.get();
        if (!categoryDoc.exists) {
            throw new functions.https.HttpsError("not-found", "Category not found");
        }
        const categoryData = categoryDoc.data();
        // Check if category has documents
        const documentsInCategory = await admin
            .firestore()
            .collection("documents")
            .where("category", "==", categoryId)
            .where("isActive", "==", true)
            .get();
        if (!documentsInCategory.empty) {
            // Move documents to uncategorized
            const batch = admin.firestore().batch();
            documentsInCategory.docs.forEach((doc) => {
                batch.update(doc.ref, {
                    category: "uncategorized",
                    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                });
            });
            await batch.commit();
        }
        // Soft delete category
        await categoryRef.update({
            isActive: false,
            deletedBy,
            deletedAt: admin.firestore.FieldValue.serverTimestamp(),
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        // Log activity
        await admin
            .firestore()
            .collection("activities")
            .add({
            type: "category_deleted",
            categoryId,
            userId: deletedBy,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            details: `Category "${categoryData === null || categoryData === void 0 ? void 0 : categoryData.name}" deleted`,
        });
        console.log(`Category deleted successfully: ${categoryId}`);
        return {
            success: true,
            message: "Category deleted successfully",
            movedDocuments: documentsInCategory.size,
        };
    }
    catch (error) {
        console.error("Error deleting category:", error);
        if (error instanceof functions.https.HttpsError) {
            throw error;
        }
        throw new functions.https.HttpsError("internal", `Failed to delete category: ${error}`);
    }
});
/**
 * Add files to a category
 */
const addFilesToCategory = functions.https.onCall(async (data, context) => {
    var _a;
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        const { categoryId, documentIds } = data;
        const userId = context.auth.uid;
        // Validate category exists
        const categoryDoc = await admin
            .firestore()
            .collection("categories")
            .doc(categoryId)
            .get();
        if (!categoryDoc.exists) {
            throw new functions.https.HttpsError("not-found", "Category not found");
        }
        // Update documents in batches
        const batchSize = 500; // Firestore batch limit
        const batches = [];
        for (let i = 0; i < documentIds.length; i += batchSize) {
            const batch = admin.firestore().batch();
            const batchDocumentIds = documentIds.slice(i, i + batchSize);
            for (const documentId of batchDocumentIds) {
                const docRef = admin
                    .firestore()
                    .collection("documents")
                    .doc(documentId);
                batch.update(docRef, {
                    category: categoryId,
                    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                });
            }
            batches.push(batch.commit());
        }
        await Promise.all(batches);
        // Update category document count
        await admin
            .firestore()
            .collection("categories")
            .doc(categoryId)
            .update({
            documentCount: admin.firestore.FieldValue.increment(documentIds.length),
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        // Log activity
        await admin
            .firestore()
            .collection("activities")
            .add({
            type: "files_added_to_category",
            categoryId,
            userId,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            details: `${documentIds.length} files added to category "${(_a = categoryDoc.data()) === null || _a === void 0 ? void 0 : _a.name}"`,
        });
        console.log(`${documentIds.length} files added to category: ${categoryId}`);
        return {
            success: true,
            message: `${documentIds.length} files added to category successfully`,
        };
    }
    catch (error) {
        console.error("Error adding files to category:", error);
        if (error instanceof functions.https.HttpsError) {
            throw error;
        }
        throw new functions.https.HttpsError("internal", `Failed to add files to category: ${error}`);
    }
});
/**
 * Remove files from a category
 */
const removeFilesFromCategory = functions.https.onCall(async (data, context) => {
    var _a;
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        const { categoryId, documentIds } = data;
        const userId = context.auth.uid;
        // Validate category exists
        const categoryDoc = await admin
            .firestore()
            .collection("categories")
            .doc(categoryId)
            .get();
        if (!categoryDoc.exists) {
            throw new functions.https.HttpsError("not-found", "Category not found");
        }
        // Update documents in batches
        const batchSize = 500;
        const batches = [];
        for (let i = 0; i < documentIds.length; i += batchSize) {
            const batch = admin.firestore().batch();
            const batchDocumentIds = documentIds.slice(i, i + batchSize);
            for (const documentId of batchDocumentIds) {
                const docRef = admin
                    .firestore()
                    .collection("documents")
                    .doc(documentId);
                batch.update(docRef, {
                    category: "uncategorized",
                    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                });
            }
            batches.push(batch.commit());
        }
        await Promise.all(batches);
        // Update category document count
        await admin
            .firestore()
            .collection("categories")
            .doc(categoryId)
            .update({
            documentCount: admin.firestore.FieldValue.increment(-documentIds.length),
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        // Log activity
        await admin
            .firestore()
            .collection("activities")
            .add({
            type: "files_removed_from_category",
            categoryId,
            userId,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            details: `${documentIds.length} files removed from category "${(_a = categoryDoc.data()) === null || _a === void 0 ? void 0 : _a.name}"`,
        });
        console.log(`${documentIds.length} files removed from category: ${categoryId}`);
        return {
            success: true,
            message: `${documentIds.length} files removed from category successfully`,
        };
    }
    catch (error) {
        console.error("Error removing files from category:", error);
        if (error instanceof functions.https.HttpsError) {
            throw error;
        }
        throw new functions.https.HttpsError("internal", `Failed to remove files from category: ${error}`);
    }
});
// Enhanced category document retrieval with real-time support
exports.getCategoryDocumentsEnhanced = functions.https.onCall(async (data, context) => {
    try {
        // Verify authentication
        if (!context.auth) {
            throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
        }
        const { categoryId, includeMetadata = true } = data;
        if (!categoryId) {
            throw new functions.https.HttpsError("invalid-argument", "Category ID is required");
        }
        console.log(`Getting enhanced documents for category: ${categoryId}`);
        // Get documents from Firestore with proper ordering
        const documentsSnapshot = await admin
            .firestore()
            .collection("documents")
            .where("category", "==", categoryId)
            .orderBy("uploadedAt", "desc")
            .get();
        const documents = documentsSnapshot.docs.map((doc) => (Object.assign({ id: doc.id }, doc.data())));
        // Get category metadata if requested
        let categoryMetadata = null;
        if (includeMetadata) {
            const categoryDoc = await admin
                .firestore()
                .collection("categories")
                .doc(categoryId)
                .get();
            if (categoryDoc.exists) {
                categoryMetadata = Object.assign({ id: categoryDoc.id }, categoryDoc.data());
            }
        }
        console.log(`Retrieved ${documents.length} documents for category: ${categoryId}`);
        return {
            success: true,
            documents,
            categoryMetadata,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
        };
    }
    catch (error) {
        console.error("Error getting category documents:", error);
        throw new functions.https.HttpsError("internal", `Failed to get category documents: ${error}`);
    }
});
// Force refresh category contents from Firebase
exports.refreshCategoryContents = functions.https.onCall(async (data, context) => {
    try {
        // Verify authentication
        if (!context.auth) {
            throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
        }
        const { categoryId } = data;
        console.log(`Force refreshing category contents: ${categoryId || "all"}`);
        let documentsQuery = admin.firestore().collection("documents");
        // Filter by category if specified
        if (categoryId) {
            documentsQuery = documentsQuery.where("category", "==", categoryId);
        }
        const documentsSnapshot = await documentsQuery
            .orderBy("uploadedAt", "desc")
            .get();
        const documents = documentsSnapshot.docs.map((doc) => (Object.assign({ id: doc.id }, doc.data())));
        // Group documents by category
        const categorizedDocuments = {};
        documents.forEach((doc) => {
            const category = doc.category || "uncategorized";
            if (!categorizedDocuments[category]) {
                categorizedDocuments[category] = [];
            }
            categorizedDocuments[category].push(doc);
        });
        // Log activity
        await admin
            .firestore()
            .collection("activities")
            .add({
            type: "category_contents_refreshed",
            categoryId: categoryId || "all",
            userId: context.auth.uid,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            details: `Refreshed ${documents.length} documents in ${Object.keys(categorizedDocuments).length} categories`,
        });
        console.log(`Refreshed ${documents.length} documents in ${Object.keys(categorizedDocuments).length} categories`);
        return {
            success: true,
            documents,
            categorizedDocuments,
            totalDocuments: documents.length,
            totalCategories: Object.keys(categorizedDocuments).length,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
        };
    }
    catch (error) {
        console.error("Error refreshing category contents:", error);
        throw new functions.https.HttpsError("internal", `Failed to refresh category contents: ${error}`);
    }
});
exports.categoryFunctions = {
    createCategory,
    updateCategory,
    deleteCategory,
    addFilesToCategory,
    removeFilesFromCategory,
    getCategoryDocumentsEnhanced: exports.getCategoryDocumentsEnhanced,
    refreshCategoryContents: exports.refreshCategoryContents,
};
//# sourceMappingURL=categoryManagement.js.map