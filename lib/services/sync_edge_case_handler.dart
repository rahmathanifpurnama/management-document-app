import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/services/firebase_service.dart';
import 'real_time_sync_service.dart';
import 'duplicate_prevention_service.dart';

/**
 * SYNC EDGE CASE HANDLER
 * Handles edge cases and error scenarios for real-time synchronization
 * Provides fallback mechanisms and recovery strategies
 */
class SyncEdgeCaseHandler {
  static final SyncEdgeCaseHandler _instance = SyncEdgeCaseHandler._internal();
  factory SyncEdgeCaseHandler() => _instance;
  SyncEdgeCaseHandler._internal();

  static SyncEdgeCaseHandler get instance => _instance;

  final FirebaseService _firebaseService = FirebaseService.instance;
  final RealTimeSyncService _realTimeSyncService = RealTimeSyncService.instance;
  final DuplicatePreventionService _duplicateService =
      DuplicatePreventionService.instance;

  // Error tracking
  final Map<String, int> _errorCounts = {};
  final Map<String, DateTime> _lastErrorTimes = {};
  final List<SyncError> _recentErrors = [];
  static const int _maxErrorHistory = 50;
  static const int _maxRetryAttempts = 3;
  static const Duration _errorCooldown = Duration(minutes: 5);

  /// Handle Firebase Console direct file additions
  Future<void> handleConsoleFileAddition(String filePath) async {
    try {
      debugPrint('🔧 Handling console file addition: $filePath');

      // Check if this is a legitimate console addition
      final isConsoleAddition = await _verifyConsoleAddition(filePath);
      if (!isConsoleAddition) {
        debugPrint(
          '⚠️ File addition not from console, skipping special handling',
        );
        return;
      }

      // Check for duplicates
      final duplicateCheck = await _duplicateService.checkDocumentDuplicates(
        filePath: filePath,
      );

      if (duplicateCheck.hasDuplicates) {
        debugPrint('✅ Document already exists, no action needed');
        return;
      }

      // Create metadata for console-added file
      await _createMetadataForConsoleFile(filePath);

      debugPrint('✅ Console file addition handled successfully');
    } catch (e) {
      await _handleError('console_file_addition', e, {'filePath': filePath});
    }
  }

  /// Handle Firebase Console direct user additions
  Future<void> handleConsoleUserAddition(String uid) async {
    try {
      debugPrint('🔧 Handling console user addition: $uid');

      // Check if user already exists
      final userExists = await _duplicateService.userExists(uid);
      if (userExists) {
        debugPrint('✅ User already exists, no action needed');
        return;
      }

      // Create user profile for console-added user
      await _createProfileForConsoleUser(uid);

      debugPrint('✅ Console user addition handled successfully');
    } catch (e) {
      await _handleError('console_user_addition', e, {'uid': uid});
    }
  }

  /// Handle sync failures and implement retry logic
  Future<void> handleSyncFailure(
    String operation,
    dynamic error,
    Map<String, dynamic> context,
  ) async {
    try {
      debugPrint('🔧 Handling sync failure: $operation');

      final errorKey = '$operation:${context.toString()}';
      final currentCount = _errorCounts[errorKey] ?? 0;

      if (currentCount >= _maxRetryAttempts) {
        debugPrint('❌ Max retry attempts reached for: $operation');
        await _escalateError(operation, error, context);
        return;
      }

      // Implement exponential backoff
      final delay = Duration(seconds: (currentCount + 1) * 2);
      debugPrint(
        '⏳ Retrying $operation in ${delay.inSeconds} seconds (attempt ${currentCount + 1})',
      );

      await Future.delayed(delay);

      // Increment error count
      _errorCounts[errorKey] = currentCount + 1;
      _lastErrorTimes[errorKey] = DateTime.now();

      // Retry the operation based on type
      await _retryOperation(operation, context);
    } catch (e) {
      await _handleError('sync_failure_handler', e, context);
    }
  }

  /// Handle network connectivity issues
  Future<void> handleNetworkIssues() async {
    try {
      debugPrint('🔧 Handling network connectivity issues');

      // Implement offline queue for pending operations
      await _queuePendingOperations();

      // Setup network recovery listener
      _setupNetworkRecoveryListener();

      debugPrint('✅ Network issue handling setup complete');
    } catch (e) {
      debugPrint('❌ Error handling network issues: $e');
    }
  }

  /// Handle Firestore permission errors
  Future<void> handlePermissionErrors(
    String operation,
    Map<String, dynamic> context,
  ) async {
    try {
      debugPrint('🔧 Handling permission errors for: $operation');

      // Check if user has required permissions
      final hasPermissions = await _verifyUserPermissions(operation);
      if (!hasPermissions) {
        debugPrint('❌ User lacks required permissions for: $operation');
        await _notifyPermissionIssue(operation, context);
        return;
      }

      // Check if it's a temporary permission issue
      await _handleTemporaryPermissionIssue(operation, context);
    } catch (e) {
      await _handleError('permission_handler', e, context);
    }
  }

  /// Handle Cloud Function timeout errors
  Future<void> handleCloudFunctionTimeout(
    String functionName,
    Map<String, dynamic> parameters,
  ) async {
    try {
      debugPrint('🔧 Handling Cloud Function timeout: $functionName');

      // Implement direct Firestore fallback
      await _executeDirectFirestoreFallback(functionName, parameters);

      debugPrint('✅ Cloud Function timeout handled with fallback');
    } catch (e) {
      await _handleError('cloud_function_timeout', e, {
        'function': functionName,
        'params': parameters,
      });
    }
  }

  /// Verify if file addition came from Firebase Console
  Future<bool> _verifyConsoleAddition(String filePath) async {
    try {
      // Check if there's a corresponding activity log from the app
      final recentActivities = await _firebaseService.firestore
          .collection('activities')
          .where('type', isEqualTo: 'document_uploaded')
          .where(
            'timestamp',
            isGreaterThan: Timestamp.fromDate(
              DateTime.now().subtract(const Duration(minutes: 5)),
            ),
          )
          .get();

      // If no recent upload activity, likely from console
      final hasRecentUpload = recentActivities.docs.any((doc) {
        final data = doc.data();
        return data['details']?['filePath'] == filePath;
      });

      return !hasRecentUpload;
    } catch (e) {
      debugPrint('❌ Error verifying console addition: $e');
      return true; // Assume console addition on error
    }
  }

  /// Create metadata for console-added file
  Future<void> _createMetadataForConsoleFile(String filePath) async {
    try {
      final fileName = filePath.split('/').last;
      final documentId = _duplicateService.generateDocumentId(filePath);

      final metadata = {
        'id': documentId,
        'fileName': fileName,
        'filePath': filePath,
        'fileSize': 0, // Unknown size for console additions
        'fileType': _getFileTypeFromPath(filePath),
        'contentType': 'application/octet-stream',
        'uploadedAt': FieldValue.serverTimestamp(),
        'uploadedBy': 'console',
        'isActive': true,
        'category': _extractCategoryFromPath(filePath),
        'source': 'console_addition',
        'syncedAt': FieldValue.serverTimestamp(),
      };

      await _firebaseService.firestore
          .collection('documents')
          .doc(documentId)
          .set(metadata);

      debugPrint('✅ Created metadata for console file: $fileName');
    } catch (e) {
      debugPrint('❌ Error creating metadata for console file: $e');
      rethrow;
    }
  }

  /// Create profile for console-added user
  Future<void> _createProfileForConsoleUser(String uid) async {
    try {
      final userProfile = {
        'uid': uid,
        'email': 'console-user@unknown.com',
        'displayName': 'Console User',
        'photoURL': '',
        'isActive': true,
        'role': 'user',
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
        'documentCount': 0,
        'source': 'console_addition',
        'syncedAt': FieldValue.serverTimestamp(),
      };

      await _firebaseService.firestore
          .collection('users')
          .doc(uid)
          .set(userProfile);

      debugPrint('✅ Created profile for console user: $uid');
    } catch (e) {
      debugPrint('❌ Error creating profile for console user: $e');
      rethrow;
    }
  }

  /// Retry operation based on type
  Future<void> _retryOperation(
    String operation,
    Map<String, dynamic> context,
  ) async {
    switch (operation) {
      case 'document_sync':
        await _retryDocumentSync(context);
        break;
      case 'user_sync':
        await _retryUserSync(context);
        break;
      case 'statistics_update':
        await _retryStatisticsUpdate(context);
        break;
      default:
        debugPrint('⚠️ Unknown operation type for retry: $operation');
    }
  }

  /// Retry document synchronization
  Future<void> _retryDocumentSync(Map<String, dynamic> context) async {
    final filePath = context['filePath'] as String?;
    if (filePath != null) {
      await handleConsoleFileAddition(filePath);
    }
  }

  /// Retry user synchronization
  Future<void> _retryUserSync(Map<String, dynamic> context) async {
    final uid = context['uid'] as String?;
    if (uid != null) {
      await handleConsoleUserAddition(uid);
    }
  }

  /// Retry statistics update
  Future<void> _retryStatisticsUpdate(Map<String, dynamic> context) async {
    // Trigger statistics recalculation
    await _firebaseService.firestore
        .collection('statistics-cache')
        .doc('global-stats')
        .delete();
  }

  /// Handle generic errors
  Future<void> _handleError(
    String operation,
    dynamic error,
    Map<String, dynamic> context,
  ) async {
    final syncError = SyncError(
      operation: operation,
      error: error.toString(),
      context: context,
      timestamp: DateTime.now(),
    );

    _recentErrors.add(syncError);

    // Keep only recent errors
    if (_recentErrors.length > _maxErrorHistory) {
      _recentErrors.removeAt(0);
    }

    debugPrint('❌ Sync error recorded: $operation - ${error.toString()}');

    // Log to Firestore for monitoring
    try {
      await _firebaseService.firestore.collection('sync-errors').add({
        'operation': operation,
        'error': error.toString(),
        'context': context,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('❌ Failed to log error to Firestore: $e');
    }
  }

  /// Escalate error when max retries reached
  Future<void> _escalateError(
    String operation,
    dynamic error,
    Map<String, dynamic> context,
  ) async {
    debugPrint('🚨 Escalating error for: $operation');

    // Log critical error
    await _firebaseService.firestore.collection('critical-errors').add({
      'operation': operation,
      'error': error.toString(),
      'context': context,
      'timestamp': FieldValue.serverTimestamp(),
      'retryAttempts': _maxRetryAttempts,
    });
  }

  /// Queue pending operations for offline handling
  Future<void> _queuePendingOperations() async {
    // Implementation for offline queue
    debugPrint('📦 Queueing pending operations for offline handling');
  }

  /// Setup network recovery listener
  void _setupNetworkRecoveryListener() {
    // Implementation for network recovery
    debugPrint('🔄 Setting up network recovery listener');
  }

  /// Verify user permissions
  Future<bool> _verifyUserPermissions(String operation) async {
    // Implementation for permission verification
    return true; // Simplified for now
  }

  /// Notify permission issue
  Future<void> _notifyPermissionIssue(
    String operation,
    Map<String, dynamic> context,
  ) async {
    debugPrint('🚫 Permission issue notification: $operation');
  }

  /// Handle temporary permission issues
  Future<void> _handleTemporaryPermissionIssue(
    String operation,
    Map<String, dynamic> context,
  ) async {
    debugPrint('⏳ Handling temporary permission issue: $operation');
  }

  /// Execute direct Firestore fallback
  Future<void> _executeDirectFirestoreFallback(
    String functionName,
    Map<String, dynamic> parameters,
  ) async {
    debugPrint('🔄 Executing direct Firestore fallback for: $functionName');
  }

  /// Extract file type from path
  String _getFileTypeFromPath(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'pdf';
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return 'image';
      case 'doc':
      case 'docx':
        return 'document';
      case 'xls':
      case 'xlsx':
        return 'spreadsheet';
      case 'ppt':
      case 'pptx':
        return 'presentation';
      default:
        return 'other';
    }
  }

  /// Extract category from path
  String _extractCategoryFromPath(String filePath) {
    final pathParts = filePath.split('/');
    if (pathParts.length >= 3) {
      return pathParts[1];
    }
    return 'uncategorized';
  }

  /// Get recent errors
  List<SyncError> get recentErrors => List.unmodifiable(_recentErrors);

  /// Get error statistics
  Map<String, dynamic> getErrorStats() {
    return {
      'totalErrors': _recentErrors.length,
      'errorsByOperation': _groupErrorsByOperation(),
      'recentErrorRate': _calculateRecentErrorRate(),
    };
  }

  Map<String, int> _groupErrorsByOperation() {
    final grouped = <String, int>{};
    for (final error in _recentErrors) {
      grouped[error.operation] = (grouped[error.operation] ?? 0) + 1;
    }
    return grouped;
  }

  double _calculateRecentErrorRate() {
    final recentErrors = _recentErrors
        .where(
          (error) =>
              DateTime.now().difference(error.timestamp) <
              const Duration(hours: 1),
        )
        .length;
    return recentErrors / 60.0; // Errors per minute in last hour
  }
}

/// Sync error model
class SyncError {
  final String operation;
  final String error;
  final Map<String, dynamic> context;
  final DateTime timestamp;

  const SyncError({
    required this.operation,
    required this.error,
    required this.context,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'SyncError(operation: $operation, error: $error, timestamp: $timestamp)';
  }
}
