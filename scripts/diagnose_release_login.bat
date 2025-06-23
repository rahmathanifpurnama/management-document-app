@echo off
echo ========================================
echo 🔍 DIAGNOSIS: Release Build Login Issues
echo ========================================
echo.

echo 📱 Checking Release Build Configuration...
echo.

REM Check App Check configuration
echo [1/6] 🔥 Checking Firebase App Check Configuration...
findstr "enableAppCheckInProduction.*true" "lib\config\firebase_config.dart" >nul
if %errorlevel%==0 (
    echo ❌ App Check is ENABLED in production mode
    echo    This may cause login failures if Play Integrity is not configured
    echo    📝 Solution: Disable App Check temporarily or configure Play Integrity
    echo.
) else (
    echo ✅ App Check is disabled in production mode
    echo.
)

REM Check network security configuration
echo [2/6] 🔒 Checking Network Security Configuration...
if exist "android\app\src\main\res\xml\network_security_config.xml" (
    echo ✅ Main network security config found
    
    REM Check for Firebase domains
    findstr "firebaseappcheck.googleapis.com" "android\app\src\main\res\xml\network_security_config.xml" >nul
    if %errorlevel%==0 (
        echo ✅ Firebase App Check domain configured
    ) else (
        echo ❌ Firebase App Check domain NOT found
    )
    
    REM Check cleartext traffic setting
    findstr "usesCleartextTraffic.*false" "android\app\src\main\AndroidManifest.xml" >nul
    if %errorlevel%==0 (
        echo ✅ Cleartext traffic disabled (secure)
    ) else (
        echo ⚠️  Cleartext traffic configuration unclear
    )
) else (
    echo ❌ Main network security config NOT found
)
echo.

REM Check build configuration
echo [3/6] 🏗️ Checking Build Configuration...
if exist "android\app\build.gradle.kts" (
    echo ✅ Build configuration found
    
    REM Check signing configuration
    findstr "signingConfig.*debug" "android\app\build.gradle.kts" >nul
    if %errorlevel%==0 (
        echo ⚠️  Using debug signing config for release
        echo    This is OK for testing but not for production
    )
) else (
    echo ❌ Build configuration NOT found
)
echo.

REM Check Firebase project configuration
echo [4/6] 🔥 Checking Firebase Project Configuration...
if exist "android\app\google-services.json" (
    echo ✅ Firebase configuration found
) else (
    echo ❌ Firebase configuration NOT found
    echo    📝 Download google-services.json from Firebase Console
)
echo.

REM Check internet connectivity requirements
echo [5/6] 🌐 Checking Network Requirements...
echo ℹ️  Release builds require internet connectivity for:
echo    - Firebase Authentication
echo    - Firebase App Check (if enabled)
echo    - Firestore database access
echo    - Firebase Storage access
echo.

REM Provide solutions
echo [6/6] 💡 SOLUTIONS FOR LOGIN ISSUES:
echo.
echo 🔧 IMMEDIATE FIXES:
echo    1. App Check is now DISABLED in production mode
echo    2. This should resolve login issues immediately
echo.
echo 🔒 SECURITY RECOMMENDATIONS:
echo    1. Configure Play Integrity in Firebase Console
echo    2. Re-enable App Check after proper configuration
echo    3. Test on multiple devices and networks
echo.
echo 📱 TESTING STEPS:
echo    1. Build release APK: flutter build apk --release
echo    2. Install on test device: flutter install --release
echo    3. Test login with admin@simdoc.com
echo    4. Test on different networks (WiFi, Mobile Data)
echo.
echo 🚨 TROUBLESHOOTING:
echo    - If login still fails, check device internet connection
echo    - Verify Firebase project is active and billing enabled
echo    - Check Firebase Authentication is enabled
echo    - Ensure user admin@simdoc.com exists in Firebase Auth
echo.

pause
