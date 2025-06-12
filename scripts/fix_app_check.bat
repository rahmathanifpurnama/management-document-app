@echo off
echo.
echo ========================================
echo   Firebase App Check "Too Many Attempts" Fix
echo ========================================
echo.

echo Checking current configuration...
echo.

REM Check if firebase_config.dart exists
if not exist "lib\config\firebase_config.dart" (
    echo ❌ Error: firebase_config.dart not found!
    echo Please run this script from the project root directory.
    pause
    exit /b 1
)

REM Check current configuration
findstr "enableAppCheckInDebug.*true" "lib\config\firebase_config.dart" >nul
if %errorlevel%==0 (
    echo ⚠️  App Check is currently ENABLED in debug mode
    echo This may cause "Too many attempts" errors
    echo.
    echo Applying fix...
    
    REM Apply the fix
    powershell -Command "(Get-Content 'lib\config\firebase_config.dart') -replace 'enableAppCheckInDebug\s*=\s*true', 'enableAppCheckInDebug = false' | Set-Content 'lib\config\firebase_config.dart'"
    
    echo ✅ App Check disabled in debug mode
    echo.
) else (
    echo ✅ App Check is already disabled in debug mode
    echo.
)

echo Current configuration:
echo.
findstr "enableAppCheckInDebug" "lib\config\firebase_config.dart"
findstr "enableAppCheckInProduction" "lib\config\firebase_config.dart"
echo.

echo ========================================
echo   Next Steps
echo ========================================
echo.
echo 1. Clean and rebuild your project:
echo    flutter clean
echo    flutter pub get
echo    flutter run
echo.
echo 2. Check the logs for this message:
echo    "🔧 Skipping App Check initialization in debug mode"
echo.
echo 3. The "Too many attempts" error should be resolved
echo.

echo ========================================
echo   Alternative Solutions
echo ========================================
echo.
echo If you want to ENABLE App Check in debug mode:
echo 1. Go to Firebase Console → Project Settings → App Check
echo 2. Register your app for App Check
echo 3. Add debug token: 0D5038C4-B4F2-4628-8AD4-D500B904BA04
echo 4. Set enableAppCheckInDebug = true in firebase_config.dart
echo.

pause
