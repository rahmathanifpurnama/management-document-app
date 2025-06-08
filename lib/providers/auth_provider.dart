import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/auth_service.dart';
import '../core/utils/anr_prevention.dart';
import '../core/config/anr_config.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService.instance;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  // Initialize auth state
  Future<void> initializeAuth() async {
    try {
      // Don't call _setLoading during initialization to avoid setState during build
      _isLoading = true;

      // Listen to auth state changes with timeout
      _authService.authStateChanges.listen((User? user) async {
        try {
          if (user != null) {
            await Future.any([
              _loadCurrentUser(),
              Future.delayed(
                const Duration(seconds: 10),
              ), // Timeout after 10 seconds
            ]);
          } else {
            _currentUser = null;
            _isLoggedIn = false;
            notifyListeners();
          }
        } catch (e) {
          _errorMessage = 'Error loading user: ${e.toString()}';
          notifyListeners();
        }
      });

      // Check if user is already logged in with timeout
      if (_authService.isLoggedIn) {
        await Future.any([
          _loadCurrentUser(),
          Future.delayed(const Duration(seconds: 5)), // Timeout after 5 seconds
        ]);
      }
    } catch (e) {
      _errorMessage = 'Gagal menginisialisasi autentikasi: ${e.toString()}';
    } finally {
      _isLoading = false;
      // Only notify listeners at the end of initialization
      notifyListeners();
    }
  }

  // Login with ANR prevention
  Future<bool> login(
    String email,
    String password, {
    bool rememberMe = false,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Execute login with ANR prevention and timeout
      UserModel? user = await ANRPrevention.executeWithTimeout<UserModel?>(
        _authService.login(email, password, rememberMe: rememberMe),
        timeout: ANRConfig.authTimeout,
        operationName: 'User Login',
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
      debugPrint('Login error: ${e.toString()}');
      debugPrint('Error type: ${e.runtimeType}');

      // Handle timeout specifically
      if (e is TimeoutException) {
        _setError(
          'Login timeout. Periksa koneksi internet Anda dan coba lagi.',
        );
      } else {
        _setError(e.toString());
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout
  Future<void> logout() async {
    _setLoading(true);

    try {
      await _authService.logout();
      _currentUser = null;
      _isLoggedIn = false;
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
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
}
