/**
 * Permission Verification Script
 * 
 * This script tests if the service account has all required permissions
 * for Firebase Authentication and Firestore operations.
 */

const { admin, db, auth } = require('./config');

async function verifyPermissions() {
  console.log('🔍 Verifying Firebase permissions...');
  console.log('📅 ' + new Date().toLocaleString());
  console.log('=' .repeat(50));

  const results = {
    firestore: false,
    authentication: false,
    serviceUsage: false
  };

  // Test 1: Firestore Access
  console.log('\n1️⃣ Testing Firestore Access...');
  try {
    const testDoc = db.collection('_permission_test').doc('test');
    await testDoc.set({ test: true, timestamp: admin.firestore.Timestamp.now() });
    await testDoc.delete();
    console.log('✅ Firestore: READ/WRITE access confirmed');
    results.firestore = true;
  } catch (error) {
    console.log('❌ Firestore: Access denied');
    console.log('   Error:', error.message);
  }

  // Test 2: Firebase Authentication Access
  console.log('\n2️⃣ Testing Firebase Authentication Access...');
  try {
    // Try to list users (this requires auth admin permissions)
    const listResult = await auth.listUsers(1);
    console.log('✅ Firebase Auth: LIST users access confirmed');
    
    // Try to create a test user (this is the main issue)
    const testEmail = `test-${Date.now()}@example.com`;
    try {
      const userRecord = await auth.createUser({
        email: testEmail,
        password: 'tempPassword123',
        displayName: 'Test User'
      });
      console.log('✅ Firebase Auth: CREATE user access confirmed');
      
      // Clean up test user
      await auth.deleteUser(userRecord.uid);
      console.log('✅ Firebase Auth: DELETE user access confirmed');
      results.authentication = true;
      
    } catch (createError) {
      console.log('❌ Firebase Auth: CREATE user access denied');
      console.log('   Error:', createError.message);
      
      if (createError.message.includes('serviceusage.serviceUsageConsumer')) {
        console.log('   🔧 SOLUTION: Add "Service Usage Consumer" role to service account');
        console.log('   📋 Instructions: See AUTHENTICATION_FIX.md');
      }
    }
    
  } catch (error) {
    console.log('❌ Firebase Auth: Basic access denied');
    console.log('   Error:', error.message);
  }

  // Test 3: Service Usage API (indirect test)
  console.log('\n3️⃣ Testing Service Usage Consumer Role...');
  try {
    // This is an indirect test - if we can create auth users, we have the role
    if (results.authentication) {
      console.log('✅ Service Usage Consumer: Role confirmed (auth creation works)');
      results.serviceUsage = true;
    } else {
      console.log('❌ Service Usage Consumer: Role missing or insufficient');
      console.log('   🔧 Add this role in Google Cloud Console IAM');
    }
  } catch (error) {
    console.log('❌ Service Usage Consumer: Cannot verify');
    console.log('   Error:', error.message);
  }

  // Summary
  console.log('\n' + '=' .repeat(50));
  console.log('📊 PERMISSION VERIFICATION SUMMARY');
  console.log('=' .repeat(50));
  
  console.log(`Firestore Access:           ${results.firestore ? '✅ PASS' : '❌ FAIL'}`);
  console.log(`Firebase Authentication:    ${results.authentication ? '✅ PASS' : '❌ FAIL'}`);
  console.log(`Service Usage Consumer:     ${results.serviceUsage ? '✅ PASS' : '❌ FAIL'}`);
  
  const allPassed = results.firestore && results.authentication && results.serviceUsage;
  
  if (allPassed) {
    console.log('\n🎉 ALL PERMISSIONS VERIFIED!');
    console.log('✅ You can now run the database seeder:');
    console.log('   node seed.js');
  } else {
    console.log('\n⚠️  PERMISSION ISSUES DETECTED');
    console.log('🔧 Required Actions:');
    
    if (!results.firestore) {
      console.log('   - Fix Firestore permissions');
    }
    if (!results.authentication || !results.serviceUsage) {
      console.log('   - Add "Service Usage Consumer" role to service account');
      console.log('   - See AUTHENTICATION_FIX.md for detailed instructions');
    }
    
    console.log('\n📋 Quick Fix URL:');
    console.log('https://console.developers.google.com/iam-admin/iam/project?project=document-management-c5a96');
  }
  
  console.log('\n🔍 Service Account Details:');
  console.log('   Email: firebase-adminsdk-fbsvc@document-management-c5a96.iam.gserviceaccount.com');
  console.log('   Project: document-management-c5a96');
  
  return allPassed;
}

// Run verification if called directly
if (require.main === module) {
  verifyPermissions()
    .then((success) => {
      console.log('\n🏁 Verification completed!');
      process.exit(success ? 0 : 1);
    })
    .catch((error) => {
      console.error('\n💥 Verification failed:', error);
      process.exit(1);
    });
}

module.exports = { verifyPermissions };
