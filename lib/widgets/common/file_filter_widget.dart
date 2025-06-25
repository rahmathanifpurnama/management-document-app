import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/document_provider.dart';

enum FileFilterMode {
  modal, // Modal bottom sheet (default)
  embedded, // Embedded in page
}

/// Context-aware filter contexts for independent filter state management
enum FilterContext { homeScreen, categoryFiles, addFiles }

/// Independent filter state for each context
class ContextFilterState {
  String searchQuery;
  String selectedFileType;
  String sortBy;
  bool sortAscending;

  ContextFilterState({
    this.searchQuery = '',
    this.selectedFileType = 'all',
    this.sortBy = 'uploadedAt',
    this.sortAscending = false,
  });

  ContextFilterState copyWith({
    String? searchQuery,
    String? selectedFileType,
    String? sortBy,
    bool? sortAscending,
  }) {
    return ContextFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFileType: selectedFileType ?? this.selectedFileType,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }

  void reset() {
    searchQuery = '';
    selectedFileType = 'all';
    sortBy = 'uploadedAt';
    sortAscending = false;
  }

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty || selectedFileType != 'all';
}

/// Static helper class to access context-specific filter states
class FilterStateManager {
  static final Map<FilterContext, ContextFilterState> _contextStates = {
    FilterContext.homeScreen: ContextFilterState(),
    FilterContext.categoryFiles: ContextFilterState(),
    FilterContext.addFiles: ContextFilterState(),
  };

  /// Get filter state for specific context
  static ContextFilterState getState(FilterContext context) {
    return _contextStates[context]!;
  }

  /// Reset filter state for specific context
  static void resetState(FilterContext context) {
    _contextStates[context]!.reset();
  }

  /// Reset all filter states
  static void resetAllStates() {
    for (var state in _contextStates.values) {
      state.reset();
    }
  }

  /// Check if any context has active filters
  static bool hasAnyActiveFilters() {
    return _contextStates.values.any((state) => state.hasActiveFilters);
  }
}

class FileFilterWidget extends StatefulWidget {
  final VoidCallback? onFilterApplied;
  final VoidCallback? onClose;
  final FileFilterMode mode;
  final FilterContext filterContext;
  final String? categoryId; // For category-specific filtering

  const FileFilterWidget({
    super.key,
    this.onFilterApplied,
    this.onClose,
    this.mode = FileFilterMode.modal,
    this.filterContext = FilterContext.homeScreen,
    this.categoryId,
  });

  /// Factory constructor for home screen filter
  factory FileFilterWidget.forHome({VoidCallback? onFilterApplied}) {
    return FileFilterWidget(
      onFilterApplied: onFilterApplied,
      mode: FileFilterMode.modal,
      filterContext: FilterContext.homeScreen,
    );
  }

  /// Factory constructor for category files filter
  factory FileFilterWidget.forCategory({
    required String categoryId,
    VoidCallback? onFilterApplied,
  }) {
    return FileFilterWidget(
      onFilterApplied: onFilterApplied,
      mode: FileFilterMode.modal,
      filterContext: FilterContext.categoryFiles,
      categoryId: categoryId,
    );
  }

  /// Factory constructor for add files filter
  factory FileFilterWidget.forAddFiles({
    required String categoryId,
    VoidCallback? onFilterApplied,
  }) {
    return FileFilterWidget(
      onFilterApplied: onFilterApplied,
      mode: FileFilterMode.modal,
      filterContext: FilterContext.addFiles,
      categoryId: categoryId,
    );
  }

  /// Factory constructor for modal filter (backward compatibility)
  factory FileFilterWidget.modal({VoidCallback? onFilterApplied}) {
    return FileFilterWidget(
      onFilterApplied: onFilterApplied,
      mode: FileFilterMode.modal,
      filterContext: FilterContext.homeScreen,
    );
  }

  /// Factory constructor for embedded filter (backward compatibility)
  factory FileFilterWidget.embedded({
    VoidCallback? onFilterApplied,
    VoidCallback? onClose,
  }) {
    return FileFilterWidget(
      onFilterApplied: onFilterApplied,
      onClose: onClose,
      mode: FileFilterMode.embedded,
      filterContext: FilterContext.homeScreen,
    );
  }

  @override
  State<FileFilterWidget> createState() => _FileFilterWidgetState();
}

class _FileFilterWidgetState extends State<FileFilterWidget> {
  ContextFilterState get _currentState =>
      FilterStateManager.getState(widget.filterContext);

  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentProvider>(
      builder: (context, documentProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: widget.mode == FileFilterMode.modal
              ? const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                )
              : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with mode-specific styling
              if (widget.mode == FileFilterMode.embedded) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (widget.onClose != null)
                      IconButton(
                        onPressed: widget.onClose,
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 24,
                          minHeight: 24,
                        ),
                      ),
                  ],
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter Files',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),

              // File Type Filter Section
              _buildSectionTitle('File Type'),
              const SizedBox(height: 8),
              _buildFileTypeFilters(context),

              const SizedBox(height: 20),

              // Sort Section
              _buildSectionTitle('Sort Files'),
              const SizedBox(height: 8),
              _buildSortOptions(context),

              const SizedBox(height: 20),

              // Clear Filter Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _currentState.reset();
                    widget.onFilterApplied?.call();
                    if (widget.mode == FileFilterMode.modal) {
                      Navigator.pop(context);
                    }
                    setState(() {}); // Refresh UI
                  },
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                  label: Text(
                    'Clear All Filters',
                    style: GoogleFonts.poppins(color: AppColors.textSecondary),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildFileTypeFilters(BuildContext context) {
    final fileTypes = [
      {'key': 'all', 'label': 'All Files', 'icon': Icons.folder_open},
      {'key': 'PDF', 'label': 'PDF', 'icon': Icons.picture_as_pdf},
      {'key': 'DOC', 'label': 'Word', 'icon': Icons.description},
      {'key': 'Excel', 'label': 'Excel', 'icon': Icons.table_chart},
      {'key': 'CSV', 'label': 'CSV', 'icon': Icons.grid_on},
      {'key': 'Image', 'label': 'Images', 'icon': Icons.image},
      {'key': 'PPT', 'label': 'PowerPoint', 'icon': Icons.slideshow},
      {'key': 'TXT', 'label': 'Text', 'icon': Icons.text_snippet},
      {'key': 'Other', 'label': 'Other', 'icon': Icons.insert_drive_file},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: fileTypes.map((fileType) {
        final isSelected = _currentState.selectedFileType == fileType['key'];
        return FilterChip(
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _currentState.selectedFileType = fileType['key'] as String;
            });
            widget.onFilterApplied?.call();
          },
          avatar: Icon(
            fileType['icon'] as IconData,
            size: 16,
            color: isSelected ? AppColors.surface : AppColors.primary,
          ),
          label: Text(
            fileType['label'] as String,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: isSelected ? AppColors.surface : AppColors.textPrimary,
            ),
          ),
          backgroundColor: AppColors.surface,
          selectedColor: AppColors.primary,
          checkmarkColor: AppColors.surface,
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSortOptions(BuildContext context) {
    final sortOptions = [
      {
        'key': 'uploadedAt',
        'label': 'Recent First',
        'icon': Icons.access_time,
        'ascending': false,
      },
      {
        'key': 'uploadedAt',
        'label': 'Oldest First',
        'icon': Icons.history,
        'ascending': true,
      },
      {
        'key': 'fileName',
        'label': 'A-Z',
        'icon': Icons.sort_by_alpha,
        'ascending': true,
      },
      {
        'key': 'fileName',
        'label': 'Z-A',
        'icon': Icons.sort_by_alpha,
        'ascending': false,
      },
    ];

    return Column(
      children: sortOptions.map((option) {
        final isSelected =
            _currentState.sortBy == option['key'] &&
            _currentState.sortAscending == option['ascending'];

        return Container(
          margin: const EdgeInsets.only(bottom: 4),
          child: ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            leading: Icon(
              option['icon'] as IconData,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 20,
            ),
            title: Text(
              option['label'] as String,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            trailing: isSelected
                ? const Icon(Icons.check, color: AppColors.primary, size: 20)
                : null,
            onTap: () {
              setState(() {
                _currentState.sortBy = option['key'] as String;
                _currentState.sortAscending = option['ascending'] as bool;
              });
              widget.onFilterApplied?.call();
              if (widget.mode == FileFilterMode.modal) {
                Navigator.pop(context);
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            tileColor: isSelected ? AppColors.primaryLight : null,
          ),
        );
      }).toList(),
    );
  }
}
