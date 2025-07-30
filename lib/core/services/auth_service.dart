import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firebase_service.dart';
import '../services/cloud_functions_service.dart';
import '../utils/anr_prevention.dart';
import '../config/anr_config.dart';
import '../../models/user_model.dart';

class AuthService {
  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();

  AuthService._();

  final FirebaseService _firebaseService = FirebaseService.instance;

  // Get current user with safety check
  User? get currentUser {
    try {
      return _firebaseService.auth.currentUser;
    } catch (e) {
      debugPrint('🚨 Error getting current user: $e');
      return null;
    }
  }

  // Get current user stream with safety check
  Stream<User?> get authStateChanges {
    try {
      return _firebaseService.auth.authStateChanges();
    } catch (e) {
      debugPrint('🚨 Error getting auth state changes: $e');
      // Return empty stream if Firebase is not available
      return Stream.value(null);
    }
  }

  // Login with email and password - ANR-safe implementation
  Future<UserModel?> login(
    String email,
    String password, {
    bool rememberMe = false,
  }) async {
    try {
      // Step 1: Firebase Authentication with timeout (no retry for auth errors)
      UserCredential userCredential =
          await ANRPrevention.executeWithTimeout(
            _firebaseService.auth.signInWithEmailAndPassword(
              email: email,
              password: password,
            ),
            timeout: const Duration(seconds: 10),
            operationName: 'Firebase Authentication',
          ) ??
          (throw Exception('Gagal melakukan autentikasi.'));

      if (userCredential.user == null) {
        throw Exception('Gagal melakukan autentikasi.');
      }

      // Step 2: Get user data from Firestore with timeout
      DocumentSnapshot? userDoc = await ANRPrevention.executeWithTimeout(
        _firebaseService.usersCollection.doc(userCredential.user!.uid).get(),
        timeout: ANRConfig.firestoreQueryTimeout,
        operationName: 'Fetch User Data',
      );

      if (userDoc?.exists != true) {
        await logout();
        throw Exception(
          'Data pengguna tidak ditemukan di database. Silakan hubungi administrator untuk melengkapi data akun Anda.',
        );
      }

      // Step 3: Parse user data with error handling
      UserModel user;
      try {
        user = UserModel.fromFirestore(userDoc!);
      } catch (e) {
        await logout();
        throw Exception('Error parsing user data: ${e.toString()}');
      }

      // Step 4: Check if user is active
      if (!user.isActive) {
        await logout();
        throw Exception('Akun Anda tidak aktif. Hubungi administrator.');
      }

      // Step 5: Execute post-login operations in background (truly non-blocking)
      _executePostLoginOperations(
        user: user,
        email: email,
        rememberMe: rememberMe,
      );

      // Step 6: Start real-time listeners after authentication (non-blocking)
      _startRealTimeListenersAfterAuth();

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // Execute post-login operations in background to prevent ANR (truly non-blocking)
  void _executePostLoginOperations({
    required UserModel user,
    required String email,
    required bool rememberMe,
  }) {
    // Execute all operations in background to prevent blocking login UI
    ANRPrevention.executeInBackground(
      () async {
        try {
          // Execute local operations that were previously "critical"
          final localFutures = <Future<void>>[];
          localFutures.add(_saveLoginSessionSafe(user.id));
          localFutures.add(_saveRememberMePreferenceSafe(email, rememberMe));

          // Execute local operations with timeout but don't block login
          await ANRPrevention.executeWithTimeout(
            Future.wait(localFutures, eagerError: false),
            timeout: ANRConfig.defaultTimeout,
            operationName: 'Local Post-Login Operations',
          );

          debugPrint('✅ Local post-login operations completed in background');

          // Execute cloud function post-login operations with optimized timeout
          await _executeCloudPostLoginOperations(user, email);
        } catch (e) {
          debugPrint('⚠️ Post-login operations failed: $e');
          // Don't throw - these are now non-critical for login success
        }
      },
      timeout: const Duration(
        seconds: 3,
      ), // Short timeout for background operations
      operationName: 'Background Post-Login Operations',
    );
  }

  // Execute cloud function post-login operations with optimized error handling
  Future<void> _executeCloudPostLoginOperations(
    UserModel user,
    String email,
  ) async {
    try {
      debugPrint(
        '🔄 Starting cloud post-login operations for user: ${user.id}',
      );

      // Use CloudFunctionsService with optimized timeout
      final cloudFunctionsService = CloudFunctionsService.instance;

      // Execute with very short timeout to prevent UI delays
      final result = await ANRPrevention.executeWithTimeout(
        cloudFunctionsService.handlePostLoginOperations(
          userId: user.id,
          email: email,
          deviceInfo: await _getDeviceInfo(),
        ),
        timeout: const Duration(seconds: 2), // Very short timeout
        operationName: 'Cloud Post-Login Operations',
      );

      if (result != null) {
        debugPrint('✅ Cloud post-login operations completed successfully');
        debugPrint('📊 Activity logging, login count, and last login updated');
      } else {
        debugPrint(
          '⚠️ Cloud post-login operations timed out - continuing normally',
        );
      }
    } catch (e) {
      // Only log errors to console - do not show to user or implement fallbacks
      debugPrint('⚠️ Cloud post-login operations failed: $e');
      debugPrint('📝 This is non-critical - login was successful');

      // Log specific error types for debugging
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('network') || errorString.contains('timeout')) {
        debugPrint('🌐 Network/timeout error - likely poor connectivity');
      } else if (errorString.contains('permission')) {
        debugPrint('🔒 Permission error - check Firestore rules');
      } else if (errorString.contains('unauthenticated')) {
        debugPrint(
          '🚫 Authentication error - user may not be fully authenticated yet',
        );
      }

      // Do not rethrow - login success should not depend on these operations
    }
  }

  // Get device information for activity logging
  Future<Map<String, dynamic>> _getDeviceInfo() async {
    try {
      // Basic device info - can be expanded later
      return {
        'platform': 'Flutter',
        'userAgent': 'SIMDOC Mobile App',
        'source': 'mobile-app',
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('⚠️ Failed to get device info: $e');
      return {
        'platform': 'Unknown',
        'userAgent': 'Unknown',
        'source': 'mobile-app',
      };
    }
  }

  // Start real-time listeners after authentication (non-blocking)
  void _startRealTimeListenersAfterAuth() {
    // Execute in background to prevent blocking login UI
    ANRPrevention.executeInBackground(
      () async {
        try {
          debugPrint('🔐 Starting real-time listeners after authentication...');

          // Note: Real-time listeners will now check authentication status internally
          // This is just a trigger to attempt starting them after login

          debugPrint('✅ Real-time listeners initialization triggered');
        } catch (e) {
          debugPrint('⚠️ Real-time listeners initialization failed: $e');
          // Don't throw - this is non-critical for login success
        }
      },
      timeout: ANRConfig.defaultTimeout,
      operationName: 'Start Real-time Listeners',
    );
  }

  // Logout
  Future<void> logout() async {
    try {
      // Clear login session
      await _clearLoginSession();

      await _firebaseService.auth.signOut();
    } catch (e) {
      throw Exception('Gagal logout: ${e.toString()}');
    }
  }

  // Get current user data
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUser == null) return null;

      DocumentSnapshot userDoc = await _firebaseService.usersCollection
          .doc(currentUser!.uid)
          .get();

      if (userDoc.exists) {
        try {
          return UserModel.fromFirestore(userDoc);
        } catch (e) {
          throw Exception('Error parsing user data: ${e.toString()}');
        }
      }

      return null;
    } catch (e) {
      throw Exception('Gagal mengambil data pengguna: ${e.toString()}');
    }
  }

  // Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  // Get remembered email
  Future<String?> getRememberedEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool('remember_me') ?? false;
    if (rememberMe) {
      return prefs.getString('remembered_email');
    }
    return null;
  }

  // Check if remember me is enabled
  Future<bool> isRememberMeEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('remember_me') ?? false;
  }

  // Clear login session
  Future<void> _clearLoginSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in_user_id');
    await prefs.setBool('is_logged_in', false);
    await prefs.remove('login_timestamp');
  }

  // Check if user has valid session
  Future<bool> hasValidSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (!isLoggedIn || currentUser == null) {
      return false;
    }

    // Check if session is not too old (optional: 30 days)
    int? loginTimestamp = prefs.getInt('login_timestamp');
    if (loginTimestamp != null) {
      DateTime loginTime = DateTime.fromMillisecondsSinceEpoch(loginTimestamp);
      Duration sessionAge = DateTime.now().difference(loginTime);

      // Session expires after 30 days of inactivity
      if (sessionAge.inDays > 30) {
        await _clearLoginSession();
        return false;
      }
    }

    return true;
  }

  // Update session timestamp (call this when user is active)
  Future<void> updateSessionActivity() async {
    if (currentUser != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
        'login_timestamp',
        DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Email tidak terdaftar. Silakan hubungi administrator.';
      case 'wrong-password':
        return 'Password salah. Silakan coba lagi.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'user-disabled':
        return 'Akun telah dinonaktifkan. Hubungi administrator.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan login. Coba lagi dalam beberapa menit.';
      case 'network-request-failed':
        return 'Tidak ada koneksi internet. Periksa koneksi Anda.';
      case 'invalid-credential':
        return 'Email atau password salah. Silakan coba lagi.';
      case 'credential-already-in-use':
        return 'Kredensial sudah digunakan oleh akun lain.';
      case 'recaptcha-not-enabled':
        return 'Sistem keamanan sedang dalam pemeliharaan. Silakan coba lagi.';
      case 'missing-recaptcha-token':
        return 'Token keamanan tidak tersedia. Silakan coba lagi.';
      case 'invalid-recaptcha-token':
        return 'Token keamanan tidak valid. Silakan coba lagi.';
      case 'invalid-verification-code':
        return 'Kode verifikasi tidak valid.';
      case 'invalid-verification-id':
        return 'ID verifikasi tidak valid.';
      case 'session-cookie-expired':
        return 'Sesi telah berakhir. Silakan login kembali.';
      case 'uid-already-exists':
        return 'UID pengguna sudah ada.';
      case 'email-already-in-use':
        return 'Email sudah digunakan oleh akun lain.';
      case 'phone-number-already-exists':
        return 'Nomor telepon sudah digunakan.';
      case 'project-not-found':
        return 'Proyek Firebase tidak ditemukan.';
      case 'insufficient-permission':
        return 'Izin tidak mencukupi.';
      case 'internal-error':
        return 'Terjadi kesalahan internal. Coba lagi nanti.';
      default:
        return 'Terjadi kesalahan: ${e.message ?? e.code}';
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseService.auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Gagal mengirim email reset password: ${e.toString()}');
    }
  }

  // Change password
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      if (currentUser == null) {
        throw Exception('Pengguna tidak ditemukan.');
      }

      // Re-authenticate user
      AuthCredential credential = EmailAuthProvider.credential(
        email: currentUser!.email!,
        password: currentPassword,
      );

      await currentUser!.reauthenticateWithCredential(credential);

      // Update password
      await currentUser!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Gagal mengubah password: ${e.toString()}');
    }
  }

  // ANR-safe methods for login operations

  // Safe login session save with timeout and error handling
  Future<void> _saveLoginSessionSafe(String userId) async {
    try {
      await ANRPrevention.executeWithTimeout(
        _batchSaveLoginSession(userId),
        timeout: ANRConfig.defaultTimeout,
        operationName: 'Save Login Session',
      );
    } catch (e) {
      debugPrint('Failed to save login session: $e');
      // Don't throw - this is non-critical for login success
    }
  }

  // Batch SharedPreferences operations to reduce ANR risk
  Future<void> _batchSaveLoginSession(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // Batch all SharedPreferences operations
    await Future.wait([
      prefs.setString('logged_in_user_id', userId),
      prefs.setBool('is_logged_in', true),
      prefs.setInt('login_timestamp', timestamp),
    ]);
  }

  // Safe remember me preference save with timeout
  Future<void> _saveRememberMePreferenceSafe(
    String email,
    bool rememberMe,
  ) async {
    try {
      await ANRPrevention.executeWithTimeout(
        _batchSaveRememberMePreference(email, rememberMe),
        timeout: ANRConfig.defaultTimeout,
        operationName: 'Save Remember Me Preference',
      );
    } catch (e) {
      debugPrint('Failed to save remember me preference: $e');
      // Don't throw - this is non-critical for login success
    }
  }

  // Batch remember me operations
  Future<void> _batchSaveRememberMePreference(
    String email,
    bool rememberMe,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    if (rememberMe) {
      await Future.wait([
        prefs.setString('remembered_email', email),
        prefs.setBool('remember_me', true),
      ]);
    } else {
      await Future.wait([
        prefs.remove('remembered_email'),
        prefs.setBool('remember_me', false),
      ]);
    }
  }
}
