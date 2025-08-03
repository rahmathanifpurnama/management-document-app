import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/document_model.dart';

/// Abstract base classes for common widget behaviors
/// Implements polymorphism through inheritance and composition

// ============================================================================
// BASE WIDGET CLASSES
// ============================================================================

/// Abstract base class for all home screen components
abstract class BaseHomeComponent extends ConsumerStatefulWidget {
  const BaseHomeComponent({super.key});

  /// Get component identifier for analytics and debugging
  String get componentId;

  /// Get component priority for rendering order
  int get priority => 0;

  /// Check if component should be visible based on user role and state
  bool shouldShow(BuildContext context);

  /// Handle component refresh
  Future<void> refresh();

  /// Handle component error
  void handleError(dynamic error, StackTrace? stackTrace);
}

/// Abstract state class for home components
abstract class BaseHomeComponentState<T extends BaseHomeComponent> 
    extends ConsumerState<T> with AutomaticKeepAliveClientMixin {
  
  bool _isLoading = false;
  String? _errorMessage;

  /// Whether to keep this component alive when not visible
  @override
  bool get wantKeepAlive => true;

  /// Get loading state
  bool get isLoading => _isLoading;

  /// Get error message
  String? get errorMessage => _errorMessage;

  /// Set loading state
  void setLoading(bool loading) {
    if (mounted && _isLoading != loading) {
      setState(() {
        _isLoading = loading;
      });
    }
  }

  /// Set error message
  void setError(String? error) {
    if (mounted && _errorMessage != error) {
      setState(() {
        _errorMessage = error;
      });
    }
  }

  /// Clear error
  void clearError() {
    setError(null);
  }

  /// Build component content
  Widget buildContent(BuildContext context);

  /// Build loading widget
  Widget buildLoading(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  /// Build error widget
  Widget buildError(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            error,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              clearError();
              widget.refresh();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Check if component should be shown
    if (!widget.shouldShow(context)) {
      return const SizedBox.shrink();
    }

    // Show error state
    if (_errorMessage != null) {
      return buildError(context, _errorMessage!);
    }

    // Show loading state
    if (_isLoading) {
      return buildLoading(context);
    }

    // Show content
    return buildContent(context);
  }
}

// ============================================================================
// DOCUMENT LIST COMPONENTS
// ============================================================================

/// Abstract base class for document list components
abstract class BaseDocumentListComponent extends BaseHomeComponent {
  final String? searchQuery;
  final Function(DocumentModel)? onDocumentTap;
  final Function(DocumentModel)? onDocumentMenu;

  const BaseDocumentListComponent({
    super.key,
    this.searchQuery,
    this.onDocumentTap,
    this.onDocumentMenu,
  });

  /// Get documents to display
  List<DocumentModel> getDocuments(BuildContext context);

  /// Filter documents based on search query
  List<DocumentModel> filterDocuments(List<DocumentModel> documents) {
    if (searchQuery == null || searchQuery!.isEmpty) {
      return documents;
    }

    return documents.where((doc) {
      return doc.fileName.toLowerCase().contains(searchQuery!.toLowerCase()) ||
             doc.category.toLowerCase().contains(searchQuery!.toLowerCase());
    }).toList();
  }

  /// Sort documents
  List<DocumentModel> sortDocuments(List<DocumentModel> documents) {
    // Default sort by upload date (newest first)
    documents.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
    return documents;
  }
}

/// Abstract state for document list components
abstract class BaseDocumentListState<T extends BaseDocumentListComponent> 
    extends BaseHomeComponentState<T> {
  
  /// Build document list item
  Widget buildDocumentItem(BuildContext context, DocumentModel document);

  /// Build empty state
  Widget buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No documents found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Documents will appear here when available',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    final documents = widget.getDocuments(context);
    final filteredDocuments = widget.filterDocuments(documents);
    final sortedDocuments = widget.sortDocuments(filteredDocuments);

    if (sortedDocuments.isEmpty) {
      return buildEmptyState(context);
    }

    return ListView.builder(
      itemCount: sortedDocuments.length,
      itemBuilder: (context, index) {
        return buildDocumentItem(context, sortedDocuments[index]);
      },
    );
  }
}

// ============================================================================
// STATISTICS COMPONENTS
// ============================================================================

/// Abstract base class for statistics components
abstract class BaseStatisticsComponent extends BaseHomeComponent {
  const BaseStatisticsComponent({super.key});

  /// Get statistics data
  Map<String, dynamic> getStatisticsData(BuildContext context);

  /// Handle statistics tap
  void onStatisticTap(String statType, BuildContext context);
}

/// Abstract state for statistics components
abstract class BaseStatisticsState<T extends BaseStatisticsComponent> 
    extends BaseHomeComponentState<T> {
  
  /// Build statistics item
  Widget buildStatisticItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    String statType,
  );

  /// Build statistics grid
  Widget buildStatisticsGrid(BuildContext context, Map<String, dynamic> stats) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final entry = stats.entries.elementAt(index);
        return buildStatisticItem(
          context,
          entry.key,
          entry.value.toString(),
          Icons.analytics,
          entry.key,
        );
      },
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    final stats = widget.getStatisticsData(context);
    return buildStatisticsGrid(context, stats);
  }
}

// ============================================================================
// SEARCH COMPONENTS
// ============================================================================

/// Abstract base class for search components
abstract class BaseSearchComponent extends BaseHomeComponent {
  final TextEditingController? controller;
  final VoidCallback? onSearchChanged;

  const BaseSearchComponent({
    super.key,
    this.controller,
    this.onSearchChanged,
  });

  /// Get search placeholder text
  String get placeholderText => 'Search...';

  /// Get search icon
  IconData get searchIcon => Icons.search;

  /// Handle search submission
  void onSearchSubmitted(String query);

  /// Handle search cleared
  void onSearchCleared();
}

/// Abstract state for search components
abstract class BaseSearchState<T extends BaseSearchComponent> 
    extends BaseHomeComponentState<T> {
  
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onSearchChanged() {
    widget.onSearchChanged?.call();
  }

  /// Build search field
  Widget buildSearchField(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: widget.placeholderText,
        prefixIcon: Icon(widget.searchIcon),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  widget.onSearchCleared();
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onSubmitted: widget.onSearchSubmitted,
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return buildSearchField(context);
  }
}
