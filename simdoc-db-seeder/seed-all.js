const { seedUsers } = require("./users");
const { seedCategories } = require("./categories");
const { seedDocuments } = require("./documents");
const { seedActivities } = require("./activities");

async function seedAll() {
  console.log("🚀 Starting SIMDOC database seeding...");
  console.log("=".repeat(50));

  try {
    // Seed in order: users -> categories -> documents -> activities
    console.log("\n1️⃣ Seeding Users...");
    await seedUsers();

    console.log("\n2️⃣ Seeding Categories...");
    await seedCategories();

    console.log("\n3️⃣ Seeding Documents...");
    await seedDocuments();

    console.log("\n4️⃣ Seeding Activities...");
    await seedActivities();

    console.log("\n" + "=".repeat(50));
    console.log("🎉 SIMDOC database seeding completed successfully!");
    console.log("=".repeat(50));

    // Summary
    console.log("\n📊 Seeding Summary:");
    console.log("✅ Users: 5 users created (1 admin, 4 regular users)");
    console.log("✅ Categories: 4 default categories (Surat Masuk, Surat Keputusan, Notulen Rapat, Laporan Evaluasi)");
    console.log("✅ Documents: 4 default document metadata entries (1 per category)");
    console.log("✅ Activities: Sample activities created based on existing users");

    console.log("\n🔐 Default Login Credentials:");
    console.log("Admin: admin@simdoc.com / password123");
    console.log("User1: user1@simdoc.com / password123");
    console.log("User2: user2@simdoc.com / password123");
    console.log("User3: user3@simdoc.com / password123");
    console.log("User4: user4@simdoc.com / password123 (inactive)");

    console.log("\n💡 Next Steps:");
    console.log("1. Test login with the provided credentials");
    console.log("2. Verify default categories and documents are properly seeded");
    console.log("3. Upload additional documents through the application interface");
    console.log("4. Deploy updated Firestore security rules");
    console.log("5. Verify search and filter functionality works correctly");
    console.log("6. Note: Default categories and sample documents are now seeded for testing!");
  } catch (error) {
    console.error("\n💥 Seeding failed:", error);
    process.exit(1);
  }
}

// Run the seeder
seedAll()
  .then(() => {
    console.log("\n🏁 Process completed!");
    process.exit(0);
  })
  .catch((error) => {
    console.error("\n💥 Process failed:", error);
    process.exit(1);
  });
