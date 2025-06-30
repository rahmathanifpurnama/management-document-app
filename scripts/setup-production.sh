#!/bin/bash

# Production Setup Script for Database Seeder
# This script helps setup the production environment for database seeding

set -e

echo "🚀 Document Management System - Production Setup"
echo "================================================"

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

# Create config directory
print_info "Creating config directory..."
mkdir -p config
print_status "Config directory created"

# Check for service account key
SERVICE_ACCOUNT_FILE="config/service-account-key.json"

if [ ! -f "$SERVICE_ACCOUNT_FILE" ]; then
    print_warning "Service account key not found"
    echo ""
    echo "📋 Please follow these steps:"
    echo "1. Go to Firebase Console: https://console.firebase.google.com/"
    echo "2. Select your project: document-management-c5a96"
    echo "3. Go to Project Settings > Service accounts"
    echo "4. Click 'Generate new private key'"
    echo "5. Download the JSON file"
    echo "6. Move it to: $(pwd)/config/service-account-key.json"
    echo ""
    read -p "Press Enter after you've placed the service account key file..."
    
    if [ ! -f "$SERVICE_ACCOUNT_FILE" ]; then
        print_error "Service account key still not found at $SERVICE_ACCOUNT_FILE"
        exit 1
    fi
fi

print_status "Service account key found"

# Validate service account key
print_info "Validating service account key..."
if ! node -e "
try {
    const key = require('./config/service-account-key.json');
    if (!key.project_id || !key.private_key || !key.client_email) {
        throw new Error('Invalid service account key format');
    }
    console.log('✅ Service account key is valid');
    console.log('📧 Client email:', key.client_email);
    console.log('🏗️  Project ID:', key.project_id);
} catch (error) {
    console.error('❌ Invalid service account key:', error.message);
    process.exit(1);
}
"; then
    print_error "Service account key validation failed"
    exit 1
fi

print_status "Service account key validated"

# Check Node.js dependencies
print_info "Checking Node.js dependencies..."
if ! node -e "require('firebase-admin')" 2>/dev/null; then
    print_warning "firebase-admin not installed"
    print_info "Installing firebase-admin..."
    npm install firebase-admin
    print_status "firebase-admin installed"
else
    print_status "firebase-admin already installed"
fi

# Set production environment
print_info "Setting up production environment..."
unset FIRESTORE_EMULATOR_HOST 2>/dev/null || true
unset FIREBASE_AUTH_EMULATOR_HOST 2>/dev/null || true
unset FIREBASE_STORAGE_EMULATOR_HOST 2>/dev/null || true
export NODE_ENV=production

print_status "Production environment configured"

# Final checks
print_info "Running final checks..."

# Check if .gitignore is properly configured
if grep -q "service-account-key.json" ../.gitignore; then
    print_status ".gitignore properly configured"
else
    print_warning ".gitignore might not be properly configured"
    print_info "Adding service account patterns to .gitignore..."
    echo "" >> ../.gitignore
    echo "# Firebase Service Account Keys (Security)" >> ../.gitignore
    echo "**/service-account-key.json" >> ../.gitignore
    echo "**/config/service-account-key.json" >> ../.gitignore
    echo "scripts/config/" >> ../.gitignore
    echo "firebase-adminsdk-*.json" >> ../.gitignore
    print_status ".gitignore updated"
fi

# Check git status
if git status --porcelain 2>/dev/null | grep -q "service-account-key.json"; then
    print_error "Service account key is being tracked by git!"
    print_info "Run: git rm --cached config/service-account-key.json"
    exit 1
fi

print_status "Git security check passed"

echo ""
echo "🎉 Production setup completed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Run the database seeder: node database-seeder.js"
echo "2. Choose option 1 for full seed"
echo "3. Monitor the process in Firebase Console"
echo ""
print_warning "IMPORTANT: Only run this on empty production databases!"
print_warning "Always backup existing data before seeding!"
