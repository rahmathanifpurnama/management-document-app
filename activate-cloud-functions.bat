@echo off
echo ========================================
echo   ACTIVATING CLOUD FUNCTIONS IN APP
echo ========================================

echo.
echo [1/3] Updating upload configuration...

REM Update UploadConfig to enable Cloud Functions by default
powershell -Command "(Get-Content 'lib\core\config\upload_config.dart') -replace 'enableCloudFunctionsByDefault = false', 'enableCloudFunctionsByDefault = true' | Set-Content 'lib\core\config\upload_config.dart'"

echo Configuration updated successfully!

echo.
echo [2/3] Rebuilding Flutter app...
call flutter clean
call flutter pub get
call flutter build apk --debug

if %errorlevel% neq 0 (
    echo ERROR: Flutter build failed!
    pause
    exit /b 1
)

echo.
echo [3/3] Cloud Functions activated successfully!
echo.
echo ========================================
echo   ACTIVATION COMPLETED!
echo ========================================
echo.
echo Changes made:
echo - Cloud Functions enabled by default
echo - Auto-initialization on first upload
echo - Automatic fallback to traditional upload if CF fails
echo.
echo Next steps:
echo 1. Test upload functionality
echo 2. Check Firebase Console for function logs
echo 3. Monitor app performance
echo.
echo Cloud Functions Features Now Available:
echo - Advanced file validation
echo - Automatic thumbnail generation
echo - Enhanced metadata extraction
echo - Improved error handling
echo - Better performance for large files
echo.
pause
