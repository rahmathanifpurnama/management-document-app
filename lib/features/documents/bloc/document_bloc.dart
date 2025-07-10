import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/document_model.dart';
import '../repositories/document_repository.dart';
import '../repositories/document_repository_impl.dart';
import 'document_event.dart';
import 'document_state.dart';

/// Document BLoC
///
/// This BLoC manages all document-related business logic and state.
/// It replaces the DocumentProvider with a more structured approach.
///
/// Features:
/// - Document loading and caching
/// - Search and filtering
/// - Real-time updates
/// - Sorting capabilities
/// - Error handling
/// - Pagination support
class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final DocumentRepository _repository;
  StreamSubscription<List<DocumentModel>>? _documentsSubscription;

  // Current filter and search state
  String _currentSearchQuery = '';
  String _currentCategory = 'all';
  String _currentStatus = 'all';
  String _currentFileType = 'all';
  String? _currentUserId;
  String _currentSortBy = 'uploadedAt';
  bool _currentSortAscending = false;

  DocumentBloc({DocumentRepository? repository})
    : _repository = repository ?? DocumentRepositoryImpl.instance,
      super(const DocumentState.initial()) {
    // Register event handlers
    on<LoadDocuments>(_onLoadDocuments);
    on<SearchDocuments>(_onSearchDocuments);
    on<FilterDocuments>(_onFilterDocuments);
    on<SortDocuments>(_onSortDocuments);
    on<DeleteDocument>(_onDeleteDocument);
    on<PermanentlyDeleteDocument>(_onPermanentlyDeleteDocument);
    on<RestoreDocument>(_onRestoreDocument);
    on<UpdateDocument>(_onUpdateDocument);
    on<RefreshDocuments>(_onRefreshDocuments);
    on<LoadRecentDocuments>(_onLoadRecentDocuments);
    on<LoadDeletedDocuments>(_onLoadDeletedDocuments);
    on<LoadDocumentsByCategory>(_onLoadDocumentsByCategory);
    on<LoadDocumentsByUser>(_onLoadDocumentsByUser);
    on<LoadDocumentStatistics>(_onLoadDocumentStatistics);
    on<SyncDocuments>(_onSyncDocuments);
    on<ClearFilters>(_onClearFilters);
    on<StartListening>(_onStartListening);
    on<StopListening>(_onStopListening);
    on<DocumentsUpdated>(_onDocumentsUpdated);
    on<LoadMoreDocuments>(_onLoadMoreDocuments);
    on<ResetState>(_onResetState);

    // Auto-load documents on initialization
    add(const LoadDocuments());
  }

  /// Load documents
  Future<void> _onLoadDocuments(
    LoadDocuments event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      emit(const DocumentState.loading(message: 'Loading documents...'));

      final documents = await _repository.getAllDocuments(
        limit: event.limit,
        startAfter: event.startAfter,
      );

      final filteredDocuments = _applyFiltersAndSort(documents);

      emit(
        DocumentState.loaded(
          documents: documents,
          filteredDocuments: filteredDocuments,
          searchQuery: _currentSearchQuery,
          selectedCategory: _currentCategory,
          selectedStatus: _currentStatus,
          selectedFileType: _currentFileType,
          selectedUserId: _currentUserId,
          sortBy: _currentSortBy,
          sortAscending: _currentSortAscending,
          lastLoadTime: DateTime.now(),
        ),
      );

      debugPrint('📄 DocumentBloc: Loaded ${documents.length} documents');
    } catch (e) {
      emit(
        DocumentState.error(
          message: 'Failed to load documents: ${e.toString()}',
          canRetry: true,
        ),
      );
      debugPrint('❌ DocumentBloc: Error loading documents: $e');
    }
  }

  /// Search documents
  Future<void> _onSearchDocuments(
    SearchDocuments event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      _currentSearchQuery = event.query;

      final currentState = state;
      if (currentState is DocumentLoaded) {
        final filteredDocuments = _applyFiltersAndSort(currentState.documents);

        emit(
          currentState.copyWith(
            filteredDocuments: filteredDocuments,
            searchQuery: _currentSearchQuery,
          ),
        );
      } else {
        // If no documents loaded yet, load them first
        add(const LoadDocuments());
      }

      debugPrint('🔍 DocumentBloc: Searching for "${event.query}"');
    } catch (e) {
      emit(
        DocumentState.error(
          message: 'Search failed: ${e.toString()}',
          previousState: state,
          canRetry: true,
        ),
      );
      debugPrint('❌ DocumentBloc: Error searching documents: $e');
    }
  }

  /// Filter documents
  Future<void> _onFilterDocuments(
    FilterDocuments event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      // Update filter state
      _currentCategory = event.category ?? _currentCategory;
      _currentStatus = event.status ?? _currentStatus;
      _currentFileType = event.fileType ?? _currentFileType;
      _currentUserId = event.userId ?? _currentUserId;

      final currentState = state;
      if (currentState is DocumentLoaded) {
        final filteredDocuments = _applyFiltersAndSort(currentState.documents);

        emit(
          currentState.copyWith(
            filteredDocuments: filteredDocuments,
            selectedCategory: _currentCategory,
            selectedStatus: _currentStatus,
            selectedFileType: _currentFileType,
            selectedUserId: _currentUserId,
          ),
        );
      } else {
        // If no documents loaded yet, load them first
        add(const LoadDocuments());
      }

      debugPrint(
        '🔍 DocumentBloc: Applied filters - Category: $_currentCategory, Status: $_currentStatus, FileType: $_currentFileType',
      );
    } catch (e) {
      emit(
        DocumentState.error(
          message: 'Filter failed: ${e.toString()}',
          previousState: state,
          canRetry: true,
        ),
      );
      debugPrint('❌ DocumentBloc: Error filtering documents: $e');
    }
  }

  /// Sort documents
  Future<void> _onSortDocuments(
    SortDocuments event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      _currentSortBy = event.sortBy;
      _currentSortAscending = event.ascending;

      final currentState = state;
      if (currentState is DocumentLoaded) {
        final filteredDocuments = _applyFiltersAndSort(currentState.documents);

        emit(
          currentState.copyWith(
            filteredDocuments: filteredDocuments,
            sortBy: _currentSortBy,
            sortAscending: _currentSortAscending,
          ),
        );
      }

      debugPrint(
        '📊 DocumentBloc: Sorted by $_currentSortBy (ascending: $_currentSortAscending)',
      );
    } catch (e) {
      emit(
        DocumentState.error(
          message: 'Sort failed: ${e.toString()}',
          previousState: state,
          canRetry: true,
        ),
      );
      debugPrint('❌ DocumentBloc: Error sorting documents: $e');
    }
  }

  /// Delete document
  Future<void> _onDeleteDocument(
    DeleteDocument event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is DocumentLoaded) {
        emit(
          DocumentState.performingOperation(
            operation: 'Deleting document...',
            currentDocuments: currentState.documents,
            filteredDocuments: currentState.filteredDocuments,
            searchQuery: currentState.searchQuery,
            selectedCategory: currentState.selectedCategory,
            selectedStatus: currentState.selectedStatus,
            selectedFileType: currentState.selectedFileType,
            selectedUserId: currentState.selectedUserId,
            sortBy: currentState.sortBy,
            sortAscending: currentState.sortAscending,
            isListening: currentState.isListening,
          ),
        );
      }

      final success = await _repository.deleteDocument(
        event.documentId,
        event.userId,
      );

      if (success) {
        // Refresh documents to reflect changes
        add(const RefreshDocuments());
        debugPrint('🗑️ DocumentBloc: Document deleted successfully');
      } else {
        throw Exception('Failed to delete document');
      }
    } catch (e) {
      emit(
        DocumentState.error(
          message: 'Failed to delete document: ${e.toString()}',
          previousState: state,
          canRetry: true,
        ),
      );
      debugPrint('❌ DocumentBloc: Error deleting document: $e');
    }
  }

  /// Permanently delete document
  Future<void> _onPermanentlyDeleteDocument(
    PermanentlyDeleteDocument event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is DocumentLoaded) {
        emit(
          DocumentState.performingOperation(
            operation: 'Permanently deleting document...',
            currentDocuments: currentState.documents,
            filteredDocuments: currentState.filteredDocuments,
            searchQuery: currentState.searchQuery,
            selectedCategory: currentState.selectedCategory,
            selectedStatus: currentState.selectedStatus,
            selectedFileType: currentState.selectedFileType,
            selectedUserId: currentState.selectedUserId,
            sortBy: currentState.sortBy,
            sortAscending: currentState.sortAscending,
            isListening: currentState.isListening,
          ),
        );
      }

      final success = await _repository.permanentlyDeleteDocument(
        event.documentId,
        event.userId,
      );

      if (success) {
        // Refresh documents to reflect changes
        add(const RefreshDocuments());
        debugPrint(
          '🗑️ DocumentBloc: Document permanently deleted successfully',
        );
      } else {
        throw Exception('Failed to permanently delete document');
      }
    } catch (e) {
      emit(
        DocumentState.error(
          message: 'Failed to permanently delete document: ${e.toString()}',
          previousState: state,
          canRetry: true,
        ),
      );
      debugPrint('❌ DocumentBloc: Error permanently deleting document: $e');
    }
  }

  /// Apply filters and sorting to documents
  List<DocumentModel> _applyFiltersAndSort(List<DocumentModel> documents) {
    var filtered = documents.where((doc) {
      // Search filter
      if (_currentSearchQuery.isNotEmpty) {
        final query = _currentSearchQuery.toLowerCase();
        final matchesSearch =
            doc.fileName.toLowerCase().contains(query) ||
            doc.category.toLowerCase().contains(query) ||
            (doc.searchTerms?.any(
                  (term) => term.toLowerCase().contains(query),
                ) ??
                false);
        if (!matchesSearch) return false;
      }

      // Category filter
      if (_currentCategory != 'all') {
        final docCategory = doc.category.isEmpty
            ? 'uncategorized'
            : doc.category;
        if (docCategory != _currentCategory) return false;
      }

      // File type filter
      if (_currentFileType != 'all') {
        if (doc.fileType != _currentFileType) return false;
      }

      // User filter
      if (_currentUserId != null) {
        if (doc.uploadedBy != _currentUserId) return false;
      }

      // Status filter (deleted/active)
      if (_currentStatus == 'active' && doc.isDeleted) return false;
      if (_currentStatus == 'deleted' && !doc.isDeleted) return false;

      return true;
    }).toList();

    // Apply sorting
    filtered.sort((a, b) {
      int comparison = 0;

      switch (_currentSortBy) {
        case 'fileName':
          comparison = a.fileName.compareTo(b.fileName);
          break;
        case 'fileSize':
          comparison = a.fileSize.compareTo(b.fileSize);
          break;
        case 'fileType':
          comparison = a.fileType.compareTo(b.fileType);
          break;
        case 'category':
          comparison = a.category.compareTo(b.category);
          break;
        case 'uploadedBy':
          comparison = a.uploadedBy.compareTo(b.uploadedBy);
          break;
        case 'uploadedAt':
        default:
          comparison = a.uploadedAt.compareTo(b.uploadedAt);
          break;
      }

      return _currentSortAscending ? comparison : -comparison;
    });

    return filtered;
  }

  /// Restore document
  Future<void> _onRestoreDocument(
    RestoreDocument event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is DocumentLoaded) {
        emit(
          DocumentState.performingOperation(
            operation: 'Restoring document...',
            currentDocuments: currentState.documents,
            filteredDocuments: currentState.filteredDocuments,
            searchQuery: currentState.searchQuery,
            selectedCategory: currentState.selectedCategory,
            selectedStatus: currentState.selectedStatus,
            selectedFileType: currentState.selectedFileType,
            selectedUserId: currentState.selectedUserId,
            sortBy: currentState.sortBy,
            sortAscending: currentState.sortAscending,
            isListening: currentState.isListening,
          ),
        );
      }

      final success = await _repository.restoreDocument(
        event.documentId,
        event.userId,
      );

      if (success) {
        // Refresh documents to reflect changes
        add(const RefreshDocuments());
        debugPrint('♻️ DocumentBloc: Document restored successfully');
      } else {
        throw Exception('Failed to restore document');
      }
    } catch (e) {
      emit(
        DocumentState.error(
          message: 'Failed to restore document: ${e.toString()}',
          previousState: state,
          canRetry: true,
        ),
      );
      debugPrint('❌ DocumentBloc: Error restoring document: $e');
    }
  }

  /// Update document
  Future<void> _onUpdateDocument(
    UpdateDocument event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is DocumentLoaded) {
        emit(
          DocumentState.performingOperation(
            operation: 'Updating document...',
            currentDocuments: currentState.documents,
            filteredDocuments: currentState.filteredDocuments,
            searchQuery: currentState.searchQuery,
            selectedCategory: currentState.selectedCategory,
            selectedStatus: currentState.selectedStatus,
            selectedFileType: currentState.selectedFileType,
            selectedUserId: currentState.selectedUserId,
            sortBy: currentState.sortBy,
            sortAscending: currentState.sortAscending,
            isListening: currentState.isListening,
          ),
        );
      }

      final success = await _repository.updateDocument(event.document);

      if (success) {
        // Refresh documents to reflect changes
        add(const RefreshDocuments());
        debugPrint('📝 DocumentBloc: Document updated successfully');
      } else {
        throw Exception('Failed to update document');
      }
    } catch (e) {
      emit(
        DocumentState.error(
          message: 'Failed to update document: ${e.toString()}',
          previousState: state,
          canRetry: true,
        ),
      );
      debugPrint('❌ DocumentBloc: Error updating document: $e');
    }
  }

  /// Refresh documents
  Future<void> _onRefreshDocuments(
    RefreshDocuments event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      final documents = await _repository.refreshDocuments(
        forceRefresh: event.forceRefresh,
      );

      final filteredDocuments = _applyFiltersAndSort(documents);

      emit(
        DocumentState.loaded(
          documents: documents,
          filteredDocuments: filteredDocuments,
          searchQuery: _currentSearchQuery,
          selectedCategory: _currentCategory,
          selectedStatus: _currentStatus,
          selectedFileType: _currentFileType,
          selectedUserId: _currentUserId,
          sortBy: _currentSortBy,
          sortAscending: _currentSortAscending,
          lastLoadTime: DateTime.now(),
        ),
      );

      debugPrint('🔄 DocumentBloc: Documents refreshed successfully');
    } catch (e) {
      emit(
        DocumentState.error(
          message: 'Failed to refresh documents: ${e.toString()}',
          canRetry: true,
        ),
      );
      debugPrint('❌ DocumentBloc: Error refreshing documents: $e');
    }
  }

  /// Load recent documents
  Future<void> _onLoadRecentDocuments(
    LoadRecentDocuments event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      emit(const DocumentState.loading(message: 'Loading recent documents...'));

      final documents = await _repository.getRecentDocuments(
        limit: event.limit,
      );
      final filteredDocuments = _applyFiltersAndSort(documents);

      emit(
        DocumentState.loaded(
          documents: documents,
          filteredDocuments: filteredDocuments,
          searchQuery: _currentSearchQuery,
          selectedCategory: _currentCategory,
          selectedStatus: _currentStatus,
          selectedFileType: _currentFileType,
          selectedUserId: _currentUserId,
          sortBy: _currentSortBy,
          sortAscending: _currentSortAscending,
          lastLoadTime: DateTime.now(),
        ),
      );

      debugPrint(
        '📅 DocumentBloc: Loaded ${documents.length} recent documents',
      );
    } catch (e) {
      emit(
        DocumentState.error(
          message: 'Failed to load recent documents: ${e.toString()}',
          canRetry: true,
        ),
      );
      debugPrint('❌ DocumentBloc: Error loading recent documents: $e');
    }
  }

  /// Load deleted documents
  Future<void> _onLoadDeletedDocuments(
    LoadDeletedDocuments event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      emit(
        const DocumentState.loading(message: 'Loading deleted documents...'),
      );

      final documents = await _repository.getDeletedDocuments(
        limit: event.limit,
      );
      final filteredDocuments = _applyFiltersAndSort(documents);

      emit(
        DocumentState.loaded(
          documents: documents,
          filteredDocuments: filteredDocuments,
          searchQuery: _currentSearchQuery,
          selectedCategory: _currentCategory,
          selectedStatus: _currentStatus,
          selectedFileType: _currentFileType,
          selectedUserId: _currentUserId,
          sortBy: _currentSortBy,
          sortAscending: _currentSortAscending,
          lastLoadTime: DateTime.now(),
        ),
      );

      debugPrint(
        '🗑️ DocumentBloc: Loaded ${documents.length} deleted documents',
      );
    } catch (e) {
      emit(
        DocumentState.error(
          message: 'Failed to load deleted documents: ${e.toString()}',
          canRetry: true,
        ),
      );
      debugPrint('❌ DocumentBloc: Error loading deleted documents: $e');
    }
  }

  /// Load documents by category
  Future<void> _onLoadDocumentsByCategory(
    LoadDocumentsByCategory event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      emit(
        const DocumentState.loading(
          message: 'Loading documents by category...',
        ),
      );

      final documents = await _repository.getDocumentsByCategory(
        event.category,
        limit: event.limit,
      );
      final filteredDocuments = _applyFiltersAndSort(documents);

      emit(
        DocumentState.loaded(
          documents: documents,
          filteredDocuments: filteredDocuments,
          searchQuery: _currentSearchQuery,
          selectedCategory: event.category,
          selectedStatus: _currentStatus,
          selectedFileType: _currentFileType,
          selectedUserId: _currentUserId,
          sortBy: _currentSortBy,
          sortAscending: _currentSortAscending,
          lastLoadTime: DateTime.now(),
        ),
      );

      debugPrint(
        '📁 DocumentBloc: Loaded ${documents.length} documents in category ${event.category}',
      );
    } catch (e) {
      emit(
        DocumentState.error(
          message: 'Failed to load documents by category: ${e.toString()}',
          canRetry: true,
        ),
      );
      debugPrint('❌ DocumentBloc: Error loading documents by category: $e');
    }
  }

  /// Load documents by user
  Future<void> _onLoadDocumentsByUser(
    LoadDocumentsByUser event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      emit(
        const DocumentState.loading(message: 'Loading documents by user...'),
      );

      final documents = await _repository.getDocumentsByUser(
        event.userId,
        limit: event.limit,
      );
      final filteredDocuments = _applyFiltersAndSort(documents);

      emit(
        DocumentState.loaded(
          documents: documents,
          filteredDocuments: filteredDocuments,
          searchQuery: _currentSearchQuery,
          selectedCategory: _currentCategory,
          selectedStatus: _currentStatus,
          selectedFileType: _currentFileType,
          selectedUserId: event.userId,
          sortBy: _currentSortBy,
          sortAscending: _currentSortAscending,
          lastLoadTime: DateTime.now(),
        ),
      );

      debugPrint(
        '👤 DocumentBloc: Loaded ${documents.length} documents by user ${event.userId}',
      );
    } catch (e) {
      emit(
        DocumentState.error(
          message: 'Failed to load documents by user: ${e.toString()}',
          canRetry: true,
        ),
      );
      debugPrint('❌ DocumentBloc: Error loading documents by user: $e');
    }
  }

  /// Load document statistics
  Future<void> _onLoadDocumentStatistics(
    LoadDocumentStatistics event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is DocumentLoaded) {
        final statistics = await _repository.getDocumentStatistics();

        emit(currentState.copyWith(statistics: statistics));
        debugPrint('📊 DocumentBloc: Document statistics loaded');
      } else {
        // Load documents first, then statistics
        add(const LoadDocuments());
      }
    } catch (e) {
      emit(
        DocumentState.error(
          message: 'Failed to load document statistics: ${e.toString()}',
          previousState: state,
          canRetry: true,
        ),
      );
      debugPrint('❌ DocumentBloc: Error loading document statistics: $e');
    }
  }

  /// Sync documents
  Future<void> _onSyncDocuments(
    SyncDocuments event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is DocumentLoaded) {
        emit(
          DocumentState.syncing(
            message: 'Syncing documents with external sources...',
            currentDocuments: currentState.documents,
            filteredDocuments: currentState.filteredDocuments,
          ),
        );
      } else {
        emit(const DocumentState.loading(message: 'Syncing documents...'));
      }

      final success = await _repository.syncDocuments();

      if (success) {
        // Refresh documents after sync
        add(const RefreshDocuments(forceRefresh: true));
        debugPrint('🔄 DocumentBloc: Documents synced successfully');
      } else {
        throw Exception('Sync operation failed');
      }
    } catch (e) {
      emit(
        DocumentState.error(
          message: 'Failed to sync documents: ${e.toString()}',
          previousState: state,
          canRetry: true,
        ),
      );
      debugPrint('❌ DocumentBloc: Error syncing documents: $e');
    }
  }

  /// Clear filters
  Future<void> _onClearFilters(
    ClearFilters event,
    Emitter<DocumentState> emit,
  ) async {
    _currentSearchQuery = '';
    _currentCategory = 'all';
    _currentStatus = 'all';
    _currentFileType = 'all';
    _currentUserId = null;

    final currentState = state;
    if (currentState is DocumentLoaded) {
      final filteredDocuments = _applyFiltersAndSort(currentState.documents);

      emit(
        currentState.copyWith(
          filteredDocuments: filteredDocuments,
          searchQuery: _currentSearchQuery,
          selectedCategory: _currentCategory,
          selectedStatus: _currentStatus,
          selectedFileType: _currentFileType,
          selectedUserId: _currentUserId,
        ),
      );
    }

    debugPrint('🧹 DocumentBloc: Filters cleared');
  }

  /// Start listening to real-time updates
  Future<void> _onStartListening(
    StartListening event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      _documentsSubscription?.cancel();
      _documentsSubscription = _repository.watchDocuments().listen(
        (documents) {
          add(DocumentsUpdated(documents: documents));
        },
        onError: (error) {
          debugPrint('❌ DocumentBloc: Real-time stream error: $error');
        },
      );

      final currentState = state;
      if (currentState is DocumentLoaded) {
        emit(currentState.copyWith(isListening: true));
      }

      debugPrint('👁️ DocumentBloc: Started real-time listening');
    } catch (e) {
      debugPrint('❌ DocumentBloc: Error starting real-time listening: $e');
    }
  }

  /// Stop listening to real-time updates
  Future<void> _onStopListening(
    StopListening event,
    Emitter<DocumentState> emit,
  ) async {
    _documentsSubscription?.cancel();
    _documentsSubscription = null;

    final currentState = state;
    if (currentState is DocumentLoaded) {
      emit(currentState.copyWith(isListening: false));
    }

    debugPrint('🛑 DocumentBloc: Stopped real-time listening');
  }

  /// Handle real-time document updates
  Future<void> _onDocumentsUpdated(
    DocumentsUpdated event,
    Emitter<DocumentState> emit,
  ) async {
    final filteredDocuments = _applyFiltersAndSort(event.documents);

    final currentState = state;
    if (currentState is DocumentLoaded) {
      emit(
        currentState.copyWith(
          documents: event.documents,
          filteredDocuments: filteredDocuments,
          lastLoadTime: DateTime.now(),
        ),
      );
    } else {
      emit(
        DocumentState.loaded(
          documents: event.documents,
          filteredDocuments: filteredDocuments,
          searchQuery: _currentSearchQuery,
          selectedCategory: _currentCategory,
          selectedStatus: _currentStatus,
          selectedFileType: _currentFileType,
          selectedUserId: _currentUserId,
          sortBy: _currentSortBy,
          sortAscending: _currentSortAscending,
          isListening: true,
          lastLoadTime: DateTime.now(),
        ),
      );
    }

    debugPrint(
      '🔄 DocumentBloc: Real-time update received - ${event.documents.length} documents',
    );
  }

  /// Load more documents (pagination)
  Future<void> _onLoadMoreDocuments(
    LoadMoreDocuments event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is! DocumentLoaded) return;

      emit(
        DocumentState.loadingMore(
          currentDocuments: currentState.documents,
          filteredDocuments: currentState.filteredDocuments,
          searchQuery: currentState.searchQuery,
          selectedCategory: currentState.selectedCategory,
          selectedStatus: currentState.selectedStatus,
          selectedFileType: currentState.selectedFileType,
          selectedUserId: currentState.selectedUserId,
          sortBy: currentState.sortBy,
          sortAscending: currentState.sortAscending,
          isListening: currentState.isListening,
        ),
      );

      final lastDocument = currentState.documents.isNotEmpty
          ? currentState.documents.last
          : null;

      final moreDocuments = await _repository.getAllDocuments(
        limit: event.limit ?? 20,
        startAfter: lastDocument,
      );

      if (moreDocuments.isNotEmpty) {
        final allDocuments = [...currentState.documents, ...moreDocuments];
        final filteredDocuments = _applyFiltersAndSort(allDocuments);

        emit(
          currentState.copyWith(
            documents: allDocuments,
            filteredDocuments: filteredDocuments,
            hasMoreDocuments: moreDocuments.length >= (event.limit ?? 20),
          ),
        );

        debugPrint(
          '📄 DocumentBloc: Loaded ${moreDocuments.length} more documents',
        );
      } else {
        emit(currentState.copyWith(hasMoreDocuments: false));
        debugPrint('📄 DocumentBloc: No more documents to load');
      }
    } catch (e) {
      emit(
        DocumentState.error(
          message: 'Failed to load more documents: ${e.toString()}',
          previousState: state,
          canRetry: true,
        ),
      );
      debugPrint('❌ DocumentBloc: Error loading more documents: $e');
    }
  }

  /// Reset state to initial
  Future<void> _onResetState(
    ResetState event,
    Emitter<DocumentState> emit,
  ) async {
    _documentsSubscription?.cancel();
    _documentsSubscription = null;

    _currentSearchQuery = '';
    _currentCategory = 'all';
    _currentStatus = 'all';
    _currentFileType = 'all';
    _currentUserId = null;
    _currentSortBy = 'uploadedAt';
    _currentSortAscending = false;

    emit(const DocumentState.initial());
    debugPrint('🔄 DocumentBloc: State reset to initial');
  }

  @override
  Future<void> close() {
    _documentsSubscription?.cancel();
    // Remove repository dispose call since it's not defined in interface
    return super.close();
  }
}
