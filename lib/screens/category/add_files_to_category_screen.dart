import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../../utils/date_formatter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';

import '../../features/file_selection/providers/file_selection_providers.dart';
import '../../features/documents/bloc/document_bloc.dart';
import '../../features/documents/bloc/document_event.dart';
import '../../features/documents/bloc/document_state.dart';
import '../../models/category_model.dart';
import '../../models/document_model.dart';
import '../../widgets/common/app_bottom_navigation.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/ios_back_button.dart';
import '../../widgets/common/reusable_file_list_widget.dart';

import '../../widgets/category/available_files_empty_state_widget.dart';
import '../../widgets/category/add_only_selection_bar_widget.dart';
import '../../widgets/common/file_filter_widget.dart';
import '../../widgets/common/reusable_search_widget.dart';
import '../../core/utils/context_filter_utils.dart';

class AddFilesToCategoryScreen extends ConsumerStatefulWidget {
  final CategoryModel category;

  const AddFilesToCategoryScreen({super.key, required this.category});

  @override
  ConsumerState<AddFilesToCategoryScreen> createState() =>
      _AddFilesToCategoryScreenState();
}

class _AddFilesToCategoryScreenState
    extends ConsumerState<AddFilesToCategoryScreen> {
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

    // DIAGNOSTIC: Uncomment the line below to run file path diagnostic on screen load
    // _runDiagnostic();
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
      // Use DocumentBloc to load documents
      debugPrint('🔄 Loading documents via DocumentBloc');

      // Load all documents to ensure we have fresh data
      context.read<DocumentBloc>().add(
        const DocumentEvent.loadDocuments(forceRefresh: true),
      );

      debugPrint(
        '✅ Successfully triggered document loading for Add Files screen via DocumentBloc',
      );
    } catch (e) {
      debugPrint('❌ Failed to load documents: $e');

      // Show user-friendly error message
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

  List<DocumentModel> _getAvailableDocuments(List<DocumentModel> allDocuments) {
    final searchQuery = _searchController.text.toLowerCase().trim();

    // Get add files filter state for additional filtering
    final addFilesFilterState = FilterStateManager.getState(
      FilterContext.addFiles,
    );

    // Update search query in filter state
    if (addFilesFilterState.searchQuery != searchQuery) {
      addFilesFilterState.searchQuery = searchQuery;
    }

    // Get all documents from BLoC state
    var availableDocuments = allDocuments.where((doc) {
      // DEFINITIVE FIX: Simple and robust filtering logic
      // Since DocumentProvider now loads documents with correct categories from Firestore,
      // we can rely on the category data being accurate

      // PRIMARY FILTER: Exclude files already in the target category
      if (doc.category == widget.category.id ||
          doc.category.toLowerCase() == widget.category.id.toLowerCase()) {
        debugPrint(
          '🚫 DEFINITIVE: Excluding file in target category: ${doc.fileName} (${doc.category})',
        );
        return false;
      }

      // DEFINITIVE FILTER: Exclude files that are in ANY specific category
      // With the Storage-Firestore merge, category data is now reliable
      final category = doc.category.trim();
      if (category.isNotEmpty &&
          category.toLowerCase() != 'general' &&
          category.toLowerCase() != 'null' &&
          category.toLowerCase() != 'uncategorized') {
        debugPrint(
          '🚫 DEFINITIVE: Excluding categorized file: ${doc.fileName} (${doc.category})',
        );
        return false;
      }

      // Show only truly uncategorized files
      final normalizedCategory = category.toLowerCase();
      final isAvailable =
          category.isEmpty ||
          normalizedCategory == 'general' ||
          normalizedCategory == 'null' ||
          normalizedCategory == 'uncategorized';

      if (isAvailable) {
        debugPrint(
          '✅ DEFINITIVE: Including available file: ${doc.fileName} (category: "${doc.category}")',
        );
      }

      return isAvailable;
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

    // Apply additional context-aware filtering (file type filter)
    if (addFilesFilterState.selectedFileType != 'all') {
      availableDocuments = availableDocuments.where((document) {
        return ContextFilterUtils.applyContextFilters(
          documents: [document],
          context: FilterContext.addFiles,
          filterState: addFilesFilterState,
          categoryId: widget.category.id,
        ).isNotEmpty;
      }).toList();
    }

    // Apply context-aware sorting
    availableDocuments.sort((a, b) {
      int comparison = 0;

      switch (addFilesFilterState.sortBy) {
        case 'fileName':
          comparison = a.fileName.compareTo(b.fileName);
          break;
        case 'fileSize':
          comparison = a.fileSize.compareTo(b.fileSize);
          break;
        case 'uploadedAt':
          comparison = a.uploadedAt.compareTo(b.uploadedAt);
          break;
        default:
          // Default: newest first for better UX
          comparison = b.uploadedAt.compareTo(a.uploadedAt);
      }

      return addFilesFilterState.sortAscending ? comparison : -comparison;
    });

    // ENHANCED DEBUG: Show detailed category breakdown for troubleshooting
    final categoryBreakdown = <String, int>{};
    final targetCategoryFiles = <String>[];
    final categorizedFiles = <String>[];
    final uncategorizedFiles = <String>[];

    for (final doc in allDocuments) {
      final category = doc.category.trim();
      final displayCategory = category.isEmpty ? 'empty' : category;
      categoryBreakdown[displayCategory] =
          (categoryBreakdown[displayCategory] ?? 0) + 1;

      // Track files by category type for detailed debugging
      if (category == widget.category.id) {
        targetCategoryFiles.add(doc.fileName);
      } else if (category.isNotEmpty &&
          category.toLowerCase() != 'general' &&
          category.toLowerCase() != 'null' &&
          category.toLowerCase() != 'uncategorized') {
        categorizedFiles.add('${doc.fileName} ($category)');
      } else {
        uncategorizedFiles.add(doc.fileName);
      }
    }

    debugPrint('🔍 AddFilesToCategory DEBUG REPORT:');
    debugPrint('   Target Category: ${widget.category.id}');
    debugPrint('   Available documents: ${availableDocuments.length}');
    debugPrint('   Total documents in BLoC: ${allDocuments.length}');
    debugPrint('   Search query: "$searchQuery"');
    debugPrint('📊 Category breakdown: $categoryBreakdown');
    debugPrint(
      '🎯 Files in target category (${targetCategoryFiles.length}): ${targetCategoryFiles.take(3).join(", ")}${targetCategoryFiles.length > 3 ? "..." : ""}',
    );
    debugPrint(
      '📁 Files in other categories (${categorizedFiles.length}): ${categorizedFiles.take(3).join(", ")}${categorizedFiles.length > 3 ? "..." : ""}',
    );
    debugPrint(
      '📂 Uncategorized files (${uncategorizedFiles.length}): ${uncategorizedFiles.take(3).join(", ")}${uncategorizedFiles.length > 3 ? "..." : ""}',
    );

    return availableDocuments;
  }

  @override
  Widget build(BuildContext context) {
    // Use isolated file selection for this screen
    final screenId = 'AddFilesToCategoryScreen';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Add Files to ${widget.category.name}',
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        leading: const IOSBackButton(),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 1),
      body: BlocBuilder<DocumentBloc, DocumentState>(
        builder: (context, documentState) {
          // Get all documents from BLoC state
          final allDocuments = documentState.maybeMap(
            loaded: (state) => state.documents,
            orElse: () => <DocumentModel>[],
          );

          // Get available documents using BLoC data
          final availableDocuments = _getAvailableDocuments(allDocuments);

          // Show loading state if documents are being loaded
          final isLoading = documentState.maybeMap(
            loading: (_) => true,
            orElse: () => false,
          );

          if ((_isLoadingDocuments || isLoading) &&
              availableDocuments.isEmpty) {
            return Column(
              children: [
                // Custom selection bar for add-only functionality
                AddOnlySelectionBarWidget(
                  screenId: screenId,
                  onAdd: () => _addSelectedFiles(),
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
                screenId: screenId,
                onAdd: () => _addSelectedFiles(),
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
                        (_isLoadingDocuments || isLoading)
                            ? _buildLoadingState()
                            : availableDocuments.isEmpty
                            ? const AvailableFilesEmptyStateWidget()
                            : ReusableFileListWidget(
                                documents: availableDocuments,
                                title: '', // Empty title to avoid duplication
                                showFilter:
                                    false, // Filter already handled above
                                showPagination: true,
                                itemsPerPage:
                                    25, // STANDARDIZED: 25 items per page across all screens
                                emptyStateMessage: 'No available files found',
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

  /// Show filter menu for add files context
  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => FileFilterWidget.forAddFiles(
        categoryId: widget.category.id,
        onFilterApplied: () {
          setState(() {
            // Trigger rebuild to apply context-aware filters
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

  Future<void> _addSelectedFiles() async {
    final screenId = 'AddFilesToCategoryScreen';
    final state = ref.read(isolatedFileSelectionProvider(screenId));
    final actions = ref.read(isolatedFileSelectionActionsProvider(screenId));

    if (state.selectedFileIds.isEmpty) return;

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
                'Adding ${state.selectedFileIds.length} file(s)...',
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
      final selectedFiles = state.availableFiles
          .where((file) => state.selectedFileIds.contains(file.id))
          .toList();

      // RACE CONDITION FIX: Process files sequentially to avoid conflicts
      for (final file in selectedFiles) {
        // Use DocumentBloc to update document category
        final updatedDocument = file.copyWith(category: widget.category.id);
        context.read<DocumentBloc>().add(
          DocumentEvent.updateDocument(document: updatedDocument),
        );

        debugPrint(
          '✅ File ${file.fileName} assigned to category ${widget.category.id}',
        );
      }

      // RACE CONDITION FIX: Wait a moment to ensure all async operations complete
      await Future.delayed(const Duration(milliseconds: 100));

      // FIXED: No force refresh needed - local cache is already updated by updateDocumentCategory
      // Force refresh was causing race condition and overriding local changes
      debugPrint('✅ Category assignment completed without force refresh');

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
        actions.exitSelectionMode();

        // Navigate back to category files screen with success result
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        // Hide loading indicator
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        // Enhanced error message with more context
        String errorMessage = 'Failed to add files to ${widget.category.name}';
        String detailedError = e.toString();

        // Extract more user-friendly error messages
        if (detailedError.contains('File not found in Firebase Storage')) {
          errorMessage =
              'Some files could not be found in storage. They may have been moved or deleted.';
        } else if (detailedError.contains('Document not found in database')) {
          errorMessage =
              'File information not found in database. Please refresh and try again.';
        } else if (detailedError.contains('Category not found')) {
          errorMessage =
              'Target category not found. Please refresh and try again.';
        } else if (detailedError.contains('Failed to get file metadata')) {
          errorMessage =
              'Unable to access file information. Please check your connection and try again.';
        }

        debugPrint('❌ Add files error details: $detailedError');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  errorMessage,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  'Check the debug console for detailed error information.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 8),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _addSelectedFiles(),
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

  /// Format date for detail dialogs
  String _formatDate(DateTime date) {
    return DateFormatter.formatAbsoluteForDetails(date);
  }
}
