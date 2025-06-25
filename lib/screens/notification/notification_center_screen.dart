import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../providers/notification_provider.dart';
import '../../models/notification_model.dart';
import '../../widgets/common/app_scaffold_with_navigation.dart';
import '../../widgets/common/loading_widget.dart';

class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() =>
      _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  String _selectedFilter = 'all';
  final List<String> _filterOptions = ['all', 'unread', 'approval', 'system'];

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, child) {
        return AppScaffoldWithNavigation(
          title: 'Notifications',
          currentNavIndex: -1, // No specific nav index for this screen
          showAppBar: true,
          actions: [
            // Mark all as read button
            if (notificationProvider.hasUnreadNotifications)
              IconButton(
                icon: const Icon(Icons.mark_email_read),
                onPressed: () => _markAllAsRead(notificationProvider),
                tooltip: 'Mark all as read',
              ),
            // Clear all button
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) =>
                  _handleMenuAction(value, notificationProvider),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'mark_all_read',
                  child: Row(
                    children: [
                      Icon(Icons.mark_email_read, size: 20),
                      SizedBox(width: 8),
                      Text('Mark all as read'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'clear_all',
                  child: Row(
                    children: [
                      Icon(Icons.clear_all, size: 20),
                      SizedBox(width: 8),
                      Text('Clear all'),
                    ],
                  ),
                ),
              ],
            ),
          ],
          body: RefreshIndicator(
            onRefresh: () => notificationProvider.refresh(),
            child: Column(
              children: [
                // Filter tabs
                _buildFilterTabs(notificationProvider),

                // Notification list
                Expanded(child: _buildNotificationList(notificationProvider)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterTabs(NotificationProvider provider) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: _filterOptions.map((filter) {
          final isSelected = _selectedFilter == filter;
          final count = _getFilterCount(filter, provider);

          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getFilterLabel(filter),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (count > 0) ...[
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.2)
                              : AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          count.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationList(NotificationProvider provider) {
    if (provider.isLoading) {
      return const Center(child: LoadingWidget());
    }

    final filteredNotifications = _getFilteredNotifications(provider);

    if (filteredNotifications.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredNotifications.length,
      itemBuilder: (context, index) {
        final notification = filteredNotifications[index];
        return _buildNotificationItem(notification, provider);
      },
    );
  }

  Widget _buildNotificationItem(
    NotificationModel notification,
    NotificationProvider provider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification.isRead
            ? AppColors.surface
            : AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification.isRead
              ? AppColors.border.withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getNotificationTypeColor(
              notification.type,
            ).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              notification.displayIcon,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
        title: Text(
          notification.title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.message,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  notification.timeAgo,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (!notification.isRead) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, size: 20),
          onSelected: (value) =>
              _handleNotificationAction(value, notification, provider),
          itemBuilder: (context) => [
            if (!notification.isRead)
              const PopupMenuItem(
                value: 'mark_read',
                child: Row(
                  children: [
                    Icon(Icons.mark_email_read, size: 16),
                    SizedBox(width: 8),
                    Text('Mark as read'),
                  ],
                ),
              ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 16),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
        ),
        onTap: () => _handleNotificationTap(notification, provider),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _getEmptyStateMessage(),
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Notifications will appear here when you receive them',
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

  // Helper methods
  List<NotificationModel> _getFilteredNotifications(
    NotificationProvider provider,
  ) {
    switch (_selectedFilter) {
      case 'unread':
        return provider.unreadNotifications;
      case 'approval':
        return provider.notifications
            .where(
              (n) =>
                  n.type == NotificationType.fileApproved ||
                  n.type == NotificationType.fileRejected ||
                  n.type == NotificationType.fileUploaded,
            )
            .toList();
      case 'system':
        return provider.notifications
            .where((n) => n.type == NotificationType.systemNotification)
            .toList();
      default:
        return provider.notifications;
    }
  }

  int _getFilterCount(String filter, NotificationProvider provider) {
    switch (filter) {
      case 'unread':
        return provider.unreadCount;
      case 'approval':
        return provider.notifications
            .where(
              (n) =>
                  n.type == NotificationType.fileApproved ||
                  n.type == NotificationType.fileRejected ||
                  n.type == NotificationType.fileUploaded,
            )
            .length;
      case 'system':
        return provider.notifications
            .where((n) => n.type == NotificationType.systemNotification)
            .length;
      default:
        return provider.notifications.length;
    }
  }

  String _getFilterLabel(String filter) {
    switch (filter) {
      case 'unread':
        return 'Unread';
      case 'approval':
        return 'Approval';
      case 'system':
        return 'System';
      default:
        return 'All';
    }
  }

  String _getEmptyStateMessage() {
    switch (_selectedFilter) {
      case 'unread':
        return 'No unread notifications';
      case 'approval':
        return 'No approval notifications';
      case 'system':
        return 'No system notifications';
      default:
        return 'No notifications yet';
    }
  }

  Color _getNotificationTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.fileApproved:
        return Colors.green;
      case NotificationType.fileRejected:
        return Colors.red;
      case NotificationType.fileUploaded:
        return Colors.blue;
      case NotificationType.bulkApproval:
        return Colors.green;
      case NotificationType.bulkRejection:
        return Colors.red;
      case NotificationType.systemNotification:
        return Colors.orange;
    }
  }

  void _handleNotificationTap(
    NotificationModel notification,
    NotificationProvider provider,
  ) {
    // Mark as read if not already read
    if (!notification.isRead) {
      provider.markAsRead(notification.id);
    }

    // Navigate to relevant screen if actionUrl is provided
    if (notification.actionUrl != null) {
      Navigator.pushNamed(context, notification.actionUrl!);
    } else if (notification.documentId != null) {
      // Navigate to document details or file preview
      Navigator.pushNamed(
        context,
        AppRoutes.documentDetails,
        arguments: {'documentId': notification.documentId},
      );
    }
  }

  void _handleNotificationAction(
    String action,
    NotificationModel notification,
    NotificationProvider provider,
  ) {
    switch (action) {
      case 'mark_read':
        provider.markAsRead(notification.id);
        break;
      case 'delete':
        _showDeleteConfirmation(notification, provider);
        break;
    }
  }

  void _handleMenuAction(String action, NotificationProvider provider) {
    switch (action) {
      case 'mark_all_read':
        _markAllAsRead(provider);
        break;
      case 'clear_all':
        _showClearAllConfirmation(provider);
        break;
    }
  }

  void _markAllAsRead(NotificationProvider provider) {
    provider.markAllAsRead();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }

  void _showDeleteConfirmation(
    NotificationModel notification,
    NotificationProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Notification'),
        content: const Text(
          'Are you sure you want to delete this notification?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteNotification(notification.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showClearAllConfirmation(NotificationProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text(
          'Are you sure you want to clear all notifications? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.clearAllNotifications();
              Navigator.pop(context);
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
