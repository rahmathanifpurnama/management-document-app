import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/document_provider.dart';

enum FileFilterMode {
  modal, // Modal bottom sheet (default)
  embedded, // Embedded in page
}

class FileFilterWidget extends StatelessWidget {
  final VoidCallback? onFilterApplied;
  final VoidCallback? onClose;
  final FileFilterMode mode;

  const FileFilterWidget({
    super.key,
    this.onFilterApplied,
    this.onClose,
    this.mode = FileFilterMode.modal,
  });

  /// Factory constructor for modal filter (bottom sheet)
  factory FileFilterWidget.modal({VoidCallback? onFilterApplied}) {
    return FileFilterWidget(
      onFilterApplied: onFilterApplied,
      mode: FileFilterMode.modal,
    );
  }

  /// Factory constructor for embedded filter (in page)
  factory FileFilterWidget.embedded({
    VoidCallback? onFilterApplied,
    VoidCallback? onClose,
  }) {
    return FileFilterWidget(
      onFilterApplied: onFilterApplied,
      onClose: onClose,
      mode: FileFilterMode.embedded,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentProvider>(
      builder: (context, documentProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: mode == FileFilterMode.modal
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
              if (mode == FileFilterMode.embedded) ...[
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
                    if (onClose != null)
                      IconButton(
                        onPressed: onClose,
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
              _buildFileTypeFilters(context, documentProvider),

              const SizedBox(height: 20),

              // Sort Section
              _buildSectionTitle('Sort Files'),
              const SizedBox(height: 8),
              _buildSortOptions(context, documentProvider),

              const SizedBox(height: 20),

              // Clear Filter Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    documentProvider.clearFilters();
                    onFilterApplied?.call();
                    if (mode == FileFilterMode.modal) {
                      Navigator.pop(context);
                    }
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

  Widget _buildFileTypeFilters(
    BuildContext context,
    DocumentProvider documentProvider,
  ) {
    final fileTypes = [
      {'key': 'all', 'label': 'All Files', 'icon': Icons.folder_open},
      {'key': 'PDF', 'label': 'PDF', 'icon': Icons.picture_as_pdf},
      {'key': 'DOC', 'label': 'Word', 'icon': Icons.description},
      {'key': 'Excel', 'label': 'Excel', 'icon': Icons.table_chart},
      {'key': 'Image', 'label': 'Images', 'icon': Icons.image},
      {'key': 'PPT', 'label': 'PowerPoint', 'icon': Icons.slideshow},
      {'key': 'TXT', 'label': 'Text', 'icon': Icons.text_snippet},
      {'key': 'Other', 'label': 'Other', 'icon': Icons.insert_drive_file},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: fileTypes.map((fileType) {
        final isSelected = documentProvider.selectedFileType == fileType['key'];
        return FilterChip(
          selected: isSelected,
          onSelected: (selected) {
            documentProvider.filterByFileType(fileType['key'] as String);
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
    DocumentProvider documentProvider,
  ) {
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
            documentProvider.sortBy == option['key'] &&
            documentProvider.sortAscending == option['ascending'];

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
              documentProvider.sortDocuments(
                option['key'] as String,
                ascending: option['ascending'] as bool,
              );
              onFilterApplied?.call();
              if (mode == FileFilterMode.modal) {
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
