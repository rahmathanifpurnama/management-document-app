import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_strings.dart';

/// Comprehensive error handler for hybrid authentication scenarios
/// Provides user-friendly error messages and recovery suggestions
class HybridAuthErrorHandler {
  /// Handle authentication errors and return user-friendly messages
  static String handleAuthError(dynamic error) {
    if (error == null) return 'Terjadi kesalahan tidak diketahui';

    final errorString = error.toString().toLowerCase();
    
    // Firebase Auth specific errors
    if (error is FirebaseAuthException) {
      return _handleFirebaseAuthError(error);
    }
    
    // Network and connectivity errors
    if (_isNetworkError(errorString)) {
      return _handleNetworkError(errorString);
    }
    
    // Offline authentication errors
    if (_isOfflineAuthError(errorString)) {
      return _handleOfflineAuthError(errorString);
    }
    
    // Biometric authentication errors
    if (_isBiometricError(errorString)) {
      return _handleBiometricError(errorString);
    }
    
    // Session and token errors
    if (_isSessionError(errorString)) {
      return _handleSessionError(errorString);
    }
    
    // Security and validation errors
    if (_isSecurityError(errorString)) {
      return _handleSecurityError(errorString);
    }
    
    // Storage errors
    if (_isStorageError(errorString)) {
      return _handleStorageError(errorString);
    }
    
    // Default error handling
    return _handleGenericError(errorString);
  }

  /// Handle Firebase Authentication specific errors
  static String _handleFirebaseAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
        return 'Email tidak terdaftar. Silakan periksa email Anda atau hubungi administrator.';
      case 'wrong-password':
        return 'Password salah. Silakan periksa password Anda.';
      case 'invalid-email':
        return 'Format email tidak valid. Silakan masukkan email yang benar.';
      case 'user-disabled':
        return 'Akun Anda telah dinonaktifkan. Hubungi administrator untuk mengaktifkan kembali.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan login. Silakan tunggu beberapa saat sebelum mencoba lagi.';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah. Periksa koneksi Anda atau coba mode offline.';
      case 'invalid-credential':
        return 'Kredensial tidak valid. Silakan periksa email dan password Anda.';
      case 'account-exists-with-different-credential':
        return 'Akun sudah ada dengan metode login yang berbeda.';
      case 'requires-recent-login':
        return 'Operasi ini memerlukan login ulang untuk keamanan.';
      case 'weak-password':
        return 'Password terlalu lemah. Gunakan kombinasi huruf, angka, dan simbol.';
      case 'email-already-in-use':
        return 'Email sudah digunakan oleh akun lain.';
      default:
        return 'Gagal melakukan autentikasi Firebase: ${error.message ?? error.code}';
    }
  }

  /// Check if error is network-related
  static bool _isNetworkError(String errorString) {
    return errorString.contains('network') ||
           errorString.contains('connection') ||
           errorString.contains('timeout') ||
           errorString.contains('internet') ||
           errorString.contains('connectivity') ||
           errorString.contains('dns') ||
           errorString.contains('socket');
  }

  /// Handle network-related errors
  static String _handleNetworkError(String errorString) {
    if (errorString.contains('timeout')) {
      return 'Koneksi timeout. Periksa koneksi internet Anda dan coba lagi.';
    }
    if (errorString.contains('dns')) {
      return 'Gagal menghubungi server. Periksa koneksi internet atau coba lagi nanti.';
    }
    if (errorString.contains('socket')) {
      return 'Koneksi terputus. Silakan periksa koneksi internet Anda.';
    }
    return 'Masalah koneksi internet. Anda dapat mencoba login offline jika tersedia.';
  }

  /// Check if error is offline authentication related
  static bool _isOfflineAuthError(String errorString) {
    return errorString.contains('offline') ||
           errorString.contains('credential') ||
           errorString.contains('stored') ||
           errorString.contains('local');
  }

  /// Handle offline authentication errors
  static String _handleOfflineAuthError(String errorString) {
    if (errorString.contains('no offline credentials') || 
        errorString.contains('tidak ada kredensial offline')) {
      return 'Belum ada kredensial offline tersimpan. Silakan login online terlebih dahulu dengan mengaktifkan "Ingat Saya".';
    }
    if (errorString.contains('invalid credentials') || 
        errorString.contains('kredensial tidak valid')) {
      return 'Kredensial offline tidak valid. Silakan login online untuk memperbarui kredensial.';
    }
    if (errorString.contains('expired')) {
      return 'Sesi offline telah kedaluwarsa. Silakan login online untuk memperbarui sesi.';
    }
    return 'Gagal melakukan autentikasi offline. Silakan coba login online.';
  }

  /// Check if error is biometric authentication related
  static bool _isBiometricError(String errorString) {
    return errorString.contains('biometric') ||
           errorString.contains('fingerprint') ||
           errorString.contains('face') ||
           errorString.contains('touch') ||
           errorString.contains('local_auth');
  }

  /// Handle biometric authentication errors
  static String _handleBiometricError(String errorString) {
    if (errorString.contains('not available') || 
        errorString.contains('tidak tersedia')) {
      return 'Autentikasi biometrik tidak tersedia di perangkat ini.';
    }
    if (errorString.contains('not enrolled') || 
        errorString.contains('tidak terdaftar')) {
      return 'Belum ada biometrik yang terdaftar. Silakan daftarkan sidik jari atau wajah di pengaturan perangkat.';
    }
    if (errorString.contains('locked out') || 
        errorString.contains('terkunci')) {
      return 'Autentikasi biometrik terkunci karena terlalu banyak percobaan gagal.';
    }
    if (errorString.contains('cancelled') || 
        errorString.contains('dibatalkan')) {
      return 'Autentikasi biometrik dibatalkan oleh pengguna.';
    }
    return 'Gagal melakukan autentikasi biometrik. Silakan coba lagi atau gunakan password.';
  }

  /// Check if error is session related
  static bool _isSessionError(String errorString) {
    return errorString.contains('session') ||
           errorString.contains('token') ||
           errorString.contains('expired') ||
           errorString.contains('invalid');
  }

  /// Handle session-related errors
  static String _handleSessionError(String errorString) {
    if (errorString.contains('expired') || 
        errorString.contains('kedaluwarsa')) {
      return 'Sesi telah kedaluwarsa. Silakan login ulang.';
    }
    if (errorString.contains('invalid token') || 
        errorString.contains('token tidak valid')) {
      return 'Token autentikasi tidak valid. Silakan login ulang.';
    }
    return 'Masalah dengan sesi autentikasi. Silakan login ulang.';
  }

  /// Check if error is security related
  static bool _isSecurityError(String errorString) {
    return errorString.contains('security') ||
           errorString.contains('permission') ||
           errorString.contains('unauthorized') ||
           errorString.contains('forbidden') ||
           errorString.contains('locked');
  }

  /// Handle security-related errors
  static String _handleSecurityError(String errorString) {
    if (errorString.contains('locked') || 
        errorString.contains('terkunci')) {
      return 'Akun terkunci sementara karena terlalu banyak percobaan login gagal. Silakan tunggu 15 menit.';
    }
    if (errorString.contains('unauthorized') || 
        errorString.contains('tidak diotorisasi')) {
      return 'Anda tidak memiliki izin untuk mengakses aplikasi ini.';
    }
    if (errorString.contains('permission')) {
      return 'Izin akses ditolak. Hubungi administrator untuk mendapatkan akses.';
    }
    return 'Masalah keamanan terdeteksi. Silakan hubungi administrator.';
  }

  /// Check if error is storage related
  static bool _isStorageError(String errorString) {
    return errorString.contains('storage') ||
           errorString.contains('secure') ||
           errorString.contains('keychain') ||
           errorString.contains('preferences');
  }

  /// Handle storage-related errors
  static String _handleStorageError(String errorString) {
    if (errorString.contains('secure storage') || 
        errorString.contains('penyimpanan aman')) {
      return 'Gagal mengakses penyimpanan aman. Silakan restart aplikasi.';
    }
    if (errorString.contains('keychain')) {
      return 'Masalah dengan keychain perangkat. Silakan periksa pengaturan keamanan perangkat.';
    }
    return 'Masalah penyimpanan data. Silakan restart aplikasi atau hubungi dukungan teknis.';
  }

  /// Handle generic errors
  static String _handleGenericError(String errorString) {
    if (errorString.contains('null')) {
      return 'Data tidak lengkap. Silakan coba lagi.';
    }
    if (errorString.contains('format')) {
      return 'Format data tidak valid. Silakan periksa input Anda.';
    }
    if (errorString.contains('parse') || errorString.contains('parsing')) {
      return 'Gagal memproses data. Silakan coba lagi.';
    }
    
    // Return a generic user-friendly message
    return 'Terjadi kesalahan tidak terduga. Silakan coba lagi atau hubungi dukungan teknis jika masalah berlanjut.';
  }

  /// Get recovery suggestions based on error type
  static List<String> getRecoverySuggestions(dynamic error) {
    final errorString = error.toString().toLowerCase();
    final suggestions = <String>[];

    if (_isNetworkError(errorString)) {
      suggestions.addAll([
        'Periksa koneksi internet Anda',
        'Coba gunakan WiFi atau data seluler yang berbeda',
        'Restart router atau modem',
        'Gunakan mode offline jika tersedia',
      ]);
    }

    if (_isOfflineAuthError(errorString)) {
      suggestions.addAll([
        'Login online terlebih dahulu dengan "Ingat Saya" diaktifkan',
        'Pastikan kredensial tersimpan dengan benar',
        'Hapus data aplikasi dan login ulang jika perlu',
      ]);
    }

    if (_isBiometricError(errorString)) {
      suggestions.addAll([
        'Pastikan sidik jari atau wajah sudah terdaftar di perangkat',
        'Bersihkan sensor biometrik',
        'Restart aplikasi dan coba lagi',
        'Gunakan password sebagai alternatif',
      ]);
    }

    if (_isSessionError(errorString)) {
      suggestions.addAll([
        'Login ulang untuk memperbarui sesi',
        'Periksa waktu dan tanggal perangkat',
        'Hapus cache aplikasi jika perlu',
      ]);
    }

    if (suggestions.isEmpty) {
      suggestions.addAll([
        'Restart aplikasi',
        'Periksa koneksi internet',
        'Update aplikasi ke versi terbaru',
        'Hubungi dukungan teknis jika masalah berlanjut',
      ]);
    }

    return suggestions;
  }

  /// Check if error is recoverable (user can retry)
  static bool isRecoverableError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    // Non-recoverable errors
    if (errorString.contains('user-disabled') ||
        errorString.contains('account-exists-with-different-credential') ||
        errorString.contains('permanently locked')) {
      return false;
    }
    
    // Most errors are recoverable
    return true;
  }

  /// Get error severity level
  static ErrorSeverity getErrorSeverity(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('security') ||
        errorString.contains('unauthorized') ||
        errorString.contains('permanently locked')) {
      return ErrorSeverity.critical;
    }
    
    if (errorString.contains('network') ||
        errorString.contains('timeout') ||
        errorString.contains('offline')) {
      return ErrorSeverity.warning;
    }
    
    return ErrorSeverity.error;
  }
}

/// Error severity levels
enum ErrorSeverity {
  info,
  warning,
  error,
  critical,
}
