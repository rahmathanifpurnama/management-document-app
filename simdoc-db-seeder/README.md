# SIMDOC Database Seeder

Seeder untuk database Firebase Firestore aplikasi SIMDOC.

## Instalasi

1. Masuk ke folder seeder:
   ```bash
   cd simdoc-db-seeder
   ```

2. Install dependensi:
   ```bash
   npm install
   ```

3. Setup Firebase Service Account:
   - Buka [Firebase Console](https://console.firebase.google.com/)
   - Pilih project SIMDOC Anda
   - Masuk ke **Project Settings** (ikon gear)
   - Pilih tab **Service Accounts**
   - Klik **Generate New Private Key**
   - Download file JSON dan rename menjadi `service-account-key.json`
   - Letakkan file `service-account-key.json` di root folder seeder ini

   **PENTING**: File harus bernama `service-account-key.json` (bukan `credentials.json`)

4. Pastikan Firebase Authentication dan Firestore sudah diaktifkan di Firebase Console

## Penggunaan

### 1. Test Koneksi Firebase
Sebelum menjalankan seeder, test koneksi terlebih dahulu:
```bash
npm test
# atau
node test-connection.js
```

### 2. Jalankan Seeder

**Opsi 1: Jalankan semua seeder sekaligus (Recommended)**
```bash
npm run seed:all
# atau
node seed-all.js
```

**Opsi 2: Jalankan seeder individual**
```bash
npm run seed:users      # Seed users collection dan authentication
npm run seed:categories # Seed categories collection
npm run seed:documents  # Seed documents collection
```

**Opsi 3: Menggunakan file batch (Windows)**
```bash
# Install dependencies
install.bat

# Run seeder
run-seeder.bat
```

### 3. Verifikasi Data
Untuk memverifikasi data yang telah di-seed:
```bash
npm run verify
# atau
node verify-data.js
```

### 4. Cleanup Database (Opsional)
Untuk menghapus semua data yang telah di-seed:
```bash
npm run cleanup
# atau
node cleanup.js
```

## Struktur Data

### Users Collection
- Admin users dengan permissions lengkap
- Regular users dengan permissions terbatas
- Authentication data untuk Firebase Auth

### Categories Collection
- Kategori default: Surat Masuk, Surat Keputusan, Notulen Rapat, Laporan Evaluasi
- Permissions dan status aktif

### Documents Collection
- Sample documents untuk setiap kategori
- Metadata dan file information
- Status approval dan permissions

### Activities Collection
- Log aktivitas user
- Tracking untuk audit trail
- Berbagai jenis aktivitas sistem

## Quick Start (Recommended)

### 🚀 One-Command Fix for All Issues
```bash
cd simdoc-db-seeder
node fix-all-issues.js
```

This script will:
1. ✅ Verify activities.js timestamp fix is applied
2. 🔍 Check Firebase Authentication permissions
3. 🔧 Provide step-by-step instructions for permission fixes
4. 🚀 Run complete database seeding when ready

### 🔍 Check Permissions Only
```bash
node verify-permissions.js
```

## Troubleshooting

### ✅ Issue 1: Activities Seeding Timestamp Error (FIXED)
**Error:** `TypeError: Cannot read properties of undefined (reading 'Timestamp')`
**Status:** FIXED - Variable name conflict resolved in activities.js

### 🔧 Issue 2: Firebase Authentication Permission Error
**Error:**
```
❌ Error creating auth user: Caller does not have required permission to use project document-management-c5a96.
Grant the caller the roles/serviceusage.serviceUsageConsumer role
```

**Quick Fix:**
1. Open [Google Cloud Console IAM](https://console.developers.google.com/iam-admin/iam/project?project=document-management-c5a96)
2. Find: `firebase-adminsdk-fbsvc@document-management-c5a96.iam.gserviceaccount.com`
3. Click ✏️ (edit) → "ADD ANOTHER ROLE"
4. Add: **Service Usage Consumer**
5. Save and wait 2-3 minutes
6. Re-run: `node fix-all-issues.js`

### Error Authentication
Jika muncul error seperti:
- `Error fetching access token`
- `getaddrinfo ENOTFOUND metadata.google.internal`
- `Could not load the default credentials`

**Solusi**: Pastikan file `service-account-key.json` sudah ada di folder ini.

### Error Permission
Jika muncul error permission:
1. Pastikan service account memiliki role:
   - Firebase Admin SDK Administrator Service Agent
   - Cloud Datastore User
   - Firebase Authentication Admin
   - **Service Usage Consumer** ← CRITICAL

## Konfigurasi

Pastikan file `service-account-key.json` sudah ada dan berisi service account key dari Firebase Console.

## Catatan

- Seeder akan membuat data sample yang realistis
- Password default untuk semua user: `password123`
- Admin user: admin@simdoc.com
- Regular users: user1@simdoc.com, user2@simdoc.com, dst.
