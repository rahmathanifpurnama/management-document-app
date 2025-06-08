@echo off
echo ========================================
echo SIMDOC Database Seeder
echo ========================================
echo.

echo Checking for credentials.json...
if not exist credentials.json (
    echo ERROR: credentials.json not found!
    echo Please download Firebase service account key and rename it to credentials.json
    echo.
    pause
    exit /b 1
)

echo Credentials found. Starting seeding process...
echo.

echo Running complete database seeding...
node seed-all.js

echo.
echo ========================================
echo Seeding process completed!
echo ========================================
echo.
pause
