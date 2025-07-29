# Firebase Integration Guide

## Overview

SimDoc uses Firebase as its backend-as-a-service platform, providing authentication, database, storage, and cloud functions capabilities.

## Firebase Services Used

### 1. Firebase Authentication
- **Email/Password Authentication**
- **Role-based access control**
- **Session management**
- **Security rules integration**

### 2. Cloud Firestore
- **Document storage and retrieval**
- **Real-time data synchronization**
- **Advanced querying capabilities**
- **Offline support**

### 3. Firebase Storage
- **File upload and download**
- **Secure file access**
- **Organized storage structure**
- **Metadata management**

### 4. Cloud Functions
- **Server-side file processing**
- **Business logic execution**
- **Database triggers**
- **Security validation**

## Firestore Database Structure

### Core Collections

#### users/{userId}
```javascript
{
  id: string,                    // User unique identifier
  email: string,                 // User email address
  fullName: string,              // User display name
  role: 'admin' | 'user',        // User role for permissions
  status: 'active' | 'inactive', // Account status
  permissions: {
    documents: string[],         // Document permissions array
    categories: string[],        // Category access array
    system: string[]             // System-level permissions
  },
  profileImage?: string,         // Profile image URL
  createdAt: timestamp,          // Account creation date
  updatedAt: timestamp,          // Last profile update
  lastLogin: timestamp,          // Last login timestamp
  createdBy: string,             // Admin who created the account
  metadata: {
    deviceInfo?: object,         // Device information
    loginHistory?: object[]      // Login history tracking
  }
}
```

#### documents/{documentId}
```javascript
{
  id: string,                    // Document unique identifier
  fileName: string,              // Original file name
  fileSize: number,              // File size in bytes
  fileType: string,              // MIME type
  filePath: string,              // Storage path
  uploadedBy: string,            // Uploader user ID
  uploadedAt: timestamp,         // Upload timestamp
  category: string,              // Category ID
  status: 'active' | 'deleted',  // Document status
  isDeleted: boolean,            // Soft delete flag
  deletedAt?: timestamp,         // Deletion timestamp
  deletedBy?: string,            // User who deleted
  downloadUrl: string,           // Firebase Storage download URL
  fileHash?: string,             // File hash for duplicate detection
  uploadedByUid: string,         // Firebase Auth UID
  contentType: string,           // Content type
  searchTerms?: string[],        // Search optimization
  analytics?: {
    downloadCount: number,       // Download statistics
    viewCount: number,           // View statistics
    lastAccessed: timestamp      // Last access time
  },
  metadata: {
    originalMetadata?: object,   // Original file metadata
    storageFileName: string,     // Secure storage name
    displayFileName: string,     // User-friendly display name
    secureStorageName: string,   // Security-sanitized name
    createdBy: string,           // Creation source
    unifiedIdSystem: boolean,    // ID system flag
    securityChecks: {
      fileNameSanitized: boolean,
      storageNameSecured: boolean,
      spacesPreservedInDisplay: boolean,
      contentValidated: boolean
    }
  }
}
```

#### categories/{categoryId}
```javascript
{
  id: string,                    // Category unique identifier
  name: string,                  // Category name
  description: string,           // Category description
  createdBy: string,             // Creator user ID
  createdAt: timestamp,          // Creation timestamp
  updatedAt: timestamp,          // Last update timestamp
  permissions: string[],         // User IDs with access
  isActive: boolean,             // Category status
  documentCount: number,         // Number of documents
  metadata: {
    color?: string,              // Category color
    icon?: string,               // Category icon
    sortOrder?: number           // Display order
  }
}
```

#### activities/{activityId}
```javascript
{
  id: string,                    // Activity unique identifier
  type: 'login' | 'logout' | 'upload' | 'download' | 'delete' | 'view' | 'create' | 'edit',
  userId: string,                // User who performed action
  timestamp: timestamp,          // Action timestamp
  details: {
    documentId?: string,         // Related document ID
    categoryId?: string,         // Related category ID
    fileName?: string,           // Related file name
    ipAddress?: string,          // User IP address
    userAgent?: string,          // User agent string
    success: boolean,            // Action success status
    errorMessage?: string        // Error details if failed
  },
  metadata: {
    sessionId?: string,          // Session identifier
    deviceInfo?: object,         // Device information
    location?: object            // Geographic information
  }
}
```

### Backend Collections (Cloud Functions)

#### upload-statistics/{statId}
```javascript
{
  totalFiles: number,            // Total file count
  totalSize: number,             // Total storage used
  categoryBreakdown: object,     // Files per category
  userBreakdown: object,         // Files per user
  lastUpdated: timestamp         // Last statistics update
}
```

#### file-validation-logs/{logId}
```javascript
{
  fileName: string,              // Validated file name
  fileType: string,              // File type
  validationResult: boolean,     // Validation success
  issues?: string[],             // Validation issues
  timestamp: timestamp,          // Validation time
  userId: string                 // User who uploaded
}
```

#### duplicate-cache/{cacheId}
```javascript
{
  fileHash: string,              // File hash
  originalFile: string,          // Original file reference
  duplicateFiles: string[],      // Duplicate file references
  createdAt: timestamp           // Cache creation time
}
```

#### storage_history/{historyId}
```javascript
{
  timestamp: timestamp,          // Snapshot timestamp
  totalBytes: number,            // Total storage used
  fileCount: number,             // Total file count
  categoryBreakdown: object,     // Storage per category
  userBreakdown: object,         // Storage per user
  growthRate: number             // Storage growth rate
}
```

## Firebase Storage Structure

### Storage Organization
```
/documents/
├── {categoryId}/              # Category-specific files
│   ├── {secureFileName1}      # Sanitized file names
│   ├── {secureFileName2}
│   └── ...
├── profile_images/            # User profile images
│   └── {userId}/
│       └── {imageFileName}
├── temp/                      # Temporary upload storage
│   └── {userId}/
│       └── {tempFileName}
└── thumbnails/                # Generated thumbnails
    └── {documentId}/
        └── {thumbnailFile}
```

### File Naming Convention
```javascript
// Original: "My Document (2024).pdf"
// Secure: "my-document-2024-{uuid}.pdf"
// Display: "My Document (2024).pdf"

const generateSecureFileName = (originalName) => {
  const sanitized = originalName
    .toLowerCase()
    .replace(/[^a-z0-9.-]/g, '-')
    .replace(/-+/g, '-')
    .replace(/^-|-$/g, '');
  
  const uuid = generateUUID();
  const extension = path.extname(originalName);
  
  return `${sanitized}-${uuid}${extension}`;
};
```

## Security Rules

### Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isAdmin() {
      return isAuthenticated() &&
             exists(/databases/$(database)/documents/users/$(request.auth.uid)) &&
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin' &&
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.status == 'active';
    }
    
    function isActiveUser() {
      return isAuthenticated() &&
             exists(/databases/$(database)/documents/users/$(request.auth.uid)) &&
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.status == 'active';
    }
    
    function hasDocumentPermission(permission) {
      return isActiveUser() &&
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.permissions.documents.hasAny([permission]);
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if isActiveUser() && 
                     (request.auth.uid == userId || isAdmin());
      
      allow update: if isActiveUser() && 
                       request.auth.uid == userId &&
                       request.resource.data.diff(resource.data).affectedKeys()
                         .hasOnly(['fullName', 'profileImageUrl', 'lastLogin', 'updatedAt']);
      
      allow create, delete: if isAdmin();
    }
    
    // Documents collection
    match /documents/{documentId} {
      allow read: if hasDocumentPermission('view') || isAdmin();
      
      allow create: if hasDocumentPermission('upload') &&
                       request.auth.uid == request.resource.data.uploadedBy &&
                       request.resource.data.keys().hasAll(['id', 'fileName', 'uploadedAt']);
      
      allow update: if (hasDocumentPermission('upload') && 
                        request.auth.uid == resource.data.uploadedBy) ||
                       isAdmin();
      
      allow delete: if isAdmin();
    }
    
    // Categories collection
    match /categories/{categoryId} {
      allow read: if isActiveUser();
      
      allow create, update, delete: if isAdmin();
    }
    
    // Activities collection
    match /activities/{activityId} {
      allow read: if isActiveUser();
      
      allow create: if isActiveUser() &&
                       request.resource.data.userId == request.auth.uid;
      
      allow delete: if isAdmin();
    }
  }
}
```

### Storage Security Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isAdmin() {
      return isAuthenticated() &&
             firestore.exists(/databases/(default)/documents/users/$(request.auth.uid)) &&
             firestore.get(/databases/(default)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    function isActiveUser() {
      return isAuthenticated() &&
             firestore.exists(/databases/(default)/documents/users/$(request.auth.uid)) &&
             firestore.get(/databases/(default)/documents/users/$(request.auth.uid)).data.status == 'active';
    }
    
    function hasDocumentPermission(permission) {
      return isActiveUser() &&
             firestore.get(/databases/(default)/documents/users/$(request.auth.uid))
               .data.permissions.documents.hasAny([permission]);
    }
    
    // Document files
    match /documents/{categoryId}/{fileName} {
      allow read: if hasDocumentPermission('view') || isAdmin();
      
      allow create: if hasDocumentPermission('upload') &&
                       request.resource.size <= 15 * 1024 * 1024 && // 15MB limit
                       request.resource.contentType.matches(
                         'application/pdf|' +
                         'application/msword|' +
                         'application/vnd.openxmlformats-officedocument.wordprocessingml.document|' +
                         'application/vnd.ms-excel|' +
                         'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet|' +
                         'application/vnd.ms-powerpoint|' +
                         'application/vnd.openxmlformats-officedocument.presentationml.presentation'
                       );
      
      allow update: if (hasDocumentPermission('upload') && 
                        resource.metadata.uploadedBy == request.auth.uid) ||
                       isAdmin();
      
      allow delete: if isAdmin();
    }
    
    // Profile images
    match /profile_images/{userId}/{fileName} {
      allow read: if isActiveUser();
      
      allow write: if isActiveUser() &&
                      request.auth.uid == userId &&
                      request.resource.size <= 2 * 1024 * 1024 && // 2MB limit
                      request.resource.contentType.matches('image/.*');
    }
    
    // Temporary files
    match /temp/{userId}/{fileName} {
      allow read, write: if isActiveUser() && request.auth.uid == userId;
      allow delete: if isActiveUser() && request.auth.uid == userId;
    }
  }
}
```

## Cloud Functions

### hybridProcessFileUpload
```typescript
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const processFileUpload = functions
  .runWith({
    timeoutSeconds: 540, // 9 minutes
    memory: '2GB',
  })
  .https.onCall(async (data: any, context: functions.https.CallableContext) => {
    // Authentication check
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'User must be authenticated'
      );
    }

    const { filePath, fileName, contentType, categoryId, metadata } = data;

    try {
      // 1. File validation
      await validateFile(filePath, contentType);

      // 2. Generate secure file name
      const secureFileName = generateSecureFileName(fileName);

      // 3. Extract metadata
      const extractedMetadata = await extractFileMetadata(filePath);

      // 4. Check for duplicates
      const fileHash = await generateFileHash(filePath);
      const isDuplicate = await checkDuplicate(fileHash);

      if (isDuplicate) {
        throw new functions.https.HttpsError(
          'already-exists',
          'File already exists in the system'
        );
      }

      // 5. Create Firestore document
      const documentId = admin.firestore().collection('documents').doc().id;
      
      await admin.firestore().collection('documents').doc(documentId).set({
        id: documentId,
        fileName: fileName,
        fileSize: extractedMetadata.size,
        fileType: contentType,
        filePath: filePath,
        uploadedBy: context.auth.uid,
        uploadedAt: admin.firestore.FieldValue.serverTimestamp(),
        category: categoryId || '',
        status: 'active',
        isDeleted: false,
        fileHash: fileHash,
        downloadUrl: await getDownloadUrl(filePath),
        uploadedByUid: context.auth.uid,
        contentType: contentType,
        metadata: {
          ...extractedMetadata,
          originalMetadata: metadata,
          storageFileName: secureFileName,
          displayFileName: fileName,
          secureStorageName: secureFileName,
          createdBy: 'cloud_function_upload',
          unifiedIdSystem: true,
          securityChecks: {
            fileNameSanitized: fileName !== secureFileName,
            storageNameSecured: true,
            spacesPreservedInDisplay: fileName.includes(' '),
            contentValidated: true
          }
        }
      });

      // 6. Update statistics
      await updateUploadStatistics(categoryId, extractedMetadata.size);

      // 7. Log activity
      await logActivity({
        type: 'upload',
        userId: context.auth.uid,
        details: {
          documentId: documentId,
          fileName: fileName,
          categoryId: categoryId,
          success: true
        }
      });

      return {
        success: true,
        documentId: documentId,
        message: 'File processed successfully'
      };

    } catch (error) {
      console.error('File processing error:', error);
      
      // Log failed activity
      await logActivity({
        type: 'upload',
        userId: context.auth.uid,
        details: {
          fileName: fileName,
          success: false,
          errorMessage: error.message
        }
      });

      throw new functions.https.HttpsError(
        'internal',
        'File processing failed',
        error
      );
    }
  });

// Helper functions
async function validateFile(filePath: string, contentType: string): Promise<void> {
  const allowedTypes = [
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/vnd.ms-excel',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'application/vnd.ms-powerpoint',
    'application/vnd.openxmlformats-officedocument.presentationml.presentation'
  ];

  if (!allowedTypes.includes(contentType)) {
    throw new Error(`Unsupported file type: ${contentType}`);
  }

  // Additional file validation logic
  const file = admin.storage().bucket().file(filePath);
  const [metadata] = await file.getMetadata();
  
  if (metadata.size > 15 * 1024 * 1024) { // 15MB limit
    throw new Error('File size exceeds 15MB limit');
  }
}

function generateSecureFileName(originalName: string): string {
  const sanitized = originalName
    .toLowerCase()
    .replace(/[^a-z0-9.-]/g, '-')
    .replace(/-+/g, '-')
    .replace(/^-|-$/g, '');
  
  const uuid = require('uuid').v4();
  const path = require('path');
  const extension = path.extname(originalName);
  
  return `${sanitized}-${uuid}${extension}`;
}

async function extractFileMetadata(filePath: string): Promise<any> {
  const file = admin.storage().bucket().file(filePath);
  const [metadata] = await file.getMetadata();
  
  return {
    size: metadata.size,
    contentType: metadata.contentType,
    timeCreated: metadata.timeCreated,
    updated: metadata.updated,
    md5Hash: metadata.md5Hash,
    crc32c: metadata.crc32c
  };
}

async function generateFileHash(filePath: string): Promise<string> {
  const file = admin.storage().bucket().file(filePath);
  const [metadata] = await file.getMetadata();
  return metadata.md5Hash;
}

async function checkDuplicate(fileHash: string): Promise<boolean> {
  const duplicateQuery = await admin.firestore()
    .collection('documents')
    .where('fileHash', '==', fileHash)
    .where('status', '==', 'active')
    .limit(1)
    .get();
  
  return !duplicateQuery.empty;
}

async function getDownloadUrl(filePath: string): Promise<string> {
  const file = admin.storage().bucket().file(filePath);
  const [url] = await file.getSignedUrl({
    action: 'read',
    expires: '03-09-2491' // Far future date
  });
  return url;
}

async function updateUploadStatistics(categoryId: string, fileSize: number): Promise<void> {
  const statsRef = admin.firestore().collection('upload-statistics').doc('global');
  
  await admin.firestore().runTransaction(async (transaction) => {
    const statsDoc = await transaction.get(statsRef);
    
    if (statsDoc.exists) {
      const currentStats = statsDoc.data();
      transaction.update(statsRef, {
        totalFiles: (currentStats?.totalFiles || 0) + 1,
        totalSize: (currentStats?.totalSize || 0) + fileSize,
        [`categoryBreakdown.${categoryId}`]: 
          ((currentStats?.categoryBreakdown?.[categoryId] || 0) + 1),
        lastUpdated: admin.firestore.FieldValue.serverTimestamp()
      });
    } else {
      transaction.set(statsRef, {
        totalFiles: 1,
        totalSize: fileSize,
        categoryBreakdown: { [categoryId]: 1 },
        lastUpdated: admin.firestore.FieldValue.serverTimestamp()
      });
    }
  });
}

async function logActivity(activity: any): Promise<void> {
  await admin.firestore().collection('activities').add({
    ...activity,
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
    id: admin.firestore().collection('activities').doc().id
  });
}
```

## Firebase Configuration

### Development Setup
```typescript
// firebase_config.dart
class FirebaseConfig {
  static const String projectId = 'simdoc-development';
  static const String storageBucket = 'simdoc-development.appspot.com';
  static const String apiKey = 'your-development-api-key';
  static const String appId = 'your-development-app-id';
  
  // Collection names
  static const String usersCollection = 'users';
  static const String documentsCollection = 'documents';
  static const String categoriesCollection = 'categories';
  static const String activitiesCollection = 'activities';
  
  // Storage paths
  static const String documentsPath = 'documents';
  static const String profileImagesPath = 'profile_images';
  static const String tempPath = 'temp';
  
  // Limits
  static const int maxFileSize = 15 * 1024 * 1024; // 15MB
  static const int batchSize = 50;
  static const int maxRetries = 3;
}
```

### Production Setup
```typescript
// firebase_config_prod.dart
class FirebaseConfigProd {
  static const String projectId = 'simdoc-production';
  static const String storageBucket = 'simdoc-production.appspot.com';
  static const String apiKey = 'your-production-api-key';
  static const String appId = 'your-production-app-id';
  
  // Enhanced security settings
  static const bool enableAppCheck = true;
  static const bool enablePerformanceMonitoring = true;
  static const bool enableCrashlytics = true;
  static const bool enableAnalytics = true;
}
```

This Firebase integration provides a robust, secure, and scalable backend for the SimDoc application with comprehensive data management, security, and monitoring capabilities.
