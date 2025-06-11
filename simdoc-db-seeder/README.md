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
   - Download file JSON dan rename menjadi `credentials.json`
   - Letakkan file `credentials.json` di root folder seeder ini

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

## Konfigurasi

Pastikan file `credentials.json` sudah ada dan berisi service account key dari Firebase Console.

## Catatan

- Seeder akan membuat data sample yang realistis
- Password default untuk semua user: `password123`
- Admin user: admin@simdoc.com
- Regular users: user1@simdoc.com, user2@simdoc.com, dst.
