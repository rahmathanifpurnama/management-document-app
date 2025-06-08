# Document Management System (SimDoc)

A comprehensive Flutter-based document management application with Firebase integration, designed for efficient document storage, categorization, and user management.

## 🚀 Project Overview

SimDoc is a modern document management system that enables organizations to:
- Store and organize documents in categories
- Manage user access and permissions
- Upload, download, and view various document types
- Track document activities and user interactions
- Provide secure authentication and authorization

## 🏗️ Architecture

### Technology Stack
- **Frontend**: Flutter (Dart)
- **Backend**: Firebase (Firestore, Storage, Authentication)
- **State Management**: Provider Pattern
- **Local Storage**: SharedPreferences
- **File Handling**: Multiple file selector packages for cross-platform support

### Project Structure
```
lib/
├── core/                    # Core application components
│   ├── constants/          # App constants (colors, strings, routes)
│   ├── services/           # Firebase and business logic services
│   ├── utils/              # Utility functions and helpers
│   └── widgets/            # Reusable core widgets
├── models/                 # Data models
├── providers/              # State management providers
├── screens/                # UI screens organized by feature
│   ├── admin/             # User management screens
│   ├── auth/              # Authentication screens
│   ├── category/          # Category management screens
│   ├── common/            # Shared screens (home, etc.)
│   ├── profile/           # User profile screens
│   └── upload/            # File upload screens
├── services/              # Additional services
├── utils/                 # App-specific utilities
└── widgets/               # Feature-specific widgets
    ├── category/          # Category-related widgets
    ├── common/            # Shared widgets
    ├── upload/            # Upload-related widgets
    └── user/              # User-related widgets
```

## 🎯 Features

### Authentication & User Management
- **Secure Login**: Firebase Authentication with email/password
- **Remember Me**: Persistent login sessions
- **User Roles**: Admin and regular user permissions
- **User Management**: Admin can create, edit, and manage users
- **Profile Management**: Users can update their profiles and avatars

### Document Management
- **File Upload**: Support for PDF, DOC, DOCX, XLS, XLSX, PPT, PPTX
- **File Validation**: Type and size restrictions (15MB limit)
- **Firebase Storage**: Secure cloud storage with organized paths
- **Download**: Direct download to device storage
- **File Metadata**: Automatic metadata extraction and storage

### Category System
- **Dynamic Categories**: Create and manage document categories
- **Permissions**: Category-level access control
- **Empty by Default**: Categories start empty, users determine content
- **CRUD Operations**: Full create, read, update, delete functionality

### User Interface
- **Modern Design**: Clean, responsive Material Design
- **Bottom Navigation**: 5-tab navigation with centered upload button
- **Dark Mode**: System-based or manual dark mode toggle
- **File Tables**: Reusable components for consistent file display
- **Search & Filter**: Advanced filtering and search capabilities

### Real-time Features
- **Live Updates**: Real-time synchronization across all components
- **Activity Tracking**: User action logging and monitoring
- **Automatic Refresh**: UI updates immediately after operations

## 🔧 Installation & Setup

### Prerequisites
- Flutter SDK (3.8.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Firebase project setup

### Firebase Configuration
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
2. Enable Authentication, Firestore, and Storage
3. Download `google-services.json` for Android
4. Place the file in `android/app/` directory

### Local Setup
1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Configure Firebase (google-services.json already included)
4. Run the application:
   ```bash
   flutter run
   ```

### Database Seeder (Optional)
A Node.js seeder is available in the `simdoc-db-seeder/` directory:
```bash
cd simdoc-db-seeder
npm install
npm run seed
```

## 🔥 Firebase Integration

### Firestore Collections
- **users**: User profiles and authentication data
- **categories**: Document categories and permissions
- **documents**: Document metadata and references
- **activities**: User activity logs and system events

### Storage Structure
```
/documents/
├── user-uploads/          # User uploaded files
├── categories/            # Category-specific files
└── temp/                  # Temporary upload storage
```

### Security Rules
- Authentication required for all operations
- Role-based access control
- Category-level permissions
- File size and type restrictions

## 📱 Build Instructions

### Development Build
```bash
flutter run --debug
```

### Production Build

#### Android APK
```bash
flutter build apk --release
```

#### Android App Bundle
```bash
flutter build appbundle --release
```

#### iOS (macOS required)
```bash
flutter build ios --release
```

### Build Configuration
- Minimum SDK: Android 21 (Android 5.0)
- Target SDK: Android 34
- iOS Deployment Target: 12.0

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Test Coverage
- Unit tests for models and services
- Widget tests for UI components
- Integration tests for critical user flows

## 📋 Dependencies

### Core Dependencies
- `firebase_core`: Firebase initialization
- `firebase_auth`: Authentication services
- `cloud_firestore`: Database operations
- `firebase_storage`: File storage
- `provider`: State management
- `shared_preferences`: Local storage

### UI Dependencies
- `google_fonts`: Typography
- `flutter_svg`: SVG icon support
- `cached_network_image`: Image caching
- `shimmer`: Loading animations
- `flutter_spinkit`: Loading indicators

### File Handling
- `file_selector`: Cross-platform file selection
- `image_picker`: Image selection
- `path_provider`: File system paths
- `permission_handler`: Device permissions
- `dio`: HTTP client for downloads

## 🔒 Security Features

- Firebase Authentication with SCRYPT hashing
- Role-based access control
- File type validation
- Size restrictions (15MB limit)
- Secure storage paths
- Activity logging and monitoring

## 🚀 Performance Optimizations

- Lazy loading of providers
- Optimized loading widgets
- Image caching
- Efficient state management
- Real-time sync optimization
- Memory management for large files

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the BAPELTAN License - see the LICENSE file for details.

## 📞 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation in the `docs/` directory

---

**Version**: 1.0.0
**Last Updated**: January 2025
**Developed with**: Flutter 3.8.0 & Firebase
