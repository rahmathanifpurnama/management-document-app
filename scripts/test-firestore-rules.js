const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
if (!admin.apps.length) {
  try {
    const serviceAccount = require('./config/service-account-key.json');
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
      projectId: 'document-management-c5a96'
    });
    console.log('✅ Initialized with service account key');
  } catch (error) {
    admin.initializeApp({
      credential: admin.credential.applicationDefault(),
      projectId: 'document-management-c5a96'
    });
    console.log('✅ Initialized with application default credentials');
  }
}

const db = admin.firestore();

async function testFirestoreRules() {
  try {
    console.log('🔍 === TESTING FIRESTORE RULES ===\n');

    // Test admin user (yang sedang login)
    const adminUserId = 'PFnoTjoDdtcG9qJBsizIhz3n5Uf2'; // web.hanif61@gmail.com
    
    console.log(`🧪 Testing document creation for admin: ${adminUserId}`);

    // Simulate the exact data that UnifiedIdSystem sends
    const testDocumentId = 'test_document_' + Date.now();
    const testDocumentData = {
      id: testDocumentId,
      fileName: 'test_file.jpg',
      filePath: `documents/${adminUserId}/test_file.jpg`,
      uploadedBy: adminUserId,
      category: '',
      fileSize: 1024000,
      fileType: 'Image',
      uploadedAt: admin.firestore.FieldValue.serverTimestamp(),
      isActive: true,
      permissions: [adminUserId],
      metadata: {
        description: '',
        tags: [],
        version: '1.0',
        contentType: 'image/jpeg',
        downloadUrl: 'https://example.com/test.jpg',
        fileHash: 'test_hash_123',
        createdBy: 'flutter_upload_service',
        uploadMethod: 'local_fallback',
      },
    };

    console.log('📋 Document data to be created:');
    console.log(JSON.stringify(testDocumentData, null, 2));

    // Check Firestore Rules requirements
    console.log('\n🔍 Checking Firestore Rules requirements:');
    
    // 1. Check required fields
    const requiredFields = ['id', 'fileName', 'uploadedAt'];
    const hasAllRequired = requiredFields.every(field => field in testDocumentData);
    console.log(`✅ Has required fields [${requiredFields.join(', ')}]: ${hasAllRequired}`);

    // 2. Check uploadedBy matches user
    const uploadedByMatches = testDocumentData.uploadedBy === adminUserId;
    console.log(`✅ uploadedBy matches user: ${uploadedByMatches}`);

    // 3. Check ID consistency
    const idConsistent = testDocumentData.id === testDocumentId;
    console.log(`✅ ID consistency: ${idConsistent}`);

    // 4. Check fileName validation
    const fileNameValid = typeof testDocumentData.fileName === 'string' && 
                         testDocumentData.fileName.length > 0 && 
                         testDocumentData.fileName.length <= 255;
    console.log(`✅ fileName valid: ${fileNameValid}`);

    // 5. Check status field (if exists)
    if ('status' in testDocumentData) {
      const validStatuses = ['active', 'pending', 'approved', 'rejected'];
      const statusValid = validStatuses.includes(testDocumentData.status);
      console.log(`✅ status valid: ${statusValid}`);
    } else {
      console.log(`⚠️ status field not present (may be required)`);
    }

    // Try to create the document
    console.log('\n🧪 Attempting to create test document...');
    
    try {
      await db.collection('documents').doc(testDocumentId).set(testDocumentData);
      console.log('✅ SUCCESS: Document created successfully!');
      
      // Clean up - delete the test document
      await db.collection('documents').doc(testDocumentId).delete();
      console.log('🗑️ Test document cleaned up');
      
    } catch (createError) {
      console.log('❌ FAILED: Document creation failed');
      console.log(`Error: ${createError.message}`);
      console.log(`Error code: ${createError.code}`);
      
      // Analyze the error
      if (createError.code === 'permission-denied') {
        console.log('\n🔍 PERMISSION DENIED ANALYSIS:');
        console.log('Possible causes:');
        console.log('1. User not authenticated properly');
        console.log('2. User does not have upload permission');
        console.log('3. User status is not active');
        console.log('4. Missing required fields in document data');
        console.log('5. Field validation failed (e.g., fileName too long)');
        console.log('6. Status field missing or invalid');
      }
    }

    // Test with status field added
    console.log('\n🧪 Testing with status field added...');
    const testDocumentDataWithStatus = {
      ...testDocumentData,
      status: 'active'
    };

    const testDocumentId2 = 'test_document_with_status_' + Date.now();
    testDocumentDataWithStatus.id = testDocumentId2;

    try {
      await db.collection('documents').doc(testDocumentId2).set(testDocumentDataWithStatus);
      console.log('✅ SUCCESS: Document with status created successfully!');
      
      // Clean up
      await db.collection('documents').doc(testDocumentId2).delete();
      console.log('🗑️ Test document with status cleaned up');
      
    } catch (createError) {
      console.log('❌ FAILED: Document with status creation failed');
      console.log(`Error: ${createError.message}`);
    }

    // Check user permissions one more time
    console.log('\n🔍 Double-checking user permissions...');
    const userDoc = await db.collection('users').doc(adminUserId).get();
    if (userDoc.exists) {
      const userData = userDoc.data();
      console.log(`User role: ${userData.role}`);
      console.log(`User status: ${userData.status}`);
      console.log(`User permissions:`, userData.permissions);
      
      const isAdmin = userData.role === 'admin';
      const isActive = userData.status === 'active';
      const hasUploadPermission = userData.permissions?.documents?.includes('upload');
      
      console.log(`Is admin: ${isAdmin}`);
      console.log(`Is active: ${isActive}`);
      console.log(`Has upload permission: ${hasUploadPermission}`);
      
      if (isAdmin && isActive) {
        console.log('✅ User should have full access to create documents');
      } else {
        console.log('❌ User may not have sufficient permissions');
      }
    }

  } catch (error) {
    console.error('❌ Error testing Firestore rules:', error);
  }
}

// Run the test
testFirestoreRules()
  .then(() => {
    console.log('\n🎉 Firestore rules test completed!');
    process.exit(0);
  })
  .catch((error) => {
    console.error('❌ Script failed:', error);
    process.exit(1);
  });
