import 'package:flutter/foundation.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import '../config/app_check_config.dart';
import '../../config/firebase_config.dart';

/// Utility class to check and manage App Check status
class AppCheckStatus {
  static AppCheckStatus? _instance;
  static AppCheckStatus get instance => _instance ??= AppCheckStatus._();
  
  AppCheckStatus._();

  /// Check if App Check is properly configured
  Future<AppCheckStatusResult> checkStatus() async {
    try {
      // Check configuration
      final isEnabledInDebug = FirebaseConfig.enableAppCheckInDebug;
      final isEnabledInProduction = FirebaseConfig.enableAppCheckInProduction;
      
      if (kDebugMode && !isEnabledInDebug) {
        return AppCheckStatusResult(
          isEnabled: false,
          status: AppCheckStatusType.disabledInDebug,
          message: 'App Check is disabled in debug mode (recommended)',
          recommendation: 'This prevents "Too many attempts" errors',
        );
      }
      
      if (!kDebugMode && !isEnabledInProduction) {
        return AppCheckStatusResult(
          isEnabled: false,
          status: AppCheckStatusType.disabledInProduction,
          message: 'App Check is disabled in production mode',
          recommendation: 'Consider enabling for better security',
        );
      }

      // Try to get a token to verify it's working
      try {
        final token = await Future.any([
          FirebaseAppCheck.instance.getToken(),
          Future.delayed(const Duration(seconds: 5), () => null),
        ]);
        
        if (token != null) {
          return AppCheckStatusResult(
            isEnabled: true,
            status: AppCheckStatusType.working,
            message: 'App Check is working correctly',
            recommendation: 'No action needed',
          );
        } else {
          return AppCheckStatusResult(
            isEnabled: true,
            status: AppCheckStatusType.tokenTimeout,
            message: 'App Check token request timed out',
            recommendation: 'Check network connection or disable App Check',
          );
        }
      } catch (e) {
        if (e.toString().contains('Too many attempts')) {
          return AppCheckStatusResult(
            isEnabled: true,
            status: AppCheckStatusType.tooManyAttempts,
            message: 'Too many attempts error detected',
            recommendation: 'Disable App Check in debug mode or configure debug token',
          );
        } else {
          return AppCheckStatusResult(
            isEnabled: true,
            status: AppCheckStatusType.error,
            message: 'App Check error: ${e.toString()}',
            recommendation: 'Check Firebase Console configuration',
          );
        }
      }
    } catch (e) {
      return AppCheckStatusResult(
        isEnabled: false,
        status: AppCheckStatusType.notInitialized,
        message: 'App Check not initialized: ${e.toString()}',
        recommendation: 'Check Firebase initialization',
      );
    }
  }

  /// Print detailed status information
  Future<void> printStatus() async {
    debugPrint('\n🔍 === APP CHECK STATUS CHECK ===');
    
    final result = await checkStatus();
    
    debugPrint('📊 Status: ${result.status.name}');
    debugPrint('✅ Enabled: ${result.isEnabled}');
    debugPrint('📝 Message: ${result.message}');
    debugPrint('💡 Recommendation: ${result.recommendation}');
    
    // Print configuration details
    debugPrint('\n⚙️ Configuration:');
    debugPrint('   Debug Mode: $kDebugMode');
    debugPrint('   Debug Enabled: ${FirebaseConfig.enableAppCheckInDebug}');
    debugPrint('   Production Enabled: ${FirebaseConfig.enableAppCheckInProduction}');
    debugPrint('   Auto Refresh: ${AppCheckConfig.enableAutoRefresh}');
    debugPrint('   Refresh Interval: ${AppCheckConfig.tokenRefreshInterval.inMinutes} minutes');
    
    debugPrint('🔍 === END APP CHECK STATUS ===\n');
  }
}

/// Result of App Check status check
class AppCheckStatusResult {
  final bool isEnabled;
  final AppCheckStatusType status;
  final String message;
  final String recommendation;

  const AppCheckStatusResult({
    required this.isEnabled,
    required this.status,
    required this.message,
    required this.recommendation,
  });
}

/// Types of App Check status
enum AppCheckStatusType {
  disabledInDebug,
  disabledInProduction,
  working,
  tokenTimeout,
  tooManyAttempts,
  error,
  notInitialized,
}
