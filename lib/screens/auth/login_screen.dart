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
import '../../core/services/firebase_service.dart';

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

  // Email validation states
  bool _isValidatingEmail = false;
  bool?
  _emailExistsInFirestore; // null = not checked, true = exists, false = doesn't exist

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

  void _validateEmailRealTime(String email) async {
    if (email.isEmpty) {
      setState(() {
        _emailExistsInFirestore = null;
        _isValidatingEmail = false;
      });
      return;
    }

    final emailService = EmailValidationService.instance;

    // Check basic email format first
    if (!emailService.isValidEmailFormat(email)) {
      setState(() {
        _emailExistsInFirestore = false;
        _isValidatingEmail = false;
      });
      return;
    }

    // Start validation process
    setState(() {
      _isValidatingEmail = true;
    });

    try {
      // Check if email exists in Firestore users collection
      final firebaseService = FirebaseService.instance;
      final snapshot = await firebaseService.usersCollection
          .where('email', isEqualTo: email.toLowerCase())
          .limit(1)
          .get();

      if (mounted) {
        setState(() {
          _emailExistsInFirestore = snapshot.docs.isNotEmpty;
          _isValidatingEmail = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _emailExistsInFirestore = false;
          _isValidatingEmail = false;
        });
      }
    }
  }

  // Get email validation icon based on current state
  Widget? _getEmailValidationIcon() {
    if (_isValidatingEmail) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    if (_emailExistsInFirestore == true) {
      return const Icon(Icons.check_circle, color: AppColors.success, size: 20);
    }

    if (_emailExistsInFirestore == false && _emailController.text.isNotEmpty) {
      return const Icon(Icons.cancel, color: AppColors.error, size: 20);
    }

    return null;
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
              decoration: TextDecoration.none,
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
      // Handle authentication errors - use the message from auth service
      if (mounted) {
        String errorMessage = e.toString();

        // Remove "Exception: " prefix if present
        if (errorMessage.startsWith('Exception: ')) {
          errorMessage = errorMessage.substring(11);
        }

        // If it's still a generic error, provide a fallback
        if (errorMessage.contains('Terjadi kesalahan:') ||
            errorMessage.toLowerCase().contains('unexpected')) {
          errorMessage =
              'Email atau password tidak valid atau salah, coba lagi';
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
                              'assets/simdoc_bapeltan.svg',
                              width: 280,
                              height: 280,
                            ),
                          ],
                        ),

                        // Email Field with visual validation feedback
                        CustomTextField(
                          controller: _emailController,
                          label: AppStrings.email,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          suffixIcon: _getEmailValidationIcon(),
                          onChanged: _validateEmailRealTime,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppStrings.fieldRequired;
                            }

                            // Only check basic email format
                            final emailService =
                                EmailValidationService.instance;
                            if (!emailService.isValidEmailFormat(value)) {
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
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              AppStrings.rememberMe,
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Login Button
                        CustomButton(
                          text: AppStrings.login,
                          onPressed: _login,
                          isLoading: isLoading,
                        ),

                        const SizedBox(height: 20),

                        // Forgot Password - styled as clickable text link
                        GestureDetector(
                          onTap: _showForgotPasswordDialog,
                          child: const Text(
                            AppStrings.forgotPassword,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              decoration: TextDecoration.none,
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
