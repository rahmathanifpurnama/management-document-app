import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';

import '../../providers/file_selection_provider.dart';
import '../../providers/document_provider.dart';
import '../../models/category_model.dart';
import '../../models/document_model.dart';
import '../../widgets/common/app_bottom_navigation.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/ios_back_button.dart';
import '../../widgets/common/reusable_file_list_widget.dart';
import '../../widgets/category/add_only_selection_bar_widget.dart';
import '../../widgets/category/available_files_empty_state_widget.dart';
import '../../widgets/common/file_filter_widget.dart';
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
  bool _isLoadingDocuments = false;

  // ========== MARGIN CONFIGURATION - Easy to adjust ==========
  // Section margins - Reduced to bring content closer to navbar
  static const EdgeInsets _searchSectionMargin = EdgeInsets.fromLTRB(
    16,
    15,
    16,
    12,
  );

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
    setState(() {
      _isLoadingDocuments = true;
    });

    try {
      // FIXED: Use DocumentProvider instead of UnifiedDocumentLoader to avoid permission issues
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );

      // Load documents from DocumentProvider (which has better error handling)
      await documentProvider.loadDocuments(forceRefresh: true);

      debugPrint(
        '✅ Successfully loaded documents for Add Files screen via DocumentProvider',
      );
    } catch (e) {
      debugPrint('❌ Failed to load documents: $e');

      // FALLBACK: Try to use existing cached data if available
      if (mounted) {
        try {
          final documentProvider = Provider.of<DocumentProvider>(
            context,
            listen: false,
          );
          if (documentProvider.documents.isNotEmpty) {
            debugPrint('📋 Using cached documents as fallback');
            return; // Use cached data
          }
        } catch (cacheError) {
          debugPrint('❌ Cache fallback also failed: $cacheError');
        }
      }

      // Show user-friendly error message only if no cached data available
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to load available files. Please check your connection.',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: AppColors.error,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _loadData(),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingDocuments = false;
        });
      }
    }
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

  List<DocumentModel> _getAvailableDocuments() {
    // FIXED: Use DocumentProvider instead of UnifiedDocumentLoader to avoid permission issues
    final documentProvider = Provider.of<DocumentProvider>(
      context,
      listen: false,
    );
    final searchQuery = _searchController.text.toLowerCase().trim();

    // Get all documents from DocumentProvider
    var availableDocuments = documentProvider.documents.where((doc) {
      // Filter out files that are already in the target category
      if (doc.category == widget.category.id) {
        return false;
      }

      // FIXED: Updated filter logic after uncategorized folder deletion
      // Show files that are available to be categorized (not already in a specific category)
      final category = doc.category.trim().toLowerCase();
      final isAvailableForCategorization =
          category.isEmpty ||
          category == 'uncategorized' ||
          category == 'general' ||
          category == 'null';

      return isAvailableForCategorization;
    }).toList();

    // Apply search filter if provided
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

    // Sort by upload date (newest first) for better UX
    availableDocuments.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));

    // ENHANCED DEBUG: Show category breakdown for troubleshooting
    final categoryBreakdown = <String, int>{};
    for (final doc in documentProvider.documents) {
      final category = doc.category.trim().toLowerCase();
      final displayCategory = category.isEmpty ? 'empty' : category;
      categoryBreakdown[displayCategory] =
          (categoryBreakdown[displayCategory] ?? 0) + 1;
    }

    debugPrint(
      'AddFilesToCategory: Available documents: ${availableDocuments.length} (search: "$searchQuery", target: ${widget.category.id})',
    );
    debugPrint('📊 Category breakdown: $categoryBreakdown');
    debugPrint(
      '📋 Total documents in provider: ${documentProvider.documents.length}',
    );

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
          body: Consumer2<FileSelectionProvider, DocumentProvider>(
            builder: (context, selectionProvider, documentProvider, child) {
              // FIXED: Get available documents from DocumentProvider
              final availableDocuments = _getAvailableDocuments();

              // Show loading state if documents are being loaded
              if ((_isLoadingDocuments || documentProvider.isLoading) &&
                  availableDocuments.isEmpty) {
                return Column(
                  children: [
                    // Custom selection bar for add-only functionality
                    AddOnlySelectionBarWidget(
                      selectionProvider: selectionProvider,
                      onAdd: () => _addSelectedFiles(selectionProvider),
                    ),
                    Expanded(child: _buildLoadingState()),
                  ],
                );
              }

              // Don't call updateAvailableFiles here to prevent race conditions
              // The available files are properly set when entering selection mode
              // This prevents the "removing invalid selections" issue

              return Column(
                children: [
                  // Custom selection bar for add-only functionality
                  AddOnlySelectionBarWidget(
                    selectionProvider: selectionProvider,
                    onAdd: () => _addSelectedFiles(selectionProvider),
                  ),

                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _loadData,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            // Search Section
                            _buildSearchSection(),

                            // Filter Section (consistent with home screen)
                            _buildFilterSection(),

                            // Files List with proper loading states
                            (_isLoadingDocuments || documentProvider.isLoading)
                                ? _buildLoadingState()
                                : availableDocuments.isEmpty
                                ? const AvailableFilesEmptyStateWidget()
                                : ReusableFileListWidget(
                                    documents: availableDocuments,
                                    title:
                                        '', // Empty title to avoid duplication
                                    showFilter:
                                        false, // Filter already handled above
                                    showPagination: true,
                                    itemsPerPage:
                                        25, // STANDARDIZED: 25 items per page across all screens
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

  /// Build filter section consistent with home screen (no animations)
  Widget _buildFilterSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Available Files',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          IconButton(
            onPressed: _showFilterMenu,
            icon: const Icon(
              Icons.filter_list,
              color: AppColors.textSecondary,
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            tooltip: 'Filter Files',
          ),
        ],
      ),
    );
  }

  /// Show filter menu (identical to home screen)
  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => FileFilterWidget(
        onFilterApplied: () {
          setState(() {
            // Trigger rebuild to apply filters
          });
        },
      ),
    );
  }

  /// Build loading state widget
  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Loading available files...',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait while we fetch the latest files',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addSelectedFiles(
    FileSelectionProvider selectionProvider,
  ) async {
    if (!selectionProvider.hasSelection) return;

    // Show loading indicator
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Adding ${selectionProvider.selectedCount} file(s)...',
                style: GoogleFonts.poppins(),
              ),
            ],
          ),
          backgroundColor: AppColors.primary,
          duration: const Duration(seconds: 10),
        ),
      );
    }

    try {
      // FIXED: Use DocumentProvider directly for reliable updates
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );
      final selectedFiles = selectionProvider.selectedFiles;

      for (final file in selectedFiles) {
        await documentProvider.updateDocumentCategory(
          file.id,
          widget.category.id,
        );
      }

      // Force refresh to ensure UI consistency
      await documentProvider.loadDocuments(forceRefresh: true);

      if (mounted) {
        // Hide loading indicator
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${selectedFiles.length} file(s) added to ${widget.category.name}',
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
        // Hide loading indicator
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to add files: $e',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: AppColors.error,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _addSelectedFiles(selectionProvider),
            ),
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
