import '../../../models/document_model.dart';

/// Abstract Document Repository Interface
///
/// This interface defines all document-related operations that can be performed.
/// It abstracts the data layer from the business logic layer (BLoC).
///
/// Features:
/// - Document CRUD operations
/// - Search and filtering capabilities
/// - Real-time document streaming
/// - Pagination support
/// - Error handling
abstract class DocumentRepository {
  /// Get all documents with optional pagination
  ///
  /// [limit] - Maximum number of documents to fetch (null for unlimited)
  /// [startAfter] - Document to start after for pagination
  /// Returns list of documents ordered by uploadedAt (descending)
  Future<List<DocumentModel>> getAllDocuments({
    int? limit,
    DocumentModel? startAfter,
  });

  /// Get a specific document by ID
  ///
  /// [id] - Document ID to fetch
  /// Returns the document if found, null otherwise
  Future<DocumentModel?> getDocumentById(String id);

  /// Delete a document (move to recycle bin)
  ///
  /// [id] - Document ID to delete
  /// [userId] - ID of user performing the deletion
  /// Returns true if successful, false otherwise
  Future<bool> deleteDocument(String id, String userId);

  /// Permanently delete a document from recycle bin
  ///
  /// [id] - Document ID to permanently delete
  /// [userId] - ID of user performing the deletion
  /// Returns true if successful, false otherwise
  Future<bool> permanentlyDeleteDocument(String id, String userId);

  /// Restore a document from recycle bin
  ///
  /// [id] - Document ID to restore
  /// [userId] - ID of user performing the restoration
  /// Returns true if successful, false otherwise
  Future<bool> restoreDocument(String id, String userId);

  /// Update document metadata
  ///
  /// [document] - Updated document model
  /// Returns true if successful, false otherwise
  Future<bool> updateDocument(DocumentModel document);

  /// Watch documents for real-time updates
  ///
  /// Returns a stream of document lists that updates in real-time
  Stream<List<DocumentModel>> watchDocuments();

  /// Search documents by query
  ///
  /// [query] - Search query string
  /// [limit] - Maximum number of results (optional)
  /// Returns list of documents matching the search query
  Future<List<DocumentModel>> searchDocuments(String query, {int? limit});

  /// Filter documents by various criteria
  ///
  /// [category] - Filter by category (optional)
  /// [status] - Filter by status (optional)
  /// [fileType] - Filter by file type (optional)
  /// [userId] - Filter by uploader (optional)
  /// [isDeleted] - Filter by deletion status (optional)
  /// [startDate] - Filter by upload date start (optional)
  /// [endDate] - Filter by upload date end (optional)
  /// Returns list of documents matching the filter criteria
  Future<List<DocumentModel>> filterDocuments({
    String? category,
    String? status,
    String? fileType,
    String? userId,
    bool? isDeleted,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get recent documents (uploaded within last 7 days)
  ///
  /// [limit] - Maximum number of documents to fetch (optional)
  /// Returns list of recent documents
  Future<List<DocumentModel>> getRecentDocuments({int? limit});

  /// Get documents in recycle bin
  ///
  /// [limit] - Maximum number of documents to fetch (optional)
  /// Returns list of deleted documents
  Future<List<DocumentModel>> getDeletedDocuments({int? limit});

  /// Get documents by category
  ///
  /// [category] - Category name to filter by
  /// [limit] - Maximum number of documents to fetch (optional)
  /// Returns list of documents in the specified category
  Future<List<DocumentModel>> getDocumentsByCategory(
    String category, {
    int? limit,
  });

  /// Get documents uploaded by a specific user
  ///
  /// [userId] - User ID to filter by
  /// [limit] - Maximum number of documents to fetch (optional)
  /// Returns list of documents uploaded by the user
  Future<List<DocumentModel>> getDocumentsByUser(String userId, {int? limit});

  /// Get document statistics
  ///
  /// Returns a map containing various document statistics
  Future<Map<String, dynamic>> getDocumentStatistics();

  /// Refresh documents from remote source
  ///
  /// [forceRefresh] - Force refresh even if cache is valid
  /// Returns updated list of documents
  Future<List<DocumentModel>> refreshDocuments({bool forceRefresh = false});

  /// Check if document exists
  ///
  /// [id] - Document ID to check
  /// Returns true if document exists, false otherwise
  Future<bool> documentExists(String id);

  /// Get total document count
  ///
  /// [includeDeleted] - Whether to include deleted documents in count
  /// Returns total number of documents
  Future<int> getDocumentCount({bool includeDeleted = false});

  /// Sync documents with external sources
  ///
  /// Performs synchronization with Firebase Storage and other sources
  /// Returns true if sync was successful, false otherwise
  Future<bool> syncDocuments();

  /// Bulk delete multiple documents
  ///
  /// [documentIds] - List of document IDs to delete
  /// [userId] - ID of user performing the deletion
  /// Returns true if all deletions were successful, false otherwise
  Future<bool> bulkDeleteDocuments(List<String> documentIds, String userId);
}
