# Admin User Setup Guide

## Overview

This guide explains how to create admin users for the Document Management System. Admin users are created directly in Firebase Authentication console and then configured through Cloud Functions.

## Prerequisites

1. Firebase project is set up and configured
2. Cloud Functions are deployed
3. Access to Firebase Console

## Step 1: Create Admin User in Firebase Authentication

### Using Firebase Console

1. **Open Firebase Console**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Select your project

2. **Navigate to Authentication**
   - Click on "Authentication" in the left sidebar
   - Go to "Users" tab

3. **Add User**
   - Click "Add user" button
   - Enter admin email address (e.g., `admin@yourcompany.com`)
   - Enter a secure password
   - Click "Add user"

4. **Note the User UID**
   - After creation, note down the User UID (you'll need this for the next step)

### Using Firebase CLI (Alternative)

```bash
# Install Firebase CLI if not already installed
npm install -g firebase-tools

# Login to Firebase
firebase login

# Create user using Firebase Auth REST API
# (This requires additional setup and is more complex)
```

## Step 2: Configure Admin Role in Firestore

### Option A: Using Cloud Function (Recommended)

1. **Call the initializeAdmin Cloud Function**
   ```javascript
   // Using Firebase SDK in your app or test script
   const functions = firebase.functions();
   const initializeAdmin = functions.httpsCallable('initializeAdmin');
   
   initializeAdmin({ email: 'admin@yourcompany.com' })
     .then((result) => {
       console.log('Admin initialized:', result.data);
     })
     .catch((error) => {
       console.error('Error:', error);
     });
   ```

2. **Or using curl (if you have the function URL)**
   ```bash
   curl -X POST \
     -H "Content-Type: application/json" \
     -d '{"data":{"email":"admin@yourcompany.com"}}' \
     https://your-region-your-project.cloudfunctions.net/initializeAdmin
   ```

### Option B: Manual Firestore Setup

1. **Open Firestore Console**
   - Go to Firestore Database in Firebase Console
   - Navigate to the `users` collection

2. **Create/Update User Document**
   - Create a document with the User UID as the document ID
   - Add the following fields:
   ```json
   {
     "id": "USER_UID_FROM_AUTH",
     "fullName": "Admin User",
     "email": "admin@yourcompany.com",
     "role": "admin",
     "status": "active",
     "createdAt": "2024-01-01T00:00:00Z",
     "updatedAt": "2024-01-01T00:00:00Z",
     "permissions": {
       "documents": ["view", "upload", "delete", "approve"],
       "categories": [],
       "system": ["user_management", "analytics"]
     },
     "lastLogin": null,
     "profileImageUrl": null
   }
   ```

## Step 3: Verify Admin Setup

### Test Admin Login

1. **Login to the app** using the admin credentials
2. **Verify admin permissions** by checking:
   - User Management access
   - Analytics access
   - Document management capabilities
   - All CRUD operations on documents

### Check Firestore Document

1. **Verify user document** in Firestore:
   - Document exists in `users` collection
   - Role is set to "admin"
   - Permissions include admin capabilities
   - Status is "active"

### Check Firebase Auth Custom Claims (Optional)

The `initializeAdmin` function also sets custom claims in Firebase Auth:

```javascript
// Check custom claims
firebase.auth().currentUser.getIdTokenResult()
  .then((idTokenResult) => {
    console.log('Custom claims:', idTokenResult.claims);
    // Should include: { admin: true }
  });
```

## Admin User Structure

### Firestore Document Structure

```typescript
interface AdminUser {
  id: string;                    // Firebase Auth UID
  fullName: string;             // Display name
  email: string;                // Email address
  role: "admin";                // Always "admin" for admin users
  status: "active";             // User status
  createdAt: Timestamp;         // Creation timestamp
  updatedAt: Timestamp;         // Last update timestamp
  permissions: {
    documents: string[];        // ["view", "upload", "delete", "approve"]
    categories: string[];       // Category permissions (usually empty for admin)
    system: string[];          // ["user_management", "analytics"]
  };
  lastLogin: Timestamp | null;  // Last login time
  profileImageUrl: string | null; // Profile image URL
  createdBy?: string;           // Who created this user (optional)
}
```

### Default Admin Permissions

```typescript
const adminPermissions = {
  documents: ["view", "upload", "delete", "approve"],
  categories: [],
  system: ["user_management", "analytics"]
};
```

## Security Considerations

1. **Strong Passwords**: Use strong, unique passwords for admin accounts
2. **Limited Admin Users**: Create only necessary admin users
3. **Regular Audits**: Regularly review admin user list
4. **Access Logging**: Monitor admin activities through the activities collection
5. **Two-Factor Authentication**: Consider enabling 2FA in Firebase Auth

## Troubleshooting

### Common Issues

1. **"User not found" error**
   - Verify the email address is correct
   - Check that the user exists in Firebase Authentication

2. **"Permission denied" error**
   - Ensure you have admin privileges to call the function
   - Check Firestore security rules

3. **Admin permissions not working**
   - Verify the user document in Firestore has correct role and permissions
   - Check that custom claims are set (if using them)

### Verification Steps

1. **Check Firebase Auth**: User exists and is enabled
2. **Check Firestore**: User document exists with correct structure
3. **Check App**: User can login and access admin features
4. **Check Logs**: Review Cloud Function logs for any errors

## Next Steps

After setting up the admin user:

1. **Update Firestore Security Rules** (Task 4)
2. **Update Firebase Storage Security Rules** (Task 5)
3. **Create Database Seeder** (Task 6)
4. **Test all admin functionalities**

## Support

If you encounter issues:

1. Check the Cloud Function logs in Firebase Console
2. Review Firestore security rules
3. Verify the user document structure matches the expected format
4. Test with Firebase emulator first if available
