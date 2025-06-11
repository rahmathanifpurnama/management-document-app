# Firebase Authentication Fix for Database Seeder

## Problem
The database seeder was failing with authentication errors:
```
Error fetching access token: Error while making request: getaddrinfo ENOTFOUND metadata.google.internal
Could not load the default credentials
```

## Root Cause
The Firebase Admin SDK was trying to use Application Default Credentials (ADC), which are only available when running on Google Cloud Platform. The seeder needs explicit service account credentials to authenticate with Firebase.

## Solution Implemented

### 1. Updated Configuration (`config.js`)
- Modified Firebase Admin SDK initialization to use service account key file
- Added fallback to default credentials if service account key is not found
- Added helpful console messages for troubleshooting

### 2. Updated Documentation (`README.md`)
- Changed service account key filename from `credentials.json` to `service-account-key.json`
- Added troubleshooting section for authentication errors
- Updated setup instructions with correct filename

### 3. Enhanced Security (`.gitignore`)
- Added `service-account-key.json` to gitignore to prevent committing sensitive credentials

### 4. Created Setup Helper (`setup-auth.bat`)
- Interactive script to guide users through authentication setup
- Automatically tests connection after setup
- Provides clear step-by-step instructions

### 5. Improved Error Handling (`test-connection.js`)
- Better error messages for authentication failures
- Specific solutions for different types of authentication errors
- References to setup helper script

### 6. Enhanced Batch Script (`run-seeder.bat`)
- Checks for correct service account key filename
- Tests connection before running seeder
- Provides helpful error messages and next steps

## How to Fix the Authentication Issue

### Option 1: Automated Setup (Recommended)
1. Run the setup helper:
   ```bash
   cd simdoc-db-seeder
   setup-auth.bat
   ```
2. Follow the on-screen instructions

### Option 2: Manual Setup
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select project: `document-management-c5a96`
3. Go to **Project Settings** (gear icon) → **Service Accounts**
4. Click **Generate new private key**
5. Download the JSON file
6. Rename it to `service-account-key.json`
7. Place it in the `simdoc-db-seeder/` folder
8. Test connection: `node test-connection.js`
9. Run seeder: `node seed-all.js`

## Verification Steps

1. **Test Connection**:
   ```bash
   cd simdoc-db-seeder
   node test-connection.js
   ```

2. **Run Individual Seeder**:
   ```bash
   node users.js
   ```

3. **Run Complete Seeder**:
   ```bash
   node seed-all.js
   ```

## Security Notes

- The `service-account-key.json` file contains sensitive credentials
- It is automatically excluded from version control via `.gitignore`
- Never commit this file to the repository
- Each developer needs their own copy of the service account key

## Service Account Permissions Required

The service account should have these roles:
- **Firebase Admin SDK Administrator Service Agent**
- **Cloud Datastore User**
- **Firebase Authentication Admin**
- **Service Usage Consumer** (roles/serviceusage.serviceUsageConsumer) ⚠️ **CRITICAL**

## Step-by-Step Permission Fix

### 🔧 Fix Firebase Authentication Permissions (REQUIRED)

**Current Error:**
```
❌ Error creating auth user: Caller does not have required permission to use project document-management-c5a96.
Grant the caller the roles/serviceusage.serviceUsageConsumer role
```

**Solution Steps:**

1. **Open Google Cloud Console IAM:**
   ```
   https://console.developers.google.com/iam-admin/iam/project?project=document-management-c5a96
   ```

2. **Find Your Service Account:**
   - Look for: `firebase-adminsdk-fbsvc@document-management-c5a96.iam.gserviceaccount.com`
   - Current roles should show: Firebase Admin SDK Administrator Service Agent

3. **Add Missing Role:**
   - Click the ✏️ (edit/pencil) icon next to your service account
   - Click "ADD ANOTHER ROLE" button
   - In the role dropdown, search for: `Service Usage Consumer`
   - Select: **Service Usage Consumer** (roles/serviceusage.serviceUsageConsumer)
   - Click "SAVE"

4. **Verify All Required Roles:**
   After adding, your service account should have:
   - ✅ Firebase Admin SDK Administrator Service Agent
   - ✅ Service Usage Consumer ← **NEWLY ADDED**

5. **Wait for Propagation:**
   - Wait 2-3 minutes for permissions to take effect
   - Google Cloud IAM changes can take a few minutes to propagate

6. **Test the Fix:**
   ```bash
   cd simdoc-db-seeder
   node test-connection.js
   node users.js
   ```

## Alternative: Quick Permission Check Script

Create and run this script to verify permissions:

### Error: "Cannot read properties of undefined (reading 'Timestamp')"
This error has been fixed in the activities.js file by resolving variable name conflicts.

## Files Modified

1. `config.js` - Updated Firebase initialization
2. `README.md` - Updated documentation and troubleshooting
3. `.gitignore` - Added new service account key filename
4. `setup-auth.bat` - New setup helper script
5. `test-connection.js` - Enhanced error messages
6. `run-seeder.bat` - Updated authentication checks
7. `AUTHENTICATION_FIX.md` - This documentation file

## Next Steps

1. Download the service account key from Firebase Console
2. Place it as `service-account-key.json` in the seeder folder
3. Run `node test-connection.js` to verify authentication
4. Run `node seed-all.js` to seed the database

The authentication issue should now be resolved!
