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

      // Set default permissions based on role - FIXED: Use array structure for Storage Rules compatibility
      const defaultPermissions =
        role === "admin"
          ? {
            documents: ["view", "upload", "delete", "approve"],
            categories: [],
            system: ["user_management", "analytics"],
          }
          : {
            documents: ["view", "upload"],
            categories: [],
            system: [],
          };

      // Create user document in Firestore
      const userData = {
        id: userRecord.uid,
        fullName,
        email,
        role,
        status: "active",
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
 * Delete a user (hard delete - permanently removes from Firebase Auth and Firestore)
 */
const deleteUser = functions.https.onCall(
  async (data: { userId: string }, context) => {
    console.log('🚀 deleteUser function called with data:', JSON.stringify(data));
    console.log('🔐 Auth context:', context.auth ? 'AUTHENTICATED' : 'NOT AUTHENTICATED');

    if (!context.auth) {
      console.log('❌ Authentication failed - no context.auth');
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }

    try {
      console.log('🔍 Checking admin permissions for user:', context.auth.uid);

      // Check if current user is admin
      const currentUserDoc = await admin
        .firestore()
        .collection("users")
        .doc(context.auth.uid)
        .get();
      const currentUser = currentUserDoc.data();

      console.log('👤 Current user data:', currentUser ? 'EXISTS' : 'NOT FOUND');
      console.log('🔑 Current user role:', currentUser?.role);

      if (!currentUser || currentUser.role !== "admin") {
        console.log('❌ Permission denied - user is not admin');
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

      // HARD DELETE: Delete user from Firebase Auth FIRST
      // This will trigger onAuthUserDeleted which will handle Firestore cleanup
      console.log(`🗑️ Deleting user from Firebase Auth: ${userId}`);
      await admin.auth().deleteUser(userId);
      console.log(`✅ User deleted from Firebase Auth: ${userId}`);

      // Note: onAuthUserDeleted trigger will automatically clean up Firestore document

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
                status: "active",
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                updatedBy: context.auth.uid,
              });
              // Enable in Firebase Auth
              await admin.auth().updateUser(userId, { disabled: false });
              break;

            case "deactivate":
              batch.update(userRef, {
                status: "inactive",
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                updatedBy: context.auth.uid,
              });
              // Disable in Firebase Auth
              await admin.auth().updateUser(userId, { disabled: true });
              break;

            case "delete":
              // Hard delete: Remove from Firestore and Firebase Auth
              batch.delete(userRef);
              // Delete from Firebase Auth
              await admin.auth().deleteUser(userId);
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

/**
 * Set admin custom claims for a user
 */
const setAdminClaims = functions.https.onCall(async (data: { userId: string, isAdmin: boolean }, context) => {
  // Only existing admins can set admin claims
  if (!context.auth || !context.auth.token.admin) {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only administrators can set admin claims"
    );
  }

  try {
    const { userId, isAdmin } = data;

    // Set custom claims
    await admin.auth().setCustomUserClaims(userId, { admin: isAdmin });

    // Update user document in Firestore
    await admin.firestore().collection("users").doc(userId).update({
      role: isAdmin ? "admin" : "user",
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedBy: context.auth.uid,
    });

    console.log(`Admin claims set for user ${userId}: ${isAdmin}`);

    return {
      success: true,
      message: `User ${userId} ${isAdmin ? "granted" : "revoked"} admin privileges`,
    };
  } catch (error) {
    console.error("Error setting admin claims:", error);
    throw new functions.https.HttpsError(
      "internal",
      `Failed to set admin claims: ${error}`
    );
  }
});



/**
 * Auto-sync all Firebase Auth users to Firestore (Admin only)
 */
const autoSyncFirebaseAuthUsers = functions.https.onCall(async (data, context) => {
  // Verify authentication and admin privileges
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be authenticated"
    );
  }

  try {
    // Check if user is admin
    const adminDoc = await admin
      .firestore()
      .collection("users")
      .doc(context.auth.uid)
      .get();

    if (!adminDoc.exists || adminDoc.data()?.role !== "admin") {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Only admins can auto-sync Firebase Auth users"
      );
    }

    // Get all Firebase Auth users
    const listUsersResult = await admin.auth().listUsers(1000);
    const authUsers = listUsersResult.users;

    // Get existing Firestore users
    const firestoreUsersSnapshot = await admin
      .firestore()
      .collection("users")
      .get();

    const existingUserIds = new Set(
      firestoreUsersSnapshot.docs.map(doc => doc.id)
    );

    // Find users that exist in Firebase Auth but not in Firestore
    const usersToSync = authUsers.filter(user => !existingUserIds.has(user.uid));

    let syncedCount = 0;
    const errors: string[] = [];

    // Sync each missing user
    for (const authUser of usersToSync) {
      try {
        // Generate a safe fullName with proper fallbacks
        let fullName = authUser.displayName || '';

        // If displayName is empty, extract from email
        if (!fullName.trim() && authUser.email) {
          const emailPart = authUser.email.split('@')[0];
          fullName = emailPart
            .replace(/[._]/g, ' ')
            .split(' ')
            .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
            .filter(word => word.length > 0)
            .join(' ');
        }

        // Final fallback if all else fails
        if (!fullName.trim()) {
          fullName = 'Unknown User';
        }

        const userData = {
          id: authUser.uid,
          fullName: fullName,
          email: authUser.email || '',
          role: "user", // Default role
          status: authUser.disabled ? "inactive" : "active",
          createdBy: context.auth.uid,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          permissions: {
            documents: ["view", "upload"],
            categories: [],
            system: [],
          },
          lastLogin: authUser.metadata.lastSignInTime ?
            admin.firestore.Timestamp.fromDate(new Date(authUser.metadata.lastSignInTime)) : null,
          profileImageUrl: null,
        };

        await admin
          .firestore()
          .collection("users")
          .doc(authUser.uid)
          .set(userData);

        syncedCount++;
        console.log(`Auto-synced user: ${authUser.email || authUser.uid}`);
      } catch (error) {
        const errorMsg = `Failed to sync user ${authUser.email || authUser.uid}: ${error}`;
        errors.push(errorMsg);
        console.error(errorMsg);
      }
    }

    // Log activity
    await admin
      .firestore()
      .collection("activities")
      .add({
        type: "auto_sync_completed",
        userId: context.auth.uid,
        createdBy: context.auth.uid,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        details: `Auto-sync completed: ${syncedCount} users synced, ${errors.length} errors`,
      });

    console.log(`Auto-sync completed: ${syncedCount} users synced, ${errors.length} errors`);

    return {
      success: true,
      syncedCount,
      totalAuthUsers: authUsers.length,
      totalFirestoreUsers: firestoreUsersSnapshot.docs.length,
      errors: errors.length > 0 ? errors : undefined,
      message: `Auto-sync completed: ${syncedCount} users synced`,
    };
  } catch (error) {
    console.error("Error in auto-sync Firebase Auth users:", error);

    if (error instanceof functions.https.HttpsError) {
      throw error;
    }

    throw new functions.https.HttpsError(
      "internal",
      `Failed to auto-sync Firebase Auth users: ${error}`
    );
  }
});

/**
 * Debug Firebase Auth permissions and test delete functionality
 */
const debugAuthPermissions = functions.https.onCall(async (data: { testUserId?: string }, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
  }

  try {
    // Check if current user is admin
    const currentUserDoc = await admin.firestore().collection("users").doc(context.auth.uid).get();
    const currentUser = currentUserDoc.data();

    if (!currentUser || currentUser.role !== "admin") {
      throw new functions.https.HttpsError("permission-denied", "Only admins can run debug operations");
    }

    const results: any = {
      timestamp: new Date().toISOString(),
      tests: {},
      errors: []
    };

    // Test 1: List users
    try {
      console.log("🧪 Testing: List users...");
      const listResult = await admin.auth().listUsers(3);
      results.tests.listUsers = {
        success: true,
        userCount: listResult.users.length,
        message: `Successfully listed ${listResult.users.length} users`
      };
      console.log(`✅ List users: ${listResult.users.length} users found`);
    } catch (error: any) {
      console.error("❌ List users failed:", error);
      results.tests.listUsers = {
        success: false,
        error: error.message,
        code: error.code
      };
      results.errors.push(`List users: ${error.message}`);
    }

    // Test 2: Create test user
    let testUserId = data.testUserId;
    if (!testUserId) {
      try {
        console.log("🧪 Testing: Create user...");
        const testEmail = `debug-test-${Date.now()}@example.com`;
        const userRecord = await admin.auth().createUser({
          email: testEmail,
          password: 'debugTest123',
          displayName: 'Debug Test User'
        });
        testUserId = userRecord.uid;
        results.tests.createUser = {
          success: true,
          userId: testUserId,
          email: testEmail,
          message: "Successfully created test user"
        };
        console.log(`✅ Create user: ${testUserId} (${testEmail})`);
      } catch (error: any) {
        console.error("❌ Create user failed:", error);
        results.tests.createUser = {
          success: false,
          error: error.message,
          code: error.code
        };
        results.errors.push(`Create user: ${error.message}`);
      }
    }

    // Test 3: Delete user (if we have a test user)
    if (testUserId) {
      try {
        console.log(`🧪 Testing: Delete user ${testUserId}...`);
        await admin.auth().deleteUser(testUserId);
        results.tests.deleteUser = {
          success: true,
          userId: testUserId,
          message: "Successfully deleted test user"
        };
        console.log(`✅ Delete user: ${testUserId}`);
      } catch (error: any) {
        console.error("❌ Delete user failed:", error);
        results.tests.deleteUser = {
          success: false,
          userId: testUserId,
          error: error.message,
          code: error.code
        };
        results.errors.push(`Delete user: ${error.message}`);
      }
    }

    // Test 4: Check service account info
    try {
      console.log("🧪 Testing: Service account info...");
      // Try to get project info to verify permissions
      const projectId = admin.app().options.projectId;
      results.tests.serviceAccount = {
        success: true,
        projectId: projectId,
        message: "Service account appears to be working"
      };
      console.log(`✅ Service account: Project ID ${projectId}`);
    } catch (error: any) {
      console.error("❌ Service account check failed:", error);
      results.tests.serviceAccount = {
        success: false,
        error: error.message,
        code: error.code
      };
      results.errors.push(`Service account: ${error.message}`);
    }

    return {
      success: results.errors.length === 0,
      message: results.errors.length === 0 ? "All tests passed" : `${results.errors.length} tests failed`,
      results: results
    };

  } catch (error: any) {
    console.error("Debug auth permissions failed:", error);
    throw new functions.https.HttpsError("internal", `Debug failed: ${error.message}`);
  }
});

/**
 * Initialize admin user (for first-time setup)
 */
const initializeAdmin = functions.https.onCall(async (data: { email: string }, context) => {
  try {
    const { email } = data;

    // Get user by email
    const userRecord = await admin.auth().getUserByEmail(email);

    // Set admin claims
    await admin.auth().setCustomUserClaims(userRecord.uid, { admin: true });

    // Update user document in Firestore
    await admin.firestore().collection("users").doc(userRecord.uid).update({
      role: "admin",
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log(`Admin initialized for user: ${email}`);

    return {
      success: true,
      message: `Admin privileges granted to ${email}`,
    };
  } catch (error) {
    console.error("Error initializing admin:", error);
    throw new functions.https.HttpsError(
      "internal",
      `Failed to initialize admin: ${error}`
    );
  }
});

export const userFunctions = {
  createUser,
  updateUserPermissions,
  deleteUser,
  bulkUserOperations,
  setAdminClaims,
  autoSyncFirebaseAuthUsers,
  debugAuthPermissions,
  initializeAdmin,
};
