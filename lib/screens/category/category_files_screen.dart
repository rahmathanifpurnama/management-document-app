import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../../utils/date_formatter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../providers/document_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/category_model.dart';
import '../../models/document_model.dart';
import '../../widgets/common/custom_app_bar.dart';

import '../../services/file_download_service.dart';
import '../../services/share_service.dart';
import '../../widgets/common/ios_back_button.dart';
import '../../core/utils/context_filter_utils.dart';
import '../../widgets/common/reusable_file_list_widget.dart';
import '../../widgets/common/reusable_file_grid_widget.dart';
import '../../widgets/common/file_filter_widget.dart';
import '../../widgets/common/file_selection_bar.dart';
import '../../widgets/common/isolated_file_selection_provider.dart';
import '../../widgets/category/category_info_header_widget.dart';
import '../../widgets/category/category_empty_state_widget.dart';
import '../../widgets/category/no_search_results_widget.dart';
import '../../widgets/category/document_menu_widget.dart';
import '../../widgets/category/view_mode_toggle_widget.dart';

class CategoryFilesScreen extends StatefulWidget {
  final CategoryModel category;

  const CategoryFilesScreen({super.key, required this.category});

  @override
  State<CategoryFilesScreen> createState() => _CategoryFilesScreenState();
}

class _CategoryFilesScreenState extends State<CategoryFilesScreen> {
  ViewMode _currentViewMode = ViewMode.list; // Restore original default
  final TextEditingController _searchController = TextEditingController();
  final ShareService _shareService = ShareService();
  String _searchQuery = '';
  bool _isRefreshing = false; // Add refresh state

  @override
  void initState() {
    super.initState();
    _initializeCategory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initializeCategory() {
    // Initialize empty category in DocumentProvider if it doesn't exist
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );

      debugPrint(
        '📁 Category screen: Initializing category ${widget.category.id}',
      );
      documentProvider.initializeCategory(widget.category.id);

      // Always try to load documents from Firebase to ensure fresh data
      debugPrint('📁 Category screen: Loading documents...');
      await documentProvider.loadDocuments();

      // If category is still empty, try async Firebase query
      final categoryDocuments = documentProvider.getDocumentsByCategory(
        widget.category.id,
      );
      if (categoryDocuments.isEmpty) {
        debugPrint(
          '🔄 Category ${widget.category.id} is empty, trying Firebase query...',
        );
        await documentProvider.getDocumentsByCategoryAsync(widget.category.id);
      }

      debugPrint('📁 Category screen: Initialization completed');
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: FileFilterWidget.forCategory(
          categoryId: widget.category.id,
          onFilterApplied: () {
            Navigator.pop(context);
            setState(() {
              // Trigger rebuild to apply context-aware filters
            });
          },
        ),
      ),
    );
  }

  /// Handle exit from selection mode - refresh UI without re-fetching data
  void _onExitSelectionMode() {
    try {
      // Only trigger UI refresh using existing cached data
      // No need to re-fetch from server as data hasn't changed
      if (mounted) {
        // Use a brief delay to ensure smooth transition
        Future.microtask(() {
          if (mounted) {
            setState(() {
              // This will rebuild the UI with current cached data
              // The DocumentProvider already has the files in memory
            });
          }
        });
      }
    } catch (e) {
      // Handle any potential errors gracefully
      debugPrint('Error during selection mode exit: $e');
      // Even if there's an error, ensure UI is refreshed
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IsolatedFileSelectionProvider(
      screenId: 'CategoryFilesScreen',
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.category.name,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textWhite,
          leading: const IOSBackButton(),
          actions: [
            ViewModeToggleWidget(
              currentMode: _currentViewMode,
              onModeChanged: (mode) {
                setState(() {
                  _currentViewMode = mode;
                });
              },
              iconColor: AppColors.textWhite,
            ),
          ],
        ),
        body: Column(
          children: [
            // File selection bar (appears when files are selected)
            FileSelectionBar(
              onExitSelection: _onExitSelectionMode,
              categoryId: widget.category.id,
            ),
            // Main content
            Expanded(
              child: Consumer<DocumentProvider>(
                builder: (context, documentProvider, child) {
                  // Get category filter state
                  final categoryFilterState = FilterStateManager.getState(
                    FilterContext.categoryFiles,
                  );

                  // Update search query in filter state if different
                  if (categoryFilterState.searchQuery != _searchQuery) {
                    categoryFilterState.searchQuery = _searchQuery;
                  }

                  // Get all category documents first
                  final allCategoryDocuments = documentProvider
                      .getDocumentsByCategory(widget.category.id);

                  // Apply context-aware filtering to category documents only
                  final filteredDocuments =
                      ContextFilterUtils.applyContextFilters(
                        documents: allCategoryDocuments,
                        context: FilterContext.categoryFiles,
                        filterState: categoryFilterState,
                        categoryId: widget.category.id,
                      );

                  debugPrint('🔍 CategoryFilesScreen Filtering Debug:');
                  debugPrint(
                    '   Category documents: ${allCategoryDocuments.length}',
                  );
                  debugPrint(
                    '   Filtered documents: ${filteredDocuments.length}',
                  );
                  debugPrint(
                    '   Search query: "${categoryFilterState.searchQuery}"',
                  );
                  debugPrint(
                    '   Selected file type: "${categoryFilterState.selectedFileType}"',
                  );

                  // IMPROVED: Better loading and empty state logic
                  final isInitialLoading =
                      documentProvider.isLoading &&
                      allCategoryDocuments.isEmpty;
                  final isCategoryLoading = _isRefreshing;

                  debugPrint('🔍 CategoryFilesScreen Consumer rebuild:');
                  debugPrint('   Category ID: ${widget.category.id}');
                  debugPrint(
                    '   Documents found: ${allCategoryDocuments.length}',
                  );
                  debugPrint(
                    '   Provider loading: ${documentProvider.isLoading}',
                  );
                  debugPrint('   Is refreshing: $_isRefreshing');
                  debugPrint('   Initial loading: $isInitialLoading');

                  // Show empty state only if no documents exist and not loading
                  if (allCategoryDocuments.isEmpty &&
                      !isInitialLoading &&
                      !isCategoryLoading) {
                    debugPrint('📭 Showing empty state widget');
                    return CategoryEmptyStateWidget(
                      categoryName: widget.category.name,
                      onAddExisting: () => _navigateToAddFiles(),
                      onUploadNew: () => _navigateToUpload(),
                    );
                  }

                  debugPrint(
                    '📋 Showing file list with ${allCategoryDocuments.length} documents',
                  );

                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _isRefreshing = true;
                      });

                      try {
                        final documentProvider = Provider.of<DocumentProvider>(
                          context,
                          listen: false,
                        );

                        // Force refresh folder contents from Firebase
                        await documentProvider.refreshFolderContents();

                        // Also try async Firebase query for this specific category
                        await documentProvider.getDocumentsByCategoryAsync(
                          widget.category.id,
                        );

                        debugPrint(
                          '🔄 Refreshed category ${widget.category.id} from Firebase',
                        );
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isRefreshing = false;
                          });
                        }
                      }
                    },
                    color: AppColors.primary,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          // Category Info Header
                          CategoryInfoHeaderWidget(
                            category: widget.category,
                            fileCount: allCategoryDocuments.length,
                            onAddExisting: () => _navigateToAddFiles(),
                            onUploadNew: () => _navigateToUpload(),
                          ),
                          // Search Widget
                          _buildSearchWidget(),
                          // Files List with Dynamic Loading Logic
                          _buildFileListSection(
                            allCategoryDocuments,
                            filteredDocuments,
                            documentProvider,
                          ),
                          // Add bottom spacing for better UX
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchWidget() {
    return _CategorySearchSection(
      searchController: _searchController,
      onSearchChanged: () => _onSearchChanged(_searchController.text),
    );
  }

  /// Build dynamic file list section with loading states
  Widget _buildFileListSection(
    List<DocumentModel> allCategoryDocuments,
    List<DocumentModel> filteredDocuments,
    DocumentProvider documentProvider,
  ) {
    // IMPROVED: Better loading state logic
    final isInitialLoading =
        documentProvider.isLoading && allCategoryDocuments.isEmpty;
    final isCategoryLoading = _isRefreshing;

    // Show loading state during refresh or initial loading
    if (isCategoryLoading || isInitialLoading) {
      debugPrint('📱 FileListSection: Showing loading widget');
      return _buildLoadingWidget();
    }

    // Show search results or file list
    if (filteredDocuments.isEmpty && _searchQuery.isNotEmpty) {
      debugPrint('🔍 FileListSection: Showing no search results');
      return NoSearchResultsWidget(searchQuery: _searchQuery);
    }

    if (filteredDocuments.isEmpty) {
      debugPrint('📭 FileListSection: Showing empty state');
      return CategoryEmptyStateWidget(
        categoryName: widget.category.name,
        onAddExisting: () => _navigateToAddFiles(),
        onUploadNew: () => _navigateToUpload(),
      );
    }

    debugPrint('📋 FileListSection: Showing ${filteredDocuments.length} files');

    // Show files in selected view mode
    return _currentViewMode == ViewMode.list
        ? ReusableFileListWidget(
            documents: filteredDocuments,
            title: widget.category.name,
            onDocumentTap: _navigateToFilePreview,
            onDocumentMenu: _showDocumentMenu,
            onFilterTap: _showFilterMenu,
            showFilter: true,
            showPagination: true,
            itemsPerPage: 25,
            emptyStateMessage: 'No files in this category',
            emptyStateIcon: Icons.folder_open,
            categoryId: widget.category.id,
          )
        : ReusableFileGridWidget(
            documents: filteredDocuments,
            title: widget.category.name,
            onDocumentTap: _navigateToFilePreview,
            onDocumentMenu: _showDocumentMenu,
            onFilterTap: _showFilterMenu,
            showFilter: true,
            showPagination: true,
            itemsPerPage: 25,
            emptyStateMessage: 'No files in this category',
            emptyStateIcon: Icons.folder_open,
            categoryId: widget.category.id,
          );
  }

  /// Build loading widget for file list section only
  Widget _buildLoadingWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
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
              'Loading files...',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait while we fetch your documents',
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

  void _showDocumentMenu(DocumentModel document) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => DocumentMenuWidget(
        document: document,
        categoryName: widget.category.name,
        onDownload: () {
          Navigator.pop(context);
          _downloadFile(document);
        },
        onShare: () {
          Navigator.pop(context);
          _shareDocument(document);
        },
        onDetails: () {
          Navigator.pop(context);
          _showDocumentDetails(document);
        },
        onRemoveFromFolder: () {
          Navigator.pop(context);
          _showRemoveFileDialog(document);
        },
        onDelete: _isCurrentUserAdmin()
            ? () {
                Navigator.pop(context);
                _showDeleteConfirmation(document);
              }
            : null,
      ),
    );
  }

  void _showRemoveFileDialog(DocumentModel document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Remove File',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to remove "${document.fileName}" from this folder?\n\nThe file will still exist in other locations.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _removeFileFromCategory(document);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Remove',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _removeFileFromCategory(DocumentModel document) async {
    try {
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );

      // Remove document from this category (make it available for categorization)
      await documentProvider.updateDocumentCategory(
        document.id,
        '', // Empty string makes file available for categorization
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${document.fileName} removed from ${widget.category.name}',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: AppColors.success,
          ),
        );

        // Navigate back to add files screen to continue adding more files
        final result = await Navigator.of(
          context,
        ).pushNamed(AppRoutes.addFilesToCategory, arguments: widget.category);

        // Refresh the current screen if files were added
        if (result == true) {
          setState(() {});
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to remove file: $e',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _navigateToFilePreview(DocumentModel document) {
    Navigator.of(context).pushNamed(AppRoutes.filePreview, arguments: document);
  }

  Future<void> _navigateToAddFiles() async {
    final result = await Navigator.of(
      context,
    ).pushNamed(AppRoutes.addFilesToCategory, arguments: widget.category);

    // FIXED: Smart refresh - only refresh if needed, don't override local changes
    if (mounted && result == true) {
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );

      // Check if category has files in local cache
      final localCategoryFiles = documentProvider.getDocumentsByCategory(
        widget.category.id,
      );

      debugPrint('📊 Local category files count: ${localCategoryFiles.length}');

      // Only refresh from Firebase if local cache is empty (which shouldn't happen now)
      if (localCategoryFiles.isEmpty) {
        debugPrint('⚠️ Local cache empty, refreshing from Firebase...');
        await documentProvider.getDocumentsByCategoryAsync(widget.category.id);
      } else {
        debugPrint('✅ Local cache has files, no refresh needed');
      }

      // Trigger UI rebuild to reflect any changes
      setState(() {});

      debugPrint('✅ Category files screen updated after adding files');
    }
  }

  void _navigateToUpload() {
    Navigator.of(
      context,
    ).pushNamed(AppRoutes.uploadDocument, arguments: widget.category.id);
  }

  // Helper method for date formatting in detail dialogs
  String _formatDate(DateTime date) {
    return DateFormatter.formatAbsoluteForDetails(date);
  }

  // Helper method for file size formatting
  String _formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = 0;
    double size = bytes.toDouble();
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    return '${size.toStringAsFixed(size < 10 ? 1 : 0)} ${suffixes[i]}';
  }

  void _showDocumentDetails(DocumentModel document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Document Details',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Name', document.fileName),
            _buildDetailRow('Size', _formatFileSize(document.fileSize)),
            _buildDetailRow('Type', document.fileType),
            _buildDetailRow('Uploaded', _formatDate(document.uploadedAt)),
            _buildDetailRow('Status', 'ACTIVE'),
            if (document.metadata.description.isNotEmpty)
              _buildDetailRow('Description', document.metadata.description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.poppins()),
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
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(DocumentModel document) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Delete File Permanently',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to permanently delete "${document.fileName}"? This action cannot be undone and the file will be removed from all locations.',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteFile(document);
              },
              child: Text(
                'Delete Permanently',
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Check if current user is admin
  bool _isCurrentUserAdmin() {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentUser = authProvider.currentUser;
      return currentUser?.isAdmin ?? false;
    } catch (e) {
      debugPrint('⚠️ Error checking admin status: $e');
      return false;
    }
  }

  Future<void> _deleteFile(DocumentModel document) async {
    try {
      // ADMIN-ONLY: Double-check admin status before deletion
      if (!_isCurrentUserAdmin()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Access denied: Only administrators can delete files',
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      // Show loading indicator
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
              Text('Deleting ${document.fileName}...'),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      // Get current user ID for logging
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentUserId = authProvider.currentUser?.id ?? 'unknown';

      // Get document provider and remove the document permanently
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );
      await documentProvider.removeDocument(document.id, currentUserId);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${document.fileName} deleted permanently from storage',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete file: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Share document using ShareService
  Future<void> _shareDocument(DocumentModel document) async {
    try {
      // Show loading message
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
                Expanded(
                  child: Text('Preparing to share ${document.fileName}...'),
                ),
              ],
            ),
            duration: const Duration(seconds: 5),
            backgroundColor: AppColors.primary,
          ),
        );
      }

      // Upload to Google Drive and share
      await _shareService.shareFileWithLink(
        document: document,
        linkExpiration: const Duration(hours: 24),
        customMessage: 'I\'m sharing a document with you from Management Doc:',
        onProgress: (progress) {
          debugPrint('Upload progress: ${(progress * 100).toInt()}%');
        },
      );

      // Hide loading message and show success
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Document uploaded to Google Drive and shared!'),
                ),
              ],
            ),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Failed to share document: ${e.toString()}'),
                ),
              ],
            ),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                _shareDocument(document);
              },
            ),
          ),
        );
      }
    }
  }

  // Download file to device storage
  Future<void> _downloadFile(DocumentModel document) async {
    final downloadService = FileDownloadService();

    try {
      // Download the file (notifications handled by FileDownloadService)
      await downloadService.downloadFile(document);

      // Success notification handled by FileDownloadService
      debugPrint('✅ Download completed: ${document.fileName}');
    } catch (e) {
      // Error notification handled by FileDownloadService
      debugPrint('❌ Download failed: ${document.fileName} - $e');
    }
  }
}

// Search widget that matches the home screen style
class _CategorySearchSection extends StatefulWidget {
  final TextEditingController searchController;
  final VoidCallback? onSearchChanged;

  const _CategorySearchSection({
    required this.searchController,
    this.onSearchChanged,
  });

  @override
  State<_CategorySearchSection> createState() => _CategorySearchSectionState();
}

class _CategorySearchSectionState extends State<_CategorySearchSection> {
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    widget.searchController.removeListener(_onSearchTextChanged);
    super.dispose();
  }

  void _onSearchTextChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      widget.onSearchChanged?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get responsive margin - OPTIMIZED
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveMargin = EdgeInsets.symmetric(
      horizontal: screenWidth < 400 ? 12.0 : 16.0,
      vertical: 8, // Add some vertical margin for category files screen
    );

    return Container(
      margin: responsiveMargin,
      child: _CategorySearchField(
        controller: widget.searchController,
        onClear: _clearSearch,
      ),
    );
  }

  void _clearSearch() {
    widget.searchController.clear();
    widget.onSearchChanged?.call();
  }
}

class _CategorySearchField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onClear;

  const _CategorySearchField({required this.controller, this.onClear});

  @override
  Widget build(BuildContext context) {
    // Get responsive values - OPTIMIZED
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    final responsiveBorderRadius = isSmallScreen ? 12.0 : 16.0;
    final responsiveElevation = 2.0;
    final fontSize = isSmallScreen ? 14.0 : 15.0;
    final iconSize = isSmallScreen ? 18.0 : 20.0;
    final verticalPadding = isSmallScreen ? 12.0 : 14.0;
    final horizontalPadding = isSmallScreen ? 12.0 : 16.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(responsiveBorderRadius),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: responsiveElevation * 2,
            offset: Offset(0, responsiveElevation / 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search files...',
          hintStyle: GoogleFonts.poppins(
            fontSize: fontSize,
            color: AppColors.textSecondary,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textSecondary,
            size: iconSize,
          ),
          suffixIcon: _buildSuffixIcon(context),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon(BuildContext context) {
    if (controller.text.isEmpty) return null;

    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth < 400 ? 18.0 : 20.0;

    return IconButton(
      icon: Icon(Icons.clear, color: AppColors.textSecondary, size: iconSize),
      onPressed: onClear,
      splashRadius: iconSize,
    );
  }
}
