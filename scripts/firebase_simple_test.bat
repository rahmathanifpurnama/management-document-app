@echo off
REM Simple Firebase Test Lab Script for Windows
REM Easy-to-use script for quick testing on Firebase Test Lab

setlocal enabledelayedexpansion

REM Default configuration
set FIREBASE_PROJECT_ID=%FIREBASE_PROJECT_ID%
if "%FIREBASE_PROJECT_ID%"=="" set FIREBASE_PROJECT_ID=your-project-id
set TEST_TYPE=robo
set DEVICE=model=Pixel3,version=30,locale=en,orientation=portrait
set TIMEOUT=15m

echo 🔥 Firebase Test Lab Simple Runner
echo ==================================

REM Parse arguments
:parse_args
if "%~1"=="" goto :start_test
if "%~1"=="--project" (
    set FIREBASE_PROJECT_ID=%~2
    shift
    shift
    goto :parse_args
)
if "%~1"=="--device" (
    set DEVICE=%~2
    shift
    shift
    goto :parse_args
)
if "%~1"=="--timeout" (
    set TIMEOUT=%~2
    shift
    shift
    goto :parse_args
)
if "%~1"=="--instrumentation" (
    set TEST_TYPE=instrumentation
    shift
    goto :parse_args
)
if "%~1"=="--help" (
    echo Usage: %0 [OPTIONS]
    echo.
    echo Options:
    echo   --project PROJECT_ID     Firebase project ID
    echo   --device DEVICE_CONFIG   Device configuration ^(default: Pixel3^)
    echo   --timeout TIMEOUT        Test timeout ^(default: 15m^)
    echo   --instrumentation        Use instrumentation tests instead of robo
    echo   --help                   Show this help
    echo.
    echo Examples:
    echo   %0 --project my-app-123
    echo   %0 --project my-app-123 --device "model=Pixel6,version=33,locale=en,orientation=portrait"
    echo   %0 --project my-app-123 --instrumentation
    exit /b 0
)
echo Unknown option: %~1
exit /b 1

:start_test
REM Validate project ID
if "%FIREBASE_PROJECT_ID%"=="your-project-id" (
    echo ❌ Please set your Firebase project ID
    echo Usage: %0 --project YOUR_PROJECT_ID
    exit /b 1
)

echo 📋 Configuration:
echo   Project ID: %FIREBASE_PROJECT_ID%
echo   Test Type: %TEST_TYPE%
echo   Device: %DEVICE%
echo   Timeout: %TIMEOUT%
echo.

REM Check prerequisites
echo 🔍 Checking prerequisites...

flutter --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Flutter not found. Please install Flutter.
    exit /b 1
)

gcloud --version >nul 2>&1
if errorlevel 1 (
    echo ❌ gcloud CLI not found. Please install Firebase CLI.
    echo Install: npm install -g firebase-tools
    exit /b 1
)

REM Check authentication
gcloud auth list --filter=status:ACTIVE --format="value(account)" >nul 2>&1
if errorlevel 1 (
    echo ❌ Not authenticated with gcloud.
    echo Please run: gcloud auth login
    exit /b 1
)

echo ✅ Prerequisites check passed

REM Set project
echo 🔧 Setting up Firebase project...
gcloud config set project "%FIREBASE_PROJECT_ID%"

REM Build APK
echo 🔨 Building APK...
flutter clean
flutter pub get
flutter build apk --debug

if not exist "build\app\outputs\flutter-apk\app-debug.apk" (
    echo ❌ APK build failed
    exit /b 1
)

echo ✅ APK built successfully

REM Build test APK if needed
if "%TEST_TYPE%"=="instrumentation" (
    echo 🔨 Building test APK...
    
    if exist "integration_test" (
        flutter build apk --debug integration_test\test_flows\auth_flow_test.dart
        
        if not exist "build\app\outputs\flutter-apk\app-debug-androidTest.apk" (
            echo ⚠️ Test APK build failed, switching to robo test
            set TEST_TYPE=robo
        ) else (
            echo ✅ Test APK built successfully
        )
    ) else (
        echo ⚠️ No integration tests found, using robo test
        set TEST_TYPE=robo
    )
)

REM Run test
echo 🚀 Running test on Firebase Test Lab...
echo This may take several minutes...

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "TIMESTAMP=%dt:~0,8%_%dt:~8,6%"
set "RESULTS_DIR=simple-test-%TIMESTAMP%"

if "%TEST_TYPE%"=="robo" (
    echo 🤖 Running Robo test...
    
    gcloud firebase test android run ^
        --type robo ^
        --app build\app\outputs\flutter-apk\app-debug.apk ^
        --device "%DEVICE%" ^
        --timeout "%TIMEOUT%" ^
        --robo-directives login_username=admin@test.com,login_password=admin123 ^
        --results-bucket=gs://%FIREBASE_PROJECT_ID%-test-results ^
        --results-dir=%RESULTS_DIR% ^
        --no-record-video
) else (
    echo 🧪 Running instrumentation test...
    
    gcloud firebase test android run ^
        --type instrumentation ^
        --app build\app\outputs\flutter-apk\app-debug.apk ^
        --test build\app\outputs\flutter-apk\app-debug-androidTest.apk ^
        --device "%DEVICE%" ^
        --timeout "%TIMEOUT%" ^
        --results-bucket=gs://%FIREBASE_PROJECT_ID%-test-results ^
        --results-dir=%RESULTS_DIR% ^
        --no-record-video
)

REM Check result
if %errorlevel% equ 0 (
    echo.
    echo 🎉 Test completed successfully!
    echo.
    echo 📊 Results:
    echo   Firebase Console: https://console.firebase.google.com/project/%FIREBASE_PROJECT_ID%/testlab/histories/
    echo   Results Bucket: gs://%FIREBASE_PROJECT_ID%-test-results/%RESULTS_DIR%
    echo.
    echo 💡 Next steps:
    echo   1. Check the Firebase Console for detailed results
    echo   2. Review any failed tests or crashes
    echo   3. Download logs and screenshots if needed
    echo   4. Run additional tests on different devices if required
) else (
    echo.
    echo ❌ Test failed or encountered errors
    echo.
    echo 🔍 Troubleshooting:
    echo   1. Check the Firebase Console for error details
    echo   2. Verify your APK is working correctly
    echo   3. Check device availability in Test Lab
    echo   4. Review the gcloud command output above
)

echo.
echo 📱 Available devices for testing:
echo   Pixel 2: model=Pixel2,version=28,locale=en,orientation=portrait
echo   Pixel 3: model=Pixel3,version=30,locale=en,orientation=portrait
echo   Pixel 4: model=Pixel4,version=31,locale=en,orientation=portrait
echo   Pixel 6: model=Pixel6,version=33,locale=en,orientation=portrait
echo   Samsung J7: model=j7xelte,version=23,locale=en,orientation=portrait
echo   Nexus 9 Tablet: model=Nexus9,version=25,locale=en,orientation=landscape
echo.
echo 🔄 To test on different device:
echo   %0 --project %FIREBASE_PROJECT_ID% --device "model=Pixel6,version=33,locale=en,orientation=portrait"
