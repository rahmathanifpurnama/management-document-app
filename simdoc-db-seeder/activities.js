const admin = require("firebase-admin");
const { COLLECTIONS } = require("./config");

/**
 * Seed sample activities for testing
 * This creates realistic activity logs for the application
 */
async function seedActivities() {
  console.log("🔄 Starting activities seeding...");

  try {
    const db = admin.firestore();
    const activitiesRef = db.collection(COLLECTIONS.ACTIVITIES);

    // Get existing users and documents for realistic activity logs
    const usersSnapshot = await db.collection(COLLECTIONS.USERS).get();
    const documentsSnapshot = await db.collection(COLLECTIONS.DOCUMENTS).get();

    if (usersSnapshot.empty) {
      console.log("⚠️ No users found. Please seed users first.");
      return;
    }

    const users = usersSnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    const documents = documentsSnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));

    // Sample activities to create
    const sampleActivities = [];

    // Create login activities for all users
    users.forEach(user => {
      // Recent login
      sampleActivities.push({
        userId: user.id,
        action: "login",
        resource: "System Login",
        timestamp: admin.firestore.Timestamp.fromDate(
          new Date(Date.now() - Math.random() * 7 * 24 * 60 * 60 * 1000) // Last 7 days
        ),
        details: {
          userAgent: "Flutter App",
          platform: "Mobile",
          deviceId: `device_${Math.random().toString(36).substr(2, 9)}`,
          appVersion: "1.0.0"
        }
      });

      // Some logout activities
      if (Math.random() > 0.3) {
        sampleActivities.push({
          userId: user.id,
          action: "logout",
          resource: "System Logout",
          timestamp: admin.firestore.Timestamp.fromDate(
            new Date(Date.now() - Math.random() * 5 * 24 * 60 * 60 * 1000) // Last 5 days
          ),
          details: {
            userAgent: "Flutter App",
            platform: "Mobile",
            sessionDuration: Math.floor(Math.random() * 3600) // seconds
          }
        });
      }
    });

    // Create document-related activities (only if documents exist)
    if (documents.length > 0) {
      documents.forEach(document => {
        // Upload activity
        sampleActivities.push({
          userId: document.uploadedBy,
          action: "upload",
          resource: `Document: ${document.fileName}`,
          timestamp: document.uploadedAt,
          details: {
            userAgent: "Flutter App",
            platform: "Mobile",
            fileSize: document.fileSize,
            fileType: document.fileType,
            category: document.category || "uncategorized"
          }
        });

        // Some download activities from different users
        const randomUsers = users.filter(u => u.id !== document.uploadedBy);
        const downloadCount = Math.floor(Math.random() * 3);

        for (let i = 0; i < downloadCount; i++) {
          const randomUser = randomUsers[Math.floor(Math.random() * randomUsers.length)];
          if (randomUser) {
            sampleActivities.push({
              userId: randomUser.id,
              action: "download",
              resource: `Document: ${document.fileName}`,
              timestamp: admin.firestore.Timestamp.fromDate(
                new Date(document.uploadedAt.toDate().getTime() + Math.random() * 7 * 24 * 60 * 60 * 1000)
              ),
              details: {
                userAgent: "Flutter App",
                platform: "Mobile",
                documentId: document.id,
                fileSize: document.fileSize
              }
            });
          }
        }
      });
    } else {
      console.log("⚠️ No documents found. Skipping document-related activities.");

      // Add some basic system activities when no documents exist
      const systemActivities = [
        {
          userId: users[0]?.id || "system",
          action: "system_init",
          resource: "System Initialization",
          timestamp: admin.firestore.Timestamp.fromDate(
            new Date(Date.now() - Math.random() * 30 * 24 * 60 * 60 * 1000)
          ),
          details: {
            userAgent: "System",
            platform: "Server",
            message: "System initialized successfully"
          }
        }
      ];

      sampleActivities.push(...systemActivities);
    }

    // Create user management activities (admin actions)
    const adminUsers = users.filter(u => u.role === 'admin');
    if (adminUsers.length > 0) {
      const adminUser = adminUsers[0];

      // Some user creation activities
      users.slice(1, 3).forEach(user => {
        sampleActivities.push({
          userId: adminUser.id,
          action: "create_user",
          resource: `User: ${user.fullName}`,
          timestamp: admin.firestore.Timestamp.fromDate(
            new Date(Date.now() - Math.random() * 30 * 24 * 60 * 60 * 1000) // Last 30 days
          ),
          details: {
            userAgent: "Flutter App",
            platform: "Mobile",
            targetUserId: user.id,
            targetUserEmail: user.email,
            targetUserRole: user.role
          }
        });
      });

      // Some user update activities
      users.slice(0, 2).forEach(user => {
        sampleActivities.push({
          userId: adminUser.id,
          action: "update_user",
          resource: `User: ${user.fullName}`,
          timestamp: admin.firestore.Timestamp.fromDate(
            new Date(Date.now() - Math.random() * 14 * 24 * 60 * 60 * 1000) // Last 14 days
          ),
          details: {
            userAgent: "Flutter App",
            platform: "Mobile",
            targetUserId: user.id,
            changes: ["profile_updated"]
          }
        });
      });
    }

    // Sort activities by timestamp (newest first)
    sampleActivities.sort((a, b) => b.timestamp.toDate() - a.timestamp.toDate());

    // Check if we have activities to seed
    if (sampleActivities.length === 0) {
      console.log("⚠️ No activities to seed. This is normal if no users or documents exist.");
      return;
    }

    // Batch write activities
    const batchSize = 500;
    let batch = db.batch();
    let operationCount = 0;

    console.log(`📝 Creating ${sampleActivities.length} sample activities...`);

    for (const activity of sampleActivities) {
      const docRef = activitiesRef.doc();
      batch.set(docRef, activity);
      operationCount++;

      if (operationCount === batchSize) {
        await batch.commit();
        console.log(`✅ Committed batch of ${batchSize} activities`);
        batch = db.batch();
        operationCount = 0;
      }
    }

    // Commit remaining operations
    if (operationCount > 0) {
      await batch.commit();
      console.log(`✅ Committed final batch of ${operationCount} activities`);
    }

    console.log("✅ Activities seeded successfully!");
    console.log(`📊 Total activities created: ${sampleActivities.length}`);
    
    // Summary by action type
    const actionSummary = {};
    sampleActivities.forEach(activity => {
      actionSummary[activity.action] = (actionSummary[activity.action] || 0) + 1;
    });
    
    console.log("📈 Activity breakdown:");
    Object.entries(actionSummary).forEach(([action, count]) => {
      console.log(`   ${action}: ${count}`);
    });

  } catch (error) {
    console.error("❌ Error seeding activities:", error);
    throw error;
  }
}

module.exports = { seedActivities };
