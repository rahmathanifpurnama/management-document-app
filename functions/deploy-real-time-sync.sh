#!/bin/bash

# Real-time Sync Cloud Functions Deployment Script
# Usage: ./deploy-real-time-sync.sh

echo "🚀 Starting Real-time Sync Cloud Functions Deployment..."

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

# Check if we're in the functions directory
if [ ! -f "package.json" ]; then
    print_error "Please run this script from the functions directory"
    exit 1
fi

# Step 1: Check Firebase CLI
print_status "Checking Firebase CLI..."
if ! command -v firebase &> /dev/null; then
    print_error "Firebase CLI not found. Installing..."
    npm install -g firebase-tools
fi

# Step 2: Check login status
print_status "Checking Firebase login status..."
if ! firebase projects:list &> /dev/null; then
    print_warning "Not logged in to Firebase. Please login..."
    firebase login
fi

# Step 3: Verify project
print_status "Verifying Firebase project..."
PROJECT_ID=$(firebase use --current 2>/dev/null)
if [ -z "$PROJECT_ID" ]; then
    print_warning "No Firebase project selected. Please select project..."
    firebase use --interactive
fi

print_success "Using Firebase project: $(firebase use --current)"

# Step 4: Install dependencies
print_status "Installing dependencies..."
npm install
if [ $? -ne 0 ]; then
    print_error "Failed to install dependencies"
    exit 1
fi

# Step 5: Compile TypeScript
print_status "Compiling TypeScript..."
npm run build
if [ $? -ne 0 ]; then
    print_error "TypeScript compilation failed"
    exit 1
fi

# Step 6: Verify new functions exist
print_status "Verifying new real-time sync functions..."
FUNCTIONS_TO_DEPLOY=(
    "onStorageFileCreated"
    "onStorageFileDeleted" 
    "onAuthUserCreated"
    "onAuthUserDeleted"
)

for func in "${FUNCTIONS_TO_DEPLOY[@]}"; do
    if grep -q "export.*$func" lib/index.js; then
        print_success "✓ Function $func found in compiled code"
    else
        print_warning "⚠ Function $func not found in compiled code"
    fi
done

# Step 7: Deploy functions
print_status "Deploying real-time sync functions..."
echo "Functions to be deployed:"
for func in "${FUNCTIONS_TO_DEPLOY[@]}"; do
    echo "  - $func"
done

read -p "Continue with deployment? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Deploy specific functions
    FUNCTIONS_LIST=$(IFS=,; echo "functions:${FUNCTIONS_TO_DEPLOY[*]}")
    FUNCTIONS_LIST=${FUNCTIONS_LIST//,/,functions:}
    
    print_status "Deploying: $FUNCTIONS_LIST"
    firebase deploy --only "$FUNCTIONS_LIST"
    
    if [ $? -eq 0 ]; then
        print_success "🎉 Real-time sync functions deployed successfully!"
        
        # Step 8: Verify deployment
        print_status "Verifying deployment..."
        firebase functions:list | grep -E "(onStorage|onAuth)"
        
        # Step 9: Show next steps
        echo ""
        print_success "✅ Deployment completed successfully!"
        echo ""
        echo "📋 Next steps:"
        echo "1. Test file upload to Firebase Storage to trigger onStorageFileCreated"
        echo "2. Create new user in Firebase Auth to trigger onAuthUserCreated"
        echo "3. Monitor logs with: firebase functions:log"
        echo "4. Check Firestore collections for auto-created metadata"
        echo ""
        echo "🔍 Monitor real-time:"
        echo "firebase functions:log --only onStorageFileCreated"
        echo "firebase functions:log --only onAuthUserCreated"
        
    else
        print_error "Deployment failed. Check the error messages above."
        exit 1
    fi
else
    print_warning "Deployment cancelled by user"
    exit 0
fi

print_success "🚀 Real-time sync deployment script completed!"
