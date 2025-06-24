import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/anr_prevention.dart';
import '../config/anr_config.dart';

/// Secure storage service for managing encrypted local data storage
/// Uses flutter_secure_storage for secure key-value storage with encryption
class SecureStorageService {
  static SecureStorageService? _instance;
  static SecureStorageService get instance =>
      _instance ??= SecureStorageService._();

  SecureStorageService._();

  // Flutter Secure Storage instance with custom options
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      sharedPreferencesName: 'simdoc_secure_prefs',
      preferencesKeyPrefix: 'simdoc_',
    ),
    iOptions: IOSOptions(
      groupId: 'group.com.simdoc.app',
      accountName: 'simdoc_keychain',
    ),
    wOptions: WindowsOptions(),
    lOptions: LinuxOptions(),
    webOptions: WebOptions(
      dbName: 'simdoc_secure_db',
      publicKey: 'simdoc_public_key',
    ),
  );

  // Storage keys
  static const String _keyUserCredentials = 'user_credentials';
  static const String _keyOfflineUserData = 'offline_user_data';
  static const String _keyAuthToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyBiometricEnabled = 'biometric_enabled';
  static const String _keyLastLoginTime = 'last_login_time';
  static const String _keyOfflineActions = 'offline_actions';
  static const String _keyEncryptionSalt = 'encryption_salt';
  static const String _keyUserSession = 'user_session';

  /// Initialize secure storage service
  Future<void> initialize() async {
    try {
      debugPrint('🔐 Initializing SecureStorageService...');

      // Test storage availability
      await _testStorageAvailability();

      debugPrint('✅ SecureStorageService initialized successfully');
    } catch (e) {
      debugPrint('❌ Failed to initialize SecureStorageService: $e');
      rethrow;
    }
  }

  /// Test if secure storage is available and working
  Future<void> _testStorageAvailability() async {
    try {
      const testKey = 'test_key';
      const testValue = 'test_value';

      await _secureStorage.write(key: testKey, value: testValue);
      final retrievedValue = await _secureStorage.read(key: testKey);

      if (retrievedValue != testValue) {
        throw Exception('Secure storage test failed');
      }

      await _secureStorage.delete(key: testKey);
      debugPrint('✅ Secure storage test passed');
    } catch (e) {
      debugPrint('❌ Secure storage test failed: $e');
      throw Exception('Secure storage is not available: $e');
    }
  }

  /// Store user credentials securely
  Future<void> storeUserCredentials({
    required String email,
    required String hashedPassword,
    required String salt,
  }) async {
    try {
      final credentials = {
        'email': email,
        'hashedPassword': hashedPassword,
        'salt': salt,
        'timestamp': DateTime.now().toIso8601String(),
      };

      await ANRPrevention.executeWithTimeout(
        _secureStorage.write(
          key: _keyUserCredentials,
          value: jsonEncode(credentials),
        ),
        timeout: ANRConfig.defaultTimeout,
        operationName: 'Store User Credentials',
      );

      debugPrint('✅ User credentials stored securely');
    } catch (e) {
      debugPrint('❌ Failed to store user credentials: $e');
      rethrow;
    }
  }

  /// Retrieve user credentials
  Future<Map<String, dynamic>?> getUserCredentials() async {
    try {
      final credentialsJson = await ANRPrevention.executeWithTimeout(
        _secureStorage.read(key: _keyUserCredentials),
        timeout: ANRConfig.defaultTimeout,
        operationName: 'Get User Credentials',
      );

      if (credentialsJson == null) {
        return null;
      }

      return jsonDecode(credentialsJson) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('❌ Failed to retrieve user credentials: $e');
      return null;
    }
  }

  /// Store offline user data
  Future<void> storeOfflineUserData(Map<String, dynamic> userData) async {
    try {
      await ANRPrevention.executeWithTimeout(
        _secureStorage.write(
          key: _keyOfflineUserData,
          value: jsonEncode(userData),
        ),
        timeout: ANRConfig.defaultTimeout,
        operationName: 'Store Offline User Data',
      );

      debugPrint('✅ Offline user data stored');
    } catch (e) {
      debugPrint('❌ Failed to store offline user data: $e');
      rethrow;
    }
  }

  /// Retrieve offline user data
  Future<Map<String, dynamic>?> getOfflineUserData() async {
    try {
      final userDataJson = await ANRPrevention.executeWithTimeout(
        _secureStorage.read(key: _keyOfflineUserData),
        timeout: ANRConfig.defaultTimeout,
        operationName: 'Get Offline User Data',
      );

      if (userDataJson == null) {
        return null;
      }

      return jsonDecode(userDataJson) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('❌ Failed to retrieve offline user data: $e');
      return null;
    }
  }

  /// Store authentication tokens
  Future<void> storeAuthTokens({
    String? authToken,
    String? refreshToken,
  }) async {
    try {
      if (authToken != null) {
        await _secureStorage.write(key: _keyAuthToken, value: authToken);
      }

      if (refreshToken != null) {
        await _secureStorage.write(key: _keyRefreshToken, value: refreshToken);
      }

      debugPrint('✅ Auth tokens stored');
    } catch (e) {
      debugPrint('❌ Failed to store auth tokens: $e');
      rethrow;
    }
  }

  /// Retrieve authentication tokens
  Future<Map<String, String?>> getAuthTokens() async {
    try {
      final authToken = await _secureStorage.read(key: _keyAuthToken);
      final refreshToken = await _secureStorage.read(key: _keyRefreshToken);

      return {'authToken': authToken, 'refreshToken': refreshToken};
    } catch (e) {
      debugPrint('❌ Failed to retrieve auth tokens: $e');
      return {'authToken': null, 'refreshToken': null};
    }
  }

  /// Store biometric preference
  Future<void> setBiometricEnabled(bool enabled) async {
    try {
      await _secureStorage.write(
        key: _keyBiometricEnabled,
        value: enabled.toString(),
      );
    } catch (e) {
      debugPrint('❌ Failed to store biometric preference: $e');
    }
  }

  /// Get biometric preference
  Future<bool> isBiometricEnabled() async {
    try {
      final value = await _secureStorage.read(key: _keyBiometricEnabled);
      return value == 'true';
    } catch (e) {
      debugPrint('❌ Failed to get biometric preference: $e');
      return false;
    }
  }

  /// Store last login time
  Future<void> storeLastLoginTime(DateTime loginTime) async {
    try {
      await _secureStorage.write(
        key: _keyLastLoginTime,
        value: loginTime.toIso8601String(),
      );
    } catch (e) {
      debugPrint('❌ Failed to store last login time: $e');
    }
  }

  /// Get last login time
  Future<DateTime?> getLastLoginTime() async {
    try {
      final timeString = await _secureStorage.read(key: _keyLastLoginTime);
      if (timeString != null) {
        return DateTime.parse(timeString);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Failed to get last login time: $e');
      return null;
    }
  }

  /// Store offline actions queue
  Future<void> storeOfflineActions(List<Map<String, dynamic>> actions) async {
    try {
      await _secureStorage.write(
        key: _keyOfflineActions,
        value: jsonEncode(actions),
      );
    } catch (e) {
      debugPrint('❌ Failed to store offline actions: $e');
    }
  }

  /// Get offline actions queue
  Future<List<Map<String, dynamic>>> getOfflineActions() async {
    try {
      final actionsJson = await _secureStorage.read(key: _keyOfflineActions);
      if (actionsJson != null) {
        final List<dynamic> actionsList = jsonDecode(actionsJson);
        return actionsList.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      debugPrint('❌ Failed to get offline actions: $e');
      return [];
    }
  }

  /// Store encryption salt
  Future<void> storeEncryptionSalt(String salt) async {
    try {
      await _secureStorage.write(key: _keyEncryptionSalt, value: salt);
    } catch (e) {
      debugPrint('❌ Failed to store encryption salt: $e');
    }
  }

  /// Get encryption salt
  Future<String?> getEncryptionSalt() async {
    try {
      return await _secureStorage.read(key: _keyEncryptionSalt);
    } catch (e) {
      debugPrint('❌ Failed to get encryption salt: $e');
      return null;
    }
  }

  /// Clear all stored data
  Future<void> clearAll() async {
    try {
      await ANRPrevention.executeWithTimeout(
        _secureStorage.deleteAll(),
        timeout: ANRConfig.defaultTimeout,
        operationName: 'Clear All Secure Storage',
      );

      debugPrint('✅ All secure storage data cleared');
    } catch (e) {
      debugPrint('❌ Failed to clear secure storage: $e');
      rethrow;
    }
  }

  /// Clear user-specific data (keep app settings)
  Future<void> clearUserData() async {
    try {
      final keysToDelete = [
        _keyUserCredentials,
        _keyOfflineUserData,
        _keyAuthToken,
        _keyRefreshToken,
        _keyLastLoginTime,
        _keyOfflineActions,
        _keyUserSession,
      ];

      for (final key in keysToDelete) {
        await _secureStorage.delete(key: key);
      }

      debugPrint('✅ User data cleared from secure storage');
    } catch (e) {
      debugPrint('❌ Failed to clear user data: $e');
      rethrow;
    }
  }

  /// Check if user credentials exist
  Future<bool> hasStoredCredentials() async {
    try {
      final credentials = await _secureStorage.read(key: _keyUserCredentials);
      return credentials != null;
    } catch (e) {
      debugPrint('❌ Failed to check stored credentials: $e');
      return false;
    }
  }
}
