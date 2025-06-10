import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
import 'category_provider.dart';

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

  // Dynamic document storage - persists during app session
  static final Map<String, List<DocumentModel>> _categoryDocuments = {};
  static bool _isInitialized = false;

  // Firebase real-time listener
  final FirebaseService _firebaseService = FirebaseService.instance;
  final DocumentService _documentService = DocumentService.instance;
  // Use optimized sync service to prevent duplicate operations
  final OptimizedFirebaseStorageSyncService _optimizedSyncService =
      OptimizedFirebaseStorageSyncService.instance;
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

  // Load documents with Firebase real-time sync
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

      // First try to sync Firebase Storage with Firestore and load documents
      bool firebaseDataLoaded = false;
      if (_useFirebaseSync) {
        try {
          debugPrint('🔄 Starting Firebase Storage sync...');

          // Perform comprehensive sync with timeout to prevent ANR
          final syncedDocuments = await ANRPrevention.executeNetworkOperation(
            _optimizedSyncService.syncStorageWithFirestoreOptimized(),
            operationName: 'Optimized Firebase Storage Sync',
          );

          if (syncedDocuments != null && syncedDocuments.isNotEmpty) {
            debugPrint(
              '📥 Loading ${syncedDocuments.length} synced documents from Firebase',
            );
            _handleFirebaseDocumentModels(syncedDocuments);
            firebaseDataLoaded = true;
            _isInitialized = true;
            // Save synced data to local storage for offline access
            await _saveToStorage();
            // Notify listeners immediately after loading
            notifyListeners();
          } else {
            // Fallback to regular Firestore query if sync returns empty
            final firebaseDocuments =
                await ANRPrevention.executeNetworkOperation(
                  _documentService.getAllDocuments(),
                  operationName: 'Firestore Document Load',
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
          }
        } catch (firebaseError) {
          debugPrint('Firebase sync/load error: $firebaseError');
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

      // PERFORMANCE FIX: Use pagination for real-time listener to prevent ANR
      _documentsSubscription = _firebaseService.documentsCollection
          .where('isActive', isEqualTo: true) // Only get active documents
          .orderBy('uploadedAt', descending: true)
          .limit(ANRConfig.defaultPageSize) // Limit real-time updates
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

      debugPrint('✅ Firebase real-time listener started for documents');
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
    // Check if document already exists to prevent duplicates
    if (_documents.any((doc) => doc.id == document.id)) {
      debugPrint(
        '⚠️ Skipping duplicate document: ${document.fileName} (ID: ${document.id})',
      );
      return;
    }

    // Add to main documents list
    _documents.add(document);

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
        existing.status != updated.status ||
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

      if (categoryId == 'uncategorized') {
        await fileCategoryService.moveFileToUncategorized(documentId);
      } else {
        await fileCategoryService.moveFileToCategory(documentId, categoryId);
      }

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
            status: '',
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

      // Status filter
      bool matchesStatus =
          _selectedStatus == 'all' || document.status == _selectedStatus;

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
          comparison = a.status.compareTo(b.status);
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
  List<DocumentModel> getRecentFiles({int days = 7}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return _documents
        .where((doc) => doc.uploadedAt.isAfter(cutoffDate))
        .toList()
      ..sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
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

  // Get documents by status with phantom file cleanup
  List<DocumentModel> getDocumentsByStatus(String status) {
    final documents = _documents
        .where((document) => document.status == status)
        .toList();

    // If requesting pending files, trigger cleanup in background
    if (status == 'pending' && documents.isNotEmpty) {
      _cleanupPhantomPendingFiles();
    }

    return documents;
  }

  // Clean up phantom pending files that don't exist in Firebase Storage
  Future<void> _cleanupPhantomPendingFiles() async {
    try {
      final pendingFiles = _documents
          .where((doc) => doc.status == 'pending')
          .toList();
      if (pendingFiles.isEmpty) return;

      debugPrint(
        '🧹 Checking ${pendingFiles.length} pending files for phantom entries...',
      );

      final List<String> phantomFileIds = [];

      for (final document in pendingFiles) {
        try {
          // Check if file exists in Firebase Storage
          final fileRef = FirebaseStorage.instance.ref(document.filePath);
          await fileRef.getMetadata();

          // Check if document exists in Firestore
          final docSnapshot = await FirebaseFirestore.instance
              .collection('documents')
              .doc(document.id)
              .get();

          if (!docSnapshot.exists) {
            phantomFileIds.add(document.id);
            debugPrint(
              '🚫 Found phantom file in local cache: ${document.fileName}',
            );
          }
        } catch (e) {
          // File doesn't exist in storage or Firestore, mark as phantom
          phantomFileIds.add(document.id);
          debugPrint(
            '🚫 Found phantom file (storage error): ${document.fileName} - $e',
          );
        }
      }

      // Remove phantom files from local cache
      if (phantomFileIds.isNotEmpty) {
        _documents.removeWhere((doc) => phantomFileIds.contains(doc.id));

        // Also remove from category documents
        _categoryDocuments.forEach((category, docs) {
          docs.removeWhere((doc) => phantomFileIds.contains(doc.id));
        });

        // Save updated data and refresh UI
        await _saveToStorage();
        _applyFiltersAndSort();

        debugPrint(
          '✅ Cleaned up ${phantomFileIds.length} phantom pending files',
        );
      }
    } catch (e) {
      debugPrint('❌ Error during phantom file cleanup: $e');
    }
  }

  // Get documents by user
  List<DocumentModel> getDocumentsByUser(String userId) {
    return _documents
        .where((document) => document.uploadedBy == userId)
        .toList();
  }

  // Get recent documents
  List<DocumentModel> getRecentDocuments({int limit = 10}) {
    List<DocumentModel> sortedDocs = List.from(_documents);
    sortedDocs.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
    return sortedDocs.take(limit).toList();
  }

  // Get pending documents count
  int get pendingDocumentsCount {
    return _documents.where((document) => document.status == 'pending').length;
  }

  // Get approved documents count
  int get approvedDocumentsCount {
    return _documents.where((document) => document.status == 'approved').length;
  }

  // Get rejected documents count
  int get rejectedDocumentsCount {
    return _documents.where((document) => document.status == 'rejected').length;
  }

  // Get total documents count
  int get totalDocumentsCount {
    return _documents.length;
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

  // Refresh documents
  Future<void> refreshDocuments() async {
    await loadDocuments();
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

  // Manual cleanup of phantom pending files (can be called from UI)
  Future<void> cleanupPhantomFiles() async {
    debugPrint('🧹 Manual cleanup of phantom files initiated...');
    await _cleanupPhantomPendingFiles();
    notifyListeners();
  }

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
