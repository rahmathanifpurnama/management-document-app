# Debug Widgets

⚠️ **FOR DEVELOPMENT/DEBUG PURPOSES ONLY** ⚠️

This folder contains widgets that are used for development, testing, and debugging purposes. These widgets should **NOT** be used in production screens.

## Contents

### `api_upload_demo_widget.dart`
- **Purpose**: Demo widget for testing Firebase Cloud Functions API integrations
- **Features**:
  - File selection testing
  - Upload security API testing
  - Enhanced upload API testing
  - Duplicate check API testing
  - Real-time API test results display
- **Usage**: For development and debugging upload functionality
- **Status**: Moved from `lib/widgets/upload/` to keep production code clean

## Usage Guidelines

1. **Development Only**: These widgets are for development and testing purposes
2. **No Production Use**: Do not import or use these widgets in production screens
3. **Testing**: Use these widgets to test and debug API integrations
4. **Documentation**: Always document the purpose and usage of debug widgets

## Adding New Debug Widgets

When adding new debug widgets to this folder:

1. Add clear documentation about the widget's purpose
2. Include warning comments about development-only usage
3. Use distinctive UI elements (like warning colors/badges) to indicate debug mode
4. Update this README with information about the new widget

## File Structure

```
lib/widgets/debug/
├── README.md                    # This file
├── api_upload_demo_widget.dart  # Upload API testing widget
└── [future debug widgets]       # Additional debug widgets

lib/screens/debug/
├── upload_api_debug_screen.dart # Screen for accessing upload debug tools
└── [other debug screens]        # Additional debug screens
```

## Important Notes

- These widgets may have different import paths compared to production widgets
- Debug widgets may use experimental or unstable APIs
- Always test debug widgets thoroughly before using them for testing production features
- Consider removing or disabling debug widgets in release builds
