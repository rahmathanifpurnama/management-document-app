/**
 * Script to fix user permissions structure in Firestore
 * Converts old boolean permission structure to new array-based structure
 * Run this script to fix existing users after deploying the updated Cloud Functions
 */

const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
if (!admin.apps.length) {
  try {
    // Try to use service account key first
    const serviceAccount = require('./config/service-account-key.json');
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
      projectId: 'document-management-c5a96'
    });
    console.log('✅ Initialized with service account key');
  } catch (error) {
    // Fallback to application default credentials
    admin.initializeApp({
      credential: admin.credential.applicationDefault(),
      projectId: 'document-management-c5a96'
    });
    console.log('✅ Initialized with application default credentials');
  }
}

const db = admin.firestore();

/**
 * Convert old boolean permissions to new array structure
 */
function convertPermissions(oldPermissions) {
  const documents = [];
  const categories = [];
  const system = [];

  // Convert document permissions
  if (oldPermissions.canViewFiles || oldPermissions.canViewAllDocuments) {
    documents.push('view');
  }
  if (oldPermissions.canUploadFiles || oldPermissions.canUploadDocuments) {
    documents.push('upload');
  }
  if (oldPermissions.canDeleteFiles) {
    documents.push('delete');
  }
  if (oldPermissions.canApproveDocuments) {
    documents.push('approve');
  }

  // Convert system permissions
  if (oldPermissions.canManageUsers || oldPermissions.canCreateUsers) {
    system.push('user_management');
  }
  if (oldPermissions.canViewAnalytics) {
    system.push('analytics');
  }

  return {
    documents,
    categories,
    system
  };
}

/**
 * Fix user permissions for all users
 */
async function fixUserPermissions() {
  try {
    console.log('🔄 Starting user permissions fix...');
    
    const usersSnapshot = await db.collection('users').get();
    const batch = db.batch();
    let updateCount = 0;

    for (const userDoc of usersSnapshot.docs) {
      const userData = userDoc.data();
      const permissions = userData.permissions || {};

      // Check if user already has new permission structure
      if (permissions.documents && Array.isArray(permissions.documents)) {
        console.log(`✅ User ${userData.email || userDoc.id} already has new permission structure`);
        continue;
      }

      // Check if user has old permission structure
      if (permissions.canViewFiles !== undefined || permissions.canUploadFiles !== undefined) {
        console.log(`🔄 Converting permissions for user: ${userData.email || userDoc.id}`);
        
        const newPermissions = convertPermissions(permissions);
        
        // Update user document
        batch.update(userDoc.ref, {
          permissions: newPermissions,
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          permissionsMigrated: true
        });
        
        updateCount++;
      } else {
        // User has no permissions, set default based on role
        console.log(`🔄 Setting default permissions for user: ${userData.email || userDoc.id}`);
        
        const defaultPermissions = userData.role === 'admin' 
          ? {
              documents: ['view', 'upload', 'delete', 'approve'],
              categories: [],
              system: ['user_management', 'analytics']
            }
          : {
              documents: ['view', 'upload'],
              categories: [],
              system: []
            };

        batch.update(userDoc.ref, {
          permissions: defaultPermissions,
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          permissionsMigrated: true
        });
        
        updateCount++;
      }
    }

    if (updateCount > 0) {
      await batch.commit();
      console.log(`✅ Successfully updated permissions for ${updateCount} users`);
    } else {
      console.log('✅ No users needed permission updates');
    }

    console.log('🎉 User permissions fix completed successfully!');
    
  } catch (error) {
    console.error('❌ Error fixing user permissions:', error);
    throw error;
  }
}

/**
 * Verify the fix by checking a few users
 */
async function verifyFix() {
  try {
    console.log('🔍 Verifying user permissions fix...');
    
    const usersSnapshot = await db.collection('users').limit(5).get();
    
    for (const userDoc of usersSnapshot.docs) {
      const userData = userDoc.data();
      const permissions = userData.permissions || {};
      
      console.log(`User: ${userData.email || userDoc.id}`);
      console.log(`  Role: ${userData.role}`);
      console.log(`  Permissions:`, permissions);
      console.log(`  Has new structure: ${Array.isArray(permissions.documents)}`);
      console.log('---');
    }
    
  } catch (error) {
    console.error('❌ Error verifying fix:', error);
  }
}

// Main execution
async function main() {
  try {
    await fixUserPermissions();
    await verifyFix();
    process.exit(0);
  } catch (error) {
    console.error('❌ Script failed:', error);
    process.exit(1);
  }
}

// Run the script
if (require.main === module) {
  main();
}

module.exports = {
  fixUserPermissions,
  verifyFix,
  convertPermissions
};
