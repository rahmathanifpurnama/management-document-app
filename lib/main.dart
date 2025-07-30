import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async' show unawaited;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// New Riverpod + BLoC imports
import 'features/settings/providers/settings_providers.dart';
import 'features/upload/bloc/upload_bloc.dart';
import 'features/category/bloc/category_bloc.dart';
import 'features/category/bloc/category_event.dart' as category_events;
import 'features/users/bloc/user_bloc.dart';
import 'features/documents/bloc/document_bloc.dart';
import 'features/sync/bloc/sync_bloc.dart';
import 'features/sync/bloc/sync_event.dart' as sync_events;
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart' as auth_events;
import 'core/services/firebase_service.dart';
import 'core/services/memory_management_service.dart';
import 'core/services/optimized_network_service.dart';
import 'core/config/anr_config.dart';
import 'core/utils/debug_log_controller.dart';
import 'core/utils/empty_storage_state_manager.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/app_routes.dart';
import 'core/utils/anr_detector.dart';
import 'core/utils/anr_prevention.dart';
import 'core/utils/anr_recovery.dart';
import 'core/utils/firebase_initialization_status.dart';

import 'screens/auth/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/common/home_screen.dart';
import 'screens/admin/user_management_screen.dart';
import 'widgets/app/statistics_initializer.dart';
import 'widgets/app/realtime_category_initializer.dart';

import 'screens/admin/create_user_screen.dart';
import 'screens/admin/edit_user_screen.dart';
import 'screens/admin/user_details_screen.dart';

import 'screens/category/manage_category_screen.dart';
import 'screens/category/category_files_screen.dart';
import 'screens/category/add_files_to_category_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/personal_info_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/profile/settings_screen.dart';
import 'screens/profile/change_password_screen.dart';

import 'screens/notification/notification_center_screen.dart';
import 'screens/upload/upload_document_screen.dart';
import 'screens/common/file_preview_screen.dart';
import 'screens/files/total_files_screen.dart';
import 'screens/recycle_bin/recycle_bin_screen.dart';
import 'screens/favorites/favorites_screen.dart';
import 'screens/activity/new_activity_page.dart';
import 'screens/activity/storage_history_page.dart';
import 'services/download_notification_service.dart';
import 'models/category_model.dart';
import 'models/user_model.dart';
import 'models/document_model.dart';

// Global RouteObserver for tracking navigation
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // HIGH PRIORITY: Initialize memory management first
  MemoryManagementService.instance.initialize();

  // HIGH PRIORITY: Initialize optimized network service
  OptimizedNetworkService.instance.initialize();

  // CRITICAL FIX: Set quiet mode to reduce debug logging
  DebugLogController.setQuietMode();
  debugPrint('🔇 Debug logging set to quiet mode to reduce terminal noise');

  // Initialize ANR recovery system first (lightweight)
  await ANRRecovery.initialize();

  // PERFORMANCE FIX: Defer heavy operations to prevent main thread blocking
  // Initialize empty storage state manager in background
  unawaited(
    EmptyStorageStateManager.instance.initialize().catchError((e) {
      debugPrint('⚠️ Empty storage state manager initialization failed: $e');
    }),
  );

  // Initialize download notification service in background
  unawaited(() async {
    try {
      final notificationService = DownloadNotificationService();
      await notificationService.initialize();
      debugPrint('✅ Download notification service initialized');
    } catch (e) {
      debugPrint('⚠️ Download notification service initialization failed: $e');
    }
  }());

  // Initialize Firebase with optimized timeout and error handling
  bool firebaseInitialized = false;
  try {
    await ANRPrevention.executeWithTimeout(
      FirebaseService.initialize(),
      timeout: ANRConfig.firebaseInitTimeout, // Use optimized timeout
      operationName: 'Firebase Initialization',
    );
    firebaseInitialized = true;
    debugPrint('✅ Firebase initialization completed successfully');
  } catch (e) {
    debugPrint('⚠️ Firebase initialization failed, continuing: $e');
    firebaseInitialized = false;
    FirebaseInitializationStatus.lastError = e.toString();

    // Check if it's a network/offline issue
    final errorString = e.toString().toLowerCase();
    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout')) {
      FirebaseInitializationStatus.isOfflineMode = true;
      debugPrint('📱 Setting offline mode due to network issues');
    }

    // Continue app launch even if Firebase fails
  }

  // Store Firebase initialization status globally
  FirebaseInitializationStatus.isInitialized = firebaseInitialized;

  // REMOVED: Architectural services initialization (DatabaseVersionTracker removed)
  // The architectural services were designed for enterprise-scale version tracking
  // which is not implemented in the current database structure (4 collections only)
  debugPrint(
    '⚠️ Architectural services disabled - using simplified initialization',
  );

  // CRITICAL FIX: Disable ANR monitoring to prevent excessive debug logging
  debugPrint('⚠️ ANR Detector disabled to prevent excessive debug logging');

  // HIGH PRIORITY: Set up error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('🚨 Flutter Error: ${details.exception}');
    if (kDebugMode) {
      debugPrint('Stack trace: ${details.stack}');
    }

    // Don't crash the app in production
    if (kReleaseMode) {
      // Log to crash reporting service in production
      // FirebaseCrashlytics.instance.recordFlutterError(details);
    }
  };

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Settings provider will be initialized in the create callback
  }

  @override
  Widget build(BuildContext context) {
    return ANRMonitorWidget(
      autoStart: true,
      child: ProviderScope(
        // Riverpod root
        child: MultiBlocProvider(
          // BLoC root
          providers: [
            // Auth BLoC
            BlocProvider<AuthBloc>(
              create: (context) =>
                  AuthBloc()..add(const auth_events.AuthEvent.initialize()),
            ),
            // Upload BLoC
            BlocProvider<UploadBloc>(create: (context) => UploadBloc()),
            // Category BLoC
            BlocProvider<CategoryBloc>(
              create: (context) =>
                  CategoryBloc()
                    ..add(const category_events.CategoryEvent.loadCategories()),
            ),
            // User BLoC
            BlocProvider<UserBloc>(create: (context) => UserBloc()),
            // Document BLoC
            BlocProvider<DocumentBloc>(create: (context) => DocumentBloc()),
            // Sync BLoC
            BlocProvider<SyncBloc>(
              create: (context) =>
                  SyncBloc()..add(const sync_events.SyncEvent.initialize()),
            ),
          ],
          child: Consumer(
            // Riverpod consumer for theme management
            builder: (context, ref, child) {
              // Use Riverpod settings provider for theme
              final settings = ref.watch(settingsProvider);
              final themeData = ref.watch(themeDataProvider);
              return MaterialApp(
                title: AppStrings.appName,
                debugShowCheckedModeBanner: false,
                theme: themeData.copyWith(
                  primaryColor: AppColors.primary,
                  scaffoldBackgroundColor: settings.darkModeEnabled
                      ? const Color(0xFF121212)
                      : AppColors.background,
                  textTheme: GoogleFonts.poppinsTextTheme(
                    settings.darkModeEnabled
                        ? ThemeData.dark().textTheme
                        : ThemeData.light().textTheme,
                  ),
                  appBarTheme: AppBarTheme(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textWhite,
                    elevation: 0,
                    titleTextStyle: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                    ),
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textWhite,
                      textStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                    hintStyle: GoogleFonts.poppins(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  cardTheme: CardThemeData(
                    color: AppColors.cardBackground,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    selectedLabelStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    unselectedLabelStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                initialRoute: AppRoutes.splash,
                navigatorObservers: [routeObserver],
                onGenerateRoute: (settings) {
                  switch (settings.name) {
                    case AppRoutes.splash:
                      return MaterialPageRoute(
                        builder: (context) => const SplashScreen(),
                      );
                    case AppRoutes.login:
                      return MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      );
                    case AppRoutes.home:
                      return MaterialPageRoute(
                        builder: (context) => const RealtimeCategoryInitializer(
                          child: StatisticsInitializer(child: HomeScreen()),
                        ),
                      );
                    case AppRoutes.userManagement:
                      return MaterialPageRoute(
                        builder: (context) => const UserManagementScreen(),
                      );

                    case AppRoutes.totalFiles:
                      return MaterialPageRoute(
                        builder: (context) => const TotalFilesScreen(),
                      );
                    case AppRoutes.recycleBin:
                      return MaterialPageRoute(
                        builder: (context) => const RecycleBinScreen(),
                      );
                    case AppRoutes.favorites:
                      return MaterialPageRoute(
                        builder: (context) => const FavoritesScreen(),
                      );
                    case AppRoutes.manageCategories:
                      return MaterialPageRoute(
                        builder: (context) => const ManageCategoryScreen(),
                      );
                    case AppRoutes.categoryFiles:
                      final category = settings.arguments as CategoryModel;
                      return MaterialPageRoute(
                        builder: (context) =>
                            CategoryFilesScreen(category: category),
                      );
                    case AppRoutes.addFilesToCategory:
                      final category = settings.arguments as CategoryModel;
                      return MaterialPageRoute(
                        builder: (context) =>
                            AddFilesToCategoryScreen(category: category),
                      );
                    case AppRoutes.createUser:
                      return MaterialPageRoute(
                        builder: (context) => const CreateUserScreen(),
                      );
                    case AppRoutes.editUser:
                      final user = settings.arguments as UserModel;
                      return MaterialPageRoute(
                        builder: (context) => EditUserScreen(user: user),
                      );
                    case AppRoutes.userDetails:
                      final user = settings.arguments as UserModel;
                      return MaterialPageRoute(
                        builder: (context) => UserDetailsScreen(user: user),
                      );
                    case AppRoutes.account:
                      return MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      );
                    case AppRoutes.profile:
                      return MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      );
                    case AppRoutes.personalInfo:
                      return MaterialPageRoute(
                        builder: (context) => const PersonalInfoScreen(),
                      );
                    case AppRoutes.editProfile:
                      return MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      );
                    case AppRoutes.settings:
                      return MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      );
                    case AppRoutes.changePassword:
                      return MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen(),
                      );
                    case AppRoutes.uploadDocument:
                      final categoryId = settings.arguments as String?;
                      return MaterialPageRoute(
                        builder: (context) =>
                            UploadDocumentScreen(categoryId: categoryId),
                      );

                    case AppRoutes.activity:
                      return MaterialPageRoute(
                        builder: (context) => const NewActivityPage(),
                      );

                    case AppRoutes.storageHistory:
                      return MaterialPageRoute(
                        builder: (context) => const StorageHistoryPage(),
                      );

                    case AppRoutes.notificationCenter:
                      return MaterialPageRoute(
                        builder: (context) => const NotificationCenterScreen(),
                      );

                    case AppRoutes.filePreview:
                      final document = settings.arguments as DocumentModel;
                      return MaterialPageRoute(
                        builder: (context) =>
                            FilePreviewScreen(document: document),
                      );

                    default:
                      return MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(title: const Text('Page Not Found')),
                          body: const Center(
                            child: Text('404 - Page Not Found'),
                          ),
                        ),
                      );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
