import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../models/category_model.dart';
import '../../services/firebase_storage_category_service.dart';

class CategoryService {
  static const String _collection = 'categories';
  final FirebaseFirestore _firestore;
  final FirebaseStorageCategoryService _storageService;

  CategoryService({
    FirebaseFirestore? firestore,
    FirebaseStorageCategoryService? storageService,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _storageService = storageService ?? FirebaseStorageCategoryService();

  // Get all categories
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  // Get categories stream for real-time updates
  Stream<List<CategoryModel>> getCategoriesStream() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CategoryModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Get active categories only
  Future<List<CategoryModel>> getActiveCategories() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to load active categories: $e');
    }
  }

  // Get category by ID
  Future<CategoryModel?> getCategoryById(String categoryId) async {
    try {
      final doc = await _firestore
          .collection(_collection)
          .doc(categoryId)
          .get();

      if (doc.exists) {
        return CategoryModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get category: $e');
    }
  }

  // Add new category (lightweight - Firestore only)
  Future<String> addCategory(CategoryModel category) async {
    try {
      // Add category to Firestore only - no Storage folder creation
      final docRef = await _firestore
          .collection(_collection)
          .add(category.toMap());

      debugPrint('✅ Created category in Firestore: ${category.name}');
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }

  // Update category
  Future<void> updateCategory(String categoryId, CategoryModel category) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(categoryId)
          .update(category.toMap());
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  // Delete category
  Future<void> deleteCategory(String categoryId) async {
    try {
      // Get category details before deletion
      final category = await getCategoryById(categoryId);

      // Delete from Firestore first
      await _firestore.collection(_collection).doc(categoryId).delete();

      // Delete corresponding folder in Firebase Storage
      if (category != null) {
        try {
          await _storageService.deleteCategoryFolder(categoryId, category.name);
          debugPrint('✅ Deleted Storage folder for category: ${category.name}');
        } catch (storageError) {
          debugPrint('⚠️ Failed to delete Storage folder: $storageError');
          // Don't fail the entire operation if Storage folder deletion fails
        }
      }
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }

  // Toggle category status
  Future<void> toggleCategoryStatus(String categoryId, bool isActive) async {
    try {
      await _firestore.collection(_collection).doc(categoryId).update({
        'isActive': isActive,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to toggle category status: $e');
    }
  }

  // Search categories
  Future<List<CategoryModel>> searchCategories(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .orderBy('name')
          .startAt([query])
          .endAt(['$query\uf8ff'])
          .get();

      return querySnapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to search categories: $e');
    }
  }

  // Get categories for specific user
  Future<List<CategoryModel>> getCategoriesForUser(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .where('permissions', arrayContains: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to load user categories: $e');
    }
  }

  // Batch operations
  Future<void> batchUpdateCategories(List<CategoryModel> categories) async {
    try {
      final batch = _firestore.batch();

      for (final category in categories) {
        final docRef = _firestore.collection(_collection).doc(category.id);
        batch.update(docRef, category.toMap());
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to batch update categories: $e');
    }
  }

  // Get categories count
  Future<int> getCategoriesCount() async {
    try {
      final querySnapshot = await _firestore.collection(_collection).get();
      return querySnapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to get categories count: $e');
    }
  }

  // Get active categories count
  Future<int> getActiveCategoriesCount() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .get();
      return querySnapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to get active categories count: $e');
    }
  }
}
