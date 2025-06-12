const admin = require('firebase-admin');

// Initialize Firebase Admin SDK for emulator
if (!admin.apps.length) {
  admin.initializeApp({
    projectId: 'document-management-c5a96'
  });

  // Connect to emulator
  process.env.FIRESTORE_EMULATOR_HOST = '127.0.0.1:8080';
  process.env.FIREBASE_AUTH_EMULATOR_HOST = '127.0.0.1:9099';
}

async function testCreateUser() {
  try {
    console.log('🔍 Testing createUser function...');
    
    // First, let's check if we have any admin users
    console.log('📋 Checking existing users...');
    const usersSnapshot = await admin.firestore().collection('users').get();
    
    console.log(`Found ${usersSnapshot.size} users:`);
    usersSnapshot.forEach(doc => {
      const userData = doc.data();
      console.log(`- ${userData.fullName} (${userData.email}) - Role: ${userData.role}`);
    });
    
    // Find an admin user
    const adminUsers = usersSnapshot.docs.filter(doc => doc.data().role === 'admin');
    
    if (adminUsers.length === 0) {
      console.log('❌ No admin users found! Creating a test admin user first...');
      
      // Create a test admin user directly in Firestore
      const testAdminId = 'test-admin-001';
      await admin.firestore().collection('users').doc(testAdminId).set({
        id: testAdminId,
        fullName: 'Test Admin',
        email: 'admin@test.com',
        role: 'admin',
        status: 'active',
        isActive: true,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        permissions: {
          documents: ['view', 'upload', 'delete', 'approve'],
          categories: [],
          system: ['user_management', 'analytics']
        }
      });
      
      console.log('✅ Test admin user created');
      return;
    }
    
    const adminUser = adminUsers[0];
    console.log(`✅ Found admin user: ${adminUser.data().fullName}`);
    
    // Test the createUser function
    console.log('🧪 Testing createUser function...');
    
    // Simulate the function call context
    const context = {
      auth: {
        uid: adminUser.id
      }
    };
    
    const testUserData = {
      fullName: 'Test User',
      email: 'testuser@example.com',
      password: 'testpassword123',
      role: 'user',
      permissions: {
        documents: ['view', 'upload'],
        categories: [],
        system: []
      }
    };
    
    // Import and call the createUser function
    const { createUser } = require('./lib/modules/userManagement');
    
    const result = await createUser(testUserData, context);
    console.log('✅ createUser function result:', result);
    
  } catch (error) {
    console.error('❌ Error testing createUser:', error);
    console.error('Error details:', error.message);
    console.error('Error code:', error.code);
  }
}

// Run the test
testCreateUser().then(() => {
  console.log('🏁 Test completed');
  process.exit(0);
}).catch(error => {
  console.error('💥 Test failed:', error);
  process.exit(1);
});
