const { admin, db, auth, COLLECTIONS } = require('./config');

async function verifyData() {
  console.log('🔍 Verifying seeded data...');
  console.log('=' .repeat(50));
  
  try {
    // Verify Users
    console.log('\n👥 Users Collection:');
    const usersSnapshot = await db.collection(COLLECTIONS.USERS).get();
    console.log(`   Total users: ${usersSnapshot.size}`);
    
    const usersByRole = {};
    const usersByStatus = {};
    
    usersSnapshot.forEach(doc => {
      const data = doc.data();
      usersByRole[data.role] = (usersByRole[data.role] || 0) + 1;
      usersByStatus[data.status] = (usersByStatus[data.status] || 0) + 1;
    });
    
    console.log('   By role:', usersByRole);
    console.log('   By status:', usersByStatus);
    
    // Verify Authentication
    console.log('\n🔐 Firebase Authentication:');
    const authUsers = await auth.listUsers();
    console.log(`   Total auth users: ${authUsers.users.length}`);
    
    // Verify Categories
    console.log('\n📁 Categories Collection:');
    const categoriesSnapshot = await db.collection(COLLECTIONS.CATEGORIES).get();
    console.log(`   Total categories: ${categoriesSnapshot.size}`);
    
    const categoriesByStatus = {};
    categoriesSnapshot.forEach(doc => {
      const data = doc.data();
      const status = data.isActive ? 'active' : 'inactive';
      categoriesByStatus[status] = (categoriesByStatus[status] || 0) + 1;
    });
    
    console.log('   By status:', categoriesByStatus);
    
    // List categories
    console.log('   Categories:');
    categoriesSnapshot.forEach(doc => {
      const data = doc.data();
      const status = data.isActive ? '🟢' : '🔴';
      console.log(`     ${status} ${data.name} (${data.permissions.length} users)`);
    });
    
    // Verify Documents
    console.log('\n📄 Documents Collection:');
    const documentsSnapshot = await db.collection(COLLECTIONS.DOCUMENTS).get();
    console.log(`   Total documents: ${documentsSnapshot.size}`);
    
    const documentsByStatus = {};
    const documentsByCategory = {};
    let totalFileSize = 0;
    
    documentsSnapshot.forEach(doc => {
      const data = doc.data();
      const status = data.isActive ? 'active' : 'inactive';
      documentsByStatus[status] = (documentsByStatus[status] || 0) + 1;
      documentsByCategory[data.category] = (documentsByCategory[data.category] || 0) + 1;
      totalFileSize += data.fileSize || 0;
    });

    console.log('   By status:', documentsByStatus);
    console.log('   By category:', documentsByCategory);
    console.log(`   Total file size: ${formatFileSize(totalFileSize)}`);

    // List sample documents
    console.log('   Sample documents:');
    documentsSnapshot.docs.slice(0, 5).forEach(doc => {
      const data = doc.data();
      const status = data.isActive ? '🟢' : '🔴';
      console.log(`     ${status} ${data.fileName} (${data.category})`);
    });
    
    // Verify Activities
    console.log('\n📊 Activities Collection:');
    const activitiesSnapshot = await db.collection(COLLECTIONS.ACTIVITIES).get();
    console.log(`   Total activities: ${activitiesSnapshot.size}`);
    
    const activitiesByAction = {};
    activitiesSnapshot.forEach(doc => {
      const data = doc.data();
      activitiesByAction[data.action] = (activitiesByAction[data.action] || 0) + 1;
    });
    
    console.log('   By action:', activitiesByAction);
    
    // Summary
    console.log('\n' + '=' .repeat(50));
    console.log('📋 VERIFICATION SUMMARY:');
    console.log('=' .repeat(50));
    console.log(`✅ Users: ${usersSnapshot.size} documents`);
    console.log(`✅ Auth Users: ${authUsers.users.length} users`);
    console.log(`✅ Categories: ${categoriesSnapshot.size} documents`);
    console.log(`✅ Documents: ${documentsSnapshot.size} documents`);
    console.log(`✅ Activities: ${activitiesSnapshot.size} documents`);
    
    // Check for any issues
    const issues = [];
    
    if (usersSnapshot.size !== authUsers.users.length) {
      issues.push(`⚠️  Mismatch: ${usersSnapshot.size} Firestore users vs ${authUsers.users.length} Auth users`);
    }
    
    if (documentsSnapshot.size === 0) {
      issues.push('⚠️  No documents found');
    }
    
    if (categoriesSnapshot.size === 0) {
      issues.push('⚠️  No categories found');
    }
    
    if (issues.length > 0) {
      console.log('\n⚠️  ISSUES FOUND:');
      issues.forEach(issue => console.log(issue));
    } else {
      console.log('\n🎉 All data verified successfully!');
    }
    
  } catch (error) {
    console.error('❌ Error verifying data:', error);
  }
}

function formatFileSize(bytes) {
  if (bytes < 1024) {
    return `${bytes} bytes`;
  } else if (bytes < 1024 * 1024) {
    return `${(bytes / 1024).toFixed(1)} KB`;
  } else if (bytes < 1024 * 1024 * 1024) {
    return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
  } else {
    return `${(bytes / (1024 * 1024 * 1024)).toFixed(1)} GB`;
  }
}

// Run if called directly
if (require.main === module) {
  verifyData().then(() => {
    console.log('\n🏁 Verification completed!');
    process.exit(0);
  }).catch((error) => {
    console.error('\n💥 Verification failed:', error);
    process.exit(1);
  });
}

module.exports = { verifyData };
