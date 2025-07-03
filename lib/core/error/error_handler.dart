import 'package:flutter/material.dart';
import '../services/network_service.dart';
import '../../widgets/common/error_widgets.dart';

/// Global error handler for the application
class AppErrorHandler {
  static AppErrorHandler? _instance;
  static AppErrorHandler get instance => _instance ??= AppErrorHandler._();

  AppErrorHandler._();

  /// Handle Firebase initialization errors
  static Widget handleFirebaseError(dynamic error, VoidCallback? onRetry) {
    final errorString = error.toString();

    debugPrint('🚨 Firebase Error: $errorString');

    // Check if it's a network-related error
    if (_isNetworkError(errorString)) {
      return FutureBuilder<NetworkDiagnostics>(
        future: NetworkService.instance.runDiagnostics(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ErrorWidgets.networkError(
              diagnostics: snapshot.data!,
              onRetry: onRetry,
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      );
    }

    // Handle specific Firebase errors
    if (_isFirebaseInitError(errorString)) {
      return ErrorWidgets.firebaseInitError(
        error: _getCleanErrorMessage(errorString),
        onRetry: onRetry,
      );
    }

    // Generic error fallback
    return ErrorWidgets.genericError(
      title: 'Application Error',
      message: _getCleanErrorMessage(errorString),
      onRetry: onRetry,
    );
  }

  /// Handle provider errors with better UX
  static Widget handleProviderError(dynamic error, VoidCallback? onRetry) {
    final errorString = error.toString();

    debugPrint('🚨 Provider Error: $errorString');

    if (_isNetworkError(errorString)) {
      return FutureBuilder<NetworkDiagnostics>(
        future: NetworkService.instance.runDiagnostics(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ErrorWidgets.networkError(
              diagnostics: snapshot.data!,
              onRetry: onRetry,
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      );
    }

    return ErrorWidgets.genericError(
      title: 'Service Error',
      message: _getCleanErrorMessage(errorString),
      icon: Icons.cloud_off,
      onRetry: onRetry,
    );
  }

  /// Show error snackbar with better design
  static void showErrorSnackBar(
    BuildContext context, {
    required String message,
    String? action,
    VoidCallback? onAction,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: duration ?? const Duration(seconds: 4),
        action: action != null && onAction != null
            ? SnackBarAction(
                label: action,
                textColor: Colors.white,
                onPressed: onAction,
              )
            : null,
      ),
    );
  }

  /// Show success snackbar
  static void showSuccessSnackBar(
    BuildContext context, {
    required String message,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }

  /// Show warning snackbar
  static void showWarningSnackBar(
    BuildContext context, {
    required String message,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.warning_outlined, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }

  /// Check if error is network-related
  static bool _isNetworkError(String error) {
    final networkKeywords = [
      'network',
      'connection',
      'timeout',
      'unreachable',
      'dns',
      'socket',
      'internet',
      'offline',
    ];

    final lowerError = error.toLowerCase();
    return networkKeywords.any((keyword) => lowerError.contains(keyword));
  }

  /// Check if error is Firebase initialization error
  static bool _isFirebaseInitError(String error) {
    final firebaseKeywords = [
      'firebase',
      'firebaseexception',
      'no firebase app',
      'firebase app',
      'firebase core',
      'firebase_core',
    ];

    final lowerError = error.toLowerCase();
    return firebaseKeywords.any((keyword) => lowerError.contains(keyword));
  }

  /// Clean up error message for user display
  static String _getCleanErrorMessage(String error) {
    // Remove technical stack traces and make user-friendly
    if (error.contains('No Firebase App')) {
      return 'Firebase services are not properly initialized. Please restart the app.';
    }

    if (error.contains('network') || error.contains('connection')) {
      return 'Network connection error. Please check your internet connection.';
    }

    if (error.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }

    if (error.contains('permission')) {
      return 'Access denied. Please check your permissions.';
    }

    // Return first line of error if it's not too technical
    final lines = error.split('\n');
    if (lines.isNotEmpty && lines.first.length < 100) {
      return lines.first;
    }

    return 'An unexpected error occurred. Please try again.';
  }
}
