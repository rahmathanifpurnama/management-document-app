import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/recycle_bin_model.dart';
import '../models/document_model.dart';
import '../core/services/firebase_service.dart';

class RecycleBinService {
  static final RecycleBinService _instance = RecycleBinService._internal();
  factory RecycleBinService() => _instance;
  RecycleBinService._internal();

  static RecycleBinService get instance => _instance;

  final FirebaseService _firebaseService = FirebaseService.instance;
  final String _collection = 'recycle_bin';

  // Get recycle bin collection reference
  CollectionReference get _recycleBinCollection =>
      _firebaseService.firestore.collection(_collection);

  /// Move document to recycle bin (soft delete)
  Future<void> moveToRecycleBin({
    required DocumentModel document,
    required String deletedBy,
    required String originalLocation,
    String? deleteReason,
  }) async {
    try {
      debugPrint('📁 Moving document to recycle bin: ${document.id}');

      final recycleBinItem = RecycleBinModel.fromDocument(
        document: document,
        deletedBy: deletedBy,
        originalLocation: originalLocation,
        deleteReason: deleteReason,
      );

      // Add to recycle bin collection
      await _recycleBinCollection.add(recycleBinItem.toMap());

      // Update original document to mark as deleted
      await _firebaseService.documentsCollection.doc(document.id).update({
        'isDeleted': true,
        'deletedAt': Timestamp.fromDate(DateTime.now()),
        'deletedBy': deletedBy,
      });

      debugPrint('✅ Document moved to recycle bin successfully');
    } catch (e) {
      debugPrint('❌ Error moving document to recycle bin: $e');
      rethrow;
    }
  }

  /// Get all items in recycle bin
  Future<List<RecycleBinModel>> getRecycleBinItems({
    int limit = 50,
    String? userId,
  }) async {
    try {
      debugPrint('📁 Loading recycle bin items...');

      Query query = _recycleBinCollection
          .orderBy('deletedAt', descending: true)
          .limit(limit);

      // Filter by user if specified
      if (userId != null) {
        query = query.where('deletedBy', isEqualTo: userId);
      }

      final querySnapshot = await query.get();

      final items = querySnapshot.docs
          .map((doc) => RecycleBinModel.fromFirestore(doc))
          .toList();

      debugPrint('✅ Loaded ${items.length} recycle bin items');
      return items;
    } catch (e) {
      debugPrint('❌ Error loading recycle bin items: $e');
      rethrow;
    }
  }

  /// Restore document from recycle bin
  Future<void> restoreDocument(String recycleBinId) async {
    try {
      debugPrint('🔄 Restoring document from recycle bin: $recycleBinId');

      final recycleBinDoc = await _recycleBinCollection.doc(recycleBinId).get();
      if (!recycleBinDoc.exists) {
        throw Exception('Recycle bin item not found');
      }

      final recycleBinItem = RecycleBinModel.fromFirestore(recycleBinDoc);

      // Check if document can be restored (within 30 days)
      if (!recycleBinItem.canBeRestored) {
        throw Exception('Document cannot be restored after 30 days');
      }

      // Restore original document
      await _firebaseService.documentsCollection
          .doc(recycleBinItem.originalDocumentId)
          .update({
        'isDeleted': false,
        'deletedAt': null,
        'deletedBy': null,
      });

      // Remove from recycle bin
      await _recycleBinCollection.doc(recycleBinId).delete();

      debugPrint('✅ Document restored successfully');
    } catch (e) {
      debugPrint('❌ Error restoring document: $e');
      rethrow;
    }
  }

  /// Permanently delete document from recycle bin
  Future<void> permanentlyDelete(String recycleBinId) async {
    try {
      debugPrint('🗑️ Permanently deleting document: $recycleBinId');

      final recycleBinDoc = await _recycleBinCollection.doc(recycleBinId).get();
      if (!recycleBinDoc.exists) {
        throw Exception('Recycle bin item not found');
      }

      final recycleBinItem = RecycleBinModel.fromFirestore(recycleBinDoc);

      // Delete original document from Firestore
      await _firebaseService.documentsCollection
          .doc(recycleBinItem.originalDocumentId)
          .delete();

      // Delete from recycle bin
      await _recycleBinCollection.doc(recycleBinId).delete();

      // TODO: Delete file from Firebase Storage
      // This should be handled by admin or cloud function

      debugPrint('✅ Document permanently deleted');
    } catch (e) {
      debugPrint('❌ Error permanently deleting document: $e');
      rethrow;
    }
  }

  /// Get recycle bin count
  Future<int> getRecycleBinCount({String? userId}) async {
    try {
      Query query = _recycleBinCollection;

      if (userId != null) {
        query = query.where('deletedBy', isEqualTo: userId);
      }

      final countSnapshot = await query.count().get();
      return countSnapshot.count ?? 0;
    } catch (e) {
      debugPrint('❌ Error getting recycle bin count: $e');
      return 0;
    }
  }

  /// Clean up old items (older than 30 days) - Admin only
  Future<void> cleanupOldItems() async {
    try {
      debugPrint('🧹 Cleaning up old recycle bin items...');

      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));

      final oldItemsSnapshot = await _recycleBinCollection
          .where('deletedAt', isLessThan: Timestamp.fromDate(thirtyDaysAgo))
          .get();

      final batch = _firebaseService.firestore.batch();

      for (final doc in oldItemsSnapshot.docs) {
        final recycleBinItem = RecycleBinModel.fromFirestore(doc);

        // Delete original document
        batch.delete(_firebaseService.documentsCollection
            .doc(recycleBinItem.originalDocumentId));

        // Delete from recycle bin
        batch.delete(doc.reference);
      }

      await batch.commit();

      debugPrint('✅ Cleaned up ${oldItemsSnapshot.docs.length} old items');
    } catch (e) {
      debugPrint('❌ Error cleaning up old items: $e');
      rethrow;
    }
  }

  /// Search recycle bin items
  Future<List<RecycleBinModel>> searchRecycleBinItems({
    required String searchQuery,
    String? userId,
    int limit = 20,
  }) async {
    try {
      debugPrint('🔍 Searching recycle bin items: $searchQuery');

      // Get all items first (Firestore doesn't support text search)
      final allItems = await getRecycleBinItems(
        limit: limit * 2, // Get more to filter
        userId: userId,
      );

      // Filter by search query
      final filteredItems = allItems.where((item) {
        final fileName = item.originalDocument.fileName.toLowerCase();
        final category = item.originalDocument.category.toLowerCase();
        final query = searchQuery.toLowerCase();

        return fileName.contains(query) || category.contains(query);
      }).take(limit).toList();

      debugPrint('✅ Found ${filteredItems.length} matching items');
      return filteredItems;
    } catch (e) {
      debugPrint('❌ Error searching recycle bin items: $e');
      rethrow;
    }
  }
}
