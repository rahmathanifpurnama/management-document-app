const { admin, db, auth, COLLECTIONS, generateTimestamp } = require('./config');

// Sample users data
const usersData = [
  {
    uid: 'admin-001',
    email: 'admin@simdoc.com',
    password: 'password123',
    userData: {
      fullName: 'Administrator SIMDOC',
      email: 'admin@simdoc.com',
      role: 'admin',
      status: 'active',
      createdBy: null,
      createdAt: generateTimestamp(30),
      lastLogin: generateTimestamp(1),
      profileImage: null,
      permissions: {
        documents: ['view', 'upload', 'delete', 'approve'],
        categories: [],
        system: ['user_management', 'analytics']
      }
    }
  },
  {
    uid: 'user-001',
    email: 'user1@simdoc.com',
    password: 'password123',
    userData: {
      fullName: 'Budi Santoso',
      email: 'user1@simdoc.com',
      role: 'user',
      status: 'active',
      createdBy: 'admin-001',
      createdAt: generateTimestamp(25),
      lastLogin: generateTimestamp(2),
      profileImage: null,
      permissions: {
        documents: ['view', 'upload'],
        categories: [],
        system: []
      }
    }
  },
  {
    uid: 'user-002',
    email: 'user2@simdoc.com',
    password: 'password123',
    userData: {
      fullName: 'Siti Nurhaliza',
      email: 'user2@simdoc.com',
      role: 'user',
      status: 'active',
      createdBy: 'admin-001',
      createdAt: generateTimestamp(20),
      lastLogin: generateTimestamp(3),
      profileImage: null,
      permissions: {
        documents: ['view', 'upload'],
        categories: [],
        system: []
      }
    }
  },
  {
    uid: 'user-003',
    email: 'user3@simdoc.com',
    password: 'password123',
    userData: {
      fullName: 'Ahmad Wijaya',
      email: 'user3@simdoc.com',
      role: 'user',
      status: 'active',
      createdBy: 'admin-001',
      createdAt: generateTimestamp(15),
      lastLogin: generateTimestamp(5),
      profileImage: null,
      permissions: {
        documents: ['view', 'upload'],
        categories: [],
        system: []
      }
    }
  },
  {
    uid: 'user-004',
    email: 'user4@simdoc.com',
    password: 'password123',
    userData: {
      fullName: 'Dewi Lestari',
      email: 'user4@simdoc.com',
      role: 'user',
      status: 'inactive',
      createdBy: 'admin-001',
      createdAt: generateTimestamp(10),
      lastLogin: generateTimestamp(15),
      profileImage: null,
      permissions: {
        documents: ['view'],
        categories: [],
        system: []
      }
    }
  }
];

async function seedUsers() {
  console.log('🚀 Starting users seeding...');
  
  try {
    const batch = db.batch();
    
    for (const user of usersData) {
      // Create user in Firebase Authentication
      try {
        await auth.createUser({
          uid: user.uid,
          email: user.email,
          password: user.password,
          displayName: user.userData.fullName,
          emailVerified: true
        });
        console.log(`✅ Created auth user: ${user.email}`);
      } catch (error) {
        if (error.code === 'auth/uid-already-exists') {
          console.log(`⚠️  Auth user already exists: ${user.email}`);
        } else {
          console.error(`❌ Error creating auth user ${user.email}:`, error.message);
          continue;
        }
      }
      
      // Add user document to Firestore
      const userRef = db.collection(COLLECTIONS.USERS).doc(user.uid);
      batch.set(userRef, user.userData);
    }
    
    await batch.commit();
    console.log('✅ Users collection seeded successfully!');
    console.log(`📊 Total users created: ${usersData.length}`);
    
  } catch (error) {
    console.error('❌ Error seeding users:', error);
  }
}

// Run if called directly
if (require.main === module) {
  seedUsers().then(() => {
    console.log('🎉 Users seeding completed!');
    process.exit(0);
  }).catch((error) => {
    console.error('💥 Users seeding failed:', error);
    process.exit(1);
  });
}

module.exports = { seedUsers, usersData };
