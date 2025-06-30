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

async function testUploadCriteria() {
  try {
    console.log('🔍 === TESTING UPLOAD CRITERIA ===\n');

    // Test both users
    const testUsers = [
      {
        uid: 'PFnoTjoDdtcG9qJBsizIhz3n5Uf2', // web.hanif61@gmail.com (admin)
        email: 'web.hanif61@gmail.com',
        expectedRole: 'admin'
      },
      {
        uid: 'CP8jF9s65PRCK2qgCigmCt0SBv13', // rahmat145hanif@gmail.com (user)
        email: 'rahmat145hanif@gmail.com',
        expectedRole: 'user'
      }
    ];

    for (const testUser of testUsers) {
      console.log(`🧪 Testing user: ${testUser.email}`);
      console.log(`🆔 UID: ${testUser.uid}`);
      
      const issues = [];
      let canUpload = false;

      // 1. Check if user exists in Firebase Auth
      try {
        const authUser = await admin.auth().getUser(testUser.uid);
        console.log(`✅ 1. User exists in Firebase Auth`);
        console.log(`   Email verified: ${authUser.emailVerified}`);
        console.log(`   Disabled: ${authUser.disabled}`);
        console.log(`   Last sign in: ${authUser.metadata.lastSignInTime || 'Never'}`);
        
        if (authUser.disabled) {
          issues.push('❌ User account is disabled');
        }
      } catch (authError) {
        issues.push('❌ 1. User tidak ada di Firebase Auth');
        console.log(`❌ 1. User tidak ada di Firebase Auth: ${authError.message}`);
      }

      // 2. Check if user document exists in Firestore
      const userDoc = await db.collection('users').doc(testUser.uid).get();
      if (!userDoc.exists) {
        issues.push('❌ 2. User document tidak ada di Firestore');
        console.log(`❌ 2. User document tidak ada di Firestore`);
      } else {
        console.log(`✅ 2. User document ada di Firestore`);
        
        const userData = userDoc.data();
        
        // 3. Check if user status is 'active'
        const userStatus = userData.status;
        if (userStatus !== 'active') {
          issues.push(`❌ 3. User status bukan 'active': ${userStatus}`);
          console.log(`❌ 3. User status bukan 'active': ${userStatus}`);
        } else {
          console.log(`✅ 3. User status adalah 'active'`);
        }

        // 4. Check if user has upload permission
        const permissions = userData.permissions;
        const documentPermissions = permissions?.documents;
        const userRole = userData.role;
        const isAdmin = userRole === 'admin';
        
        console.log(`   Role: ${userRole}`);
        console.log(`   Is Admin: ${isAdmin}`);
        console.log(`   Document permissions: ${JSON.stringify(documentPermissions)}`);
        
        let hasUploadPermission = false;
        if (documentPermissions && Array.isArray(documentPermissions)) {
          hasUploadPermission = documentPermissions.includes('upload');
        }

        if (!hasUploadPermission && !isAdmin) {
          issues.push('❌ 4. User tidak punya permission upload');
          console.log(`❌ 4. User tidak punya permission upload`);
        } else {
          if (isAdmin) {
            console.log(`✅ 4. User adalah admin (punya semua permission)`);
          } else {
            console.log(`✅ 4. User punya permission upload`);
          }
        }

        // 5. Test Storage Rules simulation
        console.log(`\n🧪 Storage Rules Simulation:`);
        
        // Simulate the exact conditions in storage.rules
        const storageRulesConditions = {
          'request.auth != null': true, // Assuming user is authenticated
          'firestore.exists(/databases/(default)/documents/users/$(request.auth.uid))': userDoc.exists,
          'user.status == "active"': userStatus === 'active',
          'hasDocumentPermission("upload")': hasUploadPermission || isAdmin,
        };

        console.log(`📋 Storage Rules Conditions:`);
        for (const [condition, result] of Object.entries(storageRulesConditions)) {
          console.log(`   ${result ? '✅' : '❌'} ${condition}: ${result}`);
        }

        const allConditionsMet = Object.values(storageRulesConditions).every(Boolean);
        canUpload = allConditionsMet;
        
        console.log(`\n🎯 Storage Rules Result: ${canUpload ? '✅ SHOULD ALLOW UPLOAD' : '❌ WILL DENY UPLOAD'}`);

        // 6. Check metadata requirements
        console.log(`\n📋 Metadata Requirements Check:`);
        console.log(`✅ uploadedBy: ${testUser.uid} (akan disertakan otomatis)`);
        console.log(`✅ originalName: [filename] (akan disertakan otomatis)`);
        console.log(`✅ uploadTimestamp: [timestamp] (akan disertakan otomatis)`);
      }

      // Final result
      console.log(`\n📊 FINAL RESULT for ${testUser.email}:`);
      if (issues.length === 0 && canUpload) {
        console.log(`🎉 SEMUA KRITERIA TERPENUHI - UPLOAD SEHARUSNYA BERHASIL`);
      } else {
        console.log(`❌ ADA MASALAH - UPLOAD AKAN GAGAL`);
        console.log(`🔍 Issues found:`);
        issues.forEach(issue => console.log(`   ${issue}`));
      }

      console.log('\n' + '='.repeat(80) + '\n');
    }

    // Test current admin specifically
    console.log(`🎯 KHUSUS UNTUK ADMIN YANG SEDANG LOGIN:`);
    console.log(`Jika Anda login sebagai: web.hanif61@gmail.com`);
    console.log(`Maka upload seharusnya berhasil karena:`);
    console.log(`✅ Admin role`);
    console.log(`✅ Status active`);
    console.log(`✅ Punya semua permission`);
    console.log(`✅ Email verified`);
    console.log(`\nJika masih error, kemungkinan masalah di:`);
    console.log(`🔍 1. Token authentication di client-side`);
    console.log(`🔍 2. Network connectivity`);
    console.log(`🔍 3. Storage Rules cache belum refresh`);
    console.log(`🔍 4. Upload metadata tidak lengkap`);

  } catch (error) {
    console.error('❌ Error testing upload criteria:', error);
  }
}

// Run the test
testUploadCriteria()
  .then(() => {
    console.log('\n🎉 Upload criteria test completed!');
    process.exit(0);
  })
  .catch((error) => {
    console.error('❌ Script failed:', error);
    process.exit(1);
  });
