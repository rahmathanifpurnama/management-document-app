# Firebase App Check "Too Many Attempts" Fix

## 🚨 Problem Solved
Fixed the recurring error: `W/StorageUtil: Error getting App Check token; using placeholder token instead. Error: com.google.firebase.FirebaseException: Too many attempts.`

## 🔧 What Was Changed

### 1. Updated Firebase Service (`lib/core/services/firebase_service.dart`)
- ✅ Added configurable App Check initialization
- ✅ Implemented rate limiting for token refresh (1-minute cooldown)
- ✅ Added environment-specific configuration (debug vs production)
- ✅ Added proper error handling and logging

### 2. Added Firebase Configuration (`lib/config/firebase_config.dart`)
- ✅ `enableAppCheckInDebug = false` (disabled by default)
- ✅ `enableAppCheckInProduction = true` (enabled for production)
- ✅ `appCheckTokenRefreshCooldown = Duration(minutes: 1)`

### 3. Created Documentation and Tools
- ✅ Troubleshooting guide: `docs/app_check_troubleshooting.md`
- ✅ Configuration script: `scripts/toggle_app_check.bat`

## 🚀 Quick Fix (Recommended)

The fix is already applied! App Check is now **disabled in debug mode** by default, which prevents the "Too many attempts" error.

### To verify the fix:
```bash
flutter clean
flutter pub get
flutter run
```

You should see this log message:
```
🔧 Skipping App Check initialization in debug mode (disabled in config)
```

## ⚙️ Configuration Options

### Option 1: Keep Current (Recommended)
- Debug: App Check disabled ✅
- Production: App Check enabled ✅
- No "Too many attempts" errors ✅

### Option 2: Use Configuration Script
Run the batch script for easy configuration:
```bash
scripts/toggle_app_check.bat
```

### Option 3: Manual Configuration
Edit `lib/config/firebase_config.dart`:
```dart
// To disable App Check completely
static const bool enableAppCheckInDebug = false;
static const bool enableAppCheckInProduction = false;

// To enable App Check in debug (requires Firebase Console setup)
static const bool enableAppCheckInDebug = true;
static const bool enableAppCheckInProduction = true;
```

## 🔍 How It Works

### Before (Problem)
1. App Check tried to get debug tokens repeatedly
2. Firebase rate-limited the requests
3. "Too many attempts" error occurred
4. Placeholder tokens were used
5. Performance degraded

### After (Solution)
1. App Check is disabled in debug mode by default
2. No token requests in development
3. No rate limiting issues
4. Normal Firebase operations
5. Better performance

### Production Mode
1. App Check uses proper providers (Play Integrity, Device Check)
2. Real attestation tokens are generated
3. Enhanced security for production apps

## 📊 Benefits

- ✅ **No more "Too many attempts" errors**
- ✅ **Faster app loading and file operations**
- ✅ **Better development experience**
- ✅ **Configurable for different environments**
- ✅ **Production security maintained**
- ✅ **Rate limiting prevents future issues**

## 🔐 Security Notes

- **Debug Mode**: App Check disabled for better development experience
- **Production Mode**: App Check enabled with proper attestation
- **Rate Limiting**: Prevents token refresh abuse
- **Graceful Fallback**: App continues working if App Check fails

## 🧪 Testing

### Test the Fix
1. Run the app: `flutter run`
2. Check logs for: `🔧 Skipping App Check initialization in debug mode`
3. Verify no "Too many attempts" errors
4. Test file upload/download functionality

### Test Production Build
1. Build release: `flutter build apk --release`
2. Check logs for: `✅ App Check initialized for production mode`
3. Verify proper App Check functionality

## 📝 Additional Notes

- The fix is backward compatible
- No breaking changes to existing functionality
- App Check can be re-enabled anytime through configuration
- Production security is maintained
- Development experience is improved

## 🆘 If Issues Persist

1. Check `docs/app_check_troubleshooting.md` for detailed troubleshooting
2. Use `scripts/toggle_app_check.bat` to try different configurations
3. Verify Firebase Console App Check settings
4. Check for proper debug token configuration (if enabling debug mode)

## 🎯 Summary

The "Too many attempts" error is now **completely resolved** by:
- Disabling App Check in debug mode (default)
- Adding rate limiting for token refresh
- Providing configurable options
- Maintaining production security

**Result**: Smooth development experience with no App Check token errors! 🎉
