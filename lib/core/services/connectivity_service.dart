import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../config/anr_config.dart';

/// Enhanced connectivity service that monitors network status and provides
/// real-time connectivity information with Firebase-specific checks
class ConnectivityService {
  static ConnectivityService? _instance;
  static ConnectivityService get instance =>
      _instance ??= ConnectivityService._();

  ConnectivityService._();

  final Connectivity _connectivity = Connectivity();

  // Stream controllers for connectivity state
  final StreamController<List<ConnectivityResult>> _connectivityController =
      StreamController<List<ConnectivityResult>>.broadcast();
  final StreamController<bool> _internetController =
      StreamController<bool>.broadcast();
  final StreamController<bool> _firebaseController =
      StreamController<bool>.broadcast();

  // Current connectivity state
  List<ConnectivityResult> _currentConnectivity = [ConnectivityResult.none];
  bool _hasInternet = false;
  bool _canReachFirebase = false;
  DateTime? _lastConnectivityCheck;

  // Cache for connectivity checks to prevent excessive network calls
  static const Duration _cacheExpiry = Duration(seconds: 30);

  // Streams for external consumption
  Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivityController.stream;
  Stream<bool> get internetStream => _internetController.stream;
  Stream<bool> get firebaseStream => _firebaseController.stream;

  // Current state getters
  List<ConnectivityResult> get currentConnectivity => _currentConnectivity;
  ConnectivityResult get primaryConnectivity => _currentConnectivity.isNotEmpty
      ? _currentConnectivity.first
      : ConnectivityResult.none;
  bool get hasInternet => _hasInternet;
  bool get canReachFirebase => _canReachFirebase;
  bool get isOnline => _hasInternet && _canReachFirebase;
  bool get isOffline => !isOnline;

  /// Initialize the connectivity service
  Future<void> initialize() async {
    try {
      debugPrint('🌐 Initializing ConnectivityService...');

      // Get initial connectivity state
      _currentConnectivity = await _connectivity.checkConnectivity();

      // Listen to connectivity changes
      _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);

      // Perform initial comprehensive check
      await _performComprehensiveCheck();

      debugPrint('✅ ConnectivityService initialized successfully');
    } catch (e) {
      debugPrint('❌ Failed to initialize ConnectivityService: $e');
    }
  }

  /// Handle connectivity changes
  void _onConnectivityChanged(List<ConnectivityResult> results) async {
    final primaryResult = results.isNotEmpty
        ? results.first
        : ConnectivityResult.none;
    debugPrint('🔄 Connectivity changed: ${primaryResult.name}');

    _currentConnectivity = results;
    _connectivityController.add(results);

    // Perform comprehensive check when connectivity changes
    await _performComprehensiveCheck();
  }

  /// Perform comprehensive connectivity check
  Future<void> _performComprehensiveCheck() async {
    try {
      // Check if we should use cached results
      if (_lastConnectivityCheck != null &&
          DateTime.now().difference(_lastConnectivityCheck!) < _cacheExpiry) {
        return;
      }

      final internetCheck = _checkInternetConnection();
      final firebaseCheck = _checkFirebaseConnection();

      // Run checks in parallel with timeout
      final results = await Future.wait([
        internetCheck,
        firebaseCheck,
      ]).timeout(ANRConfig.networkTimeout);

      final hasInternet = results[0];
      final canReachFirebase = results[1];

      // Update state if changed
      if (_hasInternet != hasInternet) {
        _hasInternet = hasInternet;
        _internetController.add(hasInternet);
        debugPrint(
          '📡 Internet status: ${hasInternet ? "Connected" : "Disconnected"}',
        );
      }

      if (_canReachFirebase != canReachFirebase) {
        _canReachFirebase = canReachFirebase;
        _firebaseController.add(canReachFirebase);
        debugPrint(
          '🔥 Firebase status: ${canReachFirebase ? "Reachable" : "Unreachable"}',
        );
      }

      _lastConnectivityCheck = DateTime.now();
    } catch (e) {
      debugPrint('❌ Comprehensive connectivity check failed: $e');
      // Set offline state on error
      _hasInternet = false;
      _canReachFirebase = false;
      _internetController.add(false);
      _firebaseController.add(false);
    }
  }

  /// Check basic internet connectivity
  Future<bool> _checkInternetConnection() async {
    try {
      if (_currentConnectivity.contains(ConnectivityResult.none) ||
          _currentConnectivity.isEmpty) {
        return false;
      }

      // Try to connect to multiple reliable hosts
      final hosts = ['google.com', '8.8.8.8', 'cloudflare.com'];

      for (final host in hosts) {
        try {
          final result = await InternetAddress.lookup(
            host,
          ).timeout(const Duration(seconds: 3));

          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            return true;
          }
        } catch (e) {
          // Continue to next host
          continue;
        }
      }

      return false;
    } catch (e) {
      debugPrint('❌ Internet connection check failed: $e');
      return false;
    }
  }

  /// Check Firebase services connectivity
  Future<bool> _checkFirebaseConnection() async {
    try {
      if (!_hasInternet) {
        return false;
      }

      // Test Firebase endpoints
      final firebaseHosts = [
        'firestore.googleapis.com',
        'firebase.googleapis.com',
        'firebaseauth.googleapis.com',
      ];

      for (final host in firebaseHosts) {
        try {
          final result = await InternetAddress.lookup(
            host,
          ).timeout(const Duration(seconds: 5));

          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            return true;
          }
        } catch (e) {
          // Continue to next host
          continue;
        }
      }

      return false;
    } catch (e) {
      debugPrint('❌ Firebase connection check failed: $e');
      return false;
    }
  }

  /// Force refresh connectivity status
  Future<void> refreshConnectivity() async {
    debugPrint('🔄 Forcing connectivity refresh...');
    _lastConnectivityCheck = null;
    await _performComprehensiveCheck();
  }

  /// Check if device has any network connection
  Future<bool> hasNetworkConnection() async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none) && result.isNotEmpty;
  }

  /// Get detailed connectivity information
  Future<ConnectivityInfo> getConnectivityInfo() async {
    await _performComprehensiveCheck();

    return ConnectivityInfo(
      connectivityResult: primaryConnectivity,
      hasInternet: _hasInternet,
      canReachFirebase: _canReachFirebase,
      isOnline: isOnline,
      lastChecked: _lastConnectivityCheck,
    );
  }

  /// Dispose resources
  void dispose() {
    _connectivityController.close();
    _internetController.close();
    _firebaseController.close();
  }
}

/// Data class for connectivity information
class ConnectivityInfo {
  final ConnectivityResult connectivityResult;
  final bool hasInternet;
  final bool canReachFirebase;
  final bool isOnline;
  final DateTime? lastChecked;

  ConnectivityInfo({
    required this.connectivityResult,
    required this.hasInternet,
    required this.canReachFirebase,
    required this.isOnline,
    this.lastChecked,
  });

  @override
  String toString() {
    return 'ConnectivityInfo('
        'connectivity: ${connectivityResult.name}, '
        'internet: $hasInternet, '
        'firebase: $canReachFirebase, '
        'online: $isOnline, '
        'lastChecked: $lastChecked'
        ')';
  }
}
