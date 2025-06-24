import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/filter_states/home_screen_filter_state.dart';

enum HomeFilterMode {
  modal, // Modal bottom sheet (default)
  embedded, // Embedded in page
}

class HomeScreenFilterWidget extends StatelessWidget {
  final VoidCallback? onFilterApplied;
  final VoidCallback? onClose;
  final HomeFilterMode mode;

  const HomeScreenFilterWidget({
    super.key,
    this.onFilterApplied,
    this.onClose,
    this.mode = HomeFilterMode.modal,
  });

  /// Factory constructor for modal filter (bottom sheet)
  factory HomeScreenFilterWidget.modal({VoidCallback? onFilterApplied}) {
    return HomeScreenFilterWidget(
      onFilterApplied: onFilterApplied,
      mode: HomeFilterMode.modal,
    );
  }

  /// Factory constructor for embedded filter (in page)
  factory HomeScreenFilterWidget.embedded({
    VoidCallback? onFilterApplied,
    VoidCallback? onClose,
  }) {
    return HomeScreenFilterWidget(
      onFilterApplied: onFilterApplied,
      onClose: onClose,
      mode: HomeFilterMode.embedded,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenFilterState>(
      builder: (context, filterState, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: mode == HomeFilterMode.modal
                ? const BorderRadius.vertical(top: Radius.circular(20))
                : BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              if (mode == HomeFilterMode.embedded) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter Files',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (onClose != null)
                      IconButton(
                        onPressed: onClose,
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.textSecondary,
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
              _buildFileTypeFilters(context, filterState),

              const SizedBox(height: 20),

              // Sort Section
              _buildSectionTitle('Sort Files'),
              const SizedBox(height: 8),
              _buildSortOptions(context, filterState),

              const SizedBox(height: 20),

              // Clear Filters Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    filterState.clearFilters();
                    onFilterApplied?.call();
                    if (mode == HomeFilterMode.modal) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                  label: Text(
                    'Clear All Filters',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
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
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildFileTypeFilters(
    BuildContext context,
    HomeScreenFilterState filterState,
  ) {
    // Consolidated file types (CSV removed, merged with Excel)
    final fileTypes = [
      {'key': 'all', 'label': 'All Files', 'icon': Icons.folder_open},
      {'key': 'PDF', 'label': 'PDF', 'icon': Icons.picture_as_pdf},
      {'key': 'DOC', 'label': 'Word', 'icon': Icons.description},
      {'key': 'Excel', 'label': 'Excel', 'icon': Icons.table_chart}, // CSV consolidated here
      {'key': 'Image', 'label': 'Images', 'icon': Icons.image},
      {'key': 'PPT', 'label': 'PowerPoint', 'icon': Icons.slideshow},
      {'key': 'TXT', 'label': 'Text', 'icon': Icons.text_snippet},
      {'key': 'Other', 'label': 'Other', 'icon': Icons.insert_drive_file},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: fileTypes.map((fileType) {
        final isSelected = filterState.selectedFileType == fileType['key'];
        return FilterChip(
          selected: isSelected,
          onSelected: (selected) {
            filterState.filterByFileType(fileType['key'] as String);
            onFilterApplied?.call();
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

  Widget _buildSortOptions(
    BuildContext context,
    HomeScreenFilterState filterState,
  ) {
    final sortOptions = [
      {'key': 'uploadedAt', 'label': 'Upload Date', 'ascending': false},
      {'key': 'fileName', 'label': 'Name (A-Z)', 'ascending': true},
      {'key': 'fileName', 'label': 'Name (Z-A)', 'ascending': false},
      {'key': 'fileSize', 'label': 'Size (Small to Large)', 'ascending': true},
      {'key': 'fileSize', 'label': 'Size (Large to Small)', 'ascending': false},
      {'key': 'category', 'label': 'Category', 'ascending': true},
    ];

    return Column(
      children: sortOptions.map((option) {
        final isSelected = filterState.sortBy == option['key'] &&
            filterState.sortAscending == option['ascending'];
        return ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(
            option['label'] as String,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
          trailing: isSelected
              ? const Icon(Icons.check, color: AppColors.primary, size: 20)
              : null,
          onTap: () {
            filterState.sortDocuments(
              option['key'] as String,
              ascending: option['ascending'] as bool,
            );
            onFilterApplied?.call();
          },
        );
      }).toList(),
    );
  }
}
