import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/firebase_service.dart';

/// Service untuk menangani refresh token dan authentication issues
class TokenRefreshService {
  static TokenRefreshService? _instance;
  static TokenRefreshService get instance =>
      _instance ??= TokenRefreshService._();

  TokenRefreshService._();

  final FirebaseService _firebaseService = FirebaseService.instance;

  /// Force refresh current user token
  Future<bool> forceRefreshToken() async {
    try {
      final currentUser = _firebaseService.auth.currentUser;
      if (currentUser == null) {
        debugPrint('❌ No current user to refresh token');
        return false;
      }

      debugPrint('🔄 Force refreshing authentication token...');

      // Force token refresh
      await currentUser.getIdToken(true); // true = force refresh

      debugPrint('✅ Token refreshed successfully');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to refresh token: $e');
      return false;
    }
  }

  /// Get current user token with automatic refresh if needed
  Future<String?> getCurrentUserToken({bool forceRefresh = false}) async {
    try {
      final currentUser = _firebaseService.auth.currentUser;
      if (currentUser == null) {
        debugPrint('❌ No current user for token');
        return null;
      }

      // Get token with optional force refresh
      final token = await currentUser.getIdToken(forceRefresh);

      if (forceRefresh) {
        debugPrint('✅ Got fresh token');
      }

      return token;
    } catch (e) {
      debugPrint('❌ Failed to get user token: $e');
      return null;
    }
  }

  /// Check if current user token is valid
  Future<bool> isTokenValid() async {
    try {
      final token = await getCurrentUserToken();
      if (token == null) return false;

      // Try to decode token to check expiry
      final currentUser = _firebaseService.auth.currentUser;
      if (currentUser == null) return false;

      // Get token result to check expiry
      final tokenResult = await currentUser.getIdTokenResult();
      final expirationTime = tokenResult.expirationTime;

      if (expirationTime == null) return false;

      final now = DateTime.now();
      final isValid = expirationTime.isAfter(now);

      debugPrint('🔍 Token expiry: $expirationTime');
      debugPrint('🔍 Current time: $now');
      debugPrint('🔍 Token valid: $isValid');

      return isValid;
    } catch (e) {
      debugPrint('❌ Failed to check token validity: $e');
      return false;
    }
  }

  /// Ensure user has valid token before operations
  Future<bool> ensureValidToken() async {
    try {
      debugPrint('🔍 Checking token validity...');

      final isValid = await isTokenValid();
      if (isValid) {
        debugPrint('✅ Token is valid');
        return true;
      }

      debugPrint('⚠️ Token is invalid/expired, refreshing...');
      return await forceRefreshToken();
    } catch (e) {
      debugPrint('❌ Failed to ensure valid token: $e');
      return false;
    }
  }

  /// Re-authenticate user to fix token issues
  Future<bool> reAuthenticateUser(String email, String password) async {
    try {
      debugPrint('🔄 Re-authenticating user...');

      final currentUser = _firebaseService.auth.currentUser;
      if (currentUser == null) {
        debugPrint('❌ No current user to re-authenticate');
        return false;
      }

      // Create credential
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      // Re-authenticate
      await currentUser.reauthenticateWithCredential(credential);

      // Force refresh token after re-auth
      await currentUser.getIdToken(true);

      debugPrint('✅ User re-authenticated successfully');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to re-authenticate user: $e');
      return false;
    }
  }

  /// Sign out and sign in again to completely refresh authentication
  Future<bool> refreshAuthenticationCompletely(
    String email,
    String password,
  ) async {
    try {
      debugPrint('🔄 Completely refreshing authentication...');

      // Sign out first
      await _firebaseService.auth.signOut();
      debugPrint('📤 Signed out successfully');

      // Wait a moment
      await Future.delayed(const Duration(seconds: 1));

      // Sign in again
      final userCredential = await _firebaseService.auth
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        debugPrint('📥 Signed in successfully');

        // Force get fresh token
        await userCredential.user!.getIdToken(true);
        debugPrint('✅ Got fresh token after sign in');

        return true;
      }

      return false;
    } catch (e) {
      debugPrint('❌ Failed to refresh authentication completely: $e');
      return false;
    }
  }

  /// Check all upload criteria and debug issues
  Future<Map<String, dynamic>> checkUploadCriteria() async {
    final result = <String, dynamic>{
      'canUpload': false,
      'issues': <String>[],
      'userInfo': <String, dynamic>{},
    };

    try {
      debugPrint('🔍 === CHECKING UPLOAD CRITERIA ===');

      // 1. Check if user is logged in
      final currentUser = _firebaseService.auth.currentUser;
      if (currentUser == null) {
        result['issues'].add('❌ User belum login');
        debugPrint('❌ User belum login');
        return result;
      }

      debugPrint('✅ User sudah login: ${currentUser.email}');
      result['userInfo']['email'] = currentUser.email;
      result['userInfo']['uid'] = currentUser.uid;
      result['userInfo']['emailVerified'] = currentUser.emailVerified;

      // 2. Check if user document exists in Firestore
      final userDoc = await _firebaseService.firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) {
        result['issues'].add('❌ User document tidak ada di Firestore');
        debugPrint('❌ User document tidak ada di Firestore');
        return result;
      }

      debugPrint('✅ User document ada di Firestore');
      final userData = userDoc.data() as Map<String, dynamic>;
      result['userInfo']['firestoreData'] = userData;

      // 3. Check if user status is 'active'
      final userStatus = userData['status'] as String?;
      if (userStatus != 'active') {
        result['issues'].add('❌ User status bukan active: $userStatus');
        debugPrint('❌ User status bukan active: $userStatus');
        return result;
      }

      debugPrint('✅ User status adalah active');

      // 4. Check if user has upload permission
      final permissions = userData['permissions'] as Map<String, dynamic>?;
      final documentPermissions = permissions?['documents'] as List<dynamic>?;

      bool hasUploadPermission = false;
      if (documentPermissions != null) {
        hasUploadPermission = documentPermissions.contains('upload');
      }

      // Also check if user is admin (admin has all permissions)
      final userRole = userData['role'] as String?;
      final isAdmin = userRole == 'admin';

      if (!hasUploadPermission && !isAdmin) {
        result['issues'].add('❌ User tidak punya permission upload');
        debugPrint('❌ User tidak punya permission upload');
        debugPrint('   Permissions: $documentPermissions');
        debugPrint('   Role: $userRole');
        return result;
      }

      if (isAdmin) {
        debugPrint('✅ User adalah admin (punya semua permission)');
      } else {
        debugPrint('✅ User punya permission upload');
      }

      // 5. Check token validity
      try {
        final tokenResult = await currentUser.getIdTokenResult();
        final now = DateTime.now();
        final isTokenExpired =
            tokenResult.expirationTime?.isBefore(now) ?? true;

        if (isTokenExpired) {
          result['issues'].add('⚠️ Token expired, perlu refresh');
          debugPrint('⚠️ Token expired, akan di-refresh otomatis');

          // Try to refresh token
          await currentUser.getIdToken(true);
          debugPrint('✅ Token berhasil di-refresh');
        } else {
          debugPrint('✅ Token masih valid');
        }
      } catch (tokenError) {
        result['issues'].add('❌ Token error: $tokenError');
        debugPrint('❌ Token error: $tokenError');
      }

      // If we reach here, all criteria are met
      if (result['issues'].isEmpty) {
        result['canUpload'] = true;
        debugPrint('🎉 SEMUA KRITERIA TERPENUHI - UPLOAD SEHARUSNYA BERHASIL');
      }

      debugPrint('🔍 === END UPLOAD CRITERIA CHECK ===');
      return result;
    } catch (e) {
      result['issues'].add('❌ Error checking criteria: $e');
      debugPrint('❌ Error checking upload criteria: $e');
      return result;
    }
  }

  /// Debug current authentication state
  Future<void> debugAuthState() async {
    try {
      debugPrint('🔍 === AUTHENTICATION DEBUG ===');

      final currentUser = _firebaseService.auth.currentUser;
      if (currentUser == null) {
        debugPrint('❌ No current user');
        return;
      }

      debugPrint('👤 User: ${currentUser.email}');
      debugPrint('🆔 UID: ${currentUser.uid}');
      debugPrint('📧 Email verified: ${currentUser.emailVerified}');

      // Check token
      try {
        final tokenResult = await currentUser.getIdTokenResult();
        debugPrint('🔑 Token issued: ${tokenResult.issuedAtTime}');
        debugPrint('🔑 Token expires: ${tokenResult.expirationTime}');
        debugPrint('🔑 Auth time: ${tokenResult.authTime}');

        final now = DateTime.now();
        final isExpired = tokenResult.expirationTime?.isBefore(now) ?? true;
        debugPrint('🔑 Token expired: $isExpired');

        // Get fresh token
        final token = await currentUser.getIdToken(true);

        if (token != null) {
          debugPrint('🔑 Fresh token length: ${token.length}');

          // Safe token preview - handle short tokens
          if (token.length > 50) {
            debugPrint('🔑 Fresh token preview: ${token.substring(0, 50)}...');
          } else {
            debugPrint('🔑 Fresh token preview: $token');
          }
        } else {
          debugPrint('❌ Failed to get token - token is null');
        }
      } catch (tokenError) {
        debugPrint('❌ Token error: $tokenError');
      }

      debugPrint('🔍 === END DEBUG ===');
    } catch (e) {
      debugPrint('❌ Failed to debug auth state: $e');
    }
  }
}
