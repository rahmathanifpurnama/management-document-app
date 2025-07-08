class AppRoutes {
  // Authentication Routes
  static const String splash = '/';
  static const String login = '/login';

  // Common Routes
  static const String home = '/home';
  static const String account = '/account';
  static const String editProfile = '/edit-profile';
  static const String changePassword = '/change-password';
  static const String activities = '/activities';

  // Document Routes
  static const String documents = '/documents';
  static const String documentDetails = '/document-details';
  static const String filePreview = '/file-preview';
  static const String uploadDocument = '/upload-document';
  static const String apiUploadDemo = '/api-upload-demo';
  static const String recentFiles = '/recent-files';
  static const String totalFiles = '/total-files';
  static const String recycleBin = '/recycle-bin';
  static const String favorites = '/favorites';

  // Category Routes
  static const String manageCategories = '/manage-categories';
  static const String categoryFiles = '/category-files';
  static const String addFilesToCategory = '/add-files-to-category';
  static const String createCategory = '/create-category';
  static const String editCategory = '/edit-category';
  static const String categoryDetails = '/category-details';

  // Admin Routes
  static const String userManagement = '/user-management';
  static const String createUser = '/create-user';
  static const String editUser = '/edit-user';
  static const String userDetails = '/user-details';
  static const String userPermissions = '/user-permissions';
  static const String searchUser = '/search-user';

  // User Routes
  static const String userDashboard = '/user-dashboard';

  // Profile Routes
  static const String profile = '/profile';
  static const String personalInfo = '/personal-info';

  // Settings Routes
  static const String settings = '/settings';

  // Approval Routes
  static const String fileApproval = '/file-approval';
  static const String notificationCenter = '/notification-center';

  // Error Routes
  static const String notFound = '/not-found';
  static const String unauthorized = '/unauthorized';
}
