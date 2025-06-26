import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../providers/category_provider.dart';
import '../../providers/document_provider.dart';
import '../../models/category_model.dart';
import '../../widgets/common/custom_app_bar.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int _currentPage = 0;
  final int _itemsPerPage = 25;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );
    await categoryProvider.loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Categories',
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.manageCategories);
            },
            tooltip: 'Manage Categories',
          ),
        ],
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          if (categoryProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (categoryProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading categories',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    categoryProvider.errorMessage!,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadCategories,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textWhite,
                    ),
                    child: Text('Retry', style: GoogleFonts.poppins()),
                  ),
                ],
              ),
            );
          }

          final categories = categoryProvider.categories;

          if (categories.isEmpty) {
            return _buildEmptyState();
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Document Categories',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showAddCategoryDialog(),
                      icon: const Icon(
                        Icons.add,
                        color: AppColors.primary,
                        size: 28,
                      ),
                      tooltip: 'Add Category',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(child: _buildCategoriesWithPagination(categories)),
              ],
            ),
          );
        },
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
            'No Categories Found',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first category to organize documents',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddCategoryDialog(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textWhite,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: const Icon(Icons.add),
            label: Text('Add Category', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  /// Build categories with pagination
  Widget _buildCategoriesWithPagination(List<CategoryModel> categories) {
    // Calculate pagination
    final totalPages = (categories.length / _itemsPerPage).ceil();
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, categories.length);
    final currentPageCategories = categories.sublist(startIndex, endIndex);

    return Column(
      children: [
        // Categories Grid
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: currentPageCategories.length,
            itemBuilder: (context, index) {
              final category = currentPageCategories[index];
              return _buildCategoryCard(category);
            },
          ),
        ),
        // Pagination Controls
        if (totalPages > 1) ...[
          const SizedBox(height: 16),
          _buildPaginationControls(totalPages),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  /// Build pagination controls
  Widget _buildPaginationControls(int totalPages) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
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
                  : AppColors.border.withValues(alpha: 0.1),
              foregroundColor: _currentPage > 0
                  ? AppColors.primary
                  : AppColors.textSecondary,
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
                  color: isCurrentPage
                      ? AppColors.primary
                      : AppColors.background,
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
                      color: isCurrentPage
                          ? Colors.white
                          : AppColors.textPrimary,
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
                  : AppColors.border.withValues(alpha: 0.1),
              foregroundColor: _currentPage < totalPages - 1
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Navigate to specific page
  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Widget _buildCategoryCard(CategoryModel category) {
    return Consumer<DocumentProvider>(
      builder: (context, documentProvider, child) {
        final documentsCount = documentProvider
            .getDocumentsByCategory(category.id)
            .length;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () => _navigateToCategoryFiles(category),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _getCategoryColor(category.name).withValues(alpha: 0.1),
                    _getCategoryColor(category.name).withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(
                        category.name,
                      ).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getCategoryIcon(category.name),
                      size: 28,
                      color: _getCategoryColor(category.name),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    category.name,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$documentsCount files',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (category.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      category.description,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToCategoryFiles(CategoryModel category) {
    Navigator.pushNamed(context, AppRoutes.categoryFiles, arguments: category);
  }

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add New Category',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Category Name',
                labelStyle: GoogleFonts.poppins(),
                border: const OutlineInputBorder(),
              ),
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description (Optional)',
                labelStyle: GoogleFonts.poppins(),
                border: const OutlineInputBorder(),
              ),
              style: GoogleFonts.poppins(),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () =>
                _addCategory(nameController.text, descriptionController.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textWhite,
            ),
            child: Text('Add', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  void _addCategory(String name, String description) {
    if (name.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter category name')),
      );
      return;
    }

    final categoryProvider = Provider.of<CategoryProvider>(
      context,
      listen: false,
    );

    final newCategory = CategoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      description: description.trim(),
      createdBy: 'current-user', // TODO: Get from auth provider
      createdAt: DateTime.now(),
      permissions: [], // Add empty permissions list
      isActive: true, // Set category as active by default
      documentCount: 0, // Initialize with 0 documents
    );

    categoryProvider.addCategory(newCategory);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Category "${name.trim()}" added successfully')),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();
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

  Color _getCategoryColor(String categoryName) {
    final name = categoryName.toLowerCase();
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
}
