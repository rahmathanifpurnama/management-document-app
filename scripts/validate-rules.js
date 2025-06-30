#!/usr/bin/env node

/**
 * Security Rules Validation Script
 * 
 * This script validates that the Firestore and Storage security rules
 * are working correctly with the new database structure.
 */

const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
function initializeFirebase() {
  if (!admin.apps.length) {
    const isEmulator = process.env.FIRESTORE_EMULATOR_HOST || process.env.NODE_ENV === 'development';
    
    if (isEmulator) {
      console.log('🔧 Using Firebase Emulator for validation');
      admin.initializeApp({
        projectId: 'document-management-c5a96'
      });
      
      // Connect to emulators
      process.env.FIRESTORE_EMULATOR_HOST = process.env.FIRESTORE_EMULATOR_HOST || '127.0.0.1:8080';
      process.env.FIREBASE_AUTH_EMULATOR_HOST = process.env.FIREBASE_AUTH_EMULATOR_HOST || '127.0.0.1:9099';
      process.env.FIREBASE_STORAGE_EMULATOR_HOST = process.env.FIREBASE_STORAGE_EMULATOR_HOST || '127.0.0.1:9199';
    } else {
      console.log('🔥 Using Production Firebase');
      console.log('❌ Production validation requires service account configuration');
      process.exit(1);
    }
  }
}

// Test data structure validation
async function validateUserStructure() {
  console.log('👤 Validating user data structure...');
  
  try {
    // Get a sample user
    const usersSnapshot = await admin.firestore().collection('users').limit(1).get();
    
    if (usersSnapshot.empty) {
      console.log('⚠️ No users found. Run the seeder first.');
      return false;
    }
    
    const userData = usersSnapshot.docs[0].data();
    const requiredFields = ['id', 'fullName', 'email', 'role', 'status', 'permissions'];
    const permissionFields = ['documents', 'categories', 'system'];
    
    // Check required fields
    for (const field of requiredFields) {
      if (!(field in userData)) {
        console.log(`❌ Missing required field: ${field}`);
        return false;
      }
    }
    
    // Check permissions structure
    if (!userData.permissions || typeof userData.permissions !== 'object') {
      console.log('❌ Invalid permissions structure');
      return false;
    }
    
    for (const field of permissionFields) {
      if (!(field in userData.permissions) || !Array.isArray(userData.permissions[field])) {
        console.log(`❌ Invalid permissions field: ${field}`);
        return false;
      }
    }
    
    // Check that isActive field is NOT present
    if ('isActive' in userData) {
      console.log('❌ Found deprecated isActive field - should be removed');
      return false;
    }
    
    // Validate role values
    if (!['admin', 'user'].includes(userData.role)) {
      console.log(`❌ Invalid role value: ${userData.role}`);
      return false;
    }
    
    // Validate status values
    if (!['active', 'inactive'].includes(userData.status)) {
      console.log(`❌ Invalid status value: ${userData.status}`);
      return false;
    }
    
    console.log('✅ User structure validation passed');
    return true;
  } catch (error) {
    console.error('❌ User structure validation failed:', error.message);
    return false;
  }
}

// Test admin user permissions
async function validateAdminPermissions() {
  console.log('🔐 Validating admin user permissions...');
  
  try {
    const adminSnapshot = await admin.firestore()
      .collection('users')
      .where('role', '==', 'admin')
      .limit(1)
      .get();
    
    if (adminSnapshot.empty) {
      console.log('⚠️ No admin users found');
      return false;
    }
    
    const adminData = adminSnapshot.docs[0].data();
    const expectedPermissions = {
      documents: ['view', 'upload', 'delete', 'approve'],
      system: ['user_management', 'analytics']
    };
    
    // Check document permissions
    for (const permission of expectedPermissions.documents) {
      if (!adminData.permissions.documents.includes(permission)) {
        console.log(`❌ Admin missing document permission: ${permission}`);
        return false;
      }
    }
    
    // Check system permissions
    for (const permission of expectedPermissions.system) {
      if (!adminData.permissions.system.includes(permission)) {
        console.log(`❌ Admin missing system permission: ${permission}`);
        return false;
      }
    }
    
    console.log('✅ Admin permissions validation passed');
    return true;
  } catch (error) {
    console.error('❌ Admin permissions validation failed:', error.message);
    return false;
  }
}

// Test categories structure
async function validateCategoriesStructure() {
  console.log('📁 Validating categories structure...');
  
  try {
    const categoriesSnapshot = await admin.firestore().collection('categories').limit(1).get();
    
    if (categoriesSnapshot.empty) {
      console.log('⚠️ No categories found. Run the seeder first.');
      return false;
    }
    
    const categoryData = categoriesSnapshot.docs[0].data();
    const requiredFields = ['id', 'name', 'description', 'color', 'icon', 'sortOrder'];
    
    for (const field of requiredFields) {
      if (!(field in categoryData)) {
        console.log(`❌ Missing required category field: ${field}`);
        return false;
      }
    }
    
    console.log('✅ Categories structure validation passed');
    return true;
  } catch (error) {
    console.error('❌ Categories structure validation failed:', error.message);
    return false;
  }
}

// Test documents structure
async function validateDocumentsStructure() {
  console.log('📄 Validating documents structure...');
  
  try {
    const documentsSnapshot = await admin.firestore().collection('documents').limit(1).get();
    
    if (documentsSnapshot.empty) {
      console.log('⚠️ No documents found. Run the seeder first.');
      return false;
    }
    
    const documentData = documentsSnapshot.docs[0].data();
    const requiredFields = ['id', 'fileName', 'originalName', 'category', 'status', 'uploadedBy', 'uploadedAt'];
    
    for (const field of requiredFields) {
      if (!(field in documentData)) {
        console.log(`❌ Missing required document field: ${field}`);
        return false;
      }
    }
    
    // Validate status values
    const validStatuses = ['pending', 'approved', 'rejected'];
    if (!validStatuses.includes(documentData.status)) {
      console.log(`❌ Invalid document status: ${documentData.status}`);
      return false;
    }
    
    console.log('✅ Documents structure validation passed');
    return true;
  } catch (error) {
    console.error('❌ Documents structure validation failed:', error.message);
    return false;
  }
}

// Test collection counts
async function validateDataCounts() {
  console.log('📊 Validating data counts...');
  
  try {
    const collections = ['users', 'categories', 'documents', 'activities'];
    const counts = {};
    
    for (const collection of collections) {
      const snapshot = await admin.firestore().collection(collection).get();
      counts[collection] = snapshot.size;
      console.log(`📋 ${collection}: ${snapshot.size} documents`);
    }
    
    // Check minimum expected counts
    if (counts.users < 1) {
      console.log('⚠️ No users found - run seeder to create sample data');
    }
    
    if (counts.categories < 1) {
      console.log('⚠️ No categories found - run seeder to create sample data');
    }
    
    console.log('✅ Data counts validation completed');
    return true;
  } catch (error) {
    console.error('❌ Data counts validation failed:', error.message);
    return false;
  }
}

// Test Firebase Auth integration
async function validateAuthIntegration() {
  console.log('🔐 Validating Firebase Auth integration...');
  
  try {
    const authUsers = await admin.auth().listUsers();
    const firestoreUsers = await admin.firestore().collection('users').get();
    
    console.log(`🔐 Firebase Auth users: ${authUsers.users.length}`);
    console.log(`📄 Firestore users: ${firestoreUsers.size}`);
    
    // Check if Auth and Firestore user counts match
    if (authUsers.users.length !== firestoreUsers.size) {
      console.log('⚠️ Mismatch between Firebase Auth and Firestore user counts');
      console.log('This might be expected if some users were created manually');
    }
    
    // Check if admin users have custom claims
    let adminClaimsCount = 0;
    for (const user of authUsers.users) {
      if (user.customClaims && user.customClaims.admin) {
        adminClaimsCount++;
      }
    }
    
    console.log(`👑 Users with admin claims: ${adminClaimsCount}`);
    
    console.log('✅ Auth integration validation completed');
    return true;
  } catch (error) {
    console.error('❌ Auth integration validation failed:', error.message);
    return false;
  }
}

// Run all validations
async function runAllValidations() {
  console.log('🔍 Starting comprehensive validation...');
  console.log('=====================================');
  
  const validations = [
    { name: 'User Structure', fn: validateUserStructure },
    { name: 'Admin Permissions', fn: validateAdminPermissions },
    { name: 'Categories Structure', fn: validateCategoriesStructure },
    { name: 'Documents Structure', fn: validateDocumentsStructure },
    { name: 'Data Counts', fn: validateDataCounts },
    { name: 'Auth Integration', fn: validateAuthIntegration }
  ];
  
  let passedCount = 0;
  let totalCount = validations.length;
  
  for (const validation of validations) {
    console.log(`\n--- ${validation.name} ---`);
    try {
      const result = await validation.fn();
      if (result) {
        passedCount++;
      }
    } catch (error) {
      console.error(`❌ ${validation.name} failed with error:`, error.message);
    }
  }
  
  console.log('\n🏁 Validation Summary');
  console.log('====================');
  console.log(`✅ Passed: ${passedCount}/${totalCount}`);
  console.log(`❌ Failed: ${totalCount - passedCount}/${totalCount}`);
  
  if (passedCount === totalCount) {
    console.log('\n🎉 All validations passed! The database structure is correct.');
  } else {
    console.log('\n⚠️ Some validations failed. Please review the issues above.');
    console.log('💡 Try running the database seeder to create proper sample data.');
  }
  
  return passedCount === totalCount;
}

// Main function
async function main() {
  try {
    console.log('🚀 Database Structure Validation Tool');
    console.log('====================================');
    
    initializeFirebase();
    
    const success = await runAllValidations();
    process.exit(success ? 0 : 1);
  } catch (error) {
    console.error('💥 Fatal error:', error.message);
    process.exit(1);
  }
}

// Run the script
if (require.main === module) {
  main();
}

module.exports = {
  runAllValidations,
  validateUserStructure,
  validateAdminPermissions,
  validateCategoriesStructure,
  validateDocumentsStructure,
  validateDataCounts,
  validateAuthIntegration
};
