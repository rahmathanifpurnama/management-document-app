# Hybrid Authentication Quick Start Guide

## Overview

Get up and running with the Hybrid Authentication System in 15 minutes. This guide covers the essential steps to integrate offline login functionality into your Flutter document management app.

## Prerequisites

- Flutter SDK 3.0+
- Firebase project configured
- Android/iOS development environment
- Basic understanding of Flutter state management

## Step 1: Install Dependencies

Add the required packages to your `pubspec.yaml`:

```yaml
dependencies:
  # Existing dependencies...
  flutter_secure_storage: ^9.2.4
  connectivity_plus: ^6.1.4
  local_auth: ^2.3.0
  crypto: ^3.0.3
  uuid: ^4.2.1
```

Run:
```bash
flutter pub get
```

## Step 2: Initialize Services

Update your `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:managementdoc/core/services/hybrid_auth_service.dart';
import 'package:managementdoc/core/services/connectivity_service.dart';
import 'package:managementdoc/core/services/biometric_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize hybrid auth services
  try {
    await ConnectivityService.instance.initialize();
    await HybridAuthService.instance.initialize();
    await BiometricAuthService.instance.initialize();
    print('✅ Hybrid auth services initialized');
  } catch (e) {
    print('❌ Failed to initialize services: $e');
  }
  
  runApp(MyApp());
}
```

## Step 3: Update AuthProvider

Replace your existing login method in `AuthProvider`:

```dart
// Replace existing login method with this
Future<bool> login(String email, String password, {bool rememberMe = false}) async {
  _setLoading(true);
  _clearError();

  try {
    // Use hybrid auth service
    UserModel? user = await _hybridAuthService.login(
      email,
      password,
      rememberMe: rememberMe, // Important for offline functionality
    );

    if (user != null) {
      _currentUser = user;
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }

    _setError('Login gagal. Silakan coba lagi.');
    return false;
  } catch (e) {
    // Handle hybrid auth errors
    if (e.toString().contains('offline credentials')) {
      _setError('Tidak ada kredensial offline. Login online terlebih dahulu dengan "Ingat Saya".');
    } else if (e.toString().contains('locked')) {
      _setError('Akun terkunci sementara. Coba lagi nanti.');
    } else {
      _setError(e.toString());
    }
    return false;
  } finally {
    _setLoading(false);
  }
}
```

## Step 4: Add Network Status UI

Add network status indicators to your login screen:

```dart
// At the top of your login screen
import 'package:managementdoc/widgets/network_status_widget.dart';

// In your build method, add these widgets:
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          // Network status banner (shows when offline)
          const NetworkStatusBanner(),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Network status indicator (top right)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      NetworkStatusWidget(compact: true),
                    ],
                  ),
                  
                  // Your existing login form...
                  // Logo, email field, password field, etc.
                  
                  // Login button
                  CustomButton(
                    text: 'Login',
                    onPressed: _login,
                    isLoading: authProvider.isLoading,
                  ),
                  
                  // Offline mode info (shows when offline)
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      if (authProvider.isOffline) {
                        return Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.orange),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Mode offline aktif. Gunakan kredensial yang tersimpan.',
                                  style: TextStyle(color: Colors.orange, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
```

## Step 5: Test Offline Functionality

### Test Scenario 1: Store Credentials for Offline Use

1. Ensure you have internet connection
2. Login with "Remember Me" checked
3. Verify login is successful
4. Logout

### Test Scenario 2: Offline Login

1. Disable internet connection (airplane mode or disconnect WiFi)
2. Try to login with the same credentials
3. Should work offline using stored credentials
4. Verify network status shows "Offline"

### Test Scenario 3: Online/Offline Transitions

1. Login while online
2. Disable internet connection
3. App should show offline status
4. Re-enable internet connection
5. App should show online status and sync any pending actions

## Step 6: Add Biometric Authentication (Optional)

### Enable Biometric Login

Add this method to your AuthProvider:

```dart
Future<bool> loginWithBiometric() async {
  if (!_biometricEnabled) {
    _setError('Biometric authentication not available');
    return false;
  }

  _setLoading(true);
  _clearError();

  try {
    final success = await _biometricAuthService.authenticateWithBiometrics();
    if (success && _hybridAuthService.currentAuthState.isAuthenticated) {
      return true;
    }
    _setError('Biometric authentication failed');
    return false;
  } catch (e) {
    _setError('Biometric error: ${e.toString()}');
    return false;
  } finally {
    _setLoading(false);
  }
}
```

### Add Biometric Button to Login Screen

```dart
// Add this after your login button
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    if (authProvider.biometricEnabled && authProvider.isLoggedIn) {
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: ElevatedButton.icon(
          onPressed: authProvider.isLoading ? null : () async {
            final success = await authProvider.loginWithBiometric();
            if (success) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
          icon: const Icon(Icons.fingerprint),
          label: const Text('Login dengan Biometrik'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.withOpacity(0.1),
            foregroundColor: Colors.blue,
            elevation: 0,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  },
),
```

## Step 7: Handle Errors Gracefully

Update your error handling:

```dart
import 'package:managementdoc/core/utils/hybrid_auth_error_handler.dart';

// In your login method's catch block:
catch (e) {
  final userMessage = HybridAuthErrorHandler.handleAuthError(e);
  final suggestions = HybridAuthErrorHandler.getRecoverySuggestions(e);
  
  _setError(userMessage);
  
  // Optionally show recovery suggestions
  if (suggestions.isNotEmpty) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Saran Pemulihan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: suggestions.map((suggestion) => 
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• '),
                  Expanded(child: Text(suggestion)),
                ],
              ),
            ),
          ).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
```

## Step 8: Test Your Implementation

### Basic Testing Checklist

- [ ] Online login works
- [ ] "Remember Me" stores credentials
- [ ] Offline login works with stored credentials
- [ ] Network status indicators appear correctly
- [ ] Error messages are user-friendly
- [ ] Biometric login works (if implemented)
- [ ] App handles network transitions smoothly

### Advanced Testing

```dart
// Add this debug method to test connectivity
void _testConnectivity() async {
  final connectivityService = ConnectivityService.instance;
  final info = await connectivityService.getConnectivityInfo();
  print('Connectivity Info: $info');
  
  final hybridAuthService = HybridAuthService.instance;
  final sessionInfo = hybridAuthService.getSessionInfo();
  print('Session Info: $sessionInfo');
}
```

## Troubleshooting

### Common Issues

**1. "No offline credentials available"**
- Solution: Login online first with "Remember Me" enabled

**2. Biometric authentication not working**
- Check device has biometric sensors
- Ensure biometric data is enrolled in device settings
- Verify app has biometric permissions

**3. Network status not updating**
- Check connectivity service initialization
- Verify internet permissions in AndroidManifest.xml

**4. Session expires too quickly**
- Check system time and date
- Verify session duration configuration

### Debug Information

Add this to see what's happening:

```dart
// In your AuthProvider initializeAuth method
print('🔐 Auth Mode: ${_hybridAuthService.currentAuthState.authMode}');
print('🌐 Online: ${_connectivityService.isOnline}');
print('👆 Biometric Available: ${await _biometricAuthService.isBiometricAvailable()}');
```

## Next Steps

1. **Read the full documentation**: `docs/HYBRID_AUTH_INTEGRATION.md`
2. **Review security considerations**: `docs/HYBRID_AUTH_SECURITY.md`
3. **Run comprehensive tests**: `flutter test test/hybrid_auth_test.dart`
4. **Implement additional features**: Offline sync, advanced biometrics
5. **Monitor and optimize**: Add analytics and performance monitoring

## Support

If you encounter issues:

1. Check the troubleshooting section above
2. Review the comprehensive documentation
3. Run the test suite to identify specific problems
4. Check device logs for detailed error information

## Summary

You now have a working hybrid authentication system that:

- ✅ Supports both online and offline login
- ✅ Provides secure credential storage
- ✅ Shows network status to users
- ✅ Handles errors gracefully
- ✅ Optionally supports biometric authentication

The system will automatically:
- Try online authentication first
- Fall back to offline authentication when needed
- Store credentials securely for offline use
- Show appropriate UI feedback
- Handle network transitions smoothly
