@echo off
echo ========================================
echo   TESTING CLOUD FUNCTIONS
echo ========================================

echo.
echo [1/5] Testing Health Check...
echo.

REM Get Firebase project info
for /f "tokens=2 delims=:" %%a in ('firebase projects:list ^| findstr "default"') do set PROJECT_ID=%%a
set PROJECT_ID=%PROJECT_ID: =%

if "%PROJECT_ID%"=="" (
    echo ERROR: Could not determine Firebase project ID
    echo Please run: firebase use --add
    pause
    exit /b 1
)

echo Project ID: %PROJECT_ID%
echo.

REM Test health check endpoint
echo Testing healthCheck function...
curl -X POST "https://us-central1-%PROJECT_ID%.cloudfunctions.net/healthCheck" -H "Content-Type: application/json" -d "{}"

if %errorlevel% neq 0 (
    echo.
    echo WARNING: Health check failed. Functions may not be deployed yet.
    echo.
) else (
    echo.
    echo ✅ Health check passed!
    echo.
)

echo.
echo [2/5] Testing File Validation...
echo.

REM Test file validation (this will fail without auth, but should return auth error)
echo Testing validateFile function...
curl -X POST "https://us-central1-%PROJECT_ID%.cloudfunctions.net/validateFile" -H "Content-Type: application/json" -d "{\"fileName\":\"test.pdf\",\"fileSize\":1024000,\"contentType\":\"application/pdf\"}"

echo.
echo.
echo [3/5] Checking Function List...
echo.

echo Listing deployed functions...
call firebase functions:list

echo.
echo [4/5] Checking Function Logs...
echo.

echo Recent function logs:
call firebase functions:log --limit 10

echo.
echo [5/5] Testing Complete!
echo.
echo ========================================
echo   TEST RESULTS
echo ========================================
echo.
echo Functions should be accessible at:
echo https://us-central1-%PROJECT_ID%.cloudfunctions.net/
echo.
echo Available endpoints:
echo - healthCheck
echo - processFileUpload
echo - validateFile
echo - generateThumbnail
echo - extractMetadata
echo - createCategory
echo - updateCategory
echo - deleteCategory
echo - addFilesToCategory
echo - removeFilesFromCategory
echo - createUser
echo - updateUserPermissions
echo - deleteUser
echo - syncStorageWithFirestore
echo - cleanupOrphanedMetadata
echo - performComprehensiveSync
echo - sendNotification
echo.
echo Next steps:
echo 1. Test upload in Flutter app
echo 2. Monitor Firebase Console for function invocations
echo 3. Check function logs for any errors
echo.
echo If functions are not working:
echo 1. Check Firebase billing is enabled
echo 2. Verify IAM permissions
echo 3. Check function deployment status in Firebase Console
echo.
pause
