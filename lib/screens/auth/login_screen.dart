import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_routes.dart';
import '../../features/auth/providers/auth_providers.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/loading_widget.dart';
import '../../services/email_validation_service.dart';

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
  String? _emailValidationMessage;

  @override
  void initState() {
    super.initState();
    _loadRememberedEmail();
  }

  Future<void> _loadRememberedEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('remembered_email');
      final rememberMe = prefs.getBool('remember_me') ?? false;

      if (rememberMe && savedEmail != null && savedEmail.isNotEmpty) {
        _emailController.text = savedEmail;
        setState(() {
          _rememberMe = true;
        });
      }
    } catch (e) {
      debugPrint('Error loading remembered email: $e');
    }
  }

  Future<void> _saveRememberedEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_rememberMe) {
        await prefs.setString('remembered_email', _emailController.text.trim());
        await prefs.setBool('remember_me', true);
      } else {
        await prefs.remove('remembered_email');
        await prefs.setBool('remember_me', false);
      }
    } catch (e) {
      debugPrint('Error saving remembered email: $e');
    }
  }

  void _validateEmailRealTime(String email) {
    if (email.isEmpty) {
      setState(() {
        _emailValidationMessage = null;
      });
      return;
    }

    final emailService = EmailValidationService.instance;

    // Check basic email format
    if (!emailService.isValidEmailFormat(email)) {
      setState(() {
        _emailValidationMessage = 'Format email tidak valid';
      });
      return;
    }

    // Check domain validation
    final domainValidation = emailService.validateEmailDomain(email);
    if (!domainValidation.isValid) {
      setState(() {
        _emailValidationMessage = domainValidation.message;
      });
      return;
    }

    // Clear validation message if email is valid
    setState(() {
      _emailValidationMessage = null;
    });
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Lupa Password',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Untuk reset password, silakan hubungi admin melalui email:',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              SizedBox(height: 12),
              SelectableText(
                'web.hanif61@gmail.com',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Waktu tunggu respons: 1-2 hari kerja',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textHint,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Tutup',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
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

      // Save remembered email before attempting login
      await _saveRememberedEmail();

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
          msg: 'Email atau password tidak valid atau salah, coba lagi',
          backgroundColor: AppColors.error,
          textColor: AppColors.textWhite,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      // Handle specific authentication errors
      if (mounted) {
        String errorMessage =
            'Terjadi kesalahan tidak terduga. Silakan coba lagi.';

        // Check for specific Firebase auth errors
        final errorString = e.toString().toLowerCase();
        if (errorString.contains('user-not-found') ||
            errorString.contains('wrong-password') ||
            errorString.contains('invalid-credential') ||
            errorString.contains('invalid-email')) {
          errorMessage =
              'Email atau password tidak valid atau salah, coba lagi';
        } else if (errorString.contains('too-many-requests')) {
          errorMessage = 'Terlalu banyak percobaan. Silakan coba lagi nanti.';
        } else if (errorString.contains('network')) {
          errorMessage =
              'Koneksi internet bermasalah. Silakan periksa koneksi Anda.';
        }

        Fluttertoast.showToast(
          msg: errorMessage,
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

                        // Email Field with real-time validation
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              controller: _emailController,
                              label: AppStrings.email,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email_outlined,
                              onChanged: _validateEmailRealTime,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppStrings.fieldRequired;
                                }

                                // Use comprehensive email validation
                                final emailService =
                                    EmailValidationService.instance;
                                if (!emailService.isValidEmailFormat(value)) {
                                  return 'Format email tidak valid';
                                }

                                final domainValidation = emailService
                                    .validateEmailDomain(value);
                                if (!domainValidation.isValid) {
                                  return domainValidation.message;
                                }

                                return null;
                              },
                            ),
                            // Real-time validation message
                            if (_emailValidationMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4, left: 4),
                                child: Text(
                                  _emailValidationMessage!,
                                  style: const TextStyle(
                                    color: AppColors.error,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
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

                        // Forgot Password - styled as clickable text link
                        GestureDetector(
                          onTap: _showForgotPasswordDialog,
                          child: const Text(
                            AppStrings.forgotPassword,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.primary,
                            ),
                            textAlign: TextAlign.center,
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
