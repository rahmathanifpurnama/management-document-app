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

  // Enhanced pagination system
  String? _lastTimestamp;
  static const int _pageSize = 25; // Reduced for better performance
  int _currentPage = 0;
  List<ActivityModel> _allActivities = []; // Store all loaded activities
  static const int _activitiesPerPage = 25;
  bool _showPaginationControls = false;

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
      _currentPage = 0; // Reset pagination
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
      _currentPage = 0; // Reset pagination
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
      _currentPage = 0; // Reset pagination
    });
    _loadActivitiesQuietly(reset: true);
  }

  // Apply activity filter without loading state
  void _applyActivityFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      _currentPage = 0; // Reset pagination
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
      return _buildEmptyState();
    }

    // Calculate pagination
    final totalPages = (_activities.length / _activitiesPerPage).ceil();
    final startIndex = _currentPage * _activitiesPerPage;
    final endIndex = (startIndex + _activitiesPerPage).clamp(
      0,
      _activities.length,
    );
    final currentPageActivities = _activities.sublist(startIndex, endIndex);

    return Column(
      children: [
        // Activity list with consistent styling
        _buildActivityListContainer(currentPageActivities),

        // Pagination controls
        if (totalPages > 1) ...[
          const SizedBox(height: 16),
          _buildPaginationControls(totalPages),
        ],

        // Load more section for infinite scroll
        if (_hasMoreData && _currentPage == totalPages - 1) ...[
          const SizedBox(height: 16),
          _buildLoadMoreSection(),
        ],
      ],
    );
  }

  Widget _buildEmptyState() {
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

  /// Build activity list container with consistent styling
  Widget _buildActivityListContainer(List<ActivityModel> activities) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: activities.asMap().entries.map((entry) {
          final index = entry.key;
          final activity = entry.value;
          final isLast = index == activities.length - 1;

          return TweenAnimationBuilder<double>(
            duration: Duration(
              milliseconds: (300 + (index * 100)).clamp(300, 1000),
            ),
            tween: Tween<double>(begin: 0.0, end: 1.0),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              final safeOpacity = value.clamp(0.0, 1.0);
              final safeTranslateValue = (1 - value).clamp(0.0, 1.0);

              return Transform.translate(
                offset: Offset(0, 20 * safeTranslateValue),
                child: Opacity(
                  opacity: safeOpacity,
                  child: _buildActivityTile(activity, isLast),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  /// Build individual activity tile with consistent styling
  Widget _buildActivityTile(ActivityModel activity, bool isLast) {
    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showActivityDetails(activity),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Enhanced icon with activity type badge
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: _getActivityColor(
                        activity.type,
                      ).withValues(alpha: 0.1),
                      child: Icon(
                        _getActivityIcon(activity.type),
                        color: _getActivityColor(activity.type),
                        size: 20,
                      ),
                    ),
                    if (activity.isSuspicious)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.surface,
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.warning,
                            size: 8,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),

                // Content section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title with activity type badge
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              activity.description,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getActivityColor(
                                activity.type,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: _getActivityColor(
                                  activity.type,
                                ).withValues(alpha: 0.3),
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              activity.type.toUpperCase(),
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: _getActivityColor(activity.type),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // User info
                      Text(
                        activity.userName ??
                            activity.userEmail ??
                            'Unknown User',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),

                      // Timestamp with enhanced formatting
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.7,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDateTime(activity.timestamp),
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.8,
                              ),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Trailing arrow for interaction hint
                Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showActivityDetails(ActivityModel activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Activity Details',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Type', activity.type.toUpperCase()),
              _buildDetailRow('Description', activity.description),
              _buildDetailRow(
                'User',
                activity.userName ?? activity.userEmail ?? 'Unknown User',
              ),
              _buildDetailRow(
                'Time',
                _formatDetailDateTime(activity.timestamp),
              ),
              if (activity.documentId != null)
                _buildDetailRow('Document ID', activity.documentId!),
              if (activity.categoryId != null)
                _buildDetailRow('Category ID', activity.categoryId!),
              if (activity.ipAddress != null)
                _buildDetailRow('IP Address', activity.ipAddress!),
              if (activity.userAgent != null)
                _buildDetailRow('User Agent', activity.userAgent!),
              if (activity.isSuspicious)
                _buildDetailRow('Status', 'SUSPICIOUS', isWarning: true),
              if (activity.details.isNotEmpty)
                ...activity.details.entries.map(
                  (entry) => _buildDetailRow(
                    entry.key.toUpperCase(),
                    entry.value.toString(),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isWarning = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: isWarning ? AppColors.warning : AppColors.textPrimary,
                fontWeight: isWarning ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDetailDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Build pagination controls with smart truncation
  Widget _buildPaginationControls(int totalPages) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button
          IconButton(
            onPressed: _currentPage > 0 ? _goToPreviousPage : null,
            icon: const Icon(Icons.chevron_left),
            style: IconButton.styleFrom(
              backgroundColor: _currentPage > 0
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : AppColors.background,
              foregroundColor: _currentPage > 0
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
          ),

          // Page indicators
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicators(totalPages),
            ),
          ),

          // Next button
          IconButton(
            onPressed: _currentPage < totalPages - 1 ? _goToNextPage : null,
            icon: const Icon(Icons.chevron_right),
            style: IconButton.styleFrom(
              backgroundColor: _currentPage < totalPages - 1
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : AppColors.background,
              foregroundColor: _currentPage < totalPages - 1
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Build page indicators with smart truncation for many pages
  List<Widget> _buildPageIndicators(int totalPages) {
    const maxVisiblePages = 5;
    List<Widget> indicators = [];

    if (totalPages <= maxVisiblePages) {
      // Show all pages if total is small
      for (int i = 0; i < totalPages; i++) {
        indicators.add(_buildPageIndicator(i));
        if (i < totalPages - 1) {
          indicators.add(const SizedBox(width: 4));
        }
      }
      return indicators;
    }

    // Smart truncation for many pages
    // Always show first page
    indicators.add(_buildPageIndicator(0));
    indicators.add(const SizedBox(width: 4));

    if (_currentPage > 2) {
      indicators.add(_buildEllipsis());
      indicators.add(const SizedBox(width: 4));
    }

    // Show current page and neighbors
    int start = (_currentPage - 1).clamp(1, totalPages - 2);
    int end = (_currentPage + 1).clamp(1, totalPages - 2);

    for (int i = start; i <= end; i++) {
      if (i != 0 && i != totalPages - 1) {
        indicators.add(_buildPageIndicator(i));
        indicators.add(const SizedBox(width: 4));
      }
    }

    if (_currentPage < totalPages - 3) {
      indicators.add(_buildEllipsis());
      indicators.add(const SizedBox(width: 4));
    }

    // Always show last page
    if (totalPages > 1) {
      indicators.add(_buildPageIndicator(totalPages - 1));
    }

    return indicators;
  }

  Widget _buildPageIndicator(int pageIndex) {
    final isActive = pageIndex == _currentPage;
    return GestureDetector(
      onTap: () => _goToPage(pageIndex),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive
                ? AppColors.primary
                : AppColors.border.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            '${pageIndex + 1}',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEllipsis() {
    return SizedBox(
      width: 32,
      height: 32,
      child: Center(
        child: Text(
          '...',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  /// Build load more section for infinite scroll
  Widget _buildLoadMoreSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          if (_isLoadingMore) ...[
            const CircularProgressIndicator(),
            const SizedBox(height: 8),
            Text(
              'Loading more activities...',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ] else ...[
            ElevatedButton.icon(
              onPressed: _loadMoreActivities,
              icon: const Icon(Icons.expand_more),
              label: Text(
                'Load More Activities',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Pagination navigation methods
  void _goToPreviousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  void _goToNextPage() {
    final totalPages = (_activities.length / _activitiesPerPage).ceil();
    if (_currentPage < totalPages - 1) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _goToPage(int pageIndex) {
    setState(() {
      _currentPage = pageIndex;
    });
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

  // Enhanced activity icons with distinct visual representation
  IconData _getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'login':
        return Icons.login;
      case 'logout':
        return Icons.logout;
      case 'upload':
        return Icons.cloud_upload;
      case 'download':
        return Icons.get_app;
      case 'delete':
        return Icons.delete_forever;
      case 'view':
        return Icons.preview;
      case 'create':
      case 'add':
        return Icons.add_circle;
      case 'update':
      case 'edit':
        return Icons.edit;
      case 'share':
        return Icons.share;
      case 'copy':
        return Icons.content_copy;
      case 'move':
        return Icons.drive_file_move;
      case 'rename':
        return Icons.drive_file_rename_outline;
      case 'suspicious_activity':
        return Icons.warning;
      case 'security':
        return Icons.security;
      case 'sync':
        return Icons.sync;
      case 'backup':
        return Icons.backup;
      case 'restore':
        return Icons.restore;
      default:
        return Icons.history;
    }
  }

  Color _getActivityColor(String type) {
    switch (type.toLowerCase()) {
      case 'login':
        return AppColors.success; // Green for successful login
      case 'logout':
        return AppColors.primary; // Blue for logout
      case 'upload':
        return AppColors.success; // Green for uploads
      case 'download':
        return AppColors.info; // Blue for downloads
      case 'delete':
        return AppColors.error; // Red for deletions
      case 'view':
      case 'preview':
        return AppColors.textSecondary; // Gray for view actions
      case 'create':
      case 'add':
        return AppColors.success; // Green for creation
      case 'update':
      case 'edit':
        return AppColors.warning; // Orange for edits
      case 'share':
        return AppColors.primary; // Blue for sharing
      case 'copy':
        return AppColors.info; // Light blue for copy
      case 'move':
        return AppColors.warning; // Orange for move
      case 'rename':
        return AppColors.warning; // Orange for rename
      case 'suspicious_activity':
        return AppColors.error; // Red for suspicious
      case 'security':
        return AppColors.error; // Red for security issues
      case 'sync':
        return AppColors.primary; // Blue for sync
      case 'backup':
        return AppColors.success; // Green for backup
      case 'restore':
        return AppColors.info; // Blue for restore
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
