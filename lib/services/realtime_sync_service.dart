import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/document_provider.dart';
import '../providers/category_provider.dart';
import '../core/services/firebase_service.dart';

/// Service to handle real-time synchronization between Firebase and UI components
class RealtimeSyncService {
  static RealtimeSyncService? _instance;
  static RealtimeSyncService get instance =>
      _instance ??= RealtimeSyncService._();

  RealtimeSyncService._();

  final FirebaseService _firebaseService = FirebaseService.instance;
  final Map<String, StreamSubscription> _subscriptions = {};
  BuildContext? _context;

  /// Initialize the service with app context
  void initialize(BuildContext context) {
    _context = context;
  }

  /// Start real-time synchronization for documents
  void startDocumentSync() {
    if (_context == null) return;

    try {
      // Cancel existing subscription
      _subscriptions['documents']?.cancel();

      // Listen to document changes
      _subscriptions['documents'] = _firebaseService.documentsCollection
          .snapshots()
          .listen(
            (snapshot) {
              _handleDocumentChanges(snapshot.docs);
            },
            onError: (error) {
              debugPrint('Document sync error: $error');
            },
          );
    } catch (e) {
      debugPrint('Failed to start document sync: $e');
    }
  }

  /// Handle document changes from Firebase
  void _handleDocumentChanges(List<dynamic> docs) {
    if (_context == null) return;

    try {
      final documentProvider = Provider.of<DocumentProvider>(
        _context!,
        listen: false,
      );

      // Trigger refresh to sync with Firebase data
      Future.microtask(() {
        documentProvider.forceRefresh();
      });
    } catch (e) {
      debugPrint('Error handling document changes: $e');
    }
  }

  /// Trigger immediate UI refresh across all file display components
  void triggerUIRefresh() {
    if (_context == null) return;

    try {
      final documentProvider = Provider.of<DocumentProvider>(
        _context!,
        listen: false,
      );

      // Single refresh instead of multiple timers to reduce Firebase calls
      documentProvider.forceRefresh();
      debugPrint('🔄 UI refresh triggered (single call)');
    } catch (e) {
      debugPrint('Error triggering UI refresh: $e');
    }
  }

  /// Notify about new file upload completion
  void notifyFileUploadComplete(String fileId, String? categoryId) {
    debugPrint('File upload completed: $fileId in category: $categoryId');

    // Trigger immediate UI refresh
    triggerUIRefresh();

    // Additional category-specific refresh if needed
    if (categoryId != null && _context != null) {
      try {
        final categoryProvider = Provider.of<CategoryProvider>(
          _context!,
          listen: false,
        );
        // Refresh category data if provider supports it
        Future.microtask(() {
          // Force refresh categories to update file counts
          categoryProvider.refreshCategories();
        });
      } catch (e) {
        debugPrint('Error refreshing category provider: $e');
      }
    }
  }

  /// Stop all real-time synchronization
  void stopSync() {
    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }

  /// Dispose the service
  void dispose() {
    stopSync();
    _context = null;
  }
}
