import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
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

              // Ensure available files are updated when entering selection mode
              // This is critical for proper selection functionality
              if (selectionProvider.isSelectionMode) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    selectionProvider.updateAvailableFiles(availableDocuments);
                  }
                });
              }

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

                            // Filter Section (with title and filter button)
                            _buildCollapsibleFilterSection(),

                            // Files List using ReusableFileListWidget
                            availableDocuments.isEmpty
                                ? _buildEmptyFileList()
                                : ReusableFileListWidget(
                                    documents: availableDocuments,
                                    title:
                                        '', // Empty title to avoid duplication
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
                                        _showDocumentMenu, // Enable menu for individual file operations
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
              // Filter Header - with title and filter button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Available Files Title
                    Text(
                      'Available Files',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    // Filter controls
                    Row(
                      children: [
                        // Active filter indicator
                        if (hasActiveFilters) ...[
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
                          const SizedBox(width: 8),
                        ],
                        // Filter button
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isFilterExpanded = !_isFilterExpanded;
                            });
                          },
                          icon: Icon(
                            _isFilterExpanded
                                ? Icons.expand_less
                                : Icons.filter_list,
                            color: hasActiveFilters
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            size: 20,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 24,
                            minHeight: 24,
                          ),
                          tooltip: _isFilterExpanded
                              ? 'Collapse Filter'
                              : 'Filter Files',
                        ),
                      ],
                    ),
                  ],
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

  /// Show document menu for individual file operations
  void _showDocumentMenu(DocumentModel document) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // File info header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getFileTypeColor(
                        document.fileType,
                        document.fileName,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getFileTypeIcon(document.fileType, document.fileName),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          document.fileName,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _formatFileSize(document.fileSize),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Menu options
            ListTile(
              leading: const Icon(Icons.visibility, color: AppColors.primary),
              title: Text(
                'Preview File',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _previewFile(document);
              },
            ),

            ListTile(
              leading: const Icon(Icons.info_outline, color: AppColors.primary),
              title: Text(
                'File Details',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showFileDetails(document);
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// Preview file
  void _previewFile(DocumentModel document) {
    Navigator.of(context).pushNamed(AppRoutes.filePreview, arguments: document);
  }

  /// Show file details
  void _showFileDetails(DocumentModel document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'File Details',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Name', document.fileName),
            _buildDetailRow('Size', _formatFileSize(document.fileSize)),
            _buildDetailRow('Type', document.fileType),
            _buildDetailRow('Uploaded', _formatDate(document.uploadedAt)),
            if (document.metadata.description.isNotEmpty)
              _buildDetailRow('Description', document.metadata.description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Get file type color (helper method)
  Color _getFileTypeColor(String fileType, [String? fileName]) {
    final lowerFileType = fileType.toLowerCase();

    String? fileExtension;
    if (fileName != null && fileName.contains('.')) {
      fileExtension = fileName.split('.').last.toLowerCase();
    }

    if (lowerFileType == 'pdf' ||
        lowerFileType.contains('pdf') ||
        fileExtension == 'pdf') {
      return Colors.red;
    } else if (lowerFileType == 'doc' ||
        lowerFileType == 'docx' ||
        lowerFileType.contains('word') ||
        lowerFileType.contains('doc')) {
      return Colors.blue;
    } else if (lowerFileType == 'xls' ||
        lowerFileType == 'xlsx' ||
        lowerFileType.contains('excel') ||
        lowerFileType.contains('sheet')) {
      return Colors.green;
    } else if (lowerFileType == 'ppt' ||
        lowerFileType == 'pptx' ||
        lowerFileType.contains('powerpoint') ||
        lowerFileType.contains('presentation')) {
      return Colors.orange;
    } else if (lowerFileType == 'jpg' ||
        lowerFileType == 'jpeg' ||
        lowerFileType == 'png' ||
        lowerFileType == 'gif' ||
        lowerFileType.contains('image') ||
        fileExtension == 'jpg' ||
        fileExtension == 'jpeg' ||
        fileExtension == 'png' ||
        fileExtension == 'gif') {
      return Colors.purple;
    } else if (lowerFileType == 'mp4' ||
        lowerFileType == 'avi' ||
        lowerFileType == 'mov' ||
        lowerFileType.contains('video')) {
      return Colors.indigo;
    } else if (lowerFileType == 'mp3' ||
        lowerFileType == 'wav' ||
        lowerFileType.contains('audio')) {
      return Colors.teal;
    } else {
      return AppColors.textSecondary;
    }
  }

  /// Get file type icon (helper method)
  IconData _getFileTypeIcon(String fileType, [String? fileName]) {
    final lowerFileType = fileType.toLowerCase();

    String? fileExtension;
    if (fileName != null && fileName.contains('.')) {
      fileExtension = fileName.split('.').last.toLowerCase();
    }

    if (lowerFileType == 'pdf' ||
        lowerFileType.contains('pdf') ||
        fileExtension == 'pdf') {
      return Icons.picture_as_pdf;
    } else if (lowerFileType == 'doc' ||
        lowerFileType == 'docx' ||
        lowerFileType.contains('word') ||
        lowerFileType.contains('doc')) {
      return Icons.description;
    } else if (lowerFileType == 'xls' ||
        lowerFileType == 'xlsx' ||
        lowerFileType.contains('excel') ||
        lowerFileType.contains('sheet')) {
      return Icons.table_chart;
    } else if (lowerFileType == 'ppt' ||
        lowerFileType == 'pptx' ||
        lowerFileType.contains('powerpoint') ||
        lowerFileType.contains('presentation')) {
      return Icons.slideshow;
    } else if (lowerFileType == 'jpg' ||
        lowerFileType == 'jpeg' ||
        lowerFileType == 'png' ||
        lowerFileType == 'gif' ||
        lowerFileType.contains('image') ||
        fileExtension == 'jpg' ||
        fileExtension == 'jpeg' ||
        fileExtension == 'png' ||
        fileExtension == 'gif') {
      return Icons.image;
    } else if (lowerFileType == 'mp4' ||
        lowerFileType == 'avi' ||
        lowerFileType == 'mov' ||
        lowerFileType.contains('video')) {
      return Icons.videocam;
    } else if (lowerFileType == 'mp3' ||
        lowerFileType == 'wav' ||
        lowerFileType.contains('audio')) {
      return Icons.audiotrack;
    } else {
      return Icons.insert_drive_file;
    }
  }

  /// Format file size (helper method)
  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '${bytes}B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)}KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
    }
  }

  /// Format date (helper method)
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
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }
}
