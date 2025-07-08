import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/favorite_model.dart';
import '../core/services/firebase_service.dart';

class FavoritesService {
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  FavoritesService._internal();

  static FavoritesService get instance => _instance;

  final FirebaseService _firebaseService = FirebaseService.instance;
  final String _collection = 'favorites';

  // Get favorites collection reference
  CollectionReference get _favoritesCollection =>
      _firebaseService.firestore.collection(_collection);

  /// Add folder to favorites
  Future<void> addToFavorites({
    required String userId,
    required String folderPath,
    required String folderName,
    String? categoryId,
    String? description,
  }) async {
    try {
      debugPrint('⭐ Adding folder to favorites: $folderPath');

      // Check if already exists
      final existingFavorite = await _favoritesCollection
          .where('userId', isEqualTo: userId)
          .where('folderPath', isEqualTo: folderPath)
          .limit(1)
          .get();

      if (existingFavorite.docs.isNotEmpty) {
        throw Exception('Folder is already in favorites');
      }

      final favorite = FavoriteModel.create(
        userId: userId,
        folderPath: folderPath,
        folderName: folderName,
        categoryId: categoryId,
        description: description,
      );

      await _favoritesCollection.add(favorite.toMap());

      debugPrint('✅ Folder added to favorites successfully');
    } catch (e) {
      debugPrint('❌ Error adding folder to favorites: $e');
      rethrow;
    }
  }

  /// Remove folder from favorites
  Future<void> removeFromFavorites({
    required String userId,
    required String folderPath,
  }) async {
    try {
      debugPrint('🗑️ Removing folder from favorites: $folderPath');

      final favoriteSnapshot = await _favoritesCollection
          .where('userId', isEqualTo: userId)
          .where('folderPath', isEqualTo: folderPath)
          .limit(1)
          .get();

      if (favoriteSnapshot.docs.isEmpty) {
        throw Exception('Folder not found in favorites');
      }

      await favoriteSnapshot.docs.first.reference.delete();

      debugPrint('✅ Folder removed from favorites successfully');
    } catch (e) {
      debugPrint('❌ Error removing folder from favorites: $e');
      rethrow;
    }
  }

  /// Get user's favorite folders
  Future<List<FavoriteModel>> getUserFavorites({
    required String userId,
    int limit = 100,
  }) async {
    try {
      debugPrint('⭐ Loading user favorites: $userId');

      final querySnapshot = await _favoritesCollection
          .where('userId', isEqualTo: userId)
          .orderBy('addedAt', descending: true)
          .limit(limit)
          .get();

      final favorites = querySnapshot.docs
          .map((doc) => FavoriteModel.fromFirestore(doc))
          .toList();

      debugPrint('✅ Loaded ${favorites.length} favorites');
      return favorites;
    } catch (e) {
      debugPrint('❌ Error loading user favorites: $e');
      rethrow;
    }
  }

  /// Check if folder is in favorites
  Future<bool> isFavorite({
    required String userId,
    required String folderPath,
  }) async {
    try {
      final favoriteSnapshot = await _favoritesCollection
          .where('userId', isEqualTo: userId)
          .where('folderPath', isEqualTo: folderPath)
          .limit(1)
          .get();

      return favoriteSnapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint('❌ Error checking if folder is favorite: $e');
      return false;
    }
  }

  /// Get favorites count for user
  Future<int> getFavoritesCount({required String userId}) async {
    try {
      final countSnapshot = await _favoritesCollection
          .where('userId', isEqualTo: userId)
          .count()
          .get();

      return countSnapshot.count ?? 0;
    } catch (e) {
      debugPrint('❌ Error getting favorites count: $e');
      return 0;
    }
  }

  /// Update favorite description
  Future<void> updateFavoriteDescription({
    required String favoriteId,
    required String description,
  }) async {
    try {
      debugPrint('📝 Updating favorite description: $favoriteId');

      await _favoritesCollection.doc(favoriteId).update({
        'description': description,
      });

      debugPrint('✅ Favorite description updated successfully');
    } catch (e) {
      debugPrint('❌ Error updating favorite description: $e');
      rethrow;
    }
  }

  /// Search user's favorites
  Future<List<FavoriteModel>> searchFavorites({
    required String userId,
    required String searchQuery,
    int limit = 50,
  }) async {
    try {
      debugPrint('🔍 Searching favorites: $searchQuery');

      // Get all user favorites first (Firestore doesn't support text search)
      final allFavorites = await getUserFavorites(
        userId: userId,
        limit: limit * 2, // Get more to filter
      );

      // Filter by search query
      final filteredFavorites = allFavorites.where((favorite) {
        final folderName = favorite.folderName.toLowerCase();
        final folderPath = favorite.folderPath.toLowerCase();
        final description = (favorite.description ?? '').toLowerCase();
        final query = searchQuery.toLowerCase();

        return folderName.contains(query) ||
               folderPath.contains(query) ||
               description.contains(query);
      }).take(limit).toList();

      debugPrint('✅ Found ${filteredFavorites.length} matching favorites');
      return filteredFavorites;
    } catch (e) {
      debugPrint('❌ Error searching favorites: $e');
      rethrow;
    }
  }

  /// Get favorites by category
  Future<List<FavoriteModel>> getFavoritesByCategory({
    required String userId,
    required String categoryId,
    int limit = 50,
  }) async {
    try {
      debugPrint('📁 Loading favorites by category: $categoryId');

      final querySnapshot = await _favoritesCollection
          .where('userId', isEqualTo: userId)
          .where('categoryId', isEqualTo: categoryId)
          .orderBy('addedAt', descending: true)
          .limit(limit)
          .get();

      final favorites = querySnapshot.docs
          .map((doc) => FavoriteModel.fromFirestore(doc))
          .toList();

      debugPrint('✅ Loaded ${favorites.length} favorites for category');
      return favorites;
    } catch (e) {
      debugPrint('❌ Error loading favorites by category: $e');
      rethrow;
    }
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite({
    required String userId,
    required String folderPath,
    required String folderName,
    String? categoryId,
    String? description,
  }) async {
    try {
      final isFav = await isFavorite(userId: userId, folderPath: folderPath);

      if (isFav) {
        await removeFromFavorites(userId: userId, folderPath: folderPath);
        return false;
      } else {
        await addToFavorites(
          userId: userId,
          folderPath: folderPath,
          folderName: folderName,
          categoryId: categoryId,
          description: description,
        );
        return true;
      }
    } catch (e) {
      debugPrint('❌ Error toggling favorite: $e');
      rethrow;
    }
  }

  /// Get recent favorites (added in last 7 days)
  Future<List<FavoriteModel>> getRecentFavorites({
    required String userId,
    int limit = 10,
  }) async {
    try {
      debugPrint('🕒 Loading recent favorites: $userId');

      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

      final querySnapshot = await _favoritesCollection
          .where('userId', isEqualTo: userId)
          .where('addedAt', isGreaterThan: Timestamp.fromDate(sevenDaysAgo))
          .orderBy('addedAt', descending: true)
          .limit(limit)
          .get();

      final favorites = querySnapshot.docs
          .map((doc) => FavoriteModel.fromFirestore(doc))
          .toList();

      debugPrint('✅ Loaded ${favorites.length} recent favorites');
      return favorites;
    } catch (e) {
      debugPrint('❌ Error loading recent favorites: $e');
      rethrow;
    }
  }
}
