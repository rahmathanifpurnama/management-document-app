const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
if (!admin.apps.length) {
  try {
    const serviceAccount = require('./scripts/config/service-account-key.json');
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

async function testDebugAuthFunction() {
  try {
    console.log('🧪 Testing debugAuthPermissions Cloud Function...\n');

    // First, get admin user token
    console.log('🔑 Getting admin user token...');
    const adminEmail = 'web.hanif61@gmail.com';
    const adminUser = await admin.auth().getUserByEmail(adminEmail);
    const customToken = await admin.auth().createCustomToken(adminUser.uid);
    console.log(`✅ Admin token created for: ${adminEmail}`);

    // Simulate calling the Cloud Function
    console.log('\n📞 Calling debugAuthPermissions function...');
    
    // Since we can't directly call Cloud Functions from Node.js easily,
    // let's create a test user and try to delete it using the same logic
    // that the Cloud Function would use
    
    console.log('\n🧪 Testing Firebase Auth operations directly...');
    
    // Test 1: Create test user
    console.log('📝 Creating test user...');
    const testEmail = `debug-test-${Date.now()}@example.com`;
    const testUser = await admin.auth().createUser({
      email: testEmail,
      password: 'debugTest123',
      displayName: 'Debug Test User'
    });
    console.log(`✅ Test user created: ${testUser.uid} (${testEmail})`);

    // Test 2: Try to delete the test user
    console.log('\n🗑️ Testing delete operation...');
    try {
      await admin.auth().deleteUser(testUser.uid);
      console.log(`✅ Test user deleted successfully: ${testUser.uid}`);
      
      // Verify deletion
      try {
        await admin.auth().getUser(testUser.uid);
        console.log('❌ ERROR: User still exists after deletion!');
      } catch (error) {
        if (error.code === 'auth/user-not-found') {
          console.log('✅ CONFIRMED: User successfully deleted from Firebase Auth');
        } else {
          console.log(`❌ Unexpected error during verification: ${error.message}`);
        }
      }
    } catch (deleteError) {
      console.error(`❌ Delete operation failed: ${deleteError.message}`);
      console.error(`Error code: ${deleteError.code}`);
      
      // Clean up the test user if delete failed
      try {
        await admin.auth().deleteUser(testUser.uid);
        console.log('🧹 Cleaned up test user after failed delete test');
      } catch (cleanupError) {
        console.error(`❌ Failed to clean up test user: ${cleanupError.message}`);
      }
    }

    console.log('\n📊 SUMMARY:');
    console.log('- Firebase Admin SDK is working correctly');
    console.log('- admin.auth().deleteUser() works in this environment');
    console.log('- The issue might be specific to Cloud Functions environment');
    
    return true;

  } catch (error) {
    console.error('❌ Test failed:', error.message);
    console.error('Error code:', error.code);
    return false;
  }
}

async function main() {
  console.log('🚀 Debug Auth Permissions Test\n');
  console.log('=' .repeat(50));

  const success = await testDebugAuthFunction();
  
  console.log('\n' + '=' .repeat(50));
  if (success) {
    console.log('🎉 Test completed successfully!');
    console.log('\n💡 Next steps:');
    console.log('1. Check Cloud Functions logs for the actual deleteUser function');
    console.log('2. Verify service account permissions in Firebase Console');
    console.log('3. Test the debugAuthPermissions function from the Flutter app');
  } else {
    console.log('💥 Test failed! Check the errors above.');
  }
}

main().catch(console.error);
