#!/bin/bash

# Production Scripts Runner
# This script helps run all production scripts with proper environment setup

set -e

echo "🚀 Document Management System - Production Scripts Runner"
echo "========================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if we're in the right directory
if [ ! -f "database-seeder.js" ]; then
    print_error "Please run this script from the scripts directory"
    exit 1
fi

# Check for service account key
SERVICE_ACCOUNT_FILE="config/service-account-key.json"

if [ ! -f "$SERVICE_ACCOUNT_FILE" ]; then
    print_error "Service account key not found at $SERVICE_ACCOUNT_FILE"
    print_info "Please run ./setup-production.sh first"
    exit 1
fi

print_status "Service account key found"

# Set production environment
print_info "Setting up production environment..."
unset FIRESTORE_EMULATOR_HOST 2>/dev/null || true
unset FIREBASE_AUTH_EMULATOR_HOST 2>/dev/null || true
unset FIREBASE_STORAGE_EMULATOR_HOST 2>/dev/null || true
export NODE_ENV=production

print_status "Production environment configured"

# Show menu
show_menu() {
    echo ""
    echo "📋 Available Production Scripts:"
    echo "================================"
    echo "1. Database Seeder - Seed production database"
    echo "2. Integration Tests - Run production tests"
    echo "3. Admin Setup - Setup admin users"
    echo "4. System Monitor - Monitor system health"
    echo "5. Rules Validation - Validate security rules"
    echo "6. Run All Tests (Integration + Rules)"
    echo "7. Full Setup (Seed + Admin + Validate)"
    echo "8. Exit"
    echo ""
}

# Run script with error handling
run_script() {
    local script_name="$1"
    local script_file="$2"
    
    print_info "Running $script_name..."
    
    if node "$script_file"; then
        print_status "$script_name completed successfully"
        return 0
    else
        print_error "$script_name failed"
        return 1
    fi
}

# Main loop
while true; do
    show_menu
    read -p "Select an option (1-8): " choice
    
    case $choice in
        1)
            run_script "Database Seeder" "database-seeder.js"
            ;;
        
        2)
            run_script "Integration Tests" "integration-test.js"
            ;;
        
        3)
            run_script "Admin Setup" "setup-admin.js"
            ;;
        
        4)
            run_script "System Monitor" "system-monitor.js"
            ;;
        
        5)
            run_script "Rules Validation" "validate-rules.js"
            ;;
        
        6)
            print_info "Running all tests..."
            if run_script "Integration Tests" "integration-test.js" && \
               run_script "Rules Validation" "validate-rules.js"; then
                print_status "All tests completed successfully"
            else
                print_error "Some tests failed"
            fi
            ;;
        
        7)
            print_info "Running full setup..."
            if run_script "Database Seeder" "database-seeder.js" && \
               run_script "Admin Setup" "setup-admin.js" && \
               run_script "Rules Validation" "validate-rules.js"; then
                print_status "Full setup completed successfully"
            else
                print_error "Full setup failed"
            fi
            ;;
        
        8)
            print_info "Goodbye!"
            exit 0
            ;;
        
        *)
            print_error "Invalid option. Please try again."
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
done
