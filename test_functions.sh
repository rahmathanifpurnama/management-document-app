#!/bin/bash

echo "🔍 Testing Firebase Functions in Production..."
echo "================================================"

# Get Firebase project info
PROJECT_ID="document-management-c5a96"
REGION="us-central1"

# Function URLs
BASE_URL="https://${REGION}-${PROJECT_ID}.cloudfunctions.net"

echo ""
echo "📊 Testing getAggregatedStatistics..."
echo "======================================"
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"data":{}}' \
  "${BASE_URL}/getAggregatedStatistics" \
  | jq '.' 2>/dev/null || echo "Response received (jq not available for formatting)"

echo ""
echo ""
echo "📄 Testing getPaginatedFileStats..."
echo "===================================="
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"data":{"page":1,"limit":10}}' \
  "${BASE_URL}/getPaginatedFileStats" \
  | jq '.' 2>/dev/null || echo "Response received (jq not available for formatting)"

echo ""
echo ""
echo "🔍 Testing checkDataIntegrity..."
echo "================================"
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"data":{}}' \
  "${BASE_URL}/checkDataIntegrity" \
  | jq '.' 2>/dev/null || echo "Response received (jq not available for formatting)"

echo ""
echo ""
echo "🔄 Testing performComprehensiveSync..."
echo "======================================"
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"data":{}}' \
  "${BASE_URL}/performComprehensiveSync" \
  | jq '.' 2>/dev/null || echo "Response received (jq not available for formatting)"

echo ""
echo ""
echo "✅ All function tests completed!"
echo "================================"
