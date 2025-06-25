@echo off
REM Comprehensive Test Runner Script for Flutter Management Document App (Windows)
REM This script runs all test suites with detailed reporting and error handling

setlocal enabledelayedexpansion

REM Configuration
set PROJECT_ROOT=%~dp0..
set REPORTS_DIR=%PROJECT_ROOT%\test_reports
set COVERAGE_DIR=%PROJECT_ROOT%\coverage
set TIMESTAMP=%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set TIMESTAMP=%TIMESTAMP: =0%
set LOG_FILE=%REPORTS_DIR%\test_run_%TIMESTAMP%.log

REM Test suite options
set RUN_UNIT_TESTS=true
set RUN_WIDGET_TESTS=true
set RUN_INTEGRATION_TESTS=true
set RUN_PERFORMANCE_TESTS=true
set RUN_DEVICE_COMPATIBILITY_TESTS=true
set GENERATE_COVERAGE=true
set UPLOAD_TO_FIREBASE=false

REM Parse command line arguments
:parse_args
if "%~1"=="" goto :setup
if "%~1"=="--unit-only" (
    set RUN_UNIT_TESTS=true
    set RUN_WIDGET_TESTS=false
    set RUN_INTEGRATION_TESTS=false
    set RUN_PERFORMANCE_TESTS=false
    set RUN_DEVICE_COMPATIBILITY_TESTS=false
    shift
    goto :parse_args
)
if "%~1"=="--widget-only" (
    set RUN_UNIT_TESTS=false
    set RUN_WIDGET_TESTS=true
    set RUN_INTEGRATION_TESTS=false
    set RUN_PERFORMANCE_TESTS=false
    set RUN_DEVICE_COMPATIBILITY_TESTS=false
    shift
    goto :parse_args
)
if "%~1"=="--integration-only" (
    set RUN_UNIT_TESTS=false
    set RUN_WIDGET_TESTS=false
    set RUN_INTEGRATION_TESTS=true
    set RUN_PERFORMANCE_TESTS=false
    set RUN_DEVICE_COMPATIBILITY_TESTS=false
    shift
    goto :parse_args
)
if "%~1"=="--performance-only" (
    set RUN_UNIT_TESTS=false
    set RUN_WIDGET_TESTS=false
    set RUN_INTEGRATION_TESTS=false
    set RUN_PERFORMANCE_TESTS=true
    set RUN_DEVICE_COMPATIBILITY_TESTS=false
    shift
    goto :parse_args
)
if "%~1"=="--no-coverage" (
    set GENERATE_COVERAGE=false
    shift
    goto :parse_args
)
if "%~1"=="--firebase" (
    set UPLOAD_TO_FIREBASE=true
    shift
    goto :parse_args
)
if "%~1"=="--help" (
    echo Usage: %0 [OPTIONS]
    echo Options:
    echo   --unit-only                 Run only unit tests
    echo   --widget-only              Run only widget tests
    echo   --integration-only         Run only integration tests
    echo   --performance-only         Run only performance tests
    echo   --no-coverage             Skip coverage generation
    echo   --firebase                Upload results to Firebase Test Lab
    echo   --help                    Show this help message
    exit /b 0
)
shift
goto :parse_args

:setup
echo ========================================
echo   Flutter App Comprehensive Test Suite
echo ========================================

REM Create directories
if not exist "%REPORTS_DIR%" mkdir "%REPORTS_DIR%"
if not exist "%COVERAGE_DIR%" mkdir "%COVERAGE_DIR%"

REM Navigate to project root
cd /d "%PROJECT_ROOT%"

REM Check Flutter installation
flutter --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Flutter is not installed or not in PATH
    exit /b 1
)

REM Get Flutter version
for /f "tokens=*" %%i in ('flutter --version ^| findstr /r "^Flutter"') do set FLUTTER_VERSION=%%i
echo [INFO] Using %FLUTTER_VERSION%

REM Clean and get dependencies
echo [INFO] Cleaning project and getting dependencies...
flutter clean
flutter pub get

REM Generate necessary files
findstr /c:"build_runner" pubspec.yaml >nul 2>&1
if not errorlevel 1 (
    echo [INFO] Generating code with build_runner...
    flutter packages pub run build_runner build --delete-conflicting-outputs
)

echo [SUCCESS] Test environment setup complete

:run_unit_tests
if "%RUN_UNIT_TESTS%"=="false" goto :run_widget_tests

echo [INFO] Running unit tests...

set UNIT_TEST_FILES=test\services\unit_tests_only.dart test\services\file_hash_service_test.dart test\services\duplicate_detection_service_test.dart test\services\enhanced_services_simple_test.dart test\providers\settings_provider_test.dart

set FAILED_UNIT_TESTS=
for %%f in (%UNIT_TEST_FILES%) do (
    if exist "%%f" (
        echo [INFO] Running %%f
        flutter test "%%f" --reporter=json > "%REPORTS_DIR%\unit_%%~nf_%TIMESTAMP%.json"
        if errorlevel 1 (
            echo [ERROR] %%f failed
            set FAILED_UNIT_TESTS=!FAILED_UNIT_TESTS! %%f
        ) else (
            echo [SUCCESS] %%f passed
        )
    ) else (
        echo [WARNING] Test file not found: %%f
    )
)

REM Run all unit tests with coverage
if "%GENERATE_COVERAGE%"=="true" (
    echo [INFO] Running all unit tests with coverage...
    flutter test test\ --coverage --reporter=json > "%REPORTS_DIR%\unit_tests_all_%TIMESTAMP%.json"
    
    if exist "coverage\lcov.info" (
        echo [SUCCESS] Coverage report generated
    )
) else (
    flutter test test\ --reporter=json > "%REPORTS_DIR%\unit_tests_all_%TIMESTAMP%.json"
)

if "%FAILED_UNIT_TESTS%"=="" (
    echo [SUCCESS] All unit tests passed
) else (
    echo [ERROR] Unit tests failed: %FAILED_UNIT_TESTS%
    set TEST_FAILURES=true
)

:run_widget_tests
if "%RUN_WIDGET_TESTS%"=="false" goto :run_integration_tests

echo [INFO] Running widget tests...

set WIDGET_TEST_FILES=test\widgets\responsive_widget_test.dart test\widgets\component_widget_test.dart test\home_screen_file_loading_test.dart

set FAILED_WIDGET_TESTS=
for %%f in (%WIDGET_TEST_FILES%) do (
    if exist "%%f" (
        echo [INFO] Running %%f
        flutter test "%%f" --reporter=json > "%REPORTS_DIR%\widget_%%~nf_%TIMESTAMP%.json"
        if errorlevel 1 (
            echo [ERROR] %%f failed
            set FAILED_WIDGET_TESTS=!FAILED_WIDGET_TESTS! %%f
        ) else (
            echo [SUCCESS] %%f passed
        )
    ) else (
        echo [WARNING] Test file not found: %%f
    )
)

if "%FAILED_WIDGET_TESTS%"=="" (
    echo [SUCCESS] All widget tests passed
) else (
    echo [ERROR] Widget tests failed: %FAILED_WIDGET_TESTS%
    set TEST_FAILURES=true
)

:run_integration_tests
if "%RUN_INTEGRATION_TESTS%"=="false" goto :run_performance_tests

echo [INFO] Running integration tests...

if not exist "integration_test" (
    echo [WARNING] Integration test directory not found, skipping integration tests
    goto :run_performance_tests
)

set INTEGRATION_TEST_FILES=integration_test\test_flows\auth_flow_test.dart integration_test\test_flows\document_flow_test.dart integration_test\test_flows\navigation_flow_test.dart

set FAILED_INTEGRATION_TESTS=
for %%f in (%INTEGRATION_TEST_FILES%) do (
    if exist "%%f" (
        echo [INFO] Running %%f
        flutter test "%%f" --reporter=json > "%REPORTS_DIR%\integration_%%~nf_%TIMESTAMP%.json"
        if errorlevel 1 (
            echo [ERROR] %%f failed
            set FAILED_INTEGRATION_TESTS=!FAILED_INTEGRATION_TESTS! %%f
        ) else (
            echo [SUCCESS] %%f passed
        )
    ) else (
        echo [WARNING] Test file not found: %%f
    )
)

if "%FAILED_INTEGRATION_TESTS%"=="" (
    echo [SUCCESS] All integration tests passed
) else (
    echo [ERROR] Integration tests failed: %FAILED_INTEGRATION_TESTS%
    set TEST_FAILURES=true
)

:run_performance_tests
if "%RUN_PERFORMANCE_TESTS%"=="false" goto :run_device_compatibility_tests

echo [INFO] Running performance tests...

set PERFORMANCE_TEST_FILES=test\performance\memory_performance_test.dart integration_test\test_flows\performance_test.dart

set FAILED_PERFORMANCE_TESTS=
for %%f in (%PERFORMANCE_TEST_FILES%) do (
    if exist "%%f" (
        echo [INFO] Running %%f
        flutter test "%%f" --reporter=json > "%REPORTS_DIR%\performance_%%~nf_%TIMESTAMP%.json"
        if errorlevel 1 (
            echo [ERROR] %%f failed
            set FAILED_PERFORMANCE_TESTS=!FAILED_PERFORMANCE_TESTS! %%f
        ) else (
            echo [SUCCESS] %%f passed
        )
    ) else (
        echo [WARNING] Test file not found: %%f
    )
)

if "%FAILED_PERFORMANCE_TESTS%"=="" (
    echo [SUCCESS] All performance tests passed
) else (
    echo [ERROR] Performance tests failed: %FAILED_PERFORMANCE_TESTS%
    set TEST_FAILURES=true
)

:run_device_compatibility_tests
if "%RUN_DEVICE_COMPATIBILITY_TESTS%"=="false" goto :generate_report

echo [INFO] Running device compatibility tests...

set COMPATIBILITY_TEST_FILES=test\device_compatibility\device_compatibility_test.dart

set FAILED_COMPATIBILITY_TESTS=
for %%f in (%COMPATIBILITY_TEST_FILES%) do (
    if exist "%%f" (
        echo [INFO] Running %%f
        flutter test "%%f" --reporter=json > "%REPORTS_DIR%\compatibility_%%~nf_%TIMESTAMP%.json"
        if errorlevel 1 (
            echo [ERROR] %%f failed
            set FAILED_COMPATIBILITY_TESTS=!FAILED_COMPATIBILITY_TESTS! %%f
        ) else (
            echo [SUCCESS] %%f passed
        )
    ) else (
        echo [WARNING] Test file not found: %%f
    )
)

if "%FAILED_COMPATIBILITY_TESTS%"=="" (
    echo [SUCCESS] All device compatibility tests passed
) else (
    echo [ERROR] Device compatibility tests failed: %FAILED_COMPATIBILITY_TESTS%
    set TEST_FAILURES=true
)

:generate_report
echo [INFO] Generating comprehensive test report...

set REPORT_FILE=%REPORTS_DIR%\comprehensive_report_%TIMESTAMP%.html

(
echo ^<!DOCTYPE html^>
echo ^<html^>
echo ^<head^>
echo     ^<title^>Test Report - %TIMESTAMP%^</title^>
echo     ^<style^>
echo         body { font-family: Arial, sans-serif; margin: 20px; }
echo         .header { background-color: #f0f0f0; padding: 20px; border-radius: 5px; }
echo         .success { color: green; }
echo         .error { color: red; }
echo         .warning { color: orange; }
echo         .section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
echo         .timestamp { color: #666; font-size: 0.9em; }
echo     ^</style^>
echo ^</head^>
echo ^<body^>
echo     ^<div class="header"^>
echo         ^<h1^>Flutter App Test Report^</h1^>
echo         ^<p class="timestamp"^>Generated: %date% %time%^</p^>
echo         ^<p^>Flutter Version: %FLUTTER_VERSION%^</p^>
echo     ^</div^>
echo     ^<div class="section"^>
echo         ^<h2^>Test Summary^</h2^>
echo         ^<ul^>
if "%RUN_UNIT_TESTS%"=="true" (echo             ^<li^>Unit Tests: ✅ Executed^</li^>) else (echo             ^<li^>Unit Tests: ⏭️ Skipped^</li^>)
if "%RUN_WIDGET_TESTS%"=="true" (echo             ^<li^>Widget Tests: ✅ Executed^</li^>) else (echo             ^<li^>Widget Tests: ⏭️ Skipped^</li^>)
if "%RUN_INTEGRATION_TESTS%"=="true" (echo             ^<li^>Integration Tests: ✅ Executed^</li^>) else (echo             ^<li^>Integration Tests: ⏭️ Skipped^</li^>)
if "%RUN_PERFORMANCE_TESTS%"=="true" (echo             ^<li^>Performance Tests: ✅ Executed^</li^>) else (echo             ^<li^>Performance Tests: ⏭️ Skipped^</li^>)
if "%RUN_DEVICE_COMPATIBILITY_TESTS%"=="true" (echo             ^<li^>Device Compatibility Tests: ✅ Executed^</li^>) else (echo             ^<li^>Device Compatibility Tests: ⏭️ Skipped^</li^>)
echo         ^</ul^>
echo     ^</div^>
echo     ^<div class="section"^>
echo         ^<h2^>Coverage Report^</h2^>
if "%GENERATE_COVERAGE%"=="true" (
    if exist "coverage\lcov.info" (
        echo         ^<p class="success"^>✅ Coverage report generated^</p^>
    ) else (
        echo         ^<p class="warning"^>⚠️ Coverage not generated^</p^>
    )
) else (
    echo         ^<p class="warning"^>⚠️ Coverage not generated^</p^>
)
echo     ^</div^>
echo     ^<div class="section"^>
echo         ^<h2^>Test Files^</h2^>
echo         ^<p^>Detailed test results are available in JSON format in the test_reports directory.^</p^>
echo     ^</div^>
echo ^</body^>
echo ^</html^>
) > "%REPORT_FILE%"

echo [SUCCESS] Comprehensive report generated: %REPORT_FILE%

:upload_firebase
if "%UPLOAD_TO_FIREBASE%"=="false" goto :finish

echo [INFO] Uploading to Firebase Test Lab...

REM Check if gcloud is installed
gcloud --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] gcloud CLI is not installed. Please install it to upload to Firebase Test Lab.
    goto :finish
)

REM Build APK for testing
echo [INFO] Building APK for Firebase Test Lab...
flutter build apk --debug

REM Run basic test on Firebase Test Lab
echo [INFO] Running tests on Firebase Test Lab...
gcloud firebase test android run --type instrumentation --app build\app\outputs\flutter-apk\app-debug.apk --test build\app\outputs\flutter-apk\app-debug-androidTest.apk --device model=Pixel2,version=28,locale=en,orientation=portrait --timeout 20m --results-bucket=gs://your-project-test-results --results-dir=automated-test-%TIMESTAMP%

echo [SUCCESS] Firebase Test Lab execution completed

:finish
echo ========================================
if "%TEST_FAILURES%"=="true" (
    echo [ERROR] Some tests failed. Check the reports for details. ❌
    echo [INFO] Reports available in: %REPORTS_DIR%
    echo ========================================
    exit /b 1
) else (
    echo [SUCCESS] All tests completed successfully! 🎉
    echo [INFO] Reports available in: %REPORTS_DIR%
    echo ========================================
    exit /b 0
)
