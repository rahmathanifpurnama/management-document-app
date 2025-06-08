import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firebase_service.dart';
import '../utils/anr_prevention.dart';
import '../config/anr_config.dart';
import '../../models/user_model.dart';
import '../../models/activity_model.dart';
import 'cloud_functions_service.dart';

class AuthService {
  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();

  AuthService._();

  final FirebaseService _firebaseService = FirebaseService.instance;

  // Get current user
  User? get currentUser => _firebaseService.auth.currentUser;

  // Get current user stream
  Stream<User?> get authStateChanges =>
      _firebaseService.auth.authStateChanges();

  // Login with email and password - ANR-safe implementation
  Future<UserModel?> login(
    String email,
    String password, {
    bool rememberMe = false,
  }) async {
    try {
      // Step 1: Firebase Authentication with timeout
      UserCredential? userCredential = await ANRPrevention.executeWithTimeout(
        _firebaseService.auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
        timeout: ANRConfig.authTimeout,
        operationName: 'Firebase Authentication',
      );

      if (userCredential?.user == null) {
        throw Exception('Gagal melakukan autentikasi.');
      }

      // Step 2: Get user data from Firestore with timeout
      DocumentSnapshot? userDoc = await ANRPrevention.executeWithTimeout(
        _firebaseService.usersCollection.doc(userCredential!.user!.uid).get(),
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

      // Step 5: Execute post-login operations in parallel (non-blocking)
      await _executePostLoginOperations(
        user: user,
        email: email,
        rememberMe: rememberMe,
      );

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // Execute post-login operations in background to prevent ANR
  Future<void> _executePostLoginOperations({
    required UserModel user,
    required String email,
    required bool rememberMe,
  }) async {
    // Execute critical operations locally (must complete for login success)
    final criticalFutures = <Future<void>>[];
    criticalFutures.add(_saveLoginSessionSafe(user.id));
    criticalFutures.add(_saveRememberMePreferenceSafe(email, rememberMe));

    // Execute critical operations with timeout
    await ANRPrevention.executeWithTimeout(
      Future.wait(criticalFutures, eagerError: false),
      timeout: ANRConfig.defaultTimeout,
      operationName: 'Critical Post-Login Operations',
    );

    // Execute non-critical operations via Cloud Functions (fire and forget)
    _executeCloudFunctionPostLogin(user.id, email);
  }

  // Execute non-critical post-login operations via Cloud Functions
  void _executeCloudFunctionPostLogin(String userId, String email) {
    // Fire and forget - don't await to prevent blocking login
    ANRPrevention.executeInBackground(
      () async {
        try {
          final cloudFunctions = CloudFunctionsService.instance;
          await cloudFunctions.handlePostLoginOperations(
            userId: userId,
            email: email,
            deviceInfo: {
              'userAgent': 'Flutter App',
              'platform': 'Mobile',
              'appVersion': '1.0.0',
            },
          );
        } catch (e) {
          debugPrint('Cloud function post-login operations failed: $e');
          // Fallback to local operations if Cloud Functions fail
          _updateLastLoginSafe(userId);
          _logActivitySafe(userId, ActivityType.login, 'System Login');
        }
      },
      timeout: ANRConfig.networkTimeout,
      operationName: 'Cloud Function Post-Login',
    );
  }

  // Logout
  Future<void> logout() async {
    try {
      String? userId = currentUser?.uid;

      // Log activity before logout
      if (userId != null) {
        await _logActivity(userId, ActivityType.logout, 'System Logout');
      }

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

  // Log user activity (used by logout)
  Future<void> _logActivity(
    String userId,
    ActivityType action,
    String resource,
  ) async {
    try {
      ActivityModel activity = ActivityModel(
        id: '',
        userId: userId,
        action: action.value,
        resource: resource,
        timestamp: DateTime.now(),
        details: {'userAgent': 'Flutter App', 'platform': 'Mobile'},
      );

      await _firebaseService.activitiesCollection.add(activity.toMap());
    } catch (e) {
      // Don't throw error for activity logging
      // Activity logging failed silently
    }
  }

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

      // Log activity
      await _logActivity(
        currentUser!.uid,
        ActivityType.update,
        'Password Changed',
      );
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

  // Safe last login update with timeout
  Future<void> _updateLastLoginSafe(String userId) async {
    try {
      await ANRPrevention.executeWithTimeout(
        _firebaseService.usersCollection.doc(userId).update({
          'lastLogin': FieldValue.serverTimestamp(),
        }),
        timeout: ANRConfig.firestoreQueryTimeout,
        operationName: 'Update Last Login',
      );
    } catch (e) {
      debugPrint('Failed to update last login: $e');
      // Don't throw - this is non-critical for login success
    }
  }

  // Safe activity logging with timeout
  Future<void> _logActivitySafe(
    String userId,
    ActivityType action,
    String resource,
  ) async {
    try {
      await ANRPrevention.executeInBackground(
        () async {
          final activity = ActivityModel(
            id: '',
            userId: userId,
            action: action.value,
            resource: resource,
            timestamp: DateTime.now(),
            details: {'userAgent': 'Flutter App', 'platform': 'Mobile'},
          );

          await _firebaseService.activitiesCollection.add(activity.toMap());
        },
        timeout: ANRConfig.firestoreQueryTimeout,
        operationName: 'Log Activity',
      );
    } catch (e) {
      debugPrint('Failed to log activity: $e');
      // Don't throw - activity logging is non-critical
    }
  }
}
