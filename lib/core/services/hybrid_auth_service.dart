import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../utils/credential_encryption.dart';
import '../utils/anr_prevention.dart';
import '../config/anr_config.dart';
import '../../models/offline_auth_models.dart';
import '../../models/user_model.dart';
import 'connectivity_service.dart';
import 'secure_storage_service.dart';
import 'auth_service.dart';
import 'firebase_service.dart';

/// Hybrid authentication service that provides both online and offline authentication
/// capabilities with secure credential storage and session management
class HybridAuthService {
  static HybridAuthService? _instance;
  static HybridAuthService get instance => _instance ??= HybridAuthService._();

  HybridAuthService._();

  // Service dependencies
  final ConnectivityService _connectivityService = ConnectivityService.instance;
  final SecureStorageService _secureStorage = SecureStorageService.instance;
  final AuthService _authService = AuthService.instance;
  final FirebaseService _firebaseService = FirebaseService.instance;

  // Stream controllers for authentication state
  final StreamController<AuthenticationState> _authStateController =
      StreamController<AuthenticationState>.broadcast();
  final StreamController<UserModel?> _userController =
      StreamController<UserModel?>.broadcast();

  // Current authentication state
  AuthenticationState _currentAuthState = AuthenticationState(
    isOnline: false,
    isAuthenticated: false,
    authMode: AuthMode.none,
  );

  UserModel? _currentUser;
  Timer? _sessionTimer;
  Timer? _connectivityTimer;

  // Constants
  static const Duration _sessionDuration = Duration(hours: 24);
  static const Duration _offlineSessionDuration = Duration(hours: 8);
  static const int _maxFailedAttempts = 5;
  static const Duration _lockoutDuration = Duration(minutes: 15);

  // Streams for external consumption
  Stream<AuthenticationState> get authStateStream =>
      _authStateController.stream;
  Stream<UserModel?> get userStream => _userController.stream;

  // Current state getters
  AuthenticationState get currentAuthState => _currentAuthState;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentAuthState.isAuthenticated;
  bool get isOnline => _currentAuthState.isOnline;
  AuthMode get authMode => _currentAuthState.authMode;

  /// Initialize the hybrid authentication service
  Future<void> initialize() async {
    try {
      debugPrint('🔐 Initializing HybridAuthService...');

      // Initialize dependencies
      await _connectivityService.initialize();
      await _secureStorage.initialize();

      // Listen to connectivity changes
      _connectivityService.internetStream.listen(_onConnectivityChanged);

      // Check for existing session
      await _checkExistingSession();

      // Start periodic connectivity checks
      _startConnectivityTimer();

      debugPrint('✅ HybridAuthService initialized successfully');
    } catch (e) {
      debugPrint('❌ Failed to initialize HybridAuthService: $e');
      rethrow;
    }
  }

  /// Handle connectivity changes
  void _onConnectivityChanged(bool isOnline) async {
    debugPrint('🌐 Connectivity changed: ${isOnline ? "Online" : "Offline"}');

    _currentAuthState = _currentAuthState.copyWith(isOnline: isOnline);
    _authStateController.add(_currentAuthState);

    if (isOnline && _currentAuthState.isAuthenticated) {
      // Try to sync when coming back online
      await _syncOfflineActions();
    }
  }

  /// Check for existing authentication session
  Future<void> _checkExistingSession() async {
    try {
      // Check if user is already authenticated with Firebase
      final firebaseUser = _firebaseService.auth.currentUser;
      if (firebaseUser != null) {
        await _handleOnlineSession(firebaseUser);
        return;
      }

      // Check for offline session
      await _checkOfflineSession();
    } catch (e) {
      debugPrint('❌ Failed to check existing session: $e');
    }
  }

  /// Handle online session restoration
  Future<void> _handleOnlineSession(User firebaseUser) async {
    try {
      final userData = await _authService.getCurrentUserData();
      if (userData != null) {
        _currentUser = userData;
        _currentAuthState = _currentAuthState.copyWith(
          isOnline: true,
          isAuthenticated: true,
          authMode: AuthMode.online,
          lastOnlineAuth: DateTime.now(),
          sessionToken: await firebaseUser.getIdToken(),
          sessionExpiry: DateTime.now().add(_sessionDuration),
        );

        _authStateController.add(_currentAuthState);
        _userController.add(_currentUser);
        _startSessionTimer();

        debugPrint('✅ Online session restored');
      }
    } catch (e) {
      debugPrint('❌ Failed to handle online session: $e');
    }
  }

  /// Check for offline session
  Future<void> _checkOfflineSession() async {
    try {
      final hasCredentials = await _secureStorage.hasStoredCredentials();
      if (!hasCredentials) return;

      final lastLoginTime = await _secureStorage.getLastLoginTime();
      if (lastLoginTime != null) {
        final timeSinceLogin = DateTime.now().difference(lastLoginTime);
        if (timeSinceLogin < _offlineSessionDuration) {
          // Restore offline session
          final userData = await _secureStorage.getOfflineUserData();
          if (userData != null) {
            _currentUser = UserModel.fromMap(userData);
            _currentAuthState = _currentAuthState.copyWith(
              isOnline: false,
              isAuthenticated: true,
              authMode: AuthMode.offline,
              lastOfflineAuth: lastLoginTime,
              sessionExpiry: lastLoginTime.add(_offlineSessionDuration),
            );

            _authStateController.add(_currentAuthState);
            _userController.add(_currentUser);
            _startSessionTimer();

            debugPrint('✅ Offline session restored');
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Failed to check offline session: $e');
    }
  }

  /// Login with email and password (hybrid approach)
  Future<UserModel?> login(
    String email,
    String password, {
    bool rememberMe = false,
  }) async {
    try {
      debugPrint('🔐 Starting hybrid login for: $email');

      // Check if account is locked out
      if (_currentAuthState.isLockedOut) {
        throw Exception(
          'Account is temporarily locked. Please try again later.',
        );
      }

      // Try online authentication first if connected
      if (_connectivityService.isOnline) {
        try {
          return await _performOnlineLogin(email, password, rememberMe);
        } catch (e) {
          debugPrint('⚠️ Online login failed, trying offline: $e');
          // Fall back to offline authentication
        }
      }

      // Try offline authentication
      return await _performOfflineLogin(email, password, rememberMe);
    } catch (e) {
      await _handleFailedLogin();
      debugPrint('❌ Hybrid login failed: $e');
      rethrow;
    }
  }

  /// Perform online authentication
  Future<UserModel?> _performOnlineLogin(
    String email,
    String password,
    bool rememberMe,
  ) async {
    debugPrint('🌐 Attempting online login...');

    final user = await ANRPrevention.executeWithTimeout(
      _authService.login(email, password, rememberMe: rememberMe),
      timeout: ANRConfig.networkTimeout,
      operationName: 'Online Login',
    );

    if (user != null) {
      _currentUser = user;

      // Store credentials for offline use if remember me is enabled
      if (rememberMe) {
        await _storeCredentialsForOfflineUse(email, password, user);
      }

      // Update authentication state
      _currentAuthState = _currentAuthState.copyWith(
        isOnline: true,
        isAuthenticated: true,
        authMode: AuthMode.online,
        lastOnlineAuth: DateTime.now(),
        sessionToken: await _firebaseService.auth.currentUser?.getIdToken(),
        sessionExpiry: DateTime.now().add(_sessionDuration),
        failedAttempts: 0,
        lockoutUntil: null,
      );

      await _secureStorage.storeLastLoginTime(DateTime.now());
      _authStateController.add(_currentAuthState);
      _userController.add(_currentUser);
      _startSessionTimer();

      debugPrint('✅ Online login successful');
      return user;
    }

    throw Exception('Online authentication failed');
  }

  /// Perform offline authentication
  Future<UserModel?> _performOfflineLogin(
    String email,
    String password,
    bool rememberMe,
  ) async {
    debugPrint('📱 Attempting offline login...');

    final credentials = await _secureStorage.getUserCredentials();
    if (credentials == null) {
      throw Exception(
        'No offline credentials available. Please connect to the internet and login first.',
      );
    }

    // Verify credentials
    final storedEmail = credentials['email'] as String;
    final storedHash = credentials['hashedPassword'] as String;
    final storedSalt = credentials['salt'] as String;

    if (storedEmail.toLowerCase() != email.toLowerCase()) {
      throw Exception('Invalid credentials');
    }

    if (!CredentialEncryption.verifyPassword(
      password,
      storedHash,
      storedSalt,
    )) {
      throw Exception('Invalid credentials');
    }

    // Load offline user data
    final userData = await _secureStorage.getOfflineUserData();
    if (userData == null) {
      throw Exception('No offline user data available');
    }

    _currentUser = UserModel.fromMap(userData);

    // Update authentication state
    _currentAuthState = _currentAuthState.copyWith(
      isOnline: false,
      isAuthenticated: true,
      authMode: AuthMode.offline,
      lastOfflineAuth: DateTime.now(),
      sessionExpiry: DateTime.now().add(_offlineSessionDuration),
      failedAttempts: 0,
      lockoutUntil: null,
    );

    await _secureStorage.storeLastLoginTime(DateTime.now());
    _authStateController.add(_currentAuthState);
    _userController.add(_currentUser);
    _startSessionTimer();

    debugPrint('✅ Offline login successful');
    return _currentUser;
  }

  /// Store credentials for offline use
  Future<void> _storeCredentialsForOfflineUse(
    String email,
    String password,
    UserModel user,
  ) async {
    try {
      // Generate salt and hash password
      final salt = CredentialEncryption.generateSalt();
      final hashedPassword = CredentialEncryption.hashPassword(password, salt);

      // Store credentials
      await _secureStorage.storeUserCredentials(
        email: email,
        hashedPassword: hashedPassword,
        salt: salt,
      );

      // Store user data for offline access
      await _secureStorage.storeOfflineUserData(user.toMap());

      debugPrint('✅ Credentials stored for offline use');
    } catch (e) {
      debugPrint('❌ Failed to store offline credentials: $e');
    }
  }

  /// Handle failed login attempt
  Future<void> _handleFailedLogin() async {
    final failedAttempts = _currentAuthState.failedAttempts + 1;
    DateTime? lockoutUntil;

    if (failedAttempts >= _maxFailedAttempts) {
      lockoutUntil = DateTime.now().add(_lockoutDuration);
      debugPrint('🔒 Account locked due to too many failed attempts');
    }

    _currentAuthState = _currentAuthState.copyWith(
      failedAttempts: failedAttempts,
      lockoutUntil: lockoutUntil,
    );

    _authStateController.add(_currentAuthState);
  }

  /// Logout from both online and offline sessions
  Future<void> logout() async {
    try {
      debugPrint('🚪 Logging out...');

      // Cancel timers
      _sessionTimer?.cancel();
      _connectivityTimer?.cancel();

      // Logout from Firebase if online
      if (_connectivityService.isOnline) {
        try {
          await _authService.logout();
        } catch (e) {
          debugPrint('⚠️ Firebase logout failed: $e');
        }
      }

      // Clear user data
      _currentUser = null;
      _currentAuthState = AuthenticationState(
        isOnline: _connectivityService.isOnline,
        isAuthenticated: false,
        authMode: AuthMode.none,
      );

      _authStateController.add(_currentAuthState);
      _userController.add(null);

      debugPrint('✅ Logout successful');
    } catch (e) {
      debugPrint('❌ Logout failed: $e');
      rethrow;
    }
  }

  /// Clear all stored credentials and user data
  Future<void> clearOfflineData() async {
    try {
      await _secureStorage.clearUserData();
      debugPrint('✅ Offline data cleared');
    } catch (e) {
      debugPrint('❌ Failed to clear offline data: $e');
      rethrow;
    }
  }

  /// Start session timer for automatic logout
  void _startSessionTimer() {
    _sessionTimer?.cancel();

    final sessionExpiry = _currentAuthState.sessionExpiry;
    if (sessionExpiry != null) {
      final timeUntilExpiry = sessionExpiry.difference(DateTime.now());
      if (timeUntilExpiry.isNegative) {
        // Session already expired
        logout();
        return;
      }

      _sessionTimer = Timer(timeUntilExpiry, () {
        debugPrint('⏰ Session expired, logging out');
        logout();
      });
    }
  }

  /// Start periodic connectivity checks
  void _startConnectivityTimer() {
    _connectivityTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _connectivityService.refreshConnectivity(),
    );
  }

  /// Sync offline actions when connection is restored
  Future<void> _syncOfflineActions() async {
    // This will be implemented in the offline sync service
    debugPrint('🔄 Syncing offline actions...');
  }

  /// Refresh authentication token
  Future<bool> refreshAuthToken() async {
    try {
      final firebaseUser = _firebaseService.auth.currentUser;
      if (firebaseUser == null) return false;

      // Force token refresh
      final newToken = await firebaseUser.getIdToken(true);

      if (newToken != null && newToken.isNotEmpty) {
        _currentAuthState = _currentAuthState.copyWith(
          sessionToken: newToken,
          sessionExpiry: DateTime.now().add(_sessionDuration),
        );

        await _secureStorage.storeAuthTokens(authToken: newToken);
        _authStateController.add(_currentAuthState);

        debugPrint('✅ Auth token refreshed successfully');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('❌ Failed to refresh auth token: $e');
      return false;
    }
  }

  /// Check for account changes (different user logged in)
  Future<bool> detectAccountChange() async {
    try {
      final firebaseUser = _firebaseService.auth.currentUser;
      if (firebaseUser == null) return false;

      final storedCredentials = await _secureStorage.getUserCredentials();
      if (storedCredentials == null) return false;

      final storedEmail = storedCredentials['email'] as String;
      final currentEmail = firebaseUser.email;

      if (currentEmail != null &&
          currentEmail.toLowerCase() != storedEmail.toLowerCase()) {
        debugPrint('⚠️ Account change detected: $storedEmail -> $currentEmail');

        // Clear old credentials and force re-authentication
        await clearOfflineData();
        await logout();

        return true;
      }

      return false;
    } catch (e) {
      debugPrint('❌ Failed to detect account change: $e');
      return false;
    }
  }

  /// Validate session integrity
  Future<bool> validateSessionIntegrity() async {
    try {
      // Check if session is expired
      if (_currentAuthState.sessionExpiry != null &&
          DateTime.now().isAfter(_currentAuthState.sessionExpiry!)) {
        debugPrint('⚠️ Session expired');
        await logout();
        return false;
      }

      // Check if user is still authenticated with Firebase
      if (_currentAuthState.authMode == AuthMode.online) {
        final firebaseUser = _firebaseService.auth.currentUser;
        if (firebaseUser == null) {
          debugPrint('⚠️ Firebase user session lost');
          await logout();
          return false;
        }

        // Check if account changed
        if (await detectAccountChange()) {
          return false;
        }

        // Try to refresh token if it's close to expiry
        if (_currentAuthState.sessionExpiry != null) {
          final timeUntilExpiry = _currentAuthState.sessionExpiry!.difference(
            DateTime.now(),
          );
          if (timeUntilExpiry.inMinutes < 30) {
            await refreshAuthToken();
          }
        }
      }

      // Validate offline session
      if (_currentAuthState.authMode == AuthMode.offline) {
        final lastOfflineAuth = _currentAuthState.lastOfflineAuth;
        if (lastOfflineAuth != null) {
          final timeSinceOfflineAuth = DateTime.now().difference(
            lastOfflineAuth,
          );
          if (timeSinceOfflineAuth > _offlineSessionDuration) {
            debugPrint('⚠️ Offline session expired');
            await logout();
            return false;
          }
        }
      }

      return true;
    } catch (e) {
      debugPrint('❌ Session validation failed: $e');
      return false;
    }
  }

  /// Update session activity (extend session)
  Future<void> updateSessionActivity() async {
    try {
      if (!_currentAuthState.isAuthenticated) return;

      final now = DateTime.now();
      Duration sessionDuration;

      switch (_currentAuthState.authMode) {
        case AuthMode.online:
        case AuthMode.hybrid:
          sessionDuration = _sessionDuration;
          break;
        case AuthMode.offline:
        case AuthMode.biometric:
          sessionDuration = _offlineSessionDuration;
          break;
        default:
          return;
      }

      _currentAuthState = _currentAuthState.copyWith(
        sessionExpiry: now.add(sessionDuration),
      );

      _authStateController.add(_currentAuthState);
      await _secureStorage.storeLastLoginTime(now);

      debugPrint('🔄 Session activity updated');
    } catch (e) {
      debugPrint('❌ Failed to update session activity: $e');
    }
  }

  /// Check credential expiration
  Future<bool> areCredentialsExpired() async {
    try {
      final credentials = await _secureStorage.getUserCredentials();
      if (credentials == null) return true;

      final timestampString = credentials['timestamp'] as String?;
      if (timestampString == null) return true;

      final credentialTimestamp = DateTime.parse(timestampString);
      final credentialAge = DateTime.now().difference(credentialTimestamp);

      // Credentials expire after 30 days
      const maxCredentialAge = Duration(days: 30);

      if (credentialAge > maxCredentialAge) {
        debugPrint('⚠️ Stored credentials expired');
        await clearOfflineData();
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('❌ Failed to check credential expiration: $e');
      return true;
    }
  }

  /// Force logout and clear all data
  Future<void> forceLogout({String? reason}) async {
    try {
      debugPrint(
        '🚨 Force logout triggered${reason != null ? ': $reason' : ''}',
      );

      // Cancel all timers
      _sessionTimer?.cancel();
      _connectivityTimer?.cancel();

      // Clear all stored data
      await clearOfflineData();

      // Logout from Firebase
      try {
        await _authService.logout();
      } catch (e) {
        debugPrint('⚠️ Firebase logout failed during force logout: $e');
      }

      // Reset state
      _currentUser = null;
      _currentAuthState = AuthenticationState(
        isOnline: _connectivityService.isOnline,
        isAuthenticated: false,
        authMode: AuthMode.none,
      );

      _authStateController.add(_currentAuthState);
      _userController.add(null);

      debugPrint('✅ Force logout completed');
    } catch (e) {
      debugPrint('❌ Force logout failed: $e');
    }
  }

  /// Get session information
  Map<String, dynamic> getSessionInfo() {
    return {
      'isAuthenticated': _currentAuthState.isAuthenticated,
      'authMode': _currentAuthState.authMode.name,
      'isOnline': _currentAuthState.isOnline,
      'sessionExpiry': _currentAuthState.sessionExpiry?.toIso8601String(),
      'lastOnlineAuth': _currentAuthState.lastOnlineAuth?.toIso8601String(),
      'lastOfflineAuth': _currentAuthState.lastOfflineAuth?.toIso8601String(),
      'failedAttempts': _currentAuthState.failedAttempts,
      'isLockedOut': _currentAuthState.isLockedOut,
      'lockoutUntil': _currentAuthState.lockoutUntil?.toIso8601String(),
      'biometricEnabled': _currentAuthState.biometricEnabled,
      'sessionValid': _currentAuthState.isSessionValid,
    };
  }

  /// Dispose resources
  void dispose() {
    _sessionTimer?.cancel();
    _connectivityTimer?.cancel();
    _authStateController.close();
    _userController.close();
  }
}
