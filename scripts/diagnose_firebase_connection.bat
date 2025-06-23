@echo off
echo ========================================
echo 🔥 FIREBASE CONNECTION DIAGNOSIS
echo ========================================
echo.

echo 🌐 Testing Firebase Service Connectivity...
echo.

REM Test basic internet connectivity
echo [1/5] 🌍 Testing Basic Internet Connectivity...
ping -n 1 google.com >nul
if %errorlevel%==0 (
    echo ✅ Internet connection is working
) else (
    echo ❌ No internet connection detected
    echo    📝 Check your network connection and try again
    goto :end
)
echo.

REM Test Firebase domains
echo [2/5] 🔥 Testing Firebase Domain Connectivity...
echo.

echo Testing Firebase Authentication...
ping -n 1 identitytoolkit.googleapis.com >nul
if %errorlevel%==0 (
    echo ✅ Firebase Auth domain reachable
) else (
    echo ❌ Firebase Auth domain unreachable
)

echo Testing Firebase Firestore...
ping -n 1 firestore.googleapis.com >nul
if %errorlevel%==0 (
    echo ✅ Firestore domain reachable
) else (
    echo ❌ Firestore domain unreachable
)

echo Testing Firebase Storage...
ping -n 1 firebasestorage.googleapis.com >nul
if %errorlevel%==0 (
    echo ✅ Firebase Storage domain reachable
) else (
    echo ❌ Firebase Storage domain unreachable
)

echo Testing Firebase App Check...
ping -n 1 firebaseappcheck.googleapis.com >nul
if %errorlevel%==0 (
    echo ✅ Firebase App Check domain reachable
) else (
    echo ❌ Firebase App Check domain unreachable
)
echo.

REM Check Firebase project configuration
echo [3/5] 📋 Checking Firebase Project Configuration...
if exist "android\app\google-services.json" (
    echo ✅ google-services.json found
    
    REM Extract project ID from google-services.json
    for /f "tokens=2 delims=:" %%a in ('findstr "project_id" "android\app\google-services.json"') do (
        set project_id=%%a
        set project_id=!project_id: =!
        set project_id=!project_id:"=!
        set project_id=!project_id:,=!
    )
    
    if defined project_id (
        echo 📋 Project ID: %project_id%
    )
) else (
    echo ❌ google-services.json NOT found
    echo    📝 Download from Firebase Console
)
echo.

REM Check authentication configuration
echo [4/5] 🔐 Checking Authentication Configuration...
echo.
echo ℹ️  Please verify in Firebase Console:
echo    1. Authentication is enabled
echo    2. Email/Password provider is enabled
echo    3. User admin@simdoc.com exists
echo    4. User is enabled (not disabled)
echo.

REM Check App Check configuration
echo [5/5] 🛡️ Checking App Check Configuration...
findstr "enableAppCheckInProduction.*false" "lib\config\firebase_config.dart" >nul
if %errorlevel%==0 (
    echo ✅ App Check is disabled in production (recommended for now)
    echo    This should resolve login issues
) else (
    echo ⚠️  App Check may be enabled in production
    echo    This could cause login failures if not properly configured
)
echo.

echo 💡 COMMON SOLUTIONS:
echo.
echo 🔧 If login still fails after fixes:
echo    1. Verify device has stable internet connection
echo    2. Try different network (WiFi vs Mobile Data)
echo    3. Check if Firebase project has billing enabled
echo    4. Verify Firebase project is not suspended
echo    5. Check Firebase Authentication quotas
echo.
echo 📱 Device-specific issues:
echo    1. Clear app data and cache
echo    2. Restart device
echo    3. Check device date/time settings
echo    4. Disable VPN if active
echo    5. Try on different device
echo.

:end
pause
