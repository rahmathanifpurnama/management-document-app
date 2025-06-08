const { db, COLLECTIONS, generateTimestamp } = require("./config");

// No default categories - start with empty category system
const categoriesData = [];

async function seedCategories() {
  console.log("🚀 Starting categories seeding...");

  try {
    const batch = db.batch();

    for (const category of categoriesData) {
      const categoryRef = db
        .collection(COLLECTIONS.CATEGORIES)
        .doc(category.id);
      const { id, ...categoryData } = category;
      batch.set(categoryRef, categoryData);
    }

    await batch.commit();
    console.log("✅ Categories collection seeded successfully!");
    console.log(`📊 Total categories created: ${categoriesData.length}`);

    // Display categories summary
    console.log("\n📋 Categories Summary:");
    categoriesData.forEach((cat) => {
      const status = cat.isActive ? "🟢 Active" : "🔴 Inactive";
      console.log(`  ${status} ${cat.name} - ${cat.permissions.length} users`);
    });
  } catch (error) {
    console.error("❌ Error seeding categories:", error);
  }
}

// Run if called directly
if (require.main === module) {
  seedCategories()
    .then(() => {
      console.log("🎉 Categories seeding completed!");
      process.exit(0);
    })
    .catch((error) => {
      console.error("💥 Categories seeding failed:", error);
      process.exit(1);
    });
}

module.exports = { seedCategories, categoriesData };
