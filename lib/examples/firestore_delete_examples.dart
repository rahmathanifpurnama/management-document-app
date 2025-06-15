import 'package:flutter/material.dart';
import '../services/firestore_bulk_delete_service.dart';
import '../utils/firestore_management_helper.dart';

/// Examples of how to use the Firestore bulk delete operations
/// These are practical examples you can copy and use in your app
class FirestoreDeleteExamples {
  
  /// Example 1: Quick delete all document metadata (your specific need)
  static Future<void> quickDeleteDocumentMetadata() async {
    try {
      print('🗑️ Starting quick delete of document metadata...');
      
      // Delete only the documents collection
      await FirestoreBulkDeleteService.quickDeleteSpecificCollections([
        'documents', // Your file metadata
      ]);
      
      print('✅ Document metadata deleted successfully!');
    } catch (e) {
      print('❌ Failed to delete document metadata: $e');
    }
  }

  /// Example 2: Preview what would be deleted (safe operation)
  static Future<void> previewDeletion() async {
    try {
      print('👁️ Previewing what would be deleted...');
      
      // This is safe - it only shows what would be deleted
      await FirestoreBulkDeleteService.quickPreviewDeletion();
      
      print('✅ Preview completed - check debug logs for details');
    } catch (e) {
      print('❌ Preview failed: $e');
    }
  }

  /// Example 3: Delete multiple metadata collections
  static Future<void> deleteAllMetadata() async {
    try {
      print('🗑️ Deleting all metadata collections...');
      
      await FirestoreBulkDeleteService.quickDeleteSpecificCollections([
        'documents',        // File metadata
        'activities',       // Activity logs
        'processing_queue', // Processing queue
        'file_cache',       // File cache
      ]);
      
      print('✅ All metadata deleted successfully!');
    } catch (e) {
      print('❌ Failed to delete metadata: $e');
    }
  }

  /// Example 4: Nuclear option - delete everything
  static Future<void> deleteEverything() async {
    try {
      print('🚨 WARNING: Deleting ALL data from ALL collections!');
      
      // This deletes EVERYTHING - use with extreme caution
      await FirestoreBulkDeleteService.quickDeleteAllDocuments();
      
      print('✅ All data deleted!');
    } catch (e) {
      print('❌ Failed to delete all data: $e');
    }
  }

  /// Example 5: Safe delete with UI confirmation
  static Future<void> safeDeleteWithConfirmation(BuildContext context) async {
    try {
      // This shows a confirmation dialog before deleting
      await FirestoreManagementHelper.safeDeleteDocumentMetadata(context);
    } catch (e) {
      print('❌ Safe delete failed: $e');
    }
  }

  /// Example 6: Step-by-step safe process
  static Future<void> stepByStepSafeProcess() async {
    try {
      print('📋 Step-by-step safe deletion process...');
      
      // Step 1: Get overview
      final service = FirestoreBulkDeleteService.instance;
      final overview = await service.getDatabaseOverview();
      print('📊 Database overview:');
      print('   Total Collections: ${overview['total_collections']}');
      print('   Total Documents: ${overview['total_documents']}');
      
      // Step 2: Preview deletion
      print('\n👁️ Previewing deletion...');
      await FirestoreBulkDeleteService.quickPreviewDeletion();
      
      // Step 3: Delete specific collections
      print('\n🗑️ Deleting document metadata...');
      await FirestoreBulkDeleteService.quickDeleteSpecificCollections([
        'documents',
      ]);
      
      // Step 4: Verify deletion
      final newOverview = await service.getDatabaseOverview();
      print('\n📊 After deletion:');
      print('   Total Collections: ${newOverview['total_collections']}');
      print('   Total Documents: ${newOverview['total_documents']}');
      
      print('✅ Step-by-step process completed!');
    } catch (e) {
      print('❌ Step-by-step process failed: $e');
    }
  }

  /// Example 7: Check specific collection count
  static Future<void> checkCollectionCount(String collectionName) async {
    try {
      final service = FirestoreBulkDeleteService.instance;
      final count = await service.getCollectionDocumentCount(collectionName);
      print('📊 Collection "$collectionName" has $count documents');
    } catch (e) {
      print('❌ Failed to check collection count: $e');
    }
  }

  /// Example 8: Custom collection deletion
  static Future<void> deleteCustomCollections(List<String> collections) async {
    try {
      print('🗑️ Deleting custom collections: ${collections.join(', ')}');
      
      await FirestoreBulkDeleteService.quickDeleteSpecificCollections(collections);
      
      print('✅ Custom collections deleted successfully!');
    } catch (e) {
      print('❌ Failed to delete custom collections: $e');
    }
  }
}

/// Widget examples for UI integration
class FirestoreDeleteWidgetExamples {
  
  /// Example: Simple button to delete document metadata
  static Widget buildDeleteButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        final confirmed = await FirestoreManagementHelper.showConfirmationDialog(
          context,
          title: 'Delete Document Metadata',
          message: 'This will permanently delete all document metadata from your database.',
        );
        
        if (confirmed) {
          await FirestoreDeleteExamples.quickDeleteDocumentMetadata();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Document metadata deleted successfully')),
          );
        }
      },
      icon: const Icon(Icons.delete_sweep),
      label: const Text('Delete Document Metadata'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
      ),
    );
  }

  /// Example: Card with multiple options
  static Widget buildManagementCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.storage, color: Colors.red[700], size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Database Management',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Manage your Firestore database and clean up metadata.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => FirestoreDeleteExamples.previewDeletion(),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text('Preview', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => FirestoreManagementHelper.openManagementScreen(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
                    child: const Text('Manage', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Example: List tile for settings
  static Widget buildSettingsListTile(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.storage, color: Colors.red[700]),
      title: const Text('Database Management'),
      subtitle: const Text('Clean up document metadata'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => FirestoreManagementHelper.openManagementScreen(context),
    );
  }

  /// Example: Floating action button
  static Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => FirestoreManagementHelper.openManagementScreen(context),
      backgroundColor: Colors.red[700],
      foregroundColor: Colors.white,
      icon: const Icon(Icons.storage),
      label: const Text('DB Manager'),
    );
  }
}

/// Usage instructions as comments
/*

HOW TO USE THESE EXAMPLES:

1. QUICK DELETE DOCUMENT METADATA (Your specific need):
   ```dart
   await FirestoreDeleteExamples.quickDeleteDocumentMetadata();
   ```

2. PREVIEW BEFORE DELETING (Safe):
   ```dart
   await FirestoreDeleteExamples.previewDeletion();
   ```

3. STEP-BY-STEP SAFE PROCESS:
   ```dart
   await FirestoreDeleteExamples.stepByStepSafeProcess();
   ```

4. ADD TO ANY SCREEN:
   ```dart
   // In your widget's build method
   FirestoreDeleteWidgetExamples.buildDeleteButton(context)
   ```

5. OPEN MANAGEMENT UI:
   ```dart
   FirestoreManagementHelper.openManagementScreen(context);
   ```

6. CHECK COLLECTION COUNT:
   ```dart
   await FirestoreDeleteExamples.checkCollectionCount('documents');
   ```

INTEGRATION LOCATIONS:
- Settings Screen: ✅ Already added
- Home Screen: Add FirestoreDeleteWidgetExamples.buildManagementCard(context)
- Admin Panel: Add FirestoreDeleteWidgetExamples.buildSettingsListTile(context)
- Any Screen: Add FirestoreDeleteWidgetExamples.buildFloatingActionButton(context)

*/
