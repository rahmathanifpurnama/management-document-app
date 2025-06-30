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

async function debugCurrentUsers() {
  try {
    console.log('🔍 Debugging current users and their permissions...\n');

    // Get all users from Firestore
    const usersSnapshot = await db.collection('users').get();
    
    if (usersSnapshot.empty) {
      console.log('❌ No users found in Firestore');
      return;
    }

    console.log(`📊 Found ${usersSnapshot.size} users in Firestore:\n`);

    for (const userDoc of usersSnapshot.docs) {
      const userData = userDoc.data();
      console.log(`👤 User: ${userData.email || 'No email'}`);
      console.log(`   ID: ${userDoc.id}`);
      console.log(`   Role: ${userData.role || 'No role'}`);
      console.log(`   Status: ${userData.status || 'No status'}`);
      console.log(`   IsActive: ${userData.isActive}`);
      
      // Check permissions structure
      if (userData.permissions) {
        console.log(`   Permissions:`, JSON.stringify(userData.permissions, null, 4));
        
        // Check if it's new array structure
        if (userData.permissions.documents && Array.isArray(userData.permissions.documents)) {
          console.log(`   ✅ Has NEW array-based permission structure`);
          console.log(`   📋 Document permissions: [${userData.permissions.documents.join(', ')}]`);
        } else {
          console.log(`   ⚠️ Has OLD boolean-based permission structure`);
          if (userData.permissions.canUploadFiles) {
            console.log(`   📤 Can upload files: ${userData.permissions.canUploadFiles}`);
          }
          if (userData.permissions.canViewFiles) {
            console.log(`   👁️ Can view files: ${userData.permissions.canViewFiles}`);
          }
          if (userData.permissions.canDeleteFiles) {
            console.log(`   🗑️ Can delete files: ${userData.permissions.canDeleteFiles}`);
          }
        }
      } else {
        console.log(`   ❌ No permissions found`);
      }
      
      console.log('   ---');
    }

    // Also check Firebase Auth users
    console.log('\n🔐 Checking Firebase Authentication users:');
    const authUsers = await admin.auth().listUsers();
    
    console.log(`📊 Found ${authUsers.users.length} users in Firebase Auth:\n`);
    
    for (const authUser of authUsers.users) {
      console.log(`🔑 Auth User: ${authUser.email || 'No email'}`);
      console.log(`   UID: ${authUser.uid}`);
      console.log(`   Disabled: ${authUser.disabled}`);
      console.log(`   Email Verified: ${authUser.emailVerified}`);
      console.log(`   Last Sign In: ${authUser.metadata.lastSignInTime || 'Never'}`);
      
      // Check if this auth user has corresponding Firestore data
      const firestoreUser = usersSnapshot.docs.find(doc => doc.id === authUser.uid);
      if (firestoreUser) {
        console.log(`   ✅ Has Firestore data`);
      } else {
        console.log(`   ❌ Missing Firestore data`);
      }
      console.log('   ---');
    }

  } catch (error) {
    console.error('❌ Error debugging users:', error);
  }
}

// Run the debug
debugCurrentUsers()
  .then(() => {
    console.log('\n🎉 Debug completed!');
    process.exit(0);
  })
  .catch((error) => {
    console.error('❌ Script failed:', error);
    process.exit(1);
  });
