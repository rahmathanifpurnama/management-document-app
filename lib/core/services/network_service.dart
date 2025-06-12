import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

/// Service to handle network connectivity and Firebase connection issues
class NetworkService {
  static NetworkService? _instance;
  static NetworkService get instance => _instance ??= NetworkService._();

  NetworkService._();

  /// Check if device has internet connectivity
  Future<bool> hasInternetConnection() async {
    try {
      // Try to connect to Google's DNS server
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint('✅ Internet connection available');
        return true;
      }
    } catch (e) {
      debugPrint('❌ No internet connection: $e');
    }
    return false;
  }

  /// Check if Firebase services are reachable
  Future<bool> canReachFirebase() async {
    try {
      // Test Firebase Storage endpoint
      final storageResult = await InternetAddress.lookup('firebasestorage.googleapis.com')
          .timeout(const Duration(seconds: 10));
      
      if (storageResult.isEmpty) {
        debugPrint('❌ Cannot reach Firebase Storage');
        return false;
      }

      // Test Firebase App Check endpoint
      final appCheckResult = await InternetAddress.lookup('firebaseappcheck.googleapis.com')
          .timeout(const Duration(seconds: 10));
      
      if (appCheckResult.isEmpty) {
        debugPrint('❌ Cannot reach Firebase App Check');
        return false;
      }

      debugPrint('✅ Firebase services are reachable');
      return true;
    } catch (e) {
      debugPrint('❌ Cannot reach Firebase services: $e');
      return false;
    }
  }

  /// Comprehensive network diagnostics
  Future<NetworkDiagnostics> runDiagnostics() async {
    debugPrint('🔍 Running network diagnostics...');
    
    final hasInternet = await hasInternetConnection();
    final canReachFirebase = await this.canReachFirebase();
    
    final diagnostics = NetworkDiagnostics(
      hasInternet: hasInternet,
      canReachFirebase: canReachFirebase,
      timestamp: DateTime.now(),
    );

    debugPrint('📊 Network Diagnostics:');
    debugPrint('   - Internet: ${diagnostics.hasInternet ? "✅" : "❌"}');
    debugPrint('   - Firebase: ${diagnostics.canReachFirebase ? "✅" : "❌"}');
    
    return diagnostics;
  }

  /// Get network troubleshooting suggestions
  List<String> getTroubleshootingSuggestions(NetworkDiagnostics diagnostics) {
    final suggestions = <String>[];

    if (!diagnostics.hasInternet) {
      suggestions.addAll([
        'Periksa koneksi internet Anda',
        'Pastikan WiFi atau data seluler aktif',
        'Coba restart router atau modem',
        'Periksa pengaturan proxy jika menggunakan jaringan perusahaan',
      ]);
    }

    if (diagnostics.hasInternet && !diagnostics.canReachFirebase) {
      suggestions.addAll([
        'Firewall atau proxy mungkin memblokir akses ke Firebase',
        'Periksa pengaturan DNS (coba gunakan 8.8.8.8 atau 1.1.1.1)',
        'Jika menggunakan VPN, coba matikan sementara',
        'Hubungi administrator jaringan jika di lingkungan perusahaan',
      ]);
    }

    return suggestions;
  }
}

/// Network diagnostics result
class NetworkDiagnostics {
  final bool hasInternet;
  final bool canReachFirebase;
  final DateTime timestamp;

  NetworkDiagnostics({
    required this.hasInternet,
    required this.canReachFirebase,
    required this.timestamp,
  });

  bool get isHealthy => hasInternet && canReachFirebase;
  
  String get status {
    if (isHealthy) return 'Healthy';
    if (!hasInternet) return 'No Internet';
    if (!canReachFirebase) return 'Firebase Unreachable';
    return 'Unknown';
  }
}
