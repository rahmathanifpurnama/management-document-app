#!/bin/bash

echo "========================================"
echo "Firebase Functions Local Testing"
echo "========================================"

echo ""
echo "Building TypeScript..."
npm run build
if [ $? -ne 0 ]; then
    echo "Error: TypeScript build failed"
    exit 1
fi

echo ""
echo "Starting Firebase Emulators..."
echo "This will start:"
echo "- Functions Emulator (port 5001)"
echo "- Firestore Emulator (port 8080)"
echo "- Auth Emulator (port 9099)"
echo "- Storage Emulator (port 9199)"
echo "- Emulator UI (http://localhost:4000)"
echo ""
echo "Press Ctrl+C to stop the emulators"
echo ""

firebase emulators:start
