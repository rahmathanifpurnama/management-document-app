const admin = require('firebase-admin');
const serviceAccount = require('./credentials.json');

// Initialize Firebase Admin SDK
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: `https://${serviceAccount.project_id}-default-rtdb.firebaseio.com`
});

const db = admin.firestore();
const auth = admin.auth();

// Collection names
const COLLECTIONS = {
  USERS: 'users',
  CATEGORIES: 'categories', 
  DOCUMENTS: 'documents',
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
