# SIMDOC Database Structure

Dokumentasi struktur data yang akan di-seed ke Firebase Firestore.

## Collections Overview

### 1. Users Collection (`users`)
Menyimpan data pengguna sistem dan permissions mereka.

**Sample Data:**
- **Admin**: admin@simdoc.com (Full permissions)
- **Users**: user1@simdoc.com, user2@simdoc.com, user3@simdoc.com (Limited permissions)
- **Inactive User**: user4@simdoc.com (Inactive status)

**Fields:**
```javascript
{
  fullName: "string",
  email: "string", 
  role: "admin|user",
  status: "active|inactive",
  createdBy: "string|null",
  createdAt: "timestamp",
  lastLogin: "timestamp|null",
  profileImage: "string|null",
  permissions: {
    documents: ["view", "upload", "delete", "approve"],
    categories: ["categoryId1", "categoryId2"],
    system: ["user_management", "analytics"]
  }
}
```

### 2. Categories Collection (`categories`)
Menyimpan kategori dokumen yang tersedia dalam sistem.

**Sample Categories:**
- Surat Masuk
- Surat Keputusan  
- Notulen Rapat
- Laporan Evaluasi
- Surat Keluar
- Proposal Kegiatan
- Dokumen Keuangan
- Arsip Lama (Inactive)

**Fields:**
```javascript
{
  name: "string",
  description: "string",
  createdBy: "string",
  createdAt: "timestamp", 
  permissions: ["userId1", "userId2"],
  isActive: "boolean"
}
```

### 3. Documents Collection (`documents`)
Menyimpan metadata dokumen yang diupload ke sistem.

**Sample Documents:**
- PDF files (Surat, SK, Laporan)
- DOCX files (Notulen)
- XLSX files (Laporan Evaluasi)

**Status Distribution:**
- Approved: 5 documents
- Pending: 2 documents  
- Rejected: 1 document

**Fields:**
```javascript
{
  fileName: "string",
  fileSize: "number", // in bytes
  fileType: "string", // MIME type
  filePath: "string", // Firebase Storage path
  uploadedBy: "string", // userId
  uploadedAt: "timestamp",
  category: "string", // categoryId
  status: "pending|approved|rejected",
  approvedBy: "string|null", // userId
  approvedAt: "timestamp|null",
  permissions: ["userId1", "userId2"],
  metadata: {
    description: "string",
    tags: ["tag1", "tag2"]
  }
}
```


```

## Authentication Data

Firebase Authentication akan dibuat dengan data berikut:

| Email | Password | Role | Status |
|-------|----------|------|--------|
| admin@simdoc.com | password123 | admin | active |
| user1@simdoc.com | password123 | user | active |
| user2@simdoc.com | password123 | user | active |
| user3@simdoc.com | password123 | user | active |
| user4@simdoc.com | password123 | user | inactive |

## Permissions System

### Document Permissions
- `view`: Dapat melihat dokumen
- `upload`: Dapat mengupload dokumen
- `delete`: Dapat menghapus dokumen
- `approve`: Dapat menyetujui/menolak dokumen

### System Permissions  
- `user_management`: Dapat mengelola pengguna
- `analytics`: Dapat melihat analytics/laporan

### Category Permissions
Array berisi userId yang memiliki akses ke kategori tersebut.

## File Size Examples

| File Type | Size | Formatted |
|-----------|------|-----------|
| PDF Small | 245,760 bytes | 240 KB |
| PDF Medium | 512,000 bytes | 500 KB |
| DOCX | 128,000 bytes | 125 KB |
| XLSX | 1,048,576 bytes | 1 MB |
| PDF Large | 768,000 bytes | 750 KB |

## Timestamps

Semua timestamp menggunakan Firebase Timestamp format dan dibuat dengan variasi:
- 30 hari yang lalu (data awal)
- 1-15 hari yang lalu (aktivitas recent)
- Beberapa hari terakhir (aktivitas terbaru)
