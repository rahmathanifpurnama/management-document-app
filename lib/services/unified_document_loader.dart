import 'package:flutter/foundation.dart';
import '../models/document_model.dart';
import '../services/firebase_storage_direct_service.dart';

/// Simplified document loader - Direct Firebase Storage access without caching
class UnifiedDocumentLoader {
  static UnifiedDocumentLoader? _instance;
  static UnifiedDocumentLoader get instance =>
      _instance ??= UnifiedDocumentLoader._();

  UnifiedDocumentLoader._();

  // Single loading state to prevent race conditions
  bool _isLoading = false;
  final FirebaseStorageDirectService _storageService =
      FirebaseStorageDirectService.instance;

  // Current documents (no caching, always fresh)
  List<DocumentModel> _currentDocuments = [];

  /// Load all documents directly from Firebase Storage - no caching
  Future<List<DocumentModel>> loadAllDocuments({
    bool forceRefresh = false,
    Function(bool isLoading)? onLoadingStateChanged,
  }) async {
    // Prevent concurrent loading operations
    if (_isLoading && !forceRefresh) {
      debugPrint(
        '📋 Document loading already in progress, returning current data',
      );
      return _currentDocuments;
    }

    _isLoading = true;
    onLoadingStateChanged?.call(true);

    try {
      debugPrint('📋 Loading documents directly from Firebase Storage...');

      // Direct Firebase Storage access - no cache, always fresh
      final documents = await _storageService.getAllFilesFromStorage();

      if (documents.isNotEmpty) {
        _currentDocuments = documents;
        debugPrint(
          '✅ Direct storage loading complete: ${documents.length} documents loaded',
        );
      } else {
        debugPrint('⚠️ No documents found in Firebase Storage');
        _currentDocuments = [];
      }

      return _currentDocuments;
    } catch (e) {
      debugPrint('❌ Direct storage loading failed: $e');
      // Return empty list on error instead of cached data
      return [];
    } finally {
      _isLoading = false;
      onLoadingStateChanged?.call(false);
    }
  }

  /// Get available documents for category selection (uncategorized files)
  List<DocumentModel> getAvailableDocuments({String searchQuery = ''}) {
    var availableDocuments = _currentDocuments
        .where((doc) => doc.category.isEmpty || doc.category == 'uncategorized')
        .toList();

    // Apply search filter if provided
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase().trim();
      availableDocuments = availableDocuments.where((document) {
        final fileName = document.fileName.toLowerCase();
        final description = document.metadata.description.toLowerCase();
        final fileType = document.fileType.toLowerCase();

        return fileName.contains(query) ||
            description.contains(query) ||
            fileType.contains(query);
      }).toList();
    }

    debugPrint(
      '📋 Available documents: ${availableDocuments.length} (search: "$searchQuery")',
    );
    return availableDocuments;
  }

  /// Get documents by category
  List<DocumentModel> getDocumentsByCategory(String categoryId) {
    final categoryDocuments = _currentDocuments
        .where((doc) => doc.category == categoryId)
        .toList();

    debugPrint(
      '📋 Category "$categoryId" documents: ${categoryDocuments.length}',
    );
    return categoryDocuments;
  }

  /// Get recent documents
  List<DocumentModel> getRecentDocuments({int limit = 10}) {
    final recentDocuments = List<DocumentModel>.from(_currentDocuments)
      ..sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));

    final result = recentDocuments.take(limit).toList();
    debugPrint('📋 Recent documents: ${result.length}');
    return result;
  }

  /// Force refresh - reload from Firebase Storage
  Future<List<DocumentModel>> refreshCache({
    Function(bool isLoading)? onLoadingStateChanged,
  }) async {
    debugPrint('📋 Force refreshing from Firebase Storage...');
    return await loadAllDocuments(
      forceRefresh: true,
      onLoadingStateChanged: onLoadingStateChanged,
    );
  }

  /// Clear current documents
  void clearCache() {
    _currentDocuments.clear();
    debugPrint('📋 Current documents cleared');
  }

  /// Get current state info
  Map<String, dynamic> getCacheInfo() {
    return {
      'currentDocuments': _currentDocuments.length,
      'isLoading': _isLoading,
    };
  }

  /// Dispose resources
  void dispose() {
    _currentDocuments.clear();
    _isLoading = false;
    debugPrint('📋 UnifiedDocumentLoader disposed');
  }
}
