import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../providers/document_provider.dart';
import '../providers/category_provider.dart';
import '../core/services/firebase_service.dart';
import '../models/document_model.dart';

/// Service untuk menangani real-time category assignment dan removal
class RealtimeCategorySyncService {
  static RealtimeCategorySyncService? _instance;
  static RealtimeCategorySyncService get instance =>
      _instance ??= RealtimeCategorySyncService._();

  RealtimeCategorySyncService._();

  final FirebaseService _firebaseService = FirebaseService.instance;
  StreamSubscription<QuerySnapshot>? _documentSubscription;
  BuildContext? _context;
  
  // Track last known category states to detect changes
  final Map<String, String> _lastKnownCategories = {};

  /// Initialize service dengan app context
  void initialize(BuildContext context) {
    _context = context;
    debugPrint('🔄 RealtimeCategorySyncService initialized');
  }

  /// Start real-time listener untuk category changes
  void startCategorySync() {
    try {
      if (_context == null) {
        debugPrint('⚠️ Context not available for category sync');
        return;
      }

      // Cancel existing subscription
      _documentSubscription?.cancel();

      debugPrint('🎯 Starting real-time category sync listener...');

      // Listen to ALL documents untuk detect category changes
      _documentSubscription = _firebaseService.documentsCollection
          .snapshots()
          .listen(
            (snapshot) {
              _handleCategoryChanges(snapshot.docChanges);
            },
            onError: (error) {
              debugPrint('❌ Category sync error: $error');
            },
          );

      debugPrint('✅ Real-time category sync started');
    } catch (e) {
      debugPrint('❌ Failed to start category sync: $e');
    }
  }

  /// Handle document changes dan detect category updates
  void _handleCategoryChanges(List<DocumentChange> changes) {
    if (_context == null) return;

    try {
      final documentProvider = Provider.of<DocumentProvider>(
        _context!,
        listen: false,
      );

      bool hasRelevantChanges = false;

      for (final change in changes) {
        final doc = change.doc;
        final data = doc.data() as Map<String, dynamic>?;
        
        if (data == null) continue;

        final documentId = doc.id;
        final currentCategory = data['category'] ?? '';
        final lastKnownCategory = _lastKnownCategories[documentId] ?? '';

        // Detect category change
        if (change.type == DocumentChangeType.modified && 
            currentCategory != lastKnownCategory) {
          
          debugPrint('🔄 Category change detected:');
          debugPrint('   Document: $documentId');
          debugPrint('   From: "$lastKnownCategory" → To: "$currentCategory"');
          
          hasRelevantChanges = true;
          
          // Update local tracking
          _lastKnownCategories[documentId] = currentCategory;
          
          // Update local document provider immediately
          _updateLocalDocumentCategory(documentProvider, documentId, currentCategory);
        }
        
        // Track new documents
        if (change.type == DocumentChangeType.added) {
          _lastKnownCategories[documentId] = currentCategory;
        }
        
        // Clean up removed documents
        if (change.type == DocumentChangeType.removed) {
          _lastKnownCategories.remove(documentId);
        }
      }

      // Trigger UI refresh if ada perubahan category
      if (hasRelevantChanges) {
        debugPrint('🔄 Triggering UI refresh for category changes');
        Future.microtask(() {
          documentProvider.notifyListeners();
        });
      }

    } catch (e) {
      debugPrint('❌ Error handling category changes: $e');
    }
  }

  /// Update local document category tanpa Firebase call
  void _updateLocalDocumentCategory(
    DocumentProvider documentProvider, 
    String documentId, 
    String newCategory
  ) {
    try {
      // Find document in local cache
      final documents = documentProvider.documents;
      final docIndex = documents.indexWhere((doc) => doc.id == documentId);
      
      if (docIndex == -1) {
        debugPrint('⚠️ Document $documentId not found in local cache');
        return;
      }

      final oldDocument = documents[docIndex];
      final oldCategory = oldDocument.category;
      
      // Create updated document
      final updatedDocument = oldDocument.copyWith(category: newCategory);
      
      // Update in main documents list
      documents[docIndex] = updatedDocument;
      
      // Update category-specific storage
      documentProvider.updateCategoryDocuments(
        documentId, 
        oldCategory, 
        newCategory, 
        updatedDocument
      );
      
      debugPrint('✅ Local document category updated: $documentId');
      
    } catch (e) {
      debugPrint('❌ Failed to update local document category: $e');
    }
  }

  /// Manually trigger category assignment (untuk immediate UI update)
  Future<void> assignDocumentToCategory(
    String documentId, 
    String categoryId
  ) async {
    try {
      debugPrint('🎯 Assigning document $documentId to category $categoryId');
      
      // Update Firestore - ini akan trigger real-time listener
      await _firebaseService.firestore
          .collection('documents')
          .doc(documentId)
          .update({
            'category': categoryId,
            'updatedAt': FieldValue.serverTimestamp(),
          });
          
      debugPrint('✅ Document category updated in Firestore');
      
    } catch (e) {
      debugPrint('❌ Failed to assign document to category: $e');
      rethrow;
    }
  }

  /// Remove document from category (set to empty string)
  Future<void> removeDocumentFromCategory(String documentId) async {
    try {
      debugPrint('🎯 Removing document $documentId from category');
      
      // Update Firestore - set category to empty string
      await _firebaseService.firestore
          .collection('documents')
          .doc(documentId)
          .update({
            'category': '',
            'updatedAt': FieldValue.serverTimestamp(),
          });
          
      debugPrint('✅ Document removed from category in Firestore');
      
    } catch (e) {
      debugPrint('❌ Failed to remove document from category: $e');
      rethrow;
    }
  }

  /// Batch assign multiple documents to category
  Future<void> assignMultipleDocumentsToCategory(
    List<String> documentIds, 
    String categoryId
  ) async {
    try {
      debugPrint('🎯 Batch assigning ${documentIds.length} documents to category $categoryId');
      
      final batch = _firebaseService.firestore.batch();
      
      for (final documentId in documentIds) {
        final docRef = _firebaseService.firestore
            .collection('documents')
            .doc(documentId);
            
        batch.update(docRef, {
          'category': categoryId,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      
      await batch.commit();
      debugPrint('✅ Batch category assignment completed');
      
    } catch (e) {
      debugPrint('❌ Failed to batch assign documents to category: $e');
      rethrow;
    }
  }

  /// Stop real-time sync
  void stopCategorySync() {
    _documentSubscription?.cancel();
    _documentSubscription = null;
    _lastKnownCategories.clear();
    debugPrint('🛑 Real-time category sync stopped');
  }

  /// Dispose service
  void dispose() {
    stopCategorySync();
    _context = null;
    debugPrint('🗑️ RealtimeCategorySyncService disposed');
  }
}
