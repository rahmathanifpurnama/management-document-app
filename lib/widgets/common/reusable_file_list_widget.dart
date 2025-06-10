import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/optimized_ui_widgets.dart';
import '../../core/config/anr_config.dart';
import '../../models/document_model.dart';
import '../../providers/file_selection_provider.dart';
import '../../providers/document_provider.dart';
import '../../services/bulk_operations_service.dart';

/// Reusable file list widget that can be used across different screens
class ReusableFileListWidget extends StatefulWidget {
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
  final String? categoryId; // Add categoryId parameter for bulk operations

  const ReusableFileListWidget({
    super.key,
    required this.documents,
    required this.title,
    this.onDocumentTap,
    this.onDocumentMenu,
    this.onFilterTap,
    this.showFilter = true,
    this.showPagination = true,
    this.itemsPerPage = 10,
    this.emptyStateMessage = 'No files found',
    this.emptyStateIcon = Icons.folder_open,
    this.categoryId, // Optional category ID for folder-specific operations
  });

  @override
  State<ReusableFileListWidget> createState() => _ReusableFileListWidgetState();
}

class _ReusableFileListWidgetState extends State<ReusableFileListWidget>
    with TickerProviderStateMixin {
  int _currentPage = 0;
  bool _isTransitioning = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for smooth transitions
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // Start with animation visible
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

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
        // Use a more conservative approach to prevent selection interference
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && selectionProvider.isSelectionMode) {
            // Only update if we're in selection mode to avoid unnecessary calls
            selectionProvider.updateAvailableFiles(widget.documents);
          }
        });

        // Show loading state if documents are being loaded and no documents available
        if (documentProvider.isLoading && widget.documents.isEmpty) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and filter
                Row(
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
                    if (widget.showFilter && widget.onFilterTap != null)
                      IconButton(
                        onPressed: widget.onFilterTap,
                        icon: const Icon(
                          Icons.filter_list,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 24,
                          minHeight: 24,
                        ),
                        tooltip: 'Filter Files',
                      ),
                  ],
                ),
                // Loading indicator
                _buildLoadingState(),
              ],
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and filter
              Row(
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
                  if (widget.showFilter && widget.onFilterTap != null)
                    IconButton(
                      onPressed: widget.onFilterTap,
                      icon: const Icon(
                        Icons.filter_list,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                      tooltip: 'Filter Files',
                    ),
                ],
              ),

              // Files List
              _buildFilesList(currentPageDocuments, selectionProvider),

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
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
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

  /// Build files list widget
  Widget _buildFilesList(
    List<DocumentModel> documents,
    FileSelectionProvider selectionProvider,
  ) {
    // Show loading state during transitions
    if (_isTransitioning) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ),
      );
    }

    if (documents.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
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
              Icon(
                widget.emptyStateIcon,
                size: 48,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 12),
              Text(
                widget.emptyStateMessage,
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

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: documents.asMap().entries.map((entry) {
            final index = entry.key;
            final document = entry.value;
            final isLast = index == documents.length - 1;

            return _buildFileListItem(document, isLast, selectionProvider);
          }).toList(),
        ),
      ),
    );
  }

  /// Build individual file list item
  Widget _buildFileListItem(
    DocumentModel document,
    bool isLast,
    FileSelectionProvider selectionProvider,
  ) {
    final isSelected = selectionProvider.isFileSelected(document.id);
    final isSelectionMode = selectionProvider.isSelectionMode;
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : null,
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _handleTap(document, selectionProvider),
          onLongPress: () => _handleLongPress(document, selectionProvider),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Selection checkbox (only show in selection mode)
                if (isSelectionMode) ...[
                  Checkbox(
                    value: isSelected,
                    onChanged: (value) {
                      selectionProvider.toggleFileSelection(document.id);
                    },
                    activeColor: AppColors.primary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(width: 8),
                ],

                // File type icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getFileTypeColor(
                          document.fileType,
                          document.fileName,
                        ).withValues(alpha: 0.8),
                        _getFileTypeColor(
                          document.fileType,
                          document.fileName,
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
                          document.fileName,
                        ).withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      _getFileTypeIcon(document.fileType, document.fileName),
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

                // Status badge (for pending files)
                if (document.status == 'pending') ...[
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'PENDING',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],

                // Individual file operations menu (only show when NOT in selection mode)
                if (!isSelectionMode) ...[
                  const SizedBox(width: 12),
                  GestureDetector(
                    // Absorb tap events to prevent interference with file selection
                    onTap: () {
                      // Prevent tap from bubbling up to parent InkWell
                      if (widget.onDocumentMenu != null) {
                        widget.onDocumentMenu!(document);
                      }
                    },
                    child: Container(
                      width: 40, // Increased touch target size
                      height: 40, // Increased touch target size
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.more_vert,
                          color: widget.onDocumentMenu != null
                              ? AppColors.textSecondary
                              : AppColors.textSecondary.withValues(alpha: 0.3),
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
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

  /// Handle smooth transition when exiting selection mode
  Future<void> _handleSmoothTransition() async {
    if (!mounted) return;

    setState(() {
      _isTransitioning = true;
    });

    // Brief fade out and in for smooth transition
    await _fadeController.reverse();

    if (mounted) {
      setState(() {
        _isTransitioning = false;
      });
      await _fadeController.forward();
    }
  }

  /// Get file type color
  Color _getFileTypeColor(String fileType, [String? fileName]) {
    final lowerFileType = fileType.toLowerCase();

    // If fileName is provided, also try to get extension from it
    String? fileExtension;
    if (fileName != null && fileName.contains('.')) {
      fileExtension = fileName.split('.').last.toLowerCase();
    }

    // Handle both extension format (pdf, jpg) and descriptive format (PDF, Image)
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

  /// Get file type icon
  IconData _getFileTypeIcon(String fileType, [String? fileName]) {
    final lowerFileType = fileType.toLowerCase();

    // If fileName is provided, also try to get extension from it
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

  /// Format file size
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

  /// Format date
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

  /// Handle tap on file item
  void _handleTap(
    DocumentModel document,
    FileSelectionProvider selectionProvider,
  ) {
    if (selectionProvider.isSelectionMode) {
      // In selection mode, toggle selection
      selectionProvider.toggleFileSelection(document.id);
    } else {
      // Normal mode, call the document tap callback
      widget.onDocumentTap?.call(document);
    }
  }

  /// Handle long press on file item
  void _handleLongPress(
    DocumentModel document,
    FileSelectionProvider selectionProvider,
  ) {
    if (selectionProvider.isSelectionMode) {
      // In selection mode, show bulk operations menu
      if (selectionProvider.hasSelection) {
        BulkOperationsService.showBulkOperationsMenu(
          context: context,
          selectedFiles: selectionProvider.selectedFiles,
          categoryId: widget
              .categoryId, // Pass categoryId for folder-specific operations
          onOperationComplete: () async {
            try {
              // Exit selection mode safely
              selectionProvider.exitSelectionMode();

              // Use smooth transition for better UX
              await _handleSmoothTransition();
            } catch (e) {
              // Handle any errors gracefully
              debugPrint('Error during bulk operation completion: $e');

              // Ensure UI is refreshed even if there's an error
              if (mounted) {
                setState(() {});
              }
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
