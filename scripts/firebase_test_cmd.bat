@echo off
REM Firebase Test Lab Script for Command Prompt/PowerShell
REM Alternative to bash script for Windows users

setlocal enabledelayedexpansion

REM Default values
set PROJECT_ID=
set DEVICE=model=Pixel3,version=30,locale=en,orientation=portrait
set TIMEOUT=30m
set TEST_TYPE=simple

REM Colors (if supported)
set GREEN=[92m
set RED=[91m
set YELLOW=[93m
set BLUE=[94m
set NC=[0m

echo %BLUE%[INFO]%NC% Firebase Test Lab - Windows Command Script
echo.

REM Parse arguments
:parse_args
if "%~1"=="" goto validate_args
if "%~1"=="--project" (
    set PROJECT_ID=%~2
    shift
    shift
    goto parse_args
)
if "%~1"=="--device" (
    set DEVICE=%~2
    shift
    shift
    goto parse_args
)
if "%~1"=="--timeout" (
    set TIMEOUT=%~2
    shift
    shift
    goto parse_args
)
if "%~1"=="--type" (
    set TEST_TYPE=%~2
    shift
    shift
    goto parse_args
)
if "%~1"=="--help" (
    goto show_usage
)
echo %RED%[ERROR]%NC% Unknown option: %~1
goto show_usage

:validate_args
if "%PROJECT_ID%"=="" (
    echo %RED%[ERROR]%NC% Project ID is required
    goto show_usage
)

echo %BLUE%[INFO]%NC% Project: %PROJECT_ID%
echo %BLUE%[INFO]%NC% Device: %DEVICE%
echo %BLUE%[INFO]%NC% Test Type: %TEST_TYPE%
echo %BLUE%[INFO]%NC% Timeout: %TIMEOUT%
echo.

REM Check if gcloud is available
gcloud version >nul 2>&1
if errorlevel 1 (
    echo %RED%[ERROR]%NC% gcloud command not found
    echo %YELLOW%[INFO]%NC% Please install Google Cloud SDK first:
    echo   1. Run: scripts\install_gcloud_sdk.bat
    echo   2. Or download from: https://cloud.google.com/sdk/docs/install-sdk
    echo   3. Restart this terminal after installation
    exit /b 1
)

REM Check if authenticated
gcloud auth list --filter=status:ACTIVE --format="value(account)" >nul 2>&1
if errorlevel 1 (
    echo %YELLOW%[WARNING]%NC% Not authenticated with gcloud
    echo %BLUE%[INFO]%NC% Running gcloud auth login...
    gcloud auth login
    if errorlevel 1 (
        echo %RED%[ERROR]%NC% Authentication failed
        exit /b 1
    )
)

REM Set project
echo %BLUE%[INFO]%NC% Setting project to %PROJECT_ID%...
gcloud config set project %PROJECT_ID%
if errorlevel 1 (
    echo %RED%[ERROR]%NC% Failed to set project
    exit /b 1
)

REM Check if APK exists
set APK_PATH=build\app\outputs\flutter-apk\app-debug.apk
if not exist "%APK_PATH%" (
    echo %YELLOW%[WARNING]%NC% APK not found at %APK_PATH%
    echo %BLUE%[INFO]%NC% Building APK...
    flutter build apk --debug
    if errorlevel 1 (
        echo %RED%[ERROR]%NC% Failed to build APK
        exit /b 1
    )
)

REM Run test based on type
if "%TEST_TYPE%"=="simple" (
    call :run_simple_test
) else if "%TEST_TYPE%"=="robo" (
    call :run_robo_test
) else if "%TEST_TYPE%"=="admin" (
    call :run_role_test admin
) else if "%TEST_TYPE%"=="user" (
    call :run_role_test user
) else (
    echo %RED%[ERROR]%NC% Invalid test type: %TEST_TYPE%
    echo Valid types: simple, robo, admin, user
    exit /b 1
)

echo %GREEN%[SUCCESS]%NC% Test completed!
echo %BLUE%[INFO]%NC% View results: https://console.firebase.google.com/project/%PROJECT_ID%/testlab/histories/
goto :eof

:run_simple_test
echo %BLUE%[INFO]%NC% Running simple instrumentation test...

gcloud firebase test android run ^
    --type instrumentation ^
    --app "%APK_PATH%" ^
    --test "%APK_PATH%" ^
    --device "%DEVICE%" ^
    --timeout "%TIMEOUT%" ^
    --results-bucket gs://%PROJECT_ID%-test-results ^
    --results-dir simple-test-%date:~-4,4%%date:~-10,2%%date:~-7,2%-%time:~0,2%%time:~3,2%%time:~6,2%

if errorlevel 1 (
    echo %RED%[ERROR]%NC% Simple test failed
    exit /b 1
)
goto :eof

:run_robo_test
echo %BLUE%[INFO]%NC% Running Robo test...

gcloud firebase test android run ^
    --type robo ^
    --app "%APK_PATH%" ^
    --device "%DEVICE%" ^
    --timeout "%TIMEOUT%" ^
    --results-bucket gs://%PROJECT_ID%-test-results ^
    --results-dir robo-test-%date:~-4,4%%date:~-10,2%%date:~-7,2%-%time:~0,2%%time:~3,2%%time:~6,2%

if errorlevel 1 (
    echo %RED%[ERROR]%NC% Robo test failed
    exit /b 1
)
goto :eof

:run_role_test
set ROLE=%~1
echo %BLUE%[INFO]%NC% Running %ROLE% role test...

if "%ROLE%"=="admin" (
    set TEST_EMAIL=admin@test.com
    set TEST_PASSWORD=admin123
) else (
    set TEST_EMAIL=user@test.com
    set TEST_PASSWORD=user123
)

REM Check if test APK exists
set TEST_APK_PATH=build\app\outputs\flutter-apk\app-debug-androidTest.apk
if not exist "%TEST_APK_PATH%" (
    echo %YELLOW%[WARNING]%NC% Test APK not found, building...
    flutter build apk --debug integration_test\test_flows\role_based_test.dart
    if errorlevel 1 (
        echo %RED%[ERROR]%NC% Failed to build test APK
        exit /b 1
    )
)

gcloud firebase test android run ^
    --type instrumentation ^
    --app "%APK_PATH%" ^
    --test "%TEST_APK_PATH%" ^
    --device "%DEVICE%" ^
    --timeout "%TIMEOUT%" ^
    --environment-variables TEST_USER_EMAIL=%TEST_EMAIL%,TEST_USER_PASSWORD=%TEST_PASSWORD%,TEST_USER_ROLE=%ROLE% ^
    --results-bucket gs://%PROJECT_ID%-test-results ^
    --results-dir %ROLE%-test-%date:~-4,4%%date:~-10,2%%date:~-7,2%-%time:~0,2%%time:~3,2%%time:~6,2%

if errorlevel 1 (
    echo %RED%[ERROR]%NC% %ROLE% test failed
    exit /b 1
)
goto :eof

:show_usage
echo Usage: %0 --project PROJECT_ID [OPTIONS]
echo.
echo Options:
echo   --project PROJECT_ID     Firebase project ID (required)
echo   --device DEVICE_SPEC     Device specification (default: Pixel3,version=30)
echo   --timeout TIMEOUT        Test timeout (default: 30m)
echo   --type TEST_TYPE         Test type: simple, robo, admin, user (default: simple)
echo   --help                   Show this help message
echo.
echo Examples:
echo   %0 --project my-project-id
echo   %0 --project my-project-id --type robo
echo   %0 --project my-project-id --type admin
echo   %0 --project my-project-id --device "model=Pixel6,version=33"
exit /b 0
