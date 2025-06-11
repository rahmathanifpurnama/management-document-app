@echo off
echo ========================================
echo SIMDOC Database Seeder
echo ========================================
echo.

echo Checking for service account key...
if not exist service-account-key.json (
    echo ERROR: service-account-key.json not found!
    echo.
    echo Please run setup-auth.bat first to configure authentication.
    echo Or manually:
    echo 1. Download Firebase service account key from Firebase Console
    echo 2. Rename it to "service-account-key.json"
    echo 3. Place it in this folder
    echo.
    pause
    exit /b 1
)

echo Service account key found. Testing connection first...
echo.

echo Testing Firebase connection...
node test-connection.js
if %errorlevel% neq 0 (
    echo.
    echo ERROR: Firebase connection test failed!
    echo Please check your service account key and try again.
    pause
    exit /b 1
)

echo.
echo Connection successful! Starting seeding process...
echo.

echo Running complete database seeding...
node seed-all.js

echo.
echo ========================================
echo Seeding process completed!
echo ========================================
echo.
pause
