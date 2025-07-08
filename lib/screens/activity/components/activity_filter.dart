import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class ActivityFilter extends StatefulWidget {
  final String selectedFilter;
  final String searchQuery;
  final DateTimeRange? dateRange;
  final Function(String) onFilterChanged;
  final Function(String) onSearchChanged;
  final Function(DateTimeRange?) onDateRangeChanged;

  const ActivityFilter({
    super.key,
    required this.selectedFilter,
    required this.searchQuery,
    this.dateRange,
    required this.onFilterChanged,
    required this.onSearchChanged,
    required this.onDateRangeChanged,
  });

  @override
  State<ActivityFilter> createState() => _ActivityFilterState();
}

class _ActivityFilterState extends State<ActivityFilter> {
  final TextEditingController _searchController = TextEditingController();
  
  final List<Map<String, dynamic>> _filterOptions = [
    {'value': 'all', 'label': 'All Activities', 'icon': Icons.list},
    {'value': 'login', 'label': 'Login/Logout', 'icon': Icons.login},
    {'value': 'file', 'label': 'File Operations', 'icon': Icons.folder},
    {'value': 'upload', 'label': 'Uploads', 'icon': Icons.upload},
    {'value': 'download', 'label': 'Downloads', 'icon': Icons.download},
    {'value': 'delete', 'label': 'Deletions', 'icon': Icons.delete},
    {'value': 'suspicious', 'label': 'Suspicious', 'icon': Icons.warning},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          const SizedBox(height: 16),
          _buildFilterChips(),
          const SizedBox(height: 16),
          _buildDateRangeSelector(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search activities, users, or descriptions...',
        prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                onPressed: () {
                  _searchController.clear();
                  widget.onSearchChanged('');
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.05),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onChanged: (value) {
        // Debounce search to avoid too many API calls
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_searchController.text == value) {
            widget.onSearchChanged(value);
          }
        });
      },
    );
  }

  Widget _buildFilterChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter by Activity Type',
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
          children: _filterOptions.map((option) {
            final isSelected = widget.selectedFilter == option['value'];
            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    option['icon'] as IconData,
                    size: 16,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    option['label'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                widget.onFilterChanged(option['value'] as String);
              },
              backgroundColor: Colors.grey.withOpacity(0.1),
              selectedColor: AppColors.primary,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.3),
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
            Expanded(
              child: _buildQuickDateButton('Today', _getTodayRange()),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildQuickDateButton('This Week', _getThisWeekRange()),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildQuickDateButton('This Month', _getThisMonthRange()),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _selectCustomDateRange,
                icon: const Icon(Icons.date_range, size: 16),
                label: Text(
                  widget.dateRange != null
                      ? '${_formatDate(widget.dateRange!.start)} - ${_formatDate(widget.dateRange!.end)}'
                      : 'Custom Range',
                  style: const TextStyle(fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  side: BorderSide(
                    color: widget.dateRange != null ? AppColors.primary : Colors.grey.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            if (widget.dateRange != null) ...[
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => widget.onDateRangeChanged(null),
                icon: const Icon(Icons.clear, size: 16),
                tooltip: 'Clear date filter',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  padding: const EdgeInsets.all(8),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildQuickDateButton(String label, DateTimeRange range) {
    final isSelected = widget.dateRange != null &&
        _isSameDay(widget.dateRange!.start, range.start) &&
        _isSameDay(widget.dateRange!.end, range.end);

    return OutlinedButton(
      onPressed: () => widget.onDateRangeChanged(range),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.primary.withOpacity(0.1) : null,
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.3),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
        ),
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

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
