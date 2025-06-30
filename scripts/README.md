# Database Management Scripts

This directory contains utility scripts for managing the Document Management System database and initial setup.

## Prerequisites

1. **Node.js** (version 18 or higher)
2. **Firebase CLI** installed and configured
3. **Firebase Emulator Suite** (for development)

## Installation

```bash
cd scripts
npm install
```

## Scripts Overview

### 1. Admin Setup Script (`setup-admin.js`)

Creates and manages admin users for the system.

**Features:**
- Create new admin users in Firebase Auth
- Upgrade existing users to admin role
- List existing admin users
- Set proper permissions and custom claims

**Usage:**
```bash
# Interactive mode
npm run setup-admin:emulator

# Or run directly
node setup-admin.js
```

**Options:**
1. Create new admin user
2. Upgrade existing user to admin
3. List existing admin users
4. Show manual setup instructions
5. Exit

### 2. Database Seeder (`database-seeder.js`)

Comprehensive database seeder for initial system setup.

**Features:**
- Full database seeding with sample data
- Partial seeding (categories, users, documents only)
- Data clearing and verification
- Support for both emulator and production

**Usage:**
```bash
# Full seeding (recommended for development)
npm run seed:emulator

# Interactive mode
node database-seeder.js
```

**Seeding Options:**
1. **Full seed** - Clear all data and seed everything
2. **Seed categories only** - Create document categories
3. **Seed users only** - Create sample users
4. **Seed documents only** - Create sample document metadata
5. **Clear all data** - Remove all existing data
6. **Verify existing data** - Check current data status
7. **Show sample credentials** - Display test user accounts
8. **Exit**

### 3. Validation Script (`validate-rules.js`)

Validates database structure and security rules compliance.

**Features:**
- User structure validation
- Admin permissions verification
- Categories and documents structure check
- Data integrity validation

**Usage:**
```bash
npm run validate:emulator
```

### 4. Integration Test Suite (`integration-test.js`)

Comprehensive testing of the entire system.

**Features:**
- Admin and regular user creation tests
- Hard delete operations testing
- Permission structure validation
- Data integrity checks

**Usage:**
```bash
npm run test:emulator
```

### 5. System Monitor (`system-monitor.js`)

System health monitoring and maintenance tools.

**Features:**
- Health checks and system metrics
- User permission auditing
- Orphaned data detection
- Automated maintenance tasks

**Usage:**
```bash
npm run monitor:emulator
```

**Monitor Options:**
1. Health Check
2. Generate System Report
3. Audit User Permissions
4. Check Orphaned Data
5. Cleanup Old Activities
6. Run Full Maintenance
7. Exit

## Sample Data

### Categories
- General Documents
- Contracts
- Reports
- Policies
- Invoices

### Users (Only Admin and User Roles)
- **Admin**: admin@company.com / Admin123!
- **User 1**: user1@company.com / User123!
- **User 2**: user2@company.com / User123!
- **User 3**: user3@company.com / User123!

### Permissions Structure (Simplified - Only 2 Roles)
```javascript
{
  admin: {
    documents: ['view', 'upload', 'delete', 'approve'],
    categories: [],
    system: ['user_management', 'analytics']
  },
  user: {
    documents: ['view', 'upload'],
    categories: [],
    system: []
  }
}
```

## Environment Setup

### Development (Emulator)

1. **Start Firebase Emulators:**
```bash
firebase emulators:start
```

2. **Run scripts with emulator:**
```bash
npm run setup-admin:emulator
npm run seed:emulator
```

### Production

1. **Configure service account** in the scripts
2. **Update Firebase project ID**
3. **Run with production environment**

⚠️ **Warning**: Production seeding will clear existing data!

## Database Structure

The seeder creates data using the new structure:

### Users Collection
```javascript
{
  id: "user_uid",
  fullName: "User Name",
  email: "user@example.com",
  role: "admin|user",
  status: "active|inactive",
  permissions: {
    documents: ["view", "upload", "delete", "approve"],
    categories: [],
    system: ["user_management", "analytics"]
  },
  createdAt: Timestamp,
  updatedAt: Timestamp,
  lastLogin: Timestamp|null,
  profileImageUrl: string|null
}
```

### Categories Collection
```javascript
{
  id: "category_id",
  name: "Category Name",
  description: "Category description",
  color: "#color_code",
  icon: "icon_name",
  sortOrder: number,
  createdAt: Timestamp,
  updatedAt: Timestamp
}
```

### Documents Collection
```javascript
{
  id: "document_id",
  fileName: "file.pdf",
  originalName: "Original File.pdf",
  category: "category_id",
  description: "Document description",
  status: "pending|approved|rejected",
  fileSize: number,
  mimeType: "application/pdf",
  uploadedBy: "user_uid",
  uploadedAt: Timestamp,
  updatedAt: Timestamp,
  downloadUrl: "gs://bucket/path",
  storagePath: "documents/document_id",
  version: number,
  tags: [],
  approvedBy: "user_uid"|null,
  approvedAt: Timestamp|null
}
```

## Security Features

- **Hard Delete Operations**: No soft delete with isActive field
- **Permission-Based Access**: Granular permissions for documents and system
- **Admin-Only Operations**: Certain operations restricted to admin users
- **Status-Based Access**: Only active users can perform operations

## Troubleshooting

### Common Issues

1. **"Firebase not initialized"**
   - Ensure Firebase emulators are running
   - Check environment variables

2. **"Permission denied"**
   - Verify Firebase security rules
   - Check user permissions

3. **"User already exists"**
   - Use the clear data option first
   - Or upgrade existing user to admin

### Verification Steps

1. **Check Firestore data:**
   - Open Firebase Emulator UI (http://localhost:4000)
   - Navigate to Firestore tab
   - Verify collections and documents

2. **Check Authentication:**
   - Open Authentication tab in emulator UI
   - Verify users are created

3. **Test login:**
   - Use sample credentials to test app login
   - Verify permissions work correctly

## Quick Reference

### Common Commands
```bash
# Setup and seeding
npm run setup-admin:emulator    # Create admin users
npm run seed:emulator           # Seed database with sample data
npm run test:full              # Full test suite (seed + validate + test)

# Testing and validation
npm run validate:emulator       # Validate database structure
npm run test:emulator          # Run integration tests
npm run test:quick             # Quick validation and testing

# Monitoring and maintenance
npm run monitor:emulator        # System monitoring and maintenance
npm run health-check           # Quick health check
npm run maintenance            # Run maintenance tasks
```

### Development Workflow
1. **Start Firebase Emulators**: `firebase emulators:start`
2. **Seed Database**: `npm run seed:emulator`
3. **Validate Setup**: `npm run validate:emulator`
4. **Run Tests**: `npm run test:emulator`
5. **Monitor System**: `npm run monitor:emulator`

### Production Deployment
1. **Test in Staging**: Run full test suite
2. **Deploy Security Rules**: `firebase deploy --only firestore:rules,storage`
3. **Deploy Functions**: `firebase deploy --only functions`
4. **Create Admin Users**: Use production-configured scripts
5. **Monitor System**: Set up automated monitoring

## Best Practices

1. **Development**: Always use emulator for testing
2. **Production**: Backup existing data before seeding
3. **Security**: Change default passwords in production
4. **Monitoring**: Verify data after seeding operations

## Support

For issues or questions:
1. Check the logs for detailed error messages
2. Verify Firebase emulator is running
3. Review the security rules
4. Check the admin setup guide: `docs/ADMIN_SETUP_GUIDE.md`
5. Review deployment guide: `docs/DEPLOYMENT_GUIDE.md`
