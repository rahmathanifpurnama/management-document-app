import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../core/constants/app_colors.dart';
import '../../features/auth/providers/auth_providers.dart';
import '../../services/activity_data_manager.dart';
import '../../models/activity_model.dart';
import '../../widgets/activity/quick_access_widget.dart';
import '../../widgets/activity/storage_chart_widget.dart';
import '../../widgets/activity/search_filter_widget.dart';
import '../../widgets/activity/activity_list_header.dart';
import '../../widgets/activity/activity_tile_factory.dart';
import '../../widgets/activity/activity_details_dialog.dart';
import '../../widgets/common/app_container.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/empty_state_widget.dart';

class NewActivityPage extends ConsumerStatefulWidget {
  const NewActivityPage({super.key});

  @override
  ConsumerState<NewActivityPage> createState() => _NewActivityPageState();
}

class _NewActivityPageState extends ConsumerState<NewActivityPage> {
  late final ActivityDataManager _dataManager;
  final ScrollController _scrollController = ScrollController();

  // UI state
  bool _isFilterExpanded = false;
  int _currentPage = 0;
  static const int _activitiesPerPage = 25;

  // Debouncing timers
  Timer? _searchDebounceTimer;
  Timer? _filterDebounceTimer;

  @override
  void initState() {
    super.initState();
    _dataManager = ActivityDataManager(pageSize: 25);
    _dataManager.setStateChangeCallback(() {
      if (mounted) setState(() {});
    });
    _scrollController.addListener(_onScroll);
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchDebounceTimer?.cancel();
    _filterDebounceTimer?.cancel();
    _dataManager.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _dataManager.loadMore();
    }
  }

  Future<void> _loadInitialData() async {
    try {
      await _dataManager.initialize();
    } catch (e) {
      debugPrint('Error loading initial data: $e');
    }
  }

  // Simplified methods using data manager
  Future<void> _refreshData() async {
    await _dataManager.refresh();
  }

  void _onFilterChanged(String filter) {
    _filterDebounceTimer?.cancel();
    _filterDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      _dataManager.applyFilter(filter);
    });
  }

  void _onSearchChanged(String query) {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      _dataManager.applySearch(query);
    });
  }

  void _onDateRangeChanged(DateTimeRange? range) {
    _dataManager.applyDateRange(range);
  }

  void _onToggleFilterExpanded() {
    setState(() {
      _isFilterExpanded = !_isFilterExpanded;
    });
  }

  void _onStatTap(String statKey) {
    // Handle quick access stat tap
    switch (statKey) {
      case 'today':
        _dataManager.applyDateRange(_getTodayRange());
        break;
      case 'week':
        _dataManager.applyDateRange(_getThisWeekRange());
        break;
      case 'suspicious':
        _dataManager.applyFilter('suspicious');
        break;
      default:
        break;
    }
  }

  // Helper methods for date ranges
  DateTimeRange _getTodayRange() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return DateTimeRange(start: today, end: now);
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

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final isAdmin = ref.watch(isAdminProvider);
        return FutureBuilder<bool>(
          future: Future.value(isAdmin),
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
          onPressed: _dataManager.isLoading ? null : _refreshData,
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_dataManager.isLoading && _dataManager.activities.isEmpty) {
      return const LoadingWidget(message: 'Loading activities...');
    }

    if (_dataManager.error != null) {
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
              selectedFilter: _dataManager.selectedFilter,
              searchQuery: _dataManager.searchQuery,
              dateRange: _dataManager.dateRange,
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
              activityCount: _dataManager.activities.length,
              onRefresh: _refreshData,
              activities: _dataManager.activities,
              isLoading: _dataManager.isLoading,
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
              height: _dataManager.isLoadingMore ? 60 : 0,
              child: _dataManager.isLoadingMore
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
    final activities = _dataManager.activities;

    if (activities.isEmpty) {
      return _buildEmptyState();
    }

    // Calculate pagination
    final totalPages = (activities.length / _activitiesPerPage).ceil();
    final startIndex = _currentPage * _activitiesPerPage;
    final endIndex = (startIndex + _activitiesPerPage).clamp(
      0,
      activities.length,
    );
    final currentPageActivities = activities.sublist(startIndex, endIndex);

    return Column(
      children: [
        // Activity list with polymorphic rendering
        ActivityListContainer(
          activities: currentPageActivities,
          onActivityTap: _showActivityDetails,
          showAnimations: true,
        ),

        // Pagination controls
        if (totalPages > 1) ...[
          const SizedBox(height: 16),
          _buildPaginationControls(totalPages),
        ],

        // Load more section for infinite scroll
        if (_dataManager.hasMoreData && _currentPage == totalPages - 1) ...[
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
        subtitle: _dataManager.hasActiveFilters
            ? 'Try adjusting your filters'
            : 'No activities have been recorded yet',
      ),
    );
  }

  void _showActivityDetails(BaseActivity activity) {
    showDialog(
      context: context,
      builder: (context) => ActivityDetailsDialog(activity: activity),
    );
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
          if (_dataManager.isLoadingMore) ...[
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
              onPressed: () => _dataManager.loadMore(),
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
    final totalPages = (_dataManager.activities.length / _activitiesPerPage)
        .ceil();
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
              _dataManager.error ?? 'An unknown error occurred',
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
}
