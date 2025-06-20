import 'package:flutter_test/flutter_test.dart';
import 'package:managementdoc/services/statistics_notification_service.dart';

void main() {
  group('StatisticsNotificationService Tests', () {
    late StatisticsNotificationService service;

    setUp(() {
      service = StatisticsNotificationService.instance;
    });

    tearDown(() {
      // Clean up any subscriptions
      service.dispose();
    });

    test('should be a singleton', () {
      final service1 = StatisticsNotificationService.instance;
      final service2 = StatisticsNotificationService.instance;
      expect(service1, same(service2));
    });

    test('should notify file deletion correctly', () async {
      // Arrange
      final List<StatisticsUpdateEvent> receivedEvents = [];
      final List<FileCountUpdateEvent> receivedFileEvents = [];

      final statisticsSubscription = service.statisticsUpdates.listen((event) {
        receivedEvents.add(event);
      });

      final fileCountSubscription = service.fileCountUpdates.listen((event) {
        receivedFileEvents.add(event);
      });

      // Act
      service.notifyFileDeleted(
        fileId: 'test-file-id',
        fileName: 'test-file.pdf',
        category: 'documents',
        fileSize: 1024,
      );

      // Wait for events to be processed
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(receivedEvents.length, 1);
      expect(receivedEvents.first.type, StatisticsUpdateType.fileDeleted);
      expect(receivedEvents.first.data['fileName'], 'test-file.pdf');

      expect(receivedFileEvents.length, 1);
      expect(receivedFileEvents.first.type, FileCountUpdateType.deleted);
      expect(receivedFileEvents.first.fileName, 'test-file.pdf');

      // Clean up
      await statisticsSubscription.cancel();
      await fileCountSubscription.cancel();
    });

    test('should notify file upload correctly', () async {
      // Arrange
      final List<StatisticsUpdateEvent> receivedEvents = [];
      final List<FileCountUpdateEvent> receivedFileEvents = [];

      final statisticsSubscription = service.statisticsUpdates.listen((event) {
        receivedEvents.add(event);
      });

      final fileCountSubscription = service.fileCountUpdates.listen((event) {
        receivedFileEvents.add(event);
      });

      // Act
      service.notifyFileUploaded(
        fileId: 'test-upload-id',
        fileName: 'uploaded-file.docx',
        category: 'reports',
        fileSize: 2048,
      );

      // Wait for events to be processed
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(receivedEvents.length, 1);
      expect(receivedEvents.first.type, StatisticsUpdateType.fileUploaded);
      expect(receivedEvents.first.data['fileName'], 'uploaded-file.docx');

      expect(receivedFileEvents.length, 1);
      expect(receivedFileEvents.first.type, FileCountUpdateType.added);
      expect(receivedFileEvents.first.fileName, 'uploaded-file.docx');

      // Clean up
      await statisticsSubscription.cancel();
      await fileCountSubscription.cancel();
    });

    test('should handle storage statistics updates', () async {
      // Arrange
      final List<StorageStatsUpdateEvent> receivedStorageEvents = [];
      final List<StatisticsUpdateEvent> receivedEvents = [];

      final storageSubscription = service.storageStatsUpdates.listen((event) {
        receivedStorageEvents.add(event);
      });

      final statisticsSubscription = service.statisticsUpdates.listen((event) {
        receivedEvents.add(event);
      });

      final testStats = {
        'totalFiles': 42,
        'totalSize': 1024000,
        'recentFiles': 5,
      };

      // Act
      service.notifyStorageStatsUpdate(testStats);

      // Wait for events to be processed
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(receivedStorageEvents.length, 1);
      expect(receivedStorageEvents.first.stats['totalFiles'], 42);

      expect(receivedEvents.length, 1);
      expect(receivedEvents.first.type, StatisticsUpdateType.storageStatsRefreshed);

      // Test cached stats
      final cachedStats = service.getCachedStorageStats();
      expect(cachedStats, isNotNull);
      expect(cachedStats!['totalFiles'], 42);

      // Clean up
      await storageSubscription.cancel();
      await statisticsSubscription.cancel();
    });

    test('should invalidate cache correctly', () {
      // Arrange
      final testStats = {
        'totalFiles': 10,
        'totalSize': 500000,
      };

      // Act
      service.notifyStorageStatsUpdate(testStats);
      expect(service.hasCachedStats, true);

      service.notifyFileDeleted(
        fileId: 'test-id',
        fileName: 'test.pdf',
        category: 'test',
        fileSize: 1000,
      );

      // Assert - cache should be invalidated after file deletion
      expect(service.hasCachedStats, false);
    });

    test('should request statistics refresh', () async {
      // Arrange
      final List<StatisticsUpdateEvent> receivedEvents = [];

      final subscription = service.statisticsUpdates.listen((event) {
        receivedEvents.add(event);
      });

      // Act
      service.requestStatisticsRefresh(reason: 'Manual test refresh');

      // Wait for events to be processed
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(receivedEvents.length, 1);
      expect(receivedEvents.first.type, StatisticsUpdateType.refreshRequested);
      expect(receivedEvents.first.data['reason'], 'Manual test refresh');

      // Clean up
      await subscription.cancel();
    });

    test('should handle multiple rapid events', () async {
      // Arrange
      final List<StatisticsUpdateEvent> receivedEvents = [];

      final subscription = service.statisticsUpdates.listen((event) {
        receivedEvents.add(event);
      });

      // Act - Send multiple events rapidly
      for (int i = 0; i < 5; i++) {
        service.notifyFileDeleted(
          fileId: 'file-$i',
          fileName: 'file-$i.pdf',
          category: 'test',
          fileSize: 1000 + i,
        );
      }

      // Wait for all events to be processed
      await Future.delayed(const Duration(milliseconds: 200));

      // Assert
      expect(receivedEvents.length, 5);
      for (int i = 0; i < 5; i++) {
        expect(receivedEvents[i].type, StatisticsUpdateType.fileDeleted);
        expect(receivedEvents[i].data['fileName'], 'file-$i.pdf');
      }

      // Clean up
      await subscription.cancel();
    });
  });
}
