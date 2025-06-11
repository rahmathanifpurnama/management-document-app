@echo off
echo ========================================
echo   FIREBASE AUTHENTICATION SETUP
echo ========================================
echo.

echo This script will help you set up Firebase authentication for the seeder.
echo.

echo Step 1: Download Service Account Key
echo ------------------------------------
echo 1. Open Firebase Console: https://console.firebase.google.com/
echo 2. Select project: document-management-c5a96
echo 3. Go to Project Settings (gear icon) ^> Service Accounts
echo 4. Click "Generate new private key"
echo 5. Download the JSON file
echo 6. Rename it to "service-account-key.json"
echo 7. Place it in this folder: %~dp0
echo.

echo Step 2: Verify File Placement
echo -----------------------------
if exist "%~dp0service-account-key.json" (
    echo ✅ service-account-key.json found!
    echo.
    echo Step 3: Test Connection
    echo ----------------------
    echo Testing Firebase connection...
    node test-connection.js
    if %errorlevel% equ 0 (
        echo.
        echo ✅ Authentication setup successful!
        echo You can now run the seeder with: node seed-all.js
    ) else (
        echo.
        echo ❌ Connection test failed. Please check:
        echo - Service account key file is valid
        echo - Project ID is correct
        echo - Firestore is enabled in Firebase Console
    )
) else (
    echo ❌ service-account-key.json not found!
    echo.
    echo Please follow Step 1 above to download and place the file.
    echo The file should be located at: %~dp0service-account-key.json
)

echo.
echo ========================================
pause
