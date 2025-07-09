import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/document_model.dart';
import '../core/services/document_service.dart';
import '../core/config/anr_config.dart';
import '../config/firebase_config.dart';
import '../core/utils/circuit_breaker.dart';

/// Unified document loader to eliminate race conditions and ensure consistent data loading
class UnifiedDocumentLoader {
  static UnifiedDocumentLoader? _instance;
  static UnifiedDocumentLoader get instance =>
      _instance ??= UnifiedDocumentLoader._();

  UnifiedDocumentLoader._();

  // Single loading state to prevent race conditions
  bool _isLoading = false;

  // Lazy-loaded DocumentService to prevent Firebase initialization errors
  DocumentService? _documentService;
  DocumentService get documentService =>
      _documentService ??= DocumentService.instance;

  // Cache for loaded documents
  List<DocumentModel> _cachedDocuments = [];
  DateTime? _lastLoadTime;
  static const Duration _cacheValidDuration = Duration(minutes: 5);

  /// ENHANCED: Load documents with Firebase Storage priority
  Future<List<DocumentModel>> loadAllDocuments({
    bool forceRefresh = false,
    Function(bool isLoading)? onLoadingStateChanged,
  }) async {
    // Prevent concurrent loading operations
    if (_isLoading && !forceRefresh) {
      debugPrint(
        '📋 Document loading already in progress, returning cached data',
      );
      return _cachedDocuments;
    }

    // ENHANCED: Check cache validity but prioritize Firebase Storage consistency
    if (!forceRefresh && _isCacheValid() && _cachedDocuments.isNotEmpty) {
      debugPrint(
        '📋 Returning cached documents (${_cachedDocuments.length} items)',
      );
      debugPrint(
        '⚠️ Note: Using cached data - may not reflect current Firebase Storage state',
      );
      return _cachedDocuments;
    }

    // FIXED: Always load if cache is empty, regardless of validity
    if (_cachedDocuments.isEmpty) {
      debugPrint('📋 Cache is empty, forcing document load...');
    }

    _isLoading = true;
    onLoadingStateChanged?.call(true);

    try {
      // REDUCED LOGGING: Only log when actually starting, not on every call

      // ENHANCED: Load documents with Firebase Storage awareness
      final documents = await _loadDocumentsWithRetry();

      if (documents.isNotEmpty) {
        _cachedDocuments = documents;
        _lastLoadTime = DateTime.now();

        // REDUCED LOGGING: Simplified success message
        debugPrint('✅ Unified loader: ${documents.length} documents loaded');
      } else {
        // REDUCED LOGGING: Simplified empty message
        debugPrint('⚠️ Unified loader: No documents found');
      }

      return _cachedDocuments;
    } catch (e) {
      // REDUCED LOGGING: Simplified error message
      debugPrint('❌ Unified loader failed: $e');
      // Return cached data on error
      return _cachedDocuments;
    } finally {
      _isLoading = false;
      onLoadingStateChanged?.call(false);
    }
  }

  /// Load documents with retry mechanism (respects empty state)
  Future<List<DocumentModel>> _loadDocumentsWithRetry() async {
    // EMPTY STATE FIX: Check if storage is confirmed empty before retrying
    if (CircuitBreaker.isCircuitOpen('storage_empty_state') ||
        CircuitBreaker.isCircuitOpen('prevent_empty_storage_retries')) {
      debugPrint(
        '📋 Unified loader: Empty storage confirmed - skipping retry attempts',
      );
      return [];
    }

    const maxRetries = 2; // Reduced from 3 to 2 to minimize logs

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        debugPrint('📋 Loading attempt $attempt/$maxRetries');

        // ENTERPRISE SCALE: Use unlimited loading for comprehensive data access
        final documents = await documentService.getAllDocuments(
          limit: FirebaseConfig.shouldEnableUnlimitedFiles
              ? null // No limit for enterprise mode
              : ANRConfig.defaultPageSize *
                    2, // Increased limit for standard mode
        );

        if (documents.isNotEmpty) {
          debugPrint(
            '✅ Loading attempt $attempt successful: ${documents.length} documents',
          );
          return documents;
        } else {
          debugPrint('⚠️ Loading attempt $attempt returned empty results');

          // SIMPLIFIED: If first attempt is empty, continue with retries
          // (Removed storage check since we're using Firestore as primary source)
        }

        if (attempt < maxRetries) {
          debugPrint('🔄 Retrying in ${500 * attempt}ms...');
          await Future.delayed(Duration(milliseconds: 500 * attempt));
        }
      } catch (e) {
        debugPrint('❌ Loading attempt $attempt failed: $e');
        if (attempt == maxRetries) rethrow;

        // Exponential backoff
        await Future.delayed(Duration(milliseconds: 1000 * attempt));
      }
    }

    return [];
  }

  /// Get available documents for category selection (uncategorized files)
  /// ENHANCED: Improved filtering logic for better file visibility
  List<DocumentModel> getAvailableDocuments({
    String searchQuery = '',
    String? excludeCategoryId,
  }) {
    // Get documents that are uncategorized or have empty category
    // FIXED: Include files with null category and improve filtering logic
    var availableDocuments = _cachedDocuments.where((doc) {
      final category = doc.category.trim();
      final isUncategorized = category.isEmpty || category == 'null';

      // If excluding a specific category, also include files from that category
      if (excludeCategoryId != null && category == excludeCategoryId) {
        return false; // Don't show files already in the target category
      }

      return isUncategorized;
    }).toList();

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

    // Sort by upload date (newest first) for better UX
    availableDocuments.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));

    debugPrint(
      '📋 Available documents: ${availableDocuments.length} (search: "$searchQuery", excludeCategory: $excludeCategoryId)',
    );
    return availableDocuments;
  }

  /// Get documents by category
  List<DocumentModel> getDocumentsByCategory(String categoryId) {
    final categoryDocuments = _cachedDocuments
        .where((doc) => doc.category == categoryId)
        .toList();

    debugPrint(
      '📋 Category "$categoryId" documents: ${categoryDocuments.length}',
    );
    return categoryDocuments;
  }

  /// Get recent documents
  List<DocumentModel> getRecentDocuments({int limit = 10}) {
    final recentDocuments = List<DocumentModel>.from(_cachedDocuments)
      ..sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));

    final result = recentDocuments.take(limit).toList();
    debugPrint('📋 Recent documents: ${result.length}');
    return result;
  }

  /// Check if cache is valid
  bool _isCacheValid() {
    // FIXED: Cache is invalid if we have no load time or if it's too old
    if (_lastLoadTime == null) {
      debugPrint('📋 Cache invalid: No load time recorded');
      return false;
    }

    final now = DateTime.now();
    final cacheAge = now.difference(_lastLoadTime!);
    final isValid = cacheAge < _cacheValidDuration;

    if (!isValid) {
      debugPrint(
        '📋 Cache invalid: Age ${cacheAge.inMinutes} minutes exceeds ${_cacheValidDuration.inMinutes} minutes',
      );
    }

    return isValid;
  }

  /// Force refresh cache
  Future<List<DocumentModel>> refreshCache({
    Function(bool isLoading)? onLoadingStateChanged,
  }) async {
    debugPrint('📋 Force refreshing document cache...');
    return await loadAllDocuments(
      forceRefresh: true,
      onLoadingStateChanged: onLoadingStateChanged,
    );
  }

  /// ENHANCED: Synchronize with DocumentProvider to ensure data consistency
  Future<void> syncWithDocumentProvider() async {
    try {
      debugPrint('📋 Syncing UnifiedDocumentLoader with DocumentProvider...');

      // Force refresh to get latest data
      await refreshCache();

      debugPrint('✅ UnifiedDocumentLoader sync completed');
    } catch (e) {
      debugPrint('❌ Failed to sync UnifiedDocumentLoader: $e');
    }
  }

  /// ENHANCED: Update document category in cache
  void updateDocumentCategory(String documentId, String newCategoryId) {
    final docIndex = _cachedDocuments.indexWhere((doc) => doc.id == documentId);
    if (docIndex != -1) {
      final updatedDoc = _cachedDocuments[docIndex].copyWith(
        category: newCategoryId,
      );
      _cachedDocuments[docIndex] = updatedDoc;
      debugPrint(
        '📋 Updated document $documentId category to $newCategoryId in cache',
      );
    }
  }

  /// Clear cache
  void clearCache() {
    _cachedDocuments.clear();
    _lastLoadTime = null;
    debugPrint('📋 Document cache cleared');
  }

  /// Get cache info
  Map<String, dynamic> getCacheInfo() {
    return {
      'cachedDocuments': _cachedDocuments.length,
      'lastLoadTime': _lastLoadTime?.toIso8601String(),
      'cacheAge': _lastLoadTime != null
          ? DateTime.now().difference(_lastLoadTime!).inMinutes
          : null,
      'isValid': _isCacheValid(),
      'isLoading': _isLoading,
    };
  }

  /// Dispose resources
  void dispose() {
    _cachedDocuments.clear();
    _lastLoadTime = null;
    _isLoading = false;
    debugPrint('📋 UnifiedDocumentLoader disposed');
  }
}
