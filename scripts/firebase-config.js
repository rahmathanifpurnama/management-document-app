#!/usr/bin/env node

/**
 * Firebase Configuration Helper
 * 
 * Shared Firebase initialization logic for all scripts
 * Supports both development (emulator) and production (service account) modes
 */

const admin = require('firebase-admin');
const path = require('path');

/**
 * Initialize Firebase Admin SDK
 * @param {Object} options - Configuration options
 * @param {string} options.scriptName - Name of the script for logging
 * @param {boolean} options.requireProduction - Whether production mode is required
 * @returns {Object} Firebase admin instance
 */
function initializeFirebase(options = {}) {
  const { scriptName = 'Script', requireProduction = false } = options;
  
  if (!admin.apps.length) {
    const isEmulator = process.env.FIRESTORE_EMULATOR_HOST || process.env.NODE_ENV === 'development';
    
    if (isEmulator && !requireProduction) {
      console.log(`🔧 ${scriptName}: Using Firebase Emulator`);
      admin.initializeApp({
        projectId: 'document-management-c5a96'
      });
      
      // Connect to emulators
      process.env.FIRESTORE_EMULATOR_HOST = process.env.FIRESTORE_EMULATOR_HOST || '127.0.0.1:8080';
      process.env.FIREBASE_AUTH_EMULATOR_HOST = process.env.FIREBASE_AUTH_EMULATOR_HOST || '127.0.0.1:9099';
      process.env.FIREBASE_STORAGE_EMULATOR_HOST = process.env.FIREBASE_STORAGE_EMULATOR_HOST || '127.0.0.1:9199';
    } else {
      console.log(`🔥 ${scriptName}: Using Production Firebase`);
      
      // Try to load service account from multiple possible locations
      const possiblePaths = [
        path.join(__dirname, 'config', 'service-account-key.json'),
        path.join(__dirname, '..', 'config', 'service-account-key.json'),
        process.env.GOOGLE_APPLICATION_CREDENTIALS,
        './service-account-key.json'
      ].filter(Boolean);
      
      let serviceAccountPath = null;
      const fs = require('fs');
      
      for (const possiblePath of possiblePaths) {
        if (fs.existsSync(possiblePath)) {
          serviceAccountPath = possiblePath;
          break;
        }
      }
      
      if (!serviceAccountPath) {
        console.log(`❌ ${scriptName}: Service account key not found!`);
        console.log('📋 Please ensure one of the following:');
        console.log('   1. Place service-account-key.json in scripts/config/');
        console.log('   2. Set GOOGLE_APPLICATION_CREDENTIALS environment variable');
        console.log('   3. Place service-account-key.json in project root');
        console.log('');
        console.log('🔗 Get service account key from:');
        console.log('   Firebase Console > Project Settings > Service Accounts > Generate new private key');
        process.exit(1);
      }
      
      try {
        const serviceAccount = require(serviceAccountPath);
        admin.initializeApp({
          credential: admin.credential.cert(serviceAccount),
          projectId: serviceAccount.project_id,
          storageBucket: `${serviceAccount.project_id}.appspot.com`
        });
        
        console.log(`✅ ${scriptName}: Production Firebase initialized`);
        console.log(`📁 Service account: ${path.basename(serviceAccountPath)}`);
        console.log(`🏗️  Project ID: ${serviceAccount.project_id}`);
      } catch (error) {
        console.log(`❌ ${scriptName}: Failed to initialize Firebase with service account`);
        console.log('💡 Error:', error.message);
        console.log('');
        console.log('🔍 Please check:');
        console.log('   1. Service account key file is valid JSON');
        console.log('   2. Service account has proper permissions');
        console.log('   3. Project ID matches your Firebase project');
        process.exit(1);
      }
    }
  }
  
  return admin;
}

/**
 * Check if running in emulator mode
 * @returns {boolean} True if running in emulator mode
 */
function isEmulatorMode() {
  return !!(process.env.FIRESTORE_EMULATOR_HOST || process.env.NODE_ENV === 'development');
}

/**
 * Get current environment info
 * @returns {Object} Environment information
 */
function getEnvironmentInfo() {
  const isEmulator = isEmulatorMode();
  return {
    mode: isEmulator ? 'emulator' : 'production',
    isEmulator,
    isProduction: !isEmulator,
    projectId: 'document-management-c5a96'
  };
}

/**
 * Validate Firebase connection
 * @param {string} scriptName - Name of the script for logging
 * @returns {Promise<boolean>} True if connection is valid
 */
async function validateConnection(scriptName = 'Script') {
  try {
    // Test Firestore connection
    await admin.firestore().collection('_connection_test').doc('test').set({
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      script: scriptName
    });
    
    // Clean up test document
    await admin.firestore().collection('_connection_test').doc('test').delete();
    
    console.log(`✅ ${scriptName}: Firebase connection validated`);
    return true;
  } catch (error) {
    console.log(`❌ ${scriptName}: Firebase connection failed:`, error.message);
    return false;
  }
}

module.exports = {
  initializeFirebase,
  isEmulatorMode,
  getEnvironmentInfo,
  validateConnection,
  admin: () => admin
};
