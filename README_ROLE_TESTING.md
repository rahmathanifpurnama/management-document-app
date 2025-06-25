# 🔐 Role-Based Testing Setup

## 📁 Files Created

### Test Files
- `integration_test/test_flows/role_based_test.dart` - Integration test untuk admin vs user roles
- `ROLE_BASED_TESTING_GUIDE.md` - Panduan lengkap role-based testing

### Scripts
- `scripts/test_role_based_access.sh` - Linux/Mac script untuk menjalankan role tests
- `scripts/test_role_based_access.bat` - Windows batch script untuk role tests  
- `scripts/setup_test_users.js` - Node.js script untuk setup test users di Firebase

### Updated Files
- `firebase_test_lab_guide.md` - Updated dengan informasi role-based testing
- `pubspec.yaml` - Added `integration_test` dependency

## 🚀 Quick Start

### 1. Setup Test Users
```bash
# Set project ID
export FIREBASE_PROJECT_ID=your-project-id

# Install Node.js dependencies
npm install firebase-admin

# Create test users
node scripts/setup_test_users.js setup
```

### 2. Run Role-Based Tests
```bash
# Linux/Mac
./scripts/test_role_based_access.sh --project your-project-id --type both

# Windows
scripts\test_role_based_access.bat --project your-project-id --type both
```

## 👥 Test Users Created

### Admin User
- **Email**: `admin@test.com`
- **Password**: `admin123`
- **Role**: `admin`
- **Permissions**: `read`, `write`, `delete`, `manage_users`, `approve_documents`

### Regular User
- **Email**: `user@test.com`
- **Password**: `user123`
- **Role**: `user`
- **Permissions**: `read`, `write`

## 🧪 Test Coverage

### Admin Tests
- ✅ Login and access management features
- ✅ Document approval workflow
- ✅ Delete documents
- ✅ Manage categories
- ✅ User management access

### User Tests
- ✅ Login and basic features
- ✅ Document upload
- ✅ View documents
- ❌ Cannot access admin features
- ❌ Cannot delete documents
- ❌ Cannot approve documents

## 📊 Test Options

### Test Types
- `--type admin` - Test only admin functionality
- `--type user` - Test only user functionality  
- `--type both` - Test both roles (recommended)

### Additional Options
- `--record-video` - Record video during test
- `--device "model=Pixel6,version=33"` - Specify device
- `--timeout 45m` - Set custom timeout

## 🔧 Troubleshooting

### Common Issues
1. **Test users not found** → Run `node scripts/setup_test_users.js setup`
2. **Authentication errors** → Check `gcloud config get-value project`
3. **Permission errors** → Verify custom claims in Firebase Console
4. **APK build errors** → Run `flutter clean && flutter build apk --debug`

### Cleanup
```bash
# Remove all test data
node scripts/setup_test_users.js cleanup
```

## 📚 Documentation

- **Detailed Guide**: `ROLE_BASED_TESTING_GUIDE.md`
- **General Firebase Testing**: `firebase_test_lab_guide.md`
- **Integration Tests**: `README_TESTING.md`

## 🎯 Example Commands

```bash
# Complete workflow
export FIREBASE_PROJECT_ID=your-project-id
node scripts/setup_test_users.js setup
flutter build apk --debug
./scripts/test_role_based_access.sh --project $FIREBASE_PROJECT_ID --type both

# View results
open https://console.firebase.google.com/project/$FIREBASE_PROJECT_ID/testlab/histories/

# Cleanup
node scripts/setup_test_users.js cleanup
```

---

**Ready for role-based testing! 🔐✅**
