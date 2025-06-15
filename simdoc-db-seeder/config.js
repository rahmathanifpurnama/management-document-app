const admin = require('firebase-admin');
const path = require('path');
const fs = require('fs');

// Try to load service account key file
let serviceAccount = null;
const serviceAccountPath = path.join(__dirname, 'service-account-key.json');

if (fs.existsSync(serviceAccountPath)) {
  console.log('🔑 Using service account key file for authentication');
  serviceAccount = require(serviceAccountPath);
} else {
  console.log('⚠️  Service account key file not found. Using default credentials.');
  console.log('📝 To fix authentication issues:');
  console.log('   1. Download service account key from Firebase Console');
  console.log('   2. Save it as "service-account-key.json" in this folder');
  console.log('   3. Re-run the seeder');
}

// Initialize Firebase Admin SDK
const initConfig = {
  projectId: 'document-management-c5a96',
  databaseURL: 'https://document-management-c5a96-default-rtdb.firebaseio.com',
  storageBucket: 'document-management-c5a96.appspot.com'
};

if (serviceAccount) {
  initConfig.credential = admin.credential.cert(serviceAccount);
}

admin.initializeApp(initConfig);

const db = admin.firestore();
const auth = admin.auth();

// Collection names
const COLLECTIONS = {
  USERS: 'users',
  CATEGORIES: 'categories',
  DOCUMENTS: 'document-metadata',
  ACTIVITIES: 'activities'
};

// Helper function to generate timestamp
const generateTimestamp = (daysAgo = 0) => {
  const date = new Date();
  date.setDate(date.getDate() - daysAgo);
  return admin.firestore.Timestamp.fromDate(date);
};

// Helper function to generate random ID
const generateId = () => {
  return Math.random().toString(36).substr(2, 9);
};

module.exports = {
  admin,
  db,
  auth,
  COLLECTIONS,
  generateTimestamp,
  generateId
};
