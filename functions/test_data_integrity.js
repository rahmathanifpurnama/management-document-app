const admin = require('firebase-admin');

// Initialize Firebase Admin (using default credentials)
if (!admin.apps.length) {
  admin.initializeApp({
    projectId: 'document-management-c5a96',
    storageBucket: 'document-management-c5a96.appspot.com'
  });
}

async function testDataIntegrity() {
  try {
    console.log('🔍 Testing Data Integrity Check...');
    console.log('=' .repeat(50));

    // Call the checkDataIntegrity function directly
    const bucket = admin.storage().bucket();

    // Get all active documents from Firestore
    const firestoreSnapshot = await admin
      .firestore()
      .collection("document-metadata")
      .where("isActive", "==", true)
      .get();

    console.log(`📊 Found ${firestoreSnapshot.docs.length} active documents in Firestore`);

    // Get all files from Storage
    const [storageFiles] = await bucket.getFiles();
    console.log(`📁 Found ${storageFiles.length} files in Storage`);

    const issues = [];
    let orphanedDocuments = 0;
    let missingDocuments = 0;

    // Check for orphaned Firestore documents (no corresponding Storage file)
    for (const doc of firestoreSnapshot.docs) {
      const docData = doc.data();
      const filePath = docData.filePath;

      if (filePath) {
        const file = bucket.file(filePath);
        const [exists] = await file.exists();

        if (!exists) {
          orphanedDocuments++;
          issues.push({
            type: "orphaned_document",
            documentId: doc.id,
            fileName: docData.fileName,
            filePath: filePath,
            issue: "Firestore document exists but Storage file is missing"
          });
        }
      }
    }

    // Check for missing Firestore documents (Storage files without metadata)
    for (const file of storageFiles) {
      const fileName = file.name.split("/").pop() || "unknown";
      const documentId = fileName.split(".")[0] || fileName;

      const docExists = firestoreSnapshot.docs.some(doc => doc.id === documentId);

      if (!docExists) {
        missingDocuments++;
        issues.push({
          type: "missing_document",
          fileName: fileName,
          filePath: file.name,
          issue: "Storage file exists but no Firestore document found"
        });
      }
    }

    const summary = {
      firestoreDocuments: firestoreSnapshot.docs.length,
      storageFiles: storageFiles.length,
      orphanedDocuments,
      missingDocuments,
      totalIssues: issues.length,
      isHealthy: issues.length === 0
    };

    console.log('📊 Data Integrity Results:');
    console.log('=' .repeat(50));
    
    // Display summary
    console.log('\n📋 SUMMARY:');
    console.log(`   Firestore Documents: ${summary.firestoreDocuments}`);
    console.log(`   Storage Files: ${summary.storageFiles}`);
    console.log(`   Orphaned Documents: ${summary.orphanedDocuments}`);
    console.log(`   Missing Documents: ${summary.missingDocuments}`);
    console.log(`   Total Issues: ${summary.totalIssues}`);
    console.log(`   System Health: ${summary.isHealthy ? '✅ HEALTHY' : '❌ ISSUES FOUND'}`);
    
    // Display issues if any
    if (issues && issues.length > 0) {
      console.log('\n⚠️  ISSUES FOUND:');
      console.log('=' .repeat(50));
      
      issues.forEach((issue, index) => {
        console.log(`\n${index + 1}. ${issue.type.toUpperCase()}`);
        console.log(`   Document ID: ${issue.documentId || 'N/A'}`);
        console.log(`   File Name: ${issue.fileName}`);
        console.log(`   File Path: ${issue.filePath}`);
        console.log(`   Issue: ${issue.issue}`);
      });
      
      // Recommendations
      console.log('\n💡 RECOMMENDATIONS:');
      console.log('=' .repeat(50));
      
      if (summary.orphanedDocuments > 0) {
        console.log('• Run cleanupOrphanedMetadata function to remove orphaned Firestore documents');
      }
      
      if (summary.missingDocuments > 0) {
        console.log('• Run syncStorageToFirestore function to create missing Firestore documents');
      }
      
      console.log('• Consider running performComprehensiveSync for complete data synchronization');
    } else {
      console.log('\n🎉 No data integrity issues found!');
    }
    
    // Count discrepancy analysis
    const countDifference = Math.abs(summary.firestoreDocuments - summary.storageFiles);
    if (countDifference > 0) {
      console.log('\n📊 COUNT DISCREPANCY ANALYSIS:');
      console.log('=' .repeat(50));
      console.log(`   Difference: ${countDifference} files`);
      
      if (summary.firestoreDocuments > summary.storageFiles) {
        console.log('   Issue: More Firestore documents than Storage files');
        console.log('   Likely cause: Orphaned Firestore documents');
        console.log('   Solution: Run cleanup operations');
      } else {
        console.log('   Issue: More Storage files than Firestore documents');
        console.log('   Likely cause: Missing Firestore metadata');
        console.log('   Solution: Run sync operations');
      }
    }
    
  } catch (error) {
    console.error('❌ Error testing data integrity:', error);
    
    if (error.code === 'functions/unauthenticated') {
      console.log('\n💡 TIP: Make sure you are authenticated with Firebase CLI');
      console.log('   Run: firebase login');
    }
  }
}

// Run the test
testDataIntegrity();
