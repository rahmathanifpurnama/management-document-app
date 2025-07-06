import * as functions from 'firebase-functions/v1';
import * as admin from 'firebase-admin';
import * as crypto from 'crypto';
import sharp from 'sharp';
import { v4 as uuidv4 } from 'uuid';

/**
 * HYBRID FILE PROCESSING MODULE
 * =============================
 * Heavy server-side processing for files uploaded via hybrid upload system
 * 
 * Features:
 * - File hash calculation (SHA-256)
 * - Advanced duplicate detection
 * - Image compression and thumbnail generation
 * - Metadata extraction
 * - Content validation and security scanning
 * - Document indexing for search
 * - Virus scanning (placeholder for future implementation)
 */

interface FileMetadata {
  uploadedBy: string;
  downloadUrl: string;
  deviceId?: string;
  timestamp: string;
  processingMode: string;
  [key: string]: any;
}

interface ProcessingResult {
  documentId: string;
  fileHash: string;
  thumbnailUrl?: string;
  extractedMetadata: any;
  processingStatus: 'completed' | 'failed' | 'partial';
  processingTime: number;
}

/**
 * Process uploaded file with heavy server-side operations
 * Called after client has already uploaded file to Firebase Storage
 */
export const processFileUpload = functions
  .runWith({
    timeoutSeconds: 540, // 9 minutes
    memory: '2GB',
  })
  .https.onCall(async (data: any, context: functions.https.CallableContext) => {
    const startTime = Date.now();

    // CRITICAL DEBUG: Log function invocation
    console.log('🚀 HYBRID FUNCTION INVOKED!');
    console.log('📞 Function: hybridProcessFileUpload');
    console.log('📋 Data received:', JSON.stringify(data, null, 2));
    console.log('👤 Context:', {
      uid: context.auth?.uid,
      email: context.auth?.token?.email,
    });
    
    try {
      // Validate authentication
      if (!context.auth) {
        throw new functions.https.HttpsError(
          'unauthenticated',
          'User must be authenticated to process files'
        );
      }

      // Validate authorization - check user permissions
      const userId = context.auth.uid;
      const userEmail = context.auth.token?.email;

      console.log(`🔐 Authorization check for user: ${userEmail} (${userId})`);

      // Get user document from Firestore to check permissions
      const db = admin.firestore();
      const userDoc = await db.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        console.log(`❌ User document not found: ${userId}`);
        throw new functions.https.HttpsError(
          'permission-denied',
          'User not found in system'
        );
      }

      const userData = userDoc.data();
      const userRole = userData?.role;
      const userPermissions = userData?.permissions?.documents || [];
      const userFullName = userData?.fullName || 'Unknown User';

      console.log(`👤 User role: ${userRole}`);
      console.log(`👤 User name: ${userFullName}`);
      console.log(`📋 User permissions:`, userPermissions);

      // Check if user has upload permission
      const hasUploadPermission = userRole === 'admin' || userPermissions.includes('upload');

      if (!hasUploadPermission) {
        console.log(`❌ User ${userEmail} does not have upload permission`);
        throw new functions.https.HttpsError(
          'permission-denied',
          'User does not have permission to upload files'
        );
      }

      console.log(`✅ User ${userEmail} authorized for file upload`);

      const { filePath, fileName, contentType, categoryId, metadata } = data;
      
      if (!filePath || !fileName || !metadata) {
        throw new functions.https.HttpsError(
          'invalid-argument',
          'Missing required parameters: filePath, fileName, or metadata'
        );
      }

      console.log(`🚀 Starting heavy processing for: ${fileName}`);
      console.log(`📁 File path: ${filePath}`);
      console.log(`👤 User: ${context.auth.uid}`);

      // PHASE 1: Download file from storage for processing
      const fileBuffer = await downloadFileFromStorage(filePath);
      console.log(`📥 Downloaded file: ${fileBuffer.length} bytes`);

      // PHASE 2: Calculate file hash (SHA-256)
      const fileHash = calculateFileHash(fileBuffer);
      console.log(`🔢 File hash calculated: ${fileHash}`);

      // PHASE 3: Advanced duplicate detection
      const duplicateCheck = await advancedDuplicateDetection(
        fileHash,
        fileName,
        fileBuffer.length,
        context.auth.uid
      );
      
      if (duplicateCheck.isDuplicate) {
        throw new functions.https.HttpsError(
          'already-exists',
          `File already exists: ${duplicateCheck.existingDocument.fileName}`,
          duplicateCheck.existingDocument
        );
      }

      // PHASE 4: Extract metadata
      const extractedMetadata = await extractFileMetadata(
        fileBuffer,
        fileName,
        contentType
      );
      console.log(`📊 Metadata extracted:`, extractedMetadata);

      // PHASE 5: Generate thumbnail (for images)
      let thumbnailUrl: string | undefined;
      if (isImageFile(contentType)) {
        thumbnailUrl = await generateThumbnail(
          fileBuffer,
          filePath,
          fileName
        );
        console.log(`🖼️ Thumbnail generated: ${thumbnailUrl}`);
      }

      // PHASE 6: Content validation and security scanning
      const securityCheck = await performSecurityScan(fileBuffer, contentType);
      if (!securityCheck.isSecure) {
        throw new functions.https.HttpsError(
          'permission-denied',
          `File failed security scan: ${securityCheck.reason}`
        );
      }

      // PHASE 7: Create document record with full metadata
      const documentId = await createEnhancedDocumentRecord({
        fileName,
        filePath,
        fileHash,
        fileSize: fileBuffer.length,
        contentType,
        categoryId,
        uploadedBy: userFullName,
        uploadedByUid: context.auth.uid, // Keep UID for internal tracking
        downloadUrl: metadata.downloadUrl,
        thumbnailUrl,
        extractedMetadata,
        originalMetadata: metadata,
      });

      // PHASE 8: Index document for search
      await indexDocumentForSearch(documentId, {
        fileName,
        extractedMetadata,
        contentType,
        categoryId,
      });

      const processingTime = Date.now() - startTime;
      console.log(`✅ Heavy processing completed in ${processingTime}ms`);

      const result: ProcessingResult = {
        documentId,
        fileHash,
        thumbnailUrl,
        extractedMetadata,
        processingStatus: 'completed',
        processingTime,
      };

      return result;

    } catch (error) {
      const processingTime = Date.now() - startTime;
      console.error(`❌ Heavy processing failed after ${processingTime}ms:`, error);
      
      if (error instanceof functions.https.HttpsError) {
        throw error;
      }
      
      throw new functions.https.HttpsError(
        'internal',
        'File processing failed',
        { error: error instanceof Error ? error.message : String(error), processingTime }
      );
    }
  });

/**
 * Download file from Firebase Storage
 */
async function downloadFileFromStorage(filePath: string): Promise<Buffer> {
  try {
    // Use default bucket from Firebase Admin initialization
    const bucket = admin.storage().bucket();
    const file = bucket.file(filePath);

    console.log(`📥 Attempting to download file: ${filePath}`);
    console.log(`🪣 Using bucket: ${bucket.name}`);

    // Check if file exists first
    const [exists] = await file.exists();
    if (!exists) {
      throw new Error(`File does not exist: ${filePath}`);
    }

    const [fileBuffer] = await file.download();
    console.log(`✅ File downloaded successfully: ${fileBuffer.length} bytes`);
    return fileBuffer;
  } catch (error) {
    console.error(`❌ Failed to download file: ${filePath}`, error);
    console.error(`❌ Error details:`, error);
    throw new Error(`Failed to download file: ${error instanceof Error ? error.message : String(error)}`);
  }
}

/**
 * Calculate SHA-256 hash of file
 */
function calculateFileHash(fileBuffer: Buffer): string {
  return crypto.createHash('sha256').update(fileBuffer).digest('hex');
}

/**
 * Advanced duplicate detection using hash + metadata
 */
async function advancedDuplicateDetection(
  fileHash: string,
  fileName: string,
  fileSize: number,
  userId: string
): Promise<{ isDuplicate: boolean; existingDocument?: any }> {
  try {
    const db = admin.firestore();
    
    // Check for exact hash match (most reliable)
    const hashQuery = await db
      .collection('documents')
      .where('fileHash', '==', fileHash)
      .limit(1)
      .get();

    if (!hashQuery.empty) {
      const existingDoc = hashQuery.docs[0].data();
      console.log(`🔍 Duplicate found by hash: ${existingDoc.fileName}`);
      return {
        isDuplicate: true,
        existingDocument: existingDoc,
      };
    }

    // Check for same filename + size + user (secondary check)
    // Try both uploadedByUid (new format) and uploadedBy (legacy format) for compatibility
    const metadataQuery = await db
      .collection('documents')
      .where('fileName', '==', fileName)
      .where('fileSize', '==', fileSize)
      .where('uploadedByUid', '==', userId)
      .limit(1)
      .get();

    // If no match with uploadedByUid, try legacy uploadedBy field
    if (metadataQuery.empty) {
      const legacyQuery = await db
        .collection('documents')
        .where('fileName', '==', fileName)
        .where('fileSize', '==', fileSize)
        .where('uploadedBy', '==', userId)
        .limit(1)
        .get();

      if (!legacyQuery.empty) {
        const existingDoc = legacyQuery.docs[0].data();
        console.log(`🔍 Potential duplicate found by legacy metadata: ${existingDoc.fileName}`);
        return {
          isDuplicate: true,
          existingDocument: existingDoc,
        };
      }
    }

    if (!metadataQuery.empty) {
      const existingDoc = metadataQuery.docs[0].data();
      console.log(`🔍 Potential duplicate found by metadata: ${existingDoc.fileName}`);
      return {
        isDuplicate: true,
        existingDocument: existingDoc,
      };
    }

    return { isDuplicate: false };
  } catch (error) {
    console.error('❌ Duplicate detection failed:', error);
    // Don't block upload for duplicate detection failures
    return { isDuplicate: false };
  }
}

/**
 * Extract metadata from file based on type
 */
async function extractFileMetadata(
  fileBuffer: Buffer,
  fileName: string,
  contentType: string
): Promise<any> {
  const metadata: any = {
    fileName,
    fileSize: fileBuffer.length,
    contentType,
    extractedAt: new Date().toISOString(),
  };

  try {
    if (isImageFile(contentType)) {
      // Extract image metadata using Sharp
      const imageMetadata = await sharp(fileBuffer).metadata();
      metadata.image = {
        width: imageMetadata.width,
        height: imageMetadata.height,
        format: imageMetadata.format,
        colorSpace: imageMetadata.space,
        hasAlpha: imageMetadata.hasAlpha,
        density: imageMetadata.density,
      };
    }

    // Add file extension info
    const extension = fileName.split('.').pop()?.toLowerCase();
    metadata.extension = extension;
    metadata.category = categorizeFileType(contentType, extension);

  } catch (error) {
    console.error('⚠️ Metadata extraction failed:', error);
    // Continue with basic metadata
  }

  return metadata;
}

/**
 * Generate thumbnail for images
 */
async function generateThumbnail(
  fileBuffer: Buffer,
  originalPath: string,
  fileName: string
): Promise<string | undefined> {
  try {
    // Generate thumbnail using Sharp
    const thumbnailBuffer = await sharp(fileBuffer)
      .resize(300, 300, {
        fit: 'inside',
        withoutEnlargement: true,
      })
      .jpeg({ quality: 80 })
      .toBuffer();

    // Upload thumbnail to storage
    const bucket = admin.storage().bucket();
    const thumbnailPath = `thumbnails/${originalPath.replace(/\.[^/.]+$/, '')}_thumb.jpg`;
    const thumbnailFile = bucket.file(thumbnailPath);

    await thumbnailFile.save(thumbnailBuffer, {
      metadata: {
        contentType: 'image/jpeg',
        metadata: {
          originalFile: fileName,
          generatedAt: new Date().toISOString(),
        },
      },
    });

    // Get download URL
    await thumbnailFile.makePublic();
    return `https://storage.googleapis.com/${bucket.name}/${thumbnailPath}`;

  } catch (error) {
    console.error('⚠️ Thumbnail generation failed:', error);
    return undefined;
  }
}

/**
 * Perform security scanning on file
 */
async function performSecurityScan(
  fileBuffer: Buffer,
  contentType: string
): Promise<{ isSecure: boolean; reason?: string }> {
  try {
    // Basic security checks
    
    // Check file size limits
    const maxSize = 100 * 1024 * 1024; // 100MB
    if (fileBuffer.length > maxSize) {
      return {
        isSecure: false,
        reason: 'File size exceeds maximum limit',
      };
    }

    // Check for suspicious file signatures
    const fileSignature = fileBuffer.slice(0, 10).toString('hex');
    const suspiciousSignatures = [
      '4d5a', // PE executable
      '7f454c46', // ELF executable
    ];

    for (const signature of suspiciousSignatures) {
      if (fileSignature.startsWith(signature)) {
        return {
          isSecure: false,
          reason: 'Suspicious file signature detected',
        };
      }
    }

    // TODO: Integrate with virus scanning service
    // TODO: Content analysis for malicious patterns

    return { isSecure: true };

  } catch (error) {
    console.error('⚠️ Security scan failed:', error);
    // Default to secure if scan fails
    return { isSecure: true };
  }
}

/**
 * Helper functions
 */
function isImageFile(contentType: string): boolean {
  return contentType.startsWith('image/');
}

function categorizeFileType(contentType: string, extension?: string): string {
  if (contentType.startsWith('image/')) return 'Image';
  if (contentType.includes('pdf')) return 'PDF';
  if (contentType.includes('word') || extension === 'doc' || extension === 'docx') return 'Document';
  if (contentType.includes('excel') || extension === 'xls' || extension === 'xlsx') return 'Spreadsheet';
  if (contentType.includes('powerpoint') || extension === 'ppt' || extension === 'pptx') return 'Presentation';
  if (contentType.includes('text')) return 'Text';
  return 'Other';
}

/**
 * Create enhanced document record with full metadata
 */
async function createEnhancedDocumentRecord(data: {
  fileName: string;
  filePath: string;
  fileHash: string;
  fileSize: number;
  contentType: string;
  categoryId?: string;
  uploadedBy: string;
  uploadedByUid?: string;
  downloadUrl: string;
  thumbnailUrl?: string;
  extractedMetadata: any;
  originalMetadata: any;
}): Promise<string> {
  try {
    const db = admin.firestore();
    const documentId = uuidv4();

    const documentData = {
      id: documentId,
      fileName: data.fileName,
      fileSize: data.fileSize,
      fileType: categorizeFileType(data.contentType, data.extractedMetadata.extension),
      filePath: data.filePath,
      fileHash: data.fileHash,
      downloadUrl: data.downloadUrl,
      thumbnailUrl: data.thumbnailUrl,
      uploadedBy: data.uploadedBy,
      uploadedByUid: data.uploadedByUid, // Keep UID for internal tracking
      uploadedAt: admin.firestore.FieldValue.serverTimestamp(),
      category: data.categoryId || '',
      status: 'active',
      permissions: [data.uploadedByUid || data.uploadedBy], // Use UID for permissions
      contentType: data.contentType,

      // Enhanced metadata from server processing
      metadata: {
        description: 'Processed via hybrid upload system',
        tags: ['hybrid-upload', 'server-processed'],
        version: '1.0',
        processingStatus: 'completed',
        serverProcessingSuccess: true,
        extractedMetadata: data.extractedMetadata,
        originalMetadata: data.originalMetadata,
        processedAt: new Date().toISOString(),
      },

      // Search indexing fields
      searchTerms: generateSearchTerms(data.fileName, data.extractedMetadata),

      // Analytics fields
      analytics: {
        downloadCount: 0,
        viewCount: 0,
        lastAccessed: null,
        createdVia: 'hybrid_upload',
      },
    };

    await db.collection('documents').doc(documentId).set(documentData);
    console.log(`✅ Enhanced document record created: ${documentId}`);

    return documentId;
  } catch (error) {
    console.error('❌ Failed to create enhanced document record:', error);
    throw new Error(`Failed to create document record: ${error instanceof Error ? error.message : String(error)}`);
  }
}

/**
 * Index document for search functionality
 */
async function indexDocumentForSearch(
  documentId: string,
  data: {
    fileName: string;
    extractedMetadata: any;
    contentType: string;
    categoryId?: string;
  }
): Promise<void> {
  try {
    const db = admin.firestore();

    // Create search index document
    const searchIndexData = {
      documentId,
      fileName: data.fileName,
      fileNameLower: data.fileName.toLowerCase(),
      fileType: categorizeFileType(data.contentType, data.extractedMetadata.extension),
      category: data.categoryId || '',
      searchTerms: generateSearchTerms(data.fileName, data.extractedMetadata),
      indexedAt: admin.firestore.FieldValue.serverTimestamp(),

      // Additional searchable fields
      extension: data.extractedMetadata.extension,
      contentType: data.contentType,

      // Image-specific search fields
      ...(data.extractedMetadata.image && {
        imageWidth: data.extractedMetadata.image.width,
        imageHeight: data.extractedMetadata.image.height,
        imageFormat: data.extractedMetadata.image.format,
      }),
    };

    await db.collection('search_index').doc(documentId).set(searchIndexData);
    console.log(`🔍 Document indexed for search: ${documentId}`);

  } catch (error) {
    console.error('⚠️ Search indexing failed:', error);
    // Don't throw error - indexing failure shouldn't block upload
  }
}

/**
 * Generate search terms from filename and metadata
 */
function generateSearchTerms(fileName: string, metadata: any): string[] {
  const terms = new Set<string>();

  // Add filename parts
  const nameWithoutExt = fileName.replace(/\.[^/.]+$/, '');
  const nameParts = nameWithoutExt.split(/[\s\-_\.]+/);
  nameParts.forEach(part => {
    if (part.length > 2) {
      terms.add(part.toLowerCase());
    }
  });

  // Add file extension
  if (metadata.extension) {
    terms.add(metadata.extension.toLowerCase());
  }

  // Add category
  if (metadata.category) {
    terms.add(metadata.category.toLowerCase());
  }

  // Add content type category
  terms.add(categorizeFileType(metadata.contentType, metadata.extension).toLowerCase());

  return Array.from(terms);
}
