@echo off
REM Firebase Test Lab Test Execution Script for Windows
REM This script runs integration tests on Firebase Test Lab

echo ========================================
echo Firebase Test Lab Test Execution
echo ========================================

REM Set variables
set PROJECT_ID=your-firebase-project-id
set RESULTS_BUCKET=gs://your-project-test-results
set TEST_TIMEOUT=60m

REM Check if Firebase CLI is installed
firebase --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Firebase CLI is not installed or not in PATH
    echo Please install Firebase CLI: npm install -g firebase-tools
    exit /b 1
)

REM Check if Flutter is installed
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Flutter is not installed or not in PATH
    echo Please install Flutter and add it to PATH
    exit /b 1
)

REM Check if gcloud is installed
gcloud --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Google Cloud SDK is not installed or not in PATH
    echo Please install Google Cloud SDK
    exit /b 1
)

echo Checking Firebase project configuration...
firebase projects:list

echo.
echo Building Flutter app for testing...

REM Build Android APK for testing
echo Building Android APK...
flutter build apk --debug
if %errorlevel% neq 0 (
    echo Error: Failed to build Android APK
    exit /b 1
)

REM Build integration test APK
echo Building integration test APK...
flutter build apk --debug integration_test/app_test.dart
if %errorlevel% neq 0 (
    echo Error: Failed to build integration test APK
    exit /b 1
)

echo.
echo Running tests on Firebase Test Lab...

REM Run Android tests
echo ========================================
echo Running Android Tests
echo ========================================

REM Smoke tests
echo Running smoke tests...
gcloud firebase test android run ^
    --type instrumentation ^
    --app build/app/outputs/flutter-apk/app-debug.apk ^
    --test build/app/outputs/flutter-apk/app-debug-androidTest.apk ^
    --device model=Pixel2,version=28,locale=en,orientation=portrait ^
    --device model=Pixel3,version=30,locale=en,orientation=portrait ^
    --timeout %TEST_TIMEOUT% ^
    --results-bucket %RESULTS_BUCKET% ^
    --results-dir android-smoke-tests-%date:~-4,4%%date:~-10,2%%date:~-7,2%-%time:~0,2%%time:~3,2%%time:~6,2% ^
    --project %PROJECT_ID%

if %errorlevel% neq 0 (
    echo Warning: Some smoke tests failed
)

REM Document management tests
echo Running document management tests...
gcloud firebase test android run ^
    --type instrumentation ^
    --app build/app/outputs/flutter-apk/app-debug.apk ^
    --test build/app/outputs/flutter-apk/app-debug-androidTest.apk ^
    --device model=Pixel4,version=31,locale=en,orientation=portrait ^
    --timeout %TEST_TIMEOUT% ^
    --results-bucket %RESULTS_BUCKET% ^
    --results-dir android-document-tests-%date:~-4,4%%date:~-10,2%%date:~-7,2%-%time:~0,2%%time:~3,2%%time:~6,2% ^
    --project %PROJECT_ID%

if %errorlevel% neq 0 (
    echo Warning: Some document tests failed
)

REM Performance tests
echo Running performance tests...
gcloud firebase test android run ^
    --type instrumentation ^
    --app build/app/outputs/flutter-apk/app-debug.apk ^
    --test build/app/outputs/flutter-apk/app-debug-androidTest.apk ^
    --device model=Pixel5,version=32,locale=en,orientation=portrait ^
    --timeout %TEST_TIMEOUT% ^
    --results-bucket %RESULTS_BUCKET% ^
    --results-dir android-performance-tests-%date:~-4,4%%date:~-10,2%%date:~-7,2%-%time:~0,2%%time:~3,2%%time:~6,2% ^
    --project %PROJECT_ID%

if %errorlevel% neq 0 (
    echo Warning: Some performance tests failed
)

REM Build iOS app if on macOS (this section would need to be run on macOS)
REM echo ========================================
REM echo Building iOS App
REM echo ========================================
REM flutter build ios --debug --no-codesign
REM if %errorlevel% neq 0 (
REM     echo Error: Failed to build iOS app
REM     exit /b 1
REM )

echo.
echo ========================================
echo Test Execution Complete
echo ========================================

echo.
echo Test results are available in:
echo %RESULTS_BUCKET%

echo.
echo To view detailed results, visit:
echo https://console.firebase.google.com/project/%PROJECT_ID%/testlab/histories

echo.
echo To download test results:
echo gsutil -m cp -r %RESULTS_BUCKET%/android-*-tests-* ./test-results/

echo.
echo Script completed successfully!
pause
