# Production Deployment Guide

## Overview

This guide provides step-by-step instructions for deploying the restructured Document Management System to production with the new admin-only hard delete operations and updated database structure.

## Pre-Deployment Checklist

### 1. Backup Existing Data
```bash
# Export existing Firestore data
firebase firestore:export gs://your-backup-bucket/backup-$(date +%Y%m%d)

# Export Firebase Auth users
firebase auth:export users-backup-$(date +%Y%m%d).json
```

### 2. Test in Staging Environment
- [ ] Deploy to staging environment first
- [ ] Run full validation tests
- [ ] Test admin user creation
- [ ] Verify hard delete operations
- [ ] Test permission-based access control

### 3. Prepare Service Account
- [ ] Download service account key from Firebase Console
- [ ] Store securely (never commit to version control)
- [ ] Configure environment variables

## Deployment Steps

### Step 1: Update Firebase Security Rules

1. **Deploy Firestore Rules**
```bash
firebase deploy --only firestore:rules
```

2. **Deploy Storage Rules**
```bash
firebase deploy --only storage
```

3. **Verify Rules Deployment**
- Check Firebase Console > Firestore > Rules
- Check Firebase Console > Storage > Rules
- Ensure rules are active and no syntax errors

### Step 2: Deploy Cloud Functions

1. **Build Functions**
```bash
cd functions
npm run build
```

2. **Deploy Functions**
```bash
firebase deploy --only functions
```

3. **Verify Functions**
- Check Firebase Console > Functions
- Test critical functions (createUser, initializeAdmin)

### Step 3: Data Migration (If Needed)

If you have existing data with `isActive` fields:

1. **Create Migration Script**
```javascript
// migration-script.js
const admin = require('firebase-admin');

async function migrateUsers() {
  const users = await admin.firestore().collection('users').get();
  const batch = admin.firestore().batch();
  
  users.docs.forEach(doc => {
    const data = doc.data();
    if ('isActive' in data) {
      // Convert isActive to status
      const newData = {
        ...data,
        status: data.isActive ? 'active' : 'inactive'
      };
      delete newData.isActive;
      
      batch.update(doc.ref, newData);
    }
  });
  
  await batch.commit();
  console.log('Migration completed');
}
```

2. **Run Migration**
```bash
node migration-script.js
```

### Step 4: Create Admin Users

1. **Configure Production Scripts**
```javascript
// Update scripts for production
const serviceAccount = require('./path/to/service-account.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: 'your-production-project-id'
});
```

2. **Create Admin User**
```bash
cd scripts
node setup-admin.js
```

3. **Verify Admin Access**
- Test login with admin credentials
- Verify admin permissions work
- Test hard delete operations

### Step 5: Validation and Testing

1. **Run Validation Script**
```bash
cd scripts
npm run validate
```

2. **Manual Testing**
- [ ] Admin user login
- [ ] Document upload/download
- [ ] User management functions
- [ ] Hard delete operations
- [ ] Permission-based access

## Post-Deployment Tasks

### 1. Monitor System Health

1. **Check Firebase Console**
- Monitor function execution logs
- Check for any error patterns
- Verify database operations

2. **Set Up Monitoring**
```javascript
// Add to Cloud Functions
const functions = require('firebase-functions');

exports.healthCheck = functions.https.onRequest((req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    version: '2.0.0'
  });
});
```

### 2. Update Documentation

1. **User Documentation**
- Update user guides with new permission system
- Document admin-only operations
- Provide troubleshooting guides

2. **Developer Documentation**
- Update API documentation
- Document new security rules
- Update integration guides

### 3. Train Users

1. **Admin Training**
- New permission system
- Hard delete operations
- User management functions

2. **End User Training**
- Updated interface changes
- New permission requirements
- Support contact information

## Security Considerations

### 1. Access Control
- [ ] Verify admin-only operations are properly restricted
- [ ] Test permission-based access control
- [ ] Ensure inactive users cannot access system

### 2. Data Protection
- [ ] Verify hard delete operations are irreversible
- [ ] Ensure sensitive data is properly protected
- [ ] Test backup and recovery procedures

### 3. Monitoring
- [ ] Set up alerts for failed operations
- [ ] Monitor unusual access patterns
- [ ] Log all admin operations

## Rollback Plan

If issues occur after deployment:

### 1. Immediate Rollback
```bash
# Rollback security rules
firebase deploy --only firestore:rules --project staging
firebase deploy --only storage --project staging

# Rollback functions
firebase deploy --only functions --project staging
```

### 2. Data Restoration
```bash
# Restore from backup
firebase firestore:import gs://your-backup-bucket/backup-YYYYMMDD

# Restore auth users
firebase auth:import users-backup-YYYYMMDD.json
```

### 3. Communication
- Notify users of temporary issues
- Provide estimated resolution time
- Document lessons learned

## Environment Configuration

### Production Environment Variables
```bash
# Firebase Configuration
FIREBASE_PROJECT_ID=your-production-project
GOOGLE_APPLICATION_CREDENTIALS=./service-account.json

# Application Configuration
NODE_ENV=production
APP_ENV=production

# Security Configuration
ENABLE_HARD_DELETE=true
ADMIN_ONLY_DELETE=true
```

### Staging Environment Variables
```bash
# Firebase Configuration
FIREBASE_PROJECT_ID=your-staging-project
GOOGLE_APPLICATION_CREDENTIALS=./staging-service-account.json

# Application Configuration
NODE_ENV=staging
APP_ENV=staging

# Security Configuration
ENABLE_HARD_DELETE=true
ADMIN_ONLY_DELETE=true
```

## Performance Optimization

### 1. Firestore Optimization
- Create composite indexes for common queries
- Optimize security rules for performance
- Monitor read/write operations

### 2. Storage Optimization
- Implement file compression
- Set up CDN for file delivery
- Monitor storage usage

### 3. Function Optimization
- Optimize cold start times
- Monitor function execution duration
- Set appropriate memory allocation

## Maintenance Tasks

### Daily
- [ ] Monitor error logs
- [ ] Check system health metrics
- [ ] Verify backup completion

### Weekly
- [ ] Review user access patterns
- [ ] Check storage usage
- [ ] Update security patches

### Monthly
- [ ] Review and rotate service account keys
- [ ] Audit user permissions
- [ ] Performance optimization review

## Support and Troubleshooting

### Common Issues

1. **Permission Denied Errors**
- Check user status (active/inactive)
- Verify user permissions
- Check security rules deployment

2. **Hard Delete Not Working**
- Verify admin role assignment
- Check custom claims
- Review function logs

3. **Data Structure Errors**
- Run validation script
- Check for missing required fields
- Verify data migration completion

### Getting Help

1. **Internal Support**
- Check deployment logs
- Review validation results
- Consult this documentation

2. **External Support**
- Firebase Support (for platform issues)
- Community forums
- Documentation resources

---

**Deployment Checklist**: Complete all items before production deployment
**Rollback Plan**: Test rollback procedures in staging environment
**Monitoring**: Set up comprehensive monitoring before going live
