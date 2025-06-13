# 🔧 Android Manifest Conflict Fix

## 🚨 **Problem Resolved**

**Error Message:**
```
Attribute application@usesCleartextTraffic value=(true) from AndroidManifest.xml:10:9-44
is also present at AndroidManifest.xml:22:9-45 value=(false).
Suggestion: add 'tools:replace="android:usesCleartextTraffic"' to <application> element
```

**Root Cause:**
- Main AndroidManifest.xml sets `android:usesCleartextTraffic="false"` (production security)
- Debug AndroidManifest.xml tries to set `android:usesCleartextTraffic="true"` (development flexibility)
- Android build system detected conflicting values and failed to merge manifests

## ✅ **Solution Implemented**

### **1. Updated Debug AndroidManifest.xml**

**File:** `android/app/src/debug/AndroidManifest.xml`

**Changes:**
- ✅ Added `xmlns:tools="http://schemas.android.com/tools"` namespace
- ✅ Added `tools:replace="android:usesCleartextTraffic,android:networkSecurityConfig"`
- ✅ Explicitly tells Android to use debug values over main manifest values

**Before:**
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:usesCleartextTraffic="true"
        android:networkSecurityConfig="@xml/network_security_config">
```

**After:**
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools">
    <application
        android:usesCleartextTraffic="true"
        android:networkSecurityConfig="@xml/network_security_config"
        tools:replace="android:usesCleartextTraffic,android:networkSecurityConfig">
```

### **2. Updated Main AndroidManifest.xml**

**File:** `android/app/src/main/AndroidManifest.xml`

**Changes:**
- ✅ Added `xmlns:tools="http://schemas.android.com/tools"` namespace for consistency

## 🎯 **How This Fix Works**

### **Build-Specific Behavior**
1. **Debug Builds**: Uses debug AndroidManifest.xml settings
   - `android:usesCleartextTraffic="true"` (allows HTTP for development)
   - Debug-specific network security config
   - Enhanced Firebase App Check debugging

2. **Release Builds**: Uses main AndroidManifest.xml settings
   - `android:usesCleartextTraffic="false"` (enforces HTTPS for security)
   - Production network security config
   - Optimized Firebase App Check for production

### **Manifest Merger Process**
1. Android build system merges main and build-specific manifests
2. `tools:replace` attribute tells merger which values to use when conflicts occur
3. Debug builds get development-friendly settings
4. Release builds get production-secure settings

## 🔍 **Verification**

### **Check the Fix**
Run the verification script:
```bash
scripts/verify_network_security.bat
```

Look for:
```
✅ Debug manifest properly configured to override main manifest
```

### **Test the Build**
```bash
flutter clean
flutter pub get
flutter run
```

Should now build successfully without manifest merger errors.

## 📱 **Expected Results**

### **Debug Mode**
- ✅ Cleartext traffic allowed for development servers
- ✅ Enhanced network security config for Firebase App Check
- ✅ User certificates allowed for debugging
- ✅ Firebase Emulator Suite support

### **Production Mode**
- ✅ Cleartext traffic disabled for security
- ✅ Production network security config
- ✅ Certificate pinning enabled
- ✅ Google Play Integrity API for App Check

## 🚀 **Benefits of This Approach**

1. **Development Flexibility**: Debug builds allow HTTP connections for local development
2. **Production Security**: Release builds enforce HTTPS-only communication
3. **Firebase Compatibility**: Proper network configuration for App Check token retrieval
4. **Build System Compliance**: Follows Android manifest merger best practices

## 🔧 **Troubleshooting**

### **If Build Still Fails**
1. **Clean Project**: `flutter clean && flutter pub get`
2. **Check Syntax**: Verify XML syntax in both manifest files
3. **Verify Namespaces**: Ensure `xmlns:tools` is properly declared
4. **Check Attributes**: Verify `tools:replace` includes all conflicting attributes

### **If Network Issues Persist**
1. **Verify Config**: Run `scripts/verify_network_security.bat`
2. **Check Domains**: Ensure all Firebase domains are in network security config
3. **Test Connectivity**: Verify network access to Firebase services
4. **Monitor Logs**: Check for App Check token success messages

This fix resolves the Android manifest conflict while maintaining the enhanced network security configuration for Firebase App Check.
