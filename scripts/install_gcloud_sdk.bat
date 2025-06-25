@echo off
REM Google Cloud SDK Installation Script for Windows
REM Run as Administrator for best results

echo [INFO] Installing Google Cloud SDK...

REM Create temp directory
set TEMP_DIR=%TEMP%\gcloud_install
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

REM Download Google Cloud SDK
echo [INFO] Downloading Google Cloud SDK...
powershell -Command "& {Invoke-WebRequest -Uri 'https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe' -OutFile '%TEMP_DIR%\GoogleCloudSDKInstaller.exe'}"

if not exist "%TEMP_DIR%\GoogleCloudSDKInstaller.exe" (
    echo [ERROR] Failed to download Google Cloud SDK installer
    echo [INFO] Please download manually from: https://cloud.google.com/sdk/docs/install-sdk
    pause
    exit /b 1
)

echo [INFO] Running Google Cloud SDK installer...
echo [INFO] Please follow the installation wizard...
start /wait "%TEMP_DIR%\GoogleCloudSDKInstaller.exe"

REM Check if installation was successful
echo [INFO] Checking installation...
timeout /t 5 /nobreak >nul

REM Try to find gcloud in common installation paths
set GCLOUD_PATH=""
if exist "%LOCALAPPDATA%\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" (
    set GCLOUD_PATH=%LOCALAPPDATA%\Google\Cloud SDK\google-cloud-sdk\bin
)
if exist "%PROGRAMFILES%\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" (
    set GCLOUD_PATH=%PROGRAMFILES%\Google\Cloud SDK\google-cloud-sdk\bin
)
if exist "%PROGRAMFILES(X86)%\Google\Cloud SDK\google-cloud-sdk\bin\gcloud.cmd" (
    set GCLOUD_PATH=%PROGRAMFILES(X86)%\Google\Cloud SDK\google-cloud-sdk\bin
)

if "%GCLOUD_PATH%"=="" (
    echo [WARNING] Could not find gcloud installation path
    echo [INFO] Please add Google Cloud SDK to your PATH manually
    echo [INFO] Common paths:
    echo   - %LOCALAPPDATA%\Google\Cloud SDK\google-cloud-sdk\bin
    echo   - %PROGRAMFILES%\Google\Cloud SDK\google-cloud-sdk\bin
    echo   - %PROGRAMFILES(X86)%\Google\Cloud SDK\google-cloud-sdk\bin
) else (
    echo [SUCCESS] Found gcloud at: %GCLOUD_PATH%
    
    REM Add to PATH for current session
    set PATH=%GCLOUD_PATH%;%PATH%
    
    REM Test gcloud
    echo [INFO] Testing gcloud installation...
    "%GCLOUD_PATH%\gcloud.cmd" version
    
    if errorlevel 1 (
        echo [ERROR] gcloud test failed
    ) else (
        echo [SUCCESS] gcloud installation successful!
        echo [INFO] You may need to restart your terminal for PATH changes to take effect
        
        REM Initialize gcloud
        echo [INFO] Initializing gcloud...
        echo [INFO] This will open a browser for authentication
        "%GCLOUD_PATH%\gcloud.cmd" init
    )
)

REM Cleanup
if exist "%TEMP_DIR%" rmdir /s /q "%TEMP_DIR%"

echo [INFO] Installation complete!
echo [INFO] If gcloud is not working in Git Bash, try these solutions:
echo   1. Restart Git Bash
echo   2. Use Command Prompt or PowerShell instead
echo   3. Add gcloud to Git Bash PATH manually
echo.
pause
