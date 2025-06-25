#!/bin/bash

# Comprehensive Test Runner Script for Flutter Management Document App
# This script runs all test suites with detailed reporting and error handling

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/test_reports"
COVERAGE_DIR="$PROJECT_ROOT/coverage"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="$REPORTS_DIR/test_run_$TIMESTAMP.log"

# Test suite options
RUN_UNIT_TESTS=true
RUN_WIDGET_TESTS=true
RUN_INTEGRATION_TESTS=true
RUN_PERFORMANCE_TESTS=true
RUN_DEVICE_COMPATIBILITY_TESTS=true
GENERATE_COVERAGE=true
UPLOAD_TO_FIREBASE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --unit-only)
      RUN_UNIT_TESTS=true
      RUN_WIDGET_TESTS=false
      RUN_INTEGRATION_TESTS=false
      RUN_PERFORMANCE_TESTS=false
      RUN_DEVICE_COMPATIBILITY_TESTS=false
      shift
      ;;
    --widget-only)
      RUN_UNIT_TESTS=false
      RUN_WIDGET_TESTS=true
      RUN_INTEGRATION_TESTS=false
      RUN_PERFORMANCE_TESTS=false
      RUN_DEVICE_COMPATIBILITY_TESTS=false
      shift
      ;;
    --integration-only)
      RUN_UNIT_TESTS=false
      RUN_WIDGET_TESTS=false
      RUN_INTEGRATION_TESTS=true
      RUN_PERFORMANCE_TESTS=false
      RUN_DEVICE_COMPATIBILITY_TESTS=false
      shift
      ;;
    --performance-only)
      RUN_UNIT_TESTS=false
      RUN_WIDGET_TESTS=false
      RUN_INTEGRATION_TESTS=false
      RUN_PERFORMANCE_TESTS=true
      RUN_DEVICE_COMPATIBILITY_TESTS=false
      shift
      ;;
    --no-coverage)
      GENERATE_COVERAGE=false
      shift
      ;;
    --firebase)
      UPLOAD_TO_FIREBASE=true
      shift
      ;;
    --help)
      echo "Usage: $0 [OPTIONS]"
      echo "Options:"
      echo "  --unit-only                 Run only unit tests"
      echo "  --widget-only              Run only widget tests"
      echo "  --integration-only         Run only integration tests"
      echo "  --performance-only         Run only performance tests"
      echo "  --no-coverage             Skip coverage generation"
      echo "  --firebase                Upload results to Firebase Test Lab"
      echo "  --help                    Show this help message"
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
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

log_info() {
    echo -e "${CYAN}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

# Setup function
setup_test_environment() {
    log "Setting up test environment..."
    
    # Create directories
    mkdir -p "$REPORTS_DIR"
    mkdir -p "$COVERAGE_DIR"
    
    # Navigate to project root
    cd "$PROJECT_ROOT"
    
    # Check Flutter installation
    if ! command -v flutter &> /dev/null; then
        log_error "Flutter is not installed or not in PATH"
        exit 1
    fi
    
    # Get Flutter version
    FLUTTER_VERSION=$(flutter --version | head -n 1)
    log_info "Using $FLUTTER_VERSION"
    
    # Clean and get dependencies
    log "Cleaning project and getting dependencies..."
    flutter clean
    flutter pub get
    
    # Generate necessary files
    if [ -f "pubspec.yaml" ] && grep -q "build_runner" pubspec.yaml; then
        log "Generating code with build_runner..."
        flutter packages pub run build_runner build --delete-conflicting-outputs
    fi
    
    log_success "Test environment setup complete"
}

# Unit tests
run_unit_tests() {
    if [ "$RUN_UNIT_TESTS" = false ]; then
        return 0
    fi
    
    log "Running unit tests..."
    
    local unit_test_files=(
        "test/services/unit_tests_only.dart"
        "test/services/file_hash_service_test.dart"
        "test/services/duplicate_detection_service_test.dart"
        "test/services/enhanced_services_simple_test.dart"
        "test/providers/settings_provider_test.dart"
    )
    
    local failed_tests=()
    
    for test_file in "${unit_test_files[@]}"; do
        if [ -f "$test_file" ]; then
            log_info "Running $test_file"
            if flutter test "$test_file" --reporter=json > "$REPORTS_DIR/unit_$(basename "$test_file" .dart)_$TIMESTAMP.json"; then
                log_success "✅ $test_file passed"
            else
                log_error "❌ $test_file failed"
                failed_tests+=("$test_file")
            fi
        else
            log_warning "Test file not found: $test_file"
        fi
    done
    
    # Run all unit tests with coverage
    if [ "$GENERATE_COVERAGE" = true ]; then
        log_info "Running all unit tests with coverage..."
        flutter test test/ --coverage --reporter=json > "$REPORTS_DIR/unit_tests_all_$TIMESTAMP.json" || true
        
        if [ -f "coverage/lcov.info" ]; then
            log_success "Coverage report generated"
            # Generate HTML coverage report if genhtml is available
            if command -v genhtml &> /dev/null; then
                genhtml coverage/lcov.info -o "$COVERAGE_DIR/html_$TIMESTAMP"
                log_success "HTML coverage report generated in $COVERAGE_DIR/html_$TIMESTAMP"
            fi
        fi
    else
        flutter test test/ --reporter=json > "$REPORTS_DIR/unit_tests_all_$TIMESTAMP.json" || true
    fi
    
    if [ ${#failed_tests[@]} -eq 0 ]; then
        log_success "All unit tests passed"
        return 0
    else
        log_error "Unit tests failed: ${failed_tests[*]}"
        return 1
    fi
}

# Widget tests
run_widget_tests() {
    if [ "$RUN_WIDGET_TESTS" = false ]; then
        return 0
    fi
    
    log "Running widget tests..."
    
    local widget_test_files=(
        "test/widgets/responsive_widget_test.dart"
        "test/widgets/component_widget_test.dart"
        "test/home_screen_file_loading_test.dart"
    )
    
    local failed_tests=()
    
    for test_file in "${widget_test_files[@]}"; do
        if [ -f "$test_file" ]; then
            log_info "Running $test_file"
            if flutter test "$test_file" --reporter=json > "$REPORTS_DIR/widget_$(basename "$test_file" .dart)_$TIMESTAMP.json"; then
                log_success "✅ $test_file passed"
            else
                log_error "❌ $test_file failed"
                failed_tests+=("$test_file")
            fi
        else
            log_warning "Test file not found: $test_file"
        fi
    done
    
    if [ ${#failed_tests[@]} -eq 0 ]; then
        log_success "All widget tests passed"
        return 0
    else
        log_error "Widget tests failed: ${failed_tests[*]}"
        return 1
    fi
}

# Integration tests
run_integration_tests() {
    if [ "$RUN_INTEGRATION_TESTS" = false ]; then
        return 0
    fi
    
    log "Running integration tests..."
    
    # Check if integration test directory exists
    if [ ! -d "integration_test" ]; then
        log_warning "Integration test directory not found, skipping integration tests"
        return 0
    fi
    
    local integration_test_files=(
        "integration_test/test_flows/auth_flow_test.dart"
        "integration_test/test_flows/document_flow_test.dart"
        "integration_test/test_flows/navigation_flow_test.dart"
    )
    
    local failed_tests=()
    
    for test_file in "${integration_test_files[@]}"; do
        if [ -f "$test_file" ]; then
            log_info "Running $test_file"
            if flutter test "$test_file" --reporter=json > "$REPORTS_DIR/integration_$(basename "$test_file" .dart)_$TIMESTAMP.json"; then
                log_success "✅ $test_file passed"
            else
                log_error "❌ $test_file failed"
                failed_tests+=("$test_file")
            fi
        else
            log_warning "Test file not found: $test_file"
        fi
    done
    
    if [ ${#failed_tests[@]} -eq 0 ]; then
        log_success "All integration tests passed"
        return 0
    else
        log_error "Integration tests failed: ${failed_tests[*]}"
        return 1
    fi
}

# Performance tests
run_performance_tests() {
    if [ "$RUN_PERFORMANCE_TESTS" = false ]; then
        return 0
    fi
    
    log "Running performance tests..."
    
    local performance_test_files=(
        "test/performance/memory_performance_test.dart"
        "integration_test/test_flows/performance_test.dart"
    )
    
    local failed_tests=()
    
    for test_file in "${performance_test_files[@]}"; do
        if [ -f "$test_file" ]; then
            log_info "Running $test_file"
            if flutter test "$test_file" --reporter=json > "$REPORTS_DIR/performance_$(basename "$test_file" .dart)_$TIMESTAMP.json"; then
                log_success "✅ $test_file passed"
            else
                log_error "❌ $test_file failed"
                failed_tests+=("$test_file")
            fi
        else
            log_warning "Test file not found: $test_file"
        fi
    done
    
    if [ ${#failed_tests[@]} -eq 0 ]; then
        log_success "All performance tests passed"
        return 0
    else
        log_error "Performance tests failed: ${failed_tests[*]}"
        return 1
    fi
}

# Device compatibility tests
run_device_compatibility_tests() {
    if [ "$RUN_DEVICE_COMPATIBILITY_TESTS" = false ]; then
        return 0
    fi
    
    log "Running device compatibility tests..."
    
    local compatibility_test_files=(
        "test/device_compatibility/device_compatibility_test.dart"
    )
    
    local failed_tests=()
    
    for test_file in "${compatibility_test_files[@]}"; do
        if [ -f "$test_file" ]; then
            log_info "Running $test_file"
            if flutter test "$test_file" --reporter=json > "$REPORTS_DIR/compatibility_$(basename "$test_file" .dart)_$TIMESTAMP.json"; then
                log_success "✅ $test_file passed"
            else
                log_error "❌ $test_file failed"
                failed_tests+=("$test_file")
            fi
        else
            log_warning "Test file not found: $test_file"
        fi
    done
    
    if [ ${#failed_tests[@]} -eq 0 ]; then
        log_success "All device compatibility tests passed"
        return 0
    else
        log_error "Device compatibility tests failed: ${failed_tests[*]}"
        return 1
    fi
}

# Generate comprehensive report
generate_report() {
    log "Generating comprehensive test report..."
    
    local report_file="$REPORTS_DIR/comprehensive_report_$TIMESTAMP.html"
    
    cat > "$report_file" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Test Report - $TIMESTAMP</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background-color: #f0f0f0; padding: 20px; border-radius: 5px; }
        .success { color: green; }
        .error { color: red; }
        .warning { color: orange; }
        .section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .timestamp { color: #666; font-size: 0.9em; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Flutter App Test Report</h1>
        <p class="timestamp">Generated: $(date)</p>
        <p>Flutter Version: $FLUTTER_VERSION</p>
    </div>
    
    <div class="section">
        <h2>Test Summary</h2>
        <ul>
            <li>Unit Tests: $([ "$RUN_UNIT_TESTS" = true ] && echo "✅ Executed" || echo "⏭️ Skipped")</li>
            <li>Widget Tests: $([ "$RUN_WIDGET_TESTS" = true ] && echo "✅ Executed" || echo "⏭️ Skipped")</li>
            <li>Integration Tests: $([ "$RUN_INTEGRATION_TESTS" = true ] && echo "✅ Executed" || echo "⏭️ Skipped")</li>
            <li>Performance Tests: $([ "$RUN_PERFORMANCE_TESTS" = true ] && echo "✅ Executed" || echo "⏭️ Skipped")</li>
            <li>Device Compatibility Tests: $([ "$RUN_DEVICE_COMPATIBILITY_TESTS" = true ] && echo "✅ Executed" || echo "⏭️ Skipped")</li>
        </ul>
    </div>
    
    <div class="section">
        <h2>Coverage Report</h2>
        $([ "$GENERATE_COVERAGE" = true ] && [ -f "coverage/lcov.info" ] && echo "<p class='success'>✅ Coverage report generated</p>" || echo "<p class='warning'>⚠️ Coverage not generated</p>")
        $([ -d "$COVERAGE_DIR/html_$TIMESTAMP" ] && echo "<p><a href='$COVERAGE_DIR/html_$TIMESTAMP/index.html'>View HTML Coverage Report</a></p>" || echo "")
    </div>
    
    <div class="section">
        <h2>Test Files</h2>
        <p>Detailed test results are available in JSON format in the test_reports directory.</p>
    </div>
</body>
</html>
EOF
    
    log_success "Comprehensive report generated: $report_file"
}

# Upload to Firebase Test Lab
upload_to_firebase() {
    if [ "$UPLOAD_TO_FIREBASE" = false ]; then
        return 0
    fi
    
    log "Uploading to Firebase Test Lab..."
    
    # Check if gcloud is installed
    if ! command -v gcloud &> /dev/null; then
        log_error "gcloud CLI is not installed. Please install it to upload to Firebase Test Lab."
        return 1
    fi
    
    # Build APK for testing
    log_info "Building APK for Firebase Test Lab..."
    flutter build apk --debug
    
    # Run basic test on Firebase Test Lab
    log_info "Running tests on Firebase Test Lab..."
    gcloud firebase test android run \
        --type instrumentation \
        --app build/app/outputs/flutter-apk/app-debug.apk \
        --test build/app/outputs/flutter-apk/app-debug-androidTest.apk \
        --device model=Pixel2,version=28,locale=en,orientation=portrait \
        --timeout 20m \
        --results-bucket=gs://your-project-test-results \
        --results-dir=automated-test-$TIMESTAMP || log_error "Firebase Test Lab execution failed"
    
    log_success "Firebase Test Lab execution completed"
}

# Main execution
main() {
    echo -e "${PURPLE}========================================${NC}"
    echo -e "${PURPLE}  Flutter App Comprehensive Test Suite${NC}"
    echo -e "${PURPLE}========================================${NC}"
    
    local start_time=$(date +%s)
    local exit_code=0
    
    # Setup
    setup_test_environment
    
    # Run test suites
    run_unit_tests || exit_code=1
    run_widget_tests || exit_code=1
    run_integration_tests || exit_code=1
    run_performance_tests || exit_code=1
    run_device_compatibility_tests || exit_code=1
    
    # Generate report
    generate_report
    
    # Upload to Firebase if requested
    upload_to_firebase
    
    # Calculate execution time
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    echo -e "${PURPLE}========================================${NC}"
    if [ $exit_code -eq 0 ]; then
        log_success "All tests completed successfully! 🎉"
    else
        log_error "Some tests failed. Check the reports for details. ❌"
    fi
    log_info "Total execution time: ${duration}s"
    log_info "Reports available in: $REPORTS_DIR"
    echo -e "${PURPLE}========================================${NC}"
    
    exit $exit_code
}

# Run main function
main "$@"
