# 🔥 Firebase Test Lab - Panduan Lengkap

## 📋 **Daftar Isi**
1. [Setup Awal](#setup-awal)
2. [Persiapan Project](#persiapan-project)
3. [Menjalankan Test Sederhana](#menjalankan-test-sederhana)
4. [Menjalankan Test Komprehensif](#menjalankan-test-komprehensif)
5. [Manual Testing](#manual-testing)
6. [Melihat Hasil Test](#melihat-hasil-test)
7. [Troubleshooting](#troubleshooting)

---

## 🚀 **Setup Awal**

### **1. Install Firebase CLI**

**Windows:**
```cmd
npm install -g firebase-tools
```

**Linux/macOS:**
```bash
npm install -g firebase-tools
# atau
curl -sL https://firebase.tools | bash
```

### **2. Login ke Firebase**
```bash
firebase login
```

### **3. Setup Project Firebase**
```bash
# Ganti dengan project ID Anda
firebase use your-project-id

# Atau set environment variable
export FIREBASE_PROJECT_ID=your-project-id  # Linux/macOS
set FIREBASE_PROJECT_ID=your-project-id     # Windows
```

### **4. Verifikasi Setup**
```bash
gcloud auth list
gcloud config get-value project
```

---

## 📱 **Persiapan Project**

### **1. Navigate ke Project Directory**
```bash
cd /path/to/your/flutter/project
```

### **2. Clean dan Build Project**
```bash
flutter clean
flutter pub get
flutter build apk --debug
```

### **3. Verifikasi APK**
```bash
# Pastikan file ini ada
ls -la build/app/outputs/flutter-apk/app-debug.apk
```

---

## 🧪 **Menjalankan Test Sederhana**

### **Script Sederhana (Recommended untuk Pemula)**

**Linux/macOS:**
```bash
./scripts/firebase_simple_test.sh --project your-project-id
```

**Windows:**
```cmd
scripts\firebase_simple_test.bat --project your-project-id
```

### **Contoh dengan Device Spesifik:**
```bash
# Test di Pixel 6
./scripts/firebase_simple_test.sh --project your-project-id --device "model=Pixel6,version=33,locale=en,orientation=portrait"

# Test di Samsung Galaxy J7
./scripts/firebase_simple_test.sh --project your-project-id --device "model=j7xelte,version=23,locale=en,orientation=portrait"

# Test di Tablet
./scripts/firebase_simple_test.sh --project your-project-id --device "model=Nexus9,version=25,locale=en,orientation=landscape"
```

### **Test dengan Timeout Khusus:**
```bash
./scripts/firebase_simple_test.sh --project your-project-id --timeout 30m
```

---

## 🎯 **Menjalankan Test Komprehensif**

### **Batch Testing (Multiple Devices)**
```bash
./scripts/firebase_batch_test.sh --project your-project-id
```

### **Test Suite Spesifik:**
```bash
# Smoke tests (cepat)
./scripts/firebase_test_runner.sh --project your-project-id --suite smoke

# Performance tests
./scripts/firebase_test_runner.sh --project your-project-id --suite performance

# Compatibility tests
./scripts/firebase_test_runner.sh --project your-project-id --suite compatibility
```

### **Device Matrix Spesifik:**
```bash
# Popular devices
./scripts/firebase_test_runner.sh --project your-project-id --devices popular

# Low-end devices
./scripts/firebase_test_runner.sh --project your-project-id --devices low-end

# High-end devices
./scripts/firebase_test_runner.sh --project your-project-id --devices high-end

# Tablet devices
./scripts/firebase_test_runner.sh --project your-project-id --devices tablets
```

---

## ⚙️ **Manual Testing (Advanced)**

### **Single Device Test:**
```bash
gcloud firebase test android run \
  --type robo \
  --app build/app/outputs/flutter-apk/app-debug.apk \
  --device model=Pixel3,version=30,locale=en,orientation=portrait \
  --timeout 20m \
  --robo-directives login_username=admin@test.com,login_password=admin123 \
  --results-bucket=gs://your-project-test-results \
  --results-dir=manual-test-$(date +%Y%m%d-%H%M%S)
```

### **Multiple Device Test:**
```bash
gcloud firebase test android run \
  --type robo \
  --app build/app/outputs/flutter-apk/app-debug.apk \
  --device model=Pixel2,version=28,locale=en,orientation=portrait \
  --device model=Pixel3,version=30,locale=en,orientation=portrait \
  --device model=Pixel6,version=33,locale=en,orientation=portrait \
  --timeout 25m \
  --results-bucket=gs://your-project-test-results \
  --results-dir=multi-device-test-$(date +%Y%m%d-%H%M%S)
```

### **Test dengan Video Recording:**
```bash
gcloud firebase test android run \
  --type robo \
  --app build/app/outputs/flutter-apk/app-debug.apk \
  --device model=Pixel3,version=30,locale=en,orientation=portrait \
  --timeout 20m \
  --record-video \
  --results-bucket=gs://your-project-test-results \
  --results-dir=video-test-$(date +%Y%m%d-%H%M%S)
```

---

## 📊 **Melihat Hasil Test**

### **1. Firebase Console**
Buka: `https://console.firebase.google.com/project/YOUR_PROJECT_ID/testlab/histories/`

### **2. Download Results**
```bash
# Download semua hasil test
gsutil -m cp -r gs://your-project-test-results/* ./test-results/
```

### **3. Generate Report**
```bash
python3 scripts/test_report_generator.py --reports-dir ./test-results --output-dir ./reports
```

---

## 🔐 **Test Role-Based Access**

### **1. Test Admin User Access**

```bash
# Test admin login dan fitur management
gcloud firebase test android run \
  --type instrumentation \
  --app build/app/outputs/flutter-apk/app-debug.apk \
  --test build/app/outputs/flutter-apk/app-debug-androidTest.apk \
  --device model=Pixel3,version=30,locale=en,orientation=portrait \
  --timeout 30m \
  --environment-variables TEST_USER_EMAIL=admin@test.com,TEST_USER_PASSWORD=admin123,TEST_USER_ROLE=admin \
  --test-targets "class com.example.AdminAccessTest" \
  --results-bucket=gs://your-project-test-results \
  --results-dir=admin-test-$(date +%Y%m%d-%H%M%S)
```

### **2. Test Regular User Access**

```bash
# Test user login dan restrictions
gcloud firebase test android run \
  --type instrumentation \
  --app build/app/outputs/flutter-apk/app-debug.apk \
  --test build/app/outputs/flutter-apk/app-debug-androidTest.apk \
  --device model=Pixel3,version=30,locale=en,orientation=portrait \
  --timeout 30m \
  --environment-variables TEST_USER_EMAIL=user@test.com,TEST_USER_PASSWORD=user123,TEST_USER_ROLE=user \
  --test-targets "class com.example.UserAccessTest" \
  --results-bucket=gs://your-project-test-results \
  --results-dir=user-test-$(date +%Y%m%d-%H%M%S)
```

### **3. Test Both Roles (Sequential)**

```bash
# Script untuk test kedua role secara berurutan
./scripts/test_both_roles.sh --project your-project-id --device "model=Pixel3,version=30"
```

**Contoh script `test_both_roles.sh`:**
```bash
#!/bin/bash

PROJECT_ID=$1
DEVICE=$2

echo "🔐 Testing Admin Access..."
gcloud firebase test android run \
  --type instrumentation \
  --app build/app/outputs/flutter-apk/app-debug.apk \
  --test build/app/outputs/flutter-apk/app-debug-androidTest.apk \
  --device $DEVICE \
  --timeout 20m \
  --environment-variables TEST_USER_EMAIL=admin@test.com,TEST_USER_PASSWORD=admin123,TEST_USER_ROLE=admin \
  --results-bucket=gs://$PROJECT_ID-test-results \
  --results-dir=admin-test-$(date +%Y%m%d-%H%M%S)

echo "👤 Testing User Access..."
gcloud firebase test android run \
  --type instrumentation \
  --app build/app/outputs/flutter-apk/app-debug.apk \
  --test build/app/outputs/flutter-apk/app-debug-androidTest.apk \
  --device $DEVICE \
  --timeout 20m \
  --environment-variables TEST_USER_EMAIL=user@test.com,TEST_USER_PASSWORD=user123,TEST_USER_ROLE=user \
  --results-bucket=gs://$PROJECT_ID-test-results \
  --results-dir=user-test-$(date +%Y%m%d-%H%M%S)

echo "✅ Role-based testing completed!"
```

### **4. Test Matrix untuk Multiple Roles**

```bash
# Test admin di multiple devices
gcloud firebase test android run \
  --type instrumentation \
  --app build/app/outputs/flutter-apk/app-debug.apk \
  --test build/app/outputs/flutter-apk/app-debug-androidTest.apk \
  --device model=Pixel2,version=28,locale=en,orientation=portrait \
  --device model=Pixel3,version=30,locale=en,orientation=portrait \
  --device model=Pixel6,version=33,locale=en,orientation=portrait \
  --timeout 45m \
  --environment-variables TEST_USER_EMAIL=admin@test.com,TEST_USER_PASSWORD=admin123,TEST_USER_ROLE=admin \
  --results-bucket=gs://your-project-test-results \
  --results-dir=admin-matrix-test-$(date +%Y%m%d-%H%M%S)

# Test user di multiple devices
gcloud firebase test android run \
  --type instrumentation \
  --app build/app/outputs/flutter-apk/app-debug.apk \
  --test build/app/outputs/flutter-apk/app-debug-androidTest.apk \
  --device model=Pixel2,version=28,locale=en,orientation=portrait \
  --device model=Pixel3,version=30,locale=en,orientation=portrait \
  --device model=Pixel6,version=33,locale=en,orientation=portrait \
  --timeout 45m \
  --environment-variables TEST_USER_EMAIL=user@test.com,TEST_USER_PASSWORD=user123,TEST_USER_ROLE=user \
  --results-bucket=gs://your-project-test-results \
  --results-dir=user-matrix-test-$(date +%Y%m%d-%H%M%S)
```

### **5. Robo Test dengan Login Credentials**

```bash
# Robo test untuk admin
gcloud firebase test android run \
  --type robo \
  --app build/app/outputs/flutter-apk/app-debug.apk \
  --device model=Pixel3,version=30,locale=en,orientation=portrait \
  --timeout 20m \
  --robo-directives login_username=admin@test.com,login_password=admin123 \
  --results-bucket=gs://your-project-test-results \
  --results-dir=robo-admin-test-$(date +%Y%m%d-%H%M%S)

# Robo test untuk user
gcloud firebase test android run \
  --type robo \
  --app build/app/outputs/flutter-apk/app-debug.apk \
  --device model=Pixel3,version=30,locale=en,orientation=portrait \
  --timeout 20m \
  --robo-directives login_username=user@test.com,login_password=user123 \
  --results-bucket=gs://your-project-test-results \
  --results-dir=robo-user-test-$(date +%Y%m%d-%H%M%S)
```

---

## 📱 **Device Matrix yang Tersedia**

### **Popular Devices:**
```bash
# Google Pixel Series
model=Pixel2,version=28,locale=en,orientation=portrait    # Android 9.0
model=Pixel3,version=30,locale=en,orientation=portrait    # Android 11.0
model=Pixel4,version=31,locale=en,orientation=portrait    # Android 12.0
model=Pixel6,version=33,locale=en,orientation=portrait    # Android 13.0

# Samsung
model=j7xelte,version=23,locale=en,orientation=portrait   # Galaxy J7, Android 6.0
```

### **Performance Testing Devices:**
```bash
# Low-end
model=NexusLowRes,version=25,locale=en,orientation=portrait
model=MediumPhone.arm,version=30,locale=en,orientation=portrait

# High-end
model=Pixel6,version=33,locale=en,orientation=portrait
model=oriole,version=33,locale=en,orientation=portrait    # Pixel 6 Pro
```

### **Tablet Devices:**
```bash
model=Nexus9,version=25,locale=en,orientation=landscape   # Landscape
model=Nexus9,version=25,locale=en,orientation=portrait    # Portrait
```

### **Android Version Coverage:**
```bash
model=Nexus6,version=23,locale=en,orientation=portrait     # Android 6.0 (API 23)
model=NexusLowRes,version=25,locale=en,orientation=portrait # Android 7.1 (API 25)
model=Pixel2,version=28,locale=en,orientation=portrait     # Android 9.0 (API 28)
model=Pixel3,version=30,locale=en,orientation=portrait     # Android 11.0 (API 30)
model=Pixel4,version=31,locale=en,orientation=portrait     # Android 12.0 (API 31)
model=Pixel6,version=33,locale=en,orientation=portrait     # Android 13.0 (API 33)
```

---

## 🔧 **Troubleshooting**

### **Common Issues:**

#### **1. Authentication Error**
```bash
# Solution:
gcloud auth login
gcloud config set project your-project-id
```

#### **2. APK Build Failed**
```bash
# Solution:
flutter clean
flutter pub get
flutter build apk --debug --verbose
```

#### **3. Device Not Available**
```bash
# Check available devices:
gcloud firebase test android models list

# Use alternative device:
./scripts/firebase_simple_test.sh --project your-project-id --device "model=Pixel2,version=28,locale=en,orientation=portrait"
```

#### **4. Test Timeout**
```bash
# Increase timeout:
./scripts/firebase_simple_test.sh --project your-project-id --timeout 30m
```

#### **5. Results Bucket Error**
```bash
# Create bucket manually:
gsutil mb gs://your-project-test-results
```

### **Debug Mode:**
```bash
# Run with verbose output:
gcloud firebase test android run --help
gcloud firebase test android models list --filter="form=PHYSICAL"
```

---

## 📈 **Best Practices**

### **1. Test Strategy:**
- **Smoke Tests**: Quick validation (5-10 minutes)
- **Compatibility Tests**: Multiple Android versions (20-30 minutes)
- **Performance Tests**: Memory and speed (30-45 minutes)
- **Comprehensive Tests**: Full device matrix (1-2 hours)

### **2. Device Selection:**
- **Start with**: Pixel 3 (most stable)
- **Add**: Pixel 6 (latest Android)
- **Include**: Samsung J7 (older Android)
- **Test tablets**: Nexus 9 (landscape mode)

### **3. Test Frequency:**
- **Daily**: Smoke tests
- **Weekly**: Compatibility tests
- **Release**: Comprehensive tests

### **4. Cost Optimization:**
- Use `--no-record-video` untuk test rutin
- Limit parallel executions
- Use shorter timeouts untuk smoke tests

---

## 🎯 **Quick Commands Cheat Sheet**

```bash
# Setup
export FIREBASE_PROJECT_ID=your-project-id
firebase use your-project-id

# Build
flutter clean && flutter pub get && flutter build apk --debug

# Simple test
./scripts/firebase_simple_test.sh --project your-project-id

# Specific device
./scripts/firebase_simple_test.sh --project your-project-id --device "model=Pixel6,version=33,locale=en,orientation=portrait"

# Batch test
./scripts/firebase_batch_test.sh --project your-project-id

# View results
open https://console.firebase.google.com/project/your-project-id/testlab/histories/

# Download results
gsutil -m cp -r gs://your-project-test-results/* ./test-results/
```

---

## 🆘 **Support**

Jika mengalami masalah:

1. **Check Prerequisites**: Flutter, Firebase CLI, Authentication
2. **Verify APK**: Pastikan APK ter-build dengan benar
3. **Check Device**: Pastikan device tersedia di Test Lab
4. **Review Logs**: Lihat output gcloud command
5. **Firebase Console**: Check detailed error messages

**Firebase Test Lab Documentation**: https://firebase.google.com/docs/test-lab

---

## 🔐 **Role-Based Testing Quick Start**

### **Setup Test Users:**
```bash
# Install dependencies
npm install firebase-admin

# Set environment variable
export FIREBASE_PROJECT_ID=your-project-id

# Create test users and data
node scripts/setup_test_users.js setup
```

### **Run Role-Based Tests:**
```bash
# Test both admin and user roles
./scripts/test_role_based_access.sh --project your-project-id --type both

# Test only admin role
./scripts/test_role_based_access.sh --project your-project-id --type admin

# Test only user role
./scripts/test_role_based_access.sh --project your-project-id --type user

# Test with video recording
./scripts/test_role_based_access.sh --project your-project-id --type both --record-video
```

### **Windows Users:**
```cmd
REM Use batch script instead
scripts\test_role_based_access.bat --project your-project-id --type both
```

### **Cleanup Test Data:**
```bash
# Remove all test users and data
node scripts/setup_test_users.js cleanup
```

---

**Happy Testing! 🧪🔥**
