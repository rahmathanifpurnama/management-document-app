import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/network_status_widget.dart';
import '../../models/offline_auth_models.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _showBiometricOption = false;

  @override
  void initState() {
    super.initState();
    _loadRememberedEmail();
    _checkBiometricAvailability();
  }

  Future<void> _loadRememberedEmail() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final rememberedEmail = await authProvider.getRememberedEmail();
    final isRememberMeEnabled = await authProvider.isRememberMeEnabled();

    if (rememberedEmail != null) {
      _emailController.text = rememberedEmail;
      _rememberMe = isRememberMeEnabled;
      setState(() {});
    }
  }

  Future<void> _checkBiometricAvailability() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final biometricEnabled = authProvider.biometricEnabled;
    final isLoggedIn = authProvider.isLoggedIn;

    if (biometricEnabled && isLoggedIn) {
      setState(() {
        _showBiometricOption = true;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      // Show progress indicator immediately
      if (mounted) {
        setState(() {});
      }

      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
        rememberMe: _rememberMe,
      );

      if (success && mounted) {
        Fluttertoast.showToast(
          msg: AppStrings.loginSuccess,
          backgroundColor: AppColors.success,
          textColor: AppColors.textWhite,
          toastLength: Toast.LENGTH_SHORT,
        );
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      } else if (authProvider.errorMessage != null && mounted) {
        Fluttertoast.showToast(
          msg: authProvider.errorMessage!,
          backgroundColor: AppColors.error,
          textColor: AppColors.textWhite,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      // Handle any unexpected errors
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Terjadi kesalahan tidak terduga. Silakan coba lagi.',
          backgroundColor: AppColors.error,
          textColor: AppColors.textWhite,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    }
  }

  Future<void> _loginWithBiometric() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      final success = await authProvider.loginWithBiometric();

      if (success && mounted) {
        Fluttertoast.showToast(
          msg: 'Login biometrik berhasil',
          backgroundColor: AppColors.success,
          textColor: AppColors.textWhite,
          toastLength: Toast.LENGTH_SHORT,
        );
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      } else if (authProvider.errorMessage != null && mounted) {
        Fluttertoast.showToast(
          msg: authProvider.errorMessage!,
          backgroundColor: AppColors.error,
          textColor: AppColors.textWhite,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Gagal melakukan login biometrik: ${e.toString()}',
          backgroundColor: AppColors.error,
          textColor: AppColors.textWhite,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return Stack(
              children: [
                Column(
                  children: [
                    // Network status banner
                    const NetworkStatusBanner(),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 20),

                              // Network status indicator
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [NetworkStatusWidget(compact: true)],
                              ),

                              const SizedBox(height: 40),

                              // Logo and Title
                              Column(
                                children: [
                                  SvgPicture.asset(
                                    'assets/Logo.svg',
                                    width: 280,
                                    height: 280,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.primary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ],
                              ),

                              // Email Field
                              CustomTextField(
                                controller: _emailController,
                                label: AppStrings.email,
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: Icons.email_outlined,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.fieldRequired;
                                  }
                                  if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                  ).hasMatch(value)) {
                                    return AppStrings.invalidEmail;
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // Password Field
                              CustomTextField(
                                controller: _passwordController,
                                label: AppStrings.password,
                                obscureText: _obscurePassword,
                                prefixIcon: Icons.lock_outlined,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: AppColors.textSecondary,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.fieldRequired;
                                  }
                                  if (value.length < 6) {
                                    return AppStrings.passwordTooShort;
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // Remember Me Checkbox
                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value ?? false;
                                      });
                                    },
                                    activeColor: AppColors.primary,
                                  ),
                                  const Text(
                                    AppStrings.rememberMe,
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 30),

                              // Login Button
                              CustomButton(
                                text: AppStrings.login,
                                onPressed: _login,
                                isLoading: authProvider.isLoading,
                              ),

                              // Biometric Login Button (if available)
                              if (_showBiometricOption &&
                                  authProvider.biometricEnabled) ...[
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: authProvider.isLoading
                                      ? null
                                      : _loginWithBiometric,
                                  icon: const Icon(Icons.fingerprint),
                                  label: const Text('Login dengan Biometrik'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary
                                        .withOpacity(0.1),
                                    foregroundColor: AppColors.primary,
                                    elevation: 0,
                                    side: const BorderSide(
                                      color: AppColors.primary,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                              ],

                              const SizedBox(height: 10),

                              // Forgot Password
                              TextButton(
                                onPressed: () {
                                  // TODO: Implement forgot password
                                },
                                child: const Text(
                                  AppStrings.forgotPassword,
                                  style: TextStyle(color: AppColors.primary),
                                ),
                              ),

                              // Offline mode info
                              if (authProvider.isOffline) ...[
                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.warning.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColors.warning,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: AppColors.warning,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Mode offline aktif. Anda dapat login menggunakan kredensial yang tersimpan.',
                                          style: TextStyle(
                                            color: AppColors.warning,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Loading Overlay
                if (authProvider.isLoading) const LoadingWidget(),
              ],
            );
          },
        ),
      ),
    );
  }
}
