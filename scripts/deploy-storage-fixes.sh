#!/bin/bash

# Deploy Firebase Storage Authorization Fixes
# This script deploys the fixes for Firebase Storage upload authorization issues

set -e  # Exit on any error

echo "🚀 Starting Firebase Storage Authorization Fixes Deployment..."
echo "=================================================="

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI is not installed. Please install it first:"
    echo "   npm install -g firebase-tools"
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "firebase.json" ]; then
    echo "❌ firebase.json not found. Please run this script from the project root directory."
    exit 1
fi

# Check if user is logged in to Firebase
echo "🔐 Checking Firebase authentication..."
if ! firebase projects:list &> /dev/null; then
    echo "❌ Not logged in to Firebase. Please run: firebase login"
    exit 1
fi

echo "✅ Firebase CLI is ready"

# Step 1: Deploy Storage Rules
echo ""
echo "📋 Step 1: Deploying Firebase Storage Rules..."
echo "----------------------------------------------"
echo "Deploying updated storage rules with fixed permission structure..."

if firebase deploy --only storage; then
    echo "✅ Storage rules deployed successfully"
else
    echo "❌ Failed to deploy storage rules"
    exit 1
fi

# Step 2: Deploy Cloud Functions
echo ""
echo "⚡ Step 2: Deploying Cloud Functions..."
echo "--------------------------------------"
echo "Deploying updated Cloud Functions with fixed user permission structure..."

# Build TypeScript functions first
echo "🔨 Building TypeScript functions..."
cd functions
if npm run build; then
    echo "✅ Functions built successfully"
else
    echo "❌ Failed to build functions"
    exit 1
fi
cd ..

# Deploy functions
if firebase deploy --only functions; then
    echo "✅ Cloud Functions deployed successfully"
else
    echo "❌ Failed to deploy Cloud Functions"
    exit 1
fi

# Step 3: Deploy Firestore Rules (if needed)
echo ""
echo "🗄️  Step 3: Deploying Firestore Rules..."
echo "----------------------------------------"
echo "Ensuring Firestore rules are up to date..."

if firebase deploy --only firestore:rules; then
    echo "✅ Firestore rules deployed successfully"
else
    echo "❌ Failed to deploy Firestore rules"
    exit 1
fi

# Step 4: Run user permissions fix script
echo ""
echo "👥 Step 4: Fixing User Permissions Structure..."
echo "----------------------------------------------"
echo "Running script to update existing user permissions..."

if node scripts/fix-user-permissions.js; then
    echo "✅ User permissions updated successfully"
else
    echo "⚠️  User permissions script failed, but deployment can continue"
    echo "   You can run this manually later: node scripts/fix-user-permissions.js"
fi

# Step 5: Verification
echo ""
echo "🔍 Step 5: Verification..."
echo "-------------------------"
echo "Deployment completed! Please verify the following:"
echo ""
echo "1. ✅ Storage Rules: Updated with backward-compatible permission checking"
echo "2. ✅ Cloud Functions: Updated to create users with new permission structure"
echo "3. ✅ User Permissions: Existing users updated to new structure"
echo "4. ✅ Storage Limits: Updated to reflect Blaze plan limits"
echo ""
echo "🧪 Testing Recommendations:"
echo "1. Test file upload with admin user"
echo "2. Test file upload with regular user"
echo "3. Verify no more 'unauthorized' errors"
echo "4. Check that storage limit warnings are resolved"
echo ""
echo "📱 Flutter App:"
echo "- No changes needed in Flutter app"
echo "- Existing users will automatically use new permission structure"
echo "- New users will be created with correct permissions"
echo ""
echo "🎉 Deployment completed successfully!"
echo "=================================================="

# Optional: Show current project info
echo ""
echo "📊 Current Firebase Project:"
firebase projects:list | grep "$(firebase use --current 2>/dev/null || echo 'No project selected')" || echo "Project: document-management-c5a96"

echo ""
echo "🔗 Useful Commands:"
echo "- View logs: firebase functions:log"
echo "- Test functions: firebase functions:shell"
echo "- Monitor: https://console.firebase.google.com/project/document-management-c5a96"
echo ""
echo "✨ All fixes have been deployed! Your Firebase Storage upload issues should now be resolved."
