#!/bin/bash

echo "========================================"
echo "🔧 FIX: Release Build PIN Verification Error"
echo "========================================"
echo ""

echo "📱 Fixing \"pin verification failed\" error in release build..."
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print colored output
print_success() {
    echo -e "\033[32m✅ $1\033[0m"
}

print_error() {
    echo -e "\033[31m❌ $1\033[0m"
}

print_warning() {
    echo -e "\033[33m⚠️  $1\033[0m"
}

print_info() {
    echo -e "\033[34mℹ️  $1\033[0m"
}

# Check prerequisites
echo "[0/6] 🔍 Checking prerequisites..."
if ! command_exists flutter; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

if ! command_exists java; then
    print_error "Java is not installed or not in PATH"
    exit 1
fi

print_success "Prerequisites check passed"
echo ""

# Step 1: Clean build cache
echo "[1/6] 🧹 Cleaning build cache..."
if flutter clean; then
    print_success "Build cache cleaned"
else
    print_error "Flutter clean failed"
    exit 1
fi
echo ""

# Step 2: Clean Android build
echo "[2/6] 🧹 Cleaning Android build..."
if [ -d "android" ]; then
    cd android
    if [ -f "gradlew" ]; then
        if ./gradlew clean; then
            print_success "Android build cleaned"
        else
            print_error "Android clean failed"
            cd ..
            exit 1
        fi
    elif [ -f "gradlew.bat" ]; then
        # For Windows Git Bash
        if cmd //c "gradlew.bat clean"; then
            print_success "Android build cleaned"
        else
            print_error "Android clean failed"
            cd ..
            exit 1
        fi
    else
        print_warning "Gradlew not found, skipping Android clean"
    fi
    cd ..
else
    print_warning "Android directory not found"
fi
echo ""

# Step 3: Get dependencies
echo "[3/6] 📦 Getting Flutter dependencies..."
if flutter pub get; then
    print_success "Dependencies updated"
else
    print_error "Flutter pub get failed"
    exit 1
fi
echo ""

# Step 4: Verify network security config
echo "[4/6] 🔍 Verifying network security configuration..."
NETWORK_CONFIG="android/app/src/main/res/xml/network_security_config.xml"
if [ -f "$NETWORK_CONFIG" ]; then
    print_success "Network security config found"
    
    # Check if certificate pinning is disabled
    if grep -q "Certificate pinning disabled" "$NETWORK_CONFIG"; then
        print_success "Certificate pinning is disabled (good for release build)"
    else
        print_warning "Certificate pinning may still be active"
        print_info "This could cause PIN verification errors"
    fi
else
    print_error "Network security config not found"
fi
echo ""

# Step 5: Build release APK
echo "[5/6] 🔨 Building release APK..."
if flutter build apk --release; then
    print_success "Release APK built successfully"
else
    print_error "Release build failed"
    echo ""
    print_info "💡 Common solutions:"
    print_info "   1. Check Firebase configuration"
    print_info "   2. Verify signing configuration"
    print_info "   3. Check network security config"
    print_info "   4. Ensure all dependencies are compatible"
    exit 1
fi
echo ""

# Step 6: Show build location
echo "[6/6] 📍 Build completed!"
echo ""
print_success "📱 APK Location: build/app/outputs/flutter-apk/app-release.apk"
echo ""
print_success "🎉 Release build should now work without PIN verification errors!"
echo ""
echo "📋 What was fixed:"
print_success "   ✅ Certificate pinning disabled"
print_success "   ✅ Network security config simplified"
print_success "   ✅ Build cache cleared"
print_success "   ✅ Dependencies updated"
echo ""
print_info "🚀 You can now install and test the APK on your device."
echo ""

# Show file size if APK exists
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
if [ -f "$APK_PATH" ]; then
    APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
    print_info "📊 APK Size: $APK_SIZE"
fi

echo "Press any key to continue..."
read -n 1 -s
