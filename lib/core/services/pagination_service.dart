import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import '../config/anr_config.dart';
import '../utils/anr_prevention.dart';
import '../../models/document_model.dart';

/// HIGH PRIORITY: Pagination service to prevent ANR from large data loads
class PaginationService<T> {
  final String collectionName;
  final T Function(DocumentSnapshot doc) fromFirestore;
  final int pageSize;
  final String? orderByField;
  final bool descending;
  final Map<String, dynamic>? whereConditions;

  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  bool _isLoading = false;
  final List<T> _allItems = [];
  final StreamController<List<T>> _itemsController =
      StreamController<List<T>>.broadcast();
  final StreamController<bool> _loadingController =
      StreamController<bool>.broadcast();

  PaginationService({
    required this.collectionName,
    required this.fromFirestore,
    this.pageSize = ANRConfig.defaultPageSize,
    this.orderByField,
    this.descending = true,
    this.whereConditions,
  });

  /// Stream of items
  Stream<List<T>> get itemsStream => _itemsController.stream;

  /// Stream of loading state
  Stream<bool> get loadingStream => _loadingController.stream;

  /// Get current items
  List<T> get currentItems => List.unmodifiable(_allItems);

  /// Check if has more items
  bool get hasMore => _hasMore;

  /// Check if currently loading
  bool get isLoading => _isLoading;

  /// Load first page
  Future<void> loadFirstPage() async {
    if (_isLoading) return;

    try {
      _setLoading(true);
      _allItems.clear();
      _lastDocument = null;
      _hasMore = true;

      await _loadPage();
    } catch (e) {
      debugPrint('❌ Error loading first page: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Load next page
  Future<void> loadNextPage() async {
    if (_isLoading || !_hasMore) return;

    try {
      _setLoading(true);
      await _loadPage();
    } catch (e) {
      debugPrint('❌ Error loading next page: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh data
  Future<void> refresh() async {
    await loadFirstPage();
  }

  /// Load page with ANR prevention and duplicate detection
  Future<void> _loadPage() async {
    final query = await ANRPrevention.executeWithTimeout(
      _buildQuery(),
      timeout: ANRConfig.firestoreQueryTimeout,
      operationName: 'Pagination Query - $collectionName',
    );

    if (query == null) {
      debugPrint('⚠️ Query timeout for $collectionName');
      return;
    }

    final snapshot = await ANRPrevention.executeWithTimeout(
      query.get(),
      timeout: ANRConfig.firestoreQueryTimeout,
      operationName: 'Pagination Fetch - $collectionName',
    );

    if (snapshot == null) {
      debugPrint('⚠️ Fetch timeout for $collectionName');
      return;
    }

    // Process results in batches to prevent ANR
    final newItems = <T>[];
    await ANRPrevention.batchProcess(
      snapshot.docs,
      (doc) async {
        try {
          return fromFirestore(doc);
        } catch (e) {
          debugPrint('❌ Error parsing document ${doc.id}: $e');
          return null;
        }
      },
      batchSize: ANRConfig.smallBatchSize,
      operationName: 'Document Parsing - $collectionName',
    ).then((results) {
      newItems.addAll(results.where((item) => item != null).cast<T>());
    });

    // CRITICAL FIX: Check for duplicates before adding items
    final existingIds = _getExistingItemIds();
    final uniqueNewItems = newItems.where((item) {
      final itemId = _getItemId(item);
      return itemId != null && !existingIds.contains(itemId);
    }).toList();

    // Only add unique items
    _allItems.addAll(uniqueNewItems);
    _itemsController.add(_allItems);

    // Update pagination state
    if (snapshot.docs.isNotEmpty) {
      _lastDocument = snapshot.docs.last;
      _hasMore = snapshot.docs.length >= pageSize;
    } else {
      _hasMore = false;
    }

    debugPrint(
      '📄 Loaded ${uniqueNewItems.length}/${newItems.length} unique items for $collectionName (Total: ${_allItems.length})',
    );
  }

  /// Build Firestore query
  Future<Query> _buildQuery() async {
    Query query = FirebaseFirestore.instance.collection(collectionName);

    // Apply where conditions
    if (whereConditions != null) {
      for (final entry in whereConditions!.entries) {
        query = query.where(entry.key, isEqualTo: entry.value);
      }
    }

    // Apply ordering
    if (orderByField != null) {
      query = query.orderBy(orderByField!, descending: descending);
    }

    // Apply pagination
    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    return query.limit(pageSize);
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    _loadingController.add(loading);
  }

  /// Add item to beginning (for new uploads) with duplicate check
  void addItem(T item) {
    final itemId = _getItemId(item);
    if (itemId != null && !_getExistingItemIds().contains(itemId)) {
      _allItems.insert(0, item);
      _itemsController.add(_allItems);
    }
  }

  /// Remove item
  void removeItem(bool Function(T item) predicate) {
    _allItems.removeWhere(predicate);
    _itemsController.add(_allItems);
  }

  /// Update item
  void updateItem(T newItem, bool Function(T item) predicate) {
    final index = _allItems.indexWhere(predicate);
    if (index != -1) {
      _allItems[index] = newItem;
      _itemsController.add(_allItems);
    }
  }

  /// Clear all data
  void clear() {
    _allItems.clear();
    _lastDocument = null;
    _hasMore = true;
    _itemsController.add(_allItems);
  }

  /// Get existing item IDs for duplicate detection
  Set<String> _getExistingItemIds() {
    return _allItems
        .map((item) => _getItemId(item))
        .where((id) => id != null)
        .cast<String>()
        .toSet();
  }

  /// Get item ID for duplicate detection (override in subclasses if needed)
  String? _getItemId(T item) {
    // Try to get ID from common properties
    try {
      if (item is Map<String, dynamic>) {
        return item['id'] as String?;
      }
      // Handle DocumentModel specifically
      if (item is DocumentModel) {
        return item.id;
      }
      // For other types, try to use toString as a unique identifier
      return item.toString();
    } catch (e) {
      debugPrint('❌ Error getting item ID: $e');
      return null;
    }
  }

  /// Dispose resources
  void dispose() {
    _itemsController.close();
    _loadingController.close();
  }
}

/// HIGH PRIORITY: Paginated list widget to prevent ANR
class PaginatedListWidget<T> extends StatefulWidget {
  final PaginationService<T> paginationService;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget? loadingWidget;
  final Widget? emptyWidget;
  final Widget? errorWidget;
  final ScrollController? scrollController;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const PaginatedListWidget({
    super.key,
    required this.paginationService,
    required this.itemBuilder,
    this.loadingWidget,
    this.emptyWidget,
    this.errorWidget,
    this.scrollController,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  State<PaginatedListWidget<T>> createState() => _PaginatedListWidgetState<T>();
}

class _PaginatedListWidgetState<T> extends State<PaginatedListWidget<T>> {
  late ScrollController _scrollController;
  StreamSubscription<List<T>>? _itemsSubscription;
  StreamSubscription<bool>? _loadingSubscription;
  List<T> _items = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_onScroll);

    _setupStreams();
    _loadInitialData();
  }

  void _setupStreams() {
    _itemsSubscription = widget.paginationService.itemsStream.listen((items) {
      if (mounted) {
        setState(() {
          _items = items;
        });
      }
    });

    _loadingSubscription = widget.paginationService.loadingStream.listen((
      loading,
    ) {
      if (mounted) {
        setState(() {
          _isLoading = loading;
        });
      }
    });
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.paginationService.loadFirstPage();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.paginationService.loadNextPage();
    }
  }

  @override
  void dispose() {
    _itemsSubscription?.cancel();
    _loadingSubscription?.cancel();
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty && _isLoading) {
      return widget.loadingWidget ??
          const Center(child: CircularProgressIndicator());
    }

    if (_items.isEmpty && !_isLoading) {
      return widget.emptyWidget ?? const Center(child: Text('No items found'));
    }

    return ListView.builder(
      controller: _scrollController,
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      itemCount: _items.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _items.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        return widget.itemBuilder(context, _items[index], index);
      },
    );
  }
}
