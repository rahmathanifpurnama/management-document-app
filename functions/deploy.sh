#!/bin/bash

echo "========================================"
echo "Firebase Cloud Functions Deployment"
echo "========================================"

echo ""
echo "Checking Node.js version..."
if ! command -v node &> /dev/null; then
    echo "Error: Node.js is not installed"
    exit 1
fi
node --version

echo ""
echo "Checking Firebase CLI..."
if ! command -v firebase &> /dev/null; then
    echo "Error: Firebase CLI is not installed"
    echo "Please run './setup.sh' first"
    exit 1
fi
firebase --version

echo ""
echo "Installing/updating dependencies..."
npm install
if [ $? -ne 0 ]; then
    echo "Error: Failed to install dependencies"
    exit 1
fi

echo ""
echo "Running linter..."
npm run lint
if [ $? -ne 0 ]; then
    echo "Warning: Linting failed, but continuing..."
fi

echo ""
echo "Building TypeScript..."
npm run build
if [ $? -ne 0 ]; then
    echo "Error: TypeScript build failed"
    exit 1
fi

echo ""
echo "Checking Firebase project..."
firebase use
if [ $? -ne 0 ]; then
    echo "Error: No Firebase project selected"
    echo "Please run 'firebase use <project-id>' to select a project"
    exit 1
fi

echo ""
echo "Deploying to Firebase..."
firebase deploy --only functions
if [ $? -ne 0 ]; then
    echo "Error: Deployment failed"
    echo ""
    echo "Common solutions:"
    echo "1. Check your internet connection"
    echo "2. Verify Firebase project has Blaze plan"
    echo "3. Ensure you have deployment permissions"
    echo "4. Try 'firebase login' to re-authenticate"
    exit 1
fi

echo ""
echo "========================================"
echo "Deployment completed successfully!"
echo "========================================"
echo ""
echo "Your Cloud Functions are now live!"
echo "Check the Firebase Console for monitoring and logs:"
echo "https://console.firebase.google.com/project/$(firebase use | grep 'Now using project' | cut -d' ' -f4)/functions"
echo ""
