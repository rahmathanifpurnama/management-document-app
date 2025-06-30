#!/usr/bin/env node

/**
 * Comprehensive Database Seeder
 *
 * This script sets up initial data for the Document Management System
 * using the new database structure with isActive field for user account status management
 * and supporting hard delete operations for data management.
 */

const admin = require('firebase-admin');
const readline = require('readline');
const path = require('path');

// Initialize Firebase Admin SDK
function initializeFirebase() {
  if (!admin.apps.length) {
    const isEmulator = process.env.FIRESTORE_EMULATOR_HOST || process.env.NODE_ENV === 'development';

    if (isEmulator) {
      console.log('🔧 Using Firebase Emulator');
      admin.initializeApp({
        projectId: 'document-management-c5a96'
      });

      // Connect to emulators
      process.env.FIRESTORE_EMULATOR_HOST = process.env.FIRESTORE_EMULATOR_HOST || '127.0.0.1:8080';
      process.env.FIREBASE_AUTH_EMULATOR_HOST = process.env.FIREBASE_AUTH_EMULATOR_HOST || '127.0.0.1:9099';
      process.env.FIREBASE_STORAGE_EMULATOR_HOST = process.env.FIREBASE_STORAGE_EMULATOR_HOST || '127.0.0.1:9199';
    } else {
      console.log('🔥 Using Production Firebase');

      // Try to load service account from multiple possible locations
      const possiblePaths = [
        path.join(__dirname, 'config', 'service-account-key.json'),
        path.join(__dirname, '..', 'config', 'service-account-key.json'),
        process.env.GOOGLE_APPLICATION_CREDENTIALS,
        './service-account-key.json'
      ].filter(Boolean);

      let serviceAccountPath = null;
      const fs = require('fs');

      for (const possiblePath of possiblePaths) {
        if (fs.existsSync(possiblePath)) {
          serviceAccountPath = possiblePath;
          break;
        }
      }

      if (!serviceAccountPath) {
        console.log('❌ Service account key not found!');
        console.log('📋 Please ensure one of the following:');
        console.log('   1. Place service-account-key.json in scripts/config/');
        console.log('   2. Set GOOGLE_APPLICATION_CREDENTIALS environment variable');
        console.log('   3. Place service-account-key.json in project root');
        console.log('');
        console.log('🔗 Get service account key from:');
        console.log('   Firebase Console > Project Settings > Service Accounts > Generate new private key');
        process.exit(1);
      }

      try {
        const serviceAccount = require(serviceAccountPath);
        admin.initializeApp({
          credential: admin.credential.cert(serviceAccount),
          projectId: serviceAccount.project_id,
          storageBucket: `${serviceAccount.project_id}.appspot.com`
        });

        console.log(`✅ Production Firebase initialized with service account`);
        console.log(`📁 Service account: ${serviceAccountPath}`);
        console.log(`🏗️  Project ID: ${serviceAccount.project_id}`);
      } catch (error) {
        console.log('❌ Failed to initialize Firebase with service account');
        console.log('💡 Error:', error.message);
        console.log('');
        console.log('🔍 Please check:');
        console.log('   1. Service account key file is valid JSON');
        console.log('   2. Service account has proper permissions');
        console.log('   3. Project ID matches your Firebase project');
        process.exit(1);
      }
    }
  }
}

// Create readline interface
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// Utility function to ask questions
function askQuestion(question) {
  return new Promise((resolve) => {
    rl.question(question, (answer) => {
      resolve(answer.trim());
    });
  });
}

// Permission templates - Only admin and user roles
const PERMISSIONS = {
  admin: {
    documents: ['view', 'upload', 'delete', 'approve'],
    categories: [],
    system: ['user_management', 'analytics']
  },
  user: {
    documents: ['view', 'upload'],
    categories: [],
    system: []
  }
};

// Sample categories data
const SAMPLE_CATEGORIES = [
  {
    id: 'general',
    name: 'General Documents',
    description: 'General purpose documents and files',
    color: '#2196F3',
    icon: 'folder',
    sortOrder: 1,
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    id: 'contracts',
    name: 'Contracts',
    description: 'Legal contracts and agreements',
    color: '#FF9800',
    icon: 'description',
    sortOrder: 2,
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    id: 'reports',
    name: 'Reports',
    description: 'Business reports and analytics',
    color: '#4CAF50',
    icon: 'assessment',
    sortOrder: 3,
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    id: 'policies',
    name: 'Policies',
    description: 'Company policies and procedures',
    color: '#9C27B0',
    icon: 'policy',
    sortOrder: 4,
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    id: 'invoices',
    name: 'Invoices',
    description: 'Financial invoices and receipts',
    color: '#F44336',
    icon: 'receipt',
    sortOrder: 5,
    createdAt: new Date(),
    updatedAt: new Date()
  }
];

// Sample users data (will be created in Firebase Auth and Firestore)
// Only admin and user roles as per application requirements
const SAMPLE_USERS = [
  {
    email: 'web.hanif61@gmail.com',
    password: 'Admin123!',
    fullName: 'Rahmat Hanif Purnama',
    role: 'admin',
    status: 'active',
    isActive: true,
    permissions: PERMISSIONS.admin
  },
  {
    email: 'rahmat145hanif@gmail.com',
    password: 'hanif123',
    fullName: 'Hanif',
    role: 'user',
    status: 'active',
    isActive: true,
    permissions: PERMISSIONS.user
  },
];

// Clear existing data
async function clearExistingData() {
  console.log('🧹 Clearing existing data...');
  
  try {
    // Clear Firestore collections
    const collections = ['users', 'categories', 'documents', 'activities'];
    
    for (const collectionName of collections) {
      const snapshot = await admin.firestore().collection(collectionName).get();
      const batch = admin.firestore().batch();
      
      snapshot.docs.forEach(doc => {
        batch.delete(doc.ref);
      });
      
      if (!snapshot.empty) {
        await batch.commit();
        console.log(`✅ Cleared ${snapshot.size} documents from ${collectionName}`);
      }
    }
    
    // Clear Firebase Auth users (except the current admin if any)
    const listUsersResult = await admin.auth().listUsers();
    const userUids = listUsersResult.users.map(user => user.uid);
    
    if (userUids.length > 0) {
      await admin.auth().deleteUsers(userUids);
      console.log(`✅ Cleared ${userUids.length} users from Firebase Auth`);
    }
    
    console.log('✅ Data clearing completed');
  } catch (error) {
    console.error('❌ Error clearing data:', error.message);
    throw error;
  }
}

// Seed categories
async function seedCategories() {
  console.log('📁 Seeding categories...');
  
  try {
    const batch = admin.firestore().batch();
    
    for (const category of SAMPLE_CATEGORIES) {
      const categoryRef = admin.firestore().collection('categories').doc(category.id);
      batch.set(categoryRef, {
        ...category,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp()
      });
    }
    
    await batch.commit();
    console.log(`✅ Created ${SAMPLE_CATEGORIES.length} categories`);
  } catch (error) {
    console.error('❌ Error seeding categories:', error.message);
    throw error;
  }
}

// Seed users
async function seedUsers() {
  console.log('👥 Seeding users...');
  
  try {
    for (const userData of SAMPLE_USERS) {
      // Create user in Firebase Auth
      const userRecord = await admin.auth().createUser({
        email: userData.email,
        password: userData.password,
        displayName: userData.fullName,
        disabled: false
      });
      
      // Set custom claims for admin users
      if (userData.role === 'admin') {
        await admin.auth().setCustomUserClaims(userRecord.uid, { admin: true });
      }
      
      // Create user document in Firestore
      await admin.firestore().collection('users').doc(userRecord.uid).set({
        id: userRecord.uid,
        fullName: userData.fullName,
        email: userData.email,
        role: userData.role,
        status: userData.status,
        isActive: userData.isActive,
        permissions: userData.permissions,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        lastLogin: null,
        profileImageUrl: null
      });
      
      console.log(`✅ Created user: ${userData.fullName} (${userData.email})`);
    }
    
    console.log(`✅ Created ${SAMPLE_USERS.length} users`);
  } catch (error) {
    console.error('❌ Error seeding users:', error.message);
    throw error;
  }
}

// Seed sample documents metadata
async function seedDocuments() {
  console.log('📄 Seeding sample documents...');
  
  try {
    // Get admin user for document creation
    const adminUser = SAMPLE_USERS.find(user => user.role === 'admin');
    const adminAuthUser = await admin.auth().getUserByEmail(adminUser.email);
    
    const sampleDocuments = [
      {
        fileName: 'Company_Policy_2024.pdf',
        originalName: 'Company Policy 2024.pdf',
        category: 'policies',
        description: 'Updated company policies for 2024',
        status: 'approved',
        fileSize: 1024000,
        mimeType: 'application/pdf'
      },
      {
        fileName: 'Q1_Financial_Report.xlsx',
        originalName: 'Q1 Financial Report.xlsx',
        category: 'reports',
        description: 'First quarter financial report',
        status: 'pending',
        fileSize: 512000,
        mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      },
      {
        fileName: 'Service_Agreement_Template.docx',
        originalName: 'Service Agreement Template.docx',
        category: 'contracts',
        description: 'Standard service agreement template',
        status: 'approved',
        fileSize: 256000,
        mimeType: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
      }
    ];
    
    for (const docData of sampleDocuments) {
      const docRef = admin.firestore().collection('documents').doc();
      
      await docRef.set({
        id: docRef.id,
        fileName: docData.fileName,
        originalName: docData.originalName,
        category: docData.category,
        description: docData.description,
        status: docData.status,
        fileSize: docData.fileSize,
        mimeType: docData.mimeType,
        uploadedBy: adminAuthUser.uid,
        uploadedAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        downloadUrl: `gs://your-bucket/documents/${docRef.id}`,
        storagePath: `documents/${docRef.id}`,
        version: 1,
        tags: [],
        approvedBy: docData.status === 'approved' ? adminAuthUser.uid : null,
        approvedAt: docData.status === 'approved' ? admin.firestore.FieldValue.serverTimestamp() : null
      });
      
      console.log(`✅ Created document: ${docData.fileName}`);
    }
    
    console.log(`✅ Created ${sampleDocuments.length} sample documents`);
  } catch (error) {
    console.error('❌ Error seeding documents:', error.message);
    throw error;
  }
}

// Seed initial activities
async function seedActivities() {
  console.log('📊 Seeding initial activities...');

  try {
    const adminUser = SAMPLE_USERS.find(user => user.role === 'admin');
    const adminAuthUser = await admin.auth().getUserByEmail(adminUser.email);

    const activities = [
      {
        type: 'system_initialized',
        userId: adminAuthUser.uid,
        details: 'Database seeded with initial data',
        timestamp: admin.firestore.FieldValue.serverTimestamp()
      },
      {
        type: 'categories_created',
        userId: adminAuthUser.uid,
        details: `Created ${SAMPLE_CATEGORIES.length} document categories`,
        timestamp: admin.firestore.FieldValue.serverTimestamp()
      },
      {
        type: 'users_created',
        userId: adminAuthUser.uid,
        details: `Created ${SAMPLE_USERS.length} user accounts`,
        timestamp: admin.firestore.FieldValue.serverTimestamp()
      }
    ];

    for (const activity of activities) {
      await admin.firestore().collection('activities').add(activity);
    }

    console.log(`✅ Created ${activities.length} initial activities`);
  } catch (error) {
    console.error('❌ Error seeding activities:', error.message);
    throw error;
  }
}

// Verify seeded data
async function verifySeededData() {
  console.log('🔍 Verifying seeded data...');

  try {
    // Check categories
    const categoriesSnapshot = await admin.firestore().collection('categories').get();
    console.log(`📁 Categories: ${categoriesSnapshot.size}`);

    // Check users
    const usersSnapshot = await admin.firestore().collection('users').get();
    console.log(`👥 Users: ${usersSnapshot.size}`);

    // Check documents
    const documentsSnapshot = await admin.firestore().collection('documents').get();
    console.log(`📄 Documents: ${documentsSnapshot.size}`);

    // Check activities
    const activitiesSnapshot = await admin.firestore().collection('activities').get();
    console.log(`📊 Activities: ${activitiesSnapshot.size}`);

    // Check Firebase Auth users
    const authUsers = await admin.auth().listUsers();
    console.log(`🔐 Auth Users: ${authUsers.users.length}`);

    console.log('✅ Data verification completed');

    // Display admin credentials
    const adminUser = SAMPLE_USERS.find(user => user.role === 'admin');
    console.log('\n🔑 Admin Credentials:');
    console.log(`Email: ${adminUser.email}`);
    console.log(`Password: ${adminUser.password}`);
    console.log('\n📝 Other Test Users:');
    SAMPLE_USERS.filter(user => user.role !== 'admin').forEach(user => {
      console.log(`${user.fullName}: ${user.email} / ${user.password}`);
    });

  } catch (error) {
    console.error('❌ Error verifying data:', error.message);
    throw error;
  }
}

// Main seeding function
async function runFullSeed() {
  console.log('🌱 Starting full database seeding...');

  try {
    await clearExistingData();
    await seedCategories();
    await seedUsers();
    await seedDocuments();
    await seedActivities();
    await verifySeededData();

    console.log('\n🎉 Database seeding completed successfully!');
    console.log('🚀 You can now start using the application with the seeded data.');
  } catch (error) {
    console.error('💥 Seeding failed:', error.message);
    throw error;
  }
}

// Partial seeding functions
async function seedCategoriesOnly() {
  console.log('🌱 Seeding categories only...');
  await seedCategories();
  console.log('✅ Categories seeding completed');
}

async function seedUsersOnly() {
  console.log('🌱 Seeding users only...');
  await seedUsers();
  console.log('✅ Users seeding completed');
}

async function seedDocumentsOnly() {
  console.log('🌱 Seeding documents only...');
  await seedDocuments();
  console.log('✅ Documents seeding completed');
}

// Show menu
async function showMenu() {
  console.log('\n🌱 Database Seeder');
  console.log('==================');
  console.log('1. Full seed (clear all + seed everything)');
  console.log('2. Seed categories only');
  console.log('3. Seed users only');
  console.log('4. Seed documents only');
  console.log('5. Clear all data');
  console.log('6. Verify existing data');
  console.log('7. Show sample credentials');
  console.log('8. Exit');

  const choice = await askQuestion('\nSelect an option (1-8): ');
  return choice;
}

// Show sample credentials
function showCredentials() {
  console.log('\n🔑 Sample User Credentials:');
  console.log('===========================');
  SAMPLE_USERS.forEach(user => {
    console.log(`${user.fullName}:`);
    console.log(`  Email: ${user.email}`);
    console.log(`  Password: ${user.password}`);
    console.log(`  Role: ${user.role}`);
    console.log(`  Permissions: ${JSON.stringify(user.permissions, null, 2)}`);
    console.log('');
  });
}

// Main function
async function main() {
  try {
    console.log('🚀 Document Management System - Database Seeder');
    console.log('================================================');

    initializeFirebase();

    while (true) {
      const choice = await showMenu();

      switch (choice) {
        case '1':
          await runFullSeed();
          break;

        case '2':
          await seedCategoriesOnly();
          break;

        case '3':
          await seedUsersOnly();
          break;

        case '4':
          await seedDocumentsOnly();
          break;

        case '5':
          await clearExistingData();
          console.log('✅ All data cleared');
          break;

        case '6':
          await verifySeededData();
          break;

        case '7':
          showCredentials();
          break;

        case '8':
          console.log('👋 Goodbye!');
          rl.close();
          process.exit(0);
          break;

        default:
          console.log('❌ Invalid option. Please try again.');
      }
    }
  } catch (error) {
    console.error('💥 Fatal error:', error.message);
    rl.close();
    process.exit(1);
  }
}

// Handle process termination
process.on('SIGINT', () => {
  console.log('\n👋 Goodbye!');
  rl.close();
  process.exit(0);
});

// Run the script
if (require.main === module) {
  main();
}

module.exports = {
  runFullSeed,
  seedCategories,
  seedUsers,
  seedDocuments,
  seedActivities,
  clearExistingData,
  verifySeededData
};
