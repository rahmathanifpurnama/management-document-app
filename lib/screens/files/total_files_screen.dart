import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../features/documents/bloc/document_bloc.dart';
import '../../features/documents/bloc/document_event.dart';
import '../../features/documents/bloc/document_state.dart';
import '../../features/file_selection/providers/file_selection_providers.dart';
import '../../models/document_model.dart';

import '../../widgets/common/file_selection_bar.dart';
import '../../widgets/common/file_filter_widget.dart';
import '../../widgets/notification/bell_notification_widget.dart';
import '../../core/constants/app_routes.dart';
import '../../core/utils/context_filter_utils.dart';

/// File list section component for Total Files screen
class TotalFilesListSection extends ConsumerStatefulWidget {
  final String searchQuery;
  final Function(DocumentModel)? onDocumentTap;
  final Function(DocumentModel)? onDocumentMenu;
  final VoidCallback? onFilterTap;

  const TotalFilesListSection({
    super.key,
    required this.searchQuery,
    this.onDocumentTap,
    this.onDocumentMenu,
    this.onFilterTap,
  });

  @override
  ConsumerState<TotalFilesListSection> createState() =>
      _TotalFilesListSectionState();
}

class _TotalFilesListSectionState extends ConsumerState<TotalFilesListSection> {
  bool _isFirstTimeLoading = true;
  bool _hasDataCheckCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Use DocumentBloc to refresh documents
    context.read<DocumentBloc>().add(
      const DocumentEvent.refreshDocuments(forceRefresh: true),
    );

    if (mounted) {
      setState(() {
        _isFirstTimeLoading = false;
        _hasDataCheckCompleted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentBloc, DocumentState>(
      builder: (context, state) {
        final isSelectionMode = ref.watch(isSelectionModeProvider);

        // Get documents from DocumentBloc state
        final allDocuments = state.when(
          initial: () => <DocumentModel>[],
          loading: (_) => <DocumentModel>[],
          loaded:
              (
                documents,
                _,
                __,
                ___,
                ____,
                _____,
                ______,
                _______,
                ________,
                _________,
                __________,
                ___________,
                ____________,
              ) => documents,
          error: (_, __, ___) => <DocumentModel>[],
          loadingMore:
              (
                currentDocuments,
                _,
                __,
                ___,
                ____,
                _____,
                ______,
                _______,
                ________,
                _________,
              ) => currentDocuments,
          performingOperation:
              (
                _,
                currentDocuments,
                __,
                ___,
                ____,
                _____,
                ______,
                _______,
                ________,
                _________,
                __________,
              ) => currentDocuments,
          syncing: (_, currentDocuments, __) => currentDocuments,
        );

        // Get total files filter state
        final totalFilesFilterState = FilterStateManager.getState(
          FilterContext.totalFiles,
        );

        // Update search query in filter state if different
        if (totalFilesFilterState.searchQuery != widget.searchQuery) {
          totalFilesFilterState.searchQuery = widget.searchQuery;
        }

        // Apply context-aware filtering to all documents
        final displayDocuments = ContextFilterUtils.applyContextFilters(
          documents: allDocuments,
          context: FilterContext.totalFiles,
          filterState: totalFilesFilterState,
        );

        // Update available files for selection only when necessary
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (isSelectionMode) {
            ref
                .read(fileSelectionProvider.notifier)
                .updateAvailableFiles(displayDocuments);
          }
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Files Section
            _buildFilesSection(displayDocuments),
          ],
        );
      },
    );
  }

  Widget _buildFilesSection(List<DocumentModel> documents) {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveMargin = EdgeInsets.symmetric(
      horizontal: screenWidth < 400 ? 12.0 : 16.0,
    );

    return Container(
      margin: responsiveMargin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Files count and info
          _buildFilesHeader(documents),
          const SizedBox(height: 12),
          // Files list
          _buildFilesList(documents),
        ],
      ),
    );
  }

  Widget _buildFilesHeader(List<DocumentModel> documents) {
    return Row(
      children: [
        Icon(Icons.folder_open, color: AppColors.textSecondary, size: 20),
        const SizedBox(width: 8),
        Text(
          '${documents.length} file${documents.length != 1 ? 's' : ''} ditemukan',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFilesList(List<DocumentModel> documents) {
    return BlocBuilder<DocumentBloc, DocumentState>(
      builder: (context, state) {
        // Check loading state from DocumentBloc
        final isLoading = state.when(
          initial: () => false,
          loading: (_) => true,
          loaded:
              (
                _,
                __,
                ___,
                ____,
                _____,
                ______,
                _______,
                ________,
                _________,
                __________,
                ___________,
                ____________,
                _____________,
              ) => false,
          error: (_, __, ___) => false,
          loadingMore:
              (
                _,
                __,
                ___,
                ____,
                _____,
                ______,
                _______,
                ________,
                _________,
                __________,
              ) => false,
          performingOperation:
              (
                _,
                __,
                ___,
                ____,
                _____,
                ______,
                _______,
                ________,
                _________,
                __________,
                ___________,
              ) => true,
          syncing: (_, __, ___) => true,
        );

        // Show loading state for first-time loading
        if (_isFirstTimeLoading || !_hasDataCheckCompleted) {
          final screenWidth = MediaQuery.of(context).size.width;
          final isSmallScreen = screenWidth < 400;
          final progressIndicatorSize = isSmallScreen ? 48.0 : 56.0;
          final textSpacing = isSmallScreen ? 12.0 : 16.0;
          final fontSize = isSmallScreen ? 15.0 : 16.0;

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: progressIndicatorSize,
                  height: progressIndicatorSize,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(height: textSpacing),
                Text(
                  'Memuat semua file...',
                  style: GoogleFonts.poppins(
                    fontSize: fontSize,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Show loading indicator during refresh
        if (isLoading && documents.isNotEmpty) {
          return Column(
            children: [
              _buildActualFilesList(documents),
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Memperbarui...',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        // Show empty state after data check is complete
        if (documents.isEmpty && !isLoading && _hasDataCheckCompleted) {
          return _buildEmptyState();
        }

        // Return the actual files list
        return _buildActualFilesList(documents);
      },
    );
  }

  Widget _buildEmptyState() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final iconSize = isSmallScreen ? 64.0 : 80.0;
    final titleFontSize = isSmallScreen ? 16.0 : 18.0;
    final subtitleFontSize = isSmallScreen ? 13.0 : 14.0;
    final spacing = isSmallScreen ? 12.0 : 16.0;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 32 : 48,
        horizontal: 16,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: iconSize,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          SizedBox(height: spacing),
          Text(
            'Tidak ada file ditemukan',
            style: GoogleFonts.poppins(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing / 2),
          Text(
            'Coba ubah filter atau kata kunci pencarian Anda',
            style: GoogleFonts.poppins(
              fontSize: subtitleFontSize,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActualFilesList(List<DocumentModel> documents) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: documents.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final document = documents[index];
        final selectedFileIds = ref.watch(selectedFileIdsProvider);
        final isSelected = selectedFileIds.contains(document.id);

        return _buildFileItem(document, isSelected);
      },
    );
  }

  Widget _buildFileItem(DocumentModel document, bool isSelected) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final responsiveElevation = 2.0;
    final responsiveBorderRadius = isSmallScreen ? 8.0 : 12.0;
    final responsivePadding = EdgeInsets.all(isSmallScreen ? 12.0 : 16.0);

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryLight : AppColors.surface,
        borderRadius: BorderRadius.circular(responsiveBorderRadius),
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : AppColors.border.withValues(alpha: 0.3),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: responsiveElevation * 2,
            offset: Offset(0, responsiveElevation / 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(responsiveBorderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(responsiveBorderRadius),
          onTap: () {
            final isSelectionMode = ref.read(isSelectionModeProvider);
            if (isSelectionMode) {
              ref
                  .read(fileSelectionProvider.notifier)
                  .toggleFileSelection(document.id);
            } else {
              widget.onDocumentTap?.call(document);
            }
          },
          onLongPress: () {
            final isSelectionMode = ref.read(isSelectionModeProvider);
            if (!isSelectionMode) {
              // Get all available documents from DocumentBloc
              final documentBloc = context.read<DocumentBloc>();
              final currentState = documentBloc.state;
              final allDocuments = currentState.when(
                initial: () => <DocumentModel>[],
                loading: (_) => <DocumentModel>[],
                loaded:
                    (
                      documents,
                      _,
                      __,
                      ___,
                      ____,
                      _____,
                      ______,
                      _______,
                      ________,
                      _________,
                      __________,
                      ___________,
                      ____________,
                    ) => documents,
                error: (_, __, ___) => <DocumentModel>[],
                loadingMore:
                    (
                      currentDocuments,
                      _,
                      __,
                      ___,
                      ____,
                      _____,
                      ______,
                      _______,
                      ________,
                      _________,
                    ) => currentDocuments,
                performingOperation:
                    (
                      _,
                      currentDocuments,
                      __,
                      ___,
                      ____,
                      _____,
                      ______,
                      _______,
                      ________,
                      _________,
                      __________,
                    ) => currentDocuments,
                syncing: (_, currentDocuments, __) => currentDocuments,
              );
              ref
                  .read(fileSelectionProvider.notifier)
                  .enterSelectionMode(document, allDocuments);
            }
          },
          child: Padding(
            padding: responsivePadding,
            child: Row(
              children: [
                // Selection checkbox (when in selection mode)
                if (ref.watch(isSelectionModeProvider)) ...[
                  Checkbox(
                    value: isSelected,
                    onChanged: (value) {
                      ref
                          .read(fileSelectionProvider.notifier)
                          .toggleFileSelection(document.id);
                    },
                    activeColor: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                ],

                // File icon
                _buildFileIcon(document),
                const SizedBox(width: 12),

                // File info
                Expanded(child: _buildFileInfo(document)),

                // Menu button (when not in selection mode)
                if (!ref.watch(isSelectionModeProvider))
                  IconButton(
                    onPressed: () => widget.onDocumentMenu?.call(document),
                    icon: Icon(
                      Icons.more_vert,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    tooltip: 'More options',
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileIcon(DocumentModel document) {
    IconData iconData;
    Color iconColor;

    // Determine icon based on file type
    final fileExtension = document.fileName.split('.').last.toLowerCase();
    switch (fileExtension) {
      case 'pdf':
        iconData = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case 'doc':
      case 'docx':
        iconData = Icons.description;
        iconColor = Colors.blue;
        break;
      case 'xls':
      case 'xlsx':
        iconData = Icons.table_chart;
        iconColor = Colors.green;
        break;
      case 'ppt':
      case 'pptx':
        iconData = Icons.slideshow;
        iconColor = Colors.orange;
        break;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        iconData = Icons.image;
        iconColor = Colors.purple;
        break;
      case 'txt':
        iconData = Icons.text_snippet;
        iconColor = Colors.grey;
        break;
      default:
        iconData = Icons.insert_drive_file;
        iconColor = AppColors.textSecondary;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(iconData, color: iconColor, size: 24),
    );
  }

  Widget _buildFileInfo(DocumentModel document) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final titleFontSize = isSmallScreen ? 14.0 : 15.0;
    final subtitleFontSize = isSmallScreen ? 11.0 : 12.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // File name
        Text(
          document.fileName,
          style: GoogleFonts.poppins(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),

        // File details
        Row(
          children: [
            // Category
            if (document.category.isNotEmpty) ...[
              Icon(Icons.folder, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                document.category,
                style: GoogleFonts.poppins(
                  fontSize: subtitleFontSize,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
            ],

            // Upload date
            Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              _formatDate(document.uploadedAt),
              style: GoogleFonts.poppins(
                fontSize: subtitleFontSize,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hari ini';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

/// Search section component for Total Files screen
class TotalFilesSearchSection extends StatefulWidget {
  final TextEditingController searchController;
  final VoidCallback? onSearchChanged;

  const TotalFilesSearchSection({
    super.key,
    required this.searchController,
    this.onSearchChanged,
  });

  @override
  State<TotalFilesSearchSection> createState() =>
      _TotalFilesSearchSectionState();
}

class _TotalFilesSearchSectionState extends State<TotalFilesSearchSection> {
  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    widget.onSearchChanged?.call();
  }

  void _clearSearch() {
    widget.searchController.clear();
    widget.onSearchChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveMargin = EdgeInsets.only(
      left: screenWidth < 400 ? 12.0 : 16.0,
      right: screenWidth < 400 ? 12.0 : 16.0,
      top: 0,
      bottom: 0,
    );
    final responsiveElevation = 2.0;

    return Container(
      margin: responsiveMargin,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: responsiveElevation * 2,
            offset: Offset(0, responsiveElevation / 2),
          ),
        ],
      ),
      child: _SearchField(
        controller: widget.searchController,
        onClear: _clearSearch,
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;

  const _SearchField({required this.controller, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveBorderRadius = screenWidth < 400 ? 8.0 : 12.0;
    final fontSize = screenWidth < 400 ? 14.0 : 15.0;
    final iconSize = screenWidth < 400 ? 20.0 : 22.0;
    final horizontalPadding = screenWidth < 400 ? 12.0 : 16.0;
    final verticalPadding = screenWidth < 400 ? 12.0 : 14.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(responsiveBorderRadius),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Cari semua file...',
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

    return IconButton(
      onPressed: onClear,
      icon: Icon(Icons.clear, color: AppColors.textSecondary, size: 20),
      tooltip: 'Clear search',
    );
  }
}

class TotalFilesScreen extends ConsumerStatefulWidget {
  const TotalFilesScreen({super.key});

  @override
  ConsumerState<TotalFilesScreen> createState() => _TotalFilesScreenState();
}

class _TotalFilesScreenState extends ConsumerState<TotalFilesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<_TotalFilesListSectionState> _fileListKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    // Use DocumentBloc to load documents
    context.read<DocumentBloc>().add(const DocumentEvent.loadDocuments());
  }

  void _performSearch() {
    // Trigger rebuild of file list with new search query
    _fileListKey.currentState?.setState(() {});
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FileFilterWidget(
        filterContext: FilterContext.totalFiles,
        mode: FileFilterMode.modal,
        onFilterApplied: () {
          Navigator.pop(context);
          // Trigger rebuild of file list with new filters
          _fileListKey.currentState?.setState(() {});
        },
      ),
    );
  }

  void _navigateToFilePreview(DocumentModel document) {
    Navigator.of(context).pushNamed(AppRoutes.filePreview, arguments: document);
  }

  void _showDocumentMenu(DocumentModel document) {
    // Implementation for document menu
    // This can be expanded based on requirements
  }

  void _onExitSelectionMode() {
    ref.read(fileSelectionProvider.notifier).exitSelectionMode();
  }

  Future<void> _refreshData() async {
    // Use DocumentBloc to refresh documents
    context.read<DocumentBloc>().add(
      const DocumentEvent.refreshDocuments(forceRefresh: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua File'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: const [BellNotificationWidget()],
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.chevron_left, size: 28, color: Colors.white),
          tooltip: 'Back',
        ),
      ),
      body: Column(
        children: [
          // File selection bar (appears when files are selected)
          FileSelectionBar(onExitSelection: _onExitSelectionMode),
          // Main content
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSpacing = screenWidth < 400 ? 8.0 : 12.0;

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          color: AppColors.background,
          child: Column(
            children: [
              SizedBox(height: responsiveSpacing),

              // Search Section
              TotalFilesSearchSection(
                searchController: _searchController,
                onSearchChanged: _performSearch,
              ),

              SizedBox(height: responsiveSpacing),

              // Title and Filter Section
              _buildTitleAndFilterSection(),

              SizedBox(height: responsiveSpacing / 2),

              // File List Section
              TotalFilesListSection(
                key: _fileListKey,
                searchQuery: _searchController.text,
                onDocumentTap: _navigateToFilePreview,
                onDocumentMenu: _showDocumentMenu,
                onFilterTap: _showFilterMenu,
              ),

              SizedBox(height: responsiveSpacing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndFilterSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveMargin = EdgeInsets.symmetric(
      horizontal: screenWidth < 400 ? 12.0 : 16.0,
    );

    return Container(
      margin: responsiveMargin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title
          Text(
            'Semua File',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          // Filter Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: _showFilterMenu,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.filter_list,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
