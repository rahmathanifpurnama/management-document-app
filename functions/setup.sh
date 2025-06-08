#!/bin/bash

echo "========================================"
echo "Firebase Cloud Functions Setup"
echo "========================================"

echo ""
echo "Checking Node.js version..."
if ! command -v node &> /dev/null; then
    echo "Error: Node.js is not installed"
    echo "Please install Node.js 18 or later from https://nodejs.org/"
    exit 1
fi

node --version

echo ""
echo "Checking npm version..."
npm --version

echo ""
echo "Checking Firebase CLI..."
if ! command -v firebase &> /dev/null; then
    echo "Firebase CLI not found. Installing..."
    npm install -g firebase-tools
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install Firebase CLI"
        echo "You may need to run with administrator privileges"
        exit 1
    fi
else
    echo "Firebase CLI found:"
    firebase --version
fi

echo ""
echo "Installing project dependencies..."
npm install
if [ $? -ne 0 ]; then
    echo "Error: Failed to install dependencies"
    exit 1
fi

echo ""
echo "Installing TypeScript types..."
npm install --save-dev @types/uuid @types/node @types/express @types/cors
if [ $? -ne 0 ]; then
    echo "Warning: Failed to install some TypeScript types, but continuing..."
fi

echo ""
echo "Updating dependencies to latest compatible versions..."
npm update
if [ $? -ne 0 ]; then
    echo "Warning: Failed to update some dependencies, but continuing..."
fi

echo ""
echo "Setting up TypeScript..."
echo "Cleaning previous build..."
rm -rf lib/

echo "Building TypeScript..."
npm run build
if [ $? -ne 0 ]; then
    echo ""
    echo "========================================"
    echo "TypeScript build failed!"
    echo "========================================"
    echo ""
    echo "Common solutions:"
    echo "1. Check if all dependencies are installed correctly"
    echo "2. Verify TypeScript configuration in tsconfig.json"
    echo "3. Check for syntax errors in source files"
    echo "4. Try running 'npm install' again"
    echo ""
    echo "You can also try:"
    echo "  npm run build --verbose  # For detailed error output"
    echo "  npx tsc --noEmit        # To check types without building"
    echo ""
    exit 1
fi

echo ""
echo "Checking Firebase login status..."
firebase projects:list &> /dev/null
if [ $? -ne 0 ]; then
    echo "Not logged in to Firebase. Starting login process..."
    firebase login
    if [ $? -ne 0 ]; then
        echo "Error: Firebase login failed"
        exit 1
    fi
else
    echo "Already logged in to Firebase"
fi

echo ""
echo "========================================"
echo "Setup completed successfully!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. Make sure you're in the correct Firebase project"
echo "2. Run './deploy.sh' to deploy functions"
echo "3. Or run 'npm run serve' to test locally"
echo ""
echo "Available commands:"
echo "  ./deploy.sh          - Deploy functions to Firebase"
echo "  npm run serve        - Start local emulator"
echo "  npm run build        - Build TypeScript"
echo "  npm run lint         - Run linter"
echo ""
