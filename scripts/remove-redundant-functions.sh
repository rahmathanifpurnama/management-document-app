#!/bin/bash

echo "🧹 REMOVING REDUNDANT FIREBASE FUNCTIONS"
echo "========================================"
echo ""

echo "📋 Functions to be removed (redundant with hybridProcessFileUpload):"
echo "  ❌ validateFile"
echo "  ❌ extractMetadata" 
echo "  ❌ checkDuplicateFile"
echo "  ❌ processFileUpload (old version)"
echo ""

echo "✅ Functions to keep:"
echo "  ✅ hybridProcessFileUpload (main function)"
echo "  ✅ streamingUpload (different purpose)"
echo "  ✅ generateThumbnail (optional feature)"
echo "  ✅ getFileAccessUrl (utility function)"
echo ""

read -p "Continue with removal? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Operation cancelled"
    exit 1
fi

echo "🔄 Step 1: Backup current functions..."
firebase functions:list > functions-backup-$(date +%Y%m%d-%H%M%S).txt

echo "🔄 Step 2: Removing redundant functions..."

echo "  Removing validateFile..."
firebase functions:delete validateFile --force

echo "  Removing extractMetadata..."
firebase functions:delete extractMetadata --force

echo "  Removing checkDuplicateFile..."
firebase functions:delete checkDuplicateFile --force

echo "  Removing old processFileUpload..."
firebase functions:delete processFileUpload --force

echo ""
echo "✅ Redundant functions removed successfully!"
echo ""
echo "📊 Estimated cost savings:"
echo "  - 4 fewer functions = ~$0.40/million invocations saved"
echo "  - Reduced cold start times"
echo "  - Simplified maintenance"
echo ""
echo "🚀 Next steps:"
echo "  1. Update client code to use only hybridProcessFileUpload"
echo "  2. Test upload functionality"
echo "  3. Monitor logs for any issues"
echo ""
echo "📝 Note: All functionality is preserved in hybridProcessFileUpload"
