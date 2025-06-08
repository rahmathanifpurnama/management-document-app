const { admin, db, auth, COLLECTIONS } = require('./config');

async function cleanupDatabase() {
  console.log('🧹 Starting database cleanup...');
  console.log('⚠️  WARNING: This will delete ALL data in the collections!');
  
  try {
    // Delete all documents in each collection
    const collections = Object.values(COLLECTIONS);
    
    for (const collectionName of collections) {
      console.log(`\n🗑️  Cleaning collection: ${collectionName}`);
      
      const snapshot = await db.collection(collectionName).get();
      const batch = db.batch();
      
      snapshot.docs.forEach(doc => {
        batch.delete(doc.ref);
      });
      
      if (snapshot.docs.length > 0) {
        await batch.commit();
        console.log(`✅ Deleted ${snapshot.docs.length} documents from ${collectionName}`);
      } else {
        console.log(`📭 Collection ${collectionName} is already empty`);
      }
    }
    
    // Clean up Firebase Authentication users
    console.log('\n🗑️  Cleaning Firebase Authentication users...');
    
    try {
      const listUsersResult = await auth.listUsers();
      const deletePromises = listUsersResult.users.map(user => {
        return auth.deleteUser(user.uid).then(() => {
          console.log(`✅ Deleted auth user: ${user.email || user.uid}`);
        }).catch(error => {
          console.error(`❌ Error deleting auth user ${user.uid}:`, error.message);
        });
      });
      
      await Promise.all(deletePromises);
      console.log(`✅ Cleaned up ${listUsersResult.users.length} authentication users`);
      
    } catch (error) {
      console.error('❌ Error cleaning authentication users:', error.message);
    }
    
    console.log('\n🎉 Database cleanup completed successfully!');
    
  } catch (error) {
    console.error('❌ Error during cleanup:', error);
  }
}

async function confirmCleanup() {
  const readline = require('readline');
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });
  
  return new Promise((resolve) => {
    rl.question('Are you sure you want to delete ALL data? Type "YES" to confirm: ', (answer) => {
      rl.close();
      resolve(answer === 'YES');
    });
  });
}

// Run if called directly
if (require.main === module) {
  confirmCleanup().then(confirmed => {
    if (confirmed) {
      return cleanupDatabase();
    } else {
      console.log('❌ Cleanup cancelled');
      process.exit(0);
    }
  }).then(() => {
    console.log('🏁 Cleanup process completed!');
    process.exit(0);
  }).catch((error) => {
    console.error('💥 Cleanup process failed:', error);
    process.exit(1);
  });
}

module.exports = { cleanupDatabase };
