import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/auth_service.dart';
import '../../../services/enhanced_auth_service.dart';
import '../../../services/activity_service.dart';
import '../../../models/user_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// BLoC for managing complex authentication operations
/// Handles login, registration, password reset, profile updates, and other auth operations
/// Works in conjunction with Riverpod providers for simple state management
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService = AuthService.instance;
  final EnhancedAuthService _enhancedAuthService = EnhancedAuthService.instance;
  final ActivityService _activityService = ActivityService();

  // Store last failed operation for retry
  AuthEvent? _lastFailedOperation;

  // Stream subscription for auth state changes
  StreamSubscription<User?>? _authStateSubscription;

  AuthBloc() : super(const AuthState.initial()) {
    // Register event handlers
    on<Initialize>(_onInitialize);
    on<Login>(_onLogin);
    on<Logout>(_onLogout);
    on<Register>(_onRegister);
    on<ResetPassword>(_onResetPassword);
    on<UpdateProfile>(_onUpdateProfile);
    on<ChangePassword>(_onChangePassword);
    on<SendEmailVerification>(_onSendEmailVerification);
    on<RefreshUserData>(_onRefreshUserData);
    on<UpdateUserPermissions>(_onUpdateUserPermissions);
    on<RefreshPermissions>(_onRefreshPermissions);
    on<VerifyEmail>(_onVerifyEmail);
    on<ConfirmPasswordReset>(_onConfirmPasswordReset);
    on<Reauthenticate>(_onReauthenticate);
    on<DeleteAccount>(_onDeleteAccount);
    on<LinkAccount>(_onLinkAccount);
    on<UnlinkAccount>(_onUnlinkAccount);
    on<UpdateEmail>(_onUpdateEmail);
    on<ClearError>(_onClearError);
    on<RetryLastOperation>(_onRetryLastOperation);
    on<AuthStateChanged>(_onAuthStateChanged);
  }

  /// Initialize auth state and setup listeners
  Future<void> _onInitialize(Initialize event, Emitter<AuthState> emit) async {
    try {
      debugPrint('🔄 AuthBloc: Initializing...');

      // Setup auth state listener
      _setupAuthStateListener();

      // Check current auth state
      final currentUser = _authService.currentUser;
      if (currentUser != null) {
        // User is already logged in, load user data
        final userData = await _authService.getCurrentUserData();
        if (userData != null) {
          emit(
            AuthState.authenticated(
              user: userData,
              isEmailVerified: currentUser.emailVerified,
            ),
          );
        } else {
          emit(const AuthState.unauthenticated());
        }
      } else {
        emit(const AuthState.unauthenticated());
      }

      debugPrint('✅ AuthBloc: Initialization complete');
    } catch (e) {
      debugPrint('❌ AuthBloc: Initialization failed - $e');
      emit(
        AuthState.error(
          message: 'Failed to initialize authentication: $e',
          canRetry: true,
          lastFailedOperation: 'initialize',
        ),
      );
    }
  }

  /// Handle login with email and password
  Future<void> _onLogin(Login event, Emitter<AuthState> emit) async {
    try {
      debugPrint('🔄 AuthBloc: Logging in user: ${event.email}');

      emit(const AuthState.loading(operationType: 'login'));

      // Perform login with timeout
      final user = await _authService
          .login(event.email, event.password, rememberMe: event.rememberMe)
          .timeout(const Duration(seconds: 15));

      if (user != null) {
        // Log activity
        await _activityService.logActivity(
          type: 'login',
          description: 'User logged in successfully',
          additionalData: {
            'email': event.email,
            'rememberMe': event.rememberMe,
          },
        );

        emit(
          AuthState.authenticated(
            user: user,
            isEmailVerified: _authService.currentUser?.emailVerified ?? false,
          ),
        );

        debugPrint('✅ AuthBloc: Login successful for: ${event.email}');
      } else {
        throw Exception('Login failed: No user data returned');
      }
    } catch (e) {
      debugPrint('❌ AuthBloc: Login failed - $e');
      _lastFailedOperation = event;
      emit(
        AuthState.error(
          message: _getErrorMessage(e),
          canRetry: true,
          lastFailedOperation: 'login',
        ),
      );
    }
  }

  /// Handle logout
  Future<void> _onLogout(Logout event, Emitter<AuthState> emit) async {
    try {
      debugPrint('🔄 AuthBloc: Logging out user...');

      final currentUser = state.currentUser;

      emit(const AuthState.loading(operationType: 'logout'));

      // Log activity before logout
      if (currentUser != null) {
        await _activityService.logActivity(
          type: 'logout',
          description: 'User logged out successfully',
          additionalData: {'email': currentUser.email},
        );
      }

      await _authService.logout().timeout(const Duration(seconds: 10));

      emit(const AuthState.unauthenticated());

      debugPrint('✅ AuthBloc: Logout successful');
    } catch (e) {
      debugPrint('❌ AuthBloc: Logout failed - $e');
      _lastFailedOperation = event;
      emit(
        AuthState.error(
          message: _getErrorMessage(e),
          canRetry: true,
          lastFailedOperation: 'logout',
          user: state.currentUser,
        ),
      );
    }
  }

  /// Handle user registration
  Future<void> _onRegister(Register event, Emitter<AuthState> emit) async {
    try {
      debugPrint('🔄 AuthBloc: Registering user: ${event.email}');

      emit(const AuthState.registering());

      // TODO: Implement user registration method in AuthService
      throw UnimplementedError('User registration not implemented yet');
    } catch (e) {
      debugPrint('❌ AuthBloc: Registration failed - $e');
      _lastFailedOperation = event;
      emit(
        AuthState.error(
          message: _getErrorMessage(e),
          canRetry: true,
          lastFailedOperation: 'register',
        ),
      );
    }
  }

  /// Handle password reset
  Future<void> _onResetPassword(
    ResetPassword event,
    Emitter<AuthState> emit,
  ) async {
    try {
      debugPrint(
        '🔄 AuthBloc: Sending password reset email to: ${event.email}',
      );

      emit(const AuthState.loading(operationType: 'resetPassword'));

      await _authService
          .resetPassword(event.email)
          .timeout(const Duration(seconds: 10));

      emit(AuthState.passwordResetSent(email: event.email));

      debugPrint('✅ AuthBloc: Password reset email sent to: ${event.email}');
    } catch (e) {
      debugPrint('❌ AuthBloc: Password reset failed - $e');
      _lastFailedOperation = event;
      emit(
        AuthState.error(
          message: _getErrorMessage(e),
          canRetry: true,
          lastFailedOperation: 'resetPassword',
        ),
      );
    }
  }

  /// Handle profile update
  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final currentUser = state.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      debugPrint('🔄 AuthBloc: Updating profile for: ${currentUser.email}');

      emit(AuthState.updatingProfile(user: currentUser));

      // TODO: Implement profile update method in AuthService
      throw UnimplementedError('Profile update not implemented yet');
    } catch (e) {
      debugPrint('❌ AuthBloc: Profile update failed - $e');
      _lastFailedOperation = event;
      emit(
        AuthState.error(
          message: _getErrorMessage(e),
          canRetry: true,
          lastFailedOperation: 'updateProfile',
          user: state.currentUser,
        ),
      );
    }
  }

  /// Handle password change
  Future<void> _onChangePassword(
    ChangePassword event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final currentUser = state.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      debugPrint('🔄 AuthBloc: Changing password for: ${currentUser.email}');

      emit(AuthState.changingPassword(user: currentUser));

      await _authService
          .changePassword(event.currentPassword, event.newPassword)
          .timeout(const Duration(seconds: 15));

      // Log activity
      await _activityService.logActivity(
        type: 'password_change',
        description: 'User changed password successfully',
        additionalData: {'email': currentUser.email},
      );

      emit(AuthState.passwordChanged(user: currentUser));

      debugPrint('✅ AuthBloc: Password changed successfully');
    } catch (e) {
      debugPrint('❌ AuthBloc: Password change failed - $e');
      _lastFailedOperation = event;
      emit(
        AuthState.error(
          message: _getErrorMessage(e),
          canRetry: true,
          lastFailedOperation: 'changePassword',
          user: state.currentUser,
        ),
      );
    }
  }

  /// Handle email verification
  Future<void> _onSendEmailVerification(
    SendEmailVerification event,
    Emitter<AuthState> emit,
  ) async {
    try {
      debugPrint('🔄 AuthBloc: Sending email verification...');

      emit(const AuthState.loading(operationType: 'sendEmailVerification'));

      // TODO: Implement sendEmailVerification method in AuthService
      throw UnimplementedError('Send email verification not implemented yet');
    } catch (e) {
      debugPrint('❌ AuthBloc: Email verification failed - $e');
      _lastFailedOperation = event;
      emit(
        AuthState.error(
          message: _getErrorMessage(e),
          canRetry: true,
          lastFailedOperation: 'sendEmailVerification',
          user: state.currentUser,
        ),
      );
    }
  }

  /// Handle user data refresh
  Future<void> _onRefreshUserData(
    RefreshUserData event,
    Emitter<AuthState> emit,
  ) async {
    try {
      debugPrint('🔄 AuthBloc: Refreshing user data...');

      emit(const AuthState.loading(operationType: 'refreshUserData'));

      final userData = await _authService.getCurrentUserData().timeout(
        const Duration(seconds: 10),
      );

      if (userData != null) {
        emit(
          AuthState.authenticated(
            user: userData,
            isEmailVerified: _authService.currentUser?.emailVerified ?? false,
          ),
        );

        debugPrint('✅ AuthBloc: User data refreshed successfully');
      } else {
        emit(const AuthState.unauthenticated());
      }
    } catch (e) {
      debugPrint('❌ AuthBloc: User data refresh failed - $e');
      _lastFailedOperation = event;
      emit(
        AuthState.error(
          message: _getErrorMessage(e),
          canRetry: true,
          lastFailedOperation: 'refreshUserData',
          user: state.currentUser,
        ),
      );
    }
  }

  /// Handle remaining auth operations (simplified implementations)
  Future<void> _onUpdateUserPermissions(
    UpdateUserPermissions event,
    Emitter<AuthState> emit,
  ) async {
    // Implementation would be similar to other operations
    emit(AuthState.error(message: 'Not implemented yet', canRetry: false));
  }

  Future<void> _onRefreshPermissions(
    RefreshPermissions event,
    Emitter<AuthState> emit,
  ) async {
    // Implementation would refresh user permissions
    emit(AuthState.error(message: 'Not implemented yet', canRetry: false));
  }

  Future<void> _onVerifyEmail(
    VerifyEmail event,
    Emitter<AuthState> emit,
  ) async {
    // Implementation would verify email with action code
    emit(AuthState.error(message: 'Not implemented yet', canRetry: false));
  }

  Future<void> _onConfirmPasswordReset(
    ConfirmPasswordReset event,
    Emitter<AuthState> emit,
  ) async {
    // Implementation would confirm password reset
    emit(AuthState.error(message: 'Not implemented yet', canRetry: false));
  }

  Future<void> _onReauthenticate(
    Reauthenticate event,
    Emitter<AuthState> emit,
  ) async {
    // Implementation would re-authenticate user
    emit(AuthState.error(message: 'Not implemented yet', canRetry: false));
  }

  Future<void> _onDeleteAccount(
    DeleteAccount event,
    Emitter<AuthState> emit,
  ) async {
    // Implementation would delete user account
    emit(AuthState.error(message: 'Not implemented yet', canRetry: false));
  }

  Future<void> _onLinkAccount(
    LinkAccount event,
    Emitter<AuthState> emit,
  ) async {
    // Implementation would link account with provider
    emit(AuthState.error(message: 'Not implemented yet', canRetry: false));
  }

  Future<void> _onUnlinkAccount(
    UnlinkAccount event,
    Emitter<AuthState> emit,
  ) async {
    // Implementation would unlink account from provider
    emit(AuthState.error(message: 'Not implemented yet', canRetry: false));
  }

  Future<void> _onUpdateEmail(
    UpdateEmail event,
    Emitter<AuthState> emit,
  ) async {
    // Implementation would update email address
    emit(AuthState.error(message: 'Not implemented yet', canRetry: false));
  }

  /// Clear error state
  Future<void> _onClearError(ClearError event, Emitter<AuthState> emit) async {
    final currentUser = state.currentUser;

    if (currentUser != null) {
      emit(
        AuthState.authenticated(
          user: currentUser,
          isEmailVerified: _authService.currentUser?.emailVerified ?? false,
        ),
      );
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  /// Retry last failed operation
  Future<void> _onRetryLastOperation(
    RetryLastOperation event,
    Emitter<AuthState> emit,
  ) async {
    if (_lastFailedOperation != null) {
      debugPrint(
        '🔄 AuthBloc: Retrying last failed operation: ${_lastFailedOperation.runtimeType}',
      );
      add(_lastFailedOperation!);
      _lastFailedOperation = null;
    }
  }

  /// Handle auth state changes from Firebase
  Future<void> _onAuthStateChanged(
    AuthStateChanged event,
    Emitter<AuthState> emit,
  ) async {
    try {
      if (event.isAuthenticated && event.userId != null) {
        // User logged in, load user data
        final userData = await _authService.getCurrentUserData();
        if (userData != null) {
          emit(
            AuthState.authenticated(
              user: userData,
              isEmailVerified: _authService.currentUser?.emailVerified ?? false,
            ),
          );
        }
      } else {
        // User logged out
        emit(const AuthState.unauthenticated());
      }
    } catch (e) {
      debugPrint('❌ AuthBloc: Auth state change handling failed - $e');
    }
  }

  /// Setup auth state listener
  void _setupAuthStateListener() {
    _authStateSubscription?.cancel();

    _authStateSubscription = _authService.authStateChanges.listen(
      (user) {
        if (!isClosed) {
          add(
            AuthStateChanged(isAuthenticated: user != null, userId: user?.uid),
          );
        }
      },
      onError: (error) {
        debugPrint('❌ AuthBloc: Auth state stream error - $error');
      },
    );
  }

  /// Get user-friendly error message
  String _getErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('user-not-found')) {
      return 'Email tidak ditemukan. Silakan periksa kembali email Anda.';
    } else if (errorString.contains('wrong-password')) {
      return 'Password salah. Silakan coba lagi.';
    } else if (errorString.contains('email-already-in-use')) {
      return 'Email sudah digunakan. Silakan gunakan email lain.';
    } else if (errorString.contains('weak-password')) {
      return 'Password terlalu lemah. Gunakan minimal 6 karakter.';
    } else if (errorString.contains('invalid-email')) {
      return 'Format email tidak valid.';
    } else if (errorString.contains('too-many-requests')) {
      return 'Terlalu banyak percobaan. Silakan coba lagi nanti.';
    } else if (errorString.contains('network')) {
      return 'Koneksi internet bermasalah. Silakan periksa koneksi Anda.';
    } else if (errorString.contains('timeout')) {
      return 'Operasi timeout. Silakan coba lagi.';
    } else {
      return 'Terjadi kesalahan: ${error.toString()}';
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
