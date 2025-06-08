import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/document_model.dart';
import '../config/firebase_config.dart';

/// Progressive loading service to load data in chunks for better UI performance
class ProgressiveLoadingService {
  static ProgressiveLoadingService? _instance;
  static ProgressiveLoadingService get instance => _instance ??= ProgressiveLoadingService._();

  ProgressiveLoadingService._();

  // Loading configuration
  static const int _initialLoadSize = 20; // Load first 20 items immediately
  static const int _batchSize = 10; // Load 10 more items per batch
  static const Duration _batchDelay = Duration(milliseconds: 300); // Delay between batches

  /// Load documents progressively
  Stream<List<DocumentModel>> loadDocumentsProgressively(
    Future<List<DocumentModel>> Function() fetchAllDocuments,
    void Function(List<DocumentModel>) onBatchLoaded,
  ) async* {
    try {
      // Fetch all documents first
      final allDocuments = await fetchAllDocuments();
      
      if (allDocuments.isEmpty) {
        yield [];
        return;
      }

      // Load initial batch immediately for instant UI response
      final initialBatch = allDocuments.take(_initialLoadSize).toList();
      yield initialBatch;
      onBatchLoaded(initialBatch);

      // If we have more documents, load them progressively
      if (allDocuments.length > _initialLoadSize) {
        final remainingDocuments = allDocuments.skip(_initialLoadSize).toList();
        final loadedDocuments = List<DocumentModel>.from(initialBatch);

        // Load remaining documents in batches
        for (int i = 0; i < remainingDocuments.length; i += _batchSize) {
          // Add delay to prevent UI blocking
          await Future.delayed(_batchDelay);

          final endIndex = (i + _batchSize).clamp(0, remainingDocuments.length);
          final batch = remainingDocuments.sublist(i, endIndex);
          
          loadedDocuments.addAll(batch);
          yield List<DocumentModel>.from(loadedDocuments);
          onBatchLoaded(batch);

          debugPrint('📦 Loaded batch ${(i ~/ _batchSize) + 1}: ${batch.length} documents');
        }
      }

      debugPrint('✅ Progressive loading completed: ${allDocuments.length} total documents');
    } catch (e) {
      debugPrint('❌ Progressive loading failed: $e');
      yield [];
    }
  }

  /// Load data with priority (critical data first)
  Future<Map<String, dynamic>> loadDataWithPriority({
    required Future<List<DocumentModel>> Function() loadDocuments,
    required Future<List<dynamic>> Function() loadCategories,
    required Future<List<dynamic>> Function() loadUsers,
  }) async {
    final results = <String, dynamic>{};

    try {
      // Priority 1: Load categories first (needed for UI structure)
      debugPrint('🔄 Loading categories (Priority 1)...');
      results['categories'] = await loadCategories();
      
      // Priority 2: Load recent documents (for immediate display)
      debugPrint('🔄 Loading documents (Priority 2)...');
      final allDocuments = await loadDocuments();
      
      // Show recent documents first
      final recentDocuments = allDocuments
          .where((doc) => DateTime.now().difference(doc.uploadedAt).inDays < 7)
          .take(10)
          .toList();
      
      results['recentDocuments'] = recentDocuments;
      results['allDocuments'] = allDocuments;

      // Priority 3: Load users (less critical for immediate UI)
      if (FirebaseConfig.shouldAutoRefresh) {
        debugPrint('🔄 Loading users (Priority 3)...');
        results['users'] = await loadUsers();
      }

      debugPrint('✅ Priority loading completed');
      return results;
    } catch (e) {
      debugPrint('❌ Priority loading failed: $e');
      return results;
    }
  }

  /// Create loading states for better UX
  Map<String, bool> createLoadingStates() {
    return {
      'categories': true,
      'documents': true,
      'users': true,
      'recentDocuments': false, // This loads first
    };
  }

  /// Update loading state
  Map<String, bool> updateLoadingState(
    Map<String, bool> currentState,
    String key,
    bool isLoading,
  ) {
    final newState = Map<String, bool>.from(currentState);
    newState[key] = isLoading;
    return newState;
  }

  /// Check if critical data is loaded
  bool isCriticalDataLoaded(Map<String, bool> loadingStates) {
    return !loadingStates['categories']! && !loadingStates['recentDocuments']!;
  }

  /// Get loading progress percentage
  double getLoadingProgress(Map<String, bool> loadingStates) {
    final totalStates = loadingStates.length;
    final loadedStates = loadingStates.values.where((isLoading) => !isLoading).length;
    return loadedStates / totalStates;
  }
}
