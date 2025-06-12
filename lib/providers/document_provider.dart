import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import '../models/document_model.dart';
import '../core/services/document_service.dart';
import '../core/services/firebase_service.dart';
import '../core/services/category_service.dart';
// DISABLED: Regular sync service to prevent duplicate operations
// import '../services/firebase_storage_sync_service.dart';
import '../services/optimized_firebase_storage_sync_service.dart';
import '../services/file_category_management_service.dart';
import '../services/cloud_functions_service.dart';
import '../core/utils/anr_prevention.dart';
import '../core/config/anr_config.dart';
import '../config/firebase_config.dart';
import 'category_provider.dart';
import '../services/firebase_storage_direct_service.dart';
import '../services/enhanced_document_service.dart';
import '../services/enhanced_firebase_storage_service.dart';
import '../services/enhanced_auth_service.dart';
import '../services/document_state_manager.dart';

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

  // Enhanced services
  final EnhancedDocumentService _enhancedDocumentService =
      EnhancedDocumentService.instance;
  final EnhancedFirebaseStorageService _enhancedStorageService =
      EnhancedFirebaseStorageService.instance;
  final EnhancedAuthService _enhancedAuthService = EnhancedAuthService.instance;

  // ARCHITECTURAL FIX: Centralized state management
  final DocumentStateManager _stateManager = DocumentStateManager.instance;

  // Dynamic document storage - persists during app session
  static final Map<String, List<DocumentModel>> _categoryDocuments = {};
  static bool _isInitialized = false;

  // Firebase real-time listener
  final FirebaseService _firebaseService = FirebaseService.instance;
  final DocumentService _documentService = DocumentService.instance;
  // Use optimized sync service to prevent duplicate operations
  final OptimizedFirebaseStorageSyncService _optimizedSyncService =
      OptimizedFirebaseStorageSyncService.instance;
  // Firebase Storage direct service for primary data source
  final FirebaseStorageDirectService _storageDirectService =
      FirebaseStorageDirectService.instance;
  StreamSubscription? _documentsSubscription;
  final bool _useFirebaseSync =
      true; // Enable Firebase sync for data persistence
  bool _isProcessingFirebaseUpdate = false; // Prevent duplicate processing
  Timer? _firebaseUpdateDebouncer; // Debounce Firebase updates
  bool _isLoadingDocuments = false; // Prevent concurrent document loading

  // Getters
  List<DocumentModel> get documents => _filteredDocuments;
  List<DocumentModel> get allDocuments => _documents;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedFileType => _selectedFileType;
  String get selectedCategory => _selectedCategory;
  String get selectedStatus => _selectedStatus;
  String get sortBy => _sortBy;
  bool get sortAscending => _sortAscending;
  bool get isFirebaseSyncActive => _documentsSubscription != null;

  // Load documents with Firebase real-time sync - FIXED: Prevent excessive operations
  Future<void> loadDocuments() async {
    // Prevent concurrent loading operations
    if (_isLoadingDocuments) {
      debugPrint('⚠️ Document loading already in progress, skipping...');
      return;
    }

    _isLoadingDocuments = true;
    _setLoading(true);
    _clearError();

    try {
      debugPrint('🔄 Starting document loading process...');

      // CRITICAL FIX: Skip automatic sync during regular loading to prevent document creation
      bool firebaseDataLoaded = false;
      if (_useFirebaseSync && FirebaseConfig.shouldEnableStorageSync) {
        try {
          debugPrint('🔄 Starting Firebase Storage sync...');

          // FIXED: Use direct document service instead of sync service to prevent new document creation
          final firebaseDocuments = await ANRPrevention.executeNetworkOperation(
            _documentService.getAllDocuments(),
            operationName: 'Direct Firestore Document Load',
          );

          if (firebaseDocuments != null && firebaseDocuments.isNotEmpty) {
            debugPrint(
              '📥 Loading ${firebaseDocuments.length} documents from Firebase service',
            );
            _handleFirebaseDocumentModels(firebaseDocuments);
            firebaseDataLoaded = true;
            _isInitialized = true;
            await _saveToStorage();
            // Notify listeners immediately after loading
            notifyListeners();
          }
        } catch (firebaseError) {
          debugPrint('Firebase load error: $firebaseError');
          // Continue to try local storage if Firebase fails
        }
      }

      // If Firebase data wasn't loaded, try local storage
      if (!firebaseDataLoaded) {
        debugPrint('🔄 Loading from local storage...');
        await _loadFromStorage();

        // If no local data either, try one more time with Firebase
        if (_categoryDocuments.isEmpty) {
          try {
            debugPrint(
              '🔄 No local data found, making final Firebase attempt...',
            );
            final firebaseDocuments = await _documentService.getAllDocuments();
            if (firebaseDocuments.isNotEmpty) {
              debugPrint(
                '📥 Final attempt: Loading ${firebaseDocuments.length} documents from Firebase',
              );
              _handleFirebaseDocumentModels(firebaseDocuments);
              firebaseDataLoaded = true;
              _isInitialized = true;
              await _saveToStorage();
              // Notify listeners after final load
              notifyListeners();
            }
          } catch (finalError) {
            debugPrint('Final Firebase attempt failed: $finalError');
          }
        } else {
          // Notify listeners if we loaded from local storage
          debugPrint(
            '📱 Loaded ${_categoryDocuments.length} categories from local storage',
          );
          notifyListeners();
        }

        // Start with empty state for new users only if no data was found anywhere
        if (!_isInitialized && _categoryDocuments.isEmpty) {
          debugPrint('📝 No data found anywhere, starting with empty state');
          _isInitialized = true;
          await _saveToStorage();
          notifyListeners();
        }
      }

      // Rebuild main documents list from category documents
      _documents = [];
      _categoryDocuments.forEach((categoryId, docs) {
        _documents.addAll(docs);
      });

      debugPrint(
        '📊 Document loading summary: ${_documents.length} total documents in ${_categoryDocuments.keys.length} categories',
      );

      // Ensure all existing categories are properly initialized
      await _ensureCategoriesInitialized();

      // Start Firebase real-time listener if enabled
      if (_useFirebaseSync) {
        _startFirebaseListener();
      }

      // Run duplicate cleanup after initial load
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await cleanupDuplicateDocuments();
      });

      _applyFiltersAndSort();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
      _isLoadingDocuments = false; // Reset loading flag
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

      // ENHANCED FIX: Use larger limit for recent files consistency
      // Recent files need more comprehensive data than the default page size
      final listenerLimit =
          ANRConfig.maxItemsPerPage * 2; // Double the limit for recent files

      _documentsSubscription = _firebaseService.documentsCollection
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
              debugPrint('Firebase listener error: $error');
              // Continue with local data if Firebase fails
              _setError('Real-time sync temporarily unavailable');
            },
          );

      debugPrint(
        '✅ Firebase real-time listener started for documents (limit: $listenerLimit)',
      );
    } catch (e) {
      debugPrint('Failed to start Firebase listener: $e');
      // Continue with local data if Firebase setup fails
    }
  }

  // Handle Firebase document updates from snapshots
  void _handleFirebaseDocumentUpdates(List<QueryDocumentSnapshot> docs) {
    // Debounce Firebase updates to prevent excessive calls - increased to 2 seconds
    _firebaseUpdateDebouncer?.cancel();
    _firebaseUpdateDebouncer = Timer(const Duration(seconds: 2), () {
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
      // Only log if there are significant changes to reduce noise
      if (docs.length != _documents.length) {
        debugPrint(
          '📥 Processing ${docs.length} documents from Firebase listener',
        );
      }

      final firebaseDocuments = docs
          .map((doc) => DocumentModel.fromFirestore(doc as DocumentSnapshot))
          .toList();

      // Merge Firebase documents with local documents
      _mergeFirebaseDocuments(firebaseDocuments, isFromListener: true);

      // Apply filters and notify listeners
      _applyFiltersAndSort();
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

      // Clear existing category documents to rebuild from Firebase data
      _categoryDocuments.clear();
      _documents.clear();

      // Use the same merge logic to prevent duplicates
      _mergeFirebaseDocuments(firebaseDocuments, isFromListener: false);

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
  Future<void> updateDocumentCategory(
    String documentId,
    String categoryId,
  ) async {
    try {
      // Use the file category management service for proper file organization
      final fileCategoryService = FileCategoryManagementService();

      await fileCategoryService.moveFileToCategory(documentId, categoryId);

      final documentIndex = _documents.indexWhere(
        (doc) => doc.id == documentId,
      );
      if (documentIndex != -1) {
        final originalDocument = _documents[documentIndex];

        // Skip if already in the same category
        if (originalDocument.category == categoryId) {
          return;
        }

        final updatedDocument = originalDocument.copyWith(category: categoryId);

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

        // Only notify once at the end
        notifyListeners();

        // Save to storage
        await _saveToStorage();
      }
    } catch (e) {
      _setError('Failed to update document category: $e');
      rethrow;
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

  // Remove document permanently (from Firebase Storage and Firestore)
  Future<void> removeDocument(String documentId, String deletedBy) async {
    try {
      // Delete from Firebase Storage and Firestore
      await _documentService.deleteDocument(documentId, deletedBy);

      // Find and remove from local category storage
      DocumentModel? docToRemove;
      String? categoryToRemoveFrom;

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
          docToRemove = doc;
          categoryToRemoveFrom = entry.key;
          break;
        }
      }

      if (docToRemove != null && categoryToRemoveFrom != null) {
        _categoryDocuments[categoryToRemoveFrom]!.removeWhere(
          (d) => d.id == documentId,
        );
      }

      // Remove from main list
      _documents.removeWhere((d) => d.id == documentId);
      _applyFiltersAndSort();

      // Save to storage for persistence
      await _saveToStorage();

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to remove document: ${e.toString()}');
    }
  }

  // Search documents
  void searchDocuments(String query) {
    _searchQuery = query;
    _applyFiltersAndSort();
    notifyListeners(); // Ensure UI updates
  }

  // Filter by category
  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFiltersAndSort();
    notifyListeners(); // Ensure UI updates
  }

  // Filter by status
  void filterByStatus(String status) {
    _selectedStatus = status;
    _applyFiltersAndSort();
    notifyListeners(); // Ensure UI updates
  }

  // Filter by file type
  void filterByFileType(String fileType) {
    _selectedFileType = fileType;
    _applyFiltersAndSort();
    notifyListeners(); // Ensure UI updates
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
        lowerFileType.contains('xls')) {
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
    // First try to get from local storage
    final localDocuments = _categoryDocuments[category] ?? [];

    // If local storage is empty but we have documents in main list, rebuild category storage
    if (localDocuments.isEmpty && _documents.isNotEmpty) {
      final documentsInCategory = _documents
          .where((doc) => doc.category == category)
          .toList();
      if (documentsInCategory.isNotEmpty) {
        _categoryDocuments[category] = documentsInCategory;
        debugPrint(
          '🔄 Rebuilt category storage for $category: ${documentsInCategory.length} documents',
        );
        // Save the rebuilt data
        _saveToStorage();
        return documentsInCategory;
      }
    }

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

  // Get recent files (uploaded in the last 7 days, regardless of category)
  // FIXED: Use unfiltered documents and apply ANR-safe limits
  List<DocumentModel> getRecentFiles({int days = 7}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    final recentFiles =
        _documents.where((doc) => doc.uploadedAt.isAfter(cutoffDate)).toList()
          ..sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));

    // Apply ANR-safe limit to prevent performance issues
    return recentFiles.take(ANRConfig.maxItemsPerPage).toList();
  }

  // Get uncategorized files
  List<DocumentModel> getUncategorizedFiles() {
    return getDocumentsByCategory('uncategorized');
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

  // ARCHITECTURAL FIX: Use state manager for consistent recent documents
  List<DocumentModel> getRecentDocuments({int limit = 10}) {
    // Try to get from state manager first for consistency
    final stateManagerDocs = _stateManager.getRecentDocuments(limit: limit);

    if (stateManagerDocs.isNotEmpty) {
      // Sync local state with state manager if needed
      if (_documents.length != _stateManager.documents.length) {
        debugPrint('🔄 Syncing local state with state manager...');
        _documents = List.from(_stateManager.documents);
        _applyFiltersAndSort();
      }

      return stateManagerDocs;
    }

    // Fallback to local documents if state manager is empty
    List<DocumentModel> sortedDocs = List.from(_documents);
    sortedDocs.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));

    // Apply ANR-safe limit
    final safeLimit = limit > (ANRConfig.maxItemsPerPage * 2)
        ? (ANRConfig.maxItemsPerPage * 2)
        : limit;

    final recentDocs = sortedDocs.take(safeLimit).toList();

    // Minimal logging for monitoring
    if (recentDocs.isNotEmpty) {
      debugPrint(
        '📊 Recent documents (fallback): ${recentDocs.length} files, newest: ${recentDocs.first.fileName}',
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
      _applyFiltersAndSort();

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

  // ARCHITECTURAL FIX: Single-threaded refresh with atomic updates
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

    debugPrint('🔄 Starting single-threaded document refresh...');

    // Use atomic refresh approach for consistency
    await refreshRecentFiles();

    debugPrint('✅ Single-threaded document refresh completed');
  }

  // Force refresh with Firebase Storage sync
  Future<void> refreshWithStorageSync() async {
    _setLoading(true);
    _clearError();

    try {
      debugPrint('🔄 Force refreshing with Firebase Storage sync...');

      // Perform optimized sync (no automatic cleanup)
      final syncedDocuments = await _optimizedSyncService
          .syncStorageWithFirestoreOptimized();
      debugPrint('📊 Sync results: ${syncedDocuments.length} documents synced');

      // Reload documents after sync
      await loadDocuments();
    } catch (e) {
      debugPrint('❌ Force refresh with sync failed: $e');
      _setError('Failed to sync with Firebase Storage: $e');
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

  // Helper methods

  void _setError(String error) {
    _errorMessage = error;
    _isLoading = false;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Clear error manually
  void clearError() {
    _clearError();
  }

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

  // Load data from persistent storage
  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load initialization status
      _isInitialized = prefs.getBool('documents_initialized') ?? false;

      // Load category documents
      final String? categoryDataString = prefs.getString('category_documents');
      if (categoryDataString != null) {
        final Map<String, dynamic> categoryData = jsonDecode(
          categoryDataString,
        );

        _categoryDocuments.clear();
        categoryData.forEach((categoryId, docsJson) {
          final List<DocumentModel> docs = (docsJson as List)
              .map((docJson) => DocumentModel.fromMapForStorage(docJson))
              .toList();
          _categoryDocuments[categoryId] = docs;
        });
      }
    } catch (e) {
      debugPrint('Error loading documents from storage: $e');
      // Reset to empty state if loading fails
      _categoryDocuments.clear();
      _isInitialized = false;
    }
  }
}
