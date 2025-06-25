import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/document_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/file_selection_provider.dart';
import '../../models/document_model.dart';
import '../../core/services/approval_service.dart';

import '../../widgets/common/app_bottom_navigation.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/reusable_file_list_widget.dart';
import '../../widgets/admin/enhanced_bulk_operations.dart';
import '../../widgets/common/advanced_search_filter.dart';
import '../../widgets/notification/notification_badge.dart';
import '../../core/utils/document_filter_utils.dart';

class FileApprovalScreen extends StatefulWidget {
  const FileApprovalScreen({super.key});

  @override
  State<FileApprovalScreen> createState() => _FileApprovalScreenState();
}

class _FileApprovalScreenState extends State<FileApprovalScreen> {
  final ApprovalService _approvalService = ApprovalService();

  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _isAutoSyncing = false;
  bool _isBulkProcessing = false;
  String _bulkOperationStatus = '';
  List<DocumentModel> _filteredDocuments = [];
  Map<String, dynamic> _approvalStats = {};
  late SearchFilterState _filterState;

  @override
  void initState() {
    super.initState();
    _filterState = DocumentFilterUtils.createDefaultFilterState(
      initialFilter: 'pending',
    );
    _loadApprovalData();
    _setupNotificationListener();
  }

  @override
  void dispose() {
    // Remove notification listener
    try {
      final notificationProvider = Provider.of<NotificationProvider>(
        context,
        listen: false,
      );
      notificationProvider.removeListener(_onNotificationUpdate);
    } catch (e) {
      // Ignore errors during disposal
    }
    super.dispose();
  }

  void _setupNotificationListener() {
    // Listen to notification provider changes for real-time updates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notificationProvider = Provider.of<NotificationProvider>(
        context,
        listen: false,
      );

      // Add listener to refresh data when new notifications arrive
      notificationProvider.addListener(_onNotificationUpdate);
    });
  }

  void _onNotificationUpdate() {
    // Auto-sync: Refresh approval data when notifications are updated
    // This ensures the list stays current with real-time changes
    if (mounted) {
      _performAutoSync();
    }
  }

  Future<void> _loadApprovalData() async {
    setState(() => _isLoading = true);

    try {
      // Check network connectivity first
      if (!await _checkNetworkConnectivity()) {
        throw Exception('No internet connection');
      }

      // Auto-sync: Load approval statistics
      _approvalStats = await _approvalService.getApprovalStatistics();

      // Auto-sync: Load documents and apply filters
      await _refreshDocuments();
    } catch (e) {
      debugPrint('Error loading approval data: $e');
      if (mounted) {
        _handleLoadingError(e);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<bool> _checkNetworkConnectivity() async {
    try {
      // Simple connectivity check - you might want to use connectivity_plus package
      return true; // For now, assume connected
    } catch (e) {
      return false;
    }
  }

  void _handleLoadingError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('network') || errorString.contains('connection')) {
      _showErrorMessage(
        'Network error. Please check your internet connection and try again.',
      );
    } else if (errorString.contains('permission') ||
        errorString.contains('unauthorized')) {
      _showErrorMessage('Access denied. Please check your permissions.');
    } else if (errorString.contains('timeout')) {
      _showErrorMessage('Request timed out. Please try again.');
    } else {
      _showErrorMessage('Failed to load approval data. Please try again.');
    }
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);

    try {
      // Show loading state during pull-to-refresh
      await _loadApprovalData();
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  Future<void> _performAutoSync() async {
    setState(() => _isAutoSyncing = true);

    try {
      // Perform background auto-sync without blocking UI
      await _refreshDocuments();
    } catch (e) {
      debugPrint('Auto-sync failed: $e');
    } finally {
      if (mounted) {
        setState(() => _isAutoSyncing = false);
      }
    }
  }

  Future<void> _refreshDocuments() async {
    try {
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );

      await documentProvider.loadAllDocumentsUnlimited();

      if (mounted) {
        _applyFilters();
      }
    } catch (e) {
      debugPrint('Error refreshing documents: $e');
      if (mounted) {
        _handleDocumentRefreshError(e);
      }
    }
  }

  void _handleDocumentRefreshError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('provider not available')) {
      _showErrorMessage('System error. Please restart the app.');
    } else if (errorString.contains('network') ||
        errorString.contains('connection')) {
      _showErrorMessage('Network error. Documents may not be up to date.');
    } else {
      _showErrorMessage(
        'Failed to refresh documents. Some data may be outdated.',
      );
    }
  }

  Future<Map<String, dynamic>> _performBulkOperationWithRetry(
    Future<Map<String, dynamic>> Function() operation,
    String operationType, {
    int maxRetries = 2,
  }) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        debugPrint('Bulk $operationType attempt $attempts failed: $e');

        if (attempts >= maxRetries) {
          rethrow;
        }

        // Wait before retry
        await Future.delayed(Duration(seconds: attempts));
      }
    }

    throw Exception('Max retries exceeded for bulk $operationType');
  }

  void _handleBulkOperationError(dynamic error, String operationType) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('network') || errorString.contains('connection')) {
      _showErrorMessage(
        'Network error during bulk $operationType. Please check your connection and try again.',
      );
    } else if (errorString.contains('permission') ||
        errorString.contains('unauthorized')) {
      _showErrorMessage(
        'Permission denied for bulk $operationType. Please check your admin privileges.',
      );
    } else if (errorString.contains('timeout')) {
      _showErrorMessage(
        'Bulk $operationType timed out. Please try with fewer documents.',
      );
    } else if (errorString.contains('max retries')) {
      _showErrorMessage(
        'Bulk $operationType failed after multiple attempts. Please try again later.',
      );
    } else {
      _showErrorMessage('Bulk $operationType failed. Please try again.');
    }
  }

  void _applyFilters() {
    try {
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );
      final allDocuments = documentProvider.documents;

      // Handle edge case: empty document list
      if (allDocuments.isEmpty) {
        setState(() {
          _filteredDocuments = [];
        });
        return;
      }

      final filtered = DocumentFilterUtils.applyFilters(
        allDocuments,
        _filterState,
      );

      if (mounted) {
        setState(() {
          _filteredDocuments = filtered;
        });
      }
    } catch (e) {
      debugPrint('Error applying filters: $e');
      if (mounted) {
        // Fallback: show all documents if filtering fails
        final documentProvider = Provider.of<DocumentProvider>(
          context,
          listen: false,
        );
        setState(() {
          _filteredDocuments = documentProvider.documents;
        });
        _showErrorMessage('Filter error. Showing all documents.');
      }
    }
  }

  void _onFilterStateChanged(SearchFilterState newState) {
    setState(() {
      _filterState = newState;
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<AuthProvider, DocumentProvider, FileSelectionProvider>(
      builder:
          (context, authProvider, documentProvider, selectionProvider, child) {
            return FutureBuilder<bool>(
              future: authProvider.isCurrentUserAdmin,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                if (!snapshot.hasData || !snapshot.data!) {
                  return _buildAccessDenied();
                }

                return AppScaffoldWithNavigation(
                  title: 'File Approval',
                  currentNavIndex: -1,
                  showAppBar: true,
                  actions: [
                    // Notification icon with badge using reusable component
                    NotificationIcon(
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.notificationCenter,
                      ),
                      showBadge: true,
                    ),
                  ],
                  body: Stack(
                    children: [
                      RefreshIndicator(
                        onRefresh: _handleRefresh,
                        child: Column(
                          children: [
                            // Statistics Card
                            if (_approvalStats.isNotEmpty)
                              _buildStatisticsCard(),

                            // Search and Filter
                            _buildSearchAndFilter(),

                            // Enhanced Bulk Operations
                            EnhancedBulkOperations(
                              onApprove: (documents, reason) =>
                                  _handleBulkApproval(documents),
                              onReject: (documents, reason) =>
                                  _handleBulkRejection(documents, reason),
                              onDelete: (documents) =>
                                  _handleBulkDeletion(documents),
                              showApprovalActions: true,
                              showFileActions: false,
                            ),

                            // Document List
                            Expanded(
                              child: _buildDocumentList(selectionProvider),
                            ),
                          ],
                        ),
                      ),

                      // Bulk operation progress overlay
                      if (_isBulkProcessing) _buildBulkProgressOverlay(),
                    ],
                  ),
                );
              },
            );
          },
    );
  }

  Widget _buildDocumentList(FileSelectionProvider selectionProvider) {
    if (_isLoading) {
      return Center(
        child: LoadingWidget(
          message: _isRefreshing
              ? 'Refreshing approval data...'
              : 'Loading approval data...',
          showMessage: true,
        ),
      );
    }

    // Show subtle loading indicator for auto-sync
    if (_isAutoSyncing) {
      return Stack(
        children: [
          _buildDocumentListContent(selectionProvider),
          Positioned(
            top: 8,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Syncing...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return _buildDocumentListContent(selectionProvider);
  }

  Widget _buildDocumentListContent(FileSelectionProvider selectionProvider) {
    if (_filteredDocuments.isEmpty) {
      return _buildEmptyState();
    }

    return ReusableFileListWidget(
      documents: _filteredDocuments,
      title: '',
      showFilter: false,
      showPagination: true,
      itemsPerPage: 25,
      emptyStateMessage: 'No documents found',
      emptyStateIcon: Icons.folder_open,
      onDocumentTap: _handleViewDetails,
      onDocumentMenu: (document) =>
          _showDocumentMenu(document, selectionProvider),
    );
  }

  Widget _buildEmptyState() {
    String message;
    String subtitle;
    IconData icon;

    switch (_filterState.selectedFilter) {
      case 'pending':
        message = 'No pending approvals';
        subtitle = 'All files have been reviewed';
        icon = Icons.check_circle_outline;
        break;
      case 'approved':
        message = 'No approved files';
        subtitle = 'Approved files will appear here';
        icon = Icons.verified_outlined;
        break;
      case 'rejected':
        message = 'No rejected files';
        subtitle = 'Rejected files will appear here';
        icon = Icons.cancel_outlined;
        break;
      default:
        message = 'No files found';
        subtitle = 'Files will appear here when uploaded';
        icon = Icons.folder_outlined;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAccessDenied() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Access Denied'),
        backgroundColor: AppColors.surface,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Access Denied',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You need admin privileges to access this page',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  // Action handlers
  Future<void> _handleSingleApproval(DocumentModel document) async {
    try {
      final result = await _approvalService.approveDocument(
        documentId: document.id,
      );

      if (!mounted) return;

      if (result['success']) {
        _showSuccessMessage('Document approved successfully');
        await _refreshDocuments();

        if (!mounted) return;

        // Send notification to user
        final notificationProvider = Provider.of<NotificationProvider>(
          context,
          listen: false,
        );
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        await notificationProvider.sendFileApprovalNotification(
          userId: document.uploadedBy,
          fileName: document.fileName,
          documentId: document.id,
          approvedBy: authProvider.currentUser?.id ?? '',
        );
      } else {
        _showErrorMessage(result['message'] ?? 'Failed to approve document');
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage('Error approving document: ${e.toString()}');
      }
    }
  }

  Future<void> _handleSingleRejection(DocumentModel document) async {
    try {
      final reason = await _showRejectionDialog();
      if (reason == null || !mounted) return;

      final result = await _approvalService.rejectDocument(
        documentId: document.id,
        reason: reason,
      );

      if (!mounted) return;

      if (result['success']) {
        _showSuccessMessage('Document rejected successfully');
        await _refreshDocuments();

        if (!mounted) return;

        // Send notification to user
        final notificationProvider = Provider.of<NotificationProvider>(
          context,
          listen: false,
        );
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        await notificationProvider.sendFileRejectionNotification(
          userId: document.uploadedBy,
          fileName: document.fileName,
          documentId: document.id,
          reason: reason,
          rejectedBy: authProvider.currentUser?.id ?? '',
        );
      } else {
        _showErrorMessage(result['message'] ?? 'Failed to reject document');
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage('Error rejecting document: ${e.toString()}');
      }
    }
  }

  Future<void> _handleBulkApproval(List<DocumentModel> documents) async {
    // Edge case: Check if documents list is empty
    if (documents.isEmpty) {
      _showErrorMessage('No documents selected for approval.');
      return;
    }

    // Edge case: Check if documents are already processed
    final validDocuments = documents
        .where((doc) => !doc.metadata.isApproved && !doc.metadata.isRejected)
        .toList();

    if (validDocuments.isEmpty) {
      _showErrorMessage('Selected documents have already been processed.');
      return;
    }

    if (validDocuments.length != documents.length) {
      final skipped = documents.length - validDocuments.length;
      _showErrorMessage(
        '$skipped documents were skipped as they are already processed.',
      );
    }

    final confirmed = await _showBulkConfirmationDialog(
      'approve',
      validDocuments.length,
    );
    if (!confirmed) return;

    // Show progress indicator
    setState(() {
      _isBulkProcessing = true;
      _bulkOperationStatus = 'Approving ${validDocuments.length} documents...';
    });

    try {
      final result = await _performBulkOperationWithRetry(
        () => _approvalService.bulkDocumentOperation(
          documentIds: validDocuments.map((doc) => doc.id).toList(),
          operation: 'approve',
        ),
        'approve',
      );

      if (!mounted) return;

      if (result['success']) {
        _showSuccessMessage(
          '${validDocuments.length} documents approved successfully',
        );

        // Clear selection
        Provider.of<FileSelectionProvider>(
          context,
          listen: false,
        ).clearSelection();

        // Refresh data
        await _refreshDocuments();
      } else {
        _showErrorMessage(result['message'] ?? 'Failed to approve documents');
      }
    } catch (e) {
      if (mounted) {
        _handleBulkOperationError(e, 'approval');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isBulkProcessing = false;
          _bulkOperationStatus = '';
        });
      }
    }
  }

  Future<void> _handleBulkRejection(
    List<DocumentModel> documents,
    String? reason,
  ) async {
    if (reason == null || reason.isEmpty) {
      reason = await _showRejectionDialog();
      if (reason == null || !mounted) return;
    }

    final confirmed = await _showBulkConfirmationDialog(
      'reject',
      documents.length,
    );
    if (!confirmed) return;

    // Show progress indicator
    setState(() {
      _isBulkProcessing = true;
      _bulkOperationStatus = 'Rejecting ${documents.length} documents...';
    });

    try {
      final result = await _approvalService.bulkDocumentOperation(
        documentIds: documents.map((doc) => doc.id).toList(),
        operation: 'reject',
        reason: reason,
      );

      if (!mounted) return;

      if (result['success']) {
        _showSuccessMessage(
          '${documents.length} documents rejected successfully',
        );

        // Clear selection
        Provider.of<FileSelectionProvider>(
          context,
          listen: false,
        ).clearSelection();

        // Refresh data
        await _refreshDocuments();
      } else {
        _showErrorMessage(result['message'] ?? 'Failed to reject documents');
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage('Error during bulk rejection: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isBulkProcessing = false;
          _bulkOperationStatus = '';
        });
      }
    }
  }

  Future<void> _handleBulkDeletion(List<DocumentModel> documents) async {
    final confirmed = await _showBulkConfirmationDialog(
      'delete',
      documents.length,
    );
    if (!confirmed) return;

    // Show progress indicator
    setState(() {
      _isBulkProcessing = true;
      _bulkOperationStatus = 'Deleting ${documents.length} documents...';
    });

    try {
      final result = await _approvalService.bulkDocumentOperation(
        documentIds: documents.map((doc) => doc.id).toList(),
        operation: 'delete',
      );

      if (!mounted) return;

      if (result['success']) {
        _showSuccessMessage(
          '${documents.length} documents deleted successfully',
        );

        // Clear selection
        Provider.of<FileSelectionProvider>(
          context,
          listen: false,
        ).clearSelection();

        // Refresh data
        await _refreshDocuments();
      } else {
        _showErrorMessage(result['message'] ?? 'Failed to delete documents');
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage('Error during bulk deletion: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isBulkProcessing = false;
          _bulkOperationStatus = '';
        });
      }
    }
  }

  void _handleViewDetails(DocumentModel document) {
    Navigator.pushNamed(
      context,
      AppRoutes.documentDetails,
      arguments: {'document': document},
    );
  }

  // Dialog helpers
  Future<String?> _showRejectionDialog() async {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Rejection Reason',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter reason for rejection...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: AppColors.surface,
          ),
          maxLines: 3,
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  Future<bool> _showBulkConfirmationDialog(String operation, int count) async {
    final message = _approvalService.getBulkOperationConfirmationMessage(
      operation: operation,
      count: count,
    );

    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Confirm ${operation.toUpperCase()}',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            content: Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: operation == 'delete'
                      ? AppColors.error
                      : AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(operation.toUpperCase()),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // Missing widget builders
  Widget _buildStatisticsCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Approval Statistics',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Statistics row
          Row(
            children: [
              _buildStatItem(
                'Pending',
                _approvalStats['pendingCount']?.toString() ?? '0',
                AppColors.warning,
              ),
              const SizedBox(width: 16),
              _buildStatItem(
                'Approved',
                _approvalStats['approvedCount']?.toString() ?? '0',
                AppColors.success,
              ),
              const SizedBox(width: 16),
              _buildStatItem(
                'Rejected',
                _approvalStats['rejectedCount']?.toString() ?? '0',
                AppColors.error,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return AdvancedSearchFilter(
      initialState: _filterState,
      filterOptions: const ['all', 'pending', 'approved', 'rejected'],
      availableFileTypes: const [
        'pdf',
        'doc',
        'docx',
        'xlsx',
        'csv',
        'ppt',
        'pptx',
        'txt',
        'jpg',
        'png',
      ],
      onStateChanged: _onFilterStateChanged,
      showAdvancedFilters: true,
      showSortOptions: true,
      showDateFilter: true,
      showFileTypeFilter: true,
      searchHint: 'Search by filename, uploader, or description...',
    );
  }

  Widget _buildBulkProgressOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Progress indicator
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: 20),

              // Status text
              Text(
                _bulkOperationStatus,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                'Please wait while we process your request...',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDocumentMenu(
    DocumentModel document,
    FileSelectionProvider selectionProvider,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.check_circle, color: AppColors.success),
              title: const Text('Approve'),
              onTap: () {
                Navigator.pop(context);
                _handleSingleApproval(document);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: AppColors.error),
              title: const Text('Reject'),
              onTap: () {
                Navigator.pop(context);
                _handleSingleRejection(document);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('View Details'),
              onTap: () {
                Navigator.pop(context);
                _handleViewDetails(document);
              },
            ),
          ],
        ),
      ),
    );
  }
}
