import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../providers/document_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/category_model.dart';
import '../../models/document_model.dart';
import '../../widgets/common/custom_app_bar.dart';

import '../../services/file_download_service.dart';
import '../../services/share_service.dart';
import '../../utils/download_location_helper.dart';
import '../../widgets/common/ios_back_button.dart';
import '../../widgets/common/reusable_file_list_widget.dart';
import '../../widgets/common/reusable_file_grid_widget.dart';
import '../../widgets/common/file_filter_widget.dart';
import '../../widgets/common/file_selection_bar.dart';

enum ViewMode { list, grid }

class CategoryFilesScreen extends StatefulWidget {
  final CategoryModel category;

  const CategoryFilesScreen({super.key, required this.category});

  @override
  State<CategoryFilesScreen> createState() => _CategoryFilesScreenState();
}

class _CategoryFilesScreenState extends State<CategoryFilesScreen> {
  ViewMode _currentViewMode = ViewMode.list;
  final TextEditingController _searchController = TextEditingController();
  final ShareService _shareService = ShareService();
  String _searchQuery = '';

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
      documentProvider.initializeCategory(widget.category.id);

      // Always try to load documents from Firebase to ensure fresh data
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
    });
  }

  List<DocumentModel> _filterDocuments(List<DocumentModel> documents) {
    if (_searchQuery.isEmpty) {
      return documents;
    }
    return documents.where((document) {
      return document.fileName.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
    }).toList();
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
        child: FileFilterWidget(
          onFilterApplied: () {
            Navigator.pop(context);
            setState(() {
              // Trigger rebuild to apply filters
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
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.category.name,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        leading: const IOSBackButton(),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _currentViewMode = _currentViewMode == ViewMode.list
                    ? ViewMode.grid
                    : ViewMode.list;
              });
            },
            icon: Icon(
              _currentViewMode == ViewMode.list
                  ? Icons.grid_view
                  : Icons.view_list,
              color: AppColors.textWhite,
            ),
            tooltip: _currentViewMode == ViewMode.list
                ? 'Switch to Grid View'
                : 'Switch to List View',
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
                final categoryDocuments = documentProvider
                    .getDocumentsByCategory(widget.category.id);
                // Apply both DocumentProvider filters and local search
                final providerFilteredDocs = documentProvider.documents
                    .where((doc) => doc.category == widget.category.id)
                    .toList();
                final filteredDocuments = _filterDocuments(
                  providerFilteredDocs,
                );

                if (categoryDocuments.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () async {
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
                  },
                  color: AppColors.primary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // Category Info Header
                        _buildCategoryInfoHeader(categoryDocuments.length),
                        // Search Widget
                        _buildSearchWidget(),
                        // Files List
                        filteredDocuments.isEmpty && _searchQuery.isNotEmpty
                            ? _buildNoSearchResults()
                            : _currentViewMode == ViewMode.list
                            ? ReusableFileListWidget(
                                documents: filteredDocuments,
                                title: widget.category.name,
                                onDocumentTap: _navigateToFilePreview,
                                onDocumentMenu: _showDocumentMenu,
                                onFilterTap: _showFilterMenu,
                                showFilter: true,
                                showPagination: true,
                                itemsPerPage: 10,
                                emptyStateMessage: 'No files in this category',
                                emptyStateIcon: Icons.folder_open,
                                categoryId: widget
                                    .category
                                    .id, // Pass category ID for bulk operations
                              )
                            : ReusableFileGridWidget(
                                documents: filteredDocuments,
                                title: widget.category.name,
                                onDocumentTap: _navigateToFilePreview,
                                onDocumentMenu: _showDocumentMenu,
                                onFilterTap: _showFilterMenu,
                                showFilter: true,
                                showPagination: true,
                                itemsPerPage: 8, // 4x2 grid per page
                                emptyStateMessage: 'No files in this category',
                                emptyStateIcon: Icons.folder_open,
                                categoryId: widget.category.id,
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
    );
  }

  Widget _buildCategoryInfoHeader(int fileCount) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8), // Optimized margins
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          12,
        ), // Rounded corners like other components
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getCategoryColor().withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(),
                    color: _getCategoryColor(),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.category.name,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (widget.category.description.isNotEmpty)
                        Text(
                          widget.category.description,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '$fileCount files',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            // Action Buttons Row for non-empty folders
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // Navigate to add existing files to category
                      final result = await Navigator.of(context).pushNamed(
                        AppRoutes.addFilesToCategory,
                        arguments: widget.category,
                      );
                      // Only refresh if files were actually added
                      if (mounted && result == true) {
                        // Just trigger a rebuild, data is already updated in provider
                        setState(() {});
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: AppColors.textWhite,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    icon: const Icon(Icons.add, size: 16),
                    label: Text(
                      'Add Existing',
                      style: GoogleFonts.poppins(fontSize: 11),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to upload with pre-selected category
                      Navigator.of(context).pushNamed(
                        AppRoutes.uploadDocument,
                        arguments: widget.category.id,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textWhite,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    icon: const Icon(Icons.upload, size: 16),
                    label: Text(
                      'Upload New',
                      style: GoogleFonts.poppins(fontSize: 11),
                    ),
                  ),
                ),
              ],
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

  Widget _buildNoSearchResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No files found',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 80,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'No Files in This Category',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload documents to this category to see them here',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  // Navigate to add existing files to category
                  final result = await Navigator.of(context).pushNamed(
                    AppRoutes.addFilesToCategory,
                    arguments: widget.category,
                  );
                  // Only refresh if files were actually added
                  if (mounted && result == true) {
                    // Just trigger a rebuild, data is already updated in provider
                    setState(() {});
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: AppColors.textWhite,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.add),
                label: Text('Add Existing Files', style: GoogleFonts.poppins()),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to upload with pre-selected category
                  Navigator.of(context).pushNamed(
                    AppRoutes.uploadDocument,
                    arguments: widget.category.id,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textWhite,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.upload_file),
                label: Text('Upload New', style: GoogleFonts.poppins()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper methods
  IconData _getCategoryIcon() {
    final name = widget.category.name.toLowerCase();
    if (name.contains('surat') || name.contains('mail')) {
      return Icons.mail;
    } else if (name.contains('laporan') || name.contains('report')) {
      return Icons.assessment;
    } else if (name.contains('notulen') || name.contains('meeting')) {
      return Icons.event_note;
    } else if (name.contains('sk') || name.contains('keputusan')) {
      return Icons.gavel;
    } else if (name.contains('proposal') || name.contains('project')) {
      return Icons.business_center;
    } else {
      return Icons.folder;
    }
  }

  Color _getCategoryColor() {
    final name = widget.category.name.toLowerCase();
    if (name.contains('surat') || name.contains('mail')) {
      return Colors.blue;
    } else if (name.contains('laporan') || name.contains('report')) {
      return Colors.green;
    } else if (name.contains('notulen') || name.contains('meeting')) {
      return Colors.orange;
    } else if (name.contains('sk') || name.contains('keputusan')) {
      return Colors.red;
    } else if (name.contains('proposal') || name.contains('project')) {
      return Colors.purple;
    } else {
      return AppColors.primary;
    }
  }

  void _showDocumentMenu(DocumentModel document) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.download),
              title: Text('Download', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pop(context);
                _downloadFile(document);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: Text('Share', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pop(context);
                _shareDocument(document);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text('Details', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pop(context);
                _showDocumentDetails(document);
              },
            ),
            ListTile(
              leading: const Icon(Icons.remove_circle, color: Colors.orange),
              title: Text(
                'Remove from Folder',
                style: GoogleFonts.poppins(color: Colors.orange),
              ),
              onTap: () {
                Navigator.pop(context);
                _showRemoveFileDialog(document);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(
                'Delete File Permanently',
                style: GoogleFonts.poppins(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(document);
              },
            ),
          ],
        ),
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

      // Remove document from this category (move to uncategorized)
      await documentProvider.updateDocumentCategory(
        document.id,
        'uncategorized',
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

  // Helper method for date formatting
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
            _buildDetailRow('Size', document.fileSizeFormatted),
            _buildDetailRow('Type', document.fileType),
            _buildDetailRow('Uploaded', _formatDate(document.uploadedAt)),
            _buildDetailRow('Status', document.status.toUpperCase()),
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

  Future<void> _deleteFile(DocumentModel document) async {
    try {
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

      // Share with link (default behavior)
      await _shareService.shareFileWithLink(
        document: document,
        linkExpiration: const Duration(hours: 24),
        customMessage: 'I\'m sharing a document with you from Management Doc:',
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
                Expanded(child: Text('Document shared successfully!')),
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
      // Show initial download message
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
                Expanded(child: Text('Downloading ${document.fileName}...')),
              ],
            ),
            duration: const Duration(seconds: 30), // Long duration for download
            backgroundColor: AppColors.primary,
          ),
        );
      }

      // Download the file
      await downloadService.downloadFile(
        document,
        onProgress: (progress) {
          // You could update a progress indicator here if needed
          debugPrint(
            'Download progress: ${(progress * 100).toStringAsFixed(1)}%',
          );
        },
      );

      // Show success message with location info
      if (mounted) {
        final locationDescription = await downloadService
            .getDownloadLocationDescription();
        final actualPath = await downloadService.getDownloadDirectoryPath();

        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'File downloaded successfully!',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'File: ${document.fileName}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Location: $locationDescription',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Path: $actualPath',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 8),
              action: SnackBarAction(
                label: 'Find File',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  DownloadLocationHelper.showDownloadLocationInfo(context);
                },
              ),
            ),
          );
        }
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.error, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(child: Text('Download failed')),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  e.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
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
                _downloadFile(document); // Retry download
              },
            ),
          ),
        );
      }
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
