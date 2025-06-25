#!/bin/bash

# Simple Firebase Test Lab Script
# Easy-to-use script for quick testing on Firebase Test Lab

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Default configuration
FIREBASE_PROJECT_ID="${FIREBASE_PROJECT_ID:-your-project-id}"
TEST_TYPE="robo"  # Default to robo test (easier)
DEVICE="model=Pixel3,version=30,locale=en,orientation=portrait"
TIMEOUT="15m"

echo -e "${BLUE}🔥 Firebase Test Lab Simple Runner${NC}"
echo "=================================="

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --project)
      FIREBASE_PROJECT_ID="$2"
      shift 2
      ;;
    --device)
      DEVICE="$2"
      shift 2
      ;;
    --timeout)
      TIMEOUT="$2"
      shift 2
      ;;
    --instrumentation)
      TEST_TYPE="instrumentation"
      shift
      ;;
    --help)
      echo "Usage: $0 [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --project PROJECT_ID     Firebase project ID"
      echo "  --device DEVICE_CONFIG   Device configuration (default: Pixel3)"
      echo "  --timeout TIMEOUT        Test timeout (default: 15m)"
      echo "  --instrumentation        Use instrumentation tests instead of robo"
      echo "  --help                   Show this help"
      echo ""
      echo "Examples:"
      echo "  $0 --project my-app-123"
      echo "  $0 --project my-app-123 --device 'model=Pixel6,version=33,locale=en,orientation=portrait'"
      echo "  $0 --project my-app-123 --instrumentation"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Validate project ID
if [ "$FIREBASE_PROJECT_ID" = "your-project-id" ]; then
    echo -e "${RED}❌ Please set your Firebase project ID${NC}"
    echo "Usage: $0 --project YOUR_PROJECT_ID"
    exit 1
fi

echo -e "${BLUE}📋 Configuration:${NC}"
echo "  Project ID: $FIREBASE_PROJECT_ID"
echo "  Test Type: $TEST_TYPE"
echo "  Device: $DEVICE"
echo "  Timeout: $TIMEOUT"
echo ""

# Check prerequisites
echo -e "${BLUE}🔍 Checking prerequisites...${NC}"

if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter not found. Please install Flutter.${NC}"
    exit 1
fi

if ! command -v gcloud &> /dev/null; then
    echo -e "${RED}❌ gcloud CLI not found. Please install Firebase CLI.${NC}"
    echo "Install: npm install -g firebase-tools"
    exit 1
fi

# Check authentication
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | head -n 1 > /dev/null; then
    echo -e "${RED}❌ Not authenticated with gcloud.${NC}"
    echo "Please run: gcloud auth login"
    exit 1
fi

echo -e "${GREEN}✅ Prerequisites check passed${NC}"

# Set project
echo -e "${BLUE}🔧 Setting up Firebase project...${NC}"
gcloud config set project "$FIREBASE_PROJECT_ID"

# Build APK
echo -e "${BLUE}🔨 Building APK...${NC}"
flutter clean
flutter pub get
flutter build apk --debug

if [ ! -f "build/app/outputs/flutter-apk/app-debug.apk" ]; then
    echo -e "${RED}❌ APK build failed${NC}"
    exit 1
fi

echo -e "${GREEN}✅ APK built successfully${NC}"

# Build test APK if needed
if [ "$TEST_TYPE" = "instrumentation" ]; then
    echo -e "${BLUE}🔨 Building test APK...${NC}"
    
    if [ -d "integration_test" ]; then
        flutter build apk --debug integration_test/test_flows/auth_flow_test.dart
        
        if [ ! -f "build/app/outputs/flutter-apk/app-debug-androidTest.apk" ]; then
            echo -e "${YELLOW}⚠️ Test APK build failed, switching to robo test${NC}"
            TEST_TYPE="robo"
        else
            echo -e "${GREEN}✅ Test APK built successfully${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️ No integration tests found, using robo test${NC}"
        TEST_TYPE="robo"
    fi
fi

# Run test
echo -e "${BLUE}🚀 Running test on Firebase Test Lab...${NC}"
echo "This may take several minutes..."

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
RESULTS_DIR="simple-test-$TIMESTAMP"

if [ "$TEST_TYPE" = "robo" ]; then
    echo -e "${BLUE}🤖 Running Robo test...${NC}"
    
    gcloud firebase test android run \
        --type robo \
        --app build/app/outputs/flutter-apk/app-debug.apk \
        --device "$DEVICE" \
        --timeout "$TIMEOUT" \
        --robo-directives login_username=admin@test.com,login_password=admin123 \
        --results-bucket="gs://${FIREBASE_PROJECT_ID}-test-results" \
        --results-dir="$RESULTS_DIR" \
        --no-record-video
else
    echo -e "${BLUE}🧪 Running instrumentation test...${NC}"
    
    gcloud firebase test android run \
        --type instrumentation \
        --app build/app/outputs/flutter-apk/app-debug.apk \
        --test build/app/outputs/flutter-apk/app-debug-androidTest.apk \
        --device "$DEVICE" \
        --timeout "$TIMEOUT" \
        --results-bucket="gs://${FIREBASE_PROJECT_ID}-test-results" \
        --results-dir="$RESULTS_DIR" \
        --no-record-video
fi

# Check result
if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}🎉 Test completed successfully!${NC}"
    echo ""
    echo -e "${BLUE}📊 Results:${NC}"
    echo "  Firebase Console: https://console.firebase.google.com/project/$FIREBASE_PROJECT_ID/testlab/histories/"
    echo "  Results Bucket: gs://${FIREBASE_PROJECT_ID}-test-results/$RESULTS_DIR"
    echo ""
    echo -e "${BLUE}💡 Next steps:${NC}"
    echo "  1. Check the Firebase Console for detailed results"
    echo "  2. Review any failed tests or crashes"
    echo "  3. Download logs and screenshots if needed"
    echo "  4. Run additional tests on different devices if required"
else
    echo ""
    echo -e "${RED}❌ Test failed or encountered errors${NC}"
    echo ""
    echo -e "${BLUE}🔍 Troubleshooting:${NC}"
    echo "  1. Check the Firebase Console for error details"
    echo "  2. Verify your APK is working correctly"
    echo "  3. Check device availability in Test Lab"
    echo "  4. Review the gcloud command output above"
fi

echo ""
echo -e "${BLUE}📱 Available devices for testing:${NC}"
echo "  Pixel 2: model=Pixel2,version=28,locale=en,orientation=portrait"
echo "  Pixel 3: model=Pixel3,version=30,locale=en,orientation=portrait"
echo "  Pixel 4: model=Pixel4,version=31,locale=en,orientation=portrait"
echo "  Pixel 6: model=Pixel6,version=33,locale=en,orientation=portrait"
echo "  Samsung J7: model=j7xelte,version=23,locale=en,orientation=portrait"
echo "  Nexus 9 Tablet: model=Nexus9,version=25,locale=en,orientation=landscape"
echo ""
echo -e "${BLUE}🔄 To test on different device:${NC}"
echo "  $0 --project $FIREBASE_PROJECT_ID --device 'model=Pixel6,version=33,locale=en,orientation=portrait'"
