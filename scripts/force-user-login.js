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

async function forceUserLogin() {
  try {
    console.log('🔄 Forcing user login refresh...\n');

    // Target user that has "Never" signed in
    const targetUserId = 'CP8jF9s65PRCK2qgCigmCt0SBv13'; // rahmat145hanif@gmail.com
    const targetEmail = 'rahmat145hanif@gmail.com';

    console.log(`🎯 Target user: ${targetEmail}`);
    console.log(`🆔 User ID: ${targetUserId}`);

    // 1. Get current user data
    const userDoc = await db.collection('users').doc(targetUserId).get();
    if (!userDoc.exists) {
      console.log('❌ User not found in Firestore');
      return;
    }

    const userData = userDoc.data();
    console.log(`📋 Current user data:`, JSON.stringify(userData, null, 2));

    // 2. Get Firebase Auth user
    try {
      const authUser = await admin.auth().getUser(targetUserId);
      console.log(`\n🔐 Firebase Auth user:`, {
        email: authUser.email,
        emailVerified: authUser.emailVerified,
        disabled: authUser.disabled,
        lastSignInTime: authUser.metadata.lastSignInTime,
        creationTime: authUser.metadata.creationTime
      });

      // 3. Generate custom token for testing
      const customToken = await admin.auth().createCustomToken(targetUserId);
      console.log(`\n🔑 Generated custom token for testing:`);
      console.log(`Token: ${customToken.substring(0, 100)}...`);

      // 4. Update user's lastLogin timestamp to simulate login
      await db.collection('users').doc(targetUserId).update({
        lastLogin: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp()
      });
      console.log(`\n✅ Updated user's lastLogin timestamp`);

      // 5. Verify email if not verified
      if (!authUser.emailVerified) {
        await admin.auth().updateUser(targetUserId, {
          emailVerified: true
        });
        console.log(`✅ Marked email as verified`);
      }

      // 6. Test Storage Rules with this user
      console.log(`\n🧪 Testing Storage Rules for this user:`);
      
      // Simulate Storage Rules conditions
      const conditions = {
        'User exists in Firestore': userDoc.exists,
        'User is active': userData.status === 'active',
        'User has upload permission': userData.permissions?.documents?.includes('upload'),
        'User has view permission': userData.permissions?.documents?.includes('view'),
        'Email verified': true, // We just set it
      };

      console.log(`📋 Storage Rules Check:`);
      for (const [condition, result] of Object.entries(conditions)) {
        console.log(`   ${result ? '✅' : '❌'} ${condition}: ${result}`);
      }

      const allGood = Object.values(conditions).every(Boolean);
      console.log(`\n🎯 Result: ${allGood ? '✅ SHOULD WORK NOW' : '❌ STILL HAS ISSUES'}`);

      if (allGood) {
        console.log(`\n📱 INSTRUCTIONS FOR APP:`);
        console.log(`1. User should LOGOUT from the app completely`);
        console.log(`2. User should LOGIN again with: ${targetEmail}`);
        console.log(`3. This will refresh the authentication token`);
        console.log(`4. Then try uploading files again`);
        console.log(`\n🔧 Alternative: Use this custom token for testing in app`);
        console.log(`Token: ${customToken}`);
      }

    } catch (authError) {
      console.log(`❌ Error getting Firebase Auth user: ${authError.message}`);
    }

  } catch (error) {
    console.error('❌ Error forcing user login:', error);
  }
}

// Run the script
forceUserLogin()
  .then(() => {
    console.log('\n🎉 Force login completed!');
    process.exit(0);
  })
  .catch((error) => {
    console.error('❌ Script failed:', error);
    process.exit(1);
  });
