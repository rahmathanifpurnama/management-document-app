import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../../core/constants/app_colors.dart';
import '../../providers/document_provider.dart';
import '../../providers/file_selection_provider.dart';
import '../../models/category_model.dart';
import '../../models/document_model.dart';
import '../../widgets/common/app_bottom_navigation.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/ios_back_button.dart';
import '../../widgets/common/embedded_file_filter_widget.dart';

class AddFilesToCategoryScreen extends StatefulWidget {
  final CategoryModel category;

  const AddFilesToCategoryScreen({super.key, required this.category});

  @override
  State<AddFilesToCategoryScreen> createState() =>
      _AddFilesToCategoryScreenState();
}

class _AddFilesToCategoryScreenState extends State<AddFilesToCategoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchTimer;
  bool _isLoading = false;
  bool _isFilterExpanded = false;

  // ========== MARGIN CONFIGURATION - Easy to adjust ==========
  // Section margins - Reduced to bring content closer to navbar
  static const EdgeInsets _searchSectionMargin = EdgeInsets.fromLTRB(
    16,
    15,
    16,
    12,
  );
  static const EdgeInsets _filterSectionMargin = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 4,
  );
  static const EdgeInsets _selectedInfoMargin = EdgeInsets.fromLTRB(
    16,
    8,
    16,
    8,
  );
  static const EdgeInsets _tableContainerMargin = EdgeInsets.symmetric(
    horizontal: 16,
  );

  // Internal paddings - Reduced for more compact layout
  static const EdgeInsets _searchSectionPadding = EdgeInsets.all(12);
  static const EdgeInsets _emptyStatePadding = EdgeInsets.all(24);

  // Spacing between sections - Reduced for more compact layout
  static const double sectionSpacing = 8.0;
  static const double bottomSpacing = 80.0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    final documentProvider = Provider.of<DocumentProvider>(
      context,
      listen: false,
    );
    await documentProvider.loadDocuments();
  }

  void _onSearchChanged() {
    if (_searchTimer?.isActive ?? false) _searchTimer!.cancel();

    // Perform search immediately if there's at least 1 character or if clearing search
    final searchText = _searchController.text.trim();
    if (searchText.isNotEmpty || searchText.isEmpty) {
      // Use minimal delay for better performance while still preventing excessive calls
      _searchTimer = Timer(const Duration(milliseconds: 100), () {
        _performSearch();
      });
    }
  }

  void _performSearch() {
    setState(() {
      // Trigger rebuild to apply filter
    });
  }

  List<DocumentModel> _getAvailableDocuments(List<DocumentModel> allDocuments) {
    // Get documents that are NOT in any category/folder (category is empty or uncategorized)
    var availableDocuments = allDocuments
        .where((doc) => doc.category.isEmpty || doc.category == 'uncategorized')
        .toList();

    // Apply search filter
    final searchQuery = _searchController.text.toLowerCase().trim();
    if (searchQuery.isNotEmpty) {
      availableDocuments = availableDocuments.where((document) {
        final fileName = document.fileName.toLowerCase();
        final description = document.metadata.description.toLowerCase();
        final fileType = document.fileType.toLowerCase();

        return fileName.contains(searchQuery) ||
            description.contains(searchQuery) ||
            fileType.contains(searchQuery);
      }).toList();
    }

    return availableDocuments;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FileSelectionProvider>(
      builder: (context, selectionProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(
            title: 'Add Files to ${widget.category.name}',
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textWhite,
            leading: const IOSBackButton(),
            actions: [
              if (selectionProvider.hasSelection)
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () => _addSelectedFiles(selectionProvider),
                  child: Text(
                    'Add (${selectionProvider.selectedCount})',
                    style: GoogleFonts.poppins(
                      color: _isLoading
                          ? AppColors.textSecondary
                          : AppColors.textWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: const AppBottomNavigation(currentIndex: 1),
          body: Consumer<DocumentProvider>(
            builder: (context, documentProvider, child) {
              // Apply DocumentProvider filters first, then get available documents
              final filteredDocuments = documentProvider.documents;
              final availableDocuments = _getAvailableDocuments(
                filteredDocuments,
              );

              // Update available files for selection
              WidgetsBinding.instance.addPostFrameCallback((_) {
                selectionProvider.updateAvailableFiles(availableDocuments);
              });

              return Column(
                children: [
                  // Custom selection bar for add-only functionality
                  _buildAddOnlySelectionBar(selectionProvider),

                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _loadData,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            // Search Section
                            _buildSearchSection(),

                            // Filter Section
                            _buildCollapsibleFilterSection(),

                            // Files List
                            _buildFileList(
                              availableDocuments,
                              selectionProvider,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSearchSection() {
    return Container(
      margin: _searchSectionMargin,
      padding: _searchSectionPadding,
      decoration: BoxDecoration(
        color: AppColors.searchBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search available files',
            hintStyle: GoogleFonts.poppins(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.textSecondary,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        // Trigger rebuild to clear filter
                      });
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsibleFilterSection() {
    return Consumer<DocumentProvider>(
      builder: (context, documentProvider, child) {
        // Check if any filters are active
        final bool hasActiveFilters =
            documentProvider.selectedFileType != 'all' ||
            documentProvider.sortBy != 'uploadedAt' ||
            documentProvider.sortAscending != false;

        return Container(
          margin: _filterSectionMargin,
          child: Column(
            children: [
              // Filter Toggle Button
              Container(
                decoration: BoxDecoration(
                  color: hasActiveFilters
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.searchBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: hasActiveFilters
                      ? Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        )
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      setState(() {
                        _isFilterExpanded = !_isFilterExpanded;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.filter_list,
                            color: hasActiveFilters
                                ? AppColors.primary
                                : AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  'Filter Files',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                if (hasActiveFilters) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Active',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.surface,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          AnimatedRotation(
                            turns: _isFilterExpanded ? 0.5 : 0.0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Collapsible Filter Content
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: _isFilterExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox.shrink(),
                secondChild: Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.border.withValues(alpha: 0.3),
                    ),
                  ),
                  child: EmbeddedFileFilterWidget(
                    onFilterApplied: () {
                      setState(() {
                        // Trigger rebuild to apply filters
                        // Optionally auto-collapse after filter selection
                        _isFilterExpanded = false;
                      });
                    },
                    onClose: () {
                      setState(() {
                        _isFilterExpanded = false;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build custom selection bar for add-only functionality
  Widget _buildAddOnlySelectionBar(FileSelectionProvider selectionProvider) {
    if (!selectionProvider.isSelectionMode) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Close selection mode button
          IconButton(
            onPressed: () {
              selectionProvider.exitSelectionMode();
            },
            icon: const Icon(Icons.close),
            color: AppColors.primary,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),

          const SizedBox(width: 12),

          // Selection count
          Expanded(
            child: Text(
              '${selectionProvider.selectedCount} file(s) selected',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),

          // Select All / Clear Selection
          if (selectionProvider.hasSelection) ...[
            TextButton(
              onPressed: selectionProvider.isAllSelected
                  ? selectionProvider.clearSelection
                  : selectionProvider.selectAll,
              child: Text(
                selectionProvider.isAllSelected ? 'Clear All' : 'Select All',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Add button
            ElevatedButton.icon(
              onPressed: () => _addSelectedFiles(selectionProvider),
              icon: const Icon(Icons.add, size: 18),
              label: Text(
                'Add',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
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

  /// Build file list with selection support
  Widget _buildFileList(
    List<DocumentModel> documents,
    FileSelectionProvider selectionProvider,
  ) {
    if (documents.isEmpty) {
      return _buildEmptyFileList();
    }

    return Container(
      margin: _tableContainerMargin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: sectionSpacing),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with file count
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.folder_open,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Available Files (${documents.length})',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                // File list
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  itemCount: documents.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final document = documents[index];
                    return _buildFileListItem(document, selectionProvider);
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: bottomSpacing),
        ],
      ),
    );
  }

  /// Build individual file list item with selection support
  Widget _buildFileListItem(
    DocumentModel document,
    FileSelectionProvider selectionProvider,
  ) {
    final isSelected = selectionProvider.isFileSelected(document.id);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.border.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            selectionProvider.toggleFileSelection(document.id);
          },
          onLongPress: () {
            if (!selectionProvider.isSelectionMode) {
              selectionProvider.enterSelectionMode(document, [document]);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Selection checkbox
                Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    selectionProvider.toggleFileSelection(document.id);
                  },
                  activeColor: AppColors.primary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),

                const SizedBox(width: 12),

                // File type icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getFileTypeColor(
                          document.fileType,
                        ).withValues(alpha: 0.8),
                        _getFileTypeColor(
                          document.fileType,
                        ).withValues(alpha: 0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: _getFileTypeColor(
                          document.fileType,
                        ).withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      _getFileTypeIcon(document.fileType),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // File info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.fileName,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            _formatFileSize(document.fileSize),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.5,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(document.uploadedAt),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyFileList() {
    return Container(
      padding: _emptyStatePadding,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Shrink to content
        children: [
          Icon(
            Icons.folder_open,
            size: 48,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No available files found',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'All files are already in categories or try adjusting your search',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16), // Bottom spacing
        ],
      ),
    );
  }

  Future<void> _addSelectedFiles(
    FileSelectionProvider selectionProvider,
  ) async {
    if (!selectionProvider.hasSelection) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );

      // Use batch update for better performance
      await documentProvider.updateMultipleDocumentsCategory(
        selectionProvider.selectedFileIds.toList(),
        widget.category.id,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${selectionProvider.selectedCount} file(s) added to ${widget.category.name}',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: AppColors.success,
          ),
        );

        // Clear selection and exit selection mode
        selectionProvider.exitSelectionMode();

        // Navigate back to category files screen with success result
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to add files: $e',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Helper methods for styling and formatting

  IconData _getFileTypeIcon(String fileType) {
    final lowerFileType = fileType.toLowerCase();

    // PDF files
    if (lowerFileType.contains('pdf')) {
      return Icons.picture_as_pdf;
    }

    // Word documents (doc, docx)
    if (lowerFileType.contains('doc') || lowerFileType.contains('word')) {
      return Icons.description;
    }

    // Excel files (xlsx, xls, spreadsheet)
    if (lowerFileType.contains('xlsx') ||
        lowerFileType.contains('xls') ||
        lowerFileType.contains('excel') ||
        lowerFileType.contains('sheet') ||
        lowerFileType.contains('spreadsheet')) {
      return Icons.table_chart;
    }

    // PowerPoint files (ppt, pptx)
    if (lowerFileType.contains('ppt') ||
        lowerFileType.contains('powerpoint') ||
        lowerFileType.contains('presentation')) {
      return Icons.slideshow;
    }

    // Image files (jpg, png, jpeg, gif)
    if (lowerFileType.contains('image') ||
        lowerFileType.contains('jpg') ||
        lowerFileType.contains('jpeg') ||
        lowerFileType.contains('png') ||
        lowerFileType.contains('gif')) {
      return Icons.image;
    }

    // Default file icon
    return Icons.insert_drive_file;
  }

  Color _getFileTypeColor(String fileType) {
    if (fileType.contains('pdf')) return Colors.red;
    if (fileType.contains('word') || fileType.contains('doc')) {
      return Colors.blue;
    }
    if (fileType.contains('excel') || fileType.contains('sheet')) {
      return Colors.green;
    }
    if (fileType.contains('powerpoint') || fileType.contains('presentation')) {
      return Colors.orange;
    }
    if (fileType.contains('image')) return Colors.purple;
    if (fileType.contains('video')) return Colors.pink;
    if (fileType.contains('audio')) return Colors.teal;
    return AppColors.textSecondary;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
