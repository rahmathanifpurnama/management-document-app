import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../models/document_model.dart';

part 'document_event.freezed.dart';

/// Document Events for DocumentBloc
///
/// These events represent all possible actions that can be performed
/// on documents in the application.
@freezed
class DocumentEvent with _$DocumentEvent {
  /// Load all documents
  ///
  /// [forceRefresh] - Force refresh even if cache is valid
  /// [limit] - Maximum number of documents to load (optional)
  /// [startAfter] - Document to start after for pagination (optional)
  const factory DocumentEvent.loadDocuments({
    @Default(false) bool forceRefresh,
    int? limit,
    DocumentModel? startAfter,
  }) = LoadDocuments;

  /// Search documents by query
  ///
  /// [query] - Search query string
  /// [limit] - Maximum number of results (optional)
  const factory DocumentEvent.searchDocuments({
    required String query,
    int? limit,
  }) = SearchDocuments;

  /// Filter documents by criteria
  ///
  /// [category] - Filter by category (optional)
  /// [status] - Filter by status (optional)
  /// [fileType] - Filter by file type (optional)
  /// [userId] - Filter by uploader (optional)
  /// [isDeleted] - Filter by deletion status (optional)
  /// [startDate] - Filter by upload date start (optional)
  /// [endDate] - Filter by upload date end (optional)
  const factory DocumentEvent.filterDocuments({
    String? category,
    String? status,
    String? fileType,
    String? userId,
    bool? isDeleted,
    DateTime? startDate,
    DateTime? endDate,
  }) = FilterDocuments;

  /// Sort documents
  ///
  /// [sortBy] - Field to sort by (uploadedAt, fileName, fileSize, etc.)
  /// [ascending] - Sort order (true for ascending, false for descending)
  const factory DocumentEvent.sortDocuments({
    required String sortBy,
    @Default(false) bool ascending,
  }) = SortDocuments;

  /// Delete a document (move to recycle bin)
  ///
  /// [documentId] - ID of document to delete
  /// [userId] - ID of user performing the deletion
  const factory DocumentEvent.deleteDocument({
    required String documentId,
    required String userId,
  }) = DeleteDocument;

  /// Permanently delete a document from recycle bin
  ///
  /// [documentId] - ID of document to permanently delete
  /// [userId] - ID of user performing the deletion
  const factory DocumentEvent.permanentlyDeleteDocument({
    required String documentId,
    required String userId,
  }) = PermanentlyDeleteDocument;

  /// Restore a document from recycle bin
  ///
  /// [documentId] - ID of document to restore
  /// [userId] - ID of user performing the restoration
  const factory DocumentEvent.restoreDocument({
    required String documentId,
    required String userId,
  }) = RestoreDocument;

  /// Update document metadata
  ///
  /// [document] - Updated document model
  const factory DocumentEvent.updateDocument({
    required DocumentModel document,
  }) = UpdateDocument;

  /// Refresh documents from remote source
  ///
  /// [forceRefresh] - Force refresh even if cache is valid
  const factory DocumentEvent.refreshDocuments({
    @Default(true) bool forceRefresh,
  }) = RefreshDocuments;

  /// Load recent documents (uploaded within last 7 days)
  ///
  /// [limit] - Maximum number of documents to load (optional)
  const factory DocumentEvent.loadRecentDocuments({int? limit}) =
      LoadRecentDocuments;

  /// Load documents in recycle bin
  ///
  /// [limit] - Maximum number of documents to load (optional)
  const factory DocumentEvent.loadDeletedDocuments({int? limit}) =
      LoadDeletedDocuments;

  /// Load documents by category
  ///
  /// [category] - Category name to filter by
  /// [limit] - Maximum number of documents to load (optional)
  const factory DocumentEvent.loadDocumentsByCategory({
    required String category,
    int? limit,
  }) = LoadDocumentsByCategory;

  /// Load documents by user
  ///
  /// [userId] - User ID to filter by
  /// [limit] - Maximum number of documents to load (optional)
  const factory DocumentEvent.loadDocumentsByUser({
    required String userId,
    int? limit,
  }) = LoadDocumentsByUser;

  /// Load document statistics
  const factory DocumentEvent.loadDocumentStatistics() = LoadDocumentStatistics;

  /// Sync documents with external sources
  const factory DocumentEvent.syncDocuments() = SyncDocuments;

  /// Clear search query and filters
  const factory DocumentEvent.clearFilters() = ClearFilters;

  /// Start real-time document listening
  const factory DocumentEvent.startListening() = StartListening;

  /// Stop real-time document listening
  const factory DocumentEvent.stopListening() = StopListening;

  /// Handle real-time document updates
  ///
  /// [documents] - Updated list of documents from stream
  const factory DocumentEvent.documentsUpdated({
    required List<DocumentModel> documents,
  }) = DocumentsUpdated;

  /// Bulk delete multiple documents
  ///
  /// [documentIds] - List of document IDs to delete
  /// [userId] - ID of user performing the deletion
  const factory DocumentEvent.bulkDeleteDocuments({
    required List<String> documentIds,
    required String userId,
  }) = BulkDeleteDocuments;

  /// Load more documents (pagination)
  ///
  /// [limit] - Number of additional documents to load
  const factory DocumentEvent.loadMoreDocuments({int? limit}) =
      LoadMoreDocuments;

  /// Reset document state to initial
  const factory DocumentEvent.resetState() = ResetState;
}
