import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_colors.dart';
import '../../models/document_model.dart';
import '../../providers/document_provider.dart';
import '../../widgets/common/reusable_file_list_widget.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../core/constants/app_routes.dart';

class RecycleBinScreen extends StatefulWidget {
  const RecycleBinScreen({super.key});

  @override
  State<RecycleBinScreen> createState() => _RecycleBinScreenState();
}

class _RecycleBinScreenState extends State<RecycleBinScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRecycleBinFiles();
  }

  Future<void> _loadRecycleBinFiles() async {
    setState(() => _isLoading = true);
    try {
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );
      await documentProvider.loadDocuments();
    } catch (e) {
      debugPrint('Error loading recycle bin files: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Recycle Bin',
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<DocumentProvider>(
            builder: (context, documentProvider, child) {
              final recycleBinFiles = documentProvider.getRecycleBinFiles();
              if (recycleBinFiles.isNotEmpty) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    switch (value) {
                      case 'empty_bin':
                        _showEmptyBinDialog();
                        break;
                      case 'restore_all':
                        _showRestoreAllDialog();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'restore_all',
                      child: Row(
                        children: [
                          Icon(Icons.restore, color: AppColors.success),
                          SizedBox(width: 8),
                          Text('Restore All'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'empty_bin',
                      child: Row(
                        children: [
                          Icon(Icons.delete_forever, color: AppColors.error),
                          SizedBox(width: 8),
                          Text('Empty Recycle Bin'),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Container(color: const Color(0xFFF5F5F5), child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return Consumer<DocumentProvider>(
      builder: (context, documentProvider, child) {
        if (_isLoading || documentProvider.isLoading) {
          return _buildLoadingState();
        }

        final recycleBinFiles = documentProvider.getRecycleBinFiles();

        if (recycleBinFiles.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          children: [
            _buildHeader(recycleBinFiles.length),
            Expanded(
              child: ReusableFileListWidget(
                documents: recycleBinFiles,
                title: '',
                showFilter: false,
                showPagination: true,
                itemsPerPage: 25,
                emptyStateMessage: 'Recycle bin is empty',
                emptyStateIcon: Icons.delete_outline,
                onDocumentTap: _handleDocumentTap,
                onDocumentMenu: _showDocumentMenu,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(int fileCount) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icon/recycle-bin.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deleted Files',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '$fileCount ${fileCount == 1 ? 'file' : 'files'} in recycle bin',
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
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyStateWidget(
      icon: Icons.delete_outline,
      title: 'Recycle Bin is Empty',
      subtitle: 'Deleted files will appear here',
      actionButton: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textWhite,
        ),
        child: const Text('Go Back'),
      ),
    );
  }

  void _handleDocumentTap(DocumentModel document) {
    // Show document details or preview
    Navigator.pushNamed(context, AppRoutes.filePreview, arguments: document);
  }

  void _showDocumentMenu(DocumentModel document) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildDocumentMenuSheet(document),
    );
  }

  Widget _buildDocumentMenuSheet(DocumentModel document) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  document.fileName,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                _buildMenuOption(
                  icon: Icons.restore,
                  title: 'Restore File',
                  subtitle: 'Move back to original location',
                  color: AppColors.success,
                  onTap: () => _restoreFile(document),
                ),
                const SizedBox(height: 8),
                _buildMenuOption(
                  icon: Icons.delete_forever,
                  title: 'Delete Permanently',
                  subtitle: 'This action cannot be undone',
                  color: AppColors.error,
                  onTap: () => _deleteFilePermanently(document),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
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
      ),
    );
  }

  Future<void> _restoreFile(DocumentModel document) async {
    try {
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );
      await documentProvider.restoreFromRecycleBin(document.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${document.fileName} restored successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to restore file: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _deleteFilePermanently(DocumentModel document) async {
    final confirmed = await _showDeleteConfirmationDialog(document.fileName);
    if (!confirmed || !mounted) return;

    try {
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );
      await documentProvider.permanentlyDeleteDocument(document.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${document.fileName} deleted permanently'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete file: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<bool> _showDeleteConfirmationDialog(String fileName) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Delete Permanently',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: Text(
              'Are you sure you want to permanently delete "$fileName"? This action cannot be undone.',
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(color: AppColors.textSecondary),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Delete',
                  style: GoogleFonts.poppins(color: AppColors.error),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showEmptyBinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Empty Recycle Bin',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to permanently delete all files in the recycle bin? This action cannot be undone.',
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
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _emptyRecycleBin();
            },
            child: Text(
              'Empty Bin',
              style: GoogleFonts.poppins(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showRestoreAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Restore All Files',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to restore all files from the recycle bin?',
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
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restoreAllFiles();
            },
            child: Text(
              'Restore All',
              style: GoogleFonts.poppins(color: AppColors.success),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _emptyRecycleBin() async {
    try {
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );
      final recycleBinFiles = documentProvider.getRecycleBinFiles();

      for (final document in recycleBinFiles) {
        await documentProvider.permanentlyDeleteDocument(document.id);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recycle bin emptied successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to empty recycle bin: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _restoreAllFiles() async {
    try {
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );
      final recycleBinFiles = documentProvider.getRecycleBinFiles();

      for (final document in recycleBinFiles) {
        await documentProvider.restoreFromRecycleBin(document.id);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${recycleBinFiles.length} files restored successfully',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to restore files: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
