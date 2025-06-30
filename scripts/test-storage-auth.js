const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
if (!admin.apps.length) {
  try {
    const serviceAccount = require('./config/service-account-key.json');
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
      projectId: 'document-management-c5a96'
    });
    console.log('✅ Initialized with service account key');
  } catch (error) {
    admin.initializeApp({
      credential: admin.credential.applicationDefault(),
      projectId: 'document-management-c5a96'
    });
    console.log('✅ Initialized with application default credentials');
  }
}

const db = admin.firestore();

async function testStorageAuth() {
  try {
    console.log('🔍 Testing Storage Authentication and Rules...\n');

    // Test user IDs
    const testUsers = [
      'CP8jF9s65PRCK2qgCigmCt0SBv13', // rahmat145hanif@gmail.com
      'PFnoTjoDdtcG9qJBsizIhz3n5Uf2'  // web.hanif61@gmail.com
    ];

    for (const userId of testUsers) {
      console.log(`🧪 Testing user: ${userId}`);
      
      // Get user data
      const userDoc = await db.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        console.log(`❌ User ${userId} not found in Firestore`);
        continue;
      }

      const userData = userDoc.data();
      console.log(`👤 User: ${userData.email}`);
      console.log(`📋 Role: ${userData.role}`);
      console.log(`🔄 Status: ${userData.status}`);
      console.log(`✅ IsActive: ${userData.isActive}`);

      // Test Storage Rules conditions
      console.log('\n🔐 Testing Storage Rules conditions:');
      
      // 1. Check if user exists in Firestore
      console.log(`   ✅ User exists in Firestore: true`);
      
      // 2. Check if user is active
      const isActive = userData.status === 'active';
      console.log(`   ${isActive ? '✅' : '❌'} User status is active: ${isActive}`);
      
      // 3. Check permissions structure
      if (userData.permissions && userData.permissions.documents) {
        const hasUploadPermission = userData.permissions.documents.includes('upload');
        const hasViewPermission = userData.permissions.documents.includes('view');
        console.log(`   ${hasUploadPermission ? '✅' : '❌'} Has upload permission: ${hasUploadPermission}`);
        console.log(`   ${hasViewPermission ? '✅' : '❌'} Has view permission: ${hasViewPermission}`);
      } else {
        console.log(`   ❌ No permissions found or invalid structure`);
      }

      // 4. Check if admin
      const isAdmin = userData.role === 'admin';
      console.log(`   ${isAdmin ? '✅' : '❌'} Is admin: ${isAdmin}`);

      // 5. Generate custom token for testing
      try {
        const customToken = await admin.auth().createCustomToken(userId);
        console.log(`   ✅ Custom token generated successfully`);
        console.log(`   🔑 Token preview: ${customToken.substring(0, 50)}...`);
      } catch (tokenError) {
        console.log(`   ❌ Failed to generate custom token: ${tokenError.message}`);
      }

      console.log('\n' + '='.repeat(50) + '\n');
    }

    // Test Storage Rules simulation
    console.log('🧪 Storage Rules Simulation:');
    console.log('For path: /documents/CP8jF9s65PRCK2qgCigmCt0SBv13/test.pdf');
    
    const testUser = await db.collection('users').doc('CP8jF9s65PRCK2qgCigmCt0SBv13').get();
    const testUserData = testUser.data();
    
    // Simulate Storage Rules logic
    const conditions = {
      'request.auth != null': true, // Assuming user is authenticated
      'firestore.exists(/databases/(default)/documents/users/$(request.auth.uid))': testUser.exists,
      'user.status == active': testUserData.status === 'active',
      'user has upload permission': testUserData.permissions?.documents?.includes('upload') || false,
      'user has view permission': testUserData.permissions?.documents?.includes('view') || false,
    };

    console.log('\n📋 Storage Rules Conditions Check:');
    for (const [condition, result] of Object.entries(conditions)) {
      console.log(`   ${result ? '✅' : '❌'} ${condition}: ${result}`);
    }

    const allConditionsMet = Object.values(conditions).every(Boolean);
    console.log(`\n🎯 Overall Result: ${allConditionsMet ? '✅ SHOULD WORK' : '❌ WILL FAIL'}`);

  } catch (error) {
    console.error('❌ Error testing storage auth:', error);
  }
}

// Run the test
testStorageAuth()
  .then(() => {
    console.log('\n🎉 Storage auth test completed!');
    process.exit(0);
  })
  .catch((error) => {
    console.error('❌ Script failed:', error);
    process.exit(1);
  });
