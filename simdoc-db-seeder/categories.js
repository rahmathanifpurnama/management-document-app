const { db, COLLECTIONS, generateTimestamp, generateId } = require("./config");

// Categories data - restored default categories
const categoriesData = [
  {
    id: "surat-masuk",
    name: "Surat Masuk",
    description: "Kategori untuk surat-surat yang masuk ke organisasi",
    createdBy: "admin-uid-001", // Will be replaced with actual admin UID
    createdAt: generateTimestamp(30), // 30 days ago
    permissions: ["admin-uid-001", "user1-uid-002"],
    isActive: true,
    documentCount: 0
  },
  {
    id: "surat-keputusan",
    name: "Surat Keputusan",
    description: "Kategori untuk surat keputusan dan kebijakan organisasi",
    createdBy: "admin-uid-001", // Will be replaced with actual admin UID
    createdAt: generateTimestamp(25), // 25 days ago
    permissions: ["admin-uid-001", "user1-uid-002"],
    isActive: true,
    documentCount: 0
  },
  {
    id: "notulen-rapat",
    name: "Notulen Rapat",
    description: "Kategori untuk notulen dan hasil rapat organisasi",
    createdBy: "admin-uid-001", // Will be replaced with actual admin UID
    createdAt: generateTimestamp(20), // 20 days ago
    permissions: ["admin-uid-001", "user1-uid-002"],
    isActive: true,
    documentCount: 0
  },
  {
    id: "laporan-evaluasi",
    name: "Laporan Evaluasi",
    description: "Kategori untuk laporan evaluasi dan monitoring",
    createdBy: "admin-uid-001", // Will be replaced with actual admin UID
    createdAt: generateTimestamp(15), // 15 days ago
    permissions: ["admin-uid-001", "user1-uid-002"],
    isActive: true,
    documentCount: 0
  }
];

async function seedCategories() {
  console.log("🚀 Starting categories seeding...");

  try {
    // Check if there are any categories to seed
    if (categoriesData.length === 0) {
      console.log("ℹ️ No default categories to seed. Categories collection will remain empty.");
      console.log("💡 Add categories to the categoriesData array if you want to seed default categories.");
      return;
    }

    // Get actual user UIDs from users collection
    const usersSnapshot = await db.collection(COLLECTIONS.USERS).get();
    const userMap = {};

    usersSnapshot.docs.forEach(doc => {
      const userData = doc.data();
      if (userData.email === 'admin@simdoc.com') {
        userMap['admin-uid-001'] = doc.id;
      } else if (userData.email === 'user1@simdoc.com') {
        userMap['user1-uid-002'] = doc.id;
      } else if (userData.email === 'user2@simdoc.com') {
        userMap['user2-uid-003'] = doc.id;
      } else if (userData.email === 'user3@simdoc.com') {
        userMap['user3-uid-004'] = doc.id;
      }
    });

    console.log("📋 Found users for categories:", Object.keys(userMap).length);

    const batch = db.batch();

    for (const category of categoriesData) {
      const categoryRef = db
        .collection(COLLECTIONS.CATEGORIES)
        .doc(category.id);
      const { id, ...categoryData } = category;

      // Replace placeholder UIDs with actual UIDs
      if (userMap[categoryData.createdBy]) {
        categoryData.createdBy = userMap[categoryData.createdBy];
      }

      // Replace placeholder UIDs in permissions array
      categoryData.permissions = categoryData.permissions.map(uid =>
        userMap[uid] || uid
      );

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

    console.log("\n📂 Sample Categories Created:");
    categoriesData.slice(0, 5).forEach(cat => {
      console.log(`  📁 ${cat.name}: ${cat.description}`);
    });

  } catch (error) {
    console.error("❌ Error seeding categories:", error);
    throw error;
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
