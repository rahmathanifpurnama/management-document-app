@echo off
REM Real-time Sync Cloud Functions Deployment Script for Windows
REM Usage: deploy-real-time-sync.bat

echo 🚀 Starting Real-time Sync Cloud Functions Deployment...

REM Check if we're in the functions directory
if not exist "package.json" (
    echo [ERROR] Please run this script from the functions directory
    pause
    exit /b 1
)

REM Step 1: Check Firebase CLI
echo [INFO] Checking Firebase CLI...
firebase --version >nul 2>&1
if errorlevel 1 (
    echo [WARNING] Firebase CLI not found. Installing...
    npm install -g firebase-tools
)

REM Step 2: Check login status
echo [INFO] Checking Firebase login status...
firebase projects:list >nul 2>&1
if errorlevel 1 (
    echo [WARNING] Not logged in to Firebase. Please login...
    firebase login
)

REM Step 3: Verify project
echo [INFO] Verifying Firebase project...
for /f "tokens=*" %%i in ('firebase use --current 2^>nul') do set PROJECT_ID=%%i
if "%PROJECT_ID%"=="" (
    echo [WARNING] No Firebase project selected. Please select project...
    firebase use --interactive
)

echo [SUCCESS] Using Firebase project: %PROJECT_ID%

REM Step 4: Install dependencies
echo [INFO] Installing dependencies...
npm install
if errorlevel 1 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)

REM Step 5: Compile TypeScript
echo [INFO] Compiling TypeScript...
npm run build
if errorlevel 1 (
    echo [ERROR] TypeScript compilation failed
    pause
    exit /b 1
)

REM Step 6: Verify new functions exist
echo [INFO] Verifying new real-time sync functions...
findstr /C:"onStorageFileCreated" lib\index.js >nul
if errorlevel 1 (
    echo [WARNING] onStorageFileCreated not found in compiled code
) else (
    echo [SUCCESS] ✓ Function onStorageFileCreated found
)

findstr /C:"onStorageFileDeleted" lib\index.js >nul
if errorlevel 1 (
    echo [WARNING] onStorageFileDeleted not found in compiled code
) else (
    echo [SUCCESS] ✓ Function onStorageFileDeleted found
)

findstr /C:"onAuthUserCreated" lib\index.js >nul
if errorlevel 1 (
    echo [WARNING] onAuthUserCreated not found in compiled code
) else (
    echo [SUCCESS] ✓ Function onAuthUserCreated found
)

findstr /C:"onAuthUserDeleted" lib\index.js >nul
if errorlevel 1 (
    echo [WARNING] onAuthUserDeleted not found in compiled code
) else (
    echo [SUCCESS] ✓ Function onAuthUserDeleted found
)

REM Step 7: Deploy functions
echo [INFO] Deploying real-time sync functions...
echo Functions to be deployed:
echo   - onStorageFileCreated
echo   - onStorageFileDeleted
echo   - onAuthUserCreated
echo   - onAuthUserDeleted
echo.

set /p CONFIRM="Continue with deployment? (y/N): "
if /i "%CONFIRM%"=="y" (
    echo [INFO] Deploying real-time sync functions...
    firebase deploy --only functions:onStorageFileCreated,functions:onStorageFileDeleted,functions:onAuthUserCreated,functions:onAuthUserDeleted
    
    if errorlevel 1 (
        echo [ERROR] Deployment failed. Check the error messages above.
        pause
        exit /b 1
    ) else (
        echo [SUCCESS] 🎉 Real-time sync functions deployed successfully!
        echo.
        echo [INFO] Verifying deployment...
        firebase functions:list | findstr /C:"onStorage onAuth"
        
        echo.
        echo [SUCCESS] ✅ Deployment completed successfully!
        echo.
        echo 📋 Next steps:
        echo 1. Test file upload to Firebase Storage to trigger onStorageFileCreated
        echo 2. Create new user in Firebase Auth to trigger onAuthUserCreated
        echo 3. Monitor logs with: firebase functions:log
        echo 4. Check Firestore collections for auto-created metadata
        echo.
        echo 🔍 Monitor real-time:
        echo firebase functions:log --only onStorageFileCreated
        echo firebase functions:log --only onAuthUserCreated
    )
) else (
    echo [WARNING] Deployment cancelled by user
)

echo.
echo [SUCCESS] 🚀 Real-time sync deployment script completed!
pause
