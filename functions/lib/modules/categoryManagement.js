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
    var _a;
    // Verify authentication
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        // Check if current user is admin
        const currentUserDoc = await admin
            .firestore()
            .collection("users")
            .doc(context.auth.uid)
            .get();
        const currentUser = currentUserDoc.data();
        // Debug logging
        console.log("🔍 Current user data:", {
            uid: context.auth.uid,
            email: (_a = context.auth.token) === null || _a === void 0 ? void 0 : _a.email,
            userExists: !!currentUser,
            role: currentUser === null || currentUser === void 0 ? void 0 : currentUser.role,
            status: currentUser === null || currentUser === void 0 ? void 0 : currentUser.status,
            isActive: currentUser === null || currentUser === void 0 ? void 0 : currentUser.isActive
        });
        if (!currentUser) {
            throw new functions.https.HttpsError("permission-denied", "User document not found in Firestore");
        }
        if (currentUser.role !== "admin") {
            throw new functions.https.HttpsError("permission-denied", "Only admin users can create categories");
        }
        // Check if user is active (support both old and new field structure)
        const isUserActive = currentUser.status === "active" || currentUser.isActive === true;
        if (!isUserActive) {
            throw new functions.https.HttpsError("permission-denied", "Only active admin users can create categories");
        }
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
            details: {
                message: `Category "${name}" created`,
                categoryName: name,
                categoryId: categoryId,
                createdBy: createdBy,
            },
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
        // Check if current user is admin
        const currentUserDoc = await admin
            .firestore()
            .collection("users")
            .doc(context.auth.uid)
            .get();
        const currentUser = currentUserDoc.data();
        if (!currentUser) {
            throw new functions.https.HttpsError("permission-denied", "User document not found in Firestore");
        }
        if (currentUser.role !== "admin") {
            throw new functions.https.HttpsError("permission-denied", "Only admin users can update categories");
        }
        // Check if user is active (support both old and new field structure)
        const isUserActive = currentUser.status === "active" || currentUser.isActive === true;
        if (!isUserActive) {
            throw new functions.https.HttpsError("permission-denied", "Only active admin users can update categories");
        }
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
        // Check if current user is admin
        const currentUserDoc = await admin
            .firestore()
            .collection("users")
            .doc(context.auth.uid)
            .get();
        const currentUser = currentUserDoc.data();
        if (!currentUser) {
            throw new functions.https.HttpsError("permission-denied", "User document not found in Firestore");
        }
        if (currentUser.role !== "admin") {
            throw new functions.https.HttpsError("permission-denied", "Only admin users can delete categories");
        }
        // Check if user is active (support both old and new field structure)
        const isUserActive = currentUser.status === "active" || currentUser.isActive === true;
        if (!isUserActive) {
            throw new functions.https.HttpsError("permission-denied", "Only active admin users can delete categories");
        }
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
        // STEP 1: Find all documents that have this category ID
        console.log(`🔍 Finding all documents with category: ${categoryId}`);
        const documentsQuery = await admin
            .firestore()
            .collection("documents")
            .where("category", "==", categoryId)
            .get();
        let movedDocuments = 0;
        // STEP 2: Clear category field from all documents in batches
        if (!documentsQuery.empty) {
            console.log(`📋 Found ${documentsQuery.size} documents to update`);
            const batchSize = 500; // Firestore batch limit
            const batches = [];
            let currentBatch = admin.firestore().batch();
            let operationCount = 0;
            for (const docSnapshot of documentsQuery.docs) {
                const docRef = admin.firestore().collection("documents").doc(docSnapshot.id);
                // Clear the category field (set to empty string)
                currentBatch.update(docRef, {
                    category: "",
                    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                });
                operationCount++;
                movedDocuments++;
                // If we've reached the batch limit, add to batches array and create new batch
                if (operationCount === batchSize) {
                    batches.push(currentBatch);
                    currentBatch = admin.firestore().batch();
                    operationCount = 0;
                }
            }
            // Add the last batch if it has operations
            if (operationCount > 0) {
                batches.push(currentBatch);
            }
            // Execute all batches
            console.log(`🔄 Executing ${batches.length} batch operations...`);
            await Promise.all(batches.map(batch => batch.commit()));
            console.log(`✅ Successfully cleared category from ${movedDocuments} documents`);
        }
        else {
            console.log("📝 No documents found with this category ID");
        }
        // STEP 3: Delete the category document
        await categoryRef.delete();
        console.log(`🗑️ Category document deleted: ${categoryId}`);
        // STEP 4: Log activity with detailed information
        await admin
            .firestore()
            .collection("activities")
            .add({
            type: "category_deleted",
            categoryId,
            userId: deletedBy,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            details: `Category "${categoryData === null || categoryData === void 0 ? void 0 : categoryData.name}" deleted and ${movedDocuments} documents moved to uncategorized`,
            metadata: {
                categoryName: categoryData === null || categoryData === void 0 ? void 0 : categoryData.name,
                documentsAffected: movedDocuments,
                deletionMethod: "hard_delete_with_document_cleanup",
            },
        });
        console.log(`✅ Category deleted successfully: ${categoryId} (${movedDocuments} documents updated)`);
        return {
            success: true,
            message: `Category deleted successfully. ${movedDocuments} documents moved to uncategorized.`,
            movedDocuments: movedDocuments,
            categoryName: categoryData === null || categoryData === void 0 ? void 0 : categoryData.name,
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
    var _a, _b;
    // DISABLED: Function uses document-metadata collection which is no longer used
    console.log("⚠️ addFilesToCategory disabled - using Storage-only approach");
    return {
        success: false,
        error: "Function disabled - using Storage-only approach",
        code: "FUNCTION_DISABLED",
    };
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        const { categoryId, documentIds } = data;
        const userId = (_a = context.auth) === null || _a === void 0 ? void 0 : _a.uid;
        if (!userId) {
            throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
        }
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
                    .collection("document-metadata")
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
            details: `${documentIds.length} files added to category "${(_b = categoryDoc.data()) === null || _b === void 0 ? void 0 : _b.name}"`,
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
    var _a, _b;
    // DISABLED: Function uses document-metadata collection which is no longer used
    console.log("⚠️ removeFilesFromCategory disabled - using Storage-only approach");
    return {
        success: false,
        error: "Function disabled - using Storage-only approach",
        code: "FUNCTION_DISABLED",
    };
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        const { categoryId, documentIds } = data;
        const userId = (_a = context.auth) === null || _a === void 0 ? void 0 : _a.uid;
        if (!userId) {
            throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
        }
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
                    .collection("document-metadata")
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
            details: `${documentIds.length} files removed from category "${(_b = categoryDoc.data()) === null || _b === void 0 ? void 0 : _b.name}"`,
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
    // DISABLED: Function uses document-metadata collection which is no longer used
    console.log("⚠️ getCategoryDocumentsEnhanced disabled - using Storage-only approach");
    return {
        success: false,
        error: "Function disabled - using Storage-only approach",
        code: "FUNCTION_DISABLED",
        documents: [],
        categoryMetadata: null,
    };
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
    var _a;
    // DISABLED: Function uses document-metadata collection which is no longer used
    console.log("⚠️ refreshCategoryContents disabled - using Storage-only approach");
    return {
        success: false,
        error: "Function disabled - using Storage-only approach",
        code: "FUNCTION_DISABLED",
        refreshedCount: 0,
    };
    try {
        // Verify authentication
        if (!context.auth) {
            throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
        }
        const { categoryId } = data;
        console.log(`Force refreshing category contents: ${categoryId || "all"}`);
        let documentsQuery = admin.firestore().collection("document-metadata");
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
            userId: ((_a = context.auth) === null || _a === void 0 ? void 0 : _a.uid) || "system",
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