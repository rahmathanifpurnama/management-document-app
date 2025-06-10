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
import '../../widgets/common/reusable_file_list_widget.dart';
import '../../widgets/common/reusable_search_widget.dart';

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
  // Internal paddings - Reduced for more compact layout
  static const EdgeInsets _emptyStatePadding = EdgeInsets.all(24);

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
          ),
          bottomNavigationBar: const AppBottomNavigation(currentIndex: 1),
          body: Consumer<DocumentProvider>(
            builder: (context, documentProvider, child) {
              // Apply DocumentProvider filters first, then get available documents
              final filteredDocuments = documentProvider.documents;
              final availableDocuments = _getAvailableDocuments(
                filteredDocuments,
              );

              // Note: updateAvailableFiles is handled by ReusableFileListWidget
              // to avoid duplicate calls that can cause selection issues

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

                            // Files List using ReusableFileListWidget
                            availableDocuments.isEmpty
                                ? _buildEmptyFileList()
                                : ReusableFileListWidget(
                                    documents: availableDocuments,
                                    title: 'Available Files',
                                    showFilter:
                                        false, // Filter already handled above
                                    showPagination: true,
                                    itemsPerPage: 10,
                                    emptyStateMessage:
                                        'No available files found',
                                    emptyStateIcon: Icons.folder_open,
                                    onDocumentTap:
                                        null, // No tap action needed, only selection
                                    onDocumentMenu:
                                        null, // No menu needed, only selection
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
    return ReusableSearchWidget(
      controller: _searchController,
      hintText: 'Search available files',
      onChanged: (value) => _onSearchChanged(),
      onClear: () {
        _searchController.clear();
        setState(() {
          // Trigger rebuild to clear filter
        });
      },
      margin: _searchSectionMargin,
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
    }
  }
}
