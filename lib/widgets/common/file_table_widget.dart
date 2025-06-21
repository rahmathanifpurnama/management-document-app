import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/document_model.dart';
import '../../services/share_service.dart';
import '../../services/file_download_service.dart';
import '../../providers/document_provider.dart';
import '../../providers/auth_provider.dart';
import 'empty_state_widget.dart';
import 'enhanced_deletion_loading.dart';
import 'share_button_widget.dart';

enum FileTableMode {
  view, // View only (like home screen)
  select, // Selection mode (like add files to category)
  manage, // Management mode (like category files)
}

enum TableColumnType {
  checkbox,
  fileName,
  fileType,
  fileSize,
  uploadDate,
  owner,
  status,
  actions,
  share,
  custom,
}

class TableColumn {
  final TableColumnType type;
  final String title;
  final TableColumnWidth width;
  final TextAlign alignment;
  final bool isCheckbox;
  final String Function(DocumentModel)? customValue;

  const TableColumn({
    required this.type,
    required this.title,
    required this.width,
    this.alignment = TextAlign.left,
    this.isCheckbox = false,
    this.customValue,
  });
}

class FileTableWidget extends StatefulWidget {
  final List<DocumentModel> documents;
  final FileTableMode mode;
  final String title;

  final bool showFilter;
  final bool showRefresh;
  final bool showSelectAll;
  final bool showShare;
  final bool isLoading;
  final bool enableIntegratedOperations; // New: Enable built-in file operations
  final Set<String>? selectedFiles;
  final VoidCallback? onRefresh;
  final VoidCallback? onFilter;
  final VoidCallback? onShare;
  final Function(DocumentModel)? onDocumentTap;
  final Function(DocumentModel)? onDocumentMenu;
  final Function(DocumentModel)? onDocumentShare;
  final Function(String, bool)? onFileSelect;
  final Function(bool?)? onSelectAll;
  final Widget? emptyStateWidget;
  final List<TableColumn>? customColumns;
  final double? maxHeight;
  final bool enableScroll;
  final double? bottomSpacing;
  final BorderRadius? borderRadius;

  const FileTableWidget({
    super.key,
    required this.documents,
    this.mode = FileTableMode.view,
    this.title = 'Files',
    this.showFilter = true,
    this.showRefresh = false,
    this.showSelectAll = false,
    this.showShare = false,
    this.isLoading = false,
    this.enableIntegratedOperations = false,
    this.selectedFiles,
    this.onRefresh,
    this.onFilter,
    this.onShare,
    this.onDocumentTap,
    this.onDocumentMenu,
    this.onDocumentShare,
    this.onFileSelect,
    this.onSelectAll,
    this.emptyStateWidget,
    this.customColumns,
    this.maxHeight,
    this.enableScroll = true,
    this.bottomSpacing,
    this.borderRadius,
  });

  /// Factory constructor for home screen usage with integrated operations
  factory FileTableWidget.forHomeScreen({
    required List<DocumentModel> documents,
    Function(DocumentModel)? onDocumentTap,
    VoidCallback? onFilter,
  }) {
    return FileTableWidget(
      documents: documents,
      mode: FileTableMode.manage,
      title: 'Recent Files',
      showFilter: true,
      showRefresh: false,
      enableScroll: false,
      bottomSpacing: 0,
      enableIntegratedOperations: true,
      onFilter: onFilter,
      onDocumentTap: onDocumentTap,
      emptyStateWidget: EmptyStateWidget.noDocuments(
        showContainer: false,
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 32),
      ),
      customColumns: [
        TableColumn(
          type: TableColumnType.fileName,
          title: 'Name',
          width: const FlexColumnWidth(7),
        ),
        TableColumn(
          type: TableColumnType.uploadDate,
          title: 'Date',
          width: const FlexColumnWidth(2),
          alignment: TextAlign.center,
        ),
        TableColumn(
          type: TableColumnType.actions,
          title: 'Action',
          width: const FixedColumnWidth(50),
          alignment: TextAlign.center,
        ),
      ],
    );
  }

  /// Factory constructor for category files with selection mode
  factory FileTableWidget.forCategoryFiles({
    required List<DocumentModel> documents,
    Function(DocumentModel)? onDocumentTap,
    VoidCallback? onFilter,
  }) {
    return FileTableWidget(
      documents: documents,
      mode: FileTableMode.manage,
      title: 'Category Files',
      showFilter: true,
      showRefresh: false,
      enableIntegratedOperations: true,
      onFilter: onFilter,
      onDocumentTap: onDocumentTap,
    );
  }

  @override
  State<FileTableWidget> createState() => _FileTableWidgetState();
}

class _FileTableWidgetState extends State<FileTableWidget> {
  final ScrollController _scrollController = ScrollController();

  // Integrated services for file operations
  late final ShareService _shareService;
  late final FileDownloadService _downloadService;

  @override
  void initState() {
    super.initState();
    if (widget.enableIntegratedOperations) {
      _shareService = ShareService();
      _downloadService = FileDownloadService();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with title and actions
          if (widget.title.isNotEmpty) ...[_buildHeader()],
          // Modern file list container
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Table Header
                _buildTableHeader(),
                // Table Content
                widget.isLoading
                    ? _buildLoadingState()
                    : widget.documents.isEmpty
                    ? _buildEmptyState()
                    : _buildTableContent(),
              ],
            ),
          ),
          SizedBox(
            height: widget.bottomSpacing ?? 100,
            child: const SizedBox.shrink(), // Configurable bottom spacing
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
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
        Row(
          children: [
            if (widget.showShare && widget.onShare != null)
              IconButton(
                onPressed: widget.onShare,
                icon: const Icon(
                  Icons.share,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                tooltip: 'Share All Files',
              ),
            if (widget.showRefresh && widget.onRefresh != null)
              IconButton(
                onPressed: widget.onRefresh,
                icon: const Icon(
                  Icons.refresh,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                tooltip: 'Refresh',
              ),
            if (widget.showFilter && widget.onFilter != null)
              IconButton(
                onPressed: widget.onFilter,
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
      ],
    );
  }

  Widget _buildTableHeader() {
    final columns = widget.customColumns ?? _getDefaultColumns();
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(16);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: borderRadius.topLeft,
          topRight: borderRadius.topRight,
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.border.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Table(
        columnWidths: _getColumnWidths(columns),
        children: [
          TableRow(
            children: columns.map((column) {
              if (column.isCheckbox && widget.mode == FileTableMode.select) {
                return TableCell(
                  child: widget.showSelectAll
                      ? Checkbox(
                          value:
                              widget.selectedFiles?.length ==
                                  widget.documents.length &&
                              widget.documents.isNotEmpty,
                          onChanged: widget.onSelectAll,
                          activeColor: AppColors.primary,
                        )
                      : const SizedBox.shrink(),
                );
              }
              return TableCell(
                child: Text(
                  column.title,
                  style: _getTableHeaderStyle(),
                  textAlign: column.alignment,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTableContent() {
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(16);
    final content = Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          bottomLeft: borderRadius.bottomLeft,
          bottomRight: borderRadius.bottomRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...widget.documents.map((document) => _buildDocumentRow(document)),
          const SizedBox(height: 4), // Bottom padding
        ],
      ),
    );

    // If scroll is enabled and maxHeight is specified, wrap in scrollable container
    if (widget.enableScroll && widget.maxHeight != null) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: widget.maxHeight!),
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          trackVisibility: true,
          thickness: 6.0,
          radius: const Radius.circular(3.0),
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            child: content,
          ),
        ),
      );
    }

    // If scroll is enabled but no maxHeight specified, calculate dynamic height
    if (widget.enableScroll) {
      return LayoutBuilder(
        builder: (context, constraints) {
          // Calculate available height dynamically
          final screenHeight = MediaQuery.of(context).size.height;
          final appBarHeight = AppBar().preferredSize.height;
          final statusBarHeight = MediaQuery.of(context).padding.top;
          final bottomNavHeight = 80.0; // Approximate bottom navigation height
          final bottomSpacing = widget.bottomSpacing ?? 100;
          final headerHeight = widget.title.isNotEmpty
              ? 60.0
              : 0.0; // Approximate header height
          final tableHeaderHeight = 50.0; // Approximate table header height

          final availableHeight =
              screenHeight -
              statusBarHeight -
              appBarHeight -
              bottomNavHeight -
              bottomSpacing -
              headerHeight -
              tableHeaderHeight -
              32; // Additional padding

          final maxHeight = availableHeight > 200 ? availableHeight : 400.0;

          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              trackVisibility: true,
              thickness: 6.0,
              radius: const Radius.circular(3.0),
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                child: content,
              ),
            ),
          );
        },
      );
    }

    // Return original content without scroll
    return content;
  }

  Widget _buildDocumentRow(DocumentModel document) {
    final columns = widget.customColumns ?? _getDefaultColumns();
    final isSelected = widget.selectedFiles?.contains(document.id) ?? false;

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
          onTap: widget.onDocumentTap != null
              ? () => widget.onDocumentTap!(document)
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Table(
              columnWidths: _getColumnWidths(columns),
              children: [
                TableRow(
                  children: columns.map((column) {
                    return TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: _buildCellContent(column, document),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCellContent(TableColumn column, DocumentModel document) {
    switch (column.type) {
      case TableColumnType.checkbox:
        if (widget.mode == FileTableMode.select) {
          final isSelected =
              widget.selectedFiles?.contains(document.id) ?? false;
          return Checkbox(
            value: isSelected,
            onChanged: widget.onFileSelect != null
                ? (value) => widget.onFileSelect!(document.id, value ?? false)
                : null,
            activeColor: AppColors.primary,
          );
        }
        return const SizedBox.shrink();

      case TableColumnType.fileName:
        return Row(
          children: [
            // Enhanced file type indicator
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getFileTypeColor(document.fileType).withValues(alpha: 0.8),
                    _getFileTypeColor(document.fileType).withValues(alpha: 0.6),
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
              child: Center(
                child: Icon(
                  _getFileTypeIcon(document.fileType),
                  color: Colors.white,
                  size: 24,
                ),
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
        );

      case TableColumnType.fileType:
        return Text(
          _getFileTypeLabel(document.fileType),
          style: _getTableTextStyle(),
          textAlign: column.alignment,
        );

      case TableColumnType.fileSize:
        return Text(
          _formatFileSize(document.fileSize),
          style: _getTableTextStyle(),
          textAlign: column.alignment,
        );

      case TableColumnType.uploadDate:
        return Column(
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
        );

      case TableColumnType.owner:
        return Text(
          document.uploadedBy,
          style: _getTableTextStyle(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: column.alignment,
        );

      case TableColumnType.status:
        // Status column removed - all files are active
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'ACTIVE',
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.green,
            ),
          ),
        );

      case TableColumnType.actions:
        return Center(
          child: widget.enableIntegratedOperations
              ? _buildIntegratedActionsMenu(document)
              : Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.border.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    onPressed: widget.onDocumentMenu != null
                        ? () => widget.onDocumentMenu!(document)
                        : null,
                    icon: const Icon(
                      Icons.more_vert,
                      color: AppColors.textSecondary,
                      size: 18,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                ),
        );

      case TableColumnType.share:
        return Center(
          child: ShareButtonWidget(
            document: document,
            style: ShareButtonStyle.icon,
            onShareComplete: widget.onDocumentShare != null
                ? () => widget.onDocumentShare!(document)
                : null,
          ),
        );

      case TableColumnType.custom:
        return Text(
          column.customValue?.call(document) ?? '',
          style: _getTableTextStyle(),
          textAlign: column.alignment,
        );
    }
  }

  Widget _buildEmptyState() {
    if (widget.emptyStateWidget != null) {
      return widget.emptyStateWidget!;
    }

    return const FileTableEmptyState();
  }

  Widget _buildLoadingState() {
    return SimpleTableLoading(borderRadius: widget.borderRadius);
  }

  /// Build integrated actions menu with built-in file operations
  Widget _buildIntegratedActionsMenu(DocumentModel document) {
    return PopupMenuButton<String>(
      icon: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: const Icon(
          Icons.more_vert,
          color: AppColors.textSecondary,
          size: 18,
        ),
      ),
      onSelected: (value) => _handleIntegratedAction(value, document),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'download',
          child: Row(
            children: [
              const Icon(Icons.download, size: 18),
              const SizedBox(width: 8),
              Text('Download', style: GoogleFonts.poppins(fontSize: 14)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'share',
          child: Row(
            children: [
              const Icon(Icons.share, size: 18),
              const SizedBox(width: 8),
              Text('Share', style: GoogleFonts.poppins(fontSize: 14)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'details',
          child: Row(
            children: [
              const Icon(Icons.info_outline, size: 18),
              const SizedBox(width: 8),
              Text('Details', style: GoogleFonts.poppins(fontSize: 14)),
            ],
          ),
        ),
        // ADMIN-ONLY: Only show delete option for admin users
        if (_isCurrentUserAdmin())
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                const Icon(Icons.delete, color: Colors.red, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Delete',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.red),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// Handle integrated file operations
  Future<void> _handleIntegratedAction(
    String action,
    DocumentModel document,
  ) async {
    switch (action) {
      case 'download':
        await _handleDownload(document);
        break;
      case 'share':
        await _handleShare(document);
        break;
      case 'details':
        _handleDetails(document);
        break;
      case 'delete':
        _handleDelete(document);
        break;
    }
  }

  /// Handle file download with integrated service
  Future<void> _handleDownload(DocumentModel document) async {
    try {
      if (!mounted) return;

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
          duration: const Duration(seconds: 3),
        ),
      );

      await _downloadService.downloadFile(document);

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${document.fileName} downloaded successfully'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Handle file sharing with integrated service
  Future<void> _handleShare(DocumentModel document) async {
    try {
      if (!mounted) return;

      // Show confirmation dialog before sharing
      final confirmed = await _showShareConfirmationDialog(document);
      if (!confirmed || !mounted) return;

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
                child: Text(
                  'Uploading ${document.displayFileName} to Google Drive...',
                ),
              ),
            ],
          ),
          duration: const Duration(minutes: 5), // Longer duration for upload
          backgroundColor: Colors.blue,
        ),
      );

      await _shareService.shareFileWithLink(
        document: document,
        linkExpiration: const Duration(hours: 24),
        customMessage: 'Sharing document from Management Doc:',
        onProgress: (progress) {
          debugPrint('Upload progress: ${(progress * 100).toInt()}%');
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${document.displayFileName} uploaded to Google Drive and shared!',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Failed to upload to Google Drive: ${e.toString()}',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  /// Handle document details display
  void _handleDetails(DocumentModel document) {
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
            _buildDetailRow(
              'Name',
              document.displayFileName,
            ), // Use clean display name
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

  /// Handle document deletion
  void _handleDelete(DocumentModel document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete File',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete "${document.fileName}"? This action cannot be undone.',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _performDelete(document);
            },
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
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

  /// Perform actual file deletion
  Future<void> _performDelete(DocumentModel document) async {
    try {
      if (!mounted) return;

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

      // Show enhanced deletion loading dialog
      showEnhancedDeletionLoading(
        context: context,
        fileName: document.fileName,
        operationType: 'single',
      );

      try {
        // Use Provider to delete document
        final documentProvider = Provider.of<DocumentProvider>(
          context,
          listen: false,
        );
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final currentUserId = authProvider.currentUser?.id ?? 'unknown';

        // ENHANCED DEBUG: Log detailed information before deletion
        debugPrint(
          '🗑️ UI: Starting enhanced deletion for document: ${document.id}',
        );
        debugPrint('📁 UI: Document fileName: ${document.fileName}');
        debugPrint('📁 UI: Document filePath: ${document.filePath}');
        debugPrint('👤 UI: Document uploadedBy: ${document.uploadedBy}');
        debugPrint('👤 UI: Current user: $currentUserId');

        await documentProvider.removeDocument(document.id, currentUserId);

        // Close loading dialog and show success
        if (mounted) {
          Navigator.of(context).pop(); // Close loading dialog

          showDialog(
            context: context,
            builder: (context) => EnhancedDeletionResult(
              success: true,
              message: '${document.fileName} deleted successfully',
              onClose: () => Navigator.of(context).pop(),
            ),
          );
        }
      } catch (deleteError) {
        // Close loading dialog and show error
        if (mounted) {
          Navigator.of(context).pop(); // Close loading dialog

          showDialog(
            context: context,
            builder: (context) => EnhancedDeletionResult(
              success: false,
              message: 'Failed to delete ${document.fileName}',
              errorDetails: deleteError.toString(),
              onRetry: () {
                Navigator.of(context).pop();
                _performDelete(document); // Retry deletion
              },
              onClose: () => Navigator.of(context).pop(),
            ),
          );
        }

        // Re-throw for outer catch block
        rethrow;
      }
    } catch (e) {
      // ENHANCED DEBUG: Log detailed error information
      debugPrint('❌ UI: Delete operation failed for ${document.fileName}');
      debugPrint('❌ UI: Error details: $e');
      debugPrint('❌ UI: Error type: ${e.runtimeType}');

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delete failed: ${document.fileName}'),
                Text(
                  'Error: ${e.toString()}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  /// Build detail row for document details dialog
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

  /// Show confirmation dialog before sharing file
  Future<bool> _showShareConfirmationDialog(DocumentModel document) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Confirm Share',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              content: Text(
                'Are you sure you want to share "${document.fileName}"? This will generate a shareable link for this file.',
                style: GoogleFonts.poppins(color: AppColors.textSecondary),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(color: AppColors.textSecondary),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textWhite,
                  ),
                  child: Text(
                    'Share',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  // Helper methods
  List<TableColumn> _getDefaultColumns() {
    switch (widget.mode) {
      case FileTableMode.select:
        return [
          TableColumn(
            type: TableColumnType.checkbox,
            title: '',
            width: const FixedColumnWidth(1000),
            isCheckbox: true,
          ),
          TableColumn(
            type: TableColumnType.fileName,
            title: 'File Name',
            width: const FlexColumnWidth(10),
          ),
          TableColumn(
            type: TableColumnType.fileType,
            title: 'Type',
            width: const FlexColumnWidth(10),
          ),
          TableColumn(
            type: TableColumnType.uploadDate,
            title: 'Date',
            width: const FlexColumnWidth(10),
          ),
        ];

      case FileTableMode.manage:
        return [
          TableColumn(
            type: TableColumnType.fileName,
            title: 'Name',
            width: const FlexColumnWidth(4),
          ),
          TableColumn(
            type: TableColumnType.fileType,
            title: 'Type',
            width: const FlexColumnWidth(2),
            alignment: TextAlign.center,
          ),
          TableColumn(
            type: TableColumnType.uploadDate,
            title: 'Date',
            width: const FlexColumnWidth(2),
            alignment: TextAlign.center,
          ),
          TableColumn(
            type: TableColumnType.actions,
            title: 'Action',
            width: const FixedColumnWidth(50),
            alignment: TextAlign.center,
          ),
        ];

      case FileTableMode.view:
        return [
          TableColumn(
            type: TableColumnType.fileName,
            title: 'Name',
            width: const FlexColumnWidth(5),
          ),
          TableColumn(
            type: TableColumnType.uploadDate,
            title: 'Date',
            width: const FlexColumnWidth(1),
            alignment: TextAlign.center,
          ),
          TableColumn(
            type: TableColumnType.actions,
            title: 'Action',
            width: const FixedColumnWidth(50),
            alignment: TextAlign.center,
          ),
        ];
    }
  }

  Map<int, TableColumnWidth> _getColumnWidths(List<TableColumn> columns) {
    final Map<int, TableColumnWidth> widths = {};
    for (int i = 0; i < columns.length; i++) {
      widths[i] = columns[i].width;
    }
    return widths;
  }

  TextStyle _getTableHeaderStyle() {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    );
  }

  TextStyle _getTableTextStyle() {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w400,
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
    if (lowerFileType.contains('doc') ||
        lowerFileType.contains('word') ||
        lowerFileType.contains('msword')) {
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

    // Video files
    if (lowerFileType.contains('video')) {
      return Icons.video_file;
    }

    // Audio files
    if (lowerFileType.contains('audio')) {
      return Icons.audio_file;
    }

    // Default file icon
    return Icons.insert_drive_file;
  }

  Color _getFileTypeColor(String fileType) {
    final lowerFileType = fileType.toLowerCase();

    // PDF files
    if (lowerFileType.contains('pdf')) {
      return Colors.red;
    }

    // Word documents (doc, docx)
    if (lowerFileType.contains('doc') ||
        lowerFileType.contains('word') ||
        lowerFileType.contains('msword')) {
      return Colors.blue;
    }

    // Excel files (xlsx, xls, spreadsheet)
    if (lowerFileType.contains('xlsx') ||
        lowerFileType.contains('xls') ||
        lowerFileType.contains('excel') ||
        lowerFileType.contains('sheet') ||
        lowerFileType.contains('spreadsheet')) {
      return Colors.green;
    }

    // PowerPoint files (ppt, pptx)
    if (lowerFileType.contains('ppt') ||
        lowerFileType.contains('powerpoint') ||
        lowerFileType.contains('presentation')) {
      return Colors.orange;
    }

    // Image files (jpg, png, jpeg, gif)
    if (lowerFileType.contains('image') ||
        lowerFileType.contains('jpg') ||
        lowerFileType.contains('jpeg') ||
        lowerFileType.contains('png') ||
        lowerFileType.contains('gif')) {
      return Colors.purple;
    }

    // Video files
    if (lowerFileType.contains('video')) {
      return Colors.pink;
    }

    // Audio files
    if (lowerFileType.contains('audio')) {
      return Colors.teal;
    }

    // Default color
    return AppColors.textSecondary;
  }

  String _getFileTypeLabel(String fileType) {
    final lowerFileType = fileType.toLowerCase();

    // PDF files
    if (lowerFileType.contains('pdf')) {
      return 'PDF';
    }

    // Word documents (doc, docx)
    if (lowerFileType.contains('doc') ||
        lowerFileType.contains('word') ||
        lowerFileType.contains('msword')) {
      return 'DOC';
    }

    // Excel files (xlsx, xls, spreadsheet)
    if (lowerFileType.contains('xlsx') ||
        lowerFileType.contains('xls') ||
        lowerFileType.contains('excel') ||
        lowerFileType.contains('sheet') ||
        lowerFileType.contains('spreadsheet')) {
      return 'XLS';
    }

    // PowerPoint files (ppt, pptx)
    if (lowerFileType.contains('ppt') ||
        lowerFileType.contains('powerpoint') ||
        lowerFileType.contains('presentation')) {
      return 'PPT';
    }

    // Image files (jpg, png, jpeg, gif)
    if (lowerFileType.contains('image') ||
        lowerFileType.contains('jpg') ||
        lowerFileType.contains('jpeg') ||
        lowerFileType.contains('png') ||
        lowerFileType.contains('gif')) {
      return 'IMG';
    }

    // Video files
    if (lowerFileType.contains('video')) {
      return 'VID';
    }

    // Audio files
    if (lowerFileType.contains('audio')) {
      return 'AUD';
    }

    // Default label
    return 'FILE';
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

  String _formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
}

/// Simple loading animation for file tables
class SimpleTableLoading extends StatelessWidget {
  final BorderRadius? borderRadius;

  const SimpleTableLoading({super.key, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          bottomLeft: borderRadius?.bottomLeft ?? const Radius.circular(16),
          bottomRight: borderRadius?.bottomRight ?? const Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Simple circular loading indicator
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),
              // Loading text
              Text(
                'Loading files...',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
