#!/bin/bash

# Simple script for Git Bash on Windows
echo "========================================"
echo "🔧 FIX: PIN Verification Error (Git Bash)"
echo "========================================"
echo ""

# Step 1: Clean Flutter
echo "🧹 Cleaning Flutter build cache..."
flutter clean
echo "✅ Flutter clean completed"
echo ""

# Step 2: Clean Android (Windows compatible)
echo "🧹 Cleaning Android build..."
if [ -d "android" ]; then
    cd android
    if [ -f "gradlew.bat" ]; then
        cmd //c "gradlew.bat clean"
        echo "✅ Android clean completed"
    else
        echo "⚠️  gradlew.bat not found, skipping Android clean"
    fi
    cd ..
else
    echo "⚠️  Android directory not found"
fi
echo ""

# Step 3: Get dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get
echo "✅ Dependencies updated"
echo ""

# Step 4: Build release
echo "🔨 Building release APK..."
flutter build apk --release
echo ""

if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo "🎉 SUCCESS! APK built successfully"
    echo "📱 Location: build/app/outputs/flutter-apk/app-release.apk"
    
    # Show file size
    if command -v du >/dev/null 2>&1; then
        SIZE=$(du -h "build/app/outputs/flutter-apk/app-release.apk" | cut -f1)
        echo "📊 Size: $SIZE"
    fi
else
    echo "❌ Build failed or APK not found"
fi

echo ""
echo "🚀 Done! You can now install the APK on your device."
echo ""
read -p "Press Enter to continue..."
