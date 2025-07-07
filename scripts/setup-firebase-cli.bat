@echo off
echo ========================================
echo Firebase CLI Setup Script
echo ========================================
echo.

echo Step 1: Checking Node.js installation...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js is not installed or not in PATH
    echo Please install Node.js from https://nodejs.org/
    echo Download the LTS version and restart your terminal after installation
    pause
    exit /b 1
) else (
    echo ✅ Node.js is installed
    node --version
)

echo.
echo Step 2: Checking npm...
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ npm is not available
    pause
    exit /b 1
) else (
    echo ✅ npm is available
    npm --version
)

echo.
echo Step 3: Installing Firebase CLI...
echo This may take a few minutes...
npm install -g firebase-tools
if %errorlevel% neq 0 (
    echo ❌ Failed to install Firebase CLI
    echo Try running as Administrator or check your internet connection
    pause
    exit /b 1
) else (
    echo ✅ Firebase CLI installed successfully
)

echo.
echo Step 4: Verifying Firebase CLI installation...
firebase --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Firebase CLI not found in PATH
    echo Try restarting your terminal
    pause
    exit /b 1
) else (
    echo ✅ Firebase CLI is working
    firebase --version
)

echo.
echo Step 5: Checking project configuration...
if exist ".firebaserc" (
    echo ✅ Firebase project configuration found
    type .firebaserc
) else (
    echo ⚠️ No .firebaserc found - you may need to run 'firebase use --add'
)

echo.
echo ========================================
echo Setup completed! Next steps:
echo 1. Run: firebase login
echo 2. Run: firebase use doc
echo 3. Run: firebase projects:list
echo ========================================
pause
