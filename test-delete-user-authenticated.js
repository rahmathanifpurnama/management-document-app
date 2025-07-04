const admin = require('./scripts/node_modules/firebase-admin');

// Initialize Firebase Admin
const serviceAccount = require('./scripts/config/service-account-key.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: 'document-management-c5a96'
});

async function testDeleteUserWithAuth() {
  try {
    console.log('🧪 Testing deleteUser Cloud Function with Authentication...');
    
    // Step 1: Create a test user to be deleted
    const testUser = await admin.auth().createUser({
      email: `test-delete-${Date.now()}@example.com`,
      password: 'testPassword123',
      displayName: 'Test Delete User'
    });
    console.log('✅ Test user created:', testUser.uid);
    
    // Step 2: Create Firestore document for the test user
    await admin.firestore().collection('users').doc(testUser.uid).set({
      fullName: 'Test Delete User',
      email: testUser.email,
      role: 'user',
      status: 'active',
      permissions: {
        documents: ['view'],
        system: []
      },
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    });
    console.log('✅ Test user Firestore document created');
    
    // Step 3: Get admin user for authentication
    const adminEmail = 'web.hanif61@gmail.com';
    let adminUser;
    try {
      adminUser = await admin.auth().getUserByEmail(adminEmail);
      console.log('✅ Admin user found:', adminUser.uid);
    } catch (error) {
      console.log('❌ Admin user not found, creating one...');
      adminUser = await admin.auth().createUser({
        email: adminEmail,
        password: 'adminPassword123',
        displayName: 'Admin User'
      });
      
      // Create admin Firestore document
      await admin.firestore().collection('users').doc(adminUser.uid).set({
        fullName: 'Admin User',
        email: adminEmail,
        role: 'admin',
        status: 'active',
        permissions: {
          documents: ['view', 'upload', 'delete', 'approve'],
          system: ['user_management', 'analytics']
        },
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp()
      });
      console.log('✅ Admin user created:', adminUser.uid);
    }
    
    // Step 4: Create custom token for admin authentication
    const customToken = await admin.auth().createCustomToken(adminUser.uid);
    console.log('✅ Custom token created for admin');
    
    // Step 5: Test the deleteUser function using Firebase Functions SDK
    const https = require('https');
    const postData = JSON.stringify({
      data: { userId: testUser.uid }
    });
    
    const options = {
      hostname: 'us-central1-document-management-c5a96.cloudfunctions.net',
      port: 443,
      path: '/deleteUser',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${customToken}`,
        'Content-Length': Buffer.byteLength(postData)
      }
    };
    
    console.log('🔄 Calling deleteUser Cloud Function...');
    
    const response = await new Promise((resolve, reject) => {
      const req = https.request(options, (res) => {
        let data = '';
        res.on('data', (chunk) => {
          data += chunk;
        });
        res.on('end', () => {
          resolve({ statusCode: res.statusCode, data });
        });
      });
      
      req.on('error', (error) => {
        reject(error);
      });
      
      req.write(postData);
      req.end();
    });
    
    console.log('📋 Cloud Function Response:');
    console.log('Status Code:', response.statusCode);
    console.log('Response Data:', response.data);
    
    // Step 6: Verify user is deleted from Firebase Auth
    try {
      await admin.auth().getUser(testUser.uid);
      console.log('❌ FAILED: User still exists in Firebase Auth');
      return false;
    } catch (error) {
      if (error.code === 'auth/user-not-found') {
        console.log('✅ SUCCESS: User successfully deleted from Firebase Auth');
      } else {
        console.log('❌ Unexpected error checking user:', error.message);
        return false;
      }
    }
    
    // Step 7: Verify user document is deleted from Firestore
    const userDoc = await admin.firestore().collection('users').doc(testUser.uid).get();
    if (!userDoc.exists) {
      console.log('✅ SUCCESS: User document deleted from Firestore');
    } else {
      console.log('❌ FAILED: User document still exists in Firestore');
      return false;
    }
    
    console.log('🎉 ALL TESTS PASSED! deleteUser function is working correctly.');
    return true;
    
  } catch (error) {
    console.error('❌ Test failed:', error.message);
    console.error('Stack trace:', error.stack);
    return false;
  }
}

// Run the test
testDeleteUserWithAuth().then(success => {
  process.exit(success ? 0 : 1);
});
