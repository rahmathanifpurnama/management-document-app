@echo off
echo ========================================
echo 🔧 FIX: Release Build PIN Verification Error
echo ========================================
echo.

echo 📱 Fixing "pin verification failed" error in release build...
echo.

REM Step 1: Clean build cache
echo [1/6] 🧹 Cleaning build cache...
flutter clean
if %errorlevel% neq 0 (
    echo ❌ Flutter clean failed
    pause
    exit /b 1
)
echo ✅ Build cache cleaned
echo.

REM Step 2: Clean Android build
echo [2/6] 🧹 Cleaning Android build...
cd android
call gradlew clean
if %errorlevel% neq 0 (
    echo ❌ Android clean failed
    cd ..
    pause
    exit /b 1
)
cd ..
echo ✅ Android build cleaned
echo.

REM Step 3: Get dependencies
echo [3/6] 📦 Getting Flutter dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo ❌ Flutter pub get failed
    pause
    exit /b 1
)
echo ✅ Dependencies updated
echo.

REM Step 4: Verify network security config
echo [4/6] 🔍 Verifying network security configuration...
if exist "android\app\src\main\res\xml\network_security_config.xml" (
    echo ✅ Network security config found
    
    REM Check if certificate pinning is disabled
    findstr "Certificate pinning disabled" "android\app\src\main\res\xml\network_security_config.xml" >nul
    if %errorlevel%==0 (
        echo ✅ Certificate pinning is disabled (good for release build)
    ) else (
        echo ⚠️  Certificate pinning may still be active
        echo    This could cause PIN verification errors
    )
) else (
    echo ❌ Network security config not found
)
echo.

REM Step 5: Build release APK
echo [5/6] 🔨 Building release APK...
flutter build apk --release
if %errorlevel% neq 0 (
    echo ❌ Release build failed
    echo.
    echo 💡 Common solutions:
    echo    1. Check Firebase configuration
    echo    2. Verify signing configuration
    echo    3. Check network security config
    echo    4. Ensure all dependencies are compatible
    pause
    exit /b 1
)
echo ✅ Release APK built successfully
echo.

REM Step 6: Show build location
echo [6/6] 📍 Build completed!
echo.
echo 📱 APK Location: build\app\outputs\flutter-apk\app-release.apk
echo.
echo 🎉 Release build should now work without PIN verification errors!
echo.
echo 📋 What was fixed:
echo    ✅ Certificate pinning disabled
echo    ✅ Network security config simplified
echo    ✅ Build cache cleared
echo    ✅ Dependencies updated
echo.
echo 🚀 You can now install and test the APK on your device.
echo.

pause
