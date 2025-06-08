import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";

interface CreateUserData {
  fullName: string;
  email: string;
  password: string;
  role: string;
  permissions?: any;
}

interface UpdateUserPermissionsData {
  userId: string;
  permissions: any;
}

interface BulkUserOperationData {
  operation: "activate" | "deactivate" | "delete";
  userIds: string[];
}

/**
 * Create a new user
 */
const createUser = functions.https.onCall(
  async (data: CreateUserData, context) => {
    // Verify authentication and admin privileges
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }

    try {
      // Check if current user is admin
      const currentUserDoc = await admin
        .firestore()
        .collection("users")
        .doc(context.auth.uid)
        .get();
      const currentUser = currentUserDoc.data();

      if (!currentUser || currentUser.role !== "admin") {
        throw new functions.https.HttpsError(
          "permission-denied",
          "Only admins can create users"
        );
      }

      const { fullName, email, password, role, permissions } = data;

      // Validate required fields
      if (!fullName || !email || !password || !role) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "Missing required fields"
        );
      }

      // Validate email format
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(email)) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "Invalid email format"
        );
      }

      // Validate password strength
      if (password.length < 6) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "Password must be at least 6 characters"
        );
      }

      // Create user in Firebase Auth
      const userRecord = await admin.auth().createUser({
        email,
        password,
        displayName: fullName,
        emailVerified: true,
      });

      // Set default permissions based on role
      const defaultPermissions =
        role === "admin"
          ? {
            canCreateUsers: true,
            canDeleteUsers: true,
            canManageCategories: true,
            canApproveDocuments: true,
            canViewAllDocuments: true,
            canDownloadDocuments: true,
            canUploadDocuments: true,
            canManagePermissions: true,
          }
          : {
            canCreateUsers: false,
            canDeleteUsers: false,
            canManageCategories: false,
            canApproveDocuments: false,
            canViewAllDocuments: false,
            canDownloadDocuments: true,
            canUploadDocuments: true,
            canManagePermissions: false,
          };

      // Create user document in Firestore
      const userData = {
        id: userRecord.uid,
        fullName,
        email,
        role,
        status: "active",
        isActive: true,
        createdBy: context.auth.uid,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        permissions: permissions || defaultPermissions,
        lastLogin: null,
        profileImageUrl: null,
      };

      await admin
        .firestore()
        .collection("users")
        .doc(userRecord.uid)
        .set(userData);

      // Log activity
      await admin
        .firestore()
        .collection("activities")
        .add({
          type: "user_created",
          userId: userRecord.uid,
          createdBy: context.auth.uid,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
          details: `User ${fullName} (${email}) created with role ${role}`,
        });

      console.log(`User created successfully: ${userRecord.uid}`);

      return {
        success: true,
        userId: userRecord.uid,
        message: "User created successfully",
      };
    } catch (error) {
      console.error("Error creating user:", error);

      // Handle specific Firebase Auth errors
      if (
        error instanceof Error &&
        "code" in error &&
        (error as any).code === "auth/email-already-exists"
      ) {
        throw new functions.https.HttpsError(
          "already-exists",
          "Email already exists"
        );
      }

      if (error instanceof functions.https.HttpsError) {
        throw error;
      }

      throw new functions.https.HttpsError(
        "internal",
        `Failed to create user: ${error}`
      );
    }
  }
);

/**
 * Update user permissions
 */
const updateUserPermissions = functions.https.onCall(
  async (data: UpdateUserPermissionsData, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }

    try {
      // Check if current user is admin
      const currentUserDoc = await admin
        .firestore()
        .collection("users")
        .doc(context.auth.uid)
        .get();
      const currentUser = currentUserDoc.data();

      if (!currentUser || currentUser.role !== "admin") {
        throw new functions.https.HttpsError(
          "permission-denied",
          "Only admins can update user permissions"
        );
      }

      const { userId, permissions } = data;

      // Validate user exists
      const userDoc = await admin
        .firestore()
        .collection("users")
        .doc(userId)
        .get();
      if (!userDoc.exists) {
        throw new functions.https.HttpsError("not-found", "User not found");
      }

      // Update user permissions
      await admin.firestore().collection("users").doc(userId).update({
        permissions,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedBy: context.auth.uid,
      });

      // Log activity
      await admin
        .firestore()
        .collection("activities")
        .add({
          type: "user_permissions_updated",
          userId,
          updatedBy: context.auth.uid,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
          details: `Permissions updated for user ${userDoc.data()?.fullName}`,
        });

      console.log(`User permissions updated successfully: ${userId}`);

      return {
        success: true,
        message: "User permissions updated successfully",
      };
    } catch (error) {
      console.error("Error updating user permissions:", error);
      if (error instanceof functions.https.HttpsError) {
        throw error;
      }
      throw new functions.https.HttpsError(
        "internal",
        `Failed to update user permissions: ${error}`
      );
    }
  }
);

/**
 * Delete a user (soft delete)
 */
const deleteUser = functions.https.onCall(
  async (data: { userId: string }, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }

    try {
      // Check if current user is admin
      const currentUserDoc = await admin
        .firestore()
        .collection("users")
        .doc(context.auth.uid)
        .get();
      const currentUser = currentUserDoc.data();

      if (!currentUser || currentUser.role !== "admin") {
        throw new functions.https.HttpsError(
          "permission-denied",
          "Only admins can delete users"
        );
      }

      const { userId } = data;

      // Prevent self-deletion
      if (userId === context.auth.uid) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "Cannot delete your own account"
        );
      }

      // Validate user exists
      const userDoc = await admin
        .firestore()
        .collection("users")
        .doc(userId)
        .get();
      if (!userDoc.exists) {
        throw new functions.https.HttpsError("not-found", "User not found");
      }

      const userData = userDoc.data();

      // Soft delete in Firestore
      await admin.firestore().collection("users").doc(userId).update({
        isActive: false,
        status: "deleted",
        deletedBy: context.auth.uid,
        deletedAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Disable user in Firebase Auth
      await admin.auth().updateUser(userId, {
        disabled: true,
      });

      // Log activity
      await admin
        .firestore()
        .collection("activities")
        .add({
          type: "user_deleted",
          userId,
          deletedBy: context.auth.uid,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
          details: `User ${userData?.fullName} (${userData?.email}) deleted`,
        });

      console.log(`User deleted successfully: ${userId}`);

      return {
        success: true,
        message: "User deleted successfully",
      };
    } catch (error) {
      console.error("Error deleting user:", error);
      if (error instanceof functions.https.HttpsError) {
        throw error;
      }
      throw new functions.https.HttpsError(
        "internal",
        `Failed to delete user: ${error}`
      );
    }
  }
);

/**
 * Bulk user operations
 */
const bulkUserOperations = functions.https.onCall(
  async (data: BulkUserOperationData, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }

    try {
      // Check if current user is admin
      const currentUserDoc = await admin
        .firestore()
        .collection("users")
        .doc(context.auth.uid)
        .get();
      const currentUser = currentUserDoc.data();

      if (!currentUser || currentUser.role !== "admin") {
        throw new functions.https.HttpsError(
          "permission-denied",
          "Only admins can perform bulk operations"
        );
      }

      const { operation, userIds } = data;

      if (!userIds || userIds.length === 0) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "No users specified"
        );
      }

      // Prevent operations on self
      if (userIds.includes(context.auth.uid)) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "Cannot perform bulk operations on your own account"
        );
      }

      const results = {
        success: 0,
        failed: 0,
        errors: [] as string[],
      };

      // Process users in batches
      const batchSize = 500;
      for (let i = 0; i < userIds.length; i += batchSize) {
        const batch = admin.firestore().batch();
        const batchUserIds = userIds.slice(i, i + batchSize);

        for (const userId of batchUserIds) {
          try {
            const userRef = admin.firestore().collection("users").doc(userId);

            switch (operation) {
            case "activate":
              batch.update(userRef, {
                isActive: true,
                status: "active",
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                updatedBy: context.auth.uid,
              });
              // Enable in Firebase Auth
              await admin.auth().updateUser(userId, { disabled: false });
              break;

            case "deactivate":
              batch.update(userRef, {
                isActive: false,
                status: "inactive",
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                updatedBy: context.auth.uid,
              });
              // Disable in Firebase Auth
              await admin.auth().updateUser(userId, { disabled: true });
              break;

            case "delete":
              batch.update(userRef, {
                isActive: false,
                status: "deleted",
                deletedBy: context.auth.uid,
                deletedAt: admin.firestore.FieldValue.serverTimestamp(),
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
              });
              // Disable in Firebase Auth
              await admin.auth().updateUser(userId, { disabled: true });
              break;
            }

            results.success++;
          } catch (error) {
            results.failed++;
            results.errors.push(
              `Failed to ${operation} user ${userId}: ${error}`
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
          type: "bulk_user_operation",
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
      console.error("Error in bulk user operations:", error);
      if (error instanceof functions.https.HttpsError) {
        throw error;
      }
      throw new functions.https.HttpsError(
        "internal",
        `Failed to perform bulk user operations: ${error}`
      );
    }
  }
);

export const userFunctions = {
  createUser,
  updateUserPermissions,
  deleteUser,
  bulkUserOperations,
};
