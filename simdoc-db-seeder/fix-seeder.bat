@echo off
echo ========================================
echo SIMDOC Database Seeder - Complete Fix
echo ========================================
echo.

echo Checking Node.js installation...
node --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Node.js is not installed or not in PATH
    echo Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)

echo Node.js found. Running fix script...
echo.

node fix-all-issues.js

echo.
echo ========================================
echo Fix process completed!
echo ========================================
echo.
echo If permissions need to be fixed manually:
echo 1. Follow the instructions shown above
echo 2. Run this script again after fixing permissions
echo.
pause
