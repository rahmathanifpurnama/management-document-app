#!/bin/bash

# Google Cloud SDK Wrapper for Git Bash
# This script helps run gcloud commands from Git Bash on Windows

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_info() {
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

# Function to find gcloud installation
find_gcloud() {
    local gcloud_paths=(
        "/c/Users/$USER/AppData/Local/Google/Cloud SDK/google-cloud-sdk/bin/gcloud.cmd"
        "/c/Program Files/Google/Cloud SDK/google-cloud-sdk/bin/gcloud.cmd"
        "/c/Program Files (x86)/Google/Cloud SDK/google-cloud-sdk/bin/gcloud.cmd"
        "/c/Google/Cloud SDK/google-cloud-sdk/bin/gcloud.cmd"
    )
    
    for path in "${gcloud_paths[@]}"; do
        if [[ -f "$path" ]]; then
            echo "$path"
            return 0
        fi
    done
    
    return 1
}

# Function to run gcloud command
run_gcloud() {
    local gcloud_path
    gcloud_path=$(find_gcloud)
    
    if [[ $? -ne 0 ]]; then
        print_error "Google Cloud SDK not found!"
        print_info "Please install Google Cloud SDK:"
        print_info "1. Run: scripts/install_gcloud_sdk.bat"
        print_info "2. Or download from: https://cloud.google.com/sdk/docs/install-sdk"
        print_info "3. Restart Git Bash after installation"
        return 1
    fi
    
    print_info "Using gcloud at: $gcloud_path"
    
    # Convert Unix-style paths to Windows paths for arguments
    local args=()
    for arg in "$@"; do
        if [[ "$arg" =~ ^/c/ ]]; then
            # Convert /c/path to C:\path
            arg=$(echo "$arg" | sed 's|^/c/|C:/|' | sed 's|/|\\|g')
        fi
        args+=("$arg")
    done
    
    # Run gcloud command
    cmd.exe //c "\"$gcloud_path\" ${args[*]}"
}

# Function to setup Firebase Test Lab
setup_firebase_testlab() {
    local project_id="$1"
    
    if [[ -z "$project_id" ]]; then
        print_error "Project ID is required"
        print_info "Usage: $0 setup PROJECT_ID"
        return 1
    fi
    
    print_info "Setting up Firebase Test Lab for project: $project_id"
    
    # Authenticate
    print_info "Authenticating with Google Cloud..."
    run_gcloud auth login
    if [[ $? -ne 0 ]]; then
        print_error "Authentication failed"
        return 1
    fi
    
    # Set project
    print_info "Setting project to $project_id..."
    run_gcloud config set project "$project_id"
    if [[ $? -ne 0 ]]; then
        print_error "Failed to set project"
        return 1
    fi
    
    # Enable APIs
    print_info "Enabling required APIs..."
    run_gcloud services enable testing.googleapis.com
    run_gcloud services enable toolresults.googleapis.com
    run_gcloud services enable storage.googleapis.com
    
    # Create results bucket
    print_info "Creating results bucket..."
    run_gcloud storage buckets create "gs://${project_id}-test-results" --location=us-central1 2>/dev/null || true
    
    print_success "Firebase Test Lab setup complete!"
}

# Function to run Firebase test
run_firebase_test() {
    local project_id="$1"
    local test_type="${2:-simple}"
    local device="${3:-model=Pixel3,version=30,locale=en,orientation=portrait}"
    
    if [[ -z "$project_id" ]]; then
        print_error "Project ID is required"
        return 1
    fi
    
    print_info "Running Firebase Test Lab test..."
    print_info "Project: $project_id"
    print_info "Type: $test_type"
    print_info "Device: $device"
    
    # Check if APK exists
    local apk_path="build/app/outputs/flutter-apk/app-debug.apk"
    if [[ ! -f "$apk_path" ]]; then
        print_warning "APK not found, building..."
        flutter build apk --debug
        if [[ $? -ne 0 ]]; then
            print_error "Failed to build APK"
            return 1
        fi
    fi
    
    # Convert paths for Windows
    local win_apk_path=$(echo "$apk_path" | sed 's|/|\\|g')
    local timestamp=$(date +%Y%m%d-%H%M%S)
    
    case "$test_type" in
        "simple")
            run_gcloud firebase test android run \
                --type instrumentation \
                --app "$win_apk_path" \
                --test "$win_apk_path" \
                --device "$device" \
                --timeout 30m \
                --results-bucket "gs://${project_id}-test-results" \
                --results-dir "simple-test-$timestamp"
            ;;
        "robo")
            run_gcloud firebase test android run \
                --type robo \
                --app "$win_apk_path" \
                --device "$device" \
                --timeout 20m \
                --results-bucket "gs://${project_id}-test-results" \
                --results-dir "robo-test-$timestamp"
            ;;
        *)
            print_error "Unknown test type: $test_type"
            print_info "Available types: simple, robo"
            return 1
            ;;
    esac
}

# Function to show available devices
show_devices() {
    print_info "Available devices:"
    run_gcloud firebase test android models list
}

# Function to show usage
show_usage() {
    echo "Google Cloud SDK Wrapper for Git Bash"
    echo ""
    echo "Usage:"
    echo "  $0 setup PROJECT_ID                    - Setup Firebase Test Lab"
    echo "  $0 test PROJECT_ID [TYPE] [DEVICE]     - Run test"
    echo "  $0 devices                             - Show available devices"
    echo "  $0 gcloud [ARGS...]                   - Run gcloud command directly"
    echo ""
    echo "Examples:"
    echo "  $0 setup my-project-id"
    echo "  $0 test my-project-id simple"
    echo "  $0 test my-project-id robo 'model=Pixel6,version=33'"
    echo "  $0 gcloud version"
    echo "  $0 devices"
}

# Main script logic
case "$1" in
    "setup")
        setup_firebase_testlab "$2"
        ;;
    "test")
        run_firebase_test "$2" "$3" "$4"
        ;;
    "devices")
        show_devices
        ;;
    "gcloud")
        shift
        run_gcloud "$@"
        ;;
    "")
        show_usage
        ;;
    *)
        print_error "Unknown command: $1"
        show_usage
        exit 1
        ;;
esac
