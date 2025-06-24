import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

import '../utils/anr_prevention.dart';
import '../config/anr_config.dart';
import 'secure_storage_service.dart';

/// Service for handling biometric authentication
/// Provides fingerprint, face recognition, and other biometric authentication methods
class BiometricAuthService {
  static BiometricAuthService? _instance;
  static BiometricAuthService get instance => _instance ??= BiometricAuthService._();

  BiometricAuthService._();

  final LocalAuthentication _localAuth = LocalAuthentication();
  final SecureStorageService _secureStorage = SecureStorageService.instance;

  // Biometric availability cache
  bool? _isBiometricAvailable;
  List<BiometricType>? _availableBiometrics;
  DateTime? _lastBiometricCheck;
  static const Duration _biometricCacheExpiry = Duration(minutes: 5);

  /// Initialize biometric authentication service
  Future<void> initialize() async {
    try {
      debugPrint('👆 Initializing BiometricAuthService...');
      
      // Check biometric availability
      await _checkBiometricAvailability();
      
      debugPrint('✅ BiometricAuthService initialized successfully');
    } catch (e) {
      debugPrint('❌ Failed to initialize BiometricAuthService: $e');
    }
  }

  /// Check if biometric authentication is available on the device
  Future<bool> isBiometricAvailable() async {
    try {
      // Use cached result if available and not expired
      if (_isBiometricAvailable != null && 
          _lastBiometricCheck != null &&
          DateTime.now().difference(_lastBiometricCheck!) < _biometricCacheExpiry) {
        return _isBiometricAvailable!;
      }

      await _checkBiometricAvailability();
      return _isBiometricAvailable ?? false;
    } catch (e) {
      debugPrint('❌ Failed to check biometric availability: $e');
      return false;
    }
  }

  /// Get list of available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      if (_availableBiometrics != null && 
          _lastBiometricCheck != null &&
          DateTime.now().difference(_lastBiometricCheck!) < _biometricCacheExpiry) {
        return _availableBiometrics!;
      }

      await _checkBiometricAvailability();
      return _availableBiometrics ?? [];
    } catch (e) {
      debugPrint('❌ Failed to get available biometrics: $e');
      return [];
    }
  }

  /// Check biometric availability and cache results
  Future<void> _checkBiometricAvailability() async {
    try {
      // Check if device supports biometrics
      final isAvailable = await ANRPrevention.executeWithTimeout(
        _localAuth.canCheckBiometrics,
        timeout: ANRConfig.defaultTimeout,
        operationName: 'Check Biometric Support',
      ) ?? false;

      if (!isAvailable) {
        _isBiometricAvailable = false;
        _availableBiometrics = [];
        _lastBiometricCheck = DateTime.now();
        return;
      }

      // Get available biometric types
      final availableBiometrics = await ANRPrevention.executeWithTimeout(
        _localAuth.getAvailableBiometrics(),
        timeout: ANRConfig.defaultTimeout,
        operationName: 'Get Available Biometrics',
      ) ?? <BiometricType>[];

      _isBiometricAvailable = availableBiometrics.isNotEmpty;
      _availableBiometrics = availableBiometrics;
      _lastBiometricCheck = DateTime.now();

      debugPrint('👆 Biometric availability: $_isBiometricAvailable');
      debugPrint('👆 Available biometrics: ${availableBiometrics.map((b) => b.name).join(', ')}');
    } catch (e) {
      debugPrint('❌ Failed to check biometric availability: $e');
      _isBiometricAvailable = false;
      _availableBiometrics = [];
      _lastBiometricCheck = DateTime.now();
    }
  }

  /// Authenticate using biometrics
  Future<bool> authenticateWithBiometrics({
    String? localizedFallbackTitle,
    String? cancelButtonText,
  }) async {
    try {
      debugPrint('👆 Starting biometric authentication...');

      // Check if biometrics are available
      if (!await isBiometricAvailable()) {
        debugPrint('❌ Biometric authentication not available');
        return false;
      }

      // Perform biometric authentication
      final isAuthenticated = await ANRPrevention.executeWithTimeout(
        _localAuth.authenticate(
          localizedReason: 'Please authenticate to access your account',
          authMessages: [
            const AndroidAuthMessages(
              signInTitle: 'Biometric Authentication',
              cancelButton: 'Cancel',
              deviceCredentialsRequiredTitle: 'Device Credentials Required',
              deviceCredentialsSetupDescription: 'Please set up device credentials',
              goToSettingsButton: 'Go to Settings',
              goToSettingsDescription: 'Please set up biometric authentication in settings',
            ),
            const IOSAuthMessages(
              cancelButton: 'Cancel',
              goToSettingsButton: 'Go to Settings',
              goToSettingsDescription: 'Please set up biometric authentication in settings',
              lockOut: 'Biometric authentication is disabled. Please re-enable it.',
            ),
          ],
          options: AuthenticationOptions(
            biometricOnly: false, // Allow fallback to device credentials
            stickyAuth: true,
            sensitiveTransaction: true,
            useErrorDialogs: true,
          ),
        ),
        timeout: const Duration(minutes: 2), // Longer timeout for user interaction
        operationName: 'Biometric Authentication',
      ) ?? false;

      if (isAuthenticated) {
        debugPrint('✅ Biometric authentication successful');
        return true;
      } else {
        debugPrint('❌ Biometric authentication failed or cancelled');
        return false;
      }
    } on PlatformException catch (e) {
      debugPrint('❌ Biometric authentication platform error: ${e.code} - ${e.message}');
      return _handleBiometricError(e);
    } catch (e) {
      debugPrint('❌ Biometric authentication error: $e');
      return false;
    }
  }

  /// Handle biometric authentication errors
  bool _handleBiometricError(PlatformException error) {
    switch (error.code) {
      case 'NotAvailable':
        debugPrint('❌ Biometric authentication not available on this device');
        break;
      case 'NotEnrolled':
        debugPrint('❌ No biometric credentials enrolled on this device');
        break;
      case 'LockedOut':
        debugPrint('❌ Biometric authentication locked out due to too many attempts');
        break;
      case 'PermanentlyLockedOut':
        debugPrint('❌ Biometric authentication permanently locked out');
        break;
      case 'UserCancel':
        debugPrint('ℹ️ User cancelled biometric authentication');
        break;
      case 'UserFallback':
        debugPrint('ℹ️ User chose to use fallback authentication');
        break;
      case 'SystemCancel':
        debugPrint('ℹ️ System cancelled biometric authentication');
        break;
      case 'InvalidContext':
        debugPrint('❌ Invalid context for biometric authentication');
        break;
      case 'NotRecognized':
        debugPrint('❌ Biometric not recognized');
        break;
      default:
        debugPrint('❌ Unknown biometric error: ${error.code}');
        break;
    }
    return false;
  }

  /// Enable biometric authentication for the user
  Future<bool> enableBiometricAuth() async {
    try {
      // Check if biometrics are available
      if (!await isBiometricAvailable()) {
        throw Exception('Biometric authentication is not available on this device');
      }

      // Test biometric authentication
      final isAuthenticated = await authenticateWithBiometrics();
      if (!isAuthenticated) {
        throw Exception('Biometric authentication test failed');
      }

      // Store biometric preference
      await _secureStorage.setBiometricEnabled(true);
      
      debugPrint('✅ Biometric authentication enabled');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to enable biometric authentication: $e');
      return false;
    }
  }

  /// Disable biometric authentication for the user
  Future<void> disableBiometricAuth() async {
    try {
      await _secureStorage.setBiometricEnabled(false);
      debugPrint('✅ Biometric authentication disabled');
    } catch (e) {
      debugPrint('❌ Failed to disable biometric authentication: $e');
      rethrow;
    }
  }

  /// Check if biometric authentication is enabled for the user
  Future<bool> isBiometricEnabled() async {
    try {
      return await _secureStorage.isBiometricEnabled();
    } catch (e) {
      debugPrint('❌ Failed to check biometric enabled status: $e');
      return false;
    }
  }

  /// Get user-friendly biometric type names
  String getBiometricTypeName(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return 'Face Recognition';
      case BiometricType.fingerprint:
        return 'Fingerprint';
      case BiometricType.iris:
        return 'Iris Recognition';
      case BiometricType.strong:
        return 'Strong Biometric';
      case BiometricType.weak:
        return 'Weak Biometric';
      default:
        return 'Biometric';
    }
  }

  /// Get available biometric types as user-friendly strings
  Future<List<String>> getAvailableBiometricNames() async {
    final biometrics = await getAvailableBiometrics();
    return biometrics.map((type) => getBiometricTypeName(type)).toList();
  }

  /// Check if device has strong biometric authentication
  Future<bool> hasStrongBiometrics() async {
    final biometrics = await getAvailableBiometrics();
    return biometrics.contains(BiometricType.strong) ||
           biometrics.contains(BiometricType.face) ||
           biometrics.contains(BiometricType.fingerprint);
  }

  /// Get biometric authentication status summary
  Future<BiometricStatus> getBiometricStatus() async {
    final isAvailable = await isBiometricAvailable();
    final isEnabled = await isBiometricEnabled();
    final availableBiometrics = await getAvailableBiometrics();
    final hasStrong = await hasStrongBiometrics();

    return BiometricStatus(
      isAvailable: isAvailable,
      isEnabled: isEnabled,
      availableBiometrics: availableBiometrics,
      hasStrongBiometrics: hasStrong,
    );
  }

  /// Stop using cached biometric availability (force refresh)
  void clearBiometricCache() {
    _isBiometricAvailable = null;
    _availableBiometrics = null;
    _lastBiometricCheck = null;
  }
}

/// Data class for biometric authentication status
class BiometricStatus {
  final bool isAvailable;
  final bool isEnabled;
  final List<BiometricType> availableBiometrics;
  final bool hasStrongBiometrics;

  BiometricStatus({
    required this.isAvailable,
    required this.isEnabled,
    required this.availableBiometrics,
    required this.hasStrongBiometrics,
  });

  @override
  String toString() {
    return 'BiometricStatus('
        'available: $isAvailable, '
        'enabled: $isEnabled, '
        'types: ${availableBiometrics.map((b) => b.name).join(', ')}, '
        'strong: $hasStrongBiometrics'
        ')';
  }
}
