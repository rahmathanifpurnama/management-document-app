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

async function testAuthDelete() {
  try {
    console.log('🧪 Testing Firebase Auth Delete Functionality...\n');

    // Step 1: Create a test user
    console.log('📝 Step 1: Creating test user...');
    const testEmail = `test-delete-${Date.now()}@example.com`;
    const testPassword = 'testPassword123';
    
    const userRecord = await admin.auth().createUser({
      email: testEmail,
      password: testPassword,
      displayName: 'Test Delete User',
      emailVerified: false,
    });
    
    console.log(`✅ Test user created: ${userRecord.uid} (${testEmail})`);

    // Step 2: Verify user exists
    console.log('\n🔍 Step 2: Verifying user exists...');
    const userExists = await admin.auth().getUser(userRecord.uid);
    console.log(`✅ User verified: ${userExists.email}`);

    // Step 3: Test admin.auth().deleteUser()
    console.log('\n🗑️ Step 3: Testing admin.auth().deleteUser()...');
    await admin.auth().deleteUser(userRecord.uid);
    console.log(`✅ admin.auth().deleteUser() executed successfully for ${userRecord.uid}`);

    // Step 4: Verify user is actually deleted
    console.log('\n🔍 Step 4: Verifying user is deleted...');
    try {
      await admin.auth().getUser(userRecord.uid);
      console.log('❌ ERROR: User still exists after deletion!');
      return false;
    } catch (error) {
      if (error.code === 'auth/user-not-found') {
        console.log('✅ SUCCESS: User successfully deleted from Firebase Auth');
        return true;
      } else {
        console.log(`❌ Unexpected error: ${error.message}`);
        return false;
      }
    }

  } catch (error) {
    console.error('❌ Test failed:', error.message);
    console.error('Error code:', error.code);
    console.error('Full error:', error);
    return false;
  }
}

async function testPermissions() {
  try {
    console.log('\n🔐 Testing Firebase Admin Permissions...\n');

    // Test 1: Can we list users?
    console.log('📋 Test 1: Listing users...');
    const listUsersResult = await admin.auth().listUsers(5);
    console.log(`✅ Can list users: Found ${listUsersResult.users.length} users`);

    // Test 2: Can we create users?
    console.log('\n👤 Test 2: Creating user...');
    const testEmail = `test-perm-${Date.now()}@example.com`;
    const userRecord = await admin.auth().createUser({
      email: testEmail,
      password: 'testPassword123',
      displayName: 'Test Permission User',
    });
    console.log(`✅ Can create users: ${userRecord.uid}`);

    // Test 3: Can we update users?
    console.log('\n✏️ Test 3: Updating user...');
    await admin.auth().updateUser(userRecord.uid, {
      displayName: 'Updated Test User',
    });
    console.log(`✅ Can update users`);

    // Test 4: Can we delete users?
    console.log('\n🗑️ Test 4: Deleting user...');
    await admin.auth().deleteUser(userRecord.uid);
    console.log(`✅ Can delete users`);

    return true;
  } catch (error) {
    console.error('❌ Permission test failed:', error.message);
    console.error('Error code:', error.code);
    return false;
  }
}

async function main() {
  console.log('🚀 Firebase Auth Delete Test Suite\n');
  console.log('=' .repeat(50));

  // Test permissions first
  const permissionsOk = await testPermissions();
  if (!permissionsOk) {
    console.log('\n❌ Permission tests failed. Cannot proceed with delete test.');
    process.exit(1);
  }

  console.log('\n' + '=' .repeat(50));

  // Test delete functionality
  const deleteTestOk = await testAuthDelete();
  
  console.log('\n' + '=' .repeat(50));
  console.log('📊 TEST RESULTS:');
  console.log(`Permissions Test: ${permissionsOk ? '✅ PASS' : '❌ FAIL'}`);
  console.log(`Delete Test: ${deleteTestOk ? '✅ PASS' : '❌ FAIL'}`);
  
  if (permissionsOk && deleteTestOk) {
    console.log('\n🎉 ALL TESTS PASSED! admin.auth().deleteUser() is working correctly.');
  } else {
    console.log('\n💥 SOME TESTS FAILED! There may be permission or configuration issues.');
  }
}

main().catch(console.error);
