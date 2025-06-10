@echo off
echo ========================================
echo   FIREBASE APP CHECK CONFIGURATION
echo ========================================

echo.
echo Current App Check Configuration:
echo.

REM Show current configuration
findstr "enableAppCheckInDebug\|enableAppCheckInProduction" "lib\config\firebase_config.dart"

echo.
echo Available Options:
echo [1] Disable App Check in Debug (Recommended - Fixes "Too many attempts")
echo [2] Enable App Check in Debug (Requires debug token setup)
echo [3] Disable App Check Completely (Debug + Production)
echo [4] Enable App Check Completely (Debug + Production)
echo [5] Production Only (Disable Debug, Enable Production)
echo [6] Show Current Configuration
echo [0] Exit

echo.
set /p choice="Select option (0-6): "

if "%choice%"=="1" goto disable_debug
if "%choice%"=="2" goto enable_debug
if "%choice%"=="3" goto disable_all
if "%choice%"=="4" goto enable_all
if "%choice%"=="5" goto production_only
if "%choice%"=="6" goto show_config
if "%choice%"=="0" goto exit
goto invalid

:disable_debug
echo.
echo [1/2] Disabling App Check in Debug mode...
powershell -Command "(Get-Content 'lib\config\firebase_config.dart') -replace 'enableAppCheckInDebug =\s*true', 'enableAppCheckInDebug = false' | Set-Content 'lib\config\firebase_config.dart'"
echo ✅ App Check disabled in debug mode
goto rebuild

:enable_debug
echo.
echo [1/2] Enabling App Check in Debug mode...
echo ⚠️  WARNING: You need to configure debug token in Firebase Console!
powershell -Command "(Get-Content 'lib\config\firebase_config.dart') -replace 'enableAppCheckInDebug =\s*false', 'enableAppCheckInDebug = true' | Set-Content 'lib\config\firebase_config.dart'"
echo ✅ App Check enabled in debug mode
goto rebuild

:disable_all
echo.
echo [1/2] Disabling App Check completely...
powershell -Command "(Get-Content 'lib\config\firebase_config.dart') -replace 'enableAppCheckInDebug =\s*true', 'enableAppCheckInDebug = false' | Set-Content 'lib\config\firebase_config.dart'"
powershell -Command "(Get-Content 'lib\config\firebase_config.dart') -replace 'enableAppCheckInProduction =\s*true', 'enableAppCheckInProduction = false' | Set-Content 'lib\config\firebase_config.dart'"
echo ✅ App Check disabled completely
goto rebuild

:enable_all
echo.
echo [1/2] Enabling App Check completely...
echo ⚠️  WARNING: You need to configure proper tokens in Firebase Console!
powershell -Command "(Get-Content 'lib\config\firebase_config.dart') -replace 'enableAppCheckInDebug =\s*false', 'enableAppCheckInDebug = true' | Set-Content 'lib\config\firebase_config.dart'"
powershell -Command "(Get-Content 'lib\config\firebase_config.dart') -replace 'enableAppCheckInProduction =\s*false', 'enableAppCheckInProduction = true' | Set-Content 'lib\config\firebase_config.dart'"
echo ✅ App Check enabled completely
goto rebuild

:production_only
echo.
echo [1/2] Setting App Check for Production Only...
powershell -Command "(Get-Content 'lib\config\firebase_config.dart') -replace 'enableAppCheckInDebug =\s*true', 'enableAppCheckInDebug = false' | Set-Content 'lib\config\firebase_config.dart'"
powershell -Command "(Get-Content 'lib\config\firebase_config.dart') -replace 'enableAppCheckInProduction =\s*false', 'enableAppCheckInProduction = true' | Set-Content 'lib\config\firebase_config.dart'"
echo ✅ App Check set for production only
goto rebuild

:show_config
echo.
echo Current Configuration:
findstr "enableAppCheckInDebug\|enableAppCheckInProduction\|appCheckTokenRefreshCooldown" "lib\config\firebase_config.dart"
echo.
pause
goto exit

:rebuild
echo.
echo [2/2] Rebuilding Flutter app...
call flutter clean
call flutter pub get

if %errorlevel% neq 0 (
    echo ❌ ERROR: Flutter rebuild failed!
    pause
    exit /b 1
)

echo.
echo ✅ Configuration updated successfully!
echo.
echo New Configuration:
findstr "enableAppCheckInDebug\|enableAppCheckInProduction" "lib\config\firebase_config.dart"
echo.
echo 📝 Note: Run 'flutter run' to test the changes
goto exit

:invalid
echo.
echo ❌ Invalid option. Please select 0-6.
echo.
pause
goto exit

:exit
echo.
echo Goodbye!
pause
