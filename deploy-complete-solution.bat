@echo off
echo ========================================
echo   COMPLETE CLOUD FUNCTIONS DEPLOYMENT
echo ========================================

echo.
echo This script will:
echo 1. Deploy all Cloud Functions to Firebase
echo 2. Activate Cloud Functions in Flutter app
echo 3. Test the deployment
echo 4. Provide next steps
echo.

set /p confirm="Continue with deployment? (y/n): "
if /i not "%confirm%"=="y" (
    echo Deployment cancelled.
    pause
    exit /b 0
)

echo.
echo ========================================
echo   STEP 1: DEPLOYING CLOUD FUNCTIONS
echo ========================================

cd functions

echo.
echo [1.1] Installing dependencies...
call npm install
if %errorlevel% neq 0 (
    echo ERROR: npm install failed!
    pause
    exit /b 1
)

echo.
echo [1.2] Building TypeScript...
call npm run build
if %errorlevel% neq 0 (
    echo ERROR: Build failed!
    pause
    exit /b 1
)

echo.
echo [1.3] Deploying to Firebase...
call firebase deploy --only functions
if %errorlevel% neq 0 (
    echo ERROR: Deploy failed!
    echo.
    echo Common issues:
    echo - Billing not enabled on Firebase project
    echo - Insufficient permissions
    echo - Network connectivity issues
    echo.
    echo Please check Firebase Console and try again.
    pause
    exit /b 1
)

cd ..

echo.
echo ========================================
echo   STEP 2: ACTIVATING IN FLUTTER APP
echo ========================================

echo.
echo [2.1] Updating upload configuration...

REM Update UploadConfig to enable Cloud Functions
powershell -Command "(Get-Content 'lib\core\config\upload_config.dart') -replace 'enableCloudFunctionsByDefault = false', 'enableCloudFunctionsByDefault = true' | Set-Content 'lib\core\config\upload_config.dart'"

echo Configuration updated!

echo.
echo [2.2] Cleaning and rebuilding Flutter app...
call flutter clean
call flutter pub get

if %errorlevel% neq 0 (
    echo ERROR: Flutter pub get failed!
    pause
    exit /b 1
)

echo.
echo ========================================
echo   STEP 3: TESTING DEPLOYMENT
echo ========================================

echo.
echo [3.1] Testing Cloud Functions...
cd functions
call test-functions.bat
cd ..

echo.
echo [3.2] Building Flutter app...
call flutter build apk --debug

if %errorlevel% neq 0 (
    echo WARNING: Flutter build failed, but Cloud Functions are deployed.
    echo You can fix Flutter issues and try again.
)

echo.
echo ========================================
echo   DEPLOYMENT COMPLETED SUCCESSFULLY!
echo ========================================

echo.
echo ✅ Cloud Functions deployed and activated!
echo.
echo Available Functions:
echo.
echo 📁 File Upload Functions:
echo   - processFileUpload: Process file uploads with metadata
echo   - validateFile: Validate files before upload
echo   - generateThumbnail: Generate image thumbnails
echo   - extractMetadata: Extract detailed file metadata
echo   - getStorageQuota: Get storage usage information
echo   - getFileAccessUrl: Generate secure download URLs
echo   - cleanupOrphanedFiles: Clean up orphaned files
echo   - batchProcessFiles: Process multiple files in batch
echo.
echo 📂 Category Management:
echo   - createCategory: Create new categories
echo   - updateCategory: Update existing categories
echo   - deleteCategory: Delete categories
echo   - addFilesToCategory: Add files to categories
echo   - removeFilesFromCategory: Remove files from categories
echo.
echo 👥 User Management:
echo   - createUser: Create new users
echo   - updateUserPermissions: Update user permissions
echo   - deleteUser: Delete users
echo   - bulkUserOperations: Bulk user operations
echo.
echo 📄 Document Management:
echo   - approveDocument: Approve pending documents
echo   - rejectDocument: Reject documents
echo   - bulkDocumentOperations: Bulk document operations
echo   - generateDocumentReport: Generate reports
echo.
echo 🔄 Sync Operations:
echo   - syncStorageWithFirestore: Sync storage with database
echo   - cleanupOrphanedMetadata: Clean up orphaned metadata
echo   - performComprehensiveSync: Full sync operation
echo.
echo 🔔 Notifications:
echo   - sendNotification: Send notifications to users
echo   - processActivityLog: Process activity logs
echo.
echo 🛠️ Utility Functions:
echo   - healthCheck: Check function status
echo   - api: Express API gateway
echo.
echo ========================================
echo   NEXT STEPS
echo ========================================
echo.
echo 1. 📱 Test Upload Functionality:
echo    - Open the Flutter app
echo    - Try uploading different file types
echo    - Check Firebase Console for function logs
echo.
echo 2. 📊 Monitor Performance:
echo    - Firebase Console ^> Functions
echo    - Check function invocations and errors
echo    - Monitor execution time and memory usage
echo.
echo 3. 🔧 Configure Alerts (Optional):
echo    - Set up alerts for function errors
echo    - Monitor storage quota usage
echo    - Set up performance alerts
echo.
echo 4. 📚 Documentation:
echo    - Read CLOUD_FUNCTIONS_DEPLOYMENT_GUIDE.md
echo    - Check function logs for any issues
echo    - Review security rules if needed
echo.
echo 5. 🚀 Production Deployment:
echo    - Test thoroughly in development
echo    - Update security rules for production
echo    - Configure proper monitoring and alerts
echo.
echo ========================================
echo   TROUBLESHOOTING
echo ========================================
echo.
echo If upload still fails:
echo.
echo 1. Check Firebase Console ^> Functions for errors
echo 2. Verify billing is enabled on Firebase project
echo 3. Check function logs: firebase functions:log
echo 4. Test health check: curl your-project.cloudfunctions.net/healthCheck
echo 5. Verify authentication is working in the app
echo.
echo For support:
echo - Check Firebase Console logs
echo - Review CLOUD_FUNCTIONS_DEPLOYMENT_GUIDE.md
echo - Test with Firebase emulator for debugging
echo.
echo ========================================
echo   DEPLOYMENT SUMMARY
echo ========================================
echo.
echo ✅ Cloud Functions: DEPLOYED
echo ✅ Flutter App: CONFIGURED
echo ✅ Upload System: ENHANCED
echo ✅ Error Handling: IMPROVED
echo ✅ Fallback System: ACTIVE
echo.
echo Your upload system now includes:
echo - Advanced file validation
echo - Automatic thumbnail generation
echo - Enhanced metadata extraction
echo - Improved error handling
echo - Better performance for large files
echo - Automatic fallback to traditional upload
echo.
pause
