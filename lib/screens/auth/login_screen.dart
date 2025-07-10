import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_routes.dart';
import '../../features/auth/providers/auth_providers.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/loading_widget.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadRememberedEmail();
  }

  Future<void> _loadRememberedEmail() async {
    // TODO: Implement remember me functionality with SharedPreferences
    // For now, skip this functionality during migration
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Show progress indicator immediately
      if (mounted) {
        setState(() {});
      }

      // Use the underlying AuthService for login
      final authService = ref.read(authServiceProvider);
      final user = await authService.login(
        _emailController.text.trim(),
        _passwordController.text,
        rememberMe: _rememberMe,
      );

      if (user != null && mounted) {
        // Login successful
        Fluttertoast.showToast(
          msg: AppStrings.loginSuccess,
          backgroundColor: AppColors.success,
          textColor: AppColors.textWhite,
          toastLength: Toast.LENGTH_SHORT,
        );
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      } else if (mounted) {
        Fluttertoast.showToast(
          msg: 'Login gagal. Silakan periksa email dan password Anda.',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            final authState = ref.watch(authStateProvider);
            final isLoading = authState.isLoading;

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 60),

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

                            // Use basic email validation for now
                            if (!value.contains('@')) {
                              return 'Format email tidak valid';
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
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Login Button
                        CustomButton(
                          text: AppStrings.login,
                          onPressed: _login,
                          isLoading: isLoading,
                        ),

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
                      ],
                    ),
                  ),
                ),

                // Loading Overlay
                if (isLoading) const LoadingWidget(),
              ],
            );
          },
        ),
      ),
    );
  }
}
