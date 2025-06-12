const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
if (!admin.apps.length) {
  admin.initializeApp({
    projectId: 'document-management-c5a96'
  });
}

async function debugUserRole() {
  try {
    console.log('🔍 Debugging user roles in production Firestore...');
    
    // Get all users from Firestore
    const usersSnapshot = await admin.firestore().collection('users').get();
    
    if (usersSnapshot.empty) {
      console.log('❌ No users found in Firestore!');
      return;
    }
    
    console.log(`📋 Found ${usersSnapshot.size} users:`);
    console.log('=====================================');
    
    usersSnapshot.forEach(doc => {
      const userData = doc.data();
      console.log(`👤 User ID: ${doc.id}`);
      console.log(`   Name: ${userData.fullName || 'N/A'}`);
      console.log(`   Email: ${userData.email || 'N/A'}`);
      console.log(`   Role: ${userData.role || 'N/A'}`);
      console.log(`   Status: ${userData.status || 'N/A'}`);
      console.log(`   Active: ${userData.isActive || false}`);
      console.log('-------------------------------------');
    });
    
    // Check for admin users
    const adminUsers = usersSnapshot.docs.filter(doc => doc.data().role === 'admin');
    console.log(`\n🔑 Admin users found: ${adminUsers.length}`);
    
    if (adminUsers.length === 0) {
      console.log('⚠️  WARNING: No admin users found! This explains the permission error.');
      console.log('💡 Solution: You need to manually set at least one user as admin.');
      
      // Show how to fix this
      console.log('\n🛠️  To fix this issue:');
      console.log('1. Go to Firebase Console > Firestore Database');
      console.log('2. Find a user document in the "users" collection');
      console.log('3. Edit the user document and change the "role" field to "admin"');
      console.log('4. Make sure "isActive" is set to true');
      console.log('5. Save the changes');
      
      return;
    }
    
    // Show admin users
    console.log('\n✅ Admin users:');
    adminUsers.forEach(doc => {
      const userData = doc.data();
      console.log(`   - ${userData.fullName} (${userData.email})`);
    });
    
  } catch (error) {
    console.error('❌ Error debugging user roles:', error);
    console.error('Error details:', error.message);
    
    if (error.message.includes('credentials') || error.message.includes('authentication')) {
      console.log('\n💡 Authentication issue detected.');
      console.log('This script needs to run with proper Firebase credentials.');
      console.log('The error in your app might be due to:');
      console.log('1. No admin users in the database');
      console.log('2. Current user not having admin role');
      console.log('3. Firestore security rules blocking the operation');
    }
  }
}

// Run the debug
debugUserRole().then(() => {
  console.log('\n🏁 Debug completed');
  process.exit(0);
}).catch(error => {
  console.error('💥 Debug failed:', error);
  process.exit(1);
});
