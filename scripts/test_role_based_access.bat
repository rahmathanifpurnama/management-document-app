@echo off
REM Firebase Test Lab - Role-Based Access Testing Script (Windows)
REM Usage: scripts\test_role_based_access.bat --project PROJECT_ID [OPTIONS]

setlocal enabledelayedexpansion

REM Default values
set PROJECT_ID=
set DEVICE=model=Pixel3,version=30,locale=en,orientation=portrait
set TIMEOUT=30m
set RESULTS_BUCKET=
set TEST_TYPE=both
set RECORD_VIDEO=false

REM Parse command line arguments
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
if "%~1"=="--bucket" (
    set RESULTS_BUCKET=%~2
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
if "%~1"=="--record-video" (
    set RECORD_VIDEO=true
    shift
    goto parse_args
)
if "%~1"=="--help" (
    goto show_usage
)
echo [ERROR] Unknown option: %~1
goto show_usage

:validate_args
if "%PROJECT_ID%"=="" (
    echo [ERROR] Project ID is required
    goto show_usage
)

REM Set default results bucket if not provided
if "%RESULTS_BUCKET%"=="" (
    set RESULTS_BUCKET=gs://%PROJECT_ID%-test-results
)

REM Validate test type
if not "%TEST_TYPE%"=="admin" if not "%TEST_TYPE%"=="user" if not "%TEST_TYPE%"=="both" (
    echo [ERROR] Invalid test type: %TEST_TYPE%. Must be 'admin', 'user', or 'both'
    exit /b 1
)

echo [INFO] Starting role-based access testing...
echo [INFO] Project: %PROJECT_ID%
echo [INFO] Device: %DEVICE%
echo [INFO] Test Type: %TEST_TYPE%
echo [INFO] Timeout: %TIMEOUT%
echo [INFO] Results Bucket: %RESULTS_BUCKET%

REM Check if APK exists
set APK_PATH=build\app\outputs\flutter-apk\app-debug.apk
set TEST_APK_PATH=build\app\outputs\flutter-apk\app-debug-androidTest.apk

if not exist "%APK_PATH%" (
    echo [ERROR] APK not found at %APK_PATH%
    echo [INFO] Building APK...
    flutter build apk --debug
    if errorlevel 1 (
        echo [ERROR] Failed to build APK
        exit /b 1
    )
)

if not exist "%TEST_APK_PATH%" (
    echo [ERROR] Test APK not found at %TEST_APK_PATH%
    echo [INFO] Building test APK...
    flutter build apk --debug integration_test\test_flows\role_based_test.dart
    if errorlevel 1 (
        echo [ERROR] Failed to build test APK
        exit /b 1
    )
)

REM Prepare video recording option
set VIDEO_OPTION=
if "%RECORD_VIDEO%"=="true" (
    set VIDEO_OPTION=--record-video
)

REM Run tests based on type
if "%TEST_TYPE%"=="admin" (
    call :run_admin_test
) else if "%TEST_TYPE%"=="user" (
    call :run_user_test
) else if "%TEST_TYPE%"=="both" (
    echo [INFO] Running both admin and user tests...
    call :run_admin_test
    if errorlevel 1 (
        echo [ERROR] Admin test failed, skipping user test
        exit /b 1
    )
    call :run_user_test
)

echo [SUCCESS] Role-based access testing completed!
echo [INFO] Check Firebase Console for detailed results: https://console.firebase.google.com/project/%PROJECT_ID%/testlab/histories/
goto :eof

:run_admin_test
echo [INFO] Running Admin Access Test...

REM Generate timestamp
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "timestamp=%dt:~0,8%-%dt:~8,6%"
set "results_dir=admin-test-%timestamp%"

gcloud firebase test android run ^
    --type instrumentation ^
    --app "%APK_PATH%" ^
    --test "%TEST_APK_PATH%" ^
    --device "%DEVICE%" ^
    --timeout "%TIMEOUT%" ^
    --environment-variables TEST_USER_EMAIL=admin@test.com,TEST_USER_PASSWORD=admin123,TEST_USER_ROLE=admin ^
    --test-targets "class com.example.AdminAccessTest" ^
    --results-bucket "%RESULTS_BUCKET%" ^
    --results-dir "%results_dir%" ^
    %VIDEO_OPTION%

if errorlevel 1 (
    echo [ERROR] Admin test failed
    exit /b 1
) else (
    echo [SUCCESS] Admin test completed successfully
    echo [INFO] Results: %RESULTS_BUCKET%/%results_dir%
)
goto :eof

:run_user_test
echo [INFO] Running User Access Test...

REM Generate timestamp
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "timestamp=%dt:~0,8%-%dt:~8,6%"
set "results_dir=user-test-%timestamp%"

gcloud firebase test android run ^
    --type instrumentation ^
    --app "%APK_PATH%" ^
    --test "%TEST_APK_PATH%" ^
    --device "%DEVICE%" ^
    --timeout "%TIMEOUT%" ^
    --environment-variables TEST_USER_EMAIL=user@test.com,TEST_USER_PASSWORD=user123,TEST_USER_ROLE=user ^
    --test-targets "class com.example.UserAccessTest" ^
    --results-bucket "%RESULTS_BUCKET%" ^
    --results-dir "%results_dir%" ^
    %VIDEO_OPTION%

if errorlevel 1 (
    echo [ERROR] User test failed
    exit /b 1
) else (
    echo [SUCCESS] User test completed successfully
    echo [INFO] Results: %RESULTS_BUCKET%/%results_dir%
)
goto :eof

:show_usage
echo Usage: %0 --project PROJECT_ID [OPTIONS]
echo.
echo Options:
echo   --project PROJECT_ID     Firebase project ID (required)
echo   --device DEVICE_SPEC     Device specification (default: Pixel3,version=30)
echo   --timeout TIMEOUT        Test timeout (default: 30m)
echo   --bucket BUCKET_NAME     Results bucket (default: PROJECT_ID-test-results)
echo   --type TEST_TYPE         Test type: admin, user, both (default: both)
echo   --record-video           Record video during test
echo   --help                   Show this help message
echo.
echo Examples:
echo   %0 --project my-project-id
echo   %0 --project my-project-id --type admin --device "model=Pixel6,version=33"
echo   %0 --project my-project-id --type both --record-video
exit /b 0
