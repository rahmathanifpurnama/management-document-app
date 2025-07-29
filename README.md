# Document Management System (SimDoc)

A comprehensive Flutter-based document management application with Firebase integration, designed for efficient document storage, categorization, and user management following object-oriented design principles.

## 📋 Table of Contents

- [Project Overview](#-project-overview)
- [Architecture](#-architecture)
- [Object-Oriented Design Patterns](#-object-oriented-design-patterns)
- [Project Structure](#-project-structure)
- [Firebase Integration](#-firebase-integration)
- [Installation & Setup](#-installation--setup)
- [Page-by-Page Documentation](#-page-by-page-documentation)
- [Development Guidelines](#-development-guidelines)
- [Testing Strategy](#-testing-strategy)
- [Deployment](#-deployment)

## 🚀 Project Overview

### Vision & Scope
SimDoc is a modern document management system that enables organizations to efficiently manage their digital documents with enterprise-grade security and user experience.

### Target Users
- **Administrators**: Full system access, user management, analytics
- **Regular Users**: Document upload, download, view, and basic management

### Core Problems Solved
- **Document Organization**: Hierarchical categorization system
- **Access Control**: Role-based permissions and security
- **Activity Tracking**: Comprehensive audit trails
- **File Management**: Upload, download, preview, and lifecycle management
- **User Management**: Admin-controlled user provisioning and permissions

### Key Features
- 🔐 **Secure Authentication**: Firebase Auth with role-based access
- 📁 **Category Management**: Hierarchical document organization
- 📤 **File Upload/Download**: Hybrid cloud processing for optimal performance
- 🗑️ **Recycle Bin**: Soft delete with recovery options
- 📊 **Analytics Dashboard**: Real-time statistics and insights
- 👥 **User Management**: Admin-controlled user provisioning
- 📱 **Activity Tracking**: Comprehensive audit logs
- 🔍 **Search & Filter**: Advanced document discovery
- 📋 **Responsive Design**: Optimized for various screen sizes

## 🏗️ Architecture

### Hybrid State Management Architecture
This application implements a **Riverpod + BLoC Hybrid Architecture** that combines the best of both state management solutions:

#### **Riverpod Usage** (Simple State & UI)
- UI state management (loading, selections, form states)
- Settings and preferences
- Computed values and derived state
- Simple data transformations
- Provider composition and dependency injection

#### **BLoC Usage** (Complex Business Logic)
- Authentication flows and user sessions
- Document operations (CRUD, file processing)
- Category management with real-time updates
- User management and permissions
- Sync operations and background tasks

#### **Repository Pattern**
- Abstract data access layer
- Firebase service abstraction
- Consistent error handling
- Caching and offline support
- Testing and mocking capabilities

### Clean Architecture Principles
```
┌─────────────────────────────────────────┐
│                Presentation             │
│  (Screens, Widgets, BLoC, Riverpod)    │
├─────────────────────────────────────────┤
│                 Domain                  │
│     (Models, Repositories, Use Cases)   │
├─────────────────────────────────────────┤
│                  Data                   │
│    (Firebase Services, Local Storage)   │
└─────────────────────────────────────────┘
```

### Technology Stack
- **Frontend**: Flutter 3.8.0+ (Dart)
- **Backend**: Firebase (Firestore, Storage, Authentication, Functions)
- **State Management**: Riverpod + BLoC Hybrid
- **Local Storage**: SharedPreferences
- **File Handling**: Cross-platform file selection and processing
- **Cloud Functions**: Node.js/TypeScript for server-side processing

## 🎯 Object-Oriented Design Patterns

### Abstraction
The application uses abstract base classes to define common interfaces:

#### BaseNotifier (Riverpod)
```dart
abstract class BaseNotifier<T> extends StateNotifier<T> {
  void safeUpdate(T Function() updater);
  void handleError(Object error);
  void reset();
}
```

#### BaseBloc (BLoC)
```dart
abstract class BaseBloc<Event extends BaseEvent, State extends BaseState>
    extends Bloc<Event, State> {
  Future<void> onRefresh(Emitter<State> emit);
}
```

#### BaseRepository
```dart
abstract class BaseRepository {
  Future<T> executeWithTimeout<T>(Future<T> Function() operation);
  Future<T> executeWithRetry<T>(Future<T> Function() operation);
  Future<bool> isAvailable();
}
```

### Encapsulation
Data and methods are properly encapsulated within classes:

- **Models**: Private fields with public getters/setters
- **Services**: Internal state hidden behind public interfaces
- **Providers**: State encapsulated within notifiers
- **BLoCs**: Business logic encapsulated within event handlers

### Polymorphism
Multiple implementations share common interfaces:

- **Repository Pattern**: Different data sources (Firebase, local storage)
- **File Processors**: Various file type handlers
- **Authentication Methods**: Multiple auth providers
- **State Notifiers**: Different state management strategies

### Inheritance
Class hierarchies provide code reuse and consistency:

- **BaseNotifier** → Feature-specific notifiers
- **BaseBloc** → Feature-specific BLoCs
- **BaseRepository** → Service-specific repositories
- **BaseState/BaseEvent** → Feature-specific states/events

## 📁 Project Structure

### Directory Organization
```
lib/
├── core/                           # Core application components
│   ├── bloc/                      # Base BLoC classes
│   │   ├── base_bloc.dart         # Abstract base BLoC
│   │   ├── base_event.dart        # Base event classes
│   │   └── base_state.dart        # Base state classes
│   ├── config/                    # Configuration files
│   │   ├── anr_config.dart        # ANR prevention config
│   │   ├── cloud_functions_config.dart # Cloud Functions setup
│   │   └── feature_flags.dart     # Feature toggles
│   ├── constants/                 # App constants
│   │   ├── app_colors.dart        # Color palette
│   │   ├── app_routes.dart        # Route definitions
│   │   └── app_strings.dart       # String constants
│   ├── repositories/              # Base repository classes
│   │   └── base_repository.dart   # Abstract repository
│   ├── riverpod/                  # Riverpod base classes
│   │   └── notifiers.dart         # Base notifiers
│   ├── services/                  # Core services
│   │   ├── auth_service.dart      # Authentication service
│   │   ├── document_service.dart  # Document operations
│   │   ├── firebase_service.dart  # Firebase initialization
│   │   └── network_service.dart   # Network operations
│   ├── utils/                     # Utility functions
│   │   ├── anr_prevention.dart    # ANR prevention utilities
│   │   ├── circuit_breaker.dart   # Circuit breaker pattern
│   │   └── debug_log_controller.dart # Logging utilities
│   └── widgets/                   # Reusable core widgets
│       ├── loading/               # Loading indicators
│       ├── error/                 # Error handling widgets
│       └── common/                # Common UI components
├── features/                      # Feature-based organization
│   ├── auth/                      # Authentication feature
│   │   ├── bloc/                  # Auth BLoC
│   │   ├── models/                # Auth models
│   │   ├── providers/             # Auth Riverpod providers
│   │   └── repositories/          # Auth repositories
│   ├── documents/                 # Document management
│   │   ├── bloc/                  # Document BLoC
│   │   ├── models/                # Document models
│   │   ├── providers/             # Document providers
│   │   └── repositories/          # Document repositories
│   ├── category/                  # Category management
│   ├── users/                     # User management
│   ├── upload/                    # File upload
│   ├── sync/                      # Data synchronization
│   ├── notification/              # Notifications
│   ├── settings/                  # App settings
│   └── file_selection/            # File selection
├── models/                        # Shared data models
│   ├── category_model.dart        # Category data structure
│   ├── document_model.dart        # Document data structure
│   ├── user_model.dart            # User data structure
│   └── notification_model.dart    # Notification structure
├── screens/                       # UI screens by feature
│   ├── admin/                     # Admin screens
│   │   ├── user_management_screen.dart
│   │   ├── create_user_screen.dart
│   │   └── edit_user_screen.dart
│   ├── auth/                      # Authentication screens
│   │   ├── splash_screen.dart
│   │   └── login_screen.dart
│   ├── category/                  # Category screens
│   │   ├── manage_category_screen.dart
│   │   └── category_files_screen.dart
│   ├── common/                    # Shared screens
│   │   ├── home_screen.dart       # Dashboard
│   │   └── file_preview_screen.dart
│   ├── profile/                   # Profile screens
│   ├── files/                     # File management screens
│   ├── recycle_bin/               # Recycle bin screens
│   ├── activity/                  # Activity screens
│   └── upload/                    # Upload screens
├── services/                      # Additional services
│   ├── bulk_operations_service.dart
│   ├── hybrid_upload_service.dart
│   ├── file_download_service.dart
│   └── share_service.dart
├── widgets/                       # Feature-specific widgets
│   ├── common/                    # Shared widgets
│   │   ├── app_scaffold_with_navigation.dart
│   │   ├── file_list_widget.dart
│   │   └── responsive_stats_grid.dart
│   ├── statistics/                # Statistics widgets
│   ├── notification/              # Notification widgets
│   ├── upload/                    # Upload widgets
│   └── user/                      # User widgets
└── utils/                         # App-specific utilities
    ├── filename_utils.dart
    ├── file_type_utils.dart
    └── date_utils.dart
```

## 🔥 Firebase Integration

### Firestore Collections Structure

#### Core Collections
```javascript
// Users collection
users/{userId} {
  id: string,
  email: string,
  fullName: string,
  role: 'admin' | 'user',
  status: 'active' | 'inactive',
  permissions: {
    documents: string[],
    categories: string[],
    system: string[]
  },
  createdAt: timestamp,
  lastLogin: timestamp
}

// Documents collection
documents/{documentId} {
  id: string,
  fileName: string,
  fileSize: number,
  fileType: string,
  filePath: string,
  uploadedBy: string,
  uploadedAt: timestamp,
  category: string,
  status: 'active' | 'deleted',
  isDeleted: boolean,
  deletedAt?: timestamp,
  deletedBy?: string,
  downloadUrl: string,
  metadata: object
}

// Categories collection
categories/{categoryId} {
  id: string,
  name: string,
  description: string,
  createdBy: string,
  createdAt: timestamp,
  permissions: string[],
  isActive: boolean,
  documentCount: number
}

// Activities collection
activities/{activityId} {
  id: string,
  type: 'login' | 'logout' | 'upload' | 'download' | 'delete' | 'view',
  userId: string,
  timestamp: timestamp,
  details: object,
  metadata: object
}
```

#### Backend Collections (Cloud Functions)
- `upload-statistics`: Real-time file count tracking
- `file-validation-logs`: Security monitoring
- `duplicate-cache`: Duplicate file detection
- `storage_history`: Storage analytics

### Firebase Storage Organization
```
/documents/
├── {categoryId}/           # Category-specific files
│   └── {secureFileName}    # Sanitized file names
├── profile_images/         # User profile images
│   └── {userId}/
└── temp/                   # Temporary upload storage
    └── {userId}/
```

### Security Rules

#### Firestore Rules
- **Authentication Required**: All operations require valid authentication
- **Role-Based Access**: Admin vs user permissions
- **Document Permissions**: Category-level access control
- **Admin-Only Operations**: Hard deletes, user management
- **Pagination Limits**: Query size restrictions for performance

#### Storage Rules
- **File Type Validation**: Allowed file types enforcement
- **Size Restrictions**: 15MB file size limit
- **User Isolation**: Users can only access their own files
- **Admin Override**: Admins have full access

### Cloud Functions

#### hybridProcessFileUpload
```typescript
// Server-side file processing
export const processFileUpload = functions
  .runWith({ timeoutSeconds: 540, memory: '2GB' })
  .https.onCall(async (data, context) => {
    // Heavy server-side processing
    // File validation and metadata extraction
    // Firestore document creation
    // Storage organization
  });
```

**Features:**
- File validation and sanitization
- Metadata extraction
- Duplicate detection
- Security scanning
- Firestore document creation
- Storage path organization

## 🔧 Installation & Setup

### Prerequisites
- **Flutter SDK**: 3.8.0 or higher
- **Dart SDK**: Latest stable version
- **Development Environment**: Android Studio / VS Code
- **Firebase Project**: Configured with required services
- **Node.js**: 16+ (for Cloud Functions development)

### Environment Configuration

#### Development Environment
1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd management-document-app
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create Firebase project at [Firebase Console](https://console.firebase.google.com)
   - Enable Authentication, Firestore, Storage, and Functions
   - Download `google-services.json` for Android
   - Place in `android/app/` directory
   - Download `GoogleService-Info.plist` for iOS
   - Place in `ios/Runner/` directory

4. **Cloud Functions Setup**
   ```bash
   cd functions
   npm install
   npm run build
   firebase deploy --only functions
   ```

5. **Firestore Security Rules**
   ```bash
   firebase deploy --only firestore:rules
   firebase deploy --only storage
   ```

#### Production Environment
1. **Firebase Project Configuration**
   - Separate production Firebase project
   - Production security rules
   - Performance monitoring enabled
   - Analytics configured

2. **Build Configuration**
   - Release signing keys
   - ProGuard configuration
   - App bundle optimization

### Running the Application

#### Development Mode
```bash
flutter run --debug
```

#### Release Mode
```bash
flutter run --release
```

#### Specific Platform
```bash
flutter run -d android    # Android device
flutter run -d ios        # iOS device
flutter run -d chrome     # Web browser
```

## � Page-by-Page Documentation

### Authentication Flow

#### 1. Splash Screen (`screens/auth/splash_screen.dart`)
**Purpose**: App initialization and authentication state checking

**State Management**:
- **BLoC**: `AuthBloc` for authentication state
- **Riverpod**: `firebaseInitializationProvider` for Firebase status

**Widget Hierarchy**:
```dart
SplashScreen
├── Scaffold
│   └── SafeArea
│       └── Column
│           ├── Logo (SVG)
│           ├── Loading Indicator
│           └── Version Text
```

**Firebase Integration**:
- Firebase initialization check
- Authentication state verification
- Automatic navigation based on auth status

**Navigation Flow**:
- Authenticated → Home Screen
- Unauthenticated → Login Screen
- Error → Error handling with retry

#### 2. Login Screen (`screens/auth/login_screen.dart`)
**Purpose**: User authentication with email/password

**State Management**:
- **BLoC**: `AuthBloc` for login operations
- **Riverpod**: `authStateProvider` for reactive auth state

**Widget Hierarchy**:
```dart
LoginScreen
├── Scaffold
│   └── SafeArea
│       └── Form
│           ├── Logo Section
│           ├── Email TextFormField
│           ├── Password TextFormField
│           ├── Remember Me Checkbox
│           ├── Login Button
│           └── Forgot Password Link
```

**Features**:
- Real-time email validation (specific domains)
- Remember Me functionality with SharedPreferences
- Forgot password modal with admin contact
- Error handling with specific messages

**OOP Patterns**:
- **Encapsulation**: Form validation logic encapsulated
- **Polymorphism**: Different authentication methods

### Dashboard & Home

#### 3. Home Screen (`screens/common/home_screen.dart`)
**Purpose**: Main dashboard with statistics, search, and file listing

**State Management**:
- **BLoC**: `DocumentBloc`, `CategoryBloc`, `SyncBloc`
- **Riverpod**: `currentUserSyncProvider`, `notificationProvider`

**Widget Hierarchy**:
```dart
HomeScreen
├── AppScaffoldWithNavigation
│   ├── BellNotificationWidget
│   ├── FileSelectionBar
│   └── RefreshIndicator
│       └── SingleChildScrollView
│           ├── HomeGreetingSection
│           ├── ResponsiveStatsGrid (Admin only)
│           ├── HomeSearchSection
│           └── HomeFileListSection
```

**Components**:
- **HomeGreetingSection**: User greeting with profile access
- **ResponsiveStatsGrid**: Statistics widgets (4 in top row, 2 in bottom)
- **HomeSearchSection**: Search functionality
- **HomeFileListSection**: Recent files with pagination

**OOP Patterns**:
- **Composition**: Multiple specialized components
- **Inheritance**: Extends StatefulWidget with RouteAware
- **Abstraction**: Abstract file operations through services

### File Management

#### 4. Total Files Screen (`screens/files/total_files_screen.dart`)
**Purpose**: Complete file listing with search and filters

**State Management**:
- **BLoC**: `DocumentBloc` for file operations
- **Riverpod**: File selection state management

**Widget Hierarchy**:
```dart
TotalFilesScreen
├── Scaffold (no bottom navigation)
│   ├── AppBar with back button
│   └── Column
│       ├── SearchWidget
│       ├── Title and Filter Section
│       └── FileListSection
```

**Features**:
- Search functionality
- Category filtering
- Bulk operations
- Infinite scroll pagination

#### 5. Recycle Bin Screen (`screens/recycle_bin/recycle_bin_screen.dart`)
**Purpose**: Manage deleted files with restore/permanent delete options

**State Management**:
- **BLoC**: `DocumentBloc` for deleted documents
- **Riverpod**: Bulk operations state

**Widget Hierarchy**:
```dart
RecycleBinScreen
├── Scaffold (no bottom navigation)
│   ├── AppBar with back button
│   └── Column
│       ├── QuickAccessWidget (4 cards, stats grid style)
│       └── DeletedFilesList
│           ├── Restore functionality
│           └── Permanent delete (Admin only)
```

**Features**:
- 7-day retention policy
- Restore functionality
- Admin-only permanent deletion
- Activity logging for all operations

### Category Management

#### 6. Manage Categories Screen (`screens/category/manage_category_screen.dart`)
**Purpose**: Category CRUD operations and management

**State Management**:
- **BLoC**: `CategoryBloc` for category operations
- **Riverpod**: Category selection and UI state

**Widget Hierarchy**:
```dart
ManageCategoryScreen
├── AppScaffoldWithNavigation
│   ├── FloatingActionButton (Add Category)
│   └── CategoryList
│       ├── CategoryCard
│       │   ├── Category Info
│       │   ├── Document Count
│       │   └── Action Menu
│       └── EmptyState
```

**Features**:
- Real-time category updates
- Document count tracking
- Permission management
- Category activation/deactivation

#### 7. Category Files Screen (`screens/category/category_files_screen.dart`)
**Purpose**: Display files within a specific category

**State Management**:
- **BLoC**: `DocumentBloc` with category filtering
- **Riverpod**: File selection state

**Navigation**: Accessed via category selection with CategoryModel argument

### User Management

#### 8. Profile Screen (`screens/profile/profile_screen.dart`)
**Purpose**: User profile management and navigation hub

**State Management**:
- **Riverpod**: `currentUserSyncProvider`, `isAdminProvider`

**Widget Hierarchy**:
```dart
ProfileScreen
├── AppScaffoldWithNavigation
│   └── SingleChildScrollView
│       ├── ProfileSection (Avatar, Name, Role)
│       ├── Personal Information Menu
│       ├── User Management Menu (Admin only)
│       ├── Activity Menu
│       ├── Settings Menu
│       └── Logout Button
```

**Features**:
- Role-based menu visibility
- Profile image management
- Integrated user management access

#### 9. User Management Screen (`screens/admin/user_management_screen.dart`)
**Purpose**: Admin-only user administration

**State Management**:
- **BLoC**: `UserBloc` for user operations
- **Riverpod**: User selection and filtering

**Widget Hierarchy**:
```dart
UserManagementScreen
├── Scaffold (no bottom navigation)
│   ├── AppBar with back button
│   ├── FloatingActionButton (Create User)
│   └── UserList
│       ├── UserCard
│       │   ├── User Info
│       │   ├── Role Badge
│       │   ├── Status Indicator
│       │   └── Action Menu
│       └── EmptyState
```

**Features**:
- User creation, editing, deletion
- Role management
- Status control (active/inactive)
- Bulk operations

### Activity & Monitoring

#### 10. Activity Screen (`screens/activity/new_activity_page.dart`)
**Purpose**: Display user activity logs with filtering and pagination

**State Management**:
- **BLoC**: Activity-specific BLoC for activity operations
- **Riverpod**: Activity filtering and pagination state

**Widget Hierarchy**:
```dart
NewActivityPage
├── Scaffold (no bottom navigation)
│   ├── AppBar with back button
│   └── Column
│       ├── QuickAccessWidget (4 cards, stats grid style)
│       └── ActivityList
│           ├── ActivityCard (color-coded icons)
│           ├── Infinite Scroll (25 items per page)
│           └── Skeleton Loading States
```

**Features**:
- Activity type filtering (login, logout, upload, download, delete, view)
- Color-coded icons for each activity type
- 25 items per page with infinite scroll
- Skeleton loading states
- Lazy loading for performance

#### 11. Upload Document Screen (`screens/upload/upload_document_screen.dart`)
**Purpose**: File upload with category selection and validation

**State Management**:
- **BLoC**: `UploadBloc` for upload operations
- **Riverpod**: File selection and upload progress

**Widget Hierarchy**:
```dart
UploadDocumentScreen
├── AppScaffoldWithNavigation
│   └── Form
│       ├── File Selection Area
│       ├── Category Dropdown
│       ├── File Preview
│       ├── Upload Progress
│       └── Upload Button
```

**Features**:
- Hybrid upload processing (client + cloud function)
- File type validation (PDF, DOC, DOCX, XLS, XLSX, PPT, PPTX)
- 15MB size limit
- Real-time upload progress
- Category assignment

## 🛠️ Development Guidelines

### Code Organization Principles

#### Feature-Based Structure
```
lib/features/{feature_name}/
├── bloc/                  # BLoC for complex business logic
├── models/                # Feature-specific models
├── providers/             # Riverpod providers for simple state
├── repositories/          # Data access layer
└── notifiers/             # StateNotifiers for mutable state
```

#### State Management Decision Tree
```
Simple State (UI, Settings) → Riverpod
├── Provider (immutable data)
├── StateProvider (simple mutable state)
├── FutureProvider (async data)
└── StreamProvider (reactive data)

Complex Business Logic → BLoC
├── Authentication flows
├── File operations
├── User management
└── Data synchronization
```

### Naming Conventions

#### Riverpod Providers
```dart
// Pattern: {feature}{Type}Provider
final authStateProvider = StreamProvider<User?>(...);
final currentUserProvider = Provider<UserModel?>(...);
final settingsNotifierProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(...);
```

#### BLoC Components
```dart
// Pattern: {Feature}Bloc, {Feature}Event, {Feature}State
class AuthBloc extends Bloc<AuthEvent, AuthState> { ... }
class AuthEvent { ... }
class AuthState { ... }
```

#### Repository Pattern
```dart
// Pattern: {Feature}Repository (abstract), {Feature}RepositoryImpl
abstract class DocumentRepository { ... }
class DocumentRepositoryImpl extends BaseRepository implements DocumentRepository { ... }
```

### Error Handling Strategy

#### Centralized Error Handling
```dart
// Base classes provide consistent error handling
abstract class BaseNotifier<T> extends StateNotifier<T> {
  void handleError(Object error) {
    // Centralized error logging and user notification
  }
}

abstract class BaseBloc<Event, State> extends Bloc<Event, State> {
  void handleError(Object error, StackTrace stackTrace) {
    // Centralized error handling for BLoCs
  }
}
```

#### Error Recovery Patterns
- **Circuit Breaker**: Prevent cascading failures
- **Retry Logic**: Automatic retry with exponential backoff
- **Fallback States**: Graceful degradation
- **User Feedback**: Clear error messages and recovery actions

### Performance Optimization

#### Memory Management
```dart
// Automatic disposal of resources
class MemoryManagementService {
  static void initialize() {
    // Memory monitoring and cleanup
  }
}
```

#### Network Optimization
```dart
// Optimized network service with caching
class OptimizedNetworkService {
  static void initialize() {
    // Request deduplication and caching
  }
}
```

#### ANR Prevention
```dart
// Application Not Responding prevention
class ANRPrevention {
  static Future<T?> executeWithTimeout<T>(
    Future<T> operation, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    // Timeout handling to prevent ANR
  }
}
```

## 🧪 Testing Strategy

### Testing Architecture

#### Unit Tests (Riverpod Providers)
```dart
// Test Riverpod providers
void main() {
  group('AuthProviders', () {
    test('currentUserProvider returns null when not authenticated', () {
      final container = ProviderContainer();
      final user = container.read(currentUserProvider);
      expect(user, isNull);
    });
  });
}
```

#### BLoC Tests
```dart
// Test BLoC using bloc_test package
void main() {
  group('AuthBloc', () {
    blocTest<AuthBloc, AuthState>(
      'emits [loading, authenticated] when login succeeds',
      build: () => AuthBloc(),
      act: (bloc) => bloc.add(Login(email: 'test@example.com', password: 'password')),
      expect: () => [
        AuthState.loading(),
        AuthState.authenticated(user: mockUser),
      ],
    );
  });
}
```

#### Integration Tests
```dart
// Test complete workflows
void main() {
  group('Document Upload Flow', () {
    testWidgets('uploads document successfully', (tester) async {
      // Test complete upload workflow
    });
  });
}
```

#### Performance Tests
```dart
// Performance benchmarking
void main() {
  group('Performance Tests', () {
    test('startup time is under 3 seconds', () async {
      final stopwatch = Stopwatch()..start();
      await initializeApp();
      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(3000));
    });
  });
}
```

### Test Execution
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/auth_test.dart

# Run with coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Run integration tests
flutter drive --target=test_driver/app.dart
```

### Performance Targets
- **Startup Time**: < 3 seconds
- **Memory Usage**: < 100MB baseline
- **Widget Rebuilds**: < 5ms per rebuild
- **API Response**: < 500ms average
- **Database Queries**: < 20ms average

## 🚀 Deployment

### Build Instructions

#### Development Build
```bash
flutter run --debug
```

#### Production Build

##### Android APK
```bash
flutter build apk --release
```

##### Android App Bundle
```bash
flutter build appbundle --release
```

##### iOS (macOS required)
```bash
flutter build ios --release
```

### Build Configuration
- **Minimum SDK**: Android 21 (Android 5.0)
- **Target SDK**: Android 34
- **iOS Deployment Target**: 12.0

### Environment Configuration

#### Development Environment
```yaml
# pubspec.yaml
environment:
  sdk: ">=3.0.0 <4.0.0"
  flutter: ">=3.8.0"
```

#### Production Deployment
1. **Firebase Project Setup**
   - Production Firebase project
   - Security rules deployment
   - Cloud Functions deployment
   - Performance monitoring

2. **App Store Deployment**
   - Code signing certificates
   - App Store Connect configuration
   - Release notes and metadata

3. **Google Play Deployment**
   - Play Console setup
   - App signing by Google Play
   - Release tracks (internal, alpha, beta, production)

## 📋 Dependencies

### Core Dependencies
```yaml
dependencies:
  # Flutter & Dart
  flutter:
    sdk: flutter

  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  firebase_storage: ^11.5.6
  cloud_functions: ^4.6.6

  # State Management
  flutter_riverpod: ^2.4.9
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  freezed_annotation: ^2.4.1

  # Local Storage
  shared_preferences: ^2.2.2

  # UI & Design
  google_fonts: ^6.1.0
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  flutter_spinkit: ^5.2.0

  # File Handling
  file_selector: ^1.0.3
  image_picker: ^1.0.4
  path_provider: ^2.1.1
  permission_handler: ^11.1.0
  dio: ^5.3.3

  # Utilities
  intl: ^0.18.1
  uuid: ^4.2.1
```

### Development Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter

  # Code Generation
  build_runner: ^2.4.7
  freezed: ^2.4.6
  json_annotation: ^4.8.1
  json_serializable: ^6.7.1

  # Testing
  bloc_test: ^9.1.5
  mocktail: ^1.0.1

  # Linting
  flutter_lints: ^3.0.1
```

## 🔒 Security Features

### Authentication & Authorization
- **Firebase Authentication**: SCRYPT hashing with secure token management
- **Role-Based Access Control**: Admin vs user permissions with granular controls
- **Session Management**: Secure session handling with automatic timeout
- **Multi-Factor Authentication**: Ready for MFA implementation

### Data Security
- **File Type Validation**: Strict file type enforcement (PDF, DOC, DOCX, XLS, XLSX, PPT, PPTX)
- **Size Restrictions**: 15MB file size limit with server-side validation
- **Content Scanning**: File content validation through Cloud Functions
- **Secure Storage Paths**: Organized storage with user isolation

### Monitoring & Auditing
- **Activity Logging**: Comprehensive audit trails for all user actions
- **Security Monitoring**: Real-time security event tracking
- **Error Logging**: Centralized error tracking and monitoring
- **Performance Monitoring**: Application performance and health monitoring

## 🚀 Performance Optimizations

### Memory Management
- **Automatic Disposal**: Resource cleanup and memory management
- **Lazy Loading**: On-demand provider initialization
- **Image Caching**: Efficient image loading and caching
- **Memory Monitoring**: Real-time memory usage tracking

### Network Optimization
- **Request Deduplication**: Prevent duplicate network requests
- **Caching Strategy**: Intelligent caching for frequently accessed data
- **Offline Support**: Graceful offline handling
- **Circuit Breaker**: Prevent cascading failures

### UI Performance
- **Widget Optimization**: Efficient widget rebuilding
- **Skeleton Loading**: Smooth loading states
- **Infinite Scroll**: Optimized list rendering
- **ANR Prevention**: Application Not Responding prevention

## 🤝 Contributing

### Development Workflow
1. **Fork the repository**
2. **Create a feature branch** from `develop`
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Follow coding standards**
   - Use provided linting rules
   - Follow naming conventions
   - Add appropriate tests
4. **Commit with conventional commits**
   ```bash
   git commit -m "feat: add user management functionality"
   ```
5. **Submit a pull request** to `develop` branch

### Code Review Process
- All PRs require review from maintainers
- Automated tests must pass
- Code coverage should not decrease
- Documentation updates required for new features

### Issue Reporting
- Use provided issue templates
- Include reproduction steps
- Provide environment details
- Add relevant labels

## 📄 License

This project is licensed under the BAPELTAN License - see the LICENSE file for details.

## 📞 Support

### Getting Help
- **Documentation**: Check this README and inline code documentation
- **Issues**: Create an issue in the repository for bugs or feature requests
- **Discussions**: Use GitHub Discussions for questions and community support

### Contact Information
- **Development Team**: Contact through repository issues
- **Admin Support**: web.hanif61@gmail.com (for password reset requests)

### Resources
- **Flutter Documentation**: [flutter.dev](https://flutter.dev)
- **Firebase Documentation**: [firebase.google.com](https://firebase.google.com)
- **Riverpod Documentation**: [riverpod.dev](https://riverpod.dev)
- **BLoC Documentation**: [bloclibrary.dev](https://bloclibrary.dev)

---

## 📊 Project Status

**Version**: 1.0.0
**Last Updated**: January 2025
**Flutter Version**: 3.8.0+
**Dart Version**: 3.0.0+
**Firebase SDK**: Latest stable

### Architecture Status
- ✅ **Riverpod + BLoC Hybrid**: Fully implemented
- ✅ **Repository Pattern**: Complete
- ✅ **Clean Architecture**: Established
- ✅ **Object-Oriented Design**: Applied throughout

### Feature Completion
- ✅ **Authentication**: Complete with role-based access
- ✅ **Document Management**: Full CRUD operations
- ✅ **Category System**: Complete with permissions
- ✅ **User Management**: Admin functionality complete
- ✅ **Activity Tracking**: Comprehensive logging
- ✅ **File Upload/Download**: Hybrid processing implemented
- ✅ **Recycle Bin**: Soft delete with recovery
- ✅ **Responsive Design**: Mobile-first approach

---

**Developed with ❤️ using Flutter & Firebase**
**© 2025 BAPELTAN - Document Management System**

