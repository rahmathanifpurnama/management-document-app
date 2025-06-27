import 'dart:async';
import 'package:flutter/material.dart';
import '../core/services/firebase_service.dart';
import 'enhanced_firebase_storage_service.dart';

/// Diagnostic service to analyze data inconsistencies between Firebase Storage and Firestore
class StorageFirestoreDiagnosticService {
  static final StorageFirestoreDiagnosticService _instance =
      StorageFirestoreDiagnosticService._internal();
  factory StorageFirestoreDiagnosticService() => _instance;
  StorageFirestoreDiagnosticService._internal();

  static StorageFirestoreDiagnosticService get instance => _instance;

  final FirebaseService _firebaseService = FirebaseService.instance;
  final EnhancedFirebaseStorageService _storageService =
      EnhancedFirebaseStorageService.instance;

  /// Comprehensive data consistency analysis
  Future<DataConsistencyReport> analyzeDataConsistency() async {
    debugPrint('🔍 Starting comprehensive data consistency analysis...');

    try {
      // Try Cloud Function first for better performance
      try {
        debugPrint('🌐 Attempting analysis via Cloud Function...');
        final callable = _firebaseService.functions.httpsCallable(
          'analyzeDataConsistency',
        );
        final result = await callable.call().timeout(
          const Duration(seconds: 30),
        );

        final data = Map<String, dynamic>.from(result.data);
        final report = DataConsistencyReport.fromCloudFunction(data);

        debugPrint('✅ Cloud Function analysis completed');
        return report;
      } catch (cloudError) {
        debugPrint(
          '⚠️ Cloud Function failed, falling back to local analysis: $cloudError',
        );
      }

      // Fallback to local analysis
      debugPrint('🔄 Performing local data consistency analysis...');

      // Get data from both sources in parallel
      final results = await Future.wait([
        _getFirestoreMetadata(),
        _getStorageFiles(),
      ]);

      final firestoreData = results[0] as List<FirestoreFileInfo>;
      final storageData = results[1] as List<DiagnosticStorageFileInfo>;

      debugPrint('📊 Firestore metadata records: ${firestoreData.length}');
      debugPrint('📊 Firebase Storage files: ${storageData.length}');

      // Analyze discrepancies
      final report = _analyzeDiscrepancies(firestoreData, storageData);

      debugPrint('✅ Local data consistency analysis completed');
      return report;
    } catch (e) {
      debugPrint('❌ Data consistency analysis failed: $e');
      return DataConsistencyReport.error(e.toString());
    }
  }

  /// Get all metadata from Firestore document-metadata collection
  Future<List<FirestoreFileInfo>> _getFirestoreMetadata() async {
    debugPrint('📋 Fetching Firestore metadata...');

    final firestore = _firebaseService.firestore;
    final snapshot = await firestore.collection('document-metadata').get();

    final firestoreFiles = <FirestoreFileInfo>[];

    for (final doc in snapshot.docs) {
      final data = doc.data();
      firestoreFiles.add(
        FirestoreFileInfo(
          id: doc.id,
          fileName: data['fileName'] ?? 'unknown',
          filePath: data['filePath'] ?? '',
          isActive: data['isActive'] ?? false,
          fileSize: data['fileSize'] ?? 0,
          uploadedAt: data['uploadedAt']?.toDate() ?? DateTime.now(),
          uploadedBy: data['uploadedBy'] ?? '',
          category: data['category'] ?? 'uncategorized',
          status: data['status'] ?? 'unknown',
        ),
      );
    }

    debugPrint('📋 Found ${firestoreFiles.length} Firestore metadata records');
    return firestoreFiles;
  }

  /// Get all files from Firebase Storage
  Future<List<DiagnosticStorageFileInfo>> _getStorageFiles() async {
    debugPrint('🗄️ Fetching Firebase Storage files...');

    final storageFiles = await _storageService.getAllStorageFilesUnlimited();

    final storageFileInfos = storageFiles
        .map(
          (file) => DiagnosticStorageFileInfo(
            fileName: file.fileName,
            filePath: file.filePath,
            fileSize: file.fileSize,
            contentType: file.fileType,
            timeCreated: file.uploadedAt,
          ),
        )
        .toList();

    debugPrint('🗄️ Found ${storageFileInfos.length} Firebase Storage files');
    return storageFileInfos;
  }

  /// Analyze discrepancies between Firestore and Storage data
  DataConsistencyReport _analyzeDiscrepancies(
    List<FirestoreFileInfo> firestoreData,
    List<DiagnosticStorageFileInfo> storageData,
  ) {
    debugPrint('🔍 Analyzing data discrepancies...');

    // Create lookup maps for efficient comparison
    final storageFileMap = <String, DiagnosticStorageFileInfo>{};
    for (final file in storageData) {
      storageFileMap[file.fileName] = file;
    }

    final firestoreFileMap = <String, FirestoreFileInfo>{};
    final activeFirestoreFiles = <FirestoreFileInfo>[];
    final inactiveFirestoreFiles = <FirestoreFileInfo>[];

    for (final file in firestoreData) {
      firestoreFileMap[file.fileName] = file;
      if (file.isActive) {
        activeFirestoreFiles.add(file);
      } else {
        inactiveFirestoreFiles.add(file);
      }
    }

    // Find orphaned metadata (exists in Firestore but not in Storage)
    final orphanedMetadata = <FirestoreFileInfo>[];
    for (final firestoreFile in firestoreData) {
      if (!storageFileMap.containsKey(firestoreFile.fileName)) {
        orphanedMetadata.add(firestoreFile);
      }
    }

    // Find orphaned storage files (exists in Storage but not in Firestore)
    final orphanedStorageFiles = <DiagnosticStorageFileInfo>[];
    for (final storageFile in storageData) {
      if (!firestoreFileMap.containsKey(storageFile.fileName)) {
        orphanedStorageFiles.add(storageFile);
      }
    }

    // Find duplicate metadata entries
    final duplicateMetadata = <String, List<FirestoreFileInfo>>{};
    final fileNameCounts = <String, int>{};

    for (final file in firestoreData) {
      fileNameCounts[file.fileName] = (fileNameCounts[file.fileName] ?? 0) + 1;
    }

    for (final entry in fileNameCounts.entries) {
      if (entry.value > 1) {
        duplicateMetadata[entry.key] = firestoreData
            .where((f) => f.fileName == entry.key)
            .toList();
      }
    }

    // Calculate statistics
    final totalFirestoreRecords = firestoreData.length;
    final totalActiveFirestoreRecords = activeFirestoreFiles.length;
    final totalInactiveFirestoreRecords = inactiveFirestoreFiles.length;
    final totalStorageFiles = storageData.length;

    debugPrint('📊 Analysis Results:');
    debugPrint('   Total Firestore records: $totalFirestoreRecords');
    debugPrint('   Active Firestore records: $totalActiveFirestoreRecords');
    debugPrint('   Inactive Firestore records: $totalInactiveFirestoreRecords');
    debugPrint('   Total Storage files: $totalStorageFiles');
    debugPrint('   Orphaned metadata: ${orphanedMetadata.length}');
    debugPrint('   Orphaned storage files: ${orphanedStorageFiles.length}');
    debugPrint('   Duplicate metadata: ${duplicateMetadata.length}');

    return DataConsistencyReport(
      totalFirestoreRecords: totalFirestoreRecords,
      totalActiveFirestoreRecords: totalActiveFirestoreRecords,
      totalInactiveFirestoreRecords: totalInactiveFirestoreRecords,
      totalStorageFiles: totalStorageFiles,
      orphanedMetadata: orphanedMetadata,
      orphanedStorageFiles: orphanedStorageFiles,
      duplicateMetadata: duplicateMetadata,
      isConsistent:
          totalActiveFirestoreRecords == totalStorageFiles &&
          orphanedMetadata.isEmpty &&
          orphanedStorageFiles.isEmpty &&
          duplicateMetadata.isEmpty,
      discrepancyCount: (totalActiveFirestoreRecords - totalStorageFiles).abs(),
    );
  }

  /// Clean up orphaned metadata records
  Future<CleanupResult> cleanupOrphanedMetadata({
    required List<FirestoreFileInfo> orphanedRecords,
    bool dryRun = true,
  }) async {
    debugPrint(
      '🧹 ${dryRun ? 'Simulating' : 'Executing'} orphaned metadata cleanup...',
    );

    if (orphanedRecords.isEmpty) {
      debugPrint('✅ No orphaned metadata to clean up');
      return CleanupResult(
        processedCount: 0,
        successCount: 0,
        errorCount: 0,
        errors: [],
      );
    }

    final errors = <String>[];
    int successCount = 0;

    for (final record in orphanedRecords) {
      try {
        if (!dryRun) {
          await _firebaseService.firestore
              .collection('document-metadata')
              .doc(record.id)
              .delete();
        }

        successCount++;
        debugPrint(
          '${dryRun ? '🔍' : '✅'} ${dryRun ? 'Would delete' : 'Deleted'} orphaned metadata: ${record.fileName}',
        );
      } catch (e) {
        final error = 'Failed to delete ${record.fileName}: $e';
        errors.add(error);
        debugPrint('❌ $error');
      }
    }

    debugPrint(
      '🧹 Cleanup ${dryRun ? 'simulation' : 'execution'} completed: $successCount/${orphanedRecords.length}',
    );

    return CleanupResult(
      processedCount: orphanedRecords.length,
      successCount: successCount,
      errorCount: errors.length,
      errors: errors,
    );
  }
}

/// Information about a file in Firestore metadata
class FirestoreFileInfo {
  final String id;
  final String fileName;
  final String filePath;
  final bool isActive;
  final int fileSize;
  final DateTime uploadedAt;
  final String uploadedBy;
  final String category;
  final String status;

  const FirestoreFileInfo({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.isActive,
    required this.fileSize,
    required this.uploadedAt,
    required this.uploadedBy,
    required this.category,
    required this.status,
  });

  @override
  String toString() =>
      'FirestoreFileInfo(id: $id, fileName: $fileName, isActive: $isActive)';
}

/// Information about a file in Firebase Storage for diagnostic purposes
class DiagnosticStorageFileInfo {
  final String fileName;
  final String filePath;
  final int fileSize;
  final String contentType;
  final DateTime timeCreated;

  const DiagnosticStorageFileInfo({
    required this.fileName,
    required this.filePath,
    required this.fileSize,
    required this.contentType,
    required this.timeCreated,
  });

  @override
  String toString() =>
      'DiagnosticStorageFileInfo(fileName: $fileName, size: $fileSize)';
}

/// Comprehensive data consistency report
class DataConsistencyReport {
  final int totalFirestoreRecords;
  final int totalActiveFirestoreRecords;
  final int totalInactiveFirestoreRecords;
  final int totalStorageFiles;
  final List<FirestoreFileInfo> orphanedMetadata;
  final List<DiagnosticStorageFileInfo> orphanedStorageFiles;
  final Map<String, List<FirestoreFileInfo>> duplicateMetadata;
  final bool isConsistent;
  final int discrepancyCount;
  final String? error;

  const DataConsistencyReport({
    required this.totalFirestoreRecords,
    required this.totalActiveFirestoreRecords,
    required this.totalInactiveFirestoreRecords,
    required this.totalStorageFiles,
    required this.orphanedMetadata,
    required this.orphanedStorageFiles,
    required this.duplicateMetadata,
    required this.isConsistent,
    required this.discrepancyCount,
    this.error,
  });

  factory DataConsistencyReport.error(String error) {
    return DataConsistencyReport(
      totalFirestoreRecords: 0,
      totalActiveFirestoreRecords: 0,
      totalInactiveFirestoreRecords: 0,
      totalStorageFiles: 0,
      orphanedMetadata: [],
      orphanedStorageFiles: [],
      duplicateMetadata: {},
      isConsistent: false,
      discrepancyCount: 0,
      error: error,
    );
  }

  factory DataConsistencyReport.fromCloudFunction(Map<String, dynamic> data) {
    // Parse orphaned metadata from Cloud Function response
    final orphanedMetadataList =
        (data['orphanedMetadata'] as List<dynamic>? ?? [])
            .map(
              (item) => FirestoreFileInfo(
                id: item['id'] ?? '',
                fileName: item['fileName'] ?? '',
                filePath: '',
                isActive: item['isActive'] ?? false,
                fileSize: 0,
                uploadedAt: DateTime.now(),
                uploadedBy: '',
                category: item['category'] ?? 'uncategorized',
                status: 'unknown',
              ),
            )
            .toList();

    // Parse orphaned storage files from Cloud Function response
    final orphanedStorageFilesList =
        (data['orphanedStorageFiles'] as List<dynamic>? ?? [])
            .map(
              (item) => DiagnosticStorageFileInfo(
                fileName: item['fileName'] ?? '',
                filePath: '',
                fileSize: item['size'] ?? 0,
                contentType: item['contentType'] ?? '',
                timeCreated: DateTime.now(),
              ),
            )
            .toList();

    // Parse duplicate metadata
    final duplicateMetadataMap = <String, List<FirestoreFileInfo>>{};
    final duplicateList = data['duplicateMetadata'] as List<dynamic>? ?? [];
    for (final fileName in duplicateList) {
      duplicateMetadataMap[fileName.toString()] = [];
    }

    return DataConsistencyReport(
      totalFirestoreRecords: data['totalFirestoreRecords'] ?? 0,
      totalActiveFirestoreRecords: data['totalActiveFirestoreRecords'] ?? 0,
      totalInactiveFirestoreRecords: data['totalInactiveFirestoreRecords'] ?? 0,
      totalStorageFiles: data['totalStorageFiles'] ?? 0,
      orphanedMetadata: orphanedMetadataList,
      orphanedStorageFiles: orphanedStorageFilesList,
      duplicateMetadata: duplicateMetadataMap,
      isConsistent: data['isConsistent'] ?? false,
      discrepancyCount: data['discrepancyCount'] ?? 0,
    );
  }

  @override
  String toString() {
    if (error != null) return 'DataConsistencyReport(error: $error)';

    return '''
DataConsistencyReport(
  Firestore Total: $totalFirestoreRecords
  Firestore Active: $totalActiveFirestoreRecords
  Firestore Inactive: $totalInactiveFirestoreRecords
  Storage Files: $totalStorageFiles
  Orphaned Metadata: ${orphanedMetadata.length}
  Orphaned Storage: ${orphanedStorageFiles.length}
  Duplicates: ${duplicateMetadata.length}
  Consistent: $isConsistent
  Discrepancy: $discrepancyCount
)''';
  }
}

/// Result of cleanup operations
class CleanupResult {
  final int processedCount;
  final int successCount;
  final int errorCount;
  final List<String> errors;

  const CleanupResult({
    required this.processedCount,
    required this.successCount,
    required this.errorCount,
    required this.errors,
  });

  @override
  String toString() =>
      'CleanupResult(processed: $processedCount, success: $successCount, errors: $errorCount)';
}
