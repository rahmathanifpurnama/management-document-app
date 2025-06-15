const { db, COLLECTIONS, generateTimestamp, generateId } = require("./config");

// Sample categories data that match the documents
const categoriesData = [
  {
    id: "finance",
    name: "Keuangan",
    description: "Dokumen terkait keuangan, laporan, dan anggaran",
    createdBy: "admin-uid-001", // Will be replaced with actual admin UID
    createdAt: generateTimestamp(30), // 1 month ago
    permissions: ["admin-uid-001", "user1-uid-002"],
    isActive: true,
    documentCount: 0
  },
  {
    id: "projects",
    name: "Proyek",
    description: "Dokumen proyek, proposal, dan rencana pengembangan",
    createdBy: "admin-uid-001",
    createdAt: generateTimestamp(25), // 25 days ago
    permissions: ["admin-uid-001", "user1-uid-002", "user2-uid-003"],
    isActive: true,
    documentCount: 0
  },
  {
    id: "documentation",
    name: "Dokumentasi",
    description: "Panduan, manual, dan dokumentasi sistem",
    createdBy: "user2-uid-003",
    createdAt: generateTimestamp(20), // 20 days ago
    permissions: ["admin-uid-001", "user1-uid-002", "user2-uid-003"],
    isActive: true,
    documentCount: 0
  },
  {
    id: "legal",
    name: "Legal",
    description: "Dokumen hukum, surat keputusan, dan peraturan",
    createdBy: "admin-uid-001",
    createdAt: generateTimestamp(15), // 15 days ago
    permissions: ["admin-uid-001"],
    isActive: true,
    documentCount: 0
  },
  {
    id: "hr",
    name: "SDM",
    description: "Dokumen sumber daya manusia dan kepegawaian",
    createdBy: "user3-uid-004",
    createdAt: generateTimestamp(10), // 10 days ago
    permissions: ["admin-uid-001", "user3-uid-004"],
    isActive: true,
    documentCount: 0
  },
  {
    id: "strategy",
    name: "Strategi",
    description: "Rencana strategis dan dokumen perencanaan",
    createdBy: "admin-uid-001",
    createdAt: generateTimestamp(8), // 8 days ago
    permissions: ["admin-uid-001", "user1-uid-002", "user2-uid-003"],
    isActive: true,
    documentCount: 0
  },
  {
    id: "contracts",
    name: "Kontrak",
    description: "Kontrak, perjanjian, dan dokumen kerjasama",
    createdBy: "user1-uid-002",
    createdAt: generateTimestamp(12), // 12 days ago
    permissions: ["admin-uid-001", "user1-uid-002"],
    isActive: true,
    documentCount: 0
  },
  {
    id: "technical",
    name: "Teknis",
    description: "Dokumen teknis, manual sistem, dan spesifikasi",
    createdBy: "user2-uid-003",
    createdAt: generateTimestamp(18), // 18 days ago
    permissions: ["admin-uid-001", "user2-uid-003"],
    isActive: true,
    documentCount: 0
  },
  {
    id: "archive",
    name: "Arsip",
    description: "Dokumen arsip dan dokumen lama",
    createdBy: "admin-uid-001",
    createdAt: generateTimestamp(35), // 35 days ago
    permissions: ["admin-uid-001"],
    isActive: true,
    documentCount: 0
  },
  {
    id: "backup",
    name: "Backup",
    description: "File backup dan restore sistem",
    createdBy: "user2-uid-003",
    createdAt: generateTimestamp(5), // 5 days ago
    permissions: ["admin-uid-001", "user2-uid-003"],
    isActive: true,
    documentCount: 0
  }
];

async function seedCategories() {
  console.log("🚀 Starting categories seeding...");

  try {
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
