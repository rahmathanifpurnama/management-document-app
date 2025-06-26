import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'package:management_document_app/services/optimized_statistics_service.dart';
import 'package:management_document_app/core/services/firebase_service.dart';

// Generate mocks
@GenerateMocks([
  FirebaseService,
  FirebaseFunctions,
  HttpsCallable,
  HttpsCallableResult,
])
import 'optimized_statistics_service_test.mocks.dart';

void main() {
  group('OptimizedStatisticsService Tests', () {
    late OptimizedStatisticsService service;
    late MockFirebaseService mockFirebaseService;
    late MockFirebaseFunctions mockFunctions;
    late MockHttpsCallable mockCallable;
    late MockHttpsCallableResult mockResult;

    setUp(() {
      mockFirebaseService = MockFirebaseService();
      mockFunctions = MockFirebaseFunctions();
      mockCallable = MockHttpsCallable();
      mockResult = MockHttpsCallableResult();
      
      // Setup mock chain
      when(mockFirebaseService.functions).thenReturn(mockFunctions);
      when(mockFunctions.httpsCallable('getAggregatedStatistics')).thenReturn(mockCallable);
      
      service = OptimizedStatisticsService.instance;
    });

    group('Aggregated Statistics', () {
      test('should return cached statistics when available', () async {
        // Arrange
        final mockStats = {
          'totalFiles': 1000000,
          'activeUsers': 5000,
          'totalCategories': 100,
          'recentFiles': 50000,
          'fileTypeStats': {'pdf': 400000, 'docx': 300000, 'xlsx': 300000},
          'totalStorageSize': 1073741824000, // 1TB
        };
        
        when(mockResult.data).thenReturn(mockStats);
        when(mockCallable.call()).thenAnswer((_) async => mockResult);

        // Act
        final result1 = await service.getAggregatedStatistics();
        final result2 = await service.getAggregatedStatistics(); // Should use cache

        // Assert
        expect(result1, equals(mockStats));
        expect(result2, equals(mockStats));
        verify(mockCallable.call()).called(1); // Only called once due to caching
      });

      test('should handle large numbers correctly', () async {
        // Arrange - Test with 10 million files
        final mockStats = {
          'totalFiles': 10000000,
          'activeUsers': 50000,
          'totalCategories': 1000,
          'recentFiles': 500000,
          'fileTypeStats': {
            'pdf': 4000000,
            'docx': 3000000,
            'xlsx': 2000000,
            'pptx': 1000000,
          },
          'totalStorageSize': 10737418240000, // 10TB
        };
        
        when(mockResult.data).thenReturn(mockStats);
        when(mockCallable.call()).thenAnswer((_) async => mockResult);

        // Act
        final result = await service.getAggregatedStatistics();

        // Assert
        expect(result['totalFiles'], equals(10000000));
        expect(result['totalStorageSize'], equals(10737418240000));
        expect(result['fileTypeStats']['pdf'], equals(4000000));
      });

      test('should force refresh when requested', () async {
        // Arrange
        final mockStats = {'totalFiles': 1000};
        when(mockResult.data).thenReturn(mockStats);
        when(mockCallable.call()).thenAnswer((_) async => mockResult);

        // Act
        await service.getAggregatedStatistics(); // First call
        await service.getAggregatedStatistics(forceRefresh: true); // Force refresh

        // Assert
        verify(mockCallable.call()).called(2); // Called twice due to force refresh
      });

      test('should return fallback data on error', () async {
        // Arrange
        when(mockCallable.call()).thenThrow(Exception('Network error'));

        // Act
        final result = await service.getAggregatedStatistics();

        // Assert
        expect(result['totalFiles'], equals(0));
        expect(result['activeUsers'], equals(0));
        expect(result['totalCategories'], equals(0));
      });
    });

    group('Paginated Statistics', () {
      test('should handle large pagination correctly', () async {
        // Arrange
        final mockPaginatedData = {
          'files': List.generate(50, (index) => {
            'id': 'file_$index',
            'fileName': 'document_$index.pdf',
            'fileSize': 1024 * 1024, // 1MB each
            'fileType': 'pdf',
            'category': 'documents',
            'uploadedAt': DateTime.now().subtract(Duration(days: index)).toIso8601String(),
            'uploadedBy': 'user_${index % 10}',
          }),
          'pagination': {
            'page': 1,
            'limit': 50,
            'total': 1000000, // 1 million total files
            'totalPages': 20000,
            'hasNext': true,
            'hasPrev': false,
          },
        };

        when(mockFunctions.httpsCallable('getPaginatedFileStats')).thenReturn(mockCallable);
        when(mockResult.data).thenReturn(mockPaginatedData);
        when(mockCallable.call(any)).thenAnswer((_) async => mockResult);

        // Act
        final result = await service.getPaginatedFileStats(page: 1, limit: 50);

        // Assert
        expect(result.files.length, equals(50));
        expect(result.pagination.total, equals(1000000));
        expect(result.pagination.totalPages, equals(20000));
        expect(result.pagination.hasNext, isTrue);
      });

      test('should handle filtering with large datasets', () async {
        // Arrange
        final mockFilteredData = {
          'files': List.generate(25, (index) => {
            'id': 'pdf_file_$index',
            'fileName': 'document_$index.pdf',
            'fileSize': 2048 * 1024, // 2MB each
            'fileType': 'pdf',
            'category': 'reports',
            'uploadedAt': DateTime.now().subtract(Duration(hours: index)).toIso8601String(),
            'uploadedBy': 'user_${index % 5}',
          }),
          'pagination': {
            'page': 1,
            'limit': 50,
            'total': 500000, // 500k PDF files
            'totalPages': 10000,
            'hasNext': true,
            'hasPrev': false,
          },
        };

        when(mockFunctions.httpsCallable('getPaginatedFileStats')).thenReturn(mockCallable);
        when(mockResult.data).thenReturn(mockFilteredData);
        when(mockCallable.call(any)).thenAnswer((_) async => mockResult);

        // Act
        final result = await service.getPaginatedFileStats(
          page: 1,
          limit: 50,
          fileType: 'pdf',
          category: 'reports',
        );

        // Assert
        expect(result.files.length, equals(25));
        expect(result.pagination.total, equals(500000));
        expect(result.files.every((file) => file.fileType == 'pdf'), isTrue);
      });
    });

    group('Cache Management', () {
      test('should invalidate cache correctly', () async {
        // Arrange
        final mockStats = {'totalFiles': 1000};
        when(mockResult.data).thenReturn(mockStats);
        when(mockCallable.call()).thenAnswer((_) async => mockResult);
        when(mockFunctions.httpsCallable('invalidateStatisticsCache')).thenReturn(mockCallable);

        // Act
        await service.getAggregatedStatistics(); // Cache data
        await service.invalidateCache(reason: 'Test invalidation');
        await service.getAggregatedStatistics(); // Should fetch fresh data

        // Assert
        verify(mockCallable.call()).called(greaterThan(1));
      });

      test('should handle cache expiration', () async {
        // This test would require time manipulation or dependency injection
        // for the cache duration. For now, we test the basic functionality.
        
        // Arrange
        final mockStats = {'totalFiles': 1000};
        when(mockResult.data).thenReturn(mockStats);
        when(mockCallable.call()).thenAnswer((_) async => mockResult);

        // Act
        final result1 = await service.getAggregatedStatistics();
        final result2 = await service.getAggregatedStatistics();

        // Assert
        expect(result1, equals(result2));
        verify(mockCallable.call()).called(1); // Cached result used
      });
    });

    group('Statistics Stream', () {
      test('should emit statistics through stream', () async {
        // Arrange
        final mockStats = {'totalFiles': 1000};
        when(mockResult.data).thenReturn(mockStats);
        when(mockCallable.call()).thenAnswer((_) async => mockResult);

        // Act & Assert
        expectLater(
          service.getStatisticsStream(),
          emits(mockStats),
        );
      });
    });

    group('Performance Tests', () {
      test('should handle concurrent requests efficiently', () async {
        // Arrange
        final mockStats = {'totalFiles': 1000000};
        when(mockResult.data).thenReturn(mockStats);
        when(mockCallable.call()).thenAnswer((_) async {
          // Simulate network delay
          await Future.delayed(Duration(milliseconds: 100));
          return mockResult;
        });

        // Act - Make 10 concurrent requests
        final futures = List.generate(10, (_) => service.getAggregatedStatistics());
        final results = await Future.wait(futures);

        // Assert
        expect(results.length, equals(10));
        expect(results.every((result) => result['totalFiles'] == 1000000), isTrue);
        // Should only make one actual call due to caching
        verify(mockCallable.call()).called(1);
      });

      test('should format large numbers correctly', () {
        // Test StatConfig.formatLargeNumber
        expect(StatConfig.formatLargeNumber(999), equals('999'));
        expect(StatConfig.formatLargeNumber(1000), equals('1.0K'));
        expect(StatConfig.formatLargeNumber(1500), equals('1.5K'));
        expect(StatConfig.formatLargeNumber(1000000), equals('1.0M'));
        expect(StatConfig.formatLargeNumber(1500000), equals('1.5M'));
        expect(StatConfig.formatLargeNumber(1000000000), equals('1.0B'));
        expect(StatConfig.formatLargeNumber(1500000000), equals('1.5B'));
      });

      test('should format file sizes correctly', () {
        // Test StatConfig.formatFileSize
        expect(StatConfig.formatFileSize(512), equals('512 B'));
        expect(StatConfig.formatFileSize(1024), equals('1.0 KB'));
        expect(StatConfig.formatFileSize(1536), equals('1.5 KB'));
        expect(StatConfig.formatFileSize(1048576), equals('1.0 MB'));
        expect(StatConfig.formatFileSize(1572864), equals('1.5 MB'));
        expect(StatConfig.formatFileSize(1073741824), equals('1.0 GB'));
        expect(StatConfig.formatFileSize(1610612736), equals('1.5 GB'));
      });
    });

    tearDown(() {
      service.dispose();
    });
  });
}
