#!/bin/bash

# Firebase Test Lab Runner Script
# Specialized script for running tests on Firebase Test Lab with comprehensive device matrix

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

# Test configurations
TEST_SUITE="comprehensive"
DEVICE_MATRIX="popular"
TIMEOUT="20m"
PARALLEL_EXECUTIONS=5

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --project)
      FIREBASE_PROJECT_ID="$2"
      RESULTS_BUCKET="gs://${FIREBASE_PROJECT_ID}-test-results"
      shift 2
      ;;
    --suite)
      TEST_SUITE="$2"
      shift 2
      ;;
    --devices)
      DEVICE_MATRIX="$2"
      shift 2
      ;;
    --timeout)
      TIMEOUT="$2"
      shift 2
      ;;
    --parallel)
      PARALLEL_EXECUTIONS="$2"
      shift 2
      ;;
    --help)
      echo "Usage: $0 [OPTIONS]"
      echo "Options:"
      echo "  --project PROJECT_ID       Firebase project ID"
      echo "  --suite SUITE              Test suite (smoke|comprehensive|performance|compatibility)"
      echo "  --devices MATRIX           Device matrix (popular|all|low-end|high-end|tablets)"
      echo "  --timeout TIMEOUT          Test timeout (default: 20m)"
      echo "  --parallel COUNT           Parallel executions (default: 5)"
      echo "  --help                     Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done

# Utility functions
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

# Device matrix definitions
get_device_matrix() {
    local matrix_type="$1"
    
    case $matrix_type in
        "popular")
            echo "model=Pixel2,version=28,locale=en,orientation=portrait model=Pixel3,version=30,locale=en,orientation=portrait model=Pixel4,version=31,locale=en,orientation=portrait"
            ;;
        "all")
            echo "model=Pixel2,version=28,locale=en,orientation=portrait model=Pixel3,version=30,locale=en,orientation=portrait model=Pixel4,version=31,locale=en,orientation=portrait model=Pixel6,version=33,locale=en,orientation=portrait model=j7xelte,version=23,locale=en,orientation=portrait model=Nexus9,version=25,locale=en,orientation=landscape"
            ;;
        "low-end")
            echo "model=NexusLowRes,version=25,locale=en,orientation=portrait model=MediumPhone.arm,version=30,locale=en,orientation=portrait"
            ;;
        "high-end")
            echo "model=Pixel6,version=33,locale=en,orientation=portrait model=oriole,version=33,locale=en,orientation=portrait"
            ;;
        "tablets")
            echo "model=Nexus9,version=25,locale=en,orientation=landscape model=Nexus9,version=25,locale=en,orientation=portrait"
            ;;
        *)
            echo "model=Pixel3,version=30,locale=en,orientation=portrait"
            ;;
    esac
}

# Test suite definitions
get_test_files() {
    local suite="$1"
    
    case $suite in
        "smoke")
            echo "integration_test/test_flows/auth_flow_test.dart"
            ;;
        "comprehensive")
            echo "integration_test/test_flows/auth_flow_test.dart integration_test/test_flows/document_flow_test.dart integration_test/test_flows/navigation_flow_test.dart"
            ;;
        "performance")
            echo "integration_test/test_flows/performance_test.dart"
            ;;
        "compatibility")
            echo "integration_test/test_flows/auth_flow_test.dart integration_test/test_flows/document_flow_test.dart"
            ;;
        *)
            echo "integration_test/test_flows/auth_flow_test.dart"
            ;;
    esac
}

# Setup function
setup_firebase_testing() {
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
    
    # Check Flutter installation
    if ! command -v flutter &> /dev/null; then
        log_error "Flutter is not installed or not in PATH"
        exit 1
    fi
    
    # Clean and get dependencies
    log_info "Preparing Flutter project..."
    flutter clean
    flutter pub get
    
    log_success "Firebase Test Lab environment setup complete"
}

# Build APKs for testing
build_test_apks() {
    log "Building APKs for Firebase Test Lab..."
    
    # Build main APK
    log_info "Building main APK..."
    flutter build apk --debug
    
    # Build test APKs for each test file
    local test_files=$(get_test_files "$TEST_SUITE")
    for test_file in $test_files; do
        if [ -f "$test_file" ]; then
            log_info "Building test APK for $test_file..."
            flutter build apk --debug "$test_file"
        else
            log_warning "Test file not found: $test_file"
        fi
    done
    
    log_success "APK build completed"
}

# Run tests on Firebase Test Lab
run_firebase_tests() {
    log "Running tests on Firebase Test Lab..."
    
    local devices=$(get_device_matrix "$DEVICE_MATRIX")
    local test_files=$(get_test_files "$TEST_SUITE")
    local job_count=0
    local max_jobs=$PARALLEL_EXECUTIONS
    
    # Create results directory
    local results_dir="firebase-test-$TEST_SUITE-$DEVICE_MATRIX-$TIMESTAMP"
    
    for test_file in $test_files; do
        if [ ! -f "$test_file" ]; then
            log_warning "Skipping missing test file: $test_file"
            continue
        fi
        
        local test_name=$(basename "$test_file" .dart)
        
        for device in $devices; do
            # Wait if we've reached max parallel jobs
            while [ $job_count -ge $max_jobs ]; do
                wait -n  # Wait for any background job to complete
                job_count=$((job_count - 1))
            done
            
            log_info "Starting test: $test_name on device: $device"
            
            # Run test in background
            (
                local device_name=$(echo "$device" | sed 's/,/-/g')
                local test_results_dir="$results_dir/$test_name-$device_name"
                
                gcloud firebase test android run \
                    --type instrumentation \
                    --app build/app/outputs/flutter-apk/app-debug.apk \
                    --test build/app/outputs/flutter-apk/app-debug-androidTest.apk \
                    --device "$device" \
                    --timeout "$TIMEOUT" \
                    --results-bucket="$RESULTS_BUCKET" \
                    --results-dir="$test_results_dir" \
                    --environment-variables coverage=true,test_suite="$TEST_SUITE" \
                    --no-record-video \
                    --no-performance-metrics 2>&1 | tee "firebase_test_${test_name}_${device_name}_${TIMESTAMP}.log"
                
                local exit_code=$?
                if [ $exit_code -eq 0 ]; then
                    log_success "✅ $test_name on $device completed successfully"
                else
                    log_error "❌ $test_name on $device failed (exit code: $exit_code)"
                fi
                
                return $exit_code
            ) &
            
            job_count=$((job_count + 1))
        done
    done
    
    # Wait for all background jobs to complete
    wait
    
    log_success "All Firebase Test Lab executions completed"
}

# Download and analyze results
analyze_results() {
    log "Downloading and analyzing test results..."
    
    local results_dir="firebase_results_$TIMESTAMP"
    mkdir -p "$results_dir"
    
    # Download results from Firebase
    log_info "Downloading results from $RESULTS_BUCKET..."
    gsutil -m cp -r "$RESULTS_BUCKET/*" "$results_dir/" 2>/dev/null || log_warning "Some results may not be available yet"
    
    # Generate summary report
    local report_file="$results_dir/firebase_test_summary_$TIMESTAMP.html"
    
    cat > "$report_file" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Firebase Test Lab Results - $TIMESTAMP</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background-color: #4285f4; color: white; padding: 20px; border-radius: 5px; }
        .success { color: #34a853; }
        .error { color: #ea4335; }
        .warning { color: #fbbc04; }
        .section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .device-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 15px; }
        .device-card { border: 1px solid #ddd; padding: 15px; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🔥 Firebase Test Lab Results</h1>
        <p>Test Suite: $TEST_SUITE | Device Matrix: $DEVICE_MATRIX</p>
        <p>Generated: $(date)</p>
    </div>
    
    <div class="section">
        <h2>Test Configuration</h2>
        <ul>
            <li><strong>Project ID:</strong> $FIREBASE_PROJECT_ID</li>
            <li><strong>Test Suite:</strong> $TEST_SUITE</li>
            <li><strong>Device Matrix:</strong> $DEVICE_MATRIX</li>
            <li><strong>Timeout:</strong> $TIMEOUT</li>
            <li><strong>Parallel Executions:</strong> $PARALLEL_EXECUTIONS</li>
        </ul>
    </div>
    
    <div class="section">
        <h2>Test Results</h2>
        <p>Detailed results are available in the Firebase Console and downloaded to: $results_dir</p>
        <p><a href="https://console.firebase.google.com/project/$FIREBASE_PROJECT_ID/testlab/histories/" target="_blank">View in Firebase Console</a></p>
    </div>
    
    <div class="section">
        <h2>Device Coverage</h2>
        <div class="device-grid">
EOF

    # Add device information to report
    local devices=$(get_device_matrix "$DEVICE_MATRIX")
    for device in $devices; do
        local model=$(echo "$device" | grep -o 'model=[^,]*' | cut -d'=' -f2)
        local version=$(echo "$device" | grep -o 'version=[^,]*' | cut -d'=' -f2)
        local orientation=$(echo "$device" | grep -o 'orientation=[^,]*' | cut -d'=' -f2)
        
        cat >> "$report_file" << EOF
            <div class="device-card">
                <h3>$model</h3>
                <p><strong>Android:</strong> API $version</p>
                <p><strong>Orientation:</strong> $orientation</p>
            </div>
EOF
    done
    
    cat >> "$report_file" << EOF
        </div>
    </div>
    
    <div class="section">
        <h2>Next Steps</h2>
        <ul>
            <li>Review detailed test results in Firebase Console</li>
            <li>Check downloaded artifacts in $results_dir</li>
            <li>Analyze any failed tests and fix issues</li>
            <li>Re-run tests if necessary</li>
        </ul>
    </div>
</body>
</html>
EOF
    
    log_success "Results analysis completed: $report_file"
    
    # Open report in browser if available
    if command -v xdg-open &> /dev/null; then
        xdg-open "$report_file"
    elif command -v open &> /dev/null; then
        open "$report_file"
    fi
}

# Main execution
main() {
    echo -e "${PURPLE}========================================${NC}"
    echo -e "${PURPLE}  Firebase Test Lab Runner${NC}"
    echo -e "${PURPLE}========================================${NC}"
    
    local start_time=$(date +%s)
    
    log_info "Configuration:"
    log_info "  Project ID: $FIREBASE_PROJECT_ID"
    log_info "  Test Suite: $TEST_SUITE"
    log_info "  Device Matrix: $DEVICE_MATRIX"
    log_info "  Timeout: $TIMEOUT"
    log_info "  Parallel Executions: $PARALLEL_EXECUTIONS"
    
    # Setup
    setup_firebase_testing
    
    # Build APKs
    build_test_apks
    
    # Run tests
    run_firebase_tests
    
    # Analyze results
    analyze_results
    
    # Calculate execution time
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    echo -e "${PURPLE}========================================${NC}"
    log_success "Firebase Test Lab execution completed! 🎉"
    log_info "Total execution time: ${duration}s"
    log_info "Results bucket: $RESULTS_BUCKET"
    echo -e "${PURPLE}========================================${NC}"
}

# Run main function
main "$@"
