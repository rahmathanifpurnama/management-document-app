import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../models/category_model.dart';
import '../../providers/category_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/app_bottom_navigation.dart';
import '../../widgets/category/category_item_widget.dart';
import '../../widgets/common/empty_state_widget.dart';

import '../../widgets/category/add_category_dialog.dart';
import '../../widgets/category/category_list_shimmer.dart';

class ManageCategoryScreen extends StatefulWidget {
  const ManageCategoryScreen({super.key});

  @override
  State<ManageCategoryScreen> createState() => _ManageCategoryScreenState();
}

class _ManageCategoryScreenState extends State<ManageCategoryScreen> {
  bool _isLoading = false;
  final _uuid = const Uuid();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadCategories() async {
    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );
    await categoryProvider.loadCategories();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  List<CategoryModel> _filterCategories(List<CategoryModel> categories) {
    if (_searchQuery.isEmpty) {
      return categories;
    }

    return categories.where((category) {
      final name = category.name.toLowerCase();
      final description = category.description.toLowerCase();
      return name.contains(_searchQuery) || description.contains(_searchQuery);
    }).toList();
  }

  Widget _buildSearchWidget() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.poppins(fontSize: 15, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Search categories...',
          hintStyle: GoogleFonts.poppins(
            fontSize: 15,
            color: AppColors.textSecondary,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textSecondary,
            size: 20,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWithNavigation(
      title: 'Categories',
      currentNavIndex: 1, // Category is index 1
      showAppBar: true, // Ensure app bar is shown
      leading: const SizedBox.shrink(), // Remove back button
      body: Container(color: const Color(0xFFF5F5F5), child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        if (categoryProvider.isLoading) {
          return _buildLoadingState();
        }

        if (categoryProvider.errorMessage != null) {
          return _buildErrorState(categoryProvider.errorMessage!);
        }

        final categories = categoryProvider.activeCategories;
        final filteredCategories = _filterCategories(categories);

        return RefreshIndicator(
          onRefresh: _loadCategories,
          color: AppColors.primary,
          child: Column(
            children: [
              // Search Widget
              _buildSearchWidget(),
              // Categories List
              Expanded(
                child: categories.isEmpty
                    ? EmptyStateWidget.noCategories(
                        actionButton: ElevatedButton.icon(
                          onPressed: _showAddCategoryDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                          icon: const Icon(Icons.add),
                          label: Text(
                            'Create Category',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : _buildCategoriesListWithAddButton(filteredCategories),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return const CategoryListShimmer(itemCount: 6);
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Error Loading Categories',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadCategories,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              icon: const Icon(Icons.refresh),
              label: Text(
                'Retry',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesListWithAddButton(List<CategoryModel> categories) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: categories.length + 1, // +1 for the Add Category button
      itemBuilder: (context, index) {
        if (index == 0) {
          // First item is the Add Category button
          return _buildAddCategoryButton();
        } else {
          // Other items are category cards
          final category =
              categories[index - 1]; // -1 because first item is button
          return CategoryItemWidget(
            category: category,
            onTap: () => _navigateToCategoryDetail(category),
            onLongPress: () => _showCategoryOptions(category),
            onEdit: () => _showEditCategoryDialog(category),
            onDelete: () => _deleteCategory(category),
            showActions: true,
          );
        }
      },
    );
  }

  Widget _buildAddCategoryButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : _showAddCategoryDialog,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Add Category Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(
                      alpha: 0.1,
                    ), // Light blue background
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: _isLoading
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.add, // ← Clear "+" sign
                            size: 32,
                            color: AppColors.primary, // ← Blue "+" sign
                          ),
                        ),
                ),

                const SizedBox(width: 16),

                // Add Category Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isLoading ? 'Adding Category...' : 'Add Category',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Create a new category folder',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToCategoryDetail(CategoryModel category) {
    Navigator.pushNamed(context, AppRoutes.categoryFiles, arguments: category);
  }

  void _showCategoryOptions(CategoryModel category) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              category.name,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.visibility_outlined),
              title: Text('View Files', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pop(context);
                _navigateToCategoryDetail(category);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text('Edit Category', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pop(context);
                _showEditCategoryDialog(category);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: Text(
                'Delete Category',
                style: GoogleFonts.poppins(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _deleteCategory(category);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          AddCategoryDialog(onSave: _addCategory, isLoading: _isLoading),
    );
  }

  void _showEditCategoryDialog(CategoryModel category) {
    showDialog(
      context: context,
      builder: (context) => AddCategoryDialog(
        category: category,
        onSave: (name, description) =>
            _updateCategory(category, name, description),
        isLoading: _isLoading,
      ),
    );
  }

  Future<void> _addCategory(String name, String description) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final categoryProvider = Provider.of<CategoryProvider>(
        context,
        listen: false,
      );

      final newCategory = CategoryModel(
        id: _uuid.v4(),
        name: name,
        description: description,
        createdBy: authProvider.currentUser?.id ?? 'unknown',
        createdAt: DateTime.now(),
        permissions: [],
        isActive: true,
        documentCount: 0, // Initialize with 0 documents
      );

      categoryProvider.addCategory(newCategory);

      Navigator.of(context).pop(); // Close dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Category "$name" added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add category: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateCategory(
    CategoryModel category,
    String name,
    String description,
  ) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final categoryProvider = Provider.of<CategoryProvider>(
        context,
        listen: false,
      );

      final updatedCategory = category.copyWith(
        name: name,
        description: description,
      );

      categoryProvider.updateCategory(updatedCategory);

      Navigator.of(context).pop(); // Close dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Category "$name" updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update category: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteCategory(CategoryModel category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Category',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete "${category.name}"? This action cannot be undone.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final categoryProvider = Provider.of<CategoryProvider>(
          context,
          listen: false,
        );
        await categoryProvider.removeCategory(category.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Category "${category.name}" deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete category: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
