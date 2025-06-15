import 'package:flutter/material.dart';
import '../screens/admin/firestore_management_screen.dart';
import '../services/firestore_bulk_delete_service.dart';

/// Helper class to easily access Firestore management operations
class FirestoreManagementHelper {
  
  /// Navigate to the Firestore Management UI Screen
  static void openManagementScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FirestoreManagementScreen(),
      ),
    );
  }

  /// Quick delete all documents (for your specific use case)
  static Future<void> quickDeleteAllDocuments() async {
    await FirestoreBulkDeleteService.quickDeleteAllDocuments();
  }

  /// Delete only document metadata (recommended for your case)
  static Future<void> deleteDocumentMetadata() async {
    await FirestoreBulkDeleteService.quickDeleteSpecificCollections([
      'documents', // Your file metadata
    ]);
  }

  /// Delete common metadata collections
  static Future<void> deleteMetadataCollections() async {
    await FirestoreBulkDeleteService.quickDeleteSpecificCollections([
      'documents',
      'activities',
      'processing_queue',
      'file_cache',
    ]);
  }

  /// Preview what would be deleted (safe operation)
  static Future<void> previewDeletion() async {
    await FirestoreBulkDeleteService.quickPreviewDeletion();
  }

  /// Show a confirmation dialog before performing dangerous operations
  static Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'DELETE',
    String cancelText = 'Cancel',
  }) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red[700]),
              const SizedBox(width: 8),
              Text(title),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.red[700], size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'This action cannot be undone!',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(confirmText),
            ),
          ],
        );
      },
    ) ?? false;
  }

  /// Safe delete with confirmation dialog
  static Future<void> safeDeleteDocumentMetadata(BuildContext context) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete Document Metadata',
      message: 'This will permanently delete all document metadata from your Firestore database. '
               'Your files in Firebase Storage will remain intact, but you will need to re-sync them.',
    );

    if (confirmed) {
      try {
        // Show loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Deleting document metadata...'),
              ],
            ),
          ),
        );

        await deleteDocumentMetadata();

        // Close loading dialog
        Navigator.of(context).pop();

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Success'),
              ],
            ),
            content: const Text('Document metadata has been successfully deleted.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        // Close loading dialog if open
        Navigator.of(context).pop();

        // Show error dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 8),
                Text('Error'),
              ],
            ),
            content: Text('Failed to delete document metadata: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  /// Add a floating action button to any screen for quick access
  static Widget buildQuickAccessFAB(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => openManagementScreen(context),
      backgroundColor: Colors.red[700],
      foregroundColor: Colors.white,
      icon: const Icon(Icons.storage),
      label: const Text('DB Manager'),
    );
  }

  /// Add a menu item to any app bar
  static PopupMenuItem<String> buildMenuAction(BuildContext context) {
    return PopupMenuItem<String>(
      value: 'firestore_management',
      child: const Row(
        children: [
          Icon(Icons.storage, color: Colors.red),
          SizedBox(width: 8),
          Text('Firestore Management'),
        ],
      ),
    );
  }

  /// Handle menu action selection
  static void handleMenuAction(BuildContext context, String action) {
    if (action == 'firestore_management') {
      openManagementScreen(context);
    }
  }
}
