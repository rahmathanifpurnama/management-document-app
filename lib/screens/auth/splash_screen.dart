import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_routes.dart';
import '../../core/utils/anr_prevention.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/offline_error_log.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hasError = false;
  String? _errorMessage;
  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();
    // Use post frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Run initialization and minimum splash duration in parallel
      final results = await Future.wait([
        _initializeAuth(authProvider),
        Future.delayed(const Duration(seconds: 2)), // Minimum splash duration
      ], eagerError: false);

      // Check if auth initialization was successful
      final authInitialized = results[0] as bool;

      if (!mounted) return;

      if (authInitialized) {
        // Check if user has valid session for auto-login
        bool hasValidSession = await authProvider.hasValidSession();

        if (mounted) {
          if (hasValidSession && authProvider.isLoggedIn) {
            // User has valid session, go directly to home
            await authProvider.updateSessionActivity();
            if (mounted) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.home);
            }
          } else {
            // No valid session, go to login
            Navigator.of(context).pushReplacementNamed(AppRoutes.login);
          }
        }
      } else {
        // Auth initialization failed - check if it's a network/Firebase issue
        if (mounted) {
          // Always go to login even if Firebase is not available
          // The login screen will handle offline mode appropriately
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        }
      }
    } catch (e) {
      // Handle Firebase/network errors with better UX
      debugPrint('🚨 Splash Screen Error: $e');

      // Log error for offline viewing
      OfflineErrorLogManager.addError('Splash Screen: ${e.toString()}');

      if (mounted) {
        // Check if it's a network error
        final errorString = e.toString().toLowerCase();
        if (errorString.contains('network') ||
            errorString.contains('connection') ||
            errorString.contains('timeout') ||
            errorString.contains('firebase')) {
          setState(() {
            _hasError = true;
            _errorMessage = _getErrorMessage(e.toString());
          });
        } else {
          // For other errors, go to login
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        }
      }
    }
  }

  Future<bool> _initializeAuth(AuthProvider authProvider) async {
    try {
      // Use ANR prevention for auth initialization
      await ANRPrevention.executeWithTimeout(
        authProvider.initializeAuth(),
        timeout: const Duration(seconds: 8),
        operationName: 'Auth Initialization',
      );
      return true;
    } catch (e) {
      debugPrint('Auth initialization failed: $e');
      return false;
    }
  }

  String _getErrorMessage(String error) {
    if (error.toLowerCase().contains('network') ||
        error.toLowerCase().contains('connection')) {
      return 'No internet connection. Please check your network settings.';
    }
    if (error.toLowerCase().contains('firebase')) {
      return 'Unable to connect to services. Please try again.';
    }
    if (error.toLowerCase().contains('timeout')) {
      return 'Connection timed out. Please try again.';
    }
    return 'Something went wrong. Please try again.';
  }

  void _retry() {
    setState(() {
      _hasError = false;
      _errorMessage = null;
      _isRetrying = true;
    });

    // Retry initialization after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isRetrying = false;
        });
        _initializeApp();
      }
    });
  }

  void _showErrorLog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OfflineErrorLog(
        errorLogs: OfflineErrorLogManager.errorLogs,
        onRetry: () {
          Navigator.of(context).pop();
          _retry();
        },
        onClose: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // App Logo
        SvgPicture.asset(
          'assets/Logo.svg',
          width: 200,
          height: 200,
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
        ),

        const SizedBox(height: 30),

        // Loading Indicator
        if (_isRetrying) ...[
          const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeWidth: 3.0,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Retrying...',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ] else ...[
          const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeWidth: 3.0,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Error icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.cloud_off_rounded,
              size: 40,
              color: Colors.red.shade400,
            ),
          ),

          const SizedBox(height: 24),

          // Error title
          const Text(
            'Connection Error',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Error message
          Text(
            _errorMessage ?? 'Unable to connect to services',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Show error log button if there are errors
          if (OfflineErrorLogManager.hasErrors)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              child: OutlinedButton.icon(
                onPressed: _showErrorLog,
                icon: const Icon(Icons.bug_report, size: 18),
                label: const Text('View Error Log'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: Colors.orange.shade400),
                  foregroundColor: Colors.orange.shade600,
                ),
              ),
            ),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppColors.primary),
                    foregroundColor: AppColors.primary,
                  ),
                  child: const Text('Skip'),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: ElevatedButton(
                  onPressed: _retry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Retry'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F5F5,
      ), // Match native splash background
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: _hasError ? _buildErrorState() : _buildLoadingState(),
              ),
            ),

            // Version Info
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  const Text(
                    'Version ${AppStrings.version}',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Powered by Flutter & Firebase',
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
