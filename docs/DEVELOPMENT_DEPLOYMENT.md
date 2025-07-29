# Development and Deployment Guide

## Development Environment Setup

### Prerequisites
- **Flutter SDK**: 3.8.0 or higher
- **Dart SDK**: 3.0.0 or higher
- **Android Studio**: Latest stable version
- **VS Code**: With Flutter and Dart extensions
- **Git**: For version control
- **Node.js**: 16+ for Firebase Functions
- **Firebase CLI**: For deployment

### Initial Setup

#### 1. Clone Repository
```bash
git clone <repository-url>
cd management-document-app
```

#### 2. Install Dependencies
```bash
# Flutter dependencies
flutter pub get

# Firebase Functions dependencies
cd functions
npm install
cd ..
```

#### 3. Firebase Configuration

##### Development Environment
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase (if not already done)
firebase init

# Select services:
# - Firestore
# - Functions
# - Storage
# - Hosting (optional)
```

##### Environment Files
Create environment-specific configuration files:

**lib/config/firebase_config_dev.dart**
```dart
class FirebaseConfigDev {
  static const String projectId = 'simdoc-development';
  static const String storageBucket = 'simdoc-development.appspot.com';
  static const String apiKey = 'your-dev-api-key';
  static const String appId = 'your-dev-app-id';
  static const String messagingSenderId = 'your-sender-id';
}
```

**lib/config/firebase_config_prod.dart**
```dart
class FirebaseConfigProd {
  static const String projectId = 'simdoc-production';
  static const String storageBucket = 'simdoc-production.appspot.com';
  static const String apiKey = 'your-prod-api-key';
  static const String appId = 'your-prod-app-id';
  static const String messagingSenderId = 'your-sender-id';
}
```

#### 4. IDE Configuration

##### VS Code Settings (.vscode/settings.json)
```json
{
  "dart.flutterSdkPath": "/path/to/flutter",
  "dart.lineLength": 100,
  "editor.rulers": [100],
  "editor.formatOnSave": true,
  "dart.previewFlutterUiGuides": true,
  "dart.previewFlutterUiGuidesCustomTracking": true,
  "files.associations": {
    "*.dart": "dart"
  }
}
```

##### Launch Configuration (.vscode/launch.json)
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter (Development)",
      "request": "launch",
      "type": "dart",
      "args": ["--flavor", "development", "--dart-define", "ENVIRONMENT=development"]
    },
    {
      "name": "Flutter (Production)",
      "request": "launch",
      "type": "dart",
      "args": ["--flavor", "production", "--dart-define", "ENVIRONMENT=production"]
    }
  ]
}
```

## Development Workflow

### Git Workflow

#### Branch Strategy
```
main (production)
├── develop (development)
│   ├── feature/user-management
│   ├── feature/file-upload
│   ├── hotfix/login-bug
│   └── release/v1.1.0
```

#### Commit Convention
```bash
# Format: type(scope): description
git commit -m "feat(auth): add remember me functionality"
git commit -m "fix(upload): resolve file size validation issue"
git commit -m "docs(readme): update installation instructions"
git commit -m "refactor(bloc): improve error handling in DocumentBloc"
```

#### Types:
- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes
- **refactor**: Code refactoring
- **test**: Adding or updating tests
- **chore**: Maintenance tasks

### Code Quality Standards

#### Linting Configuration (analysis_options.yaml)
```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false

linter:
  rules:
    # Error rules
    avoid_empty_else: true
    avoid_print: true
    avoid_relative_lib_imports: true
    avoid_returning_null_for_future: true
    avoid_slow_async_io: true
    avoid_types_as_parameter_names: true
    cancel_subscriptions: true
    close_sinks: true
    comment_references: true
    control_flow_in_finally: true
    empty_statements: true
    hash_and_equals: true
    invariant_booleans: true
    iterable_contains_unrelated_type: true
    list_remove_unrelated_type: true
    literal_only_boolean_expressions: true
    no_adjacent_strings_in_list: true
    no_duplicate_case_values: true
    prefer_void_to_null: true
    test_types_in_equals: true
    throw_in_finally: true
    unnecessary_statements: true
    unrelated_type_equality_checks: true
    valid_regexps: true

    # Style rules
    always_declare_return_types: true
    always_put_control_body_on_new_line: true
    always_put_required_named_parameters_first: true
    always_require_non_null_named_parameters: true
    annotate_overrides: true
    avoid_annotating_with_dynamic: true
    avoid_bool_literals_in_conditional_expressions: true
    avoid_catches_without_on_clauses: true
    avoid_catching_errors: true
    avoid_double_and_int_checks: true
    avoid_field_initializers_in_const_classes: true
    avoid_function_literals_in_foreach_calls: true
    avoid_implementing_value_types: true
    avoid_init_to_null: true
    avoid_null_checks_in_equality_operators: true
    avoid_positional_boolean_parameters: true
    avoid_private_typedef_functions: true
    avoid_redundant_argument_values: true
    avoid_renaming_method_parameters: true
    avoid_return_types_on_setters: true
    avoid_returning_null: true
    avoid_returning_null_for_void: true
    avoid_setters_without_getters: true
    avoid_shadowing_type_parameters: true
    avoid_single_cascade_in_expression_statements: true
    avoid_unnecessary_containers: true
    avoid_unused_constructor_parameters: true
    avoid_void_async: true
    await_only_futures: true
    camel_case_extensions: true
    camel_case_types: true
    cascade_invocations: true
    constant_identifier_names: true
    curly_braces_in_flow_control_structures: true
    directives_ordering: true
    empty_catches: true
    empty_constructor_bodies: true
    file_names: true
    flutter_style_todos: true
    implementation_imports: true
    join_return_with_assignment: true
    leading_newlines_in_multiline_strings: true
    library_names: true
    library_prefixes: true
    lines_longer_than_80_chars: false
    non_constant_identifier_names: true
    null_closures: true
    omit_local_variable_types: true
    one_member_abstracts: true
    only_throw_errors: true
    overridden_fields: true
    package_api_docs: true
    package_names: true
    package_prefixed_library_names: true
    parameter_assignments: true
    prefer_adjacent_string_concatenation: true
    prefer_asserts_in_initializer_lists: true
    prefer_asserts_with_message: true
    prefer_collection_literals: true
    prefer_conditional_assignment: true
    prefer_const_constructors: true
    prefer_const_constructors_in_immutables: true
    prefer_const_declarations: true
    prefer_const_literals_to_create_immutables: true
    prefer_constructors_over_static_methods: true
    prefer_contains: true
    prefer_equal_for_default_values: true
    prefer_expression_function_bodies: true
    prefer_final_fields: true
    prefer_final_in_for_each: true
    prefer_final_locals: true
    prefer_for_elements_to_map_fromIterable: true
    prefer_foreach: true
    prefer_function_declarations_over_variables: true
    prefer_generic_function_type_aliases: true
    prefer_if_elements_to_conditional_expressions: true
    prefer_if_null_operators: true
    prefer_initializing_formals: true
    prefer_inlined_adds: true
    prefer_int_literals: true
    prefer_interpolation_to_compose_strings: true
    prefer_is_empty: true
    prefer_is_not_empty: true
    prefer_is_not_operator: true
    prefer_iterable_whereType: true
    prefer_mixin: true
    prefer_null_aware_operators: true
    prefer_relative_imports: true
    prefer_single_quotes: true
    prefer_spread_collections: true
    prefer_typing_uninitialized_variables: true
    provide_deprecation_message: true
    public_member_api_docs: false
    recursive_getters: true
    slash_for_doc_comments: true
    sort_child_properties_last: true
    sort_constructors_first: true
    sort_pub_dependencies: true
    sort_unnamed_constructors_first: true
    type_annotate_public_apis: true
    type_init_formals: true
    unawaited_futures: true
    unnecessary_await_in_return: true
    unnecessary_brace_in_string_interps: true
    unnecessary_const: true
    unnecessary_getters_setters: true
    unnecessary_lambdas: true
    unnecessary_new: true
    unnecessary_null_aware_assignments: true
    unnecessary_null_in_if_null_operators: true
    unnecessary_overrides: true
    unnecessary_parenthesis: true
    unnecessary_raw_strings: true
    unnecessary_string_escapes: true
    unnecessary_string_interpolations: true
    unnecessary_this: true
    use_full_hex_values_for_flutter_colors: true
    use_function_type_syntax_for_parameters: true
    use_rethrow_when_possible: true
    use_setters_to_change_properties: true
    use_string_buffers: true
    use_to_and_as_if_applicable: true
    valid_regexps: true
    void_checks: true
```

#### Pre-commit Hooks
```bash
# Install pre-commit hooks
npm install -g pre-commit

# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: flutter-analyze
        name: Flutter Analyze
        entry: flutter analyze
        language: system
        pass_filenames: false
        types: [dart]
      
      - id: flutter-test
        name: Flutter Test
        entry: flutter test
        language: system
        pass_filenames: false
        types: [dart]
      
      - id: dart-format
        name: Dart Format
        entry: dart format --set-exit-if-changed .
        language: system
        pass_filenames: false
        types: [dart]
```

### Testing Strategy

#### Unit Tests
```bash
# Run all unit tests
flutter test

# Run specific test file
flutter test test/unit/auth_service_test.dart

# Run tests with coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

#### Widget Tests
```bash
# Run widget tests
flutter test test/widget/

# Run specific widget test
flutter test test/widget/login_screen_test.dart
```

#### Integration Tests
```bash
# Run integration tests
flutter drive --target=test_driver/app.dart
```

#### Test Structure
```
test/
├── unit/
│   ├── models/
│   ├── services/
│   ├── repositories/
│   └── blocs/
├── widget/
│   ├── screens/
│   └── widgets/
├── integration/
│   ├── auth_flow_test.dart
│   ├── upload_flow_test.dart
│   └── user_management_test.dart
└── test_driver/
    ├── app.dart
    └── app_test.dart
```

## Build and Deployment

### Build Configuration

#### Android Build Configuration

**android/app/build.gradle**
```gradle
android {
    compileSdkVersion 34
    ndkVersion flutter.ndkVersion

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    defaultConfig {
        applicationId "com.bapeltan.simdoc"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
        multiDexEnabled true
    }

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
        debug {
            signingConfig signingConfigs.debug
            debuggable true
        }
    }

    flavorDimensions "environment"
    productFlavors {
        development {
            dimension "environment"
            applicationIdSuffix ".dev"
            versionNameSuffix "-dev"
            resValue "string", "app_name", "SimDoc Dev"
        }
        production {
            dimension "environment"
            resValue "string", "app_name", "SimDoc"
        }
    }
}
```

#### iOS Build Configuration

**ios/Runner/Info.plist**
```xml
<key>CFBundleDisplayName</key>
<string>SimDoc</string>
<key>CFBundleIdentifier</key>
<string>com.bapeltan.simdoc</string>
<key>CFBundleVersion</key>
<string>$(FLUTTER_BUILD_NUMBER)</string>
<key>CFBundleShortVersionString</key>
<string>$(FLUTTER_BUILD_NAME)</string>
```

### Build Commands

#### Development Builds
```bash
# Debug build
flutter run --debug --flavor development

# Profile build
flutter run --profile --flavor development

# Release build for testing
flutter build apk --release --flavor development
```

#### Production Builds
```bash
# Android APK
flutter build apk --release --flavor production

# Android App Bundle (recommended for Play Store)
flutter build appbundle --release --flavor production

# iOS (requires macOS and Xcode)
flutter build ios --release --flavor production
```

### Deployment Pipeline

#### CI/CD with GitHub Actions

**.github/workflows/ci.yml**
```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.8.0'
        channel: 'stable'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Run analyzer
      run: flutter analyze
    
    - name: Run tests
      run: flutter test --coverage
    
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        file: coverage/lcov.info

  build-android:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.8.0'
        channel: 'stable'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Build APK
      run: flutter build apk --release --flavor production
    
    - name: Build App Bundle
      run: flutter build appbundle --release --flavor production
    
    - name: Upload artifacts
      uses: actions/upload-artifact@v3
      with:
        name: android-builds
        path: |
          build/app/outputs/flutter-apk/app-production-release.apk
          build/app/outputs/bundle/productionRelease/app-production-release.aab

  deploy-firebase:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '16'
    
    - name: Install Firebase CLI
      run: npm install -g firebase-tools
    
    - name: Deploy Firebase Functions
      run: |
        cd functions
        npm install
        npm run build
        firebase deploy --only functions --token ${{ secrets.FIREBASE_TOKEN }}
    
    - name: Deploy Firestore Rules
      run: firebase deploy --only firestore:rules --token ${{ secrets.FIREBASE_TOKEN }}
    
    - name: Deploy Storage Rules
      run: firebase deploy --only storage --token ${{ secrets.FIREBASE_TOKEN }}
```

#### Firebase Deployment

```bash
# Deploy all Firebase services
firebase deploy

# Deploy specific services
firebase deploy --only functions
firebase deploy --only firestore:rules
firebase deploy --only storage

# Deploy to specific project
firebase use production
firebase deploy --only functions
```

### Performance Monitoring

#### Firebase Performance Monitoring
```dart
// lib/main.dart
import 'package:firebase_performance/firebase_performance.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Enable performance monitoring
  FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
  
  runApp(MyApp());
}
```

#### Custom Performance Traces
```dart
class DocumentService {
  Future<List<DocumentModel>> getAllDocuments() async {
    final trace = FirebasePerformance.instance.newTrace('get_all_documents');
    await trace.start();
    
    try {
      final documents = await _fetchDocuments();
      trace.setMetric('document_count', documents.length);
      return documents;
    } finally {
      await trace.stop();
    }
  }
}
```

### Security Considerations

#### Code Obfuscation
```bash
# Build with obfuscation
flutter build apk --release --obfuscate --split-debug-info=build/debug-info/
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info/
```

#### Environment Variables
```bash
# Use dart-define for sensitive configuration
flutter build apk --release --dart-define=API_KEY=your-api-key --dart-define=ENVIRONMENT=production
```

#### ProGuard Configuration (Android)
**android/app/proguard-rules.pro**
```
# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase rules
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Preserve line numbers for debugging
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
```

This comprehensive development and deployment guide provides all necessary information for setting up, developing, testing, and deploying the SimDoc application following best practices and industry standards.
