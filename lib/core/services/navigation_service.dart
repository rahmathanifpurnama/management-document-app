import 'package:flutter/material.dart';
import '../interfaces/service_interfaces.dart';
import '../constants/app_routes.dart';
import '../../models/document_model.dart';

/// Concrete implementation of INavigationService
class NavigationService implements INavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  static NavigationService get instance => _instance;

  BuildContext? _context;

  /// Set the current context for navigation
  void setContext(BuildContext context) {
    _context = context;
  }

  /// Get the current context
  BuildContext get context {
    if (_context == null) {
      throw Exception('Navigation context not set. Call setContext() first.');
    }
    return _context!;
  }

  @override
  void navigateToFilePreview(DocumentModel document) {
    Navigator.pushNamed(
      context,
      AppRoutes.filePreview,
      arguments: document,
    );
  }

  @override
  void navigateToProfile() {
    Navigator.pushNamed(context, AppRoutes.profile);
  }

  @override
  void navigateToCategory(String categoryId) {
    Navigator.pushNamed(
      context,
      AppRoutes.manageCategories,
      arguments: categoryId,
    );
  }

  @override
  void showDocumentMenu(DocumentModel document) {
    showModalBottomSheet(
      context: context,
      builder: (context) => DocumentMenuBottomSheet(document: document),
    );
  }
}

/// Document menu bottom sheet widget
class DocumentMenuBottomSheet extends StatelessWidget {
  final DocumentModel document;

  const DocumentMenuBottomSheet({
    super.key,
    required this.document,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.visibility),
            title: const Text('Preview'),
            onTap: () {
              Navigator.pop(context);
              NavigationService.instance.navigateToFilePreview(document);
            },
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Download'),
            onTap: () {
              Navigator.pop(context);
              // Handle download
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () {
              Navigator.pop(context);
              // Handle share
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete'),
            onTap: () {
              Navigator.pop(context);
              // Handle delete
            },
          ),
        ],
      ),
    );
  }
}
