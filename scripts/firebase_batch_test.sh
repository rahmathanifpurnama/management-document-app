#!/bin/bash

# Firebase Test Lab Batch Testing Script
# Runs comprehensive testing across multiple devices and configurations

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
FIREBASE_PROJECT_ID="${FIREBASE_PROJECT_ID:-your-project-id}"
RESULTS_BUCKET="gs://${FIREBASE_PROJECT_ID}-test-results"
TEST_TYPE="instrumentation"  # or "robo"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --project)
      FIREBASE_PROJECT_ID="$2"
      RESULTS_BUCKET="gs://${FIREBASE_PROJECT_ID}-test-results"
      shift 2
      ;;
    --robo)
      TEST_TYPE="robo"
      shift
      ;;
    --help)
      echo "Usage: $0 [OPTIONS]"
      echo "Options:"
      echo "  --project PROJECT_ID    Firebase project ID"
      echo "  --robo                  Use Robo testing instead of instrumentation"
      echo "  --help                  Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done

log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

# Setup function
setup_environment() {
    log "Setting up Firebase Test Lab environment..."
    
    cd "$PROJECT_ROOT"
    
    # Check gcloud installation
    if ! command -v gcloud &> /dev/null; then
        log_error "gcloud CLI is not installed. Please install it first."
        exit 1
    fi
    
    # Check authentication
    if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | head -n 1 > /dev/null; then
        log_error "Not authenticated with gcloud. Please run 'gcloud auth login'"
        exit 1
    fi
    
    # Set project
    gcloud config set project "$FIREBASE_PROJECT_ID"
    log_info "Using Firebase project: $FIREBASE_PROJECT_ID"
    
    # Check Flutter installation
    if ! command -v flutter &> /dev/null; then
        log_error "Flutter is not installed or not in PATH"
        exit 1
    fi
    
    log_success "Environment setup complete"
}

# Build APKs
build_apks() {
    log "Building APKs for testing..."
    
    # Clean and prepare
    flutter clean
    flutter pub get
    
    # Build main APK
    log_info "Building main APK..."
    flutter build apk --debug
    
    if [ "$TEST_TYPE" = "instrumentation" ]; then
        # Build test APK (if integration tests exist)
        if [ -d "integration_test" ]; then
            log_info "Building test APK..."
            flutter build apk --debug integration_test/test_flows/auth_flow_test.dart
        else
            log_info "No integration tests found, switching to Robo testing"
            TEST_TYPE="robo"
        fi
    fi
    
    log_success "APK build completed"
}

# Device configurations
declare -A DEVICE_CONFIGS=(
    ["pixel2"]="model=Pixel2,version=28,locale=en,orientation=portrait"
    ["pixel3"]="model=Pixel3,version=30,locale=en,orientation=portrait"
    ["pixel4"]="model=Pixel4,version=31,locale=en,orientation=portrait"
    ["pixel6"]="model=Pixel6,version=33,locale=en,orientation=portrait"
    ["samsung_j7"]="model=j7xelte,version=23,locale=en,orientation=portrait"
    ["nexus_lowres"]="model=NexusLowRes,version=25,locale=en,orientation=portrait"
    ["nexus9_tablet"]="model=Nexus9,version=25,locale=en,orientation=landscape"
    ["medium_phone"]="model=MediumPhone.arm,version=30,locale=en,orientation=portrait"
)

# Test scenarios
run_smoke_tests() {
    log "Running smoke tests..."
    
    local devices=("pixel3" "pixel4")
    local results_dir="smoke-tests-$TIMESTAMP"
    
    for device_key in "${devices[@]}"; do
        local device_config="${DEVICE_CONFIGS[$device_key]}"
        log_info "Running smoke test on $device_key"
        
        if [ "$TEST_TYPE" = "robo" ]; then
            gcloud firebase test android run \
                --type robo \
                --app build/app/outputs/flutter-apk/app-debug.apk \
                --device "$device_config" \
                --timeout 10m \
                --robo-directives login_username=admin@test.com,login_password=admin123 \
                --results-bucket="$RESULTS_BUCKET" \
                --results-dir="$results_dir/$device_key" \
                --no-record-video &
        else
            gcloud firebase test android run \
                --type instrumentation \
                --app build/app/outputs/flutter-apk/app-debug.apk \
                --test build/app/outputs/flutter-apk/app-debug-androidTest.apk \
                --device "$device_config" \
                --timeout 10m \
                --results-bucket="$RESULTS_BUCKET" \
                --results-dir="$results_dir/$device_key" \
                --no-record-video &
        fi
    done
    
    wait
    log_success "Smoke tests completed"
}

run_compatibility_tests() {
    log "Running compatibility tests across Android versions..."
    
    local devices=("samsung_j7" "nexus_lowres" "pixel2" "pixel3" "pixel4" "pixel6")
    local results_dir="compatibility-tests-$TIMESTAMP"
    
    for device_key in "${devices[@]}"; do
        local device_config="${DEVICE_CONFIGS[$device_key]}"
        log_info "Running compatibility test on $device_key"
        
        if [ "$TEST_TYPE" = "robo" ]; then
            gcloud firebase test android run \
                --type robo \
                --app build/app/outputs/flutter-apk/app-debug.apk \
                --device "$device_config" \
                --timeout 15m \
                --robo-directives login_username=user@test.com,login_password=user123 \
                --results-bucket="$RESULTS_BUCKET" \
                --results-dir="$results_dir/$device_key" \
                --no-record-video &
        else
            gcloud firebase test android run \
                --type instrumentation \
                --app build/app/outputs/flutter-apk/app-debug.apk \
                --test build/app/outputs/flutter-apk/app-debug-androidTest.apk \
                --device "$device_config" \
                --timeout 15m \
                --results-bucket="$RESULTS_BUCKET" \
                --results-dir="$results_dir/$device_key" \
                --no-record-video &
        fi
        
        # Limit parallel executions
        if (( $(jobs -r | wc -l) >= 3 )); then
            wait -n
        fi
    done
    
    wait
    log_success "Compatibility tests completed"
}

run_performance_tests() {
    log "Running performance tests..."
    
    local devices=("nexus_lowres" "medium_phone" "pixel6")
    local results_dir="performance-tests-$TIMESTAMP"
    
    for device_key in "${devices[@]}"; do
        local device_config="${DEVICE_CONFIGS[$device_key]}"
        log_info "Running performance test on $device_key"
        
        if [ "$TEST_TYPE" = "robo" ]; then
            gcloud firebase test android run \
                --type robo \
                --app build/app/outputs/flutter-apk/app-debug.apk \
                --device "$device_config" \
                --timeout 20m \
                --robo-directives login_username=admin@test.com,login_password=admin123 \
                --results-bucket="$RESULTS_BUCKET" \
                --results-dir="$results_dir/$device_key" \
                --record-video &
        else
            gcloud firebase test android run \
                --type instrumentation \
                --app build/app/outputs/flutter-apk/app-debug.apk \
                --test build/app/outputs/flutter-apk/app-debug-androidTest.apk \
                --device "$device_config" \
                --timeout 20m \
                --environment-variables performance_test=true \
                --results-bucket="$RESULTS_BUCKET" \
                --results-dir="$results_dir/$device_key" \
                --record-video &
        fi
    done
    
    wait
    log_success "Performance tests completed"
}

run_tablet_tests() {
    log "Running tablet-specific tests..."
    
    local devices=("nexus9_tablet")
    local results_dir="tablet-tests-$TIMESTAMP"
    
    for device_key in "${devices[@]}"; do
        local device_config="${DEVICE_CONFIGS[$device_key]}"
        log_info "Running tablet test on $device_key"
        
        if [ "$TEST_TYPE" = "robo" ]; then
            gcloud firebase test android run \
                --type robo \
                --app build/app/outputs/flutter-apk/app-debug.apk \
                --device "$device_config" \
                --timeout 15m \
                --robo-directives login_username=admin@test.com,login_password=admin123 \
                --results-bucket="$RESULTS_BUCKET" \
                --results-dir="$results_dir/$device_key" \
                --record-video &
        else
            gcloud firebase test android run \
                --type instrumentation \
                --app build/app/outputs/flutter-apk/app-debug.apk \
                --test build/app/outputs/flutter-apk/app-debug-androidTest.apk \
                --device "$device_config" \
                --timeout 15m \
                --results-bucket="$RESULTS_BUCKET" \
                --results-dir="$results_dir/$device_key" \
                --record-video &
        fi
    done
    
    wait
    log_success "Tablet tests completed"
}

# Generate summary report
generate_summary() {
    log "Generating test summary..."
    
    local summary_file="firebase_test_summary_$TIMESTAMP.html"
    
    cat > "$summary_file" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Firebase Test Lab Summary - $TIMESTAMP</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background-color: #4285f4; color: white; padding: 20px; border-radius: 5px; }
        .section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .device { background-color: #f8f9fa; padding: 10px; margin: 5px 0; border-radius: 3px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🔥 Firebase Test Lab Results</h1>
        <p>Project: $FIREBASE_PROJECT_ID</p>
        <p>Test Type: $TEST_TYPE</p>
        <p>Generated: $(date)</p>
    </div>
    
    <div class="section">
        <h2>Test Configuration</h2>
        <ul>
            <li><strong>Project ID:</strong> $FIREBASE_PROJECT_ID</li>
            <li><strong>Test Type:</strong> $TEST_TYPE</li>
            <li><strong>Results Bucket:</strong> $RESULTS_BUCKET</li>
            <li><strong>Timestamp:</strong> $TIMESTAMP</li>
        </ul>
    </div>
    
    <div class="section">
        <h2>Tested Devices</h2>
EOF

    for device_key in "${!DEVICE_CONFIGS[@]}"; do
        local device_config="${DEVICE_CONFIGS[$device_key]}"
        echo "        <div class=\"device\">$device_key: $device_config</div>" >> "$summary_file"
    done

    cat >> "$summary_file" << EOF
    </div>
    
    <div class="section">
        <h2>Results</h2>
        <p>Detailed results are available in the Firebase Console:</p>
        <p><a href="https://console.firebase.google.com/project/$FIREBASE_PROJECT_ID/testlab/histories/" target="_blank">View in Firebase Console</a></p>
        <p>Results bucket: <code>$RESULTS_BUCKET</code></p>
    </div>
</body>
</html>
EOF
    
    log_success "Summary generated: $summary_file"
    
    # Open in browser if available
    if command -v xdg-open &> /dev/null; then
        xdg-open "$summary_file"
    elif command -v open &> /dev/null; then
        open "$summary_file"
    fi
}

# Main execution
main() {
    echo -e "${PURPLE}========================================${NC}"
    echo -e "${PURPLE}  Firebase Test Lab Batch Testing${NC}"
    echo -e "${PURPLE}========================================${NC}"
    
    local start_time=$(date +%s)
    
    log_info "Starting comprehensive Firebase Test Lab testing..."
    log_info "Project: $FIREBASE_PROJECT_ID"
    log_info "Test Type: $TEST_TYPE"
    
    # Setup
    setup_environment
    
    # Build APKs
    build_apks
    
    # Run test suites
    run_smoke_tests
    run_compatibility_tests
    run_performance_tests
    run_tablet_tests
    
    # Generate summary
    generate_summary
    
    # Calculate execution time
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    echo -e "${PURPLE}========================================${NC}"
    log_success "All Firebase Test Lab tests completed! 🎉"
    log_info "Total execution time: ${duration}s"
    log_info "Results available at: $RESULTS_BUCKET"
    log_info "Firebase Console: https://console.firebase.google.com/project/$FIREBASE_PROJECT_ID/testlab/histories/"
    echo -e "${PURPLE}========================================${NC}"
}

# Run main function
main "$@"
