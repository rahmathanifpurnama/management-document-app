const { db, COLLECTIONS, generateTimestamp, generateId } = require("./config");

// Sample document data with realistic file metadata
const documentsData = [
  {
    id: generateId(),
    fileName: "Laporan_Keuangan_Q1_2024.pdf",
    fileSize: 2048576, // 2MB
    fileType: "pdf",
    filePath: "documents/finance/Laporan_Keuangan_Q1_2024.pdf",
    uploadedBy: "admin-uid-001", // Will be replaced with actual admin UID
    uploadedAt: generateTimestamp(5), // 5 days ago
    category: "finance",
    permissions: ["admin-uid-001", "user1-uid-002"],
    isActive: true,
    metadata: {
      description: "Laporan keuangan triwulan pertama tahun 2024",
      tags: ["keuangan", "laporan", "Q1", "2024"],
      version: "1.0",
      contentType: "application/pdf",
      downloadUrl: null
    }
  },
  {
    id: generateId(),
    fileName: "Proposal_Proyek_Sistem_Informasi.docx",
    fileSize: 1536000, // 1.5MB
    fileType: "docx",
    filePath: "documents/projects/Proposal_Proyek_Sistem_Informasi.docx",
    uploadedBy: "user1-uid-002",
    uploadedAt: generateTimestamp(3), // 3 days ago
    category: "projects",
    permissions: ["user1-uid-002", "admin-uid-001"],
    isActive: true,
    metadata: {
      description: "Proposal pengembangan sistem informasi manajemen dokumen",
      tags: ["proposal", "sistem informasi", "proyek", "pengembangan"],
      version: "2.1",
      contentType: "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
      downloadUrl: null
    }
  },
  {
    id: generateId(),
    fileName: "Panduan_Penggunaan_Aplikasi.pdf",
    fileSize: 3145728, // 3MB
    fileType: "pdf",
    filePath: "documents/documentation/Panduan_Penggunaan_Aplikasi.pdf",
    uploadedBy: "user2-uid-003",
    uploadedAt: generateTimestamp(2), // 2 days ago
    category: "documentation",
    permissions: ["user2-uid-003", "admin-uid-001", "user1-uid-002"],
    isActive: true,
    metadata: {
      description: "Panduan lengkap penggunaan aplikasi manajemen dokumen",
      tags: ["panduan", "dokumentasi", "tutorial", "aplikasi"],
      version: "1.5",
      contentType: "application/pdf",
      downloadUrl: null
    }
  },
  {
    id: generateId(),
    fileName: "Surat_Keputusan_001_2024.pdf",
    fileSize: 512000, // 512KB
    fileType: "pdf",
    filePath: "documents/legal/Surat_Keputusan_001_2024.pdf",
    uploadedBy: "admin-uid-001",
    uploadedAt: generateTimestamp(1), // 1 day ago
    category: "legal",
    permissions: ["admin-uid-001"],
    isActive: true,
    metadata: {
      description: "Surat keputusan nomor 001 tahun 2024 tentang kebijakan baru",
      tags: ["surat keputusan", "legal", "kebijakan", "2024"],
      version: "1.0",
      contentType: "application/pdf",
      downloadUrl: null
    }
  },
  {
    id: generateId(),
    fileName: "Data_Karyawan_2024.xlsx",
    fileSize: 1024000, // 1MB
    fileType: "xlsx",
    filePath: "documents/hr/Data_Karyawan_2024.xlsx",
    uploadedBy: "user3-uid-004",
    uploadedAt: generateTimestamp(0), // Today
    category: "hr",
    permissions: ["user3-uid-004", "admin-uid-001"],
    isActive: true,
    metadata: {
      description: "Database karyawan tahun 2024 dengan informasi lengkap",
      tags: ["karyawan", "hr", "database", "2024"],
      version: "1.0",
      contentType: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      downloadUrl: null
    }
  },
  {
    id: generateId(),
    fileName: "Rencana_Strategis_2024-2026.pptx",
    fileSize: 4194304, // 4MB
    fileType: "pptx",
    filePath: "documents/strategy/Rencana_Strategis_2024-2026.pptx",
    uploadedBy: "admin-uid-001",
    uploadedAt: generateTimestamp(7), // 1 week ago
    category: "strategy",
    permissions: ["admin-uid-001", "user1-uid-002", "user2-uid-003"],
    isActive: true,
    metadata: {
      description: "Rencana strategis organisasi untuk periode 2024-2026",
      tags: ["rencana strategis", "strategi", "planning", "2024-2026"],
      version: "3.0",
      contentType: "application/vnd.openxmlformats-officedocument.presentationml.presentation",
      downloadUrl: null
    }
  },
  {
    id: generateId(),
    fileName: "Kontrak_Vendor_ABC_Corp.pdf",
    fileSize: 768000, // 768KB
    fileType: "pdf",
    filePath: "documents/contracts/Kontrak_Vendor_ABC_Corp.pdf",
    uploadedBy: "user1-uid-002",
    uploadedAt: generateTimestamp(10), // 10 days ago
    category: "contracts",
    permissions: ["user1-uid-002", "admin-uid-001"],
    isActive: true,
    metadata: {
      description: "Kontrak kerjasama dengan vendor ABC Corporation",
      tags: ["kontrak", "vendor", "kerjasama", "ABC Corp"],
      version: "1.0",
      contentType: "application/pdf",
      downloadUrl: null
    }
  },
  {
    id: generateId(),
    fileName: "Manual_Teknis_Server.pdf",
    fileSize: 2560000, // 2.5MB
    fileType: "pdf",
    filePath: "documents/technical/Manual_Teknis_Server.pdf",
    uploadedBy: "user2-uid-003",
    uploadedAt: generateTimestamp(14), // 2 weeks ago
    category: "technical",
    permissions: ["user2-uid-003", "admin-uid-001"],
    isActive: true,
    metadata: {
      description: "Manual teknis konfigurasi dan maintenance server",
      tags: ["manual", "teknis", "server", "maintenance"],
      version: "2.0",
      contentType: "application/pdf",
      downloadUrl: null
    }
  },
  {
    id: generateId(),
    fileName: "Arsip_Dokumen_Lama.pdf",
    fileSize: 1280000, // 1.25MB
    fileType: "pdf",
    filePath: "documents/archive/Arsip_Dokumen_Lama.pdf",
    uploadedBy: "admin-uid-001",
    uploadedAt: generateTimestamp(30), // 1 month ago
    category: "archive",
    permissions: ["admin-uid-001"],
    isActive: false, // Inactive document for testing
    metadata: {
      description: "Arsip dokumen lama yang sudah tidak aktif",
      tags: ["arsip", "lama", "inactive"],
      version: "1.0",
      contentType: "application/pdf",
      downloadUrl: null
    }
  },
  {
    id: generateId(),
    fileName: "Backup_Database_2024.sql",
    fileSize: 10485760, // 10MB
    fileType: "sql",
    filePath: "documents/backup/Backup_Database_2024.sql",
    uploadedBy: "user2-uid-003",
    uploadedAt: generateTimestamp(1), // Yesterday
    category: "backup",
    permissions: ["user2-uid-003", "admin-uid-001"],
    isActive: true,
    metadata: {
      description: "File backup database sistem tahun 2024",
      tags: ["backup", "database", "sql", "2024"],
      version: "1.0",
      contentType: "application/sql",
      downloadUrl: null
    }
  }
];

async function seedDocuments() {
  console.log("🚀 Starting documents seeding...");

  try {
    // Get actual user UIDs from users collection
    const usersSnapshot = await db.collection(COLLECTIONS.USERS).get();
    const userMap = {};

    usersSnapshot.docs.forEach(doc => {
      const userData = doc.data();
      if (userData.email === 'admin@simdoc.com') {
        userMap['admin-uid-001'] = doc.id;
      } else if (userData.email === 'user1@simdoc.com') {
        userMap['user1-uid-002'] = doc.id;
      } else if (userData.email === 'user2@simdoc.com') {
        userMap['user2-uid-003'] = doc.id;
      } else if (userData.email === 'user3@simdoc.com') {
        userMap['user3-uid-004'] = doc.id;
      }
    });

    console.log("📋 Found users:", Object.keys(userMap).length);

    const batch = db.batch();

    for (const document of documentsData) {
      const docRef = db.collection(COLLECTIONS.DOCUMENTS).doc(document.id);
      const { id, ...docData } = document;

      // Replace placeholder UIDs with actual UIDs
      if (userMap[docData.uploadedBy]) {
        docData.uploadedBy = userMap[docData.uploadedBy];
      }

      // Replace placeholder UIDs in permissions array
      docData.permissions = docData.permissions.map(uid =>
        userMap[uid] || uid
      );

      batch.set(docRef, docData);
    }

    await batch.commit();
    console.log("✅ Documents collection seeded successfully!");
    console.log(`📊 Total documents created: ${documentsData.length}`);

    // Display documents summary by category and status
    const categoryCount = documentsData.reduce((acc, doc) => {
      acc[doc.category] = (acc[doc.category] || 0) + 1;
      return acc;
    }, {});

    const activeCount = documentsData.filter(doc => doc.isActive).length;
    const inactiveCount = documentsData.filter(doc => !doc.isActive).length;

    console.log("\n📋 Documents Summary:");
    console.log(`  ✅ Active documents: ${activeCount}`);
    console.log(`  ❌ Inactive documents: ${inactiveCount}`);

    console.log("\n📂 Documents by Category:");
    Object.entries(categoryCount).forEach(([category, count]) => {
      console.log(`  📁 ${category}: ${count} documents`);
    });

    console.log("\n📄 Sample Documents Created:");
    documentsData.slice(0, 3).forEach(doc => {
      console.log(`  📄 ${doc.fileName} (${doc.category})`);
    });

  } catch (error) {
    console.error("❌ Error seeding documents:", error);
    throw error;
  }
}

// Run if called directly
if (require.main === module) {
  seedDocuments()
    .then(() => {
      console.log("🎉 Documents seeding completed!");
      process.exit(0);
    })
    .catch((error) => {
      console.error("💥 Documents seeding failed:", error);
      process.exit(1);
    });
}

module.exports = { seedDocuments, documentsData };
