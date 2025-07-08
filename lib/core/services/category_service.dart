import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../models/category_model.dart';
import '../../services/activity_service.dart';
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
          .limit(50) // Add limit to comply with Firestore security rules
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
        .limit(50) // Add limit to comply with Firestore security rules
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
          .limit(50) // Add limit to comply with Firestore security rules
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
      // Generate document ID first
      final docRef = _firestore.collection(_collection).doc();

      // Create category with the generated ID
      final categoryWithId = category.copyWith(id: docRef.id);

      // Add category to Firestore only - no Storage folder creation
      await docRef.set(categoryWithId.toMap());

      // Log activity
      try {
        final activityService = ActivityService();
        await activityService.logActivity(
          type: 'create',
          description: 'Category created: ${category.name}',
          categoryId: docRef.id,
          additionalData: {
            'categoryName': category.name,
            'description': category.description,
            'userAgent': 'Flutter App',
            'platform': 'Mobile',
          },
        );
      } catch (activityError) {
        debugPrint(
          '⚠️ Failed to log category creation activity: $activityError',
        );
      }

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

      // Log activity
      try {
        final activityService = ActivityService();
        await activityService.logActivity(
          type: 'update',
          description: 'Category updated: ${category.name}',
          categoryId: categoryId,
          additionalData: {
            'categoryName': category.name,
            'description': category.description,
            'userAgent': 'Flutter App',
            'platform': 'Mobile',
          },
        );
      } catch (activityError) {
        debugPrint('⚠️ Failed to log category update activity: $activityError');
      }
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

        // Log activity
        try {
          final activityService = ActivityService();
          await activityService.logActivity(
            type: 'delete',
            description: 'Category deleted: ${category.name}',
            categoryId: categoryId,
            additionalData: {
              'categoryName': category.name,
              'userAgent': 'Flutter App',
              'platform': 'Mobile',
            },
          );
        } catch (activityError) {
          debugPrint(
            '⚠️ Failed to log category deletion activity: $activityError',
          );
        }
      }
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }

  // Toggle category status
  Future<void> toggleCategoryStatus(String categoryId, bool isActive) async {
    try {
      // Get category details for logging
      final category = await getCategoryById(categoryId);

      await _firestore.collection(_collection).doc(categoryId).update({
        'isActive': isActive,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Log activity
      try {
        final activityService = ActivityService();
        await activityService.logActivity(
          type: 'update',
          description:
              'Category ${isActive ? "activated" : "deactivated"}: ${category?.name ?? "Unknown"}',
          categoryId: categoryId,
          additionalData: {
            'categoryName': category?.name,
            'statusChanged': isActive ? 'activated' : 'deactivated',
            'userAgent': 'Flutter App',
            'platform': 'Mobile',
          },
        );
      } catch (activityError) {
        debugPrint(
          '⚠️ Failed to log category status toggle activity: $activityError',
        );
      }
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
          .limit(50) // Add limit to comply with Firestore security rules
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
          .limit(50) // Add limit to comply with Firestore security rules
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
      final querySnapshot = await _firestore
          .collection(_collection)
          .limit(50) // Add limit to comply with Firestore security rules
          .get();
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
          .limit(50) // Add limit to comply with Firestore security rules
          .get();
      return querySnapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to get active categories count: $e');
    }
  }
}
