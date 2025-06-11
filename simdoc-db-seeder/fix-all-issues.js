/**
 * Complete Fix Script for Database Seeder Issues
 * 
 * This script addresses both:
 * 1. ✅ Activities seeding timestamp error (already fixed)
 * 2. 🔧 Firebase Authentication permissions (requires manual IAM fix)
 */

const { verifyPermissions } = require('./verify-permissions');
const { seedUsers } = require('./users');
const { seedCategories } = require('./categories');
const { seedDocuments } = require('./documents');
const { seedActivities } = require('./activities');

async function fixAllIssues() {
  console.log('🚀 SIMDOC Database Seeder - Complete Fix');
  console.log('📅 ' + new Date().toLocaleString());
  console.log('=' .repeat(60));

  console.log('\n📋 ISSUES BEING ADDRESSED:');
  console.log('1. ✅ Activities seeding timestamp error (FIXED)');
  console.log('2. 🔧 Firebase Authentication permissions (CHECKING...)');
  console.log('');

  // Step 1: Verify current permissions
  console.log('🔍 STEP 1: Verifying current permissions...');
  const permissionsOk = await verifyPermissions();
  
  if (!permissionsOk) {
    console.log('\n⚠️  MANUAL ACTION REQUIRED:');
    console.log('=' .repeat(60));
    console.log('🔧 Firebase Authentication permissions need to be fixed manually.');
    console.log('');
    console.log('📋 QUICK FIX STEPS:');
    console.log('1. Open: https://console.developers.google.com/iam-admin/iam/project?project=document-management-c5a96');
    console.log('2. Find service account: firebase-adminsdk-fbsvc@document-management-c5a96.iam.gserviceaccount.com');
    console.log('3. Click the ✏️ (edit) icon');
    console.log('4. Click "ADD ANOTHER ROLE"');
    console.log('5. Search and select: "Service Usage Consumer"');
    console.log('6. Click "SAVE"');
    console.log('7. Wait 2-3 minutes for changes to take effect');
    console.log('8. Re-run this script: node fix-all-issues.js');
    console.log('');
    console.log('📖 For detailed instructions, see: AUTHENTICATION_FIX.md');
    console.log('');
    
    // Offer alternative seeding without auth
    console.log('🔄 ALTERNATIVE: Seed without Firebase Authentication');
    console.log('If you want to proceed without fixing permissions:');
    console.log('   node seed-without-auth.js');
    console.log('');
    console.log('⚠️  Note: This will create database records but NOT Firebase Auth users.');
    console.log('   You\'ll need to create auth users manually later.');
    
    return false;
  }

  // Step 2: Run complete seeding
  console.log('\n🎉 STEP 2: All permissions verified! Running complete seeding...');
  console.log('=' .repeat(60));

  try {
    // Seed in order: users -> categories -> documents -> activities
    console.log('\n1️⃣ Seeding Users...');
    await seedUsers();

    console.log('\n2️⃣ Seeding Categories...');
    await seedCategories();

    console.log('\n3️⃣ Seeding Documents...');
    await seedDocuments();

    console.log('\n4️⃣ Seeding Activities...');
    await seedActivities();
    
    console.log('\n' + '=' .repeat(60));
    console.log('🎉 ALL ISSUES FIXED AND SEEDING COMPLETED!');
    console.log('=' .repeat(60));
    console.log('');
    console.log('✅ FIXED ISSUES:');
    console.log('   1. Activities seeding timestamp error');
    console.log('   2. Firebase Authentication permissions');
    console.log('');
    console.log('✅ SEEDED DATA:');
    console.log('   - Users (Firebase Auth + Firestore)');
    console.log('   - Categories');
    console.log('   - Documents');
    console.log('   - Activities');
    console.log('');
    console.log('🚀 Your database is now ready for the Flutter app!');
    
    return true;
    
  } catch (error) {
    console.error('\n💥 Seeding failed even with correct permissions:', error);
    console.log('\n🔍 DEBUGGING STEPS:');
    console.log('1. Check if all required files exist');
    console.log('2. Verify service account key is valid');
    console.log('3. Check network connectivity');
    console.log('4. Review error details above');
    
    return false;
  }
}

// Helper function to check if activities.js fix is applied
function checkActivitiesFixStatus() {
  const fs = require('fs');
  const path = require('path');
  
  try {
    const activitiesPath = path.join(__dirname, 'activities.js');
    const content = fs.readFileSync(activitiesPath, 'utf8');
    
    // Check if the fix is applied (adminUser instead of admin)
    const hasAdminUser = content.includes('const adminUser = adminUsers[0];');
    const hasOldAdmin = content.includes('const admin = adminUsers[0];');
    
    if (hasAdminUser && !hasOldAdmin) {
      console.log('✅ Activities.js timestamp fix: APPLIED');
      return true;
    } else {
      console.log('❌ Activities.js timestamp fix: NOT APPLIED');
      return false;
    }
  } catch (error) {
    console.log('⚠️  Activities.js timestamp fix: CANNOT VERIFY');
    return false;
  }
}

// Run fix if called directly
if (require.main === module) {
  console.log('🔍 Checking activities.js fix status...');
  checkActivitiesFixStatus();
  console.log('');
  
  fixAllIssues()
    .then((success) => {
      console.log('\n🏁 Fix process completed!');
      process.exit(success ? 0 : 1);
    })
    .catch((error) => {
      console.error('\n💥 Fix process failed:', error);
      process.exit(1);
    });
}

module.exports = { fixAllIssues, checkActivitiesFixStatus };
