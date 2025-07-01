import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/services/firebase_service.dart';
import '../models/document_model.dart';
import '../models/user_model.dart';

/**
 * REAL-TIME SYNCHRONIZATION SERVICE
 * Handles real-time detection and synchronization of changes from Firebase
 * Provides streams for real-time UI updates
 */
class RealTimeSyncService {
  static final RealTimeSyncService _instance = RealTimeSyncService._internal();
  factory RealTimeSyncService() => _instance;
  RealTimeSyncService._internal();

  static RealTimeSyncService get instance => _instance;

  final FirebaseService _firebaseService = FirebaseService.instance;

  // Stream controllers for real-time updates
  final StreamController<Map<String, dynamic>> _statisticsController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<List<DocumentModel>> _documentsController =
      StreamController<List<DocumentModel>>.broadcast();
  final StreamController<List<UserModel>> _usersController =
      StreamController<List<UserModel>>.broadcast();
  final StreamController<SyncEvent> _syncEventsController =
      StreamController<SyncEvent>.broadcast();

  // Firestore listeners
  StreamSubscription<QuerySnapshot>? _documentsSubscription;
  StreamSubscription<QuerySnapshot>? _usersSubscription;
  StreamSubscription<QuerySnapshot>? _activitiesSubscription;
  StreamSubscription<DocumentSnapshot>? _statisticsCacheSubscription;

  // Cache for preventing duplicate processing
  final Set<String> _processedDocuments = <String>{};
  final Set<String> _processedUsers = <String>{};

  // Statistics cache
  Map<String, dynamic>? _cachedStatistics;
  DateTime? _lastStatisticsUpdate;

  /// Initialize real-time synchronization
  Future<void> initialize() async {
    try {
      await _setupDocumentListener();
      await _setupUserListener();
      await _setupActivityListener();
      await _setupStatisticsCacheListener();
    } catch (e) {
      rethrow;
    }
  }

  /// Setup real-time listener for document-metadata collection
  Future<void> _setupDocumentListener() async {
    try {
      // PERMISSION FIX: Check if user is properly authenticated before starting listener
      final currentUser = _firebaseService.auth.currentUser;
      if (currentUser == null) {
        debugPrint('⚠️ Document listener not started - user not authenticated');
        return;
      }

      // REMOVED: document-metadata collection listener
      // This collection is no longer used and was causing permission errors
      // File data now comes directly from Firebase Storage only
      debugPrint('⚠️ Document listener disabled - using Storage-only approach');

      debugPrint('✅ Document listener setup complete');
    } catch (e) {
      debugPrint('❌ Error setting up document listener: $e');
      // Don't rethrow permission errors during login
      if (!e.toString().contains('permission-denied')) {
        rethrow;
      }
    }
  }

  /// Setup real-time listener for users collection
  Future<void> _setupUserListener() async {
    try {
      _usersSubscription = _firebaseService.firestore
          .collection('users')
          .snapshots()
          .listen(
            (snapshot) => _handleUserChanges(snapshot),
            onError: (error) {
              debugPrint('❌ User listener error: $error');
              _emitSyncEvent(SyncEventType.error, 'User sync error: $error');
            },
          );

      debugPrint('✅ User listener setup complete');
    } catch (e) {
      debugPrint('❌ Error setting up user listener: $e');
      rethrow;
    }
  }

  /// Setup listener for sync activities (for monitoring)
  Future<void> _setupActivityListener() async {
    try {
      _activitiesSubscription = _firebaseService.firestore
          .collection('activities')
          .where('source', isEqualTo: 'real_time_sync')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .snapshots()
          .listen(
            (snapshot) => _handleActivityChanges(snapshot),
            onError: (error) {
              debugPrint('❌ Activity listener error: $error');
            },
          );

      debugPrint('✅ Activity listener setup complete');
    } catch (e) {
      debugPrint('❌ Error setting up activity listener: $e');
      // Don't rethrow - activity monitoring is not critical
    }
  }

  /// Setup listener for statistics cache invalidation
  Future<void> _setupStatisticsCacheListener() async {
    try {
      _statisticsCacheSubscription = _firebaseService.firestore
          .collection('statistics-cache')
          .doc('global-stats')
          .snapshots()
          .listen(
            (snapshot) => _handleStatisticsCacheChanges(snapshot),
            onError: (error) {
              debugPrint('❌ Statistics cache listener error: $error');
            },
          );

      debugPrint('✅ Statistics cache listener setup complete');
    } catch (e) {
      debugPrint('❌ Error setting up statistics cache listener: $e');
      // Don't rethrow - cache monitoring is not critical
    }
  }

  /// Handle document collection changes
  void _handleDocumentChanges(QuerySnapshot snapshot) {
    try {
      final documents = <DocumentModel>[];
      bool hasNewDocuments = false;

      for (final change in snapshot.docChanges) {
        final doc = change.doc;
        final documentId = doc.id;

        switch (change.type) {
          case DocumentChangeType.added:
            if (!_processedDocuments.contains(documentId)) {
              _processedDocuments.add(documentId);
              hasNewDocuments = true;
              final data = doc.data() as Map<String, dynamic>?;
              final fileName = data?['fileName'] ?? 'Unknown File';
              debugPrint('📄 New document detected: $fileName');
            }
            break;
          case DocumentChangeType.modified:
            final data = doc.data() as Map<String, dynamic>?;
            final fileName = data?['fileName'] ?? 'Unknown File';
            debugPrint('📝 Document modified: $fileName');
            break;
          case DocumentChangeType.removed:
            _processedDocuments.remove(documentId);
            final data = doc.data() as Map<String, dynamic>?;
            final fileName = data?['fileName'] ?? 'Unknown File';
            debugPrint('🗑️ Document removed: $fileName');
            break;
        }

        try {
          final document = DocumentModel.fromFirestore(doc);
          documents.add(document);
        } catch (e) {
          debugPrint('⚠️ Error parsing document ${doc.id}: $e');
        }
      }

      // Emit updated documents list
      _documentsController.add(documents);

      // Emit sync event for new documents
      if (hasNewDocuments) {
        _emitSyncEvent(SyncEventType.documentAdded, 'New documents detected');
        _invalidateStatisticsCache();
      }

      debugPrint(
        '📊 Document changes processed: ${snapshot.docChanges.length} changes',
      );
    } catch (e) {
      debugPrint('❌ Error handling document changes: $e');
      _emitSyncEvent(
        SyncEventType.error,
        'Error processing document changes: $e',
      );
    }
  }

  /// Handle user collection changes
  void _handleUserChanges(QuerySnapshot snapshot) {
    try {
      final users = <UserModel>[];
      bool hasNewUsers = false;

      for (final change in snapshot.docChanges) {
        final doc = change.doc;
        final userId = doc.id;

        switch (change.type) {
          case DocumentChangeType.added:
            if (!_processedUsers.contains(userId)) {
              _processedUsers.add(userId);
              hasNewUsers = true;
              final data = doc.data() as Map<String, dynamic>?;
              final email = data?['email'] ?? 'Unknown Email';
              debugPrint('👤 New user detected: $email');
            }
            break;
          case DocumentChangeType.modified:
            final data = doc.data() as Map<String, dynamic>?;
            final email = data?['email'] ?? 'Unknown Email';
            debugPrint('👤 User modified: $email');
            break;
          case DocumentChangeType.removed:
            _processedUsers.remove(userId);
            final data = doc.data() as Map<String, dynamic>?;
            final email = data?['email'] ?? 'Unknown Email';
            debugPrint('👤 User removed: $email');
            break;
        }

        try {
          final user = UserModel.fromFirestore(doc);
          users.add(user);
        } catch (e) {
          debugPrint('⚠️ Error parsing user ${doc.id}: $e');
        }
      }

      // Emit updated users list
      _usersController.add(users);

      // Emit sync event for new users
      if (hasNewUsers) {
        _emitSyncEvent(SyncEventType.userAdded, 'New users detected');
        _invalidateStatisticsCache();
      }

      debugPrint(
        '👥 User changes processed: ${snapshot.docChanges.length} changes',
      );
    } catch (e) {
      debugPrint('❌ Error handling user changes: $e');
      _emitSyncEvent(SyncEventType.error, 'Error processing user changes: $e');
    }
  }

  /// Handle activity changes (for monitoring sync operations)
  void _handleActivityChanges(QuerySnapshot snapshot) {
    try {
      for (final change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final data = change.doc.data() as Map<String, dynamic>?;
          if (data != null) {
            final activityType = data['type'] as String?;
            final details = data['details'] as Map<String, dynamic>?;

            debugPrint(
              '🔔 Sync activity: $activityType - ${details?.toString()}',
            );

            // Emit sync event based on activity type
            if (activityType == 'document_created') {
              _emitSyncEvent(
                SyncEventType.documentAdded,
                'Document created via sync',
              );
            } else if (activityType == 'user_created') {
              _emitSyncEvent(SyncEventType.userAdded, 'User created via sync');
            }
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Error handling activity changes: $e');
    }
  }

  /// Handle statistics cache changes
  void _handleStatisticsCacheChanges(DocumentSnapshot snapshot) {
    try {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['statistics'] != null) {
          _cachedStatistics = Map<String, dynamic>.from(data['statistics']);
          _lastStatisticsUpdate = DateTime.now();

          // Emit updated statistics
          _statisticsController.add(_cachedStatistics!);

          debugPrint('📊 Statistics cache updated');
          _emitSyncEvent(
            SyncEventType.statisticsUpdated,
            'Statistics refreshed',
          );
        }
      } else {
        // Cache was deleted - statistics need to be recalculated
        debugPrint(
          '🔄 Statistics cache invalidated - triggering recalculation',
        );
        _emitSyncEvent(
          SyncEventType.statisticsInvalidated,
          'Statistics cache cleared',
        );
      }
    } catch (e) {
      debugPrint('❌ Error handling statistics cache changes: $e');
    }
  }

  /// Emit sync event
  void _emitSyncEvent(SyncEventType type, String message) {
    final event = SyncEvent(
      type: type,
      message: message,
      timestamp: DateTime.now(),
    );
    _syncEventsController.add(event);
  }

  /// Invalidate statistics cache to trigger recalculation
  Future<void> _invalidateStatisticsCache() async {
    try {
      await _firebaseService.firestore
          .collection('statistics-cache')
          .doc('global-stats')
          .delete();

      debugPrint('🔄 Statistics cache invalidated');
    } catch (e) {
      debugPrint('❌ Error invalidating statistics cache: $e');
    }
  }

  /// Get real-time statistics stream
  Stream<Map<String, dynamic>> get statisticsStream =>
      _statisticsController.stream;

  /// Get real-time documents stream
  Stream<List<DocumentModel>> get documentsStream =>
      _documentsController.stream;

  /// Get real-time users stream
  Stream<List<UserModel>> get usersStream => _usersController.stream;

  /// Get sync events stream
  Stream<SyncEvent> get syncEventsStream => _syncEventsController.stream;

  /// Get current cached statistics
  Map<String, dynamic>? get currentStatistics => _cachedStatistics;

  /// Check if service is initialized
  bool get isInitialized =>
      _documentsSubscription != null && _usersSubscription != null;

  /// Dispose all resources
  void dispose() {
    _documentsSubscription?.cancel();
    _usersSubscription?.cancel();
    _activitiesSubscription?.cancel();
    _statisticsCacheSubscription?.cancel();

    _statisticsController.close();
    _documentsController.close();
    _usersController.close();
    _syncEventsController.close();

    _processedDocuments.clear();
    _processedUsers.clear();

    debugPrint('🔄 RealTimeSyncService disposed');
  }
}

/// Sync event types
enum SyncEventType {
  documentAdded,
  documentModified,
  documentRemoved,
  userAdded,
  userModified,
  userRemoved,
  statisticsUpdated,
  statisticsInvalidated,
  error,
}

/// Sync event model
class SyncEvent {
  final SyncEventType type;
  final String message;
  final DateTime timestamp;

  const SyncEvent({
    required this.type,
    required this.message,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'SyncEvent(type: $type, message: $message, timestamp: $timestamp)';
  }
}
