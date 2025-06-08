const { db, COLLECTIONS, generateTimestamp, generateId } = require("./config");

// No default activities - start with empty activity system
const activitiesData = [];

async function seedActivities() {
  console.log("🚀 Starting activities seeding...");

  try {
    const batch = db.batch();

    for (const activity of activitiesData) {
      const activityRef = db
        .collection(COLLECTIONS.ACTIVITIES)
        .doc(activity.id);
      const { id, ...activityData } = activity;
      batch.set(activityRef, activityData);
    }

    await batch.commit();
    console.log("✅ Activities collection seeded successfully!");
    console.log(`📊 Total activities created: ${activitiesData.length}`);

    // Display activities summary by action
    const actionCount = activitiesData.reduce((acc, activity) => {
      acc[activity.action] = (acc[activity.action] || 0) + 1;
      return acc;
    }, {});

    console.log("\n📋 Activities Summary by Action:");
    Object.entries(actionCount).forEach(([action, count]) => {
      console.log(`  📝 ${action}: ${count} activities`);
    });
  } catch (error) {
    console.error("❌ Error seeding activities:", error);
  }
}

// Run if called directly
if (require.main === module) {
  seedActivities()
    .then(() => {
      console.log("🎉 Activities seeding completed!");
      process.exit(0);
    })
    .catch((error) => {
      console.error("💥 Activities seeding failed:", error);
      process.exit(1);
    });
}

module.exports = { seedActivities, activitiesData };
