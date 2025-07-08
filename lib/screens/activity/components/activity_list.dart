import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/activity_model.dart';
import '../../../services/activity_service.dart';
import '../../../services/export_service.dart';

class ActivityList extends StatefulWidget {
  final List<ActivityModel> activities;
  final VoidCallback onRefresh;

  const ActivityList({
    super.key,
    required this.activities,
    required this.onRefresh,
  });

  @override
  State<ActivityList> createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  final ActivityService _activityService = ActivityService();
  final ExportService _exportService = ExportService();
  final ScrollController _scrollController = ScrollController();
  
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  static const int _itemsPerPage = 20;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMoreActivities();
    }
  }

  Future<void> _loadMoreActivities() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() => _isLoadingMore = true);

    try {
      // This would typically load more activities from the service
      // For now, we'll simulate pagination
      await Future.delayed(const Duration(seconds: 1));
      
      // In a real implementation, you would:
      // final moreActivities = await _activityService.getActivities(
      //   limit: _itemsPerPage,
      //   startAfter: widget.activities.last.documentSnapshot,
      // );
      
      setState(() {
        _currentPage++;
        _isLoadingMore = false;
        // _hasMoreData = moreActivities.length == _itemsPerPage;
      });
    } catch (e) {
      setState(() => _isLoadingMore = false);
      debugPrint('Error loading more activities: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => widget.onRefresh(),
            child: widget.activities.isEmpty
                ? _buildEmptyState()
                : _buildActivityList(),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${widget.activities.length} Activities',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _exportToExcel,
                icon: const Icon(Icons.file_download),
                tooltip: 'Export to Excel',
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  foregroundColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: widget.onRefresh,
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  foregroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: widget.activities.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == widget.activities.length) {
          return _buildLoadingIndicator();
        }
        
        final activity = widget.activities[index];
        return _buildActivityTile(activity, index);
      },
    );
  }

  Widget _buildActivityTile(ActivityModel activity, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: activity.isSuspicious
            ? Border.all(color: AppColors.error.withOpacity(0.3), width: 2)
            : Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: _buildActivityIcon(activity),
        title: Text(
          activity.description,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.person,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  activity.userName ?? 'Unknown User',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (activity.userEmail != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    '(${activity.userEmail})',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary.withOpacity(0.7),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatTimestamp(activity.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (activity.isSuspicious) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'SUSPICIOUS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: _buildActivityMenu(activity),
      ),
    );
  }

  Widget _buildActivityIcon(ActivityModel activity) {
    IconData icon;
    Color color;

    switch (activity.type) {
      case 'login':
        icon = Icons.login;
        color = AppColors.success;
        break;
      case 'logout':
        icon = Icons.logout;
        color = AppColors.warning;
        break;
      case 'upload':
        icon = Icons.upload;
        color = AppColors.primary;
        break;
      case 'download':
        icon = Icons.download;
        color = AppColors.info;
        break;
      case 'delete':
        icon = Icons.delete;
        color = AppColors.error;
        break;
      case 'view':
        icon = Icons.visibility;
        color = AppColors.textSecondary;
        break;
      case 'account_lock':
        icon = Icons.lock;
        color = AppColors.error;
        break;
      case 'account_unlock':
        icon = Icons.lock_open;
        color = AppColors.success;
        break;
      case 'suspicious_activity':
        icon = Icons.warning;
        color = AppColors.error;
        break;
      default:
        icon = Icons.info;
        color = AppColors.textSecondary;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }

  Widget _buildActivityMenu(ActivityModel activity) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
      onSelected: (value) => _handleMenuAction(value, activity),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'details',
          child: Row(
            children: [
              Icon(Icons.info, size: 16),
              SizedBox(width: 8),
              Text('View Details'),
            ],
          ),
        ),
        if (activity.userId.isNotEmpty) ...[
          const PopupMenuItem(
            value: 'user_activities',
            child: Row(
              children: [
                Icon(Icons.person, size: 16),
                SizedBox(width: 8),
                Text('User Activities'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'lock_user',
            child: Row(
              children: [
                Icon(Icons.lock, size: 16, color: AppColors.error),
                SizedBox(width: 8),
                Text('Lock User Account', style: TextStyle(color: AppColors.error)),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Activities Found',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search criteria',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _handleMenuAction(String action, ActivityModel activity) {
    switch (action) {
      case 'details':
        _showActivityDetails(activity);
        break;
      case 'user_activities':
        _showUserActivities(activity.userId);
        break;
      case 'lock_user':
        _showLockUserDialog(activity.userId, activity.userName ?? 'Unknown User');
        break;
    }
  }

  void _showActivityDetails(ActivityModel activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Activity Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Type', activity.type),
            _buildDetailRow('Description', activity.description),
            _buildDetailRow('User', activity.userName ?? 'Unknown'),
            _buildDetailRow('Email', activity.userEmail ?? 'N/A'),
            _buildDetailRow('Time', _formatTimestamp(activity.timestamp)),
            _buildDetailRow('Suspicious', activity.isSuspicious ? 'Yes' : 'No'),
            if (activity.documentId != null)
              _buildDetailRow('Document ID', activity.documentId!),
            if (activity.categoryId != null)
              _buildDetailRow('Category ID', activity.categoryId!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showUserActivities(String userId) {
    // Navigate to user activities page or show dialog
    // This would be implemented based on your navigation structure
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User activities feature coming soon')),
    );
  }

  void _showLockUserDialog(String userId, String userName) {
    final reasonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Lock User Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are you sure you want to lock the account for $userName?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for locking',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please provide a reason')),
                );
                return;
              }
              
              Navigator.pop(context);
              
              final success = await _activityService.lockUserAccount(
                userId,
                reasonController.text.trim(),
              );
              
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User account locked successfully')),
                );
                widget.onRefresh();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to lock user account')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Lock Account'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportToExcel() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exporting activities to Excel...')),
      );
      
      await _exportService.exportActivitiesToExcel(widget.activities);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activities exported successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}
