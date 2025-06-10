# Firebase App Check Troubleshooting

## Problem: "Too many attempts" Error

### Symptoms
- Error message: `W/StorageUtil(11752): Error getting App Check token; using placeholder token instead. Error: com.google.firebase.FirebaseException: Too many attempts.`
- Occurs every time files load or page refreshes
- App functionality may be affected

### Root Causes
1. **Debug Token Issues**: App Check debug provider trying to get tokens without proper configuration
2. **Token Refresh Loop**: Excessive token refresh attempts
3. **Missing Debug Token**: No debug token configured in Firebase Console for development

### Solutions Implemented

#### 1. Configurable App Check Initialization
App Check is now configurable through `lib/config/firebase_config.dart`:

```dart
// App Check settings
static const bool enableAppCheckInDebug = false; // Disabled by default for debug
static const bool enableAppCheckInProduction = true; // Enabled for production
static const Duration appCheckTokenRefreshCooldown = Duration(minutes: 1);
```

#### 2. Rate Limited Token Refresh
Token refresh is now rate-limited to prevent "too many attempts":
- Minimum 1-minute cooldown between token refreshes
- Configurable cooldown duration
- Automatic skip of excessive refresh attempts

#### 3. Environment-Specific Configuration
- **Debug Mode**: App Check disabled by default to prevent token issues
- **Production Mode**: App Check enabled with proper providers (Play Integrity, Device Check)

### Configuration Options

#### Option 1: Disable App Check in Debug (Recommended)
Keep the default configuration in `firebase_config.dart`:
```dart
static const bool enableAppCheckInDebug = false;
```

#### Option 2: Enable App Check in Debug with Debug Token
1. Set `enableAppCheckInDebug = true` in `firebase_config.dart`
2. Configure debug token in Firebase Console:
   - Go to Firebase Console → Project Settings → App Check
   - Register your app for App Check
   - Add debug token for development

#### Option 3: Completely Disable App Check
Set both flags to false in `firebase_config.dart`:
```dart
static const bool enableAppCheckInDebug = false;
static const bool enableAppCheckInProduction = false;
```

### Testing the Fix

1. **Clean and Rebuild**:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Check Logs**:
   - Look for: `🔧 Skipping App Check initialization in debug mode (disabled in config)`
   - No more "Too many attempts" errors should appear

3. **Verify Functionality**:
   - File uploads should work normally
   - No placeholder tokens should be used
   - App performance should improve

### Production Deployment

For production builds, ensure:
1. `enableAppCheckInProduction = true`
2. Proper App Check providers are configured:
   - Android: Play Integrity API
   - iOS: Device Check API
3. App is registered in Firebase Console App Check section

### Additional Notes

- App Check is a security feature but not critical for app functionality
- The app will continue to work even if App Check fails to initialize
- Debug mode now skips App Check to prevent development issues
- Production mode uses proper attestation providers for security

### Monitoring

Monitor these log messages:
- `✅ App Check initialized for production mode` - Success in production
- `🔧 Skipping App Check initialization in debug mode` - Expected in debug
- `⚠️ App Check initialization failed` - Check configuration if this appears
- `🔄 App Check token refresh skipped (rate limited)` - Rate limiting working
