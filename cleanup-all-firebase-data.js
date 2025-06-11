const admin = require("firebase-admin");
const serviceAccount = require("./simdoc-db-seeder/credentials.json");

// Initialize Firebase Admin SDK
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: `https://${serviceAccount.project_id}-default-rtdb.firebaseio.com`,
  storageBucket: `${serviceAccount.project_id}.appspot.com`
});

const db = admin.firestore();
const storage = admin.storage();

async function deleteCollection(collectionName) {
  console.log(`🗑️ Deleting collection: ${collectionName}`);
  
  try {
    const collectionRef = db.collection(collectionName);
    const snapshot = await collectionRef.get();
    
    if (snapshot.empty) {
      console.log(`✅ Collection ${collectionName} is already empty`);
      return;
    }
    
    console.log(`📋 Found ${snapshot.size} documents in ${collectionName}`);
    
    // Delete in batches
    const batchSize = 500;
    const batches = [];
    
    for (let i = 0; i < snapshot.docs.length; i += batchSize) {
      const batch = db.batch();
      const batchDocs = snapshot.docs.slice(i, i + batchSize);
      
      batchDocs.forEach(doc => {
        batch.delete(doc.ref);
      });
      
      batches.push(batch);
    }
    
    // Execute all batches
    for (let i = 0; i < batches.length; i++) {
      await batches[i].commit();
      console.log(`✅ Deleted batch ${i + 1}/${batches.length} from ${collectionName}`);
    }
    
    console.log(`🎉 Successfully deleted all documents from ${collectionName}`);
  } catch (error) {
    console.error(`❌ Error deleting collection ${collectionName}:`, error);
  }
}

async function deleteStorageFolder(folderPath) {
  console.log(`🗑️ Deleting storage folder: ${folderPath}`);
  
  try {
    const bucket = storage.bucket();
    const [files] = await bucket.getFiles({ prefix: folderPath });
    
    if (files.length === 0) {
      console.log(`✅ Storage folder ${folderPath} is already empty`);
      return;
    }
    
    console.log(`📋 Found ${files.length} files in ${folderPath}`);
    
    // Delete files in batches
    const batchSize = 100;
    for (let i = 0; i < files.length; i += batchSize) {
      const batch = files.slice(i, i + batchSize);
      await Promise.all(batch.map(file => file.delete()));
      console.log(`✅ Deleted batch ${Math.floor(i/batchSize) + 1}/${Math.ceil(files.length/batchSize)} from ${folderPath}`);
    }
    
    console.log(`🎉 Successfully deleted all files from ${folderPath}`);
  } catch (error) {
    console.error(`❌ Error deleting storage folder ${folderPath}:`, error);
  }
}

async function cleanupAllFirebaseData() {
  console.log("🧹 Starting complete Firebase cleanup...");
  console.log("⚠️  This will delete ALL data from Firestore and Storage!");
  
  try {
    // Delete all Firestore collections
    const collections = [
      'users',
      'categories', 
      'documents',
      'activities',
      'processing_queue',
      'metadata',
      'notifications'
    ];
    
    for (const collection of collections) {
      await deleteCollection(collection);
    }
    
    // Delete all Storage folders
    const storageFolders = [
      'documents/',
      'profile_images/',
      'temp/',
      'uploads/'
    ];
    
    for (const folder of storageFolders) {
      await deleteStorageFolder(folder);
    }
    
    console.log("\n🎉 CLEANUP COMPLETED SUCCESSFULLY!");
    console.log("📝 Summary:");
    console.log("   ✅ All Firestore collections cleared");
    console.log("   ✅ All Storage files deleted");
    console.log("   ✅ Database is now completely clean");
    console.log("\n🚀 Ready for fresh data seeding!");
    
  } catch (error) {
    console.error("\n💥 Cleanup failed:", error);
    process.exit(1);
  } finally {
    process.exit(0);
  }
}

// Confirmation prompt
console.log("⚠️  WARNING: This will delete ALL data from Firebase!");
console.log("   - All Firestore collections will be emptied");
console.log("   - All Storage files will be deleted");
console.log("   - This action cannot be undone!");
console.log("\nPress Ctrl+C to cancel, or wait 10 seconds to continue...");

setTimeout(() => {
  cleanupAllFirebaseData();
}, 10000);
