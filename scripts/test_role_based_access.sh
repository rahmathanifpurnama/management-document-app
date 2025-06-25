#!/bin/bash

# Firebase Test Lab - Role-Based Access Testing Script
# Usage: ./scripts/test_role_based_access.sh --project PROJECT_ID [OPTIONS]

set -e

# Default values
PROJECT_ID=""
DEVICE="model=Pixel3,version=30,locale=en,orientation=portrait"
TIMEOUT="30m"
RESULTS_BUCKET=""
TEST_TYPE="both"  # admin, user, both
RECORD_VIDEO="false"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 --project PROJECT_ID [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --project PROJECT_ID     Firebase project ID (required)"
    echo "  --device DEVICE_SPEC     Device specification (default: Pixel3,version=30)"
    echo "  --timeout TIMEOUT        Test timeout (default: 30m)"
    echo "  --bucket BUCKET_NAME     Results bucket (default: PROJECT_ID-test-results)"
    echo "  --type TEST_TYPE         Test type: admin, user, both (default: both)"
    echo "  --record-video           Record video during test"
    echo "  --help                   Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --project my-project-id"
    echo "  $0 --project my-project-id --type admin --device 'model=Pixel6,version=33'"
    echo "  $0 --project my-project-id --type both --record-video"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --project)
            PROJECT_ID="$2"
            shift 2
            ;;
        --device)
            DEVICE="$2"
            shift 2
            ;;
        --timeout)
            TIMEOUT="$2"
            shift 2
            ;;
        --bucket)
            RESULTS_BUCKET="$2"
            shift 2
            ;;
        --type)
            TEST_TYPE="$2"
            shift 2
            ;;
        --record-video)
            RECORD_VIDEO="true"
            shift
            ;;
        --help)
            show_usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Validate required parameters
if [[ -z "$PROJECT_ID" ]]; then
    print_error "Project ID is required"
    show_usage
    exit 1
fi

# Set default results bucket if not provided
if [[ -z "$RESULTS_BUCKET" ]]; then
    RESULTS_BUCKET="gs://${PROJECT_ID}-test-results"
fi

# Validate test type
if [[ "$TEST_TYPE" != "admin" && "$TEST_TYPE" != "user" && "$TEST_TYPE" != "both" ]]; then
    print_error "Invalid test type: $TEST_TYPE. Must be 'admin', 'user', or 'both'"
    exit 1
fi

print_status "Starting role-based access testing..."
print_status "Project: $PROJECT_ID"
print_status "Device: $DEVICE"
print_status "Test Type: $TEST_TYPE"
print_status "Timeout: $TIMEOUT"
print_status "Results Bucket: $RESULTS_BUCKET"

# Check if APK exists
APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"
TEST_APK_PATH="build/app/outputs/flutter-apk/app-debug-androidTest.apk"

if [[ ! -f "$APK_PATH" ]]; then
    print_error "APK not found at $APK_PATH"
    print_status "Building APK..."
    flutter build apk --debug
fi

if [[ ! -f "$TEST_APK_PATH" ]]; then
    print_error "Test APK not found at $TEST_APK_PATH"
    print_status "Building test APK..."
    flutter build apk --debug integration_test/test_flows/role_based_test.dart
fi

# Prepare video recording option
VIDEO_OPTION=""
if [[ "$RECORD_VIDEO" == "true" ]]; then
    VIDEO_OPTION="--record-video"
fi

# Function to run admin test
run_admin_test() {
    print_status "🔐 Running Admin Access Test..."
    
    local timestamp=$(date +%Y%m%d-%H%M%S)
    local results_dir="admin-test-$timestamp"
    
    gcloud firebase test android run \
        --type instrumentation \
        --app "$APK_PATH" \
        --test "$TEST_APK_PATH" \
        --device "$DEVICE" \
        --timeout "$TIMEOUT" \
        --environment-variables TEST_USER_EMAIL=admin@test.com,TEST_USER_PASSWORD=admin123,TEST_USER_ROLE=admin \
        --test-targets "class com.example.AdminAccessTest" \
        --results-bucket "$RESULTS_BUCKET" \
        --results-dir "$results_dir" \
        $VIDEO_OPTION
    
    if [[ $? -eq 0 ]]; then
        print_success "Admin test completed successfully"
        print_status "Results: $RESULTS_BUCKET/$results_dir"
    else
        print_error "Admin test failed"
        return 1
    fi
}

# Function to run user test
run_user_test() {
    print_status "👤 Running User Access Test..."
    
    local timestamp=$(date +%Y%m%d-%H%M%S)
    local results_dir="user-test-$timestamp"
    
    gcloud firebase test android run \
        --type instrumentation \
        --app "$APK_PATH" \
        --test "$TEST_APK_PATH" \
        --device "$DEVICE" \
        --timeout "$TIMEOUT" \
        --environment-variables TEST_USER_EMAIL=user@test.com,TEST_USER_PASSWORD=user123,TEST_USER_ROLE=user \
        --test-targets "class com.example.UserAccessTest" \
        --results-bucket "$RESULTS_BUCKET" \
        --results-dir "$results_dir" \
        $VIDEO_OPTION
    
    if [[ $? -eq 0 ]]; then
        print_success "User test completed successfully"
        print_status "Results: $RESULTS_BUCKET/$results_dir"
    else
        print_error "User test failed"
        return 1
    fi
}

# Run tests based on type
case "$TEST_TYPE" in
    "admin")
        run_admin_test
        ;;
    "user")
        run_user_test
        ;;
    "both")
        print_status "Running both admin and user tests..."
        run_admin_test
        if [[ $? -eq 0 ]]; then
            run_user_test
        else
            print_error "Admin test failed, skipping user test"
            exit 1
        fi
        ;;
esac

print_success "✅ Role-based access testing completed!"
print_status "Check Firebase Console for detailed results: https://console.firebase.google.com/project/$PROJECT_ID/testlab/histories/"
