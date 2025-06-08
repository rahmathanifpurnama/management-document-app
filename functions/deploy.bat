@echo off
echo ========================================
echo Firebase Cloud Functions Deployment
echo ========================================

echo.
echo Checking Node.js version...
node --version
if %errorlevel% neq 0 (
    echo Error: Node.js is not installed or not in PATH
    pause
    exit /b 1
)

echo.
echo Checking Firebase CLI...
firebase --version
if %errorlevel% neq 0 (
    echo Error: Firebase CLI is not installed
    echo Please install it with: npm install -g firebase-tools
    pause
    exit /b 1
)

echo.
echo Installing dependencies...
npm install
if %errorlevel% neq 0 (
    echo Error: Failed to install dependencies
    pause
    exit /b 1
)

echo.
echo Running linter...
npm run lint
if %errorlevel% neq 0 (
    echo Warning: Linting failed, but continuing...
)

echo.
echo Building TypeScript...
npm run build
if %errorlevel% neq 0 (
    echo Error: TypeScript build failed
    pause
    exit /b 1
)

echo.
echo Deploying to Firebase...
firebase deploy --only functions
if %errorlevel% neq 0 (
    echo Error: Deployment failed
    pause
    exit /b 1
)

echo.
echo ========================================
echo Deployment completed successfully!
echo ========================================
pause
