/**
 * Firebase Test Users Setup Script
 * 
 * This script creates test users for Firebase Test Lab integration testing
 * Run with: node scripts/setup_test_users.js
 * 
 * Prerequisites:
 * 1. Install Firebase Admin SDK: npm install firebase-admin
 * 2. Set up service account key
 * 3. Set FIREBASE_PROJECT_ID environment variable
 */

const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.applicationDefault(),
    projectId: process.env.FIREBASE_PROJECT_ID
  });
}

const auth = admin.auth();
const db = admin.firestore();

// Test user configurations
const TEST_USERS = [
  {
    uid: 'test-admin-uid',
    email: 'admin@test.com',
    password: 'admin123',
    displayName: 'Test Admin',
    role: 'admin',
    permissions: ['read', 'write', 'delete', 'manage_users', 'approve_documents']
  },
  {
    uid: 'test-user-uid',
    email: 'user@test.com',
    password: 'user123',
    displayName: 'Test User',
    role: 'user',
    permissions: ['read', 'write']
  }
];

// Test data configurations
const TEST_CATEGORIES = [
  {
    id: 'test-category-1',
    name: 'Test Category 1',
    description: 'First test category for integration tests',
    createdBy: 'test-admin-uid',
    permissions: ['test-admin-uid', 'test-user-uid']
  },
  {
    id: 'test-category-2',
    name: 'Admin Only Category',
    description: 'Category accessible only by admin',
    createdBy: 'test-admin-uid',
    permissions: ['test-admin-uid']
  }
];

const TEST_DOCUMENTS = [
  {
    id: 'test-doc-1',
    fileName: 'test-document-1.pdf',
    originalName: 'Test Document 1.pdf',
    fileSize: 1024000,
    contentType: 'application/pdf',
    uploadedBy: 'test-user-uid',
    status: 'pending',
    category: 'test-category-1'
  },
  {
    id: 'test-doc-2',
    fileName: 'test-document-2.xlsx',
    originalName: 'Test Spreadsheet.xlsx',
    fileSize: 512000,
    contentType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    uploadedBy: 'test-user-uid',
    status: 'approved',
    category: 'test-category-1',
    approvedBy: 'test-admin-uid'
  }
];

/**
 * Create test users in Firebase Auth
 */
async function createTestUsers() {
  console.log('🔐 Creating test users...');
  
  for (const user of TEST_USERS) {
    try {
      // Check if user already exists
      try {
        await auth.getUser(user.uid);
        console.log(`✅ User ${user.email} already exists`);
        
        // Update custom claims
        await auth.setCustomUserClaims(user.uid, {
          role: user.role,
          permissions: user.permissions
        });
        console.log(`✅ Updated custom claims for ${user.email}`);
        
      } catch (error) {
        if (error.code === 'auth/user-not-found') {
          // Create new user
          await auth.createUser({
            uid: user.uid,
            email: user.email,
            password: user.password,
            displayName: user.displayName,
            emailVerified: true
          });
          
          // Set custom claims
          await auth.setCustomUserClaims(user.uid, {
            role: user.role,
            permissions: user.permissions
          });
          
          console.log(`✅ Created user: ${user.email} with role: ${user.role}`);
        } else {
          throw error;
        }
      }
      
      // Create user profile in Firestore
      await db.collection('users').doc(user.uid).set({
        email: user.email,
        displayName: user.displayName,
        role: user.role,
        permissions: user.permissions,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        isTestUser: true
      }, { merge: true });
      
    } catch (error) {
      console.error(`❌ Error creating user ${user.email}:`, error.message);
    }
  }
}

/**
 * Create test categories in Firestore
 */
async function createTestCategories() {
  console.log('📁 Creating test categories...');
  
  for (const category of TEST_CATEGORIES) {
    try {
      await db.collection('categories').doc(category.id).set({
        name: category.name,
        description: category.description,
        createdBy: category.createdBy,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        permissions: category.permissions,
        isTestData: true
      }, { merge: true });
      
      console.log(`✅ Created category: ${category.name}`);
    } catch (error) {
      console.error(`❌ Error creating category ${category.name}:`, error.message);
    }
  }
}

/**
 * Create test documents in Firestore
 */
async function createTestDocuments() {
  console.log('📄 Creating test documents...');
  
  for (const doc of TEST_DOCUMENTS) {
    try {
      const docData = {
        fileName: doc.fileName,
        originalName: doc.originalName,
        fileSize: doc.fileSize,
        contentType: doc.contentType,
        uploadedBy: doc.uploadedBy,
        uploadedAt: admin.firestore.FieldValue.serverTimestamp(),
        status: doc.status,
        category: doc.category,
        isTestData: true
      };
      
      if (doc.approvedBy) {
        docData.approvedBy = doc.approvedBy;
        docData.approvedAt = admin.firestore.FieldValue.serverTimestamp();
      }
      
      await db.collection('document-metadata').doc(doc.id).set(docData, { merge: true });
      
      console.log(`✅ Created document: ${doc.originalName}`);
    } catch (error) {
      console.error(`❌ Error creating document ${doc.originalName}:`, error.message);
    }
  }
}

/**
 * Create test activities for testing activity logs
 */
async function createTestActivities() {
  console.log('📊 Creating test activities...');
  
  const activities = [
    {
      userId: 'test-user-uid',
      action: 'upload',
      documentId: 'test-doc-1',
      details: 'Uploaded test document 1',
      timestamp: admin.firestore.FieldValue.serverTimestamp()
    },
    {
      userId: 'test-admin-uid',
      action: 'approve',
      documentId: 'test-doc-2',
      details: 'Approved test document 2',
      timestamp: admin.firestore.FieldValue.serverTimestamp()
    }
  ];
  
  for (const activity of activities) {
    try {
      await db.collection('activities').add({
        ...activity,
        isTestData: true
      });
      
      console.log(`✅ Created activity: ${activity.action} by ${activity.userId}`);
    } catch (error) {
      console.error(`❌ Error creating activity:`, error.message);
    }
  }
}

/**
 * Clean up test data
 */
async function cleanupTestData() {
  console.log('🧹 Cleaning up existing test data...');
  
  try {
    // Delete test users
    for (const user of TEST_USERS) {
      try {
        await auth.deleteUser(user.uid);
        console.log(`🗑️ Deleted user: ${user.email}`);
      } catch (error) {
        if (error.code !== 'auth/user-not-found') {
          console.error(`❌ Error deleting user ${user.email}:`, error.message);
        }
      }
    }
    
    // Delete test documents from Firestore
    const collections = ['users', 'categories', 'document-metadata', 'activities'];
    
    for (const collectionName of collections) {
      const snapshot = await db.collection(collectionName).where('isTestData', '==', true).get();
      
      const batch = db.batch();
      snapshot.docs.forEach(doc => {
        batch.delete(doc.ref);
      });
      
      if (!snapshot.empty) {
        await batch.commit();
        console.log(`🗑️ Deleted ${snapshot.size} test documents from ${collectionName}`);
      }
    }
    
  } catch (error) {
    console.error('❌ Error during cleanup:', error.message);
  }
}

/**
 * Main setup function
 */
async function setupTestEnvironment() {
  try {
    console.log('🚀 Setting up Firebase Test Lab environment...');
    console.log(`📋 Project ID: ${process.env.FIREBASE_PROJECT_ID || 'Not set'}`);
    
    if (!process.env.FIREBASE_PROJECT_ID) {
      console.error('❌ FIREBASE_PROJECT_ID environment variable is not set');
      process.exit(1);
    }
    
    // Create test users and data
    await createTestUsers();
    await createTestCategories();
    await createTestDocuments();
    await createTestActivities();
    
    console.log('✅ Test environment setup completed!');
    console.log('\n📋 Test Users Created:');
    console.log('   Admin: admin@test.com / admin123');
    console.log('   User:  user@test.com / user123');
    console.log('\n🧪 Ready for Firebase Test Lab integration testing!');
    
  } catch (error) {
    console.error('❌ Setup failed:', error.message);
    process.exit(1);
  }
}

/**
 * Command line interface
 */
const command = process.argv[2];

switch (command) {
  case 'setup':
    setupTestEnvironment();
    break;
  case 'cleanup':
    cleanupTestData();
    break;
  case 'users':
    createTestUsers();
    break;
  case 'data':
    createTestCategories()
      .then(() => createTestDocuments())
      .then(() => createTestActivities());
    break;
  default:
    console.log('Usage: node scripts/setup_test_users.js [command]');
    console.log('Commands:');
    console.log('  setup   - Create all test users and data');
    console.log('  cleanup - Remove all test data');
    console.log('  users   - Create only test users');
    console.log('  data    - Create only test data');
    break;
}
