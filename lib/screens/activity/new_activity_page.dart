import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../services/activity_service.dart';
import '../../models/activity_model.dart';
import '../../widgets/activity/quick_access_widget.dart';
import '../../widgets/activity/storage_chart_widget.dart';
import '../../widgets/activity/search_filter_widget.dart';
import '../../widgets/activity/activity_list_header.dart';
import '../../widgets/common/app_container.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/empty_state_widget.dart';

class NewActivityPage extends StatefulWidget {
  const NewActivityPage({super.key});

  @override
  State<NewActivityPage> createState() => _NewActivityPageState();
}

class _NewActivityPageState extends State<NewActivityPage> {
  final ActivityService _activityService = ActivityService();
  final ScrollController _scrollController = ScrollController();

  // State variables
  List<ActivityModel> _activities = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  String? _error;

  // Filter state
  String _selectedFilter = 'all';
  String _searchQuery = '';
  DateTimeRange? _dateRange;
  bool _isFilterExpanded = false;

  // Pagination
  String? _lastTimestamp;
  static const int _pageSize = 50;

  // Debouncing timers
  Timer? _searchDebounceTimer;
  Timer? _filterDebounceTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchDebounceTimer?.cancel();
    _filterDebounceTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreActivities();
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load initial activities - statistics are handled by QuickAccessWidget
      await _loadActivities(reset: true);
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      debugPrint('Error loading initial data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadActivities({bool reset = false}) async {
    // Store current activities to prevent flickering
    List<ActivityModel> previousActivities = List.from(_activities);

    if (reset) {
      _lastTimestamp = null;
      _hasMoreData = true;
      // Don't clear activities immediately to prevent flickering
    }

    if (!_hasMoreData) return;

    try {
      final result = await _activityService.getFilteredActivities(
        filter: _selectedFilter,
        searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
        dateRange: _dateRange,
        limit: _pageSize,
        startAfterTimestamp: _lastTimestamp,
      );

      // Safe handling of activities list
      final activitiesData = result['activities'];
      List<ActivityModel> newActivities = [];

      if (activitiesData is List) {
        newActivities = activitiesData
            .map((data) {
              try {
                if (data is Map) {
                  return _createActivityFromData(
                    Map<String, dynamic>.from(data),
                  );
                }
                return null;
              } catch (e) {
                debugPrint('Error parsing activity data: $e');
                return null;
              }
            })
            .where((activity) => activity != null)
            .cast<ActivityModel>()
            .toList();
      }

      // Only update UI once with final data
      if (mounted) {
        setState(() {
          if (reset) {
            _activities = newActivities;
          } else {
            _activities.addAll(newActivities);
          }
          _hasMoreData = result['hasMore'] ?? false;
          _lastTimestamp = result['lastTimestamp'];
        });
      }
    } catch (e) {
      debugPrint('Error loading activities: $e');
      // Restore previous activities on error to prevent empty state
      if (mounted && reset) {
        setState(() {
          _activities = previousActivities;
        });
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to load activities. Please try again.'),
            backgroundColor: AppColors.error,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _loadActivities(reset: true),
            ),
          ),
        );
      }
      // Don't rethrow to prevent app crash
    }
  }

  Future<void> _loadMoreActivities() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      await _loadActivities();
    } catch (e) {
      debugPrint('Error loading more activities: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to load more activities.'),
            backgroundColor: AppColors.warning,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadInitialData();
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });

    // Debounce filter changes to prevent excessive API calls
    _filterDebounceTimer?.cancel();
    _filterDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      _loadActivities(reset: true);
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });

    // Debounce search changes to prevent excessive API calls
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      _loadActivities(reset: true);
    });
  }

  void _onDateRangeChanged(DateTimeRange? range) {
    setState(() {
      _dateRange = range;
    });

    // Date range changes are immediate as they're user-initiated actions
    _loadActivities(reset: true);
  }

  void _onToggleFilterExpanded() {
    setState(() {
      _isFilterExpanded = !_isFilterExpanded;
    });
  }

  void _onStatTap(String statKey) {
    // Handle quick access stat tap without triggering loading states
    switch (statKey) {
      case 'today':
        _applyDateRangeFilter(_getTodayRange());
        break;
      case 'week':
        _applyDateRangeFilter(_getThisWeekRange());
        break;
      case 'suspicious':
        _applyActivityFilter('suspicious');
        break;
      default:
        break;
    }
  }

  // Apply date range filter without loading state
  void _applyDateRangeFilter(DateTimeRange? range) {
    setState(() {
      _dateRange = range;
    });
    _loadActivitiesQuietly(reset: true);
  }

  // Apply activity filter without loading state
  void _applyActivityFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _loadActivitiesQuietly(reset: true);
  }

  // Load activities without showing loading indicators to prevent flickering
  Future<void> _loadActivitiesQuietly({bool reset = false}) async {
    // Store current activities to prevent flickering during quick access
    List<ActivityModel> previousActivities = List.from(_activities);

    if (reset) {
      _lastTimestamp = null;
      _hasMoreData = true;
      // Don't clear activities immediately to prevent flickering
    }

    if (!_hasMoreData) return;

    try {
      final result = await _activityService.getFilteredActivities(
        filter: _selectedFilter,
        searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
        dateRange: _dateRange,
        limit: _pageSize,
        startAfterTimestamp: _lastTimestamp,
      );

      // Safe handling of activities list
      final activitiesData = result['activities'];
      List<ActivityModel> newActivities = [];

      if (activitiesData is List) {
        newActivities = activitiesData
            .map((data) {
              try {
                if (data is Map) {
                  return _createActivityFromData(
                    Map<String, dynamic>.from(data),
                  );
                }
                return null;
              } catch (e) {
                debugPrint('Error parsing activity data: $e');
                return null;
              }
            })
            .where((activity) => activity != null)
            .cast<ActivityModel>()
            .toList();
      }

      // Only update UI once with final data to prevent flickering
      if (mounted) {
        setState(() {
          if (reset) {
            _activities = newActivities;
          } else {
            _activities.addAll(newActivities);
          }
          _hasMoreData = result['hasMore'] ?? false;
          _lastTimestamp = result['lastTimestamp'];
        });
      }
    } catch (e) {
      debugPrint('Error loading activities quietly: $e');
      // Restore previous activities on error to prevent empty state
      if (mounted && reset) {
        setState(() {
          _activities = previousActivities;
        });
      }
      // Don't show error messages for quiet loading to prevent UI disruption
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
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

            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: _buildAppBar(),
              body: _buildBody(),
            );
          },
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      title: Text(
        'Activity Monitor',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _isLoading ? null : _refreshData,
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading && _activities.isEmpty) {
      return const LoadingWidget(message: 'Loading activities...');
    }

    if (_error != null) {
      return _buildErrorState();
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Access Statistics - Optimized to prevent unnecessary rebuilds
            QuickAccessWidget(
              key: const ValueKey('quick_access'),
              onRefresh: _refreshData,
              onStatTap: _onStatTap,
            ),
            const SizedBox(height: 16),

            // Storage Chart - Cached to prevent rebuilds
            StorageChartWidget(
              key: const ValueKey('storage_chart'),
              showHeader: true,
              showPeriodSelector: true,
              showStorageStats: true,
            ),
            const SizedBox(height: 16),

            // Search and Filter - Optimized with debouncing
            SearchFilterWidget(
              key: const ValueKey('search_filter'),
              selectedFilter: _selectedFilter,
              searchQuery: _searchQuery,
              dateRange: _dateRange,
              onFilterChanged: _onFilterChanged,
              onSearchChanged: _onSearchChanged,
              onDateRangeChanged: _onDateRangeChanged,
              isExpanded: _isFilterExpanded,
              onToggleExpanded: _onToggleFilterExpanded,
            ),
            const SizedBox(height: 16),

            // Activity List Header - Optimized loading states
            ActivityListHeader(
              key: const ValueKey('activity_header'),
              activityCount: _activities.length,
              onRefresh: _refreshData,
              activities: _activities,
              isLoading: _isLoading,
              showExportButton: true,
              showRefreshButton: true,
            ),
            const SizedBox(height: 8),

            // Activity List - Optimized rendering
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildActivityList(),
            ),

            // Load More Indicator - Smooth animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: _isLoadingMore ? 60 : 0,
              child: _isLoadingMore
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityList() {
    if (_activities.isEmpty) {
      return AppContainer.card(
        child: EmptyStateWidget(
          icon: Icons.history,
          title: 'No Activities Found',
          subtitle:
              _searchQuery.isNotEmpty ||
                  _dateRange != null ||
                  _selectedFilter != 'all'
              ? 'Try adjusting your filters'
              : 'No activities have been recorded yet',
        ),
      );
    }

    return AppContainer.card(
      padding: EdgeInsets.zero,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _activities.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final activity = _activities[index];
          return _buildActivityTile(activity);
        },
      ),
    );
  }

  Widget _buildActivityTile(ActivityModel activity) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getActivityColor(
          activity.type,
        ).withValues(alpha: 0.1),
        child: Icon(
          _getActivityIcon(activity.type),
          color: _getActivityColor(activity.type),
          size: 20,
        ),
      ),
      title: Text(
        activity.description,
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            activity.userName ?? activity.userEmail ?? 'Unknown User',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            _formatDateTime(activity.timestamp),
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      trailing: activity.isSuspicious
          ? Icon(Icons.warning, color: AppColors.warning, size: 20)
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: AppContainer.card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Error Loading Activities',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? 'An unknown error occurred',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _refreshData, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessDenied() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Access Denied'),
      ),
      body: Center(
        child: AppContainer.card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock, size: 48, color: AppColors.warning),
              const SizedBox(height: 16),
              Text(
                'Access Denied',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You need administrator privileges to access this page.',
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

  // Helper methods
  IconData _getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'login':
      case 'logout':
        return Icons.login;
      case 'upload':
        return Icons.upload;
      case 'download':
        return Icons.download;
      case 'delete':
        return Icons.delete;
      case 'view':
        return Icons.visibility;
      case 'suspicious_activity':
        return Icons.warning;
      default:
        return Icons.history;
    }
  }

  Color _getActivityColor(String type) {
    switch (type.toLowerCase()) {
      case 'login':
      case 'logout':
        return AppColors.primary;
      case 'upload':
        return AppColors.success;
      case 'download':
        return AppColors.info;
      case 'delete':
        return AppColors.error;
      case 'view':
        return AppColors.textSecondary;
      case 'suspicious_activity':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  DateTimeRange _getTodayRange() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return DateTimeRange(
      start: today,
      end: today
          .add(const Duration(days: 1))
          .subtract(const Duration(microseconds: 1)),
    );
  }

  DateTimeRange _getThisWeekRange() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDay = DateTime(
      weekStart.year,
      weekStart.month,
      weekStart.day,
    );
    return DateTimeRange(start: weekStartDay, end: now);
  }

  ActivityModel _createActivityFromData(Map<String, dynamic> data) {
    return ActivityModel(
      id: data['id'] ?? '',
      userId: data['userId'] ?? '',
      type: data['type'] ?? '',
      description: data['description'] ?? '',
      timestamp: DateTime.tryParse(data['timestamp'] ?? '') ?? DateTime.now(),
      userName: data['userName'],
      userEmail: data['userEmail'],
      documentId: data['documentId'],
      categoryId: data['categoryId'],
      isSuspicious: data['isSuspicious'] ?? false,
      ipAddress: data['ipAddress'],
      userAgent: data['userAgent'],
      details: _parseDetailsField(data['details']),
    );
  }

  /// Helper method to safely parse details field
  Map<String, dynamic> _parseDetailsField(dynamic details) {
    if (details == null) {
      return {};
    }

    if (details is Map<String, dynamic>) {
      return details;
    }

    if (details is Map) {
      return Map<String, dynamic>.from(details);
    }

    if (details is String) {
      // Handle string details by creating a simple map
      return {'description': details};
    }

    // For any other type, convert to string and wrap in map
    return {'value': details.toString()};
  }
}
