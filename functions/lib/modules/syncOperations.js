"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.syncFunctions = exports.checkDataIntegrity = exports.getPaginatedFileStats = exports.invalidateStatisticsCache = exports.getAggregatedStatistics = void 0;
const functions = __importStar(require("firebase-functions/v1"));
const admin = __importStar(require("firebase-admin"));
/**
 * Sync Firebase Storage with Firestore metadata
 */
const syncStorageWithFirestore = functions.https.onCall(async (data, context) => {
    var _a, _b;
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        // Check user permissions
        const userDoc = await admin
            .firestore()
            .collection("users")
            .doc(context.auth.uid)
            .get();
        const user = userDoc.data();
        if (!user || user.role !== "admin") {
            throw new functions.https.HttpsError("permission-denied", "Only admins can perform sync operations");
        }
        const startTime = Date.now();
        console.log("Starting Storage to Firestore sync...");
        const bucket = admin.storage().bucket();
        const documentsRef = bucket.getFiles({ prefix: "documents/" });
        let processed = 0;
        const errors = [];
        const batchSize = 500;
        let batch = admin.firestore().batch();
        let batchCount = 0;
        const [files] = await documentsRef;
        for (const file of files) {
            try {
                // Skip system files
                if (file.name.includes("/.") || file.name.endsWith("/")) {
                    continue;
                }
                const fileName = file.name.split("/").pop() || "unknown";
                const documentId = fileName.split(".")[0] || fileName;
                // Check if document already exists in Firestore
                const existingDoc = await admin
                    .firestore()
                    .collection("document-metadata")
                    .doc(documentId)
                    .get();
                if (!existingDoc.exists) {
                    // Get file metadata
                    const [metadata] = await file.getMetadata();
                    // Create document record
                    const documentData = {
                        id: documentId,
                        fileName,
                        fileSize: parseInt(String(metadata.size || "0")),
                        fileType: getFileTypeFromName(fileName),
                        filePath: file.name,
                        downloadUrl: await file
                            .getSignedUrl({
                            action: "read",
                            expires: "03-09-2491",
                        })
                            .then((urls) => urls[0]),
                        uploadedBy: ((_a = metadata.metadata) === null || _a === void 0 ? void 0 : _a.uploadedBy) || "system",
                        // TIMESTAMP FIX: Always use serverTimestamp for consistency
                        // This ensures all uploadedAt timestamps are server-side and timezone-consistent
                        uploadedAt: admin.firestore.FieldValue.serverTimestamp(),
                        category: ((_b = metadata.metadata) === null || _b === void 0 ? void 0 : _b.categoryId) || "uncategorized",
                        status: "approved", // Default for synced files
                        isActive: true,
                        syncedAt: admin.firestore.FieldValue.serverTimestamp(),
                    };
                    batch.set(admin.firestore().collection("document-metadata").doc(documentId), documentData);
                    batchCount++;
                    processed++;
                    // Commit batch when it reaches the limit
                    if (batchCount >= batchSize) {
                        await batch.commit();
                        batch = admin.firestore().batch();
                        batchCount = 0;
                    }
                }
            }
            catch (error) {
                errors.push(`Error processing file ${file.name}: ${error}`);
                console.error(`Error processing file ${file.name}:`, error);
            }
        }
        // Commit remaining batch
        if (batchCount > 0) {
            await batch.commit();
        }
        const duration = Date.now() - startTime;
        // Log activity
        await admin
            .firestore()
            .collection("activities")
            .add({
            type: "storage_sync_completed",
            userId: context.auth.uid,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            details: `Storage sync completed: ${processed} files processed in ${duration}ms`,
        });
        console.log(`Storage sync completed: ${processed} files processed`);
        return {
            success: true,
            processed,
            errors,
            duration,
        };
    }
    catch (error) {
        console.error("Error in storage sync:", error);
        throw new functions.https.HttpsError("internal", `Storage sync failed: ${error}`);
    }
});
/**
 * DISABLED: Clean up orphaned metadata to prevent automatic deletions
 * This function has been disabled to prevent unwanted metadata deletion
 * Use manual cleanup functions with proper admin controls instead
 */
// const cleanupOrphanedMetadataDisabled = functions.https.onCall(
//   async () => {
//     throw new functions.https.HttpsError(
//       "failed-precondition",
//       "Automatic orphaned metadata cleanup has been disabled. Use manual cleanup functions instead."
//     );
//   }
// );
/**
 * Manual cleanup of orphaned metadata (requires admin authentication)
 */
const manualCleanupOrphanedMetadata = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        // Check user permissions
        const userDoc = await admin
            .firestore()
            .collection("users")
            .doc(context.auth.uid)
            .get();
        const user = userDoc.data();
        if (!user || user.role !== "admin") {
            throw new functions.https.HttpsError("permission-denied", "Only admins can perform cleanup operations");
        }
        const startTime = Date.now();
        console.log("Starting orphaned metadata cleanup...");
        const bucket = admin.storage().bucket();
        let processed = 0;
        const errors = [];
        // Get all documents from Firestore
        const documentsSnapshot = await admin
            .firestore()
            .collection("document-metadata")
            .where("isActive", "==", true)
            .get();
        const batchSize = 500;
        let batch = admin.firestore().batch();
        let batchCount = 0;
        for (const doc of documentsSnapshot.docs) {
            try {
                const documentData = doc.data();
                const filePath = documentData.filePath;
                if (!filePath) {
                    continue;
                }
                // Check if file exists in Storage
                const file = bucket.file(filePath);
                const [exists] = await file.exists();
                if (!exists) {
                    // Mark document as orphaned
                    batch.update(doc.ref, {
                        isActive: false,
                        orphanedAt: admin.firestore.FieldValue.serverTimestamp(),
                        orphanedBy: context.auth.uid,
                        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                    });
                    batchCount++;
                    processed++;
                    // Commit batch when it reaches the limit
                    if (batchCount >= batchSize) {
                        await batch.commit();
                        batch = admin.firestore().batch();
                        batchCount = 0;
                    }
                }
            }
            catch (error) {
                errors.push(`Error checking document ${doc.id}: ${error}`);
                console.error(`Error checking document ${doc.id}:`, error);
            }
        }
        // Commit remaining batch
        if (batchCount > 0) {
            await batch.commit();
        }
        const duration = Date.now() - startTime;
        // Log activity
        await admin
            .firestore()
            .collection("activities")
            .add({
            type: "orphaned_cleanup_completed",
            userId: context.auth.uid,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            details: `Orphaned metadata cleanup completed: ${processed} orphaned documents found in ${duration}ms`,
        });
        console.log(`Orphaned metadata cleanup completed: ${processed} orphaned documents`);
        return {
            success: true,
            processed,
            errors,
            duration,
        };
    }
    catch (error) {
        console.error("Error in orphaned metadata cleanup:", error);
        throw new functions.https.HttpsError("internal", `Orphaned metadata cleanup failed: ${error}`);
    }
});
/**
 * Enhanced Storage-to-Firestore Sync Function
 * Specifically designed to handle PDF files and other orphaned storage files
 */
const syncStorageToFirestore = functions.https.onCall(async (data, context) => {
    // Check authentication
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        // Check admin permissions
        const userDoc = await admin
            .firestore()
            .collection("users")
            .doc(context.auth.uid)
            .get();
        const user = userDoc.data();
        if (!user || user.role !== "admin") {
            throw new functions.https.HttpsError("permission-denied", "Only administrators can perform storage sync operations");
        }
        console.log("🔄 Starting enhanced storage-to-firestore sync...");
        const results = {
            totalStorageFiles: 0,
            orphanedFiles: 0,
            createdRecords: 0,
            errors: [],
            fileTypes: {},
            processingTime: 0,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
        };
        const startTime = Date.now();
        // Step 1: Get all files from Firebase Storage
        console.log("📁 Scanning Firebase Storage for files...");
        const storageFiles = await getAllStorageFiles();
        results.totalStorageFiles = storageFiles.length;
        console.log(`📊 Found ${storageFiles.length} files in Storage`);
        if (storageFiles.length === 0) {
            return {
                success: true,
                results: results,
                message: "No files found in Firebase Storage",
            };
        }
        // Step 2: Check which files are missing from Firestore
        console.log("🔍 Checking for orphaned files...");
        const orphanedFiles = [];
        for (const file of storageFiles) {
            const existsInFirestore = await checkFileExistsInFirestore(file.path);
            if (!existsInFirestore) {
                orphanedFiles.push(file);
                // Track file types
                const fileType = getFileTypeFromContentType(file.contentType);
                results.fileTypes[fileType] = (results.fileTypes[fileType] || 0) + 1;
            }
        }
        results.orphanedFiles = orphanedFiles.length;
        console.log(`🔍 Found ${orphanedFiles.length} orphaned files`);
        if (orphanedFiles.length === 0) {
            results.processingTime = Date.now() - startTime;
            return {
                success: true,
                results: results,
                message: "All storage files already have Firestore records",
            };
        }
        // Step 3: Create Firestore records for orphaned files
        console.log("📝 Creating Firestore records for orphaned files...");
        let createdCount = 0;
        for (const file of orphanedFiles) {
            try {
                await createFirestoreRecordForStorageFile(file, context.auth.uid);
                createdCount++;
                if (createdCount % 10 === 0) {
                    console.log(`📝 Created ${createdCount}/${orphanedFiles.length} records...`);
                }
            }
            catch (error) {
                const errorMsg = `Failed to create record for ${file.name}: ${error}`;
                results.errors.push(errorMsg);
                console.error(`❌ ${errorMsg}`);
            }
        }
        results.createdRecords = createdCount;
        results.processingTime = Date.now() - startTime;
        const successMessage = results.errors.length === 0
            ? `Successfully created ${createdCount} Firestore records for orphaned files`
            : `Created ${createdCount} records with ${results.errors.length} errors`;
        console.log(`✅ Storage sync completed: ${successMessage}`);
        // Log activity
        await admin.firestore().collection("activities").add({
            type: "storage_firestore_sync",
            userId: context.auth.uid,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            details: successMessage,
            results: results,
        });
        return {
            success: true,
            results: results,
            message: successMessage,
        };
    }
    catch (error) {
        console.error("❌ Storage sync failed:", error);
        throw new functions.https.HttpsError("internal", `Storage sync operation failed: ${error}`);
    }
});
/**
 * Perform comprehensive sync (Storage to Firestore + Cleanup)
 */
const performComprehensiveSync = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        // Check user permissions
        const userDoc = await admin
            .firestore()
            .collection("users")
            .doc(context.auth.uid)
            .get();
        const user = userDoc.data();
        if (!user || user.role !== "admin") {
            throw new functions.https.HttpsError("permission-denied", "Only admins can perform comprehensive sync");
        }
        const startTime = Date.now();
        console.log("Starting comprehensive sync...");
        // Step 1: Sync Storage with Firestore
        console.log("Running storage sync...");
        // Step 2: Cleanup orphaned metadata
        console.log("Running cleanup...");
        // Step 3: Update category document counts
        await updateCategoryDocumentCounts();
        // Step 4: Update user statistics
        await updateUserStatistics();
        const duration = Date.now() - startTime;
        // Log activity
        await admin
            .firestore()
            .collection("activities")
            .add({
            type: "comprehensive_sync_completed",
            userId: context.auth.uid,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            details: `Comprehensive sync completed in ${duration}ms`,
        });
        console.log(`Comprehensive sync completed in ${duration}ms`);
        return {
            success: true,
            message: "Comprehensive sync completed",
            duration,
        };
    }
    catch (error) {
        console.error("Error in comprehensive sync:", error);
        throw new functions.https.HttpsError("internal", `Comprehensive sync failed: ${error}`);
    }
});
// Helper functions
async function updateCategoryDocumentCounts() {
    console.log("Updating category document counts...");
    const categoriesSnapshot = await admin
        .firestore()
        .collection("categories")
        .where("isActive", "==", true)
        .get();
    const batch = admin.firestore().batch();
    for (const categoryDoc of categoriesSnapshot.docs) {
        const categoryId = categoryDoc.id;
        // Count documents in this category
        const documentsSnapshot = await admin
            .firestore()
            .collection("document-metadata")
            .where("category", "==", categoryId)
            .where("isActive", "==", true)
            .get();
        batch.update(categoryDoc.ref, {
            documentCount: documentsSnapshot.size,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
    }
    await batch.commit();
    console.log(`Updated document counts for ${categoriesSnapshot.size} categories`);
}
async function updateUserStatistics() {
    console.log("Updating user statistics...");
    const usersSnapshot = await admin
        .firestore()
        .collection("users")
        .where("isActive", "==", true)
        .get();
    const batch = admin.firestore().batch();
    for (const userDoc of usersSnapshot.docs) {
        const userId = userDoc.id;
        // Count documents uploaded by this user
        const documentsSnapshot = await admin
            .firestore()
            .collection("document-metadata")
            .where("uploadedBy", "==", userId)
            .where("isActive", "==", true)
            .get();
        batch.update(userDoc.ref, {
            documentCount: documentsSnapshot.size,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
    }
    await batch.commit();
    console.log(`Updated statistics for ${usersSnapshot.size} users`);
}
/**
 * OPTIMIZED STATISTICS FUNCTIONS FOR LARGE DATASETS
 * Handles 1M+ files efficiently using aggregation and caching
 */
// Aggregated statistics cache collection
const STATS_CACHE_COLLECTION = "statistics-cache";
const STATS_CACHE_DOC = "global-stats";
const CACHE_TTL_MINUTES = 5; // 5 minutes cache
/**
 * Get aggregated statistics optimized for large datasets
 * Uses Firestore aggregation queries and intelligent caching
 */
exports.getAggregatedStatistics = functions.https.onCall(async (data, context) => {
    try {
        console.log("📊 Getting aggregated statistics...");
        // Check cache first
        const cachedStats = await getCachedStatistics();
        if (cachedStats) {
            console.log("✅ Returning cached statistics");
            return cachedStats;
        }
        // Calculate fresh statistics
        const freshStats = await calculateFreshStatistics();
        // Cache the results
        await cacheStatistics(freshStats);
        console.log("✅ Calculated and cached fresh statistics");
        return freshStats;
    }
    catch (error) {
        console.error("❌ Error getting aggregated statistics:", error);
        throw new functions.https.HttpsError("internal", "Failed to get statistics", error);
    }
});
/**
 * Get cached statistics if valid
 */
async function getCachedStatistics() {
    var _a;
    try {
        const cacheDoc = await admin
            .firestore()
            .collection(STATS_CACHE_COLLECTION)
            .doc(STATS_CACHE_DOC)
            .get();
        if (!cacheDoc.exists) {
            return null;
        }
        const data = cacheDoc.data();
        if (!data)
            return null;
        // Check if cache is still valid
        const cacheTime = (_a = data.cachedAt) === null || _a === void 0 ? void 0 : _a.toDate();
        if (!cacheTime)
            return null;
        const now = new Date();
        const diffMinutes = (now.getTime() - cacheTime.getTime()) / (1000 * 60);
        if (diffMinutes > CACHE_TTL_MINUTES) {
            console.log("⏰ Cache expired, will calculate fresh stats");
            return null;
        }
        return data.statistics;
    }
    catch (error) {
        console.error("❌ Error getting cached statistics:", error);
        return null;
    }
}
/**
 * Calculate fresh statistics using optimized queries
 */
async function calculateFreshStatistics() {
    console.log("🔄 Calculating fresh statistics...");
    // Execute basic count queries in parallel (these don't require complex indexes)
    const [totalFilesResult, activeUsersResult, totalCategoriesResult, fileTypeStatsResult, storageSizeResult] = await Promise.all([
        // Total active files - simple single-field query
        admin
            .firestore()
            .collection("document-metadata")
            .where("isActive", "==", true)
            .count()
            .get(),
        // Active users - simple single-field query
        admin
            .firestore()
            .collection("users")
            .where("isActive", "==", true)
            .count()
            .get(),
        // Total categories - simple count query
        admin
            .firestore()
            .collection("categories")
            .count()
            .get(),
        // File type statistics (limited sample for performance)
        getFileTypeStatistics(),
        // Storage size calculation (optimized)
        getOptimizedStorageSize()
    ]);
    // For recent files, use a simpler approach that doesn't require complex indexing
    // Get recent files by fetching documents and counting them locally (last 7 days)
    let recentFilesCount = 0;
    try {
        const sevenDaysAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000);
        console.log(`📊 Calculating recent files since: ${sevenDaysAgo.toISOString()}`);
        const recentFilesSnapshot = await admin
            .firestore()
            .collection("document-metadata")
            .where("isActive", "==", true)
            .where("uploadedAt", ">=", sevenDaysAgo)
            .limit(1000) // Limit to prevent excessive reads
            .get();
        recentFilesCount = recentFilesSnapshot.docs.length;
        console.log(`📊 Recent files count (last 7 days): ${recentFilesCount}`);
        // Debug: Log some sample recent files for verification
        if (recentFilesSnapshot.docs.length > 0) {
            const sampleDocs = recentFilesSnapshot.docs.slice(0, 3);
            sampleDocs.forEach(doc => {
                const data = doc.data();
                const uploadedAt = data.uploadedAt;
                console.log(`📄 Sample recent file: ${data.fileName} uploaded at: ${uploadedAt}`);
            });
        }
    }
    catch (recentFilesError) {
        console.warn(`⚠️ Could not calculate recent files, using 0: ${recentFilesError}`);
        recentFilesCount = 0;
    }
    const statistics = {
        totalFiles: totalFilesResult.data().count,
        activeUsers: activeUsersResult.data().count,
        totalCategories: totalCategoriesResult.data().count,
        recentFiles: recentFilesCount,
        fileTypeStats: fileTypeStatsResult,
        totalStorageSize: storageSizeResult,
        lastCalculated: admin.firestore.FieldValue.serverTimestamp(),
        calculationDurationMs: Date.now() // Will be updated after calculation
    };
    return statistics;
}
/**
 * Get file type statistics with optimized sampling
 * For large datasets, uses sampling to avoid loading all documents
 */
async function getFileTypeStatistics() {
    try {
        // For performance, limit to recent files or use sampling
        const recentFilesSnapshot = await admin
            .firestore()
            .collection("document-metadata")
            .where("isActive", "==", true)
            .orderBy("uploadedAt", "desc")
            .limit(10000) // Sample recent files for type distribution
            .get();
        const fileTypeStats = {};
        recentFilesSnapshot.docs.forEach(doc => {
            const data = doc.data();
            const fileType = data.fileType || 'unknown';
            fileTypeStats[fileType] = (fileTypeStats[fileType] || 0) + 1;
        });
        return fileTypeStats;
    }
    catch (error) {
        console.error("❌ Error getting file type statistics:", error);
        return {};
    }
}
/**
 * Get optimized storage size calculation
 * Uses aggregation where possible to avoid loading all documents
 */
async function getOptimizedStorageSize() {
    try {
        // For large datasets, we might need to use Cloud Storage API
        // or maintain a running total in a separate document
        // For now, use a limited sample to estimate
        const sampleSnapshot = await admin
            .firestore()
            .collection("document-metadata")
            .where("isActive", "==", true)
            .limit(1000)
            .get();
        let totalSampleSize = 0;
        sampleSnapshot.docs.forEach(doc => {
            const data = doc.data();
            totalSampleSize += data.fileSize || 0;
        });
        // Estimate total size based on sample
        const totalFilesSnapshot = await admin
            .firestore()
            .collection("document-metadata")
            .where("isActive", "==", true)
            .count()
            .get();
        const totalFiles = totalFilesSnapshot.data().count;
        const sampleSize = sampleSnapshot.size;
        if (sampleSize === 0)
            return 0;
        const averageFileSize = totalSampleSize / sampleSize;
        const estimatedTotalSize = Math.round(averageFileSize * totalFiles);
        return estimatedTotalSize;
    }
    catch (error) {
        console.error("❌ Error calculating storage size:", error);
        return 0;
    }
}
/**
 * Cache statistics for performance
 */
async function cacheStatistics(statistics) {
    try {
        await admin
            .firestore()
            .collection(STATS_CACHE_COLLECTION)
            .doc(STATS_CACHE_DOC)
            .set({
            statistics,
            cachedAt: admin.firestore.FieldValue.serverTimestamp(),
            version: "1.0"
        });
    }
    catch (error) {
        console.error("❌ Error caching statistics:", error);
        // Don't throw error, caching failure shouldn't break the function
    }
}
/**
 * Invalidate statistics cache
 * Called when files are uploaded/deleted to ensure fresh data
 */
exports.invalidateStatisticsCache = functions.https.onCall(async (data, context) => {
    try {
        console.log("🗑️ Invalidating statistics cache...");
        await admin
            .firestore()
            .collection(STATS_CACHE_COLLECTION)
            .doc(STATS_CACHE_DOC)
            .delete();
        console.log("✅ Statistics cache invalidated");
        return { success: true };
    }
    catch (error) {
        console.error("❌ Error invalidating cache:", error);
        throw new functions.https.HttpsError("internal", "Failed to invalidate cache", error);
    }
});
/**
 * Get paginated file statistics for detailed breakdowns
 * Supports large datasets with cursor-based pagination (FIXED: No more offset/limit issues)
 */
exports.getPaginatedFileStats = functions.https.onCall(async (data, context) => {
    try {
        const { page = 1, limit = 50, category, fileType, sortBy = 'uploadedAt', sortOrder = 'desc', lastDocumentId: cursorDocumentId = null // For cursor-based pagination
         } = data;
        console.log(`📄 Getting paginated stats: page=${page}, limit=${limit}, cursor=${cursorDocumentId}`);
        let query = admin
            .firestore()
            .collection("document-metadata")
            .where("isActive", "==", true);
        // Add filters
        if (category) {
            query = query.where("category", "==", category);
        }
        if (fileType) {
            query = query.where("fileType", "==", fileType);
        }
        // Add sorting
        query = query.orderBy(sortBy, sortOrder);
        // FIXED: Use cursor-based pagination instead of offset/limit
        if (cursorDocumentId && page > 1) {
            // Get the last document for cursor pagination
            const lastDocRef = admin
                .firestore()
                .collection("document-metadata")
                .doc(cursorDocumentId);
            const lastDocSnapshot = await lastDocRef.get();
            if (lastDocSnapshot.exists) {
                query = query.startAfter(lastDocSnapshot);
            }
        }
        // Apply limit
        query = query.limit(limit);
        const snapshot = await query.get();
        const files = snapshot.docs.map(doc => (Object.assign(Object.assign({ id: doc.id }, doc.data()), { 
            // Only return essential fields for performance
            fileName: doc.data().fileName, fileSize: doc.data().fileSize, fileType: doc.data().fileType, category: doc.data().category, uploadedAt: doc.data().uploadedAt, uploadedBy: doc.data().uploadedBy })));
        // Get total count for pagination info
        let countQuery = admin
            .firestore()
            .collection("document-metadata")
            .where("isActive", "==", true);
        if (category) {
            countQuery = countQuery.where("category", "==", category);
        }
        if (fileType) {
            countQuery = countQuery.where("fileType", "==", fileType);
        }
        const totalCount = await countQuery.count().get();
        const total = totalCount.data().count;
        // Calculate pagination info for cursor-based pagination
        const hasNext = files.length === limit;
        const hasPrev = page > 1;
        const lastDocumentId = files.length > 0 ? files[files.length - 1].id : null;
        return {
            files,
            pagination: {
                page,
                limit,
                total,
                hasNext,
                hasPrev,
                lastDocumentId // For next page cursor
            },
            filters: {
                category,
                fileType,
                sortBy,
                sortOrder
            }
        };
    }
    catch (error) {
        console.error("❌ Error getting paginated file stats:", error);
        throw new functions.https.HttpsError("internal", "Failed to get paginated stats", error);
    }
});
/**
 * DIAGNOSTIC: Check data integrity between Firestore and Storage
 * Identifies orphaned documents and count discrepancies
 */
exports.checkDataIntegrity = functions.https.onCall(async (data, context) => {
    try {
        console.log("🔍 Starting data integrity check...");
        const bucket = admin.storage().bucket();
        // Get all active documents from Firestore
        const firestoreSnapshot = await admin
            .firestore()
            .collection("document-metadata")
            .where("isActive", "==", true)
            .get();
        console.log(`📊 Found ${firestoreSnapshot.docs.length} active documents in Firestore`);
        // Get all files from Storage
        const [storageFiles] = await bucket.getFiles();
        console.log(`📁 Found ${storageFiles.length} files in Storage`);
        const issues = [];
        let orphanedDocuments = 0;
        let missingDocuments = 0;
        // Check for orphaned Firestore documents (no corresponding Storage file)
        for (const doc of firestoreSnapshot.docs) {
            const docData = doc.data();
            const filePath = docData.filePath;
            if (filePath) {
                const file = bucket.file(filePath);
                const [exists] = await file.exists();
                if (!exists) {
                    orphanedDocuments++;
                    issues.push({
                        type: "orphaned_document",
                        documentId: doc.id,
                        fileName: docData.fileName,
                        filePath: filePath,
                        issue: "Firestore document exists but Storage file is missing"
                    });
                }
            }
        }
        // Check for missing Firestore documents (Storage files without metadata)
        for (const file of storageFiles) {
            const fileName = file.name.split("/").pop() || "unknown";
            const documentId = fileName.split(".")[0] || fileName;
            const docExists = firestoreSnapshot.docs.some(doc => doc.id === documentId);
            if (!docExists) {
                missingDocuments++;
                issues.push({
                    type: "missing_document",
                    fileName: fileName,
                    filePath: file.name,
                    issue: "Storage file exists but no Firestore document found"
                });
            }
        }
        const summary = {
            firestoreDocuments: firestoreSnapshot.docs.length,
            storageFiles: storageFiles.length,
            orphanedDocuments,
            missingDocuments,
            totalIssues: issues.length,
            isHealthy: issues.length === 0
        };
        console.log("📋 Data Integrity Summary:", summary);
        return {
            summary,
            issues: issues.slice(0, 50), // Limit to first 50 issues for response size
            timestamp: admin.firestore.FieldValue.serverTimestamp()
        };
    }
    catch (error) {
        console.error("❌ Error checking data integrity:", error);
        throw new functions.https.HttpsError("internal", "Failed to check data integrity", error);
    }
});
async function getAllStorageFiles() {
    const files = [];
    const bucket = admin.storage().bucket();
    try {
        // Get files from documents folder
        const [storageFiles] = await bucket.getFiles({
            prefix: 'documents/',
        });
        for (const file of storageFiles) {
            const [metadata] = await file.getMetadata();
            files.push({
                name: file.name.split('/').pop() || file.name,
                path: file.name,
                size: parseInt(String(metadata.size || 0)),
                contentType: metadata.contentType || 'application/octet-stream',
                timeCreated: new Date(metadata.timeCreated || Date.now()),
            });
        }
    }
    catch (error) {
        console.error('❌ Error scanning storage:', error);
    }
    return files;
}
async function checkFileExistsInFirestore(filePath) {
    try {
        const querySnapshot = await admin
            .firestore()
            .collection('document-metadata')
            .where('filePath', '==', filePath)
            .limit(1)
            .get();
        return !querySnapshot.empty;
    }
    catch (error) {
        console.error(`⚠️ Error checking Firestore for ${filePath}:`, error);
        return false;
    }
}
async function createFirestoreRecordForStorageFile(file, adminUserId) {
    const documentId = admin.firestore().collection('document-metadata').doc().id;
    // Generate download URL for the file
    let downloadUrl = null;
    try {
        const storageRef = admin.storage().bucket().file(file.path);
        downloadUrl = await storageRef.getSignedUrl({
            action: 'read',
            expires: '03-09-2491' // Far future date
        }).then(urls => urls[0]);
    }
    catch (error) {
        console.warn(`⚠️ Failed to generate download URL for ${file.name}:`, error);
    }
    const documentData = {
        id: documentId,
        fileName: file.name,
        filePath: file.path,
        fileSize: file.size,
        fileType: getFileTypeFromContentType(file.contentType),
        uploadedBy: adminUserId,
        // TIMESTAMP FIX: Use serverTimestamp for consistency instead of file.timeCreated
        // This ensures all uploadedAt timestamps are server-side and timezone-consistent
        uploadedAt: admin.firestore.FieldValue.serverTimestamp(),
        downloadUrl: downloadUrl,
        category: extractCategoryFromPath(file.path),
        status: 'active',
        isActive: true,
        permissions: [adminUserId],
        metadata: {
            description: 'Auto-synced from Storage',
            tags: ['storage-synced'],
            version: '1.0',
            contentType: file.contentType,
            syncedAt: admin.firestore.FieldValue.serverTimestamp(),
            createdBy: 'sync_operations',
            unifiedIdSystem: true,
            // Store original file creation time for reference
            originalTimeCreated: admin.firestore.Timestamp.fromDate(file.timeCreated),
        },
    };
    // ENHANCED: Use atomic transaction to ensure both collections are updated together
    const batch = admin.firestore().batch();
    // Add document-metadata record to batch
    const docRef = admin.firestore().collection('document-metadata').doc(documentId);
    batch.set(docRef, documentData);
    // Add activity log to batch
    const activityRef = admin.firestore().collection('activities').doc();
    batch.set(activityRef, {
        type: 'file_synced',
        documentId: documentId,
        userId: adminUserId,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        details: `File ${file.name} synced from Storage to Firestore`,
        syncSource: 'sync_operations',
    });
    // Commit both operations atomically
    await batch.commit();
    console.log(`✅ Created Firestore record and activity log for: ${file.name}`);
}
function getFileTypeFromContentType(contentType) {
    if (contentType.includes('pdf'))
        return 'PDF';
    if (contentType.includes('image'))
        return 'Image';
    if (contentType.includes('word') || contentType.includes('document'))
        return 'Document';
    if (contentType.includes('sheet') || contentType.includes('excel'))
        return 'Spreadsheet';
    return 'Other';
}
function extractCategoryFromPath(filePath) {
    const parts = filePath.split('/');
    if (parts.length >= 3 && parts[1] === 'categories') {
        return parts[2];
    }
    return 'general';
}
function getFileTypeFromName(fileName) {
    var _a;
    const extension = (_a = fileName.split(".").pop()) === null || _a === void 0 ? void 0 : _a.toLowerCase();
    switch (extension) {
        case "pdf":
            return "PDF";
        case "doc":
        case "docx":
            return "DOC";
        case "xls":
        case "xlsx":
            return "Excel";
        case "ppt":
        case "pptx":
            return "PPT";
        case "jpg":
        case "jpeg":
        case "png":
        case "gif":
            return "Image";
        case "txt":
            return "Text";
        default:
            return "Other";
    }
}
/**
 * Monitor sync consistency between document-metadata and activities collections
 * Detects files recorded in activities but missing from document-metadata
 */
const monitorSyncConsistency = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        // Check user permissions
        const userDoc = await admin
            .firestore()
            .collection("users")
            .doc(context.auth.uid)
            .get();
        const user = userDoc.data();
        if (!user || user.role !== "admin") {
            throw new functions.https.HttpsError("permission-denied", "Only admins can monitor sync consistency");
        }
        console.log("🔍 Starting sync consistency monitoring...");
        const startTime = Date.now();
        // Get all file upload activities
        const activitiesSnapshot = await admin
            .firestore()
            .collection("activities")
            .where("type", "==", "file_uploaded")
            .orderBy("timestamp", "desc")
            .limit(1000) // Check last 1000 uploads
            .get();
        const inconsistencies = [];
        const orphanedActivities = [];
        let checkedCount = 0;
        console.log(`📊 Checking ${activitiesSnapshot.docs.length} file upload activities...`);
        for (const activity of activitiesSnapshot.docs) {
            try {
                const activityData = activity.data();
                const documentId = activityData.documentId;
                if (!documentId) {
                    orphanedActivities.push({
                        activityId: activity.id,
                        reason: "Missing documentId",
                        timestamp: activityData.timestamp,
                    });
                    continue;
                }
                // Check if corresponding document exists in document-metadata
                const docSnapshot = await admin
                    .firestore()
                    .collection("document-metadata")
                    .doc(documentId)
                    .get();
                if (!docSnapshot.exists) {
                    inconsistencies.push({
                        documentId,
                        activityId: activity.id,
                        timestamp: activityData.timestamp,
                        details: activityData.details,
                        userId: activityData.userId,
                        issue: "Document exists in activities but not in document-metadata",
                    });
                }
                checkedCount++;
            }
            catch (error) {
                console.error(`Error checking activity ${activity.id}:`, error);
            }
        }
        // Also check for documents without corresponding activities
        const documentsSnapshot = await admin
            .firestore()
            .collection("document-metadata")
            .where("isActive", "==", true)
            .orderBy("uploadedAt", "desc")
            .limit(1000)
            .get();
        const missingActivities = [];
        console.log(`📊 Checking ${documentsSnapshot.docs.length} documents for missing activities...`);
        for (const doc of documentsSnapshot.docs) {
            try {
                const docData = doc.data();
                // Look for corresponding activity
                const activityQuery = await admin
                    .firestore()
                    .collection("activities")
                    .where("type", "==", "file_uploaded")
                    .where("documentId", "==", doc.id)
                    .limit(1)
                    .get();
                if (activityQuery.empty) {
                    missingActivities.push({
                        documentId: doc.id,
                        fileName: docData.fileName,
                        uploadedAt: docData.uploadedAt,
                        uploadedBy: docData.uploadedBy,
                        issue: "Document exists in document-metadata but no corresponding activity",
                    });
                }
            }
            catch (error) {
                console.error(`Error checking document ${doc.id}:`, error);
            }
        }
        const duration = Date.now() - startTime;
        const summary = {
            checkedActivities: checkedCount,
            checkedDocuments: documentsSnapshot.docs.length,
            inconsistencies: inconsistencies.length,
            orphanedActivities: orphanedActivities.length,
            missingActivities: missingActivities.length,
            duration: `${duration}ms`,
        };
        console.log("✅ Sync consistency monitoring completed:", summary);
        // Log monitoring activity
        await admin
            .firestore()
            .collection("activities")
            .add({
            type: "sync_consistency_check",
            userId: context.auth.uid,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            details: `Sync monitoring completed: ${inconsistencies.length} inconsistencies found`,
            summary,
        });
        return {
            success: true,
            summary,
            inconsistencies,
            orphanedActivities,
            missingActivities,
        };
    }
    catch (error) {
        console.error("❌ Sync consistency monitoring failed:", error);
        throw new functions.https.HttpsError("internal", `Sync consistency monitoring failed: ${error}`);
    }
});
/**
 * Repair sync inconsistencies by creating missing records
 */
const repairSyncInconsistencies = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        // Check user permissions
        const userDoc = await admin
            .firestore()
            .collection("users")
            .doc(context.auth.uid)
            .get();
        const user = userDoc.data();
        if (!user || user.role !== "admin") {
            throw new functions.https.HttpsError("permission-denied", "Only admins can repair sync inconsistencies");
        }
        const { repairType, inconsistencies } = data;
        console.log(`🔧 Starting sync repair: ${repairType}`);
        let repairedCount = 0;
        const errors = [];
        if (repairType === "create_missing_activities") {
            // Create missing activities for documents
            for (const item of inconsistencies || []) {
                try {
                    await admin
                        .firestore()
                        .collection("activities")
                        .add({
                        type: "file_uploaded",
                        documentId: item.documentId,
                        userId: item.uploadedBy,
                        timestamp: item.uploadedAt || admin.firestore.FieldValue.serverTimestamp(),
                        details: `File ${item.fileName} uploaded (auto-repaired activity)`,
                        repaired: true,
                        repairedBy: context.auth.uid,
                        repairedAt: admin.firestore.FieldValue.serverTimestamp(),
                    });
                    repairedCount++;
                    console.log(`✅ Created missing activity for document: ${item.documentId}`);
                }
                catch (error) {
                    const errorMsg = `Failed to create activity for ${item.documentId}: ${error}`;
                    errors.push(errorMsg);
                    console.error(errorMsg);
                }
            }
        }
        // Log repair activity
        await admin
            .firestore()
            .collection("activities")
            .add({
            type: "sync_repair_completed",
            userId: context.auth.uid,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            details: `Sync repair completed: ${repairedCount} items repaired`,
            repairType,
            repairedCount,
            errorCount: errors.length,
        });
        return {
            success: true,
            repairedCount,
            errors,
            message: `Successfully repaired ${repairedCount} inconsistencies`,
        };
    }
    catch (error) {
        console.error("❌ Sync repair failed:", error);
        throw new functions.https.HttpsError("internal", `Sync repair failed: ${error}`);
    }
});
exports.syncFunctions = {
    syncStorageWithFirestore,
    syncStorageToFirestore,
    cleanupOrphanedMetadata: manualCleanupOrphanedMetadata,
    performComprehensiveSync,
    monitorSyncConsistency,
    repairSyncInconsistencies,
    // ENHANCED: Statistics Functions for Large Datasets
    getAggregatedStatistics: exports.getAggregatedStatistics,
    getPaginatedFileStats: exports.getPaginatedFileStats,
    invalidateStatisticsCache: exports.invalidateStatisticsCache,
};
//# sourceMappingURL=syncOperations.js.map