import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/document_provider.dart';

/// Widget untuk menginisialisasi sinkronisasi antara CategoryProvider dan DocumentProvider
/// Khususnya untuk menangani pembersihan kategori dari dokumen ketika kategori dihapus
class CategoryDocumentSyncInitializer extends StatefulWidget {
  final Widget child;

  const CategoryDocumentSyncInitializer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<CategoryDocumentSyncInitializer> createState() =>
      _CategoryDocumentSyncInitializerState();
}

class _CategoryDocumentSyncInitializerState
    extends State<CategoryDocumentSyncInitializer> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (!_isInitialized) {
      _initializeCategoryDocumentSync();
      _isInitialized = true;
    }
  }

  void _initializeCategoryDocumentSync() {
    try {
      final categoryProvider = Provider.of<CategoryProvider>(
        context,
        listen: false,
      );
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );

      // Setup callback untuk category deletion
      categoryProvider.setOnCategoryDeletedCallback((String categoryId) async {
        debugPrint('🔄 CategoryDocumentSync: Handling category deletion: $categoryId');
        
        try {
          await documentProvider.clearCategoryFromAllDocuments(categoryId);
          debugPrint('✅ CategoryDocumentSync: Documents cleared for category: $categoryId');
        } catch (e) {
          debugPrint('❌ CategoryDocumentSync: Failed to clear documents: $e');
        }
      });

      debugPrint('✅ CategoryDocumentSync: Sync initialized successfully');
    } catch (e) {
      debugPrint('❌ CategoryDocumentSync: Failed to initialize sync: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
