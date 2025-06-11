/**
 * Database Seeder - Firestore Only (No Firebase Auth)
 * 
 * This script seeds the database without creating Firebase Authentication users.
 * Use this as a workaround when you don't have Firebase Auth permissions.
 */

const { admin, db, COLLECTIONS, generateTimestamp } = require('./config');

// Import seeder modules
const { seedCategories } = require('./categories');
const { seedDocuments } = require('./documents');
const { seedActivities } = require('./activities');

// User data without Firebase Auth creation
const usersData = [
  {
    uid: 'admin_001',
    userData: {
      fullName: 'Admin User',
      email: 'admin@simdoc.com',
      role: 'admin',
      department: 'IT',
      phoneNumber: '+62812345678',
      isActive: true,
      createdAt: generateTimestamp(30),
      lastLoginAt: generateTimestamp(1),
      profilePicture: null
    }
  },
  {
    uid: 'user_001',
    userData: {
      fullName: 'John Doe',
      email: 'user1@simdoc.com',
      role: 'user',
      department: 'Finance',
      phoneNumber: '+62812345679',
      isActive: true,
      createdAt: generateTimestamp(25),
      lastLoginAt: generateTimestamp(2),
      profilePicture: null
    }
  },
  {
    uid: 'user_002',
    userData: {
      fullName: 'Jane Smith',
      email: 'user2@simdoc.com',
      role: 'user',
      department: 'HR',
      phoneNumber: '+62812345680',
      isActive: true,
      createdAt: generateTimestamp(20),
      lastLoginAt: generateTimestamp(3),
      profilePicture: null
    }
  },
  {
    uid: 'user_003',
    userData: {
      fullName: 'Bob Wilson',
      email: 'user3@simdoc.com',
      role: 'user',
      department: 'Operations',
      phoneNumber: '+62812345681',
      isActive: true,
      createdAt: generateTimestamp(15),
      lastLoginAt: generateTimestamp(4),
      profilePicture: null
    }
  },
  {
    uid: 'user_004',
    userData: {
      fullName: 'Alice Brown',
      email: 'user4@simdoc.com',
      role: 'user',
      department: 'Marketing',
      phoneNumber: '+62812345682',
      isActive: true,
      createdAt: generateTimestamp(10),
      lastLoginAt: generateTimestamp(5),
      profilePicture: null
    }
  }
];

/**
 * Seed users in Firestore only (no Firebase Auth)
 */
async function seedUsersFirestoreOnly() {
  console.log('👥 Starting users seeding (Firestore only)...');

  try {
    const batch = db.batch();
    
    for (const user of usersData) {
      // Add user document to Firestore only
      const userRef = db.collection(COLLECTIONS.USERS).doc(user.uid);
      batch.set(userRef, user.userData);
      console.log(`📝 Prepared Firestore user: ${user.userData.email}`);
    }
    
    await batch.commit();
    console.log('✅ Users collection seeded successfully!');
    console.log(`📊 Total users created: ${usersData.length}`);
    console.log('⚠️  Note: Firebase Authentication users were NOT created');
    console.log('   You can create them later when you have proper permissions');
    
  } catch (error) {
    console.error('❌ Error seeding users:', error);
    throw error;
  }
}

/**
 * Main seeding function
 */
async function seedAll() {
  console.log('🚀 Starting database seeding (without Firebase Auth)...');
  console.log('📅 ' + new Date().toLocaleString());
  console.log('=' .repeat(50));

  try {
    // 1. Seed Users (Firestore only)
    console.log('1️⃣ Seeding Users (Firestore only)...');
    await seedUsersFirestoreOnly();
    console.log('');

    // 2. Seed Categories
    console.log('2️⃣ Seeding Categories...');
    await seedCategories();
    console.log('');

    // 3. Seed Documents
    console.log('3️⃣ Seeding Documents...');
    await seedDocuments();
    console.log('');

    // 4. Seed Activities
    console.log('4️⃣ Seeding Activities...');
    await seedActivities();
    console.log('');

    console.log('=' .repeat(50));
    console.log('🎉 Database seeding completed successfully!');
    console.log('');
    console.log('📋 Summary:');
    console.log('   ✅ Users (Firestore documents)');
    console.log('   ✅ Categories');
    console.log('   ✅ Documents');
    console.log('   ✅ Activities');
    console.log('');
    console.log('⚠️  Firebase Authentication users were NOT created');
    console.log('   To create them, fix the IAM permissions and run:');
    console.log('   node users.js');

  } catch (error) {
    console.error('💥 Seeding failed:', error);
    throw error;
  }
}

// Run if called directly
if (require.main === module) {
  seedAll().then(() => {
    console.log('🏁 Seeding process completed!');
    process.exit(0);
  }).catch((error) => {
    console.error('💥 Seeding process failed:', error);
    process.exit(1);
  });
}

module.exports = { seedAll, seedUsersFirestoreOnly, usersData };
