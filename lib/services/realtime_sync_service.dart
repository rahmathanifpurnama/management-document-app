import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/documents/bloc/document_bloc.dart';
import '../features/documents/bloc/document_event.dart';
import '../features/category/bloc/category_bloc.dart';
import '../features/category/bloc/category_event.dart' as category_events;
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
      // PERMISSION FIX: Check if user is properly authenticated before starting listener
      final currentUser = _firebaseService.auth.currentUser;
      if (currentUser == null) {
        debugPrint(
          '⚠️ RealtimeSyncService document sync not started - user not authenticated',
        );
        return;
      }

      // Note: DocumentBloc handles its own sync, so we can proceed with real-time updates
      debugPrint(
        '🔄 Starting real-time document sync with DocumentBloc integration',
      );

      // Cancel existing subscription
      _subscriptions['documents']?.cancel();

      // PERFORMANCE FIX: Listen to document changes with pagination to prevent ANR
      _subscriptions['documents'] = _firebaseService.documentsCollection
          .where('isActive', isEqualTo: true)
          .orderBy('uploadedAt', descending: true)
          .limit(20) // Limit real-time updates to prevent ANR
          .snapshots()
          .listen(
            (snapshot) {
              _handleDocumentChanges(snapshot.docs);
            },
            onError: (error) {
              debugPrint('Document sync error: $error');
              // Continue with cached data if real-time sync fails
            },
          );

      debugPrint('✅ RealtimeSyncService document listener started');
    } catch (e) {
      debugPrint('Failed to start document sync: $e');
    }
  }

  /// Handle document changes from Firebase
  void _handleDocumentChanges(List<dynamic> docs) {
    if (_context == null) return;

    try {
      // Trigger refresh to sync with Firebase data using DocumentBloc
      Future.microtask(() {
        _context!.read<DocumentBloc>().add(
          const DocumentEvent.refreshDocuments(),
        );
      });
    } catch (e) {
      debugPrint('Error handling document changes: $e');
    }
  }

  /// Trigger immediate UI refresh across all file display components
  void triggerUIRefresh() {
    if (_context == null) return;

    try {
      // Single refresh using DocumentBloc instead of multiple timers to reduce Firebase calls
      _context!.read<DocumentBloc>().add(
        const DocumentEvent.refreshDocuments(),
      );
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
        // Refresh category data using CategoryBloc
        Future.microtask(() {
          // Force refresh categories to update file counts
          _context!.read<CategoryBloc>().add(
            const category_events.CategoryEvent.loadCategories(),
          );
        });
      } catch (e) {
        debugPrint('Error refreshing category BLoC: $e');
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
