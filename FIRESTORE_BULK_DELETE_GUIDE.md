# Firestore Bulk Delete Operations Guide

## ⚠️ CRITICAL WARNING
**These operations will permanently delete data from your Firestore database. This action CANNOT be undone. Use with extreme caution.**

## Quick Usage

### 1. Preview What Will Be Deleted (Safe)
```dart
import 'package:your_app/services/firestore_bulk_delete_service.dart';

// See what would be deleted without actually deleting anything
await FirestoreBulkDeleteService.quickPreviewDeletion();
```

### 2. Delete All Documents from All Collections
```dart
// ⚠️ WARNING: This deletes EVERYTHING!
await FirestoreBulkDeleteService.quickDeleteAllDocuments();
```

### 3. Delete Specific Collections Only
```dart
// Delete only specific collections
await FirestoreBulkDeleteService.quickDeleteSpecificCollections([
  'documents',
  'activities', 
  'processing_queue'
]);
```

## Using the Management UI

### 1. Add the Screen to Your App
Add this to your app's navigation:

```dart
import 'package:your_app/screens/admin/firestore_management_screen.dart';

// Navigate to the management screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const FirestoreManagementScreen(),
  ),
);
```

### 2. UI Features
- **Database Overview**: See all collections and document counts
- **Collection Selection**: Choose specific collections to delete
- **Dry Run**: Preview operations before executing
- **Confirmation**: Safety checkbox to prevent accidental deletion
- **Real-time Results**: See operation progress and results

## Step-by-Step Safe Process

### Step 1: Preview Your Database
```dart
final service = FirestoreBulkDeleteService.instance;
final overview = await service.getDatabaseOverview();
print('Total Collections: ${overview['total_collections']}');
print('Total Documents: ${overview['total_documents']}');
```

### Step 2: Test with Dry Run
```dart
// This shows what would be deleted without actually deleting
final result = await service.deleteAllDocumentsFromAllCollections(
  dryRun: true, // SAFE - no actual deletion
);
print('Would delete: ${result['total_deleted']} documents');
```

### Step 3: Delete Specific Collections (Recommended)
```dart
// Delete only the collections you want to clean
final result = await service.deleteSpecificCollections([
  'activities',      // Activity logs
  'processing_queue', // Processing queue
  'file_cache',      // File cache
], dryRun: false); // REAL DELETION
```

### Step 4: Nuclear Option (Delete Everything)
```dart
// ⚠️ ONLY if you want to delete EVERYTHING
final result = await service.deleteAllDocumentsFromAllCollections(
  dryRun: false, // REAL DELETION
);
```

## Common Use Cases

### Clean Up Metadata Only (Keep User Data)
```dart
await FirestoreBulkDeleteService.quickDeleteSpecificCollections([
  'activities',
  'processing_queue', 
  'file_cache',
  'notifications',
]);
```

### Complete Database Reset
```dart
// Preview first
await FirestoreBulkDeleteService.quickPreviewDeletion();

// Then delete everything
await FirestoreBulkDeleteService.quickDeleteAllDocuments();
```

### Clean Up Document Metadata (Your Original Request)
```dart
// This will delete all document metadata from the 'documents' collection
await FirestoreBulkDeleteService.quickDeleteSpecificCollections([
  'documents'
]);
```

## Safety Features

### 1. Dry Run Mode
All operations support dry run mode to preview results:
```dart
final result = await service.deleteAllDocumentsFromAllCollections(
  dryRun: true, // No actual deletion
);
```

### 2. Batch Processing
Operations are performed in batches to prevent overwhelming Firestore:
```dart
final result = await service.deleteAllDocumentsFromAllCollections(
  dryRun: false,
  batchSize: 50, // Process 50 documents at a time
);
```

### 3. Error Handling
Operations continue even if some documents fail to delete:
```dart
// Check results for errors
if (result['total_errors'] > 0) {
  print('Errors occurred: ${result['errors']}');
}
```

### 4. Progress Monitoring
Monitor progress through debug logs:
```dart
// Enable debug logging to see progress
import 'package:flutter/foundation.dart';
// Logs will show in debug console
```

## Collections in Your App

Based on your app structure, these are the likely collections:

- **documents** - Your file metadata (this is what you want to delete)
- **categories** - File categories
- **users** - User accounts
- **activities** - Activity logs
- **processing_queue** - File processing queue
- **settings** - App settings
- **notifications** - User notifications
- **file_cache** - Cached file data

## Recommended Approach for Your Use Case

Since you want to delete document metadata IDs:

```dart
// 1. Preview what's in the documents collection
final service = FirestoreBulkDeleteService.instance;
final count = await service.getCollectionDocumentCount('documents');
print('Documents collection has $count documents');

// 2. Delete only the documents collection
await FirestoreBulkDeleteService.quickDeleteSpecificCollections(['documents']);

// 3. Verify it's empty
final newCount = await service.getCollectionDocumentCount('documents');
print('Documents collection now has $newCount documents');
```

## Emergency Stop

If an operation is running and you need to stop it:
```dart
final service = FirestoreBulkDeleteService.instance;
service.stopOperation(); // This will halt ongoing operations
```

## Error Recovery

If operations fail:
1. Check the error messages in the result
2. Retry with smaller batch sizes
3. Delete collections one by one instead of all at once

## After Deletion

After deleting document metadata:
1. Your Firebase Storage files will remain intact
2. You may need to re-sync or re-upload file metadata
3. Categories and other data will remain unless specifically deleted

## Example: Complete Document Metadata Cleanup

```dart
import 'package:your_app/services/firestore_bulk_delete_service.dart';

Future<void> cleanupDocumentMetadata() async {
  try {
    print('🔍 Starting document metadata cleanup...');
    
    // 1. Preview current state
    await FirestoreBulkDeleteService.quickPreviewDeletion();
    
    // 2. Delete only document metadata
    await FirestoreBulkDeleteService.quickDeleteSpecificCollections([
      'documents',
      'activities',
      'processing_queue',
    ]);
    
    print('✅ Document metadata cleanup completed!');
    
  } catch (e) {
    print('❌ Cleanup failed: $e');
  }
}
```

## Support

If you encounter issues:
1. Check the debug logs for detailed error messages
2. Try smaller batch sizes
3. Use dry run mode to test operations
4. Delete collections one by one if bulk operations fail
