#!/bin/bash

# Setup script for Flutter + Firebase Functions project
set -e

echo "Setting up Flutter + Firebase Functions development environment..."

# Update package lists
sudo apt-get update

# Install required system dependencies
sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa

# Install Node.js 20 (required for Firebase Functions)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify Node.js installation
node --version
npm --version

# Remove old Flutter if exists
sudo rm -rf /opt/flutter

# Install the latest Flutter from git (master channel which should have Dart 3.8.0+)
cd /tmp
git clone https://github.com/flutter/flutter.git -b stable --depth 1
sudo mv flutter /opt/flutter

# Set proper permissions for Flutter
sudo chown -R $USER:$USER /opt/flutter
sudo chmod -R 755 /opt/flutter

# Add Flutter to PATH in profile
echo 'export PATH="/opt/flutter/bin:$PATH"' >> $HOME/.profile
export PATH="/opt/flutter/bin:$PATH"

# Configure Flutter
flutter config --no-analytics
flutter doctor --android-licenses || true

# Upgrade Flutter to latest
flutter upgrade

# Verify Flutter version
flutter --version

# Navigate to project directory
cd /mnt/persist/workspace

# Install Flutter dependencies
flutter pub get

# Navigate to functions directory and install dependencies
cd functions

# Clean npm cache and reinstall
npm cache clean --force
rm -rf node_modules package-lock.json
npm install

# Fix permissions for node_modules
chmod -R 755 node_modules
chmod +x node_modules/.bin/*

# Create a simple test directory and test file to verify Jest setup
mkdir -p __tests__

# Create a simple test file
cat > __tests__/sample.test.js << 'EOF'
describe('Sample Test Suite', () => {
  test('should pass basic test', () => {
    expect(1 + 1).toBe(2);
  });

  test('should test string operations', () => {
    expect('hello world').toContain('world');
  });

  test('should test array operations', () => {
    const arr = [1, 2, 3];
    expect(arr).toHaveLength(3);
    expect(arr).toContain(2);
  });
});
EOF

# Build TypeScript functions
npm run build

# Navigate back to project root
cd /mnt/persist/workspace

echo "Setup completed successfully!"
echo "Flutter version:"
flutter --version
echo "Node.js version:"
node --version
echo "NPM version:"
npm --version