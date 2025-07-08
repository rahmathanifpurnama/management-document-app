import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../common/app_container.dart';

class SearchFilterWidget extends StatefulWidget {
  final String selectedFilter;
  final String searchQuery;
  final DateTimeRange? dateRange;
  final Function(String) onFilterChanged;
  final Function(String) onSearchChanged;
  final Function(DateTimeRange?) onDateRangeChanged;
  final bool isExpanded;
  final VoidCallback? onToggleExpanded;
  final bool showExpandToggle;

  const SearchFilterWidget({
    super.key,
    required this.selectedFilter,
    required this.searchQuery,
    this.dateRange,
    required this.onFilterChanged,
    required this.onSearchChanged,
    required this.onDateRangeChanged,
    this.isExpanded = false,
    this.onToggleExpanded,
    this.showExpandToggle = true,
  });

  @override
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget>
    with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  final List<Map<String, dynamic>> _filterOptions = [
    {'value': 'all', 'label': 'All', 'icon': Icons.list},
    {'value': 'login', 'label': 'Login', 'icon': Icons.login},
    {'value': 'file', 'label': 'Files', 'icon': Icons.folder},
    {'value': 'upload', 'label': 'Upload', 'icon': Icons.upload},
    {'value': 'download', 'label': 'Download', 'icon': Icons.download},
    {'value': 'delete', 'label': 'Delete', 'icon': Icons.delete},
    {'value': 'suspicious', 'label': 'Suspicious', 'icon': Icons.warning},
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (widget.isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(SearchFilterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
    if (widget.searchQuery != oldWidget.searchQuery) {
      _searchController.text = widget.searchQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer.bordered(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          const SizedBox(height: 12),
          _buildBasicFilters(),
          if (widget.showExpandToggle) ...[
            const SizedBox(height: 8),
            _buildExpandToggle(),
          ],
          _buildExpandableContent(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search activities, users, or descriptions...',
        hintStyle: GoogleFonts.poppins(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.textSecondary,
          size: 20,
        ),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onPressed: () {
                  _searchController.clear();
                  widget.onSearchChanged('');
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        isDense: true,
      ),
      style: GoogleFonts.poppins(fontSize: 14),
      onChanged: (value) {
        // Debounce search to avoid too many calls
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_searchController.text == value) {
            widget.onSearchChanged(value);
          }
        });
      },
    );
  }

  Widget _buildBasicFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filterOptions.take(4).map((option) {
          final isSelected = widget.selectedFilter == option['value'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    option['icon'],
                    size: 16,
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(option['label']),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  widget.onFilterChanged(option['value']);
                }
              },
              backgroundColor: AppColors.background,
              selectedColor: AppColors.primary.withValues(alpha: 0.1),
              checkmarkColor: AppColors.primary,
              labelStyle: GoogleFonts.poppins(
                fontSize: 12,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: 1,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExpandToggle() {
    return GestureDetector(
      onTap: widget.onToggleExpanded,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.isExpanded ? 'Less Filters' : 'More Filters',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            AnimatedRotation(
              turns: widget.isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.primary,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableContent() {
    return SizeTransition(
      sizeFactor: _expandAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          _buildAdvancedFilters(),
          const SizedBox(height: 16),
          _buildDateRangeSelector(),
        ],
      ),
    );
  }

  Widget _buildAdvancedFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity Types',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _filterOptions.skip(4).map((option) {
            final isSelected = widget.selectedFilter == option['value'];
            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    option['icon'],
                    size: 14,
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(option['label']),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  widget.onFilterChanged(option['value']);
                }
              },
              backgroundColor: AppColors.background,
              selectedColor: AppColors.primary.withValues(alpha: 0.1),
              checkmarkColor: AppColors.primary,
              labelStyle: GoogleFonts.poppins(
                fontSize: 12,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: 1,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateRangeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date Range',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildQuickDateButton('Today', _getTodayRange())),
            const SizedBox(width: 8),
            Expanded(child: _buildQuickDateButton('Week', _getThisWeekRange())),
            const SizedBox(width: 8),
            Expanded(child: _buildQuickDateButton('Month', _getThisMonthRange())),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _selectCustomDateRange,
            icon: const Icon(Icons.date_range, size: 16),
            label: Text(
              widget.dateRange != null
                  ? '${_formatDate(widget.dateRange!.start)} - ${_formatDate(widget.dateRange!.end)}'
                  : 'Custom Range',
              style: GoogleFonts.poppins(fontSize: 12),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              side: BorderSide(
                color: widget.dateRange != null ? AppColors.primary : AppColors.border,
              ),
              foregroundColor: widget.dateRange != null ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
        if (widget.dateRange != null) ...[
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: () => widget.onDateRangeChanged(null),
              icon: const Icon(Icons.clear, size: 16),
              label: const Text('Clear Date Range'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                textStyle: GoogleFonts.poppins(fontSize: 12),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildQuickDateButton(String label, DateTimeRange range) {
    final isSelected = widget.dateRange != null &&
        widget.dateRange!.start.day == range.start.day &&
        widget.dateRange!.end.day == range.end.day;

    return OutlinedButton(
      onPressed: () => widget.onDateRangeChanged(range),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
        ),
        backgroundColor: isSelected ? AppColors.primary.withValues(alpha: 0.1) : null,
        foregroundColor: isSelected ? AppColors.primary : AppColors.textSecondary,
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 11),
      ),
    );
  }

  Future<void> _selectCustomDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: widget.dateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      widget.onDateRangeChanged(picked);
    }
  }

  DateTimeRange _getTodayRange() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return DateTimeRange(
      start: today,
      end: today.add(const Duration(days: 1)).subtract(const Duration(microseconds: 1)),
    );
  }

  DateTimeRange _getThisWeekRange() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDay = DateTime(weekStart.year, weekStart.month, weekStart.day);
    return DateTimeRange(
      start: weekStartDay,
      end: now,
    );
  }

  DateTimeRange _getThisMonthRange() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    return DateTimeRange(
      start: monthStart,
      end: now,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
