#!/usr/bin/env node

/**
 * Integration Test Suite
 * 
 * Comprehensive testing of the Document Management System
 * with the new database structure and admin-only hard delete operations.
 */

const { initializeFirebase, getEnvironmentInfo, validateConnection } = require('./firebase-config');

// Initialize Firebase with production support
const admin = initializeFirebase({
  scriptName: 'Integration Test',
  requireProduction: false
});

// Test results tracking
let testResults = {
  passed: 0,
  failed: 0,
  total: 0,
  details: []
};

// Test helper function
async function runTest(testName, testFunction) {
  testResults.total++;
  console.log(`\n🧪 Testing: ${testName}`);
  
  try {
    const result = await testFunction();
    if (result) {
      testResults.passed++;
      testResults.details.push({ name: testName, status: 'PASSED', error: null });
      console.log(`✅ ${testName} - PASSED`);
    } else {
      testResults.failed++;
      testResults.details.push({ name: testName, status: 'FAILED', error: 'Test returned false' });
      console.log(`❌ ${testName} - FAILED`);
    }
  } catch (error) {
    testResults.failed++;
    testResults.details.push({ name: testName, status: 'ERROR', error: error.message });
    console.log(`💥 ${testName} - ERROR: ${error.message}`);
  }
}

// Test 1: Admin User Creation
async function testAdminUserCreation() {
  try {
    // Create test admin user
    const testEmail = 'test-admin@integration-test.com';
    const testPassword = 'TestAdmin123!';
    
    // Check if user already exists and delete if so
    try {
      const existingUser = await admin.auth().getUserByEmail(testEmail);
      await admin.auth().deleteUser(existingUser.uid);
      await admin.firestore().collection('users').doc(existingUser.uid).delete();
    } catch (e) {
      // User doesn't exist, which is fine
    }
    
    // Create new admin user
    const userRecord = await admin.auth().createUser({
      email: testEmail,
      password: testPassword,
      displayName: 'Test Admin User',
      disabled: false
    });
    
    // Create Firestore document
    await admin.firestore().collection('users').doc(userRecord.uid).set({
      id: userRecord.uid,
      fullName: 'Test Admin User',
      email: testEmail,
      role: 'admin',
      status: 'active',
      permissions: {
        documents: ['view', 'upload', 'delete', 'approve'],
        categories: [],
        system: ['user_management', 'analytics']
      },
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      lastLogin: null,
      profileImageUrl: null
    });
    
    // Set custom claims
    await admin.auth().setCustomUserClaims(userRecord.uid, { admin: true });
    
    // Verify user was created correctly
    const userDoc = await admin.firestore().collection('users').doc(userRecord.uid).get();
    const userData = userDoc.data();
    
    // Cleanup
    await admin.auth().deleteUser(userRecord.uid);
    await admin.firestore().collection('users').doc(userRecord.uid).delete();
    
    return userData.role === 'admin' && userData.status === 'active' && !('isActive' in userData);
  } catch (error) {
    console.error('Admin user creation test failed:', error.message);
    return false;
  }
}

// Test 2: Regular User Creation
async function testRegularUserCreation() {
  try {
    const testEmail = 'test-user@integration-test.com';
    const testPassword = 'TestUser123!';
    
    // Cleanup existing user if any
    try {
      const existingUser = await admin.auth().getUserByEmail(testEmail);
      await admin.auth().deleteUser(existingUser.uid);
      await admin.firestore().collection('users').doc(existingUser.uid).delete();
    } catch (e) {
      // User doesn't exist
    }
    
    // Create regular user
    const userRecord = await admin.auth().createUser({
      email: testEmail,
      password: testPassword,
      displayName: 'Test Regular User',
      disabled: false
    });
    
    // Create Firestore document
    await admin.firestore().collection('users').doc(userRecord.uid).set({
      id: userRecord.uid,
      fullName: 'Test Regular User',
      email: testEmail,
      role: 'user',
      status: 'active',
      permissions: {
        documents: ['view', 'upload'],
        categories: [],
        system: []
      },
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      lastLogin: null,
      profileImageUrl: null
    });
    
    // Verify user was created correctly
    const userDoc = await admin.firestore().collection('users').doc(userRecord.uid).get();
    const userData = userDoc.data();
    
    // Cleanup
    await admin.auth().deleteUser(userRecord.uid);
    await admin.firestore().collection('users').doc(userRecord.uid).delete();
    
    return userData.role === 'user' && userData.status === 'active' && !('isActive' in userData);
  } catch (error) {
    console.error('Regular user creation test failed:', error.message);
    return false;
  }
}

// Test 3: Hard Delete Operations
async function testHardDeleteOperations() {
  try {
    // Create test user for deletion
    const testEmail = 'test-delete@integration-test.com';
    const userRecord = await admin.auth().createUser({
      email: testEmail,
      password: 'TestDelete123!',
      displayName: 'Test Delete User'
    });
    
    // Create Firestore document
    await admin.firestore().collection('users').doc(userRecord.uid).set({
      id: userRecord.uid,
      fullName: 'Test Delete User',
      email: testEmail,
      role: 'user',
      status: 'active',
      permissions: { documents: ['view'], categories: [], system: [] },
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    });
    
    // Verify user exists
    const beforeDelete = await admin.firestore().collection('users').doc(userRecord.uid).get();
    if (!beforeDelete.exists) {
      return false;
    }
    
    // Perform hard delete
    await admin.auth().deleteUser(userRecord.uid);
    await admin.firestore().collection('users').doc(userRecord.uid).delete();
    
    // Verify user is completely deleted
    try {
      await admin.auth().getUser(userRecord.uid);
      return false; // Should not reach here
    } catch (authError) {
      // Expected - user should not exist in Auth
    }
    
    const afterDelete = await admin.firestore().collection('users').doc(userRecord.uid).get();
    return !afterDelete.exists; // Should not exist in Firestore
  } catch (error) {
    console.error('Hard delete test failed:', error.message);
    return false;
  }
}

// Test 4: Permission Structure Validation
async function testPermissionStructure() {
  try {
    // Get existing users and check their permission structure
    const usersSnapshot = await admin.firestore().collection('users').limit(5).get();

    if (usersSnapshot.empty) {
      console.log('No users found for permission testing');
      return false;
    }

    for (const doc of usersSnapshot.docs) {
      const userData = doc.data();
      console.log(`Checking permissions for user ${doc.id}:`, JSON.stringify(userData.permissions, null, 2));

      // Check required permission fields
      if (!userData.permissions || typeof userData.permissions !== 'object') {
        console.log(`Missing or invalid permissions object for user ${doc.id}`);
        return false;
      }

      const requiredFields = ['documents', 'categories', 'system'];
      for (const field of requiredFields) {
        if (!Array.isArray(userData.permissions[field])) {
          console.log(`Missing or invalid ${field} array for user ${doc.id}`);
          return false;
        }
      }

      // Validate permission values
      const validDocumentPermissions = ['view', 'upload', 'delete', 'approve'];
      const validSystemPermissions = ['user_management', 'analytics'];

      for (const permission of userData.permissions.documents) {
        if (!validDocumentPermissions.includes(permission)) {
          console.log(`Invalid document permission '${permission}' for user ${doc.id}`);
          return false;
        }
      }

      for (const permission of userData.permissions.system) {
        if (!validSystemPermissions.includes(permission)) {
          console.log(`Invalid system permission '${permission}' for user ${doc.id}`);
          return false;
        }
      }
    }

    return true;
  } catch (error) {
    console.error('Permission structure test failed:', error.message);
    return false;
  }
}

// Test 5: Category Structure Validation
async function testCategoryStructure() {
  try {
    const categoriesSnapshot = await admin.firestore().collection('categories').limit(3).get();
    
    if (categoriesSnapshot.empty) {
      console.log('No categories found for testing');
      return false;
    }
    
    for (const doc of categoriesSnapshot.docs) {
      const categoryData = doc.data();
      
      const requiredFields = ['id', 'name', 'description', 'color', 'icon', 'sortOrder'];
      for (const field of requiredFields) {
        if (!(field in categoryData)) {
          return false;
        }
      }
      
      // Validate data types
      if (typeof categoryData.name !== 'string' || categoryData.name.length === 0) {
        return false;
      }
      
      if (typeof categoryData.sortOrder !== 'number') {
        return false;
      }
    }
    
    return true;
  } catch (error) {
    console.error('Category structure test failed:', error.message);
    return false;
  }
}

// Test 6: Document Structure Validation
async function testDocumentStructure() {
  try {
    const documentsSnapshot = await admin.firestore().collection('documents').limit(3).get();
    
    if (documentsSnapshot.empty) {
      console.log('No documents found for testing');
      return true; // This is acceptable
    }
    
    for (const doc of documentsSnapshot.docs) {
      const documentData = doc.data();
      
      const requiredFields = ['id', 'fileName', 'originalName', 'status', 'uploadedBy'];
      for (const field of requiredFields) {
        if (!(field in documentData)) {
          return false;
        }
      }
      
      // Validate status values
      const validStatuses = ['pending', 'approved', 'rejected'];
      if (!validStatuses.includes(documentData.status)) {
        return false;
      }
    }
    
    return true;
  } catch (error) {
    console.error('Document structure test failed:', error.message);
    return false;
  }
}

// Test 7: isActive Field Validation for Users
async function testIsActiveFieldValidation() {
  try {
    // Check that users collection has isActive field (for account management)
    const usersSnapshot = await admin.firestore().collection('users').limit(5).get();

    if (usersSnapshot.empty) {
      console.log('No users found for isActive field testing');
      return false;
    }

    for (const doc of usersSnapshot.docs) {
      const userData = doc.data();

      // Users should have isActive field for account management
      if (!('isActive' in userData)) {
        console.log(`Missing isActive field in users/${doc.id}`);
        return false;
      }

      // isActive should be boolean
      if (typeof userData.isActive !== 'boolean') {
        console.log(`Invalid isActive field type in users/${doc.id}`);
        return false;
      }
    }

    // Check that other collections don't have isActive field (not used for soft delete)
    const otherCollections = ['categories', 'documents'];

    for (const collectionName of otherCollections) {
      const snapshot = await admin.firestore().collection(collectionName).limit(5).get();

      for (const doc of snapshot.docs) {
        const data = doc.data();
        if ('isActive' in data) {
          console.log(`Found unexpected isActive field in ${collectionName}/${doc.id}`);
          return false;
        }
      }
    }

    return true;
  } catch (error) {
    console.error('isActive field validation failed:', error.message);
    return false;
  }
}

// Run all integration tests
async function runIntegrationTests() {
  console.log('🚀 Starting Integration Test Suite');
  console.log('==================================');
  
  // Reset test results
  testResults = { passed: 0, failed: 0, total: 0, details: [] };
  
  // Run all tests
  await runTest('Admin User Creation', testAdminUserCreation);
  await runTest('Regular User Creation', testRegularUserCreation);
  await runTest('Hard Delete Operations', testHardDeleteOperations);
  await runTest('Permission Structure Validation', testPermissionStructure);
  await runTest('Category Structure Validation', testCategoryStructure);
  await runTest('Document Structure Validation', testDocumentStructure);
  await runTest('isActive Field Validation', testIsActiveFieldValidation);
  
  // Print summary
  console.log('\n📊 Integration Test Results');
  console.log('===========================');
  console.log(`✅ Passed: ${testResults.passed}/${testResults.total}`);
  console.log(`❌ Failed: ${testResults.failed}/${testResults.total}`);
  console.log(`📈 Success Rate: ${((testResults.passed / testResults.total) * 100).toFixed(1)}%`);
  
  // Print detailed results
  if (testResults.failed > 0) {
    console.log('\n❌ Failed Tests:');
    testResults.details
      .filter(test => test.status !== 'PASSED')
      .forEach(test => {
        console.log(`   • ${test.name}: ${test.error || 'Test failed'}`);
      });
  }
  
  if (testResults.passed === testResults.total) {
    console.log('\n🎉 All integration tests passed! The system is working correctly.');
  } else {
    console.log('\n⚠️ Some tests failed. Please review the issues above.');
  }
  
  return testResults.passed === testResults.total;
}

// Main function
async function main() {
  try {
    const envInfo = getEnvironmentInfo();
    console.log(`🌍 Environment: ${envInfo.mode}`);

    // Validate connection
    const isConnected = await validateConnection('Integration Test');
    if (!isConnected) {
      console.log('❌ Cannot proceed without valid Firebase connection');
      process.exit(1);
    }

    const success = await runIntegrationTests();
    process.exit(success ? 0 : 1);
  } catch (error) {
    console.error('💥 Integration test suite failed:', error.message);
    process.exit(1);
  }
}

// Run the script
if (require.main === module) {
  main();
}

module.exports = {
  runIntegrationTests,
  testAdminUserCreation,
  testRegularUserCreation,
  testHardDeleteOperations,
  testPermissionStructure,
  testCategoryStructure,
  testDocumentStructure,
  testIsActiveFieldValidation
};
