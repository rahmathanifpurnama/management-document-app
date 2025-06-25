# 🔐 Firebase Test Lab - Role-Based Testing Guide

## Overview
Panduan lengkap untuk menjalankan integration test dengan role-based access control (Admin vs User) di Firebase Test Lab.

## 📋 Prerequisites

### 1. Firebase Project Setup
- Firebase project sudah aktif
- Firebase Authentication enabled
- Firestore database configured
- Firebase Test Lab enabled

### 2. Development Environment
```bash
# Install dependencies
npm install firebase-admin
flutter pub get

# Install Google Cloud SDK
# Download: https://cloud.google.com/sdk/docs/install

# Authenticate
gcloud auth login
gcloud config set project your-project-id
```

## 👥 Setup Test Users

### 1. Automatic Setup (Recommended)
```bash
# Set environment variable
export FIREBASE_PROJECT_ID=your-project-id

# Create test users and data
node scripts/setup_test_users.js setup
```

### 2. Manual Setup
**Go to Firebase Console → Authentication → Users**

**Admin User:**
- Email: `admin@test.com`
- Password: `admin123`
- Custom Claims: `{"role": "admin", "permissions": ["read", "write", "delete", "manage_users"]}`

**Regular User:**
- Email: `user@test.com`
- Password: `user123`
- Custom Claims: `{"role": "user", "permissions": ["read", "write"]}`

### 3. Verify Setup
```bash
# Check if users were created
# Go to Firebase Console → Authentication → Users
# You should see both test users listed
```

## 🧪 Running Role-Based Tests

### 1. Build APKs
```bash
# Build main APK
flutter build apk --debug

# Build test APK
flutter build apk --debug integration_test/test_flows/role_based_test.dart
```

### 2. Run Tests

#### Test Both Roles (Recommended)
```bash
# Linux/Mac
./scripts/test_role_based_access.sh --project your-project-id --type both

# Windows
scripts\test_role_based_access.bat --project your-project-id --type both
```

#### Test Admin Only
```bash
# Linux/Mac
./scripts/test_role_based_access.sh --project your-project-id --type admin

# Windows
scripts\test_role_based_access.bat --project your-project-id --type admin
```

#### Test User Only
```bash
# Linux/Mac
./scripts/test_role_based_access.sh --project your-project-id --type user

# Windows
scripts\test_role_based_access.bat --project your-project-id --type user
```

### 3. Advanced Options

#### With Video Recording
```bash
./scripts/test_role_based_access.sh --project your-project-id --type both --record-video
```

#### Custom Device
```bash
./scripts/test_role_based_access.sh \
  --project your-project-id \
  --type both \
  --device "model=Pixel6,version=33,locale=en,orientation=portrait"
```

#### Custom Timeout
```bash
./scripts/test_role_based_access.sh \
  --project your-project-id \
  --type both \
  --timeout 45m
```

## 📊 Test Coverage

### Admin Tests
- ✅ Login with admin credentials
- ✅ Access user management features
- ✅ Approve/reject documents
- ✅ Delete documents
- ✅ Create/manage categories
- ✅ View all user activities

### User Tests
- ✅ Login with user credentials
- ✅ Upload documents
- ✅ View own documents
- ✅ Access allowed categories
- ❌ Cannot access user management
- ❌ Cannot delete other users' documents
- ❌ Cannot approve/reject documents

### Cross-Role Validation
- ✅ Role isolation (user session ≠ admin privileges)
- ✅ Permission boundaries
- ✅ Session management

## 🔧 Troubleshooting

### Test Users Not Found
```bash
# Re-create test users
node scripts/setup_test_users.js cleanup
node scripts/setup_test_users.js setup

# Verify in Firebase Console
# Go to Authentication → Users
```

### Authentication Errors
```bash
# Check project configuration
gcloud config get-value project

# Set correct project
gcloud config set project your-project-id

# Re-authenticate
gcloud auth login
```

### Role Permission Failures
```bash
# Check custom claims in Firebase Console
# Go to Authentication → Users → Select user → Custom claims

# Verify Firestore security rules
# Ensure rules allow test user access

# Check test data exists
# Go to Firestore → Collections
```

### APK Build Errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build apk --debug --verbose

# Check for dependency issues
flutter doctor
```

### Test Timeout
```bash
# Increase timeout
./scripts/test_role_based_access.sh --project your-project-id --timeout 45m

# Use faster device
./scripts/test_role_based_access.sh --project your-project-id --device "model=Pixel3,version=30"
```

## 📈 Best Practices

### 1. Test Strategy
- **Daily**: Quick admin/user smoke tests (10 minutes)
- **Weekly**: Full role-based test suite (30 minutes)
- **Release**: Comprehensive role testing on multiple devices (1 hour)

### 2. Device Selection
- **Primary**: Pixel3 (stable, fast)
- **Secondary**: Pixel6 (latest Android)
- **Fallback**: Pixel2 (older Android support)

### 3. Cost Optimization
- Use `--no-record-video` for routine tests
- Test on single device for daily runs
- Use device matrix only for release testing

### 4. Data Management
- Clean up test data after major test runs
- Recreate test users monthly
- Monitor Firestore usage for test data

## 🎯 Quick Commands

```bash
# Complete setup and test
export FIREBASE_PROJECT_ID=your-project-id
node scripts/setup_test_users.js setup
flutter build apk --debug
./scripts/test_role_based_access.sh --project $FIREBASE_PROJECT_ID --type both

# Cleanup after testing
node scripts/setup_test_users.js cleanup

# View results
open https://console.firebase.google.com/project/$FIREBASE_PROJECT_ID/testlab/histories/
```

## 📚 Related Files

- `integration_test/test_flows/role_based_test.dart` - Main test file
- `scripts/test_role_based_access.sh` - Linux/Mac test script
- `scripts/test_role_based_access.bat` - Windows test script
- `scripts/setup_test_users.js` - User setup script
- `firebase_test_lab_guide.md` - General Firebase Test Lab guide

## 🔗 Resources

- [Firebase Test Lab Documentation](https://firebase.google.com/docs/test-lab)
- [Firebase Authentication Custom Claims](https://firebase.google.com/docs/auth/admin/custom-claims)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Flutter Integration Testing](https://docs.flutter.dev/testing/integration-tests)

---

**Happy Role-Based Testing! 🔐🧪**
