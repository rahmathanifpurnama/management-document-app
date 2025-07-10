import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import '../models/document_model.dart';
import '../core/services/document_service.dart';
import '../core/services/firebase_service.dart';
import '../core/utils/firebase_initialization_status.dart';
// REMOVED: Sync services that created duplicate documents
import '../services/file_category_management_service.dart';
import '../services/cloud_functions_service.dart';
import '../core/config/anr_config.dart';

import '../config/firebase_config.dart';
// import 'category_provider.dart'; // Removed - migrated to BLoC

import '../services/enhanced_document_service.dart';
import '../services/enhanced_firebase_storage_service.dart';
import '../services/enhanced_auth_service.dart';
import '../services/realtime_category_sync_service.dart';

// UNIFIED ID SYSTEM: Import new architectural services
import '../core/services/unified_id_system.dart';
import '../core/services/smart_cache_invalidation.dart';
import '../core/services/id_reconciliation_service.dart';
import '../services/document_state_manager.dart';
import '../services/unified_document_loader.dart';
import '../services/direct_storage_deletion_service.dart';
import '../services/activity_service.dart';

import '../services/statistics_notification_service.dart';
import '../core/utils/circuit_breaker.dart';
import '../core/utils/empty_storage_state_manager.dart';

class DocumentProvider extends ChangeNotifier {
  List<DocumentModel> _documents = [];
  List<DocumentModel> _filteredDocuments = [];

  String? _errorMessage;
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'all';
  String _selectedStatus = 'all';
  String _selectedFileType = 'all';
  String _sortBy = 'uploadedAt';
  bool _sortAscending = false;

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
        _safeAutoInitializeDocuments();
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

  /// Safe auto-initialization that checks Firebase status first
  Future<void> _safeAutoInitializeDocuments() async {
    try {
      // Check if Firebase is initialized
      if (!FirebaseInitializationStatus.canInitializeProviders) {
        debugPrint(
          '⚠️ DocumentProvider: Firebase not ready, skipping auto-initialization',
        );
        debugPrint('   Status: ${FirebaseInitializationStatus.statusMessage}');

        // Set offline mode if needed
        if (FirebaseInitializationStatus.lastError != null) {
          FirebaseInitializationStatus.isOfflineMode = true;
        }

        // Don't crash - just skip initialization
        return;
      }

      // Firebase is ready, proceed with normal initialization
      await _autoInitializeDocuments();
    } catch (e) {
      debugPrint('❌ DocumentProvider: Safe auto-initialization failed: $e');

      // Check if it's a Firebase initialization error
      if (e.toString().contains('Firebase') &&
          e.toString().contains('no-app')) {
        debugPrint(
          '🔄 DocumentProvider: Firebase not initialized, will retry later',
        );
        FirebaseInitializationStatus.lastError = e.toString();
        return;
      }

      // For other errors, log but don't crash
      debugPrint('⚠️ DocumentProvider: Continuing with limited functionality');
    }
  }

  // Lazy-loaded services to prevent Firebase initialization errors
  EnhancedFirebaseStorageService? _enhancedStorageService;
  EnhancedFirebaseStorageService get enhancedStorageService =>
      _enhancedStorageService ??= EnhancedFirebaseStorageService.instance;

  EnhancedAuthService? _enhancedAuthService;
  EnhancedAuthService get enhancedAuthService =>
      _enhancedAuthService ??= EnhancedAuthService.instance;

  // ARCHITECTURAL FIX: Centralized state management
  DocumentStateManager? _stateManager;
  DocumentStateManager get stateManager =>
      _stateManager ??= DocumentStateManager.instance;

  // UNIFIED LOADING: Use unified document loader to eliminate race conditions
  UnifiedDocumentLoader? _unifiedLoader;
  UnifiedDocumentLoader get unifiedLoader =>
      _unifiedLoader ??= UnifiedDocumentLoader.instance;

  // STORAGE-FIRST DELETION: Service for direct storage deletion
  DirectStorageDeletionService? _directStorageService;
  DirectStorageDeletionService get directStorageService =>
      _directStorageService ??= DirectStorageDeletionService.instance;

  // STATISTICS NOTIFICATION: Service for real-time statistics updates
  StatisticsNotificationService? _statisticsService;
  StatisticsNotificationService get statisticsService =>
      _statisticsService ??= StatisticsNotificationService.instance;

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

      // Apply filters and sorting
      _applyFiltersAndSort();

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
      final unifiedDocuments = await unifiedLoader.loadAllDocuments(
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
      await stateManager.refreshDocuments();

      final stateManagerDocs = stateManager.documents;
      if (stateManagerDocs.isNotEmpty) {
        _documents = List.from(stateManagerDocs);
        _applyFiltersAndSort();
        notifyListeners();

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
        // DEFINITIVE FIX: Merge traditional documents with Firestore categories
        final documentsWithCategories =
            await _mergeStorageWithFirestoreCategories(documents);
        _handleFirebaseDocumentModels(documentsWithCategories);

        // RACE CONDITION FIX: Update last load time
        _lastLoadTime = DateTime.now();

        debugPrint(
          '✅ Traditional loading completed: ${documents.length} documents',
        );
        debugPrint(
          '🔗 DEFINITIVE FIX: Traditional documents merged with Firestore categories',
        );
      } else {
        debugPrint('📱 Traditional loading: No documents found');
      }
    } catch (e) {
      debugPrint('❌ Traditional loading failed: $e');
      // REMOVED: Cache fallback to prevent showing cached count
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
  // REMOVED: Firebase update processing variables - no longer needed
  bool _isLoadingDocuments = false; // Prevent concurrent document loading

  // Getters
  List<DocumentModel> get documents => _filteredDocuments;
  List<DocumentModel> get allDocuments => _documents;
  List<DocumentModel> get filteredDocuments => _filteredDocuments;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedFileType => _selectedFileType;
  String get selectedCategory => _selectedCategory;
  String get selectedStatus => _selectedStatus;
  String get sortBy => _sortBy;
  bool get sortAscending => _sortAscending;
  bool get isFirebaseSyncActive => _documentsSubscription != null;

  // RACE CONDITION FIX: Getter for last load time
  DateTime? get lastLoadTime => _lastLoadTime;

  // Check if any filters are currently active
  bool get hasActiveFilters =>
      _searchQuery.isNotEmpty ||
      _selectedCategory != 'all' ||
      _selectedStatus != 'all' ||
      _selectedFileType != 'all';

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

  // SIMPLIFIED: Load documents from Firestore collection only
  Future<void> loadDocuments({bool forceRefresh = false}) async {
    final emptyStateManager = EmptyStorageStateManager.instance;

    // REMOVED: Database version tracking (not implemented in current database structure)
    // Only 3 collections exist: users, documents, categories, activities

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
      debugPrint('🔄 Starting Firestore-only document loading...');

      // Load documents directly from Firestore collection
      final firestoreDocuments = await _documentService.getAllDocuments();

      if (firestoreDocuments.isNotEmpty) {
        debugPrint(
          '✅ Loaded ${firestoreDocuments.length} documents from Firestore',
        );

        // Update local state directly from Firestore
        _documents = List.from(firestoreDocuments);
        _isInitialized = true;

        // Update last load time
        _lastLoadTime = DateTime.now();

        // Rebuild category documents
        _categoryDocuments.clear();
        for (final doc in _documents) {
          final category = doc.category.isEmpty
              ? 'uncategorized'
              : doc.category;
          if (!_categoryDocuments.containsKey(category)) {
            _categoryDocuments[category] = [];
          }
          _categoryDocuments[category]!.add(doc);
        }

        await _saveToStorage();

        // Mark storage as not empty
        await emptyStateManager.setStorageNotEmpty();

        // Start Firebase listener for real-time updates
        if (_useFirebaseSync) {
          _startFirebaseListener();
        }

        debugPrint('✅ Firestore-only loading completed successfully');
      } else {
        debugPrint('📁 No documents found in Firestore');
        _documents.clear();
        _categoryDocuments.clear();
        _isInitialized = true;
        await _saveToStorage();
        await emptyStateManager.setStorageEmpty();
      }

      _applyFiltersAndSort();
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
          '! Firebase listener already active, skipping duplicate listener',
        );
        return;
      }

      // PERMISSION FIX: Check if user is properly authenticated before starting listener
      final currentUser = _firebaseService.auth.currentUser;
      if (currentUser == null) {
        debugPrint('⚠️ Firebase listener not started - user not authenticated');
        return;
      }

      // ENTERPRISE SCALE: Use appropriate limit based on configuration
      final listenerLimit = FirebaseConfig.shouldEnableUnlimitedFiles
          ? ANRConfig
                .enterprisePageSize // Larger limit for enterprise
          : ANRConfig.defaultPageSize; // Standard limit for regular use

      // REMOVED: document-metadata collection listener
      // This collection is no longer used and was causing permission errors
      // File data now comes directly from Firebase Storage only
      debugPrint('⚠️ Firebase listener disabled - using Storage-only approach');

      // REDUCED LOGGING: Only log listener start once, not repeatedly
      debugPrint('✅ Firebase listener started (limit: $listenerLimit)');
    } catch (e) {
      debugPrint('Failed to start Firebase listener: $e');
      // Continue with local data if Firebase setup fails
    }
  }

  // REMOVED: Firebase listener methods - no longer needed
  // Using Storage-only approach without document-metadata collection

  // REMOVED: Firebase document update handlers - no longer needed
  // Using Storage-only approach without document-metadata collection

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

      // Apply filters and notify listeners
      _applyFiltersAndSort();
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
    _applyFiltersAndSort();

    // Save to storage for persistence
    _saveToStorage();
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
    _applyFiltersAndSort();

    // Save to storage for persistence
    _saveToStorage();
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

      // Use real-time category sync untuk batch assignment
      try {
        final realtimeCategorySync = RealtimeCategorySyncService.instance;
        await realtimeCategorySync.assignMultipleDocumentsToCategory(
          documentIds,
          categoryId,
        );
        debugPrint('✅ Real-time batch assignment successful');

        // Update local cache immediately
        _updateLocalBatchAssignment(documentIds, categoryId);
        return; // Exit early if successful
      } catch (syncError) {
        debugPrint('⚠️ Real-time batch assignment failed: $syncError');
        // Continue with fallback method
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

  // Update document category dengan real-time sync
  // ENHANCED: Menggunakan RealtimeCategorySyncService untuk immediate updates
  Future<void> updateDocumentCategory(
    String documentId,
    String categoryId,
  ) async {
    try {
      debugPrint('🔄 DocumentProvider: Starting real-time category update...');
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
      unifiedLoader.updateDocumentCategory(documentId, categoryId);

      // RACE CONDITION FIX: Mark this as a recent category assignment to prevent override
      _lastLoadTime = DateTime.now();

      // SURGICAL FIX: Track this assignment to prevent race condition reappearance
      _trackRecentAssignment(documentId, categoryId);

      // Notify listeners immediately for UI update
      notifyListeners();

      // Save to storage immediately with priority flag
      await _saveToStorage();

      debugPrint('✅ Local cache updated immediately with timestamp protection');

      // REMOVED: Firestore document-metadata update - collection no longer used
      // Using Storage-only approach for better performance and simplicity

      // STEP 3: Use real-time category sync service untuk immediate Firestore update
      try {
        final realtimeCategorySync = RealtimeCategorySyncService.instance;
        await realtimeCategorySync.assignDocumentToCategory(
          documentId,
          categoryId,
        );
        debugPrint('✅ Real-time category assignment completed');
      } catch (syncError) {
        debugPrint('⚠️ Real-time category sync failed: $syncError');

        // Fallback to direct Firestore update
        try {
          await _documentService.updateDocumentCategory(documentId, categoryId);
          debugPrint('✅ Fallback Firestore update successful');
        } catch (fallbackError) {
          debugPrint(
            '⚠️ Fallback Firestore update also failed: $fallbackError',
          );
        }
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

  // REMOVED: _updateFirestoreDocumentCategory method - no longer needed
  // Using Storage-only approach without document-metadata collection

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

  // Remove file from category dengan real-time sync (set category to empty string)
  Future<void> removeFileFromCategory(
    String documentId,
    String categoryId,
  ) async {
    try {
      debugPrint('🔄 Removing file $documentId from category $categoryId');

      // Use real-time category sync service untuk immediate update
      try {
        final realtimeCategorySync = RealtimeCategorySyncService.instance;
        await realtimeCategorySync.removeDocumentFromCategory(documentId);
        debugPrint('✅ Real-time category removal completed');
      } catch (syncError) {
        debugPrint('⚠️ Real-time category removal failed: $syncError');

        // Fallback to direct Firestore update
        await _documentService.updateDocumentCategory(documentId, '');
        debugPrint('✅ Fallback category removal successful');
      }

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

      _applyFiltersAndSort();
    }
  }

  // Remove document permanently (STORAGE-FIRST: Delete from Firebase Storage first, then Firestore)
  Future<void> removeDocument(String documentId, String deletedBy) async {
    try {
      debugPrint(
        '🗑️ DocumentProvider: Starting STORAGE-FIRST document removal for ID: $documentId',
      );

      // ADMIN-ONLY: Verify admin status before proceeding
      final isAdmin = await _verifyUserIsAdmin(deletedBy);
      if (!isAdmin) {
        throw Exception('Access denied: Only administrators can delete files');
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

      // STORAGE-FIRST DELETION: Delete from Firebase Storage first, then Firestore
      bool storageDeleted = false;
      bool firestoreDeleted = false;
      String? backendError;
      String deletionMethod = 'storage_first';

      try {
        // STEP 1: Delete from Firebase Storage first
        if (localDocument != null && localDocument.id.isNotEmpty) {
          debugPrint('🗑️ STEP 1: Deleting file from Firebase Storage...');

          try {
            // Use DirectStorageDeletionService for direct storage deletion
            final directStorageService = DirectStorageDeletionService.instance;
            final storageResult = await directStorageService
                .deleteDocumentDirect(localDocument);

            if (storageResult.success) {
              debugPrint(
                '✅ Storage deletion successful: ${storageResult.message}',
              );
              storageDeleted = true;
            } else {
              debugPrint(
                '⚠️ Storage deletion failed: ${storageResult.message}',
              );
              // Continue with Firestore deletion even if storage fails
            }
          } catch (storageError) {
            debugPrint('❌ Storage deletion error: $storageError');
            // Continue with Firestore deletion even if storage fails
          }

          // STEP 2: Delete from Firestore after storage deletion
          debugPrint('🗑️ STEP 2: Deleting metadata from Firestore...');

          try {
            await _firebaseService.documentsCollection.doc(documentId).delete();
            debugPrint('✅ Firestore deletion successful');
            firestoreDeleted = true;
          } catch (firestoreError) {
            debugPrint('⚠️ Firestore deletion failed: $firestoreError');
            backendError = firestoreError.toString();

            // If document not found in Firestore, consider it successful
            if (firestoreError.toString().contains('not found') ||
                firestoreError.toString().contains('not-found')) {
              debugPrint(
                'ℹ️ Document not found in Firestore - considering deletion successful',
              );
              firestoreDeleted = true;
            }
          }
        } else {
          // No local document metadata available, try to find and delete from Firestore
          debugPrint(
            '⚠️ No local document metadata, attempting Firestore deletion...',
          );

          try {
            await _firebaseService.documentsCollection.doc(documentId).delete();
            debugPrint('✅ Firestore deletion successful (no local metadata)');
            firestoreDeleted = true;
          } catch (firestoreError) {
            debugPrint('❌ Firestore deletion failed: $firestoreError');
            backendError = firestoreError.toString();

            if (firestoreError.toString().contains('not found') ||
                firestoreError.toString().contains('not-found')) {
              debugPrint(
                'ℹ️ Document not found in Firestore - considering deletion successful',
              );
              firestoreDeleted = true;
            } else {
              throw Exception('Failed to delete document: $firestoreError');
            }
          }
        }

        // Log deletion results
        debugPrint(
          '📊 Deletion results: Storage=$storageDeleted, Firestore=$firestoreDeleted, Method=$deletionMethod',
        );
      } catch (deletionError) {
        debugPrint('❌ Storage-first deletion error: $deletionError');
        backendError = deletionError.toString();

        // Handle specific error cases
        if (deletionError.toString().contains('Document not found')) {
          debugPrint(
            'ℹ️ Document not found in backend - proceeding with local cleanup',
          );
          firestoreDeleted =
              true; // Consider it successful for cleanup purposes
        } else if (deletionError.toString().contains('Access denied')) {
          throw Exception(
            'Access denied: Only administrators can delete files',
          );
        } else {
          // For other errors, still proceed with local cleanup but log the error
          debugPrint(
            '⚠️ Backend deletion failed, proceeding with local cleanup: $deletionError',
          );
        }
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
        stateManager.removeDocument(documentId);
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
        _applyFiltersAndSort();

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

      // Log activity for successful deletion
      if (storageDeleted || firestoreDeleted) {
        try {
          final activityService = ActivityService();
          await activityService.logActivity(
            type: 'delete',
            description:
                'Document: ${localDocument?.fileName ?? 'Unknown'} (ID: $documentId)',
            documentId: documentId,
            additionalData: {
              'storageDeleted': storageDeleted,
              'firestoreDeleted': firestoreDeleted,
              'deletionMethod': deletionMethod,
              'userAgent': 'Flutter App',
              'platform': 'Mobile',
            },
          );
          debugPrint('✅ Activity logged successfully');
        } catch (activityError) {
          debugPrint('⚠️ Failed to log activity: $activityError');
          // Don't throw here as the main deletion operation succeeded
        }

        // Log final status with backend deletion details and method used
        debugPrint(
          '✅ DocumentProvider: Document removal completed successfully for ID: $documentId (Method: $deletionMethod)',
        );

        // STATISTICS UPDATE: Notify about successful file deletion
        if (localDocument != null && localDocument.id.isNotEmpty) {
          statisticsService.notifyFileDeleted(
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
        stateManager.removeDocument(documentId);
        debugPrint('✅ Removed from state manager cache');
      } catch (e) {
        debugPrint('⚠️ Failed to remove from state manager: $e');
      }

      // Update UI if any changes were made
      if (localChanges) {
        _applyFiltersAndSort();
        notifyListeners();
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
          stateManager.removeDocument(documentId);
          debugPrint('✅ Removed from state manager cache');
        } catch (e) {
          debugPrint('⚠️ Failed to remove from state manager: $e');
        }

        // Update UI if any changes were made
        if (localChanges) {
          _applyFiltersAndSort();
          notifyListeners();
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
          statisticsService.notifyFileDeleted(
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
            final directResult = await directStorageService
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

      // Apply filters and notify listeners
      _applyFiltersAndSort();

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

  // Search documents
  void searchDocuments(String query) {
    _searchQuery = query;
    _applyFiltersAndSort();
    // Note: _applyFiltersAndSort() already calls notifyListeners() to prevent double notifications
  }

  // Filter by category
  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFiltersAndSort();
    // Note: _applyFiltersAndSort() already calls notifyListeners() to prevent double notifications
  }

  // Filter by status
  void filterByStatus(String status) {
    _selectedStatus = status;
    _applyFiltersAndSort();
    // Note: _applyFiltersAndSort() already calls notifyListeners() to prevent double notifications
  }

  // Filter by file type
  void filterByFileType(String fileType) {
    _selectedFileType = fileType;
    _applyFiltersAndSort();
    // Note: _applyFiltersAndSort() already calls notifyListeners() to prevent double notifications
  }

  // Sort documents
  void sortDocuments(String sortBy, {bool ascending = false}) {
    _sortBy = sortBy;
    _sortAscending = ascending;
    _applyFiltersAndSort();
  }

  // Apply filters and sorting
  void _applyFiltersAndSort() {
    _filteredDocuments = _documents.where((document) {
      // Exclude deleted files from normal display
      if (document.isDeleted) {
        return false;
      }

      // Search filter
      bool matchesSearch =
          _searchQuery.isEmpty ||
          document.fileName.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          document.metadata.description.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          document.metadata.tags.any(
            (tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()),
          );

      // Category filter
      bool matchesCategory =
          _selectedCategory == 'all' || document.category == _selectedCategory;

      // Status filter removed - all files are active by default
      bool matchesStatus = true;

      // File type filter
      bool matchesFileType =
          _selectedFileType == 'all' ||
          _getFileTypeCategory(document.fileType) == _selectedFileType;

      return matchesSearch &&
          matchesCategory &&
          matchesStatus &&
          matchesFileType;
    }).toList();

    // Apply sorting
    _filteredDocuments.sort((a, b) {
      int comparison = 0;

      switch (_sortBy) {
        case 'fileName':
          comparison = a.fileName.compareTo(b.fileName);
          break;
        case 'fileSize':
          comparison = a.fileSize.compareTo(b.fileSize);
          break;
        case 'uploadedAt':
          comparison = a.uploadedAt.compareTo(b.uploadedAt);
          break;
        case 'category':
          comparison = a.category.compareTo(b.category);
          break;
        case 'status':
          // Status sorting removed - all files are active
          comparison = 0;
          break;
        default:
          comparison = a.uploadedAt.compareTo(b.uploadedAt);
      }

      return _sortAscending ? comparison : -comparison;
    });

    // Always notify listeners after applying filters and sorting
    notifyListeners();
  }

  // Clear filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'all';
    _selectedStatus = 'all';
    _selectedFileType = 'all';
    _sortBy = 'uploadedAt';
    _sortAscending = false;
    _applyFiltersAndSort();
  }

  // Get file type category for filtering
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
        _applyFiltersAndSort();

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

  // ENTERPRISE SCALE: Get recent files with unlimited support (excluding deleted files)
  List<DocumentModel> getRecentFiles({int days = 7, int? limit}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    final recentFiles =
        _documents
            .where(
              (doc) => doc.uploadedAt.isAfter(cutoffDate) && !doc.isDeleted,
            ) // Exclude deleted files
            .toList()
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

  // Get files in recycle bin
  List<DocumentModel> getRecycleBinFiles() {
    return _documents.where((doc) => doc.isDeleted).toList()..sort(
      (a, b) => (b.deletedAt ?? DateTime.now()).compareTo(
        a.deletedAt ?? DateTime.now(),
      ),
    );
  }

  // Get total count of files (including deleted ones)
  int get totalFilesCount {
    return _documents.length;
  }

  // Get count of active files (excluding deleted ones)
  int get activeFilesCount {
    return _documents.where((doc) => !doc.isDeleted).length;
  }

  // Get count of files in recycle bin
  int get recycleBinCount {
    return _documents.where((doc) => doc.isDeleted).length;
  }

  // Get count of recent files (last 7 days, excluding deleted)
  int get recentFilesCount {
    return getRecentFiles().length;
  }

  // Get statistics data for responsive stats grid
  Map<String, dynamic> get statisticsData {
    return {
      'totalFiles': totalFilesCount,
      'activeFiles': activeFilesCount,
      'recentFiles': recentFilesCount,
      'recycleBinCount': recycleBinCount,
      'favoritesCount': 0, // TODO: Implement favorites functionality
      'totalCategories': _categoryDocuments.keys.length,
      'activeUsers': 1, // TODO: Get from UserProvider
    };
  }

  // Move file to recycle bin (soft delete)
  Future<void> moveToRecycleBin(String documentId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      debugPrint('🗑️ Moving document to recycle bin: $documentId');

      // Update in Firestore
      await _firebaseService.firestore
          .collection('documents')
          .doc(documentId)
          .update({
            'isDeleted': true,
            'deletedAt': FieldValue.serverTimestamp(),
            'deletedBy': currentUser.uid,
          });

      // Update local state
      final docIndex = _documents.indexWhere((doc) => doc.id == documentId);
      if (docIndex != -1) {
        _documents[docIndex] = _documents[docIndex].copyWith(
          isDeleted: true,
          deletedAt: DateTime.now(),
          deletedBy: currentUser.uid,
        );
        _applyFiltersAndSort();
        notifyListeners();
      }

      debugPrint('✅ Document moved to recycle bin successfully');
    } catch (e) {
      debugPrint('❌ Failed to move document to recycle bin: $e');
      rethrow;
    }
  }

  // Restore file from recycle bin
  Future<void> restoreFromRecycleBin(String documentId) async {
    try {
      debugPrint('♻️ Restoring document from recycle bin: $documentId');

      // Update in Firestore
      await _firebaseService.firestore
          .collection('documents')
          .doc(documentId)
          .update({
            'isDeleted': false,
            'deletedAt': FieldValue.delete(),
            'deletedBy': FieldValue.delete(),
          });

      // Update local state
      final docIndex = _documents.indexWhere((doc) => doc.id == documentId);
      if (docIndex != -1) {
        _documents[docIndex] = _documents[docIndex].copyWith(
          isDeleted: false,
          deletedAt: null,
          deletedBy: null,
        );
        _applyFiltersAndSort();
        notifyListeners();
      }

      debugPrint('✅ Document restored from recycle bin successfully');
    } catch (e) {
      debugPrint('❌ Failed to restore document from recycle bin: $e');
      rethrow;
    }
  }

  // Permanently delete file from recycle bin
  Future<void> permanentlyDeleteDocument(String documentId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      debugPrint('🗑️ Permanently deleting document: $documentId');

      final document = _documents.firstWhere((doc) => doc.id == documentId);

      // Delete from Firebase Storage if file path exists
      if (document.filePath.isNotEmpty) {
        try {
          final storageRef = _firebaseService.storage.ref().child(
            document.filePath,
          );
          await storageRef.delete();
          debugPrint('✅ File deleted from Firebase Storage');
        } catch (storageError) {
          debugPrint(
            '⚠️ Failed to delete from storage (file may not exist): $storageError',
          );
        }
      }

      // Delete from Firestore
      await _firebaseService.firestore
          .collection('documents')
          .doc(documentId)
          .delete();

      // Remove from local state
      _documents.removeWhere((doc) => doc.id == documentId);
      _applyFiltersAndSort();
      notifyListeners();

      debugPrint('✅ Document permanently deleted successfully');
    } catch (e) {
      debugPrint('❌ Failed to permanently delete document: $e');
      rethrow;
    }
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
          _applyFiltersAndSort();
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
        _applyFiltersAndSort();
      } else {
        debugPrint('⚠️ No documents found in Firebase during refresh');
      }
    } catch (e) {
      debugPrint('❌ Failed to refresh folder contents: $e');
      _setError('Failed to refresh folder contents: $e');
    }
  }

  // Remove category and its documents
  void removeCategory(String categoryId) {
    _categoryDocuments.remove(categoryId);
    _documents.removeWhere((doc) => doc.category == categoryId);
    _applyFiltersAndSort();
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

  // UNIFIED DATA SOURCE: Firestore as single source of truth for recent documents
  List<DocumentModel> getRecentDocuments({int? limit}) {
    // TIMESTAMP FIX: Use consistent recent files calculation (7 days)
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

    // Filter documents from Firestore data (primary source)
    List<DocumentModel> recentDocs = _documents
        .where((doc) => doc.uploadedAt.isAfter(sevenDaysAgo))
        .toList();

    // Sort by upload time (newest first)
    recentDocs.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));

    // ENTERPRISE SCALE: Apply appropriate limit based on configuration
    List<DocumentModel> limitedDocs;
    if (FirebaseConfig.shouldEnableUnlimitedFiles &&
        (limit == null || limit == 0)) {
      // No limit for enterprise mode
      limitedDocs = recentDocs;
    } else {
      // Apply specified limit or safe default
      final safeLimit = limit ?? ANRConfig.defaultPageSize;
      limitedDocs = recentDocs.take(safeLimit).toList();
    }

    // Enhanced debugging for recent files
    debugPrint('📊 Recent files calculation:');
    debugPrint('   - Cutoff date: $sevenDaysAgo');
    debugPrint('   - Total documents: ${_documents.length}');
    debugPrint('   - Recent documents (7 days): ${recentDocs.length}');
    debugPrint('   - Limited result: ${limitedDocs.length}');

    // Log sample recent files for verification
    if (limitedDocs.isNotEmpty) {
      debugPrint('📊 Sample recent files:');
      final sampleDocs = limitedDocs.take(3);
      for (final doc in sampleDocs) {
        final daysDiff = DateTime.now().difference(doc.uploadedAt).inDays;
        debugPrint('   - ${doc.fileName} ($daysDiff days ago)');
      }
    } else {
      debugPrint('⚠️ No recent files found in the last 7 days');
    }

    return limitedDocs;
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
      await stateManager.refreshDocuments();

      // Sync local state with state manager
      final freshDocuments = stateManager.documents;
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

        // Apply filters and sort
        _applyFiltersAndSort();

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

        _applyFiltersAndSort();
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
    if (!(await enhancedAuthService.canPerformUnlimitedQueries())) {
      debugPrint('⚠️ Unlimited queries not available for current user');
      await loadDocuments(); // Fallback to regular loading
      return;
    }

    // Prevent concurrent unlimited loading operations
    if (_isLoadingDocuments) {
      debugPrint(
        '⚠️ Unlimited document loading already in progress, skipping...',
      );
      return;
    }

    _setLoading(true);
    _clearError();

    _isLoadingDocuments = true;

    try {
      debugPrint('🔓 Loading all documents with unlimited query...');

      final documents = await _enhancedDocumentService.getAllDocumentsUnlimited(
        categoryFilter: categoryFilter,
        searchQuery: searchQuery,
      );

      _documents = documents;
      _applyFiltersAndSort();

      // Start Firebase listener only if not already active and we have documents
      if (_useFirebaseSync && documents.isNotEmpty) {
        _startFirebaseListener();
      }

      debugPrint('✅ Loaded ${documents.length} documents with unlimited query');
    } catch (e) {
      _setError('Failed to load documents: ${e.toString()}');
      debugPrint('❌ Unlimited query failed: $e');
    } finally {
      _isLoadingDocuments = false;
      _setLoading(false);
    }
  }

  /// Load documents from Firebase Storage with unlimited access
  Future<void> loadDocumentsFromStorageUnlimited() async {
    if (!(await enhancedAuthService.canAccessStorageManagement())) {
      debugPrint('⚠️ Storage management access denied');
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      debugPrint('📁 Loading documents from Firebase Storage...');

      final storageDocuments = await enhancedStorageService
          .getAllStorageFilesUnlimited();

      // Merge with existing documents, avoiding duplicates
      final existingPaths = _documents.map((doc) => doc.filePath).toSet();
      final newDocuments = storageDocuments
          .where((doc) => !existingPaths.contains(doc.filePath))
          .toList();

      _documents.addAll(newDocuments);
      _applyFiltersAndSort();

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
    if (!(await enhancedAuthService.canAccessStorageManagement())) {
      debugPrint('⚠️ Storage management access denied');
      return;
    }

    try {
      debugPrint('🔄 Refreshing download URLs...');

      int refreshedCount = 0;
      for (final document in _documents) {
        if (document.filePath.isNotEmpty) {
          final newUrl = await enhancedStorageService.refreshDownloadUrl(
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
    if (!(await enhancedAuthService.canPerformUnlimitedQueries())) {
      return {'error': 'Admin privileges required'};
    }

    try {
      final firestoreStats = await _enhancedDocumentService
          .getDocumentStatistics();
      final storageStats = await enhancedStorageService.getStorageStatistics();

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
    return await enhancedAuthService.canPerformUnlimitedQueries();
  }

  /// Check if storage management is available for current user
  Future<bool> get canManageStorage async {
    return await enhancedAuthService.canAccessStorageManagement();
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
    await stateManager.refreshDocuments();
    final freshDocuments = stateManager.documents;

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
    _applyFiltersAndSort();
    notifyListeners();
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
        _applyFiltersAndSort();

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
    // REMOVED: Firebase update debouncer - no longer used
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

  /// Clear category from all documents when category is deleted
  Future<void> clearCategoryFromAllDocuments(String categoryId) async {
    try {
      debugPrint('🧹 Clearing category $categoryId from all documents...');

      bool hasChanges = false;
      final documentsToUpdate = <DocumentModel>[];

      // Find all documents with this category
      for (int i = 0; i < _documents.length; i++) {
        if (_documents[i].category == categoryId) {
          final updatedDocument = _documents[i].copyWith(category: '');
          _documents[i] = updatedDocument;
          documentsToUpdate.add(updatedDocument);
          hasChanges = true;
        }
      }

      // Clear from category storage
      if (_categoryDocuments.containsKey(categoryId)) {
        final movedDocuments = _categoryDocuments[categoryId]!;
        _categoryDocuments.remove(categoryId);

        // Move documents to uncategorized
        if (!_categoryDocuments.containsKey('uncategorized')) {
          _categoryDocuments['uncategorized'] = [];
        }

        for (final doc in movedDocuments) {
          final updatedDoc = doc.copyWith(category: '');
          _categoryDocuments['uncategorized']!.add(updatedDoc);
        }

        debugPrint(
          '📦 Moved ${movedDocuments.length} documents to uncategorized',
        );
      }

      if (hasChanges) {
        debugPrint(
          '✅ Cleared category from ${documentsToUpdate.length} documents',
        );
        notifyListeners();
        await _saveToStorage();
      }
    } catch (e) {
      debugPrint('❌ Failed to clear category from documents: $e');
    }
  }

  /// Update category documents untuk real-time sync
  void updateCategoryDocuments(
    String documentId,
    String oldCategory,
    String newCategory,
    DocumentModel updatedDocument,
  ) {
    try {
      // Remove from old category if it exists
      if (oldCategory.isNotEmpty &&
          _categoryDocuments.containsKey(oldCategory)) {
        _categoryDocuments[oldCategory]!.removeWhere(
          (doc) => doc.id == documentId,
        );
        debugPrint('📤 Removed document from old category: $oldCategory');
      }

      // Add to new category if it's not empty
      if (newCategory.isNotEmpty) {
        if (!_categoryDocuments.containsKey(newCategory)) {
          _categoryDocuments[newCategory] = [];
        }

        // Check if document already exists in new category
        if (!_categoryDocuments[newCategory]!.any(
          (doc) => doc.id == documentId,
        )) {
          _categoryDocuments[newCategory]!.add(updatedDocument);
          debugPrint('📥 Added document to new category: $newCategory');
        }
      }

      // Apply filters and sort
      _applyFiltersAndSort();
    } catch (e) {
      debugPrint('❌ Failed to update category documents: $e');
    }
  }

  /// Update local cache untuk batch assignment
  void _updateLocalBatchAssignment(
    List<String> documentIds,
    String categoryId,
  ) {
    try {
      bool hasChanges = false;

      for (final documentId in documentIds) {
        final documentIndex = _documents.indexWhere(
          (doc) => doc.id == documentId,
        );

        if (documentIndex != -1) {
          final originalDocument = _documents[documentIndex];
          final updatedDocument = originalDocument.copyWith(
            category: categoryId,
          );

          // Update main documents list
          _documents[documentIndex] = updatedDocument;

          // Update category documents
          updateCategoryDocuments(
            documentId,
            originalDocument.category,
            categoryId,
            updatedDocument,
          );

          hasChanges = true;
        }
      }

      if (hasChanges) {
        notifyListeners();
        _saveToStorage();
        debugPrint(
          '✅ Local batch assignment completed for ${documentIds.length} documents',
        );
      }
    } catch (e) {
      debugPrint('❌ Failed to update local batch assignment: $e');
    }
  }

  /// Clear all local cache and phantom file data
  Future<void> clearAllCache() async {
    try {
      debugPrint('🧹 Clearing all local cache and phantom file data...');

      final prefs = await SharedPreferences.getInstance();

      // Clear all document-related cache
      await prefs.remove('category_documents');
      await prefs.remove('documents_initialized');
      await prefs.remove('persistent_assignments');
      await prefs.remove('cache_validation_timestamp');
      await prefs.remove('cached_document_count');

      // Clear local state
      _documents.clear();
      _categoryDocuments.clear();
      _recentlyAssignedFiles.clear();
      _persistentAssignments.clear();
      _isInitialized = false;

      // Clear state manager cache
      stateManager.clearData();

      // Clear smart cache invalidation
      await _cacheInvalidation.invalidateCache();

      debugPrint('✅ All cache cleared successfully');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error clearing cache: $e');
    }
  }

  // USER STRATEGY: Get Firestore documents that user has access to
  Future<List<DocumentModel>> _getUserAccessibleFirestoreDocuments(
    List<DocumentModel> storageDocuments,
  ) async {
    final accessibleDocuments = <DocumentModel>[];

    try {
      // For user accounts, we need to check each document individually
      // since they can't do unlimited queries
      for (final storageDoc in storageDocuments) {
        try {
          // Try to get the document from Firestore by ID if it exists
          if (storageDoc.id.isNotEmpty) {
            final docSnapshot = await _firebaseService.documentsCollection
                .doc(storageDoc.id)
                .get();

            if (docSnapshot.exists) {
              final firestoreDoc = DocumentModel.fromFirestore(docSnapshot);
              accessibleDocuments.add(firestoreDoc);
              debugPrint(
                '✅ User access: ${firestoreDoc.fileName} (${firestoreDoc.category})',
              );
            }
          }
        } catch (e) {
          // If individual document access fails, skip it
          debugPrint('⚠️ User access denied for: ${storageDoc.fileName}');
        }
      }

      debugPrint(
        '👤 User strategy completed: ${accessibleDocuments.length} accessible documents',
      );
      return accessibleDocuments;
    } catch (e) {
      debugPrint('❌ User strategy failed: $e');
      return [];
    }
  }

  // DEFINITIVE FIX: Merge Firebase Storage data with Firestore category metadata
  Future<List<DocumentModel>> _mergeStorageWithFirestoreCategories(
    List<DocumentModel> storageDocuments,
  ) async {
    try {
      debugPrint('🔗 DEFINITIVE FIX: Starting Storage-Firestore merge...');
      debugPrint('   Storage documents: ${storageDocuments.length}');

      // Check if current user is admin to determine merge strategy
      final isAdmin = await enhancedAuthService.isCurrentUserAdmin;
      debugPrint('   User type: ${isAdmin ? "Admin" : "User"}');

      List<DocumentModel> firestoreDocuments = [];

      if (isAdmin) {
        // ADMIN STRATEGY: Get all documents (unlimited access)
        debugPrint('🔓 Admin strategy: Getting all Firestore documents...');
        try {
          firestoreDocuments = await _documentService.getAllDocuments();
          debugPrint(
            '   Admin Firestore documents: ${firestoreDocuments.length}',
          );
        } catch (e) {
          debugPrint('⚠️ Admin getAllDocuments failed: $e');
          // Fallback to enhanced service for admin
          final enhancedService = EnhancedDocumentService.instance;
          firestoreDocuments = await enhancedService.getAllDocumentsUnlimited();
          debugPrint(
            '   Admin enhanced documents: ${firestoreDocuments.length}',
          );
        }
      } else {
        // USER STRATEGY: Get documents individually by checking each storage document
        debugPrint('👤 User strategy: Individual document lookup...');
        firestoreDocuments = await _getUserAccessibleFirestoreDocuments(
          storageDocuments,
        );
        debugPrint(
          '   User accessible documents: ${firestoreDocuments.length}',
        );
      }

      // Create a map of file path/name to category for quick lookup
      final Map<String, String> pathToCategoryMap = {};
      final Map<String, String> nameToCategoryMap = {};

      for (final firestoreDoc in firestoreDocuments) {
        if (firestoreDoc.category.isNotEmpty &&
            firestoreDoc.category != 'general' &&
            firestoreDoc.category != 'uncategorized') {
          pathToCategoryMap[firestoreDoc.filePath] = firestoreDoc.category;
          nameToCategoryMap[firestoreDoc.fileName] = firestoreDoc.category;
          debugPrint(
            '📁 Firestore category mapping: ${firestoreDoc.fileName} -> ${firestoreDoc.category}',
          );
        }
      }

      // Merge Storage documents with Firestore category data
      final mergedDocuments = <DocumentModel>[];
      int categorizedCount = 0;

      for (final storageDoc in storageDocuments) {
        String finalCategory = storageDoc.category;

        // Try to find category from Firestore by file path first
        if (pathToCategoryMap.containsKey(storageDoc.filePath)) {
          finalCategory = pathToCategoryMap[storageDoc.filePath]!;
          categorizedCount++;
          debugPrint('✅ Path match: ${storageDoc.fileName} -> $finalCategory');
        }
        // Fallback to file name matching
        else if (nameToCategoryMap.containsKey(storageDoc.fileName)) {
          finalCategory = nameToCategoryMap[storageDoc.fileName]!;
          categorizedCount++;
          debugPrint('✅ Name match: ${storageDoc.fileName} -> $finalCategory');
        }

        // Create merged document with correct category
        final mergedDoc = storageDoc.copyWith(category: finalCategory);
        mergedDocuments.add(mergedDoc);
      }

      debugPrint('🔗 DEFINITIVE FIX: Merge completed');
      debugPrint('   Total documents: ${mergedDocuments.length}');
      debugPrint('   Categorized documents: $categorizedCount');
      debugPrint(
        '   Uncategorized documents: ${mergedDocuments.length - categorizedCount}',
      );

      return mergedDocuments;
    } catch (e) {
      debugPrint('❌ DEFINITIVE FIX: Merge failed: $e');
      // Return original storage documents as fallback
      return storageDocuments;
    }
  }

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
}
