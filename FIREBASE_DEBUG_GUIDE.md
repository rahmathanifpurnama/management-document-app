# Firebase Debug Guide

## 🔧 Firebase Connectivity Troubleshooting

This guide helps you diagnose and fix Firebase connectivity issues in the Management Document App.

## 🚀 Quick Access to Debug Tools

### 1. **Debug Screen Access**
- **Development Mode**: Red floating action button on home screen (debug builds only)
- **Settings Menu**: Profile → Settings → Admin Tools → Firebase Debug
- **Direct Navigation**: Use route `/firebase-debug`

### 2. **Debug Features**
- Real-time Firebase connection status
- Network connectivity diagnostics
- Firebase Auth status check
- Firebase Storage connectivity test
- Firebase App Check token verification
- Detailed error reporting with recommendations

## 🔍 Common Issues & Solutions

### **Issue 1: Storage Timeout Errors**
```
I/flutter: ! Operation timeout: Storage List All Files after 10s
I/flutter: ❌ Operation failed: Storage List All Files - TimeoutException
```

**Solutions:**
1. Check internet connection stability
2. Verify Firebase project configuration
3. Check firewall/proxy settings
4. Restart the application

### **Issue 2: App Check Token Errors**
```
W/StorageUtil: Error getting App Check token; using placeholder token instead
W/NetworkRequest: no auth token for request
```

**Solutions:**
1. **Add Debug Token to Firebase Console:**
   - Run the app and check logs for debug token
   - Copy the token from logs: `D/FirebaseAppCheck: Debug token: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX`
   - Go to Firebase Console → App Check → Debug tokens
   - Add the debug token

2. **Configure Network Security (Android):**
   - Ensure `network_security_config.xml` is properly configured
   - Verify AndroidManifest.xml includes network security config

### **Issue 3: Network Connectivity Problems**
```
W/StorageUtil: Error getting App Check token; using placeholder token instead. 
Error: com.google.firebase.FirebaseException: Unable to resolve host "firebaseappcheck.googleapis.com"
```

**Solutions:**
1. Check internet connection
2. Verify DNS settings (try 8.8.8.8 or 1.1.1.1)
3. Disable VPN temporarily
4. Check corporate firewall settings
5. Ensure Firebase domains are whitelisted

## 📱 Using the Debug Screen

### **Connection Status Widget**
- **Green**: All services healthy
- **Orange**: Some issues detected
- **Red**: Critical connectivity problems

### **Detailed Diagnostics**
1. **Network Status**: Internet and Firebase domain accessibility
2. **Authentication**: User login status
3. **Storage**: Firebase Storage connectivity
4. **App Check**: Token verification status

### **Recommendations Section**
The debug screen provides specific recommendations based on detected issues.

## 🛠️ Firebase Console Configuration

### **1. App Check Setup**
1. Go to Firebase Console → App Check
2. Select your Android app
3. Click "Debug tokens" → "Add debug token"
4. Enter the debug token from app logs
5. Save the configuration

### **2. Storage Rules**
Ensure your Firebase Storage rules allow authenticated access:
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### **3. Firestore Rules**
Ensure your Firestore rules allow authenticated access:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 🔧 Network Configuration

### **Android Network Security Config**
The app includes `network_security_config.xml` that allows:
- HTTPS connections to Firebase domains
- Cleartext traffic for development (localhost)
- Proper certificate validation

### **Required Firebase Domains**
Ensure these domains are accessible:
- `firebaseappcheck.googleapis.com`
- `firebasestorage.googleapis.com`
- `firebase.googleapis.com`
- `firestore.googleapis.com`
- `identitytoolkit.googleapis.com`
- `securetoken.googleapis.com`

## 📊 Monitoring & Logging

### **Debug Logs**
The app provides detailed logging for:
- Firebase initialization
- Network connectivity
- Storage operations
- Authentication status
- App Check token management

### **Performance Monitoring**
- Operation timeouts are logged with specific durations
- Failed operations include error details
- Network diagnostics provide latency information

## 🚨 Emergency Troubleshooting

### **If Debug Screen Won't Load**
1. Check if the route is properly registered in `main.dart`
2. Verify all imports are correct
3. Ensure no compilation errors exist
4. Try accessing via Settings menu instead of floating button

### **If Firebase Services Are Completely Unreachable**
1. Verify `google-services.json` is correct and up-to-date
2. Check Firebase project status in console
3. Verify app package name matches Firebase configuration
4. Try creating a new Firebase project for testing

## 📞 Support

If issues persist after following this guide:
1. Check Firebase Console for service status
2. Review Firebase documentation for latest updates
3. Contact system administrator for network/firewall issues
4. Consider using Firebase emulator for local development

## 🔄 Regular Maintenance

### **Weekly Checks**
- Verify debug tokens are still valid
- Check Firebase Console for any alerts
- Monitor app performance metrics

### **Monthly Reviews**
- Update Firebase SDK versions
- Review and update security rules
- Check for new Firebase features that could improve connectivity

---

**Note**: This debug system is designed to work across different development environments without requiring local-specific configurations.
