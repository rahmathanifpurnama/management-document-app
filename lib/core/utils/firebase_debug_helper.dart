import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import '../services/network_service.dart';
import '../config/app_check_config.dart';

/// Helper class for debugging Firebase connection issues
class FirebaseDebugHelper {
  static FirebaseDebugHelper? _instance;
  static FirebaseDebugHelper get instance =>
      _instance ??= FirebaseDebugHelper._();

  FirebaseDebugHelper._();

  // Rate limiting for App Check requests
  static DateTime? _lastAppCheckRequest;
  static const Duration _appCheckCooldown = Duration(minutes: 2);

  /// Run comprehensive Firebase diagnostics
  Future<FirebaseConnectionReport> runDiagnostics() async {
    debugPrint('🔍 Running Firebase diagnostics...');

    final report = FirebaseConnectionReport();

    // Network diagnostics
    final networkDiagnostics = await NetworkService.instance.runDiagnostics();
    report.networkStatus = networkDiagnostics;

    // Firebase Auth status
    report.authStatus = await _checkAuthStatus();

    // Firebase Storage status
    report.storageStatus = await _checkStorageStatus();

    // App Check status
    report.appCheckStatus = await _checkAppCheckStatus();

    // Print comprehensive report
    _printDiagnosticsReport(report);

    return report;
  }

  /// Check Firebase Auth status
  Future<ServiceStatus> _checkAuthStatus() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        debugPrint('✅ Firebase Auth: User logged in (${user.email})');
        return ServiceStatus.healthy;
      } else {
        debugPrint('ℹ️ Firebase Auth: No user logged in');
        return ServiceStatus.noUser;
      }
    } catch (e) {
      debugPrint('❌ Firebase Auth error: $e');
      return ServiceStatus.error;
    }
  }

  /// Check Firebase Storage status
  Future<ServiceStatus> _checkStorageStatus() async {
    try {
      // Try to list files in storage with timeout
      final storageRef = FirebaseStorage.instance.ref().child('documents');

      final listResult = await Future.any([
        storageRef.listAll(),
        Future.delayed(const Duration(seconds: 10)).then(
          (_) => throw TimeoutException(
            'Storage timeout',
            const Duration(seconds: 10),
          ),
        ),
      ]);

      debugPrint(
        '✅ Firebase Storage: Connected (${listResult.items.length} items found)',
      );
      return ServiceStatus.healthy;
    } on TimeoutException {
      debugPrint('⏱️ Firebase Storage: Timeout after 10 seconds');
      return ServiceStatus.timeout;
    } catch (e) {
      debugPrint('❌ Firebase Storage error: $e');
      return ServiceStatus.error;
    }
  }

  /// Check App Check status with rate limiting
  Future<ServiceStatus> _checkAppCheckStatus() async {
    try {
      // Check rate limiting to prevent "too many attempts"
      final now = DateTime.now();
      if (_lastAppCheckRequest != null &&
          now.difference(_lastAppCheckRequest!) < _appCheckCooldown) {
        debugPrint('⏸️ Firebase App Check: Rate limited, skipping check');
        debugPrint('   Last request: $_lastAppCheckRequest');
        debugPrint('   Cooldown: ${_appCheckCooldown.inMinutes} minutes');
        return ServiceStatus.warning;
      }

      _lastAppCheckRequest = now;

      final token = await Future.any([
        FirebaseAppCheck.instance.getToken(),
        Future.delayed(const Duration(seconds: 10)).then(
          (_) => throw TimeoutException(
            'App Check timeout',
            const Duration(seconds: 10),
          ),
        ),
      ]);

      if (token != null && token.isNotEmpty) {
        debugPrint('✅ Firebase App Check: Token obtained');
        return ServiceStatus.healthy;
      } else {
        debugPrint('⚠️ Firebase App Check: Token is null or empty');
        return ServiceStatus.warning;
      }
    } on TimeoutException {
      debugPrint('⏱️ Firebase App Check: Timeout after 10 seconds');
      return ServiceStatus.timeout;
    } catch (e) {
      debugPrint('❌ Firebase App Check error: $e');
      if (e.toString().contains('Too many attempts')) {
        debugPrint('🚨 Rate limit exceeded. Please:');
        debugPrint('   1. Add debug token to Firebase Console');
        debugPrint('   2. Wait 5-10 minutes');
        debugPrint('   3. Restart the app');
      }
      return ServiceStatus.error;
    }
  }

  /// Print comprehensive diagnostics report
  void _printDiagnosticsReport(FirebaseConnectionReport report) {
    debugPrint('\n📊 === FIREBASE DIAGNOSTICS REPORT ===');
    debugPrint('🌐 Network: ${report.networkStatus.status}');
    debugPrint('🔐 Auth: ${report.authStatus.name}');
    debugPrint('📁 Storage: ${report.storageStatus.name}');
    debugPrint('🛡️ App Check: ${report.appCheckStatus.name}');
    debugPrint('⏰ Timestamp: ${DateTime.now()}');

    // App Check configuration info
    final appCheckInfo = AppCheckConfig.getDebugInfo();
    debugPrint('\n🔧 APP CHECK CONFIGURATION:');
    appCheckInfo.forEach((key, value) {
      debugPrint('   $key: $value');
    });

    // Provide recommendations
    final recommendations = _getRecommendations(report);
    if (recommendations.isNotEmpty) {
      debugPrint('\n💡 RECOMMENDATIONS:');
      for (int i = 0; i < recommendations.length; i++) {
        debugPrint('   ${i + 1}. ${recommendations[i]}');
      }
    }

    debugPrint('=====================================\n');
  }

  /// Get recommendations based on diagnostics
  List<String> _getRecommendations(FirebaseConnectionReport report) {
    final recommendations = <String>[];

    if (!report.networkStatus.hasInternet) {
      recommendations.add('Check your internet connection');
    }

    if (!report.networkStatus.canReachFirebase) {
      recommendations.add('Check firewall/proxy settings for Firebase domains');
    }

    if (report.storageStatus == ServiceStatus.timeout) {
      recommendations.add(
        'Firebase Storage is timing out - check network stability',
      );
    }

    if (report.appCheckStatus == ServiceStatus.error) {
      recommendations.add(
        'URGENT: Add debug token 0D5038C4-B4F2-4628-8AD4-D500B904BA04 to Firebase Console',
      );
      recommendations.add(
        'Go to Firebase Console → App Check → Debug tokens → Add debug token',
      );
      recommendations.add(
        'Wait 5-10 minutes after adding token, then restart app',
      );
    }

    if (report.authStatus == ServiceStatus.noUser) {
      recommendations.add('User needs to log in to access Firebase services');
    }

    return recommendations;
  }
}

/// Firebase connection report
class FirebaseConnectionReport {
  late NetworkDiagnostics networkStatus;
  late ServiceStatus authStatus;
  late ServiceStatus storageStatus;
  late ServiceStatus appCheckStatus;

  bool get isHealthy =>
      networkStatus.isHealthy &&
      authStatus == ServiceStatus.healthy &&
      storageStatus == ServiceStatus.healthy;
}

/// Service status enum
enum ServiceStatus { healthy, warning, error, timeout, noUser }
