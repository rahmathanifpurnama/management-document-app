#!/bin/bash

# Firebase Test Lab Test Execution Script for Unix-based systems
# This script runs integration tests on Firebase Test Lab

set -e  # Exit on any error

echo "========================================"
echo "Firebase Test Lab Test Execution"
echo "========================================"

# Set variables
PROJECT_ID="your-firebase-project-id"
RESULTS_BUCKET="gs://your-project-test-results"
TEST_TIMEOUT="60m"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    print_error "Firebase CLI is not installed or not in PATH"
    echo "Please install Firebase CLI: npm install -g firebase-tools"
    exit 1
fi

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    echo "Please install Flutter and add it to PATH"
    exit 1
fi

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    print_error "Google Cloud SDK is not installed or not in PATH"
    echo "Please install Google Cloud SDK"
    exit 1
fi

print_status "Checking Firebase project configuration..."
firebase projects:list

echo
print_status "Building Flutter app for testing..."

# Clean previous builds
print_status "Cleaning previous builds..."
flutter clean
flutter pub get

# Build Android APK for testing
print_status "Building Android APK..."
flutter build apk --debug
if [ $? -ne 0 ]; then
    print_error "Failed to build Android APK"
    exit 1
fi

# Build integration test APK
print_status "Building integration test APK..."
flutter build apk --debug integration_test/app_test.dart
if [ $? -ne 0 ]; then
    print_error "Failed to build integration test APK"
    exit 1
fi

echo
print_status "Running tests on Firebase Test Lab..."

# Function to run Android tests
run_android_tests() {
    local test_name=$1
    local device_config=$2
    local test_file=$3
    
    print_status "Running $test_name..."
    
    gcloud firebase test android run \
        --type instrumentation \
        --app build/app/outputs/flutter-apk/app-debug.apk \
        --test build/app/outputs/flutter-apk/app-debug-androidTest.apk \
        $device_config \
        --timeout $TEST_TIMEOUT \
        --results-bucket $RESULTS_BUCKET \
        --results-dir "android-$test_name-$TIMESTAMP" \
        --project $PROJECT_ID \
        --environment-variables coverage=true,coverageFile=/sdcard/coverage.lcov
    
    if [ $? -ne 0 ]; then
        print_warning "Some $test_name failed"
        return 1
    else
        print_status "$test_name completed successfully"
        return 0
    fi
}

# Run Android tests
echo "========================================"
echo "Running Android Tests"
echo "========================================"

# Smoke tests
run_android_tests "smoke-tests" \
    "--device model=Pixel2,version=28,locale=en,orientation=portrait --device model=Pixel3,version=30,locale=en,orientation=portrait"

# Document management tests
run_android_tests "document-tests" \
    "--device model=Pixel4,version=31,locale=en,orientation=portrait"

# User management tests
run_android_tests "user-management-tests" \
    "--device model=Pixel4,version=31,locale=en,orientation=portrait"

# Category tests
run_android_tests "category-tests" \
    "--device model=Pixel5,version=32,locale=en,orientation=portrait"

# Performance tests
run_android_tests "performance-tests" \
    "--device model=Pixel5,version=32,locale=en,orientation=portrait"

# Full test suite
run_android_tests "full-suite" \
    "--device model=Pixel6,version=33,locale=en,orientation=portrait"

# Build and test iOS if on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo
    echo "========================================"
    echo "Building and Testing iOS App"
    echo "========================================"
    
    print_status "Building iOS app..."
    flutter build ios --debug --no-codesign
    if [ $? -ne 0 ]; then
        print_error "Failed to build iOS app"
        exit 1
    fi
    
    # Create iOS test archive
    print_status "Creating iOS test archive..."
    cd ios
    xcodebuild -workspace Runner.xcworkspace \
        -scheme Runner \
        -configuration Debug \
        -destination generic/platform=iOS \
        -archivePath build/Runner.xcarchive \
        archive
    
    # Export IPA for testing
    xcodebuild -exportArchive \
        -archivePath build/Runner.xcarchive \
        -exportPath build \
        -exportOptionsPlist exportOptions.plist
    
    cd ..
    
    # Run iOS tests
    print_status "Running iOS tests..."
    gcloud firebase test ios run \
        --test ios/build/Runner.ipa \
        --device model=iphone13pro,version=15.7,locale=en,orientation=portrait \
        --device model=iphone14,version=16.6,locale=en,orientation=portrait \
        --timeout $TEST_TIMEOUT \
        --results-bucket $RESULTS_BUCKET \
        --results-dir "ios-tests-$TIMESTAMP" \
        --project $PROJECT_ID
    
    if [ $? -ne 0 ]; then
        print_warning "Some iOS tests failed"
    else
        print_status "iOS tests completed successfully"
    fi
else
    print_warning "iOS testing skipped (not running on macOS)"
fi

echo
echo "========================================"
echo "Test Execution Complete"
echo "========================================"

echo
print_status "Test results are available in:"
echo "$RESULTS_BUCKET"

echo
print_status "To view detailed results, visit:"
echo "https://console.firebase.google.com/project/$PROJECT_ID/testlab/histories"

echo
print_status "To download test results:"
echo "gsutil -m cp -r $RESULTS_BUCKET/android-*-tests-$TIMESTAMP ./test-results/"

# Generate test report
print_status "Generating test report..."
mkdir -p test-results
cat > test-results/test-summary-$TIMESTAMP.md << EOF
# Firebase Test Lab Results - $TIMESTAMP

## Test Execution Summary

- **Project ID**: $PROJECT_ID
- **Execution Time**: $(date)
- **Results Bucket**: $RESULTS_BUCKET

## Test Configurations

### Android Tests
- Smoke Tests: android-smoke-tests-$TIMESTAMP
- Document Tests: android-document-tests-$TIMESTAMP
- User Management Tests: android-user-management-tests-$TIMESTAMP
- Category Tests: android-category-tests-$TIMESTAMP
- Performance Tests: android-performance-tests-$TIMESTAMP
- Full Suite: android-full-suite-$TIMESTAMP

### iOS Tests
$(if [[ "$OSTYPE" == "darwin"* ]]; then echo "- iOS Tests: ios-tests-$TIMESTAMP"; else echo "- iOS Tests: Skipped (not on macOS)"; fi)

## Viewing Results

1. Visit the Firebase Console: https://console.firebase.google.com/project/$PROJECT_ID/testlab/histories
2. Download results: \`gsutil -m cp -r $RESULTS_BUCKET/android-*-tests-$TIMESTAMP ./test-results/\`

## Next Steps

1. Review test results in Firebase Console
2. Download and analyze detailed logs
3. Fix any failing tests
4. Re-run tests as needed
EOF

print_status "Test summary saved to: test-results/test-summary-$TIMESTAMP.md"

echo
print_status "Script completed successfully!"
