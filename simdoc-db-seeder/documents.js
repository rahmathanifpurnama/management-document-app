const { db, COLLECTIONS, generateTimestamp, generateId } = require("./config");

// No default documents - start with empty document system
const documentsData = [];

async function seedDocuments() {
  console.log("🚀 Starting documents seeding...");

  try {
    const batch = db.batch();

    for (const document of documentsData) {
      const docRef = db.collection(COLLECTIONS.DOCUMENTS).doc(document.id);
      const { id, ...docData } = document;
      batch.set(docRef, docData);
    }

    await batch.commit();
    console.log("✅ Documents collection seeded successfully!");
    console.log(`📊 Total documents created: ${documentsData.length}`);

    // Display documents summary by status
    const statusCount = documentsData.reduce((acc, doc) => {
      acc[doc.status] = (acc[doc.status] || 0) + 1;
      return acc;
    }, {});

    console.log("\n📋 Documents Summary by Status:");
    Object.entries(statusCount).forEach(([status, count]) => {
      const emoji =
        status === "approved" ? "✅" : status === "pending" ? "⏳" : "❌";
      console.log(`  ${emoji} ${status}: ${count} documents`);
    });
  } catch (error) {
    console.error("❌ Error seeding documents:", error);
  }
}

// Run if called directly
if (require.main === module) {
  seedDocuments()
    .then(() => {
      console.log("🎉 Documents seeding completed!");
      process.exit(0);
    })
    .catch((error) => {
      console.error("💥 Documents seeding failed:", error);
      process.exit(1);
    });
}

module.exports = { seedDocuments, documentsData };
