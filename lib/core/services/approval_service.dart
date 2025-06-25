import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import '../../models/document_model.dart';
import '../../models/notification_model.dart';

class ApprovalService {
  static final ApprovalService _instance = ApprovalService._internal();
  factory ApprovalService() => _instance;
  ApprovalService._internal();

  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Approve a single document
  Future<Map<String, dynamic>> approveDocument({
    required String documentId,
    String? reason,
  }) async {
    try {
      debugPrint('🔄 Approving document: $documentId');

      final callable = _functions.httpsCallable('approveDocument');
      final result = await callable.call({
        'documentId': documentId,
        'reason': reason,
      });

      debugPrint('✅ Document approved successfully: $documentId');
      return {
        'success': true,
        'message': result.data['message'] ?? 'Document approved successfully',
        'data': result.data,
      };
    } catch (e) {
      debugPrint('❌ Error approving document: $e');
      return {
        'success': false,
        'message': _getErrorMessage(e),
        'error': e.toString(),
      };
    }
  }

  /// Reject a single document
  Future<Map<String, dynamic>> rejectDocument({
    required String documentId,
    required String reason,
  }) async {
    try {
      debugPrint('🔄 Rejecting document: $documentId');

      final callable = _functions.httpsCallable('rejectDocument');
      final result = await callable.call({
        'documentId': documentId,
        'reason': reason,
      });

      debugPrint('✅ Document rejected successfully: $documentId');
      return {
        'success': true,
        'message': result.data['message'] ?? 'Document rejected successfully',
        'data': result.data,
      };
    } catch (e) {
      debugPrint('❌ Error rejecting document: $e');
      return {
        'success': false,
        'message': _getErrorMessage(e),
        'error': e.toString(),
      };
    }
  }

  /// Perform bulk operations on multiple documents
  Future<Map<String, dynamic>> bulkDocumentOperation({
    required List<String> documentIds,
    required String operation, // 'approve', 'reject', 'delete'
    String? reason,
  }) async {
    try {
      debugPrint(
        '🔄 Performing bulk $operation on ${documentIds.length} documents',
      );

      final callable = _functions.httpsCallable('bulkDocumentOperations');
      final result = await callable.call({
        'documentIds': documentIds,
        'operation': operation,
        'reason': reason,
      });

      debugPrint('✅ Bulk $operation completed successfully');
      return {
        'success': true,
        'message':
            result.data['message'] ?? 'Bulk operation completed successfully',
        'data': result.data,
        'results': result.data['results'] ?? [],
      };
    } catch (e) {
      debugPrint('❌ Error in bulk operation: $e');
      return {
        'success': false,
        'message': _getErrorMessage(e),
        'error': e.toString(),
      };
    }
  }

  /// Get pending documents that need approval
  Future<List<DocumentModel>> getPendingDocuments() async {
    try {
      debugPrint('🔄 Fetching pending documents for approval');

      final callable = _functions.httpsCallable('getPendingDocuments');
      final result = await callable.call();

      final List<dynamic> documentsData = result.data['documents'] ?? [];
      final List<DocumentModel> documents = documentsData
          .map((data) => DocumentModel.fromMap(data as Map<String, dynamic>))
          .toList();

      debugPrint('✅ Fetched ${documents.length} pending documents');
      return documents;
    } catch (e) {
      debugPrint('❌ Error fetching pending documents: $e');
      return [];
    }
  }

  /// Get approval statistics
  Future<Map<String, dynamic>> getApprovalStatistics() async {
    try {
      debugPrint('🔄 Fetching approval statistics');

      final callable = _functions.httpsCallable('getApprovalStatistics');
      final result = await callable.call();

      debugPrint('✅ Fetched approval statistics');
      return result.data ?? {};
    } catch (e) {
      debugPrint('❌ Error fetching approval statistics: $e');
      return {
        'pendingCount': 0,
        'approvedCount': 0,
        'rejectedCount': 0,
        'totalCount': 0,
      };
    }
  }

  /// Send notification to user about file status
  Future<bool> sendNotificationToUser({
    required String userId,
    required String title,
    required String message,
    required NotificationType type,
    String? documentId,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      debugPrint('🔄 Sending notification to user: $userId');

      final callable = _functions.httpsCallable('sendNotification');
      final result = await callable.call({
        'userId': userId,
        'title': title,
        'message': message,
        'type': type.name,
        'documentId': documentId,
        'data': additionalData,
      });

      debugPrint('✅ Notification sent successfully');
      return result.data['success'] ?? false;
    } catch (e) {
      debugPrint('❌ Error sending notification: $e');
      return false;
    }
  }

  /// Get document approval history
  Future<List<Map<String, dynamic>>> getDocumentApprovalHistory(
    String documentId,
  ) async {
    try {
      debugPrint('🔄 Fetching approval history for document: $documentId');

      final callable = _functions.httpsCallable('getDocumentApprovalHistory');
      final result = await callable.call({'documentId': documentId});

      final List<dynamic> historyData = result.data['history'] ?? [];
      debugPrint('✅ Fetched ${historyData.length} approval history entries');

      return historyData.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('❌ Error fetching approval history: $e');
      return [];
    }
  }

  /// Check if document needs approval
  bool documentNeedsApproval(DocumentModel document) {
    // Check if document has approval fields
    final metadata = document.metadata.toMap();
    final hasApprovedBy = metadata.containsKey('approvedBy');
    final hasRejectedBy = metadata.containsKey('rejectedBy');

    // Document needs approval if it hasn't been approved or rejected
    return !hasApprovedBy && !hasRejectedBy;
  }

  /// Get document approval status
  String getDocumentApprovalStatus(DocumentModel document) {
    final metadata = document.metadata.toMap();

    if (metadata.containsKey('approvedBy') && metadata['approvedBy'] != null) {
      return 'approved';
    } else if (metadata.containsKey('rejectedBy') &&
        metadata['rejectedBy'] != null) {
      return 'rejected';
    } else {
      return 'pending';
    }
  }

  /// Get approval status display text
  String getApprovalStatusDisplayText(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'pending':
        return 'Pending Approval';
      default:
        return 'Unknown';
    }
  }

  /// Get approval status color
  String getApprovalStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return '#10B981'; // Green
      case 'rejected':
        return '#EF4444'; // Red
      case 'pending':
        return '#F59E0B'; // Orange
      default:
        return '#6B7280'; // Gray
    }
  }

  /// Helper method to extract error message from exception
  String _getErrorMessage(dynamic error) {
    if (error is FirebaseFunctionsException) {
      switch (error.code) {
        case 'permission-denied':
          return 'You do not have permission to perform this action';
        case 'unauthenticated':
          return 'Please log in to continue';
        case 'invalid-argument':
          return 'Invalid request parameters';
        case 'not-found':
          return 'Document not found';
        case 'already-exists':
          return 'Operation already completed';
        default:
          return error.message ?? 'An error occurred';
      }
    }
    return error.toString();
  }

  /// Validate bulk operation parameters
  bool validateBulkOperation({
    required List<String> documentIds,
    required String operation,
  }) {
    if (documentIds.isEmpty) {
      debugPrint('❌ No documents selected for bulk operation');
      return false;
    }

    if (!['approve', 'reject', 'delete'].contains(operation)) {
      debugPrint('❌ Invalid bulk operation: $operation');
      return false;
    }

    if (documentIds.length > 50) {
      debugPrint('❌ Too many documents selected (max 50)');
      return false;
    }

    return true;
  }

  /// Get bulk operation confirmation message
  String getBulkOperationConfirmationMessage({
    required String operation,
    required int count,
  }) {
    switch (operation) {
      case 'approve':
        return 'Are you sure you want to approve $count document${count > 1 ? 's' : ''}?';
      case 'reject':
        return 'Are you sure you want to reject $count document${count > 1 ? 's' : ''}?';
      case 'delete':
        return 'Are you sure you want to delete $count document${count > 1 ? 's' : ''}? This action cannot be undone.';
      default:
        return 'Are you sure you want to perform this operation on $count document${count > 1 ? 's' : ''}?';
    }
  }
}
