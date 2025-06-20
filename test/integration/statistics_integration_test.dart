import 'package:flutter_test/flutter_test.dart';
import 'package:managementdoc/services/statistics_notification_service.dart';

void main() {
  group('Statistics Integration Tests', () {
    late StatisticsNotificationService statisticsService;

    setUp(() {
      statisticsService = StatisticsNotificationService.instance;
    });

    tearDown(() {
      statisticsService.dispose();
    });

    test('should integrate file deletion with statistics updates', () async {
      // Arrange
      final List<StatisticsUpdateEvent> receivedEvents = [];
      final subscription = statisticsService.statisticsUpdates.listen((event) {
        receivedEvents.add(event);
      });

      // Act - Simulate file deletion (this would normally be called by DocumentProvider)
      statisticsService.notifyFileDeleted(
        fileId: 'integration-test-file',
        fileName: 'integration-test.pdf',
        category: 'test-documents',
        fileSize: 1024,
      );

      // Wait for event processing
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(receivedEvents.length, 1);
      expect(receivedEvents.first.type, StatisticsUpdateType.fileDeleted);
      expect(receivedEvents.first.data['fileName'], 'integration-test.pdf');
      expect(receivedEvents.first.data['category'], 'test-documents');
      expect(receivedEvents.first.data['fileSize'], 1024);

      // Verify cache invalidation
      expect(statisticsService.hasCachedStats, false);

      // Clean up
      await subscription.cancel();
    });

    test('should integrate file upload with statistics updates', () async {
      // Arrange
      final List<StatisticsUpdateEvent> receivedEvents = [];
      final subscription = statisticsService.statisticsUpdates.listen((event) {
        receivedEvents.add(event);
      });

      // Act - Simulate file upload (this would normally be called by upload providers)
      statisticsService.notifyFileUploaded(
        fileId: 'integration-upload-file',
        fileName: 'integration-upload.docx',
        category: 'reports',
        fileSize: 2048,
      );

      // Wait for event processing
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(receivedEvents.length, 1);
      expect(receivedEvents.first.type, StatisticsUpdateType.fileUploaded);
      expect(receivedEvents.first.data['fileName'], 'integration-upload.docx');
      expect(receivedEvents.first.data['category'], 'reports');
      expect(receivedEvents.first.data['fileSize'], 2048);

      // Verify cache invalidation
      expect(statisticsService.hasCachedStats, false);

      // Clean up
      await subscription.cancel();
    });

    test('should handle complete file lifecycle with statistics', () async {
      // Arrange
      final List<StatisticsUpdateEvent> receivedEvents = [];
      final subscription = statisticsService.statisticsUpdates.listen((event) {
        receivedEvents.add(event);
      });

      // Act - Simulate complete file lifecycle
      
      // 1. File upload
      statisticsService.notifyFileUploaded(
        fileId: 'lifecycle-file',
        fileName: 'lifecycle-test.pdf',
        category: 'documents',
        fileSize: 1500,
      );

      await Future.delayed(const Duration(milliseconds: 50));

      // 2. Storage stats update
      statisticsService.notifyStorageStatsUpdate({
        'totalFiles': 10,
        'recentFiles': 3,
        'totalSize': 15000,
      });

      await Future.delayed(const Duration(milliseconds: 50));

      // 3. File deletion
      statisticsService.notifyFileDeleted(
        fileId: 'lifecycle-file',
        fileName: 'lifecycle-test.pdf',
        category: 'documents',
        fileSize: 1500,
      );

      // Wait for all events to be processed
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(receivedEvents.length, 3);
      
      // Check upload event
      expect(receivedEvents[0].type, StatisticsUpdateType.fileUploaded);
      expect(receivedEvents[0].data['fileName'], 'lifecycle-test.pdf');
      
      // Check storage stats event
      expect(receivedEvents[1].type, StatisticsUpdateType.storageStatsRefreshed);
      expect(receivedEvents[1].data['totalFiles'], 10);
      
      // Check deletion event
      expect(receivedEvents[2].type, StatisticsUpdateType.fileDeleted);
      expect(receivedEvents[2].data['fileName'], 'lifecycle-test.pdf');

      // Clean up
      await subscription.cancel();
    });

    test('should handle concurrent statistics operations', () async {
      // Arrange
      final List<StatisticsUpdateEvent> receivedEvents = [];
      final subscription = statisticsService.statisticsUpdates.listen((event) {
        receivedEvents.add(event);
      });

      // Act - Simulate concurrent operations
      final futures = <Future>[];
      
      for (int i = 0; i < 3; i++) {
        futures.add(Future(() {
          statisticsService.notifyFileUploaded(
            fileId: 'concurrent-upload-$i',
            fileName: 'concurrent-upload-$i.pdf',
            category: 'test',
            fileSize: 1000 + i,
          );
        }));
      }

      for (int i = 0; i < 2; i++) {
        futures.add(Future(() {
          statisticsService.notifyFileDeleted(
            fileId: 'concurrent-delete-$i',
            fileName: 'concurrent-delete-$i.pdf',
            category: 'test',
            fileSize: 500 + i,
          );
        }));
      }

      // Wait for all concurrent operations
      await Future.wait(futures);
      await Future.delayed(const Duration(milliseconds: 200));

      // Assert
      expect(receivedEvents.length, 5); // 3 uploads + 2 deletions
      
      final uploadEvents = receivedEvents.where((e) => e.type == StatisticsUpdateType.fileUploaded).toList();
      final deleteEvents = receivedEvents.where((e) => e.type == StatisticsUpdateType.fileDeleted).toList();
      
      expect(uploadEvents.length, 3);
      expect(deleteEvents.length, 2);

      // Clean up
      await subscription.cancel();
    });

    test('should maintain event order and integrity', () async {
      // Arrange
      final List<StatisticsUpdateEvent> receivedEvents = [];
      final subscription = statisticsService.statisticsUpdates.listen((event) {
        receivedEvents.add(event);
      });

      // Act - Send events in specific order
      statisticsService.notifyFileUploaded(
        fileId: 'order-test-1',
        fileName: 'first.pdf',
        category: 'test',
        fileSize: 1000,
      );

      statisticsService.requestStatisticsRefresh(reason: 'Manual refresh');

      statisticsService.notifyFileDeleted(
        fileId: 'order-test-2',
        fileName: 'second.pdf',
        category: 'test',
        fileSize: 2000,
      );

      // Wait for all events
      await Future.delayed(const Duration(milliseconds: 150));

      // Assert
      expect(receivedEvents.length, 3);
      expect(receivedEvents[0].type, StatisticsUpdateType.fileUploaded);
      expect(receivedEvents[1].type, StatisticsUpdateType.refreshRequested);
      expect(receivedEvents[2].type, StatisticsUpdateType.fileDeleted);

      // Verify data integrity
      expect(receivedEvents[0].data['fileName'], 'first.pdf');
      expect(receivedEvents[2].data['fileName'], 'second.pdf');

      // Clean up
      await subscription.cancel();
    });
  });
}
