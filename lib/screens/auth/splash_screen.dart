import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_routes.dart';
import '../../core/utils/anr_prevention.dart';
import '../../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
        // Auth initialization failed, go to login
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        }
      }
    } catch (e) {
      // Handle any errors by navigating to login
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo
                  SvgPicture.asset(
                    'assets/Logo.svg',
                    width: 380,
                    height: 380,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),

                  // Loading Indicator - Standard CircularProgressIndicator
                  const SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                      strokeWidth: 3.0,
                    ),
                  ),
                ],
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
                      color: AppColors.textWhite,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Powered by Flutter & Firebase',
                    style: TextStyle(
                      color: AppColors.textWhite.withValues(alpha: 0.7),
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
