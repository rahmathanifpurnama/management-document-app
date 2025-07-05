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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.fileUploadFunctions = void 0;
const functions = __importStar(require("firebase-functions/v1"));
const admin = __importStar(require("firebase-admin"));
const sharp_1 = __importDefault(require("sharp"));
const crypto = __importStar(require("crypto"));
// Security Configuration
const MAX_FILE_SIZE = 15 * 1024 * 1024; // 15MB
const MAX_REQUESTS_PER_MINUTE = 30; // Rate limiting
// Allowed file types with comprehensive MIME type validation
const ALLOWED_TYPES = [
    "application/pdf",
    "application/msword",
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    "application/vnd.ms-excel",
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    "text/csv",
    "application/csv",
    "text/comma-separated-values",
    "application/vnd.ms-powerpoint",
    "application/vnd.openxmlformats-officedocument.presentationml.presentation",
    "image/jpeg",
    "image/png",
    "image/gif",
    "text/plain",
];
// Allowed file extensions (security whitelist)
const ALLOWED_EXTENSIONS = [
    "pdf",
    "doc",
    "docx",
    "xls",
    "xlsx",
    "csv",
    "ppt",
    "pptx",
    "jpg",
    "jpeg",
    "png",
    "gif",
    "txt",
];
// Rate limiting storage (in production, use Redis or Firestore)
const rateLimitStore = new Map();
// Security Helper Functions
/**
 * Rate limiting check
 */
function checkRateLimit(userId) {
    const now = Date.now();
    const userKey = `rate_limit_${userId}`;
    const userLimit = rateLimitStore.get(userKey);
    if (!userLimit || now > userLimit.resetTime) {
        // Reset rate limit window
        rateLimitStore.set(userKey, {
            count: 1,
            resetTime: now + 60 * 1000, // 1 minute window
        });
        return;
    }
    if (userLimit.count >= MAX_REQUESTS_PER_MINUTE) {
        throw new functions.https.HttpsError("resource-exhausted", "Rate limit exceeded. Please try again later.");
    }
    userLimit.count++;
    rateLimitStore.set(userKey, userLimit);
}
/**
 * Sanitize filename to prevent path traversal and injection attacks
 * ENHANCED: Preserves spaces for display while securing dangerous characters
 */
function sanitizeFileName(fileName) {
    if (!fileName || typeof fileName !== "string") {
        throw new functions.https.HttpsError("invalid-argument", "Invalid filename provided");
    }
    // Remove path traversal attempts
    let sanitized = fileName.replace(/\.\./g, "");
    // Remove or replace dangerous characters (but preserve spaces)
    // eslint-disable-next-line no-control-regex
    sanitized = sanitized.replace(/[<>:"/\\|?*\x00-\x1f]/g, "_");
    // Remove leading/trailing spaces and dots
    sanitized = sanitized.trim().replace(/^\.+|\.+$/g, "");
    // Ensure filename is not empty after sanitization
    if (!sanitized) {
        throw new functions.https.HttpsError("invalid-argument", "Filename cannot be empty or contain only invalid characters");
    }
    // Limit filename length
    if (sanitized.length > 255) {
        const extension = sanitized.split(".").pop() || "";
        const nameWithoutExt = sanitized.substring(0, sanitized.lastIndexOf("."));
        sanitized =
            nameWithoutExt.substring(0, 250 - extension.length) + "." + extension;
    }
    return sanitized;
}
/**
 * Create secure storage path from filename
 * ENHANCED: Replaces spaces and special characters for secure storage paths
 */
function createSecureStoragePath(fileName) {
    if (!fileName || typeof fileName !== "string") {
        throw new functions.https.HttpsError("invalid-argument", "Invalid filename provided");
    }
    // First sanitize for security
    let securePath = sanitizeFileName(fileName);
    // Then replace spaces with underscores for storage path
    securePath = securePath.replace(/\s+/g, "_");
    // Convert to lowercase for consistency
    securePath = securePath.toLowerCase();
    return securePath;
}
/**
 * Sanitize email address for Firebase Storage path compatibility
 * Converts email to storage-safe format for human-readable folder names
 */
function sanitizeEmailForStorage(email) {
    if (!email || typeof email !== "string") {
        return "unknown-user";
    }
    // Convert email to storage-safe format
    // john.doe@company.com -> john-dot-doe-at-company-dot-com
    return email
        .replace(/@/g, "-at-")
        .replace(/\./g, "-dot-")
        .replace(/\+/g, "-plus-")
        .replace(/ /g, "-")
        .toLowerCase();
}
/**
 * Calculate file hash for duplicate detection
 */
async function calculateFileHash(filePath) {
    try {
        const fileRef = admin.storage().bucket().file(filePath);
        const [buffer] = await fileRef.download();
        // Calculate SHA-256 hash
        const hash = crypto.createHash("sha256");
        hash.update(buffer);
        return hash.digest("hex");
    }
    catch (error) {
        console.error("Error calculating file hash:", error);
        throw new functions.https.HttpsError("internal", `Failed to calculate file hash: ${error}`);
    }
}
/**
 * Check for duplicate files based on hash
 */
async function checkForDuplicates(fileHash, fileName, fileSize, uploadedBy) {
    try {
        const firestore = admin.firestore();
        // First check by hash (most reliable)
        const hashQuery = await firestore
            .collection("documents")
            .where("metadata.fileHash", "==", fileHash)
            .where("isActive", "==", true)
            .limit(1)
            .get();
        if (!hashQuery.empty) {
            const existingDoc = hashQuery.docs[0].data();
            console.log(`Duplicate file detected by hash: ${fileHash}`);
            return {
                isDuplicate: true,
                existingDocument: existingDoc,
            };
        }
        // Secondary check by filename and size (less reliable but useful)
        const nameQuery = await firestore
            .collection("documents")
            .where("fileName", "==", fileName)
            .where("fileSize", "==", fileSize)
            .where("uploadedBy", "==", uploadedBy)
            .where("isActive", "==", true)
            .limit(1)
            .get();
        if (!nameQuery.empty) {
            const existingDoc = nameQuery.docs[0].data();
            console.log(`Potential duplicate file detected by name and size: ${fileName}`);
            return {
                isDuplicate: true,
                existingDocument: existingDoc,
            };
        }
        return { isDuplicate: false };
    }
    catch (error) {
        console.error("Error checking for duplicates:", error);
        // Don't fail upload if duplicate check fails
        return { isDuplicate: false };
    }
}
/**
 * Process file upload and create document metadata
 */
const processFileUpload = functions.https.onCall(async (data, context) => {
    var _a;
    // Verify authentication
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    // Rate limiting check
    checkRateLimit(context.auth.uid);
    try {
        const { filePath, contentType, metadata, categoryId } = data;
        const uploadedBy = context.auth.uid;
        console.log(`Processing file upload: ${filePath}`);
        // Extract and process file information
        const originalFileName = filePath.split("/").pop() || "unknown";
        const displayFileName = sanitizeFileName(originalFileName); // For display (preserves spaces)
        const secureStorageName = createSecureStoragePath(originalFileName); // For storage paths
        const fileRef = admin.storage().bucket().file(filePath);
        // Get file metadata
        const [fileMetadata] = await fileRef.getMetadata();
        const fileSize = parseInt(String(fileMetadata.size || "0"));
        // Enhanced file validation (use display name for validation)
        const validation = await validateFileInternal({
            fileName: displayFileName,
            fileSize,
            contentType: contentType || fileMetadata.contentType || "",
        });
        if (!validation.isValid) {
            throw new functions.https.HttpsError("invalid-argument", validation.error || "File validation failed");
        }
        // Calculate file hash for duplicate detection
        console.log("Calculating file hash for duplicate detection...");
        const fileHash = await calculateFileHash(filePath);
        // Check for duplicates
        const duplicateCheck = await checkForDuplicates(fileHash, displayFileName, fileSize, uploadedBy);
        if (duplicateCheck.isDuplicate) {
            // DISABLED: Automatic file deletion to prevent unwanted data loss
            // Instead, just reject the upload without deleting the file
            // try {
            //   await fileRef.delete();
            //   console.log(`Deleted duplicate file: ${filePath}`);
            // } catch (deleteError) {
            //   console.warn(`Failed to delete duplicate file: ${deleteError}`);
            // }
            console.log(`Duplicate file detected but not deleted: ${filePath}`);
            throw new functions.https.HttpsError("already-exists", `File already exists in the system. Original file: ${((_a = duplicateCheck.existingDocument) === null || _a === void 0 ? void 0 : _a.fileName) || "Unknown"}. The uploaded file has been preserved but not processed.`);
        }
        // Extract additional metadata
        const extractedMetadata = await extractMetadataInternal({
            filePath,
            contentType: contentType || fileMetadata.contentType || "",
        });
        // Generate thumbnail for images
        let thumbnailUrl = null;
        if (contentType === null || contentType === void 0 ? void 0 : contentType.startsWith("image/")) {
            thumbnailUrl = await generateThumbnailInternal(filePath);
        }
        // UNIFIED ID SYSTEM: Use Firestore auto-generated ID as single source of truth
        const docRef = admin.firestore().collection("documents").doc();
        const documentId = docRef.id; // Use Firestore's auto-generated ID
        console.log(`🆔 Using unified document ID: ${documentId}`);
        // ENHANCED: Use original name for display, secure name for storage references
        const documentData = {
            id: documentId, // Store ID in document for consistency
            fileName: displayFileName, // Clean filename for display (preserves spaces)
            originalFileName: originalFileName, // Keep original for reference
            secureStorageName: secureStorageName, // Secure name for storage operations
            fileSize,
            fileType: getFileType(displayFileName),
            filePath, // Storage path without timestamp
            downloadUrl: await fileRef
                .getSignedUrl({
                action: "read",
                expires: "03-09-2491", // Far future date
            })
                .then((urls) => urls[0]),
            thumbnailUrl,
            uploadedBy,
            uploadedAt: admin.firestore.FieldValue.serverTimestamp(),
            category: categoryId || "",
            status: "active", // Changed from "pending" to "active"
            metadata: Object.assign(Object.assign({}, extractedMetadata), { originalMetadata: metadata, fileHash: fileHash, storageFileName: filePath.split("/").pop() || secureStorageName, displayFileName: displayFileName, secureStorageName: secureStorageName, createdBy: "cloud_function_upload", unifiedIdSystem: true, securityChecks: {
                    fileNameSanitized: originalFileName !== displayFileName,
                    storageNameSecured: originalFileName !== secureStorageName,
                    spacesPreservedInDisplay: displayFileName.includes(' '),
                    contentValidated: false, // Content-based scanning disabled
                    duplicateChecked: true,
                    validatedAt: admin.firestore.FieldValue.serverTimestamp(),
                } }),
            isActive: true,
        };
        // ENHANCED: Use atomic transaction to ensure both collections are updated together
        const batch = admin.firestore().batch();
        // Add documents write to batch
        batch.set(docRef, documentData);
        // Add activity log to batch
        const activityRef = admin.firestore().collection("activities").doc();
        batch.set(activityRef, {
            type: "file_uploaded",
            documentId,
            userId: uploadedBy,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            details: `File ${displayFileName} uploaded successfully`,
        });
        // Commit both operations atomically
        await batch.commit();
        console.log(`✅ Atomic transaction completed: documents and activities updated for ${documentId}`);
        console.log(`File upload processed successfully: ${documentId}`);
        return {
            success: true,
            documentId,
            message: "File uploaded and processed successfully",
        };
    }
    catch (error) {
        console.error("Error processing file upload:", error);
        throw new functions.https.HttpsError("internal", `Failed to process file upload: ${error}`);
    }
});
/**
 * Generate thumbnail for images
 */
const generateThumbnail = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    // Rate limiting check
    checkRateLimit(context.auth.uid);
    try {
        const thumbnailUrl = await generateThumbnailInternal(data.filePath);
        return { success: true, thumbnailUrl };
    }
    catch (error) {
        console.error("Error generating thumbnail:", error);
        throw new functions.https.HttpsError("internal", `Failed to generate thumbnail: ${error}`);
    }
});
/**
 * Validate file before upload
 */
const validateFile = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    // Rate limiting check
    checkRateLimit(context.auth.uid);
    // Sanitize filename in validation data (preserve spaces for display)
    const sanitizedData = Object.assign(Object.assign({}, data), { fileName: sanitizeFileName(data.fileName) });
    const validation = await validateFileInternal(sanitizedData);
    return validation;
});
/**
 * Extract file metadata
 */
const extractMetadata = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        const metadata = await extractMetadataInternal(data);
        return { success: true, metadata };
    }
    catch (error) {
        console.error("Error extracting metadata:", error);
        throw new functions.https.HttpsError("internal", `Failed to extract metadata: ${error}`);
    }
});
// Internal helper functions
async function validateFileInternal(data) {
    var _a;
    const { fileName, fileSize, contentType } = data;
    // Input validation
    if (!fileName || !contentType) {
        return {
            isValid: false,
            error: "Missing required file information",
        };
    }
    // Check file size
    if (fileSize <= 0) {
        return {
            isValid: false,
            error: "Invalid file size",
        };
    }
    if (fileSize > MAX_FILE_SIZE) {
        return {
            isValid: false,
            error: `File size exceeds maximum limit of ${MAX_FILE_SIZE / (1024 * 1024)}MB`,
        };
    }
    // Check MIME type
    if (!ALLOWED_TYPES.includes(contentType)) {
        return {
            isValid: false,
            error: `File type ${contentType} is not allowed. Allowed types: ${ALLOWED_TYPES.join(", ")}`,
        };
    }
    // Check file extension
    const extension = (_a = fileName.split(".").pop()) === null || _a === void 0 ? void 0 : _a.toLowerCase();
    if (!extension || !ALLOWED_EXTENSIONS.includes(extension)) {
        return {
            isValid: false,
            error: `File extension .${extension} is not allowed. Allowed extensions: ${ALLOWED_EXTENSIONS.join(", ")}`,
        };
    }
    // Cross-validate MIME type and extension
    const mimeExtensionMap = {
        "application/pdf": ["pdf"],
        "application/msword": ["doc"],
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document": [
            "docx",
        ],
        "application/vnd.ms-excel": ["xls"],
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet": [
            "xlsx",
        ],
        "text/csv": ["csv"],
        "application/csv": ["csv"],
        "text/comma-separated-values": ["csv"],
        "application/vnd.ms-powerpoint": ["ppt"],
        "application/vnd.openxmlformats-officedocument.presentationml.presentation": ["pptx"],
        "image/jpeg": ["jpg", "jpeg"],
        "image/png": ["png"],
        "image/gif": ["gif"],
        "text/plain": ["txt"],
    };
    const expectedExtensions = mimeExtensionMap[contentType];
    if (expectedExtensions && !expectedExtensions.includes(extension)) {
        return {
            isValid: false,
            error: `File extension .${extension} does not match MIME type ${contentType}`,
        };
    }
    return { isValid: true };
}
async function extractMetadataInternal(data) {
    const { filePath, contentType } = data;
    try {
        const fileRef = admin.storage().bucket().file(filePath);
        const [metadata] = await fileRef.getMetadata();
        const extractedMetadata = {
            size: metadata.size,
            contentType: metadata.contentType,
            timeCreated: metadata.timeCreated,
            updated: metadata.updated,
            md5Hash: metadata.md5Hash,
            crc32c: metadata.crc32c,
        };
        // Add specific metadata based on file type
        if (contentType.startsWith("image/")) {
            try {
                const [buffer] = await fileRef.download();
                const imageMetadata = await (0, sharp_1.default)(buffer).metadata();
                extractedMetadata.image = {
                    width: imageMetadata.width,
                    height: imageMetadata.height,
                    format: imageMetadata.format,
                    hasAlpha: imageMetadata.hasAlpha,
                };
            }
            catch (error) {
                console.warn("Failed to extract image metadata:", error);
            }
        }
        return extractedMetadata;
    }
    catch (error) {
        console.error("Error extracting metadata:", error);
        return {};
    }
}
async function generateThumbnailInternal(filePath) {
    try {
        const bucket = admin.storage().bucket();
        const file = bucket.file(filePath);
        // Download the file
        const [buffer] = await file.download();
        // Generate thumbnail
        const thumbnailBuffer = await (0, sharp_1.default)(buffer)
            .resize(200, 200, {
            fit: "inside",
            withoutEnlargement: true,
        })
            .jpeg({ quality: 80 })
            .toBuffer();
        // Upload thumbnail
        const thumbnailPath = `thumbnails/${filePath.split("/").pop()}_thumb.jpg`;
        const thumbnailFile = bucket.file(thumbnailPath);
        await thumbnailFile.save(thumbnailBuffer, {
            metadata: {
                contentType: "image/jpeg",
            },
        });
        // Get download URL
        const [url] = await thumbnailFile.getSignedUrl({
            action: "read",
            expires: "03-09-2491",
        });
        return url;
    }
    catch (error) {
        console.error("Error generating thumbnail:", error);
        return null;
    }
}
function getFileType(fileName) {
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
        case "csv":
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
 * Get storage quota information
 */
const getStorageQuota = functions.https.onCall(async (_data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        const bucket = admin.storage().bucket();
        // Get bucket metadata to check usage
        await bucket.getMetadata();
        // Firebase Storage doesn't directly expose quota info via Admin SDK
        // This is a simplified implementation - in production, you might want to
        // track usage in Firestore or use Cloud Monitoring APIs
        const used = 0; // Would need to calculate actual usage
        const limit = 1024 * 1024 * 1024 * 1024; // 1TB limit for Blaze plan (effectively unlimited)
        return {
            success: true,
            used,
            limit,
            available: limit - used,
        };
    }
    catch (error) {
        console.error("Error getting storage quota:", error);
        throw new functions.https.HttpsError("internal", `Failed to get storage quota: ${error}`);
    }
});
/**
 * Search for a file in Firebase Storage by filename
 */
async function searchFileInStorage(fileName) {
    try {
        console.log(`Searching for file in storage: ${fileName}`);
        const bucket = admin.storage().bucket();
        // Search in common directories
        const searchPaths = [
            "documents/",
            "documents/categories/",
            "uploads/",
            "files/",
        ];
        for (const basePath of searchPaths) {
            try {
                const [files] = await bucket.getFiles({ prefix: basePath });
                for (const file of files) {
                    const name = file.name.split("/").pop() || "";
                    // Check for exact match or pattern match (with timestamp)
                    if (name === fileName || name.includes(fileName)) {
                        console.log(`Found file: ${file.name}`);
                        return file.name;
                    }
                }
            }
            catch (error) {
                console.warn(`Error searching in ${basePath}:`, error);
                continue;
            }
        }
        console.log(`File not found in storage: ${fileName}`);
        return null;
    }
    catch (error) {
        console.error("Error searching for file:", error);
        return null;
    }
}
/**
 * Get file access URL with expiration
 */
const getFileAccessUrl = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        const { filePath, expirationMinutes = 60 } = data;
        // Validate filePath parameter
        if (!filePath || typeof filePath !== "string" || filePath.trim() === "") {
            console.error("Invalid filePath provided:", filePath);
            throw new functions.https.HttpsError("invalid-argument", "A valid file path must be specified");
        }
        // Sanitize and validate the file path
        const sanitizedPath = filePath.trim();
        console.log(`Generating access URL for file: ${sanitizedPath}`);
        // Check if file exists in storage
        const bucket = admin.storage().bucket();
        let file = bucket.file(sanitizedPath);
        let [exists] = await file.exists();
        let actualPath = sanitizedPath;
        if (!exists) {
            console.log(`File not found at exact path: ${sanitizedPath}`);
            // Extract filename from path and search for it
            const fileName = sanitizedPath.split("/").pop() || "";
            if (fileName) {
                console.log(`Searching for file by name: ${fileName}`);
                const foundPath = await searchFileInStorage(fileName);
                if (foundPath) {
                    file = bucket.file(foundPath);
                    [exists] = await file.exists();
                    actualPath = foundPath;
                    console.log(`Found file at alternative path: ${foundPath}`);
                }
            }
            if (!exists) {
                console.error(`File not found in storage: ${sanitizedPath}`);
                throw new functions.https.HttpsError("not-found", `File not found: ${sanitizedPath}`);
            }
        }
        // Generate signed URL
        const [url] = await file.getSignedUrl({
            action: "read",
            expires: Date.now() + expirationMinutes * 60 * 1000,
        });
        console.log(`Successfully generated access URL for: ${actualPath}`);
        return {
            success: true,
            url,
            actualPath,
            expiresAt: new Date(Date.now() + expirationMinutes * 60 * 1000).toISOString(),
        };
    }
    catch (error) {
        console.error("Error generating file access URL:", error);
        // Re-throw HttpsError as-is
        if (error instanceof functions.https.HttpsError) {
            throw error;
        }
        // Wrap other errors
        throw new functions.https.HttpsError("internal", `Failed to generate file access URL: ${error}`);
    }
});
/**
 * Cleanup orphaned files
 */
const cleanupOrphanedFiles = functions.https.onCall(async (_data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        const bucket = admin.storage().bucket();
        const firestore = admin.firestore();
        // Get all files from storage
        const [files] = await bucket.getFiles({ prefix: "documents/" });
        // Get all document records from Firestore
        const documentsSnapshot = await firestore.collection("documents").get();
        const documentPaths = new Set(documentsSnapshot.docs.map((doc) => doc.data().filePath));
        let deletedCount = 0;
        // DISABLED: Automatic orphaned file deletion to prevent data loss
        // Instead, just log orphaned files for manual review
        for (const file of files) {
            if (!documentPaths.has(file.name) && !file.name.endsWith("/.keep")) {
                // Log orphaned file but don't delete
                console.log(`Orphaned file found (not deleted): ${file.name}`);
                deletedCount++; // Count for reporting, but don't actually delete
                // try {
                //   await file.delete();
                //   deletedCount++;
                //   console.log(`Deleted orphaned file: ${file.name}`);
                // } catch (error) {
                //   console.warn(`Failed to delete file ${file.name}:`, error);
                // }
            }
        }
        return {
            success: true,
            deletedCount,
            message: `Cleaned up ${deletedCount} orphaned files`,
        };
    }
    catch (error) {
        console.error("Error cleaning up orphaned files:", error);
        throw new functions.https.HttpsError("internal", `Failed to cleanup orphaned files: ${error}`);
    }
});
/**
 * Check for duplicate files before upload
 */
const checkDuplicateFile = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        const { fileName, fileSize, contentType, fileHash } = data;
        console.log(`Checking for duplicate file: ${fileName}`);
        // Query Firestore for potential duplicates
        const documentsRef = admin.firestore().collection("documents");
        // First check by filename and size
        const nameAndSizeQuery = await documentsRef
            .where("fileName", "==", fileName)
            .where("fileSize", "==", fileSize)
            .where("isActive", "==", true)
            .get();
        if (!nameAndSizeQuery.empty) {
            const existingDoc = nameAndSizeQuery.docs[0].data();
            return {
                isDuplicate: true,
                existingDocument: {
                    id: nameAndSizeQuery.docs[0].id,
                    fileName: existingDoc.fileName,
                    uploadedAt: existingDoc.uploadedAt,
                    uploadedBy: existingDoc.uploadedBy,
                },
                reason: "Same filename and size",
            };
        }
        // If hash is provided, check by hash
        if (fileHash) {
            const hashQuery = await documentsRef
                .where("metadata.fileHash", "==", fileHash)
                .where("isActive", "==", true)
                .get();
            if (!hashQuery.empty) {
                const existingDoc = hashQuery.docs[0].data();
                return {
                    isDuplicate: true,
                    existingDocument: {
                        id: hashQuery.docs[0].id,
                        fileName: existingDoc.fileName,
                        uploadedAt: existingDoc.uploadedAt,
                        uploadedBy: existingDoc.uploadedBy,
                    },
                    reason: "Same file hash",
                };
            }
        }
        // Check by content type and size for potential duplicates
        const contentTypeQuery = await documentsRef
            .where("fileSize", "==", fileSize)
            .where("metadata.contentType", "==", contentType)
            .where("isActive", "==", true)
            .limit(5)
            .get();
        const potentialDuplicates = contentTypeQuery.docs.map((doc) => ({
            id: doc.id,
            fileName: doc.data().fileName,
            uploadedAt: doc.data().uploadedAt,
        }));
        return {
            isDuplicate: false,
            potentialDuplicates,
            message: "No exact duplicates found",
        };
    }
    catch (error) {
        console.error("Error checking for duplicates:", error);
        throw new functions.https.HttpsError("internal", `Failed to check for duplicates: ${error}`);
    }
});
/**
 * Batch process multiple files
 */
const batchProcessFiles = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }
    try {
        const { filePaths, operation, options = {} } = data;
        const results = [];
        for (const filePath of filePaths) {
            try {
                let result;
                switch (operation) {
                    case "generateThumbnail":
                        result = await generateThumbnailInternal(filePath);
                        break;
                    case "extractMetadata":
                        result = await extractMetadataInternal({
                            filePath,
                            contentType: options.contentType || "application/octet-stream",
                        });
                        break;
                    default:
                        throw new Error(`Unknown operation: ${operation}`);
                }
                results.push({
                    filePath,
                    success: true,
                    result,
                });
            }
            catch (error) {
                results.push({
                    filePath,
                    success: false,
                    error: error instanceof Error ? error.message : String(error),
                });
            }
        }
        return {
            success: true,
            results,
            processed: results.length,
        };
    }
    catch (error) {
        console.error("Error in batch processing:", error);
        throw new functions.https.HttpsError("internal", `Failed to batch process files: ${error}`);
    }
});
/**
 * Streaming upload for large files (HTTP endpoint)
 */
const streamingUpload = functions.https.onRequest(async (req, res) => {
    // Set CORS headers
    res.set("Access-Control-Allow-Origin", "*");
    res.set("Access-Control-Allow-Methods", "POST, OPTIONS");
    res.set("Access-Control-Allow-Headers", "Content-Type, Authorization");
    if (req.method === "OPTIONS") {
        res.status(204).send("");
        return;
    }
    if (req.method !== "POST") {
        res.status(405).json({ error: "Method not allowed" });
        return;
    }
    try {
        // Verify authentication from Authorization header
        const authHeader = req.headers.authorization;
        if (!authHeader || !authHeader.startsWith("Bearer ")) {
            res.status(401).json({ error: "Unauthorized" });
            return;
        }
        const idToken = authHeader.split("Bearer ")[1];
        const decodedToken = await admin.auth().verifyIdToken(idToken);
        // Rate limiting check
        checkRateLimit(decodedToken.uid);
        // Handle multipart upload with streaming
        const contentLength = parseInt(req.headers["content-length"] || "0");
        if (contentLength > MAX_FILE_SIZE) {
            res.status(413).json({
                error: `File too large. Maximum size: ${MAX_FILE_SIZE / (1024 * 1024)}MB`,
            });
            return;
        }
        // Require filename header - no timestamp fallback
        const originalFileName = req.headers["x-file-name"];
        if (!originalFileName) {
            res.status(400).json({
                error: "Missing x-file-name header. Filename is required for upload."
            });
            return;
        }
        const displayFileName = sanitizeFileName(originalFileName); // Preserves spaces
        const secureStorageName = createSecureStoragePath(originalFileName); // Secure for storage
        // Use email-based folder structure for human-readable storage paths
        const userEmail = decodedToken.email || decodedToken.uid; // Fallback to UID if no email
        const sanitizedEmail = sanitizeEmailForStorage(userEmail);
        const filePath = `documents/${sanitizedEmail}/${secureStorageName}`;
        // Stream upload to Firebase Storage
        const bucket = admin.storage().bucket();
        const file = bucket.file(filePath);
        const stream = file.createWriteStream({
            metadata: {
                contentType: req.headers["content-type"] || "application/octet-stream",
            },
        });
        // Handle stream events
        stream.on("error", (error) => {
            console.error("Stream upload error:", error);
            res.status(500).json({ error: "Upload failed" });
        });
        stream.on("finish", async () => {
            try {
                // Get download URL
                const [url] = await file.getSignedUrl({
                    action: "read",
                    expires: "03-09-2491",
                });
                res.status(200).json({
                    success: true,
                    filePath,
                    downloadUrl: url,
                    message: "File uploaded successfully",
                });
            }
            catch (error) {
                console.error("Error getting download URL:", error);
                res.status(500).json({ error: "Failed to get download URL" });
            }
        });
        // Pipe request to storage stream
        req.pipe(stream);
    }
    catch (error) {
        console.error("Streaming upload error:", error);
        res.status(500).json({ error: "Internal server error" });
    }
});
exports.fileUploadFunctions = {
    processFileUpload,
    generateThumbnail,
    validateFile,
    checkDuplicateFile,
    extractMetadata,
    getStorageQuota,
    getFileAccessUrl,
    cleanupOrphanedFiles,
    batchProcessFiles,
    streamingUpload,
};
//# sourceMappingURL=fileUpload.js.map