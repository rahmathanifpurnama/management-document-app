import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/document_model.dart';
import '../../providers/file_selection_provider.dart';
import '../../providers/document_provider.dart';
import '../../services/bulk_operations_service.dart';
import '../../theme/app_colors.dart';
import '../../utils/file_icon_helper.dart';
import '../../utils/file_size_formatter.dart';
import '../../utils/date_formatter.dart';
import '../common/responsive_layout_widget.dart';

/// Reusable file grid widget with pagination support
class ReusableFileGridWidget extends StatefulWidget {
  final List<DocumentModel> documents;
  final String title;
  final Function(DocumentModel)? onDocumentTap;
  final Function(DocumentModel)? onDocumentMenu;
  final VoidCallback? onFilterTap;
  final bool showFilter;
  final bool showPagination;
  final int itemsPerPage;
  final String emptyStateMessage;
  final IconData emptyStateIcon;
  final String? categoryId;

  const ReusableFileGridWidget({
    super.key,
    required this.documents,
    required this.title,
    this.onDocumentTap,
    this.onDocumentMenu,
    this.onFilterTap,
    this.showFilter = true,
    this.showPagination = true,
    this.itemsPerPage = 8, // Default 8 items per page for grid (4x2)
    this.emptyStateMessage = 'No files found',
    this.emptyStateIcon = Icons.folder_open,
    this.categoryId,
  });

  @override
  State<ReusableFileGridWidget> createState() => _ReusableFileGridWidgetState();
}

class _ReusableFileGridWidgetState extends State<ReusableFileGridWidget> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final totalPages = widget.showPagination
        ? (widget.documents.length / widget.itemsPerPage).ceil()
        : 1;
    final startIndex = widget.showPagination
        ? _currentPage * widget.itemsPerPage
        : 0;
    final endIndex = widget.showPagination
        ? (startIndex + widget.itemsPerPage).clamp(0, widget.documents.length)
        : widget.documents.length;
    final currentPageDocuments = widget.documents.sublist(startIndex, endIndex);

    return Consumer2<FileSelectionProvider, DocumentProvider>(
      builder: (context, selectionProvider, documentProvider, child) {
        // Update available files for selection only when necessary
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (selectionProvider.isSelectionMode) {
            // Only update if we're in selection mode to avoid unnecessary calls
            selectionProvider.updateAvailableFiles(widget.documents);
          }
        });

        // Show loading state if documents are being loaded and no documents available
        if (documentProvider.isLoading && widget.documents.isEmpty) {
          return Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                // Filter Header
                if (widget.showFilter) _buildFilterHeader(),
                // Loading indicator
                _buildLoadingState(),
              ],
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            children: [
              // Filter Header
              if (widget.showFilter) _buildFilterHeader(),

              // Grid View
              if (currentPageDocuments.isEmpty)
                _buildEmptyState()
              else
                _buildGrid(currentPageDocuments, selectionProvider),

              // Pagination Controls
              if (widget.showPagination && totalPages > 1) ...[
                const SizedBox(height: 16),
                _buildPaginationControls(totalPages),
              ],
            ],
          ),
        );
      },
    );
  }

  /// Build loading state widget
  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(48),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading files...',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build filter header - consistent with home screen and list mode
  Widget _buildFilterHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          if (widget.onFilterTap != null)
            IconButton(
              onPressed: widget.onFilterTap,
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

  /// Build grid view with responsive layout
  Widget _buildGrid(
    List<DocumentModel> documents,
    FileSelectionProvider selectionProvider,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.getResponsiveGridCount(context),
        crossAxisSpacing: ResponsiveHelper.getResponsiveValue(
          context,
          mobile: 12,
          tablet: 16,
          desktop: 20,
        ),
        mainAxisSpacing: ResponsiveHelper.getResponsiveValue(
          context,
          mobile: 12,
          tablet: 16,
          desktop: 20,
        ),
        childAspectRatio: ResponsiveHelper.getResponsiveAspectRatio(context),
      ),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final document = documents[index];
        return _buildGridItem(document, selectionProvider);
      },
    );
  }

  /// Build individual grid item
  Widget _buildGridItem(
    DocumentModel document,
    FileSelectionProvider selectionProvider,
  ) {
    final isSelected = selectionProvider.isFileSelected(document.id);

    return GestureDetector(
      onTap: () => _handleGridItemTap(document, selectionProvider),
      onLongPress: () => _handleGridItemLongPress(document, selectionProvider),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // File Icon and Selection Indicator
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Stack(
                  children: [
                    // File Icon
                    Center(
                      child: Icon(
                        FileIconHelper.getFileIcon(document.fileName),
                        size: ResponsiveHelper.getResponsiveValue(
                          context,
                          mobile: 40,
                          tablet: 48,
                          desktop: 56,
                        ),
                        color: FileIconHelper.getFileTypeColor(
                          document.fileName,
                        ),
                      ),
                    ),
                    // Selection indicator (only show in selection mode)
                    if (selectionProvider.isSelectionMode)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.surface,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                )
                              : null,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // File Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // File name with menu button row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            document.fileName,
                            style: GoogleFonts.poppins(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                mobile: 11,
                                tablet: 12,
                                desktop: 14,
                              ),
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Menu button (only show when NOT in selection mode)
                        if (!selectionProvider.isSelectionMode) ...[
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: widget.onDocumentMenu != null
                                ? () => widget.onDocumentMenu!(document)
                                : null,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: AppColors.surface.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.shadow.withValues(
                                      alpha: 0.1,
                                    ),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.more_vert,
                                color: AppColors.textSecondary,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    // File size and date
                    Text(
                      '${FileSizeFormatter.formatBytes(document.fileSize)} • ${DateFormatter.formatRelative(document.uploadedAt)}',
                      style: GoogleFonts.poppins(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          mobile: 9,
                          tablet: 10,
                          desktop: 12,
                        ),
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            widget.emptyStateIcon,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            widget.emptyStateMessage,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build pagination controls
  Widget _buildPaginationControls(int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous button
        IconButton(
          onPressed: _currentPage > 0
              ? () => _goToPage(_currentPage - 1)
              : null,
          icon: const Icon(Icons.chevron_left),
          style: IconButton.styleFrom(
            backgroundColor: _currentPage > 0
                ? AppColors.primary.withValues(alpha: 0.1)
                : AppColors.background,
            foregroundColor: _currentPage > 0
                ? AppColors.primary
                : AppColors.textSecondary.withValues(alpha: 0.5),
          ),
        ),

        const SizedBox(width: 16),

        // Page indicators
        ...List.generate(totalPages, (index) {
          final isCurrentPage = index == _currentPage;
          return GestureDetector(
            onTap: () => _goToPage(index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCurrentPage ? AppColors.primary : AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isCurrentPage
                      ? AppColors.primary
                      : AppColors.border.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isCurrentPage ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        }),

        const SizedBox(width: 16),

        // Next button
        IconButton(
          onPressed: _currentPage < totalPages - 1
              ? () => _goToPage(_currentPage + 1)
              : null,
          icon: const Icon(Icons.chevron_right),
          style: IconButton.styleFrom(
            backgroundColor: _currentPage < totalPages - 1
                ? AppColors.primary.withValues(alpha: 0.1)
                : AppColors.background,
            foregroundColor: _currentPage < totalPages - 1
                ? AppColors.primary
                : AppColors.textSecondary.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  /// Navigate to specific page
  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  /// Handle tap on grid item
  void _handleGridItemTap(
    DocumentModel document,
    FileSelectionProvider selectionProvider,
  ) {
    if (selectionProvider.isSelectionMode) {
      // In selection mode, toggle selection
      selectionProvider.toggleFileSelection(document.id);
    } else {
      // Normal mode, call onDocumentTap if provided
      widget.onDocumentTap?.call(document);
    }
  }

  /// Handle long press on grid item
  void _handleGridItemLongPress(
    DocumentModel document,
    FileSelectionProvider selectionProvider,
  ) {
    if (selectionProvider.isSelectionMode) {
      // In selection mode, show bulk operations menu
      if (selectionProvider.hasSelection) {
        BulkOperationsService.showBulkOperationsMenu(
          context: context,
          selectedFiles: selectionProvider.selectedFiles,
          categoryId: widget.categoryId,
          onOperationComplete: () async {
            try {
              // Exit selection mode safely
              selectionProvider.exitSelectionMode();
            } catch (e) {
              // Handle any errors gracefully
              debugPrint('Error during bulk operation completion: $e');
            }
          },
        );
      }
    } else {
      // Enter selection mode with this file
      selectionProvider.enterSelectionMode(document, widget.documents);
    }
  }
}
