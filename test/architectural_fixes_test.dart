import 'package:flutter_test/flutter_test.dart';
import 'package:managementdoc/services/document_state_manager.dart';
import 'package:managementdoc/models/document_model.dart';

void main() {
  group('Architectural Fixes Tests', () {
    late DocumentStateManager stateManager;

    setUp(() {
      stateManager = DocumentStateManager.instance;
      stateManager.clearData(); // Start with clean state
    });

    tearDown(() {
      stateManager.clearData();
    });

    test('DocumentStateManager should prevent concurrent refresh operations', () async {
      // Start first refresh
      final future1 = stateManager.refreshDocuments();

      // Try to start second refresh immediately
      final future2 = stateManager.refreshDocuments();

      // Both should complete without error
      await Future.wait([future1, future2]);

      // Should not crash or cause race conditions
      expect(stateManager.documents, isA<List<DocumentModel>>());
    });

    test('DocumentStateManager should provide correct cache status', () {
      final status = stateManager.getCacheStatus();

      expect(status, isA<Map<String, dynamic>>());
      expect(status.containsKey('documentCount'), isTrue);
      expect(status.containsKey('lastRefresh'), isTrue);
      expect(status.containsKey('cacheValid'), isTrue);
      expect(status.containsKey('isRefreshing'), isTrue);
      expect(status['documentCount'], equals(0)); // Should start empty
      expect(status['isRefreshing'], equals(false)); // Should not be refreshing initially
    });

    test('DocumentStateManager should handle empty state correctly', () {
      // Initially should be empty
      expect(stateManager.documents.length, equals(0));

      // Recent documents should also be empty
      final recentDocs = stateManager.getRecentDocuments(limit: 10);
      expect(recentDocs.length, equals(0));

      // Cache should be invalid initially
      final status = stateManager.getCacheStatus();
      expect(status['cacheValid'], equals(false));
    });

    test('DocumentStateManager should handle refresh without errors', () async {
      // Should be able to refresh even with empty state
      await stateManager.refreshDocuments();

      // Should still be empty after refresh (no actual Firebase connection in test)
      expect(stateManager.documents.length, equals(0));

      // Cache status should be updated
      final status = stateManager.getCacheStatus();
      expect(status['isRefreshing'], equals(false));
    });

    test('DocumentStateManager should handle getRecentDocuments with limits', () {
      // Should handle empty state
      final recentDocs = stateManager.getRecentDocuments(limit: 10);
      expect(recentDocs.length, equals(0));
      
      // Should handle different limits
      final recentDocs50 = stateManager.getRecentDocuments(limit: 50);
      expect(recentDocs50.length, equals(0));
    });

    test('DocumentStateManager should handle document operations safely', () {
      // Should handle remove on empty state
      stateManager.removeDocument('non_existent');
      expect(stateManager.documents.length, equals(0));
      
      // Should handle clear data
      stateManager.clearData();
      expect(stateManager.documents.length, equals(0));
      
      final status = stateManager.getCacheStatus();
      expect(status['documentCount'], equals(0));
    });

    test('DocumentStateManager singleton should work correctly', () {
      // Should return same instance
      final instance1 = DocumentStateManager.instance;
      final instance2 = DocumentStateManager.instance;
      
      expect(identical(instance1, instance2), isTrue);
    });

    test('DocumentStateManager should handle stream correctly', () {
      // Should have a valid stream
      expect(stateManager.documentsStream, isA<Stream<List<DocumentModel>>>());
      
      // Stream should be broadcast
      final subscription1 = stateManager.documentsStream.listen((_) {});
      final subscription2 = stateManager.documentsStream.listen((_) {});
      
      // Should not throw error for multiple listeners
      expect(() {
        subscription1.cancel();
        subscription2.cancel();
      }, returnsNormally);
    });
  });
}
