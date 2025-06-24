import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import '../models/document_model.dart';
import '../core/services/document_service.dart';
import '../core/services/firebase_service.dart';
import '../core/services/category_service.dart';
// REMOVED: Sync services that created duplicate documents
import '../services/file_category_management_service.dart';
import '../services/cloud_functions_service.dart';
import '../core/config/anr_config.dart';
import '../core/config/feature_flags.dart';
import '../config/firebase_config.dart';
import 'category_provider.dart';

import '../services/enhanced_document_service.dart';
import '../services/enhanced_firebase_storage_service.dart';
import '../services/enhanced_auth_service.dart';

// UNIFIED ID SYSTEM: Import new architectural services
import '../core/services/unified_id_system.dart';
import '../core/services/smart_cache_invalidation.dart';
import '../core/services/id_reconciliation_service.dart';
import '../services/document_state_manager.dart';
import '../services/unified_document_loader.dart';
import '../services/direct_storage_deletion_service.dart';
import '../services/optimized_deletion_service.dart';
import '../services/statistics_notification_service.dart';
import '../core/utils/circuit_breaker.dart';
import '../core/utils/empty_storage_state_manager.dart';

class DocumentProvider extends ChangeNotifier {
  List<DocumentModel> _documents = [];
  List<DocumentModel> _filteredDocuments = [];

  String? _errorMessage;
  bool _isLoading = false;

  // REMOVED: Global filter state variables - now handled by screen-specific filter states
  // String _searchQuery = '';
  // String _selectedCategory = 'all';
  // String _selectedStatus = 'all';
  // String _selectedFileType = 'all';
  // String _sortBy = 'uploadedAt';
  // bool _sortAscending = false;

  // ARCHITECTURAL FIX: State management for atomic operations
  bool _isRefreshingRecentFiles = false;
  bool _isAtomicUpdateInProgress = false;

  // ENTERPRISE SCALE: Auto-initialization flag
  bool _autoInitialized = false;

  // RACE CONDITION FIX: Track last load time to prevent unnecessary force refreshes
  DateTime? _lastLoadTime;

  // ENHANCED SURGICAL FIX: Track recently assigned files with persistent storage
  // This prevents files from reappearing in "Add Files to Category" screen during Firebase sync delays
  final Map<String, String> _recentlyAssignedFiles =
      {}; // documentId -> categoryId
  final Map<String, DateTime> _assignmentTimestamps =
      {}; // documentId -> timestamp

  // PERSISTENT FIX: Track assignments that persist across app sessions
  final Map<String, String> _persistentAssignments =
      {}; // documentId -> categoryId
  bool _persistentTrackingLoaded = false;

  // Enhanced services
  final EnhancedDocumentService _enhancedDocumentService =
      EnhancedDocumentService.instance;

  // ENTERPRISE SCALE: Constructor with auto-initialization
  DocumentProvider() {
    // Initialize empty storage state manager
    _initializeEmptyStorageManager();

    // FIXED: Always auto-initialize regardless of enterprise mode to ensure files load
    if (!_autoInitialized) {
      _autoInitialized = true;
      debugPrint('🚀 DocumentProvider: Scheduling auto-initialization...');
      // Schedule initialization after the provider is created
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _autoInitializeDocuments();
      });

      // REMOVED: Immediate cache loading to prevent showing cached count
      // This ensures statistics show 0 until Firebase Storage loads
      debugPrint(
        '🚀 DocumentProvider: Cache loading disabled to prevent count flickering',
      );
    }
  }

  /// Initialize empty storage state manager
  Future<void> _initializeEmptyStorageManager() async {
    await EmptyStorageStateManager.instance.initialize();
  }

  final EnhancedFirebaseStorageService _enhancedStorageService =
      EnhancedFirebaseStorageService.instance;
  final EnhancedAuthService _enhancedAuthService = EnhancedAuthService.instance;

  // ARCHITECTURAL FIX: Centralized state management
  final DocumentStateManager _stateManager = DocumentStateManager.instance;

  // UNIFIED LOADING: Use unified document loader to eliminate race conditions
  final UnifiedDocumentLoader _unifiedLoader = UnifiedDocumentLoader.instance;

  // OPTIMIZED DELETION: Services for improved deletion performance
  final DirectStorageDeletionService _directStorageService =
      DirectStorageDeletionService.instance;
  final OptimizedDeletionService _optimizedDeletionService =
      OptimizedDeletionService.instance;

  // STATISTICS NOTIFICATION: Service for real-time statistics updates
  final StatisticsNotificationService _statisticsService =
      StatisticsNotificationService.instance;

  // UNIFIED ID SYSTEM: New architectural services
  final UnifiedIdSystem _unifiedIdSystem = UnifiedIdSystem.instance;
  final SmartCacheInvalidation _cacheInvalidation =
      SmartCacheInvalidation.instance;
  final IdReconciliationService _reconciliationService =
      IdReconciliationService.instance;

  /// Handle unified documents from the unified loader
  /// ENHANCED: Better synchronization with UnifiedDocumentLoader
  void _handleUnifiedDocuments(List<DocumentModel> unifiedDocuments) {
    debugPrint('🔄 Processing ${unifiedDocuments.length} unified documents');

    // ENHANCED: Atomic update to prevent race conditions
    if (_isAtomicUpdateInProgress) {
      debugPrint(
        '⚠️ Atomic update in progress, skipping unified document handling',
      );
      return;
    }

    _isAtomicUpdateInProgress = true;

    try {
      // Clear existing data
      documents.clear();

      // Add unified documents
      documents.addAll(unifiedDocuments);

      // Notify listeners - filtering now handled by screen-specific states
      notifyListeners();

      debugPrint('✅ Unified documents processed successfully');
    } finally {
      _isAtomicUpdateInProgress = false;
    }
  }

  /// ENHANCED: Synchronize with UnifiedDocumentLoader for data consistency
  Future<void> syncWithUnifiedLoader() async {
    try {
      debugPrint('🔄 Syncing DocumentProvider with UnifiedDocumentLoader...');

      // Get latest data from UnifiedDocumentLoader
      final unifiedDocuments = await _unifiedLoader.loadAllDocuments(
        forceRefresh: true,
      );

      if (unifiedDocuments.isNotEmpty) {
        _handleUnifiedDocuments(unifiedDocuments);
        await _saveToStorage();
        notifyListeners();
      }

      debugPrint(
        '✅ DocumentProvider sync with UnifiedDocumentLoader completed',
      );
    } catch (e) {
      debugPrint('❌ Failed to sync with UnifiedDocumentLoader: $e');
    }
  }

  /// ENHANCED: Auto-initialize documents with Firebase Storage priority
  Future<void> _autoInitializeDocuments() async {
    // Check if we should skip loading due to confirmed empty state
    final emptyStateManager = EmptyStorageStateManager.instance;

    if (emptyStateManager.shouldSkipLoading()) {
      debugPrint(
        '🚫 AUTO-INIT: Skipping - empty storage state confirmed and cached',
      );
      return;
    }

    // FIXED: Don't skip if documents are empty - that's exactly when we need to load
    if (_isLoadingDocuments) {
      debugPrint(
        '📋 Auto-initialization skipped - loading already in progress',
      );
      return;
    }

    debugPrint(
      '🚀 AUTO-INIT: Starting Firebase Storage-first initialization...',
    );

    try {
      // PRIORITY 1: Always try Firebase Storage first for consistency
      debugPrint('📁 AUTO-INIT: Attempting Firebase Storage direct load...');
      await _stateManager.refreshDocuments();

      final stateManagerDocs = _stateManager.documents;
      if (stateManagerDocs.isNotEmpty) {
        _documents = List.from(stateManagerDocs);
        notifyListeners(); // Filtering now handled by screen-specific states

        // Mark storage as not empty
        await emptyStateManager.setStorageNotEmpty();

        debugPrint(
          '✅ AUTO-INIT: Loaded ${_documents.length} documents from Firebase Storage',
        );
        return;
      }

      // Check if storage is actually empty before fallback
      if (stateManagerDocs.isEmpty &&
          !emptyStateManager.hasCheckedThisSession) {
        // Mark that we've checked and it's empty
        await emptyStateManager.setStorageEmpty();
        debugPrint(
          '📁 AUTO-INIT: Storage confirmed empty - no fallback needed',
        );
        return;
      }

      // PRIORITY 2: Fallback to regular loading if Storage check failed (not empty)
      if (!emptyStateManager.isEmptyStateConfirmed) {
        debugPrint(
          '📋 AUTO-INIT: Storage check failed, trying regular loading...',
        );
        await loadDocuments();
      }

      debugPrint('✅ AUTO-INIT: Auto-initialization completed');
    } catch (e) {
      debugPrint('❌ AUTO-INIT: Firebase Storage initialization failed: $e');

      if (_documents.isEmpty && !emptyStateManager.isEmptyStateConfirmed) {
        debugPrint('📊 AUTO-INIT: No documents loaded - may be empty storage');
      }
    }
  }

  /// Fallback to traditional loading if unified loader fails
  Future<void> _loadDocumentsTraditional() async {
    debugPrint('🔄 Falling back to traditional document loading...');

    try {
      // ENTERPRISE SCALE: Use unlimited loading for enterprise mode
      final limit = FirebaseConfig.shouldEnableUnlimitedFiles
          ? null // No limit for enterprise
          : ANRConfig.defaultPageSize;

      final documents = await _documentService.getAllDocuments(limit: limit);

      if (documents.isNotEmpty) {
        _handleFirebaseDocumentModels(documents);

        // RACE CONDITION FIX: Update last load time
        _lastLoadTime = DateTime.now();

        debugPrint(
          '✅ Traditional loading completed: ${documents.length} documents',
        );
      } else {
        debugPrint('📱 Traditional loading: No documents found');
      }
    } catch (e) {
      debugPrint('❌ Traditional loading failed: $e');
      // REMOVED: Cache fallback to prevent showing cached count
    }
  }

  /// Firebase Storage fallback when Firestore is empty
  Future<void> _loadFromFirebaseStorageFallback() async {
    // Use circuit breaker to prevent repeated failures
    final result = await CircuitBreaker.execute(
      'storage_fallback_loading',
      () async {
        debugPrint('📁 Loading documents directly from Firebase Storage...');

        // Use enhanced storage service to get all files
        final storageDocuments = await _enhancedStorageService
            .getAllStorageFilesUnlimited();

        if (storageDocuments.isNotEmpty) {
          debugPrint(
            '✅ Firebase Storage fallback: Found ${storageDocuments.length} files',
          );

          // Clear existing documents and add storage documents
          _documents.clear();
          _categoryDocuments.clear();

          // Process storage documents
          for (final doc in storageDocuments) {
            _addDocumentToLocal(doc);
          }

          await _saveToStorage();
          notifyListeners(); // Filtering now handled by screen-specific states

          debugPrint('✅ Firebase Storage fallback completed successfully');
          return true;
        } else {
          debugPrint('⚠️ Firebase Storage fallback: No files found');
          return false;
        }
      },
      operationName: 'Firebase Storage Fallback',
    );

    if (result == null) {
      debugPrint('🚫 Firebase Storage fallback blocked by circuit breaker');
    }
  }

  // Dynamic document storage - persists during app session
  static final Map<String, List<DocumentModel>> _categoryDocuments = {};
  static bool _isInitialized = false;

  // Firebase real-time listener
  final FirebaseService _firebaseService = FirebaseService.instance;
  final DocumentService _documentService = DocumentService.instance;
  StreamSubscription? _documentsSubscription;
  final bool _useFirebaseSync =
      true; // Enable Firebase sync for data persistence
  bool _isProcessingFirebaseUpdate = false; // Prevent duplicate processing
  Timer? _firebaseUpdateDebouncer; // Debounce Firebase updates
  bool _isLoadingDocuments = false; // Prevent concurrent document loading

  // Getters
  List<DocumentModel> get documents =>
      _documents; // Return all documents instead of filtered
  List<DocumentModel> get allDocuments => _documents;
  List<DocumentModel> get filteredDocuments =>
      _documents; // Return all documents - filtering now handled by screen-specific states

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isFirebaseSyncActive => _documentsSubscription != null;

  // REMOVED: Filter state getters - now handled by screen-specific filter states
  // String get searchQuery => _searchQuery;
  // String get selectedFileType => _selectedFileType;
  // String get selectedCategory => _selectedCategory;
  // String get selectedStatus => _selectedStatus;
  // String get sortBy => _sortBy;
  // bool get sortAscending => _sortAscending;

  // RACE CONDITION FIX: Getter for last load time
  DateTime? get lastLoadTime => _lastLoadTime;

  // REMOVED: hasActiveFilters getter - now handled by screen-specific filter states
  // bool get hasActiveFilters => ...

  // Helper methods for state management
  void _setLoading(bool loading, {bool notify = true}) {
    _isLoading = loading;
    if (notify) {
      notifyListeners();
    }
  }

  void _setError(String error, {bool notify = true}) {
    _errorMessage = error;
    if (notify) {
      notifyListeners();
    }
  }

  void _clearError() {
    _errorMessage = null;
  }

  // ENHANCED: Load documents with Firebase Storage priority
  Future<void> loadDocuments({bool forceRefresh = false}) async {
    final emptyStateManager = EmptyStorageStateManager.instance;

    // REMOVED: Database version tracking (not implemented in current database structure)
    // Only 4 collections exist: users, document-metadata, categories, activities

    // Check if we should skip loading due to confirmed empty state
    if (!forceRefresh && emptyStateManager.shouldSkipLoading()) {
      debugPrint(
        '🚫 Document loading skipped - empty storage state confirmed and cached',
      );
      return;
    }

    // Prevent concurrent loading operations unless force refresh is requested
    if (_isLoadingDocuments && !forceRefresh) {
      debugPrint('⚠️ Document loading already in progress, skipping...');
      return;
    }

    _isLoadingDocuments = true;
    _setLoading(
      true,
      notify: false,
    ); // Don't notify yet, will notify at the end
    _clearError();

    if (forceRefresh) {
      debugPrint('🔄 Force refreshing documents...');
      // Reset empty state on force refresh
      await emptyStateManager.resetEmptyState();
      // Reset circuit breakers on force refresh to allow retry
      CircuitBreaker.resetCircuit('unified_document_loading');
      CircuitBreaker.resetCircuit('storage_fallback_loading');
      CircuitBreaker.resetCircuit('storage_empty_check');
      CircuitBreaker.resetCircuit('prevent_empty_storage_retries');
    }

    try {
      debugPrint('🔄 Starting Firebase Storage-first document loading...');

      // PRIORITY 1: Try Firebase Storage first for consistency
      await _stateManager.refreshDocuments();
      final storageDocuments = _stateManager.documents;

      if (storageDocuments.isNotEmpty) {
        debugPrint(
          '✅ Loaded ${storageDocuments.length} documents from Firebase Storage',
        );

        // Update local state with Storage data
        _documents = List.from(storageDocuments);
        _isInitialized = true;

        // RACE CONDITION FIX: Update last load time
        _lastLoadTime = DateTime.now();

        await _saveToStorage();

        // SMART CACHE INVALIDATION: Mark cache as valid after successful load
        await _cacheInvalidation.markCacheAsValid(
          documentCount: _documents.length,
        );

        // Mark storage as not empty
        await emptyStateManager.setStorageNotEmpty();

        // Start Firebase listener for real-time updates
        if (_useFirebaseSync) {
          _startFirebaseListener();
        }

        debugPrint(
          '📊 File count matches Firebase Storage exactly: ${_documents.length} files',
        );
      } else {
        // EMPTY STATE FIX: Use EmptyStorageStateManager for proper empty state handling
        if (!emptyStateManager.hasCheckedThisSession) {
          // First time checking - confirm if storage is actually empty
          final documentsRef = _firebaseService.storage.ref().child(
            'documents',
          );
          final listResult = await documentsRef.listAll();

          if (listResult.items.isEmpty) {
            // Storage is confirmed empty
            await emptyStateManager.setStorageEmpty();
            debugPrint(
              '📁 Firebase Storage confirmed empty - cached for session',
            );

            // Clear local data to match empty storage
            _documents.clear();
            _isInitialized = true;
            await _saveToStorage();
            return; // Exit early, no fallback needed
          } else {
            // Storage has files but state manager didn't detect them
            emptyStateManager.markCheckedThisSession();
          }
        } else if (emptyStateManager.isEmptyStateConfirmed) {
          // Already confirmed empty in this session
          debugPrint('📁 Storage already confirmed empty - skipping fallbacks');
          _documents.clear();
          _isInitialized = true;
          await _saveToStorage();
          return; // Exit early, no fallback needed
        }

        // Only try fallbacks if storage is not confirmed empty
        if (!emptyStateManager.isEmptyStateConfirmed) {
          debugPrint('⚠️ Storage check inconclusive, trying unified loader...');
          final unifiedDocuments = await _unifiedLoader.loadAllDocuments(
            forceRefresh: forceRefresh,
            onLoadingStateChanged: (isLoading) {
              _isLoading = isLoading;
            },
          );

          if (unifiedDocuments.isNotEmpty) {
            _handleUnifiedDocuments(unifiedDocuments);
            _isInitialized = true;

            // RACE CONDITION FIX: Update last load time
            _lastLoadTime = DateTime.now();

            await _saveToStorage();
            await emptyStateManager.setStorageNotEmpty();

            if (_useFirebaseSync) {
              _startFirebaseListener();
            }
          } else {
            // FINAL FALLBACK: Traditional loading
            debugPrint('⚠️ Trying traditional loading as final fallback...');
            await _loadDocumentsTraditional();
          }
        }
      }

      // Filtering now handled by screen-specific states
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false, notify: false); // Don't notify here
      _isLoadingDocuments = false; // Reset loading flag

      // OPTIMIZED: Single notification at the end to prevent multiple UI rebuilds
      notifyListeners();
    }
  }

  // Start Firebase real-time listener for document updates with optimization
  void _startFirebaseListener() {
    try {
      // CRITICAL FIX: Only start listener if not already active
      if (_documentsSubscription != null) {
        debugPrint(
          '⚠️ Firebase listener already active, skipping duplicate listener',
        );
        return;
      }

      // ENTERPRISE SCALE: Use appropriate limit based on configuration
      final listenerLimit = FirebaseConfig.shouldEnableUnlimitedFiles
          ? ANRConfig
                .enterprisePageSize // Larger limit for enterprise
          : ANRConfig.defaultPageSize; // Standard limit for regular use

      _documentsSubscription = _firebaseService.firestore
          .collection('document-metadata')
          .where('isActive', isEqualTo: true) // Only get active documents
          .orderBy('uploadedAt', descending: true)
          .limit(
            listenerLimit,
          ) // Increased limit for better recent files coverage
          .snapshots()
          .listen(
            (snapshot) {
              _handleFirebaseDocumentUpdates(snapshot.docs);
            },
            onError: (error) {
              // REDUCED LOGGING: Only log Firebase listener errors, not every event
              debugPrint('❌ Firebase listener error: $error');
              _setError('Real-time sync temporarily unavailable');
            },
          );

      // REDUCED LOGGING: Only log listener start once, not repeatedly
      debugPrint('✅ Firebase listener started (limit: $listenerLimit)');
    } catch (e) {
      debugPrint('Failed to start Firebase listener: $e');
      // Continue with local data if Firebase setup fails
    }
  }

  // Handle Firebase document updates from snapshots
  void _handleFirebaseDocumentUpdates(List<QueryDocumentSnapshot> docs) {
    // REDUCED debounce time for faster UI updates and consistency
    _firebaseUpdateDebouncer?.cancel();
    _firebaseUpdateDebouncer = Timer(const Duration(milliseconds: 500), () {
      _processFirebaseDocumentUpdates(docs);
    });
  }

  // Process Firebase document updates (debounced)
  void _processFirebaseDocumentUpdates(List<QueryDocumentSnapshot> docs) {
    // Prevent duplicate processing or processing during initial load
    if (_isProcessingFirebaseUpdate || _isLoadingDocuments) {
      debugPrint(
        '⚠️ Firebase update already in progress or documents loading, skipping...',
      );
      return;
    }

    try {
      _isProcessingFirebaseUpdate = true;
      // REDUCED LOGGING: Only log significant changes and use controlled logging
      if (docs.length != _documents.length) {
        // Use controlled logging to reduce noise
        if (docs.isNotEmpty) {
          debugPrint('📥 Firebase listener: ${docs.length} documents updated');
        }
      }

      final firebaseDocuments = docs
          .map((doc) => DocumentModel.fromFirestore(doc as DocumentSnapshot))
          .toList();

      // SURGICAL FIX: Preserve recent assignments during Firebase listener updates
      final updatedFirebaseDocuments = firebaseDocuments.map((doc) {
        if (_recentlyAssignedFiles.containsKey(doc.id)) {
          final recentCategory = _recentlyAssignedFiles[doc.id]!;
          debugPrint(
            '🔒 Preserving recent assignment from listener for ${doc.fileName}: $recentCategory',
          );
          return doc.copyWith(category: recentCategory);
        }
        return doc;
      }).toList();

      // Merge Firebase documents with local documents
      _mergeFirebaseDocuments(updatedFirebaseDocuments, isFromListener: true);

      // Notify listeners - filtering now handled by screen-specific states
      notifyListeners();
    } catch (e) {
      debugPrint('Error handling Firebase updates: $e');
    } finally {
      _isProcessingFirebaseUpdate = false;
    }
  }

  // Handle Firebase document updates from DocumentModel list (for direct service calls)
  void _handleFirebaseDocumentModels(List<DocumentModel> firebaseDocuments) {
    try {
      debugPrint(
        '📥 Loading ${firebaseDocuments.length} documents from Firebase service',
      );

      // SURGICAL FIX: Preserve recent assignments during Firebase updates
      // This prevents race condition where Firebase data overwrites local changes
      final preservedAssignments = <String, DocumentModel>{};
      for (final doc in firebaseDocuments) {
        if (_recentlyAssignedFiles.containsKey(doc.id)) {
          final recentCategory = _recentlyAssignedFiles[doc.id]!;
          // Override Firebase data with recent local assignment
          preservedAssignments[doc.id] = doc.copyWith(category: recentCategory);
          debugPrint(
            '🔒 Preserving recent assignment for ${doc.fileName}: $recentCategory',
          );
        }
      }

      // Clear existing category documents to rebuild from Firebase data
      _categoryDocuments.clear();
      _documents.clear();

      // Apply preserved assignments to Firebase documents
      final updatedFirebaseDocuments = firebaseDocuments.map((doc) {
        return preservedAssignments[doc.id] ?? doc;
      }).toList();

      // Use the same merge logic to prevent duplicates
      _mergeFirebaseDocuments(updatedFirebaseDocuments, isFromListener: false);

      debugPrint(
        '✅ Rebuilt category documents: ${_categoryDocuments.keys.length} categories with ${_documents.length} total documents',
      );

      // Notify listeners - filtering now handled by screen-specific states
      notifyListeners();
    } catch (e) {
      debugPrint('Error handling Firebase updates: $e');
    }
  }

  // Merge Firebase documents with local storage (for real-time listener updates)
  void _mergeFirebaseDocuments(
    List<DocumentModel> firebaseDocuments, {
    bool isFromListener = false,
  }) {
    // Only show merge log for significant changes to reduce noise
    if (isFromListener && firebaseDocuments.length != _documents.length) {
      debugPrint('🔄 Merging ${firebaseDocuments.length} Firebase documents');
    }

    bool hasChanges = false;

    // Create a map of Firebase documents for quick lookup
    final firebaseDocMap = {for (var doc in firebaseDocuments) doc.id: doc};

    // For listener updates, we need to handle document additions, updates, and deletions
    if (isFromListener) {
      // Remove documents that no longer exist in Firebase
      final documentsToRemove = <String>[];
      for (final localDoc in _documents) {
        if (!firebaseDocMap.containsKey(localDoc.id)) {
          documentsToRemove.add(localDoc.id);
        }
      }

      for (final docId in documentsToRemove) {
        _removeDocumentFromLocal(docId);
        hasChanges = true;
      }
    }

    // Update or add documents from Firebase (unified logic for both listener and initial load)
    for (final firebaseDoc in firebaseDocuments) {
      final existingIndex = _documents.indexWhere(
        (doc) => doc.id == firebaseDoc.id,
      );

      if (existingIndex != -1) {
        // Update existing document only if it has changed
        final existingDoc = _documents[existingIndex];
        if (_hasDocumentChanged(existingDoc, firebaseDoc)) {
          _updateDocumentInLocal(existingDoc, firebaseDoc);
          hasChanges = true;
        }
      } else {
        // Add new document (with duplicate prevention)
        _addDocumentToLocal(firebaseDoc);
        hasChanges = true;
      }
    }

    // Only save if there were actual changes
    if (hasChanges) {
      _saveToStorage();
    }
  }

  // Helper method to add document to local storage
  void _addDocumentToLocal(DocumentModel document) {
    // ENHANCED DUPLICATE PREVENTION: Check by ID, file path, and file name
    final isDuplicateById = _documents.any((doc) => doc.id == document.id);
    final isDuplicateByPath = _documents.any(
      (doc) => doc.filePath == document.filePath,
    );
    final isDuplicateByNameAndSize = _documents.any(
      (doc) =>
          doc.fileName == document.fileName &&
          doc.fileSize == document.fileSize &&
          doc.uploadedAt.difference(document.uploadedAt).abs().inMinutes < 5,
    );

    if (isDuplicateById || isDuplicateByPath || isDuplicateByNameAndSize) {
      debugPrint(
        '⚠️ DUPLICATE DETECTED - Skipping: ${document.fileName} (ID: ${document.id}, Path: ${document.filePath})',
      );
      debugPrint(
        '   Duplicate reasons: ID=$isDuplicateById, Path=$isDuplicateByPath, Name+Size=$isDuplicateByNameAndSize',
      );
      return;
    }

    // Add to main documents list
    _documents.add(document);
    debugPrint('✅ Added document: ${document.fileName} (ID: ${document.id})');

    // Add to category storage
    if (!_categoryDocuments.containsKey(document.category)) {
      _categoryDocuments[document.category] = [];
    }

    // Check if already exists in category to prevent duplicates
    if (!_categoryDocuments[document.category]!.any(
      (doc) => doc.id == document.id,
    )) {
      _categoryDocuments[document.category]!.add(document);
      debugPrint(
        '✅ Added document to local storage: ${document.fileName} (Category: ${document.category})',
      );
    } else {
      debugPrint(
        '⚠️ Document already exists in category ${document.category}: ${document.fileName}',
      );
    }
  }

  // Helper method to update document in local storage
  void _updateDocumentInLocal(DocumentModel oldDoc, DocumentModel newDoc) {
    // Update in main documents list
    final mainIndex = _documents.indexWhere((doc) => doc.id == newDoc.id);
    if (mainIndex != -1) {
      _documents[mainIndex] = newDoc;
    }

    // Handle category change
    if (oldDoc.category != newDoc.category) {
      // Remove from old category
      if (_categoryDocuments.containsKey(oldDoc.category)) {
        _categoryDocuments[oldDoc.category]!.removeWhere(
          (doc) => doc.id == newDoc.id,
        );
      }

      // Add to new category
      if (!_categoryDocuments.containsKey(newDoc.category)) {
        _categoryDocuments[newDoc.category] = [];
      }
      _categoryDocuments[newDoc.category]!.add(newDoc);
    } else {
      // Update in same category
      if (_categoryDocuments.containsKey(newDoc.category)) {
        final categoryIndex = _categoryDocuments[newDoc.category]!.indexWhere(
          (doc) => doc.id == newDoc.id,
        );
        if (categoryIndex != -1) {
          _categoryDocuments[newDoc.category]![categoryIndex] = newDoc;
        }
      }
    }

    debugPrint(
      '🔄 Updated document in local storage: ${newDoc.fileName} (Category: ${newDoc.category})',
    );
  }

  // Helper method to remove document from local storage
  void _removeDocumentFromLocal(String documentId) {
    // Find and remove from category storage
    for (final entry in _categoryDocuments.entries) {
      entry.value.removeWhere((doc) => doc.id == documentId);
    }

    // Remove from main documents list
    _documents.removeWhere((doc) => doc.id == documentId);

    debugPrint('🗑️ Removed document from local storage: $documentId');
  }

  // Check if document has changed (to avoid unnecessary updates)
  bool _hasDocumentChanged(DocumentModel existing, DocumentModel updated) {
    return existing.fileName != updated.fileName ||
        existing.fileSize != updated.fileSize ||
        existing.category != updated.category ||
        existing.uploadedAt != updated.uploadedAt ||
        existing.metadata.description != updated.metadata.description;
  }

  // Add document
  void addDocument(DocumentModel document) {
    // Check if document already exists to prevent duplicates
    if (_documents.any((doc) => doc.id == document.id)) {
      debugPrint(
        '⚠️ Document with ID ${document.id} already exists, skipping duplicate',
      );
      return;
    }

    // Add to category-specific storage
    if (!_categoryDocuments.containsKey(document.category)) {
      _categoryDocuments[document.category] = [];
    }

    // Check if document already exists in category to prevent duplicates
    if (_categoryDocuments[document.category]!.any(
      (doc) => doc.id == document.id,
    )) {
      debugPrint(
        '⚠️ Document with ID ${document.id} already exists in category ${document.category}, skipping duplicate',
      );
      return;
    }

    _categoryDocuments[document.category]!.insert(0, document);

    // Update main documents list
    _documents.insert(0, document);
    debugPrint(
      '✅ Document ${document.fileName} added successfully (ID: ${document.id})',
    );

    // Save to storage for persistence
    _saveToStorage();

    // Notify listeners - filtering now handled by screen-specific states
    notifyListeners();
  }

  // Add document to specific category (for uploads)
  void addDocumentToCategory(DocumentModel document, String categoryId) {
    final updatedDocument = document.copyWith(category: categoryId);

    // Check if document already exists to prevent duplicates
    if (_documents.any((doc) => doc.id == updatedDocument.id)) {
      debugPrint(
        '⚠️ Document with ID ${updatedDocument.id} already exists, skipping duplicate',
      );
      return;
    }

    // Add to category-specific storage
    if (!_categoryDocuments.containsKey(categoryId)) {
      _categoryDocuments[categoryId] = [];
    }

    // Check if document already exists in category to prevent duplicates
    if (_categoryDocuments[categoryId]!.any(
      (doc) => doc.id == updatedDocument.id,
    )) {
      debugPrint(
        '⚠️ Document with ID ${updatedDocument.id} already exists in category $categoryId, skipping duplicate',
      );
      return;
    }

    _categoryDocuments[categoryId]!.insert(0, updatedDocument);

    // Update main documents list
    _documents.insert(0, updatedDocument);
    debugPrint(
      '✅ Document ${updatedDocument.fileName} added to category $categoryId successfully (ID: ${updatedDocument.id})',
    );

    // Save to storage for persistence
    _saveToStorage();

    // Notify listeners - filtering now handled by screen-specific states
    notifyListeners();
  }

  // Batch update multiple documents to category (more efficient)
  Future<void> updateMultipleDocumentsCategory(
    List<String> documentIds,
    String categoryId,
  ) async {
    try {
      debugPrint(
        '🔄 Updating ${documentIds.length} documents to category: $categoryId',
      );

      // First try to update via Cloud Functions for persistence
      try {
        final categoryProvider = CategoryProvider();
        await categoryProvider.addFilesToCategory(categoryId, documentIds);
        debugPrint('✅ Cloud Functions update successful');
      } catch (cloudError) {
        debugPrint('⚠️ Cloud Functions update failed: $cloudError');
        // Continue with local update and direct Firebase fallback
      }

      bool hasChanges = false;

      // Update documents locally for immediate UI feedback
      for (final documentId in documentIds) {
        final documentIndex = _documents.indexWhere(
          (doc) => doc.id == documentId,
        );
        if (documentIndex != -1) {
          final originalDocument = _documents[documentIndex];

          // Skip if already in the same category
          if (originalDocument.category == categoryId) {
            continue;
          }

          final updatedDocument = originalDocument.copyWith(
            category: categoryId,
          );

          // Update main documents list
          _documents[documentIndex] = updatedDocument;

          // Remove from old category storage
          if (_categoryDocuments.containsKey(originalDocument.category)) {
            _categoryDocuments[originalDocument.category]!.removeWhere(
              (doc) => doc.id == documentId,
            );
          }

          // Add to new category storage
          if (!_categoryDocuments.containsKey(categoryId)) {
            _categoryDocuments[categoryId] = [];
          }
          _categoryDocuments[categoryId]!.add(updatedDocument);

          hasChanges = true;

          // Also update in Firebase directly as fallback
          try {
            await _documentService.updateDocumentCategory(
              documentId,
              categoryId,
            );
          } catch (firebaseError) {
            debugPrint(
              '⚠️ Direct Firebase update failed for $documentId: $firebaseError',
            );
          }
        }
      }

      // Only notify once after all updates
      if (hasChanges) {
        notifyListeners();
        // Save to storage
        await _saveToStorage();
        debugPrint(
          '✅ Local updates completed for ${documentIds.length} documents',
        );
      }
    } catch (e) {
      debugPrint('❌ Failed to update documents category: $e');
      _setError('Failed to update documents category: $e');
      rethrow;
    }
  }

  // Update document category with Firebase Storage integration
  // FIXED: Update local cache first for immediate UI response, then sync with backend
  Future<void> updateDocumentCategory(
    String documentId,
    String categoryId,
  ) async {
    try {
      debugPrint('🔄 DocumentProvider: Starting category update...');
      debugPrint('   Document ID: $documentId');
      debugPrint('   Target Category: $categoryId');

      final documentIndex = _documents.indexWhere(
        (doc) => doc.id == documentId,
      );

      if (documentIndex == -1) {
        debugPrint('⚠️ Document not found in local cache: $documentId');
        throw Exception('Document not found in local cache');
      }

      final originalDocument = _documents[documentIndex];

      debugPrint(
        '✅ Document found in local cache: ${originalDocument.fileName}',
      );

      // Skip if already in the same category
      if (originalDocument.category == categoryId) {
        debugPrint('⚠️ Document already in target category, skipping update');
        return;
      }

      // STEP 1: Update local cache FIRST for immediate UI response
      final updatedDocument = originalDocument.copyWith(category: categoryId);

      // Update main documents list
      _documents[documentIndex] = updatedDocument;

      // Remove from old category storage
      if (_categoryDocuments.containsKey(originalDocument.category)) {
        _categoryDocuments[originalDocument.category]!.removeWhere(
          (doc) => doc.id == documentId,
        );
        debugPrint('✅ Removed from old category: ${originalDocument.category}');
      }

      // Add to new category storage
      if (!_categoryDocuments.containsKey(categoryId)) {
        _categoryDocuments[categoryId] = [];
      }
      _categoryDocuments[categoryId]!.add(updatedDocument);
      debugPrint('✅ Added to new category: $categoryId');

      // ENHANCED: Update UnifiedDocumentLoader cache for consistency
      _unifiedLoader.updateDocumentCategory(documentId, categoryId);

      // RACE CONDITION FIX: Mark this as a recent category assignment to prevent override
      _lastLoadTime = DateTime.now();

      // SURGICAL FIX: Track this assignment to prevent race condition reappearance
      _trackRecentAssignment(documentId, categoryId);

      // Notify listeners immediately for UI update
      notifyListeners();

      // Save to storage immediately with priority flag
      await _saveToStorage();

      debugPrint('✅ Local cache updated immediately with timestamp protection');

      // STEP 2: Update Firestore document-metadata (non-blocking for UI)
      try {
        await _updateFirestoreDocumentCategory(documentId, categoryId);
        debugPrint('✅ Firestore updated successfully');
      } catch (firestoreError) {
        debugPrint('⚠️ Firestore update failed: $firestoreError');
        // Don't rollback local changes - Firestore will be eventually consistent
      }

      // STEP 3: Update Firebase Storage (non-blocking for UI, graceful degradation)
      try {
        final fileCategoryService = FileCategoryManagementService();
        await fileCategoryService.moveFileToCategory(documentId, categoryId);
        debugPrint('✅ Firebase Storage updated successfully');
      } catch (storageError) {
        debugPrint('⚠️ Firebase Storage update failed: $storageError');
        // Don't rollback local changes - Storage organization is not critical for functionality
      }

      // STEP 4: Update category document count (non-blocking)
      try {
        await _updateCategoryDocumentCount(categoryId);
        debugPrint('✅ Category document count updated');
      } catch (countError) {
        debugPrint('⚠️ Category count update failed: $countError');
        // Don't rollback - count will be eventually consistent
      }

      debugPrint('✅ DocumentProvider: Category update completed successfully');
    } catch (e) {
      debugPrint('❌ DocumentProvider: Failed to update document category: $e');
      _setError('Failed to update document category: $e');
      rethrow;
    }
  }

  /// Update Firestore document-metadata with new category
  Future<void> _updateFirestoreDocumentCategory(
    String documentId,
    String categoryId,
  ) async {
    try {
      debugPrint('🔄 Updating Firestore document-metadata for: $documentId');
      debugPrint('   New category: $categoryId');

      await FirebaseFirestore.instance
          .collection('document-metadata')
          .doc(documentId)
          .update({
            'category': categoryId,
            'updatedAt': FieldValue.serverTimestamp(),
          });

      debugPrint('✅ Firestore document-metadata updated successfully');
    } catch (e) {
      debugPrint('❌ Failed to update Firestore document-metadata: $e');

      // ENHANCED: Try to create document if it doesn't exist
      if (e.toString().contains('No document to update')) {
        try {
          debugPrint('🔄 Document not found, attempting to create...');

          // Find document in local cache to get metadata
          final document = _documents.firstWhere(
            (doc) => doc.id == documentId,
            orElse: () => throw Exception('Document not found in local cache'),
          );

          await FirebaseFirestore.instance
              .collection('document-metadata')
              .doc(documentId)
              .set({
                'id': documentId,
                'fileName': document.fileName,
                'fileSize': document.fileSize,
                'fileType': document.fileType,
                'filePath': document.filePath,
                'uploadedBy': document.uploadedBy,
                'uploadedAt': document.uploadedAt,
                'category': categoryId,
                'permissions': document.permissions,
                'isActive': true,
                'createdAt': FieldValue.serverTimestamp(),
                'updatedAt': FieldValue.serverTimestamp(),
              });

          debugPrint('✅ Firestore document created successfully');
        } catch (createError) {
          debugPrint('❌ Failed to create Firestore document: $createError');
          // Don't throw - graceful degradation
        }
      }

      // Don't throw error - graceful degradation for eventual consistency
    }
  }

  /// Update category document count in Firestore
  Future<void> _updateCategoryDocumentCount(String categoryId) async {
    try {
      debugPrint('🔄 Updating category document count for: $categoryId');

      // Count documents in this category
      final documentsInCategory = _documents
          .where((doc) => doc.category == categoryId)
          .length;

      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .update({
            'documentCount': documentsInCategory,
            'updatedAt': FieldValue.serverTimestamp(),
          });

      debugPrint('✅ Category document count updated: $documentsInCategory');
    } catch (e) {
      debugPrint('❌ Failed to update category document count: $e');
      // Don't throw error as this is not critical for the operation
    }
  }

  // Remove file from category (set category to empty string, not uncategorized)
  Future<void> removeFileFromCategory(
    String documentId,
    String categoryId,
  ) async {
    try {
      debugPrint('🔄 Removing file $documentId from category $categoryId');

      // Update document in Firestore to have empty category
      await _documentService.updateDocumentCategory(documentId, '');

      final documentIndex = _documents.indexWhere(
        (doc) => doc.id == documentId,
      );

      if (documentIndex != -1) {
        final originalDocument = _documents[documentIndex];

        // Update document with empty category (not uncategorized)
        final updatedDocument = originalDocument.copyWith(category: '');

        // Update main documents list
        _documents[documentIndex] = updatedDocument;

        // Remove from category storage
        if (_categoryDocuments.containsKey(categoryId)) {
          _categoryDocuments[categoryId]!.removeWhere(
            (doc) => doc.id == documentId,
          );
        }

        // Don't add to any category - file becomes uncategorized but available for categorization

        // SURGICAL FIX: Clear recent assignment tracking when file is removed from category
        _recentlyAssignedFiles.remove(documentId);
        _assignmentTimestamps.remove(documentId);

        // PERSISTENT FIX: Also clear persistent assignment tracking
        if (_persistentAssignments.remove(documentId) != null) {
          _savePersistentAssignments();
          debugPrint(
            '🧹 Cleared persistent assignment for removed file: $documentId',
          );
        }

        debugPrint('✅ File $documentId removed from category $categoryId');

        // Notify listeners and save
        notifyListeners();
        await _saveToStorage();
      }
    } catch (e) {
      debugPrint('❌ Failed to remove file from category: $e');
      _setError('Failed to remove file from category: $e');
      rethrow;
    }
  }

  // Update document
  void updateDocument(DocumentModel document) {
    int index = _documents.indexWhere((d) => d.id == document.id);
    if (index != -1) {
      final oldDocument = _documents[index];
      _documents[index] = document;

      // Update category storage if category changed
      if (oldDocument.category != document.category) {
        // Remove from old category
        if (_categoryDocuments.containsKey(oldDocument.category)) {
          _categoryDocuments[oldDocument.category]!.removeWhere(
            (doc) => doc.id == document.id,
          );
        }

        // Add to new category
        if (!_categoryDocuments.containsKey(document.category)) {
          _categoryDocuments[document.category] = [];
        }
        _categoryDocuments[document.category]!.add(document);
      } else {
        // Update in same category
        if (_categoryDocuments.containsKey(document.category)) {
          final categoryIndex = _categoryDocuments[document.category]!
              .indexWhere((doc) => doc.id == document.id);
          if (categoryIndex != -1) {
            _categoryDocuments[document.category]![categoryIndex] = document;
          }
        }
      }

      // Notify listeners - filtering now handled by screen-specific states
      notifyListeners();
    }
  }

  // Remove document permanently (from Firebase Storage and Firestore)
  Future<void> removeDocument(String documentId, String deletedBy) async {
    try {
      debugPrint(
        '🗑️ DocumentProvider: Starting document removal for ID: $documentId',
      );

      // ADMIN-ONLY: Verify admin status before proceeding
      final isAdmin = await _verifyUserIsAdmin(deletedBy);
      if (!isAdmin) {
        throw Exception('Access denied: Only administrators can delete files');
      }

      // FEATURE FLAG: Use cloud function for deletion if enabled
      if (FeatureFlags.useCloudFunctionDelete) {
        await _deleteDocumentViaCloudFunction(documentId, deletedBy);
        return;
      }

      // ENHANCED FIX: Force refresh from Firestore before deletion to ensure we have latest data
      debugPrint('🔄 Refreshing documents from Firestore before deletion...');
      await _refreshDocumentsFromFirestore();

      // ENHANCED DELETE FIX: Find document in local cache first for better error handling
      DocumentModel? localDocument;
      String? categoryToRemoveFrom;

      // Find document in main list
      localDocument = _documents.firstWhere(
        (d) => d.id == documentId,
        orElse: () => DocumentModel(
          id: '',
          fileName: '',
          fileSize: 0,
          fileType: '',
          filePath: '',
          uploadedBy: '',
          uploadedAt: DateTime.now(),
          category: '',
          permissions: [],
          metadata: DocumentMetadata(description: '', tags: []),
        ),
      );

      // If not found in main list, search in category storage
      if (localDocument.id.isEmpty) {
        for (final entry in _categoryDocuments.entries) {
          final doc = entry.value.firstWhere(
            (d) => d.id == documentId,
            orElse: () => DocumentModel(
              id: '',
              fileName: '',
              fileSize: 0,
              fileType: '',
              filePath: '',
              uploadedBy: '',
              uploadedAt: DateTime.now(),
              category: '',
              permissions: [],
              metadata: DocumentMetadata(description: '', tags: []),
            ),
          );
          if (doc.id.isNotEmpty) {
            localDocument = doc;
            categoryToRemoveFrom = entry.key;
            debugPrint('📁 Found document in category: $categoryToRemoveFrom');
            break;
          }
        }
      }

      // Log what we found locally
      if (localDocument?.id.isNotEmpty == true) {
        debugPrint('✅ Found document locally: ${localDocument!.fileName}');
      } else {
        debugPrint('⚠️ Document not found in local cache: $documentId');
      }

      // OPTIMIZED DELETE: Use OptimizedDeletionService for comprehensive deletion handling
      bool backendDeletionSuccessful = false;
      String? backendError;
      String deletionMethod = 'unknown';

      try {
        // Use OptimizedDeletionService for intelligent deletion
        if (localDocument != null && localDocument.id.isNotEmpty) {
          debugPrint('🚀 Using OptimizedDeletionService for deletion...');

          final optimizedResult = await _optimizedDeletionService
              .deleteDocument(localDocument, deletedBy);

          if (optimizedResult.success) {
            debugPrint('✅ Optimized deletion completed successfully');
            backendDeletionSuccessful = true;
            deletionMethod = optimizedResult.methodName;

            debugPrint(
              '📊 Deletion stats: Storage=${optimizedResult.storageDeleted}, Firestore=${optimizedResult.firestoreDeleted}, Duration=${optimizedResult.formattedDuration}',
            );
          } else {
            debugPrint(
              '❌ Optimized deletion failed: ${optimizedResult.message}',
            );
            backendError = optimizedResult.message;
            deletionMethod = 'optimized_failed';

            // Check if it's an authorization error
            if (optimizedResult.errorCode == 'UNAUTHORIZED') {
              throw Exception(
                'Access denied: Only administrators can delete files',
              );
            }

            // For other errors, still proceed with local cleanup
            backendDeletionSuccessful = false;
          }
        } else {
          // No local document metadata available, try traditional deletion
          debugPrint(
            '⚠️ No local document metadata, using traditional deletion...',
          );

          try {
            await _documentService.deleteDocument(documentId, deletedBy);
            debugPrint('✅ Traditional backend deletion completed successfully');
            backendDeletionSuccessful = true;
            deletionMethod = 'traditional_fallback';
          } catch (deleteError) {
            backendError = deleteError.toString();
            debugPrint('❌ Traditional backend deletion failed: $deleteError');

            // Handle specific error cases
            if (deleteError.toString().contains('Document not found')) {
              debugPrint(
                'ℹ️ Document not found in backend - proceeding with local cleanup',
              );
              backendDeletionSuccessful = true;
              deletionMethod = 'not_found_cleanup';
            } else if (deleteError.toString().contains('CRITICAL')) {
              debugPrint('🚨 Critical storage deletion issue detected');
              backendDeletionSuccessful = false;
              deletionMethod = 'critical_error';
            } else {
              // For other errors, rethrow to let the UI handle it
              rethrow;
            }
          }
        }
      } catch (optimizedDeleteError) {
        debugPrint('❌ Optimized deletion service error: $optimizedDeleteError');
        backendError = optimizedDeleteError.toString();
        backendDeletionSuccessful = false;
        deletionMethod = 'service_error';

        // Don't rethrow here - proceed with local cleanup
      }

      // ENHANCED DELETE FIX: Always perform local cleanup regardless of backend result
      // This ensures UI consistency even if backend operations fail
      bool localChanges = false;

      // Remove from category storage
      if (categoryToRemoveFrom != null &&
          _categoryDocuments.containsKey(categoryToRemoveFrom)) {
        final removedCount = _categoryDocuments[categoryToRemoveFrom]!.length;
        _categoryDocuments[categoryToRemoveFrom]!.removeWhere(
          (d) => d.id == documentId,
        );
        final newCount = _categoryDocuments[categoryToRemoveFrom]!.length;
        if (removedCount != newCount) {
          localChanges = true;
          debugPrint('✅ Removed from category storage: $categoryToRemoveFrom');
        }
      }

      // Remove from main list
      final originalCount = _documents.length;
      _documents.removeWhere((d) => d.id == documentId);
      if (_documents.length != originalCount) {
        localChanges = true;
        debugPrint('✅ Removed from main document list');
      }

      // Remove from state manager cache
      try {
        _stateManager.removeDocument(documentId);
        debugPrint('✅ Removed from state manager cache');
      } catch (e) {
        debugPrint('⚠️ Failed to remove from state manager: $e');
      }

      // SURGICAL FIX: Clear recent assignment tracking when document is permanently removed
      _recentlyAssignedFiles.remove(documentId);
      _assignmentTimestamps.remove(documentId);

      // PERSISTENT FIX: Also clear persistent assignment tracking
      if (_persistentAssignments.remove(documentId) != null) {
        _savePersistentAssignments();
        debugPrint(
          '🧹 Cleared persistent assignment for deleted document: $documentId',
        );
      }

      // Update UI and persistence if any local changes were made
      if (localChanges) {
        // Save to storage for persistence
        try {
          await _saveToStorage();
          debugPrint('✅ Local storage updated');
        } catch (e) {
          debugPrint('⚠️ Failed to update local storage: $e');
        }

        // Notify listeners to update UI
        notifyListeners();
        debugPrint('✅ UI updated');
      }

      // Log final status with backend deletion details and method used
      if (backendDeletionSuccessful) {
        debugPrint(
          '✅ DocumentProvider: Document removal completed successfully for ID: $documentId (Method: $deletionMethod)',
        );

        // STATISTICS UPDATE: Notify about successful file deletion
        if (localDocument != null && localDocument.id.isNotEmpty) {
          _statisticsService.notifyFileDeleted(
            fileId: localDocument.id,
            fileName: localDocument.fileName,
            category: localDocument.category,
            fileSize: localDocument.fileSize,
          );
          debugPrint(
            '📊 Statistics notification sent for deleted file: ${localDocument.fileName}',
          );
        }
      } else {
        debugPrint(
          '⚠️ DocumentProvider: Document removal completed with backend issues for ID: $documentId (Method: $deletionMethod)',
        );
        if (backendError != null) {
          debugPrint('📋 Backend error details: $backendError');
        }
      }
    } catch (e) {
      debugPrint(
        '❌ DocumentProvider: Failed to remove document $documentId: $e',
      );
      throw Exception('Failed to remove document: ${e.toString()}');
    }
  }

  /// Force remove document from local cache only (for UI cleanup)
  void forceRemoveFromLocal(String documentId) {
    try {
      debugPrint(
        '🧹 DocumentProvider: Force removing from local cache: $documentId',
      );

      bool localChanges = false;

      // Remove from category storage
      for (final entry in _categoryDocuments.entries) {
        final removedCount = entry.value.length;
        entry.value.removeWhere((d) => d.id == documentId);
        if (entry.value.length != removedCount) {
          localChanges = true;
          debugPrint('✅ Removed from category storage: ${entry.key}');
        }
      }

      // Remove from main list
      final originalCount = _documents.length;
      _documents.removeWhere((d) => d.id == documentId);
      if (_documents.length != originalCount) {
        localChanges = true;
        debugPrint('✅ Removed from main document list');
      }

      // Remove from state manager cache
      try {
        _stateManager.removeDocument(documentId);
        debugPrint('✅ Removed from state manager cache');
      } catch (e) {
        debugPrint('⚠️ Failed to remove from state manager: $e');
      }

      // Update UI if any changes were made
      if (localChanges) {
        notifyListeners(); // Filtering now handled by screen-specific states
        debugPrint('✅ Local UI updated');

        // Save to storage asynchronously
        _saveToStorage().catchError((e) {
          debugPrint('⚠️ Failed to update local storage: $e');
        });
      }

      debugPrint(
        '✅ DocumentProvider: Force removal completed for: $documentId',
      );
    } catch (e) {
      debugPrint('❌ DocumentProvider: Failed to force remove from local: $e');
    }
  }

  /// Delete document using Cloud Function with unified ID system
  Future<void> _deleteDocumentViaCloudFunction(
    String documentId,
    String deletedBy,
  ) async {
    // Find document in local cache for better error handling (declare outside try-catch)
    DocumentModel? localDocument;
    try {
      localDocument = _documents.firstWhere((d) => d.id == documentId);
      debugPrint('✅ Found document locally: ${localDocument.fileName}');
    } catch (e) {
      debugPrint('⚠️ Document not found in local cache: $documentId');
    }

    // Declare CloudFunctions service outside try-catch for error handling access
    final cloudFunctions = CloudFunctionsService.instance;

    try {
      debugPrint(
        '🚀 DocumentProvider: Deleting document via Cloud Function: $documentId',
      );

      // UNIFIED ID SYSTEM: Validate and normalize document ID before deletion
      String actualDocumentId = documentId;
      final isValidId = await _unifiedIdSystem.validateDocumentId(documentId);

      if (!isValidId && localDocument != null) {
        debugPrint(
          '⚠️ Document ID validation failed, attempting reconciliation...',
        );

        // Try to find the correct Firestore ID using the unified system
        final correctId = await _unifiedIdSystem.getFirestoreIdFromStoragePath(
          localDocument.filePath,
        );
        if (correctId != null && correctId != documentId) {
          debugPrint(
            '🔄 Found correct Firestore ID: $correctId (was: $documentId)',
          );
          actualDocumentId = correctId;
        } else {
          debugPrint(
            '❌ Could not resolve correct Firestore ID, proceeding with original ID',
          );
        }
      }

      // Call cloud function for deletion using the resolved document ID
      final cloudFunctions = CloudFunctionsService.instance;
      final result = await cloudFunctions.deleteDocument(actualDocumentId);

      debugPrint('🔍 Called Cloud Function with ID: $actualDocumentId');

      if (result['success'] == true) {
        debugPrint('✅ Cloud function deletion successful');

        // Remove from local cache
        bool localChanges = false;

        // Remove from category storage
        for (final entry in _categoryDocuments.entries) {
          final removedCount = entry.value.length;
          entry.value.removeWhere((d) => d.id == documentId);
          if (entry.value.length != removedCount) {
            localChanges = true;
            debugPrint('✅ Removed from category storage: ${entry.key}');
          }
        }

        // Remove from main list
        final originalCount = _documents.length;
        _documents.removeWhere((d) => d.id == documentId);
        if (_documents.length != originalCount) {
          localChanges = true;
          debugPrint('✅ Removed from main document list');
        }

        // Remove from state manager cache
        try {
          _stateManager.removeDocument(documentId);
          debugPrint('✅ Removed from state manager cache');
        } catch (e) {
          debugPrint('⚠️ Failed to remove from state manager: $e');
        }

        // Update UI if any changes were made
        if (localChanges) {
          notifyListeners(); // Filtering now handled by screen-specific states
          debugPrint('✅ Local UI updated after cloud function deletion');

          // Save to storage asynchronously
          _saveToStorage().catchError((e) {
            debugPrint('⚠️ Failed to update local storage: $e');
          });
        }

        debugPrint(
          '✅ DocumentProvider: Cloud function deletion completed for: $documentId',
        );

        // STATISTICS UPDATE: Notify about successful file deletion via cloud function
        if (localDocument != null && localDocument.id.isNotEmpty) {
          _statisticsService.notifyFileDeleted(
            fileId: localDocument.id,
            fileName: localDocument.fileName,
            category: localDocument.category,
            fileSize: localDocument.fileSize,
          );
          debugPrint(
            '📊 Statistics notification sent for cloud function deleted file: ${localDocument.fileName}',
          );
        }
      } else {
        throw Exception(
          'Cloud function deletion failed: ${result['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      debugPrint('❌ DocumentProvider: Cloud function deletion failed: $e');

      // Check if it's a "not found" error and handle gracefully with reconciliation
      if (e.toString().contains('not-found') ||
          e.toString().contains('Document not found')) {
        debugPrint(
          'ℹ️ Document not found in backend - attempting reconciliation and fallback deletion',
        );

        // UNIFIED ID SYSTEM: Try reconciliation service for ID mismatch scenarios
        if (localDocument != null) {
          debugPrint('🔄 Attempting document reconciliation...');
          final reconciledDocuments = await _reconciliationService
              .reconcileSpecificDocuments([localDocument]);

          if (reconciledDocuments.isNotEmpty) {
            final reconciledDocument = reconciledDocuments.first;
            if (reconciledDocument.id != documentId) {
              debugPrint(
                '✅ Document reconciled with new ID: ${reconciledDocument.id}',
              );
              // Try deletion again with reconciled ID
              try {
                final retryResult = await cloudFunctions.deleteDocument(
                  reconciledDocument.id,
                );
                if (retryResult['success'] == true) {
                  debugPrint('✅ Deletion successful after reconciliation');
                  forceRemoveFromLocal(documentId);
                  return;
                }
              } catch (retryError) {
                debugPrint(
                  '⚠️ Deletion still failed after reconciliation: $retryError',
                );
              }
            }
          }
        }

        // If reconciliation fails, try direct storage deletion as fallback
        if (localDocument != null) {
          debugPrint('🔄 Attempting direct storage deletion as fallback...');
          try {
            final directResult = await _directStorageService
                .deleteDocumentDirect(localDocument, forceDelete: true);
            if (directResult.success) {
              debugPrint('✅ Direct storage deletion successful');
            } else {
              debugPrint(
                '⚠️ Direct storage deletion failed: ${directResult.message}',
              );
            }
          } catch (directError) {
            debugPrint('❌ Direct storage deletion error: $directError');
          }
        }

        // Always perform local cleanup regardless of backend result
        forceRemoveFromLocal(documentId);
        return;
      }

      // For other errors, rethrow
      rethrow;
    }
  }

  /// Force refresh documents from server
  Future<void> forceRefreshDocuments() async {
    debugPrint('🔄 Force refreshing documents from server...');
    await loadDocuments(forceRefresh: true);
  }

  /// Refresh documents from Firestore (internal method)
  Future<void> _refreshDocumentsFromFirestore() async {
    try {
      debugPrint('🔄 Refreshing documents from Firestore...');

      // Get fresh data from Firestore
      final freshDocuments = await _documentService.getAllDocuments();

      // Update local cache with fresh data
      _documents.clear();
      _documents.addAll(freshDocuments);

      // Rebuild category storage
      _categoryDocuments.clear();
      for (final doc in freshDocuments) {
        final category = doc.category.isEmpty ? 'uncategorized' : doc.category;
        if (!_categoryDocuments.containsKey(category)) {
          _categoryDocuments[category] = [];
        }
        _categoryDocuments[category]!.add(doc);
      }

      // Notify listeners - filtering now handled by screen-specific states
      notifyListeners();

      debugPrint(
        '✅ Refreshed ${freshDocuments.length} documents from Firestore',
      );
    } catch (e) {
      debugPrint('❌ Failed to refresh documents from Firestore: $e');
      // Don't rethrow - this is a best-effort operation
    }
  }

  /// Run file path diagnostic (for troubleshooting)
  Future<Map<String, dynamic>> runFilePathDiagnostic() async {
    try {
      debugPrint('🔍 Running file path diagnostic...');
      final fileCategoryService = FileCategoryManagementService();
      final results = await fileCategoryService.diagnoseFilePathIssues();

      debugPrint('✅ Diagnostic completed');
      return results;
    } catch (e) {
      debugPrint('❌ Failed to run diagnostic: $e');
      return {'error': e.toString()};
    }
  }

  // REMOVED: Filter and sort methods - now handled by screen-specific filter states
  // void searchDocuments(String query) { ... }
  // void filterByCategory(String category) { ... }
  // void filterByStatus(String status) { ... }
  // void filterByFileType(String fileType) { ... }
  // void sortDocuments(String sortBy, {bool ascending = false}) { ... }

  // REMOVED: _applyFiltersAndSort method - filtering now handled by screen-specific filter states
  // void _applyFiltersAndSort() { ... }

  // REMOVED: clearFilters method - now handled by screen-specific filter states
  // void clearFilters() { ... }

  // Get file type category for filtering (CSV consolidated with Excel)
  String _getFileTypeCategory(String fileType) {
    final lowerFileType = fileType.toLowerCase();

    if (lowerFileType.contains('pdf')) {
      return 'PDF';
    } else if (lowerFileType.contains('doc') ||
        lowerFileType.contains('word')) {
      return 'DOC';
    } else if (lowerFileType.contains('excel') ||
        lowerFileType.contains('sheet') ||
        lowerFileType.contains('xlsx') ||
        lowerFileType.contains('xls') ||
        lowerFileType.contains('csv')) {
      // ← CSV consolidated with Excel
      return 'Excel';
    } else if (lowerFileType.contains('image') ||
        lowerFileType.contains('jpg') ||
        lowerFileType.contains('jpeg') ||
        lowerFileType.contains('png')) {
      return 'Image';
    } else if (lowerFileType.contains('powerpoint') ||
        lowerFileType.contains('presentation') ||
        lowerFileType.contains('pptx') ||
        lowerFileType.contains('ppt')) {
      return 'PPT';
    } else if (lowerFileType.contains('text') ||
        lowerFileType.contains('txt')) {
      return 'TXT';
    } else {
      return 'Other';
    }
  }

  // Get document by ID
  DocumentModel? getDocumentById(String documentId) {
    try {
      return _documents.firstWhere((document) => document.id == documentId);
    } catch (e) {
      return null;
    }
  }

  // Get documents by category with Firebase fallback
  List<DocumentModel> getDocumentsByCategory(String category) {
    debugPrint('🔍 Getting documents for category: $category');

    // Handle empty category - return documents with empty category
    if (category.isEmpty) {
      final uncategorizedDocs = _documents
          .where((doc) => doc.category.isEmpty)
          .toList();
      debugPrint(
        '📭 Empty category: returning ${uncategorizedDocs.length} uncategorized documents',
      );
      return uncategorizedDocs;
    }

    // First try to get from local storage
    final localDocuments = _categoryDocuments[category] ?? [];
    debugPrint(
      '📁 Local storage has ${localDocuments.length} documents for category $category',
    );

    // ENHANCED: Always rebuild from main list to ensure consistency
    final documentsInCategory = _documents
        .where((doc) => doc.category == category)
        .toList();

    debugPrint(
      '📊 Found ${documentsInCategory.length} documents in main list for category $category',
    );

    // ENHANCED DEBUG: Show sample documents for troubleshooting
    if (documentsInCategory.isNotEmpty) {
      final sampleDocs = documentsInCategory
          .take(3)
          .map((doc) => '${doc.fileName} (${doc.category})')
          .join(', ');
      debugPrint(
        '📄 Sample documents in category: $sampleDocs${documentsInCategory.length > 3 ? "..." : ""}',
      );
    }

    // RACE CONDITION FIX: Only rebuild if there's a significant mismatch and no recent updates
    final hasRecentUpdate =
        _lastLoadTime != null &&
        DateTime.now().difference(_lastLoadTime!).inSeconds < 30;

    if (documentsInCategory.length != localDocuments.length &&
        !hasRecentUpdate) {
      debugPrint(
        '🔄 Rebuilding category storage due to count mismatch (no recent updates)...',
      );
      _categoryDocuments[category] = documentsInCategory;

      // Save the rebuilt data asynchronously
      _saveToStorage().catchError((e) {
        debugPrint('⚠️ Failed to save rebuilt category storage: $e');
      });

      debugPrint(
        '✅ Rebuilt category storage for $category: ${documentsInCategory.length} documents',
      );
      return documentsInCategory;
    } else if (hasRecentUpdate &&
        documentsInCategory.length != localDocuments.length) {
      debugPrint(
        '⚠️ Skipping rebuild due to recent update - preserving local changes',
      );
    }

    debugPrint(
      '📋 Returning ${localDocuments.length} documents for category $category',
    );
    return localDocuments;
  }

  // Get documents by category with Firebase query fallback
  Future<List<DocumentModel>> getDocumentsByCategoryAsync(
    String category,
  ) async {
    try {
      // First try local storage
      final localDocuments = getDocumentsByCategory(category);
      if (localDocuments.isNotEmpty) {
        return localDocuments;
      }

      // If local storage is empty, query Firebase directly
      debugPrint(
        '🔄 Local storage empty for category $category, querying Firebase...',
      );
      final firebaseDocuments = await _documentService.getDocumentsByCategory(
        category,
      );

      if (firebaseDocuments.isNotEmpty) {
        // Update local storage with Firebase data
        _categoryDocuments[category] = firebaseDocuments;

        // Also update main documents list if needed
        for (final doc in firebaseDocuments) {
          if (!_documents.any((d) => d.id == doc.id)) {
            _documents.add(doc);
          }
        }

        await _saveToStorage();
        notifyListeners(); // Filtering now handled by screen-specific states

        debugPrint(
          '✅ Retrieved ${firebaseDocuments.length} documents for category $category from Firebase',
        );
        return firebaseDocuments;
      }

      return [];
    } catch (e) {
      debugPrint('❌ Failed to get documents for category $category: $e');
      return [];
    }
  }

  // ENTERPRISE SCALE: Get recent files with unlimited support
  List<DocumentModel> getRecentFiles({int days = 7, int? limit}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    final recentFiles =
        _documents.where((doc) => doc.uploadedAt.isAfter(cutoffDate)).toList()
          ..sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));

    // ENHANCED DEBUG: Log recent files regardless of category
    debugPrint('📅 Recent files (${days}d): ${recentFiles.length} total');
    if (recentFiles.isNotEmpty) {
      final categoryBreakdown = <String, int>{};
      for (final file in recentFiles) {
        final category = file.category.isEmpty ? 'empty' : file.category;
        categoryBreakdown[category] = (categoryBreakdown[category] ?? 0) + 1;
      }
      debugPrint('📊 Recent files by category: $categoryBreakdown');
      debugPrint(
        '🔍 FIXED: Recent files now show ALL files regardless of category filters',
      );
    }

    // ENTERPRISE SCALE: Apply appropriate limit based on configuration
    if (FirebaseConfig.shouldEnableUnlimitedFiles && limit == null) {
      // No limit for enterprise mode
      return recentFiles;
    } else {
      // Apply specified limit or safe default
      final safeLimit = limit ?? ANRConfig.maxItemsPerPage;
      return recentFiles.take(safeLimit).toList();
    }
  }

  // Get uncategorized files (files with empty category)
  List<DocumentModel> getUncategorizedFiles() {
    return getDocumentsByCategory(''); // Empty string for uncategorized files
  }

  /// Verify that the user has admin privileges
  Future<bool> _verifyUserIsAdmin(String userId) async {
    try {
      debugPrint(
        '🔐 DocumentProvider: Verifying admin status for user: $userId',
      );

      // Get user document from Firestore
      final userDoc = await _firebaseService.firestore
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        debugPrint('❌ DocumentProvider: User document not found: $userId');
        return false;
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final userRole = userData['role']?.toString() ?? 'user';

      final isAdmin = userRole == 'admin';
      debugPrint(
        '🔐 DocumentProvider: User role: $userRole, isAdmin: $isAdmin',
      );

      return isAdmin;
    } catch (e) {
      debugPrint('❌ DocumentProvider: Error verifying admin status: $e');
      return false;
    }
  }

  // Initialize empty category (for new categories)
  void initializeCategory(String categoryId) {
    if (!_categoryDocuments.containsKey(categoryId)) {
      _categoryDocuments[categoryId] = [];
      debugPrint('✅ Initialized empty category: $categoryId');
      // Save to storage to persist the category initialization
      _saveToStorage();
    }
  }

  // Force refresh folder contents from Firebase (for troubleshooting)
  Future<void> refreshFolderContents() async {
    try {
      debugPrint('🔄 Force refreshing folder contents from Firebase...');

      // Try Cloud Functions first for better performance
      try {
        final cloudFunctions = CloudFunctionsService.instance;
        final result = await cloudFunctions.refreshCategoryContents();

        if (result['success'] == true && result['documents'] != null) {
          final documents = result['documents'] as List;
          final categorizedDocuments =
              result['categorizedDocuments'] as Map<String, dynamic>;

          debugPrint(
            '📥 Cloud Functions: Refreshed ${documents.length} documents in ${categorizedDocuments.keys.length} categories',
          );

          // Clear and rebuild from Cloud Functions data
          _categoryDocuments.clear();
          _documents.clear();

          // Convert and organize documents
          for (final docData in documents) {
            final document = DocumentModel.fromMap(
              docData as Map<String, dynamic>,
            );
            _documents.add(document);

            if (!_categoryDocuments.containsKey(document.category)) {
              _categoryDocuments[document.category] = [];
            }
            _categoryDocuments[document.category]!.add(document);
          }

          debugPrint(
            '✅ Cloud Functions refresh complete: ${_categoryDocuments.keys.length} categories with ${_documents.length} total documents',
          );

          // Save to storage and notify listeners
          await _saveToStorage();
          notifyListeners(); // Filtering now handled by screen-specific states
          return;
        }
      } catch (cloudError) {
        debugPrint(
          '⚠️ Cloud Functions refresh failed, falling back to direct Firebase: $cloudError',
        );
      }

      // Fallback to direct Firebase service
      final firebaseDocuments = await _documentService.getAllDocuments();

      if (firebaseDocuments.isNotEmpty) {
        debugPrint(
          '📥 Direct Firebase: Loading ${firebaseDocuments.length} documents',
        );

        // Clear and rebuild category documents
        _categoryDocuments.clear();
        _documents.clear();

        // Rebuild from Firebase data
        for (final firebaseDoc in firebaseDocuments) {
          _documents.add(firebaseDoc);

          if (!_categoryDocuments.containsKey(firebaseDoc.category)) {
            _categoryDocuments[firebaseDoc.category] = [];
          }
          _categoryDocuments[firebaseDoc.category]!.add(firebaseDoc);
        }

        debugPrint(
          '✅ Direct Firebase refresh complete: ${_categoryDocuments.keys.length} categories with ${_documents.length} total documents',
        );

        // Save to storage and notify listeners
        await _saveToStorage();
        notifyListeners(); // Filtering now handled by screen-specific states
      } else {
        debugPrint('⚠️ No documents found in Firebase during refresh');
      }
    } catch (e) {
      debugPrint('❌ Failed to refresh folder contents: $e');
      _setError('Failed to refresh folder contents: $e');
    }
  }

  // Ensure all existing categories from Firestore are initialized in local storage
  Future<void> _ensureCategoriesInitialized() async {
    try {
      // Create CategoryService instance to get all categories
      final categoryService = CategoryService();
      final allCategories = await categoryService.getAllCategories();

      bool hasChanges = false;
      for (final category in allCategories) {
        if (!_categoryDocuments.containsKey(category.id)) {
          _categoryDocuments[category.id] = [];
          debugPrint(
            '✅ Auto-initialized category: ${category.name} (${category.id})',
          );
          hasChanges = true;
        }
      }

      // No automatic uncategorized category - let users create categories as needed

      if (hasChanges) {
        await _saveToStorage();
      }
    } catch (e) {
      debugPrint('⚠️ Failed to ensure categories initialized: $e');
    }
  }

  // Remove category and its documents
  void removeCategory(String categoryId) {
    _categoryDocuments.remove(categoryId);
    _documents.removeWhere((doc) => doc.category == categoryId);
    notifyListeners(); // Filtering now handled by screen-specific states
  }

  // Get all documents (status filtering removed)
  List<DocumentModel> getDocumentsByStatus(String status) {
    // Return all documents since status management is removed
    return _documents.toList();
  }

  // Phantom file cleanup removed since status management is removed

  // Get documents by user
  List<DocumentModel> getDocumentsByUser(String userId) {
    return _documents
        .where((document) => document.uploadedBy == userId)
        .toList();
  }

  // ENHANCED: Firebase Storage as single source of truth for recent documents
  List<DocumentModel> getRecentDocuments({int? limit}) {
    // PRIORITY 1: Always use Firebase Storage data from state manager
    final stateManagerDocs = _stateManager.getRecentDocuments(
      limit:
          limit ??
          (FirebaseConfig.shouldEnableUnlimitedFiles
              ? 0
              : ANRConfig.defaultPageSize),
    );

    // CONSISTENCY FIX: Always sync local state with Storage-based state manager
    if (_stateManager.documents.isNotEmpty) {
      if (_documents.length != _stateManager.documents.length) {
        debugPrint('🔄 Syncing local state with Firebase Storage data...');
        _documents = List.from(_stateManager.documents);
        notifyListeners(); // Filtering now handled by screen-specific states
      }

      // Return Storage-based data for consistency
      debugPrint(
        '📊 Using Firebase Storage data: ${stateManagerDocs.length} recent files',
      );
      return stateManagerDocs;
    }

    // FALLBACK: Only use local data if Storage data is not available
    // This ensures we don't show inconsistent data
    List<DocumentModel> sortedDocs = List.from(_documents);
    sortedDocs.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));

    // ENTERPRISE SCALE: Apply appropriate limit based on configuration
    List<DocumentModel> recentDocs;
    if (FirebaseConfig.shouldEnableUnlimitedFiles &&
        (limit == null || limit == 0)) {
      // No limit for enterprise mode
      recentDocs = sortedDocs;
    } else {
      // Apply specified limit or safe default
      final safeLimit = limit ?? ANRConfig.defaultPageSize;
      recentDocs = sortedDocs.take(safeLimit).toList();
    }

    // Log fallback usage for monitoring
    if (recentDocs.isNotEmpty) {
      debugPrint(
        '⚠️ Using fallback data (may not match Storage): ${recentDocs.length} files',
      );
    }

    return recentDocs;
  }

  // ARCHITECTURAL FIX: Use centralized state manager for atomic updates
  Future<void> refreshRecentFiles() async {
    // Prevent concurrent refresh operations
    if (_isRefreshingRecentFiles) {
      debugPrint('⚠️ Recent files refresh already in progress, skipping...');
      return;
    }

    _isRefreshingRecentFiles = true;

    try {
      debugPrint('🔄 Starting centralized document refresh...');

      // Use DocumentStateManager for atomic refresh
      await _stateManager.refreshDocuments();

      // Sync local state with state manager
      final freshDocuments = _stateManager.documents;
      if (freshDocuments.isNotEmpty) {
        await _atomicDocumentUpdate(freshDocuments);

        debugPrint(
          '✅ Documents refreshed via state manager: ${freshDocuments.length} files',
        );

        if (freshDocuments.isNotEmpty) {
          debugPrint(
            '📊 Latest file: ${freshDocuments.first.fileName} (${freshDocuments.first.uploadedAt})',
          );
        }

        return;
      }

      // FALLBACK: Use existing data if state manager is empty
      debugPrint('⚠️ State manager returned empty, keeping existing data');
    } catch (e) {
      debugPrint('❌ Failed to refresh via state manager: $e');
      // Keep existing data on error - don't clear it
    } finally {
      _isRefreshingRecentFiles = false;
    }
  }

  // ARCHITECTURAL FIX: Atomic document update to prevent race conditions
  Future<void> _atomicDocumentUpdate(List<DocumentModel> newDocuments) async {
    if (_isAtomicUpdateInProgress) {
      debugPrint('⚠️ Atomic update already in progress, skipping...');
      return;
    }

    _isAtomicUpdateInProgress = true;

    try {
      debugPrint('🔄 Starting atomic document update...');

      // Create a snapshot of current state for rollback if needed
      final previousDocuments = List<DocumentModel>.from(_documents);
      final previousCategoryDocuments = <String, List<DocumentModel>>{};
      for (final entry in _categoryDocuments.entries) {
        previousCategoryDocuments[entry.key] = List<DocumentModel>.from(
          entry.value,
        );
      }

      try {
        // ATOMIC OPERATION: Update all data structures together
        _documents = List<DocumentModel>.from(newDocuments);

        // Rebuild category documents from new data
        _categoryDocuments.clear();
        for (final doc in newDocuments) {
          final category = doc.category.isEmpty
              ? 'uncategorized'
              : doc.category;
          _categoryDocuments.putIfAbsent(category, () => []).add(doc);
        }

        // Save to local storage
        await _saveToStorage();

        // Notify listeners of the change
        notifyListeners();

        debugPrint('✅ Atomic document update completed successfully');
      } catch (e) {
        // ROLLBACK: Restore previous state on error
        debugPrint('❌ Atomic update failed, rolling back: $e');
        _documents = previousDocuments;

        // Restore category documents
        _categoryDocuments.clear();
        _categoryDocuments.addAll(previousCategoryDocuments);

        notifyListeners(); // Filtering now handled by screen-specific states
        rethrow;
      }
    } finally {
      _isAtomicUpdateInProgress = false;
    }
  }

  // Status count methods removed since status management is removed

  // Get total documents count
  int get totalDocumentsCount {
    return _documents.length;
  }

  // Enhanced methods using new services

  /// Load all documents with unlimited query support (admin only)
  Future<void> loadAllDocumentsUnlimited({
    String? categoryFilter,
    String? searchQuery,
  }) async {
    if (!(await _enhancedAuthService.canPerformUnlimitedQueries())) {
      debugPrint('⚠️ Unlimited queries not available for current user');
      await loadDocuments(); // Fallback to regular loading
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      debugPrint('🔓 Loading all documents with unlimited query...');

      final documents = await _enhancedDocumentService.getAllDocumentsUnlimited(
        categoryFilter: categoryFilter,
        searchQuery: searchQuery,
      );

      _documents = documents;
      notifyListeners(); // Filtering now handled by screen-specific states

      debugPrint('✅ Loaded ${documents.length} documents with unlimited query');
    } catch (e) {
      _setError('Failed to load documents: ${e.toString()}');
      debugPrint('❌ Unlimited query failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Load documents from Firebase Storage with unlimited access
  Future<void> loadDocumentsFromStorageUnlimited() async {
    if (!(await _enhancedAuthService.canAccessStorageManagement())) {
      debugPrint('⚠️ Storage management access denied');
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      debugPrint('📁 Loading documents from Firebase Storage...');

      final storageDocuments = await _enhancedStorageService
          .getAllStorageFilesUnlimited();

      // Merge with existing documents, avoiding duplicates
      final existingPaths = _documents.map((doc) => doc.filePath).toSet();
      final newDocuments = storageDocuments
          .where((doc) => !existingPaths.contains(doc.filePath))
          .toList();

      _documents.addAll(newDocuments);
      notifyListeners(); // Filtering now handled by screen-specific states

      debugPrint('✅ Added ${newDocuments.length} documents from Storage');
    } catch (e) {
      _setError('Failed to load storage documents: ${e.toString()}');
      debugPrint('❌ Storage loading failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh download URLs for all documents
  Future<void> refreshAllDownloadUrls() async {
    if (!(await _enhancedAuthService.canAccessStorageManagement())) {
      debugPrint('⚠️ Storage management access denied');
      return;
    }

    try {
      debugPrint('🔄 Refreshing download URLs...');

      int refreshedCount = 0;
      for (final document in _documents) {
        if (document.filePath.isNotEmpty) {
          final newUrl = await _enhancedStorageService.refreshDownloadUrl(
            document.filePath,
          );
          if (newUrl != null) {
            refreshedCount++;
          }
        }
      }

      debugPrint('✅ Refreshed $refreshedCount download URLs');
      notifyListeners(); // Notify UI to update
    } catch (e) {
      debugPrint('❌ Failed to refresh download URLs: $e');
    }
  }

  /// Get document statistics (admin only)
  Future<Map<String, dynamic>> getDocumentStatistics() async {
    if (!(await _enhancedAuthService.canPerformUnlimitedQueries())) {
      return {'error': 'Admin privileges required'};
    }

    try {
      final firestoreStats = await _enhancedDocumentService
          .getDocumentStatistics();
      final storageStats = await _enhancedStorageService.getStorageStatistics();

      return {
        'firestore': firestoreStats,
        'storage': storageStats,
        'local': {
          'totalDocuments': _documents.length,
          'filteredDocuments': _filteredDocuments.length,
          'categories': _categoryDocuments.keys.length,
        },
      };
    } catch (e) {
      debugPrint('❌ Failed to get statistics: $e');
      return {'error': e.toString()};
    }
  }

  /// Check if unlimited queries are available for current user
  Future<bool> get canUseUnlimitedQueries async {
    return await _enhancedAuthService.canPerformUnlimitedQueries();
  }

  /// Check if storage management is available for current user
  Future<bool> get canManageStorage async {
    return await _enhancedAuthService.canAccessStorageManagement();
  }

  // Get total file size
  int get totalFileSize {
    return _documents.fold(0, (total, document) => total + document.fileSize);
  }

  // Get formatted total file size
  String get totalFileSizeFormatted {
    int totalSize = totalFileSize;
    if (totalSize < 1024) {
      return '$totalSize bytes';
    } else if (totalSize < 1024 * 1024) {
      return '${(totalSize / 1024).toStringAsFixed(1)} KB';
    } else if (totalSize < 1024 * 1024 * 1024) {
      return '${(totalSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(totalSize / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  // ENHANCED: Firebase Storage-first refresh with atomic updates
  Future<void> refreshDocuments() async {
    // Prevent concurrent refresh operations (including recent files refresh)
    if (_isLoadingDocuments ||
        _isRefreshingRecentFiles ||
        _isAtomicUpdateInProgress) {
      debugPrint(
        '⚠️ Document operation already in progress, skipping refresh...',
      );
      return;
    }

    debugPrint('🔄 Starting Firebase Storage-first document refresh...');

    // ENHANCED: Use Firebase Storage as primary source for refresh
    await _stateManager.refreshDocuments();
    final freshDocuments = _stateManager.documents;

    if (freshDocuments.isNotEmpty) {
      await _atomicDocumentUpdate(freshDocuments);
      debugPrint(
        '✅ Storage-first refresh completed: ${freshDocuments.length} documents',
      );
      debugPrint(
        '📊 File count matches Firebase Storage exactly: ${freshDocuments.length} files',
      );
    } else {
      // Fallback to recent files refresh if Storage is empty
      await refreshRecentFiles();
    }

    debugPrint('✅ Firebase Storage-first document refresh completed');
  }

  // Force refresh (simplified - no sync service needed)
  Future<void> refreshWithStorageSync() async {
    _setLoading(true);
    _clearError();

    try {
      debugPrint('🔄 Force refreshing documents...');

      // Simply reload documents from current sources
      await loadDocuments();
    } catch (e) {
      debugPrint('❌ Force refresh failed: $e');
      _setError('Failed to refresh documents: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Force UI refresh (for immediate updates after uploads)
  void forceRefresh() {
    notifyListeners(); // Filtering now handled by screen-specific states
  }

  // Clean up existing duplicate documents
  Future<void> cleanupDuplicateDocuments() async {
    try {
      debugPrint('🧹 Starting duplicate document cleanup...');

      final Map<String, DocumentModel> uniqueDocuments = {};
      final List<DocumentModel> duplicatesToRemove = [];

      // Group documents by file path (most reliable identifier)
      for (final doc in _documents) {
        final key = '${doc.filePath}_${doc.fileName}_${doc.fileSize}';

        if (uniqueDocuments.containsKey(key)) {
          // Keep the one with the most recent upload time
          final existing = uniqueDocuments[key]!;
          if (doc.uploadedAt.isAfter(existing.uploadedAt)) {
            duplicatesToRemove.add(existing);
            uniqueDocuments[key] = doc;
          } else {
            duplicatesToRemove.add(doc);
          }
        } else {
          uniqueDocuments[key] = doc;
        }
      }

      if (duplicatesToRemove.isNotEmpty) {
        debugPrint(
          '🧹 Found ${duplicatesToRemove.length} duplicate documents to remove',
        );

        // Remove duplicates from main list
        for (final duplicate in duplicatesToRemove) {
          _documents.removeWhere((doc) => doc.id == duplicate.id);
          debugPrint(
            '🗑️ Removed duplicate: ${duplicate.fileName} (ID: ${duplicate.id})',
          );
        }

        // Rebuild category storage
        _categoryDocuments.clear();
        for (final doc in _documents) {
          final category = doc.category;
          if (!_categoryDocuments.containsKey(category)) {
            _categoryDocuments[category] = [];
          }
          _categoryDocuments[category]!.add(doc);
        }

        // Save cleaned data
        await _saveToStorage();
        notifyListeners(); // Filtering now handled by screen-specific states

        debugPrint(
          '✅ Cleanup complete: Removed ${duplicatesToRemove.length} duplicates, ${_documents.length} unique documents remain',
        );
      } else {
        debugPrint('✅ No duplicates found - data is clean');
      }
    } catch (e) {
      debugPrint('❌ Failed to cleanup duplicates: $e');
    }
  }

  // Manual cleanup removed since status management is removed

  // Get sync status information (simplified for optimized service)
  Future<Map<String, dynamic>> getSyncStatus() async {
    try {
      // Simplified status since optimized service doesn't have getSyncStatus
      return {
        'storageFileCount': 'N/A - Use optimized sync',
        'firestoreDocumentCount': _documents.length,
        'orphanedFileCount': 'N/A - Manual check required',
        'syncNeeded': false,
        'lastSyncCheck': DateTime.now().toIso8601String(),
        'note': 'Using optimized sync service - automatic cleanup disabled',
      };
    } catch (e) {
      return {
        'error': e.toString(),
        'syncNeeded': true,
        'lastSyncCheck': DateTime.now().toIso8601String(),
      };
    }
  }

  // Helper methods - removed duplicates

  // Clear error manually
  void clearError() {
    _clearError();
  }

  // All required methods are already implemented above

  @override
  void dispose() {
    // Cancel Firebase listener
    _documentsSubscription?.cancel();
    // Cancel debounce timer
    _firebaseUpdateDebouncer?.cancel();
    super.dispose();
  }

  // Save data to persistent storage
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert category documents to JSON
      final Map<String, dynamic> categoryData = {};
      _categoryDocuments.forEach((categoryId, docs) {
        categoryData[categoryId] = docs
            .map((doc) => doc.toMapForStorage())
            .toList();
      });

      await prefs.setString('category_documents', jsonEncode(categoryData));
      await prefs.setBool('documents_initialized', _isInitialized);
    } catch (e) {
      debugPrint('Error saving documents to storage: $e');
    }
  }

  // REMOVED: _loadFromStorage method to prevent cache loading
  // This ensures statistics show 0 until Firebase Storage loads

  // SURGICAL FIX: Helper methods for tracking recent assignments to prevent race condition

  /// Track a recent file assignment to prevent reappearance during Firebase sync delays
  void _trackRecentAssignment(String documentId, String categoryId) {
    _recentlyAssignedFiles[documentId] = categoryId;
    _assignmentTimestamps[documentId] = DateTime.now();

    // PERSISTENT FIX: Also track in persistent storage for cross-session protection
    _persistentAssignments[documentId] = categoryId;
    _savePersistentAssignments();

    // Clean up old assignments (older than 2 minutes) to prevent memory leaks
    _cleanupOldAssignments();

    debugPrint(
      '🔒 Tracking recent assignment: $documentId -> $categoryId (persistent: true)',
    );
  }

  /// Check if a document was recently assigned to a specific category
  bool isRecentlyAssignedToCategory(String documentId, String categoryId) {
    final assignedCategory = _recentlyAssignedFiles[documentId];
    final timestamp = _assignmentTimestamps[documentId];

    if (assignedCategory == null || timestamp == null) {
      return false;
    }

    // Consider assignment recent if it happened within the last 2 minutes
    final isRecent = DateTime.now().difference(timestamp).inMinutes < 2;

    if (!isRecent) {
      // Clean up expired assignment
      _recentlyAssignedFiles.remove(documentId);
      _assignmentTimestamps.remove(documentId);
      return false;
    }

    return assignedCategory == categoryId;
  }

  /// Check if a document was recently assigned to any category (for filtering available files)
  bool isRecentlyAssigned(String documentId) {
    // ENHANCED FIX: Load persistent tracking on first use
    if (!_persistentTrackingLoaded) {
      _loadPersistentAssignments();
    }

    // Check temporary tracking first (for current session)
    final timestamp = _assignmentTimestamps[documentId];
    if (timestamp != null) {
      // Consider assignment recent if it happened within the last 2 minutes
      final isRecent = DateTime.now().difference(timestamp).inMinutes < 2;

      if (isRecent) {
        return true;
      } else {
        // Clean up expired assignment
        _recentlyAssignedFiles.remove(documentId);
        _assignmentTimestamps.remove(documentId);
      }
    }

    // PERSISTENT FIX: Check if document has a persistent assignment that conflicts with current category filtering
    if (_persistentAssignments.containsKey(documentId)) {
      final persistentCategory = _persistentAssignments[documentId]!;

      // Verify the assignment is still valid by checking if the document actually has this category
      final document = _documents.firstWhere(
        (doc) => doc.id == documentId,
        orElse: () => DocumentModel(
          id: '',
          fileName: '',
          fileSize: 0,
          fileType: '',
          filePath: '',
          uploadedBy: '',
          uploadedAt: DateTime.now(),
          category: '',
          permissions: [],
          metadata: DocumentMetadata(description: '', tags: []),
        ),
      );

      if (document.id.isNotEmpty && document.category == persistentCategory) {
        debugPrint(
          '🔒 Persistent assignment confirmed for ${document.fileName}: $persistentCategory',
        );
        return true;
      } else {
        // Clean up invalid persistent assignment
        _persistentAssignments.remove(documentId);
        _savePersistentAssignments();
        debugPrint(
          '🧹 Cleaned up invalid persistent assignment for: $documentId',
        );
      }
    }

    return false;
  }

  /// Clean up old assignment tracking to prevent memory leaks
  void _cleanupOldAssignments() {
    final now = DateTime.now();
    final expiredIds = <String>[];

    _assignmentTimestamps.forEach((documentId, timestamp) {
      if (now.difference(timestamp).inMinutes >= 2) {
        expiredIds.add(documentId);
      }
    });

    for (final id in expiredIds) {
      _recentlyAssignedFiles.remove(id);
      _assignmentTimestamps.remove(id);
    }

    if (expiredIds.isNotEmpty) {
      debugPrint(
        '🧹 Cleaned up ${expiredIds.length} expired assignment trackings',
      );
    }
  }

  // PERSISTENT FIX: Methods for persistent assignment tracking across app sessions

  /// Save persistent assignments to local storage
  void _savePersistentAssignments() {
    try {
      SharedPreferences.getInstance()
          .then((prefs) {
            final assignmentsJson = jsonEncode(_persistentAssignments);
            prefs.setString('persistent_assignments', assignmentsJson);
            debugPrint(
              '💾 Saved ${_persistentAssignments.length} persistent assignments',
            );
          })
          .catchError((e) {
            debugPrint('❌ Failed to save persistent assignments: $e');
          });
    } catch (e) {
      debugPrint('❌ Error saving persistent assignments: $e');
    }
  }

  /// Load persistent assignments from local storage
  void _loadPersistentAssignments() {
    if (_persistentTrackingLoaded) return;

    try {
      SharedPreferences.getInstance()
          .then((prefs) {
            final assignmentsJson = prefs.getString('persistent_assignments');
            if (assignmentsJson != null) {
              final Map<String, dynamic> decoded = jsonDecode(assignmentsJson);
              _persistentAssignments.clear();
              decoded.forEach((key, value) {
                _persistentAssignments[key] = value.toString();
              });
              debugPrint(
                '📂 Loaded ${_persistentAssignments.length} persistent assignments',
              );
            } else {
              debugPrint('📂 No persistent assignments found in storage');
            }
            _persistentTrackingLoaded = true;
          })
          .catchError((e) {
            debugPrint('❌ Failed to load persistent assignments: $e');
            _persistentTrackingLoaded =
                true; // Mark as loaded to prevent retry loops
          });
    } catch (e) {
      debugPrint('❌ Error loading persistent assignments: $e');
      _persistentTrackingLoaded = true; // Mark as loaded to prevent retry loops
    }
  }

  /// Clear persistent assignments (for cleanup or reset)
  void _clearPersistentAssignments() {
    _persistentAssignments.clear();
    SharedPreferences.getInstance()
        .then((prefs) {
          prefs.remove('persistent_assignments');
          debugPrint('🧹 Cleared all persistent assignments');
        })
        .catchError((e) {
          debugPrint('❌ Failed to clear persistent assignments: $e');
        });
  }
}
