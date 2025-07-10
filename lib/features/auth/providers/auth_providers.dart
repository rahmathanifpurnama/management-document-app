import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/auth_service.dart';
import '../../../services/enhanced_auth_service.dart';
import '../../../models/user_model.dart';

/// Riverpod providers for Auth state management
/// Handles simple auth state and user data with reactive updates

/// Firebase Auth instance provider
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService.instance;
});

/// Enhanced auth service provider
final enhancedAuthServiceProvider = Provider<EnhancedAuthService>((ref) {
  return EnhancedAuthService.instance;
});

/// Auth state stream provider - tracks Firebase Auth state changes
final authStateProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.authStateChanges();
});

/// Current Firebase user provider
final currentFirebaseUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// User ID provider
final userIdProvider = Provider<String?>((ref) {
  final user = ref.watch(currentFirebaseUserProvider);
  return user?.uid;
});

/// Is logged in provider
final isLoggedInProvider = Provider<bool>((ref) {
  final user = ref.watch(currentFirebaseUserProvider);
  return user != null;
});

/// Current user data provider - fetches UserModel from Firestore
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  final user = ref.watch(currentFirebaseUserProvider);

  if (user == null) return null;

  try {
    return await authService.getCurrentUserData();
  } catch (e) {
    // Return null if user data not found or error occurs
    return null;
  }
});

/// Current user data (synchronous) - for immediate access
final currentUserSyncProvider = Provider<UserModel?>((ref) {
  final asyncUser = ref.watch(currentUserProvider);
  return asyncUser.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// User role provider
final userRoleProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserSyncProvider);
  return user?.role;
});

/// Is admin provider
final isAdminProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider);
  return role == 'admin';
});

/// Is user active provider
final isUserActiveProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserSyncProvider);
  return user?.isActive ?? false;
});

/// User permissions provider
final userPermissionsProvider = Provider<UserPermissions?>((ref) {
  final user = ref.watch(currentUserSyncProvider);
  return user?.permissions;
});

/// Email verified provider
final emailVerifiedProvider = Provider<bool>((ref) {
  final firebaseUser = ref.watch(currentFirebaseUserProvider);
  return firebaseUser?.emailVerified ?? false;
});

/// User display name provider
final userDisplayNameProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserSyncProvider);
  return user?.fullName;
});

/// User email provider
final userEmailProvider = Provider<String?>((ref) {
  final firebaseUser = ref.watch(currentFirebaseUserProvider);
  return firebaseUser?.email;
});

/// Permission check providers - for specific permissions
final canUploadFilesProvider = FutureProvider<bool>((ref) async {
  final enhancedAuth = ref.watch(enhancedAuthServiceProvider);
  final isLoggedIn = ref.watch(isLoggedInProvider);

  if (!isLoggedIn) return false;

  try {
    return await enhancedAuth.canUploadFiles();
  } catch (e) {
    return false;
  }
});

final canDeleteFilesProvider = FutureProvider<bool>((ref) async {
  final enhancedAuth = ref.watch(enhancedAuthServiceProvider);
  final isLoggedIn = ref.watch(isLoggedInProvider);

  if (!isLoggedIn) return false;

  try {
    return await enhancedAuth.canDeleteFiles();
  } catch (e) {
    return false;
  }
});

final canManageUsersProvider = FutureProvider<bool>((ref) async {
  final enhancedAuth = ref.watch(enhancedAuthServiceProvider);
  final isLoggedIn = ref.watch(isLoggedInProvider);

  if (!isLoggedIn) return false;

  try {
    return await enhancedAuth.canManageUsers();
  } catch (e) {
    return false;
  }
});

final canViewAnalyticsProvider = FutureProvider<bool>((ref) async {
  final enhancedAuth = ref.watch(enhancedAuthServiceProvider);
  final isLoggedIn = ref.watch(isLoggedInProvider);

  if (!isLoggedIn) return false;

  try {
    return await enhancedAuth.canViewAnalytics();
  } catch (e) {
    return false;
  }
});

final canAccessStorageManagementProvider = FutureProvider<bool>((ref) async {
  final enhancedAuth = ref.watch(enhancedAuthServiceProvider);
  final isLoggedIn = ref.watch(isLoggedInProvider);

  if (!isLoggedIn) return false;

  try {
    return await enhancedAuth.canAccessStorageManagement();
  } catch (e) {
    return false;
  }
});

final canPerformUnlimitedQueriesProvider = FutureProvider<bool>((ref) async {
  final enhancedAuth = ref.watch(enhancedAuthServiceProvider);
  final isLoggedIn = ref.watch(isLoggedInProvider);

  if (!isLoggedIn) return false;

  try {
    return await enhancedAuth.canPerformUnlimitedQueries();
  } catch (e) {
    return false;
  }
});

/// Document access provider - for checking specific document permissions
final documentAccessProvider = FutureProvider.family<bool, Map<String, String>>(
  (ref, params) async {
    final enhancedAuth = ref.watch(enhancedAuthServiceProvider);
    final isLoggedIn = ref.watch(isLoggedInProvider);

    if (!isLoggedIn) return false;

    final documentId = params['documentId'];
    final action = params['action'];

    if (documentId == null || action == null) return false;

    try {
      return await enhancedAuth.hasDocumentAccess(documentId, action);
    } catch (e) {
      return false;
    }
  },
);

/// System permission provider - for checking specific system permissions
final systemPermissionProvider = FutureProvider.family<bool, String>((
  ref,
  permission,
) async {
  final enhancedAuth = ref.watch(enhancedAuthServiceProvider);
  final isLoggedIn = ref.watch(isLoggedInProvider);

  if (!isLoggedIn) return false;

  try {
    return await enhancedAuth.hasSystemPermission(permission);
  } catch (e) {
    return false;
  }
});

/// User permission summary provider
final userPermissionSummaryProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  final enhancedAuth = ref.watch(enhancedAuthServiceProvider);
  final isLoggedIn = ref.watch(isLoggedInProvider);

  if (!isLoggedIn) return {};

  try {
    return await enhancedAuth.getCurrentUserPermissionSummary();
  } catch (e) {
    return {};
  }
});

/// Refresh current user provider - for triggering user data refresh
final refreshCurrentUserProvider = FutureProvider<void>((ref) async {
  final authService = ref.watch(authServiceProvider);

  try {
    // This will trigger a refresh of currentUserProvider
    ref.invalidate(currentUserProvider);
  } catch (e) {
    // Handle error silently
  }
});
