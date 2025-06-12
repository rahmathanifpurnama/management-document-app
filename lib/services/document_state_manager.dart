import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/document_model.dart';
import '../core/config/anr_config.dart';
import 'firebase_storage_direct_service.dart';

/// ARCHITECTURAL FIX: Centralized document state management
/// Provides single source of truth for document data with atomic operations
class DocumentStateManager {
  static DocumentStateManager? _instance;
  static DocumentStateManager get instance => _instance ??= DocumentStateManager._();
  
  DocumentStateManager._();

  // Core data storage
  List<DocumentModel> _documents = [];
  DateTime? _lastRefresh;
  bool _isRefreshing = false;
  
  // Cache configuration
  static const Duration _cacheExpiry = Duration(minutes: 5);
  
  // Services
  final FirebaseStorageDirectService _storageService = FirebaseStorageDirectService.instance;
  
  // Stream controller for real-time updates
  final StreamController<List<DocumentModel>> _documentsController = 
      StreamController<List<DocumentModel>>.broadcast();
  
  /// Stream of document updates
  Stream<List<DocumentModel>> get documentsStream => _documentsController.stream;
  
  /// Current documents (read-only)
  List<DocumentModel> get documents => List.unmodifiable(_documents);
  
  /// Check if cache is valid
  bool get _isCacheValid {
    if (_lastRefresh == null) return false;
    return DateTime.now().difference(_lastRefresh!) < _cacheExpiry;
  }
  
  /// Get documents with automatic refresh if needed
  Future<List<DocumentModel>> getDocuments({bool forceRefresh = false}) async {
    // Return cached data if valid and not forcing refresh
    if (!forceRefresh && _isCacheValid && _documents.isNotEmpty) {
      debugPrint('📋 Returning cached documents: ${_documents.length} files');
      return documents;
    }
    
    // Refresh data if needed
    await refreshDocuments();
    return documents;
  }
  
  /// Get recent documents with limit
  List<DocumentModel> getRecentDocuments({int limit = 50}) {
    final sortedDocs = List<DocumentModel>.from(_documents);
    sortedDocs.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
    
    final safeLimit = limit > ANRConfig.maxItemsPerPage 
        ? ANRConfig.maxItemsPerPage 
        : limit;
    
    return sortedDocs.take(safeLimit).toList();
  }
  
  /// ATOMIC OPERATION: Refresh documents from Firebase Storage
  Future<void> refreshDocuments() async {
    // Prevent concurrent refresh operations
    if (_isRefreshing) {
      debugPrint('⚠️ Document refresh already in progress, waiting...');
      // Wait for current refresh to complete
      while (_isRefreshing) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return;
    }
    
    _isRefreshing = true;
    
    try {
      debugPrint('🔄 Starting atomic document refresh...');
      
      // Fetch fresh data from Firebase Storage
      final freshDocuments = await _storageService.getAllFilesFromStorage();
      
      if (freshDocuments.isNotEmpty) {
        // ATOMIC UPDATE: Replace all data at once
        _documents = freshDocuments;
        _lastRefresh = DateTime.now();
        
        // Notify listeners
        _documentsController.add(documents);
        
        debugPrint('✅ Atomic refresh completed: ${_documents.length} documents');
      } else {
        debugPrint('⚠️ No documents received from storage, keeping existing data');
      }
    } catch (e) {
      debugPrint('❌ Document refresh failed: $e');
      // Keep existing data on error
    } finally {
      _isRefreshing = false;
    }
  }
  
  /// Add new document to state
  void addDocument(DocumentModel document) {
    // Check for duplicates
    final existingIndex = _documents.indexWhere((doc) => doc.id == document.id);
    
    if (existingIndex != -1) {
      // Update existing document
      _documents[existingIndex] = document;
      debugPrint('📝 Updated existing document: ${document.fileName}');
    } else {
      // Add new document
      _documents.add(document);
      debugPrint('➕ Added new document: ${document.fileName}');
    }
    
    // Re-sort by upload time
    _documents.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
    
    // Notify listeners
    _documentsController.add(documents);
  }
  
  /// Remove document from state
  void removeDocument(String documentId) {
    final removedCount = _documents.length;
    _documents.removeWhere((doc) => doc.id == documentId);
    
    if (_documents.length < removedCount) {
      debugPrint('🗑️ Removed document: $documentId');
      // Notify listeners
      _documentsController.add(documents);
    }
  }
  
  /// Update document in state
  void updateDocument(DocumentModel updatedDocument) {
    final index = _documents.indexWhere((doc) => doc.id == updatedDocument.id);
    
    if (index != -1) {
      _documents[index] = updatedDocument;
      debugPrint('📝 Updated document: ${updatedDocument.fileName}');
      
      // Re-sort by upload time
      _documents.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
      
      // Notify listeners
      _documentsController.add(documents);
    }
  }
  
  /// Clear all data (for logout or reset)
  void clearData() {
    _documents.clear();
    _lastRefresh = null;
    _documentsController.add(documents);
    debugPrint('🧹 Document state cleared');
  }
  
  /// Get cache status information
  Map<String, dynamic> getCacheStatus() {
    return {
      'documentCount': _documents.length,
      'lastRefresh': _lastRefresh?.toIso8601String(),
      'cacheValid': _isCacheValid,
      'isRefreshing': _isRefreshing,
      'cacheAge': _lastRefresh != null 
          ? DateTime.now().difference(_lastRefresh!).inMinutes 
          : null,
    };
  }
  
  /// Dispose resources
  void dispose() {
    _documentsController.close();
  }
}
