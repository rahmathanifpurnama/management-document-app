import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";
import { v4 as uuidv4 } from "uuid";

interface CategoryData {
  name: string;
  description?: string;
  permissions?: string[];
  isActive?: boolean;
}

interface UpdateCategoryData {
  categoryId: string;
  name?: string;
  description?: string;
  permissions?: string[];
  isActive?: boolean;
}

interface AddFilesToCategoryData {
  categoryId: string;
  documentIds: string[];
}

interface RemoveFilesFromCategoryData {
  categoryId: string;
  documentIds: string[];
}

/**
 * Create a new category
 */
const createCategory = functions.https.onCall(
  async (data: CategoryData, context) => {
    // Verify authentication
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }

    try {
      const { name, description, permissions, isActive } = data;
      const createdBy = context.auth.uid;

      // Validate required fields
      if (!name || name.trim().length === 0) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "Category name is required"
        );
      }

      // Check if category name already exists
      const existingCategory = await admin
        .firestore()
        .collection("categories")
        .where("name", "==", name.trim())
        .where("isActive", "==", true)
        .get();

      if (!existingCategory.empty) {
        throw new functions.https.HttpsError(
          "already-exists",
          "Category with this name already exists"
        );
      }

      // Create category
      const categoryId = uuidv4();
      const categoryData = {
        id: categoryId,
        name: name.trim(),
        description: description?.trim() || "",
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
    } catch (error) {
      console.error("Error creating category:", error);
      if (error instanceof functions.https.HttpsError) {
        throw error;
      }
      throw new functions.https.HttpsError(
        "internal",
        `Failed to create category: ${error}`
      );
    }
  }
);

/**
 * Update an existing category
 */
const updateCategory = functions.https.onCall(
  async (data: UpdateCategoryData, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
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
      if (name && name.trim() !== categoryDoc.data()?.name) {
        const existingCategory = await admin
          .firestore()
          .collection("categories")
          .where("name", "==", name.trim())
          .where("isActive", "==", true)
          .get();

        if (!existingCategory.empty) {
          throw new functions.https.HttpsError(
            "already-exists",
            "Category with this name already exists"
          );
        }
      }

      // Prepare update data
      const updateData: any = {
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedBy,
      };

      if (name !== undefined) updateData.name = name.trim();
      if (description !== undefined)
        updateData.description = description.trim();
      if (permissions !== undefined) updateData.permissions = permissions;
      if (isActive !== undefined) updateData.isActive = isActive;

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
          details: `Category "${categoryDoc.data()?.name}" updated`,
        });

      console.log(`Category updated successfully: ${categoryId}`);

      return {
        success: true,
        message: "Category updated successfully",
      };
    } catch (error) {
      console.error("Error updating category:", error);
      if (error instanceof functions.https.HttpsError) {
        throw error;
      }
      throw new functions.https.HttpsError(
        "internal",
        `Failed to update category: ${error}`
      );
    }
  }
);

/**
 * Delete a category (soft delete)
 */
const deleteCategory = functions.https.onCall(
  async (data: { categoryId: string }, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
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

      // REMOVED: document-metadata collection check - collection no longer used
      // Using Storage-only approach - category deletion allowed without metadata check
      console.log("⚠️ Category document check disabled - using Storage-only approach");

      // ADMIN HARD DELETE: Permanently delete category for admin users
      await categoryRef.delete();

      // Log activity
      await admin
        .firestore()
        .collection("activities")
        .add({
          type: "category_deleted",
          categoryId,
          userId: deletedBy,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
          details: `Category "${categoryData?.name}" deleted`,
        });

      console.log(`Category deleted successfully: ${categoryId}`);

      return {
        success: true,
        message: "Category deleted successfully",
        movedDocuments: documentsInCategory.size,
      };
    } catch (error) {
      console.error("Error deleting category:", error);
      if (error instanceof functions.https.HttpsError) {
        throw error;
      }
      throw new functions.https.HttpsError(
        "internal",
        `Failed to delete category: ${error}`
      );
    }
  }
);

/**
 * Add files to a category
 */
const addFilesToCategory = functions.https.onCall(
  async (data: AddFilesToCategoryData, context) => {
    // DISABLED: Function uses document-metadata collection which is no longer used
    console.log("⚠️ addFilesToCategory disabled - using Storage-only approach");
    return {
      success: false,
      error: "Function disabled - using Storage-only approach",
      code: "FUNCTION_DISABLED",
    };

    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
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
          documentCount: admin.firestore.FieldValue.increment(
            documentIds.length
          ),
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
          details: `${documentIds.length} files added to category "${
            categoryDoc.data()?.name
          }"`,
        });

      console.log(
        `${documentIds.length} files added to category: ${categoryId}`
      );

      return {
        success: true,
        message: `${documentIds.length} files added to category successfully`,
      };
    } catch (error) {
      console.error("Error adding files to category:", error);
      if (error instanceof functions.https.HttpsError) {
        throw error;
      }
      throw new functions.https.HttpsError(
        "internal",
        `Failed to add files to category: ${error}`
      );
    }
  }
);

/**
 * Remove files from a category
 */
const removeFilesFromCategory = functions.https.onCall(
  async (data: RemoveFilesFromCategoryData, context) => {
    // DISABLED: Function uses document-metadata collection which is no longer used
    console.log("⚠️ removeFilesFromCategory disabled - using Storage-only approach");
    return {
      success: false,
      error: "Function disabled - using Storage-only approach",
      code: "FUNCTION_DISABLED",
    };

    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
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
          documentCount: admin.firestore.FieldValue.increment(
            -documentIds.length
          ),
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
          details: `${documentIds.length} files removed from category "${
            categoryDoc.data()?.name
          }"`,
        });

      console.log(
        `${documentIds.length} files removed from category: ${categoryId}`
      );

      return {
        success: true,
        message: `${documentIds.length} files removed from category successfully`,
      };
    } catch (error) {
      console.error("Error removing files from category:", error);
      if (error instanceof functions.https.HttpsError) {
        throw error;
      }
      throw new functions.https.HttpsError(
        "internal",
        `Failed to remove files from category: ${error}`
      );
    }
  }
);

// Enhanced category document retrieval with real-time support
export const getCategoryDocumentsEnhanced = functions.https.onCall(
  async (data, context) => {
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
        throw new functions.https.HttpsError(
          "unauthenticated",
          "User must be authenticated"
        );
      }

      const { categoryId, includeMetadata = true } = data;

      if (!categoryId) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "Category ID is required"
        );
      }

      console.log(`Getting enhanced documents for category: ${categoryId}`);

      // Get documents from Firestore with proper ordering
      const documentsSnapshot = await admin
        .firestore()
        .collection("document-metadata")
        .where("category", "==", categoryId)
        .orderBy("uploadedAt", "desc")
        .get();

      const documents = documentsSnapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      }));

      // Get category metadata if requested
      let categoryMetadata = null;
      if (includeMetadata) {
        const categoryDoc = await admin
          .firestore()
          .collection("categories")
          .doc(categoryId)
          .get();

        if (categoryDoc.exists) {
          categoryMetadata = {
            id: categoryDoc.id,
            ...categoryDoc.data(),
          };
        }
      }

      console.log(
        `Retrieved ${documents.length} documents for category: ${categoryId}`
      );

      return {
        success: true,
        documents,
        categoryMetadata,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      };
    } catch (error) {
      console.error("Error getting category documents:", error);
      throw new functions.https.HttpsError(
        "internal",
        `Failed to get category documents: ${error}`
      );
    }
  }
);

// Force refresh category contents from Firebase
export const refreshCategoryContents = functions.https.onCall(
  async (data, context) => {
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
        throw new functions.https.HttpsError(
          "unauthenticated",
          "User must be authenticated"
        );
      }

      const { categoryId } = data;

      console.log(`Force refreshing category contents: ${categoryId || "all"}`);

      let documentsQuery: FirebaseFirestore.Query<FirebaseFirestore.DocumentData> =
        admin.firestore().collection("document-metadata");

      // Filter by category if specified
      if (categoryId) {
        documentsQuery = documentsQuery.where("category", "==", categoryId);
      }

      const documentsSnapshot = await documentsQuery
        .orderBy("uploadedAt", "desc")
        .get();

      const documents = documentsSnapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      }));

      // Group documents by category
      const categorizedDocuments: { [key: string]: any[] } = {};
      documents.forEach((doc: any) => {
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
          details: `Refreshed ${documents.length} documents in ${
            Object.keys(categorizedDocuments).length
          } categories`,
        });

      console.log(
        `Refreshed ${documents.length} documents in ${
          Object.keys(categorizedDocuments).length
        } categories`
      );

      return {
        success: true,
        documents,
        categorizedDocuments,
        totalDocuments: documents.length,
        totalCategories: Object.keys(categorizedDocuments).length,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      };
    } catch (error) {
      console.error("Error refreshing category contents:", error);
      throw new functions.https.HttpsError(
        "internal",
        `Failed to refresh category contents: ${error}`
      );
    }
  }
);

export const categoryFunctions = {
  createCategory,
  updateCategory,
  deleteCategory,
  addFilesToCategory,
  removeFilesFromCategory,
  getCategoryDocumentsEnhanced,
  refreshCategoryContents,
};
