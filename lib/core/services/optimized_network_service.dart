import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../config/anr_config.dart';
import '../utils/anr_prevention.dart';

/// HIGH PRIORITY: Network service to prevent ANR from concurrent operations
class OptimizedNetworkService {
  static OptimizedNetworkService? _instance;
  static OptimizedNetworkService get instance => _instance ??= OptimizedNetworkService._();
  
  OptimizedNetworkService._();

  final Queue<_NetworkOperation> _operationQueue = Queue();
  final Set<String> _activeOperations = {};
  int _concurrentOperations = 0;
  Timer? _queueProcessor;

  /// Initialize the service
  void initialize() {
    _startQueueProcessor();
    debugPrint('🌐 OptimizedNetworkService initialized');
  }

  /// HIGH PRIORITY: Execute Firestore operation with concurrency control
  Future<T?> executeFirestoreOperation<T>(
    Future<T> Function() operation, {
    required String operationId,
    String? operationName,
    Duration? timeout,
    int priority = 1,
  }) async {
    return await _executeOperation(
      operation,
      operationId: operationId,
      operationName: operationName ?? 'Firestore Operation',
      timeout: timeout ?? ANRConfig.firestoreQueryTimeout,
      priority: priority,
      type: _OperationType.firestore,
    );
  }

  /// HIGH PRIORITY: Execute Firebase Storage operation with concurrency control
  Future<T?> executeStorageOperation<T>(
    Future<T> Function() operation, {
    required String operationId,
    String? operationName,
    Duration? timeout,
    int priority = 1,
  }) async {
    return await _executeOperation(
      operation,
      operationId: operationId,
      operationName: operationName ?? 'Storage Operation',
      timeout: timeout ?? ANRConfig.storageListTimeout,
      priority: priority,
      type: _OperationType.storage,
    );
  }

  /// Execute network operation with queue management
  Future<T?> _executeOperation<T>(
    Future<T> Function() operation, {
    required String operationId,
    required String operationName,
    required Duration timeout,
    required int priority,
    required _OperationType type,
  }) async {
    // Check if operation is already running
    if (_activeOperations.contains(operationId)) {
      debugPrint('⚠️ Operation already running: $operationId');
      return null;
    }

    final completer = Completer<T?>();
    final networkOp = _NetworkOperation<T>(
      id: operationId,
      name: operationName,
      operation: operation,
      timeout: timeout,
      priority: priority,
      type: type,
      completer: completer,
    );

    _operationQueue.add(networkOp);
    _processQueue();

    return await completer.future;
  }

  /// Process operation queue
  void _processQueue() {
    if (_operationQueue.isEmpty) return;
    if (_concurrentOperations >= _getMaxConcurrentOperations()) return;

    // Sort by priority (higher priority first)
    final sortedOps = _operationQueue.toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));
    
    _operationQueue.clear();
    _operationQueue.addAll(sortedOps);

    while (_operationQueue.isNotEmpty && 
           _concurrentOperations < _getMaxConcurrentOperations()) {
      final op = _operationQueue.removeFirst();
      _executeQueuedOperation(op);
    }
  }

  /// Execute queued operation
  void _executeQueuedOperation<T>(_NetworkOperation<T> op) async {
    _concurrentOperations++;
    _activeOperations.add(op.id);

    try {
      debugPrint('🔄 Executing ${op.name} (${op.id}) - Priority: ${op.priority}');
      
      final result = await ANRPrevention.executeWithTimeout(
        op.operation(),
        timeout: op.timeout,
        operationName: op.name,
      );

      op.completer.complete(result);
      debugPrint('✅ Completed ${op.name} (${op.id})');
    } catch (e) {
      debugPrint('❌ Failed ${op.name} (${op.id}): $e');
      op.completer.complete(null);
    } finally {
      _concurrentOperations--;
      _activeOperations.remove(op.id);
      
      // Process next operations in queue
      if (_operationQueue.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 50), _processQueue);
      }
    }
  }

  /// Get max concurrent operations based on type
  int _getMaxConcurrentOperations() {
    return ANRConfig.maxConcurrentNetworkOps;
  }

  /// Start queue processor timer
  void _startQueueProcessor() {
    _queueProcessor?.cancel();
    _queueProcessor = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => _processQueue(),
    );
  }

  /// HIGH PRIORITY: Batch Firestore operations
  Future<List<T?>> batchFirestoreOperations<T>(
    List<Future<T> Function()> operations, {
    required String batchId,
    String? operationName,
    int batchSize = 3,
  }) async {
    debugPrint('📦 Starting batch operations: $batchId (${operations.length} ops)');
    
    final results = <T?>[];
    
    for (int i = 0; i < operations.length; i += batchSize) {
      final batch = operations.skip(i).take(batchSize).toList();
      final batchResults = await Future.wait(
        batch.asMap().entries.map((entry) {
          final index = i + entry.key;
          return executeFirestoreOperation(
            entry.value,
            operationId: '${batchId}_$index',
            operationName: '${operationName ?? 'Batch Op'} $index',
            priority: 2, // Lower priority for batch operations
          );
        }),
      );
      
      results.addAll(batchResults);
      
      // Yield to UI between batches
      if (i + batchSize < operations.length) {
        await Future.delayed(ANRConfig.batchDelay);
      }
    }
    
    debugPrint('✅ Completed batch operations: $batchId');
    return results;
  }

  /// Cancel operation
  void cancelOperation(String operationId) {
    _activeOperations.remove(operationId);
    _operationQueue.removeWhere((op) => op.id == operationId);
    debugPrint('❌ Cancelled operation: $operationId');
  }

  /// Cancel all operations
  void cancelAllOperations() {
    _activeOperations.clear();
    _operationQueue.clear();
    debugPrint('❌ Cancelled all operations');
  }

  /// Get operation statistics
  Map<String, dynamic> getStats() {
    return {
      'activeOperations': _activeOperations.length,
      'queuedOperations': _operationQueue.length,
      'concurrentOperations': _concurrentOperations,
      'maxConcurrentOperations': _getMaxConcurrentOperations(),
    };
  }

  /// Dispose resources
  void dispose() {
    _queueProcessor?.cancel();
    cancelAllOperations();
    debugPrint('🗑️ OptimizedNetworkService disposed');
  }
}

/// Network operation wrapper
class _NetworkOperation<T> {
  final String id;
  final String name;
  final Future<T> Function() operation;
  final Duration timeout;
  final int priority;
  final _OperationType type;
  final Completer<T?> completer;

  _NetworkOperation({
    required this.id,
    required this.name,
    required this.operation,
    required this.timeout,
    required this.priority,
    required this.type,
    required this.completer,
  });
}

/// Operation types
enum _OperationType {
  firestore,
  storage,
  auth,
  cloudFunction,
}

/// HIGH PRIORITY: Optimized Firestore service wrapper
class OptimizedFirestoreService {
  static OptimizedFirestoreService? _instance;
  static OptimizedFirestoreService get instance => _instance ??= OptimizedFirestoreService._();
  
  OptimizedFirestoreService._();

  final OptimizedNetworkService _networkService = OptimizedNetworkService.instance;

  /// Get collection with optimization
  Future<QuerySnapshot?> getCollection(
    String collectionPath, {
    Map<String, dynamic>? whereConditions,
    String? orderBy,
    bool descending = true,
    int? limit,
    DocumentSnapshot? startAfter,
  }) async {
    final operationId = 'get_collection_${collectionPath}_${DateTime.now().millisecondsSinceEpoch}';
    
    return await _networkService.executeFirestoreOperation(
      () async {
        Query query = FirebaseFirestore.instance.collection(collectionPath);
        
        // Apply where conditions
        if (whereConditions != null) {
          for (final entry in whereConditions.entries) {
            query = query.where(entry.key, isEqualTo: entry.value);
          }
        }
        
        // Apply ordering
        if (orderBy != null) {
          query = query.orderBy(orderBy, descending: descending);
        }
        
        // Apply pagination
        if (startAfter != null) {
          query = query.startAfterDocument(startAfter);
        }
        
        // Apply limit
        if (limit != null) {
          query = query.limit(limit);
        }
        
        return await query.get();
      },
      operationId: operationId,
      operationName: 'Get Collection: $collectionPath',
      priority: 3, // High priority for data fetching
    );
  }

  /// Get document with optimization
  Future<DocumentSnapshot?> getDocument(String documentPath) async {
    final operationId = 'get_document_${documentPath}_${DateTime.now().millisecondsSinceEpoch}';
    
    return await _networkService.executeFirestoreOperation(
      () async {
        return await FirebaseFirestore.instance.doc(documentPath).get();
      },
      operationId: operationId,
      operationName: 'Get Document: $documentPath',
      priority: 4, // Higher priority for single document
    );
  }

  /// Add document with optimization
  Future<DocumentReference?> addDocument(
    String collectionPath,
    Map<String, dynamic> data,
  ) async {
    final operationId = 'add_document_${collectionPath}_${DateTime.now().millisecondsSinceEpoch}';
    
    return await _networkService.executeFirestoreOperation(
      () async {
        return await FirebaseFirestore.instance.collection(collectionPath).add(data);
      },
      operationId: operationId,
      operationName: 'Add Document: $collectionPath',
      priority: 5, // Highest priority for writes
    );
  }

  /// Update document with optimization
  Future<void> updateDocument(
    String documentPath,
    Map<String, dynamic> data,
  ) async {
    final operationId = 'update_document_${documentPath}_${DateTime.now().millisecondsSinceEpoch}';
    
    await _networkService.executeFirestoreOperation(
      () async {
        await FirebaseFirestore.instance.doc(documentPath).update(data);
        return null;
      },
      operationId: operationId,
      operationName: 'Update Document: $documentPath',
      priority: 5, // Highest priority for writes
    );
  }

  /// Delete document with optimization
  Future<void> deleteDocument(String documentPath) async {
    final operationId = 'delete_document_${documentPath}_${DateTime.now().millisecondsSinceEpoch}';
    
    await _networkService.executeFirestoreOperation(
      () async {
        await FirebaseFirestore.instance.doc(documentPath).delete();
        return null;
      },
      operationId: operationId,
      operationName: 'Delete Document: $documentPath',
      priority: 5, // Highest priority for writes
    );
  }
}
