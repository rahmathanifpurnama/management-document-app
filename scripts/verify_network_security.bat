@echo off
REM Verification script for Android Network Security Configuration
REM This script checks if the network security configuration is properly set up

echo.
echo 🔒 Android Network Security Configuration Verification
echo =====================================================
echo.

REM Check if network security config files exist
echo 📁 Checking network security configuration files...
echo.

if exist "android\app\src\main\res\xml\network_security_config.xml" (
    echo ✅ Main network security config found
) else (
    echo ❌ Main network security config NOT found
    echo    Expected: android\app\src\main\res\xml\network_security_config.xml
)

if exist "android\app\src\debug\res\xml\network_security_config.xml" (
    echo ✅ Debug network security config found
) else (
    echo ❌ Debug network security config NOT found
    echo    Expected: android\app\src\debug\res\xml\network_security_config.xml
)

echo.

REM Check AndroidManifest.xml configuration
echo 📱 Checking AndroidManifest.xml configuration...
echo.

findstr "networkSecurityConfig" "android\app\src\main\AndroidManifest.xml" >nul
if %errorlevel%==0 (
    echo ✅ Main AndroidManifest.xml references network security config
) else (
    echo ❌ Main AndroidManifest.xml does NOT reference network security config
)

findstr "networkSecurityConfig" "android\app\src\debug\AndroidManifest.xml" >nul
if %errorlevel%==0 (
    echo ✅ Debug AndroidManifest.xml references network security config
) else (
    echo ❌ Debug AndroidManifest.xml does NOT reference network security config
)

echo.

REM Check Firebase configuration
echo 🔥 Checking Firebase App Check configuration...
echo.

findstr "enableAppCheckInDebug.*true" "lib\config\firebase_config.dart" >nul
if %errorlevel%==0 (
    echo ✅ App Check enabled in debug mode
) else (
    echo ⚠️  App Check disabled in debug mode
    echo    This is OK if you prefer to keep it disabled
)

findstr "useEnhancedNetworkSecurity.*true" "lib\config\firebase_config.dart" >nul
if %errorlevel%==0 (
    echo ✅ Enhanced network security enabled
) else (
    echo ❌ Enhanced network security NOT enabled
)

echo.

REM Check for Firebase domains in network config
echo 🌐 Checking Firebase domains in network security config...
echo.

findstr "firebaseappcheck.googleapis.com" "android\app\src\main\res\xml\network_security_config.xml" >nul
if %errorlevel%==0 (
    echo ✅ Firebase App Check domain found
) else (
    echo ❌ Firebase App Check domain NOT found
)

findstr "playintegrity.googleapis.com" "android\app\src\main\res\xml\network_security_config.xml" >nul
if %errorlevel%==0 (
    echo ✅ Google Play Integrity domain found
) else (
    echo ❌ Google Play Integrity domain NOT found
)

findstr "trust-anchors" "android\app\src\main\res\xml\network_security_config.xml" >nul
if %errorlevel%==0 (
    echo ✅ Trust anchors configuration found
) else (
    echo ❌ Trust anchors configuration NOT found
)

echo.

REM Check cleartext traffic settings
echo 🔓 Checking cleartext traffic configuration...
echo.

findstr "usesCleartextTraffic.*false" "android\app\src\main\AndroidManifest.xml" >nul
if %errorlevel%==0 (
    echo ✅ Cleartext traffic disabled in main (production security)
) else (
    echo ⚠️  Cleartext traffic not properly configured in main
)

findstr "usesCleartextTraffic.*true" "android\app\src\debug\AndroidManifest.xml" >nul
if %errorlevel%==0 (
    echo ✅ Cleartext traffic enabled in debug (development flexibility)
) else (
    echo ⚠️  Cleartext traffic not properly configured in debug
)

echo.

REM Summary
echo 📋 Verification Summary
echo ======================
echo.
echo If all checks show ✅, your network security configuration is properly set up.
echo If you see ❌ or ⚠️, please review the ANDROID_NETWORK_SECURITY_FIX.md file.
echo.
echo 🚀 Next steps:
echo 1. Clean and rebuild your project: flutter clean && flutter pub get
echo 2. Run the app and check for App Check token success messages
echo 3. Monitor Firebase Storage access for proper token usage
echo 4. Verify file loading works correctly in the home screen
echo.

pause
