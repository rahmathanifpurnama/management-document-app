import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/document_model.dart';
import '../core/services/document_service.dart';
import '../core/config/anr_config.dart';
import '../config/firebase_config.dart';
import '../core/utils/anr_prevention.dart';

/// Unified document loader to eliminate race conditions and ensure consistent data loading
class UnifiedDocumentLoader {
  static UnifiedDocumentLoader? _instance;
  static UnifiedDocumentLoader get instance =>
      _instance ??= UnifiedDocumentLoader._();

  UnifiedDocumentLoader._();

  // Single loading state to prevent race conditions
  bool _isLoading = false;
  final DocumentService _documentService = DocumentService.instance;

  // Cache for loaded documents
  List<DocumentModel> _cachedDocuments = [];
  DateTime? _lastLoadTime;
  static const Duration _cacheValidDuration = Duration(minutes: 5);

  /// Load all documents with unified approach - eliminates race conditions
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

    // Check cache validity
    if (!forceRefresh && _isCacheValid()) {
      debugPrint(
        '📋 Returning cached documents (${_cachedDocuments.length} items)',
      );
      return _cachedDocuments;
    }

    _isLoading = true;
    onLoadingStateChanged?.call(true);

    try {
      debugPrint('📋 Starting unified document loading...');

      // Single source of truth - load all documents at once
      final documents = await _loadDocumentsWithRetry();

      if (documents.isNotEmpty) {
        _cachedDocuments = documents;
        _lastLoadTime = DateTime.now();

        debugPrint(
          '✅ Unified loading complete: ${documents.length} documents loaded',
        );
      } else {
        debugPrint('⚠️ No documents loaded, keeping existing cache');
      }

      return _cachedDocuments;
    } catch (e) {
      debugPrint('❌ Unified document loading failed: $e');
      // Return cached data on error
      return _cachedDocuments;
    } finally {
      _isLoading = false;
      onLoadingStateChanged?.call(false);
    }
  }

  /// Load documents with retry mechanism
  Future<List<DocumentModel>> _loadDocumentsWithRetry() async {
    const maxRetries = 3;

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        debugPrint('📋 Loading attempt $attempt/$maxRetries');

        // ENTERPRISE SCALE: Use unlimited loading for comprehensive data access
        final documents = await _documentService.getAllDocuments(
          limit: FirebaseConfig.shouldEnableUnlimitedFiles
              ? null // No limit for enterprise mode
              : ANRConfig.defaultPageSize *
                    2, // Increased limit for standard mode
        );

        if (documents.isNotEmpty) {
          return documents;
        }

        if (attempt < maxRetries) {
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
  List<DocumentModel> getAvailableDocuments({String searchQuery = ''}) {
    var availableDocuments = _cachedDocuments
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
    if (_lastLoadTime == null || _cachedDocuments.isEmpty) {
      return false;
    }

    final now = DateTime.now();
    final cacheAge = now.difference(_lastLoadTime!);
    return cacheAge < _cacheValidDuration;
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
