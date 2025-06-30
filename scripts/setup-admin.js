#!/usr/bin/env node

/**
 * Admin Setup Utility
 * 
 * This script helps set up admin users for the Document Management System.
 * It provides instructions and utilities for creating admin users.
 */

const { initializeFirebase, getEnvironmentInfo, validateConnection, admin: getAdmin } = require('./firebase-config');
const readline = require('readline');

// Initialize Firebase with production support
const admin = initializeFirebase({
  scriptName: 'Admin Setup',
  requireProduction: false
});

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

// Admin user permissions
const adminPermissions = {
  documents: ['view', 'upload', 'delete', 'approve'],
  categories: [],
  system: ['user_management', 'analytics']
};

// Create admin user in Firebase Auth
async function createAdminInAuth(email, password, fullName) {
  try {
    console.log('👤 Creating user in Firebase Authentication...');
    
    const userRecord = await admin.auth().createUser({
      email: email,
      password: password,
      displayName: fullName,
      disabled: false
    });
    
    console.log('✅ User created in Firebase Auth:', userRecord.uid);
    return userRecord;
  } catch (error) {
    console.error('❌ Error creating user in Firebase Auth:', error.message);
    throw error;
  }
}

// Create admin user document in Firestore
async function createAdminInFirestore(userRecord, fullName) {
  try {
    console.log('📄 Creating user document in Firestore...');
    
    const userData = {
      id: userRecord.uid,
      fullName: fullName,
      email: userRecord.email,
      role: 'admin',
      status: 'active',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      permissions: adminPermissions,
      lastLogin: null,
      profileImageUrl: null
    };
    
    await admin.firestore()
      .collection('users')
      .doc(userRecord.uid)
      .set(userData);
    
    console.log('✅ User document created in Firestore');
    
    // Set custom claims
    await admin.auth().setCustomUserClaims(userRecord.uid, { admin: true });
    console.log('✅ Admin custom claims set');
    
    return userData;
  } catch (error) {
    console.error('❌ Error creating user document in Firestore:', error.message);
    throw error;
  }
}

// Setup admin user from existing Firebase Auth user
async function setupExistingUser(email) {
  try {
    console.log('🔍 Looking up existing user...');
    
    const userRecord = await admin.auth().getUserByEmail(email);
    console.log('✅ Found existing user:', userRecord.uid);
    
    // Check if user document already exists
    const userDoc = await admin.firestore()
      .collection('users')
      .doc(userRecord.uid)
      .get();
    
    if (userDoc.exists) {
      const userData = userDoc.data();
      if (userData.role === 'admin') {
        console.log('ℹ️  User is already an admin');
        return userData;
      }
    }
    
    // Create/update user document
    const userData = {
      id: userRecord.uid,
      fullName: userRecord.displayName || userRecord.email.split('@')[0],
      email: userRecord.email,
      role: 'admin',
      status: 'active',
      createdAt: userDoc.exists ? userDoc.data().createdAt : admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      permissions: adminPermissions,
      lastLogin: userDoc.exists ? userDoc.data().lastLogin : null,
      profileImageUrl: userDoc.exists ? userDoc.data().profileImageUrl : null
    };
    
    await admin.firestore()
      .collection('users')
      .doc(userRecord.uid)
      .set(userData, { merge: true });
    
    // Set custom claims
    await admin.auth().setCustomUserClaims(userRecord.uid, { admin: true });
    
    console.log('✅ User upgraded to admin');
    return userData;
  } catch (error) {
    console.error('❌ Error setting up existing user:', error.message);
    throw error;
  }
}

// List existing admin users
async function listAdminUsers() {
  try {
    console.log('📋 Listing existing admin users...');
    
    const snapshot = await admin.firestore()
      .collection('users')
      .where('role', '==', 'admin')
      .get();
    
    if (snapshot.empty) {
      console.log('ℹ️  No admin users found');
      return [];
    }
    
    const adminUsers = [];
    snapshot.forEach(doc => {
      const userData = doc.data();
      adminUsers.push(userData);
      console.log(`👤 ${userData.fullName} (${userData.email}) - Status: ${userData.status}`);
    });
    
    return adminUsers;
  } catch (error) {
    console.error('❌ Error listing admin users:', error.message);
    throw error;
  }
}

// Main menu
async function showMenu() {
  console.log('\n🔧 Admin Setup Utility');
  console.log('======================');
  console.log('1. Create new admin user');
  console.log('2. Upgrade existing user to admin');
  console.log('3. List existing admin users');
  console.log('4. Show manual setup instructions');
  console.log('5. Exit');
  
  const choice = await askQuestion('\nSelect an option (1-5): ');
  return choice;
}

// Show manual setup instructions
function showInstructions() {
  console.log('\n📖 Manual Admin Setup Instructions');
  console.log('===================================');
  console.log('1. Go to Firebase Console > Authentication > Users');
  console.log('2. Click "Add user" and create admin user');
  console.log('3. Note the User UID');
  console.log('4. Use option 2 in this script to upgrade the user to admin');
  console.log('5. Or manually create Firestore document in users collection');
  console.log('\nFor detailed instructions, see: docs/ADMIN_SETUP_GUIDE.md');
}

// Main function
async function main() {
  try {
    console.log('🚀 Document Management System - Admin Setup');
    console.log('============================================');

    const envInfo = getEnvironmentInfo();
    console.log(`🌍 Environment: ${envInfo.mode}`);

    // Validate connection
    const isConnected = await validateConnection('Admin Setup');
    if (!isConnected) {
      console.log('❌ Cannot proceed without valid Firebase connection');
      rl.close();
      process.exit(1);
    }
    
    while (true) {
      const choice = await showMenu();
      
      switch (choice) {
        case '1':
          const email = await askQuestion('Enter admin email: ');
          const password = await askQuestion('Enter admin password: ');
          const fullName = await askQuestion('Enter admin full name: ');
          
          const userRecord = await createAdminInAuth(email, password, fullName);
          await createAdminInFirestore(userRecord, fullName);
          console.log('🎉 Admin user created successfully!');
          break;
          
        case '2':
          const existingEmail = await askQuestion('Enter existing user email: ');
          await setupExistingUser(existingEmail);
          console.log('🎉 User upgraded to admin successfully!');
          break;
          
        case '3':
          await listAdminUsers();
          break;
          
        case '4':
          showInstructions();
          break;
          
        case '5':
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
  createAdminInAuth,
  createAdminInFirestore,
  setupExistingUser,
  listAdminUsers
};
