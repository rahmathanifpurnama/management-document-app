@echo off
echo ========================================
echo Firebase Cloud Functions Setup
echo ========================================

echo.
echo Checking Node.js version...
node --version
if %errorlevel% neq 0 (
    echo Error: Node.js is not installed
    echo Please install Node.js 18 or later from https://nodejs.org/
    pause
    exit /b 1
)

echo.
echo Checking Firebase CLI...
firebase --version
if %errorlevel% neq 0 (
    echo Installing Firebase CLI...
    npm install -g firebase-tools
    if %errorlevel% neq 0 (
        echo Error: Failed to install Firebase CLI
        pause
        exit /b 1
    )
)

echo.
echo Installing project dependencies...
npm install
if %errorlevel% neq 0 (
    echo Error: Failed to install dependencies
    pause
    exit /b 1
)

echo.
echo Setting up TypeScript...
npm run build
if %errorlevel% neq 0 (
    echo Error: TypeScript setup failed
    pause
    exit /b 1
)

echo.
echo Logging into Firebase...
firebase login
if %errorlevel% neq 0 (
    echo Error: Firebase login failed
    pause
    exit /b 1
)

echo.
echo Initializing Firebase project...
cd ..
firebase init
if %errorlevel% neq 0 (
    echo Error: Firebase initialization failed
    pause
    exit /b 1
)

echo.
echo ========================================
echo Setup completed successfully!
echo ========================================
echo.
echo Next steps:
echo 1. Configure your Firebase project settings
echo 2. Update firebase.json if needed
echo 3. Run deploy.bat to deploy functions
echo.
pause
