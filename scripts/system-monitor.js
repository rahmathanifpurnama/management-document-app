#!/usr/bin/env node

/**
 * System Monitor and Maintenance Script
 * 
 * Monitors the Document Management System health and performs maintenance tasks.
 */

const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
function initializeFirebase() {
  if (!admin.apps.length) {
    const isEmulator = process.env.FIRESTORE_EMULATOR_HOST || process.env.NODE_ENV === 'development';
    
    if (isEmulator) {
      console.log('🔧 Using Firebase Emulator for monitoring');
      admin.initializeApp({
        projectId: 'document-management-c5a96'
      });
      
      // Connect to emulators
      process.env.FIRESTORE_EMULATOR_HOST = process.env.FIRESTORE_EMULATOR_HOST || '127.0.0.1:8080';
      process.env.FIREBASE_AUTH_EMULATOR_HOST = process.env.FIREBASE_AUTH_EMULATOR_HOST || '127.0.0.1:9099';
      process.env.FIREBASE_STORAGE_EMULATOR_HOST = process.env.FIREBASE_STORAGE_EMULATOR_HOST || '127.0.0.1:9199';
    } else {
      console.log('🔥 Using Production Firebase');
      console.log('❌ Production monitoring requires service account configuration');
      process.exit(1);
    }
  }
}

// System health check
async function checkSystemHealth() {
  console.log('🏥 Checking system health...');
  
  const health = {
    timestamp: new Date().toISOString(),
    status: 'healthy',
    issues: [],
    metrics: {}
  };
  
  try {
    // Check Firestore connectivity
    await admin.firestore().collection('_health_check').doc('test').set({
      timestamp: admin.firestore.FieldValue.serverTimestamp()
    });
    health.metrics.firestoreConnectivity = 'OK';
  } catch (error) {
    health.status = 'unhealthy';
    health.issues.push('Firestore connectivity failed');
    health.metrics.firestoreConnectivity = 'FAILED';
  }
  
  try {
    // Check Auth connectivity
    await admin.auth().listUsers(1);
    health.metrics.authConnectivity = 'OK';
  } catch (error) {
    health.status = 'unhealthy';
    health.issues.push('Firebase Auth connectivity failed');
    health.metrics.authConnectivity = 'FAILED';
  }
  
  // Check collection counts
  const collections = ['users', 'categories', 'documents', 'activities'];
  for (const collection of collections) {
    try {
      const snapshot = await admin.firestore().collection(collection).get();
      health.metrics[`${collection}Count`] = snapshot.size;
    } catch (error) {
      health.issues.push(`Failed to count ${collection}`);
    }
  }
  
  // Check for admin users
  try {
    const adminSnapshot = await admin.firestore()
      .collection('users')
      .where('role', '==', 'admin')
      .get();
    
    health.metrics.adminUserCount = adminSnapshot.size;
    
    if (adminSnapshot.size === 0) {
      health.status = 'warning';
      health.issues.push('No admin users found');
    }
  } catch (error) {
    health.issues.push('Failed to check admin users');
  }
  
  // Check for inactive users
  try {
    const inactiveSnapshot = await admin.firestore()
      .collection('users')
      .where('status', '==', 'inactive')
      .get();
    
    health.metrics.inactiveUserCount = inactiveSnapshot.size;
  } catch (error) {
    health.issues.push('Failed to check inactive users');
  }
  
  return health;
}

// Clean up old activities
async function cleanupOldActivities(daysOld = 30) {
  console.log(`🧹 Cleaning up activities older than ${daysOld} days...`);
  
  try {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - daysOld);
    
    const oldActivities = await admin.firestore()
      .collection('activities')
      .where('timestamp', '<', cutoffDate)
      .get();
    
    if (oldActivities.empty) {
      console.log('✅ No old activities to clean up');
      return 0;
    }
    
    const batch = admin.firestore().batch();
    oldActivities.docs.forEach(doc => {
      batch.delete(doc.ref);
    });
    
    await batch.commit();
    console.log(`✅ Cleaned up ${oldActivities.size} old activities`);
    return oldActivities.size;
  } catch (error) {
    console.error('❌ Failed to cleanup old activities:', error.message);
    return -1;
  }
}

// Audit user permissions
async function auditUserPermissions() {
  console.log('🔍 Auditing user permissions...');
  
  const audit = {
    totalUsers: 0,
    adminUsers: 0,
    regularUsers: 0,
    inactiveUsers: 0,
    usersWithIssues: [],
    permissionDistribution: {}
  };
  
  try {
    const usersSnapshot = await admin.firestore().collection('users').get();
    audit.totalUsers = usersSnapshot.size;
    
    for (const doc of usersSnapshot.docs) {
      const userData = doc.data();
      
      // Count by role
      if (userData.role === 'admin') {
        audit.adminUsers++;
      } else {
        audit.regularUsers++;
      }
      
      // Count by status
      if (userData.status === 'inactive') {
        audit.inactiveUsers++;
      }
      
      // Check for permission issues
      const issues = [];
      
      // Check for deprecated isActive field
      if ('isActive' in userData) {
        issues.push('Has deprecated isActive field');
      }
      
      // Check permission structure
      if (!userData.permissions || typeof userData.permissions !== 'object') {
        issues.push('Missing or invalid permissions structure');
      } else {
        const requiredFields = ['documents', 'categories', 'system'];
        for (const field of requiredFields) {
          if (!Array.isArray(userData.permissions[field])) {
            issues.push(`Invalid ${field} permissions`);
          }
        }
      }
      
      // Check admin permissions
      if (userData.role === 'admin') {
        const expectedAdminPerms = ['view', 'upload', 'delete', 'approve'];
        const hasAllAdminPerms = expectedAdminPerms.every(perm => 
          userData.permissions?.documents?.includes(perm)
        );
        
        if (!hasAllAdminPerms) {
          issues.push('Admin missing required document permissions');
        }
      }
      
      if (issues.length > 0) {
        audit.usersWithIssues.push({
          id: doc.id,
          email: userData.email,
          role: userData.role,
          issues: issues
        });
      }
      
      // Track permission distribution
      if (userData.permissions?.documents) {
        userData.permissions.documents.forEach(perm => {
          audit.permissionDistribution[perm] = (audit.permissionDistribution[perm] || 0) + 1;
        });
      }
    }
    
    return audit;
  } catch (error) {
    console.error('❌ Failed to audit user permissions:', error.message);
    return null;
  }
}

// Check for orphaned data
async function checkOrphanedData() {
  console.log('🔍 Checking for orphaned data...');
  
  const orphans = {
    documentsWithoutUsers: [],
    activitiesWithoutUsers: []
  };
  
  try {
    // Get all user IDs
    const usersSnapshot = await admin.firestore().collection('users').get();
    const userIds = new Set(usersSnapshot.docs.map(doc => doc.id));
    
    // Check documents
    const documentsSnapshot = await admin.firestore().collection('documents').get();
    for (const doc of documentsSnapshot.docs) {
      const docData = doc.data();
      if (docData.uploadedBy && !userIds.has(docData.uploadedBy)) {
        orphans.documentsWithoutUsers.push({
          id: doc.id,
          fileName: docData.fileName,
          uploadedBy: docData.uploadedBy
        });
      }
    }
    
    // Check activities
    const activitiesSnapshot = await admin.firestore().collection('activities').get();
    for (const doc of activitiesSnapshot.docs) {
      const activityData = doc.data();
      if (activityData.userId && !userIds.has(activityData.userId)) {
        orphans.activitiesWithoutUsers.push({
          id: doc.id,
          type: activityData.type,
          userId: activityData.userId
        });
      }
    }
    
    return orphans;
  } catch (error) {
    console.error('❌ Failed to check orphaned data:', error.message);
    return null;
  }
}

// Generate system report
async function generateSystemReport() {
  console.log('📊 Generating system report...');
  
  const report = {
    timestamp: new Date().toISOString(),
    health: await checkSystemHealth(),
    userAudit: await auditUserPermissions(),
    orphanedData: await checkOrphanedData()
  };
  
  // Print summary
  console.log('\n📋 System Report Summary');
  console.log('========================');
  console.log(`Status: ${report.health.status.toUpperCase()}`);
  console.log(`Total Users: ${report.userAudit?.totalUsers || 'N/A'}`);
  console.log(`Admin Users: ${report.userAudit?.adminUsers || 'N/A'}`);
  console.log(`Inactive Users: ${report.userAudit?.inactiveUsers || 'N/A'}`);
  console.log(`Documents: ${report.health.metrics.documentsCount || 'N/A'}`);
  console.log(`Categories: ${report.health.metrics.categoriesCount || 'N/A'}`);
  console.log(`Activities: ${report.health.metrics.activitiesCount || 'N/A'}`);
  
  if (report.health.issues.length > 0) {
    console.log('\n⚠️ Health Issues:');
    report.health.issues.forEach(issue => console.log(`   • ${issue}`));
  }
  
  if (report.userAudit?.usersWithIssues.length > 0) {
    console.log('\n⚠️ Users with Permission Issues:');
    report.userAudit.usersWithIssues.forEach(user => {
      console.log(`   • ${user.email} (${user.role}): ${user.issues.join(', ')}`);
    });
  }
  
  if (report.orphanedData?.documentsWithoutUsers.length > 0) {
    console.log('\n⚠️ Orphaned Documents:');
    report.orphanedData.documentsWithoutUsers.forEach(doc => {
      console.log(`   • ${doc.fileName} (uploaded by deleted user: ${doc.uploadedBy})`);
    });
  }
  
  return report;
}

// Maintenance tasks
async function runMaintenance() {
  console.log('🔧 Running maintenance tasks...');
  
  const results = {
    activitiesCleanedUp: await cleanupOldActivities(30),
    healthCheck: await checkSystemHealth(),
    timestamp: new Date().toISOString()
  };
  
  // Log maintenance activity
  try {
    await admin.firestore().collection('activities').add({
      type: 'system_maintenance',
      userId: 'system',
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      details: `Maintenance completed. Cleaned up ${results.activitiesCleanedUp} old activities.`
    });
  } catch (error) {
    console.error('Failed to log maintenance activity:', error.message);
  }
  
  return results;
}

// Interactive menu
const readline = require('readline');
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

function askQuestion(question) {
  return new Promise((resolve) => {
    rl.question(question, (answer) => {
      resolve(answer.trim());
    });
  });
}

async function showMenu() {
  console.log('\n🔧 System Monitor & Maintenance');
  console.log('===============================');
  console.log('1. Health Check');
  console.log('2. Generate System Report');
  console.log('3. Audit User Permissions');
  console.log('4. Check Orphaned Data');
  console.log('5. Cleanup Old Activities');
  console.log('6. Run Full Maintenance');
  console.log('7. Exit');
  
  const choice = await askQuestion('\nSelect an option (1-7): ');
  return choice;
}

// Main function
async function main() {
  try {
    console.log('🚀 Document Management System - Monitor & Maintenance');
    console.log('=====================================================');
    
    initializeFirebase();
    
    while (true) {
      const choice = await showMenu();
      
      switch (choice) {
        case '1':
          const health = await checkSystemHealth();
          console.log('\n🏥 Health Check Results:');
          console.log(JSON.stringify(health, null, 2));
          break;
          
        case '2':
          await generateSystemReport();
          break;
          
        case '3':
          const audit = await auditUserPermissions();
          console.log('\n🔍 User Permissions Audit:');
          console.log(JSON.stringify(audit, null, 2));
          break;
          
        case '4':
          const orphans = await checkOrphanedData();
          console.log('\n🔍 Orphaned Data Check:');
          console.log(JSON.stringify(orphans, null, 2));
          break;
          
        case '5':
          const days = await askQuestion('Enter days old for cleanup (default 30): ');
          const daysOld = parseInt(days) || 30;
          await cleanupOldActivities(daysOld);
          break;
          
        case '6':
          const results = await runMaintenance();
          console.log('\n🔧 Maintenance Results:');
          console.log(JSON.stringify(results, null, 2));
          break;
          
        case '7':
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
  checkSystemHealth,
  cleanupOldActivities,
  auditUserPermissions,
  checkOrphanedData,
  generateSystemReport,
  runMaintenance
};
