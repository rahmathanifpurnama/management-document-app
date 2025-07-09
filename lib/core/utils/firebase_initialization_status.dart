import 'package:flutter/foundation.dart';

/// Global Firebase initialization status tracker
/// 
/// This class helps prevent provider initialization errors when Firebase
/// is not yet initialized or when the app is offline.
class FirebaseInitializationStatus {
  static bool _isInitialized = false;
  static String? _lastError;
  static bool _isOfflineMode = false;

  /// Whether Firebase has been successfully initialized
  static bool get isInitialized => _isInitialized;
  
  /// Set Firebase initialization status
  static set isInitialized(bool value) {
    _isInitialized = value;
    debugPrint('🔥 Firebase initialization status: ${value ? "✅ Initialized" : "❌ Failed"}');
  }

  /// Last Firebase initialization error
  static String? get lastError => _lastError;
  
  /// Set last Firebase error
  static set lastError(String? error) {
    _lastError = error;
    if (error != null) {
      debugPrint('🚨 Firebase error: $error');
    }
  }

  /// Whether the app is running in offline mode
  static bool get isOfflineMode => _isOfflineMode;
  
  /// Set offline mode status
  static set isOfflineMode(bool value) {
    _isOfflineMode = value;
    debugPrint('📱 Offline mode: ${value ? "✅ Enabled" : "❌ Disabled"}');
  }

  /// Check if it's safe to initialize Firebase-dependent providers
  static bool get canInitializeProviders {
    return _isInitialized || _isOfflineMode;
  }

  /// Get user-friendly status message
  static String get statusMessage {
    if (_isInitialized) {
      return 'Connected to services';
    } else if (_isOfflineMode) {
      return 'Running in offline mode';
    } else if (_lastError != null) {
      if (_lastError!.toLowerCase().contains('network') ||
          _lastError!.toLowerCase().contains('connection')) {
        return 'No internet connection';
      } else if (_lastError!.toLowerCase().contains('firebase')) {
        return 'Unable to connect to services';
      } else {
        return 'Service initialization failed';
      }
    } else {
      return 'Initializing services...';
    }
  }

  /// Reset all status flags (useful for retry operations)
  static void reset() {
    _isInitialized = false;
    _lastError = null;
    _isOfflineMode = false;
    debugPrint('🔄 Firebase initialization status reset');
  }
}
