@echo off
echo ========================================
echo   DEPLOYING CLOUD FUNCTIONS
echo ========================================

echo.
echo [1/4] Building TypeScript functions...
call npm run build
if %errorlevel% neq 0 (
    echo ERROR: Build failed!
    pause
    exit /b 1
)

echo.
echo [2/4] Deploying to Firebase...
call firebase deploy --only functions
if %errorlevel% neq 0 (
    echo ERROR: Deploy failed!
    pause
    exit /b 1
)

echo.
echo [3/4] Testing health check endpoint...
timeout /t 5 /nobreak > nul
echo Testing Cloud Functions availability...

echo.
echo [4/4] Cloud Functions deployed successfully!
echo.
echo Available Functions:
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
echo - healthCheck
echo.
echo ========================================
echo   DEPLOYMENT COMPLETED SUCCESSFULLY!
echo ========================================
echo.
echo Next steps:
echo 1. Update Flutter app to enable Cloud Functions
echo 2. Test upload functionality
echo 3. Monitor Firebase Console for function logs
echo.
pause
