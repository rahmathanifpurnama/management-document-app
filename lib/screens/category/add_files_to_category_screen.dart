import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../../core/constants/app_colors.dart';
import '../../providers/document_provider.dart';
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
  final Set<String> _selectedFiles = <String>{};
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

  // Table header text margins - Customize these for each header text

  static const EdgeInsets _fileNameHeaderMargin = EdgeInsets.only(
    left: 2,
    right: 2,
    top: 4,
    bottom: 4,
  );

  static const EdgeInsets _dateHeaderMargin = EdgeInsets.symmetric(
    horizontal: 2,
    vertical: 4,
  );

  // Internal paddings - Reduced for more compact layout
  static const EdgeInsets _searchSectionPadding = EdgeInsets.all(12);
  static const EdgeInsets _selectedInfoPadding = EdgeInsets.all(12);
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
    // Get documents that are NOT in any category/folder (category is empty)
    var availableDocuments = allDocuments
        .where((doc) => doc.category.isEmpty)
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Add Files to ${widget.category.name}',
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        leading: const IOSBackButton(),
        actions: [
          if (_selectedFiles.isNotEmpty)
            TextButton(
              onPressed: _isLoading ? null : _addSelectedFiles,
              child: Text(
                'Add (${_selectedFiles.length})',
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
          final availableDocuments = _getAvailableDocuments(filteredDocuments);

          return RefreshIndicator(
            onRefresh: _loadData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Search Section
                  _buildSearchSection(),

                  // Filter Section
                  _buildCollapsibleFilterSection(),

                  // Selected Files Info
                  if (_selectedFiles.isNotEmpty) _buildSelectedFilesInfo(),

                  // Files List
                  _buildFileTableWithHeader(availableDocuments),
                ],
              ),
            ),
          );
        },
      ),
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

  Widget _buildSelectedFilesInfo() {
    return Container(
      margin: _selectedInfoMargin,
      padding: _selectedInfoPadding,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${_selectedFiles.length} file(s) selected to add to ${widget.category.name}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedFiles.clear();
              });
            },
            child: Text(
              'Clear',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileTableWithHeader(List<DocumentModel> documents) {
    return Container(
      margin: _tableContainerMargin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: sectionSpacing),
          Container(
            width: double.infinity, // Ensure full width
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Shrink to content
              children: [
                // Table Header - Always shown
                _buildTableHeader(),
                // File List or Empty State
                documents.isEmpty
                    ? _buildEmptyFileList()
                    : _buildFileList(documents),
              ],
            ),
          ),
          SizedBox(height: bottomSpacing),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.border.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(40), // Checkbox space
          1: FlexColumnWidth(4), // Name
          3: FlexColumnWidth(2), // Date
        },
        children: [
          TableRow(
            children: [
              TableCell(
                child: Container(
                  width: 30, // Custom width
                  height: 30, // Custom height
                  alignment: Alignment.center, // Custom alignment
                  margin: EdgeInsets
                      .zero, // Custom margin - menghapus _fileNameHeaderMargin
                  child: Consumer<DocumentProvider>(
                    builder: (context, documentProvider, child) {
                      final availableDocuments = _getAvailableDocuments(
                        documentProvider.documents,
                      );
                      final allSelected =
                          availableDocuments.isNotEmpty &&
                          _selectedFiles.length == availableDocuments.length;

                      return Checkbox(
                        value: allSelected,
                        onChanged: availableDocuments.isEmpty
                            ? null
                            : (value) {
                                setState(() {
                                  if (value == true) {
                                    // Select all available documents
                                    _selectedFiles.clear();
                                    _selectedFiles.addAll(
                                      availableDocuments.map((doc) => doc.id),
                                    );
                                  } else {
                                    // Deselect all
                                    _selectedFiles.clear();
                                  }
                                });
                              },
                        activeColor: AppColors.primary,
                        materialTapTargetSize: MaterialTapTargetSize
                            .shrinkWrap, // Mengurangi tap area
                        visualDensity:
                            VisualDensity.compact, // Mengurangi visual density
                      );
                    },
                  ),
                ),
              ),
              TableCell(
                child: Container(
                  margin: _fileNameHeaderMargin,
                  child: Text('File Name', style: _getTableHeaderStyle()),
                ),
              ),
              TableCell(
                child: Container(
                  margin: _dateHeaderMargin,
                  child: Text(
                    'Date',
                    style: _getTableHeaderStyle(),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ],
          ),
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

  Widget _buildFileList(List<DocumentModel> documents) {
    // Calculate dynamic height based on number of documents
    // Each row is approximately 80px, show 7 items max before scrolling
    final double itemHeight = 80.0;
    final int maxVisibleItems = 7;
    final double maxHeight = maxVisibleItems * itemHeight; // 7 * 80 = 560px
    final double calculatedHeight = documents.length * itemHeight;
    final double containerHeight = calculatedHeight > maxHeight
        ? maxHeight
        : calculatedHeight;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: containerHeight,
            child:
                documents.length >
                    maxVisibleItems // Show scrollbar if more than 7 items
                ? Scrollbar(
                    thumbVisibility: true,
                    trackVisibility: true,
                    thickness: 6.0,
                    radius: const Radius.circular(3.0),
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final document = documents[index];
                        return _buildDocumentRow(document);
                      },
                    ),
                  )
                : ListView.builder(
                    physics:
                        const NeverScrollableScrollPhysics(), // No scroll for 7 or fewer items
                    padding: EdgeInsets.zero,
                    shrinkWrap: true, // Shrink to content size
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final document = documents[index];
                      return _buildDocumentRow(document);
                    },
                  ),
          ),
          const SizedBox(height: 20), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildDocumentRow(DocumentModel document) {
    final isSelected = _selectedFiles.contains(document.id);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.border.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedFiles.remove(document.id);
              } else {
                _selectedFiles.add(document.id);
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Table(
              columnWidths: const {
                0: FixedColumnWidth(40), // Checkbox
                1: FlexColumnWidth(4), // Name
                3: FlexColumnWidth(2), // Date
              },
              children: [
                TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Container(
                        width: 30, // Custom width
                        height: 30, // Custom height
                        alignment: Alignment.center, // Custom alignment
                        child: Checkbox(
                          value: isSelected,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                _selectedFiles.add(document.id);
                              } else {
                                _selectedFiles.remove(document.id);
                              }
                            });
                          },
                          activeColor: AppColors.primary,
                          materialTapTargetSize: MaterialTapTargetSize
                              .shrinkWrap, // Reduce tap area
                          visualDensity:
                              VisualDensity.compact, // Reduce visual density
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Row(
                        children: [
                          // Enhanced file type indicator
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
                            child: Stack(
                              children: [
                                Center(
                                  child: Icon(
                                    _getFileTypeIcon(document.fileType),
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                Positioned(
                                  bottom: 2,
                                  right: 2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      _getFileTypeLabel(document.fileType),
                                      style: GoogleFonts.poppins(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w600,
                                        color: _getFileTypeColor(
                                          document.fileType,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                const SizedBox(height: 2),
                                Text(
                                  _formatFileSize(document.fileSize),
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _formatDate(document.uploadedAt),
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatTime(document.uploadedAt),
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addSelectedFiles() async {
    if (_selectedFiles.isEmpty) return;

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
        _selectedFiles.toList(),
        widget.category.id,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_selectedFiles.length} file(s) added to ${widget.category.name}',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: AppColors.success,
          ),
        );

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
  TextStyle _getTableHeaderStyle() {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    );
  }

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

  String _getFileTypeLabel(String fileType) {
    if (fileType.contains('pdf')) return 'PDF';
    if (fileType.contains('word') || fileType.contains('doc')) return 'Word';
    if (fileType.contains('excel') || fileType.contains('sheet')) {
      return 'Excel';
    }
    if (fileType.contains('powerpoint') || fileType.contains('presentation')) {
      return 'PowerPoint';
    }
    if (fileType.contains('image')) return 'Image';
    if (fileType.contains('video')) return 'Video';
    if (fileType.contains('audio')) return 'Audio';
    return 'File';
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

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
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
