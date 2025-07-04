import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../services/firebase_service.dart';
import '../../models/user_model.dart';
import '../../services/cloud_functions_service.dart';

class UserService {
  static UserService? _instance;
  static UserService get instance => _instance ??= UserService._();

  UserService._();

  final FirebaseService _firebaseService = FirebaseService.instance;
  final CloudFunctionsService _cloudFunctions = CloudFunctionsService.instance;

  // Create new user (Admin only) - Using Cloud Functions
  Future<UserModel> createUser({
    required String fullName,
    required String email,
    required String password,
    required String role,
    required String createdBy,
    UserPermissions? permissions,
  }) async {
    try {
      // Set default permissions based on role
      UserPermissions userPermissions =
          permissions ??
          (role == 'admin' ? UserPermissions.admin() : UserPermissions.user());

      // Use Cloud Functions to create user (handles admin permission check)
      String userId = await _cloudFunctions.createUser(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
        permissions: userPermissions.toMap(),
      );

      // Fetch the created user data from Firestore
      DocumentSnapshot userDoc = await _firebaseService.usersCollection
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc);
      } else {
        throw Exception('User created but data not found in database.');
      }
    } catch (e) {
      // Handle Cloud Functions errors
      if (e.toString().contains('permission-denied')) {
        throw Exception('Hanya admin yang dapat membuat pengguna baru.');
      } else if (e.toString().contains('already-exists')) {
        throw Exception('Email sudah digunakan oleh pengguna lain.');
      } else if (e.toString().contains('invalid-argument')) {
        throw Exception('Data yang dimasukkan tidak valid.');
      } else {
        throw Exception('Gagal membuat pengguna: ${e.toString()}');
      }
    }
  }

  // Get all users
  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firebaseService.usersCollection
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  // Get users stream
  Stream<List<UserModel>> getUsersStream() {
    return _firebaseService.usersCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList(),
        );
  }

  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot doc = await _firebaseService.usersCollection
          .doc(userId)
          .get();

      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil data pengguna: ${e.toString()}');
    }
  }

  // Update user
  Future<void> updateUser(UserModel user, String updatedBy) async {
    try {
      await _firebaseService.usersCollection.doc(user.id).update(user.toMap());
    } catch (e) {
      throw Exception('Gagal mengupdate pengguna: ${e.toString()}');
    }
  }

  // Update user status
  Future<void> updateUserStatus(
    String userId,
    String status,
    String updatedBy,
  ) async {
    try {
      await _firebaseService.usersCollection.doc(userId).update({
        'status': status,
      });
    } catch (e) {
      throw Exception('Gagal mengupdate status pengguna: ${e.toString()}');
    }
  }

  // Update user permissions
  Future<void> updateUserPermissions(
    String userId,
    UserPermissions permissions,
    String updatedBy,
  ) async {
    try {
      await _firebaseService.usersCollection.doc(userId).update({
        'permissions': permissions.toMap(),
      });
    } catch (e) {
      throw Exception('Gagal mengupdate izin pengguna: ${e.toString()}');
    }
  }

  // Delete user using Cloud Function (hard delete from both Firestore and Firebase Auth)
  Future<void> deleteUser(String userId, String deletedBy) async {
    try {
      debugPrint('🔄 Deleting user via Cloud Function: $userId');

      // Use Cloud Function to perform hard delete from both Firestore and Firebase Auth
      await _cloudFunctions.deleteUser(userId);

      debugPrint('✅ User deleted successfully via Cloud Function: $userId');
    } catch (e) {
      debugPrint('❌ Failed to delete user via Cloud Function: $e');
      throw Exception('Gagal menghapus pengguna: ${e.toString()}');
    }
  }

  // Search users
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      // Search by name
      QuerySnapshot nameQuery = await _firebaseService.usersCollection
          .where('fullName', isGreaterThanOrEqualTo: query)
          .where('fullName', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      // Search by email
      QuerySnapshot emailQuery = await _firebaseService.usersCollection
          .where('email', isGreaterThanOrEqualTo: query)
          .where('email', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      Set<UserModel> users = {};

      // Add results from name search
      for (var doc in nameQuery.docs) {
        users.add(UserModel.fromFirestore(doc));
      }

      // Add results from email search
      for (var doc in emailQuery.docs) {
        users.add(UserModel.fromFirestore(doc));
      }

      return users.toList();
    } catch (e) {
      throw Exception('Gagal mencari pengguna: ${e.toString()}');
    }
  }

  // Get users by role
  Future<List<UserModel>> getUsersByRole(String role) async {
    try {
      QuerySnapshot querySnapshot = await _firebaseService.usersCollection
          .where('role', isEqualTo: role)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception(
        'Gagal mengambil pengguna berdasarkan role: ${e.toString()}',
      );
    }
  }

  // Get active users count
  Future<int> getActiveUsersCount() async {
    try {
      QuerySnapshot querySnapshot = await _firebaseService.usersCollection
          .where('status', isEqualTo: 'active')
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      throw Exception('Gagal menghitung pengguna aktif: ${e.toString()}');
    }
  }

  // Get total users count
  Future<int> getTotalUsersCount() async {
    try {
      QuerySnapshot querySnapshot = await _firebaseService.usersCollection
          .get();
      return querySnapshot.docs.length;
    } catch (e) {
      throw Exception('Gagal menghitung total pengguna: ${e.toString()}');
    }
  }

  // Update profile image
  Future<void> updateProfileImage(
    String userId,
    String imageUrl,
    String updatedBy,
  ) async {
    try {
      await _firebaseService.usersCollection.doc(userId).update({
        'profileImage': imageUrl,
      });
    } catch (e) {
      throw Exception('Gagal mengupdate foto profil: ${e.toString()}');
    }
  }
}
