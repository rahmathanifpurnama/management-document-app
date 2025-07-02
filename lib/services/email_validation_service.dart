import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service for comprehensive email validation and verification
class EmailValidationService {
  static EmailValidationService? _instance;
  static EmailValidationService get instance =>
      _instance ??= EmailValidationService._();

  EmailValidationService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Common email domain providers
  static const List<String> _commonEmailDomains = [
    'gmail.com',
    'yahoo.com',
    'outlook.com',
    'hotmail.com',
    'live.com',
    'msn.com',
    'icloud.com',
    'me.com',
    'mac.com',
    'aol.com',
    'protonmail.com',
    'yandex.com',
    'mail.com',
    'zoho.com',
    'fastmail.com',
    'tutanota.com',
    'gmx.com',
    'web.de',
    'yahoo.co.uk',
    'yahoo.ca',
    'yahoo.com.au',
    'outlook.co.uk',
    'outlook.fr',
    'outlook.de',
    'outlook.com.au',
  ];

  // Indonesian email domains
  static const List<String> _indonesianEmailDomains = [
    'yahoo.co.id',
    'gmail.co.id',
    'telkom.net',
    'indosat.net.id',
    'xl.co.id',
    'tri.co.id',
    'smartfren.com',
  ];

  // Corporate/Educational domains (optional whitelist)
  static const List<String> _corporateEducationalDomains = [
    'ac.id',
    'edu',
    'edu.au',
    'edu.sg',
    'edu.my',
    'co.id',
    'or.id',
    'net.id',
    'web.id',
    'sch.id',
  ];

  /// Validate email format using regex
  bool isValidEmailFormat(String email) {
    if (email.isEmpty) return false;

    // Comprehensive email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
    );

    return emailRegex.hasMatch(email.trim().toLowerCase());
  }

  /// Validate email domain against common providers
  EmailDomainValidationResult validateEmailDomain(String email) {
    if (!isValidEmailFormat(email)) {
      return EmailDomainValidationResult(
        isValid: false,
        domainType: EmailDomainType.invalid,
        message: 'Format email tidak valid',
      );
    }

    final domain = email.split('@').last.toLowerCase();

    // Check against common domains
    if (_commonEmailDomains.contains(domain)) {
      return EmailDomainValidationResult(
        isValid: true,
        domainType: EmailDomainType.common,
        message: 'Email domain valid',
        domain: domain,
      );
    }

    // Check against Indonesian domains
    if (_indonesianEmailDomains.contains(domain)) {
      return EmailDomainValidationResult(
        isValid: true,
        domainType: EmailDomainType.indonesian,
        message: 'Email domain Indonesia valid',
        domain: domain,
      );
    }

    // Check against corporate/educational domains
    if (_corporateEducationalDomains.any(
      (corpDomain) => domain.endsWith(corpDomain),
    )) {
      return EmailDomainValidationResult(
        isValid: true,
        domainType: EmailDomainType.corporate,
        message: 'Email domain korporat/pendidikan valid',
        domain: domain,
      );
    }

    // Unknown domain - might be valid but not in our whitelist
    return EmailDomainValidationResult(
      isValid: false,
      domainType: EmailDomainType.unknown,
      message:
          'Domain email tidak dikenal. Gunakan email dari provider umum seperti Gmail, Yahoo, atau Outlook.',
      domain: domain,
    );
  }

  /// Send email verification to user
  Future<EmailVerificationResult> sendEmailVerification({
    String? customMessage,
  }) async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        return EmailVerificationResult(
          success: false,
          message: 'Pengguna tidak ditemukan. Silakan login terlebih dahulu.',
        );
      }

      if (user.emailVerified) {
        return EmailVerificationResult(
          success: true,
          message: 'Email sudah terverifikasi.',
          isAlreadyVerified: true,
        );
      }

      // Send verification email
      await user.sendEmailVerification();

      debugPrint('✅ Email verification sent to: ${user.email}');

      return EmailVerificationResult(
        success: true,
        message:
            customMessage ??
            'Email verifikasi telah dikirim ke ${user.email}. Silakan periksa inbox dan spam folder Anda.',
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Firebase Auth error sending verification: ${e.code}');

      String message;
      switch (e.code) {
        case 'too-many-requests':
          message =
              'Terlalu banyak permintaan verifikasi. Coba lagi dalam beberapa menit.';
          break;
        case 'user-disabled':
          message = 'Akun telah dinonaktifkan.';
          break;
        case 'network-request-failed':
          message = 'Tidak ada koneksi internet. Periksa koneksi Anda.';
          break;
        default:
          message = 'Gagal mengirim email verifikasi: ${e.message}';
      }

      return EmailVerificationResult(
        success: false,
        message: message,
        errorCode: e.code,
      );
    } catch (e) {
      debugPrint('❌ Unexpected error sending verification: $e');
      return EmailVerificationResult(
        success: false,
        message: 'Terjadi kesalahan tidak terduga: ${e.toString()}',
      );
    }
  }

  /// Check if current user's email is verified
  bool get isCurrentUserEmailVerified {
    final user = _auth.currentUser;
    return user?.emailVerified ?? false;
  }

  /// Reload user and check verification status
  Future<bool> checkEmailVerificationStatus() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      await user.reload();
      final updatedUser = _auth.currentUser;

      return updatedUser?.emailVerified ?? false;
    } catch (e) {
      debugPrint('❌ Error checking email verification status: $e');
      return false;
    }
  }

  /// Get email verification requirements message
  String getEmailVerificationRequirementMessage() {
    return 'Untuk keamanan akun Anda, verifikasi email diperlukan sebelum dapat menggunakan aplikasi. '
        'Email verifikasi telah dikirim ke alamat email Anda.';
  }

  /// Validate email for registration (combines format and domain validation)
  EmailRegistrationValidationResult validateEmailForRegistration(String email) {
    // First check format
    if (!isValidEmailFormat(email)) {
      return EmailRegistrationValidationResult(
        isValid: false,
        message: 'Format email tidak valid',
        requiresVerification: false,
      );
    }

    // Then check domain
    final domainResult = validateEmailDomain(email);

    if (!domainResult.isValid) {
      return EmailRegistrationValidationResult(
        isValid: false,
        message: domainResult.message,
        requiresVerification: false,
        domainType: domainResult.domainType,
      );
    }

    // Email is valid and requires verification
    return EmailRegistrationValidationResult(
      isValid: true,
      message: 'Email valid. Verifikasi email akan dikirim setelah registrasi.',
      requiresVerification: true,
      domainType: domainResult.domainType,
    );
  }
}

/// Result of email domain validation
class EmailDomainValidationResult {
  final bool isValid;
  final EmailDomainType domainType;
  final String message;
  final String? domain;

  EmailDomainValidationResult({
    required this.isValid,
    required this.domainType,
    required this.message,
    this.domain,
  });
}

/// Result of email verification process
class EmailVerificationResult {
  final bool success;
  final String message;
  final bool isAlreadyVerified;
  final String? errorCode;

  EmailVerificationResult({
    required this.success,
    required this.message,
    this.isAlreadyVerified = false,
    this.errorCode,
  });
}

/// Result of email validation for registration
class EmailRegistrationValidationResult {
  final bool isValid;
  final String message;
  final bool requiresVerification;
  final EmailDomainType? domainType;

  EmailRegistrationValidationResult({
    required this.isValid,
    required this.message,
    required this.requiresVerification,
    this.domainType,
  });
}

/// Types of email domains
enum EmailDomainType { invalid, common, indonesian, corporate, unknown }
