# Direct Storage Deletion Service

## Overview

The `DirectStorageDeletionService` is a standalone Firebase Storage deletion service that bypasses Firestore entirely and works directly with Firebase Storage. This service is designed to solve document ID errors when trying to access documents-metadata in Firestore by providing direct storage operations.

## Key Features

- **Firestore-Independent**: Works directly with Firebase Storage without requiring Firestore document references
- **Admin-Only Permissions**: Enforces admin-only deletion policies for security
- **Comprehensive Error Handling**: Provides detailed error information for storage operations
- **Batch Operations**: Supports deleting multiple files in a single operation
- **Pattern Matching**: Can find and delete files by filename patterns
- **File Information**: Get file metadata without deleting

## Installation

The service is already included in your project at:
```
lib/services/direct_storage_deletion_service.dart
```

## Usage

### Basic Setup

```dart
import '../services/direct_storage_deletion_service.dart';

final deletionService = DirectStorageDeletionService.instance;
```

### 1. Delete Single File by Path

```dart
Future<void> deleteSingleFile() async {
  const storagePath = 'documents/user123/sample-document.pdf';
  
  final result = await deletionService.deleteFileByPath(storagePath);
  
  if (result.success) {
    print('✅ File deleted: ${result.fileName}');
    print('📏 Size: ${result.fileSize} bytes');
  } else {
    print('❌ Deletion failed: ${result.message}');
    print('🔍 Error code: ${result.errorCode}');
  }
}
```

### 2. Delete Multiple Files

```dart
Future<void> deleteMultipleFiles() async {
  const storagePaths = [
    'documents/user123/file1.pdf',
    'documents/user123/file2.docx',
    'documents/user456/file3.jpg',
  ];
  
  final result = await deletionService.deleteMultipleFilesByPath(
    storagePaths,
    continueOnError: true, // Continue even if some files fail
  );
  
  print('📊 Results: ${result.successCount}/${result.totalFiles} successful');
  
  // Check individual results
  for (final fileResult in result.results) {
    if (fileResult.success) {
      print('✅ ${fileResult.fileName}: deleted');
    } else {
      print('❌ ${fileResult.path}: ${fileResult.message}');
    }
  }
}
```

### 3. Delete Files by Pattern

```dart
Future<void> deleteFilesByPattern() async {
  // Delete all files containing "temp" in their name
  final result = await deletionService.deleteFilesByPattern(
    'temp',
    searchPath: 'documents',
    exactMatch: false, // Partial match
  );
  
  print('🔍 Found and deleted ${result.successCount} files');
}
```

### 4. Get File Information

```dart
Future<void> getFileInfo() async {
  const storagePath = 'documents/user123/sample-document.pdf';
  
  final fileInfo = await deletionService.getFileInfo(storagePath);
  
  if (fileInfo.success) {
    print('📄 File: ${fileInfo.name}');
    print('📏 Size: ${fileInfo.formattedSize}');
    print('📅 Created: ${fileInfo.timeCreated}');
    print('🏷️ Type: ${fileInfo.contentType}');
  } else {
    print('❌ Failed to get info: ${fileInfo.message}');
  }
}
```

## Storage Path Format

The service expects storage paths in the format:
```
documents/userId/filename.extension
```

Examples:
- `documents/user123/report.pdf`
- `documents/admin456/image.jpg`
- `documents/user789/presentation.pptx`

## Error Handling

The service provides comprehensive error handling with specific error codes:

### Common Error Codes

- `UNAUTHORIZED`: User doesn't have admin permissions
- `INVALID_PATH`: Storage path format is invalid
- `NOT_FOUND`: File doesn't exist in storage
- `DELETION_FAILED`: Storage deletion operation failed
- `BATCH_ERROR`: Error during batch operation

### Error Response Structure

```dart
class StorageDeletionResult {
  final bool success;
  final String path;
  final String message;
  final String? errorCode;
  final String? fileName;
  final int? fileSize;
  final DateTime timestamp;
}
```

## Security Features

### Admin-Only Access

- All deletion operations require admin privileges
- Uses `AdminPermissionService` to verify user permissions
- Unauthorized users receive `UNAUTHORIZED` error

### Path Validation

- Validates storage path format
- Prevents directory traversal attacks (`../`)
- Ensures proper file extensions
- Rejects empty or malformed paths

## Best Practices

### 1. Always Check Results

```dart
final result = await deletionService.deleteFileByPath(path);
if (!result.success) {
  // Handle error appropriately
  logger.error('Deletion failed: ${result.message}');
  return;
}
```

### 2. Use Batch Operations for Multiple Files

```dart
// Efficient - single batch operation
await deletionService.deleteMultipleFilesByPath(paths);

// Inefficient - multiple individual operations
for (final path in paths) {
  await deletionService.deleteFileByPath(path);
}
```

### 3. Handle Different Error Scenarios

```dart
switch (result.errorCode) {
  case 'UNAUTHORIZED':
    showUnauthorizedDialog();
    break;
  case 'NOT_FOUND':
    showFileNotFoundMessage();
    break;
  case 'DELETION_FAILED':
    showDeletionErrorDialog(result.message);
    break;
  default:
    showGenericErrorDialog();
}
```

## Troubleshooting

### Common Issues

1. **"Admin privileges required"**
   - Ensure user has admin role in Firestore users collection
   - Check `AdminPermissionService` configuration

2. **"File not found"**
   - Verify the storage path is correct
   - Check if file exists using `getFileInfo()` first

3. **"Invalid path format"**
   - Ensure path doesn't start/end with `/`
   - Include file extension
   - Avoid special characters like `../`

### Debug Mode

Enable debug logging to see detailed operation information:

```dart
import 'package:flutter/foundation.dart';

// Debug prints are automatically shown in debug mode
// Look for logs starting with 🗑️, ✅, ❌, 🔍
```

## Integration with Existing Code

This service is designed to work independently of your existing Firestore-based deletion logic. You can:

1. **Replace existing deletion calls** with direct storage operations
2. **Use as fallback** when Firestore document ID issues occur
3. **Combine with cleanup operations** to remove orphaned files

## Performance Considerations

- **Batch operations** are more efficient than individual deletions
- **Pattern matching** searches entire folder structures (use specific paths when possible)
- **File existence checks** add overhead but prevent unnecessary operations
- **Admin permission checks** are cached for performance

## Examples

See `lib/examples/direct_storage_deletion_example.dart` for complete working examples of all service features.

## Testing

Run the test suite to verify service functionality:

```bash
flutter test test/services/direct_storage_deletion_service_test.dart
```

The test suite covers:
- Path validation
- Result class functionality
- Error handling scenarios
- Batch operation logic
