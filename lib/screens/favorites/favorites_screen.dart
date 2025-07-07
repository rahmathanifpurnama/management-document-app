import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_colors.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/empty_state_widget.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Mock data for UI design - will be replaced with actual logic later
  final List<FavoriteFolder> _mockFavoriteFolders = [
    FavoriteFolder(
      id: '1',
      name: 'Important Documents',
      description: 'Critical business documents',
      fileCount: 15,
      lastModified: DateTime.now().subtract(const Duration(days: 2)),
      color: AppColors.primary,
    ),
    FavoriteFolder(
      id: '2',
      name: 'Project Files',
      description: 'Current project documentation',
      fileCount: 8,
      lastModified: DateTime.now().subtract(const Duration(hours: 5)),
      color: AppColors.success,
    ),
    FavoriteFolder(
      id: '3',
      name: 'Personal',
      description: 'Personal documents and files',
      fileCount: 23,
      lastModified: DateTime.now().subtract(const Duration(days: 1)),
      color: AppColors.warning,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Favorites',
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
            tooltip: 'Search Favorites',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'sort':
                  _showSortOptions();
                  break;
                case 'view':
                  _toggleViewMode();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'sort',
                child: Row(
                  children: [
                    Icon(Icons.sort, color: AppColors.textPrimary),
                    SizedBox(width: 8),
                    Text('Sort'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'view',
                child: Row(
                  children: [
                    Icon(Icons.view_module, color: AppColors.textPrimary),
                    SizedBox(width: 8),
                    Text('View Mode'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(color: const Color(0xFFF5F5F5), child: _buildBody()),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateFavoriteDialog,
        backgroundColor: AppColors.primary,
        tooltip: 'Create Favorite Folder',
        child: const Icon(Icons.add, color: AppColors.textWhite),
      ),
    );
  }

  Widget _buildBody() {
    if (_mockFavoriteFolders.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildHeader(),
        Expanded(child: _buildFavoritesList()),
      ],
    );
  }

  Widget _buildHeader() {
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
            'assets/icon/user-folder.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Favorite Folders',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${_mockFavoriteFolders.length} ${_mockFavoriteFolders.length == 1 ? 'folder' : 'folders'} marked as favorite',
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

  Widget _buildFavoritesList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _mockFavoriteFolders.length,
      itemBuilder: (context, index) {
        final folder = _mockFavoriteFolders[index];
        return _buildFavoriteCard(folder);
      },
    );
  }

  Widget _buildFavoriteCard(FavoriteFolder folder) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
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
          onTap: () => _openFavoriteFolder(folder),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Folder Icon with Color
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: folder.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.folder, color: folder.color, size: 24),
                ),
                const SizedBox(width: 16),

                // Folder Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        folder.name,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        folder.description,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.description,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${folder.fileCount} files',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatLastModified(folder.lastModified),
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Action Menu
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: AppColors.textSecondary),
                  onSelected: (value) => _handleFolderAction(folder, value),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'open',
                      child: Row(
                        children: [
                          Icon(Icons.folder_open, color: AppColors.primary),
                          SizedBox(width: 8),
                          Text('Open'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: AppColors.warning),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'remove',
                      child: Row(
                        children: [
                          Icon(Icons.favorite_border, color: AppColors.error),
                          SizedBox(width: 8),
                          Text('Remove from Favorites'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyStateWidget(
      icon: Icons.favorite_border,
      title: 'No Favorite Folders',
      subtitle: 'Mark folders as favorites to see them here',
      actionButton: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textWhite,
        ),
        child: const Text('Browse Folders'),
      ),
    );
  }

  String _formatLastModified(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _openFavoriteFolder(FavoriteFolder folder) {
    // TODO: Implement navigation to folder contents
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${folder.name} - Logic to be implemented'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _handleFolderAction(FavoriteFolder folder, String action) {
    switch (action) {
      case 'open':
        _openFavoriteFolder(folder);
        break;
      case 'edit':
        _showEditFavoriteDialog(folder);
        break;
      case 'remove':
        _removeFavoriteFolder(folder);
        break;
    }
  }

  void _showSearchDialog() {
    // TODO: Implement search functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Search functionality - To be implemented'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _showSortOptions() {
    // TODO: Implement sort options
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sort options - To be implemented'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _toggleViewMode() {
    // TODO: Implement view mode toggle
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('View mode toggle - To be implemented'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _showCreateFavoriteDialog() {
    // TODO: Implement create favorite dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Create favorite dialog - To be implemented'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _showEditFavoriteDialog(FavoriteFolder folder) {
    // TODO: Implement edit favorite dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit ${folder.name} - To be implemented'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _removeFavoriteFolder(FavoriteFolder folder) {
    // TODO: Implement remove favorite functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Remove ${folder.name} from favorites - To be implemented',
        ),
        backgroundColor: AppColors.warning,
      ),
    );
  }
}

// Mock model for favorite folders - will be replaced with actual model later
class FavoriteFolder {
  final String id;
  final String name;
  final String description;
  final int fileCount;
  final DateTime lastModified;
  final Color color;

  FavoriteFolder({
    required this.id,
    required this.name,
    required this.description,
    required this.fileCount,
    required this.lastModified,
    required this.color,
  });
}
