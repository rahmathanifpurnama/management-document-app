const admin = require('./functions/node_modules/firebase-admin');

// Initialize Firebase Admin SDK
if (!admin.apps.length) {
  admin.initializeApp({
    projectId: 'document-management-c5a96'
  });
}

async function createAdminUser() {
  try {
    console.log('🔍 Checking for existing admin users...');
    
    // Check existing users
    const usersSnapshot = await admin.firestore().collection('users').get();
    
    if (usersSnapshot.empty) {
      console.log('📝 No users found. Creating first admin user...');
    } else {
      console.log(`📋 Found ${usersSnapshot.size} existing users:`);
      
      let hasAdmin = false;
      usersSnapshot.forEach(doc => {
        const userData = doc.data();
        console.log(`   - ${userData.fullName || 'N/A'} (${userData.email || 'N/A'}) - Role: ${userData.role || 'N/A'}`);
        if (userData.role === 'admin') {
          hasAdmin = true;
        }
      });
      
      if (hasAdmin) {
        console.log('✅ Admin user already exists. No action needed.');
        return;
      }
      
      console.log('⚠️  No admin users found. Creating admin user...');
    }
    
    // Create admin user in Firebase Auth
    console.log('🔐 Creating admin user in Firebase Auth...');
    const userRecord = await admin.auth().createUser({
      email: 'admin@managementdoc.com',
      password: 'AdminPass123!',
      displayName: 'System Administrator',
      emailVerified: true,
    });
    
    console.log(`✅ Admin user created in Auth: ${userRecord.uid}`);
    
    // Create admin user document in Firestore
    console.log('📄 Creating admin user document in Firestore...');
    const adminUserData = {
      id: userRecord.uid,
      fullName: 'System Administrator',
      email: 'admin@managementdoc.com',
      role: 'admin',
      status: 'active',
      isActive: true,
      createdBy: 'system',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      permissions: {
        documents: ['view', 'upload', 'delete', 'approve'],
        categories: [],
        system: ['user_management', 'analytics']
      },
      lastLogin: null,
      profileImageUrl: null,
    };
    
    await admin.firestore()
      .collection('users')
      .doc(userRecord.uid)
      .set(adminUserData);
    
    console.log('✅ Admin user document created in Firestore');
    
    // Log activity
    await admin.firestore()
      .collection('activities')
      .add({
        type: 'admin_user_created',
        userId: userRecord.uid,
        createdBy: 'system',
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        details: 'System administrator account created',
      });
    
    console.log('📝 Activity logged');
    
    console.log('\n🎉 SUCCESS! Admin user created successfully.');
    console.log('📧 Email: admin@managementdoc.com');
    console.log('🔑 Password: AdminPass123!');
    console.log('\n⚠️  IMPORTANT: Please change the password after first login!');
    
  } catch (error) {
    console.error('❌ Error creating admin user:', error);
    
    if (error.code === 'auth/email-already-exists') {
      console.log('📧 Email already exists in Firebase Auth.');
      console.log('🔍 Checking if user document exists in Firestore...');
      
      try {
        // Get user by email
        const userRecord = await admin.auth().getUserByEmail('admin@managementdoc.com');
        const userDoc = await admin.firestore().collection('users').doc(userRecord.uid).get();
        
        if (!userDoc.exists) {
          console.log('📄 User document missing in Firestore. Creating...');
          
          const adminUserData = {
            id: userRecord.uid,
            fullName: 'System Administrator',
            email: 'admin@managementdoc.com',
            role: 'admin',
            status: 'active',
            isActive: true,
            createdBy: 'system',
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            permissions: {
              documents: ['view', 'upload', 'delete', 'approve'],
              categories: [],
              system: ['user_management', 'analytics']
            },
            lastLogin: null,
            profileImageUrl: null,
          };
          
          await admin.firestore()
            .collection('users')
            .doc(userRecord.uid)
            .set(adminUserData);
          
          console.log('✅ Admin user document created in Firestore');
        } else {
          const userData = userDoc.data();
          if (userData.role !== 'admin') {
            console.log('🔧 Updating user role to admin...');
            await admin.firestore()
              .collection('users')
              .doc(userRecord.uid)
              .update({
                role: 'admin',
                permissions: {
                  documents: ['view', 'upload', 'delete', 'approve'],
                  categories: [],
                  system: ['user_management', 'analytics']
                },
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
              });
            console.log('✅ User role updated to admin');
          } else {
            console.log('✅ User is already an admin');
          }
        }
      } catch (innerError) {
        console.error('❌ Error handling existing user:', innerError);
      }
    }
  }
}

// Run the script
createAdminUser().then(() => {
  console.log('\n🏁 Script completed');
  process.exit(0);
}).catch(error => {
  console.error('💥 Script failed:', error);
  process.exit(1);
});
