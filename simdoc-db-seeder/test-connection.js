const { admin, db, auth } = require('./config');

async function testConnection() {
  console.log('🔍 Testing Firebase connection...');
  console.log('=' .repeat(40));
  
  try {
    // Test Firestore connection
    console.log('\n📊 Testing Firestore connection...');
    const testDoc = await db.collection('test').doc('connection-test').set({
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      message: 'Connection test successful'
    });
    
    // Read the test document
    const testRead = await db.collection('test').doc('connection-test').get();
    if (testRead.exists) {
      console.log('✅ Firestore connection: SUCCESS');
      console.log(`   Data: ${JSON.stringify(testRead.data())}`);
    }
    
    // Clean up test document
    await db.collection('test').doc('connection-test').delete();
    console.log('🧹 Test document cleaned up');
    
    // Test Firebase Authentication
    console.log('\n🔐 Testing Firebase Authentication...');
    try {
      const listUsersResult = await auth.listUsers(1);
      console.log('✅ Firebase Auth connection: SUCCESS');
      console.log(`   Current users count: ${listUsersResult.users.length}`);
    } catch (authError) {
      console.log('❌ Firebase Auth connection: FAILED');
      console.error('   Error:', authError.message);
    }
    
    // Test project info
    console.log('\n📋 Project Information:');
    const projectId = admin.app().options.projectId;
    console.log(`   Project ID: ${projectId}`);
    console.log(`   Service Account: ${admin.app().options.credential.clientEmail || 'N/A'}`);
    
    console.log('\n' + '=' .repeat(40));
    console.log('🎉 Connection test completed successfully!');
    console.log('✅ Ready to run database seeding');
    
  } catch (error) {
    console.log('\n' + '=' .repeat(40));
    console.error('❌ Connection test failed!');
    console.error('Error details:', error.message);
    
    if (error.code === 'ENOENT' && error.path && error.path.includes('credentials.json')) {
      console.log('\n💡 Solution:');
      console.log('1. Download Firebase service account key from Firebase Console');
      console.log('2. Rename it to "credentials.json"');
      console.log('3. Place it in this folder');
    } else if (error.message.includes('project')) {
      console.log('\n💡 Solution:');
      console.log('1. Check if the project ID in credentials.json is correct');
      console.log('2. Ensure Firestore is enabled in Firebase Console');
      console.log('3. Verify service account has proper permissions');
    }
    
    process.exit(1);
  }
}

// Run if called directly
if (require.main === module) {
  testConnection().then(() => {
    console.log('\n🏁 Test completed!');
    process.exit(0);
  }).catch((error) => {
    console.error('\n💥 Test failed:', error);
    process.exit(1);
  });
}

module.exports = { testConnection };
