@echo off
echo ========================================
echo 🚀 TESTING: Release Build Login
echo ========================================
echo.

echo 📋 Pre-build Checklist:
echo ✅ App Check disabled in production mode
echo ✅ Network security configuration verified
echo ✅ Firebase configuration present
echo.

echo 🏗️ Building Release APK...
echo.
echo ⏳ This may take several minutes...
flutter clean
flutter pub get
flutter build apk --release

if %errorlevel%==0 (
    echo ✅ Release APK built successfully!
    echo.
    echo 📱 APK Location: build\app\outputs\flutter-apk\app-release.apk
    echo.
    
    echo 🔧 INSTALLATION INSTRUCTIONS:
    echo.
    echo Option 1 - Install via ADB:
    echo    adb install build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo Option 2 - Manual Installation:
    echo    1. Copy APK to your device
    echo    2. Enable "Install from Unknown Sources"
    echo    3. Install the APK
    echo.
    
    echo 🧪 TESTING CHECKLIST:
    echo.
    echo □ Test login with admin@simdoc.com
    echo □ Test on WiFi connection
    echo □ Test on mobile data connection
    echo □ Test on different devices if available
    echo □ Check for any error messages
    echo.
    
    echo 📊 EXPECTED RESULTS:
    echo ✅ Login should work without "gagal silahkan coba lagi" error
    echo ✅ App should connect to Firebase successfully
    echo ✅ User data should load properly after login
    echo.
    
    echo 🚨 IF LOGIN STILL FAILS:
    echo 1. Check device internet connection
    echo 2. Verify Firebase project status
    echo 3. Check Firebase Authentication settings
    echo 4. Run: scripts\diagnose_firebase_connection.bat
    echo.
    
) else (
    echo ❌ Release build failed!
    echo.
    echo 🔧 TROUBLESHOOTING:
    echo 1. Check for build errors above
    echo 2. Ensure all dependencies are installed
    echo 3. Try: flutter doctor
    echo 4. Try: flutter clean && flutter pub get
    echo.
)

pause
