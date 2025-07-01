const admin = require('firebase-admin');

// Initialize Firebase Admin if not already initialized
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.applicationDefault(),
    projectId: 'document-management-c5a96'
  });
}

async function debugCurrentUser() {
  try {
    console.log('🔍 Debugging current user data...');
    
    // List all users in Firestore
    const usersSnapshot = await admin.firestore().collection('users').get();
    
    console.log(`📊 Total users in Firestore: ${usersSnapshot.size}`);
    
    usersSnapshot.forEach(doc => {
      const userData = doc.data();
      console.log(`\n👤 User ID: ${doc.id}`);
      console.log(`   Name: ${userData.fullName}`);
      console.log(`   Email: ${userData.email}`);
      console.log(`   Role: ${userData.role}`);
      console.log(`   Status: ${userData.status}`);
      console.log(`   Is Admin: ${userData.role === 'admin'}`);
      console.log(`   Is Active: ${userData.status === 'active'}`);
      console.log(`   Can Create Categories: ${userData.role === 'admin' && userData.status === 'active'}`);
    });
    
    // Also check Firebase Auth users
    console.log('\n🔐 Firebase Auth Users:');
    const authUsers = await admin.auth().listUsers();
    authUsers.users.forEach(user => {
      console.log(`   Auth User: ${user.email} (${user.uid}) - Disabled: ${user.disabled}`);
    });
    
  } catch (error) {
    console.error('❌ Error debugging users:', error);
  }
}

debugCurrentUser();
