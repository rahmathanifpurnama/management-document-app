# Hybrid Authentication System Integration Guide

## Overview

The Hybrid Authentication System provides seamless online and offline authentication capabilities for the Flutter document management app. It combines Firebase Authentication for online access with secure local credential storage for offline functionality.

## Features

- **Online Authentication**: Firebase Auth integration with real-time connectivity
- **Offline Authentication**: Secure local credential storage with encryption
- **Biometric Authentication**: Fingerprint and face recognition support
- **Session Management**: Automatic token refresh and session validation
- **Security Features**: Account change detection, credential expiration, lockout protection
- **Network Awareness**: Real-time connectivity monitoring and status indicators

## Architecture

### Core Components

1. **HybridAuthService**: Main authentication orchestrator
2. **ConnectivityService**: Network status monitoring
3. **SecureStorageService**: Encrypted local storage
4. **BiometricAuthService**: Biometric authentication handling
5. **OfflineSyncService**: Offline action synchronization
6. **CredentialEncryption**: Password hashing and encryption utilities

### Authentication Flow

```
User Login Request
       ↓
Check Connectivity
       ↓
   Online? ────Yes───→ Firebase Auth ────Success───→ Store Credentials
       ↓                     ↓                            ↓
      No                   Fail                    Update Session
       ↓                     ↓                            ↓
Check Local Credentials ←────┘                    Login Complete
       ↓
   Available? ────Yes───→ Validate Credentials ────Success───→ Login Complete
       ↓                         ↓
      No                       Fail
       ↓                         ↓
   Login Failed ←───────────────┘
```

## Integration Steps

### 1. Dependencies

Ensure these packages are added to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_secure_storage: ^9.2.4
  connectivity_plus: ^6.1.4
  local_auth: ^2.3.0
  crypto: ^3.0.3
  uuid: ^4.2.1
```

### 2. Initialize Services

In your `main.dart`, initialize the hybrid authentication system:

```dart
import 'package:managementdoc/core/services/hybrid_auth_service.dart';
import 'package:managementdoc/core/services/connectivity_service.dart';
import 'package:managementdoc/core/services/biometric_auth_service.dart';
import 'package:managementdoc/core/services/offline_sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize hybrid auth services
  await ConnectivityService.instance.initialize();
  await HybridAuthService.instance.initialize();
  await BiometricAuthService.instance.initialize();
  await OfflineSyncService.instance.initialize();
  
  runApp(MyApp());
}
```

### 3. Update AuthProvider

Replace your existing AuthProvider with the enhanced version that uses HybridAuthService:

```dart
class AuthProvider extends ChangeNotifier {
  final HybridAuthService _hybridAuthService = HybridAuthService.instance;
  final BiometricAuthService _biometricAuthService = BiometricAuthService.instance;
  final ConnectivityService _connectivityService = ConnectivityService.instance;
  
  // ... implementation details in lib/providers/auth_provider.dart
}
```

### 4. Update Login Screen

Enhance your login screen to support offline authentication and biometric login:

```dart
// Add network status indicators
NetworkStatusBanner(),
NetworkStatusWidget(compact: true),

// Add biometric login button
if (_showBiometricOption && authProvider.biometricEnabled) ...[
  ElevatedButton.icon(
    onPressed: _loginWithBiometric,
    icon: Icon(Icons.fingerprint),
    label: Text('Login dengan Biometrik'),
  ),
],

// Add offline mode information
if (authProvider.isOffline) ...[
  Container(
    // Offline mode info UI
  ),
],
```

### 5. Add Network Status UI

Include network status components in your app:

```dart
// In app bar or header
ConnectivityIndicator(),

// In main content areas
NetworkStatusWidget(showDetails: true),

// As banner notification
NetworkStatusBanner(),
```

## Configuration

### Security Settings

Configure security parameters in your app:

```dart
// Session durations
static const Duration _sessionDuration = Duration(hours: 24);
static const Duration _offlineSessionDuration = Duration(hours: 8);

// Security limits
static const int _maxFailedAttempts = 5;
static const Duration _lockoutDuration = Duration(minutes: 15);

// Credential expiration
static const Duration _credentialMaxAge = Duration(days: 30);
```

### Biometric Configuration

Configure biometric authentication options:

```dart
// Enable biometric authentication
await authProvider.enableBiometricAuth();

// Check biometric status
final status = await authProvider.getBiometricStatus();

// Get available biometric types
final types = await authProvider.getAvailableBiometricNames();
```

## Usage Examples

### Basic Login

```dart
// Hybrid login (tries online first, falls back to offline)
final success = await authProvider.login(
  email,
  password,
  rememberMe: true, // Required for offline functionality
);
```

### Biometric Login

```dart
// Login with biometrics
final success = await authProvider.loginWithBiometric();
```

### Check Authentication Status

```dart
// Get current authentication state
final isOnline = authProvider.isOnline;
final authMode = authProvider.authMode;
final isAuthenticated = authProvider.isLoggedIn;

// Get session information
final sessionInfo = hybridAuthService.getSessionInfo();
```

### Handle Connectivity Changes

```dart
// Listen to connectivity changes
authProvider.addListener(() {
  if (authProvider.isOnline) {
    // Handle online state
  } else {
    // Handle offline state
  }
});
```

## Security Considerations

### Password Security

- Passwords are hashed using PBKDF2 with SHA-256
- Unique salt generated for each password
- 100,000 iterations for key derivation
- Constant-time comparison to prevent timing attacks

### Local Storage Security

- Uses `flutter_secure_storage` for encrypted storage
- Platform-specific secure storage (Keychain on iOS, Keystore on Android)
- Credentials encrypted before storage
- Device fingerprinting for additional security

### Session Management

- Automatic token refresh before expiration
- Session validation on app resume
- Account change detection
- Automatic logout on security violations

### Biometric Security

- Biometric data never leaves the device
- Uses platform-specific biometric APIs
- Fallback to device credentials when needed
- Proper error handling for biometric failures

## Error Handling

The system includes comprehensive error handling:

```dart
import 'package:managementdoc/core/utils/hybrid_auth_error_handler.dart';

try {
  await authProvider.login(email, password);
} catch (error) {
  final userMessage = HybridAuthErrorHandler.handleAuthError(error);
  final suggestions = HybridAuthErrorHandler.getRecoverySuggestions(error);
  final isRecoverable = HybridAuthErrorHandler.isRecoverableError(error);
  
  // Show user-friendly error message and recovery options
}
```

## Offline Functionality

### Offline Actions

Actions performed while offline are queued and synchronized when connectivity is restored:

```dart
// Queue offline action
await OfflineSyncService.instance.queueAction(
  type: 'document_view',
  data: {
    'userId': userId,
    'documentId': documentId,
    'timestamp': DateTime.now().toIso8601String(),
  },
  priority: ActionPriority.normal,
);
```

### Sync Status

Monitor offline sync status:

```dart
// Listen to sync status
OfflineSyncService.instance.syncStatusStream.listen((status) {
  print('Pending actions: ${status.pendingActions.length}');
  print('Sync state: ${status.syncState}');
});
```

## Testing

Run the comprehensive test suite:

```bash
flutter test test/hybrid_auth_test.dart
```

The test suite covers:
- Credential encryption and validation
- Offline authentication models
- Service mocking and integration
- Online/offline transitions
- Biometric authentication flows
- Error scenarios

## Troubleshooting

### Common Issues

1. **Biometric not available**: Check device capabilities and user enrollment
2. **Offline login fails**: Ensure "Remember Me" was enabled during online login
3. **Session expires quickly**: Check system time and network connectivity
4. **Sync failures**: Verify Firebase configuration and network permissions

### Debug Information

Enable debug logging:

```dart
// Enable debug prints
debugPrint('🔐 Auth state: ${authProvider.authMode}');
debugPrint('🌐 Online status: ${authProvider.isOnline}');
debugPrint('📱 Biometric enabled: ${authProvider.biometricEnabled}');
```

### Performance Monitoring

Monitor authentication performance:

```dart
// Get session information
final sessionInfo = hybridAuthService.getSessionInfo();
print('Session info: $sessionInfo');

// Check connectivity status
final connectivityInfo = await connectivityService.getConnectivityInfo();
print('Connectivity: $connectivityInfo');
```

## Migration Guide

### From Basic Firebase Auth

1. Install new dependencies
2. Initialize hybrid services
3. Update AuthProvider usage
4. Add network status UI components
5. Test offline functionality
6. Update error handling

### Backward Compatibility

The hybrid system maintains compatibility with existing Firebase Auth:
- Existing users can continue logging in normally
- Firebase Auth sessions are preserved
- Gradual migration to offline capabilities

## Best Practices

1. **Always enable "Remember Me"** for offline functionality
2. **Handle network transitions gracefully** with appropriate UI feedback
3. **Implement proper error handling** with user-friendly messages
4. **Test offline scenarios thoroughly** including edge cases
5. **Monitor session health** and refresh tokens proactively
6. **Secure credential storage** with proper encryption
7. **Validate biometric availability** before offering biometric login
8. **Provide clear offline mode indicators** to users

## Support

For issues or questions regarding the hybrid authentication system:

1. Check the troubleshooting section
2. Review error logs and debug information
3. Test with different network conditions
4. Verify device capabilities for biometric features
5. Consult the comprehensive test suite for usage examples
