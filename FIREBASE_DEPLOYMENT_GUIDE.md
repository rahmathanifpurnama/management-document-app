# Firebase Deployment Guide for Upload System Updates

This guide provides step-by-step instructions for deploying the updated upload system to Firebase, including Cloud Functions and Firestore security rules.

## Prerequisites

Before starting the deployment, ensure you have:

1. **Firebase CLI installed and authenticated**
   ```bash
   npm install -g firebase-tools
   firebase login
   ```

2. **Project access and permissions**
   - Admin access to the Firebase project
   - Billing account enabled (required for Cloud Functions)
   - Firestore database initialized

3. **Environment setup**
   - Node.js 18+ installed
   - TypeScript compiler available
   - All dependencies installed in the functions directory

## Pre-Deployment Checklist

### 1. Backup Current Configuration

Before making any changes, create backups:

```bash
# Backup current Firestore rules
firebase firestore:rules:get > firestore-rules-backup-$(date +%Y%m%d).rules

# Backup current Cloud Functions (if needed)
firebase functions:config:get > functions-config-backup-$(date +%Y%m%d).json
```

### 2. Verify Project Configuration

```bash
# Check current project
firebase projects:list
firebase use --add  # Select your project if not already set

# Verify project settings
firebase project:info
```

## Deployment Steps

### Step 1: Deploy Firestore Security Rules

The updated rules include enhanced validation for the unified upload system.

```bash
# Navigate to project root
cd /path/to/your/project

# Deploy Firestore rules
firebase deploy --only firestore:rules

# Verify deployment
firebase firestore:rules:get
```

**Expected Changes:**
- Enhanced document creation validation with unified ID system
- Upload statistics collection rules
- File validation logs collection rules
- Duplicate cache collection rules

### Step 2: Build and Deploy Cloud Functions

```bash
# Navigate to functions directory
cd functions

# Install dependencies (if not already done)
npm install

# Build TypeScript to JavaScript
npm run build

# Deploy all functions
firebase deploy --only functions

# Or deploy specific functions only
firebase deploy --only functions:processFileUpload,functions:validateFile,functions:checkDuplicateFile
```

**Expected Functions to be Deployed:**
- `processFileUpload` - Enhanced with better security validation
- `validateFile` - Updated validation logic
- `checkDuplicateFile` - Improved duplicate detection
- `generateThumbnail` - Image thumbnail generation
- `extractMetadata` - File metadata extraction
- `getFileAccessUrl` - Secure file access URLs
- `cleanupOrphanedFiles` - File cleanup utilities
- `batchProcessFiles` - Batch processing operations
- `streamingUpload` - Large file upload support

### Step 3: Verify Deployment

After deployment, verify everything is working:

```bash
# Check function deployment status
firebase functions:list

# Check function logs
firebase functions:log

# Test a simple function call
firebase functions:shell
```

## Environment-Specific Configurations

### Development Environment

```bash
# Use development project
firebase use development

# Deploy with development settings
firebase deploy --only firestore:rules,functions
```

### Staging Environment

```bash
# Use staging project
firebase use staging

# Deploy with staging settings
firebase deploy --only firestore:rules,functions
```

### Production Environment

```bash
# Use production project
firebase use production

# Deploy with production settings (more cautious approach)
firebase deploy --only firestore:rules
# Wait and verify rules work correctly
firebase deploy --only functions
```

## Post-Deployment Verification

### 1. Test Upload Functionality

1. **Open the Flutter application**
2. **Navigate to the upload page**
3. **Test file selection and upload**
4. **Verify files appear in document list**
5. **Check Firebase Console for new documents**

### 2. Verify Security Rules

1. **Test authenticated user access**
2. **Test admin user access**
3. **Verify unauthorized access is blocked**
4. **Check Firestore rules simulator in Firebase Console**

### 3. Monitor Cloud Functions

```bash
# Monitor function execution
firebase functions:log --only processFileUpload

# Check function metrics in Firebase Console
# - Invocations
# - Execution time
# - Error rate
```

## Troubleshooting

### Common Issues and Solutions

#### 1. Function Deployment Fails

```bash
# Check function logs for errors
firebase functions:log

# Verify Node.js version compatibility
node --version  # Should be 18+

# Clear and reinstall dependencies
cd functions
rm -rf node_modules package-lock.json
npm install
npm run build
```

#### 2. Firestore Rules Validation Errors

```bash
# Test rules locally
firebase emulators:start --only firestore

# Use rules simulator in Firebase Console
# Test specific operations with sample data
```

#### 3. Upload Functionality Not Working

1. **Check browser console for errors**
2. **Verify Firebase configuration in Flutter app**
3. **Check Cloud Function logs**
4. **Verify Firestore rules allow operations**

## Rollback Procedures

If issues occur after deployment:

### 1. Rollback Firestore Rules

```bash
# Restore previous rules
firebase deploy --only firestore:rules --config firestore-rules-backup-YYYYMMDD.rules
```

### 2. Rollback Cloud Functions

```bash
# List function versions
firebase functions:list

# Rollback to previous version (if available)
# Note: This requires manual intervention in Firebase Console
```

## Monitoring and Maintenance

### 1. Set Up Monitoring

- **Enable Cloud Function monitoring in Firebase Console**
- **Set up alerts for function errors**
- **Monitor Firestore usage and costs**

### 2. Regular Maintenance

- **Review function logs weekly**
- **Monitor storage usage**
- **Clean up old validation logs**
- **Update dependencies regularly**

## Security Considerations

1. **Verify all functions require authentication**
2. **Check rate limiting is working**
3. **Monitor for suspicious upload patterns**
4. **Review file validation logs regularly**
5. **Ensure admin-only operations are protected**

## Support and Documentation

- **Firebase Console**: https://console.firebase.google.com
- **Firebase Documentation**: https://firebase.google.com/docs
- **Cloud Functions Documentation**: https://firebase.google.com/docs/functions
- **Firestore Security Rules**: https://firebase.google.com/docs/firestore/security/get-started

For additional support, check the Firebase status page and community forums.

## Detailed Testing Procedures

### Upload System Testing Checklist

#### 1. Basic Upload Tests
- [ ] Single file upload (PDF, DOC, image)
- [ ] Multiple file upload
- [ ] Large file upload (near 15MB limit)
- [ ] Invalid file type rejection
- [ ] File size limit enforcement

#### 2. Security Validation Tests
- [ ] Malicious file content detection
- [ ] Script injection prevention
- [ ] Executable file rejection
- [ ] Macro-enabled document handling

#### 3. Duplicate Detection Tests
- [ ] Exact duplicate file rejection
- [ ] Hash-based duplicate detection
- [ ] Filename and size duplicate detection
- [ ] Different files with same name handling

#### 4. Error Handling Tests
- [ ] Network interruption during upload
- [ ] Authentication token expiration
- [ ] Storage quota exceeded
- [ ] Cloud Function timeout handling

#### 5. UI Consistency Tests
- [ ] Progress indicators working
- [ ] Error messages displaying correctly
- [ ] File list updates properly
- [ ] Responsive design on different screens

## Performance Optimization

### Cloud Functions Optimization

```javascript
// Example function configuration for better performance
exports.processFileUpload = functions
  .runWith({
    timeoutSeconds: 540,
    memory: '1GB'
  })
  .https.onCall(async (data, context) => {
    // Function implementation
  });
```

### Firestore Query Optimization

```javascript
// Optimized queries for better performance
const documentsQuery = firestore
  .collection('document-metadata')
  .where('isActive', '==', true)
  .where('uploadedBy', '==', userId)
  .orderBy('uploadedAt', 'desc')
  .limit(50);
```

## Cost Management

### 1. Monitor Usage
- **Cloud Functions invocations**
- **Firestore read/write operations**
- **Storage bandwidth usage**
- **Cloud Functions execution time**

### 2. Optimize Costs
- **Implement caching for frequently accessed data**
- **Use Cloud Functions efficiently**
- **Monitor and clean up unused files**
- **Optimize Firestore queries**

## Backup and Recovery

### 1. Automated Backups

```bash
# Set up automated Firestore backups
gcloud firestore export gs://your-backup-bucket/firestore-backup-$(date +%Y%m%d)
```

### 2. Recovery Procedures

```bash
# Restore from backup if needed
gcloud firestore import gs://your-backup-bucket/firestore-backup-YYYYMMDD
```
