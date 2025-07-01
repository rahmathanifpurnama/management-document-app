const admin = require('firebase-admin');

// Initialize Firebase Admin if not already initialized
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.applicationDefault(),
    projectId: 'document-management-c5a96'
  });
}

async function fixAdminUser() {
  try {
    console.log('🔍 Checking all users in Firebase Auth and Firestore...');

    // List all users in Firebase Auth
    const authUsers = await admin.auth().listUsers();
    console.log(`📊 Found ${authUsers.users.length} users in Firebase Auth:`);

    for (const authUser of authUsers.users) {
      console.log(`\n👤 Auth User: ${authUser.email} (${authUser.uid})`);
      console.log(`   Disabled: ${authUser.disabled}`);
      console.log(`   Email Verified: ${authUser.emailVerified}`);

      // Check corresponding Firestore document
      const userDoc = await admin.firestore().collection('users').doc(authUser.uid).get();

      if (userDoc.exists) {
        const userData = userDoc.data();
        console.log(`   📄 Firestore Document EXISTS:`);
        console.log(`      Role: ${userData.role}`);
        console.log(`      Status: ${userData.status}`);
        console.log(`      Email: ${userData.email}`);
        console.log(`      Can Create Categories: ${userData.role === 'admin' && userData.status === 'active'}`);
      } else {
        console.log(`   ❌ Firestore Document MISSING`);
      }
    }

    // Now specifically check the admin email
    const adminEmail = 'web.hanif61@gmail.com';
    console.log(`\n🎯 Specifically checking admin: ${adminEmail}`);

    let authUser;
    try {
      authUser = await admin.auth().getUserByEmail(adminEmail);
      console.log(`✅ Found admin in Auth: ${authUser.email} (${authUser.uid})`);
    } catch (error) {
      console.log(`❌ Admin not found in Firebase Auth: ${adminEmail}`);
      return;
    }

    // Check if user document exists in Firestore
    const userDoc = await admin.firestore().collection('users').doc(authUser.uid).get();

    if (!userDoc.exists) {
      console.log(`❌ User document missing in Firestore for ${authUser.email}`);

      // Create user document with admin role
      const userData = {
        id: authUser.uid,
        fullName: 'Web Hanif',
        email: authUser.email,
        role: 'admin',
        status: 'active',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        permissions: {
          documents: ['view', 'upload', 'delete', 'approve'],
          categories: [],
          system: ['user_management', 'analytics']
        },
        lastLogin: null,
        profileImageUrl: null
      };

      await admin.firestore().collection('users').doc(authUser.uid).set(userData);
      console.log(`✅ Created admin user document for ${authUser.email}`);

    } else {
      const userData = userDoc.data();
      console.log(`📋 Current user data:`);
      console.log(`   Role: ${userData.role}`);
      console.log(`   Status: ${userData.status}`);
      console.log(`   Email: ${userData.email}`);

      // Update to admin if not already
      if (userData.role !== 'admin' || userData.status !== 'active') {
        await admin.firestore().collection('users').doc(authUser.uid).update({
          role: 'admin',
          status: 'active',
          email: authUser.email,
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          permissions: {
            documents: ['view', 'upload', 'delete', 'approve'],
            categories: [],
            system: ['user_management', 'analytics']
          }
        });

        console.log(`✅ Updated ${authUser.email} to admin with active status`);
      } else {
        console.log(`✅ ${authUser.email} is already admin and active`);
      }
    }

    console.log('\n🎉 Admin user fix completed!');
    console.log('Now try to logout and login again in your app, then test creating category.');

  } catch (error) {
    console.error('❌ Error fixing admin user:', error);
    if (error.message.includes('permission')) {
      console.log('\n💡 Permission error detected. Please fix manually in Firebase Console:');
      console.log('1. Go to Firebase Console → Firestore');
      console.log('2. Open "users" collection');
      console.log('3. Find/create document with ID matching the UID of web.hanif61@gmail.com');
      console.log('4. Set role: "admin" and status: "active"');
    }
  }
}

fixAdminUser();
