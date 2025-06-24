import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/auth_service.dart';
import '../core/services/hybrid_auth_service.dart';
import '../core/services/biometric_auth_service.dart';
import '../core/services/connectivity_service.dart';

import '../services/enhanced_auth_service.dart';
import '../models/user_model.dart';
import '../models/offline_auth_models.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService.instance;
  final HybridAuthService _hybridAuthService = HybridAuthService.instance;
  final BiometricAuthService _biometricAuthService =
      BiometricAuthService.instance;
  final ConnectivityService _connectivityService = ConnectivityService.instance;
  final EnhancedAuthService _enhancedAuthService = EnhancedAuthService.instance;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;
  AuthenticationState? _authState;
  bool _isOnline = false;
  bool _biometricEnabled = false;

  // Stream subscriptions
  StreamSubscription<AuthenticationState>? _authStateSubscription;
  StreamSubscription<UserModel?>? _userSubscription;
  StreamSubscription<bool>? _connectivitySubscription;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  bool get isOnline => _isOnline;
  bool get isOffline => !_isOnline;
  AuthMode get authMode => _authState?.authMode ?? AuthMode.none;
  bool get biometricEnabled => _biometricEnabled;
  bool get canUseBiometric =>
      _biometricEnabled && _authState?.biometricEnabled == true;

  // Initialize auth state
  Future<void> initializeAuth() async {
    try {
      // Don't call _setLoading during initialization to avoid setState during build
      _isLoading = true;

      // Initialize hybrid auth service
      await _hybridAuthService.initialize();
      await _biometricAuthService.initialize();

      // Listen to hybrid auth state changes
      _authStateSubscription = _hybridAuthService.authStateStream.listen((
        authState,
      ) {
        _authState = authState;
        _isLoggedIn = authState.isAuthenticated;
        _isOnline = authState.isOnline;
        notifyListeners();
      });

      // Listen to user changes
      _userSubscription = _hybridAuthService.userStream.listen((user) {
        _currentUser = user;
        notifyListeners();
      });

      // Listen to connectivity changes
      _connectivitySubscription = _connectivityService.internetStream.listen((
        isOnline,
      ) {
        _isOnline = isOnline;
        notifyListeners();
      });

      // Check biometric availability
      _biometricEnabled = await _biometricAuthService.isBiometricAvailable();

      // Fallback: Listen to Firebase auth state changes for compatibility
      _authService.authStateChanges.listen((User? user) async {
        try {
          if (user != null && !_isLoggedIn) {
            // Only handle if hybrid auth hasn't already handled it
            await Future.any([
              _loadCurrentUser(),
              Future.delayed(
                const Duration(seconds: 10),
              ), // Timeout after 10 seconds
            ]);
          } else if (user == null && _authState?.authMode == AuthMode.online) {
            // Handle Firebase logout
            _currentUser = null;
            _isLoggedIn = false;
            notifyListeners();
          }
        } catch (e) {
          _errorMessage = 'Error loading user: ${e.toString()}';
          notifyListeners();
        }
      });
    } catch (e) {
      _errorMessage = 'Gagal menginisialisasi autentikasi: ${e.toString()}';
    } finally {
      _isLoading = false;
      // Only notify listeners at the end of initialization
      notifyListeners();
    }
  }

  // Login with hybrid authentication (online/offline)
  Future<bool> login(
    String email,
    String password, {
    bool rememberMe = false,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Use hybrid auth service for login
      UserModel? user = await _hybridAuthService.login(
        email,
        password,
        rememberMe: rememberMe,
      );

      if (user != null) {
        _currentUser = user;
        _isLoggedIn = true;
        notifyListeners();
        return true;
      }

      _setError('Login gagal. Silakan coba lagi.');
      return false;
    } catch (e) {
      // Debug: Print detailed error information
      debugPrint('Hybrid login error: ${e.toString()}');
      debugPrint('Error type: ${e.runtimeType}');

      // Handle specific error types
      if (e is TimeoutException) {
        _setError(
          'Login timeout. Periksa koneksi internet Anda dan coba lagi.',
        );
      } else if (e.toString().contains('locked')) {
        _setError('Akun terkunci sementara. Silakan coba lagi nanti.');
      } else if (e.toString().contains('offline credentials')) {
        _setError(
          'Tidak ada kredensial offline. Silakan login online terlebih dahulu.',
        );
      } else {
        _setError(e.toString());
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Login with biometric authentication
  Future<bool> loginWithBiometric() async {
    if (!_biometricEnabled) {
      _setError('Autentikasi biometrik tidak tersedia.');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      // Authenticate with biometrics
      final isAuthenticated = await _biometricAuthService
          .authenticateWithBiometrics();

      if (!isAuthenticated) {
        _setError('Autentikasi biometrik gagal.');
        return false;
      }

      // Check if we have stored credentials for offline login
      final hasCredentials =
          _hybridAuthService.currentAuthState.isAuthenticated;
      if (!hasCredentials) {
        _setError(
          'Tidak ada sesi tersimpan. Silakan login dengan email dan password.',
        );
        return false;
      }

      // User is already authenticated through hybrid service
      return true;
    } catch (e) {
      debugPrint('Biometric login error: ${e.toString()}');
      _setError('Gagal melakukan autentikasi biometrik: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout from both online and offline sessions
  Future<void> logout() async {
    _setLoading(true);

    try {
      // Use hybrid auth service for logout
      await _hybridAuthService.logout();

      _currentUser = null;
      _isLoggedIn = false;
      _authState = null;
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Clear all offline data
  Future<void> clearOfflineData() async {
    _setLoading(true);
    _clearError();

    try {
      await _hybridAuthService.clearOfflineData();
      debugPrint('✅ Offline data cleared');
    } catch (e) {
      _setError('Gagal menghapus data offline: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Load current user data with timeout
  Future<void> _loadCurrentUser() async {
    try {
      // Add timeout to prevent hanging
      UserModel? user = await _authService.getCurrentUserData().timeout(
        const Duration(seconds: 10),
      );
      if (user != null) {
        _currentUser = user;
        _isLoggedIn = true;
      } else {
        _currentUser = null;
        _isLoggedIn = false;
      }
      notifyListeners();
    } catch (e) {
      _setError('Gagal memuat data pengguna: ${e.toString()}');
    }
  }

  // Refresh current user data
  Future<void> refreshCurrentUser() async {
    if (_authService.isLoggedIn) {
      await _loadCurrentUser();
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Change password
  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.changePassword(currentPassword, newPassword);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get remembered email
  Future<String?> getRememberedEmail() async {
    return await _authService.getRememberedEmail();
  }

  // Check if remember me is enabled
  Future<bool> isRememberMeEnabled() async {
    return await _authService.isRememberMeEnabled();
  }

  // Check if user has valid session for auto-login
  Future<bool> hasValidSession() async {
    return await _authService.hasValidSession();
  }

  // Update session activity
  Future<void> updateSessionActivity() async {
    await _authService.updateSessionActivity();
  }

  // Update current user
  void updateCurrentUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear error manually
  void clearError() {
    _clearError();
  }

  // Enhanced role-based permission methods

  /// Check if current user has admin privileges
  Future<bool> get isCurrentUserAdmin async {
    return await _enhancedAuthService.isCurrentUserAdmin;
  }

  /// Check if current user has specific document permission
  Future<bool> hasDocumentPermission(String permission) async {
    return await _enhancedAuthService.hasDocumentPermission(permission);
  }

  /// Check if current user can access specific category
  Future<bool> hasCategoryAccess(String categoryId) async {
    return await _enhancedAuthService.hasCategoryAccess(categoryId);
  }

  /// Check if current user has specific system permission
  Future<bool> hasSystemPermission(String permission) async {
    return await _enhancedAuthService.hasSystemPermission(permission);
  }

  /// Check if user can perform unlimited queries
  Future<bool> canPerformUnlimitedQueries() async {
    return await _enhancedAuthService.canPerformUnlimitedQueries();
  }

  /// Check if user can access storage management
  Future<bool> canAccessStorageManagement() async {
    return await _enhancedAuthService.canAccessStorageManagement();
  }

  /// Check if user can manage other users
  Future<bool> canManageUsers() async {
    return await _enhancedAuthService.canManageUsers();
  }

  /// Check if user can view analytics
  Future<bool> canViewAnalytics() async {
    return await _enhancedAuthService.canViewAnalytics();
  }

  /// Check if user can upload files
  Future<bool> canUploadFiles() async {
    return await _enhancedAuthService.canUploadFiles();
  }

  /// Check if user can delete files
  Future<bool> canDeleteFiles() async {
    return await _enhancedAuthService.canDeleteFiles();
  }

  /// Check if user can approve files
  Future<bool> canApproveFiles() async {
    return await _enhancedAuthService.canApproveFiles();
  }

  /// Get current user's permission summary
  Future<Map<String, dynamic>> getCurrentUserPermissionSummary() async {
    return await _enhancedAuthService.getCurrentUserPermissionSummary();
  }

  /// Refresh current user permissions
  Future<void> refreshCurrentUserPermissions() async {
    await _enhancedAuthService.refreshCurrentUserPermissions();
    notifyListeners(); // Notify UI to update
  }

  /// Check if user has access to specific document
  Future<bool> hasDocumentAccess(String documentId, String action) async {
    return await _enhancedAuthService.hasDocumentAccess(documentId, action);
  }

  // Biometric authentication methods

  /// Enable biometric authentication
  Future<bool> enableBiometricAuth() async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _biometricAuthService.enableBiometricAuth();
      if (success) {
        _biometricEnabled = true;
        notifyListeners();
      }
      return success;
    } catch (e) {
      _setError('Gagal mengaktifkan autentikasi biometrik: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Disable biometric authentication
  Future<void> disableBiometricAuth() async {
    _setLoading(true);
    _clearError();

    try {
      await _biometricAuthService.disableBiometricAuth();
      _biometricEnabled = false;
      notifyListeners();
    } catch (e) {
      _setError('Gagal menonaktifkan autentikasi biometrik: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Get biometric status
  Future<BiometricStatus> getBiometricStatus() async {
    return await _biometricAuthService.getBiometricStatus();
  }

  /// Get available biometric types
  Future<List<String>> getAvailableBiometricNames() async {
    return await _biometricAuthService.getAvailableBiometricNames();
  }

  // Connectivity and sync methods

  /// Force refresh connectivity status
  Future<void> refreshConnectivity() async {
    await _connectivityService.refreshConnectivity();
  }

  /// Get connectivity information
  Future<ConnectivityInfo> getConnectivityInfo() async {
    return await _connectivityService.getConnectivityInfo();
  }

  // Dispose method to clean up resources
  @override
  void dispose() {
    _authStateSubscription?.cancel();
    _userSubscription?.cancel();
    _connectivitySubscription?.cancel();
    _hybridAuthService.dispose();
    super.dispose();
  }
}
