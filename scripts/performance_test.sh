#!/bin/bash

echo "🚀 Starting Performance Tests..."
echo "================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}$1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

print_success "Flutter found: $(flutter --version | head -n 1)"

# 1. App startup time test
print_status "📱 Testing app startup time..."
echo "Running app in profile mode with startup tracing..."

# Create startup test results directory
mkdir -p test_results/performance

# Run startup time test
flutter run --profile --trace-startup --verbose > test_results/performance/startup_trace.log 2>&1 &
FLUTTER_PID=$!

# Wait for app to start (adjust time as needed)
sleep 10

# Kill the flutter process
kill $FLUTTER_PID 2>/dev/null || true

if [ -f "test_results/performance/startup_trace.log" ]; then
    print_success "Startup trace completed"
    # Extract startup time from log (this would need to be customized based on actual log format)
    grep -i "startup" test_results/performance/startup_trace.log | tail -5
else
    print_warning "Startup trace log not found"
fi

# 2. Memory usage test
print_status "💾 Testing memory usage..."
echo "Running app in profile mode with memory monitoring..."

flutter run --profile --enable-software-rendering > test_results/performance/memory_trace.log 2>&1 &
FLUTTER_PID=$!

# Wait for memory profiling
sleep 15

# Kill the flutter process
kill $FLUTTER_PID 2>/dev/null || true

if [ -f "test_results/performance/memory_trace.log" ]; then
    print_success "Memory trace completed"
else
    print_warning "Memory trace log not found"
fi

# 3. Widget rebuild analysis
print_status "🔄 Analyzing widget rebuilds..."
echo "Running app in debug mode with widget build tracing..."

flutter run --debug --trace-widget-builds > test_results/performance/rebuild_trace.log 2>&1 &
FLUTTER_PID=$!

# Wait for rebuild analysis
sleep 10

# Kill the flutter process
kill $FLUTTER_PID 2>/dev/null || true

if [ -f "test_results/performance/rebuild_trace.log" ]; then
    print_success "Widget rebuild analysis completed"
else
    print_warning "Widget rebuild trace log not found"
fi

# 4. Performance profiling
print_status "📊 Running performance profiling..."
echo "Running app in profile mode with Skia tracing..."

flutter run --profile --trace-skia > test_results/performance/skia_trace.log 2>&1 &
FLUTTER_PID=$!

# Wait for profiling
sleep 10

# Kill the flutter process
kill $FLUTTER_PID 2>/dev/null || true

if [ -f "test_results/performance/skia_trace.log" ]; then
    print_success "Skia performance profiling completed"
else
    print_warning "Skia trace log not found"
fi

# 5. Integration test performance
print_status "🧪 Running integration tests with performance monitoring..."

# Check if integration tests exist
if [ -d "test/integration" ]; then
    echo "Running integration tests..."
    
    # Run integration tests
    flutter test test/integration/ --reporter=json > test_results/performance/integration_test_results.json 2>&1
    
    if [ $? -eq 0 ]; then
        print_success "Integration tests completed successfully"
    else
        print_warning "Some integration tests failed or had issues"
    fi
else
    print_warning "Integration test directory not found"
fi

# 6. Flutter analyze for performance issues
print_status "🔍 Running Flutter analyze for performance issues..."

flutter analyze > test_results/performance/analyze_results.txt 2>&1

if [ $? -eq 0 ]; then
    print_success "Flutter analyze completed with no issues"
else
    print_warning "Flutter analyze found some issues - check analyze_results.txt"
fi

# 7. Generate performance report
print_status "📋 Generating performance report..."

cat > test_results/performance/performance_report.md << EOF
# Performance Test Report

Generated on: $(date)

## Test Results Summary

### 1. App Startup Time
- **Status**: $([ -f "test_results/performance/startup_trace.log" ] && echo "✅ Completed" || echo "❌ Failed")
- **Log File**: startup_trace.log

### 2. Memory Usage
- **Status**: $([ -f "test_results/performance/memory_trace.log" ] && echo "✅ Completed" || echo "❌ Failed")
- **Log File**: memory_trace.log

### 3. Widget Rebuild Analysis
- **Status**: $([ -f "test_results/performance/rebuild_trace.log" ] && echo "✅ Completed" || echo "❌ Failed")
- **Log File**: rebuild_trace.log

### 4. Performance Profiling
- **Status**: $([ -f "test_results/performance/skia_trace.log" ] && echo "✅ Completed" || echo "❌ Failed")
- **Log File**: skia_trace.log

### 5. Integration Tests
- **Status**: $([ -f "test_results/performance/integration_test_results.json" ] && echo "✅ Completed" || echo "❌ Failed")
- **Results File**: integration_test_results.json

### 6. Static Analysis
- **Status**: $([ -f "test_results/performance/analyze_results.txt" ] && echo "✅ Completed" || echo "❌ Failed")
- **Results File**: analyze_results.txt

## Recommendations

1. **Startup Optimization**: Review startup_trace.log for slow initialization
2. **Memory Management**: Check memory_trace.log for memory leaks
3. **Widget Performance**: Analyze rebuild_trace.log for excessive rebuilds
4. **Rendering Performance**: Review skia_trace.log for rendering bottlenecks
5. **Code Quality**: Address any issues found in analyze_results.txt

## Next Steps

1. Review all log files for specific performance issues
2. Implement optimizations based on findings
3. Re-run tests to verify improvements
4. Set up continuous performance monitoring

EOF

print_success "Performance report generated: test_results/performance/performance_report.md"

# 8. Display summary
print_status "📊 Performance Test Summary"
echo "================================"

echo "Test Results Location: test_results/performance/"
echo ""
echo "Generated Files:"
ls -la test_results/performance/ 2>/dev/null || echo "No files generated"

echo ""
print_success "Performance tests completed!"
echo ""
echo "📖 Next steps:"
echo "1. Review the performance report: test_results/performance/performance_report.md"
echo "2. Analyze individual log files for specific issues"
echo "3. Implement optimizations based on findings"
echo "4. Re-run tests to verify improvements"

# Optional: Open the performance report if on a system with a default text editor
if command -v code &> /dev/null; then
    echo ""
    echo "💡 Tip: Run 'code test_results/performance/' to open results in VS Code"
elif command -v notepad &> /dev/null; then
    echo ""
    echo "💡 Tip: Run 'notepad test_results/performance/performance_report.md' to view the report"
fi
