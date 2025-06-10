# Upload Limits Documentation

## Batasan Upload File di Aplikasi Management Document

### **Batasan yang Diterapkan**

#### 1. **Ukuran File Individual**
- **Maksimal 15MB** per file
- **Validasi lokal: 10MB** (untuk validasi awal sebelum upload)
- **Tipe file yang didukung:**
  - Dokumen: PDF, DOC, DOCX, TXT
  - Spreadsheet: XLS, XLSX  
  - Presentasi: PPTX
  - Gambar: JPG, JPEG, PNG

#### 2. **Jumlah File per Upload Session**
- **Maksimal 20 file** dapat dipilih sekaligus
- **Total ukuran maksimal: 200MB** untuk semua file yang dipilih

#### 3. **Upload Bersamaan (Concurrent)**
- **Maksimal 3 file** dapat diupload secara bersamaan
- File lainnya akan menunggu dalam antrian

#### 4. **Rate Limiting (Backend)**
- **Maksimal 30 request per menit** per user
- Mencegah spam dan abuse

#### 5. **Timeout**
- **Upload timeout: 5 menit** per file
- **Cloud Functions timeout: 3 menit**

### **Validasi yang Dilakukan**

#### 1. **Validasi Awal (Client-side)**
- Jumlah file tidak melebihi 20
- Total ukuran tidak melebihi 200MB
- Ukuran individual file tidak melebihi 15MB
- Ekstensi file sesuai dengan yang diizinkan

#### 2. **Validasi Keamanan**
- Validasi MIME type
- Pemeriksaan konten file
- Deteksi file berbahaya

#### 3. **Validasi Backend**
- Double-check ukuran file
- Validasi metadata
- Pemeriksaan duplikasi

### **Pesan Error**

| Error | Pesan |
|-------|-------|
| File terlalu besar | "File terlalu besar (maksimal 15MB)" |
| Terlalu banyak file | "Terlalu banyak file (maksimal 20 file per upload)" |
| Total ukuran terlalu besar | "Total ukuran file terlalu besar (maksimal 200MB)" |
| Ekstensi tidak didukung | "Jenis file tidak didukung" |
| Upload timeout | "Upload timeout - coba file yang lebih kecil" |

### **Rekomendasi untuk User**

#### **Untuk Upload Optimal:**
1. **Pilih maksimal 10-15 file** per session untuk performa terbaik
2. **Kompres file besar** sebelum upload jika memungkinkan
3. **Upload file dalam batch kecil** jika memiliki banyak file
4. **Pastikan koneksi internet stabil** untuk file besar

#### **Jika Mengalami Error:**
1. **Kurangi jumlah file** yang dipilih
2. **Kompres atau bagi file besar** menjadi beberapa bagian
3. **Coba upload ulang** jika terjadi timeout
4. **Periksa format file** yang didukung

### **Implementasi Teknis**

#### **File Konfigurasi:**
- `lib/core/config/upload_config.dart` - Konfigurasi utama upload
- `lib/core/config/file_config.dart` - Konfigurasi file yang didukung
- `functions/src/modules/fileUpload.ts` - Validasi backend

#### **Validasi UI:**
- `lib/widgets/upload/upload_zone_widget.dart` - Validasi saat pemilihan file
- `lib/services/file_validation_service.dart` - Service validasi file

### **Monitoring dan Logging**

#### **Metrics yang Dipantau:**
- Jumlah file yang diupload per user
- Ukuran total upload per session
- Rate limiting violations
- Upload success/failure rate

#### **Logging:**
- File yang ditolak karena ukuran
- File yang ditolak karena ekstensi
- Timeout events
- Rate limiting events

### **Pertimbangan Performa**

#### **Memory Usage:**
- Validasi file dilakukan secara streaming
- Tidak memuat seluruh file ke memory sekaligus
- Batch processing untuk multiple files

#### **Network Optimization:**
- Concurrent upload terbatas untuk menghindari network congestion
- Retry mechanism untuk upload yang gagal
- Progress tracking untuk user experience

### **Future Improvements**

#### **Planned Enhancements:**
1. **Dynamic file size limits** berdasarkan user tier
2. **Intelligent file compression** otomatis
3. **Resume upload** untuk file besar yang terputus
4. **Bulk upload optimization** untuk banyak file kecil
5. **Cloud storage quota management** per user

#### **Monitoring Improvements:**
1. **Real-time upload analytics**
2. **User upload behavior tracking**
3. **Automatic limit adjustment** berdasarkan server load
4. **Predictive upload failure prevention**
