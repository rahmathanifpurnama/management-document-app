import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';

enum SortOption { nameAsc, nameDesc, dateAsc, dateDesc, sizeAsc, sizeDesc }

class SearchFilterState {
  final String searchQuery;
  final String selectedFilter;
  final List<String> selectedFileTypes;
  final DateTimeRange? dateRange;
  final SortOption sortOption;
  final bool showOnlyFavorites;

  SearchFilterState({
    this.searchQuery = '',
    this.selectedFilter = 'all',
    this.selectedFileTypes = const [],
    this.dateRange,
    this.sortOption = SortOption.dateDesc,
    this.showOnlyFavorites = false,
  });

  SearchFilterState copyWith({
    String? searchQuery,
    String? selectedFilter,
    List<String>? selectedFileTypes,
    DateTimeRange? dateRange,
    SortOption? sortOption,
    bool? showOnlyFavorites,
  }) {
    return SearchFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedFileTypes: selectedFileTypes ?? this.selectedFileTypes,
      dateRange: dateRange ?? this.dateRange,
      sortOption: sortOption ?? this.sortOption,
      showOnlyFavorites: showOnlyFavorites ?? this.showOnlyFavorites,
    );
  }
}

class AdvancedSearchFilter extends StatefulWidget {
  final SearchFilterState initialState;
  final List<String> filterOptions;
  final List<String> availableFileTypes;
  final Function(SearchFilterState state) onStateChanged;
  final bool showAdvancedFilters;
  final bool showSortOptions;
  final bool showDateFilter;
  final bool showFileTypeFilter;
  final String searchHint;

  const AdvancedSearchFilter({
    super.key,
    required this.initialState,
    required this.filterOptions,
    required this.availableFileTypes,
    required this.onStateChanged,
    this.showAdvancedFilters = true,
    this.showSortOptions = true,
    this.showDateFilter = true,
    this.showFileTypeFilter = true,
    this.searchHint = 'Search files...',
  });

  @override
  State<AdvancedSearchFilter> createState() => _AdvancedSearchFilterState();
}

class _AdvancedSearchFilterState extends State<AdvancedSearchFilter> {
  late TextEditingController _searchController;
  late SearchFilterState _currentState;
  bool _showAdvancedFilters = false;

  @override
  void initState() {
    super.initState();
    _currentState = widget.initialState;
    _searchController = TextEditingController(text: _currentState.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Search bar
          _buildSearchBar(),
          const SizedBox(height: 12),

          // Basic filter tabs
          _buildFilterTabs(),

          // Advanced filters toggle
          if (widget.showAdvancedFilters) ...[
            const SizedBox(height: 8),
            _buildAdvancedFiltersToggle(),
          ],

          // Advanced filters panel
          if (_showAdvancedFilters) ...[
            const SizedBox(height: 12),
            _buildAdvancedFiltersPanel(),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: widget.searchHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _updateState(_currentState.copyWith(searchQuery: ''));
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: AppColors.surface,
            ),
            onChanged: (query) {
              _updateState(_currentState.copyWith(searchQuery: query));
            },
          ),
        ),
        const SizedBox(width: 8),
        // Sort button
        if (widget.showSortOptions)
          PopupMenuButton<SortOption>(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.3),
                ),
              ),
              child: const Icon(Icons.sort),
            ),
            onSelected: (sortOption) {
              _updateState(_currentState.copyWith(sortOption: sortOption));
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: SortOption.nameAsc,
                child: Row(
                  children: [
                    Icon(Icons.sort_by_alpha, size: 16),
                    SizedBox(width: 8),
                    Text('Name A-Z'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: SortOption.nameDesc,
                child: Row(
                  children: [
                    Icon(Icons.sort_by_alpha, size: 16),
                    SizedBox(width: 8),
                    Text('Name Z-A'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: SortOption.dateDesc,
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 16),
                    SizedBox(width: 8),
                    Text('Newest First'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: SortOption.dateAsc,
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 16),
                    SizedBox(width: 8),
                    Text('Oldest First'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: SortOption.sizeDesc,
                child: Row(
                  children: [
                    Icon(Icons.storage, size: 16),
                    SizedBox(width: 8),
                    Text('Largest First'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: SortOption.sizeAsc,
                child: Row(
                  children: [
                    Icon(Icons.storage, size: 16),
                    SizedBox(width: 8),
                    Text('Smallest First'),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildFilterTabs() {
    return Row(
      children: widget.filterOptions.map((filter) {
        final isSelected = _currentState.selectedFilter == filter;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              _updateState(_currentState.copyWith(selectedFilter: filter));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.border.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                _getFilterLabel(filter),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAdvancedFiltersToggle() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showAdvancedFilters = !_showAdvancedFilters;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _showAdvancedFilters ? Icons.expand_less : Icons.expand_more,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              'Advanced Filters',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedFiltersPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date range filter
          if (widget.showDateFilter) ...[
            Text(
              'Date Range',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            _buildDateRangeSelector(),
            const SizedBox(height: 16),
          ],

          // File type filter
          if (widget.showFileTypeFilter &&
              widget.availableFileTypes.isNotEmpty) ...[
            Text(
              'File Types',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            _buildFileTypeFilter(),
            const SizedBox(height: 16),
          ],

          // Clear filters button
          Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: _clearAllFilters,
                child: Text(
                  'Clear All Filters',
                  style: GoogleFonts.poppins(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    return GestureDetector(
      onTap: _selectDateRange,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.date_range, size: 16),
            const SizedBox(width: 8),
            Text(
              _currentState.dateRange != null
                  ? '${DateFormat('MMM dd').format(_currentState.dateRange!.start)} - ${DateFormat('MMM dd').format(_currentState.dateRange!.end)}'
                  : 'Select date range',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: _currentState.dateRange != null
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            if (_currentState.dateRange != null)
              GestureDetector(
                onTap: () {
                  _updateState(_currentState.copyWith(dateRange: null));
                },
                child: const Icon(Icons.clear, size: 16),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileTypeFilter() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.availableFileTypes.map((fileType) {
        final isSelected = _currentState.selectedFileTypes.contains(fileType);
        return GestureDetector(
          onTap: () => _toggleFileType(fileType),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.border.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              fileType.toUpperCase(),
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _updateState(SearchFilterState newState) {
    setState(() {
      _currentState = newState;
    });
    widget.onStateChanged(newState);
  }

  void _toggleFileType(String fileType) {
    final selectedTypes = List<String>.from(_currentState.selectedFileTypes);
    if (selectedTypes.contains(fileType)) {
      selectedTypes.remove(fileType);
    } else {
      selectedTypes.add(fileType);
    }
    _updateState(_currentState.copyWith(selectedFileTypes: selectedTypes));
  }

  Future<void> _selectDateRange() async {
    final dateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: _currentState.dateRange,
    );

    if (dateRange != null) {
      _updateState(_currentState.copyWith(dateRange: dateRange));
    }
  }

  void _clearAllFilters() {
    _searchController.clear();
    _updateState(SearchFilterState(selectedFilter: widget.filterOptions.first));
  }

  String _getFilterLabel(String filter) {
    switch (filter.toLowerCase()) {
      case 'all':
        return 'All';
      case 'pending':
        return 'Pending';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'favorites':
        return 'Favorites';
      case 'recent':
        return 'Recent';
      default:
        return filter;
    }
  }
}
