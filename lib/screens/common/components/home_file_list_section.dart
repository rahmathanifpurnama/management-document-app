part of '../home_screen.dart';

/// Stateful widget for file list display with integrated operations
/// Consolidates file operations and API calls for better maintainability
///
/// COMPREHENSIVE FIX: File list with full search and filter functionality
/// - Uses DocumentProvider's filtered results for complete filter support
/// - Maintains search functionality through DocumentProvider
/// - Supports all filter types: category, file type, and search
/// - Forces refresh on initialization for immediate storage consistency
/// - Maintains ANR optimizations while ensuring complete data coverage
class HomeFileListSection extends StatefulWidget {
  final String searchQuery;
  final Function(DocumentModel)? onDocumentTap;
  final Function(DocumentModel)? onDocumentMenu;
  final VoidCallback? onFilterTap;

  const HomeFileListSection({
    super.key,
    required this.searchQuery,
    this.onDocumentTap,
    this.onDocumentMenu,
    this.onFilterTap,
  });

  /// Factory constructor for home screen file list
  factory HomeFileListSection.forHomeScreen({
    required String searchQuery,
    required Function(DocumentModel) onDocumentTap,
    required Function(DocumentModel) onDocumentMenu,
    required VoidCallback onFilterTap,
  }) {
    return HomeFileListSection(
      searchQuery: searchQuery,
      onDocumentTap: onDocumentTap,
      onDocumentMenu: onDocumentMenu,
      onFilterTap: onFilterTap,
    );
  }

  @override
  State<HomeFileListSection> createState() => _HomeFileListSectionState();
}

class _HomeFileListSectionState extends State<HomeFileListSection>
    with TickerProviderStateMixin {
  int _currentPage = 0;
  // ENTERPRISE SCALE: Increased pagination for better performance with large datasets
  static const int _filesPerPage = 25;
  bool _isTransitioning = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Enhanced animations for initial page load
  late AnimationController _slideController;
  late AnimationController _staggerController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // Simple loading state management for first-time login
  bool _isFirstTimeLoading = true;
  bool _hasDataCheckCompleted = false;

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

    // Initialize enhanced animations for initial page load
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _staggerController, curve: Curves.elasticOut),
    );

    // Start animations with delay for better visual effect
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _slideController.forward();
      }
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _staggerController.forward();
      }
    });

    // Reset page when search query changes and refresh recent files
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _currentPage = 0;
        });

        // Start initial loading process
        _startInitialLoading();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  /// Start first-time loading process for login users
  Future<void> _startInitialLoading() async {
    if (!mounted) return;

    // Set loading state
    setState(() {
      _isFirstTimeLoading = true;
      _hasDataCheckCompleted = false;
    });

    try {
      debugPrint(
        '🔄 HomeFileListSection: Starting first-time loading for login user...',
      );

      // Show loading UI for minimum duration (better UX)
      final minimumLoadingTime = Future.delayed(
        const Duration(milliseconds: 1200),
      );

      // Get document provider
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );

      // Force load documents from database
      final dataLoadingFuture = documentProvider.loadDocuments(
        forceRefresh: true,
      );

      // Wait for both minimum loading time and data loading
      await Future.wait([minimumLoadingTime, dataLoadingFuture]);

      if (mounted) {
        setState(() {
          _isFirstTimeLoading = false;
          _hasDataCheckCompleted = true;
        });

        final documentCount = documentProvider.allDocuments.length;
        debugPrint(
          '✅ HomeFileListSection: First-time loading completed - Found $documentCount files',
        );
      }
    } catch (e) {
      debugPrint('❌ HomeFileListSection: First-time loading failed: $e');
      if (mounted) {
        setState(() {
          _isFirstTimeLoading = false;
          _hasDataCheckCompleted = true;
        });
      }
    }
  }

  @override
  void didUpdateWidget(HomeFileListSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset page when search query changes
    if (oldWidget.searchQuery != widget.searchQuery) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _currentPage = 0;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DocumentProvider, FileSelectionProvider>(
      builder: (context, documentProvider, selectionProvider, child) {
        // Get filtered documents for display
        final displayDocuments = documentProvider.filteredDocuments;

        // Update available files for selection only when necessary
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (selectionProvider.isSelectionMode) {
            selectionProvider.updateAvailableFiles(displayDocuments);
          }
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Files Section with Pagination
            _buildRecentFilesSection(displayDocuments, selectionProvider),
          ],
        );
      },
    );
  }

  /// Build recent files section with pagination and pull to refresh
  Widget _buildRecentFilesSection(
    List<DocumentModel> documents,
    FileSelectionProvider selectionProvider,
  ) {
    final totalPages = (documents.length / _filesPerPage).ceil();
    final startIndex = _currentPage * _filesPerPage;
    final endIndex = (startIndex + _filesPerPage).clamp(0, documents.length);
    final currentPageDocuments = documents.sublist(startIndex, endIndex);

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and filter - animated
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              tween: Tween<double>(begin: 0.0, end: 1.0),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(-30 * (1 - value), 0),
                  child: Opacity(
                    opacity: value,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Files',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        // Filter button
                        Row(
                          children: [
                            // Filter button
                            if (widget.onFilterTap != null)
                              TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 800),
                                tween: Tween<double>(begin: 0.0, end: 1.0),
                                curve: Curves.elasticOut,
                                builder: (context, buttonValue, child) {
                                  return Transform.scale(
                                    scale: buttonValue,
                                    child: IconButton(
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
                                  );
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Files List with enhanced animations
            SlideTransition(
              position: _slideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildFilesList(
                    currentPageDocuments,
                    selectionProvider,
                  ),
                ),
              ),
            ),

            // Pagination Controls
            if (totalPages > 1) ...[
              const SizedBox(height: 16),
              _buildPaginationControls(totalPages),
            ],

            // Add some bottom padding
            const SizedBox(height: 100),
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
    return Consumer<DocumentProvider>(
      builder: (context, documentProvider, child) {
        // PRIORITY 1: Show first-time loading state for login users
        if (_isFirstTimeLoading || !_hasDataCheckCompleted) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
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
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading your files...',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Checking database for your documents',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        // PRIORITY 2: Show transition loading state (for page changes, etc.)
        if (_isTransitioning) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Center(
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

        // PRIORITY 3: Show empty state after data check is complete
        if (documents.isEmpty &&
            !documentProvider.isLoading &&
            _hasDataCheckCompleted) {
          return _buildEmptyState();
        }

        // Return the actual files list
        return _buildActualFilesList(documents, selectionProvider);
      },
    );
  }

  /// Build the actual files list when documents are available
  Widget _buildActualFilesList(
    List<DocumentModel> documents,
    FileSelectionProvider selectionProvider,
  ) {
    return Container(
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

          // Add staggered animation for each file item
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300 + (index * 100)),
            tween: Tween<double>(begin: 0.0, end: 1.0),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: _buildFileListItem(
                    document,
                    isLast,
                    selectionProvider,
                  ),
                ),
              );
            },
          );
        }).toList(),
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

                // Individual file operations menu (only show when NOT in selection mode)
                if (!isSelectionMode) ...[
                  const SizedBox(width: 12),
                  // DELETE FIX: Improved menu button with better error handling and constraints
                  Container(
                    width: 40, // Increased touch target for better UX
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: widget.onDocumentMenu != null
                            ? () {
                                try {
                                  widget.onDocumentMenu!(document);
                                } catch (e) {
                                  debugPrint(
                                    '❌ Error opening document menu: $e',
                                  );
                                  // Show user-friendly error message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Unable to open menu. Please try again.',
                                      ),
                                      backgroundColor: AppColors.error,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              }
                            : null,
                        child: Center(
                          child: Icon(
                            Icons.more_vert,
                            color: widget.onDocumentMenu != null
                                ? AppColors.textSecondary
                                : AppColors.textSecondary.withValues(
                                    alpha: 0.3,
                                  ),
                            size: 18,
                          ),
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

  /// Build clean pagination controls without background styling
  Widget _buildPaginationControls(int totalPages) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous button
          _buildPaginationButton(
            icon: Icons.chevron_left,
            isEnabled: _currentPage > 0,
            onTap: _currentPage > 0 ? () => _goToPage(_currentPage - 1) : null,
            tooltip: 'Previous page',
          ),

          const SizedBox(width: 16),

          // Page indicators with smart truncation and ellipsis
          ..._buildPageIndicators(totalPages),

          const SizedBox(width: 16),

          // Next button
          _buildPaginationButton(
            icon: Icons.chevron_right,
            isEnabled: _currentPage < totalPages - 1,
            onTap: _currentPage < totalPages - 1
                ? () => _goToPage(_currentPage + 1)
                : null,
            tooltip: 'Next page',
          ),
        ],
      ),
    );
  }

  /// Build pagination button with consistent styling
  Widget _buildPaginationButton({
    required IconData icon,
    required bool isEnabled,
    required VoidCallback? onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isEnabled
                    ? AppColors.primary.withValues(alpha: 0.3)
                    : AppColors.border.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              size: 18,
              color: isEnabled
                  ? AppColors.primary
                  : AppColors.textSecondary.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }

  /// Build page indicators with smart truncation for many pages
  List<Widget> _buildPageIndicators(int totalPages) {
    const maxVisiblePages = 5;

    if (totalPages <= maxVisiblePages) {
      // Show all pages if total is small
      return List.generate(totalPages, (index) => _buildPageIndicator(index));
    }

    // Smart truncation for many pages
    List<Widget> indicators = [];

    // Always show first page
    indicators.add(_buildPageIndicator(0));

    if (_currentPage > 2) {
      indicators.add(_buildEllipsis());
    }

    // Show current page and neighbors
    int start = (_currentPage - 1).clamp(1, totalPages - 2);
    int end = (_currentPage + 1).clamp(1, totalPages - 2);

    for (int i = start; i <= end; i++) {
      if (i != 0 && i != totalPages - 1) {
        indicators.add(_buildPageIndicator(i));
      }
    }

    if (_currentPage < totalPages - 3) {
      indicators.add(_buildEllipsis());
    }

    // Always show last page
    if (totalPages > 1) {
      indicators.add(_buildPageIndicator(totalPages - 1));
    }

    return indicators;
  }

  /// Build clean page indicator
  Widget _buildPageIndicator(int index) {
    final isCurrentPage = index == _currentPage;
    return GestureDetector(
      onTap: () => _goToPage(index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isCurrentPage ? AppColors.primary : Colors.transparent,
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
              fontSize: 13,
              fontWeight: isCurrentPage ? FontWeight.w600 : FontWeight.w500,
              color: isCurrentPage ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  /// Build clean ellipsis indicator
  Widget _buildEllipsis() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 32,
      height: 32,
      child: Center(
        child: Text(
          '...',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  /// Navigate to specific page
  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  /// Build empty state with animation
  Widget _buildEmptyState() {
    final emptyStateManager = EmptyStorageStateManager.instance;
    final isEmptyStateConfirmed = emptyStateManager.shouldShowEmptyUI();

    final emptyMessage = isEmptyStateConfirmed
        ? 'No files in storage'
        : 'No files found';
    final emptySubMessage = isEmptyStateConfirmed
        ? 'Upload files to see them here'
        : 'Files will appear here once uploaded';

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
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
                      isEmptyStateConfirmed
                          ? Icons.cloud_off
                          : Icons.folder_open,
                      size: 48,
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      emptyMessage,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      emptySubMessage,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Handle smooth transition when exiting selection mode
  /// DELETE FIX: Enhanced transition handling with error boundaries
  Future<void> _handleSmoothTransition() async {
    if (!mounted) return;

    try {
      setState(() {
        _isTransitioning = true;
      });

      // Brief fade out and in for smooth transition with error handling
      if (_fadeController.isAnimating) {
        _fadeController.stop();
      }

      await _fadeController.reverse();

      if (mounted) {
        setState(() {
          _isTransitioning = false;
        });
        await _fadeController.forward();
      }
    } catch (e) {
      debugPrint('❌ Error during transition animation: $e');
      // Ensure UI is in a consistent state even if animation fails
      if (mounted) {
        setState(() {
          _isTransitioning = false;
        });
        // Reset animation to forward state
        _fadeController.reset();
        _fadeController.forward();
      }
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
    } else if (lowerFileType == 'zip' ||
        lowerFileType == 'rar' ||
        lowerFileType.contains('archive')) {
      return Colors.brown;
    } else if (lowerFileType == 'txt' || lowerFileType.contains('text')) {
      return Colors.blueGrey;
    } else {
      return Colors.grey;
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

    // Handle both extension format (pdf, jpg) and descriptive format (PDF, Image)
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
      return Icons.video_file;
    } else if (lowerFileType == 'mp3' ||
        lowerFileType == 'wav' ||
        lowerFileType.contains('audio')) {
      return Icons.audio_file;
    } else if (lowerFileType == 'zip' ||
        lowerFileType == 'rar' ||
        lowerFileType.contains('archive')) {
      return Icons.archive;
    } else if (lowerFileType == 'txt' || lowerFileType.contains('text')) {
      return Icons.description;
    } else {
      return Icons.insert_drive_file;
    }
  }

  /// Format file size
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
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
      return DateFormat('MMM dd, yyyy').format(date);
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
      // We need to get all available documents from the provider
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );
      selectionProvider.enterSelectionMode(
        document,
        documentProvider.documents,
      );
    }
  }
}
