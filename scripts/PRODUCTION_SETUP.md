# Production Scripts Setup

Panduan lengkap untuk mengkonfigurasi semua scripts untuk production Firebase.

## 📋 Scripts yang Mendukung Production

Semua scripts berikut telah dikonfigurasi untuk mendukung production:

1. **`database-seeder.js`** - Database seeding untuk production
2. **`integration-test.js`** - Testing di production environment
3. **`setup-admin.js`** - Setup admin users di production
4. **`system-monitor.js`** - Monitoring sistem production
5. **`validate-rules.js`** - Validasi security rules production
6. **`firebase-config.js`** - Helper konfigurasi Firebase (shared)

## 📋 Prerequisites

1. Firebase project sudah dibuat
2. Node.js terinstall
3. Akses admin ke Firebase Console

## 🔑 Step 1: Mendapatkan Service Account Key

### 1.1 Buka Firebase Console
1. Kunjungi [Firebase Console](https://console.firebase.google.com/)
2. Pilih project `document-management-c5a96`

### 1.2 Generate Service Account Key
1. Klik ⚙️ **Project Settings**
2. Pilih tab **Service accounts**
3. Klik **Generate new private key**
4. Download file JSON (contoh: `document-management-c5a96-firebase-adminsdk-xxxxx.json`)

## 📁 Step 2: Setup Service Account Key

### Opsi 1: Menggunakan Folder Config (Recommended)
```bash
# Buat folder config
mkdir -p scripts/config

# Pindahkan service account key
mv ~/Downloads/document-management-c5a96-firebase-adminsdk-xxxxx.json scripts/config/service-account-key.json
```

### Opsi 2: Environment Variable
```bash
# Set environment variable
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/service-account-key.json"
```

### Opsi 3: Project Root
```bash
# Letakkan di root project dengan nama service-account-key.json
cp ~/Downloads/document-management-c5a96-firebase-adminsdk-xxxxx.json ./service-account-key.json
```

## 🔒 Step 3: Verifikasi Security

### 3.1 Pastikan .gitignore sudah benar
File `.gitignore` sudah dikonfigurasi untuk mengabaikan:
```
**/service-account-key.json
**/config/service-account-key.json
scripts/config/
firebase-adminsdk-*.json
```

### 3.2 Jangan commit service account key!
```bash
# Pastikan file tidak ter-track
git status
# Service account key tidak boleh muncul di list
```

## 🚀 Step 4: Menjalankan Scripts Production

### 4.1 Install Dependencies
```bash
npm install firebase-admin
```

### 4.2 Set Environment untuk Production
```bash
# Unset emulator environment
unset FIRESTORE_EMULATOR_HOST
unset NODE_ENV

# Atau set explicitly
export NODE_ENV=production
```

### 4.3 Menjalankan Scripts

**Database Seeder:**
```bash
cd scripts
node database-seeder.js
```

**Integration Tests:**
```bash
node integration-test.js
```

**Admin Setup:**
```bash
node setup-admin.js
```

**System Monitor:**
```bash
node system-monitor.js
```

**Rules Validation:**
```bash
node validate-rules.js
```

## ⚠️ Step 5: Permissions yang Diperlukan

Service account harus memiliki permissions berikut:
- **Firebase Admin SDK Admin Service Agent**
- **Cloud Datastore User** (untuk Firestore)
- **Firebase Authentication Admin**
- **Cloud Storage Admin** (jika menggunakan storage)

## 🔍 Troubleshooting

### Error: "Service account key not found"
- Pastikan file service account ada di salah satu lokasi yang didukung
- Periksa nama file harus `service-account-key.json`
- Periksa permissions file (readable)

### Error: "Failed to initialize Firebase"
- Pastikan service account key valid JSON
- Periksa project ID di service account key
- Pastikan service account memiliki permissions yang cukup

### Error: "Permission denied"
- Periksa IAM roles untuk service account
- Pastikan Firebase Admin SDK enabled
- Periksa Firestore rules

## 📊 Monitoring

Setelah seeding berhasil, verifikasi di Firebase Console:
1. **Authentication** - User accounts terbuat
2. **Firestore** - Collections dan documents terbuat
3. **Storage** - Bucket tersedia (jika diperlukan)

## 🔄 Rollback

Jika perlu rollback:
```bash
# Jalankan seeder dan pilih option 5 (Clear all data)
node database-seeder.js
# Pilih: 5. Clear all data
```

## 📝 Notes

- **JANGAN** jalankan seeder di production yang sudah ada data user
- Selalu backup data production sebelum seeding
- Test di staging environment terlebih dahulu
- Service account key adalah credential sensitif, jaga keamanannya
