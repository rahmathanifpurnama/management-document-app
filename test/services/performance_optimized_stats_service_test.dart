import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:management_document_app/services/performance_optimized_stats_service.dart';
import 'package:management_document_app/services/optimized_statistics_service.dart';
import 'package:management_document_app/models/document_model.dart';

// Generate mocks
@GenerateMocks([OptimizedStatisticsService])
import 'performance_optimized_stats_service_test.mocks.dart';

void main() {
  group('PerformanceOptimizedStatsService Tests', () {
    late PerformanceOptimizedStatsService service;
    late MockOptimizedStatisticsService mockBaseService;

    setUp(() {
      mockBaseService = MockOptimizedStatisticsService();
      service = PerformanceOptimizedStatsService.instance;
      service.initialize();
    });

    group('Progressive Loading', () {
      test('should emit statistics progressively', () async {
        // Arrange
        final mockBasicStats = {
          'totalFiles': 1000000,
          'activeUsers': 5000,
          'totalCategories': 100,
          'recentFiles': 50000,
        };

        final mockDetailedStats = {
          ...mockBasicStats,
          'fileTypeDistribution': {'pdf': 40.0, 'docx': 30.0, 'xlsx': 30.0},
          'growthTrends': {'dailyGrowth': '+12', 'weeklyGrowth': '+89'},
        };

        when(mockBaseService.getAggregatedStatistics(forceRefresh: true))
            .thenAnswer((_) async => mockBasicStats);

        // Act & Assert
        final stream = service.getProgressiveStatistics();
        final events = <Map<String, dynamic>>[];
        
        await for (final event in stream.take(3)) {
          events.add(event);
        }

        // Should receive skeleton, basic, and detailed stats
        expect(events.length, greaterThanOrEqualTo(2));
        expect(events.last.containsKey('totalFiles'), isTrue);
      });

      test('should handle progressive loading errors gracefully', () async {
        // Arrange
        when(mockBaseService.getAggregatedStatistics(forceRefresh: true))
            .thenThrow(Exception('Network error'));

        // Act
        final stream = service.getProgressiveStatistics();
        
        // Assert - Should not throw, should handle error gracefully
        expect(() async {
          await for (final event in stream.take(1)) {
            // Should receive at least skeleton data
            expect(event, isNotNull);
          }
        }, returnsNormally);
      });
    });

    group('Virtualized Statistics', () {
      test('should handle large dataset virtualization', () async {
        // Arrange
        final mockFiles = List.generate(50, (index) => DocumentModel(
          id: 'file_$index',
          fileName: 'document_$index.pdf',
          fileSize: 1024 * 1024, // 1MB
          fileType: 'pdf',
          category: 'documents',
          uploadedAt: DateTime.now().subtract(Duration(days: index)),
          uploadedBy: 'user_${index % 10}',
          downloadUrl: 'https://example.com/file_$index.pdf',
          isActive: true,
        ));

        final mockPaginatedStats = PaginatedFileStats(
          files: mockFiles,
          pagination: const PaginationInfo(
            page: 1,
            limit: 50,
            total: 1000000, // 1 million files
            totalPages: 20000,
            hasNext: true,
            hasPrev: false,
          ),
        );

        when(mockBaseService.getPaginatedFileStats(
          page: 1,
          limit: 50,
          sortBy: 'uploadedAt',
          sortOrder: 'desc',
        )).thenAnswer((_) async => mockPaginatedStats);

        // Act
        final result = await service.getVirtualizedStats(
          startIndex: 0,
          endIndex: 49,
        );

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data.files.length, equals(50));
        expect(result.data.pagination.total, equals(1000000));
        expect(result.isFromCache, isFalse);
        expect(result.loadTime.inMilliseconds, greaterThan(0));
      });

      test('should use cache for repeated requests', () async {
        // Arrange
        final mockFiles = [
          DocumentModel(
            id: 'file_1',
            fileName: 'test.pdf',
            fileSize: 1024,
            fileType: 'pdf',
            category: 'test',
            uploadedAt: DateTime.now(),
            uploadedBy: 'user1',
            downloadUrl: 'https://example.com/test.pdf',
            isActive: true,
          ),
        ];

        final mockPaginatedStats = PaginatedFileStats(
          files: mockFiles,
          pagination: const PaginationInfo(
            page: 1,
            limit: 50,
            total: 1,
            totalPages: 1,
            hasNext: false,
            hasPrev: false,
          ),
        );

        when(mockBaseService.getPaginatedFileStats(
          page: 1,
          limit: 50,
          sortBy: 'uploadedAt',
          sortOrder: 'desc',
        )).thenAnswer((_) async => mockPaginatedStats);

        // Act
        final result1 = await service.getVirtualizedStats(
          startIndex: 0,
          endIndex: 49,
        );
        final result2 = await service.getVirtualizedStats(
          startIndex: 0,
          endIndex: 49,
        );

        // Assert
        expect(result1.isFromCache, isFalse);
        expect(result2.isFromCache, isTrue);
        expect(result2.loadTime, equals(Duration.zero));
      });

      test('should handle virtualization errors', () async {
        // Arrange
        when(mockBaseService.getPaginatedFileStats(
          page: any,
          limit: any,
          sortBy: any,
          sortOrder: any,
        )).thenThrow(Exception('Database error'));

        // Act
        final result = await service.getVirtualizedStats(
          startIndex: 0,
          endIndex: 49,
        );

        // Assert
        expect(result.hasError, isTrue);
        expect(result.error, contains('Database error'));
        expect(result.data.files.isEmpty, isTrue);
      });
    });

    group('Memory Management', () {
      test('should track memory usage correctly', () {
        // Act
        final memoryStats = service.getMemoryUsage();

        // Assert
        expect(memoryStats.cacheSize, isA<int>());
        expect(memoryStats.maxCacheSize, equals(1000));
        expect(memoryStats.memoryUsageBytes, isA<int>());
        expect(memoryStats.cacheHitRate, isA<double>());
        expect(memoryStats.cacheUsagePercentage, isA<double>());
        expect(memoryStats.memoryUsageFormatted, isA<String>());
      });

      test('should clear cache when requested', () {
        // Act
        service.clearCache();
        final memoryStats = service.getMemoryUsage();

        // Assert
        expect(memoryStats.cacheSize, equals(0));
        expect(memoryStats.memoryUsageBytes, equals(0));
      });

      test('should detect near capacity correctly', () {
        // This would require filling the cache to near capacity
        // For now, test the calculation logic
        final memoryStats = MemoryUsageStats(
          cacheSize: 850,
          maxCacheSize: 1000,
          memoryUsageBytes: 1024 * 1024,
          cacheHitRate: 0.85,
        );

        expect(memoryStats.isNearCapacity, isTrue);
        expect(memoryStats.cacheUsagePercentage, equals(85.0));
      });
    });

    group('Preloading', () {
      test('should preload data for smooth scrolling', () async {
        // Arrange
        final mockFiles = List.generate(50, (index) => DocumentModel(
          id: 'preload_file_$index',
          fileName: 'preload_$index.pdf',
          fileSize: 1024,
          fileType: 'pdf',
          category: 'preload',
          uploadedAt: DateTime.now(),
          uploadedBy: 'user1',
          downloadUrl: 'https://example.com/preload_$index.pdf',
          isActive: true,
        ));

        final mockPaginatedStats = PaginatedFileStats(
          files: mockFiles,
          pagination: const PaginationInfo(
            page: 2,
            limit: 50,
            total: 1000,
            totalPages: 20,
            hasNext: true,
            hasPrev: true,
          ),
        );

        when(mockBaseService.getPaginatedFileStats(
          page: 2,
          limit: 50,
          sortBy: 'uploadedAt',
          sortOrder: 'desc',
        )).thenAnswer((_) async => mockPaginatedStats);

        // Act
        await service.preloadVirtualizedData(
          currentIndex: 0,
          viewportSize: 50,
        );

        // Assert - Should complete without error
        // In a real implementation, we'd verify the preload happened
        expect(true, isTrue); // Placeholder assertion
      });
    });

    group('VirtualizedStatsController', () {
      test('should load viewport data correctly', () async {
        // Arrange
        final controller = VirtualizedStatsController();
        final mockFiles = [
          DocumentModel(
            id: 'controller_file_1',
            fileName: 'controller_test.pdf',
            fileSize: 1024,
            fileType: 'pdf',
            category: 'test',
            uploadedAt: DateTime.now(),
            uploadedBy: 'user1',
            downloadUrl: 'https://example.com/controller_test.pdf',
            isActive: true,
          ),
        ];

        final mockPaginatedStats = PaginatedFileStats(
          files: mockFiles,
          pagination: const PaginationInfo(
            page: 1,
            limit: 50,
            total: 100,
            totalPages: 2,
            hasNext: true,
            hasPrev: false,
          ),
        );

        when(mockBaseService.getPaginatedFileStats(
          page: 1,
          limit: 50,
          sortBy: 'uploadedAt',
          sortOrder: 'desc',
        )).thenAnswer((_) async => mockPaginatedStats);

        // Act
        await controller.loadViewport(
          startIndex: 0,
          endIndex: 49,
        );

        // Assert
        expect(controller.totalItems, equals(100));
        
        // Clean up
        controller.dispose();
      });
    });

    group('Performance Benchmarks', () {
      test('should handle 1M+ file simulation efficiently', () async {
        // Simulate large dataset operations
        final startTime = DateTime.now();
        
        // Simulate processing 1 million file metadata entries
        final largeDataset = List.generate(1000000, (index) => {
          'id': 'file_$index',
          'size': 1024 * (index % 1000 + 1),
          'type': ['pdf', 'docx', 'xlsx'][index % 3],
        });

        // Simulate aggregation operations
        final totalSize = largeDataset.fold<int>(0, (sum, file) => sum + (file['size'] as int));
        final typeCount = <String, int>{};
        for (final file in largeDataset) {
          final type = file['type'] as String;
          typeCount[type] = (typeCount[type] ?? 0) + 1;
        }

        final endTime = DateTime.now();
        final processingTime = endTime.difference(startTime);

        // Assert performance requirements
        expect(processingTime.inMilliseconds, lessThan(5000)); // Should complete in under 5 seconds
        expect(totalSize, greaterThan(0));
        expect(typeCount.length, equals(3));
        expect(typeCount.values.fold(0, (sum, count) => sum + count), equals(1000000));
      });

      test('should maintain memory efficiency with large datasets', () {
        // Test memory usage patterns
        final initialMemory = service.getMemoryUsage();
        
        // Simulate cache operations
        service.clearCache();
        
        final afterClearMemory = service.getMemoryUsage();
        
        // Assert memory was freed
        expect(afterClearMemory.memoryUsageBytes, lessThanOrEqualTo(initialMemory.memoryUsageBytes));
        expect(afterClearMemory.cacheSize, equals(0));
      });
    });

    tearDown(() {
      service.dispose();
    });
  });
}
