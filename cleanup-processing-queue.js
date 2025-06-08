const admin = require("firebase-admin");
const serviceAccount = require("../simdoc-db-seeder/credentials.json");

// Initialize Firebase Admin SDK
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: `https://${serviceAccount.project_id}-default-rtdb.firebaseio.com`,
});

const db = admin.firestore();

async function cleanupProcessingQueue() {
  console.log("🧹 Starting cleanup of processing_queue collection...");

  try {
    // Get all documents in processing_queue collection
    const queueSnapshot = await db.collection("processing_queue").get();

    if (queueSnapshot.empty) {
      console.log(
        "✅ Processing queue collection is already empty or does not exist."
      );
      return;
    }

    console.log(
      `📋 Found ${queueSnapshot.size} documents in processing_queue collection`
    );

    // Delete documents in batches
    const batchSize = 500;
    const batches = [];

    for (let i = 0; i < queueSnapshot.docs.length; i += batchSize) {
      const batch = db.batch();
      const batchDocs = queueSnapshot.docs.slice(i, i + batchSize);

      batchDocs.forEach((doc) => {
        batch.delete(doc.ref);
      });

      batches.push(batch);
    }

    // Execute all batches
    for (let i = 0; i < batches.length; i++) {
      await batches[i].commit();
      console.log(`✅ Deleted batch ${i + 1}/${batches.length}`);
    }

    console.log("🎉 Successfully cleaned up processing_queue collection!");
    console.log(`📊 Total documents deleted: ${queueSnapshot.size}`);
  } catch (error) {
    console.error("❌ Error cleaning up processing queue:", error);
    throw error;
  }
}

async function verifyCleanup() {
  console.log("\n🔍 Verifying cleanup...");

  try {
    const queueSnapshot = await db.collection("processing_queue").get();

    if (queueSnapshot.empty) {
      console.log(
        "✅ Verification successful: processing_queue collection is empty"
      );
    } else {
      console.log(
        `⚠️  Warning: ${queueSnapshot.size} documents still exist in processing_queue`
      );
    }
  } catch (error) {
    console.error("❌ Error during verification:", error);
  }
}

async function main() {
  try {
    await cleanupProcessingQueue();
    await verifyCleanup();

    console.log("\n💡 Cleanup completed successfully!");
    console.log("📝 Summary:");
    console.log("   - Removed all processing_queue documents from Firestore");
    console.log("   - Processing queue functionality has been disabled");
    console.log("   - File status management now only shows pending files");
  } catch (error) {
    console.error("\n💥 Cleanup failed:", error);
    process.exit(1);
  } finally {
    process.exit(0);
  }
}

// Run the cleanup
main();
