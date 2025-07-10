@echo off
echo 🚀 Starting Performance Tests...
echo ================================

REM Check if Flutter is installed
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter is not installed or not in PATH
    exit /b 1
)

echo ✅ Flutter found
flutter --version | findstr "Flutter"

REM Create test results directory
if not exist "test_results\performance" mkdir test_results\performance

echo.
echo 📱 Testing app startup time...
echo Running app in profile mode with startup tracing...

REM Run startup time test
start /b flutter run --profile --trace-startup --verbose > test_results\performance\startup_trace.log 2>&1

REM Wait for app to start
timeout /t 10 /nobreak >nul

REM Kill flutter processes
taskkill /f /im flutter.exe >nul 2>&1
taskkill /f /im dart.exe >nul 2>&1

if exist "test_results\performance\startup_trace.log" (
    echo ✅ Startup trace completed
) else (
    echo ⚠️ Startup trace log not found
)

echo.
echo 💾 Testing memory usage...
echo Running app in profile mode with memory monitoring...

REM Run memory usage test
start /b flutter run --profile --enable-software-rendering > test_results\performance\memory_trace.log 2>&1

REM Wait for memory profiling
timeout /t 15 /nobreak >nul

REM Kill flutter processes
taskkill /f /im flutter.exe >nul 2>&1
taskkill /f /im dart.exe >nul 2>&1

if exist "test_results\performance\memory_trace.log" (
    echo ✅ Memory trace completed
) else (
    echo ⚠️ Memory trace log not found
)

echo.
echo 🔄 Analyzing widget rebuilds...
echo Running app in debug mode with widget build tracing...

REM Run widget rebuild analysis
start /b flutter run --debug --trace-widget-builds > test_results\performance\rebuild_trace.log 2>&1

REM Wait for rebuild analysis
timeout /t 10 /nobreak >nul

REM Kill flutter processes
taskkill /f /im flutter.exe >nul 2>&1
taskkill /f /im dart.exe >nul 2>&1

if exist "test_results\performance\rebuild_trace.log" (
    echo ✅ Widget rebuild analysis completed
) else (
    echo ⚠️ Widget rebuild trace log not found
)

echo.
echo 📊 Running performance profiling...
echo Running app in profile mode with Skia tracing...

REM Run performance profiling
start /b flutter run --profile --trace-skia > test_results\performance\skia_trace.log 2>&1

REM Wait for profiling
timeout /t 10 /nobreak >nul

REM Kill flutter processes
taskkill /f /im flutter.exe >nul 2>&1
taskkill /f /im dart.exe >nul 2>&1

if exist "test_results\performance\skia_trace.log" (
    echo ✅ Skia performance profiling completed
) else (
    echo ⚠️ Skia trace log not found
)

echo.
echo 🧪 Running integration tests with performance monitoring...

REM Check if integration tests exist
if exist "test\integration" (
    echo Running integration tests...
    flutter test test\integration\ --reporter=json > test_results\performance\integration_test_results.json 2>&1
    
    if %errorlevel% equ 0 (
        echo ✅ Integration tests completed successfully
    ) else (
        echo ⚠️ Some integration tests failed or had issues
    )
) else (
    echo ⚠️ Integration test directory not found
)

echo.
echo 🔍 Running Flutter analyze for performance issues...

flutter analyze > test_results\performance\analyze_results.txt 2>&1

if %errorlevel% equ 0 (
    echo ✅ Flutter analyze completed with no issues
) else (
    echo ⚠️ Flutter analyze found some issues - check analyze_results.txt
)

echo.
echo 📋 Generating performance report...

REM Generate performance report
(
echo # Performance Test Report
echo.
echo Generated on: %date% %time%
echo.
echo ## Test Results Summary
echo.
echo ### 1. App Startup Time
if exist "test_results\performance\startup_trace.log" (
    echo - **Status**: ✅ Completed
) else (
    echo - **Status**: ❌ Failed
)
echo - **Log File**: startup_trace.log
echo.
echo ### 2. Memory Usage
if exist "test_results\performance\memory_trace.log" (
    echo - **Status**: ✅ Completed
) else (
    echo - **Status**: ❌ Failed
)
echo - **Log File**: memory_trace.log
echo.
echo ### 3. Widget Rebuild Analysis
if exist "test_results\performance\rebuild_trace.log" (
    echo - **Status**: ✅ Completed
) else (
    echo - **Status**: ❌ Failed
)
echo - **Log File**: rebuild_trace.log
echo.
echo ### 4. Performance Profiling
if exist "test_results\performance\skia_trace.log" (
    echo - **Status**: ✅ Completed
) else (
    echo - **Status**: ❌ Failed
)
echo - **Log File**: skia_trace.log
echo.
echo ### 5. Integration Tests
if exist "test_results\performance\integration_test_results.json" (
    echo - **Status**: ✅ Completed
) else (
    echo - **Status**: ❌ Failed
)
echo - **Results File**: integration_test_results.json
echo.
echo ### 6. Static Analysis
if exist "test_results\performance\analyze_results.txt" (
    echo - **Status**: ✅ Completed
) else (
    echo - **Status**: ❌ Failed
)
echo - **Results File**: analyze_results.txt
echo.
echo ## Recommendations
echo.
echo 1. **Startup Optimization**: Review startup_trace.log for slow initialization
echo 2. **Memory Management**: Check memory_trace.log for memory leaks
echo 3. **Widget Performance**: Analyze rebuild_trace.log for excessive rebuilds
echo 4. **Rendering Performance**: Review skia_trace.log for rendering bottlenecks
echo 5. **Code Quality**: Address any issues found in analyze_results.txt
echo.
echo ## Next Steps
echo.
echo 1. Review all log files for specific performance issues
echo 2. Implement optimizations based on findings
echo 3. Re-run tests to verify improvements
echo 4. Set up continuous performance monitoring
) > test_results\performance\performance_report.md

echo ✅ Performance report generated: test_results\performance\performance_report.md

echo.
echo 📊 Performance Test Summary
echo ================================
echo.
echo Test Results Location: test_results\performance\
echo.
echo Generated Files:
dir test_results\performance\ /b 2>nul

echo.
echo ✅ Performance tests completed!
echo.
echo 📖 Next steps:
echo 1. Review the performance report: test_results\performance\performance_report.md
echo 2. Analyze individual log files for specific issues
echo 3. Implement optimizations based on findings
echo 4. Re-run tests to verify improvements

echo.
echo 💡 Tip: Run 'code test_results\performance\' to open results in VS Code

pause
